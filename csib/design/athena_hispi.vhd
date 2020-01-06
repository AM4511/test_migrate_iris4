----------------------------------------------------------------------
-- DESCRIPTION: Matrox IO Expander FPGA (MIOX)
--
-- Top level history:
-- =============================================
-- V0.1     : First PCB itteration
-- V0.2     ; Fixed the PS section IO names
--
-- PROJECT: 4Sight-EV6
--
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;


entity csib_athena_hispi is
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
    hispi_data_n_0       : in std_logic_vector (5 downto 0);
    hispi_data_p_0       : in std_logic_vector (5 downto 0);
    hispi_serial_clk_n_0 : in std_logic_vector (5 downto 0);
    hispi_serial_clk_p_0 : in std_logic_vector (5 downto 0);

    ---------------------------------------------------------------------------
    --  FPGA FLASH SPI user interface
    ---------------------------------------------------------------------------
    spi_cs_n : inout std_logic;
    spi_sd   : inout std_logic_vector (3 downto 0);
    --spi_sdin  : inout std_logic_vector (3 downto 0);


    ---------------------------------------------------------------------------
    --  FPGA USER IO interface
    ---------------------------------------------------------------------------
    user_data_in  : in  std_logic_vector(3 downto 0);
    user_data_out : out std_logic_vector(2 downto 0)
    );
end csib_athena_hispi;


architecture struct of csib_athena_hispi is


  component system_pb_wrapper is
    port (
      PCIE_REFCLK_100MHz      : in    std_logic;
      PCIE_RESET_N            : in    std_logic;
      SPI_0_0_io0_io          : inout std_logic;
      SPI_0_0_io1_io          : inout std_logic;
      SPI_0_0_io2_io          : inout std_logic;
      SPI_0_0_io3_io          : inout std_logic;
      SPI_0_0_ss_io           : inout std_logic_vector (0 to 0);
      STARTUP_IO_0_cfgclk     : out   std_logic;
      STARTUP_IO_0_cfgmclk    : out   std_logic;
      STARTUP_IO_0_eos        : out   std_logic;
      STARTUP_IO_0_preq       : out   std_logic;
      ext_sync_0_ext_sync_en  : out   std_logic;
      ext_sync_0_ext_sync_in  : in    std_logic;
      ext_sync_0_ext_sync_out : out   std_logic;
      hispi_data_n_0          : in    std_logic_vector (5 downto 0);
      hispi_data_p_0          : in    std_logic_vector (5 downto 0);
      hispi_serial_clk_n_0    : in    std_logic_vector (5 downto 0);
      hispi_serial_clk_p_0    : in    std_logic_vector (5 downto 0);
      pcie_rxn                : in    std_logic_vector (1 downto 0);
      pcie_rxp                : in    std_logic_vector (1 downto 0);
      pcie_txn                : out   std_logic_vector (1 downto 0);
      pcie_txp                : out   std_logic_vector (1 downto 0);
      ref_clk                 : in    std_logic;
      user_data_in            : in    std_logic_vector (3 downto 0);
      user_data_out           : out   std_logic_vector (2 downto 0)
      );
  end component;


  constant PB_DEBUG_COM : std_logic := '0';

  signal UNCONNECTED  : std_logic_vector (53 downto 0);
  signal pcie_sys_clk : std_logic;
  -- signal ncsi_clk_out              : std_logic;
  -- signal uart0_transmission_active : std_logic;
  -- signal lpc_clk_24MHz_bufg        : std_logic;
  -- signal nclk_ce                   : std_logic := '1';
  -- signal nclk_d1                   : std_logic := '1';
  -- signal nclk_d2                   : std_logic := '0';
  -- signal nclk_rst                  : std_logic := '0';
  -- signal nclk_set                  : std_logic := '0';
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
      PCIE_REFCLK_100MHz      => pcie_sys_clk,
      PCIE_RESET_N            => sys_rst_n,
      SPI_0_0_io0_io          => spi_sd(0),
      SPI_0_0_io1_io          => spi_sd(1),
      SPI_0_0_io2_io          => spi_sd(2),
      SPI_0_0_io3_io          => spi_sd(3),
      SPI_0_0_ss_io(0)        => spi_cs_n,
      ext_sync_0_ext_sync_en  => open,
      ext_sync_0_ext_sync_in  => '0',
      ext_sync_0_ext_sync_out => open,
      hispi_data_n_0          => hispi_data_n_0,
      hispi_data_p_0          => hispi_data_p_0,
      hispi_serial_clk_n_0    => hispi_serial_clk_n_0,
      hispi_serial_clk_p_0    => hispi_serial_clk_p_0,
      user_data_in            => user_data_in,
      user_data_out           => user_data_out,
      STARTUP_IO_0_cfgclk     => open,
      STARTUP_IO_0_cfgmclk    => open,
      STARTUP_IO_0_eos        => open,
      STARTUP_IO_0_preq       => open,

      pcie_rxn => pcie_rx_n,
      pcie_rxp => pcie_rx_p,
      pcie_txn => pcie_tx_n,
      pcie_txp => pcie_tx_p,
      ref_clk  => ref_clk
      );



  -- G_spi_data_buff : for i in 0 to 3 generate
  --   spi_sdout(i) <= spi_out(i) when (spi_out_en(i) = '1') else
  --                   'Z';

  -- end generate G_spi_data_buff;

  -- spi_in <= spi_sdin;

  -- spi_cs_n <= spi_cs_out(0) when (spi_cs_en = '1') else
  --             'Z';

  -- spi_cs_in(0) <= spi_cs_n;

end struct;
