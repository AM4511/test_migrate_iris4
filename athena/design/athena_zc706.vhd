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


entity athena_zc706 is
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
    -- Zynq PS :
    ---------------------------------------------------------------------------
    PS_DDR_addr          : inout std_logic_vector (14 downto 0);
    PS_DDR_ba            : inout std_logic_vector (2 downto 0);
    PS_DDR_cas_n         : inout std_logic;
    PS_DDR_ck_n          : inout std_logic;
    PS_DDR_ck_p          : inout std_logic;
    PS_DDR_cke           : inout std_logic;
    PS_DDR_cs_n          : inout std_logic;
    PS_DDR_dm            : inout std_logic_vector (3 downto 0);
    PS_DDR_dq            : inout std_logic_vector (31 downto 0);
    PS_DDR_dqs_n         : inout std_logic_vector (3 downto 0);
    PS_DDR_dqs_p         : inout std_logic_vector (3 downto 0);
    PS_DDR_odt           : inout std_logic;
    PS_DDR_ras_n         : inout std_logic;
    PS_DDR_reset_n       : inout std_logic;
    PS_DDR_we_n          : inout std_logic;
    PS_FIXED_IO_ddr_vrn  : inout std_logic;
    PS_FIXED_IO_ddr_vrp  : inout std_logic;
    PS_FIXED_IO_mio      : inout std_logic_vector (53 downto 0);
    PS_FIXED_IO_ps_clk   : inout std_logic;
    PS_FIXED_IO_ps_porb  : inout std_logic;
    PS_FIXED_IO_ps_srstb : inout std_logic;

    ---------------------------------------------------------------------------
    -- I2C
    ---------------------------------------------------------------------------
    smbdata               : inout std_logic;
    smbclk                : inout std_logic;
    ---------------------------------------------------------------------------
    -- SiT9102 2.5V LVDS 200 MHz fixed-frequency oscillator (SiTime).
    -- See UG954 (v1.8) August 6, 2019; System Clock, page 36.
    ---------------------------------------------------------------------------
    SYSCLK_P : in std_logic;
    SYSCLK_N : in std_logic;

    ---------------------------------------------------------------------------
    -- Si570 3.3V LVDS I2C programmable oscillator, 156.250 MHz default
    -- See UG954 (v1.8) August 6, 2019; Programmable User Clock, page 37.
    ---------------------------------------------------------------------------
    -- USRCLK_P : in std_logic;
    -- USRCLK_N : in std_logic;

    ---------------------------------------------------------------------------
    -- User clock input SMAs, limit input swing voltage to VADJ_FPGA setting
    -- See UG954 (v1.8) August 6, 2019; User SMA Clock Source, page 38.
    ---------------------------------------------------------------------------
    -- USER_SMA_CLOCK_P : in std_logic;
    -- USER_SMA_CLOCK_N : in std_logic;

    ---------------------------------------------------------------------------
    -- GTX SMA Clock (SMA_MGT_REFCLK_P and SMA_MGT_REFCLK_N)
    -- See UG954 (v1.8) August 6, 2019; GTX SMA Clock (SMA_MGT_REFCLK_P and 
    -- SMA_MGT_REFCLK_N) page39.
    ---------------------------------------------------------------------------
    -- SMA_MGT_REFCLK_N : in std_logic;
    -- SMA_MGT_REFCLK_P : in std_logic;

    ---------------------------------------------------------------------------
    -- Si5324 Jitter Attenuated Clock
    -- See UG954 (v1.8) August 6, 2019; User SMA Clock Source, page 40.
    ---------------------------------------------------------------------------
    -- REC_CLOCK_C_P     : out std_logic;
    -- REC_CLOCK_C_N     : out std_logic;
    -- SI5324_INT_ALM_LS : in  std_logic;
    -- SI5324_RST_LS     : out std_logic;
    -- SI5324_OUT_C_N    : in std_logic;
    -- SI5324_OUT_C_P    : in std_logic;

    ---------------------------------------------------------------------------
    -- GTX Transceivers
    -- See UG954 (v1.8) August 6, 2019; GTX Transceivers p41.
    ---------------------------------------------------------------------------
    -- SMA_MGT_TX_P : out std_logic;
    -- SMA_MGT_TX_N : out std_logic;
    -- SMA_MGT_RX_P : in  std_logic;
    -- SMA_MGT_RX_N : in  std_logic;

    ---------------------------------------------------------------------------
    -- PCI Express Endpoint Connectivity
    -- See UG954 (v1.8) August 6, 2019; PCI Express Endpoint Connectivity page
    -- 46.
    ---------------------------------------------------------------------------
    PCIE_PERST_LS : in std_logic;

    PCIE_CLK_QO_P : in std_logic;
    PCIE_CLK_QO_N : in std_logic;

    PCIE_TX0_P : out std_logic;
    PCIE_TX0_N : out std_logic;
    PCIE_RX0_P : in  std_logic;
    PCIE_RX0_N : in  std_logic;

    --PCIE_TX1_P : out std_logic;
    --PCIE_TX1_N : out std_logic;
    --PCIE_RX1_P : in  std_logic;
    --PCIE_RX1_N : in  std_logic;

    -- PCIE_WAKE_B_LS : in std_logic;
    -- PCIE_TX2_P    : in std_logic;
    -- PCIE_RX2_P    : in std_logic;
    -- PCIE_TX2_N    : in std_logic;
    -- PCIE_RX2_N    : in std_logic;
    -- PCIE_TX3_P    : in std_logic;
    -- PCIE_RX3_P    : in std_logic;
    -- PCIE_TX3_N    : in std_logic;
    -- PCIE_RX3_N    : in std_logic;

    ---------------------------------------------------------------------------
    -- SFP+ Transceiver
    -- See UG954 (v1.8) August 6, 2019; SFP/SFP+ Module Connector, page 48.
    ---------------------------------------------------------------------------
    -- SFP_TX_DISABLE : out std_logic;
    -- SFP_TX_P       : out std_logic;
    -- SFP_TX_N       : out std_logic;
    -- SFP_RX_P       : in std_logic;
    -- SFP_RX_N       : in std_logic;

    ---------------------------------------------------------------------------
    -- HDMI Video Output
    -- See UG954 (v1.8) August 6, 2019; HDMI Video Output page 52.
    ---------------------------------------------------------------------------
    -- HDMI_R_CLK        : in std_logic;
    -- HDMI_INT          : in std_logic;
    -- HDMI_R_SPDIF      : in std_logic;
    -- HDMI_SPDIF_OUT_LS : in std_logic;
    -- HDMI_R_VSYNC      : in std_logic;
    -- HDMI_R_HSYNC      : in std_logic;
    -- HDMI_R_DE         : in std_logic;

    -- HDMI_R_D4  : in std_logic;
    -- HDMI_R_D5  : in std_logic;
    -- HDMI_R_D6  : in std_logic;
    -- HDMI_R_D7  : in std_logic;
    -- HDMI_R_D8  : in std_logic;
    -- HDMI_R_D9  : in std_logic;
    -- HDMI_R_D10 : in std_logic;
    -- HDMI_R_D11 : in std_logic;
    -- HDMI_R_D16 : in std_logic;
    -- HDMI_R_D17 : in std_logic;
    -- HDMI_R_D18 : in std_logic;
    -- HDMI_R_D19 : in std_logic;
    -- HDMI_R_D20 : in std_logic;
    -- HDMI_R_D21 : in std_logic;
    -- HDMI_R_D22 : in std_logic;
    -- HDMI_R_D23 : in std_logic;

    -- HDMI_R_D28 : in std_logic;
    -- HDMI_R_D29 : in std_logic;
    -- HDMI_R_D30 : in std_logic;
    -- HDMI_R_D31 : in std_logic;
    -- HDMI_R_D32 : in std_logic;
    -- HDMI_R_D33 : in std_logic;
    -- HDMI_R_D34 : in std_logic;
    -- HDMI_R_D35 : in std_logic;

    ---------------------------------------------------------------------------
    -- PL I2C Bus
    -- See UG954 (v1.8) August 6, 2019; I2C Bus page 55.
    ---------------------------------------------------------------------------
    -- IIC_SCL_MAIN_LS : in std_logic;
    -- IIC_SDA_MAIN_LS : in std_logic;

    ---------------------------------------------------------------------------
    -- Real Time Clock (RTC)
    -- See UG954 (v1.8) August 6, 2019; Real Time Clock (RTC) page 57.
    ---------------------------------------------------------------------------
    -- IIC_RTC_IRQ_1_B   : in std_logic;

    ---------------------------------------------------------------------------
    -- User LEDs
    -- See UG954 (v1.8) August 6, 2019; User LEDs page 60.
    ---------------------------------------------------------------------------
    GPIO_LED_LEFT  : out std_logic;     -- DS8
    -- GPIO_LED_CENTER : out std_logic;    -- DS9
    GPIO_LED_RIGHT : out std_logic;     -- DS10
    -- GPIO_LED_0 : out std_logic;         -- DS35
   
    heart_beat     : out std_logic;  
    ---------------------------------------------------------------------------
    -- User Pushbuttons
    -- See UG954 (v1.8) August 6, 2019; User Pushbuttons page 61.
    ---------------------------------------------------------------------------
    -- GPIO_SW_LEFT   : in std_logic;      -- SW7
    -- GPIO_SW_CENTER : in std_logic;      -- SW9
    -- GPIO_SW_RIGHT  : in std_logic;      -- SW8
    -- PL_CPU_RESET   : in std_logic;      -- SW13

    ---------------------------------------------------------------------------
    -- GPIO DIP Switch (SW12)
    -- See UG954 (v1.8) August 6, 2019; GPIO DIP Switch page 62.
    ---------------------------------------------------------------------------
    -- GPIO_DIP_SW0 : in std_logic;        -- DIP 1
    -- GPIO_DIP_SW1 : in std_logic;        -- DIP 2
    -- GPIO_DIP_SW2 : in std_logic;        -- DIP 3
    -- GPIO_DIP_SW3 : in std_logic;        -- DIP 4

    ---------------------------------------------------------------------------
    -- User PMOD GPIO Headers J58 (HDR_2X6)
    -- See UG954 (v1.8) August 6, 2019; User PMOD GPIO Headers page 62.
    -- See also Digilent: www.digilentinc.com (Pmod Peripheral Modules)
    ---------------------------------------------------------------------------
    -- PMOD1_0_LS : inout std_logic;       -- J58-Pin1
    -- PMOD1_1_LS : inout std_logic;       -- J58-Pin3
    -- PMOD1_2_LS : inout std_logic;       -- J58-Pin5
    -- PMOD1_3_LS : inout std_logic;       -- J58-Pin7
    -- PMOD1_4_LS : inout std_logic;       -- J58-Pin2
    -- PMOD1_5_LS : inout std_logic;       -- J58-Pin4
    -- PMOD1_6_LS : inout std_logic;       -- J58-Pin6
    -- PMOD1_7_LS : inout std_logic;       -- J58-Pin8

    ---------------------------------------------------------------------------
    -- Cooling Fan
    -- See UG954 (v1.8) August 6, 2019; Cooling Fan, page 84.
    ---------------------------------------------------------------------------
    -- SM_FAN_TACH : in std_logic;
    -- SM_FAN_PWM  : out std_logic;

    ---------------------------------------------------------------------------
    -- XADC Analog-to-Digital Converter
    -- See UG954 (v1.8) August 6, 2019; XADC Analog-to-Digital Converter, page 85.
    ---------------------------------------------------------------------------
    -- XADC_VAUX0P_R : in std_logic;
    -- XADC_VAUX0N_R : in std_logic;
    -- XADC_VAUX8P_R : in std_logic;
    -- XADC_VAUX8N_R : in std_logic;
    -- XADC_AD1_R_P  : in std_logic;
    -- XADC_AD1_R_N  : in std_logic;
    -- XADC_GPIO_0   : inout std_logic;
    -- XADC_GPIO_1   : inout std_logic;
    -- XADC_GPIO_2   : inout std_logic;
    -- XADC_GPIO_3   : inout std_logic;

    ---------------------------------------------------------------------------
    -- Programmable logic JTAG
    -- See UG954 (v1.8) August 6, 2019; 
    ---------------------------------------------------------------------------
    -- PL_PJTAG_TCK   : in std_logic;
    -- PL_PJTAG_TMS   : in std_logic;
    -- PL_PJTAG_TDI   : in std_logic;
    -- PL_PJTAG_TDO_R : in std_logic;

    ---------------------------------------------------------------------------
    -- DDR3 SODIMM Memory (PL)
    -- See UG954 (v1.8) August 6, 2019; DDR3 SODIMM Memory (PL) page 19
    -- The memory module at J1 is a 1 GB DDR3 small outline dual-inline memory module
    -- (SODIMM) :
    --
    --         * Part number: MT8JTF12864HZ-1G6G1 (Micron Technology)
    --         * Supply voltage: 1.5V
    --         * Datapath width: 64 bits
    --         * Data rate: Up to 1,600 MT/s
    ---------------------------------------------------------------------------
    -- DDR3 address interface
    -- PL_DDR3_A0  : in std_logic;
    -- PL_DDR3_A1  : in std_logic;
    -- PL_DDR3_A2  : in std_logic;
    -- PL_DDR3_A3  : in std_logic;
    -- PL_DDR3_A4  : in std_logic;
    -- PL_DDR3_A5  : in std_logic;
    -- PL_DDR3_A6  : in std_logic;
    -- PL_DDR3_A7  : in std_logic;
    -- PL_DDR3_A8  : in std_logic;
    -- PL_DDR3_A9  : in std_logic;
    -- PL_DDR3_A10 : in std_logic;
    -- PL_DDR3_A11 : in std_logic;
    -- PL_DDR3_A13 : in std_logic;
    -- PL_DDR3_A12 : in std_logic;
    -- PL_DDR3_A14 : in std_logic;
    -- PL_DDR3_A15 : in std_logic;

    -- DDR3 bank interface
    -- PL_DDR3_BA0 : in std_logic;
    -- PL_DDR3_BA1 : in std_logic;
    -- PL_DDR3_BA2 : in std_logic;

    -- DDR3 data interface
    -- PL_DDR3_D0  : in std_logic;
    -- PL_DDR3_D1  : in std_logic;
    -- PL_DDR3_D2  : in std_logic;
    -- PL_DDR3_D3  : in std_logic;
    -- PL_DDR3_D4  : in std_logic;
    -- PL_DDR3_D5  : in std_logic;
    -- PL_DDR3_D6  : in std_logic;
    -- PL_DDR3_D7  : in std_logic;
    -- PL_DDR3_D8  : in std_logic;
    -- PL_DDR3_D9  : in std_logic;
    -- PL_DDR3_D10 : in std_logic;
    -- PL_DDR3_D11 : in std_logic;
    -- PL_DDR3_D12 : in std_logic;
    -- PL_DDR3_D13 : in std_logic;
    -- PL_DDR3_D14 : in std_logic;
    -- PL_DDR3_D15 : in std_logic;
    -- PL_DDR3_D16 : in std_logic;
    -- PL_DDR3_D17 : in std_logic;
    -- PL_DDR3_D18 : in std_logic;
    -- PL_DDR3_D19 : in std_logic;
    -- PL_DDR3_D20 : in std_logic;
    -- PL_DDR3_D21 : in std_logic;
    -- PL_DDR3_D22 : in std_logic;
    -- PL_DDR3_D23 : in std_logic;
    -- PL_DDR3_D24 : in std_logic;
    -- PL_DDR3_D25 : in std_logic;
    -- PL_DDR3_D26 : in std_logic;
    -- PL_DDR3_D27 : in std_logic;
    -- PL_DDR3_D28 : in std_logic;
    -- PL_DDR3_D29 : in std_logic;
    -- PL_DDR3_D30 : in std_logic;
    -- PL_DDR3_D31 : in std_logic;
    -- PL_DDR3_D32 : in std_logic;
    -- PL_DDR3_D33 : in std_logic;
    -- PL_DDR3_D34 : in std_logic;
    -- PL_DDR3_D35 : in std_logic;
    -- PL_DDR3_D36 : in std_logic;
    -- PL_DDR3_D37 : in std_logic;
    -- PL_DDR3_D38 : in std_logic;
    -- PL_DDR3_D39 : in std_logic;
    -- PL_DDR3_D40 : in std_logic;
    -- PL_DDR3_D41 : in std_logic;
    -- PL_DDR3_D42 : in std_logic;
    -- PL_DDR3_D43 : in std_logic;
    -- PL_DDR3_D44 : in std_logic;
    -- PL_DDR3_D45 : in std_logic;
    -- PL_DDR3_D46 : in std_logic;
    -- PL_DDR3_D47 : in std_logic;
    -- PL_DDR3_D48 : in std_logic;
    -- PL_DDR3_D49 : in std_logic;
    -- PL_DDR3_D50 : in std_logic;
    -- PL_DDR3_D51 : in std_logic;
    -- PL_DDR3_D52 : in std_logic;
    -- PL_DDR3_D53 : in std_logic;
    -- PL_DDR3_D54 : in std_logic;
    -- PL_DDR3_D55 : in std_logic;
    -- PL_DDR3_D56 : in std_logic;
    -- PL_DDR3_D57 : in std_logic;
    -- PL_DDR3_D58 : in std_logic;
    -- PL_DDR3_D59 : in std_logic;
    -- PL_DDR3_D60 : in std_logic;
    -- PL_DDR3_D61 : in std_logic;
    -- PL_DDR3_D62 : in std_logic;
    -- PL_DDR3_D63 : in std_logic;

    -- DDR3 DM
    -- PL_DDR3_DM0 : in std_logic;
    -- PL_DDR3_DM1 : in std_logic;
    -- PL_DDR3_DM2 : in std_logic;
    -- PL_DDR3_DM3 : in std_logic;
    -- PL_DDR3_DM4 : in std_logic;
    -- PL_DDR3_DM5 : in std_logic;
    -- PL_DDR3_DM6 : in std_logic;
    -- PL_DDR3_DM7 : in std_logic;

    -- DDR3 DQS
    -- PL_DDR3_DQS0_P : in std_logic;
    -- PL_DDR3_DQS0_N : in std_logic;
    -- PL_DDR3_DQS1_P : in std_logic;
    -- PL_DDR3_DQS1_N : in std_logic;
    -- PL_DDR3_DQS2_P : in std_logic;
    -- PL_DDR3_DQS2_N : in std_logic;
    -- PL_DDR3_DQS3_P : in std_logic;
    -- PL_DDR3_DQS3_N : in std_logic;
    -- PL_DDR3_DQS4_P : in std_logic;
    -- PL_DDR3_DQS4_N : in std_logic;
    -- PL_DDR3_DQS5_P : in std_logic;
    -- PL_DDR3_DQS5_N : in std_logic;
    -- PL_DDR3_DQS6_P : in std_logic;
    -- PL_DDR3_DQS6_N : in std_logic;
    -- PL_DDR3_DQS7_P : in std_logic;
    -- PL_DDR3_DQS7_N : in std_logic;

    -- DDR3 control interface
    -- PL_DDR3_ODT0       : in std_logic;
    -- PL_DDR3_ODT1       : in std_logic;
    -- PL_DDR3_RESET_B    : in std_logic;
    -- PL_DDR3_S0_B       : in std_logic;
    -- PL_DDR3_S1_B       : in std_logic;
    -- PL_DDR3_TEMP_EVENT : in std_logic;
    -- PL_DDR3_WE_B       : in std_logic;
    -- PL_DDR3_CAS_B      : in std_logic;
    -- PL_DDR3_RAS_B      : in std_logic;
    -- PL_DDR3_CKE0       : in std_logic;
    -- PL_DDR3_CKE1       : in std_logic;
    -- PL_DDR3_CLK0_P     : in std_logic;
    -- PL_DDR3_CLK0_N     : in std_logic;
    -- PL_DDR3_CLK1_P     : in std_logic;
    -- PL_DDR3_CLK1_N     : in std_logic;

    ---------------------------------------------------------------------------
    -- High Pin Count (HPC) Connector (J37)
    -- See UG954 (v1.8) August 6, 2019; HPC Connector J37 p67.
    ---------------------------------------------------------------------------
    --FMC_HPC_CLK0_M2C_P : in std_logic;
    --FMC_HPC_CLK0_M2C_N : in std_logic;

    --FMC_HPC_CLK1_M2C_P : in std_logic;
    --FMC_HPC_CLK1_M2C_N : in std_logic;



    -- FMC_HPC_LA00_CC_P : in std_logic;
    -- FMC_HPC_LA00_CC_N : in std_logic;
    -- FMC_HPC_LA01_CC_P : in std_logic;
    -- FMC_HPC_LA01_CC_N : in std_logic;
    -- FMC_HPC_LA02_P    : in std_logic;
    -- FMC_HPC_LA02_N    : in std_logic;
    --FMC_HPC_LA03_P : in  std_logic;
    --FMC_HPC_LA03_N : in  std_logic;
    -- FMC_HPC_LA04_P    : in std_logic;
    -- FMC_HPC_LA04_N    : in std_logic;
    -- FMC_HPC_LA05_P    : in std_logic;
    -- FMC_HPC_LA05_N    : in std_logic;
    -- FMC_HPC_LA06_P    : in std_logic;
    -- FMC_HPC_LA06_N    : in std_logic;
    --FMC_HPC_LA07_P : in  std_logic;
    --FMC_HPC_LA07_N : in  std_logic;
    -- FMC_HPC_LA08_P    : in std_logic;
    -- FMC_HPC_LA08_N    : in std_logic;
    -- FMC_HPC_LA09_P    : in std_logic;
    -- FMC_HPC_LA09_N    : in std_logic;
    -- FMC_HPC_LA10_P    : in std_logic;
    -- FMC_HPC_LA10_N    : in std_logic;
    --FMC_HPC_LA11_P : in  std_logic;
    --FMC_HPC_LA11_N : in  std_logic;
    -- FMC_HPC_LA12_P    : in std_logic;
    -- FMC_HPC_LA12_N    : in std_logic;
    FMC_HPC_LA13_P : out std_logic;
    FMC_HPC_LA13_N : out std_logic;
    FMC_HPC_LA14_P : out std_logic;
    FMC_HPC_LA14_N : in  std_logic;
    FMC_HPC_LA15_P : out std_logic;
    FMC_HPC_LA15_N : out std_logic;
    FMC_HPC_LA16_P : in  std_logic;
    FMC_HPC_LA16_N : out std_logic
    -- FMC_HPC_LA17_CC_P : in std_logic;
    -- FMC_HPC_LA17_CC_N : in std_logic;
    -- FMC_HPC_LA18_CC_P : in std_logic;
    -- FMC_HPC_LA18_CC_N : in std_logic;
    -- FMC_HPC_LA19_P    : in std_logic;
    -- FMC_HPC_LA19_N    : in std_logic;
    -- FMC_HPC_LA20_P    : in std_logic;
    -- FMC_HPC_LA20_N    : in std_logic;
    -- FMC_HPC_LA21_P    : in std_logic;
    -- FMC_HPC_LA21_N    : in std_logic;
    -- FMC_HPC_LA22_P    : in std_logic;
    -- FMC_HPC_LA22_N    : in std_logic;
    --FMC_HPC_LA23_P : in  std_logic;
    --FMC_HPC_LA23_N : in  std_logic;
    --- FMC_HPC_LA24_P    : in std_logic;
    -- FMC_HPC_LA24_N    : in std_logic;
    -- FMC_HPC_LA25_P    : in std_logic;
    -- FMC_HPC_LA25_N    : in std_logic;
    -- FMC_HPC_LA26_P    : in std_logic;
    -- FMC_HPC_LA26_N    : in std_logic;
    --FMC_HPC_LA27_P : in  std_logic;
    --FMC_HPC_LA27_N : in  std_logic;
    --FMC_HPC_LA28_P : in  std_logic;
    --FMC_HPC_LA28_N : in  std_logic
    -- FMC_HPC_LA29_P    : in std_logic;
    -- FMC_HPC_LA29_N    : in std_logic;
    -- FMC_HPC_LA30_P    : in std_logic;
    -- FMC_HPC_LA30_N    : in std_logic;
    -- FMC_HPC_LA31_P    : in std_logic;
    -- FMC_HPC_LA31_N    : in std_logic;
    -- FMC_HPC_LA32_P    : in std_logic;
    -- FMC_HPC_LA32_N    : in std_logic;
    -- FMC_HPC_LA33_P    : in std_logic;
    -- FMC_HPC_LA33_N    : in std_logic;
    -- FMC_HPC_DP3_C2M_P       : in std_logic;
    -- FMC_HPC_DP3_M2C_P       : in std_logic;
    -- FMC_HPC_DP3_C2M_N       : in std_logic;
    -- FMC_HPC_DP3_M2C_N       : in std_logic;
    -- FMC_HPC_DP2_C2M_P       : in std_logic;
    -- FMC_HPC_DP2_M2C_P       : in std_logic;
    -- FMC_HPC_DP2_C2M_N       : in std_logic;
    -- FMC_HPC_GBTCLK0_M2C_C_P : in std_logic;
    -- FMC_HPC_DP2_M2C_N       : in std_logic;
    -- FMC_HPC_GBTCLK0_M2C_C_N : in std_logic;
    -- FMC_HPC_DP1_C2M_P       : in std_logic;
    -- FMC_HPC_DP1_M2C_P       : in std_logic;
    -- FMC_HPC_DP1_C2M_N       : in std_logic;
    -- FMC_HPC_DP1_M2C_N       : in std_logic;
    -- FMC_HPC_DP0_C2M_P       : in std_logic;
    -- FMC_HPC_DP0_M2C_P       : in std_logic;
    -- FMC_HPC_DP0_C2M_N       : in std_logic;
    -- FMC_HPC_DP0_M2C_N       : in std_logic;
    -- FMC_HPC_DP7_C2M_P       : in std_logic;
    -- FMC_HPC_DP7_M2C_P       : in std_logic;
    -- FMC_HPC_DP7_C2M_N       : in std_logic;
    -- FMC_HPC_DP7_M2C_N       : in std_logic;
    -- FMC_HPC_DP6_C2M_P       : in std_logic;
    -- FMC_HPC_DP6_M2C_P       : in std_logic;
    -- FMC_HPC_DP6_C2M_N       : in std_logic;
    -- FMC_HPC_GBTCLK1_M2C_C_P : in std_logic;
    -- FMC_HPC_DP6_M2C_N       : in std_logic;
    -- FMC_HPC_GBTCLK1_M2C_C_N : in std_logic;
    -- FMC_HPC_DP5_C2M_P       : in std_logic;
    -- FMC_HPC_DP5_M2C_P       : in std_logic;
    -- FMC_HPC_DP5_C2M_N       : in std_logic;
    -- FMC_HPC_DP5_M2C_N       : in std_logic;
    -- FMC_HPC_DP4_C2M_P       : in std_logic;
    -- FMC_HPC_DP4_M2C_P       : in std_logic;
    -- FMC_HPC_DP4_C2M_N       : in std_logic;
    -- FMC_HPC_DP4_M2C_N       : in std_logic;


    ---------------------------------------------------------------------------
    -- Low Pin Count (LPC) Connector (J5)
    -- See UG954 (v1.8) August 6, 2019; HPC Connector J5 p71.
    ---------------------------------------------------------------------------
    -- PWRCTL1_FMC_PG_C2M_LS : in std_logic;
    -- FMC_LPC_CLK0_M2C_P    : in std_logic;
    -- FMC_LPC_CLK0_M2C_N    : in std_logic;
    -- FMC_LPC_CLK1_M2C_P    : in std_logic;
    -- FMC_LPC_CLK1_M2C_N    : in std_logic;

   -- FMC_LPC_LA00_CC_P : in std_logic;
   -- FMC_LPC_LA00_CC_N : in std_logic;
   -- FMC_LPC_LA01_CC_P : in std_logic;
   -- FMC_LPC_LA01_CC_N : in std_logic;
   -- FMC_LPC_LA02_P    : in std_logic;
   -- FMC_LPC_LA02_N    : in std_logic;
   -- FMC_LPC_LA03_P    : in std_logic;
   -- FMC_LPC_LA03_N    : in std_logic;
   -- FMC_LPC_LA04_P    : in std_logic;
   -- FMC_LPC_LA04_N    : in std_logic;
   -- FMC_LPC_LA05_P    : in std_logic;
   -- FMC_LPC_LA05_N    : in std_logic;
   -- FMC_LPC_LA06_P    : in std_logic;
   -- FMC_LPC_LA06_N    : in std_logic;
   -- FMC_LPC_LA07_P    : in std_logic;
   -- FMC_LPC_LA07_N    : in std_logic;
   -- FMC_LPC_LA08_P    : in std_logic;
   -- FMC_LPC_LA08_N    : in std_logic;
   -- FMC_LPC_LA09_P    : in std_logic;
   -- FMC_LPC_LA09_N    : in std_logic;
   -- FMC_LPC_LA10_P    : in std_logic;
   -- FMC_LPC_LA10_N    : in std_logic;
   -- FMC_LPC_LA11_P    : in std_logic;
   -- FMC_LPC_LA11_N    : in std_logic;
   -- FMC_LPC_LA12_P    : in std_logic;
   -- FMC_LPC_LA12_N    : in std_logic;
   -- FMC_LPC_LA13_P    : in std_logic;
   -- FMC_LPC_LA13_N    : in std_logic;
   -- FMC_LPC_LA14_P    : in std_logic;
   -- FMC_LPC_LA14_N    : in std_logic;
   -- FMC_LPC_LA15_P    : in std_logic;
   -- FMC_LPC_LA15_N    : in std_logic;
   -- FMC_LPC_LA16_P    : in std_logic;
   -- FMC_LPC_LA16_N    : in std_logic;
   -- FMC_LPC_LA17_CC_P : in std_logic;
   -- FMC_LPC_LA17_CC_N : in std_logic;
   -- FMC_LPC_LA18_CC_P : in std_logic;
   -- FMC_LPC_LA18_CC_N : in std_logic;
   -- FMC_LPC_LA19_P    : in std_logic;
   -- FMC_LPC_LA19_N    : in std_logic;
   -- FMC_LPC_LA20_P    : in std_logic;
   -- FMC_LPC_LA20_N    : in std_logic;
   -- FMC_LPC_LA21_P    : in std_logic;
   -- FMC_LPC_LA21_N    : in std_logic;
   -- FMC_LPC_LA22_P    : in std_logic;
   -- FMC_LPC_LA22_N    : in std_logic;
   -- FMC_LPC_LA23_P    : in std_logic;
   -- FMC_LPC_LA23_N    : in std_logic;
   -- FMC_LPC_LA24_P    : in std_logic;
   -- FMC_LPC_LA24_N    : in std_logic;
   -- FMC_LPC_LA25_P    : in std_logic;
   -- FMC_LPC_LA25_N    : in std_logic;
   -- FMC_LPC_LA26_P    : in std_logic;
   -- FMC_LPC_LA26_N    : in std_logic;
   -- FMC_LPC_LA27_P    : in std_logic;
   -- FMC_LPC_LA27_N    : in std_logic;
   -- FMC_LPC_LA28_P    : in std_logic;
   -- FMC_LPC_LA28_N    : in std_logic;
   -- FMC_LPC_LA29_P    : in std_logic;
   -- FMC_LPC_LA29_N    : in std_logic;
   -- FMC_LPC_LA30_P    : in std_logic;
   -- FMC_LPC_LA30_N    : in std_logic;
   -- FMC_LPC_LA31_P    : in std_logic;
   -- FMC_LPC_LA31_N    : in std_logic;
   -- FMC_LPC_LA32_P    : in std_logic;
   -- FMC_LPC_LA32_N    : in std_logic;
   -- FMC_LPC_LA33_P    : in std_logic;
   -- FMC_LPC_LA33_N    : in std_logic;
   -- FMC_LPC_DP0_C2M_P       : in std_logic;
   -- FMC_LPC_DP0_M2C_P       : in std_logic;
   -- FMC_LPC_DP0_C2M_N       : in std_logic;
   -- FMC_LPC_DP0_M2C_N       : in std_logic;
   -- FMC_LPC_GBTCLK0_M2C_C_P : in std_logic;
   -- FMC_LPC_GBTCLK0_M2C_C_N : in std_logic;
   -- 6N1792        : in std_logic;
   -- 6N2017        : in std_logic;
   -- 8N241         : in std_logic;
   -- 8N242         : in std_logic;
   -- 8N91          : in std_logic;
   -- 8N236         : in std_logic;
   -- 8N235         : in std_logic;
   -- 8N281         : in std_logic;
   -- 8N261         : in std_logic;
   -- 8N278         : in std_logic;
   -- 8N282         : in std_logic
    );
end athena_zc706;


architecture struct of athena_zc706 is


  component system_wrapper is
    port (
      FPGA_Info_board_info : in STD_LOGIC_VECTOR ( 3 downto 0 );
      FPGA_Info_fpga_build_id : in STD_LOGIC_VECTOR ( 31 downto 0 );
      FPGA_Info_fpga_device_id : in STD_LOGIC_VECTOR ( 7 downto 0 );
      FPGA_Info_fpga_firmware_type : in STD_LOGIC_VECTOR ( 7 downto 0 );
      FPGA_Info_fpga_major_ver : in STD_LOGIC_VECTOR ( 7 downto 0 );
      FPGA_Info_fpga_minor_ver : in STD_LOGIC_VECTOR ( 7 downto 0 );
      FPGA_Info_fpga_sub_minor_ver : in STD_LOGIC_VECTOR ( 7 downto 0 );
      
      I2C_if_i2c_sdata : inout STD_LOGIC;
      I2C_if_i2c_slk :  inout STD_LOGIC;
      
      PS_DDR_addr             : inout std_logic_vector (14 downto 0);
      PS_DDR_ba               : inout std_logic_vector (2 downto 0);
      PS_DDR_cas_n            : inout std_logic;
      PS_DDR_ck_n             : inout std_logic;
      PS_DDR_ck_p             : inout std_logic;
      PS_DDR_cke              : inout std_logic;
      PS_DDR_cs_n             : inout std_logic;
      PS_DDR_dm               : inout std_logic_vector (3 downto 0);
      PS_DDR_dq               : inout std_logic_vector (31 downto 0);
      PS_DDR_dqs_n            : inout std_logic_vector (3 downto 0);
      PS_DDR_dqs_p            : inout std_logic_vector (3 downto 0);
      PS_DDR_odt              : inout std_logic;
      PS_DDR_ras_n            : inout std_logic;
      PS_DDR_reset_n          : inout std_logic;
      PS_DDR_we_n             : inout std_logic;
      PS_FIXED_IO_ddr_vrn     : inout std_logic;
      PS_FIXED_IO_ddr_vrp     : inout std_logic;
      PS_FIXED_IO_mio         : inout std_logic_vector (53 downto 0);
      PS_FIXED_IO_ps_clk      : inout std_logic;
      PS_FIXED_IO_ps_porb     : inout std_logic;
      PS_FIXED_IO_ps_srstb    : inout std_logic;
      anput_if_exposure       : out   std_logic;
      anput_if_ext_trig       : in    std_logic;
      anput_if_strobe         : out   std_logic;
      anput_if_trig_rdy       : out   std_logic;
      led_out                 : out   std_logic_vector (1 downto 0);
      --SYSCLK_200MHz           : in    std_logic;
      pcie_clk100MHz          : in    std_logic;
      pcie_reset_n            : in    std_logic;
      pcie_rxn                : in    std_logic;
      pcie_rxp                : in    std_logic;
      pcie_txn                : out   std_logic;
      pcie_txp                : out   std_logic;
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
      --xgs_hispi_clk_n         : in    std_logic_vector (1 downto 0);
      --xgs_hispi_clk_p         : in    std_logic_vector (1 downto 0);
      --xgs_hispi_data_n        : in    std_logic_vector (5 downto 0);
      --xgs_hispi_data_p        : in    std_logic_vector (5 downto 0)
      );
  end component;


  signal pcie_clk100MHz          : std_logic;
  signal pcie_reset_n            : std_logic;
  signal pcie_rxn                : std_logic;
  signal pcie_rxp                : std_logic;
  signal pcie_txn                : std_logic;
  signal pcie_txp                : std_logic;
  signal led_out                 : std_logic_vector (1 downto 0);
  signal anput_if_exposure       : std_logic;
  signal anput_if_ext_trig       : std_logic;
  signal anput_if_strobe         : std_logic;
  signal anput_if_trig_rdy       : std_logic;  signal xgs_ctrl_xgs_clk_pll_en : std_logic;
  signal xgs_ctrl_xgs_cs_n       : std_logic;
  signal xgs_ctrl_xgs_fwsi_en    : std_logic;
  signal xgs_ctrl_xgs_monitor0   : std_logic;
  signal xgs_ctrl_xgs_monitor1   : std_logic;
  signal xgs_ctrl_xgs_monitor2   : std_logic;
  signal xgs_ctrl_xgs_power_good : std_logic;
  signal xgs_ctrl_xgs_reset_n    : std_logic;
  signal xgs_ctrl_xgs_sclk       : std_logic;
  signal xgs_ctrl_xgs_sdin       : std_logic;
  signal xgs_ctrl_xgs_sdout      : std_logic;
  signal xgs_ctrl_xgs_trig_int   : std_logic;
  signal xgs_ctrl_xgs_trig_rd    : std_logic;
  signal xgs_hispi_clk_n         : std_logic_vector (1 downto 0);
  signal xgs_hispi_clk_p         : std_logic_vector (1 downto 0);
  signal xgs_hispi_data_n        : std_logic_vector (5 downto 0);
  signal xgs_hispi_data_p        : std_logic_vector (5 downto 0);

  signal SYSCLK_200MHz   : std_logic;
  signal heart_beat_cntr : std_logic_vector(27 downto 0):= (others=>'0');

begin

  -- Pour avoir access a la pin dedie du core PCIe, il faut instantier le IBUFDS_GTE2
  ibuf_pcie_clk_100MHz : IBUFDS_GTE2
    port map (
      O     => pcie_clk100MHz,
      I     => PCIE_CLK_QO_P,
      IB    => PCIE_CLK_QO_N,
      CEB   => '0',
      ODIV2 => open
      );

ibuf_200MHz : IBUFDS
    port map (
      O     => SYSCLK_200MHz,
      I     => SYSCLK_P,
      IB    => SYSCLK_N
      );




  xsystem_wrapper : system_wrapper
    port map(
      FPGA_Info_board_info         => "0000",
      FPGA_Info_fpga_build_id      => "00000000000000000000000000000000",
      FPGA_Info_fpga_device_id     => "00000000",
      FPGA_Info_fpga_firmware_type => "00000000",
      FPGA_Info_fpga_major_ver     => "00000000",
      FPGA_Info_fpga_minor_ver     => "00000000",
      FPGA_Info_fpga_sub_minor_ver => "00000000",
    
      I2C_if_i2c_sdata        => smbdata,
      I2C_if_i2c_slk          => smbclk,   
    
      PS_DDR_addr             => PS_DDR_addr,
      PS_DDR_ba               => PS_DDR_ba,
      PS_DDR_cas_n            => PS_DDR_cas_n,
      PS_DDR_ck_n             => PS_DDR_ck_n,
      PS_DDR_ck_p             => PS_DDR_ck_p,
      PS_DDR_cke              => PS_DDR_cke,
      PS_DDR_cs_n             => PS_DDR_cs_n,
      PS_DDR_dm               => PS_DDR_dm,
      PS_DDR_dq               => PS_DDR_dq,
      PS_DDR_dqs_n            => PS_DDR_dqs_n,
      PS_DDR_dqs_p            => PS_DDR_dqs_p,
      PS_DDR_odt              => PS_DDR_odt,
      PS_DDR_ras_n            => PS_DDR_ras_n,
      PS_DDR_reset_n          => PS_DDR_reset_n,
      PS_DDR_we_n             => PS_DDR_we_n,
      PS_FIXED_IO_ddr_vrn     => PS_FIXED_IO_ddr_vrn,
      PS_FIXED_IO_ddr_vrp     => PS_FIXED_IO_ddr_vrp,
      PS_FIXED_IO_mio         => PS_FIXED_IO_mio,
      PS_FIXED_IO_ps_clk      => PS_FIXED_IO_ps_clk,
      PS_FIXED_IO_ps_porb     => PS_FIXED_IO_ps_porb,
      PS_FIXED_IO_ps_srstb    => PS_FIXED_IO_ps_srstb,
      anput_if_exposure       => anput_if_exposure,
      anput_if_ext_trig       => anput_if_ext_trig,
      anput_if_strobe         => anput_if_strobe,
      anput_if_trig_rdy       => anput_if_trig_rdy,
      led_out                 => led_out,
      --SYSCLK_200MHz           => SYSCLK_200MHz,      
      pcie_clk100MHz          => pcie_clk100MHz,
      pcie_reset_n            => pcie_reset_n,
      pcie_rxn                => pcie_rxn,
      pcie_rxp                => pcie_rxp,
      pcie_txn                => pcie_txn,
      pcie_txp                => pcie_txp,
      xgs_ctrl_xgs_clk_pll_en => xgs_ctrl_xgs_clk_pll_en,
      xgs_ctrl_xgs_cs_n       => xgs_ctrl_xgs_cs_n,
      xgs_ctrl_xgs_fwsi_en    => xgs_ctrl_xgs_fwsi_en,
      xgs_ctrl_xgs_monitor0   => xgs_ctrl_xgs_monitor0,
      xgs_ctrl_xgs_monitor1   => xgs_ctrl_xgs_monitor1,
      xgs_ctrl_xgs_monitor2   => xgs_ctrl_xgs_monitor2,
      xgs_ctrl_xgs_power_good => xgs_ctrl_xgs_power_good,
      xgs_ctrl_xgs_reset_n    => xgs_ctrl_xgs_reset_n,
      xgs_ctrl_xgs_sclk       => xgs_ctrl_xgs_sclk,
      xgs_ctrl_xgs_sdin       => xgs_ctrl_xgs_sdin,
      xgs_ctrl_xgs_sdout      => xgs_ctrl_xgs_sdout,
      xgs_ctrl_xgs_trig_int   => xgs_ctrl_xgs_trig_int,
      xgs_ctrl_xgs_trig_rd    => xgs_ctrl_xgs_trig_rd
      --xgs_hispi_clk_n         => xgs_hispi_clk_n,
      --xgs_hispi_clk_p         => xgs_hispi_clk_p,
      --xgs_hispi_data_n        => xgs_hispi_data_n,
      --xgs_hispi_data_p        => xgs_hispi_data_p
      );



  -----------------------------------------------------------------------------
  -- Triggers TBD!!!!
  -----------------------------------------------------------------------------
  -- OPEN <= anput_if_exposure;
  anput_if_ext_trig <= '0';
  -- OPEN <= anput_if_strobe;
  -- OPEN <= anput_if_trig_rdy;

  -----------------------------------------------------------------------------
  -- Led
  -----------------------------------------------------------------------------
  --GPIO_LED_LEFT  <= led_out(0);
  --GPIO_LED_RIGHT <= led_out(1);

  -----------------------------------------------------------------------------
  -- PCIe Lane 0
  -----------------------------------------------------------------------------
  pcie_rxn <= PCIE_RX0_N;
  pcie_rxp <= PCIE_RX0_P;
  PCIE_TX0_N  <= pcie_txn;
  PCIE_TX0_P  <= pcie_txp;

  -----------------------------------------------------------------------------
  -- PCIe Lane 1
  -----------------------------------------------------------------------------
  --pcie_rxn(1) <= PCIE_RX1_N;
  --pcie_rxp(1) <= PCIE_RX1_P;
  --PCIE_TX1_N  <= pcie_txn(1);
  --PCIE_TX1_P  <= pcie_txp(1);

  pcie_reset_n <= PCIE_PERST_LS;

  -----------------------------------------------------------------------------
  -- XGS controller TBD!!!
  -----------------------------------------------------------------------------
  -- On IRIS4 connected on PLL on board
  -- open <= xgs_ctrl_xgs_clk_pll_en;


  -- SPI
  FMC_HPC_LA13_P          <= xgs_ctrl_xgs_sclk;
  FMC_HPC_LA14_P <= xgs_ctrl_xgs_cs_n;
  xgs_ctrl_xgs_sdin       <= FMC_HPC_LA14_N;
  FMC_HPC_LA13_N          <= xgs_ctrl_xgs_sdout;
  -- open <= xgs_ctrl_xgs_fwsi_en;

  -- Monitor TBD
  xgs_ctrl_xgs_monitor0 <= '0';
  xgs_ctrl_xgs_monitor1 <= '0';
  xgs_ctrl_xgs_monitor2 <= FMC_HPC_LA16_P;

  -- Power good du sensor board (PMIC)
  xgs_ctrl_xgs_power_good <= '1';

  FMC_HPC_LA15_P          <= xgs_ctrl_xgs_reset_n;

  -- Exposure
  FMC_HPC_LA15_N          <= xgs_ctrl_xgs_trig_int;

  -- TRigger read line. Not used on the zynq 
  FMC_HPC_LA16_N          <= xgs_ctrl_xgs_trig_rd;


  -----------------------------------------------------------------------------
  -- Top HiSPi
  -----------------------------------------------------------------------------
  --xgs_hispi_clk_n(0) <= FMC_HPC_CLK0_M2C_N;
  --xgs_hispi_clk_p(0) <= FMC_HPC_CLK0_M2C_P;

  --xgs_hispi_data_n(0) <= FMC_HPC_LA11_N;
  --xgs_hispi_data_p(0) <= FMC_HPC_LA11_P;
  --xgs_hispi_data_n(2) <= FMC_HPC_LA07_N;
  --xgs_hispi_data_p(2) <= FMC_HPC_LA07_P;
  --xgs_hispi_data_n(4) <= FMC_HPC_LA03_N;
  --xgs_hispi_data_p(4) <= FMC_HPC_LA03_P;


  -----------------------------------------------------------------------------
  -- Bottom HiSPi
  -----------------------------------------------------------------------------
  --xgs_hispi_clk_n(1) <= FMC_HPC_CLK1_M2C_N;
  --xgs_hispi_clk_p(1) <= FMC_HPC_CLK1_M2C_P;

  --xgs_hispi_data_n(1) <= FMC_HPC_LA28_N;
  --xgs_hispi_data_p(1) <= FMC_HPC_LA28_P;
  --xgs_hispi_data_n(3) <= FMC_HPC_LA27_N;
  --xgs_hispi_data_p(3) <= FMC_HPC_LA27_P;
  --xgs_hispi_data_n(5) <= FMC_HPC_LA23_N;
  --xgs_hispi_data_p(5) <= FMC_HPC_LA23_P;



  process(SYSCLK_200MHz)
  begin
    if(rising_edge(SYSCLK_200MHz)) then
      heart_beat_cntr <= heart_beat_cntr+'1';      
    end if;
  end process;  

  heart_beat <= heart_beat_cntr(27);


  GPIO_LED_LEFT  <= heart_beat_cntr(27) and not(PCIE_PERST_LS);
  GPIO_LED_RIGHT <= '0';







end struct;
