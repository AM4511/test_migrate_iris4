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
    ps_clk   : inout std_logic;
    ps_porb  : inout std_logic;
    ps_srstb : inout std_logic;
    mio      : inout std_logic_vector (6 downto 1);


    ---------------------------------------------------------------------------
    -- Zynq PS : DDR2 interface
    ---------------------------------------------------------------------------
    ddr_vrn     : inout std_logic;
    ddr_vrp     : inout std_logic;
    ddr_addr    : inout std_logic_vector (14 downto 0);
    ddr_ba      : inout std_logic_vector (2 downto 0);
    ddr_cas_n   : inout std_logic;
    ddr_ck_n    : inout std_logic;
    ddr_ck_p    : inout std_logic;
    ddr_cke     : inout std_logic;
    ddr_cs_n    : inout std_logic;
    ddr_dm      : inout std_logic_vector (3 downto 0);
    ddr_dq      : inout std_logic_vector (31 downto 0);
    ddr_dqs_n   : inout std_logic_vector (3 downto 0);
    ddr_dqs_p   : inout std_logic_vector (3 downto 0);
    ddr_odt     : inout std_logic;
    ddr_ras_n   : inout std_logic;
    ddr_reset_n : inout std_logic;
    ddr_we_n    : inout std_logic;


    ---------------------------------------------------------------------------
    -- Zynq PL : PCIe Interface
    ---------------------------------------------------------------------------
    pcie_sys_clk_n : in  std_logic;
    pcie_sys_clk_p : in  std_logic;
    sys_rst_n      : in  std_logic;     -- Platform reset
    pcie_rx_n      : in  std_logic;
    pcie_rx_p      : in  std_logic;
    pcie_tx_n      : out std_logic;
    pcie_tx_p      : out std_logic;


    ---------------------------------------------------------------------------
    -- Zynq PL : LPC Interface
    ---------------------------------------------------------------------------
    lpc_clk_24MHz : in    std_logic;
    lpc_frame_n   : in    std_logic;
    lpc_ad        : inout std_logic_vector(3 downto 0);
    serirq        : inout std_logic;


    ---------------------------------------------------------------------------
    -- Zynq PL : COM1 (RS485/RS-232)
    ---------------------------------------------------------------------------
    com1_rts_n : out std_logic;
    com1_txd   : out std_logic;
    com1_rxd   : in  std_logic;
    com1_cts_n : in  std_logic;

    -- RS485 buffer controls
    com1_rs485 : in  std_logic;
    com1_dxen  : out std_logic;
    com1_rxen  : out std_logic;


    ---------------------------------------------------------------------------
    -- Zynq PL :  COM2
    ---------------------------------------------------------------------------
    com2_txd   : out std_logic;
    com2_dsr_n : in  std_logic;
    com2_cts_n : in  std_logic;
    com2_dcd_n : in  std_logic;
    com2_dtr_n : out std_logic;
    com2_rxd   : in  std_logic;
    com2_rts_n : out std_logic;
    com2_ri_n  : in  std_logic;


    ---------------------------------------------------------------------------
    -- Zynq PL : misc
    ---------------------------------------------------------------------------
    fpga_rsvd       : in  std_logic_vector(3 downto 0);
    sw_diag_n       : in  std_logic;    -- Not implemented (backdoor)
    host_proc_hot_n : in  std_logic;
    fpga_led        : out std_logic;    -- TBD!!! (debug)

    Vp_Vn_0_v_n : in std_logic;
    Vp_Vn_0_v_p : in std_logic;

    ---------------------------------------------------------------------------
    --  FPGA USER IO interface
    ---------------------------------------------------------------------------
    user_data_in  : in  std_logic_vector(7 downto 0);
    user_data_out : out std_logic_vector(7 downto 0);

    --------------------------------------------------
    -- NCSI for trigger over Ethernet (ToE) 
    --------------------------------------------------
    lan1_sdp         : inout std_logic_vector (3 downto 0);
    lan1_ncsi_clk    : out   std_logic;
    lan1_ncsi_crs_dv : in    std_logic;
    lan1_ncsi_rxd    : in    std_logic_vector (1 downto 0);
    lan1_ncsi_tx_en  : out   std_logic;
    lan1_ncsi_txd    : out   std_logic_vector (1 downto 0);

    lan2_sdp         : inout std_logic_vector (3 downto 0);
    lan2_ncsi_clk    : out   std_logic;
    lan2_ncsi_crs_dv : in    std_logic;
    lan2_ncsi_rxd    : in    std_logic_vector (1 downto 0);
    lan2_ncsi_tx_en  : out   std_logic;
    lan2_ncsi_txd    : out   std_logic_vector (1 downto 0);

    lan3_sdp         : inout std_logic_vector (3 downto 0);
    lan3_ncsi_clk    : out   std_logic;
    lan3_ncsi_crs_dv : in    std_logic;
    lan3_ncsi_rxd    : in    std_logic_vector (1 downto 0);
    lan3_ncsi_tx_en  : out   std_logic;
    lan3_ncsi_txd    : out   std_logic_vector (1 downto 0);

    lan4_sdp         : inout std_logic_vector (3 downto 0);
    lan4_ncsi_clk    : out   std_logic;
    lan4_ncsi_crs_dv : in    std_logic;
    lan4_ncsi_rxd    : in    std_logic_vector (1 downto 0);
    lan4_ncsi_tx_en  : out   std_logic;
    lan4_ncsi_txd    : out   std_logic_vector (1 downto 0);

    --------------------------------------------------
    -- Profinet port 1
    --------------------------------------------------
    profinet1_led_in      : in  std_logic_vector (1 downto 0);
    profinet1_led_out     : out std_logic_vector (1 downto 0);
    --profinet1_ncsi_clk    : out std_logic;
    profinet1_ncsi_crs_dv : in  std_logic;
    profinet1_ncsi_rxd    : in  std_logic_vector (1 downto 0);
    profinet1_ncsi_tx_en  : out std_logic;
    profinet1_ncsi_txd    : out std_logic_vector (1 downto 0);

    --------------------------------------------------
    -- Profinet port 2
    --------------------------------------------------
    profinet2_led_in      : in  std_logic_vector (1 downto 0);
    profinet2_led_out     : out std_logic_vector (1 downto 0);
    profinet2_ncsi_clk    : out std_logic;
    profinet2_ncsi_crs_dv : in  std_logic;
    profinet2_ncsi_rxd    : in  std_logic_vector (1 downto 0);
    profinet2_ncsi_tx_en  : out std_logic;
    profinet2_ncsi_txd    : out std_logic_vector (1 downto 0)
    );
end csib_top;



architecture struct of csib_top is


  component system_pb_wrapper is
    port (
      FPGA_Info_0_board_info         : in    std_logic_vector (3 downto 0);
      FPGA_Info_0_fpga_build_id      : in    std_logic_vector (31 downto 0);
      FPGA_Info_0_fpga_device_id     : in    std_logic_vector (7 downto 0);
      FPGA_Info_0_fpga_firmware_type : in    std_logic_vector (7 downto 0);
      FPGA_Info_0_fpga_major_ver     : in    std_logic_vector (7 downto 0);
      FPGA_Info_0_fpga_minor_ver     : in    std_logic_vector (7 downto 0);
      FPGA_Info_0_fpga_sub_minor_ver : in    std_logic_vector (7 downto 0);
      PCIE_REFCLK_100MHz             : in    std_logic;
      PCIE_RESET_N                   : in    std_logic;
      UART_0_ctsn                    : in    std_logic;
      UART_0_dcdn                    : in    std_logic;
      UART_0_dsrn                    : in    std_logic;
      UART_0_dtrn                    : out   std_logic;
      UART_0_out1n                   : out   std_logic;
      UART_0_out2n                   : out   std_logic;
      UART_0_ri                      : in    std_logic;
      UART_0_rtsn                    : out   std_logic;
      UART_0_rxd                     : in    std_logic;
      UART_0_txd                     : out   std_logic;
      UART_1_ctsn                    : in    std_logic;
      UART_1_dcdn                    : in    std_logic;
      UART_1_dsrn                    : in    std_logic;
      UART_1_dtrn                    : out   std_logic;
      UART_1_out1n                   : out   std_logic;
      UART_1_out2n                   : out   std_logic;
      UART_1_ri                      : in    std_logic;
      UART_1_rtsn                    : out   std_logic;
      UART_1_rxd                     : in    std_logic;
      UART_1_txd                     : out   std_logic;
      UART_DBG_ctsn                  : in    std_logic;
      UART_DBG_dcdn                  : in    std_logic;
      UART_DBG_dsrn                  : in    std_logic;
      UART_DBG_dtrn                  : out   std_logic;
      UART_DBG_ri                    : in    std_logic;
      UART_DBG_rtsn                  : out   std_logic;
      UART_DBG_rxd                   : in    std_logic;
      UART_DBG_txd                   : out   std_logic;
      Vp_Vn_0_v_n                    : in    std_logic;
      Vp_Vn_0_v_p                    : in    std_logic;
      ddr_addr                       : inout std_logic_vector (14 downto 0);
      ddr_ba                         : inout std_logic_vector (2 downto 0);
      ddr_cas_n                      : inout std_logic;
      ddr_ck_n                       : inout std_logic;
      ddr_ck_p                       : inout std_logic;
      ddr_cke                        : inout std_logic;
      ddr_cs_n                       : inout std_logic;
      ddr_dm                         : inout std_logic_vector (3 downto 0);
      ddr_dq                         : inout std_logic_vector (31 downto 0);
      ddr_dqs_n                      : inout std_logic_vector (3 downto 0);
      ddr_dqs_p                      : inout std_logic_vector (3 downto 0);
      ddr_odt                        : inout std_logic;
      ddr_ras_n                      : inout std_logic;
      ddr_reset_n                    : inout std_logic;
      ddr_we_n                       : inout std_logic;
      debug_in                       : in    std_logic_vector (31 downto 0);
      debug_out                      : out   std_logic_vector (31 downto 0);
      ext_sync_0_ext_sync_en         : out   std_logic;
      ext_sync_0_ext_sync_in         : in    std_logic;
      ext_sync_0_ext_sync_out        : out   std_logic;
      fixed_io_ddr_vrn               : inout std_logic;
      fixed_io_ddr_vrp               : inout std_logic;
      fixed_io_mio                   : inout std_logic_vector (53 downto 0);
      fixed_io_ps_clk                : inout std_logic;
      fixed_io_ps_porb               : inout std_logic;
      fixed_io_ps_srstb              : inout std_logic;
      lpc_lpc_ad                     : inout std_logic_vector (3 downto 0);
      lpc_lpc_clk                    : in    std_logic;
      lpc_lpc_frame_n                : in    std_logic;
      lpc_lpc_reset_n                : in    std_logic;
      lpc_serirq                     : inout std_logic;
      mtxSPI_0_spi_csn               : out   std_logic;
      mtxSPI_0_spi_sdin              : in    std_logic;
      mtxSPI_0_spi_sdout             : out   std_logic;
      ncsi_0_crs_dv                  : in    std_logic;
      ncsi_0_rx_er                   : in    std_logic;
      ncsi_0_rxd                     : in    std_logic_vector (1 downto 0);
      ncsi_0_tx_en                   : out   std_logic;
      ncsi_0_txd                     : out   std_logic_vector (1 downto 0);
      ncsi_1_crs_dv                  : in    std_logic;
      ncsi_1_rx_er                   : in    std_logic;
      ncsi_1_rxd                     : in    std_logic_vector (1 downto 0);
      ncsi_1_tx_en                   : out   std_logic;
      ncsi_1_txd                     : out   std_logic_vector (1 downto 0);
      ncsi_2_crs_dv                  : in    std_logic;
      ncsi_2_rx_er                   : in    std_logic;
      ncsi_2_rxd                     : in    std_logic_vector (1 downto 0);
      ncsi_2_tx_en                   : out   std_logic;
      ncsi_2_txd                     : out   std_logic_vector (1 downto 0);
      ncsi_3_crs_dv                  : in    std_logic;
      ncsi_3_rx_er                   : in    std_logic;
      ncsi_3_rxd                     : in    std_logic_vector (1 downto 0);
      ncsi_3_tx_en                   : out   std_logic;
      ncsi_3_txd                     : out   std_logic_vector (1 downto 0);
      ncsi_4_crs_dv                  : in    std_logic;
      ncsi_4_rx_er                   : in    std_logic;
      ncsi_4_rxd                     : in    std_logic_vector (1 downto 0);
      ncsi_4_tx_en                   : out   std_logic;
      ncsi_4_txd                     : out   std_logic_vector (1 downto 0);
      ncsi_5_crs_dv                  : in    std_logic;
      ncsi_5_rx_er                   : in    std_logic;
      ncsi_5_rxd                     : in    std_logic_vector (1 downto 0);
      ncsi_5_tx_en                   : out   std_logic;
      ncsi_5_txd                     : out   std_logic_vector (1 downto 0);
      ncsi_clk_out                   : out   std_logic;
      pcie_rxn                       : in    std_logic;
      pcie_rxp                       : in    std_logic;
      pcie_txn                       : out   std_logic;
      pcie_txp                       : out   std_logic;
      transmission_active_0          : out   std_logic;
      transmission_active_1          : out   std_logic;
      user_data_in                   : in    std_logic_vector (7 downto 0);
      user_data_out                  : out   std_logic_vector (7 downto 0)
      );
  end component;


  -----------------------------------------------------------------------------
  -- TBD:
  --
  -- Implement full duplex control in the register file
  -- This implements the duplex selection for the COM1.  This bit is only effective
  -- when the port operates RS485 mode, selected by an input pin controlled by the BIOS code.
  -- The default is the backward-compatible mode of full duplex.  In this mode, the RS-485
  -- driver enable is under software control with the RTS pin. The receiver is always enabled.

  -- In half duplex, the driver is automatically turned on when there is a character to send.
  -- Also, when we are driving the RS485 line, the input is masked so the receiving side of the
  -- UART does not see what is sent.
  --
  -- 0x0 : Full-duplex RS485 operation
  -- 0x1 : Half-duplex auto-rx-tx RS485 operation
  -----------------------------------------------------------------------------
  constant COM1_RS485_DUPLEX : std_logic := '0';


  -----------------------------------------------------------------------------
  -- TBD:
  --
  -- These bits are used to redirect Profiblaze UART output on physical COM
  -- port output.  This should be used for debugging purposes only.  The
  -- standard PC COM port remains in function, but its output cannot be
  -- seen on the TxD pin of the DE-9 connector.
  --
  -- Only GPM IvB FPGA uses both bits.  LSB is used for the Profiblaze
  -- associated with the WOL Ethernet port output on COM1.  MSB is used
  -- for the Profiblaze associated with the MoBo Ethernet port output on COM2.
  --
  -- On the GPM ByT, only the LSB is effective.
  --
  -- Profiblaze UART is hardcoded to 115200 bps, 8 data bit, no parity,
  -- 1 stop bit.
  --
  --  0x0 : Standard COM port output seen on the port conector
  --  0x1 : Profiblaze output see on the port connector
  -----------------------------------------------------------------------------
  constant PB_DEBUG_COM : std_logic := '0';

  signal UNCONNECTED               : std_logic_vector (53 downto 0);
  signal pcie_sys_clk              : std_logic;
  signal ncsi_clk_out              : std_logic;
  signal uart0_transmission_active : std_logic;
  signal lpc_clk_24MHz_bufg        : std_logic;
  signal UART_0_ctsn               : std_logic;
  signal UART_0_dcdn               : std_logic;
  signal UART_0_dsrn               : std_logic;
  signal UART_0_dtrn               : std_logic;
  signal UART_0_out1n              : std_logic;
  signal UART_0_out2n              : std_logic;
  signal UART_0_ri                 : std_logic;
  signal UART_0_rtsn               : std_logic;
  signal UART_0_rxd                : std_logic;
  signal UART_0_txd                : std_logic;
  signal UART_1_ctsn               : std_logic;
  signal UART_1_dcdn               : std_logic;
  signal UART_1_dsrn               : std_logic;
  signal UART_1_dtrn               : std_logic;
  signal UART_1_out1n              : std_logic;
  signal UART_1_out2n              : std_logic;
  signal UART_1_ri                 : std_logic;
  signal UART_1_rtsn               : std_logic;
  signal UART_1_rxd                : std_logic;
  signal UART_1_txd                : std_logic;
  signal UART_DBG_ctsn             : std_logic;
  signal UART_DBG_dcdn             : std_logic;
  signal UART_DBG_dsrn             : std_logic;
  signal UART_DBG_dtrn             : std_logic;
  signal UART_DBG_ri               : std_logic;
  signal UART_DBG_rtsn             : std_logic;
  signal UART_DBG_rxd              : std_logic;
  signal UART_DBG_txd              : std_logic;

  signal uart_config       : std_logic_vector (1 downto 0)  := "00";
  signal debug_in          : std_logic_vector (31 downto 0) := (others => '0');
  signal debug_out         : std_logic_vector (31 downto 0);
  signal user_data_in_mux  : std_logic_vector (user_data_in'range);
  signal user_data_out_int : std_logic_vector(user_data_out'range);

  signal nclk_ce  : std_logic := '1';
  signal nclk_d1  : std_logic := '1';
  signal nclk_d2  : std_logic := '0';
  signal nclk_rst : std_logic := '0';
  signal nclk_set : std_logic := '0';

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

  Buf_lpc_clk_24MHz : BUFG
    port map (
      O => lpc_clk_24MHz_bufg,
      I => lpc_clk_24MHz
      );


  xsystem_pb_wrapper : system_pb_wrapper
    port map(
      FPGA_Info_0_board_info         => "0000",
      FPGA_Info_0_fpga_build_id      => std_logic_vector(to_unsigned(FPGA_BUILD_DATE, 32)),
      FPGA_Info_0_fpga_device_id     => std_logic_vector(to_unsigned(FPGA_DEVICE_ID, 8)),
      FPGA_Info_0_fpga_firmware_type => std_logic_vector(to_unsigned(FPGA_IS_NPI_GOLDEN, 8)),
      FPGA_Info_0_fpga_major_ver     => std_logic_vector(to_unsigned(FPGA_MAJOR_VERSION, 8)),
      FPGA_Info_0_fpga_minor_ver     => std_logic_vector(to_unsigned(FPGA_MINOR_VERSION, 8)),
      FPGA_Info_0_fpga_sub_minor_ver => std_logic_vector(to_unsigned(FPGA_SUB_MINOR_VERSION, 8)),
      PCIE_REFCLK_100MHz             => pcie_sys_clk,
      PCIE_RESET_N                   => sys_rst_n,
      UART_0_ctsn                    => UART_0_ctsn,
      UART_0_dcdn                    => UART_0_dcdn,
      UART_0_dsrn                    => UART_0_dsrn,
      UART_0_dtrn                    => UART_0_dtrn,
      UART_0_out1n                   => UART_0_out1n,
      UART_0_out2n                   => UART_0_out2n,
      UART_0_ri                      => UART_0_ri,
      UART_0_rtsn                    => UART_0_rtsn,
      UART_0_rxd                     => UART_0_rxd,
      UART_0_txd                     => UART_0_txd,
      UART_1_ctsn                    => UART_1_ctsn,
      UART_1_dcdn                    => UART_1_dcdn,
      UART_1_dsrn                    => UART_1_dsrn,
      UART_1_dtrn                    => UART_1_dtrn,
      UART_1_out1n                   => UART_1_out1n,
      UART_1_out2n                   => UART_1_out2n,
      UART_1_ri                      => UART_1_ri,
      UART_1_rtsn                    => UART_1_rtsn,
      UART_1_rxd                     => UART_1_rxd,
      UART_1_txd                     => UART_1_txd,
      UART_DBG_ctsn                  => UART_DBG_ctsn,
      UART_DBG_dcdn                  => UART_DBG_dcdn,
      UART_DBG_dsrn                  => UART_DBG_dsrn,
      UART_DBG_dtrn                  => UART_DBG_dtrn,
      UART_DBG_ri                    => UART_DBG_ri,
      UART_DBG_rtsn                  => UART_DBG_rtsn,
      UART_DBG_rxd                   => UART_DBG_rxd,
      UART_DBG_txd                   => UART_DBG_txd,
      Vp_Vn_0_v_n                    => Vp_Vn_0_v_n,
      Vp_Vn_0_v_p                    => Vp_Vn_0_v_p,
      ddr_addr                       => ddr_addr,
      ddr_ba                         => ddr_ba,       -- ToDo
      ddr_cas_n                      => ddr_cas_n,    -- ToDo
      ddr_ck_n                       => ddr_ck_n,     -- ToDo
      ddr_ck_p                       => ddr_ck_p,     -- ToDo
      ddr_cke                        => ddr_cke,      -- ToDo
      ddr_cs_n                       => ddr_cs_n,     -- ToDo
      ddr_dm                         => ddr_dm,       -- ToDo
      ddr_dq                         => ddr_dq,       -- ToDo
      ddr_dqs_n                      => ddr_dqs_n,    -- ToDo
      ddr_dqs_p                      => ddr_dqs_p,    -- ToDo
      ddr_odt                        => ddr_odt,      -- ToDo
      ddr_ras_n                      => ddr_ras_n,    -- ToDo
      ddr_reset_n                    => ddr_reset_n,  -- ToDo
      ddr_we_n                       => ddr_we_n,     -- ToDo
      debug_in                       => debug_in,
      debug_out                      => debug_out,
      ext_sync_0_ext_sync_en         => open,
      ext_sync_0_ext_sync_in         => '0',
      ext_sync_0_ext_sync_out        => open,
      FIXED_IO_ddr_vrn               => ddr_vrn,
      FIXED_IO_ddr_vrp               => ddr_vrp,
      FIXED_IO_mio(0)                => UNCONNECTED(0),
      FIXED_IO_mio(6 downto 1)       => mio(6 downto 1),
      FIXED_IO_mio(53 downto 7)      => UNCONNECTED(53 downto 7),
      FIXED_IO_ps_clk                => ps_clk,
      FIXED_IO_ps_porb               => ps_porb,
      FIXED_IO_ps_srstb              => ps_srstb,
      lpc_lpc_ad                     => lpc_ad,
      lpc_lpc_clk                    => lpc_clk_24MHz_bufg,
      lpc_lpc_frame_n                => lpc_frame_n,
      lpc_lpc_reset_n                => sys_rst_n,
      lpc_serirq                     => serirq,
      mtxSPI_0_spi_csn               => open,
      mtxSPI_0_spi_sdin              => '0',
      mtxSPI_0_spi_sdout             => open,

      -- POE 1
      ncsi_0_crs_dv => lan1_ncsi_crs_dv,
      ncsi_0_rx_er  => '0',
      ncsi_0_rxd    => lan1_ncsi_rxd,
      ncsi_0_tx_en  => lan1_ncsi_tx_en,
      ncsi_0_txd    => lan1_ncsi_txd,

      -- POE 2
      ncsi_1_crs_dv => lan2_ncsi_crs_dv,
      ncsi_1_rx_er  => '0',
      ncsi_1_rxd    => lan2_ncsi_rxd,
      ncsi_1_tx_en  => lan2_ncsi_tx_en,
      ncsi_1_txd    => lan2_ncsi_txd,

      -- POE 3
      ncsi_2_crs_dv => lan3_ncsi_crs_dv,
      ncsi_2_rx_er  => '0',
      ncsi_2_rxd    => lan3_ncsi_rxd,
      ncsi_2_tx_en  => lan3_ncsi_tx_en,
      ncsi_2_txd    => lan3_ncsi_txd,

      -- POE 4
      ncsi_3_crs_dv => lan4_ncsi_crs_dv,
      ncsi_3_rx_er  => '0',
      ncsi_3_rxd    => lan4_ncsi_rxd,
      ncsi_3_tx_en  => lan4_ncsi_tx_en,
      ncsi_3_txd    => lan4_ncsi_txd,

      -- Profinet 0
      ncsi_4_crs_dv => profinet1_ncsi_crs_dv,
      ncsi_4_rx_er  => '0',
      ncsi_4_rxd    => profinet1_ncsi_rxd,
      ncsi_4_tx_en  => profinet1_ncsi_tx_en,
      ncsi_4_txd    => profinet1_ncsi_txd,

      -- Profinet 1
      ncsi_5_crs_dv => profinet2_ncsi_crs_dv,
      ncsi_5_rx_er  => '0',
      ncsi_5_rxd    => profinet2_ncsi_rxd,
      ncsi_5_tx_en  => profinet2_ncsi_tx_en,
      ncsi_5_txd    => profinet2_ncsi_txd,

      -- NCSI clock
      ncsi_clk_out => ncsi_clk_out,

      pcie_rxn => pcie_rx_n,
      pcie_rxp => pcie_rx_p,
      pcie_txn => pcie_tx_n,
      pcie_txp => pcie_tx_p,

      transmission_active_0 => uart0_transmission_active,
      transmission_active_1 => open,
      user_data_in          => user_data_in_mux,
      user_data_out         => user_data_out_int
      );

  -----------------------------------------------------------------------------
  -- NCSI clock mapping
  -----------------------------------------------------------------------------
  -- lan1_ncsi_clk      <= ncsi_clk_out;
  -- lan2_ncsi_clk      <= ncsi_clk_out;
  -- lan3_ncsi_clk      <= ncsi_clk_out;
  -- lan4_ncsi_clk      <= ncsi_clk_out;
  -- profinet1_ncsi_clk <= ncsi_clk_out;
  -- profinet2_ncsi_clk <= ncsi_clk_out;



  oddrbuff_lan1_ncsi_clk : ODDR
    generic map(
      DDR_CLK_EDGE => "OPPOSITE_EDGE",
      INIT         => '0',
      SRTYPE       => "SYNC")
    port map (
      Q  => lan1_ncsi_clk,
      C  => ncsi_clk_out,               -- 1-bit clock input
      CE => nclk_ce,                    -- 1-bit clock enable input
      D1 => nclk_d1,                    -- 1-bit data input (positive edge)
      D2 => nclk_d2,                    -- 1-bit data input (negative edge)
      R  => nclk_rst,                   -- 1-bit reset input
      S  => nclk_set                    -- 1-bit set input
      );

  oddrbuff_lan2_ncsi_clk : ODDR
    generic map(
      DDR_CLK_EDGE => "OPPOSITE_EDGE",
      INIT         => '0',
      SRTYPE       => "SYNC")
    port map (
      Q  => lan2_ncsi_clk,
      C  => ncsi_clk_out,               -- 1-bit clock input
      CE => nclk_ce,                    -- 1-bit clock enable input
      D1 => nclk_d1,                    -- 1-bit data input (positive edge)
      D2 => nclk_d2,                    -- 1-bit data input (negative edge)
      R  => nclk_rst,                   -- 1-bit reset input
      S  => nclk_set                    -- 1-bit set input
      );


  oddrbuff_lan3_ncsi_clk : ODDR
    generic map(
      DDR_CLK_EDGE => "OPPOSITE_EDGE",
      INIT         => '0',
      SRTYPE       => "SYNC")
    port map (
      Q  => lan3_ncsi_clk,
      C  => ncsi_clk_out,               -- 1-bit clock input
      CE => nclk_ce,                    -- 1-bit clock enable input
      D1 => nclk_d1,                    -- 1-bit data input (positive edge)
      D2 => nclk_d2,                    -- 1-bit data input (negative edge)
      R  => nclk_rst,                   -- 1-bit reset input
      S  => nclk_set                    -- 1-bit set input
      );

  oddrbuff_lan4_ncsi_clk : ODDR
    generic map(
      DDR_CLK_EDGE => "OPPOSITE_EDGE",
      INIT         => '0',
      SRTYPE       => "SYNC")
    port map (
      Q  => lan4_ncsi_clk,
      C  => ncsi_clk_out,               -- 1-bit clock input
      CE => nclk_ce,                    -- 1-bit clock enable input
      D1 => nclk_d1,                    -- 1-bit data input (positive edge)
      D2 => nclk_d2,                    -- 1-bit data input (negative edge)
      R  => nclk_rst,                   -- 1-bit reset input
      S  => nclk_set                    -- 1-bit set input
      );


  -- oddrbuff_profinet1_ncsi_clk : ODDR
  --   generic map(
  --     DDR_CLK_EDGE => "OPPOSITE_EDGE",
  --     INIT         => '0',
  --     SRTYPE       => "SYNC")
  --   port map (
  --     Q  => profinet1_ncsi_clk,
  --     C  => ncsi_clk_out,               -- 1-bit clock input
  --     CE => nclk_ce,                    -- 1-bit clock enable input
  --     D1 => nclk_d1,                    -- 1-bit data input (positive edge)
  --     D2 => nclk_d2,                    -- 1-bit data input (negative edge)
  --     R  => nclk_rst,                   -- 1-bit reset input
  --     S  => nclk_set                    -- 1-bit set input
  --     );

  oddrbuff_profinet2_ncsi_clk : ODDR
    generic map(
      DDR_CLK_EDGE => "OPPOSITE_EDGE",
      INIT         => '0',
      SRTYPE       => "SYNC")
    port map (
      Q  => profinet2_ncsi_clk,
      C  => ncsi_clk_out,               -- 1-bit clock input
      CE => nclk_ce,                    -- 1-bit clock enable input
      D1 => nclk_d1,                    -- 1-bit data input (positive edge)
      D2 => nclk_d2,                    -- 1-bit data input (negative edge)
      R  => nclk_rst,                   -- 1-bit reset input
      S  => nclk_set                    -- 1-bit set input
      );


  nclk_rst <= '0';
  nclk_set <= '0';


  -----------------------------------------------------------------------------
  -- user_data_in_mux (GPIO loopback)
  -----------------------------------------------------------------------------
  user_data_out    <= user_data_out_int;
  user_data_in_mux <= user_data_out_int when (debug_out(0) = '1') else
                      user_data_in;


  debug_in(7 downto 0)  <= user_data_in;
  debug_in(15 downto 8) <= user_data_in_mux;

  uart_config <= debug_out(5 downto 4);

  -----------------------------------------------------------------------------
  -- COM port debug
  -----------------------------------------------------------------------------
  P_COM_PORTS_MUX : process (uart_config) is
  begin
    case uart_config is
      -------------------------------------------------------------------------
      -- ZYNQ Debug terminal spit on COM1
      -------------------------------------------------------------------------
      when "01" =>
        ---------------------------------------------------------------------------
        -- COM1 (RS485/RS-232)
        ---------------------------------------------------------------------------
        com1_rts_n    <= UART_DBG_rtsn;
        com1_txd      <= UART_DBG_txd;
        UART_DBG_rxd  <= com1_rxd;
        UART_DBG_ctsn <= com1_cts_n;
        UART_DBG_dcdn <= '1';
        UART_DBG_dsrn <= '1';
        UART_DBG_ri   <= '1';

        ---------------------------------------------------------------------------
        -- COM2
        ---------------------------------------------------------------------------
        com2_rts_n  <= UART_1_rtsn;
        com2_txd    <= UART_1_txd;
        UART_1_rxd  <= com2_rxd;
        UART_1_ctsn <= com2_cts_n;
        UART_1_dcdn <= '1';
        UART_1_dsrn <= '1';
        UART_1_ri   <= '1';

        ---------------------------------------------------------------------------
        -- ZYNQ UART
        ---------------------------------------------------------------------------
        UART_0_ctsn <= '1';
        UART_0_dcdn <= '1';
        UART_0_dsrn <= '1';
        UART_0_ri   <= '1';
        UART_0_rxd  <= '0';

      -------------------------------------------------------------------------
      -- ZYNQ Debug terminal spit on COM2
      -------------------------------------------------------------------------
      when "10" =>
        ---------------------------------------------------------------------------
        -- COM1 (RS485/RS-232) spit LPC UART0
        ---------------------------------------------------------------------------
        com1_rts_n  <= UART_0_rtsn;
        com1_txd    <= UART_0_txd;
        UART_0_rxd  <= com1_rxd;
        UART_0_ctsn <= com1_cts_n;
        UART_0_dcdn <= '1';
        UART_0_dsrn <= '1';
        UART_0_ri   <= '1';

        ---------------------------------------------------------------------------
        -- COM2 spit LPC UART1
        ---------------------------------------------------------------------------
        com2_rts_n    <= UART_DBG_rtsn;
        com2_txd      <= UART_DBG_txd;
        UART_DBG_rxd  <= com2_rxd;
        UART_DBG_ctsn <= com2_cts_n;
        UART_DBG_dcdn <= '1';
        UART_DBG_dsrn <= '1';
        UART_DBG_ri   <= '1';

        ---------------------------------------------------------------------------
        -- ZYNQ UART static inputs (Unused)
        ---------------------------------------------------------------------------
        UART_1_ctsn <= '1';
        UART_1_dcdn <= '1';
        UART_1_dsrn <= '1';
        UART_1_ri   <= '1';
        UART_1_rxd  <= '0';

      -------------------------------------------------------------------------
      -- ZYNQ Debug terminal disabled
      -------------------------------------------------------------------------
      when others =>
        ---------------------------------------------------------------------------
        -- COM1 (RS485/RS-232) spit LPC UART0
        ---------------------------------------------------------------------------
        com1_rts_n  <= UART_0_rtsn;
        com1_txd    <= UART_0_txd;
        UART_0_rxd  <= com1_rxd;
        UART_0_ctsn <= com1_cts_n;
        UART_0_dcdn <= '1';
        UART_0_dsrn <= '1';
        UART_0_ri   <= '1';

        ---------------------------------------------------------------------------
        -- COM2 spit LPC UART1
        ---------------------------------------------------------------------------
        com2_rts_n  <= UART_1_rtsn;
        com2_txd    <= UART_1_txd;
        UART_1_rxd  <= com2_rxd;
        UART_1_ctsn <= com2_cts_n;
        UART_1_dcdn <= '1';
        UART_1_dsrn <= '1';
        UART_1_ri   <= '1';

        ---------------------------------------------------------------------------
        -- ZYNQ UART static inputs (Unused)
        ---------------------------------------------------------------------------
        UART_DBG_ctsn <= '1';
        UART_DBG_dcdn <= '1';
        UART_DBG_dsrn <= '1';
        UART_DBG_ri   <= '1';
        UART_DBG_rxd  <= '0';
    end case;
  end process P_COM_PORTS_MUX;

  profinet1_led_out <= profinet1_led_in;
  profinet2_led_out <= profinet2_led_in;


  --com1_rts_n <= uart_0_rtsn;
-----------------------------------------------------------------------------
-- COM PORT 1 (RS-485) driver control
-----------------------------------------------------------------------------
  -- P_com1_rs485 : process(com1_rs485,
  --                        uart_0_rtsn,
  --                        uart0_transmission_active
  --                        )
  -- begin
  --   -------------------------------------------------------------------------
  --   -- RS-485 mode
  --   -------------------------------------------------------------------------
  --   if (com1_rs485 = '1') then
  --     if (COM1_RS485_DUPLEX = '1') then
  --       -- half duplex rs485, controlled automatically
  --       com1_dxen <= uart0_transmission_active;
  --     else
  --       -- full duplex, controlled by the COM Port driver
  --       com1_dxen <= not uart_0_rtsn;
  --     end if;

  --   -------------------------------------------------------------------------
  --   -- RS-232 mode
  --   -------------------------------------------------------------------------
  --   else
  --     -- The transmit driver is always active (Full duplex; point-to-point)
  --     com1_dxen <= '1';
  --   end if;
  -- end process P_com1_rs485;


-- en mode RS485 auto-RTS ou RTS-controlled-without-local-echo, on devra controler la reception.
-- Pour l'instant, il n'y a pas de controle de MIL/driver pour permettre ce choix, donc on présume
-- qu'on est toujours en full-duplex, donc que le recepteur est toujours actif.
-- Ce bit n'est relié aux receivers qu'à partir du pcb y7449-01.
  com1_rxen <= '1';

-- en attendant, pour etre compatible avec tous les PCB, on va masquer artificiellement la reception, seulement dans le cas suivant:
-- on est en RS485,
-- on est en Half duplex ET
-- on est en train de transmettre
  -- com1_rxd_masked <= com1_rxd when (uart0_transmission_active = '0' or
  --                                   com1_rs485 = '0' or
  --                                   COM1_RS485_DUPLEX = '0'
  --                                   ) else
  --                    '1';

-- on mux sur la sortie le uart Profinet (en debug) avec le COM1 regulier:
-- com1_txd <= profinet_serial_txd when (PB_DEBUG_COM = '1') else
--             uart_0_txd;

end struct;
