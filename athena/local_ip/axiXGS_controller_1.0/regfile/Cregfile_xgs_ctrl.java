/*****************************************************************************
**  $HeadURL:$
**  $Revision:$
**  $Date:$
**
**  MODULE: regfile_xgs_ctrl
**
**  DESCRIPTION: Register file of the regfile_xgs_ctrl module
**
**
**  DO NOT MODIFY MANUALLY.
**
**  FDK IDE Version: 4.7.0_beta3
**  Build ID: I20191219-1127
**
**  COPYRIGHT (c) 2011 Matrox Electronic Systems Ltd.
**  All Rights Reserved
**
*****************************************************************************/
public class Cregfile_xgs_ctrl  extends CRegisterFile {


   public Cregfile_xgs_ctrl()
   {
      super("regfile_xgs_ctrl", 12, 32, true);

      CSection section;
      CExternal external;
      CRegister register;

      /***************************************************************
      * Section: SYSTEM
      * Offset: 0x0
      ****************************************************************/
      section = new CSection(this, "SYSTEM", "null", 0x0);
      super.childrenList.add(section);

      /***************************************************************
      * Register: ID
      * Offset: 0x0
      ****************************************************************/
      register = new CRegister(section, "ID", "", 0x0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "StaticID", "MINUTEs of the build", CField.FieldType.RO, 0, 32, 0xcafe0ccd));

      /***************************************************************
      * Register: ACQ_CAP
      * Offset: 0x30
      ****************************************************************/
      register = new CRegister(section, "ACQ_CAP", "null", 0x30);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "DPC", "null", CField.FieldType.STATIC, 15, 1, 0x1));
      register.addField(new CField(register, "EXP_FOT", "null", CField.FieldType.STATIC, 14, 1, 0x1));
      register.addField(new CField(register, "FPN_73", "FPN 7.3 correction CAP", CField.FieldType.RO, 13, 1, 0x0));
      register.addField(new CField(register, "COLOR", "null", CField.FieldType.RO, 12, 1, 0x0));
      register.addField(new CField(register, "CH_LVDS", "null", CField.FieldType.RO, 8, 4, 0x0));
      register.addField(new CField(register, "LUT_WIDTH", "null", CField.FieldType.RO, 4, 1, 0x0));
      register.addField(new CField(register, "LUT_PALETTE", "null", CField.FieldType.RO, 0, 2, 0x0));


      /***************************************************************
      * Section: ACQ
      * Offset: 0x100
      ****************************************************************/
      section = new CSection(this, "ACQ", "null", 0x100);
      super.childrenList.add(section);

      /***************************************************************
      * Register: GRAB_CTRL
      * Offset: 0x0
      ****************************************************************/
      register = new CRegister(section, "GRAB_CTRL", "GRAB ConTRoL Register", 0x0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "RESET_GRAB", "null", CField.FieldType.RW, 31, 1, 0x0));
      register.addField(new CField(register, "GRAB_ROI2_EN", "null", CField.FieldType.RW, 29, 1, 0x0));
      register.addField(new CField(register, "ABORT_GRAB", "ABORT GRAB", CField.FieldType.WO, 28, 1, 0x0));
      register.addField(new CField(register, "TRIGGER_OVERLAP_BUFFn", "null", CField.FieldType.RW, 16, 1, 0x0));
      register.addField(new CField(register, "TRIGGER_OVERLAP", "null", CField.FieldType.RW, 15, 1, 0x1));
      register.addField(new CField(register, "TRIGGER_ACT", "TRIGGER ACTivation", CField.FieldType.RW, 12, 3, 0x0));
      register.addField(new CField(register, "TRIGGER_SRC", "TRIGGER SouRCe", CField.FieldType.RW, 8, 3, 0x0));
      register.addField(new CField(register, "GRAB_SS", "GRAB Software Snapshot", CField.FieldType.WO, 4, 1, 0x0));
      register.addField(new CField(register, "BUFFER_ID", "null", CField.FieldType.RW, 1, 1, 0x0));
      register.addField(new CField(register, "GRAB_CMD", "GRAB CoMmanD", CField.FieldType.WO, 0, 1, 0x0));

      /***************************************************************
      * Register: GRAB_STAT
      * Offset: 0x8
      ****************************************************************/
      register = new CRegister(section, "GRAB_STAT", "null", 0x8);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "GRAB_CMD_DONE", "GRAB CoMmanD DONE", CField.FieldType.RO, 31, 1, 0x0));
      register.addField(new CField(register, "ABORT_PET", "ABORT during PET", CField.FieldType.RO, 30, 1, 0x0));
      register.addField(new CField(register, "ABORT_DELAI", "null", CField.FieldType.RO, 29, 1, 0x0));
      register.addField(new CField(register, "ABORT_DONE", "ABORT is DONE", CField.FieldType.RO, 28, 1, 0x0));
      register.addField(new CField(register, "TRIGGER_RDY", "null", CField.FieldType.RO, 24, 1, 0x0));
      register.addField(new CField(register, "ABORT_MNGR_STAT", "null", CField.FieldType.RO, 20, 3, 0x0));
      register.addField(new CField(register, "TRIG_MNGR_STAT", "null", CField.FieldType.RO, 16, 4, 0x0));
      register.addField(new CField(register, "TIMER_MNGR_STAT", "null", CField.FieldType.RO, 12, 3, 0x0));
      register.addField(new CField(register, "GRAB_MNGR_STAT", "null", CField.FieldType.RO, 8, 4, 0x0));
      register.addField(new CField(register, "GRAB_FOT", "GRAB Field Overhead Time", CField.FieldType.RO, 6, 1, 0x0));
      register.addField(new CField(register, "GRAB_READOUT", "null", CField.FieldType.RO, 5, 1, 0x0));
      register.addField(new CField(register, "GRAB_EXPOSURE", "null", CField.FieldType.RO, 4, 1, 0x0));
      register.addField(new CField(register, "GRAB_PENDING", "null", CField.FieldType.RO, 2, 1, 0x0));
      register.addField(new CField(register, "GRAB_ACTIVE", "null", CField.FieldType.RO, 1, 1, 0x0));
      register.addField(new CField(register, "GRAB_IDLE", "null", CField.FieldType.RO, 0, 1, 0x0));

      /***************************************************************
      * Register: READOUT_CFG1
      * Offset: 0x10
      ****************************************************************/
      register = new CRegister(section, "READOUT_CFG1", "null", 0x10);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "GRAB_REVX_OVER_RST", "null", CField.FieldType.WO, 30, 1, 0x0));
      register.addField(new CField(register, "GRAB_REVX_OVER", "null", CField.FieldType.RO, 29, 1, 0x0));
      register.addField(new CField(register, "GRAB_REVX", "null", CField.FieldType.RW, 28, 1, 0x0));
      register.addField(new CField(register, "ROT_LENGTH", "Row Overhead Time LENGTH", CField.FieldType.STATIC, 16, 10, 0x0));
      register.addField(new CField(register, "FOT_LENGTH", "Frame Overhead Time LENGTH", CField.FieldType.STATIC, 0, 16, 0x0));

      /***************************************************************
      * Register: READOUT_CFG2
      * Offset: 0x18
      ****************************************************************/
      register = new CRegister(section, "READOUT_CFG2", "null", 0x18);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "READOUT_EN", "READOUT ENable", CField.FieldType.RW, 28, 1, 0x0));
      register.addField(new CField(register, "READOUT_LENGTH", "null", CField.FieldType.RW, 0, 24, 0x0));

      /***************************************************************
      * Register: READOUT_CFG3
      * Offset: 0x20
      ****************************************************************/
      register = new CRegister(section, "READOUT_CFG3", "null", 0x20);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "KEEP_OUT_TRIG", "null", CField.FieldType.RW, 16, 16, 0x0));
      register.addField(new CField(register, "LINE_TIME", "LINE TIME", CField.FieldType.RW, 0, 16, 0x0));

      /***************************************************************
      * Register: EXP_CTRL1
      * Offset: 0x28
      ****************************************************************/
      register = new CRegister(section, "EXP_CTRL1", "null", 0x28);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "EXPOSURE_LEV_MODE", "EXPOSURE LEVel MODE", CField.FieldType.RW, 28, 1, 0x0));
      register.addField(new CField(register, "EXPOSURE_SS", "EXPOSURE Single Slope", CField.FieldType.RW, 0, 28, 0x0));

      /***************************************************************
      * Register: EXP_CTRL2
      * Offset: 0x30
      ****************************************************************/
      register = new CRegister(section, "EXP_CTRL2", "null", 0x30);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "EXPOSURE_DS", "EXPOSURE Dual Slope", CField.FieldType.RW, 0, 28, 0x0));

      /***************************************************************
      * Register: EXP_CTRL3
      * Offset: 0x38
      ****************************************************************/
      register = new CRegister(section, "EXP_CTRL3", "null", 0x38);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "EXPOSURE_TS", "EXPOSURE Tripple Slope", CField.FieldType.RW, 0, 28, 0x0));

      /***************************************************************
      * Register: TRIGGER_DELAY
      * Offset: 0x40
      ****************************************************************/
      register = new CRegister(section, "TRIGGER_DELAY", "null", 0x40);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "TRIGGER_DELAY", "TRIGGER DELAY", CField.FieldType.RW, 0, 28, 0x0));

      /***************************************************************
      * Register: STROBE_CTRL1
      * Offset: 0x48
      ****************************************************************/
      register = new CRegister(section, "STROBE_CTRL1", "null", 0x48);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "STROBE_E", "STROBE Enable", CField.FieldType.RW, 31, 1, 0x0));
      register.addField(new CField(register, "STROBE_POL", "STROBE POLarity", CField.FieldType.RW, 28, 1, 0x0));
      register.addField(new CField(register, "STROBE_START", "STROBE START", CField.FieldType.RW, 0, 28, 0x0));

      /***************************************************************
      * Register: STROBE_CTRL2
      * Offset: 0x50
      ****************************************************************/
      register = new CRegister(section, "STROBE_CTRL2", "null", 0x50);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "STROBE_MODE", "STROBE MODE", CField.FieldType.RW, 31, 1, 0x0));
      register.addField(new CField(register, "STROBE_B_EN", "STROBE phase B ENable", CField.FieldType.RW, 29, 1, 0x0));
      register.addField(new CField(register, "STROBE_A_EN", "STROBE phase A ENable", CField.FieldType.RW, 28, 1, 0x1));
      register.addField(new CField(register, "STROBE_END", "STROBE END", CField.FieldType.RW, 0, 28, 0xfffffff));

      /***************************************************************
      * Register: ACQ_SER_CTRL
      * Offset: 0x58
      ****************************************************************/
      register = new CRegister(section, "ACQ_SER_CTRL", "Acquisition Serial Control", 0x58);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "SER_RWn", "SERial Read/Writen", CField.FieldType.RW, 16, 1, 0x1));
      register.addField(new CField(register, "SER_CMD", "SERial CoMmand ", CField.FieldType.RW, 8, 2, 0x0));
      register.addField(new CField(register, "SER_RF_SS", "SERial Read Fifo SnapShot", CField.FieldType.WO, 4, 1, 0x0));
      register.addField(new CField(register, "SER_WF_SS", "SERial Write Fifo SnapShot", CField.FieldType.WO, 0, 1, 0x0));

      /***************************************************************
      * Register: ACQ_SER_ADDATA
      * Offset: 0x60
      ****************************************************************/
      register = new CRegister(section, "ACQ_SER_ADDATA", "Serial Interface Data", 0x60);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "SER_DAT", "SERial interface DATa", CField.FieldType.RW, 16, 16, 0x0));
      register.addField(new CField(register, "SER_ADD", "SERial interface ADDress", CField.FieldType.RW, 0, 15, 0x0));

      /***************************************************************
      * Register: ACQ_SER_STAT
      * Offset: 0x68
      ****************************************************************/
      register = new CRegister(section, "ACQ_SER_STAT", "Serial Interface Data", 0x68);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "SER_FIFO_EMPTY", "SERial FIFO EMPTY", CField.FieldType.RO, 24, 1, 0x0));
      register.addField(new CField(register, "SER_BUSY", "SERial BUSY", CField.FieldType.RO, 16, 1, 0x0));
      register.addField(new CField(register, "SER_DAT_R", "SERial interface DATa Read", CField.FieldType.RO, 0, 16, 0x0));

      /***************************************************************
      * Register: SENSOR_CTRL
      * Offset: 0x90
      ****************************************************************/
      register = new CRegister(section, "SENSOR_CTRL", "SENSOR ConTRoL", 0x90);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "SENSOR_REFRESH_TEMP", "SENSOR REFRESH TEMPerature", CField.FieldType.WO, 24, 1, 0x0));
      register.addField(new CField(register, "SENSOR_POWERDOWN", "null", CField.FieldType.WO, 16, 1, 0x0));
      register.addField(new CField(register, "SENSOR_COLOR", "SENSOR COLOR", CField.FieldType.RW, 8, 1, 0x0));
      register.addField(new CField(register, "SENSOR_REG_UPTATE", "SENSOR REGister UPDATE", CField.FieldType.RW, 4, 1, 0x1));
      register.addField(new CField(register, "SENSOR_RESETN", "SENSOR RESET Not", CField.FieldType.RW, 1, 1, 0x1));
      register.addField(new CField(register, "SENSOR_POWERUP", "null", CField.FieldType.WO, 0, 1, 0x0));

      /***************************************************************
      * Register: SENSOR_STAT
      * Offset: 0x98
      ****************************************************************/
      register = new CRegister(section, "SENSOR_STAT", "SENSOR control STATus", 0x98);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "SENSOR_TEMP", "null", CField.FieldType.RO, 24, 8, 0x0));
      register.addField(new CField(register, "SENSOR_TEMP_VALID", "SENSOR TEMPerature VALID", CField.FieldType.RO, 23, 1, 0x0));
      register.addField(new CField(register, "SENSOR_POWERDOWN", "null", CField.FieldType.RO, 16, 1, 0x0));
      register.addField(new CField(register, "SENSOR_RESETN", "SENSOR RESET N", CField.FieldType.RO, 13, 1, 0x0));
      register.addField(new CField(register, "SENSOR_OSC_EN", "SENSOR OSCILLATOR ENable", CField.FieldType.RO, 12, 1, 0x0));
      register.addField(new CField(register, "SENSOR_VCC_PG", "SENSOR supply VCC  Power Good", CField.FieldType.RO, 8, 1, 0x0));
      register.addField(new CField(register, "SENSOR_POWERUP_STAT", "null", CField.FieldType.RO, 1, 1, 0x0));
      register.addField(new CField(register, "SENSOR_POWERUP_DONE", "null", CField.FieldType.RO, 0, 1, 0x0));

      /***************************************************************
      * Register: SENSOR_SUBSAMPLING
      * Offset: 0xa0
      ****************************************************************/
      register = new CRegister(section, "SENSOR_SUBSAMPLING", "null", 0xa0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "reserved1", "null", CField.FieldType.STATIC, 4, 12, 0x0));
      register.addField(new CField(register, "ACTIVE_SUBSAMPLING_Y", "null", CField.FieldType.RW, 3, 1, 0x0));
      register.addField(new CField(register, "reserved0", "", CField.FieldType.STATIC, 2, 1, 0x0));
      register.addField(new CField(register, "M_SUBSAMPLING_Y", "", CField.FieldType.RW, 1, 1, 0x0));
      register.addField(new CField(register, "SUBSAMPLING_X", "", CField.FieldType.RW, 0, 1, 0x0));

      /***************************************************************
      * Register: SENSOR_GAIN_ANA
      * Offset: 0xa4
      ****************************************************************/
      register = new CRegister(section, "SENSOR_GAIN_ANA", "null", 0xa4);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "reserved1", "null", CField.FieldType.STATIC, 11, 5, 0x0));
      register.addField(new CField(register, "ANALOG_GAIN", "", CField.FieldType.RW, 8, 3, 0x1));
      register.addField(new CField(register, "reserved0", "null", CField.FieldType.STATIC, 0, 8, 0x0));

      /***************************************************************
      * Register: SENSOR_ROI_Y_START
      * Offset: 0xa8
      ****************************************************************/
      register = new CRegister(section, "SENSOR_ROI_Y_START", "null", 0xa8);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "reserved", "null", CField.FieldType.STATIC, 10, 6, 0x0));
      register.addField(new CField(register, "Y_START", "Y START", CField.FieldType.RW, 0, 10, 0x0));

      /***************************************************************
      * Register: SENSOR_ROI_Y_SIZE
      * Offset: 0xac
      ****************************************************************/
      register = new CRegister(section, "SENSOR_ROI_Y_SIZE", "null", 0xac);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "reserved", "null", CField.FieldType.STATIC, 10, 6, 0x0));
      register.addField(new CField(register, "Y_SIZE", "Y SIZE", CField.FieldType.RW, 0, 10, 0x302));

      /***************************************************************
      * Register: SENSOR_ROI2_Y_START
      * Offset: 0xb0
      ****************************************************************/
      register = new CRegister(section, "SENSOR_ROI2_Y_START", "null", 0xb0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "reserved", "null", CField.FieldType.STATIC, 10, 6, 0x0));
      register.addField(new CField(register, "Y_START", "Y START", CField.FieldType.RW, 0, 10, 0x0));

      /***************************************************************
      * Register: SENSOR_ROI2_Y_SIZE
      * Offset: 0xb4
      ****************************************************************/
      register = new CRegister(section, "SENSOR_ROI2_Y_SIZE", "null", 0xb4);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "reserved", "null", CField.FieldType.STATIC, 10, 6, 0x0));
      register.addField(new CField(register, "Y_SIZE", "Y SIZE", CField.FieldType.RW, 0, 10, 0x302));

      /***************************************************************
      * Register: SENSOR_M_LINES
      * Offset: 0xdc
      ****************************************************************/
      register = new CRegister(section, "SENSOR_M_LINES", "null", 0xdc);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "M_SUPPRESSED", "null", CField.FieldType.RW, 10, 5, 0x0));
      register.addField(new CField(register, "M_LINES", "null", CField.FieldType.RW, 0, 10, 0x8));

      /***************************************************************
      * Register: DEBUG_PINS
      * Offset: 0xe0
      ****************************************************************/
      register = new CRegister(section, "DEBUG_PINS", "null", 0xe0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "Debug3_sel", "null", CField.FieldType.RW, 24, 5, 0x1f));
      register.addField(new CField(register, "Debug2_sel", "null", CField.FieldType.RW, 16, 5, 0x1f));
      register.addField(new CField(register, "Debug1_sel", "null", CField.FieldType.RW, 8, 5, 0x1f));
      register.addField(new CField(register, "Debug0_sel", "null", CField.FieldType.RW, 0, 5, 0x1f));

      /***************************************************************
      * Register: TRIGGER_MISSED
      * Offset: 0xe8
      ****************************************************************/
      register = new CRegister(section, "TRIGGER_MISSED", "null", 0xe8);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "TRIGGER_MISSED_RST", "TRIGGER MISSED ReSeT", CField.FieldType.WO, 28, 1, 0x0));
      register.addField(new CField(register, "TRIGGER_MISSED_CNTR", "TRIGGER MISSED CouNTeR", CField.FieldType.RO, 0, 16, 0x0));

      /***************************************************************
      * Register: SENSOR_FPS
      * Offset: 0xf0
      ****************************************************************/
      register = new CRegister(section, "SENSOR_FPS", "null", 0xf0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "SENSOR_FPS", "SENSOR Frame Per Second", CField.FieldType.RO, 0, 16, 0x0));

      /***************************************************************
      * Register: DEBUG
      * Offset: 0x120
      ****************************************************************/
      register = new CRegister(section, "DEBUG", "null", 0x120);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "DEBUG_RST_CNTR", "null", CField.FieldType.RW, 28, 1, 0x1));
      register.addField(new CField(register, "TEST_MODE_PIX_START", "null", CField.FieldType.RW, 16, 10, 0x0));
      register.addField(new CField(register, "TEST_MOVE", "null", CField.FieldType.RW, 9, 1, 0x0));
      register.addField(new CField(register, "TEST_MODE", "null", CField.FieldType.RW, 8, 1, 0x0));
      register.addField(new CField(register, "LED_STAT_CLHS", "null", CField.FieldType.RO, 6, 2, 0x0));
      register.addField(new CField(register, "LED_STAT_CTRL", "null", CField.FieldType.RO, 4, 2, 0x0));
      register.addField(new CField(register, "LED_TEST_COLOR", "null", CField.FieldType.RW, 1, 2, 0x0));
      register.addField(new CField(register, "LED_TEST", "null", CField.FieldType.RW, 0, 1, 0x0));

      /***************************************************************
      * Register: DEBUG_CNTR1
      * Offset: 0x128
      ****************************************************************/
      register = new CRegister(section, "DEBUG_CNTR1", "null", 0x128);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "EOF_CNTR", "null", CField.FieldType.RO, 0, 32, 0x0));

      /***************************************************************
      * Register: DEBUG_CNTR2
      * Offset: 0x130
      ****************************************************************/
      register = new CRegister(section, "DEBUG_CNTR2", "null", 0x130);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "EOL_CNTR", "null", CField.FieldType.RO, 0, 12, 0x0));

      /***************************************************************
      * Register: DEBUG_CNTR3
      * Offset: 0x134
      ****************************************************************/
      register = new CRegister(section, "DEBUG_CNTR3", "null", 0x134);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "SENSOR_FRAME_DURATION", "", CField.FieldType.RO, 0, 28, 0x0));

      /***************************************************************
      * Register: EXP_FOT
      * Offset: 0x138
      ****************************************************************/
      register = new CRegister(section, "EXP_FOT", "null", 0x138);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "EXP_FOT", "EXPosure during FOT", CField.FieldType.RW, 16, 1, 0x1));
      register.addField(new CField(register, "EXP_FOT_TIME", "EXPosure during FOT TIME", CField.FieldType.RW, 0, 12, 0x9ee));

      /***************************************************************
      * Register: ACQ_SFNC
      * Offset: 0x140
      ****************************************************************/
      register = new CRegister(section, "ACQ_SFNC", "null", 0x140);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "RELOAD_GRAB_PARAMS", "", CField.FieldType.RW, 0, 1, 0x1));


 }

}


