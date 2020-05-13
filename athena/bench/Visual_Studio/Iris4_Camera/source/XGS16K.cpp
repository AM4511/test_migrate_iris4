//-----------------------------------------------
//
//  Configuration for XGS16000
//
//  From WIP Last Changed Rev: 
//-----------------------------------------------

/* Headers */
#include "stdafx.h"
#include <stdio.h> 
#include <stdlib.h>

#include "XGS_Ctrl.h"










//-----------------------------------------------
// Init specific 
//-----------------------------------------------
void CXGS_Ctrl::XGS16M_SetGrabParamsInit16000(int lanes)
   {

   SensorParams.SENSOR_TYPE            = 16000;
   SensorParams.XGS_HiSPI_Ch           = 24;
   SensorParams.Xsize_Full             = 4000; //+8; // Interpolation NOT INCLUDED
   SensorParams.Ysize_Full             = 4000; //+8; // Interpolation NOT INCLUDED
 
	// This may depend on the configuration (Lanes+LineSize) 
   if (rXGSptr.ACQ.DEBUG.f.FPGA_7C706 == 1)
	   SensorParams.ReadOutN_2_TrigN = 0; //
   else
	   SensorParams.ReadOutN_2_TrigN = 0; //

   SensorParams.TrigN_2_FOT          = 0 * GrabParams.XGS_LINE_SIZE_FACTOR;

   SensorParams.EXP_FOT_TIME           = SensorParams.TrigN_2_FOT + 0;  // 0 us trig fall to FOT START  + 0us calculated from start of FOT to end of real exposure in dev board, to validate!


   //---------------------------------
   // Constants for XGS 16M FOT
   //---------------------------------
   // SFOTand EFOT numbers
   // SFOT 24 lanes ->
   // SFOT 18 lanes ->
   // SFOT 12 lanes ->
   // SFOT 6 lanes  ->
   // EFOT 24 lanes ->
   // EFOT 18 lanes ->
   // EFOT 12 lanes ->
   // EFOT 6 lanes  ->
   
   // Short Integration time
   // SFOT 24 lanes -> 
   // EFOT 24 lanes -> 

   if (lanes == 24)   SensorParams.FOT = unsigned long(0 / SystemPeriodNanoSecond);
   if (lanes == 18)   SensorParams.FOT = unsigned long(0 / SystemPeriodNanoSecond);
   if (lanes == 12)   SensorParams.FOT = unsigned long(0 / SystemPeriodNanoSecond);
   if (lanes == 6)    SensorParams.FOT = unsigned long(0 / SystemPeriodNanoSecond); // ns/sysclk

   GrabParams.FOT = 10; // FOT exprime en nombre de ligne senseur, utilise en mode EO_FOT_SEL=1.

   GrabParams.Y_START             = 0;
   GrabParams.Y_END               = SensorParams.Ysize_Full - 1;
   GrabParams.REVERSE_Y           = 0;
   GrabParams.BLACK_OFFSET        = 0x0100;     // data_pedestal
   GrabParams.ANALOG_GAIN         = 0x1;        // gain=1
						          
   printf("XGS16M Sensor detected, ");
   }


void CXGS_Ctrl::XGS16M_LoadDCF(int lanes)
{
     
	XGS_WaitRdy();                          // Wait until the sensor is ready to receive register writes 
	
	XGS16M_Check_otpm_depended_uploads();   // OTM : timing settings 
	
	XGS16M_Enable6lanes();               	// No support for other nblane for the moment

	XGS_Activate_sensor();                  // Set slave and external trig

	XGS_Config_Monitor();                   // Config monitor pins

	XGS_CopyMirror_regs();                  // Copy some "mirror" registers from Sensor to FPGA

	XGS_SetConfigFPGA();                    // Confif FPGA registers, Readout_cfg, Exposure during FOT...

}





//-----------------------------------------
// Check if need to optimize XGS register
//-----------------------------------------
void CXGS_Ctrl::XGS16M_Check_otpm_depended_uploads() {

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

	if (otpmversion == 1) {

	}

	if (otpmversion == 2) {

	}

	if (otpmversion > 2) {
		printf("New DCF must be implemented for OTPM version: 0x%X \n", otpmversion);
		exit(1);
	}

}


//----------------------------------------------------
// This fonction load specific registers for MUX mode
//----------------------------------------------------
void CXGS_Ctrl::XGS16M_Enable6lanes(void) {

	printf("XGS Initializing 6 HiSPI lanes\n");
	// mux mode dependent uploads
	// Loading 6 lanes 12 bit specific settings
	WriteSPI(0x38C4, 0x0600);

	WriteSPI(0x3A00, 0x000D);
	WriteSPI(0x3A02, 0x0001);

	WriteSPI(0x3E00, 0x0001);
	WriteSPI(0x3E28, 0x2537);
	WriteSPI(0x3E80, 0x000D);

	//WriteSPI(0x3810, 0x02DC);                                     // minimum line time
	WriteSPI(0x3810, (0x02DC)*GrabParams.XGS_LINE_SIZE_FACTOR); // To reduce framerate in PCIe x1, temporairement

	// Not used in slave mode:
	//LOG = Setting framerate to 28FPS
	//REG = 0x383A, 0x0C58
	//LOG = Setting 5ms exposure time
	//REG = 0x3840, 0x01ba
	//REG = 0x3842, 0x01c4

}






