/*****************************************************************************
 ** File                : regfile_xgs_ctrl.sv
 ** Project             : FDK
 ** Module              : regfile_xgs_ctrl
 ** Created on          : 2020/03/03 08:21:44
 ** Created by          : jmansill
 ** FDK IDE Version     : 4.7.0_beta3
 ** Build ID            : I20191219-1127
 ** Register file CRC32 : 0xD7056496
 **
 **  COPYRIGHT (c) 2020 Matrox Electronic Systems Ltd.
 **  All Rights Reserved
 **
 *****************************************************************************/
typedef bit  [7:0][3:0]  uint8_t;
typedef bit  [15:0][1:0] uint16_t;
typedef bit  [31:0]      uint32_t;



/**************************************************************************
* Register name : ID
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [31:0] StaticID;                 /* Bits(31:0), MINUTEs of the build */
      logic        rsvd_register_space[11];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_ctrl_SYSTEM_ID_t;


/**************************************************************************
* Register name : ACQ_CAP
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [1:0]  LUT_PALETTE;  /* Bits(1:0), null */
      logic [1:0]  rsvd0;        /* Bits(3:2), Reserved */
      logic        LUT_WIDTH;    /* Bits(4:4), null */
      logic [2:0]  rsvd1;        /* Bits(7:5), Reserved */
      logic [3:0]  CH_LVDS;      /* Bits(11:8), null */
      logic        COLOR;        /* Bits(12:12), null */
      logic        FPN_73;       /* Bits(13:13), FPN 7.3 correction CAP */
      logic        EXP_FOT;      /* Bits(14:14), null */
      logic        DPC;          /* Bits(15:15), null */
      logic [15:0] rsvd2;        /* Bits(31:16), Reserved */
   } f;

} fdk_regfile_xgs_ctrl_SYSTEM_ACQ_CAP_t;


/**************************************************************************
* Register name : GRAB_CTRL
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic        GRAB_CMD;                /* Bits(0:0), GRAB CoMmanD */
      logic        BUFFER_ID;               /* Bits(1:1), null */
      logic [1:0]  rsvd0;                   /* Bits(3:2), Reserved */
      logic        GRAB_SS;                 /* Bits(4:4), GRAB Software Snapshot */
      logic [2:0]  rsvd1;                   /* Bits(7:5), Reserved */
      logic [2:0]  TRIGGER_SRC;             /* Bits(10:8), TRIGGER SouRCe */
      logic        rsvd2;                   /* Bits(11:11), Reserved */
      logic [2:0]  TRIGGER_ACT;             /* Bits(14:12), TRIGGER ACTivation */
      logic        TRIGGER_OVERLAP;         /* Bits(15:15), null */
      logic        TRIGGER_OVERLAP_BUFFn;   /* Bits(16:16), null */
      logic [10:0] rsvd3;                   /* Bits(27:17), Reserved */
      logic        ABORT_GRAB;              /* Bits(28:28), ABORT GRAB */
      logic        GRAB_ROI2_EN;            /* Bits(29:29), null */
      logic        rsvd4;                   /* Bits(30:30), Reserved */
      logic        RESET_GRAB;              /* Bits(31:31), null */
      logic        rsvd_register_space[1];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_ctrl_ACQ_GRAB_CTRL_t;


/**************************************************************************
* Register name : GRAB_STAT
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic       GRAB_IDLE;               /* Bits(0:0), null */
      logic       GRAB_ACTIVE;             /* Bits(1:1), null */
      logic       GRAB_PENDING;            /* Bits(2:2), null */
      logic       rsvd0;                   /* Bits(3:3), Reserved */
      logic       GRAB_EXPOSURE;           /* Bits(4:4), null */
      logic       GRAB_READOUT;            /* Bits(5:5), null */
      logic       GRAB_FOT;                /* Bits(6:6), GRAB Field Overhead Time */
      logic       rsvd1;                   /* Bits(7:7), Reserved */
      logic [3:0] GRAB_MNGR_STAT;          /* Bits(11:8), null */
      logic [2:0] TIMER_MNGR_STAT;         /* Bits(14:12), null */
      logic       rsvd2;                   /* Bits(15:15), Reserved */
      logic [3:0] TRIG_MNGR_STAT;          /* Bits(19:16), null */
      logic [2:0] ABORT_MNGR_STAT;         /* Bits(22:20), null */
      logic       rsvd3;                   /* Bits(23:23), Reserved */
      logic       TRIGGER_RDY;             /* Bits(24:24), null */
      logic [2:0] rsvd4;                   /* Bits(27:25), Reserved */
      logic       ABORT_DONE;              /* Bits(28:28), ABORT is DONE */
      logic       ABORT_DELAI;             /* Bits(29:29), null */
      logic       ABORT_PET;               /* Bits(30:30), ABORT during PET */
      logic       GRAB_CMD_DONE;           /* Bits(31:31), GRAB CoMmanD DONE */
      logic       rsvd_register_space[1];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_ctrl_ACQ_GRAB_STAT_t;


/**************************************************************************
* Register name : READOUT_CFG1
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [15:0] FOT_LENGTH;              /* Bits(15:0), Frame Overhead Time LENGTH */
      logic [9:0]  ROT_LENGTH;              /* Bits(25:16), Row Overhead Time LENGTH */
      logic [1:0]  rsvd0;                   /* Bits(27:26), Reserved */
      logic        GRAB_REVX;               /* Bits(28:28), null */
      logic        GRAB_REVX_OVER;          /* Bits(29:29), null */
      logic        GRAB_REVX_OVER_RST;      /* Bits(30:30), null */
      logic        rsvd1;                   /* Bits(31:31), Reserved */
      logic        rsvd_register_space[1];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_ctrl_ACQ_READOUT_CFG1_t;


/**************************************************************************
* Register name : READOUT_CFG2
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [28:0] READOUT_LENGTH;          /* Bits(28:0), null */
      logic [2:0]  rsvd0;                   /* Bits(31:29), Reserved */
      logic        rsvd_register_space[1];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_ctrl_ACQ_READOUT_CFG2_t;


/**************************************************************************
* Register name : READOUT_CFG3
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [15:0] LINE_TIME;          /* Bits(15:0), LINE TIME */
      logic        KEEP_OUT_TRIG_ENA;  /* Bits(16:16), null */
      logic [14:0] rsvd0;              /* Bits(31:17), Reserved */
   } f;

} fdk_regfile_xgs_ctrl_ACQ_READOUT_CFG3_t;


/**************************************************************************
* Register name : READOUT_CFG4
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [15:0] KEEP_OUT_TRIG_START;  /* Bits(15:0), null */
      logic [15:0] KEEP_OUT_TRIG_END;    /* Bits(31:16), null */
   } f;

} fdk_regfile_xgs_ctrl_ACQ_READOUT_CFG4_t;


/**************************************************************************
* Register name : EXP_CTRL1
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [27:0] EXPOSURE_SS;             /* Bits(27:0), EXPOSURE Single Slope */
      logic        EXPOSURE_LEV_MODE;       /* Bits(28:28), EXPOSURE LEVel MODE */
      logic [2:0]  rsvd0;                   /* Bits(31:29), Reserved */
      logic        rsvd_register_space[1];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_ctrl_ACQ_EXP_CTRL1_t;


/**************************************************************************
* Register name : EXP_CTRL2
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [27:0] EXPOSURE_DS;             /* Bits(27:0), EXPOSURE Dual */
      logic [3:0]  rsvd0;                   /* Bits(31:28), Reserved */
      logic        rsvd_register_space[1];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_ctrl_ACQ_EXP_CTRL2_t;


/**************************************************************************
* Register name : EXP_CTRL3
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [27:0] EXPOSURE_TS;             /* Bits(27:0), EXPOSURE Tripple */
      logic [3:0]  rsvd0;                   /* Bits(31:28), Reserved */
      logic        rsvd_register_space[1];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_ctrl_ACQ_EXP_CTRL3_t;


/**************************************************************************
* Register name : TRIGGER_DELAY
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [27:0] TRIGGER_DELAY;           /* Bits(27:0), TRIGGER DELAY */
      logic [3:0]  rsvd0;                   /* Bits(31:28), Reserved */
      logic        rsvd_register_space[1];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_ctrl_ACQ_TRIGGER_DELAY_t;


/**************************************************************************
* Register name : STROBE_CTRL1
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [27:0] STROBE_START;            /* Bits(27:0), STROBE START */
      logic        STROBE_POL;              /* Bits(28:28), STROBE POLarity */
      logic [1:0]  rsvd0;                   /* Bits(30:29), Reserved */
      logic        STROBE_E;                /* Bits(31:31), STROBE Enable */
      logic        rsvd_register_space[1];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_ctrl_ACQ_STROBE_CTRL1_t;


/**************************************************************************
* Register name : STROBE_CTRL2
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [27:0] STROBE_END;              /* Bits(27:0), STROBE END */
      logic        STROBE_A_EN;             /* Bits(28:28), STROBE phase A ENable */
      logic        STROBE_B_EN;             /* Bits(29:29), STROBE phase B ENable */
      logic        rsvd0;                   /* Bits(30:30), Reserved */
      logic        STROBE_MODE;             /* Bits(31:31), STROBE MODE */
      logic        rsvd_register_space[1];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_ctrl_ACQ_STROBE_CTRL2_t;


/**************************************************************************
* Register name : ACQ_SER_CTRL
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic        SER_WF_SS;               /* Bits(0:0), SERial Write Fifo SnapShot */
      logic [2:0]  rsvd0;                   /* Bits(3:1), Reserved */
      logic        SER_RF_SS;               /* Bits(4:4), SERial Read Fifo SnapShot */
      logic [2:0]  rsvd1;                   /* Bits(7:5), Reserved */
      logic [1:0]  SER_CMD;                 /* Bits(9:8), SERial CoMmand */
      logic [5:0]  rsvd2;                   /* Bits(15:10), Reserved */
      logic        SER_RWn;                 /* Bits(16:16), SERial Read/Writen */
      logic [14:0] rsvd3;                   /* Bits(31:17), Reserved */
      logic        rsvd_register_space[1];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_ctrl_ACQ_ACQ_SER_CTRL_t;


/**************************************************************************
* Register name : ACQ_SER_ADDATA
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [14:0] SER_ADD;                 /* Bits(14:0), SERial interface ADDress */
      logic        rsvd0;                   /* Bits(15:15), Reserved */
      logic [15:0] SER_DAT;                 /* Bits(31:16), SERial interface DATa */
      logic        rsvd_register_space[1];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_ctrl_ACQ_ACQ_SER_ADDATA_t;


/**************************************************************************
* Register name : ACQ_SER_STAT
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [15:0] SER_DAT_R;               /* Bits(15:0), SERial interface DATa Read */
      logic        SER_BUSY;                /* Bits(16:16), SERial BUSY */
      logic [6:0]  rsvd0;                   /* Bits(23:17), Reserved */
      logic        SER_FIFO_EMPTY;          /* Bits(24:24), SERial FIFO EMPTY */
      logic [6:0]  rsvd1;                   /* Bits(31:25), Reserved */
      logic        rsvd_register_space[9];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_ctrl_ACQ_ACQ_SER_STAT_t;


/**************************************************************************
* Register name : SENSOR_CTRL
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic       SENSOR_POWERUP;          /* Bits(0:0), null */
      logic       SENSOR_RESETN;           /* Bits(1:1), SENSOR RESET Not */
      logic [1:0] rsvd0;                   /* Bits(3:2), Reserved */
      logic       SENSOR_REG_UPTATE;       /* Bits(4:4), SENSOR REGister UPDATE */
      logic [2:0] rsvd1;                   /* Bits(7:5), Reserved */
      logic       SENSOR_COLOR;            /* Bits(8:8), SENSOR COLOR */
      logic [6:0] rsvd2;                   /* Bits(15:9), Reserved */
      logic       SENSOR_POWERDOWN;        /* Bits(16:16), null */
      logic [6:0] rsvd3;                   /* Bits(23:17), Reserved */
      logic       SENSOR_REFRESH_TEMP;     /* Bits(24:24), SENSOR REFRESH TEMPerature */
      logic [6:0] rsvd4;                   /* Bits(31:25), Reserved */
      logic       rsvd_register_space[1];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_ctrl_ACQ_SENSOR_CTRL_t;


/**************************************************************************
* Register name : SENSOR_STAT
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic       SENSOR_POWERUP_DONE;     /* Bits(0:0), null */
      logic       SENSOR_POWERUP_STAT;     /* Bits(1:1), null */
      logic [5:0] rsvd0;                   /* Bits(7:2), Reserved */
      logic       SENSOR_VCC_PG;           /* Bits(8:8), SENSOR supply VCC  Power Good */
      logic [2:0] rsvd1;                   /* Bits(11:9), Reserved */
      logic       SENSOR_OSC_EN;           /* Bits(12:12), SENSOR OSCILLATOR ENable */
      logic       SENSOR_RESETN;           /* Bits(13:13), SENSOR RESET N */
      logic [1:0] rsvd2;                   /* Bits(15:14), Reserved */
      logic       SENSOR_POWERDOWN;        /* Bits(16:16), null */
      logic [5:0] rsvd3;                   /* Bits(22:17), Reserved */
      logic       SENSOR_TEMP_VALID;       /* Bits(23:23), SENSOR TEMPerature VALID */
      logic [7:0] SENSOR_TEMP;             /* Bits(31:24), null */
      logic       rsvd_register_space[1];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_ctrl_ACQ_SENSOR_STAT_t;


/**************************************************************************
* Register name : SENSOR_SUBSAMPLING
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic        SUBSAMPLING_X;         /* Bits(0:0), */
      logic        M_SUBSAMPLING_Y;       /* Bits(1:1), */
      logic        reserved0;             /* Bits(2:2), */
      logic        ACTIVE_SUBSAMPLING_Y;  /* Bits(3:3), null */
      logic [11:0] reserved1;             /* Bits(15:4), null */
      logic [15:0] rsvd0;                 /* Bits(31:16), Reserved */
   } f;

} fdk_regfile_xgs_ctrl_ACQ_SENSOR_SUBSAMPLING_t;


/**************************************************************************
* Register name : SENSOR_GAIN_ANA
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [7:0]  reserved0;    /* Bits(7:0), null */
      logic [2:0]  ANALOG_GAIN;  /* Bits(10:8), */
      logic [4:0]  reserved1;    /* Bits(15:11), null */
      logic [15:0] rsvd0;        /* Bits(31:16), Reserved */
   } f;

} fdk_regfile_xgs_ctrl_ACQ_SENSOR_GAIN_ANA_t;


/**************************************************************************
* Register name : SENSOR_ROI_Y_START
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [9:0]  Y_START;   /* Bits(9:0), Y START */
      logic [5:0]  reserved;  /* Bits(15:10), null */
      logic [15:0] rsvd0;     /* Bits(31:16), Reserved */
   } f;

} fdk_regfile_xgs_ctrl_ACQ_SENSOR_ROI_Y_START_t;


/**************************************************************************
* Register name : SENSOR_ROI_Y_SIZE
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [9:0]  Y_SIZE;    /* Bits(9:0), Y SIZE */
      logic [5:0]  reserved;  /* Bits(15:10), null */
      logic [15:0] rsvd0;     /* Bits(31:16), Reserved */
   } f;

} fdk_regfile_xgs_ctrl_ACQ_SENSOR_ROI_Y_SIZE_t;


/**************************************************************************
* Register name : SENSOR_ROI2_Y_START
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [9:0]  Y_START;   /* Bits(9:0), Y START */
      logic [5:0]  reserved;  /* Bits(15:10), null */
      logic [15:0] rsvd0;     /* Bits(31:16), Reserved */
   } f;

} fdk_regfile_xgs_ctrl_ACQ_SENSOR_ROI2_Y_START_t;


/**************************************************************************
* Register name : SENSOR_ROI2_Y_SIZE
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [9:0]  Y_SIZE;                  /* Bits(9:0), Y SIZE */
      logic [5:0]  reserved;                /* Bits(15:10), null */
      logic [15:0] rsvd0;                   /* Bits(31:16), Reserved */
      logic        rsvd_register_space[8];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_ctrl_ACQ_SENSOR_ROI2_Y_SIZE_t;


/**************************************************************************
* Register name : SENSOR_M_LINES
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [9:0]  M_LINES;       /* Bits(9:0), null */
      logic [4:0]  M_SUPPRESSED;  /* Bits(14:10), null */
      logic [16:0] rsvd0;         /* Bits(31:15), Reserved */
   } f;

} fdk_regfile_xgs_ctrl_ACQ_SENSOR_M_LINES_t;


/**************************************************************************
* Register name : SENSOR_F_LINES
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [9:0]  F_LINES;       /* Bits(9:0), null */
      logic [4:0]  F_SUPPRESSED;  /* Bits(14:10), null */
      logic [16:0] rsvd0;         /* Bits(31:15), Reserved */
   } f;

} fdk_regfile_xgs_ctrl_ACQ_SENSOR_F_LINES_t;


/**************************************************************************
* Register name : DEBUG_PINS
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [4:0] Debug0_sel;              /* Bits(4:0), null */
      logic [2:0] rsvd0;                   /* Bits(7:5), Reserved */
      logic [4:0] Debug1_sel;              /* Bits(12:8), null */
      logic [2:0] rsvd1;                   /* Bits(15:13), Reserved */
      logic [4:0] Debug2_sel;              /* Bits(20:16), null */
      logic [2:0] rsvd2;                   /* Bits(23:21), Reserved */
      logic [4:0] Debug3_sel;              /* Bits(28:24), null */
      logic [2:0] rsvd3;                   /* Bits(31:29), Reserved */
      logic       rsvd_register_space[1];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_ctrl_ACQ_DEBUG_PINS_t;


/**************************************************************************
* Register name : TRIGGER_MISSED
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [15:0] TRIGGER_MISSED_CNTR;     /* Bits(15:0), TRIGGER MISSED CouNTeR */
      logic [11:0] rsvd0;                   /* Bits(27:16), Reserved */
      logic        TRIGGER_MISSED_RST;      /* Bits(28:28), TRIGGER MISSED ReSeT */
      logic [2:0]  rsvd1;                   /* Bits(31:29), Reserved */
      logic        rsvd_register_space[1];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_ctrl_ACQ_TRIGGER_MISSED_t;


/**************************************************************************
* Register name : SENSOR_FPS
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [15:0] SENSOR_FPS;               /* Bits(15:0), SENSOR Frame Per Second */
      logic [15:0] rsvd0;                    /* Bits(31:16), Reserved */
      logic        rsvd_register_space[43];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_ctrl_ACQ_SENSOR_FPS_t;


/**************************************************************************
* Register name : DEBUG
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic       LED_TEST;                /* Bits(0:0), null */
      logic [1:0] LED_TEST_COLOR;          /* Bits(2:1), null */
      logic       rsvd0;                   /* Bits(3:3), Reserved */
      logic [1:0] LED_STAT_CTRL;           /* Bits(5:4), null */
      logic [1:0] LED_STAT_CLHS;           /* Bits(7:6), null */
      logic       TEST_MODE;               /* Bits(8:8), null */
      logic       TEST_MOVE;               /* Bits(9:9), null */
      logic [5:0] rsvd1;                   /* Bits(15:10), Reserved */
      logic [9:0] TEST_MODE_PIX_START;     /* Bits(25:16), null */
      logic [1:0] rsvd2;                   /* Bits(27:26), Reserved */
      logic       DEBUG_RST_CNTR;          /* Bits(28:28), null */
      logic [2:0] rsvd3;                   /* Bits(31:29), Reserved */
      logic       rsvd_register_space[1];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_ctrl_ACQ_DEBUG_t;


/**************************************************************************
* Register name : DEBUG_CNTR1
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [31:0] EOF_CNTR;                /* Bits(31:0), null */
      logic        rsvd_register_space[1];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_ctrl_ACQ_DEBUG_CNTR1_t;


/**************************************************************************
* Register name : DEBUG_CNTR2
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [11:0] EOL_CNTR;  /* Bits(11:0), null */
      logic [19:0] rsvd0;     /* Bits(31:12), Reserved */
   } f;

} fdk_regfile_xgs_ctrl_ACQ_DEBUG_CNTR2_t;


/**************************************************************************
* Register name : DEBUG_CNTR3
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [27:0] SENSOR_FRAME_DURATION;  /* Bits(27:0), */
      logic [3:0]  rsvd0;                  /* Bits(31:28), Reserved */
   } f;

} fdk_regfile_xgs_ctrl_ACQ_DEBUG_CNTR3_t;


/**************************************************************************
* Register name : EXP_FOT
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [11:0] EXP_FOT_TIME;            /* Bits(11:0), EXPosure during FOT TIME */
      logic [3:0]  rsvd0;                   /* Bits(15:12), Reserved */
      logic        EXP_FOT;                 /* Bits(16:16), EXPosure during FOT */
      logic [14:0] rsvd1;                   /* Bits(31:17), Reserved */
      logic        rsvd_register_space[1];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_ctrl_ACQ_EXP_FOT_t;


/**************************************************************************
* Register name : ACQ_SFNC
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic        RELOAD_GRAB_PARAMS;      /* Bits(0:0), */
      logic [30:0] rsvd0;                   /* Bits(31:1), Reserved */
      logic        rsvd_register_space[3];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_ctrl_ACQ_ACQ_SFNC_t;


/**************************************************************************
* Section name   : SYSTEM
***************************************************************************/
typedef struct packed
{
   fdk_regfile_xgs_ctrl_SYSTEM_ID_t      ID;       /* Address offset: 0x0 */
   fdk_regfile_xgs_ctrl_SYSTEM_ACQ_CAP_t ACQ_CAP;  /* Address offset: 0x30 */
} fdk_regfile_xgs_ctrl_SYSTEM_t;


/**************************************************************************
* Section name   : ACQ
***************************************************************************/
typedef struct packed
{
   fdk_regfile_xgs_ctrl_ACQ_GRAB_CTRL_t           GRAB_CTRL;            /* Address offset: 0x0 */
   fdk_regfile_xgs_ctrl_ACQ_GRAB_STAT_t           GRAB_STAT;            /* Address offset: 0x8 */
   fdk_regfile_xgs_ctrl_ACQ_READOUT_CFG1_t        READOUT_CFG1;         /* Address offset: 0x10 */
   fdk_regfile_xgs_ctrl_ACQ_READOUT_CFG2_t        READOUT_CFG2;         /* Address offset: 0x18 */
   fdk_regfile_xgs_ctrl_ACQ_READOUT_CFG3_t        READOUT_CFG3;         /* Address offset: 0x20 */
   fdk_regfile_xgs_ctrl_ACQ_READOUT_CFG4_t        READOUT_CFG4;         /* Address offset: 0x24 */
   fdk_regfile_xgs_ctrl_ACQ_EXP_CTRL1_t           EXP_CTRL1;            /* Address offset: 0x28 */
   fdk_regfile_xgs_ctrl_ACQ_EXP_CTRL2_t           EXP_CTRL2;            /* Address offset: 0x30 */
   fdk_regfile_xgs_ctrl_ACQ_EXP_CTRL3_t           EXP_CTRL3;            /* Address offset: 0x38 */
   fdk_regfile_xgs_ctrl_ACQ_TRIGGER_DELAY_t       TRIGGER_DELAY;        /* Address offset: 0x40 */
   fdk_regfile_xgs_ctrl_ACQ_STROBE_CTRL1_t        STROBE_CTRL1;         /* Address offset: 0x48 */
   fdk_regfile_xgs_ctrl_ACQ_STROBE_CTRL2_t        STROBE_CTRL2;         /* Address offset: 0x50 */
   fdk_regfile_xgs_ctrl_ACQ_ACQ_SER_CTRL_t        ACQ_SER_CTRL;         /* Address offset: 0x58 */
   fdk_regfile_xgs_ctrl_ACQ_ACQ_SER_ADDATA_t      ACQ_SER_ADDATA;       /* Address offset: 0x60 */
   fdk_regfile_xgs_ctrl_ACQ_ACQ_SER_STAT_t        ACQ_SER_STAT;         /* Address offset: 0x68 */
   fdk_regfile_xgs_ctrl_ACQ_SENSOR_CTRL_t         SENSOR_CTRL;          /* Address offset: 0x90 */
   fdk_regfile_xgs_ctrl_ACQ_SENSOR_STAT_t         SENSOR_STAT;          /* Address offset: 0x98 */
   fdk_regfile_xgs_ctrl_ACQ_SENSOR_SUBSAMPLING_t  SENSOR_SUBSAMPLING;   /* Address offset: 0xa0 */
   fdk_regfile_xgs_ctrl_ACQ_SENSOR_GAIN_ANA_t     SENSOR_GAIN_ANA;      /* Address offset: 0xa4 */
   fdk_regfile_xgs_ctrl_ACQ_SENSOR_ROI_Y_START_t  SENSOR_ROI_Y_START;   /* Address offset: 0xa8 */
   fdk_regfile_xgs_ctrl_ACQ_SENSOR_ROI_Y_SIZE_t   SENSOR_ROI_Y_SIZE;    /* Address offset: 0xac */
   fdk_regfile_xgs_ctrl_ACQ_SENSOR_ROI2_Y_START_t SENSOR_ROI2_Y_START;  /* Address offset: 0xb0 */
   fdk_regfile_xgs_ctrl_ACQ_SENSOR_ROI2_Y_SIZE_t  SENSOR_ROI2_Y_SIZE;   /* Address offset: 0xb4 */
   fdk_regfile_xgs_ctrl_ACQ_SENSOR_M_LINES_t      SENSOR_M_LINES;       /* Address offset: 0xd8 */
   fdk_regfile_xgs_ctrl_ACQ_SENSOR_F_LINES_t      SENSOR_F_LINES;       /* Address offset: 0xdc */
   fdk_regfile_xgs_ctrl_ACQ_DEBUG_PINS_t          DEBUG_PINS;           /* Address offset: 0xe0 */
   fdk_regfile_xgs_ctrl_ACQ_TRIGGER_MISSED_t      TRIGGER_MISSED;       /* Address offset: 0xe8 */
   fdk_regfile_xgs_ctrl_ACQ_SENSOR_FPS_t          SENSOR_FPS;           /* Address offset: 0xf0 */
   fdk_regfile_xgs_ctrl_ACQ_DEBUG_t               DEBUG;                /* Address offset: 0x1a0 */
   fdk_regfile_xgs_ctrl_ACQ_DEBUG_CNTR1_t         DEBUG_CNTR1;          /* Address offset: 0x1a8 */
   fdk_regfile_xgs_ctrl_ACQ_DEBUG_CNTR2_t         DEBUG_CNTR2;          /* Address offset: 0x1b0 */
   fdk_regfile_xgs_ctrl_ACQ_DEBUG_CNTR3_t         DEBUG_CNTR3;          /* Address offset: 0x1b4 */
   fdk_regfile_xgs_ctrl_ACQ_EXP_FOT_t             EXP_FOT;              /* Address offset: 0x1b8 */
   fdk_regfile_xgs_ctrl_ACQ_ACQ_SFNC_t            ACQ_SFNC;             /* Address offset: 0x1c0 */
} fdk_regfile_xgs_ctrl_ACQ_t;


/**************************************************************************
* Register file name : regfile_xgs_ctrl
***************************************************************************/
typedef struct packed
{
   fdk_regfile_xgs_ctrl_SYSTEM_t SYSTEM;       /* Section; Base address offset: 0x0 */
   uint32_t                      [50:0]rsvd0;  /* Padding; Size (204 Bytes) */
   fdk_regfile_xgs_ctrl_ACQ_t    ACQ;          /* Section; Base address offset: 0x100 */
} fdk_regfile_xgs_ctrl_t;

