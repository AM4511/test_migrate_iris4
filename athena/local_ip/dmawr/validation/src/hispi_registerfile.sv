/*****************************************************************************
 ** File                : hispi_registerfile.sv
 ** Project             : FDK
 ** Module              : hispi_registerfile
 ** Created on          : 2019/07/30 14:01:37
 ** Created by          : amarchan
 ** FDK IDE Version     : 4.7.0_beta2
 ** Build ID            : I20190711-1601
 ** Register file CRC32 : 0x1EABE929
 **
 **  COPYRIGHT (c) 2019 Matrox Electronic Systems Ltd.
 **  All Rights Reserved
 **
 *****************************************************************************/
typedef bit  [7:0][3:0]  uint8_t;
typedef bit  [15:0][1:0] uint16_t;
typedef bit  [31:0]      uint32_t;



/**************************************************************************
* Register name : tag
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [23:0] value;  /* Bits(23:0), Tag identifier */
      logic [7:0]  rsvd0;  /* Bits(31:24), Reserved */
   } f;

} fdk_hispi_registerfile_info_tag_t;


/**************************************************************************
* Register name : fid
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [31:0] value;  /* Bits(31:0), null */
   } f;

} fdk_hispi_registerfile_info_fid_t;


/**************************************************************************
* Register name : version
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [7:0] hw;     /* Bits(7:0), null */
      logic [7:0] minor;  /* Bits(15:8), null */
      logic [7:0] major;  /* Bits(23:16), null */
      logic [7:0] rsvd0;  /* Bits(31:24), Reserved */
   } f;

} fdk_hispi_registerfile_info_version_t;


/**************************************************************************
* Register name : capability
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [7:0]  value;  /* Bits(7:0), null */
      logic [23:0] rsvd0;  /* Bits(31:8), Reserved */
   } f;

} fdk_hispi_registerfile_info_capability_t;


/**************************************************************************
* Register name : scratchpad
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [31:0] value;  /* Bits(31:0), null */
   } f;

} fdk_hispi_registerfile_info_scratchpad_t;


/**************************************************************************
* Register name : ctrl
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic        reset;           /* Bits(0:0), null */
      logic        capture_enable;  /* Bits(1:1), null */
      logic [29:0] rsvd0;           /* Bits(31:2), Reserved */
   } f;

} fdk_hispi_registerfile_core_ctrl_t;


/**************************************************************************
* Register name : pixels_per_line
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [15:0] value;  /* Bits(15:0), null */
      logic [15:0] rsvd0;  /* Bits(31:16), Reserved */
   } f;

} fdk_hispi_registerfile_core_pixels_per_line_t;


/**************************************************************************
* Register name : line_per_frame
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [15:0] value;  /* Bits(15:0), null */
      logic [15:0] rsvd0;  /* Bits(31:16), Reserved */
   } f;

} fdk_hispi_registerfile_core_line_per_frame_t;


/**************************************************************************
* Register name : status
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic        pll_locked;  /* Bits(0:0), null */
      logic [30:0] rsvd0;       /* Bits(31:1), Reserved */
   } f;

} fdk_hispi_registerfile_phy_status_t;


/**************************************************************************
* Section name   : info
***************************************************************************/
typedef struct packed
{
   fdk_hispi_registerfile_info_tag_t        tag;         /* Address offset: 0x0 */
   fdk_hispi_registerfile_info_fid_t        fid;         /* Address offset: 0x4 */
   fdk_hispi_registerfile_info_version_t    version;     /* Address offset: 0x8 */
   fdk_hispi_registerfile_info_capability_t capability;  /* Address offset: 0xc */
   fdk_hispi_registerfile_info_scratchpad_t scratchpad;  /* Address offset: 0x10 */
} fdk_hispi_registerfile_info_t;


/**************************************************************************
* Section name   : core
***************************************************************************/
typedef struct packed
{
   fdk_hispi_registerfile_core_ctrl_t            ctrl;             /* Address offset: 0x0 */
   fdk_hispi_registerfile_core_pixels_per_line_t pixels_per_line;  /* Address offset: 0x4 */
   fdk_hispi_registerfile_core_line_per_frame_t  line_per_frame;   /* Address offset: 0x8 */
} fdk_hispi_registerfile_core_t;


/**************************************************************************
* Section name   : phy
***************************************************************************/
typedef struct packed
{
   fdk_hispi_registerfile_phy_status_t status;  /* Address offset: 0x0 */
} fdk_hispi_registerfile_phy_t;


/**************************************************************************
* Register file name : hispi_registerfile
***************************************************************************/
typedef struct packed
{
   fdk_hispi_registerfile_info_t info;        /* Section; Base address offset: 0x0 */
   uint32_t                      [6:0]rsvd0;  /* Padding; Size (28 Bytes) */
   fdk_hispi_registerfile_core_t core;        /* Section; Base address offset: 0x30 */
   uint32_t                      rsvd1;       /* Padding; Size (4 Bytes) */
   fdk_hispi_registerfile_phy_t  phy;         /* Section; Base address offset: 0x40 */
} fdk_hispi_registerfile_t;

