/*****************************************************************************
 ** File                : regfile_xgs_athena.sv
 ** Project             : FDK
 ** Module              : regfile_xgs_athena
 ** Created on          : 2021/09/09 15:51:51
 ** Created by          : jmansill
 ** FDK IDE Version     : 4.7.0_beta4
 ** Build ID            : I20191220-1537
 ** Register file CRC32 : 0xA02D6828
 **
 **  COPYRIGHT (c) 2021 Matrox Electronic Systems Ltd.
 **  All Rights Reserved
 **
 *****************************************************************************/
typedef bit  [7:0][3:0]  uint8_t;
typedef bit  [15:0][1:0] uint16_t;
typedef bit  [31:0]      uint32_t;



/**************************************************************************
* Register name : TAG
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [23:0] VALUE;  /* Bits(23:0), Tag identifier */
      logic [7:0]  rsvd0;  /* Bits(31:24), Reserved */
   } f;

} fdk_regfile_xgs_athena_SYSTEM_TAG_t;


/**************************************************************************
* Register name : VERSION
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [7:0] HW;     /* Bits(7:0), null */
      logic [7:0] MINOR;  /* Bits(15:8), null */
      logic [7:0] MAJOR;  /* Bits(23:16), null */
      logic [7:0] rsvd0;  /* Bits(31:24), Reserved */
   } f;

} fdk_regfile_xgs_athena_SYSTEM_VERSION_t;


/**************************************************************************
* Register name : CAPABILITY
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [7:0]  VALUE;  /* Bits(7:0), null */
      logic [23:0] rsvd0;  /* Bits(31:8), Reserved */
   } f;

} fdk_regfile_xgs_athena_SYSTEM_CAPABILITY_t;


/**************************************************************************
* Register name : SCRATCHPAD
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [31:0] VALUE;  /* Bits(31:0), null */
   } f;

} fdk_regfile_xgs_athena_SYSTEM_SCRATCHPAD_t;


/**************************************************************************
* Register name : CTRL
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic        GRAB_QUEUE_EN;           /* Bits(0:0), */
      logic [30:0] rsvd0;                   /* Bits(31:1), Reserved */
      logic        rsvd_register_space[1];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_athena_DMA_CTRL_t;


/**************************************************************************
* Register name : FSTART
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [31:0] VALUE;  /* Bits(31:0), INitial GRAb ADDRess Register */
   } f;

} fdk_regfile_xgs_athena_DMA_FSTART_t;


/**************************************************************************
* Register name : FSTART_HIGH
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [31:0] VALUE;  /* Bits(31:0), INitial GRAb ADDRess Register High */
   } f;

} fdk_regfile_xgs_athena_DMA_FSTART_HIGH_t;


/**************************************************************************
* Register name : FSTART_G
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [31:0] VALUE;  /* Bits(31:0), GRAb ADDRess Register */
   } f;

} fdk_regfile_xgs_athena_DMA_FSTART_G_t;


/**************************************************************************
* Register name : FSTART_G_HIGH
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [31:0] VALUE;  /* Bits(31:0), GRAb ADDRess Register High */
   } f;

} fdk_regfile_xgs_athena_DMA_FSTART_G_HIGH_t;


/**************************************************************************
* Register name : FSTART_R
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [31:0] VALUE;  /* Bits(31:0), GRAb ADDRess Register */
   } f;

} fdk_regfile_xgs_athena_DMA_FSTART_R_t;


/**************************************************************************
* Register name : FSTART_R_HIGH
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [31:0] VALUE;  /* Bits(31:0), GRAb ADDRess Register High */
   } f;

} fdk_regfile_xgs_athena_DMA_FSTART_R_HIGH_t;


/**************************************************************************
* Register name : LINE_PITCH
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [15:0] VALUE;  /* Bits(15:0), Grab LinePitch */
      logic [15:0] rsvd0;  /* Bits(31:16), Reserved */
   } f;

} fdk_regfile_xgs_athena_DMA_LINE_PITCH_t;


/**************************************************************************
* Register name : LINE_SIZE
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [13:0] VALUE;  /* Bits(13:0), Host Line size */
      logic [17:0] rsvd0;  /* Bits(31:14), Reserved */
   } f;

} fdk_regfile_xgs_athena_DMA_LINE_SIZE_t;


/**************************************************************************
* Register name : CSC
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [7:0] rsvd0;                   /* Bits(7:0), Reserved */
      logic       REVERSE_X;               /* Bits(8:8), Reverse image in X direction */
      logic       REVERSE_Y;               /* Bits(9:9), REVERSE Y */
      logic [3:0] SUB_X;                   /* Bits(13:10), null */
      logic [8:0] rsvd1;                   /* Bits(22:14), Reserved */
      logic       DUP_LAST_LINE;           /* Bits(23:23), null */
      logic [2:0] COLOR_SPACE;             /* Bits(26:24), null */
      logic [4:0] rsvd2;                   /* Bits(31:27), Reserved */
      logic       rsvd_register_space[3];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_athena_DMA_CSC_t;


/**************************************************************************
* Register name : OUTPUT_BUFFER
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic        CLR_MAX_LINE_BUFF_CNT;  /* Bits(0:0), Clear maximum line buffer count */
      logic [2:0]  rsvd0;                  /* Bits(3:1), Reserved */
      logic        PCIE_BACK_PRESSURE;     /* Bits(4:4), PCIE link back pressure detected */
      logic [14:0] rsvd1;                  /* Bits(19:5), Reserved */
      logic [3:0]  ADDRESS_BUS_WIDTH;      /* Bits(23:20), Line buffer address size in bits */
      logic [1:0]  LINE_PTR_WIDTH;         /* Bits(25:24), Line pointer size (in bits) */
      logic [1:0]  rsvd2;                  /* Bits(27:26), Reserved */
      logic [3:0]  MAX_LINE_BUFF_CNT;      /* Bits(31:28), Maximum line buffer count */
   } f;

} fdk_regfile_xgs_athena_DMA_OUTPUT_BUFFER_t;


/**************************************************************************
* Register name : TLP
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [2:0]  CFG_MAX_PLD;    /* Bits(2:0), PCIe Device Control Register (Offset 08h); bits 7 downto 5 */
      logic        BUS_MASTER_EN;  /* Bits(3:3), null */
      logic [11:0] rsvd0;          /* Bits(15:4), Reserved */
      logic [11:0] MAX_PAYLOAD;    /* Bits(27:16), null */
      logic [3:0]  rsvd1;          /* Bits(31:28), Reserved */
   } f;

} fdk_regfile_xgs_athena_DMA_TLP_t;


/**************************************************************************
* Register name : ROI_X
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [12:0] X_START;                 /* Bits(12:0), null */
      logic [2:0]  rsvd0;                   /* Bits(15:13), Reserved */
      logic [12:0] X_SIZE;                  /* Bits(28:16), null */
      logic [1:0]  rsvd1;                   /* Bits(30:29), Reserved */
      logic        ROI_EN;                  /* Bits(31:31), Region of interest enable */
      logic        rsvd_register_space[2];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_athena_DMA_ROI_X_t;


/**************************************************************************
* Register name : ROI_Y
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [12:0] Y_START;                 /* Bits(12:0), null */
      logic [2:0]  rsvd0;                   /* Bits(15:13), Reserved */
      logic [12:0] Y_SIZE;                  /* Bits(28:16), null */
      logic [1:0]  rsvd1;                   /* Bits(30:29), Reserved */
      logic        ROI_EN;                  /* Bits(31:31), Region of interest enable */
      logic        rsvd_register_space[2];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_athena_DMA_ROI_Y_t;


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

} fdk_regfile_xgs_athena_ACQ_GRAB_CTRL_t;


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

} fdk_regfile_xgs_athena_ACQ_GRAB_STAT_t;


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
      logic [15:0] FOT_LENGTH;       /* Bits(15:0), Frame Overhead Time LENGTH */
      logic        EO_FOT_SEL;       /* Bits(16:16), null */
      logic [6:0]  rsvd0;            /* Bits(23:17), Reserved */
      logic [4:0]  FOT_LENGTH_LINE;  /* Bits(28:24), Frame Overhead Time LENGTH LINE */
      logic [2:0]  rsvd1;            /* Bits(31:29), Reserved */
   } f;

} fdk_regfile_xgs_athena_ACQ_READOUT_CFG1_t;


/**************************************************************************
* Register name : READOUT_CFG_FRAME_LINE
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [12:0] CURR_FRAME_LINES;  /* Bits(12:0), null */
      logic [2:0]  rsvd0;             /* Bits(15:13), Reserved */
      logic [7:0]  DUMMY_LINES;       /* Bits(23:16), null */
      logic [7:0]  rsvd1;             /* Bits(31:24), Reserved */
   } f;

} fdk_regfile_xgs_athena_ACQ_READOUT_CFG_FRAME_LINE_t;


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

} fdk_regfile_xgs_athena_ACQ_READOUT_CFG2_t;


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
      logic [15:0] LINE_TIME;  /* Bits(15:0), LINE TIME */
      logic [15:0] rsvd0;      /* Bits(31:16), Reserved */
   } f;

} fdk_regfile_xgs_athena_ACQ_READOUT_CFG3_t;


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
      logic        KEEP_OUT_TRIG_ENA;    /* Bits(16:16), null */
      logic [14:0] rsvd0;                /* Bits(31:17), Reserved */
   } f;

} fdk_regfile_xgs_athena_ACQ_READOUT_CFG4_t;


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

} fdk_regfile_xgs_athena_ACQ_EXP_CTRL1_t;


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

} fdk_regfile_xgs_athena_ACQ_EXP_CTRL2_t;


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

} fdk_regfile_xgs_athena_ACQ_EXP_CTRL3_t;


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

} fdk_regfile_xgs_athena_ACQ_TRIGGER_DELAY_t;


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

} fdk_regfile_xgs_athena_ACQ_STROBE_CTRL1_t;


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

} fdk_regfile_xgs_athena_ACQ_STROBE_CTRL2_t;


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

} fdk_regfile_xgs_athena_ACQ_ACQ_SER_CTRL_t;


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

} fdk_regfile_xgs_athena_ACQ_ACQ_SER_ADDATA_t;


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

} fdk_regfile_xgs_athena_ACQ_ACQ_SER_STAT_t;


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
      logic       SENSOR_REG_UPDATE;       /* Bits(4:4), SENSOR REGister UPDATE */
      logic [2:0] rsvd1;                   /* Bits(7:5), Reserved */
      logic       SENSOR_COLOR;            /* Bits(8:8), SENSOR COLOR */
      logic [6:0] rsvd2;                   /* Bits(15:9), Reserved */
      logic       SENSOR_POWERDOWN;        /* Bits(16:16), null */
      logic [6:0] rsvd3;                   /* Bits(23:17), Reserved */
      logic       SENSOR_REFRESH_TEMP;     /* Bits(24:24), SENSOR REFRESH TEMPerature */
      logic [6:0] rsvd4;                   /* Bits(31:25), Reserved */
      logic       rsvd_register_space[1];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_athena_ACQ_SENSOR_CTRL_t;


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
      logic       SENSOR_POWERUP_DONE;  /* Bits(0:0), null */
      logic       SENSOR_POWERUP_STAT;  /* Bits(1:1), null */
      logic [5:0] rsvd0;                /* Bits(7:2), Reserved */
      logic       SENSOR_VCC_PG;        /* Bits(8:8), SENSOR supply VCC  Power Good */
      logic [2:0] rsvd1;                /* Bits(11:9), Reserved */
      logic       SENSOR_OSC_EN;        /* Bits(12:12), SENSOR OSCILLATOR ENable */
      logic       SENSOR_RESETN;        /* Bits(13:13), SENSOR RESET N */
      logic [1:0] rsvd2;                /* Bits(15:14), Reserved */
      logic       SENSOR_POWERDOWN;     /* Bits(16:16), null */
      logic [5:0] rsvd3;                /* Bits(22:17), Reserved */
      logic       SENSOR_TEMP_VALID;    /* Bits(23:23), SENSOR TEMPerature VALID */
      logic [7:0] SENSOR_TEMP;          /* Bits(31:24), null */
   } f;

} fdk_regfile_xgs_athena_ACQ_SENSOR_STAT_t;


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
      logic        SUBSAMPLING_X;           /* Bits(0:0), */
      logic        M_SUBSAMPLING_Y;         /* Bits(1:1), */
      logic        reserved0;               /* Bits(2:2), */
      logic        ACTIVE_SUBSAMPLING_Y;    /* Bits(3:3), null */
      logic [11:0] reserved1;               /* Bits(15:4), null */
      logic [15:0] rsvd0;                   /* Bits(31:16), Reserved */
      logic        rsvd_register_space[1];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_athena_ACQ_SENSOR_SUBSAMPLING_t;


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

} fdk_regfile_xgs_athena_ACQ_SENSOR_GAIN_ANA_t;


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

} fdk_regfile_xgs_athena_ACQ_SENSOR_ROI_Y_START_t;


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
      logic [9:0]  Y_SIZE;                  /* Bits(9:0), Y SIZE */
      logic [5:0]  reserved;                /* Bits(15:10), null */
      logic [15:0] rsvd0;                   /* Bits(31:16), Reserved */
      logic        rsvd_register_space[2];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_athena_ACQ_SENSOR_ROI_Y_SIZE_t;


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
      logic [9:0]  M_LINES_SENSOR;   /* Bits(9:0), null */
      logic [4:0]  M_SUPPRESSED;     /* Bits(14:10), null */
      logic        M_LINES_DISPLAY;  /* Bits(15:15), null */
      logic [15:0] rsvd0;            /* Bits(31:16), Reserved */
   } f;

} fdk_regfile_xgs_athena_ACQ_SENSOR_M_LINES_t;


/**************************************************************************
* Register name : SENSOR_DP_GR
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [11:0] DP_OFFSET_GR;  /* Bits(11:0), null */
      logic [3:0]  reserved;      /* Bits(15:12), null */
      logic [15:0] rsvd0;         /* Bits(31:16), Reserved */
   } f;

} fdk_regfile_xgs_athena_ACQ_SENSOR_DP_GR_t;


/**************************************************************************
* Register name : SENSOR_DP_GB
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [11:0] DP_OFFSET_GB;  /* Bits(11:0), null */
      logic [3:0]  reserved;      /* Bits(15:12), null */
      logic [15:0] rsvd0;         /* Bits(31:16), Reserved */
   } f;

} fdk_regfile_xgs_athena_ACQ_SENSOR_DP_GB_t;


/**************************************************************************
* Register name : SENSOR_DP_R
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [11:0] DP_OFFSET_R;  /* Bits(11:0), null */
      logic [3:0]  reserved;     /* Bits(15:12), null */
      logic [15:0] rsvd0;        /* Bits(31:16), Reserved */
   } f;

} fdk_regfile_xgs_athena_ACQ_SENSOR_DP_R_t;


/**************************************************************************
* Register name : SENSOR_DP_B
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [11:0] DP_OFFSET_B;  /* Bits(11:0), null */
      logic [3:0]  reserved;     /* Bits(15:12), null */
      logic [15:0] rsvd0;        /* Bits(31:16), Reserved */
   } f;

} fdk_regfile_xgs_athena_ACQ_SENSOR_DP_B_t;


/**************************************************************************
* Register name : SENSOR_GAIN_DIG_G
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [6:0]  DG_FACTOR_GB;  /* Bits(6:0), null */
      logic        reserved0;     /* Bits(7:7), null */
      logic [6:0]  DG_FACTOR_GR;  /* Bits(14:8), null */
      logic        reserved1;     /* Bits(15:15), null */
      logic [15:0] rsvd0;         /* Bits(31:16), Reserved */
   } f;

} fdk_regfile_xgs_athena_ACQ_SENSOR_GAIN_DIG_G_t;


/**************************************************************************
* Register name : SENSOR_GAIN_DIG_RB
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [6:0]  DG_FACTOR_B;             /* Bits(6:0), null */
      logic        reserved0;               /* Bits(7:7), null */
      logic [6:0]  DG_FACTOR_R;             /* Bits(14:8), null */
      logic        reserved1;               /* Bits(15:15), null */
      logic [15:0] rsvd0;                   /* Bits(31:16), Reserved */
      logic        rsvd_register_space[1];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_athena_ACQ_SENSOR_GAIN_DIG_RB_t;


/**************************************************************************
* Register name : FPGA_ROI_X_START
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [12:0] X_START;  /* Bits(12:0), X START */
      logic [18:0] rsvd0;    /* Bits(31:13), Reserved */
   } f;

} fdk_regfile_xgs_athena_ACQ_FPGA_ROI_X_START_t;


/**************************************************************************
* Register name : FPGA_ROI_X_SIZE
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [12:0] X_SIZE;  /* Bits(12:0), X SIZE */
      logic [18:0] rsvd0;   /* Bits(31:13), Reserved */
   } f;

} fdk_regfile_xgs_athena_ACQ_FPGA_ROI_X_SIZE_t;


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

} fdk_regfile_xgs_athena_ACQ_DEBUG_PINS_t;


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

} fdk_regfile_xgs_athena_ACQ_TRIGGER_MISSED_t;


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
      logic [15:0] SENSOR_FPS;  /* Bits(15:0), SENSOR Frame Per Second */
      logic [15:0] rsvd0;       /* Bits(31:16), Reserved */
   } f;

} fdk_regfile_xgs_athena_ACQ_SENSOR_FPS_t;


/**************************************************************************
* Register name : SENSOR_FPS2
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [19:0] SENSOR_FPS;               /* Bits(19:0), SENSOR Frame Per Second */
      logic [11:0] rsvd0;                    /* Bits(31:20), Reserved */
      logic        rsvd_register_space[42];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_athena_ACQ_SENSOR_FPS2_t;


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
      logic        LED_TEST;                /* Bits(0:0), null */
      logic [1:0]  LED_TEST_COLOR;          /* Bits(2:1), null */
      logic [24:0] rsvd0;                   /* Bits(27:3), Reserved */
      logic        DEBUG_RST_CNTR;          /* Bits(28:28), null */
      logic [2:0]  rsvd1;                   /* Bits(31:29), Reserved */
      logic        rsvd_register_space[1];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_athena_ACQ_DEBUG_t;


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
      logic [27:0] SENSOR_FRAME_DURATION;   /* Bits(27:0), */
      logic [3:0]  rsvd0;                   /* Bits(31:28), Reserved */
      logic        rsvd_register_space[3];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_athena_ACQ_DEBUG_CNTR1_t;


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

} fdk_regfile_xgs_athena_ACQ_EXP_FOT_t;


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

} fdk_regfile_xgs_athena_ACQ_ACQ_SFNC_t;


/**************************************************************************
* Register name : TIMER_CTRL
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic        TIMERSTART;  /* Bits(0:0), null */
      logic [2:0]  rsvd0;       /* Bits(3:1), Reserved */
      logic        TIMERSTOP;   /* Bits(4:4), null */
      logic [2:0]  rsvd1;       /* Bits(7:5), Reserved */
      logic        ADAPTATIVE;  /* Bits(8:8), null */
      logic [22:0] rsvd2;       /* Bits(31:9), Reserved */
   } f;

} fdk_regfile_xgs_athena_ACQ_TIMER_CTRL_t;


/**************************************************************************
* Register name : TIMER_DELAY
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [31:0] VALUE;  /* Bits(31:0), null */
   } f;

} fdk_regfile_xgs_athena_ACQ_TIMER_DELAY_t;


/**************************************************************************
* Register name : TIMER_DURATION
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [31:0] VALUE;  /* Bits(31:0), null */
   } f;

} fdk_regfile_xgs_athena_ACQ_TIMER_DURATION_t;


/**************************************************************************
* Register name : CTRL
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic        ENABLE_HISPI;       /* Bits(0:0), null */
      logic        ENABLE_DATA_PATH;   /* Bits(1:1), null */
      logic        SW_CALIB_SERDES;    /* Bits(2:2), Initiate the SERDES TAP calibrartion */
      logic        SW_CLR_HISPI;       /* Bits(3:3), null */
      logic        SW_CLR_IDELAYCTRL;  /* Bits(4:4), Reset the Xilinx macro IDELAYCTRL */
      logic [26:0] rsvd0;              /* Bits(31:5), Reserved */
   } f;

} fdk_regfile_xgs_athena_HISPI_CTRL_t;


/**************************************************************************
* Register name : STATUS
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic        CALIBRATION_DONE;      /* Bits(0:0), Calibration sequence completed */
      logic        CALIBRATION_ERROR;     /* Bits(1:1), Calibration error */
      logic        FIFO_ERROR;            /* Bits(2:2), Calibration active */
      logic        PHY_BIT_LOCKED_ERROR;  /* Bits(3:3), null */
      logic        CRC_ERROR;             /* Bits(4:4), Lane CRC error */
      logic [22:0] rsvd0;                 /* Bits(27:5), Reserved */
      logic [3:0]  FSM;                   /* Bits(31:28), HISPI  finite state machine status */
   } f;

} fdk_regfile_xgs_athena_HISPI_STATUS_t;


/**************************************************************************
* Register name : IDELAYCTRL_STATUS
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic        PLL_LOCKED;  /* Bits(0:0), IDELAYCTRL PLL locked */
      logic [30:0] rsvd0;       /* Bits(31:1), Reserved */
   } f;

} fdk_regfile_xgs_athena_HISPI_IDELAYCTRL_STATUS_t;


/**************************************************************************
* Register name : IDLE_CHARACTER
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [11:0] VALUE;  /* Bits(11:0), null */
      logic [19:0] rsvd0;  /* Bits(31:12), Reserved */
   } f;

} fdk_regfile_xgs_athena_HISPI_IDLE_CHARACTER_t;


/**************************************************************************
* Register name : PHY
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [2:0] NB_LANES;        /* Bits(2:0), Number of physical lane enabled */
      logic [4:0] rsvd0;           /* Bits(7:3), Reserved */
      logic [2:0] MUX_RATIO;       /* Bits(10:8), null */
      logic [4:0] rsvd1;           /* Bits(15:11), Reserved */
      logic [9:0] PIXEL_PER_LANE;  /* Bits(25:16), Number of pixels per lanes */
      logic [5:0] rsvd2;           /* Bits(31:26), Reserved */
   } f;

} fdk_regfile_xgs_athena_HISPI_PHY_t;


/**************************************************************************
* Register name : FRAME_CFG
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [12:0] PIXELS_PER_LINE;  /* Bits(12:0), null */
      logic [2:0]  rsvd0;            /* Bits(15:13), Reserved */
      logic [11:0] LINES_PER_FRAME;  /* Bits(27:16), null */
      logic [3:0]  rsvd1;            /* Bits(31:28), Reserved */
   } f;

} fdk_regfile_xgs_athena_HISPI_FRAME_CFG_t;


/**************************************************************************
* Register name : FRAME_CFG_X_VALID
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [12:0] X_START;                 /* Bits(12:0), null */
      logic [2:0]  rsvd0;                   /* Bits(15:13), Reserved */
      logic [12:0] X_END;                   /* Bits(28:16), null */
      logic [2:0]  rsvd1;                   /* Bits(31:29), Reserved */
      logic        rsvd_register_space[2];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_athena_HISPI_FRAME_CFG_X_VALID_t;


/**************************************************************************
* Register name : LANE_DECODER_STATUS
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic        FIFO_OVERRUN;           /* Bits(0:0), null */
      logic        FIFO_UNDERRUN;          /* Bits(1:1), null */
      logic        CALIBRATION_DONE;       /* Bits(2:2), null */
      logic        CALIBRATION_ERROR;      /* Bits(3:3), null */
      logic [4:0]  CALIBRATION_TAP_VALUE;  /* Bits(8:4), null */
      logic [2:0]  rsvd0;                  /* Bits(11:9), Reserved */
      logic        PHY_BIT_LOCKED;         /* Bits(12:12), null */
      logic        PHY_BIT_LOCKED_ERROR;   /* Bits(13:13), null */
      logic        PHY_SYNC_ERROR;         /* Bits(14:14), null */
      logic        CRC_ERROR;              /* Bits(15:15), CRC Error */
      logic [15:0] rsvd1;                  /* Bits(31:16), Reserved */
   } f;

} fdk_regfile_xgs_athena_HISPI_LANE_DECODER_STATUS_t;


/**************************************************************************
* Register name : TAP_HISTOGRAM
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [31:0] VALUE;  /* Bits(31:0), null */
   } f;

} fdk_regfile_xgs_athena_HISPI_TAP_HISTOGRAM_t;


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
      logic [4:0] TAP_LANE_0;       /* Bits(4:0), null */
      logic [4:0] TAP_LANE_1;       /* Bits(9:5), null */
      logic [4:0] TAP_LANE_2;       /* Bits(14:10), null */
      logic [4:0] TAP_LANE_3;       /* Bits(19:15), null */
      logic [4:0] TAP_LANE_4;       /* Bits(24:20), null */
      logic [4:0] TAP_LANE_5;       /* Bits(29:25), null */
      logic       LOAD_TAPS;        /* Bits(30:30), null */
      logic       MANUAL_CALIB_EN;  /* Bits(31:31), null */
   } f;

} fdk_regfile_xgs_athena_HISPI_DEBUG_t;


/**************************************************************************
* Register name : DPC_CAPABILITIES
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [3:0]  DPC_VER;          /* Bits(3:0), null */
      logic [11:0] rsvd0;            /* Bits(15:4), Reserved */
      logic [11:0] DPC_LIST_LENGTH;  /* Bits(27:16), null */
      logic [3:0]  rsvd1;            /* Bits(31:28), Reserved */
   } f;

} fdk_regfile_xgs_athena_DPC_DPC_CAPABILITIES_t;


/**************************************************************************
* Register name : DPC_LIST_CTRL
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [11:0] dpc_list_add;            /* Bits(11:0), null */
      logic        dpc_list_ss;             /* Bits(12:12), null */
      logic        dpc_list_WRn;            /* Bits(13:13), null */
      logic        dpc_enable;              /* Bits(14:14), null */
      logic        dpc_pattern0_cfg;        /* Bits(15:15), null */
      logic [11:0] dpc_list_count;          /* Bits(27:16), null */
      logic        dpc_firstlast_line_rem;  /* Bits(28:28), null */
      logic        dpc_fifo_reset;          /* Bits(29:29), null */
      logic [1:0]  rsvd0;                   /* Bits(31:30), Reserved */
   } f;

} fdk_regfile_xgs_athena_DPC_DPC_LIST_CTRL_t;


/**************************************************************************
* Register name : DPC_LIST_STAT
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [29:0] rsvd0;              /* Bits(29:0), Reserved */
      logic        dpc_fifo_overrun;   /* Bits(30:30), null */
      logic        dpc_fifo_underrun;  /* Bits(31:31), null */
   } f;

} fdk_regfile_xgs_athena_DPC_DPC_LIST_STAT_t;


/**************************************************************************
* Register name : DPC_LIST_DATA1
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [12:0] dpc_list_corr_x;  /* Bits(12:0), null */
      logic [2:0]  rsvd0;            /* Bits(15:13), Reserved */
      logic [11:0] dpc_list_corr_y;  /* Bits(27:16), null */
      logic [3:0]  rsvd1;            /* Bits(31:28), Reserved */
   } f;

} fdk_regfile_xgs_athena_DPC_DPC_LIST_DATA1_t;


/**************************************************************************
* Register name : DPC_LIST_DATA2
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [7:0]  dpc_list_corr_pattern;  /* Bits(7:0), null */
      logic [23:0] rsvd0;                  /* Bits(31:8), Reserved */
   } f;

} fdk_regfile_xgs_athena_DPC_DPC_LIST_DATA2_t;


/**************************************************************************
* Register name : DPC_LIST_DATA1_RD
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [12:0] dpc_list_corr_x;  /* Bits(12:0), null */
      logic [2:0]  rsvd0;            /* Bits(15:13), Reserved */
      logic [11:0] dpc_list_corr_y;  /* Bits(27:16), null */
      logic [3:0]  rsvd1;            /* Bits(31:28), Reserved */
   } f;

} fdk_regfile_xgs_athena_DPC_DPC_LIST_DATA1_RD_t;


/**************************************************************************
* Register name : DPC_LIST_DATA2_RD
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [7:0]  dpc_list_corr_pattern;  /* Bits(7:0), null */
      logic [23:0] rsvd0;                  /* Bits(31:8), Reserved */
   } f;

} fdk_regfile_xgs_athena_DPC_DPC_LIST_DATA2_RD_t;


/**************************************************************************
* Register name : LUT_CAPABILITIES
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [3:0]  LUT_VER;          /* Bits(3:0), null */
      logic [11:0] rsvd0;            /* Bits(15:4), Reserved */
      logic [11:0] LUT_SIZE_CONFIG;  /* Bits(27:16), null */
      logic [3:0]  rsvd1;            /* Bits(31:28), Reserved */
   } f;

} fdk_regfile_xgs_athena_LUT_LUT_CAPABILITIES_t;


/**************************************************************************
* Register name : LUT_CTRL
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [9:0] LUT_ADD;           /* Bits(9:0), null */
      logic       LUT_SS;            /* Bits(10:10), LUT SnapShot */
      logic       LUT_WRN;           /* Bits(11:11), LUT Write ReadNot */
      logic [3:0] LUT_SEL;           /* Bits(15:12), LUT SELection */
      logic [9:0] LUT_DATA_W;        /* Bits(25:16), LUT DATA to Write */
      logic [1:0] rsvd0;             /* Bits(27:26), Reserved */
      logic       LUT_BYPASS;        /* Bits(28:28), LUT BYPASS */
      logic       LUT_BYPASS_COLOR;  /* Bits(29:29), LUT BYPASS COLOR */
      logic [1:0] rsvd1;             /* Bits(31:30), Reserved */
   } f;

} fdk_regfile_xgs_athena_LUT_LUT_CTRL_t;


/**************************************************************************
* Register name : LUT_RB
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [7:0]  LUT_RB;  /* Bits(7:0), null */
      logic [23:0] rsvd0;   /* Bits(31:8), Reserved */
   } f;

} fdk_regfile_xgs_athena_LUT_LUT_RB_t;


/**************************************************************************
* Register name : BAYER_CAPABILITIES
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [1:0]  BAYER_VER;  /* Bits(1:0), null */
      logic [29:0] rsvd0;      /* Bits(31:2), Reserved */
   } f;

} fdk_regfile_xgs_athena_BAYER_BAYER_CAPABILITIES_t;


/**************************************************************************
* Register name : WB_MUL1
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [15:0] WB_MULT_B;  /* Bits(15:0), null */
      logic [15:0] WB_MULT_G;  /* Bits(31:16), null */
   } f;

} fdk_regfile_xgs_athena_BAYER_WB_MUL1_t;


/**************************************************************************
* Register name : WB_MUL2
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [15:0] WB_MULT_R;  /* Bits(15:0), null */
      logic [15:0] rsvd0;      /* Bits(31:16), Reserved */
   } f;

} fdk_regfile_xgs_athena_BAYER_WB_MUL2_t;


/**************************************************************************
* Register name : WB_B_ACC
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [30:0] B_ACC;  /* Bits(30:0), null */
      logic        rsvd0;  /* Bits(31:31), Reserved */
   } f;

} fdk_regfile_xgs_athena_BAYER_WB_B_ACC_t;


/**************************************************************************
* Register name : WB_G_ACC
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [31:0] G_ACC;  /* Bits(31:0), null */
   } f;

} fdk_regfile_xgs_athena_BAYER_WB_G_ACC_t;


/**************************************************************************
* Register name : WB_R_ACC
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [30:0] R_ACC;  /* Bits(30:0), null */
      logic        rsvd0;  /* Bits(31:31), Reserved */
   } f;

} fdk_regfile_xgs_athena_BAYER_WB_R_ACC_t;


/**************************************************************************
* Register name : CCM_CTRL
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic        CCM_EN;  /* Bits(0:0), null */
      logic [30:0] rsvd0;   /* Bits(31:1), Reserved */
   } f;

} fdk_regfile_xgs_athena_BAYER_CCM_CTRL_t;


/**************************************************************************
* Register name : CCM_KR1
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [11:0] Kr;     /* Bits(11:0), null */
      logic [3:0]  rsvd0;  /* Bits(15:12), Reserved */
      logic [11:0] Kg;     /* Bits(27:16), null */
      logic [3:0]  rsvd1;  /* Bits(31:28), Reserved */
   } f;

} fdk_regfile_xgs_athena_BAYER_CCM_KR1_t;


/**************************************************************************
* Register name : CCM_KR2
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [11:0] Kb;     /* Bits(11:0), null */
      logic [3:0]  rsvd0;  /* Bits(15:12), Reserved */
      logic [8:0]  KOff;   /* Bits(24:16), null */
      logic [6:0]  rsvd1;  /* Bits(31:25), Reserved */
   } f;

} fdk_regfile_xgs_athena_BAYER_CCM_KR2_t;


/**************************************************************************
* Register name : CCM_KG1
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [11:0] Kr;     /* Bits(11:0), null */
      logic [3:0]  rsvd0;  /* Bits(15:12), Reserved */
      logic [11:0] Kg;     /* Bits(27:16), null */
      logic [3:0]  rsvd1;  /* Bits(31:28), Reserved */
   } f;

} fdk_regfile_xgs_athena_BAYER_CCM_KG1_t;


/**************************************************************************
* Register name : CCM_KG2
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [11:0] Kb;     /* Bits(11:0), null */
      logic [3:0]  rsvd0;  /* Bits(15:12), Reserved */
      logic [8:0]  KOff;   /* Bits(24:16), null */
      logic [6:0]  rsvd1;  /* Bits(31:25), Reserved */
   } f;

} fdk_regfile_xgs_athena_BAYER_CCM_KG2_t;


/**************************************************************************
* Register name : CCM_KB1
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [11:0] Kr;     /* Bits(11:0), null */
      logic [3:0]  rsvd0;  /* Bits(15:12), Reserved */
      logic [11:0] Kg;     /* Bits(27:16), null */
      logic [3:0]  rsvd1;  /* Bits(31:28), Reserved */
   } f;

} fdk_regfile_xgs_athena_BAYER_CCM_KB1_t;


/**************************************************************************
* Register name : CCM_KB2
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [11:0] Kb;     /* Bits(11:0), null */
      logic [3:0]  rsvd0;  /* Bits(15:12), Reserved */
      logic [8:0]  KOff;   /* Bits(24:16), null */
      logic [6:0]  rsvd1;  /* Bits(31:25), Reserved */
   } f;

} fdk_regfile_xgs_athena_BAYER_CCM_KB2_t;


/**************************************************************************
* Register name : TEMP
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [3:0]  rsvd0;   /* Bits(3:0), Reserved */
      logic [11:0] SMTEMP;  /* Bits(15:4), System Monitor TEMPerature */
      logic [15:0] rsvd1;   /* Bits(31:16), Reserved */
   } f;

} fdk_regfile_xgs_athena_SYSMONXIL_TEMP_t;


/**************************************************************************
* Register name : VCCINT
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [3:0]  rsvd0;   /* Bits(3:0), Reserved */
      logic [11:0] SMVINT;  /* Bits(15:4), System Monitor VCCINT */
      logic [15:0] rsvd1;   /* Bits(31:16), Reserved */
   } f;

} fdk_regfile_xgs_athena_SYSMONXIL_VCCINT_t;


/**************************************************************************
* Register name : VCCAUX
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [3:0]  rsvd0;                   /* Bits(3:0), Reserved */
      logic [11:0] SMVAUX;                  /* Bits(15:4), System Monitor VCCAUX */
      logic [15:0] rsvd1;                   /* Bits(31:16), Reserved */
      logic        rsvd_register_space[3];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_athena_SYSMONXIL_VCCAUX_t;


/**************************************************************************
* Register name : VCCBRAM
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [3:0]  rsvd0;                    /* Bits(3:0), Reserved */
      logic [11:0] SMVBRAM;                  /* Bits(15:4), System Monitor VCCBRAM */
      logic [15:0] rsvd1;                    /* Bits(31:16), Reserved */
      logic        rsvd_register_space[25];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_athena_SYSMONXIL_VCCBRAM_t;


/**************************************************************************
* Register name : TEMP_MAX
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [3:0]  rsvd0;                   /* Bits(3:0), Reserved */
      logic [11:0] SMTMAX;                  /* Bits(15:4), System Monitor Temperature MAXimum */
      logic [15:0] rsvd1;                   /* Bits(31:16), Reserved */
      logic        rsvd_register_space[3];  /* Reserved space below */
   } f;

} fdk_regfile_xgs_athena_SYSMONXIL_TEMP_MAX_t;


/**************************************************************************
* Register name : TEMP_MIN
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [3:0]  rsvd0;   /* Bits(3:0), Reserved */
      logic [11:0] SMTMIN;  /* Bits(15:4), System Monitor Temperature MINimum */
      logic [15:0] rsvd1;   /* Bits(31:16), Reserved */
   } f;

} fdk_regfile_xgs_athena_SYSMONXIL_TEMP_MIN_t;


/**************************************************************************
* Section name   : SYSTEM
***************************************************************************/
typedef struct packed
{
   fdk_regfile_xgs_athena_SYSTEM_TAG_t        TAG;         /* Address offset: 0x0 */
   fdk_regfile_xgs_athena_SYSTEM_VERSION_t    VERSION;     /* Address offset: 0x4 */
   fdk_regfile_xgs_athena_SYSTEM_CAPABILITY_t CAPABILITY;  /* Address offset: 0x8 */
   fdk_regfile_xgs_athena_SYSTEM_SCRATCHPAD_t SCRATCHPAD;  /* Address offset: 0xc */
} fdk_regfile_xgs_athena_SYSTEM_t;


/**************************************************************************
* Section name   : DMA
***************************************************************************/
typedef struct packed
{
   fdk_regfile_xgs_athena_DMA_CTRL_t          CTRL;           /* Address offset: 0x0 */
   fdk_regfile_xgs_athena_DMA_FSTART_t        FSTART;         /* Address offset: 0x8 */
   fdk_regfile_xgs_athena_DMA_FSTART_HIGH_t   FSTART_HIGH;    /* Address offset: 0xc */
   fdk_regfile_xgs_athena_DMA_FSTART_G_t      FSTART_G;       /* Address offset: 0x10 */
   fdk_regfile_xgs_athena_DMA_FSTART_G_HIGH_t FSTART_G_HIGH;  /* Address offset: 0x14 */
   fdk_regfile_xgs_athena_DMA_FSTART_R_t      FSTART_R;       /* Address offset: 0x18 */
   fdk_regfile_xgs_athena_DMA_FSTART_R_HIGH_t FSTART_R_HIGH;  /* Address offset: 0x1c */
   fdk_regfile_xgs_athena_DMA_LINE_PITCH_t    LINE_PITCH;     /* Address offset: 0x20 */
   fdk_regfile_xgs_athena_DMA_LINE_SIZE_t     LINE_SIZE;      /* Address offset: 0x24 */
   fdk_regfile_xgs_athena_DMA_CSC_t           CSC;            /* Address offset: 0x28 */
   fdk_regfile_xgs_athena_DMA_OUTPUT_BUFFER_t OUTPUT_BUFFER;  /* Address offset: 0x38 */
   fdk_regfile_xgs_athena_DMA_TLP_t           TLP;            /* Address offset: 0x3c */
   fdk_regfile_xgs_athena_DMA_ROI_X_t         ROI_X;          /* Address offset: 0x40 */
   fdk_regfile_xgs_athena_DMA_ROI_Y_t         ROI_Y;          /* Address offset: 0x4c */
} fdk_regfile_xgs_athena_DMA_t;


/**************************************************************************
* Section name   : ACQ
***************************************************************************/
typedef struct packed
{
   fdk_regfile_xgs_athena_ACQ_GRAB_CTRL_t              GRAB_CTRL;               /* Address offset: 0x0 */
   fdk_regfile_xgs_athena_ACQ_GRAB_STAT_t              GRAB_STAT;               /* Address offset: 0x8 */
   fdk_regfile_xgs_athena_ACQ_READOUT_CFG1_t           READOUT_CFG1;            /* Address offset: 0x10 */
   fdk_regfile_xgs_athena_ACQ_READOUT_CFG_FRAME_LINE_t READOUT_CFG_FRAME_LINE;  /* Address offset: 0x14 */
   fdk_regfile_xgs_athena_ACQ_READOUT_CFG2_t           READOUT_CFG2;            /* Address offset: 0x18 */
   fdk_regfile_xgs_athena_ACQ_READOUT_CFG3_t           READOUT_CFG3;            /* Address offset: 0x20 */
   fdk_regfile_xgs_athena_ACQ_READOUT_CFG4_t           READOUT_CFG4;            /* Address offset: 0x24 */
   fdk_regfile_xgs_athena_ACQ_EXP_CTRL1_t              EXP_CTRL1;               /* Address offset: 0x28 */
   fdk_regfile_xgs_athena_ACQ_EXP_CTRL2_t              EXP_CTRL2;               /* Address offset: 0x30 */
   fdk_regfile_xgs_athena_ACQ_EXP_CTRL3_t              EXP_CTRL3;               /* Address offset: 0x38 */
   fdk_regfile_xgs_athena_ACQ_TRIGGER_DELAY_t          TRIGGER_DELAY;           /* Address offset: 0x40 */
   fdk_regfile_xgs_athena_ACQ_STROBE_CTRL1_t           STROBE_CTRL1;            /* Address offset: 0x48 */
   fdk_regfile_xgs_athena_ACQ_STROBE_CTRL2_t           STROBE_CTRL2;            /* Address offset: 0x50 */
   fdk_regfile_xgs_athena_ACQ_ACQ_SER_CTRL_t           ACQ_SER_CTRL;            /* Address offset: 0x58 */
   fdk_regfile_xgs_athena_ACQ_ACQ_SER_ADDATA_t         ACQ_SER_ADDATA;          /* Address offset: 0x60 */
   fdk_regfile_xgs_athena_ACQ_ACQ_SER_STAT_t           ACQ_SER_STAT;            /* Address offset: 0x68 */
   fdk_regfile_xgs_athena_ACQ_SENSOR_CTRL_t            SENSOR_CTRL;             /* Address offset: 0x90 */
   fdk_regfile_xgs_athena_ACQ_SENSOR_STAT_t            SENSOR_STAT;             /* Address offset: 0x98 */
   fdk_regfile_xgs_athena_ACQ_SENSOR_SUBSAMPLING_t     SENSOR_SUBSAMPLING;      /* Address offset: 0x9c */
   fdk_regfile_xgs_athena_ACQ_SENSOR_GAIN_ANA_t        SENSOR_GAIN_ANA;         /* Address offset: 0xa4 */
   fdk_regfile_xgs_athena_ACQ_SENSOR_ROI_Y_START_t     SENSOR_ROI_Y_START;      /* Address offset: 0xa8 */
   fdk_regfile_xgs_athena_ACQ_SENSOR_ROI_Y_SIZE_t      SENSOR_ROI_Y_SIZE;       /* Address offset: 0xac */
   fdk_regfile_xgs_athena_ACQ_SENSOR_M_LINES_t         SENSOR_M_LINES;          /* Address offset: 0xb8 */
   fdk_regfile_xgs_athena_ACQ_SENSOR_DP_GR_t           SENSOR_DP_GR;            /* Address offset: 0xbc */
   fdk_regfile_xgs_athena_ACQ_SENSOR_DP_GB_t           SENSOR_DP_GB;            /* Address offset: 0xc0 */
   fdk_regfile_xgs_athena_ACQ_SENSOR_DP_R_t            SENSOR_DP_R;             /* Address offset: 0xc4 */
   fdk_regfile_xgs_athena_ACQ_SENSOR_DP_B_t            SENSOR_DP_B;             /* Address offset: 0xc8 */
   fdk_regfile_xgs_athena_ACQ_SENSOR_GAIN_DIG_G_t      SENSOR_GAIN_DIG_G;       /* Address offset: 0xcc */
   fdk_regfile_xgs_athena_ACQ_SENSOR_GAIN_DIG_RB_t     SENSOR_GAIN_DIG_RB;      /* Address offset: 0xd0 */
   fdk_regfile_xgs_athena_ACQ_FPGA_ROI_X_START_t       FPGA_ROI_X_START;        /* Address offset: 0xd8 */
   fdk_regfile_xgs_athena_ACQ_FPGA_ROI_X_SIZE_t        FPGA_ROI_X_SIZE;         /* Address offset: 0xdc */
   fdk_regfile_xgs_athena_ACQ_DEBUG_PINS_t             DEBUG_PINS;              /* Address offset: 0xe0 */
   fdk_regfile_xgs_athena_ACQ_TRIGGER_MISSED_t         TRIGGER_MISSED;          /* Address offset: 0xe8 */
   fdk_regfile_xgs_athena_ACQ_SENSOR_FPS_t             SENSOR_FPS;              /* Address offset: 0xf0 */
   fdk_regfile_xgs_athena_ACQ_SENSOR_FPS2_t            SENSOR_FPS2;             /* Address offset: 0xf4 */
   fdk_regfile_xgs_athena_ACQ_DEBUG_t                  DEBUG;                   /* Address offset: 0x1a0 */
   fdk_regfile_xgs_athena_ACQ_DEBUG_CNTR1_t            DEBUG_CNTR1;             /* Address offset: 0x1a8 */
   fdk_regfile_xgs_athena_ACQ_EXP_FOT_t                EXP_FOT;                 /* Address offset: 0x1b8 */
   fdk_regfile_xgs_athena_ACQ_ACQ_SFNC_t               ACQ_SFNC;                /* Address offset: 0x1c0 */
   fdk_regfile_xgs_athena_ACQ_TIMER_CTRL_t             TIMER_CTRL;              /* Address offset: 0x1d0 */
   fdk_regfile_xgs_athena_ACQ_TIMER_DELAY_t            TIMER_DELAY;             /* Address offset: 0x1d4 */
   fdk_regfile_xgs_athena_ACQ_TIMER_DURATION_t         TIMER_DURATION;          /* Address offset: 0x1d8 */
} fdk_regfile_xgs_athena_ACQ_t;


/**************************************************************************
* Section name   : HISPI
***************************************************************************/
typedef struct packed
{
   fdk_regfile_xgs_athena_HISPI_CTRL_t                CTRL;                    /* Address offset: 0x0 */
   fdk_regfile_xgs_athena_HISPI_STATUS_t              STATUS;                  /* Address offset: 0x4 */
   fdk_regfile_xgs_athena_HISPI_IDELAYCTRL_STATUS_t   IDELAYCTRL_STATUS;       /* Address offset: 0x8 */
   fdk_regfile_xgs_athena_HISPI_IDLE_CHARACTER_t      IDLE_CHARACTER;          /* Address offset: 0xc */
   fdk_regfile_xgs_athena_HISPI_PHY_t                 PHY;                     /* Address offset: 0x10 */
   fdk_regfile_xgs_athena_HISPI_FRAME_CFG_t           FRAME_CFG;               /* Address offset: 0x14 */
   fdk_regfile_xgs_athena_HISPI_FRAME_CFG_X_VALID_t   FRAME_CFG_X_VALID;       /* Address offset: 0x18 */
   fdk_regfile_xgs_athena_HISPI_LANE_DECODER_STATUS_t LANE_DECODER_STATUS[6];  /* Address offset: 0x24 */
   fdk_regfile_xgs_athena_HISPI_TAP_HISTOGRAM_t       TAP_HISTOGRAM[6];        /* Address offset: 0x3c */
   fdk_regfile_xgs_athena_HISPI_DEBUG_t               DEBUG;                   /* Address offset: 0x54 */
} fdk_regfile_xgs_athena_HISPI_t;


/**************************************************************************
* Section name   : DPC
***************************************************************************/
typedef struct packed
{
   fdk_regfile_xgs_athena_DPC_DPC_CAPABILITIES_t  DPC_CAPABILITIES;   /* Address offset: 0x0 */
   fdk_regfile_xgs_athena_DPC_DPC_LIST_CTRL_t     DPC_LIST_CTRL;      /* Address offset: 0x4 */
   fdk_regfile_xgs_athena_DPC_DPC_LIST_STAT_t     DPC_LIST_STAT;      /* Address offset: 0x8 */
   fdk_regfile_xgs_athena_DPC_DPC_LIST_DATA1_t    DPC_LIST_DATA1;     /* Address offset: 0xc */
   fdk_regfile_xgs_athena_DPC_DPC_LIST_DATA2_t    DPC_LIST_DATA2;     /* Address offset: 0x10 */
   fdk_regfile_xgs_athena_DPC_DPC_LIST_DATA1_RD_t DPC_LIST_DATA1_RD;  /* Address offset: 0x14 */
   fdk_regfile_xgs_athena_DPC_DPC_LIST_DATA2_RD_t DPC_LIST_DATA2_RD;  /* Address offset: 0x18 */
} fdk_regfile_xgs_athena_DPC_t;


/**************************************************************************
* Section name   : LUT
***************************************************************************/
typedef struct packed
{
   fdk_regfile_xgs_athena_LUT_LUT_CAPABILITIES_t LUT_CAPABILITIES;  /* Address offset: 0x0 */
   fdk_regfile_xgs_athena_LUT_LUT_CTRL_t         LUT_CTRL;          /* Address offset: 0x4 */
   fdk_regfile_xgs_athena_LUT_LUT_RB_t           LUT_RB;            /* Address offset: 0x8 */
} fdk_regfile_xgs_athena_LUT_t;


/**************************************************************************
* Section name   : BAYER
***************************************************************************/
typedef struct packed
{
   fdk_regfile_xgs_athena_BAYER_BAYER_CAPABILITIES_t BAYER_CAPABILITIES;  /* Address offset: 0x0 */
   fdk_regfile_xgs_athena_BAYER_WB_MUL1_t            WB_MUL1;             /* Address offset: 0x4 */
   fdk_regfile_xgs_athena_BAYER_WB_MUL2_t            WB_MUL2;             /* Address offset: 0x8 */
   fdk_regfile_xgs_athena_BAYER_WB_B_ACC_t           WB_B_ACC;            /* Address offset: 0xc */
   fdk_regfile_xgs_athena_BAYER_WB_G_ACC_t           WB_G_ACC;            /* Address offset: 0x10 */
   fdk_regfile_xgs_athena_BAYER_WB_R_ACC_t           WB_R_ACC;            /* Address offset: 0x14 */
   fdk_regfile_xgs_athena_BAYER_CCM_CTRL_t           CCM_CTRL;            /* Address offset: 0x18 */
   fdk_regfile_xgs_athena_BAYER_CCM_KR1_t            CCM_KR1;             /* Address offset: 0x1c */
   fdk_regfile_xgs_athena_BAYER_CCM_KR2_t            CCM_KR2;             /* Address offset: 0x20 */
   fdk_regfile_xgs_athena_BAYER_CCM_KG1_t            CCM_KG1;             /* Address offset: 0x24 */
   fdk_regfile_xgs_athena_BAYER_CCM_KG2_t            CCM_KG2;             /* Address offset: 0x28 */
   fdk_regfile_xgs_athena_BAYER_CCM_KB1_t            CCM_KB1;             /* Address offset: 0x2c */
   fdk_regfile_xgs_athena_BAYER_CCM_KB2_t            CCM_KB2;             /* Address offset: 0x30 */
} fdk_regfile_xgs_athena_BAYER_t;


/**************************************************************************
* External section name   : SYSMONXIL
***************************************************************************/
typedef struct packed
{
   fdk_regfile_xgs_athena_SYSMONXIL_TEMP_t     TEMP;        /* Address offset: 0x0 */
   fdk_regfile_xgs_athena_SYSMONXIL_VCCINT_t   VCCINT;      /* Address offset: 0x4 */
   fdk_regfile_xgs_athena_SYSMONXIL_VCCAUX_t   VCCAUX;      /* Address offset: 0x8 */
   fdk_regfile_xgs_athena_SYSMONXIL_VCCBRAM_t  VCCBRAM;     /* Address offset: 0x18 */
   fdk_regfile_xgs_athena_SYSMONXIL_TEMP_MAX_t TEMP_MAX;    /* Address offset: 0x80 */
   fdk_regfile_xgs_athena_SYSMONXIL_TEMP_MIN_t TEMP_MIN;    /* Address offset: 0x90 */
   uint32_t                                    [26:0]rsvd;  /* Reserved space (27 x uint32_t) */
} fdk_regfile_xgs_athena_SYSMONXIL_t;


/**************************************************************************
* Register file name : regfile_xgs_athena
***************************************************************************/
typedef struct packed
{
   fdk_regfile_xgs_athena_SYSTEM_t    SYSTEM;        /* Section; Base address offset: 0x0 */
   uint32_t                           [23:0]rsvd0;   /* Padding; Size (96 Bytes) */
   fdk_regfile_xgs_athena_DMA_t       DMA;           /* Section; Base address offset: 0x70 */
   uint32_t                           [13:0]rsvd1;   /* Padding; Size (56 Bytes) */
   fdk_regfile_xgs_athena_ACQ_t       ACQ;           /* Section; Base address offset: 0x100 */
   uint32_t                           [72:0]rsvd2;   /* Padding; Size (292 Bytes) */
   fdk_regfile_xgs_athena_HISPI_t     HISPI;         /* Section; Base address offset: 0x400 */
   uint32_t                           [9:0]rsvd3;    /* Padding; Size (40 Bytes) */
   fdk_regfile_xgs_athena_DPC_t       DPC;           /* Section; Base address offset: 0x480 */
   uint32_t                           [4:0]rsvd4;    /* Padding; Size (20 Bytes) */
   fdk_regfile_xgs_athena_LUT_t       LUT;           /* Section; Base address offset: 0x4b0 */
   uint32_t                           rsvd5;         /* Padding; Size (4 Bytes) */
   fdk_regfile_xgs_athena_BAYER_t     BAYER;         /* Section; Base address offset: 0x4c0 */
   uint32_t                           [130:0]rsvd6;  /* Padding; Size (524 Bytes) */
   fdk_regfile_xgs_athena_SYSMONXIL_t SYSMONXIL;     /* External section; Base address offset: 0x700 */
} fdk_regfile_xgs_athena_t;

