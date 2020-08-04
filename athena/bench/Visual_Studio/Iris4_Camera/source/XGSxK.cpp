//-----------------------------------------------
//
//  Common functions for all DCF XGS sensors
//
//-----------------------------------------------

/* Headers */
#include "osincludes.h"

#include "XGS_Ctrl.h"




//-----------------------------------------
// Cofig Monitor PINS
//-----------------------------------------
void CXGS_Ctrl::XGS_Config_Monitor() {
	

    // Program monitor pins in XGS
    M_UINT32 monitor_0_reg = 0x6;    // 0x6 : Real Integration  , 0x2 : Integrate
    M_UINT32 monitor_1_reg = 0x10;   // 0x10 :EFOT indication
    M_UINT32 monitor_2_reg = 0x1;    // New_line
             //monitor_2_reg = 0x13;   // Mline
    		 //monitor_2_reg = 0xe;
    
    //Monitor is normal debug
    WriteSPI(0x3806, (monitor_2_reg << 10) + (monitor_1_reg << 5) + monitor_0_reg);    // Monitor Lines
    WriteSPI(0x3602, (2 << 6) + (2 << 3) + 2);    // Monitor_ctrl
    
    //Monitor is debug monitor3 from MDH
    //WriteSPI(0x3806, (monitor_2_reg << 10) + (monitor_1_reg << 5) + monitor_0_reg);    // Monitor Lines
    //WriteSPI(0x3e40, (0x4 << 10) + (0x0 << 5) + 0x0);    // Monitor Lines in mode MDH - Line valid
    //WriteSPI(0x3602, (3 << 6) + (2 << 3) + 2);    // Monitor_ctrl


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

	// Par defaut XGS mets une latence de UN frame pour les registre OFFSET_LAT_COMP et GAIN_LAT_COMP, nous les ecritures registres sont allignees au EO_FOT
	// alors on ne veux pas une latence de 1 frame. Mettre OFFSET_LAT_COMP et GAIN_LAT_COMP a 0
	WriteSPI(0x3802, 0xfcff & ReadSPI(0x3802) );  

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
	sXGSptr.ACQ.EXP_FOT.f.EXP_FOT      = 1;
	rXGSptr.ACQ.EXP_FOT.u32            = sXGSptr.ACQ.EXP_FOT.u32;

	//Trigger KeepOut zone
	sXGSptr.ACQ.READOUT_CFG4.f.KEEP_OUT_TRIG_START = SensorParams.KEEP_OUT_ZONE_START;   //START Keepout trigger zone (100ns before and during NEW_LINE monitor)
	sXGSptr.ACQ.READOUT_CFG4.f.KEEP_OUT_TRIG_ENA   = 1;
	rXGSptr.ACQ.READOUT_CFG4.u32                   = sXGSptr.ACQ.READOUT_CFG4.u32;

	// Set FOT time (not used by fpga for the moment)
	sXGSptr.ACQ.READOUT_CFG1.f.FOT_LENGTH_LINE    = GrabParams.FOT;
	sXGSptr.ACQ.READOUT_CFG1.f.FOT_LENGTH         = (M_UINT32)(double(GrabParams.FOT * sXGSptr.ACQ.READOUT_CFG3.f.LINE_TIME * SensorPeriodNanoSecond) / SystemPeriodNanoSecond); 
	sXGSptr.ACQ.READOUT_CFG1.f.EO_FOT_SEL         = 1;  //EO_FOT genere ds le fpga : programmable number of lines!
	rXGSptr.ACQ.READOUT_CFG1.u32                  = sXGSptr.ACQ.READOUT_CFG1.u32;


	// Set Location of first valid x pixel(including Interpolation)
	sXGSptr.HISPI.FRAME_CFG_X_VALID.f.X_START     = SensorParams.XGS_X_START;
	rXGSptr.HISPI.FRAME_CFG_X_VALID.u32           = sXGSptr.HISPI.FRAME_CFG_X_VALID.u32;

	// Set Location of last valid x pixel(including Interpolation) 
	sXGSptr.HISPI.FRAME_CFG_X_VALID.f.X_END       = SensorParams.XGS_X_END;
	rXGSptr.HISPI.FRAME_CFG_X_VALID.u32           = sXGSptr.HISPI.FRAME_CFG_X_VALID.u32;

	// Set complete line/frame size (including Black pixels, Interpolation, dummies, valid) 
	sXGSptr.HISPI.FRAME_CFG.f.PIXELS_PER_LINE     = SensorParams.XGS_X_SIZE;
	sXGSptr.HISPI.FRAME_CFG.f.LINES_PER_FRAME     = SensorParams.XGS_Y_SIZE;
	rXGSptr.HISPI.FRAME_CFG.u32                   = sXGSptr.HISPI.FRAME_CFG.u32;

	// Set FPGA MUX ratio and HiSPI number of lanes used
	sXGSptr.HISPI.CTRL.f.XGS_MUX_RATIO            = SensorParams.XGS_HiSPI_mux;   //static register for the moment
	sXGSptr.HISPI.CTRL.f.XGS_NB_LANES             = SensorParams.XGS_HiSPI_Ch_used; 
	rXGSptr.HISPI.CTRL.u32                        = sXGSptr.HISPI.CTRL.u32;



}