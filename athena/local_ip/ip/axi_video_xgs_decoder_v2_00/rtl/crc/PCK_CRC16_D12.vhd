--------------------------------------------------------------------------------
-- Copyright (C) 1999-2008 Easics NV.
-- This source file may be used and distributed without restriction
-- provided that this copyright statement is not removed from the file
-- and that any derivative work contains the original copyright notice
-- and the associated disclaimer.
--
-- THIS SOURCE FILE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS
-- OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
-- WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
--
-- Purpose : synthesizable CRC function
--   * polynomial: x^16 + x^12 + x^5 + 1
--   * data width: 12
--
-- Info : tools@easics.be
--        http://www.easics.com
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package PCK_CRC16_D12 is
  -- polynomial: x^16 + x^12 + x^5 + 1
  -- data width: 12
  -- convention: the first serial bit is D[11]
  function nextCRC16_D12
    (Data: unsigned(11 downto 0);
     crc:  unsigned(15 downto 0))
    return unsigned;
end PCK_CRC16_D12;


package body PCK_CRC16_D12 is

  -- polynomial: x^16 + x^12 + x^5 + 1
  -- data width: 12
  -- convention: the first serial bit is D[11]
  function nextCRC16_D12
    (Data: unsigned(11 downto 0);
     crc:  unsigned(15 downto 0))
    return unsigned is

    variable d:      unsigned(11 downto 0);
    variable c:      unsigned(15 downto 0);
    variable newcrc: unsigned(15 downto 0);

  begin
    d := Data;
    c := crc;

    newcrc(0) := d(11) xor d(8) xor d(4) xor d(0) xor c(4) xor c(8) xor c(12) xor c(15);
    newcrc(1) := d(9) xor d(5) xor d(1) xor c(5) xor c(9) xor c(13);
    newcrc(2) := d(10) xor d(6) xor d(2) xor c(6) xor c(10) xor c(14);
    newcrc(3) := d(11) xor d(7) xor d(3) xor c(7) xor c(11) xor c(15);
    newcrc(4) := d(8) xor d(4) xor c(8) xor c(12);
    newcrc(5) := d(11) xor d(9) xor d(8) xor d(5) xor d(4) xor d(0) xor c(4) xor c(8) xor c(9) xor c(12) xor c(13) xor c(15);
    newcrc(6) := d(10) xor d(9) xor d(6) xor d(5) xor d(1) xor c(5) xor c(9) xor c(10) xor c(13) xor c(14);
    newcrc(7) := d(11) xor d(10) xor d(7) xor d(6) xor d(2) xor c(6) xor c(10) xor c(11) xor c(14) xor c(15);
    newcrc(8) := d(11) xor d(8) xor d(7) xor d(3) xor c(7) xor c(11) xor c(12) xor c(15);
    newcrc(9) := d(9) xor d(8) xor d(4) xor c(8) xor c(12) xor c(13);
    newcrc(10) := d(10) xor d(9) xor d(5) xor c(9) xor c(13) xor c(14);
    newcrc(11) := d(11) xor d(10) xor d(6) xor c(10) xor c(14) xor c(15);
    newcrc(12) := d(8) xor d(7) xor d(4) xor d(0) xor c(0) xor c(4) xor c(8) xor c(11) xor c(12);
    newcrc(13) := d(9) xor d(8) xor d(5) xor d(1) xor c(1) xor c(5) xor c(9) xor c(12) xor c(13);
    newcrc(14) := d(10) xor d(9) xor d(6) xor d(2) xor c(2) xor c(6) xor c(10) xor c(13) xor c(14);
    newcrc(15) := d(11) xor d(10) xor d(7) xor d(3) xor c(3) xor c(7) xor c(11) xor c(14) xor c(15);
    return newcrc;
  end nextCRC16_D12;

end PCK_CRC16_D12;
