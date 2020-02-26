-- *********************************************************************
-- Copyright 2019, ON Semiconductor Corporation.
--
-- This software is owned by ON Semiconductor Corporation (ON)
-- and is protected by United States copyright laws and international
-- treaty provisions.  Therefore, you must treat this software like any
-- other copyrighted material (e.g., book, or musical recording), with
-- the exception that one copy may be made for personal use or
-- evaluation.  Reproduction, modification, translation, compilation, or
-- representation of this software in any other form (e.g., paper,
-- magnetic, optical, silicon, etc.) is prohibited without the express
-- written permission of ON.
--
-- Disclaimer: ON makes no warranty of any kind, express or
-- implied, with regard to this material, including, but not limited to,
-- the implied warranties of merchantability and fitness for a particular
-- purpose. ON reserves the right to make changes without further
-- notice to the materials described herein. ON does not assume any
-- liability arising out of the application or use of any product or
-- circuit described herein. ON's products described herein are not
-- authorized for use as components in life-support devices.
--
-- This software is protected by and subject to worldwide patent
-- coverage, including U.S. and foreign patents. Use may be limited by
-- and subject to the ON Software License Agreement.
--
-- *********************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.xgs_model_pkg.all;

entity xgs_sensor_config is
  generic(G_MODEL_ID       : std_logic_vector(15 downto 0) := X"0058";
          G_REV_ID         : std_logic_vector(15 downto 0) := X"0002";
          G_PXL_ARRAY_ROWS : integer := 3072);
  port(
       RESET_B      : in    std_logic;
       EXTCLK       : in    std_logic;
       
       --Register interface
       reg_addr    : in  std_logic_vector(14 downto 0);
       reg_wr      : in  std_logic;
       reg_wr_data : in  std_logic_vector(15 downto 0);
       reg_rd_data : out std_logic_vector(15 downto 0);
       
       --Output to HiSPi module
       bit_clock_period    : out time;
       
       sensor_fsm_state    : out std_logic_vector(4 downto 0);
       
       hispi_if_enable     : out std_logic;
       output_msb_first    : out std_logic;
       hispi_enable_crc    : out std_logic;
       hispi_standby_state : out std_logic;
       hispi_mux_sel       : out std_logic_vector(1 downto 0);
       vert_left_bar_en    : out std_logic;
       hispi_pixel_depth   : out std_logic_vector(2 downto 0); --0x4 = 10bit and 0x5 = 12bit
       blanking_data       : out std_logic_vector(11 downto 0);

       line_time           : out std_logic_vector(15 downto 0);

       --Output to Image module
       slave_triggered_mode: out std_logic;
       frame_length        : out std_logic_vector(15 downto 0);
       roi_size            : out integer range G_PXL_ARRAY_ROWS downto 0;
       ext_emb_data        : out std_logic;
       cmc_patgen_en       : out std_logic;
       active_ctxt         : out std_logic_vector(2 downto 0);
       nested_readout      : out std_logic;
       x_subsampling       : out std_logic;
       y_subsampling       : out std_logic;
       y_reversed          : out std_logic;
       swap_top_bottom     : out std_logic;
       sequencer_enable    : out std_logic;
       frame_count         : in  std_logic_vector(7 downto 0);
       test_pattern_mode   : out std_logic_vector(2 downto 0);
       test_data_red       : out std_logic_vector(12 downto 0);
       test_data_greenr    : out std_logic_vector(12 downto 0);
       test_data_blue      : out std_logic_vector(12 downto 0);
       test_data_greenb    : out std_logic_vector(12 downto 0)
       
      );
end xgs_sensor_config;

architecture behaviour of xgs_sensor_config is

signal register_map       : t_register_map;
signal sensor_state       : std_logic_vector(4 downto 0);
signal cmc_patgen_updt    : std_logic;
signal cmc_patgen_enable  : std_logic;
signal line_rate_gen      : std_logic_vector(12 downto 0) := (others => '0');
signal nb_act_line_gen    : std_logic_vector(12 downto 0) := (others => '0');
signal nb_frame_gen       : std_logic_vector(5 downto 0)  := (others => '0');
signal inter_frame_gen    : std_logic_vector(5 downto 0);
signal frames             : std_logic_vector(7 downto 0);
signal transmit_colmem_tp : std_logic;

begin

REG_READ : process(reg_addr)
begin
  reg_rd_data <= (others => '0');
  if to_integer(unsigned(sensor_state)) >= 3 then
    if reg_addr(14 downto 12) = "011" then
      reg_rd_data <= register_map(to_integer(unsigned(reg_addr(11 downto 1))));
    elsif ('0' & reg_addr) = X"0000" then --alias to address 0x3000
      reg_rd_data <= register_map(0);
    elsif ('0' & reg_addr) = X"0002" then --alias to address 0x31FE"
      reg_rd_data <= register_map(255);
    else
      reg_rd_data <= X"DEAD"; --These registers have not been implemented.
    end if;
  end if;
end process REG_READ;

REG_WRITE : process(reg_addr, reg_wr, RESET_B)
begin
  if RESET_B = '0' then
    register_map <= (others => (others => '0'));
    register_map(0)    <= G_MODEL_ID; --Address 0x3000 - model_id
    register_map(255)  <= G_REV_ID;   --Address 0x31FE - revision_id
    register_map(1024) <= X"0002";    --Address 0x3800 - general_config0
    register_map(1026) <= X"1111";    --Address 0x3804 - contexts_reg
    register_map(1032) <= X"00E6";    --Address 0x3810 - line_time
    register_map(1812) <= X"2507";    --Address 0x3E28 - hispi_control_common
    register_map(1817) <= X"03A6";    --Address 0x3E32 - hispi_blanking_data
  elsif reg_wr = '1' then
    register_map(to_integer(unsigned(reg_addr(11 downto 1)))) <= reg_wr_data;
  end if;
end process REG_WRITE;

SENSOR_FSM_STATE_PROC : process(RESET_B, register_map, sensor_state)
begin
  if RESET_B = '0' then
    sensor_state <= "00000";
  else
    case sensor_state is
      when "00000" =>
        sensor_state <= "00011" after 200 us;
      when "00011" =>
        if register_map(896)(4 downto 2) = "111" then --addr 0x3700
          sensor_state <= "01011" after 500 us;
        end if;
      when "01011" =>
        if register_map(896)(4 downto 2) /= "111" then --addr 0x3700
          sensor_state <= "00011";
        end if;
      when others => 
        null;
    end case;
  end if;
    
end process SENSOR_FSM_STATE_PROC;

LINE_RATE_PROC : process(cmc_patgen_updt, frame_count)
variable pre_value : std_logic;
begin
  if frame_count(5 downto 0) = nb_frame_gen(5 downto 0) then
    transmit_colmem_tp <= '0';
  end if;
  
  if pre_value /= cmc_patgen_updt then
    pre_value := cmc_patgen_updt;
    line_rate_gen    <= register_map(1283)(12 downto 0);
    nb_act_line_gen  <= register_map(1284)(12 downto 0);
    nb_frame_gen     <= register_map(1285)(5 downto 0);
    if register_map(1285)(5 downto 0) /= "000000" then
      transmit_colmem_tp <= '1';
    end if;
  end if;
  
end process LINE_RATE_PROC;

sensor_fsm_state <= sensor_state;

bit_clock_period <= 1.2857 ns;

hispi_if_enable     <= '1' when (to_integer(unsigned(sensor_state)) >= 3) and
                                (register_map(896)(4 downto 2) = "111")   and
                                (register_map(1812)(0) = '1')             else '0';
output_msb_first    <= register_map(1812)(1);           --Address 0x3E28
hispi_enable_crc    <= register_map(1812)(2);           --Address 0x3E28
hispi_standby_state <= register_map(1812)(3);           --Address 0x3E28
hispi_mux_sel       <= register_map(1812)(5 downto 4);  --Address 0x3E28
vert_left_bar_en    <= register_map(1812)(6);           --Address 0x3E28
hispi_pixel_depth   <= register_map(1812)(10 downto 8); --Address 0x3E28

blanking_data       <= register_map(1817)(11 downto 0); --Address 0x3E32

cmc_patgen_enable   <= register_map(1283)(15);
cmc_patgen_en       <= register_map(1283)(15);
cmc_patgen_updt     <= register_map(1285)(15);
inter_frame_gen     <= register_map(1285)(11 downto 6);

line_time           <= register_map(1032) when cmc_patgen_enable = '0' else "000" & line_rate_gen;              --Address 0x3810
  
sequencer_enable    <= '1' when (register_map(1024)(0) = '1' or (cmc_patgen_enable = '1' and transmit_colmem_tp = '1')) and (to_integer(unsigned(sensor_state)) >= 3) else '0';
frames              <= register_map(1024)(15 downto 8) when cmc_patgen_enable = '0' else "00" & nb_frame_gen;
slave_triggered_mode<= '1' when (register_map(1024)(4) = '1' and register_map(1024)(5) = '1') else '0';

frame_length        <= register_map(1053)              when cmc_patgen_enable = '0' else std_logic_vector(to_unsigned(to_integer(unsigned(nb_act_line_gen)) + to_integer(unsigned(inter_frame_gen)) + 1 ,16));
roi_size            <= to_integer(unsigned(register_map(1038)(13 downto 0)))*4 when cmc_patgen_enable = '0' else to_integer(unsigned(nb_act_line_gen)); --in number of lines
ext_emb_data        <= '0';

test_pattern_mode   <= register_map(1799)(2 downto 0);  --Address 0x3E0E
test_data_red       <= register_map(1800)(12 downto 0); --Address 0x3E10
test_data_greenr    <= register_map(1801)(12 downto 0); --Address 0x3E12
test_data_blue      <= register_map(1802)(12 downto 0); --Address 0x3E14
test_data_greenb    <= register_map(1803)(12 downto 0); --Address 0x3E16

swap_top_bottom     <= register_map(1025)(11);
active_ctxt         <= register_map(1026)(2 downto 0); 
nested_readout      <= register_map(1031)(0);
y_reversed          <= register_map(1031)(1);

--TODO : Make it dependent on selected context
--This is fixed to context0 registers
x_subsampling       <= register_map(1054)(0);  
y_subsampling       <= register_map(1054)(3);

end behaviour;
