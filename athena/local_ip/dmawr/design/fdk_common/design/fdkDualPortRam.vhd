----------------------------------------------------------------------------------------
-- Name:        fdkDualPortRam
-- Type:        Inferred Generic RAM Bloc
-- Project:     FDK
--
-- Description: Inferred generic ram bloc used by the IP-Core.
--
-- Author(s):   Alain Marchand, Matrox Electronic Systems Ltd.
----------------------------------------------------------------------------------------
-- History:     V0.01 (am)
--               * initial release
----------------------------------------------------------------------------------------
-- SVN:         $Revision: 1530 $
--              $LastChangedDate: 2012-11-29 18:12:32 -0500 (Thu, 29 Nov 2012) $
--              $HeadURL:$
----------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- synthesis translate_off
library xpm;
use xpm.vcomponents.all;
-- synthesis translate_on  

entity fdkDualPortRam is
  generic
    (
      FPGA_ARCH : string  := "ALTERA";  -- ALTERA, XILINX_KU, GENERIC
      BYTESIZE  : integer := 8;         -- 8 or 9
      DATAWIDTH : integer := 32;        -- 32,36,40,64,128, etc.
      ADDRWIDTH : integer := 12
      );
  port
    (
      ben       : in  std_logic_vector ((DATAWIDTH/BYTESIZE)-1 downto 0);
      data      : in  std_logic_vector (DATAWIDTH-1 downto 0);
      rdaddress : in  std_logic_vector (ADDRWIDTH-1 downto 0);
      rdclock   : in  std_logic;
      rden      : in  std_logic := '1';
      wraddress : in  std_logic_vector (ADDRWIDTH-1 downto 0);
      wrclock   : in  std_logic := '1';
      wren      : in  std_logic := '0';
      q         : out std_logic_vector (DATAWIDTH-1 downto 0)
      );
end fdkDualPortRam;


architecture rtl of fdkDualPortRam is

  component xpm_memory_sdpram
    generic (

      -- Common module generics
      MEMORY_SIZE       : integer := 2048;
      MEMORY_PRIMITIVE  : string  := "auto";
      CLOCKING_MODE     : string  := "common_clock";
      ECC_MODE          : string  := "no_ecc";
      MEMORY_INIT_FILE  : string  := "none";
      MEMORY_INIT_PARAM : string  := "";
      USE_MEM_INIT      : integer := 1;
      WAKEUP_TIME       : string  := "disable_sleep";
      AUTO_SLEEP_TIME   : integer := 0;
      MESSAGE_CONTROL   : integer := 0;

      -- Port A module generics
      WRITE_DATA_WIDTH_A : integer := 32;
      BYTE_WRITE_WIDTH_A : integer := 32;
      ADDR_WIDTH_A       : integer := 6;

      -- Port B module generics
      READ_DATA_WIDTH_B  : integer := 32;
      ADDR_WIDTH_B       : integer := 6;
      READ_RESET_VALUE_B : string  := "0";
      READ_LATENCY_B     : integer := 2;
      WRITE_MODE_B       : string  := "no_change"

      );
    port (

      -- Common module ports
      sleep : in std_logic;

      -- Port A module ports
      clka           : in std_logic;
      ena            : in std_logic;
      wea            : in std_logic_vector((WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A)-1 downto 0);
      addra          : in std_logic_vector(ADDR_WIDTH_A-1 downto 0);
      dina           : in std_logic_vector(WRITE_DATA_WIDTH_A-1 downto 0);
      injectsbiterra : in std_logic;
      injectdbiterra : in std_logic;

      -- Port B module ports
      clkb     : in  std_logic;
      rstb     : in  std_logic;
      enb      : in  std_logic;
      regceb   : in  std_logic;
      addrb    : in  std_logic_vector(ADDR_WIDTH_B-1 downto 0);
      doutb    : out std_logic_vector(READ_DATA_WIDTH_B-1 downto 0);
      sbiterrb : out std_logic;
      dbiterrb : out std_logic
      );
  end component;

  -- component altera_ram2p2c is
  --   generic
  --     (
  --       BYTESIZE  : integer := 8;       -- 8 or 9
  --       DATAWIDTH : integer := 32;      -- 32,36,40,64,128, etc.
  --       ADDRWIDTH : integer := 12
  --       );
  --   port
  --     (
  --       byteena_a : in  std_logic_vector ((DATAWIDTH/BYTESIZE)-1 downto 0) := (others => '1');
  --       data      : in  std_logic_vector (DATAWIDTH-1 downto 0);
  --       rdaddress : in  std_logic_vector (ADDRWIDTH-1 downto 0);
  --       rdclock   : in  std_logic;
  --       rden      : in  std_logic                                          := '1';
  --       wraddress : in  std_logic_vector (ADDRWIDTH-1 downto 0);
  --       wrclock   : in  std_logic                                          := '1';
  --       wren      : in  std_logic                                          := '0';
  --       q         : out std_logic_vector (DATAWIDTH-1 downto 0)
  --       );
  -- end component;

  component ram2ck is
    generic
      (
        C_NB_COL    : integer              := 4;  -- Specify number of colums (number of bytes)
        C_COL_WIDTH : integer range 8 to 9 := 8;  -- Specify column width (byte width, typically 8 or 9)
        C_ADDRWIDTH : integer              := 12
        );
    port
      (
        wr_clk  : in  std_logic := '1';
        wr_en   : in  std_logic := '0';
        wr_data : in  std_logic_vector ((C_NB_COL*C_COL_WIDTH)-1 downto 0);
        wr_addr : in  std_logic_vector (C_ADDRWIDTH-1 downto 0);
        wr_ben  : in  std_logic_vector (C_NB_COL-1 downto 0);
        rd_clk  : in  std_logic;
        rd_addr : in  std_logic_vector (C_ADDRWIDTH-1 downto 0);
        rd_en   : in  std_logic := '1';
        rd_data : out std_logic_vector ((C_NB_COL*C_COL_WIDTH)-1 downto 0)
        );
  end component;

begin


  -- gen_altera_ram : if FPGA_ARCH = "ALTERA" generate
  --   xaltera_ram2p2c : altera_ram2p2c
  --     generic map (
  --       BYTESIZE  => BYTESIZE,
  --       DATAWIDTH => DATAWIDTH,
  --       ADDRWIDTH => ADDRWIDTH
  --       )
  --     port map (
  --       byteena_a => ben,
  --       data      => data,
  --       rdaddress => rdaddress,
  --       rdclock   => rdclock,
  --       rden      => rden,
  --       wraddress => wraddress,
  --       wrclock   => wrclock,
  --       wren      => wren,
  --       q         => q
  --       );
  -- end generate;

  
  gen_xilinx_ku_ram : if FPGA_ARCH = "XILINX_KU" generate
    ---------------------------------------------------
    xpm_tag_ram : xpm_memory_sdpram
      ---------------------------------------------------
      generic map (

        -- Common module generics
        MEMORY_SIZE       => (2**ADDRWIDTH)*DATAWIDTH,  -- positive integer (26 * 4096) 
        MEMORY_PRIMITIVE  => "block",  --string; "auto", "distributed", "block" or "ultra" ;
        CLOCKING_MODE     => "independent_clock",  --string; "common_clock", "independent_clock" 
        MEMORY_INIT_FILE  => "none",    --string; "none" or "<filename>.mem" 
        MEMORY_INIT_PARAM => "",        --string;
        USE_MEM_INIT      => 1,         --integer; 0,1
        WAKEUP_TIME       => "disable_sleep",  --string; "disable_sleep" or "use_sleep_pin" 
        MESSAGE_CONTROL   => 0,         --integer; 0,1
        ECC_MODE          => "no_ecc",  --string; "no_ecc", "encode_only", "decode_only" or "both_encode_and_decode" 
        AUTO_SLEEP_TIME   => 0,         --Do not Change

        -- Port A module generics
        WRITE_DATA_WIDTH_A => DATAWIDTH,  --positive integer
        BYTE_WRITE_WIDTH_A => BYTESIZE,  --integer; 8, 9, or WRITE_DATA_WIDTH_A value
        ADDR_WIDTH_A       => ADDRWIDTH,  --

        -- Port B module generics
        READ_DATA_WIDTH_B  => DATAWIDTH,    --positive integer
        ADDR_WIDTH_B       => ADDRWIDTH,    --positive integer
        READ_RESET_VALUE_B => "0",      --string
        READ_LATENCY_B     => 1,        --non-negative integer
        WRITE_MODE_B       => "read_first"  --string; "write_first", "read_first", "no_change" 
        )
      port map (

        -- Common module ports
        sleep => '0',

        -- Port A module ports
        clka           => wrclock,
        ena            => '1',
        wea            => ben,
        addra          => wraddress,
        dina           => data,
        injectsbiterra => '0',
        injectdbiterra => '0',

        -- Port B module ports
        clkb     => rdclock,
        rstb     => '0',
        enb      => rden,
        regceb   => '1',
        addrb    => rdaddress,
        doutb    => q,
        sbiterrb => open,
        dbiterrb => open
        );
  end generate;


  -----------------------------------------------------------------------------
  -- RAM block instantiated by inference
  -----------------------------------------------------------------------------
  G_generic_ram : if FPGA_ARCH = "GENERIC" generate
    xram2ck : ram2ck
      generic map(
        C_NB_COL    => DATAWIDTH/BYTESIZE,
        C_COL_WIDTH => BYTESIZE,
        C_ADDRWIDTH => ADDRWIDTH
        )
      port map(
        wr_clk  => wrclock,
        wr_en   => wren,
        wr_data => data,
        wr_addr => wraddress,
        wr_ben  => ben,
        rd_clk  => rdclock,
        rd_addr => rdaddress,
        rd_en   => rden,
        rd_data => q
        );
  end generate;

end rtl;
