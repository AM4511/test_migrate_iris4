-----------------------------------------------------------------------
-- $HeadURL: svn://brainstorm/fpga/trunk/Matrox/Imaging/FPGA/Output_Conditioning.vhd$
-- $Author: jmansill $
-- $Revision:  $
-- $Date: 2010-05-25 07:07:15 -0400 (Tue, 25 May 2010) $
--
-- DESCRIPTION: Spider Output Conditioner
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
use work.spider_pak.all;

entity Output_Conditioning is
  generic( SIMULATION      : integer :=0;
           LPC_PERIOD      : integer :=30    -- 30 pour GPM, 40 pour GPM-Atom
         ); 
  port (
    ---------------------------------------------------------------------
    -- Reset and clock signals
    ---------------------------------------------------------------------
    sys_reset_n                          : in    std_logic;
    sys_clk                              : in    std_logic;  
    
    ---------------------------------------------------------------------
    -- Inputs
    ---------------------------------------------------------------------
    userio_data_out                      : in   std_logic_vector;
    OutSel_MUX                           : in   std_logic_vector;

    ---------------------------------------------------------------------
    -- Output signal: noiseless
    ---------------------------------------------------------------------
    user_data_out                        : out  std_logic_vector;

    ---------------------------------------------------------------------
    -- REGISTER 
    ---------------------------------------------------------------------
    regfile                              : inout OUTPUTCONDITIONING_TYPE := INIT_OUTPUTCONDITIONING_TYPE
    
     
  );
end Output_Conditioning;


architecture functional of Output_Conditioning is

--------------------------------------------------------------------------------------
-- constant to limit the output toggle rate : 61 Khz --> Debounce 8.196721us chaque edge 
--------------------------------------------------------------------------------------
constant filter_timer_SYNTH_30 : std_logic_vector(regfile.Output_Debounce.Output_HoldOFF_reg_CNTR'range) := conv_std_logic_vector(273,regfile.Output_Debounce.Output_HoldOFF_reg_CNTR'length); -- 8.196721us/30ns = 273 clks
constant filter_timer_SYNTH_40 : std_logic_vector(regfile.Output_Debounce.Output_HoldOFF_reg_CNTR'range) := conv_std_logic_vector(205,regfile.Output_Debounce.Output_HoldOFF_reg_CNTR'length); -- 8.196721us/40ns = 205 clks
constant filter_timer_SYNTH_16 : std_logic_vector(regfile.Output_Debounce.Output_HoldOFF_reg_CNTR'range) := conv_std_logic_vector(512,regfile.Output_Debounce.Output_HoldOFF_reg_CNTR'length); -- 8.196721us/16ns = 512 clks

constant filter_timer_SIM      : std_logic_vector(regfile.Output_Debounce.Output_HoldOFF_reg_CNTR'range) := conv_std_logic_vector( 15,regfile.Output_Debounce.Output_HoldOFF_reg_CNTR'length); -- 15 clks

-----------------------------------------------------
-- signals
-----------------------------------------------------
signal user_data_out_pre_filter     : std_logic_vector(user_data_out'range);
signal user_data_out_post_filter    : std_logic_vector(user_data_out'range);
signal mask_out                     : std_logic_vector(user_data_out'range);

type type_filter_cntr   is array (user_data_out'range) of std_logic_vector(regfile.Output_Debounce.Output_HoldOFF_reg_CNTR'range);
signal filter_cntr      : type_filter_cntr;
signal filter_timer     : std_logic_vector(regfile.Output_Debounce.Output_HoldOFF_reg_CNTR'range);

type TYPE_Outsel is array (user_data_out'range) of integer;
signal Outsel_AsInt       : TYPE_Outsel;

type TYPE_Outsel_MUX_IO is array (user_data_out'range) of std_logic_vector(OutSel_MUX'length downto 0);
signal OutSel_MUX_IO      : TYPE_Outsel_MUX_IO;



begin


-------------------------------------------------------
-- OUTPUT MUX
-------------------------------------------------------

Timers_gen_sel : for i in user_data_out'range generate
  Outsel_AsInt(i)  <= CONV_integer(regfile.OutputCond(i).Outsel);
  OutSel_MUX_IO(i) <= OutSel_MUX & userio_data_out(i);
end generate;


process(sys_clk)
begin
  if (sys_clk'event and sys_clk='1') then
    if(sys_reset_n='0') then
      user_data_out_pre_filter(user_data_out'range)     <= (others=>'0');
    else
      for i in user_data_out'range loop

        --external output
        if Outsel_AsInt(i) < OutSel_MUX_IO(i)'length then
          if(regfile.OutputCond(i).OutputPol='0') then
            user_data_out_pre_filter(i)     <= OutSel_MUX_IO(i)(Outsel_AsInt(i));
          else
            user_data_out_pre_filter(i)     <= not(OutSel_MUX_IO(i)(Outsel_AsInt(i)));
          end if;
        else
          if(regfile.OutputCond(i).OutputPol='0') then
            user_data_out_pre_filter(i)     <= '0';
          else
            user_data_out_pre_filter(i)     <= '1';
          end if;
        end if;

      end loop;
    end if;
  end if;
end process;


--------------------------------------------------------
--  Filter output signal at 61khz
--------------------------------------------------------
process(regfile.Output_Debounce.Output_HoldOFF_reg_EN, regfile.Output_Debounce.Output_HoldOFF_reg_CNTR)
begin
  if(SIMULATION=1)then
    filter_timer <= filter_timer_SIM;
  else
    if(regfile.Output_Debounce.Output_HoldOFF_reg_EN='0') then
      if(LPC_PERIOD=30) then
        filter_timer <= filter_timer_SYNTH_30;
      elsif(LPC_PERIOD=40) then
        filter_timer <= filter_timer_SYNTH_40;
      elsif(LPC_PERIOD=16) then
        filter_timer <= filter_timer_SYNTH_16;
      else
        assert FALSE report "VALEUR LPC_PERIOD DE GENERIQUE NON SUPPORTEE. Il est temps de generaliser l'algorithme pour toutes les valeurs de clock" severity FAILURE;  
      end if;
    else
      filter_timer <= regfile.Output_Debounce.Output_HoldOFF_reg_CNTR;
    end if;
  end if;
end process;

                
process(sys_clk)
begin
  if (sys_clk'event and sys_clk='1') then
    if(sys_reset_n='0') then
      user_data_out_post_filter(user_data_out'range)    <= (others=>'0');
      mask_out(user_data_out'range)                     <= (others=>'0');
      user_data_out(user_data_out'range)                <= (others=>'0');
      for j in user_data_out'range loop
        filter_cntr(j)                                  <= (others=>'0');
      end loop; 
    else
      for i in user_data_out'range loop

        if(mask_out(i)='0') then
          filter_cntr(i)  <= filter_timer;
          if(user_data_out_pre_filter(i) /= user_data_out_post_filter(i) ) then
            user_data_out_post_filter(i) <= user_data_out_pre_filter(i);
            mask_out(i)                  <= '1';
          else
            user_data_out_post_filter(i) <= user_data_out_post_filter(i);
            mask_out(i)                  <= '0';
          end if;
        else
          user_data_out_post_filter(i) <= user_data_out_post_filter(i);
          if(filter_cntr(i)=X"000") then
            filter_cntr(i) <= filter_timer;
            mask_out(i)    <= '0';
          else
            filter_cntr(i) <= filter_cntr(i) - '1';
            mask_out(i)    <= '1';
          end if;
        end if;

        user_data_out(i)                <= user_data_out_post_filter(i);

      end loop;
      
    end if;
  end if;
end process;


-- OutputVal_gen : for i in user_data_out'range generate
--   G_: if (i < user_data_out'left) generate
--   regfile.OutputCond(i).OutputVal  <= user_data_out_post_filter(i);
    
--   end generate G_;
-- end generate;

P_OutputVal: process(user_data_out_post_filter) is
begin
  for i in regfile.OutputCond'range loop
    if (i < user_data_out'length) then
      regfile.OutputCond(i).OutputVal  <= user_data_out_post_filter(i);
    else
      regfile.OutputCond(i).OutputVal  <= '0';
    end if;
  end loop;
end process;


end functional;
