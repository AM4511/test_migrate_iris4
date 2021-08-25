%=================================================================
%  $HeadURL:$
%  $Revision:$
%  $Date:$
%  $Author:$
%
%  MODULE: regfile_xgs_athena
%
%  DESCRIPTION: Register file of the regfile_xgs_athena module
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
% SECTION NAME	: SYSTEM
%=================================================================
Section("SYSTEM", 0, 0x0);

Register("tag", 0x0, 4, "null");
		Field("value", 23, 0, "rd", 0x0, 0x58544d, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "Tag identifier");
			FieldValue("MTX ASCII string ", 5788749);

Register("version", 0x4, 4, "Register file version");
		Field("major", 23, 16, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("minor", 15, 8, "rd", 0x0, 0x2, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("hw", 7, 0, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");

Register("capability", 0x8, 4, "Register file version");
		Field("value", 7, 0, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");

Register("scratchpad", 0xc, 4, "Register file version");
		Field("value", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

%=================================================================
% SECTION NAME	: DMA
%=================================================================
Section("DMA", 0, 0x70);

Register("ctrl", 0x70, 4, "Initial Grab Address Register ");
		Field("grab_queue_en", 0, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "");
			FieldValue("", 0);
			FieldValue("", 1);

Register("fstart", 0x78, 4, "Initial Grab Address Register ");
		Field("value", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "INitial GRAb ADDRess Register");

Register("fstart_high", 0x7c, 4, "Initial Grab Address Register HI 32 bits");
		Field("value", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "INitial GRAb ADDRess Register High");

Register("fstart_g", 0x80, 4, "Green Grab Address Register ");
		Field("value", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "GRAb ADDRess Register");

Register("fstart_g_high", 0x84, 4, "Green Grab Address Register HIGH 32 bits");
		Field("value", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "GRAb ADDRess Register High");

Register("fstart_r", 0x88, 4, "Red Grab Address Register ");
		Field("value", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "GRAb ADDRess Register");

Register("fstart_r_high", 0x8c, 4, "Red Grab Address Register HIGH 32 bits");
		Field("value", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "GRAb ADDRess Register High");

Register("line_pitch", 0x90, 4, "Grab Line Pitch Register");
		Field("value", 15, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Grab LinePitch");

Register("line_size", 0x94, 4, "Host Line Size Register");
		Field("value", 13, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Host Line size");
			FieldValue("Auto-compute line size from sensor data.", 0);

Register("csc", 0x98, 4, "null");
		Field("color_space", 26, 24, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Reserved for Mono sensor operation", 0);
			FieldValue("BGR32", 1);
			FieldValue("YUV 4:2:2 in full range", 2);
			FieldValue("Reserved for Planar 8-bits (Not implemented yet)", 3);
			FieldValue("Reserved for Y only with color sensor (Not implemented)", 4);
			FieldValue("RAW color pixels (For color sensor only, 8bpp)", 5);
		Field("dup_last_line", 23, 23, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("normal processing", 0);
			FieldValue("last line is duplicated", 1);
		Field("sub_x", 13, 10, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("reverse_y", 9, 9, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "REVERSE Y ");
			FieldValue("Bottom to top readout", 0);
			FieldValue("Top to bottom readout", 1);
		Field("reverse_x", 8, 8, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Reverse image in X direction");
			FieldValue("Reverse X disabled", 0);
			FieldValue("Reverse X enabled", 1);

Register("output_buffer", 0xa8, 4, "Output line buffer");
		Field("max_line_buff_cnt", 31, 28, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Maximum line buffer count");
		Field("line_ptr_width", 25, 24, "rd|wr", 0x0, 0x2, 0xffffffff, 0xffffffff, TEST, 0, 0, "Line pointer size (in bits)");
			FieldValue("Not valid", 0);
			FieldValue("The buffer is divided in 2 line buffers", 1);
			FieldValue("The buffer is divided in 4 line buffers", 2);
			FieldValue("The buffer is divided in 8 line buffers", 3);
		Field("address_bus_width", 23, 20, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Line buffer address size in bits");
		Field("pcie_back_pressure", 4, 4, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "PCIE link back pressure detected");
			FieldValue("No effect", 0);
			FieldValue("Back pressure detected on PCIe", 1);
		Field("clr_max_line_buff_cnt", 0, 0, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Clear maximum line buffer count");
			FieldValue("No effect", 0);
			FieldValue("Clear the max count", 1);

Register("tlp", 0xac, 4, "null");
		Field("max_payload", 27, 16, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
		Field("bus_master_en", 3, 3, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
		Field("cfg_max_pld", 2, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "PCIe Device Control Register (Offset 08h); bits 7 downto 5");
			FieldValue("128 bytes max payload size", 0);
			FieldValue("256 bytes max payload size", 1);
			FieldValue("512 bytes max payload size", 2);
			FieldValue("1024 bytes max payload size", 3);

Register("roi_x", 0xb0, 4, "null");
		Field("roi_en", 31, 31, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Region of interest enable");
			FieldValue("Region of interest is disabled", 0);
			FieldValue("Region of interest is enabled", 1);
		Field("x_size", 28, 16, "rd|wr", 0x0, 0x3ff, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("x_start", 12, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("roi_y", 0xbc, 4, "null");
		Field("roi_en", 31, 31, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Region of interest enable");
			FieldValue("Region of interest is disabled", 0);
			FieldValue("Region of interest is enabled", 1);
		Field("y_size", 28, 16, "rd|wr", 0x0, 0x3ff, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("y_start", 12, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

%=================================================================
% SECTION NAME	: ACQ
%=================================================================
Section("ACQ", 0, 0x100);

Register("grab_ctrl", 0x100, 4, "GRAB ConTRoL Register");
		Field("reset_grab", 31, 31, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Reset not active", 0);
			FieldValue("Reset active", 1);
		Field("grab_roi2_en", 29, 29, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Dual ROI disable", 0);
			FieldValue("Dual ROI enable", 1);
		Field("abort_grab", 28, 28, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "ABORT GRAB");
			FieldValue("Normal operation", 0);
			FieldValue("Reset Grab", 1);
		Field("trigger_overlap_buffn", 16, 16, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Buffer the trigger received during the dead window in PET mode and execute", 0);
			FieldValue("The trigger will be ignored during dead window in PET mode.", 1);
		Field("trigger_overlap", 15, 15, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Trigger Overlap disable", 0);
			FieldValue("Trigger Overlap enable (default)", 1);
		Field("trigger_act", 14, 12, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "TRIGGER ACTivation");
			FieldValue("Rising edge", 0);
			FieldValue("Falling edge", 1);
			FieldValue("Rising or Falling edge", 2);
			FieldValue("Level HI ", 3);
			FieldValue("Level LO", 4);
			FieldValue("Internal Programmable Timer Trigger", 5);
			FieldValue("RESERVED", 6);
			FieldValue("RESERVED", 7);
		Field("trigger_src", 10, 8, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "TRIGGER SouRCe");
			FieldValue("RESERVED", 0);
			FieldValue("Immediate mode (Continuous)", 1);
			FieldValue("Hardware Snapshop mode", 2);
			FieldValue("Software Snapshot mode", 3);
			FieldValue("SFNC mode (auto trig)", 4);
		Field("grab_ss", 4, 4, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "GRAB Software Snapshot");
			FieldValue("Idle", 0);
			FieldValue("Start a grab", 1);
		Field("buffer_id", 1, 1, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("grab_cmd", 0, 0, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "GRAB CoMmanD");
			FieldValue("Idle", 0);
			FieldValue("Start grab command", 1);

Register("grab_stat", 0x108, 4, "null");
		Field("grab_cmd_done", 31, 31, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "GRAB CoMmanD DONE");
			FieldValue("Grab Command in process", 0);
			FieldValue("Grab command idle", 1);
		Field("abort_pet", 30, 30, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "ABORT during PET");
			FieldValue("Abort in PET Phase idle", 0);
			FieldValue("Abort in PET Phase active", 1);
		Field("abort_delai", 29, 29, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("Abort in Delai Phase idle", 0);
			FieldValue("Abort in Delai Phase active", 1);
		Field("abort_done", 28, 28, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "ABORT is DONE");
			FieldValue("Abort sequence not finished yet", 0);
			FieldValue("Abort DONE, or not started (reset value)", 1);
		Field("trigger_rdy", 24, 24, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
		Field("abort_mngr_stat", 22, 20, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
		Field("trig_mngr_stat", 19, 16, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
		Field("timer_mngr_stat", 14, 12, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
		Field("grab_mngr_stat", 11, 8, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
		Field("grab_fot", 6, 6, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "GRAB Field Overhead Time");
			FieldValue("Not in FOT", 0);
			FieldValue("In FOT", 1);
		Field("grab_readout", 5, 5, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
		Field("grab_exposure", 4, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("Idle", 0);
			FieldValue("Integrating", 1);
		Field("grab_pending", 2, 2, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("No grab pending", 0);
			FieldValue("Grab pending", 1);
		Field("grab_active", 1, 1, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
		Field("grab_idle", 0, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("Grab is in proccess", 0);
			FieldValue("Grab is Idle", 1);

Register("readout_cfg1", 0x110, 4, "null");
		Field("fot_length_line", 28, 24, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Frame Overhead Time LENGTH LINE");
		Field("eo_fot_sel", 16, 16, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("fot_length", 15, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Frame Overhead Time LENGTH");

Register("readout_cfg_frame_line", 0x114, 4, "null");
		Field("dummy_lines", 23, 16, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("curr_frame_lines", 12, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");

Register("readout_cfg2", 0x118, 4, "null");
		Field("readout_length", 28, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");

Register("readout_cfg3", 0x120, 4, "null");
		Field("line_time", 15, 0, "rd|wr", 0x0, 0x16e, 0xffffffff, 0xffffffff, TEST, 0, 0, "LINE TIME");

Register("readout_cfg4", 0x124, 4, "null");
		Field("keep_out_trig_ena", 16, 16, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("keep_out_trig_start", 15, 0, "rd|wr", 0x0, 0xffff, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("exp_ctrl1", 0x128, 4, "null");
		Field("exposure_lev_mode", 28, 28, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "EXPOSURE LEVel MODE");
			FieldValue("Timed Mode", 0);
			FieldValue("Trigger Width", 1);
		Field("exposure_ss", 27, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "EXPOSURE Single Slope");

Register("exp_ctrl2", 0x130, 4, "null");
		Field("exposure_ds", 27, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "EXPOSURE Dual ");

Register("exp_ctrl3", 0x138, 4, "null");
		Field("exposure_ts", 27, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "EXPOSURE Tripple ");

Register("trigger_delay", 0x140, 4, "null");
		Field("trigger_delay", 27, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "TRIGGER DELAY");

Register("strobe_ctrl1", 0x148, 4, "null");
		Field("strobe_e", 31, 31, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "STROBE Enable");
			FieldValue("Strobe disabled", 0);
			FieldValue("Strobe enabled", 1);
		Field("strobe_pol", 28, 28, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "STROBE POLarity");
			FieldValue("Active high strobe", 0);
			FieldValue("Active low strobe", 1);
		Field("strobe_start", 27, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "STROBE START");

Register("strobe_ctrl2", 0x150, 4, "null");
		Field("strobe_mode", 31, 31, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "STROBE MODE");
			FieldValue("Strobe start during exposure", 0);
			FieldValue("Strobe start during trigger delay", 1);
		Field("strobe_b_en", 29, 29, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "STROBE phase B ENable");
			FieldValue("Enable Strobe B", 0);
			FieldValue("Disable Strobe B", 1);
		Field("strobe_a_en", 28, 28, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "STROBE phase A ENable");
			FieldValue("Enable Strobe A (default strobe)", 0);
			FieldValue("Disable Strobe A", 1);
		Field("strobe_end", 27, 0, "rd|wr", 0x0, 0xfffffff, 0xffffffff, 0xffffffff, TEST, 0, 0, "STROBE END");

Register("acq_ser_ctrl", 0x158, 4, "Acquisition Serial Control");
		Field("ser_rwn", 16, 16, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "SERial Read/Writen");
			FieldValue("Write access", 0);
			FieldValue("Read access", 1);
		Field("ser_cmd", 9, 8, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "SERial CoMmand ");
			FieldValue("CMOS sensor access COMMAND", 0);
			FieldValue("Insert timer COMMAND", 1);
			FieldValue("STOP separator COMMAND", 2);
			FieldValue("RESERVED", 3);
		Field("ser_rf_ss", 4, 4, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "SERial Read Fifo SnapShot");
			FieldValue("Idle", 0);
			FieldValue("Start Read FIFO", 1);
		Field("ser_wf_ss", 0, 0, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "SERial Write Fifo SnapShot");
			FieldValue("Idle", 0);
			FieldValue("Write a command to the FIFO", 1);

Register("acq_ser_addata", 0x160, 4, "Serial Interface Data");
		Field("ser_dat", 31, 16, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "SERial interface DATa");
		Field("ser_add", 14, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "SERial interface ADDress");

Register("acq_ser_stat", 0x168, 4, "Serial Interface Data");
		Field("ser_fifo_empty", 24, 24, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "SERial FIFO EMPTY");
		Field("ser_busy", 16, 16, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "SERial BUSY");
			FieldValue("FIFO read logic is idle", 0);
			FieldValue("FIFO read logic is runnning", 1);
		Field("ser_dat_r", 15, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "SERial interface DATa Read");

Register("sensor_ctrl", 0x190, 4, "SENSOR ConTRoL");
		Field("sensor_refresh_temp", 24, 24, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "SENSOR REFRESH TEMPerature");
			FieldValue("Idle", 0);
			FieldValue("Starts a Temperature read on Python SPI interface", 1);
		Field("sensor_powerdown", 16, 16, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
		Field("sensor_color", 8, 8, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "SENSOR COLOR");
			FieldValue("Monochrone sensor", 0);
			FieldValue("Color sensor", 1);
		Field("sensor_reg_update", 4, 4, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "SENSOR REGister UPDATE");
			FieldValue("Do not update registers", 0);
			FieldValue("Update registers", 1);
		Field("sensor_resetn", 1, 1, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "SENSOR RESET Not");
			FieldValue("Reset the sensor after a successfull  powerUP", 0);
			FieldValue("Nothing", 1);
		Field("sensor_powerup", 0, 0, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("idle", 0);
			FieldValue("Start the power sequence", 1);

Register("sensor_stat", 0x198, 4, "SENSOR control STATus");
		Field("sensor_temp", 31, 24, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
		Field("sensor_temp_valid", 23, 23, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "SENSOR TEMPerature VALID");
			FieldValue("SENSOR_TEMPERATURE register is not valid", 0);
			FieldValue("SENSOR_TEMPERATURE register is valid", 1);
		Field("sensor_powerdown", 16, 16, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("Not in powerdown state", 0);
			FieldValue("Powerdown", 1);
		Field("sensor_resetn", 13, 13, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "SENSOR RESET N");
			FieldValue("In reset state", 0);
			FieldValue("Not in reset ", 1);
		Field("sensor_osc_en", 12, 12, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "SENSOR OSCILLATOR ENable");
			FieldValue("Disable", 0);
			FieldValue("Enable", 1);
		Field("sensor_vcc_pg", 8, 8, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "SENSOR supply VCC  Power Good");
			FieldValue("Disable", 0);
			FieldValue("Enable", 1);
		Field("sensor_powerup_stat", 1, 1, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("PowerUp sequence fail", 0);
			FieldValue("PowerUp sequence success", 1);
		Field("sensor_powerup_done", 0, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("PowerUp sequence not started", 0);
			FieldValue("PowerUp sequence finish", 1);

Register("sensor_subsampling", 0x19c, 4, "null");
		Field("reserved1", 15, 4, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("active_subsampling_y", 3, 3, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("", 0);
			FieldValue("", 1);
		Field("reserved0", 2, 2, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "");
			FieldValue("Idle", 0);
			FieldValue("Enable", 1);
		Field("m_subsampling_y", 1, 1, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "");
			FieldValue("", 0);
			FieldValue("", 1);
		Field("subsampling_x", 0, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "");
			FieldValue("", 0);
			FieldValue("", 1);

Register("sensor_gain_ana", 0x1a4, 4, "null");
		Field("reserved1", 15, 11, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("analog_gain", 10, 8, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "");
			FieldValue("1x", 1);
			FieldValue("2x", 3);
			FieldValue("4x", 7);
		Field("reserved0", 7, 0, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");

Register("sensor_roi_y_start", 0x1a8, 4, "null");
		Field("reserved", 15, 10, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("y_start", 9, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Y START");

Register("sensor_roi_y_size", 0x1ac, 4, "null");
		Field("reserved", 15, 10, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("y_size", 9, 0, "rd|wr", 0x0, 0x302, 0xffffffff, 0xffffffff, TEST, 0, 0, "Y SIZE");

Register("sensor_m_lines", 0x1b8, 4, "null");
		Field("m_lines_display", 15, 15, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("m_suppressed", 14, 10, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("m_lines_sensor", 9, 0, "rd|wr", 0x0, 0x8, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("sensor_dp_gr", 0x1bc, 4, "null");
		Field("reserved", 15, 12, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("dp_offset_gr", 11, 0, "rd|wr", 0x0, 0x100, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("sensor_dp_gb", 0x1c0, 4, "null");
		Field("reserved", 15, 12, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("dp_offset_gb", 11, 0, "rd|wr", 0x0, 0x100, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("sensor_dp_r", 0x1c4, 4, "null");
		Field("reserved", 15, 12, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("dp_offset_r", 11, 0, "rd|wr", 0x0, 0x100, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("sensor_dp_b", 0x1c8, 4, "null");
		Field("reserved", 15, 12, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("dp_offset_b", 11, 0, "rd|wr", 0x0, 0x100, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("sensor_gain_dig_g", 0x1cc, 4, "null");
		Field("reserved1", 15, 15, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("dg_factor_gr", 14, 8, "rd|wr", 0x0, 0x20, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("reserved0", 7, 7, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("dg_factor_gb", 6, 0, "rd|wr", 0x0, 0x20, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("sensor_gain_dig_rb", 0x1d0, 4, "null");
		Field("reserved1", 15, 15, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("dg_factor_r", 14, 8, "rd|wr", 0x0, 0x20, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("reserved0", 7, 7, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("dg_factor_b", 6, 0, "rd|wr", 0x0, 0x20, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("fpga_roi_x_start", 0x1d8, 4, "null");
		Field("x_start", 12, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "X START");

Register("fpga_roi_x_size", 0x1dc, 4, "null");
		Field("x_size", 12, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "X SIZE");

Register("debug_pins", 0x1e0, 4, "null");
		Field("debug3_sel", 28, 24, "rd|wr", 0x0, 0x1f, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("debug2_sel", 20, 16, "rd|wr", 0x0, 0x1f, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("debug1_sel", 12, 8, "rd|wr", 0x0, 0x1f, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("debug0_sel", 4, 0, "rd|wr", 0x0, 0x1f, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("trigger_missed", 0x1e8, 4, "null");
		Field("trigger_missed_rst", 28, 28, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "TRIGGER MISSED ReSeT");
			FieldValue("Reset the Trigger counter reset", 1);
		Field("trigger_missed_cntr", 15, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "TRIGGER MISSED CouNTeR");

Register("sensor_fps", 0x1f0, 4, "null");
		Field("sensor_fps", 15, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "SENSOR Frame Per Second");

Register("sensor_fps2", 0x1f4, 4, "null");
		Field("sensor_fps", 19, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "SENSOR Frame Per Second");

Register("debug", 0x2a0, 4, "null");
		Field("debug_rst_cntr", 28, 28, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("", 0);
			FieldValue("Reset counters", 1);
		Field("led_test_color", 2, 1, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("The LED is OFF", 0);
			FieldValue("The LED is GREEN", 1);
			FieldValue("The LED is RED", 2);
			FieldValue("The LED is ORANGE", 3);
		Field("led_test", 0, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("The LED is in user mode.", 0);
			FieldValue("The LED is in test mode.", 1);

Register("debug_cntr1", 0x2a8, 4, "null");
		Field("sensor_frame_duration", 27, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "");

Register("exp_fot", 0x2b8, 4, "null");
		Field("exp_fot", 16, 16, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "EXPosure during FOT");
			FieldValue("Disable exposure during FOT in output exposure signal and Strobe", 0);
			FieldValue("Enable exposure during FOT in output exposure signal and Strobe", 1);
		Field("exp_fot_time", 11, 0, "rd|wr", 0x0, 0x9ee, 0xffffffff, 0xffffffff, TEST, 0, 0, "EXPosure during FOT TIME");

Register("acq_sfnc", 0x2c0, 4, "null");
		Field("reload_grab_params", 0, 0, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "");
			FieldValue("", 0);
			FieldValue("", 1);

Register("timer_ctrl", 0x2d0, 4, "null");
		Field("adaptative", 8, 8, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Non adaptative", 0);
			FieldValue("Adaptative to trigger_rdy", 1);
		Field("timerstop", 4, 4, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
		Field("timerstart", 0, 0, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");

Register("timer_delay", 0x2d4, 4, "null");
		Field("value", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("timer_duration", 0x2d8, 4, "null");
		Field("value", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

%=================================================================
% SECTION NAME	: HISPI
%=================================================================
Section("HISPI", 0, 0x400);

Register("ctrl", 0x400, 4, "null");
		Field("sw_clr_idelayctrl", 4, 4, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "Reset the Xilinx macro IDELAYCTRL");
			FieldValue("No effect", 0);
			FieldValue("Reset IDELAYCTRL", 1);
		Field("sw_clr_hispi", 3, 3, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("sw_calib_serdes", 2, 2, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Initiate the SERDES TAP calibrartion ");
			FieldValue("No effect", 0);
			FieldValue("Initiate the calibration", 1);
		Field("enable_data_path", 1, 1, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("enable_hispi", 0, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("status", 0x404, 4, "Global status register");
		Field("fsm", 31, 28, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "HISPI  finite state machine status");
			FieldValue("S_DISABLED", 0);
			FieldValue("S_IDLE", 1);
			FieldValue("S_RESET_PHY", 2);
			FieldValue("S_INIT", 3);
			FieldValue("S_START_CALIBRATION", 4);
			FieldValue("S_CALIBRATE", 5);
			FieldValue("S_PACK", 6);
			FieldValue("S_FLUSH_PACKER", 7);
			FieldValue("S_SOF", 8);
			FieldValue("S_EOF", 9);
			FieldValue("S_SOL", 10);
			FieldValue("S_EOL", 11);
			FieldValue("Reserved", 12);
			FieldValue("Reserved", 13);
			FieldValue("FSM error (Unknown state)", 14);
			FieldValue("S_DONE", 15);
		Field("crc_error", 4, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Lane CRC error");
			FieldValue("No lane CRC error occured", 0);
			FieldValue("Lane CRC error occured", 1);
		Field("phy_bit_locked_error", 3, 3, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
		Field("fifo_error", 2, 2, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Calibration active ");
			FieldValue("No FiFo error occured", 0);
			FieldValue("FiFo error occured", 1);
		Field("calibration_error", 1, 1, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Calibration error");
			FieldValue("No calibration error", 0);
			FieldValue("A calibration error occured", 1);
		Field("calibration_done", 0, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Calibration sequence completed");
			FieldValue("Calibration sequence not completed", 0);
			FieldValue("Last calibration sequence completed successfully", 1);

Register("idelayctrl_status", 0x408, 4, "null");
		Field("pll_locked", 0, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "IDELAYCTRL PLL locked");
			FieldValue("IDELAYCTRL PLL unlocked", 0);
			FieldValue("IDELAYCTRL PLL locked", 1);

Register("idle_character", 0x40c, 4, "null");
		Field("value", 11, 0, "rd|wr", 0x0, 0x3A6, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("phy", 0x410, 4, "null");
		Field("pixel_per_lane", 25, 16, "rd|wr", 0x0, 0xAE, 0xffffffff, 0xffffffff, TEST, 0, 0, "Number of pixels per lanes");
		Field("mux_ratio", 10, 8, "rd", 0x0, 0x4, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("nb_lanes", 2, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Number of physical lane enabled");
			FieldValue("All lanes are disabled", 0);
			FieldValue("4 lanes enabled", 4);
			FieldValue("6 lanes enabled", 6);

Register("frame_cfg", 0x414, 4, "null");
		Field("lines_per_frame", 27, 16, "rd|wr", 0x0, 0xc1e, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("pixels_per_line", 12, 0, "rd|wr", 0x0, 0x1050, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("frame_cfg_x_valid", 0x418, 4, "null");
		Field("x_end", 28, 16, "rd|wr", 0x0, 0x1023, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("x_start", 12, 0, "rd|wr", 0x0, 0x24, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

variable lane_decoder_statusTags = UChar_Type[6];

for(i = 0; i < 6; i++)
{
	lane_decoder_statusTags[i] = i;
}

Group("lane_decoder_status", "DECTAG", lane_decoder_statusTags);

for(i = 0; i < 6; i++)
{

	Register("lane_decoder_status", 0x424 + i*0x4, 4, "lane_decoder_status*", "lane_decoder_status", i, "null");
		Field("crc_error", 15, 15, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "CRC Error");
			FieldValue("CRC no error occured", 0);
			FieldValue("CRC error occured", 1);
		Field("phy_sync_error", 14, 14, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
			FieldValue("Pixel bit boundaries unlocked", 0);
			FieldValue("Pixel bit boundaries locked", 1);
		Field("phy_bit_locked_error", 13, 13, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
			FieldValue("Pixel bit boundaries unlocked", 0);
			FieldValue("Pixel bit boundaries locked", 1);
		Field("phy_bit_locked", 12, 12, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("Pixel bit boundaries unlocked", 0);
			FieldValue("Pixel bit boundaries locked", 1);
		Field("calibration_tap_value", 8, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
		Field("calibration_error", 3, 3, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("calibration_done", 2, 2, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
		Field("fifo_underrun", 1, 1, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("fifo_overrun", 0, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
}

variable tap_histogramTags = UChar_Type[6];

for(i = 0; i < 6; i++)
{
	tap_histogramTags[i] = i;
}

Group("tap_histogram", "DECTAG", tap_histogramTags);

for(i = 0; i < 6; i++)
{

	Register("tap_histogram", 0x43c + i*0x4, 4, "tap_histogram*", "tap_histogram", i, "null");
		Field("value", 31, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
}

Register("debug", 0x454, 4, "null");
		Field("manual_calib_en", 31, 31, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("load_taps", 30, 30, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
		Field("tap_lane_5", 29, 25, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("tap_lane_4", 24, 20, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("tap_lane_3", 19, 15, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("tap_lane_2", 14, 10, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("tap_lane_1", 9, 5, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("tap_lane_0", 4, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

%=================================================================
% SECTION NAME	: DPC
%=================================================================
Section("DPC", 0, 0x480);

Register("dpc_capabilities", 0x480, 4, "null");
		Field("dpc_list_length", 27, 16, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
		Field("dpc_ver", 3, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("Initial monochrone correction only, 2 lines buffered.", 0);

Register("dpc_list_ctrl", 0x484, 4, "null");
		Field("dpc_fifo_reset", 29, 29, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Fifo in normal operation", 0);
			FieldValue("Fifo in reset State", 1);
		Field("dpc_firstlast_line_rem", 28, 28, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Do not remove any lines of the image received", 0);
			FieldValue("Remove first and last line of the image received", 1);
		Field("dpc_list_count", 27, 16, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("dpc_pattern0_cfg", 15, 15, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Do not correct current pixel", 0);
			FieldValue("Replace current pixel by a white pixel (0x3ff)", 1);
		Field("dpc_enable", 14, 14, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("DPC logic is bypassed", 0);
			FieldValue("DPC logic is enabled", 1);
		Field("dpc_list_wrn", 13, 13, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Read list operation", 0);
			FieldValue("Write list operation", 1);
		Field("dpc_list_ss", 12, 12, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("Do nothing", 0);
			FieldValue("Start the READ/WRITE transaction", 1);
		Field("dpc_list_add", 11, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("dpc_list_stat", 0x488, 4, "null");
		Field("dpc_fifo_underrun", 31, 31, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("Underrun not detected", 0);
			FieldValue("Underrun detected", 1);
		Field("dpc_fifo_overrun", 30, 30, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("Overrun not detected", 0);
			FieldValue("Overrun detected", 1);

Register("dpc_list_data1", 0x48c, 4, "null");
		Field("dpc_list_corr_y", 27, 16, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("dpc_list_corr_x", 12, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("dpc_list_data2", 0x490, 4, "");
		Field("dpc_list_corr_pattern", 7, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("dpc_list_data1_rd", 0x494, 4, "null");
		Field("dpc_list_corr_y", 27, 16, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
		Field("dpc_list_corr_x", 12, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");

Register("dpc_list_data2_rd", 0x498, 4, "");
		Field("dpc_list_corr_pattern", 7, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");

%=================================================================
% SECTION NAME	: LUT
%=================================================================
Section("LUT", 0, 0x4b0);

Register("lut_capabilities", 0x4b0, 4, "null");
		Field("lut_size_config", 27, 16, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("Reserved", 0);
			FieldValue("10 to 8 bits LUT (Mono Only)", 1);
			FieldValue("8 to 8 bits RGB LUT (Color Only)", 2);
		Field("lut_ver", 3, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("Initial monochrone LUT", 0);
			FieldValue("Initial color LUT", 1);

Register("lut_ctrl", 0x4b4, 4, "null");
		Field("lut_bypass_color", 29, 29, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "LUT BYPASS COLOR");
		Field("lut_bypass", 28, 28, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "LUT BYPASS");
		Field("lut_data_w", 25, 16, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "LUT DATA to Write");
		Field("lut_sel", 15, 12, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "LUT SELection");
			FieldValue("Write Blue LUT(Color only)", 1);
			FieldValue("Write Green LUT(Color only)", 2);
			FieldValue("Write Red LUT(Color only)", 4);
			FieldValue("Write all component RGB LUT (Color only)", 7);
			FieldValue("Write LUT 10 to 8(Mono) or LUT 10 to 10(color) with same data ", 8);
		Field("lut_wrn", 11, 11, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "LUT Write ReadNot");
			FieldValue("Read operation", 0);
			FieldValue("Write operation", 1);
		Field("lut_ss", 10, 10, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "LUT SnapShot");
		Field("lut_add", 9, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("lut_rb", 0x4b8, 4, "null");
		Field("lut_rb", 7, 0, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");

%=================================================================
% SECTION NAME	: BAYER
%=================================================================
Section("BAYER", 0, 0x4c0);

Register("bayer_capabilities", 0x4c0, 4, "null");
		Field("bayer_ver", 1, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("Bayer not implemented", 0);
			FieldValue("Initial Bayer 2x2 version", 1);

Register("wb_mul1", 0x4c4, 4, "null");
		Field("wb_mult_g", 31, 16, "rd|wr", 0x0, 0x1000, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("wb_mult_b", 15, 0, "rd|wr", 0x0, 0x1000, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("wb_mul2", 0x4c8, 4, "null");
		Field("wb_mult_r", 15, 0, "rd|wr", 0x0, 0x1000, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("wb_b_acc", 0x4cc, 4, "null");
		Field("b_acc", 30, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");

Register("wb_g_acc", 0x4d0, 4, "null");
		Field("g_acc", 31, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");

Register("wb_r_acc", 0x4d4, 4, "null");
		Field("r_acc", 30, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");

Register("ccm_ctrl", 0x4d8, 4, "null");
		Field("ccm_en", 0, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("ccm_kr1", 0x4dc, 4, "null");
		Field("kg", 27, 16, "rd|wr", 0x0, 0x000, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("kr", 11, 0, "rd|wr", 0x0, 0x100, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("ccm_kr2", 0x4e0, 4, "null");
		Field("koff", 24, 16, "rd|wr", 0x0, 0x00, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("kb", 11, 0, "rd|wr", 0x0, 0x000, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("ccm_kg1", 0x4e4, 4, "null");
		Field("kg", 27, 16, "rd|wr", 0x0, 0x100, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("kr", 11, 0, "rd|wr", 0x0, 0x000, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("ccm_kg2", 0x4e8, 4, "null");
		Field("koff", 24, 16, "rd|wr", 0x0, 0x00, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("kb", 11, 0, "rd|wr", 0x0, 0x000, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("ccm_kb1", 0x4ec, 4, "null");
		Field("kg", 27, 16, "rd|wr", 0x0, 0x00, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("kr", 11, 0, "rd|wr", 0x0, 0x00, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("ccm_kb2", 0x4f0, 4, "null");
		Field("koff", 24, 16, "rd|wr", 0x0, 0x00, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("kb", 11, 0, "rd|wr", 0x0, 0x100, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

%=================================================================
% EXTERNAL NAME	: SYSMONXIL
%=================================================================
Section("SYSMONXIL", 0, 0x700);

Register("temp", 0x700, 4, "null");
		Field("smtemp", 15, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "System Monitor TEMPerature");

Register("vccint", 0x704, 4, "system monitor VCCINT");
		Field("smvint", 15, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "System Monitor VCCINT");

Register("vccaux", 0x708, 4, "system monitor VCCAUX");
		Field("smvaux", 15, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "System Monitor VCCAUX");

Register("vccbram", 0x718, 4, "system monitor VCCBRAM");
		Field("smvbram", 15, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "System Monitor VCCBRAM");

Register("temp_max", 0x780, 4, "system monitor Temperature MAXimum");
		Field("smtmax", 15, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "System Monitor Temperature MAXimum");

Register("temp_min", 0x790, 4, "system monitor Temperature MAXimum");
		Field("smtmin", 15, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "System Monitor Temperature MINimum");


