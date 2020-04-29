-------------------------------------------------------------------------------
-- File                : regfile_xgs_athena.vhd
-- Project             : FDK
-- Module              : regfile_xgs_athena_pack
-- Created on          : 2020/04/29 11:37:34
-- Created by          : imaval
-- FDK IDE Version     : 4.7.0_beta4
-- Build ID            : I20191220-1537
-- Register file CRC32 : 0x6C02943B
-------------------------------------------------------------------------------
library ieee;        -- The standard IEEE library
   use ieee.std_logic_1164.all  ;
   use ieee.numeric_std.all     ;
   use ieee.std_logic_unsigned.all;


package regfile_xgs_athena_pack is
   --------------------------------------------------------------------------------
   -- Address constants
   --------------------------------------------------------------------------------
   constant K_SYSTEM_TAG_ADDR           : natural := 16#0#;
   constant K_SYSTEM_VERSION_ADDR       : natural := 16#4#;
   constant K_SYSTEM_CAPABILITY_ADDR    : natural := 16#8#;
   constant K_SYSTEM_SCRATCHPAD_ADDR    : natural := 16#c#;
   constant K_DMA_CTRL_ADDR             : natural := 16#70#;
   constant K_DMA_FSTART_ADDR           : natural := 16#74#;
   constant K_DMA_FSTART_HIGH_ADDR      : natural := 16#78#;
   constant K_DMA_FSTART_G_ADDR         : natural := 16#7c#;
   constant K_DMA_FSTART_G_HIGH_ADDR    : natural := 16#80#;
   constant K_DMA_FSTART_R_ADDR         : natural := 16#84#;
   constant K_DMA_FSTART_R_HIGH_ADDR    : natural := 16#88#;
   constant K_DMA_LINE_PITCH_ADDR       : natural := 16#8c#;
   constant K_DMA_LINE_SIZE_ADDR        : natural := 16#90#;
   constant K_DMA_CSC_ADDR              : natural := 16#94#;
   constant K_ACQ_GRAB_CTRL_ADDR        : natural := 16#100#;
   constant K_ACQ_GRAB_STAT_ADDR        : natural := 16#108#;
   constant K_ACQ_READOUT_CFG1_ADDR     : natural := 16#110#;
   constant K_ACQ_READOUT_CFG2_ADDR     : natural := 16#118#;
   constant K_ACQ_READOUT_CFG3_ADDR     : natural := 16#120#;
   constant K_ACQ_EXP_CTRL1_ADDR        : natural := 16#128#;
   constant K_ACQ_EXP_CTRL2_ADDR        : natural := 16#130#;
   constant K_ACQ_EXP_CTRL3_ADDR        : natural := 16#138#;
   constant K_ACQ_TRIGGER_DELAY_ADDR    : natural := 16#140#;
   constant K_ACQ_STROBE_CTRL1_ADDR     : natural := 16#148#;
   constant K_ACQ_STROBE_CTRL2_ADDR     : natural := 16#150#;
   constant K_ACQ_ACQ_SER_CTRL_ADDR     : natural := 16#158#;
   constant K_ACQ_ACQ_SER_ADDATA_ADDR   : natural := 16#160#;
   constant K_ACQ_ACQ_SER_STAT_ADDR     : natural := 16#168#;
   constant K_ACQ_LVDS_CTRL_ADDR        : natural := 16#170#;
   constant K_ACQ_LVDS_CTRL2_ADDR       : natural := 16#178#;
   constant K_ACQ_LVDS_TRAINING_ADDR    : natural := 16#180#;
   constant K_ACQ_LVDS_STAT_ADDR        : natural := 16#188#;
   constant K_ACQ_LVDS_STAT2_ADDR       : natural := 16#18c#;
   constant K_ACQ_SENSOR_CTRL_ADDR      : natural := 16#190#;
   constant K_ACQ_SENSOR_STAT_ADDR      : natural := 16#198#;
   constant K_ACQ_SENSOR_GEN_CFG_ADDR   : natural := 16#1a0#;
   constant K_ACQ_SENSOR_INT_CTL_ADDR   : natural := 16#1a8#;
   constant K_ACQ_SENSOR_GAIN_ANA_ADDR  : natural := 16#1b0#;
   constant K_ACQ_SENSOR_BLACK_CAL_ADDR : natural := 16#1b8#;
   constant K_ACQ_SENSOR_ROI_CONF0_ADDR : natural := 16#1c0#;
   constant K_ACQ_SENSOR_ROI2_CONF0_ADDR : natural := 16#1c4#;
   constant K_ACQ_SENSOR_ROI_CONF1_ADDR : natural := 16#1c8#;
   constant K_ACQ_SENSOR_ROI2_CONF1_ADDR : natural := 16#1cc#;
   constant K_ACQ_SENSOR_ROI_CONF2_ADDR : natural := 16#1d0#;
   constant K_ACQ_SENSOR_ROI2_CONF2_ADDR : natural := 16#1d4#;
   constant K_ACQ_CRC_ADDR              : natural := 16#1d8#;
   constant K_ACQ_DEBUG_PINS_ADDR       : natural := 16#1e0#;
   constant K_ACQ_TRIGGER_MISSED_ADDR   : natural := 16#1e8#;
   constant K_ACQ_SENSOR_FPS_ADDR       : natural := 16#1f0#;
   constant K_ACQ_DEBUG_ADDR            : natural := 16#220#;
   constant K_ACQ_DEBUG_CNTR1_ADDR      : natural := 16#228#;
   constant K_ACQ_DEBUG_CNTR2_ADDR      : natural := 16#230#;
   constant K_ACQ_DEBUG_CNTR3_ADDR      : natural := 16#234#;
   constant K_ACQ_EXP_FOT_ADDR          : natural := 16#23c#;
   constant K_ACQ_ACQ_SFNC_ADDR         : natural := 16#244#;
   constant K_ACQ_NOPEL_ADDR            : natural := 16#254#;
   constant K_DATA_LUT_CTRL_ADDR        : natural := 16#300#;
   constant K_DATA_LUT_RB_ADDR          : natural := 16#308#;
   constant K_DATA_WB_MULT1_ADDR        : natural := 16#310#;
   constant K_DATA_WB_MULT2_ADDR        : natural := 16#318#;
   constant K_DATA_WB_B_ACC_ADDR        : natural := 16#320#;
   constant K_DATA_WB_G_ACC_ADDR        : natural := 16#328#;
   constant K_DATA_WB_R_ACC_ADDR        : natural := 16#330#;
   constant K_DATA_FPN_ADD_ADDR         : natural := 16#338#;
   constant K_DATA_FPN_READ_REG_ADDR    : natural := 16#33c#;
   constant K_DATA_FPN_DATA_0_ADDR      : natural := 16#340#;
   constant K_DATA_FPN_DATA_1_ADDR      : natural := 16#344#;
   constant K_DATA_FPN_DATA_2_ADDR      : natural := 16#348#;
   constant K_DATA_FPN_DATA_3_ADDR      : natural := 16#34c#;
   constant K_DATA_FPN_DATA_4_ADDR      : natural := 16#350#;
   constant K_DATA_FPN_DATA_5_ADDR      : natural := 16#354#;
   constant K_DATA_FPN_DATA_6_ADDR      : natural := 16#358#;
   constant K_DATA_FPN_DATA_7_ADDR      : natural := 16#35c#;
   constant K_DATA_FPN_CONTRAST_ADDR    : natural := 16#360#;
   constant K_DATA_FPN_ACC_ADD_ADDR     : natural := 16#368#;
   constant K_DATA_FPN_ACC_DATA_ADDR    : natural := 16#370#;
   constant K_DATA_DPC_LIST_CTRL_ADDR   : natural := 16#380#;
   constant K_DATA_DPC_LIST_DATA_ADDR   : natural := 16#384#;
   constant K_DATA_DPC_LIST_DATA_RD_ADDR : natural := 16#388#;
   constant K_HISPI_CTRL_ADDR           : natural := 16#400#;
   constant K_HISPI_STATUS_ADDR         : natural := 16#404#;
   
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
      VALUE          : std_logic_vector(13 downto 0);
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
      DUP_LAST_LINE  : std_logic;
      REVERSE_Y      : std_logic;
      REVERSE_X      : std_logic;
   end record DMA_CSC_TYPE;

   constant INIT_DMA_CSC_TYPE : DMA_CSC_TYPE := (
      COLOR_SPACE     => (others=> 'Z'),
      DUP_LAST_LINE   => 'Z',
      REVERSE_Y       => 'Z',
      REVERSE_X       => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DMA_CSC_TYPE) return std_logic_vector;
   function to_DMA_CSC_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_CSC_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: GRAB_CTRL
   ------------------------------------------------------------------------------------------
   type ACQ_GRAB_CTRL_TYPE is record
      RESET_GRAB     : std_logic;
      GRAB_ROI2_EN   : std_logic;
      ABORT_GRAB     : std_logic;
      SLOPE_CFG      : std_logic_vector(1 downto 0);
      TRIGGER_OVERLAP_BUFFn: std_logic;
      TRIGGER_OVERLAP: std_logic;
      TRIGGER_ACT    : std_logic_vector(2 downto 0);
      TRIGGER_SRC    : std_logic_vector(1 downto 0);
      GRAB_SS        : std_logic;
      BUFFER_ID      : std_logic;
      GRAB_CMD       : std_logic;
   end record ACQ_GRAB_CTRL_TYPE;

   constant INIT_ACQ_GRAB_CTRL_TYPE : ACQ_GRAB_CTRL_TYPE := (
      RESET_GRAB      => 'Z',
      GRAB_ROI2_EN    => 'Z',
      ABORT_GRAB      => 'Z',
      SLOPE_CFG       => (others=> 'Z'),
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
      ROT_LENGTH     : std_logic_vector(9 downto 0);
      FOT_LENGTH     : std_logic_vector(15 downto 0);
   end record ACQ_READOUT_CFG1_TYPE;

   constant INIT_ACQ_READOUT_CFG1_TYPE : ACQ_READOUT_CFG1_TYPE := (
      ROT_LENGTH      => (others=> 'Z'),
      FOT_LENGTH      => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_READOUT_CFG1_TYPE) return std_logic_vector;
   function to_ACQ_READOUT_CFG1_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_READOUT_CFG1_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: READOUT_CFG2
   ------------------------------------------------------------------------------------------
   type ACQ_READOUT_CFG2_TYPE is record
      READOUT_EN     : std_logic;
      READOUT_LENGTH : std_logic_vector(23 downto 0);
   end record ACQ_READOUT_CFG2_TYPE;

   constant INIT_ACQ_READOUT_CFG2_TYPE : ACQ_READOUT_CFG2_TYPE := (
      READOUT_EN      => 'Z',
      READOUT_LENGTH  => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_READOUT_CFG2_TYPE) return std_logic_vector;
   function to_ACQ_READOUT_CFG2_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_READOUT_CFG2_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: READOUT_CFG3
   ------------------------------------------------------------------------------------------
   type ACQ_READOUT_CFG3_TYPE is record
      BL_LINES       : std_logic_vector(7 downto 0);
   end record ACQ_READOUT_CFG3_TYPE;

   constant INIT_ACQ_READOUT_CFG3_TYPE : ACQ_READOUT_CFG3_TYPE := (
      BL_LINES        => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_READOUT_CFG3_TYPE) return std_logic_vector;
   function to_ACQ_READOUT_CFG3_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_READOUT_CFG3_TYPE;
   
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
      SER_ROI_UPDATE : std_logic;
      SER_BLACKCAL_UPDATE: std_logic;
      SER_GAIN_UPDATE: std_logic;
      SER_SUBBIN_UPDATE: std_logic;
      SER_WRn        : std_logic;
      SER_CMD        : std_logic_vector(1 downto 0);
      SER_RF_SS      : std_logic;
      SER_WF_SS      : std_logic;
   end record ACQ_ACQ_SER_CTRL_TYPE;

   constant INIT_ACQ_ACQ_SER_CTRL_TYPE : ACQ_ACQ_SER_CTRL_TYPE := (
      SER_ROI_UPDATE  => 'Z',
      SER_BLACKCAL_UPDATE => 'Z',
      SER_GAIN_UPDATE => 'Z',
      SER_SUBBIN_UPDATE => 'Z',
      SER_WRn         => 'Z',
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
      SER_ADD        : std_logic_vector(8 downto 0);
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
   -- Register Name: LVDS_CTRL
   ------------------------------------------------------------------------------------------
   type ACQ_LVDS_CTRL_TYPE is record
      LVDS_BIT_RATE  : std_logic_vector(15 downto 0);
      LVDS_MODE      : std_logic;
      LVDS_SER_FACTOR: std_logic_vector(3 downto 0);
      LVDS_CH        : std_logic_vector(3 downto 0);
      LVDS_START_CALIB: std_logic;
      LVDS_SYS_RESET : std_logic;
   end record ACQ_LVDS_CTRL_TYPE;

   constant INIT_ACQ_LVDS_CTRL_TYPE : ACQ_LVDS_CTRL_TYPE := (
      LVDS_BIT_RATE   => (others=> 'Z'),
      LVDS_MODE       => 'Z',
      LVDS_SER_FACTOR => (others=> 'Z'),
      LVDS_CH         => (others=> 'Z'),
      LVDS_START_CALIB => 'Z',
      LVDS_SYS_RESET  => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_LVDS_CTRL_TYPE) return std_logic_vector;
   function to_ACQ_LVDS_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_LVDS_CTRL_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: LVDS_CTRL2
   ------------------------------------------------------------------------------------------
   type ACQ_LVDS_CTRL2_TYPE is record
      REMAP_MODE_SUPP: std_logic_vector(7 downto 0);
      LVDS_DECOD_EN  : std_logic;
      LVDS_DECOD_REMAP_MODE: std_logic_vector(2 downto 0);
   end record ACQ_LVDS_CTRL2_TYPE;

   constant INIT_ACQ_LVDS_CTRL2_TYPE : ACQ_LVDS_CTRL2_TYPE := (
      REMAP_MODE_SUPP => (others=> 'Z'),
      LVDS_DECOD_EN   => 'Z',
      LVDS_DECOD_REMAP_MODE => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_LVDS_CTRL2_TYPE) return std_logic_vector;
   function to_ACQ_LVDS_CTRL2_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_LVDS_CTRL2_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: LVDS_TRAINING
   ------------------------------------------------------------------------------------------
   type ACQ_LVDS_TRAINING_TYPE is record
      DATA_TRAINING  : std_logic_vector(9 downto 0);
      CRTL_TRAINING  : std_logic_vector(9 downto 0);
   end record ACQ_LVDS_TRAINING_TYPE;

   constant INIT_ACQ_LVDS_TRAINING_TYPE : ACQ_LVDS_TRAINING_TYPE := (
      DATA_TRAINING   => (others=> 'Z'),
      CRTL_TRAINING   => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_LVDS_TRAINING_TYPE) return std_logic_vector;
   function to_ACQ_LVDS_TRAINING_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_LVDS_TRAINING_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: LVDS_STAT
   ------------------------------------------------------------------------------------------
   type ACQ_LVDS_STAT_TYPE is record
      IDELAY_RDY     : std_logic;
      LVDS_RDY       : std_logic;
      LVDS_CALIB_OK  : std_logic;
      LVDS_CALIB_ACT : std_logic;
      BS_DONE_STAT   : std_logic;
      BS_CH_LOCK_STAT: std_logic_vector(8 downto 0);
      PD_DONE_STAT   : std_logic;
      PD_CH_LOCK_STAT: std_logic_vector(8 downto 0);
   end record ACQ_LVDS_STAT_TYPE;

   constant INIT_ACQ_LVDS_STAT_TYPE : ACQ_LVDS_STAT_TYPE := (
      IDELAY_RDY      => 'Z',
      LVDS_RDY        => 'Z',
      LVDS_CALIB_OK   => 'Z',
      LVDS_CALIB_ACT  => 'Z',
      BS_DONE_STAT    => 'Z',
      BS_CH_LOCK_STAT => (others=> 'Z'),
      PD_DONE_STAT    => 'Z',
      PD_CH_LOCK_STAT => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_LVDS_STAT_TYPE) return std_logic_vector;
   function to_ACQ_LVDS_STAT_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_LVDS_STAT_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: LVDS_STAT2
   ------------------------------------------------------------------------------------------
   type ACQ_LVDS_STAT2_TYPE is record
      WORD_ALIGN     : std_logic_vector(31 downto 0);
   end record ACQ_LVDS_STAT2_TYPE;

   constant INIT_ACQ_LVDS_STAT2_TYPE : ACQ_LVDS_STAT2_TYPE := (
      WORD_ALIGN      => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_LVDS_STAT2_TYPE) return std_logic_vector;
   function to_ACQ_LVDS_STAT2_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_LVDS_STAT2_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: SENSOR_CTRL
   ------------------------------------------------------------------------------------------
   type ACQ_SENSOR_CTRL_TYPE is record
      SENSOR_REFRESH_TEMP: std_logic;
      SENSOR_POWERDOWN: std_logic;
      SENSOR_REMAP_CFG: std_logic_vector(1 downto 0);
      SENSOR_COLOR   : std_logic;
      SENSOR_REG_UPTATE: std_logic;
      SENSOR_RESETN  : std_logic;
      SENSOR_POWERUP : std_logic;
   end record ACQ_SENSOR_CTRL_TYPE;

   constant INIT_ACQ_SENSOR_CTRL_TYPE : ACQ_SENSOR_CTRL_TYPE := (
      SENSOR_REFRESH_TEMP => 'Z',
      SENSOR_POWERDOWN => 'Z',
      SENSOR_REMAP_CFG => (others=> 'Z'),
      SENSOR_COLOR    => 'Z',
      SENSOR_REG_UPTATE => 'Z',
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
      SENSOR_VCCPIX_PG: std_logic;
      SENSOR_VCC33_PG: std_logic;
      SENSOR_VCC18_PG: std_logic;
      SENSOR_VCCPIX_EN: std_logic;
      SENSOR_VCC33_EN: std_logic;
      SENSOR_VCC18_EN: std_logic;
      SENSOR_POWERUP_STAT: std_logic;
      SENSOR_POWERUP_DONE: std_logic;
   end record ACQ_SENSOR_STAT_TYPE;

   constant INIT_ACQ_SENSOR_STAT_TYPE : ACQ_SENSOR_STAT_TYPE := (
      SENSOR_TEMP     => (others=> 'Z'),
      SENSOR_TEMP_VALID => 'Z',
      SENSOR_POWERDOWN => 'Z',
      SENSOR_RESETN   => 'Z',
      SENSOR_OSC_EN   => 'Z',
      SENSOR_VCCPIX_PG => 'Z',
      SENSOR_VCC33_PG => 'Z',
      SENSOR_VCC18_PG => 'Z',
      SENSOR_VCCPIX_EN => 'Z',
      SENSOR_VCC33_EN => 'Z',
      SENSOR_VCC18_EN => 'Z',
      SENSOR_POWERUP_STAT => 'Z',
      SENSOR_POWERUP_DONE => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_SENSOR_STAT_TYPE) return std_logic_vector;
   function to_ACQ_SENSOR_STAT_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_STAT_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: SENSOR_GEN_CFG
   ------------------------------------------------------------------------------------------
   type ACQ_SENSOR_GEN_CFG_TYPE is record
      reserved_1     : std_logic_vector(6 downto 0);
      BINNING        : std_logic;
      SUBSAMPLING    : std_logic;
      NZROT_XSM_DELAY_ENABLE: std_logic;
      SLAVE_MODE     : std_logic;
      TRIGGERED_MODE : std_logic;
      XLAG_ENABLE    : std_logic;
      ZERO_ROT_ENABLE: std_logic;
      ROLLING_SHUTTER: std_logic;
      ENABLE         : std_logic;
   end record ACQ_SENSOR_GEN_CFG_TYPE;

   constant INIT_ACQ_SENSOR_GEN_CFG_TYPE : ACQ_SENSOR_GEN_CFG_TYPE := (
      reserved_1      => (others=> 'Z'),
      BINNING         => 'Z',
      SUBSAMPLING     => 'Z',
      NZROT_XSM_DELAY_ENABLE => 'Z',
      SLAVE_MODE      => 'Z',
      TRIGGERED_MODE  => 'Z',
      XLAG_ENABLE     => 'Z',
      ZERO_ROT_ENABLE => 'Z',
      ROLLING_SHUTTER => 'Z',
      ENABLE          => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_SENSOR_GEN_CFG_TYPE) return std_logic_vector;
   function to_ACQ_SENSOR_GEN_CFG_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_GEN_CFG_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: SENSOR_INT_CTL
   ------------------------------------------------------------------------------------------
   type ACQ_SENSOR_INT_CTL_TYPE is record
      reserved_2     : std_logic_vector(1 downto 0);
      BINNING_MODE   : std_logic_vector(1 downto 0);
      SUBSAMPLING_MODE: std_logic_vector(1 downto 0);
      reserved1      : std_logic;
      reserved0      : std_logic_vector(7 downto 0);
   end record ACQ_SENSOR_INT_CTL_TYPE;

   constant INIT_ACQ_SENSOR_INT_CTL_TYPE : ACQ_SENSOR_INT_CTL_TYPE := (
      reserved_2      => (others=> 'Z'),
      BINNING_MODE    => (others=> 'Z'),
      SUBSAMPLING_MODE => (others=> 'Z'),
      reserved1       => 'Z',
      reserved0       => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_SENSOR_INT_CTL_TYPE) return std_logic_vector;
   function to_ACQ_SENSOR_INT_CTL_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_INT_CTL_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: SENSOR_GAIN_ANA
   ------------------------------------------------------------------------------------------
   type ACQ_SENSOR_GAIN_ANA_TYPE is record
      reserved       : std_logic_vector(2 downto 0);
      AFE_GAIN0      : std_logic_vector(7 downto 0);
      MUX_GAINSW0    : std_logic_vector(4 downto 0);
   end record ACQ_SENSOR_GAIN_ANA_TYPE;

   constant INIT_ACQ_SENSOR_GAIN_ANA_TYPE : ACQ_SENSOR_GAIN_ANA_TYPE := (
      reserved        => (others=> 'Z'),
      AFE_GAIN0       => (others=> 'Z'),
      MUX_GAINSW0     => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_SENSOR_GAIN_ANA_TYPE) return std_logic_vector;
   function to_ACQ_SENSOR_GAIN_ANA_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_GAIN_ANA_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: SENSOR_BLACK_CAL
   ------------------------------------------------------------------------------------------
   type ACQ_SENSOR_BLACK_CAL_TYPE is record
      CRC_SEED       : std_logic;
      reserved       : std_logic_vector(3 downto 0);
      BLACK_SAMPLES  : std_logic_vector(2 downto 0);
      BLACK_OFFSET   : std_logic_vector(7 downto 0);
   end record ACQ_SENSOR_BLACK_CAL_TYPE;

   constant INIT_ACQ_SENSOR_BLACK_CAL_TYPE : ACQ_SENSOR_BLACK_CAL_TYPE := (
      CRC_SEED        => 'Z',
      reserved        => (others=> 'Z'),
      BLACK_SAMPLES   => (others=> 'Z'),
      BLACK_OFFSET    => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_SENSOR_BLACK_CAL_TYPE) return std_logic_vector;
   function to_ACQ_SENSOR_BLACK_CAL_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_BLACK_CAL_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: SENSOR_ROI_CONF0
   ------------------------------------------------------------------------------------------
   type ACQ_SENSOR_ROI_CONF0_TYPE is record
      X_END_MSB      : std_logic;
      X_START_MSB    : std_logic;
      X_END          : std_logic_vector(7 downto 0);
      X_START        : std_logic_vector(7 downto 0);
   end record ACQ_SENSOR_ROI_CONF0_TYPE;

   constant INIT_ACQ_SENSOR_ROI_CONF0_TYPE : ACQ_SENSOR_ROI_CONF0_TYPE := (
      X_END_MSB       => 'Z',
      X_START_MSB     => 'Z',
      X_END           => (others=> 'Z'),
      X_START         => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_SENSOR_ROI_CONF0_TYPE) return std_logic_vector;
   function to_ACQ_SENSOR_ROI_CONF0_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_ROI_CONF0_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: SENSOR_ROI2_CONF0
   ------------------------------------------------------------------------------------------
   type ACQ_SENSOR_ROI2_CONF0_TYPE is record
      X_END_MSB      : std_logic;
      X_START_MSB    : std_logic;
      X_END          : std_logic_vector(7 downto 0);
      X_START        : std_logic_vector(7 downto 0);
   end record ACQ_SENSOR_ROI2_CONF0_TYPE;

   constant INIT_ACQ_SENSOR_ROI2_CONF0_TYPE : ACQ_SENSOR_ROI2_CONF0_TYPE := (
      X_END_MSB       => 'Z',
      X_START_MSB     => 'Z',
      X_END           => (others=> 'Z'),
      X_START         => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_SENSOR_ROI2_CONF0_TYPE) return std_logic_vector;
   function to_ACQ_SENSOR_ROI2_CONF0_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_ROI2_CONF0_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: SENSOR_ROI_CONF1
   ------------------------------------------------------------------------------------------
   type ACQ_SENSOR_ROI_CONF1_TYPE is record
      reserved       : std_logic_vector(2 downto 0);
      Y_START        : std_logic_vector(12 downto 0);
   end record ACQ_SENSOR_ROI_CONF1_TYPE;

   constant INIT_ACQ_SENSOR_ROI_CONF1_TYPE : ACQ_SENSOR_ROI_CONF1_TYPE := (
      reserved        => (others=> 'Z'),
      Y_START         => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_SENSOR_ROI_CONF1_TYPE) return std_logic_vector;
   function to_ACQ_SENSOR_ROI_CONF1_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_ROI_CONF1_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: SENSOR_ROI2_CONF1
   ------------------------------------------------------------------------------------------
   type ACQ_SENSOR_ROI2_CONF1_TYPE is record
      reserved       : std_logic_vector(2 downto 0);
      Y_START        : std_logic_vector(12 downto 0);
   end record ACQ_SENSOR_ROI2_CONF1_TYPE;

   constant INIT_ACQ_SENSOR_ROI2_CONF1_TYPE : ACQ_SENSOR_ROI2_CONF1_TYPE := (
      reserved        => (others=> 'Z'),
      Y_START         => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_SENSOR_ROI2_CONF1_TYPE) return std_logic_vector;
   function to_ACQ_SENSOR_ROI2_CONF1_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_ROI2_CONF1_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: SENSOR_ROI_CONF2
   ------------------------------------------------------------------------------------------
   type ACQ_SENSOR_ROI_CONF2_TYPE is record
      reserved       : std_logic_vector(2 downto 0);
      Y_END          : std_logic_vector(12 downto 0);
   end record ACQ_SENSOR_ROI_CONF2_TYPE;

   constant INIT_ACQ_SENSOR_ROI_CONF2_TYPE : ACQ_SENSOR_ROI_CONF2_TYPE := (
      reserved        => (others=> 'Z'),
      Y_END           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_SENSOR_ROI_CONF2_TYPE) return std_logic_vector;
   function to_ACQ_SENSOR_ROI_CONF2_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_ROI_CONF2_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: SENSOR_ROI2_CONF2
   ------------------------------------------------------------------------------------------
   type ACQ_SENSOR_ROI2_CONF2_TYPE is record
      reserved       : std_logic_vector(2 downto 0);
      Y_END          : std_logic_vector(12 downto 0);
   end record ACQ_SENSOR_ROI2_CONF2_TYPE;

   constant INIT_ACQ_SENSOR_ROI2_CONF2_TYPE : ACQ_SENSOR_ROI2_CONF2_TYPE := (
      reserved        => (others=> 'Z'),
      Y_END           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_SENSOR_ROI2_CONF2_TYPE) return std_logic_vector;
   function to_ACQ_SENSOR_ROI2_CONF2_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_ROI2_CONF2_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: CRC
   ------------------------------------------------------------------------------------------
   type ACQ_CRC_TYPE is record
      CRC_InitValue  : std_logic;
      CRC_Reset      : std_logic;
      CRC_EN         : std_logic;
      CRC_STATUS     : std_logic_vector(7 downto 0);
   end record ACQ_CRC_TYPE;

   constant INIT_ACQ_CRC_TYPE : ACQ_CRC_TYPE := (
      CRC_InitValue   => 'Z',
      CRC_Reset       => 'Z',
      CRC_EN          => 'Z',
      CRC_STATUS      => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_CRC_TYPE) return std_logic_vector;
   function to_ACQ_CRC_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_CRC_TYPE;
   
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
   -- Register Name: DEBUG
   ------------------------------------------------------------------------------------------
   type ACQ_DEBUG_TYPE is record
      DEBUG_RST_CNTR : std_logic;
      TEST_MODE_PIX_START: std_logic_vector(9 downto 0);
      TEST_MOVE      : std_logic;
      TEST_MODE      : std_logic;
      LED_TEST_COLOR : std_logic_vector(1 downto 0);
      LED_TEST       : std_logic;
   end record ACQ_DEBUG_TYPE;

   constant INIT_ACQ_DEBUG_TYPE : ACQ_DEBUG_TYPE := (
      DEBUG_RST_CNTR  => 'Z',
      TEST_MODE_PIX_START => (others=> 'Z'),
      TEST_MOVE       => 'Z',
      TEST_MODE       => 'Z',
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
      EOF_CNTR       : std_logic_vector(31 downto 0);
   end record ACQ_DEBUG_CNTR1_TYPE;

   constant INIT_ACQ_DEBUG_CNTR1_TYPE : ACQ_DEBUG_CNTR1_TYPE := (
      EOF_CNTR        => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_DEBUG_CNTR1_TYPE) return std_logic_vector;
   function to_ACQ_DEBUG_CNTR1_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_DEBUG_CNTR1_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: DEBUG_CNTR2
   ------------------------------------------------------------------------------------------
   type ACQ_DEBUG_CNTR2_TYPE is record
      EOL_CNTR       : std_logic_vector(11 downto 0);
   end record ACQ_DEBUG_CNTR2_TYPE;

   constant INIT_ACQ_DEBUG_CNTR2_TYPE : ACQ_DEBUG_CNTR2_TYPE := (
      EOL_CNTR        => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_DEBUG_CNTR2_TYPE) return std_logic_vector;
   function to_ACQ_DEBUG_CNTR2_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_DEBUG_CNTR2_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: DEBUG_CNTR3
   ------------------------------------------------------------------------------------------
   type ACQ_DEBUG_CNTR3_TYPE is record
      SENSOR_FRAME_DURATION: std_logic_vector(27 downto 0);
   end record ACQ_DEBUG_CNTR3_TYPE;

   constant INIT_ACQ_DEBUG_CNTR3_TYPE : ACQ_DEBUG_CNTR3_TYPE := (
      SENSOR_FRAME_DURATION => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_DEBUG_CNTR3_TYPE) return std_logic_vector;
   function to_ACQ_DEBUG_CNTR3_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_DEBUG_CNTR3_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: EXP_FOT
   ------------------------------------------------------------------------------------------
   type ACQ_EXP_FOT_TYPE is record
      EXP_FOT        : std_logic;
      EXP_FOT_TIME   : std_logic_vector(11 downto 0);
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
   -- Register Name: NOPEL
   ------------------------------------------------------------------------------------------
   type ACQ_NOPEL_TYPE is record
      NOPEL_FIFO_UNDERRUN: std_logic;
      NOPEL_FIFO_OVERRUN: std_logic;
      NOPEL_FIFO_RST : std_logic;
      NOPEL_BYPASS   : std_logic;
      NOPEL_ENABLE   : std_logic;
      NOPEL_THRESHOLD: std_logic_vector(7 downto 0);
   end record ACQ_NOPEL_TYPE;

   constant INIT_ACQ_NOPEL_TYPE : ACQ_NOPEL_TYPE := (
      NOPEL_FIFO_UNDERRUN => 'Z',
      NOPEL_FIFO_OVERRUN => 'Z',
      NOPEL_FIFO_RST  => 'Z',
      NOPEL_BYPASS    => 'Z',
      NOPEL_ENABLE    => 'Z',
      NOPEL_THRESHOLD => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_NOPEL_TYPE) return std_logic_vector;
   function to_ACQ_NOPEL_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_NOPEL_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: LUT_CTRL
   ------------------------------------------------------------------------------------------
   type DATA_LUT_CTRL_TYPE is record
      LUT_BYPASS     : std_logic;
      LUT_PALETTE_USE: std_logic;
      LUT_PALETTE_W  : std_logic;
      LUT_DATA_W     : std_logic_vector(9 downto 0);
      LUT_SEL        : std_logic_vector(2 downto 0);
      LUT_WRN        : std_logic;
      LUT_SS         : std_logic;
      LUT_ADD        : std_logic_vector(9 downto 0);
   end record DATA_LUT_CTRL_TYPE;

   constant INIT_DATA_LUT_CTRL_TYPE : DATA_LUT_CTRL_TYPE := (
      LUT_BYPASS      => 'Z',
      LUT_PALETTE_USE => 'Z',
      LUT_PALETTE_W   => 'Z',
      LUT_DATA_W      => (others=> 'Z'),
      LUT_SEL         => (others=> 'Z'),
      LUT_WRN         => 'Z',
      LUT_SS          => 'Z',
      LUT_ADD         => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DATA_LUT_CTRL_TYPE) return std_logic_vector;
   function to_DATA_LUT_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return DATA_LUT_CTRL_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: LUT_RB
   ------------------------------------------------------------------------------------------
   type DATA_LUT_RB_TYPE is record
      LUT_RB         : std_logic_vector(9 downto 0);
   end record DATA_LUT_RB_TYPE;

   constant INIT_DATA_LUT_RB_TYPE : DATA_LUT_RB_TYPE := (
      LUT_RB          => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DATA_LUT_RB_TYPE) return std_logic_vector;
   function to_DATA_LUT_RB_TYPE(stdlv : std_logic_vector(31 downto 0)) return DATA_LUT_RB_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: WB_MULT1
   ------------------------------------------------------------------------------------------
   type DATA_WB_MULT1_TYPE is record
      WB_MULT_G      : std_logic_vector(15 downto 0);
      WB_MULT_B      : std_logic_vector(15 downto 0);
   end record DATA_WB_MULT1_TYPE;

   constant INIT_DATA_WB_MULT1_TYPE : DATA_WB_MULT1_TYPE := (
      WB_MULT_G       => (others=> 'Z'),
      WB_MULT_B       => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DATA_WB_MULT1_TYPE) return std_logic_vector;
   function to_DATA_WB_MULT1_TYPE(stdlv : std_logic_vector(31 downto 0)) return DATA_WB_MULT1_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: WB_MULT2
   ------------------------------------------------------------------------------------------
   type DATA_WB_MULT2_TYPE is record
      WB_MULT_R      : std_logic_vector(15 downto 0);
   end record DATA_WB_MULT2_TYPE;

   constant INIT_DATA_WB_MULT2_TYPE : DATA_WB_MULT2_TYPE := (
      WB_MULT_R       => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DATA_WB_MULT2_TYPE) return std_logic_vector;
   function to_DATA_WB_MULT2_TYPE(stdlv : std_logic_vector(31 downto 0)) return DATA_WB_MULT2_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: WB_B_ACC
   ------------------------------------------------------------------------------------------
   type DATA_WB_B_ACC_TYPE is record
      B_ACC          : std_logic_vector(30 downto 0);
   end record DATA_WB_B_ACC_TYPE;

   constant INIT_DATA_WB_B_ACC_TYPE : DATA_WB_B_ACC_TYPE := (
      B_ACC           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DATA_WB_B_ACC_TYPE) return std_logic_vector;
   function to_DATA_WB_B_ACC_TYPE(stdlv : std_logic_vector(31 downto 0)) return DATA_WB_B_ACC_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: WB_G_ACC
   ------------------------------------------------------------------------------------------
   type DATA_WB_G_ACC_TYPE is record
      G_ACC          : std_logic_vector(31 downto 0);
   end record DATA_WB_G_ACC_TYPE;

   constant INIT_DATA_WB_G_ACC_TYPE : DATA_WB_G_ACC_TYPE := (
      G_ACC           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DATA_WB_G_ACC_TYPE) return std_logic_vector;
   function to_DATA_WB_G_ACC_TYPE(stdlv : std_logic_vector(31 downto 0)) return DATA_WB_G_ACC_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: WB_R_ACC
   ------------------------------------------------------------------------------------------
   type DATA_WB_R_ACC_TYPE is record
      R_ACC          : std_logic_vector(30 downto 0);
   end record DATA_WB_R_ACC_TYPE;

   constant INIT_DATA_WB_R_ACC_TYPE : DATA_WB_R_ACC_TYPE := (
      R_ACC           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DATA_WB_R_ACC_TYPE) return std_logic_vector;
   function to_DATA_WB_R_ACC_TYPE(stdlv : std_logic_vector(31 downto 0)) return DATA_WB_R_ACC_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: FPN_ADD
   ------------------------------------------------------------------------------------------
   type DATA_FPN_ADD_TYPE is record
      FPN_73         : std_logic;
      FPN_WE         : std_logic;
      FPN_EN         : std_logic;
      FPN_SS         : std_logic;
      FPN_ADD        : std_logic_vector(9 downto 0);
   end record DATA_FPN_ADD_TYPE;

   constant INIT_DATA_FPN_ADD_TYPE : DATA_FPN_ADD_TYPE := (
      FPN_73          => 'Z',
      FPN_WE          => 'Z',
      FPN_EN          => 'Z',
      FPN_SS          => 'Z',
      FPN_ADD         => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DATA_FPN_ADD_TYPE) return std_logic_vector;
   function to_DATA_FPN_ADD_TYPE(stdlv : std_logic_vector(31 downto 0)) return DATA_FPN_ADD_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: FPN_READ_REG
   ------------------------------------------------------------------------------------------
   type DATA_FPN_READ_REG_TYPE is record
      FPN_READ_PIX_SEL: std_logic_vector(2 downto 0);
      FPN_READ_PRNU  : std_logic_vector(8 downto 0);
      FPN_READ_FPN   : std_logic_vector(10 downto 0);
   end record DATA_FPN_READ_REG_TYPE;

   constant INIT_DATA_FPN_READ_REG_TYPE : DATA_FPN_READ_REG_TYPE := (
      FPN_READ_PIX_SEL => (others=> 'Z'),
      FPN_READ_PRNU   => (others=> 'Z'),
      FPN_READ_FPN    => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DATA_FPN_READ_REG_TYPE) return std_logic_vector;
   function to_DATA_FPN_READ_REG_TYPE(stdlv : std_logic_vector(31 downto 0)) return DATA_FPN_READ_REG_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: FPN_DATA
   ------------------------------------------------------------------------------------------
   type DATA_FPN_DATA_TYPE is record
      FPN_DATA_PRNU  : std_logic_vector(8 downto 0);
      FPN_DATA_FPN   : std_logic_vector(10 downto 0);
   end record DATA_FPN_DATA_TYPE;

   constant INIT_DATA_FPN_DATA_TYPE : DATA_FPN_DATA_TYPE := (
      FPN_DATA_PRNU   => (others=> 'Z'),
      FPN_DATA_FPN    => (others=> 'Z')
   );

   ------------------------------------------------------------------------------------------
   -- Array type: DATA_FPN_DATA_TYPE
   ------------------------------------------------------------------------------------------
   type DATA_FPN_DATA_TYPE_ARRAY is array (7 downto 0) of DATA_FPN_DATA_TYPE;
   constant INIT_DATA_FPN_DATA_TYPE_ARRAY : DATA_FPN_DATA_TYPE_ARRAY := (others => INIT_DATA_FPN_DATA_TYPE);
   -- Casting functions:
   function to_std_logic_vector(reg : DATA_FPN_DATA_TYPE) return std_logic_vector;
   function to_DATA_FPN_DATA_TYPE(stdlv : std_logic_vector(31 downto 0)) return DATA_FPN_DATA_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: FPN_CONTRAST
   ------------------------------------------------------------------------------------------
   type DATA_FPN_CONTRAST_TYPE is record
      CONTRAST_GAIN  : std_logic_vector(11 downto 0);
      CONTRAST_OFFSET: std_logic_vector(7 downto 0);
   end record DATA_FPN_CONTRAST_TYPE;

   constant INIT_DATA_FPN_CONTRAST_TYPE : DATA_FPN_CONTRAST_TYPE := (
      CONTRAST_GAIN   => (others=> 'Z'),
      CONTRAST_OFFSET => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DATA_FPN_CONTRAST_TYPE) return std_logic_vector;
   function to_DATA_FPN_CONTRAST_TYPE(stdlv : std_logic_vector(31 downto 0)) return DATA_FPN_CONTRAST_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: FPN_ACC_ADD
   ------------------------------------------------------------------------------------------
   type DATA_FPN_ACC_ADD_TYPE is record
      FPN_ACC_MODE_SEL: std_logic;
      FPN_ACC_MODE_EN: std_logic;
      FPN_ACC_R_SS   : std_logic;
      FPN_ACC_ADD    : std_logic_vector(11 downto 0);
   end record DATA_FPN_ACC_ADD_TYPE;

   constant INIT_DATA_FPN_ACC_ADD_TYPE : DATA_FPN_ACC_ADD_TYPE := (
      FPN_ACC_MODE_SEL => 'Z',
      FPN_ACC_MODE_EN => 'Z',
      FPN_ACC_R_SS    => 'Z',
      FPN_ACC_ADD     => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DATA_FPN_ACC_ADD_TYPE) return std_logic_vector;
   function to_DATA_FPN_ACC_ADD_TYPE(stdlv : std_logic_vector(31 downto 0)) return DATA_FPN_ACC_ADD_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: FPN_ACC_DATA
   ------------------------------------------------------------------------------------------
   type DATA_FPN_ACC_DATA_TYPE is record
      FPN_ACC_R_WORKING: std_logic;
      FPN_ACC_DATA   : std_logic_vector(23 downto 0);
   end record DATA_FPN_ACC_DATA_TYPE;

   constant INIT_DATA_FPN_ACC_DATA_TYPE : DATA_FPN_ACC_DATA_TYPE := (
      FPN_ACC_R_WORKING => 'Z',
      FPN_ACC_DATA    => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DATA_FPN_ACC_DATA_TYPE) return std_logic_vector;
   function to_DATA_FPN_ACC_DATA_TYPE(stdlv : std_logic_vector(31 downto 0)) return DATA_FPN_ACC_DATA_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: DPC_LIST_CTRL
   ------------------------------------------------------------------------------------------
   type DATA_DPC_LIST_CTRL_TYPE is record
      dpc_fifo_underrun: std_logic;
      dpc_fifo_overrun: std_logic;
      dpc_fifo_reset : std_logic;
      dpc_firstlast_line_rem: std_logic;
      dpc_pattern0_cfg: std_logic;
      dpc_enable     : std_logic;
      dpc_list_count : std_logic_vector(5 downto 0);
      dpc_list_WRn   : std_logic;
      dpc_list_ss    : std_logic;
      dpc_list_add   : std_logic_vector(5 downto 0);
   end record DATA_DPC_LIST_CTRL_TYPE;

   constant INIT_DATA_DPC_LIST_CTRL_TYPE : DATA_DPC_LIST_CTRL_TYPE := (
      dpc_fifo_underrun => 'Z',
      dpc_fifo_overrun => 'Z',
      dpc_fifo_reset  => 'Z',
      dpc_firstlast_line_rem => 'Z',
      dpc_pattern0_cfg => 'Z',
      dpc_enable      => 'Z',
      dpc_list_count  => (others=> 'Z'),
      dpc_list_WRn    => 'Z',
      dpc_list_ss     => 'Z',
      dpc_list_add    => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DATA_DPC_LIST_CTRL_TYPE) return std_logic_vector;
   function to_DATA_DPC_LIST_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return DATA_DPC_LIST_CTRL_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: DPC_LIST_DATA
   ------------------------------------------------------------------------------------------
   type DATA_DPC_LIST_DATA_TYPE is record
      dpc_list_corr_pattern: std_logic_vector(7 downto 0);
      dpc_list_corr_y: std_logic_vector(11 downto 0);
      dpc_list_corr_x: std_logic_vector(11 downto 0);
   end record DATA_DPC_LIST_DATA_TYPE;

   constant INIT_DATA_DPC_LIST_DATA_TYPE : DATA_DPC_LIST_DATA_TYPE := (
      dpc_list_corr_pattern => (others=> 'Z'),
      dpc_list_corr_y => (others=> 'Z'),
      dpc_list_corr_x => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DATA_DPC_LIST_DATA_TYPE) return std_logic_vector;
   function to_DATA_DPC_LIST_DATA_TYPE(stdlv : std_logic_vector(31 downto 0)) return DATA_DPC_LIST_DATA_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: DPC_LIST_DATA_RD
   ------------------------------------------------------------------------------------------
   type DATA_DPC_LIST_DATA_RD_TYPE is record
      dpc_list_corr_pattern: std_logic_vector(7 downto 0);
      dpc_list_corr_y: std_logic_vector(11 downto 0);
      dpc_list_corr_x: std_logic_vector(11 downto 0);
   end record DATA_DPC_LIST_DATA_RD_TYPE;

   constant INIT_DATA_DPC_LIST_DATA_RD_TYPE : DATA_DPC_LIST_DATA_RD_TYPE := (
      dpc_list_corr_pattern => (others=> 'Z'),
      dpc_list_corr_y => (others=> 'Z'),
      dpc_list_corr_x => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DATA_DPC_LIST_DATA_RD_TYPE) return std_logic_vector;
   function to_DATA_DPC_LIST_DATA_RD_TYPE(stdlv : std_logic_vector(31 downto 0)) return DATA_DPC_LIST_DATA_RD_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: CTRL
   ------------------------------------------------------------------------------------------
   type HISPI_CTRL_TYPE is record
      CLR            : std_logic;
      RESET_IDELAYCTRL: std_logic;
   end record HISPI_CTRL_TYPE;

   constant INIT_HISPI_CTRL_TYPE : HISPI_CTRL_TYPE := (
      CLR             => 'Z',
      RESET_IDELAYCTRL => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : HISPI_CTRL_TYPE) return std_logic_vector;
   function to_HISPI_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return HISPI_CTRL_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: STATUS
   ------------------------------------------------------------------------------------------
   type HISPI_STATUS_TYPE is record
      PLL_LOCKED     : std_logic;
   end record HISPI_STATUS_TYPE;

   constant INIT_HISPI_STATUS_TYPE : HISPI_STATUS_TYPE := (
      PLL_LOCKED      => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : HISPI_STATUS_TYPE) return std_logic_vector;
   function to_HISPI_STATUS_TYPE(stdlv : std_logic_vector(31 downto 0)) return HISPI_STATUS_TYPE;
   
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
      CSC             => INIT_DMA_CSC_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Section Name: ACQ
   ------------------------------------------------------------------------------------------
   type ACQ_TYPE is record
      GRAB_CTRL      : ACQ_GRAB_CTRL_TYPE;
      GRAB_STAT      : ACQ_GRAB_STAT_TYPE;
      READOUT_CFG1   : ACQ_READOUT_CFG1_TYPE;
      READOUT_CFG2   : ACQ_READOUT_CFG2_TYPE;
      READOUT_CFG3   : ACQ_READOUT_CFG3_TYPE;
      EXP_CTRL1      : ACQ_EXP_CTRL1_TYPE;
      EXP_CTRL2      : ACQ_EXP_CTRL2_TYPE;
      EXP_CTRL3      : ACQ_EXP_CTRL3_TYPE;
      TRIGGER_DELAY  : ACQ_TRIGGER_DELAY_TYPE;
      STROBE_CTRL1   : ACQ_STROBE_CTRL1_TYPE;
      STROBE_CTRL2   : ACQ_STROBE_CTRL2_TYPE;
      ACQ_SER_CTRL   : ACQ_ACQ_SER_CTRL_TYPE;
      ACQ_SER_ADDATA : ACQ_ACQ_SER_ADDATA_TYPE;
      ACQ_SER_STAT   : ACQ_ACQ_SER_STAT_TYPE;
      LVDS_CTRL      : ACQ_LVDS_CTRL_TYPE;
      LVDS_CTRL2     : ACQ_LVDS_CTRL2_TYPE;
      LVDS_TRAINING  : ACQ_LVDS_TRAINING_TYPE;
      LVDS_STAT      : ACQ_LVDS_STAT_TYPE;
      LVDS_STAT2     : ACQ_LVDS_STAT2_TYPE;
      SENSOR_CTRL    : ACQ_SENSOR_CTRL_TYPE;
      SENSOR_STAT    : ACQ_SENSOR_STAT_TYPE;
      SENSOR_GEN_CFG : ACQ_SENSOR_GEN_CFG_TYPE;
      SENSOR_INT_CTL : ACQ_SENSOR_INT_CTL_TYPE;
      SENSOR_GAIN_ANA: ACQ_SENSOR_GAIN_ANA_TYPE;
      SENSOR_BLACK_CAL: ACQ_SENSOR_BLACK_CAL_TYPE;
      SENSOR_ROI_CONF0: ACQ_SENSOR_ROI_CONF0_TYPE;
      SENSOR_ROI2_CONF0: ACQ_SENSOR_ROI2_CONF0_TYPE;
      SENSOR_ROI_CONF1: ACQ_SENSOR_ROI_CONF1_TYPE;
      SENSOR_ROI2_CONF1: ACQ_SENSOR_ROI2_CONF1_TYPE;
      SENSOR_ROI_CONF2: ACQ_SENSOR_ROI_CONF2_TYPE;
      SENSOR_ROI2_CONF2: ACQ_SENSOR_ROI2_CONF2_TYPE;
      CRC            : ACQ_CRC_TYPE;
      DEBUG_PINS     : ACQ_DEBUG_PINS_TYPE;
      TRIGGER_MISSED : ACQ_TRIGGER_MISSED_TYPE;
      SENSOR_FPS     : ACQ_SENSOR_FPS_TYPE;
      DEBUG          : ACQ_DEBUG_TYPE;
      DEBUG_CNTR1    : ACQ_DEBUG_CNTR1_TYPE;
      DEBUG_CNTR2    : ACQ_DEBUG_CNTR2_TYPE;
      DEBUG_CNTR3    : ACQ_DEBUG_CNTR3_TYPE;
      EXP_FOT        : ACQ_EXP_FOT_TYPE;
      ACQ_SFNC       : ACQ_ACQ_SFNC_TYPE;
      NOPEL          : ACQ_NOPEL_TYPE;
   end record ACQ_TYPE;

   constant INIT_ACQ_TYPE : ACQ_TYPE := (
      GRAB_CTRL       => INIT_ACQ_GRAB_CTRL_TYPE,
      GRAB_STAT       => INIT_ACQ_GRAB_STAT_TYPE,
      READOUT_CFG1    => INIT_ACQ_READOUT_CFG1_TYPE,
      READOUT_CFG2    => INIT_ACQ_READOUT_CFG2_TYPE,
      READOUT_CFG3    => INIT_ACQ_READOUT_CFG3_TYPE,
      EXP_CTRL1       => INIT_ACQ_EXP_CTRL1_TYPE,
      EXP_CTRL2       => INIT_ACQ_EXP_CTRL2_TYPE,
      EXP_CTRL3       => INIT_ACQ_EXP_CTRL3_TYPE,
      TRIGGER_DELAY   => INIT_ACQ_TRIGGER_DELAY_TYPE,
      STROBE_CTRL1    => INIT_ACQ_STROBE_CTRL1_TYPE,
      STROBE_CTRL2    => INIT_ACQ_STROBE_CTRL2_TYPE,
      ACQ_SER_CTRL    => INIT_ACQ_ACQ_SER_CTRL_TYPE,
      ACQ_SER_ADDATA  => INIT_ACQ_ACQ_SER_ADDATA_TYPE,
      ACQ_SER_STAT    => INIT_ACQ_ACQ_SER_STAT_TYPE,
      LVDS_CTRL       => INIT_ACQ_LVDS_CTRL_TYPE,
      LVDS_CTRL2      => INIT_ACQ_LVDS_CTRL2_TYPE,
      LVDS_TRAINING   => INIT_ACQ_LVDS_TRAINING_TYPE,
      LVDS_STAT       => INIT_ACQ_LVDS_STAT_TYPE,
      LVDS_STAT2      => INIT_ACQ_LVDS_STAT2_TYPE,
      SENSOR_CTRL     => INIT_ACQ_SENSOR_CTRL_TYPE,
      SENSOR_STAT     => INIT_ACQ_SENSOR_STAT_TYPE,
      SENSOR_GEN_CFG  => INIT_ACQ_SENSOR_GEN_CFG_TYPE,
      SENSOR_INT_CTL  => INIT_ACQ_SENSOR_INT_CTL_TYPE,
      SENSOR_GAIN_ANA => INIT_ACQ_SENSOR_GAIN_ANA_TYPE,
      SENSOR_BLACK_CAL => INIT_ACQ_SENSOR_BLACK_CAL_TYPE,
      SENSOR_ROI_CONF0 => INIT_ACQ_SENSOR_ROI_CONF0_TYPE,
      SENSOR_ROI2_CONF0 => INIT_ACQ_SENSOR_ROI2_CONF0_TYPE,
      SENSOR_ROI_CONF1 => INIT_ACQ_SENSOR_ROI_CONF1_TYPE,
      SENSOR_ROI2_CONF1 => INIT_ACQ_SENSOR_ROI2_CONF1_TYPE,
      SENSOR_ROI_CONF2 => INIT_ACQ_SENSOR_ROI_CONF2_TYPE,
      SENSOR_ROI2_CONF2 => INIT_ACQ_SENSOR_ROI2_CONF2_TYPE,
      CRC             => INIT_ACQ_CRC_TYPE,
      DEBUG_PINS      => INIT_ACQ_DEBUG_PINS_TYPE,
      TRIGGER_MISSED  => INIT_ACQ_TRIGGER_MISSED_TYPE,
      SENSOR_FPS      => INIT_ACQ_SENSOR_FPS_TYPE,
      DEBUG           => INIT_ACQ_DEBUG_TYPE,
      DEBUG_CNTR1     => INIT_ACQ_DEBUG_CNTR1_TYPE,
      DEBUG_CNTR2     => INIT_ACQ_DEBUG_CNTR2_TYPE,
      DEBUG_CNTR3     => INIT_ACQ_DEBUG_CNTR3_TYPE,
      EXP_FOT         => INIT_ACQ_EXP_FOT_TYPE,
      ACQ_SFNC        => INIT_ACQ_ACQ_SFNC_TYPE,
      NOPEL           => INIT_ACQ_NOPEL_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Section Name: DATA
   ------------------------------------------------------------------------------------------
   type DATA_TYPE is record
      LUT_CTRL       : DATA_LUT_CTRL_TYPE;
      LUT_RB         : DATA_LUT_RB_TYPE;
      WB_MULT1       : DATA_WB_MULT1_TYPE;
      WB_MULT2       : DATA_WB_MULT2_TYPE;
      WB_B_ACC       : DATA_WB_B_ACC_TYPE;
      WB_G_ACC       : DATA_WB_G_ACC_TYPE;
      WB_R_ACC       : DATA_WB_R_ACC_TYPE;
      FPN_ADD        : DATA_FPN_ADD_TYPE;
      FPN_READ_REG   : DATA_FPN_READ_REG_TYPE;
      FPN_DATA       : DATA_FPN_DATA_TYPE_ARRAY;
      FPN_CONTRAST   : DATA_FPN_CONTRAST_TYPE;
      FPN_ACC_ADD    : DATA_FPN_ACC_ADD_TYPE;
      FPN_ACC_DATA   : DATA_FPN_ACC_DATA_TYPE;
      DPC_LIST_CTRL  : DATA_DPC_LIST_CTRL_TYPE;
      DPC_LIST_DATA  : DATA_DPC_LIST_DATA_TYPE;
      DPC_LIST_DATA_RD: DATA_DPC_LIST_DATA_RD_TYPE;
   end record DATA_TYPE;

   constant INIT_DATA_TYPE : DATA_TYPE := (
      LUT_CTRL        => INIT_DATA_LUT_CTRL_TYPE,
      LUT_RB          => INIT_DATA_LUT_RB_TYPE,
      WB_MULT1        => INIT_DATA_WB_MULT1_TYPE,
      WB_MULT2        => INIT_DATA_WB_MULT2_TYPE,
      WB_B_ACC        => INIT_DATA_WB_B_ACC_TYPE,
      WB_G_ACC        => INIT_DATA_WB_G_ACC_TYPE,
      WB_R_ACC        => INIT_DATA_WB_R_ACC_TYPE,
      FPN_ADD         => INIT_DATA_FPN_ADD_TYPE,
      FPN_READ_REG    => INIT_DATA_FPN_READ_REG_TYPE,
      FPN_DATA        => INIT_DATA_FPN_DATA_TYPE_ARRAY,
      FPN_CONTRAST    => INIT_DATA_FPN_CONTRAST_TYPE,
      FPN_ACC_ADD     => INIT_DATA_FPN_ACC_ADD_TYPE,
      FPN_ACC_DATA    => INIT_DATA_FPN_ACC_DATA_TYPE,
      DPC_LIST_CTRL   => INIT_DATA_DPC_LIST_CTRL_TYPE,
      DPC_LIST_DATA   => INIT_DATA_DPC_LIST_DATA_TYPE,
      DPC_LIST_DATA_RD => INIT_DATA_DPC_LIST_DATA_RD_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Section Name: HISPI
   ------------------------------------------------------------------------------------------
   type HISPI_TYPE is record
      CTRL           : HISPI_CTRL_TYPE;
      STATUS         : HISPI_STATUS_TYPE;
   end record HISPI_TYPE;

   constant INIT_HISPI_TYPE : HISPI_TYPE := (
      CTRL            => INIT_HISPI_CTRL_TYPE,
      STATUS          => INIT_HISPI_STATUS_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Register file name: regfile_xgs_athena
   ------------------------------------------------------------------------------------------
   type REGFILE_XGS_ATHENA_TYPE is record
      SYSTEM         : SYSTEM_TYPE;
      DMA            : DMA_TYPE;
      ACQ            : ACQ_TYPE;
      DATA           : DATA_TYPE;
      HISPI          : HISPI_TYPE;
   end record REGFILE_XGS_ATHENA_TYPE;

   constant INIT_REGFILE_XGS_ATHENA_TYPE : REGFILE_XGS_ATHENA_TYPE := (
      SYSTEM          => INIT_SYSTEM_TYPE,
      DMA             => INIT_DMA_TYPE,
      ACQ             => INIT_ACQ_TYPE,
      DATA            => INIT_DATA_TYPE,
      HISPI           => INIT_HISPI_TYPE
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
      output(13 downto 0) := reg.VALUE;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DMA_LINE_SIZE_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DMA_LINE_SIZE_TYPE
   --------------------------------------------------------------------------------
   function to_DMA_LINE_SIZE_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_LINE_SIZE_TYPE is
   variable output : DMA_LINE_SIZE_TYPE;
   begin
      output.VALUE := stdlv(13 downto 0);
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
      output(23) := reg.DUP_LAST_LINE;
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
      output.DUP_LAST_LINE := stdlv(23);
      output.REVERSE_Y := stdlv(9);
      output.REVERSE_X := stdlv(8);
      return output;
   end to_DMA_CSC_TYPE;

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
      output(25 downto 24) := reg.SLOPE_CFG;
      output(16) := reg.TRIGGER_OVERLAP_BUFFn;
      output(15) := reg.TRIGGER_OVERLAP;
      output(14 downto 12) := reg.TRIGGER_ACT;
      output(9 downto 8) := reg.TRIGGER_SRC;
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
      output.SLOPE_CFG := stdlv(25 downto 24);
      output.TRIGGER_OVERLAP_BUFFn := stdlv(16);
      output.TRIGGER_OVERLAP := stdlv(15);
      output.TRIGGER_ACT := stdlv(14 downto 12);
      output.TRIGGER_SRC := stdlv(9 downto 8);
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
      output(25 downto 16) := reg.ROT_LENGTH;
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
      output.ROT_LENGTH := stdlv(25 downto 16);
      output.FOT_LENGTH := stdlv(15 downto 0);
      return output;
   end to_ACQ_READOUT_CFG1_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_READOUT_CFG2_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_READOUT_CFG2_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(28) := reg.READOUT_EN;
      output(23 downto 0) := reg.READOUT_LENGTH;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_READOUT_CFG2_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_READOUT_CFG2_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_READOUT_CFG2_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_READOUT_CFG2_TYPE is
   variable output : ACQ_READOUT_CFG2_TYPE;
   begin
      output.READOUT_EN := stdlv(28);
      output.READOUT_LENGTH := stdlv(23 downto 0);
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
      output(7 downto 0) := reg.BL_LINES;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_READOUT_CFG3_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_READOUT_CFG3_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_READOUT_CFG3_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_READOUT_CFG3_TYPE is
   variable output : ACQ_READOUT_CFG3_TYPE;
   begin
      output.BL_LINES := stdlv(7 downto 0);
      return output;
   end to_ACQ_READOUT_CFG3_TYPE;

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
      output(20) := reg.SER_ROI_UPDATE;
      output(19) := reg.SER_BLACKCAL_UPDATE;
      output(18) := reg.SER_GAIN_UPDATE;
      output(17) := reg.SER_SUBBIN_UPDATE;
      output(16) := reg.SER_WRn;
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
      output.SER_ROI_UPDATE := stdlv(20);
      output.SER_BLACKCAL_UPDATE := stdlv(19);
      output.SER_GAIN_UPDATE := stdlv(18);
      output.SER_SUBBIN_UPDATE := stdlv(17);
      output.SER_WRn := stdlv(16);
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
      output(8 downto 0) := reg.SER_ADD;
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
      output.SER_ADD := stdlv(8 downto 0);
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
   -- Description: Cast from ACQ_LVDS_CTRL_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_LVDS_CTRL_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 16) := reg.LVDS_BIT_RATE;
      output(12) := reg.LVDS_MODE;
      output(11 downto 8) := reg.LVDS_SER_FACTOR;
      output(7 downto 4) := reg.LVDS_CH;
      output(1) := reg.LVDS_START_CALIB;
      output(0) := reg.LVDS_SYS_RESET;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_LVDS_CTRL_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_LVDS_CTRL_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_LVDS_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_LVDS_CTRL_TYPE is
   variable output : ACQ_LVDS_CTRL_TYPE;
   begin
      output.LVDS_BIT_RATE := stdlv(31 downto 16);
      output.LVDS_MODE := stdlv(12);
      output.LVDS_SER_FACTOR := stdlv(11 downto 8);
      output.LVDS_CH := stdlv(7 downto 4);
      output.LVDS_START_CALIB := stdlv(1);
      output.LVDS_SYS_RESET := stdlv(0);
      return output;
   end to_ACQ_LVDS_CTRL_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_LVDS_CTRL2_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_LVDS_CTRL2_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(23 downto 16) := reg.REMAP_MODE_SUPP;
      output(4) := reg.LVDS_DECOD_EN;
      output(2 downto 0) := reg.LVDS_DECOD_REMAP_MODE;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_LVDS_CTRL2_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_LVDS_CTRL2_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_LVDS_CTRL2_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_LVDS_CTRL2_TYPE is
   variable output : ACQ_LVDS_CTRL2_TYPE;
   begin
      output.REMAP_MODE_SUPP := stdlv(23 downto 16);
      output.LVDS_DECOD_EN := stdlv(4);
      output.LVDS_DECOD_REMAP_MODE := stdlv(2 downto 0);
      return output;
   end to_ACQ_LVDS_CTRL2_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_LVDS_TRAINING_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_LVDS_TRAINING_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(25 downto 16) := reg.DATA_TRAINING;
      output(9 downto 0) := reg.CRTL_TRAINING;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_LVDS_TRAINING_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_LVDS_TRAINING_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_LVDS_TRAINING_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_LVDS_TRAINING_TYPE is
   variable output : ACQ_LVDS_TRAINING_TYPE;
   begin
      output.DATA_TRAINING := stdlv(25 downto 16);
      output.CRTL_TRAINING := stdlv(9 downto 0);
      return output;
   end to_ACQ_LVDS_TRAINING_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_LVDS_STAT_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_LVDS_STAT_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(29) := reg.IDELAY_RDY;
      output(28) := reg.LVDS_RDY;
      output(25) := reg.LVDS_CALIB_OK;
      output(24) := reg.LVDS_CALIB_ACT;
      output(21) := reg.BS_DONE_STAT;
      output(20 downto 12) := reg.BS_CH_LOCK_STAT;
      output(9) := reg.PD_DONE_STAT;
      output(8 downto 0) := reg.PD_CH_LOCK_STAT;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_LVDS_STAT_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_LVDS_STAT_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_LVDS_STAT_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_LVDS_STAT_TYPE is
   variable output : ACQ_LVDS_STAT_TYPE;
   begin
      output.IDELAY_RDY := stdlv(29);
      output.LVDS_RDY := stdlv(28);
      output.LVDS_CALIB_OK := stdlv(25);
      output.LVDS_CALIB_ACT := stdlv(24);
      output.BS_DONE_STAT := stdlv(21);
      output.BS_CH_LOCK_STAT := stdlv(20 downto 12);
      output.PD_DONE_STAT := stdlv(9);
      output.PD_CH_LOCK_STAT := stdlv(8 downto 0);
      return output;
   end to_ACQ_LVDS_STAT_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_LVDS_STAT2_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_LVDS_STAT2_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.WORD_ALIGN;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_LVDS_STAT2_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_LVDS_STAT2_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_LVDS_STAT2_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_LVDS_STAT2_TYPE is
   variable output : ACQ_LVDS_STAT2_TYPE;
   begin
      output.WORD_ALIGN := stdlv(31 downto 0);
      return output;
   end to_ACQ_LVDS_STAT2_TYPE;

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
      output(13 downto 12) := reg.SENSOR_REMAP_CFG;
      output(8) := reg.SENSOR_COLOR;
      output(4) := reg.SENSOR_REG_UPTATE;
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
      output.SENSOR_REMAP_CFG := stdlv(13 downto 12);
      output.SENSOR_COLOR := stdlv(8);
      output.SENSOR_REG_UPTATE := stdlv(4);
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
      output(10) := reg.SENSOR_VCCPIX_PG;
      output(9) := reg.SENSOR_VCC33_PG;
      output(8) := reg.SENSOR_VCC18_PG;
      output(6) := reg.SENSOR_VCCPIX_EN;
      output(5) := reg.SENSOR_VCC33_EN;
      output(4) := reg.SENSOR_VCC18_EN;
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
      output.SENSOR_VCCPIX_PG := stdlv(10);
      output.SENSOR_VCC33_PG := stdlv(9);
      output.SENSOR_VCC18_PG := stdlv(8);
      output.SENSOR_VCCPIX_EN := stdlv(6);
      output.SENSOR_VCC33_EN := stdlv(5);
      output.SENSOR_VCC18_EN := stdlv(4);
      output.SENSOR_POWERUP_STAT := stdlv(1);
      output.SENSOR_POWERUP_DONE := stdlv(0);
      return output;
   end to_ACQ_SENSOR_STAT_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_SENSOR_GEN_CFG_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_SENSOR_GEN_CFG_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(15 downto 9) := reg.reserved_1;
      output(8) := reg.BINNING;
      output(7) := reg.SUBSAMPLING;
      output(6) := reg.NZROT_XSM_DELAY_ENABLE;
      output(5) := reg.SLAVE_MODE;
      output(4) := reg.TRIGGERED_MODE;
      output(3) := reg.XLAG_ENABLE;
      output(2) := reg.ZERO_ROT_ENABLE;
      output(1) := reg.ROLLING_SHUTTER;
      output(0) := reg.ENABLE;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_SENSOR_GEN_CFG_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_SENSOR_GEN_CFG_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_SENSOR_GEN_CFG_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_GEN_CFG_TYPE is
   variable output : ACQ_SENSOR_GEN_CFG_TYPE;
   begin
      output.reserved_1 := stdlv(15 downto 9);
      output.BINNING := stdlv(8);
      output.SUBSAMPLING := stdlv(7);
      output.NZROT_XSM_DELAY_ENABLE := stdlv(6);
      output.SLAVE_MODE := stdlv(5);
      output.TRIGGERED_MODE := stdlv(4);
      output.XLAG_ENABLE := stdlv(3);
      output.ZERO_ROT_ENABLE := stdlv(2);
      output.ROLLING_SHUTTER := stdlv(1);
      output.ENABLE := stdlv(0);
      return output;
   end to_ACQ_SENSOR_GEN_CFG_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_SENSOR_INT_CTL_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_SENSOR_INT_CTL_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(15 downto 14) := reg.reserved_2;
      output(13 downto 12) := reg.BINNING_MODE;
      output(11 downto 10) := reg.SUBSAMPLING_MODE;
      output(9) := reg.reserved1;
      output(7 downto 0) := reg.reserved0;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_SENSOR_INT_CTL_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_SENSOR_INT_CTL_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_SENSOR_INT_CTL_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_INT_CTL_TYPE is
   variable output : ACQ_SENSOR_INT_CTL_TYPE;
   begin
      output.reserved_2 := stdlv(15 downto 14);
      output.BINNING_MODE := stdlv(13 downto 12);
      output.SUBSAMPLING_MODE := stdlv(11 downto 10);
      output.reserved1 := stdlv(9);
      output.reserved0 := stdlv(7 downto 0);
      return output;
   end to_ACQ_SENSOR_INT_CTL_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_SENSOR_GAIN_ANA_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_SENSOR_GAIN_ANA_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(15 downto 13) := reg.reserved;
      output(12 downto 5) := reg.AFE_GAIN0;
      output(4 downto 0) := reg.MUX_GAINSW0;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_SENSOR_GAIN_ANA_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_SENSOR_GAIN_ANA_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_SENSOR_GAIN_ANA_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_GAIN_ANA_TYPE is
   variable output : ACQ_SENSOR_GAIN_ANA_TYPE;
   begin
      output.reserved := stdlv(15 downto 13);
      output.AFE_GAIN0 := stdlv(12 downto 5);
      output.MUX_GAINSW0 := stdlv(4 downto 0);
      return output;
   end to_ACQ_SENSOR_GAIN_ANA_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_SENSOR_BLACK_CAL_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_SENSOR_BLACK_CAL_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(15) := reg.CRC_SEED;
      output(14 downto 11) := reg.reserved;
      output(10 downto 8) := reg.BLACK_SAMPLES;
      output(7 downto 0) := reg.BLACK_OFFSET;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_SENSOR_BLACK_CAL_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_SENSOR_BLACK_CAL_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_SENSOR_BLACK_CAL_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_BLACK_CAL_TYPE is
   variable output : ACQ_SENSOR_BLACK_CAL_TYPE;
   begin
      output.CRC_SEED := stdlv(15);
      output.reserved := stdlv(14 downto 11);
      output.BLACK_SAMPLES := stdlv(10 downto 8);
      output.BLACK_OFFSET := stdlv(7 downto 0);
      return output;
   end to_ACQ_SENSOR_BLACK_CAL_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_SENSOR_ROI_CONF0_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_SENSOR_ROI_CONF0_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(24) := reg.X_END_MSB;
      output(16) := reg.X_START_MSB;
      output(15 downto 8) := reg.X_END;
      output(7 downto 0) := reg.X_START;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_SENSOR_ROI_CONF0_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_SENSOR_ROI_CONF0_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_SENSOR_ROI_CONF0_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_ROI_CONF0_TYPE is
   variable output : ACQ_SENSOR_ROI_CONF0_TYPE;
   begin
      output.X_END_MSB := stdlv(24);
      output.X_START_MSB := stdlv(16);
      output.X_END := stdlv(15 downto 8);
      output.X_START := stdlv(7 downto 0);
      return output;
   end to_ACQ_SENSOR_ROI_CONF0_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_SENSOR_ROI2_CONF0_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_SENSOR_ROI2_CONF0_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(24) := reg.X_END_MSB;
      output(16) := reg.X_START_MSB;
      output(15 downto 8) := reg.X_END;
      output(7 downto 0) := reg.X_START;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_SENSOR_ROI2_CONF0_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_SENSOR_ROI2_CONF0_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_SENSOR_ROI2_CONF0_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_ROI2_CONF0_TYPE is
   variable output : ACQ_SENSOR_ROI2_CONF0_TYPE;
   begin
      output.X_END_MSB := stdlv(24);
      output.X_START_MSB := stdlv(16);
      output.X_END := stdlv(15 downto 8);
      output.X_START := stdlv(7 downto 0);
      return output;
   end to_ACQ_SENSOR_ROI2_CONF0_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_SENSOR_ROI_CONF1_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_SENSOR_ROI_CONF1_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(15 downto 13) := reg.reserved;
      output(12 downto 0) := reg.Y_START;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_SENSOR_ROI_CONF1_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_SENSOR_ROI_CONF1_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_SENSOR_ROI_CONF1_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_ROI_CONF1_TYPE is
   variable output : ACQ_SENSOR_ROI_CONF1_TYPE;
   begin
      output.reserved := stdlv(15 downto 13);
      output.Y_START := stdlv(12 downto 0);
      return output;
   end to_ACQ_SENSOR_ROI_CONF1_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_SENSOR_ROI2_CONF1_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_SENSOR_ROI2_CONF1_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(15 downto 13) := reg.reserved;
      output(12 downto 0) := reg.Y_START;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_SENSOR_ROI2_CONF1_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_SENSOR_ROI2_CONF1_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_SENSOR_ROI2_CONF1_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_ROI2_CONF1_TYPE is
   variable output : ACQ_SENSOR_ROI2_CONF1_TYPE;
   begin
      output.reserved := stdlv(15 downto 13);
      output.Y_START := stdlv(12 downto 0);
      return output;
   end to_ACQ_SENSOR_ROI2_CONF1_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_SENSOR_ROI_CONF2_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_SENSOR_ROI_CONF2_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(15 downto 13) := reg.reserved;
      output(12 downto 0) := reg.Y_END;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_SENSOR_ROI_CONF2_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_SENSOR_ROI_CONF2_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_SENSOR_ROI_CONF2_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_ROI_CONF2_TYPE is
   variable output : ACQ_SENSOR_ROI_CONF2_TYPE;
   begin
      output.reserved := stdlv(15 downto 13);
      output.Y_END := stdlv(12 downto 0);
      return output;
   end to_ACQ_SENSOR_ROI_CONF2_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_SENSOR_ROI2_CONF2_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_SENSOR_ROI2_CONF2_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(15 downto 13) := reg.reserved;
      output(12 downto 0) := reg.Y_END;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_SENSOR_ROI2_CONF2_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_SENSOR_ROI2_CONF2_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_SENSOR_ROI2_CONF2_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_ROI2_CONF2_TYPE is
   variable output : ACQ_SENSOR_ROI2_CONF2_TYPE;
   begin
      output.reserved := stdlv(15 downto 13);
      output.Y_END := stdlv(12 downto 0);
      return output;
   end to_ACQ_SENSOR_ROI2_CONF2_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_CRC_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_CRC_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(18) := reg.CRC_InitValue;
      output(17) := reg.CRC_Reset;
      output(16) := reg.CRC_EN;
      output(7 downto 0) := reg.CRC_STATUS;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_CRC_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_CRC_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_CRC_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_CRC_TYPE is
   variable output : ACQ_CRC_TYPE;
   begin
      output.CRC_InitValue := stdlv(18);
      output.CRC_Reset := stdlv(17);
      output.CRC_EN := stdlv(16);
      output.CRC_STATUS := stdlv(7 downto 0);
      return output;
   end to_ACQ_CRC_TYPE;

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
   -- Description: Cast from ACQ_DEBUG_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_DEBUG_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(28) := reg.DEBUG_RST_CNTR;
      output(25 downto 16) := reg.TEST_MODE_PIX_START;
      output(9) := reg.TEST_MOVE;
      output(8) := reg.TEST_MODE;
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
      output.TEST_MODE_PIX_START := stdlv(25 downto 16);
      output.TEST_MOVE := stdlv(9);
      output.TEST_MODE := stdlv(8);
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
      output(31 downto 0) := reg.EOF_CNTR;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_DEBUG_CNTR1_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_DEBUG_CNTR1_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_DEBUG_CNTR1_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_DEBUG_CNTR1_TYPE is
   variable output : ACQ_DEBUG_CNTR1_TYPE;
   begin
      output.EOF_CNTR := stdlv(31 downto 0);
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
      output(11 downto 0) := reg.EOL_CNTR;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_DEBUG_CNTR2_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_DEBUG_CNTR2_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_DEBUG_CNTR2_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_DEBUG_CNTR2_TYPE is
   variable output : ACQ_DEBUG_CNTR2_TYPE;
   begin
      output.EOL_CNTR := stdlv(11 downto 0);
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
      output(27 downto 0) := reg.SENSOR_FRAME_DURATION;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_DEBUG_CNTR3_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_DEBUG_CNTR3_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_DEBUG_CNTR3_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_DEBUG_CNTR3_TYPE is
   variable output : ACQ_DEBUG_CNTR3_TYPE;
   begin
      output.SENSOR_FRAME_DURATION := stdlv(27 downto 0);
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
      output(11 downto 0) := reg.EXP_FOT_TIME;
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
      output.EXP_FOT_TIME := stdlv(11 downto 0);
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
   -- Description: Cast from ACQ_NOPEL_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_NOPEL_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(25) := reg.NOPEL_FIFO_UNDERRUN;
      output(24) := reg.NOPEL_FIFO_OVERRUN;
      output(20) := reg.NOPEL_FIFO_RST;
      output(17) := reg.NOPEL_BYPASS;
      output(16) := reg.NOPEL_ENABLE;
      output(7 downto 0) := reg.NOPEL_THRESHOLD;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_NOPEL_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_NOPEL_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_NOPEL_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_NOPEL_TYPE is
   variable output : ACQ_NOPEL_TYPE;
   begin
      output.NOPEL_FIFO_UNDERRUN := stdlv(25);
      output.NOPEL_FIFO_OVERRUN := stdlv(24);
      output.NOPEL_FIFO_RST := stdlv(20);
      output.NOPEL_BYPASS := stdlv(17);
      output.NOPEL_ENABLE := stdlv(16);
      output.NOPEL_THRESHOLD := stdlv(7 downto 0);
      return output;
   end to_ACQ_NOPEL_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DATA_LUT_CTRL_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DATA_LUT_CTRL_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31) := reg.LUT_BYPASS;
      output(29) := reg.LUT_PALETTE_USE;
      output(28) := reg.LUT_PALETTE_W;
      output(25 downto 16) := reg.LUT_DATA_W;
      output(14 downto 12) := reg.LUT_SEL;
      output(11) := reg.LUT_WRN;
      output(10) := reg.LUT_SS;
      output(9 downto 0) := reg.LUT_ADD;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DATA_LUT_CTRL_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DATA_LUT_CTRL_TYPE
   --------------------------------------------------------------------------------
   function to_DATA_LUT_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return DATA_LUT_CTRL_TYPE is
   variable output : DATA_LUT_CTRL_TYPE;
   begin
      output.LUT_BYPASS := stdlv(31);
      output.LUT_PALETTE_USE := stdlv(29);
      output.LUT_PALETTE_W := stdlv(28);
      output.LUT_DATA_W := stdlv(25 downto 16);
      output.LUT_SEL := stdlv(14 downto 12);
      output.LUT_WRN := stdlv(11);
      output.LUT_SS := stdlv(10);
      output.LUT_ADD := stdlv(9 downto 0);
      return output;
   end to_DATA_LUT_CTRL_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DATA_LUT_RB_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DATA_LUT_RB_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(9 downto 0) := reg.LUT_RB;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DATA_LUT_RB_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DATA_LUT_RB_TYPE
   --------------------------------------------------------------------------------
   function to_DATA_LUT_RB_TYPE(stdlv : std_logic_vector(31 downto 0)) return DATA_LUT_RB_TYPE is
   variable output : DATA_LUT_RB_TYPE;
   begin
      output.LUT_RB := stdlv(9 downto 0);
      return output;
   end to_DATA_LUT_RB_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DATA_WB_MULT1_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DATA_WB_MULT1_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 16) := reg.WB_MULT_G;
      output(15 downto 0) := reg.WB_MULT_B;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DATA_WB_MULT1_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DATA_WB_MULT1_TYPE
   --------------------------------------------------------------------------------
   function to_DATA_WB_MULT1_TYPE(stdlv : std_logic_vector(31 downto 0)) return DATA_WB_MULT1_TYPE is
   variable output : DATA_WB_MULT1_TYPE;
   begin
      output.WB_MULT_G := stdlv(31 downto 16);
      output.WB_MULT_B := stdlv(15 downto 0);
      return output;
   end to_DATA_WB_MULT1_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DATA_WB_MULT2_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DATA_WB_MULT2_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(15 downto 0) := reg.WB_MULT_R;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DATA_WB_MULT2_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DATA_WB_MULT2_TYPE
   --------------------------------------------------------------------------------
   function to_DATA_WB_MULT2_TYPE(stdlv : std_logic_vector(31 downto 0)) return DATA_WB_MULT2_TYPE is
   variable output : DATA_WB_MULT2_TYPE;
   begin
      output.WB_MULT_R := stdlv(15 downto 0);
      return output;
   end to_DATA_WB_MULT2_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DATA_WB_B_ACC_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DATA_WB_B_ACC_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(30 downto 0) := reg.B_ACC;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DATA_WB_B_ACC_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DATA_WB_B_ACC_TYPE
   --------------------------------------------------------------------------------
   function to_DATA_WB_B_ACC_TYPE(stdlv : std_logic_vector(31 downto 0)) return DATA_WB_B_ACC_TYPE is
   variable output : DATA_WB_B_ACC_TYPE;
   begin
      output.B_ACC := stdlv(30 downto 0);
      return output;
   end to_DATA_WB_B_ACC_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DATA_WB_G_ACC_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DATA_WB_G_ACC_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.G_ACC;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DATA_WB_G_ACC_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DATA_WB_G_ACC_TYPE
   --------------------------------------------------------------------------------
   function to_DATA_WB_G_ACC_TYPE(stdlv : std_logic_vector(31 downto 0)) return DATA_WB_G_ACC_TYPE is
   variable output : DATA_WB_G_ACC_TYPE;
   begin
      output.G_ACC := stdlv(31 downto 0);
      return output;
   end to_DATA_WB_G_ACC_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DATA_WB_R_ACC_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DATA_WB_R_ACC_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(30 downto 0) := reg.R_ACC;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DATA_WB_R_ACC_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DATA_WB_R_ACC_TYPE
   --------------------------------------------------------------------------------
   function to_DATA_WB_R_ACC_TYPE(stdlv : std_logic_vector(31 downto 0)) return DATA_WB_R_ACC_TYPE is
   variable output : DATA_WB_R_ACC_TYPE;
   begin
      output.R_ACC := stdlv(30 downto 0);
      return output;
   end to_DATA_WB_R_ACC_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DATA_FPN_ADD_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DATA_FPN_ADD_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31) := reg.FPN_73;
      output(28) := reg.FPN_WE;
      output(24) := reg.FPN_EN;
      output(16) := reg.FPN_SS;
      output(9 downto 0) := reg.FPN_ADD;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DATA_FPN_ADD_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DATA_FPN_ADD_TYPE
   --------------------------------------------------------------------------------
   function to_DATA_FPN_ADD_TYPE(stdlv : std_logic_vector(31 downto 0)) return DATA_FPN_ADD_TYPE is
   variable output : DATA_FPN_ADD_TYPE;
   begin
      output.FPN_73 := stdlv(31);
      output.FPN_WE := stdlv(28);
      output.FPN_EN := stdlv(24);
      output.FPN_SS := stdlv(16);
      output.FPN_ADD := stdlv(9 downto 0);
      return output;
   end to_DATA_FPN_ADD_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DATA_FPN_READ_REG_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DATA_FPN_READ_REG_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(30 downto 28) := reg.FPN_READ_PIX_SEL;
      output(24 downto 16) := reg.FPN_READ_PRNU;
      output(10 downto 0) := reg.FPN_READ_FPN;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DATA_FPN_READ_REG_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DATA_FPN_READ_REG_TYPE
   --------------------------------------------------------------------------------
   function to_DATA_FPN_READ_REG_TYPE(stdlv : std_logic_vector(31 downto 0)) return DATA_FPN_READ_REG_TYPE is
   variable output : DATA_FPN_READ_REG_TYPE;
   begin
      output.FPN_READ_PIX_SEL := stdlv(30 downto 28);
      output.FPN_READ_PRNU := stdlv(24 downto 16);
      output.FPN_READ_FPN := stdlv(10 downto 0);
      return output;
   end to_DATA_FPN_READ_REG_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DATA_FPN_DATA_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DATA_FPN_DATA_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(24 downto 16) := reg.FPN_DATA_PRNU;
      output(10 downto 0) := reg.FPN_DATA_FPN;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DATA_FPN_DATA_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DATA_FPN_DATA_TYPE
   --------------------------------------------------------------------------------
   function to_DATA_FPN_DATA_TYPE(stdlv : std_logic_vector(31 downto 0)) return DATA_FPN_DATA_TYPE is
   variable output : DATA_FPN_DATA_TYPE;
   begin
      output.FPN_DATA_PRNU := stdlv(24 downto 16);
      output.FPN_DATA_FPN := stdlv(10 downto 0);
      return output;
   end to_DATA_FPN_DATA_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DATA_FPN_CONTRAST_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DATA_FPN_CONTRAST_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(27 downto 16) := reg.CONTRAST_GAIN;
      output(7 downto 0) := reg.CONTRAST_OFFSET;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DATA_FPN_CONTRAST_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DATA_FPN_CONTRAST_TYPE
   --------------------------------------------------------------------------------
   function to_DATA_FPN_CONTRAST_TYPE(stdlv : std_logic_vector(31 downto 0)) return DATA_FPN_CONTRAST_TYPE is
   variable output : DATA_FPN_CONTRAST_TYPE;
   begin
      output.CONTRAST_GAIN := stdlv(27 downto 16);
      output.CONTRAST_OFFSET := stdlv(7 downto 0);
      return output;
   end to_DATA_FPN_CONTRAST_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DATA_FPN_ACC_ADD_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DATA_FPN_ACC_ADD_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(21) := reg.FPN_ACC_MODE_SEL;
      output(20) := reg.FPN_ACC_MODE_EN;
      output(16) := reg.FPN_ACC_R_SS;
      output(11 downto 0) := reg.FPN_ACC_ADD;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DATA_FPN_ACC_ADD_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DATA_FPN_ACC_ADD_TYPE
   --------------------------------------------------------------------------------
   function to_DATA_FPN_ACC_ADD_TYPE(stdlv : std_logic_vector(31 downto 0)) return DATA_FPN_ACC_ADD_TYPE is
   variable output : DATA_FPN_ACC_ADD_TYPE;
   begin
      output.FPN_ACC_MODE_SEL := stdlv(21);
      output.FPN_ACC_MODE_EN := stdlv(20);
      output.FPN_ACC_R_SS := stdlv(16);
      output.FPN_ACC_ADD := stdlv(11 downto 0);
      return output;
   end to_DATA_FPN_ACC_ADD_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DATA_FPN_ACC_DATA_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DATA_FPN_ACC_DATA_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(24) := reg.FPN_ACC_R_WORKING;
      output(23 downto 0) := reg.FPN_ACC_DATA;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DATA_FPN_ACC_DATA_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DATA_FPN_ACC_DATA_TYPE
   --------------------------------------------------------------------------------
   function to_DATA_FPN_ACC_DATA_TYPE(stdlv : std_logic_vector(31 downto 0)) return DATA_FPN_ACC_DATA_TYPE is
   variable output : DATA_FPN_ACC_DATA_TYPE;
   begin
      output.FPN_ACC_R_WORKING := stdlv(24);
      output.FPN_ACC_DATA := stdlv(23 downto 0);
      return output;
   end to_DATA_FPN_ACC_DATA_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DATA_DPC_LIST_CTRL_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DATA_DPC_LIST_CTRL_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31) := reg.dpc_fifo_underrun;
      output(30) := reg.dpc_fifo_overrun;
      output(28) := reg.dpc_fifo_reset;
      output(26) := reg.dpc_firstlast_line_rem;
      output(25) := reg.dpc_pattern0_cfg;
      output(24) := reg.dpc_enable;
      output(21 downto 16) := reg.dpc_list_count;
      output(12) := reg.dpc_list_WRn;
      output(8) := reg.dpc_list_ss;
      output(5 downto 0) := reg.dpc_list_add;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DATA_DPC_LIST_CTRL_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DATA_DPC_LIST_CTRL_TYPE
   --------------------------------------------------------------------------------
   function to_DATA_DPC_LIST_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return DATA_DPC_LIST_CTRL_TYPE is
   variable output : DATA_DPC_LIST_CTRL_TYPE;
   begin
      output.dpc_fifo_underrun := stdlv(31);
      output.dpc_fifo_overrun := stdlv(30);
      output.dpc_fifo_reset := stdlv(28);
      output.dpc_firstlast_line_rem := stdlv(26);
      output.dpc_pattern0_cfg := stdlv(25);
      output.dpc_enable := stdlv(24);
      output.dpc_list_count := stdlv(21 downto 16);
      output.dpc_list_WRn := stdlv(12);
      output.dpc_list_ss := stdlv(8);
      output.dpc_list_add := stdlv(5 downto 0);
      return output;
   end to_DATA_DPC_LIST_CTRL_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DATA_DPC_LIST_DATA_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DATA_DPC_LIST_DATA_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 24) := reg.dpc_list_corr_pattern;
      output(23 downto 12) := reg.dpc_list_corr_y;
      output(11 downto 0) := reg.dpc_list_corr_x;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DATA_DPC_LIST_DATA_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DATA_DPC_LIST_DATA_TYPE
   --------------------------------------------------------------------------------
   function to_DATA_DPC_LIST_DATA_TYPE(stdlv : std_logic_vector(31 downto 0)) return DATA_DPC_LIST_DATA_TYPE is
   variable output : DATA_DPC_LIST_DATA_TYPE;
   begin
      output.dpc_list_corr_pattern := stdlv(31 downto 24);
      output.dpc_list_corr_y := stdlv(23 downto 12);
      output.dpc_list_corr_x := stdlv(11 downto 0);
      return output;
   end to_DATA_DPC_LIST_DATA_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DATA_DPC_LIST_DATA_RD_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DATA_DPC_LIST_DATA_RD_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 24) := reg.dpc_list_corr_pattern;
      output(23 downto 12) := reg.dpc_list_corr_y;
      output(11 downto 0) := reg.dpc_list_corr_x;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DATA_DPC_LIST_DATA_RD_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DATA_DPC_LIST_DATA_RD_TYPE
   --------------------------------------------------------------------------------
   function to_DATA_DPC_LIST_DATA_RD_TYPE(stdlv : std_logic_vector(31 downto 0)) return DATA_DPC_LIST_DATA_RD_TYPE is
   variable output : DATA_DPC_LIST_DATA_RD_TYPE;
   begin
      output.dpc_list_corr_pattern := stdlv(31 downto 24);
      output.dpc_list_corr_y := stdlv(23 downto 12);
      output.dpc_list_corr_x := stdlv(11 downto 0);
      return output;
   end to_DATA_DPC_LIST_DATA_RD_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from HISPI_CTRL_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : HISPI_CTRL_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(1) := reg.CLR;
      output(0) := reg.RESET_IDELAYCTRL;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_HISPI_CTRL_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to HISPI_CTRL_TYPE
   --------------------------------------------------------------------------------
   function to_HISPI_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return HISPI_CTRL_TYPE is
   variable output : HISPI_CTRL_TYPE;
   begin
      output.CLR := stdlv(1);
      output.RESET_IDELAYCTRL := stdlv(0);
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
      output(0) := reg.PLL_LOCKED;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_HISPI_STATUS_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to HISPI_STATUS_TYPE
   --------------------------------------------------------------------------------
   function to_HISPI_STATUS_TYPE(stdlv : std_logic_vector(31 downto 0)) return HISPI_STATUS_TYPE is
   variable output : HISPI_STATUS_TYPE;
   begin
      output.PLL_LOCKED := stdlv(0);
      return output;
   end to_HISPI_STATUS_TYPE;

   
end package body;


-------------------------------------------------------------------------------
-- File                : regfile_xgs_athena.vhd
-- Project             : FDK
-- Module              : regfile_xgs_athena
-- Created on          : 2020/04/29 11:37:34
-- Created by          : imaval
-- FDK IDE Version     : 4.7.0_beta4
-- Build ID            : I20191220-1537
-- Register file CRC32 : 0x6C02943B
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
      resetN        : in    std_logic;                                               -- System reset
      sysclk        : in    std_logic;                                               -- System clock
      regfile       : inout REGFILE_XGS_ATHENA_TYPE := INIT_REGFILE_XGS_ATHENA_TYPE; -- Register file
      ------------------------------------------------------------------------------------
      -- Interface name: registerFileIF
      -- Description: 
      ------------------------------------------------------------------------------------
      reg_read      : in    std_logic;                                               -- Read
      reg_write     : in    std_logic;                                               -- Write
      reg_addr      : in    std_logic_vector(10 downto 2);                           -- Address
      reg_beN       : in    std_logic_vector(3 downto 0);                            -- Byte enable
      reg_writedata : in    std_logic_vector(31 downto 0);                           -- Write data
      reg_readdata  : out   std_logic_vector(31 downto 0)                            -- Read data
   );
   
end regfile_xgs_athena;

architecture rtl of regfile_xgs_athena is
------------------------------------------------------------------------------------------
-- Signals declaration
------------------------------------------------------------------------------------------
signal readBackMux                                          : std_logic_vector(31 downto 0);                   -- Data readback multiplexer
signal hit                                                  : std_logic_vector(80 downto 0);                   -- Address decode hit
signal wEn                                                  : std_logic_vector(80 downto 0);                   -- Write Enable
signal fullAddr                                             : std_logic_vector(11 downto 0):= (others => '0'); -- Full Address
signal fullAddrAsInt                                        : integer;                                        
signal bitEnN                                               : std_logic_vector(31 downto 0);                   -- Bits enable
signal ldData                                               : std_logic;                                      
signal rb_SYSTEM_TAG                                        : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_SYSTEM_VERSION                                    : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_SYSTEM_CAPABILITY                                 : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_SYSTEM_SCRATCHPAD                                 : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DMA_CTRL                                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DMA_FSTART                                        : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DMA_FSTART_HIGH                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DMA_FSTART_G                                      : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DMA_FSTART_G_HIGH                                 : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DMA_FSTART_R                                      : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DMA_FSTART_R_HIGH                                 : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DMA_LINE_PITCH                                    : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DMA_LINE_SIZE                                     : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DMA_CSC                                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_GRAB_CTRL                                     : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_GRAB_STAT                                     : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_READOUT_CFG1                                  : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_READOUT_CFG2                                  : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_READOUT_CFG3                                  : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_EXP_CTRL1                                     : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_EXP_CTRL2                                     : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_EXP_CTRL3                                     : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_TRIGGER_DELAY                                 : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_STROBE_CTRL1                                  : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_STROBE_CTRL2                                  : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_ACQ_SER_CTRL                                  : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_ACQ_SER_ADDATA                                : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_ACQ_SER_STAT                                  : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_LVDS_CTRL                                     : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_LVDS_CTRL2                                    : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_LVDS_TRAINING                                 : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_LVDS_STAT                                     : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_LVDS_STAT2                                    : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_CTRL                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_STAT                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_GEN_CFG                                : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_INT_CTL                                : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_GAIN_ANA                               : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_BLACK_CAL                              : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_ROI_CONF0                              : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_ROI2_CONF0                             : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_ROI_CONF1                              : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_ROI2_CONF1                             : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_ROI_CONF2                              : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_ROI2_CONF2                             : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_CRC                                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_DEBUG_PINS                                    : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_TRIGGER_MISSED                                : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_FPS                                    : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_DEBUG                                         : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_DEBUG_CNTR1                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_DEBUG_CNTR2                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_DEBUG_CNTR3                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_EXP_FOT                                       : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_ACQ_SFNC                                      : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_NOPEL                                         : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DATA_LUT_CTRL                                     : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DATA_LUT_RB                                       : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DATA_WB_MULT1                                     : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DATA_WB_MULT2                                     : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DATA_WB_B_ACC                                     : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DATA_WB_G_ACC                                     : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DATA_WB_R_ACC                                     : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DATA_FPN_ADD                                      : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DATA_FPN_READ_REG                                 : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DATA_FPN_DATA_0                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DATA_FPN_DATA_1                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DATA_FPN_DATA_2                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DATA_FPN_DATA_3                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DATA_FPN_DATA_4                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DATA_FPN_DATA_5                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DATA_FPN_DATA_6                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DATA_FPN_DATA_7                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DATA_FPN_CONTRAST                                 : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DATA_FPN_ACC_ADD                                  : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DATA_FPN_ACC_DATA                                 : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DATA_DPC_LIST_CTRL                                : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DATA_DPC_LIST_DATA                                : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_DATA_DPC_LIST_DATA_RD                             : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_HISPI_CTRL                                        : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_HISPI_STATUS                                      : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal field_rw_SYSTEM_SCRATCHPAD_VALUE                     : std_logic_vector(31 downto 0);                   -- Field: VALUE
signal field_rw_DMA_CTRL_GRAB_QUEUE_EN                      : std_logic;                                       -- Field: GRAB_QUEUE_EN
signal field_rw_DMA_FSTART_VALUE                            : std_logic_vector(31 downto 0);                   -- Field: VALUE
signal field_rw_DMA_FSTART_HIGH_VALUE                       : std_logic_vector(31 downto 0);                   -- Field: VALUE
signal field_rw_DMA_FSTART_G_VALUE                          : std_logic_vector(31 downto 0);                   -- Field: VALUE
signal field_rw_DMA_FSTART_G_HIGH_VALUE                     : std_logic_vector(31 downto 0);                   -- Field: VALUE
signal field_rw_DMA_FSTART_R_VALUE                          : std_logic_vector(31 downto 0);                   -- Field: VALUE
signal field_rw_DMA_FSTART_R_HIGH_VALUE                     : std_logic_vector(31 downto 0);                   -- Field: VALUE
signal field_rw_DMA_LINE_PITCH_VALUE                        : std_logic_vector(15 downto 0);                   -- Field: VALUE
signal field_rw_DMA_LINE_SIZE_VALUE                         : std_logic_vector(13 downto 0);                   -- Field: VALUE
signal field_rw_DMA_CSC_COLOR_SPACE                         : std_logic_vector(2 downto 0);                    -- Field: COLOR_SPACE
signal field_rw_DMA_CSC_DUP_LAST_LINE                       : std_logic;                                       -- Field: DUP_LAST_LINE
signal field_rw_DMA_CSC_REVERSE_Y                           : std_logic;                                       -- Field: REVERSE_Y
signal field_rw_DMA_CSC_REVERSE_X                           : std_logic;                                       -- Field: REVERSE_X
signal field_rw_ACQ_GRAB_CTRL_RESET_GRAB                    : std_logic;                                       -- Field: RESET_GRAB
signal field_rw_ACQ_GRAB_CTRL_GRAB_ROI2_EN                  : std_logic;                                       -- Field: GRAB_ROI2_EN
signal field_wautoclr_ACQ_GRAB_CTRL_ABORT_GRAB              : std_logic;                                       -- Field: ABORT_GRAB
signal field_rw_ACQ_GRAB_CTRL_SLOPE_CFG                     : std_logic_vector(1 downto 0);                    -- Field: SLOPE_CFG
signal field_rw_ACQ_GRAB_CTRL_TRIGGER_OVERLAP_BUFFn         : std_logic;                                       -- Field: TRIGGER_OVERLAP_BUFFn
signal field_rw_ACQ_GRAB_CTRL_TRIGGER_OVERLAP               : std_logic;                                       -- Field: TRIGGER_OVERLAP
signal field_rw_ACQ_GRAB_CTRL_TRIGGER_ACT                   : std_logic_vector(2 downto 0);                    -- Field: TRIGGER_ACT
signal field_rw_ACQ_GRAB_CTRL_TRIGGER_SRC                   : std_logic_vector(1 downto 0);                    -- Field: TRIGGER_SRC
signal field_wautoclr_ACQ_GRAB_CTRL_GRAB_SS                 : std_logic;                                       -- Field: GRAB_SS
signal field_rw_ACQ_GRAB_CTRL_BUFFER_ID                     : std_logic;                                       -- Field: BUFFER_ID
signal field_wautoclr_ACQ_GRAB_CTRL_GRAB_CMD                : std_logic;                                       -- Field: GRAB_CMD
signal field_rw_ACQ_READOUT_CFG2_READOUT_EN                 : std_logic;                                       -- Field: READOUT_EN
signal field_rw_ACQ_READOUT_CFG2_READOUT_LENGTH             : std_logic_vector(23 downto 0);                   -- Field: READOUT_LENGTH
signal field_rw_ACQ_EXP_CTRL1_EXPOSURE_LEV_MODE             : std_logic;                                       -- Field: EXPOSURE_LEV_MODE
signal field_rw_ACQ_EXP_CTRL1_EXPOSURE_SS                   : std_logic_vector(27 downto 0);                   -- Field: EXPOSURE_SS
signal field_rw_ACQ_EXP_CTRL2_EXPOSURE_DS                   : std_logic_vector(27 downto 0);                   -- Field: EXPOSURE_DS
signal field_rw_ACQ_EXP_CTRL3_EXPOSURE_TS                   : std_logic_vector(27 downto 0);                   -- Field: EXPOSURE_TS
signal field_rw_ACQ_TRIGGER_DELAY_TRIGGER_DELAY             : std_logic_vector(27 downto 0);                   -- Field: TRIGGER_DELAY
signal field_rw_ACQ_STROBE_CTRL1_STROBE_E                   : std_logic;                                       -- Field: STROBE_E
signal field_rw_ACQ_STROBE_CTRL1_STROBE_POL                 : std_logic;                                       -- Field: STROBE_POL
signal field_rw_ACQ_STROBE_CTRL1_STROBE_START               : std_logic_vector(27 downto 0);                   -- Field: STROBE_START
signal field_rw_ACQ_STROBE_CTRL2_STROBE_MODE                : std_logic;                                       -- Field: STROBE_MODE
signal field_rw_ACQ_STROBE_CTRL2_STROBE_END                 : std_logic_vector(27 downto 0);                   -- Field: STROBE_END
signal field_rw_ACQ_ACQ_SER_CTRL_SER_ROI_UPDATE             : std_logic;                                       -- Field: SER_ROI_UPDATE
signal field_rw_ACQ_ACQ_SER_CTRL_SER_BLACKCAL_UPDATE        : std_logic;                                       -- Field: SER_BLACKCAL_UPDATE
signal field_rw_ACQ_ACQ_SER_CTRL_SER_GAIN_UPDATE            : std_logic;                                       -- Field: SER_GAIN_UPDATE
signal field_rw_ACQ_ACQ_SER_CTRL_SER_SUBBIN_UPDATE          : std_logic;                                       -- Field: SER_SUBBIN_UPDATE
signal field_rw_ACQ_ACQ_SER_CTRL_SER_WRn                    : std_logic;                                       -- Field: SER_WRn
signal field_rw_ACQ_ACQ_SER_CTRL_SER_CMD                    : std_logic_vector(1 downto 0);                    -- Field: SER_CMD
signal field_wautoclr_ACQ_ACQ_SER_CTRL_SER_RF_SS            : std_logic;                                       -- Field: SER_RF_SS
signal field_wautoclr_ACQ_ACQ_SER_CTRL_SER_WF_SS            : std_logic;                                       -- Field: SER_WF_SS
signal field_rw_ACQ_ACQ_SER_ADDATA_SER_DAT                  : std_logic_vector(15 downto 0);                   -- Field: SER_DAT
signal field_rw_ACQ_ACQ_SER_ADDATA_SER_ADD                  : std_logic_vector(8 downto 0);                    -- Field: SER_ADD
signal field_rw_ACQ_LVDS_CTRL_LVDS_BIT_RATE                 : std_logic_vector(15 downto 0);                   -- Field: LVDS_BIT_RATE
signal field_rw_ACQ_LVDS_CTRL_LVDS_SER_FACTOR               : std_logic_vector(3 downto 0);                    -- Field: LVDS_SER_FACTOR
signal field_rw_ACQ_LVDS_CTRL_LVDS_CH                       : std_logic_vector(3 downto 0);                    -- Field: LVDS_CH
signal field_wautoclr_ACQ_LVDS_CTRL_LVDS_START_CALIB        : std_logic;                                       -- Field: LVDS_START_CALIB
signal field_rw_ACQ_LVDS_CTRL_LVDS_SYS_RESET                : std_logic;                                       -- Field: LVDS_SYS_RESET
signal field_rw_ACQ_LVDS_CTRL2_LVDS_DECOD_EN                : std_logic;                                       -- Field: LVDS_DECOD_EN
signal field_rw_ACQ_LVDS_CTRL2_LVDS_DECOD_REMAP_MODE        : std_logic_vector(2 downto 0);                    -- Field: LVDS_DECOD_REMAP_MODE
signal field_rw_ACQ_LVDS_TRAINING_DATA_TRAINING             : std_logic_vector(9 downto 0);                    -- Field: DATA_TRAINING
signal field_rw_ACQ_LVDS_TRAINING_CRTL_TRAINING             : std_logic_vector(9 downto 0);                    -- Field: CRTL_TRAINING
signal field_wautoclr_ACQ_SENSOR_CTRL_SENSOR_REFRESH_TEMP   : std_logic;                                       -- Field: SENSOR_REFRESH_TEMP
signal field_wautoclr_ACQ_SENSOR_CTRL_SENSOR_POWERDOWN      : std_logic;                                       -- Field: SENSOR_POWERDOWN
signal field_rw_ACQ_SENSOR_CTRL_SENSOR_REMAP_CFG            : std_logic_vector(1 downto 0);                    -- Field: SENSOR_REMAP_CFG
signal field_rw_ACQ_SENSOR_CTRL_SENSOR_COLOR                : std_logic;                                       -- Field: SENSOR_COLOR
signal field_rw_ACQ_SENSOR_CTRL_SENSOR_REG_UPTATE           : std_logic;                                       -- Field: SENSOR_REG_UPTATE
signal field_rw_ACQ_SENSOR_CTRL_SENSOR_RESETN               : std_logic;                                       -- Field: SENSOR_RESETN
signal field_wautoclr_ACQ_SENSOR_CTRL_SENSOR_POWERUP        : std_logic;                                       -- Field: SENSOR_POWERUP
signal field_rw_ACQ_SENSOR_GEN_CFG_reserved_1               : std_logic_vector(6 downto 0);                    -- Field: reserved_1
signal field_rw_ACQ_SENSOR_GEN_CFG_BINNING                  : std_logic;                                       -- Field: BINNING
signal field_rw_ACQ_SENSOR_GEN_CFG_SUBSAMPLING              : std_logic;                                       -- Field: SUBSAMPLING
signal field_rw_ACQ_SENSOR_GEN_CFG_NZROT_XSM_DELAY_ENABLE   : std_logic;                                       -- Field: NZROT_XSM_DELAY_ENABLE
signal field_rw_ACQ_SENSOR_GEN_CFG_SLAVE_MODE               : std_logic;                                       -- Field: SLAVE_MODE
signal field_rw_ACQ_SENSOR_GEN_CFG_TRIGGERED_MODE           : std_logic;                                       -- Field: TRIGGERED_MODE
signal field_rw_ACQ_SENSOR_GEN_CFG_XLAG_ENABLE              : std_logic;                                       -- Field: XLAG_ENABLE
signal field_rw_ACQ_SENSOR_GEN_CFG_ZERO_ROT_ENABLE          : std_logic;                                       -- Field: ZERO_ROT_ENABLE
signal field_rw_ACQ_SENSOR_GEN_CFG_ROLLING_SHUTTER          : std_logic;                                       -- Field: ROLLING_SHUTTER
signal field_rw_ACQ_SENSOR_GEN_CFG_ENABLE                   : std_logic;                                       -- Field: ENABLE
signal field_rw_ACQ_SENSOR_INT_CTL_reserved_2               : std_logic_vector(1 downto 0);                    -- Field: reserved_2
signal field_rw_ACQ_SENSOR_INT_CTL_BINNING_MODE             : std_logic_vector(1 downto 0);                    -- Field: BINNING_MODE
signal field_rw_ACQ_SENSOR_INT_CTL_SUBSAMPLING_MODE         : std_logic_vector(1 downto 0);                    -- Field: SUBSAMPLING_MODE
signal field_rw_ACQ_SENSOR_INT_CTL_reserved1                : std_logic;                                       -- Field: reserved1
signal field_rw_ACQ_SENSOR_INT_CTL_reserved0                : std_logic_vector(7 downto 0);                    -- Field: reserved0
signal field_rw_ACQ_SENSOR_GAIN_ANA_reserved                : std_logic_vector(2 downto 0);                    -- Field: reserved
signal field_rw_ACQ_SENSOR_GAIN_ANA_AFE_GAIN0               : std_logic_vector(7 downto 0);                    -- Field: AFE_GAIN0
signal field_rw_ACQ_SENSOR_GAIN_ANA_MUX_GAINSW0             : std_logic_vector(4 downto 0);                    -- Field: MUX_GAINSW0
signal field_rw_ACQ_SENSOR_BLACK_CAL_CRC_SEED               : std_logic;                                       -- Field: CRC_SEED
signal field_rw_ACQ_SENSOR_BLACK_CAL_reserved               : std_logic_vector(3 downto 0);                    -- Field: reserved
signal field_rw_ACQ_SENSOR_BLACK_CAL_BLACK_OFFSET           : std_logic_vector(7 downto 0);                    -- Field: BLACK_OFFSET
signal field_rw_ACQ_SENSOR_ROI_CONF0_X_END_MSB              : std_logic;                                       -- Field: X_END_MSB
signal field_rw_ACQ_SENSOR_ROI_CONF0_X_START_MSB            : std_logic;                                       -- Field: X_START_MSB
signal field_rw_ACQ_SENSOR_ROI_CONF0_X_END                  : std_logic_vector(7 downto 0);                    -- Field: X_END
signal field_rw_ACQ_SENSOR_ROI_CONF0_X_START                : std_logic_vector(7 downto 0);                    -- Field: X_START
signal field_rw_ACQ_SENSOR_ROI2_CONF0_X_END_MSB             : std_logic;                                       -- Field: X_END_MSB
signal field_rw_ACQ_SENSOR_ROI2_CONF0_X_START_MSB           : std_logic;                                       -- Field: X_START_MSB
signal field_rw_ACQ_SENSOR_ROI2_CONF0_X_END                 : std_logic_vector(7 downto 0);                    -- Field: X_END
signal field_rw_ACQ_SENSOR_ROI2_CONF0_X_START               : std_logic_vector(7 downto 0);                    -- Field: X_START
signal field_rw_ACQ_SENSOR_ROI_CONF1_Y_START                : std_logic_vector(12 downto 0);                   -- Field: Y_START
signal field_rw_ACQ_SENSOR_ROI2_CONF1_Y_START               : std_logic_vector(12 downto 0);                   -- Field: Y_START
signal field_rw_ACQ_SENSOR_ROI_CONF2_Y_END                  : std_logic_vector(12 downto 0);                   -- Field: Y_END
signal field_rw_ACQ_SENSOR_ROI2_CONF2_Y_END                 : std_logic_vector(12 downto 0);                   -- Field: Y_END
signal field_rw_ACQ_CRC_CRC_InitValue                       : std_logic;                                       -- Field: CRC_InitValue
signal field_wautoclr_ACQ_CRC_CRC_Reset                     : std_logic;                                       -- Field: CRC_Reset
signal field_rw_ACQ_CRC_CRC_EN                              : std_logic;                                       -- Field: CRC_EN
signal field_rw_ACQ_DEBUG_PINS_Debug3_sel                   : std_logic_vector(4 downto 0);                    -- Field: Debug3_sel
signal field_rw_ACQ_DEBUG_PINS_Debug2_sel                   : std_logic_vector(4 downto 0);                    -- Field: Debug2_sel
signal field_rw_ACQ_DEBUG_PINS_Debug1_sel                   : std_logic_vector(4 downto 0);                    -- Field: Debug1_sel
signal field_rw_ACQ_DEBUG_PINS_Debug0_sel                   : std_logic_vector(4 downto 0);                    -- Field: Debug0_sel
signal field_wautoclr_ACQ_TRIGGER_MISSED_TRIGGER_MISSED_RST : std_logic;                                       -- Field: TRIGGER_MISSED_RST
signal field_rw_ACQ_DEBUG_DEBUG_RST_CNTR                    : std_logic;                                       -- Field: DEBUG_RST_CNTR
signal field_rw_ACQ_DEBUG_TEST_MODE_PIX_START               : std_logic_vector(9 downto 0);                    -- Field: TEST_MODE_PIX_START
signal field_rw_ACQ_DEBUG_TEST_MOVE                         : std_logic;                                       -- Field: TEST_MOVE
signal field_rw_ACQ_DEBUG_TEST_MODE                         : std_logic;                                       -- Field: TEST_MODE
signal field_rw_ACQ_DEBUG_LED_TEST_COLOR                    : std_logic_vector(1 downto 0);                    -- Field: LED_TEST_COLOR
signal field_rw_ACQ_DEBUG_LED_TEST                          : std_logic;                                       -- Field: LED_TEST
signal field_rw_ACQ_EXP_FOT_EXP_FOT                         : std_logic;                                       -- Field: EXP_FOT
signal field_rw_ACQ_EXP_FOT_EXP_FOT_TIME                    : std_logic_vector(11 downto 0);                   -- Field: EXP_FOT_TIME
signal field_wautoclr_ACQ_ACQ_SFNC_RELOAD_GRAB_PARAMS       : std_logic;                                       -- Field: RELOAD_GRAB_PARAMS
signal field_rw_ACQ_NOPEL_NOPEL_FIFO_RST                    : std_logic;                                       -- Field: NOPEL_FIFO_RST
signal field_rw_ACQ_NOPEL_NOPEL_BYPASS                      : std_logic;                                       -- Field: NOPEL_BYPASS
signal field_rw_ACQ_NOPEL_NOPEL_ENABLE                      : std_logic;                                       -- Field: NOPEL_ENABLE
signal field_rw_ACQ_NOPEL_NOPEL_THRESHOLD                   : std_logic_vector(7 downto 0);                    -- Field: NOPEL_THRESHOLD
signal field_rw_DATA_LUT_CTRL_LUT_BYPASS                    : std_logic;                                       -- Field: LUT_BYPASS
signal field_rw_DATA_LUT_CTRL_LUT_PALETTE_USE               : std_logic;                                       -- Field: LUT_PALETTE_USE
signal field_rw_DATA_LUT_CTRL_LUT_PALETTE_W                 : std_logic;                                       -- Field: LUT_PALETTE_W
signal field_rw_DATA_LUT_CTRL_LUT_DATA_W                    : std_logic_vector(9 downto 0);                    -- Field: LUT_DATA_W
signal field_rw_DATA_LUT_CTRL_LUT_SEL                       : std_logic_vector(2 downto 0);                    -- Field: LUT_SEL
signal field_rw_DATA_LUT_CTRL_LUT_WRN                       : std_logic;                                       -- Field: LUT_WRN
signal field_wautoclr_DATA_LUT_CTRL_LUT_SS                  : std_logic;                                       -- Field: LUT_SS
signal field_rw_DATA_LUT_CTRL_LUT_ADD                       : std_logic_vector(9 downto 0);                    -- Field: LUT_ADD
signal field_rw_DATA_WB_MULT1_WB_MULT_G                     : std_logic_vector(15 downto 0);                   -- Field: WB_MULT_G
signal field_rw_DATA_WB_MULT1_WB_MULT_B                     : std_logic_vector(15 downto 0);                   -- Field: WB_MULT_B
signal field_rw_DATA_WB_MULT2_WB_MULT_R                     : std_logic_vector(15 downto 0);                   -- Field: WB_MULT_R
signal field_rw_DATA_FPN_ADD_FPN_73                         : std_logic;                                       -- Field: FPN_73
signal field_rw_DATA_FPN_ADD_FPN_WE                         : std_logic;                                       -- Field: FPN_WE
signal field_rw_DATA_FPN_ADD_FPN_EN                         : std_logic;                                       -- Field: FPN_EN
signal field_wautoclr_DATA_FPN_ADD_FPN_SS                   : std_logic;                                       -- Field: FPN_SS
signal field_rw_DATA_FPN_ADD_FPN_ADD                        : std_logic_vector(9 downto 0);                    -- Field: FPN_ADD
signal field_rw_DATA_FPN_READ_REG_FPN_READ_PIX_SEL          : std_logic_vector(2 downto 0);                    -- Field: FPN_READ_PIX_SEL
signal field_rw_DATA_FPN_DATA_0_FPN_DATA_PRNU               : std_logic_vector(8 downto 0);                    -- Field: FPN_DATA_PRNU
signal field_rw_DATA_FPN_DATA_0_FPN_DATA_FPN                : std_logic_vector(10 downto 0);                   -- Field: FPN_DATA_FPN
signal field_rw_DATA_FPN_DATA_1_FPN_DATA_PRNU               : std_logic_vector(8 downto 0);                    -- Field: FPN_DATA_PRNU
signal field_rw_DATA_FPN_DATA_1_FPN_DATA_FPN                : std_logic_vector(10 downto 0);                   -- Field: FPN_DATA_FPN
signal field_rw_DATA_FPN_DATA_2_FPN_DATA_PRNU               : std_logic_vector(8 downto 0);                    -- Field: FPN_DATA_PRNU
signal field_rw_DATA_FPN_DATA_2_FPN_DATA_FPN                : std_logic_vector(10 downto 0);                   -- Field: FPN_DATA_FPN
signal field_rw_DATA_FPN_DATA_3_FPN_DATA_PRNU               : std_logic_vector(8 downto 0);                    -- Field: FPN_DATA_PRNU
signal field_rw_DATA_FPN_DATA_3_FPN_DATA_FPN                : std_logic_vector(10 downto 0);                   -- Field: FPN_DATA_FPN
signal field_rw_DATA_FPN_DATA_4_FPN_DATA_PRNU               : std_logic_vector(8 downto 0);                    -- Field: FPN_DATA_PRNU
signal field_rw_DATA_FPN_DATA_4_FPN_DATA_FPN                : std_logic_vector(10 downto 0);                   -- Field: FPN_DATA_FPN
signal field_rw_DATA_FPN_DATA_5_FPN_DATA_PRNU               : std_logic_vector(8 downto 0);                    -- Field: FPN_DATA_PRNU
signal field_rw_DATA_FPN_DATA_5_FPN_DATA_FPN                : std_logic_vector(10 downto 0);                   -- Field: FPN_DATA_FPN
signal field_rw_DATA_FPN_DATA_6_FPN_DATA_PRNU               : std_logic_vector(8 downto 0);                    -- Field: FPN_DATA_PRNU
signal field_rw_DATA_FPN_DATA_6_FPN_DATA_FPN                : std_logic_vector(10 downto 0);                   -- Field: FPN_DATA_FPN
signal field_rw_DATA_FPN_DATA_7_FPN_DATA_PRNU               : std_logic_vector(8 downto 0);                    -- Field: FPN_DATA_PRNU
signal field_rw_DATA_FPN_DATA_7_FPN_DATA_FPN                : std_logic_vector(10 downto 0);                   -- Field: FPN_DATA_FPN
signal field_rw_DATA_FPN_CONTRAST_CONTRAST_GAIN             : std_logic_vector(11 downto 0);                   -- Field: CONTRAST_GAIN
signal field_rw_DATA_FPN_CONTRAST_CONTRAST_OFFSET           : std_logic_vector(7 downto 0);                    -- Field: CONTRAST_OFFSET
signal field_rw_DATA_FPN_ACC_ADD_FPN_ACC_MODE_SEL           : std_logic;                                       -- Field: FPN_ACC_MODE_SEL
signal field_rw_DATA_FPN_ACC_ADD_FPN_ACC_MODE_EN            : std_logic;                                       -- Field: FPN_ACC_MODE_EN
signal field_wautoclr_DATA_FPN_ACC_ADD_FPN_ACC_R_SS         : std_logic;                                       -- Field: FPN_ACC_R_SS
signal field_rw_DATA_FPN_ACC_ADD_FPN_ACC_ADD                : std_logic_vector(11 downto 0);                   -- Field: FPN_ACC_ADD
signal field_rw_DATA_DPC_LIST_CTRL_dpc_fifo_reset           : std_logic;                                       -- Field: dpc_fifo_reset
signal field_rw_DATA_DPC_LIST_CTRL_dpc_firstlast_line_rem   : std_logic;                                       -- Field: dpc_firstlast_line_rem
signal field_rw_DATA_DPC_LIST_CTRL_dpc_pattern0_cfg         : std_logic;                                       -- Field: dpc_pattern0_cfg
signal field_rw_DATA_DPC_LIST_CTRL_dpc_enable               : std_logic;                                       -- Field: dpc_enable
signal field_rw_DATA_DPC_LIST_CTRL_dpc_list_count           : std_logic_vector(5 downto 0);                    -- Field: dpc_list_count
signal field_rw_DATA_DPC_LIST_CTRL_dpc_list_WRn             : std_logic;                                       -- Field: dpc_list_WRn
signal field_wautoclr_DATA_DPC_LIST_CTRL_dpc_list_ss        : std_logic;                                       -- Field: dpc_list_ss
signal field_rw_DATA_DPC_LIST_CTRL_dpc_list_add             : std_logic_vector(5 downto 0);                    -- Field: dpc_list_add
signal field_rw_DATA_DPC_LIST_DATA_dpc_list_corr_pattern    : std_logic_vector(7 downto 0);                    -- Field: dpc_list_corr_pattern
signal field_rw_DATA_DPC_LIST_DATA_dpc_list_corr_y          : std_logic_vector(11 downto 0);                   -- Field: dpc_list_corr_y
signal field_rw_DATA_DPC_LIST_DATA_dpc_list_corr_x          : std_logic_vector(11 downto 0);                   -- Field: dpc_list_corr_x
signal field_rw_HISPI_CTRL_CLR                              : std_logic;                                       -- Field: CLR
signal field_rw_HISPI_CTRL_RESET_IDELAYCTRL                 : std_logic;                                       -- Field: RESET_IDELAYCTRL

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

hit(0)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#0#,12)))	else '0'; -- Addr:  0x0000	TAG
hit(1)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#4#,12)))	else '0'; -- Addr:  0x0004	VERSION
hit(2)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#8#,12)))	else '0'; -- Addr:  0x0008	CAPABILITY
hit(3)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#c#,12)))	else '0'; -- Addr:  0x000C	SCRATCHPAD
hit(4)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#70#,12)))	else '0'; -- Addr:  0x0070	CTRL
hit(5)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#74#,12)))	else '0'; -- Addr:  0x0074	FSTART
hit(6)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#78#,12)))	else '0'; -- Addr:  0x0078	FSTART_HIGH
hit(7)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#7c#,12)))	else '0'; -- Addr:  0x007C	FSTART_G
hit(8)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#80#,12)))	else '0'; -- Addr:  0x0080	FSTART_G_HIGH
hit(9)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#84#,12)))	else '0'; -- Addr:  0x0084	FSTART_R
hit(10) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#88#,12)))	else '0'; -- Addr:  0x0088	FSTART_R_HIGH
hit(11) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#8c#,12)))	else '0'; -- Addr:  0x008C	LINE_PITCH
hit(12) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#90#,12)))	else '0'; -- Addr:  0x0090	LINE_SIZE
hit(13) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#94#,12)))	else '0'; -- Addr:  0x0094	CSC
hit(14) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#100#,12)))	else '0'; -- Addr:  0x0100	GRAB_CTRL
hit(15) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#108#,12)))	else '0'; -- Addr:  0x0108	GRAB_STAT
hit(16) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#110#,12)))	else '0'; -- Addr:  0x0110	READOUT_CFG1
hit(17) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#118#,12)))	else '0'; -- Addr:  0x0118	READOUT_CFG2
hit(18) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#120#,12)))	else '0'; -- Addr:  0x0120	READOUT_CFG3
hit(19) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#128#,12)))	else '0'; -- Addr:  0x0128	EXP_CTRL1
hit(20) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#130#,12)))	else '0'; -- Addr:  0x0130	EXP_CTRL2
hit(21) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#138#,12)))	else '0'; -- Addr:  0x0138	EXP_CTRL3
hit(22) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#140#,12)))	else '0'; -- Addr:  0x0140	TRIGGER_DELAY
hit(23) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#148#,12)))	else '0'; -- Addr:  0x0148	STROBE_CTRL1
hit(24) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#150#,12)))	else '0'; -- Addr:  0x0150	STROBE_CTRL2
hit(25) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#158#,12)))	else '0'; -- Addr:  0x0158	ACQ_SER_CTRL
hit(26) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#160#,12)))	else '0'; -- Addr:  0x0160	ACQ_SER_ADDATA
hit(27) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#168#,12)))	else '0'; -- Addr:  0x0168	ACQ_SER_STAT
hit(28) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#170#,12)))	else '0'; -- Addr:  0x0170	LVDS_CTRL
hit(29) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#178#,12)))	else '0'; -- Addr:  0x0178	LVDS_CTRL2
hit(30) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#180#,12)))	else '0'; -- Addr:  0x0180	LVDS_TRAINING
hit(31) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#188#,12)))	else '0'; -- Addr:  0x0188	LVDS_STAT
hit(32) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#18c#,12)))	else '0'; -- Addr:  0x018C	LVDS_STAT2
hit(33) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#190#,12)))	else '0'; -- Addr:  0x0190	SENSOR_CTRL
hit(34) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#198#,12)))	else '0'; -- Addr:  0x0198	SENSOR_STAT
hit(35) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1a0#,12)))	else '0'; -- Addr:  0x01A0	SENSOR_GEN_CFG
hit(36) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1a8#,12)))	else '0'; -- Addr:  0x01A8	SENSOR_INT_CTL
hit(37) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1b0#,12)))	else '0'; -- Addr:  0x01B0	SENSOR_GAIN_ANA
hit(38) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1b8#,12)))	else '0'; -- Addr:  0x01B8	SENSOR_BLACK_CAL
hit(39) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1c0#,12)))	else '0'; -- Addr:  0x01C0	SENSOR_ROI_CONF0
hit(40) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1c4#,12)))	else '0'; -- Addr:  0x01C4	SENSOR_ROI2_CONF0
hit(41) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1c8#,12)))	else '0'; -- Addr:  0x01C8	SENSOR_ROI_CONF1
hit(42) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1cc#,12)))	else '0'; -- Addr:  0x01CC	SENSOR_ROI2_CONF1
hit(43) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1d0#,12)))	else '0'; -- Addr:  0x01D0	SENSOR_ROI_CONF2
hit(44) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1d4#,12)))	else '0'; -- Addr:  0x01D4	SENSOR_ROI2_CONF2
hit(45) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1d8#,12)))	else '0'; -- Addr:  0x01D8	CRC
hit(46) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1e0#,12)))	else '0'; -- Addr:  0x01E0	DEBUG_PINS
hit(47) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1e8#,12)))	else '0'; -- Addr:  0x01E8	TRIGGER_MISSED
hit(48) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1f0#,12)))	else '0'; -- Addr:  0x01F0	SENSOR_FPS
hit(49) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#220#,12)))	else '0'; -- Addr:  0x0220	DEBUG
hit(50) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#228#,12)))	else '0'; -- Addr:  0x0228	DEBUG_CNTR1
hit(51) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#230#,12)))	else '0'; -- Addr:  0x0230	DEBUG_CNTR2
hit(52) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#234#,12)))	else '0'; -- Addr:  0x0234	DEBUG_CNTR3
hit(53) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#23c#,12)))	else '0'; -- Addr:  0x023C	EXP_FOT
hit(54) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#244#,12)))	else '0'; -- Addr:  0x0244	ACQ_SFNC
hit(55) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#254#,12)))	else '0'; -- Addr:  0x0254	NOPEL
hit(56) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#300#,12)))	else '0'; -- Addr:  0x0300	LUT_CTRL
hit(57) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#308#,12)))	else '0'; -- Addr:  0x0308	LUT_RB
hit(58) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#310#,12)))	else '0'; -- Addr:  0x0310	WB_MULT1
hit(59) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#318#,12)))	else '0'; -- Addr:  0x0318	WB_MULT2
hit(60) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#320#,12)))	else '0'; -- Addr:  0x0320	WB_B_ACC
hit(61) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#328#,12)))	else '0'; -- Addr:  0x0328	WB_G_ACC
hit(62) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#330#,12)))	else '0'; -- Addr:  0x0330	WB_R_ACC
hit(63) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#338#,12)))	else '0'; -- Addr:  0x0338	FPN_ADD
hit(64) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#33c#,12)))	else '0'; -- Addr:  0x033C	FPN_READ_REG
hit(65) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#340#,12)))	else '0'; -- Addr:  0x0340	FPN_DATA[0]
hit(66) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#344#,12)))	else '0'; -- Addr:  0x0344	FPN_DATA[1]
hit(67) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#348#,12)))	else '0'; -- Addr:  0x0348	FPN_DATA[2]
hit(68) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#34c#,12)))	else '0'; -- Addr:  0x034C	FPN_DATA[3]
hit(69) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#350#,12)))	else '0'; -- Addr:  0x0350	FPN_DATA[4]
hit(70) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#354#,12)))	else '0'; -- Addr:  0x0354	FPN_DATA[5]
hit(71) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#358#,12)))	else '0'; -- Addr:  0x0358	FPN_DATA[6]
hit(72) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#35c#,12)))	else '0'; -- Addr:  0x035C	FPN_DATA[7]
hit(73) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#360#,12)))	else '0'; -- Addr:  0x0360	FPN_CONTRAST
hit(74) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#368#,12)))	else '0'; -- Addr:  0x0368	FPN_ACC_ADD
hit(75) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#370#,12)))	else '0'; -- Addr:  0x0370	FPN_ACC_DATA
hit(76) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#380#,12)))	else '0'; -- Addr:  0x0380	DPC_LIST_CTRL
hit(77) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#384#,12)))	else '0'; -- Addr:  0x0384	DPC_LIST_DATA
hit(78) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#388#,12)))	else '0'; -- Addr:  0x0388	DPC_LIST_DATA_RD
hit(79) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#400#,12)))	else '0'; -- Addr:  0x0400	CTRL
hit(80) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#404#,12)))	else '0'; -- Addr:  0x0404	STATUS



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
                            rb_ACQ_GRAB_CTRL,
                            rb_ACQ_GRAB_STAT,
                            rb_ACQ_READOUT_CFG1,
                            rb_ACQ_READOUT_CFG2,
                            rb_ACQ_READOUT_CFG3,
                            rb_ACQ_EXP_CTRL1,
                            rb_ACQ_EXP_CTRL2,
                            rb_ACQ_EXP_CTRL3,
                            rb_ACQ_TRIGGER_DELAY,
                            rb_ACQ_STROBE_CTRL1,
                            rb_ACQ_STROBE_CTRL2,
                            rb_ACQ_ACQ_SER_CTRL,
                            rb_ACQ_ACQ_SER_ADDATA,
                            rb_ACQ_ACQ_SER_STAT,
                            rb_ACQ_LVDS_CTRL,
                            rb_ACQ_LVDS_CTRL2,
                            rb_ACQ_LVDS_TRAINING,
                            rb_ACQ_LVDS_STAT,
                            rb_ACQ_LVDS_STAT2,
                            rb_ACQ_SENSOR_CTRL,
                            rb_ACQ_SENSOR_STAT,
                            rb_ACQ_SENSOR_GEN_CFG,
                            rb_ACQ_SENSOR_INT_CTL,
                            rb_ACQ_SENSOR_GAIN_ANA,
                            rb_ACQ_SENSOR_BLACK_CAL,
                            rb_ACQ_SENSOR_ROI_CONF0,
                            rb_ACQ_SENSOR_ROI2_CONF0,
                            rb_ACQ_SENSOR_ROI_CONF1,
                            rb_ACQ_SENSOR_ROI2_CONF1,
                            rb_ACQ_SENSOR_ROI_CONF2,
                            rb_ACQ_SENSOR_ROI2_CONF2,
                            rb_ACQ_CRC,
                            rb_ACQ_DEBUG_PINS,
                            rb_ACQ_TRIGGER_MISSED,
                            rb_ACQ_SENSOR_FPS,
                            rb_ACQ_DEBUG,
                            rb_ACQ_DEBUG_CNTR1,
                            rb_ACQ_DEBUG_CNTR2,
                            rb_ACQ_DEBUG_CNTR3,
                            rb_ACQ_EXP_FOT,
                            rb_ACQ_ACQ_SFNC,
                            rb_ACQ_NOPEL,
                            rb_DATA_LUT_CTRL,
                            rb_DATA_LUT_RB,
                            rb_DATA_WB_MULT1,
                            rb_DATA_WB_MULT2,
                            rb_DATA_WB_B_ACC,
                            rb_DATA_WB_G_ACC,
                            rb_DATA_WB_R_ACC,
                            rb_DATA_FPN_ADD,
                            rb_DATA_FPN_READ_REG,
                            rb_DATA_FPN_DATA_0,
                            rb_DATA_FPN_DATA_1,
                            rb_DATA_FPN_DATA_2,
                            rb_DATA_FPN_DATA_3,
                            rb_DATA_FPN_DATA_4,
                            rb_DATA_FPN_DATA_5,
                            rb_DATA_FPN_DATA_6,
                            rb_DATA_FPN_DATA_7,
                            rb_DATA_FPN_CONTRAST,
                            rb_DATA_FPN_ACC_ADD,
                            rb_DATA_FPN_ACC_DATA,
                            rb_DATA_DPC_LIST_CTRL,
                            rb_DATA_DPC_LIST_DATA,
                            rb_DATA_DPC_LIST_DATA_RD,
                            rb_HISPI_CTRL,
                            rb_HISPI_STATUS
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

      -- [0x074]: /DMA/FSTART
      when 16#74# =>
         readBackMux <= rb_DMA_FSTART;

      -- [0x078]: /DMA/FSTART_HIGH
      when 16#78# =>
         readBackMux <= rb_DMA_FSTART_HIGH;

      -- [0x07c]: /DMA/FSTART_G
      when 16#7C# =>
         readBackMux <= rb_DMA_FSTART_G;

      -- [0x080]: /DMA/FSTART_G_HIGH
      when 16#80# =>
         readBackMux <= rb_DMA_FSTART_G_HIGH;

      -- [0x084]: /DMA/FSTART_R
      when 16#84# =>
         readBackMux <= rb_DMA_FSTART_R;

      -- [0x088]: /DMA/FSTART_R_HIGH
      when 16#88# =>
         readBackMux <= rb_DMA_FSTART_R_HIGH;

      -- [0x08c]: /DMA/LINE_PITCH
      when 16#8C# =>
         readBackMux <= rb_DMA_LINE_PITCH;

      -- [0x090]: /DMA/LINE_SIZE
      when 16#90# =>
         readBackMux <= rb_DMA_LINE_SIZE;

      -- [0x094]: /DMA/CSC
      when 16#94# =>
         readBackMux <= rb_DMA_CSC;

      -- [0x100]: /ACQ/GRAB_CTRL
      when 16#100# =>
         readBackMux <= rb_ACQ_GRAB_CTRL;

      -- [0x108]: /ACQ/GRAB_STAT
      when 16#108# =>
         readBackMux <= rb_ACQ_GRAB_STAT;

      -- [0x110]: /ACQ/READOUT_CFG1
      when 16#110# =>
         readBackMux <= rb_ACQ_READOUT_CFG1;

      -- [0x118]: /ACQ/READOUT_CFG2
      when 16#118# =>
         readBackMux <= rb_ACQ_READOUT_CFG2;

      -- [0x120]: /ACQ/READOUT_CFG3
      when 16#120# =>
         readBackMux <= rb_ACQ_READOUT_CFG3;

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

      -- [0x170]: /ACQ/LVDS_CTRL
      when 16#170# =>
         readBackMux <= rb_ACQ_LVDS_CTRL;

      -- [0x178]: /ACQ/LVDS_CTRL2
      when 16#178# =>
         readBackMux <= rb_ACQ_LVDS_CTRL2;

      -- [0x180]: /ACQ/LVDS_TRAINING
      when 16#180# =>
         readBackMux <= rb_ACQ_LVDS_TRAINING;

      -- [0x188]: /ACQ/LVDS_STAT
      when 16#188# =>
         readBackMux <= rb_ACQ_LVDS_STAT;

      -- [0x18c]: /ACQ/LVDS_STAT2
      when 16#18C# =>
         readBackMux <= rb_ACQ_LVDS_STAT2;

      -- [0x190]: /ACQ/SENSOR_CTRL
      when 16#190# =>
         readBackMux <= rb_ACQ_SENSOR_CTRL;

      -- [0x198]: /ACQ/SENSOR_STAT
      when 16#198# =>
         readBackMux <= rb_ACQ_SENSOR_STAT;

      -- [0x1a0]: /ACQ/SENSOR_GEN_CFG
      when 16#1A0# =>
         readBackMux <= rb_ACQ_SENSOR_GEN_CFG;

      -- [0x1a8]: /ACQ/SENSOR_INT_CTL
      when 16#1A8# =>
         readBackMux <= rb_ACQ_SENSOR_INT_CTL;

      -- [0x1b0]: /ACQ/SENSOR_GAIN_ANA
      when 16#1B0# =>
         readBackMux <= rb_ACQ_SENSOR_GAIN_ANA;

      -- [0x1b8]: /ACQ/SENSOR_BLACK_CAL
      when 16#1B8# =>
         readBackMux <= rb_ACQ_SENSOR_BLACK_CAL;

      -- [0x1c0]: /ACQ/SENSOR_ROI_CONF0
      when 16#1C0# =>
         readBackMux <= rb_ACQ_SENSOR_ROI_CONF0;

      -- [0x1c4]: /ACQ/SENSOR_ROI2_CONF0
      when 16#1C4# =>
         readBackMux <= rb_ACQ_SENSOR_ROI2_CONF0;

      -- [0x1c8]: /ACQ/SENSOR_ROI_CONF1
      when 16#1C8# =>
         readBackMux <= rb_ACQ_SENSOR_ROI_CONF1;

      -- [0x1cc]: /ACQ/SENSOR_ROI2_CONF1
      when 16#1CC# =>
         readBackMux <= rb_ACQ_SENSOR_ROI2_CONF1;

      -- [0x1d0]: /ACQ/SENSOR_ROI_CONF2
      when 16#1D0# =>
         readBackMux <= rb_ACQ_SENSOR_ROI_CONF2;

      -- [0x1d4]: /ACQ/SENSOR_ROI2_CONF2
      when 16#1D4# =>
         readBackMux <= rb_ACQ_SENSOR_ROI2_CONF2;

      -- [0x1d8]: /ACQ/CRC
      when 16#1D8# =>
         readBackMux <= rb_ACQ_CRC;

      -- [0x1e0]: /ACQ/DEBUG_PINS
      when 16#1E0# =>
         readBackMux <= rb_ACQ_DEBUG_PINS;

      -- [0x1e8]: /ACQ/TRIGGER_MISSED
      when 16#1E8# =>
         readBackMux <= rb_ACQ_TRIGGER_MISSED;

      -- [0x1f0]: /ACQ/SENSOR_FPS
      when 16#1F0# =>
         readBackMux <= rb_ACQ_SENSOR_FPS;

      -- [0x220]: /ACQ/DEBUG
      when 16#220# =>
         readBackMux <= rb_ACQ_DEBUG;

      -- [0x228]: /ACQ/DEBUG_CNTR1
      when 16#228# =>
         readBackMux <= rb_ACQ_DEBUG_CNTR1;

      -- [0x230]: /ACQ/DEBUG_CNTR2
      when 16#230# =>
         readBackMux <= rb_ACQ_DEBUG_CNTR2;

      -- [0x234]: /ACQ/DEBUG_CNTR3
      when 16#234# =>
         readBackMux <= rb_ACQ_DEBUG_CNTR3;

      -- [0x23c]: /ACQ/EXP_FOT
      when 16#23C# =>
         readBackMux <= rb_ACQ_EXP_FOT;

      -- [0x244]: /ACQ/ACQ_SFNC
      when 16#244# =>
         readBackMux <= rb_ACQ_ACQ_SFNC;

      -- [0x254]: /ACQ/NOPEL
      when 16#254# =>
         readBackMux <= rb_ACQ_NOPEL;

      -- [0x300]: /DATA/LUT_CTRL
      when 16#300# =>
         readBackMux <= rb_DATA_LUT_CTRL;

      -- [0x308]: /DATA/LUT_RB
      when 16#308# =>
         readBackMux <= rb_DATA_LUT_RB;

      -- [0x310]: /DATA/WB_MULT1
      when 16#310# =>
         readBackMux <= rb_DATA_WB_MULT1;

      -- [0x318]: /DATA/WB_MULT2
      when 16#318# =>
         readBackMux <= rb_DATA_WB_MULT2;

      -- [0x320]: /DATA/WB_B_ACC
      when 16#320# =>
         readBackMux <= rb_DATA_WB_B_ACC;

      -- [0x328]: /DATA/WB_G_ACC
      when 16#328# =>
         readBackMux <= rb_DATA_WB_G_ACC;

      -- [0x330]: /DATA/WB_R_ACC
      when 16#330# =>
         readBackMux <= rb_DATA_WB_R_ACC;

      -- [0x338]: /DATA/FPN_ADD
      when 16#338# =>
         readBackMux <= rb_DATA_FPN_ADD;

      -- [0x33c]: /DATA/FPN_READ_REG
      when 16#33C# =>
         readBackMux <= rb_DATA_FPN_READ_REG;

      -- [0x340]: /DATA/FPN_DATA_0
      when 16#340# =>
         readBackMux <= rb_DATA_FPN_DATA_0;

      -- [0x344]: /DATA/FPN_DATA_1
      when 16#344# =>
         readBackMux <= rb_DATA_FPN_DATA_1;

      -- [0x348]: /DATA/FPN_DATA_2
      when 16#348# =>
         readBackMux <= rb_DATA_FPN_DATA_2;

      -- [0x34c]: /DATA/FPN_DATA_3
      when 16#34C# =>
         readBackMux <= rb_DATA_FPN_DATA_3;

      -- [0x350]: /DATA/FPN_DATA_4
      when 16#350# =>
         readBackMux <= rb_DATA_FPN_DATA_4;

      -- [0x354]: /DATA/FPN_DATA_5
      when 16#354# =>
         readBackMux <= rb_DATA_FPN_DATA_5;

      -- [0x358]: /DATA/FPN_DATA_6
      when 16#358# =>
         readBackMux <= rb_DATA_FPN_DATA_6;

      -- [0x35c]: /DATA/FPN_DATA_7
      when 16#35C# =>
         readBackMux <= rb_DATA_FPN_DATA_7;

      -- [0x360]: /DATA/FPN_CONTRAST
      when 16#360# =>
         readBackMux <= rb_DATA_FPN_CONTRAST;

      -- [0x368]: /DATA/FPN_ACC_ADD
      when 16#368# =>
         readBackMux <= rb_DATA_FPN_ACC_ADD;

      -- [0x370]: /DATA/FPN_ACC_DATA
      when 16#370# =>
         readBackMux <= rb_DATA_FPN_ACC_DATA;

      -- [0x380]: /DATA/DPC_LIST_CTRL
      when 16#380# =>
         readBackMux <= rb_DATA_DPC_LIST_CTRL;

      -- [0x384]: /DATA/DPC_LIST_DATA
      when 16#384# =>
         readBackMux <= rb_DATA_DPC_LIST_DATA;

      -- [0x388]: /DATA/DPC_LIST_DATA_RD
      when 16#388# =>
         readBackMux <= rb_DATA_DPC_LIST_DATA_RD;

      -- [0x400]: /HISPI/CTRL
      when 16#400# =>
         readBackMux <= rb_HISPI_CTRL;

      -- [0x404]: /HISPI/STATUS
      when 16#404# =>
         readBackMux <= rb_HISPI_STATUS;

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
rb_SYSTEM_VERSION(23 downto 16) <= std_logic_vector(to_unsigned(integer(1),8));
regfile.SYSTEM.VERSION.MAJOR <= rb_SYSTEM_VERSION(23 downto 16);


------------------------------------------------------------------------------------------
-- Field name: MINOR
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_SYSTEM_VERSION(15 downto 8) <= std_logic_vector(to_unsigned(integer(5),8));
regfile.SYSTEM.VERSION.MINOR <= rb_SYSTEM_VERSION(15 downto 8);


------------------------------------------------------------------------------------------
-- Field name: HW(7 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_SYSTEM_VERSION(7 downto 0) <= regfile.SYSTEM.VERSION.HW;




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
      if(wEn(4) = '1' and bitEnN(0) = '0') then
         field_rw_DMA_CTRL_GRAB_QUEUE_EN <= reg_writedata(0);
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
      for j in  31 downto 0  loop
         if(wEn(5) = '1' and bitEnN(j) = '0') then
            field_rw_DMA_FSTART_VALUE(j-0) <= reg_writedata(j);
         end if;
      end loop;
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
      for j in  31 downto 0  loop
         if(wEn(6) = '1' and bitEnN(j) = '0') then
            field_rw_DMA_FSTART_HIGH_VALUE(j-0) <= reg_writedata(j);
         end if;
      end loop;
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
      for j in  31 downto 0  loop
         if(wEn(7) = '1' and bitEnN(j) = '0') then
            field_rw_DMA_FSTART_G_VALUE(j-0) <= reg_writedata(j);
         end if;
      end loop;
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
      for j in  31 downto 0  loop
         if(wEn(8) = '1' and bitEnN(j) = '0') then
            field_rw_DMA_FSTART_G_HIGH_VALUE(j-0) <= reg_writedata(j);
         end if;
      end loop;
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
      for j in  31 downto 0  loop
         if(wEn(9) = '1' and bitEnN(j) = '0') then
            field_rw_DMA_FSTART_R_VALUE(j-0) <= reg_writedata(j);
         end if;
      end loop;
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
      for j in  31 downto 0  loop
         if(wEn(10) = '1' and bitEnN(j) = '0') then
            field_rw_DMA_FSTART_R_HIGH_VALUE(j-0) <= reg_writedata(j);
         end if;
      end loop;
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
      for j in  15 downto 0  loop
         if(wEn(11) = '1' and bitEnN(j) = '0') then
            field_rw_DMA_LINE_PITCH_VALUE(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_DMA_LINE_PITCH_VALUE;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DMA_LINE_SIZE
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(12) <= (hit(12)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: VALUE(13 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DMA_LINE_SIZE(13 downto 0) <= field_rw_DMA_LINE_SIZE_VALUE(13 downto 0);
regfile.DMA.LINE_SIZE.VALUE <= field_rw_DMA_LINE_SIZE_VALUE(13 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DMA_LINE_SIZE_VALUE
------------------------------------------------------------------------------------------
P_DMA_LINE_SIZE_VALUE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DMA_LINE_SIZE_VALUE <= std_logic_vector(to_unsigned(integer(0),14));
      else
         for j in  13 downto 0  loop
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
-- Field name: DUP_LAST_LINE
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DMA_CSC(23) <= field_rw_DMA_CSC_DUP_LAST_LINE;
regfile.DMA.CSC.DUP_LAST_LINE <= field_rw_DMA_CSC_DUP_LAST_LINE;


------------------------------------------------------------------------------------------
-- Process: P_DMA_CSC_DUP_LAST_LINE
------------------------------------------------------------------------------------------
P_DMA_CSC_DUP_LAST_LINE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DMA_CSC_DUP_LAST_LINE <= '0';
      else
         if(wEn(13) = '1' and bitEnN(23) = '0') then
            field_rw_DMA_CSC_DUP_LAST_LINE <= reg_writedata(23);
         end if;
      end if;
   end if;
end process P_DMA_CSC_DUP_LAST_LINE;

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
-- Register name: ACQ_GRAB_CTRL
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(14) <= (hit(14)) and (reg_write);

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
         if(wEn(14) = '1' and bitEnN(31) = '0') then
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
         if(wEn(14) = '1' and bitEnN(29) = '0') then
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
         if(wEn(14) = '1' and bitEnN(28) = '0') then
            field_wautoclr_ACQ_GRAB_CTRL_ABORT_GRAB <= reg_writedata(28);
         else
            field_wautoclr_ACQ_GRAB_CTRL_ABORT_GRAB <= '0';
         end if;
      end if;
   end if;
end process P_ACQ_GRAB_CTRL_ABORT_GRAB;

------------------------------------------------------------------------------------------
-- Field name: SLOPE_CFG(25 downto 24)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_GRAB_CTRL(25 downto 24) <= field_rw_ACQ_GRAB_CTRL_SLOPE_CFG(1 downto 0);
regfile.ACQ.GRAB_CTRL.SLOPE_CFG <= field_rw_ACQ_GRAB_CTRL_SLOPE_CFG(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_GRAB_CTRL_SLOPE_CFG
------------------------------------------------------------------------------------------
P_ACQ_GRAB_CTRL_SLOPE_CFG : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_GRAB_CTRL_SLOPE_CFG <= std_logic_vector(to_unsigned(integer(1),2));
      else
         for j in  25 downto 24  loop
            if(wEn(14) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_GRAB_CTRL_SLOPE_CFG(j-24) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_GRAB_CTRL_SLOPE_CFG;

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
         if(wEn(14) = '1' and bitEnN(16) = '0') then
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
         if(wEn(14) = '1' and bitEnN(15) = '0') then
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
            if(wEn(14) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_GRAB_CTRL_TRIGGER_ACT(j-12) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_GRAB_CTRL_TRIGGER_ACT;

------------------------------------------------------------------------------------------
-- Field name: TRIGGER_SRC(9 downto 8)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_GRAB_CTRL(9 downto 8) <= field_rw_ACQ_GRAB_CTRL_TRIGGER_SRC(1 downto 0);
regfile.ACQ.GRAB_CTRL.TRIGGER_SRC <= field_rw_ACQ_GRAB_CTRL_TRIGGER_SRC(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_GRAB_CTRL_TRIGGER_SRC
------------------------------------------------------------------------------------------
P_ACQ_GRAB_CTRL_TRIGGER_SRC : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_GRAB_CTRL_TRIGGER_SRC <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  9 downto 8  loop
            if(wEn(14) = '1' and bitEnN(j) = '0') then
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
         if(wEn(14) = '1' and bitEnN(4) = '0') then
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
         if(wEn(14) = '1' and bitEnN(1) = '0') then
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
         if(wEn(14) = '1' and bitEnN(0) = '0') then
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
wEn(15) <= (hit(15)) and (reg_write);

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
wEn(16) <= (hit(16)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: ROT_LENGTH
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_ACQ_READOUT_CFG1(25 downto 16) <= std_logic_vector(to_unsigned(integer(0),10));
regfile.ACQ.READOUT_CFG1.ROT_LENGTH <= rb_ACQ_READOUT_CFG1(25 downto 16);


------------------------------------------------------------------------------------------
-- Field name: FOT_LENGTH
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_ACQ_READOUT_CFG1(15 downto 0) <= std_logic_vector(to_unsigned(integer(0),16));
regfile.ACQ.READOUT_CFG1.FOT_LENGTH <= rb_ACQ_READOUT_CFG1(15 downto 0);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_READOUT_CFG2
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(17) <= (hit(17)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: READOUT_EN
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_READOUT_CFG2(28) <= field_rw_ACQ_READOUT_CFG2_READOUT_EN;
regfile.ACQ.READOUT_CFG2.READOUT_EN <= field_rw_ACQ_READOUT_CFG2_READOUT_EN;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_READOUT_CFG2_READOUT_EN
------------------------------------------------------------------------------------------
P_ACQ_READOUT_CFG2_READOUT_EN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_READOUT_CFG2_READOUT_EN <= '0';
      else
         if(wEn(17) = '1' and bitEnN(28) = '0') then
            field_rw_ACQ_READOUT_CFG2_READOUT_EN <= reg_writedata(28);
         end if;
      end if;
   end if;
end process P_ACQ_READOUT_CFG2_READOUT_EN;

------------------------------------------------------------------------------------------
-- Field name: READOUT_LENGTH(23 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_READOUT_CFG2(23 downto 0) <= field_rw_ACQ_READOUT_CFG2_READOUT_LENGTH(23 downto 0);
regfile.ACQ.READOUT_CFG2.READOUT_LENGTH <= field_rw_ACQ_READOUT_CFG2_READOUT_LENGTH(23 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_READOUT_CFG2_READOUT_LENGTH
------------------------------------------------------------------------------------------
P_ACQ_READOUT_CFG2_READOUT_LENGTH : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_READOUT_CFG2_READOUT_LENGTH <= std_logic_vector(to_unsigned(integer(0),24));
      else
         for j in  23 downto 0  loop
            if(wEn(17) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_READOUT_CFG2_READOUT_LENGTH(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_READOUT_CFG2_READOUT_LENGTH;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_READOUT_CFG3
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(18) <= (hit(18)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: BL_LINES
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_ACQ_READOUT_CFG3(7 downto 0) <= std_logic_vector(to_unsigned(integer(2),8));
regfile.ACQ.READOUT_CFG3.BL_LINES <= rb_ACQ_READOUT_CFG3(7 downto 0);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_EXP_CTRL1
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(19) <= (hit(19)) and (reg_write);

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
         if(wEn(19) = '1' and bitEnN(28) = '0') then
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
            if(wEn(19) = '1' and bitEnN(j) = '0') then
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
wEn(20) <= (hit(20)) and (reg_write);

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
            if(wEn(20) = '1' and bitEnN(j) = '0') then
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
wEn(21) <= (hit(21)) and (reg_write);

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
            if(wEn(21) = '1' and bitEnN(j) = '0') then
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
wEn(22) <= (hit(22)) and (reg_write);

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
            if(wEn(22) = '1' and bitEnN(j) = '0') then
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
wEn(23) <= (hit(23)) and (reg_write);

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
         if(wEn(23) = '1' and bitEnN(31) = '0') then
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
         if(wEn(23) = '1' and bitEnN(28) = '0') then
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
            if(wEn(23) = '1' and bitEnN(j) = '0') then
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
wEn(24) <= (hit(24)) and (reg_write);

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
         if(wEn(24) = '1' and bitEnN(31) = '0') then
            field_rw_ACQ_STROBE_CTRL2_STROBE_MODE <= reg_writedata(31);
         end if;
      end if;
   end if;
end process P_ACQ_STROBE_CTRL2_STROBE_MODE;

------------------------------------------------------------------------------------------
-- Field name: STROBE_B_EN
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_ACQ_STROBE_CTRL2(29) <= '0';
regfile.ACQ.STROBE_CTRL2.STROBE_B_EN <= rb_ACQ_STROBE_CTRL2(29);


------------------------------------------------------------------------------------------
-- Field name: STROBE_A_EN
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_ACQ_STROBE_CTRL2(28) <= '1';
regfile.ACQ.STROBE_CTRL2.STROBE_A_EN <= rb_ACQ_STROBE_CTRL2(28);


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
            if(wEn(24) = '1' and bitEnN(j) = '0') then
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
wEn(25) <= (hit(25)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: SER_ROI_UPDATE
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_ACQ_SER_CTRL(20) <= field_rw_ACQ_ACQ_SER_CTRL_SER_ROI_UPDATE;
regfile.ACQ.ACQ_SER_CTRL.SER_ROI_UPDATE <= field_rw_ACQ_ACQ_SER_CTRL_SER_ROI_UPDATE;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_ACQ_SER_CTRL_SER_ROI_UPDATE
------------------------------------------------------------------------------------------
P_ACQ_ACQ_SER_CTRL_SER_ROI_UPDATE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_ACQ_SER_CTRL_SER_ROI_UPDATE <= '0';
      else
         if(wEn(25) = '1' and bitEnN(20) = '0') then
            field_rw_ACQ_ACQ_SER_CTRL_SER_ROI_UPDATE <= reg_writedata(20);
         end if;
      end if;
   end if;
end process P_ACQ_ACQ_SER_CTRL_SER_ROI_UPDATE;

------------------------------------------------------------------------------------------
-- Field name: SER_BLACKCAL_UPDATE
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_ACQ_SER_CTRL(19) <= field_rw_ACQ_ACQ_SER_CTRL_SER_BLACKCAL_UPDATE;
regfile.ACQ.ACQ_SER_CTRL.SER_BLACKCAL_UPDATE <= field_rw_ACQ_ACQ_SER_CTRL_SER_BLACKCAL_UPDATE;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_ACQ_SER_CTRL_SER_BLACKCAL_UPDATE
------------------------------------------------------------------------------------------
P_ACQ_ACQ_SER_CTRL_SER_BLACKCAL_UPDATE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_ACQ_SER_CTRL_SER_BLACKCAL_UPDATE <= '0';
      else
         if(wEn(25) = '1' and bitEnN(19) = '0') then
            field_rw_ACQ_ACQ_SER_CTRL_SER_BLACKCAL_UPDATE <= reg_writedata(19);
         end if;
      end if;
   end if;
end process P_ACQ_ACQ_SER_CTRL_SER_BLACKCAL_UPDATE;

------------------------------------------------------------------------------------------
-- Field name: SER_GAIN_UPDATE
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_ACQ_SER_CTRL(18) <= field_rw_ACQ_ACQ_SER_CTRL_SER_GAIN_UPDATE;
regfile.ACQ.ACQ_SER_CTRL.SER_GAIN_UPDATE <= field_rw_ACQ_ACQ_SER_CTRL_SER_GAIN_UPDATE;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_ACQ_SER_CTRL_SER_GAIN_UPDATE
------------------------------------------------------------------------------------------
P_ACQ_ACQ_SER_CTRL_SER_GAIN_UPDATE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_ACQ_SER_CTRL_SER_GAIN_UPDATE <= '0';
      else
         if(wEn(25) = '1' and bitEnN(18) = '0') then
            field_rw_ACQ_ACQ_SER_CTRL_SER_GAIN_UPDATE <= reg_writedata(18);
         end if;
      end if;
   end if;
end process P_ACQ_ACQ_SER_CTRL_SER_GAIN_UPDATE;

------------------------------------------------------------------------------------------
-- Field name: SER_SUBBIN_UPDATE
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_ACQ_SER_CTRL(17) <= field_rw_ACQ_ACQ_SER_CTRL_SER_SUBBIN_UPDATE;
regfile.ACQ.ACQ_SER_CTRL.SER_SUBBIN_UPDATE <= field_rw_ACQ_ACQ_SER_CTRL_SER_SUBBIN_UPDATE;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_ACQ_SER_CTRL_SER_SUBBIN_UPDATE
------------------------------------------------------------------------------------------
P_ACQ_ACQ_SER_CTRL_SER_SUBBIN_UPDATE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_ACQ_SER_CTRL_SER_SUBBIN_UPDATE <= '0';
      else
         if(wEn(25) = '1' and bitEnN(17) = '0') then
            field_rw_ACQ_ACQ_SER_CTRL_SER_SUBBIN_UPDATE <= reg_writedata(17);
         end if;
      end if;
   end if;
end process P_ACQ_ACQ_SER_CTRL_SER_SUBBIN_UPDATE;

------------------------------------------------------------------------------------------
-- Field name: SER_WRn
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_ACQ_SER_CTRL(16) <= field_rw_ACQ_ACQ_SER_CTRL_SER_WRn;
regfile.ACQ.ACQ_SER_CTRL.SER_WRn <= field_rw_ACQ_ACQ_SER_CTRL_SER_WRn;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_ACQ_SER_CTRL_SER_WRn
------------------------------------------------------------------------------------------
P_ACQ_ACQ_SER_CTRL_SER_WRn : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_ACQ_SER_CTRL_SER_WRn <= '1';
      else
         if(wEn(25) = '1' and bitEnN(16) = '0') then
            field_rw_ACQ_ACQ_SER_CTRL_SER_WRn <= reg_writedata(16);
         end if;
      end if;
   end if;
end process P_ACQ_ACQ_SER_CTRL_SER_WRn;

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
            if(wEn(25) = '1' and bitEnN(j) = '0') then
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
         if(wEn(25) = '1' and bitEnN(4) = '0') then
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
         if(wEn(25) = '1' and bitEnN(0) = '0') then
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
wEn(26) <= (hit(26)) and (reg_write);

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
            if(wEn(26) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_ACQ_SER_ADDATA_SER_DAT(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_ACQ_SER_ADDATA_SER_DAT;

------------------------------------------------------------------------------------------
-- Field name: SER_ADD(8 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_ACQ_SER_ADDATA(8 downto 0) <= field_rw_ACQ_ACQ_SER_ADDATA_SER_ADD(8 downto 0);
regfile.ACQ.ACQ_SER_ADDATA.SER_ADD <= field_rw_ACQ_ACQ_SER_ADDATA_SER_ADD(8 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_ACQ_SER_ADDATA_SER_ADD
------------------------------------------------------------------------------------------
P_ACQ_ACQ_SER_ADDATA_SER_ADD : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_ACQ_SER_ADDATA_SER_ADD <= std_logic_vector(to_unsigned(integer(0),9));
      else
         for j in  8 downto 0  loop
            if(wEn(26) = '1' and bitEnN(j) = '0') then
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
wEn(27) <= (hit(27)) and (reg_write);

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
-- Register name: ACQ_LVDS_CTRL
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(28) <= (hit(28)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: LVDS_BIT_RATE(31 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_LVDS_CTRL(31 downto 16) <= field_rw_ACQ_LVDS_CTRL_LVDS_BIT_RATE(15 downto 0);
regfile.ACQ.LVDS_CTRL.LVDS_BIT_RATE <= field_rw_ACQ_LVDS_CTRL_LVDS_BIT_RATE(15 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_LVDS_CTRL_LVDS_BIT_RATE
------------------------------------------------------------------------------------------
P_ACQ_LVDS_CTRL_LVDS_BIT_RATE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_LVDS_CTRL_LVDS_BIT_RATE <= std_logic_vector(to_unsigned(integer(1824),16));
      else
         for j in  31 downto 16  loop
            if(wEn(28) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_LVDS_CTRL_LVDS_BIT_RATE(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_LVDS_CTRL_LVDS_BIT_RATE;

------------------------------------------------------------------------------------------
-- Field name: LVDS_MODE
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_LVDS_CTRL(12) <= regfile.ACQ.LVDS_CTRL.LVDS_MODE;


------------------------------------------------------------------------------------------
-- Field name: LVDS_SER_FACTOR(11 downto 8)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_LVDS_CTRL(11 downto 8) <= field_rw_ACQ_LVDS_CTRL_LVDS_SER_FACTOR(3 downto 0);
regfile.ACQ.LVDS_CTRL.LVDS_SER_FACTOR <= field_rw_ACQ_LVDS_CTRL_LVDS_SER_FACTOR(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_LVDS_CTRL_LVDS_SER_FACTOR
------------------------------------------------------------------------------------------
P_ACQ_LVDS_CTRL_LVDS_SER_FACTOR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_LVDS_CTRL_LVDS_SER_FACTOR <= std_logic_vector(to_unsigned(integer(10),4));
      else
         for j in  11 downto 8  loop
            if(wEn(28) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_LVDS_CTRL_LVDS_SER_FACTOR(j-8) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_LVDS_CTRL_LVDS_SER_FACTOR;

------------------------------------------------------------------------------------------
-- Field name: LVDS_CH(7 downto 4)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_LVDS_CTRL(7 downto 4) <= field_rw_ACQ_LVDS_CTRL_LVDS_CH(3 downto 0);
regfile.ACQ.LVDS_CTRL.LVDS_CH <= field_rw_ACQ_LVDS_CTRL_LVDS_CH(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_LVDS_CTRL_LVDS_CH
------------------------------------------------------------------------------------------
P_ACQ_LVDS_CTRL_LVDS_CH : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_LVDS_CTRL_LVDS_CH <= std_logic_vector(to_unsigned(integer(4),4));
      else
         for j in  7 downto 4  loop
            if(wEn(28) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_LVDS_CTRL_LVDS_CH(j-4) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_LVDS_CTRL_LVDS_CH;

------------------------------------------------------------------------------------------
-- Field name: LVDS_START_CALIB
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_ACQ_LVDS_CTRL(1) <= '0';
regfile.ACQ.LVDS_CTRL.LVDS_START_CALIB <= field_wautoclr_ACQ_LVDS_CTRL_LVDS_START_CALIB;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_LVDS_CTRL_LVDS_START_CALIB
------------------------------------------------------------------------------------------
P_ACQ_LVDS_CTRL_LVDS_START_CALIB : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_ACQ_LVDS_CTRL_LVDS_START_CALIB <= '0';
      else
         if(wEn(28) = '1' and bitEnN(1) = '0') then
            field_wautoclr_ACQ_LVDS_CTRL_LVDS_START_CALIB <= reg_writedata(1);
         else
            field_wautoclr_ACQ_LVDS_CTRL_LVDS_START_CALIB <= '0';
         end if;
      end if;
   end if;
end process P_ACQ_LVDS_CTRL_LVDS_START_CALIB;

------------------------------------------------------------------------------------------
-- Field name: LVDS_SYS_RESET
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_LVDS_CTRL(0) <= field_rw_ACQ_LVDS_CTRL_LVDS_SYS_RESET;
regfile.ACQ.LVDS_CTRL.LVDS_SYS_RESET <= field_rw_ACQ_LVDS_CTRL_LVDS_SYS_RESET;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_LVDS_CTRL_LVDS_SYS_RESET
------------------------------------------------------------------------------------------
P_ACQ_LVDS_CTRL_LVDS_SYS_RESET : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_LVDS_CTRL_LVDS_SYS_RESET <= '1';
      else
         if(wEn(28) = '1' and bitEnN(0) = '0') then
            field_rw_ACQ_LVDS_CTRL_LVDS_SYS_RESET <= reg_writedata(0);
         end if;
      end if;
   end if;
end process P_ACQ_LVDS_CTRL_LVDS_SYS_RESET;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_LVDS_CTRL2
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(29) <= (hit(29)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: REMAP_MODE_SUPP(7 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_LVDS_CTRL2(23 downto 16) <= regfile.ACQ.LVDS_CTRL2.REMAP_MODE_SUPP;


------------------------------------------------------------------------------------------
-- Field name: LVDS_DECOD_EN
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_LVDS_CTRL2(4) <= field_rw_ACQ_LVDS_CTRL2_LVDS_DECOD_EN;
regfile.ACQ.LVDS_CTRL2.LVDS_DECOD_EN <= field_rw_ACQ_LVDS_CTRL2_LVDS_DECOD_EN;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_LVDS_CTRL2_LVDS_DECOD_EN
------------------------------------------------------------------------------------------
P_ACQ_LVDS_CTRL2_LVDS_DECOD_EN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_LVDS_CTRL2_LVDS_DECOD_EN <= '0';
      else
         if(wEn(29) = '1' and bitEnN(4) = '0') then
            field_rw_ACQ_LVDS_CTRL2_LVDS_DECOD_EN <= reg_writedata(4);
         end if;
      end if;
   end if;
end process P_ACQ_LVDS_CTRL2_LVDS_DECOD_EN;

------------------------------------------------------------------------------------------
-- Field name: LVDS_DECOD_REMAP_MODE(2 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_LVDS_CTRL2(2 downto 0) <= field_rw_ACQ_LVDS_CTRL2_LVDS_DECOD_REMAP_MODE(2 downto 0);
regfile.ACQ.LVDS_CTRL2.LVDS_DECOD_REMAP_MODE <= field_rw_ACQ_LVDS_CTRL2_LVDS_DECOD_REMAP_MODE(2 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_LVDS_CTRL2_LVDS_DECOD_REMAP_MODE
------------------------------------------------------------------------------------------
P_ACQ_LVDS_CTRL2_LVDS_DECOD_REMAP_MODE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_LVDS_CTRL2_LVDS_DECOD_REMAP_MODE <= std_logic_vector(to_unsigned(integer(0),3));
      else
         for j in  2 downto 0  loop
            if(wEn(29) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_LVDS_CTRL2_LVDS_DECOD_REMAP_MODE(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_LVDS_CTRL2_LVDS_DECOD_REMAP_MODE;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_LVDS_TRAINING
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(30) <= (hit(30)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: DATA_TRAINING(25 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_LVDS_TRAINING(25 downto 16) <= field_rw_ACQ_LVDS_TRAINING_DATA_TRAINING(9 downto 0);
regfile.ACQ.LVDS_TRAINING.DATA_TRAINING <= field_rw_ACQ_LVDS_TRAINING_DATA_TRAINING(9 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_LVDS_TRAINING_DATA_TRAINING
------------------------------------------------------------------------------------------
P_ACQ_LVDS_TRAINING_DATA_TRAINING : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_LVDS_TRAINING_DATA_TRAINING <= std_logic_vector(to_unsigned(integer(934),10));
      else
         for j in  25 downto 16  loop
            if(wEn(30) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_LVDS_TRAINING_DATA_TRAINING(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_LVDS_TRAINING_DATA_TRAINING;

------------------------------------------------------------------------------------------
-- Field name: CRTL_TRAINING(9 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_LVDS_TRAINING(9 downto 0) <= field_rw_ACQ_LVDS_TRAINING_CRTL_TRAINING(9 downto 0);
regfile.ACQ.LVDS_TRAINING.CRTL_TRAINING <= field_rw_ACQ_LVDS_TRAINING_CRTL_TRAINING(9 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_LVDS_TRAINING_CRTL_TRAINING
------------------------------------------------------------------------------------------
P_ACQ_LVDS_TRAINING_CRTL_TRAINING : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_LVDS_TRAINING_CRTL_TRAINING <= std_logic_vector(to_unsigned(integer(934),10));
      else
         for j in  9 downto 0  loop
            if(wEn(30) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_LVDS_TRAINING_CRTL_TRAINING(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_LVDS_TRAINING_CRTL_TRAINING;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_LVDS_STAT
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(31) <= (hit(31)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: IDELAY_RDY
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_LVDS_STAT(29) <= regfile.ACQ.LVDS_STAT.IDELAY_RDY;


------------------------------------------------------------------------------------------
-- Field name: LVDS_RDY
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_LVDS_STAT(28) <= regfile.ACQ.LVDS_STAT.LVDS_RDY;


------------------------------------------------------------------------------------------
-- Field name: LVDS_CALIB_OK
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_LVDS_STAT(25) <= regfile.ACQ.LVDS_STAT.LVDS_CALIB_OK;


------------------------------------------------------------------------------------------
-- Field name: LVDS_CALIB_ACT
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_LVDS_STAT(24) <= regfile.ACQ.LVDS_STAT.LVDS_CALIB_ACT;


------------------------------------------------------------------------------------------
-- Field name: BS_DONE_STAT
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_LVDS_STAT(21) <= regfile.ACQ.LVDS_STAT.BS_DONE_STAT;


------------------------------------------------------------------------------------------
-- Field name: BS_CH_LOCK_STAT(8 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_LVDS_STAT(20 downto 12) <= regfile.ACQ.LVDS_STAT.BS_CH_LOCK_STAT;


------------------------------------------------------------------------------------------
-- Field name: PD_DONE_STAT
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_LVDS_STAT(9) <= regfile.ACQ.LVDS_STAT.PD_DONE_STAT;


------------------------------------------------------------------------------------------
-- Field name: PD_CH_LOCK_STAT(8 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_LVDS_STAT(8 downto 0) <= regfile.ACQ.LVDS_STAT.PD_CH_LOCK_STAT;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_LVDS_STAT2
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(32) <= (hit(32)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: WORD_ALIGN(31 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_LVDS_STAT2(31 downto 0) <= regfile.ACQ.LVDS_STAT2.WORD_ALIGN;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_SENSOR_CTRL
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(33) <= (hit(33)) and (reg_write);

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
         if(wEn(33) = '1' and bitEnN(24) = '0') then
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
         if(wEn(33) = '1' and bitEnN(16) = '0') then
            field_wautoclr_ACQ_SENSOR_CTRL_SENSOR_POWERDOWN <= reg_writedata(16);
         else
            field_wautoclr_ACQ_SENSOR_CTRL_SENSOR_POWERDOWN <= '0';
         end if;
      end if;
   end if;
end process P_ACQ_SENSOR_CTRL_SENSOR_POWERDOWN;

------------------------------------------------------------------------------------------
-- Field name: SENSOR_REMAP_CFG(13 downto 12)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_CTRL(13 downto 12) <= field_rw_ACQ_SENSOR_CTRL_SENSOR_REMAP_CFG(1 downto 0);
regfile.ACQ.SENSOR_CTRL.SENSOR_REMAP_CFG <= field_rw_ACQ_SENSOR_CTRL_SENSOR_REMAP_CFG(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_CTRL_SENSOR_REMAP_CFG
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_CTRL_SENSOR_REMAP_CFG : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_CTRL_SENSOR_REMAP_CFG <= std_logic_vector(to_unsigned(integer(1),2));
      else
         for j in  13 downto 12  loop
            if(wEn(33) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_CTRL_SENSOR_REMAP_CFG(j-12) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_CTRL_SENSOR_REMAP_CFG;

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
         if(wEn(33) = '1' and bitEnN(8) = '0') then
            field_rw_ACQ_SENSOR_CTRL_SENSOR_COLOR <= reg_writedata(8);
         end if;
      end if;
   end if;
end process P_ACQ_SENSOR_CTRL_SENSOR_COLOR;

------------------------------------------------------------------------------------------
-- Field name: SENSOR_REG_UPTATE
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_CTRL(4) <= field_rw_ACQ_SENSOR_CTRL_SENSOR_REG_UPTATE;
regfile.ACQ.SENSOR_CTRL.SENSOR_REG_UPTATE <= field_rw_ACQ_SENSOR_CTRL_SENSOR_REG_UPTATE;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_CTRL_SENSOR_REG_UPTATE
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_CTRL_SENSOR_REG_UPTATE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_CTRL_SENSOR_REG_UPTATE <= '1';
      else
         if(wEn(33) = '1' and bitEnN(4) = '0') then
            field_rw_ACQ_SENSOR_CTRL_SENSOR_REG_UPTATE <= reg_writedata(4);
         end if;
      end if;
   end if;
end process P_ACQ_SENSOR_CTRL_SENSOR_REG_UPTATE;

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
         if(wEn(33) = '1' and bitEnN(1) = '0') then
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
         if(wEn(33) = '1' and bitEnN(0) = '0') then
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
wEn(34) <= (hit(34)) and (reg_write);

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
-- Field name: SENSOR_VCCPIX_PG
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_STAT(10) <= regfile.ACQ.SENSOR_STAT.SENSOR_VCCPIX_PG;


------------------------------------------------------------------------------------------
-- Field name: SENSOR_VCC33_PG
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_STAT(9) <= regfile.ACQ.SENSOR_STAT.SENSOR_VCC33_PG;


------------------------------------------------------------------------------------------
-- Field name: SENSOR_VCC18_PG
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_STAT(8) <= regfile.ACQ.SENSOR_STAT.SENSOR_VCC18_PG;


------------------------------------------------------------------------------------------
-- Field name: SENSOR_VCCPIX_EN
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_STAT(6) <= regfile.ACQ.SENSOR_STAT.SENSOR_VCCPIX_EN;


------------------------------------------------------------------------------------------
-- Field name: SENSOR_VCC33_EN
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_STAT(5) <= regfile.ACQ.SENSOR_STAT.SENSOR_VCC33_EN;


------------------------------------------------------------------------------------------
-- Field name: SENSOR_VCC18_EN
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_STAT(4) <= regfile.ACQ.SENSOR_STAT.SENSOR_VCC18_EN;


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
-- Register name: ACQ_SENSOR_GEN_CFG
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(35) <= (hit(35)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: reserved_1(15 downto 9)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_GEN_CFG(15 downto 9) <= field_rw_ACQ_SENSOR_GEN_CFG_reserved_1(6 downto 0);
regfile.ACQ.SENSOR_GEN_CFG.reserved_1 <= field_rw_ACQ_SENSOR_GEN_CFG_reserved_1(6 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_GEN_CFG_reserved_1
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_GEN_CFG_reserved_1 : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_GEN_CFG_reserved_1 <= std_logic_vector(to_unsigned(integer(4),7));
      else
         for j in  15 downto 9  loop
            if(wEn(35) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_GEN_CFG_reserved_1(j-9) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_GEN_CFG_reserved_1;

------------------------------------------------------------------------------------------
-- Field name: BINNING
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_GEN_CFG(8) <= field_rw_ACQ_SENSOR_GEN_CFG_BINNING;
regfile.ACQ.SENSOR_GEN_CFG.BINNING <= field_rw_ACQ_SENSOR_GEN_CFG_BINNING;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_GEN_CFG_BINNING
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_GEN_CFG_BINNING : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_GEN_CFG_BINNING <= '0';
      else
         if(wEn(35) = '1' and bitEnN(8) = '0') then
            field_rw_ACQ_SENSOR_GEN_CFG_BINNING <= reg_writedata(8);
         end if;
      end if;
   end if;
end process P_ACQ_SENSOR_GEN_CFG_BINNING;

------------------------------------------------------------------------------------------
-- Field name: SUBSAMPLING
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_GEN_CFG(7) <= field_rw_ACQ_SENSOR_GEN_CFG_SUBSAMPLING;
regfile.ACQ.SENSOR_GEN_CFG.SUBSAMPLING <= field_rw_ACQ_SENSOR_GEN_CFG_SUBSAMPLING;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_GEN_CFG_SUBSAMPLING
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_GEN_CFG_SUBSAMPLING : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_GEN_CFG_SUBSAMPLING <= '0';
      else
         if(wEn(35) = '1' and bitEnN(7) = '0') then
            field_rw_ACQ_SENSOR_GEN_CFG_SUBSAMPLING <= reg_writedata(7);
         end if;
      end if;
   end if;
end process P_ACQ_SENSOR_GEN_CFG_SUBSAMPLING;

------------------------------------------------------------------------------------------
-- Field name: NZROT_XSM_DELAY_ENABLE
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_GEN_CFG(6) <= field_rw_ACQ_SENSOR_GEN_CFG_NZROT_XSM_DELAY_ENABLE;
regfile.ACQ.SENSOR_GEN_CFG.NZROT_XSM_DELAY_ENABLE <= field_rw_ACQ_SENSOR_GEN_CFG_NZROT_XSM_DELAY_ENABLE;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_GEN_CFG_NZROT_XSM_DELAY_ENABLE
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_GEN_CFG_NZROT_XSM_DELAY_ENABLE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_GEN_CFG_NZROT_XSM_DELAY_ENABLE <= '0';
      else
         if(wEn(35) = '1' and bitEnN(6) = '0') then
            field_rw_ACQ_SENSOR_GEN_CFG_NZROT_XSM_DELAY_ENABLE <= reg_writedata(6);
         end if;
      end if;
   end if;
end process P_ACQ_SENSOR_GEN_CFG_NZROT_XSM_DELAY_ENABLE;

------------------------------------------------------------------------------------------
-- Field name: SLAVE_MODE
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_GEN_CFG(5) <= field_rw_ACQ_SENSOR_GEN_CFG_SLAVE_MODE;
regfile.ACQ.SENSOR_GEN_CFG.SLAVE_MODE <= field_rw_ACQ_SENSOR_GEN_CFG_SLAVE_MODE;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_GEN_CFG_SLAVE_MODE
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_GEN_CFG_SLAVE_MODE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_GEN_CFG_SLAVE_MODE <= '1';
      else
         if(wEn(35) = '1' and bitEnN(5) = '0') then
            field_rw_ACQ_SENSOR_GEN_CFG_SLAVE_MODE <= reg_writedata(5);
         end if;
      end if;
   end if;
end process P_ACQ_SENSOR_GEN_CFG_SLAVE_MODE;

------------------------------------------------------------------------------------------
-- Field name: TRIGGERED_MODE
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_GEN_CFG(4) <= field_rw_ACQ_SENSOR_GEN_CFG_TRIGGERED_MODE;
regfile.ACQ.SENSOR_GEN_CFG.TRIGGERED_MODE <= field_rw_ACQ_SENSOR_GEN_CFG_TRIGGERED_MODE;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_GEN_CFG_TRIGGERED_MODE
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_GEN_CFG_TRIGGERED_MODE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_GEN_CFG_TRIGGERED_MODE <= '1';
      else
         if(wEn(35) = '1' and bitEnN(4) = '0') then
            field_rw_ACQ_SENSOR_GEN_CFG_TRIGGERED_MODE <= reg_writedata(4);
         end if;
      end if;
   end if;
end process P_ACQ_SENSOR_GEN_CFG_TRIGGERED_MODE;

------------------------------------------------------------------------------------------
-- Field name: XLAG_ENABLE
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_GEN_CFG(3) <= field_rw_ACQ_SENSOR_GEN_CFG_XLAG_ENABLE;
regfile.ACQ.SENSOR_GEN_CFG.XLAG_ENABLE <= field_rw_ACQ_SENSOR_GEN_CFG_XLAG_ENABLE;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_GEN_CFG_XLAG_ENABLE
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_GEN_CFG_XLAG_ENABLE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_GEN_CFG_XLAG_ENABLE <= '0';
      else
         if(wEn(35) = '1' and bitEnN(3) = '0') then
            field_rw_ACQ_SENSOR_GEN_CFG_XLAG_ENABLE <= reg_writedata(3);
         end if;
      end if;
   end if;
end process P_ACQ_SENSOR_GEN_CFG_XLAG_ENABLE;

------------------------------------------------------------------------------------------
-- Field name: ZERO_ROT_ENABLE
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_GEN_CFG(2) <= field_rw_ACQ_SENSOR_GEN_CFG_ZERO_ROT_ENABLE;
regfile.ACQ.SENSOR_GEN_CFG.ZERO_ROT_ENABLE <= field_rw_ACQ_SENSOR_GEN_CFG_ZERO_ROT_ENABLE;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_GEN_CFG_ZERO_ROT_ENABLE
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_GEN_CFG_ZERO_ROT_ENABLE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_GEN_CFG_ZERO_ROT_ENABLE <= '0';
      else
         if(wEn(35) = '1' and bitEnN(2) = '0') then
            field_rw_ACQ_SENSOR_GEN_CFG_ZERO_ROT_ENABLE <= reg_writedata(2);
         end if;
      end if;
   end if;
end process P_ACQ_SENSOR_GEN_CFG_ZERO_ROT_ENABLE;

------------------------------------------------------------------------------------------
-- Field name: ROLLING_SHUTTER
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_GEN_CFG(1) <= field_rw_ACQ_SENSOR_GEN_CFG_ROLLING_SHUTTER;
regfile.ACQ.SENSOR_GEN_CFG.ROLLING_SHUTTER <= field_rw_ACQ_SENSOR_GEN_CFG_ROLLING_SHUTTER;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_GEN_CFG_ROLLING_SHUTTER
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_GEN_CFG_ROLLING_SHUTTER : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_GEN_CFG_ROLLING_SHUTTER <= '0';
      else
         if(wEn(35) = '1' and bitEnN(1) = '0') then
            field_rw_ACQ_SENSOR_GEN_CFG_ROLLING_SHUTTER <= reg_writedata(1);
         end if;
      end if;
   end if;
end process P_ACQ_SENSOR_GEN_CFG_ROLLING_SHUTTER;

------------------------------------------------------------------------------------------
-- Field name: ENABLE
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_GEN_CFG(0) <= field_rw_ACQ_SENSOR_GEN_CFG_ENABLE;
regfile.ACQ.SENSOR_GEN_CFG.ENABLE <= field_rw_ACQ_SENSOR_GEN_CFG_ENABLE;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_GEN_CFG_ENABLE
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_GEN_CFG_ENABLE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_GEN_CFG_ENABLE <= '1';
      else
         if(wEn(35) = '1' and bitEnN(0) = '0') then
            field_rw_ACQ_SENSOR_GEN_CFG_ENABLE <= reg_writedata(0);
         end if;
      end if;
   end if;
end process P_ACQ_SENSOR_GEN_CFG_ENABLE;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_SENSOR_INT_CTL
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(36) <= (hit(36)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: reserved_2(15 downto 14)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_INT_CTL(15 downto 14) <= field_rw_ACQ_SENSOR_INT_CTL_reserved_2(1 downto 0);
regfile.ACQ.SENSOR_INT_CTL.reserved_2 <= field_rw_ACQ_SENSOR_INT_CTL_reserved_2(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_INT_CTL_reserved_2
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_INT_CTL_reserved_2 : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_INT_CTL_reserved_2 <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  15 downto 14  loop
            if(wEn(36) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_INT_CTL_reserved_2(j-14) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_INT_CTL_reserved_2;

------------------------------------------------------------------------------------------
-- Field name: BINNING_MODE(13 downto 12)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_INT_CTL(13 downto 12) <= field_rw_ACQ_SENSOR_INT_CTL_BINNING_MODE(1 downto 0);
regfile.ACQ.SENSOR_INT_CTL.BINNING_MODE <= field_rw_ACQ_SENSOR_INT_CTL_BINNING_MODE(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_INT_CTL_BINNING_MODE
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_INT_CTL_BINNING_MODE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_INT_CTL_BINNING_MODE <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  13 downto 12  loop
            if(wEn(36) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_INT_CTL_BINNING_MODE(j-12) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_INT_CTL_BINNING_MODE;

------------------------------------------------------------------------------------------
-- Field name: SUBSAMPLING_MODE(11 downto 10)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_INT_CTL(11 downto 10) <= field_rw_ACQ_SENSOR_INT_CTL_SUBSAMPLING_MODE(1 downto 0);
regfile.ACQ.SENSOR_INT_CTL.SUBSAMPLING_MODE <= field_rw_ACQ_SENSOR_INT_CTL_SUBSAMPLING_MODE(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_INT_CTL_SUBSAMPLING_MODE
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_INT_CTL_SUBSAMPLING_MODE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_INT_CTL_SUBSAMPLING_MODE <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  11 downto 10  loop
            if(wEn(36) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_INT_CTL_SUBSAMPLING_MODE(j-10) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_INT_CTL_SUBSAMPLING_MODE;

------------------------------------------------------------------------------------------
-- Field name: reserved1
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_INT_CTL(9) <= field_rw_ACQ_SENSOR_INT_CTL_reserved1;
regfile.ACQ.SENSOR_INT_CTL.reserved1 <= field_rw_ACQ_SENSOR_INT_CTL_reserved1;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_INT_CTL_reserved1
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_INT_CTL_reserved1 : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_INT_CTL_reserved1 <= '0';
      else
         if(wEn(36) = '1' and bitEnN(9) = '0') then
            field_rw_ACQ_SENSOR_INT_CTL_reserved1 <= reg_writedata(9);
         end if;
      end if;
   end if;
end process P_ACQ_SENSOR_INT_CTL_reserved1;

------------------------------------------------------------------------------------------
-- Field name: reserved0(7 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_INT_CTL(7 downto 0) <= field_rw_ACQ_SENSOR_INT_CTL_reserved0(7 downto 0);
regfile.ACQ.SENSOR_INT_CTL.reserved0 <= field_rw_ACQ_SENSOR_INT_CTL_reserved0(7 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_INT_CTL_reserved0
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_INT_CTL_reserved0 : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_INT_CTL_reserved0 <= std_logic_vector(to_unsigned(integer(0),8));
      else
         for j in  7 downto 0  loop
            if(wEn(36) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_INT_CTL_reserved0(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_INT_CTL_reserved0;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_SENSOR_GAIN_ANA
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(37) <= (hit(37)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: reserved(15 downto 13)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_GAIN_ANA(15 downto 13) <= field_rw_ACQ_SENSOR_GAIN_ANA_reserved(2 downto 0);
regfile.ACQ.SENSOR_GAIN_ANA.reserved <= field_rw_ACQ_SENSOR_GAIN_ANA_reserved(2 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_GAIN_ANA_reserved
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_GAIN_ANA_reserved : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_GAIN_ANA_reserved <= std_logic_vector(to_unsigned(integer(0),3));
      else
         for j in  15 downto 13  loop
            if(wEn(37) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_GAIN_ANA_reserved(j-13) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_GAIN_ANA_reserved;

------------------------------------------------------------------------------------------
-- Field name: AFE_GAIN0(12 downto 5)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_GAIN_ANA(12 downto 5) <= field_rw_ACQ_SENSOR_GAIN_ANA_AFE_GAIN0(7 downto 0);
regfile.ACQ.SENSOR_GAIN_ANA.AFE_GAIN0 <= field_rw_ACQ_SENSOR_GAIN_ANA_AFE_GAIN0(7 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_GAIN_ANA_AFE_GAIN0
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_GAIN_ANA_AFE_GAIN0 : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_GAIN_ANA_AFE_GAIN0 <= std_logic_vector(to_unsigned(integer(15),8));
      else
         for j in  12 downto 5  loop
            if(wEn(37) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_GAIN_ANA_AFE_GAIN0(j-5) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_GAIN_ANA_AFE_GAIN0;

------------------------------------------------------------------------------------------
-- Field name: MUX_GAINSW0(4 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_GAIN_ANA(4 downto 0) <= field_rw_ACQ_SENSOR_GAIN_ANA_MUX_GAINSW0(4 downto 0);
regfile.ACQ.SENSOR_GAIN_ANA.MUX_GAINSW0 <= field_rw_ACQ_SENSOR_GAIN_ANA_MUX_GAINSW0(4 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_GAIN_ANA_MUX_GAINSW0
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_GAIN_ANA_MUX_GAINSW0 : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_GAIN_ANA_MUX_GAINSW0 <= std_logic_vector(to_unsigned(integer(3),5));
      else
         for j in  4 downto 0  loop
            if(wEn(37) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_GAIN_ANA_MUX_GAINSW0(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_GAIN_ANA_MUX_GAINSW0;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_SENSOR_BLACK_CAL
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(38) <= (hit(38)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: CRC_SEED
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_BLACK_CAL(15) <= field_rw_ACQ_SENSOR_BLACK_CAL_CRC_SEED;
regfile.ACQ.SENSOR_BLACK_CAL.CRC_SEED <= field_rw_ACQ_SENSOR_BLACK_CAL_CRC_SEED;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_BLACK_CAL_CRC_SEED
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_BLACK_CAL_CRC_SEED : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_BLACK_CAL_CRC_SEED <= '0';
      else
         if(wEn(38) = '1' and bitEnN(15) = '0') then
            field_rw_ACQ_SENSOR_BLACK_CAL_CRC_SEED <= reg_writedata(15);
         end if;
      end if;
   end if;
end process P_ACQ_SENSOR_BLACK_CAL_CRC_SEED;

------------------------------------------------------------------------------------------
-- Field name: reserved(14 downto 11)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_BLACK_CAL(14 downto 11) <= field_rw_ACQ_SENSOR_BLACK_CAL_reserved(3 downto 0);
regfile.ACQ.SENSOR_BLACK_CAL.reserved <= field_rw_ACQ_SENSOR_BLACK_CAL_reserved(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_BLACK_CAL_reserved
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_BLACK_CAL_reserved : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_BLACK_CAL_reserved <= std_logic_vector(to_unsigned(integer(8),4));
      else
         for j in  14 downto 11  loop
            if(wEn(38) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_BLACK_CAL_reserved(j-11) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_BLACK_CAL_reserved;

------------------------------------------------------------------------------------------
-- Field name: BLACK_SAMPLES
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_BLACK_CAL(10 downto 8) <= std_logic_vector(to_unsigned(integer(7),3));
regfile.ACQ.SENSOR_BLACK_CAL.BLACK_SAMPLES <= rb_ACQ_SENSOR_BLACK_CAL(10 downto 8);


------------------------------------------------------------------------------------------
-- Field name: BLACK_OFFSET(7 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_BLACK_CAL(7 downto 0) <= field_rw_ACQ_SENSOR_BLACK_CAL_BLACK_OFFSET(7 downto 0);
regfile.ACQ.SENSOR_BLACK_CAL.BLACK_OFFSET <= field_rw_ACQ_SENSOR_BLACK_CAL_BLACK_OFFSET(7 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_BLACK_CAL_BLACK_OFFSET
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_BLACK_CAL_BLACK_OFFSET : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_BLACK_CAL_BLACK_OFFSET <= std_logic_vector(to_unsigned(integer(15),8));
      else
         for j in  7 downto 0  loop
            if(wEn(38) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_BLACK_CAL_BLACK_OFFSET(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_BLACK_CAL_BLACK_OFFSET;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_SENSOR_ROI_CONF0
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(39) <= (hit(39)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: X_END_MSB
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_ROI_CONF0(24) <= field_rw_ACQ_SENSOR_ROI_CONF0_X_END_MSB;
regfile.ACQ.SENSOR_ROI_CONF0.X_END_MSB <= field_rw_ACQ_SENSOR_ROI_CONF0_X_END_MSB;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_ROI_CONF0_X_END_MSB
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_ROI_CONF0_X_END_MSB : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_ROI_CONF0_X_END_MSB <= '1';
      else
         if(wEn(39) = '1' and bitEnN(24) = '0') then
            field_rw_ACQ_SENSOR_ROI_CONF0_X_END_MSB <= reg_writedata(24);
         end if;
      end if;
   end if;
end process P_ACQ_SENSOR_ROI_CONF0_X_END_MSB;

------------------------------------------------------------------------------------------
-- Field name: X_START_MSB
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_ROI_CONF0(16) <= field_rw_ACQ_SENSOR_ROI_CONF0_X_START_MSB;
regfile.ACQ.SENSOR_ROI_CONF0.X_START_MSB <= field_rw_ACQ_SENSOR_ROI_CONF0_X_START_MSB;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_ROI_CONF0_X_START_MSB
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_ROI_CONF0_X_START_MSB : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_ROI_CONF0_X_START_MSB <= '0';
      else
         if(wEn(39) = '1' and bitEnN(16) = '0') then
            field_rw_ACQ_SENSOR_ROI_CONF0_X_START_MSB <= reg_writedata(16);
         end if;
      end if;
   end if;
end process P_ACQ_SENSOR_ROI_CONF0_X_START_MSB;

------------------------------------------------------------------------------------------
-- Field name: X_END(15 downto 8)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_ROI_CONF0(15 downto 8) <= field_rw_ACQ_SENSOR_ROI_CONF0_X_END(7 downto 0);
regfile.ACQ.SENSOR_ROI_CONF0.X_END <= field_rw_ACQ_SENSOR_ROI_CONF0_X_END(7 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_ROI_CONF0_X_END
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_ROI_CONF0_X_END : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_ROI_CONF0_X_END <= std_logic_vector(to_unsigned(integer(159),8));
      else
         for j in  15 downto 8  loop
            if(wEn(39) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_ROI_CONF0_X_END(j-8) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_ROI_CONF0_X_END;

------------------------------------------------------------------------------------------
-- Field name: X_START(7 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_ROI_CONF0(7 downto 0) <= field_rw_ACQ_SENSOR_ROI_CONF0_X_START(7 downto 0);
regfile.ACQ.SENSOR_ROI_CONF0.X_START <= field_rw_ACQ_SENSOR_ROI_CONF0_X_START(7 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_ROI_CONF0_X_START
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_ROI_CONF0_X_START : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_ROI_CONF0_X_START <= std_logic_vector(to_unsigned(integer(0),8));
      else
         for j in  7 downto 0  loop
            if(wEn(39) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_ROI_CONF0_X_START(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_ROI_CONF0_X_START;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_SENSOR_ROI2_CONF0
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(40) <= (hit(40)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: X_END_MSB
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_ROI2_CONF0(24) <= field_rw_ACQ_SENSOR_ROI2_CONF0_X_END_MSB;
regfile.ACQ.SENSOR_ROI2_CONF0.X_END_MSB <= field_rw_ACQ_SENSOR_ROI2_CONF0_X_END_MSB;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_ROI2_CONF0_X_END_MSB
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_ROI2_CONF0_X_END_MSB : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_ROI2_CONF0_X_END_MSB <= '1';
      else
         if(wEn(40) = '1' and bitEnN(24) = '0') then
            field_rw_ACQ_SENSOR_ROI2_CONF0_X_END_MSB <= reg_writedata(24);
         end if;
      end if;
   end if;
end process P_ACQ_SENSOR_ROI2_CONF0_X_END_MSB;

------------------------------------------------------------------------------------------
-- Field name: X_START_MSB
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_ROI2_CONF0(16) <= field_rw_ACQ_SENSOR_ROI2_CONF0_X_START_MSB;
regfile.ACQ.SENSOR_ROI2_CONF0.X_START_MSB <= field_rw_ACQ_SENSOR_ROI2_CONF0_X_START_MSB;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_ROI2_CONF0_X_START_MSB
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_ROI2_CONF0_X_START_MSB : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_ROI2_CONF0_X_START_MSB <= '0';
      else
         if(wEn(40) = '1' and bitEnN(16) = '0') then
            field_rw_ACQ_SENSOR_ROI2_CONF0_X_START_MSB <= reg_writedata(16);
         end if;
      end if;
   end if;
end process P_ACQ_SENSOR_ROI2_CONF0_X_START_MSB;

------------------------------------------------------------------------------------------
-- Field name: X_END(15 downto 8)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_ROI2_CONF0(15 downto 8) <= field_rw_ACQ_SENSOR_ROI2_CONF0_X_END(7 downto 0);
regfile.ACQ.SENSOR_ROI2_CONF0.X_END <= field_rw_ACQ_SENSOR_ROI2_CONF0_X_END(7 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_ROI2_CONF0_X_END
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_ROI2_CONF0_X_END : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_ROI2_CONF0_X_END <= std_logic_vector(to_unsigned(integer(159),8));
      else
         for j in  15 downto 8  loop
            if(wEn(40) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_ROI2_CONF0_X_END(j-8) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_ROI2_CONF0_X_END;

------------------------------------------------------------------------------------------
-- Field name: X_START(7 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_ROI2_CONF0(7 downto 0) <= field_rw_ACQ_SENSOR_ROI2_CONF0_X_START(7 downto 0);
regfile.ACQ.SENSOR_ROI2_CONF0.X_START <= field_rw_ACQ_SENSOR_ROI2_CONF0_X_START(7 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_ROI2_CONF0_X_START
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_ROI2_CONF0_X_START : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_ROI2_CONF0_X_START <= std_logic_vector(to_unsigned(integer(0),8));
      else
         for j in  7 downto 0  loop
            if(wEn(40) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_ROI2_CONF0_X_START(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_ROI2_CONF0_X_START;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_SENSOR_ROI_CONF1
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(41) <= (hit(41)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: reserved
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_ROI_CONF1(15 downto 13) <= std_logic_vector(to_unsigned(integer(0),3));
regfile.ACQ.SENSOR_ROI_CONF1.reserved <= rb_ACQ_SENSOR_ROI_CONF1(15 downto 13);


------------------------------------------------------------------------------------------
-- Field name: Y_START(12 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_ROI_CONF1(12 downto 0) <= field_rw_ACQ_SENSOR_ROI_CONF1_Y_START(12 downto 0);
regfile.ACQ.SENSOR_ROI_CONF1.Y_START <= field_rw_ACQ_SENSOR_ROI_CONF1_Y_START(12 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_ROI_CONF1_Y_START
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_ROI_CONF1_Y_START : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_ROI_CONF1_Y_START <= std_logic_vector(to_unsigned(integer(0),13));
      else
         for j in  12 downto 0  loop
            if(wEn(41) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_ROI_CONF1_Y_START(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_ROI_CONF1_Y_START;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_SENSOR_ROI2_CONF1
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(42) <= (hit(42)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: reserved
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_ROI2_CONF1(15 downto 13) <= std_logic_vector(to_unsigned(integer(0),3));
regfile.ACQ.SENSOR_ROI2_CONF1.reserved <= rb_ACQ_SENSOR_ROI2_CONF1(15 downto 13);


------------------------------------------------------------------------------------------
-- Field name: Y_START(12 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_ROI2_CONF1(12 downto 0) <= field_rw_ACQ_SENSOR_ROI2_CONF1_Y_START(12 downto 0);
regfile.ACQ.SENSOR_ROI2_CONF1.Y_START <= field_rw_ACQ_SENSOR_ROI2_CONF1_Y_START(12 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_ROI2_CONF1_Y_START
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_ROI2_CONF1_Y_START : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_ROI2_CONF1_Y_START <= std_logic_vector(to_unsigned(integer(0),13));
      else
         for j in  12 downto 0  loop
            if(wEn(42) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_ROI2_CONF1_Y_START(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_ROI2_CONF1_Y_START;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_SENSOR_ROI_CONF2
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(43) <= (hit(43)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: reserved
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_ROI_CONF2(15 downto 13) <= std_logic_vector(to_unsigned(integer(0),3));
regfile.ACQ.SENSOR_ROI_CONF2.reserved <= rb_ACQ_SENSOR_ROI_CONF2(15 downto 13);


------------------------------------------------------------------------------------------
-- Field name: Y_END(12 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_ROI_CONF2(12 downto 0) <= field_rw_ACQ_SENSOR_ROI_CONF2_Y_END(12 downto 0);
regfile.ACQ.SENSOR_ROI_CONF2.Y_END <= field_rw_ACQ_SENSOR_ROI_CONF2_Y_END(12 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_ROI_CONF2_Y_END
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_ROI_CONF2_Y_END : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_ROI_CONF2_Y_END <= std_logic_vector(to_unsigned(integer(1023),13));
      else
         for j in  12 downto 0  loop
            if(wEn(43) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_ROI_CONF2_Y_END(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_ROI_CONF2_Y_END;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_SENSOR_ROI2_CONF2
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(44) <= (hit(44)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: reserved
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_ROI2_CONF2(15 downto 13) <= std_logic_vector(to_unsigned(integer(0),3));
regfile.ACQ.SENSOR_ROI2_CONF2.reserved <= rb_ACQ_SENSOR_ROI2_CONF2(15 downto 13);


------------------------------------------------------------------------------------------
-- Field name: Y_END(12 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_ROI2_CONF2(12 downto 0) <= field_rw_ACQ_SENSOR_ROI2_CONF2_Y_END(12 downto 0);
regfile.ACQ.SENSOR_ROI2_CONF2.Y_END <= field_rw_ACQ_SENSOR_ROI2_CONF2_Y_END(12 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_ROI2_CONF2_Y_END
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_ROI2_CONF2_Y_END : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_ROI2_CONF2_Y_END <= std_logic_vector(to_unsigned(integer(1023),13));
      else
         for j in  12 downto 0  loop
            if(wEn(44) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_ROI2_CONF2_Y_END(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_ROI2_CONF2_Y_END;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_CRC
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(45) <= (hit(45)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: CRC_InitValue
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_CRC(18) <= field_rw_ACQ_CRC_CRC_InitValue;
regfile.ACQ.CRC.CRC_InitValue <= field_rw_ACQ_CRC_CRC_InitValue;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_CRC_CRC_InitValue
------------------------------------------------------------------------------------------
P_ACQ_CRC_CRC_InitValue : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_CRC_CRC_InitValue <= '0';
      else
         if(wEn(45) = '1' and bitEnN(18) = '0') then
            field_rw_ACQ_CRC_CRC_InitValue <= reg_writedata(18);
         end if;
      end if;
   end if;
end process P_ACQ_CRC_CRC_InitValue;

------------------------------------------------------------------------------------------
-- Field name: CRC_Reset
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_ACQ_CRC(17) <= '0';
regfile.ACQ.CRC.CRC_Reset <= field_wautoclr_ACQ_CRC_CRC_Reset;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_CRC_CRC_Reset
------------------------------------------------------------------------------------------
P_ACQ_CRC_CRC_Reset : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_ACQ_CRC_CRC_Reset <= '0';
      else
         if(wEn(45) = '1' and bitEnN(17) = '0') then
            field_wautoclr_ACQ_CRC_CRC_Reset <= reg_writedata(17);
         else
            field_wautoclr_ACQ_CRC_CRC_Reset <= '0';
         end if;
      end if;
   end if;
end process P_ACQ_CRC_CRC_Reset;

------------------------------------------------------------------------------------------
-- Field name: CRC_EN
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_CRC(16) <= field_rw_ACQ_CRC_CRC_EN;
regfile.ACQ.CRC.CRC_EN <= field_rw_ACQ_CRC_CRC_EN;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_CRC_CRC_EN
------------------------------------------------------------------------------------------
P_ACQ_CRC_CRC_EN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_CRC_CRC_EN <= '1';
      else
         if(wEn(45) = '1' and bitEnN(16) = '0') then
            field_rw_ACQ_CRC_CRC_EN <= reg_writedata(16);
         end if;
      end if;
   end if;
end process P_ACQ_CRC_CRC_EN;

------------------------------------------------------------------------------------------
-- Field name: CRC_STATUS(7 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_CRC(7 downto 0) <= regfile.ACQ.CRC.CRC_STATUS;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_DEBUG_PINS
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(46) <= (hit(46)) and (reg_write);

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
            if(wEn(46) = '1' and bitEnN(j) = '0') then
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
            if(wEn(46) = '1' and bitEnN(j) = '0') then
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
            if(wEn(46) = '1' and bitEnN(j) = '0') then
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
            if(wEn(46) = '1' and bitEnN(j) = '0') then
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
wEn(47) <= (hit(47)) and (reg_write);

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
         if(wEn(47) = '1' and bitEnN(28) = '0') then
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
wEn(48) <= (hit(48)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: SENSOR_FPS(15 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_FPS(15 downto 0) <= regfile.ACQ.SENSOR_FPS.SENSOR_FPS;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_DEBUG
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(49) <= (hit(49)) and (reg_write);

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
         if(wEn(49) = '1' and bitEnN(28) = '0') then
            field_rw_ACQ_DEBUG_DEBUG_RST_CNTR <= reg_writedata(28);
         end if;
      end if;
   end if;
end process P_ACQ_DEBUG_DEBUG_RST_CNTR;

------------------------------------------------------------------------------------------
-- Field name: TEST_MODE_PIX_START(25 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_DEBUG(25 downto 16) <= field_rw_ACQ_DEBUG_TEST_MODE_PIX_START(9 downto 0);
regfile.ACQ.DEBUG.TEST_MODE_PIX_START <= field_rw_ACQ_DEBUG_TEST_MODE_PIX_START(9 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_DEBUG_TEST_MODE_PIX_START
------------------------------------------------------------------------------------------
P_ACQ_DEBUG_TEST_MODE_PIX_START : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_DEBUG_TEST_MODE_PIX_START <= std_logic_vector(to_unsigned(integer(0),10));
      else
         for j in  25 downto 16  loop
            if(wEn(49) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_DEBUG_TEST_MODE_PIX_START(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_DEBUG_TEST_MODE_PIX_START;

------------------------------------------------------------------------------------------
-- Field name: TEST_MOVE
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_DEBUG(9) <= field_rw_ACQ_DEBUG_TEST_MOVE;
regfile.ACQ.DEBUG.TEST_MOVE <= field_rw_ACQ_DEBUG_TEST_MOVE;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_DEBUG_TEST_MOVE
------------------------------------------------------------------------------------------
P_ACQ_DEBUG_TEST_MOVE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_DEBUG_TEST_MOVE <= '0';
      else
         if(wEn(49) = '1' and bitEnN(9) = '0') then
            field_rw_ACQ_DEBUG_TEST_MOVE <= reg_writedata(9);
         end if;
      end if;
   end if;
end process P_ACQ_DEBUG_TEST_MOVE;

------------------------------------------------------------------------------------------
-- Field name: TEST_MODE
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_DEBUG(8) <= field_rw_ACQ_DEBUG_TEST_MODE;
regfile.ACQ.DEBUG.TEST_MODE <= field_rw_ACQ_DEBUG_TEST_MODE;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_DEBUG_TEST_MODE
------------------------------------------------------------------------------------------
P_ACQ_DEBUG_TEST_MODE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_DEBUG_TEST_MODE <= '0';
      else
         if(wEn(49) = '1' and bitEnN(8) = '0') then
            field_rw_ACQ_DEBUG_TEST_MODE <= reg_writedata(8);
         end if;
      end if;
   end if;
end process P_ACQ_DEBUG_TEST_MODE;

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
            if(wEn(49) = '1' and bitEnN(j) = '0') then
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
         if(wEn(49) = '1' and bitEnN(0) = '0') then
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
wEn(50) <= (hit(50)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: EOF_CNTR(31 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_DEBUG_CNTR1(31 downto 0) <= regfile.ACQ.DEBUG_CNTR1.EOF_CNTR;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_DEBUG_CNTR2
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(51) <= (hit(51)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: EOL_CNTR(11 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_DEBUG_CNTR2(11 downto 0) <= regfile.ACQ.DEBUG_CNTR2.EOL_CNTR;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_DEBUG_CNTR3
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(52) <= (hit(52)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: SENSOR_FRAME_DURATION(27 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_DEBUG_CNTR3(27 downto 0) <= regfile.ACQ.DEBUG_CNTR3.SENSOR_FRAME_DURATION;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_EXP_FOT
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(53) <= (hit(53)) and (reg_write);

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
         field_rw_ACQ_EXP_FOT_EXP_FOT <= '0';
      else
         if(wEn(53) = '1' and bitEnN(16) = '0') then
            field_rw_ACQ_EXP_FOT_EXP_FOT <= reg_writedata(16);
         end if;
      end if;
   end if;
end process P_ACQ_EXP_FOT_EXP_FOT;

------------------------------------------------------------------------------------------
-- Field name: EXP_FOT_TIME(11 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_EXP_FOT(11 downto 0) <= field_rw_ACQ_EXP_FOT_EXP_FOT_TIME(11 downto 0);
regfile.ACQ.EXP_FOT.EXP_FOT_TIME <= field_rw_ACQ_EXP_FOT_EXP_FOT_TIME(11 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_EXP_FOT_EXP_FOT_TIME
------------------------------------------------------------------------------------------
P_ACQ_EXP_FOT_EXP_FOT_TIME : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_EXP_FOT_EXP_FOT_TIME <= std_logic_vector(to_unsigned(integer(0),12));
      else
         for j in  11 downto 0  loop
            if(wEn(53) = '1' and bitEnN(j) = '0') then
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
wEn(54) <= (hit(54)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: RELOAD_GRAB_PARAMS
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_ACQ_ACQ_SFNC(0) <= '0';
regfile.ACQ.ACQ_SFNC.RELOAD_GRAB_PARAMS <= field_wautoclr_ACQ_ACQ_SFNC_RELOAD_GRAB_PARAMS;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_ACQ_SFNC_RELOAD_GRAB_PARAMS
------------------------------------------------------------------------------------------
P_ACQ_ACQ_SFNC_RELOAD_GRAB_PARAMS : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_ACQ_ACQ_SFNC_RELOAD_GRAB_PARAMS <= '1';
      else
         if(wEn(54) = '1' and bitEnN(0) = '0') then
            field_wautoclr_ACQ_ACQ_SFNC_RELOAD_GRAB_PARAMS <= reg_writedata(0);
         else
            field_wautoclr_ACQ_ACQ_SFNC_RELOAD_GRAB_PARAMS <= '0';
         end if;
      end if;
   end if;
end process P_ACQ_ACQ_SFNC_RELOAD_GRAB_PARAMS;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_NOPEL
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(55) <= (hit(55)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: NOPEL_FIFO_UNDERRUN
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_NOPEL(25) <= regfile.ACQ.NOPEL.NOPEL_FIFO_UNDERRUN;


------------------------------------------------------------------------------------------
-- Field name: NOPEL_FIFO_OVERRUN
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_NOPEL(24) <= regfile.ACQ.NOPEL.NOPEL_FIFO_OVERRUN;


------------------------------------------------------------------------------------------
-- Field name: NOPEL_FIFO_RST
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_NOPEL(20) <= field_rw_ACQ_NOPEL_NOPEL_FIFO_RST;
regfile.ACQ.NOPEL.NOPEL_FIFO_RST <= field_rw_ACQ_NOPEL_NOPEL_FIFO_RST;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_NOPEL_NOPEL_FIFO_RST
------------------------------------------------------------------------------------------
P_ACQ_NOPEL_NOPEL_FIFO_RST : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_NOPEL_NOPEL_FIFO_RST <= '0';
      else
         if(wEn(55) = '1' and bitEnN(20) = '0') then
            field_rw_ACQ_NOPEL_NOPEL_FIFO_RST <= reg_writedata(20);
         end if;
      end if;
   end if;
end process P_ACQ_NOPEL_NOPEL_FIFO_RST;

------------------------------------------------------------------------------------------
-- Field name: NOPEL_BYPASS
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_NOPEL(17) <= field_rw_ACQ_NOPEL_NOPEL_BYPASS;
regfile.ACQ.NOPEL.NOPEL_BYPASS <= field_rw_ACQ_NOPEL_NOPEL_BYPASS;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_NOPEL_NOPEL_BYPASS
------------------------------------------------------------------------------------------
P_ACQ_NOPEL_NOPEL_BYPASS : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_NOPEL_NOPEL_BYPASS <= '0';
      else
         if(wEn(55) = '1' and bitEnN(17) = '0') then
            field_rw_ACQ_NOPEL_NOPEL_BYPASS <= reg_writedata(17);
         end if;
      end if;
   end if;
end process P_ACQ_NOPEL_NOPEL_BYPASS;

------------------------------------------------------------------------------------------
-- Field name: NOPEL_ENABLE
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_NOPEL(16) <= field_rw_ACQ_NOPEL_NOPEL_ENABLE;
regfile.ACQ.NOPEL.NOPEL_ENABLE <= field_rw_ACQ_NOPEL_NOPEL_ENABLE;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_NOPEL_NOPEL_ENABLE
------------------------------------------------------------------------------------------
P_ACQ_NOPEL_NOPEL_ENABLE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_NOPEL_NOPEL_ENABLE <= '1';
      else
         if(wEn(55) = '1' and bitEnN(16) = '0') then
            field_rw_ACQ_NOPEL_NOPEL_ENABLE <= reg_writedata(16);
         end if;
      end if;
   end if;
end process P_ACQ_NOPEL_NOPEL_ENABLE;

------------------------------------------------------------------------------------------
-- Field name: NOPEL_THRESHOLD(7 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_NOPEL(7 downto 0) <= field_rw_ACQ_NOPEL_NOPEL_THRESHOLD(7 downto 0);
regfile.ACQ.NOPEL.NOPEL_THRESHOLD <= field_rw_ACQ_NOPEL_NOPEL_THRESHOLD(7 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_NOPEL_NOPEL_THRESHOLD
------------------------------------------------------------------------------------------
P_ACQ_NOPEL_NOPEL_THRESHOLD : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_NOPEL_NOPEL_THRESHOLD <= std_logic_vector(to_unsigned(integer(16),8));
      else
         for j in  7 downto 0  loop
            if(wEn(55) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_NOPEL_NOPEL_THRESHOLD(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_NOPEL_NOPEL_THRESHOLD;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DATA_LUT_CTRL
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(56) <= (hit(56)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: LUT_BYPASS
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_LUT_CTRL(31) <= field_rw_DATA_LUT_CTRL_LUT_BYPASS;
regfile.DATA.LUT_CTRL.LUT_BYPASS <= field_rw_DATA_LUT_CTRL_LUT_BYPASS;


------------------------------------------------------------------------------------------
-- Process: P_DATA_LUT_CTRL_LUT_BYPASS
------------------------------------------------------------------------------------------
P_DATA_LUT_CTRL_LUT_BYPASS : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_LUT_CTRL_LUT_BYPASS <= '0';
      else
         if(wEn(56) = '1' and bitEnN(31) = '0') then
            field_rw_DATA_LUT_CTRL_LUT_BYPASS <= reg_writedata(31);
         end if;
      end if;
   end if;
end process P_DATA_LUT_CTRL_LUT_BYPASS;

------------------------------------------------------------------------------------------
-- Field name: LUT_PALETTE_USE
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_LUT_CTRL(29) <= field_rw_DATA_LUT_CTRL_LUT_PALETTE_USE;
regfile.DATA.LUT_CTRL.LUT_PALETTE_USE <= field_rw_DATA_LUT_CTRL_LUT_PALETTE_USE;


------------------------------------------------------------------------------------------
-- Process: P_DATA_LUT_CTRL_LUT_PALETTE_USE
------------------------------------------------------------------------------------------
P_DATA_LUT_CTRL_LUT_PALETTE_USE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_LUT_CTRL_LUT_PALETTE_USE <= '0';
      else
         if(wEn(56) = '1' and bitEnN(29) = '0') then
            field_rw_DATA_LUT_CTRL_LUT_PALETTE_USE <= reg_writedata(29);
         end if;
      end if;
   end if;
end process P_DATA_LUT_CTRL_LUT_PALETTE_USE;

------------------------------------------------------------------------------------------
-- Field name: LUT_PALETTE_W
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_LUT_CTRL(28) <= field_rw_DATA_LUT_CTRL_LUT_PALETTE_W;
regfile.DATA.LUT_CTRL.LUT_PALETTE_W <= field_rw_DATA_LUT_CTRL_LUT_PALETTE_W;


------------------------------------------------------------------------------------------
-- Process: P_DATA_LUT_CTRL_LUT_PALETTE_W
------------------------------------------------------------------------------------------
P_DATA_LUT_CTRL_LUT_PALETTE_W : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_LUT_CTRL_LUT_PALETTE_W <= '0';
      else
         if(wEn(56) = '1' and bitEnN(28) = '0') then
            field_rw_DATA_LUT_CTRL_LUT_PALETTE_W <= reg_writedata(28);
         end if;
      end if;
   end if;
end process P_DATA_LUT_CTRL_LUT_PALETTE_W;

------------------------------------------------------------------------------------------
-- Field name: LUT_DATA_W(25 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_LUT_CTRL(25 downto 16) <= field_rw_DATA_LUT_CTRL_LUT_DATA_W(9 downto 0);
regfile.DATA.LUT_CTRL.LUT_DATA_W <= field_rw_DATA_LUT_CTRL_LUT_DATA_W(9 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DATA_LUT_CTRL_LUT_DATA_W
------------------------------------------------------------------------------------------
P_DATA_LUT_CTRL_LUT_DATA_W : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_LUT_CTRL_LUT_DATA_W <= std_logic_vector(to_unsigned(integer(0),10));
      else
         for j in  25 downto 16  loop
            if(wEn(56) = '1' and bitEnN(j) = '0') then
               field_rw_DATA_LUT_CTRL_LUT_DATA_W(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DATA_LUT_CTRL_LUT_DATA_W;

------------------------------------------------------------------------------------------
-- Field name: LUT_SEL(14 downto 12)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_LUT_CTRL(14 downto 12) <= field_rw_DATA_LUT_CTRL_LUT_SEL(2 downto 0);
regfile.DATA.LUT_CTRL.LUT_SEL <= field_rw_DATA_LUT_CTRL_LUT_SEL(2 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DATA_LUT_CTRL_LUT_SEL
------------------------------------------------------------------------------------------
P_DATA_LUT_CTRL_LUT_SEL : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_LUT_CTRL_LUT_SEL <= std_logic_vector(to_unsigned(integer(0),3));
      else
         for j in  14 downto 12  loop
            if(wEn(56) = '1' and bitEnN(j) = '0') then
               field_rw_DATA_LUT_CTRL_LUT_SEL(j-12) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DATA_LUT_CTRL_LUT_SEL;

------------------------------------------------------------------------------------------
-- Field name: LUT_WRN
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_LUT_CTRL(11) <= field_rw_DATA_LUT_CTRL_LUT_WRN;
regfile.DATA.LUT_CTRL.LUT_WRN <= field_rw_DATA_LUT_CTRL_LUT_WRN;


------------------------------------------------------------------------------------------
-- Process: P_DATA_LUT_CTRL_LUT_WRN
------------------------------------------------------------------------------------------
P_DATA_LUT_CTRL_LUT_WRN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_LUT_CTRL_LUT_WRN <= '0';
      else
         if(wEn(56) = '1' and bitEnN(11) = '0') then
            field_rw_DATA_LUT_CTRL_LUT_WRN <= reg_writedata(11);
         end if;
      end if;
   end if;
end process P_DATA_LUT_CTRL_LUT_WRN;

------------------------------------------------------------------------------------------
-- Field name: LUT_SS
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_DATA_LUT_CTRL(10) <= '0';
regfile.DATA.LUT_CTRL.LUT_SS <= field_wautoclr_DATA_LUT_CTRL_LUT_SS;


------------------------------------------------------------------------------------------
-- Process: P_DATA_LUT_CTRL_LUT_SS
------------------------------------------------------------------------------------------
P_DATA_LUT_CTRL_LUT_SS : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_DATA_LUT_CTRL_LUT_SS <= '0';
      else
         if(wEn(56) = '1' and bitEnN(10) = '0') then
            field_wautoclr_DATA_LUT_CTRL_LUT_SS <= reg_writedata(10);
         else
            field_wautoclr_DATA_LUT_CTRL_LUT_SS <= '0';
         end if;
      end if;
   end if;
end process P_DATA_LUT_CTRL_LUT_SS;

------------------------------------------------------------------------------------------
-- Field name: LUT_ADD(9 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_LUT_CTRL(9 downto 0) <= field_rw_DATA_LUT_CTRL_LUT_ADD(9 downto 0);
regfile.DATA.LUT_CTRL.LUT_ADD <= field_rw_DATA_LUT_CTRL_LUT_ADD(9 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DATA_LUT_CTRL_LUT_ADD
------------------------------------------------------------------------------------------
P_DATA_LUT_CTRL_LUT_ADD : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_LUT_CTRL_LUT_ADD <= std_logic_vector(to_unsigned(integer(0),10));
      else
         for j in  9 downto 0  loop
            if(wEn(56) = '1' and bitEnN(j) = '0') then
               field_rw_DATA_LUT_CTRL_LUT_ADD(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DATA_LUT_CTRL_LUT_ADD;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DATA_LUT_RB
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(57) <= (hit(57)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: LUT_RB(9 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_DATA_LUT_RB(9 downto 0) <= regfile.DATA.LUT_RB.LUT_RB;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DATA_WB_MULT1
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(58) <= (hit(58)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: WB_MULT_G(31 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_WB_MULT1(31 downto 16) <= field_rw_DATA_WB_MULT1_WB_MULT_G(15 downto 0);
regfile.DATA.WB_MULT1.WB_MULT_G <= field_rw_DATA_WB_MULT1_WB_MULT_G(15 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DATA_WB_MULT1_WB_MULT_G
------------------------------------------------------------------------------------------
P_DATA_WB_MULT1_WB_MULT_G : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_WB_MULT1_WB_MULT_G <= std_logic_vector(to_unsigned(integer(4096),16));
      else
         for j in  31 downto 16  loop
            if(wEn(58) = '1' and bitEnN(j) = '0') then
               field_rw_DATA_WB_MULT1_WB_MULT_G(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DATA_WB_MULT1_WB_MULT_G;

------------------------------------------------------------------------------------------
-- Field name: WB_MULT_B(15 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_WB_MULT1(15 downto 0) <= field_rw_DATA_WB_MULT1_WB_MULT_B(15 downto 0);
regfile.DATA.WB_MULT1.WB_MULT_B <= field_rw_DATA_WB_MULT1_WB_MULT_B(15 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DATA_WB_MULT1_WB_MULT_B
------------------------------------------------------------------------------------------
P_DATA_WB_MULT1_WB_MULT_B : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_WB_MULT1_WB_MULT_B <= std_logic_vector(to_unsigned(integer(4096),16));
      else
         for j in  15 downto 0  loop
            if(wEn(58) = '1' and bitEnN(j) = '0') then
               field_rw_DATA_WB_MULT1_WB_MULT_B(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DATA_WB_MULT1_WB_MULT_B;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DATA_WB_MULT2
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(59) <= (hit(59)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: WB_MULT_R(15 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_WB_MULT2(15 downto 0) <= field_rw_DATA_WB_MULT2_WB_MULT_R(15 downto 0);
regfile.DATA.WB_MULT2.WB_MULT_R <= field_rw_DATA_WB_MULT2_WB_MULT_R(15 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DATA_WB_MULT2_WB_MULT_R
------------------------------------------------------------------------------------------
P_DATA_WB_MULT2_WB_MULT_R : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_WB_MULT2_WB_MULT_R <= std_logic_vector(to_unsigned(integer(4096),16));
      else
         for j in  15 downto 0  loop
            if(wEn(59) = '1' and bitEnN(j) = '0') then
               field_rw_DATA_WB_MULT2_WB_MULT_R(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DATA_WB_MULT2_WB_MULT_R;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DATA_WB_B_ACC
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(60) <= (hit(60)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: B_ACC(30 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_DATA_WB_B_ACC(30 downto 0) <= regfile.DATA.WB_B_ACC.B_ACC;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DATA_WB_G_ACC
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(61) <= (hit(61)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: G_ACC(31 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_DATA_WB_G_ACC(31 downto 0) <= regfile.DATA.WB_G_ACC.G_ACC;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DATA_WB_R_ACC
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(62) <= (hit(62)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: R_ACC(30 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_DATA_WB_R_ACC(30 downto 0) <= regfile.DATA.WB_R_ACC.R_ACC;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DATA_FPN_ADD
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(63) <= (hit(63)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: FPN_73
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_FPN_ADD(31) <= field_rw_DATA_FPN_ADD_FPN_73;
regfile.DATA.FPN_ADD.FPN_73 <= field_rw_DATA_FPN_ADD_FPN_73;


------------------------------------------------------------------------------------------
-- Process: P_DATA_FPN_ADD_FPN_73
------------------------------------------------------------------------------------------
P_DATA_FPN_ADD_FPN_73 : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_FPN_ADD_FPN_73 <= '0';
      else
         if(wEn(63) = '1' and bitEnN(31) = '0') then
            field_rw_DATA_FPN_ADD_FPN_73 <= reg_writedata(31);
         end if;
      end if;
   end if;
end process P_DATA_FPN_ADD_FPN_73;

------------------------------------------------------------------------------------------
-- Field name: FPN_WE
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_FPN_ADD(28) <= field_rw_DATA_FPN_ADD_FPN_WE;
regfile.DATA.FPN_ADD.FPN_WE <= field_rw_DATA_FPN_ADD_FPN_WE;


------------------------------------------------------------------------------------------
-- Process: P_DATA_FPN_ADD_FPN_WE
------------------------------------------------------------------------------------------
P_DATA_FPN_ADD_FPN_WE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_FPN_ADD_FPN_WE <= '1';
      else
         if(wEn(63) = '1' and bitEnN(28) = '0') then
            field_rw_DATA_FPN_ADD_FPN_WE <= reg_writedata(28);
         end if;
      end if;
   end if;
end process P_DATA_FPN_ADD_FPN_WE;

------------------------------------------------------------------------------------------
-- Field name: FPN_EN
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_FPN_ADD(24) <= field_rw_DATA_FPN_ADD_FPN_EN;
regfile.DATA.FPN_ADD.FPN_EN <= field_rw_DATA_FPN_ADD_FPN_EN;


------------------------------------------------------------------------------------------
-- Process: P_DATA_FPN_ADD_FPN_EN
------------------------------------------------------------------------------------------
P_DATA_FPN_ADD_FPN_EN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_FPN_ADD_FPN_EN <= '0';
      else
         if(wEn(63) = '1' and bitEnN(24) = '0') then
            field_rw_DATA_FPN_ADD_FPN_EN <= reg_writedata(24);
         end if;
      end if;
   end if;
end process P_DATA_FPN_ADD_FPN_EN;

------------------------------------------------------------------------------------------
-- Field name: FPN_SS
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_DATA_FPN_ADD(16) <= '0';
regfile.DATA.FPN_ADD.FPN_SS <= field_wautoclr_DATA_FPN_ADD_FPN_SS;


------------------------------------------------------------------------------------------
-- Process: P_DATA_FPN_ADD_FPN_SS
------------------------------------------------------------------------------------------
P_DATA_FPN_ADD_FPN_SS : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_DATA_FPN_ADD_FPN_SS <= '0';
      else
         if(wEn(63) = '1' and bitEnN(16) = '0') then
            field_wautoclr_DATA_FPN_ADD_FPN_SS <= reg_writedata(16);
         else
            field_wautoclr_DATA_FPN_ADD_FPN_SS <= '0';
         end if;
      end if;
   end if;
end process P_DATA_FPN_ADD_FPN_SS;

------------------------------------------------------------------------------------------
-- Field name: FPN_ADD(9 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_FPN_ADD(9 downto 0) <= field_rw_DATA_FPN_ADD_FPN_ADD(9 downto 0);
regfile.DATA.FPN_ADD.FPN_ADD <= field_rw_DATA_FPN_ADD_FPN_ADD(9 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DATA_FPN_ADD_FPN_ADD
------------------------------------------------------------------------------------------
P_DATA_FPN_ADD_FPN_ADD : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_FPN_ADD_FPN_ADD <= std_logic_vector(to_unsigned(integer(0),10));
      else
         for j in  9 downto 0  loop
            if(wEn(63) = '1' and bitEnN(j) = '0') then
               field_rw_DATA_FPN_ADD_FPN_ADD(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DATA_FPN_ADD_FPN_ADD;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DATA_FPN_READ_REG
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(64) <= (hit(64)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: FPN_READ_PIX_SEL(30 downto 28)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_FPN_READ_REG(30 downto 28) <= field_rw_DATA_FPN_READ_REG_FPN_READ_PIX_SEL(2 downto 0);
regfile.DATA.FPN_READ_REG.FPN_READ_PIX_SEL <= field_rw_DATA_FPN_READ_REG_FPN_READ_PIX_SEL(2 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DATA_FPN_READ_REG_FPN_READ_PIX_SEL
------------------------------------------------------------------------------------------
P_DATA_FPN_READ_REG_FPN_READ_PIX_SEL : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_FPN_READ_REG_FPN_READ_PIX_SEL <= std_logic_vector(to_unsigned(integer(0),3));
      else
         for j in  30 downto 28  loop
            if(wEn(64) = '1' and bitEnN(j) = '0') then
               field_rw_DATA_FPN_READ_REG_FPN_READ_PIX_SEL(j-28) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DATA_FPN_READ_REG_FPN_READ_PIX_SEL;

------------------------------------------------------------------------------------------
-- Field name: FPN_READ_PRNU(8 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_DATA_FPN_READ_REG(24 downto 16) <= regfile.DATA.FPN_READ_REG.FPN_READ_PRNU;


------------------------------------------------------------------------------------------
-- Field name: FPN_READ_FPN(10 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_DATA_FPN_READ_REG(10 downto 0) <= regfile.DATA.FPN_READ_REG.FPN_READ_FPN;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DATA_FPN_DATA_0
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(65) <= (hit(65)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: FPN_DATA_PRNU(24 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_FPN_DATA_0(24 downto 16) <= field_rw_DATA_FPN_DATA_0_FPN_DATA_PRNU(8 downto 0);
regfile.DATA.FPN_DATA(0).FPN_DATA_PRNU <= field_rw_DATA_FPN_DATA_0_FPN_DATA_PRNU(8 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DATA_FPN_DATA_0_FPN_DATA_PRNU
------------------------------------------------------------------------------------------
P_DATA_FPN_DATA_0_FPN_DATA_PRNU : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_FPN_DATA_0_FPN_DATA_PRNU <= std_logic_vector(to_unsigned(integer(0),9));
      else
         for j in  24 downto 16  loop
            if(wEn(65) = '1' and bitEnN(j) = '0') then
               field_rw_DATA_FPN_DATA_0_FPN_DATA_PRNU(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DATA_FPN_DATA_0_FPN_DATA_PRNU;

------------------------------------------------------------------------------------------
-- Field name: FPN_DATA_FPN(10 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_FPN_DATA_0(10 downto 0) <= field_rw_DATA_FPN_DATA_0_FPN_DATA_FPN(10 downto 0);
regfile.DATA.FPN_DATA(0).FPN_DATA_FPN <= field_rw_DATA_FPN_DATA_0_FPN_DATA_FPN(10 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DATA_FPN_DATA_0_FPN_DATA_FPN
------------------------------------------------------------------------------------------
P_DATA_FPN_DATA_0_FPN_DATA_FPN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_FPN_DATA_0_FPN_DATA_FPN <= std_logic_vector(to_unsigned(integer(0),11));
      else
         for j in  10 downto 0  loop
            if(wEn(65) = '1' and bitEnN(j) = '0') then
               field_rw_DATA_FPN_DATA_0_FPN_DATA_FPN(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DATA_FPN_DATA_0_FPN_DATA_FPN;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DATA_FPN_DATA_1
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(66) <= (hit(66)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: FPN_DATA_PRNU(24 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_FPN_DATA_1(24 downto 16) <= field_rw_DATA_FPN_DATA_1_FPN_DATA_PRNU(8 downto 0);
regfile.DATA.FPN_DATA(1).FPN_DATA_PRNU <= field_rw_DATA_FPN_DATA_1_FPN_DATA_PRNU(8 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DATA_FPN_DATA_1_FPN_DATA_PRNU
------------------------------------------------------------------------------------------
P_DATA_FPN_DATA_1_FPN_DATA_PRNU : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_FPN_DATA_1_FPN_DATA_PRNU <= std_logic_vector(to_unsigned(integer(0),9));
      else
         for j in  24 downto 16  loop
            if(wEn(66) = '1' and bitEnN(j) = '0') then
               field_rw_DATA_FPN_DATA_1_FPN_DATA_PRNU(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DATA_FPN_DATA_1_FPN_DATA_PRNU;

------------------------------------------------------------------------------------------
-- Field name: FPN_DATA_FPN(10 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_FPN_DATA_1(10 downto 0) <= field_rw_DATA_FPN_DATA_1_FPN_DATA_FPN(10 downto 0);
regfile.DATA.FPN_DATA(1).FPN_DATA_FPN <= field_rw_DATA_FPN_DATA_1_FPN_DATA_FPN(10 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DATA_FPN_DATA_1_FPN_DATA_FPN
------------------------------------------------------------------------------------------
P_DATA_FPN_DATA_1_FPN_DATA_FPN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_FPN_DATA_1_FPN_DATA_FPN <= std_logic_vector(to_unsigned(integer(0),11));
      else
         for j in  10 downto 0  loop
            if(wEn(66) = '1' and bitEnN(j) = '0') then
               field_rw_DATA_FPN_DATA_1_FPN_DATA_FPN(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DATA_FPN_DATA_1_FPN_DATA_FPN;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DATA_FPN_DATA_2
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(67) <= (hit(67)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: FPN_DATA_PRNU(24 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_FPN_DATA_2(24 downto 16) <= field_rw_DATA_FPN_DATA_2_FPN_DATA_PRNU(8 downto 0);
regfile.DATA.FPN_DATA(2).FPN_DATA_PRNU <= field_rw_DATA_FPN_DATA_2_FPN_DATA_PRNU(8 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DATA_FPN_DATA_2_FPN_DATA_PRNU
------------------------------------------------------------------------------------------
P_DATA_FPN_DATA_2_FPN_DATA_PRNU : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_FPN_DATA_2_FPN_DATA_PRNU <= std_logic_vector(to_unsigned(integer(0),9));
      else
         for j in  24 downto 16  loop
            if(wEn(67) = '1' and bitEnN(j) = '0') then
               field_rw_DATA_FPN_DATA_2_FPN_DATA_PRNU(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DATA_FPN_DATA_2_FPN_DATA_PRNU;

------------------------------------------------------------------------------------------
-- Field name: FPN_DATA_FPN(10 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_FPN_DATA_2(10 downto 0) <= field_rw_DATA_FPN_DATA_2_FPN_DATA_FPN(10 downto 0);
regfile.DATA.FPN_DATA(2).FPN_DATA_FPN <= field_rw_DATA_FPN_DATA_2_FPN_DATA_FPN(10 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DATA_FPN_DATA_2_FPN_DATA_FPN
------------------------------------------------------------------------------------------
P_DATA_FPN_DATA_2_FPN_DATA_FPN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_FPN_DATA_2_FPN_DATA_FPN <= std_logic_vector(to_unsigned(integer(0),11));
      else
         for j in  10 downto 0  loop
            if(wEn(67) = '1' and bitEnN(j) = '0') then
               field_rw_DATA_FPN_DATA_2_FPN_DATA_FPN(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DATA_FPN_DATA_2_FPN_DATA_FPN;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DATA_FPN_DATA_3
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(68) <= (hit(68)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: FPN_DATA_PRNU(24 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_FPN_DATA_3(24 downto 16) <= field_rw_DATA_FPN_DATA_3_FPN_DATA_PRNU(8 downto 0);
regfile.DATA.FPN_DATA(3).FPN_DATA_PRNU <= field_rw_DATA_FPN_DATA_3_FPN_DATA_PRNU(8 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DATA_FPN_DATA_3_FPN_DATA_PRNU
------------------------------------------------------------------------------------------
P_DATA_FPN_DATA_3_FPN_DATA_PRNU : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_FPN_DATA_3_FPN_DATA_PRNU <= std_logic_vector(to_unsigned(integer(0),9));
      else
         for j in  24 downto 16  loop
            if(wEn(68) = '1' and bitEnN(j) = '0') then
               field_rw_DATA_FPN_DATA_3_FPN_DATA_PRNU(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DATA_FPN_DATA_3_FPN_DATA_PRNU;

------------------------------------------------------------------------------------------
-- Field name: FPN_DATA_FPN(10 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_FPN_DATA_3(10 downto 0) <= field_rw_DATA_FPN_DATA_3_FPN_DATA_FPN(10 downto 0);
regfile.DATA.FPN_DATA(3).FPN_DATA_FPN <= field_rw_DATA_FPN_DATA_3_FPN_DATA_FPN(10 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DATA_FPN_DATA_3_FPN_DATA_FPN
------------------------------------------------------------------------------------------
P_DATA_FPN_DATA_3_FPN_DATA_FPN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_FPN_DATA_3_FPN_DATA_FPN <= std_logic_vector(to_unsigned(integer(0),11));
      else
         for j in  10 downto 0  loop
            if(wEn(68) = '1' and bitEnN(j) = '0') then
               field_rw_DATA_FPN_DATA_3_FPN_DATA_FPN(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DATA_FPN_DATA_3_FPN_DATA_FPN;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DATA_FPN_DATA_4
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(69) <= (hit(69)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: FPN_DATA_PRNU(24 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_FPN_DATA_4(24 downto 16) <= field_rw_DATA_FPN_DATA_4_FPN_DATA_PRNU(8 downto 0);
regfile.DATA.FPN_DATA(4).FPN_DATA_PRNU <= field_rw_DATA_FPN_DATA_4_FPN_DATA_PRNU(8 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DATA_FPN_DATA_4_FPN_DATA_PRNU
------------------------------------------------------------------------------------------
P_DATA_FPN_DATA_4_FPN_DATA_PRNU : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_FPN_DATA_4_FPN_DATA_PRNU <= std_logic_vector(to_unsigned(integer(0),9));
      else
         for j in  24 downto 16  loop
            if(wEn(69) = '1' and bitEnN(j) = '0') then
               field_rw_DATA_FPN_DATA_4_FPN_DATA_PRNU(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DATA_FPN_DATA_4_FPN_DATA_PRNU;

------------------------------------------------------------------------------------------
-- Field name: FPN_DATA_FPN(10 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_FPN_DATA_4(10 downto 0) <= field_rw_DATA_FPN_DATA_4_FPN_DATA_FPN(10 downto 0);
regfile.DATA.FPN_DATA(4).FPN_DATA_FPN <= field_rw_DATA_FPN_DATA_4_FPN_DATA_FPN(10 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DATA_FPN_DATA_4_FPN_DATA_FPN
------------------------------------------------------------------------------------------
P_DATA_FPN_DATA_4_FPN_DATA_FPN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_FPN_DATA_4_FPN_DATA_FPN <= std_logic_vector(to_unsigned(integer(0),11));
      else
         for j in  10 downto 0  loop
            if(wEn(69) = '1' and bitEnN(j) = '0') then
               field_rw_DATA_FPN_DATA_4_FPN_DATA_FPN(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DATA_FPN_DATA_4_FPN_DATA_FPN;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DATA_FPN_DATA_5
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(70) <= (hit(70)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: FPN_DATA_PRNU(24 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_FPN_DATA_5(24 downto 16) <= field_rw_DATA_FPN_DATA_5_FPN_DATA_PRNU(8 downto 0);
regfile.DATA.FPN_DATA(5).FPN_DATA_PRNU <= field_rw_DATA_FPN_DATA_5_FPN_DATA_PRNU(8 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DATA_FPN_DATA_5_FPN_DATA_PRNU
------------------------------------------------------------------------------------------
P_DATA_FPN_DATA_5_FPN_DATA_PRNU : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_FPN_DATA_5_FPN_DATA_PRNU <= std_logic_vector(to_unsigned(integer(0),9));
      else
         for j in  24 downto 16  loop
            if(wEn(70) = '1' and bitEnN(j) = '0') then
               field_rw_DATA_FPN_DATA_5_FPN_DATA_PRNU(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DATA_FPN_DATA_5_FPN_DATA_PRNU;

------------------------------------------------------------------------------------------
-- Field name: FPN_DATA_FPN(10 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_FPN_DATA_5(10 downto 0) <= field_rw_DATA_FPN_DATA_5_FPN_DATA_FPN(10 downto 0);
regfile.DATA.FPN_DATA(5).FPN_DATA_FPN <= field_rw_DATA_FPN_DATA_5_FPN_DATA_FPN(10 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DATA_FPN_DATA_5_FPN_DATA_FPN
------------------------------------------------------------------------------------------
P_DATA_FPN_DATA_5_FPN_DATA_FPN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_FPN_DATA_5_FPN_DATA_FPN <= std_logic_vector(to_unsigned(integer(0),11));
      else
         for j in  10 downto 0  loop
            if(wEn(70) = '1' and bitEnN(j) = '0') then
               field_rw_DATA_FPN_DATA_5_FPN_DATA_FPN(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DATA_FPN_DATA_5_FPN_DATA_FPN;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DATA_FPN_DATA_6
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(71) <= (hit(71)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: FPN_DATA_PRNU(24 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_FPN_DATA_6(24 downto 16) <= field_rw_DATA_FPN_DATA_6_FPN_DATA_PRNU(8 downto 0);
regfile.DATA.FPN_DATA(6).FPN_DATA_PRNU <= field_rw_DATA_FPN_DATA_6_FPN_DATA_PRNU(8 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DATA_FPN_DATA_6_FPN_DATA_PRNU
------------------------------------------------------------------------------------------
P_DATA_FPN_DATA_6_FPN_DATA_PRNU : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_FPN_DATA_6_FPN_DATA_PRNU <= std_logic_vector(to_unsigned(integer(0),9));
      else
         for j in  24 downto 16  loop
            if(wEn(71) = '1' and bitEnN(j) = '0') then
               field_rw_DATA_FPN_DATA_6_FPN_DATA_PRNU(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DATA_FPN_DATA_6_FPN_DATA_PRNU;

------------------------------------------------------------------------------------------
-- Field name: FPN_DATA_FPN(10 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_FPN_DATA_6(10 downto 0) <= field_rw_DATA_FPN_DATA_6_FPN_DATA_FPN(10 downto 0);
regfile.DATA.FPN_DATA(6).FPN_DATA_FPN <= field_rw_DATA_FPN_DATA_6_FPN_DATA_FPN(10 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DATA_FPN_DATA_6_FPN_DATA_FPN
------------------------------------------------------------------------------------------
P_DATA_FPN_DATA_6_FPN_DATA_FPN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_FPN_DATA_6_FPN_DATA_FPN <= std_logic_vector(to_unsigned(integer(0),11));
      else
         for j in  10 downto 0  loop
            if(wEn(71) = '1' and bitEnN(j) = '0') then
               field_rw_DATA_FPN_DATA_6_FPN_DATA_FPN(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DATA_FPN_DATA_6_FPN_DATA_FPN;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DATA_FPN_DATA_7
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(72) <= (hit(72)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: FPN_DATA_PRNU(24 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_FPN_DATA_7(24 downto 16) <= field_rw_DATA_FPN_DATA_7_FPN_DATA_PRNU(8 downto 0);
regfile.DATA.FPN_DATA(7).FPN_DATA_PRNU <= field_rw_DATA_FPN_DATA_7_FPN_DATA_PRNU(8 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DATA_FPN_DATA_7_FPN_DATA_PRNU
------------------------------------------------------------------------------------------
P_DATA_FPN_DATA_7_FPN_DATA_PRNU : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_FPN_DATA_7_FPN_DATA_PRNU <= std_logic_vector(to_unsigned(integer(0),9));
      else
         for j in  24 downto 16  loop
            if(wEn(72) = '1' and bitEnN(j) = '0') then
               field_rw_DATA_FPN_DATA_7_FPN_DATA_PRNU(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DATA_FPN_DATA_7_FPN_DATA_PRNU;

------------------------------------------------------------------------------------------
-- Field name: FPN_DATA_FPN(10 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_FPN_DATA_7(10 downto 0) <= field_rw_DATA_FPN_DATA_7_FPN_DATA_FPN(10 downto 0);
regfile.DATA.FPN_DATA(7).FPN_DATA_FPN <= field_rw_DATA_FPN_DATA_7_FPN_DATA_FPN(10 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DATA_FPN_DATA_7_FPN_DATA_FPN
------------------------------------------------------------------------------------------
P_DATA_FPN_DATA_7_FPN_DATA_FPN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_FPN_DATA_7_FPN_DATA_FPN <= std_logic_vector(to_unsigned(integer(0),11));
      else
         for j in  10 downto 0  loop
            if(wEn(72) = '1' and bitEnN(j) = '0') then
               field_rw_DATA_FPN_DATA_7_FPN_DATA_FPN(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DATA_FPN_DATA_7_FPN_DATA_FPN;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DATA_FPN_CONTRAST
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(73) <= (hit(73)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: CONTRAST_GAIN(27 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_FPN_CONTRAST(27 downto 16) <= field_rw_DATA_FPN_CONTRAST_CONTRAST_GAIN(11 downto 0);
regfile.DATA.FPN_CONTRAST.CONTRAST_GAIN <= field_rw_DATA_FPN_CONTRAST_CONTRAST_GAIN(11 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DATA_FPN_CONTRAST_CONTRAST_GAIN
------------------------------------------------------------------------------------------
P_DATA_FPN_CONTRAST_CONTRAST_GAIN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_FPN_CONTRAST_CONTRAST_GAIN <= std_logic_vector(to_unsigned(integer(256),12));
      else
         for j in  27 downto 16  loop
            if(wEn(73) = '1' and bitEnN(j) = '0') then
               field_rw_DATA_FPN_CONTRAST_CONTRAST_GAIN(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DATA_FPN_CONTRAST_CONTRAST_GAIN;

------------------------------------------------------------------------------------------
-- Field name: CONTRAST_OFFSET(7 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_FPN_CONTRAST(7 downto 0) <= field_rw_DATA_FPN_CONTRAST_CONTRAST_OFFSET(7 downto 0);
regfile.DATA.FPN_CONTRAST.CONTRAST_OFFSET <= field_rw_DATA_FPN_CONTRAST_CONTRAST_OFFSET(7 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DATA_FPN_CONTRAST_CONTRAST_OFFSET
------------------------------------------------------------------------------------------
P_DATA_FPN_CONTRAST_CONTRAST_OFFSET : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_FPN_CONTRAST_CONTRAST_OFFSET <= std_logic_vector(to_unsigned(integer(0),8));
      else
         for j in  7 downto 0  loop
            if(wEn(73) = '1' and bitEnN(j) = '0') then
               field_rw_DATA_FPN_CONTRAST_CONTRAST_OFFSET(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DATA_FPN_CONTRAST_CONTRAST_OFFSET;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DATA_FPN_ACC_ADD
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(74) <= (hit(74)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: FPN_ACC_MODE_SEL
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_FPN_ACC_ADD(21) <= field_rw_DATA_FPN_ACC_ADD_FPN_ACC_MODE_SEL;
regfile.DATA.FPN_ACC_ADD.FPN_ACC_MODE_SEL <= field_rw_DATA_FPN_ACC_ADD_FPN_ACC_MODE_SEL;


------------------------------------------------------------------------------------------
-- Process: P_DATA_FPN_ACC_ADD_FPN_ACC_MODE_SEL
------------------------------------------------------------------------------------------
P_DATA_FPN_ACC_ADD_FPN_ACC_MODE_SEL : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_FPN_ACC_ADD_FPN_ACC_MODE_SEL <= '0';
      else
         if(wEn(74) = '1' and bitEnN(21) = '0') then
            field_rw_DATA_FPN_ACC_ADD_FPN_ACC_MODE_SEL <= reg_writedata(21);
         end if;
      end if;
   end if;
end process P_DATA_FPN_ACC_ADD_FPN_ACC_MODE_SEL;

------------------------------------------------------------------------------------------
-- Field name: FPN_ACC_MODE_EN
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_FPN_ACC_ADD(20) <= field_rw_DATA_FPN_ACC_ADD_FPN_ACC_MODE_EN;
regfile.DATA.FPN_ACC_ADD.FPN_ACC_MODE_EN <= field_rw_DATA_FPN_ACC_ADD_FPN_ACC_MODE_EN;


------------------------------------------------------------------------------------------
-- Process: P_DATA_FPN_ACC_ADD_FPN_ACC_MODE_EN
------------------------------------------------------------------------------------------
P_DATA_FPN_ACC_ADD_FPN_ACC_MODE_EN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_FPN_ACC_ADD_FPN_ACC_MODE_EN <= '0';
      else
         if(wEn(74) = '1' and bitEnN(20) = '0') then
            field_rw_DATA_FPN_ACC_ADD_FPN_ACC_MODE_EN <= reg_writedata(20);
         end if;
      end if;
   end if;
end process P_DATA_FPN_ACC_ADD_FPN_ACC_MODE_EN;

------------------------------------------------------------------------------------------
-- Field name: FPN_ACC_R_SS
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_DATA_FPN_ACC_ADD(16) <= '0';
regfile.DATA.FPN_ACC_ADD.FPN_ACC_R_SS <= field_wautoclr_DATA_FPN_ACC_ADD_FPN_ACC_R_SS;


------------------------------------------------------------------------------------------
-- Process: P_DATA_FPN_ACC_ADD_FPN_ACC_R_SS
------------------------------------------------------------------------------------------
P_DATA_FPN_ACC_ADD_FPN_ACC_R_SS : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_DATA_FPN_ACC_ADD_FPN_ACC_R_SS <= '0';
      else
         if(wEn(74) = '1' and bitEnN(16) = '0') then
            field_wautoclr_DATA_FPN_ACC_ADD_FPN_ACC_R_SS <= reg_writedata(16);
         else
            field_wautoclr_DATA_FPN_ACC_ADD_FPN_ACC_R_SS <= '0';
         end if;
      end if;
   end if;
end process P_DATA_FPN_ACC_ADD_FPN_ACC_R_SS;

------------------------------------------------------------------------------------------
-- Field name: FPN_ACC_ADD(11 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_FPN_ACC_ADD(11 downto 0) <= field_rw_DATA_FPN_ACC_ADD_FPN_ACC_ADD(11 downto 0);
regfile.DATA.FPN_ACC_ADD.FPN_ACC_ADD <= field_rw_DATA_FPN_ACC_ADD_FPN_ACC_ADD(11 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DATA_FPN_ACC_ADD_FPN_ACC_ADD
------------------------------------------------------------------------------------------
P_DATA_FPN_ACC_ADD_FPN_ACC_ADD : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_FPN_ACC_ADD_FPN_ACC_ADD <= std_logic_vector(to_unsigned(integer(0),12));
      else
         for j in  11 downto 0  loop
            if(wEn(74) = '1' and bitEnN(j) = '0') then
               field_rw_DATA_FPN_ACC_ADD_FPN_ACC_ADD(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DATA_FPN_ACC_ADD_FPN_ACC_ADD;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DATA_FPN_ACC_DATA
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(75) <= (hit(75)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: FPN_ACC_R_WORKING
-- Field type: RO
------------------------------------------------------------------------------------------
rb_DATA_FPN_ACC_DATA(24) <= regfile.DATA.FPN_ACC_DATA.FPN_ACC_R_WORKING;


------------------------------------------------------------------------------------------
-- Field name: FPN_ACC_DATA(23 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_DATA_FPN_ACC_DATA(23 downto 0) <= regfile.DATA.FPN_ACC_DATA.FPN_ACC_DATA;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DATA_DPC_LIST_CTRL
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(76) <= (hit(76)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: dpc_fifo_underrun
-- Field type: RO
------------------------------------------------------------------------------------------
rb_DATA_DPC_LIST_CTRL(31) <= regfile.DATA.DPC_LIST_CTRL.dpc_fifo_underrun;


------------------------------------------------------------------------------------------
-- Field name: dpc_fifo_overrun
-- Field type: RO
------------------------------------------------------------------------------------------
rb_DATA_DPC_LIST_CTRL(30) <= regfile.DATA.DPC_LIST_CTRL.dpc_fifo_overrun;


------------------------------------------------------------------------------------------
-- Field name: dpc_fifo_reset
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_DPC_LIST_CTRL(28) <= field_rw_DATA_DPC_LIST_CTRL_dpc_fifo_reset;
regfile.DATA.DPC_LIST_CTRL.dpc_fifo_reset <= field_rw_DATA_DPC_LIST_CTRL_dpc_fifo_reset;


------------------------------------------------------------------------------------------
-- Process: P_DATA_DPC_LIST_CTRL_dpc_fifo_reset
------------------------------------------------------------------------------------------
P_DATA_DPC_LIST_CTRL_dpc_fifo_reset : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_DPC_LIST_CTRL_dpc_fifo_reset <= '0';
      else
         if(wEn(76) = '1' and bitEnN(28) = '0') then
            field_rw_DATA_DPC_LIST_CTRL_dpc_fifo_reset <= reg_writedata(28);
         end if;
      end if;
   end if;
end process P_DATA_DPC_LIST_CTRL_dpc_fifo_reset;

------------------------------------------------------------------------------------------
-- Field name: dpc_firstlast_line_rem
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_DPC_LIST_CTRL(26) <= field_rw_DATA_DPC_LIST_CTRL_dpc_firstlast_line_rem;
regfile.DATA.DPC_LIST_CTRL.dpc_firstlast_line_rem <= field_rw_DATA_DPC_LIST_CTRL_dpc_firstlast_line_rem;


------------------------------------------------------------------------------------------
-- Process: P_DATA_DPC_LIST_CTRL_dpc_firstlast_line_rem
------------------------------------------------------------------------------------------
P_DATA_DPC_LIST_CTRL_dpc_firstlast_line_rem : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_DPC_LIST_CTRL_dpc_firstlast_line_rem <= '0';
      else
         if(wEn(76) = '1' and bitEnN(26) = '0') then
            field_rw_DATA_DPC_LIST_CTRL_dpc_firstlast_line_rem <= reg_writedata(26);
         end if;
      end if;
   end if;
end process P_DATA_DPC_LIST_CTRL_dpc_firstlast_line_rem;

------------------------------------------------------------------------------------------
-- Field name: dpc_pattern0_cfg
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_DPC_LIST_CTRL(25) <= field_rw_DATA_DPC_LIST_CTRL_dpc_pattern0_cfg;
regfile.DATA.DPC_LIST_CTRL.dpc_pattern0_cfg <= field_rw_DATA_DPC_LIST_CTRL_dpc_pattern0_cfg;


------------------------------------------------------------------------------------------
-- Process: P_DATA_DPC_LIST_CTRL_dpc_pattern0_cfg
------------------------------------------------------------------------------------------
P_DATA_DPC_LIST_CTRL_dpc_pattern0_cfg : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_DPC_LIST_CTRL_dpc_pattern0_cfg <= '0';
      else
         if(wEn(76) = '1' and bitEnN(25) = '0') then
            field_rw_DATA_DPC_LIST_CTRL_dpc_pattern0_cfg <= reg_writedata(25);
         end if;
      end if;
   end if;
end process P_DATA_DPC_LIST_CTRL_dpc_pattern0_cfg;

------------------------------------------------------------------------------------------
-- Field name: dpc_enable
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_DPC_LIST_CTRL(24) <= field_rw_DATA_DPC_LIST_CTRL_dpc_enable;
regfile.DATA.DPC_LIST_CTRL.dpc_enable <= field_rw_DATA_DPC_LIST_CTRL_dpc_enable;


------------------------------------------------------------------------------------------
-- Process: P_DATA_DPC_LIST_CTRL_dpc_enable
------------------------------------------------------------------------------------------
P_DATA_DPC_LIST_CTRL_dpc_enable : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_DPC_LIST_CTRL_dpc_enable <= '0';
      else
         if(wEn(76) = '1' and bitEnN(24) = '0') then
            field_rw_DATA_DPC_LIST_CTRL_dpc_enable <= reg_writedata(24);
         end if;
      end if;
   end if;
end process P_DATA_DPC_LIST_CTRL_dpc_enable;

------------------------------------------------------------------------------------------
-- Field name: dpc_list_count(21 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_DPC_LIST_CTRL(21 downto 16) <= field_rw_DATA_DPC_LIST_CTRL_dpc_list_count(5 downto 0);
regfile.DATA.DPC_LIST_CTRL.dpc_list_count <= field_rw_DATA_DPC_LIST_CTRL_dpc_list_count(5 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DATA_DPC_LIST_CTRL_dpc_list_count
------------------------------------------------------------------------------------------
P_DATA_DPC_LIST_CTRL_dpc_list_count : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_DPC_LIST_CTRL_dpc_list_count <= std_logic_vector(to_unsigned(integer(0),6));
      else
         for j in  21 downto 16  loop
            if(wEn(76) = '1' and bitEnN(j) = '0') then
               field_rw_DATA_DPC_LIST_CTRL_dpc_list_count(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DATA_DPC_LIST_CTRL_dpc_list_count;

------------------------------------------------------------------------------------------
-- Field name: dpc_list_WRn
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_DPC_LIST_CTRL(12) <= field_rw_DATA_DPC_LIST_CTRL_dpc_list_WRn;
regfile.DATA.DPC_LIST_CTRL.dpc_list_WRn <= field_rw_DATA_DPC_LIST_CTRL_dpc_list_WRn;


------------------------------------------------------------------------------------------
-- Process: P_DATA_DPC_LIST_CTRL_dpc_list_WRn
------------------------------------------------------------------------------------------
P_DATA_DPC_LIST_CTRL_dpc_list_WRn : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_DPC_LIST_CTRL_dpc_list_WRn <= '0';
      else
         if(wEn(76) = '1' and bitEnN(12) = '0') then
            field_rw_DATA_DPC_LIST_CTRL_dpc_list_WRn <= reg_writedata(12);
         end if;
      end if;
   end if;
end process P_DATA_DPC_LIST_CTRL_dpc_list_WRn;

------------------------------------------------------------------------------------------
-- Field name: dpc_list_ss
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_DATA_DPC_LIST_CTRL(8) <= '0';
regfile.DATA.DPC_LIST_CTRL.dpc_list_ss <= field_wautoclr_DATA_DPC_LIST_CTRL_dpc_list_ss;


------------------------------------------------------------------------------------------
-- Process: P_DATA_DPC_LIST_CTRL_dpc_list_ss
------------------------------------------------------------------------------------------
P_DATA_DPC_LIST_CTRL_dpc_list_ss : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_DATA_DPC_LIST_CTRL_dpc_list_ss <= '0';
      else
         if(wEn(76) = '1' and bitEnN(8) = '0') then
            field_wautoclr_DATA_DPC_LIST_CTRL_dpc_list_ss <= reg_writedata(8);
         else
            field_wautoclr_DATA_DPC_LIST_CTRL_dpc_list_ss <= '0';
         end if;
      end if;
   end if;
end process P_DATA_DPC_LIST_CTRL_dpc_list_ss;

------------------------------------------------------------------------------------------
-- Field name: dpc_list_add(5 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_DPC_LIST_CTRL(5 downto 0) <= field_rw_DATA_DPC_LIST_CTRL_dpc_list_add(5 downto 0);
regfile.DATA.DPC_LIST_CTRL.dpc_list_add <= field_rw_DATA_DPC_LIST_CTRL_dpc_list_add(5 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DATA_DPC_LIST_CTRL_dpc_list_add
------------------------------------------------------------------------------------------
P_DATA_DPC_LIST_CTRL_dpc_list_add : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_DPC_LIST_CTRL_dpc_list_add <= std_logic_vector(to_unsigned(integer(0),6));
      else
         for j in  5 downto 0  loop
            if(wEn(76) = '1' and bitEnN(j) = '0') then
               field_rw_DATA_DPC_LIST_CTRL_dpc_list_add(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DATA_DPC_LIST_CTRL_dpc_list_add;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DATA_DPC_LIST_DATA
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(77) <= (hit(77)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: dpc_list_corr_pattern(31 downto 24)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_DPC_LIST_DATA(31 downto 24) <= field_rw_DATA_DPC_LIST_DATA_dpc_list_corr_pattern(7 downto 0);
regfile.DATA.DPC_LIST_DATA.dpc_list_corr_pattern <= field_rw_DATA_DPC_LIST_DATA_dpc_list_corr_pattern(7 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DATA_DPC_LIST_DATA_dpc_list_corr_pattern
------------------------------------------------------------------------------------------
P_DATA_DPC_LIST_DATA_dpc_list_corr_pattern : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_DPC_LIST_DATA_dpc_list_corr_pattern <= std_logic_vector(to_unsigned(integer(0),8));
      else
         for j in  31 downto 24  loop
            if(wEn(77) = '1' and bitEnN(j) = '0') then
               field_rw_DATA_DPC_LIST_DATA_dpc_list_corr_pattern(j-24) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DATA_DPC_LIST_DATA_dpc_list_corr_pattern;

------------------------------------------------------------------------------------------
-- Field name: dpc_list_corr_y(23 downto 12)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_DPC_LIST_DATA(23 downto 12) <= field_rw_DATA_DPC_LIST_DATA_dpc_list_corr_y(11 downto 0);
regfile.DATA.DPC_LIST_DATA.dpc_list_corr_y <= field_rw_DATA_DPC_LIST_DATA_dpc_list_corr_y(11 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DATA_DPC_LIST_DATA_dpc_list_corr_y
------------------------------------------------------------------------------------------
P_DATA_DPC_LIST_DATA_dpc_list_corr_y : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_DPC_LIST_DATA_dpc_list_corr_y <= std_logic_vector(to_unsigned(integer(0),12));
      else
         for j in  23 downto 12  loop
            if(wEn(77) = '1' and bitEnN(j) = '0') then
               field_rw_DATA_DPC_LIST_DATA_dpc_list_corr_y(j-12) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DATA_DPC_LIST_DATA_dpc_list_corr_y;

------------------------------------------------------------------------------------------
-- Field name: dpc_list_corr_x(11 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_DATA_DPC_LIST_DATA(11 downto 0) <= field_rw_DATA_DPC_LIST_DATA_dpc_list_corr_x(11 downto 0);
regfile.DATA.DPC_LIST_DATA.dpc_list_corr_x <= field_rw_DATA_DPC_LIST_DATA_dpc_list_corr_x(11 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_DATA_DPC_LIST_DATA_dpc_list_corr_x
------------------------------------------------------------------------------------------
P_DATA_DPC_LIST_DATA_dpc_list_corr_x : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_DATA_DPC_LIST_DATA_dpc_list_corr_x <= std_logic_vector(to_unsigned(integer(0),12));
      else
         for j in  11 downto 0  loop
            if(wEn(77) = '1' and bitEnN(j) = '0') then
               field_rw_DATA_DPC_LIST_DATA_dpc_list_corr_x(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_DATA_DPC_LIST_DATA_dpc_list_corr_x;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: DATA_DPC_LIST_DATA_RD
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(78) <= (hit(78)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: dpc_list_corr_pattern(7 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_DATA_DPC_LIST_DATA_RD(31 downto 24) <= regfile.DATA.DPC_LIST_DATA_RD.dpc_list_corr_pattern;


------------------------------------------------------------------------------------------
-- Field name: dpc_list_corr_y(11 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_DATA_DPC_LIST_DATA_RD(23 downto 12) <= regfile.DATA.DPC_LIST_DATA_RD.dpc_list_corr_y;


------------------------------------------------------------------------------------------
-- Field name: dpc_list_corr_x(11 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_DATA_DPC_LIST_DATA_RD(11 downto 0) <= regfile.DATA.DPC_LIST_DATA_RD.dpc_list_corr_x;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: HISPI_CTRL
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(79) <= (hit(79)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: CLR
-- Field type: RW
------------------------------------------------------------------------------------------
rb_HISPI_CTRL(1) <= field_rw_HISPI_CTRL_CLR;
regfile.HISPI.CTRL.CLR <= field_rw_HISPI_CTRL_CLR;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_CTRL_CLR
------------------------------------------------------------------------------------------
P_HISPI_CTRL_CLR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_HISPI_CTRL_CLR <= '0';
      else
         if(wEn(79) = '1' and bitEnN(1) = '0') then
            field_rw_HISPI_CTRL_CLR <= reg_writedata(1);
         end if;
      end if;
   end if;
end process P_HISPI_CTRL_CLR;

------------------------------------------------------------------------------------------
-- Field name: RESET_IDELAYCTRL
-- Field type: RW
------------------------------------------------------------------------------------------
rb_HISPI_CTRL(0) <= field_rw_HISPI_CTRL_RESET_IDELAYCTRL;
regfile.HISPI.CTRL.RESET_IDELAYCTRL <= field_rw_HISPI_CTRL_RESET_IDELAYCTRL;


------------------------------------------------------------------------------------------
-- Process: P_HISPI_CTRL_RESET_IDELAYCTRL
------------------------------------------------------------------------------------------
P_HISPI_CTRL_RESET_IDELAYCTRL : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_HISPI_CTRL_RESET_IDELAYCTRL <= '0';
      else
         if(wEn(79) = '1' and bitEnN(0) = '0') then
            field_rw_HISPI_CTRL_RESET_IDELAYCTRL <= reg_writedata(0);
         end if;
      end if;
   end if;
end process P_HISPI_CTRL_RESET_IDELAYCTRL;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: HISPI_STATUS
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(80) <= (hit(80)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: PLL_LOCKED
-- Field type: RO
------------------------------------------------------------------------------------------
rb_HISPI_STATUS(0) <= regfile.HISPI.STATUS.PLL_LOCKED;


ldData <= reg_read;

end rtl;

