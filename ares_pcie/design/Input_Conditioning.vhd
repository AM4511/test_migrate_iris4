-----------------------------------------------------------------------
-- $HeadURL: svn://brainstorm/fpga/trunk/Matrox/Imaging/FPGA/InConditioning.vhd$
-- $Author: jmansill $
-- $Revision:  $
-- $Date: 2010-05-25 07:07:15 -0400 (Tue, 25 May 2010) $
--
-- DESCRIPTION: Spider Input Conditioner, filter and debounce logic

-- Step 1) Filter small glitches of less than ~510ns
-- Step 2) Debounce a programmable time. After an edge pases through
--         the debounce filter, any further edge will be suppressed 
--         for the programmed time
-- Step 3) Polarity control
--
--
-- Created by:  Javier Mansilla
-- Date:        30 juillet 2013
-- Project:     Spider GPM
--
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--use work.regfile_spider_lpc_pack.all;
use work.spider_pak.all;

entity Input_Conditioning is
  generic( LPC_PERIOD          : integer :=30);                          -- 30 pour GPM, 40 pour GPM-Atom
  port (
    ---------------------------------------------------------------------
    -- Reset and clock signals
    ---------------------------------------------------------------------
    sys_reset_n                          : in    std_logic;
    sys_clk                              : in    std_logic;
    
    ---------------------------------------------------------------------
    -- Input signal: noisy outside world
    ---------------------------------------------------------------------
    noise_user_data_in                   : in    std_logic_vector;

    ---------------------------------------------------------------------
    -- Output signal: noiseless
    ---------------------------------------------------------------------
    clean_user_data_in                   : out   std_logic_vector;
    
    ---------------------------------------------------------------------
    -- REGISTER 
    ---------------------------------------------------------------------
    regfile                              : inout INPUTCONDITIONING_TYPE := INIT_INPUTCONDITIONING_TYPE
    
     
  );
end Input_Conditioning;


architecture functional of Input_Conditioning is


-----------------------------------------------------
-- signals
-----------------------------------------------------

type NBin_x5_array   is array (noise_user_data_in'range) of std_logic_vector(4 downto 0);
type NBin_x24_array  is array (noise_user_data_in'range) of std_logic_vector(23 downto 0);

signal input_ff1                         : std_logic_vector(noise_user_data_in'range);
signal input_ff2                         : std_logic_vector(noise_user_data_in'range);
signal input_ff3                         : std_logic_vector(noise_user_data_in'range);
signal input_ff4                         : std_logic_vector(noise_user_data_in'range);

signal glitch_cnt                        : NBin_x5_array;
signal glitch_out                        : std_logic_vector(noise_user_data_in'range);
signal glitch_out_p1                     : std_logic_vector(noise_user_data_in'range);

signal debounce_cnt                      : NBin_x24_array;
signal debounce_out                      : std_logic_vector(noise_user_data_in'range);
signal debounce_en                       : std_logic_vector(noise_user_data_in'range);


begin


--Registre de periode
regfile.CAPABILITIES_INCOND.Period_ns <= conv_std_logic_vector(LPC_PERIOD, 8);



-------------------------------------------------------
-- Piping the input signal to synchronise on sys_clk   
-------------------------------------------------------
process(sys_clk)
begin
  if (sys_clk'event and sys_clk='1') then
    for i in noise_user_data_in'range loop
      if(sys_reset_n='0') then
        input_ff1(i) <= '0';
        input_ff2(i) <= '0';
        input_ff3(i) <= '0';
        input_ff4(i) <= '0';
      else
        input_ff1(i) <= noise_user_data_in(i);
        input_ff2(i) <= input_ff1(i);
        input_ff3(i) <= input_ff2(i);
        input_ff4(i) <= input_ff3(i);
      end if;
    end loop;
  end if;
end process;

-------------------------------------------------------
-- 1) Glitch removal, any glitch less than 30x17=510ns will be removed : GPM
-- 1) Glitch removal, any glitch less than 40x13=520ns will be removed : GPM-Atom
-- 1) Glitch removal, any glitch less than 16x32=512ns will be removed : Spider PCIe
-------------------------------------------------------
process(sys_clk)
begin
  if rising_edge(sys_clk) then
    for i in noise_user_data_in'range loop
      if(sys_reset_n='0') then
        glitch_cnt(i)    <= (others => '0');
        glitch_out(i)    <= '0';
      elsif(regfile.InputConditioning(i).InputFiltering='1') then
        -- detection of first rising edge or falling edge: reset counter
        if ((input_ff3(i) = '1' and input_ff4(i) = '0') or (input_ff3(i) = '0' and input_ff4(i) = '1')) then
          glitch_cnt(i) <= (others => '0');
        -- to reduce power, stop counting when reach debounce time
        --GPM dans spartan6
        elsif (glitch_cnt(i) = "10000") and (LPC_PERIOD=30) then      --17 cycles
          glitch_cnt(i)   <= glitch_cnt(i);
          glitch_out(i)   <= input_ff4(i);
        --GPM-ATOM dans A7
        elsif (glitch_cnt(i) = "01100") and (LPC_PERIOD=40) then      --13 cycles
          glitch_cnt(i)   <= glitch_cnt(i);
          glitch_out(i)   <= input_ff4(i);
        --Spider PCIe dans A7
        elsif (glitch_cnt(i) = "11111") and (LPC_PERIOD=16) then      --32 cycles
          glitch_cnt(i)   <= glitch_cnt(i);
          glitch_out(i)   <= input_ff4(i);
        
        -- not detected edge so incrementing counter
        else
          glitch_cnt(i)   <= glitch_cnt(i) + '1';
        end if;
      else
        glitch_out(i) <= input_ff4(i);
      end if;
    end loop;
  end if;    
end process;

process(sys_clk)
begin
  if rising_edge(sys_clk) then
    for i in noise_user_data_in'range loop
      if(sys_reset_n='0') then
        glitch_out_p1(i)    <= '0';
      else
        glitch_out_p1(i)    <= glitch_out(i);
      end if;
    end loop;
  end if;
end process;




-------------------------------------------------------
-- 2) Debounce with programmable time, no delai in the first edge
-------------------------------------------------------
process(sys_clk)
begin
  if rising_edge(sys_clk) then
    for i in noise_user_data_in'range loop
      if(sys_reset_n='0') then
        debounce_cnt(i) <= (others => '0');
        debounce_out(i) <= '0';
        debounce_en(i)  <= '0';
      -- detection of rising edge: reset counter
      elsif (debounce_en(i)='0' and glitch_out(i) = '1' and glitch_out_p1(i) = '0') then  --Rising detected
        debounce_cnt(i) <= (others => '0');
        debounce_en(i)  <= '1';
        debounce_out(i) <= '1';
      -- detection of falling edge: reset counter
      elsif (debounce_en(i)='0' and glitch_out(i) = '0' and glitch_out_p1(i) = '1') then  -- Falling detected
        debounce_cnt(i) <= (others => '0');
        debounce_en(i)  <= '1';
        debounce_out(i) <= '0';
      -- to reduce power, stop counting when reach debounce time
      elsif ((debounce_en(i)= '0') or (debounce_en(i)= '1' and debounce_cnt(i) = regfile.InputConditioning(i).DebounceHoldOff) ) then
        debounce_cnt(i) <= debounce_cnt(i);
        debounce_out(i) <= glitch_out_p1(i);
        debounce_en(i)  <= '0';
      -- Increase counter
      elsif(debounce_en(i)  = '1') then
        debounce_cnt(i) <= debounce_cnt(i) + '1';
        debounce_out(i) <= debounce_out(i);            -- Don't change the state of Input
        debounce_en(i)  <= '1';
      end if;
    end loop;
  end if;    
end process;


-------------------------------------------------------
-- 3) Polarity control
-------------------------------------------------------
process(debounce_out, regfile)
begin
  for i in noise_user_data_in'range loop
    if(regfile.InputConditioning(i).InputPol='0') then 
      clean_user_data_in(i) <= debounce_out(i);
    else
      clean_user_data_in(i) <= not(debounce_out(i));
    end if;
  end loop;
end process;



end functional;
    