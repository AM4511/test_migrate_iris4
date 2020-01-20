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

library chip_lib;
use chip_lib.xgs_model_pkg.all;

entity xgs_spi_i2c is
  port(
       reg_addr    : out std_logic_vector(14 downto 0);
       reg_wr      : out std_logic;
       reg_wr_data : out std_logic_vector(15 downto 0);
       reg_rd_data : in  std_logic_vector(15 downto 0);
       
       SCLK         : in    std_logic;
       SDATA        : inout std_logic;
       FWSI_EN      : in    std_logic;
       CS           : in    std_logic;
       SDATAOUT     : out   std_logic
      );
end xgs_spi_i2c;

architecture behaviour of xgs_spi_i2c is

signal bit_count     : integer range 0 to 31;
signal addr          : std_logic_vector(14 downto 0);
signal read_notwrite : std_logic;

begin

SDATA <= 'Z';

MAIN : process(SCLK, CS)
variable var_wr_data : std_logic_vector(15 downto 0);
begin
  if CS = '1' then
    bit_count     <= 0;
    read_notwrite <= '0';
    reg_wr        <= '0';
    var_wr_data   := (others => '0');
  elsif SCLK'event and SCLK = '1' then
    if FWSI_EN = '1' then
      if bit_count < 15 then
        addr(14-bit_count)    <= SDATA;
      elsif bit_count = 15 then
        read_notwrite <= SDATA;
        reg_addr      <= addr;
      else
        reg_wr        <= '0';
        reg_addr      <= addr;
        if read_notwrite = '0' then
          var_wr_data(31-bit_count) := SDATA;
        end if;
      end if;
      if bit_count = 31 then
        reg_wr      <= not(read_notwrite);
        reg_wr_data <= var_wr_data;
        var_wr_data := (others => '0');
        addr        <= std_logic_vector(unsigned(addr)+to_unsigned(2,15));
        bit_count   <= 16;
      else
        bit_count <= bit_count + 1;
      end if;
    else
      assert false
        report "I2C operation has not been modeled yet";
    end if;
  end if;
end process MAIN;

DATA_OUTPUT : process(SCLK, CS)
begin
  if CS = '1' then
    SDATAOUT  <= 'Z';
  elsif SCLK'event and SCLK = '0' then
    if read_notwrite = '1' then
      SDATAOUT <= reg_rd_data(31-bit_count);
    else
      SDATAOUT <= 'Z';
    end if;
  end if;
end process DATA_OUTPUT;

end behaviour;
