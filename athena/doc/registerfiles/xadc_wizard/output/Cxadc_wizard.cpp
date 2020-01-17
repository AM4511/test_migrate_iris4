/*****************************************************************************
**  $HeadURL:$
**  $Revision:$
**  $Date:$
**
**  MODULE: xadc_wizard
**
**  DESCRIPTION: Register file of the xadc_wizard module
**
**
**  DO NOT MODIFY MANUALLY.
**
**  FDK IDE Version: 4.6.0_beta1
**  Build ID: I20160217-1125
**
**  COPYRIGHT (c) 2019 Matrox Electronic Systems Ltd.
**  All Rights Reserved
**
*****************************************************************************/
#include "Cxadc_wizard.h"

Cxadc_wizard::Cxadc_wizard() : CfdkRegisterFile("xadc_wizard", 9, 32, true)
{
   CfdkSection *pSection;
   CfdkRegister *pRegister;


   /******************************************************************
   * Section: //local_register
   * Offset: 0x0
   *******************************************************************/
   pSection = createSection(this, "local_register", 0x0);
   this->addSection(pSection);

   /******************************************************************
   * Register: //local_register/ssr(31:0)
   * Offset: 0x0
   * Address: 0x0
   *******************************************************************/
   pRegister = createRegister(pSection, "ssr", 0x0, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 0, 32, CfdkField::RW, 0x0, 0xffffffff, 0xffffffff)); // ssr(31:0)

   /******************************************************************
   * Register: //local_register/sr(31:0)
   * Offset: 0x4
   * Address: 0x4
   *******************************************************************/
   pRegister = createRegister(pSection, "sr", 0x4, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "jtag_busy", 10, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // sr(10)
   pRegister->addField(createField(pRegister, "jtag_modified", 9, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // sr(9)
   pRegister->addField(createField(pRegister, "jtag_locked", 8, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // sr(8)
   pRegister->addField(createField(pRegister, "busy", 7, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // sr(7)
   pRegister->addField(createField(pRegister, "eos", 6, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // sr(6)
   pRegister->addField(createField(pRegister, "eoc", 5, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // sr(5)
   pRegister->addField(createField(pRegister, "channel", 0, 5, CfdkField::RO, 0x0, 0x0, 0x1f)); // sr(4:0)

   /******************************************************************
   * Register: //local_register/aosr(31:0)
   * Offset: 0x8
   * Address: 0x8
   *******************************************************************/
   pRegister = createRegister(pSection, "aosr", 0x8, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "alarm_7", 8, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // aosr(8)
   pRegister->addField(createField(pRegister, "alarm_6", 7, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // aosr(7)
   pRegister->addField(createField(pRegister, "alarm_5", 6, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // aosr(6)
   pRegister->addField(createField(pRegister, "alarm_4", 5, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // aosr(5)
   pRegister->addField(createField(pRegister, "alarm_3", 4, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // aosr(4)
   pRegister->addField(createField(pRegister, "alarm_2", 3, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // aosr(3)
   pRegister->addField(createField(pRegister, "alarm_1", 2, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // aosr(2)
   pRegister->addField(createField(pRegister, "alarm_0", 1, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // aosr(1)
   pRegister->addField(createField(pRegister, "over_temperature", 0, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // aosr(0)

   /******************************************************************
   * Register: //local_register/convstr(31:0)
   * Offset: 0xc
   * Address: 0xc
   *******************************************************************/
   pRegister = createRegister(pSection, "convstr", 0xc, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "temp_rd_wait_cycle", 2, 16, CfdkField::RW, 0x3e8, 0xffff, 0xffff)); // convstr(17:2)
   pRegister->addField(createField(pRegister, "temp_bus_update", 1, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // convstr(1)
   pRegister->addField(createField(pRegister, "convst", 0, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // convstr(0)

   /******************************************************************
   * Register: //local_register/xadc_reset(31:0)
   * Offset: 0x10
   * Address: 0x10
   *******************************************************************/
   pRegister = createRegister(pSection, "xadc_reset", 0x10, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "reset", 0, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // xadc_reset(0)


   /******************************************************************
   * Section: //interrupt_controller
   * Offset: 0x5c
   *******************************************************************/
   pSection = createSection(this, "interrupt_controller", 0x5c);
   this->addSection(pSection);

   /******************************************************************
   * Register: //interrupt_controller/global_interrupt(31:0)
   * Offset: 0x0
   * Address: 0x5c
   *******************************************************************/
   pRegister = createRegister(pSection, "global_interrupt", 0x0, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "enable", 31, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // global_interrupt(31)

   /******************************************************************
   * Register: //interrupt_controller/interrupt_status(31:0)
   * Offset: 0x4
   * Address: 0x60
   *******************************************************************/
   pRegister = createRegister(pSection, "interrupt_status", 0x4, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "alarm_6", 13, 1, CfdkField::RW2C, 0x0, 0x1, 0x0)); // interrupt_status(13)
   pRegister->addField(createField(pRegister, "alarm_5", 12, 1, CfdkField::RW2C, 0x0, 0x1, 0x0)); // interrupt_status(12)
   pRegister->addField(createField(pRegister, "alarm_4", 11, 1, CfdkField::RW2C, 0x0, 0x1, 0x0)); // interrupt_status(11)
   pRegister->addField(createField(pRegister, "alarm_2", 10, 1, CfdkField::RW2C, 0x0, 0x1, 0x0)); // interrupt_status(10)
   pRegister->addField(createField(pRegister, "alarm_0_deactive", 9, 1, CfdkField::RW2C, 0x0, 0x1, 0x0)); // interrupt_status(9)
   pRegister->addField(createField(pRegister, "over_temperature_deactive", 8, 1, CfdkField::RW2C, 0x0, 0x1, 0x0)); // interrupt_status(8)
   pRegister->addField(createField(pRegister, "jtag_modified", 7, 1, CfdkField::RW2C, 0x0, 0x1, 0x0)); // interrupt_status(7)
   pRegister->addField(createField(pRegister, "jtag_locked", 6, 1, CfdkField::RW2C, 0x0, 0x1, 0x0)); // interrupt_status(6)
   pRegister->addField(createField(pRegister, "eoc", 5, 1, CfdkField::RW2C, 0x0, 0x1, 0x0)); // interrupt_status(5)
   pRegister->addField(createField(pRegister, "eos", 4, 1, CfdkField::RW2C, 0x0, 0x1, 0x0)); // interrupt_status(4)
   pRegister->addField(createField(pRegister, "alarm_3", 3, 1, CfdkField::RW2C, 0x0, 0x1, 0x0)); // interrupt_status(3)
   pRegister->addField(createField(pRegister, "alarm_1", 2, 1, CfdkField::RW2C, 0x0, 0x1, 0x0)); // interrupt_status(2)
   pRegister->addField(createField(pRegister, "alarm_0", 1, 1, CfdkField::RW2C, 0x0, 0x1, 0x0)); // interrupt_status(1)
   pRegister->addField(createField(pRegister, "over_temperature", 0, 1, CfdkField::RW2C, 0x0, 0x1, 0x0)); // interrupt_status(0)

   /******************************************************************
   * Register: //interrupt_controller/interrupt_enable(31:0)
   * Offset: 0xc
   * Address: 0x68
   *******************************************************************/
   pRegister = createRegister(pSection, "interrupt_enable", 0xc, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "alarm_6", 13, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // interrupt_enable(13)
   pRegister->addField(createField(pRegister, "alarm_5", 12, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // interrupt_enable(12)
   pRegister->addField(createField(pRegister, "alarm_4", 11, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // interrupt_enable(11)
   pRegister->addField(createField(pRegister, "alarm_2", 10, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // interrupt_enable(10)
   pRegister->addField(createField(pRegister, "alarm_0_deactive", 9, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // interrupt_enable(9)
   pRegister->addField(createField(pRegister, "over_temperature_deactive", 8, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // interrupt_enable(8)
   pRegister->addField(createField(pRegister, "jtag_modified", 7, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // interrupt_enable(7)
   pRegister->addField(createField(pRegister, "jtag_locked", 6, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // interrupt_enable(6)
   pRegister->addField(createField(pRegister, "eoc", 5, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // interrupt_enable(5)
   pRegister->addField(createField(pRegister, "eos", 4, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // interrupt_enable(4)
   pRegister->addField(createField(pRegister, "alarm_3", 3, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // interrupt_enable(3)
   pRegister->addField(createField(pRegister, "alarm_1", 2, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // interrupt_enable(2)
   pRegister->addField(createField(pRegister, "alarm_0", 1, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // interrupt_enable(1)
   pRegister->addField(createField(pRegister, "over_temperature", 0, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // interrupt_enable(0)


   /******************************************************************
   * Section: //xadc_hard_macro
   * Offset: 0x200
   *******************************************************************/
   pSection = createSection(this, "xadc_hard_macro", 0x200);
   this->addSection(pSection);

   /******************************************************************
   * Register: //xadc_hard_macro/temperature(31:0)
   * Offset: 0x0
   * Address: 0x200
   *******************************************************************/
   pRegister = createRegister(pSection, "temperature", 0x0, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // temperature(15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/vcc_int(31:0)
   * Offset: 0x4
   * Address: 0x204
   *******************************************************************/
   pRegister = createRegister(pSection, "vcc_int", 0x4, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // vcc_int(15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/vcc_aux(31:0)
   * Offset: 0x8
   * Address: 0x208
   *******************************************************************/
   pRegister = createRegister(pSection, "vcc_aux", 0x8, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // vcc_aux(15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/vp_vn(31:0)
   * Offset: 0xc
   * Address: 0x20c
   *******************************************************************/
   pRegister = createRegister(pSection, "vp_vn", 0xc, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // vp_vn(15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/vref_p(31:0)
   * Offset: 0x10
   * Address: 0x210
   *******************************************************************/
   pRegister = createRegister(pSection, "vref_p", 0x10, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // vref_p(15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/vref_n(31:0)
   * Offset: 0x14
   * Address: 0x214
   *******************************************************************/
   pRegister = createRegister(pSection, "vref_n", 0x14, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // vref_n(15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/vcc_bram(31:0)
   * Offset: 0x18
   * Address: 0x218
   *******************************************************************/
   pRegister = createRegister(pSection, "vcc_bram", 0x18, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // vcc_bram(15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/supply_a_offset(31:0)
   * Offset: 0x20
   * Address: 0x220
   *******************************************************************/
   pRegister = createRegister(pSection, "supply_a_offset", 0x20, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // supply_a_offset(15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/adc_a_offset(31:0)
   * Offset: 0x24
   * Address: 0x224
   *******************************************************************/
   pRegister = createRegister(pSection, "adc_a_offset", 0x24, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // adc_a_offset(15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/adc_a_gain(31:0)
   * Offset: 0x28
   * Address: 0x228
   *******************************************************************/
   pRegister = createRegister(pSection, "adc_a_gain", 0x28, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "sign", 6, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // adc_a_gain(6)
   pRegister->addField(createField(pRegister, "mag", 0, 6, CfdkField::RO, 0x0, 0x0, 0x3f)); // adc_a_gain(5:0)

   /******************************************************************
   * Register: //xadc_hard_macro/vcc_pint(31:0)
   * Offset: 0x34
   * Address: 0x234
   *******************************************************************/
   pRegister = createRegister(pSection, "vcc_pint", 0x34, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // vcc_pint(15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/vcc_paux(31:0)
   * Offset: 0x38
   * Address: 0x238
   *******************************************************************/
   pRegister = createRegister(pSection, "vcc_paux", 0x38, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // vcc_paux(15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/vcco_ddr(31:0)
   * Offset: 0x3c
   * Address: 0x23c
   *******************************************************************/
   pRegister = createRegister(pSection, "vcco_ddr", 0x3c, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // vcco_ddr(15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/vaux_p_n[0](31:0)
   * Offset: 0x40
   * Address: 0x240
   *******************************************************************/
   pRegister = createRegister(pSection, "vaux_p_n[0]", 0x40, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // vaux_p_n[](15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/vaux_p_n[1](31:0)
   * Offset: 0x44
   * Address: 0x244
   *******************************************************************/
   pRegister = createRegister(pSection, "vaux_p_n[1]", 0x44, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // vaux_p_n[](15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/vaux_p_n[2](31:0)
   * Offset: 0x48
   * Address: 0x248
   *******************************************************************/
   pRegister = createRegister(pSection, "vaux_p_n[2]", 0x48, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // vaux_p_n[](15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/vaux_p_n[3](31:0)
   * Offset: 0x4c
   * Address: 0x24c
   *******************************************************************/
   pRegister = createRegister(pSection, "vaux_p_n[3]", 0x4c, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // vaux_p_n[](15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/vaux_p_n[4](31:0)
   * Offset: 0x50
   * Address: 0x250
   *******************************************************************/
   pRegister = createRegister(pSection, "vaux_p_n[4]", 0x50, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // vaux_p_n[](15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/vaux_p_n[5](31:0)
   * Offset: 0x54
   * Address: 0x254
   *******************************************************************/
   pRegister = createRegister(pSection, "vaux_p_n[5]", 0x54, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // vaux_p_n[](15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/vaux_p_n[6](31:0)
   * Offset: 0x58
   * Address: 0x258
   *******************************************************************/
   pRegister = createRegister(pSection, "vaux_p_n[6]", 0x58, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // vaux_p_n[](15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/vaux_p_n[7](31:0)
   * Offset: 0x5c
   * Address: 0x25c
   *******************************************************************/
   pRegister = createRegister(pSection, "vaux_p_n[7]", 0x5c, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // vaux_p_n[](15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/vaux_p_n[8](31:0)
   * Offset: 0x60
   * Address: 0x260
   *******************************************************************/
   pRegister = createRegister(pSection, "vaux_p_n[8]", 0x60, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // vaux_p_n[](15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/vaux_p_n[9](31:0)
   * Offset: 0x64
   * Address: 0x264
   *******************************************************************/
   pRegister = createRegister(pSection, "vaux_p_n[9]", 0x64, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // vaux_p_n[](15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/vaux_p_n[10](31:0)
   * Offset: 0x68
   * Address: 0x268
   *******************************************************************/
   pRegister = createRegister(pSection, "vaux_p_n[10]", 0x68, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // vaux_p_n[](15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/vaux_p_n[11](31:0)
   * Offset: 0x6c
   * Address: 0x26c
   *******************************************************************/
   pRegister = createRegister(pSection, "vaux_p_n[11]", 0x6c, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // vaux_p_n[](15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/vaux_p_n[12](31:0)
   * Offset: 0x70
   * Address: 0x270
   *******************************************************************/
   pRegister = createRegister(pSection, "vaux_p_n[12]", 0x70, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // vaux_p_n[](15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/vaux_p_n[13](31:0)
   * Offset: 0x74
   * Address: 0x274
   *******************************************************************/
   pRegister = createRegister(pSection, "vaux_p_n[13]", 0x74, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // vaux_p_n[](15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/vaux_p_n[14](31:0)
   * Offset: 0x78
   * Address: 0x278
   *******************************************************************/
   pRegister = createRegister(pSection, "vaux_p_n[14]", 0x78, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // vaux_p_n[](15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/vaux_p_n[15](31:0)
   * Offset: 0x7c
   * Address: 0x27c
   *******************************************************************/
   pRegister = createRegister(pSection, "vaux_p_n[15]", 0x7c, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // vaux_p_n[](15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/max_temperature(31:0)
   * Offset: 0x80
   * Address: 0x280
   *******************************************************************/
   pRegister = createRegister(pSection, "max_temperature", 0x80, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // max_temperature(15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/max_vcc_int(31:0)
   * Offset: 0x84
   * Address: 0x284
   *******************************************************************/
   pRegister = createRegister(pSection, "max_vcc_int", 0x84, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // max_vcc_int(15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/max_vcc_aux(31:0)
   * Offset: 0x88
   * Address: 0x288
   *******************************************************************/
   pRegister = createRegister(pSection, "max_vcc_aux", 0x88, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // max_vcc_aux(15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/max_vcc_bram(31:0)
   * Offset: 0x8c
   * Address: 0x28c
   *******************************************************************/
   pRegister = createRegister(pSection, "max_vcc_bram", 0x8c, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // max_vcc_bram(15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/min_temperature(31:0)
   * Offset: 0x90
   * Address: 0x290
   *******************************************************************/
   pRegister = createRegister(pSection, "min_temperature", 0x90, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // min_temperature(15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/min_vcc_int(31:0)
   * Offset: 0x94
   * Address: 0x294
   *******************************************************************/
   pRegister = createRegister(pSection, "min_vcc_int", 0x94, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // min_vcc_int(15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/min_vcc_aux(31:0)
   * Offset: 0x98
   * Address: 0x298
   *******************************************************************/
   pRegister = createRegister(pSection, "min_vcc_aux", 0x98, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // min_vcc_aux(15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/min_vcc_bram(31:0)
   * Offset: 0x9c
   * Address: 0x29c
   *******************************************************************/
   pRegister = createRegister(pSection, "min_vcc_bram", 0x9c, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // min_vcc_bram(15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/max_vcc_pint(31:0)
   * Offset: 0xa0
   * Address: 0x2a0
   *******************************************************************/
   pRegister = createRegister(pSection, "max_vcc_pint", 0xa0, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // max_vcc_pint(15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/max_vcc_paux(31:0)
   * Offset: 0xa4
   * Address: 0x2a4
   *******************************************************************/
   pRegister = createRegister(pSection, "max_vcc_paux", 0xa4, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // max_vcc_paux(15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/max_vcco_ddr(31:0)
   * Offset: 0xa8
   * Address: 0x2a8
   *******************************************************************/
   pRegister = createRegister(pSection, "max_vcco_ddr", 0xa8, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // max_vcco_ddr(15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/min_vcc_pint(31:0)
   * Offset: 0xb0
   * Address: 0x2b0
   *******************************************************************/
   pRegister = createRegister(pSection, "min_vcc_pint", 0xb0, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // min_vcc_pint(15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/min_vcc_paux(31:0)
   * Offset: 0xb4
   * Address: 0x2b4
   *******************************************************************/
   pRegister = createRegister(pSection, "min_vcc_paux", 0xb4, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // min_vcc_paux(15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/main_vcco_ddr(31:0)
   * Offset: 0xb8
   * Address: 0x2b8
   *******************************************************************/
   pRegister = createRegister(pSection, "main_vcco_ddr", 0xb8, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // main_vcco_ddr(15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/supply_b_offset(31:0)
   * Offset: 0xc0
   * Address: 0x2c0
   *******************************************************************/
   pRegister = createRegister(pSection, "supply_b_offset", 0xc0, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // supply_b_offset(15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/adc_b_offset(31:0)
   * Offset: 0xc4
   * Address: 0x2c4
   *******************************************************************/
   pRegister = createRegister(pSection, "adc_b_offset", 0xc4, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // adc_b_offset(15:4)

   /******************************************************************
   * Register: //xadc_hard_macro/adc_b_gain(31:0)
   * Offset: 0xc8
   * Address: 0x2c8
   *******************************************************************/
   pRegister = createRegister(pSection, "adc_b_gain", 0xc8, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "sign", 6, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // adc_b_gain(6)
   pRegister->addField(createField(pRegister, "mag", 0, 6, CfdkField::RO, 0x0, 0x0, 0x3f)); // adc_b_gain(5:0)

   /******************************************************************
   * Register: //xadc_hard_macro/flag(31:0)
   * Offset: 0xd4
   * Address: 0x2d4
   *******************************************************************/
   pRegister = createRegister(pSection, "flag", 0xd4, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "jtgd", 11, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // flag(11)
   pRegister->addField(createField(pRegister, "jtgr", 10, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // flag(10)
   pRegister->addField(createField(pRegister, "ref", 9, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // flag(9)
   pRegister->addField(createField(pRegister, "alarm_6", 7, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // flag(7)
   pRegister->addField(createField(pRegister, "alarm_5", 6, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // flag(6)
   pRegister->addField(createField(pRegister, "alarm_4", 5, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // flag(5)
   pRegister->addField(createField(pRegister, "alarm_3", 4, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // flag(4)
   pRegister->addField(createField(pRegister, "over_temperature", 3, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // flag(3)
   pRegister->addField(createField(pRegister, "alarm_2", 2, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // flag(2)
   pRegister->addField(createField(pRegister, "alarm_1", 1, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // flag(1)
   pRegister->addField(createField(pRegister, "alarm_0", 0, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // flag(0)


   /******************************************************************
   * Section: //control
   * Offset: 0x300
   *******************************************************************/
   pSection = createSection(this, "control", 0x300);
   this->addSection(pSection);

   /******************************************************************
   * Register: //control/config_0(31:0)
   * Offset: 0x0
   * Address: 0x300
   *******************************************************************/
   pRegister = createRegister(pSection, "config_0", 0x0, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "cavg", 15, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // config_0(15)
   pRegister->addField(createField(pRegister, "avg", 12, 2, CfdkField::RW, 0x0, 0x3, 0x3)); // config_0(13:12)
   pRegister->addField(createField(pRegister, "mux", 11, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // config_0(11)
   pRegister->addField(createField(pRegister, "bu", 10, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // config_0(10)
   pRegister->addField(createField(pRegister, "ec", 9, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // config_0(9)
   pRegister->addField(createField(pRegister, "acq", 8, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // config_0(8)
   pRegister->addField(createField(pRegister, "input_channel", 0, 5, CfdkField::RW, 0x0, 0x1f, 0x1f)); // config_0(4:0)

   /******************************************************************
   * Register: //control/config_1(31:0)
   * Offset: 0x4
   * Address: 0x304
   *******************************************************************/
   pRegister = createRegister(pSection, "config_1", 0x4, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "seq", 12, 4, CfdkField::RW, 0x0, 0xf, 0xf)); // config_1(15:12)
   pRegister->addField(createField(pRegister, "alarm_6_disable", 11, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // config_1(11)
   pRegister->addField(createField(pRegister, "alarm_5_disable", 10, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // config_1(10)
   pRegister->addField(createField(pRegister, "alarm_4_disable", 9, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // config_1(9)
   pRegister->addField(createField(pRegister, "alarm_3_disable", 8, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // config_1(8)
   pRegister->addField(createField(pRegister, "cal_enable_3", 7, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // config_1(7)
   pRegister->addField(createField(pRegister, "cal_enable_2", 6, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // config_1(6)
   pRegister->addField(createField(pRegister, "cal_enable_1", 5, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // config_1(5)
   pRegister->addField(createField(pRegister, "cal_enable_0", 4, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // config_1(4)
   pRegister->addField(createField(pRegister, "alarm_2_disable", 3, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // config_1(3)
   pRegister->addField(createField(pRegister, "alarm_1_disable", 2, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // config_1(2)
   pRegister->addField(createField(pRegister, "alarm_0_disable", 1, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // config_1(1)
   pRegister->addField(createField(pRegister, "ot_disable", 0, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // config_1(0)

   /******************************************************************
   * Register: //control/config_2(31:0)
   * Offset: 0x8
   * Address: 0x308
   *******************************************************************/
   pRegister = createRegister(pSection, "config_2", 0x8, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "cd", 8, 8, CfdkField::RW, 0x1e, 0xff, 0xff)); // config_2(15:8)
   pRegister->addField(createField(pRegister, "pd", 4, 2, CfdkField::RW, 0x0, 0x3, 0x3)); // config_2(5:4)


   /******************************************************************
   * Section: //alarm_tresholds
   * Offset: 0x340
   *******************************************************************/
   pSection = createSection(this, "alarm_tresholds", 0x340);
   this->addSection(pSection);

   /******************************************************************
   * Register: //alarm_tresholds/temperature_upper(31:0)
   * Offset: 0x0
   * Address: 0x340
   *******************************************************************/
   pRegister = createRegister(pSection, "temperature_upper", 0x0, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RW, 0x0, 0xfff, 0xfff)); // temperature_upper(15:4)

   /******************************************************************
   * Register: //alarm_tresholds/vccint_upper(31:0)
   * Offset: 0x4
   * Address: 0x344
   *******************************************************************/
   pRegister = createRegister(pSection, "vccint_upper", 0x4, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RW, 0x0, 0xfff, 0xfff)); // vccint_upper(15:4)

   /******************************************************************
   * Register: //alarm_tresholds/vccaux_upper(31:0)
   * Offset: 0x8
   * Address: 0x348
   *******************************************************************/
   pRegister = createRegister(pSection, "vccaux_upper", 0x8, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RW, 0x0, 0xfff, 0xfff)); // vccaux_upper(15:4)

   /******************************************************************
   * Register: //alarm_tresholds/ot_alarm_limit(31:0)
   * Offset: 0xc
   * Address: 0x34c
   *******************************************************************/
   pRegister = createRegister(pSection, "ot_alarm_limit", 0xc, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RW, 0x0, 0xfff, 0xfff)); // ot_alarm_limit(15:4)

   /******************************************************************
   * Register: //alarm_tresholds/temperature_lower(31:0)
   * Offset: 0x10
   * Address: 0x350
   *******************************************************************/
   pRegister = createRegister(pSection, "temperature_lower", 0x10, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RW, 0x0, 0xfff, 0xfff)); // temperature_lower(15:4)

   /******************************************************************
   * Register: //alarm_tresholds/vccint_lower(31:0)
   * Offset: 0x14
   * Address: 0x354
   *******************************************************************/
   pRegister = createRegister(pSection, "vccint_lower", 0x14, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RW, 0x0, 0xfff, 0xfff)); // vccint_lower(15:4)

   /******************************************************************
   * Register: //alarm_tresholds/vccaux_lower(31:0)
   * Offset: 0x18
   * Address: 0x358
   *******************************************************************/
   pRegister = createRegister(pSection, "vccaux_lower", 0x18, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RW, 0x0, 0xfff, 0xfff)); // vccaux_lower(15:4)

   /******************************************************************
   * Register: //alarm_tresholds/ot_alarm_reset(31:0)
   * Offset: 0x1c
   * Address: 0x35c
   *******************************************************************/
   pRegister = createRegister(pSection, "ot_alarm_reset", 0x1c, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RW, 0x0, 0xfff, 0xfff)); // ot_alarm_reset(15:4)

   /******************************************************************
   * Register: //alarm_tresholds/vccbram_upper(31:0)
   * Offset: 0x20
   * Address: 0x360
   *******************************************************************/
   pRegister = createRegister(pSection, "vccbram_upper", 0x20, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RW, 0x0, 0xfff, 0xfff)); // vccbram_upper(15:4)

   /******************************************************************
   * Register: //alarm_tresholds/vccpint_upper(31:0)
   * Offset: 0x24
   * Address: 0x364
   *******************************************************************/
   pRegister = createRegister(pSection, "vccpint_upper", 0x24, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RW, 0x0, 0xfff, 0xfff)); // vccpint_upper(15:4)

   /******************************************************************
   * Register: //alarm_tresholds/vccpaux_upper(31:0)
   * Offset: 0x28
   * Address: 0x368
   *******************************************************************/
   pRegister = createRegister(pSection, "vccpaux_upper", 0x28, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RW, 0x0, 0xfff, 0xfff)); // vccpaux_upper(15:4)

   /******************************************************************
   * Register: //alarm_tresholds/vcco_ddr_upper(31:0)
   * Offset: 0x2c
   * Address: 0x36c
   *******************************************************************/
   pRegister = createRegister(pSection, "vcco_ddr_upper", 0x2c, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RW, 0x0, 0xfff, 0xfff)); // vcco_ddr_upper(15:4)

   /******************************************************************
   * Register: //alarm_tresholds/vccbram_lower(31:0)
   * Offset: 0x30
   * Address: 0x370
   *******************************************************************/
   pRegister = createRegister(pSection, "vccbram_lower", 0x30, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RW, 0x0, 0xfff, 0xfff)); // vccbram_lower(15:4)

   /******************************************************************
   * Register: //alarm_tresholds/vccpint_lower(31:0)
   * Offset: 0x34
   * Address: 0x374
   *******************************************************************/
   pRegister = createRegister(pSection, "vccpint_lower", 0x34, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RW, 0x0, 0xfff, 0xfff)); // vccpint_lower(15:4)

   /******************************************************************
   * Register: //alarm_tresholds/vccpaux_lower(31:0)
   * Offset: 0x38
   * Address: 0x378
   *******************************************************************/
   pRegister = createRegister(pSection, "vccpaux_lower", 0x38, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RW, 0x0, 0xfff, 0xfff)); // vccpaux_lower(15:4)

   /******************************************************************
   * Register: //alarm_tresholds/vcco_ddr_lower(31:0)
   * Offset: 0x3c
   * Address: 0x37c
   *******************************************************************/
   pRegister = createRegister(pSection, "vcco_ddr_lower", 0x3c, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 4, 12, CfdkField::RW, 0x0, 0xfff, 0xfff)); // vcco_ddr_lower(15:4)


}


