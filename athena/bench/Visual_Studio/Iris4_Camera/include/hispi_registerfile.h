/**************************************************************************
*
* File name    :  hispi_registerfile.h
* Created by   : imaval
*
* Content      :  This file contains the register structures for the
*                 fpga hispi_registerfile processing unit.
*
* Hardware native endianness: little endian
*
* FDK IDE Version     : 4.7.0_beta4
* Build ID            : I20191220-1537
* Register file CRC32 : 0x5C4A3DCB
*
* COPYRIGHT (c) 2020 Matrox Electronic Systems Ltd.
* All Rights Reserved
*
***************************************************************************/
#ifndef __FPGA_HISPI_REGISTERFILE_H__
#define __FPGA_HISPI_REGISTERFILE_H__

#include "mbasictypes.h"





/**************************************************************************
* Register address defines
***************************************************************************/
#define FPGA_HISPI_REGISTERFILE_INFO_TAG_ADDRESS                 0x00
#define FPGA_HISPI_REGISTERFILE_INFO_FID_ADDRESS                 0x04
#define FPGA_HISPI_REGISTERFILE_INFO_VERSION_ADDRESS             0x08
#define FPGA_HISPI_REGISTERFILE_INFO_CAPABILITY_ADDRESS          0x0C
#define FPGA_HISPI_REGISTERFILE_INFO_SCRATCHPAD_ADDRESS          0x10
#define FPGA_HISPI_REGISTERFILE_CORE_CTRL_ADDRESS                0x30
#define FPGA_HISPI_REGISTERFILE_CORE_PIXELS_PER_LINE_ADDRESS     0x34
#define FPGA_HISPI_REGISTERFILE_CORE_LINE_PER_FRAME_ADDRESS      0x38
#define FPGA_HISPI_REGISTERFILE_PHY_CTRL_ADDRESS                 0x40
#define FPGA_HISPI_REGISTERFILE_PHY_STATUS_ADDRESS               0x44

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

} FPGA_HISPI_REGISTERFILE_INFO_TAG_TYPE;


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

} FPGA_HISPI_REGISTERFILE_INFO_FID_TYPE;


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

} FPGA_HISPI_REGISTERFILE_INFO_VERSION_TYPE;


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

} FPGA_HISPI_REGISTERFILE_INFO_CAPABILITY_TYPE;


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

} FPGA_HISPI_REGISTERFILE_INFO_SCRATCHPAD_TYPE;


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
      M_UINT32 capture_enable : 1;   /* Bits(0:0), null */
      M_UINT32 reset          : 1;   /* Bits(1:1), null */
      M_UINT32 rsvd0          : 30;  /* Bits(31:2), Reserved */
   } f;

} FPGA_HISPI_REGISTERFILE_CORE_CTRL_TYPE;


/**************************************************************************
* Register name : pixels_per_line
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 value : 16;  /* Bits(15:0), null */
      M_UINT32 rsvd0 : 16;  /* Bits(31:16), Reserved */
   } f;

} FPGA_HISPI_REGISTERFILE_CORE_PIXELS_PER_LINE_TYPE;


/**************************************************************************
* Register name : line_per_frame
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 value : 16;  /* Bits(15:0), null */
      M_UINT32 rsvd0 : 16;  /* Bits(31:16), Reserved */
   } f;

} FPGA_HISPI_REGISTERFILE_CORE_LINE_PER_FRAME_TYPE;


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
      M_UINT32 reset_idelayctrl : 1;   /* Bits(0:0), Reset the xilinx macro IDELAYCTRL */
      M_UINT32 rsvd0            : 31;  /* Bits(31:1), Reserved */
   } f;

} FPGA_HISPI_REGISTERFILE_PHY_CTRL_TYPE;


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
      M_UINT32 pll_locked : 1;   /* Bits(0:0), null */
      M_UINT32 rsvd0      : 31;  /* Bits(31:1), Reserved */
   } f;

} FPGA_HISPI_REGISTERFILE_PHY_STATUS_TYPE;


/**************************************************************************
* Section name   : info
***************************************************************************/
typedef struct
{
   FPGA_HISPI_REGISTERFILE_INFO_TAG_TYPE        tag;         /* Address offset: 0x0 */
   FPGA_HISPI_REGISTERFILE_INFO_FID_TYPE        fid;         /* Address offset: 0x4 */
   FPGA_HISPI_REGISTERFILE_INFO_VERSION_TYPE    version;     /* Address offset: 0x8 */
   FPGA_HISPI_REGISTERFILE_INFO_CAPABILITY_TYPE capability;  /* Address offset: 0xc */
   FPGA_HISPI_REGISTERFILE_INFO_SCRATCHPAD_TYPE scratchpad;  /* Address offset: 0x10 */
} FPGA_HISPI_REGISTERFILE_INFO_TYPE;

/**************************************************************************
* Section name   : core
***************************************************************************/
typedef struct
{
   FPGA_HISPI_REGISTERFILE_CORE_CTRL_TYPE            ctrl;             /* Address offset: 0x0 */
   FPGA_HISPI_REGISTERFILE_CORE_PIXELS_PER_LINE_TYPE pixels_per_line;  /* Address offset: 0x4 */
   FPGA_HISPI_REGISTERFILE_CORE_LINE_PER_FRAME_TYPE  line_per_frame;   /* Address offset: 0x8 */
} FPGA_HISPI_REGISTERFILE_CORE_TYPE;

/**************************************************************************
* Section name   : phy
***************************************************************************/
typedef struct
{
   FPGA_HISPI_REGISTERFILE_PHY_CTRL_TYPE   ctrl;    /* Address offset: 0x0 */
   FPGA_HISPI_REGISTERFILE_PHY_STATUS_TYPE status;  /* Address offset: 0x4 */
} FPGA_HISPI_REGISTERFILE_PHY_TYPE;

/**************************************************************************
* Register file name : hispi_registerfile
***************************************************************************/
typedef struct
{
   FPGA_HISPI_REGISTERFILE_INFO_TYPE info;      /* Section; Base address offset: 0x0 */
   M_UINT32                          rsvd0[7];  /* Padding; Size (28 Bytes) */
   FPGA_HISPI_REGISTERFILE_CORE_TYPE core;      /* Section; Base address offset: 0x30 */
   M_UINT32                          rsvd1[1];  /* Padding; Size (4 Bytes) */
   FPGA_HISPI_REGISTERFILE_PHY_TYPE  phy;       /* Section; Base address offset: 0x40 */
} FPGA_HISPI_REGISTERFILE_TYPE;



#endif
