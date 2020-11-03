/**************************************************************************
*
* File name    :  regfile_ares.h
* Created by   : amarchan
*
* Content      :  This file contains the register structures for the
*                 fpga regfile_ares processing unit.
*
* Hardware native endianness: little endian
*
* FDK IDE Version     : 4.7.0_beta4
* Build ID            : I20191220-1537
* Register file CRC32 : 0x7A83C19D
*
* COPYRIGHT (c) 2020 Matrox Electronic Systems Ltd.
* All Rights Reserved
*
***************************************************************************/
#ifndef __FPGA_REGFILE_ARES_H__
#define __FPGA_REGFILE_ARES_H__

#include "mbasictypes.h"





/**************************************************************************
* Register address defines
***************************************************************************/
#define FPGA_REGFILE_ARES_DEVICE_SPECIFIC_INTSTAT_ADDRESS                     0x0000
#define FPGA_REGFILE_ARES_DEVICE_SPECIFIC_INTMASKN_ADDRESS                    0x0004
#define FPGA_REGFILE_ARES_DEVICE_SPECIFIC_INTSTAT2_ADDRESS                    0x0008
#define FPGA_REGFILE_ARES_DEVICE_SPECIFIC_BUILDID_ADDRESS                     0x001C
#define FPGA_REGFILE_ARES_DEVICE_SPECIFIC_FPGA_ID_ADDRESS                     0x0020
#define FPGA_REGFILE_ARES_DEVICE_SPECIFIC_LED_OVERRIDE_ADDRESS                0x0024
#define FPGA_REGFILE_ARES_INTERRUPT_QUEUE_CONTROL_ADDRESS                     0x0040
#define FPGA_REGFILE_ARES_INTERRUPT_QUEUE_CONS_IDX_ADDRESS                    0x0044
#define FPGA_REGFILE_ARES_INTERRUPT_QUEUE_ADDR_LOW_ADDRESS                    0x0048
#define FPGA_REGFILE_ARES_INTERRUPT_QUEUE_ADDR_HIGH_ADDRESS                   0x004C
#define FPGA_REGFILE_ARES_INTERRUPT_QUEUE_MAPPING_ADDRESS                     0x0050
#define FPGA_REGFILE_ARES_TLP_TIMEOUT_ADDRESS                                 0x0070
#define FPGA_REGFILE_ARES_TLP_TRANSACTION_ABORT_CNTR_ADDRESS                  0x0074
#define FPGA_REGFILE_ARES_SPI_SPIREGIN_ADDRESS                                0x00E0
#define FPGA_REGFILE_ARES_SPI_SPIREGOUT_ADDRESS                               0x00E8
#define FPGA_REGFILE_ARES_ARBITER_ARBITER_CAPABILITIES_ADDRESS                0x00F0
#define FPGA_REGFILE_ARES_ARBITER_AGENT_ADDRESS                               0x00F4
#define FPGA_REGFILE_ARES_AXI_WINDOW_CTRL_ADDRESS                             0x0100
#define FPGA_REGFILE_ARES_AXI_WINDOW_PCI_BAR0_START_ADDRESS                   0x0104
#define FPGA_REGFILE_ARES_AXI_WINDOW_PCI_BAR0_STOP_ADDRESS                    0x0108
#define FPGA_REGFILE_ARES_AXI_WINDOW_AXI_TRANSLATION_ADDRESS                  0x010C
#define FPGA_REGFILE_ARES_IO_CAPABILITIES_IO_ADDRESS                          0x0200
#define FPGA_REGFILE_ARES_IO_IO_PIN_ADDRESS                                   0x0204
#define FPGA_REGFILE_ARES_IO_IO_OUT_ADDRESS                                   0x0208
#define FPGA_REGFILE_ARES_IO_IO_DIR_ADDRESS                                   0x020C
#define FPGA_REGFILE_ARES_IO_IO_POL_ADDRESS                                   0x0210
#define FPGA_REGFILE_ARES_IO_IO_INTSTAT_ADDRESS                               0x0214
#define FPGA_REGFILE_ARES_IO_IO_INTMASKN_ADDRESS                              0x0218
#define FPGA_REGFILE_ARES_IO_IO_ANYEDGE_ADDRESS                               0x021C
#define FPGA_REGFILE_ARES_QUADRATURE_CAPABILITIES_QUAD_ADDRESS                0x0300
#define FPGA_REGFILE_ARES_QUADRATURE_POSITIONRESET_ADDRESS                    0x0304
#define FPGA_REGFILE_ARES_QUADRATURE_DECODERINPUT_ADDRESS                     0x0308
#define FPGA_REGFILE_ARES_QUADRATURE_DECODERCFG_ADDRESS                       0x030C
#define FPGA_REGFILE_ARES_QUADRATURE_DECODERPOSTRIGGER_ADDRESS                0x0310
#define FPGA_REGFILE_ARES_QUADRATURE_DECODERCNTRLATCH_CFG_ADDRESS             0x0314
#define FPGA_REGFILE_ARES_QUADRATURE_DECODERCNTRLATCHED_SW_ADDRESS            0x0334
#define FPGA_REGFILE_ARES_QUADRATURE_DECODERCNTRLATCHED_ADDRESS               0x0338
#define FPGA_REGFILE_ARES_TICKTABLE_CAPABILITIES_TICKTBL_ADDRESS              0x0380
#define FPGA_REGFILE_ARES_TICKTABLE_CAPABILITIES_EXT1_ADDRESS                 0x0384
#define FPGA_REGFILE_ARES_TICKTABLE_TICKTABLECLOCKPERIOD_ADDRESS              0x0388
#define FPGA_REGFILE_ARES_TICKTABLE_TICKCONFIG_ADDRESS                        0x038C
#define FPGA_REGFILE_ARES_TICKTABLE_CURRENTSTAMPLATCHED_ADDRESS               0x0390
#define FPGA_REGFILE_ARES_TICKTABLE_WRITETIME_ADDRESS                         0x0394
#define FPGA_REGFILE_ARES_TICKTABLE_WRITECOMMAND_ADDRESS                      0x0398
#define FPGA_REGFILE_ARES_TICKTABLE_LATCHINTSTAT_ADDRESS                      0x039C
#define FPGA_REGFILE_ARES_TICKTABLE_INPUTSTAMP_ADDRESS                        0x03A0
#define FPGA_REGFILE_ARES_TICKTABLE_RESERVED_FOR_EXTRA_LATCH_ADDRESS          0x03A8
#define FPGA_REGFILE_ARES_TICKTABLE_INPUTSTAMPLATCHED_ADDRESS                 0x03D0
#define FPGA_REGFILE_ARES_INPUTCONDITIONING_CAPABILITIES_INCOND_ADDRESS       0x0400
#define FPGA_REGFILE_ARES_INPUTCONDITIONING_INPUTCONDITIONING_ADDRESS         0x0404
#define FPGA_REGFILE_ARES_OUTPUTCONDITIONING_CAPABILITIES_OUTCOND_ADDRESS     0x0480
#define FPGA_REGFILE_ARES_OUTPUTCONDITIONING_OUTPUTCOND_ADDRESS               0x0484
#define FPGA_REGFILE_ARES_OUTPUTCONDITIONING_RESERVED_ADDRESS                 0x0494
#define FPGA_REGFILE_ARES_OUTPUTCONDITIONING_OUTPUT_DEBOUNCE_ADDRESS          0x04AC
#define FPGA_REGFILE_ARES_INTERNALINPUT_CAPABILITIES_INT_INP_ADDRESS          0x0500
#define FPGA_REGFILE_ARES_INTERNALOUTPUT_CAPABILITIES_INTOUT_ADDRESS          0x0580
#define FPGA_REGFILE_ARES_INTERNALOUTPUT_OUTPUTCOND_ADDRESS                   0x0584
#define FPGA_REGFILE_ARES_TIMER_CAPABILITIES_TIMER_ADDRESS                    0x0600
#define FPGA_REGFILE_ARES_TIMER_TIMERCLOCKPERIOD_ADDRESS                      0x0604
#define FPGA_REGFILE_ARES_TIMER_TIMERTRIGGERARM_ADDRESS                       0x0608
#define FPGA_REGFILE_ARES_TIMER_TIMERCLOCKSOURCE_ADDRESS                      0x060C
#define FPGA_REGFILE_ARES_TIMER_TIMERDELAYVALUE_ADDRESS                       0x0610
#define FPGA_REGFILE_ARES_TIMER_TIMERDURATION_ADDRESS                         0x0614
#define FPGA_REGFILE_ARES_TIMER_TIMERLATCHEDVALUE_ADDRESS                     0x0618
#define FPGA_REGFILE_ARES_TIMER_TIMERSTATUS_ADDRESS                           0x061C
#define FPGA_REGFILE_ARES_MICROBLAZE_CAPABILITIES_MICRO_ADDRESS               0x0A00
#define FPGA_REGFILE_ARES_MICROBLAZE_PRODCONS_ADDRESS                         0x0A04
#define FPGA_REGFILE_ARES_ANALOGOUTPUT_CAPABILITIES_ANA_OUT_ADDRESS           0x0A80
#define FPGA_REGFILE_ARES_ANALOGOUTPUT_OUTPUTVALUE_ADDRESS                    0x0A84
#define FPGA_REGFILE_ARES_EOFM_EOFM_ADDRESS                                   0x0B00
#define FPGA_REGFILE_ARES_PRODCONS_POINTERS_ADDRESS                           0x2000
#define FPGA_REGFILE_ARES_PRODCONS_DPRAM_ADDRESS                              0x3000

/**************************************************************************
* Register name : intstat
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 irq_io         : 1;   /* Bits(0:0), null */
      M_UINT32 irq_tick       : 1;   /* Bits(1:1), null */
      M_UINT32 rsvd0          : 1;   /* Bits(2:2), Reserved */
      M_UINT32 irq_timer      : 1;   /* Bits(3:3), null */
      M_UINT32 irq_tick_wa    : 1;   /* Bits(4:4), null */
      M_UINT32 rsvd1          : 1;   /* Bits(5:5), Reserved */
      M_UINT32 irq_microblaze : 1;   /* Bits(6:6), null */
      M_UINT32 irq_tick_latch : 1;   /* Bits(7:7), null */
      M_UINT32 rsvd2          : 24;  /* Bits(31:8), Reserved */
   } f;

} FPGA_REGFILE_ARES_DEVICE_SPECIFIC_INTSTAT_TYPE;


/**************************************************************************
* Register name : intmaskn
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 irq_io         : 1;   /* Bits(0:0), null */
      M_UINT32 irq_tick       : 1;   /* Bits(1:1), null */
      M_UINT32 rsvd0          : 1;   /* Bits(2:2), Reserved */
      M_UINT32 irq_timer      : 1;   /* Bits(3:3), null */
      M_UINT32 irq_tick_wa    : 1;   /* Bits(4:4), null */
      M_UINT32 rsvd1          : 1;   /* Bits(5:5), Reserved */
      M_UINT32 irq_microblaze : 1;   /* Bits(6:6), null */
      M_UINT32 irq_tick_latch : 1;   /* Bits(7:7), null */
      M_UINT32 rsvd2          : 24;  /* Bits(31:8), Reserved */
   } f;

} FPGA_REGFILE_ARES_DEVICE_SPECIFIC_INTMASKN_TYPE;


/**************************************************************************
* Register name : intstat2
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 irq_timer_start        : 8;  /* Bits(7:0), null */
      M_UINT32 rsvd0                  : 8;  /* Bits(15:8), Reserved */
      M_UINT32 irq_timer_end          : 8;  /* Bits(23:16), null */
      M_UINT32 rsvd1                  : 8;  /* Bits(31:24), Reserved */
      M_UINT32 rsvd_register_space[4] ;     /* Reserved space below */
   } f;

} FPGA_REGFILE_ARES_DEVICE_SPECIFIC_INTSTAT2_TYPE;


/**************************************************************************
* Register name : buildid
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 value : 32;  /* Bits(31:0), EPOCH date value */
   } f;

} FPGA_REGFILE_ARES_DEVICE_SPECIFIC_BUILDID_TYPE;


/**************************************************************************
* Register name : fpga_id
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 fpga_id      : 5;   /* Bits(4:0), null */
      M_UINT32 rsvd0        : 5;   /* Bits(9:5), Reserved */
      M_UINT32 pb_debug_com : 1;   /* Bits(10:10), null */
      M_UINT32 rsvd1        : 1;   /* Bits(11:11), Reserved */
      M_UINT32 profinet_led : 1;   /* Bits(12:12), null */
      M_UINT32 rsvd2        : 15;  /* Bits(27:13), Reserved */
      M_UINT32 fpga_straps  : 4;   /* Bits(31:28), FPGA Strapping */
   } f;

} FPGA_REGFILE_ARES_DEVICE_SPECIFIC_FPGA_ID_TYPE;


/**************************************************************************
* Register name : led_override
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0            : 24;  /* Bits(23:0), Reserved */
      M_UINT32 orange_off_flash : 1;   /* Bits(24:24), null */
      M_UINT32 red_orange_flash : 1;   /* Bits(25:25), null */
      M_UINT32 rsvd1            : 6;   /* Bits(31:26), Reserved */
   } f;

} FPGA_REGFILE_ARES_DEVICE_SPECIFIC_LED_OVERRIDE_TYPE;


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
      M_UINT32 enable : 1;   /* Bits(0:0), null */
      M_UINT32 rsvd0  : 23;  /* Bits(23:1), Reserved */
      M_UINT32 nb_dw  : 8;   /* Bits(31:24), null */
   } f;

} FPGA_REGFILE_ARES_INTERRUPT_QUEUE_CONTROL_TYPE;


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

} FPGA_REGFILE_ARES_INTERRUPT_QUEUE_CONS_IDX_TYPE;


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

} FPGA_REGFILE_ARES_INTERRUPT_QUEUE_ADDR_LOW_TYPE;


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

} FPGA_REGFILE_ARES_INTERRUPT_QUEUE_ADDR_HIGH_TYPE;


/**************************************************************************
* Register name : mapping
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 irq_io          : 1;  /* Bits(0:0), null */
      M_UINT32 irq_tick        : 1;  /* Bits(1:1), null */
      M_UINT32 irq_tick_wa     : 1;  /* Bits(2:2), null */
      M_UINT32 irq_timer       : 1;  /* Bits(3:3), null */
      M_UINT32 irq_microblaze  : 1;  /* Bits(4:4), null */
      M_UINT32 irq_tick_latch  : 1;  /* Bits(5:5), null */
      M_UINT32 rsvd0           : 2;  /* Bits(7:6), Reserved */
      M_UINT32 io_intstat      : 4;  /* Bits(11:8), null */
      M_UINT32 rsvd1           : 4;  /* Bits(15:12), Reserved */
      M_UINT32 irq_timer_start : 8;  /* Bits(23:16), null */
      M_UINT32 irq_timer_end   : 8;  /* Bits(31:24), null */
   } f;

} FPGA_REGFILE_ARES_INTERRUPT_QUEUE_MAPPING_TYPE;


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

} FPGA_REGFILE_ARES_TLP_TIMEOUT_TYPE;


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

} FPGA_REGFILE_ARES_TLP_TRANSACTION_ABORT_CNTR_TYPE;


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
      M_UINT32 rsvd4                  : 7;  /* Bits(31:25), Reserved */
      M_UINT32 rsvd_register_space[1] ;     /* Reserved space below */
   } f;

} FPGA_REGFILE_ARES_SPI_SPIREGIN_TYPE;


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

} FPGA_REGFILE_ARES_SPI_SPIREGOUT_TYPE;


/**************************************************************************
* Register name : arbiter_capabilities
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 tag      : 12;  /* Bits(11:0), null */
      M_UINT32 rsvd0    : 4;   /* Bits(15:12), Reserved */
      M_UINT32 agent_nb : 2;   /* Bits(17:16), null */
      M_UINT32 rsvd1    : 14;  /* Bits(31:18), Reserved */
   } f;

} FPGA_REGFILE_ARES_ARBITER_ARBITER_CAPABILITIES_TYPE;


/**************************************************************************
* Register name : agent
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 req   : 1;   /* Bits(0:0), REQuest resource */
      M_UINT32 rsvd0 : 3;   /* Bits(3:1), Reserved */
      M_UINT32 done  : 1;   /* Bits(4:4), transaction DONE */
      M_UINT32 rsvd1 : 3;   /* Bits(7:5), Reserved */
      M_UINT32 rec   : 1;   /* Bits(8:8), master request RECeived */
      M_UINT32 ack   : 1;   /* Bits(9:9), master request ACKnoledge */
      M_UINT32 rsvd2 : 22;  /* Bits(31:10), Reserved */
   } f;

} FPGA_REGFILE_ARES_ARBITER_AGENT_TYPE;


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

} FPGA_REGFILE_ARES_AXI_WINDOW_CTRL_TYPE;


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

} FPGA_REGFILE_ARES_AXI_WINDOW_PCI_BAR0_START_TYPE;


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

} FPGA_REGFILE_ARES_AXI_WINDOW_PCI_BAR0_STOP_TYPE;


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

} FPGA_REGFILE_ARES_AXI_WINDOW_AXI_TRANSLATION_TYPE;


/**************************************************************************
* Register name : capabilities_io
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0  : 12;  /* Bits(11:0), Reserved */
      M_UINT32 intnum : 5;   /* Bits(16:12), null */
      M_UINT32 output : 1;   /* Bits(17:17), null */
      M_UINT32 input  : 1;   /* Bits(18:18), null */
      M_UINT32 n_port : 5;   /* Bits(23:19), null */
      M_UINT32 io_id  : 8;   /* Bits(31:24), null */
   } f;

} FPGA_REGFILE_ARES_IO_CAPABILITIES_IO_TYPE;


/**************************************************************************
* Register name : io_pin
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 pin_value : 4;   /* Bits(3:0), null */
      M_UINT32 rsvd0     : 28;  /* Bits(31:4), Reserved */
   } f;

} FPGA_REGFILE_ARES_IO_IO_PIN_TYPE;


/**************************************************************************
* Register name : io_out
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 out_value : 4;   /* Bits(3:0), null */
      M_UINT32 rsvd0     : 28;  /* Bits(31:4), Reserved */
   } f;

} FPGA_REGFILE_ARES_IO_IO_OUT_TYPE;


/**************************************************************************
* Register name : io_dir
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 dir   : 4;   /* Bits(3:0), null */
      M_UINT32 rsvd0 : 28;  /* Bits(31:4), Reserved */
   } f;

} FPGA_REGFILE_ARES_IO_IO_DIR_TYPE;


/**************************************************************************
* Register name : io_pol
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 in_pol : 4;   /* Bits(3:0), null */
      M_UINT32 rsvd0  : 28;  /* Bits(31:4), Reserved */
   } f;

} FPGA_REGFILE_ARES_IO_IO_POL_TYPE;


/**************************************************************************
* Register name : io_intstat
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 intstat : 4;   /* Bits(3:0), null */
      M_UINT32 rsvd0   : 28;  /* Bits(31:4), Reserved */
   } f;

} FPGA_REGFILE_ARES_IO_IO_INTSTAT_TYPE;


/**************************************************************************
* Register name : io_intmaskn
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 intmaskn : 4;   /* Bits(3:0), null */
      M_UINT32 rsvd0    : 28;  /* Bits(31:4), Reserved */
   } f;

} FPGA_REGFILE_ARES_IO_IO_INTMASKN_TYPE;


/**************************************************************************
* Register name : io_anyedge
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 in_anyedge : 4;   /* Bits(3:0), null */
      M_UINT32 rsvd0      : 28;  /* Bits(31:4), Reserved */
   } f;

} FPGA_REGFILE_ARES_IO_IO_ANYEDGE_TYPE;


/**************************************************************************
* Register name : capabilities_quad
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0         : 20;  /* Bits(19:0), Reserved */
      M_UINT32 feature_rev   : 4;   /* Bits(23:20), null */
      M_UINT32 quadrature_id : 8;   /* Bits(31:24), null */
   } f;

} FPGA_REGFILE_ARES_QUADRATURE_CAPABILITIES_QUAD_TYPE;


/**************************************************************************
* Register name : positionreset
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 soft_positionreset      : 1;   /* Bits(0:0), null */
      M_UINT32 positionresetactivation : 1;   /* Bits(1:1), null */
      M_UINT32 positionresetsource     : 4;   /* Bits(5:2), null */
      M_UINT32 rsvd0                   : 26;  /* Bits(31:6), Reserved */
   } f;

} FPGA_REGFILE_ARES_QUADRATURE_POSITIONRESET_TYPE;


/**************************************************************************
* Register name : decoderinput
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0     : 13;  /* Bits(12:0), Reserved */
      M_UINT32 aselector : 3;   /* Bits(15:13), null */
      M_UINT32 rsvd1     : 13;  /* Bits(28:16), Reserved */
      M_UINT32 bselector : 3;   /* Bits(31:29), null */
   } f;

} FPGA_REGFILE_ARES_QUADRATURE_DECODERINPUT_TYPE;


/**************************************************************************
* Register name : decodercfg
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 quadenable    : 1;   /* Bits(0:0), null */
      M_UINT32 rsvd0         : 1;   /* Bits(1:1), Reserved */
      M_UINT32 decoutsource0 : 3;   /* Bits(4:2), null */
      M_UINT32 rsvd1         : 27;  /* Bits(31:5), Reserved */
   } f;

} FPGA_REGFILE_ARES_QUADRATURE_DECODERCFG_TYPE;


/**************************************************************************
* Register name : decoderpostrigger
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 positiontrigger : 32;  /* Bits(31:0), null */
   } f;

} FPGA_REGFILE_ARES_QUADRATURE_DECODERPOSTRIGGER_TYPE;


/**************************************************************************
* Register name : decodercntrlatch_cfg
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0                  : 4;  /* Bits(3:0), Reserved */
      M_UINT32 decodercntrlatch_act   : 2;  /* Bits(5:4), null */
      M_UINT32 rsvd1                  : 2;  /* Bits(7:6), Reserved */
      M_UINT32 decodercntrlatch_en    : 1;  /* Bits(8:8), null */
      M_UINT32 rsvd2                  : 7;  /* Bits(15:9), Reserved */
      M_UINT32 decodercntrlatch_src   : 5;  /* Bits(20:16), null */
      M_UINT32 rsvd3                  : 3;  /* Bits(23:21), Reserved */
      M_UINT32 decodercntrlatch_sw    : 1;  /* Bits(24:24), null */
      M_UINT32 rsvd4                  : 7;  /* Bits(31:25), Reserved */
      M_UINT32 rsvd_register_space[7] ;     /* Reserved space below */
   } f;

} FPGA_REGFILE_ARES_QUADRATURE_DECODERCNTRLATCH_CFG_TYPE;


/**************************************************************************
* Register name : decodercntrlatched_sw
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 decodercntr : 32;  /* Bits(31:0), null */
   } f;

} FPGA_REGFILE_ARES_QUADRATURE_DECODERCNTRLATCHED_SW_TYPE;


/**************************************************************************
* Register name : decodercntrlatched
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 decodercntr : 32;  /* Bits(31:0), null */
   } f;

} FPGA_REGFILE_ARES_QUADRATURE_DECODERCNTRLATCHED_TYPE;


/**************************************************************************
* Register name : capabilities_ticktbl
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0        : 7;  /* Bits(6:0), Reserved */
      M_UINT32 intnum       : 5;  /* Bits(11:7), null */
      M_UINT32 nb_elements  : 5;  /* Bits(16:12), null */
      M_UINT32 rsvd1        : 3;  /* Bits(19:17), Reserved */
      M_UINT32 feature_rev  : 4;  /* Bits(23:20), null */
      M_UINT32 ticktable_id : 8;  /* Bits(31:24), null */
   } f;

} FPGA_REGFILE_ARES_TICKTABLE_CAPABILITIES_TICKTBL_TYPE;


/**************************************************************************
* Register name : capabilities_ext1
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 table_width : 8;   /* Bits(7:0), null */
      M_UINT32 nb_latch    : 4;   /* Bits(11:8), null */
      M_UINT32 rsvd0       : 20;  /* Bits(31:12), Reserved */
   } f;

} FPGA_REGFILE_ARES_TICKTABLE_CAPABILITIES_EXT1_TYPE;


/**************************************************************************
* Register name : ticktableclockperiod
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 period_ns : 8;   /* Bits(7:0), null */
      M_UINT32 rsvd0     : 24;  /* Bits(31:8), Reserved */
   } f;

} FPGA_REGFILE_ARES_TICKTABLE_TICKTABLECLOCKPERIOD_TYPE;


/**************************************************************************
* Register name : tickconfig
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 resettimestamp      : 1;  /* Bits(0:0), null */
      M_UINT32 latchcurrentstamp   : 1;  /* Bits(1:1), null */
      M_UINT32 intclock_en         : 1;  /* Bits(2:2), null */
      M_UINT32 enablehalftableint  : 1;  /* Bits(3:3), null */
      M_UINT32 tickclockactivation : 2;  /* Bits(5:4), null */
      M_UINT32 intclock_sel        : 2;  /* Bits(7:6), null */
      M_UINT32 tickclock           : 4;  /* Bits(11:8), null */
      M_UINT32 rsvd0               : 4;  /* Bits(15:12), Reserved */
      M_UINT32 clearmask           : 8;  /* Bits(23:16), Clear command Mask */
      M_UINT32 rsvd1               : 4;  /* Bits(27:24), Reserved */
      M_UINT32 clearticktable      : 1;  /* Bits(28:28), Clear command in Tick Table */
      M_UINT32 rsvd2               : 3;  /* Bits(31:29), Reserved */
   } f;

} FPGA_REGFILE_ARES_TICKTABLE_TICKCONFIG_TYPE;


/**************************************************************************
* Register name : currentstamplatched
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 currentstamp : 32;  /* Bits(31:0), null */
   } f;

} FPGA_REGFILE_ARES_TICKTABLE_CURRENTSTAMPLATCHED_TYPE;


/**************************************************************************
* Register name : writetime
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 writetime : 32;  /* Bits(31:0), null */
   } f;

} FPGA_REGFILE_ARES_TICKTABLE_WRITETIME_TYPE;


/**************************************************************************
* Register name : writecommand
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 bitnum             : 2;   /* Bits(1:0), null */
      M_UINT32 rsvd0              : 3;   /* Bits(4:2), Reserved */
      M_UINT32 bitcmd             : 2;   /* Bits(6:5), null */
      M_UINT32 rsvd1              : 1;   /* Bits(7:7), Reserved */
      M_UINT32 executeimmwrite    : 1;   /* Bits(8:8), null */
      M_UINT32 executefuturewrite : 1;   /* Bits(9:9), null */
      M_UINT32 rsvd2              : 2;   /* Bits(11:10), Reserved */
      M_UINT32 writestatus        : 1;   /* Bits(12:12), null */
      M_UINT32 writedone          : 1;   /* Bits(13:13), null */
      M_UINT32 rsvd3              : 18;  /* Bits(31:14), Reserved */
   } f;

} FPGA_REGFILE_ARES_TICKTABLE_WRITECOMMAND_TYPE;


/**************************************************************************
* Register name : latchintstat
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 latchintstat : 2;   /* Bits(1:0), null */
      M_UINT32 rsvd0        : 30;  /* Bits(31:2), Reserved */
   } f;

} FPGA_REGFILE_ARES_TICKTABLE_LATCHINTSTAT_TYPE;


/**************************************************************************
* Register name : inputstamp
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0                : 4;   /* Bits(3:0), Reserved */
      M_UINT32 inputstampactivation : 2;   /* Bits(5:4), null */
      M_UINT32 rsvd1                : 2;   /* Bits(7:6), Reserved */
      M_UINT32 latchinputstamp_en   : 1;   /* Bits(8:8), null */
      M_UINT32 latchinputintenable  : 1;   /* Bits(9:9), null */
      M_UINT32 rsvd2                : 6;   /* Bits(15:10), Reserved */
      M_UINT32 inputstampsource     : 4;   /* Bits(19:16), null */
      M_UINT32 rsvd3                : 12;  /* Bits(31:20), Reserved */
   } f;

} FPGA_REGFILE_ARES_TICKTABLE_INPUTSTAMP_TYPE;


/**************************************************************************
* Register name : reserved_for_extra_latch
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 reserved_for_extra_latch : 1;   /* Bits(0:0), null */
      M_UINT32 rsvd0                    : 31;  /* Bits(31:1), Reserved */
   } f;

} FPGA_REGFILE_ARES_TICKTABLE_RESERVED_FOR_EXTRA_LATCH_TYPE;


/**************************************************************************
* Register name : inputstamplatched
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 inputstamp : 32;  /* Bits(31:0), null */
   } f;

} FPGA_REGFILE_ARES_TICKTABLE_INPUTSTAMPLATCHED_TYPE;


/**************************************************************************
* Register name : capabilities_incond
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 period_ns    : 8;  /* Bits(7:0), null */
      M_UINT32 rsvd0        : 4;  /* Bits(11:8), Reserved */
      M_UINT32 nb_inputs    : 5;  /* Bits(16:12), null */
      M_UINT32 rsvd1        : 3;  /* Bits(19:17), Reserved */
      M_UINT32 feature_rev  : 4;  /* Bits(23:20), null */
      M_UINT32 inputcond_id : 8;  /* Bits(31:24), null */
   } f;

} FPGA_REGFILE_ARES_INPUTCONDITIONING_CAPABILITIES_INCOND_TYPE;


/**************************************************************************
* Register name : inputconditioning
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 inputpol        : 1;   /* Bits(0:0), null */
      M_UINT32 inputfiltering  : 1;   /* Bits(1:1), null */
      M_UINT32 rsvd0           : 6;   /* Bits(7:2), Reserved */
      M_UINT32 debounceholdoff : 24;  /* Bits(31:8), null */
   } f;

} FPGA_REGFILE_ARES_INPUTCONDITIONING_INPUTCONDITIONING_TYPE;


/**************************************************************************
* Register name : capabilities_outcond
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0         : 12;  /* Bits(11:0), Reserved */
      M_UINT32 nb_outputs    : 5;   /* Bits(16:12), null */
      M_UINT32 rsvd1         : 3;   /* Bits(19:17), Reserved */
      M_UINT32 feature_rev   : 4;   /* Bits(23:20), null */
      M_UINT32 outputcond_id : 8;   /* Bits(31:24), null */
   } f;

} FPGA_REGFILE_ARES_OUTPUTCONDITIONING_CAPABILITIES_OUTCOND_TYPE;


/**************************************************************************
* Register name : outputcond
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 outsel    : 6;   /* Bits(5:0), null */
      M_UINT32 rsvd0     : 1;   /* Bits(6:6), Reserved */
      M_UINT32 outputpol : 1;   /* Bits(7:7), null */
      M_UINT32 rsvd1     : 8;   /* Bits(15:8), Reserved */
      M_UINT32 outputval : 1;   /* Bits(16:16), Output Value */
      M_UINT32 rsvd2     : 15;  /* Bits(31:17), Reserved */
   } f;

} FPGA_REGFILE_ARES_OUTPUTCONDITIONING_OUTPUTCOND_TYPE;


/**************************************************************************
* Register name : reserved
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 reserved               : 8;   /* Bits(7:0), null */
      M_UINT32 rsvd0                  : 24;  /* Bits(31:8), Reserved */
      M_UINT32 rsvd_register_space[5] ;      /* Reserved space below */
   } f;

} FPGA_REGFILE_ARES_OUTPUTCONDITIONING_RESERVED_TYPE;


/**************************************************************************
* Register name : output_debounce
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 output_holdoff_reg_cntr : 10;  /* Bits(9:0), null */
      M_UINT32 rsvd0                   : 6;   /* Bits(15:10), Reserved */
      M_UINT32 output_holdoff_reg_en   : 1;   /* Bits(16:16), null */
      M_UINT32 rsvd1                   : 15;  /* Bits(31:17), Reserved */
   } f;

} FPGA_REGFILE_ARES_OUTPUTCONDITIONING_OUTPUT_DEBOUNCE_TYPE;


/**************************************************************************
* Register name : capabilities_int_inp
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0        : 12;  /* Bits(11:0), Reserved */
      M_UINT32 nb_inputs    : 5;   /* Bits(16:12), null */
      M_UINT32 rsvd1        : 3;   /* Bits(19:17), Reserved */
      M_UINT32 feature_rev  : 4;   /* Bits(23:20), null */
      M_UINT32 int_input_id : 8;   /* Bits(31:24), null */
   } f;

} FPGA_REGFILE_ARES_INTERNALINPUT_CAPABILITIES_INT_INP_TYPE;


/**************************************************************************
* Register name : capabilities_intout
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0         : 12;  /* Bits(11:0), Reserved */
      M_UINT32 nb_outputs    : 5;   /* Bits(16:12), null */
      M_UINT32 rsvd1         : 3;   /* Bits(19:17), Reserved */
      M_UINT32 feature_rev   : 4;   /* Bits(23:20), null */
      M_UINT32 int_output_id : 8;   /* Bits(31:24), null */
   } f;

} FPGA_REGFILE_ARES_INTERNALOUTPUT_CAPABILITIES_INTOUT_TYPE;


/**************************************************************************
* Register name : outputcond
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 outsel    : 6;   /* Bits(5:0), null */
      M_UINT32 rsvd0     : 10;  /* Bits(15:6), Reserved */
      M_UINT32 outputval : 1;   /* Bits(16:16), Output Value */
      M_UINT32 rsvd1     : 15;  /* Bits(31:17), Reserved */
   } f;

} FPGA_REGFILE_ARES_INTERNALOUTPUT_OUTPUTCOND_TYPE;


/**************************************************************************
* Register name : capabilities_timer
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0       : 7;  /* Bits(6:0), Reserved */
      M_UINT32 intnum      : 5;  /* Bits(11:7), null */
      M_UINT32 rsvd1       : 8;  /* Bits(19:12), Reserved */
      M_UINT32 feature_rev : 4;  /* Bits(23:20), null */
      M_UINT32 timer_id    : 8;  /* Bits(31:24), null */
   } f;

} FPGA_REGFILE_ARES_TIMER_CAPABILITIES_TIMER_TYPE;


/**************************************************************************
* Register name : timerclockperiod
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 period_ns : 16;  /* Bits(15:0), null */
      M_UINT32 rsvd0     : 16;  /* Bits(31:16), Reserved */
   } f;

} FPGA_REGFILE_ARES_TIMER_TIMERCLOCKPERIOD_TYPE;


/**************************************************************************
* Register name : timertriggerarm
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 timertriggeractivation : 3;  /* Bits(2:0), null */
      M_UINT32 timertriggersource     : 6;  /* Bits(8:3), null */
      M_UINT32 timertriggerlogicdsel  : 2;  /* Bits(10:9), null */
      M_UINT32 timertriggerlogicesel  : 2;  /* Bits(12:11), null */
      M_UINT32 rsvd0                  : 1;  /* Bits(13:13), Reserved */
      M_UINT32 timermesurement        : 1;  /* Bits(14:14), null */
      M_UINT32 soft_timertrigger      : 1;  /* Bits(15:15), null */
      M_UINT32 timerarmactivation     : 3;  /* Bits(18:16), null */
      M_UINT32 timerarmsource         : 5;  /* Bits(23:19), null */
      M_UINT32 timerarmenable         : 1;  /* Bits(24:24), null */
      M_UINT32 timertriggeroverlap    : 2;  /* Bits(26:25), null */
      M_UINT32 rsvd1                  : 4;  /* Bits(30:27), Reserved */
      M_UINT32 soft_timerarm          : 1;  /* Bits(31:31), null */
   } f;

} FPGA_REGFILE_ARES_TIMER_TIMERTRIGGERARM_TYPE;


/**************************************************************************
* Register name : timerclocksource
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 timerclocksource     : 4;   /* Bits(3:0), null */
      M_UINT32 timerclockactivation : 2;   /* Bits(5:4), null */
      M_UINT32 rsvd0                : 2;   /* Bits(7:6), Reserved */
      M_UINT32 delayclocksource     : 4;   /* Bits(11:8), null */
      M_UINT32 delayclockactivation : 2;   /* Bits(13:12), null */
      M_UINT32 rsvd1                : 2;   /* Bits(15:14), Reserved */
      M_UINT32 intclock_sel         : 2;   /* Bits(17:16), null */
      M_UINT32 rsvd2                : 14;  /* Bits(31:18), Reserved */
   } f;

} FPGA_REGFILE_ARES_TIMER_TIMERCLOCKSOURCE_TYPE;


/**************************************************************************
* Register name : timerdelayvalue
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 timerdelayvalue : 32;  /* Bits(31:0), null */
   } f;

} FPGA_REGFILE_ARES_TIMER_TIMERDELAYVALUE_TYPE;


/**************************************************************************
* Register name : timerduration
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 timerduration : 32;  /* Bits(31:0), null */
   } f;

} FPGA_REGFILE_ARES_TIMER_TIMERDURATION_TYPE;


/**************************************************************************
* Register name : timerlatchedvalue
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 timerlatchedvalue : 32;  /* Bits(31:0), null */
   } f;

} FPGA_REGFILE_ARES_TIMER_TIMERLATCHEDVALUE_TYPE;


/**************************************************************************
* Register name : timerstatus
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 timerenable         : 1;  /* Bits(0:0), null */
      M_UINT32 timerinversion      : 1;  /* Bits(1:1), null */
      M_UINT32 rsvd0               : 6;  /* Bits(7:2), Reserved */
      M_UINT32 timercntrreset      : 1;  /* Bits(8:8), null */
      M_UINT32 timerlatchvalue     : 1;  /* Bits(9:9), null */
      M_UINT32 timerlatchandreset  : 1;  /* Bits(10:10), null */
      M_UINT32 rsvd1               : 5;  /* Bits(15:11), Reserved */
      M_UINT32 timerstartintmaskn  : 1;  /* Bits(16:16), null */
      M_UINT32 timerendintmaskn    : 1;  /* Bits(17:17), null */
      M_UINT32 rsvd2               : 8;  /* Bits(25:18), Reserved */
      M_UINT32 timerstatus_latched : 3;  /* Bits(28:26), null */
      M_UINT32 timerstatus         : 3;  /* Bits(31:29), null */
   } f;

} FPGA_REGFILE_ARES_TIMER_TIMERSTATUS_TYPE;


/**************************************************************************
* Register name : capabilities_micro
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0       : 15;  /* Bits(14:0), Reserved */
      M_UINT32 intnum      : 5;   /* Bits(19:15), null */
      M_UINT32 feature_rev : 4;   /* Bits(23:20), null */
      M_UINT32 micro_id    : 8;   /* Bits(31:24), null */
   } f;

} FPGA_REGFILE_ARES_MICROBLAZE_CAPABILITIES_MICRO_TYPE;


/**************************************************************************
* Register name : prodcons
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 offset     : 20;  /* Bits(19:0), null */
      M_UINT32 memorysize : 5;   /* Bits(24:20), null */
      M_UINT32 rsvd0      : 7;   /* Bits(31:25), Reserved */
   } f;

} FPGA_REGFILE_ARES_MICROBLAZE_PRODCONS_TYPE;


/**************************************************************************
* Register name : capabilities_ana_out
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0       : 12;  /* Bits(11:0), Reserved */
      M_UINT32 nb_outputs  : 4;   /* Bits(15:12), null */
      M_UINT32 rsvd1       : 4;   /* Bits(19:16), Reserved */
      M_UINT32 feature_rev : 4;   /* Bits(23:20), null */
      M_UINT32 ana_out_id  : 8;   /* Bits(31:24), null */
   } f;

} FPGA_REGFILE_ARES_ANALOGOUTPUT_CAPABILITIES_ANA_OUT_TYPE;


/**************************************************************************
* Register name : outputvalue
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 outputval : 8;   /* Bits(7:0), */
      M_UINT32 rsvd0     : 24;  /* Bits(31:8), Reserved */
   } f;

} FPGA_REGFILE_ARES_ANALOGOUTPUT_OUTPUTVALUE_TYPE;


/**************************************************************************
* Register name : eofm
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 24;  /* Bits(23:0), Reserved */
      M_UINT32 eofm  : 8;   /* Bits(31:24), null */
   } f;

} FPGA_REGFILE_ARES_EOFM_EOFM_TYPE;


/**************************************************************************
* Register name : pointers
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 input_free_start          : 8;  /* Bits(7:0), */
      M_UINT32 input_free_end            : 8;  /* Bits(15:8), */
      M_UINT32 output_free_start         : 8;  /* Bits(23:16), */
      M_UINT32 output_free_end           : 8;  /* Bits(31:24), */
      M_UINT32 rsvd_register_space[1023] ;     /* Reserved space below */
   } f;

} FPGA_REGFILE_ARES_PRODCONS_POINTERS_TYPE;


/**************************************************************************
* Register name : dpram
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 data : 32;  /* Bits(31:0), null */
   } f;

} FPGA_REGFILE_ARES_PRODCONS_DPRAM_TYPE;


/**************************************************************************
* Section name   : device_specific
***************************************************************************/
typedef struct
{
   FPGA_REGFILE_ARES_DEVICE_SPECIFIC_INTSTAT_TYPE      intstat;       /* Address offset: 0x0 */
   FPGA_REGFILE_ARES_DEVICE_SPECIFIC_INTMASKN_TYPE     intmaskn;      /* Address offset: 0x4 */
   FPGA_REGFILE_ARES_DEVICE_SPECIFIC_INTSTAT2_TYPE     intstat2;      /* Address offset: 0x8 */
   FPGA_REGFILE_ARES_DEVICE_SPECIFIC_BUILDID_TYPE      buildid;       /* Address offset: 0x1c */
   FPGA_REGFILE_ARES_DEVICE_SPECIFIC_FPGA_ID_TYPE      fpga_id;       /* Address offset: 0x20 */
   FPGA_REGFILE_ARES_DEVICE_SPECIFIC_LED_OVERRIDE_TYPE led_override;  /* Address offset: 0x24 */
} FPGA_REGFILE_ARES_DEVICE_SPECIFIC_TYPE;

/**************************************************************************
* Section name   : interrupt_queue
***************************************************************************/
typedef struct
{
   FPGA_REGFILE_ARES_INTERRUPT_QUEUE_CONTROL_TYPE   control;    /* Address offset: 0x0 */
   FPGA_REGFILE_ARES_INTERRUPT_QUEUE_CONS_IDX_TYPE  cons_idx;   /* Address offset: 0x4 */
   FPGA_REGFILE_ARES_INTERRUPT_QUEUE_ADDR_LOW_TYPE  addr_low;   /* Address offset: 0x8 */
   FPGA_REGFILE_ARES_INTERRUPT_QUEUE_ADDR_HIGH_TYPE addr_high;  /* Address offset: 0xc */
   FPGA_REGFILE_ARES_INTERRUPT_QUEUE_MAPPING_TYPE   mapping;    /* Address offset: 0x10 */
} FPGA_REGFILE_ARES_INTERRUPT_QUEUE_TYPE;

/**************************************************************************
* Section name   : tlp
***************************************************************************/
typedef struct
{
   FPGA_REGFILE_ARES_TLP_TIMEOUT_TYPE                timeout;                 /* Address offset: 0x0 */
   FPGA_REGFILE_ARES_TLP_TRANSACTION_ABORT_CNTR_TYPE transaction_abort_cntr;  /* Address offset: 0x4 */
} FPGA_REGFILE_ARES_TLP_TYPE;

/**************************************************************************
* Section name   : spi
***************************************************************************/
typedef struct
{
   FPGA_REGFILE_ARES_SPI_SPIREGIN_TYPE  spiregin;   /* Address offset: 0x0 */
   FPGA_REGFILE_ARES_SPI_SPIREGOUT_TYPE spiregout;  /* Address offset: 0x8 */
} FPGA_REGFILE_ARES_SPI_TYPE;

/**************************************************************************
* Section name   : arbiter
***************************************************************************/
typedef struct
{
   FPGA_REGFILE_ARES_ARBITER_ARBITER_CAPABILITIES_TYPE arbiter_capabilities;  /* Address offset: 0x0 */
   FPGA_REGFILE_ARES_ARBITER_AGENT_TYPE                agent[2];              /* Address offset: 0x4 */
} FPGA_REGFILE_ARES_ARBITER_TYPE;

/**************************************************************************
* Section name   : axi_window
***************************************************************************/
typedef struct
{
   FPGA_REGFILE_ARES_AXI_WINDOW_CTRL_TYPE            ctrl;             /* Address offset: 0x0 */
   FPGA_REGFILE_ARES_AXI_WINDOW_PCI_BAR0_START_TYPE  pci_bar0_start;   /* Address offset: 0x4 */
   FPGA_REGFILE_ARES_AXI_WINDOW_PCI_BAR0_STOP_TYPE   pci_bar0_stop;    /* Address offset: 0x8 */
   FPGA_REGFILE_ARES_AXI_WINDOW_AXI_TRANSLATION_TYPE axi_translation;  /* Address offset: 0xc */
} FPGA_REGFILE_ARES_AXI_WINDOW_TYPE;

/**************************************************************************
* Section name   : io
***************************************************************************/
typedef struct
{
   FPGA_REGFILE_ARES_IO_CAPABILITIES_IO_TYPE capabilities_io;  /* Address offset: 0x0 */
   FPGA_REGFILE_ARES_IO_IO_PIN_TYPE          io_pin;           /* Address offset: 0x4 */
   FPGA_REGFILE_ARES_IO_IO_OUT_TYPE          io_out;           /* Address offset: 0x8 */
   FPGA_REGFILE_ARES_IO_IO_DIR_TYPE          io_dir;           /* Address offset: 0xc */
   FPGA_REGFILE_ARES_IO_IO_POL_TYPE          io_pol;           /* Address offset: 0x10 */
   FPGA_REGFILE_ARES_IO_IO_INTSTAT_TYPE      io_intstat;       /* Address offset: 0x14 */
   FPGA_REGFILE_ARES_IO_IO_INTMASKN_TYPE     io_intmaskn;      /* Address offset: 0x18 */
   FPGA_REGFILE_ARES_IO_IO_ANYEDGE_TYPE      io_anyedge;       /* Address offset: 0x1c */
   M_UINT32                                  rsvd[24];         /* Reserved space (24 x M_UINT32) */
} FPGA_REGFILE_ARES_IO_TYPE;

/**************************************************************************
* Section name   : quadrature
***************************************************************************/
typedef struct
{
   FPGA_REGFILE_ARES_QUADRATURE_CAPABILITIES_QUAD_TYPE     capabilities_quad;      /* Address offset: 0x0 */
   FPGA_REGFILE_ARES_QUADRATURE_POSITIONRESET_TYPE         positionreset;          /* Address offset: 0x4 */
   FPGA_REGFILE_ARES_QUADRATURE_DECODERINPUT_TYPE          decoderinput;           /* Address offset: 0x8 */
   FPGA_REGFILE_ARES_QUADRATURE_DECODERCFG_TYPE            decodercfg;             /* Address offset: 0xc */
   FPGA_REGFILE_ARES_QUADRATURE_DECODERPOSTRIGGER_TYPE     decoderpostrigger;      /* Address offset: 0x10 */
   FPGA_REGFILE_ARES_QUADRATURE_DECODERCNTRLATCH_CFG_TYPE  decodercntrlatch_cfg;   /* Address offset: 0x14 */
   FPGA_REGFILE_ARES_QUADRATURE_DECODERCNTRLATCHED_SW_TYPE decodercntrlatched_sw;  /* Address offset: 0x34 */
   FPGA_REGFILE_ARES_QUADRATURE_DECODERCNTRLATCHED_TYPE    decodercntrlatched;     /* Address offset: 0x38 */
   M_UINT32                                                rsvd[17];               /* Reserved space (17 x M_UINT32) */
} FPGA_REGFILE_ARES_QUADRATURE_TYPE;

/**************************************************************************
* Section name   : ticktable
***************************************************************************/
typedef struct
{
   FPGA_REGFILE_ARES_TICKTABLE_CAPABILITIES_TICKTBL_TYPE     capabilities_ticktbl;          /* Address offset: 0x0 */
   FPGA_REGFILE_ARES_TICKTABLE_CAPABILITIES_EXT1_TYPE        capabilities_ext1;             /* Address offset: 0x4 */
   FPGA_REGFILE_ARES_TICKTABLE_TICKTABLECLOCKPERIOD_TYPE     ticktableclockperiod;          /* Address offset: 0x8 */
   FPGA_REGFILE_ARES_TICKTABLE_TICKCONFIG_TYPE               tickconfig;                    /* Address offset: 0xc */
   FPGA_REGFILE_ARES_TICKTABLE_CURRENTSTAMPLATCHED_TYPE      currentstamplatched;           /* Address offset: 0x10 */
   FPGA_REGFILE_ARES_TICKTABLE_WRITETIME_TYPE                writetime;                     /* Address offset: 0x14 */
   FPGA_REGFILE_ARES_TICKTABLE_WRITECOMMAND_TYPE             writecommand;                  /* Address offset: 0x18 */
   FPGA_REGFILE_ARES_TICKTABLE_LATCHINTSTAT_TYPE             latchintstat;                  /* Address offset: 0x1c */
   FPGA_REGFILE_ARES_TICKTABLE_INPUTSTAMP_TYPE               inputstamp[2];                 /* Address offset: 0x20 */
   FPGA_REGFILE_ARES_TICKTABLE_RESERVED_FOR_EXTRA_LATCH_TYPE reserved_for_extra_latch[10];  /* Address offset: 0x28 */
   FPGA_REGFILE_ARES_TICKTABLE_INPUTSTAMPLATCHED_TYPE        inputstamplatched[2];          /* Address offset: 0x50 */
   M_UINT32                                                  rsvd[10];                      /* Reserved space (10 x M_UINT32) */
} FPGA_REGFILE_ARES_TICKTABLE_TYPE;

/**************************************************************************
* Section name   : inputconditioning
***************************************************************************/
typedef struct
{
   FPGA_REGFILE_ARES_INPUTCONDITIONING_CAPABILITIES_INCOND_TYPE capabilities_incond;   /* Address offset: 0x0 */
   FPGA_REGFILE_ARES_INPUTCONDITIONING_INPUTCONDITIONING_TYPE   inputconditioning[4];  /* Address offset: 0x4 */
   M_UINT32                                                     rsvd[27];              /* Reserved space (27 x M_UINT32) */
} FPGA_REGFILE_ARES_INPUTCONDITIONING_TYPE;

/**************************************************************************
* Section name   : outputconditioning
***************************************************************************/
typedef struct
{
   FPGA_REGFILE_ARES_OUTPUTCONDITIONING_CAPABILITIES_OUTCOND_TYPE capabilities_outcond;  /* Address offset: 0x0 */
   FPGA_REGFILE_ARES_OUTPUTCONDITIONING_OUTPUTCOND_TYPE           outputcond[4];         /* Address offset: 0x4 */
   FPGA_REGFILE_ARES_OUTPUTCONDITIONING_RESERVED_TYPE             reserved;              /* Address offset: 0x14 */
   FPGA_REGFILE_ARES_OUTPUTCONDITIONING_OUTPUT_DEBOUNCE_TYPE      output_debounce;       /* Address offset: 0x2c */
   M_UINT32                                                       rsvd[20];              /* Reserved space (20 x M_UINT32) */
} FPGA_REGFILE_ARES_OUTPUTCONDITIONING_TYPE;

/**************************************************************************
* Section name   : internalinput
***************************************************************************/
typedef struct
{
   FPGA_REGFILE_ARES_INTERNALINPUT_CAPABILITIES_INT_INP_TYPE capabilities_int_inp;  /* Address offset: 0x0 */
   M_UINT32                                                  rsvd[31];              /* Reserved space (31 x M_UINT32) */
} FPGA_REGFILE_ARES_INTERNALINPUT_TYPE;

/**************************************************************************
* Section name   : internaloutput
***************************************************************************/
typedef struct
{
   FPGA_REGFILE_ARES_INTERNALOUTPUT_CAPABILITIES_INTOUT_TYPE capabilities_intout;  /* Address offset: 0x0 */
   FPGA_REGFILE_ARES_INTERNALOUTPUT_OUTPUTCOND_TYPE          outputcond[1];        /* Address offset: 0x4 */
   M_UINT32                                                  rsvd[30];             /* Reserved space (30 x M_UINT32) */
} FPGA_REGFILE_ARES_INTERNALOUTPUT_TYPE;

/**************************************************************************
* Section name   : timer
***************************************************************************/
typedef struct
{
   FPGA_REGFILE_ARES_TIMER_CAPABILITIES_TIMER_TYPE capabilities_timer;  /* Address offset: 0x0 */
   FPGA_REGFILE_ARES_TIMER_TIMERCLOCKPERIOD_TYPE   timerclockperiod;    /* Address offset: 0x4 */
   FPGA_REGFILE_ARES_TIMER_TIMERTRIGGERARM_TYPE    timertriggerarm;     /* Address offset: 0x8 */
   FPGA_REGFILE_ARES_TIMER_TIMERCLOCKSOURCE_TYPE   timerclocksource;    /* Address offset: 0xc */
   FPGA_REGFILE_ARES_TIMER_TIMERDELAYVALUE_TYPE    timerdelayvalue;     /* Address offset: 0x10 */
   FPGA_REGFILE_ARES_TIMER_TIMERDURATION_TYPE      timerduration;       /* Address offset: 0x14 */
   FPGA_REGFILE_ARES_TIMER_TIMERLATCHEDVALUE_TYPE  timerlatchedvalue;   /* Address offset: 0x18 */
   FPGA_REGFILE_ARES_TIMER_TIMERSTATUS_TYPE        timerstatus;         /* Address offset: 0x1c */
   M_UINT32                                        rsvd[24];            /* Reserved space (24 x M_UINT32) */
} FPGA_REGFILE_ARES_TIMER_TYPE;

/**************************************************************************
* Section name   : microblaze
***************************************************************************/
typedef struct
{
   FPGA_REGFILE_ARES_MICROBLAZE_CAPABILITIES_MICRO_TYPE capabilities_micro;  /* Address offset: 0x0 */
   FPGA_REGFILE_ARES_MICROBLAZE_PRODCONS_TYPE           prodcons[2];         /* Address offset: 0x4 */
   M_UINT32                                             rsvd[29];            /* Reserved space (29 x M_UINT32) */
} FPGA_REGFILE_ARES_MICROBLAZE_TYPE;

/**************************************************************************
* Section name   : analogoutput
***************************************************************************/
typedef struct
{
   FPGA_REGFILE_ARES_ANALOGOUTPUT_CAPABILITIES_ANA_OUT_TYPE capabilities_ana_out;  /* Address offset: 0x0 */
   FPGA_REGFILE_ARES_ANALOGOUTPUT_OUTPUTVALUE_TYPE          outputvalue;           /* Address offset: 0x4 */
   M_UINT32                                                 rsvd[30];              /* Reserved space (30 x M_UINT32) */
} FPGA_REGFILE_ARES_ANALOGOUTPUT_TYPE;

/**************************************************************************
* Section name   : eofm
***************************************************************************/
typedef struct
{
   FPGA_REGFILE_ARES_EOFM_EOFM_TYPE eofm;  /* Address offset: 0x0 */
} FPGA_REGFILE_ARES_EOFM_TYPE;

/**************************************************************************
* External section name   : PRODCONS
***************************************************************************/
typedef struct
{
   FPGA_REGFILE_ARES_PRODCONS_POINTERS_TYPE pointers;     /* Address offset: 0x0 */
   FPGA_REGFILE_ARES_PRODCONS_DPRAM_TYPE    dpram[1024];  /* Address offset: 0x1000 */
} FPGA_REGFILE_ARES_PRODCONS_TYPE;


/**************************************************************************
* Register file name : regfile_ares
***************************************************************************/
typedef struct
{
   FPGA_REGFILE_ARES_DEVICE_SPECIFIC_TYPE    device_specific;     /* Section; Base address offset: 0x0 */
   M_UINT32                                  rsvd0[6];            /* Padding; Size (24 Bytes) */
   FPGA_REGFILE_ARES_INTERRUPT_QUEUE_TYPE    interrupt_queue;     /* Section; Base address offset: 0x40 */
   M_UINT32                                  rsvd1[7];            /* Padding; Size (28 Bytes) */
   FPGA_REGFILE_ARES_TLP_TYPE                tlp;                 /* Section; Base address offset: 0x70 */
   M_UINT32                                  rsvd2[26];           /* Padding; Size (104 Bytes) */
   FPGA_REGFILE_ARES_SPI_TYPE                spi;                 /* Section; Base address offset: 0xe0 */
   FPGA_REGFILE_ARES_ARBITER_TYPE            arbiter;             /* Section; Base address offset: 0xf0 */
   M_UINT32                                  rsvd3[1];            /* Padding; Size (4 Bytes) */
   FPGA_REGFILE_ARES_AXI_WINDOW_TYPE         axi_window[4];       /* Section; Base address offset: 0x100 */
   M_UINT32                                  rsvd4[48];           /* Padding; Size (192 Bytes) */
   FPGA_REGFILE_ARES_IO_TYPE                 io[2];               /* Section; Base address offset: 0x200 */
   FPGA_REGFILE_ARES_QUADRATURE_TYPE         quadrature[1];       /* Section; Base address offset: 0x300 */
   FPGA_REGFILE_ARES_TICKTABLE_TYPE          ticktable[1];        /* Section; Base address offset: 0x380 */
   FPGA_REGFILE_ARES_INPUTCONDITIONING_TYPE  inputconditioning;   /* Section; Base address offset: 0x400 */
   FPGA_REGFILE_ARES_OUTPUTCONDITIONING_TYPE outputconditioning;  /* Section; Base address offset: 0x480 */
   FPGA_REGFILE_ARES_INTERNALINPUT_TYPE      internalinput;       /* Section; Base address offset: 0x500 */
   FPGA_REGFILE_ARES_INTERNALOUTPUT_TYPE     internaloutput;      /* Section; Base address offset: 0x580 */
   FPGA_REGFILE_ARES_TIMER_TYPE              timer[8];            /* Section; Base address offset: 0x600 */
   FPGA_REGFILE_ARES_MICROBLAZE_TYPE         microblaze;          /* Section; Base address offset: 0xa00 */
   FPGA_REGFILE_ARES_ANALOGOUTPUT_TYPE       analogoutput;        /* Section; Base address offset: 0xa80 */
   FPGA_REGFILE_ARES_EOFM_TYPE               eofm;                /* Section; Base address offset: 0xb00 */
   M_UINT32                                  rsvd5[1343];         /* Padding; Size (5372 Bytes) */
   FPGA_REGFILE_ARES_PRODCONS_TYPE           prodcons[2];         /* External section; Base address offset: 0x2000 */
} FPGA_REGFILE_ARES_TYPE;



#endif
