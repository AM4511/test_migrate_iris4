-------------------------------------------------------------------------------
-- File                : regfile_xgs_athena.vhd
-- Project             : FDK
-- Module              : regfile_xgs_athena_pack
-- Created on          : 2021/12/13 11:39:54
-- Created by          : jmansill
-- FDK IDE Version     : 4.7.0_beta3
-- Build ID            : I20191219-1127
-- Register file CRC32 : 0x4F0D5164
-------------------------------------------------------------------------------
library ieee;        -- The standard IEEE library
   use ieee.std_logic_1164.all  ;
   use ieee.numeric_std.all     ;
   use ieee.std_logic_unsigned.all;


package regfile_xgs_athena_pack is
   --------------------------------------------------------------------------------
   -- Address constants
   --------------------------------------------------------------------------------
   constant K_SYSTEM_TAG_ADDR                 : natural := 16#0#;
   constant K_SYSTEM_VERSION_ADDR             : natural := 16#4#;
   constant K_SYSTEM_CAPABILITY_ADDR          : natural := 16#8#;
   constant K_SYSTEM_SCRATCHPAD_ADDR          : natural := 16#c#;
   constant K_DMA_CTRL_ADDR                   : natural := 16#70#;
   constant K_DMA_FSTART_ADDR                 : natural := 16#78#;
   constant K_DMA_FSTART_HIGH_ADDR            : natural := 16#7c#;
   constant K_DMA_FSTART_G_ADDR               : natural := 16#80#;
   constant K_DMA_FSTART_G_HIGH_ADDR          : natural := 16#84#;
   constant K_DMA_FSTART_R_ADDR               : natural := 16#88#;
   constant K_DMA_FSTART_R_HIGH_ADDR          : natural := 16#8c#;
   constant K_DMA_LINE_PITCH_ADDR             : natural := 16#90#;
   constant K_DMA_LINE_SIZE_ADDR              : natural := 16#94#;
   constant K_DMA_CSC_ADDR                    : natural := 16#98#;
   constant K_DMA_OUTPUT_BUFFER_ADDR          : natural := 16#a8#;
   constant K_DMA_TLP_ADDR                    : natural := 16#ac#;
   constant K_DMA_ROI_X_ADDR                  : natural := 16#b0#;
   constant K_DMA_ROI_Y_ADDR                  : natural := 16#bc#;
   constant K_ACQ_GRAB_CTRL_ADDR              : natural := 16#100#;
   constant K_ACQ_GRAB_STAT_ADDR              : natural := 16#108#;
   constant K_ACQ_READOUT_CFG1_ADDR           : natural := 16#110#;
   constant K_ACQ_READOUT_CFG_FRAME_LINE_ADDR : natural := 16#114#;
   constant K_ACQ_READOUT_CFG2_ADDR           : natural := 16#118#;
   constant K_ACQ_READOUT_CFG3_ADDR           : natural := 16#120#;
   constant K_ACQ_READOUT_CFG4_ADDR           : natural := 16#124#;
   constant K_ACQ_EXP_CTRL1_ADDR              : natural := 16#128#;
   constant K_ACQ_EXP_CTRL2_ADDR              : natural := 16#130#;
   constant K_ACQ_EXP_CTRL3_ADDR              : natural := 16#138#;
   constant K_ACQ_TRIGGER_DELAY_ADDR          : natural := 16#140#;
   constant K_ACQ_STROBE_CTRL1_ADDR           : natural := 16#148#;
   constant K_ACQ_STROBE_CTRL2_ADDR           : natural := 16#150#;
   constant K_ACQ_ACQ_SER_CTRL_ADDR           : natural := 16#158#;
   constant K_ACQ_ACQ_SER_ADDATA_ADDR         : natural := 16#160#;
   constant K_ACQ_ACQ_SER_STAT_ADDR           : natural := 16#168#;
   constant K_ACQ_SENSOR_CTRL_ADDR            : natural := 16#190#;
   constant K_ACQ_SENSOR_STAT_ADDR            : natural := 16#198#;
   constant K_ACQ_SENSOR_SUBSAMPLING_ADDR     : natural := 16#19c#;
   constant K_ACQ_SENSOR_GAIN_ANA_ADDR        : natural := 16#1a4#;
   constant K_ACQ_SENSOR_ROI_Y_START_ADDR     : natural := 16#1a8#;
   constant K_ACQ_SENSOR_ROI_Y_SIZE_ADDR      : natural := 16#1ac#;
   constant K_ACQ_SENSOR_M_LINES_ADDR         : natural := 16#1b8#;
   constant K_ACQ_SENSOR_DP_GR_ADDR           : natural := 16#1bc#;
   constant K_ACQ_SENSOR_DP_GB_ADDR           : natural := 16#1c0#;
   constant K_ACQ_SENSOR_DP_R_ADDR            : natural := 16#1c4#;
   constant K_ACQ_SENSOR_DP_B_ADDR            : natural := 16#1c8#;
   constant K_ACQ_SENSOR_GAIN_DIG_G_ADDR      : natural := 16#1cc#;
   constant K_ACQ_SENSOR_GAIN_DIG_RB_ADDR     : natural := 16#1d0#;
   constant K_ACQ_DEBUG_PINS_ADDR             : natural := 16#1e0#;
   constant K_ACQ_TRIGGER_MISSED_ADDR         : natural := 16#1e8#;
   constant K_ACQ_SENSOR_FPS_ADDR             : natural := 16#1f0#;
   constant K_ACQ_SENSOR_FPS2_ADDR            : natural := 16#1f4#;
   constant K_ACQ_DEBUG_ADDR                  : natural := 16#2a0#;
   constant K_ACQ_DEBUG_CNTR1_ADDR            : natural := 16#2a8#;
   constant K_ACQ_DEBUG_CNTR2_ADDR            : natural := 16#2b0#;
   constant K_ACQ_DEBUG_CNTR3_ADDR            : natural := 16#2b4#;
   constant K_ACQ_EXP_FOT_ADDR                : natural := 16#2b8#;
   constant K_ACQ_ACQ_SFNC_ADDR               : natural := 16#2c0#;
   constant K_ACQ_TIMER_CTRL_ADDR             : natural := 16#2d0#;
   constant K_ACQ_TIMER_DELAY_ADDR            : natural := 16#2d4#;
   constant K_ACQ_TIMER_DURATION_ADDR         : natural := 16#2d8#;
   constant K_HISPI_CTRL_ADDR                 : natural := 16#400#;
   constant K_HISPI_STATUS_ADDR               : natural := 16#404#;
   constant K_HISPI_IDELAYCTRL_STATUS_ADDR    : natural := 16#408#;
   constant K_HISPI_IDLE_CHARACTER_ADDR       : natural := 16#40c#;
   constant K_HISPI_PHY_ADDR                  : natural := 16#410#;
   constant K_HISPI_FRAME_CFG_ADDR            : natural := 16#414#;
   constant K_HISPI_FRAME_CFG_X_VALID_ADDR    : natural := 16#418#;
   constant K_HISPI_LANE_DECODER_STATUS_0_ADDR : natural := 16#424#;
   constant K_HISPI_LANE_DECODER_STATUS_1_ADDR : natural := 16#428#;
   constant K_HISPI_LANE_DECODER_STATUS_2_ADDR : natural := 16#42c#;
   constant K_HISPI_LANE_DECODER_STATUS_3_ADDR : natural := 16#430#;
   constant K_HISPI_LANE_DECODER_STATUS_4_ADDR : natural := 16#434#;
   constant K_HISPI_LANE_DECODER_STATUS_5_ADDR : natural := 16#438#;
   constant K_HISPI_TAP_HISTOGRAM_0_ADDR      : natural := 16#43c#;
   constant K_HISPI_TAP_HISTOGRAM_1_ADDR      : natural := 16#440#;
   constant K_HISPI_TAP_HISTOGRAM_2_ADDR      : natural := 16#444#;
   constant K_HISPI_TAP_HISTOGRAM_3_ADDR      : natural := 16#448#;
   constant K_HISPI_TAP_HISTOGRAM_4_ADDR      : natural := 16#44c#;
   constant K_HISPI_TAP_HISTOGRAM_5_ADDR      : natural := 16#450#;
   constant K_HISPI_DEBUG_ADDR                : natural := 16#454#;
   constant K_DPC_DPC_CAPABILITIES_ADDR       : natural := 16#480#;
   constant K_DPC_DPC_LIST_CTRL_ADDR          : natural := 16#484#;
   constant K_DPC_DPC_LIST_STAT_ADDR          : natural := 16#488#;
   constant K_DPC_DPC_LIST_DATA1_ADDR         : natural := 16#48c#;
   constant K_DPC_DPC_LIST_DATA2_ADDR         : natural := 16#490#;
   constant K_DPC_DPC_LIST_DATA1_RD_ADDR      : natural := 16#494#;
   constant K_DPC_DPC_LIST_DATA2_RD_ADDR      : natural := 16#498#;
   constant K_LUT_LUT_CAPABILITIES_ADDR       : natural := 16#4b0#;
   constant K_LUT_LUT_CTRL_ADDR               : natural := 16#4b4#;
   constant K_LUT_LUT_RB_ADDR                 : natural := 16#4b8#;
   constant K_BAYER_BAYER_CAPABILITIES_ADDR   : natural := 16#4c0#;
   constant K_BAYER_WB_MUL1_ADDR              : natural := 16#4c4#;
   constant K_BAYER_WB_MUL2_ADDR              : natural := 16#4c8#;
   constant K_BAYER_WB_B_ACC_ADDR             : natural := 16#4cc#;
   constant K_BAYER_WB_G_ACC_ADDR             : natural := 16#4d0#;
   constant K_BAYER_WB_R_ACC_ADDR             : natural := 16#4d4#;
   constant K_BAYER_CCM_CTRL_ADDR             : natural := 16#4d8#;
   constant K_BAYER_CCM_KR1_ADDR              : natural := 16#4dc#;
   constant K_BAYER_CCM_KR2_ADDR              : natural := 16#4e0#;
   constant K_BAYER_CCM_KG1_ADDR              : natural := 16#4e4#;
   constant K_BAYER_CCM_KG2_ADDR              : natural := 16#4e8#;
   constant K_BAYER_CCM_KB1_ADDR              : natural := 16#4ec#;
   constant K_BAYER_CCM_KB2_ADDR              : natural := 16#4f0#;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: TAG
   ------------------------------------------------------------------------------------------
   type SYSTEM_TAG_TYPE is record
      VALUE          : std_logic_vector(23 downto 0);
   end record SYSTEM_TAG_TYPE;

   constant INIT_SYSTEM_TAG_TYPE : SYSTEM_TAG_TYPE := (
      VALUE           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : SYSTEM_TAG_TYPE) return std_logic_vector;
   function to_SYSTEM_TAG_TYPE(stdlv : std_logic_vector(31 downto 0)) return SYSTEM_TAG_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: VERSION
   ------------------------------------------------------------------------------------------
   type SYSTEM_VERSION_TYPE is record
      MAJOR          : std_logic_vector(7 downto 0);
      MINOR          : std_logic_vector(7 downto 0);
      HW             : std_logic_vector(7 downto 0);
   end record SYSTEM_VERSION_TYPE;

   constant INIT_SYSTEM_VERSION_TYPE : SYSTEM_VERSION_TYPE := (
      MAJOR           => (others=> 'Z'),
      MINOR           => (others=> 'Z'),
      HW              => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : SYSTEM_VERSION_TYPE) return std_logic_vector;
   function to_SYSTEM_VERSION_TYPE(stdlv : std_logic_vector(31 downto 0)) return SYSTEM_VERSION_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: CAPABILITY
   ------------------------------------------------------------------------------------------
   type SYSTEM_CAPABILITY_TYPE is record
      VALUE          : std_logic_vector(7 downto 0);
   end record SYSTEM_CAPABILITY_TYPE;

   constant INIT_SYSTEM_CAPABILITY_TYPE : SYSTEM_CAPABILITY_TYPE := (
      VALUE           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : SYSTEM_CAPABILITY_TYPE) return std_logic_vector;
   function to_SYSTEM_CAPABILITY_TYPE(stdlv : std_logic_vector(31 downto 0)) return SYSTEM_CAPABILITY_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: SCRATCHPAD
   ------------------------------------------------------------------------------------------
   type SYSTEM_SCRATCHPAD_TYPE is record
      VALUE          : std_logic_vector(31 downto 0);
   end record SYSTEM_SCRATCHPAD_TYPE;

   constant INIT_SYSTEM_SCRATCHPAD_TYPE : SYSTEM_SCRATCHPAD_TYPE := (
      VALUE           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : SYSTEM_SCRATCHPAD_TYPE) return std_logic_vector;
   function to_SYSTEM_SCRATCHPAD_TYPE(stdlv : std_logic_vector(31 downto 0)) return SYSTEM_SCRATCHPAD_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: CTRL
   ------------------------------------------------------------------------------------------
   type DMA_CTRL_TYPE is record
      GRAB_QUEUE_EN  : std_logic;
   end record DMA_CTRL_TYPE;

   constant INIT_DMA_CTRL_TYPE : DMA_CTRL_TYPE := (
      GRAB_QUEUE_EN   => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DMA_CTRL_TYPE) return std_logic_vector;
   function to_DMA_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_CTRL_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: FSTART
   ------------------------------------------------------------------------------------------
   type DMA_FSTART_TYPE is record
      VALUE          : std_logic_vector(31 downto 0);
   end record DMA_FSTART_TYPE;

   constant INIT_DMA_FSTART_TYPE : DMA_FSTART_TYPE := (
      VALUE           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DMA_FSTART_TYPE) return std_logic_vector;
   function to_DMA_FSTART_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_FSTART_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: FSTART_HIGH
   ------------------------------------------------------------------------------------------
   type DMA_FSTART_HIGH_TYPE is record
      VALUE          : std_logic_vector(31 downto 0);
   end record DMA_FSTART_HIGH_TYPE;

   constant INIT_DMA_FSTART_HIGH_TYPE : DMA_FSTART_HIGH_TYPE := (
      VALUE           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DMA_FSTART_HIGH_TYPE) return std_logic_vector;
   function to_DMA_FSTART_HIGH_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_FSTART_HIGH_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: FSTART_G
   ------------------------------------------------------------------------------------------
   type DMA_FSTART_G_TYPE is record
      VALUE          : std_logic_vector(31 downto 0);
   end record DMA_FSTART_G_TYPE;

   constant INIT_DMA_FSTART_G_TYPE : DMA_FSTART_G_TYPE := (
      VALUE           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DMA_FSTART_G_TYPE) return std_logic_vector;
   function to_DMA_FSTART_G_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_FSTART_G_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: FSTART_G_HIGH
   ------------------------------------------------------------------------------------------
   type DMA_FSTART_G_HIGH_TYPE is record
      VALUE          : std_logic_vector(31 downto 0);
   end record DMA_FSTART_G_HIGH_TYPE;

   constant INIT_DMA_FSTART_G_HIGH_TYPE : DMA_FSTART_G_HIGH_TYPE := (
      VALUE           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DMA_FSTART_G_HIGH_TYPE) return std_logic_vector;
   function to_DMA_FSTART_G_HIGH_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_FSTART_G_HIGH_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: FSTART_R
   ------------------------------------------------------------------------------------------
   type DMA_FSTART_R_TYPE is record
      VALUE          : std_logic_vector(31 downto 0);
   end record DMA_FSTART_R_TYPE;

   constant INIT_DMA_FSTART_R_TYPE : DMA_FSTART_R_TYPE := (
      VALUE           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DMA_FSTART_R_TYPE) return std_logic_vector;
   function to_DMA_FSTART_R_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_FSTART_R_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: FSTART_R_HIGH
   ------------------------------------------------------------------------------------------
   type DMA_FSTART_R_HIGH_TYPE is record
      VALUE          : std_logic_vector(31 downto 0);
   end record DMA_FSTART_R_HIGH_TYPE;

   constant INIT_DMA_FSTART_R_HIGH_TYPE : DMA_FSTART_R_HIGH_TYPE := (
      VALUE           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DMA_FSTART_R_HIGH_TYPE) return std_logic_vector;
   function to_DMA_FSTART_R_HIGH_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_FSTART_R_HIGH_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: LINE_PITCH
   ------------------------------------------------------------------------------------------
   type DMA_LINE_PITCH_TYPE is record
      VALUE          : std_logic_vector(15 downto 0);
   end record DMA_LINE_PITCH_TYPE;

   constant INIT_DMA_LINE_PITCH_TYPE : DMA_LINE_PITCH_TYPE := (
      VALUE           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DMA_LINE_PITCH_TYPE) return std_logic_vector;
   function to_DMA_LINE_PITCH_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_LINE_PITCH_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: LINE_SIZE
   ------------------------------------------------------------------------------------------
   type DMA_LINE_SIZE_TYPE is record
      VALUE          : std_logic_vector(14 downto 0);
   end record DMA_LINE_SIZE_TYPE;

   constant INIT_DMA_LINE_SIZE_TYPE : DMA_LINE_SIZE_TYPE := (
      VALUE           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DMA_LINE_SIZE_TYPE) return std_logic_vector;
   function to_DMA_LINE_SIZE_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_LINE_SIZE_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: CSC
   ------------------------------------------------------------------------------------------
   type DMA_CSC_TYPE is record
      COLOR_SPACE    : std_logic_vector(2 downto 0);
      SUB_X          : std_logic_vector(3 downto 0);
      REVERSE_Y      : std_logic;
      REVERSE_X      : std_logic;
   end record DMA_CSC_TYPE;

   constant INIT_DMA_CSC_TYPE : DMA_CSC_TYPE := (
      COLOR_SPACE     => (others=> 'Z'),
      SUB_X           => (others=> 'Z'),
      REVERSE_Y       => 'Z',
      REVERSE_X       => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DMA_CSC_TYPE) return std_logic_vector;
   function to_DMA_CSC_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_CSC_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: OUTPUT_BUFFER
   ------------------------------------------------------------------------------------------
   type DMA_OUTPUT_BUFFER_TYPE is record
      MAX_LINE_BUFF_CNT: std_logic_vector(2 downto 0);
      LINE_PTR_WIDTH : std_logic_vector(1 downto 0);
      ADDRESS_BUS_WIDTH: std_logic_vector(3 downto 0);
      PCIE_BACK_PRESSURE: std_logic;
      PCIE_BACK_PRESSURE_set: std_logic;
      CLR_MAX_LINE_BUFF_CNT: std_logic;
   end record DMA_OUTPUT_BUFFER_TYPE;

   constant INIT_DMA_OUTPUT_BUFFER_TYPE : DMA_OUTPUT_BUFFER_TYPE := (
      MAX_LINE_BUFF_CNT => (others=> 'Z'),
      LINE_PTR_WIDTH  => (others=> 'Z'),
      ADDRESS_BUS_WIDTH => (others=> 'Z'),
      PCIE_BACK_PRESSURE => 'Z',
      PCIE_BACK_PRESSURE_set => 'Z',
      CLR_MAX_LINE_BUFF_CNT => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DMA_OUTPUT_BUFFER_TYPE) return std_logic_vector;
   function to_DMA_OUTPUT_BUFFER_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_OUTPUT_BUFFER_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: TLP
   ------------------------------------------------------------------------------------------
   type DMA_TLP_TYPE is record
      MAX_PAYLOAD    : std_logic_vector(11 downto 0);
      BUS_MASTER_EN  : std_logic;
      CFG_MAX_PLD    : std_logic_vector(2 downto 0);
   end record DMA_TLP_TYPE;

   constant INIT_DMA_TLP_TYPE : DMA_TLP_TYPE := (
      MAX_PAYLOAD     => (others=> 'Z'),
      BUS_MASTER_EN   => 'Z',
      CFG_MAX_PLD     => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DMA_TLP_TYPE) return std_logic_vector;
   function to_DMA_TLP_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_TLP_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: ROI_X
   ------------------------------------------------------------------------------------------
   type DMA_ROI_X_TYPE is record
      ROI_EN         : std_logic;
      X_SIZE         : std_logic_vector(12 downto 0);
      X_START        : std_logic_vector(12 downto 0);
   end record DMA_ROI_X_TYPE;

   constant INIT_DMA_ROI_X_TYPE : DMA_ROI_X_TYPE := (
      ROI_EN          => 'Z',
      X_SIZE          => (others=> 'Z'),
      X_START         => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DMA_ROI_X_TYPE) return std_logic_vector;
   function to_DMA_ROI_X_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_ROI_X_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: ROI_Y
   ------------------------------------------------------------------------------------------
   type DMA_ROI_Y_TYPE is record
      ROI_EN         : std_logic;
      Y_SIZE         : std_logic_vector(12 downto 0);
      Y_START        : std_logic_vector(12 downto 0);
   end record DMA_ROI_Y_TYPE;

   constant INIT_DMA_ROI_Y_TYPE : DMA_ROI_Y_TYPE := (
      ROI_EN          => 'Z',
      Y_SIZE          => (others=> 'Z'),
      Y_START         => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DMA_ROI_Y_TYPE) return std_logic_vector;
   function to_DMA_ROI_Y_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_ROI_Y_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: GRAB_CTRL
   ------------------------------------------------------------------------------------------
   type ACQ_GRAB_CTRL_TYPE is record
      RESET_GRAB     : std_logic;
      GRAB_ROI2_EN   : std_logic;
      ABORT_GRAB     : std_logic;
      TRIGGER_OVERLAP_BUFFn: std_logic;
      TRIGGER_OVERLAP: std_logic;
      TRIGGER_ACT    : std_logic_vector(2 downto 0);
      TRIGGER_SRC    : std_logic_vector(2 downto 0);
      GRAB_SS        : std_logic;
      BUFFER_ID      : std_logic;
      GRAB_CMD       : std_logic;
   end record ACQ_GRAB_CTRL_TYPE;

   constant INIT_ACQ_GRAB_CTRL_TYPE : ACQ_GRAB_CTRL_TYPE := (
      RESET_GRAB      => 'Z',
      GRAB_ROI2_EN    => 'Z',
      ABORT_GRAB      => 'Z',
      TRIGGER_OVERLAP_BUFFn => 'Z',
      TRIGGER_OVERLAP => 'Z',
      TRIGGER_ACT     => (others=> 'Z'),
      TRIGGER_SRC     => (others=> 'Z'),
      GRAB_SS         => 'Z',
      BUFFER_ID       => 'Z',
      GRAB_CMD        => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_GRAB_CTRL_TYPE) return std_logic_vector;
   function to_ACQ_GRAB_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_GRAB_CTRL_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: GRAB_STAT
   ------------------------------------------------------------------------------------------
   type ACQ_GRAB_STAT_TYPE is record
      GRAB_CMD_DONE  : std_logic;
      ABORT_PET      : std_logic;
      ABORT_DELAI    : std_logic;
      ABORT_DONE     : std_logic;
      TRIGGER_RDY    : std_logic;
      ABORT_MNGR_STAT: std_logic_vector(2 downto 0);
      TRIG_MNGR_STAT : std_logic_vector(3 downto 0);
      TIMER_MNGR_STAT: std_logic_vector(2 downto 0);
      GRAB_MNGR_STAT : std_logic_vector(3 downto 0);
      GRAB_FOT       : std_logic;
      GRAB_READOUT   : std_logic;
      GRAB_EXPOSURE  : std_logic;
      GRAB_PENDING   : std_logic;
      GRAB_ACTIVE    : std_logic;
      GRAB_IDLE      : std_logic;
   end record ACQ_GRAB_STAT_TYPE;

   constant INIT_ACQ_GRAB_STAT_TYPE : ACQ_GRAB_STAT_TYPE := (
      GRAB_CMD_DONE   => 'Z',
      ABORT_PET       => 'Z',
      ABORT_DELAI     => 'Z',
      ABORT_DONE      => 'Z',
      TRIGGER_RDY     => 'Z',
      ABORT_MNGR_STAT => (others=> 'Z'),
      TRIG_MNGR_STAT  => (others=> 'Z'),
      TIMER_MNGR_STAT => (others=> 'Z'),
      GRAB_MNGR_STAT  => (others=> 'Z'),
      GRAB_FOT        => 'Z',
      GRAB_READOUT    => 'Z',
      GRAB_EXPOSURE   => 'Z',
      GRAB_PENDING    => 'Z',
      GRAB_ACTIVE     => 'Z',
      GRAB_IDLE       => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_GRAB_STAT_TYPE) return std_logic_vector;
   function to_ACQ_GRAB_STAT_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_GRAB_STAT_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: READOUT_CFG1
   ------------------------------------------------------------------------------------------
   type ACQ_READOUT_CFG1_TYPE is record
      FOT_LENGTH_LINE: std_logic_vector(4 downto 0);
      EO_FOT_SEL     : std_logic;
      FOT_LENGTH     : std_logic_vector(15 downto 0);
   end record ACQ_READOUT_CFG1_TYPE;

   constant INIT_ACQ_READOUT_CFG1_TYPE : ACQ_READOUT_CFG1_TYPE := (
      FOT_LENGTH_LINE => (others=> 'Z'),
      EO_FOT_SEL      => 'Z',
      FOT_LENGTH      => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_READOUT_CFG1_TYPE) return std_logic_vector;
   function to_ACQ_READOUT_CFG1_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_READOUT_CFG1_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: READOUT_CFG_FRAME_LINE
   ------------------------------------------------------------------------------------------
   type ACQ_READOUT_CFG_FRAME_LINE_TYPE is record
      DUMMY_LINES    : std_logic_vector(7 downto 0);
      CURR_FRAME_LINES: std_logic_vector(12 downto 0);
   end record ACQ_READOUT_CFG_FRAME_LINE_TYPE;

   constant INIT_ACQ_READOUT_CFG_FRAME_LINE_TYPE : ACQ_READOUT_CFG_FRAME_LINE_TYPE := (
      DUMMY_LINES     => (others=> 'Z'),
      CURR_FRAME_LINES => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_READOUT_CFG_FRAME_LINE_TYPE) return std_logic_vector;
   function to_ACQ_READOUT_CFG_FRAME_LINE_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_READOUT_CFG_FRAME_LINE_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: READOUT_CFG2
   ------------------------------------------------------------------------------------------
   type ACQ_READOUT_CFG2_TYPE is record
      READOUT_LENGTH : std_logic_vector(28 downto 0);
   end record ACQ_READOUT_CFG2_TYPE;

   constant INIT_ACQ_READOUT_CFG2_TYPE : ACQ_READOUT_CFG2_TYPE := (
      READOUT_LENGTH  => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_READOUT_CFG2_TYPE) return std_logic_vector;
   function to_ACQ_READOUT_CFG2_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_READOUT_CFG2_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: READOUT_CFG3
   ------------------------------------------------------------------------------------------
   type ACQ_READOUT_CFG3_TYPE is record
      LINE_TIME      : std_logic_vector(15 downto 0);
   end record ACQ_READOUT_CFG3_TYPE;

   constant INIT_ACQ_READOUT_CFG3_TYPE : ACQ_READOUT_CFG3_TYPE := (
      LINE_TIME       => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_READOUT_CFG3_TYPE) return std_logic_vector;
   function to_ACQ_READOUT_CFG3_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_READOUT_CFG3_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: READOUT_CFG4
   ------------------------------------------------------------------------------------------
   type ACQ_READOUT_CFG4_TYPE is record
      KEEP_OUT_TRIG_ENA: std_logic;
      KEEP_OUT_TRIG_START: std_logic_vector(15 downto 0);
   end record ACQ_READOUT_CFG4_TYPE;

   constant INIT_ACQ_READOUT_CFG4_TYPE : ACQ_READOUT_CFG4_TYPE := (
      KEEP_OUT_TRIG_ENA => 'Z',
      KEEP_OUT_TRIG_START => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_READOUT_CFG4_TYPE) return std_logic_vector;
   function to_ACQ_READOUT_CFG4_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_READOUT_CFG4_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: EXP_CTRL1
   ------------------------------------------------------------------------------------------
   type ACQ_EXP_CTRL1_TYPE is record
      EXPOSURE_LEV_MODE: std_logic;
      EXPOSURE_SS    : std_logic_vector(27 downto 0);
   end record ACQ_EXP_CTRL1_TYPE;

   constant INIT_ACQ_EXP_CTRL1_TYPE : ACQ_EXP_CTRL1_TYPE := (
      EXPOSURE_LEV_MODE => 'Z',
      EXPOSURE_SS     => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_EXP_CTRL1_TYPE) return std_logic_vector;
   function to_ACQ_EXP_CTRL1_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_EXP_CTRL1_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: EXP_CTRL2
   ------------------------------------------------------------------------------------------
   type ACQ_EXP_CTRL2_TYPE is record
      EXPOSURE_DS    : std_logic_vector(27 downto 0);
   end record ACQ_EXP_CTRL2_TYPE;

   constant INIT_ACQ_EXP_CTRL2_TYPE : ACQ_EXP_CTRL2_TYPE := (
      EXPOSURE_DS     => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_EXP_CTRL2_TYPE) return std_logic_vector;
   function to_ACQ_EXP_CTRL2_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_EXP_CTRL2_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: EXP_CTRL3
   ------------------------------------------------------------------------------------------
   type ACQ_EXP_CTRL3_TYPE is record
      EXPOSURE_TS    : std_logic_vector(27 downto 0);
   end record ACQ_EXP_CTRL3_TYPE;

   constant INIT_ACQ_EXP_CTRL3_TYPE : ACQ_EXP_CTRL3_TYPE := (
      EXPOSURE_TS     => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_EXP_CTRL3_TYPE) return std_logic_vector;
   function to_ACQ_EXP_CTRL3_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_EXP_CTRL3_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: TRIGGER_DELAY
   ------------------------------------------------------------------------------------------
   type ACQ_TRIGGER_DELAY_TYPE is record
      TRIGGER_DELAY  : std_logic_vector(27 downto 0);
   end record ACQ_TRIGGER_DELAY_TYPE;

   constant INIT_ACQ_TRIGGER_DELAY_TYPE : ACQ_TRIGGER_DELAY_TYPE := (
      TRIGGER_DELAY   => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_TRIGGER_DELAY_TYPE) return std_logic_vector;
   function to_ACQ_TRIGGER_DELAY_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_TRIGGER_DELAY_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: STROBE_CTRL1
   ------------------------------------------------------------------------------------------
   type ACQ_STROBE_CTRL1_TYPE is record
      STROBE_E       : std_logic;
      STROBE_POL     : std_logic;
      STROBE_START   : std_logic_vector(27 downto 0);
   end record ACQ_STROBE_CTRL1_TYPE;

   constant INIT_ACQ_STROBE_CTRL1_TYPE : ACQ_STROBE_CTRL1_TYPE := (
      STROBE_E        => 'Z',
      STROBE_POL      => 'Z',
      STROBE_START    => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_STROBE_CTRL1_TYPE) return std_logic_vector;
   function to_ACQ_STROBE_CTRL1_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_STROBE_CTRL1_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: STROBE_CTRL2
   ------------------------------------------------------------------------------------------
   type ACQ_STROBE_CTRL2_TYPE is record
      STROBE_MODE    : std_logic;
      STROBE_B_EN    : std_logic;
      STROBE_A_EN    : std_logic;
      STROBE_END     : std_logic_vector(27 downto 0);
   end record ACQ_STROBE_CTRL2_TYPE;

   constant INIT_ACQ_STROBE_CTRL2_TYPE : ACQ_STROBE_CTRL2_TYPE := (
      STROBE_MODE     => 'Z',
      STROBE_B_EN     => 'Z',
      STROBE_A_EN     => 'Z',
      STROBE_END      => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_STROBE_CTRL2_TYPE) return std_logic_vector;
   function to_ACQ_STROBE_CTRL2_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_STROBE_CTRL2_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: ACQ_SER_CTRL
   ------------------------------------------------------------------------------------------
   type ACQ_ACQ_SER_CTRL_TYPE is record
      SER_RWn        : std_logic;
      SER_CMD        : std_logic_vector(1 downto 0);
      SER_RF_SS      : std_logic;
      SER_WF_SS      : std_logic;
   end record ACQ_ACQ_SER_CTRL_TYPE;

   constant INIT_ACQ_ACQ_SER_CTRL_TYPE : ACQ_ACQ_SER_CTRL_TYPE := (
      SER_RWn         => 'Z',
      SER_CMD         => (others=> 'Z'),
      SER_RF_SS       => 'Z',
      SER_WF_SS       => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_ACQ_SER_CTRL_TYPE) return std_logic_vector;
   function to_ACQ_ACQ_SER_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_ACQ_SER_CTRL_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: ACQ_SER_ADDATA
   ------------------------------------------------------------------------------------------
   type ACQ_ACQ_SER_ADDATA_TYPE is record
      SER_DAT        : std_logic_vector(15 downto 0);
      SER_ADD        : std_logic_vector(14 downto 0);
   end record ACQ_ACQ_SER_ADDATA_TYPE;

   constant INIT_ACQ_ACQ_SER_ADDATA_TYPE : ACQ_ACQ_SER_ADDATA_TYPE := (
      SER_DAT         => (others=> 'Z'),
      SER_ADD         => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_ACQ_SER_ADDATA_TYPE) return std_logic_vector;
   function to_ACQ_ACQ_SER_ADDATA_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_ACQ_SER_ADDATA_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: ACQ_SER_STAT
   ------------------------------------------------------------------------------------------
   type ACQ_ACQ_SER_STAT_TYPE is record
      SER_FIFO_EMPTY : std_logic;
      SER_BUSY       : std_logic;
      SER_DAT_R      : std_logic_vector(15 downto 0);
   end record ACQ_ACQ_SER_STAT_TYPE;

   constant INIT_ACQ_ACQ_SER_STAT_TYPE : ACQ_ACQ_SER_STAT_TYPE := (
      SER_FIFO_EMPTY  => 'Z',
      SER_BUSY        => 'Z',
      SER_DAT_R       => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_ACQ_SER_STAT_TYPE) return std_logic_vector;
   function to_ACQ_ACQ_SER_STAT_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_ACQ_SER_STAT_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: SENSOR_CTRL
   ------------------------------------------------------------------------------------------
   type ACQ_SENSOR_CTRL_TYPE is record
      SENSOR_REFRESH_TEMP: std_logic;
      SENSOR_POWERDOWN: std_logic;
      SENSOR_COLOR   : std_logic;
      SENSOR_REG_UPDATE: std_logic;
      SENSOR_RESETN  : std_logic;
      SENSOR_POWERUP : std_logic;
   end record ACQ_SENSOR_CTRL_TYPE;

   constant INIT_ACQ_SENSOR_CTRL_TYPE : ACQ_SENSOR_CTRL_TYPE := (
      SENSOR_REFRESH_TEMP => 'Z',
      SENSOR_POWERDOWN => 'Z',
      SENSOR_COLOR    => 'Z',
      SENSOR_REG_UPDATE => 'Z',
      SENSOR_RESETN   => 'Z',
      SENSOR_POWERUP  => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_SENSOR_CTRL_TYPE) return std_logic_vector;
   function to_ACQ_SENSOR_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_CTRL_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: SENSOR_STAT
   ------------------------------------------------------------------------------------------
   type ACQ_SENSOR_STAT_TYPE is record
      SENSOR_TEMP    : std_logic_vector(7 downto 0);
      SENSOR_TEMP_VALID: std_logic;
      SENSOR_POWERDOWN: std_logic;
      SENSOR_RESETN  : std_logic;
      SENSOR_OSC_EN  : std_logic;
      SENSOR_VCC_PG  : std_logic;
      SENSOR_POWERUP_STAT: std_logic;
      SENSOR_POWERUP_DONE: std_logic;
   end record ACQ_SENSOR_STAT_TYPE;

   constant INIT_ACQ_SENSOR_STAT_TYPE : ACQ_SENSOR_STAT_TYPE := (
      SENSOR_TEMP     => (others=> 'Z'),
      SENSOR_TEMP_VALID => 'Z',
      SENSOR_POWERDOWN => 'Z',
      SENSOR_RESETN   => 'Z',
      SENSOR_OSC_EN   => 'Z',
      SENSOR_VCC_PG   => 'Z',
      SENSOR_POWERUP_STAT => 'Z',
      SENSOR_POWERUP_DONE => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_SENSOR_STAT_TYPE) return std_logic_vector;
   function to_ACQ_SENSOR_STAT_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_STAT_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: SENSOR_SUBSAMPLING
   ------------------------------------------------------------------------------------------
   type ACQ_SENSOR_SUBSAMPLING_TYPE is record
      reserved1      : std_logic_vector(11 downto 0);
      ACTIVE_SUBSAMPLING_Y: std_logic;
      reserved0      : std_logic;
      M_SUBSAMPLING_Y: std_logic;
      SUBSAMPLING_X  : std_logic;
   end record ACQ_SENSOR_SUBSAMPLING_TYPE;

   constant INIT_ACQ_SENSOR_SUBSAMPLING_TYPE : ACQ_SENSOR_SUBSAMPLING_TYPE := (
      reserved1       => (others=> 'Z'),
      ACTIVE_SUBSAMPLING_Y => 'Z',
      reserved0       => 'Z',
      M_SUBSAMPLING_Y => 'Z',
      SUBSAMPLING_X   => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_SENSOR_SUBSAMPLING_TYPE) return std_logic_vector;
   function to_ACQ_SENSOR_SUBSAMPLING_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_SUBSAMPLING_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: SENSOR_GAIN_ANA
   ------------------------------------------------------------------------------------------
   type ACQ_SENSOR_GAIN_ANA_TYPE is record
      reserved1      : std_logic_vector(4 downto 0);
      ANALOG_GAIN    : std_logic_vector(2 downto 0);
      reserved0      : std_logic_vector(7 downto 0);
   end record ACQ_SENSOR_GAIN_ANA_TYPE;

   constant INIT_ACQ_SENSOR_GAIN_ANA_TYPE : ACQ_SENSOR_GAIN_ANA_TYPE := (
      reserved1       => (others=> 'Z'),
      ANALOG_GAIN     => (others=> 'Z'),
      reserved0       => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_SENSOR_GAIN_ANA_TYPE) return std_logic_vector;
   function to_ACQ_SENSOR_GAIN_ANA_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_GAIN_ANA_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: SENSOR_ROI_Y_START
   ------------------------------------------------------------------------------------------
   type ACQ_SENSOR_ROI_Y_START_TYPE is record
      reserved       : std_logic_vector(5 downto 0);
      Y_START        : std_logic_vector(9 downto 0);
   end record ACQ_SENSOR_ROI_Y_START_TYPE;

   constant INIT_ACQ_SENSOR_ROI_Y_START_TYPE : ACQ_SENSOR_ROI_Y_START_TYPE := (
      reserved        => (others=> 'Z'),
      Y_START         => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_SENSOR_ROI_Y_START_TYPE) return std_logic_vector;
   function to_ACQ_SENSOR_ROI_Y_START_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_ROI_Y_START_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: SENSOR_ROI_Y_SIZE
   ------------------------------------------------------------------------------------------
   type ACQ_SENSOR_ROI_Y_SIZE_TYPE is record
      reserved       : std_logic_vector(5 downto 0);
      Y_SIZE         : std_logic_vector(9 downto 0);
   end record ACQ_SENSOR_ROI_Y_SIZE_TYPE;

   constant INIT_ACQ_SENSOR_ROI_Y_SIZE_TYPE : ACQ_SENSOR_ROI_Y_SIZE_TYPE := (
      reserved        => (others=> 'Z'),
      Y_SIZE          => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_SENSOR_ROI_Y_SIZE_TYPE) return std_logic_vector;
   function to_ACQ_SENSOR_ROI_Y_SIZE_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_ROI_Y_SIZE_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: SENSOR_M_LINES
   ------------------------------------------------------------------------------------------
   type ACQ_SENSOR_M_LINES_TYPE is record
      M_LINES_DISPLAY: std_logic;
      M_SUPPRESSED   : std_logic_vector(4 downto 0);
      M_LINES_SENSOR : std_logic_vector(9 downto 0);
   end record ACQ_SENSOR_M_LINES_TYPE;

   constant INIT_ACQ_SENSOR_M_LINES_TYPE : ACQ_SENSOR_M_LINES_TYPE := (
      M_LINES_DISPLAY => 'Z',
      M_SUPPRESSED    => (others=> 'Z'),
      M_LINES_SENSOR  => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_SENSOR_M_LINES_TYPE) return std_logic_vector;
   function to_ACQ_SENSOR_M_LINES_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_M_LINES_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: SENSOR_DP_GR
   ------------------------------------------------------------------------------------------
   type ACQ_SENSOR_DP_GR_TYPE is record
      reserved       : std_logic_vector(3 downto 0);
      DP_OFFSET_GR   : std_logic_vector(11 downto 0);
   end record ACQ_SENSOR_DP_GR_TYPE;

   constant INIT_ACQ_SENSOR_DP_GR_TYPE : ACQ_SENSOR_DP_GR_TYPE := (
      reserved        => (others=> 'Z'),
      DP_OFFSET_GR    => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_SENSOR_DP_GR_TYPE) return std_logic_vector;
   function to_ACQ_SENSOR_DP_GR_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_DP_GR_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: SENSOR_DP_GB
   ------------------------------------------------------------------------------------------
   type ACQ_SENSOR_DP_GB_TYPE is record
      reserved       : std_logic_vector(3 downto 0);
      DP_OFFSET_GB   : std_logic_vector(11 downto 0);
   end record ACQ_SENSOR_DP_GB_TYPE;

   constant INIT_ACQ_SENSOR_DP_GB_TYPE : ACQ_SENSOR_DP_GB_TYPE := (
      reserved        => (others=> 'Z'),
      DP_OFFSET_GB    => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_SENSOR_DP_GB_TYPE) return std_logic_vector;
   function to_ACQ_SENSOR_DP_GB_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_DP_GB_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: SENSOR_DP_R
   ------------------------------------------------------------------------------------------
   type ACQ_SENSOR_DP_R_TYPE is record
      reserved       : std_logic_vector(3 downto 0);
      DP_OFFSET_R    : std_logic_vector(11 downto 0);
   end record ACQ_SENSOR_DP_R_TYPE;

   constant INIT_ACQ_SENSOR_DP_R_TYPE : ACQ_SENSOR_DP_R_TYPE := (
      reserved        => (others=> 'Z'),
      DP_OFFSET_R     => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_SENSOR_DP_R_TYPE) return std_logic_vector;
   function to_ACQ_SENSOR_DP_R_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_DP_R_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: SENSOR_DP_B
   ------------------------------------------------------------------------------------------
   type ACQ_SENSOR_DP_B_TYPE is record
      reserved       : std_logic_vector(3 downto 0);
      DP_OFFSET_B    : std_logic_vector(11 downto 0);
   end record ACQ_SENSOR_DP_B_TYPE;

   constant INIT_ACQ_SENSOR_DP_B_TYPE : ACQ_SENSOR_DP_B_TYPE := (
      reserved        => (others=> 'Z'),
      DP_OFFSET_B     => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_SENSOR_DP_B_TYPE) return std_logic_vector;
   function to_ACQ_SENSOR_DP_B_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_DP_B_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: SENSOR_GAIN_DIG_G
   ------------------------------------------------------------------------------------------
   type ACQ_SENSOR_GAIN_DIG_G_TYPE is record
      reserved1      : std_logic;
      DG_FACTOR_GR   : std_logic_vector(6 downto 0);
      reserved0      : std_logic;
      DG_FACTOR_GB   : std_logic_vector(6 downto 0);
   end record ACQ_SENSOR_GAIN_DIG_G_TYPE;

   constant INIT_ACQ_SENSOR_GAIN_DIG_G_TYPE : ACQ_SENSOR_GAIN_DIG_G_TYPE := (
      reserved1       => 'Z',
      DG_FACTOR_GR    => (others=> 'Z'),
      reserved0       => 'Z',
      DG_FACTOR_GB    => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_SENSOR_GAIN_DIG_G_TYPE) return std_logic_vector;
   function to_ACQ_SENSOR_GAIN_DIG_G_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_GAIN_DIG_G_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: SENSOR_GAIN_DIG_RB
   ------------------------------------------------------------------------------------------
   type ACQ_SENSOR_GAIN_DIG_RB_TYPE is record
      reserved1      : std_logic;
      DG_FACTOR_R    : std_logic_vector(6 downto 0);
      reserved0      : std_logic;
      DG_FACTOR_B    : std_logic_vector(6 downto 0);
   end record ACQ_SENSOR_GAIN_DIG_RB_TYPE;

   constant INIT_ACQ_SENSOR_GAIN_DIG_RB_TYPE : ACQ_SENSOR_GAIN_DIG_RB_TYPE := (
      reserved1       => 'Z',
      DG_FACTOR_R     => (others=> 'Z'),
      reserved0       => 'Z',
      DG_FACTOR_B     => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_SENSOR_GAIN_DIG_RB_TYPE) return std_logic_vector;
   function to_ACQ_SENSOR_GAIN_DIG_RB_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_GAIN_DIG_RB_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: DEBUG_PINS
   ------------------------------------------------------------------------------------------
   type ACQ_DEBUG_PINS_TYPE is record
      Debug3_sel     : std_logic_vector(4 downto 0);
      Debug2_sel     : std_logic_vector(4 downto 0);
      Debug1_sel     : std_logic_vector(4 downto 0);
      Debug0_sel     : std_logic_vector(4 downto 0);
   end record ACQ_DEBUG_PINS_TYPE;

   constant INIT_ACQ_DEBUG_PINS_TYPE : ACQ_DEBUG_PINS_TYPE := (
      Debug3_sel      => (others=> 'Z'),
      Debug2_sel      => (others=> 'Z'),
      Debug1_sel      => (others=> 'Z'),
      Debug0_sel      => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_DEBUG_PINS_TYPE) return std_logic_vector;
   function to_ACQ_DEBUG_PINS_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_DEBUG_PINS_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: TRIGGER_MISSED
   ------------------------------------------------------------------------------------------
   type ACQ_TRIGGER_MISSED_TYPE is record
      TRIGGER_MISSED_RST: std_logic;
      TRIGGER_MISSED_CNTR: std_logic_vector(15 downto 0);
   end record ACQ_TRIGGER_MISSED_TYPE;

   constant INIT_ACQ_TRIGGER_MISSED_TYPE : ACQ_TRIGGER_MISSED_TYPE := (
      TRIGGER_MISSED_RST => 'Z',
      TRIGGER_MISSED_CNTR => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_TRIGGER_MISSED_TYPE) return std_logic_vector;
   function to_ACQ_TRIGGER_MISSED_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_TRIGGER_MISSED_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: SENSOR_FPS
   ------------------------------------------------------------------------------------------
   type ACQ_SENSOR_FPS_TYPE is record
      SENSOR_FPS     : std_logic_vector(15 downto 0);
   end record ACQ_SENSOR_FPS_TYPE;

   constant INIT_ACQ_SENSOR_FPS_TYPE : ACQ_SENSOR_FPS_TYPE := (
      SENSOR_FPS      => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_SENSOR_FPS_TYPE) return std_logic_vector;
   function to_ACQ_SENSOR_FPS_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_FPS_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: SENSOR_FPS2
   ------------------------------------------------------------------------------------------
   type ACQ_SENSOR_FPS2_TYPE is record
      SENSOR_FPS     : std_logic_vector(19 downto 0);
   end record ACQ_SENSOR_FPS2_TYPE;

   constant INIT_ACQ_SENSOR_FPS2_TYPE : ACQ_SENSOR_FPS2_TYPE := (
      SENSOR_FPS      => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_SENSOR_FPS2_TYPE) return std_logic_vector;
   function to_ACQ_SENSOR_FPS2_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_FPS2_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: DEBUG
   ------------------------------------------------------------------------------------------
   type ACQ_DEBUG_TYPE is record
      DEBUG_RST_CNTR : std_logic;
      LED_TEST_COLOR : std_logic_vector(1 downto 0);
      LED_TEST       : std_logic;
   end record ACQ_DEBUG_TYPE;

   constant INIT_ACQ_DEBUG_TYPE : ACQ_DEBUG_TYPE := (
      DEBUG_RST_CNTR  => 'Z',
      LED_TEST_COLOR  => (others=> 'Z'),
      LED_TEST        => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_DEBUG_TYPE) return std_logic_vector;
   function to_ACQ_DEBUG_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_DEBUG_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: DEBUG_CNTR1
   ------------------------------------------------------------------------------------------
   type ACQ_DEBUG_CNTR1_TYPE is record
      SENSOR_FRAME_DURATION: std_logic_vector(27 downto 0);
   end record ACQ_DEBUG_CNTR1_TYPE;

   constant INIT_ACQ_DEBUG_CNTR1_TYPE : ACQ_DEBUG_CNTR1_TYPE := (
      SENSOR_FRAME_DURATION => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_DEBUG_CNTR1_TYPE) return std_logic_vector;
   function to_ACQ_DEBUG_CNTR1_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_DEBUG_CNTR1_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: DEBUG_CNTR2
   ------------------------------------------------------------------------------------------
   type ACQ_DEBUG_CNTR2_TYPE is record
      EOF_CNTR       : std_logic_vector(31 downto 0);
   end record ACQ_DEBUG_CNTR2_TYPE;

   constant INIT_ACQ_DEBUG_CNTR2_TYPE : ACQ_DEBUG_CNTR2_TYPE := (
      EOF_CNTR        => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_DEBUG_CNTR2_TYPE) return std_logic_vector;
   function to_ACQ_DEBUG_CNTR2_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_DEBUG_CNTR2_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: DEBUG_CNTR3
   ------------------------------------------------------------------------------------------
   type ACQ_DEBUG_CNTR3_TYPE is record
      TRIG_INT_CNTR  : std_logic_vector(31 downto 0);
   end record ACQ_DEBUG_CNTR3_TYPE;

   constant INIT_ACQ_DEBUG_CNTR3_TYPE : ACQ_DEBUG_CNTR3_TYPE := (
      TRIG_INT_CNTR   => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_DEBUG_CNTR3_TYPE) return std_logic_vector;
   function to_ACQ_DEBUG_CNTR3_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_DEBUG_CNTR3_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: EXP_FOT
   ------------------------------------------------------------------------------------------
   type ACQ_EXP_FOT_TYPE is record
      EXP_FOT        : std_logic;
      EXP_FOT_TIME   : std_logic_vector(15 downto 0);
   end record ACQ_EXP_FOT_TYPE;

   constant INIT_ACQ_EXP_FOT_TYPE : ACQ_EXP_FOT_TYPE := (
      EXP_FOT         => 'Z',
      EXP_FOT_TIME    => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_EXP_FOT_TYPE) return std_logic_vector;
   function to_ACQ_EXP_FOT_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_EXP_FOT_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: ACQ_SFNC
   ------------------------------------------------------------------------------------------
   type ACQ_ACQ_SFNC_TYPE is record
      RELOAD_GRAB_PARAMS: std_logic;
   end record ACQ_ACQ_SFNC_TYPE;

   constant INIT_ACQ_ACQ_SFNC_TYPE : ACQ_ACQ_SFNC_TYPE := (
      RELOAD_GRAB_PARAMS => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_ACQ_SFNC_TYPE) return std_logic_vector;
   function to_ACQ_ACQ_SFNC_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_ACQ_SFNC_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: TIMER_CTRL
   ------------------------------------------------------------------------------------------
   type ACQ_TIMER_CTRL_TYPE is record
      ADAPTATIVE     : std_logic;
      TIMERSTOP      : std_logic;
      TIMERSTART     : std_logic;
   end record ACQ_TIMER_CTRL_TYPE;

   constant INIT_ACQ_TIMER_CTRL_TYPE : ACQ_TIMER_CTRL_TYPE := (
      ADAPTATIVE      => 'Z',
      TIMERSTOP       => 'Z',
      TIMERSTART      => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_TIMER_CTRL_TYPE) return std_logic_vector;
   function to_ACQ_TIMER_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_TIMER_CTRL_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: TIMER_DELAY
   ------------------------------------------------------------------------------------------
   type ACQ_TIMER_DELAY_TYPE is record
      VALUE          : std_logic_vector(31 downto 0);
   end record ACQ_TIMER_DELAY_TYPE;

   constant INIT_ACQ_TIMER_DELAY_TYPE : ACQ_TIMER_DELAY_TYPE := (
      VALUE           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_TIMER_DELAY_TYPE) return std_logic_vector;
   function to_ACQ_TIMER_DELAY_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_TIMER_DELAY_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: TIMER_DURATION
   ------------------------------------------------------------------------------------------
   type ACQ_TIMER_DURATION_TYPE is record
      VALUE          : std_logic_vector(31 downto 0);
   end record ACQ_TIMER_DURATION_TYPE;

   constant INIT_ACQ_TIMER_DURATION_TYPE : ACQ_TIMER_DURATION_TYPE := (
      VALUE           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_TIMER_DURATION_TYPE) return std_logic_vector;
   function to_ACQ_TIMER_DURATION_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_TIMER_DURATION_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: CTRL
   ------------------------------------------------------------------------------------------
   type HISPI_CTRL_TYPE is record
      SW_CLR_IDELAYCTRL: std_logic;
      SW_CLR_HISPI   : std_logic;
      SW_CALIB_SERDES: std_logic;
      ENABLE_DATA_PATH: std_logic;
      ENABLE_HISPI   : std_logic;
   end record HISPI_CTRL_TYPE;

   constant INIT_HISPI_CTRL_TYPE : HISPI_CTRL_TYPE := (
      SW_CLR_IDELAYCTRL => 'Z',
      SW_CLR_HISPI    => 'Z',
      SW_CALIB_SERDES => 'Z',
      ENABLE_DATA_PATH => 'Z',
      ENABLE_HISPI    => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : HISPI_CTRL_TYPE) return std_logic_vector;
   function to_HISPI_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return HISPI_CTRL_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: STATUS
   ------------------------------------------------------------------------------------------
   type HISPI_STATUS_TYPE is record
      FSM            : std_logic_vector(3 downto 0);
      CRC_ERROR      : std_logic;
      PHY_BIT_LOCKED_ERROR: std_logic;
      FIFO_ERROR     : std_logic;
      CALIBRATION_ERROR: std_logic;
      CALIBRATION_DONE: std_logic;
   end record HISPI_STATUS_TYPE;

   constant INIT_HISPI_STATUS_TYPE : HISPI_STATUS_TYPE := (
      FSM             => (others=> 'Z'),
      CRC_ERROR       => 'Z',
      PHY_BIT_LOCKED_ERROR => 'Z',
      FIFO_ERROR      => 'Z',
      CALIBRATION_ERROR => 'Z',
      CALIBRATION_DONE => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : HISPI_STATUS_TYPE) return std_logic_vector;
   function to_HISPI_STATUS_TYPE(stdlv : std_logic_vector(31 downto 0)) return HISPI_STATUS_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: IDELAYCTRL_STATUS
   ------------------------------------------------------------------------------------------
   type HISPI_IDELAYCTRL_STATUS_TYPE is record
      PLL_LOCKED     : std_logic;
   end record HISPI_IDELAYCTRL_STATUS_TYPE;

   constant INIT_HISPI_IDELAYCTRL_STATUS_TYPE : HISPI_IDELAYCTRL_STATUS_TYPE := (
      PLL_LOCKED      => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : HISPI_IDELAYCTRL_STATUS_TYPE) return std_logic_vector;
   function to_HISPI_IDELAYCTRL_STATUS_TYPE(stdlv : std_logic_vector(31 downto 0)) return HISPI_IDELAYCTRL_STATUS_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: IDLE_CHARACTER
   ------------------------------------------------------------------------------------------
   type HISPI_IDLE_CHARACTER_TYPE is record
      VALUE          : std_logic_vector(11 downto 0);
   end record HISPI_IDLE_CHARACTER_TYPE;

   constant INIT_HISPI_IDLE_CHARACTER_TYPE : HISPI_IDLE_CHARACTER_TYPE := (
      VALUE           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : HISPI_IDLE_CHARACTER_TYPE) return std_logic_vector;
   function to_HISPI_IDLE_CHARACTER_TYPE(stdlv : std_logic_vector(31 downto 0)) return HISPI_IDLE_CHARACTER_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: PHY
   ------------------------------------------------------------------------------------------
   type HISPI_PHY_TYPE is record
      PIXEL_PER_LANE : std_logic_vector(9 downto 0);
      MUX_RATIO      : std_logic_vector(2 downto 0);
      NB_LANES       : std_logic_vector(2 downto 0);
   end record HISPI_PHY_TYPE;

   constant INIT_HISPI_PHY_TYPE : HISPI_PHY_TYPE := (
      PIXEL_PER_LANE  => (others=> 'Z'),
      MUX_RATIO       => (others=> 'Z'),
      NB_LANES        => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : HISPI_PHY_TYPE) return std_logic_vector;
   function to_HISPI_PHY_TYPE(stdlv : std_logic_vector(31 downto 0)) return HISPI_PHY_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: FRAME_CFG
   ------------------------------------------------------------------------------------------
   type HISPI_FRAME_CFG_TYPE is record
      LINES_PER_FRAME: std_logic_vector(11 downto 0);
      PIXELS_PER_LINE: std_logic_vector(12 downto 0);
   end record HISPI_FRAME_CFG_TYPE;

   constant INIT_HISPI_FRAME_CFG_TYPE : HISPI_FRAME_CFG_TYPE := (
      LINES_PER_FRAME => (others=> 'Z'),
      PIXELS_PER_LINE => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : HISPI_FRAME_CFG_TYPE) return std_logic_vector;
   function to_HISPI_FRAME_CFG_TYPE(stdlv : std_logic_vector(31 downto 0)) return HISPI_FRAME_CFG_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: FRAME_CFG_X_VALID
   ------------------------------------------------------------------------------------------
   type HISPI_FRAME_CFG_X_VALID_TYPE is record
      X_END          : std_logic_vector(12 downto 0);
      X_START        : std_logic_vector(12 downto 0);
   end record HISPI_FRAME_CFG_X_VALID_TYPE;

   constant INIT_HISPI_FRAME_CFG_X_VALID_TYPE : HISPI_FRAME_CFG_X_VALID_TYPE := (
      X_END           => (others=> 'Z'),
      X_START         => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : HISPI_FRAME_CFG_X_VALID_TYPE) return std_logic_vector;
   function to_HISPI_FRAME_CFG_X_VALID_TYPE(stdlv : std_logic_vector(31 downto 0)) return HISPI_FRAME_CFG_X_VALID_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: LANE_DECODER_STATUS
   ------------------------------------------------------------------------------------------
   type HISPI_LANE_DECODER_STATUS_TYPE is record
      CRC_ERROR      : std_logic;
      CRC_ERROR_set  : std_logic;
      PHY_SYNC_ERROR : std_logic;
      PHY_SYNC_ERROR_set: std_logic;
      PHY_BIT_LOCKED_ERROR: std_logic;
      PHY_BIT_LOCKED_ERROR_set: std_logic;
      PHY_BIT_LOCKED : std_logic;
      CALIBRATION_TAP_VALUE: std_logic_vector(4 downto 0);
      CALIBRATION_ERROR: std_logic;
      CALIBRATION_ERROR_set: std_logic;
      CALIBRATION_DONE: std_logic;
      FIFO_UNDERRUN  : std_logic;
      FIFO_UNDERRUN_set: std_logic;
      FIFO_OVERRUN   : std_logic;
      FIFO_OVERRUN_set: std_logic;
   end record HISPI_LANE_DECODER_STATUS_TYPE;

   constant INIT_HISPI_LANE_DECODER_STATUS_TYPE : HISPI_LANE_DECODER_STATUS_TYPE := (
      CRC_ERROR       => 'Z',
      CRC_ERROR_set   => 'Z',
      PHY_SYNC_ERROR  => 'Z',
      PHY_SYNC_ERROR_set => 'Z',
      PHY_BIT_LOCKED_ERROR => 'Z',
      PHY_BIT_LOCKED_ERROR_set => 'Z',
      PHY_BIT_LOCKED  => 'Z',
      CALIBRATION_TAP_VALUE => (others=> 'Z'),
      CALIBRATION_ERROR => 'Z',
      CALIBRATION_ERROR_set => 'Z',
      CALIBRATION_DONE => 'Z',
      FIFO_UNDERRUN   => 'Z',
      FIFO_UNDERRUN_set => 'Z',
      FIFO_OVERRUN    => 'Z',
      FIFO_OVERRUN_set => 'Z'
   );

   ------------------------------------------------------------------------------------------
   -- Array type: HISPI_LANE_DECODER_STATUS_TYPE
   ------------------------------------------------------------------------------------------
   type HISPI_LANE_DECODER_STATUS_TYPE_ARRAY is array (5 downto 0) of HISPI_LANE_DECODER_STATUS_TYPE;
   constant INIT_HISPI_LANE_DECODER_STATUS_TYPE_ARRAY : HISPI_LANE_DECODER_STATUS_TYPE_ARRAY := (others => INIT_HISPI_LANE_DECODER_STATUS_TYPE);
   -- Casting functions:
   function to_std_logic_vector(reg : HISPI_LANE_DECODER_STATUS_TYPE) return std_logic_vector;
   function to_HISPI_LANE_DECODER_STATUS_TYPE(stdlv : std_logic_vector(31 downto 0)) return HISPI_LANE_DECODER_STATUS_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: TAP_HISTOGRAM
   ------------------------------------------------------------------------------------------
   type HISPI_TAP_HISTOGRAM_TYPE is record
      VALUE          : std_logic_vector(31 downto 0);
   end record HISPI_TAP_HISTOGRAM_TYPE;

   constant INIT_HISPI_TAP_HISTOGRAM_TYPE : HISPI_TAP_HISTOGRAM_TYPE := (
      VALUE           => (others=> 'Z')
   );

   ------------------------------------------------------------------------------------------
   -- Array type: HISPI_TAP_HISTOGRAM_TYPE
   ------------------------------------------------------------------------------------------
   type HISPI_TAP_HISTOGRAM_TYPE_ARRAY is array (5 downto 0) of HISPI_TAP_HISTOGRAM_TYPE;
   constant INIT_HISPI_TAP_HISTOGRAM_TYPE_ARRAY : HISPI_TAP_HISTOGRAM_TYPE_ARRAY := (others => INIT_HISPI_TAP_HISTOGRAM_TYPE);
   -- Casting functions:
   function to_std_logic_vector(reg : HISPI_TAP_HISTOGRAM_TYPE) return std_logic_vector;
   function to_HISPI_TAP_HISTOGRAM_TYPE(stdlv : std_logic_vector(31 downto 0)) return HISPI_TAP_HISTOGRAM_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: DEBUG
   ------------------------------------------------------------------------------------------
   type HISPI_DEBUG_TYPE is record
      MANUAL_CALIB_EN: std_logic;
      LOAD_TAPS      : std_logic;
      TAP_LANE_5     : std_logic_vector(4 downto 0);
      TAP_LANE_4     : std_logic_vector(4 downto 0);
      TAP_LANE_3     : std_logic_vector(4 downto 0);
      TAP_LANE_2     : std_logic_vector(4 downto 0);
      TAP_LANE_1     : std_logic_vector(4 downto 0);
      TAP_LANE_0     : std_logic_vector(4 downto 0);
   end record HISPI_DEBUG_TYPE;

   constant INIT_HISPI_DEBUG_TYPE : HISPI_DEBUG_TYPE := (
      MANUAL_CALIB_EN => 'Z',
      LOAD_TAPS       => 'Z',
      TAP_LANE_5      => (others=> 'Z'),
      TAP_LANE_4      => (others=> 'Z'),
      TAP_LANE_3      => (others=> 'Z'),
      TAP_LANE_2      => (others=> 'Z'),
      TAP_LANE_1      => (others=> 'Z'),
      TAP_LANE_0      => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : HISPI_DEBUG_TYPE) return std_logic_vector;
   function to_HISPI_DEBUG_TYPE(stdlv : std_logic_vector(31 downto 0)) return HISPI_DEBUG_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: DPC_CAPABILITIES
   ------------------------------------------------------------------------------------------
   type DPC_DPC_CAPABILITIES_TYPE is record
      DPC_LIST_LENGTH: std_logic_vector(11 downto 0);
      DPC_VER        : std_logic_vector(3 downto 0);
   end record DPC_DPC_CAPABILITIES_TYPE;

   constant INIT_DPC_DPC_CAPABILITIES_TYPE : DPC_DPC_CAPABILITIES_TYPE := (
      DPC_LIST_LENGTH => (others=> 'Z'),
      DPC_VER         => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DPC_DPC_CAPABILITIES_TYPE) return std_logic_vector;
   function to_DPC_DPC_CAPABILITIES_TYPE(stdlv : std_logic_vector(31 downto 0)) return DPC_DPC_CAPABILITIES_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: DPC_LIST_CTRL
   ------------------------------------------------------------------------------------------
   type DPC_DPC_LIST_CTRL_TYPE is record
      dpc_highlight_all: std_logic;
      dpc_fifo_reset : std_logic;
      dpc_firstlast_line_rem: std_logic;
      dpc_list_count : std_logic_vector(11 downto 0);
      dpc_pattern0_cfg: std_logic;
      dpc_enable     : std_logic;
      dpc_list_WRn   : std_logic;
      dpc_list_ss    : std_logic;
      dpc_list_add   : std_logic_vector(11 downto 0);
   end record DPC_DPC_LIST_CTRL_TYPE;

   constant INIT_DPC_DPC_LIST_CTRL_TYPE : DPC_DPC_LIST_CTRL_TYPE := (
      dpc_highlight_all => 'Z',
      dpc_fifo_reset  => 'Z',
      dpc_firstlast_line_rem => 'Z',
      dpc_list_count  => (others=> 'Z'),
      dpc_pattern0_cfg => 'Z',
      dpc_enable      => 'Z',
      dpc_list_WRn    => 'Z',
      dpc_list_ss     => 'Z',
      dpc_list_add    => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DPC_DPC_LIST_CTRL_TYPE) return std_logic_vector;
   function to_DPC_DPC_LIST_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return DPC_DPC_LIST_CTRL_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: DPC_LIST_STAT
   ------------------------------------------------------------------------------------------
   type DPC_DPC_LIST_STAT_TYPE is record
      dpc_fifo_underrun: std_logic;
      dpc_fifo_overrun: std_logic;
   end record DPC_DPC_LIST_STAT_TYPE;

   constant INIT_DPC_DPC_LIST_STAT_TYPE : DPC_DPC_LIST_STAT_TYPE := (
      dpc_fifo_underrun => 'Z',
      dpc_fifo_overrun => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DPC_DPC_LIST_STAT_TYPE) return std_logic_vector;
   function to_DPC_DPC_LIST_STAT_TYPE(stdlv : std_logic_vector(31 downto 0)) return DPC_DPC_LIST_STAT_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: DPC_LIST_DATA1
   ------------------------------------------------------------------------------------------
   type DPC_DPC_LIST_DATA1_TYPE is record
      dpc_list_corr_y: std_logic_vector(11 downto 0);
      dpc_list_corr_x: std_logic_vector(12 downto 0);
   end record DPC_DPC_LIST_DATA1_TYPE;

   constant INIT_DPC_DPC_LIST_DATA1_TYPE : DPC_DPC_LIST_DATA1_TYPE := (
      dpc_list_corr_y => (others=> 'Z'),
      dpc_list_corr_x => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DPC_DPC_LIST_DATA1_TYPE) return std_logic_vector;
   function to_DPC_DPC_LIST_DATA1_TYPE(stdlv : std_logic_vector(31 downto 0)) return DPC_DPC_LIST_DATA1_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: DPC_LIST_DATA2
   ------------------------------------------------------------------------------------------
   type DPC_DPC_LIST_DATA2_TYPE is record
      dpc_list_corr_pattern: std_logic_vector(7 downto 0);
   end record DPC_DPC_LIST_DATA2_TYPE;

   constant INIT_DPC_DPC_LIST_DATA2_TYPE : DPC_DPC_LIST_DATA2_TYPE := (
      dpc_list_corr_pattern => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DPC_DPC_LIST_DATA2_TYPE) return std_logic_vector;
   function to_DPC_DPC_LIST_DATA2_TYPE(stdlv : std_logic_vector(31 downto 0)) return DPC_DPC_LIST_DATA2_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: DPC_LIST_DATA1_RD
   ------------------------------------------------------------------------------------------
   type DPC_DPC_LIST_DATA1_RD_TYPE is record
      dpc_list_corr_y: std_logic_vector(11 downto 0);
      dpc_list_corr_x: std_logic_vector(12 downto 0);
   end record DPC_DPC_LIST_DATA1_RD_TYPE;

   constant INIT_DPC_DPC_LIST_DATA1_RD_TYPE : DPC_DPC_LIST_DATA1_RD_TYPE := (
      dpc_list_corr_y => (others=> 'Z'),
      dpc_list_corr_x => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DPC_DPC_LIST_DATA1_RD_TYPE) return std_logic_vector;
   function to_DPC_DPC_LIST_DATA1_RD_TYPE(stdlv : std_logic_vector(31 downto 0)) return DPC_DPC_LIST_DATA1_RD_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: DPC_LIST_DATA2_RD
   ------------------------------------------------------------------------------------------
   type DPC_DPC_LIST_DATA2_RD_TYPE is record
      dpc_list_corr_pattern: std_logic_vector(7 downto 0);
   end record DPC_DPC_LIST_DATA2_RD_TYPE;

   constant INIT_DPC_DPC_LIST_DATA2_RD_TYPE : DPC_DPC_LIST_DATA2_RD_TYPE := (
      dpc_list_corr_pattern => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DPC_DPC_LIST_DATA2_RD_TYPE) return std_logic_vector;
   function to_DPC_DPC_LIST_DATA2_RD_TYPE(stdlv : std_logic_vector(31 downto 0)) return DPC_DPC_LIST_DATA2_RD_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: LUT_CAPABILITIES
   ------------------------------------------------------------------------------------------
   type LUT_LUT_CAPABILITIES_TYPE is record
      LUT_SIZE_CONFIG: std_logic_vector(11 downto 0);
      LUT_VER        : std_logic_vector(3 downto 0);
   end record LUT_LUT_CAPABILITIES_TYPE;

   constant INIT_LUT_LUT_CAPABILITIES_TYPE : LUT_LUT_CAPABILITIES_TYPE := (
      LUT_SIZE_CONFIG => (others=> 'Z'),
      LUT_VER         => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : LUT_LUT_CAPABILITIES_TYPE) return std_logic_vector;
   function to_LUT_LUT_CAPABILITIES_TYPE(stdlv : std_logic_vector(31 downto 0)) return LUT_LUT_CAPABILITIES_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: LUT_CTRL
   ------------------------------------------------------------------------------------------
   type LUT_LUT_CTRL_TYPE is record
      LUT_BYPASS_COLOR: std_logic;
      LUT_BYPASS     : std_logic;
      LUT_DATA_W     : std_logic_vector(9 downto 0);
      LUT_SEL        : std_logic_vector(3 downto 0);
      LUT_WRN        : std_logic;
      LUT_SS         : std_logic;
      LUT_ADD        : std_logic_vector(9 downto 0);
   end record LUT_LUT_CTRL_TYPE;

   constant INIT_LUT_LUT_CTRL_TYPE : LUT_LUT_CTRL_TYPE := (
      LUT_BYPASS_COLOR => 'Z',
      LUT_BYPASS      => 'Z',
      LUT_DATA_W      => (others=> 'Z'),
      LUT_SEL         => (others=> 'Z'),
      LUT_WRN         => 'Z',
      LUT_SS          => 'Z',
      LUT_ADD         => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : LUT_LUT_CTRL_TYPE) return std_logic_vector;
   function to_LUT_LUT_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return LUT_LUT_CTRL_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: LUT_RB
   ------------------------------------------------------------------------------------------
   type LUT_LUT_RB_TYPE is record
      LUT_RB         : std_logic_vector(7 downto 0);
   end record LUT_LUT_RB_TYPE;

   constant INIT_LUT_LUT_RB_TYPE : LUT_LUT_RB_TYPE := (
      LUT_RB          => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : LUT_LUT_RB_TYPE) return std_logic_vector;
   function to_LUT_LUT_RB_TYPE(stdlv : std_logic_vector(31 downto 0)) return LUT_LUT_RB_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: BAYER_CAPABILITIES
   ------------------------------------------------------------------------------------------
   type BAYER_BAYER_CAPABILITIES_TYPE is record
      BAYER_VER      : std_logic_vector(1 downto 0);
   end record BAYER_BAYER_CAPABILITIES_TYPE;

   constant INIT_BAYER_BAYER_CAPABILITIES_TYPE : BAYER_BAYER_CAPABILITIES_TYPE := (
      BAYER_VER       => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : BAYER_BAYER_CAPABILITIES_TYPE) return std_logic_vector;
   function to_BAYER_BAYER_CAPABILITIES_TYPE(stdlv : std_logic_vector(31 downto 0)) return BAYER_BAYER_CAPABILITIES_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: WB_MUL1
   ------------------------------------------------------------------------------------------
   type BAYER_WB_MUL1_TYPE is record
      WB_MULT_G      : std_logic_vector(15 downto 0);
      WB_MULT_B      : std_logic_vector(15 downto 0);
   end record BAYER_WB_MUL1_TYPE;

   constant INIT_BAYER_WB_MUL1_TYPE : BAYER_WB_MUL1_TYPE := (
      WB_MULT_G       => (others=> 'Z'),
      WB_MULT_B       => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : BAYER_WB_MUL1_TYPE) return std_logic_vector;
   function to_BAYER_WB_MUL1_TYPE(stdlv : std_logic_vector(31 downto 0)) return BAYER_WB_MUL1_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: WB_MUL2
   ------------------------------------------------------------------------------------------
   type BAYER_WB_MUL2_TYPE is record
      WB_MULT_R      : std_logic_vector(15 downto 0);
   end record BAYER_WB_MUL2_TYPE;

   constant INIT_BAYER_WB_MUL2_TYPE : BAYER_WB_MUL2_TYPE := (
      WB_MULT_R       => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : BAYER_WB_MUL2_TYPE) return std_logic_vector;
   function to_BAYER_WB_MUL2_TYPE(stdlv : std_logic_vector(31 downto 0)) return BAYER_WB_MUL2_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: WB_B_ACC
   ------------------------------------------------------------------------------------------
   type BAYER_WB_B_ACC_TYPE is record
      B_ACC          : std_logic_vector(30 downto 0);
   end record BAYER_WB_B_ACC_TYPE;

   constant INIT_BAYER_WB_B_ACC_TYPE : BAYER_WB_B_ACC_TYPE := (
      B_ACC           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : BAYER_WB_B_ACC_TYPE) return std_logic_vector;
   function to_BAYER_WB_B_ACC_TYPE(stdlv : std_logic_vector(31 downto 0)) return BAYER_WB_B_ACC_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: WB_G_ACC
   ------------------------------------------------------------------------------------------
   type BAYER_WB_G_ACC_TYPE is record
      G_ACC          : std_logic_vector(31 downto 0);
   end record BAYER_WB_G_ACC_TYPE;

   constant INIT_BAYER_WB_G_ACC_TYPE : BAYER_WB_G_ACC_TYPE := (
      G_ACC           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : BAYER_WB_G_ACC_TYPE) return std_logic_vector;
   function to_BAYER_WB_G_ACC_TYPE(stdlv : std_logic_vector(31 downto 0)) return BAYER_WB_G_ACC_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: WB_R_ACC
   ------------------------------------------------------------------------------------------
   type BAYER_WB_R_ACC_TYPE is record
      R_ACC          : std_logic_vector(30 downto 0);
   end record BAYER_WB_R_ACC_TYPE;

   constant INIT_BAYER_WB_R_ACC_TYPE : BAYER_WB_R_ACC_TYPE := (
      R_ACC           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : BAYER_WB_R_ACC_TYPE) return std_logic_vector;
   function to_BAYER_WB_R_ACC_TYPE(stdlv : std_logic_vector(31 downto 0)) return BAYER_WB_R_ACC_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: CCM_CTRL
   ------------------------------------------------------------------------------------------
   type BAYER_CCM_CTRL_TYPE is record
      CCM_EN         : std_logic;
   end record BAYER_CCM_CTRL_TYPE;

   constant INIT_BAYER_CCM_CTRL_TYPE : BAYER_CCM_CTRL_TYPE := (
      CCM_EN          => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : BAYER_CCM_CTRL_TYPE) return std_logic_vector;
   function to_BAYER_CCM_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return BAYER_CCM_CTRL_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: CCM_KR1
   ------------------------------------------------------------------------------------------
   type BAYER_CCM_KR1_TYPE is record
      Kg             : std_logic_vector(11 downto 0);
      Kr             : std_logic_vector(11 downto 0);
   end record BAYER_CCM_KR1_TYPE;

   constant INIT_BAYER_CCM_KR1_TYPE : BAYER_CCM_KR1_TYPE := (
      Kg              => (others=> 'Z'),
      Kr              => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : BAYER_CCM_KR1_TYPE) return std_logic_vector;
   function to_BAYER_CCM_KR1_TYPE(stdlv : std_logic_vector(31 downto 0)) return BAYER_CCM_KR1_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: CCM_KR2
   ------------------------------------------------------------------------------------------
   type BAYER_CCM_KR2_TYPE is record
      KOff           : std_logic_vector(8 downto 0);
      Kb             : std_logic_vector(11 downto 0);
   end record BAYER_CCM_KR2_TYPE;

   constant INIT_BAYER_CCM_KR2_TYPE : BAYER_CCM_KR2_TYPE := (
      KOff            => (others=> 'Z'),
      Kb              => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : BAYER_CCM_KR2_TYPE) return std_logic_vector;
   function to_BAYER_CCM_KR2_TYPE(stdlv : std_logic_vector(31 downto 0)) return BAYER_CCM_KR2_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: CCM_KG1
   ------------------------------------------------------------------------------------------
   type BAYER_CCM_KG1_TYPE is record
      Kg             : std_logic_vector(11 downto 0);
      Kr             : std_logic_vector(11 downto 0);
   end record BAYER_CCM_KG1_TYPE;

   constant INIT_BAYER_CCM_KG1_TYPE : BAYER_CCM_KG1_TYPE := (
      Kg              => (others=> 'Z'),
      Kr              => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : BAYER_CCM_KG1_TYPE) return std_logic_vector;
   function to_BAYER_CCM_KG1_TYPE(stdlv : std_logic_vector(31 downto 0)) return BAYER_CCM_KG1_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: CCM_KG2
   ------------------------------------------------------------------------------------------
   type BAYER_CCM_KG2_TYPE is record
      KOff           : std_logic_vector(8 downto 0);
      Kb             : std_logic_vector(11 downto 0);
   end record BAYER_CCM_KG2_TYPE;

   constant INIT_BAYER_CCM_KG2_TYPE : BAYER_CCM_KG2_TYPE := (
      KOff            => (others=> 'Z'),
      Kb              => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : BAYER_CCM_KG2_TYPE) return std_logic_vector;
   function to_BAYER_CCM_KG2_TYPE(stdlv : std_logic_vector(31 downto 0)) return BAYER_CCM_KG2_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: CCM_KB1
   ------------------------------------------------------------------------------------------
   type BAYER_CCM_KB1_TYPE is record
      Kg             : std_logic_vector(11 downto 0);
      Kr             : std_logic_vector(11 downto 0);
   end record BAYER_CCM_KB1_TYPE;

   constant INIT_BAYER_CCM_KB1_TYPE : BAYER_CCM_KB1_TYPE := (
      Kg              => (others=> 'Z'),
      Kr              => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : BAYER_CCM_KB1_TYPE) return std_logic_vector;
   function to_BAYER_CCM_KB1_TYPE(stdlv : std_logic_vector(31 downto 0)) return BAYER_CCM_KB1_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: CCM_KB2
   ------------------------------------------------------------------------------------------
   type BAYER_CCM_KB2_TYPE is record
      KOff           : std_logic_vector(8 downto 0);
      Kb             : std_logic_vector(11 downto 0);
   end record BAYER_CCM_KB2_TYPE;

   constant INIT_BAYER_CCM_KB2_TYPE : BAYER_CCM_KB2_TYPE := (
      KOff            => (others=> 'Z'),
      Kb              => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : BAYER_CCM_KB2_TYPE) return std_logic_vector;
   function to_BAYER_CCM_KB2_TYPE(stdlv : std_logic_vector(31 downto 0)) return BAYER_CCM_KB2_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Section Name: SYSTEM
   ------------------------------------------------------------------------------------------
   type SYSTEM_TYPE is record
      TAG            : SYSTEM_TAG_TYPE;
      VERSION        : SYSTEM_VERSION_TYPE;
      CAPABILITY     : SYSTEM_CAPABILITY_TYPE;
      SCRATCHPAD     : SYSTEM_SCRATCHPAD_TYPE;
   end record SYSTEM_TYPE;

   constant INIT_SYSTEM_TYPE : SYSTEM_TYPE := (
      TAG             => INIT_SYSTEM_TAG_TYPE,
      VERSION         => INIT_SYSTEM_VERSION_TYPE,
      CAPABILITY      => INIT_SYSTEM_CAPABILITY_TYPE,
      SCRATCHPAD      => INIT_SYSTEM_SCRATCHPAD_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Section Name: DMA
   ------------------------------------------------------------------------------------------
   type DMA_TYPE is record
      CTRL           : DMA_CTRL_TYPE;
      FSTART         : DMA_FSTART_TYPE;
      FSTART_HIGH    : DMA_FSTART_HIGH_TYPE;
      FSTART_G       : DMA_FSTART_G_TYPE;
      FSTART_G_HIGH  : DMA_FSTART_G_HIGH_TYPE;
      FSTART_R       : DMA_FSTART_R_TYPE;
      FSTART_R_HIGH  : DMA_FSTART_R_HIGH_TYPE;
      LINE_PITCH     : DMA_LINE_PITCH_TYPE;
      LINE_SIZE      : DMA_LINE_SIZE_TYPE;
      CSC            : DMA_CSC_TYPE;
      OUTPUT_BUFFER  : DMA_OUTPUT_BUFFER_TYPE;
      TLP            : DMA_TLP_TYPE;
      ROI_X          : DMA_ROI_X_TYPE;
      ROI_Y          : DMA_ROI_Y_TYPE;
   end record DMA_TYPE;

   constant INIT_DMA_TYPE : DMA_TYPE := (
      CTRL            => INIT_DMA_CTRL_TYPE,
      FSTART          => INIT_DMA_FSTART_TYPE,
      FSTART_HIGH     => INIT_DMA_FSTART_HIGH_TYPE,
      FSTART_G        => INIT_DMA_FSTART_G_TYPE,
      FSTART_G_HIGH   => INIT_DMA_FSTART_G_HIGH_TYPE,
      FSTART_R        => INIT_DMA_FSTART_R_TYPE,
      FSTART_R_HIGH   => INIT_DMA_FSTART_R_HIGH_TYPE,
      LINE_PITCH      => INIT_DMA_LINE_PITCH_TYPE,
      LINE_SIZE       => INIT_DMA_LINE_SIZE_TYPE,
      CSC             => INIT_DMA_CSC_TYPE,
      OUTPUT_BUFFER   => INIT_DMA_OUTPUT_BUFFER_TYPE,
      TLP             => INIT_DMA_TLP_TYPE,
      ROI_X           => INIT_DMA_ROI_X_TYPE,
      ROI_Y           => INIT_DMA_ROI_Y_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Section Name: ACQ
   ------------------------------------------------------------------------------------------
   type ACQ_TYPE is record
      GRAB_CTRL      : ACQ_GRAB_CTRL_TYPE;
      GRAB_STAT      : ACQ_GRAB_STAT_TYPE;
      READOUT_CFG1   : ACQ_READOUT_CFG1_TYPE;
      READOUT_CFG_FRAME_LINE: ACQ_READOUT_CFG_FRAME_LINE_TYPE;
      READOUT_CFG2   : ACQ_READOUT_CFG2_TYPE;
      READOUT_CFG3   : ACQ_READOUT_CFG3_TYPE;
      READOUT_CFG4   : ACQ_READOUT_CFG4_TYPE;
      EXP_CTRL1      : ACQ_EXP_CTRL1_TYPE;
      EXP_CTRL2      : ACQ_EXP_CTRL2_TYPE;
      EXP_CTRL3      : ACQ_EXP_CTRL3_TYPE;
      TRIGGER_DELAY  : ACQ_TRIGGER_DELAY_TYPE;
      STROBE_CTRL1   : ACQ_STROBE_CTRL1_TYPE;
      STROBE_CTRL2   : ACQ_STROBE_CTRL2_TYPE;
      ACQ_SER_CTRL   : ACQ_ACQ_SER_CTRL_TYPE;
      ACQ_SER_ADDATA : ACQ_ACQ_SER_ADDATA_TYPE;
      ACQ_SER_STAT   : ACQ_ACQ_SER_STAT_TYPE;
      SENSOR_CTRL    : ACQ_SENSOR_CTRL_TYPE;
      SENSOR_STAT    : ACQ_SENSOR_STAT_TYPE;
      SENSOR_SUBSAMPLING: ACQ_SENSOR_SUBSAMPLING_TYPE;
      SENSOR_GAIN_ANA: ACQ_SENSOR_GAIN_ANA_TYPE;
      SENSOR_ROI_Y_START: ACQ_SENSOR_ROI_Y_START_TYPE;
      SENSOR_ROI_Y_SIZE: ACQ_SENSOR_ROI_Y_SIZE_TYPE;
      SENSOR_M_LINES : ACQ_SENSOR_M_LINES_TYPE;
      SENSOR_DP_GR   : ACQ_SENSOR_DP_GR_TYPE;
      SENSOR_DP_GB   : ACQ_SENSOR_DP_GB_TYPE;
      SENSOR_DP_R    : ACQ_SENSOR_DP_R_TYPE;
      SENSOR_DP_B    : ACQ_SENSOR_DP_B_TYPE;
      SENSOR_GAIN_DIG_G: ACQ_SENSOR_GAIN_DIG_G_TYPE;
      SENSOR_GAIN_DIG_RB: ACQ_SENSOR_GAIN_DIG_RB_TYPE;
      DEBUG_PINS     : ACQ_DEBUG_PINS_TYPE;
      TRIGGER_MISSED : ACQ_TRIGGER_MISSED_TYPE;
      SENSOR_FPS     : ACQ_SENSOR_FPS_TYPE;
      SENSOR_FPS2    : ACQ_SENSOR_FPS2_TYPE;
      DEBUG          : ACQ_DEBUG_TYPE;
      DEBUG_CNTR1    : ACQ_DEBUG_CNTR1_TYPE;
      DEBUG_CNTR2    : ACQ_DEBUG_CNTR2_TYPE;
      DEBUG_CNTR3    : ACQ_DEBUG_CNTR3_TYPE;
      EXP_FOT        : ACQ_EXP_FOT_TYPE;
      ACQ_SFNC       : ACQ_ACQ_SFNC_TYPE;
      TIMER_CTRL     : ACQ_TIMER_CTRL_TYPE;
      TIMER_DELAY    : ACQ_TIMER_DELAY_TYPE;
      TIMER_DURATION : ACQ_TIMER_DURATION_TYPE;
   end record ACQ_TYPE;

   constant INIT_ACQ_TYPE : ACQ_TYPE := (
      GRAB_CTRL       => INIT_ACQ_GRAB_CTRL_TYPE,
      GRAB_STAT       => INIT_ACQ_GRAB_STAT_TYPE,
      READOUT_CFG1    => INIT_ACQ_READOUT_CFG1_TYPE,
      READOUT_CFG_FRAME_LINE => INIT_ACQ_READOUT_CFG_FRAME_LINE_TYPE,
      READOUT_CFG2    => INIT_ACQ_READOUT_CFG2_TYPE,
      READOUT_CFG3    => INIT_ACQ_READOUT_CFG3_TYPE,
      READOUT_CFG4    => INIT_ACQ_READOUT_CFG4_TYPE,
      EXP_CTRL1       => INIT_ACQ_EXP_CTRL1_TYPE,
      EXP_CTRL2       => INIT_ACQ_EXP_CTRL2_TYPE,
      EXP_CTRL3       => INIT_ACQ_EXP_CTRL3_TYPE,
      TRIGGER_DELAY   => INIT_ACQ_TRIGGER_DELAY_TYPE,
      STROBE_CTRL1    => INIT_ACQ_STROBE_CTRL1_TYPE,
      STROBE_CTRL2    => INIT_ACQ_STROBE_CTRL2_TYPE,
      ACQ_SER_CTRL    => INIT_ACQ_ACQ_SER_CTRL_TYPE,
      ACQ_SER_ADDATA  => INIT_ACQ_ACQ_SER_ADDATA_TYPE,
      ACQ_SER_STAT    => INIT_ACQ_ACQ_SER_STAT_TYPE,
      SENSOR_CTRL     => INIT_ACQ_SENSOR_CTRL_TYPE,
      SENSOR_STAT     => INIT_ACQ_SENSOR_STAT_TYPE,
      SENSOR_SUBSAMPLING => INIT_ACQ_SENSOR_SUBSAMPLING_TYPE,
      SENSOR_GAIN_ANA => INIT_ACQ_SENSOR_GAIN_ANA_TYPE,
      SENSOR_ROI_Y_START => INIT_ACQ_SENSOR_ROI_Y_START_TYPE,
      SENSOR_ROI_Y_SIZE => INIT_ACQ_SENSOR_ROI_Y_SIZE_TYPE,
      SENSOR_M_LINES  => INIT_ACQ_SENSOR_M_LINES_TYPE,
      SENSOR_DP_GR    => INIT_ACQ_SENSOR_DP_GR_TYPE,
      SENSOR_DP_GB    => INIT_ACQ_SENSOR_DP_GB_TYPE,
      SENSOR_DP_R     => INIT_ACQ_SENSOR_DP_R_TYPE,
      SENSOR_DP_B     => INIT_ACQ_SENSOR_DP_B_TYPE,
      SENSOR_GAIN_DIG_G => INIT_ACQ_SENSOR_GAIN_DIG_G_TYPE,
      SENSOR_GAIN_DIG_RB => INIT_ACQ_SENSOR_GAIN_DIG_RB_TYPE,
      DEBUG_PINS      => INIT_ACQ_DEBUG_PINS_TYPE,
      TRIGGER_MISSED  => INIT_ACQ_TRIGGER_MISSED_TYPE,
      SENSOR_FPS      => INIT_ACQ_SENSOR_FPS_TYPE,
      SENSOR_FPS2     => INIT_ACQ_SENSOR_FPS2_TYPE,
      DEBUG           => INIT_ACQ_DEBUG_TYPE,
      DEBUG_CNTR1     => INIT_ACQ_DEBUG_CNTR1_TYPE,
      DEBUG_CNTR2     => INIT_ACQ_DEBUG_CNTR2_TYPE,
      DEBUG_CNTR3     => INIT_ACQ_DEBUG_CNTR3_TYPE,
      EXP_FOT         => INIT_ACQ_EXP_FOT_TYPE,
      ACQ_SFNC        => INIT_ACQ_ACQ_SFNC_TYPE,
      TIMER_CTRL      => INIT_ACQ_TIMER_CTRL_TYPE,
      TIMER_DELAY     => INIT_ACQ_TIMER_DELAY_TYPE,
      TIMER_DURATION  => INIT_ACQ_TIMER_DURATION_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Section Name: HISPI
   ------------------------------------------------------------------------------------------
   type HISPI_TYPE is record
      CTRL           : HISPI_CTRL_TYPE;
      STATUS         : HISPI_STATUS_TYPE;
      IDELAYCTRL_STATUS: HISPI_IDELAYCTRL_STATUS_TYPE;
      IDLE_CHARACTER : HISPI_IDLE_CHARACTER_TYPE;
      PHY            : HISPI_PHY_TYPE;
      FRAME_CFG      : HISPI_FRAME_CFG_TYPE;
      FRAME_CFG_X_VALID: HISPI_FRAME_CFG_X_VALID_TYPE;
      LANE_DECODER_STATUS: HISPI_LANE_DECODER_STATUS_TYPE_ARRAY;
      TAP_HISTOGRAM  : HISPI_TAP_HISTOGRAM_TYPE_ARRAY;
      DEBUG          : HISPI_DEBUG_TYPE;
   end record HISPI_TYPE;

   constant INIT_HISPI_TYPE : HISPI_TYPE := (
      CTRL            => INIT_HISPI_CTRL_TYPE,
      STATUS          => INIT_HISPI_STATUS_TYPE,
      IDELAYCTRL_STATUS => INIT_HISPI_IDELAYCTRL_STATUS_TYPE,
      IDLE_CHARACTER  => INIT_HISPI_IDLE_CHARACTER_TYPE,
      PHY             => INIT_HISPI_PHY_TYPE,
      FRAME_CFG       => INIT_HISPI_FRAME_CFG_TYPE,
      FRAME_CFG_X_VALID => INIT_HISPI_FRAME_CFG_X_VALID_TYPE,
      LANE_DECODER_STATUS => INIT_HISPI_LANE_DECODER_STATUS_TYPE_ARRAY,
      TAP_HISTOGRAM   => INIT_HISPI_TAP_HISTOGRAM_TYPE_ARRAY,
      DEBUG           => INIT_HISPI_DEBUG_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Section Name: DPC
   ------------------------------------------------------------------------------------------
   type DPC_TYPE is record
      DPC_CAPABILITIES: DPC_DPC_CAPABILITIES_TYPE;
      DPC_LIST_CTRL  : DPC_DPC_LIST_CTRL_TYPE;
      DPC_LIST_STAT  : DPC_DPC_LIST_STAT_TYPE;
      DPC_LIST_DATA1 : DPC_DPC_LIST_DATA1_TYPE;
      DPC_LIST_DATA2 : DPC_DPC_LIST_DATA2_TYPE;
      DPC_LIST_DATA1_RD: DPC_DPC_LIST_DATA1_RD_TYPE;
      DPC_LIST_DATA2_RD: DPC_DPC_LIST_DATA2_RD_TYPE;
   end record DPC_TYPE;

   constant INIT_DPC_TYPE : DPC_TYPE := (
      DPC_CAPABILITIES => INIT_DPC_DPC_CAPABILITIES_TYPE,
      DPC_LIST_CTRL   => INIT_DPC_DPC_LIST_CTRL_TYPE,
      DPC_LIST_STAT   => INIT_DPC_DPC_LIST_STAT_TYPE,
      DPC_LIST_DATA1  => INIT_DPC_DPC_LIST_DATA1_TYPE,
      DPC_LIST_DATA2  => INIT_DPC_DPC_LIST_DATA2_TYPE,
      DPC_LIST_DATA1_RD => INIT_DPC_DPC_LIST_DATA1_RD_TYPE,
      DPC_LIST_DATA2_RD => INIT_DPC_DPC_LIST_DATA2_RD_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Section Name: LUT
   ------------------------------------------------------------------------------------------
   type LUT_TYPE is record
      LUT_CAPABILITIES: LUT_LUT_CAPABILITIES_TYPE;
      LUT_CTRL       : LUT_LUT_CTRL_TYPE;
      LUT_RB         : LUT_LUT_RB_TYPE;
   end record LUT_TYPE;

   constant INIT_LUT_TYPE : LUT_TYPE := (
      LUT_CAPABILITIES => INIT_LUT_LUT_CAPABILITIES_TYPE,
      LUT_CTRL        => INIT_LUT_LUT_CTRL_TYPE,
      LUT_RB          => INIT_LUT_LUT_RB_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Section Name: BAYER
   ------------------------------------------------------------------------------------------
   type BAYER_TYPE is record
      BAYER_CAPABILITIES: BAYER_BAYER_CAPABILITIES_TYPE;
      WB_MUL1        : BAYER_WB_MUL1_TYPE;
      WB_MUL2        : BAYER_WB_MUL2_TYPE;
      WB_B_ACC       : BAYER_WB_B_ACC_TYPE;
      WB_G_ACC       : BAYER_WB_G_ACC_TYPE;
      WB_R_ACC       : BAYER_WB_R_ACC_TYPE;
      CCM_CTRL       : BAYER_CCM_CTRL_TYPE;
      CCM_KR1        : BAYER_CCM_KR1_TYPE;
      CCM_KR2        : BAYER_CCM_KR2_TYPE;
      CCM_KG1        : BAYER_CCM_KG1_TYPE;
      CCM_KG2        : BAYER_CCM_KG2_TYPE;
      CCM_KB1        : BAYER_CCM_KB1_TYPE;
      CCM_KB2        : BAYER_CCM_KB2_TYPE;
   end record BAYER_TYPE;

   constant INIT_BAYER_TYPE : BAYER_TYPE := (
      BAYER_CAPABILITIES => INIT_BAYER_BAYER_CAPABILITIES_TYPE,
      WB_MUL1         => INIT_BAYER_WB_MUL1_TYPE,
      WB_MUL2         => INIT_BAYER_WB_MUL2_TYPE,
      WB_B_ACC        => INIT_BAYER_WB_B_ACC_TYPE,
      WB_G_ACC        => INIT_BAYER_WB_G_ACC_TYPE,
      WB_R_ACC        => INIT_BAYER_WB_R_ACC_TYPE,
      CCM_CTRL        => INIT_BAYER_CCM_CTRL_TYPE,
      CCM_KR1         => INIT_BAYER_CCM_KR1_TYPE,
      CCM_KR2         => INIT_BAYER_CCM_KR2_TYPE,
      CCM_KG1         => INIT_BAYER_CCM_KG1_TYPE,
      CCM_KG2         => INIT_BAYER_CCM_KG2_TYPE,
      CCM_KB1         => INIT_BAYER_CCM_KB1_TYPE,
      CCM_KB2         => INIT_BAYER_CCM_KB2_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Register file name: regfile_xgs_athena
   ------------------------------------------------------------------------------------------
   type REGFILE_XGS_ATHENA_TYPE is record
      SYSTEM         : SYSTEM_TYPE;
      DMA            : DMA_TYPE;
      ACQ            : ACQ_TYPE;
      HISPI          : HISPI_TYPE;
      DPC            : DPC_TYPE;
      LUT            : LUT_TYPE;
      BAYER          : BAYER_TYPE;
   end record REGFILE_XGS_ATHENA_TYPE;

   constant INIT_REGFILE_XGS_ATHENA_TYPE : REGFILE_XGS_ATHENA_TYPE := (
      SYSTEM          => INIT_SYSTEM_TYPE,
      DMA             => INIT_DMA_TYPE,
      ACQ             => INIT_ACQ_TYPE,
      HISPI           => INIT_HISPI_TYPE,
      DPC             => INIT_DPC_TYPE,
      LUT             => INIT_LUT_TYPE,
      BAYER           => INIT_BAYER_TYPE
   );

   
end regfile_xgs_athena_pack;

package body regfile_xgs_athena_pack is
   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from SYSTEM_TAG_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : SYSTEM_TAG_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(23 downto 0) := reg.VALUE;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_SYSTEM_TAG_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to SYSTEM_TAG_TYPE
   --------------------------------------------------------------------------------
   function to_SYSTEM_TAG_TYPE(stdlv : std_logic_vector(31 downto 0)) return SYSTEM_TAG_TYPE is
   variable output : SYSTEM_TAG_TYPE;
   begin
      output.VALUE := stdlv(23 downto 0);
      return output;
   end to_SYSTEM_TAG_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from SYSTEM_VERSION_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : SYSTEM_VERSION_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(23 downto 16) := reg.MAJOR;
      output(15 downto 8) := reg.MINOR;
      output(7 downto 0) := reg.HW;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_SYSTEM_VERSION_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to SYSTEM_VERSION_TYPE
   --------------------------------------------------------------------------------
   function to_SYSTEM_VERSION_TYPE(stdlv : std_logic_vector(31 downto 0)) return SYSTEM_VERSION_TYPE is
   variable output : SYSTEM_VERSION_TYPE;
   begin
      output.MAJOR := stdlv(23 downto 16);
      output.MINOR := stdlv(15 downto 8);
      output.HW := stdlv(7 downto 0);
      return output;
   end to_SYSTEM_VERSION_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from SYSTEM_CAPABILITY_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : SYSTEM_CAPABILITY_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(7 downto 0) := reg.VALUE;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_SYSTEM_CAPABILITY_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to SYSTEM_CAPABILITY_TYPE
   --------------------------------------------------------------------------------
   function to_SYSTEM_CAPABILITY_TYPE(stdlv : std_logic_vector(31 downto 0)) return SYSTEM_CAPABILITY_TYPE is
   variable output : SYSTEM_CAPABILITY_TYPE;
   begin
      output.VALUE := stdlv(7 downto 0);
      return output;
   end to_SYSTEM_CAPABILITY_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from SYSTEM_SCRATCHPAD_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : SYSTEM_SCRATCHPAD_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.VALUE;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_SYSTEM_SCRATCHPAD_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to SYSTEM_SCRATCHPAD_TYPE
   --------------------------------------------------------------------------------
   function to_SYSTEM_SCRATCHPAD_TYPE(stdlv : std_logic_vector(31 downto 0)) return SYSTEM_SCRATCHPAD_TYPE is
   variable output : SYSTEM_SCRATCHPAD_TYPE;
   begin
      output.VALUE := stdlv(31 downto 0);
      return output;
   end to_SYSTEM_SCRATCHPAD_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DMA_CTRL_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DMA_CTRL_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(0) := reg.GRAB_QUEUE_EN;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DMA_CTRL_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DMA_CTRL_TYPE
   --------------------------------------------------------------------------------
   function to_DMA_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_CTRL_TYPE is
   variable output : DMA_CTRL_TYPE;
   begin
      output.GRAB_QUEUE_EN := stdlv(0);
      return output;
   end to_DMA_CTRL_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DMA_FSTART_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DMA_FSTART_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.VALUE;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DMA_FSTART_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DMA_FSTART_TYPE
   --------------------------------------------------------------------------------
   function to_DMA_FSTART_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_FSTART_TYPE is
   variable output : DMA_FSTART_TYPE;
   begin
      output.VALUE := stdlv(31 downto 0);
      return output;
   end to_DMA_FSTART_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DMA_FSTART_HIGH_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DMA_FSTART_HIGH_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.VALUE;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DMA_FSTART_HIGH_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DMA_FSTART_HIGH_TYPE
   --------------------------------------------------------------------------------
   function to_DMA_FSTART_HIGH_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_FSTART_HIGH_TYPE is
   variable output : DMA_FSTART_HIGH_TYPE;
   begin
      output.VALUE := stdlv(31 downto 0);
      return output;
   end to_DMA_FSTART_HIGH_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DMA_FSTART_G_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DMA_FSTART_G_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.VALUE;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DMA_FSTART_G_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DMA_FSTART_G_TYPE
   --------------------------------------------------------------------------------
   function to_DMA_FSTART_G_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_FSTART_G_TYPE is
   variable output : DMA_FSTART_G_TYPE;
   begin
      output.VALUE := stdlv(31 downto 0);
      return output;
   end to_DMA_FSTART_G_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DMA_FSTART_G_HIGH_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DMA_FSTART_G_HIGH_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.VALUE;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DMA_FSTART_G_HIGH_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DMA_FSTART_G_HIGH_TYPE
   --------------------------------------------------------------------------------
   function to_DMA_FSTART_G_HIGH_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_FSTART_G_HIGH_TYPE is
   variable output : DMA_FSTART_G_HIGH_TYPE;
   begin
      output.VALUE := stdlv(31 downto 0);
      return output;
   end to_DMA_FSTART_G_HIGH_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DMA_FSTART_R_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DMA_FSTART_R_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.VALUE;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DMA_FSTART_R_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DMA_FSTART_R_TYPE
   --------------------------------------------------------------------------------
   function to_DMA_FSTART_R_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_FSTART_R_TYPE is
   variable output : DMA_FSTART_R_TYPE;
   begin
      output.VALUE := stdlv(31 downto 0);
      return output;
   end to_DMA_FSTART_R_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DMA_FSTART_R_HIGH_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DMA_FSTART_R_HIGH_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.VALUE;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DMA_FSTART_R_HIGH_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DMA_FSTART_R_HIGH_TYPE
   --------------------------------------------------------------------------------
   function to_DMA_FSTART_R_HIGH_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_FSTART_R_HIGH_TYPE is
   variable output : DMA_FSTART_R_HIGH_TYPE;
   begin
      output.VALUE := stdlv(31 downto 0);
      return output;
   end to_DMA_FSTART_R_HIGH_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DMA_LINE_PITCH_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DMA_LINE_PITCH_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(15 downto 0) := reg.VALUE;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DMA_LINE_PITCH_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DMA_LINE_PITCH_TYPE
   --------------------------------------------------------------------------------
   function to_DMA_LINE_PITCH_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_LINE_PITCH_TYPE is
   variable output : DMA_LINE_PITCH_TYPE;
   begin
      output.VALUE := stdlv(15 downto 0);
      return output;
   end to_DMA_LINE_PITCH_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DMA_LINE_SIZE_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DMA_LINE_SIZE_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(14 downto 0) := reg.VALUE;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DMA_LINE_SIZE_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DMA_LINE_SIZE_TYPE
   --------------------------------------------------------------------------------
   function to_DMA_LINE_SIZE_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_LINE_SIZE_TYPE is
   variable output : DMA_LINE_SIZE_TYPE;
   begin
      output.VALUE := stdlv(14 downto 0);
      return output;
   end to_DMA_LINE_SIZE_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DMA_CSC_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DMA_CSC_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(26 downto 24) := reg.COLOR_SPACE;
      output(13 downto 10) := reg.SUB_X;
      output(9) := reg.REVERSE_Y;
      output(8) := reg.REVERSE_X;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DMA_CSC_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DMA_CSC_TYPE
   --------------------------------------------------------------------------------
   function to_DMA_CSC_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_CSC_TYPE is
   variable output : DMA_CSC_TYPE;
   begin
      output.COLOR_SPACE := stdlv(26 downto 24);
      output.SUB_X := stdlv(13 downto 10);
      output.REVERSE_Y := stdlv(9);
      output.REVERSE_X := stdlv(8);
      return output;
   end to_DMA_CSC_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DMA_OUTPUT_BUFFER_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DMA_OUTPUT_BUFFER_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(30 downto 28) := reg.MAX_LINE_BUFF_CNT;
      output(25 downto 24) := reg.LINE_PTR_WIDTH;
      output(23 downto 20) := reg.ADDRESS_BUS_WIDTH;
      output(4) := reg.PCIE_BACK_PRESSURE;
      output(0) := reg.CLR_MAX_LINE_BUFF_CNT;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DMA_OUTPUT_BUFFER_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DMA_OUTPUT_BUFFER_TYPE
   --------------------------------------------------------------------------------
   function to_DMA_OUTPUT_BUFFER_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_OUTPUT_BUFFER_TYPE is
   variable output : DMA_OUTPUT_BUFFER_TYPE;
   begin
      output.MAX_LINE_BUFF_CNT := stdlv(30 downto 28);
      output.LINE_PTR_WIDTH := stdlv(25 downto 24);
      output.ADDRESS_BUS_WIDTH := stdlv(23 downto 20);
      output.PCIE_BACK_PRESSURE := stdlv(4);
      output.CLR_MAX_LINE_BUFF_CNT := stdlv(0);
      return output;
   end to_DMA_OUTPUT_BUFFER_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DMA_TLP_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DMA_TLP_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(27 downto 16) := reg.MAX_PAYLOAD;
      output(3) := reg.BUS_MASTER_EN;
      output(2 downto 0) := reg.CFG_MAX_PLD;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DMA_TLP_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DMA_TLP_TYPE
   --------------------------------------------------------------------------------
   function to_DMA_TLP_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_TLP_TYPE is
   variable output : DMA_TLP_TYPE;
   begin
      output.MAX_PAYLOAD := stdlv(27 downto 16);
      output.BUS_MASTER_EN := stdlv(3);
      output.CFG_MAX_PLD := stdlv(2 downto 0);
      return output;
   end to_DMA_TLP_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DMA_ROI_X_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DMA_ROI_X_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31) := reg.ROI_EN;
      output(28 downto 16) := reg.X_SIZE;
      output(12 downto 0) := reg.X_START;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DMA_ROI_X_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DMA_ROI_X_TYPE
   --------------------------------------------------------------------------------
   function to_DMA_ROI_X_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_ROI_X_TYPE is
   variable output : DMA_ROI_X_TYPE;
   begin
      output.ROI_EN := stdlv(31);
      output.X_SIZE := stdlv(28 downto 16);
      output.X_START := stdlv(12 downto 0);
      return output;
   end to_DMA_ROI_X_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DMA_ROI_Y_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DMA_ROI_Y_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31) := reg.ROI_EN;
      output(28 downto 16) := reg.Y_SIZE;
      output(12 downto 0) := reg.Y_START;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DMA_ROI_Y_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DMA_ROI_Y_TYPE
   --------------------------------------------------------------------------------
   function to_DMA_ROI_Y_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_ROI_Y_TYPE is
   variable output : DMA_ROI_Y_TYPE;
   begin
      output.ROI_EN := stdlv(31);
      output.Y_SIZE := stdlv(28 downto 16);
      output.Y_START := stdlv(12 downto 0);
      return output;
   end to_DMA_ROI_Y_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_GRAB_CTRL_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_GRAB_CTRL_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31) := reg.RESET_GRAB;
      output(29) := reg.GRAB_ROI2_EN;
      output(28) := reg.ABORT_GRAB;
      output(16) := reg.TRIGGER_OVERLAP_BUFFn;
      output(15) := reg.TRIGGER_OVERLAP;
      output(14 downto 12) := reg.TRIGGER_ACT;
      output(10 downto 8) := reg.TRIGGER_SRC;
      output(4) := reg.GRAB_SS;
      output(1) := reg.BUFFER_ID;
      output(0) := reg.GRAB_CMD;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_GRAB_CTRL_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_GRAB_CTRL_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_GRAB_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_GRAB_CTRL_TYPE is
   variable output : ACQ_GRAB_CTRL_TYPE;
   begin
      output.RESET_GRAB := stdlv(31);
      output.GRAB_ROI2_EN := stdlv(29);
      output.ABORT_GRAB := stdlv(28);
      output.TRIGGER_OVERLAP_BUFFn := stdlv(16);
      output.TRIGGER_OVERLAP := stdlv(15);
      output.TRIGGER_ACT := stdlv(14 downto 12);
      output.TRIGGER_SRC := stdlv(10 downto 8);
      output.GRAB_SS := stdlv(4);
      output.BUFFER_ID := stdlv(1);
      output.GRAB_CMD := stdlv(0);
      return output;
   end to_ACQ_GRAB_CTRL_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_GRAB_STAT_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_GRAB_STAT_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31) := reg.GRAB_CMD_DONE;
      output(30) := reg.ABORT_PET;
      output(29) := reg.ABORT_DELAI;
      output(28) := reg.ABORT_DONE;
      output(24) := reg.TRIGGER_RDY;
      output(22 downto 20) := reg.ABORT_MNGR_STAT;
      output(19 downto 16) := reg.TRIG_MNGR_STAT;
      output(14 downto 12) := reg.TIMER_MNGR_STAT;
      output(11 downto 8) := reg.GRAB_MNGR_STAT;
      output(6) := reg.GRAB_FOT;
      output(5) := reg.GRAB_READOUT;
      output(4) := reg.GRAB_EXPOSURE;
      output(2) := reg.GRAB_PENDING;
      output(1) := reg.GRAB_ACTIVE;
      output(0) := reg.GRAB_IDLE;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_GRAB_STAT_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_GRAB_STAT_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_GRAB_STAT_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_GRAB_STAT_TYPE is
   variable output : ACQ_GRAB_STAT_TYPE;
   begin
      output.GRAB_CMD_DONE := stdlv(31);
      output.ABORT_PET := stdlv(30);
      output.ABORT_DELAI := stdlv(29);
      output.ABORT_DONE := stdlv(28);
      output.TRIGGER_RDY := stdlv(24);
      output.ABORT_MNGR_STAT := stdlv(22 downto 20);
      output.TRIG_MNGR_STAT := stdlv(19 downto 16);
      output.TIMER_MNGR_STAT := stdlv(14 downto 12);
      output.GRAB_MNGR_STAT := stdlv(11 downto 8);
      output.GRAB_FOT := stdlv(6);
      output.GRAB_READOUT := stdlv(5);
      output.GRAB_EXPOSURE := stdlv(4);
      output.GRAB_PENDING := stdlv(2);
      output.GRAB_ACTIVE := stdlv(1);
      output.GRAB_IDLE := stdlv(0);
      return output;
   end to_ACQ_GRAB_STAT_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_READOUT_CFG1_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_READOUT_CFG1_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(28 downto 24) := reg.FOT_LENGTH_LINE;
      output(16) := reg.EO_FOT_SEL;
      output(15 downto 0) := reg.FOT_LENGTH;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_READOUT_CFG1_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_READOUT_CFG1_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_READOUT_CFG1_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_READOUT_CFG1_TYPE is
   variable output : ACQ_READOUT_CFG1_TYPE;
   begin
      output.FOT_LENGTH_LINE := stdlv(28 downto 24);
      output.EO_FOT_SEL := stdlv(16);
      output.FOT_LENGTH := stdlv(15 downto 0);
      return output;
   end to_ACQ_READOUT_CFG1_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_READOUT_CFG_FRAME_LINE_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_READOUT_CFG_FRAME_LINE_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(23 downto 16) := reg.DUMMY_LINES;
      output(12 downto 0) := reg.CURR_FRAME_LINES;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_READOUT_CFG_FRAME_LINE_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_READOUT_CFG_FRAME_LINE_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_READOUT_CFG_FRAME_LINE_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_READOUT_CFG_FRAME_LINE_TYPE is
   variable output : ACQ_READOUT_CFG_FRAME_LINE_TYPE;
   begin
      output.DUMMY_LINES := stdlv(23 downto 16);
      output.CURR_FRAME_LINES := stdlv(12 downto 0);
      return output;
   end to_ACQ_READOUT_CFG_FRAME_LINE_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_READOUT_CFG2_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_READOUT_CFG2_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(28 downto 0) := reg.READOUT_LENGTH;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_READOUT_CFG2_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_READOUT_CFG2_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_READOUT_CFG2_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_READOUT_CFG2_TYPE is
   variable output : ACQ_READOUT_CFG2_TYPE;
   begin
      output.READOUT_LENGTH := stdlv(28 downto 0);
      return output;
   end to_ACQ_READOUT_CFG2_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_READOUT_CFG3_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_READOUT_CFG3_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(15 downto 0) := reg.LINE_TIME;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_READOUT_CFG3_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_READOUT_CFG3_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_READOUT_CFG3_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_READOUT_CFG3_TYPE is
   variable output : ACQ_READOUT_CFG3_TYPE;
   begin
      output.LINE_TIME := stdlv(15 downto 0);
      return output;
   end to_ACQ_READOUT_CFG3_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_READOUT_CFG4_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_READOUT_CFG4_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(16) := reg.KEEP_OUT_TRIG_ENA;
      output(15 downto 0) := reg.KEEP_OUT_TRIG_START;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_READOUT_CFG4_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_READOUT_CFG4_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_READOUT_CFG4_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_READOUT_CFG4_TYPE is
   variable output : ACQ_READOUT_CFG4_TYPE;
   begin
      output.KEEP_OUT_TRIG_ENA := stdlv(16);
      output.KEEP_OUT_TRIG_START := stdlv(15 downto 0);
      return output;
   end to_ACQ_READOUT_CFG4_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_EXP_CTRL1_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_EXP_CTRL1_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(28) := reg.EXPOSURE_LEV_MODE;
      output(27 downto 0) := reg.EXPOSURE_SS;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_EXP_CTRL1_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_EXP_CTRL1_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_EXP_CTRL1_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_EXP_CTRL1_TYPE is
   variable output : ACQ_EXP_CTRL1_TYPE;
   begin
      output.EXPOSURE_LEV_MODE := stdlv(28);
      output.EXPOSURE_SS := stdlv(27 downto 0);
      return output;
   end to_ACQ_EXP_CTRL1_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_EXP_CTRL2_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_EXP_CTRL2_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(27 downto 0) := reg.EXPOSURE_DS;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_EXP_CTRL2_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_EXP_CTRL2_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_EXP_CTRL2_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_EXP_CTRL2_TYPE is
   variable output : ACQ_EXP_CTRL2_TYPE;
   begin
      output.EXPOSURE_DS := stdlv(27 downto 0);
      return output;
   end to_ACQ_EXP_CTRL2_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_EXP_CTRL3_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_EXP_CTRL3_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(27 downto 0) := reg.EXPOSURE_TS;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_EXP_CTRL3_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_EXP_CTRL3_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_EXP_CTRL3_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_EXP_CTRL3_TYPE is
   variable output : ACQ_EXP_CTRL3_TYPE;
   begin
      output.EXPOSURE_TS := stdlv(27 downto 0);
      return output;
   end to_ACQ_EXP_CTRL3_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_TRIGGER_DELAY_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_TRIGGER_DELAY_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(27 downto 0) := reg.TRIGGER_DELAY;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_TRIGGER_DELAY_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_TRIGGER_DELAY_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_TRIGGER_DELAY_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_TRIGGER_DELAY_TYPE is
   variable output : ACQ_TRIGGER_DELAY_TYPE;
   begin
      output.TRIGGER_DELAY := stdlv(27 downto 0);
      return output;
   end to_ACQ_TRIGGER_DELAY_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_STROBE_CTRL1_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_STROBE_CTRL1_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31) := reg.STROBE_E;
      output(28) := reg.STROBE_POL;
      output(27 downto 0) := reg.STROBE_START;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_STROBE_CTRL1_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_STROBE_CTRL1_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_STROBE_CTRL1_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_STROBE_CTRL1_TYPE is
   variable output : ACQ_STROBE_CTRL1_TYPE;
   begin
      output.STROBE_E := stdlv(31);
      output.STROBE_POL := stdlv(28);
      output.STROBE_START := stdlv(27 downto 0);
      return output;
   end to_ACQ_STROBE_CTRL1_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_STROBE_CTRL2_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_STROBE_CTRL2_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31) := reg.STROBE_MODE;
      output(29) := reg.STROBE_B_EN;
      output(28) := reg.STROBE_A_EN;
      output(27 downto 0) := reg.STROBE_END;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_STROBE_CTRL2_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_STROBE_CTRL2_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_STROBE_CTRL2_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_STROBE_CTRL2_TYPE is
   variable output : ACQ_STROBE_CTRL2_TYPE;
   begin
      output.STROBE_MODE := stdlv(31);
      output.STROBE_B_EN := stdlv(29);
      output.STROBE_A_EN := stdlv(28);
      output.STROBE_END := stdlv(27 downto 0);
      return output;
   end to_ACQ_STROBE_CTRL2_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_ACQ_SER_CTRL_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_ACQ_SER_CTRL_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(16) := reg.SER_RWn;
      output(9 downto 8) := reg.SER_CMD;
      output(4) := reg.SER_RF_SS;
      output(0) := reg.SER_WF_SS;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_ACQ_SER_CTRL_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_ACQ_SER_CTRL_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_ACQ_SER_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_ACQ_SER_CTRL_TYPE is
   variable output : ACQ_ACQ_SER_CTRL_TYPE;
   begin
      output.SER_RWn := stdlv(16);
      output.SER_CMD := stdlv(9 downto 8);
      output.SER_RF_SS := stdlv(4);
      output.SER_WF_SS := stdlv(0);
      return output;
   end to_ACQ_ACQ_SER_CTRL_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_ACQ_SER_ADDATA_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_ACQ_SER_ADDATA_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 16) := reg.SER_DAT;
      output(14 downto 0) := reg.SER_ADD;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_ACQ_SER_ADDATA_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_ACQ_SER_ADDATA_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_ACQ_SER_ADDATA_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_ACQ_SER_ADDATA_TYPE is
   variable output : ACQ_ACQ_SER_ADDATA_TYPE;
   begin
      output.SER_DAT := stdlv(31 downto 16);
      output.SER_ADD := stdlv(14 downto 0);
      return output;
   end to_ACQ_ACQ_SER_ADDATA_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_ACQ_SER_STAT_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_ACQ_SER_STAT_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(24) := reg.SER_FIFO_EMPTY;
      output(16) := reg.SER_BUSY;
      output(15 downto 0) := reg.SER_DAT_R;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_ACQ_SER_STAT_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_ACQ_SER_STAT_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_ACQ_SER_STAT_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_ACQ_SER_STAT_TYPE is
   variable output : ACQ_ACQ_SER_STAT_TYPE;
   begin
      output.SER_FIFO_EMPTY := stdlv(24);
      output.SER_BUSY := stdlv(16);
      output.SER_DAT_R := stdlv(15 downto 0);
      return output;
   end to_ACQ_ACQ_SER_STAT_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_SENSOR_CTRL_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_SENSOR_CTRL_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(24) := reg.SENSOR_REFRESH_TEMP;
      output(16) := reg.SENSOR_POWERDOWN;
      output(8) := reg.SENSOR_COLOR;
      output(4) := reg.SENSOR_REG_UPDATE;
      output(1) := reg.SENSOR_RESETN;
      output(0) := reg.SENSOR_POWERUP;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_SENSOR_CTRL_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_SENSOR_CTRL_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_SENSOR_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_CTRL_TYPE is
   variable output : ACQ_SENSOR_CTRL_TYPE;
   begin
      output.SENSOR_REFRESH_TEMP := stdlv(24);
      output.SENSOR_POWERDOWN := stdlv(16);
      output.SENSOR_COLOR := stdlv(8);
      output.SENSOR_REG_UPDATE := stdlv(4);
      output.SENSOR_RESETN := stdlv(1);
      output.SENSOR_POWERUP := stdlv(0);
      return output;
   end to_ACQ_SENSOR_CTRL_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_SENSOR_STAT_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_SENSOR_STAT_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 24) := reg.SENSOR_TEMP;
      output(23) := reg.SENSOR_TEMP_VALID;
      output(16) := reg.SENSOR_POWERDOWN;
      output(13) := reg.SENSOR_RESETN;
      output(12) := reg.SENSOR_OSC_EN;
      output(8) := reg.SENSOR_VCC_PG;
      output(1) := reg.SENSOR_POWERUP_STAT;
      output(0) := reg.SENSOR_POWERUP_DONE;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_SENSOR_STAT_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_SENSOR_STAT_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_SENSOR_STAT_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_STAT_TYPE is
   variable output : ACQ_SENSOR_STAT_TYPE;
   begin
      output.SENSOR_TEMP := stdlv(31 downto 24);
      output.SENSOR_TEMP_VALID := stdlv(23);
      output.SENSOR_POWERDOWN := stdlv(16);
      output.SENSOR_RESETN := stdlv(13);
      output.SENSOR_OSC_EN := stdlv(12);
      output.SENSOR_VCC_PG := stdlv(8);
      output.SENSOR_POWERUP_STAT := stdlv(1);
      output.SENSOR_POWERUP_DONE := stdlv(0);
      return output;
   end to_ACQ_SENSOR_STAT_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_SENSOR_SUBSAMPLING_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_SENSOR_SUBSAMPLING_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(15 downto 4) := reg.reserved1;
      output(3) := reg.ACTIVE_SUBSAMPLING_Y;
      output(2) := reg.reserved0;
      output(1) := reg.M_SUBSAMPLING_Y;
      output(0) := reg.SUBSAMPLING_X;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_SENSOR_SUBSAMPLING_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_SENSOR_SUBSAMPLING_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_SENSOR_SUBSAMPLING_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_SUBSAMPLING_TYPE is
   variable output : ACQ_SENSOR_SUBSAMPLING_TYPE;
   begin
      output.reserved1 := stdlv(15 downto 4);
      output.ACTIVE_SUBSAMPLING_Y := stdlv(3);
      output.reserved0 := stdlv(2);
      output.M_SUBSAMPLING_Y := stdlv(1);
      output.SUBSAMPLING_X := stdlv(0);
      return output;
   end to_ACQ_SENSOR_SUBSAMPLING_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_SENSOR_GAIN_ANA_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_SENSOR_GAIN_ANA_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(15 downto 11) := reg.reserved1;
      output(10 downto 8) := reg.ANALOG_GAIN;
      output(7 downto 0) := reg.reserved0;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_SENSOR_GAIN_ANA_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_SENSOR_GAIN_ANA_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_SENSOR_GAIN_ANA_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_GAIN_ANA_TYPE is
   variable output : ACQ_SENSOR_GAIN_ANA_TYPE;
   begin
      output.reserved1 := stdlv(15 downto 11);
      output.ANALOG_GAIN := stdlv(10 downto 8);
      output.reserved0 := stdlv(7 downto 0);
      return output;
   end to_ACQ_SENSOR_GAIN_ANA_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_SENSOR_ROI_Y_START_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_SENSOR_ROI_Y_START_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(15 downto 10) := reg.reserved;
      output(9 downto 0) := reg.Y_START;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_SENSOR_ROI_Y_START_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_SENSOR_ROI_Y_START_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_SENSOR_ROI_Y_START_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_ROI_Y_START_TYPE is
   variable output : ACQ_SENSOR_ROI_Y_START_TYPE;
   begin
      output.reserved := stdlv(15 downto 10);
      output.Y_START := stdlv(9 downto 0);
      return output;
   end to_ACQ_SENSOR_ROI_Y_START_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_SENSOR_ROI_Y_SIZE_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_SENSOR_ROI_Y_SIZE_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(15 downto 10) := reg.reserved;
      output(9 downto 0) := reg.Y_SIZE;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_SENSOR_ROI_Y_SIZE_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_SENSOR_ROI_Y_SIZE_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_SENSOR_ROI_Y_SIZE_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_ROI_Y_SIZE_TYPE is
   variable output : ACQ_SENSOR_ROI_Y_SIZE_TYPE;
   begin
      output.reserved := stdlv(15 downto 10);
      output.Y_SIZE := stdlv(9 downto 0);
      return output;
   end to_ACQ_SENSOR_ROI_Y_SIZE_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_SENSOR_M_LINES_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_SENSOR_M_LINES_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(15) := reg.M_LINES_DISPLAY;
      output(14 downto 10) := reg.M_SUPPRESSED;
      output(9 downto 0) := reg.M_LINES_SENSOR;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_SENSOR_M_LINES_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_SENSOR_M_LINES_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_SENSOR_M_LINES_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_M_LINES_TYPE is
   variable output : ACQ_SENSOR_M_LINES_TYPE;
   begin
      output.M_LINES_DISPLAY := stdlv(15);
      output.M_SUPPRESSED := stdlv(14 downto 10);
      output.M_LINES_SENSOR := stdlv(9 downto 0);
      return output;
   end to_ACQ_SENSOR_M_LINES_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_SENSOR_DP_GR_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_SENSOR_DP_GR_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(15 downto 12) := reg.reserved;
      output(11 downto 0) := reg.DP_OFFSET_GR;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_SENSOR_DP_GR_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_SENSOR_DP_GR_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_SENSOR_DP_GR_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_DP_GR_TYPE is
   variable output : ACQ_SENSOR_DP_GR_TYPE;
   begin
      output.reserved := stdlv(15 downto 12);
      output.DP_OFFSET_GR := stdlv(11 downto 0);
      return output;
   end to_ACQ_SENSOR_DP_GR_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_SENSOR_DP_GB_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_SENSOR_DP_GB_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(15 downto 12) := reg.reserved;
      output(11 downto 0) := reg.DP_OFFSET_GB;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_SENSOR_DP_GB_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_SENSOR_DP_GB_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_SENSOR_DP_GB_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_DP_GB_TYPE is
   variable output : ACQ_SENSOR_DP_GB_TYPE;
   begin
      output.reserved := stdlv(15 downto 12);
      output.DP_OFFSET_GB := stdlv(11 downto 0);
      return output;
   end to_ACQ_SENSOR_DP_GB_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_SENSOR_DP_R_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_SENSOR_DP_R_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(15 downto 12) := reg.reserved;
      output(11 downto 0) := reg.DP_OFFSET_R;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_SENSOR_DP_R_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_SENSOR_DP_R_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_SENSOR_DP_R_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_DP_R_TYPE is
   variable output : ACQ_SENSOR_DP_R_TYPE;
   begin
      output.reserved := stdlv(15 downto 12);
      output.DP_OFFSET_R := stdlv(11 downto 0);
      return output;
   end to_ACQ_SENSOR_DP_R_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_SENSOR_DP_B_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_SENSOR_DP_B_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(15 downto 12) := reg.reserved;
      output(11 downto 0) := reg.DP_OFFSET_B;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_SENSOR_DP_B_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_SENSOR_DP_B_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_SENSOR_DP_B_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_DP_B_TYPE is
   variable output : ACQ_SENSOR_DP_B_TYPE;
   begin
      output.reserved := stdlv(15 downto 12);
      output.DP_OFFSET_B := stdlv(11 downto 0);
      return output;
   end to_ACQ_SENSOR_DP_B_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_SENSOR_GAIN_DIG_G_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_SENSOR_GAIN_DIG_G_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(15) := reg.reserved1;
      output(14 downto 8) := reg.DG_FACTOR_GR;
      output(7) := reg.reserved0;
      output(6 downto 0) := reg.DG_FACTOR_GB;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_SENSOR_GAIN_DIG_G_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_SENSOR_GAIN_DIG_G_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_SENSOR_GAIN_DIG_G_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_GAIN_DIG_G_TYPE is
   variable output : ACQ_SENSOR_GAIN_DIG_G_TYPE;
   begin
      output.reserved1 := stdlv(15);
      output.DG_FACTOR_GR := stdlv(14 downto 8);
      output.reserved0 := stdlv(7);
      output.DG_FACTOR_GB := stdlv(6 downto 0);
      return output;
   end to_ACQ_SENSOR_GAIN_DIG_G_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_SENSOR_GAIN_DIG_RB_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_SENSOR_GAIN_DIG_RB_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(15) := reg.reserved1;
      output(14 downto 8) := reg.DG_FACTOR_R;
      output(7) := reg.reserved0;
      output(6 downto 0) := reg.DG_FACTOR_B;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_SENSOR_GAIN_DIG_RB_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_SENSOR_GAIN_DIG_RB_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_SENSOR_GAIN_DIG_RB_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_GAIN_DIG_RB_TYPE is
   variable output : ACQ_SENSOR_GAIN_DIG_RB_TYPE;
   begin
      output.reserved1 := stdlv(15);
      output.DG_FACTOR_R := stdlv(14 downto 8);
      output.reserved0 := stdlv(7);
      output.DG_FACTOR_B := stdlv(6 downto 0);
      return output;
   end to_ACQ_SENSOR_GAIN_DIG_RB_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_DEBUG_PINS_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_DEBUG_PINS_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(28 downto 24) := reg.Debug3_sel;
      output(20 downto 16) := reg.Debug2_sel;
      output(12 downto 8) := reg.Debug1_sel;
      output(4 downto 0) := reg.Debug0_sel;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_DEBUG_PINS_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_DEBUG_PINS_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_DEBUG_PINS_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_DEBUG_PINS_TYPE is
   variable output : ACQ_DEBUG_PINS_TYPE;
   begin
      output.Debug3_sel := stdlv(28 downto 24);
      output.Debug2_sel := stdlv(20 downto 16);
      output.Debug1_sel := stdlv(12 downto 8);
      output.Debug0_sel := stdlv(4 downto 0);
      return output;
   end to_ACQ_DEBUG_PINS_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_TRIGGER_MISSED_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_TRIGGER_MISSED_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(28) := reg.TRIGGER_MISSED_RST;
      output(15 downto 0) := reg.TRIGGER_MISSED_CNTR;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_TRIGGER_MISSED_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_TRIGGER_MISSED_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_TRIGGER_MISSED_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_TRIGGER_MISSED_TYPE is
   variable output : ACQ_TRIGGER_MISSED_TYPE;
   begin
      output.TRIGGER_MISSED_RST := stdlv(28);
      output.TRIGGER_MISSED_CNTR := stdlv(15 downto 0);
      return output;
   end to_ACQ_TRIGGER_MISSED_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_SENSOR_FPS_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_SENSOR_FPS_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(15 downto 0) := reg.SENSOR_FPS;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_SENSOR_FPS_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_SENSOR_FPS_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_SENSOR_FPS_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_FPS_TYPE is
   variable output : ACQ_SENSOR_FPS_TYPE;
   begin
      output.SENSOR_FPS := stdlv(15 downto 0);
      return output;
   end to_ACQ_SENSOR_FPS_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_SENSOR_FPS2_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_SENSOR_FPS2_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(19 downto 0) := reg.SENSOR_FPS;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_SENSOR_FPS2_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_SENSOR_FPS2_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_SENSOR_FPS2_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_FPS2_TYPE is
   variable output : ACQ_SENSOR_FPS2_TYPE;
   begin
      output.SENSOR_FPS := stdlv(19 downto 0);
      return output;
   end to_ACQ_SENSOR_FPS2_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_DEBUG_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_DEBUG_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(28) := reg.DEBUG_RST_CNTR;
      output(2 downto 1) := reg.LED_TEST_COLOR;
      output(0) := reg.LED_TEST;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_DEBUG_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_DEBUG_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_DEBUG_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_DEBUG_TYPE is
   variable output : ACQ_DEBUG_TYPE;
   begin
      output.DEBUG_RST_CNTR := stdlv(28);
      output.LED_TEST_COLOR := stdlv(2 downto 1);
      output.LED_TEST := stdlv(0);
      return output;
   end to_ACQ_DEBUG_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_DEBUG_CNTR1_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_DEBUG_CNTR1_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(27 downto 0) := reg.SENSOR_FRAME_DURATION;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_DEBUG_CNTR1_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_DEBUG_CNTR1_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_DEBUG_CNTR1_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_DEBUG_CNTR1_TYPE is
   variable output : ACQ_DEBUG_CNTR1_TYPE;
   begin
      output.SENSOR_FRAME_DURATION := stdlv(27 downto 0);
      return output;
   end to_ACQ_DEBUG_CNTR1_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_DEBUG_CNTR2_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_DEBUG_CNTR2_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.EOF_CNTR;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_DEBUG_CNTR2_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_DEBUG_CNTR2_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_DEBUG_CNTR2_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_DEBUG_CNTR2_TYPE is
   variable output : ACQ_DEBUG_CNTR2_TYPE;
   begin
      output.EOF_CNTR := stdlv(31 downto 0);
      return output;
   end to_ACQ_DEBUG_CNTR2_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_DEBUG_CNTR3_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_DEBUG_CNTR3_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.TRIG_INT_CNTR;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_DEBUG_CNTR3_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_DEBUG_CNTR3_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_DEBUG_CNTR3_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_DEBUG_CNTR3_TYPE is
   variable output : ACQ_DEBUG_CNTR3_TYPE;
   begin
      output.TRIG_INT_CNTR := stdlv(31 downto 0);
      return output;
   end to_ACQ_DEBUG_CNTR3_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_EXP_FOT_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_EXP_FOT_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(16) := reg.EXP_FOT;
      output(15 downto 0) := reg.EXP_FOT_TIME;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_EXP_FOT_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_EXP_FOT_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_EXP_FOT_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_EXP_FOT_TYPE is
   variable output : ACQ_EXP_FOT_TYPE;
   begin
      output.EXP_FOT := stdlv(16);
      output.EXP_FOT_TIME := stdlv(15 downto 0);
      return output;
   end to_ACQ_EXP_FOT_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_ACQ_SFNC_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_ACQ_SFNC_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(0) := reg.RELOAD_GRAB_PARAMS;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_ACQ_SFNC_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_ACQ_SFNC_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_ACQ_SFNC_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_ACQ_SFNC_TYPE is
   variable output : ACQ_ACQ_SFNC_TYPE;
   begin
      output.RELOAD_GRAB_PARAMS := stdlv(0);
      return output;
   end to_ACQ_ACQ_SFNC_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_TIMER_CTRL_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_TIMER_CTRL_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(8) := reg.ADAPTATIVE;
      output(4) := reg.TIMERSTOP;
      output(0) := reg.TIMERSTART;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_TIMER_CTRL_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_TIMER_CTRL_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_TIMER_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_TIMER_CTRL_TYPE is
   variable output : ACQ_TIMER_CTRL_TYPE;
   begin
      output.ADAPTATIVE := stdlv(8);
      output.TIMERSTOP := stdlv(4);
      output.TIMERSTART := stdlv(0);
      return output;
   end to_ACQ_TIMER_CTRL_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_TIMER_DELAY_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_TIMER_DELAY_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.VALUE;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_TIMER_DELAY_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_TIMER_DELAY_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_TIMER_DELAY_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_TIMER_DELAY_TYPE is
   variable output : ACQ_TIMER_DELAY_TYPE;
   begin
      output.VALUE := stdlv(31 downto 0);
      return output;
   end to_ACQ_TIMER_DELAY_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_TIMER_DURATION_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_TIMER_DURATION_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.VALUE;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_TIMER_DURATION_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_TIMER_DURATION_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_TIMER_DURATION_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_TIMER_DURATION_TYPE is
   variable output : ACQ_TIMER_DURATION_TYPE;
   begin
      output.VALUE := stdlv(31 downto 0);
      return output;
   end to_ACQ_TIMER_DURATION_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from HISPI_CTRL_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : HISPI_CTRL_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(4) := reg.SW_CLR_IDELAYCTRL;
      output(3) := reg.SW_CLR_HISPI;
      output(2) := reg.SW_CALIB_SERDES;
      output(1) := reg.ENABLE_DATA_PATH;
      output(0) := reg.ENABLE_HISPI;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_HISPI_CTRL_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to HISPI_CTRL_TYPE
   --------------------------------------------------------------------------------
   function to_HISPI_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return HISPI_CTRL_TYPE is
   variable output : HISPI_CTRL_TYPE;
   begin
      output.SW_CLR_IDELAYCTRL := stdlv(4);
      output.SW_CLR_HISPI := stdlv(3);
      output.SW_CALIB_SERDES := stdlv(2);
      output.ENABLE_DATA_PATH := stdlv(1);
      output.ENABLE_HISPI := stdlv(0);
      return output;
   end to_HISPI_CTRL_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from HISPI_STATUS_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : HISPI_STATUS_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 28) := reg.FSM;
      output(4) := reg.CRC_ERROR;
      output(3) := reg.PHY_BIT_LOCKED_ERROR;
      output(2) := reg.FIFO_ERROR;
      output(1) := reg.CALIBRATION_ERROR;
      output(0) := reg.CALIBRATION_DONE;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_HISPI_STATUS_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to HISPI_STATUS_TYPE
   --------------------------------------------------------------------------------
   function to_HISPI_STATUS_TYPE(stdlv : std_logic_vector(31 downto 0)) return HISPI_STATUS_TYPE is
   variable output : HISPI_STATUS_TYPE;
   begin
      output.FSM := stdlv(31 downto 28);
      output.CRC_ERROR := stdlv(4);
      output.PHY_BIT_LOCKED_ERROR := stdlv(3);
      output.FIFO_ERROR := stdlv(2);
      output.CALIBRATION_ERROR := stdlv(1);
      output.CALIBRATION_DONE := stdlv(0);
      return output;
   end to_HISPI_STATUS_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from HISPI_IDELAYCTRL_STATUS_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : HISPI_IDELAYCTRL_STATUS_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(0) := reg.PLL_LOCKED;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_HISPI_IDELAYCTRL_STATUS_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to HISPI_IDELAYCTRL_STATUS_TYPE
   --------------------------------------------------------------------------------
   function to_HISPI_IDELAYCTRL_STATUS_TYPE(stdlv : std_logic_vector(31 downto 0)) return HISPI_IDELAYCTRL_STATUS_TYPE is
   variable output : HISPI_IDELAYCTRL_STATUS_TYPE;
   begin
      output.PLL_LOCKED := stdlv(0);
      return output;
   end to_HISPI_IDELAYCTRL_STATUS_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from HISPI_IDLE_CHARACTER_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : HISPI_IDLE_CHARACTER_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(11 downto 0) := reg.VALUE;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_HISPI_IDLE_CHARACTER_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to HISPI_IDLE_CHARACTER_TYPE
   --------------------------------------------------------------------------------
   function to_HISPI_IDLE_CHARACTER_TYPE(stdlv : std_logic_vector(31 downto 0)) return HISPI_IDLE_CHARACTER_TYPE is
   variable output : HISPI_IDLE_CHARACTER_TYPE;
   begin
      output.VALUE := stdlv(11 downto 0);
      return output;
   end to_HISPI_IDLE_CHARACTER_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from HISPI_PHY_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : HISPI_PHY_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(25 downto 16) := reg.PIXEL_PER_LANE;
      output(10 downto 8) := reg.MUX_RATIO;
      output(2 downto 0) := reg.NB_LANES;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_HISPI_PHY_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to HISPI_PHY_TYPE
   --------------------------------------------------------------------------------
   function to_HISPI_PHY_TYPE(stdlv : std_logic_vector(31 downto 0)) return HISPI_PHY_TYPE is
   variable output : HISPI_PHY_TYPE;
   begin
      output.PIXEL_PER_LANE := stdlv(25 downto 16);
      output.MUX_RATIO := stdlv(10 downto 8);
      output.NB_LANES := stdlv(2 downto 0);
      return output;
   end to_HISPI_PHY_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from HISPI_FRAME_CFG_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : HISPI_FRAME_CFG_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(27 downto 16) := reg.LINES_PER_FRAME;
      output(12 downto 0) := reg.PIXELS_PER_LINE;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_HISPI_FRAME_CFG_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to HISPI_FRAME_CFG_TYPE
   --------------------------------------------------------------------------------
   function to_HISPI_FRAME_CFG_TYPE(stdlv : std_logic_vector(31 downto 0)) return HISPI_FRAME_CFG_TYPE is
   variable output : HISPI_FRAME_CFG_TYPE;
   begin
      output.LINES_PER_FRAME := stdlv(27 downto 16);
      output.PIXELS_PER_LINE := stdlv(12 downto 0);
      return output;
   end to_HISPI_FRAME_CFG_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from HISPI_FRAME_CFG_X_VALID_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : HISPI_FRAME_CFG_X_VALID_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(28 downto 16) := reg.X_END;
      output(12 downto 0) := reg.X_START;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_HISPI_FRAME_CFG_X_VALID_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to HISPI_FRAME_CFG_X_VALID_TYPE
   --------------------------------------------------------------------------------
   function to_HISPI_FRAME_CFG_X_VALID_TYPE(stdlv : std_logic_vector(31 downto 0)) return HISPI_FRAME_CFG_X_VALID_TYPE is
   variable output : HISPI_FRAME_CFG_X_VALID_TYPE;
   begin
      output.X_END := stdlv(28 downto 16);
      output.X_START := stdlv(12 downto 0);
      return output;
   end to_HISPI_FRAME_CFG_X_VALID_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from HISPI_LANE_DECODER_STATUS_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : HISPI_LANE_DECODER_STATUS_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(15) := reg.CRC_ERROR;
      output(14) := reg.PHY_SYNC_ERROR;
      output(13) := reg.PHY_BIT_LOCKED_ERROR;
      output(12) := reg.PHY_BIT_LOCKED;
      output(8 downto 4) := reg.CALIBRATION_TAP_VALUE;
      output(3) := reg.CALIBRATION_ERROR;
      output(2) := reg.CALIBRATION_DONE;
      output(1) := reg.FIFO_UNDERRUN;
      output(0) := reg.FIFO_OVERRUN;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_HISPI_LANE_DECODER_STATUS_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to HISPI_LANE_DECODER_STATUS_TYPE
   --------------------------------------------------------------------------------
   function to_HISPI_LANE_DECODER_STATUS_TYPE(stdlv : std_logic_vector(31 downto 0)) return HISPI_LANE_DECODER_STATUS_TYPE is
   variable output : HISPI_LANE_DECODER_STATUS_TYPE;
   begin
      output.CRC_ERROR := stdlv(15);
      output.PHY_SYNC_ERROR := stdlv(14);
      output.PHY_BIT_LOCKED_ERROR := stdlv(13);
      output.PHY_BIT_LOCKED := stdlv(12);
      output.CALIBRATION_TAP_VALUE := stdlv(8 downto 4);
      output.CALIBRATION_ERROR := stdlv(3);
      output.CALIBRATION_DONE := stdlv(2);
      output.FIFO_UNDERRUN := stdlv(1);
      output.FIFO_OVERRUN := stdlv(0);
      return output;
   end to_HISPI_LANE_DECODER_STATUS_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from HISPI_TAP_HISTOGRAM_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : HISPI_TAP_HISTOGRAM_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.VALUE;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_HISPI_TAP_HISTOGRAM_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to HISPI_TAP_HISTOGRAM_TYPE
   --------------------------------------------------------------------------------
   function to_HISPI_TAP_HISTOGRAM_TYPE(stdlv : std_logic_vector(31 downto 0)) return HISPI_TAP_HISTOGRAM_TYPE is
   variable output : HISPI_TAP_HISTOGRAM_TYPE;
   begin
      output.VALUE := stdlv(31 downto 0);
      return output;
   end to_HISPI_TAP_HISTOGRAM_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from HISPI_DEBUG_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : HISPI_DEBUG_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31) := reg.MANUAL_CALIB_EN;
      output(30) := reg.LOAD_TAPS;
      output(29 downto 25) := reg.TAP_LANE_5;
      output(24 downto 20) := reg.TAP_LANE_4;
      output(19 downto 15) := reg.TAP_LANE_3;
      output(14 downto 10) := reg.TAP_LANE_2;
      output(9 downto 5) := reg.TAP_LANE_1;
      output(4 downto 0) := reg.TAP_LANE_0;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_HISPI_DEBUG_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to HISPI_DEBUG_TYPE
   --------------------------------------------------------------------------------
   function to_HISPI_DEBUG_TYPE(stdlv : std_logic_vector(31 downto 0)) return HISPI_DEBUG_TYPE is
   variable output : HISPI_DEBUG_TYPE;
   begin
      output.MANUAL_CALIB_EN := stdlv(31);
      output.LOAD_TAPS := stdlv(30);
      output.TAP_LANE_5 := stdlv(29 downto 25);
      output.TAP_LANE_4 := stdlv(24 downto 20);
      output.TAP_LANE_3 := stdlv(19 downto 15);
      output.TAP_LANE_2 := stdlv(14 downto 10);
      output.TAP_LANE_1 := stdlv(9 downto 5);
      output.TAP_LANE_0 := stdlv(4 downto 0);
      return output;
   end to_HISPI_DEBUG_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DPC_DPC_CAPABILITIES_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DPC_DPC_CAPABILITIES_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(27 downto 16) := reg.DPC_LIST_LENGTH;
      output(3 downto 0) := reg.DPC_VER;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DPC_DPC_CAPABILITIES_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DPC_DPC_CAPABILITIES_TYPE
   --------------------------------------------------------------------------------
   function to_DPC_DPC_CAPABILITIES_TYPE(stdlv : std_logic_vector(31 downto 0)) return DPC_DPC_CAPABILITIES_TYPE is
   variable output : DPC_DPC_CAPABILITIES_TYPE;
   begin
      output.DPC_LIST_LENGTH := stdlv(27 downto 16);
      output.DPC_VER := stdlv(3 downto 0);
      return output;
   end to_DPC_DPC_CAPABILITIES_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DPC_DPC_LIST_CTRL_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DPC_DPC_LIST_CTRL_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31) := reg.dpc_highlight_all;
      output(29) := reg.dpc_fifo_reset;
      output(28) := reg.dpc_firstlast_line_rem;
      output(27 downto 16) := reg.dpc_list_count;
      output(15) := reg.dpc_pattern0_cfg;
      output(14) := reg.dpc_enable;
      output(13) := reg.dpc_list_WRn;
      output(12) := reg.dpc_list_ss;
      output(11 downto 0) := reg.dpc_list_add;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DPC_DPC_LIST_CTRL_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DPC_DPC_LIST_CTRL_TYPE
   --------------------------------------------------------------------------------
   function to_DPC_DPC_LIST_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return DPC_DPC_LIST_CTRL_TYPE is
   variable output : DPC_DPC_LIST_CTRL_TYPE;
   begin
      output.dpc_highlight_all := stdlv(31);
      output.dpc_fifo_reset := stdlv(29);
      output.dpc_firstlast_line_rem := stdlv(28);
      output.dpc_list_count := stdlv(27 downto 16);
      output.dpc_pattern0_cfg := stdlv(15);
      output.dpc_enable := stdlv(14);
      output.dpc_list_WRn := stdlv(13);
      output.dpc_list_ss := stdlv(12);
      output.dpc_list_add := stdlv(11 downto 0);
      return output;
   end to_DPC_DPC_LIST_CTRL_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DPC_DPC_LIST_STAT_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DPC_DPC_LIST_STAT_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31) := reg.dpc_fifo_underrun;
      output(30) := reg.dpc_fifo_overrun;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DPC_DPC_LIST_STAT_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DPC_DPC_LIST_STAT_TYPE
   --------------------------------------------------------------------------------
   function to_DPC_DPC_LIST_STAT_TYPE(stdlv : std_logic_vector(31 downto 0)) return DPC_DPC_LIST_STAT_TYPE is
   variable output : DPC_DPC_LIST_STAT_TYPE;
   begin
      output.dpc_fifo_underrun := stdlv(31);
      output.dpc_fifo_overrun := stdlv(30);
      return output;
   end to_DPC_DPC_LIST_STAT_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DPC_DPC_LIST_DATA1_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DPC_DPC_LIST_DATA1_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(27 downto 16) := reg.dpc_list_corr_y;
      output(12 downto 0) := reg.dpc_list_corr_x;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DPC_DPC_LIST_DATA1_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DPC_DPC_LIST_DATA1_TYPE
   --------------------------------------------------------------------------------
   function to_DPC_DPC_LIST_DATA1_TYPE(stdlv : std_logic_vector(31 downto 0)) return DPC_DPC_LIST_DATA1_TYPE is
   variable output : DPC_DPC_LIST_DATA1_TYPE;
   begin
      output.dpc_list_corr_y := stdlv(27 downto 16);
      output.dpc_list_corr_x := stdlv(12 downto 0);
      return output;
   end to_DPC_DPC_LIST_DATA1_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DPC_DPC_LIST_DATA2_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DPC_DPC_LIST_DATA2_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(7 downto 0) := reg.dpc_list_corr_pattern;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DPC_DPC_LIST_DATA2_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DPC_DPC_LIST_DATA2_TYPE
   --------------------------------------------------------------------------------
   function to_DPC_DPC_LIST_DATA2_TYPE(stdlv : std_logic_vector(31 downto 0)) return DPC_DPC_LIST_DATA2_TYPE is
   variable output : DPC_DPC_LIST_DATA2_TYPE;
   begin
      output.dpc_list_corr_pattern := stdlv(7 downto 0);
      return output;
   end to_DPC_DPC_LIST_DATA2_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DPC_DPC_LIST_DATA1_RD_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DPC_DPC_LIST_DATA1_RD_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(27 downto 16) := reg.dpc_list_corr_y;
      output(12 downto 0) := reg.dpc_list_corr_x;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DPC_DPC_LIST_DATA1_RD_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DPC_DPC_LIST_DATA1_RD_TYPE
   --------------------------------------------------------------------------------
   function to_DPC_DPC_LIST_DATA1_RD_TYPE(stdlv : std_logic_vector(31 downto 0)) return DPC_DPC_LIST_DATA1_RD_TYPE is
   variable output : DPC_DPC_LIST_DATA1_RD_TYPE;
   begin
      output.dpc_list_corr_y := stdlv(27 downto 16);
      output.dpc_list_corr_x := stdlv(12 downto 0);
      return output;
   end to_DPC_DPC_LIST_DATA1_RD_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DPC_DPC_LIST_DATA2_RD_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DPC_DPC_LIST_DATA2_RD_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(7 downto 0) := reg.dpc_list_corr_pattern;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DPC_DPC_LIST_DATA2_RD_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DPC_DPC_LIST_DATA2_RD_TYPE
   --------------------------------------------------------------------------------
   function to_DPC_DPC_LIST_DATA2_RD_TYPE(stdlv : std_logic_vector(31 downto 0)) return DPC_DPC_LIST_DATA2_RD_TYPE is
   variable output : DPC_DPC_LIST_DATA2_RD_TYPE;
   begin
      output.dpc_list_corr_pattern := stdlv(7 downto 0);
      return output;
   end to_DPC_DPC_LIST_DATA2_RD_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from LUT_LUT_CAPABILITIES_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : LUT_LUT_CAPABILITIES_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(27 downto 16) := reg.LUT_SIZE_CONFIG;
      output(3 downto 0) := reg.LUT_VER;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_LUT_LUT_CAPABILITIES_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to LUT_LUT_CAPABILITIES_TYPE
   --------------------------------------------------------------------------------
   function to_LUT_LUT_CAPABILITIES_TYPE(stdlv : std_logic_vector(31 downto 0)) return LUT_LUT_CAPABILITIES_TYPE is
   variable output : LUT_LUT_CAPABILITIES_TYPE;
   begin
      output.LUT_SIZE_CONFIG := stdlv(27 downto 16);
      output.LUT_VER := stdlv(3 downto 0);
      return output;
   end to_LUT_LUT_CAPABILITIES_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from LUT_LUT_CTRL_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : LUT_LUT_CTRL_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(29) := reg.LUT_BYPASS_COLOR;
      output(28) := reg.LUT_BYPASS;
      output(25 downto 16) := reg.LUT_DATA_W;
      output(15 downto 12) := reg.LUT_SEL;
      output(11) := reg.LUT_WRN;
      output(10) := reg.LUT_SS;
      output(9 downto 0) := reg.LUT_ADD;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_LUT_LUT_CTRL_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to LUT_LUT_CTRL_TYPE
   --------------------------------------------------------------------------------
   function to_LUT_LUT_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return LUT_LUT_CTRL_TYPE is
   variable output : LUT_LUT_CTRL_TYPE;
   begin
      output.LUT_BYPASS_COLOR := stdlv(29);
      output.LUT_BYPASS := stdlv(28);
      output.LUT_DATA_W := stdlv(25 downto 16);
      output.LUT_SEL := stdlv(15 downto 12);
      output.LUT_WRN := stdlv(11);
      output.LUT_SS := stdlv(10);
      output.LUT_ADD := stdlv(9 downto 0);
      return output;
   end to_LUT_LUT_CTRL_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from LUT_LUT_RB_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : LUT_LUT_RB_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(7 downto 0) := reg.LUT_RB;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_LUT_LUT_RB_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to LUT_LUT_RB_TYPE
   --------------------------------------------------------------------------------
   function to_LUT_LUT_RB_TYPE(stdlv : std_logic_vector(31 downto 0)) return LUT_LUT_RB_TYPE is
   variable output : LUT_LUT_RB_TYPE;
   begin
      output.LUT_RB := stdlv(7 downto 0);
      return output;
   end to_LUT_LUT_RB_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from BAYER_BAYER_CAPABILITIES_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : BAYER_BAYER_CAPABILITIES_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(1 downto 0) := reg.BAYER_VER;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_BAYER_BAYER_CAPABILITIES_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to BAYER_BAYER_CAPABILITIES_TYPE
   --------------------------------------------------------------------------------
   function to_BAYER_BAYER_CAPABILITIES_TYPE(stdlv : std_logic_vector(31 downto 0)) return BAYER_BAYER_CAPABILITIES_TYPE is
   variable output : BAYER_BAYER_CAPABILITIES_TYPE;
   begin
      output.BAYER_VER := stdlv(1 downto 0);
      return output;
   end to_BAYER_BAYER_CAPABILITIES_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from BAYER_WB_MUL1_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : BAYER_WB_MUL1_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 16) := reg.WB_MULT_G;
      output(15 downto 0) := reg.WB_MULT_B;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_BAYER_WB_MUL1_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to BAYER_WB_MUL1_TYPE
   --------------------------------------------------------------------------------
   function to_BAYER_WB_MUL1_TYPE(stdlv : std_logic_vector(31 downto 0)) return BAYER_WB_MUL1_TYPE is
   variable output : BAYER_WB_MUL1_TYPE;
   begin
      output.WB_MULT_G := stdlv(31 downto 16);
      output.WB_MULT_B := stdlv(15 downto 0);
      return output;
   end to_BAYER_WB_MUL1_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from BAYER_WB_MUL2_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : BAYER_WB_MUL2_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(15 downto 0) := reg.WB_MULT_R;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_BAYER_WB_MUL2_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to BAYER_WB_MUL2_TYPE
   --------------------------------------------------------------------------------
   function to_BAYER_WB_MUL2_TYPE(stdlv : std_logic_vector(31 downto 0)) return BAYER_WB_MUL2_TYPE is
   variable output : BAYER_WB_MUL2_TYPE;
   begin
      output.WB_MULT_R := stdlv(15 downto 0);
      return output;
   end to_BAYER_WB_MUL2_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from BAYER_WB_B_ACC_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : BAYER_WB_B_ACC_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(30 downto 0) := reg.B_ACC;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_BAYER_WB_B_ACC_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to BAYER_WB_B_ACC_TYPE
   --------------------------------------------------------------------------------
   function to_BAYER_WB_B_ACC_TYPE(stdlv : std_logic_vector(31 downto 0)) return BAYER_WB_B_ACC_TYPE is
   variable output : BAYER_WB_B_ACC_TYPE;
   begin
      output.B_ACC := stdlv(30 downto 0);
      return output;
   end to_BAYER_WB_B_ACC_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from BAYER_WB_G_ACC_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : BAYER_WB_G_ACC_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.G_ACC;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_BAYER_WB_G_ACC_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to BAYER_WB_G_ACC_TYPE
   --------------------------------------------------------------------------------
   function to_BAYER_WB_G_ACC_TYPE(stdlv : std_logic_vector(31 downto 0)) return BAYER_WB_G_ACC_TYPE is
   variable output : BAYER_WB_G_ACC_TYPE;
   begin
      output.G_ACC := stdlv(31 downto 0);
      return output;
   end to_BAYER_WB_G_ACC_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from BAYER_WB_R_ACC_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : BAYER_WB_R_ACC_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(30 downto 0) := reg.R_ACC;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_BAYER_WB_R_ACC_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to BAYER_WB_R_ACC_TYPE
   --------------------------------------------------------------------------------
   function to_BAYER_WB_R_ACC_TYPE(stdlv : std_logic_vector(31 downto 0)) return BAYER_WB_R_ACC_TYPE is
   variable output : BAYER_WB_R_ACC_TYPE;
   begin
      output.R_ACC := stdlv(30 downto 0);
      return output;
   end to_BAYER_WB_R_ACC_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from BAYER_CCM_CTRL_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : BAYER_CCM_CTRL_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(0) := reg.CCM_EN;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_BAYER_CCM_CTRL_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to BAYER_CCM_CTRL_TYPE
   --------------------------------------------------------------------------------
   function to_BAYER_CCM_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return BAYER_CCM_CTRL_TYPE is
   variable output : BAYER_CCM_CTRL_TYPE;
   begin
      output.CCM_EN := stdlv(0);
      return output;
   end to_BAYER_CCM_CTRL_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from BAYER_CCM_KR1_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : BAYER_CCM_KR1_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(27 downto 16) := reg.Kg;
      output(11 downto 0) := reg.Kr;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_BAYER_CCM_KR1_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to BAYER_CCM_KR1_TYPE
   --------------------------------------------------------------------------------
   function to_BAYER_CCM_KR1_TYPE(stdlv : std_logic_vector(31 downto 0)) return BAYER_CCM_KR1_TYPE is
   variable output : BAYER_CCM_KR1_TYPE;
   begin
      output.Kg := stdlv(27 downto 16);
      output.Kr := stdlv(11 downto 0);
      return output;
   end to_BAYER_CCM_KR1_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from BAYER_CCM_KR2_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : BAYER_CCM_KR2_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(24 downto 16) := reg.KOff;
      output(11 downto 0) := reg.Kb;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_BAYER_CCM_KR2_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to BAYER_CCM_KR2_TYPE
   --------------------------------------------------------------------------------
   function to_BAYER_CCM_KR2_TYPE(stdlv : std_logic_vector(31 downto 0)) return BAYER_CCM_KR2_TYPE is
   variable output : BAYER_CCM_KR2_TYPE;
   begin
      output.KOff := stdlv(24 downto 16);
      output.Kb := stdlv(11 downto 0);
      return output;
   end to_BAYER_CCM_KR2_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from BAYER_CCM_KG1_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : BAYER_CCM_KG1_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(27 downto 16) := reg.Kg;
      output(11 downto 0) := reg.Kr;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_BAYER_CCM_KG1_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to BAYER_CCM_KG1_TYPE
   --------------------------------------------------------------------------------
   function to_BAYER_CCM_KG1_TYPE(stdlv : std_logic_vector(31 downto 0)) return BAYER_CCM_KG1_TYPE is
   variable output : BAYER_CCM_KG1_TYPE;
   begin
      output.Kg := stdlv(27 downto 16);
      output.Kr := stdlv(11 downto 0);
      return output;
   end to_BAYER_CCM_KG1_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from BAYER_CCM_KG2_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : BAYER_CCM_KG2_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(24 downto 16) := reg.KOff;
      output(11 downto 0) := reg.Kb;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_BAYER_CCM_KG2_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to BAYER_CCM_KG2_TYPE
   --------------------------------------------------------------------------------
   function to_BAYER_CCM_KG2_TYPE(stdlv : std_logic_vector(31 downto 0)) return BAYER_CCM_KG2_TYPE is
   variable output : BAYER_CCM_KG2_TYPE;
   begin
      output.KOff := stdlv(24 downto 16);
      output.Kb := stdlv(11 downto 0);
      return output;
   end to_BAYER_CCM_KG2_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from BAYER_CCM_KB1_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : BAYER_CCM_KB1_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(27 downto 16) := reg.Kg;
      output(11 downto 0) := reg.Kr;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_BAYER_CCM_KB1_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to BAYER_CCM_KB1_TYPE
   --------------------------------------------------------------------------------
   function to_BAYER_CCM_KB1_TYPE(stdlv : std_logic_vector(31 downto 0)) return BAYER_CCM_KB1_TYPE is
   variable output : BAYER_CCM_KB1_TYPE;
   begin
      output.Kg := stdlv(27 downto 16);
      output.Kr := stdlv(11 downto 0);
      return output;
   end to_BAYER_CCM_KB1_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from BAYER_CCM_KB2_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : BAYER_CCM_KB2_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(24 downto 16) := reg.KOff;
      output(11 downto 0) := reg.Kb;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_BAYER_CCM_KB2_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to BAYER_CCM_KB2_TYPE
   --------------------------------------------------------------------------------
   function to_BAYER_CCM_KB2_TYPE(stdlv : std_logic_vector(31 downto 0)) return BAYER_CCM_KB2_TYPE is
   variable output : BAYER_CCM_KB2_TYPE;
   begin
      output.KOff := stdlv(24 downto 16);
      output.Kb := stdlv(11 downto 0);
      return output;
   end to_BAYER_CCM_KB2_TYPE;

   
end package body;


-------------------------------------------------------------------------------
-- File                : regfile_xgs_athena.vhd
-- Project             : FDK
-- Module              : regfile_xgs_athena
-- Created on          : 2021/12/13 11:39:54
-- Created by          : jmansill
-- FDK IDE Version     : 4.7.0_beta3
-- Build ID            : I20191219-1127
-- Register file CRC32 : 0x4F0D5164
-------------------------------------------------------------------------------
-- The standard IEEE library
library ieee;
   use ieee.std_logic_1164.all; 
   use ieee.numeric_std.all;    
   use ieee.std_logic_unsigned.all;

-- Work library
library work;
   use work.regfile_xgs_athena_pack.all;


entity regfile_xgs_athena is
   
   port (
      resetN                      : in    std_logic;                                               -- System reset
      sysclk                      : in    std_logic;                                               -- System clock
      regfile                     : inout REGFILE_XGS_ATHENA_TYPE := INIT_REGFILE_XGS_ATHENA_TYPE; -- Register file
      ------------------------------------------------------------------------------------
      -- Interface name: registerFileIF
      -- Description: 
      ------------------------------------------------------------------------------------
      reg_wait                    : out   std_logic;                                               -- Wait
      reg_read                    : in    std_logic;                                               -- Read
      reg_write                   : in    std_logic;                                               -- Write
      reg_addr                    : in    std_logic_vector(10 downto 2);                           -- Address
      reg_beN                     : in    std_logic_vector(3 downto 0);                            -- Byte enable
      reg_writedata               : in    std_logic_vector(31 downto 0);                           -- Write data
      reg_readdatavalid           : out   std_logic;                                               -- Read data valid
      reg_readdata                : out   std_logic_vector(31 downto 0);                           -- Read data
      ------------------------------------------------------------------------------------
      -- Interface name: SYSMONXIL
      -- Description: 
      ------------------------------------------------------------------------------------
      ext_SYSMONXIL_addr          : out   std_logic_vector(5 downto 0);                            -- Address Bus for SYSMONXIL external section
      ext_SYSMONXIL_readEn        : out   std_logic;                                               -- Read enable for SYSMONXIL external section
      ext_SYSMONXIL_readDataValid : in    std_logic;                                               -- Read Data Valid for SYSMONXIL external section
      ext_SYSMONXIL_readData      : in    std_logic_vector(31 downto 0)                            -- Read Data for the SYSMONXIL external section
   );
   
end regfile_xgs_athena;

architecture rtl of regfile_xgs_athena is
------------------------------------------------------------------------------------------
-- Signals declaration
------------------------------------------------------------------------------------------
signal readBackMux                                                 : std_logic_vector(31 downto 0);                   -- Data readback multiplexer
signal hit                                                         : std_logic_vector(103 downto 0);                  -- Address decode hit
signal wEn                                                         : std_logic_vector(102 downto 0);                  -- Write Enable
signal fullAddr                                                    : std_logic_vector(11 downto 0):= (others => '0'); -- Full Address
signal fullAddrAsInt                                               : integer;                                        
signal bitEnN                                                      : std_logic_vector(31 downto 0);                   -- Bits enable
signal ldData                                                      : std_logic;                                      
signal rb_SYSTEM_TAG                                               : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_SYSTEM_VERSION                                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_SYSTEM_CAPABILITY                                        : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_SYSTEM_SCRATCHPAD                                        : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DMA_CTRL                                                 : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DMA_FSTART                                               : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DMA_FSTART_HIGH                                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DMA_FSTART_G                                             : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DMA_FSTART_G_HIGH                                        : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DMA_FSTART_R                                             : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DMA_FSTART_R_HIGH                                        : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DMA_LINE_PITCH                                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DMA_LINE_SIZE                                            : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DMA_CSC                                                  : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DMA_OUTPUT_BUFFER                                        : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DMA_TLP                                                  : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DMA_ROI_X                                                : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DMA_ROI_Y                                                : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_GRAB_CTRL                                            : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_GRAB_STAT                                            : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_READOUT_CFG1                                         : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_READOUT_CFG_FRAME_LINE                               : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_READOUT_CFG2                                         : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_READOUT_CFG3                                         : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_READOUT_CFG4                                         : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_EXP_CTRL1                                            : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_EXP_CTRL2                                            : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_EXP_CTRL3                                            : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_TRIGGER_DELAY                                        : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_STROBE_CTRL1                                         : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_STROBE_CTRL2                                         : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_ACQ_SER_CTRL                                         : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_ACQ_SER_ADDATA                                       : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_ACQ_SER_STAT                                         : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_CTRL                                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_STAT                                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_SUBSAMPLING                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_GAIN_ANA                                      : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_ROI_Y_START                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_ROI_Y_SIZE                                    : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_M_LINES                                       : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_DP_GR                                         : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_DP_GB                                         : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_DP_R                                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_DP_B                                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_GAIN_DIG_G                                    : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_GAIN_DIG_RB                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_DEBUG_PINS                                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_TRIGGER_MISSED                                       : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_FPS                                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_FPS2                                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_DEBUG                                                : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_DEBUG_CNTR1                                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_DEBUG_CNTR2                                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_DEBUG_CNTR3                                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_EXP_FOT                                              : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_ACQ_SFNC                                             : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_TIMER_CTRL                                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_TIMER_DELAY                                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_TIMER_DURATION                                       : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_HISPI_CTRL                                               : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_HISPI_STATUS                                             : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_HISPI_IDELAYCTRL_STATUS                                  : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_HISPI_IDLE_CHARACTER                                     : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_HISPI_PHY                                                : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_HISPI_FRAME_CFG                                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_HISPI_FRAME_CFG_X_VALID                                  : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_HISPI_LANE_DECODER_STATUS_0                              : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_HISPI_LANE_DECODER_STATUS_1                              : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_HISPI_LANE_DECODER_STATUS_2                              : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_HISPI_LANE_DECODER_STATUS_3                              : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_HISPI_LANE_DECODER_STATUS_4                              : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_HISPI_LANE_DECODER_STATUS_5                              : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_HISPI_TAP_HISTOGRAM_0                                    : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_HISPI_TAP_HISTOGRAM_1                                    : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_HISPI_TAP_HISTOGRAM_2                                    : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_HISPI_TAP_HISTOGRAM_3                                    : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_HISPI_TAP_HISTOGRAM_4                                    : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_HISPI_TAP_HISTOGRAM_5                                    : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_HISPI_DEBUG                                              : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DPC_DPC_CAPABILITIES                                     : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DPC_DPC_LIST_CTRL                                        : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DPC_DPC_LIST_STAT                                        : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DPC_DPC_LIST_DATA1                                       : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DPC_DPC_LIST_DATA2                                       : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DPC_DPC_LIST_DATA1_RD                                    : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DPC_DPC_LIST_DATA2_RD                                    : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_LUT_LUT_CAPABILITIES                                     : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_LUT_LUT_CTRL                                             : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_LUT_LUT_RB                                               : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_BAYER_BAYER_CAPABILITIES                                 : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_BAYER_WB_MUL1                                            : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_BAYER_WB_MUL2                                            : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_BAYER_WB_B_ACC                                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_BAYER_WB_G_ACC                                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_BAYER_WB_R_ACC                                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_BAYER_CCM_CTRL                                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_BAYER_CCM_KR1                                            : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_BAYER_CCM_KR2                                            : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_BAYER_CCM_KG1                                            : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_BAYER_CCM_KG2                                            : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_BAYER_CCM_KB1                                            : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_BAYER_CCM_KB2                                            : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal field_rw_SYSTEM_SCRATCHPAD_VALUE                            : std_logic_vector(31 downto 0);                   -- Field: VALUE
signal field_rw_DMA_CTRL_GRAB_QUEUE_EN                             : std_logic;                                       -- Field: GRAB_QUEUE_EN
signal field_rw_DMA_FSTART_VALUE                                   : std_logic_vector(31 downto 0);                   -- Field: VALUE
signal field_rw_DMA_FSTART_HIGH_VALUE                              : std_logic_vector(31 downto 0);                   -- Field: VALUE
signal field_rw_DMA_FSTART_G_VALUE                                 : std_logic_vector(31 downto 0);                   -- Field: VALUE
signal field_rw_DMA_FSTART_G_HIGH_VALUE                            : std_logic_vector(31 downto 0);                   -- Field: VALUE
signal field_rw_DMA_FSTART_R_VALUE                                 : std_logic_vector(31 downto 0);                   -- Field: VALUE
signal field_rw_DMA_FSTART_R_HIGH_VALUE                            : std_logic_vector(31 downto 0);                   -- Field: VALUE
signal field_rw_DMA_LINE_PITCH_VALUE                               : std_logic_vector(15 downto 0);                   -- Field: VALUE
signal field_rw_DMA_LINE_SIZE_VALUE                                : std_logic_vector(14 downto 0);                   -- Field: VALUE
signal field_rw_DMA_CSC_COLOR_SPACE                                : std_logic_vector(2 downto 0);                    -- Field: COLOR_SPACE
signal field_rw_DMA_CSC_SUB_X                                      : std_logic_vector(3 downto 0);                    -- Field: SUB_X
signal field_rw_DMA_CSC_REVERSE_Y                                  : std_logic;                                       -- Field: REVERSE_Y
signal field_rw_DMA_CSC_REVERSE_X                                  : std_logic;                                       -- Field: REVERSE_X
signal field_rw_DMA_OUTPUT_BUFFER_LINE_PTR_WIDTH                   : std_logic_vector(1 downto 0);                    -- Field: LINE_PTR_WIDTH
signal field_rw2c_DMA_OUTPUT_BUFFER_PCIE_BACK_PRESSURE             : std_logic;                                       -- Field: PCIE_BACK_PRESSURE
signal field_wautoclr_DMA_OUTPUT_BUFFER_CLR_MAX_LINE_BUFF_CNT      : std_logic;                                       -- Field: CLR_MAX_LINE_BUFF_CNT
signal field_rw_DMA_ROI_X_ROI_EN                                   : std_logic;                                       -- Field: ROI_EN
signal field_rw_DMA_ROI_X_X_SIZE                                   : std_logic_vector(12 downto 0);                   -- Field: X_SIZE
signal field_rw_DMA_ROI_X_X_START                                  : std_logic_vector(12 downto 0);                   -- Field: X_START
signal field_rw_DMA_ROI_Y_ROI_EN                                   : std_logic;                                       -- Field: ROI_EN
signal field_rw_DMA_ROI_Y_Y_SIZE                                   : std_logic_vector(12 downto 0);                   -- Field: Y_SIZE
signal field_rw_DMA_ROI_Y_Y_START                                  : std_logic_vector(12 downto 0);                   -- Field: Y_START
signal field_rw_ACQ_GRAB_CTRL_RESET_GRAB                           : std_logic;                                       -- Field: RESET_GRAB
signal field_rw_ACQ_GRAB_CTRL_GRAB_ROI2_EN                         : std_logic;                                       -- Field: GRAB_ROI2_EN
signal field_wautoclr_ACQ_GRAB_CTRL_ABORT_GRAB                     : std_logic;                                       -- Field: ABORT_GRAB
signal field_rw_ACQ_GRAB_CTRL_TRIGGER_OVERLAP_BUFFn                : std_logic;                                       -- Field: TRIGGER_OVERLAP_BUFFn
signal field_rw_ACQ_GRAB_CTRL_TRIGGER_OVERLAP                      : std_logic;                                       -- Field: TRIGGER_OVERLAP
signal field_rw_ACQ_GRAB_CTRL_TRIGGER_ACT                          : std_logic_vector(2 downto 0);                    -- Field: TRIGGER_ACT
signal field_rw_ACQ_GRAB_CTRL_TRIGGER_SRC                          : std_logic_vector(2 downto 0);                    -- Field: TRIGGER_SRC
signal field_wautoclr_ACQ_GRAB_CTRL_GRAB_SS                        : std_logic;                                       -- Field: GRAB_SS
signal field_rw_ACQ_GRAB_CTRL_BUFFER_ID                            : std_logic;                                       -- Field: BUFFER_ID
signal field_wautoclr_ACQ_GRAB_CTRL_GRAB_CMD                       : std_logic;                                       -- Field: GRAB_CMD
signal field_rw_ACQ_READOUT_CFG1_FOT_LENGTH_LINE                   : std_logic_vector(4 downto 0);                    -- Field: FOT_LENGTH_LINE
signal field_rw_ACQ_READOUT_CFG1_EO_FOT_SEL                        : std_logic;                                       -- Field: EO_FOT_SEL
signal field_rw_ACQ_READOUT_CFG1_FOT_LENGTH                        : std_logic_vector(15 downto 0);                   -- Field: FOT_LENGTH
signal field_rw_ACQ_READOUT_CFG_FRAME_LINE_DUMMY_LINES             : std_logic_vector(7 downto 0);                    -- Field: DUMMY_LINES
signal field_rw_ACQ_READOUT_CFG3_LINE_TIME                         : std_logic_vector(15 downto 0);                   -- Field: LINE_TIME
signal field_rw_ACQ_READOUT_CFG4_KEEP_OUT_TRIG_ENA                 : std_logic;                                       -- Field: KEEP_OUT_TRIG_ENA
signal field_rw_ACQ_READOUT_CFG4_KEEP_OUT_TRIG_START               : std_logic_vector(15 downto 0);                   -- Field: KEEP_OUT_TRIG_START
signal field_rw_ACQ_EXP_CTRL1_EXPOSURE_LEV_MODE                    : std_logic;                                       -- Field: EXPOSURE_LEV_MODE
signal field_rw_ACQ_EXP_CTRL1_EXPOSURE_SS                          : std_logic_vector(27 downto 0);                   -- Field: EXPOSURE_SS
signal field_rw_ACQ_EXP_CTRL2_EXPOSURE_DS                          : std_logic_vector(27 downto 0);                   -- Field: EXPOSURE_DS
signal field_rw_ACQ_EXP_CTRL3_EXPOSURE_TS                          : std_logic_vector(27 downto 0);                   -- Field: EXPOSURE_TS
signal field_rw_ACQ_TRIGGER_DELAY_TRIGGER_DELAY                    : std_logic_vector(27 downto 0);                   -- Field: TRIGGER_DELAY
signal field_rw_ACQ_STROBE_CTRL1_STROBE_E                          : std_logic;                                       -- Field: STROBE_E
signal field_rw_ACQ_STROBE_CTRL1_STROBE_POL                        : std_logic;                                       -- Field: STROBE_POL
signal field_rw_ACQ_STROBE_CTRL1_STROBE_START                      : std_logic_vector(27 downto 0);                   -- Field: STROBE_START
signal field_rw_ACQ_STROBE_CTRL2_STROBE_MODE                       : std_logic;                                       -- Field: STROBE_MODE
signal field_rw_ACQ_STROBE_CTRL2_STROBE_B_EN                       : std_logic;                                       -- Field: STROBE_B_EN
signal field_rw_ACQ_STROBE_CTRL2_STROBE_A_EN                       : std_logic;                                       -- Field: STROBE_A_EN
signal field_rw_ACQ_STROBE_CTRL2_STROBE_END                        : std_logic_vector(27 downto 0);                   -- Field: STROBE_END
signal field_rw_ACQ_ACQ_SER_CTRL_SER_RWn                           : std_logic;                                       -- Field: SER_RWn
signal field_rw_ACQ_ACQ_SER_CTRL_SER_CMD                           : std_logic_vector(1 downto 0);                    -- Field: SER_CMD
signal field_wautoclr_ACQ_ACQ_SER_CTRL_SER_RF_SS                   : std_logic;                                       -- Field: SER_RF_SS
signal field_wautoclr_ACQ_ACQ_SER_CTRL_SER_WF_SS                   : std_logic;                                       -- Field: SER_WF_SS
signal field_rw_ACQ_ACQ_SER_ADDATA_SER_DAT                         : std_logic_vector(15 downto 0);                   -- Field: SER_DAT
signal field_rw_ACQ_ACQ_SER_ADDATA_SER_ADD                         : std_logic_vector(14 downto 0);                   -- Field: SER_ADD
signal field_wautoclr_ACQ_SENSOR_CTRL_SENSOR_REFRESH_TEMP          : std_logic;                                       -- Field: SENSOR_REFRESH_TEMP
signal field_wautoclr_ACQ_SENSOR_CTRL_SENSOR_POWERDOWN             : std_logic;                                       -- Field: SENSOR_POWERDOWN
signal field_rw_ACQ_SENSOR_CTRL_SENSOR_COLOR                       : std_logic;                                       -- Field: SENSOR_COLOR
signal field_rw_ACQ_SENSOR_CTRL_SENSOR_REG_UPDATE                  : std_logic;                                       -- Field: SENSOR_REG_UPDATE
signal field_rw_ACQ_SENSOR_CTRL_SENSOR_RESETN                      : std_logic;                                       -- Field: SENSOR_RESETN
signal field_wautoclr_ACQ_SENSOR_CTRL_SENSOR_POWERUP               : std_logic;                                       -- Field: SENSOR_POWERUP
signal field_rw_ACQ_SENSOR_SUBSAMPLING_ACTIVE_SUBSAMPLING_Y        : std_logic;                                       -- Field: ACTIVE_SUBSAMPLING_Y
signal field_rw_ACQ_SENSOR_SUBSAMPLING_M_SUBSAMPLING_Y             : std_logic;                                       -- Field: M_SUBSAMPLING_Y
signal field_rw_ACQ_SENSOR_SUBSAMPLING_SUBSAMPLING_X               : std_logic;                                       -- Field: SUBSAMPLING_X
signal field_rw_ACQ_SENSOR_GAIN_ANA_ANALOG_GAIN                    : std_logic_vector(2 downto 0);                    -- Field: ANALOG_GAIN
signal field_rw_ACQ_SENSOR_ROI_Y_START_Y_START                     : std_logic_vector(9 downto 0);                    -- Field: Y_START
signal field_rw_ACQ_SENSOR_ROI_Y_SIZE_Y_SIZE                       : std_logic_vector(9 downto 0);                    -- Field: Y_SIZE
signal field_rw_ACQ_SENSOR_M_LINES_M_LINES_DISPLAY                 : std_logic;                                       -- Field: M_LINES_DISPLAY
signal field_rw_ACQ_SENSOR_M_LINES_M_SUPPRESSED                    : std_logic_vector(4 downto 0);                    -- Field: M_SUPPRESSED
signal field_rw_ACQ_SENSOR_M_LINES_M_LINES_SENSOR                  : std_logic_vector(9 downto 0);                    -- Field: M_LINES_SENSOR
signal field_rw_ACQ_SENSOR_DP_GR_DP_OFFSET_GR                      : std_logic_vector(11 downto 0);                   -- Field: DP_OFFSET_GR
signal field_rw_ACQ_SENSOR_DP_GB_DP_OFFSET_GB                      : std_logic_vector(11 downto 0);                   -- Field: DP_OFFSET_GB
signal field_rw_ACQ_SENSOR_DP_R_DP_OFFSET_R                        : std_logic_vector(11 downto 0);                   -- Field: DP_OFFSET_R
signal field_rw_ACQ_SENSOR_DP_B_DP_OFFSET_B                        : std_logic_vector(11 downto 0);                   -- Field: DP_OFFSET_B
signal field_rw_ACQ_SENSOR_GAIN_DIG_G_DG_FACTOR_GR                 : std_logic_vector(6 downto 0);                    -- Field: DG_FACTOR_GR
signal field_rw_ACQ_SENSOR_GAIN_DIG_G_DG_FACTOR_GB                 : std_logic_vector(6 downto 0);                    -- Field: DG_FACTOR_GB
signal field_rw_ACQ_SENSOR_GAIN_DIG_RB_DG_FACTOR_R                 : std_logic_vector(6 downto 0);                    -- Field: DG_FACTOR_R
signal field_rw_ACQ_SENSOR_GAIN_DIG_RB_DG_FACTOR_B                 : std_logic_vector(6 downto 0);                    -- Field: DG_FACTOR_B
signal field_rw_ACQ_DEBUG_PINS_Debug3_sel                          : std_logic_vector(4 downto 0);                    -- Field: Debug3_sel
signal field_rw_ACQ_DEBUG_PINS_Debug2_sel                          : std_logic_vector(4 downto 0);                    -- Field: Debug2_sel
signal field_rw_ACQ_DEBUG_PINS_Debug1_sel                          : std_logic_vector(4 downto 0);                    -- Field: Debug1_sel
signal field_rw_ACQ_DEBUG_PINS_Debug0_sel                          : std_logic_vector(4 downto 0);                    -- Field: Debug0_sel
signal field_wautoclr_ACQ_TRIGGER_MISSED_TRIGGER_MISSED_RST        : std_logic;                                       -- Field: TRIGGER_MISSED_RST
signal field_rw_ACQ_DEBUG_DEBUG_RST_CNTR                           : std_logic;                                       -- Field: DEBUG_RST_CNTR
signal field_rw_ACQ_DEBUG_LED_TEST_COLOR                           : std_logic_vector(1 downto 0);                    -- Field: LED_TEST_COLOR
signal field_rw_ACQ_DEBUG_LED_TEST                                 : std_logic;                                       -- Field: LED_TEST
signal field_rw_ACQ_EXP_FOT_EXP_FOT                                : std_logic;                                       -- Field: EXP_FOT
signal field_rw_ACQ_EXP_FOT_EXP_FOT_TIME                           : std_logic_vector(15 downto 0);                   -- Field: EXP_FOT_TIME
signal field_rw_ACQ_ACQ_SFNC_RELOAD_GRAB_PARAMS                    : std_logic;                                       -- Field: RELOAD_GRAB_PARAMS
signal field_rw_ACQ_TIMER_CTRL_ADAPTATIVE                          : std_logic;                                       -- Field: ADAPTATIVE
signal field_wautoclr_ACQ_TIMER_CTRL_TIMERSTOP                     : std_logic;                                       -- Field: TIMERSTOP
signal field_wautoclr_ACQ_TIMER_CTRL_TIMERSTART                    : std_logic;                                       -- Field: TIMERSTART
signal field_rw_ACQ_TIMER_DELAY_VALUE                              : std_logic_vector(31 downto 0);                   -- Field: VALUE
signal field_rw_ACQ_TIMER_DURATION_VALUE                           : std_logic_vector(31 downto 0);                   -- Field: VALUE
signal field_rw_HISPI_CTRL_SW_CLR_IDELAYCTRL                       : std_logic;                                       -- Field: SW_CLR_IDELAYCTRL
signal field_rw_HISPI_CTRL_SW_CLR_HISPI                            : std_logic;                                       -- Field: SW_CLR_HISPI
signal field_wautoclr_HISPI_CTRL_SW_CALIB_SERDES                   : std_logic;                                       -- Field: SW_CALIB_SERDES
signal field_rw_HISPI_CTRL_ENABLE_DATA_PATH                        : std_logic;                                       -- Field: ENABLE_DATA_PATH
signal field_rw_HISPI_CTRL_ENABLE_HISPI                            : std_logic;                                       -- Field: ENABLE_HISPI
signal field_rw_HISPI_IDLE_CHARACTER_VALUE                         : std_logic_vector(11 downto 0);                   -- Field: VALUE
signal field_rw_HISPI_PHY_PIXEL_PER_LANE                           : std_logic_vector(9 downto 0);                    -- Field: PIXEL_PER_LANE
signal field_rw_HISPI_PHY_NB_LANES                                 : std_logic_vector(2 downto 0);                    -- Field: NB_LANES
signal field_rw_HISPI_FRAME_CFG_LINES_PER_FRAME                    : std_logic_vector(11 downto 0);                   -- Field: LINES_PER_FRAME
signal field_rw_HISPI_FRAME_CFG_PIXELS_PER_LINE                    : std_logic_vector(12 downto 0);                   -- Field: PIXELS_PER_LINE
signal field_rw_HISPI_FRAME_CFG_X_VALID_X_END                      : std_logic_vector(12 downto 0);                   -- Field: X_END
signal field_rw_HISPI_FRAME_CFG_X_VALID_X_START                    : std_logic_vector(12 downto 0);                   -- Field: X_START
signal field_rw2c_HISPI_LANE_DECODER_STATUS_0_CRC_ERROR            : std_logic;                                       -- Field: CRC_ERROR
signal field_rw2c_HISPI_LANE_DECODER_STATUS_0_PHY_SYNC_ERROR       : std_logic;                                       -- Field: PHY_SYNC_ERROR
signal field_rw2c_HISPI_LANE_DECODER_STATUS_0_PHY_BIT_LOCKED_ERROR : std_logic;                                       -- Field: PHY_BIT_LOCKED_ERROR
signal field_rw2c_HISPI_LANE_DECODER_STATUS_0_CALIBRATION_ERROR    : std_logic;                                       -- Field: CALIBRATION_ERROR
signal field_rw2c_HISPI_LANE_DECODER_STATUS_0_FIFO_UNDERRUN        : std_logic;                                       -- Field: FIFO_UNDERRUN
signal field_rw2c_HISPI_LANE_DECODER_STATUS_0_FIFO_OVERRUN         : std_logic;                                       -- Field: FIFO_OVERRUN
signal field_rw2c_HISPI_LANE_DECODER_STATUS_1_CRC_ERROR            : std_logic;                                       -- Field: CRC_ERROR
signal field_rw2c_HISPI_LANE_DECODER_STATUS_1_PHY_SYNC_ERROR       : std_logic;                                       -- Field: PHY_SYNC_ERROR
signal field_rw2c_HISPI_LANE_DECODER_STATUS_1_PHY_BIT_LOCKED_ERROR : std_logic;                                       -- Field: PHY_BIT_LOCKED_ERROR
signal field_rw2c_HISPI_LANE_DECODER_STATUS_1_CALIBRATION_ERROR    : std_logic;                                       -- Field: CALIBRATION_ERROR
signal field_rw2c_HISPI_LANE_DECODER_STATUS_1_FIFO_UNDERRUN        : std_logic;                                       -- Field: FIFO_UNDERRUN
signal field_rw2c_HISPI_LANE_DECODER_STATUS_1_FIFO_OVERRUN         : std_logic;                                       -- Field: FIFO_OVERRUN
signal field_rw2c_HISPI_LANE_DECODER_STATUS_2_CRC_ERROR            : std_logic;                                       -- Field: CRC_ERROR
signal field_rw2c_HISPI_LANE_DECODER_STATUS_2_PHY_SYNC_ERROR       : std_logic;                                       -- Field: PHY_SYNC_ERROR
signal field_rw2c_HISPI_LANE_DECODER_STATUS_2_PHY_BIT_LOCKED_ERROR : std_logic;                                       -- Field: PHY_BIT_LOCKED_ERROR
signal field_rw2c_HISPI_LANE_DECODER_STATUS_2_CALIBRATION_ERROR    : std_logic;                                       -- Field: CALIBRATION_ERROR
signal field_rw2c_HISPI_LANE_DECODER_STATUS_2_FIFO_UNDERRUN        : std_logic;                                       -- Field: FIFO_UNDERRUN
signal field_rw2c_HISPI_LANE_DECODER_STATUS_2_FIFO_OVERRUN         : std_logic;                                       -- Field: FIFO_OVERRUN
signal field_rw2c_HISPI_LANE_DECODER_STATUS_3_CRC_ERROR            : std_logic;                                       -- Field: CRC_ERROR
signal field_rw2c_HISPI_LANE_DECODER_STATUS_3_PHY_SYNC_ERROR       : std_logic;                                       -- Field: PHY_SYNC_ERROR
signal field_rw2c_HISPI_LANE_DECODER_STATUS_3_PHY_BIT_LOCKED_ERROR : std_logic;                                       -- Field: PHY_BIT_LOCKED_ERROR
signal field_rw2c_HISPI_LANE_DECODER_STATUS_3_CALIBRATION_ERROR    : std_logic;                                       -- Field: CALIBRATION_ERROR
signal field_rw2c_HISPI_LANE_DECODER_STATUS_3_FIFO_UNDERRUN        : std_logic;                                       -- Field: FIFO_UNDERRUN
signal field_rw2c_HISPI_LANE_DECODER_STATUS_3_FIFO_OVERRUN         : std_logic;                                       -- Field: FIFO_OVERRUN
signal field_rw2c_HISPI_LANE_DECODER_STATUS_4_CRC_ERROR            : std_logic;                                       -- Field: CRC_ERROR
signal field_rw2c_HISPI_LANE_DECODER_STATUS_4_PHY_SYNC_ERROR       : std_logic;                                       -- Field: PHY_SYNC_ERROR
signal field_rw2c_HISPI_LANE_DECODER_STATUS_4_PHY_BIT_LOCKED_ERROR : std_logic;                                       -- Field: PHY_BIT_LOCKED_ERROR
signal field_rw2c_HISPI_LANE_DECODER_STATUS_4_CALIBRATION_ERROR    : std_logic;                                       -- Field: CALIBRATION_ERROR
signal field_rw2c_HISPI_LANE_DECODER_STATUS_4_FIFO_UNDERRUN        : std_logic;                                       -- Field: FIFO_UNDERRUN
signal field_rw2c_HISPI_LANE_DECODER_STATUS_4_FIFO_OVERRUN         : std_logic;                                       -- Field: FIFO_OVERRUN
signal field_rw2c_HISPI_LANE_DECODER_STATUS_5_CRC_ERROR            : std_logic;                                       -- Field: CRC_ERROR
signal field_rw2c_HISPI_LANE_DECODER_STATUS_5_PHY_SYNC_ERROR       : std_logic;                                       -- Field: PHY_SYNC_ERROR
signal field_rw2c_HISPI_LANE_DECODER_STATUS_5_PHY_BIT_LOCKED_ERROR : std_logic;                                       -- Field: PHY_BIT_LOCKED_ERROR
signal field_rw2c_HISPI_LANE_DECODER_STATUS_5_CALIBRATION_ERROR    : std_logic;                                       -- Field: CALIBRATION_ERROR
signal field_rw2c_HISPI_LANE_DECODER_STATUS_5_FIFO_UNDERRUN        : std_logic;                                       -- Field: FIFO_UNDERRUN
signal field_rw2c_HISPI_LANE_DECODER_STATUS_5_FIFO_OVERRUN         : std_logic;                                       -- Field: FIFO_OVERRUN
signal field_rw_HISPI_DEBUG_MANUAL_CALIB_EN                        : std_logic;                                       -- Field: MANUAL_CALIB_EN
signal field_wautoclr_HISPI_DEBUG_LOAD_TAPS                        : std_logic;                                       -- Field: LOAD_TAPS
signal field_rw_HISPI_DEBUG_TAP_LANE_5                             : std_logic_vector(4 downto 0);                    -- Field: TAP_LANE_5
signal field_rw_HISPI_DEBUG_TAP_LANE_4                             : std_logic_vector(4 downto 0);                    -- Field: TAP_LANE_4
signal field_rw_HISPI_DEBUG_TAP_LANE_3                             : std_logic_vector(4 downto 0);                    -- Field: TAP_LANE_3
signal field_rw_HISPI_DEBUG_TAP_LANE_2                             : std_logic_vector(4 downto 0);                    -- Field: TAP_LANE_2
signal field_rw_HISPI_DEBUG_TAP_LANE_1                             : std_logic_vector(4 downto 0);                    -- Field: TAP_LANE_1
signal field_rw_HISPI_DEBUG_TAP_LANE_0                             : std_logic_vector(4 downto 0);                    -- Field: TAP_LANE_0
signal field_rw_DPC_DPC_LIST_CTRL_dpc_highlight_all                : std_logic;                                       -- Field: dpc_highlight_all
signal field_rw_DPC_DPC_LIST_CTRL_dpc_fifo_reset                   : std_logic;                                       -- Field: dpc_fifo_reset
signal field_rw_DPC_DPC_LIST_CTRL_dpc_firstlast_line_rem           : std_logic;                                       -- Field: dpc_firstlast_line_rem
signal field_rw_DPC_DPC_LIST_CTRL_dpc_list_count                   : std_logic_vector(11 downto 0);                   -- Field: dpc_list_count
signal field_rw_DPC_DPC_LIST_CTRL_dpc_pattern0_cfg                 : std_logic;                                       -- Field: dpc_pattern0_cfg
signal field_rw_DPC_DPC_LIST_CTRL_dpc_enable                       : std_logic;                                       -- Field: dpc_enable
signal field_rw_DPC_DPC_LIST_CTRL_dpc_list_WRn                     : std_logic;                                       -- Field: dpc_list_WRn
signal field_wautoclr_DPC_DPC_LIST_CTRL_dpc_list_ss                : std_logic;                                       -- Field: dpc_list_ss
signal field_rw_DPC_DPC_LIST_CTRL_dpc_list_add                     : std_logic_vector(11 downto 0);                   -- Field: dpc_list_add
signal field_rw_DPC_DPC_LIST_DATA1_dpc_list_corr_y                 : std_logic_vector(11 downto 0);                   -- Field: dpc_list_corr_y
signal field_rw_DPC_DPC_LIST_DATA1_dpc_list_corr_x                 : std_logic_vector(12 downto 0);                   -- Field: dpc_list_corr_x
signal field_rw_DPC_DPC_LIST_DATA2_dpc_list_corr_pattern           : std_logic_vector(7 downto 0);                    -- Field: dpc_list_corr_pattern
signal field_rw_LUT_LUT_CTRL_LUT_BYPASS_COLOR                      : std_logic;                                       -- Field: LUT_BYPASS_COLOR
signal field_rw_LUT_LUT_CTRL_LUT_BYPASS                            : std_logic;                                       -- Field: LUT_BYPASS
signal field_rw_LUT_LUT_CTRL_LUT_DATA_W                            : std_logic_vector(9 downto 0);                    -- Field: LUT_DATA_W
signal field_rw_LUT_LUT_CTRL_LUT_SEL                               : std_logic_vector(3 downto 0);                    -- Field: LUT_SEL
signal field_rw_LUT_LUT_CTRL_LUT_WRN                               : std_logic;                                       -- Field: LUT_WRN
signal field_wautoclr_LUT_LUT_CTRL_LUT_SS                          : std_logic;                                       -- Field: LUT_SS
signal field_rw_LUT_LUT_CTRL_LUT_ADD                               : std_logic_vector(9 downto 0);                    -- Field: LUT_ADD
signal field_rw_BAYER_WB_MUL1_WB_MULT_G                            : std_logic_vector(15 downto 0);                   -- Field: WB_MULT_G
signal field_rw_BAYER_WB_MUL1_WB_MULT_B                            : std_logic_vector(15 downto 0);                   -- Field: WB_MULT_B
signal field_rw_BAYER_WB_MUL2_WB_MULT_R                            : std_logic_vector(15 downto 0);                   -- Field: WB_MULT_R
signal field_rw_BAYER_CCM_CTRL_CCM_EN                              : std_logic;                                       -- Field: CCM_EN
signal field_rw_BAYER_CCM_KR1_Kg                                   : std_logic_vector(11 downto 0);                   -- Field: Kg
signal field_rw_BAYER_CCM_KR1_Kr                                   : std_logic_vector(11 downto 0);                   -- Field: Kr
signal field_rw_BAYER_CCM_KR2_KOff                                 : std_logic_vector(8 downto 0);                    -- Field: KOff
signal field_rw_BAYER_CCM_KR2_Kb                                   : std_logic_vector(11 downto 0);                   -- Field: Kb
signal field_rw_BAYER_CCM_KG1_Kg                                   : std_logic_vector(11 downto 0);                   -- Field: Kg
signal field_rw_BAYER_CCM_KG1_Kr                                   : std_logic_vector(11 downto 0);                   -- Field: Kr
signal field_rw_BAYER_CCM_KG2_KOff                                 : std_logic_vector(8 downto 0);                    -- Field: KOff
signal field_rw_BAYER_CCM_KG2_Kb                                   : std_logic_vector(11 downto 0);                   -- Field: Kb
signal field_rw_BAYER_CCM_KB1_Kg                                   : std_logic_vector(11 downto 0);                   -- Field: Kg
signal field_rw_BAYER_CCM_KB1_Kr                                   : std_logic_vector(11 downto 0);                   -- Field: Kr
signal field_rw_BAYER_CCM_KB2_KOff                                 : std_logic_vector(8 downto 0);                    -- Field: KOff
signal field_rw_BAYER_CCM_KB2_Kb                                   : std_logic_vector(11 downto 0);                   -- Field: Kb
signal ext_SYSMONXIL_readDataValid_FF                              : std_logic;                                       -- Pipelined version of ext_SYSMONXIL_readDataValid
signal ext_SYSMONXIL_readData_FF                                   : std_logic_vector(31 downto 0);                   -- Pipelined version of ext_SYSMONXIL_readData
signal ext_SYSMONXIL_readPending                                   : std_logic;                                       -- Read pending for the SYSMONXIL external section

begin -- rtl

------------------------------------------------------------------------------------------
-- Process: P_bitEnN
------------------------------------------------------------------------------------------
P_bitEnN : process(reg_beN)
begin
   for i in 3 downto 0 loop
      for j in 7 downto 0 loop
         bitEnN(i*8+j) <= reg_beN(i);
      end loop;
   end loop;
end process P_bitEnN;

--------------------------------------------------------------------------------
-- Address decoding logic
--------------------------------------------------------------------------------
fullAddr(10 downto 2)<= reg_addr;

hit(0)   <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#0#,12)))	else '0'; -- Addr:  0x0000	TAG
hit(1)   <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#4#,12)))	else '0'; -- Addr:  0x0004	VERSION
hit(2)   <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#8#,12)))	else '0'; -- Addr:  0x0008	CAPABILITY
hit(3)   <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#c#,12)))	else '0'; -- Addr:  0x000C	SCRATCHPAD
hit(4)   <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#70#,12)))	else '0'; -- Addr:  0x0070	CTRL
hit(5)   <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#78#,12)))	else '0'; -- Addr:  0x0078	FSTART
hit(6)   <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#7c#,12)))	else '0'; -- Addr:  0x007C	FSTART_HIGH
hit(7)   <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#80#,12)))	else '0'; -- Addr:  0x0080	FSTART_G
hit(8)   <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#84#,12)))	else '0'; -- Addr:  0x0084	FSTART_G_HIGH
hit(9)   <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#88#,12)))	else '0'; -- Addr:  0x0088	FSTART_R
hit(10)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#8c#,12)))	else '0'; -- Addr:  0x008C	FSTART_R_HIGH
hit(11)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#90#,12)))	else '0'; -- Addr:  0x0090	LINE_PITCH
hit(12)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#94#,12)))	else '0'; -- Addr:  0x0094	LINE_SIZE
hit(13)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#98#,12)))	else '0'; -- Addr:  0x0098	CSC
hit(14)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#a8#,12)))	else '0'; -- Addr:  0x00A8	OUTPUT_BUFFER
hit(15)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#ac#,12)))	else '0'; -- Addr:  0x00AC	TLP
hit(16)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#b0#,12)))	else '0'; -- Addr:  0x00B0	ROI_X
hit(17)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#bc#,12)))	else '0'; -- Addr:  0x00BC	ROI_Y
hit(18)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#100#,12)))	else '0'; -- Addr:  0x0100	GRAB_CTRL
hit(19)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#108#,12)))	else '0'; -- Addr:  0x0108	GRAB_STAT
hit(20)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#110#,12)))	else '0'; -- Addr:  0x0110	READOUT_CFG1
hit(21)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#114#,12)))	else '0'; -- Addr:  0x0114	READOUT_CFG_FRAME_LINE
hit(22)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#118#,12)))	else '0'; -- Addr:  0x0118	READOUT_CFG2
hit(23)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#120#,12)))	else '0'; -- Addr:  0x0120	READOUT_CFG3
hit(24)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#124#,12)))	else '0'; -- Addr:  0x0124	READOUT_CFG4
hit(25)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#128#,12)))	else '0'; -- Addr:  0x0128	EXP_CTRL1
hit(26)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#130#,12)))	else '0'; -- Addr:  0x0130	EXP_CTRL2
hit(27)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#138#,12)))	else '0'; -- Addr:  0x0138	EXP_CTRL3
hit(28)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#140#,12)))	else '0'; -- Addr:  0x0140	TRIGGER_DELAY
hit(29)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#148#,12)))	else '0'; -- Addr:  0x0148	STROBE_CTRL1
hit(30)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#150#,12)))	else '0'; -- Addr:  0x0150	STROBE_CTRL2
hit(31)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#158#,12)))	else '0'; -- Addr:  0x0158	ACQ_SER_CTRL
hit(32)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#160#,12)))	else '0'; -- Addr:  0x0160	ACQ_SER_ADDATA
hit(33)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#168#,12)))	else '0'; -- Addr:  0x0168	ACQ_SER_STAT
hit(34)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#190#,12)))	else '0'; -- Addr:  0x0190	SENSOR_CTRL
hit(35)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#198#,12)))	else '0'; -- Addr:  0x0198	SENSOR_STAT
hit(36)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#19c#,12)))	else '0'; -- Addr:  0x019C	SENSOR_SUBSAMPLING
hit(37)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1a4#,12)))	else '0'; -- Addr:  0x01A4	SENSOR_GAIN_ANA
hit(38)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1a8#,12)))	else '0'; -- Addr:  0x01A8	SENSOR_ROI_Y_START
hit(39)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1ac#,12)))	else '0'; -- Addr:  0x01AC	SENSOR_ROI_Y_SIZE
hit(40)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1b8#,12)))	else '0'; -- Addr:  0x01B8	SENSOR_M_LINES
hit(41)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1bc#,12)))	else '0'; -- Addr:  0x01BC	SENSOR_DP_GR
hit(42)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1c0#,12)))	else '0'; -- Addr:  0x01C0	SENSOR_DP_GB
hit(43)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1c4#,12)))	else '0'; -- Addr:  0x01C4	SENSOR_DP_R
hit(44)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1c8#,12)))	else '0'; -- Addr:  0x01C8	SENSOR_DP_B
hit(45)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1cc#,12)))	else '0'; -- Addr:  0x01CC	SENSOR_GAIN_DIG_G
hit(46)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1d0#,12)))	else '0'; -- Addr:  0x01D0	SENSOR_GAIN_DIG_RB
hit(47)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1e0#,12)))	else '0'; -- Addr:  0x01E0	DEBUG_PINS
hit(48)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1e8#,12)))	else '0'; -- Addr:  0x01E8	TRIGGER_MISSED
hit(49)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1f0#,12)))	else '0'; -- Addr:  0x01F0	SENSOR_FPS
hit(50)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1f4#,12)))	else '0'; -- Addr:  0x01F4	SENSOR_FPS2
hit(51)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#2a0#,12)))	else '0'; -- Addr:  0x02A0	DEBUG
hit(52)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#2a8#,12)))	else '0'; -- Addr:  0x02A8	DEBUG_CNTR1
hit(53)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#2b0#,12)))	else '0'; -- Addr:  0x02B0	DEBUG_CNTR2
hit(54)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#2b4#,12)))	else '0'; -- Addr:  0x02B4	DEBUG_CNTR3
hit(55)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#2b8#,12)))	else '0'; -- Addr:  0x02B8	EXP_FOT
hit(56)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#2c0#,12)))	else '0'; -- Addr:  0x02C0	ACQ_SFNC
hit(57)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#2d0#,12)))	else '0'; -- Addr:  0x02D0	TIMER_CTRL
hit(58)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#2d4#,12)))	else '0'; -- Addr:  0x02D4	TIMER_DELAY
hit(59)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#2d8#,12)))	else '0'; -- Addr:  0x02D8	TIMER_DURATION
hit(60)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#400#,12)))	else '0'; -- Addr:  0x0400	CTRL
hit(61)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#404#,12)))	else '0'; -- Addr:  0x0404	STATUS
hit(62)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#408#,12)))	else '0'; -- Addr:  0x0408	IDELAYCTRL_STATUS
hit(63)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#40c#,12)))	else '0'; -- Addr:  0x040C	IDLE_CHARACTER
hit(64)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#410#,12)))	else '0'; -- Addr:  0x0410	PHY
hit(65)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#414#,12)))	else '0'; -- Addr:  0x0414	FRAME_CFG
hit(66)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#418#,12)))	else '0'; -- Addr:  0x0418	FRAME_CFG_X_VALID
hit(67)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#424#,12)))	else '0'; -- Addr:  0x0424	LANE_DECODER_STATUS[0]
hit(68)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#428#,12)))	else '0'; -- Addr:  0x0428	LANE_DECODER_STATUS[1]
hit(69)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#42c#,12)))	else '0'; -- Addr:  0x042C	LANE_DECODER_STATUS[2]
hit(70)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#430#,12)))	else '0'; -- Addr:  0x0430	LANE_DECODER_STATUS[3]
hit(71)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#434#,12)))	else '0'; -- Addr:  0x0434	LANE_DECODER_STATUS[4]
hit(72)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#438#,12)))	else '0'; -- Addr:  0x0438	LANE_DECODER_STATUS[5]
hit(73)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#43c#,12)))	else '0'; -- Addr:  0x043C	TAP_HISTOGRAM[0]
hit(74)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#440#,12)))	else '0'; -- Addr:  0x0440	TAP_HISTOGRAM[1]
hit(75)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#444#,12)))	else '0'; -- Addr:  0x0444	TAP_HISTOGRAM[2]
hit(76)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#448#,12)))	else '0'; -- Addr:  0x0448	TAP_HISTOGRAM[3]
hit(77)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#44c#,12)))	else '0'; -- Addr:  0x044C	TAP_HISTOGRAM[4]
hit(78)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#450#,12)))	else '0'; -- Addr:  0x0450	TAP_HISTOGRAM[5]
hit(79)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#454#,12)))	else '0'; -- Addr:  0x0454	DEBUG
hit(80)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#480#,12)))	else '0'; -- Addr:  0x0480	DPC_CAPABILITIES
hit(81)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#484#,12)))	else '0'; -- Addr:  0x0484	DPC_LIST_CTRL
hit(82)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#488#,12)))	else '0'; -- Addr:  0x0488	DPC_LIST_STAT
hit(83)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#48c#,12)))	else '0'; -- Addr:  0x048C	DPC_LIST_DATA1
hit(84)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#490#,12)))	else '0'; -- Addr:  0x0490	DPC_LIST_DATA2
hit(85)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#494#,12)))	else '0'; -- Addr:  0x0494	DPC_LIST_DATA1_RD
hit(86)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#498#,12)))	else '0'; -- Addr:  0x0498	DPC_LIST_DATA2_RD
hit(87)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#4b0#,12)))	else '0'; -- Addr:  0x04B0	LUT_CAPABILITIES
hit(88)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#4b4#,12)))	else '0'; -- Addr:  0x04B4	LUT_CTRL
hit(89)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#4b8#,12)))	else '0'; -- Addr:  0x04B8	LUT_RB
hit(90)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#4c0#,12)))	else '0'; -- Addr:  0x04C0	BAYER_CAPABILITIES
hit(91)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#4c4#,12)))	else '0'; -- Addr:  0x04C4	WB_MUL1
hit(92)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#4c8#,12)))	else '0'; -- Addr:  0x04C8	WB_MUL2
hit(93)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#4cc#,12)))	else '0'; -- Addr:  0x04CC	WB_B_ACC
hit(94)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#4d0#,12)))	else '0'; -- Addr:  0x04D0	WB_G_ACC
hit(95)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#4d4#,12)))	else '0'; -- Addr:  0x04D4	WB_R_ACC
hit(96)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#4d8#,12)))	else '0'; -- Addr:  0x04D8	CCM_CTRL
hit(97)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#4dc#,12)))	else '0'; -- Addr:  0x04DC	CCM_KR1
hit(98)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#4e0#,12)))	else '0'; -- Addr:  0x04E0	CCM_KR2
hit(99)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#4e4#,12)))	else '0'; -- Addr:  0x04E4	CCM_KG1
hit(100) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#4e8#,12)))	else '0'; -- Addr:  0x04E8	CCM_KG2
hit(101) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#4ec#,12)))	else '0'; -- Addr:  0x04EC	CCM_KB1
hit(102) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#4f0#,12)))	else '0'; -- Addr:  0x04F0	CCM_KB2

hit(103) <= '1' when (fullAddr >= std_logic_vector(to_unsigned(16#700#,12)) and fullAddr <= std_logic_vector(to_unsigned(16#7fc#,12)))	else '0'; -- Addr:  0x0700 to 0x07FC	SYSMONXIL


fullAddrAsInt <= CONV_integer(fullAddr);


------------------------------------------------------------------------------------------
-- Process: P_readBackMux_Mux
------------------------------------------------------------------------------------------
P_readBackMux_Mux : process(fullAddrAsInt,
                            rb_SYSTEM_TAG,
                            rb_SYSTEM_VERSION,
                            rb_SYSTEM_CAPABILITY,
                            rb_SYSTEM_SCRATCHPAD,
                            rb_DMA_CTRL,
                            rb_DMA_FSTART,
                            rb_DMA_FSTART_HIGH,
                            rb_DMA_FSTART_G,
                            rb_DMA_FSTART_G_HIGH,
                            rb_DMA_FSTART_R,
                            rb_DMA_FSTART_R_HIGH,
                            rb_DMA_LINE_PITCH,
                            rb_DMA_LINE_SIZE,
                            rb_DMA_CSC,
                            rb_DMA_OUTPUT_BUFFER,
                            rb_DMA_TLP,
                            rb_DMA_ROI_X,
                            rb_DMA_ROI_Y,
                            rb_ACQ_GRAB_CTRL,
                            rb_ACQ_GRAB_STAT,
                            rb_ACQ_READOUT_CFG1,
                            rb_ACQ_READOUT_CFG_FRAME_LINE,
                            rb_ACQ_READOUT_CFG2,
                            rb_ACQ_READOUT_CFG3,
                            rb_ACQ_READOUT_CFG4,
                            rb_ACQ_EXP_CTRL1,
                            rb_ACQ_EXP_CTRL2,
                            rb_ACQ_EXP_CTRL3,
                            rb_ACQ_TRIGGER_DELAY,
                            rb_ACQ_STROBE_CTRL1,
                            rb_ACQ_STROBE_CTRL2,
                            rb_ACQ_ACQ_SER_CTRL,
                            rb_ACQ_ACQ_SER_ADDATA,
                            rb_ACQ_ACQ_SER_STAT,
                            rb_ACQ_SENSOR_CTRL,
                            rb_ACQ_SENSOR_STAT,
                            rb_ACQ_SENSOR_SUBSAMPLING,
                            rb_ACQ_SENSOR_GAIN_ANA,
                            rb_ACQ_SENSOR_ROI_Y_START,
                            rb_ACQ_SENSOR_ROI_Y_SIZE,
                            rb_ACQ_SENSOR_M_LINES,
                            rb_ACQ_SENSOR_DP_GR,
                            rb_ACQ_SENSOR_DP_GB,
                            rb_ACQ_SENSOR_DP_R,
                            rb_ACQ_SENSOR_DP_B,
                            rb_ACQ_SENSOR_GAIN_DIG_G,
                            rb_ACQ_SENSOR_GAIN_DIG_RB,
                            rb_ACQ_DEBUG_PINS,
                            rb_ACQ_TRIGGER_MISSED,
                            rb_ACQ_SENSOR_FPS,
                            rb_ACQ_SENSOR_FPS2,
                            rb_ACQ_DEBUG,
                            rb_ACQ_DEBUG_CNTR1,
                            rb_ACQ_DEBUG_CNTR2,
                            rb_ACQ_DEBUG_CNTR3,
                            rb_ACQ_EXP_FOT,
                            rb_ACQ_ACQ_SFNC,
                            rb_ACQ_TIMER_CTRL,
                            rb_ACQ_TIMER_DELAY,
                            rb_ACQ_TIMER_DURATION,
                            rb_HISPI_CTRL,
                            rb_HISPI_STATUS,
                            rb_HISPI_IDELAYCTRL_STATUS,
                            rb_HISPI_IDLE_CHARACTER,
                            rb_HISPI_PHY,
                            rb_HISPI_FRAME_CFG,
                            rb_HISPI_FRAME_CFG_X_VALID,
                            rb_HISPI_LANE_DECODER_STATUS_0,
                            rb_HISPI_LANE_DECODER_STATUS_1,
                            rb_HISPI_LANE_DECODER_STATUS_2,
                            rb_HISPI_LANE_DECODER_STATUS_3,
                            rb_HISPI_LANE_DECODER_STATUS_4,
                            rb_HISPI_LANE_DECODER_STATUS_5,
                            rb_HISPI_TAP_HISTOGRAM_0,
                            rb_HISPI_TAP_HISTOGRAM_1,
                            rb_HISPI_TAP_HISTOGRAM_2,
                            rb_HISPI_TAP_HISTOGRAM_3,
                            rb_HISPI_TAP_HISTOGRAM_4,
                            rb_HISPI_TAP_HISTOGRAM_5,
                            rb_HISPI_DEBUG,
                            rb_DPC_DPC_CAPABILITIES,
                            rb_DPC_DPC_LIST_CTRL,
                            rb_DPC_DPC_LIST_STAT,
                            rb_DPC_DPC_LIST_DATA1,
                            rb_DPC_DPC_LIST_DATA2,
                            rb_DPC_DPC_LIST_DATA1_RD,
                            rb_DPC_DPC_LIST_DATA2_RD,
                            rb_LUT_LUT_CAPABILITIES,
                            rb_LUT_LUT_CTRL,
                            rb_LUT_LUT_RB,
                            rb_BAYER_BAYER_CAPABILITIES,
                            rb_BAYER_WB_MUL1,
                            rb_BAYER_WB_MUL2,
                            rb_BAYER_WB_B_ACC,
                            rb_BAYER_WB_G_ACC,
                            rb_BAYER_WB_R_ACC,
                            rb_BAYER_CCM_CTRL,
                            rb_BAYER_CCM_KR1,
                            rb_BAYER_CCM_KR2,
                            rb_BAYER_CCM_KG1,
                            rb_BAYER_CCM_KG2,
                            rb_BAYER_CCM_KB1,
                            rb_BAYER_CCM_KB2,
                            ext_SYSMONXIL_readData_FF
                           )
begin
   case fullAddrAsInt is
      -- [0x000]: /SYSTEM/TAG
      when 16#0# =>
         readBackMux <= rb_SYSTEM_TAG;

      -- [0x004]: /SYSTEM/VERSION
      when 16#4# =>
         readBackMux <= rb_SYSTEM_VERSION;

      -- [0x008]: /SYSTEM/CAPABILITY
      when 16#8# =>
         readBackMux <= rb_SYSTEM_CAPABILITY;

      -- [0x00c]: /SYSTEM/SCRATCHPAD
      when 16#C# =>
         readBackMux <= rb_SYSTEM_SCRATCHPAD;

      -- [0x070]: /DMA/CTRL
      when 16#70# =>
         readBackMux <= rb_DMA_CTRL;

      -- [0x078]: /DMA/FSTART
      when 16#78# =>
         readBackMux <= rb_DMA_FSTART;

      -- [0x07c]: /DMA/FSTART_HIGH
      when 16#7C# =>
         readBackMux <= rb_DMA_FSTART_HIGH;

      -- [0x080]: /DMA/FSTART_G
      when 16#80# =>
         readBackMux <= rb_DMA_FSTART_G;

      -- [0x084]: /DMA/FSTART_G_HIGH
      when 16#84# =>
         readBackMux <= rb_DMA_FSTART_G_HIGH;

      -- [0x088]: /DMA/FSTART_R
      when 16#88# =>
         readBackMux <= rb_DMA_FSTART_R;

      -- [0x08c]: /DMA/FSTART_R_HIGH
      when 16#8C# =>
         readBackMux <= rb_DMA_FSTART_R_HIGH;

      -- [0x090]: /DMA/LINE_PITCH
      when 16#90# =>
         readBackMux <= rb_DMA_LINE_PITCH;

      -- [0x094]: /DMA/LINE_SIZE
      when 16#94# =>
         readBackMux <= rb_DMA_LINE_SIZE;

      -- [0x098]: /DMA/CSC
      when 16#98# =>
         readBackMux <= rb_DMA_CSC;

      -- [0x0a8]: /DMA/OUTPUT_BUFFER
      when 16#A8# =>
         readBackMux <= rb_DMA_OUTPUT_BUFFER;

      -- [0x0ac]: /DMA/TLP
      when 16#AC# =>
         readBackMux <= rb_DMA_TLP;

      -- [0x0b0]: /DMA/ROI_X
      when 16#B0# =>
         readBackMux <= rb_DMA_ROI_X;

      -- [0x0bc]: /DMA/ROI_Y
      when 16#BC# =>
         readBackMux <= rb_DMA_ROI_Y;

      -- [0x100]: /ACQ/GRAB_CTRL
      when 16#100# =>
         readBackMux <= rb_ACQ_GRAB_CTRL;

      -- [0x108]: /ACQ/GRAB_STAT
      when 16#108# =>
         readBackMux <= rb_ACQ_GRAB_STAT;

      -- [0x110]: /ACQ/READOUT_CFG1
      when 16#110# =>
         readBackMux <= rb_ACQ_READOUT_CFG1;

      -- [0x114]: /ACQ/READOUT_CFG_FRAME_LINE
      when 16#114# =>
         readBackMux <= rb_ACQ_READOUT_CFG_FRAME_LINE;

      -- [0x118]: /ACQ/READOUT_CFG2
      when 16#118# =>
         readBackMux <= rb_ACQ_READOUT_CFG2;

      -- [0x120]: /ACQ/READOUT_CFG3
      when 16#120# =>
         readBackMux <= rb_ACQ_READOUT_CFG3;

      -- [0x124]: /ACQ/READOUT_CFG4
      when 16#124# =>
         readBackMux <= rb_ACQ_READOUT_CFG4;

      -- [0x128]: /ACQ/EXP_CTRL1
      when 16#128# =>
         readBackMux <= rb_ACQ_EXP_CTRL1;

      -- [0x130]: /ACQ/EXP_CTRL2
      when 16#130# =>
         readBackMux <= rb_ACQ_EXP_CTRL2;

      -- [0x138]: /ACQ/EXP_CTRL3
      when 16#138# =>
         readBackMux <= rb_ACQ_EXP_CTRL3;

      -- [0x140]: /ACQ/TRIGGER_DELAY
      when 16#140# =>
         readBackMux <= rb_ACQ_TRIGGER_DELAY;

      -- [0x148]: /ACQ/STROBE_CTRL1
      when 16#148# =>
         readBackMux <= rb_ACQ_STROBE_CTRL1;

      -- [0x150]: /ACQ/STROBE_CTRL2
      when 16#150# =>
         readBackMux <= rb_ACQ_STROBE_CTRL2;

      -- [0x158]: /ACQ/ACQ_SER_CTRL
      when 16#158# =>
         readBackMux <= rb_ACQ_ACQ_SER_CTRL;

      -- [0x160]: /ACQ/ACQ_SER_ADDATA
      when 16#160# =>
         readBackMux <= rb_ACQ_ACQ_SER_ADDATA;

      -- [0x168]: /ACQ/ACQ_SER_STAT
      when 16#168# =>
         readBackMux <= rb_ACQ_ACQ_SER_STAT;

      -- [0x190]: /ACQ/SENSOR_CTRL
      when 16#190# =>
         readBackMux <= rb_ACQ_SENSOR_CTRL;

      -- [0x198]: /ACQ/SENSOR_STAT
      when 16#198# =>
         readBackMux <= rb_ACQ_SENSOR_STAT;

      -- [0x19c]: /ACQ/SENSOR_SUBSAMPLING
      when 16#19C# =>
         readBackMux <= rb_ACQ_SENSOR_SUBSAMPLING;

      -- [0x1a4]: /ACQ/SENSOR_GAIN_ANA
      when 16#1A4# =>
         readBackMux <= rb_ACQ_SENSOR_GAIN_ANA;

      -- [0x1a8]: /ACQ/SENSOR_ROI_Y_START
      when 16#1A8# =>
         readBackMux <= rb_ACQ_SENSOR_ROI_Y_START;

      -- [0x1ac]: /ACQ/SENSOR_ROI_Y_SIZE
      when 16#1AC# =>
         readBackMux <= rb_ACQ_SENSOR_ROI_Y_SIZE;

      -- [0x1b8]: /ACQ/SENSOR_M_LINES
      when 16#1B8# =>
         readBackMux <= rb_ACQ_SENSOR_M_LINES;

      -- [0x1bc]: /ACQ/SENSOR_DP_GR
      when 16#1BC# =>
         readBackMux <= rb_ACQ_SENSOR_DP_GR;

      -- [0x1c0]: /ACQ/SENSOR_DP_GB
      when 16#1C0# =>
         readBackMux <= rb_ACQ_SENSOR_DP_GB;

      -- [0x1c4]: /ACQ/SENSOR_DP_R
      when 16#1C4# =>
         readBackMux <= rb_ACQ_SENSOR_DP_R;

      -- [0x1c8]: /ACQ/SENSOR_DP_B
      when 16#1C8# =>
         readBackMux <= rb_ACQ_SENSOR_DP_B;

      -- [0x1cc]: /ACQ/SENSOR_GAIN_DIG_G
      when 16#1CC# =>
         readBackMux <= rb_ACQ_SENSOR_GAIN_DIG_G;

      -- [0x1d0]: /ACQ/SENSOR_GAIN_DIG_RB
      when 16#1D0# =>
         readBackMux <= rb_ACQ_SENSOR_GAIN_DIG_RB;

      -- [0x1e0]: /ACQ/DEBUG_PINS
      when 16#1E0# =>
         readBackMux <= rb_ACQ_DEBUG_PINS;

      -- [0x1e8]: /ACQ/TRIGGER_MISSED
      when 16#1E8# =>
         readBackMux <= rb_ACQ_TRIGGER_MISSED;

      -- [0x1f0]: /ACQ/SENSOR_FPS
      when 16#1F0# =>
         readBackMux <= rb_ACQ_SENSOR_FPS;

      -- [0x1f4]: /ACQ/SENSOR_FPS2
      when 16#1F4# =>
         readBackMux <= rb_ACQ_SENSOR_FPS2;

      -- [0x2a0]: /ACQ/DEBUG
      when 16#2A0# =>
         readBackMux <= rb_ACQ_DEBUG;

      -- [0x2a8]: /ACQ/DEBUG_CNTR1
      when 16#2A8# =>
         readBackMux <= rb_ACQ_DEBUG_CNTR1;

      -- [0x2b0]: /ACQ/DEBUG_CNTR2
      when 16#2B0# =>
         readBackMux <= rb_ACQ_DEBUG_CNTR2;

      -- [0x2b4]: /ACQ/DEBUG_CNTR3
      when 16#2B4# =>
         readBackMux <= rb_ACQ_DEBUG_CNTR3;

      -- [0x2b8]: /ACQ/EXP_FOT
      when 16#2B8# =>
         readBackMux <= rb_ACQ_EXP_FOT;

      -- [0x2c0]: /ACQ/ACQ_SFNC
      when 16#2C0# =>
         readBackMux <= rb_ACQ_ACQ_SFNC;

      -- [0x2d0]: /ACQ/TIMER_CTRL
      when 16#2D0# =>
         readBackMux <= rb_ACQ_TIMER_CTRL;

      -- [0x2d4]: /ACQ/TIMER_DELAY
      when 16#2D4# =>
         readBackMux <= rb_ACQ_TIMER_DELAY;

      -- [0x2d8]: /ACQ/TIMER_DURATION
      when 16#2D8# =>
         readBackMux <= rb_ACQ_TIMER_DURATION;

      -- [0x400]: /HISPI/CTRL
      when 16#400# =>
         readBackMux <= rb_HISPI_CTRL;

      -- [0x404]: /HISPI/STATUS
      when 16#404# =>
         readBackMux <= rb_HISPI_STATUS;

      -- [0x408]: /HISPI/IDELAYCTRL_STATUS
      when 16#408# =>
         readBackMux <= rb_HISPI_IDELAYCTRL_STATUS;

      -- [0x40c]: /HISPI/IDLE_CHARACTER
      when 16#40C# =>
         readBackMux <= rb_HISPI_IDLE_CHARACTER;

      -- [0x410]: /HISPI/PHY
      when 16#410# =>
         readBackMux <= rb_HISPI_PHY;

      -- [0x414]: /HISPI/FRAME_CFG
      when 16#414# =>
         readBackMux <= rb_HISPI_FRAME_CFG;

      -- [0x418]: /HISPI/FRAME_CFG_X_VALID
      when 16#418# =>
         readBackMux <= rb_HISPI_FRAME_CFG_X_VALID;

      -- [0x424]: /HISPI/LANE_DECODER_STATUS_0
      when 16#424# =>
         readBackMux <= rb_HISPI_LANE_DECODER_STATUS_0;

      -- [0x428]: /HISPI/LANE_DECODER_STATUS_1
      when 16#428# =>
         readBackMux <= rb_HISPI_LANE_DECODER_STATUS_1;

      -- [0x42c]: /HISPI/LANE_DECODER_STATUS_2
      when 16#42C# =>
         readBackMux <= rb_HISPI_LANE_DECODER_STATUS_2;

      -- [0x430]: /HISPI/LANE_DECODER_STATUS_3
      when 16#430# =>
         readBackMux <= rb_HISPI_LANE_DECODER_STATUS_3;

      -- [0x434]: /HISPI/LANE_DECODER_STATUS_4
      when 16#434# =>
         readBackMux <= rb_HISPI_LANE_DECODER_STATUS_4;

      -- [0x438]: /HISPI/LANE_DECODER_STATUS_5
      when 16#438# =>
         readBackMux <= rb_HISPI_LANE_DECODER_STATUS_5;

      -- [0x43c]: /HISPI/TAP_HISTOGRAM_0
      when 16#43C# =>
         readBackMux <= rb_HISPI_TAP_HISTOGRAM_0;

      -- [0x440]: /HISPI/TAP_HISTOGRAM_1
      when 16#440# =>
         readBackMux <= rb_HISPI_TAP_HISTOGRAM_1;

      -- [0x444]: /HISPI/TAP_HISTOGRAM_2
      when 16#444# =>
         readBackMux <= rb_HISPI_TAP_HISTOGRAM_2;

      -- [0x448]: /HISPI/TAP_HISTOGRAM_3
      when 16#448# =>
         readBackMux <= rb_HISPI_TAP_HISTOGRAM_3;

      -- [0x44c]: /HISPI/TAP_HISTOGRAM_4
      when 16#44C# =>
         readBackMux <= rb_HISPI_TAP_HISTOGRAM_4;

      -- [0x450]: /HISPI/TAP_HISTOGRAM_5
      when 16#450# =>
         readBackMux <= rb_HISPI_TAP_HISTOGRAM_5;

      -- [0x454]: /HISPI/DEBUG
      when 16#454# =>
         readBackMux <= rb_HISPI_DEBUG;

      -- [0x480]: /DPC/DPC_CAPABILITIES
      when 16#480# =>
         readBackMux <= rb_DPC_DPC_CAPABILITIES;

      -- [0x484]: /DPC/DPC_LIST_CTRL
      when 16#484# =>
         readBackMux <= rb_DPC_DPC_LIST_CTRL;

      -- [0x488]: /DPC/DPC_LIST_STAT
      when 16#488# =>
         readBackMux <= rb_DPC_DPC_LIST_STAT;

      -- [0x48c]: /DPC/DPC_LIST_DATA1
      when 16#48C# =>
         readBackMux <= rb_DPC_DPC_LIST_DATA1;

      -- [0x490]: /DPC/DPC_LIST_DATA2
      when 16#490# =>
         readBackMux <= rb_DPC_DPC_LIST_DATA2;

      -- [0x494]: /DPC/DPC_LIST_DATA1_RD
      when 16#494# =>
         readBackMux <= rb_DPC_DPC_LIST_DATA1_RD;

      -- [0x498]: /DPC/DPC_LIST_DATA2_RD
      when 16#498# =>
         readBackMux <= rb_DPC_DPC_LIST_DATA2_RD;

      -- [0x4b0]: /LUT/LUT_CAPABILITIES
      when 16#4B0# =>
         readBackMux <= rb_LUT_LUT_CAPABILITIES;

      -- [0x4b4]: /LUT/LUT_CTRL
      when 16#4B4# =>
         readBackMux <= rb_LUT_LUT_CTRL;

      -- [0x4b8]: /LUT/LUT_RB
      when 16#4B8# =>
         readBackMux <= rb_LUT_LUT_RB;

      -- [0x4c0]: /BAYER/BAYER_CAPABILITIES
      when 16#4C0# =>
         readBackMux <= rb_BAYER_BAYER_CAPABILITIES;

      -- [0x4c4]: /BAYER/WB_MUL1
      when 16#4C4# =>
         readBackMux <= rb_BAYER_WB_MUL1;

      -- [0x4c8]: /BAYER/WB_MUL2
      when 16#4C8# =>
         readBackMux <= rb_BAYER_WB_MUL2;

      -- [0x4cc]: /BAYER/WB_B_ACC
      when 16#4CC# =>
         readBackMux <= rb_BAYER_WB_B_ACC;

      -- [0x4d0]: /BAYER/WB_G_ACC
      when 16#4D0# =>
         readBackMux <= rb_BAYER_WB_G_ACC;

      -- [0x4d4]: /BAYER/WB_R_ACC
      when 16#4D4# =>
         readBackMux <= rb_BAYER_WB_R_ACC;

      -- [0x4d8]: /BAYER/CCM_CTRL
      when 16#4D8# =>
         readBackMux <= rb_BAYER_CCM_CTRL;

      -- [0x4dc]: /BAYER/CCM_KR1
      when 16#4DC# =>
         readBackMux <= rb_BAYER_CCM_KR1;

      -- [0x4e0]: /BAYER/CCM_KR2
      when 16#4E0# =>
         readBackMux <= rb_BAYER_CCM_KR2;

      -- [0x4e4]: /BAYER/CCM_KG1
      when 16#4E4# =>
         readBackMux <= rb_BAYER_CCM_KG1;

      -- [0x4e8]: /BAYER/CCM_KG2
      when 16#4E8# =>
         readBackMux <= rb_BAYER_CCM_KG2;

      -- [0x4ec]: /BAYER/CCM_KB1
      when 16#4EC# =>
         readBackMux <= rb_BAYER_CCM_KB1;

      -- [0x4f0]: /BAYER/CCM_KB2
      when 16#4F0# =>
         readBackMux <= rb_BAYER_CCM_KB2;

      -- [0x700:0x7fc] SYSMONXIL external section
      when 16#700# to 16#7FC# =>
         readBackMux <= ext_SYSMONXIL_readData_FF;

      -- Default value
      when others =>
         readBackMux <= (others => '0');

   end case;

end process P_readBackMux_Mux;


------------------------------------------------------------------------------------------
-- Process: P_reg_readdata
------------------------------------------------------------------------------------------
P_reg_readdata : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         reg_readdata <= (others=>'0');
      else
         if (ldData = '1') then
            reg_readdata <= readBackMux;
         end if;
      end if;
   end if;
end process P_reg_readdata;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: SYSTEM_TAG
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(0) <= (hit(0)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: VALUE
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_SYSTEM_TAG(23 downto 0) <= std_logic_vector(to_unsigned(integer(5788749),24));
regfile.SYSTEM.TAG.VALUE <= rb_SYSTEM_TAG(23 downto 0);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: SYSTEM_VERSION
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(1) <= (hit(1)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: MAJOR
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_SYSTEM_VERSION(23 downto 16) <= std_logic_vector(to_unsigned(integer(0),8));
regfile.SYSTEM.VERSION.MAJOR <= rb_SYSTEM_VERSION(23 downto 16);


------------------------------------------------------------------------------------------
-- Field name: MINOR
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_SYSTEM_VERSION(15 downto 8) <= std_logic_vector(to_unsigned(integer(2),8));
regfile.SYSTEM.VERSION.MINOR <= rb_SYSTEM_VERSION(15 downto 8);


------------------------------------------------------------------------------------------
-- Field name: HW
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_SYSTEM_VERSION(7 downto 0) <= std_logic_vector(to_unsigned(integer(0),8));
regfile.SYSTEM.VERSION.HW <= rb_SYSTEM_VERSION(7 downto 0);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: SYSTEM_CAPABILITY
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(2) <= (hit(2)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: VALUE
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_SYSTEM_CAPABILITY(7 downto 0) <= std_logic_vector(to_unsigned(integer(0),8));
regfile.SYSTEM.CAPABILITY.VALUE <= rb_SYSTEM_CAPABILITY(7 downto 0);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: SYSTEM_SCRATCHPAD
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(3) <= (hit(3)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: VALUE(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_SYSTEM_SCRATCHPAD(31 downto 0) <= field_rw_SYSTEM_SCRATCHPAD_VALUE(31 downto 0);
regfile.SYSTEM.SCRATCHPAD.VALUE <= field_rw_SYSTEM_SCRATCHPAD_VALUE(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_SYSTEM_SCRATCHPAD_VALUE
------------------------------------------------------------------------------------------
P_SYSTEM_SCRATCHPAD_VALUE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_SYSTEM_SCRATCHPAD_VALUE <= X"00000000";
      else
         for j in  31 downto 0  loop
            if(wEn(3) = '1' and bitEnN(j) = '0') then
               field_rw_SYSTEM_SCRATCHPAD_VALUE(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_SYSTEM_SCRATCHPAD_VALUE;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DMA_CTRL
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(4) <= (hit(4)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: GRAB_QUEUE_EN
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DMA_CTRL(0) <= field_rw_DMA_CTRL_GRAB_QUEUE_EN;
regfile.DMA.CTRL.GRAB_QUEUE_EN <= field_rw_DMA_CTRL_GRAB_QUEUE_EN;


------------------------------------------------------------------------------------------
-- Process: P_DMA_CTRL_GRAB_QUEUE_EN
------------------------------------------------------------------------------------------
P_DMA_CTRL_GRAB_QUEUE_EN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DMA_CTRL_GRAB_QUEUE_EN <= '0';
      else
         if(wEn(4) = '1' and bitEnN(0) = '0') then
            field_rw_DMA_CTRL_GRAB_QUEUE_EN <= reg_writedata(0);
         end if;
      end if;
   end if;
end process P_DMA_CTRL_GRAB_QUEUE_EN;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DMA_FSTART
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(5) <= (hit(5)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: VALUE(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DMA_FSTART(31 downto 0) <= field_rw_DMA_FSTART_VALUE(31 downto 0);
regfile.DMA.FSTART.VALUE <= field_rw_DMA_FSTART_VALUE(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DMA_FSTART_VALUE
------------------------------------------------------------------------------------------
P_DMA_FSTART_VALUE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DMA_FSTART_VALUE <= X"00000000";
      else
         for j in  31 downto 0  loop
            if(wEn(5) = '1' and bitEnN(j) = '0') then
               field_rw_DMA_FSTART_VALUE(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DMA_FSTART_VALUE;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DMA_FSTART_HIGH
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(6) <= (hit(6)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: VALUE(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DMA_FSTART_HIGH(31 downto 0) <= field_rw_DMA_FSTART_HIGH_VALUE(31 downto 0);
regfile.DMA.FSTART_HIGH.VALUE <= field_rw_DMA_FSTART_HIGH_VALUE(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DMA_FSTART_HIGH_VALUE
------------------------------------------------------------------------------------------
P_DMA_FSTART_HIGH_VALUE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DMA_FSTART_HIGH_VALUE <= X"00000000";
      else
         for j in  31 downto 0  loop
            if(wEn(6) = '1' and bitEnN(j) = '0') then
               field_rw_DMA_FSTART_HIGH_VALUE(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DMA_FSTART_HIGH_VALUE;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DMA_FSTART_G
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(7) <= (hit(7)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: VALUE(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DMA_FSTART_G(31 downto 0) <= field_rw_DMA_FSTART_G_VALUE(31 downto 0);
regfile.DMA.FSTART_G.VALUE <= field_rw_DMA_FSTART_G_VALUE(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DMA_FSTART_G_VALUE
------------------------------------------------------------------------------------------
P_DMA_FSTART_G_VALUE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DMA_FSTART_G_VALUE <= X"00000000";
      else
         for j in  31 downto 0  loop
            if(wEn(7) = '1' and bitEnN(j) = '0') then
               field_rw_DMA_FSTART_G_VALUE(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DMA_FSTART_G_VALUE;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DMA_FSTART_G_HIGH
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(8) <= (hit(8)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: VALUE(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DMA_FSTART_G_HIGH(31 downto 0) <= field_rw_DMA_FSTART_G_HIGH_VALUE(31 downto 0);
regfile.DMA.FSTART_G_HIGH.VALUE <= field_rw_DMA_FSTART_G_HIGH_VALUE(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DMA_FSTART_G_HIGH_VALUE
------------------------------------------------------------------------------------------
P_DMA_FSTART_G_HIGH_VALUE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DMA_FSTART_G_HIGH_VALUE <= X"00000000";
      else
         for j in  31 downto 0  loop
            if(wEn(8) = '1' and bitEnN(j) = '0') then
               field_rw_DMA_FSTART_G_HIGH_VALUE(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DMA_FSTART_G_HIGH_VALUE;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DMA_FSTART_R
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(9) <= (hit(9)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: VALUE(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DMA_FSTART_R(31 downto 0) <= field_rw_DMA_FSTART_R_VALUE(31 downto 0);
regfile.DMA.FSTART_R.VALUE <= field_rw_DMA_FSTART_R_VALUE(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DMA_FSTART_R_VALUE
------------------------------------------------------------------------------------------
P_DMA_FSTART_R_VALUE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DMA_FSTART_R_VALUE <= X"00000000";
      else
         for j in  31 downto 0  loop
            if(wEn(9) = '1' and bitEnN(j) = '0') then
               field_rw_DMA_FSTART_R_VALUE(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DMA_FSTART_R_VALUE;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DMA_FSTART_R_HIGH
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(10) <= (hit(10)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: VALUE(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DMA_FSTART_R_HIGH(31 downto 0) <= field_rw_DMA_FSTART_R_HIGH_VALUE(31 downto 0);
regfile.DMA.FSTART_R_HIGH.VALUE <= field_rw_DMA_FSTART_R_HIGH_VALUE(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DMA_FSTART_R_HIGH_VALUE
------------------------------------------------------------------------------------------
P_DMA_FSTART_R_HIGH_VALUE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DMA_FSTART_R_HIGH_VALUE <= X"00000000";
      else
         for j in  31 downto 0  loop
            if(wEn(10) = '1' and bitEnN(j) = '0') then
               field_rw_DMA_FSTART_R_HIGH_VALUE(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DMA_FSTART_R_HIGH_VALUE;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DMA_LINE_PITCH
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(11) <= (hit(11)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: VALUE(15 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DMA_LINE_PITCH(15 downto 0) <= field_rw_DMA_LINE_PITCH_VALUE(15 downto 0);
regfile.DMA.LINE_PITCH.VALUE <= field_rw_DMA_LINE_PITCH_VALUE(15 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DMA_LINE_PITCH_VALUE
------------------------------------------------------------------------------------------
P_DMA_LINE_PITCH_VALUE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DMA_LINE_PITCH_VALUE <= std_logic_vector(to_unsigned(integer(0),16));
      else
         for j in  15 downto 0  loop
            if(wEn(11) = '1' and bitEnN(j) = '0') then
               field_rw_DMA_LINE_PITCH_VALUE(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DMA_LINE_PITCH_VALUE;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DMA_LINE_SIZE
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(12) <= (hit(12)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: VALUE(14 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DMA_LINE_SIZE(14 downto 0) <= field_rw_DMA_LINE_SIZE_VALUE(14 downto 0);
regfile.DMA.LINE_SIZE.VALUE <= field_rw_DMA_LINE_SIZE_VALUE(14 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DMA_LINE_SIZE_VALUE
------------------------------------------------------------------------------------------
P_DMA_LINE_SIZE_VALUE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DMA_LINE_SIZE_VALUE <= std_logic_vector(to_unsigned(integer(0),15));
      else
         for j in  14 downto 0  loop
            if(wEn(12) = '1' and bitEnN(j) = '0') then
               field_rw_DMA_LINE_SIZE_VALUE(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DMA_LINE_SIZE_VALUE;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DMA_CSC
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(13) <= (hit(13)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: COLOR_SPACE(26 downto 24)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DMA_CSC(26 downto 24) <= field_rw_DMA_CSC_COLOR_SPACE(2 downto 0);
regfile.DMA.CSC.COLOR_SPACE <= field_rw_DMA_CSC_COLOR_SPACE(2 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DMA_CSC_COLOR_SPACE
------------------------------------------------------------------------------------------
P_DMA_CSC_COLOR_SPACE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DMA_CSC_COLOR_SPACE <= std_logic_vector(to_unsigned(integer(0),3));
      else
         for j in  26 downto 24  loop
            if(wEn(13) = '1' and bitEnN(j) = '0') then
               field_rw_DMA_CSC_COLOR_SPACE(j-24) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DMA_CSC_COLOR_SPACE;

------------------------------------------------------------------------------------------
-- Field name: SUB_X(13 downto 10)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DMA_CSC(13 downto 10) <= field_rw_DMA_CSC_SUB_X(3 downto 0);
regfile.DMA.CSC.SUB_X <= field_rw_DMA_CSC_SUB_X(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DMA_CSC_SUB_X
------------------------------------------------------------------------------------------
P_DMA_CSC_SUB_X : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DMA_CSC_SUB_X <= std_logic_vector(to_unsigned(integer(0),4));
      else
         for j in  13 downto 10  loop
            if(wEn(13) = '1' and bitEnN(j) = '0') then
               field_rw_DMA_CSC_SUB_X(j-10) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DMA_CSC_SUB_X;

------------------------------------------------------------------------------------------
-- Field name: REVERSE_Y
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DMA_CSC(9) <= field_rw_DMA_CSC_REVERSE_Y;
regfile.DMA.CSC.REVERSE_Y <= field_rw_DMA_CSC_REVERSE_Y;


------------------------------------------------------------------------------------------
-- Process: P_DMA_CSC_REVERSE_Y
------------------------------------------------------------------------------------------
P_DMA_CSC_REVERSE_Y : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DMA_CSC_REVERSE_Y <= '0';
      else
         if(wEn(13) = '1' and bitEnN(9) = '0') then
            field_rw_DMA_CSC_REVERSE_Y <= reg_writedata(9);
         end if;
      end if;
   end if;
end process P_DMA_CSC_REVERSE_Y;

------------------------------------------------------------------------------------------
-- Field name: REVERSE_X
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DMA_CSC(8) <= field_rw_DMA_CSC_REVERSE_X;
regfile.DMA.CSC.REVERSE_X <= field_rw_DMA_CSC_REVERSE_X;


------------------------------------------------------------------------------------------
-- Process: P_DMA_CSC_REVERSE_X
------------------------------------------------------------------------------------------
P_DMA_CSC_REVERSE_X : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DMA_CSC_REVERSE_X <= '0';
      else
         if(wEn(13) = '1' and bitEnN(8) = '0') then
            field_rw_DMA_CSC_REVERSE_X <= reg_writedata(8);
         end if;
      end if;
   end if;
end process P_DMA_CSC_REVERSE_X;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DMA_OUTPUT_BUFFER
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(14) <= (hit(14)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: MAX_LINE_BUFF_CNT(2 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_DMA_OUTPUT_BUFFER(30 downto 28) <= regfile.DMA.OUTPUT_BUFFER.MAX_LINE_BUFF_CNT;


------------------------------------------------------------------------------------------
-- Field name: LINE_PTR_WIDTH(25 downto 24)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DMA_OUTPUT_BUFFER(25 downto 24) <= field_rw_DMA_OUTPUT_BUFFER_LINE_PTR_WIDTH(1 downto 0);
regfile.DMA.OUTPUT_BUFFER.LINE_PTR_WIDTH <= field_rw_DMA_OUTPUT_BUFFER_LINE_PTR_WIDTH(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DMA_OUTPUT_BUFFER_LINE_PTR_WIDTH
------------------------------------------------------------------------------------------
P_DMA_OUTPUT_BUFFER_LINE_PTR_WIDTH : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DMA_OUTPUT_BUFFER_LINE_PTR_WIDTH <= std_logic_vector(to_unsigned(integer(2),2));
      else
         for j in  25 downto 24  loop
            if(wEn(14) = '1' and bitEnN(j) = '0') then
               field_rw_DMA_OUTPUT_BUFFER_LINE_PTR_WIDTH(j-24) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DMA_OUTPUT_BUFFER_LINE_PTR_WIDTH;

------------------------------------------------------------------------------------------
-- Field name: ADDRESS_BUS_WIDTH(3 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_DMA_OUTPUT_BUFFER(23 downto 20) <= regfile.DMA.OUTPUT_BUFFER.ADDRESS_BUS_WIDTH;


------------------------------------------------------------------------------------------
-- Field name: PCIE_BACK_PRESSURE
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_DMA_OUTPUT_BUFFER(4) <= field_rw2c_DMA_OUTPUT_BUFFER_PCIE_BACK_PRESSURE;
regfile.DMA.OUTPUT_BUFFER.PCIE_BACK_PRESSURE <= field_rw2c_DMA_OUTPUT_BUFFER_PCIE_BACK_PRESSURE;


------------------------------------------------------------------------------------------
-- Process: P_DMA_OUTPUT_BUFFER_PCIE_BACK_PRESSURE
------------------------------------------------------------------------------------------
P_DMA_OUTPUT_BUFFER_PCIE_BACK_PRESSURE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_DMA_OUTPUT_BUFFER_PCIE_BACK_PRESSURE <= '0';
      else
         if(wEn(14) = '1' and reg_writedata(4) = '1' and bitEnN(4) = '0') then
            -- Clear the field to '0'
            field_rw2c_DMA_OUTPUT_BUFFER_PCIE_BACK_PRESSURE <= '0';
         else
            -- Set the field to '1'
            field_rw2c_DMA_OUTPUT_BUFFER_PCIE_BACK_PRESSURE <= field_rw2c_DMA_OUTPUT_BUFFER_PCIE_BACK_PRESSURE or regfile.DMA.OUTPUT_BUFFER.PCIE_BACK_PRESSURE_set;
         end if;
      end if;
   end if;
end process P_DMA_OUTPUT_BUFFER_PCIE_BACK_PRESSURE;

------------------------------------------------------------------------------------------
-- Field name: CLR_MAX_LINE_BUFF_CNT
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_DMA_OUTPUT_BUFFER(0) <= '0';
regfile.DMA.OUTPUT_BUFFER.CLR_MAX_LINE_BUFF_CNT <= field_wautoclr_DMA_OUTPUT_BUFFER_CLR_MAX_LINE_BUFF_CNT;


------------------------------------------------------------------------------------------
-- Process: P_DMA_OUTPUT_BUFFER_CLR_MAX_LINE_BUFF_CNT
------------------------------------------------------------------------------------------
P_DMA_OUTPUT_BUFFER_CLR_MAX_LINE_BUFF_CNT : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_DMA_OUTPUT_BUFFER_CLR_MAX_LINE_BUFF_CNT <= '0';
      else
         if(wEn(14) = '1' and bitEnN(0) = '0') then
            field_wautoclr_DMA_OUTPUT_BUFFER_CLR_MAX_LINE_BUFF_CNT <= reg_writedata(0);
         else
            field_wautoclr_DMA_OUTPUT_BUFFER_CLR_MAX_LINE_BUFF_CNT <= '0';
         end if;
      end if;
   end if;
end process P_DMA_OUTPUT_BUFFER_CLR_MAX_LINE_BUFF_CNT;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DMA_TLP
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(15) <= (hit(15)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: MAX_PAYLOAD(11 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_DMA_TLP(27 downto 16) <= regfile.DMA.TLP.MAX_PAYLOAD;


------------------------------------------------------------------------------------------
-- Field name: BUS_MASTER_EN
-- Field type: RO
------------------------------------------------------------------------------------------
rb_DMA_TLP(3) <= regfile.DMA.TLP.BUS_MASTER_EN;


------------------------------------------------------------------------------------------
-- Field name: CFG_MAX_PLD(2 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_DMA_TLP(2 downto 0) <= regfile.DMA.TLP.CFG_MAX_PLD;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DMA_ROI_X
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(16) <= (hit(16)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: ROI_EN
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DMA_ROI_X(31) <= field_rw_DMA_ROI_X_ROI_EN;
regfile.DMA.ROI_X.ROI_EN <= field_rw_DMA_ROI_X_ROI_EN;


------------------------------------------------------------------------------------------
-- Process: P_DMA_ROI_X_ROI_EN
------------------------------------------------------------------------------------------
P_DMA_ROI_X_ROI_EN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DMA_ROI_X_ROI_EN <= '0';
      else
         if(wEn(16) = '1' and bitEnN(31) = '0') then
            field_rw_DMA_ROI_X_ROI_EN <= reg_writedata(31);
         end if;
      end if;
   end if;
end process P_DMA_ROI_X_ROI_EN;

------------------------------------------------------------------------------------------
-- Field name: X_SIZE(28 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DMA_ROI_X(28 downto 16) <= field_rw_DMA_ROI_X_X_SIZE(12 downto 0);
regfile.DMA.ROI_X.X_SIZE <= field_rw_DMA_ROI_X_X_SIZE(12 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DMA_ROI_X_X_SIZE
------------------------------------------------------------------------------------------
P_DMA_ROI_X_X_SIZE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DMA_ROI_X_X_SIZE <= std_logic_vector(to_unsigned(integer(1023),13));
      else
         for j in  28 downto 16  loop
            if(wEn(16) = '1' and bitEnN(j) = '0') then
               field_rw_DMA_ROI_X_X_SIZE(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DMA_ROI_X_X_SIZE;

------------------------------------------------------------------------------------------
-- Field name: X_START(12 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DMA_ROI_X(12 downto 0) <= field_rw_DMA_ROI_X_X_START(12 downto 0);
regfile.DMA.ROI_X.X_START <= field_rw_DMA_ROI_X_X_START(12 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DMA_ROI_X_X_START
------------------------------------------------------------------------------------------
P_DMA_ROI_X_X_START : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DMA_ROI_X_X_START <= std_logic_vector(to_unsigned(integer(0),13));
      else
         for j in  12 downto 0  loop
            if(wEn(16) = '1' and bitEnN(j) = '0') then
               field_rw_DMA_ROI_X_X_START(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DMA_ROI_X_X_START;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DMA_ROI_Y
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(17) <= (hit(17)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: ROI_EN
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DMA_ROI_Y(31) <= field_rw_DMA_ROI_Y_ROI_EN;
regfile.DMA.ROI_Y.ROI_EN <= field_rw_DMA_ROI_Y_ROI_EN;


------------------------------------------------------------------------------------------
-- Process: P_DMA_ROI_Y_ROI_EN
------------------------------------------------------------------------------------------
P_DMA_ROI_Y_ROI_EN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DMA_ROI_Y_ROI_EN <= '0';
      else
         if(wEn(17) = '1' and bitEnN(31) = '0') then
            field_rw_DMA_ROI_Y_ROI_EN <= reg_writedata(31);
         end if;
      end if;
   end if;
end process P_DMA_ROI_Y_ROI_EN;

------------------------------------------------------------------------------------------
-- Field name: Y_SIZE(28 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DMA_ROI_Y(28 downto 16) <= field_rw_DMA_ROI_Y_Y_SIZE(12 downto 0);
regfile.DMA.ROI_Y.Y_SIZE <= field_rw_DMA_ROI_Y_Y_SIZE(12 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DMA_ROI_Y_Y_SIZE
------------------------------------------------------------------------------------------
P_DMA_ROI_Y_Y_SIZE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DMA_ROI_Y_Y_SIZE <= std_logic_vector(to_unsigned(integer(1023),13));
      else
         for j in  28 downto 16  loop
            if(wEn(17) = '1' and bitEnN(j) = '0') then
               field_rw_DMA_ROI_Y_Y_SIZE(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DMA_ROI_Y_Y_SIZE;

------------------------------------------------------------------------------------------
-- Field name: Y_START(12 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DMA_ROI_Y(12 downto 0) <= field_rw_DMA_ROI_Y_Y_START(12 downto 0);
regfile.DMA.ROI_Y.Y_START <= field_rw_DMA_ROI_Y_Y_START(12 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DMA_ROI_Y_Y_START
------------------------------------------------------------------------------------------
P_DMA_ROI_Y_Y_START : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DMA_ROI_Y_Y_START <= std_logic_vector(to_unsigned(integer(0),13));
      else
         for j in  12 downto 0  loop
            if(wEn(17) = '1' and bitEnN(j) = '0') then
               field_rw_DMA_ROI_Y_Y_START(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DMA_ROI_Y_Y_START;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_GRAB_CTRL
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(18) <= (hit(18)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: RESET_GRAB
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_GRAB_CTRL(31) <= field_rw_ACQ_GRAB_CTRL_RESET_GRAB;
regfile.ACQ.GRAB_CTRL.RESET_GRAB <= field_rw_ACQ_GRAB_CTRL_RESET_GRAB;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_GRAB_CTRL_RESET_GRAB
------------------------------------------------------------------------------------------
P_ACQ_GRAB_CTRL_RESET_GRAB : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_GRAB_CTRL_RESET_GRAB <= '0';
      else
         if(wEn(18) = '1' and bitEnN(31) = '0') then
            field_rw_ACQ_GRAB_CTRL_RESET_GRAB <= reg_writedata(31);
         end if;
      end if;
   end if;
end process P_ACQ_GRAB_CTRL_RESET_GRAB;

------------------------------------------------------------------------------------------
-- Field name: GRAB_ROI2_EN
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_GRAB_CTRL(29) <= field_rw_ACQ_GRAB_CTRL_GRAB_ROI2_EN;
regfile.ACQ.GRAB_CTRL.GRAB_ROI2_EN <= field_rw_ACQ_GRAB_CTRL_GRAB_ROI2_EN;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_GRAB_CTRL_GRAB_ROI2_EN
------------------------------------------------------------------------------------------
P_ACQ_GRAB_CTRL_GRAB_ROI2_EN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_GRAB_CTRL_GRAB_ROI2_EN <= '0';
      else
         if(wEn(18) = '1' and bitEnN(29) = '0') then
            field_rw_ACQ_GRAB_CTRL_GRAB_ROI2_EN <= reg_writedata(29);
         end if;
      end if;
   end if;
end process P_ACQ_GRAB_CTRL_GRAB_ROI2_EN;

------------------------------------------------------------------------------------------
-- Field name: ABORT_GRAB
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_ACQ_GRAB_CTRL(28) <= '0';
regfile.ACQ.GRAB_CTRL.ABORT_GRAB <= field_wautoclr_ACQ_GRAB_CTRL_ABORT_GRAB;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_GRAB_CTRL_ABORT_GRAB
------------------------------------------------------------------------------------------
P_ACQ_GRAB_CTRL_ABORT_GRAB : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_ACQ_GRAB_CTRL_ABORT_GRAB <= '0';
      else
         if(wEn(18) = '1' and bitEnN(28) = '0') then
            field_wautoclr_ACQ_GRAB_CTRL_ABORT_GRAB <= reg_writedata(28);
         else
            field_wautoclr_ACQ_GRAB_CTRL_ABORT_GRAB <= '0';
         end if;
      end if;
   end if;
end process P_ACQ_GRAB_CTRL_ABORT_GRAB;

------------------------------------------------------------------------------------------
-- Field name: TRIGGER_OVERLAP_BUFFn
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_GRAB_CTRL(16) <= field_rw_ACQ_GRAB_CTRL_TRIGGER_OVERLAP_BUFFn;
regfile.ACQ.GRAB_CTRL.TRIGGER_OVERLAP_BUFFn <= field_rw_ACQ_GRAB_CTRL_TRIGGER_OVERLAP_BUFFn;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_GRAB_CTRL_TRIGGER_OVERLAP_BUFFn
------------------------------------------------------------------------------------------
P_ACQ_GRAB_CTRL_TRIGGER_OVERLAP_BUFFn : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_GRAB_CTRL_TRIGGER_OVERLAP_BUFFn <= '0';
      else
         if(wEn(18) = '1' and bitEnN(16) = '0') then
            field_rw_ACQ_GRAB_CTRL_TRIGGER_OVERLAP_BUFFn <= reg_writedata(16);
         end if;
      end if;
   end if;
end process P_ACQ_GRAB_CTRL_TRIGGER_OVERLAP_BUFFn;

------------------------------------------------------------------------------------------
-- Field name: TRIGGER_OVERLAP
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_GRAB_CTRL(15) <= field_rw_ACQ_GRAB_CTRL_TRIGGER_OVERLAP;
regfile.ACQ.GRAB_CTRL.TRIGGER_OVERLAP <= field_rw_ACQ_GRAB_CTRL_TRIGGER_OVERLAP;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_GRAB_CTRL_TRIGGER_OVERLAP
------------------------------------------------------------------------------------------
P_ACQ_GRAB_CTRL_TRIGGER_OVERLAP : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_GRAB_CTRL_TRIGGER_OVERLAP <= '1';
      else
         if(wEn(18) = '1' and bitEnN(15) = '0') then
            field_rw_ACQ_GRAB_CTRL_TRIGGER_OVERLAP <= reg_writedata(15);
         end if;
      end if;
   end if;
end process P_ACQ_GRAB_CTRL_TRIGGER_OVERLAP;

------------------------------------------------------------------------------------------
-- Field name: TRIGGER_ACT(14 downto 12)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_GRAB_CTRL(14 downto 12) <= field_rw_ACQ_GRAB_CTRL_TRIGGER_ACT(2 downto 0);
regfile.ACQ.GRAB_CTRL.TRIGGER_ACT <= field_rw_ACQ_GRAB_CTRL_TRIGGER_ACT(2 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_GRAB_CTRL_TRIGGER_ACT
------------------------------------------------------------------------------------------
P_ACQ_GRAB_CTRL_TRIGGER_ACT : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_GRAB_CTRL_TRIGGER_ACT <= std_logic_vector(to_unsigned(integer(0),3));
      else
         for j in  14 downto 12  loop
            if(wEn(18) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_GRAB_CTRL_TRIGGER_ACT(j-12) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_GRAB_CTRL_TRIGGER_ACT;

------------------------------------------------------------------------------------------
-- Field name: TRIGGER_SRC(10 downto 8)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_GRAB_CTRL(10 downto 8) <= field_rw_ACQ_GRAB_CTRL_TRIGGER_SRC(2 downto 0);
regfile.ACQ.GRAB_CTRL.TRIGGER_SRC <= field_rw_ACQ_GRAB_CTRL_TRIGGER_SRC(2 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_GRAB_CTRL_TRIGGER_SRC
------------------------------------------------------------------------------------------
P_ACQ_GRAB_CTRL_TRIGGER_SRC : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_GRAB_CTRL_TRIGGER_SRC <= std_logic_vector(to_unsigned(integer(0),3));
      else
         for j in  10 downto 8  loop
            if(wEn(18) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_GRAB_CTRL_TRIGGER_SRC(j-8) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_GRAB_CTRL_TRIGGER_SRC;

------------------------------------------------------------------------------------------
-- Field name: GRAB_SS
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_ACQ_GRAB_CTRL(4) <= '0';
regfile.ACQ.GRAB_CTRL.GRAB_SS <= field_wautoclr_ACQ_GRAB_CTRL_GRAB_SS;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_GRAB_CTRL_GRAB_SS
------------------------------------------------------------------------------------------
P_ACQ_GRAB_CTRL_GRAB_SS : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_ACQ_GRAB_CTRL_GRAB_SS <= '0';
      else
         if(wEn(18) = '1' and bitEnN(4) = '0') then
            field_wautoclr_ACQ_GRAB_CTRL_GRAB_SS <= reg_writedata(4);
         else
            field_wautoclr_ACQ_GRAB_CTRL_GRAB_SS <= '0';
         end if;
      end if;
   end if;
end process P_ACQ_GRAB_CTRL_GRAB_SS;

------------------------------------------------------------------------------------------
-- Field name: BUFFER_ID
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_GRAB_CTRL(1) <= field_rw_ACQ_GRAB_CTRL_BUFFER_ID;
regfile.ACQ.GRAB_CTRL.BUFFER_ID <= field_rw_ACQ_GRAB_CTRL_BUFFER_ID;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_GRAB_CTRL_BUFFER_ID
------------------------------------------------------------------------------------------
P_ACQ_GRAB_CTRL_BUFFER_ID : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_GRAB_CTRL_BUFFER_ID <= '0';
      else
         if(wEn(18) = '1' and bitEnN(1) = '0') then
            field_rw_ACQ_GRAB_CTRL_BUFFER_ID <= reg_writedata(1);
         end if;
      end if;
   end if;
end process P_ACQ_GRAB_CTRL_BUFFER_ID;

------------------------------------------------------------------------------------------
-- Field name: GRAB_CMD
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_ACQ_GRAB_CTRL(0) <= '0';
regfile.ACQ.GRAB_CTRL.GRAB_CMD <= field_wautoclr_ACQ_GRAB_CTRL_GRAB_CMD;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_GRAB_CTRL_GRAB_CMD
------------------------------------------------------------------------------------------
P_ACQ_GRAB_CTRL_GRAB_CMD : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_ACQ_GRAB_CTRL_GRAB_CMD <= '0';
      else
         if(wEn(18) = '1' and bitEnN(0) = '0') then
            field_wautoclr_ACQ_GRAB_CTRL_GRAB_CMD <= reg_writedata(0);
         else
            field_wautoclr_ACQ_GRAB_CTRL_GRAB_CMD <= '0';
         end if;
      end if;
   end if;
end process P_ACQ_GRAB_CTRL_GRAB_CMD;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_GRAB_STAT
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(19) <= (hit(19)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: GRAB_CMD_DONE
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_GRAB_STAT(31) <= regfile.ACQ.GRAB_STAT.GRAB_CMD_DONE;


------------------------------------------------------------------------------------------
-- Field name: ABORT_PET
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_GRAB_STAT(30) <= regfile.ACQ.GRAB_STAT.ABORT_PET;


------------------------------------------------------------------------------------------
-- Field name: ABORT_DELAI
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_GRAB_STAT(29) <= regfile.ACQ.GRAB_STAT.ABORT_DELAI;


------------------------------------------------------------------------------------------
-- Field name: ABORT_DONE
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_GRAB_STAT(28) <= regfile.ACQ.GRAB_STAT.ABORT_DONE;


------------------------------------------------------------------------------------------
-- Field name: TRIGGER_RDY
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_GRAB_STAT(24) <= regfile.ACQ.GRAB_STAT.TRIGGER_RDY;


------------------------------------------------------------------------------------------
-- Field name: ABORT_MNGR_STAT(2 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_GRAB_STAT(22 downto 20) <= regfile.ACQ.GRAB_STAT.ABORT_MNGR_STAT;


------------------------------------------------------------------------------------------
-- Field name: TRIG_MNGR_STAT(3 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_GRAB_STAT(19 downto 16) <= regfile.ACQ.GRAB_STAT.TRIG_MNGR_STAT;


------------------------------------------------------------------------------------------
-- Field name: TIMER_MNGR_STAT(2 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_GRAB_STAT(14 downto 12) <= regfile.ACQ.GRAB_STAT.TIMER_MNGR_STAT;


------------------------------------------------------------------------------------------
-- Field name: GRAB_MNGR_STAT(3 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_GRAB_STAT(11 downto 8) <= regfile.ACQ.GRAB_STAT.GRAB_MNGR_STAT;


------------------------------------------------------------------------------------------
-- Field name: GRAB_FOT
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_GRAB_STAT(6) <= regfile.ACQ.GRAB_STAT.GRAB_FOT;


------------------------------------------------------------------------------------------
-- Field name: GRAB_READOUT
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_GRAB_STAT(5) <= regfile.ACQ.GRAB_STAT.GRAB_READOUT;


------------------------------------------------------------------------------------------
-- Field name: GRAB_EXPOSURE
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_GRAB_STAT(4) <= regfile.ACQ.GRAB_STAT.GRAB_EXPOSURE;


------------------------------------------------------------------------------------------
-- Field name: GRAB_PENDING
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_GRAB_STAT(2) <= regfile.ACQ.GRAB_STAT.GRAB_PENDING;


------------------------------------------------------------------------------------------
-- Field name: GRAB_ACTIVE
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_GRAB_STAT(1) <= regfile.ACQ.GRAB_STAT.GRAB_ACTIVE;


------------------------------------------------------------------------------------------
-- Field name: GRAB_IDLE
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_GRAB_STAT(0) <= regfile.ACQ.GRAB_STAT.GRAB_IDLE;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_READOUT_CFG1
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(20) <= (hit(20)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: FOT_LENGTH_LINE(28 downto 24)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_READOUT_CFG1(28 downto 24) <= field_rw_ACQ_READOUT_CFG1_FOT_LENGTH_LINE(4 downto 0);
regfile.ACQ.READOUT_CFG1.FOT_LENGTH_LINE <= field_rw_ACQ_READOUT_CFG1_FOT_LENGTH_LINE(4 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_READOUT_CFG1_FOT_LENGTH_LINE
------------------------------------------------------------------------------------------
P_ACQ_READOUT_CFG1_FOT_LENGTH_LINE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_READOUT_CFG1_FOT_LENGTH_LINE <= std_logic_vector(to_unsigned(integer(0),5));
      else
         for j in  28 downto 24  loop
            if(wEn(20) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_READOUT_CFG1_FOT_LENGTH_LINE(j-24) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_READOUT_CFG1_FOT_LENGTH_LINE;

------------------------------------------------------------------------------------------
-- Field name: EO_FOT_SEL
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_READOUT_CFG1(16) <= field_rw_ACQ_READOUT_CFG1_EO_FOT_SEL;
regfile.ACQ.READOUT_CFG1.EO_FOT_SEL <= field_rw_ACQ_READOUT_CFG1_EO_FOT_SEL;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_READOUT_CFG1_EO_FOT_SEL
------------------------------------------------------------------------------------------
P_ACQ_READOUT_CFG1_EO_FOT_SEL : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_READOUT_CFG1_EO_FOT_SEL <= '0';
      else
         if(wEn(20) = '1' and bitEnN(16) = '0') then
            field_rw_ACQ_READOUT_CFG1_EO_FOT_SEL <= reg_writedata(16);
         end if;
      end if;
   end if;
end process P_ACQ_READOUT_CFG1_EO_FOT_SEL;

------------------------------------------------------------------------------------------
-- Field name: FOT_LENGTH(15 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_READOUT_CFG1(15 downto 0) <= field_rw_ACQ_READOUT_CFG1_FOT_LENGTH(15 downto 0);
regfile.ACQ.READOUT_CFG1.FOT_LENGTH <= field_rw_ACQ_READOUT_CFG1_FOT_LENGTH(15 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_READOUT_CFG1_FOT_LENGTH
------------------------------------------------------------------------------------------
P_ACQ_READOUT_CFG1_FOT_LENGTH : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_READOUT_CFG1_FOT_LENGTH <= std_logic_vector(to_unsigned(integer(0),16));
      else
         for j in  15 downto 0  loop
            if(wEn(20) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_READOUT_CFG1_FOT_LENGTH(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_READOUT_CFG1_FOT_LENGTH;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_READOUT_CFG_FRAME_LINE
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(21) <= (hit(21)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: DUMMY_LINES(23 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_READOUT_CFG_FRAME_LINE(23 downto 16) <= field_rw_ACQ_READOUT_CFG_FRAME_LINE_DUMMY_LINES(7 downto 0);
regfile.ACQ.READOUT_CFG_FRAME_LINE.DUMMY_LINES <= field_rw_ACQ_READOUT_CFG_FRAME_LINE_DUMMY_LINES(7 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_READOUT_CFG_FRAME_LINE_DUMMY_LINES
------------------------------------------------------------------------------------------
P_ACQ_READOUT_CFG_FRAME_LINE_DUMMY_LINES : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_READOUT_CFG_FRAME_LINE_DUMMY_LINES <= std_logic_vector(to_unsigned(integer(0),8));
      else
         for j in  23 downto 16  loop
            if(wEn(21) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_READOUT_CFG_FRAME_LINE_DUMMY_LINES(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_READOUT_CFG_FRAME_LINE_DUMMY_LINES;

------------------------------------------------------------------------------------------
-- Field name: CURR_FRAME_LINES(12 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_READOUT_CFG_FRAME_LINE(12 downto 0) <= regfile.ACQ.READOUT_CFG_FRAME_LINE.CURR_FRAME_LINES;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_READOUT_CFG2
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(22) <= (hit(22)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: READOUT_LENGTH(28 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_READOUT_CFG2(28 downto 0) <= regfile.ACQ.READOUT_CFG2.READOUT_LENGTH;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_READOUT_CFG3
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(23) <= (hit(23)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: LINE_TIME(15 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_READOUT_CFG3(15 downto 0) <= field_rw_ACQ_READOUT_CFG3_LINE_TIME(15 downto 0);
regfile.ACQ.READOUT_CFG3.LINE_TIME <= field_rw_ACQ_READOUT_CFG3_LINE_TIME(15 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_READOUT_CFG3_LINE_TIME
------------------------------------------------------------------------------------------
P_ACQ_READOUT_CFG3_LINE_TIME : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_READOUT_CFG3_LINE_TIME <= std_logic_vector(to_unsigned(integer(366),16));
      else
         for j in  15 downto 0  loop
            if(wEn(23) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_READOUT_CFG3_LINE_TIME(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_READOUT_CFG3_LINE_TIME;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_READOUT_CFG4
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(24) <= (hit(24)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: KEEP_OUT_TRIG_ENA
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_READOUT_CFG4(16) <= field_rw_ACQ_READOUT_CFG4_KEEP_OUT_TRIG_ENA;
regfile.ACQ.READOUT_CFG4.KEEP_OUT_TRIG_ENA <= field_rw_ACQ_READOUT_CFG4_KEEP_OUT_TRIG_ENA;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_READOUT_CFG4_KEEP_OUT_TRIG_ENA
------------------------------------------------------------------------------------------
P_ACQ_READOUT_CFG4_KEEP_OUT_TRIG_ENA : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_READOUT_CFG4_KEEP_OUT_TRIG_ENA <= '0';
      else
         if(wEn(24) = '1' and bitEnN(16) = '0') then
            field_rw_ACQ_READOUT_CFG4_KEEP_OUT_TRIG_ENA <= reg_writedata(16);
         end if;
      end if;
   end if;
end process P_ACQ_READOUT_CFG4_KEEP_OUT_TRIG_ENA;

------------------------------------------------------------------------------------------
-- Field name: KEEP_OUT_TRIG_START(15 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_READOUT_CFG4(15 downto 0) <= field_rw_ACQ_READOUT_CFG4_KEEP_OUT_TRIG_START(15 downto 0);
regfile.ACQ.READOUT_CFG4.KEEP_OUT_TRIG_START <= field_rw_ACQ_READOUT_CFG4_KEEP_OUT_TRIG_START(15 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_READOUT_CFG4_KEEP_OUT_TRIG_START
------------------------------------------------------------------------------------------
P_ACQ_READOUT_CFG4_KEEP_OUT_TRIG_START : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_READOUT_CFG4_KEEP_OUT_TRIG_START <= std_logic_vector(to_unsigned(integer(65535),16));
      else
         for j in  15 downto 0  loop
            if(wEn(24) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_READOUT_CFG4_KEEP_OUT_TRIG_START(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_READOUT_CFG4_KEEP_OUT_TRIG_START;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_EXP_CTRL1
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(25) <= (hit(25)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: EXPOSURE_LEV_MODE
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_EXP_CTRL1(28) <= field_rw_ACQ_EXP_CTRL1_EXPOSURE_LEV_MODE;
regfile.ACQ.EXP_CTRL1.EXPOSURE_LEV_MODE <= field_rw_ACQ_EXP_CTRL1_EXPOSURE_LEV_MODE;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_EXP_CTRL1_EXPOSURE_LEV_MODE
------------------------------------------------------------------------------------------
P_ACQ_EXP_CTRL1_EXPOSURE_LEV_MODE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_EXP_CTRL1_EXPOSURE_LEV_MODE <= '0';
      else
         if(wEn(25) = '1' and bitEnN(28) = '0') then
            field_rw_ACQ_EXP_CTRL1_EXPOSURE_LEV_MODE <= reg_writedata(28);
         end if;
      end if;
   end if;
end process P_ACQ_EXP_CTRL1_EXPOSURE_LEV_MODE;

------------------------------------------------------------------------------------------
-- Field name: EXPOSURE_SS(27 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_EXP_CTRL1(27 downto 0) <= field_rw_ACQ_EXP_CTRL1_EXPOSURE_SS(27 downto 0);
regfile.ACQ.EXP_CTRL1.EXPOSURE_SS <= field_rw_ACQ_EXP_CTRL1_EXPOSURE_SS(27 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_EXP_CTRL1_EXPOSURE_SS
------------------------------------------------------------------------------------------
P_ACQ_EXP_CTRL1_EXPOSURE_SS : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_EXP_CTRL1_EXPOSURE_SS <= std_logic_vector(to_unsigned(integer(0),28));
      else
         for j in  27 downto 0  loop
            if(wEn(25) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_EXP_CTRL1_EXPOSURE_SS(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_EXP_CTRL1_EXPOSURE_SS;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_EXP_CTRL2
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(26) <= (hit(26)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: EXPOSURE_DS(27 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_EXP_CTRL2(27 downto 0) <= field_rw_ACQ_EXP_CTRL2_EXPOSURE_DS(27 downto 0);
regfile.ACQ.EXP_CTRL2.EXPOSURE_DS <= field_rw_ACQ_EXP_CTRL2_EXPOSURE_DS(27 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_EXP_CTRL2_EXPOSURE_DS
------------------------------------------------------------------------------------------
P_ACQ_EXP_CTRL2_EXPOSURE_DS : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_EXP_CTRL2_EXPOSURE_DS <= std_logic_vector(to_unsigned(integer(0),28));
      else
         for j in  27 downto 0  loop
            if(wEn(26) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_EXP_CTRL2_EXPOSURE_DS(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_EXP_CTRL2_EXPOSURE_DS;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_EXP_CTRL3
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(27) <= (hit(27)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: EXPOSURE_TS(27 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_EXP_CTRL3(27 downto 0) <= field_rw_ACQ_EXP_CTRL3_EXPOSURE_TS(27 downto 0);
regfile.ACQ.EXP_CTRL3.EXPOSURE_TS <= field_rw_ACQ_EXP_CTRL3_EXPOSURE_TS(27 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_EXP_CTRL3_EXPOSURE_TS
------------------------------------------------------------------------------------------
P_ACQ_EXP_CTRL3_EXPOSURE_TS : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_EXP_CTRL3_EXPOSURE_TS <= std_logic_vector(to_unsigned(integer(0),28));
      else
         for j in  27 downto 0  loop
            if(wEn(27) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_EXP_CTRL3_EXPOSURE_TS(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_EXP_CTRL3_EXPOSURE_TS;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_TRIGGER_DELAY
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(28) <= (hit(28)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TRIGGER_DELAY(27 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_TRIGGER_DELAY(27 downto 0) <= field_rw_ACQ_TRIGGER_DELAY_TRIGGER_DELAY(27 downto 0);
regfile.ACQ.TRIGGER_DELAY.TRIGGER_DELAY <= field_rw_ACQ_TRIGGER_DELAY_TRIGGER_DELAY(27 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_TRIGGER_DELAY_TRIGGER_DELAY
------------------------------------------------------------------------------------------
P_ACQ_TRIGGER_DELAY_TRIGGER_DELAY : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_TRIGGER_DELAY_TRIGGER_DELAY <= std_logic_vector(to_unsigned(integer(0),28));
      else
         for j in  27 downto 0  loop
            if(wEn(28) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_TRIGGER_DELAY_TRIGGER_DELAY(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_TRIGGER_DELAY_TRIGGER_DELAY;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_STROBE_CTRL1
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(29) <= (hit(29)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: STROBE_E
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_STROBE_CTRL1(31) <= field_rw_ACQ_STROBE_CTRL1_STROBE_E;
regfile.ACQ.STROBE_CTRL1.STROBE_E <= field_rw_ACQ_STROBE_CTRL1_STROBE_E;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_STROBE_CTRL1_STROBE_E
------------------------------------------------------------------------------------------
P_ACQ_STROBE_CTRL1_STROBE_E : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_STROBE_CTRL1_STROBE_E <= '0';
      else
         if(wEn(29) = '1' and bitEnN(31) = '0') then
            field_rw_ACQ_STROBE_CTRL1_STROBE_E <= reg_writedata(31);
         end if;
      end if;
   end if;
end process P_ACQ_STROBE_CTRL1_STROBE_E;

------------------------------------------------------------------------------------------
-- Field name: STROBE_POL
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_STROBE_CTRL1(28) <= field_rw_ACQ_STROBE_CTRL1_STROBE_POL;
regfile.ACQ.STROBE_CTRL1.STROBE_POL <= field_rw_ACQ_STROBE_CTRL1_STROBE_POL;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_STROBE_CTRL1_STROBE_POL
------------------------------------------------------------------------------------------
P_ACQ_STROBE_CTRL1_STROBE_POL : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_STROBE_CTRL1_STROBE_POL <= '0';
      else
         if(wEn(29) = '1' and bitEnN(28) = '0') then
            field_rw_ACQ_STROBE_CTRL1_STROBE_POL <= reg_writedata(28);
         end if;
      end if;
   end if;
end process P_ACQ_STROBE_CTRL1_STROBE_POL;

------------------------------------------------------------------------------------------
-- Field name: STROBE_START(27 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_STROBE_CTRL1(27 downto 0) <= field_rw_ACQ_STROBE_CTRL1_STROBE_START(27 downto 0);
regfile.ACQ.STROBE_CTRL1.STROBE_START <= field_rw_ACQ_STROBE_CTRL1_STROBE_START(27 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_STROBE_CTRL1_STROBE_START
------------------------------------------------------------------------------------------
P_ACQ_STROBE_CTRL1_STROBE_START : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_STROBE_CTRL1_STROBE_START <= std_logic_vector(to_unsigned(integer(0),28));
      else
         for j in  27 downto 0  loop
            if(wEn(29) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_STROBE_CTRL1_STROBE_START(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_STROBE_CTRL1_STROBE_START;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_STROBE_CTRL2
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(30) <= (hit(30)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: STROBE_MODE
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_STROBE_CTRL2(31) <= field_rw_ACQ_STROBE_CTRL2_STROBE_MODE;
regfile.ACQ.STROBE_CTRL2.STROBE_MODE <= field_rw_ACQ_STROBE_CTRL2_STROBE_MODE;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_STROBE_CTRL2_STROBE_MODE
------------------------------------------------------------------------------------------
P_ACQ_STROBE_CTRL2_STROBE_MODE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_STROBE_CTRL2_STROBE_MODE <= '0';
      else
         if(wEn(30) = '1' and bitEnN(31) = '0') then
            field_rw_ACQ_STROBE_CTRL2_STROBE_MODE <= reg_writedata(31);
         end if;
      end if;
   end if;
end process P_ACQ_STROBE_CTRL2_STROBE_MODE;

------------------------------------------------------------------------------------------
-- Field name: STROBE_B_EN
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_STROBE_CTRL2(29) <= field_rw_ACQ_STROBE_CTRL2_STROBE_B_EN;
regfile.ACQ.STROBE_CTRL2.STROBE_B_EN <= field_rw_ACQ_STROBE_CTRL2_STROBE_B_EN;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_STROBE_CTRL2_STROBE_B_EN
------------------------------------------------------------------------------------------
P_ACQ_STROBE_CTRL2_STROBE_B_EN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_STROBE_CTRL2_STROBE_B_EN <= '0';
      else
         if(wEn(30) = '1' and bitEnN(29) = '0') then
            field_rw_ACQ_STROBE_CTRL2_STROBE_B_EN <= reg_writedata(29);
         end if;
      end if;
   end if;
end process P_ACQ_STROBE_CTRL2_STROBE_B_EN;

------------------------------------------------------------------------------------------
-- Field name: STROBE_A_EN
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_STROBE_CTRL2(28) <= field_rw_ACQ_STROBE_CTRL2_STROBE_A_EN;
regfile.ACQ.STROBE_CTRL2.STROBE_A_EN <= field_rw_ACQ_STROBE_CTRL2_STROBE_A_EN;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_STROBE_CTRL2_STROBE_A_EN
------------------------------------------------------------------------------------------
P_ACQ_STROBE_CTRL2_STROBE_A_EN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_STROBE_CTRL2_STROBE_A_EN <= '1';
      else
         if(wEn(30) = '1' and bitEnN(28) = '0') then
            field_rw_ACQ_STROBE_CTRL2_STROBE_A_EN <= reg_writedata(28);
         end if;
      end if;
   end if;
end process P_ACQ_STROBE_CTRL2_STROBE_A_EN;

------------------------------------------------------------------------------------------
-- Field name: STROBE_END(27 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_STROBE_CTRL2(27 downto 0) <= field_rw_ACQ_STROBE_CTRL2_STROBE_END(27 downto 0);
regfile.ACQ.STROBE_CTRL2.STROBE_END <= field_rw_ACQ_STROBE_CTRL2_STROBE_END(27 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_STROBE_CTRL2_STROBE_END
------------------------------------------------------------------------------------------
P_ACQ_STROBE_CTRL2_STROBE_END : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_STROBE_CTRL2_STROBE_END <= std_logic_vector(to_unsigned(integer(268435455),28));
      else
         for j in  27 downto 0  loop
            if(wEn(30) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_STROBE_CTRL2_STROBE_END(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_STROBE_CTRL2_STROBE_END;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_ACQ_SER_CTRL
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(31) <= (hit(31)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: SER_RWn
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_ACQ_SER_CTRL(16) <= field_rw_ACQ_ACQ_SER_CTRL_SER_RWn;
regfile.ACQ.ACQ_SER_CTRL.SER_RWn <= field_rw_ACQ_ACQ_SER_CTRL_SER_RWn;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_ACQ_SER_CTRL_SER_RWn
------------------------------------------------------------------------------------------
P_ACQ_ACQ_SER_CTRL_SER_RWn : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_ACQ_SER_CTRL_SER_RWn <= '1';
      else
         if(wEn(31) = '1' and bitEnN(16) = '0') then
            field_rw_ACQ_ACQ_SER_CTRL_SER_RWn <= reg_writedata(16);
         end if;
      end if;
   end if;
end process P_ACQ_ACQ_SER_CTRL_SER_RWn;

------------------------------------------------------------------------------------------
-- Field name: SER_CMD(9 downto 8)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_ACQ_SER_CTRL(9 downto 8) <= field_rw_ACQ_ACQ_SER_CTRL_SER_CMD(1 downto 0);
regfile.ACQ.ACQ_SER_CTRL.SER_CMD <= field_rw_ACQ_ACQ_SER_CTRL_SER_CMD(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_ACQ_SER_CTRL_SER_CMD
------------------------------------------------------------------------------------------
P_ACQ_ACQ_SER_CTRL_SER_CMD : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_ACQ_SER_CTRL_SER_CMD <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  9 downto 8  loop
            if(wEn(31) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_ACQ_SER_CTRL_SER_CMD(j-8) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_ACQ_SER_CTRL_SER_CMD;

------------------------------------------------------------------------------------------
-- Field name: SER_RF_SS
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_ACQ_ACQ_SER_CTRL(4) <= '0';
regfile.ACQ.ACQ_SER_CTRL.SER_RF_SS <= field_wautoclr_ACQ_ACQ_SER_CTRL_SER_RF_SS;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_ACQ_SER_CTRL_SER_RF_SS
------------------------------------------------------------------------------------------
P_ACQ_ACQ_SER_CTRL_SER_RF_SS : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_ACQ_ACQ_SER_CTRL_SER_RF_SS <= '0';
      else
         if(wEn(31) = '1' and bitEnN(4) = '0') then
            field_wautoclr_ACQ_ACQ_SER_CTRL_SER_RF_SS <= reg_writedata(4);
         else
            field_wautoclr_ACQ_ACQ_SER_CTRL_SER_RF_SS <= '0';
         end if;
      end if;
   end if;
end process P_ACQ_ACQ_SER_CTRL_SER_RF_SS;

------------------------------------------------------------------------------------------
-- Field name: SER_WF_SS
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_ACQ_ACQ_SER_CTRL(0) <= '0';
regfile.ACQ.ACQ_SER_CTRL.SER_WF_SS <= field_wautoclr_ACQ_ACQ_SER_CTRL_SER_WF_SS;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_ACQ_SER_CTRL_SER_WF_SS
------------------------------------------------------------------------------------------
P_ACQ_ACQ_SER_CTRL_SER_WF_SS : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_ACQ_ACQ_SER_CTRL_SER_WF_SS <= '0';
      else
         if(wEn(31) = '1' and bitEnN(0) = '0') then
            field_wautoclr_ACQ_ACQ_SER_CTRL_SER_WF_SS <= reg_writedata(0);
         else
            field_wautoclr_ACQ_ACQ_SER_CTRL_SER_WF_SS <= '0';
         end if;
      end if;
   end if;
end process P_ACQ_ACQ_SER_CTRL_SER_WF_SS;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_ACQ_SER_ADDATA
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(32) <= (hit(32)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: SER_DAT(31 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_ACQ_SER_ADDATA(31 downto 16) <= field_rw_ACQ_ACQ_SER_ADDATA_SER_DAT(15 downto 0);
regfile.ACQ.ACQ_SER_ADDATA.SER_DAT <= field_rw_ACQ_ACQ_SER_ADDATA_SER_DAT(15 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_ACQ_SER_ADDATA_SER_DAT
------------------------------------------------------------------------------------------
P_ACQ_ACQ_SER_ADDATA_SER_DAT : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_ACQ_SER_ADDATA_SER_DAT <= std_logic_vector(to_unsigned(integer(0),16));
      else
         for j in  31 downto 16  loop
            if(wEn(32) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_ACQ_SER_ADDATA_SER_DAT(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_ACQ_SER_ADDATA_SER_DAT;

------------------------------------------------------------------------------------------
-- Field name: SER_ADD(14 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_ACQ_SER_ADDATA(14 downto 0) <= field_rw_ACQ_ACQ_SER_ADDATA_SER_ADD(14 downto 0);
regfile.ACQ.ACQ_SER_ADDATA.SER_ADD <= field_rw_ACQ_ACQ_SER_ADDATA_SER_ADD(14 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_ACQ_SER_ADDATA_SER_ADD
------------------------------------------------------------------------------------------
P_ACQ_ACQ_SER_ADDATA_SER_ADD : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_ACQ_SER_ADDATA_SER_ADD <= std_logic_vector(to_unsigned(integer(0),15));
      else
         for j in  14 downto 0  loop
            if(wEn(32) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_ACQ_SER_ADDATA_SER_ADD(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_ACQ_SER_ADDATA_SER_ADD;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_ACQ_SER_STAT
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(33) <= (hit(33)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: SER_FIFO_EMPTY
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_ACQ_SER_STAT(24) <= regfile.ACQ.ACQ_SER_STAT.SER_FIFO_EMPTY;


------------------------------------------------------------------------------------------
-- Field name: SER_BUSY
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_ACQ_SER_STAT(16) <= regfile.ACQ.ACQ_SER_STAT.SER_BUSY;


------------------------------------------------------------------------------------------
-- Field name: SER_DAT_R(15 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_ACQ_SER_STAT(15 downto 0) <= regfile.ACQ.ACQ_SER_STAT.SER_DAT_R;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_SENSOR_CTRL
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(34) <= (hit(34)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: SENSOR_REFRESH_TEMP
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_CTRL(24) <= '0';
regfile.ACQ.SENSOR_CTRL.SENSOR_REFRESH_TEMP <= field_wautoclr_ACQ_SENSOR_CTRL_SENSOR_REFRESH_TEMP;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_CTRL_SENSOR_REFRESH_TEMP
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_CTRL_SENSOR_REFRESH_TEMP : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_ACQ_SENSOR_CTRL_SENSOR_REFRESH_TEMP <= '0';
      else
         if(wEn(34) = '1' and bitEnN(24) = '0') then
            field_wautoclr_ACQ_SENSOR_CTRL_SENSOR_REFRESH_TEMP <= reg_writedata(24);
         else
            field_wautoclr_ACQ_SENSOR_CTRL_SENSOR_REFRESH_TEMP <= '0';
         end if;
      end if;
   end if;
end process P_ACQ_SENSOR_CTRL_SENSOR_REFRESH_TEMP;

------------------------------------------------------------------------------------------
-- Field name: SENSOR_POWERDOWN
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_CTRL(16) <= '0';
regfile.ACQ.SENSOR_CTRL.SENSOR_POWERDOWN <= field_wautoclr_ACQ_SENSOR_CTRL_SENSOR_POWERDOWN;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_CTRL_SENSOR_POWERDOWN
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_CTRL_SENSOR_POWERDOWN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_ACQ_SENSOR_CTRL_SENSOR_POWERDOWN <= '0';
      else
         if(wEn(34) = '1' and bitEnN(16) = '0') then
            field_wautoclr_ACQ_SENSOR_CTRL_SENSOR_POWERDOWN <= reg_writedata(16);
         else
            field_wautoclr_ACQ_SENSOR_CTRL_SENSOR_POWERDOWN <= '0';
         end if;
      end if;
   end if;
end process P_ACQ_SENSOR_CTRL_SENSOR_POWERDOWN;

------------------------------------------------------------------------------------------
-- Field name: SENSOR_COLOR
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_CTRL(8) <= field_rw_ACQ_SENSOR_CTRL_SENSOR_COLOR;
regfile.ACQ.SENSOR_CTRL.SENSOR_COLOR <= field_rw_ACQ_SENSOR_CTRL_SENSOR_COLOR;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_CTRL_SENSOR_COLOR
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_CTRL_SENSOR_COLOR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_CTRL_SENSOR_COLOR <= '0';
      else
         if(wEn(34) = '1' and bitEnN(8) = '0') then
            field_rw_ACQ_SENSOR_CTRL_SENSOR_COLOR <= reg_writedata(8);
         end if;
      end if;
   end if;
end process P_ACQ_SENSOR_CTRL_SENSOR_COLOR;

------------------------------------------------------------------------------------------
-- Field name: SENSOR_REG_UPDATE
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_CTRL(4) <= field_rw_ACQ_SENSOR_CTRL_SENSOR_REG_UPDATE;
regfile.ACQ.SENSOR_CTRL.SENSOR_REG_UPDATE <= field_rw_ACQ_SENSOR_CTRL_SENSOR_REG_UPDATE;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_CTRL_SENSOR_REG_UPDATE
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_CTRL_SENSOR_REG_UPDATE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_CTRL_SENSOR_REG_UPDATE <= '1';
      else
         if(wEn(34) = '1' and bitEnN(4) = '0') then
            field_rw_ACQ_SENSOR_CTRL_SENSOR_REG_UPDATE <= reg_writedata(4);
         end if;
      end if;
   end if;
end process P_ACQ_SENSOR_CTRL_SENSOR_REG_UPDATE;

------------------------------------------------------------------------------------------
-- Field name: SENSOR_RESETN
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_CTRL(1) <= field_rw_ACQ_SENSOR_CTRL_SENSOR_RESETN;
regfile.ACQ.SENSOR_CTRL.SENSOR_RESETN <= field_rw_ACQ_SENSOR_CTRL_SENSOR_RESETN;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_CTRL_SENSOR_RESETN
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_CTRL_SENSOR_RESETN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_CTRL_SENSOR_RESETN <= '1';
      else
         if(wEn(34) = '1' and bitEnN(1) = '0') then
            field_rw_ACQ_SENSOR_CTRL_SENSOR_RESETN <= reg_writedata(1);
         end if;
      end if;
   end if;
end process P_ACQ_SENSOR_CTRL_SENSOR_RESETN;

------------------------------------------------------------------------------------------
-- Field name: SENSOR_POWERUP
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_CTRL(0) <= '0';
regfile.ACQ.SENSOR_CTRL.SENSOR_POWERUP <= field_wautoclr_ACQ_SENSOR_CTRL_SENSOR_POWERUP;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_CTRL_SENSOR_POWERUP
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_CTRL_SENSOR_POWERUP : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_ACQ_SENSOR_CTRL_SENSOR_POWERUP <= '0';
      else
         if(wEn(34) = '1' and bitEnN(0) = '0') then
            field_wautoclr_ACQ_SENSOR_CTRL_SENSOR_POWERUP <= reg_writedata(0);
         else
            field_wautoclr_ACQ_SENSOR_CTRL_SENSOR_POWERUP <= '0';
         end if;
      end if;
   end if;
end process P_ACQ_SENSOR_CTRL_SENSOR_POWERUP;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_SENSOR_STAT
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(35) <= (hit(35)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: SENSOR_TEMP(7 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_STAT(31 downto 24) <= regfile.ACQ.SENSOR_STAT.SENSOR_TEMP;


------------------------------------------------------------------------------------------
-- Field name: SENSOR_TEMP_VALID
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_STAT(23) <= regfile.ACQ.SENSOR_STAT.SENSOR_TEMP_VALID;


------------------------------------------------------------------------------------------
-- Field name: SENSOR_POWERDOWN
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_STAT(16) <= regfile.ACQ.SENSOR_STAT.SENSOR_POWERDOWN;


------------------------------------------------------------------------------------------
-- Field name: SENSOR_RESETN
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_STAT(13) <= regfile.ACQ.SENSOR_STAT.SENSOR_RESETN;


------------------------------------------------------------------------------------------
-- Field name: SENSOR_OSC_EN
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_STAT(12) <= regfile.ACQ.SENSOR_STAT.SENSOR_OSC_EN;


------------------------------------------------------------------------------------------
-- Field name: SENSOR_VCC_PG
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_STAT(8) <= regfile.ACQ.SENSOR_STAT.SENSOR_VCC_PG;


------------------------------------------------------------------------------------------
-- Field name: SENSOR_POWERUP_STAT
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_STAT(1) <= regfile.ACQ.SENSOR_STAT.SENSOR_POWERUP_STAT;


------------------------------------------------------------------------------------------
-- Field name: SENSOR_POWERUP_DONE
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_STAT(0) <= regfile.ACQ.SENSOR_STAT.SENSOR_POWERUP_DONE;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_SENSOR_SUBSAMPLING
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(36) <= (hit(36)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: reserved1
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_SUBSAMPLING(15 downto 4) <= std_logic_vector(to_unsigned(integer(0),12));
regfile.ACQ.SENSOR_SUBSAMPLING.reserved1 <= rb_ACQ_SENSOR_SUBSAMPLING(15 downto 4);


------------------------------------------------------------------------------------------
-- Field name: ACTIVE_SUBSAMPLING_Y
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_SUBSAMPLING(3) <= field_rw_ACQ_SENSOR_SUBSAMPLING_ACTIVE_SUBSAMPLING_Y;
regfile.ACQ.SENSOR_SUBSAMPLING.ACTIVE_SUBSAMPLING_Y <= field_rw_ACQ_SENSOR_SUBSAMPLING_ACTIVE_SUBSAMPLING_Y;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_SUBSAMPLING_ACTIVE_SUBSAMPLING_Y
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_SUBSAMPLING_ACTIVE_SUBSAMPLING_Y : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_SUBSAMPLING_ACTIVE_SUBSAMPLING_Y <= '0';
      else
         if(wEn(36) = '1' and bitEnN(3) = '0') then
            field_rw_ACQ_SENSOR_SUBSAMPLING_ACTIVE_SUBSAMPLING_Y <= reg_writedata(3);
         end if;
      end if;
   end if;
end process P_ACQ_SENSOR_SUBSAMPLING_ACTIVE_SUBSAMPLING_Y;

------------------------------------------------------------------------------------------
-- Field name: reserved0
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_SUBSAMPLING(2) <= '0';
regfile.ACQ.SENSOR_SUBSAMPLING.reserved0 <= rb_ACQ_SENSOR_SUBSAMPLING(2);


------------------------------------------------------------------------------------------
-- Field name: M_SUBSAMPLING_Y
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_SUBSAMPLING(1) <= field_rw_ACQ_SENSOR_SUBSAMPLING_M_SUBSAMPLING_Y;
regfile.ACQ.SENSOR_SUBSAMPLING.M_SUBSAMPLING_Y <= field_rw_ACQ_SENSOR_SUBSAMPLING_M_SUBSAMPLING_Y;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_SUBSAMPLING_M_SUBSAMPLING_Y
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_SUBSAMPLING_M_SUBSAMPLING_Y : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_SUBSAMPLING_M_SUBSAMPLING_Y <= '0';
      else
         if(wEn(36) = '1' and bitEnN(1) = '0') then
            field_rw_ACQ_SENSOR_SUBSAMPLING_M_SUBSAMPLING_Y <= reg_writedata(1);
         end if;
      end if;
   end if;
end process P_ACQ_SENSOR_SUBSAMPLING_M_SUBSAMPLING_Y;

------------------------------------------------------------------------------------------
-- Field name: SUBSAMPLING_X
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_SUBSAMPLING(0) <= field_rw_ACQ_SENSOR_SUBSAMPLING_SUBSAMPLING_X;
regfile.ACQ.SENSOR_SUBSAMPLING.SUBSAMPLING_X <= field_rw_ACQ_SENSOR_SUBSAMPLING_SUBSAMPLING_X;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_SUBSAMPLING_SUBSAMPLING_X
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_SUBSAMPLING_SUBSAMPLING_X : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_SUBSAMPLING_SUBSAMPLING_X <= '0';
      else
         if(wEn(36) = '1' and bitEnN(0) = '0') then
            field_rw_ACQ_SENSOR_SUBSAMPLING_SUBSAMPLING_X <= reg_writedata(0);
         end if;
      end if;
   end if;
end process P_ACQ_SENSOR_SUBSAMPLING_SUBSAMPLING_X;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_SENSOR_GAIN_ANA
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(37) <= (hit(37)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: reserved1
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_GAIN_ANA(15 downto 11) <= std_logic_vector(to_unsigned(integer(0),5));
regfile.ACQ.SENSOR_GAIN_ANA.reserved1 <= rb_ACQ_SENSOR_GAIN_ANA(15 downto 11);


------------------------------------------------------------------------------------------
-- Field name: ANALOG_GAIN(10 downto 8)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_GAIN_ANA(10 downto 8) <= field_rw_ACQ_SENSOR_GAIN_ANA_ANALOG_GAIN(2 downto 0);
regfile.ACQ.SENSOR_GAIN_ANA.ANALOG_GAIN <= field_rw_ACQ_SENSOR_GAIN_ANA_ANALOG_GAIN(2 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_GAIN_ANA_ANALOG_GAIN
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_GAIN_ANA_ANALOG_GAIN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_GAIN_ANA_ANALOG_GAIN <= std_logic_vector(to_unsigned(integer(1),3));
      else
         for j in  10 downto 8  loop
            if(wEn(37) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_GAIN_ANA_ANALOG_GAIN(j-8) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_GAIN_ANA_ANALOG_GAIN;

------------------------------------------------------------------------------------------
-- Field name: reserved0
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_GAIN_ANA(7 downto 0) <= std_logic_vector(to_unsigned(integer(0),8));
regfile.ACQ.SENSOR_GAIN_ANA.reserved0 <= rb_ACQ_SENSOR_GAIN_ANA(7 downto 0);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_SENSOR_ROI_Y_START
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(38) <= (hit(38)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: reserved
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_ROI_Y_START(15 downto 10) <= std_logic_vector(to_unsigned(integer(0),6));
regfile.ACQ.SENSOR_ROI_Y_START.reserved <= rb_ACQ_SENSOR_ROI_Y_START(15 downto 10);


------------------------------------------------------------------------------------------
-- Field name: Y_START(9 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_ROI_Y_START(9 downto 0) <= field_rw_ACQ_SENSOR_ROI_Y_START_Y_START(9 downto 0);
regfile.ACQ.SENSOR_ROI_Y_START.Y_START <= field_rw_ACQ_SENSOR_ROI_Y_START_Y_START(9 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_ROI_Y_START_Y_START
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_ROI_Y_START_Y_START : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_ROI_Y_START_Y_START <= std_logic_vector(to_unsigned(integer(0),10));
      else
         for j in  9 downto 0  loop
            if(wEn(38) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_ROI_Y_START_Y_START(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_ROI_Y_START_Y_START;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_SENSOR_ROI_Y_SIZE
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(39) <= (hit(39)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: reserved
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_ROI_Y_SIZE(15 downto 10) <= std_logic_vector(to_unsigned(integer(0),6));
regfile.ACQ.SENSOR_ROI_Y_SIZE.reserved <= rb_ACQ_SENSOR_ROI_Y_SIZE(15 downto 10);


------------------------------------------------------------------------------------------
-- Field name: Y_SIZE(9 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_ROI_Y_SIZE(9 downto 0) <= field_rw_ACQ_SENSOR_ROI_Y_SIZE_Y_SIZE(9 downto 0);
regfile.ACQ.SENSOR_ROI_Y_SIZE.Y_SIZE <= field_rw_ACQ_SENSOR_ROI_Y_SIZE_Y_SIZE(9 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_ROI_Y_SIZE_Y_SIZE
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_ROI_Y_SIZE_Y_SIZE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_ROI_Y_SIZE_Y_SIZE <= std_logic_vector(to_unsigned(integer(770),10));
      else
         for j in  9 downto 0  loop
            if(wEn(39) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_ROI_Y_SIZE_Y_SIZE(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_ROI_Y_SIZE_Y_SIZE;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_SENSOR_M_LINES
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(40) <= (hit(40)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: M_LINES_DISPLAY
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_M_LINES(15) <= field_rw_ACQ_SENSOR_M_LINES_M_LINES_DISPLAY;
regfile.ACQ.SENSOR_M_LINES.M_LINES_DISPLAY <= field_rw_ACQ_SENSOR_M_LINES_M_LINES_DISPLAY;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_M_LINES_M_LINES_DISPLAY
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_M_LINES_M_LINES_DISPLAY : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_M_LINES_M_LINES_DISPLAY <= '0';
      else
         if(wEn(40) = '1' and bitEnN(15) = '0') then
            field_rw_ACQ_SENSOR_M_LINES_M_LINES_DISPLAY <= reg_writedata(15);
         end if;
      end if;
   end if;
end process P_ACQ_SENSOR_M_LINES_M_LINES_DISPLAY;

------------------------------------------------------------------------------------------
-- Field name: M_SUPPRESSED(14 downto 10)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_M_LINES(14 downto 10) <= field_rw_ACQ_SENSOR_M_LINES_M_SUPPRESSED(4 downto 0);
regfile.ACQ.SENSOR_M_LINES.M_SUPPRESSED <= field_rw_ACQ_SENSOR_M_LINES_M_SUPPRESSED(4 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_M_LINES_M_SUPPRESSED
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_M_LINES_M_SUPPRESSED : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_M_LINES_M_SUPPRESSED <= std_logic_vector(to_unsigned(integer(0),5));
      else
         for j in  14 downto 10  loop
            if(wEn(40) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_M_LINES_M_SUPPRESSED(j-10) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_M_LINES_M_SUPPRESSED;

------------------------------------------------------------------------------------------
-- Field name: M_LINES_SENSOR(9 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_M_LINES(9 downto 0) <= field_rw_ACQ_SENSOR_M_LINES_M_LINES_SENSOR(9 downto 0);
regfile.ACQ.SENSOR_M_LINES.M_LINES_SENSOR <= field_rw_ACQ_SENSOR_M_LINES_M_LINES_SENSOR(9 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_M_LINES_M_LINES_SENSOR
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_M_LINES_M_LINES_SENSOR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_M_LINES_M_LINES_SENSOR <= std_logic_vector(to_unsigned(integer(8),10));
      else
         for j in  9 downto 0  loop
            if(wEn(40) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_M_LINES_M_LINES_SENSOR(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_M_LINES_M_LINES_SENSOR;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_SENSOR_DP_GR
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(41) <= (hit(41)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: reserved
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_DP_GR(15 downto 12) <= std_logic_vector(to_unsigned(integer(0),4));
regfile.ACQ.SENSOR_DP_GR.reserved <= rb_ACQ_SENSOR_DP_GR(15 downto 12);


------------------------------------------------------------------------------------------
-- Field name: DP_OFFSET_GR(11 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_DP_GR(11 downto 0) <= field_rw_ACQ_SENSOR_DP_GR_DP_OFFSET_GR(11 downto 0);
regfile.ACQ.SENSOR_DP_GR.DP_OFFSET_GR <= field_rw_ACQ_SENSOR_DP_GR_DP_OFFSET_GR(11 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_DP_GR_DP_OFFSET_GR
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_DP_GR_DP_OFFSET_GR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_DP_GR_DP_OFFSET_GR <= std_logic_vector(to_unsigned(integer(256),12));
      else
         for j in  11 downto 0  loop
            if(wEn(41) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_DP_GR_DP_OFFSET_GR(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_DP_GR_DP_OFFSET_GR;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_SENSOR_DP_GB
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(42) <= (hit(42)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: reserved
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_DP_GB(15 downto 12) <= std_logic_vector(to_unsigned(integer(0),4));
regfile.ACQ.SENSOR_DP_GB.reserved <= rb_ACQ_SENSOR_DP_GB(15 downto 12);


------------------------------------------------------------------------------------------
-- Field name: DP_OFFSET_GB(11 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_DP_GB(11 downto 0) <= field_rw_ACQ_SENSOR_DP_GB_DP_OFFSET_GB(11 downto 0);
regfile.ACQ.SENSOR_DP_GB.DP_OFFSET_GB <= field_rw_ACQ_SENSOR_DP_GB_DP_OFFSET_GB(11 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_DP_GB_DP_OFFSET_GB
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_DP_GB_DP_OFFSET_GB : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_DP_GB_DP_OFFSET_GB <= std_logic_vector(to_unsigned(integer(256),12));
      else
         for j in  11 downto 0  loop
            if(wEn(42) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_DP_GB_DP_OFFSET_GB(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_DP_GB_DP_OFFSET_GB;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_SENSOR_DP_R
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(43) <= (hit(43)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: reserved
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_DP_R(15 downto 12) <= std_logic_vector(to_unsigned(integer(0),4));
regfile.ACQ.SENSOR_DP_R.reserved <= rb_ACQ_SENSOR_DP_R(15 downto 12);


------------------------------------------------------------------------------------------
-- Field name: DP_OFFSET_R(11 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_DP_R(11 downto 0) <= field_rw_ACQ_SENSOR_DP_R_DP_OFFSET_R(11 downto 0);
regfile.ACQ.SENSOR_DP_R.DP_OFFSET_R <= field_rw_ACQ_SENSOR_DP_R_DP_OFFSET_R(11 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_DP_R_DP_OFFSET_R
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_DP_R_DP_OFFSET_R : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_DP_R_DP_OFFSET_R <= std_logic_vector(to_unsigned(integer(256),12));
      else
         for j in  11 downto 0  loop
            if(wEn(43) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_DP_R_DP_OFFSET_R(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_DP_R_DP_OFFSET_R;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_SENSOR_DP_B
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(44) <= (hit(44)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: reserved
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_DP_B(15 downto 12) <= std_logic_vector(to_unsigned(integer(0),4));
regfile.ACQ.SENSOR_DP_B.reserved <= rb_ACQ_SENSOR_DP_B(15 downto 12);


------------------------------------------------------------------------------------------
-- Field name: DP_OFFSET_B(11 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_DP_B(11 downto 0) <= field_rw_ACQ_SENSOR_DP_B_DP_OFFSET_B(11 downto 0);
regfile.ACQ.SENSOR_DP_B.DP_OFFSET_B <= field_rw_ACQ_SENSOR_DP_B_DP_OFFSET_B(11 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_DP_B_DP_OFFSET_B
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_DP_B_DP_OFFSET_B : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_DP_B_DP_OFFSET_B <= std_logic_vector(to_unsigned(integer(256),12));
      else
         for j in  11 downto 0  loop
            if(wEn(44) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_DP_B_DP_OFFSET_B(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_DP_B_DP_OFFSET_B;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_SENSOR_GAIN_DIG_G
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(45) <= (hit(45)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: reserved1
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_GAIN_DIG_G(15) <= '0';
regfile.ACQ.SENSOR_GAIN_DIG_G.reserved1 <= rb_ACQ_SENSOR_GAIN_DIG_G(15);


------------------------------------------------------------------------------------------
-- Field name: DG_FACTOR_GR(14 downto 8)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_GAIN_DIG_G(14 downto 8) <= field_rw_ACQ_SENSOR_GAIN_DIG_G_DG_FACTOR_GR(6 downto 0);
regfile.ACQ.SENSOR_GAIN_DIG_G.DG_FACTOR_GR <= field_rw_ACQ_SENSOR_GAIN_DIG_G_DG_FACTOR_GR(6 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_GAIN_DIG_G_DG_FACTOR_GR
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_GAIN_DIG_G_DG_FACTOR_GR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_GAIN_DIG_G_DG_FACTOR_GR <= std_logic_vector(to_unsigned(integer(32),7));
      else
         for j in  14 downto 8  loop
            if(wEn(45) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_GAIN_DIG_G_DG_FACTOR_GR(j-8) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_GAIN_DIG_G_DG_FACTOR_GR;

------------------------------------------------------------------------------------------
-- Field name: reserved0
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_GAIN_DIG_G(7) <= '0';
regfile.ACQ.SENSOR_GAIN_DIG_G.reserved0 <= rb_ACQ_SENSOR_GAIN_DIG_G(7);


------------------------------------------------------------------------------------------
-- Field name: DG_FACTOR_GB(6 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_GAIN_DIG_G(6 downto 0) <= field_rw_ACQ_SENSOR_GAIN_DIG_G_DG_FACTOR_GB(6 downto 0);
regfile.ACQ.SENSOR_GAIN_DIG_G.DG_FACTOR_GB <= field_rw_ACQ_SENSOR_GAIN_DIG_G_DG_FACTOR_GB(6 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_GAIN_DIG_G_DG_FACTOR_GB
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_GAIN_DIG_G_DG_FACTOR_GB : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_GAIN_DIG_G_DG_FACTOR_GB <= std_logic_vector(to_unsigned(integer(32),7));
      else
         for j in  6 downto 0  loop
            if(wEn(45) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_GAIN_DIG_G_DG_FACTOR_GB(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_GAIN_DIG_G_DG_FACTOR_GB;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_SENSOR_GAIN_DIG_RB
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(46) <= (hit(46)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: reserved1
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_GAIN_DIG_RB(15) <= '0';
regfile.ACQ.SENSOR_GAIN_DIG_RB.reserved1 <= rb_ACQ_SENSOR_GAIN_DIG_RB(15);


------------------------------------------------------------------------------------------
-- Field name: DG_FACTOR_R(14 downto 8)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_GAIN_DIG_RB(14 downto 8) <= field_rw_ACQ_SENSOR_GAIN_DIG_RB_DG_FACTOR_R(6 downto 0);
regfile.ACQ.SENSOR_GAIN_DIG_RB.DG_FACTOR_R <= field_rw_ACQ_SENSOR_GAIN_DIG_RB_DG_FACTOR_R(6 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_GAIN_DIG_RB_DG_FACTOR_R
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_GAIN_DIG_RB_DG_FACTOR_R : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_GAIN_DIG_RB_DG_FACTOR_R <= std_logic_vector(to_unsigned(integer(32),7));
      else
         for j in  14 downto 8  loop
            if(wEn(46) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_GAIN_DIG_RB_DG_FACTOR_R(j-8) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_GAIN_DIG_RB_DG_FACTOR_R;

------------------------------------------------------------------------------------------
-- Field name: reserved0
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_GAIN_DIG_RB(7) <= '0';
regfile.ACQ.SENSOR_GAIN_DIG_RB.reserved0 <= rb_ACQ_SENSOR_GAIN_DIG_RB(7);


------------------------------------------------------------------------------------------
-- Field name: DG_FACTOR_B(6 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_GAIN_DIG_RB(6 downto 0) <= field_rw_ACQ_SENSOR_GAIN_DIG_RB_DG_FACTOR_B(6 downto 0);
regfile.ACQ.SENSOR_GAIN_DIG_RB.DG_FACTOR_B <= field_rw_ACQ_SENSOR_GAIN_DIG_RB_DG_FACTOR_B(6 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_GAIN_DIG_RB_DG_FACTOR_B
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_GAIN_DIG_RB_DG_FACTOR_B : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_GAIN_DIG_RB_DG_FACTOR_B <= std_logic_vector(to_unsigned(integer(32),7));
      else
         for j in  6 downto 0  loop
            if(wEn(46) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_GAIN_DIG_RB_DG_FACTOR_B(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_GAIN_DIG_RB_DG_FACTOR_B;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_DEBUG_PINS
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(47) <= (hit(47)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: Debug3_sel(28 downto 24)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_DEBUG_PINS(28 downto 24) <= field_rw_ACQ_DEBUG_PINS_Debug3_sel(4 downto 0);
regfile.ACQ.DEBUG_PINS.Debug3_sel <= field_rw_ACQ_DEBUG_PINS_Debug3_sel(4 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_DEBUG_PINS_Debug3_sel
------------------------------------------------------------------------------------------
P_ACQ_DEBUG_PINS_Debug3_sel : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_DEBUG_PINS_Debug3_sel <= std_logic_vector(to_unsigned(integer(31),5));
      else
         for j in  28 downto 24  loop
            if(wEn(47) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_DEBUG_PINS_Debug3_sel(j-24) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_DEBUG_PINS_Debug3_sel;

------------------------------------------------------------------------------------------
-- Field name: Debug2_sel(20 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_DEBUG_PINS(20 downto 16) <= field_rw_ACQ_DEBUG_PINS_Debug2_sel(4 downto 0);
regfile.ACQ.DEBUG_PINS.Debug2_sel <= field_rw_ACQ_DEBUG_PINS_Debug2_sel(4 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_DEBUG_PINS_Debug2_sel
------------------------------------------------------------------------------------------
P_ACQ_DEBUG_PINS_Debug2_sel : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_DEBUG_PINS_Debug2_sel <= std_logic_vector(to_unsigned(integer(31),5));
      else
         for j in  20 downto 16  loop
            if(wEn(47) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_DEBUG_PINS_Debug2_sel(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_DEBUG_PINS_Debug2_sel;

------------------------------------------------------------------------------------------
-- Field name: Debug1_sel(12 downto 8)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_DEBUG_PINS(12 downto 8) <= field_rw_ACQ_DEBUG_PINS_Debug1_sel(4 downto 0);
regfile.ACQ.DEBUG_PINS.Debug1_sel <= field_rw_ACQ_DEBUG_PINS_Debug1_sel(4 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_DEBUG_PINS_Debug1_sel
------------------------------------------------------------------------------------------
P_ACQ_DEBUG_PINS_Debug1_sel : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_DEBUG_PINS_Debug1_sel <= std_logic_vector(to_unsigned(integer(31),5));
      else
         for j in  12 downto 8  loop
            if(wEn(47) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_DEBUG_PINS_Debug1_sel(j-8) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_DEBUG_PINS_Debug1_sel;

------------------------------------------------------------------------------------------
-- Field name: Debug0_sel(4 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_DEBUG_PINS(4 downto 0) <= field_rw_ACQ_DEBUG_PINS_Debug0_sel(4 downto 0);
regfile.ACQ.DEBUG_PINS.Debug0_sel <= field_rw_ACQ_DEBUG_PINS_Debug0_sel(4 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_DEBUG_PINS_Debug0_sel
------------------------------------------------------------------------------------------
P_ACQ_DEBUG_PINS_Debug0_sel : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_DEBUG_PINS_Debug0_sel <= std_logic_vector(to_unsigned(integer(31),5));
      else
         for j in  4 downto 0  loop
            if(wEn(47) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_DEBUG_PINS_Debug0_sel(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_DEBUG_PINS_Debug0_sel;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_TRIGGER_MISSED
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(48) <= (hit(48)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TRIGGER_MISSED_RST
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_ACQ_TRIGGER_MISSED(28) <= '0';
regfile.ACQ.TRIGGER_MISSED.TRIGGER_MISSED_RST <= field_wautoclr_ACQ_TRIGGER_MISSED_TRIGGER_MISSED_RST;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_TRIGGER_MISSED_TRIGGER_MISSED_RST
------------------------------------------------------------------------------------------
P_ACQ_TRIGGER_MISSED_TRIGGER_MISSED_RST : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_ACQ_TRIGGER_MISSED_TRIGGER_MISSED_RST <= '0';
      else
         if(wEn(48) = '1' and bitEnN(28) = '0') then
            field_wautoclr_ACQ_TRIGGER_MISSED_TRIGGER_MISSED_RST <= reg_writedata(28);
         else
            field_wautoclr_ACQ_TRIGGER_MISSED_TRIGGER_MISSED_RST <= '0';
         end if;
      end if;
   end if;
end process P_ACQ_TRIGGER_MISSED_TRIGGER_MISSED_RST;

------------------------------------------------------------------------------------------
-- Field name: TRIGGER_MISSED_CNTR(15 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_TRIGGER_MISSED(15 downto 0) <= regfile.ACQ.TRIGGER_MISSED.TRIGGER_MISSED_CNTR;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_SENSOR_FPS
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(49) <= (hit(49)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: SENSOR_FPS(15 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_FPS(15 downto 0) <= regfile.ACQ.SENSOR_FPS.SENSOR_FPS;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_SENSOR_FPS2
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(50) <= (hit(50)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: SENSOR_FPS(19 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_FPS2(19 downto 0) <= regfile.ACQ.SENSOR_FPS2.SENSOR_FPS;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_DEBUG
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(51) <= (hit(51)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: DEBUG_RST_CNTR
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_DEBUG(28) <= field_rw_ACQ_DEBUG_DEBUG_RST_CNTR;
regfile.ACQ.DEBUG.DEBUG_RST_CNTR <= field_rw_ACQ_DEBUG_DEBUG_RST_CNTR;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_DEBUG_DEBUG_RST_CNTR
------------------------------------------------------------------------------------------
P_ACQ_DEBUG_DEBUG_RST_CNTR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_DEBUG_DEBUG_RST_CNTR <= '1';
      else
         if(wEn(51) = '1' and bitEnN(28) = '0') then
            field_rw_ACQ_DEBUG_DEBUG_RST_CNTR <= reg_writedata(28);
         end if;
      end if;
   end if;
end process P_ACQ_DEBUG_DEBUG_RST_CNTR;

------------------------------------------------------------------------------------------
-- Field name: LED_TEST_COLOR(2 downto 1)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_DEBUG(2 downto 1) <= field_rw_ACQ_DEBUG_LED_TEST_COLOR(1 downto 0);
regfile.ACQ.DEBUG.LED_TEST_COLOR <= field_rw_ACQ_DEBUG_LED_TEST_COLOR(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_DEBUG_LED_TEST_COLOR
------------------------------------------------------------------------------------------
P_ACQ_DEBUG_LED_TEST_COLOR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_DEBUG_LED_TEST_COLOR <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  2 downto 1  loop
            if(wEn(51) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_DEBUG_LED_TEST_COLOR(j-1) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_DEBUG_LED_TEST_COLOR;

------------------------------------------------------------------------------------------
-- Field name: LED_TEST
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_DEBUG(0) <= field_rw_ACQ_DEBUG_LED_TEST;
regfile.ACQ.DEBUG.LED_TEST <= field_rw_ACQ_DEBUG_LED_TEST;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_DEBUG_LED_TEST
------------------------------------------------------------------------------------------
P_ACQ_DEBUG_LED_TEST : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_DEBUG_LED_TEST <= '0';
      else
         if(wEn(51) = '1' and bitEnN(0) = '0') then
            field_rw_ACQ_DEBUG_LED_TEST <= reg_writedata(0);
         end if;
      end if;
   end if;
end process P_ACQ_DEBUG_LED_TEST;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_DEBUG_CNTR1
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(52) <= (hit(52)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: SENSOR_FRAME_DURATION(27 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_DEBUG_CNTR1(27 downto 0) <= regfile.ACQ.DEBUG_CNTR1.SENSOR_FRAME_DURATION;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_DEBUG_CNTR2
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(53) <= (hit(53)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: EOF_CNTR(31 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_DEBUG_CNTR2(31 downto 0) <= regfile.ACQ.DEBUG_CNTR2.EOF_CNTR;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_DEBUG_CNTR3
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(54) <= (hit(54)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TRIG_INT_CNTR(31 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_DEBUG_CNTR3(31 downto 0) <= regfile.ACQ.DEBUG_CNTR3.TRIG_INT_CNTR;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_EXP_FOT
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(55) <= (hit(55)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: EXP_FOT
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_EXP_FOT(16) <= field_rw_ACQ_EXP_FOT_EXP_FOT;
regfile.ACQ.EXP_FOT.EXP_FOT <= field_rw_ACQ_EXP_FOT_EXP_FOT;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_EXP_FOT_EXP_FOT
------------------------------------------------------------------------------------------
P_ACQ_EXP_FOT_EXP_FOT : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_EXP_FOT_EXP_FOT <= '1';
      else
         if(wEn(55) = '1' and bitEnN(16) = '0') then
            field_rw_ACQ_EXP_FOT_EXP_FOT <= reg_writedata(16);
         end if;
      end if;
   end if;
end process P_ACQ_EXP_FOT_EXP_FOT;

------------------------------------------------------------------------------------------
-- Field name: EXP_FOT_TIME(15 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_EXP_FOT(15 downto 0) <= field_rw_ACQ_EXP_FOT_EXP_FOT_TIME(15 downto 0);
regfile.ACQ.EXP_FOT.EXP_FOT_TIME <= field_rw_ACQ_EXP_FOT_EXP_FOT_TIME(15 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_EXP_FOT_EXP_FOT_TIME
------------------------------------------------------------------------------------------
P_ACQ_EXP_FOT_EXP_FOT_TIME : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_EXP_FOT_EXP_FOT_TIME <= std_logic_vector(to_unsigned(integer(2542),16));
      else
         for j in  15 downto 0  loop
            if(wEn(55) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_EXP_FOT_EXP_FOT_TIME(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_EXP_FOT_EXP_FOT_TIME;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_ACQ_SFNC
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(56) <= (hit(56)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: RELOAD_GRAB_PARAMS
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_ACQ_SFNC(0) <= field_rw_ACQ_ACQ_SFNC_RELOAD_GRAB_PARAMS;
regfile.ACQ.ACQ_SFNC.RELOAD_GRAB_PARAMS <= field_rw_ACQ_ACQ_SFNC_RELOAD_GRAB_PARAMS;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_ACQ_SFNC_RELOAD_GRAB_PARAMS
------------------------------------------------------------------------------------------
P_ACQ_ACQ_SFNC_RELOAD_GRAB_PARAMS : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_ACQ_SFNC_RELOAD_GRAB_PARAMS <= '1';
      else
         if(wEn(56) = '1' and bitEnN(0) = '0') then
            field_rw_ACQ_ACQ_SFNC_RELOAD_GRAB_PARAMS <= reg_writedata(0);
         end if;
      end if;
   end if;
end process P_ACQ_ACQ_SFNC_RELOAD_GRAB_PARAMS;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_TIMER_CTRL
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(57) <= (hit(57)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: ADAPTATIVE
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_TIMER_CTRL(8) <= field_rw_ACQ_TIMER_CTRL_ADAPTATIVE;
regfile.ACQ.TIMER_CTRL.ADAPTATIVE <= field_rw_ACQ_TIMER_CTRL_ADAPTATIVE;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_TIMER_CTRL_ADAPTATIVE
------------------------------------------------------------------------------------------
P_ACQ_TIMER_CTRL_ADAPTATIVE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_TIMER_CTRL_ADAPTATIVE <= '1';
      else
         if(wEn(57) = '1' and bitEnN(8) = '0') then
            field_rw_ACQ_TIMER_CTRL_ADAPTATIVE <= reg_writedata(8);
         end if;
      end if;
   end if;
end process P_ACQ_TIMER_CTRL_ADAPTATIVE;

------------------------------------------------------------------------------------------
-- Field name: TIMERSTOP
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_ACQ_TIMER_CTRL(4) <= '0';
regfile.ACQ.TIMER_CTRL.TIMERSTOP <= field_wautoclr_ACQ_TIMER_CTRL_TIMERSTOP;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_TIMER_CTRL_TIMERSTOP
------------------------------------------------------------------------------------------
P_ACQ_TIMER_CTRL_TIMERSTOP : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_ACQ_TIMER_CTRL_TIMERSTOP <= '0';
      else
         if(wEn(57) = '1' and bitEnN(4) = '0') then
            field_wautoclr_ACQ_TIMER_CTRL_TIMERSTOP <= reg_writedata(4);
         else
            field_wautoclr_ACQ_TIMER_CTRL_TIMERSTOP <= '0';
         end if;
      end if;
   end if;
end process P_ACQ_TIMER_CTRL_TIMERSTOP;

------------------------------------------------------------------------------------------
-- Field name: TIMERSTART
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_ACQ_TIMER_CTRL(0) <= '0';
regfile.ACQ.TIMER_CTRL.TIMERSTART <= field_wautoclr_ACQ_TIMER_CTRL_TIMERSTART;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_TIMER_CTRL_TIMERSTART
------------------------------------------------------------------------------------------
P_ACQ_TIMER_CTRL_TIMERSTART : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_ACQ_TIMER_CTRL_TIMERSTART <= '0';
      else
         if(wEn(57) = '1' and bitEnN(0) = '0') then
            field_wautoclr_ACQ_TIMER_CTRL_TIMERSTART <= reg_writedata(0);
         else
            field_wautoclr_ACQ_TIMER_CTRL_TIMERSTART <= '0';
         end if;
      end if;
   end if;
end process P_ACQ_TIMER_CTRL_TIMERSTART;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_TIMER_DELAY
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(58) <= (hit(58)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: VALUE(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_TIMER_DELAY(31 downto 0) <= field_rw_ACQ_TIMER_DELAY_VALUE(31 downto 0);
regfile.ACQ.TIMER_DELAY.VALUE <= field_rw_ACQ_TIMER_DELAY_VALUE(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_TIMER_DELAY_VALUE
------------------------------------------------------------------------------------------
P_ACQ_TIMER_DELAY_VALUE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_TIMER_DELAY_VALUE <= X"00000000";
      else
         for j in  31 downto 0  loop
            if(wEn(58) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_TIMER_DELAY_VALUE(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_TIMER_DELAY_VALUE;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_TIMER_DURATION
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(59) <= (hit(59)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: VALUE(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_TIMER_DURATION(31 downto 0) <= field_rw_ACQ_TIMER_DURATION_VALUE(31 downto 0);
regfile.ACQ.TIMER_DURATION.VALUE <= field_rw_ACQ_TIMER_DURATION_VALUE(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_TIMER_DURATION_VALUE
------------------------------------------------------------------------------------------
P_ACQ_TIMER_DURATION_VALUE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_TIMER_DURATION_VALUE <= X"00000000";
      else
         for j in  31 downto 0  loop
            if(wEn(59) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_TIMER_DURATION_VALUE(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_TIMER_DURATION_VALUE;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: HISPI_CTRL
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(60) <= (hit(60)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: SW_CLR_IDELAYCTRL
-- Field type: RW
------------------------------------------------------------------------------------------
rb_HISPI_CTRL(4) <= field_rw_HISPI_CTRL_SW_CLR_IDELAYCTRL;
regfile.HISPI.CTRL.SW_CLR_IDELAYCTRL <= field_rw_HISPI_CTRL_SW_CLR_IDELAYCTRL;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_CTRL_SW_CLR_IDELAYCTRL
------------------------------------------------------------------------------------------
P_HISPI_CTRL_SW_CLR_IDELAYCTRL : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_HISPI_CTRL_SW_CLR_IDELAYCTRL <= '1';
      else
         if(wEn(60) = '1' and bitEnN(4) = '0') then
            field_rw_HISPI_CTRL_SW_CLR_IDELAYCTRL <= reg_writedata(4);
         end if;
      end if;
   end if;
end process P_HISPI_CTRL_SW_CLR_IDELAYCTRL;

------------------------------------------------------------------------------------------
-- Field name: SW_CLR_HISPI
-- Field type: RW
------------------------------------------------------------------------------------------
rb_HISPI_CTRL(3) <= field_rw_HISPI_CTRL_SW_CLR_HISPI;
regfile.HISPI.CTRL.SW_CLR_HISPI <= field_rw_HISPI_CTRL_SW_CLR_HISPI;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_CTRL_SW_CLR_HISPI
------------------------------------------------------------------------------------------
P_HISPI_CTRL_SW_CLR_HISPI : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_HISPI_CTRL_SW_CLR_HISPI <= '0';
      else
         if(wEn(60) = '1' and bitEnN(3) = '0') then
            field_rw_HISPI_CTRL_SW_CLR_HISPI <= reg_writedata(3);
         end if;
      end if;
   end if;
end process P_HISPI_CTRL_SW_CLR_HISPI;

------------------------------------------------------------------------------------------
-- Field name: SW_CALIB_SERDES
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_HISPI_CTRL(2) <= '0';
regfile.HISPI.CTRL.SW_CALIB_SERDES <= field_wautoclr_HISPI_CTRL_SW_CALIB_SERDES;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_CTRL_SW_CALIB_SERDES
------------------------------------------------------------------------------------------
P_HISPI_CTRL_SW_CALIB_SERDES : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_HISPI_CTRL_SW_CALIB_SERDES <= '0';
      else
         if(wEn(60) = '1' and bitEnN(2) = '0') then
            field_wautoclr_HISPI_CTRL_SW_CALIB_SERDES <= reg_writedata(2);
         else
            field_wautoclr_HISPI_CTRL_SW_CALIB_SERDES <= '0';
         end if;
      end if;
   end if;
end process P_HISPI_CTRL_SW_CALIB_SERDES;

------------------------------------------------------------------------------------------
-- Field name: ENABLE_DATA_PATH
-- Field type: RW
------------------------------------------------------------------------------------------
rb_HISPI_CTRL(1) <= field_rw_HISPI_CTRL_ENABLE_DATA_PATH;
regfile.HISPI.CTRL.ENABLE_DATA_PATH <= field_rw_HISPI_CTRL_ENABLE_DATA_PATH;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_CTRL_ENABLE_DATA_PATH
------------------------------------------------------------------------------------------
P_HISPI_CTRL_ENABLE_DATA_PATH : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_HISPI_CTRL_ENABLE_DATA_PATH <= '0';
      else
         if(wEn(60) = '1' and bitEnN(1) = '0') then
            field_rw_HISPI_CTRL_ENABLE_DATA_PATH <= reg_writedata(1);
         end if;
      end if;
   end if;
end process P_HISPI_CTRL_ENABLE_DATA_PATH;

------------------------------------------------------------------------------------------
-- Field name: ENABLE_HISPI
-- Field type: RW
------------------------------------------------------------------------------------------
rb_HISPI_CTRL(0) <= field_rw_HISPI_CTRL_ENABLE_HISPI;
regfile.HISPI.CTRL.ENABLE_HISPI <= field_rw_HISPI_CTRL_ENABLE_HISPI;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_CTRL_ENABLE_HISPI
------------------------------------------------------------------------------------------
P_HISPI_CTRL_ENABLE_HISPI : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_HISPI_CTRL_ENABLE_HISPI <= '0';
      else
         if(wEn(60) = '1' and bitEnN(0) = '0') then
            field_rw_HISPI_CTRL_ENABLE_HISPI <= reg_writedata(0);
         end if;
      end if;
   end if;
end process P_HISPI_CTRL_ENABLE_HISPI;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: HISPI_STATUS
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(61) <= (hit(61)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: FSM(3 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_HISPI_STATUS(31 downto 28) <= regfile.HISPI.STATUS.FSM;


------------------------------------------------------------------------------------------
-- Field name: CRC_ERROR
-- Field type: RO
------------------------------------------------------------------------------------------
rb_HISPI_STATUS(4) <= regfile.HISPI.STATUS.CRC_ERROR;


------------------------------------------------------------------------------------------
-- Field name: PHY_BIT_LOCKED_ERROR
-- Field type: RO
------------------------------------------------------------------------------------------
rb_HISPI_STATUS(3) <= regfile.HISPI.STATUS.PHY_BIT_LOCKED_ERROR;


------------------------------------------------------------------------------------------
-- Field name: FIFO_ERROR
-- Field type: RO
------------------------------------------------------------------------------------------
rb_HISPI_STATUS(2) <= regfile.HISPI.STATUS.FIFO_ERROR;


------------------------------------------------------------------------------------------
-- Field name: CALIBRATION_ERROR
-- Field type: RO
------------------------------------------------------------------------------------------
rb_HISPI_STATUS(1) <= regfile.HISPI.STATUS.CALIBRATION_ERROR;


------------------------------------------------------------------------------------------
-- Field name: CALIBRATION_DONE
-- Field type: RO
------------------------------------------------------------------------------------------
rb_HISPI_STATUS(0) <= regfile.HISPI.STATUS.CALIBRATION_DONE;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: HISPI_IDELAYCTRL_STATUS
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(62) <= (hit(62)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: PLL_LOCKED
-- Field type: RO
------------------------------------------------------------------------------------------
rb_HISPI_IDELAYCTRL_STATUS(0) <= regfile.HISPI.IDELAYCTRL_STATUS.PLL_LOCKED;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: HISPI_IDLE_CHARACTER
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(63) <= (hit(63)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: VALUE(11 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_HISPI_IDLE_CHARACTER(11 downto 0) <= field_rw_HISPI_IDLE_CHARACTER_VALUE(11 downto 0);
regfile.HISPI.IDLE_CHARACTER.VALUE <= field_rw_HISPI_IDLE_CHARACTER_VALUE(11 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_HISPI_IDLE_CHARACTER_VALUE
------------------------------------------------------------------------------------------
P_HISPI_IDLE_CHARACTER_VALUE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_HISPI_IDLE_CHARACTER_VALUE <= std_logic_vector(to_unsigned(integer(934),12));
      else
         for j in  11 downto 0  loop
            if(wEn(63) = '1' and bitEnN(j) = '0') then
               field_rw_HISPI_IDLE_CHARACTER_VALUE(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_HISPI_IDLE_CHARACTER_VALUE;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: HISPI_PHY
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(64) <= (hit(64)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: PIXEL_PER_LANE(25 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_HISPI_PHY(25 downto 16) <= field_rw_HISPI_PHY_PIXEL_PER_LANE(9 downto 0);
regfile.HISPI.PHY.PIXEL_PER_LANE <= field_rw_HISPI_PHY_PIXEL_PER_LANE(9 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_HISPI_PHY_PIXEL_PER_LANE
------------------------------------------------------------------------------------------
P_HISPI_PHY_PIXEL_PER_LANE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_HISPI_PHY_PIXEL_PER_LANE <= std_logic_vector(to_unsigned(integer(174),10));
      else
         for j in  25 downto 16  loop
            if(wEn(64) = '1' and bitEnN(j) = '0') then
               field_rw_HISPI_PHY_PIXEL_PER_LANE(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_HISPI_PHY_PIXEL_PER_LANE;

------------------------------------------------------------------------------------------
-- Field name: MUX_RATIO
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_HISPI_PHY(10 downto 8) <= std_logic_vector(to_unsigned(integer(4),3));
regfile.HISPI.PHY.MUX_RATIO <= rb_HISPI_PHY(10 downto 8);


------------------------------------------------------------------------------------------
-- Field name: NB_LANES(2 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_HISPI_PHY(2 downto 0) <= field_rw_HISPI_PHY_NB_LANES(2 downto 0);
regfile.HISPI.PHY.NB_LANES <= field_rw_HISPI_PHY_NB_LANES(2 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_HISPI_PHY_NB_LANES
------------------------------------------------------------------------------------------
P_HISPI_PHY_NB_LANES : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_HISPI_PHY_NB_LANES <= std_logic_vector(to_unsigned(integer(0),3));
      else
         for j in  2 downto 0  loop
            if(wEn(64) = '1' and bitEnN(j) = '0') then
               field_rw_HISPI_PHY_NB_LANES(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_HISPI_PHY_NB_LANES;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: HISPI_FRAME_CFG
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(65) <= (hit(65)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: LINES_PER_FRAME(27 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_HISPI_FRAME_CFG(27 downto 16) <= field_rw_HISPI_FRAME_CFG_LINES_PER_FRAME(11 downto 0);
regfile.HISPI.FRAME_CFG.LINES_PER_FRAME <= field_rw_HISPI_FRAME_CFG_LINES_PER_FRAME(11 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_HISPI_FRAME_CFG_LINES_PER_FRAME
------------------------------------------------------------------------------------------
P_HISPI_FRAME_CFG_LINES_PER_FRAME : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_HISPI_FRAME_CFG_LINES_PER_FRAME <= std_logic_vector(to_unsigned(integer(3102),12));
      else
         for j in  27 downto 16  loop
            if(wEn(65) = '1' and bitEnN(j) = '0') then
               field_rw_HISPI_FRAME_CFG_LINES_PER_FRAME(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_HISPI_FRAME_CFG_LINES_PER_FRAME;

------------------------------------------------------------------------------------------
-- Field name: PIXELS_PER_LINE(12 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_HISPI_FRAME_CFG(12 downto 0) <= field_rw_HISPI_FRAME_CFG_PIXELS_PER_LINE(12 downto 0);
regfile.HISPI.FRAME_CFG.PIXELS_PER_LINE <= field_rw_HISPI_FRAME_CFG_PIXELS_PER_LINE(12 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_HISPI_FRAME_CFG_PIXELS_PER_LINE
------------------------------------------------------------------------------------------
P_HISPI_FRAME_CFG_PIXELS_PER_LINE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_HISPI_FRAME_CFG_PIXELS_PER_LINE <= std_logic_vector(to_unsigned(integer(4176),13));
      else
         for j in  12 downto 0  loop
            if(wEn(65) = '1' and bitEnN(j) = '0') then
               field_rw_HISPI_FRAME_CFG_PIXELS_PER_LINE(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_HISPI_FRAME_CFG_PIXELS_PER_LINE;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: HISPI_FRAME_CFG_X_VALID
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(66) <= (hit(66)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: X_END(28 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_HISPI_FRAME_CFG_X_VALID(28 downto 16) <= field_rw_HISPI_FRAME_CFG_X_VALID_X_END(12 downto 0);
regfile.HISPI.FRAME_CFG_X_VALID.X_END <= field_rw_HISPI_FRAME_CFG_X_VALID_X_END(12 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_HISPI_FRAME_CFG_X_VALID_X_END
------------------------------------------------------------------------------------------
P_HISPI_FRAME_CFG_X_VALID_X_END : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_HISPI_FRAME_CFG_X_VALID_X_END <= std_logic_vector(to_unsigned(integer(4131),13));
      else
         for j in  28 downto 16  loop
            if(wEn(66) = '1' and bitEnN(j) = '0') then
               field_rw_HISPI_FRAME_CFG_X_VALID_X_END(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_HISPI_FRAME_CFG_X_VALID_X_END;

------------------------------------------------------------------------------------------
-- Field name: X_START(12 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_HISPI_FRAME_CFG_X_VALID(12 downto 0) <= field_rw_HISPI_FRAME_CFG_X_VALID_X_START(12 downto 0);
regfile.HISPI.FRAME_CFG_X_VALID.X_START <= field_rw_HISPI_FRAME_CFG_X_VALID_X_START(12 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_HISPI_FRAME_CFG_X_VALID_X_START
------------------------------------------------------------------------------------------
P_HISPI_FRAME_CFG_X_VALID_X_START : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_HISPI_FRAME_CFG_X_VALID_X_START <= std_logic_vector(to_unsigned(integer(36),13));
      else
         for j in  12 downto 0  loop
            if(wEn(66) = '1' and bitEnN(j) = '0') then
               field_rw_HISPI_FRAME_CFG_X_VALID_X_START(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_HISPI_FRAME_CFG_X_VALID_X_START;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: HISPI_LANE_DECODER_STATUS_0
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(67) <= (hit(67)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: CRC_ERROR
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_0(15) <= field_rw2c_HISPI_LANE_DECODER_STATUS_0_CRC_ERROR;
regfile.HISPI.LANE_DECODER_STATUS(0).CRC_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_0_CRC_ERROR;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_LANE_DECODER_STATUS_0_CRC_ERROR
------------------------------------------------------------------------------------------
P_HISPI_LANE_DECODER_STATUS_0_CRC_ERROR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_HISPI_LANE_DECODER_STATUS_0_CRC_ERROR <= '0';
      else
         if(wEn(67) = '1' and reg_writedata(15) = '1' and bitEnN(15) = '0') then
            -- Clear the field to '0'
            field_rw2c_HISPI_LANE_DECODER_STATUS_0_CRC_ERROR <= '0';
         else
            -- Set the field to '1'
            field_rw2c_HISPI_LANE_DECODER_STATUS_0_CRC_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_0_CRC_ERROR or regfile.HISPI.LANE_DECODER_STATUS(0).CRC_ERROR_set;
         end if;
      end if;
   end if;
end process P_HISPI_LANE_DECODER_STATUS_0_CRC_ERROR;

------------------------------------------------------------------------------------------
-- Field name: PHY_SYNC_ERROR
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_0(14) <= field_rw2c_HISPI_LANE_DECODER_STATUS_0_PHY_SYNC_ERROR;
regfile.HISPI.LANE_DECODER_STATUS(0).PHY_SYNC_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_0_PHY_SYNC_ERROR;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_LANE_DECODER_STATUS_0_PHY_SYNC_ERROR
------------------------------------------------------------------------------------------
P_HISPI_LANE_DECODER_STATUS_0_PHY_SYNC_ERROR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_HISPI_LANE_DECODER_STATUS_0_PHY_SYNC_ERROR <= '0';
      else
         if(wEn(67) = '1' and reg_writedata(14) = '1' and bitEnN(14) = '0') then
            -- Clear the field to '0'
            field_rw2c_HISPI_LANE_DECODER_STATUS_0_PHY_SYNC_ERROR <= '0';
         else
            -- Set the field to '1'
            field_rw2c_HISPI_LANE_DECODER_STATUS_0_PHY_SYNC_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_0_PHY_SYNC_ERROR or regfile.HISPI.LANE_DECODER_STATUS(0).PHY_SYNC_ERROR_set;
         end if;
      end if;
   end if;
end process P_HISPI_LANE_DECODER_STATUS_0_PHY_SYNC_ERROR;

------------------------------------------------------------------------------------------
-- Field name: PHY_BIT_LOCKED_ERROR
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_0(13) <= field_rw2c_HISPI_LANE_DECODER_STATUS_0_PHY_BIT_LOCKED_ERROR;
regfile.HISPI.LANE_DECODER_STATUS(0).PHY_BIT_LOCKED_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_0_PHY_BIT_LOCKED_ERROR;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_LANE_DECODER_STATUS_0_PHY_BIT_LOCKED_ERROR
------------------------------------------------------------------------------------------
P_HISPI_LANE_DECODER_STATUS_0_PHY_BIT_LOCKED_ERROR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_HISPI_LANE_DECODER_STATUS_0_PHY_BIT_LOCKED_ERROR <= '0';
      else
         if(wEn(67) = '1' and reg_writedata(13) = '1' and bitEnN(13) = '0') then
            -- Clear the field to '0'
            field_rw2c_HISPI_LANE_DECODER_STATUS_0_PHY_BIT_LOCKED_ERROR <= '0';
         else
            -- Set the field to '1'
            field_rw2c_HISPI_LANE_DECODER_STATUS_0_PHY_BIT_LOCKED_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_0_PHY_BIT_LOCKED_ERROR or regfile.HISPI.LANE_DECODER_STATUS(0).PHY_BIT_LOCKED_ERROR_set;
         end if;
      end if;
   end if;
end process P_HISPI_LANE_DECODER_STATUS_0_PHY_BIT_LOCKED_ERROR;

------------------------------------------------------------------------------------------
-- Field name: PHY_BIT_LOCKED
-- Field type: RO
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_0(12) <= regfile.HISPI.LANE_DECODER_STATUS(0).PHY_BIT_LOCKED;


------------------------------------------------------------------------------------------
-- Field name: CALIBRATION_TAP_VALUE(4 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_0(8 downto 4) <= regfile.HISPI.LANE_DECODER_STATUS(0).CALIBRATION_TAP_VALUE;


------------------------------------------------------------------------------------------
-- Field name: CALIBRATION_ERROR
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_0(3) <= field_rw2c_HISPI_LANE_DECODER_STATUS_0_CALIBRATION_ERROR;
regfile.HISPI.LANE_DECODER_STATUS(0).CALIBRATION_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_0_CALIBRATION_ERROR;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_LANE_DECODER_STATUS_0_CALIBRATION_ERROR
------------------------------------------------------------------------------------------
P_HISPI_LANE_DECODER_STATUS_0_CALIBRATION_ERROR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_HISPI_LANE_DECODER_STATUS_0_CALIBRATION_ERROR <= '0';
      else
         if(wEn(67) = '1' and reg_writedata(3) = '1' and bitEnN(3) = '0') then
            -- Clear the field to '0'
            field_rw2c_HISPI_LANE_DECODER_STATUS_0_CALIBRATION_ERROR <= '0';
         else
            -- Set the field to '1'
            field_rw2c_HISPI_LANE_DECODER_STATUS_0_CALIBRATION_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_0_CALIBRATION_ERROR or regfile.HISPI.LANE_DECODER_STATUS(0).CALIBRATION_ERROR_set;
         end if;
      end if;
   end if;
end process P_HISPI_LANE_DECODER_STATUS_0_CALIBRATION_ERROR;

------------------------------------------------------------------------------------------
-- Field name: CALIBRATION_DONE
-- Field type: RO
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_0(2) <= regfile.HISPI.LANE_DECODER_STATUS(0).CALIBRATION_DONE;


------------------------------------------------------------------------------------------
-- Field name: FIFO_UNDERRUN
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_0(1) <= field_rw2c_HISPI_LANE_DECODER_STATUS_0_FIFO_UNDERRUN;
regfile.HISPI.LANE_DECODER_STATUS(0).FIFO_UNDERRUN <= field_rw2c_HISPI_LANE_DECODER_STATUS_0_FIFO_UNDERRUN;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_LANE_DECODER_STATUS_0_FIFO_UNDERRUN
------------------------------------------------------------------------------------------
P_HISPI_LANE_DECODER_STATUS_0_FIFO_UNDERRUN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_HISPI_LANE_DECODER_STATUS_0_FIFO_UNDERRUN <= '0';
      else
         if(wEn(67) = '1' and reg_writedata(1) = '1' and bitEnN(1) = '0') then
            -- Clear the field to '0'
            field_rw2c_HISPI_LANE_DECODER_STATUS_0_FIFO_UNDERRUN <= '0';
         else
            -- Set the field to '1'
            field_rw2c_HISPI_LANE_DECODER_STATUS_0_FIFO_UNDERRUN <= field_rw2c_HISPI_LANE_DECODER_STATUS_0_FIFO_UNDERRUN or regfile.HISPI.LANE_DECODER_STATUS(0).FIFO_UNDERRUN_set;
         end if;
      end if;
   end if;
end process P_HISPI_LANE_DECODER_STATUS_0_FIFO_UNDERRUN;

------------------------------------------------------------------------------------------
-- Field name: FIFO_OVERRUN
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_0(0) <= field_rw2c_HISPI_LANE_DECODER_STATUS_0_FIFO_OVERRUN;
regfile.HISPI.LANE_DECODER_STATUS(0).FIFO_OVERRUN <= field_rw2c_HISPI_LANE_DECODER_STATUS_0_FIFO_OVERRUN;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_LANE_DECODER_STATUS_0_FIFO_OVERRUN
------------------------------------------------------------------------------------------
P_HISPI_LANE_DECODER_STATUS_0_FIFO_OVERRUN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_HISPI_LANE_DECODER_STATUS_0_FIFO_OVERRUN <= '0';
      else
         if(wEn(67) = '1' and reg_writedata(0) = '1' and bitEnN(0) = '0') then
            -- Clear the field to '0'
            field_rw2c_HISPI_LANE_DECODER_STATUS_0_FIFO_OVERRUN <= '0';
         else
            -- Set the field to '1'
            field_rw2c_HISPI_LANE_DECODER_STATUS_0_FIFO_OVERRUN <= field_rw2c_HISPI_LANE_DECODER_STATUS_0_FIFO_OVERRUN or regfile.HISPI.LANE_DECODER_STATUS(0).FIFO_OVERRUN_set;
         end if;
      end if;
   end if;
end process P_HISPI_LANE_DECODER_STATUS_0_FIFO_OVERRUN;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: HISPI_LANE_DECODER_STATUS_1
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(68) <= (hit(68)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: CRC_ERROR
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_1(15) <= field_rw2c_HISPI_LANE_DECODER_STATUS_1_CRC_ERROR;
regfile.HISPI.LANE_DECODER_STATUS(1).CRC_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_1_CRC_ERROR;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_LANE_DECODER_STATUS_1_CRC_ERROR
------------------------------------------------------------------------------------------
P_HISPI_LANE_DECODER_STATUS_1_CRC_ERROR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_HISPI_LANE_DECODER_STATUS_1_CRC_ERROR <= '0';
      else
         if(wEn(68) = '1' and reg_writedata(15) = '1' and bitEnN(15) = '0') then
            -- Clear the field to '0'
            field_rw2c_HISPI_LANE_DECODER_STATUS_1_CRC_ERROR <= '0';
         else
            -- Set the field to '1'
            field_rw2c_HISPI_LANE_DECODER_STATUS_1_CRC_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_1_CRC_ERROR or regfile.HISPI.LANE_DECODER_STATUS(1).CRC_ERROR_set;
         end if;
      end if;
   end if;
end process P_HISPI_LANE_DECODER_STATUS_1_CRC_ERROR;

------------------------------------------------------------------------------------------
-- Field name: PHY_SYNC_ERROR
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_1(14) <= field_rw2c_HISPI_LANE_DECODER_STATUS_1_PHY_SYNC_ERROR;
regfile.HISPI.LANE_DECODER_STATUS(1).PHY_SYNC_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_1_PHY_SYNC_ERROR;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_LANE_DECODER_STATUS_1_PHY_SYNC_ERROR
------------------------------------------------------------------------------------------
P_HISPI_LANE_DECODER_STATUS_1_PHY_SYNC_ERROR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_HISPI_LANE_DECODER_STATUS_1_PHY_SYNC_ERROR <= '0';
      else
         if(wEn(68) = '1' and reg_writedata(14) = '1' and bitEnN(14) = '0') then
            -- Clear the field to '0'
            field_rw2c_HISPI_LANE_DECODER_STATUS_1_PHY_SYNC_ERROR <= '0';
         else
            -- Set the field to '1'
            field_rw2c_HISPI_LANE_DECODER_STATUS_1_PHY_SYNC_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_1_PHY_SYNC_ERROR or regfile.HISPI.LANE_DECODER_STATUS(1).PHY_SYNC_ERROR_set;
         end if;
      end if;
   end if;
end process P_HISPI_LANE_DECODER_STATUS_1_PHY_SYNC_ERROR;

------------------------------------------------------------------------------------------
-- Field name: PHY_BIT_LOCKED_ERROR
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_1(13) <= field_rw2c_HISPI_LANE_DECODER_STATUS_1_PHY_BIT_LOCKED_ERROR;
regfile.HISPI.LANE_DECODER_STATUS(1).PHY_BIT_LOCKED_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_1_PHY_BIT_LOCKED_ERROR;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_LANE_DECODER_STATUS_1_PHY_BIT_LOCKED_ERROR
------------------------------------------------------------------------------------------
P_HISPI_LANE_DECODER_STATUS_1_PHY_BIT_LOCKED_ERROR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_HISPI_LANE_DECODER_STATUS_1_PHY_BIT_LOCKED_ERROR <= '0';
      else
         if(wEn(68) = '1' and reg_writedata(13) = '1' and bitEnN(13) = '0') then
            -- Clear the field to '0'
            field_rw2c_HISPI_LANE_DECODER_STATUS_1_PHY_BIT_LOCKED_ERROR <= '0';
         else
            -- Set the field to '1'
            field_rw2c_HISPI_LANE_DECODER_STATUS_1_PHY_BIT_LOCKED_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_1_PHY_BIT_LOCKED_ERROR or regfile.HISPI.LANE_DECODER_STATUS(1).PHY_BIT_LOCKED_ERROR_set;
         end if;
      end if;
   end if;
end process P_HISPI_LANE_DECODER_STATUS_1_PHY_BIT_LOCKED_ERROR;

------------------------------------------------------------------------------------------
-- Field name: PHY_BIT_LOCKED
-- Field type: RO
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_1(12) <= regfile.HISPI.LANE_DECODER_STATUS(1).PHY_BIT_LOCKED;


------------------------------------------------------------------------------------------
-- Field name: CALIBRATION_TAP_VALUE(4 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_1(8 downto 4) <= regfile.HISPI.LANE_DECODER_STATUS(1).CALIBRATION_TAP_VALUE;


------------------------------------------------------------------------------------------
-- Field name: CALIBRATION_ERROR
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_1(3) <= field_rw2c_HISPI_LANE_DECODER_STATUS_1_CALIBRATION_ERROR;
regfile.HISPI.LANE_DECODER_STATUS(1).CALIBRATION_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_1_CALIBRATION_ERROR;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_LANE_DECODER_STATUS_1_CALIBRATION_ERROR
------------------------------------------------------------------------------------------
P_HISPI_LANE_DECODER_STATUS_1_CALIBRATION_ERROR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_HISPI_LANE_DECODER_STATUS_1_CALIBRATION_ERROR <= '0';
      else
         if(wEn(68) = '1' and reg_writedata(3) = '1' and bitEnN(3) = '0') then
            -- Clear the field to '0'
            field_rw2c_HISPI_LANE_DECODER_STATUS_1_CALIBRATION_ERROR <= '0';
         else
            -- Set the field to '1'
            field_rw2c_HISPI_LANE_DECODER_STATUS_1_CALIBRATION_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_1_CALIBRATION_ERROR or regfile.HISPI.LANE_DECODER_STATUS(1).CALIBRATION_ERROR_set;
         end if;
      end if;
   end if;
end process P_HISPI_LANE_DECODER_STATUS_1_CALIBRATION_ERROR;

------------------------------------------------------------------------------------------
-- Field name: CALIBRATION_DONE
-- Field type: RO
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_1(2) <= regfile.HISPI.LANE_DECODER_STATUS(1).CALIBRATION_DONE;


------------------------------------------------------------------------------------------
-- Field name: FIFO_UNDERRUN
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_1(1) <= field_rw2c_HISPI_LANE_DECODER_STATUS_1_FIFO_UNDERRUN;
regfile.HISPI.LANE_DECODER_STATUS(1).FIFO_UNDERRUN <= field_rw2c_HISPI_LANE_DECODER_STATUS_1_FIFO_UNDERRUN;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_LANE_DECODER_STATUS_1_FIFO_UNDERRUN
------------------------------------------------------------------------------------------
P_HISPI_LANE_DECODER_STATUS_1_FIFO_UNDERRUN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_HISPI_LANE_DECODER_STATUS_1_FIFO_UNDERRUN <= '0';
      else
         if(wEn(68) = '1' and reg_writedata(1) = '1' and bitEnN(1) = '0') then
            -- Clear the field to '0'
            field_rw2c_HISPI_LANE_DECODER_STATUS_1_FIFO_UNDERRUN <= '0';
         else
            -- Set the field to '1'
            field_rw2c_HISPI_LANE_DECODER_STATUS_1_FIFO_UNDERRUN <= field_rw2c_HISPI_LANE_DECODER_STATUS_1_FIFO_UNDERRUN or regfile.HISPI.LANE_DECODER_STATUS(1).FIFO_UNDERRUN_set;
         end if;
      end if;
   end if;
end process P_HISPI_LANE_DECODER_STATUS_1_FIFO_UNDERRUN;

------------------------------------------------------------------------------------------
-- Field name: FIFO_OVERRUN
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_1(0) <= field_rw2c_HISPI_LANE_DECODER_STATUS_1_FIFO_OVERRUN;
regfile.HISPI.LANE_DECODER_STATUS(1).FIFO_OVERRUN <= field_rw2c_HISPI_LANE_DECODER_STATUS_1_FIFO_OVERRUN;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_LANE_DECODER_STATUS_1_FIFO_OVERRUN
------------------------------------------------------------------------------------------
P_HISPI_LANE_DECODER_STATUS_1_FIFO_OVERRUN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_HISPI_LANE_DECODER_STATUS_1_FIFO_OVERRUN <= '0';
      else
         if(wEn(68) = '1' and reg_writedata(0) = '1' and bitEnN(0) = '0') then
            -- Clear the field to '0'
            field_rw2c_HISPI_LANE_DECODER_STATUS_1_FIFO_OVERRUN <= '0';
         else
            -- Set the field to '1'
            field_rw2c_HISPI_LANE_DECODER_STATUS_1_FIFO_OVERRUN <= field_rw2c_HISPI_LANE_DECODER_STATUS_1_FIFO_OVERRUN or regfile.HISPI.LANE_DECODER_STATUS(1).FIFO_OVERRUN_set;
         end if;
      end if;
   end if;
end process P_HISPI_LANE_DECODER_STATUS_1_FIFO_OVERRUN;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: HISPI_LANE_DECODER_STATUS_2
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(69) <= (hit(69)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: CRC_ERROR
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_2(15) <= field_rw2c_HISPI_LANE_DECODER_STATUS_2_CRC_ERROR;
regfile.HISPI.LANE_DECODER_STATUS(2).CRC_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_2_CRC_ERROR;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_LANE_DECODER_STATUS_2_CRC_ERROR
------------------------------------------------------------------------------------------
P_HISPI_LANE_DECODER_STATUS_2_CRC_ERROR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_HISPI_LANE_DECODER_STATUS_2_CRC_ERROR <= '0';
      else
         if(wEn(69) = '1' and reg_writedata(15) = '1' and bitEnN(15) = '0') then
            -- Clear the field to '0'
            field_rw2c_HISPI_LANE_DECODER_STATUS_2_CRC_ERROR <= '0';
         else
            -- Set the field to '1'
            field_rw2c_HISPI_LANE_DECODER_STATUS_2_CRC_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_2_CRC_ERROR or regfile.HISPI.LANE_DECODER_STATUS(2).CRC_ERROR_set;
         end if;
      end if;
   end if;
end process P_HISPI_LANE_DECODER_STATUS_2_CRC_ERROR;

------------------------------------------------------------------------------------------
-- Field name: PHY_SYNC_ERROR
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_2(14) <= field_rw2c_HISPI_LANE_DECODER_STATUS_2_PHY_SYNC_ERROR;
regfile.HISPI.LANE_DECODER_STATUS(2).PHY_SYNC_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_2_PHY_SYNC_ERROR;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_LANE_DECODER_STATUS_2_PHY_SYNC_ERROR
------------------------------------------------------------------------------------------
P_HISPI_LANE_DECODER_STATUS_2_PHY_SYNC_ERROR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_HISPI_LANE_DECODER_STATUS_2_PHY_SYNC_ERROR <= '0';
      else
         if(wEn(69) = '1' and reg_writedata(14) = '1' and bitEnN(14) = '0') then
            -- Clear the field to '0'
            field_rw2c_HISPI_LANE_DECODER_STATUS_2_PHY_SYNC_ERROR <= '0';
         else
            -- Set the field to '1'
            field_rw2c_HISPI_LANE_DECODER_STATUS_2_PHY_SYNC_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_2_PHY_SYNC_ERROR or regfile.HISPI.LANE_DECODER_STATUS(2).PHY_SYNC_ERROR_set;
         end if;
      end if;
   end if;
end process P_HISPI_LANE_DECODER_STATUS_2_PHY_SYNC_ERROR;

------------------------------------------------------------------------------------------
-- Field name: PHY_BIT_LOCKED_ERROR
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_2(13) <= field_rw2c_HISPI_LANE_DECODER_STATUS_2_PHY_BIT_LOCKED_ERROR;
regfile.HISPI.LANE_DECODER_STATUS(2).PHY_BIT_LOCKED_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_2_PHY_BIT_LOCKED_ERROR;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_LANE_DECODER_STATUS_2_PHY_BIT_LOCKED_ERROR
------------------------------------------------------------------------------------------
P_HISPI_LANE_DECODER_STATUS_2_PHY_BIT_LOCKED_ERROR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_HISPI_LANE_DECODER_STATUS_2_PHY_BIT_LOCKED_ERROR <= '0';
      else
         if(wEn(69) = '1' and reg_writedata(13) = '1' and bitEnN(13) = '0') then
            -- Clear the field to '0'
            field_rw2c_HISPI_LANE_DECODER_STATUS_2_PHY_BIT_LOCKED_ERROR <= '0';
         else
            -- Set the field to '1'
            field_rw2c_HISPI_LANE_DECODER_STATUS_2_PHY_BIT_LOCKED_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_2_PHY_BIT_LOCKED_ERROR or regfile.HISPI.LANE_DECODER_STATUS(2).PHY_BIT_LOCKED_ERROR_set;
         end if;
      end if;
   end if;
end process P_HISPI_LANE_DECODER_STATUS_2_PHY_BIT_LOCKED_ERROR;

------------------------------------------------------------------------------------------
-- Field name: PHY_BIT_LOCKED
-- Field type: RO
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_2(12) <= regfile.HISPI.LANE_DECODER_STATUS(2).PHY_BIT_LOCKED;


------------------------------------------------------------------------------------------
-- Field name: CALIBRATION_TAP_VALUE(4 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_2(8 downto 4) <= regfile.HISPI.LANE_DECODER_STATUS(2).CALIBRATION_TAP_VALUE;


------------------------------------------------------------------------------------------
-- Field name: CALIBRATION_ERROR
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_2(3) <= field_rw2c_HISPI_LANE_DECODER_STATUS_2_CALIBRATION_ERROR;
regfile.HISPI.LANE_DECODER_STATUS(2).CALIBRATION_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_2_CALIBRATION_ERROR;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_LANE_DECODER_STATUS_2_CALIBRATION_ERROR
------------------------------------------------------------------------------------------
P_HISPI_LANE_DECODER_STATUS_2_CALIBRATION_ERROR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_HISPI_LANE_DECODER_STATUS_2_CALIBRATION_ERROR <= '0';
      else
         if(wEn(69) = '1' and reg_writedata(3) = '1' and bitEnN(3) = '0') then
            -- Clear the field to '0'
            field_rw2c_HISPI_LANE_DECODER_STATUS_2_CALIBRATION_ERROR <= '0';
         else
            -- Set the field to '1'
            field_rw2c_HISPI_LANE_DECODER_STATUS_2_CALIBRATION_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_2_CALIBRATION_ERROR or regfile.HISPI.LANE_DECODER_STATUS(2).CALIBRATION_ERROR_set;
         end if;
      end if;
   end if;
end process P_HISPI_LANE_DECODER_STATUS_2_CALIBRATION_ERROR;

------------------------------------------------------------------------------------------
-- Field name: CALIBRATION_DONE
-- Field type: RO
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_2(2) <= regfile.HISPI.LANE_DECODER_STATUS(2).CALIBRATION_DONE;


------------------------------------------------------------------------------------------
-- Field name: FIFO_UNDERRUN
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_2(1) <= field_rw2c_HISPI_LANE_DECODER_STATUS_2_FIFO_UNDERRUN;
regfile.HISPI.LANE_DECODER_STATUS(2).FIFO_UNDERRUN <= field_rw2c_HISPI_LANE_DECODER_STATUS_2_FIFO_UNDERRUN;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_LANE_DECODER_STATUS_2_FIFO_UNDERRUN
------------------------------------------------------------------------------------------
P_HISPI_LANE_DECODER_STATUS_2_FIFO_UNDERRUN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_HISPI_LANE_DECODER_STATUS_2_FIFO_UNDERRUN <= '0';
      else
         if(wEn(69) = '1' and reg_writedata(1) = '1' and bitEnN(1) = '0') then
            -- Clear the field to '0'
            field_rw2c_HISPI_LANE_DECODER_STATUS_2_FIFO_UNDERRUN <= '0';
         else
            -- Set the field to '1'
            field_rw2c_HISPI_LANE_DECODER_STATUS_2_FIFO_UNDERRUN <= field_rw2c_HISPI_LANE_DECODER_STATUS_2_FIFO_UNDERRUN or regfile.HISPI.LANE_DECODER_STATUS(2).FIFO_UNDERRUN_set;
         end if;
      end if;
   end if;
end process P_HISPI_LANE_DECODER_STATUS_2_FIFO_UNDERRUN;

------------------------------------------------------------------------------------------
-- Field name: FIFO_OVERRUN
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_2(0) <= field_rw2c_HISPI_LANE_DECODER_STATUS_2_FIFO_OVERRUN;
regfile.HISPI.LANE_DECODER_STATUS(2).FIFO_OVERRUN <= field_rw2c_HISPI_LANE_DECODER_STATUS_2_FIFO_OVERRUN;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_LANE_DECODER_STATUS_2_FIFO_OVERRUN
------------------------------------------------------------------------------------------
P_HISPI_LANE_DECODER_STATUS_2_FIFO_OVERRUN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_HISPI_LANE_DECODER_STATUS_2_FIFO_OVERRUN <= '0';
      else
         if(wEn(69) = '1' and reg_writedata(0) = '1' and bitEnN(0) = '0') then
            -- Clear the field to '0'
            field_rw2c_HISPI_LANE_DECODER_STATUS_2_FIFO_OVERRUN <= '0';
         else
            -- Set the field to '1'
            field_rw2c_HISPI_LANE_DECODER_STATUS_2_FIFO_OVERRUN <= field_rw2c_HISPI_LANE_DECODER_STATUS_2_FIFO_OVERRUN or regfile.HISPI.LANE_DECODER_STATUS(2).FIFO_OVERRUN_set;
         end if;
      end if;
   end if;
end process P_HISPI_LANE_DECODER_STATUS_2_FIFO_OVERRUN;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: HISPI_LANE_DECODER_STATUS_3
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(70) <= (hit(70)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: CRC_ERROR
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_3(15) <= field_rw2c_HISPI_LANE_DECODER_STATUS_3_CRC_ERROR;
regfile.HISPI.LANE_DECODER_STATUS(3).CRC_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_3_CRC_ERROR;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_LANE_DECODER_STATUS_3_CRC_ERROR
------------------------------------------------------------------------------------------
P_HISPI_LANE_DECODER_STATUS_3_CRC_ERROR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_HISPI_LANE_DECODER_STATUS_3_CRC_ERROR <= '0';
      else
         if(wEn(70) = '1' and reg_writedata(15) = '1' and bitEnN(15) = '0') then
            -- Clear the field to '0'
            field_rw2c_HISPI_LANE_DECODER_STATUS_3_CRC_ERROR <= '0';
         else
            -- Set the field to '1'
            field_rw2c_HISPI_LANE_DECODER_STATUS_3_CRC_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_3_CRC_ERROR or regfile.HISPI.LANE_DECODER_STATUS(3).CRC_ERROR_set;
         end if;
      end if;
   end if;
end process P_HISPI_LANE_DECODER_STATUS_3_CRC_ERROR;

------------------------------------------------------------------------------------------
-- Field name: PHY_SYNC_ERROR
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_3(14) <= field_rw2c_HISPI_LANE_DECODER_STATUS_3_PHY_SYNC_ERROR;
regfile.HISPI.LANE_DECODER_STATUS(3).PHY_SYNC_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_3_PHY_SYNC_ERROR;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_LANE_DECODER_STATUS_3_PHY_SYNC_ERROR
------------------------------------------------------------------------------------------
P_HISPI_LANE_DECODER_STATUS_3_PHY_SYNC_ERROR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_HISPI_LANE_DECODER_STATUS_3_PHY_SYNC_ERROR <= '0';
      else
         if(wEn(70) = '1' and reg_writedata(14) = '1' and bitEnN(14) = '0') then
            -- Clear the field to '0'
            field_rw2c_HISPI_LANE_DECODER_STATUS_3_PHY_SYNC_ERROR <= '0';
         else
            -- Set the field to '1'
            field_rw2c_HISPI_LANE_DECODER_STATUS_3_PHY_SYNC_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_3_PHY_SYNC_ERROR or regfile.HISPI.LANE_DECODER_STATUS(3).PHY_SYNC_ERROR_set;
         end if;
      end if;
   end if;
end process P_HISPI_LANE_DECODER_STATUS_3_PHY_SYNC_ERROR;

------------------------------------------------------------------------------------------
-- Field name: PHY_BIT_LOCKED_ERROR
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_3(13) <= field_rw2c_HISPI_LANE_DECODER_STATUS_3_PHY_BIT_LOCKED_ERROR;
regfile.HISPI.LANE_DECODER_STATUS(3).PHY_BIT_LOCKED_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_3_PHY_BIT_LOCKED_ERROR;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_LANE_DECODER_STATUS_3_PHY_BIT_LOCKED_ERROR
------------------------------------------------------------------------------------------
P_HISPI_LANE_DECODER_STATUS_3_PHY_BIT_LOCKED_ERROR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_HISPI_LANE_DECODER_STATUS_3_PHY_BIT_LOCKED_ERROR <= '0';
      else
         if(wEn(70) = '1' and reg_writedata(13) = '1' and bitEnN(13) = '0') then
            -- Clear the field to '0'
            field_rw2c_HISPI_LANE_DECODER_STATUS_3_PHY_BIT_LOCKED_ERROR <= '0';
         else
            -- Set the field to '1'
            field_rw2c_HISPI_LANE_DECODER_STATUS_3_PHY_BIT_LOCKED_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_3_PHY_BIT_LOCKED_ERROR or regfile.HISPI.LANE_DECODER_STATUS(3).PHY_BIT_LOCKED_ERROR_set;
         end if;
      end if;
   end if;
end process P_HISPI_LANE_DECODER_STATUS_3_PHY_BIT_LOCKED_ERROR;

------------------------------------------------------------------------------------------
-- Field name: PHY_BIT_LOCKED
-- Field type: RO
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_3(12) <= regfile.HISPI.LANE_DECODER_STATUS(3).PHY_BIT_LOCKED;


------------------------------------------------------------------------------------------
-- Field name: CALIBRATION_TAP_VALUE(4 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_3(8 downto 4) <= regfile.HISPI.LANE_DECODER_STATUS(3).CALIBRATION_TAP_VALUE;


------------------------------------------------------------------------------------------
-- Field name: CALIBRATION_ERROR
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_3(3) <= field_rw2c_HISPI_LANE_DECODER_STATUS_3_CALIBRATION_ERROR;
regfile.HISPI.LANE_DECODER_STATUS(3).CALIBRATION_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_3_CALIBRATION_ERROR;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_LANE_DECODER_STATUS_3_CALIBRATION_ERROR
------------------------------------------------------------------------------------------
P_HISPI_LANE_DECODER_STATUS_3_CALIBRATION_ERROR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_HISPI_LANE_DECODER_STATUS_3_CALIBRATION_ERROR <= '0';
      else
         if(wEn(70) = '1' and reg_writedata(3) = '1' and bitEnN(3) = '0') then
            -- Clear the field to '0'
            field_rw2c_HISPI_LANE_DECODER_STATUS_3_CALIBRATION_ERROR <= '0';
         else
            -- Set the field to '1'
            field_rw2c_HISPI_LANE_DECODER_STATUS_3_CALIBRATION_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_3_CALIBRATION_ERROR or regfile.HISPI.LANE_DECODER_STATUS(3).CALIBRATION_ERROR_set;
         end if;
      end if;
   end if;
end process P_HISPI_LANE_DECODER_STATUS_3_CALIBRATION_ERROR;

------------------------------------------------------------------------------------------
-- Field name: CALIBRATION_DONE
-- Field type: RO
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_3(2) <= regfile.HISPI.LANE_DECODER_STATUS(3).CALIBRATION_DONE;


------------------------------------------------------------------------------------------
-- Field name: FIFO_UNDERRUN
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_3(1) <= field_rw2c_HISPI_LANE_DECODER_STATUS_3_FIFO_UNDERRUN;
regfile.HISPI.LANE_DECODER_STATUS(3).FIFO_UNDERRUN <= field_rw2c_HISPI_LANE_DECODER_STATUS_3_FIFO_UNDERRUN;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_LANE_DECODER_STATUS_3_FIFO_UNDERRUN
------------------------------------------------------------------------------------------
P_HISPI_LANE_DECODER_STATUS_3_FIFO_UNDERRUN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_HISPI_LANE_DECODER_STATUS_3_FIFO_UNDERRUN <= '0';
      else
         if(wEn(70) = '1' and reg_writedata(1) = '1' and bitEnN(1) = '0') then
            -- Clear the field to '0'
            field_rw2c_HISPI_LANE_DECODER_STATUS_3_FIFO_UNDERRUN <= '0';
         else
            -- Set the field to '1'
            field_rw2c_HISPI_LANE_DECODER_STATUS_3_FIFO_UNDERRUN <= field_rw2c_HISPI_LANE_DECODER_STATUS_3_FIFO_UNDERRUN or regfile.HISPI.LANE_DECODER_STATUS(3).FIFO_UNDERRUN_set;
         end if;
      end if;
   end if;
end process P_HISPI_LANE_DECODER_STATUS_3_FIFO_UNDERRUN;

------------------------------------------------------------------------------------------
-- Field name: FIFO_OVERRUN
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_3(0) <= field_rw2c_HISPI_LANE_DECODER_STATUS_3_FIFO_OVERRUN;
regfile.HISPI.LANE_DECODER_STATUS(3).FIFO_OVERRUN <= field_rw2c_HISPI_LANE_DECODER_STATUS_3_FIFO_OVERRUN;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_LANE_DECODER_STATUS_3_FIFO_OVERRUN
------------------------------------------------------------------------------------------
P_HISPI_LANE_DECODER_STATUS_3_FIFO_OVERRUN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_HISPI_LANE_DECODER_STATUS_3_FIFO_OVERRUN <= '0';
      else
         if(wEn(70) = '1' and reg_writedata(0) = '1' and bitEnN(0) = '0') then
            -- Clear the field to '0'
            field_rw2c_HISPI_LANE_DECODER_STATUS_3_FIFO_OVERRUN <= '0';
         else
            -- Set the field to '1'
            field_rw2c_HISPI_LANE_DECODER_STATUS_3_FIFO_OVERRUN <= field_rw2c_HISPI_LANE_DECODER_STATUS_3_FIFO_OVERRUN or regfile.HISPI.LANE_DECODER_STATUS(3).FIFO_OVERRUN_set;
         end if;
      end if;
   end if;
end process P_HISPI_LANE_DECODER_STATUS_3_FIFO_OVERRUN;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: HISPI_LANE_DECODER_STATUS_4
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(71) <= (hit(71)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: CRC_ERROR
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_4(15) <= field_rw2c_HISPI_LANE_DECODER_STATUS_4_CRC_ERROR;
regfile.HISPI.LANE_DECODER_STATUS(4).CRC_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_4_CRC_ERROR;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_LANE_DECODER_STATUS_4_CRC_ERROR
------------------------------------------------------------------------------------------
P_HISPI_LANE_DECODER_STATUS_4_CRC_ERROR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_HISPI_LANE_DECODER_STATUS_4_CRC_ERROR <= '0';
      else
         if(wEn(71) = '1' and reg_writedata(15) = '1' and bitEnN(15) = '0') then
            -- Clear the field to '0'
            field_rw2c_HISPI_LANE_DECODER_STATUS_4_CRC_ERROR <= '0';
         else
            -- Set the field to '1'
            field_rw2c_HISPI_LANE_DECODER_STATUS_4_CRC_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_4_CRC_ERROR or regfile.HISPI.LANE_DECODER_STATUS(4).CRC_ERROR_set;
         end if;
      end if;
   end if;
end process P_HISPI_LANE_DECODER_STATUS_4_CRC_ERROR;

------------------------------------------------------------------------------------------
-- Field name: PHY_SYNC_ERROR
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_4(14) <= field_rw2c_HISPI_LANE_DECODER_STATUS_4_PHY_SYNC_ERROR;
regfile.HISPI.LANE_DECODER_STATUS(4).PHY_SYNC_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_4_PHY_SYNC_ERROR;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_LANE_DECODER_STATUS_4_PHY_SYNC_ERROR
------------------------------------------------------------------------------------------
P_HISPI_LANE_DECODER_STATUS_4_PHY_SYNC_ERROR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_HISPI_LANE_DECODER_STATUS_4_PHY_SYNC_ERROR <= '0';
      else
         if(wEn(71) = '1' and reg_writedata(14) = '1' and bitEnN(14) = '0') then
            -- Clear the field to '0'
            field_rw2c_HISPI_LANE_DECODER_STATUS_4_PHY_SYNC_ERROR <= '0';
         else
            -- Set the field to '1'
            field_rw2c_HISPI_LANE_DECODER_STATUS_4_PHY_SYNC_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_4_PHY_SYNC_ERROR or regfile.HISPI.LANE_DECODER_STATUS(4).PHY_SYNC_ERROR_set;
         end if;
      end if;
   end if;
end process P_HISPI_LANE_DECODER_STATUS_4_PHY_SYNC_ERROR;

------------------------------------------------------------------------------------------
-- Field name: PHY_BIT_LOCKED_ERROR
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_4(13) <= field_rw2c_HISPI_LANE_DECODER_STATUS_4_PHY_BIT_LOCKED_ERROR;
regfile.HISPI.LANE_DECODER_STATUS(4).PHY_BIT_LOCKED_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_4_PHY_BIT_LOCKED_ERROR;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_LANE_DECODER_STATUS_4_PHY_BIT_LOCKED_ERROR
------------------------------------------------------------------------------------------
P_HISPI_LANE_DECODER_STATUS_4_PHY_BIT_LOCKED_ERROR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_HISPI_LANE_DECODER_STATUS_4_PHY_BIT_LOCKED_ERROR <= '0';
      else
         if(wEn(71) = '1' and reg_writedata(13) = '1' and bitEnN(13) = '0') then
            -- Clear the field to '0'
            field_rw2c_HISPI_LANE_DECODER_STATUS_4_PHY_BIT_LOCKED_ERROR <= '0';
         else
            -- Set the field to '1'
            field_rw2c_HISPI_LANE_DECODER_STATUS_4_PHY_BIT_LOCKED_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_4_PHY_BIT_LOCKED_ERROR or regfile.HISPI.LANE_DECODER_STATUS(4).PHY_BIT_LOCKED_ERROR_set;
         end if;
      end if;
   end if;
end process P_HISPI_LANE_DECODER_STATUS_4_PHY_BIT_LOCKED_ERROR;

------------------------------------------------------------------------------------------
-- Field name: PHY_BIT_LOCKED
-- Field type: RO
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_4(12) <= regfile.HISPI.LANE_DECODER_STATUS(4).PHY_BIT_LOCKED;


------------------------------------------------------------------------------------------
-- Field name: CALIBRATION_TAP_VALUE(4 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_4(8 downto 4) <= regfile.HISPI.LANE_DECODER_STATUS(4).CALIBRATION_TAP_VALUE;


------------------------------------------------------------------------------------------
-- Field name: CALIBRATION_ERROR
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_4(3) <= field_rw2c_HISPI_LANE_DECODER_STATUS_4_CALIBRATION_ERROR;
regfile.HISPI.LANE_DECODER_STATUS(4).CALIBRATION_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_4_CALIBRATION_ERROR;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_LANE_DECODER_STATUS_4_CALIBRATION_ERROR
------------------------------------------------------------------------------------------
P_HISPI_LANE_DECODER_STATUS_4_CALIBRATION_ERROR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_HISPI_LANE_DECODER_STATUS_4_CALIBRATION_ERROR <= '0';
      else
         if(wEn(71) = '1' and reg_writedata(3) = '1' and bitEnN(3) = '0') then
            -- Clear the field to '0'
            field_rw2c_HISPI_LANE_DECODER_STATUS_4_CALIBRATION_ERROR <= '0';
         else
            -- Set the field to '1'
            field_rw2c_HISPI_LANE_DECODER_STATUS_4_CALIBRATION_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_4_CALIBRATION_ERROR or regfile.HISPI.LANE_DECODER_STATUS(4).CALIBRATION_ERROR_set;
         end if;
      end if;
   end if;
end process P_HISPI_LANE_DECODER_STATUS_4_CALIBRATION_ERROR;

------------------------------------------------------------------------------------------
-- Field name: CALIBRATION_DONE
-- Field type: RO
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_4(2) <= regfile.HISPI.LANE_DECODER_STATUS(4).CALIBRATION_DONE;


------------------------------------------------------------------------------------------
-- Field name: FIFO_UNDERRUN
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_4(1) <= field_rw2c_HISPI_LANE_DECODER_STATUS_4_FIFO_UNDERRUN;
regfile.HISPI.LANE_DECODER_STATUS(4).FIFO_UNDERRUN <= field_rw2c_HISPI_LANE_DECODER_STATUS_4_FIFO_UNDERRUN;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_LANE_DECODER_STATUS_4_FIFO_UNDERRUN
------------------------------------------------------------------------------------------
P_HISPI_LANE_DECODER_STATUS_4_FIFO_UNDERRUN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_HISPI_LANE_DECODER_STATUS_4_FIFO_UNDERRUN <= '0';
      else
         if(wEn(71) = '1' and reg_writedata(1) = '1' and bitEnN(1) = '0') then
            -- Clear the field to '0'
            field_rw2c_HISPI_LANE_DECODER_STATUS_4_FIFO_UNDERRUN <= '0';
         else
            -- Set the field to '1'
            field_rw2c_HISPI_LANE_DECODER_STATUS_4_FIFO_UNDERRUN <= field_rw2c_HISPI_LANE_DECODER_STATUS_4_FIFO_UNDERRUN or regfile.HISPI.LANE_DECODER_STATUS(4).FIFO_UNDERRUN_set;
         end if;
      end if;
   end if;
end process P_HISPI_LANE_DECODER_STATUS_4_FIFO_UNDERRUN;

------------------------------------------------------------------------------------------
-- Field name: FIFO_OVERRUN
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_4(0) <= field_rw2c_HISPI_LANE_DECODER_STATUS_4_FIFO_OVERRUN;
regfile.HISPI.LANE_DECODER_STATUS(4).FIFO_OVERRUN <= field_rw2c_HISPI_LANE_DECODER_STATUS_4_FIFO_OVERRUN;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_LANE_DECODER_STATUS_4_FIFO_OVERRUN
------------------------------------------------------------------------------------------
P_HISPI_LANE_DECODER_STATUS_4_FIFO_OVERRUN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_HISPI_LANE_DECODER_STATUS_4_FIFO_OVERRUN <= '0';
      else
         if(wEn(71) = '1' and reg_writedata(0) = '1' and bitEnN(0) = '0') then
            -- Clear the field to '0'
            field_rw2c_HISPI_LANE_DECODER_STATUS_4_FIFO_OVERRUN <= '0';
         else
            -- Set the field to '1'
            field_rw2c_HISPI_LANE_DECODER_STATUS_4_FIFO_OVERRUN <= field_rw2c_HISPI_LANE_DECODER_STATUS_4_FIFO_OVERRUN or regfile.HISPI.LANE_DECODER_STATUS(4).FIFO_OVERRUN_set;
         end if;
      end if;
   end if;
end process P_HISPI_LANE_DECODER_STATUS_4_FIFO_OVERRUN;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: HISPI_LANE_DECODER_STATUS_5
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(72) <= (hit(72)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: CRC_ERROR
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_5(15) <= field_rw2c_HISPI_LANE_DECODER_STATUS_5_CRC_ERROR;
regfile.HISPI.LANE_DECODER_STATUS(5).CRC_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_5_CRC_ERROR;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_LANE_DECODER_STATUS_5_CRC_ERROR
------------------------------------------------------------------------------------------
P_HISPI_LANE_DECODER_STATUS_5_CRC_ERROR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_HISPI_LANE_DECODER_STATUS_5_CRC_ERROR <= '0';
      else
         if(wEn(72) = '1' and reg_writedata(15) = '1' and bitEnN(15) = '0') then
            -- Clear the field to '0'
            field_rw2c_HISPI_LANE_DECODER_STATUS_5_CRC_ERROR <= '0';
         else
            -- Set the field to '1'
            field_rw2c_HISPI_LANE_DECODER_STATUS_5_CRC_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_5_CRC_ERROR or regfile.HISPI.LANE_DECODER_STATUS(5).CRC_ERROR_set;
         end if;
      end if;
   end if;
end process P_HISPI_LANE_DECODER_STATUS_5_CRC_ERROR;

------------------------------------------------------------------------------------------
-- Field name: PHY_SYNC_ERROR
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_5(14) <= field_rw2c_HISPI_LANE_DECODER_STATUS_5_PHY_SYNC_ERROR;
regfile.HISPI.LANE_DECODER_STATUS(5).PHY_SYNC_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_5_PHY_SYNC_ERROR;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_LANE_DECODER_STATUS_5_PHY_SYNC_ERROR
------------------------------------------------------------------------------------------
P_HISPI_LANE_DECODER_STATUS_5_PHY_SYNC_ERROR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_HISPI_LANE_DECODER_STATUS_5_PHY_SYNC_ERROR <= '0';
      else
         if(wEn(72) = '1' and reg_writedata(14) = '1' and bitEnN(14) = '0') then
            -- Clear the field to '0'
            field_rw2c_HISPI_LANE_DECODER_STATUS_5_PHY_SYNC_ERROR <= '0';
         else
            -- Set the field to '1'
            field_rw2c_HISPI_LANE_DECODER_STATUS_5_PHY_SYNC_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_5_PHY_SYNC_ERROR or regfile.HISPI.LANE_DECODER_STATUS(5).PHY_SYNC_ERROR_set;
         end if;
      end if;
   end if;
end process P_HISPI_LANE_DECODER_STATUS_5_PHY_SYNC_ERROR;

------------------------------------------------------------------------------------------
-- Field name: PHY_BIT_LOCKED_ERROR
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_5(13) <= field_rw2c_HISPI_LANE_DECODER_STATUS_5_PHY_BIT_LOCKED_ERROR;
regfile.HISPI.LANE_DECODER_STATUS(5).PHY_BIT_LOCKED_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_5_PHY_BIT_LOCKED_ERROR;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_LANE_DECODER_STATUS_5_PHY_BIT_LOCKED_ERROR
------------------------------------------------------------------------------------------
P_HISPI_LANE_DECODER_STATUS_5_PHY_BIT_LOCKED_ERROR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_HISPI_LANE_DECODER_STATUS_5_PHY_BIT_LOCKED_ERROR <= '0';
      else
         if(wEn(72) = '1' and reg_writedata(13) = '1' and bitEnN(13) = '0') then
            -- Clear the field to '0'
            field_rw2c_HISPI_LANE_DECODER_STATUS_5_PHY_BIT_LOCKED_ERROR <= '0';
         else
            -- Set the field to '1'
            field_rw2c_HISPI_LANE_DECODER_STATUS_5_PHY_BIT_LOCKED_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_5_PHY_BIT_LOCKED_ERROR or regfile.HISPI.LANE_DECODER_STATUS(5).PHY_BIT_LOCKED_ERROR_set;
         end if;
      end if;
   end if;
end process P_HISPI_LANE_DECODER_STATUS_5_PHY_BIT_LOCKED_ERROR;

------------------------------------------------------------------------------------------
-- Field name: PHY_BIT_LOCKED
-- Field type: RO
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_5(12) <= regfile.HISPI.LANE_DECODER_STATUS(5).PHY_BIT_LOCKED;


------------------------------------------------------------------------------------------
-- Field name: CALIBRATION_TAP_VALUE(4 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_5(8 downto 4) <= regfile.HISPI.LANE_DECODER_STATUS(5).CALIBRATION_TAP_VALUE;


------------------------------------------------------------------------------------------
-- Field name: CALIBRATION_ERROR
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_5(3) <= field_rw2c_HISPI_LANE_DECODER_STATUS_5_CALIBRATION_ERROR;
regfile.HISPI.LANE_DECODER_STATUS(5).CALIBRATION_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_5_CALIBRATION_ERROR;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_LANE_DECODER_STATUS_5_CALIBRATION_ERROR
------------------------------------------------------------------------------------------
P_HISPI_LANE_DECODER_STATUS_5_CALIBRATION_ERROR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_HISPI_LANE_DECODER_STATUS_5_CALIBRATION_ERROR <= '0';
      else
         if(wEn(72) = '1' and reg_writedata(3) = '1' and bitEnN(3) = '0') then
            -- Clear the field to '0'
            field_rw2c_HISPI_LANE_DECODER_STATUS_5_CALIBRATION_ERROR <= '0';
         else
            -- Set the field to '1'
            field_rw2c_HISPI_LANE_DECODER_STATUS_5_CALIBRATION_ERROR <= field_rw2c_HISPI_LANE_DECODER_STATUS_5_CALIBRATION_ERROR or regfile.HISPI.LANE_DECODER_STATUS(5).CALIBRATION_ERROR_set;
         end if;
      end if;
   end if;
end process P_HISPI_LANE_DECODER_STATUS_5_CALIBRATION_ERROR;

------------------------------------------------------------------------------------------
-- Field name: CALIBRATION_DONE
-- Field type: RO
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_5(2) <= regfile.HISPI.LANE_DECODER_STATUS(5).CALIBRATION_DONE;


------------------------------------------------------------------------------------------
-- Field name: FIFO_UNDERRUN
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_5(1) <= field_rw2c_HISPI_LANE_DECODER_STATUS_5_FIFO_UNDERRUN;
regfile.HISPI.LANE_DECODER_STATUS(5).FIFO_UNDERRUN <= field_rw2c_HISPI_LANE_DECODER_STATUS_5_FIFO_UNDERRUN;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_LANE_DECODER_STATUS_5_FIFO_UNDERRUN
------------------------------------------------------------------------------------------
P_HISPI_LANE_DECODER_STATUS_5_FIFO_UNDERRUN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_HISPI_LANE_DECODER_STATUS_5_FIFO_UNDERRUN <= '0';
      else
         if(wEn(72) = '1' and reg_writedata(1) = '1' and bitEnN(1) = '0') then
            -- Clear the field to '0'
            field_rw2c_HISPI_LANE_DECODER_STATUS_5_FIFO_UNDERRUN <= '0';
         else
            -- Set the field to '1'
            field_rw2c_HISPI_LANE_DECODER_STATUS_5_FIFO_UNDERRUN <= field_rw2c_HISPI_LANE_DECODER_STATUS_5_FIFO_UNDERRUN or regfile.HISPI.LANE_DECODER_STATUS(5).FIFO_UNDERRUN_set;
         end if;
      end if;
   end if;
end process P_HISPI_LANE_DECODER_STATUS_5_FIFO_UNDERRUN;

------------------------------------------------------------------------------------------
-- Field name: FIFO_OVERRUN
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_HISPI_LANE_DECODER_STATUS_5(0) <= field_rw2c_HISPI_LANE_DECODER_STATUS_5_FIFO_OVERRUN;
regfile.HISPI.LANE_DECODER_STATUS(5).FIFO_OVERRUN <= field_rw2c_HISPI_LANE_DECODER_STATUS_5_FIFO_OVERRUN;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_LANE_DECODER_STATUS_5_FIFO_OVERRUN
------------------------------------------------------------------------------------------
P_HISPI_LANE_DECODER_STATUS_5_FIFO_OVERRUN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_HISPI_LANE_DECODER_STATUS_5_FIFO_OVERRUN <= '0';
      else
         if(wEn(72) = '1' and reg_writedata(0) = '1' and bitEnN(0) = '0') then
            -- Clear the field to '0'
            field_rw2c_HISPI_LANE_DECODER_STATUS_5_FIFO_OVERRUN <= '0';
         else
            -- Set the field to '1'
            field_rw2c_HISPI_LANE_DECODER_STATUS_5_FIFO_OVERRUN <= field_rw2c_HISPI_LANE_DECODER_STATUS_5_FIFO_OVERRUN or regfile.HISPI.LANE_DECODER_STATUS(5).FIFO_OVERRUN_set;
         end if;
      end if;
   end if;
end process P_HISPI_LANE_DECODER_STATUS_5_FIFO_OVERRUN;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: HISPI_TAP_HISTOGRAM_0
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(73) <= (hit(73)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: VALUE(31 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_HISPI_TAP_HISTOGRAM_0(31 downto 0) <= regfile.HISPI.TAP_HISTOGRAM(0).VALUE;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: HISPI_TAP_HISTOGRAM_1
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(74) <= (hit(74)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: VALUE(31 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_HISPI_TAP_HISTOGRAM_1(31 downto 0) <= regfile.HISPI.TAP_HISTOGRAM(1).VALUE;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: HISPI_TAP_HISTOGRAM_2
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(75) <= (hit(75)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: VALUE(31 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_HISPI_TAP_HISTOGRAM_2(31 downto 0) <= regfile.HISPI.TAP_HISTOGRAM(2).VALUE;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: HISPI_TAP_HISTOGRAM_3
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(76) <= (hit(76)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: VALUE(31 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_HISPI_TAP_HISTOGRAM_3(31 downto 0) <= regfile.HISPI.TAP_HISTOGRAM(3).VALUE;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: HISPI_TAP_HISTOGRAM_4
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(77) <= (hit(77)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: VALUE(31 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_HISPI_TAP_HISTOGRAM_4(31 downto 0) <= regfile.HISPI.TAP_HISTOGRAM(4).VALUE;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: HISPI_TAP_HISTOGRAM_5
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(78) <= (hit(78)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: VALUE(31 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_HISPI_TAP_HISTOGRAM_5(31 downto 0) <= regfile.HISPI.TAP_HISTOGRAM(5).VALUE;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: HISPI_DEBUG
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(79) <= (hit(79)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: MANUAL_CALIB_EN
-- Field type: RW
------------------------------------------------------------------------------------------
rb_HISPI_DEBUG(31) <= field_rw_HISPI_DEBUG_MANUAL_CALIB_EN;
regfile.HISPI.DEBUG.MANUAL_CALIB_EN <= field_rw_HISPI_DEBUG_MANUAL_CALIB_EN;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_DEBUG_MANUAL_CALIB_EN
------------------------------------------------------------------------------------------
P_HISPI_DEBUG_MANUAL_CALIB_EN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_HISPI_DEBUG_MANUAL_CALIB_EN <= '0';
      else
         if(wEn(79) = '1' and bitEnN(31) = '0') then
            field_rw_HISPI_DEBUG_MANUAL_CALIB_EN <= reg_writedata(31);
         end if;
      end if;
   end if;
end process P_HISPI_DEBUG_MANUAL_CALIB_EN;

------------------------------------------------------------------------------------------
-- Field name: LOAD_TAPS
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_HISPI_DEBUG(30) <= '0';
regfile.HISPI.DEBUG.LOAD_TAPS <= field_wautoclr_HISPI_DEBUG_LOAD_TAPS;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_DEBUG_LOAD_TAPS
------------------------------------------------------------------------------------------
P_HISPI_DEBUG_LOAD_TAPS : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_HISPI_DEBUG_LOAD_TAPS <= '0';
      else
         if(wEn(79) = '1' and bitEnN(30) = '0') then
            field_wautoclr_HISPI_DEBUG_LOAD_TAPS <= reg_writedata(30);
         else
            field_wautoclr_HISPI_DEBUG_LOAD_TAPS <= '0';
         end if;
      end if;
   end if;
end process P_HISPI_DEBUG_LOAD_TAPS;

------------------------------------------------------------------------------------------
-- Field name: TAP_LANE_5(29 downto 25)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_HISPI_DEBUG(29 downto 25) <= field_rw_HISPI_DEBUG_TAP_LANE_5(4 downto 0);
regfile.HISPI.DEBUG.TAP_LANE_5 <= field_rw_HISPI_DEBUG_TAP_LANE_5(4 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_HISPI_DEBUG_TAP_LANE_5
------------------------------------------------------------------------------------------
P_HISPI_DEBUG_TAP_LANE_5 : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_HISPI_DEBUG_TAP_LANE_5 <= std_logic_vector(to_unsigned(integer(0),5));
      else
         for j in  29 downto 25  loop
            if(wEn(79) = '1' and bitEnN(j) = '0') then
               field_rw_HISPI_DEBUG_TAP_LANE_5(j-25) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_HISPI_DEBUG_TAP_LANE_5;

------------------------------------------------------------------------------------------
-- Field name: TAP_LANE_4(24 downto 20)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_HISPI_DEBUG(24 downto 20) <= field_rw_HISPI_DEBUG_TAP_LANE_4(4 downto 0);
regfile.HISPI.DEBUG.TAP_LANE_4 <= field_rw_HISPI_DEBUG_TAP_LANE_4(4 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_HISPI_DEBUG_TAP_LANE_4
------------------------------------------------------------------------------------------
P_HISPI_DEBUG_TAP_LANE_4 : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_HISPI_DEBUG_TAP_LANE_4 <= std_logic_vector(to_unsigned(integer(0),5));
      else
         for j in  24 downto 20  loop
            if(wEn(79) = '1' and bitEnN(j) = '0') then
               field_rw_HISPI_DEBUG_TAP_LANE_4(j-20) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_HISPI_DEBUG_TAP_LANE_4;

------------------------------------------------------------------------------------------
-- Field name: TAP_LANE_3(19 downto 15)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_HISPI_DEBUG(19 downto 15) <= field_rw_HISPI_DEBUG_TAP_LANE_3(4 downto 0);
regfile.HISPI.DEBUG.TAP_LANE_3 <= field_rw_HISPI_DEBUG_TAP_LANE_3(4 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_HISPI_DEBUG_TAP_LANE_3
------------------------------------------------------------------------------------------
P_HISPI_DEBUG_TAP_LANE_3 : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_HISPI_DEBUG_TAP_LANE_3 <= std_logic_vector(to_unsigned(integer(0),5));
      else
         for j in  19 downto 15  loop
            if(wEn(79) = '1' and bitEnN(j) = '0') then
               field_rw_HISPI_DEBUG_TAP_LANE_3(j-15) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_HISPI_DEBUG_TAP_LANE_3;

------------------------------------------------------------------------------------------
-- Field name: TAP_LANE_2(14 downto 10)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_HISPI_DEBUG(14 downto 10) <= field_rw_HISPI_DEBUG_TAP_LANE_2(4 downto 0);
regfile.HISPI.DEBUG.TAP_LANE_2 <= field_rw_HISPI_DEBUG_TAP_LANE_2(4 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_HISPI_DEBUG_TAP_LANE_2
------------------------------------------------------------------------------------------
P_HISPI_DEBUG_TAP_LANE_2 : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_HISPI_DEBUG_TAP_LANE_2 <= std_logic_vector(to_unsigned(integer(0),5));
      else
         for j in  14 downto 10  loop
            if(wEn(79) = '1' and bitEnN(j) = '0') then
               field_rw_HISPI_DEBUG_TAP_LANE_2(j-10) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_HISPI_DEBUG_TAP_LANE_2;

------------------------------------------------------------------------------------------
-- Field name: TAP_LANE_1(9 downto 5)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_HISPI_DEBUG(9 downto 5) <= field_rw_HISPI_DEBUG_TAP_LANE_1(4 downto 0);
regfile.HISPI.DEBUG.TAP_LANE_1 <= field_rw_HISPI_DEBUG_TAP_LANE_1(4 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_HISPI_DEBUG_TAP_LANE_1
------------------------------------------------------------------------------------------
P_HISPI_DEBUG_TAP_LANE_1 : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_HISPI_DEBUG_TAP_LANE_1 <= std_logic_vector(to_unsigned(integer(0),5));
      else
         for j in  9 downto 5  loop
            if(wEn(79) = '1' and bitEnN(j) = '0') then
               field_rw_HISPI_DEBUG_TAP_LANE_1(j-5) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_HISPI_DEBUG_TAP_LANE_1;

------------------------------------------------------------------------------------------
-- Field name: TAP_LANE_0(4 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_HISPI_DEBUG(4 downto 0) <= field_rw_HISPI_DEBUG_TAP_LANE_0(4 downto 0);
regfile.HISPI.DEBUG.TAP_LANE_0 <= field_rw_HISPI_DEBUG_TAP_LANE_0(4 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_HISPI_DEBUG_TAP_LANE_0
------------------------------------------------------------------------------------------
P_HISPI_DEBUG_TAP_LANE_0 : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_HISPI_DEBUG_TAP_LANE_0 <= std_logic_vector(to_unsigned(integer(0),5));
      else
         for j in  4 downto 0  loop
            if(wEn(79) = '1' and bitEnN(j) = '0') then
               field_rw_HISPI_DEBUG_TAP_LANE_0(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_HISPI_DEBUG_TAP_LANE_0;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DPC_DPC_CAPABILITIES
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(80) <= (hit(80)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: DPC_LIST_LENGTH(11 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_DPC_DPC_CAPABILITIES(27 downto 16) <= regfile.DPC.DPC_CAPABILITIES.DPC_LIST_LENGTH;


------------------------------------------------------------------------------------------
-- Field name: DPC_VER(3 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_DPC_DPC_CAPABILITIES(3 downto 0) <= regfile.DPC.DPC_CAPABILITIES.DPC_VER;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DPC_DPC_LIST_CTRL
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(81) <= (hit(81)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: dpc_highlight_all
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DPC_DPC_LIST_CTRL(31) <= field_rw_DPC_DPC_LIST_CTRL_dpc_highlight_all;
regfile.DPC.DPC_LIST_CTRL.dpc_highlight_all <= field_rw_DPC_DPC_LIST_CTRL_dpc_highlight_all;


------------------------------------------------------------------------------------------
-- Process: P_DPC_DPC_LIST_CTRL_dpc_highlight_all
------------------------------------------------------------------------------------------
P_DPC_DPC_LIST_CTRL_dpc_highlight_all : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DPC_DPC_LIST_CTRL_dpc_highlight_all <= '0';
      else
         if(wEn(81) = '1' and bitEnN(31) = '0') then
            field_rw_DPC_DPC_LIST_CTRL_dpc_highlight_all <= reg_writedata(31);
         end if;
      end if;
   end if;
end process P_DPC_DPC_LIST_CTRL_dpc_highlight_all;

------------------------------------------------------------------------------------------
-- Field name: dpc_fifo_reset
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DPC_DPC_LIST_CTRL(29) <= field_rw_DPC_DPC_LIST_CTRL_dpc_fifo_reset;
regfile.DPC.DPC_LIST_CTRL.dpc_fifo_reset <= field_rw_DPC_DPC_LIST_CTRL_dpc_fifo_reset;


------------------------------------------------------------------------------------------
-- Process: P_DPC_DPC_LIST_CTRL_dpc_fifo_reset
------------------------------------------------------------------------------------------
P_DPC_DPC_LIST_CTRL_dpc_fifo_reset : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DPC_DPC_LIST_CTRL_dpc_fifo_reset <= '0';
      else
         if(wEn(81) = '1' and bitEnN(29) = '0') then
            field_rw_DPC_DPC_LIST_CTRL_dpc_fifo_reset <= reg_writedata(29);
         end if;
      end if;
   end if;
end process P_DPC_DPC_LIST_CTRL_dpc_fifo_reset;

------------------------------------------------------------------------------------------
-- Field name: dpc_firstlast_line_rem
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DPC_DPC_LIST_CTRL(28) <= field_rw_DPC_DPC_LIST_CTRL_dpc_firstlast_line_rem;
regfile.DPC.DPC_LIST_CTRL.dpc_firstlast_line_rem <= field_rw_DPC_DPC_LIST_CTRL_dpc_firstlast_line_rem;


------------------------------------------------------------------------------------------
-- Process: P_DPC_DPC_LIST_CTRL_dpc_firstlast_line_rem
------------------------------------------------------------------------------------------
P_DPC_DPC_LIST_CTRL_dpc_firstlast_line_rem : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DPC_DPC_LIST_CTRL_dpc_firstlast_line_rem <= '0';
      else
         if(wEn(81) = '1' and bitEnN(28) = '0') then
            field_rw_DPC_DPC_LIST_CTRL_dpc_firstlast_line_rem <= reg_writedata(28);
         end if;
      end if;
   end if;
end process P_DPC_DPC_LIST_CTRL_dpc_firstlast_line_rem;

------------------------------------------------------------------------------------------
-- Field name: dpc_list_count(27 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DPC_DPC_LIST_CTRL(27 downto 16) <= field_rw_DPC_DPC_LIST_CTRL_dpc_list_count(11 downto 0);
regfile.DPC.DPC_LIST_CTRL.dpc_list_count <= field_rw_DPC_DPC_LIST_CTRL_dpc_list_count(11 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DPC_DPC_LIST_CTRL_dpc_list_count
------------------------------------------------------------------------------------------
P_DPC_DPC_LIST_CTRL_dpc_list_count : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DPC_DPC_LIST_CTRL_dpc_list_count <= std_logic_vector(to_unsigned(integer(0),12));
      else
         for j in  27 downto 16  loop
            if(wEn(81) = '1' and bitEnN(j) = '0') then
               field_rw_DPC_DPC_LIST_CTRL_dpc_list_count(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DPC_DPC_LIST_CTRL_dpc_list_count;

------------------------------------------------------------------------------------------
-- Field name: dpc_pattern0_cfg
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DPC_DPC_LIST_CTRL(15) <= field_rw_DPC_DPC_LIST_CTRL_dpc_pattern0_cfg;
regfile.DPC.DPC_LIST_CTRL.dpc_pattern0_cfg <= field_rw_DPC_DPC_LIST_CTRL_dpc_pattern0_cfg;


------------------------------------------------------------------------------------------
-- Process: P_DPC_DPC_LIST_CTRL_dpc_pattern0_cfg
------------------------------------------------------------------------------------------
P_DPC_DPC_LIST_CTRL_dpc_pattern0_cfg : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DPC_DPC_LIST_CTRL_dpc_pattern0_cfg <= '0';
      else
         if(wEn(81) = '1' and bitEnN(15) = '0') then
            field_rw_DPC_DPC_LIST_CTRL_dpc_pattern0_cfg <= reg_writedata(15);
         end if;
      end if;
   end if;
end process P_DPC_DPC_LIST_CTRL_dpc_pattern0_cfg;

------------------------------------------------------------------------------------------
-- Field name: dpc_enable
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DPC_DPC_LIST_CTRL(14) <= field_rw_DPC_DPC_LIST_CTRL_dpc_enable;
regfile.DPC.DPC_LIST_CTRL.dpc_enable <= field_rw_DPC_DPC_LIST_CTRL_dpc_enable;


------------------------------------------------------------------------------------------
-- Process: P_DPC_DPC_LIST_CTRL_dpc_enable
------------------------------------------------------------------------------------------
P_DPC_DPC_LIST_CTRL_dpc_enable : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DPC_DPC_LIST_CTRL_dpc_enable <= '0';
      else
         if(wEn(81) = '1' and bitEnN(14) = '0') then
            field_rw_DPC_DPC_LIST_CTRL_dpc_enable <= reg_writedata(14);
         end if;
      end if;
   end if;
end process P_DPC_DPC_LIST_CTRL_dpc_enable;

------------------------------------------------------------------------------------------
-- Field name: dpc_list_WRn
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DPC_DPC_LIST_CTRL(13) <= field_rw_DPC_DPC_LIST_CTRL_dpc_list_WRn;
regfile.DPC.DPC_LIST_CTRL.dpc_list_WRn <= field_rw_DPC_DPC_LIST_CTRL_dpc_list_WRn;


------------------------------------------------------------------------------------------
-- Process: P_DPC_DPC_LIST_CTRL_dpc_list_WRn
------------------------------------------------------------------------------------------
P_DPC_DPC_LIST_CTRL_dpc_list_WRn : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DPC_DPC_LIST_CTRL_dpc_list_WRn <= '0';
      else
         if(wEn(81) = '1' and bitEnN(13) = '0') then
            field_rw_DPC_DPC_LIST_CTRL_dpc_list_WRn <= reg_writedata(13);
         end if;
      end if;
   end if;
end process P_DPC_DPC_LIST_CTRL_dpc_list_WRn;

------------------------------------------------------------------------------------------
-- Field name: dpc_list_ss
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_DPC_DPC_LIST_CTRL(12) <= '0';
regfile.DPC.DPC_LIST_CTRL.dpc_list_ss <= field_wautoclr_DPC_DPC_LIST_CTRL_dpc_list_ss;


------------------------------------------------------------------------------------------
-- Process: P_DPC_DPC_LIST_CTRL_dpc_list_ss
------------------------------------------------------------------------------------------
P_DPC_DPC_LIST_CTRL_dpc_list_ss : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_DPC_DPC_LIST_CTRL_dpc_list_ss <= '0';
      else
         if(wEn(81) = '1' and bitEnN(12) = '0') then
            field_wautoclr_DPC_DPC_LIST_CTRL_dpc_list_ss <= reg_writedata(12);
         else
            field_wautoclr_DPC_DPC_LIST_CTRL_dpc_list_ss <= '0';
         end if;
      end if;
   end if;
end process P_DPC_DPC_LIST_CTRL_dpc_list_ss;

------------------------------------------------------------------------------------------
-- Field name: dpc_list_add(11 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DPC_DPC_LIST_CTRL(11 downto 0) <= field_rw_DPC_DPC_LIST_CTRL_dpc_list_add(11 downto 0);
regfile.DPC.DPC_LIST_CTRL.dpc_list_add <= field_rw_DPC_DPC_LIST_CTRL_dpc_list_add(11 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DPC_DPC_LIST_CTRL_dpc_list_add
------------------------------------------------------------------------------------------
P_DPC_DPC_LIST_CTRL_dpc_list_add : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DPC_DPC_LIST_CTRL_dpc_list_add <= std_logic_vector(to_unsigned(integer(0),12));
      else
         for j in  11 downto 0  loop
            if(wEn(81) = '1' and bitEnN(j) = '0') then
               field_rw_DPC_DPC_LIST_CTRL_dpc_list_add(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DPC_DPC_LIST_CTRL_dpc_list_add;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DPC_DPC_LIST_STAT
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(82) <= (hit(82)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: dpc_fifo_underrun
-- Field type: RO
------------------------------------------------------------------------------------------
rb_DPC_DPC_LIST_STAT(31) <= regfile.DPC.DPC_LIST_STAT.dpc_fifo_underrun;


------------------------------------------------------------------------------------------
-- Field name: dpc_fifo_overrun
-- Field type: RO
------------------------------------------------------------------------------------------
rb_DPC_DPC_LIST_STAT(30) <= regfile.DPC.DPC_LIST_STAT.dpc_fifo_overrun;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DPC_DPC_LIST_DATA1
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(83) <= (hit(83)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: dpc_list_corr_y(27 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DPC_DPC_LIST_DATA1(27 downto 16) <= field_rw_DPC_DPC_LIST_DATA1_dpc_list_corr_y(11 downto 0);
regfile.DPC.DPC_LIST_DATA1.dpc_list_corr_y <= field_rw_DPC_DPC_LIST_DATA1_dpc_list_corr_y(11 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DPC_DPC_LIST_DATA1_dpc_list_corr_y
------------------------------------------------------------------------------------------
P_DPC_DPC_LIST_DATA1_dpc_list_corr_y : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DPC_DPC_LIST_DATA1_dpc_list_corr_y <= std_logic_vector(to_unsigned(integer(0),12));
      else
         for j in  27 downto 16  loop
            if(wEn(83) = '1' and bitEnN(j) = '0') then
               field_rw_DPC_DPC_LIST_DATA1_dpc_list_corr_y(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DPC_DPC_LIST_DATA1_dpc_list_corr_y;

------------------------------------------------------------------------------------------
-- Field name: dpc_list_corr_x(12 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DPC_DPC_LIST_DATA1(12 downto 0) <= field_rw_DPC_DPC_LIST_DATA1_dpc_list_corr_x(12 downto 0);
regfile.DPC.DPC_LIST_DATA1.dpc_list_corr_x <= field_rw_DPC_DPC_LIST_DATA1_dpc_list_corr_x(12 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DPC_DPC_LIST_DATA1_dpc_list_corr_x
------------------------------------------------------------------------------------------
P_DPC_DPC_LIST_DATA1_dpc_list_corr_x : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DPC_DPC_LIST_DATA1_dpc_list_corr_x <= std_logic_vector(to_unsigned(integer(0),13));
      else
         for j in  12 downto 0  loop
            if(wEn(83) = '1' and bitEnN(j) = '0') then
               field_rw_DPC_DPC_LIST_DATA1_dpc_list_corr_x(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DPC_DPC_LIST_DATA1_dpc_list_corr_x;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DPC_DPC_LIST_DATA2
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(84) <= (hit(84)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: dpc_list_corr_pattern(7 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DPC_DPC_LIST_DATA2(7 downto 0) <= field_rw_DPC_DPC_LIST_DATA2_dpc_list_corr_pattern(7 downto 0);
regfile.DPC.DPC_LIST_DATA2.dpc_list_corr_pattern <= field_rw_DPC_DPC_LIST_DATA2_dpc_list_corr_pattern(7 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DPC_DPC_LIST_DATA2_dpc_list_corr_pattern
------------------------------------------------------------------------------------------
P_DPC_DPC_LIST_DATA2_dpc_list_corr_pattern : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DPC_DPC_LIST_DATA2_dpc_list_corr_pattern <= std_logic_vector(to_unsigned(integer(0),8));
      else
         for j in  7 downto 0  loop
            if(wEn(84) = '1' and bitEnN(j) = '0') then
               field_rw_DPC_DPC_LIST_DATA2_dpc_list_corr_pattern(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DPC_DPC_LIST_DATA2_dpc_list_corr_pattern;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DPC_DPC_LIST_DATA1_RD
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(85) <= (hit(85)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: dpc_list_corr_y(11 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_DPC_DPC_LIST_DATA1_RD(27 downto 16) <= regfile.DPC.DPC_LIST_DATA1_RD.dpc_list_corr_y;


------------------------------------------------------------------------------------------
-- Field name: dpc_list_corr_x(12 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_DPC_DPC_LIST_DATA1_RD(12 downto 0) <= regfile.DPC.DPC_LIST_DATA1_RD.dpc_list_corr_x;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DPC_DPC_LIST_DATA2_RD
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(86) <= (hit(86)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: dpc_list_corr_pattern(7 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_DPC_DPC_LIST_DATA2_RD(7 downto 0) <= regfile.DPC.DPC_LIST_DATA2_RD.dpc_list_corr_pattern;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: LUT_LUT_CAPABILITIES
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(87) <= (hit(87)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: LUT_SIZE_CONFIG(11 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_LUT_LUT_CAPABILITIES(27 downto 16) <= regfile.LUT.LUT_CAPABILITIES.LUT_SIZE_CONFIG;


------------------------------------------------------------------------------------------
-- Field name: LUT_VER(3 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_LUT_LUT_CAPABILITIES(3 downto 0) <= regfile.LUT.LUT_CAPABILITIES.LUT_VER;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: LUT_LUT_CTRL
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(88) <= (hit(88)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: LUT_BYPASS_COLOR
-- Field type: RW
------------------------------------------------------------------------------------------
rb_LUT_LUT_CTRL(29) <= field_rw_LUT_LUT_CTRL_LUT_BYPASS_COLOR;
regfile.LUT.LUT_CTRL.LUT_BYPASS_COLOR <= field_rw_LUT_LUT_CTRL_LUT_BYPASS_COLOR;


------------------------------------------------------------------------------------------
-- Process: P_LUT_LUT_CTRL_LUT_BYPASS_COLOR
------------------------------------------------------------------------------------------
P_LUT_LUT_CTRL_LUT_BYPASS_COLOR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_LUT_LUT_CTRL_LUT_BYPASS_COLOR <= '1';
      else
         if(wEn(88) = '1' and bitEnN(29) = '0') then
            field_rw_LUT_LUT_CTRL_LUT_BYPASS_COLOR <= reg_writedata(29);
         end if;
      end if;
   end if;
end process P_LUT_LUT_CTRL_LUT_BYPASS_COLOR;

------------------------------------------------------------------------------------------
-- Field name: LUT_BYPASS
-- Field type: RW
------------------------------------------------------------------------------------------
rb_LUT_LUT_CTRL(28) <= field_rw_LUT_LUT_CTRL_LUT_BYPASS;
regfile.LUT.LUT_CTRL.LUT_BYPASS <= field_rw_LUT_LUT_CTRL_LUT_BYPASS;


------------------------------------------------------------------------------------------
-- Process: P_LUT_LUT_CTRL_LUT_BYPASS
------------------------------------------------------------------------------------------
P_LUT_LUT_CTRL_LUT_BYPASS : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_LUT_LUT_CTRL_LUT_BYPASS <= '1';
      else
         if(wEn(88) = '1' and bitEnN(28) = '0') then
            field_rw_LUT_LUT_CTRL_LUT_BYPASS <= reg_writedata(28);
         end if;
      end if;
   end if;
end process P_LUT_LUT_CTRL_LUT_BYPASS;

------------------------------------------------------------------------------------------
-- Field name: LUT_DATA_W(25 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_LUT_LUT_CTRL(25 downto 16) <= field_rw_LUT_LUT_CTRL_LUT_DATA_W(9 downto 0);
regfile.LUT.LUT_CTRL.LUT_DATA_W <= field_rw_LUT_LUT_CTRL_LUT_DATA_W(9 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_LUT_LUT_CTRL_LUT_DATA_W
------------------------------------------------------------------------------------------
P_LUT_LUT_CTRL_LUT_DATA_W : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_LUT_LUT_CTRL_LUT_DATA_W <= std_logic_vector(to_unsigned(integer(0),10));
      else
         for j in  25 downto 16  loop
            if(wEn(88) = '1' and bitEnN(j) = '0') then
               field_rw_LUT_LUT_CTRL_LUT_DATA_W(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_LUT_LUT_CTRL_LUT_DATA_W;

------------------------------------------------------------------------------------------
-- Field name: LUT_SEL(15 downto 12)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_LUT_LUT_CTRL(15 downto 12) <= field_rw_LUT_LUT_CTRL_LUT_SEL(3 downto 0);
regfile.LUT.LUT_CTRL.LUT_SEL <= field_rw_LUT_LUT_CTRL_LUT_SEL(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_LUT_LUT_CTRL_LUT_SEL
------------------------------------------------------------------------------------------
P_LUT_LUT_CTRL_LUT_SEL : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_LUT_LUT_CTRL_LUT_SEL <= std_logic_vector(to_unsigned(integer(0),4));
      else
         for j in  15 downto 12  loop
            if(wEn(88) = '1' and bitEnN(j) = '0') then
               field_rw_LUT_LUT_CTRL_LUT_SEL(j-12) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_LUT_LUT_CTRL_LUT_SEL;

------------------------------------------------------------------------------------------
-- Field name: LUT_WRN
-- Field type: RW
------------------------------------------------------------------------------------------
rb_LUT_LUT_CTRL(11) <= field_rw_LUT_LUT_CTRL_LUT_WRN;
regfile.LUT.LUT_CTRL.LUT_WRN <= field_rw_LUT_LUT_CTRL_LUT_WRN;


------------------------------------------------------------------------------------------
-- Process: P_LUT_LUT_CTRL_LUT_WRN
------------------------------------------------------------------------------------------
P_LUT_LUT_CTRL_LUT_WRN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_LUT_LUT_CTRL_LUT_WRN <= '0';
      else
         if(wEn(88) = '1' and bitEnN(11) = '0') then
            field_rw_LUT_LUT_CTRL_LUT_WRN <= reg_writedata(11);
         end if;
      end if;
   end if;
end process P_LUT_LUT_CTRL_LUT_WRN;

------------------------------------------------------------------------------------------
-- Field name: LUT_SS
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_LUT_LUT_CTRL(10) <= '0';
regfile.LUT.LUT_CTRL.LUT_SS <= field_wautoclr_LUT_LUT_CTRL_LUT_SS;


------------------------------------------------------------------------------------------
-- Process: P_LUT_LUT_CTRL_LUT_SS
------------------------------------------------------------------------------------------
P_LUT_LUT_CTRL_LUT_SS : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_LUT_LUT_CTRL_LUT_SS <= '0';
      else
         if(wEn(88) = '1' and bitEnN(10) = '0') then
            field_wautoclr_LUT_LUT_CTRL_LUT_SS <= reg_writedata(10);
         else
            field_wautoclr_LUT_LUT_CTRL_LUT_SS <= '0';
         end if;
      end if;
   end if;
end process P_LUT_LUT_CTRL_LUT_SS;

------------------------------------------------------------------------------------------
-- Field name: LUT_ADD(9 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_LUT_LUT_CTRL(9 downto 0) <= field_rw_LUT_LUT_CTRL_LUT_ADD(9 downto 0);
regfile.LUT.LUT_CTRL.LUT_ADD <= field_rw_LUT_LUT_CTRL_LUT_ADD(9 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_LUT_LUT_CTRL_LUT_ADD
------------------------------------------------------------------------------------------
P_LUT_LUT_CTRL_LUT_ADD : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_LUT_LUT_CTRL_LUT_ADD <= std_logic_vector(to_unsigned(integer(0),10));
      else
         for j in  9 downto 0  loop
            if(wEn(88) = '1' and bitEnN(j) = '0') then
               field_rw_LUT_LUT_CTRL_LUT_ADD(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_LUT_LUT_CTRL_LUT_ADD;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: LUT_LUT_RB
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(89) <= (hit(89)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: LUT_RB
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_LUT_LUT_RB(7 downto 0) <= std_logic_vector(to_unsigned(integer(0),8));
regfile.LUT.LUT_RB.LUT_RB <= rb_LUT_LUT_RB(7 downto 0);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: BAYER_BAYER_CAPABILITIES
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(90) <= (hit(90)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: BAYER_VER(1 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_BAYER_BAYER_CAPABILITIES(1 downto 0) <= regfile.BAYER.BAYER_CAPABILITIES.BAYER_VER;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: BAYER_WB_MUL1
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(91) <= (hit(91)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: WB_MULT_G(31 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_BAYER_WB_MUL1(31 downto 16) <= field_rw_BAYER_WB_MUL1_WB_MULT_G(15 downto 0);
regfile.BAYER.WB_MUL1.WB_MULT_G <= field_rw_BAYER_WB_MUL1_WB_MULT_G(15 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_BAYER_WB_MUL1_WB_MULT_G
------------------------------------------------------------------------------------------
P_BAYER_WB_MUL1_WB_MULT_G : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_BAYER_WB_MUL1_WB_MULT_G <= std_logic_vector(to_unsigned(integer(4096),16));
      else
         for j in  31 downto 16  loop
            if(wEn(91) = '1' and bitEnN(j) = '0') then
               field_rw_BAYER_WB_MUL1_WB_MULT_G(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_BAYER_WB_MUL1_WB_MULT_G;

------------------------------------------------------------------------------------------
-- Field name: WB_MULT_B(15 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_BAYER_WB_MUL1(15 downto 0) <= field_rw_BAYER_WB_MUL1_WB_MULT_B(15 downto 0);
regfile.BAYER.WB_MUL1.WB_MULT_B <= field_rw_BAYER_WB_MUL1_WB_MULT_B(15 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_BAYER_WB_MUL1_WB_MULT_B
------------------------------------------------------------------------------------------
P_BAYER_WB_MUL1_WB_MULT_B : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_BAYER_WB_MUL1_WB_MULT_B <= std_logic_vector(to_unsigned(integer(4096),16));
      else
         for j in  15 downto 0  loop
            if(wEn(91) = '1' and bitEnN(j) = '0') then
               field_rw_BAYER_WB_MUL1_WB_MULT_B(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_BAYER_WB_MUL1_WB_MULT_B;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: BAYER_WB_MUL2
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(92) <= (hit(92)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: WB_MULT_R(15 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_BAYER_WB_MUL2(15 downto 0) <= field_rw_BAYER_WB_MUL2_WB_MULT_R(15 downto 0);
regfile.BAYER.WB_MUL2.WB_MULT_R <= field_rw_BAYER_WB_MUL2_WB_MULT_R(15 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_BAYER_WB_MUL2_WB_MULT_R
------------------------------------------------------------------------------------------
P_BAYER_WB_MUL2_WB_MULT_R : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_BAYER_WB_MUL2_WB_MULT_R <= std_logic_vector(to_unsigned(integer(4096),16));
      else
         for j in  15 downto 0  loop
            if(wEn(92) = '1' and bitEnN(j) = '0') then
               field_rw_BAYER_WB_MUL2_WB_MULT_R(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_BAYER_WB_MUL2_WB_MULT_R;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: BAYER_WB_B_ACC
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(93) <= (hit(93)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: B_ACC(30 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_BAYER_WB_B_ACC(30 downto 0) <= regfile.BAYER.WB_B_ACC.B_ACC;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: BAYER_WB_G_ACC
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(94) <= (hit(94)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: G_ACC(31 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_BAYER_WB_G_ACC(31 downto 0) <= regfile.BAYER.WB_G_ACC.G_ACC;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: BAYER_WB_R_ACC
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(95) <= (hit(95)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: R_ACC(30 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_BAYER_WB_R_ACC(30 downto 0) <= regfile.BAYER.WB_R_ACC.R_ACC;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: BAYER_CCM_CTRL
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(96) <= (hit(96)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: CCM_EN
-- Field type: RW
------------------------------------------------------------------------------------------
rb_BAYER_CCM_CTRL(0) <= field_rw_BAYER_CCM_CTRL_CCM_EN;
regfile.BAYER.CCM_CTRL.CCM_EN <= field_rw_BAYER_CCM_CTRL_CCM_EN;


------------------------------------------------------------------------------------------
-- Process: P_BAYER_CCM_CTRL_CCM_EN
------------------------------------------------------------------------------------------
P_BAYER_CCM_CTRL_CCM_EN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_BAYER_CCM_CTRL_CCM_EN <= '0';
      else
         if(wEn(96) = '1' and bitEnN(0) = '0') then
            field_rw_BAYER_CCM_CTRL_CCM_EN <= reg_writedata(0);
         end if;
      end if;
   end if;
end process P_BAYER_CCM_CTRL_CCM_EN;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: BAYER_CCM_KR1
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(97) <= (hit(97)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: Kg(27 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_BAYER_CCM_KR1(27 downto 16) <= field_rw_BAYER_CCM_KR1_Kg(11 downto 0);
regfile.BAYER.CCM_KR1.Kg <= field_rw_BAYER_CCM_KR1_Kg(11 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_BAYER_CCM_KR1_Kg
------------------------------------------------------------------------------------------
P_BAYER_CCM_KR1_Kg : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_BAYER_CCM_KR1_Kg <= std_logic_vector(to_unsigned(integer(0),12));
      else
         for j in  27 downto 16  loop
            if(wEn(97) = '1' and bitEnN(j) = '0') then
               field_rw_BAYER_CCM_KR1_Kg(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_BAYER_CCM_KR1_Kg;

------------------------------------------------------------------------------------------
-- Field name: Kr(11 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_BAYER_CCM_KR1(11 downto 0) <= field_rw_BAYER_CCM_KR1_Kr(11 downto 0);
regfile.BAYER.CCM_KR1.Kr <= field_rw_BAYER_CCM_KR1_Kr(11 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_BAYER_CCM_KR1_Kr
------------------------------------------------------------------------------------------
P_BAYER_CCM_KR1_Kr : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_BAYER_CCM_KR1_Kr <= std_logic_vector(to_unsigned(integer(256),12));
      else
         for j in  11 downto 0  loop
            if(wEn(97) = '1' and bitEnN(j) = '0') then
               field_rw_BAYER_CCM_KR1_Kr(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_BAYER_CCM_KR1_Kr;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: BAYER_CCM_KR2
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(98) <= (hit(98)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: KOff(24 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_BAYER_CCM_KR2(24 downto 16) <= field_rw_BAYER_CCM_KR2_KOff(8 downto 0);
regfile.BAYER.CCM_KR2.KOff <= field_rw_BAYER_CCM_KR2_KOff(8 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_BAYER_CCM_KR2_KOff
------------------------------------------------------------------------------------------
P_BAYER_CCM_KR2_KOff : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_BAYER_CCM_KR2_KOff <= std_logic_vector(to_unsigned(integer(0),9));
      else
         for j in  24 downto 16  loop
            if(wEn(98) = '1' and bitEnN(j) = '0') then
               field_rw_BAYER_CCM_KR2_KOff(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_BAYER_CCM_KR2_KOff;

------------------------------------------------------------------------------------------
-- Field name: Kb(11 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_BAYER_CCM_KR2(11 downto 0) <= field_rw_BAYER_CCM_KR2_Kb(11 downto 0);
regfile.BAYER.CCM_KR2.Kb <= field_rw_BAYER_CCM_KR2_Kb(11 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_BAYER_CCM_KR2_Kb
------------------------------------------------------------------------------------------
P_BAYER_CCM_KR2_Kb : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_BAYER_CCM_KR2_Kb <= std_logic_vector(to_unsigned(integer(0),12));
      else
         for j in  11 downto 0  loop
            if(wEn(98) = '1' and bitEnN(j) = '0') then
               field_rw_BAYER_CCM_KR2_Kb(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_BAYER_CCM_KR2_Kb;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: BAYER_CCM_KG1
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(99) <= (hit(99)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: Kg(27 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_BAYER_CCM_KG1(27 downto 16) <= field_rw_BAYER_CCM_KG1_Kg(11 downto 0);
regfile.BAYER.CCM_KG1.Kg <= field_rw_BAYER_CCM_KG1_Kg(11 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_BAYER_CCM_KG1_Kg
------------------------------------------------------------------------------------------
P_BAYER_CCM_KG1_Kg : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_BAYER_CCM_KG1_Kg <= std_logic_vector(to_unsigned(integer(256),12));
      else
         for j in  27 downto 16  loop
            if(wEn(99) = '1' and bitEnN(j) = '0') then
               field_rw_BAYER_CCM_KG1_Kg(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_BAYER_CCM_KG1_Kg;

------------------------------------------------------------------------------------------
-- Field name: Kr(11 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_BAYER_CCM_KG1(11 downto 0) <= field_rw_BAYER_CCM_KG1_Kr(11 downto 0);
regfile.BAYER.CCM_KG1.Kr <= field_rw_BAYER_CCM_KG1_Kr(11 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_BAYER_CCM_KG1_Kr
------------------------------------------------------------------------------------------
P_BAYER_CCM_KG1_Kr : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_BAYER_CCM_KG1_Kr <= std_logic_vector(to_unsigned(integer(0),12));
      else
         for j in  11 downto 0  loop
            if(wEn(99) = '1' and bitEnN(j) = '0') then
               field_rw_BAYER_CCM_KG1_Kr(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_BAYER_CCM_KG1_Kr;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: BAYER_CCM_KG2
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(100) <= (hit(100)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: KOff(24 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_BAYER_CCM_KG2(24 downto 16) <= field_rw_BAYER_CCM_KG2_KOff(8 downto 0);
regfile.BAYER.CCM_KG2.KOff <= field_rw_BAYER_CCM_KG2_KOff(8 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_BAYER_CCM_KG2_KOff
------------------------------------------------------------------------------------------
P_BAYER_CCM_KG2_KOff : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_BAYER_CCM_KG2_KOff <= std_logic_vector(to_unsigned(integer(0),9));
      else
         for j in  24 downto 16  loop
            if(wEn(100) = '1' and bitEnN(j) = '0') then
               field_rw_BAYER_CCM_KG2_KOff(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_BAYER_CCM_KG2_KOff;

------------------------------------------------------------------------------------------
-- Field name: Kb(11 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_BAYER_CCM_KG2(11 downto 0) <= field_rw_BAYER_CCM_KG2_Kb(11 downto 0);
regfile.BAYER.CCM_KG2.Kb <= field_rw_BAYER_CCM_KG2_Kb(11 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_BAYER_CCM_KG2_Kb
------------------------------------------------------------------------------------------
P_BAYER_CCM_KG2_Kb : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_BAYER_CCM_KG2_Kb <= std_logic_vector(to_unsigned(integer(0),12));
      else
         for j in  11 downto 0  loop
            if(wEn(100) = '1' and bitEnN(j) = '0') then
               field_rw_BAYER_CCM_KG2_Kb(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_BAYER_CCM_KG2_Kb;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: BAYER_CCM_KB1
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(101) <= (hit(101)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: Kg(27 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_BAYER_CCM_KB1(27 downto 16) <= field_rw_BAYER_CCM_KB1_Kg(11 downto 0);
regfile.BAYER.CCM_KB1.Kg <= field_rw_BAYER_CCM_KB1_Kg(11 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_BAYER_CCM_KB1_Kg
------------------------------------------------------------------------------------------
P_BAYER_CCM_KB1_Kg : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_BAYER_CCM_KB1_Kg <= std_logic_vector(to_unsigned(integer(0),12));
      else
         for j in  27 downto 16  loop
            if(wEn(101) = '1' and bitEnN(j) = '0') then
               field_rw_BAYER_CCM_KB1_Kg(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_BAYER_CCM_KB1_Kg;

------------------------------------------------------------------------------------------
-- Field name: Kr(11 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_BAYER_CCM_KB1(11 downto 0) <= field_rw_BAYER_CCM_KB1_Kr(11 downto 0);
regfile.BAYER.CCM_KB1.Kr <= field_rw_BAYER_CCM_KB1_Kr(11 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_BAYER_CCM_KB1_Kr
------------------------------------------------------------------------------------------
P_BAYER_CCM_KB1_Kr : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_BAYER_CCM_KB1_Kr <= std_logic_vector(to_unsigned(integer(0),12));
      else
         for j in  11 downto 0  loop
            if(wEn(101) = '1' and bitEnN(j) = '0') then
               field_rw_BAYER_CCM_KB1_Kr(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_BAYER_CCM_KB1_Kr;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: BAYER_CCM_KB2
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(102) <= (hit(102)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: KOff(24 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_BAYER_CCM_KB2(24 downto 16) <= field_rw_BAYER_CCM_KB2_KOff(8 downto 0);
regfile.BAYER.CCM_KB2.KOff <= field_rw_BAYER_CCM_KB2_KOff(8 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_BAYER_CCM_KB2_KOff
------------------------------------------------------------------------------------------
P_BAYER_CCM_KB2_KOff : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_BAYER_CCM_KB2_KOff <= std_logic_vector(to_unsigned(integer(0),9));
      else
         for j in  24 downto 16  loop
            if(wEn(102) = '1' and bitEnN(j) = '0') then
               field_rw_BAYER_CCM_KB2_KOff(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_BAYER_CCM_KB2_KOff;

------------------------------------------------------------------------------------------
-- Field name: Kb(11 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_BAYER_CCM_KB2(11 downto 0) <= field_rw_BAYER_CCM_KB2_Kb(11 downto 0);
regfile.BAYER.CCM_KB2.Kb <= field_rw_BAYER_CCM_KB2_Kb(11 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_BAYER_CCM_KB2_Kb
------------------------------------------------------------------------------------------
P_BAYER_CCM_KB2_Kb : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_BAYER_CCM_KB2_Kb <= std_logic_vector(to_unsigned(integer(256),12));
      else
         for j in  11 downto 0  loop
            if(wEn(102) = '1' and bitEnN(j) = '0') then
               field_rw_BAYER_CCM_KB2_Kb(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_BAYER_CCM_KB2_Kb;

------------------------------------------------------------------------------------------
-- External section: SYSMONXIL
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Process: P_ext_SYSMONXIL_addr
------------------------------------------------------------------------------------------
P_ext_SYSMONXIL_addr : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         ext_SYSMONXIL_addr <= (others=>'0');
      else
         if (reg_write = '1' or reg_read = '1') then
            ext_SYSMONXIL_addr <= reg_addr(7 downto 2);
         end if;
      end if;
   end if;
end process P_ext_SYSMONXIL_addr;


------------------------------------------------------------------------------------------
-- Process: P_ext_SYSMONXIL_readEn
------------------------------------------------------------------------------------------
P_ext_SYSMONXIL_readEn : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         ext_SYSMONXIL_readEn <= '0';
      else
         ext_SYSMONXIL_readEn <= hit(103) and reg_read;
      end if;
   end if;
end process P_ext_SYSMONXIL_readEn;


------------------------------------------------------------------------------------------
-- Process: P_ext_SYSMONXIL_readDataValid_pipeline
------------------------------------------------------------------------------------------
P_ext_SYSMONXIL_readDataValid_pipeline : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         ext_SYSMONXIL_readDataValid_FF <= '0';
      else
         ext_SYSMONXIL_readDataValid_FF <= ext_SYSMONXIL_readDataValid;
      end if;
   end if;
end process P_ext_SYSMONXIL_readDataValid_pipeline;


------------------------------------------------------------------------------------------
-- Process: P_ext_SYSMONXIL_readData_pipeline
------------------------------------------------------------------------------------------
P_ext_SYSMONXIL_readData_pipeline : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         ext_SYSMONXIL_readData_FF <= (others=>'0');
      else
         ext_SYSMONXIL_readData_FF <= ext_SYSMONXIL_readData;
      end if;
   end if;
end process P_ext_SYSMONXIL_readData_pipeline;


------------------------------------------------------------------------------------------
-- Process: P_ext_SYSMONXIL_readPending
------------------------------------------------------------------------------------------
P_ext_SYSMONXIL_readPending : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         ext_SYSMONXIL_readPending <= '0';
      else
         if (reg_read = '1' and hit(103) = '1') then
            ext_SYSMONXIL_readPending <= '1';

         elsif (ext_SYSMONXIL_readDataValid_FF = '1') then
            ext_SYSMONXIL_readPending <= '0';

         end if;
      end if;
   end if;
end process P_ext_SYSMONXIL_readPending;


------------------------------------------------------------------------------------------
-- Process: P_reg_wait
------------------------------------------------------------------------------------------
P_reg_wait : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         reg_wait <= '0';
      else
         -- Wait signal is asserted
         if(reg_read = '1' and ldData = '0') then
            reg_wait <= '1';
         -- Wait signal is deasserted
         elsif(ldData = '1') then
            reg_wait <= '0';
         end if;
      end if;
   end if;
end process P_reg_wait;


------------------------------------------------------------------------------------------
-- Process: P_reg_readdatavalid
------------------------------------------------------------------------------------------
P_reg_readdatavalid : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         reg_readdatavalid <= '0';
      else
         reg_readdatavalid <= ldData;
      end if;
   end if;
end process P_reg_readdatavalid;


ldData <= (reg_read and not(hit(103)))  or (ext_SYSMONXIL_readPending and ext_SYSMONXIL_readDataValid_FF);

end rtl;

