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
    ---------------------------------------------------------------------------
    -- Zynq PS :
    ---------------------------------------------------------------------------
    -- ps_clk   : inout std_logic;
    -- ps_porb  : inout std_logic;
    -- ps_srstb : inout std_logic;
    --mio      : inout std_logic_vector (6 downto 1);


    ---------------------------------------------------------------------------
    -- Zynq PS : DDR2 interface
    ---------------------------------------------------------------------------
    -- ddr_vrn     : inout std_logic;
    -- ddr_vrp     : inout std_logic;
    -- ddr_addr    : inout std_logic_vector (14 downto 0);
    -- ddr_ba      : inout std_logic_vector (2 downto 0);
    -- ddr_cas_n   : inout std_logic;
    -- ddr_ck_n    : inout std_logic;
    -- ddr_ck_p    : inout std_logic;
    -- ddr_cke     : inout std_logic;
    -- ddr_cs_n    : inout std_logic;
    -- ddr_dm      : inout std_logic_vector (3 downto 0);
    -- ddr_dq      : inout std_logic_vector (31 downto 0);
    -- ddr_dqs_n   : inout std_logic_vector (3 downto 0);
    -- ddr_dqs_p   : inout std_logic_vector (3 downto 0);
    -- ddr_odt     : inout std_logic;
    -- ddr_ras_n   : inout std_logic;
    -- ddr_reset_n : inout std_logic;
    -- ddr_we_n    : inout std_logic;


    ---------------------------------------------------------------------------
    -- Zynq PL : PCIe Interface
    ---------------------------------------------------------------------------
    -- pcie_sys_clk_n : in  std_logic;
    -- pcie_sys_clk_p : in  std_logic;
    -- sys_rst_n      : in  std_logic;     -- Platform reset
    -- pcie_rx_n      : in  std_logic;
    -- pcie_rx_p      : in  std_logic;
    -- pcie_tx_n      : out std_logic;
    -- pcie_tx_p      : out std_logic;


    ---------------------------------------------------------------------------
    -- HiSPi sensor interface
    ---------------------------------------------------------------------------
    -- hispi_data_n_0       : in std_logic_vector (5 downto 0);
    -- hispi_data_p_0       : in std_logic_vector (5 downto 0);
    -- hispi_serial_clk_n_0 : in std_logic_vector (5 downto 0);
    -- hispi_serial_clk_p_0 : in std_logic_vector (5 downto 0);

    ---------------------------------------------------------------------------
    -- Zynq PL :  Debug uart
    ---------------------------------------------------------------------------
    -- uart_ctsn : in  std_logic;
    -- uart_dcdn : in  std_logic;
    -- uart_dsrn : in  std_logic;
    -- uart_dtrn : out std_logic;
    -- uart_ri   : in  std_logic;
    -- uart_rtsn : out std_logic;
    -- uart_rxd  : in  std_logic;
    -- uart_txd  : out std_logic;

    ---------------------------------------------------------------------------
    -- Zynq PL : misc
    ---------------------------------------------------------------------------
    -- fpga_rsvd       : in  std_logic_vector(3 downto 0);
    -- sw_diag_n       : in  std_logic;    -- Not implemented (backdoor)
    -- host_proc_hot_n : in  std_logic;
    -- fpga_led        : out std_logic;    -- TBD!!! (debug)

    -- Vp_Vn_0_v_n : in std_logic;
    -- Vp_Vn_0_v_p : in std_logic;

    ---------------------------------------------------------------------------
    --  FPGA USER IO interface
    ---------------------------------------------------------------------------
    user_data_in  : in  std_logic_vector(3 downto 0);
    user_data_out : out std_logic_vector(2 downto 0);

    --------------------------------------------------
    -- Profinet port 1
    --------------------------------------------------
    profinet_led_in  : in  std_logic_vector (1 downto 0);
    profinet_led_out : out std_logic_vector (1 downto 0);
    profinet_clk     : out std_logic;
    profinet_crs_dv  : in  std_logic;
    profinet_rxd     : in  std_logic_vector (1 downto 0);
    profinet_tx_en   : out std_logic;
    profinet_txd     : out std_logic_vector (1 downto 0)

    );
end csib_top;


architecture struct of csib_top is


  component system_pb_wrapper is
    port (
      ext_sync_0_ext_sync_en  : out std_logic;
      ext_sync_0_ext_sync_in  : in  std_logic;
      ext_sync_0_ext_sync_out : out std_logic;
      ncsi_clk_out            : out std_logic;
      profinet_crs_dv         : in  std_logic;
      profinet_rx_er          : in  std_logic;
      profinet_rxd            : in  std_logic_vector (1 downto 0);
      profinet_tx_en          : out std_logic;
      profinet_txd            : out std_logic_vector (1 downto 0);
      user_data_in            : in  std_logic_vector (3 downto 0);
      user_data_out           : out std_logic_vector (2 downto 0)
      );
  end component;


  constant PB_DEBUG_COM : std_logic := '0';

  signal UNCONNECTED               : std_logic_vector (53 downto 0);
  signal pcie_sys_clk              : std_logic;
  signal ncsi_clk_out              : std_logic;
  signal uart0_transmission_active : std_logic;
  signal lpc_clk_24MHz_bufg        : std_logic;
  signal nclk_ce                   : std_logic := '1';
  signal nclk_d1                   : std_logic := '1';
  signal nclk_d2                   : std_logic := '0';
  signal nclk_rst                  : std_logic := '0';
  signal nclk_set                  : std_logic := '0';

begin


  xsystem_pb_wrapper : system_pb_wrapper
    port map(
      ext_sync_0_ext_sync_en  => open,
      ext_sync_0_ext_sync_in  => '0',
      ext_sync_0_ext_sync_out => open,
      ncsi_clk_out            => ncsi_clk_out,
      profinet_crs_dv         => profinet_crs_dv,
      profinet_rx_er          => '0',
      profinet_rxd            => profinet_rxd,
      profinet_tx_en          => profinet_tx_en,
      profinet_txd            => profinet_txd,
      user_data_in            => user_data_in,
      user_data_out           => user_data_out
      );


  -- xsystem_pb_wrapper : system_pb_wrapper
  --   port map(
  --     PCIE_REFCLK_100MHz        => pcie_sys_clk,
  --     PCIE_RESET_N              => sys_rst_n,
  --     ddr_addr                  => ddr_addr,
  --     ddr_ba                    => ddr_ba,
  --     ddr_cas_n                 => ddr_cas_n,
  --     ddr_ck_n                  => ddr_ck_n,
  --     ddr_ck_p                  => ddr_ck_p,
  --     ddr_cke                   => ddr_cke,
  --     ddr_cs_n                  => ddr_cs_n,
  --     ddr_dm                    => ddr_dm,
  --     ddr_dq                    => ddr_dq,
  --     ddr_dqs_n                 => ddr_dqs_n,
  --     ddr_dqs_p                 => ddr_dqs_p,
  --     ddr_odt                   => ddr_odt,
  --     ddr_ras_n                 => ddr_ras_n,
  --     ddr_reset_n               => ddr_reset_n,
  --     ddr_we_n                  => ddr_we_n,
  --     ext_sync_0_ext_sync_en    => open,
  --     ext_sync_0_ext_sync_in    => '0',
  --     ext_sync_0_ext_sync_out   => open,
  --     fixed_io_ddr_vrn          => ddr_vrn,
  --     fixed_io_ddr_vrp          => ddr_vrp,
  --     fixed_io_mio(0)           => unconnected(0),
  --     fixed_io_mio(6 downto 1)  => mio(6 downto 1),
  --     fixed_io_mio(53 downto 7) => unconnected(53 downto 7),
  --     fixed_io_ps_clk           => ps_clk,
  --     fixed_io_ps_porb          => ps_porb,
  --     fixed_io_ps_srstb         => ps_srstb,
  --     hispi_data_n_0            => hispi_data_n_0,
  --     hispi_data_p_0            => hispi_data_p_0,
  --     hispi_serial_clk_n_0      => hispi_serial_clk_n_0,
  --     hispi_serial_clk_p_0      => hispi_serial_clk_p_0,
  --     ncsi_clk_out              => ncsi_clk_out,
  --     pcie_rxn(0)               => pcie_rx_n,
  --     pcie_rxp(0)               => pcie_rx_p,
  --     pcie_txn(0)               => pcie_tx_n,
  --     pcie_txp(0)               => pcie_tx_p,
  --     profinet_crs_dv           => profinet_crs_dv,
  --     profinet_rx_er            => '0',
  --     profinet_rxd              => profinet_rxd,
  --     profinet_tx_en            => profinet_tx_en,
  --     profinet_txd              => profinet_txd,
  --     uart_ctsn                 => uart_ctsn,
  --     uart_dcdn                 => uart_dcdn,
  --     uart_dsrn                 => uart_dsrn,
  --     uart_dtrn                 => uart_dtrn,
  --     uart_ri                   => uart_ri,
  --     uart_rtsn                 => uart_rtsn,
  --     uart_rxd                  => uart_rxd,
  --     uart_txd                  => uart_txd,
  --     user_data_in              => user_data_in,
  --     user_data_out             => user_data_out
  --     );


  oddrbuff_profinet_ncsi_clk : ODDR
    generic map(
      DDR_CLK_EDGE => "OPPOSITE_EDGE",
      INIT         => '0',
      SRTYPE       => "SYNC")
    port map (
      Q  => profinet_clk,
      C  => ncsi_clk_out,               -- 1-bit clock input
      CE => nclk_ce,                    -- 1-bit clock enable input
      D1 => nclk_d1,                    -- 1-bit data input (positive edge)
      D2 => nclk_d2,                    -- 1-bit data input (negative edge)
      R  => nclk_rst,                   -- 1-bit reset input
      S  => nclk_set                    -- 1-bit set input
      );



  nclk_rst <= '0';
  nclk_set <= '0';

  profinet_led_out <= profinet_led_in;


end struct;
