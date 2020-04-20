%=================================================================
%  $HeadURL:$
%  $Revision:$
%  $Date:$
%  $Author:$
%
%  MODULE: dma2tlp
%
%  DESCRIPTION: Register file of the dma2tlp module
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

Register("tag", 0x0, 4, "null");
		Field("value", 23, 0, "rd", 0x0, 0x58544d, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "Tag identifier");
			FieldValue("MTX ASCII string ", 5788749);

Register("fid", 0x4, 4, "Matrox IP-Core Function ID");
		Field("value", 31, 0, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");

Register("version", 0x8, 4, "Register file version");
		Field("major", 23, 16, "rd", 0x0, 0x1, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("minor", 15, 8, "rd", 0x0, 0x5, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("hw", 7, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");

Register("capability", 0xc, 4, "Register file version");
		Field("value", 7, 0, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");

Register("scratchpad", 0x10, 4, "Register file version");
		Field("value", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

%=================================================================
% SECTION NAME	: DMA
%=================================================================
Section("dma", 0, 0x40);

Register("ctrl", 0x40, 4, "null");
		Field("grab_queue_enable", 1, 1, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Grab queue disabled", 0);
			FieldValue("Grab queue enabled", 1);
		Field("enable", 0, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

variable frame_startTags = UChar_Type[2];

for(i = 0; i < 2; i++)
{
	frame_startTags[i] = i;
}

Group("frame_start", "DECTAG", frame_startTags);

for(i = 0; i < 2; i++)
{

	Register("frame_start", 0x44 + i*0x4, 4, "frame_start*", "frame_start", i, "Initial Grab Address Register ");
		Field("value", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "INitial GRAb ADDRess Register");
}

variable frame_start_gTags = UChar_Type[2];

for(i = 0; i < 2; i++)
{
	frame_start_gTags[i] = i;
}

Group("frame_start_g", "DECTAG", frame_start_gTags);

for(i = 0; i < 2; i++)
{

	Register("frame_start_g", 0x4c + i*0x4, 4, "frame_start_g*", "frame_start_g", i, "Green Grab Address Register ");
		Field("value", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "GRAb ADDRess Register");
}

variable frame_start_rTags = UChar_Type[2];

for(i = 0; i < 2; i++)
{
	frame_start_rTags[i] = i;
}

Group("frame_start_r", "DECTAG", frame_start_rTags);

for(i = 0; i < 2; i++)
{

	Register("frame_start_r", 0x54 + i*0x4, 4, "frame_start_r*", "frame_start_r", i, "Red Grab Address Register ");
		Field("value", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "GRAb ADDRess Register");
}

Register("line_pitch", 0x5c, 4, "Grab Line Pitch Register");
		Field("value", 15, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Grab LinePitch");

Register("line_size", 0x60, 4, "Host Line Size Register");
		Field("value", 13, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Host Line size");
			FieldValue("Auto-compute line size from sensor data.", 0);

Register("csc", 0x64, 4, "null");
		Field("color_space", 26, 24, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Reserved for Mono sensor operation", 0);
			FieldValue("BGR32", 1);
			FieldValue("YUV 4:2:2 in full range", 2);
			FieldValue("Planar 8-bits", 3);
			FieldValue("Reserved for Y only with color sensor", 4);
			FieldValue("RAW color pixels (8bpp or 10bpp selected with  MONO10 regsiter)", 5);
		Field("dup_last_line", 23, 23, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("normal processing", 0);
			FieldValue("last line is duplicated", 1);
		Field("mono10", 16, 16, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Mono is in 8 bits", 0);
			FieldValue("Mono is in 10 bits", 1);
		Field("reverse_y", 9, 9, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "REVERSE Y ");
			FieldValue("Bottom to top readout", 0);
			FieldValue("Top to bottom readout", 1);
		Field("grab_revx", 8, 8, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

%=================================================================
% SECTION NAME	: STATUS
%=================================================================
Section("status", 0, 0xc0);

Register("active", 0xc0, 4, "null");
		Field("busy", 0, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");

Register("debug", 0xc4, 4, "null");
		Field("grab_max_add", 31, 2, "rd|wr", 0x0, 0x3fffffff, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("out_of_memory_clear", 1, 1, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
		Field("out_of_memory_stat", 0, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");


