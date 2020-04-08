-------------------------------------------------------------------------------
-- File                : regfile_xgs_ctrl.vhd
-- Project             : FDK
-- Module              : regfile_xgs_ctrl_pack
-- Created on          : 2020/04/08 09:30:17
-- Created by          : jmansill
-- FDK IDE Version     : 4.7.0_beta3
-- Build ID            : I20191219-1127
-- Register file CRC32 : 0xC931B2A2
-------------------------------------------------------------------------------
library ieee;        -- The standard IEEE library
   use ieee.std_logic_1164.all  ;
   use ieee.numeric_std.all     ;
   use ieee.std_logic_unsigned.all;


package regfile_xgs_ctrl_pack is
   --------------------------------------------------------------------------------
   -- Address constants
   --------------------------------------------------------------------------------
   constant K_SYSTEM_ID_ADDR                 : natural := 16#0#;
   constant K_SYSTEM_ACQ_CAP_ADDR            : natural := 16#30#;
   constant K_ACQ_GRAB_CTRL_ADDR             : natural := 16#100#;
   constant K_ACQ_GRAB_STAT_ADDR             : natural := 16#108#;
   constant K_ACQ_READOUT_CFG1_ADDR          : natural := 16#110#;
   constant K_ACQ_READOUT_CFG_FRAME_LINE_ADDR : natural := 16#114#;
   constant K_ACQ_READOUT_CFG2_ADDR          : natural := 16#118#;
   constant K_ACQ_READOUT_CFG3_ADDR          : natural := 16#120#;
   constant K_ACQ_READOUT_CFG4_ADDR          : natural := 16#124#;
   constant K_ACQ_EXP_CTRL1_ADDR             : natural := 16#128#;
   constant K_ACQ_EXP_CTRL2_ADDR             : natural := 16#130#;
   constant K_ACQ_EXP_CTRL3_ADDR             : natural := 16#138#;
   constant K_ACQ_TRIGGER_DELAY_ADDR         : natural := 16#140#;
   constant K_ACQ_STROBE_CTRL1_ADDR          : natural := 16#148#;
   constant K_ACQ_STROBE_CTRL2_ADDR          : natural := 16#150#;
   constant K_ACQ_ACQ_SER_CTRL_ADDR          : natural := 16#158#;
   constant K_ACQ_ACQ_SER_ADDATA_ADDR        : natural := 16#160#;
   constant K_ACQ_ACQ_SER_STAT_ADDR          : natural := 16#168#;
   constant K_ACQ_SENSOR_CTRL_ADDR           : natural := 16#190#;
   constant K_ACQ_SENSOR_STAT_ADDR           : natural := 16#198#;
   constant K_ACQ_SENSOR_SUBSAMPLING_ADDR    : natural := 16#1a0#;
   constant K_ACQ_SENSOR_GAIN_ANA_ADDR       : natural := 16#1a4#;
   constant K_ACQ_SENSOR_ROI_Y_START_ADDR    : natural := 16#1a8#;
   constant K_ACQ_SENSOR_ROI_Y_SIZE_ADDR     : natural := 16#1ac#;
   constant K_ACQ_SENSOR_ROI2_Y_START_ADDR   : natural := 16#1b0#;
   constant K_ACQ_SENSOR_ROI2_Y_SIZE_ADDR    : natural := 16#1b4#;
   constant K_ACQ_SENSOR_M_LINES_ADDR        : natural := 16#1d8#;
   constant K_ACQ_SENSOR_F_LINES_ADDR        : natural := 16#1dc#;
   constant K_ACQ_DEBUG_PINS_ADDR            : natural := 16#1e0#;
   constant K_ACQ_TRIGGER_MISSED_ADDR        : natural := 16#1e8#;
   constant K_ACQ_SENSOR_FPS_ADDR            : natural := 16#1f0#;
   constant K_ACQ_DEBUG_ADDR                 : natural := 16#2a0#;
   constant K_ACQ_DEBUG_CNTR1_ADDR           : natural := 16#2a8#;
   constant K_ACQ_DEBUG_CNTR2_ADDR           : natural := 16#2b0#;
   constant K_ACQ_DEBUG_CNTR3_ADDR           : natural := 16#2b4#;
   constant K_ACQ_EXP_FOT_ADDR               : natural := 16#2b8#;
   constant K_ACQ_ACQ_SFNC_ADDR              : natural := 16#2c0#;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: ID
   ------------------------------------------------------------------------------------------
   type SYSTEM_ID_TYPE is record
      StaticID       : std_logic_vector(31 downto 0);
   end record SYSTEM_ID_TYPE;

   constant INIT_SYSTEM_ID_TYPE : SYSTEM_ID_TYPE := (
      StaticID        => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : SYSTEM_ID_TYPE) return std_logic_vector;
   function to_SYSTEM_ID_TYPE(stdlv : std_logic_vector(31 downto 0)) return SYSTEM_ID_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: ACQ_CAP
   ------------------------------------------------------------------------------------------
   type SYSTEM_ACQ_CAP_TYPE is record
      DPC            : std_logic;
      EXP_FOT        : std_logic;
      FPN_73         : std_logic;
      COLOR          : std_logic;
      CH_LVDS        : std_logic_vector(3 downto 0);
      LUT_WIDTH      : std_logic;
      LUT_PALETTE    : std_logic_vector(1 downto 0);
   end record SYSTEM_ACQ_CAP_TYPE;

   constant INIT_SYSTEM_ACQ_CAP_TYPE : SYSTEM_ACQ_CAP_TYPE := (
      DPC             => 'Z',
      EXP_FOT         => 'Z',
      FPN_73          => 'Z',
      COLOR           => 'Z',
      CH_LVDS         => (others=> 'Z'),
      LUT_WIDTH       => 'Z',
      LUT_PALETTE     => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : SYSTEM_ACQ_CAP_TYPE) return std_logic_vector;
   function to_SYSTEM_ACQ_CAP_TYPE(stdlv : std_logic_vector(31 downto 0)) return SYSTEM_ACQ_CAP_TYPE;
   
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
      GRAB_REVX_OVER_RST: std_logic;
      GRAB_REVX_OVER : std_logic;
      GRAB_REVX      : std_logic;
      ROT_LENGTH     : std_logic_vector(9 downto 0);
      FOT_LENGTH     : std_logic_vector(15 downto 0);
   end record ACQ_READOUT_CFG1_TYPE;

   constant INIT_ACQ_READOUT_CFG1_TYPE : ACQ_READOUT_CFG1_TYPE := (
      GRAB_REVX_OVER_RST => 'Z',
      GRAB_REVX_OVER  => 'Z',
      GRAB_REVX       => 'Z',
      ROT_LENGTH      => (others=> 'Z'),
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
      KEEP_OUT_TRIG_ENA: std_logic;
      LINE_TIME      : std_logic_vector(15 downto 0);
   end record ACQ_READOUT_CFG3_TYPE;

   constant INIT_ACQ_READOUT_CFG3_TYPE : ACQ_READOUT_CFG3_TYPE := (
      KEEP_OUT_TRIG_ENA => 'Z',
      LINE_TIME       => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_READOUT_CFG3_TYPE) return std_logic_vector;
   function to_ACQ_READOUT_CFG3_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_READOUT_CFG3_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: READOUT_CFG4
   ------------------------------------------------------------------------------------------
   type ACQ_READOUT_CFG4_TYPE is record
      KEEP_OUT_TRIG_END: std_logic_vector(15 downto 0);
      KEEP_OUT_TRIG_START: std_logic_vector(15 downto 0);
   end record ACQ_READOUT_CFG4_TYPE;

   constant INIT_ACQ_READOUT_CFG4_TYPE : ACQ_READOUT_CFG4_TYPE := (
      KEEP_OUT_TRIG_END => (others=> 'Z'),
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
      SENSOR_REG_UPTATE: std_logic;
      SENSOR_RESETN  : std_logic;
      SENSOR_POWERUP : std_logic;
   end record ACQ_SENSOR_CTRL_TYPE;

   constant INIT_ACQ_SENSOR_CTRL_TYPE : ACQ_SENSOR_CTRL_TYPE := (
      SENSOR_REFRESH_TEMP => 'Z',
      SENSOR_POWERDOWN => 'Z',
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
   -- Register Name: SENSOR_ROI2_Y_START
   ------------------------------------------------------------------------------------------
   type ACQ_SENSOR_ROI2_Y_START_TYPE is record
      reserved       : std_logic_vector(5 downto 0);
      Y_START        : std_logic_vector(9 downto 0);
   end record ACQ_SENSOR_ROI2_Y_START_TYPE;

   constant INIT_ACQ_SENSOR_ROI2_Y_START_TYPE : ACQ_SENSOR_ROI2_Y_START_TYPE := (
      reserved        => (others=> 'Z'),
      Y_START         => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_SENSOR_ROI2_Y_START_TYPE) return std_logic_vector;
   function to_ACQ_SENSOR_ROI2_Y_START_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_ROI2_Y_START_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: SENSOR_ROI2_Y_SIZE
   ------------------------------------------------------------------------------------------
   type ACQ_SENSOR_ROI2_Y_SIZE_TYPE is record
      reserved       : std_logic_vector(5 downto 0);
      Y_SIZE         : std_logic_vector(9 downto 0);
   end record ACQ_SENSOR_ROI2_Y_SIZE_TYPE;

   constant INIT_ACQ_SENSOR_ROI2_Y_SIZE_TYPE : ACQ_SENSOR_ROI2_Y_SIZE_TYPE := (
      reserved        => (others=> 'Z'),
      Y_SIZE          => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_SENSOR_ROI2_Y_SIZE_TYPE) return std_logic_vector;
   function to_ACQ_SENSOR_ROI2_Y_SIZE_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_ROI2_Y_SIZE_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: SENSOR_M_LINES
   ------------------------------------------------------------------------------------------
   type ACQ_SENSOR_M_LINES_TYPE is record
      M_SUPPRESSED   : std_logic_vector(4 downto 0);
      M_LINES_SENSOR : std_logic_vector(9 downto 0);
   end record ACQ_SENSOR_M_LINES_TYPE;

   constant INIT_ACQ_SENSOR_M_LINES_TYPE : ACQ_SENSOR_M_LINES_TYPE := (
      M_SUPPRESSED    => (others=> 'Z'),
      M_LINES_SENSOR  => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_SENSOR_M_LINES_TYPE) return std_logic_vector;
   function to_ACQ_SENSOR_M_LINES_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_M_LINES_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: SENSOR_F_LINES
   ------------------------------------------------------------------------------------------
   type ACQ_SENSOR_F_LINES_TYPE is record
      F_SUPPRESSED   : std_logic_vector(4 downto 0);
      F_LINES_SENSOR : std_logic_vector(9 downto 0);
   end record ACQ_SENSOR_F_LINES_TYPE;

   constant INIT_ACQ_SENSOR_F_LINES_TYPE : ACQ_SENSOR_F_LINES_TYPE := (
      F_SUPPRESSED    => (others=> 'Z'),
      F_LINES_SENSOR  => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ACQ_SENSOR_F_LINES_TYPE) return std_logic_vector;
   function to_ACQ_SENSOR_F_LINES_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_F_LINES_TYPE;
   
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
      LED_STAT_CLHS  : std_logic_vector(1 downto 0);
      LED_STAT_CTRL  : std_logic_vector(1 downto 0);
      LED_TEST_COLOR : std_logic_vector(1 downto 0);
      LED_TEST       : std_logic;
   end record ACQ_DEBUG_TYPE;

   constant INIT_ACQ_DEBUG_TYPE : ACQ_DEBUG_TYPE := (
      DEBUG_RST_CNTR  => 'Z',
      TEST_MODE_PIX_START => (others=> 'Z'),
      TEST_MOVE       => 'Z',
      TEST_MODE       => 'Z',
      LED_STAT_CLHS   => (others=> 'Z'),
      LED_STAT_CTRL   => (others=> 'Z'),
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
   -- Section Name: SYSTEM
   ------------------------------------------------------------------------------------------
   type SYSTEM_TYPE is record
      ID             : SYSTEM_ID_TYPE;
      ACQ_CAP        : SYSTEM_ACQ_CAP_TYPE;
   end record SYSTEM_TYPE;

   constant INIT_SYSTEM_TYPE : SYSTEM_TYPE := (
      ID              => INIT_SYSTEM_ID_TYPE,
      ACQ_CAP         => INIT_SYSTEM_ACQ_CAP_TYPE
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
      SENSOR_ROI2_Y_START: ACQ_SENSOR_ROI2_Y_START_TYPE;
      SENSOR_ROI2_Y_SIZE: ACQ_SENSOR_ROI2_Y_SIZE_TYPE;
      SENSOR_M_LINES : ACQ_SENSOR_M_LINES_TYPE;
      SENSOR_F_LINES : ACQ_SENSOR_F_LINES_TYPE;
      DEBUG_PINS     : ACQ_DEBUG_PINS_TYPE;
      TRIGGER_MISSED : ACQ_TRIGGER_MISSED_TYPE;
      SENSOR_FPS     : ACQ_SENSOR_FPS_TYPE;
      DEBUG          : ACQ_DEBUG_TYPE;
      DEBUG_CNTR1    : ACQ_DEBUG_CNTR1_TYPE;
      DEBUG_CNTR2    : ACQ_DEBUG_CNTR2_TYPE;
      DEBUG_CNTR3    : ACQ_DEBUG_CNTR3_TYPE;
      EXP_FOT        : ACQ_EXP_FOT_TYPE;
      ACQ_SFNC       : ACQ_ACQ_SFNC_TYPE;
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
      SENSOR_ROI2_Y_START => INIT_ACQ_SENSOR_ROI2_Y_START_TYPE,
      SENSOR_ROI2_Y_SIZE => INIT_ACQ_SENSOR_ROI2_Y_SIZE_TYPE,
      SENSOR_M_LINES  => INIT_ACQ_SENSOR_M_LINES_TYPE,
      SENSOR_F_LINES  => INIT_ACQ_SENSOR_F_LINES_TYPE,
      DEBUG_PINS      => INIT_ACQ_DEBUG_PINS_TYPE,
      TRIGGER_MISSED  => INIT_ACQ_TRIGGER_MISSED_TYPE,
      SENSOR_FPS      => INIT_ACQ_SENSOR_FPS_TYPE,
      DEBUG           => INIT_ACQ_DEBUG_TYPE,
      DEBUG_CNTR1     => INIT_ACQ_DEBUG_CNTR1_TYPE,
      DEBUG_CNTR2     => INIT_ACQ_DEBUG_CNTR2_TYPE,
      DEBUG_CNTR3     => INIT_ACQ_DEBUG_CNTR3_TYPE,
      EXP_FOT         => INIT_ACQ_EXP_FOT_TYPE,
      ACQ_SFNC        => INIT_ACQ_ACQ_SFNC_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Register file name: regfile_xgs_ctrl
   ------------------------------------------------------------------------------------------
   type REGFILE_XGS_CTRL_TYPE is record
      SYSTEM         : SYSTEM_TYPE;
      ACQ            : ACQ_TYPE;
   end record REGFILE_XGS_CTRL_TYPE;

   constant INIT_REGFILE_XGS_CTRL_TYPE : REGFILE_XGS_CTRL_TYPE := (
      SYSTEM          => INIT_SYSTEM_TYPE,
      ACQ             => INIT_ACQ_TYPE
   );

   
end regfile_xgs_ctrl_pack;

package body regfile_xgs_ctrl_pack is
   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from SYSTEM_ID_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : SYSTEM_ID_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.StaticID;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_SYSTEM_ID_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to SYSTEM_ID_TYPE
   --------------------------------------------------------------------------------
   function to_SYSTEM_ID_TYPE(stdlv : std_logic_vector(31 downto 0)) return SYSTEM_ID_TYPE is
   variable output : SYSTEM_ID_TYPE;
   begin
      output.StaticID := stdlv(31 downto 0);
      return output;
   end to_SYSTEM_ID_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from SYSTEM_ACQ_CAP_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : SYSTEM_ACQ_CAP_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(15) := reg.DPC;
      output(14) := reg.EXP_FOT;
      output(13) := reg.FPN_73;
      output(12) := reg.COLOR;
      output(11 downto 8) := reg.CH_LVDS;
      output(4) := reg.LUT_WIDTH;
      output(1 downto 0) := reg.LUT_PALETTE;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_SYSTEM_ACQ_CAP_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to SYSTEM_ACQ_CAP_TYPE
   --------------------------------------------------------------------------------
   function to_SYSTEM_ACQ_CAP_TYPE(stdlv : std_logic_vector(31 downto 0)) return SYSTEM_ACQ_CAP_TYPE is
   variable output : SYSTEM_ACQ_CAP_TYPE;
   begin
      output.DPC := stdlv(15);
      output.EXP_FOT := stdlv(14);
      output.FPN_73 := stdlv(13);
      output.COLOR := stdlv(12);
      output.CH_LVDS := stdlv(11 downto 8);
      output.LUT_WIDTH := stdlv(4);
      output.LUT_PALETTE := stdlv(1 downto 0);
      return output;
   end to_SYSTEM_ACQ_CAP_TYPE;

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
      output(30) := reg.GRAB_REVX_OVER_RST;
      output(29) := reg.GRAB_REVX_OVER;
      output(28) := reg.GRAB_REVX;
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
      output.GRAB_REVX_OVER_RST := stdlv(30);
      output.GRAB_REVX_OVER := stdlv(29);
      output.GRAB_REVX := stdlv(28);
      output.ROT_LENGTH := stdlv(25 downto 16);
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
      output(16) := reg.KEEP_OUT_TRIG_ENA;
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
      output.KEEP_OUT_TRIG_ENA := stdlv(16);
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
      output(31 downto 16) := reg.KEEP_OUT_TRIG_END;
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
      output.KEEP_OUT_TRIG_END := stdlv(31 downto 16);
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
   -- Description: Cast from ACQ_SENSOR_ROI2_Y_START_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_SENSOR_ROI2_Y_START_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(15 downto 10) := reg.reserved;
      output(9 downto 0) := reg.Y_START;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_SENSOR_ROI2_Y_START_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_SENSOR_ROI2_Y_START_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_SENSOR_ROI2_Y_START_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_ROI2_Y_START_TYPE is
   variable output : ACQ_SENSOR_ROI2_Y_START_TYPE;
   begin
      output.reserved := stdlv(15 downto 10);
      output.Y_START := stdlv(9 downto 0);
      return output;
   end to_ACQ_SENSOR_ROI2_Y_START_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_SENSOR_ROI2_Y_SIZE_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_SENSOR_ROI2_Y_SIZE_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(15 downto 10) := reg.reserved;
      output(9 downto 0) := reg.Y_SIZE;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_SENSOR_ROI2_Y_SIZE_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_SENSOR_ROI2_Y_SIZE_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_SENSOR_ROI2_Y_SIZE_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_ROI2_Y_SIZE_TYPE is
   variable output : ACQ_SENSOR_ROI2_Y_SIZE_TYPE;
   begin
      output.reserved := stdlv(15 downto 10);
      output.Y_SIZE := stdlv(9 downto 0);
      return output;
   end to_ACQ_SENSOR_ROI2_Y_SIZE_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_SENSOR_M_LINES_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_SENSOR_M_LINES_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
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
      output.M_SUPPRESSED := stdlv(14 downto 10);
      output.M_LINES_SENSOR := stdlv(9 downto 0);
      return output;
   end to_ACQ_SENSOR_M_LINES_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ACQ_SENSOR_F_LINES_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ACQ_SENSOR_F_LINES_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(14 downto 10) := reg.F_SUPPRESSED;
      output(9 downto 0) := reg.F_LINES_SENSOR;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ACQ_SENSOR_F_LINES_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ACQ_SENSOR_F_LINES_TYPE
   --------------------------------------------------------------------------------
   function to_ACQ_SENSOR_F_LINES_TYPE(stdlv : std_logic_vector(31 downto 0)) return ACQ_SENSOR_F_LINES_TYPE is
   variable output : ACQ_SENSOR_F_LINES_TYPE;
   begin
      output.F_SUPPRESSED := stdlv(14 downto 10);
      output.F_LINES_SENSOR := stdlv(9 downto 0);
      return output;
   end to_ACQ_SENSOR_F_LINES_TYPE;

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
      output(7 downto 6) := reg.LED_STAT_CLHS;
      output(5 downto 4) := reg.LED_STAT_CTRL;
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
      output.LED_STAT_CLHS := stdlv(7 downto 6);
      output.LED_STAT_CTRL := stdlv(5 downto 4);
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

   
end package body;


-------------------------------------------------------------------------------
-- File                : regfile_xgs_ctrl.vhd
-- Project             : FDK
-- Module              : regfile_xgs_ctrl
-- Created on          : 2020/04/08 09:30:17
-- Created by          : jmansill
-- FDK IDE Version     : 4.7.0_beta3
-- Build ID            : I20191219-1127
-- Register file CRC32 : 0xC931B2A2
-------------------------------------------------------------------------------
-- The standard IEEE library
library ieee;
   use ieee.std_logic_1164.all; 
   use ieee.numeric_std.all;    
   use ieee.std_logic_unsigned.all;

-- Work library
library work;
   use work.regfile_xgs_ctrl_pack.all;


entity regfile_xgs_ctrl is
   
   port (
      resetN        : in    std_logic;                                           -- System reset
      sysclk        : in    std_logic;                                           -- System clock
      regfile       : inout REGFILE_XGS_CTRL_TYPE := INIT_REGFILE_XGS_CTRL_TYPE; -- Register file
      ------------------------------------------------------------------------------------
      -- Interface name: registerFileIF
      -- Description: 
      ------------------------------------------------------------------------------------
      reg_read      : in    std_logic;                                           -- Read
      reg_write     : in    std_logic;                                           -- Write
      reg_addr      : in    std_logic_vector(11 downto 2);                       -- Address
      reg_beN       : in    std_logic_vector(3 downto 0);                        -- Byte enable
      reg_writedata : in    std_logic_vector(31 downto 0);                       -- Write data
      reg_readdata  : out   std_logic_vector(31 downto 0)                        -- Read data
   );
   
end regfile_xgs_ctrl;

architecture rtl of regfile_xgs_ctrl is
------------------------------------------------------------------------------------------
-- Signals declaration
------------------------------------------------------------------------------------------
signal readBackMux                                          : std_logic_vector(31 downto 0);                   -- Data readback multiplexer
signal hit                                                  : std_logic_vector(36 downto 0);                   -- Address decode hit
signal wEn                                                  : std_logic_vector(36 downto 0);                   -- Write Enable
signal fullAddr                                             : std_logic_vector(11 downto 0):= (others => '0'); -- Full Address
signal fullAddrAsInt                                        : integer;                                        
signal bitEnN                                               : std_logic_vector(31 downto 0);                   -- Bits enable
signal ldData                                               : std_logic;                                      
signal rb_SYSTEM_ID                                         : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_SYSTEM_ACQ_CAP                                    : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_GRAB_CTRL                                     : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_GRAB_STAT                                     : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_READOUT_CFG1                                  : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_READOUT_CFG_FRAME_LINE                        : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_READOUT_CFG2                                  : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_READOUT_CFG3                                  : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_READOUT_CFG4                                  : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_EXP_CTRL1                                     : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_EXP_CTRL2                                     : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_EXP_CTRL3                                     : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_TRIGGER_DELAY                                 : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_STROBE_CTRL1                                  : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_STROBE_CTRL2                                  : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_ACQ_SER_CTRL                                  : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_ACQ_SER_ADDATA                                : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_ACQ_SER_STAT                                  : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_CTRL                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_STAT                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_SUBSAMPLING                            : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_GAIN_ANA                               : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_ROI_Y_START                            : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_ROI_Y_SIZE                             : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_ROI2_Y_START                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_ROI2_Y_SIZE                            : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_M_LINES                                : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_F_LINES                                : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_DEBUG_PINS                                    : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_TRIGGER_MISSED                                : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_SENSOR_FPS                                    : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_DEBUG                                         : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_DEBUG_CNTR1                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_DEBUG_CNTR2                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_DEBUG_CNTR3                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_EXP_FOT                                       : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_ACQ_ACQ_SFNC                                      : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal field_rw_ACQ_GRAB_CTRL_RESET_GRAB                    : std_logic;                                       -- Field: RESET_GRAB
signal field_rw_ACQ_GRAB_CTRL_GRAB_ROI2_EN                  : std_logic;                                       -- Field: GRAB_ROI2_EN
signal field_wautoclr_ACQ_GRAB_CTRL_ABORT_GRAB              : std_logic;                                       -- Field: ABORT_GRAB
signal field_rw_ACQ_GRAB_CTRL_TRIGGER_OVERLAP_BUFFn         : std_logic;                                       -- Field: TRIGGER_OVERLAP_BUFFn
signal field_rw_ACQ_GRAB_CTRL_TRIGGER_OVERLAP               : std_logic;                                       -- Field: TRIGGER_OVERLAP
signal field_rw_ACQ_GRAB_CTRL_TRIGGER_ACT                   : std_logic_vector(2 downto 0);                    -- Field: TRIGGER_ACT
signal field_rw_ACQ_GRAB_CTRL_TRIGGER_SRC                   : std_logic_vector(2 downto 0);                    -- Field: TRIGGER_SRC
signal field_wautoclr_ACQ_GRAB_CTRL_GRAB_SS                 : std_logic;                                       -- Field: GRAB_SS
signal field_rw_ACQ_GRAB_CTRL_BUFFER_ID                     : std_logic;                                       -- Field: BUFFER_ID
signal field_wautoclr_ACQ_GRAB_CTRL_GRAB_CMD                : std_logic;                                       -- Field: GRAB_CMD
signal field_wautoclr_ACQ_READOUT_CFG1_GRAB_REVX_OVER_RST   : std_logic;                                       -- Field: GRAB_REVX_OVER_RST
signal field_rw_ACQ_READOUT_CFG1_GRAB_REVX                  : std_logic;                                       -- Field: GRAB_REVX
signal field_rw_ACQ_READOUT_CFG_FRAME_LINE_DUMMY_LINES      : std_logic_vector(7 downto 0);                    -- Field: DUMMY_LINES
signal field_rw_ACQ_READOUT_CFG3_KEEP_OUT_TRIG_ENA          : std_logic;                                       -- Field: KEEP_OUT_TRIG_ENA
signal field_rw_ACQ_READOUT_CFG3_LINE_TIME                  : std_logic_vector(15 downto 0);                   -- Field: LINE_TIME
signal field_rw_ACQ_READOUT_CFG4_KEEP_OUT_TRIG_END          : std_logic_vector(15 downto 0);                   -- Field: KEEP_OUT_TRIG_END
signal field_rw_ACQ_READOUT_CFG4_KEEP_OUT_TRIG_START        : std_logic_vector(15 downto 0);                   -- Field: KEEP_OUT_TRIG_START
signal field_rw_ACQ_EXP_CTRL1_EXPOSURE_LEV_MODE             : std_logic;                                       -- Field: EXPOSURE_LEV_MODE
signal field_rw_ACQ_EXP_CTRL1_EXPOSURE_SS                   : std_logic_vector(27 downto 0);                   -- Field: EXPOSURE_SS
signal field_rw_ACQ_EXP_CTRL2_EXPOSURE_DS                   : std_logic_vector(27 downto 0);                   -- Field: EXPOSURE_DS
signal field_rw_ACQ_EXP_CTRL3_EXPOSURE_TS                   : std_logic_vector(27 downto 0);                   -- Field: EXPOSURE_TS
signal field_rw_ACQ_TRIGGER_DELAY_TRIGGER_DELAY             : std_logic_vector(27 downto 0);                   -- Field: TRIGGER_DELAY
signal field_rw_ACQ_STROBE_CTRL1_STROBE_E                   : std_logic;                                       -- Field: STROBE_E
signal field_rw_ACQ_STROBE_CTRL1_STROBE_POL                 : std_logic;                                       -- Field: STROBE_POL
signal field_rw_ACQ_STROBE_CTRL1_STROBE_START               : std_logic_vector(27 downto 0);                   -- Field: STROBE_START
signal field_rw_ACQ_STROBE_CTRL2_STROBE_MODE                : std_logic;                                       -- Field: STROBE_MODE
signal field_rw_ACQ_STROBE_CTRL2_STROBE_B_EN                : std_logic;                                       -- Field: STROBE_B_EN
signal field_rw_ACQ_STROBE_CTRL2_STROBE_A_EN                : std_logic;                                       -- Field: STROBE_A_EN
signal field_rw_ACQ_STROBE_CTRL2_STROBE_END                 : std_logic_vector(27 downto 0);                   -- Field: STROBE_END
signal field_rw_ACQ_ACQ_SER_CTRL_SER_RWn                    : std_logic;                                       -- Field: SER_RWn
signal field_rw_ACQ_ACQ_SER_CTRL_SER_CMD                    : std_logic_vector(1 downto 0);                    -- Field: SER_CMD
signal field_wautoclr_ACQ_ACQ_SER_CTRL_SER_RF_SS            : std_logic;                                       -- Field: SER_RF_SS
signal field_wautoclr_ACQ_ACQ_SER_CTRL_SER_WF_SS            : std_logic;                                       -- Field: SER_WF_SS
signal field_rw_ACQ_ACQ_SER_ADDATA_SER_DAT                  : std_logic_vector(15 downto 0);                   -- Field: SER_DAT
signal field_rw_ACQ_ACQ_SER_ADDATA_SER_ADD                  : std_logic_vector(14 downto 0);                   -- Field: SER_ADD
signal field_wautoclr_ACQ_SENSOR_CTRL_SENSOR_REFRESH_TEMP   : std_logic;                                       -- Field: SENSOR_REFRESH_TEMP
signal field_wautoclr_ACQ_SENSOR_CTRL_SENSOR_POWERDOWN      : std_logic;                                       -- Field: SENSOR_POWERDOWN
signal field_rw_ACQ_SENSOR_CTRL_SENSOR_COLOR                : std_logic;                                       -- Field: SENSOR_COLOR
signal field_rw_ACQ_SENSOR_CTRL_SENSOR_REG_UPTATE           : std_logic;                                       -- Field: SENSOR_REG_UPTATE
signal field_rw_ACQ_SENSOR_CTRL_SENSOR_RESETN               : std_logic;                                       -- Field: SENSOR_RESETN
signal field_wautoclr_ACQ_SENSOR_CTRL_SENSOR_POWERUP        : std_logic;                                       -- Field: SENSOR_POWERUP
signal field_rw_ACQ_SENSOR_SUBSAMPLING_ACTIVE_SUBSAMPLING_Y : std_logic;                                       -- Field: ACTIVE_SUBSAMPLING_Y
signal field_rw_ACQ_SENSOR_SUBSAMPLING_M_SUBSAMPLING_Y      : std_logic;                                       -- Field: M_SUBSAMPLING_Y
signal field_rw_ACQ_SENSOR_SUBSAMPLING_SUBSAMPLING_X        : std_logic;                                       -- Field: SUBSAMPLING_X
signal field_rw_ACQ_SENSOR_GAIN_ANA_ANALOG_GAIN             : std_logic_vector(2 downto 0);                    -- Field: ANALOG_GAIN
signal field_rw_ACQ_SENSOR_ROI_Y_START_Y_START              : std_logic_vector(9 downto 0);                    -- Field: Y_START
signal field_rw_ACQ_SENSOR_ROI_Y_SIZE_Y_SIZE                : std_logic_vector(9 downto 0);                    -- Field: Y_SIZE
signal field_rw_ACQ_SENSOR_ROI2_Y_START_Y_START             : std_logic_vector(9 downto 0);                    -- Field: Y_START
signal field_rw_ACQ_SENSOR_ROI2_Y_SIZE_Y_SIZE               : std_logic_vector(9 downto 0);                    -- Field: Y_SIZE
signal field_rw_ACQ_SENSOR_M_LINES_M_SUPPRESSED             : std_logic_vector(4 downto 0);                    -- Field: M_SUPPRESSED
signal field_rw_ACQ_SENSOR_M_LINES_M_LINES_SENSOR           : std_logic_vector(9 downto 0);                    -- Field: M_LINES_SENSOR
signal field_rw_ACQ_SENSOR_F_LINES_F_SUPPRESSED             : std_logic_vector(4 downto 0);                    -- Field: F_SUPPRESSED
signal field_rw_ACQ_SENSOR_F_LINES_F_LINES_SENSOR           : std_logic_vector(9 downto 0);                    -- Field: F_LINES_SENSOR
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
signal field_rw_ACQ_ACQ_SFNC_RELOAD_GRAB_PARAMS             : std_logic;                                       -- Field: RELOAD_GRAB_PARAMS

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
fullAddr(11 downto 2)<= reg_addr;

hit(0)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#0#,12)))	else '0'; -- Addr:  0x0000	ID
hit(1)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#30#,12)))	else '0'; -- Addr:  0x0030	ACQ_CAP
hit(2)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#100#,12)))	else '0'; -- Addr:  0x0100	GRAB_CTRL
hit(3)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#108#,12)))	else '0'; -- Addr:  0x0108	GRAB_STAT
hit(4)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#110#,12)))	else '0'; -- Addr:  0x0110	READOUT_CFG1
hit(5)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#114#,12)))	else '0'; -- Addr:  0x0114	READOUT_CFG_FRAME_LINE
hit(6)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#118#,12)))	else '0'; -- Addr:  0x0118	READOUT_CFG2
hit(7)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#120#,12)))	else '0'; -- Addr:  0x0120	READOUT_CFG3
hit(8)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#124#,12)))	else '0'; -- Addr:  0x0124	READOUT_CFG4
hit(9)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#128#,12)))	else '0'; -- Addr:  0x0128	EXP_CTRL1
hit(10) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#130#,12)))	else '0'; -- Addr:  0x0130	EXP_CTRL2
hit(11) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#138#,12)))	else '0'; -- Addr:  0x0138	EXP_CTRL3
hit(12) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#140#,12)))	else '0'; -- Addr:  0x0140	TRIGGER_DELAY
hit(13) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#148#,12)))	else '0'; -- Addr:  0x0148	STROBE_CTRL1
hit(14) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#150#,12)))	else '0'; -- Addr:  0x0150	STROBE_CTRL2
hit(15) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#158#,12)))	else '0'; -- Addr:  0x0158	ACQ_SER_CTRL
hit(16) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#160#,12)))	else '0'; -- Addr:  0x0160	ACQ_SER_ADDATA
hit(17) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#168#,12)))	else '0'; -- Addr:  0x0168	ACQ_SER_STAT
hit(18) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#190#,12)))	else '0'; -- Addr:  0x0190	SENSOR_CTRL
hit(19) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#198#,12)))	else '0'; -- Addr:  0x0198	SENSOR_STAT
hit(20) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1a0#,12)))	else '0'; -- Addr:  0x01A0	SENSOR_SUBSAMPLING
hit(21) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1a4#,12)))	else '0'; -- Addr:  0x01A4	SENSOR_GAIN_ANA
hit(22) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1a8#,12)))	else '0'; -- Addr:  0x01A8	SENSOR_ROI_Y_START
hit(23) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1ac#,12)))	else '0'; -- Addr:  0x01AC	SENSOR_ROI_Y_SIZE
hit(24) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1b0#,12)))	else '0'; -- Addr:  0x01B0	SENSOR_ROI2_Y_START
hit(25) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1b4#,12)))	else '0'; -- Addr:  0x01B4	SENSOR_ROI2_Y_SIZE
hit(26) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1d8#,12)))	else '0'; -- Addr:  0x01D8	SENSOR_M_LINES
hit(27) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1dc#,12)))	else '0'; -- Addr:  0x01DC	SENSOR_F_LINES
hit(28) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1e0#,12)))	else '0'; -- Addr:  0x01E0	DEBUG_PINS
hit(29) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1e8#,12)))	else '0'; -- Addr:  0x01E8	TRIGGER_MISSED
hit(30) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1f0#,12)))	else '0'; -- Addr:  0x01F0	SENSOR_FPS
hit(31) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#2a0#,12)))	else '0'; -- Addr:  0x02A0	DEBUG
hit(32) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#2a8#,12)))	else '0'; -- Addr:  0x02A8	DEBUG_CNTR1
hit(33) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#2b0#,12)))	else '0'; -- Addr:  0x02B0	DEBUG_CNTR2
hit(34) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#2b4#,12)))	else '0'; -- Addr:  0x02B4	DEBUG_CNTR3
hit(35) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#2b8#,12)))	else '0'; -- Addr:  0x02B8	EXP_FOT
hit(36) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#2c0#,12)))	else '0'; -- Addr:  0x02C0	ACQ_SFNC



fullAddrAsInt <= CONV_integer(fullAddr);


------------------------------------------------------------------------------------------
-- Process: P_readBackMux_Mux
------------------------------------------------------------------------------------------
P_readBackMux_Mux : process(fullAddrAsInt,
                            rb_SYSTEM_ID,
                            rb_SYSTEM_ACQ_CAP,
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
                            rb_ACQ_SENSOR_ROI2_Y_START,
                            rb_ACQ_SENSOR_ROI2_Y_SIZE,
                            rb_ACQ_SENSOR_M_LINES,
                            rb_ACQ_SENSOR_F_LINES,
                            rb_ACQ_DEBUG_PINS,
                            rb_ACQ_TRIGGER_MISSED,
                            rb_ACQ_SENSOR_FPS,
                            rb_ACQ_DEBUG,
                            rb_ACQ_DEBUG_CNTR1,
                            rb_ACQ_DEBUG_CNTR2,
                            rb_ACQ_DEBUG_CNTR3,
                            rb_ACQ_EXP_FOT,
                            rb_ACQ_ACQ_SFNC
                           )
begin
   case fullAddrAsInt is
      -- [0x000]: /SYSTEM/ID
      when 16#0# =>
         readBackMux <= rb_SYSTEM_ID;

      -- [0x030]: /SYSTEM/ACQ_CAP
      when 16#30# =>
         readBackMux <= rb_SYSTEM_ACQ_CAP;

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

      -- [0x1a0]: /ACQ/SENSOR_SUBSAMPLING
      when 16#1A0# =>
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

      -- [0x1b0]: /ACQ/SENSOR_ROI2_Y_START
      when 16#1B0# =>
         readBackMux <= rb_ACQ_SENSOR_ROI2_Y_START;

      -- [0x1b4]: /ACQ/SENSOR_ROI2_Y_SIZE
      when 16#1B4# =>
         readBackMux <= rb_ACQ_SENSOR_ROI2_Y_SIZE;

      -- [0x1d8]: /ACQ/SENSOR_M_LINES
      when 16#1D8# =>
         readBackMux <= rb_ACQ_SENSOR_M_LINES;

      -- [0x1dc]: /ACQ/SENSOR_F_LINES
      when 16#1DC# =>
         readBackMux <= rb_ACQ_SENSOR_F_LINES;

      -- [0x1e0]: /ACQ/DEBUG_PINS
      when 16#1E0# =>
         readBackMux <= rb_ACQ_DEBUG_PINS;

      -- [0x1e8]: /ACQ/TRIGGER_MISSED
      when 16#1E8# =>
         readBackMux <= rb_ACQ_TRIGGER_MISSED;

      -- [0x1f0]: /ACQ/SENSOR_FPS
      when 16#1F0# =>
         readBackMux <= rb_ACQ_SENSOR_FPS;

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
-- Register name: SYSTEM_ID
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(0) <= (hit(0)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: StaticID(31 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_SYSTEM_ID(31 downto 0) <= regfile.SYSTEM.ID.StaticID;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: SYSTEM_ACQ_CAP
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(1) <= (hit(1)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: DPC
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_SYSTEM_ACQ_CAP(15) <= '1';
regfile.SYSTEM.ACQ_CAP.DPC <= rb_SYSTEM_ACQ_CAP(15);


------------------------------------------------------------------------------------------
-- Field name: EXP_FOT
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_SYSTEM_ACQ_CAP(14) <= '1';
regfile.SYSTEM.ACQ_CAP.EXP_FOT <= rb_SYSTEM_ACQ_CAP(14);


------------------------------------------------------------------------------------------
-- Field name: FPN_73
-- Field type: RO
------------------------------------------------------------------------------------------
rb_SYSTEM_ACQ_CAP(13) <= regfile.SYSTEM.ACQ_CAP.FPN_73;


------------------------------------------------------------------------------------------
-- Field name: COLOR
-- Field type: RO
------------------------------------------------------------------------------------------
rb_SYSTEM_ACQ_CAP(12) <= regfile.SYSTEM.ACQ_CAP.COLOR;


------------------------------------------------------------------------------------------
-- Field name: CH_LVDS(3 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_SYSTEM_ACQ_CAP(11 downto 8) <= regfile.SYSTEM.ACQ_CAP.CH_LVDS;


------------------------------------------------------------------------------------------
-- Field name: LUT_WIDTH
-- Field type: RO
------------------------------------------------------------------------------------------
rb_SYSTEM_ACQ_CAP(4) <= regfile.SYSTEM.ACQ_CAP.LUT_WIDTH;


------------------------------------------------------------------------------------------
-- Field name: LUT_PALETTE(1 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_SYSTEM_ACQ_CAP(1 downto 0) <= regfile.SYSTEM.ACQ_CAP.LUT_PALETTE;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_GRAB_CTRL
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(2) <= (hit(2)) and (reg_write);

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
         if(wEn(2) = '1' and bitEnN(31) = '0') then
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
         if(wEn(2) = '1' and bitEnN(29) = '0') then
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
         if(wEn(2) = '1' and bitEnN(28) = '0') then
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
         if(wEn(2) = '1' and bitEnN(16) = '0') then
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
         if(wEn(2) = '1' and bitEnN(15) = '0') then
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
            if(wEn(2) = '1' and bitEnN(j) = '0') then
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
            if(wEn(2) = '1' and bitEnN(j) = '0') then
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
         if(wEn(2) = '1' and bitEnN(4) = '0') then
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
         if(wEn(2) = '1' and bitEnN(1) = '0') then
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
         if(wEn(2) = '1' and bitEnN(0) = '0') then
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
wEn(3) <= (hit(3)) and (reg_write);

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
wEn(4) <= (hit(4)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: GRAB_REVX_OVER_RST
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_ACQ_READOUT_CFG1(30) <= '0';
regfile.ACQ.READOUT_CFG1.GRAB_REVX_OVER_RST <= field_wautoclr_ACQ_READOUT_CFG1_GRAB_REVX_OVER_RST;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_READOUT_CFG1_GRAB_REVX_OVER_RST
------------------------------------------------------------------------------------------
P_ACQ_READOUT_CFG1_GRAB_REVX_OVER_RST : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_ACQ_READOUT_CFG1_GRAB_REVX_OVER_RST <= '0';
      else
         if(wEn(4) = '1' and bitEnN(30) = '0') then
            field_wautoclr_ACQ_READOUT_CFG1_GRAB_REVX_OVER_RST <= reg_writedata(30);
         else
            field_wautoclr_ACQ_READOUT_CFG1_GRAB_REVX_OVER_RST <= '0';
         end if;
      end if;
   end if;
end process P_ACQ_READOUT_CFG1_GRAB_REVX_OVER_RST;

------------------------------------------------------------------------------------------
-- Field name: GRAB_REVX_OVER
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_READOUT_CFG1(29) <= regfile.ACQ.READOUT_CFG1.GRAB_REVX_OVER;


------------------------------------------------------------------------------------------
-- Field name: GRAB_REVX
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_READOUT_CFG1(28) <= field_rw_ACQ_READOUT_CFG1_GRAB_REVX;
regfile.ACQ.READOUT_CFG1.GRAB_REVX <= field_rw_ACQ_READOUT_CFG1_GRAB_REVX;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_READOUT_CFG1_GRAB_REVX
------------------------------------------------------------------------------------------
P_ACQ_READOUT_CFG1_GRAB_REVX : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_READOUT_CFG1_GRAB_REVX <= '0';
      else
         if(wEn(4) = '1' and bitEnN(28) = '0') then
            field_rw_ACQ_READOUT_CFG1_GRAB_REVX <= reg_writedata(28);
         end if;
      end if;
   end if;
end process P_ACQ_READOUT_CFG1_GRAB_REVX;

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
-- Register name: ACQ_READOUT_CFG_FRAME_LINE
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(5) <= (hit(5)) and (reg_write);

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
            if(wEn(5) = '1' and bitEnN(j) = '0') then
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
wEn(6) <= (hit(6)) and (reg_write);

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
wEn(7) <= (hit(7)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: KEEP_OUT_TRIG_ENA
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_READOUT_CFG3(16) <= field_rw_ACQ_READOUT_CFG3_KEEP_OUT_TRIG_ENA;
regfile.ACQ.READOUT_CFG3.KEEP_OUT_TRIG_ENA <= field_rw_ACQ_READOUT_CFG3_KEEP_OUT_TRIG_ENA;


------------------------------------------------------------------------------------------
-- Process: P_ACQ_READOUT_CFG3_KEEP_OUT_TRIG_ENA
------------------------------------------------------------------------------------------
P_ACQ_READOUT_CFG3_KEEP_OUT_TRIG_ENA : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_READOUT_CFG3_KEEP_OUT_TRIG_ENA <= '0';
      else
         if(wEn(7) = '1' and bitEnN(16) = '0') then
            field_rw_ACQ_READOUT_CFG3_KEEP_OUT_TRIG_ENA <= reg_writedata(16);
         end if;
      end if;
   end if;
end process P_ACQ_READOUT_CFG3_KEEP_OUT_TRIG_ENA;

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
            if(wEn(7) = '1' and bitEnN(j) = '0') then
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
wEn(8) <= (hit(8)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: KEEP_OUT_TRIG_END(31 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_READOUT_CFG4(31 downto 16) <= field_rw_ACQ_READOUT_CFG4_KEEP_OUT_TRIG_END(15 downto 0);
regfile.ACQ.READOUT_CFG4.KEEP_OUT_TRIG_END <= field_rw_ACQ_READOUT_CFG4_KEEP_OUT_TRIG_END(15 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_READOUT_CFG4_KEEP_OUT_TRIG_END
------------------------------------------------------------------------------------------
P_ACQ_READOUT_CFG4_KEEP_OUT_TRIG_END : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_READOUT_CFG4_KEEP_OUT_TRIG_END <= std_logic_vector(to_unsigned(integer(365),16));
      else
         for j in  31 downto 16  loop
            if(wEn(8) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_READOUT_CFG4_KEEP_OUT_TRIG_END(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_READOUT_CFG4_KEEP_OUT_TRIG_END;

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
         field_rw_ACQ_READOUT_CFG4_KEEP_OUT_TRIG_START <= std_logic_vector(to_unsigned(integer(366),16));
      else
         for j in  15 downto 0  loop
            if(wEn(8) = '1' and bitEnN(j) = '0') then
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
wEn(9) <= (hit(9)) and (reg_write);

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
         if(wEn(9) = '1' and bitEnN(28) = '0') then
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
            if(wEn(9) = '1' and bitEnN(j) = '0') then
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
wEn(10) <= (hit(10)) and (reg_write);

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
            if(wEn(10) = '1' and bitEnN(j) = '0') then
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
wEn(11) <= (hit(11)) and (reg_write);

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
            if(wEn(11) = '1' and bitEnN(j) = '0') then
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
wEn(12) <= (hit(12)) and (reg_write);

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
            if(wEn(12) = '1' and bitEnN(j) = '0') then
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
wEn(13) <= (hit(13)) and (reg_write);

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
         if(wEn(13) = '1' and bitEnN(31) = '0') then
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
         if(wEn(13) = '1' and bitEnN(28) = '0') then
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
            if(wEn(13) = '1' and bitEnN(j) = '0') then
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
wEn(14) <= (hit(14)) and (reg_write);

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
         if(wEn(14) = '1' and bitEnN(31) = '0') then
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
         if(wEn(14) = '1' and bitEnN(29) = '0') then
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
         if(wEn(14) = '1' and bitEnN(28) = '0') then
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
            if(wEn(14) = '1' and bitEnN(j) = '0') then
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
wEn(15) <= (hit(15)) and (reg_write);

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
         if(wEn(15) = '1' and bitEnN(16) = '0') then
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
            if(wEn(15) = '1' and bitEnN(j) = '0') then
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
         if(wEn(15) = '1' and bitEnN(4) = '0') then
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
         if(wEn(15) = '1' and bitEnN(0) = '0') then
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
wEn(16) <= (hit(16)) and (reg_write);

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
            if(wEn(16) = '1' and bitEnN(j) = '0') then
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
            if(wEn(16) = '1' and bitEnN(j) = '0') then
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
wEn(17) <= (hit(17)) and (reg_write);

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
wEn(18) <= (hit(18)) and (reg_write);

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
         if(wEn(18) = '1' and bitEnN(24) = '0') then
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
         if(wEn(18) = '1' and bitEnN(16) = '0') then
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
         if(wEn(18) = '1' and bitEnN(8) = '0') then
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
         if(wEn(18) = '1' and bitEnN(4) = '0') then
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
         if(wEn(18) = '1' and bitEnN(1) = '0') then
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
         if(wEn(18) = '1' and bitEnN(0) = '0') then
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
wEn(19) <= (hit(19)) and (reg_write);

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
wEn(20) <= (hit(20)) and (reg_write);

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
         if(wEn(20) = '1' and bitEnN(3) = '0') then
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
         if(wEn(20) = '1' and bitEnN(1) = '0') then
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
         if(wEn(20) = '1' and bitEnN(0) = '0') then
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
wEn(21) <= (hit(21)) and (reg_write);

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
            if(wEn(21) = '1' and bitEnN(j) = '0') then
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
wEn(22) <= (hit(22)) and (reg_write);

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
            if(wEn(22) = '1' and bitEnN(j) = '0') then
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
wEn(23) <= (hit(23)) and (reg_write);

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
            if(wEn(23) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_ROI_Y_SIZE_Y_SIZE(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_ROI_Y_SIZE_Y_SIZE;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_SENSOR_ROI2_Y_START
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(24) <= (hit(24)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: reserved
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_ROI2_Y_START(15 downto 10) <= std_logic_vector(to_unsigned(integer(0),6));
regfile.ACQ.SENSOR_ROI2_Y_START.reserved <= rb_ACQ_SENSOR_ROI2_Y_START(15 downto 10);


------------------------------------------------------------------------------------------
-- Field name: Y_START(9 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_ROI2_Y_START(9 downto 0) <= field_rw_ACQ_SENSOR_ROI2_Y_START_Y_START(9 downto 0);
regfile.ACQ.SENSOR_ROI2_Y_START.Y_START <= field_rw_ACQ_SENSOR_ROI2_Y_START_Y_START(9 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_ROI2_Y_START_Y_START
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_ROI2_Y_START_Y_START : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_ROI2_Y_START_Y_START <= std_logic_vector(to_unsigned(integer(0),10));
      else
         for j in  9 downto 0  loop
            if(wEn(24) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_ROI2_Y_START_Y_START(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_ROI2_Y_START_Y_START;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_SENSOR_ROI2_Y_SIZE
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(25) <= (hit(25)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: reserved
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_ROI2_Y_SIZE(15 downto 10) <= std_logic_vector(to_unsigned(integer(0),6));
regfile.ACQ.SENSOR_ROI2_Y_SIZE.reserved <= rb_ACQ_SENSOR_ROI2_Y_SIZE(15 downto 10);


------------------------------------------------------------------------------------------
-- Field name: Y_SIZE(9 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_ROI2_Y_SIZE(9 downto 0) <= field_rw_ACQ_SENSOR_ROI2_Y_SIZE_Y_SIZE(9 downto 0);
regfile.ACQ.SENSOR_ROI2_Y_SIZE.Y_SIZE <= field_rw_ACQ_SENSOR_ROI2_Y_SIZE_Y_SIZE(9 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_ROI2_Y_SIZE_Y_SIZE
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_ROI2_Y_SIZE_Y_SIZE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_ROI2_Y_SIZE_Y_SIZE <= std_logic_vector(to_unsigned(integer(770),10));
      else
         for j in  9 downto 0  loop
            if(wEn(25) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_ROI2_Y_SIZE_Y_SIZE(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_ROI2_Y_SIZE_Y_SIZE;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_SENSOR_M_LINES
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(26) <= (hit(26)) and (reg_write);

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
            if(wEn(26) = '1' and bitEnN(j) = '0') then
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
            if(wEn(26) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_M_LINES_M_LINES_SENSOR(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_M_LINES_M_LINES_SENSOR;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_SENSOR_F_LINES
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(27) <= (hit(27)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: F_SUPPRESSED(14 downto 10)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_F_LINES(14 downto 10) <= field_rw_ACQ_SENSOR_F_LINES_F_SUPPRESSED(4 downto 0);
regfile.ACQ.SENSOR_F_LINES.F_SUPPRESSED <= field_rw_ACQ_SENSOR_F_LINES_F_SUPPRESSED(4 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_F_LINES_F_SUPPRESSED
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_F_LINES_F_SUPPRESSED : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_F_LINES_F_SUPPRESSED <= std_logic_vector(to_unsigned(integer(0),5));
      else
         for j in  14 downto 10  loop
            if(wEn(27) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_F_LINES_F_SUPPRESSED(j-10) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_F_LINES_F_SUPPRESSED;

------------------------------------------------------------------------------------------
-- Field name: F_LINES_SENSOR(9 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_ACQ_SENSOR_F_LINES(9 downto 0) <= field_rw_ACQ_SENSOR_F_LINES_F_LINES_SENSOR(9 downto 0);
regfile.ACQ.SENSOR_F_LINES.F_LINES_SENSOR <= field_rw_ACQ_SENSOR_F_LINES_F_LINES_SENSOR(9 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_ACQ_SENSOR_F_LINES_F_LINES_SENSOR
------------------------------------------------------------------------------------------
P_ACQ_SENSOR_F_LINES_F_LINES_SENSOR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_ACQ_SENSOR_F_LINES_F_LINES_SENSOR <= std_logic_vector(to_unsigned(integer(8),10));
      else
         for j in  9 downto 0  loop
            if(wEn(27) = '1' and bitEnN(j) = '0') then
               field_rw_ACQ_SENSOR_F_LINES_F_LINES_SENSOR(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_ACQ_SENSOR_F_LINES_F_LINES_SENSOR;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: ACQ_DEBUG_PINS
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(28) <= (hit(28)) and (reg_write);

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
            if(wEn(28) = '1' and bitEnN(j) = '0') then
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
            if(wEn(28) = '1' and bitEnN(j) = '0') then
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
            if(wEn(28) = '1' and bitEnN(j) = '0') then
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
            if(wEn(28) = '1' and bitEnN(j) = '0') then
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
wEn(29) <= (hit(29)) and (reg_write);

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
         if(wEn(29) = '1' and bitEnN(28) = '0') then
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
wEn(30) <= (hit(30)) and (reg_write);

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
wEn(31) <= (hit(31)) and (reg_write);

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
         if(wEn(31) = '1' and bitEnN(28) = '0') then
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
            if(wEn(31) = '1' and bitEnN(j) = '0') then
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
         if(wEn(31) = '1' and bitEnN(9) = '0') then
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
         if(wEn(31) = '1' and bitEnN(8) = '0') then
            field_rw_ACQ_DEBUG_TEST_MODE <= reg_writedata(8);
         end if;
      end if;
   end if;
end process P_ACQ_DEBUG_TEST_MODE;

------------------------------------------------------------------------------------------
-- Field name: LED_STAT_CLHS(1 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_DEBUG(7 downto 6) <= regfile.ACQ.DEBUG.LED_STAT_CLHS;


------------------------------------------------------------------------------------------
-- Field name: LED_STAT_CTRL(1 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_ACQ_DEBUG(5 downto 4) <= regfile.ACQ.DEBUG.LED_STAT_CTRL;


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
            if(wEn(31) = '1' and bitEnN(j) = '0') then
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
         if(wEn(31) = '1' and bitEnN(0) = '0') then
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
wEn(32) <= (hit(32)) and (reg_write);

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
wEn(33) <= (hit(33)) and (reg_write);

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
wEn(34) <= (hit(34)) and (reg_write);

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
wEn(35) <= (hit(35)) and (reg_write);

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
         if(wEn(35) = '1' and bitEnN(16) = '0') then
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
         field_rw_ACQ_EXP_FOT_EXP_FOT_TIME <= std_logic_vector(to_unsigned(integer(2542),12));
      else
         for j in  11 downto 0  loop
            if(wEn(35) = '1' and bitEnN(j) = '0') then
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
wEn(36) <= (hit(36)) and (reg_write);

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
         if(wEn(36) = '1' and bitEnN(0) = '0') then
            field_rw_ACQ_ACQ_SFNC_RELOAD_GRAB_PARAMS <= reg_writedata(0);
         end if;
      end if;
   end if;
end process P_ACQ_ACQ_SFNC_RELOAD_GRAB_PARAMS;

ldData <= reg_read;

end rtl;

