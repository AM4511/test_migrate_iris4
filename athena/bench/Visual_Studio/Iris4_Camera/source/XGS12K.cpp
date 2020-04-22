//-----------------------------------------------
//
//  Configuration for XGS12000
//
//-----------------------------------------------

/* Headers */
#include "stdafx.h"
#include <stdio.h> 
#include <stdlib.h>

#include "XGS_Ctrl.h"

//---------------------------------
// Constants for XGS 12K FOT  greg ferrel 1/04/2020
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

//Short Integration time
// SFOT 24 lanes -> 3.605us
// EFOT 24 lanes -> 29.9us








//-----------------------------------------------
// Init specific 
//-----------------------------------------------
void CXGS_Ctrl::SetGrabParamsInit12000(int lanes)
   {

   SensorParams.SENSOR_TYPE            = 12000;
   SensorParams.XGS_HiSPI_Ch           = 24;
   SensorParams.Xsize_Full             = 4096; //+8; //8 Interpolation
   SensorParams.Ysize_Full             = 3072; //+8;

   if (lanes == 24)   SensorParams.FOT = unsigned long(29900 / SystemPeriodNanoSecond);
   if (lanes == 18)   SensorParams.FOT = unsigned long(31100 / SystemPeriodNanoSecond);
   if (lanes == 12)   SensorParams.FOT = unsigned long(50100 / SystemPeriodNanoSecond);
   if (lanes == 6)    SensorParams.FOT = unsigned long(95900 / SystemPeriodNanoSecond); // ns/sysclk

   GrabParams.FOT = 10; // FOT exprime en nombre de ligne senseur, utilise en mode EO_FOT_SEL=1.

   GrabParams.LinePitch           = SensorParams.Xsize_Full; //pour linstant 8bpp
   GrabParams.Y_START             = 0;
   GrabParams.Y_END               = SensorParams.Ysize_Full - 1;
   GrabParams.REVERSE_Y           = 0;
   GrabParams.BLACK_OFFSET        = 0x0100;     // data_pedestal
   GrabParams.ANALOG_GAIN         = 0x1;        // gain=1
						          
   printf("XGS12K Sensor detected, ");
   }




void CXGS_Ctrl::LoadDCF_12K(int lanes)
      {
      

	Initialize_sensor();             // Wait until the sensor is ready to receive register writes 
	Check_otpm_depended_uploads();   // OTM write
	if (lanes == 6)  Enable6lanes();                  
	if (lanes == 24) Enable24lanes();

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



//	  //-----------------------------------------------
//	  // Set ExposureTime during FOT, but not enabled!
//	  //-----------------------------------------------
//	  rACQ.EXP_FOT.f.EXP_FOT_TIME = (unsigned long)(27300 / 16); //P1300/P500/P300 : 27.3us calculated from DCF
//
//
//    //-------------------------------
//    // In PET engin Python inserts dummy lines before/after start of integration
//    // We set 2 dummy lines, 1 before and 1 after start of integration in PET mode
//    // see reg 224 : [0:3]-1 is the total dummy lines [4:7] is the lines before start of integration 
//    // Those dummy lines inserted are complete lines as BL lines
//    //-------------------------------
//    SensorParams.EXP_DUMMY_LINES = (ReadSPI(224) & 0xf)-1;
//
//	  //WriteSPI_B(224, 0, 3, 0xe);                    //  jmansill : Total of dummy rows inserted at Exposure , add 3-1-Reg[4:7] = 1 dummy line after exposure start)
//	  //WriteSPI_B(224, 4, 7, 0x5);                    //  jmansill : Delai start of exposure of 1 line when in PET engin, insert 1 dummy line before exposure start)	  
//
//
//
//	  EnableDecoder();                        // Enable DataPath Decoder
//	  EnableReadout();                        // Enable Frame Redaout
//	  EnableRegUpdate();                      // Enable Python Register Update by the controller
//

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

		printf("\n\nL version otpmversion devrait etre a 1 avec ce senseur!\n\n");
		exit(1);

		//apbase.log("Loading required register uploads")
		//apbase.load_preset("Req_Reg_Up")
		printf("XGS Loading required register uploads\n");
		WriteSPI(0x3428, 0xA620);
		WriteSPI(0x342A, 0x0000);
		WriteSPI(0x3430, 0x20B6);
		WriteSPI(0x3842, 0x0000);

		WriteSPI(0x38E2, 0x0000);

		WriteSPI(0x38E4, 0x0019);
		WriteSPI(0x38E6, 0x0019);
		WriteSPI(0x38E8, 0x0019);

		WriteSPI(0x3934, 0x0108);
		WriteSPI(0x3938, 0x0108);
		WriteSPI(0x393C, 0x0108);

		WriteSPI(0x3992, 0x0001);

		WriteSPI(0x389A, 0x0802); //M-lines

		WriteSPI(0x38EA, 0x003E);
		WriteSPI(0x38EC, 0x003E);
		WriteSPI(0x38EE, 0x003E);

		WriteSPI(0x38CA, 0x0707);
		WriteSPI(0x38CC, 0x0007);

		//apbase.log("Loading timing uploads")
		//apbase.load_preset("FSM_Up")
		//REG_BURST = 0x4000, ...
		printf("XGS Loading timing uploads\n");
		M_UINT32 REG_BURST1[500] = { 0x4000, 0x0001, 0x817C, 0x0012, 0xA97C, 0x000F, 0xA97C, 0x000C, 0xA97C, 0x0001, 0x817C, 0x501F, 0x817C, 0x501F, 0x817C, 0x5017, 0x817C, 0x500F, 0x817C, 0x5A01, 0x817C, 0x5F02, 0x817C, 0x5A01, 0x817C, 0x501F, 0x817C, 0x501F, 0x817C, 0x501F, 0x817C, 0x501F, 0x817C, 0x501F, 0x817C, 0x5015, 0x817C, 0x500F, 0x817C, 0x500F, 0x817C, 0x5001, 0x817C, 0x5502, 0x817C, 0x501A, 0x817C, 0x5008, 0x817C, 0x5000, 0x817C , 0xcafefade };
		M_UINT32 REG_BURST2[500] = { 0x4064, 0x5021, 0x0071, 0x5022, 0x007d, 0x5a21, 0x007d, 0x5f22, 0x007d, 0x5a21, 0x007d, 0x5034, 0x007d, 0x502f, 0x007d, 0x5027, 0x007d, 0x5021, 0x007d, 0x5522, 0x007d, 0x5021, 0x007d, 0x5022, 0x007d, 0x5031, 0x0071, 0x502f, 0x0071, 0x5022, 0x0071, 0x0021, 0x0071, 0x0031, 0x5071, 0x002f, 0x5071, 0x0023, 0x5071, 0x0021, 0x0071, 0xa032, 0x0071, 0xa02b, 0x0071, 0x2021, 0x0071, 0x200f, 0x2071, 0x200a, 0x2071, 0x2001, 0x0071, 0x600b, 0x0071, 0x4001, 0x0071, 0x400f, 0x0871, 0x400a, 0x0871, 0x4001, 0x0071, 0x501f, 0x0071, 0x501b, 0x0071, 0x500f, 0x0071, 0x5001, 0x0070, 0x5001, 0x0072, 0x5000, 0x0072, 0xcafefade };
		M_UINT32 REG_BURST3[500] = { 0x40F8, 0x5001, 0x0072, 0x501A, 0x0072, 0x500D, 0x0072, 0x5001, 0x0070, 0x5032, 0x00F0, 0x5021, 0x00F0, 0x5021, 0x0070, 0x5020, 0x0071, 0xcafefade };
		M_UINT32 REG_BURST4[500] = { 0x4118, 0x5011, 0x0072, 0x500f, 0x0072, 0x500c, 0x0072, 0x501a, 0x0072, 0x500d, 0x0072, 0x5001, 0x0070, 0x5032, 0x00f0, 0x5021, 0x00f0, 0x5021, 0x0070, 0x5020, 0x0071, 0xcafefade };
		M_UINT32 REG_BURST5[500] = { 0x4140, 0x501A, 0x0072, 0x500B, 0x0072, 0x501A, 0x0072, 0x500D, 0x0072, 0x5001, 0x0070, 0x5032, 0x00F0, 0x5021, 0x00f0, 0x5021, 0x0070, 0x5020, 0x0071, 0xcafefade };
		M_UINT32 REG_BURST6[500] = { 0x4164, 0x501F, 0x0072, 0x501F, 0x0072, 0x5013, 0x0072, 0x5007, 0x0072, 0x501A, 0x0072, 0x500D, 0x0072, 0x5001, 0x0070, 0x5032, 0x00f0, 0x5021, 0x00F0, 0x5021, 0x0070, 0x5020, 0x0071, 0xcafefade };
		M_UINT32 REG_BURST7[500] = { 0x4190, 0x5012, 0x0072, 0x500f, 0x0072, 0x5008, 0x0072, 0x501a, 0x0072, 0x500d, 0x0072, 0x5001, 0x0070, 0x5032, 0x00f0, 0x5021, 0x00f0, 0x5021, 0x0070, 0x5020, 0x0071, 0xcafefade };

		WriteSPI_BURST(REG_BURST1);
		WriteSPI_BURST(REG_BURST2);
		WriteSPI_BURST(REG_BURST3);
		WriteSPI_BURST(REG_BURST4);
		WriteSPI_BURST(REG_BURST5);
		WriteSPI_BURST(REG_BURST6);
		WriteSPI_BURST(REG_BURST7);

		//apbase.load_preset("LSM_Up")
		//No updates required as the default values are good
		printf("XGS Loading LSM_Up, No updates required as the default values are good\n");


		//apbase.load_preset("ALSM_Up")
		printf("XGS Loading ALSM_Up\n");
		M_UINT32 REG_BURST8[500] = { 0x6420, 0x0002, 0x001c, 0x0001, 0x0000, 0x0004, 0x0160, 0x0041, 0x0160, 0x0042, 0x0160, 0x0043, 0x0160, 0x0042, 0x0060, 0x0042, 0x1060, 0x0001, 0x1060, 0x0001, 0x9060, 0x0002, 0x9060, 0x0006, 0x9060, 0x0081, 0x9060, 0x0081, 0x1060, 0x0022, 0x1060, 0x0028, 0x1060, 0x0001, 0x1020, 0x0001, 0x1000, 0x2001, 0x1000, 0x0002, 0x1000, 0x0008, 0x1200, 0x0003, 0x1000, 0x0002, 0x1004, 0x0001, 0x5000, 0xc001, 0x5002, 0xe001, 0x5002, 0xc001, 0x7002, 0x8001, 0x5002, 0x8001, 0x5002, 0x8901, 0x5002, 0xbe01, 0x5002, 0x8001, 0x7002, 0xc001, 0x5002, 0x4001, 0x5002, 0x4901, 0x5002, 0x7e01, 0x5002, 0x4001, 0x7002, 0x0001, 0x5002, 0x0001, 0x5002, 0x0901, 0x5002, 0x3e01, 0x5002, 0x0001, 0x7002, 0x4001, 0x5002, 0xc001, 0x5001, 0xc901, 0x5001, 0xfe01, 0x5001, 0xc001, 0x7001, 0x8001, 0x5001, 0x8001, 0x5001, 0x8901, 0x5001, 0xbe01, 0x5001, 0x8001, 0x7001, 0xc001, 0x5001, 0x4001, 0x5001, 0x4901, 0x5001, 0x7e01, 0x5001, 0x4001, 0x7001, 0x0001, 0x5001, 0x0001, 0x5001, 0x0901, 0x5001, 0x3e01, 0x5001, 0x0001, 0x7001, 0x4001, 0x5001, 0xc001, 0x5000, 0xc901, 0x5000, 0xfe01, 0x5000, 0xc001, 0x7000, 0x8001, 0x5000, 0x8001, 0x5000, 0x8901, 0x5000, 0x9e01, 0x5000, 0x8002, 0x5000, 0x0001, 0x1000, 0x0001, 0x100c, 0x0001, 0x106c, 0x001f, 0x1060, 0x0005, 0x1060, 0x0001, 0x1020, 0x0005, 0x1000, 0x8001, 0x5003, 0xa001, 0x1003, 0x8001, 0x1003, 0x8001, 0x1003, 0xc001, 0x1003, 0xc001, 0x3003, 0xc001, 0x1003, 0x4001, 0x1003, 0x4801, 0x1003, 0x4901, 0x1003, 0x7e01, 0x1003, 0x4001, 0x1003, 0x4001, 0x1003, 0x4001, 0x1003, 0x0001, 0x3003, 0x0001, 0x1003, 0x0001, 0x1003, 0x0801, 0x1003, 0x0901, 0x1003, 0x3e01, 0x1003, 0x0001, 0x3003, 0x4001, 0x1003, 0xc001, 0x1002, 0xc801, 0x1002, 0xc901, 0x1002, 0xfe01, 0x1002, 0xc001, 0x3002, 0x8001, 0x1002, 0x8001, 0x1002, 0x8801, 0x1002, 0x8901, 0x1002, 0xbe01, 0x1002, 0x8001, 0x3002, 0xc001, 0x1002, 0x4001, 0x1002, 0x4901, 0x1002, 0x7e01, 0x1002, 0x4001, 0x3002, 0x0001, 0x1002, 0x0001, 0x1002, 0x0901, 0x1002, 0x3e01, 0x1002, 0x0001, 0x3002, 0x4001, 0x1002, 0xc001, 0x1001, 0xc901, 0x1001, 0xfe01, 0x1001, 0xc001, 0x3001, 0x8001, 0x1001, 0x8001, 0x1001, 0x8901, 0x1001, 0xbe01, 0x1001, 0x8001, 0x3001, 0xc001, 0x1001, 0x4001, 0x1001, 0x4901, 0x1001, 0x7e01, 0x1001, 0x4001, 0x3001, 0x0001, 0x1001, 0x0001, 0x1001, 0x0901, 0x1001, 0x3e01, 0x1001, 0x0001, 0x3001, 0x4001, 0x1001, 0xc001, 0x1000, 0xc901, 0x1000, 0xfe01, 0x1000, 0xc001, 0x3000, 0x8001, 0x1000, 0x8001, 0x1000, 0x8901, 0x1000, 0x9e01, 0x1000, 0x8001, 0x1000, 0x0001, 0x1000, 0x0000, 0x1000, 0xcafefade };
		WriteSPI_BURST(REG_BURST8);

	}

	if (otpmversion != 0) {
		printf("No timing uploads necessary for OTPM version: 0x%X\n", otpmversion);
		printf("Loading required register uploads\n");

		//apbase.load_preset("Req_Reg_Up_1")
		//Section Req_Reg_Up_1:
		WriteSPI(0x38EA, 0x003E);
		WriteSPI(0x38EC, 0x003E);
		WriteSPI(0x38EE, 0x003E);

		WriteSPI(0x38CA, 0x0707);
		WriteSPI(0x38CC, 0x0007);
		WriteSPI(0x389A, 0x0C03); //M-lines 3-3
	}
}


//----------------------------------------------------
// This fonction load specific registers for MUX mode
//----------------------------------------------------
void CXGS_Ctrl::Enable6lanes(void) {

	printf("XGS Initializing 6 HiSPI lanes\n");
	// mux mode dependent uploads
	// Loading 6 lanes 12 bit specific settings
	WriteSPI(0x38C4, 0x0600);

	WriteSPI(0x3A00, 0x000D);
	WriteSPI(0x3A02, 0x0001);

	WriteSPI(0x3E00, 0x0001);
	WriteSPI(0x3E28, 0x2537);
	WriteSPI(0x3E80, 0x000D);

	WriteSPI(0x3810, 0x02DC); // minimum line time

	// Not used in slave mode:
	//LOG = Setting framerate to 28FPS
	//REG = 0x383A, 0x0C58
	//LOG = Setting 5ms exposure time
	//REG = 0x3840, 0x01ba
	//REG = 0x3842, 0x01c4

}

void CXGS_Ctrl::Enable24lanes(void) {

	printf("XGS Initializing 24 HiSPI lanes\n");

	// Loading 24 lanes 12 bit specific settings
	WriteSPI(0x38C4, 0x1300);

	WriteSPI(0x3A00, 0x000A);
	WriteSPI(0x3A02, 0x0001);

	WriteSPI(0x3E00, 0x0008);
	WriteSPI(0x3E28, 0x2507);
	WriteSPI(0x3E80, 0x0001);

	WriteSPI(0x3810, 0x00E6); // minimum line time

	//LOG = Setting framerate to 90FPS
	WriteSPI(0x383A, 0x0C3A);

	//LOG = Setting 5ms exposure time
	WriteSPI(0x3840, 0x0580);
	WriteSPI(0x3842, 0x009c);
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