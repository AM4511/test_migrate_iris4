
library ieee;
 use ieee.std_logic_1164.all;
 use IEEE.std_logic_unsigned.all;
 use ieee.numeric_std.all;
 use std.textio.all ; 

package dpc_package is
 
  type STD8_LOGIC_VECTOR    is array (natural range <>) of std_logic_vector(7 downto 0);
  type STD10_LOGIC_VECTOR   is array (natural range <>) of std_logic_vector(9 downto 0);
  type STD12_LOGIC_VECTOR   is array (natural range <>) of std_logic_vector(11 downto 0);
  type STD13_LOGIC_VECTOR   is array (natural range <>) of std_logic_vector(12 downto 0);
  type STD100_LOGIC_VECTOR  is array (natural range <>) of std_logic_vector(99 downto 0);
  
end package dpc_package;
 
-- Package Body Section
package body dpc_package is
 

 
end package body dpc_package;