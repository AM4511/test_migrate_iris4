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
		Field("minor", 15, 8, "rd", 0x0, 0x1, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
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
			FieldValue("Planar 8-bits", 3);
			FieldValue("Reserved for Y only with color sensor", 4);
			FieldValue("RAW color pixels (8bpp or 10bpp selected with  MONO10 regsiter)", 5);
		Field("dup_last_line", 23, 23, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("normal processing", 0);
			FieldValue("last line is duplicated", 1);
		Field("reverse_y", 9, 9, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "REVERSE Y ");
			FieldValue("Bottom to top readout", 0);
			FieldValue("Top to bottom readout", 1);
		Field("reverse_x", 8, 8, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

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
		Field("sensor_reg_uptate", 4, 4, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "SENSOR REGister UPDATE");
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

Register("sensor_roi2_y_start", 0x1b0, 4, "null");
		Field("reserved", 15, 10, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("y_start", 9, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Y START");

Register("sensor_roi2_y_size", 0x1b4, 4, "null");
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
		Field("xgs_mux_ratio", 14, 12, "rd", 0x0, 0x4, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("xgs_nb_lanes", 10, 8, "rd|wr", 0x0, 0x6, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("sw_clr_idelayctrl", 4, 4, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Reset the Xilinx macro IDELAYCTRL");
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
		Field("phy_bit_locked_error", 3, 3, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
		Field("fifo_error", 2, 2, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Calibration active ");
		Field("calibration_error", 1, 1, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Calibration active ");
		Field("calibration_done", 0, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Calibration active ");

Register("idelayctrl_status", 0x408, 4, "null");
		Field("pll_locked", 0, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "IDELAYCTRL PLL locked");
			FieldValue("IDELAYCTRL PLL unlocked", 0);
			FieldValue("IDELAYCTRL PLL locked", 1);

Register("idle_character", 0x40c, 4, "null");
		Field("value", 11, 0, "rd|wr", 0x0, 0x3A6, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("frame_cfg", 0x410, 4, "null");
		Field("lines_per_frame", 27, 16, "rd|wr", 0x0, 0xc1e, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("pixels_per_line", 12, 0, "rd|wr", 0x0, 0x1050, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("frame_cfg_x_valid", 0x414, 4, "null");
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

	Register("lane_decoder_status", 0x420 + i*0x4, 4, "lane_decoder_status*", "lane_decoder_status", i, "null");
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

	Register("tap_histogram", 0x438 + i*0x4, 4, "tap_histogram*", "tap_histogram", i, "null");
		Field("value", 31, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
}

variable lane_packer_statusTags = UChar_Type[3];

for(i = 0; i < 3; i++)
{
	lane_packer_statusTags[i] = i;
}

Group("lane_packer_status", "DECTAG", lane_packer_statusTags);

for(i = 0; i < 3; i++)
{

	Register("lane_packer_status", 0x450 + i*0x4, 4, "lane_packer_status*", "lane_packer_status", i, "null");
		Field("fifo_underrun", 1, 1, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("fifo_overrun", 0, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
}

Register("debug", 0x45c, 4, "null");
		Field("manual_calib_en", 31, 31, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("load_taps", 30, 30, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
		Field("tap_lane_5", 29, 25, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("tap_lane_4", 24, 20, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("tap_lane_3", 19, 15, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("tap_lane_2", 14, 10, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("tap_lane_1", 9, 5, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("tap_lane_0", 4, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");


