/*****************************************************************************
 ** File                : regfile_i2c.sv
 ** Project             : FDK
 ** Module              : regfile_i2c
 ** Created on          : 2020/03/19 13:08:52
 ** Created by          : jmansill
 ** FDK IDE Version     : 4.7.0_beta3
 ** Build ID            : I20191219-1127
 ** Register file CRC32 : 0x5A5B9037
 **
 **  COPYRIGHT (c) 2020 Matrox Electronic Systems Ltd.
 **  All Rights Reserved
 **
 *****************************************************************************/
typedef bit  [7:0][3:0]  uint8_t;
typedef bit  [15:0][1:0] uint16_t;
typedef bit  [31:0]      uint32_t;



/**************************************************************************
* Register name : I2C_ID
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [11:0] ID;                      /* Bits(11:0), null */
      logic [3:0]  rsvd0;                   /* Bits(15:12), Reserved */
      logic        NI_ACCESS;               /* Bits(16:16), null */
      logic        CLOCK_STRETCHING;        /* Bits(17:17), null */
      logic [13:0] rsvd1;                   /* Bits(31:18), Reserved */
      logic        rsvd_register_space[1];  /* Reserved space below */
   } f;

} fdk_regfile_i2c_I2C_I2C_ID_t;


/**************************************************************************
* Register name : I2C_CTRL0
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [7:0] I2C_DATA_WRITE;          /* Bits(7:0), I2C Data Write */
      logic [7:0] I2C_DATA_READ;           /* Bits(15:8), I2C Data Read */
      logic       TRIGGER;                 /* Bits(16:16), Trigger */
      logic [1:0] BUS_SEL;                 /* Bits(18:17), I2C BUS selection */
      logic [3:0] rsvd0;                   /* Bits(22:19), Reserved */
      logic       NI_ACC;                  /* Bits(23:23), Non Indexed I2C access */
      logic [7:0] I2C_INDEX;               /* Bits(31:24), I2C Index */
      logic       rsvd_register_space[1];  /* Reserved space below */
   } f;

} fdk_regfile_i2c_I2C_I2C_CTRL0_t;


/**************************************************************************
* Register name : I2C_CTRL1
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic        I2C_RW;                  /* Bits(0:0), I2C Read/Write */
      logic [6:0]  I2C_DEVICE_ID;           /* Bits(7:1), I2C Device ID */
      logic [16:0] rsvd0;                   /* Bits(24:8), Reserved */
      logic        READING;                 /* Bits(25:25), Reading */
      logic        WRITING;                 /* Bits(26:26), Writing */
      logic        BUSY;                    /* Bits(27:27), Busy */
      logic        I2C_ERROR;               /* Bits(28:28), Error */
      logic [2:0]  rsvd1;                   /* Bits(31:29), Reserved */
      logic        rsvd_register_space[1];  /* Reserved space below */
   } f;

} fdk_regfile_i2c_I2C_I2C_CTRL1_t;


/**************************************************************************
* Section name   : I2C
***************************************************************************/
typedef struct packed
{
   fdk_regfile_i2c_I2C_I2C_ID_t    I2C_ID;     /* Address offset: 0x0 */
   fdk_regfile_i2c_I2C_I2C_CTRL0_t I2C_CTRL0;  /* Address offset: 0x8 */
   fdk_regfile_i2c_I2C_I2C_CTRL1_t I2C_CTRL1;  /* Address offset: 0x10 */
} fdk_regfile_i2c_I2C_t;


/**************************************************************************
* Register file name : regfile_i2c
***************************************************************************/
typedef struct packed
{
   fdk_regfile_i2c_I2C_t I2C;  /* Section; Base address offset: 0x0 */
} fdk_regfile_i2c_t;

