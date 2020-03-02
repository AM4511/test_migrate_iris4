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


entity athena_zynq is
  generic(
    FPGA_MAJOR_VERSION          : integer := 0;
    FPGA_MINOR_VERSION          : integer := 0;
    FPGA_SUB_MINOR_VERSION      : integer := 0;
    FPGA_BUILD_DATE             : integer := 0;
    FPGA_IS_NPI_GOLDEN          : integer := 0;
    FPGA_DEVICE_ID              : integer := 0;
    HISPI_NUMBER_OF_DATA_LANES  : integer := 6;
    HISPI_NUMBER_OF_CLOCK_LANES : integer := 2
    );
  port (
    ---------------------------------------------------------------------------
    -- System interface
    ---------------------------------------------------------------------------
    refclk   : in std_logic;
--    sysrst_n : in std_logic;


    ---------------------------------------------------------------------------
    -- PCIe Interface Gen1x2
    ---------------------------------------------------------------------------
    pcie_clk_n : in std_logic;
    pcie_clk_p : in std_logic;

    pcie_rx_n : in  std_logic_vector(1 downto 0);
    pcie_rx_p : in  std_logic_vector(1 downto 0);
    pcie_tx_n : out std_logic_vector(1 downto 0);
    pcie_tx_p : out std_logic_vector(1 downto 0);


    ---------------------------------------------------------------------------
    -- 
    ---------------------------------------------------------------------------
    FIXED_IO_ddr_vrn  : inout std_logic;
    FIXED_IO_ddr_vrp  : inout std_logic;
    FIXED_IO_mio      : inout std_logic_vector (53 downto 0);
    FIXED_IO_ps_clk   : inout std_logic;
    FIXED_IO_ps_porb  : inout std_logic;
    FIXED_IO_ps_srstb : inout std_logic;


    ---------------------------------------------------------------------------
    -- 
    ---------------------------------------------------------------------------
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
    -- XGS sensor control interface
    ---------------------------------------------------------------------------
    xgs_reset_n    : out std_logic;
    xgs_clk_pll_en : out std_logic;
    xgs_trig_int   : out std_logic;
    xgs_trig_rd    : out std_logic;
    xgs_monitor    : in  std_logic_vector(2 downto 0);
    xgs_fwsi_en    : out std_logic;
    xgs_cs_n       : out std_logic;
    xgs_sclk       : out std_logic;
    xgs_sdin       : in  std_logic;
    xgs_sdout      : out std_logic;

    xgs_power_good : in std_logic;

    ---------------------------------------------------------------------------
    --  XGS sensor HiSPi data interface
    ---------------------------------------------------------------------------
    xgs_hispi_sclk_n  : in std_logic_vector (HISPI_NUMBER_OF_CLOCK_LANES-1 downto 0);
    xgs_hispi_sclk_p  : in std_logic_vector (HISPI_NUMBER_OF_CLOCK_LANES-1 downto 0);
    xgs_hispi_sdata_n : in std_logic_vector (HISPI_NUMBER_OF_DATA_LANES-1 downto 0);
    xgs_hispi_sdata_p : in std_logic_vector (HISPI_NUMBER_OF_DATA_LANES-1 downto 0);

    ---------------------------------------------------------------------------
    --  Debug
    ---------------------------------------------------------------------------
    debug_data : out std_logic_vector(3 downto 0);

    ---------------------------------------------------------------------------
    --  LED outputs
    ---------------------------------------------------------------------------
    led_out : out std_logic_vector(1 downto 0);

    ---------------------------------------------------------------------------
    --  OUTPUTS TO IO FPGA
    ---------------------------------------------------------------------------
    strobe_out   : out std_logic;
    exposure_out : out std_logic;
    trig_rdy_out : out std_logic;

    ---------------------------------------------------------------------------
    --  INPUTS FROM other fpga
    ---------------------------------------------------------------------------
    ext_trig : in std_logic;

    ---------------------------------------------------------------------------
    --  I2C
    ---------------------------------------------------------------------------
    smbclk  : inout std_logic;
    smbdata : inout std_logic;

    ---------------------------------------------------------------------------
    --  Temperature ALERT
    ---------------------------------------------------------------------------
    temp_alertN : in std_logic;

    ---------------------------------------------------------------------------
    --  Strappings
    ---------------------------------------------------------------------------
    fpga_var_type : in std_logic_vector(1 downto 0);

    ---------------------------------------------------------------------------
    --  FPGA FLASH SPI  interface
    ---------------------------------------------------------------------------
    cfg_spi_cs_n : inout std_logic;
    cfg_spi_sd   : inout std_logic_vector (3 downto 0)

    );
end athena_zynq;


architecture struct of athena_zynq is


  component system_wrapper is
    port (
      FIXED_IO_ddr_vrn        : inout std_logic;
      FIXED_IO_ddr_vrp        : inout std_logic;
      FIXED_IO_mio            : inout std_logic_vector (53 downto 0);
      FIXED_IO_ps_clk         : inout std_logic;
      FIXED_IO_ps_porb        : inout std_logic;
      FIXED_IO_ps_srstb       : inout std_logic;
      anput_exposure          : out   std_logic;
      anput_ext_trig          : in    std_logic;
      anput_strobe            : out   std_logic;
      anput_trig_rdy          : out   std_logic;
      ddr_addr                : inout std_logic_vector (14 downto 0);
      ddr_ba                  : inout std_logic_vector (2 downto 0);
      ddr_cas_n               : inout std_logic;
      ddr_ck_n                : inout std_logic;
      ddr_ck_p                : inout std_logic;
      ddr_cke                 : inout std_logic;
      ddr_cs_n                : inout std_logic;
      ddr_dm                  : inout std_logic_vector (3 downto 0);
      ddr_dq                  : inout std_logic_vector (31 downto 0);
      ddr_dqs_n               : inout std_logic_vector (3 downto 0);
      ddr_dqs_p               : inout std_logic_vector (3 downto 0);
      ddr_odt                 : inout std_logic;
      ddr_ras_n               : inout std_logic;
      ddr_reset_n             : inout std_logic;
      ddr_we_n                : inout std_logic;
      hispi_hispi_clk_n       : in    std_logic_vector (1 downto 0);
      hispi_hispi_clk_p       : in    std_logic_vector (1 downto 0);
      hispi_hispi_data_n      : in    std_logic_vector (5 downto 0);
      hispi_hispi_data_p      : in    std_logic_vector (5 downto 0);
      led_out_0               : out   std_logic_vector (1 downto 0);
      pcie_rxn                : in    std_logic_vector (1 downto 0);
      pcie_rxp                : in    std_logic_vector (1 downto 0);
      pcie_txn                : out   std_logic_vector (1 downto 0);
      pcie_txp                : out   std_logic_vector (1 downto 0);
      refclk_100MHz           : in    std_logic;
      xgs_ctrl_xgs_clk_pll_en : out   std_logic;
      xgs_ctrl_xgs_cs_n       : out   std_logic;
      xgs_ctrl_xgs_fwsi_en    : out   std_logic;
      xgs_ctrl_xgs_monitor0   : in    std_logic;
      xgs_ctrl_xgs_monitor1   : in    std_logic;
      xgs_ctrl_xgs_monitor2   : in    std_logic;
      xgs_ctrl_xgs_power_good : in    std_logic;
      xgs_ctrl_xgs_reset_n    : out   std_logic;
      xgs_ctrl_xgs_sclk       : out   std_logic;
      xgs_ctrl_xgs_sdin       : in    std_logic;
      xgs_ctrl_xgs_sdout      : out   std_logic;
      xgs_ctrl_xgs_trig_int   : out   std_logic;
      xgs_ctrl_xgs_trig_rd    : out   std_logic
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


  xsystem_wrapper : system_wrapper
    port map(
      FIXED_IO_ddr_vrn        => FIXED_IO_ddr_vrn,
      FIXED_IO_ddr_vrp        => FIXED_IO_ddr_vrp,
      FIXED_IO_mio            => FIXED_IO_mio,
      FIXED_IO_ps_clk         => FIXED_IO_ps_clk,
      FIXED_IO_ps_porb        => FIXED_IO_ps_porb,
      FIXED_IO_ps_srstb       => FIXED_IO_ps_srstb,
      anput_exposure          => exposure_out,
      anput_ext_trig          => ext_trig ,
      anput_strobe            => strobe_out,
      anput_trig_rdy          => trig_rdy_out,
      ddr_addr                => ddr_addr,
      ddr_ba                  => ddr_ba,
      ddr_cas_n               => ddr_cas_n,
      ddr_ck_n                => ddr_ck_n,
      ddr_ck_p                => ddr_ck_p,
      ddr_cke                 => ddr_cke,
      ddr_cs_n                => ddr_cs_n,
      ddr_dm                  => ddr_dm,
      ddr_dq                  => ddr_dq,
      ddr_dqs_n               => ddr_dqs_n,
      ddr_dqs_p               => ddr_dqs_p,
      ddr_odt                 => ddr_odt,
      ddr_ras_n               => ddr_ras_n,
      ddr_reset_n             => ddr_reset_n,
      ddr_we_n                => ddr_we_n,
      hispi_hispi_clk_n       => xgs_hispi_sclk_n,
      hispi_hispi_clk_p       => xgs_hispi_sclk_p,
      hispi_hispi_data_n      => xgs_hispi_sdata_n,
      hispi_hispi_data_p      => xgs_hispi_sdata_p,
      led_out_0               => led_out,
      pcie_rxn                => pcie_rx_n,
      pcie_rxp                => pcie_rx_p,
      pcie_txn                => pcie_tx_n,
      pcie_txp                => pcie_tx_p,
      refclk_100MHz           => refclk,
      xgs_ctrl_xgs_clk_pll_en => open,  --TBD
      xgs_ctrl_xgs_cs_n       => xgs_cs_n,
      xgs_ctrl_xgs_fwsi_en    => xgs_fwsi_en,
      xgs_ctrl_xgs_monitor0   => xgs_monitor(0),
      xgs_ctrl_xgs_monitor1   => xgs_monitor(1),
      xgs_ctrl_xgs_monitor2   => xgs_monitor(0),
      xgs_ctrl_xgs_power_good => xgs_power_good,
      xgs_ctrl_xgs_reset_n    => xgs_reset_n,
      xgs_ctrl_xgs_sclk       => xgs_sclk,
      xgs_ctrl_xgs_sdin       => xgs_sdin,
      xgs_ctrl_xgs_sdout      => xgs_sdout,
      xgs_ctrl_xgs_trig_int   => xgs_trig_int,
      xgs_ctrl_xgs_trig_rd    => xgs_trig_rd
      );



end struct;
