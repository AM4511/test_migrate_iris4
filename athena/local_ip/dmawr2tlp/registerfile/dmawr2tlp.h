/**************************************************************************
*
* File name    :  dma2tlp.h
* Created by   : imaval
*
* Content      :  This file contains the register structures for the
*                 fpga dma2tlp processing unit.
*
* Hardware native endianness: little endian
*
* FDK IDE Version     : 4.7.0_beta4
* Build ID            : I20191220-1537
* Register file CRC32 : 0x1D520EF7
*
* COPYRIGHT (c) 2020 Matrox Electronic Systems Ltd.
* All Rights Reserved
*
***************************************************************************/
#ifndef __FPGA_DMA2TLP_H__
#define __FPGA_DMA2TLP_H__

#include "mbasictypes.h"





/**************************************************************************
* Register address defines
***************************************************************************/
#define FPGA_DMA2TLP_INFO_TAG_ADDRESS            0x00
#define FPGA_DMA2TLP_INFO_FID_ADDRESS            0x04
#define FPGA_DMA2TLP_INFO_VERSION_ADDRESS        0x08
#define FPGA_DMA2TLP_INFO_CAPABILITY_ADDRESS     0x0C
#define FPGA_DMA2TLP_INFO_SCRATCHPAD_ADDRESS     0x10
#define FPGA_DMA2TLP_DMA_CTRL_ADDRESS            0x40
#define FPGA_DMA2TLP_DMA_STATUS_ADDRESS          0x4C
#define FPGA_DMA2TLP_DMA_FRAME_START_ADDRESS     0x50
#define FPGA_DMA2TLP_DMA_FRAME_START_G_ADDRESS   0x58
#define FPGA_DMA2TLP_DMA_FRAME_START_R_ADDRESS   0x60
#define FPGA_DMA2TLP_DMA_LINE_SIZE_ADDRESS       0x68
#define FPGA_DMA2TLP_DMA_LINE_PITCH_ADDRESS      0x6C
#define FPGA_DMA2TLP_DMA_CSC_ADDRESS             0x70
#define FPGA_DMA2TLP_STATUS_DEBUG_ADDRESS        0xC0

/**************************************************************************
* Register name : tag
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 value : 24;  /* Bits(23:0), Tag identifier */
      M_UINT32 rsvd0 : 8;   /* Bits(31:24), Reserved */
   } f;

} FPGA_DMA2TLP_INFO_TAG_TYPE;


/**************************************************************************
* Register name : fid
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 value : 32;  /* Bits(31:0), null */
   } f;

} FPGA_DMA2TLP_INFO_FID_TYPE;


/**************************************************************************
* Register name : version
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 hw    : 8;  /* Bits(7:0), null */
      M_UINT32 minor : 8;  /* Bits(15:8), null */
      M_UINT32 major : 8;  /* Bits(23:16), null */
      M_UINT32 rsvd0 : 8;  /* Bits(31:24), Reserved */
   } f;

} FPGA_DMA2TLP_INFO_VERSION_TYPE;


/**************************************************************************
* Register name : capability
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 value : 8;   /* Bits(7:0), null */
      M_UINT32 rsvd0 : 24;  /* Bits(31:8), Reserved */
   } f;

} FPGA_DMA2TLP_INFO_CAPABILITY_TYPE;


/**************************************************************************
* Register name : scratchpad
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 value : 32;  /* Bits(31:0), null */
   } f;

} FPGA_DMA2TLP_INFO_SCRATCHPAD_TYPE;


/**************************************************************************
* Register name : ctrl
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 enable                 : 1;   /* Bits(0:0), Enable the DMA engine */
      M_UINT32 grab_queue_enable      : 1;   /* Bits(1:1), Grab queue enable */
      M_UINT32 rsvd0                  : 30;  /* Bits(31:2), Reserved */
      M_UINT32 rsvd_register_space[2] ;      /* Reserved space below */
   } f;

} FPGA_DMA2TLP_DMA_CTRL_TYPE;


/**************************************************************************
* Register name : status
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 busy  : 1;   /* Bits(0:0), null */
      M_UINT32 rsvd0 : 31;  /* Bits(31:1), Reserved */
   } f;

} FPGA_DMA2TLP_DMA_STATUS_TYPE;


/**************************************************************************
* Register name : frame_start
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 value : 32;  /* Bits(31:0), INitial GRAb ADDRess Register */
   } f;

} FPGA_DMA2TLP_DMA_FRAME_START_TYPE;


/**************************************************************************
* Register name : frame_start_g
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 value : 32;  /* Bits(31:0), GRAb ADDRess Register */
   } f;

} FPGA_DMA2TLP_DMA_FRAME_START_G_TYPE;


/**************************************************************************
* Register name : frame_start_r
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 value : 32;  /* Bits(31:0), GRAb ADDRess Register */
   } f;

} FPGA_DMA2TLP_DMA_FRAME_START_R_TYPE;


/**************************************************************************
* Register name : line_size
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 value : 14;  /* Bits(13:0), Host Line size */
      M_UINT32 rsvd0 : 18;  /* Bits(31:14), Reserved */
   } f;

} FPGA_DMA2TLP_DMA_LINE_SIZE_TYPE;


/**************************************************************************
* Register name : line_pitch
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 value : 16;  /* Bits(15:0), Grab LinePitch */
      M_UINT32 rsvd0 : 16;  /* Bits(31:16), Reserved */
   } f;

} FPGA_DMA2TLP_DMA_LINE_PITCH_TYPE;


/**************************************************************************
* Register name : csc
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0                  : 8;   /* Bits(7:0), Reserved */
      M_UINT32 reverse_x              : 1;   /* Bits(8:8), null */
      M_UINT32 reverse_y              : 1;   /* Bits(9:9), REVERSE Y */
      M_UINT32 rsvd1                  : 13;  /* Bits(22:10), Reserved */
      M_UINT32 duplicate_last_line    : 1;   /* Bits(23:23), null */
      M_UINT32 color_space            : 3;   /* Bits(26:24), null */
      M_UINT32 rsvd2                  : 5;   /* Bits(31:27), Reserved */
      M_UINT32 rsvd_register_space[3] ;      /* Reserved space below */
   } f;

} FPGA_DMA2TLP_DMA_CSC_TYPE;


/**************************************************************************
* Register name : debug
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 out_of_memory_stat  : 1;   /* Bits(0:0), null */
      M_UINT32 out_of_memory_clear : 1;   /* Bits(1:1), null */
      M_UINT32 grab_max_add        : 30;  /* Bits(31:2), null */
   } f;

} FPGA_DMA2TLP_STATUS_DEBUG_TYPE;


/**************************************************************************
* Section name   : info
***************************************************************************/
typedef struct
{
   FPGA_DMA2TLP_INFO_TAG_TYPE        tag;         /* Address offset: 0x0 */
   FPGA_DMA2TLP_INFO_FID_TYPE        fid;         /* Address offset: 0x4 */
   FPGA_DMA2TLP_INFO_VERSION_TYPE    version;     /* Address offset: 0x8 */
   FPGA_DMA2TLP_INFO_CAPABILITY_TYPE capability;  /* Address offset: 0xc */
   FPGA_DMA2TLP_INFO_SCRATCHPAD_TYPE scratchpad;  /* Address offset: 0x10 */
} FPGA_DMA2TLP_INFO_TYPE;

/**************************************************************************
* Section name   : dma
***************************************************************************/
typedef struct
{
   FPGA_DMA2TLP_DMA_CTRL_TYPE          ctrl;              /* Address offset: 0x0 */
   FPGA_DMA2TLP_DMA_STATUS_TYPE        status;            /* Address offset: 0xc */
   FPGA_DMA2TLP_DMA_FRAME_START_TYPE   frame_start[2];    /* Address offset: 0x10 */
   FPGA_DMA2TLP_DMA_FRAME_START_G_TYPE frame_start_g[2];  /* Address offset: 0x18 */
   FPGA_DMA2TLP_DMA_FRAME_START_R_TYPE frame_start_r[2];  /* Address offset: 0x20 */
   FPGA_DMA2TLP_DMA_LINE_SIZE_TYPE     line_size;         /* Address offset: 0x28 */
   FPGA_DMA2TLP_DMA_LINE_PITCH_TYPE    line_pitch;        /* Address offset: 0x2c */
   FPGA_DMA2TLP_DMA_CSC_TYPE           csc;               /* Address offset: 0x30 */
} FPGA_DMA2TLP_DMA_TYPE;

/**************************************************************************
* Section name   : status
***************************************************************************/
typedef struct
{
   FPGA_DMA2TLP_STATUS_DEBUG_TYPE debug;  /* Address offset: 0x0 */
} FPGA_DMA2TLP_STATUS_TYPE;

/**************************************************************************
* Register file name : dma2tlp
***************************************************************************/
typedef struct
{
   FPGA_DMA2TLP_INFO_TYPE   info;       /* Section; Base address offset: 0x0 */
   M_UINT32                 rsvd0[11];  /* Padding; Size (44 Bytes) */
   FPGA_DMA2TLP_DMA_TYPE    dma;        /* Section; Base address offset: 0x40 */
   M_UINT32                 rsvd1[16];  /* Padding; Size (64 Bytes) */
   FPGA_DMA2TLP_STATUS_TYPE status;     /* Section; Base address offset: 0xc0 */
} FPGA_DMA2TLP_TYPE;



#endif
