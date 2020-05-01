/**************************************************************************
*
* File name    :  regfile_xgs_athena.h
* Created by   : imaval
*
* Content      :  This file contains the register structures for the
*                 fpga regfile_xgs_athena processing unit.
*
* Hardware native endianness: little endian
*
* FDK IDE Version     : 4.7.0_beta4
* Build ID            : I20191220-1537
* Register file CRC32 : 0x99823D16
*
* COPYRIGHT (c) 2020 Matrox Electronic Systems Ltd.
* All Rights Reserved
*
***************************************************************************/
#ifndef __FPGA_REGFILE_XGS_ATHENA_H__
#define __FPGA_REGFILE_XGS_ATHENA_H__

#include "mbasictypes.h"





/**************************************************************************
* Register address defines
***************************************************************************/
#define FPGA_REGFILE_XGS_ATHENA_SYSTEM_TAG_ADDRESS                     0x000
#define FPGA_REGFILE_XGS_ATHENA_SYSTEM_VERSION_ADDRESS                 0x004
#define FPGA_REGFILE_XGS_ATHENA_SYSTEM_CAPABILITY_ADDRESS              0x008
#define FPGA_REGFILE_XGS_ATHENA_SYSTEM_SCRATCHPAD_ADDRESS              0x00C
#define FPGA_REGFILE_XGS_ATHENA_DMA_CTRL_ADDRESS                       0x070
#define FPGA_REGFILE_XGS_ATHENA_DMA_FSTART_ADDRESS                     0x078
#define FPGA_REGFILE_XGS_ATHENA_DMA_FSTART_HIGH_ADDRESS                0x07C
#define FPGA_REGFILE_XGS_ATHENA_DMA_FSTART_G_ADDRESS                   0x080
#define FPGA_REGFILE_XGS_ATHENA_DMA_FSTART_G_HIGH_ADDRESS              0x084
#define FPGA_REGFILE_XGS_ATHENA_DMA_FSTART_R_ADDRESS                   0x088
#define FPGA_REGFILE_XGS_ATHENA_DMA_FSTART_R_HIGH_ADDRESS              0x08C
#define FPGA_REGFILE_XGS_ATHENA_DMA_LINE_PITCH_ADDRESS                 0x090
#define FPGA_REGFILE_XGS_ATHENA_DMA_LINE_SIZE_ADDRESS                  0x094
#define FPGA_REGFILE_XGS_ATHENA_DMA_CSC_ADDRESS                        0x098
#define FPGA_REGFILE_XGS_ATHENA_ACQ_GRAB_CTRL_ADDRESS                  0x100
#define FPGA_REGFILE_XGS_ATHENA_ACQ_GRAB_STAT_ADDRESS                  0x108
#define FPGA_REGFILE_XGS_ATHENA_ACQ_READOUT_CFG1_ADDRESS               0x110
#define FPGA_REGFILE_XGS_ATHENA_ACQ_READOUT_CFG_FRAME_LINE_ADDRESS     0x114
#define FPGA_REGFILE_XGS_ATHENA_ACQ_READOUT_CFG2_ADDRESS               0x118
#define FPGA_REGFILE_XGS_ATHENA_ACQ_READOUT_CFG3_ADDRESS               0x120
#define FPGA_REGFILE_XGS_ATHENA_ACQ_READOUT_CFG4_ADDRESS               0x124
#define FPGA_REGFILE_XGS_ATHENA_ACQ_EXP_CTRL1_ADDRESS                  0x128
#define FPGA_REGFILE_XGS_ATHENA_ACQ_EXP_CTRL2_ADDRESS                  0x130
#define FPGA_REGFILE_XGS_ATHENA_ACQ_EXP_CTRL3_ADDRESS                  0x138
#define FPGA_REGFILE_XGS_ATHENA_ACQ_TRIGGER_DELAY_ADDRESS              0x140
#define FPGA_REGFILE_XGS_ATHENA_ACQ_STROBE_CTRL1_ADDRESS               0x148
#define FPGA_REGFILE_XGS_ATHENA_ACQ_STROBE_CTRL2_ADDRESS               0x150
#define FPGA_REGFILE_XGS_ATHENA_ACQ_ACQ_SER_CTRL_ADDRESS               0x158
#define FPGA_REGFILE_XGS_ATHENA_ACQ_ACQ_SER_ADDATA_ADDRESS             0x160
#define FPGA_REGFILE_XGS_ATHENA_ACQ_ACQ_SER_STAT_ADDRESS               0x168
#define FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_CTRL_ADDRESS                0x190
#define FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_STAT_ADDRESS                0x198
#define FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_SUBSAMPLING_ADDRESS         0x19C
#define FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_GAIN_ANA_ADDRESS            0x1A4
#define FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_ROI_Y_START_ADDRESS         0x1A8
#define FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_ROI_Y_SIZE_ADDRESS          0x1AC
#define FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_ROI2_Y_START_ADDRESS        0x1B0
#define FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_ROI2_Y_SIZE_ADDRESS         0x1B4
#define FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_M_LINES_ADDRESS             0x1B8
#define FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_DP_GR_ADDRESS               0x1BC
#define FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_DP_GB_ADDRESS               0x1C0
#define FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_DP_R_ADDRESS                0x1C4
#define FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_DP_B_ADDRESS                0x1C8
#define FPGA_REGFILE_XGS_ATHENA_ACQ_DEBUG_PINS_ADDRESS                 0x1E0
#define FPGA_REGFILE_XGS_ATHENA_ACQ_TRIGGER_MISSED_ADDRESS             0x1E8
#define FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_FPS_ADDRESS                 0x1F0
#define FPGA_REGFILE_XGS_ATHENA_ACQ_DEBUG_ADDRESS                      0x2A0
#define FPGA_REGFILE_XGS_ATHENA_ACQ_DEBUG_CNTR1_ADDRESS                0x2A8
#define FPGA_REGFILE_XGS_ATHENA_ACQ_EXP_FOT_ADDRESS                    0x2B8
#define FPGA_REGFILE_XGS_ATHENA_ACQ_ACQ_SFNC_ADDRESS                   0x2C0
#define FPGA_REGFILE_XGS_ATHENA_DATA_LUT_CTRL_ADDRESS                  0x300
#define FPGA_REGFILE_XGS_ATHENA_DATA_LUT_RB_ADDRESS                    0x308
#define FPGA_REGFILE_XGS_ATHENA_DATA_WB_MULT1_ADDRESS                  0x310
#define FPGA_REGFILE_XGS_ATHENA_DATA_WB_MULT2_ADDRESS                  0x318
#define FPGA_REGFILE_XGS_ATHENA_DATA_WB_B_ACC_ADDRESS                  0x320
#define FPGA_REGFILE_XGS_ATHENA_DATA_WB_G_ACC_ADDRESS                  0x328
#define FPGA_REGFILE_XGS_ATHENA_DATA_WB_R_ACC_ADDRESS                  0x330
#define FPGA_REGFILE_XGS_ATHENA_DATA_FPN_ADD_ADDRESS                   0x338
#define FPGA_REGFILE_XGS_ATHENA_DATA_FPN_READ_REG_ADDRESS              0x33C
#define FPGA_REGFILE_XGS_ATHENA_DATA_FPN_DATA_ADDRESS                  0x340
#define FPGA_REGFILE_XGS_ATHENA_DATA_FPN_CONTRAST_ADDRESS              0x360
#define FPGA_REGFILE_XGS_ATHENA_DATA_FPN_ACC_ADD_ADDRESS               0x368
#define FPGA_REGFILE_XGS_ATHENA_DATA_FPN_ACC_DATA_ADDRESS              0x370
#define FPGA_REGFILE_XGS_ATHENA_DATA_DPC_LIST_CTRL_ADDRESS             0x380
#define FPGA_REGFILE_XGS_ATHENA_DATA_DPC_LIST_DATA_ADDRESS             0x384
#define FPGA_REGFILE_XGS_ATHENA_DATA_DPC_LIST_DATA_RD_ADDRESS          0x388
#define FPGA_REGFILE_XGS_ATHENA_HISPI_CTRL_ADDRESS                     0x400
#define FPGA_REGFILE_XGS_ATHENA_HISPI_IDELAYCTRL_STATUS_ADDRESS        0x404
#define FPGA_REGFILE_XGS_ATHENA_HISPI_LANE_DECODER_STATUS_ADDRESS      0x408
#define FPGA_REGFILE_XGS_ATHENA_HISPI_LANE_PACKER_STATUS_ADDRESS       0x420

/**************************************************************************
* Register name : TAG
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 VALUE : 24;  /* Bits(23:0), Tag identifier */
      M_UINT32 RSVD0 : 8;   /* Bits(31:24), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_SYSTEM_TAG_TYPE;


/**************************************************************************
* Register name : VERSION
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 HW    : 8;  /* Bits(7:0), null */
      M_UINT32 MINOR : 8;  /* Bits(15:8), null */
      M_UINT32 MAJOR : 8;  /* Bits(23:16), null */
      M_UINT32 RSVD0 : 8;  /* Bits(31:24), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_SYSTEM_VERSION_TYPE;


/**************************************************************************
* Register name : CAPABILITY
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 VALUE : 8;   /* Bits(7:0), null */
      M_UINT32 RSVD0 : 24;  /* Bits(31:8), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_SYSTEM_CAPABILITY_TYPE;


/**************************************************************************
* Register name : SCRATCHPAD
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 VALUE : 32;  /* Bits(31:0), null */
   } f;

} FPGA_REGFILE_XGS_ATHENA_SYSTEM_SCRATCHPAD_TYPE;


/**************************************************************************
* Register name : CTRL
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 GRAB_QUEUE_EN          : 1;   /* Bits(0:0), */
      M_UINT32 RSVD0                  : 31;  /* Bits(31:1), Reserved */
      M_UINT32 RSVD_REGISTER_SPACE[1] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DMA_CTRL_TYPE;


/**************************************************************************
* Register name : FSTART
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 VALUE : 32;  /* Bits(31:0), INitial GRAb ADDRess Register */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DMA_FSTART_TYPE;


/**************************************************************************
* Register name : FSTART_HIGH
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 VALUE : 32;  /* Bits(31:0), INitial GRAb ADDRess Register High */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DMA_FSTART_HIGH_TYPE;


/**************************************************************************
* Register name : FSTART_G
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 VALUE : 32;  /* Bits(31:0), GRAb ADDRess Register */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DMA_FSTART_G_TYPE;


/**************************************************************************
* Register name : FSTART_G_HIGH
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 VALUE : 32;  /* Bits(31:0), GRAb ADDRess Register High */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DMA_FSTART_G_HIGH_TYPE;


/**************************************************************************
* Register name : FSTART_R
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 VALUE : 32;  /* Bits(31:0), GRAb ADDRess Register */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DMA_FSTART_R_TYPE;


/**************************************************************************
* Register name : FSTART_R_HIGH
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 VALUE : 32;  /* Bits(31:0), GRAb ADDRess Register High */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DMA_FSTART_R_HIGH_TYPE;


/**************************************************************************
* Register name : LINE_PITCH
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 VALUE : 16;  /* Bits(15:0), Grab LinePitch */
      M_UINT32 RSVD0 : 16;  /* Bits(31:16), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DMA_LINE_PITCH_TYPE;


/**************************************************************************
* Register name : LINE_SIZE
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 VALUE : 14;  /* Bits(13:0), Host Line size */
      M_UINT32 RSVD0 : 18;  /* Bits(31:14), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DMA_LINE_SIZE_TYPE;


/**************************************************************************
* Register name : CSC
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 RSVD0                  : 8;   /* Bits(7:0), Reserved */
      M_UINT32 REVERSE_X              : 1;   /* Bits(8:8), null */
      M_UINT32 REVERSE_Y              : 1;   /* Bits(9:9), REVERSE Y */
      M_UINT32 RSVD1                  : 13;  /* Bits(22:10), Reserved */
      M_UINT32 DUP_LAST_LINE          : 1;   /* Bits(23:23), null */
      M_UINT32 COLOR_SPACE            : 3;   /* Bits(26:24), null */
      M_UINT32 RSVD2                  : 5;   /* Bits(31:27), Reserved */
      M_UINT32 RSVD_REGISTER_SPACE[3] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DMA_CSC_TYPE;


/**************************************************************************
* Register name : GRAB_CTRL
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 GRAB_CMD               : 1;   /* Bits(0:0), GRAB CoMmanD */
      M_UINT32 BUFFER_ID              : 1;   /* Bits(1:1), null */
      M_UINT32 RSVD0                  : 2;   /* Bits(3:2), Reserved */
      M_UINT32 GRAB_SS                : 1;   /* Bits(4:4), GRAB Software Snapshot */
      M_UINT32 RSVD1                  : 3;   /* Bits(7:5), Reserved */
      M_UINT32 TRIGGER_SRC            : 3;   /* Bits(10:8), TRIGGER SouRCe */
      M_UINT32 RSVD2                  : 1;   /* Bits(11:11), Reserved */
      M_UINT32 TRIGGER_ACT            : 3;   /* Bits(14:12), TRIGGER ACTivation */
      M_UINT32 TRIGGER_OVERLAP        : 1;   /* Bits(15:15), null */
      M_UINT32 TRIGGER_OVERLAP_BUFFN  : 1;   /* Bits(16:16), null */
      M_UINT32 RSVD3                  : 11;  /* Bits(27:17), Reserved */
      M_UINT32 ABORT_GRAB             : 1;   /* Bits(28:28), ABORT GRAB */
      M_UINT32 GRAB_ROI2_EN           : 1;   /* Bits(29:29), null */
      M_UINT32 RSVD4                  : 1;   /* Bits(30:30), Reserved */
      M_UINT32 RESET_GRAB             : 1;   /* Bits(31:31), null */
      M_UINT32 RSVD_REGISTER_SPACE[1] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_GRAB_CTRL_TYPE;


/**************************************************************************
* Register name : GRAB_STAT
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 GRAB_IDLE              : 1;  /* Bits(0:0), null */
      M_UINT32 GRAB_ACTIVE            : 1;  /* Bits(1:1), null */
      M_UINT32 GRAB_PENDING           : 1;  /* Bits(2:2), null */
      M_UINT32 RSVD0                  : 1;  /* Bits(3:3), Reserved */
      M_UINT32 GRAB_EXPOSURE          : 1;  /* Bits(4:4), null */
      M_UINT32 GRAB_READOUT           : 1;  /* Bits(5:5), null */
      M_UINT32 GRAB_FOT               : 1;  /* Bits(6:6), GRAB Field Overhead Time */
      M_UINT32 RSVD1                  : 1;  /* Bits(7:7), Reserved */
      M_UINT32 GRAB_MNGR_STAT         : 4;  /* Bits(11:8), null */
      M_UINT32 TIMER_MNGR_STAT        : 3;  /* Bits(14:12), null */
      M_UINT32 RSVD2                  : 1;  /* Bits(15:15), Reserved */
      M_UINT32 TRIG_MNGR_STAT         : 4;  /* Bits(19:16), null */
      M_UINT32 ABORT_MNGR_STAT        : 3;  /* Bits(22:20), null */
      M_UINT32 RSVD3                  : 1;  /* Bits(23:23), Reserved */
      M_UINT32 TRIGGER_RDY            : 1;  /* Bits(24:24), null */
      M_UINT32 RSVD4                  : 3;  /* Bits(27:25), Reserved */
      M_UINT32 ABORT_DONE             : 1;  /* Bits(28:28), ABORT is DONE */
      M_UINT32 ABORT_DELAI            : 1;  /* Bits(29:29), null */
      M_UINT32 ABORT_PET              : 1;  /* Bits(30:30), ABORT during PET */
      M_UINT32 GRAB_CMD_DONE          : 1;  /* Bits(31:31), GRAB CoMmanD DONE */
      M_UINT32 RSVD_REGISTER_SPACE[1] ;     /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_GRAB_STAT_TYPE;


/**************************************************************************
* Register name : READOUT_CFG1
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 FOT_LENGTH      : 16;  /* Bits(15:0), Frame Overhead Time LENGTH */
      M_UINT32 EO_FOT_SEL      : 1;   /* Bits(16:16), null */
      M_UINT32 RSVD0           : 7;   /* Bits(23:17), Reserved */
      M_UINT32 FOT_LENGTH_LINE : 5;   /* Bits(28:24), Frame Overhead Time LENGTH LINE */
      M_UINT32 RSVD1           : 3;   /* Bits(31:29), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_READOUT_CFG1_TYPE;


/**************************************************************************
* Register name : READOUT_CFG_FRAME_LINE
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 CURR_FRAME_LINES : 13;  /* Bits(12:0), null */
      M_UINT32 RSVD0            : 3;   /* Bits(15:13), Reserved */
      M_UINT32 DUMMY_LINES      : 8;   /* Bits(23:16), null */
      M_UINT32 RSVD1            : 8;   /* Bits(31:24), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_READOUT_CFG_FRAME_LINE_TYPE;


/**************************************************************************
* Register name : READOUT_CFG2
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 READOUT_LENGTH         : 29;  /* Bits(28:0), null */
      M_UINT32 RSVD0                  : 3;   /* Bits(31:29), Reserved */
      M_UINT32 RSVD_REGISTER_SPACE[1] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_READOUT_CFG2_TYPE;


/**************************************************************************
* Register name : READOUT_CFG3
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 LINE_TIME         : 16;  /* Bits(15:0), LINE TIME */
      M_UINT32 KEEP_OUT_TRIG_ENA : 1;   /* Bits(16:16), null */
      M_UINT32 RSVD0             : 15;  /* Bits(31:17), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_READOUT_CFG3_TYPE;


/**************************************************************************
* Register name : READOUT_CFG4
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 KEEP_OUT_TRIG_START : 16;  /* Bits(15:0), null */
      M_UINT32 KEEP_OUT_TRIG_END   : 16;  /* Bits(31:16), null */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_READOUT_CFG4_TYPE;


/**************************************************************************
* Register name : EXP_CTRL1
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 EXPOSURE_SS            : 28;  /* Bits(27:0), EXPOSURE Single Slope */
      M_UINT32 EXPOSURE_LEV_MODE      : 1;   /* Bits(28:28), EXPOSURE LEVel MODE */
      M_UINT32 RSVD0                  : 3;   /* Bits(31:29), Reserved */
      M_UINT32 RSVD_REGISTER_SPACE[1] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_EXP_CTRL1_TYPE;


/**************************************************************************
* Register name : EXP_CTRL2
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 EXPOSURE_DS            : 28;  /* Bits(27:0), EXPOSURE Dual */
      M_UINT32 RSVD0                  : 4;   /* Bits(31:28), Reserved */
      M_UINT32 RSVD_REGISTER_SPACE[1] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_EXP_CTRL2_TYPE;


/**************************************************************************
* Register name : EXP_CTRL3
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 EXPOSURE_TS            : 28;  /* Bits(27:0), EXPOSURE Tripple */
      M_UINT32 RSVD0                  : 4;   /* Bits(31:28), Reserved */
      M_UINT32 RSVD_REGISTER_SPACE[1] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_EXP_CTRL3_TYPE;


/**************************************************************************
* Register name : TRIGGER_DELAY
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 TRIGGER_DELAY          : 28;  /* Bits(27:0), TRIGGER DELAY */
      M_UINT32 RSVD0                  : 4;   /* Bits(31:28), Reserved */
      M_UINT32 RSVD_REGISTER_SPACE[1] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_TRIGGER_DELAY_TYPE;


/**************************************************************************
* Register name : STROBE_CTRL1
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 STROBE_START           : 28;  /* Bits(27:0), STROBE START */
      M_UINT32 STROBE_POL             : 1;   /* Bits(28:28), STROBE POLarity */
      M_UINT32 RSVD0                  : 2;   /* Bits(30:29), Reserved */
      M_UINT32 STROBE_E               : 1;   /* Bits(31:31), STROBE Enable */
      M_UINT32 RSVD_REGISTER_SPACE[1] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_STROBE_CTRL1_TYPE;


/**************************************************************************
* Register name : STROBE_CTRL2
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 STROBE_END             : 28;  /* Bits(27:0), STROBE END */
      M_UINT32 STROBE_A_EN            : 1;   /* Bits(28:28), STROBE phase A ENable */
      M_UINT32 STROBE_B_EN            : 1;   /* Bits(29:29), STROBE phase B ENable */
      M_UINT32 RSVD0                  : 1;   /* Bits(30:30), Reserved */
      M_UINT32 STROBE_MODE            : 1;   /* Bits(31:31), STROBE MODE */
      M_UINT32 RSVD_REGISTER_SPACE[1] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_STROBE_CTRL2_TYPE;


/**************************************************************************
* Register name : ACQ_SER_CTRL
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 SER_WF_SS              : 1;   /* Bits(0:0), SERial Write Fifo SnapShot */
      M_UINT32 RSVD0                  : 3;   /* Bits(3:1), Reserved */
      M_UINT32 SER_RF_SS              : 1;   /* Bits(4:4), SERial Read Fifo SnapShot */
      M_UINT32 RSVD1                  : 3;   /* Bits(7:5), Reserved */
      M_UINT32 SER_CMD                : 2;   /* Bits(9:8), SERial CoMmand */
      M_UINT32 RSVD2                  : 6;   /* Bits(15:10), Reserved */
      M_UINT32 SER_RWN                : 1;   /* Bits(16:16), SERial Read/Writen */
      M_UINT32 RSVD3                  : 15;  /* Bits(31:17), Reserved */
      M_UINT32 RSVD_REGISTER_SPACE[1] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_ACQ_SER_CTRL_TYPE;


/**************************************************************************
* Register name : ACQ_SER_ADDATA
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 SER_ADD                : 15;  /* Bits(14:0), SERial interface ADDress */
      M_UINT32 RSVD0                  : 1;   /* Bits(15:15), Reserved */
      M_UINT32 SER_DAT                : 16;  /* Bits(31:16), SERial interface DATa */
      M_UINT32 RSVD_REGISTER_SPACE[1] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_ACQ_SER_ADDATA_TYPE;


/**************************************************************************
* Register name : ACQ_SER_STAT
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 SER_DAT_R              : 16;  /* Bits(15:0), SERial interface DATa Read */
      M_UINT32 SER_BUSY               : 1;   /* Bits(16:16), SERial BUSY */
      M_UINT32 RSVD0                  : 7;   /* Bits(23:17), Reserved */
      M_UINT32 SER_FIFO_EMPTY         : 1;   /* Bits(24:24), SERial FIFO EMPTY */
      M_UINT32 RSVD1                  : 7;   /* Bits(31:25), Reserved */
      M_UINT32 RSVD_REGISTER_SPACE[9] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_ACQ_SER_STAT_TYPE;


/**************************************************************************
* Register name : SENSOR_CTRL
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 SENSOR_POWERUP         : 1;  /* Bits(0:0), null */
      M_UINT32 SENSOR_RESETN          : 1;  /* Bits(1:1), SENSOR RESET Not */
      M_UINT32 RSVD0                  : 2;  /* Bits(3:2), Reserved */
      M_UINT32 SENSOR_REG_UPTATE      : 1;  /* Bits(4:4), SENSOR REGister UPDATE */
      M_UINT32 RSVD1                  : 3;  /* Bits(7:5), Reserved */
      M_UINT32 SENSOR_COLOR           : 1;  /* Bits(8:8), SENSOR COLOR */
      M_UINT32 RSVD2                  : 7;  /* Bits(15:9), Reserved */
      M_UINT32 SENSOR_POWERDOWN       : 1;  /* Bits(16:16), null */
      M_UINT32 RSVD3                  : 7;  /* Bits(23:17), Reserved */
      M_UINT32 SENSOR_REFRESH_TEMP    : 1;  /* Bits(24:24), SENSOR REFRESH TEMPerature */
      M_UINT32 RSVD4                  : 7;  /* Bits(31:25), Reserved */
      M_UINT32 RSVD_REGISTER_SPACE[1] ;     /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_CTRL_TYPE;


/**************************************************************************
* Register name : SENSOR_STAT
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 SENSOR_POWERUP_DONE : 1;  /* Bits(0:0), null */
      M_UINT32 SENSOR_POWERUP_STAT : 1;  /* Bits(1:1), null */
      M_UINT32 RSVD0               : 6;  /* Bits(7:2), Reserved */
      M_UINT32 SENSOR_VCC_PG       : 1;  /* Bits(8:8), SENSOR supply VCC  Power Good */
      M_UINT32 RSVD1               : 3;  /* Bits(11:9), Reserved */
      M_UINT32 SENSOR_OSC_EN       : 1;  /* Bits(12:12), SENSOR OSCILLATOR ENable */
      M_UINT32 SENSOR_RESETN       : 1;  /* Bits(13:13), SENSOR RESET N */
      M_UINT32 RSVD2               : 2;  /* Bits(15:14), Reserved */
      M_UINT32 SENSOR_POWERDOWN    : 1;  /* Bits(16:16), null */
      M_UINT32 RSVD3               : 6;  /* Bits(22:17), Reserved */
      M_UINT32 SENSOR_TEMP_VALID   : 1;  /* Bits(23:23), SENSOR TEMPerature VALID */
      M_UINT32 SENSOR_TEMP         : 8;  /* Bits(31:24), null */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_STAT_TYPE;


/**************************************************************************
* Register name : SENSOR_SUBSAMPLING
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 SUBSAMPLING_X          : 1;   /* Bits(0:0), */
      M_UINT32 M_SUBSAMPLING_Y        : 1;   /* Bits(1:1), */
      M_UINT32 RESERVED0              : 1;   /* Bits(2:2), */
      M_UINT32 ACTIVE_SUBSAMPLING_Y   : 1;   /* Bits(3:3), null */
      M_UINT32 RESERVED1              : 12;  /* Bits(15:4), null */
      M_UINT32 RSVD0                  : 16;  /* Bits(31:16), Reserved */
      M_UINT32 RSVD_REGISTER_SPACE[1] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_SUBSAMPLING_TYPE;


/**************************************************************************
* Register name : SENSOR_GAIN_ANA
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 RESERVED0   : 8;   /* Bits(7:0), null */
      M_UINT32 ANALOG_GAIN : 3;   /* Bits(10:8), */
      M_UINT32 RESERVED1   : 5;   /* Bits(15:11), null */
      M_UINT32 RSVD0       : 16;  /* Bits(31:16), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_GAIN_ANA_TYPE;


/**************************************************************************
* Register name : SENSOR_ROI_Y_START
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 Y_START  : 10;  /* Bits(9:0), Y START */
      M_UINT32 RESERVED : 6;   /* Bits(15:10), null */
      M_UINT32 RSVD0    : 16;  /* Bits(31:16), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_ROI_Y_START_TYPE;


/**************************************************************************
* Register name : SENSOR_ROI_Y_SIZE
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 Y_SIZE   : 10;  /* Bits(9:0), Y SIZE */
      M_UINT32 RESERVED : 6;   /* Bits(15:10), null */
      M_UINT32 RSVD0    : 16;  /* Bits(31:16), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_ROI_Y_SIZE_TYPE;


/**************************************************************************
* Register name : SENSOR_ROI2_Y_START
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 Y_START  : 10;  /* Bits(9:0), Y START */
      M_UINT32 RESERVED : 6;   /* Bits(15:10), null */
      M_UINT32 RSVD0    : 16;  /* Bits(31:16), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_ROI2_Y_START_TYPE;


/**************************************************************************
* Register name : SENSOR_ROI2_Y_SIZE
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 Y_SIZE   : 10;  /* Bits(9:0), Y SIZE */
      M_UINT32 RESERVED : 6;   /* Bits(15:10), null */
      M_UINT32 RSVD0    : 16;  /* Bits(31:16), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_ROI2_Y_SIZE_TYPE;


/**************************************************************************
* Register name : SENSOR_M_LINES
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 M_LINES_SENSOR : 10;  /* Bits(9:0), null */
      M_UINT32 M_SUPPRESSED   : 5;   /* Bits(14:10), null */
      M_UINT32 RSVD0          : 17;  /* Bits(31:15), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_M_LINES_TYPE;


/**************************************************************************
* Register name : SENSOR_DP_GR
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 DP_OFFSET_GR : 12;  /* Bits(11:0), null */
      M_UINT32 RESERVED     : 4;   /* Bits(15:12), null */
      M_UINT32 RSVD0        : 16;  /* Bits(31:16), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_DP_GR_TYPE;


/**************************************************************************
* Register name : SENSOR_DP_GB
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 DP_OFFSET_GB : 12;  /* Bits(11:0), null */
      M_UINT32 RESERVED     : 4;   /* Bits(15:12), null */
      M_UINT32 RSVD0        : 16;  /* Bits(31:16), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_DP_GB_TYPE;


/**************************************************************************
* Register name : SENSOR_DP_R
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 DP_OFFSET_R : 12;  /* Bits(11:0), null */
      M_UINT32 RESERVED    : 4;   /* Bits(15:12), null */
      M_UINT32 RSVD0       : 16;  /* Bits(31:16), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_DP_R_TYPE;


/**************************************************************************
* Register name : SENSOR_DP_B
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 DP_OFFSET_B            : 12;  /* Bits(11:0), null */
      M_UINT32 RESERVED               : 4;   /* Bits(15:12), null */
      M_UINT32 RSVD0                  : 16;  /* Bits(31:16), Reserved */
      M_UINT32 RSVD_REGISTER_SPACE[5] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_DP_B_TYPE;


/**************************************************************************
* Register name : DEBUG_PINS
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 DEBUG0_SEL             : 5;  /* Bits(4:0), null */
      M_UINT32 RSVD0                  : 3;  /* Bits(7:5), Reserved */
      M_UINT32 DEBUG1_SEL             : 5;  /* Bits(12:8), null */
      M_UINT32 RSVD1                  : 3;  /* Bits(15:13), Reserved */
      M_UINT32 DEBUG2_SEL             : 5;  /* Bits(20:16), null */
      M_UINT32 RSVD2                  : 3;  /* Bits(23:21), Reserved */
      M_UINT32 DEBUG3_SEL             : 5;  /* Bits(28:24), null */
      M_UINT32 RSVD3                  : 3;  /* Bits(31:29), Reserved */
      M_UINT32 RSVD_REGISTER_SPACE[1] ;     /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_DEBUG_PINS_TYPE;


/**************************************************************************
* Register name : TRIGGER_MISSED
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 TRIGGER_MISSED_CNTR    : 16;  /* Bits(15:0), TRIGGER MISSED CouNTeR */
      M_UINT32 RSVD0                  : 12;  /* Bits(27:16), Reserved */
      M_UINT32 TRIGGER_MISSED_RST     : 1;   /* Bits(28:28), TRIGGER MISSED ReSeT */
      M_UINT32 RSVD1                  : 3;   /* Bits(31:29), Reserved */
      M_UINT32 RSVD_REGISTER_SPACE[1] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_TRIGGER_MISSED_TYPE;


/**************************************************************************
* Register name : SENSOR_FPS
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 SENSOR_FPS              : 16;  /* Bits(15:0), SENSOR Frame Per Second */
      M_UINT32 RSVD0                   : 16;  /* Bits(31:16), Reserved */
      M_UINT32 RSVD_REGISTER_SPACE[43] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_FPS_TYPE;


/**************************************************************************
* Register name : DEBUG
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 LED_TEST               : 1;   /* Bits(0:0), null */
      M_UINT32 LED_TEST_COLOR         : 2;   /* Bits(2:1), null */
      M_UINT32 RSVD0                  : 25;  /* Bits(27:3), Reserved */
      M_UINT32 DEBUG_RST_CNTR         : 1;   /* Bits(28:28), null */
      M_UINT32 RSVD1                  : 3;   /* Bits(31:29), Reserved */
      M_UINT32 RSVD_REGISTER_SPACE[1] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_DEBUG_TYPE;


/**************************************************************************
* Register name : DEBUG_CNTR1
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 SENSOR_FRAME_DURATION  : 28;  /* Bits(27:0), */
      M_UINT32 RSVD0                  : 4;   /* Bits(31:28), Reserved */
      M_UINT32 RSVD_REGISTER_SPACE[3] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_DEBUG_CNTR1_TYPE;


/**************************************************************************
* Register name : EXP_FOT
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 EXP_FOT_TIME           : 12;  /* Bits(11:0), EXPosure during FOT TIME */
      M_UINT32 RSVD0                  : 4;   /* Bits(15:12), Reserved */
      M_UINT32 EXP_FOT                : 1;   /* Bits(16:16), EXPosure during FOT */
      M_UINT32 RSVD1                  : 15;  /* Bits(31:17), Reserved */
      M_UINT32 RSVD_REGISTER_SPACE[1] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_EXP_FOT_TYPE;


/**************************************************************************
* Register name : ACQ_SFNC
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 RELOAD_GRAB_PARAMS     : 1;   /* Bits(0:0), */
      M_UINT32 RSVD0                  : 31;  /* Bits(31:1), Reserved */
      M_UINT32 RSVD_REGISTER_SPACE[3] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_ACQ_SFNC_TYPE;


/**************************************************************************
* Register name : LUT_CTRL
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 LUT_ADD                : 10;  /* Bits(9:0), null */
      M_UINT32 LUT_SS                 : 1;   /* Bits(10:10), LUT SnapShot */
      M_UINT32 LUT_WRN                : 1;   /* Bits(11:11), LUT Write ReadNot */
      M_UINT32 LUT_SEL                : 3;   /* Bits(14:12), LUT SELection */
      M_UINT32 RSVD0                  : 1;   /* Bits(15:15), Reserved */
      M_UINT32 LUT_DATA_W             : 10;  /* Bits(25:16), LUT DATA to Write */
      M_UINT32 RSVD1                  : 2;   /* Bits(27:26), Reserved */
      M_UINT32 LUT_PALETTE_W          : 1;   /* Bits(28:28), LUT PALETTE to Write */
      M_UINT32 LUT_PALETTE_USE        : 1;   /* Bits(29:29), LUT PALETTE to USE */
      M_UINT32 RSVD2                  : 1;   /* Bits(30:30), Reserved */
      M_UINT32 LUT_BYPASS             : 1;   /* Bits(31:31), LUT BYPASS */
      M_UINT32 RSVD_REGISTER_SPACE[1] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DATA_LUT_CTRL_TYPE;


/**************************************************************************
* Register name : LUT_RB
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 LUT_RB                 : 10;  /* Bits(9:0), null */
      M_UINT32 RSVD0                  : 22;  /* Bits(31:10), Reserved */
      M_UINT32 RSVD_REGISTER_SPACE[1] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DATA_LUT_RB_TYPE;


/**************************************************************************
* Register name : WB_MULT1
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 WB_MULT_B              : 16;  /* Bits(15:0), null */
      M_UINT32 WB_MULT_G              : 16;  /* Bits(31:16), null */
      M_UINT32 RSVD_REGISTER_SPACE[1] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DATA_WB_MULT1_TYPE;


/**************************************************************************
* Register name : WB_MULT2
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 WB_MULT_R              : 16;  /* Bits(15:0), null */
      M_UINT32 RSVD0                  : 16;  /* Bits(31:16), Reserved */
      M_UINT32 RSVD_REGISTER_SPACE[1] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DATA_WB_MULT2_TYPE;


/**************************************************************************
* Register name : WB_B_ACC
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 B_ACC                  : 31;  /* Bits(30:0), null */
      M_UINT32 RSVD0                  : 1;   /* Bits(31:31), Reserved */
      M_UINT32 RSVD_REGISTER_SPACE[1] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DATA_WB_B_ACC_TYPE;


/**************************************************************************
* Register name : WB_G_ACC
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 G_ACC                  : 32;  /* Bits(31:0), null */
      M_UINT32 RSVD_REGISTER_SPACE[1] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DATA_WB_G_ACC_TYPE;


/**************************************************************************
* Register name : WB_R_ACC
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 R_ACC                  : 31;  /* Bits(30:0), null */
      M_UINT32 RSVD0                  : 1;   /* Bits(31:31), Reserved */
      M_UINT32 RSVD_REGISTER_SPACE[1] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DATA_WB_R_ACC_TYPE;


/**************************************************************************
* Register name : FPN_ADD
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 FPN_ADD : 10;  /* Bits(9:0), FPN ADDress */
      M_UINT32 RSVD0   : 6;   /* Bits(15:10), Reserved */
      M_UINT32 FPN_SS  : 1;   /* Bits(16:16), FPN SnapShot */
      M_UINT32 RSVD1   : 7;   /* Bits(23:17), Reserved */
      M_UINT32 FPN_EN  : 1;   /* Bits(24:24), FPN ENable */
      M_UINT32 RSVD2   : 3;   /* Bits(27:25), Reserved */
      M_UINT32 FPN_WE  : 1;   /* Bits(28:28), FPN Write Enable */
      M_UINT32 RSVD3   : 2;   /* Bits(30:29), Reserved */
      M_UINT32 FPN_73  : 1;   /* Bits(31:31), null */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DATA_FPN_ADD_TYPE;


/**************************************************************************
* Register name : FPN_READ_REG
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 FPN_READ_FPN     : 11;  /* Bits(10:0), null */
      M_UINT32 RSVD0            : 5;   /* Bits(15:11), Reserved */
      M_UINT32 FPN_READ_PRNU    : 9;   /* Bits(24:16), null */
      M_UINT32 RSVD1            : 3;   /* Bits(27:25), Reserved */
      M_UINT32 FPN_READ_PIX_SEL : 3;   /* Bits(30:28), null */
      M_UINT32 RSVD2            : 1;   /* Bits(31:31), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DATA_FPN_READ_REG_TYPE;


/**************************************************************************
* Register name : FPN_DATA
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 FPN_DATA_FPN  : 11;  /* Bits(10:0), FPN DATA FPN */
      M_UINT32 RSVD0         : 5;   /* Bits(15:11), Reserved */
      M_UINT32 FPN_DATA_PRNU : 9;   /* Bits(24:16), FPN DATA PRNU */
      M_UINT32 RSVD1         : 7;   /* Bits(31:25), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DATA_FPN_DATA_TYPE;


/**************************************************************************
* Register name : FPN_CONTRAST
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 CONTRAST_OFFSET        : 8;   /* Bits(7:0), CONTRAST OFFSET */
      M_UINT32 RSVD0                  : 8;   /* Bits(15:8), Reserved */
      M_UINT32 CONTRAST_GAIN          : 12;  /* Bits(27:16), null */
      M_UINT32 RSVD1                  : 4;   /* Bits(31:28), Reserved */
      M_UINT32 RSVD_REGISTER_SPACE[1] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DATA_FPN_CONTRAST_TYPE;


/**************************************************************************
* Register name : FPN_ACC_ADD
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 FPN_ACC_ADD            : 12;  /* Bits(11:0), FPN ACCumulator ADDress */
      M_UINT32 RSVD0                  : 4;   /* Bits(15:12), Reserved */
      M_UINT32 FPN_ACC_R_SS           : 1;   /* Bits(16:16), FPN ACCumulator Read Snapshot */
      M_UINT32 RSVD1                  : 3;   /* Bits(19:17), Reserved */
      M_UINT32 FPN_ACC_MODE_EN        : 1;   /* Bits(20:20), FPN ACCumulator MODE ENable */
      M_UINT32 FPN_ACC_MODE_SEL       : 1;   /* Bits(21:21), null */
      M_UINT32 RSVD2                  : 10;  /* Bits(31:22), Reserved */
      M_UINT32 RSVD_REGISTER_SPACE[1] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DATA_FPN_ACC_ADD_TYPE;


/**************************************************************************
* Register name : FPN_ACC_DATA
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 FPN_ACC_DATA           : 24;  /* Bits(23:0), FPN ACCumulator DATA */
      M_UINT32 FPN_ACC_R_WORKING      : 1;   /* Bits(24:24), FPN ACCumulator Read WORKING */
      M_UINT32 RSVD0                  : 7;   /* Bits(31:25), Reserved */
      M_UINT32 RSVD_REGISTER_SPACE[3] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DATA_FPN_ACC_DATA_TYPE;


/**************************************************************************
* Register name : DPC_LIST_CTRL
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 DPC_LIST_ADD           : 6;  /* Bits(5:0), null */
      M_UINT32 RSVD0                  : 2;  /* Bits(7:6), Reserved */
      M_UINT32 DPC_LIST_SS            : 1;  /* Bits(8:8), null */
      M_UINT32 RSVD1                  : 3;  /* Bits(11:9), Reserved */
      M_UINT32 DPC_LIST_WRN           : 1;  /* Bits(12:12), null */
      M_UINT32 RSVD2                  : 3;  /* Bits(15:13), Reserved */
      M_UINT32 DPC_LIST_COUNT         : 6;  /* Bits(21:16), null */
      M_UINT32 RSVD3                  : 2;  /* Bits(23:22), Reserved */
      M_UINT32 DPC_ENABLE             : 1;  /* Bits(24:24), null */
      M_UINT32 DPC_PATTERN0_CFG       : 1;  /* Bits(25:25), null */
      M_UINT32 DPC_FIRSTLAST_LINE_REM : 1;  /* Bits(26:26), null */
      M_UINT32 RSVD4                  : 1;  /* Bits(27:27), Reserved */
      M_UINT32 DPC_FIFO_RESET         : 1;  /* Bits(28:28), */
      M_UINT32 RSVD5                  : 1;  /* Bits(29:29), Reserved */
      M_UINT32 DPC_FIFO_OVERRUN       : 1;  /* Bits(30:30), null */
      M_UINT32 DPC_FIFO_UNDERRUN      : 1;  /* Bits(31:31), */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DATA_DPC_LIST_CTRL_TYPE;


/**************************************************************************
* Register name : DPC_LIST_DATA
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 DPC_LIST_CORR_X       : 12;  /* Bits(11:0), null */
      M_UINT32 DPC_LIST_CORR_Y       : 12;  /* Bits(23:12), null */
      M_UINT32 DPC_LIST_CORR_PATTERN : 8;   /* Bits(31:24), null */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DATA_DPC_LIST_DATA_TYPE;


/**************************************************************************
* Register name : DPC_LIST_DATA_RD
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 DPC_LIST_CORR_X       : 12;  /* Bits(11:0), null */
      M_UINT32 DPC_LIST_CORR_Y       : 12;  /* Bits(23:12), null */
      M_UINT32 DPC_LIST_CORR_PATTERN : 8;   /* Bits(31:24), null */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DATA_DPC_LIST_DATA_RD_TYPE;


/**************************************************************************
* Register name : CTRL
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 ENABLE           : 1;   /* Bits(0:0), null */
      M_UINT32 CLR              : 1;   /* Bits(1:1), null */
      M_UINT32 CALIBRATE_SERDES : 1;   /* Bits(2:2), Initiate the SERDES TAP calibrartion */
      M_UINT32 RESET_IDELAYCTRL : 1;   /* Bits(3:3), Reset the Xilinx macro IDELAYCTRL */
      M_UINT32 RSVD0            : 28;  /* Bits(31:4), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_HISPI_CTRL_TYPE;


/**************************************************************************
* Register name : IDELAYCTRL_STATUS
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 PLL_LOCKED : 1;   /* Bits(0:0), IDELAYCTRL PLL locked */
      M_UINT32 RSVD0      : 31;  /* Bits(31:1), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_HISPI_IDELAYCTRL_STATUS_TYPE;


/**************************************************************************
* Register name : LANE_DECODER_STATUS
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 CALIBRATION_TAP_VALUE : 5;   /* Bits(4:0), null */
      M_UINT32 CALIBRATION_ACTIVE    : 1;   /* Bits(5:5), null */
      M_UINT32 CALIBRARTION_ERROR    : 1;   /* Bits(6:6), null */
      M_UINT32 FIFO_OVERRUN          : 1;   /* Bits(7:7), null */
      M_UINT32 FIFO_UNDERRUN         : 1;   /* Bits(8:8), null */
      M_UINT32 RSVD0                 : 23;  /* Bits(31:9), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_HISPI_LANE_DECODER_STATUS_TYPE;


/**************************************************************************
* Register name : LANE_PACKER_STATUS
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 RSVD0         : 7;   /* Bits(6:0), Reserved */
      M_UINT32 FIFO_OVERRUN  : 1;   /* Bits(7:7), null */
      M_UINT32 FIFO_UNDERRUN : 1;   /* Bits(8:8), null */
      M_UINT32 RSVD1         : 23;  /* Bits(31:9), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_HISPI_LANE_PACKER_STATUS_TYPE;


/**************************************************************************
* Section name   : SYSTEM
***************************************************************************/
typedef struct
{
   FPGA_REGFILE_XGS_ATHENA_SYSTEM_TAG_TYPE        TAG;         /* Address offset: 0x0 */
   FPGA_REGFILE_XGS_ATHENA_SYSTEM_VERSION_TYPE    VERSION;     /* Address offset: 0x4 */
   FPGA_REGFILE_XGS_ATHENA_SYSTEM_CAPABILITY_TYPE CAPABILITY;  /* Address offset: 0x8 */
   FPGA_REGFILE_XGS_ATHENA_SYSTEM_SCRATCHPAD_TYPE SCRATCHPAD;  /* Address offset: 0xc */
} FPGA_REGFILE_XGS_ATHENA_SYSTEM_TYPE;

/**************************************************************************
* Section name   : DMA
***************************************************************************/
typedef struct
{
   FPGA_REGFILE_XGS_ATHENA_DMA_CTRL_TYPE          CTRL;           /* Address offset: 0x0 */
   FPGA_REGFILE_XGS_ATHENA_DMA_FSTART_TYPE        FSTART;         /* Address offset: 0x8 */
   FPGA_REGFILE_XGS_ATHENA_DMA_FSTART_HIGH_TYPE   FSTART_HIGH;    /* Address offset: 0xc */
   FPGA_REGFILE_XGS_ATHENA_DMA_FSTART_G_TYPE      FSTART_G;       /* Address offset: 0x10 */
   FPGA_REGFILE_XGS_ATHENA_DMA_FSTART_G_HIGH_TYPE FSTART_G_HIGH;  /* Address offset: 0x14 */
   FPGA_REGFILE_XGS_ATHENA_DMA_FSTART_R_TYPE      FSTART_R;       /* Address offset: 0x18 */
   FPGA_REGFILE_XGS_ATHENA_DMA_FSTART_R_HIGH_TYPE FSTART_R_HIGH;  /* Address offset: 0x1c */
   FPGA_REGFILE_XGS_ATHENA_DMA_LINE_PITCH_TYPE    LINE_PITCH;     /* Address offset: 0x20 */
   FPGA_REGFILE_XGS_ATHENA_DMA_LINE_SIZE_TYPE     LINE_SIZE;      /* Address offset: 0x24 */
   FPGA_REGFILE_XGS_ATHENA_DMA_CSC_TYPE           CSC;            /* Address offset: 0x28 */
} FPGA_REGFILE_XGS_ATHENA_DMA_TYPE;

/**************************************************************************
* Section name   : ACQ
***************************************************************************/
typedef struct
{
   FPGA_REGFILE_XGS_ATHENA_ACQ_GRAB_CTRL_TYPE              GRAB_CTRL;               /* Address offset: 0x0 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_GRAB_STAT_TYPE              GRAB_STAT;               /* Address offset: 0x8 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_READOUT_CFG1_TYPE           READOUT_CFG1;            /* Address offset: 0x10 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_READOUT_CFG_FRAME_LINE_TYPE READOUT_CFG_FRAME_LINE;  /* Address offset: 0x14 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_READOUT_CFG2_TYPE           READOUT_CFG2;            /* Address offset: 0x18 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_READOUT_CFG3_TYPE           READOUT_CFG3;            /* Address offset: 0x20 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_READOUT_CFG4_TYPE           READOUT_CFG4;            /* Address offset: 0x24 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_EXP_CTRL1_TYPE              EXP_CTRL1;               /* Address offset: 0x28 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_EXP_CTRL2_TYPE              EXP_CTRL2;               /* Address offset: 0x30 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_EXP_CTRL3_TYPE              EXP_CTRL3;               /* Address offset: 0x38 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_TRIGGER_DELAY_TYPE          TRIGGER_DELAY;           /* Address offset: 0x40 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_STROBE_CTRL1_TYPE           STROBE_CTRL1;            /* Address offset: 0x48 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_STROBE_CTRL2_TYPE           STROBE_CTRL2;            /* Address offset: 0x50 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_ACQ_SER_CTRL_TYPE           ACQ_SER_CTRL;            /* Address offset: 0x58 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_ACQ_SER_ADDATA_TYPE         ACQ_SER_ADDATA;          /* Address offset: 0x60 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_ACQ_SER_STAT_TYPE           ACQ_SER_STAT;            /* Address offset: 0x68 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_CTRL_TYPE            SENSOR_CTRL;             /* Address offset: 0x90 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_STAT_TYPE            SENSOR_STAT;             /* Address offset: 0x98 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_SUBSAMPLING_TYPE     SENSOR_SUBSAMPLING;      /* Address offset: 0x9c */
   FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_GAIN_ANA_TYPE        SENSOR_GAIN_ANA;         /* Address offset: 0xa4 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_ROI_Y_START_TYPE     SENSOR_ROI_Y_START;      /* Address offset: 0xa8 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_ROI_Y_SIZE_TYPE      SENSOR_ROI_Y_SIZE;       /* Address offset: 0xac */
   FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_ROI2_Y_START_TYPE    SENSOR_ROI2_Y_START;     /* Address offset: 0xb0 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_ROI2_Y_SIZE_TYPE     SENSOR_ROI2_Y_SIZE;      /* Address offset: 0xb4 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_M_LINES_TYPE         SENSOR_M_LINES;          /* Address offset: 0xb8 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_DP_GR_TYPE           SENSOR_DP_GR;            /* Address offset: 0xbc */
   FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_DP_GB_TYPE           SENSOR_DP_GB;            /* Address offset: 0xc0 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_DP_R_TYPE            SENSOR_DP_R;             /* Address offset: 0xc4 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_DP_B_TYPE            SENSOR_DP_B;             /* Address offset: 0xc8 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_DEBUG_PINS_TYPE             DEBUG_PINS;              /* Address offset: 0xe0 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_TRIGGER_MISSED_TYPE         TRIGGER_MISSED;          /* Address offset: 0xe8 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_FPS_TYPE             SENSOR_FPS;              /* Address offset: 0xf0 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_DEBUG_TYPE                  DEBUG;                   /* Address offset: 0x1a0 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_DEBUG_CNTR1_TYPE            DEBUG_CNTR1;             /* Address offset: 0x1a8 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_EXP_FOT_TYPE                EXP_FOT;                 /* Address offset: 0x1b8 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_ACQ_SFNC_TYPE               ACQ_SFNC;                /* Address offset: 0x1c0 */
} FPGA_REGFILE_XGS_ATHENA_ACQ_TYPE;

/**************************************************************************
* Section name   : DATA
***************************************************************************/
typedef struct
{
   FPGA_REGFILE_XGS_ATHENA_DATA_LUT_CTRL_TYPE         LUT_CTRL;          /* Address offset: 0x0 */
   FPGA_REGFILE_XGS_ATHENA_DATA_LUT_RB_TYPE           LUT_RB;            /* Address offset: 0x8 */
   FPGA_REGFILE_XGS_ATHENA_DATA_WB_MULT1_TYPE         WB_MULT1;          /* Address offset: 0x10 */
   FPGA_REGFILE_XGS_ATHENA_DATA_WB_MULT2_TYPE         WB_MULT2;          /* Address offset: 0x18 */
   FPGA_REGFILE_XGS_ATHENA_DATA_WB_B_ACC_TYPE         WB_B_ACC;          /* Address offset: 0x20 */
   FPGA_REGFILE_XGS_ATHENA_DATA_WB_G_ACC_TYPE         WB_G_ACC;          /* Address offset: 0x28 */
   FPGA_REGFILE_XGS_ATHENA_DATA_WB_R_ACC_TYPE         WB_R_ACC;          /* Address offset: 0x30 */
   FPGA_REGFILE_XGS_ATHENA_DATA_FPN_ADD_TYPE          FPN_ADD;           /* Address offset: 0x38 */
   FPGA_REGFILE_XGS_ATHENA_DATA_FPN_READ_REG_TYPE     FPN_READ_REG;      /* Address offset: 0x3c */
   FPGA_REGFILE_XGS_ATHENA_DATA_FPN_DATA_TYPE         FPN_DATA[8];       /* Address offset: 0x40 */
   FPGA_REGFILE_XGS_ATHENA_DATA_FPN_CONTRAST_TYPE     FPN_CONTRAST;      /* Address offset: 0x60 */
   FPGA_REGFILE_XGS_ATHENA_DATA_FPN_ACC_ADD_TYPE      FPN_ACC_ADD;       /* Address offset: 0x68 */
   FPGA_REGFILE_XGS_ATHENA_DATA_FPN_ACC_DATA_TYPE     FPN_ACC_DATA;      /* Address offset: 0x70 */
   FPGA_REGFILE_XGS_ATHENA_DATA_DPC_LIST_CTRL_TYPE    DPC_LIST_CTRL;     /* Address offset: 0x80 */
   FPGA_REGFILE_XGS_ATHENA_DATA_DPC_LIST_DATA_TYPE    DPC_LIST_DATA;     /* Address offset: 0x84 */
   FPGA_REGFILE_XGS_ATHENA_DATA_DPC_LIST_DATA_RD_TYPE DPC_LIST_DATA_RD;  /* Address offset: 0x88 */
} FPGA_REGFILE_XGS_ATHENA_DATA_TYPE;

/**************************************************************************
* Section name   : HISPI
***************************************************************************/
typedef struct
{
   FPGA_REGFILE_XGS_ATHENA_HISPI_CTRL_TYPE                CTRL;                    /* Address offset: 0x0 */
   FPGA_REGFILE_XGS_ATHENA_HISPI_IDELAYCTRL_STATUS_TYPE   IDELAYCTRL_STATUS;       /* Address offset: 0x4 */
   FPGA_REGFILE_XGS_ATHENA_HISPI_LANE_DECODER_STATUS_TYPE LANE_DECODER_STATUS[6];  /* Address offset: 0x8 */
   FPGA_REGFILE_XGS_ATHENA_HISPI_LANE_PACKER_STATUS_TYPE  LANE_PACKER_STATUS[3];   /* Address offset: 0x20 */
} FPGA_REGFILE_XGS_ATHENA_HISPI_TYPE;

/**************************************************************************
* Register file name : REGFILE_XGS_ATHENA
***************************************************************************/
typedef struct
{
   FPGA_REGFILE_XGS_ATHENA_SYSTEM_TYPE SYSTEM;     /* Section; Base address offset: 0x0 */
   M_UINT32                            RSVD0[24];  /* Padding; Size (96 Bytes) */
   FPGA_REGFILE_XGS_ATHENA_DMA_TYPE    DMA;        /* Section; Base address offset: 0x70 */
   M_UINT32                            RSVD1[22];  /* Padding; Size (88 Bytes) */
   FPGA_REGFILE_XGS_ATHENA_ACQ_TYPE    ACQ;        /* Section; Base address offset: 0x100 */
   M_UINT32                            RSVD2[12];  /* Padding; Size (48 Bytes) */
   FPGA_REGFILE_XGS_ATHENA_DATA_TYPE   DATA;       /* Section; Base address offset: 0x300 */
   M_UINT32                            RSVD3[29];  /* Padding; Size (116 Bytes) */
   FPGA_REGFILE_XGS_ATHENA_HISPI_TYPE  HISPI;      /* Section; Base address offset: 0x400 */
} FPGA_REGFILE_XGS_ATHENA_TYPE;



#endif
