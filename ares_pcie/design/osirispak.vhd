-----------------------------------------------------------------------
-- $HeadURL: svn://brainstorm/fpga/trunk/Matrox/Imaging/FPGA/Iris2/Isis/design/osirispak.vhd $
-- $Author: mchampou $
-- $Revision: 6326 $
-- $Date: 2010-05-21 10:45:16 -0400 (Fri, 21 May 2010) $
--
-- File:         Osirisspak.vhd
-- 
-- Description:  Top level package file for IrisGT Athena FPGA
-- 
--------------------------------------------------------------------------------

library ieee;
   use ieee.std_logic_1164.all;
   use ieee.std_logic_arith.all;
   use ieee.numeric_bit.all;

library work;


package osirispak is

  ---------------------------------------------
  -- REGISTER BUS constants
  ---------------------------------------------
  -- la valeur est inexacte et initilise selon toute evidence. La definition utilisee vient de spider_pak.
  --constant REG_ADDRLSB      : integer := 2;   -- 32 bits (4 bytes) granularity
  --constant REG_ADDRMSB      : integer := 12;  -- 8k BAR0


  ---------------------------------------------------------------------------------
  -- PCIe constants
  ---------------------------------------------------------------------------------
  --constant NB_PCIE_AGENTS     : integer := 2; -- number of BAR agents + number of master agents
  type ATTRIB_VECTOR  is array(natural range <>) of std_logic_vector(1 downto 0);
  type TRANS_ID       is array(natural range <>) of std_logic_vector(23 downto 0);
  type BYTE_COUNT_ARRAY is array(natural range <>) of std_logic_vector(12 downto 0);
  type LOWER_ADDR_ARRAY is array(natural range <>) of std_logic_vector(6 downto 0);
  type FMT_TYPE_ARRAY is array(natural range <>) of std_logic_vector(6 downto 0);
  type LENGTH_DW_ARRAY is array(natural range <>) of std_logic_vector(9 downto 0);
  type PCIE_DATA_ARRAY is array(natural range <>) of std_logic_vector(63 downto 0);
  type PCIE_ADDRESS_ARRAY is array(natural range <>) of std_logic_vector(63 downto 2);
  type LDWBE_FDWBE_ARRAY is array(natural range <>) of std_logic_vector(7 downto 0);
  type integer_vector is array (natural range <>) of integer; -- definition de VHDL2008 non disponible dans ISE 13.4
  
  ---------------------------------------------------------------------------------
  -- PCIe - Streamer constants
  ---------------------------------------------------------------------------------
  --constant MAX_PCIE_PAYLOAD_SIZE  : integer := 128; -- ceci sert a limiter la dimension maximale que les agents master sur le pcie (le DMA) peuvent utiliser, en plus de la limitation
                                                   -- de link negocie avec le link partner.  Le but est d'etre plus efficace sur certaines architectures (Iris GT par exemple, qui est plus 
                                                   -- performant avec des payload de 64.
  
  -- Our maximum payload size is 128B takes 5 bits when base 0
  --constant MAXPAY_DW_MSB  : integer := 4; 
  --constant MAXPAY_B_MSB   : integer := 6; 
--  constant MAXPAY_STR_MSB : integer := 3; -- hardcode pendant transisiton de burst variable... MAXPAY_DW_MSB - (STR_BURST_LENGTH-1); --3 -- 5

  ---------------------------------------------------------------------------------
  -- STREAMER MODULES FUNCTIONS
  ---------------------------------------------------------------------------------

  ---------------------------------------------------------------------------------
  -- GENERAL FUNCTIONS
  ---------------------------------------------------------------------------------
  function log2(arg: integer) return integer;
  function log2_ceil(a:integer) return integer;
  function bo2sl(s : boolean) return std_logic;
  function OrN (arg: std_logic_vector) return std_logic;
  function AndN (arg: std_logic_vector) return std_logic;  

end osirispak;

package body osirispak is
  ----------------------------------------------------------------------------
  --  log2 function
  ----------------------------------------------------------------------------
  function log2(arg: integer) return integer is
    variable tmp  : integer;
    variable tmp1 : integer;
  begin
    tmp  := arg;
    tmp1 := arg;
    if (arg=0 or arg=1) then
      return (0);
    else
      for i in 1 to 256 loop
        tmp  := tmp/2;
        tmp1 := tmp1 mod 2;
        if (((tmp = 1) and (tmp1 = 0)) or (tmp = 0)) then
          return(i);
        else
          tmp1 := tmp;
        end if;
      end loop;
    end if;
  end log2;

  ---------------------------------------------------
  -- Calculation of number of bits needed to fit the 
  -- integer sent as an argument
  ---------------------------------------------------
  function log2_ceil(a:integer) return integer is
    variable index  : integer := a;
    variable sum    : integer := 1; 
  begin
    case index is
      when 0 to 2 => sum := 1;
      when 3 to 4 => sum := 2;
      when 5 to 8 => sum := 3;
      when 9 to 16 => sum := 4;
      when 17 to 32 => sum := 5;
      when 33 to 64 => sum := 6;
      when 65 to 128 => sum := 7;
      when 129 to 256 => sum := 8;   
      when 257 to 512 => sum := 9;
      when 513 to 1024 => sum := 10;
      when 1025 to 2048 => sum := 11;
      when 2049 to 4096 => sum := 12;
      when 4097 to 8192 => sum := 13;
      when 8193 to 16384 => sum := 14;
      when 16385 to 32786 => sum := 15;
      when 32797 to 65536	=> sum := 16;
      when 65537 to 131072 => sum := 17;
      when 131073 to 262144 => sum := 18;
      when 262145 to 524288 => sum := 19;
      when 524289 to 1048576 => sum := 20;
      when 1048577 to 2097152 => sum := 21;
      when 2097153 to 4194304 => sum := 22;
      when 4194305 to 8388608 => sum := 23;
      when 8388609 to 16777216 => sum := 24;
      when others => sum := 25;
    end case; 
    return sum;
  end log2_ceil;

  -----------------------------------------------------------------------------
  -- boolean to std_logic
  -----------------------------------------------------------------------------
  function bo2sl(s : boolean) return std_logic is 
  begin
    case s is
      when false => return ('0');
      when true  => return ('1');
    end case;
  end bo2sl;


  -----------------------------------------------------------------------------
  -- Function making a OR of a group of signals
  -----------------------------------------------------------------------------
  function OrN (arg: std_logic_vector) return std_logic is
    variable result : std_logic;
  begin
    result := '0';

    for i in arg'range loop
      result := result or arg(i);
    end loop;

    return result;
  end OrN;


  -----------------------------------------------------------------------------
  -- Function making an AND of a group of signals
  -----------------------------------------------------------------------------
  function AndN (arg: std_logic_vector) return std_logic is
    variable result : std_logic;
  begin
    result := '1';

    for i in arg'range loop
      result := result and arg(i);
    end loop;

    return result;
  end AndN;


end osirispak;

-- pour interfacer avec le module de flash SPI
package spi_pak is
  alias SPI_TYPE                            is  work.regfile_ares_pack.SPI_TYPE;
  alias INIT_SPI_TYPE                       is  work.regfile_ares_pack.INIT_SPI_TYPE;
end spi_pak;

package body spi_pak is
end spi_pak;


-- package int_queue_pak is
--   alias INTERRUPT_QUEUE_TYPE       is  work.regfile_ares_pack.INTERRUPT_QUEUE_TYPE;     
--   alias INIT_INTERRUPT_QUEUE_TYPE  is  work.regfile_ares_pack.INIT_INTERRUPT_QUEUE_TYPE;
--   alias INIT_INTERRUPT_QUEUE_CONS_IDX_TYPE  is  work.regfile_ares_pack.INIT_INTERRUPT_QUEUE_CONS_IDX_TYPE;

--   --alias to_std_logic_vector        is  work.regfile_ares_pack.to_std_logic_vector[work.regfile_ares_pack.INTERRUPT_QUEUE_ADDR_HIGH_TYPE return std_logic_vector];
-- end int_queue_pak;

package body int_queue_pak is
end int_queue_pak;
