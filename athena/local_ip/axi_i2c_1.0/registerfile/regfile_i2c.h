/**************************************************************************
*
* File name    :  regfile_i2c.h
* Created by   : imaval
*
* Content      :  This file contains the register structures for the
*                 fpga regfile_i2c processing unit.
*
* Hardware native endianness: little endian
*
* FDK IDE Version     : 4.7.0_beta4
* Build ID            : I20191220-1537
* Register file CRC32 : 0x5A5B9037
*
* COPYRIGHT (c) 2020 Matrox Electronic Systems Ltd.
* All Rights Reserved
*
***************************************************************************/
#ifndef __FPGA_REGFILE_I2C_H__
#define __FPGA_REGFILE_I2C_H__

#include "mbasictypes.h"





/**************************************************************************
* Register address defines
***************************************************************************/
#define FPGA_REGFILE_I2C_I2C_I2C_ID_ADDRESS        0x000
#define FPGA_REGFILE_I2C_I2C_I2C_CTRL0_ADDRESS     0x008
#define FPGA_REGFILE_I2C_I2C_I2C_CTRL1_ADDRESS     0x010

/**************************************************************************
* Register name : I2C_ID
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 ID                     : 12;  /* Bits(11:0), null */
      M_UINT32 RSVD0                  : 4;   /* Bits(15:12), Reserved */
      M_UINT32 NI_ACCESS              : 1;   /* Bits(16:16), null */
      M_UINT32 CLOCK_STRETCHING       : 1;   /* Bits(17:17), null */
      M_UINT32 RSVD1                  : 14;  /* Bits(31:18), Reserved */
      M_UINT32 RSVD_REGISTER_SPACE[1] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_I2C_I2C_I2C_ID_TYPE;


/**************************************************************************
* Register name : I2C_CTRL0
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 I2C_DATA_WRITE         : 8;  /* Bits(7:0), I2C Data Write */
      M_UINT32 I2C_DATA_READ          : 8;  /* Bits(15:8), I2C Data Read */
      M_UINT32 TRIGGER                : 1;  /* Bits(16:16), Trigger */
      M_UINT32 BUS_SEL                : 2;  /* Bits(18:17), I2C BUS selection */
      M_UINT32 RSVD0                  : 4;  /* Bits(22:19), Reserved */
      M_UINT32 NI_ACC                 : 1;  /* Bits(23:23), Non Indexed I2C access */
      M_UINT32 I2C_INDEX              : 8;  /* Bits(31:24), I2C Index */
      M_UINT32 RSVD_REGISTER_SPACE[1] ;     /* Reserved space below */
   } f;

} FPGA_REGFILE_I2C_I2C_I2C_CTRL0_TYPE;


/**************************************************************************
* Register name : I2C_CTRL1
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 I2C_RW                 : 1;   /* Bits(0:0), I2C Read/Write */
      M_UINT32 I2C_DEVICE_ID          : 7;   /* Bits(7:1), I2C Device ID */
      M_UINT32 RSVD0                  : 17;  /* Bits(24:8), Reserved */
      M_UINT32 READING                : 1;   /* Bits(25:25), Reading */
      M_UINT32 WRITING                : 1;   /* Bits(26:26), Writing */
      M_UINT32 BUSY                   : 1;   /* Bits(27:27), Busy */
      M_UINT32 I2C_ERROR              : 1;   /* Bits(28:28), Error */
      M_UINT32 RSVD1                  : 3;   /* Bits(31:29), Reserved */
      M_UINT32 RSVD_REGISTER_SPACE[1] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_I2C_I2C_I2C_CTRL1_TYPE;


/**************************************************************************
* Section name   : I2C
***************************************************************************/
typedef struct
{
   FPGA_REGFILE_I2C_I2C_I2C_ID_TYPE    I2C_ID;     /* Address offset: 0x0 */
   FPGA_REGFILE_I2C_I2C_I2C_CTRL0_TYPE I2C_CTRL0;  /* Address offset: 0x8 */
   FPGA_REGFILE_I2C_I2C_I2C_CTRL1_TYPE I2C_CTRL1;  /* Address offset: 0x10 */
} FPGA_REGFILE_I2C_I2C_TYPE;

/**************************************************************************
* Register file name : REGFILE_I2C
***************************************************************************/
typedef struct
{
   FPGA_REGFILE_I2C_I2C_TYPE I2C;  /* Section; Base address offset: 0x0 */
} FPGA_REGFILE_I2C_TYPE;



#endif
