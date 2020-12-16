/*****************************************************************************
 ** File                : regfile_xgs_athena.sv
 ** Project             : FDK
 ** Module              : <MODULENAME>
 ** Created on          : 2020/12/16 10:23:48
 ** Created by          : <USERNAME>
 ** FDK IDE Version     : 4.7.0_beta4
 ** Build ID            : I20201209-1553
 ** Register file CRC32 : 0x<CRC32>
 **
 **  COPYRIGHT (c) 2020 Matrox Electronic Systems Ltd.
 **  All Rights Reserved
 **
 *****************************************************************************/
package regfile_xgs_athena_pkg;
	import fdkide_pkg::*;
	
	
class Creg_system_tag extends Cregister;
   Cfield VALUE;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.VALUE = new(this, "VALUE", RO, 23, 0, 'h58544d);
   endfunction

endclass


class Creg_system_version extends Cregister;
   Cfield MAJOR;
   Cfield MINOR;
   Cfield HW;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.MAJOR = new(this, "MAJOR", RO, 23, 16, 'ha);
      this.MINOR = new(this, "MINOR", RO, 15, 8, 'h2);
      this.HW = new(this, "HW", RO, 7, 0, 'h3);
   endfunction

endclass


class Creg_system_capability extends Cregister;
   Cfield VALUE;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.VALUE = new(this, "VALUE", RO, 7, 0, 'h0);
   endfunction

endclass


class Creg_system_scratchpad extends Cregister;
   Cfield VALUE;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.VALUE = new(this, "VALUE", RW, 31, 0, 'h0);
   endfunction

endclass


class Csec_system extends Csection;
       Creg_system_tag TAG;
       Creg_system_version VERSION;
       Creg_system_capability CAPABILITY;
       Creg_system_scratchpad SCRATCHPAD;
   

   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.TAG = new(this, "TAG",'h0);
      this.VERSION = new(this, "VERSION",'h4);
      this.CAPABILITY = new(this, "CAPABILITY",'h8);
      this.SCRATCHPAD = new(this, "SCRATCHPAD",'hc);
   endfunction

endclass


class Creg_dma_ctrl extends Cregister;
   Cfield GRAB_QUEUE_EN;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.GRAB_QUEUE_EN = new(this, "GRAB_QUEUE_EN", RW, 0, 0, 'h0);
   endfunction

endclass


class Creg_dma_fstart extends Cregister;
   Cfield VALUE;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.VALUE = new(this, "VALUE", RW, 31, 0, 'h0);
   endfunction

endclass


class Creg_dma_fstart_high extends Cregister;
   Cfield VALUE;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.VALUE = new(this, "VALUE", RW, 31, 0, 'h0);
   endfunction

endclass


class Creg_dma_fstart_g extends Cregister;
   Cfield VALUE;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.VALUE = new(this, "VALUE", RW, 31, 0, 'h0);
   endfunction

endclass


class Creg_dma_fstart_g_high extends Cregister;
   Cfield VALUE;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.VALUE = new(this, "VALUE", RW, 31, 0, 'h0);
   endfunction

endclass


class Creg_dma_fstart_r extends Cregister;
   Cfield VALUE;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.VALUE = new(this, "VALUE", RW, 31, 0, 'h0);
   endfunction

endclass


class Creg_dma_fstart_r_high extends Cregister;
   Cfield VALUE;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.VALUE = new(this, "VALUE", RW, 31, 0, 'h0);
   endfunction

endclass


class Creg_dma_line_pitch extends Cregister;
   Cfield VALUE;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.VALUE = new(this, "VALUE", RW, 15, 0, 'h0);
   endfunction

endclass


class Creg_dma_line_size extends Cregister;
   Cfield VALUE;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.VALUE = new(this, "VALUE", RW, 13, 0, 'h0);
   endfunction

endclass


class Creg_dma_csc extends Cregister;
   Cfield COLOR_SPACE;
   Cfield DUP_LAST_LINE;
   Cfield REVERSE_Y;
   Cfield REVERSE_X;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.COLOR_SPACE = new(this, "COLOR_SPACE", RW, 26, 24, 'h0);
      this.DUP_LAST_LINE = new(this, "DUP_LAST_LINE", RW, 23, 23, 'h0);
      this.REVERSE_Y = new(this, "REVERSE_Y", RW, 9, 9, 'h0);
      this.REVERSE_X = new(this, "REVERSE_X", RW, 8, 8, 'h0);
   endfunction

endclass


class Creg_dma_output_buffer extends Cregister;
   Cfield MAX_LINE_BUFF_CNT;
   Cfield LINE_PTR_WIDTH;
   Cfield ADDRESS_BUS_WIDTH;
   Cfield PCIE_BACK_PRESSURE;
   Cfield CLR_MAX_LINE_BUFF_CNT;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.MAX_LINE_BUFF_CNT = new(this, "MAX_LINE_BUFF_CNT", RO, 31, 28, 'h0);
      this.LINE_PTR_WIDTH = new(this, "LINE_PTR_WIDTH", RW, 25, 24, 'h2);
      this.ADDRESS_BUS_WIDTH = new(this, "ADDRESS_BUS_WIDTH", RO, 23, 20, 'h0);
      this.PCIE_BACK_PRESSURE = new(this, "PCIE_BACK_PRESSURE", RW2C, 4, 4, 'h0);
      this.CLR_MAX_LINE_BUFF_CNT = new(this, "CLR_MAX_LINE_BUFF_CNT", WO, 0, 0, 'h0);
   endfunction

endclass


class Creg_dma_tlp extends Cregister;
   Cfield MAX_PAYLOAD;
   Cfield BUS_MASTER_EN;
   Cfield CFG_MAX_PLD;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.MAX_PAYLOAD = new(this, "MAX_PAYLOAD", RO, 27, 16, 'h0);
      this.BUS_MASTER_EN = new(this, "BUS_MASTER_EN", RO, 3, 3, 'h0);
      this.CFG_MAX_PLD = new(this, "CFG_MAX_PLD", RO, 2, 0, 'h0);
   endfunction

endclass


class Csec_dma extends Csection;
       Creg_dma_ctrl CTRL;
       Creg_dma_fstart FSTART;
       Creg_dma_fstart_high FSTART_HIGH;
       Creg_dma_fstart_g FSTART_G;
       Creg_dma_fstart_g_high FSTART_G_HIGH;
       Creg_dma_fstart_r FSTART_R;
       Creg_dma_fstart_r_high FSTART_R_HIGH;
       Creg_dma_line_pitch LINE_PITCH;
       Creg_dma_line_size LINE_SIZE;
       Creg_dma_csc CSC;
       Creg_dma_output_buffer OUTPUT_BUFFER;
       Creg_dma_tlp TLP;
   

   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.CTRL = new(this, "CTRL",'h0);
      this.FSTART = new(this, "FSTART",'h8);
      this.FSTART_HIGH = new(this, "FSTART_HIGH",'hc);
      this.FSTART_G = new(this, "FSTART_G",'h10);
      this.FSTART_G_HIGH = new(this, "FSTART_G_HIGH",'h14);
      this.FSTART_R = new(this, "FSTART_R",'h18);
      this.FSTART_R_HIGH = new(this, "FSTART_R_HIGH",'h1c);
      this.LINE_PITCH = new(this, "LINE_PITCH",'h20);
      this.LINE_SIZE = new(this, "LINE_SIZE",'h24);
      this.CSC = new(this, "CSC",'h28);
      this.OUTPUT_BUFFER = new(this, "OUTPUT_BUFFER",'h38);
      this.TLP = new(this, "TLP",'h3c);
   endfunction

endclass


class Creg_acq_grab_ctrl extends Cregister;
   Cfield RESET_GRAB;
   Cfield GRAB_ROI2_EN;
   Cfield ABORT_GRAB;
   Cfield TRIGGER_OVERLAP_BUFFn;
   Cfield TRIGGER_OVERLAP;
   Cfield TRIGGER_ACT;
   Cfield TRIGGER_SRC;
   Cfield GRAB_SS;
   Cfield BUFFER_ID;
   Cfield GRAB_CMD;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.RESET_GRAB = new(this, "RESET_GRAB", RW, 31, 31, 'h0);
      this.GRAB_ROI2_EN = new(this, "GRAB_ROI2_EN", RW, 29, 29, 'h0);
      this.ABORT_GRAB = new(this, "ABORT_GRAB", WO, 28, 28, 'h0);
      this.TRIGGER_OVERLAP_BUFFn = new(this, "TRIGGER_OVERLAP_BUFFn", RW, 16, 16, 'h0);
      this.TRIGGER_OVERLAP = new(this, "TRIGGER_OVERLAP", RW, 15, 15, 'h1);
      this.TRIGGER_ACT = new(this, "TRIGGER_ACT", RW, 14, 12, 'h0);
      this.TRIGGER_SRC = new(this, "TRIGGER_SRC", RW, 10, 8, 'h0);
      this.GRAB_SS = new(this, "GRAB_SS", WO, 4, 4, 'h0);
      this.BUFFER_ID = new(this, "BUFFER_ID", RW, 1, 1, 'h0);
      this.GRAB_CMD = new(this, "GRAB_CMD", WO, 0, 0, 'h0);
   endfunction

endclass


class Creg_acq_grab_stat extends Cregister;
   Cfield GRAB_CMD_DONE;
   Cfield ABORT_PET;
   Cfield ABORT_DELAI;
   Cfield ABORT_DONE;
   Cfield TRIGGER_RDY;
   Cfield ABORT_MNGR_STAT;
   Cfield TRIG_MNGR_STAT;
   Cfield TIMER_MNGR_STAT;
   Cfield GRAB_MNGR_STAT;
   Cfield GRAB_FOT;
   Cfield GRAB_READOUT;
   Cfield GRAB_EXPOSURE;
   Cfield GRAB_PENDING;
   Cfield GRAB_ACTIVE;
   Cfield GRAB_IDLE;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.GRAB_CMD_DONE = new(this, "GRAB_CMD_DONE", RO, 31, 31, 'h0);
      this.ABORT_PET = new(this, "ABORT_PET", RO, 30, 30, 'h0);
      this.ABORT_DELAI = new(this, "ABORT_DELAI", RO, 29, 29, 'h0);
      this.ABORT_DONE = new(this, "ABORT_DONE", RO, 28, 28, 'h0);
      this.TRIGGER_RDY = new(this, "TRIGGER_RDY", RO, 24, 24, 'h0);
      this.ABORT_MNGR_STAT = new(this, "ABORT_MNGR_STAT", RO, 22, 20, 'h0);
      this.TRIG_MNGR_STAT = new(this, "TRIG_MNGR_STAT", RO, 19, 16, 'h0);
      this.TIMER_MNGR_STAT = new(this, "TIMER_MNGR_STAT", RO, 14, 12, 'h0);
      this.GRAB_MNGR_STAT = new(this, "GRAB_MNGR_STAT", RO, 11, 8, 'h0);
      this.GRAB_FOT = new(this, "GRAB_FOT", RO, 6, 6, 'h0);
      this.GRAB_READOUT = new(this, "GRAB_READOUT", RO, 5, 5, 'h0);
      this.GRAB_EXPOSURE = new(this, "GRAB_EXPOSURE", RO, 4, 4, 'h0);
      this.GRAB_PENDING = new(this, "GRAB_PENDING", RO, 2, 2, 'h0);
      this.GRAB_ACTIVE = new(this, "GRAB_ACTIVE", RO, 1, 1, 'h0);
      this.GRAB_IDLE = new(this, "GRAB_IDLE", RO, 0, 0, 'h0);
   endfunction

endclass


class Creg_acq_readout_cfg1 extends Cregister;
   Cfield FOT_LENGTH_LINE;
   Cfield EO_FOT_SEL;
   Cfield FOT_LENGTH;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.FOT_LENGTH_LINE = new(this, "FOT_LENGTH_LINE", RW, 28, 24, 'h0);
      this.EO_FOT_SEL = new(this, "EO_FOT_SEL", RW, 16, 16, 'h0);
      this.FOT_LENGTH = new(this, "FOT_LENGTH", RW, 15, 0, 'h0);
   endfunction

endclass


class Creg_acq_readout_cfg_frame_line extends Cregister;
   Cfield DUMMY_LINES;
   Cfield CURR_FRAME_LINES;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.DUMMY_LINES = new(this, "DUMMY_LINES", RW, 23, 16, 'h0);
      this.CURR_FRAME_LINES = new(this, "CURR_FRAME_LINES", RO, 12, 0, 'h0);
   endfunction

endclass


class Creg_acq_readout_cfg2 extends Cregister;
   Cfield READOUT_LENGTH;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.READOUT_LENGTH = new(this, "READOUT_LENGTH", RO, 28, 0, 'h0);
   endfunction

endclass


class Creg_acq_readout_cfg3 extends Cregister;
   Cfield LINE_TIME;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.LINE_TIME = new(this, "LINE_TIME", RW, 15, 0, 'h16e);
   endfunction

endclass


class Creg_acq_readout_cfg4 extends Cregister;
   Cfield KEEP_OUT_TRIG_ENA;
   Cfield KEEP_OUT_TRIG_START;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.KEEP_OUT_TRIG_ENA = new(this, "KEEP_OUT_TRIG_ENA", RW, 16, 16, 'h0);
      this.KEEP_OUT_TRIG_START = new(this, "KEEP_OUT_TRIG_START", RW, 15, 0, 'hffff);
   endfunction

endclass


class Creg_acq_exp_ctrl1 extends Cregister;
   Cfield EXPOSURE_LEV_MODE;
   Cfield EXPOSURE_SS;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.EXPOSURE_LEV_MODE = new(this, "EXPOSURE_LEV_MODE", RW, 28, 28, 'h0);
      this.EXPOSURE_SS = new(this, "EXPOSURE_SS", RW, 27, 0, 'h0);
   endfunction

endclass


class Creg_acq_exp_ctrl2 extends Cregister;
   Cfield EXPOSURE_DS;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.EXPOSURE_DS = new(this, "EXPOSURE_DS", RW, 27, 0, 'h0);
   endfunction

endclass


class Creg_acq_exp_ctrl3 extends Cregister;
   Cfield EXPOSURE_TS;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.EXPOSURE_TS = new(this, "EXPOSURE_TS", RW, 27, 0, 'h0);
   endfunction

endclass


class Creg_acq_trigger_delay extends Cregister;
   Cfield TRIGGER_DELAY;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.TRIGGER_DELAY = new(this, "TRIGGER_DELAY", RW, 27, 0, 'h0);
   endfunction

endclass


class Creg_acq_strobe_ctrl1 extends Cregister;
   Cfield STROBE_E;
   Cfield STROBE_POL;
   Cfield STROBE_START;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.STROBE_E = new(this, "STROBE_E", RW, 31, 31, 'h0);
      this.STROBE_POL = new(this, "STROBE_POL", RW, 28, 28, 'h0);
      this.STROBE_START = new(this, "STROBE_START", RW, 27, 0, 'h0);
   endfunction

endclass


class Creg_acq_strobe_ctrl2 extends Cregister;
   Cfield STROBE_MODE;
   Cfield STROBE_B_EN;
   Cfield STROBE_A_EN;
   Cfield STROBE_END;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.STROBE_MODE = new(this, "STROBE_MODE", RW, 31, 31, 'h0);
      this.STROBE_B_EN = new(this, "STROBE_B_EN", RW, 29, 29, 'h0);
      this.STROBE_A_EN = new(this, "STROBE_A_EN", RW, 28, 28, 'h1);
      this.STROBE_END = new(this, "STROBE_END", RW, 27, 0, 'hfffffff);
   endfunction

endclass


class Creg_acq_acq_ser_ctrl extends Cregister;
   Cfield SER_RWn;
   Cfield SER_CMD;
   Cfield SER_RF_SS;
   Cfield SER_WF_SS;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.SER_RWn = new(this, "SER_RWn", RW, 16, 16, 'h1);
      this.SER_CMD = new(this, "SER_CMD", RW, 9, 8, 'h0);
      this.SER_RF_SS = new(this, "SER_RF_SS", WO, 4, 4, 'h0);
      this.SER_WF_SS = new(this, "SER_WF_SS", WO, 0, 0, 'h0);
   endfunction

endclass


class Creg_acq_acq_ser_addata extends Cregister;
   Cfield SER_DAT;
   Cfield SER_ADD;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.SER_DAT = new(this, "SER_DAT", RW, 31, 16, 'h0);
      this.SER_ADD = new(this, "SER_ADD", RW, 14, 0, 'h0);
   endfunction

endclass


class Creg_acq_acq_ser_stat extends Cregister;
   Cfield SER_FIFO_EMPTY;
   Cfield SER_BUSY;
   Cfield SER_DAT_R;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.SER_FIFO_EMPTY = new(this, "SER_FIFO_EMPTY", RO, 24, 24, 'h0);
      this.SER_BUSY = new(this, "SER_BUSY", RO, 16, 16, 'h0);
      this.SER_DAT_R = new(this, "SER_DAT_R", RO, 15, 0, 'h0);
   endfunction

endclass


class Creg_acq_sensor_ctrl extends Cregister;
   Cfield SENSOR_REFRESH_TEMP;
   Cfield SENSOR_POWERDOWN;
   Cfield SENSOR_COLOR;
   Cfield SENSOR_REG_UPDATE;
   Cfield SENSOR_RESETN;
   Cfield SENSOR_POWERUP;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.SENSOR_REFRESH_TEMP = new(this, "SENSOR_REFRESH_TEMP", WO, 24, 24, 'h0);
      this.SENSOR_POWERDOWN = new(this, "SENSOR_POWERDOWN", WO, 16, 16, 'h0);
      this.SENSOR_COLOR = new(this, "SENSOR_COLOR", RW, 8, 8, 'h0);
      this.SENSOR_REG_UPDATE = new(this, "SENSOR_REG_UPDATE", RW, 4, 4, 'h1);
      this.SENSOR_RESETN = new(this, "SENSOR_RESETN", RW, 1, 1, 'h1);
      this.SENSOR_POWERUP = new(this, "SENSOR_POWERUP", WO, 0, 0, 'h0);
   endfunction

endclass


class Creg_acq_sensor_stat extends Cregister;
   Cfield SENSOR_TEMP;
   Cfield SENSOR_TEMP_VALID;
   Cfield SENSOR_POWERDOWN;
   Cfield SENSOR_RESETN;
   Cfield SENSOR_OSC_EN;
   Cfield SENSOR_VCC_PG;
   Cfield SENSOR_POWERUP_STAT;
   Cfield SENSOR_POWERUP_DONE;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.SENSOR_TEMP = new(this, "SENSOR_TEMP", RO, 31, 24, 'h0);
      this.SENSOR_TEMP_VALID = new(this, "SENSOR_TEMP_VALID", RO, 23, 23, 'h0);
      this.SENSOR_POWERDOWN = new(this, "SENSOR_POWERDOWN", RO, 16, 16, 'h0);
      this.SENSOR_RESETN = new(this, "SENSOR_RESETN", RO, 13, 13, 'h0);
      this.SENSOR_OSC_EN = new(this, "SENSOR_OSC_EN", RO, 12, 12, 'h0);
      this.SENSOR_VCC_PG = new(this, "SENSOR_VCC_PG", RO, 8, 8, 'h0);
      this.SENSOR_POWERUP_STAT = new(this, "SENSOR_POWERUP_STAT", RO, 1, 1, 'h0);
      this.SENSOR_POWERUP_DONE = new(this, "SENSOR_POWERUP_DONE", RO, 0, 0, 'h0);
   endfunction

endclass


class Creg_acq_sensor_subsampling extends Cregister;
   Cfield reserved1;
   Cfield ACTIVE_SUBSAMPLING_Y;
   Cfield reserved0;
   Cfield M_SUBSAMPLING_Y;
   Cfield SUBSAMPLING_X;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.reserved1 = new(this, "reserved1", RO, 15, 4, 'h0);
      this.ACTIVE_SUBSAMPLING_Y = new(this, "ACTIVE_SUBSAMPLING_Y", RW, 3, 3, 'h0);
      this.reserved0 = new(this, "reserved0", RO, 2, 2, 'h0);
      this.M_SUBSAMPLING_Y = new(this, "M_SUBSAMPLING_Y", RW, 1, 1, 'h0);
      this.SUBSAMPLING_X = new(this, "SUBSAMPLING_X", RW, 0, 0, 'h0);
   endfunction

endclass


class Creg_acq_sensor_gain_ana extends Cregister;
   Cfield reserved1;
   Cfield ANALOG_GAIN;
   Cfield reserved0;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.reserved1 = new(this, "reserved1", RO, 15, 11, 'h0);
      this.ANALOG_GAIN = new(this, "ANALOG_GAIN", RW, 10, 8, 'h1);
      this.reserved0 = new(this, "reserved0", RO, 7, 0, 'h0);
   endfunction

endclass


class Creg_acq_sensor_roi_y_start extends Cregister;
   Cfield reserved;
   Cfield Y_START;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.reserved = new(this, "reserved", RO, 15, 10, 'h0);
      this.Y_START = new(this, "Y_START", RW, 9, 0, 'h0);
   endfunction

endclass


class Creg_acq_sensor_roi_y_size extends Cregister;
   Cfield reserved;
   Cfield Y_SIZE;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.reserved = new(this, "reserved", RO, 15, 10, 'h0);
      this.Y_SIZE = new(this, "Y_SIZE", RW, 9, 0, 'h302);
   endfunction

endclass


class Creg_acq_sensor_m_lines extends Cregister;
   Cfield M_LINES_DISPLAY;
   Cfield M_SUPPRESSED;
   Cfield M_LINES_SENSOR;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.M_LINES_DISPLAY = new(this, "M_LINES_DISPLAY", RW, 15, 15, 'h0);
      this.M_SUPPRESSED = new(this, "M_SUPPRESSED", RW, 14, 10, 'h0);
      this.M_LINES_SENSOR = new(this, "M_LINES_SENSOR", RW, 9, 0, 'h8);
   endfunction

endclass


class Creg_acq_sensor_dp_gr extends Cregister;
   Cfield reserved;
   Cfield DP_OFFSET_GR;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.reserved = new(this, "reserved", RO, 15, 12, 'h0);
      this.DP_OFFSET_GR = new(this, "DP_OFFSET_GR", RW, 11, 0, 'h100);
   endfunction

endclass


class Creg_acq_sensor_dp_gb extends Cregister;
   Cfield reserved;
   Cfield DP_OFFSET_GB;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.reserved = new(this, "reserved", RO, 15, 12, 'h0);
      this.DP_OFFSET_GB = new(this, "DP_OFFSET_GB", RW, 11, 0, 'h100);
   endfunction

endclass


class Creg_acq_sensor_dp_r extends Cregister;
   Cfield reserved;
   Cfield DP_OFFSET_R;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.reserved = new(this, "reserved", RO, 15, 12, 'h0);
      this.DP_OFFSET_R = new(this, "DP_OFFSET_R", RW, 11, 0, 'h100);
   endfunction

endclass


class Creg_acq_sensor_dp_b extends Cregister;
   Cfield reserved;
   Cfield DP_OFFSET_B;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.reserved = new(this, "reserved", RO, 15, 12, 'h0);
      this.DP_OFFSET_B = new(this, "DP_OFFSET_B", RW, 11, 0, 'h100);
   endfunction

endclass


class Creg_acq_sensor_gain_dig_g extends Cregister;
   Cfield reserved1;
   Cfield DG_FACTOR_GR;
   Cfield reserved0;
   Cfield DG_FACTOR_GB;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.reserved1 = new(this, "reserved1", RO, 15, 15, 'h0);
      this.DG_FACTOR_GR = new(this, "DG_FACTOR_GR", RW, 14, 8, 'h20);
      this.reserved0 = new(this, "reserved0", RO, 7, 7, 'h0);
      this.DG_FACTOR_GB = new(this, "DG_FACTOR_GB", RW, 6, 0, 'h20);
   endfunction

endclass


class Creg_acq_sensor_gain_dig_rb extends Cregister;
   Cfield reserved1;
   Cfield DG_FACTOR_R;
   Cfield reserved0;
   Cfield DG_FACTOR_B;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.reserved1 = new(this, "reserved1", RO, 15, 15, 'h0);
      this.DG_FACTOR_R = new(this, "DG_FACTOR_R", RW, 14, 8, 'h20);
      this.reserved0 = new(this, "reserved0", RO, 7, 7, 'h0);
      this.DG_FACTOR_B = new(this, "DG_FACTOR_B", RW, 6, 0, 'h20);
   endfunction

endclass


class Creg_acq_fpga_roi_x_start extends Cregister;
   Cfield X_START;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.X_START = new(this, "X_START", RW, 12, 0, 'h0);
   endfunction

endclass


class Creg_acq_fpga_roi_x_size extends Cregister;
   Cfield X_SIZE;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.X_SIZE = new(this, "X_SIZE", RW, 12, 0, 'h0);
   endfunction

endclass


class Creg_acq_debug_pins extends Cregister;
   Cfield Debug3_sel;
   Cfield Debug2_sel;
   Cfield Debug1_sel;
   Cfield Debug0_sel;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.Debug3_sel = new(this, "Debug3_sel", RW, 28, 24, 'h1f);
      this.Debug2_sel = new(this, "Debug2_sel", RW, 20, 16, 'h1f);
      this.Debug1_sel = new(this, "Debug1_sel", RW, 12, 8, 'h1f);
      this.Debug0_sel = new(this, "Debug0_sel", RW, 4, 0, 'h1f);
   endfunction

endclass


class Creg_acq_trigger_missed extends Cregister;
   Cfield TRIGGER_MISSED_RST;
   Cfield TRIGGER_MISSED_CNTR;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.TRIGGER_MISSED_RST = new(this, "TRIGGER_MISSED_RST", WO, 28, 28, 'h0);
      this.TRIGGER_MISSED_CNTR = new(this, "TRIGGER_MISSED_CNTR", RO, 15, 0, 'h0);
   endfunction

endclass


class Creg_acq_sensor_fps extends Cregister;
   Cfield SENSOR_FPS;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.SENSOR_FPS = new(this, "SENSOR_FPS", RO, 15, 0, 'h0);
   endfunction

endclass


class Creg_acq_sensor_fps2 extends Cregister;
   Cfield SENSOR_FPS;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.SENSOR_FPS = new(this, "SENSOR_FPS", RO, 19, 0, 'h0);
   endfunction

endclass


class Creg_acq_debug extends Cregister;
   Cfield DEBUG_RST_CNTR;
   Cfield LED_TEST_COLOR;
   Cfield LED_TEST;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.DEBUG_RST_CNTR = new(this, "DEBUG_RST_CNTR", RW, 28, 28, 'h1);
      this.LED_TEST_COLOR = new(this, "LED_TEST_COLOR", RW, 2, 1, 'h0);
      this.LED_TEST = new(this, "LED_TEST", RW, 0, 0, 'h0);
   endfunction

endclass


class Creg_acq_debug_cntr1 extends Cregister;
   Cfield SENSOR_FRAME_DURATION;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.SENSOR_FRAME_DURATION = new(this, "SENSOR_FRAME_DURATION", RO, 27, 0, 'h0);
   endfunction

endclass


class Creg_acq_exp_fot extends Cregister;
   Cfield EXP_FOT;
   Cfield EXP_FOT_TIME;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.EXP_FOT = new(this, "EXP_FOT", RW, 16, 16, 'h1);
      this.EXP_FOT_TIME = new(this, "EXP_FOT_TIME", RW, 11, 0, 'h9ee);
   endfunction

endclass


class Creg_acq_acq_sfnc extends Cregister;
   Cfield RELOAD_GRAB_PARAMS;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.RELOAD_GRAB_PARAMS = new(this, "RELOAD_GRAB_PARAMS", RW, 0, 0, 'h1);
   endfunction

endclass


class Creg_acq_timer_ctrl extends Cregister;
   Cfield ADAPTATIVE;
   Cfield TIMERSTOP;
   Cfield TIMERSTART;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.ADAPTATIVE = new(this, "ADAPTATIVE", RW, 8, 8, 'h1);
      this.TIMERSTOP = new(this, "TIMERSTOP", WO, 4, 4, 'h0);
      this.TIMERSTART = new(this, "TIMERSTART", WO, 0, 0, 'h0);
   endfunction

endclass


class Creg_acq_timer_delay extends Cregister;
   Cfield VALUE;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.VALUE = new(this, "VALUE", RW, 31, 0, 'h0);
   endfunction

endclass


class Creg_acq_timer_duration extends Cregister;
   Cfield VALUE;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.VALUE = new(this, "VALUE", RW, 31, 0, 'h0);
   endfunction

endclass


class Csec_acq extends Csection;
       Creg_acq_grab_ctrl GRAB_CTRL;
       Creg_acq_grab_stat GRAB_STAT;
       Creg_acq_readout_cfg1 READOUT_CFG1;
       Creg_acq_readout_cfg_frame_line READOUT_CFG_FRAME_LINE;
       Creg_acq_readout_cfg2 READOUT_CFG2;
       Creg_acq_readout_cfg3 READOUT_CFG3;
       Creg_acq_readout_cfg4 READOUT_CFG4;
       Creg_acq_exp_ctrl1 EXP_CTRL1;
       Creg_acq_exp_ctrl2 EXP_CTRL2;
       Creg_acq_exp_ctrl3 EXP_CTRL3;
       Creg_acq_trigger_delay TRIGGER_DELAY;
       Creg_acq_strobe_ctrl1 STROBE_CTRL1;
       Creg_acq_strobe_ctrl2 STROBE_CTRL2;
       Creg_acq_acq_ser_ctrl ACQ_SER_CTRL;
       Creg_acq_acq_ser_addata ACQ_SER_ADDATA;
       Creg_acq_acq_ser_stat ACQ_SER_STAT;
       Creg_acq_sensor_ctrl SENSOR_CTRL;
       Creg_acq_sensor_stat SENSOR_STAT;
       Creg_acq_sensor_subsampling SENSOR_SUBSAMPLING;
       Creg_acq_sensor_gain_ana SENSOR_GAIN_ANA;
       Creg_acq_sensor_roi_y_start SENSOR_ROI_Y_START;
       Creg_acq_sensor_roi_y_size SENSOR_ROI_Y_SIZE;
       Creg_acq_sensor_m_lines SENSOR_M_LINES;
       Creg_acq_sensor_dp_gr SENSOR_DP_GR;
       Creg_acq_sensor_dp_gb SENSOR_DP_GB;
       Creg_acq_sensor_dp_r SENSOR_DP_R;
       Creg_acq_sensor_dp_b SENSOR_DP_B;
       Creg_acq_sensor_gain_dig_g SENSOR_GAIN_DIG_G;
       Creg_acq_sensor_gain_dig_rb SENSOR_GAIN_DIG_RB;
       Creg_acq_fpga_roi_x_start FPGA_ROI_X_START;
       Creg_acq_fpga_roi_x_size FPGA_ROI_X_SIZE;
       Creg_acq_debug_pins DEBUG_PINS;
       Creg_acq_trigger_missed TRIGGER_MISSED;
       Creg_acq_sensor_fps SENSOR_FPS;
       Creg_acq_sensor_fps2 SENSOR_FPS2;
       Creg_acq_debug DEBUG;
       Creg_acq_debug_cntr1 DEBUG_CNTR1;
       Creg_acq_exp_fot EXP_FOT;
       Creg_acq_acq_sfnc ACQ_SFNC;
       Creg_acq_timer_ctrl TIMER_CTRL;
       Creg_acq_timer_delay TIMER_DELAY;
       Creg_acq_timer_duration TIMER_DURATION;
   

   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.GRAB_CTRL = new(this, "GRAB_CTRL",'h0);
      this.GRAB_STAT = new(this, "GRAB_STAT",'h8);
      this.READOUT_CFG1 = new(this, "READOUT_CFG1",'h10);
      this.READOUT_CFG_FRAME_LINE = new(this, "READOUT_CFG_FRAME_LINE",'h14);
      this.READOUT_CFG2 = new(this, "READOUT_CFG2",'h18);
      this.READOUT_CFG3 = new(this, "READOUT_CFG3",'h20);
      this.READOUT_CFG4 = new(this, "READOUT_CFG4",'h24);
      this.EXP_CTRL1 = new(this, "EXP_CTRL1",'h28);
      this.EXP_CTRL2 = new(this, "EXP_CTRL2",'h30);
      this.EXP_CTRL3 = new(this, "EXP_CTRL3",'h38);
      this.TRIGGER_DELAY = new(this, "TRIGGER_DELAY",'h40);
      this.STROBE_CTRL1 = new(this, "STROBE_CTRL1",'h48);
      this.STROBE_CTRL2 = new(this, "STROBE_CTRL2",'h50);
      this.ACQ_SER_CTRL = new(this, "ACQ_SER_CTRL",'h58);
      this.ACQ_SER_ADDATA = new(this, "ACQ_SER_ADDATA",'h60);
      this.ACQ_SER_STAT = new(this, "ACQ_SER_STAT",'h68);
      this.SENSOR_CTRL = new(this, "SENSOR_CTRL",'h90);
      this.SENSOR_STAT = new(this, "SENSOR_STAT",'h98);
      this.SENSOR_SUBSAMPLING = new(this, "SENSOR_SUBSAMPLING",'h9c);
      this.SENSOR_GAIN_ANA = new(this, "SENSOR_GAIN_ANA",'ha4);
      this.SENSOR_ROI_Y_START = new(this, "SENSOR_ROI_Y_START",'ha8);
      this.SENSOR_ROI_Y_SIZE = new(this, "SENSOR_ROI_Y_SIZE",'hac);
      this.SENSOR_M_LINES = new(this, "SENSOR_M_LINES",'hb8);
      this.SENSOR_DP_GR = new(this, "SENSOR_DP_GR",'hbc);
      this.SENSOR_DP_GB = new(this, "SENSOR_DP_GB",'hc0);
      this.SENSOR_DP_R = new(this, "SENSOR_DP_R",'hc4);
      this.SENSOR_DP_B = new(this, "SENSOR_DP_B",'hc8);
      this.SENSOR_GAIN_DIG_G = new(this, "SENSOR_GAIN_DIG_G",'hcc);
      this.SENSOR_GAIN_DIG_RB = new(this, "SENSOR_GAIN_DIG_RB",'hd0);
      this.FPGA_ROI_X_START = new(this, "FPGA_ROI_X_START",'hd8);
      this.FPGA_ROI_X_SIZE = new(this, "FPGA_ROI_X_SIZE",'hdc);
      this.DEBUG_PINS = new(this, "DEBUG_PINS",'he0);
      this.TRIGGER_MISSED = new(this, "TRIGGER_MISSED",'he8);
      this.SENSOR_FPS = new(this, "SENSOR_FPS",'hf0);
      this.SENSOR_FPS2 = new(this, "SENSOR_FPS2",'hf4);
      this.DEBUG = new(this, "DEBUG",'h1a0);
      this.DEBUG_CNTR1 = new(this, "DEBUG_CNTR1",'h1a8);
      this.EXP_FOT = new(this, "EXP_FOT",'h1b8);
      this.ACQ_SFNC = new(this, "ACQ_SFNC",'h1c0);
      this.TIMER_CTRL = new(this, "TIMER_CTRL",'h1d0);
      this.TIMER_DELAY = new(this, "TIMER_DELAY",'h1d4);
      this.TIMER_DURATION = new(this, "TIMER_DURATION",'h1d8);
   endfunction

endclass


class Creg_hispi_ctrl extends Cregister;
   Cfield SW_CLR_IDELAYCTRL;
   Cfield SW_CLR_HISPI;
   Cfield SW_CALIB_SERDES;
   Cfield ENABLE_DATA_PATH;
   Cfield ENABLE_HISPI;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.SW_CLR_IDELAYCTRL = new(this, "SW_CLR_IDELAYCTRL", RW, 4, 4, 'h0);
      this.SW_CLR_HISPI = new(this, "SW_CLR_HISPI", RW, 3, 3, 'h0);
      this.SW_CALIB_SERDES = new(this, "SW_CALIB_SERDES", WO, 2, 2, 'h0);
      this.ENABLE_DATA_PATH = new(this, "ENABLE_DATA_PATH", RW, 1, 1, 'h0);
      this.ENABLE_HISPI = new(this, "ENABLE_HISPI", RW, 0, 0, 'h0);
   endfunction

endclass


class Creg_hispi_status extends Cregister;
   Cfield FSM;
   Cfield CRC_ERROR;
   Cfield PHY_BIT_LOCKED_ERROR;
   Cfield FIFO_ERROR;
   Cfield CALIBRATION_ERROR;
   Cfield CALIBRATION_DONE;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.FSM = new(this, "FSM", RO, 31, 28, 'h0);
      this.CRC_ERROR = new(this, "CRC_ERROR", RO, 4, 4, 'h0);
      this.PHY_BIT_LOCKED_ERROR = new(this, "PHY_BIT_LOCKED_ERROR", RO, 3, 3, 'h0);
      this.FIFO_ERROR = new(this, "FIFO_ERROR", RO, 2, 2, 'h0);
      this.CALIBRATION_ERROR = new(this, "CALIBRATION_ERROR", RO, 1, 1, 'h0);
      this.CALIBRATION_DONE = new(this, "CALIBRATION_DONE", RO, 0, 0, 'h0);
   endfunction

endclass


class Creg_hispi_idelayctrl_status extends Cregister;
   Cfield PLL_LOCKED;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.PLL_LOCKED = new(this, "PLL_LOCKED", RO, 0, 0, 'h0);
   endfunction

endclass


class Creg_hispi_idle_character extends Cregister;
   Cfield VALUE;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.VALUE = new(this, "VALUE", RW, 11, 0, 'h3A6);
   endfunction

endclass


class Creg_hispi_phy extends Cregister;
   Cfield PIXEL_PER_LANE;
   Cfield MUX_RATIO;
   Cfield NB_LANES;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.PIXEL_PER_LANE = new(this, "PIXEL_PER_LANE", RW, 25, 16, 'hAE);
      this.MUX_RATIO = new(this, "MUX_RATIO", RO, 10, 8, 'h4);
      this.NB_LANES = new(this, "NB_LANES", RW, 2, 0, 'h0);
   endfunction

endclass


class Creg_hispi_frame_cfg extends Cregister;
   Cfield LINES_PER_FRAME;
   Cfield PIXELS_PER_LINE;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.LINES_PER_FRAME = new(this, "LINES_PER_FRAME", RW, 27, 16, 'hc1e);
      this.PIXELS_PER_LINE = new(this, "PIXELS_PER_LINE", RW, 12, 0, 'h1050);
   endfunction

endclass


class Creg_hispi_frame_cfg_x_valid extends Cregister;
   Cfield X_END;
   Cfield X_START;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.X_END = new(this, "X_END", RW, 28, 16, 'h1023);
      this.X_START = new(this, "X_START", RW, 12, 0, 'h24);
   endfunction

endclass


class Creg_hispi_lane_decoder_status extends Cregister;
   Cfield CRC_ERROR;
   Cfield PHY_SYNC_ERROR;
   Cfield PHY_BIT_LOCKED_ERROR;
   Cfield PHY_BIT_LOCKED;
   Cfield CALIBRATION_TAP_VALUE;
   Cfield CALIBRATION_ERROR;
   Cfield CALIBRATION_DONE;
   Cfield FIFO_UNDERRUN;
   Cfield FIFO_OVERRUN;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.CRC_ERROR = new(this, "CRC_ERROR", RW2C, 15, 15, 'h0);
      this.PHY_SYNC_ERROR = new(this, "PHY_SYNC_ERROR", RW2C, 14, 14, 'h0);
      this.PHY_BIT_LOCKED_ERROR = new(this, "PHY_BIT_LOCKED_ERROR", RW2C, 13, 13, 'h0);
      this.PHY_BIT_LOCKED = new(this, "PHY_BIT_LOCKED", RO, 12, 12, 'h0);
      this.CALIBRATION_TAP_VALUE = new(this, "CALIBRATION_TAP_VALUE", RO, 8, 4, 'h0);
      this.CALIBRATION_ERROR = new(this, "CALIBRATION_ERROR", RW2C, 3, 3, 'h0);
      this.CALIBRATION_DONE = new(this, "CALIBRATION_DONE", RO, 2, 2, 'h0);
      this.FIFO_UNDERRUN = new(this, "FIFO_UNDERRUN", RW2C, 1, 1, 'h0);
      this.FIFO_OVERRUN = new(this, "FIFO_OVERRUN", RW2C, 0, 0, 'h0);
   endfunction

endclass


class Creg_hispi_tap_histogram extends Cregister;
   Cfield VALUE;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.VALUE = new(this, "VALUE", RO, 31, 0, 'h0);
   endfunction

endclass


class Creg_hispi_debug extends Cregister;
   Cfield MANUAL_CALIB_EN;
   Cfield LOAD_TAPS;
   Cfield TAP_LANE_5;
   Cfield TAP_LANE_4;
   Cfield TAP_LANE_3;
   Cfield TAP_LANE_2;
   Cfield TAP_LANE_1;
   Cfield TAP_LANE_0;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.MANUAL_CALIB_EN = new(this, "MANUAL_CALIB_EN", RW, 31, 31, 'h0);
      this.LOAD_TAPS = new(this, "LOAD_TAPS", WO, 30, 30, 'h0);
      this.TAP_LANE_5 = new(this, "TAP_LANE_5", RW, 29, 25, 'h0);
      this.TAP_LANE_4 = new(this, "TAP_LANE_4", RW, 24, 20, 'h0);
      this.TAP_LANE_3 = new(this, "TAP_LANE_3", RW, 19, 15, 'h0);
      this.TAP_LANE_2 = new(this, "TAP_LANE_2", RW, 14, 10, 'h0);
      this.TAP_LANE_1 = new(this, "TAP_LANE_1", RW, 9, 5, 'h0);
      this.TAP_LANE_0 = new(this, "TAP_LANE_0", RW, 4, 0, 'h0);
   endfunction

endclass


class Csec_hispi extends Csection;
       Creg_hispi_ctrl CTRL;
       Creg_hispi_status STATUS;
       Creg_hispi_idelayctrl_status IDELAYCTRL_STATUS;
       Creg_hispi_idle_character IDLE_CHARACTER;
       Creg_hispi_phy PHY;
       Creg_hispi_frame_cfg FRAME_CFG;
       Creg_hispi_frame_cfg_x_valid FRAME_CFG_X_VALID;
       Creg_hispi_lane_decoder_status LANE_DECODER_STATUS[6];
       Creg_hispi_tap_histogram TAP_HISTOGRAM[6];
       Creg_hispi_debug DEBUG;
   

   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.CTRL = new(this, "CTRL",'h0);
      this.STATUS = new(this, "STATUS",'h4);
      this.IDELAYCTRL_STATUS = new(this, "IDELAYCTRL_STATUS",'h8);
      this.IDLE_CHARACTER = new(this, "IDLE_CHARACTER",'hc);
      this.PHY = new(this, "PHY",'h10);
      this.FRAME_CFG = new(this, "FRAME_CFG",'h14);
      this.FRAME_CFG_X_VALID = new(this, "FRAME_CFG_X_VALID",'h18);
      this.LANE_DECODER_STATUS[0] = new(this, "LANE_DECODER_STATUS[6]", 'h24);
      this.LANE_DECODER_STATUS[1] = new(this, "LANE_DECODER_STATUS[6]", 'h28);
      this.LANE_DECODER_STATUS[2] = new(this, "LANE_DECODER_STATUS[6]", 'h2c);
      this.LANE_DECODER_STATUS[3] = new(this, "LANE_DECODER_STATUS[6]", 'h30);
      this.LANE_DECODER_STATUS[4] = new(this, "LANE_DECODER_STATUS[6]", 'h34);
      this.LANE_DECODER_STATUS[5] = new(this, "LANE_DECODER_STATUS[6]", 'h38);
      this.TAP_HISTOGRAM[0] = new(this, "TAP_HISTOGRAM[6]", 'h3c);
      this.TAP_HISTOGRAM[1] = new(this, "TAP_HISTOGRAM[6]", 'h40);
      this.TAP_HISTOGRAM[2] = new(this, "TAP_HISTOGRAM[6]", 'h44);
      this.TAP_HISTOGRAM[3] = new(this, "TAP_HISTOGRAM[6]", 'h48);
      this.TAP_HISTOGRAM[4] = new(this, "TAP_HISTOGRAM[6]", 'h4c);
      this.TAP_HISTOGRAM[5] = new(this, "TAP_HISTOGRAM[6]", 'h50);
      this.DEBUG = new(this, "DEBUG",'h54);
   endfunction

endclass


class Creg_dpc_dpc_capabilities extends Cregister;
   Cfield DPC_LIST_LENGTH;
   Cfield DPC_VER;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.DPC_LIST_LENGTH = new(this, "DPC_LIST_LENGTH", RO, 27, 16, 'h0);
      this.DPC_VER = new(this, "DPC_VER", RO, 3, 0, 'h0);
   endfunction

endclass


class Creg_dpc_dpc_list_ctrl extends Cregister;
   Cfield dpc_fifo_reset;
   Cfield dpc_firstlast_line_rem;
   Cfield dpc_list_count;
   Cfield dpc_pattern0_cfg;
   Cfield dpc_enable;
   Cfield dpc_list_WRn;
   Cfield dpc_list_ss;
   Cfield dpc_list_add;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.dpc_fifo_reset = new(this, "dpc_fifo_reset", RW, 29, 29, 'h0);
      this.dpc_firstlast_line_rem = new(this, "dpc_firstlast_line_rem", RW, 28, 28, 'h0);
      this.dpc_list_count = new(this, "dpc_list_count", RW, 27, 16, 'h0);
      this.dpc_pattern0_cfg = new(this, "dpc_pattern0_cfg", RW, 15, 15, 'h0);
      this.dpc_enable = new(this, "dpc_enable", RW, 14, 14, 'h0);
      this.dpc_list_WRn = new(this, "dpc_list_WRn", RW, 13, 13, 'h0);
      this.dpc_list_ss = new(this, "dpc_list_ss", WO, 12, 12, 'h0);
      this.dpc_list_add = new(this, "dpc_list_add", RW, 11, 0, 'h0);
   endfunction

endclass


class Creg_dpc_dpc_list_stat extends Cregister;
   Cfield dpc_fifo_underrun;
   Cfield dpc_fifo_overrun;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.dpc_fifo_underrun = new(this, "dpc_fifo_underrun", RO, 31, 31, 'h0);
      this.dpc_fifo_overrun = new(this, "dpc_fifo_overrun", RO, 30, 30, 'h0);
   endfunction

endclass


class Creg_dpc_dpc_list_data1 extends Cregister;
   Cfield dpc_list_corr_y;
   Cfield dpc_list_corr_x;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.dpc_list_corr_y = new(this, "dpc_list_corr_y", RW, 27, 16, 'h0);
      this.dpc_list_corr_x = new(this, "dpc_list_corr_x", RW, 12, 0, 'h0);
   endfunction

endclass


class Creg_dpc_dpc_list_data2 extends Cregister;
   Cfield dpc_list_corr_pattern;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.dpc_list_corr_pattern = new(this, "dpc_list_corr_pattern", RW, 7, 0, 'h0);
   endfunction

endclass


class Creg_dpc_dpc_list_data1_rd extends Cregister;
   Cfield dpc_list_corr_y;
   Cfield dpc_list_corr_x;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.dpc_list_corr_y = new(this, "dpc_list_corr_y", RO, 27, 16, 'h0);
      this.dpc_list_corr_x = new(this, "dpc_list_corr_x", RO, 12, 0, 'h0);
   endfunction

endclass


class Creg_dpc_dpc_list_data2_rd extends Cregister;
   Cfield dpc_list_corr_pattern;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.dpc_list_corr_pattern = new(this, "dpc_list_corr_pattern", RO, 7, 0, 'h0);
   endfunction

endclass


class Csec_dpc extends Csection;
       Creg_dpc_dpc_capabilities DPC_CAPABILITIES;
       Creg_dpc_dpc_list_ctrl DPC_LIST_CTRL;
       Creg_dpc_dpc_list_stat DPC_LIST_STAT;
       Creg_dpc_dpc_list_data1 DPC_LIST_DATA1;
       Creg_dpc_dpc_list_data2 DPC_LIST_DATA2;
       Creg_dpc_dpc_list_data1_rd DPC_LIST_DATA1_RD;
       Creg_dpc_dpc_list_data2_rd DPC_LIST_DATA2_RD;
   

   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.DPC_CAPABILITIES = new(this, "DPC_CAPABILITIES",'h0);
      this.DPC_LIST_CTRL = new(this, "DPC_LIST_CTRL",'h4);
      this.DPC_LIST_STAT = new(this, "DPC_LIST_STAT",'h8);
      this.DPC_LIST_DATA1 = new(this, "DPC_LIST_DATA1",'hc);
      this.DPC_LIST_DATA2 = new(this, "DPC_LIST_DATA2",'h10);
      this.DPC_LIST_DATA1_RD = new(this, "DPC_LIST_DATA1_RD",'h14);
      this.DPC_LIST_DATA2_RD = new(this, "DPC_LIST_DATA2_RD",'h18);
   endfunction

endclass


class Creg_lut_lut_capabilities extends Cregister;
   Cfield LUT_SIZE_CONFIG;
   Cfield LUT_VER;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.LUT_SIZE_CONFIG = new(this, "LUT_SIZE_CONFIG", RO, 27, 16, 'h0);
      this.LUT_VER = new(this, "LUT_VER", RO, 3, 0, 'h0);
   endfunction

endclass


class Creg_lut_lut_ctrl extends Cregister;
   Cfield LUT_BYPASS;
   Cfield LUT_DATA_W;
   Cfield LUT_SEL;
   Cfield LUT_WRN;
   Cfield LUT_SS;
   Cfield LUT_ADD;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.LUT_BYPASS = new(this, "LUT_BYPASS", RW, 28, 28, 'h0);
      this.LUT_DATA_W = new(this, "LUT_DATA_W", RW, 23, 16, 'h0);
      this.LUT_SEL = new(this, "LUT_SEL", RW, 15, 12, 'h0);
      this.LUT_WRN = new(this, "LUT_WRN", RW, 11, 11, 'h0);
      this.LUT_SS = new(this, "LUT_SS", WO, 10, 10, 'h0);
      this.LUT_ADD = new(this, "LUT_ADD", RW, 9, 0, 'h0);
   endfunction

endclass


class Creg_lut_lut_rb extends Cregister;
   Cfield LUT_RB;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.LUT_RB = new(this, "LUT_RB", RO, 7, 0, 'h0);
   endfunction

endclass


class Csec_lut extends Csection;
       Creg_lut_lut_capabilities LUT_CAPABILITIES;
       Creg_lut_lut_ctrl LUT_CTRL;
       Creg_lut_lut_rb LUT_RB;
   

   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.LUT_CAPABILITIES = new(this, "LUT_CAPABILITIES",'h0);
      this.LUT_CTRL = new(this, "LUT_CTRL",'h4);
      this.LUT_RB = new(this, "LUT_RB",'h8);
   endfunction

endclass


class Creg_sysmonxil_temp extends Cregister;
   Cfield SMTEMP;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.SMTEMP = new(this, "SMTEMP", RO, 15, 4, 'h0);
   endfunction

endclass


class Creg_sysmonxil_vccint extends Cregister;
   Cfield SMVINT;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.SMVINT = new(this, "SMVINT", RO, 15, 4, 'h0);
   endfunction

endclass


class Creg_sysmonxil_vccaux extends Cregister;
   Cfield SMVAUX;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.SMVAUX = new(this, "SMVAUX", RO, 15, 4, 'h0);
   endfunction

endclass


class Creg_sysmonxil_vccbram extends Cregister;
   Cfield SMVBRAM;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.SMVBRAM = new(this, "SMVBRAM", RO, 15, 4, 'h0);
   endfunction

endclass


class Creg_sysmonxil_temp_max extends Cregister;
   Cfield SMTMAX;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.SMTMAX = new(this, "SMTMAX", RO, 15, 4, 'h0);
   endfunction

endclass


class Creg_sysmonxil_temp_min extends Cregister;
   Cfield SMTMIN;
   


   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.SMTMIN = new(this, "SMTMIN", RO, 15, 4, 'h0);
   endfunction

endclass


class Cext_sysmonxil extends Cexternal;
       Creg_sysmonxil_temp TEMP;
       Creg_sysmonxil_vccint VCCINT;
       Creg_sysmonxil_vccaux VCCAUX;
       Creg_sysmonxil_vccbram VCCBRAM;
       Creg_sysmonxil_temp_max TEMP_MAX;
       Creg_sysmonxil_temp_min TEMP_MIN;
   

   function new(Cnode parent, string name, longint offset);

      super.new(parent, name, offset);


      // Member instatiation
      this.TEMP = new(this, "TEMP", 'h0);
      this.VCCINT = new(this, "VCCINT", 'h4);
      this.VCCAUX = new(this, "VCCAUX", 'h8);
      this.VCCBRAM = new(this, "VCCBRAM", 'h18);
      this.TEMP_MAX = new(this, "TEMP_MAX", 'h80);
      this.TEMP_MIN = new(this, "TEMP_MIN", 'h90);
   endfunction

endclass


class Cregfile_xgs_athena extends Caddressable;
       Csec_system SYSTEM;
       Csec_dma DMA;
       Csec_acq ACQ;
       Csec_hispi HISPI;
       Csec_dpc DPC;
       Csec_lut LUT;
       Cext_sysmonxil SYSMONXIL;

   

   function new(longint offset='h0, string name="regfile_xgs_athena");

      super.new(null, name);


      // Member instatiation
      this.SYSTEM = new(this, "SYSTEM", 'h0);
      this.DMA = new(this, "DMA", 'h70);
      this.ACQ = new(this, "ACQ", 'h100);
      this.HISPI = new(this, "HISPI", 'h400);
      this.DPC = new(this, "DPC", 'h480);
      this.LUT = new(this, "LUT", 'h4b0);
      this.SYSMONXIL = new(this, "SYSMONXIL", 'h700);
   endfunction

endclass



endpackage
