//-----------------------------------------------
//
//  Configuration for XGS12000
//
//  From WIP Last Changed Rev: WIP Last Changed Rev: 18245:  
//    C:\Aptina Imaging\apps_data\XGS12M-REV2.ini 
//    $iris4\athena\bench\XGS_OnSemi_ini_files\XGS12M-REV2.ini   
//-----------------------------------------------

/* Headers */
#include "osincludes.h"

#include "XGS_Ctrl.h"



//Derniere version du microcode de Onsemi pour la famaille XGS12K
M_UINT32 XGS12K_WIP = 18245;





//-----------------------------------------------
// Init specific 
//-----------------------------------------------
void CXGS_Ctrl::XGS12M_SetGrabParamsInit12000(int lanes, int color)
   {

   SensorParams.SENSOR_TYPE          = 12000;
   SensorParams.XGS_HiSPI_Ch         = 24;
   SensorParams.XGS_HiSPI_Ch_used    = 6;
   SensorParams.XGS_HiSPI_mux        = 4;

   SensorParams.Xsize_Full           = 4104;     // Interpolation INCLUDED
   SensorParams.Xsize_Full_valid     = 4096;     // Transfering from interpolation 0 to 4096, till we have a real ROI X

   if (color == 0) {
	   SensorParams.XGS_DMA_LinePtrWidth = 2;   //4 line buffers
	   SensorParams.Xstart_valid         = 4;
   }
   else {
	   SensorParams.XGS_DMA_LinePtrWidth = 1;   //2 line buffers
	   SensorParams.Xstart_valid         = 2;   // When color and DPC enabled, then only remove 2 pix
   }

   SensorParams.Ysize_Full           = 3080;     // Interpolation INCLUDED 
   SensorParams.Ysize_Full_valid     = 3072;     // Without any interpolation  
   SensorParams.Ystart_valid         = 4;

   SensorParams.XGS_X_START          = 32;                                                     // MONO : Location of first valid x pixel(including Interpolation, dummies, bl, valid)
   SensorParams.XGS_X_END            = SensorParams.XGS_X_START + SensorParams.Xsize_Full -1;     // MONO : Location of last valid x pixel(including Interpolation, dummies, bl, valid)
   
   SensorParams.XGS_X_SIZE           = 4176;    // FULL X, including everything
   SensorParams.XGS_Y_SIZE           = 3102;    // FULL Y, including everything (M_LINES as in the SPEC, may be modified with dcf M_LINES PROGRAMMED)                                                  // FULL Y, including everything (M_LINES as in the SPEC, may be modified with dcf M_LINES PROGRAMMED)


   // This may depend on the configuration (Lanes+LineSize) 
   if (color == 0) {
	   SensorParams.FOTn_2_EXP          = 76800;
	   SensorParams.ReadOutN_2_TrigN    = 51200;
	   SensorParams.TrigN_2_FOT         = 23000 * GrabParams.XGS_LINE_SIZE_FACTOR;
	   SensorParams.EXP_FOT             = 5400;
	   SensorParams.EXP_FOT_TIME        = SensorParams.TrigN_2_FOT + SensorParams.EXP_FOT;  //TOTAL : 23us trig fall to FOT START  + 5.36us calculated from start of FOT to end of real exposure in dev board, to validate!
	   SensorParams.KEEP_OUT_ZONE_START = 0x2bf;
   }
   else
   {
	   SensorParams.FOTn_2_EXP          = 213600;
	   SensorParams.ReadOutN_2_TrigN    = 188400;
	   SensorParams.TrigN_2_FOT         = 91600;
	   SensorParams.EXP_FOT             = 5400;
	   SensorParams.EXP_FOT_TIME        = SensorParams.TrigN_2_FOT + SensorParams.EXP_FOT;  //TOTAL : 23us trig fall to FOT START  + 5.36us calculated from start of FOT to end of real exposure in dev board, to validate!
	   SensorParams.KEEP_OUT_ZONE_START = 0xb1a;

   }


   GrabParams.FOT                    = 10; // FOT exprime en nombre de ligne senseur, utilise en mode EO_FOT_SEL=1.

   GrabParams.Y_START                = 0;
   GrabParams.Y_END                  = SensorParams.Ysize_Full - 1;
   GrabParams.BLACK_OFFSET           = 0x0100;     // data_pedestal
   GrabParams.ANALOG_GAIN            = 0x1;        // gain=1
						          
   //printf_s("XGS12M Sensor detected, ");
   }


void CXGS_Ctrl::XGS12M_SetGrabParamsInit8000(int lanes, int color)
{

	SensorParams.SENSOR_TYPE       = 8000;
	SensorParams.XGS_HiSPI_Ch      = 24;
	SensorParams.XGS_HiSPI_Ch_used = 6;
	SensorParams.XGS_HiSPI_mux     = 4;

	SensorParams.Xsize_Full         = 4104;     // Interpolation INCLUDED
	SensorParams.Xsize_Full_valid   = 4096;

	if (color == 0) {
		SensorParams.XGS_DMA_LinePtrWidth = 2;   //4 line buffers
		SensorParams.Xstart_valid         = 4;
	}
	else {
		SensorParams.XGS_DMA_LinePtrWidth = 1;   //2 line buffers
		SensorParams.Xstart_valid         = 2;   // When color and DPC enabled, then only remove 2 pix
	}



	SensorParams.Ysize_Full         = 2168;     // Interpolation INCLUDED 
	SensorParams.Ysize_Full_valid   = 2160;
	SensorParams.Ystart_valid       = 4;

	SensorParams.XGS_X_START = 32;                                                     // MONO : Location of first valid x pixel(including Interpolation, dummies, bl, valid)
	SensorParams.XGS_X_END = SensorParams.XGS_X_START + SensorParams.Xsize_Full - 1;     // MONO : Location of last valid x pixel(including Interpolation, dummies, bl, valid)

	SensorParams.XGS_X_SIZE = 4176;    // FULL X, including everything
	SensorParams.XGS_Y_SIZE = 2190;    // FULL Y, including everything (M_LINES as in the SPEC, may be modified with dcf M_LINES PROGRAMMED)                                                  // FULL Y, including everything (M_LINES as in the SPEC, may be modified with dcf M_LINES PROGRAMMED)

	// This may depend on the configuration (Lanes+LineSize) 
	if (color == 0) {
		SensorParams.FOTn_2_EXP          = 76800;
		SensorParams.ReadOutN_2_TrigN    = 51200;
		SensorParams.TrigN_2_FOT         = 23000 * GrabParams.XGS_LINE_SIZE_FACTOR;
		SensorParams.EXP_FOT             = 5400;
		SensorParams.EXP_FOT_TIME        = SensorParams.TrigN_2_FOT + SensorParams.EXP_FOT;  //TOTAL : 23us trig fall to FOT START  + 5.36us calculated from start of FOT to end of real exposure in dev board, to validate!
		SensorParams.KEEP_OUT_ZONE_START = 0x2bf;
	} 
	else
	{
		SensorParams.FOTn_2_EXP          = 213600;
		SensorParams.ReadOutN_2_TrigN    = 188000;
		SensorParams.TrigN_2_FOT         = 91600;
		SensorParams.EXP_FOT             = 5400;
		SensorParams.EXP_FOT_TIME        = SensorParams.TrigN_2_FOT + SensorParams.EXP_FOT;  //TOTAL : 23us trig fall to FOT START  + 5.36us calculated from start of FOT to end of real exposure in dev board, to validate!
		SensorParams.KEEP_OUT_ZONE_START = 0xb1a;
	}

	GrabParams.FOT = 10; // FOT exprime en nombre de ligne senseur, utilise en mode EO_FOT_SEL=1.

	GrabParams.Y_START = 0;
	GrabParams.Y_END = SensorParams.Ysize_Full - 1;
	GrabParams.BLACK_OFFSET = 0x0100;     // data_pedestal
	GrabParams.ANALOG_GAIN = 0x1;        // gain=1

	//printf_s("XGS8M Sensor detected, ");
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
	Sleep(50); //comme ds le code de onsemi
	//otpmversion = reg.reg(0x3016).bitfield(0xF).uncached_value
	M_UINT32 otpmversion = ReadSPI(0x3016);
	printf_s("XGS OTPM version : 0x%X\n", otpmversion);
	WriteSPI(0x3700, 0x0000);
	//Sleep(50);

	if (otpmversion <= 1) {

		printf_s("\n\nLa version otpm est v%d, load de la version longue de la dcf (WIP Rev: %d)\n", otpmversion, XGS12K_WIP);

		printf_s("XGS Loading required register uploads\n");
		XGS12M_Req_Reg_Up_0();
		printf_s("XGS Loading timing uploads");
		XGS12M_Timing_Up();
	}
	else
	if (otpmversion == 2) {
		  printf_s("XGS Reduced uploads required for OTPM version: v%d (WIP Rev: %d)\n", otpmversion, XGS12K_WIP);
		  XGS12M_Req_Reg_Up_2();
    }
	else
	if (otpmversion > 2) {
		printf_s("XGS Reduced uploads required for OTPM version: v%d (WIP Rev: %d), new DCF from Onsemi maybe available\n", otpmversion, XGS12K_WIP);
		XGS12M_Req_Reg_Up_2();
	}


}


//----------------------------------------------------
// This fonction load specific registers for MUX mode
//----------------------------------------------------
void CXGS_Ctrl::XGS12M_Enable6lanes(void) {

	printf_s("XGS Initializing 6 HiSPI lanes\n");
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

	//Updates to fix first frame not saturating in triggered mode(see AND90029 - D). 
    //WIP 18245
	WriteSPI(0x38CE, 0x8000);
	WriteSPI(0x38D6, 0x9FFF);
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

	//Updates to fix first frame not saturating in triggered mode(see AND90029 - D). 
	//WIP 18245
	WriteSPI(0x38CE, 0x8000);
	WriteSPI(0x38D6, 0x9FFF);

}


//-----------
// Timing UP
//-----------
const M_UINT32 REG_BURST1[] = { 0x4064, 0x5021, 0x0071, 0x5022, 0x007D, 0x5A21, 0x007D, 0x5F22, 0x007D, 0x5A21, 0x007D, 0x5034, 0x007D, 0x502F, 0x007D, 0x5027, 0x007D, 0x5021, 0x007D, 0x5522, 0x007D, 0x5021, 0x007D, 0x5022, 0x007D, 0x5031, 0x0071, 0x502F, 0x0071, 0x5022, 0x0071, 0x0021, 0x0071, 0x0031, 0x5071, 0x002F, 0x5071, 0x0023, 0x5071, 0x0021, 0x0071, 0xA032, 0x0071, 0xA02B, 0x0071, 0x2021, 0x0071, 0x200F, 0x2071, 0x200A, 0x2071, 0x2001, 0x0071, 0x600B, 0x0071, 0x4001, 0x0071, 0x400F, 0x0871, 0x400A, 0x0871, 0x4001, 0x0071, 0x501F, 0x0071, 0x501B, 0x0071, 0x500F, 0x0071, 0x5001, 0x0070, 0x5001, 0x0072, 0x5000, 0x0072 };
const M_UINT32 REG_BURST2[] = { 0x40F8, 0x5001, 0x0072, 0x501A, 0x0072, 0x500D, 0x0072, 0x5001, 0x0070, 0x5032, 0x00F0, 0x5021, 0x00F0, 0x5021, 0x0070, 0x5020, 0x0071 };
const M_UINT32 REG_BURST3[] = { 0x4118, 0x5011, 0x0072, 0x500F, 0x0072, 0x500C, 0x0072, 0x501A, 0x0072, 0x500D, 0x0072, 0x5001, 0x0070, 0x5032, 0x00F0, 0x5021, 0x00F0, 0x5021, 0x0070, 0x5020, 0x0071 };
const M_UINT32 REG_BURST4[] = { 0x4140, 0x501A, 0x0072, 0x500B, 0x0072, 0x501A, 0x0072, 0x500D, 0x0072, 0x5001, 0x0070, 0x5032, 0x00F0, 0x5021, 0x00F0, 0x5021, 0x0070, 0x5020, 0x0071 };
const M_UINT32 REG_BURST5[] = { 0x4164, 0x501F, 0x0072, 0x501F, 0x0072, 0x5013, 0x0072, 0x5007, 0x0072, 0x501A, 0x0072, 0x500D, 0x0072, 0x5001, 0x0070, 0x5032, 0x00F0, 0x5021, 0x00F0, 0x5021, 0x0070, 0x5020, 0x0071 };
const M_UINT32 REG_BURST6[] = { 0x4190, 0x5012, 0x0072, 0x500F, 0x0072, 0x5008, 0x0072, 0x501A, 0x0072, 0x500D, 0x0072, 0x5001, 0x0070, 0x5032, 0x00F0, 0x5021, 0x00F0, 0x5021, 0x0070, 0x5020, 0x0071 };
const M_UINT32 REG_BURST7[] = { 0x6420, 0x0002, 0x001C, 0x0001, 0x0000, 0x0004, 0x0160, 0x0041, 0x0160, 0x0042, 0x0160, 0x0043, 0x0160, 0x0042, 0x0060, 0x0042, 0x1060, 0x0001, 0x1060, 0x0001, 0x9060, 0x0002, 0x9060, 0x0006, 0x9060, 0x0081, 0x9060, 0x0081, 0x1060, 0x0022, 0x1060, 0x0028, 0x1060, 0x0001, 0x1020, 0x0001, 0x1000, 0x2001, 0x1000, 0x0002, 0x1000, 0x0008, 0x1200, 0x0003, 0x1000, 0x0002, 0x1004, 0x0001, 0x5000, 0xC001, 0x5002, 0xE001, 0x5002, 0xC001, 0x7002, 0x8001, 0x5002, 0x8001, 0x5002, 0x8901, 0x5002, 0xBE01, 0x5002, 0x8001, 0x7002, 0xC001, 0x5002, 0x4001, 0x5002, 0x4901, 0x5002, 0x7E01, 0x5002, 0x4001, 0x7002, 0x0001, 0x5002, 0x0001, 0x5002, 0x0901, 0x5002, 0x3E01, 0x5002, 0x0001, 0x7002, 0x4001, 0x5002, 0xC001, 0x5001, 0xC901, 0x5001, 0xFE01, 0x5001, 0xC001, 0x7001, 0x8001, 0x5001, 0x8001, 0x5001, 0x8901, 0x5001, 0xBE01, 0x5001, 0x8001, 0x7001, 0xC001, 0x5001, 0x4001, 0x5001, 0x4901, 0x5001, 0x7E01, 0x5001, 0x4001, 0x7001, 0x0001, 0x5001, 0x0001, 0x5001, 0x0901, 0x5001, 0x3E01, 0x5001, 0x0001, 0x7001, 0x4001, 0x5001, 0xC001, 0x5000, 0xC901, 0x5000, 0xFE01, 0x5000, 0xC001, 0x7000, 0x8001, 0x5000, 0x8001, 0x5000, 0x8901, 0x5000, 0x9E01, 0x5000, 0x8002, 0x5000, 0x0001, 0x1000, 0x0001, 0x100C, 0x0001, 0x106C, 0x001F, 0x1060, 0x0005, 0x1060, 0x0001, 0x1020, 0x0005, 0x1000, 0x8001, 0x5003, 0xA001, 0x1003, 0x8001, 0x1003, 0x8001, 0x1003, 0xC001, 0x1003, 0xC001, 0x3003, 0xC001, 0x1003, 0x4001, 0x1003, 0x4801, 0x1003, 0x4901, 0x1003, 0x7E01, 0x1003, 0x4001, 0x1003, 0x4001, 0x1003, 0x4001, 0x1003, 0x0001, 0x3003, 0x0001, 0x1003, 0x0001, 0x1003, 0x0801, 0x1003, 0x0901, 0x1003, 0x3E01, 0x1003, 0x0001, 0x3003, 0x4001, 0x1003, 0xC001, 0x1002, 0xC801, 0x1002, 0xC901, 0x1002, 0xFE01, 0x1002, 0xC001, 0x3002, 0x8001, 0x1002, 0x8001, 0x1002, 0x8801, 0x1002, 0x8901, 0x1002, 0xBE01, 0x1002, 0x8001, 0x3002, 0xC001, 0x1002, 0x4001, 0x1002, 0x4801, 0x1002, 0x4901, 0x1002, 0x7E01, 0x1002, 0x4001, 0x3002, 0x0001, 0x1002, 0x0001, 0x1002, 0x0801, 0x1002, 0x0901, 0x1002, 0x3E01, 0x1002, 0x0001, 0x3002, 0x4001, 0x1002, 0xC001, 0x1001, 0xC801, 0x1001, 0xC901, 0x1001, 0xFE01, 0x1001, 0xC001, 0x3001, 0x8001, 0x1001, 0x8001, 0x1001, 0x8801, 0x1001, 0x8901, 0x1001, 0xBE01, 0x1001, 0x8001, 0x3001, 0xC001, 0x1001, 0x4001, 0x1001, 0x4901, 0x1001, 0x7E01, 0x1001, 0x4001, 0x3001, 0x0001, 0x1001, 0x0001, 0x1001, 0x0901, 0x1001, 0x3E01, 0x1001, 0x0001, 0x3001, 0x4001, 0x1001, 0xC001, 0x1000, 0xC901, 0x1000, 0xFE01, 0x1000, 0xC001, 0x3000, 0x8001, 0x1000, 0x8001, 0x1000, 0x8901, 0x1000, 0x9E01, 0x1000, 0x8001, 0x1000, 0x0001, 0x1000, 0x0000, 0x1000 };

void CXGS_Ctrl::XGS12M_Timing_Up(void) {
	//[Hidden:Timing_Up]
	WriteSPI_BURST(REG_BURST1, sizeof(REG_BURST1) / sizeof(M_UINT32) );
	WriteSPI_BURST(REG_BURST2, sizeof(REG_BURST2) / sizeof(M_UINT32) );
	WriteSPI_BURST(REG_BURST3, sizeof(REG_BURST3) / sizeof(M_UINT32) );
	WriteSPI_BURST(REG_BURST4, sizeof(REG_BURST4) / sizeof(M_UINT32) );
	WriteSPI_BURST(REG_BURST5, sizeof(REG_BURST5) / sizeof(M_UINT32) );
	WriteSPI_BURST(REG_BURST6, sizeof(REG_BURST6) / sizeof(M_UINT32) );
	WriteSPI_BURST(REG_BURST7, sizeof(REG_BURST7) / sizeof(M_UINT32) );
}




