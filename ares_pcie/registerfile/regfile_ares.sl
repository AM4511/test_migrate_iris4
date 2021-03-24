%=================================================================
%  $HeadURL:$
%  $Revision:$
%  $Date:$
%  $Author:$
%
%  MODULE: regfile_ares
%
%  DESCRIPTION: Register file of the regfile_ares module
%
%  FDK IDE Version: 4.7.0_beta4
%  Build ID: I20191220-1537
%  
%  DO NOT MODIFY MANUALLY.
%
%=================================================================



variable TEST = 1;
variable NO_TEST = 0;
variable i;		%index used for filling tables used in Group registers.

%=================================================================
% SECTION NAME	: DEVICE_SPECIFIC
%=================================================================
Section("Device_specific", 0, 0x0);

Register("intstat", 0x0, 4, "null");
		Field("irq_tick_latch", 7, 7, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
			FieldValue("No interrupt detected", 0);
			FieldValue("Interrupt event occured in the tick table", 1);
		Field("irq_microblaze", 6, 6, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
			FieldValue("No interrupt detected.", 0);
			FieldValue("This bit indicates that an interrupt has been detected. ", 1);
		Field("irq_tick_wa", 4, 4, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
			FieldValue("No interrupt detected.", 0);
			FieldValue("This bit indicates that an interrupt has been detected. A wrap around of the tick table has been generated.", 1);
		Field("irq_timer", 3, 3, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("No interrupt detected", 0);
			FieldValue("Interrupt event occured in one Timer", 1);
		Field("irq_tick", 1, 1, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
			FieldValue("No interrupt detected", 0);
			FieldValue("Interrupt event occured in the Tick Table", 1);
		Field("irq_io", 0, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
			FieldValue("No interrupt detected", 0);
			FieldValue("Interrupt event occured in the User Inputs", 1);

Register("intmaskn", 0x4, 4, "null");
		Field("irq_tick_latch", 7, 7, "rd", 0x0, 0x1, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
			FieldValue("No interrupt detected", 0);
			FieldValue("Interrupt event occured in the tick table", 1);
		Field("irq_microblaze", 6, 6, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("IRQ from Microblaze disabled", 0);
			FieldValue("IRQ from Microblaze enabled", 1);
		Field("irq_tick_wa", 4, 4, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("IRQ from Tick Table Wrap Around disabled", 0);
			FieldValue("IRQ from Tick Table Wrap Around enabled", 1);
		Field("irq_timer", 3, 3, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("IRQ from Timers pins disabled", 0);
			FieldValue("IRQ from Timers enabled", 1);
		Field("irq_tick", 1, 1, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("IRQ from Tick Table disabled", 0);
			FieldValue("IRQ from Tick Table enabled", 1);
		Field("irq_io", 0, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("IRQ from Input pins disabled", 0);
			FieldValue("IRQ from Input pins enabled", 1);

Register("intstat2", 0x8, 4, "null");
		Field("irq_timer_end", 23, 16, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("irq_timer_start", 7, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");

Register("buildid", 0x1c, 4, "null");
		Field("value", 31, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "EPOCH date value");

Register("fpga_id", 0x20, 4, "null");
		Field("fpga_straps", 31, 28, "rd", 0x0, 0xF, 0x0, 0x0, NO_TEST, 0, 0, "FPGA Strapping");
			FieldValue("No strapping installed (Default value)", 15);
		Field("user_red_led", 14, 14, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "User red LED enable");
			FieldValue("User green LED disabled", 0);
			FieldValue("User green LED enabled", 1);
		Field("user_green_led", 13, 13, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "User green LED enable");
			FieldValue("User green LED disabled", 0);
			FieldValue("User green LED enabled", 1);
		Field("profinet_led", 12, 12, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("User Leds are under Host processor control", 0);
			FieldValue("User Leds are under Microblaze control", 1);
		Field("pb_debug_com", 10, 10, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("UART line between SOC and FPGA is tristated by the FPGA", 0);
			FieldValue("Profiblaze output is seen on the internal com port", 1);
		Field("npi_golden", 8, 8, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "NPI Golden fpga");
			FieldValue("Current firmware is a regular MIL upgrade FPGA", 0);
			FieldValue("Current firmware is a NPI golden FPGA", 1);
		Field("fpga_id", 4, 0, "rd", 0x0, 0x2, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("Spartan6 LX9 fpga used on Y7449-00 (deprecated)", 1);
			FieldValue("Spartan6 LX16 fpga used on Y7449-01,02", 2);
			FieldValue("Artix7 A35T fpga used on Y7471-00 (deprecated)", 3);
			FieldValue("Artix7 A50T fpga used on Y7471-01", 4);
			FieldValue("Artix7 A50T fpga used on Y7471-02", 5);
			FieldValue("Artix7 A50T fpga used on Y7449-03", 6);
			FieldValue("Artix7 Spider PCIe on Advanced IO board", 7);
			FieldValue("Artix7 Ares PCIe (Iris3 Spider+Profiblaze on Y7478-00)", 8);
			FieldValue("Artix7 Ares PCIe (Iris3 Spider+Profiblaze on Y7478-01)", 9);
			FieldValue("Reserved for Artix7 Eris (LPC) on Y7478-01", 10);
			FieldValue("Iris GTX, Artix7 Ares PCIe, Artix7 A35T on Y7571-[00,01]", 16);
			FieldValue("Iris GTX, Artix7 Ares PCIe, Artix7 A50T on Y7571-[00,01]", 17);
			FieldValue("Iris GTX, Artix7 Ares PCIe, Artix7 A35T on Y7571-02", 18);
			FieldValue("Iris GTX, Artix7 Ares PCIe, Artix7 A50T on Y7571-02", 19);

Register("led_override", 0x24, 4, "null");
		Field("red_orange_flash", 25, 25, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Normal operation", 0);
			FieldValue("Flash override active", 1);
		Field("orange_off_flash", 24, 24, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Normal operation", 0);
			FieldValue("Flashing override active", 1);

%=================================================================
% SECTION NAME	: INTERRUPT_QUEUE
%=================================================================
Section("INTERRUPT_QUEUE", 0, 0x40);

Register("control", 0x40, 4, "null");
		Field("nb_dw", 31, 24, "rd", 0x0, 0x1, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("enable", 0, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("cons_idx", 0x44, 4, "null");
		Field("cons_idx", 9, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("addr_low", 0x48, 4, "null");
		Field("addr", 31, 13, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("addrlsbRO", 12, 0, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");

Register("addr_high", 0x4c, 4, "null");
		Field("addr", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("mapping", 0x50, 4, "null");
		Field("irq_timer_end", 31, 24, "wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
		Field("irq_timer_start", 23, 16, "wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
		Field("io_intstat", 11, 8, "wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
		Field("irq_tick_latch", 5, 5, "wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("No interrupt detected", 0);
			FieldValue("Interrupt event occured in the tick table", 1);
		Field("irq_microblaze", 4, 4, "wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
		Field("irq_timer", 3, 3, "wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
		Field("irq_tick_wa", 2, 2, "wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
		Field("irq_tick", 1, 1, "wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
		Field("irq_io", 0, 0, "wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");

%=================================================================
% SECTION NAME	: TLP
%=================================================================
Section("tlp", 0, 0x70);

Register("timeout", 0x70, 4, "TLP transaction timeout value");
		Field("value", 31, 0, "rd|wr", 0x0, 0x1DCD650, 0xffffffff, 0xffffffff, TEST, 0, 0, "TLP timeout value");
			FieldValue("500 ms", 31250000);

Register("transaction_abort_cntr", 0x74, 4, "TLP transaction abort counter");
		Field("clr", 31, 31, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Clear transaction abort counter value");
			FieldValue("No effect", 0);
			FieldValue("clr the counter value to 0", 1);
		Field("value", 30, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Counter value");

%=================================================================
% SECTION NAME	: SPI
%=================================================================
Section("SPI", 0, 0xe0);

Register("spiregin", 0xe0, 4, "SPI Register In");
		Field("spi_enable", 24, 24, "wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "SPI ENABLE");
			FieldValue("The SPI interface is disabled", 0);
			FieldValue("The SPI interface is enabled", 1);
		Field("spirw", 22, 22, "wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "SPI  Read Write");
			FieldValue("Write Access", 0);
			FieldValue("Read Access", 1);
		Field("spicmddone", 21, 21, "wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "SPI  CoMmaD DONE");
		Field("spisel", 18, 18, "wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "SPI active channel SELection");
		Field("spitxst", 16, 16, "wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "SPI SPITXST Transfer STart");
		Field("spidataw", 7, 0, "wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "SPI Data  byte to write");

Register("spiregout", 0xe8, 4, "SPI Register Out");
		Field("spi_wb_cap", 17, 17, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "SPI Write Burst CAPable");
			FieldValue("This fpga can't do write burst", 0);
			FieldValue("This fpga is capable of doing write burst", 1);
		Field("spiwrtd", 16, 16, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "SPI Write or Read Transfer Done");
			FieldValue("Transfer in progress", 0);
			FieldValue("No transfer in progress", 1);
		Field("spidatard", 7, 0, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "SPI DATA  Read byte OUTput ");

%=================================================================
% SECTION NAME	: ARBITER
%=================================================================
Section("arbiter", 0, 0xf0);

Register("arbiter_capabilities", 0xf0, 4, "null");
		Field("agent_nb", 17, 16, "rd", 0x0, 0x2, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("tag", 11, 0, "rd", 0x0, 0xAAB, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");

variable agentTags = UChar_Type[2];

for(i = 0; i < 2; i++)
{
	agentTags[i] = i;
}

Group("agent", "DECTAG", agentTags);

for(i = 0; i < 2; i++)
{

	Register("agent", 0xf4 + i*0x4, 4, "agent*", "agent", i, "null");
		Field("ack", 9, 9, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "master request ACKnoledge");
			FieldValue(" The resource is NOT ready to be used.", 0);
			FieldValue(" The resource is ready to be used.", 1);
		Field("rec", 8, 8, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "master request RECeived");
			FieldValue(" Master request not received", 0);
			FieldValue("Master request has been received", 1);
		Field("done", 4, 4, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "transaction DONE ");
			FieldValue("Nothing", 0);
			FieldValue("Master requester transaction done", 1);
		Field("req", 0, 0, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "REQuest resource");
			FieldValue("Nothing", 0);
			FieldValue("Ask for a device resource", 1);
}

%=================================================================
% SECTION NAME	: AXI_WINDOW
%=================================================================
Section("axi_window", 0, 0x100);

variable axi_windowTags = UChar_Type[4];

for(i = 0; i < 4; i++)
{
	axi_windowTags[i] = i;
}

Group("axi_window", "DECTAG", axi_windowTags);

for(i = 0; i < 4; i++)
{

	Register("ctrl", 0x100 + i*0x10, 4, "ctrl*", "axi_window", i, "PCIe Bar 0 start address");
		Field("enable", 0, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("pci_bar0_start", 0x104 + i*0x10, 4, "pci_bar0_start*", "axi_window", i, "PCIe Bar 0 window start offset");
		Field("value", 25, 2, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("valuelsbRO", 1, 0, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");

	Register("pci_bar0_stop", 0x108 + i*0x10, 4, "pci_bar0_stop*", "axi_window", i, "PCIe Bar 0 window stop offset");
		Field("value", 25, 2, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("valuelsbRO", 1, 0, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");

	Register("axi_translation", 0x10c + i*0x10, 4, "axi_translation*", "axi_window", i, "Axi offset translation");
		Field("value", 31, 2, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("valuelsbRO", 1, 0, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
}

%=================================================================
% SECTION NAME	: IO
%=================================================================
Section("IO", 0, 0x200);

variable ioTags = UChar_Type[2];

for(i = 0; i < 2; i++)
{
	ioTags[i] = i;
}

Group("io", "DECTAG", ioTags);

for(i = 0; i < 2; i++)
{

	Register("capabilities_io", 0x200 + i*0x80, 4, "capabilities_io*", "io", i, "null");
		Field("io_id", 31, 24, "rd", 0x0, 0x10, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("n_port", 23, 19, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
		Field("input", 18, 18, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("No input capabilities", 0);
			FieldValue("Input capabilities present", 1);
		Field("output", 17, 17, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("No output capabilities", 0);
			FieldValue("Output capabilities present", 1);
		Field("intnum", 16, 12, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");

	Register("io_pin", 0x204 + i*0x80, 4, "io_pin*", "io", i, "null");
		Field("pin_value", 3, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("Input is de-asserted", 0);
			FieldValue("Input is asserted", 1);

	Register("io_out", 0x208 + i*0x80, 4, "io_out*", "io", i, "null");
		Field("out_value", 3, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Output will be low", 0);
			FieldValue("Output will be high", 1);

	Register("io_dir", 0x20c + i*0x80, 4, "io_dir*", "io", i, "null");
		Field("dir", 3, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("User pin is an input", 0);
			FieldValue("User pin is an output. Input functions still work (interrupt, readback) but the input value will be the driven value.", 1);

	Register("io_pol", 0x210 + i*0x80, 4, "io_pol*", "io", i, "null");
		Field("in_pol", 3, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("User I/O input generates an interrupt on rising edge.", 0);
			FieldValue("User I/O input generates an interrupt on falling edge.", 1);

	Register("io_intstat", 0x214 + i*0x80, 4, "io_intstat*", "io", i, "null");
		Field("intstat", 3, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
			FieldValue("No interrupt detected", 0);
			FieldValue("Interrupt event occured", 1);

	Register("io_intmaskn", 0x218 + i*0x80, 4, "io_intmaskn*", "io", i, "null");
		Field("intmaskn", 3, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("No interrupt will be generated for the corresponding user I/O. (Note that if the corresponding bit is already asserted in the IO_INTSTAT register, the interrupt will still be generated)", 0);
			FieldValue("Interrupt generated when the corresponding I/O toggles with the polarity defined in IO_POL register.", 1);

	Register("io_anyedge", 0x21c + i*0x80, 4, "io_anyedge*", "io", i, "null");
		Field("in_anyedge", 3, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
}

%=================================================================
% SECTION NAME	: QUADRATURE
%=================================================================
Section("Quadrature", 0, 0x300);

variable quadratureTags = UChar_Type[1];

for(i = 0; i < 1; i++)
{
	quadratureTags[i] = i;
}

Group("quadrature", "DECTAG", quadratureTags);

for(i = 0; i < 1; i++)
{

	Register("capabilities_quad", 0x300 + i*0x80, 4, "capabilities_quad*", "quadrature", i, "null");
		Field("quadrature_id", 31, 24, "rd", 0x0, 0x64, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("feature_rev", 23, 20, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");

	Register("positionreset", 0x304 + i*0x80, 4, "positionreset*", "quadrature", i, "null");
		Field("positionresetsource", 5, 2, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Disable Reset source", 0);
			FieldValue("Counter reaches position trigger", 5);
		Field("positionresetactivation", 1, 1, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Rising edge", 0);
			FieldValue("Falling edge", 1);
		Field("soft_positionreset", 0, 0, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("Nothing", 0);
			FieldValue("Software position reset", 1);

	Register("decoderinput", 0x308 + i*0x80, 4, "decoderinput*", "quadrature", i, "null");
		Field("bselector", 31, 29, "rd|wr", 0x0, 0x2, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("aselector", 15, 13, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("decodercfg", 0x30c + i*0x80, 4, "decodercfg*", "quadrature", i, "null");
		Field("decoutsource0", 4, 2, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("New Tick", 0);
			FieldValue("Clock Wise Tick", 1);
			FieldValue("Counter Clock Wise Tick", 2);
			FieldValue("Any Tick (Clock or counter clock wise ticks)", 3);
			FieldValue("Counter reaches Position Trigger register(Regenerated Tick)", 4);
		Field("quadenable", 0, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Quadrature decoder disable", 0);
			FieldValue("Quadratue decoder enable", 1);

	Register("decoderpostrigger", 0x310 + i*0x80, 4, "decoderpostrigger*", "quadrature", i, "null");
		Field("positiontrigger", 31, 0, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("decodercntrlatch_cfg", 0x314 + i*0x80, 4, "decodercntrlatch_cfg*", "quadrature", i, "null");
		Field("decodercntrlatch_sw", 24, 24, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("Nothing", 0);
			FieldValue("Latch the quad decoder counter into DecoderCntrLatched_SW register.", 1);
		Field("decodercntrlatch_src", 20, 16, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("decodercntrlatch_en", 8, 8, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Nothing", 0);
			FieldValue("Enable the Quad decoder counter latch from Inputs and Timers", 1);
		Field("decodercntrlatch_act", 5, 4, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("RisingEdge", 0);
			FieldValue("FallingEdge", 1);
			FieldValue("AnyEdge", 2);
			FieldValue("None (edge detection disable)", 3);

	Register("decodercntrlatched_sw", 0x334 + i*0x80, 4, "decodercntrlatched_sw*", "quadrature", i, "null");
		Field("decodercntr", 31, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");

	Register("decodercntrlatched", 0x338 + i*0x80, 4, "decodercntrlatched*", "quadrature", i, "null");
		Field("decodercntr", 31, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
}

%=================================================================
% SECTION NAME	: TICKTABLE
%=================================================================
Section("TickTable", 0, 0x380);

variable ticktableTags = UChar_Type[1];

for(i = 0; i < 1; i++)
{
	ticktableTags[i] = i;
}

Group("ticktable", "DECTAG", ticktableTags);

for(i = 0; i < 1; i++)
{

	Register("capabilities_ticktbl", 0x380 + i*0x80, 4, "capabilities_ticktbl*", "ticktable", i, "null");
		Field("ticktable_id", 31, 24, "rd", 0x0, 0x61, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("feature_rev", 23, 20, "rd", 0x0, 0x1, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("nb_elements", 16, 12, "rd", 0x0, 0xd, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("intnum", 11, 7, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");

	Register("capabilities_ext1", 0x384 + i*0x80, 4, "capabilities_ext1*", "ticktable", i, "null");
		Field("nb_latch", 11, 8, "rd", 0x0, 0x2, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("table_width", 7, 0, "rd", 0x0, 0x4, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");

	Register("ticktableclockperiod", 0x388 + i*0x80, 4, "ticktableclockperiod*", "ticktable", i, "null");
		Field("period_ns", 7, 0, "rd", 0x0, 0x1e, 0x0, 0x0, NO_TEST, 0, 0, "null");

	Register("tickconfig", 0x38c + i*0x80, 4, "tickconfig*", "ticktable", i, "null");
		Field("clearticktable", 28, 28, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Clear command in Tick Table");
		Field("clearmask", 23, 16, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Clear command Mask ");
		Field("tickclock", 11, 8, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Internal clock source", 0);
			FieldValue("QuadratureDecoder Output", 5);
		Field("intclock_sel", 7, 6, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("T=Period_ns * 8192 : Clock Int is 4.069 Khz(GPm),  3.05175 Khz(GPm-Atom), 7.629 Khz(Spider_PCIe)", 0);
			FieldValue("T=Period_ns * 2048 : Clock Int is 16.276 Khz(GPm),  12.207 Khz(GPm-Atom),  30.518Khz(Spider_PCIe) (Default)", 1);
			FieldValue("T=Period_ns * 1024 : Clock Int is 32.552 Khz(GPm),  24.414 Khz(GPm-Atom),  61.035Khz(Spider_PCIe) ", 2);
			FieldValue("T=Period_ns * 256 : Clock Int is 130.208 Khz(GPm),  97.656 Khz(GPm-Atom),  244.141Khz(Spider_PCIe) ", 3);
		Field("tickclockactivation", 5, 4, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("RisingEdge", 0);
			FieldValue("FallingEdge", 1);
			FieldValue("AnyEdge", 2);
			FieldValue("None (edge detection disable)", 3);
		Field("enablehalftableint", 3, 3, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("No interrupt are generated", 0);
			FieldValue("An interrupt is generated whenever an half of the table has been executed(first half and second half).", 1);
		Field("intclock_en", 2, 2, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Internal clock disabled", 0);
			FieldValue("Internal clock enabled", 1);
		Field("latchcurrentstamp", 1, 1, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("Nothing", 0);
			FieldValue("Latch current stamp to register", 1);
		Field("resettimestamp", 0, 0, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("Nothing", 0);
			FieldValue("Reset ticktable and counters", 1);

	Register("currentstamplatched", 0x390 + i*0x80, 4, "currentstamplatched*", "ticktable", i, "null");
		Field("currentstamp", 31, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");

	Register("writetime", 0x394 + i*0x80, 4, "writetime*", "ticktable", i, "null");
		Field("writetime", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("writecommand", 0x398 + i*0x80, 4, "writecommand*", "ticktable", i, "null");
		Field("writedone", 13, 13, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("Last Cmd running", 0);
			FieldValue("Last Cmd executed", 1);
		Field("writestatus", 12, 12, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("Last ExecuteFutureWrite resulted in failure", 0);
			FieldValue("Last ExecuteFutureWrite resulted in success", 1);
		Field("executefuturewrite", 9, 9, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("Nothing", 0);
			FieldValue("Future write snapshot", 1);
		Field("executeimmwrite", 8, 8, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("Nothing", 0);
			FieldValue("Imminent write snapshot", 1);
		Field("bitcmd", 6, 5, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Do not change output", 0);
			FieldValue("Rise output", 1);
			FieldValue("Fall output", 2);
			FieldValue("Rise-then-fall output.", 3);
		Field("bitnum", 1, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("latchintstat", 0x39c + i*0x80, 4, "latchintstat*", "ticktable", i, "null");
		Field("latchintstat", 1, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
			FieldValue("No interrupt condition", 0);
			FieldValue("Interrupt condition occured", 1);

	Register("inputstamp", 0x3a0 + i*0x80, 4, "inputstamp*", "ticktable", i, "null");
		Field("inputstampsource", 19, 16, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("latchinputintenable", 9, 9, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Interrupt generation disabled", 0);
			FieldValue("Interrupt generation enabled", 1);
		Field("latchinputstamp_en", 8, 8, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Nothing", 0);
			FieldValue("Enable the Input stamp arm logic", 1);
		Field("inputstampactivation", 5, 4, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("RisingEdge", 0);
			FieldValue("FallingEdge", 1);
			FieldValue("AnyEdge", 2);
			FieldValue("None (edge detection disable)", 3);

	Register("inputstamp", 0x3a4 + i*0x80, 4, "inputstamp*", "ticktable", i, "null");
		Field("inputstampsource", 19, 16, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("latchinputintenable", 9, 9, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Interrupt generation disabled", 0);
			FieldValue("Interrupt generation enabled", 1);
		Field("latchinputstamp_en", 8, 8, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Nothing", 0);
			FieldValue("Enable the Input stamp arm logic", 1);
		Field("inputstampactivation", 5, 4, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("RisingEdge", 0);
			FieldValue("FallingEdge", 1);
			FieldValue("AnyEdge", 2);
			FieldValue("None (edge detection disable)", 3);

	Register("reserved_for_extra_latch", 0x3a8 + i*0x80, 4, "reserved_for_extra_latch**", "ticktable", i, "null");
		Field("reserved_for_extra_latch", 0, 0, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");

	Register("reserved_for_extra_latch", 0x3ac + i*0x80, 4, "reserved_for_extra_latch**", "ticktable", i, "null");
		Field("reserved_for_extra_latch", 0, 0, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");

	Register("reserved_for_extra_latch", 0x3b0 + i*0x80, 4, "reserved_for_extra_latch**", "ticktable", i, "null");
		Field("reserved_for_extra_latch", 0, 0, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");

	Register("reserved_for_extra_latch", 0x3b4 + i*0x80, 4, "reserved_for_extra_latch**", "ticktable", i, "null");
		Field("reserved_for_extra_latch", 0, 0, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");

	Register("reserved_for_extra_latch", 0x3b8 + i*0x80, 4, "reserved_for_extra_latch**", "ticktable", i, "null");
		Field("reserved_for_extra_latch", 0, 0, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");

	Register("reserved_for_extra_latch", 0x3bc + i*0x80, 4, "reserved_for_extra_latch**", "ticktable", i, "null");
		Field("reserved_for_extra_latch", 0, 0, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");

	Register("reserved_for_extra_latch", 0x3c0 + i*0x80, 4, "reserved_for_extra_latch**", "ticktable", i, "null");
		Field("reserved_for_extra_latch", 0, 0, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");

	Register("reserved_for_extra_latch", 0x3c4 + i*0x80, 4, "reserved_for_extra_latch**", "ticktable", i, "null");
		Field("reserved_for_extra_latch", 0, 0, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");

	Register("reserved_for_extra_latch", 0x3c8 + i*0x80, 4, "reserved_for_extra_latch**", "ticktable", i, "null");
		Field("reserved_for_extra_latch", 0, 0, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");

	Register("reserved_for_extra_latch", 0x3cc + i*0x80, 4, "reserved_for_extra_latch**", "ticktable", i, "null");
		Field("reserved_for_extra_latch", 0, 0, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");

	Register("inputstamplatched", 0x3d0 + i*0x80, 4, "inputstamplatched*", "ticktable", i, "null");
		Field("inputstamp", 31, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");

	Register("inputstamplatched", 0x3d4 + i*0x80, 4, "inputstamplatched*", "ticktable", i, "null");
		Field("inputstamp", 31, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
}

%=================================================================
% SECTION NAME	: INPUTCONDITIONING
%=================================================================
Section("InputConditioning", 0, 0x400);

Register("capabilities_incond", 0x400, 4, "null");
		Field("inputcond_id", 31, 24, "rd", 0x0, 0x62, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("feature_rev", 23, 20, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("nb_inputs", 16, 12, "rd", 0x0, 0x4, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("period_ns", 7, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");

variable inputconditioningTags = UChar_Type[4];

for(i = 0; i < 4; i++)
{
	inputconditioningTags[i] = i;
}

Group("inputconditioning", "DECTAG", inputconditioningTags);

for(i = 0; i < 4; i++)
{

	Register("inputconditioning", 0x404 + i*0x4, 4, "inputconditioning*", "inputconditioning", i, "");
		Field("debounceholdoff", 31, 8, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("inputfiltering", 1, 1, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Filtering OFF", 0);
			FieldValue("500 ns +/- 10% filtering enabled", 1);
		Field("inputpol", 0, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Not invert polarity", 0);
			FieldValue("Invert polarity ", 1);
}

%=================================================================
% SECTION NAME	: OUTPUTCONDITIONING
%=================================================================
Section("OutputConditioning", 0, 0x480);

Register("capabilities_outcond", 0x480, 4, "null");
		Field("outputcond_id", 31, 24, "rd", 0x0, 0x63, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("feature_rev", 23, 20, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("nb_outputs", 16, 12, "rd", 0x0, 0x4, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");

variable outputcondTags = UChar_Type[4];

for(i = 0; i < 4; i++)
{
	outputcondTags[i] = i;
}

Group("outputcond", "DECTAG", outputcondTags);

for(i = 0; i < 4; i++)
{

	Register("outputcond", 0x484 + i*0x4, 4, "outputcond*", "outputcond", i, "null");
		Field("outputval", 16, 16, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Output Value");
		Field("outputpol", 7, 7, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Do not change polarity", 0);
			FieldValue("Polarity inverted", 1);
		Field("outsel", 5, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Static output programmed in IO module", 0);
			FieldValue("QuadratureDecoder", 5);
}

Register("reserved", 0x494, 4, "null");
		Field("reserved", 7, 0, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
			FieldValue("No interrupt detected", 0);
			FieldValue("Interrupt event occured", 1);

Register("output_debounce", 0x4ac, 4, "null");
		Field("output_holdoff_reg_en", 16, 16, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("output_holdoff_reg_cntr", 9, 0, "rd|wr", 0x0, 0x1ff, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

%=================================================================
% SECTION NAME	: INTERNALINPUT
%=================================================================
Section("InternalInput", 0, 0x500);

Register("capabilities_int_inp", 0x500, 4, "null");
		Field("int_input_id", 31, 24, "rd", 0x0, 0x66, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("feature_rev", 23, 20, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("nb_inputs", 16, 12, "rd", 0x0, 0x3, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");

%=================================================================
% SECTION NAME	: INTERNALOUTPUT
%=================================================================
Section("InternalOutput", 0, 0x580);

Register("capabilities_intout", 0x580, 4, "null");
		Field("int_output_id", 31, 24, "rd", 0x0, 0x65, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("feature_rev", 23, 20, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("nb_outputs", 16, 12, "rd", 0x0, 0x1, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");

variable outputcondTags = UChar_Type[1];

for(i = 0; i < 1; i++)
{
	outputcondTags[i] = i;
}

Group("outputcond", "DECTAG", outputcondTags);

for(i = 0; i < 1; i++)
{

	Register("outputcond", 0x584 + i*0x4, 4, "outputcond*", "outputcond", i, "null");
		Field("outputval", 16, 16, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Output Value");
		Field("outsel", 5, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("QuadratureDecoder", 4);
			FieldValue("Microblaze internal output", 17);
}

%=================================================================
% SECTION NAME	: TIMER
%=================================================================
Section("Timer", 0, 0x600);

variable timerTags = UChar_Type[8];

for(i = 0; i < 8; i++)
{
	timerTags[i] = i;
}

Group("timer", "DECTAG", timerTags);

for(i = 0; i < 8; i++)
{

	Register("capabilities_timer", 0x600 + i*0x80, 4, "capabilities_timer*", "timer", i, "null");
		Field("timer_id", 31, 24, "rd", 0x0, 0x60, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("feature_rev", 23, 20, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("intnum", 11, 7, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");

	Register("timerclockperiod", 0x604 + i*0x80, 4, "timerclockperiod*", "timer", i, "null");
		Field("period_ns", 15, 0, "rd", 0x0, 0xf0, 0x0, 0x0, NO_TEST, 0, 0, "null");

	Register("timertriggerarm", 0x608 + i*0x80, 4, "timertriggerarm*", "timer", i, "null");
		Field("soft_timerarm", 31, 31, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("Nothing", 0);
			FieldValue("Sofware Timer Arm", 1);
		Field("timertriggeroverlap", 26, 25, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("M_OFF", 0);
			FieldValue("M_LATCH", 1);
			FieldValue("M_RESET", 2);
			FieldValue("Reserved", 3);
		Field("timerarmenable", 24, 24, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("The timer will not wait for a ARM event", 0);
			FieldValue("The timer will wait for a ARM event", 1);
		Field("timerarmsource", 23, 19, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Software", 0);
		Field("timerarmactivation", 18, 16, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("RisingEdge", 0);
			FieldValue("FallingEdge", 1);
			FieldValue("AnyEdge", 2);
			FieldValue("LevelLow", 3);
			FieldValue("LevelHigh", 4);
			FieldValue("None (edge detection disable)", 5);
		Field("soft_timertrigger", 15, 15, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("Nothing", 0);
			FieldValue("Software Timer trigger", 1);
		Field("timermesurement", 14, 14, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Set the timer in pulse generation mode", 0);
			FieldValue("Set the timer in pulse measurement mode", 1);
		Field("timertriggerlogicesel", 12, 11, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Logic 1", 0);
			FieldValue("Arm Activation signal", 1);
			FieldValue("Trigger Activation signal AND Arm Activation signal", 2);
			FieldValue("Trigger Activation signal OR Arm Activation signal", 3);
		Field("timertriggerlogicdsel", 10, 9, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Trigger Activation signal", 0);
			FieldValue("Trigger Activation signal AND Arm Activation signal", 1);
			FieldValue("Trigger Activation signal OR  Arm Activation signal", 2);
			FieldValue("Trigger Activation signal XOR Arm Activation signal", 3);
		Field("timertriggersource", 8, 3, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Continuous mode (Delaying->Active->Delaying...)", 0);
			FieldValue("Software", 1);
			FieldValue("QuadratureDecoder Output", 13);
		Field("timertriggeractivation", 2, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("RisingEdge", 0);
			FieldValue("FallingEdge", 1);
			FieldValue("AnyEdge", 2);
			FieldValue("LevelLow", 3);
			FieldValue("LevelHigh", 4);
			FieldValue("None (edge detection disable)", 5);

	Register("timerclocksource", 0x60c + i*0x80, 4, "timerclocksource*", "timer", i, "null");
		Field("intclock_sel", 17, 16, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Clock Int twice the nominal frequency", 0);
			FieldValue("Clock Int is nominal clock period as defined by TimerClockPeriod register", 1);
			FieldValue("Clock Int is half the nominal frequency", 2);
			FieldValue("Clock Int is quater of the nominal frequency", 3);
		Field("delayclockactivation", 13, 12, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("RisingEdge", 0);
			FieldValue("FallingEdge", 1);
			FieldValue("AnyEdge", 2);
			FieldValue("None (edge detection disable)", 3);
		Field("delayclocksource", 11, 8, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Internal reference clock as defined by Period_ns field", 0);
			FieldValue("QuadratureDecoder Outputs", 5);
		Field("timerclockactivation", 5, 4, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("RisingEdge", 0);
			FieldValue("FallingEdge", 1);
			FieldValue("AnyEdge", 2);
			FieldValue("None (edge detection disable)", 3);
		Field("timerclocksource", 3, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Internal reference clock as defined by Period_ns field", 0);
			FieldValue("QuadratureDecoder Outputs", 5);

	Register("timerdelayvalue", 0x610 + i*0x80, 4, "timerdelayvalue*", "timer", i, "null");
		Field("timerdelayvalue", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("timerduration", 0x614 + i*0x80, 4, "timerduration*", "timer", i, "null");
		Field("timerduration", 31, 0, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("timerlatchedvalue", 0x618 + i*0x80, 4, "timerlatchedvalue*", "timer", i, "null");
		Field("timerlatchedvalue", 31, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");

	Register("timerstatus", 0x61c + i*0x80, 4, "timerstatus*", "timer", i, "null");
		Field("timerstatus", 31, 29, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("TimerDisabled", 0);
			FieldValue("WaitOnArm", 1);
			FieldValue("WaitOnTrigger", 2);
			FieldValue("Delaying, output of the is '0'", 3);
			FieldValue("Active, output of the timer is '1'", 4);
			FieldValue("Measure, output of the is '0'", 5);
		Field("timerstatus_latched", 28, 26, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("TimerDisabled", 0);
			FieldValue("WaitOnArm", 1);
			FieldValue("WaitOnTrigger", 2);
			FieldValue("Delaying, output of the is '0'", 3);
			FieldValue("Active, output of the timer is '1'", 4);
			FieldValue("Measure, output of the is '0'", 5);
		Field("timerendintmaskn", 17, 17, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("No interrupt will be generated for the corresponding End Timer.", 0);
			FieldValue("Interrupt will be generated for the corresponding End Timer.", 1);
		Field("timerstartintmaskn", 16, 16, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("No interrupt will be generated for the corresponding Timer.", 0);
			FieldValue("Interrupt will be generated for the correspondingTimer.", 1);
		Field("timerlatchandreset", 10, 10, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Don't reset the internal counter after latching the current value", 0);
			FieldValue("Reset the internal counter after latching the current value", 1);
		Field("timerlatchvalue", 9, 9, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("Nothing", 0);
			FieldValue("Timer latched value register snapshot", 1);
		Field("timercntrreset", 8, 8, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("Nothing", 0);
			FieldValue("Timer Counter Reset", 1);
		Field("timerinversion", 1, 1, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Output is '1' in the Active state, '0' otherwise", 0);
			FieldValue("Outout is '0' in the Active state, '1' otherwise", 1);
		Field("timerenable", 0, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Timer is disabled, it's output is in '0' state", 0);
			FieldValue("Timer is enabled and cycles in arm, trigger, delay and active state", 1);
}

%=================================================================
% SECTION NAME	: MICROBLAZE
%=================================================================
Section("Microblaze", 0, 0xa00);

Register("capabilities_micro", 0xa00, 4, "null");
		Field("micro_id", 31, 24, "rd", 0x0, 0x70, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("feature_rev", 23, 20, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("intnum", 19, 15, "rd", 0x0, 0x6, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");

variable prodconsTags = UChar_Type[2];

for(i = 0; i < 2; i++)
{
	prodconsTags[i] = i;
}

Group("prodcons", "DECTAG", prodconsTags);

for(i = 0; i < 2; i++)
{

	Register("prodcons", 0xa04 + i*0x4, 4, "prodcons*", "prodcons", i, "null");
		Field("memorysize", 24, 20, "rd", 0x0, 0xc, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("offset", 19, 0, "rd", 0x0, 0x2000, 0x0, 0x0, NO_TEST, 0, 0, "null");
}

%=================================================================
% SECTION NAME	: ANALOGOUTPUT
%=================================================================
Section("AnalogOutput", 0, 0xa80);

Register("capabilities_ana_out", 0xa80, 4, "null");
		Field("ana_out_id", 31, 24, "rd", 0x0, 0x67, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("feature_rev", 23, 20, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("nb_outputs", 15, 12, "rd", 0x0, 0x1, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");

Register("outputvalue", 0xa84, 4, "null");
		Field("outputval", 7, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "");

%=================================================================
% SECTION NAME	: EOFM
%=================================================================
Section("EOFM", 0, 0xb00);

Register("eofm", 0xb00, 4, "null");
		Field("eofm", 31, 24, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");

%=================================================================
% EXTERNAL NAME	: PRODCONS
%=================================================================
Section("ProdCons", 0, 0x2000);

variable prodconsTags = UChar_Type[2];

for(i = 0; i < 2; i++)
{
	prodconsTags[i] = i;
}

Group("prodcons", "DECTAG", prodconsTags);

for(i = 0; i < 2; i++)
{

	Register("pointers", 0x2000 + i*0x2000, 4, "pointers*", "prodcons", i, "null");
		Field("output_free_end", 31, 24, "rd|wr", 0x0, 0xff, 0xffffffff, 0xffffffff, TEST, 0, 0, "");
		Field("output_free_start", 23, 16, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "");
		Field("input_free_end", 15, 8, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "");
		Field("input_free_start", 7, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "");

	Register("dpram", 0x3000 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3004 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3008 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x300c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3010 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3014 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3018 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x301c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3020 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3024 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3028 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x302c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3030 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3034 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3038 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x303c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3040 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3044 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3048 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x304c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3050 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3054 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3058 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x305c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3060 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3064 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3068 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x306c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3070 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3074 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3078 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x307c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3080 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3084 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3088 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x308c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3090 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3094 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3098 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x309c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x30a0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x30a4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x30a8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x30ac + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x30b0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x30b4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x30b8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x30bc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x30c0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x30c4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x30c8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x30cc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x30d0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x30d4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x30d8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x30dc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x30e0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x30e4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x30e8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x30ec + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x30f0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x30f4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x30f8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x30fc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3100 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3104 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3108 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x310c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3110 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3114 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3118 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x311c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3120 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3124 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3128 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x312c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3130 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3134 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3138 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x313c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3140 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3144 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3148 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x314c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3150 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3154 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3158 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x315c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3160 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3164 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3168 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x316c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3170 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3174 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3178 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x317c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3180 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3184 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3188 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x318c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3190 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3194 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3198 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x319c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x31a0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x31a4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x31a8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x31ac + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x31b0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x31b4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x31b8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x31bc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x31c0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x31c4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x31c8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x31cc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x31d0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x31d4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x31d8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x31dc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x31e0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x31e4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x31e8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x31ec + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x31f0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x31f4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x31f8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x31fc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3200 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3204 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3208 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x320c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3210 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3214 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3218 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x321c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3220 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3224 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3228 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x322c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3230 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3234 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3238 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x323c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3240 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3244 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3248 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x324c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3250 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3254 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3258 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x325c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3260 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3264 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3268 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x326c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3270 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3274 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3278 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x327c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3280 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3284 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3288 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x328c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3290 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3294 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3298 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x329c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x32a0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x32a4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x32a8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x32ac + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x32b0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x32b4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x32b8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x32bc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x32c0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x32c4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x32c8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x32cc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x32d0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x32d4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x32d8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x32dc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x32e0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x32e4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x32e8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x32ec + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x32f0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x32f4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x32f8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x32fc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3300 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3304 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3308 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x330c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3310 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3314 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3318 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x331c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3320 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3324 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3328 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x332c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3330 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3334 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3338 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x333c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3340 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3344 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3348 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x334c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3350 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3354 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3358 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x335c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3360 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3364 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3368 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x336c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3370 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3374 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3378 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x337c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3380 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3384 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3388 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x338c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3390 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3394 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3398 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x339c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x33a0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x33a4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x33a8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x33ac + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x33b0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x33b4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x33b8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x33bc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x33c0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x33c4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x33c8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x33cc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x33d0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x33d4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x33d8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x33dc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x33e0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x33e4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x33e8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x33ec + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x33f0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x33f4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x33f8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x33fc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3400 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3404 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3408 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x340c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3410 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3414 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3418 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x341c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3420 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3424 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3428 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x342c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3430 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3434 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3438 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x343c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3440 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3444 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3448 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x344c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3450 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3454 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3458 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x345c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3460 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3464 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3468 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x346c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3470 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3474 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3478 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x347c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3480 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3484 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3488 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x348c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3490 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3494 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3498 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x349c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x34a0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x34a4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x34a8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x34ac + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x34b0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x34b4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x34b8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x34bc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x34c0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x34c4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x34c8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x34cc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x34d0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x34d4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x34d8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x34dc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x34e0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x34e4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x34e8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x34ec + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x34f0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x34f4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x34f8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x34fc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3500 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3504 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3508 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x350c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3510 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3514 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3518 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x351c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3520 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3524 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3528 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x352c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3530 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3534 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3538 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x353c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3540 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3544 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3548 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x354c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3550 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3554 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3558 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x355c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3560 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3564 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3568 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x356c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3570 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3574 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3578 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x357c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3580 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3584 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3588 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x358c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3590 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3594 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3598 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x359c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x35a0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x35a4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x35a8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x35ac + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x35b0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x35b4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x35b8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x35bc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x35c0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x35c4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x35c8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x35cc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x35d0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x35d4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x35d8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x35dc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x35e0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x35e4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x35e8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x35ec + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x35f0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x35f4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x35f8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x35fc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3600 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3604 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3608 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x360c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3610 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3614 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3618 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x361c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3620 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3624 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3628 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x362c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3630 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3634 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3638 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x363c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3640 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3644 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3648 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x364c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3650 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3654 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3658 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x365c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3660 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3664 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3668 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x366c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3670 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3674 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3678 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x367c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3680 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3684 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3688 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x368c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3690 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3694 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3698 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x369c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x36a0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x36a4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x36a8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x36ac + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x36b0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x36b4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x36b8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x36bc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x36c0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x36c4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x36c8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x36cc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x36d0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x36d4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x36d8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x36dc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x36e0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x36e4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x36e8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x36ec + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x36f0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x36f4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x36f8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x36fc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3700 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3704 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3708 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x370c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3710 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3714 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3718 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x371c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3720 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3724 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3728 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x372c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3730 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3734 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3738 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x373c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3740 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3744 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3748 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x374c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3750 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3754 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3758 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x375c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3760 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3764 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3768 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x376c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3770 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3774 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3778 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x377c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3780 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3784 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3788 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x378c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3790 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3794 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3798 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x379c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x37a0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x37a4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x37a8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x37ac + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x37b0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x37b4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x37b8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x37bc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x37c0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x37c4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x37c8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x37cc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x37d0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x37d4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x37d8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x37dc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x37e0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x37e4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x37e8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x37ec + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x37f0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x37f4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x37f8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x37fc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3800 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3804 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3808 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x380c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3810 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3814 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3818 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x381c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3820 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3824 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3828 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x382c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3830 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3834 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3838 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x383c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3840 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3844 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3848 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x384c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3850 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3854 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3858 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x385c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3860 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3864 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3868 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x386c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3870 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3874 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3878 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x387c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3880 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3884 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3888 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x388c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3890 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3894 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3898 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x389c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x38a0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x38a4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x38a8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x38ac + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x38b0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x38b4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x38b8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x38bc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x38c0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x38c4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x38c8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x38cc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x38d0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x38d4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x38d8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x38dc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x38e0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x38e4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x38e8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x38ec + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x38f0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x38f4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x38f8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x38fc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3900 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3904 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3908 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x390c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3910 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3914 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3918 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x391c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3920 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3924 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3928 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x392c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3930 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3934 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3938 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x393c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3940 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3944 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3948 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x394c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3950 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3954 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3958 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x395c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3960 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3964 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3968 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x396c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3970 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3974 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3978 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x397c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3980 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3984 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3988 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x398c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3990 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3994 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3998 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x399c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x39a0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x39a4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x39a8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x39ac + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x39b0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x39b4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x39b8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x39bc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x39c0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x39c4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x39c8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x39cc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x39d0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x39d4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x39d8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x39dc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x39e0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x39e4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x39e8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x39ec + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x39f0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x39f4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x39f8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x39fc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a00 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a04 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a08 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a0c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a10 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a14 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a18 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a1c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a20 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a24 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a28 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a2c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a30 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a34 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a38 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a3c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a40 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a44 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a48 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a4c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a50 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a54 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a58 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a5c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a60 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a64 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a68 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a6c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a70 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a74 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a78 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a7c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a80 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a84 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a88 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a8c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a90 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a94 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a98 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3a9c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3aa0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3aa4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3aa8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3aac + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ab0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ab4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ab8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3abc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ac0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ac4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ac8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3acc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ad0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ad4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ad8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3adc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ae0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ae4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ae8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3aec + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3af0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3af4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3af8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3afc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b00 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b04 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b08 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b0c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b10 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b14 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b18 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b1c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b20 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b24 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b28 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b2c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b30 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b34 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b38 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b3c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b40 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b44 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b48 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b4c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b50 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b54 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b58 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b5c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b60 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b64 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b68 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b6c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b70 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b74 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b78 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b7c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b80 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b84 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b88 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b8c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b90 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b94 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b98 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3b9c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ba0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ba4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ba8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3bac + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3bb0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3bb4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3bb8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3bbc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3bc0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3bc4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3bc8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3bcc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3bd0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3bd4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3bd8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3bdc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3be0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3be4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3be8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3bec + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3bf0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3bf4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3bf8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3bfc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c00 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c04 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c08 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c0c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c10 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c14 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c18 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c1c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c20 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c24 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c28 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c2c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c30 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c34 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c38 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c3c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c40 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c44 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c48 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c4c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c50 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c54 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c58 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c5c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c60 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c64 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c68 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c6c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c70 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c74 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c78 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c7c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c80 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c84 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c88 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c8c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c90 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c94 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c98 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3c9c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ca0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ca4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ca8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3cac + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3cb0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3cb4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3cb8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3cbc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3cc0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3cc4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3cc8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ccc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3cd0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3cd4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3cd8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3cdc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ce0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ce4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ce8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3cec + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3cf0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3cf4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3cf8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3cfc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d00 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d04 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d08 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d0c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d10 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d14 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d18 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d1c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d20 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d24 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d28 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d2c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d30 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d34 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d38 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d3c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d40 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d44 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d48 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d4c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d50 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d54 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d58 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d5c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d60 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d64 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d68 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d6c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d70 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d74 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d78 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d7c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d80 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d84 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d88 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d8c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d90 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d94 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d98 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3d9c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3da0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3da4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3da8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3dac + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3db0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3db4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3db8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3dbc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3dc0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3dc4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3dc8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3dcc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3dd0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3dd4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3dd8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ddc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3de0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3de4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3de8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3dec + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3df0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3df4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3df8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3dfc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e00 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e04 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e08 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e0c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e10 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e14 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e18 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e1c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e20 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e24 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e28 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e2c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e30 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e34 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e38 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e3c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e40 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e44 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e48 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e4c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e50 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e54 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e58 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e5c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e60 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e64 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e68 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e6c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e70 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e74 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e78 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e7c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e80 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e84 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e88 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e8c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e90 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e94 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e98 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3e9c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ea0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ea4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ea8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3eac + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3eb0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3eb4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3eb8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ebc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ec0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ec4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ec8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ecc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ed0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ed4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ed8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3edc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ee0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ee4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ee8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3eec + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ef0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ef4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ef8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3efc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f00 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f04 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f08 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f0c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f10 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f14 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f18 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f1c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f20 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f24 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f28 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f2c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f30 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f34 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f38 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f3c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f40 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f44 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f48 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f4c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f50 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f54 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f58 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f5c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f60 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f64 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f68 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f6c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f70 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f74 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f78 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f7c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f80 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f84 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f88 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f8c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f90 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f94 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f98 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3f9c + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3fa0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3fa4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3fa8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3fac + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3fb0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3fb4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3fb8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3fbc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3fc0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3fc4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3fc8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3fcc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3fd0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3fd4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3fd8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3fdc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3fe0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3fe4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3fe8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3fec + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ff0 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ff4 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ff8 + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

	Register("dpram", 0x3ffc + i*0x2000, 4, "dpram****", "prodcons", i, "null");
		Field("data", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
}


