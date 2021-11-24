/**************************************************************************
*
* File name    :  regfile_xgs_athena.h
* Created by   : jmansill
*
* Content      :  This file contains the register structures for the
*                 fpga regfile_xgs_athena processing unit.
*
* Hardware native endianness: little endian
*
* FDK IDE Version     : 4.7.0_beta3
* Build ID            : I20191219-1127
* Register file CRC32 : 0xA2225BCE
*
* COPYRIGHT (c) 2021 Matrox Electronic Systems Ltd.
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
#define FPGA_REGFILE_XGS_ATHENA_DMA_OUTPUT_BUFFER_ADDRESS              0x0A8
#define FPGA_REGFILE_XGS_ATHENA_DMA_TLP_ADDRESS                        0x0AC
#define FPGA_REGFILE_XGS_ATHENA_DMA_ROI_X_ADDRESS                      0x0B0
#define FPGA_REGFILE_XGS_ATHENA_DMA_ROI_Y_ADDRESS                      0x0BC
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
#define FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_M_LINES_ADDRESS             0x1B8
#define FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_DP_GR_ADDRESS               0x1BC
#define FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_DP_GB_ADDRESS               0x1C0
#define FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_DP_R_ADDRESS                0x1C4
#define FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_DP_B_ADDRESS                0x1C8
#define FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_GAIN_DIG_G_ADDRESS          0x1CC
#define FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_GAIN_DIG_RB_ADDRESS         0x1D0
#define FPGA_REGFILE_XGS_ATHENA_ACQ_DEBUG_PINS_ADDRESS                 0x1E0
#define FPGA_REGFILE_XGS_ATHENA_ACQ_TRIGGER_MISSED_ADDRESS             0x1E8
#define FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_FPS_ADDRESS                 0x1F0
#define FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_FPS2_ADDRESS                0x1F4
#define FPGA_REGFILE_XGS_ATHENA_ACQ_DEBUG_ADDRESS                      0x2A0
#define FPGA_REGFILE_XGS_ATHENA_ACQ_DEBUG_CNTR1_ADDRESS                0x2A8
#define FPGA_REGFILE_XGS_ATHENA_ACQ_DEBUG_CNTR2_ADDRESS                0x2B0
#define FPGA_REGFILE_XGS_ATHENA_ACQ_DEBUG_CNTR3_ADDRESS                0x2B4
#define FPGA_REGFILE_XGS_ATHENA_ACQ_EXP_FOT_ADDRESS                    0x2B8
#define FPGA_REGFILE_XGS_ATHENA_ACQ_ACQ_SFNC_ADDRESS                   0x2C0
#define FPGA_REGFILE_XGS_ATHENA_ACQ_TIMER_CTRL_ADDRESS                 0x2D0
#define FPGA_REGFILE_XGS_ATHENA_ACQ_TIMER_DELAY_ADDRESS                0x2D4
#define FPGA_REGFILE_XGS_ATHENA_ACQ_TIMER_DURATION_ADDRESS             0x2D8
#define FPGA_REGFILE_XGS_ATHENA_HISPI_CTRL_ADDRESS                     0x400
#define FPGA_REGFILE_XGS_ATHENA_HISPI_STATUS_ADDRESS                   0x404
#define FPGA_REGFILE_XGS_ATHENA_HISPI_IDELAYCTRL_STATUS_ADDRESS        0x408
#define FPGA_REGFILE_XGS_ATHENA_HISPI_IDLE_CHARACTER_ADDRESS           0x40C
#define FPGA_REGFILE_XGS_ATHENA_HISPI_PHY_ADDRESS                      0x410
#define FPGA_REGFILE_XGS_ATHENA_HISPI_FRAME_CFG_ADDRESS                0x414
#define FPGA_REGFILE_XGS_ATHENA_HISPI_FRAME_CFG_X_VALID_ADDRESS        0x418
#define FPGA_REGFILE_XGS_ATHENA_HISPI_LANE_DECODER_STATUS_ADDRESS      0x424
#define FPGA_REGFILE_XGS_ATHENA_HISPI_TAP_HISTOGRAM_ADDRESS            0x43C
#define FPGA_REGFILE_XGS_ATHENA_HISPI_DEBUG_ADDRESS                    0x454
#define FPGA_REGFILE_XGS_ATHENA_DPC_DPC_CAPABILITIES_ADDRESS           0x480
#define FPGA_REGFILE_XGS_ATHENA_DPC_DPC_LIST_CTRL_ADDRESS              0x484
#define FPGA_REGFILE_XGS_ATHENA_DPC_DPC_LIST_STAT_ADDRESS              0x488
#define FPGA_REGFILE_XGS_ATHENA_DPC_DPC_LIST_DATA1_ADDRESS             0x48C
#define FPGA_REGFILE_XGS_ATHENA_DPC_DPC_LIST_DATA2_ADDRESS             0x490
#define FPGA_REGFILE_XGS_ATHENA_DPC_DPC_LIST_DATA1_RD_ADDRESS          0x494
#define FPGA_REGFILE_XGS_ATHENA_DPC_DPC_LIST_DATA2_RD_ADDRESS          0x498
#define FPGA_REGFILE_XGS_ATHENA_LUT_LUT_CAPABILITIES_ADDRESS           0x4B0
#define FPGA_REGFILE_XGS_ATHENA_LUT_LUT_CTRL_ADDRESS                   0x4B4
#define FPGA_REGFILE_XGS_ATHENA_LUT_LUT_RB_ADDRESS                     0x4B8
#define FPGA_REGFILE_XGS_ATHENA_BAYER_BAYER_CAPABILITIES_ADDRESS       0x4C0
#define FPGA_REGFILE_XGS_ATHENA_BAYER_WB_MUL1_ADDRESS                  0x4C4
#define FPGA_REGFILE_XGS_ATHENA_BAYER_WB_MUL2_ADDRESS                  0x4C8
#define FPGA_REGFILE_XGS_ATHENA_BAYER_WB_B_ACC_ADDRESS                 0x4CC
#define FPGA_REGFILE_XGS_ATHENA_BAYER_WB_G_ACC_ADDRESS                 0x4D0
#define FPGA_REGFILE_XGS_ATHENA_BAYER_WB_R_ACC_ADDRESS                 0x4D4
#define FPGA_REGFILE_XGS_ATHENA_BAYER_CCM_CTRL_ADDRESS                 0x4D8
#define FPGA_REGFILE_XGS_ATHENA_BAYER_CCM_KR1_ADDRESS                  0x4DC
#define FPGA_REGFILE_XGS_ATHENA_BAYER_CCM_KR2_ADDRESS                  0x4E0
#define FPGA_REGFILE_XGS_ATHENA_BAYER_CCM_KG1_ADDRESS                  0x4E4
#define FPGA_REGFILE_XGS_ATHENA_BAYER_CCM_KG2_ADDRESS                  0x4E8
#define FPGA_REGFILE_XGS_ATHENA_BAYER_CCM_KB1_ADDRESS                  0x4EC
#define FPGA_REGFILE_XGS_ATHENA_BAYER_CCM_KB2_ADDRESS                  0x4F0
#define FPGA_REGFILE_XGS_ATHENA_SYSMONXIL_TEMP_ADDRESS                 0x700
#define FPGA_REGFILE_XGS_ATHENA_SYSMONXIL_VCCINT_ADDRESS               0x704
#define FPGA_REGFILE_XGS_ATHENA_SYSMONXIL_VCCAUX_ADDRESS               0x708
#define FPGA_REGFILE_XGS_ATHENA_SYSMONXIL_VCCBRAM_ADDRESS              0x718
#define FPGA_REGFILE_XGS_ATHENA_SYSMONXIL_TEMP_MAX_ADDRESS             0x780
#define FPGA_REGFILE_XGS_ATHENA_SYSMONXIL_TEMP_MIN_ADDRESS             0x790

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
      M_UINT32 VALUE : 15;  /* Bits(14:0), Host Line size */
      M_UINT32 RSVD0 : 17;  /* Bits(31:15), Reserved */
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
      M_UINT32 REVERSE_X              : 1;   /* Bits(8:8), Reverse image in X direction */
      M_UINT32 REVERSE_Y              : 1;   /* Bits(9:9), REVERSE Y */
      M_UINT32 SUB_X                  : 4;   /* Bits(13:10), null */
      M_UINT32 RSVD1                  : 10;  /* Bits(23:14), Reserved */
      M_UINT32 COLOR_SPACE            : 3;   /* Bits(26:24), null */
      M_UINT32 RSVD2                  : 5;   /* Bits(31:27), Reserved */
      M_UINT32 RSVD_REGISTER_SPACE[3] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DMA_CSC_TYPE;


/**************************************************************************
* Register name : OUTPUT_BUFFER
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 CLR_MAX_LINE_BUFF_CNT : 1;   /* Bits(0:0), Clear maximum line buffer count */
      M_UINT32 RSVD0                 : 3;   /* Bits(3:1), Reserved */
      M_UINT32 PCIE_BACK_PRESSURE    : 1;   /* Bits(4:4), PCIE link back pressure detected */
      M_UINT32 RSVD1                 : 15;  /* Bits(19:5), Reserved */
      M_UINT32 ADDRESS_BUS_WIDTH     : 4;   /* Bits(23:20), Line buffer address size in bits */
      M_UINT32 LINE_PTR_WIDTH        : 2;   /* Bits(25:24), Line pointer size (in bits) */
      M_UINT32 RSVD2                 : 2;   /* Bits(27:26), Reserved */
      M_UINT32 MAX_LINE_BUFF_CNT     : 3;   /* Bits(30:28), Maximum line buffer count */
      M_UINT32 RSVD3                 : 1;   /* Bits(31:31), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DMA_OUTPUT_BUFFER_TYPE;


/**************************************************************************
* Register name : TLP
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 CFG_MAX_PLD   : 3;   /* Bits(2:0), PCIe Device Control Register (Offset 08h); bits 7 downto 5 */
      M_UINT32 BUS_MASTER_EN : 1;   /* Bits(3:3), null */
      M_UINT32 RSVD0         : 12;  /* Bits(15:4), Reserved */
      M_UINT32 MAX_PAYLOAD   : 12;  /* Bits(27:16), null */
      M_UINT32 RSVD1         : 4;   /* Bits(31:28), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DMA_TLP_TYPE;


/**************************************************************************
* Register name : ROI_X
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 X_START                : 13;  /* Bits(12:0), null */
      M_UINT32 RSVD0                  : 3;   /* Bits(15:13), Reserved */
      M_UINT32 X_SIZE                 : 13;  /* Bits(28:16), null */
      M_UINT32 RSVD1                  : 2;   /* Bits(30:29), Reserved */
      M_UINT32 ROI_EN                 : 1;   /* Bits(31:31), Region of interest enable */
      M_UINT32 RSVD_REGISTER_SPACE[2] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DMA_ROI_X_TYPE;


/**************************************************************************
* Register name : ROI_Y
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 Y_START                : 13;  /* Bits(12:0), null */
      M_UINT32 RSVD0                  : 3;   /* Bits(15:13), Reserved */
      M_UINT32 Y_SIZE                 : 13;  /* Bits(28:16), null */
      M_UINT32 RSVD1                  : 2;   /* Bits(30:29), Reserved */
      M_UINT32 ROI_EN                 : 1;   /* Bits(31:31), Region of interest enable */
      M_UINT32 RSVD_REGISTER_SPACE[2] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DMA_ROI_Y_TYPE;


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
      M_UINT32 LINE_TIME : 16;  /* Bits(15:0), LINE TIME */
      M_UINT32 RSVD0     : 16;  /* Bits(31:16), Reserved */
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
      M_UINT32 KEEP_OUT_TRIG_ENA   : 1;   /* Bits(16:16), null */
      M_UINT32 RSVD0               : 15;  /* Bits(31:17), Reserved */
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
      M_UINT32 SENSOR_REG_UPDATE      : 1;  /* Bits(4:4), SENSOR REGister UPDATE */
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
      M_UINT32 Y_SIZE                 : 10;  /* Bits(9:0), Y SIZE */
      M_UINT32 RESERVED               : 6;   /* Bits(15:10), null */
      M_UINT32 RSVD0                  : 16;  /* Bits(31:16), Reserved */
      M_UINT32 RSVD_REGISTER_SPACE[2] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_ROI_Y_SIZE_TYPE;


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
      M_UINT32 M_LINES_SENSOR  : 10;  /* Bits(9:0), null */
      M_UINT32 M_SUPPRESSED    : 5;   /* Bits(14:10), null */
      M_UINT32 M_LINES_DISPLAY : 1;   /* Bits(15:15), null */
      M_UINT32 RSVD0           : 16;  /* Bits(31:16), Reserved */
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
      M_UINT32 DP_OFFSET_B : 12;  /* Bits(11:0), null */
      M_UINT32 RESERVED    : 4;   /* Bits(15:12), null */
      M_UINT32 RSVD0       : 16;  /* Bits(31:16), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_DP_B_TYPE;


/**************************************************************************
* Register name : SENSOR_GAIN_DIG_G
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 DG_FACTOR_GB : 7;   /* Bits(6:0), null */
      M_UINT32 RESERVED0    : 1;   /* Bits(7:7), null */
      M_UINT32 DG_FACTOR_GR : 7;   /* Bits(14:8), null */
      M_UINT32 RESERVED1    : 1;   /* Bits(15:15), null */
      M_UINT32 RSVD0        : 16;  /* Bits(31:16), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_GAIN_DIG_G_TYPE;


/**************************************************************************
* Register name : SENSOR_GAIN_DIG_RB
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 DG_FACTOR_B            : 7;   /* Bits(6:0), null */
      M_UINT32 RESERVED0              : 1;   /* Bits(7:7), null */
      M_UINT32 DG_FACTOR_R            : 7;   /* Bits(14:8), null */
      M_UINT32 RESERVED1              : 1;   /* Bits(15:15), null */
      M_UINT32 RSVD0                  : 16;  /* Bits(31:16), Reserved */
      M_UINT32 RSVD_REGISTER_SPACE[3] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_GAIN_DIG_RB_TYPE;


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
      M_UINT32 SENSOR_FPS : 16;  /* Bits(15:0), SENSOR Frame Per Second */
      M_UINT32 RSVD0      : 16;  /* Bits(31:16), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_FPS_TYPE;


/**************************************************************************
* Register name : SENSOR_FPS2
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 SENSOR_FPS              : 20;  /* Bits(19:0), SENSOR Frame Per Second */
      M_UINT32 RSVD0                   : 12;  /* Bits(31:20), Reserved */
      M_UINT32 RSVD_REGISTER_SPACE[42] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_FPS2_TYPE;


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
      M_UINT32 RSVD_REGISTER_SPACE[1] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_DEBUG_CNTR1_TYPE;


/**************************************************************************
* Register name : DEBUG_CNTR2
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 EOF_CNTR : 32;  /* Bits(31:0), null */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_DEBUG_CNTR2_TYPE;


/**************************************************************************
* Register name : DEBUG_CNTR3
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 TRIG_INT_CNTR : 32;  /* Bits(31:0), null */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_DEBUG_CNTR3_TYPE;


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
      M_UINT32 EXP_FOT_TIME           : 16;  /* Bits(15:0), EXPosure during FOT TIME */
      M_UINT32 EXP_FOT                : 1;   /* Bits(16:16), EXPosure during FOT */
      M_UINT32 RSVD0                  : 15;  /* Bits(31:17), Reserved */
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
* Register name : TIMER_CTRL
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 TIMERSTART : 1;   /* Bits(0:0), null */
      M_UINT32 RSVD0      : 3;   /* Bits(3:1), Reserved */
      M_UINT32 TIMERSTOP  : 1;   /* Bits(4:4), null */
      M_UINT32 RSVD1      : 3;   /* Bits(7:5), Reserved */
      M_UINT32 ADAPTATIVE : 1;   /* Bits(8:8), null */
      M_UINT32 RSVD2      : 23;  /* Bits(31:9), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_ACQ_TIMER_CTRL_TYPE;


/**************************************************************************
* Register name : TIMER_DELAY
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

} FPGA_REGFILE_XGS_ATHENA_ACQ_TIMER_DELAY_TYPE;


/**************************************************************************
* Register name : TIMER_DURATION
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

} FPGA_REGFILE_XGS_ATHENA_ACQ_TIMER_DURATION_TYPE;


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
      M_UINT32 ENABLE_HISPI      : 1;   /* Bits(0:0), null */
      M_UINT32 ENABLE_DATA_PATH  : 1;   /* Bits(1:1), null */
      M_UINT32 SW_CALIB_SERDES   : 1;   /* Bits(2:2), Initiate the SERDES TAP calibrartion */
      M_UINT32 SW_CLR_HISPI      : 1;   /* Bits(3:3), null */
      M_UINT32 SW_CLR_IDELAYCTRL : 1;   /* Bits(4:4), Reset the Xilinx macro IDELAYCTRL */
      M_UINT32 RSVD0             : 27;  /* Bits(31:5), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_HISPI_CTRL_TYPE;


/**************************************************************************
* Register name : STATUS
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 CALIBRATION_DONE     : 1;   /* Bits(0:0), Calibration sequence completed */
      M_UINT32 CALIBRATION_ERROR    : 1;   /* Bits(1:1), Calibration error */
      M_UINT32 FIFO_ERROR           : 1;   /* Bits(2:2), Calibration active */
      M_UINT32 PHY_BIT_LOCKED_ERROR : 1;   /* Bits(3:3), null */
      M_UINT32 CRC_ERROR            : 1;   /* Bits(4:4), Lane CRC error */
      M_UINT32 RSVD0                : 23;  /* Bits(27:5), Reserved */
      M_UINT32 FSM                  : 4;   /* Bits(31:28), HISPI  finite state machine status */
   } f;

} FPGA_REGFILE_XGS_ATHENA_HISPI_STATUS_TYPE;


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
* Register name : IDLE_CHARACTER
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 VALUE : 12;  /* Bits(11:0), null */
      M_UINT32 RSVD0 : 20;  /* Bits(31:12), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_HISPI_IDLE_CHARACTER_TYPE;


/**************************************************************************
* Register name : PHY
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 NB_LANES       : 3;   /* Bits(2:0), Number of physical lane enabled */
      M_UINT32 RSVD0          : 5;   /* Bits(7:3), Reserved */
      M_UINT32 MUX_RATIO      : 3;   /* Bits(10:8), null */
      M_UINT32 RSVD1          : 5;   /* Bits(15:11), Reserved */
      M_UINT32 PIXEL_PER_LANE : 10;  /* Bits(25:16), Number of pixels per lanes */
      M_UINT32 RSVD2          : 6;   /* Bits(31:26), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_HISPI_PHY_TYPE;


/**************************************************************************
* Register name : FRAME_CFG
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 PIXELS_PER_LINE : 13;  /* Bits(12:0), null */
      M_UINT32 RSVD0           : 3;   /* Bits(15:13), Reserved */
      M_UINT32 LINES_PER_FRAME : 12;  /* Bits(27:16), null */
      M_UINT32 RSVD1           : 4;   /* Bits(31:28), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_HISPI_FRAME_CFG_TYPE;


/**************************************************************************
* Register name : FRAME_CFG_X_VALID
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 X_START                : 13;  /* Bits(12:0), null */
      M_UINT32 RSVD0                  : 3;   /* Bits(15:13), Reserved */
      M_UINT32 X_END                  : 13;  /* Bits(28:16), null */
      M_UINT32 RSVD1                  : 3;   /* Bits(31:29), Reserved */
      M_UINT32 RSVD_REGISTER_SPACE[2] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_HISPI_FRAME_CFG_X_VALID_TYPE;


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
      M_UINT32 FIFO_OVERRUN          : 1;   /* Bits(0:0), null */
      M_UINT32 FIFO_UNDERRUN         : 1;   /* Bits(1:1), null */
      M_UINT32 CALIBRATION_DONE      : 1;   /* Bits(2:2), null */
      M_UINT32 CALIBRATION_ERROR     : 1;   /* Bits(3:3), null */
      M_UINT32 CALIBRATION_TAP_VALUE : 5;   /* Bits(8:4), null */
      M_UINT32 RSVD0                 : 3;   /* Bits(11:9), Reserved */
      M_UINT32 PHY_BIT_LOCKED        : 1;   /* Bits(12:12), null */
      M_UINT32 PHY_BIT_LOCKED_ERROR  : 1;   /* Bits(13:13), null */
      M_UINT32 PHY_SYNC_ERROR        : 1;   /* Bits(14:14), null */
      M_UINT32 CRC_ERROR             : 1;   /* Bits(15:15), CRC Error */
      M_UINT32 RSVD1                 : 16;  /* Bits(31:16), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_HISPI_LANE_DECODER_STATUS_TYPE;


/**************************************************************************
* Register name : TAP_HISTOGRAM
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

} FPGA_REGFILE_XGS_ATHENA_HISPI_TAP_HISTOGRAM_TYPE;


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
      M_UINT32 TAP_LANE_0      : 5;  /* Bits(4:0), null */
      M_UINT32 TAP_LANE_1      : 5;  /* Bits(9:5), null */
      M_UINT32 TAP_LANE_2      : 5;  /* Bits(14:10), null */
      M_UINT32 TAP_LANE_3      : 5;  /* Bits(19:15), null */
      M_UINT32 TAP_LANE_4      : 5;  /* Bits(24:20), null */
      M_UINT32 TAP_LANE_5      : 5;  /* Bits(29:25), null */
      M_UINT32 LOAD_TAPS       : 1;  /* Bits(30:30), null */
      M_UINT32 MANUAL_CALIB_EN : 1;  /* Bits(31:31), null */
   } f;

} FPGA_REGFILE_XGS_ATHENA_HISPI_DEBUG_TYPE;


/**************************************************************************
* Register name : DPC_CAPABILITIES
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 DPC_VER         : 4;   /* Bits(3:0), null */
      M_UINT32 RSVD0           : 12;  /* Bits(15:4), Reserved */
      M_UINT32 DPC_LIST_LENGTH : 12;  /* Bits(27:16), null */
      M_UINT32 RSVD1           : 4;   /* Bits(31:28), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DPC_DPC_CAPABILITIES_TYPE;


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
      M_UINT32 DPC_LIST_ADD           : 12;  /* Bits(11:0), null */
      M_UINT32 DPC_LIST_SS            : 1;   /* Bits(12:12), null */
      M_UINT32 DPC_LIST_WRN           : 1;   /* Bits(13:13), null */
      M_UINT32 DPC_ENABLE             : 1;   /* Bits(14:14), null */
      M_UINT32 DPC_PATTERN0_CFG       : 1;   /* Bits(15:15), null */
      M_UINT32 DPC_LIST_COUNT         : 12;  /* Bits(27:16), null */
      M_UINT32 DPC_FIRSTLAST_LINE_REM : 1;   /* Bits(28:28), null */
      M_UINT32 DPC_FIFO_RESET         : 1;   /* Bits(29:29), null */
      M_UINT32 RSVD0                  : 1;   /* Bits(30:30), Reserved */
      M_UINT32 DPC_HIGHLIGHT_ALL      : 1;   /* Bits(31:31), null */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DPC_DPC_LIST_CTRL_TYPE;


/**************************************************************************
* Register name : DPC_LIST_STAT
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 RSVD0             : 30;  /* Bits(29:0), Reserved */
      M_UINT32 DPC_FIFO_OVERRUN  : 1;   /* Bits(30:30), null */
      M_UINT32 DPC_FIFO_UNDERRUN : 1;   /* Bits(31:31), null */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DPC_DPC_LIST_STAT_TYPE;


/**************************************************************************
* Register name : DPC_LIST_DATA1
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 DPC_LIST_CORR_X : 13;  /* Bits(12:0), null */
      M_UINT32 RSVD0           : 3;   /* Bits(15:13), Reserved */
      M_UINT32 DPC_LIST_CORR_Y : 12;  /* Bits(27:16), null */
      M_UINT32 RSVD1           : 4;   /* Bits(31:28), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DPC_DPC_LIST_DATA1_TYPE;


/**************************************************************************
* Register name : DPC_LIST_DATA2
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 DPC_LIST_CORR_PATTERN : 8;   /* Bits(7:0), null */
      M_UINT32 RSVD0                 : 24;  /* Bits(31:8), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DPC_DPC_LIST_DATA2_TYPE;


/**************************************************************************
* Register name : DPC_LIST_DATA1_RD
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 DPC_LIST_CORR_X : 13;  /* Bits(12:0), null */
      M_UINT32 RSVD0           : 3;   /* Bits(15:13), Reserved */
      M_UINT32 DPC_LIST_CORR_Y : 12;  /* Bits(27:16), null */
      M_UINT32 RSVD1           : 4;   /* Bits(31:28), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DPC_DPC_LIST_DATA1_RD_TYPE;


/**************************************************************************
* Register name : DPC_LIST_DATA2_RD
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 DPC_LIST_CORR_PATTERN : 8;   /* Bits(7:0), null */
      M_UINT32 RSVD0                 : 24;  /* Bits(31:8), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_DPC_DPC_LIST_DATA2_RD_TYPE;


/**************************************************************************
* Register name : LUT_CAPABILITIES
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 LUT_VER         : 4;   /* Bits(3:0), null */
      M_UINT32 RSVD0           : 12;  /* Bits(15:4), Reserved */
      M_UINT32 LUT_SIZE_CONFIG : 12;  /* Bits(27:16), null */
      M_UINT32 RSVD1           : 4;   /* Bits(31:28), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_LUT_LUT_CAPABILITIES_TYPE;


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
      M_UINT32 LUT_ADD          : 10;  /* Bits(9:0), null */
      M_UINT32 LUT_SS           : 1;   /* Bits(10:10), LUT SnapShot */
      M_UINT32 LUT_WRN          : 1;   /* Bits(11:11), LUT Write ReadNot */
      M_UINT32 LUT_SEL          : 4;   /* Bits(15:12), LUT SELection */
      M_UINT32 LUT_DATA_W       : 10;  /* Bits(25:16), LUT DATA to Write */
      M_UINT32 RSVD0            : 2;   /* Bits(27:26), Reserved */
      M_UINT32 LUT_BYPASS       : 1;   /* Bits(28:28), LUT BYPASS */
      M_UINT32 LUT_BYPASS_COLOR : 1;   /* Bits(29:29), LUT BYPASS COLOR */
      M_UINT32 RSVD1            : 2;   /* Bits(31:30), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_LUT_LUT_CTRL_TYPE;


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
      M_UINT32 LUT_RB : 8;   /* Bits(7:0), null */
      M_UINT32 RSVD0  : 24;  /* Bits(31:8), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_LUT_LUT_RB_TYPE;


/**************************************************************************
* Register name : BAYER_CAPABILITIES
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 BAYER_VER : 2;   /* Bits(1:0), null */
      M_UINT32 RSVD0     : 30;  /* Bits(31:2), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_BAYER_BAYER_CAPABILITIES_TYPE;


/**************************************************************************
* Register name : WB_MUL1
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 WB_MULT_B : 16;  /* Bits(15:0), null */
      M_UINT32 WB_MULT_G : 16;  /* Bits(31:16), null */
   } f;

} FPGA_REGFILE_XGS_ATHENA_BAYER_WB_MUL1_TYPE;


/**************************************************************************
* Register name : WB_MUL2
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 WB_MULT_R : 16;  /* Bits(15:0), null */
      M_UINT32 RSVD0     : 16;  /* Bits(31:16), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_BAYER_WB_MUL2_TYPE;


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
      M_UINT32 B_ACC : 31;  /* Bits(30:0), null */
      M_UINT32 RSVD0 : 1;   /* Bits(31:31), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_BAYER_WB_B_ACC_TYPE;


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
      M_UINT32 G_ACC : 32;  /* Bits(31:0), null */
   } f;

} FPGA_REGFILE_XGS_ATHENA_BAYER_WB_G_ACC_TYPE;


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
      M_UINT32 R_ACC : 31;  /* Bits(30:0), null */
      M_UINT32 RSVD0 : 1;   /* Bits(31:31), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_BAYER_WB_R_ACC_TYPE;


/**************************************************************************
* Register name : CCM_CTRL
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 CCM_EN : 1;   /* Bits(0:0), null */
      M_UINT32 RSVD0  : 31;  /* Bits(31:1), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_BAYER_CCM_CTRL_TYPE;


/**************************************************************************
* Register name : CCM_KR1
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 KR    : 12;  /* Bits(11:0), null */
      M_UINT32 RSVD0 : 4;   /* Bits(15:12), Reserved */
      M_UINT32 KG    : 12;  /* Bits(27:16), null */
      M_UINT32 RSVD1 : 4;   /* Bits(31:28), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_BAYER_CCM_KR1_TYPE;


/**************************************************************************
* Register name : CCM_KR2
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 KB    : 12;  /* Bits(11:0), null */
      M_UINT32 RSVD0 : 4;   /* Bits(15:12), Reserved */
      M_UINT32 KOFF  : 9;   /* Bits(24:16), null */
      M_UINT32 RSVD1 : 7;   /* Bits(31:25), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_BAYER_CCM_KR2_TYPE;


/**************************************************************************
* Register name : CCM_KG1
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 KR    : 12;  /* Bits(11:0), null */
      M_UINT32 RSVD0 : 4;   /* Bits(15:12), Reserved */
      M_UINT32 KG    : 12;  /* Bits(27:16), null */
      M_UINT32 RSVD1 : 4;   /* Bits(31:28), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_BAYER_CCM_KG1_TYPE;


/**************************************************************************
* Register name : CCM_KG2
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 KB    : 12;  /* Bits(11:0), null */
      M_UINT32 RSVD0 : 4;   /* Bits(15:12), Reserved */
      M_UINT32 KOFF  : 9;   /* Bits(24:16), null */
      M_UINT32 RSVD1 : 7;   /* Bits(31:25), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_BAYER_CCM_KG2_TYPE;


/**************************************************************************
* Register name : CCM_KB1
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 KR    : 12;  /* Bits(11:0), null */
      M_UINT32 RSVD0 : 4;   /* Bits(15:12), Reserved */
      M_UINT32 KG    : 12;  /* Bits(27:16), null */
      M_UINT32 RSVD1 : 4;   /* Bits(31:28), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_BAYER_CCM_KB1_TYPE;


/**************************************************************************
* Register name : CCM_KB2
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 KB    : 12;  /* Bits(11:0), null */
      M_UINT32 RSVD0 : 4;   /* Bits(15:12), Reserved */
      M_UINT32 KOFF  : 9;   /* Bits(24:16), null */
      M_UINT32 RSVD1 : 7;   /* Bits(31:25), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_BAYER_CCM_KB2_TYPE;


/**************************************************************************
* Register name : TEMP
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 RSVD0  : 4;   /* Bits(3:0), Reserved */
      M_UINT32 SMTEMP : 12;  /* Bits(15:4), System Monitor TEMPerature */
      M_UINT32 RSVD1  : 16;  /* Bits(31:16), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_SYSMONXIL_TEMP_TYPE;


/**************************************************************************
* Register name : VCCINT
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 RSVD0  : 4;   /* Bits(3:0), Reserved */
      M_UINT32 SMVINT : 12;  /* Bits(15:4), System Monitor VCCINT */
      M_UINT32 RSVD1  : 16;  /* Bits(31:16), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_SYSMONXIL_VCCINT_TYPE;


/**************************************************************************
* Register name : VCCAUX
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 RSVD0                  : 4;   /* Bits(3:0), Reserved */
      M_UINT32 SMVAUX                 : 12;  /* Bits(15:4), System Monitor VCCAUX */
      M_UINT32 RSVD1                  : 16;  /* Bits(31:16), Reserved */
      M_UINT32 RSVD_REGISTER_SPACE[3] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_SYSMONXIL_VCCAUX_TYPE;


/**************************************************************************
* Register name : VCCBRAM
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 RSVD0                   : 4;   /* Bits(3:0), Reserved */
      M_UINT32 SMVBRAM                 : 12;  /* Bits(15:4), System Monitor VCCBRAM */
      M_UINT32 RSVD1                   : 16;  /* Bits(31:16), Reserved */
      M_UINT32 RSVD_REGISTER_SPACE[25] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_SYSMONXIL_VCCBRAM_TYPE;


/**************************************************************************
* Register name : TEMP_MAX
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 RSVD0                  : 4;   /* Bits(3:0), Reserved */
      M_UINT32 SMTMAX                 : 12;  /* Bits(15:4), System Monitor Temperature MAXimum */
      M_UINT32 RSVD1                  : 16;  /* Bits(31:16), Reserved */
      M_UINT32 RSVD_REGISTER_SPACE[3] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_XGS_ATHENA_SYSMONXIL_TEMP_MAX_TYPE;


/**************************************************************************
* Register name : TEMP_MIN
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 RSVD0  : 4;   /* Bits(3:0), Reserved */
      M_UINT32 SMTMIN : 12;  /* Bits(15:4), System Monitor Temperature MINimum */
      M_UINT32 RSVD1  : 16;  /* Bits(31:16), Reserved */
   } f;

} FPGA_REGFILE_XGS_ATHENA_SYSMONXIL_TEMP_MIN_TYPE;


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
   FPGA_REGFILE_XGS_ATHENA_DMA_OUTPUT_BUFFER_TYPE OUTPUT_BUFFER;  /* Address offset: 0x38 */
   FPGA_REGFILE_XGS_ATHENA_DMA_TLP_TYPE           TLP;            /* Address offset: 0x3c */
   FPGA_REGFILE_XGS_ATHENA_DMA_ROI_X_TYPE         ROI_X;          /* Address offset: 0x40 */
   FPGA_REGFILE_XGS_ATHENA_DMA_ROI_Y_TYPE         ROI_Y;          /* Address offset: 0x4c */
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
   FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_M_LINES_TYPE         SENSOR_M_LINES;          /* Address offset: 0xb8 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_DP_GR_TYPE           SENSOR_DP_GR;            /* Address offset: 0xbc */
   FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_DP_GB_TYPE           SENSOR_DP_GB;            /* Address offset: 0xc0 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_DP_R_TYPE            SENSOR_DP_R;             /* Address offset: 0xc4 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_DP_B_TYPE            SENSOR_DP_B;             /* Address offset: 0xc8 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_GAIN_DIG_G_TYPE      SENSOR_GAIN_DIG_G;       /* Address offset: 0xcc */
   FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_GAIN_DIG_RB_TYPE     SENSOR_GAIN_DIG_RB;      /* Address offset: 0xd0 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_DEBUG_PINS_TYPE             DEBUG_PINS;              /* Address offset: 0xe0 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_TRIGGER_MISSED_TYPE         TRIGGER_MISSED;          /* Address offset: 0xe8 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_FPS_TYPE             SENSOR_FPS;              /* Address offset: 0xf0 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_SENSOR_FPS2_TYPE            SENSOR_FPS2;             /* Address offset: 0xf4 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_DEBUG_TYPE                  DEBUG;                   /* Address offset: 0x1a0 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_DEBUG_CNTR1_TYPE            DEBUG_CNTR1;             /* Address offset: 0x1a8 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_DEBUG_CNTR2_TYPE            DEBUG_CNTR2;             /* Address offset: 0x1b0 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_DEBUG_CNTR3_TYPE            DEBUG_CNTR3;             /* Address offset: 0x1b4 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_EXP_FOT_TYPE                EXP_FOT;                 /* Address offset: 0x1b8 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_ACQ_SFNC_TYPE               ACQ_SFNC;                /* Address offset: 0x1c0 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_TIMER_CTRL_TYPE             TIMER_CTRL;              /* Address offset: 0x1d0 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_TIMER_DELAY_TYPE            TIMER_DELAY;             /* Address offset: 0x1d4 */
   FPGA_REGFILE_XGS_ATHENA_ACQ_TIMER_DURATION_TYPE         TIMER_DURATION;          /* Address offset: 0x1d8 */
} FPGA_REGFILE_XGS_ATHENA_ACQ_TYPE;

/**************************************************************************
* Section name   : HISPI
***************************************************************************/
typedef struct
{
   FPGA_REGFILE_XGS_ATHENA_HISPI_CTRL_TYPE                CTRL;                    /* Address offset: 0x0 */
   FPGA_REGFILE_XGS_ATHENA_HISPI_STATUS_TYPE              STATUS;                  /* Address offset: 0x4 */
   FPGA_REGFILE_XGS_ATHENA_HISPI_IDELAYCTRL_STATUS_TYPE   IDELAYCTRL_STATUS;       /* Address offset: 0x8 */
   FPGA_REGFILE_XGS_ATHENA_HISPI_IDLE_CHARACTER_TYPE      IDLE_CHARACTER;          /* Address offset: 0xc */
   FPGA_REGFILE_XGS_ATHENA_HISPI_PHY_TYPE                 PHY;                     /* Address offset: 0x10 */
   FPGA_REGFILE_XGS_ATHENA_HISPI_FRAME_CFG_TYPE           FRAME_CFG;               /* Address offset: 0x14 */
   FPGA_REGFILE_XGS_ATHENA_HISPI_FRAME_CFG_X_VALID_TYPE   FRAME_CFG_X_VALID;       /* Address offset: 0x18 */
   FPGA_REGFILE_XGS_ATHENA_HISPI_LANE_DECODER_STATUS_TYPE LANE_DECODER_STATUS[6];  /* Address offset: 0x24 */
   FPGA_REGFILE_XGS_ATHENA_HISPI_TAP_HISTOGRAM_TYPE       TAP_HISTOGRAM[6];        /* Address offset: 0x3c */
   FPGA_REGFILE_XGS_ATHENA_HISPI_DEBUG_TYPE               DEBUG;                   /* Address offset: 0x54 */
} FPGA_REGFILE_XGS_ATHENA_HISPI_TYPE;

/**************************************************************************
* Section name   : DPC
***************************************************************************/
typedef struct
{
   FPGA_REGFILE_XGS_ATHENA_DPC_DPC_CAPABILITIES_TYPE  DPC_CAPABILITIES;   /* Address offset: 0x0 */
   FPGA_REGFILE_XGS_ATHENA_DPC_DPC_LIST_CTRL_TYPE     DPC_LIST_CTRL;      /* Address offset: 0x4 */
   FPGA_REGFILE_XGS_ATHENA_DPC_DPC_LIST_STAT_TYPE     DPC_LIST_STAT;      /* Address offset: 0x8 */
   FPGA_REGFILE_XGS_ATHENA_DPC_DPC_LIST_DATA1_TYPE    DPC_LIST_DATA1;     /* Address offset: 0xc */
   FPGA_REGFILE_XGS_ATHENA_DPC_DPC_LIST_DATA2_TYPE    DPC_LIST_DATA2;     /* Address offset: 0x10 */
   FPGA_REGFILE_XGS_ATHENA_DPC_DPC_LIST_DATA1_RD_TYPE DPC_LIST_DATA1_RD;  /* Address offset: 0x14 */
   FPGA_REGFILE_XGS_ATHENA_DPC_DPC_LIST_DATA2_RD_TYPE DPC_LIST_DATA2_RD;  /* Address offset: 0x18 */
} FPGA_REGFILE_XGS_ATHENA_DPC_TYPE;

/**************************************************************************
* Section name   : LUT
***************************************************************************/
typedef struct
{
   FPGA_REGFILE_XGS_ATHENA_LUT_LUT_CAPABILITIES_TYPE LUT_CAPABILITIES;  /* Address offset: 0x0 */
   FPGA_REGFILE_XGS_ATHENA_LUT_LUT_CTRL_TYPE         LUT_CTRL;          /* Address offset: 0x4 */
   FPGA_REGFILE_XGS_ATHENA_LUT_LUT_RB_TYPE           LUT_RB;            /* Address offset: 0x8 */
} FPGA_REGFILE_XGS_ATHENA_LUT_TYPE;

/**************************************************************************
* Section name   : BAYER
***************************************************************************/
typedef struct
{
   FPGA_REGFILE_XGS_ATHENA_BAYER_BAYER_CAPABILITIES_TYPE BAYER_CAPABILITIES;  /* Address offset: 0x0 */
   FPGA_REGFILE_XGS_ATHENA_BAYER_WB_MUL1_TYPE            WB_MUL1;             /* Address offset: 0x4 */
   FPGA_REGFILE_XGS_ATHENA_BAYER_WB_MUL2_TYPE            WB_MUL2;             /* Address offset: 0x8 */
   FPGA_REGFILE_XGS_ATHENA_BAYER_WB_B_ACC_TYPE           WB_B_ACC;            /* Address offset: 0xc */
   FPGA_REGFILE_XGS_ATHENA_BAYER_WB_G_ACC_TYPE           WB_G_ACC;            /* Address offset: 0x10 */
   FPGA_REGFILE_XGS_ATHENA_BAYER_WB_R_ACC_TYPE           WB_R_ACC;            /* Address offset: 0x14 */
   FPGA_REGFILE_XGS_ATHENA_BAYER_CCM_CTRL_TYPE           CCM_CTRL;            /* Address offset: 0x18 */
   FPGA_REGFILE_XGS_ATHENA_BAYER_CCM_KR1_TYPE            CCM_KR1;             /* Address offset: 0x1c */
   FPGA_REGFILE_XGS_ATHENA_BAYER_CCM_KR2_TYPE            CCM_KR2;             /* Address offset: 0x20 */
   FPGA_REGFILE_XGS_ATHENA_BAYER_CCM_KG1_TYPE            CCM_KG1;             /* Address offset: 0x24 */
   FPGA_REGFILE_XGS_ATHENA_BAYER_CCM_KG2_TYPE            CCM_KG2;             /* Address offset: 0x28 */
   FPGA_REGFILE_XGS_ATHENA_BAYER_CCM_KB1_TYPE            CCM_KB1;             /* Address offset: 0x2c */
   FPGA_REGFILE_XGS_ATHENA_BAYER_CCM_KB2_TYPE            CCM_KB2;             /* Address offset: 0x30 */
} FPGA_REGFILE_XGS_ATHENA_BAYER_TYPE;

/**************************************************************************
* External section name   : SYSMONXIL
***************************************************************************/
typedef struct
{
   FPGA_REGFILE_XGS_ATHENA_SYSMONXIL_TEMP_TYPE     TEMP;      /* Address offset: 0x0 */
   FPGA_REGFILE_XGS_ATHENA_SYSMONXIL_VCCINT_TYPE   VCCINT;    /* Address offset: 0x4 */
   FPGA_REGFILE_XGS_ATHENA_SYSMONXIL_VCCAUX_TYPE   VCCAUX;    /* Address offset: 0x8 */
   FPGA_REGFILE_XGS_ATHENA_SYSMONXIL_VCCBRAM_TYPE  VCCBRAM;   /* Address offset: 0x18 */
   FPGA_REGFILE_XGS_ATHENA_SYSMONXIL_TEMP_MAX_TYPE TEMP_MAX;  /* Address offset: 0x80 */
   FPGA_REGFILE_XGS_ATHENA_SYSMONXIL_TEMP_MIN_TYPE TEMP_MIN;  /* Address offset: 0x90 */
   M_UINT32                                        RSVD[27];  /* Reserved space (27 x M_UINT32) */
} FPGA_REGFILE_XGS_ATHENA_SYSMONXIL_TYPE;


/**************************************************************************
* Register file name : REGFILE_XGS_ATHENA
***************************************************************************/
typedef struct
{
   FPGA_REGFILE_XGS_ATHENA_SYSTEM_TYPE    SYSTEM;      /* Section; Base address offset: 0x0 */
   M_UINT32                               RSVD0[24];   /* Padding; Size (96 Bytes) */
   FPGA_REGFILE_XGS_ATHENA_DMA_TYPE       DMA;         /* Section; Base address offset: 0x70 */
   M_UINT32                               RSVD1[14];   /* Padding; Size (56 Bytes) */
   FPGA_REGFILE_XGS_ATHENA_ACQ_TYPE       ACQ;         /* Section; Base address offset: 0x100 */
   M_UINT32                               RSVD2[73];   /* Padding; Size (292 Bytes) */
   FPGA_REGFILE_XGS_ATHENA_HISPI_TYPE     HISPI;       /* Section; Base address offset: 0x400 */
   M_UINT32                               RSVD3[10];   /* Padding; Size (40 Bytes) */
   FPGA_REGFILE_XGS_ATHENA_DPC_TYPE       DPC;         /* Section; Base address offset: 0x480 */
   M_UINT32                               RSVD4[5];    /* Padding; Size (20 Bytes) */
   FPGA_REGFILE_XGS_ATHENA_LUT_TYPE       LUT;         /* Section; Base address offset: 0x4b0 */
   M_UINT32                               RSVD5[1];    /* Padding; Size (4 Bytes) */
   FPGA_REGFILE_XGS_ATHENA_BAYER_TYPE     BAYER;       /* Section; Base address offset: 0x4c0 */
   M_UINT32                               RSVD6[131];  /* Padding; Size (524 Bytes) */
   FPGA_REGFILE_XGS_ATHENA_SYSMONXIL_TYPE SYSMONXIL;   /* External section; Base address offset: 0x700 */
} FPGA_REGFILE_XGS_ATHENA_TYPE;



#endif
