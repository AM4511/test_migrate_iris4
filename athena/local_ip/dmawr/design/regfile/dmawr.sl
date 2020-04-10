%=================================================================
%  $HeadURL:$
%  $Revision:$
%  $Date:$
%  $Author:$
%
%  MODULE: dmawr
%
%  DESCRIPTION: Register file of the dmawr module
%
%  FDK IDE Version: 3.7.9
%  Build ID: I20120425-1654
%  
%  DO NOT MODIFY MANUALLY.
%
%=================================================================



variable TEST = 1;
variable NO_TEST = 0;
variable i;		%index used for filling tables used in Group registers.

%=================================================================
% SECTION NAME	: HEADER
%=================================================================
Section("HEADER", 0, 0x0);

Register("fstruc", 0x0, 8, "Function STRUCture");
		Field("tag", 31, 8, "rd", 0x0, 0x4d5458, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "Structure valid TAG");
			FieldValue("", 5067864);
		Field("mjver", 7, 4, "rd", 0x0, 0x1, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "Standard header structure MaJor VERsion");
		Field("mnver", 3, 0, "rd", 0x0, 0x4, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "Standard header structure MiNor VERsion");

Register("fid", 0x8, 8, "Function IDentification");
		Field("fid", 31, 16, "rd", 0x0, 0xc011, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "Function IDentification");
		Field("capability", 15, 0, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "CAPABILITY list");
			FieldValue("No specific capability field", 0);

Register("fsize", 0x10, 8, "Function register SIZE");
		Field("fullsize", 31, 16, "rd", 0x0, 0x40, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "FULL register SIZE");
			FieldValue("This is a reserved value indicating that the field does not actually report the size of the entire structure. That value is likely to be retrieved in the HDF section of the IP.", 0);
		Field("usersize", 15, 0, "rd", 0x0, 0x8, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "SPECific register SIZE");

Register("fctrl", 0x18, 8, "Function ConTRoL");
		Field("snppdg", 29, 29, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "SNapSHot PenDinG");
			FieldValue("Do nothing", 0);
			FieldValue("A snapshot command is pending", 1);
		Field("active", 28, 28, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Active");
			FieldValue("Do nothing", 0);
			FieldValue("A transfer is active", 1);
		Field("snpsht", 25, 25, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "SNaPSHoT");
			FieldValue("Do nothing", 0);
			FieldValue("Snapshot", 1);
		Field("abort", 24, 24, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "ABORT process");
			FieldValue("Do nothing", 0);
			FieldValue("Reset logic.", 1);
		Field("ipferr", 23, 16, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "IP Function ERRor");
			FieldValue("No error reported", 0);

Register("foffset", 0x20, 8, "Function OFFSET");
		Field("ioctloff", 31, 16, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "IO ConTroL register OFFset");
			FieldValue("No Stream Output port  is declared for this Processing Unit", 0);
		Field("useroff", 15, 0, "rd", 0x0, 0x8, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "SPECific register offset");
			FieldValue("No User specific register section is defined.", 0);

Register("fint", 0x28, 8, "Function Interrupt");
		Field("lsbof", 14, 8, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "LSB OFFSET");
			FieldValue("Reserved", 126);
			FieldValue("Interrupt not mapped.", 127);
		Field("ipevent", 2, 0, "rd", 0x0, 0x1, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "IP (number of) EVENT");
			FieldValue("No interrupt implemented", 0);
			FieldValue("1 Interrupt implemented", 1);
			FieldValue("2 Interrupts implemented", 2);
			FieldValue("3 Interrupts implemented", 3);
			FieldValue("4 Interrupts implemented", 4);
			FieldValue("5 Interrupts implemented", 5);
			FieldValue("6 Interrupts implemented", 6);
			FieldValue("7 Interrupts implemented", 7);

Register("fversion", 0x30, 8, "Function VERSION ");
		Field("subfid", 23, 16, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "SUB Function ID");
			FieldValue("1 x 128-bit sdram bank", 0);
			FieldValue("2 x 32-bit sram banks", 1);
			FieldValue("4 x 32-bit sram banks", 2);
			FieldValue("1 x 256-bit sdram bank", 3);
			FieldValue("1 x 512-bit sdram bank", 4);
			FieldValue("1 x 512-bit sdram bank, 4 contexts", 5);
			FieldValue("1 x 128-bit sdram bank, 2 contexts", 6);
		Field("ipmjver", 15, 12, "rd", 0x0, 0x2, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "IP register structure MaJor VERsion");
			FieldValue("Field Overflow", 0);
		Field("ipmnver", 11, 8, "rd", 0x0, 0x2, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "IP register structure MiNor VERsion");
			FieldValue("Initial version", 0);
			FieldValue("", 1);
			FieldValue("", 2);
		Field("iphwver", 7, 3, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "IP HardWare VERsion");

Register("frsvd3", 0x38, 8, "Function ReSerVed 3");
		Field("frsvd3", 31, 0, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "Function Reserved 3");

%=================================================================
% SECTION NAME	: USER
%=================================================================
Section("USER", 0, 0x40);

Register("dstfstart", 0x40, 8, "Destination frame start register.");
		Field("fstart", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Frame start address");

Register("dstlnpitch", 0x48, 8, "Destination pitch register.");
		Field("lnpitch", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Pitch");

Register("dstlnsize", 0x50, 8, "Destination row size register.");
		Field("lnsize", 30, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Row size");

Register("dstnbline", 0x58, 8, "Destination number of row register.");
		Field("nbline", 30, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Number of rows");

Register("dstfstart1", 0x60, 8, "DeSTination Frame START register context 1");
		Field("fstart", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Frame START address of the context number 1");

Register("dstfstart2", 0x68, 8, "DeSTination Frame START register context 2");
		Field("fstart", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Frame START address of the context number 2");

Register("dstfstart3", 0x70, 8, "DeSTination Frame START register context 3");
		Field("fstart", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Frame START address of the context number 3");

Register("dstctrl", 0x78, 8, "DeSTination ConTRoL");
		Field("bufclr", 7, 7, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "BUFfer CLeaR");
			FieldValue("Buffer clear is disabled", 0);
			FieldValue("Buffer clear is enabled", 1);
		Field("dte3", 6, 6, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "Data Transfer Enable 3");
			FieldValue("Component transfer disabled. The constant value 0x0 is sent instead of the pixel values for each pixel of the component 3.", 0);
			FieldValue("Component transfer is enabled. ", 1);
		Field("dte2", 5, 5, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "Data Transfer Enable 2");
			FieldValue("Component transfer disabled. The constant value 0x0 is sent instead of the pixel values for each pixel of the component 2.", 0);
			FieldValue("Component transfer is enabled. ", 1);
		Field("dte1", 4, 4, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "Data Transfer Enable 1");
			FieldValue("Component transfer disabled. The constant value 0x0 is sent instead of the pixel values for each pixel of the component 1.", 0);
			FieldValue("Component transfer is enabled. ", 1);
		Field("dte0", 3, 3, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "Data Transfer Enable 0");
			FieldValue("Component transfer disabled. The constant value 0x0 is sent instead of the pixel values for each pixel of the component 0.", 0);
			FieldValue("Component transfer is enabled. ", 1);
		Field("bitwdth", 2, 2, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "BIT WiDTH");
			FieldValue("8 bits per component", 0);
			FieldValue("16 bits per component", 1);
		Field("nbcontx", 1, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "NumBer of CONTeXt");
			FieldValue("One context", 0);
			FieldValue("Two contexts", 1);
			FieldValue("Three contexts", 2);
			FieldValue("Four contexts", 3);

Register("dstclrptrn", 0x80, 8, "DeSTination CLeaR PaTteRN");
		Field("clrptrn", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "CLeaR PaTteRN");


