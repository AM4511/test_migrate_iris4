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
use ieee.std_logic_arith.all;
  
library unisim;
use unisim.vcomponents.all;


entity athena is
  generic(
    FPGA_MAJOR_VERSION          : integer := 0;
    FPGA_MINOR_VERSION          : integer := 0;
    FPGA_SUB_MINOR_VERSION      : integer := 0;
    FPGA_BUILD_DATE             : integer := 0;
    FPGA_IS_NPI_GOLDEN          : integer := 0;
    FPGA_DEVICE_ID              : integer := 0;
    PCIE_NB_LANES               : integer := 2;   
    HISPI_NUMBER_OF_DATA_LANES  : integer := 6;
    HISPI_NUMBER_OF_CLOCK_LANES : integer := 2
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
    pcie_clk_n : in std_logic;
    pcie_clk_p : in std_logic;

    pcie_rx_n : in  std_logic_vector(PCIE_NB_LANES-1 downto 0);
    pcie_rx_p : in  std_logic_vector(PCIE_NB_LANES-1 downto 0);
    pcie_tx_n : out std_logic_vector(PCIE_NB_LANES-1 downto 0);
    pcie_tx_p : out std_logic_vector(PCIE_NB_LANES-1 downto 0);

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
end athena;


architecture struct of athena is



component system_pb_wrapper
  port (
    Anput_exposure : out STD_LOGIC;
    Anput_ext_trig : in STD_LOGIC;
    Anput_strobe : out STD_LOGIC;
    Anput_trig_rdy : out STD_LOGIC;
    I2C_if_i2c_sdata : inout STD_LOGIC;
    I2C_if_i2c_slk : inout STD_LOGIC;
    SPI_spi_csn : out STD_LOGIC;
    SPI_spi_sdin : in STD_LOGIC;
    SPI_spi_sdout : out STD_LOGIC;
    info_board_info : in STD_LOGIC_VECTOR ( 3 downto 0 );
    info_fpga_build_id : in STD_LOGIC_VECTOR ( 31 downto 0 );
    info_fpga_device_id : in STD_LOGIC_VECTOR ( 7 downto 0 );
    info_fpga_firmware_type : in STD_LOGIC_VECTOR ( 7 downto 0 );
    info_fpga_major_ver : in STD_LOGIC_VECTOR ( 7 downto 0 );
    info_fpga_minor_ver : in STD_LOGIC_VECTOR ( 7 downto 0 );
    info_fpga_sub_minor_ver : in STD_LOGIC_VECTOR ( 7 downto 0 );
    led_out : out STD_LOGIC_VECTOR ( 1 downto 0 );
    pcie_rxn : in STD_LOGIC_VECTOR ( 1 downto 0 );
    pcie_rxp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    pcie_sys_clk : in STD_LOGIC;
    pcie_sys_rst_n : in STD_LOGIC;
    pcie_txn : out STD_LOGIC_VECTOR ( 1 downto 0 );
    pcie_txp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    ref_clk : in STD_LOGIC;
    hispi_hispi_data_p : in STD_LOGIC_VECTOR ( HISPI_NUMBER_OF_DATA_LANES-1 downto 0 );
    hispi_hispi_clk_p : in STD_LOGIC_VECTOR ( 1 downto 0 );
    hispi_hispi_data_n : in STD_LOGIC_VECTOR ( HISPI_NUMBER_OF_DATA_LANES-1 downto 0 );
    hispi_hispi_clk_n : in STD_LOGIC_VECTOR ( 1 downto 0 );
    xgs_ctrl_xgs_clk_pll_en : out STD_LOGIC;
    xgs_ctrl_xgs_cs_n : out STD_LOGIC;
    xgs_ctrl_xgs_fwsi_en : out STD_LOGIC;
    xgs_ctrl_xgs_monitor0 : in STD_LOGIC;
    xgs_ctrl_xgs_monitor1 : in STD_LOGIC;
    xgs_ctrl_xgs_monitor2 : in STD_LOGIC;
    xgs_ctrl_xgs_power_good : in STD_LOGIC;
    xgs_ctrl_xgs_reset_n : out STD_LOGIC;
    xgs_ctrl_xgs_sclk : out STD_LOGIC;
    xgs_ctrl_xgs_sdin : in STD_LOGIC;
    xgs_ctrl_xgs_sdout : out STD_LOGIC;
    xgs_ctrl_xgs_trig_int : out STD_LOGIC;
    xgs_ctrl_xgs_trig_rd : out STD_LOGIC;
    debug_out            : out STD_LOGIC_VECTOR(3 downto 0);
    ext_ch_gt_drpclk_in : in STD_LOGIC;
    ext_ch_gt_drpclk_out : out STD_LOGIC  
  );
  end component;

  signal pcie_clk_100MHz : std_logic;
  signal info_board_info : std_logic_vector(3 downto 0);
  signal ext_ch_gt_drpclk: std_logic;
  
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


     
  info_board_info <= "00" & fpga_var_type;    
      
  xsystem_pb_wrapper : system_pb_wrapper
  port map(
    Anput_exposure          => exposure_out,
    Anput_ext_trig          => ext_trig,
    Anput_strobe            => strobe_out,
    Anput_trig_rdy          => trig_rdy_out,
    
    I2C_if_i2c_sdata        => smbdata,
    I2C_if_i2c_slk          => smbclk,
    
    SPI_spi_csn             => cfg_spi_cs_n,
    SPI_spi_sdin            => cfg_spi_sd(1),
    SPI_spi_sdout           => cfg_spi_sd(0),
   
    info_board_info         => info_board_info,
    info_fpga_build_id      => conv_std_logic_vector(FPGA_BUILD_DATE, 32),
    info_fpga_device_id     => conv_std_logic_vector(FPGA_DEVICE_ID,   8),
    --info_fpga_firmware_type => "00000000",
    info_fpga_firmware_type => conv_std_logic_vector(FPGA_IS_NPI_GOLDEN,   8),
    info_fpga_major_ver     => conv_std_logic_vector(FPGA_MAJOR_VERSION,     8),
    info_fpga_minor_ver     => conv_std_logic_vector(FPGA_MINOR_VERSION,     8),
    info_fpga_sub_minor_ver => conv_std_logic_vector(FPGA_SUB_MINOR_VERSION, 8),
   
    --info_board_info         => "0000",
    --info_fpga_build_id      => "00000000000000000000000000000000",
    --info_fpga_device_id     => "00000000",
    --info_fpga_firmware_type => "00000000",
    --info_fpga_major_ver     => "00000000",
    --info_fpga_minor_ver     => "00000000",
    --info_fpga_sub_minor_ver => "00000000",

   
    led_out                 => led_out,
    
    pcie_rxn(0)             => pcie_rx_n(0),
    pcie_rxn(1)             => pcie_rx_n(1),
    pcie_rxp(0)             => pcie_rx_p(0),
    pcie_rxp(1)             => pcie_rx_p(1),
    pcie_txn(0)             => pcie_tx_n(0),
    pcie_txn(1)             => pcie_tx_n(1),
    pcie_txp(0)             => pcie_tx_p(0),
    pcie_txp(1)             => pcie_tx_p(1),

    pcie_sys_clk            => pcie_clk_100MHz,
    pcie_sys_rst_n          => sys_rst_n,
    ref_clk                 => ref_clk,
    --ref_clk                 => pcie_clk_100MHz,

    
    hispi_hispi_data_p      => xgs_hispi_sdata_p(HISPI_NUMBER_OF_DATA_LANES-1 downto 0),
    hispi_hispi_clk_p       => xgs_hispi_sclk_p,
    hispi_hispi_data_n      => xgs_hispi_sdata_n(HISPI_NUMBER_OF_DATA_LANES-1 downto 0),
    hispi_hispi_clk_n       => xgs_hispi_sclk_n,
    
    xgs_ctrl_xgs_clk_pll_en => xgs_clk_pll_en,
    xgs_ctrl_xgs_cs_n       => xgs_cs_n,
    xgs_ctrl_xgs_fwsi_en    => xgs_fwsi_en,
    xgs_ctrl_xgs_monitor0   => xgs_monitor(0),
    xgs_ctrl_xgs_monitor1   => xgs_monitor(1),
    xgs_ctrl_xgs_monitor2   => xgs_monitor(2),
    xgs_ctrl_xgs_power_good => xgs_power_good,
    xgs_ctrl_xgs_reset_n    => xgs_reset_n,
    xgs_ctrl_xgs_sclk       => xgs_sclk,
    xgs_ctrl_xgs_sdin       => xgs_sdin,
    xgs_ctrl_xgs_sdout      => xgs_sdout,
    xgs_ctrl_xgs_trig_int   => xgs_trig_int,
    xgs_ctrl_xgs_trig_rd    => xgs_trig_rd,
    debug_out               => debug_data,
    
    ext_ch_gt_drpclk_in    => ext_ch_gt_drpclk,
    ext_ch_gt_drpclk_out   => ext_ch_gt_drpclk  

  );


  



end struct;
