----------------------------------------------------------------------
-- DESCRIPTION: IRIS4 Athena HiSPi FPGA
--
-- Top level history:
-- =============================================
-- V0.1     : First  itteration
--
-- PROJECT  : Iris4
--
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;


entity athena is
  generic(
    FPGA_MAJOR_VERSION     : integer := 0;
    FPGA_MINOR_VERSION     : integer := 0;
    FPGA_SUB_MINOR_VERSION : integer := 0;
    FPGA_BUILD_DATE        : integer := 0;
    FPGA_IS_NPI_GOLDEN     : integer := 0;
    FPGA_DEVICE_ID         : integer := 0;
    HISPI_NUMBER_OF_DATA_LANES    : integer := 6;
    HISPI_NUMBER_OF_CLOCK_LANES   : integer := 2
    );
  port (
    ---------------------------------------------------------------------------
    -- System interface
    ---------------------------------------------------------------------------
    ref_clk                         : in std_logic;
    sys_rst_n                       : in std_logic;

    ---------------------------------------------------------------------------
    -- PCIe Interface Gen1x2
    ---------------------------------------------------------------------------
    pcie_clk_n                      : in  std_logic;
    pcie_clk_p                      : in  std_logic;

    pcie_rx_n                       : in  std_logic_vector(1 downto 0);
    pcie_rx_p                       : in  std_logic_vector(1 downto 0);
    pcie_tx_n                       : out std_logic_vector(1 downto 0);
    pcie_tx_p                       : out std_logic_vector(1 downto 0);

    ---------------------------------------------------------------------------
    -- XGS sensor control interface
    ---------------------------------------------------------------------------
    xgs_reset_n                     : out std_logic;
    xgs_clk_pll_en                  : out std_logic; 
    xgs_trig_int                    : out std_logic;
    xgs_trig_rd                     : out std_logic;
    xgs_monitor                     : in  std_logic_vector(2 downto 0);
    xgs_fwsi_en                     : out std_logic;  
    xgs_cs_n                        : out std_logic;
    xgs_sclk                        : out std_logic;
    xgs_sdin                        : in  std_logic;
    xgs_sdout                       : out std_logic;


    ---------------------------------------------------------------------------
    --  XGS sensor HiSPi data interface
    ---------------------------------------------------------------------------
    xgs_hispi_sclk_n                : in std_logic_vector (HISPI_NUMBER_OF_CLOCK_LANES-1 downto 0);
    xgs_hispi_sclk_p                : in std_logic_vector (HISPI_NUMBER_OF_CLOCK_LANES-1 downto 0);
    xgs_hispi_sdata_n               : in std_logic_vector (HISPI_NUMBER_OF_DATA_LANES-1 downto 0);
    xgs_hispi_sdata_p               : in std_logic_vector (HISPI_NUMBER_OF_DATA_LANES-1 downto 0);

    ---------------------------------------------------------------------------
    --  Debug
    ---------------------------------------------------------------------------
    debug_data                      : out std_logic_vector(3 downto 0);
    
    ---------------------------------------------------------------------------
    --  LED outputs
    ---------------------------------------------------------------------------
    led_out                         : out   std_logic_vector(1 downto 0);
    
    ---------------------------------------------------------------------------
    --  OUTPUTS TO IO FPGA
    ---------------------------------------------------------------------------
    strobe_out                      : out   std_logic;
    exposure_out                    : out   std_logic;
    trig_rdy_out                    : out   std_logic;

    ---------------------------------------------------------------------------
    --  INPUTS FROM other fpga
    ---------------------------------------------------------------------------
    ext_trig                        : in    std_logic;

    ---------------------------------------------------------------------------
    --  I2C
    ---------------------------------------------------------------------------
    smbclk                          : inout std_logic;
    smbdata                         : inout std_logic;

    ---------------------------------------------------------------------------
    --  Temperature ALERT
    ---------------------------------------------------------------------------
    temp_alertN                     : in    std_logic;    
  
    ---------------------------------------------------------------------------
    --  Strappings
    ---------------------------------------------------------------------------
    fpga_var_type                   : in    std_logic_vector(1 downto 0);    
  
    ---------------------------------------------------------------------------
    --  FPGA FLASH SPI  interface
    ---------------------------------------------------------------------------
    cfg_spi_cs_n                    : inout std_logic;
    cfg_spi_sd                      : inout std_logic_vector (3 downto 0)

    );
end athena;


architecture struct of athena is


  component system_pb_wrapper is
    port (
      cfg_qspi_io0_io        : inout std_logic;
      cfg_qspi_io1_io        : inout std_logic;
      cfg_qspi_io2_io        : inout std_logic;
      cfg_qspi_io3_io        : inout std_logic;
      cfg_qspi_ss_io         : inout std_logic_vector (0 to 0);
      cfg_startup_io_cfgclk  : out   std_logic;
      cfg_startup_io_cfgmclk : out   std_logic;
      cfg_startup_io_eos     : out   std_logic;
      cfg_startup_io_preq    : out   std_logic;
      pcie_clk_100MHz        : in    std_logic;
      pcie_rxn               : in    std_logic_vector (1 downto 0);
      pcie_rxp               : in    std_logic_vector (1 downto 0);
      pcie_txn               : out   std_logic_vector (1 downto 0);
      pcie_txp               : out   std_logic_vector (1 downto 0);
      ref_clk                : in    std_logic;
      sys_rst_n              : in    std_logic;
      xgs_hispi_data_n       : in    std_logic_vector (5 downto 0);
      xgs_hispi_data_p       : in    std_logic_vector (5 downto 0);
      xgs_hispi_sclk_n       : in    std_logic_vector (1 downto 0);
      xgs_hispi_sclk_p       : in    std_logic_vector (1 downto 0)
      );
  end component;



  signal pcie_clk_100MHz : std_logic;
  signal spi_in          : std_logic_vector (3 downto 0);
  signal spi_out         : std_logic_vector (3 downto 0);
  signal spi_out_en      : std_logic_vector (3 downto 0);
  signal spi_cs_in       : std_logic_vector (0 to 0);
  signal spi_cs_out      : std_logic_vector (0 to 0);
  signal spi_cs_en       : std_logic;

begin

  -- Pour avoir access a la pin dedie du core PCIe, il faut instantier le IBUFDS_GTE2
  ibuf_pcie_clk_100MHz : IBUFDS_GTE2
    port map (
      O     => pcie_clk_100MHz,
      I     => pcie_clk_p,
      IB    => pcie_clk_n,
      CEB   => '0',
      ODIV2 => open
      );


  xsystem_pb_wrapper : system_pb_wrapper
    port map(
      pcie_clk_100MHz        => pcie_clk_100MHz,
      sys_rst_n              => sys_rst_n,
      cfg_qspi_io0_io        => cfg_spi_sd(0),
      cfg_qspi_io1_io        => cfg_spi_sd(1),
      cfg_qspi_io2_io        => cfg_spi_sd(2),
      cfg_qspi_io3_io        => cfg_spi_sd(3),
      cfg_qspi_ss_io(0)      => cfg_spi_cs_n,
      xgs_hispi_data_n       => xgs_hispi_sdata_n,
      xgs_hispi_data_p       => xgs_hispi_sdata_p,
      xgs_hispi_sclk_n(0)    => xgs_hispi_sclk_n(0),
      xgs_hispi_sclk_n(1)    => xgs_hispi_sclk_n(1),
      --xgs_hispi_sclk_n(2)    => xgs_hispi_sclk_n(2), 
      --xgs_hispi_sclk_n(3)    => xgs_hispi_sclk_n(3),
      --xgs_hispi_sclk_n(4)    => xgs_hispi_sclk_n(4),
      --xgs_hispi_sclk_n(5)    => xgs_hispi_sclk_n(5),     
      xgs_hispi_sclk_p(0)    => xgs_hispi_sclk_p(0),
      xgs_hispi_sclk_p(1)    => xgs_hispi_sclk_p(1),
      --xgs_hispi_sclk_p(2)    => xgs_hispi_sclk_p(2),      
      --xgs_hispi_sclk_p(3)    => xgs_hispi_sclk_p(3),
      --xgs_hispi_sclk_p(4)    => xgs_hispi_sclk_p(4),
      --xgs_hispi_sclk_p(5)    => xgs_hispi_sclk_p(5),

      cfg_startup_io_cfgclk  => open,
      cfg_startup_io_cfgmclk => open,
      cfg_startup_io_eos     => open,
      cfg_startup_io_preq    => open,

      -- bug dans vivado il faut exploser sinon ca bug!
      pcie_rxn(0)               => pcie_rx_n(0),
      pcie_rxn(1)               => pcie_rx_n(1),
      pcie_rxp(0)               => pcie_rx_p(0),
      pcie_rxp(1)               => pcie_rx_p(1),
      pcie_txn(0)               => pcie_tx_n(0),
      pcie_txn(1)               => pcie_tx_n(1),
      pcie_txp(0)               => pcie_tx_p(0),
      pcie_txp(1)               => pcie_tx_p(1),

      ref_clk                => ref_clk
      );



end struct;
