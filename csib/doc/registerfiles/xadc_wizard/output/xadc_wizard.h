/**************************************************************************
*
* File name    :  xadc_wizard.h
*
* Content      :  This file contains the register structures for the
*                 fpga xadc_wizard processing unit.
*
* Hardware native endianness: little endian
*
* FDK IDE Version: 4.6.0_beta1
* Build ID: I20160217-1125
*
* COPYRIGHT (c) 2008 Matrox Electronic Systems Ltd.
* All Rights Reserved
*
***************************************************************************/
#ifndef __FPGA_XADC_WIZARD_H__
#define __FPGA_XADC_WIZARD_H__

#include "mbasictypes.h"





/**************************************************************************
* Register address defines
***************************************************************************/
#define FPGA_XADC_WIZARD_LOCAL_REGISTER_SSR_ADDRESS                        0x000
#define FPGA_XADC_WIZARD_LOCAL_REGISTER_SR_ADDRESS                         0x004
#define FPGA_XADC_WIZARD_LOCAL_REGISTER_AOSR_ADDRESS                       0x008
#define FPGA_XADC_WIZARD_LOCAL_REGISTER_CONVSTR_ADDRESS                    0x00C
#define FPGA_XADC_WIZARD_LOCAL_REGISTER_XADC_RESET_ADDRESS                 0x010
#define FPGA_XADC_WIZARD_INTERRUPT_CONTROLLER_GLOBAL_INTERRUPT_ADDRESS     0x05C
#define FPGA_XADC_WIZARD_INTERRUPT_CONTROLLER_INTERRUPT_STATUS_ADDRESS     0x060
#define FPGA_XADC_WIZARD_INTERRUPT_CONTROLLER_INTERRUPT_ENABLE_ADDRESS     0x068
#define FPGA_XADC_WIZARD_XADC_HARD_MACRO_TEMPERATURE_ADDRESS               0x200
#define FPGA_XADC_WIZARD_XADC_HARD_MACRO_VCC_INT_ADDRESS                   0x204
#define FPGA_XADC_WIZARD_XADC_HARD_MACRO_VCC_AUX_ADDRESS                   0x208
#define FPGA_XADC_WIZARD_XADC_HARD_MACRO_VP_VN_ADDRESS                     0x20C
#define FPGA_XADC_WIZARD_XADC_HARD_MACRO_VREF_P_ADDRESS                    0x210
#define FPGA_XADC_WIZARD_XADC_HARD_MACRO_VREF_N_ADDRESS                    0x214
#define FPGA_XADC_WIZARD_XADC_HARD_MACRO_VCC_BRAM_ADDRESS                  0x218
#define FPGA_XADC_WIZARD_XADC_HARD_MACRO_SUPPLY_A_OFFSET_ADDRESS           0x220
#define FPGA_XADC_WIZARD_XADC_HARD_MACRO_ADC_A_OFFSET_ADDRESS              0x224
#define FPGA_XADC_WIZARD_XADC_HARD_MACRO_ADC_A_GAIN_ADDRESS                0x228
#define FPGA_XADC_WIZARD_XADC_HARD_MACRO_VCC_PINT_ADDRESS                  0x234
#define FPGA_XADC_WIZARD_XADC_HARD_MACRO_VCC_PAUX_ADDRESS                  0x238
#define FPGA_XADC_WIZARD_XADC_HARD_MACRO_VCCO_DDR_ADDRESS                  0x23C
#define FPGA_XADC_WIZARD_XADC_HARD_MACRO_VAUX_P_N_ADDRESS                  0x240
#define FPGA_XADC_WIZARD_XADC_HARD_MACRO_MAX_TEMPERATURE_ADDRESS           0x280
#define FPGA_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCC_INT_ADDRESS               0x284
#define FPGA_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCC_AUX_ADDRESS               0x288
#define FPGA_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCC_BRAM_ADDRESS              0x28C
#define FPGA_XADC_WIZARD_XADC_HARD_MACRO_MIN_TEMPERATURE_ADDRESS           0x290
#define FPGA_XADC_WIZARD_XADC_HARD_MACRO_MIN_VCC_INT_ADDRESS               0x294
#define FPGA_XADC_WIZARD_XADC_HARD_MACRO_MIN_VCC_AUX_ADDRESS               0x298
#define FPGA_XADC_WIZARD_XADC_HARD_MACRO_MIN_VCC_BRAM_ADDRESS              0x29C
#define FPGA_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCC_PINT_ADDRESS              0x2A0
#define FPGA_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCC_PAUX_ADDRESS              0x2A4
#define FPGA_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCCO_DDR_ADDRESS              0x2A8
#define FPGA_XADC_WIZARD_XADC_HARD_MACRO_MIN_VCC_PINT_ADDRESS              0x2B0
#define FPGA_XADC_WIZARD_XADC_HARD_MACRO_MIN_VCC_PAUX_ADDRESS              0x2B4
#define FPGA_XADC_WIZARD_XADC_HARD_MACRO_MAIN_VCCO_DDR_ADDRESS             0x2B8
#define FPGA_XADC_WIZARD_XADC_HARD_MACRO_SUPPLY_B_OFFSET_ADDRESS           0x2C0
#define FPGA_XADC_WIZARD_XADC_HARD_MACRO_ADC_B_OFFSET_ADDRESS              0x2C4
#define FPGA_XADC_WIZARD_XADC_HARD_MACRO_ADC_B_GAIN_ADDRESS                0x2C8
#define FPGA_XADC_WIZARD_XADC_HARD_MACRO_FLAG_ADDRESS                      0x2D4
#define FPGA_XADC_WIZARD_CONTROL_CONFIG_0_ADDRESS                          0x300
#define FPGA_XADC_WIZARD_CONTROL_CONFIG_1_ADDRESS                          0x304
#define FPGA_XADC_WIZARD_CONTROL_CONFIG_2_ADDRESS                          0x308
#define FPGA_XADC_WIZARD_ALARM_TRESHOLDS_TEMPERATURE_UPPER_ADDRESS         0x340
#define FPGA_XADC_WIZARD_ALARM_TRESHOLDS_VCCINT_UPPER_ADDRESS              0x344
#define FPGA_XADC_WIZARD_ALARM_TRESHOLDS_VCCAUX_UPPER_ADDRESS              0x348
#define FPGA_XADC_WIZARD_ALARM_TRESHOLDS_OT_ALARM_LIMIT_ADDRESS            0x34C
#define FPGA_XADC_WIZARD_ALARM_TRESHOLDS_TEMPERATURE_LOWER_ADDRESS         0x350
#define FPGA_XADC_WIZARD_ALARM_TRESHOLDS_VCCINT_LOWER_ADDRESS              0x354
#define FPGA_XADC_WIZARD_ALARM_TRESHOLDS_VCCAUX_LOWER_ADDRESS              0x358
#define FPGA_XADC_WIZARD_ALARM_TRESHOLDS_OT_ALARM_RESET_ADDRESS            0x35C
#define FPGA_XADC_WIZARD_ALARM_TRESHOLDS_VCCBRAM_UPPER_ADDRESS             0x360
#define FPGA_XADC_WIZARD_ALARM_TRESHOLDS_VCCPINT_UPPER_ADDRESS             0x364
#define FPGA_XADC_WIZARD_ALARM_TRESHOLDS_VCCPAUX_UPPER_ADDRESS             0x368
#define FPGA_XADC_WIZARD_ALARM_TRESHOLDS_VCCO_DDR_UPPER_ADDRESS            0x36C
#define FPGA_XADC_WIZARD_ALARM_TRESHOLDS_VCCBRAM_LOWER_ADDRESS             0x370
#define FPGA_XADC_WIZARD_ALARM_TRESHOLDS_VCCPINT_LOWER_ADDRESS             0x374
#define FPGA_XADC_WIZARD_ALARM_TRESHOLDS_VCCPAUX_LOWER_ADDRESS             0x378
#define FPGA_XADC_WIZARD_ALARM_TRESHOLDS_VCCO_DDR_LOWER_ADDRESS            0x37C


/**************************************************************************
* Register name : ssr
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

} FPGA_XADC_WIZARD_LOCAL_REGISTER_SSR_TYPE;


/**************************************************************************
* Register name : sr
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 channel       : 5;   /* Bits(4:0), Channel selection outputs */
      M_UINT32 eoc           : 1;   /* Bits(5:5), End of Conversion signal */
      M_UINT32 eos           : 1;   /* Bits(6:6), End of Sequence */
      M_UINT32 busy          : 1;   /* Bits(7:7), ADC busy signal */
      M_UINT32 jtag_locked   : 1;   /* Bits(8:8), JTAG locked */
      M_UINT32 jtag_modified : 1;   /* Bits(9:9), JTAG modified */
      M_UINT32 jtag_busy     : 1;   /* Bits(10:10), JTAG busy */
      M_UINT32 rsvd0         : 21;  /* Bits(31:11), Reserved */

   } f;

} FPGA_XADC_WIZARD_LOCAL_REGISTER_SR_TYPE;


/**************************************************************************
* Register name : aosr
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 over_temperature : 1;   /* Bits(0:0), XADC Over-Temperature Alarm Status */
      M_UINT32 alarm_0          : 1;   /* Bits(1:1), XADC Temperature-Sensor Status */
      M_UINT32 alarm_1          : 1;   /* Bits(2:2), XADC VCCINT-Sensor Status */
      M_UINT32 alarm_2          : 1;   /* Bits(3:3), XADC VCCAUX-Sensor Status */
      M_UINT32 alarm_3          : 1;   /* Bits(4:4), XADC VBRAM-Sensor Status */
      M_UINT32 alarm_4          : 1;   /* Bits(5:5), XADC VCCPINT-Sensor Status */
      M_UINT32 alarm_5          : 1;   /* Bits(6:6), XADC VCCPAUX-Sensor Status */
      M_UINT32 alarm_6          : 1;   /* Bits(7:7), XADC VCCDDRO-Sensor Status */
      M_UINT32 alarm_7          : 1;   /* Bits(8:8), Logical ORing of ALARM bits 0 to 7 */
      M_UINT32 rsvd0            : 23;  /* Bits(31:9), Reserved */

   } f;

} FPGA_XADC_WIZARD_LOCAL_REGISTER_AOSR_TYPE;


/**************************************************************************
* Register name : convstr
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 convst             : 1;   /* Bits(0:0), Conversion Start */
      M_UINT32 temp_bus_update    : 1;   /* Bits(1:1), Temperature bus update */
      M_UINT32 temp_rd_wait_cycle : 16;  /* Bits(17:2), Wait cycle for temperature update */
      M_UINT32 rsvd0              : 14;  /* Bits(31:18), Reserved */

   } f;

} FPGA_XADC_WIZARD_LOCAL_REGISTER_CONVSTR_TYPE;


/**************************************************************************
* Register name : xadc_reset
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 reset : 1;   /* Bits(0:0), null */
      M_UINT32 rsvd0 : 31;  /* Bits(31:1), Reserved */

   } f;

} FPGA_XADC_WIZARD_LOCAL_REGISTER_XADC_RESET_TYPE;


/**************************************************************************
* Register name : global_interrupt
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0  : 31;  /* Bits(30:0), Reserved */
      M_UINT32 enable : 1;   /* Bits(31:31), Global Interrupt Enable */

   } f;

} FPGA_XADC_WIZARD_INTERRUPT_CONTROLLER_GLOBAL_INTERRUPT_TYPE;


/**************************************************************************
* Register name : interrupt_status
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 over_temperature          : 1;   /* Bits(0:0), Over-Temperature Alarm Interrupt */
      M_UINT32 alarm_0                   : 1;   /* Bits(1:1), XADC Temperature-Sensor Interrupt */
      M_UINT32 alarm_1                   : 1;   /* Bits(2:2), XADC VCCINT-Sensor Interrupt */
      M_UINT32 alarm_3                   : 1;   /* Bits(3:3), XADC VBRAM-Sensor Interrupt */
      M_UINT32 eos                       : 1;   /* Bits(4:4), End of Sequence Interrupt */
      M_UINT32 eoc                       : 1;   /* Bits(5:5), End of Sequence Interrupt */
      M_UINT32 jtag_locked               : 1;   /* Bits(6:6), JTAGLOCKED Interrupt */
      M_UINT32 jtag_modified             : 1;   /* Bits(7:7), JTAGMODIFIED Interrupt */
      M_UINT32 over_temperature_deactive : 1;   /* Bits(8:8), Over-Temperature Deactive Interrupt. */
      M_UINT32 alarm_0_deactive          : 1;   /* Bits(9:9), ALM[0] Deactive Interrupt. */
      M_UINT32 alarm_2                   : 1;   /* Bits(10:10), XADC VCCAUX-Sensor Interrupt */
      M_UINT32 alarm_4                   : 1;   /* Bits(11:11), XADC VCCPINT-Sensor Interrupt */
      M_UINT32 alarm_5                   : 1;   /* Bits(12:12), XADC VCCPAUX-Sensor Interrupt */
      M_UINT32 alarm_6                   : 1;   /* Bits(13:13), XADC VCCDDRO-Sensor Interrupt */
      M_UINT32 rsvd0                     : 18;  /* Bits(31:14), Reserved */
      M_UINT32 rsvd_register_space[1]    ;      /* Reserved space below */

   } f;

} FPGA_XADC_WIZARD_INTERRUPT_CONTROLLER_INTERRUPT_STATUS_TYPE;


/**************************************************************************
* Register name : interrupt_enable
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 over_temperature          : 1;   /* Bits(0:0), Over-Temperature Alarm Interrupt */
      M_UINT32 alarm_0                   : 1;   /* Bits(1:1), XADC Temperature-Sensor Interrupt */
      M_UINT32 alarm_1                   : 1;   /* Bits(2:2), XADC VCCINT-Sensor Interrupt */
      M_UINT32 alarm_3                   : 1;   /* Bits(3:3), XADC VBRAM-Sensor Interrupt */
      M_UINT32 eos                       : 1;   /* Bits(4:4), End of Sequence Interrupt */
      M_UINT32 eoc                       : 1;   /* Bits(5:5), End of Sequence Interrupt */
      M_UINT32 jtag_locked               : 1;   /* Bits(6:6), JTAGLOCKED Interrupt */
      M_UINT32 jtag_modified             : 1;   /* Bits(7:7), JTAGMODIFIED Interrupt */
      M_UINT32 over_temperature_deactive : 1;   /* Bits(8:8), Over-Temperature Deactive Interrupt. */
      M_UINT32 alarm_0_deactive          : 1;   /* Bits(9:9), ALM[0] Deactive Interrupt. */
      M_UINT32 alarm_2                   : 1;   /* Bits(10:10), XADC VCCAUX-Sensor Interrupt */
      M_UINT32 alarm_4                   : 1;   /* Bits(11:11), XADC VCCPINT-Sensor Interrupt */
      M_UINT32 alarm_5                   : 1;   /* Bits(12:12), XADC VCCPAUX-Sensor Interrupt */
      M_UINT32 alarm_6                   : 1;   /* Bits(13:13), XADC VCCDDRO-Sensor Interrupt */
      M_UINT32 rsvd0                     : 18;  /* Bits(31:14), Reserved */

   } f;

} FPGA_XADC_WIZARD_INTERRUPT_CONTROLLER_INTERRUPT_ENABLE_TYPE;


/**************************************************************************
* Register name : temperature
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), Temperature value */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_XADC_HARD_MACRO_TEMPERATURE_TYPE;


/**************************************************************************
* Register name : vcc_int
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), Vccint value */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_XADC_HARD_MACRO_VCC_INT_TYPE;


/**************************************************************************
* Register name : vcc_aux
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), Vccaux value */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_XADC_HARD_MACRO_VCC_AUX_TYPE;


/**************************************************************************
* Register name : vp_vn
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), Vp/Vn value */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_XADC_HARD_MACRO_VP_VN_TYPE;


/**************************************************************************
* Register name : vref_p
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), Vrefp value */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_XADC_HARD_MACRO_VREF_P_TYPE;


/**************************************************************************
* Register name : vref_n
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), Vrefp value */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_XADC_HARD_MACRO_VREF_N_TYPE;


/**************************************************************************
* Register name : vcc_bram
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0                  : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value                  : 12;  /* Bits(15:4), Vrefp value */
      M_UINT32 rsvd1                  : 16;  /* Bits(31:16), Reserved */
      M_UINT32 rsvd_register_space[1] ;      /* Reserved space below */

   } f;

} FPGA_XADC_WIZARD_XADC_HARD_MACRO_VCC_BRAM_TYPE;


/**************************************************************************
* Register name : supply_a_offset
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), Supply A offset value */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_XADC_HARD_MACRO_SUPPLY_A_OFFSET_TYPE;


/**************************************************************************
* Register name : adc_a_offset
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), ADC A offset value */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_XADC_HARD_MACRO_ADC_A_OFFSET_TYPE;


/**************************************************************************
* Register name : adc_a_gain
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 mag                    : 6;   /* Bits(5:0), Gain magnitude value */
      M_UINT32 sign                   : 1;   /* Bits(6:6), Gain sign */
      M_UINT32 rsvd0                  : 25;  /* Bits(31:7), Reserved */
      M_UINT32 rsvd_register_space[2] ;      /* Reserved space below */

   } f;

} FPGA_XADC_WIZARD_XADC_HARD_MACRO_ADC_A_GAIN_TYPE;


/**************************************************************************
* Register name : vcc_pint
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), Vcc Pint value */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_XADC_HARD_MACRO_VCC_PINT_TYPE;


/**************************************************************************
* Register name : vcc_paux
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), Vcc Paux value */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_XADC_HARD_MACRO_VCC_PAUX_TYPE;


/**************************************************************************
* Register name : vcco_ddr
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), Vcco DDR value */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_XADC_HARD_MACRO_VCCO_DDR_TYPE;


/**************************************************************************
* Register name : vaux_p_n
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), Vaux_P/Vaux_N value */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_XADC_HARD_MACRO_VAUX_P_N_TYPE;


/**************************************************************************
* Register name : max_temperature
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), Max temperature value */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_XADC_HARD_MACRO_MAX_TEMPERATURE_TYPE;


/**************************************************************************
* Register name : max_vcc_int
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), Max  Vcc int value */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCC_INT_TYPE;


/**************************************************************************
* Register name : max_vcc_aux
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), Max  Vcc int value */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCC_AUX_TYPE;


/**************************************************************************
* Register name : max_vcc_bram
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), Max  Vcc int value */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCC_BRAM_TYPE;


/**************************************************************************
* Register name : min_temperature
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), Minimum  temperature value */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_XADC_HARD_MACRO_MIN_TEMPERATURE_TYPE;


/**************************************************************************
* Register name : min_vcc_int
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), Minimum Vcc int value */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_XADC_HARD_MACRO_MIN_VCC_INT_TYPE;


/**************************************************************************
* Register name : min_vcc_aux
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), Minimum Vcc int value */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_XADC_HARD_MACRO_MIN_VCC_AUX_TYPE;


/**************************************************************************
* Register name : min_vcc_bram
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), Minimum Vcc int value */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_XADC_HARD_MACRO_MIN_VCC_BRAM_TYPE;


/**************************************************************************
* Register name : max_vcc_pint
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), Max  Vcc pint value */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCC_PINT_TYPE;


/**************************************************************************
* Register name : max_vcc_paux
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), Max  Vcc paux  value */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCC_PAUX_TYPE;


/**************************************************************************
* Register name : max_vcco_ddr
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0                  : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value                  : 12;  /* Bits(15:4), Max  Vcco DDR value */
      M_UINT32 rsvd1                  : 16;  /* Bits(31:16), Reserved */
      M_UINT32 rsvd_register_space[1] ;      /* Reserved space below */

   } f;

} FPGA_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCCO_DDR_TYPE;


/**************************************************************************
* Register name : min_vcc_pint
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), Minimum Vcc pint value */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_XADC_HARD_MACRO_MIN_VCC_PINT_TYPE;


/**************************************************************************
* Register name : min_vcc_paux
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), Minimum Vcc paux  value */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_XADC_HARD_MACRO_MIN_VCC_PAUX_TYPE;


/**************************************************************************
* Register name : main_vcco_ddr
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0                  : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value                  : 12;  /* Bits(15:4), Minimum Vcco DDR value */
      M_UINT32 rsvd1                  : 16;  /* Bits(31:16), Reserved */
      M_UINT32 rsvd_register_space[1] ;      /* Reserved space below */

   } f;

} FPGA_XADC_WIZARD_XADC_HARD_MACRO_MAIN_VCCO_DDR_TYPE;


/**************************************************************************
* Register name : supply_b_offset
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), Supply A offset value */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_XADC_HARD_MACRO_SUPPLY_B_OFFSET_TYPE;


/**************************************************************************
* Register name : adc_b_offset
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), ADC A offset value */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_XADC_HARD_MACRO_ADC_B_OFFSET_TYPE;


/**************************************************************************
* Register name : adc_b_gain
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 mag                    : 6;   /* Bits(5:0), Gain magnitude value */
      M_UINT32 sign                   : 1;   /* Bits(6:6), Gain sign */
      M_UINT32 rsvd0                  : 25;  /* Bits(31:7), Reserved */
      M_UINT32 rsvd_register_space[2] ;      /* Reserved space below */

   } f;

} FPGA_XADC_WIZARD_XADC_HARD_MACRO_ADC_B_GAIN_TYPE;


/**************************************************************************
* Register name : flag
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 alarm_0          : 1;   /* Bits(0:0), Alarm 0 output */
      M_UINT32 alarm_1          : 1;   /* Bits(1:1), Alarm 1 output */
      M_UINT32 alarm_2          : 1;   /* Bits(2:2), Alarm 2 output */
      M_UINT32 over_temperature : 1;   /* Bits(3:3), Over temperature output */
      M_UINT32 alarm_3          : 1;   /* Bits(4:4), Alarm 3 output */
      M_UINT32 alarm_4          : 1;   /* Bits(5:5), Alarm 4 output output */
      M_UINT32 alarm_5          : 1;   /* Bits(6:6), Alarm 5 output */
      M_UINT32 alarm_6          : 1;   /* Bits(7:7), Alarm 6 output */
      M_UINT32 rsvd0            : 1;   /* Bits(8:8), Reserved */
      M_UINT32 ref              : 1;   /* Bits(9:9), ADC reference voltage */
      M_UINT32 jtgr             : 1;   /* Bits(10:10), */
      M_UINT32 jtgd             : 1;   /* Bits(11:11), */
      M_UINT32 rsvd1            : 20;  /* Bits(31:12), Reserved */

   } f;

} FPGA_XADC_WIZARD_XADC_HARD_MACRO_FLAG_TYPE;


/**************************************************************************
* Register name : config_0
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 input_channel : 5;   /* Bits(4:0), ADC input channel */
      M_UINT32 rsvd0         : 3;   /* Bits(7:5), Reserved */
      M_UINT32 acq           : 1;   /* Bits(8:8), null */
      M_UINT32 ec            : 1;   /* Bits(9:9), null */
      M_UINT32 bu            : 1;   /* Bits(10:10), null */
      M_UINT32 mux           : 1;   /* Bits(11:11), null */
      M_UINT32 avg           : 2;   /* Bits(13:12), Averaging */
      M_UINT32 rsvd1         : 1;   /* Bits(14:14), Reserved */
      M_UINT32 cavg          : 1;   /* Bits(15:15), Disable calculation averaging */
      M_UINT32 rsvd2         : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_CONTROL_CONFIG_0_TYPE;


/**************************************************************************
* Register name : config_1
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 ot_disable      : 1;   /* Bits(0:0), Over temperature disable */
      M_UINT32 alarm_0_disable : 1;   /* Bits(1:1), Alarm 0 disable */
      M_UINT32 alarm_1_disable : 1;   /* Bits(2:2), Alarm 0 disable */
      M_UINT32 alarm_2_disable : 1;   /* Bits(3:3), Alarm 2 disable */
      M_UINT32 cal_enable_0    : 1;   /* Bits(4:4), ADCs offset correction enable */
      M_UINT32 cal_enable_1    : 1;   /* Bits(5:5), ADCs offset and gain correction enable */
      M_UINT32 cal_enable_2    : 1;   /* Bits(6:6), Supply sensor offset correction enable */
      M_UINT32 cal_enable_3    : 1;   /* Bits(7:7), Supply sensor offset and gain correction enable */
      M_UINT32 alarm_3_disable : 1;   /* Bits(8:8), Alarm 3 disable */
      M_UINT32 alarm_4_disable : 1;   /* Bits(9:9), Alarm 4 disable */
      M_UINT32 alarm_5_disable : 1;   /* Bits(10:10), Alarm 5 disable */
      M_UINT32 alarm_6_disable : 1;   /* Bits(11:11), Alarm 6 disable */
      M_UINT32 seq             : 4;   /* Bits(15:12), null */
      M_UINT32 rsvd0           : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_CONTROL_CONFIG_1_TYPE;


/**************************************************************************
* Register name : config_2
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 pd    : 2;   /* Bits(5:4), Power down selection */
      M_UINT32 rsvd1 : 2;   /* Bits(7:6), Reserved */
      M_UINT32 cd    : 8;   /* Bits(15:8), Clock division selection */
      M_UINT32 rsvd2 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_CONTROL_CONFIG_2_TYPE;


/**************************************************************************
* Register name : temperature_upper
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), null */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_ALARM_TRESHOLDS_TEMPERATURE_UPPER_TYPE;


/**************************************************************************
* Register name : vccint_upper
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), null */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_ALARM_TRESHOLDS_VCCINT_UPPER_TYPE;


/**************************************************************************
* Register name : vccaux_upper
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), null */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_ALARM_TRESHOLDS_VCCAUX_UPPER_TYPE;


/**************************************************************************
* Register name : ot_alarm_limit
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), null */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_ALARM_TRESHOLDS_OT_ALARM_LIMIT_TYPE;


/**************************************************************************
* Register name : temperature_lower
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), null */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_ALARM_TRESHOLDS_TEMPERATURE_LOWER_TYPE;


/**************************************************************************
* Register name : vccint_lower
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), null */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_ALARM_TRESHOLDS_VCCINT_LOWER_TYPE;


/**************************************************************************
* Register name : vccaux_lower
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), null */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_ALARM_TRESHOLDS_VCCAUX_LOWER_TYPE;


/**************************************************************************
* Register name : ot_alarm_reset
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), null */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_ALARM_TRESHOLDS_OT_ALARM_RESET_TYPE;


/**************************************************************************
* Register name : vccbram_upper
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), null */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_ALARM_TRESHOLDS_VCCBRAM_UPPER_TYPE;


/**************************************************************************
* Register name : vccpint_upper
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), null */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_ALARM_TRESHOLDS_VCCPINT_UPPER_TYPE;


/**************************************************************************
* Register name : vccpaux_upper
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), null */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_ALARM_TRESHOLDS_VCCPAUX_UPPER_TYPE;


/**************************************************************************
* Register name : vcco_ddr_upper
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), null */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_ALARM_TRESHOLDS_VCCO_DDR_UPPER_TYPE;


/**************************************************************************
* Register name : vccbram_lower
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), null */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_ALARM_TRESHOLDS_VCCBRAM_LOWER_TYPE;


/**************************************************************************
* Register name : vccpint_lower
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), null */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_ALARM_TRESHOLDS_VCCPINT_LOWER_TYPE;


/**************************************************************************
* Register name : vccpaux_lower
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), null */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_ALARM_TRESHOLDS_VCCPAUX_LOWER_TYPE;


/**************************************************************************
* Register name : vcco_ddr_lower
***************************************************************************/
typedef union
{
   M_UINT32 u32;
   M_UINT16 u16;
   M_UINT8  u8;

   struct
   {
      M_UINT32 rsvd0 : 4;   /* Bits(3:0), Reserved */
      M_UINT32 value : 12;  /* Bits(15:4), null */
      M_UINT32 rsvd1 : 16;  /* Bits(31:16), Reserved */

   } f;

} FPGA_XADC_WIZARD_ALARM_TRESHOLDS_VCCO_DDR_LOWER_TYPE;


/**************************************************************************
* Section name   : local_register
***************************************************************************/
typedef struct
{
   FPGA_XADC_WIZARD_LOCAL_REGISTER_SSR_TYPE        ssr;         /* Address offset: 0x0 */
   FPGA_XADC_WIZARD_LOCAL_REGISTER_SR_TYPE         sr;          /* Address offset: 0x4 */
   FPGA_XADC_WIZARD_LOCAL_REGISTER_AOSR_TYPE       aosr;        /* Address offset: 0x8 */
   FPGA_XADC_WIZARD_LOCAL_REGISTER_CONVSTR_TYPE    convstr;     /* Address offset: 0xc */
   FPGA_XADC_WIZARD_LOCAL_REGISTER_XADC_RESET_TYPE xadc_reset;  /* Address offset: 0x10 */

} FPGA_XADC_WIZARD_LOCAL_REGISTER_TYPE;


/**************************************************************************
* Section name   : interrupt_controller
***************************************************************************/
typedef struct
{
   FPGA_XADC_WIZARD_INTERRUPT_CONTROLLER_GLOBAL_INTERRUPT_TYPE global_interrupt;  /* Address offset: 0x0 */
   FPGA_XADC_WIZARD_INTERRUPT_CONTROLLER_INTERRUPT_STATUS_TYPE interrupt_status;  /* Address offset: 0x4 */
   FPGA_XADC_WIZARD_INTERRUPT_CONTROLLER_INTERRUPT_ENABLE_TYPE interrupt_enable;  /* Address offset: 0xc */

} FPGA_XADC_WIZARD_INTERRUPT_CONTROLLER_TYPE;


/**************************************************************************
* Section name   : xadc_hard_macro
***************************************************************************/
typedef struct
{
   FPGA_XADC_WIZARD_XADC_HARD_MACRO_TEMPERATURE_TYPE     temperature;      /* Address offset: 0x0 */
   FPGA_XADC_WIZARD_XADC_HARD_MACRO_VCC_INT_TYPE         vcc_int;          /* Address offset: 0x4 */
   FPGA_XADC_WIZARD_XADC_HARD_MACRO_VCC_AUX_TYPE         vcc_aux;          /* Address offset: 0x8 */
   FPGA_XADC_WIZARD_XADC_HARD_MACRO_VP_VN_TYPE           vp_vn;            /* Address offset: 0xc */
   FPGA_XADC_WIZARD_XADC_HARD_MACRO_VREF_P_TYPE          vref_p;           /* Address offset: 0x10 */
   FPGA_XADC_WIZARD_XADC_HARD_MACRO_VREF_N_TYPE          vref_n;           /* Address offset: 0x14 */
   FPGA_XADC_WIZARD_XADC_HARD_MACRO_VCC_BRAM_TYPE        vcc_bram;         /* Address offset: 0x18 */
   FPGA_XADC_WIZARD_XADC_HARD_MACRO_SUPPLY_A_OFFSET_TYPE supply_a_offset;  /* Address offset: 0x20 */
   FPGA_XADC_WIZARD_XADC_HARD_MACRO_ADC_A_OFFSET_TYPE    adc_a_offset;     /* Address offset: 0x24 */
   FPGA_XADC_WIZARD_XADC_HARD_MACRO_ADC_A_GAIN_TYPE      adc_a_gain;       /* Address offset: 0x28 */
   FPGA_XADC_WIZARD_XADC_HARD_MACRO_VCC_PINT_TYPE        vcc_pint;         /* Address offset: 0x34 */
   FPGA_XADC_WIZARD_XADC_HARD_MACRO_VCC_PAUX_TYPE        vcc_paux;         /* Address offset: 0x38 */
   FPGA_XADC_WIZARD_XADC_HARD_MACRO_VCCO_DDR_TYPE        vcco_ddr;         /* Address offset: 0x3c */
   FPGA_XADC_WIZARD_XADC_HARD_MACRO_VAUX_P_N_TYPE        vaux_p_n[16];     /* Address offset: 0x40 */
   FPGA_XADC_WIZARD_XADC_HARD_MACRO_MAX_TEMPERATURE_TYPE max_temperature;  /* Address offset: 0x80 */
   FPGA_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCC_INT_TYPE     max_vcc_int;      /* Address offset: 0x84 */
   FPGA_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCC_AUX_TYPE     max_vcc_aux;      /* Address offset: 0x88 */
   FPGA_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCC_BRAM_TYPE    max_vcc_bram;     /* Address offset: 0x8c */
   FPGA_XADC_WIZARD_XADC_HARD_MACRO_MIN_TEMPERATURE_TYPE min_temperature;  /* Address offset: 0x90 */
   FPGA_XADC_WIZARD_XADC_HARD_MACRO_MIN_VCC_INT_TYPE     min_vcc_int;      /* Address offset: 0x94 */
   FPGA_XADC_WIZARD_XADC_HARD_MACRO_MIN_VCC_AUX_TYPE     min_vcc_aux;      /* Address offset: 0x98 */
   FPGA_XADC_WIZARD_XADC_HARD_MACRO_MIN_VCC_BRAM_TYPE    min_vcc_bram;     /* Address offset: 0x9c */
   FPGA_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCC_PINT_TYPE    max_vcc_pint;     /* Address offset: 0xa0 */
   FPGA_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCC_PAUX_TYPE    max_vcc_paux;     /* Address offset: 0xa4 */
   FPGA_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCCO_DDR_TYPE    max_vcco_ddr;     /* Address offset: 0xa8 */
   FPGA_XADC_WIZARD_XADC_HARD_MACRO_MIN_VCC_PINT_TYPE    min_vcc_pint;     /* Address offset: 0xb0 */
   FPGA_XADC_WIZARD_XADC_HARD_MACRO_MIN_VCC_PAUX_TYPE    min_vcc_paux;     /* Address offset: 0xb4 */
   FPGA_XADC_WIZARD_XADC_HARD_MACRO_MAIN_VCCO_DDR_TYPE   main_vcco_ddr;    /* Address offset: 0xb8 */
   FPGA_XADC_WIZARD_XADC_HARD_MACRO_SUPPLY_B_OFFSET_TYPE supply_b_offset;  /* Address offset: 0xc0 */
   FPGA_XADC_WIZARD_XADC_HARD_MACRO_ADC_B_OFFSET_TYPE    adc_b_offset;     /* Address offset: 0xc4 */
   FPGA_XADC_WIZARD_XADC_HARD_MACRO_ADC_B_GAIN_TYPE      adc_b_gain;       /* Address offset: 0xc8 */
   FPGA_XADC_WIZARD_XADC_HARD_MACRO_FLAG_TYPE            flag;             /* Address offset: 0xd4 */

} FPGA_XADC_WIZARD_XADC_HARD_MACRO_TYPE;


/**************************************************************************
* Section name   : control
***************************************************************************/
typedef struct
{
   FPGA_XADC_WIZARD_CONTROL_CONFIG_0_TYPE config_0;  /* Address offset: 0x0 */
   FPGA_XADC_WIZARD_CONTROL_CONFIG_1_TYPE config_1;  /* Address offset: 0x4 */
   FPGA_XADC_WIZARD_CONTROL_CONFIG_2_TYPE config_2;  /* Address offset: 0x8 */

} FPGA_XADC_WIZARD_CONTROL_TYPE;


/**************************************************************************
* Section name   : alarm_tresholds
***************************************************************************/
typedef struct
{
   FPGA_XADC_WIZARD_ALARM_TRESHOLDS_TEMPERATURE_UPPER_TYPE temperature_upper;  /* Address offset: 0x0 */
   FPGA_XADC_WIZARD_ALARM_TRESHOLDS_VCCINT_UPPER_TYPE      vccint_upper;       /* Address offset: 0x4 */
   FPGA_XADC_WIZARD_ALARM_TRESHOLDS_VCCAUX_UPPER_TYPE      vccaux_upper;       /* Address offset: 0x8 */
   FPGA_XADC_WIZARD_ALARM_TRESHOLDS_OT_ALARM_LIMIT_TYPE    ot_alarm_limit;     /* Address offset: 0xc */
   FPGA_XADC_WIZARD_ALARM_TRESHOLDS_TEMPERATURE_LOWER_TYPE temperature_lower;  /* Address offset: 0x10 */
   FPGA_XADC_WIZARD_ALARM_TRESHOLDS_VCCINT_LOWER_TYPE      vccint_lower;       /* Address offset: 0x14 */
   FPGA_XADC_WIZARD_ALARM_TRESHOLDS_VCCAUX_LOWER_TYPE      vccaux_lower;       /* Address offset: 0x18 */
   FPGA_XADC_WIZARD_ALARM_TRESHOLDS_OT_ALARM_RESET_TYPE    ot_alarm_reset;     /* Address offset: 0x1c */
   FPGA_XADC_WIZARD_ALARM_TRESHOLDS_VCCBRAM_UPPER_TYPE     vccbram_upper;      /* Address offset: 0x20 */
   FPGA_XADC_WIZARD_ALARM_TRESHOLDS_VCCPINT_UPPER_TYPE     vccpint_upper;      /* Address offset: 0x24 */
   FPGA_XADC_WIZARD_ALARM_TRESHOLDS_VCCPAUX_UPPER_TYPE     vccpaux_upper;      /* Address offset: 0x28 */
   FPGA_XADC_WIZARD_ALARM_TRESHOLDS_VCCO_DDR_UPPER_TYPE    vcco_ddr_upper;     /* Address offset: 0x2c */
   FPGA_XADC_WIZARD_ALARM_TRESHOLDS_VCCBRAM_LOWER_TYPE     vccbram_lower;      /* Address offset: 0x30 */
   FPGA_XADC_WIZARD_ALARM_TRESHOLDS_VCCPINT_LOWER_TYPE     vccpint_lower;      /* Address offset: 0x34 */
   FPGA_XADC_WIZARD_ALARM_TRESHOLDS_VCCPAUX_LOWER_TYPE     vccpaux_lower;      /* Address offset: 0x38 */
   FPGA_XADC_WIZARD_ALARM_TRESHOLDS_VCCO_DDR_LOWER_TYPE    vcco_ddr_lower;     /* Address offset: 0x3c */

} FPGA_XADC_WIZARD_ALARM_TRESHOLDS_TYPE;


/**************************************************************************
* Register file name : xadc_wizard
***************************************************************************/
typedef struct
{
   FPGA_XADC_WIZARD_LOCAL_REGISTER_TYPE       local_register;        /* Section; Base address offset: 0x0 */
   M_UINT32                                   rsvd0[18];             /* Padding; Size (72 Bytes) */
   FPGA_XADC_WIZARD_INTERRUPT_CONTROLLER_TYPE interrupt_controller;  /* Section; Base address offset: 0x5c */
   M_UINT32                                   rsvd1[101];            /* Padding; Size (404 Bytes) */
   FPGA_XADC_WIZARD_XADC_HARD_MACRO_TYPE      xadc_hard_macro;       /* Section; Base address offset: 0x200 */
   M_UINT32                                   rsvd2[10];             /* Padding; Size (40 Bytes) */
   FPGA_XADC_WIZARD_CONTROL_TYPE              control;               /* Section; Base address offset: 0x300 */
   M_UINT32                                   rsvd3[13];             /* Padding; Size (52 Bytes) */
   FPGA_XADC_WIZARD_ALARM_TRESHOLDS_TYPE      alarm_tresholds;       /* Section; Base address offset: 0x340 */

} FPGA_XADC_WIZARD_TYPE;



#endif
