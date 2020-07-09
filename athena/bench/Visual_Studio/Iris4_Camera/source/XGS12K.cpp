//-----------------------------------------------
//
//  Configuration for XGS12000
//
//  From WIP Last Changed Rev: WIP Last Changed Rev: 17021:  C:\Aptina Imaging\apps_data\XGS12M-REV2.ini 
//-----------------------------------------------

/* Headers */
#include "stdafx.h"
#include <stdio.h> 
#include <stdlib.h>

#include "XGS_Ctrl.h"



//Derniere version du microcode de Onsemi pour la famaille XGS12K
M_UINT32 XGS12K_WIP = 17021;





//-----------------------------------------------
// Init specific 
//-----------------------------------------------
void CXGS_Ctrl::XGS12M_SetGrabParamsInit12000(int lanes)
   {

   SensorParams.SENSOR_TYPE            = 12000;
   SensorParams.XGS_HiSPI_Ch           = 24;

   SensorParams.Xsize_Full = 4096;             //+8; // Interpolation NOT INCLUDED
   SensorParams.Ysize_Full = 3072;             //+8; // Interpolation NOT INCLUDED 

   SensorParams.XGS_X_START            = 36;                                                     // MONO : Location of first valid x pixel(including Interpolation, dummies, bl, valid)
   SensorParams.XGS_X_END              = SensorParams.XGS_X_START + SensorParams.Xsize_Full - 1; // MONO : Location of last valid x pixel(including Interpolation, dummies, bl, valid)
   SensorParams.XGS_X_SIZE             = 4176;                                                   // FULL X, including everything
   
   SensorParams.Trig_2_EXP             = 76800;

   // This may depend on the configuration (Lanes+LineSize) 
   SensorParams.ReadOutN_2_TrigN     = 51200; 

   SensorParams.TrigN_2_FOT          = 23000 * GrabParams.XGS_LINE_SIZE_FACTOR;

   SensorParams.EXP_FOT              = 5400;

   SensorParams.EXP_FOT_TIME         = SensorParams.TrigN_2_FOT + SensorParams.EXP_FOT;  //TOTAL : 23us trig fall to FOT START  + 5.36us calculated from start of FOT to end of real exposure in dev board, to validate!

   SensorParams.KEEP_OUT_ZONE_START  = 0x2bf;

   //---------------------------------
   // Constants for XGS 12M FOT  greg ferrel 1/04/2020
   //---------------------------------
   // SFOTand EFOT numbers
   // SFOT 24 lanes -> 14.4us
   // SFOT 18 lanes -> 15.2us
   // SFOT 12 lanes -> 22.9us
   // SFOT 6 lanes ->  45.76us -> 4.05 lines
   // EFOT 24 lanes-> 29.9us
   // EFOT 18 lanes -> 31.1us
   // EFOT 12 lanes ->50.1us
   // EFOT 6 lanes ->  95.9us
   
   // Short Integration time
   // SFOT 24 lanes -> 3.605us
   // EFOT 24 lanes -> 29.9us

   if (lanes == 24)   SensorParams.FOT = unsigned long(29900 / SystemPeriodNanoSecond);
   if (lanes == 18)   SensorParams.FOT = unsigned long(31100 / SystemPeriodNanoSecond);
   if (lanes == 12)   SensorParams.FOT = unsigned long(50100 / SystemPeriodNanoSecond);
   if (lanes == 6)    SensorParams.FOT = unsigned long(95900 / SystemPeriodNanoSecond); // ns/sysclk

   GrabParams.FOT = 10; // FOT exprime en nombre de ligne senseur, utilise en mode EO_FOT_SEL=1.

   GrabParams.Y_START             = 0;
   GrabParams.Y_END               = SensorParams.Ysize_Full - 1;
   GrabParams.REVERSE_Y           = 0;
   GrabParams.BLACK_OFFSET        = 0x0100;     // data_pedestal
   GrabParams.ANALOG_GAIN         = 0x1;        // gain=1
						          
   printf("XGS12M Sensor detected, ");
   }

void CXGS_Ctrl::XGS12M_SetGrabParamsInit9400(int lanes)
{

	SensorParams.SENSOR_TYPE  = 9400;
	SensorParams.XGS_HiSPI_Ch = 24;

	SensorParams.Xsize_Full = 3072; //+8; // Interpolation NOT INCLUDED
	SensorParams.Ysize_Full = 3072; //+8; // Interpolation NOT INCLUDED

	SensorParams.XGS_X_START = 548;                                                    // MONO : Location of first valid x pixel(including Interpolation, dummies, bl, valid)
	SensorParams.XGS_X_END   = SensorParams.XGS_X_START + SensorParams.Xsize_Full - 1; // MONO : Location of last valid x pixel(including Interpolation, dummies, bl, valid)
	SensorParams.XGS_X_SIZE  = 4176;                                                   // FULL X, including everything


  
	// This may depend on the configuration (Lanes+LineSize) 
	SensorParams.ReadOutN_2_TrigN = 0; //

	SensorParams.TrigN_2_FOT = 0 * GrabParams.XGS_LINE_SIZE_FACTOR;

	SensorParams.EXP_FOT_TIME = SensorParams.TrigN_2_FOT + 0;  //0us trig fall to FOT START  + 0us calculated from start of FOT to end of real exposure in dev board, to validate!

	SensorParams.KEEP_OUT_ZONE_START = 0x2bf;

	//---------------------------------
	// Constants for XGS 9.4M FOT
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

	GrabParams.Y_START      = 0;
	GrabParams.Y_END        = SensorParams.Ysize_Full - 1;
	GrabParams.REVERSE_Y    = 0;
	GrabParams.BLACK_OFFSET = 0x0100;     // data_pedestal
	GrabParams.ANALOG_GAIN  = 0x1;        // gain=1

	printf("XGS9.4M Sensor detected, ");
}

void CXGS_Ctrl::XGS12M_SetGrabParamsInit8000(int lanes)
{

	SensorParams.SENSOR_TYPE = 8000;
	SensorParams.XGS_HiSPI_Ch = 24;

	SensorParams.Xsize_Full = 4096; //+8; // Interpolation NOT INCLUDED
	SensorParams.Ysize_Full = 2160; //+8; // Interpolation NOT INCLUDED

	SensorParams.XGS_X_START = 36;                                                     // MONO : Location of first valid x pixel(including Interpolation, dummies, bl, valid)
	SensorParams.XGS_X_END   = SensorParams.XGS_X_START + SensorParams.Xsize_Full - 1; // MONO : Location of last valid x pixel(including Interpolation, dummies, bl, valid)
	SensorParams.XGS_X_SIZE  = 4176;                                                   // FULL X, including everything

    // This may depend on the configuration (Lanes+SensorArea)
	SensorParams.ReadOutN_2_TrigN = 0;  // in ns
	SensorParams.TrigN_2_FOT      = 0;  // in ns
	
    SensorParams.ReadOutN_2_TrigN = 0; //

	SensorParams.TrigN_2_FOT = 0 * GrabParams.XGS_LINE_SIZE_FACTOR;

	SensorParams.EXP_FOT_TIME = SensorParams.TrigN_2_FOT + 0;  //0us trig fall to FOT START  + 0us calculated from start of FOT to end of real exposure in dev board, to validate!

	SensorParams.KEEP_OUT_ZONE_START = 0x2bf;


	//---------------------------------
	// Constants for XGS 9.4M FOT
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

	GrabParams.Y_START = 0;
	GrabParams.Y_END = SensorParams.Ysize_Full - 1;
	GrabParams.REVERSE_Y = 0;
	GrabParams.BLACK_OFFSET = 0x0100;     // data_pedestal
	GrabParams.ANALOG_GAIN = 0x1;        // gain=1

	printf("XGS8M Sensor detected, ");
}

void CXGS_Ctrl::XGS12M_LoadDCF(int lanes)
{
     
	XGS_WaitRdy();                          // Wait until the sensor is ready to receive register writes 
	
	XGS12M_Check_otpm_depended_uploads();   // OTM : timing settings 
	
	XGS12M_Enable6lanes();               	// No support for other nblane for the moment

	XGS_Activate_sensor();                  // Set slave and external trig

	XGS_Config_Monitor();                   // Config monitor pins

	XGS_CopyMirror_regs();                  // Copy some "mirror" registers from Sensor to FPGA

	XGS_SetConfigFPGA();                    // Confif FPGA registers, Readout_cfg, Exposure during FOT...

}





//-----------------------------------------
// Check if need to optimize XGS register
//-----------------------------------------
void CXGS_Ctrl::XGS12M_Check_otpm_depended_uploads() {

	// Checking the version of OTPM and uploading settings accordingly, reg 0x3700[5] needs to be enabled to read the OTPM version
	// apbase.log("Checking OTPM version (enable register 0x3700[5] = 1) -. reg 0x3016[3:0]")
	WriteSPI(0x3700, 0x0020);
	Sleep(50);
	//otpmversion = reg.reg(0x3016).bitfield(0xF).uncached_value
	M_UINT32 otpmversion = ReadSPI(0x3016);
	printf("XGS OTPM version : 0x%X\n", otpmversion);
	WriteSPI(0x3700, 0x0000);

	if (otpmversion <= 1) {

		printf("\n\nLa version otpm est v%d, load de la version longue de la dcf (WIP Rev: %d)\n", otpmversion, XGS12K_WIP);

		printf("XGS Loading required register uploads\n");
		XGS12M_Req_Reg_Up_0();
		printf("XGS Loading timing uploads");
		XGS12M_Timing_Up();
	}
	else
	if (otpmversion == 2) {
		  printf("XGS Reduced uploads required for OTPM version: v%d (WIP Rev: %d)\n", otpmversion, XGS12K_WIP);
		  XGS12M_Req_Reg_Up_2();
    }
	else
	if (otpmversion > 2) {
		printf("XGS Reduced uploads required for OTPM version: v%d (WIP Rev: %d), new DCF from Onsemi maybe available\n", otpmversion, XGS12K_WIP);
		XGS12M_Req_Reg_Up_2();
	}


}


//----------------------------------------------------
// This fonction load specific registers for MUX mode
//----------------------------------------------------
void CXGS_Ctrl::XGS12M_Enable6lanes(void) {

	printf("XGS Initializing 6 HiSPI lanes\n");
	// mux mode dependent uploads
	// Loading 6 lanes 12 bit specific settings
	WriteSPI(0x38C4, 0x0600);

	WriteSPI(0x3A00, 0x000D);
	WriteSPI(0x3A02, 0x0001);

	WriteSPI(0x3E00, 0x0001);
	WriteSPI(0x3E28, 0x2537);
	WriteSPI(0x3E80, 0x000D);

	WriteSPI(0x3810, 0x02DC*GrabParams.XGS_LINE_SIZE_FACTOR);                                     // minimum line time

	// Not used in slave mode:
	//LOG = Setting framerate to 28FPS
	//REG = 0x383A, 0x0C58
	//LOG = Setting 5ms exposure time
	//REG = 0x3840, 0x01ba
	//REG = 0x3842, 0x01c4

}

void CXGS_Ctrl::XGS12M_Req_Reg_Up_0(void) {
	//[Hidden:Req_Reg_Up_0]
	WriteSPI(0x3992, 0x0001);
	WriteSPI(0x389a, 0x0802);
	WriteSPI(0x38e4, 0x0019);
	WriteSPI(0x38e6, 0x0019);
	WriteSPI(0x38e8, 0x0019);
	WriteSPI(0x38ca, 0x0707);
	WriteSPI(0x38ea, 0x003E);
	WriteSPI(0x38ec, 0x003E);
	WriteSPI(0x38cc, 0x0007);
	WriteSPI(0x38ee, 0x003E);
	WriteSPI(0x3934, 0x0108);
	WriteSPI(0x3938, 0x0108);
	WriteSPI(0x393c, 0x0108);
	WriteSPI(0x3944, 0x0108);
	WriteSPI(0x3936, 0x0108);
	WriteSPI(0x393a, 0x0108);
	WriteSPI(0x393e, 0x0108);
	WriteSPI(0x3946, 0x0108);
	WriteSPI(0x3948, 0x0108);
	WriteSPI(0x394c, 0x0108);
	WriteSPI(0x3950, 0x0108);
	WriteSPI(0x3958, 0x0108);
	WriteSPI(0x394a, 0x0108);
	WriteSPI(0x394e, 0x0108);
	WriteSPI(0x3952, 0x0108);
	WriteSPI(0x395a, 0x0108);
	WriteSPI(0x3928, 0x0108);
	WriteSPI(0x3930, 0x0108);
	WriteSPI(0x392a, 0x0108);
	WriteSPI(0x3932, 0x0108);
	WriteSPI(0x3954, 0x0095);
	WriteSPI(0x3956, 0x0095);
	WriteSPI(0x383a, 0x0C20);
	WriteSPI(0x3430, 0x20B6);
	WriteSPI(0x3428, 0xA620);
	WriteSPI(0x342a, 0x0000);
}

void CXGS_Ctrl::XGS12M_Req_Reg_Up_2(void) {
	//[Hidden:Req_Reg_Up_2]
	WriteSPI(0x389a, 0x0802);
	WriteSPI(0x38ca, 0x0707);
	WriteSPI(0x38ea, 0x003E);
	WriteSPI(0x38ec, 0x003E);
	WriteSPI(0x38cc, 0x0007);
	WriteSPI(0x38ee, 0x003E);
	WriteSPI(0x3944, 0x0108);
	WriteSPI(0x3936, 0x0108);
	WriteSPI(0x393a, 0x0108);
	WriteSPI(0x393e, 0x0108);
	WriteSPI(0x3946, 0x0108);
	WriteSPI(0x3948, 0x0108);
	WriteSPI(0x394c, 0x0108);
	WriteSPI(0x3950, 0x0108);
	WriteSPI(0x3958, 0x0108);
	WriteSPI(0x394a, 0x0108);
	WriteSPI(0x394e, 0x0108);
	WriteSPI(0x3952, 0x0108);
	WriteSPI(0x395a, 0x0108);
	WriteSPI(0x3928, 0x0108);
	WriteSPI(0x3930, 0x0108);
	WriteSPI(0x392a, 0x0108);
	WriteSPI(0x3932, 0x0108);
	WriteSPI(0x3954, 0x0095);
	WriteSPI(0x3956, 0x0095);
	WriteSPI(0x383a, 0x0C20);
}

void CXGS_Ctrl::XGS12M_Timing_Up(void) {
	//[Hidden:Timing_Up]

	M_UINT32 REG_BURST1[500] = { 0x4064, 0x5021, 0x0071, 0x5022, 0x007D, 0x5A21, 0x007D, 0x5F22, 0x007D, 0x5A21, 0x007D, 0x5034, 0x007D, 0x502F, 0x007D, 0x5027, 0x007D, 0x5021, 0x007D, 0x5522, 0x007D, 0x5021, 0x007D, 0x5022, 0x007D, 0x5031, 0x0071, 0x502F, 0x0071, 0x5022, 0x0071, 0x0021, 0x0071, 0x0031, 0x5071, 0x002F, 0x5071, 0x0023, 0x5071, 0x0021, 0x0071, 0xA032, 0x0071, 0xA02B, 0x0071, 0x2021, 0x0071, 0x200F, 0x2071, 0x200A, 0x2071, 0x2001, 0x0071, 0x600B, 0x0071, 0x4001, 0x0071, 0x400F, 0x0871, 0x400A, 0x0871, 0x4001, 0x0071, 0x501F, 0x0071, 0x501B, 0x0071, 0x500F, 0x0071, 0x5001, 0x0070, 0x5001, 0x0072, 0x5000, 0x0072, 0xcafefade };
	M_UINT32 REG_BURST2[500] = { 0x40F8, 0x5001, 0x0072, 0x501A, 0x0072, 0x500D, 0x0072, 0x5001, 0x0070, 0x5032, 0x00F0, 0x5021, 0x00F0, 0x5021, 0x0070, 0x5020, 0x0071, 0xcafefade };
	M_UINT32 REG_BURST3[500] = { 0x4118, 0x5011, 0x0072, 0x500F, 0x0072, 0x500C, 0x0072, 0x501A, 0x0072, 0x500D, 0x0072, 0x5001, 0x0070, 0x5032, 0x00F0, 0x5021, 0x00F0, 0x5021, 0x0070, 0x5020, 0x0071, 0xcafefade };
	M_UINT32 REG_BURST4[500] = { 0x4140, 0x501A, 0x0072, 0x500B, 0x0072, 0x501A, 0x0072, 0x500D, 0x0072, 0x5001, 0x0070, 0x5032, 0x00F0, 0x5021, 0x00F0, 0x5021, 0x0070, 0x5020, 0x0071, 0xcafefade };
	M_UINT32 REG_BURST5[500] = { 0x4164, 0x501F, 0x0072, 0x501F, 0x0072, 0x5013, 0x0072, 0x5007, 0x0072, 0x501A, 0x0072, 0x500D, 0x0072, 0x5001, 0x0070, 0x5032, 0x00F0, 0x5021, 0x00F0, 0x5021, 0x0070, 0x5020, 0x0071, 0xcafefade };
	M_UINT32 REG_BURST6[500] = { 0x4190, 0x5012, 0x0072, 0x500F, 0x0072, 0x5008, 0x0072, 0x501A, 0x0072, 0x500D, 0x0072, 0x5001, 0x0070, 0x5032, 0x00F0, 0x5021, 0x00F0, 0x5021, 0x0070, 0x5020, 0x0071, 0xcafefade };
	M_UINT32 REG_BURST7[500] = { 0x6420, 0x0002, 0x001C, 0x0001, 0x0000, 0x0004, 0x0160, 0x0041, 0x0160, 0x0042, 0x0160, 0x0043, 0x0160, 0x0042, 0x0060, 0x0042, 0x1060, 0x0001, 0x1060, 0x0001, 0x9060, 0x0002, 0x9060, 0x0006, 0x9060, 0x0081, 0x9060, 0x0081, 0x1060, 0x0022, 0x1060, 0x0028, 0x1060, 0x0001, 0x1020, 0x0001, 0x1000, 0x2001, 0x1000, 0x0002, 0x1000, 0x0008, 0x1200, 0x0003, 0x1000, 0x0002, 0x1004, 0x0001, 0x5000, 0xC001, 0x5002, 0xE001, 0x5002, 0xC001, 0x7002, 0x8001, 0x5002, 0x8001, 0x5002, 0x8901, 0x5002, 0xBE01, 0x5002, 0x8001, 0x7002, 0xC001, 0x5002, 0x4001, 0x5002, 0x4901, 0x5002, 0x7E01, 0x5002, 0x4001, 0x7002, 0x0001, 0x5002, 0x0001, 0x5002, 0x0901, 0x5002, 0x3E01, 0x5002, 0x0001, 0x7002, 0x4001, 0x5002, 0xC001, 0x5001, 0xC901, 0x5001, 0xFE01, 0x5001, 0xC001, 0x7001, 0x8001, 0x5001, 0x8001, 0x5001, 0x8901, 0x5001, 0xBE01, 0x5001, 0x8001, 0x7001, 0xC001, 0x5001, 0x4001, 0x5001, 0x4901, 0x5001, 0x7E01, 0x5001, 0x4001, 0x7001, 0x0001, 0x5001, 0x0001, 0x5001, 0x0901, 0x5001, 0x3E01, 0x5001, 0x0001, 0x7001, 0x4001, 0x5001, 0xC001, 0x5000, 0xC901, 0x5000, 0xFE01, 0x5000, 0xC001, 0x7000, 0x8001, 0x5000, 0x8001, 0x5000, 0x8901, 0x5000, 0x9E01, 0x5000, 0x8002, 0x5000, 0x0001, 0x1000, 0x0001, 0x100C, 0x0001, 0x106C, 0x001F, 0x1060, 0x0005, 0x1060, 0x0001, 0x1020, 0x0005, 0x1000, 0x8001, 0x5003, 0xA001, 0x1003, 0x8001, 0x1003, 0x8001, 0x1003, 0xC001, 0x1003, 0xC001, 0x3003, 0xC001, 0x1003, 0x4001, 0x1003, 0x4801, 0x1003, 0x4901, 0x1003, 0x7E01, 0x1003, 0x4001, 0x1003, 0x4001, 0x1003, 0x4001, 0x1003, 0x0001, 0x3003, 0x0001, 0x1003, 0x0001, 0x1003, 0x0801, 0x1003, 0x0901, 0x1003, 0x3E01, 0x1003, 0x0001, 0x3003, 0x4001, 0x1003, 0xC001, 0x1002, 0xC801, 0x1002, 0xC901, 0x1002, 0xFE01, 0x1002, 0xC001, 0x3002, 0x8001, 0x1002, 0x8001, 0x1002, 0x8801, 0x1002, 0x8901, 0x1002, 0xBE01, 0x1002, 0x8001, 0x3002, 0xC001, 0x1002, 0x4001, 0x1002, 0x4801, 0x1002, 0x4901, 0x1002, 0x7E01, 0x1002, 0x4001, 0x3002, 0x0001, 0x1002, 0x0001, 0x1002, 0x0801, 0x1002, 0x0901, 0x1002, 0x3E01, 0x1002, 0x0001, 0x3002, 0x4001, 0x1002, 0xC001, 0x1001, 0xC801, 0x1001, 0xC901, 0x1001, 0xFE01, 0x1001, 0xC001, 0x3001, 0x8001, 0x1001, 0x8001, 0x1001, 0x8801, 0x1001, 0x8901, 0x1001, 0xBE01, 0x1001, 0x8001, 0x3001, 0xC001, 0x1001, 0x4001, 0x1001, 0x4901, 0x1001, 0x7E01, 0x1001, 0x4001, 0x3001, 0x0001, 0x1001, 0x0001, 0x1001, 0x0901, 0x1001, 0x3E01, 0x1001, 0x0001, 0x3001, 0x4001, 0x1001, 0xC001, 0x1000, 0xC901, 0x1000, 0xFE01, 0x1000, 0xC001, 0x3000, 0x8001, 0x1000, 0x8001, 0x1000, 0x8901, 0x1000, 0x9E01, 0x1000, 0x8001, 0x1000, 0x0001, 0x1000, 0x0000, 0x1000, 0xcafefade };

	WriteSPI_BURST(REG_BURST1);
	WriteSPI_BURST(REG_BURST2);
	WriteSPI_BURST(REG_BURST3);
	WriteSPI_BURST(REG_BURST4);
	WriteSPI_BURST(REG_BURST5);
	WriteSPI_BURST(REG_BURST6);
	WriteSPI_BURST(REG_BURST7);
}




