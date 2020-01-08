----------------------------------------------------------------------
-- DESCRIPTION: Ares eSpi
--
-- Top level history:
-- =============================================
-- V0.1     : 
-- V0.2     : 
--
-- PROJECT: Iris-4
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


library unisim;
use unisim.vcomponents.all;


entity ares_espi_xc7a50t is
  generic(
    FPGA_MAJOR_VERSION     : integer := 0;
    FPGA_MINOR_VERSION     : integer := 0;
    FPGA_SUB_MINOR_VERSION : integer := 0;
    FPGA_BUILD_DATE        : integer := 0;
    FPGA_IS_NPI_GOLDEN     : integer := 0;
    FPGA_DEVICE_ID         : integer := 0
    );
  port (
    sys_rst_n      : in std_logic;
    ref_clk_100MHz : in std_logic;
    fpga_straps    : in std_logic_vector(3 downto 0);

    ---------------------------------------------------------------------------
    --eSPI interface
    ---------------------------------------------------------------------------
    espi_reset_n : in    std_logic;
    espi_clk     : in    std_logic;
    espi_cs_n    : in    std_logic;
    espi_io      : inout std_logic_vector(3 downto 0);
    espi_alert_n : out   std_logic;

    ---------------------------------------------------------------------------
    -- PCIe interface
    ---------------------------------------------------------------------------
    pcie_sys_clk_p : in  std_logic;
    pcie_sys_clk_n : in  std_logic;
    pcie_rxn       : in  std_logic;
    pcie_rxp       : in  std_logic;
    pcie_txn       : out std_logic;
    pcie_txp       : out std_logic;


    ---------------------------------------------------------------------------
    -- CPU debug interface
    ---------------------------------------------------------------------------
    debug_uart_rxd : in  std_logic;
    debug_uart_txd : out std_logic;

    ------------------------------
    -- I/F to Athena FPGA
    ------------------------------
    acq_led           : in  std_logic_vector(1 downto 0);
    acq_exposure      : in  std_logic;  -- connecte sur internal_input(0)
    acq_strobe        : in  std_logic;  -- connecte sur internal_input(1)
    acq_trigger_ready : in  std_logic;  -- connecte sur internal_input(2)
    acq_trigger       : out std_logic;

    ------------------------------
    -- connexion aux LEDS et SOC
    ------------------------------
    user_rled_soc : in  std_logic;
    user_gled_soc : in  std_logic;
    user_rled     : out std_logic;
    user_gled     : out std_logic;
    status_rled   : out std_logic;
    status_gled   : out std_logic;

    ---------------------------------------------------------------------------
    -- NCSI I/F
    ---------------------------------------------------------------------------
    rmii_crs_dv : in  std_logic;
    rmii_rxd    : in  std_logic_vector (1 downto 0);
    rmii_tx_en  : out std_logic;
    rmii_txd    : out std_logic_vector (1 downto 0);

    ---------------------------------------------------------------------------
    -- Flash SPI
    ---------------------------------------------------------------------------
    spi_csn   : out std_logic;
    spi_sdin  : in  std_logic;
    spi_sdout : out std_logic;


    ---------------------------------------------------------------------------
    -- HyperRam I/F
    ---------------------------------------------------------------------------
    rpc_ck_p    : out   std_logic;
    rpc_ck_n    : out   std_logic;
    rpc_cs0_n   : out   std_logic;
    rpc_cs1_n   : out   std_logic;
    rpc_dq      : inout std_logic_vector (7 downto 0);
    rpc_reset_n : out   std_logic;
    rpc_rwds    : inout std_logic;
    rpc_wp_n    : out   std_logic;

    ---------------------------------------------------------------------------
    -- Matrox Advance I/O
    ---------------------------------------------------------------------------
    pwm_out       : out std_logic;      -- WHAT IS THAT ?!?
    user_data_in  : in  std_logic_vector (3 downto 0);
    user_data_out : out std_logic_vector (2 downto 0)
    );
end ares_espi_xc7a50t;


architecture struct of ares_espi_xc7a50t is


  component system_pb_wrapper is
    port (
      debug_uart_rxd               : in    std_logic;
      debug_uart_txd               : out   std_logic;
      ext_sync_ext_sync_en         : out   std_logic;
      ext_sync_ext_sync_in         : in    std_logic;
      ext_sync_ext_sync_out        : out   std_logic;
      fpga_info_board_info         : in    std_logic_vector (3 downto 0);
      fpga_info_fpga_build_id      : in    std_logic_vector (31 downto 0);
      fpga_info_fpga_device_id     : in    std_logic_vector (7 downto 0);
      fpga_info_fpga_firmware_type : in    std_logic_vector (7 downto 0);
      fpga_info_fpga_major_ver     : in    std_logic_vector (7 downto 0);
      fpga_info_fpga_minor_ver     : in    std_logic_vector (7 downto 0);
      fpga_info_fpga_sub_minor_ver : in    std_logic_vector (7 downto 0);
      mtxSPI_spi_csn               : out   std_logic;
      mtxSPI_spi_sdin              : in    std_logic;
      mtxSPI_spi_sdout             : out   std_logic;
      pcie_rxn                     : in    std_logic;
      pcie_rxp                     : in    std_logic;
      pcie_sys_clk_100MHz          : in    std_logic;
      pcie_txn                     : out   std_logic;
      pcie_txp                     : out   std_logic;
      ref_clk_100MHz               : in    std_logic;
      rmii_crs_dv                  : in    std_logic;
      rmii_rx_er                   : in    std_logic;
      rmii_rxd                     : in    std_logic_vector (1 downto 0);
      rmii_tx_en                   : out   std_logic;
      rmii_txd                     : out   std_logic_vector (1 downto 0);
      rpc_ck                       : out   std_logic;
      rpc_ck_n                     : out   std_logic;
      rpc_cs0_n                    : out   std_logic;
      rpc_cs1_n                    : out   std_logic;
      rpc_dq                       : inout std_logic_vector (7 downto 0);
      rpc_reset_n                  : out   std_logic;
      rpc_rwds                     : inout std_logic;
      rpc_wp_n                     : out   std_logic;
      sys_rst_n                    : in    std_logic;
      user_data_in                 : in    std_logic_vector (3 downto 0);
      user_data_out                : out   std_logic_vector (2 downto 0)
      );
  end component;



  signal pcie_sys_clk : std_logic;



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
      sys_rst_n                    => sys_rst_n,
      ref_clk_100MHz               => ref_clk_100MHz,
      pcie_sys_clk_100MHz          => pcie_sys_clk,
      pcie_rxn                     => pcie_rxn,
      pcie_rxp                     => pcie_rxp,
      pcie_txn                     => pcie_txn,
      pcie_txp                     => pcie_txp,
      debug_uart_rxd               => debug_uart_rxd,
      debug_uart_txd               => debug_uart_txd,
      ext_sync_ext_sync_en         => open,
      ext_sync_ext_sync_in         => '0',
      ext_sync_ext_sync_out        => open,
      fpga_info_board_info         => "0000",
      fpga_info_fpga_build_id      => std_logic_vector(to_unsigned(FPGA_BUILD_DATE, 32)),
      fpga_info_fpga_device_id     => std_logic_vector(to_unsigned(FPGA_DEVICE_ID, 8)),
      fpga_info_fpga_firmware_type => std_logic_vector(to_unsigned(FPGA_IS_NPI_GOLDEN, 8)),
      fpga_info_fpga_major_ver     => std_logic_vector(to_unsigned(FPGA_MAJOR_VERSION, 8)),
      fpga_info_fpga_minor_ver     => std_logic_vector(to_unsigned(FPGA_MINOR_VERSION, 8)),
      fpga_info_fpga_sub_minor_ver => std_logic_vector(to_unsigned(FPGA_SUB_MINOR_VERSION, 8)),
      mtxSPI_spi_csn               => spi_csn,
      mtxSPI_spi_sdin              => spi_sdin,
      mtxSPI_spi_sdout             => spi_sdout,
      rmii_crs_dv                  => rmii_crs_dv,
      rmii_rx_er                   => '0', -- NC
      rmii_rxd                     => rmii_rxd,
      rmii_tx_en                   => rmii_tx_en,
      rmii_txd                     => rmii_txd,
      rpc_ck                       => rpc_ck_p,
      rpc_ck_n                     => rpc_ck_n,
      rpc_cs0_n                    => rpc_cs0_n,
      rpc_cs1_n                    => rpc_cs1_n,
      rpc_dq                       => rpc_dq,
      rpc_reset_n                  => rpc_reset_n,
      rpc_rwds                     => rpc_rwds,
      rpc_wp_n                     => rpc_wp_n,
      user_data_in                 => user_data_in,
      user_data_out                => user_data_out
      );

end struct;
