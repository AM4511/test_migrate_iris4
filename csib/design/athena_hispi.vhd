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


entity athena_hispi is
  generic(
    FPGA_MAJOR_VERSION     : integer := 0;
    FPGA_MINOR_VERSION     : integer := 0;
    FPGA_SUB_MINOR_VERSION : integer := 0;
    FPGA_BUILD_DATE        : integer := 0;
    FPGA_IS_NPI_GOLDEN     : integer := 0;
    FPGA_DEVICE_ID         : integer := 0;
    HISPI_NUMBER_OF_LANES  : integer := 6
    );
  port (
    ---------------------------------------------------------------------------
    -- System interface
    ---------------------------------------------------------------------------
    ref_clk   : in std_logic;
    sys_rst_n : in std_logic;

    ---------------------------------------------------------------------------
    -- PCIe Interface Gen1x2
    ---------------------------------------------------------------------------
    pcie_clk_n : in  std_logic;
    pcie_clk_p : in  std_logic;
    pcie_rx_n  : in  std_logic_vector (1 to 0);
    pcie_rx_p  : in  std_logic_vector (1 to 0);
    pcie_tx_n  : out std_logic_vector (1 to 0);
    pcie_tx_p  : out std_logic_vector (1 to 0);


    ---------------------------------------------------------------------------
    -- XGS sensor control interface
    ---------------------------------------------------------------------------
    xgs_reset_n  : out std_logic;
    xgs_trig_int : out std_logic;
    xgs_trig_rd  : out std_logic;
    xgs_monitor  : in  std_logic_vector(2 downto 0);
    xgs_cs_n     : out std_logic;
    xgs_sclk     : out std_logic;
    xgs_sdin     : in  std_logic;
    xgs_sdout    : out std_logic;


    ---------------------------------------------------------------------------
    --  XGS sensor HiSPi data interface
    ---------------------------------------------------------------------------
    xgs_hispi_sclk_n  : in std_logic_vector (HISPI_NUMBER_OF_LANES-1 downto 0);
    xgs_hispi_sclk_p  : in std_logic_vector (HISPI_NUMBER_OF_LANES-1 downto 0);
    xgs_hispi_sdata_n : in std_logic_vector (HISPI_NUMBER_OF_LANES-1 downto 0);
    xgs_hispi_sdata_p : in std_logic_vector (HISPI_NUMBER_OF_LANES-1 downto 0);


    ---------------------------------------------------------------------------
    --  FPGA FLASH SPI  interface
    ---------------------------------------------------------------------------
    cfg_spi_cs_n : inout std_logic;
    cfg_spi_sd   : inout std_logic_vector (3 downto 0)

    );
end athena_hispi;


architecture struct of athena_hispi is


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
      xgs_hispi_sclk_n       : in    std_logic_vector (5 downto 0);
      xgs_hispi_sclk_p       : in    std_logic_vector (5 downto 0)
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
      xgs_hispi_sclk_n       => xgs_hispi_sclk_n,
      xgs_hispi_sclk_p       => xgs_hispi_sclk_p,
      cfg_startup_io_cfgclk  => open,
      cfg_startup_io_cfgmclk => open,
      cfg_startup_io_eos     => open,
      cfg_startup_io_preq    => open,
      pcie_rxn               => pcie_rx_n,
      pcie_rxp               => pcie_rx_p,
      pcie_txn               => pcie_tx_n,
      pcie_txp               => pcie_tx_p,
      ref_clk                => ref_clk
      );



end struct;
