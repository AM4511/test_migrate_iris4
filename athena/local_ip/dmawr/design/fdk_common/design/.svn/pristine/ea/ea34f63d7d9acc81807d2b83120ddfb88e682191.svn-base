----------------------------------------------------------------------
-- $HeadURL: svn://brainstorm/svn_ipcore/trunk/Matrox/Imaging/FDK/hw/cores/common/design/fifo_syncram.vhd $
-- $Revision: 10081 $
-- $Date: 2010-04-15 13:22:24 -0400 (Thu, 15 Apr 2010) $
-- $Author: mpoirie1 $
--
-- DESCRIPTION: fifo_syncram
--
-- contains the following modules:
--
--                alt_syncram_stx_gen
--                alt_syncram_stxii_gen
--
-----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity fifo_syncram is
  generic (

    USE_RDEN     : boolean := true;     -- if false, rden is hardwired to '1'
    BYTE_SIZE    : integer := 8;        -- 8 or 9
    WRDATA_WIDTH : integer;             -- must be a multiple of BYTE_SIZE
    WRADDR_WIDTH : integer;
    RDDATA_WIDTH : integer;             -- must be a multiple of BYTE_SIZE
    RDADDR_WIDTH : integer;
    FPGA_ARCH    : string  := "ALTERA";  -- "ALTERA", "XILINX_KU"
    FPGA_FAMILY  : string  := "STRATIX"  -- "STRATIX", "STRATIXII", "STRATIXIII", "STRATIXIV"

    );
	
  port (

    -------------------------------------------------
    -- fifo write port
    -------------------------------------------------
    wrclk  : in  std_logic;
    wren   : in  std_logic;
    wraddr : in  std_logic_vector(WRADDR_WIDTH-1 downto 0);
    wrdata : in  std_logic_vector(WRDATA_WIDTH-1 downto 0);
    wrbena : in  std_logic_vector(WRDATA_WIDTH/BYTE_SIZE-1 downto 0) := (others => '1');
    -------------------------------------------------
    -- fifo read port
    -------------------------------------------------
    rdclk  : in  std_logic;
    rden   : in  std_logic                                           := '1';
    rdaddr : in  std_logic_vector(RDADDR_WIDTH-1 downto 0);
    rddata : out std_logic_vector(RDDATA_WIDTH-1 downto 0)

    );
end fifo_syncram;

architecture functional of fifo_syncram is


  -----------------------------------------------------
  -- log2
  -----------------------------------------------------
  function log2 (arg : integer
                 ) return                  integer is

    variable result       : integer := 0;
    variable comparevalue : integer := 1;
  begin

    assert arg /= 0
      report "invalid arg value 0 in log2"
      severity failure;

    while (comparevalue < arg) loop
      comparevalue := comparevalue * 2;
      result       := result + 1;
    end loop;

    return result;
  end;


  -----------------------------------------------------
  -- roundexp
  -- returns an integer that is a function of byte_size * 2exp(n)
  -----------------------------------------------------
  function roundexp (arg       : integer;
                     byte_size : integer
                     ) return                  integer is

    variable result : integer := byte_size;
  begin

    while (result < arg) loop
      result := result * 2;
    end loop;

    return result;
  end roundexp;


  -----------------------------------------------------
  -- gen_sram_size
  -----------------------------------------------------
  function gen_sram_size (datawidth : integer;
                          addrwidth : integer;
                          bytesize  : integer
                          ) return                  integer is

    variable result : integer;
  begin

    result := (2 ** (log2(datawidth/bytesize*8))) * (2 ** addrwidth) / 8 * bytesize;

    return result;
  end gen_sram_size;




  -----------------------------------------------------
  -- constants
  -----------------------------------------------------
  constant WRDATA_WIDTH_INT : integer := roundexp(WRDATA_WIDTH, BYTE_SIZE);  -- must be a function of BYTE_SIZE*2exp(n), i.e. 8/9, 16/18, 32/36, 64/72, ...
  constant RDDATA_WIDTH_INT : integer := roundexp(RDDATA_WIDTH, BYTE_SIZE);  -- must be a function of BYTE_SIZE*2exp(n), i.e. 8/9, 16/18, 32/36, 64/72, ...
  constant SRAM_SIZE        : integer := gen_sram_size(WRDATA_WIDTH_INT, WRADDR_WIDTH, BYTE_SIZE);  -- equal to "write" depth * WRDATA_WIDTH and "read" depth * RDDATA_WIDTH

  -----------------------------------------------------
  -- signals
  -----------------------------------------------------
  signal signal_SRAM_SIZE : integer := SRAM_SIZE;
  signal wrbena_int       : std_logic_vector(WRDATA_WIDTH_INT/BYTE_SIZE-1 downto 0);
  signal wrdata_int       : std_logic_vector(WRDATA_WIDTH_INT-1 downto 0);
  signal rddata_int       : std_logic_vector(RDDATA_WIDTH_INT-1 downto 0);


-------------------------------------------------
-- fdkDualPortRam (Infered ram block)
-------------------------------------------------
  component fdkDualPortRam
    generic
      (
        FPGA_ARCH : string  := "ALTERA";  -- "ALTERA", "XILINX_KU      
        BYTESIZE  : integer := 8;         -- 8 or 9
        DATAWIDTH : integer := 32;
        ADDRWIDTH : integer := 12
        );
    port
      (
        ben       : in  std_logic_vector (DATAWIDTH/BYTE_SIZE-1 downto 0);
        data      : in  std_logic_vector (DATAWIDTH-1 downto 0);
        rdaddress : in  std_logic_vector (ADDRWIDTH-1 downto 0);
        rdclock   : in  std_logic;
        rden      : in  std_logic := '1';
        wraddress : in  std_logic_vector (ADDRWIDTH-1 downto 0);
        wrclock   : in  std_logic := '1';
        wren      : in  std_logic := '0';
        q         : out std_logic_vector (DATAWIDTH-1 downto 0)
        );
  end component;


begin

-------------------------------------------------
-- Verifications
-------------------------------------------------

--synthesis translate_off

  -------------------------------------
  -- WRDATA_WIDTH must be a multiple of BYTE_SIZE
  -------------------------------------
  assert WRDATA_WIDTH mod BYTE_SIZE = 0
    report "WRDATA_WIDTH is not a multiple of BYTE_SIZE in fifo_syncram module"
    severity failure;

  -------------------------------------
  -- RDDATA_WIDTH must be a multiple of BYTE_SIZE
  -------------------------------------
  assert RDDATA_WIDTH mod BYTE_SIZE = 0
    report "RDDATA_WIDTH is not a multiple of BYTE_SIZE in fifo_syncram module"
    severity failure;

  -------------------------------------
  -- RDDATA_WIDTH must equal WRDATA_WIDTH
  -------------------------------------
  assert RDDATA_WIDTH = WRDATA_WIDTH
    report "RDDATA_WIDTH is not equal to WRDATA_WIDTH in fifo_syncram module"
    severity failure;

  -------------------------------------
  -- RDADDR_WIDTH must equal WRADDR_WIDTH
  -------------------------------------
  assert RDADDR_WIDTH = WRADDR_WIDTH
    report "RDADDR_WIDTH is not equal to WRADDR_WIDTH in fifo_syncram module"
    severity failure;

--synthesis translate_on

  xfdkDualPortRam_sync : fdkDualPortRam
    generic map (
      FPGA_ARCH => FPGA_ARCH,
      BYTESIZE  => BYTE_SIZE,
      DATAWIDTH => WRDATA_WIDTH_INT,
      ADDRWIDTH => WRADDR_WIDTH
      )
    port map (
      ben       => wrbena_int,
      data      => wrdata_int,
      rdaddress => rdaddr,
      rdclock   => rdclk ,
      rden      => rden ,
      wraddress => wraddr,
      wrclock   => wrclk ,
      wren      => wren ,
      q         => rddata_int
      );

  --------------
  -- wrbena_int
  --------------
  wrbena_int(WRDATA_WIDTH/BYTE_SIZE-1 downto 0) <= wrbena;

  --------------
  -- wrdata_int
  --------------
  wrdata_int(WRDATA_WIDTH-1 downto 0) <= wrdata;

  gen_int_width_adjust : if WRDATA_WIDTH_INT > WRDATA_WIDTH generate
                                                                    wrbena_int(WRDATA_WIDTH_INT/BYTE_SIZE-1 downto WRDATA_WIDTH/BYTE_SIZE) <= (others => '0'); 
                                                                      wrdata_int(WRDATA_WIDTH_INT-1 downto WRDATA_WIDTH) <= (others => '0'); 
  end generate gen_int_width_adjust; 

 --------------
 -- rddata
 --------------
 rddata <= rddata_int(rddata'range);

end functional;





