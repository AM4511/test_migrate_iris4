/**************************************************************************
*
* File name    :  pcie2AxiMaster.h
*
* Content      :  This file contains the register structures for the
*                 fpga pcie2AxiMaster processing unit.
*
* Hardware native endianness: little endian
*
* FDK IDE Version: 4.5.0_beta5
* Build ID: I20151222-1010
*
* COPYRIGHT (c) 2008 Matrox Electronic Systems Ltd.
* All Rights Reserved
*
***************************************************************************/
#ifndef __FPGA_PCIE2AXIMASTER_H__
#define __FPGA_PCIE2AXIMASTER_H__

#include "mbasictypes.h"





/**************************************************************************
* Register address defines
***************************************************************************/
#define FPGA_PCIE2AXIMASTER_INFO_TAG_ADDRESS                       0x000
#define FPGA_PCIE2AXIMASTER_INFO_FID_ADDRESS                       0x004
#define FPGA_PCIE2AXIMASTER_INFO_VERSION_ADDRESS                   0x008
#define FPGA_PCIE2AXIMASTER_INFO_CAPABILITY_ADDRESS                0x00C
#define FPGA_PCIE2AXIMASTER_INFO_SCRATCHPAD_ADDRESS                0x010
#define FPGA_PCIE2AXIMASTER_FPGA_VERSION_ADDRESS                   0x020
#define FPGA_PCIE2AXIMASTER_FPGA_BUILD_ID_ADDRESS                  0x024
#define FPGA_PCIE2AXIMASTER_FPGA_DEVICE_ADDRESS                    0x028
#define FPGA_PCIE2AXIMASTER_FPGA_BOARD_INFO_ADDRESS                0x02C
#define FPGA_PCIE2AXIMASTER_INTERRUPTS_CTRL_ADDRESS                0x040
#define FPGA_PCIE2AXIMASTER_INTERRUPTS_STATUS_ADDRESS              0x044
#define FPGA_PCIE2AXIMASTER_INTERRUPTS_ENABLE_ADDRESS              0x04C
#define FPGA_PCIE2AXIMASTER_INTERRUPTS_MASK_ADDRESS                0x054
#define FPGA_PCIE2AXIMASTER_INTERRUPT_QUEUE_CONTROL_ADDRESS        0x060
#define FPGA_PCIE2AXIMASTER_INTERRUPT_QUEUE_CONS_IDX_ADDRESS       0x064
#define FPGA_PCIE2AXIMASTER_INTERRUPT_QUEUE_ADDR_LOW_ADDRESS       0x068
#define FPGA_PCIE2AXIMASTER_INTERRUPT_QUEUE_ADDR_HIGH_ADDRESS      0x06C
#define FPGA_PCIE2AXIMASTER_TLP_TIMEOUT_ADDRESS                    0x070
#define FPGA_PCIE2AXIMASTER_TLP_TRANSACTION_ABORT_CNTR_ADDRESS     0x074
#define FPGA_PCIE2AXIMASTER_SPI_SPIREGIN_ADDRESS                   0x0E0
#define FPGA_PCIE2AXIMASTER_SPI_SPIREGOUT_ADDRESS                  0x0E8
#define FPGA_PCIE2AXIMASTER_AXI_WINDOW_CTRL_ADDRESS                0x100
#define FPGA_PCIE2AXIMASTER_AXI_WINDOW_PCI_BAR0_START_ADDRESS      0x104
#define FPGA_PCIE2AXIMASTER_AXI_WINDOW_PCI_BAR0_STOP_ADDRESS       0x108
#define FPGA_PCIE2AXIMASTER_AXI_WINDOW_AXI_TRANSLATION_ADDRESS     0x10C
#define FPGA_PCIE2AXIMASTER_DEBUG_INPUT_ADDRESS                    0x200
#define FPGA_PCIE2AXIMASTER_DEBUG_OUTPUT_ADDRESS                   0x204


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
      M_UINT32 value : 24;  /* Bits(23:0), Tag value */
      M_UINT32 rsvd0 : 8;   /* Bits(31:24), Reserved */

   } f;

} FPGA_PCIE2AXIMASTER_INFO_TAG_TYPE;


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

} FPGA_PCIE2AXIMASTER_INFO_FID_TYPE;


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
      M_UINT32 sub_minor : 8;  /* Bits(7:0), Sub minor version */
      M_UINT32 minor     : 8;  /* Bits(15:8), Minor version */
      M_UINT32 major     : 8;  /* Bits(23:16), Major version */
      M_UINT32 rsvd0     : 8;  /* Bits(31:24), Reserved */

   } f;

} FPGA_PCIE2AXIMASTER_INFO_VERSION_TYPE;


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

} FPGA_PCIE2AXIMASTER_INFO_CAPABILITY_TYPE;


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

} FPGA_PCIE2AXIMASTER_INFO_SCRATCHPAD_TYPE;


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
      M_UINT32 sub_minor     : 8;  /* Bits(7:0), Sub minor version */
      M_UINT32 minor         : 8;  /* Bits(15:8), Minor version */
      M_UINT32 major         : 8;  /* Bits(23:16), Major version */
      M_UINT32 firmware_type : 8;  /* Bits(31:24), Firmware type */

   } f;

} FPGA_PCIE2AXIMASTER_FPGA_VERSION_TYPE;


/**************************************************************************
* Register name : build_id
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

} FPGA_PCIE2AXIMASTER_FPGA_BUILD_ID_TYPE;


/**************************************************************************
* Register name : device
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 id    : 8;   /* Bits(7:0), Manufacturer FPGA device ID */
      M_UINT32 rsvd0 : 24;  /* Bits(31:8), Reserved */

   } f;

} FPGA_PCIE2AXIMASTER_FPGA_DEVICE_TYPE;


/**************************************************************************
* Register name : board_info
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 capability : 4;   /* Bits(3:0), Board capability */
      M_UINT32 rsvd0      : 28;  /* Bits(31:4), Reserved */

   } f;

} FPGA_PCIE2AXIMASTER_FPGA_BOARD_INFO_TYPE;


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
      M_UINT32 global_mask : 1;   /* Bits(0:0), Global Mask interrupt */
      M_UINT32 num_irq     : 7;   /* Bits(7:1), Number of IRQ */
      M_UINT32 rsvd0       : 24;  /* Bits(31:8), Reserved */

   } f;

} FPGA_PCIE2AXIMASTER_INTERRUPTS_CTRL_TYPE;


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
      M_UINT32 value : 32;  /* Bits(31:0), null */

   } f;

} FPGA_PCIE2AXIMASTER_INTERRUPTS_STATUS_TYPE;


/**************************************************************************
* Register name : enable
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

} FPGA_PCIE2AXIMASTER_INTERRUPTS_ENABLE_TYPE;


/**************************************************************************
* Register name : mask
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

} FPGA_PCIE2AXIMASTER_INTERRUPTS_MASK_TYPE;


/**************************************************************************
* Register name : control
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 enable : 1;   /* Bits(0:0), QInterrupt queue enable */
      M_UINT32 rsvd0  : 23;  /* Bits(23:1), Reserved */
      M_UINT32 nb_dw  : 8;   /* Bits(31:24), Number of DWORDS */

   } f;

} FPGA_PCIE2AXIMASTER_INTERRUPT_QUEUE_CONTROL_TYPE;


/**************************************************************************
* Register name : cons_idx
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 cons_idx : 10;  /* Bits(9:0), null */
      M_UINT32 rsvd0    : 22;  /* Bits(31:10), Reserved */

   } f;

} FPGA_PCIE2AXIMASTER_INTERRUPT_QUEUE_CONS_IDX_TYPE;


/**************************************************************************
* Register name : addr_low
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 addr : 32;  /* Bits(31:0), null */

   } f;

} FPGA_PCIE2AXIMASTER_INTERRUPT_QUEUE_ADDR_LOW_TYPE;


/**************************************************************************
* Register name : addr_high
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 addr : 32;  /* Bits(31:0), null */

   } f;

} FPGA_PCIE2AXIMASTER_INTERRUPT_QUEUE_ADDR_HIGH_TYPE;


/**************************************************************************
* Register name : timeout
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 value : 32;  /* Bits(31:0), TLP timeout value */

   } f;

} FPGA_PCIE2AXIMASTER_TLP_TIMEOUT_TYPE;


/**************************************************************************
* Register name : transaction_abort_cntr
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 value : 31;  /* Bits(30:0), Counter value */
      M_UINT32 clr   : 1;   /* Bits(31:31), Clear transaction abort counter value */

   } f;

} FPGA_PCIE2AXIMASTER_TLP_TRANSACTION_ABORT_CNTR_TYPE;


/**************************************************************************
* Register name : spiregin
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 spidataw               : 8;  /* Bits(7:0), SPI Data  byte to write */
      M_UINT32 rsvd0                  : 8;  /* Bits(15:8), Reserved */
      M_UINT32 spitxst                : 1;  /* Bits(16:16), SPI SPITXST Transfer STart */
      M_UINT32 rsvd1                  : 1;  /* Bits(17:17), Reserved */
      M_UINT32 spisel                 : 1;  /* Bits(18:18), SPI active channel SELection */
      M_UINT32 rsvd2                  : 2;  /* Bits(20:19), Reserved */
      M_UINT32 spicmddone             : 1;  /* Bits(21:21), SPI  CoMmaD DONE */
      M_UINT32 spirw                  : 1;  /* Bits(22:22), SPI  Read Write */
      M_UINT32 rsvd3                  : 1;  /* Bits(23:23), Reserved */
      M_UINT32 spi_enable             : 1;  /* Bits(24:24), SPI ENABLE */
      M_UINT32 spi_old_enable         : 1;  /* Bits(25:25), null */
      M_UINT32 rsvd4                  : 6;  /* Bits(31:26), Reserved */
      M_UINT32 rsvd_register_space[1] ;     /* Reserved space below */

   } f;

} FPGA_PCIE2AXIMASTER_SPI_SPIREGIN_TYPE;


/**************************************************************************
* Register name : spiregout
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 spidatard              : 8;   /* Bits(7:0), SPI DATA  Read byte OUTput */
      M_UINT32 rsvd0                  : 8;   /* Bits(15:8), Reserved */
      M_UINT32 spiwrtd                : 1;   /* Bits(16:16), SPI Write or Read Transfer Done */
      M_UINT32 spi_wb_cap             : 1;   /* Bits(17:17), SPI Write Burst CAPable */
      M_UINT32 rsvd1                  : 14;  /* Bits(31:18), Reserved */
      M_UINT32 rsvd_register_space[1] ;      /* Reserved space below */

   } f;

} FPGA_PCIE2AXIMASTER_SPI_SPIREGOUT_TYPE;


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
      M_UINT32 enable : 1;   /* Bits(0:0), null */
      M_UINT32 rsvd0  : 31;  /* Bits(31:1), Reserved */

   } f;

} FPGA_PCIE2AXIMASTER_AXI_WINDOW_CTRL_TYPE;


/**************************************************************************
* Register name : pci_bar0_start
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 value : 26;  /* Bits(25:0), null */
      M_UINT32 rsvd0 : 6;   /* Bits(31:26), Reserved */

   } f;

} FPGA_PCIE2AXIMASTER_AXI_WINDOW_PCI_BAR0_START_TYPE;


/**************************************************************************
* Register name : pci_bar0_stop
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 value : 26;  /* Bits(25:0), null */
      M_UINT32 rsvd0 : 6;   /* Bits(31:26), Reserved */

   } f;

} FPGA_PCIE2AXIMASTER_AXI_WINDOW_PCI_BAR0_STOP_TYPE;


/**************************************************************************
* Register name : axi_translation
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

} FPGA_PCIE2AXIMASTER_AXI_WINDOW_AXI_TRANSLATION_TYPE;


/**************************************************************************
* Register name : input
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

} FPGA_PCIE2AXIMASTER_DEBUG_INPUT_TYPE;


/**************************************************************************
* Register name : output
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

} FPGA_PCIE2AXIMASTER_DEBUG_OUTPUT_TYPE;


/**************************************************************************
* Section name   : info
***************************************************************************/
typedef struct
{
   FPGA_PCIE2AXIMASTER_INFO_TAG_TYPE        tag;         /* Address offset: 0x0 */
   FPGA_PCIE2AXIMASTER_INFO_FID_TYPE        fid;         /* Address offset: 0x4 */
   FPGA_PCIE2AXIMASTER_INFO_VERSION_TYPE    version;     /* Address offset: 0x8 */
   FPGA_PCIE2AXIMASTER_INFO_CAPABILITY_TYPE capability;  /* Address offset: 0xc */
   FPGA_PCIE2AXIMASTER_INFO_SCRATCHPAD_TYPE scratchpad;  /* Address offset: 0x10 */

} FPGA_PCIE2AXIMASTER_INFO_TYPE;


/**************************************************************************
* Section name   : fpga
***************************************************************************/
typedef struct
{
   FPGA_PCIE2AXIMASTER_FPGA_VERSION_TYPE    version;     /* Address offset: 0x0 */
   FPGA_PCIE2AXIMASTER_FPGA_BUILD_ID_TYPE   build_id;    /* Address offset: 0x4 */
   FPGA_PCIE2AXIMASTER_FPGA_DEVICE_TYPE     device;      /* Address offset: 0x8 */
   FPGA_PCIE2AXIMASTER_FPGA_BOARD_INFO_TYPE board_info;  /* Address offset: 0xc */

} FPGA_PCIE2AXIMASTER_FPGA_TYPE;


/**************************************************************************
* Section name   : interrupts
***************************************************************************/
typedef struct
{
   FPGA_PCIE2AXIMASTER_INTERRUPTS_CTRL_TYPE   ctrl;       /* Address offset: 0x0 */
   FPGA_PCIE2AXIMASTER_INTERRUPTS_STATUS_TYPE status[2];  /* Address offset: 0x4 */
   FPGA_PCIE2AXIMASTER_INTERRUPTS_ENABLE_TYPE enable[2];  /* Address offset: 0xc */
   FPGA_PCIE2AXIMASTER_INTERRUPTS_MASK_TYPE   mask[2];    /* Address offset: 0x14 */

} FPGA_PCIE2AXIMASTER_INTERRUPTS_TYPE;


/**************************************************************************
* Section name   : interrupt_queue
***************************************************************************/
typedef struct
{
   FPGA_PCIE2AXIMASTER_INTERRUPT_QUEUE_CONTROL_TYPE   control;    /* Address offset: 0x0 */
   FPGA_PCIE2AXIMASTER_INTERRUPT_QUEUE_CONS_IDX_TYPE  cons_idx;   /* Address offset: 0x4 */
   FPGA_PCIE2AXIMASTER_INTERRUPT_QUEUE_ADDR_LOW_TYPE  addr_low;   /* Address offset: 0x8 */
   FPGA_PCIE2AXIMASTER_INTERRUPT_QUEUE_ADDR_HIGH_TYPE addr_high;  /* Address offset: 0xc */

} FPGA_PCIE2AXIMASTER_INTERRUPT_QUEUE_TYPE;


/**************************************************************************
* Section name   : tlp
***************************************************************************/
typedef struct
{
   FPGA_PCIE2AXIMASTER_TLP_TIMEOUT_TYPE                timeout;                 /* Address offset: 0x0 */
   FPGA_PCIE2AXIMASTER_TLP_TRANSACTION_ABORT_CNTR_TYPE transaction_abort_cntr;  /* Address offset: 0x4 */

} FPGA_PCIE2AXIMASTER_TLP_TYPE;


/**************************************************************************
* Section name   : spi
***************************************************************************/
typedef struct
{
   FPGA_PCIE2AXIMASTER_SPI_SPIREGIN_TYPE  spiregin;   /* Address offset: 0x0 */
   FPGA_PCIE2AXIMASTER_SPI_SPIREGOUT_TYPE spiregout;  /* Address offset: 0x8 */

} FPGA_PCIE2AXIMASTER_SPI_TYPE;


/**************************************************************************
* Section name   : axi_window
***************************************************************************/
typedef struct
{
   FPGA_PCIE2AXIMASTER_AXI_WINDOW_CTRL_TYPE            ctrl;             /* Address offset: 0x0 */
   FPGA_PCIE2AXIMASTER_AXI_WINDOW_PCI_BAR0_START_TYPE  pci_bar0_start;   /* Address offset: 0x4 */
   FPGA_PCIE2AXIMASTER_AXI_WINDOW_PCI_BAR0_STOP_TYPE   pci_bar0_stop;    /* Address offset: 0x8 */
   FPGA_PCIE2AXIMASTER_AXI_WINDOW_AXI_TRANSLATION_TYPE axi_translation;  /* Address offset: 0xc */

} FPGA_PCIE2AXIMASTER_AXI_WINDOW_TYPE;


/**************************************************************************
* Section name   : debug
***************************************************************************/
typedef struct
{
   FPGA_PCIE2AXIMASTER_DEBUG_INPUT_TYPE  input;   /* Address offset: 0x0 */
   FPGA_PCIE2AXIMASTER_DEBUG_OUTPUT_TYPE output;  /* Address offset: 0x4 */

} FPGA_PCIE2AXIMASTER_DEBUG_TYPE;


/**************************************************************************
* Register file name : pcie2aximaster
***************************************************************************/
typedef struct
{
   FPGA_PCIE2AXIMASTER_INFO_TYPE            info;             /* Section; Base address offset: 0x0 */
   M_UINT32                                 rsvd0[3];         /* Padding; Size (12 Bytes) */
   FPGA_PCIE2AXIMASTER_FPGA_TYPE            fpga;             /* Section; Base address offset: 0x20 */
   M_UINT32                                 rsvd1[4];         /* Padding; Size (16 Bytes) */
   FPGA_PCIE2AXIMASTER_INTERRUPTS_TYPE      interrupts;       /* Section; Base address offset: 0x40 */
   M_UINT32                                 rsvd2[1];         /* Padding; Size (4 Bytes) */
   FPGA_PCIE2AXIMASTER_INTERRUPT_QUEUE_TYPE interrupt_queue;  /* Section; Base address offset: 0x60 */
   FPGA_PCIE2AXIMASTER_TLP_TYPE             tlp;              /* Section; Base address offset: 0x70 */
   M_UINT32                                 rsvd3[26];        /* Padding; Size (104 Bytes) */
   FPGA_PCIE2AXIMASTER_SPI_TYPE             spi;              /* Section; Base address offset: 0xe0 */
   M_UINT32                                 rsvd4[4];         /* Padding; Size (16 Bytes) */
   FPGA_PCIE2AXIMASTER_AXI_WINDOW_TYPE      axi_window[4];    /* Section; Base address offset: 0x100 */
   M_UINT32                                 rsvd5[48];        /* Padding; Size (192 Bytes) */
   FPGA_PCIE2AXIMASTER_DEBUG_TYPE           debug;            /* Section; Base address offset: 0x200 */

} FPGA_PCIE2AXIMASTER_TYPE;



#endif
