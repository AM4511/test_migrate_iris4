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
		Field("major", 23, 16, "rd", 0x0, 0x1, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("minor", 15, 8, "rd", 0x0, 0x5, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("hw", 7, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");

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

Register("fstart", 0x74, 4, "Initial Grab Address Register ");
		Field("value", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "INitial GRAb ADDRess Register");

Register("fstart_high", 0x78, 4, "Initial Grab Address Register HI 32 bits");
		Field("value", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "INitial GRAb ADDRess Register High");

Register("fstart_g", 0x7c, 4, "Green Grab Address Register ");
		Field("value", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "GRAb ADDRess Register");

Register("fstart_g_high", 0x80, 4, "Green Grab Address Register HIGH 32 bits");
		Field("value", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "GRAb ADDRess Register High");

Register("fstart_r", 0x84, 4, "Red Grab Address Register ");
		Field("value", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "GRAb ADDRess Register");

Register("fstart_r_high", 0x88, 4, "Red Grab Address Register HIGH 32 bits");
		Field("value", 31, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "GRAb ADDRess Register High");

Register("line_pitch", 0x8c, 4, "Grab Line Pitch Register");
		Field("value", 15, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Grab LinePitch");

Register("line_size", 0x90, 4, "Host Line Size Register");
		Field("value", 13, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Host Line size");
			FieldValue("Auto-compute line size from sensor data.", 0);

Register("csc", 0x94, 4, "null");
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
		Field("slope_cfg", 25, 24, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "Multiple SLOPE integration ConFiGuration");
			FieldValue("RESERVED", 0);
			FieldValue("Single slope mode (default mode)", 1);
			FieldValue("Dual slope mode", 2);
			FieldValue("Triple slope mode", 3);
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
			FieldValue("RESERVED", 5);
			FieldValue("RESERVED", 6);
			FieldValue("RESERVED", 7);
		Field("trigger_src", 9, 8, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "TRIGGER SouRCe");
			FieldValue("RESERVED", 0);
			FieldValue("Immediate mode (Continuous)", 1);
			FieldValue("Hardware Snapshop mode", 2);
			FieldValue("Software Snapshot mode", 3);
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
		Field("rot_length", 25, 16, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "Row Overhead Time LENGTH");
		Field("fot_length", 15, 0, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "Frame Overhead Time LENGTH");

Register("readout_cfg2", 0x118, 4, "null");
		Field("readout_en", 28, 28, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "READOUT ENable");
			FieldValue("Disable readout", 0);
			FieldValue("Enable readout ", 1);
		Field("readout_length", 23, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("readout_cfg3", 0x120, 4, "null");
		Field("bl_lines", 7, 0, "rd", 0x0, 0x2, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "BLack LINES");

Register("exp_ctrl1", 0x128, 4, "null");
		Field("exposure_lev_mode", 28, 28, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "EXPOSURE LEVel MODE");
			FieldValue("Timed Mode", 0);
			FieldValue("Trigger Width", 1);
		Field("exposure_ss", 27, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "EXPOSURE Single Slope");

Register("exp_ctrl2", 0x130, 4, "null");
		Field("exposure_ds", 27, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "EXPOSURE Dual Slope");

Register("exp_ctrl3", 0x138, 4, "null");
		Field("exposure_ts", 27, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "EXPOSURE Tripple Slope");

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
		Field("strobe_b_en", 29, 29, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "STROBE phase B ENable");
			FieldValue("Enable Strobe B", 0);
			FieldValue("Disable Strobe B", 1);
		Field("strobe_a_en", 28, 28, "rd", 0x0, 0x1, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "STROBE phase A ENable");
			FieldValue("Enable Strobe A (default strobe)", 0);
			FieldValue("Disable Strobe A", 1);
		Field("strobe_end", 27, 0, "rd|wr", 0x0, 0xfffffff, 0xffffffff, 0xffffffff, TEST, 0, 0, "STROBE END");

Register("acq_ser_ctrl", 0x158, 4, "Acquisition Serial Control");
		Field("ser_roi_update", 20, 20, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("ser_blackcal_update", 19, 19, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("ser_gain_update", 18, 18, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("ser_subbin_update", 17, 17, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("ser_wrn", 16, 16, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "SERial Write/Readn");
			FieldValue("Read access", 0);
			FieldValue("Write access", 1);
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
		Field("ser_add", 8, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "SERial interface ADDress");

Register("acq_ser_stat", 0x168, 4, "Serial Interface Data");
		Field("ser_fifo_empty", 24, 24, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "SERial FIFO EMPTY");
		Field("ser_busy", 16, 16, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "SERial BUSY");
			FieldValue("FIFO read logic is idle", 0);
			FieldValue("FIFO read logic is runnning", 1);
		Field("ser_dat_r", 15, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "SERial interface DATa Read");

Register("lvds_ctrl", 0x170, 4, "null");
		Field("lvds_bit_rate", 31, 16, "rd|wr", 0x0, 0x720, 0xffffffff, 0xffffffff, TEST, 0, 0, "LVDS BIT RATE selector");
		Field("lvds_mode", 12, 12, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("LVDS10", 0);
			FieldValue("LVDS8", 1);
		Field("lvds_ser_factor", 11, 8, "rd|wr", 0x0, 0xa, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("lvds_ch", 7, 4, "rd|wr", 0x0, 0x4, 0xffffffff, 0xffffffff, TEST, 0, 0, "LVDS CHannels ");
			FieldValue("1 LVDS channel", 1);
			FieldValue("2 LVDS channels", 2);
			FieldValue("4 LVDS Channels", 4);
			FieldValue("8 LVDS Channels", 8);
		Field("lvds_start_calib", 1, 1, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "LVDS START CALIBration");
			FieldValue("Idle", 0);
			FieldValue("Perform a LVDS calibration", 1);
		Field("lvds_sys_reset", 0, 0, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "LVDS SYStem LVDS RESET");
			FieldValue("LVDS not in reset state", 0);
			FieldValue("LVDS module reset", 1);

Register("lvds_ctrl2", 0x178, 4, "null");
		Field("remap_mode_supp", 23, 16, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "REMAPer MODE SUPPorted");
			FieldValue("P1300 x4 supported", 1);
			FieldValue("P1300 x1 supported", 2);
			FieldValue("P5000 x4 supported", 4);
			FieldValue("P5000 x1 supported", 8);
			FieldValue("P5000 x8 supported", 16);
			FieldValue("P5000 x2 supported", 32);
			FieldValue("P1300 x2 supported", 64);
			FieldValue("Not implemented yet", 128);
		Field("lvds_decod_en", 4, 4, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Decoder Disable", 0);
			FieldValue("Decoder Enable", 1);
		Field("lvds_decod_remap_mode", 2, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Python 1300, 4x LVDS", 0);
			FieldValue("Python 1300, 1x LVDS", 1);
			FieldValue("Python 5000, 4x LVDS", 2);
			FieldValue("Python 5000, 1x LVDS", 3);
			FieldValue("Python 5000, 8x LVDS", 4);
			FieldValue("Python 5000, 2x LVDS", 5);
			FieldValue("Python 1300, 2x LVDS", 6);

Register("lvds_training", 0x180, 4, "null");
		Field("data_training", 25, 16, "rd|wr", 0x0, 0x3a6, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("crtl_training", 9, 0, "rd|wr", 0x0, 0x3a6, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("lvds_stat", 0x188, 4, "null");
		Field("idelay_rdy", 29, 29, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Input DELAY ReaDY");
			FieldValue("IDELAYE2 module not calibrated", 0);
			FieldValue("IDELAYE2 module calibrated", 1);
		Field("lvds_rdy", 28, 28, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "LVDS ReaDY");
			FieldValue("LVDS module not ready to calibration", 0);
			FieldValue("LVDS module ready to calibration", 1);
		Field("lvds_calib_ok", 25, 25, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "LVDS CALIBration OK");
			FieldValue("Calibration sequence fail", 0);
			FieldValue("Calibration sequence success", 1);
		Field("lvds_calib_act", 24, 24, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "LVDS CALIBration ACTivate");
			FieldValue("Calibration is idle", 0);
			FieldValue("Calibration is active", 1);
		Field("bs_done_stat", 21, 21, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "BitSlip DONE STATus");
			FieldValue("BitSlip sequence in progress", 0);
			FieldValue("BitSlip sequence finish", 1);
		Field("bs_ch_lock_stat", 20, 12, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "BitSlip CHannel LOCK STATus");
		Field("pd_done_stat", 9, 9, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
		Field("pd_ch_lock_stat", 8, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Phase Detect LOCK STATus");

Register("lvds_stat2", 0x18c, 4, "null");
		Field("word_align", 31, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Word ALIGnement");

Register("sensor_ctrl", 0x190, 4, "SENSOR ConTRoL");
		Field("sensor_refresh_temp", 24, 24, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "SENSOR REFRESH TEMPerature");
			FieldValue("Idle", 0);
			FieldValue("Starts a Temperature read on Python SPI interface", 1);
		Field("sensor_powerdown", 16, 16, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
		Field("sensor_remap_cfg", 13, 12, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "SENSOR REMAPing ConFiGuration");
			FieldValue("", 0);
			FieldValue("Black data disabled, Valid data enabled", 1);
			FieldValue("", 2);
			FieldValue("", 3);
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
		Field("sensor_vccpix_pg", 10, 10, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "SENSOR supply PIX VCC  Power Good");
			FieldValue("Disable", 0);
			FieldValue("Enable", 1);
		Field("sensor_vcc33_pg", 9, 9, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "SENSOR supply 3.3 VCC  Power Good");
			FieldValue("Disable", 0);
			FieldValue("Enable", 1);
		Field("sensor_vcc18_pg", 8, 8, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "SENSOR supply 1.8 VCC Power Good");
			FieldValue("Disable", 0);
			FieldValue("Enable", 1);
		Field("sensor_vccpix_en", 6, 6, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "SENSOR supply PIX VCC ENable");
			FieldValue("Disable", 0);
			FieldValue("Enable", 1);
		Field("sensor_vcc33_en", 5, 5, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "SENSOR supply 3.3 VCC ENable");
			FieldValue("Disable", 0);
			FieldValue("Enable", 1);
		Field("sensor_vcc18_en", 4, 4, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "SENSOR supply 1.8 VCC ENable");
			FieldValue("Disable", 0);
			FieldValue("Enable", 1);
		Field("sensor_powerup_stat", 1, 1, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("PowerUp sequence fail", 0);
			FieldValue("PowerUp sequence success", 1);
		Field("sensor_powerup_done", 0, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("PowerUp sequence not started", 0);
			FieldValue("PowerUp sequence finish", 1);

Register("sensor_gen_cfg", 0x1a0, 4, "null");
		Field("reserved_1", 15, 9, "rd|wr", 0x0, 0x4, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("binning", 8, 8, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "BINNING enable");
			FieldValue("No binning", 0);
			FieldValue("Binning", 1);
		Field("subsampling", 7, 7, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "SUBSAMPLING enable");
			FieldValue("No subsampling", 0);
			FieldValue("Subsampling", 1);
		Field("nzrot_xsm_delay_enable", 6, 6, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "NZROT XSM DELAY ENABLE");
			FieldValue("Don't insert delai", 0);
			FieldValue("Insert delay defined by register nzrot_xsm_delay", 1);
		Field("slave_mode", 5, 5, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "SLAVE MODE");
			FieldValue("Master", 0);
			FieldValue("Slave", 1);
		Field("triggered_mode", 4, 4, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "TRIGGERED MODE");
			FieldValue("Normal mode", 0);
			FieldValue("Triggered mode", 1);
		Field("xlag_enable", 3, 3, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Xlag OFF", 0);
			FieldValue("Xlag ON", 1);
		Field("zero_rot_enable", 2, 2, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "ZERO ROT ENABLE");
			FieldValue("Idle", 0);
			FieldValue("Enable", 1);
		Field("rolling_shutter", 1, 1, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "ROLLING SHUTTER");
			FieldValue("Rolling shutter disable", 0);
			FieldValue("Rolling shutter enable(non supported)", 1);
		Field("enable", 0, 0, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "Sequencer ENABLE");
			FieldValue("Idle", 0);
			FieldValue("Enable", 1);

Register("sensor_int_ctl", 0x1a8, 4, "null");
		Field("reserved_2", 15, 14, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("binning_mode", 13, 12, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "BINNING MODE");
			FieldValue("Binning in x and y (VITA compatible)", 0);
			FieldValue("Binning in x, not y ", 1);
			FieldValue("Binning in y, not x", 2);
			FieldValue("Binning in x and y", 3);
		Field("subsampling_mode", 11, 10, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "SUBSAMPLING MODE");
			FieldValue("Subsampling in x and y (VITA compatible)", 0);
			FieldValue("Subsampling in x, not y ", 1);
			FieldValue("Subsampling in y, not in x", 2);
			FieldValue("Subsampling in x and y ", 3);
		Field("reserved1", 9, 9, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("reserved0", 7, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("sensor_gain_ana", 0x1b0, 4, "null");
		Field("reserved", 15, 13, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("afe_gain0", 12, 5, "rd|wr", 0x0, 0xf, 0xffffffff, 0xffffffff, TEST, 0, 0, "AFE GAIN");
		Field("mux_gainsw0", 4, 0, "rd|wr", 0x0, 0x3, 0xffffffff, 0xffffffff, TEST, 0, 0, "Column MUX GAIN");

Register("sensor_black_cal", 0x1b8, 4, "null");
		Field("crc_seed", 15, 15, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("reserved", 14, 11, "rd|wr", 0x0, 0x8, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("black_samples", 10, 8, "rd", 0x0, 0x7, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("black_offset", 7, 0, "rd|wr", 0x0, 0xf, 0xffffffff, 0xffffffff, TEST, 0, 0, "BLACK OFFSET");

Register("sensor_roi_conf0", 0x1c0, 4, "null");
		Field("x_end_msb", 24, 24, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "X END");
		Field("x_start_msb", 16, 16, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "X START MSB ");
		Field("x_end", 15, 8, "rd|wr", 0x0, 0x9f, 0xffffffff, 0xffffffff, TEST, 0, 0, "X END");
		Field("x_start", 7, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "X START");

Register("sensor_roi2_conf0", 0x1c4, 4, "null");
		Field("x_end_msb", 24, 24, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "X END");
		Field("x_start_msb", 16, 16, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "X START MSB ");
		Field("x_end", 15, 8, "rd|wr", 0x0, 0x9f, 0xffffffff, 0xffffffff, TEST, 0, 0, "X END");
		Field("x_start", 7, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "X START");

Register("sensor_roi_conf1", 0x1c8, 4, "null");
		Field("reserved", 15, 13, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("y_start", 12, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Y START");

Register("sensor_roi2_conf1", 0x1cc, 4, "null");
		Field("reserved", 15, 13, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("y_start", 12, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Y START");

Register("sensor_roi_conf2", 0x1d0, 4, "null");
		Field("reserved", 15, 13, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("y_end", 12, 0, "rd|wr", 0x0, 0x3ff, 0xffffffff, 0xffffffff, TEST, 0, 0, "Y END");

Register("sensor_roi2_conf2", 0x1d4, 4, "null");
		Field("reserved", 15, 13, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");
		Field("y_end", 12, 0, "rd|wr", 0x0, 0x3ff, 0xffffffff, 0xffffffff, TEST, 0, 0, "Y END");

Register("crc", 0x1d8, 4, "null");
		Field("crc_initvalue", 18, 18, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("crc_reset", 17, 17, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
		Field("crc_en", 16, 16, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "CRC ENable");
		Field("crc_status", 7, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("NO ERROR", 0);
			FieldValue("CRC ERROR", 1);

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

Register("debug", 0x220, 4, "null");
		Field("debug_rst_cntr", 28, 28, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("", 0);
			FieldValue("Reset counters", 1);
		Field("test_mode_pix_start", 25, 16, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("test_move", 9, 9, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Static test ramp", 0);
			FieldValue("The test ramp moves", 1);
		Field("test_mode", 8, 8, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Normal acquisition data from sensor", 0);
			FieldValue("Test mode, a ramp is generated.", 1);
		Field("led_test_color", 2, 1, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("The LED is OFF", 0);
			FieldValue("The LED is GREEN", 1);
			FieldValue("The LED is RED", 2);
			FieldValue("The LED is ORANGE", 3);
		Field("led_test", 0, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("The LED is in user mode.", 0);
			FieldValue("The LED is in test mode.", 1);

Register("debug_cntr1", 0x228, 4, "null");
		Field("eof_cntr", 31, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");

Register("debug_cntr2", 0x230, 4, "null");
		Field("eol_cntr", 11, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");

Register("debug_cntr3", 0x234, 4, "null");
		Field("sensor_frame_duration", 27, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");

Register("exp_fot", 0x23c, 4, "null");
		Field("exp_fot", 16, 16, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "EXPosure during FOT");
			FieldValue("Disable exposure during FOT in output exposure signal and Strobe", 0);
			FieldValue("Enable exposure during FOT in output exposure signal and Strobe", 1);
		Field("exp_fot_time", 11, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "EXPosure during FOT TIME");

Register("acq_sfnc", 0x244, 4, "null");
		Field("reload_grab_params", 0, 0, "rd|wr", 0x0, 0x1, 0x0, 0x0, NO_TEST, 0, 0, "");
			FieldValue("", 0);
			FieldValue("", 1);

Register("nopel", 0x254, 4, "NOise Peak ELimination adaptative filter with threshold");
		Field("nopel_fifo_underrun", 25, 25, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "NOPEL FIFO UNDERRUN");
			FieldValue("Underrun not detected", 0);
			FieldValue("Underrun detected", 1);
		Field("nopel_fifo_overrun", 24, 24, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("Overrun not detected", 0);
			FieldValue("Overrun detected", 1);
		Field("nopel_fifo_rst", 20, 20, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "NOPEL FIFO RESET");
			FieldValue("Fifo in normal operation", 0);
			FieldValue("Fifo in reset State", 1);
		Field("nopel_bypass", 17, 17, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "NOPEL BYPASS");
			FieldValue("Nopel MIN-MAX used", 0);
			FieldValue("Nopel MIN-MAX bypass, send current pixel", 1);
		Field("nopel_enable", 16, 16, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Nopel filter bypassed", 0);
			FieldValue("Nopel filter used", 1);
		Field("nopel_threshold", 7, 0, "rd|wr", 0x0, 0x10, 0xffffffff, 0xffffffff, TEST, 0, 0, "NOPEL THRESHOLD");

%=================================================================
% SECTION NAME	: DATA
%=================================================================
Section("DATA", 0, 0x300);

Register("lut_ctrl", 0x300, 4, "null");
		Field("lut_bypass", 31, 31, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "LUT BYPASS");
			FieldValue("Use LUT logic.", 0);
			FieldValue("LUT logic bypass.", 1);
		Field("lut_palette_use", 29, 29, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "LUT PALETTE to USE");
			FieldValue("Palette 0 is used", 0);
			FieldValue("Palette 1 is used", 1);
		Field("lut_palette_w", 28, 28, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "LUT PALETTE to Write");
			FieldValue("Write Palette 0", 0);
			FieldValue("Write Palette 1", 1);
		Field("lut_data_w", 25, 16, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "LUT DATA to Write");
		Field("lut_sel", 14, 12, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "LUT SELection");
			FieldValue("Read or Write to Gamma / Mono0 LUT", 0);
			FieldValue("Read or write to Blue / Mono1 LUT", 1);
			FieldValue("Read or write to Green / Mono2 LUT ", 2);
			FieldValue("Read or write to Red / Mono3   LUT", 3);
			FieldValue("Write ALL LUT with same data.", 4);
			FieldValue("", 5);
			FieldValue("", 6);
			FieldValue("", 7);
		Field("lut_wrn", 11, 11, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "LUT Write ReadNot");
			FieldValue("Read operation", 0);
			FieldValue("Write operation", 1);
		Field("lut_ss", 10, 10, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "LUT SnapShot");
		Field("lut_add", 9, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("lut_rb", 0x308, 4, "");
		Field("lut_rb", 9, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");

Register("wb_mult1", 0x310, 4, "null");
		Field("wb_mult_g", 31, 16, "rd|wr", 0x0, 0x1000, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("wb_mult_b", 15, 0, "rd|wr", 0x0, 0x1000, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("wb_mult2", 0x318, 4, "null");
		Field("wb_mult_r", 15, 0, "rd|wr", 0x0, 0x1000, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("wb_b_acc", 0x320, 4, "null");
		Field("b_acc", 30, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");

Register("wb_g_acc", 0x328, 4, "null");
		Field("g_acc", 31, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");

Register("wb_r_acc", 0x330, 4, "null");
		Field("r_acc", 30, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");

Register("fpn_add", 0x338, 4, "null");
		Field("fpn_73", 31, 31, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Use normal fpn mode 5.3 ", 0);
			FieldValue("Use advanced fpn mode 7.3", 1);
		Field("fpn_we", 28, 28, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "FPN Write Enable");
			FieldValue("Read operation", 0);
			FieldValue("Write operation", 1);
		Field("fpn_en", 24, 24, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "FPN ENable");
			FieldValue("HW correction disable", 0);
			FieldValue("HW correction enable", 1);
		Field("fpn_ss", 16, 16, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "FPN SnapShot");
			FieldValue("Nothing", 0);
			FieldValue("Snapshot", 1);
		Field("fpn_add", 9, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "FPN ADDress");

Register("fpn_read_reg", 0x33c, 4, "null");
		Field("fpn_read_pix_sel", 30, 28, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("fpn_read_prnu", 24, 16, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
		Field("fpn_read_fpn", 10, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");

variable fpn_dataTags = UChar_Type[8];

for(i = 0; i < 8; i++)
{
	fpn_dataTags[i] = i;
}

Group("fpn_data", "DECTAG", fpn_dataTags);

for(i = 0; i < 8; i++)
{

	Register("fpn_data", 0x340 + i*0x4, 4, "fpn_data*", "fpn_data", i, "null");
		Field("fpn_data_prnu", 24, 16, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "FPN DATA PRNU");
		Field("fpn_data_fpn", 10, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "FPN DATA FPN");
}

Register("fpn_contrast", 0x360, 4, "null");
		Field("contrast_gain", 27, 16, "rd|wr", 0x0, 0x100, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("contrast_offset", 7, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "CONTRAST OFFSET");

Register("fpn_acc_add", 0x368, 4, "null");
		Field("fpn_acc_mode_sel", 21, 21, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Don't use Contrast Gain and Offset", 0);
			FieldValue("Use Contrast Gain and Offset", 1);
		Field("fpn_acc_mode_en", 20, 20, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "FPN ACCumulator MODE ENable");
			FieldValue("Normal DMA transfert mode", 0);
			FieldValue("Accumulator mode", 1);
		Field("fpn_acc_r_ss", 16, 16, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "FPN ACCumulator Read Snapshot");
		Field("fpn_acc_add", 11, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "FPN ACCumulator ADDress");

Register("fpn_acc_data", 0x370, 4, "null");
		Field("fpn_acc_r_working", 24, 24, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "FPN ACCumulator Read WORKING");
			FieldValue("The data in the field FPN_ACC_DATA is valid", 0);
			FieldValue("The data in the field FPN_ACC_DATA is invalid", 1);
		Field("fpn_acc_data", 23, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "FPN ACCumulator DATA");

Register("dpc_list_ctrl", 0x380, 4, "null");
		Field("dpc_fifo_underrun", 31, 31, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("Underrun not detected", 0);
			FieldValue("Underrun detected", 1);
		Field("dpc_fifo_overrun", 30, 30, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("Overrun not detected", 0);
			FieldValue("Overrun detected", 1);
		Field("dpc_fifo_reset", 28, 28, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Fifo in normal operation", 0);
			FieldValue("Fifo in reset State", 1);
		Field("dpc_firstlast_line_rem", 26, 26, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Do not remove any lines of the image received", 0);
			FieldValue("Remove first and last line of the image received", 1);
		Field("dpc_pattern0_cfg", 25, 25, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Do not correct current pixel", 0);
			FieldValue("Replace current pixel by a white pixel (0x3ff)", 1);
		Field("dpc_enable", 24, 24, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("DPC logic is bypassed", 0);
			FieldValue("PDC  logic is enable", 1);
		Field("dpc_list_count", 21, 16, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("dpc_list_wrn", 12, 12, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
			FieldValue("Read list operation", 0);
			FieldValue("Write list operation", 1);
		Field("dpc_list_ss", 8, 8, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("Do nothing", 0);
			FieldValue("Start the READ/WRITE transaction", 1);
		Field("dpc_list_add", 5, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("dpc_list_data", 0x384, 4, "null");
		Field("dpc_list_corr_pattern", 31, 24, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("dpc_list_corr_y", 23, 12, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("dpc_list_corr_x", 11, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");

Register("dpc_list_data_rd", 0x388, 4, "null");
		Field("dpc_list_corr_pattern", 31, 24, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
		Field("dpc_list_corr_y", 23, 12, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
		Field("dpc_list_corr_x", 11, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");

%=================================================================
% SECTION NAME	: HISPI
%=================================================================
Section("HISPI", 0, 0x400);

Register("ctrl", 0x400, 4, "null");
		Field("clr", 1, 1, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "null");
		Field("reset_idelayctrl", 0, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Reset the xilinx macro IDELAYCTRL");

Register("status", 0x404, 4, "null");
		Field("pll_locked", 0, 0, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");


