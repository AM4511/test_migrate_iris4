----------------------------------------------------------------------
-- DESCRIPTION: Athena XGS
--
-- Top level history:
-- =============================================
-- V0.1     : 
-- V0.2     : 
--
-- PROJECT: Iris-4
--D:/git/gitlab/iris4/csib/vivado/2019.1/csib_xczu2cg_1574439982/csib_xczu2cg_1574439982.srcs/sources_1/bd/system_pb/hdl/system_pb_wrapper.vhd
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;


entity csib_xc7a50t is
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
    --  Profinet NCSI
    ---------------------------------------------------------------------------
    rmii_crs_dv : in  std_logic;
    rmii_rx_er  : in  std_logic;
    rmii_rxd    : in  std_logic_vector (1 downto 0);
    rmii_tx_en  : out std_logic;
    rmii_txd    : out std_logic_vector (1 downto 0);

    ---------------------------------------------------------------------------
    --  FPGA FLASH SPI user interface
    ---------------------------------------------------------------------------
    spi_cs_n : inout std_logic;
    spi_sd   : inout std_logic_vector (3 downto 0);

    ---------------------------------------------------------------------------
    --  UART
    ---------------------------------------------------------------------------
    uart_rxd : in  std_logic;
    uart_txd : out std_logic;

    ---------------------------------------------------------------------------
    -- MTX advance IO
    ---------------------------------------------------------------------------
    user_data_in  : in  std_logic_vector (3 downto 0);
    user_data_out : out std_logic_vector (2 downto 0)

    );
end csib_xc7a50t;


architecture struct of csib_xc7a50t is


  component system_pb_wrapper is
    port (
    GPO_0 : out STD_LOGIC_VECTOR ( 1 downto 0 );
    IENOn_0 : out STD_LOGIC;
    RPC_CK_0 : out STD_LOGIC;
    RPC_CK_N_0 : out STD_LOGIC;
    RPC_CS0_N_0 : out STD_LOGIC;
    RPC_CS1_N_0 : out STD_LOGIC;
    RPC_DQ_0 : inout STD_LOGIC_VECTOR ( 7 downto 0 );
    RPC_RESET_N_0 : out STD_LOGIC;
    RPC_RWDS_0 : inout STD_LOGIC;
    RPC_WP_N_0 : out STD_LOGIC;
    ext_rst_n : in STD_LOGIC;
    ext_sync_ext_sync_en : out STD_LOGIC;
    ext_sync_ext_sync_in : in STD_LOGIC;
    ext_sync_ext_sync_out : out STD_LOGIC;
    hispi_data_n : in STD_LOGIC_VECTOR ( 5 downto 0 );
    hispi_data_p : in STD_LOGIC_VECTOR ( 5 downto 0 );
    hispi_serial_clk_n : in STD_LOGIC_VECTOR ( 5 downto 0 );
    hispi_serial_clk_p : in STD_LOGIC_VECTOR ( 5 downto 0 );
    pcie_refclk_100MHz : in STD_LOGIC;
    pcie_rxn : in STD_LOGIC_VECTOR ( 1 downto 0 );
    pcie_rxp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    pcie_txn : out STD_LOGIC_VECTOR ( 1 downto 0 );
    pcie_txp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    ref_clk_100MHz : in STD_LOGIC;
    rmii_crs_dv : in STD_LOGIC;
    rmii_rx_er : in STD_LOGIC;
    rmii_rxd : in STD_LOGIC_VECTOR ( 1 downto 0 );
    rmii_tx_en : out STD_LOGIC;
    rmii_txd : out STD_LOGIC_VECTOR ( 1 downto 0 );
    spi_io0_io : inout STD_LOGIC;
    spi_io1_io : inout STD_LOGIC;
    spi_io2_io : inout STD_LOGIC;
    spi_io3_io : inout STD_LOGIC;
    spi_ss_io : inout STD_LOGIC_VECTOR ( 0 to 0 );
    startup_io_cfgclk : out STD_LOGIC;
    startup_io_cfgmclk : out STD_LOGIC;
    startup_io_eos : out STD_LOGIC;
    startup_io_preq : out STD_LOGIC;
    uart_rxd : in STD_LOGIC;
    uart_txd : out STD_LOGIC;
    user_data_in : in STD_LOGIC_VECTOR ( 3 downto 0 );
    user_data_out : out STD_LOGIC_VECTOR ( 2 downto 0 )
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
      pcie_refclk_100MHz    => pcie_sys_clk,
      ext_rst_n             => sys_rst_n,
      spi_io0_io            => spi_sd(0),
      spi_io1_io            => spi_sd(1),
      spi_io2_io            => spi_sd(2),
      spi_io3_io            => spi_sd(3),
      spi_ss_io(0)          => spi_cs_n,
      startup_io_cfgclk     => open,
      startup_io_cfgmclk    => open,
      startup_io_eos        => open,
      startup_io_preq       => open,
      uart_rxd              => uart_rxd,
      uart_txd              => uart_txd,
      ext_sync_ext_sync_en  => open,
      ext_sync_ext_sync_in  => '0',
      ext_sync_ext_sync_out => open,
      hispi_data_n          => hispi_data_n,
      hispi_data_p          => hispi_data_p,
      hispi_serial_clk_n    => hispi_serial_clk_n,
      hispi_serial_clk_p    => hispi_serial_clk_p,
      pcie_rxn              => pcie_rx_n,
      pcie_rxp              => pcie_rx_p,
      pcie_txn              => pcie_tx_n,
      pcie_txp              => pcie_tx_p,
      ref_clk_100MHz        => ref_clk,
      rmii_crs_dv           => rmii_crs_dv,
      rmii_rx_er            => rmii_rx_er,
      rmii_rxd              => rmii_rxd,
      rmii_tx_en            => rmii_tx_en,
      rmii_txd              => rmii_txd,
      user_data_in          => user_data_in,
      user_data_out         => user_data_out
      );

end struct;
