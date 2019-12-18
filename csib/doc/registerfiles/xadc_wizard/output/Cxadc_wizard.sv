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
import registerfile_pkg::*;

class Cxadc_wizard extends Cregisterfile;

   function new();
      Csection section;
      Cexternal external;
      Cregister register;
      Cfield field;

      super.new("Cxadc_wizard");

      super.addrWidth = 9;
      super.dataWidth = 32;
      super.littleEndian = 1;

      /***************************************************************
      * Section: //local_register
      * Offset: 0x0
      ****************************************************************/
      section = new("local_register");
      section.offset = 0;
      super.childList.push_back(section);

      /***************************************************************
      * Register: //local_register/ssr(31:0)
      * Offset: 0x0
      * Address: 0x0
      ****************************************************************/
      register = new("ssr");
      register.offset = 0;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //local_register/ssr(31:0) <<= value(31:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 0;
      field.size = 32;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //local_register/sr(31:0)
      * Offset: 0x4
      * Address: 0x4
      ****************************************************************/
      register = new("sr");
      register.offset = 4;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //local_register/sr <<= jtag_busy(10)
      ****************************************************************/
      field = new("jtag_busy");
      field.lsb = 10;
      field.size = 1;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //local_register/sr <<= jtag_modified(9)
      ****************************************************************/
      field = new("jtag_modified");
      field.lsb = 9;
      field.size = 1;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //local_register/sr <<= jtag_locked(8)
      ****************************************************************/
      field = new("jtag_locked");
      field.lsb = 8;
      field.size = 1;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //local_register/sr <<= busy(7)
      ****************************************************************/
      field = new("busy");
      field.lsb = 7;
      field.size = 1;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //local_register/sr <<= eos(6)
      ****************************************************************/
      field = new("eos");
      field.lsb = 6;
      field.size = 1;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //local_register/sr <<= eoc(5)
      ****************************************************************/
      field = new("eoc");
      field.lsb = 5;
      field.size = 1;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //local_register/sr(4:0) <<= channel(4:0)
      ****************************************************************/
      field = new("channel");
      field.lsb = 0;
      field.size = 5;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //local_register/aosr(31:0)
      * Offset: 0x8
      * Address: 0x8
      ****************************************************************/
      register = new("aosr");
      register.offset = 8;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //local_register/aosr <<= alarm_7(8)
      ****************************************************************/
      field = new("alarm_7");
      field.lsb = 8;
      field.size = 1;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //local_register/aosr <<= alarm_6(7)
      ****************************************************************/
      field = new("alarm_6");
      field.lsb = 7;
      field.size = 1;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //local_register/aosr <<= alarm_5(6)
      ****************************************************************/
      field = new("alarm_5");
      field.lsb = 6;
      field.size = 1;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //local_register/aosr <<= alarm_4(5)
      ****************************************************************/
      field = new("alarm_4");
      field.lsb = 5;
      field.size = 1;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //local_register/aosr <<= alarm_3(4)
      ****************************************************************/
      field = new("alarm_3");
      field.lsb = 4;
      field.size = 1;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //local_register/aosr <<= alarm_2(3)
      ****************************************************************/
      field = new("alarm_2");
      field.lsb = 3;
      field.size = 1;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //local_register/aosr <<= alarm_1(2)
      ****************************************************************/
      field = new("alarm_1");
      field.lsb = 2;
      field.size = 1;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //local_register/aosr <<= alarm_0(1)
      ****************************************************************/
      field = new("alarm_0");
      field.lsb = 1;
      field.size = 1;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //local_register/aosr <<= over_temperature(0)
      ****************************************************************/
      field = new("over_temperature");
      field.lsb = 0;
      field.size = 1;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //local_register/convstr(31:0)
      * Offset: 0xc
      * Address: 0xc
      ****************************************************************/
      register = new("convstr");
      register.offset = 12;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //local_register/convstr(17:2) <<= temp_rd_wait_cycle(15:0)
      ****************************************************************/
      field = new("temp_rd_wait_cycle");
      field.lsb = 2;
      field.size = 16;
      field.access_type = ACC_TYPES.RW;
      field.value = 1000;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //local_register/convstr <<= temp_bus_update(1)
      ****************************************************************/
      field = new("temp_bus_update");
      field.lsb = 1;
      field.size = 1;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //local_register/convstr <<= convst(0)
      ****************************************************************/
      field = new("convst");
      field.lsb = 0;
      field.size = 1;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //local_register/xadc_reset(31:0)
      * Offset: 0x10
      * Address: 0x10
      ****************************************************************/
      register = new("xadc_reset");
      register.offset = 16;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //local_register/xadc_reset <<= reset(0)
      ****************************************************************/
      field = new("reset");
      field.lsb = 0;
      field.size = 1;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);



      /***************************************************************
      * Section: //interrupt_controller
      * Offset: 0x5c
      ****************************************************************/
      section = new("interrupt_controller");
      section.offset = 92;
      super.childList.push_back(section);

      /***************************************************************
      * Register: //interrupt_controller/global_interrupt(31:0)
      * Offset: 0x0
      * Address: 0x5c
      ****************************************************************/
      register = new("global_interrupt");
      register.offset = 0;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //interrupt_controller/global_interrupt <<= enable(31)
      ****************************************************************/
      field = new("enable");
      field.lsb = 31;
      field.size = 1;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //interrupt_controller/interrupt_status(31:0)
      * Offset: 0x4
      * Address: 0x60
      ****************************************************************/
      register = new("interrupt_status");
      register.offset = 4;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //interrupt_controller/interrupt_status <<= alarm_6(13)
      ****************************************************************/
      field = new("alarm_6");
      field.lsb = 13;
      field.size = 1;
      field.access_type = ACC_TYPES.RW2C;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //interrupt_controller/interrupt_status <<= alarm_5(12)
      ****************************************************************/
      field = new("alarm_5");
      field.lsb = 12;
      field.size = 1;
      field.access_type = ACC_TYPES.RW2C;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //interrupt_controller/interrupt_status <<= alarm_4(11)
      ****************************************************************/
      field = new("alarm_4");
      field.lsb = 11;
      field.size = 1;
      field.access_type = ACC_TYPES.RW2C;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //interrupt_controller/interrupt_status <<= alarm_2(10)
      ****************************************************************/
      field = new("alarm_2");
      field.lsb = 10;
      field.size = 1;
      field.access_type = ACC_TYPES.RW2C;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //interrupt_controller/interrupt_status <<= alarm_0_deactive(9)
      ****************************************************************/
      field = new("alarm_0_deactive");
      field.lsb = 9;
      field.size = 1;
      field.access_type = ACC_TYPES.RW2C;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //interrupt_controller/interrupt_status <<= over_temperature_deactive(8)
      ****************************************************************/
      field = new("over_temperature_deactive");
      field.lsb = 8;
      field.size = 1;
      field.access_type = ACC_TYPES.RW2C;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //interrupt_controller/interrupt_status <<= jtag_modified(7)
      ****************************************************************/
      field = new("jtag_modified");
      field.lsb = 7;
      field.size = 1;
      field.access_type = ACC_TYPES.RW2C;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //interrupt_controller/interrupt_status <<= jtag_locked(6)
      ****************************************************************/
      field = new("jtag_locked");
      field.lsb = 6;
      field.size = 1;
      field.access_type = ACC_TYPES.RW2C;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //interrupt_controller/interrupt_status <<= eoc(5)
      ****************************************************************/
      field = new("eoc");
      field.lsb = 5;
      field.size = 1;
      field.access_type = ACC_TYPES.RW2C;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //interrupt_controller/interrupt_status <<= eos(4)
      ****************************************************************/
      field = new("eos");
      field.lsb = 4;
      field.size = 1;
      field.access_type = ACC_TYPES.RW2C;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //interrupt_controller/interrupt_status <<= alarm_3(3)
      ****************************************************************/
      field = new("alarm_3");
      field.lsb = 3;
      field.size = 1;
      field.access_type = ACC_TYPES.RW2C;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //interrupt_controller/interrupt_status <<= alarm_1(2)
      ****************************************************************/
      field = new("alarm_1");
      field.lsb = 2;
      field.size = 1;
      field.access_type = ACC_TYPES.RW2C;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //interrupt_controller/interrupt_status <<= alarm_0(1)
      ****************************************************************/
      field = new("alarm_0");
      field.lsb = 1;
      field.size = 1;
      field.access_type = ACC_TYPES.RW2C;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //interrupt_controller/interrupt_status <<= over_temperature(0)
      ****************************************************************/
      field = new("over_temperature");
      field.lsb = 0;
      field.size = 1;
      field.access_type = ACC_TYPES.RW2C;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //interrupt_controller/interrupt_enable(31:0)
      * Offset: 0xc
      * Address: 0x68
      ****************************************************************/
      register = new("interrupt_enable");
      register.offset = 12;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //interrupt_controller/interrupt_enable <<= alarm_6(13)
      ****************************************************************/
      field = new("alarm_6");
      field.lsb = 13;
      field.size = 1;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //interrupt_controller/interrupt_enable <<= alarm_5(12)
      ****************************************************************/
      field = new("alarm_5");
      field.lsb = 12;
      field.size = 1;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //interrupt_controller/interrupt_enable <<= alarm_4(11)
      ****************************************************************/
      field = new("alarm_4");
      field.lsb = 11;
      field.size = 1;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //interrupt_controller/interrupt_enable <<= alarm_2(10)
      ****************************************************************/
      field = new("alarm_2");
      field.lsb = 10;
      field.size = 1;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //interrupt_controller/interrupt_enable <<= alarm_0_deactive(9)
      ****************************************************************/
      field = new("alarm_0_deactive");
      field.lsb = 9;
      field.size = 1;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //interrupt_controller/interrupt_enable <<= over_temperature_deactive(8)
      ****************************************************************/
      field = new("over_temperature_deactive");
      field.lsb = 8;
      field.size = 1;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //interrupt_controller/interrupt_enable <<= jtag_modified(7)
      ****************************************************************/
      field = new("jtag_modified");
      field.lsb = 7;
      field.size = 1;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //interrupt_controller/interrupt_enable <<= jtag_locked(6)
      ****************************************************************/
      field = new("jtag_locked");
      field.lsb = 6;
      field.size = 1;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //interrupt_controller/interrupt_enable <<= eoc(5)
      ****************************************************************/
      field = new("eoc");
      field.lsb = 5;
      field.size = 1;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //interrupt_controller/interrupt_enable <<= eos(4)
      ****************************************************************/
      field = new("eos");
      field.lsb = 4;
      field.size = 1;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //interrupt_controller/interrupt_enable <<= alarm_3(3)
      ****************************************************************/
      field = new("alarm_3");
      field.lsb = 3;
      field.size = 1;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //interrupt_controller/interrupt_enable <<= alarm_1(2)
      ****************************************************************/
      field = new("alarm_1");
      field.lsb = 2;
      field.size = 1;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //interrupt_controller/interrupt_enable <<= alarm_0(1)
      ****************************************************************/
      field = new("alarm_0");
      field.lsb = 1;
      field.size = 1;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //interrupt_controller/interrupt_enable <<= over_temperature(0)
      ****************************************************************/
      field = new("over_temperature");
      field.lsb = 0;
      field.size = 1;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);



      /***************************************************************
      * Section: //xadc_hard_macro
      * Offset: 0x200
      ****************************************************************/
      section = new("xadc_hard_macro");
      section.offset = 512;
      super.childList.push_back(section);

      /***************************************************************
      * Register: //xadc_hard_macro/temperature(31:0)
      * Offset: 0x0
      * Address: 0x200
      ****************************************************************/
      register = new("temperature");
      register.offset = 0;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/temperature(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/vcc_int(31:0)
      * Offset: 0x4
      * Address: 0x204
      ****************************************************************/
      register = new("vcc_int");
      register.offset = 4;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/vcc_int(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/vcc_aux(31:0)
      * Offset: 0x8
      * Address: 0x208
      ****************************************************************/
      register = new("vcc_aux");
      register.offset = 8;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/vcc_aux(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/vp_vn(31:0)
      * Offset: 0xc
      * Address: 0x20c
      ****************************************************************/
      register = new("vp_vn");
      register.offset = 12;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/vp_vn(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/vref_p(31:0)
      * Offset: 0x10
      * Address: 0x210
      ****************************************************************/
      register = new("vref_p");
      register.offset = 16;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/vref_p(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/vref_n(31:0)
      * Offset: 0x14
      * Address: 0x214
      ****************************************************************/
      register = new("vref_n");
      register.offset = 20;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/vref_n(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/vcc_bram(31:0)
      * Offset: 0x18
      * Address: 0x218
      ****************************************************************/
      register = new("vcc_bram");
      register.offset = 24;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/vcc_bram(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/supply_a_offset(31:0)
      * Offset: 0x20
      * Address: 0x220
      ****************************************************************/
      register = new("supply_a_offset");
      register.offset = 32;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/supply_a_offset(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/adc_a_offset(31:0)
      * Offset: 0x24
      * Address: 0x224
      ****************************************************************/
      register = new("adc_a_offset");
      register.offset = 36;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/adc_a_offset(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/adc_a_gain(31:0)
      * Offset: 0x28
      * Address: 0x228
      ****************************************************************/
      register = new("adc_a_gain");
      register.offset = 40;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/adc_a_gain <<= sign(6)
      ****************************************************************/
      field = new("sign");
      field.lsb = 6;
      field.size = 1;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //xadc_hard_macro/adc_a_gain(5:0) <<= mag(5:0)
      ****************************************************************/
      field = new("mag");
      field.lsb = 0;
      field.size = 6;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/vcc_pint(31:0)
      * Offset: 0x34
      * Address: 0x234
      ****************************************************************/
      register = new("vcc_pint");
      register.offset = 52;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/vcc_pint(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/vcc_paux(31:0)
      * Offset: 0x38
      * Address: 0x238
      ****************************************************************/
      register = new("vcc_paux");
      register.offset = 56;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/vcc_paux(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/vcco_ddr(31:0)
      * Offset: 0x3c
      * Address: 0x23c
      ****************************************************************/
      register = new("vcco_ddr");
      register.offset = 60;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/vcco_ddr(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/vaux_p_n[0](31:0)
      * Offset: 0x40
      * Address: 0x240
      ****************************************************************/
      register = new("vaux_p_n[0]");
      register.offset = 64;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/vaux_p_n[0](15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/vaux_p_n[1](31:0)
      * Offset: 0x44
      * Address: 0x244
      ****************************************************************/
      register = new("vaux_p_n[1]");
      register.offset = 68;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/vaux_p_n[1](15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/vaux_p_n[2](31:0)
      * Offset: 0x48
      * Address: 0x248
      ****************************************************************/
      register = new("vaux_p_n[2]");
      register.offset = 72;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/vaux_p_n[2](15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/vaux_p_n[3](31:0)
      * Offset: 0x4c
      * Address: 0x24c
      ****************************************************************/
      register = new("vaux_p_n[3]");
      register.offset = 76;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/vaux_p_n[3](15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/vaux_p_n[4](31:0)
      * Offset: 0x50
      * Address: 0x250
      ****************************************************************/
      register = new("vaux_p_n[4]");
      register.offset = 80;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/vaux_p_n[4](15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/vaux_p_n[5](31:0)
      * Offset: 0x54
      * Address: 0x254
      ****************************************************************/
      register = new("vaux_p_n[5]");
      register.offset = 84;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/vaux_p_n[5](15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/vaux_p_n[6](31:0)
      * Offset: 0x58
      * Address: 0x258
      ****************************************************************/
      register = new("vaux_p_n[6]");
      register.offset = 88;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/vaux_p_n[6](15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/vaux_p_n[7](31:0)
      * Offset: 0x5c
      * Address: 0x25c
      ****************************************************************/
      register = new("vaux_p_n[7]");
      register.offset = 92;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/vaux_p_n[7](15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/vaux_p_n[8](31:0)
      * Offset: 0x60
      * Address: 0x260
      ****************************************************************/
      register = new("vaux_p_n[8]");
      register.offset = 96;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/vaux_p_n[8](15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/vaux_p_n[9](31:0)
      * Offset: 0x64
      * Address: 0x264
      ****************************************************************/
      register = new("vaux_p_n[9]");
      register.offset = 100;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/vaux_p_n[9](15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/vaux_p_n[10](31:0)
      * Offset: 0x68
      * Address: 0x268
      ****************************************************************/
      register = new("vaux_p_n[10]");
      register.offset = 104;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/vaux_p_n[10](15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/vaux_p_n[11](31:0)
      * Offset: 0x6c
      * Address: 0x26c
      ****************************************************************/
      register = new("vaux_p_n[11]");
      register.offset = 108;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/vaux_p_n[11](15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/vaux_p_n[12](31:0)
      * Offset: 0x70
      * Address: 0x270
      ****************************************************************/
      register = new("vaux_p_n[12]");
      register.offset = 112;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/vaux_p_n[12](15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/vaux_p_n[13](31:0)
      * Offset: 0x74
      * Address: 0x274
      ****************************************************************/
      register = new("vaux_p_n[13]");
      register.offset = 116;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/vaux_p_n[13](15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/vaux_p_n[14](31:0)
      * Offset: 0x78
      * Address: 0x278
      ****************************************************************/
      register = new("vaux_p_n[14]");
      register.offset = 120;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/vaux_p_n[14](15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/vaux_p_n[15](31:0)
      * Offset: 0x7c
      * Address: 0x27c
      ****************************************************************/
      register = new("vaux_p_n[15]");
      register.offset = 124;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/vaux_p_n[15](15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/max_temperature(31:0)
      * Offset: 0x80
      * Address: 0x280
      ****************************************************************/
      register = new("max_temperature");
      register.offset = 128;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/max_temperature(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/max_vcc_int(31:0)
      * Offset: 0x84
      * Address: 0x284
      ****************************************************************/
      register = new("max_vcc_int");
      register.offset = 132;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/max_vcc_int(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/max_vcc_aux(31:0)
      * Offset: 0x88
      * Address: 0x288
      ****************************************************************/
      register = new("max_vcc_aux");
      register.offset = 136;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/max_vcc_aux(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/max_vcc_bram(31:0)
      * Offset: 0x8c
      * Address: 0x28c
      ****************************************************************/
      register = new("max_vcc_bram");
      register.offset = 140;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/max_vcc_bram(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/min_temperature(31:0)
      * Offset: 0x90
      * Address: 0x290
      ****************************************************************/
      register = new("min_temperature");
      register.offset = 144;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/min_temperature(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/min_vcc_int(31:0)
      * Offset: 0x94
      * Address: 0x294
      ****************************************************************/
      register = new("min_vcc_int");
      register.offset = 148;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/min_vcc_int(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/min_vcc_aux(31:0)
      * Offset: 0x98
      * Address: 0x298
      ****************************************************************/
      register = new("min_vcc_aux");
      register.offset = 152;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/min_vcc_aux(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/min_vcc_bram(31:0)
      * Offset: 0x9c
      * Address: 0x29c
      ****************************************************************/
      register = new("min_vcc_bram");
      register.offset = 156;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/min_vcc_bram(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/max_vcc_pint(31:0)
      * Offset: 0xa0
      * Address: 0x2a0
      ****************************************************************/
      register = new("max_vcc_pint");
      register.offset = 160;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/max_vcc_pint(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/max_vcc_paux(31:0)
      * Offset: 0xa4
      * Address: 0x2a4
      ****************************************************************/
      register = new("max_vcc_paux");
      register.offset = 164;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/max_vcc_paux(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/max_vcco_ddr(31:0)
      * Offset: 0xa8
      * Address: 0x2a8
      ****************************************************************/
      register = new("max_vcco_ddr");
      register.offset = 168;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/max_vcco_ddr(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/min_vcc_pint(31:0)
      * Offset: 0xb0
      * Address: 0x2b0
      ****************************************************************/
      register = new("min_vcc_pint");
      register.offset = 176;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/min_vcc_pint(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/min_vcc_paux(31:0)
      * Offset: 0xb4
      * Address: 0x2b4
      ****************************************************************/
      register = new("min_vcc_paux");
      register.offset = 180;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/min_vcc_paux(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/main_vcco_ddr(31:0)
      * Offset: 0xb8
      * Address: 0x2b8
      ****************************************************************/
      register = new("main_vcco_ddr");
      register.offset = 184;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/main_vcco_ddr(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/supply_b_offset(31:0)
      * Offset: 0xc0
      * Address: 0x2c0
      ****************************************************************/
      register = new("supply_b_offset");
      register.offset = 192;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/supply_b_offset(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/adc_b_offset(31:0)
      * Offset: 0xc4
      * Address: 0x2c4
      ****************************************************************/
      register = new("adc_b_offset");
      register.offset = 196;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/adc_b_offset(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/adc_b_gain(31:0)
      * Offset: 0xc8
      * Address: 0x2c8
      ****************************************************************/
      register = new("adc_b_gain");
      register.offset = 200;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/adc_b_gain <<= sign(6)
      ****************************************************************/
      field = new("sign");
      field.lsb = 6;
      field.size = 1;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //xadc_hard_macro/adc_b_gain(5:0) <<= mag(5:0)
      ****************************************************************/
      field = new("mag");
      field.lsb = 0;
      field.size = 6;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //xadc_hard_macro/flag(31:0)
      * Offset: 0xd4
      * Address: 0x2d4
      ****************************************************************/
      register = new("flag");
      register.offset = 212;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //xadc_hard_macro/flag <<= jtgd(11)
      ****************************************************************/
      field = new("jtgd");
      field.lsb = 11;
      field.size = 1;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //xadc_hard_macro/flag <<= jtgr(10)
      ****************************************************************/
      field = new("jtgr");
      field.lsb = 10;
      field.size = 1;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //xadc_hard_macro/flag <<= ref(9)
      ****************************************************************/
      field = new("ref");
      field.lsb = 9;
      field.size = 1;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //xadc_hard_macro/flag <<= alarm_6(7)
      ****************************************************************/
      field = new("alarm_6");
      field.lsb = 7;
      field.size = 1;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //xadc_hard_macro/flag <<= alarm_5(6)
      ****************************************************************/
      field = new("alarm_5");
      field.lsb = 6;
      field.size = 1;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //xadc_hard_macro/flag <<= alarm_4(5)
      ****************************************************************/
      field = new("alarm_4");
      field.lsb = 5;
      field.size = 1;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //xadc_hard_macro/flag <<= alarm_3(4)
      ****************************************************************/
      field = new("alarm_3");
      field.lsb = 4;
      field.size = 1;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //xadc_hard_macro/flag <<= over_temperature(3)
      ****************************************************************/
      field = new("over_temperature");
      field.lsb = 3;
      field.size = 1;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //xadc_hard_macro/flag <<= alarm_2(2)
      ****************************************************************/
      field = new("alarm_2");
      field.lsb = 2;
      field.size = 1;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //xadc_hard_macro/flag <<= alarm_1(1)
      ****************************************************************/
      field = new("alarm_1");
      field.lsb = 1;
      field.size = 1;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //xadc_hard_macro/flag <<= alarm_0(0)
      ****************************************************************/
      field = new("alarm_0");
      field.lsb = 0;
      field.size = 1;
      field.access_type = ACC_TYPES.RO;
      field.value = 0;
      register.childList.push_back(field);



      /***************************************************************
      * Section: //control
      * Offset: 0x300
      ****************************************************************/
      section = new("control");
      section.offset = 768;
      super.childList.push_back(section);

      /***************************************************************
      * Register: //control/config_0(31:0)
      * Offset: 0x0
      * Address: 0x300
      ****************************************************************/
      register = new("config_0");
      register.offset = 0;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //control/config_0 <<= cavg(15)
      ****************************************************************/
      field = new("cavg");
      field.lsb = 15;
      field.size = 1;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //control/config_0(13:12) <<= avg(1:0)
      ****************************************************************/
      field = new("avg");
      field.lsb = 12;
      field.size = 2;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //control/config_0 <<= mux(11)
      ****************************************************************/
      field = new("mux");
      field.lsb = 11;
      field.size = 1;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //control/config_0 <<= bu(10)
      ****************************************************************/
      field = new("bu");
      field.lsb = 10;
      field.size = 1;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //control/config_0 <<= ec(9)
      ****************************************************************/
      field = new("ec");
      field.lsb = 9;
      field.size = 1;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //control/config_0 <<= acq(8)
      ****************************************************************/
      field = new("acq");
      field.lsb = 8;
      field.size = 1;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //control/config_0(4:0) <<= input_channel(4:0)
      ****************************************************************/
      field = new("input_channel");
      field.lsb = 0;
      field.size = 5;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //control/config_1(31:0)
      * Offset: 0x4
      * Address: 0x304
      ****************************************************************/
      register = new("config_1");
      register.offset = 4;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //control/config_1(15:12) <<= seq(3:0)
      ****************************************************************/
      field = new("seq");
      field.lsb = 12;
      field.size = 4;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //control/config_1 <<= alarm_6_disable(11)
      ****************************************************************/
      field = new("alarm_6_disable");
      field.lsb = 11;
      field.size = 1;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //control/config_1 <<= alarm_5_disable(10)
      ****************************************************************/
      field = new("alarm_5_disable");
      field.lsb = 10;
      field.size = 1;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //control/config_1 <<= alarm_4_disable(9)
      ****************************************************************/
      field = new("alarm_4_disable");
      field.lsb = 9;
      field.size = 1;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //control/config_1 <<= alarm_3_disable(8)
      ****************************************************************/
      field = new("alarm_3_disable");
      field.lsb = 8;
      field.size = 1;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //control/config_1 <<= cal_enable_3(7)
      ****************************************************************/
      field = new("cal_enable_3");
      field.lsb = 7;
      field.size = 1;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //control/config_1 <<= cal_enable_2(6)
      ****************************************************************/
      field = new("cal_enable_2");
      field.lsb = 6;
      field.size = 1;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //control/config_1 <<= cal_enable_1(5)
      ****************************************************************/
      field = new("cal_enable_1");
      field.lsb = 5;
      field.size = 1;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //control/config_1 <<= cal_enable_0(4)
      ****************************************************************/
      field = new("cal_enable_0");
      field.lsb = 4;
      field.size = 1;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //control/config_1 <<= alarm_2_disable(3)
      ****************************************************************/
      field = new("alarm_2_disable");
      field.lsb = 3;
      field.size = 1;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //control/config_1 <<= alarm_1_disable(2)
      ****************************************************************/
      field = new("alarm_1_disable");
      field.lsb = 2;
      field.size = 1;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //control/config_1 <<= alarm_0_disable(1)
      ****************************************************************/
      field = new("alarm_0_disable");
      field.lsb = 1;
      field.size = 1;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //control/config_1 <<= ot_disable(0)
      ****************************************************************/
      field = new("ot_disable");
      field.lsb = 0;
      field.size = 1;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //control/config_2(31:0)
      * Offset: 0x8
      * Address: 0x308
      ****************************************************************/
      register = new("config_2");
      register.offset = 8;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //control/config_2(15:8) <<= cd(7:0)
      ****************************************************************/
      field = new("cd");
      field.lsb = 8;
      field.size = 8;
      field.access_type = ACC_TYPES.RW;
      field.value = 30;
      register.childList.push_back(field);

      /***************************************************************
      * Field : //control/config_2(5:4) <<= pd(1:0)
      ****************************************************************/
      field = new("pd");
      field.lsb = 4;
      field.size = 2;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);



      /***************************************************************
      * Section: //alarm_tresholds
      * Offset: 0x340
      ****************************************************************/
      section = new("alarm_tresholds");
      section.offset = 832;
      super.childList.push_back(section);

      /***************************************************************
      * Register: //alarm_tresholds/temperature_upper(31:0)
      * Offset: 0x0
      * Address: 0x340
      ****************************************************************/
      register = new("temperature_upper");
      register.offset = 0;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //alarm_tresholds/temperature_upper(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //alarm_tresholds/vccint_upper(31:0)
      * Offset: 0x4
      * Address: 0x344
      ****************************************************************/
      register = new("vccint_upper");
      register.offset = 4;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //alarm_tresholds/vccint_upper(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //alarm_tresholds/vccaux_upper(31:0)
      * Offset: 0x8
      * Address: 0x348
      ****************************************************************/
      register = new("vccaux_upper");
      register.offset = 8;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //alarm_tresholds/vccaux_upper(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //alarm_tresholds/ot_alarm_limit(31:0)
      * Offset: 0xc
      * Address: 0x34c
      ****************************************************************/
      register = new("ot_alarm_limit");
      register.offset = 12;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //alarm_tresholds/ot_alarm_limit(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //alarm_tresholds/temperature_lower(31:0)
      * Offset: 0x10
      * Address: 0x350
      ****************************************************************/
      register = new("temperature_lower");
      register.offset = 16;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //alarm_tresholds/temperature_lower(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //alarm_tresholds/vccint_lower(31:0)
      * Offset: 0x14
      * Address: 0x354
      ****************************************************************/
      register = new("vccint_lower");
      register.offset = 20;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //alarm_tresholds/vccint_lower(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //alarm_tresholds/vccaux_lower(31:0)
      * Offset: 0x18
      * Address: 0x358
      ****************************************************************/
      register = new("vccaux_lower");
      register.offset = 24;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //alarm_tresholds/vccaux_lower(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //alarm_tresholds/ot_alarm_reset(31:0)
      * Offset: 0x1c
      * Address: 0x35c
      ****************************************************************/
      register = new("ot_alarm_reset");
      register.offset = 28;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //alarm_tresholds/ot_alarm_reset(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //alarm_tresholds/vccbram_upper(31:0)
      * Offset: 0x20
      * Address: 0x360
      ****************************************************************/
      register = new("vccbram_upper");
      register.offset = 32;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //alarm_tresholds/vccbram_upper(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //alarm_tresholds/vccpint_upper(31:0)
      * Offset: 0x24
      * Address: 0x364
      ****************************************************************/
      register = new("vccpint_upper");
      register.offset = 36;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //alarm_tresholds/vccpint_upper(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //alarm_tresholds/vccpaux_upper(31:0)
      * Offset: 0x28
      * Address: 0x368
      ****************************************************************/
      register = new("vccpaux_upper");
      register.offset = 40;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //alarm_tresholds/vccpaux_upper(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //alarm_tresholds/vcco_ddr_upper(31:0)
      * Offset: 0x2c
      * Address: 0x36c
      ****************************************************************/
      register = new("vcco_ddr_upper");
      register.offset = 44;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //alarm_tresholds/vcco_ddr_upper(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //alarm_tresholds/vccbram_lower(31:0)
      * Offset: 0x30
      * Address: 0x370
      ****************************************************************/
      register = new("vccbram_lower");
      register.offset = 48;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //alarm_tresholds/vccbram_lower(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //alarm_tresholds/vccpint_lower(31:0)
      * Offset: 0x34
      * Address: 0x374
      ****************************************************************/
      register = new("vccpint_lower");
      register.offset = 52;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //alarm_tresholds/vccpint_lower(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //alarm_tresholds/vccpaux_lower(31:0)
      * Offset: 0x38
      * Address: 0x378
      ****************************************************************/
      register = new("vccpaux_lower");
      register.offset = 56;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //alarm_tresholds/vccpaux_lower(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);


      /***************************************************************
      * Register: //alarm_tresholds/vcco_ddr_lower(31:0)
      * Offset: 0x3c
      * Address: 0x37c
      ****************************************************************/
      register = new("vcco_ddr_lower");
      register.offset = 60;
      section.childList.push_back(register);

      /***************************************************************
      * Field : //alarm_tresholds/vcco_ddr_lower(15:4) <<= value(11:0)
      ****************************************************************/
      field = new("value");
      field.lsb = 4;
      field.size = 12;
      field.access_type = ACC_TYPES.RW;
      field.value = 0;
      register.childList.push_back(field);



   endfunction;

endclass
