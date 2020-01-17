%=================================================================
%  $HeadURL:$
%  $Revision:$
%  $Date:$
%  $Author:$
%
%  MODULE: xadc_wizard
%
%  DESCRIPTION: Register file of the xadc_wizard module
%
%  FDK IDE Version: 4.6.0_beta1
%  Build ID: I20160217-1125
%  
%  DO NOT MODIFY MANUALLY.
%
%=================================================================



variable TEST = 1;
variable NO_TEST = 0;
variable i;		%index used for filling tables used in Group registers.

%=================================================================
% SECTION NAME	: LOCAL_REGISTER
%=================================================================
Section("local_register", 0, 0x0);

Register("ssr", 0x0, 4, "Software Reset Register (SSR)");
		Field("value", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("sr", 0x4, 4, "Status Register (SR)");
		Field("jtag_busy", 10, 10, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "JTAG busy");
		Field("jtag_modified", 9, 9, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "JTAG modified");
		Field("jtag_locked", 8, 8, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "JTAG locked");
		Field("busy", 7, 7, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "ADC busy signal");
		Field("eos", 6, 6, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "End of Sequence");
		Field("eoc", 5, 5, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "End of Conversion signal");
		Field("channel", 4, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Channel selection outputs");

Register("aosr", 0x8, 4, "Alarm Output Status Register (AOSR)");
		Field("alarm_7", 8, 8, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Logical ORing of ALARM bits 0 to 7");
		Field("alarm_6", 7, 7, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "XADC VCCDDRO-Sensor Status");
		Field("alarm_5", 6, 6, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "XADC VCCPAUX-Sensor Status");
		Field("alarm_4", 5, 5, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "XADC VCCPINT-Sensor Status");
		Field("alarm_3", 4, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "XADC VBRAM-Sensor Status");
		Field("alarm_2", 3, 3, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "XADC VCCAUX-Sensor Status");
		Field("alarm_1", 2, 2, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "XADC VCCINT-Sensor Status");
		Field("alarm_0", 1, 1, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "XADC Temperature-Sensor Status");
		Field("over_temperature", 0, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "XADC Over-Temperature Alarm Status");

Register("convstr", 0xc, 4, "CONVST Register (CONVSTR)");
		Field("temp_rd_wait_cycle", 17, 2, "rd|wr", 0x0, 0x03E8, 0xffffffff, 0xffffffff, TEST, 0, 0, "Wait cycle for temperature update");
		Field("temp_bus_update", 1, 1, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Temperature bus update");
		Field("convst", 0, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Conversion Start");

Register("xadc_reset", 0x10, 4, "XADC Hard Macro Reset Register");
		Field("reset", 0, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Release the reset (Normal operation)", 0);
			FieldValue("Reset the XADC", 1);

%=================================================================
% SECTION NAME	: INTERRUPT_CONTROLLER
%=================================================================
Section("interrupt_controller", 0, 0x5c);

Register("global_interrupt", 0x5c, 4, "Global Interrupt Enable Register (GIER)");
		Field("enable", 31, 31, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Global Interrupt Enable");
			FieldValue("All interrupts are disabled", 0);
			FieldValue("All interrupts are enabled", 1);

Register("interrupt_status", 0x60, 4, "IP Interrupt Status Register (IPISR)");
		Field("alarm_6", 13, 13, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "XADC VCCDDRO-Sensor Interrupt");
		Field("alarm_5", 12, 12, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "XADC VCCPAUX-Sensor Interrupt");
		Field("alarm_4", 11, 11, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "XADC VCCPINT-Sensor Interrupt");
		Field("alarm_2", 10, 10, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "XADC VCCAUX-Sensor Interrupt");
		Field("alarm_0_deactive", 9, 9, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "ALM[0] Deactive Interrupt. ");
		Field("over_temperature_deactive", 8, 8, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "Over-Temperature Deactive Interrupt. ");
		Field("jtag_modified", 7, 7, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "JTAGMODIFIED Interrupt");
		Field("jtag_locked", 6, 6, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "JTAGLOCKED Interrupt");
		Field("eoc", 5, 5, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "End of Sequence Interrupt");
		Field("eos", 4, 4, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "End of Sequence Interrupt");
		Field("alarm_3", 3, 3, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "XADC VBRAM-Sensor Interrupt");
		Field("alarm_1", 2, 2, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "XADC VCCINT-Sensor Interrupt");
		Field("alarm_0", 1, 1, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "XADC Temperature-Sensor Interrupt");
		Field("over_temperature", 0, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "Over-Temperature Alarm Interrupt");

Register("interrupt_enable", 0x68, 4, "IP Interrupt Enable Register (IPIER)");
		Field("alarm_6", 13, 13, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "XADC VCCDDRO-Sensor Interrupt");
			FieldValue("Disabled", 0);
			FieldValue("Enabled", 1);
		Field("alarm_5", 12, 12, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "XADC VCCPAUX-Sensor Interrupt");
			FieldValue("Disabled", 0);
			FieldValue("Enabled", 1);
		Field("alarm_4", 11, 11, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "XADC VCCPINT-Sensor Interrupt");
			FieldValue("Disabled", 0);
			FieldValue("Enabled", 1);
		Field("alarm_2", 10, 10, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "XADC VCCAUX-Sensor Interrupt");
			FieldValue("Disabled", 0);
			FieldValue("Enabled", 1);
		Field("alarm_0_deactive", 9, 9, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "ALM[0] Deactive Interrupt. ");
			FieldValue("Disabled", 0);
			FieldValue("Enabled", 1);
		Field("over_temperature_deactive", 8, 8, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Over-Temperature Deactive Interrupt. ");
			FieldValue("Disabled", 0);
			FieldValue("Enabled", 1);
		Field("jtag_modified", 7, 7, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "JTAGMODIFIED Interrupt");
			FieldValue("Disabled", 0);
			FieldValue("Enabled", 1);
		Field("jtag_locked", 6, 6, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "JTAGLOCKED Interrupt");
			FieldValue("Disabled", 0);
			FieldValue("Enabled", 1);
		Field("eoc", 5, 5, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "End of Sequence Interrupt");
			FieldValue("Disabled", 0);
			FieldValue("Enabled", 1);
		Field("eos", 4, 4, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "End of Sequence Interrupt");
			FieldValue("Disabled", 0);
			FieldValue("Enabled", 1);
		Field("alarm_3", 3, 3, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "XADC VBRAM-Sensor Interrupt");
			FieldValue("Disabled", 0);
			FieldValue("Enabled", 1);
		Field("alarm_1", 2, 2, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "XADC VCCINT-Sensor Interrupt");
			FieldValue("Disabled", 0);
			FieldValue("Enabled", 1);
		Field("alarm_0", 1, 1, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "XADC Temperature-Sensor Interrupt");
			FieldValue("Disabled", 0);
			FieldValue("Enabled", 1);
		Field("over_temperature", 0, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Over-Temperature Alarm Interrupt");
			FieldValue("Disabled", 0);
			FieldValue("Enabled", 1);

%=================================================================
% SECTION NAME	: XADC_HARD_MACRO
%=================================================================
Section("xadc_hard_macro", 0, 0x200);

Register("temperature", 0x200, 4, "null");
		Field("value", 15, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Temperature value");

Register("vcc_int", 0x204, 4, "null");
		Field("value", 15, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Vccint value");

Register("vcc_aux", 0x208, 4, "null");
		Field("value", 15, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Vccaux value");

Register("vp_vn", 0x20c, 4, "null");
		Field("value", 15, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Vp/Vn value");

Register("vref_p", 0x210, 4, "null");
		Field("value", 15, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Vrefp value");

Register("vref_n", 0x214, 4, "null");
		Field("value", 15, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Vrefp value");

Register("vcc_bram", 0x218, 4, "null");
		Field("value", 15, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Vrefp value");

Register("supply_a_offset", 0x220, 4, "null");
		Field("value", 15, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Supply A offset value");

Register("adc_a_offset", 0x224, 4, "null");
		Field("value", 15, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "ADC A offset value");

Register("adc_a_gain", 0x228, 4, "null");
		Field("sign", 6, 6, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Gain sign");
			FieldValue("Negative gain", 0);
			FieldValue("Positive gain", 1);
		Field("mag", 5, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Gain magnitude value");

Register("vcc_pint", 0x234, 4, "null");
		Field("value", 15, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Vcc Pint value");

Register("vcc_paux", 0x238, 4, "null");
		Field("value", 15, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Vcc Paux value");

Register("vcco_ddr", 0x23c, 4, "null");
		Field("value", 15, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Vcco DDR value");

variable vaux_p_nTags = UChar_Type[16];

for(i = 0; i < 16; i++)
{
	vaux_p_nTags[i] = i;
}

Group("vaux_p_n", "DECTAG", vaux_p_nTags);

for(i = 0; i < 16; i++)
{

	Register("vaux_p_n", 0x240 + i*0x4, 4, "vaux_p_n**", "vaux_p_n", i, "null");
		Field("value", 15, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Vaux_P/Vaux_N value");
}

Register("max_temperature", 0x280, 4, "null");
		Field("value", 15, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Max temperature value");

Register("max_vcc_int", 0x284, 4, "null");
		Field("value", 15, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Max  Vcc int value");

Register("max_vcc_aux", 0x288, 4, "null");
		Field("value", 15, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Max  Vcc int value");

Register("max_vcc_bram", 0x28c, 4, "null");
		Field("value", 15, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Max  Vcc int value");

Register("min_temperature", 0x290, 4, "null");
		Field("value", 15, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Minimum  temperature value");

Register("min_vcc_int", 0x294, 4, "null");
		Field("value", 15, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Minimum Vcc int value");

Register("min_vcc_aux", 0x298, 4, "null");
		Field("value", 15, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Minimum Vcc int value");

Register("min_vcc_bram", 0x29c, 4, "null");
		Field("value", 15, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Minimum Vcc int value");

Register("max_vcc_pint", 0x2a0, 4, "null");
		Field("value", 15, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Max  Vcc pint value");

Register("max_vcc_paux", 0x2a4, 4, "null");
		Field("value", 15, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Max  Vcc paux  value");

Register("max_vcco_ddr", 0x2a8, 4, "null");
		Field("value", 15, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Max  Vcco DDR value");

Register("min_vcc_pint", 0x2b0, 4, "null");
		Field("value", 15, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Minimum Vcc pint value");

Register("min_vcc_paux", 0x2b4, 4, "null");
		Field("value", 15, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Minimum Vcc paux  value");

Register("main_vcco_ddr", 0x2b8, 4, "null");
		Field("value", 15, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Minimum Vcco DDR value");

Register("supply_b_offset", 0x2c0, 4, "null");
		Field("value", 15, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Supply A offset value");

Register("adc_b_offset", 0x2c4, 4, "null");
		Field("value", 15, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "ADC A offset value");

Register("adc_b_gain", 0x2c8, 4, "null");
		Field("sign", 6, 6, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Gain sign");
			FieldValue("Negative gain", 0);
			FieldValue("Positive gain", 1);
		Field("mag", 5, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Gain magnitude value");

Register("flag", 0x2d4, 4, "null");
		Field("jtgd", 11, 11, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "");
		Field("jtgr", 10, 10, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "");
		Field("ref", 9, 9, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "ADC reference voltage");
			FieldValue("External reference voltage is used", 0);
			FieldValue("Internal reference voltage is used", 1);
		Field("alarm_6", 7, 7, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Alarm 6 output");
		Field("alarm_5", 6, 6, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Alarm 5 output");
		Field("alarm_4", 5, 5, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Alarm 4 output output");
		Field("alarm_3", 4, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Alarm 3 output");
		Field("over_temperature", 3, 3, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Over temperature output");
		Field("alarm_2", 2, 2, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Alarm 2 output");
		Field("alarm_1", 1, 1, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Alarm 1 output");
		Field("alarm_0", 0, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Alarm 0 output");

%=================================================================
% SECTION NAME	: CONTROL
%=================================================================
Section("control", 0, 0x300);

Register("config_0", 0x300, 4, "null");
		Field("cavg", 15, 15, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Disable calculation averaging");
			FieldValue("Averaging enabled (default)", 0);
			FieldValue("Averaging disabled", 1);
		Field("avg", 13, 12, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Averaging");
			FieldValue("No averaging", 0);
			FieldValue("Average 16 samples", 1);
			FieldValue("Average 64 samples", 2);
			FieldValue("Average 256 samples", 3);
		Field("mux", 11, 11, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Internal Mux", 0);
			FieldValue("External mux", 1);
		Field("bu", 10, 10, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Unipolar mode", 0);
			FieldValue("Bipolar mode", 1);
		Field("ec", 9, 9, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Continuous sampling mode", 0);
			FieldValue("Event driven mode", 1);
		Field("acq", 8, 8, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("input_channel", 4, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "ADC input channel");
			FieldValue("On-chip temperature", 0);
			FieldValue("VCCINT", 1);
			FieldValue("VCCAUX", 2);
			FieldValue("VP , VN – Dedicated analog inputs", 3);
			FieldValue("VREFP (1.25V)", 4);
			FieldValue("VREFN (0V)", 5);
			FieldValue("VCCBRAM", 6);
			FieldValue("Invalid channel selection", 7);
			FieldValue("Carry out an XADC calibration", 8);
			FieldValue("VCCPINT", 13);
			FieldValue("VCCPAUX", 14);
			FieldValue("VCCO_DDR", 15);
			FieldValue("VAUXP[0], VAUXN[0] – Auxiliary", 16);
			FieldValue("VAUXP[1], VAUXN[1] – Auxiliary", 17);

Register("config_1", 0x304, 4, "null");
		Field("seq", 15, 12, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Default mode", 0);
			FieldValue("Single pass sequence", 1);
			FieldValue("Continuous sequence mode", 2);
			FieldValue("Single channel mode (seq uencer off)", 3);
			FieldValue("Simultaneous sampling mode", 4);
			FieldValue("Simultaneous sampling mode", 5);
			FieldValue("Simultaneous sampling mode", 6);
			FieldValue("Simultaneous sampling mode", 7);
			FieldValue("Independent ADC mode", 8);
			FieldValue("Independent ADC mode", 9);
			FieldValue("Independent ADC mode", 10);
			FieldValue("Independent ADC mode", 11);
			FieldValue("Independent ADC mode", 12);
			FieldValue("Default mode", 13);
			FieldValue("Default mode", 14);
			FieldValue("Default mode", 15);
		Field("alarm_6_disable", 11, 11, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Alarm 6 disable");
			FieldValue("Alarm enabled", 0);
			FieldValue("Alarm disabled", 1);
		Field("alarm_5_disable", 10, 10, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Alarm 5 disable");
			FieldValue("Alarm enabled", 0);
			FieldValue("Alarm disabled", 1);
		Field("alarm_4_disable", 9, 9, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Alarm 4 disable");
			FieldValue("Alarm enabled", 0);
			FieldValue("Alarm disabled", 1);
		Field("alarm_3_disable", 8, 8, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Alarm 3 disable");
			FieldValue("Alarm enabled", 0);
			FieldValue("Alarm disabled", 1);
		Field("cal_enable_3", 7, 7, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Supply sensor offset and gain correction enable");
			FieldValue("Disable calibration", 0);
			FieldValue("Enable calibration", 1);
		Field("cal_enable_2", 6, 6, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Supply sensor offset correction enable");
			FieldValue("Disable calibration", 0);
			FieldValue("Enable calibration", 1);
		Field("cal_enable_1", 5, 5, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "ADCs offset and gain correction enable");
			FieldValue("Disable calibration", 0);
			FieldValue("Enable calibration", 1);
		Field("cal_enable_0", 4, 4, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "ADCs offset correction enable");
			FieldValue("Disable calibration", 0);
			FieldValue("Enable calibration", 1);
		Field("alarm_2_disable", 3, 3, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Alarm 2 disable");
			FieldValue("Alarm enabled", 0);
			FieldValue("Alarm disabled", 1);
		Field("alarm_1_disable", 2, 2, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Alarm 0 disable");
			FieldValue("Alarm enabled", 0);
			FieldValue("Alarm disabled", 1);
		Field("alarm_0_disable", 1, 1, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Alarm 0 disable");
			FieldValue("Alarm enabled", 0);
			FieldValue("Alarm disabled", 1);
		Field("ot_disable", 0, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Over temperature disable");
			FieldValue("Over temperature signal enable", 0);
			FieldValue("Over temperature signal disable", 1);

Register("config_2", 0x308, 4, "null");
		Field("cd", 15, 8, "rd|wr", 0x0, 0x1E, 0xffffffff, 0xffffffff, TEST, 0, 0, "Clock division selection");
		Field("pd", 5, 4, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Power down selection");
			FieldValue("Default. All XADC blocks powered up", 0);
			FieldValue("Not valid – do not select", 1);
			FieldValue("ADC B powered down", 2);
			FieldValue("XADC powered down", 3);

%=================================================================
% SECTION NAME	: ALARM_TRESHOLDS
%=================================================================
Section("alarm_tresholds", 0, 0x340);

Register("temperature_upper", 0x340, 4, "Temperature upper  [alarm 0]");
		Field("value", 15, 4, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("vccint_upper", 0x344, 4, "VCCINT upper  [alarm 1]");
		Field("value", 15, 4, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("vccaux_upper", 0x348, 4, "VCCAUX upper [alarm 2]");
		Field("value", 15, 4, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("ot_alarm_limit", 0x34c, 4, "Over-temperature alarm limit");
		Field("value", 15, 4, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("temperature_lower", 0x350, 4, "OT alarm limit");
		Field("value", 15, 4, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("vccint_lower", 0x354, 4, "VCCINT lower [alarm 1]");
		Field("value", 15, 4, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("vccaux_lower", 0x358, 4, "VCCAUX lower  [alarm 2]");
		Field("value", 15, 4, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("ot_alarm_reset", 0x35c, 4, "Over-temperature alarm reset");
		Field("value", 15, 4, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("vccbram_upper", 0x360, 4, "VCCBRAM upper [alarm 3]");
		Field("value", 15, 4, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("vccpint_upper", 0x364, 4, "VCCPINT upper [alarm 4]");
		Field("value", 15, 4, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("vccpaux_upper", 0x368, 4, "VCCPAUX upper VCCBRAM lower [alarm 5]");
		Field("value", 15, 4, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("vcco_ddr_upper", 0x36c, 4, "VCCO DDR upper [alarm 6]");
		Field("value", 15, 4, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("vccbram_lower", 0x370, 4, "VCCBRAM lower [alarm 3]");
		Field("value", 15, 4, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("vccpint_lower", 0x374, 4, "VCCPINT lower  [alarm 4]");
		Field("value", 15, 4, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("vccpaux_lower", 0x378, 4, "VCCPAUX lower [alarm 5]");
		Field("value", 15, 4, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("vcco_ddr_lower", 0x37c, 4, "VCCO DDR lower [alarm 6]");
		Field("value", 15, 4, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");


