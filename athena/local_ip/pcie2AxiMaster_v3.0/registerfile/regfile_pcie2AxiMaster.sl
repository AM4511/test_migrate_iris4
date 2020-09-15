%=================================================================
%  $HeadURL:$
%  $Revision:$
%  $Date:$
%  $Author:$
%
%  MODULE: regfile_pcie2AxiMaster
%
%  DESCRIPTION: Register file of the regfile_pcie2AxiMaster module
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
% SECTION NAME	: INFO
%=================================================================
Section("info", 0, 0x0);

Register("tag", 0x0, 4, "Matrox Tag Identifier");
		Field("value", 23, 0, "rd", 0x0, 0x58544d, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "Tag value");
			FieldValue("MTX ASCII string ", 5788749);

Register("fid", 0x4, 4, "Matrox IP-Core Function ID");
		Field("value", 31, 0, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");

Register("version", 0x8, 4, "Register file version");
		Field("major", 23, 16, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "Major version");
		Field("minor", 15, 8, "rd", 0x0, 0x9, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "Minor version");
		Field("sub_minor", 7, 0, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "Sub minor version");

Register("capability", 0xc, 4, "Register file version");
		Field("value", 7, 0, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");

Register("scratchpad", 0x10, 4, "Scratch pad");
		Field("value", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

%=================================================================
% SECTION NAME	: FPGA
%=================================================================
Section("fpga", 0, 0x20);

Register("version", 0x20, 4, "Register file version");
		Field("firmware_type", 31, 24, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Firmware type");
			FieldValue("Driver update", 0);
			FieldValue("NPI Golden firmware", 1);
			FieldValue("Engineering firmware", 2);
		Field("major", 23, 16, "rd", 0x0, 0x1, 0x0, 0x0, NO_TEST, 0, 0, "Major version");
		Field("minor", 15, 8, "rd", 0x0, 0x1, 0x0, 0x0, NO_TEST, 0, 0, "Minor version");
		Field("sub_minor", 7, 0, "rd", 0x0, 0x1, 0x0, 0x0, NO_TEST, 0, 0, "Sub minor version");
			FieldValue("", 1);

Register("build_id", 0x24, 4, "Firmware build id");
		Field("value", 31, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");

Register("device", 0x28, 4, "null");
		Field("id", 7, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Manufacturer FPGA device ID");

Register("board_info", 0x2c, 4, "Board information");
		Field("capability", 3, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Board capability");
			FieldValue("2 ToE Ports available ", 0);
			FieldValue("4 ToE ports available", 1);

%=================================================================
% SECTION NAME	: INTERRUPTS
%=================================================================
Section("interrupts", 0, 0x40);

Register("ctrl", 0x40, 4, "null");
		Field("sw_irq", 31, 31, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Software IRQ");
			FieldValue("No effect", 0);
			FieldValue("Create an Irq event (pluse)", 1);
		Field("num_irq", 7, 1, "rd", 0x0, 0x1, 0x0, 0x0, NO_TEST, 0, 0, "Number of IRQ");
		Field("global_mask", 0, 0, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "Global Mask interrupt ");
			FieldValue("Any enabled interrupt will bi signaled to the host", 0);
			FieldValue("No active interrrupt is signaled to the host", 1);

variable statusTags = UChar_Type[2];

for(i = 0; i < 2; i++)
{
	statusTags[i] = i;
}

Group("status", "DECTAG", statusTags);

for(i = 0; i < 2; i++)
{

	Register("status", 0x44 + i*0x4, 4, "status*", "status", i, "Interrupt status register");
		Field("value", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
}

variable enableTags = UChar_Type[2];

for(i = 0; i < 2; i++)
{
	enableTags[i] = i;
}

Group("enable", "DECTAG", enableTags);

for(i = 0; i < 2; i++)
{

	Register("enable", 0x4c + i*0x4, 4, "enable*", "enable", i, "Interrupt status enable");
		Field("value", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
}

variable maskTags = UChar_Type[2];

for(i = 0; i < 2; i++)
{
	maskTags[i] = i;
}

Group("mask", "DECTAG", maskTags);

for(i = 0; i < 2; i++)
{

	Register("mask", 0x54 + i*0x4, 4, "mask*", "mask", i, "Interrupt event mask");
		Field("value", 31, 0, "rd|wr", 0x0, 0xffffffff, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
}

%=================================================================
% SECTION NAME	: INTERRUPT_QUEUE
%=================================================================
Section("interrupt_queue", 0, 0x60);

Register("control", 0x60, 4, "null");
		Field("nb_dw", 31, 24, "rd", 0x0, 0x2, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "Number of DWORDS");
		Field("enable", 0, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "QInterrupt queue enable");

Register("cons_idx", 0x64, 4, "Consumer Index");
		Field("cons_idx", 9, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("addr_low", 0x68, 4, "null");
		Field("addr", 31, 12, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("addrlsbRO", 11, 0, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");

Register("addr_high", 0x6c, 4, "null");
		Field("addr", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

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
Section("spi", 0, 0xe0);

Register("spiregin", 0xe0, 4, "SPI Register In");
		Field("spi_old_enable", 25, 25, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("spi_enable", 24, 24, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "SPI ENABLE");
			FieldValue("The SPI interface is disabled", 0);
			FieldValue("The SPI interface is enabled", 1);
		Field("spirw", 22, 22, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "SPI  Read Write");
			FieldValue("Write Access", 0);
			FieldValue("Read Access", 1);
		Field("spicmddone", 21, 21, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "SPI  CoMmaD DONE");
		Field("spisel", 18, 18, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "SPI active channel SELection");
		Field("spitxst", 16, 16, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "SPI SPITXST Transfer STart");
		Field("spidataw", 7, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "SPI Data  byte to write");

Register("spiregout", 0xe8, 4, "SPI Register Out");
		Field("spi_wb_cap", 17, 17, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "SPI Write Burst CAPable");
			FieldValue("This fpga can't do write burst", 0);
			FieldValue("This fpga is capable of doing write burst", 1);
		Field("spiwrtd", 16, 16, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "SPI Write or Read Transfer Done");
			FieldValue("Transfer in progress", 0);
			FieldValue("No transfer in progress", 1);
		Field("spidatard", 7, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "SPI DATA  Read byte OUTput ");

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
% SECTION NAME	: DEBUG
%=================================================================
Section("debug", 0, 0x200);

Register("input", 0x200, 4, "debug input signals");
		Field("value", 31, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");

Register("output", 0x204, 4, "null");
		Field("value", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("dma_debug1", 0x208, 4, "null");
		Field("add_start", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("dma_debug2", 0x20c, 4, "null");
		Field("add_overrun", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("dma_debug3", 0x210, 4, "null");
		Field("dma_add_error", 4, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
		Field("dma_overrun", 0, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");


