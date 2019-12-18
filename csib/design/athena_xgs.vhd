----------------------------------------------------------------------
-- DESCRIPTION: Athena XGS
--
-- Top level history:
-- =============================================
-- V0.1     : 
-- V0.2     : 
--
-- PROJECT: Iris-4
--
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;



entity athena_xgs is
  generic(
    FPGA_MAJOR_VERSION     : integer := 0;
    FPGA_MINOR_VERSION     : integer := 0;
    FPGA_SUB_MINOR_VERSION : integer := 0;
    FPGA_BUILD_DATE        : integer := 0;
    FPGA_IS_NPI_GOLDEN     : integer := 0;
    FPGA_DEVICE_ID         : integer := 0
    );
  port (
    ref_clk : in std_logic;

    ---------------------------------------------------------------------------
    -- Zynq PL : PCIe Interface
    ---------------------------------------------------------------------------
    pcie_sys_clk_n : in  std_logic;
    pcie_sys_clk_p : in  std_logic;
    sys_rst_n      : in  std_logic;     -- Platform reset
    pcie_rx_n      : in  std_logic_vector (1 to 0);
    pcie_rx_p      : in  std_logic_vector (1 to 0);
    pcie_tx_n      : out std_logic_vector (1 to 0);
    pcie_tx_p      : out std_logic_vector (1 to 0);


    ---------------------------------------------------------------------------
    -- HiSPi sensor interface
    ---------------------------------------------------------------------------
    hispi_data_n       : in std_logic_vector (5 downto 0);
    hispi_data_p       : in std_logic_vector (5 downto 0);
    hispi_serial_clk_n : in std_logic_vector (5 downto 0);
    hispi_serial_clk_p : in std_logic_vector (5 downto 0);

    ---------------------------------------------------------------------------
    --  FPGA FLASH SPI user interface
    ---------------------------------------------------------------------------
    spi_cs_n : inout std_logic;
    spi_sd   : inout std_logic_vector (3 downto 0)
    );
end athena_xgs;


architecture struct of athena_xgs is


  component system_pb_wrapper is
    port (
      PCIE_REFCLK_100MHz   : in    std_logic;
      PCIE_RESET_N         : in    std_logic;
      SPI_0_0_io0_io       : inout std_logic;
      SPI_0_0_io1_io       : inout std_logic;
      SPI_0_0_io2_io       : inout std_logic;
      SPI_0_0_io3_io       : inout std_logic;
      SPI_0_0_ss_io        : inout std_logic_vector (0 to 0);
      STARTUP_IO_0_cfgclk  : out   std_logic;
      STARTUP_IO_0_cfgmclk : out   std_logic;
      STARTUP_IO_0_eos     : out   std_logic;
      STARTUP_IO_0_preq    : out   std_logic;
      hispi_data_n_0       : in    std_logic_vector (5 downto 0);
      hispi_data_p_0       : in    std_logic_vector (5 downto 0);
      hispi_serial_clk_n_0 : in    std_logic_vector (5 downto 0);
      hispi_serial_clk_p_0 : in    std_logic_vector (5 downto 0);
      pcie_rxn             : in    std_logic_vector (1 downto 0);
      pcie_rxp             : in    std_logic_vector (1 downto 0);
      pcie_txn             : out   std_logic_vector (1 downto 0);
      pcie_txp             : out   std_logic_vector (1 downto 0);
      ref_clk              : in    std_logic
      );
  end component;


  constant PB_DEBUG_COM : std_logic := '0';

  signal UNCONNECTED  : std_logic_vector (53 downto 0);
  signal pcie_sys_clk : std_logic;
  signal spi_in       : std_logic_vector (3 downto 0);
  signal spi_out      : std_logic_vector (3 downto 0);
  signal spi_out_en   : std_logic_vector (3 downto 0);
  signal spi_cs_in    : std_logic_vector (0 to 0);
  signal spi_cs_out   : std_logic_vector (0 to 0);
  signal spi_cs_en    : std_logic;

begin

  -- Pour avoir access a la pin dedie du core PCIe, il faut instantier le IBUFDS_GTE2
  pcie_refclk_ibuf : IBUFDS_GTE2
    port map (
      O     => pcie_sys_clk,
      I     => pcie_sys_clk_p,
      IB    => pcie_sys_clk_n,
      CEB   => '0',
      ODIV2 => open
      );


  xsystem_pb_wrapper : system_pb_wrapper
    port map(
      PCIE_REFCLK_100MHz   => pcie_sys_clk,
      PCIE_RESET_N         => sys_rst_n,
      SPI_0_0_io0_io       => spi_sd(0),
      SPI_0_0_io1_io       => spi_sd(1),
      SPI_0_0_io2_io       => spi_sd(2),
      SPI_0_0_io3_io       => spi_sd(3),
      SPI_0_0_ss_io(0)     => spi_cs_n,
      STARTUP_IO_0_cfgclk  => open,
      STARTUP_IO_0_cfgmclk => open,
      STARTUP_IO_0_eos     => open,
      STARTUP_IO_0_preq    => open,
      hispi_data_n_0       => hispi_data_n,
      hispi_data_p_0       => hispi_data_p,
      hispi_serial_clk_n_0 => hispi_serial_clk_n,
      hispi_serial_clk_p_0 => hispi_serial_clk_p,
      pcie_rxn             => pcie_rx_n,
      pcie_rxp             => pcie_rx_p,
      pcie_txn             => pcie_tx_n,
      pcie_txp             => pcie_tx_p,
      ref_clk              => ref_clk
      );


end struct;
