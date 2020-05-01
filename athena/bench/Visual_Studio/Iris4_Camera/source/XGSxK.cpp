//-----------------------------------------------
//
//  Common functions for all DCF XGS sensors
//
//-----------------------------------------------

/* Headers */
#include "stdafx.h"
#include <stdio.h> 
#include <stdlib.h>

#include "XGS_Ctrl.h"




//-----------------------------------------
// Cofig Monitor PINS
//-----------------------------------------
void CXGS_Ctrl::XGS_Config_Monitor() {
	
	// Program monitor pins in XGS
	//M_UINT32 monitor_0_reg = 0x6;    // 0x6 : Real Integration  , 0x2 : Integrate
	//M_UINT32 monitor_1_reg = 0x10;   // 0x10 :EFOT indication
	//M_UINT32 monitor_2_reg = 0x1;    // New_line

	M_UINT32 monitor_0_reg = 0x6;    // Real EXP
	M_UINT32 monitor_1_reg = 0x10;   // 0x10 :EFOT indication : Do not change
	//M_UINT32 monitor_2_reg = 0x1;  // New_line
	//M_UINT32 monitor_2_reg = 0x6;  // real int
	M_UINT32 monitor_2_reg = 0x13;   // Mline

	//Monitor 0 is normal debug
	WriteSPI(0x3806, (monitor_2_reg << 10) + (monitor_1_reg << 5) + monitor_0_reg);    // Monitor Lines
	WriteSPI(0x3602, (2 << 6) + (2 << 3) + 2);    // Monitor_ctrl

	//Monitor 0 is Line valid
	WriteSPI(0x3e40, (0x4 << 10) + (0x4 << 5) + 0x4);    // Monitor Lines in mode MDH - Line valid
	WriteSPI(0x3602, (2 << 6) + (2 << 3) + 3);    // Monitor_ctrl

}



//-----------------------------------------
// PowerUp and wait until Sensor is rdy
//-----------------------------------------
void CXGS_Ctrl::XGS_WaitRdy() {

	//	Wait until the sensor is ready to receive register writes: (REG 0x3706[3:0] = 0x3) : POLL_REG = 0x3706, 0x000F, != 0x3, DELAY = 25, TIMEOUT = 500
	PollRegSPI(0x3706, 0xF, 0x3, 25, 40);

}

//----------------------
// Activating sensor
//----------------------
void CXGS_Ctrl::XGS_Activate_sensor() {
	M_UINT32 read;

	// Enable PLL and Analog blocks: REG = 0x3700, 0x001c
	WriteSPI(0x3700, 0x001c);

	printf("Polling for initialisation complete\n");

	// Check if initialization is complete (REG 0x3706[7:0] = 0xEB): POLL_REG = 0x3706, 0x00FF, != 0xEB, DELAY = 25, TIMEOUT = 500
	PollRegSPI(0x3706, 0x00FF, 0xEB, 25, 40);

	// Slave mode + Trigger mode
	M_UINT32 GeneralConfig0 = ReadSPI(0x3800);
	WriteSPI(0x3800, GeneralConfig0 | 0x30);
	if ((ReadSPI(0x3800) & 0x30) == 0x30) printf("XGS is now in Slave trigger mode.\n");

	//Enable sequencer : BITFIELD = 0x3800, 0x0001, 1
	WriteSPI_Bit(0x3800, 0, 1);

	read = ReadSPI(0x3800);
	if (read == 0x31)
		printf("XGS sequencer enable!!!\n\n\n");

}


//-----------------------------------------
// XGS copy mirror registers from XGS to FPGA
//-----------------------------------------
void CXGS_Ctrl::XGS_CopyMirror_regs() {

	// Copy some "mirror" registers from Sensor to FPGA
	sXGSptr.ACQ.SENSOR_GAIN_ANA.u32 = ReadSPI(0x3844);      //Analog Gain
	rXGSptr.ACQ.SENSOR_GAIN_ANA.u32 = sXGSptr.ACQ.SENSOR_GAIN_ANA.u32;

	sXGSptr.ACQ.SENSOR_SUBSAMPLING.u32 = ReadSPI(0x383c);      //Subsampling
	rXGSptr.ACQ.SENSOR_SUBSAMPLING.u32 = sXGSptr.ACQ.SENSOR_SUBSAMPLING.u32;

	sXGSptr.ACQ.SENSOR_M_LINES.u32 = ReadSPI(0x389a);      //M_LINES cntx(0)
	rXGSptr.ACQ.SENSOR_M_LINES.u32 = sXGSptr.ACQ.SENSOR_M_LINES.u32;

	//sXGSptr.ACQ.SENSOR_F_LINES.u32 = ReadSPI(0x389c);      //F_LINES cntx(0)
	//rXGSptr.ACQ.SENSOR_F_LINES.u32 = sXGSptr.ACQ.SENSOR_F_LINES.u32;

	sXGSptr.ACQ.READOUT_CFG3.f.LINE_TIME = ReadSPI(0x3810);      //LINETIME
	rXGSptr.ACQ.READOUT_CFG3.f.LINE_TIME = sXGSptr.ACQ.READOUT_CFG3.f.LINE_TIME;

}


void CXGS_Ctrl::XGS_SetConfigFPGA(void) {

	//Enable EXP during FOT
	sXGSptr.ACQ.EXP_FOT.f.EXP_FOT_TIME = (M_UINT32)((double)SensorParams.EXP_FOT_TIME / SystemPeriodNanoSecond);
	sXGSptr.ACQ.EXP_FOT.f.EXP_FOT = 1;
	rXGSptr.ACQ.EXP_FOT.u32 = sXGSptr.ACQ.EXP_FOT.u32;

	//Trigger KeepOut zone
	sXGSptr.ACQ.READOUT_CFG4.f.KEEP_OUT_TRIG_START = (M_UINT32)(double((sXGSptr.ACQ.READOUT_CFG3.f.LINE_TIME * SensorPeriodNanoSecond) - 100) / SystemPeriodNanoSecond);   //START Keepout trigger zone (100ns)
	sXGSptr.ACQ.READOUT_CFG4.f.KEEP_OUT_TRIG_END = (M_UINT32)(double(sXGSptr.ACQ.READOUT_CFG3.f.LINE_TIME * SensorPeriodNanoSecond) / SystemPeriodNanoSecond);           //END   Keepout trigger zone (100ns), this is more for testing, monitor will reset the counter 	
	rXGSptr.ACQ.READOUT_CFG4.u32 = sXGSptr.ACQ.READOUT_CFG4.u32;

	// Pour le moment non enable car on recois pas le signal New_line du XGS (Xcelerator)
	sXGSptr.ACQ.READOUT_CFG3.f.KEEP_OUT_TRIG_ENA = 0;
	rXGSptr.ACQ.READOUT_CFG3.u32 = sXGSptr.ACQ.READOUT_CFG3.u32;

	// Set FOT time (not used by fpga for the moment)
	sXGSptr.ACQ.READOUT_CFG1.f.FOT_LENGTH_LINE = GrabParams.FOT;
	sXGSptr.ACQ.READOUT_CFG1.f.FOT_LENGTH = (M_UINT32)(double(GrabParams.FOT * sXGSptr.ACQ.READOUT_CFG3.f.LINE_TIME * SensorPeriodNanoSecond) / SystemPeriodNanoSecond); //test: de EO_FOT genere ds le fpga
	sXGSptr.ACQ.READOUT_CFG1.f.EO_FOT_SEL = 1;
	rXGSptr.ACQ.READOUT_CFG1.u32 = sXGSptr.ACQ.READOUT_CFG1.u32;

}