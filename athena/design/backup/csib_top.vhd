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


entity csib_top is
  generic(
    FPGA_MAJOR_VERSION     : integer := 0;
    FPGA_MINOR_VERSION     : integer := 0;
    FPGA_SUB_MINOR_VERSION : integer := 0;
    FPGA_BUILD_DATE        : integer := 0;
    FPGA_IS_NPI_GOLDEN     : integer := 0;
    FPGA_DEVICE_ID         : integer := 0
    );
  port (
    ref_clk           : in    std_logic;
    fixed_io_mio      : inout std_logic_vector (53 downto 0);
    fixed_io_ps_clk   : inout std_logic;
    fixed_io_ps_porb  : inout std_logic;
    fixed_io_ps_srstb : inout std_logic;

    ---------------------------------------------------------------------------
    -- HyperBus interface
    ---------------------------------------------------------------------------
    RPC_CK             : out   std_logic;
    RPC_CK_N           : out   std_logic;
    RPC_CS0_N          : out   std_logic;
    RPC_CS1_N          : out   std_logic;
    RPC_DQ             : inout std_logic_vector (7 downto 0);
    RPC_INT_N          : in    std_logic;
    RPC_RESET_N        : out   std_logic;
    RPC_RSTO_N         : in    std_logic;
    RPC_RWDS           : inout std_logic;
    RPC_WP_N           : out   std_logic;
    
    ---------------------------------------------------------------------------
    -- HiSPi sensor interface
    ---------------------------------------------------------------------------
    hispi_data_n       : in    std_logic_vector (5 downto 0);
    hispi_data_p       : in    std_logic_vector (5 downto 0);
    hispi_serial_clk_n : in    std_logic_vector (5 downto 0);
    hispi_serial_clk_p : in    std_logic_vector (5 downto 0);

    ---------------------------------------------------------------------------
    -- Zynq PL : PCIe Interface
    ---------------------------------------------------------------------------
    pcie_reset_n  : in  std_logic;
    pcie_refclk_p : in  std_logic;
    pcie_refclk_n : in  std_logic;
    pcie_rxn      : in  std_logic_vector (1 downto 0);
    pcie_rxp      : in  std_logic_vector (1 downto 0);
    pcie_txn      : out std_logic_vector (1 downto 0);
    pcie_txp      : out std_logic_vector (1 downto 0);

    ---------------------------------------------------------------------------
    -- Profinet
    ---------------------------------------------------------------------------
    ncsi_clk_out    : out std_logic;
    profinet_crs_dv : in  std_logic;
    profinet_rx_er  : in  std_logic;
    profinet_rxd    : in  std_logic_vector (1 downto 0);
    profinet_tx_en  : out std_logic;
    profinet_txd    : out std_logic_vector (1 downto 0);

    ---------------------------------------------------------------------------
    -- Profinet
    ---------------------------------------------------------------------------
    uart_ctsn : in  std_logic;
    uart_dcdn : in  std_logic;
    uart_dsrn : in  std_logic;
    uart_dtrn : out std_logic;
    uart_ri   : in  std_logic;
    uart_rtsn : out std_logic;
    uart_rxd  : in  std_logic;
    uart_txd  : out std_logic;

    ---------------------------------------------------------------------------
    -- MTX advance IO
    ---------------------------------------------------------------------------
    user_data_in  : in  std_logic_vector (3 downto 0);
    user_data_out : out std_logic_vector (2 downto 0)
    );
end csib_top;


architecture struct of csib_top is


  component system_pb_wrapper is
    port (
      RPC_CK                : out   std_logic;
      RPC_CK_N              : out   std_logic;
      RPC_CS0_N             : out   std_logic;
      RPC_CS1_N             : out   std_logic;
      RPC_DQ                : inout std_logic_vector (7 downto 0);
      RPC_INT_N             : in    std_logic;
      RPC_RESET_N           : out   std_logic;
      RPC_RSTO_N            : in    std_logic;
      RPC_RWDS              : inout std_logic;
      RPC_WP_N              : out   std_logic;
      ext_sync_ext_sync_en  : out   std_logic;
      ext_sync_ext_sync_in  : in    std_logic;
      ext_sync_ext_sync_out : out   std_logic;
      fixed_io_mio          : inout std_logic_vector (53 downto 0);
      fixed_io_ps_clk       : inout std_logic;
      fixed_io_ps_porb      : inout std_logic;
      fixed_io_ps_srstb     : inout std_logic;
      hispi_data_n          : in    std_logic_vector (5 downto 0);
      hispi_data_p          : in    std_logic_vector (5 downto 0);
      hispi_serial_clk_n    : in    std_logic_vector (5 downto 0);
      hispi_serial_clk_p    : in    std_logic_vector (5 downto 0);
      ncsi_clk_out          : out   std_logic;
      pcie_refclk_100MHz    : in    std_logic;
      pcie_reset_n          : in    std_logic;
      pcie_rxn              : in    std_logic_vector (1 downto 0);
      pcie_rxp              : in    std_logic_vector (1 downto 0);
      pcie_txn              : out   std_logic_vector (1 downto 0);
      pcie_txp              : out   std_logic_vector (1 downto 0);
      profinet_crs_dv       : in    std_logic;
      profinet_rx_er        : in    std_logic;
      profinet_rxd          : in    std_logic_vector (1 downto 0);
      profinet_tx_en        : out   std_logic;
      profinet_txd          : out   std_logic_vector (1 downto 0);
      uart_ctsn             : in    std_logic;
      uart_dcdn             : in    std_logic;
      uart_dsrn             : in    std_logic;
      uart_dtrn             : out   std_logic;
      uart_ri               : in    std_logic;
      uart_rtsn             : out   std_logic;
      uart_rxd              : in    std_logic;
      uart_txd              : out   std_logic;
      user_data_in          : in    std_logic_vector (3 downto 0);
      user_data_out         : out   std_logic_vector (2 downto 0)
      );
  end component;


  -- constant PB_DEBUG_COM : std_logic := '0';

  -- signal UNCONNECTED  : std_logic_vector (53 downto 0);
  -- signal pcie_sys_clk : std_logic;
  -- signal spi_in       : std_logic_vector (3 downto 0);
  -- signal spi_out      : std_logic_vector (3 downto 0);
  -- signal spi_out_en   : std_logic_vector (3 downto 0);
  -- signal spi_cs_in    : std_logic_vector (0 to 0);
  -- signal spi_cs_out   : std_logic_vector (0 to 0);
  -- signal spi_cs_en    : std_logic;
  signal pcie_refclk_100MHz : std_logic;

begin

  -- Pour avoir access a la pin dedie du core PCIe, il faut instantier le IBUFDS_GTE2
  pcie_refclk_ibuf : IBUFDS_GTE2
    port map (
      O     => pcie_refclk_100MHz,
      I     => pcie_refclk_p,
      IB    => pcie_refclk_n,
      CEB   => '0',
      ODIV2 => open
      );


  xsystem_pb_wrapper : system_pb_wrapper
    port map(
      RPC_CK                => RPC_CK,
      RPC_CK_N              => RPC_CK_N,
      RPC_CS0_N             => RPC_CS0_N,
      RPC_CS1_N             => RPC_CS1_N,
      RPC_DQ                => RPC_DQ,
      RPC_INT_N             => RPC_INT_N,
      RPC_RESET_N           => RPC_RESET_N,
      RPC_RSTO_N            => RPC_RSTO_N,
      RPC_RWDS              => RPC_RWDS,
      RPC_WP_N              => RPC_WP_N,
      ext_sync_ext_sync_en  => open,
      ext_sync_ext_sync_in  => '0',
      ext_sync_ext_sync_out => open,
      fixed_io_mio          => fixed_io_mio,
      fixed_io_ps_clk       => fixed_io_ps_clk,
      fixed_io_ps_porb      => fixed_io_ps_porb,
      fixed_io_ps_srstb     => fixed_io_ps_srstb,
      hispi_data_n          => hispi_data_n,
      hispi_data_p          => hispi_data_p,
      hispi_serial_clk_n    => hispi_serial_clk_n,
      hispi_serial_clk_p    => hispi_serial_clk_p,
      ncsi_clk_out          => ncsi_clk_out,
      pcie_refclk_100MHz    => pcie_refclk_100MHz,
      pcie_reset_n          => pcie_reset_n,
      pcie_rxn              => pcie_rxn,
      pcie_rxp              => pcie_rxp,
      pcie_txn              => pcie_txn,
      pcie_txp              => pcie_txp,
      profinet_crs_dv       => profinet_crs_dv,
      profinet_rx_er        => profinet_rx_er,
      profinet_rxd          => profinet_rxd,
      profinet_tx_en        => profinet_tx_en,
      profinet_txd          => profinet_txd,
      uart_ctsn             => uart_ctsn,
      uart_dcdn             => uart_dcdn,
      uart_dsrn             => uart_dsrn,
      uart_dtrn             => uart_dtrn,
      uart_ri               => uart_ri,
      uart_rtsn             => uart_rtsn,
      uart_rxd              => uart_rxd,
      uart_txd              => uart_txd,
      user_data_in          => user_data_in,
      user_data_out         => user_data_out
      );

end struct;
