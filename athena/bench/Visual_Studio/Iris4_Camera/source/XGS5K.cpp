//-----------------------------------------------
//
//  Configuration for XGS5000
//
//-----------------------------------------------

/* Headers */
#include "stdafx.h"
#include <stdio.h> 
#include <stdlib.h>

#include "XGS_Ctrl.h"

//---------------------------------
// Constants for XGS 5K FOT  
//---------------------------------
// SFOTand EFOT numbers

// SFOT 16 lanes ->
// SFOT 4 lanes  ->
// EFOT 16 lanes ->
// EFOT 4 lanes  ->

//Short Integration time
// SFOT
// EFOT








//-----------------------------------------------
// Init specific 
//-----------------------------------------------
void CXGS_Ctrl::SetGrabParamsInit5000(int lanes)
   {

   SensorParams.SENSOR_TYPE            = 5000;
   SensorParams.XGS_HiSPI_Ch           = 16;
   SensorParams.Xsize_Full             = 2592; //+8; //8 Interpolation
   SensorParams.Ysize_Full             = 2048; //+8;

 
   if (lanes == 16)   SensorParams.FOT = unsigned long(0 / SystemPeriodNanoSecond);
   if (lanes == 4)    SensorParams.FOT = unsigned long(0 / SystemPeriodNanoSecond); // ns/sysclk

   GrabParams.FOT = 0; // FOT exprime en nombre de ligne senseur, utilise en mode EO_FOT_SEL=1.

   GrabParams.LinePitch           = SensorParams.Xsize_Full; //pour linstant 8bpp
   GrabParams.Y_START             = 0;
   GrabParams.Y_END               = SensorParams.Ysize_Full - 1;
   GrabParams.REVERSE_Y           = 0;
   GrabParams.BLACK_OFFSET        = 0x0100;     // data_pedestal
   GrabParams.ANALOG_GAIN         = 0x1;        // gain=1
						          
   printf("XGS5K Sensor detected, ");
   }




void CXGS_Ctrl::LoadDCF_5K(int lanes)
      {
      

	Initialize_sensor();             // Wait until the sensor is ready to receive register writes 
	Check_otpm_depended_uploads();   // OTM write
	if (lanes == 4)  Enable4lanes();                  
	if (lanes == 16) Enable16lanes();

	Activate_sensor();

	// Program monitor pins in XGS
	//M_UINT32 monitor_0_reg = 0x6;    // 0x6 : Real Integration  , 0x2 : Integrate
	//M_UINT32 monitor_1_reg = 0x10;   // 0x10 :EFOT indication
	//M_UINT32 monitor_2_reg = 0x1;    // New_line

	M_UINT32 monitor_0_reg = 0x0;    // modifie plus bas pour aller chercher 1 signal du datapath
	M_UINT32 monitor_1_reg = 0x10;   // 0x10 :EFOT indication
	//M_UINT32 monitor_2_reg = 0x1;    // New_line
	M_UINT32 monitor_2_reg = 0x6;  // real int
	//M_UINT32 monitor_2_reg = 0x13;  // Mline

	//Monitor 0 is Line valid
	WriteSPI(0x3806, (monitor_2_reg << 10) + (monitor_1_reg << 5) + monitor_0_reg);    // Monitor Lines
	WriteSPI(0x3602, (2 << 6) + (2 << 3) + 2);    // Monitor_ctrl

	WriteSPI(0x3e40, (0x4 << 10) + (0x4 << 5) + 0x4);    // Monitor Lines in mode MDH - Line valid
	WriteSPI(0x3602, (2 << 6) + (2 << 3) + 3);    // Monitor_ctrl

	WriteSPI(0x3812, 0);    // integration offset coarse default is 0 [3:0]


	WriteSPI(0x389c, 0);   //F_line

	// Copy some "mirror" registers from Sensor to FPGA
	sXGSptr.ACQ.SENSOR_GAIN_ANA.u32      = ReadSPI(0x3844);      //Analog Gain
	rXGSptr.ACQ.SENSOR_GAIN_ANA.u32      = sXGSptr.ACQ.SENSOR_GAIN_ANA.u32;

	sXGSptr.ACQ.SENSOR_SUBSAMPLING.u32   = ReadSPI(0x383c);      //Subsampling
	rXGSptr.ACQ.SENSOR_SUBSAMPLING.u32   = sXGSptr.ACQ.SENSOR_SUBSAMPLING.u32;

	sXGSptr.ACQ.SENSOR_M_LINES.u32       = ReadSPI(0x389a);      //M_LINES cntx(0)
	rXGSptr.ACQ.SENSOR_M_LINES.u32       = sXGSptr.ACQ.SENSOR_M_LINES.u32;

	sXGSptr.ACQ.SENSOR_F_LINES.u32       = ReadSPI(0x389c);      //F_LINES cntx(0)
	rXGSptr.ACQ.SENSOR_F_LINES.u32       = sXGSptr.ACQ.SENSOR_F_LINES.u32;

	sXGSptr.ACQ.READOUT_CFG3.f.LINE_TIME = ReadSPI(0x3810);      //LINETIME
	rXGSptr.ACQ.READOUT_CFG3.f.LINE_TIME = sXGSptr.ACQ.READOUT_CFG3.f.LINE_TIME;

      }


//-----------------------------------------
// PowerUp and wait until Sensor is rdy
//-----------------------------------------
void CXGS_Ctrl::Initialize_sensor() {

	//	Wait until the sensor is ready to receive register writes: (REG 0x3706[3:0] = 0x3) : POLL_REG = 0x3706, 0x000F, != 0x3, DELAY = 25, TIMEOUT = 500
	PollRegSPI(0x3706, 0xF, 0x3, 25, 40);

}



//-----------------------------------------
// Check if need to optimize XGS register
//-----------------------------------------
void CXGS_Ctrl::Check_otpm_depended_uploads() {

	// Checking the version of OTPM and uploading settings accordingly, reg 0x3700[5] needs to be enabled to read the OTPM version
	// apbase.log("Checking OTPM version (enable register 0x3700[5] = 1) -. reg 0x3016[3:0]")
	WriteSPI(0x3700, 0x0020);
	Sleep(50);
	//otpmversion = reg.reg(0x3016).bitfield(0xF).uncached_value
	M_UINT32 otpmversion = ReadSPI(0x3016);
	printf("XGS OTPM version : 0x%X\n", otpmversion);
	WriteSPI(0x3700, 0x0000);

	if (otpmversion == 0) {



	}

	if (otpmversion != 0) {

	}
}


//----------------------------------------------------
// This fonction load specific registers for MUX mode
//----------------------------------------------------
void CXGS_Ctrl::Enable4lanes(void) {

	printf("XGS Initializing 4 HiSPI lanes\n");
	// mux mode dependent uploads
	// Loading 4 lanes 12 bit specific settings

}

void CXGS_Ctrl::Enable24lanes(void) {

	printf("XGS Initializing 16 HiSPI lanes\n");


}

//----------------------
// Activating sensor
//----------------------
void CXGS_Ctrl::Activate_sensor() {
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