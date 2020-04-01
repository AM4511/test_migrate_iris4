-----------------------------------------------------------------------
-- $HeadURL: svn://brainstorm/fpga/trunk/Matrox/Imaging/FPGA/Iris2/Isis/design/osirispak.vhd $
-- $Author: jlarin $
-- $Revision: 6326 $
-- $Date: 2010-05-21 10:45:16 -0400 (Fri, 21 May 2010) $
--
-- File:         pciepack.vhd
-- 
-- Description:  package pour les type globaux associe au core PCIe
-- 
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

library work;
use work.regfile_pcie2AxiMaster_pack.all;


package pciepack is

  ---------------------------------------------------------------------------------
  -- PCIe constants
  ---------------------------------------------------------------------------------
  --constant NB_PCIE_AGENTS     : integer := 3; -- number of BAR agents + number of master agents
  type ATTRIB_VECTOR is array(natural range <>) of std_logic_vector(1 downto 0);
  type TRANS_ID is array(natural range <>) of std_logic_vector(23 downto 0);
  type BYTE_COUNT_ARRAY is array(natural range <>) of std_logic_vector(12 downto 0);
  type LOWER_ADDR_ARRAY is array(natural range <>) of std_logic_vector(6 downto 0);
  type FMT_TYPE_ARRAY is array(natural range <>) of std_logic_vector(6 downto 0);
  type LENGTH_DW_ARRAY is array(natural range <>) of std_logic_vector(9 downto 0);
  type PCIE_DATA_ARRAY is array(natural range <>) of std_logic_vector(63 downto 0);
  type PCIE_ADDRESS_ARRAY is array(natural range <>) of std_logic_vector(63 downto 2);
  type LDWBE_FDWBE_ARRAY is array(natural range <>) of std_logic_vector(7 downto 0);
  type integer_vector is array (natural range <>) of integer;  -- definition de VHDL2008 non disponible dans ISE 13.4


end pciepack;



package body pciepack is

end pciepack;



