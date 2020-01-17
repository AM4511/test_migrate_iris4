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
**  COPYRIGHT (c) 2011 Matrox Electronic Systems Ltd.
**  All Rights Reserved
**
*****************************************************************************/
public class Cxadc_wizard  extends CRegisterFile {


   public Cxadc_wizard()
   {
      super("xadc_wizard", 11, 32, true);

      CSection section;
      CExternal external;
      CRegister register;
      /***************************************************************
      * Section: local_register
      * Offset: 0x0
      ****************************************************************/
      section = new CSection(this, "local_register", "XADC Wizard Local Register Grouping", 0x0);
      super.childrenList.add(section);

      /***************************************************************
      * Register: ssr
      * Offset: 0x0
      ****************************************************************/
      register = new CRegister(section, "ssr", "Software Reset Register (SSR)", 0x0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "null", CField.FieldType.RW, 0, 32, 0x0));

      /***************************************************************
      * Register: sr
      * Offset: 0x4
      ****************************************************************/
      register = new CRegister(section, "sr", "Status Register (SR)", 0x4);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "jtag_busy", "JTAG busy", CField.FieldType.RO, 10, 1, 0x0));
      register.addField(new CField(register, "jtag_modified", "JTAG modified", CField.FieldType.RO, 9, 1, 0x0));
      register.addField(new CField(register, "jtag_locked", "JTAG locked", CField.FieldType.RO, 8, 1, 0x0));
      register.addField(new CField(register, "busy", "ADC busy signal", CField.FieldType.RO, 7, 1, 0x0));
      register.addField(new CField(register, "eos", "End of Sequence", CField.FieldType.RO, 6, 1, 0x0));
      register.addField(new CField(register, "eoc", "End of Conversion signal", CField.FieldType.RO, 5, 1, 0x0));
      register.addField(new CField(register, "channel", "Channel selection outputs", CField.FieldType.RO, 0, 5, 0x0));

      /***************************************************************
      * Register: aosr
      * Offset: 0x8
      ****************************************************************/
      register = new CRegister(section, "aosr", "Alarm Output Status Register (AOSR)", 0x8);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "alarm_7", "Logical ORing of ALARM bits 0 to 7", CField.FieldType.RO, 8, 1, 0x0));
      register.addField(new CField(register, "alarm_6", "XADC VCCDDRO-Sensor Status", CField.FieldType.RO, 7, 1, 0x0));
      register.addField(new CField(register, "alarm_5", "XADC VCCPAUX-Sensor Status", CField.FieldType.RO, 6, 1, 0x0));
      register.addField(new CField(register, "alarm_4", "XADC VCCPINT-Sensor Status", CField.FieldType.RO, 5, 1, 0x0));
      register.addField(new CField(register, "alarm_3", "XADC VBRAM-Sensor Status", CField.FieldType.RO, 4, 1, 0x0));
      register.addField(new CField(register, "alarm_2", "XADC VCCAUX-Sensor Status", CField.FieldType.RO, 3, 1, 0x0));
      register.addField(new CField(register, "alarm_1", "XADC VCCINT-Sensor Status", CField.FieldType.RO, 2, 1, 0x0));
      register.addField(new CField(register, "alarm_0", "XADC Temperature-Sensor Status", CField.FieldType.RO, 1, 1, 0x0));
      register.addField(new CField(register, "over_temperature", "XADC Over-Temperature Alarm Status", CField.FieldType.RO, 0, 1, 0x0));

      /***************************************************************
      * Register: convstr
      * Offset: 0xc
      ****************************************************************/
      register = new CRegister(section, "convstr", "CONVST Register (CONVSTR)", 0xc);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "temp_rd_wait_cycle", "Wait cycle for temperature update", CField.FieldType.RW, 2, 16, 0x3e8));
      register.addField(new CField(register, "temp_bus_update", "Temperature bus update", CField.FieldType.RW, 1, 1, 0x0));
      register.addField(new CField(register, "convst", "Conversion Start", CField.FieldType.RW, 0, 1, 0x0));

      /***************************************************************
      * Register: xadc_reset
      * Offset: 0x10
      ****************************************************************/
      register = new CRegister(section, "xadc_reset", "XADC Hard Macro Reset Register", 0x10);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "reset", "null", CField.FieldType.RW, 0, 1, 0x0));


      /***************************************************************
      * Section: interrupt_controller
      * Offset: 0x5c
      ****************************************************************/
      section = new CSection(this, "interrupt_controller", "XADC Wizard Interrupt Controller", 0x5c);
      super.childrenList.add(section);

      /***************************************************************
      * Register: global_interrupt
      * Offset: 0x0
      ****************************************************************/
      register = new CRegister(section, "global_interrupt", "Global Interrupt Enable Register (GIER)", 0x0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "enable", "Global Interrupt Enable", CField.FieldType.RW, 31, 1, 0x0));

      /***************************************************************
      * Register: interrupt_status
      * Offset: 0x4
      ****************************************************************/
      register = new CRegister(section, "interrupt_status", "IP Interrupt Status Register (IPISR)", 0x4);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "alarm_6", "XADC VCCDDRO-Sensor Interrupt", CField.FieldType.RW2CLR, 13, 1, 0x0));
      register.addField(new CField(register, "alarm_5", "XADC VCCPAUX-Sensor Interrupt", CField.FieldType.RW2CLR, 12, 1, 0x0));
      register.addField(new CField(register, "alarm_4", "XADC VCCPINT-Sensor Interrupt", CField.FieldType.RW2CLR, 11, 1, 0x0));
      register.addField(new CField(register, "alarm_2", "XADC VCCAUX-Sensor Interrupt", CField.FieldType.RW2CLR, 10, 1, 0x0));
      register.addField(new CField(register, "alarm_0_deactive", "ALM[0] Deactive Interrupt. ", CField.FieldType.RW2CLR, 9, 1, 0x0));
      register.addField(new CField(register, "over_temperature_deactive", "Over-Temperature Deactive Interrupt. ", CField.FieldType.RW2CLR, 8, 1, 0x0));
      register.addField(new CField(register, "jtag_modified", "JTAGMODIFIED Interrupt", CField.FieldType.RW2CLR, 7, 1, 0x0));
      register.addField(new CField(register, "jtag_locked", "JTAGLOCKED Interrupt", CField.FieldType.RW2CLR, 6, 1, 0x0));
      register.addField(new CField(register, "eoc", "End of Sequence Interrupt", CField.FieldType.RW2CLR, 5, 1, 0x0));
      register.addField(new CField(register, "eos", "End of Sequence Interrupt", CField.FieldType.RW2CLR, 4, 1, 0x0));
      register.addField(new CField(register, "alarm_3", "XADC VBRAM-Sensor Interrupt", CField.FieldType.RW2CLR, 3, 1, 0x0));
      register.addField(new CField(register, "alarm_1", "XADC VCCINT-Sensor Interrupt", CField.FieldType.RW2CLR, 2, 1, 0x0));
      register.addField(new CField(register, "alarm_0", "XADC Temperature-Sensor Interrupt", CField.FieldType.RW2CLR, 1, 1, 0x0));
      register.addField(new CField(register, "over_temperature", "Over-Temperature Alarm Interrupt", CField.FieldType.RW2CLR, 0, 1, 0x0));

      /***************************************************************
      * Register: interrupt_enable
      * Offset: 0xc
      ****************************************************************/
      register = new CRegister(section, "interrupt_enable", "IP Interrupt Enable Register (IPIER)", 0xc);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "alarm_6", "XADC VCCDDRO-Sensor Interrupt", CField.FieldType.RW, 13, 1, 0x0));
      register.addField(new CField(register, "alarm_5", "XADC VCCPAUX-Sensor Interrupt", CField.FieldType.RW, 12, 1, 0x0));
      register.addField(new CField(register, "alarm_4", "XADC VCCPINT-Sensor Interrupt", CField.FieldType.RW, 11, 1, 0x0));
      register.addField(new CField(register, "alarm_2", "XADC VCCAUX-Sensor Interrupt", CField.FieldType.RW, 10, 1, 0x0));
      register.addField(new CField(register, "alarm_0_deactive", "ALM[0] Deactive Interrupt. ", CField.FieldType.RW, 9, 1, 0x0));
      register.addField(new CField(register, "over_temperature_deactive", "Over-Temperature Deactive Interrupt. ", CField.FieldType.RW, 8, 1, 0x0));
      register.addField(new CField(register, "jtag_modified", "JTAGMODIFIED Interrupt", CField.FieldType.RW, 7, 1, 0x0));
      register.addField(new CField(register, "jtag_locked", "JTAGLOCKED Interrupt", CField.FieldType.RW, 6, 1, 0x0));
      register.addField(new CField(register, "eoc", "End of Sequence Interrupt", CField.FieldType.RW, 5, 1, 0x0));
      register.addField(new CField(register, "eos", "End of Sequence Interrupt", CField.FieldType.RW, 4, 1, 0x0));
      register.addField(new CField(register, "alarm_3", "XADC VBRAM-Sensor Interrupt", CField.FieldType.RW, 3, 1, 0x0));
      register.addField(new CField(register, "alarm_1", "XADC VCCINT-Sensor Interrupt", CField.FieldType.RW, 2, 1, 0x0));
      register.addField(new CField(register, "alarm_0", "XADC Temperature-Sensor Interrupt", CField.FieldType.RW, 1, 1, 0x0));
      register.addField(new CField(register, "over_temperature", "Over-Temperature Alarm Interrupt", CField.FieldType.RW, 0, 1, 0x0));


      /***************************************************************
      * Section: xadc_hard_macro
      * Offset: 0x200
      ****************************************************************/
      section = new CSection(this, "xadc_hard_macro", "XADC Wizard Hard Macro", 0x200);
      super.childrenList.add(section);

      /***************************************************************
      * Register: temperature
      * Offset: 0x0
      ****************************************************************/
      register = new CRegister(section, "temperature", "null", 0x0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "Temperature value", CField.FieldType.RO, 4, 12, 0x0));

      /***************************************************************
      * Register: vcc_int
      * Offset: 0x4
      ****************************************************************/
      register = new CRegister(section, "vcc_int", "null", 0x4);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "Vccint value", CField.FieldType.RO, 4, 12, 0x0));

      /***************************************************************
      * Register: vcc_aux
      * Offset: 0x8
      ****************************************************************/
      register = new CRegister(section, "vcc_aux", "null", 0x8);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "Vccaux value", CField.FieldType.RO, 4, 12, 0x0));

      /***************************************************************
      * Register: vp_vn
      * Offset: 0xc
      ****************************************************************/
      register = new CRegister(section, "vp_vn", "null", 0xc);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "Vp/Vn value", CField.FieldType.RO, 4, 12, 0x0));

      /***************************************************************
      * Register: vref_p
      * Offset: 0x10
      ****************************************************************/
      register = new CRegister(section, "vref_p", "null", 0x10);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "Vrefp value", CField.FieldType.RO, 4, 12, 0x0));

      /***************************************************************
      * Register: vref_n
      * Offset: 0x14
      ****************************************************************/
      register = new CRegister(section, "vref_n", "null", 0x14);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "Vrefp value", CField.FieldType.RO, 4, 12, 0x0));

      /***************************************************************
      * Register: vcc_bram
      * Offset: 0x18
      ****************************************************************/
      register = new CRegister(section, "vcc_bram", "null", 0x18);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "Vrefp value", CField.FieldType.RO, 4, 12, 0x0));

      /***************************************************************
      * Register: supply_a_offset
      * Offset: 0x20
      ****************************************************************/
      register = new CRegister(section, "supply_a_offset", "null", 0x20);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "Supply A offset value", CField.FieldType.RO, 4, 12, 0x0));

      /***************************************************************
      * Register: adc_a_offset
      * Offset: 0x24
      ****************************************************************/
      register = new CRegister(section, "adc_a_offset", "null", 0x24);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "ADC A offset value", CField.FieldType.RO, 4, 12, 0x0));

      /***************************************************************
      * Register: adc_a_gain
      * Offset: 0x28
      ****************************************************************/
      register = new CRegister(section, "adc_a_gain", "null", 0x28);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "sign", "Gain sign", CField.FieldType.RO, 6, 1, 0x0));
      register.addField(new CField(register, "mag", "Gain magnitude value", CField.FieldType.RO, 0, 6, 0x0));

      /***************************************************************
      * Register: vcc_pint
      * Offset: 0x34
      ****************************************************************/
      register = new CRegister(section, "vcc_pint", "null", 0x34);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "Vcc Pint value", CField.FieldType.RO, 4, 12, 0x0));

      /***************************************************************
      * Register: vcc_paux
      * Offset: 0x38
      ****************************************************************/
      register = new CRegister(section, "vcc_paux", "null", 0x38);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "Vcc Paux value", CField.FieldType.RO, 4, 12, 0x0));

      /***************************************************************
      * Register: vcco_ddr
      * Offset: 0x3c
      ****************************************************************/
      register = new CRegister(section, "vcco_ddr", "null", 0x3c);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "Vcco DDR value", CField.FieldType.RO, 4, 12, 0x0));

      /***************************************************************
      * Register: vaux_p_n
      * Offset: 0x40
      ****************************************************************/
      register = new CRegister(section, "vaux_p_n", "null", 0x40);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "Vaux_P/Vaux_N value", CField.FieldType.RO, 4, 12, 0x0));

      /***************************************************************
      * Register: max_temperature
      * Offset: 0x80
      ****************************************************************/
      register = new CRegister(section, "max_temperature", "null", 0x80);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "Max temperature value", CField.FieldType.RO, 4, 12, 0x0));

      /***************************************************************
      * Register: max_vcc_int
      * Offset: 0x84
      ****************************************************************/
      register = new CRegister(section, "max_vcc_int", "null", 0x84);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "Max  Vcc int value", CField.FieldType.RO, 4, 12, 0x0));

      /***************************************************************
      * Register: max_vcc_aux
      * Offset: 0x88
      ****************************************************************/
      register = new CRegister(section, "max_vcc_aux", "null", 0x88);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "Max  Vcc int value", CField.FieldType.RO, 4, 12, 0x0));

      /***************************************************************
      * Register: max_vcc_bram
      * Offset: 0x8c
      ****************************************************************/
      register = new CRegister(section, "max_vcc_bram", "null", 0x8c);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "Max  Vcc int value", CField.FieldType.RO, 4, 12, 0x0));

      /***************************************************************
      * Register: min_temperature
      * Offset: 0x90
      ****************************************************************/
      register = new CRegister(section, "min_temperature", "null", 0x90);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "Minimum  temperature value", CField.FieldType.RO, 4, 12, 0x0));

      /***************************************************************
      * Register: min_vcc_int
      * Offset: 0x94
      ****************************************************************/
      register = new CRegister(section, "min_vcc_int", "null", 0x94);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "Minimum Vcc int value", CField.FieldType.RO, 4, 12, 0x0));

      /***************************************************************
      * Register: min_vcc_aux
      * Offset: 0x98
      ****************************************************************/
      register = new CRegister(section, "min_vcc_aux", "null", 0x98);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "Minimum Vcc int value", CField.FieldType.RO, 4, 12, 0x0));

      /***************************************************************
      * Register: min_vcc_bram
      * Offset: 0x9c
      ****************************************************************/
      register = new CRegister(section, "min_vcc_bram", "null", 0x9c);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "Minimum Vcc int value", CField.FieldType.RO, 4, 12, 0x0));

      /***************************************************************
      * Register: max_vcc_pint
      * Offset: 0xa0
      ****************************************************************/
      register = new CRegister(section, "max_vcc_pint", "null", 0xa0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "Max  Vcc pint value", CField.FieldType.RO, 4, 12, 0x0));

      /***************************************************************
      * Register: max_vcc_paux
      * Offset: 0xa4
      ****************************************************************/
      register = new CRegister(section, "max_vcc_paux", "null", 0xa4);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "Max  Vcc paux  value", CField.FieldType.RO, 4, 12, 0x0));

      /***************************************************************
      * Register: max_vcco_ddr
      * Offset: 0xa8
      ****************************************************************/
      register = new CRegister(section, "max_vcco_ddr", "null", 0xa8);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "Max  Vcco DDR value", CField.FieldType.RO, 4, 12, 0x0));

      /***************************************************************
      * Register: min_vcc_pint
      * Offset: 0xb0
      ****************************************************************/
      register = new CRegister(section, "min_vcc_pint", "null", 0xb0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "Minimum Vcc pint value", CField.FieldType.RO, 4, 12, 0x0));

      /***************************************************************
      * Register: min_vcc_paux
      * Offset: 0xb4
      ****************************************************************/
      register = new CRegister(section, "min_vcc_paux", "null", 0xb4);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "Minimum Vcc paux  value", CField.FieldType.RO, 4, 12, 0x0));

      /***************************************************************
      * Register: main_vcco_ddr
      * Offset: 0xb8
      ****************************************************************/
      register = new CRegister(section, "main_vcco_ddr", "null", 0xb8);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "Minimum Vcco DDR value", CField.FieldType.RO, 4, 12, 0x0));

      /***************************************************************
      * Register: supply_b_offset
      * Offset: 0xc0
      ****************************************************************/
      register = new CRegister(section, "supply_b_offset", "null", 0xc0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "Supply A offset value", CField.FieldType.RO, 4, 12, 0x0));

      /***************************************************************
      * Register: adc_b_offset
      * Offset: 0xc4
      ****************************************************************/
      register = new CRegister(section, "adc_b_offset", "null", 0xc4);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "ADC A offset value", CField.FieldType.RO, 4, 12, 0x0));

      /***************************************************************
      * Register: adc_b_gain
      * Offset: 0xc8
      ****************************************************************/
      register = new CRegister(section, "adc_b_gain", "null", 0xc8);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "sign", "Gain sign", CField.FieldType.RO, 6, 1, 0x0));
      register.addField(new CField(register, "mag", "Gain magnitude value", CField.FieldType.RO, 0, 6, 0x0));

      /***************************************************************
      * Register: flag
      * Offset: 0xd4
      ****************************************************************/
      register = new CRegister(section, "flag", "null", 0xd4);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "jtgd", "", CField.FieldType.RO, 11, 1, 0x0));
      register.addField(new CField(register, "jtgr", "", CField.FieldType.RO, 10, 1, 0x0));
      register.addField(new CField(register, "ref", "ADC reference voltage", CField.FieldType.RO, 9, 1, 0x0));
      register.addField(new CField(register, "alarm_6", "Alarm 6 output", CField.FieldType.RO, 7, 1, 0x0));
      register.addField(new CField(register, "alarm_5", "Alarm 5 output", CField.FieldType.RO, 6, 1, 0x0));
      register.addField(new CField(register, "alarm_4", "Alarm 4 output output", CField.FieldType.RO, 5, 1, 0x0));
      register.addField(new CField(register, "alarm_3", "Alarm 3 output", CField.FieldType.RO, 4, 1, 0x0));
      register.addField(new CField(register, "over_temperature", "Over temperature output", CField.FieldType.RO, 3, 1, 0x0));
      register.addField(new CField(register, "alarm_2", "Alarm 2 output", CField.FieldType.RO, 2, 1, 0x0));
      register.addField(new CField(register, "alarm_1", "Alarm 1 output", CField.FieldType.RO, 1, 1, 0x0));
      register.addField(new CField(register, "alarm_0", "Alarm 0 output", CField.FieldType.RO, 0, 1, 0x0));


      /***************************************************************
      * Section: control
      * Offset: 0x300
      ****************************************************************/
      section = new CSection(this, "control", "XADC Control Registers", 0x300);
      super.childrenList.add(section);

      /***************************************************************
      * Register: config_0
      * Offset: 0x0
      ****************************************************************/
      register = new CRegister(section, "config_0", "null", 0x0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "cavg", "Disable calculation averaging", CField.FieldType.RW, 15, 1, 0x0));
      register.addField(new CField(register, "avg", "Averaging", CField.FieldType.RW, 12, 2, 0x0));
      register.addField(new CField(register, "mux", "null", CField.FieldType.RW, 11, 1, 0x0));
      register.addField(new CField(register, "bu", "null", CField.FieldType.RW, 10, 1, 0x0));
      register.addField(new CField(register, "ec", "null", CField.FieldType.RW, 9, 1, 0x0));
      register.addField(new CField(register, "acq", "null", CField.FieldType.RW, 8, 1, 0x0));
      register.addField(new CField(register, "input_channel", "ADC input channel", CField.FieldType.RW, 0, 5, 0x0));

      /***************************************************************
      * Register: config_1
      * Offset: 0x4
      ****************************************************************/
      register = new CRegister(section, "config_1", "null", 0x4);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "seq", "null", CField.FieldType.RW, 12, 4, 0x0));
      register.addField(new CField(register, "alarm_6_disable", "Alarm 6 disable", CField.FieldType.RW, 11, 1, 0x0));
      register.addField(new CField(register, "alarm_5_disable", "Alarm 5 disable", CField.FieldType.RW, 10, 1, 0x0));
      register.addField(new CField(register, "alarm_4_disable", "Alarm 4 disable", CField.FieldType.RW, 9, 1, 0x0));
      register.addField(new CField(register, "alarm_3_disable", "Alarm 3 disable", CField.FieldType.RW, 8, 1, 0x0));
      register.addField(new CField(register, "cal_enable_3", "Supply sensor offset and gain correction enable", CField.FieldType.RW, 7, 1, 0x0));
      register.addField(new CField(register, "cal_enable_2", "Supply sensor offset correction enable", CField.FieldType.RW, 6, 1, 0x0));
      register.addField(new CField(register, "cal_enable_1", "ADCs offset and gain correction enable", CField.FieldType.RW, 5, 1, 0x0));
      register.addField(new CField(register, "cal_enable_0", "ADCs offset correction enable", CField.FieldType.RW, 4, 1, 0x0));
      register.addField(new CField(register, "alarm_2_disable", "Alarm 2 disable", CField.FieldType.RW, 3, 1, 0x0));
      register.addField(new CField(register, "alarm_1_disable", "Alarm 0 disable", CField.FieldType.RW, 2, 1, 0x0));
      register.addField(new CField(register, "alarm_0_disable", "Alarm 0 disable", CField.FieldType.RW, 1, 1, 0x0));
      register.addField(new CField(register, "ot_disable", "Over temperature disable", CField.FieldType.RW, 0, 1, 0x0));

      /***************************************************************
      * Register: config_2
      * Offset: 0x8
      ****************************************************************/
      register = new CRegister(section, "config_2", "null", 0x8);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "cd", "Clock division selection", CField.FieldType.RW, 8, 8, 0x1e));
      register.addField(new CField(register, "pd", "Power down selection", CField.FieldType.RW, 4, 2, 0x0));


      /***************************************************************
      * Section: alarm_tresholds
      * Offset: 0x340
      ****************************************************************/
      section = new CSection(this, "alarm_tresholds", "null", 0x340);
      super.childrenList.add(section);

      /***************************************************************
      * Register: temperature_upper
      * Offset: 0x0
      ****************************************************************/
      register = new CRegister(section, "temperature_upper", "Temperature upper  [alarm 0]", 0x0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "null", CField.FieldType.RW, 4, 12, 0x0));

      /***************************************************************
      * Register: vccint_upper
      * Offset: 0x4
      ****************************************************************/
      register = new CRegister(section, "vccint_upper", "VCCINT upper  [alarm 1]", 0x4);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "null", CField.FieldType.RW, 4, 12, 0x0));

      /***************************************************************
      * Register: vccaux_upper
      * Offset: 0x8
      ****************************************************************/
      register = new CRegister(section, "vccaux_upper", "VCCAUX upper [alarm 2]", 0x8);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "null", CField.FieldType.RW, 4, 12, 0x0));

      /***************************************************************
      * Register: ot_alarm_limit
      * Offset: 0xc
      ****************************************************************/
      register = new CRegister(section, "ot_alarm_limit", "Over-temperature alarm limit", 0xc);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "null", CField.FieldType.RW, 4, 12, 0x0));

      /***************************************************************
      * Register: temperature_lower
      * Offset: 0x10
      ****************************************************************/
      register = new CRegister(section, "temperature_lower", "OT alarm limit", 0x10);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "null", CField.FieldType.RW, 4, 12, 0x0));

      /***************************************************************
      * Register: vccint_lower
      * Offset: 0x14
      ****************************************************************/
      register = new CRegister(section, "vccint_lower", "VCCINT lower [alarm 1]", 0x14);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "null", CField.FieldType.RW, 4, 12, 0x0));

      /***************************************************************
      * Register: vccaux_lower
      * Offset: 0x18
      ****************************************************************/
      register = new CRegister(section, "vccaux_lower", "VCCAUX lower  [alarm 2]", 0x18);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "null", CField.FieldType.RW, 4, 12, 0x0));

      /***************************************************************
      * Register: ot_alarm_reset
      * Offset: 0x1c
      ****************************************************************/
      register = new CRegister(section, "ot_alarm_reset", "Over-temperature alarm reset", 0x1c);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "null", CField.FieldType.RW, 4, 12, 0x0));

      /***************************************************************
      * Register: vccbram_upper
      * Offset: 0x20
      ****************************************************************/
      register = new CRegister(section, "vccbram_upper", "VCCBRAM upper [alarm 3]", 0x20);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "null", CField.FieldType.RW, 4, 12, 0x0));

      /***************************************************************
      * Register: vccpint_upper
      * Offset: 0x24
      ****************************************************************/
      register = new CRegister(section, "vccpint_upper", "VCCPINT upper [alarm 4]", 0x24);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "null", CField.FieldType.RW, 4, 12, 0x0));

      /***************************************************************
      * Register: vccpaux_upper
      * Offset: 0x28
      ****************************************************************/
      register = new CRegister(section, "vccpaux_upper", "VCCPAUX upper VCCBRAM lower [alarm 5]", 0x28);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "null", CField.FieldType.RW, 4, 12, 0x0));

      /***************************************************************
      * Register: vcco_ddr_upper
      * Offset: 0x2c
      ****************************************************************/
      register = new CRegister(section, "vcco_ddr_upper", "VCCO DDR upper [alarm 6]", 0x2c);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "null", CField.FieldType.RW, 4, 12, 0x0));

      /***************************************************************
      * Register: vccbram_lower
      * Offset: 0x30
      ****************************************************************/
      register = new CRegister(section, "vccbram_lower", "VCCBRAM lower [alarm 3]", 0x30);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "null", CField.FieldType.RW, 4, 12, 0x0));

      /***************************************************************
      * Register: vccpint_lower
      * Offset: 0x34
      ****************************************************************/
      register = new CRegister(section, "vccpint_lower", "VCCPINT lower  [alarm 4]", 0x34);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "null", CField.FieldType.RW, 4, 12, 0x0));

      /***************************************************************
      * Register: vccpaux_lower
      * Offset: 0x38
      ****************************************************************/
      register = new CRegister(section, "vccpaux_lower", "VCCPAUX lower [alarm 5]", 0x38);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "null", CField.FieldType.RW, 4, 12, 0x0));

      /***************************************************************
      * Register: vcco_ddr_lower
      * Offset: 0x3c
      ****************************************************************/
      register = new CRegister(section, "vcco_ddr_lower", "VCCO DDR lower [alarm 6]", 0x3c);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "null", CField.FieldType.RW, 4, 12, 0x0));


 }

}

