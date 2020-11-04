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
--use ieee.numeric_bit.all;


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

  -- pour la version PCIE qui parle au protocol serie:
  --type STD8_LOGIC_VECTOR is array (natural range <>) of std_logic_vector(7 downto 0);
  --type STD32_LOGIC_VECTOR is array (natural range <>) of std_logic_vector(31 downto 0);


  -- ------------------------------------------------------------------------------------------
  -- -- Register Name: ctrl
  -- ------------------------------------------------------------------------------------------
  -- type AXI_WINDOW_CTRL_TYPE is record
  --   enable : std_logic;
  -- end record AXI_WINDOW_CTRL_TYPE;

  -- constant INIT_AXI_WINDOW_CTRL_TYPE : AXI_WINDOW_CTRL_TYPE := (
  --   enable => 'Z'
  --   );

  -- -- Casting functions:
  -- function to_std_logic_vector(reg       : AXI_WINDOW_CTRL_TYPE) return std_logic_vector;
  -- function to_AXI_WINDOW_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return AXI_WINDOW_CTRL_TYPE;

  -- ------------------------------------------------------------------------------------------
  -- -- Register Name: pci_bar0_start
  -- ------------------------------------------------------------------------------------------
  -- type AXI_WINDOW_PCI_BAR0_START_TYPE is record
  --   value : std_logic_vector(25 downto 0);
  -- end record AXI_WINDOW_PCI_BAR0_START_TYPE;

  -- constant INIT_AXI_WINDOW_PCI_BAR0_START_TYPE : AXI_WINDOW_PCI_BAR0_START_TYPE := (
  --   value => (others => 'Z')
  --   );

  -- -- Casting functions:
  -- function to_std_logic_vector(reg                 : AXI_WINDOW_PCI_BAR0_START_TYPE) return std_logic_vector;
  -- function to_AXI_WINDOW_PCI_BAR0_START_TYPE(stdlv : std_logic_vector(31 downto 0)) return AXI_WINDOW_PCI_BAR0_START_TYPE;

  -- ------------------------------------------------------------------------------------------
  -- -- Register Name: pci_bar0_stop
  -- ------------------------------------------------------------------------------------------
  -- type AXI_WINDOW_PCI_BAR0_STOP_TYPE is record
  --   value : std_logic_vector(25 downto 0);
  -- end record AXI_WINDOW_PCI_BAR0_STOP_TYPE;

  -- constant INIT_AXI_WINDOW_PCI_BAR0_STOP_TYPE : AXI_WINDOW_PCI_BAR0_STOP_TYPE := (
  --   value => (others => 'Z')
  --   );

  -- -- Casting functions:
  -- function to_std_logic_vector(reg                : AXI_WINDOW_PCI_BAR0_STOP_TYPE) return std_logic_vector;
  -- function to_AXI_WINDOW_PCI_BAR0_STOP_TYPE(stdlv : std_logic_vector(31 downto 0)) return AXI_WINDOW_PCI_BAR0_STOP_TYPE;

  -- ------------------------------------------------------------------------------------------
  -- -- Register Name: axi_translation
  -- ------------------------------------------------------------------------------------------
  -- type AXI_WINDOW_AXI_TRANSLATION_TYPE is record
  --   value : std_logic_vector(31 downto 0);
  -- end record AXI_WINDOW_AXI_TRANSLATION_TYPE;

  -- constant INIT_AXI_WINDOW_AXI_TRANSLATION_TYPE : AXI_WINDOW_AXI_TRANSLATION_TYPE := (
  --   value => (others => 'Z')
  --   );

  -- -- Casting functions:
  -- function to_std_logic_vector(reg                  : AXI_WINDOW_AXI_TRANSLATION_TYPE) return std_logic_vector;
  -- function to_AXI_WINDOW_AXI_TRANSLATION_TYPE(stdlv : std_logic_vector(31 downto 0)) return AXI_WINDOW_AXI_TRANSLATION_TYPE;
  -- ------------------------------------------------------------------------------------------
  -- -- Section Name: axi_window
  -- ------------------------------------------------------------------------------------------
  -- type AXI_WINDOW_TYPE is record
  --   ctrl            : AXI_WINDOW_CTRL_TYPE;
  --   pci_bar0_start  : AXI_WINDOW_PCI_BAR0_START_TYPE;
  --   pci_bar0_stop   : AXI_WINDOW_PCI_BAR0_STOP_TYPE;
  --   axi_translation : AXI_WINDOW_AXI_TRANSLATION_TYPE;
  -- end record AXI_WINDOW_TYPE;

  -- constant INIT_AXI_WINDOW_TYPE : AXI_WINDOW_TYPE := (
  --   ctrl            => INIT_AXI_WINDOW_CTRL_TYPE,
  --   pci_bar0_start  => INIT_AXI_WINDOW_PCI_BAR0_START_TYPE,
  --   pci_bar0_stop   => INIT_AXI_WINDOW_PCI_BAR0_STOP_TYPE,
  --   axi_translation => INIT_AXI_WINDOW_AXI_TRANSLATION_TYPE
  --   );

  -- ------------------------------------------------------------------------------------------
  -- -- Array type: AXI_WINDOW_TYPE
  -- ------------------------------------------------------------------------------------------
  -- type AXI_WINDOW_TYPE_ARRAY is array (3 downto 0) of AXI_WINDOW_TYPE;
  -- constant INIT_AXI_WINDOW_TYPE_ARRAY : AXI_WINDOW_TYPE_ARRAY := (others => INIT_AXI_WINDOW_TYPE);

  ---------------------------------------------------------------------------------
  -- PCIe - Streamer constants
  ---------------------------------------------------------------------------------
--  constant MAX_PCIE_PAYLOAD_SIZE  : integer := 128; -- ceci sert a limiter la dimension maximale que les agents master sur le pcie (le DMA) peuvent utiliser, en plus de la limitation
  -- de link negocie avec le link partner.  Le but est d'etre plus efficace sur certaines architectures (Iris GT par exemple, qui est plus 
    -- performant avec des payload de 64.


  ---------------------------------------------------------------------------------
  -- GENERAL FUNCTIONS
  ---------------------------------------------------------------------------------
  --function log2(arg: integer) return integer;
  --function log2_ceil(a:integer) return integer;
  --function bo2sl(s : boolean) return std_logic;
  --function OrN (arg: std_logic_vector) return std_logic;
  --function AndN (arg: std_logic_vector) return std_logic;  

end pciepack;



-- package body pciepack is
-- 
-- 
--   
--   ---------------------------------------------------
--   -- Calculation of number of bits needed to fit the 
--   -- integer sent as an argument
--   ---------------------------------------------------
--   function log2_ceil(a:integer) return integer is
--     variable index  : integer := a;
--     variable sum    : integer := 1; 
--   begin
--     case index is
--       when 0 to 2 => sum := 1;
--       when 3 to 4 => sum := 2;
--       when 5 to 8 => sum := 3;
--       when 9 to 16 => sum := 4;
--       when 17 to 32 => sum := 5;
--       when 33 to 64 => sum := 6;
--       when 65 to 128 => sum := 7;
--       when 129 to 256 => sum := 8;   
--       when 257 to 512 => sum := 9;
--       when 513 to 1024 => sum := 10;
--       when 1025 to 2048 => sum := 11;
--       when 2049 to 4096 => sum := 12;
--       when 4097 to 8192 => sum := 13;
--       when 8193 to 16384 => sum := 14;
--       when 16385 to 32786 => sum := 15;
--       when 32797 to 65536    => sum := 16;
--       when 65537 to 131072 => sum := 17;
--       when 131073 to 262144 => sum := 18;
--       when 262145 to 524288 => sum := 19;
--       when 524289 to 1048576 => sum := 20;
--       when 1048577 to 2097152 => sum := 21;
--       when 2097153 to 4194304 => sum := 22;
--       when 4194305 to 8388608 => sum := 23;
--       when 8388609 to 16777216 => sum := 24;
--       when others => sum := 25;
--     end case; 
--     return sum;
--   end log2_ceil;
-- 
--   -----------------------------------------------------------------------------
--   -- boolean to std_logic
--   -----------------------------------------------------------------------------
--   function bo2sl(s : boolean) return std_logic is 
--   begin
--     case s is
--       when false => return ('0');
--       when true  => return ('1');
--     end case;
--   end bo2sl;
-- 
-- 
--   -----------------------------------------------------------------------------
--   -- Function making a OR of a group of signals
--   -----------------------------------------------------------------------------
--   function OrN (arg: std_logic_vector) return std_logic is
--     variable result : std_logic;
--   begin
--     result := '0';
-- 
--     for i in arg'range loop
--       result := result or arg(i);
--     end loop;
-- 
--     return result;
--   end OrN;
-- 
-- 
--   -----------------------------------------------------------------------------
--   -- Function making an AND of a group of signals
--   -----------------------------------------------------------------------------
--   function AndN (arg: std_logic_vector) return std_logic is
--     variable result : std_logic;
--   begin
--     result := '1';
-- 
--     for i in arg'range loop
--       result := result and arg(i);
--     end loop;
-- 
--     return result;
--   end AndN;
-- 
-- 
-- end pciepack;



