-----------------------------------------------------------------------
-- $HeadURL: svn://brainstorm/fpga/trunk/Matrox/Imaging/FPGA/pwm_output_core.vhd$
-- $Author: jmansill $
-- $Revision:  $
-- $Date: 2010-05-25 07:07:15 -0400 (Tue, 25 May 2010) $
--
-- DESCRIPTION: PWM output
--              Ce module est construit pour etre utilise dans ARES.
--              Sur Iris3, il y a une signal PWM qui est converti
--              en signal analogue sur le Daughterboard.
--              Ceci est la premiere iteration
--
-- Created by:  Jlarin
-- Date:        30 novembre 2015
-- Project:     Iris 3
--
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.spider_pak.all;

entity pwm_output is
   port (
    ---------------------------------------------------------------------
    -- Reset and clock signals
    ---------------------------------------------------------------------
    sys_reset                             : in    std_logic;
    sys_clk                               : in    std_logic;
    
    ---------------------------------------------------------------------
    -- Output signal: noiseless
    ---------------------------------------------------------------------
    pwm_Out                               : out   std_logic;

    ---------------------------------------------------------------------
    -- REGISTER 
    ---------------------------------------------------------------------
    regfile                               : inout ANALOGOUTPUT_TYPE := INIT_ANALOGOUTPUT_TYPE
  );
end pwm_output;


architecture functional of pwm_output is


  -----------------------------------------------------
  -- signals
  -----------------------------------------------------

  signal count            : std_logic_vector(7 downto 0);
  signal output_level     : std_logic;
  signal count_is_0       : std_logic;
  signal count_is_reached : std_logic;

  constant MAX_COUNT      : std_logic_vector(count'range) := std_logic_vector(to_unsigned(integer(135),count'length));

begin

  -- version initiale, la valeur 100% est a 136. Le sysclock est a 62.5 Mhz, il y a 137 etat a notre compteur (0 a 136), ce qui donne une frequence naturelle de 456,204 kHz. 
  -- La qualification hardware nous revelera si c'est une bonne frequence.
  cntprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if sys_reset = '1' then
        count <= (others => '0');
      elsif count = MAX_COUNT then
        count <= (others => '0');
      else
        count <= count + 1;
      end if;
    end if;
  end process;

  -- on flop les unite de match
  cntmatchprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if to_integer(unsigned(count)) = 0 then
        count_is_0 <= '1';
      else
        count_is_0 <= '0';
      end if;
      
      -- est-ce qu'on a atteint le compte desire?
      if count = regfile.OutputValue.OutputVal then
        count_is_reached <= '1';
      else
        count_is_reached <= '0';
      end if;
      
      -- maintenant on peut generer la sortie.
      -- Le compte incremente. Quand on match le compte desire, la sortie descend. Sinon, la sortie monte a 0.
      -- Ce qui fait que lorsqu'on programme 0, on ne fait que descendre la sortie. Sinon, la longeur du pulse est proportionnelle a la valeur programme dans le registre,
      -- jusqu'a 136 (ou plus) ou la sortie est toujours active.
      if count_is_reached = '1' or sys_reset = '1' then
        output_level <= '0';
      elsif count_is_0 = '1' then
        output_level <= '1';
      end if;
    end if;
  end process;

  pwm_Out <= output_level;
  
end functional;
    