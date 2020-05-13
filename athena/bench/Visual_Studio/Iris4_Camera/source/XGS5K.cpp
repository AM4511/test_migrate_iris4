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
void CXGS_Ctrl::XGS5M_SetGrabParamsInit5000(int lanes)
   {

   SensorParams.SENSOR_TYPE            = 5000;
   SensorParams.XGS_HiSPI_Ch           = 16;
   SensorParams.Xsize_Full             = 2592; //+8; //8 Interpolation
   SensorParams.Ysize_Full             = 2048; //+8;

   // This may depend on the configuration (Lanes+LineSize) 
   if (rXGSptr.ACQ.DEBUG.f.FPGA_7C706 == 1)
	   SensorParams.ReadOutN_2_TrigN = 0; //
   else
	   SensorParams.ReadOutN_2_TrigN = 0; //

   SensorParams.TrigN_2_FOT = 0 * GrabParams.XGS_LINE_SIZE_FACTOR;

   SensorParams.EXP_FOT_TIME = SensorParams.TrigN_2_FOT + 0;  //0us trig fall to FOT START  + 0us calculated from start of FOT to end of real exposure in dev board, to validate!


   if (lanes == 16)   SensorParams.FOT = unsigned long(0 / SystemPeriodNanoSecond);
   if (lanes == 4)    SensorParams.FOT = unsigned long(0 / SystemPeriodNanoSecond); // ns/sysclk

   GrabParams.FOT = 0; // FOT exprime en nombre de ligne senseur, utilise en mode EO_FOT_SEL=1.

   GrabParams.Y_START             = 0;
   GrabParams.Y_END               = SensorParams.Ysize_Full - 1;
   GrabParams.REVERSE_Y           = 0;
   GrabParams.BLACK_OFFSET        = 0x0100;     // data_pedestal
   GrabParams.ANALOG_GAIN         = 0x1;        // gain=1
						          
   printf("XGS5K Sensor detected, ");
   }




void CXGS_Ctrl::XGS5M_LoadDCF(int lanes) {
      
	XGS_WaitRdy();                          // Wait until the sensor is ready to receive register writes 

	XGS5M_Check_otpm_depended_uploads();    // OTM : timing settings 

	XGS5M_Enable4lanes();               	// No support for other nblane for the moment

	XGS_Activate_sensor();                  // Set slave and external trig

	XGS_Config_Monitor();                   // Config monitor pins

	XGS_CopyMirror_regs();                  // Copy some "mirror" registers from Sensor to FPGA

	XGS_SetConfigFPGA();                    // Confif FPGA registers, Readout_cfg, Exposure during FOT...
}




//-----------------------------------------
// Check if need to optimize XGS register
//-----------------------------------------
void CXGS_Ctrl::XGS5M_Check_otpm_depended_uploads() {

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
void CXGS_Ctrl::XGS5M_Enable4lanes(void) {

	printf("XGS Initializing 4 HiSPI lanes\n");
	// mux mode dependent uploads
	// Loading 4 lanes 12 bit specific settings

}


