//-----------------------------------------------
//
//  Simple HW test test grab Iris4
//  trig is HW timer
//
//  Mono and COLOR sensor
//
//-----------------------------------------------

/* Headers */
#include "osincludes.h"

#include <iostream>
using namespace std;

#include <mil.h>

#include "MilLayer.h"
#include "XGS_Ctrl.h"
#include "XGS_Data.h"
#include "Pcie.h"

void test_0003_HW_Timer(CPcie* Pcie, CXGS_Ctrl* XGS_Ctrl, CXGS_Data* XGS_Data)
   {
	
	MIL_ID MilDisplay;
	MIL_ID MilGrabBuffer;
	M_UINT64 ImageBufferAddr = 0;

	MIL_ID MilGrabBufferR;
	M_UINT64 ImageBufferAddrR = 0;

	MIL_ID MilGrabBufferG;
	M_UINT64 ImageBufferAddrG = 0;

	MIL_ID MilGrabBufferB;

	MIL_INT  ImageBufferLinePitch = 0;

	int MonoType = 8;
	int YUVType = 16;
	int PlanarType = 24;
	int RGB32Type = 32;

	int Color_type = 0;
	int RGB32 = 0;
	int PLANAR = 0;
	int YUV = 0;
	int RAW = 0;
	int COLOR_Y = 0;

	int BYTE_PER_PIXEL = 1;

	int getch_return;
	int Sortie = 0;
	char ch;

	bool CheckCRC   = true;
	bool DisplayOn  = true;
	int PolldoSleep =0;
	bool FPS_On     = true;

	M_UINT32 LUT_PATTERN = 0;

	M_UINT32 Tmissed;
	M_UINT32 ExposureIncr = 10;
	M_UINT32 BlackOffset  = 0x100;

	M_UINT32 XGSStart_Y = 0;
	M_UINT32 XGSSize_Y = 0;
	M_UINT32 OVERSCAN_Y = 0;

	M_UINT32 XGSStart_X = 0;
	M_UINT32 XGSSize_X = 0;

	M_UINT32 SubX = 0;
	M_UINT32 SubY = 0;

	M_UINT32 XGSTestImageMode = 0;

	GrabParamStruct*   GrabParams   = XGS_Ctrl->getGrabParams();         // This is a Local Pointer to grab parameter structure
	SensorParamStruct* SensorParams = XGS_Ctrl->getSensorParams();
	DMAParamStruct*    DMAParams    = XGS_Data->getDMAParams();             // This is a Local Pointer to DMA parameter structure

	M_UINT32 FileDumpNum = 0;

	printf_s("\n\n********************************\n");
	printf_s(    "*    Executing Test0003.cpp    *\n");
	printf_s(    "********************************\n\n");



	//------------------------------
    // INITIALIZE XGS SENSOR
    //------------------------------
	XGS_Ctrl->InitXGS();

	//---------------------------------
	// Calibrate FPGA HiSPI interface
	//---------------------------------
	XGS_Data->HiSpiCalibrate(1);

	//---------------------
	//
	// MIL LAYER 
	//
	//---------------------
	// Init Display with correct X-Y parameters 

	//--------------------------------
	// MONO TRANSFER
	//--------------------------------
	if (SensorParams->IS_COLOR == 0) {
		ImageBufferAddr = LayerCreateGrabBuffer(&MilGrabBuffer, SensorParams->Xsize_Full_valid, 1 * SensorParams->Ysize_Full_valid, MonoType);
		LUT_PATTERN = 0;

		ImageBufferLinePitch = MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL);
		LayerInitDisplay(MilGrabBuffer, &MilDisplay, 0);
		printf_s("Adresse buffer display (MemPtr)    = 0x%llx \n", ImageBufferAddr);
		printf_s("Line Pitch buffer display (MemPtr) = 0x%llx \n", ImageBufferLinePitch);
	}
	else

		//----------------------------------------------------
		// This is a color camera, configure transfer type
		//----------------------------------------------------
		printf_s("\nThis is a color camera, what color type do you want to use? \n");
	printf_s("0: RGB32 \n");
	printf_s("1: YUV16 \n");
	printf_s("2: PLANAR \n");
	printf_s("3: RAW \n");
	printf_s("4: MONO8 Conversion \n");


	scanf_s("%d", &Color_type);
	printf_s("\n");

	if (Color_type == 0) RGB32 = 1;
	if (Color_type == 1) YUV = 1;
	if (Color_type == 2) PLANAR = 1;
	if (Color_type == 3) RAW = 1;
	if (Color_type == 4) COLOR_Y = 1;



	//--------------------------------
	// RGB24 TRANSFER
	//--------------------------------
	if (RGB32 == 1)
	{
		ImageBufferAddr = LayerCreateGrabBuffer(&MilGrabBuffer, SensorParams->Xsize_Full_valid, 1 * SensorParams->Ysize_Full_valid, RGB32Type);
		LUT_PATTERN = 3;
		XGS_Ctrl->rXGSptr.BAYER.WB_MUL1.f.WB_MULT_B = 0x1000;
		XGS_Ctrl->rXGSptr.BAYER.WB_MUL1.f.WB_MULT_G = 0x1000;
		XGS_Ctrl->rXGSptr.BAYER.WB_MUL2.f.WB_MULT_R = 0x1000;

		ImageBufferLinePitch = MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL);
		LayerInitDisplay(MilGrabBuffer, &MilDisplay, 1);
		printf_s("Adresse buffer display (MemPtr)    = 0x%llx \n", ImageBufferAddr);
		printf_s("Line Pitch buffer display (MemPtr) = 0x%llx \n", ImageBufferLinePitch);
	}

	//--------------------------------
	// YUV16 TRANSFER
	//--------------------------------
	else if (YUV == 1)
	{
		ImageBufferAddr = LayerCreateGrabBuffer(&MilGrabBuffer, SensorParams->Xsize_Full_valid, 1 * SensorParams->Ysize_Full_valid, YUVType);
		LUT_PATTERN = 3;
		XGS_Ctrl->rXGSptr.BAYER.WB_MUL1.f.WB_MULT_B = 0x1000;
		XGS_Ctrl->rXGSptr.BAYER.WB_MUL1.f.WB_MULT_G = 0x1000;
		XGS_Ctrl->rXGSptr.BAYER.WB_MUL2.f.WB_MULT_R = 0x1000;

		ImageBufferLinePitch = MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL);
		LayerInitDisplay(MilGrabBuffer, &MilDisplay, 1);
		printf_s("Adresse buffer display (MemPtr)    = 0x%llx \n", ImageBufferAddr);
		printf_s("Line Pitch buffer display (MemPtr) = 0x%llx \n", ImageBufferLinePitch);

	}
	//--------------------------------
	// PLANAR TRANSFER
	//--------------------------------
	else if (PLANAR == 1)
	{   // USING 3 MONO BUFFERS
		//ImageBufferAddr  = LayerCreateGrabBuffer(&MilGrabBufferB, SensorParams->Xsize_Full_valid, 1 * SensorParams->Ysize_Full_valid, MonoType);		
		//ImageBufferAddrG = LayerCreateGrabBuffer(&MilGrabBufferG, SensorParams->Xsize_Full_valid, 1 * SensorParams->Ysize_Full_valid, MonoType);			
		//ImageBufferAddrR = LayerCreateGrabBuffer(&MilGrabBufferR, SensorParams->Xsize_Full_valid, 1 * SensorParams->Ysize_Full_valid, MonoType);
		//
		//ImageBufferLinePitch = MbufInquire(MilGrabBufferB, M_PITCH_BYTE, M_NULL);
		//		
		//LayerInitDisplay(MilGrabBufferB, &MilDisplayB, 1);
		//LayerInitDisplay(MilGrabBufferG, &MilDisplayG, 2);
		//LayerInitDisplay(MilGrabBufferR, &MilDisplayR, 3);

		ImageBufferAddr = LayerCreateGrabBuffer(&MilGrabBuffer, SensorParams->Xsize_Full_valid, 1 * SensorParams->Ysize_Full_valid, PlanarType);

		ImageBufferLinePitch = MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL);

		MbufChildColor(MilGrabBuffer, M_BLUE, &MilGrabBufferB);
		MbufChildColor(MilGrabBuffer, M_GREEN, &MilGrabBufferG);
		MbufChildColor(MilGrabBuffer, M_RED, &MilGrabBufferR);

		ImageBufferAddr = LayerGetPhysicalAddressBuffer(MilGrabBufferB);
		ImageBufferAddrG = LayerGetPhysicalAddressBuffer(MilGrabBufferG);
		ImageBufferAddrR = LayerGetPhysicalAddressBuffer(MilGrabBufferR);

		LayerInitDisplay(MilGrabBuffer, &MilDisplay, 4);

		LUT_PATTERN = 3;
		XGS_Ctrl->rXGSptr.BAYER.WB_MUL1.f.WB_MULT_B = 0x1000;
		XGS_Ctrl->rXGSptr.BAYER.WB_MUL1.f.WB_MULT_G = 0x1000;
		XGS_Ctrl->rXGSptr.BAYER.WB_MUL2.f.WB_MULT_R = 0x1000;

		printf_s("Adresse buffer display PLANAR B(MemPtr)    = 0x%llx \n", ImageBufferAddr);
		printf_s("Adresse buffer display PLANAR G(MemPtr)    = 0x%llx \n", ImageBufferAddrG);
		printf_s("Adresse buffer display PLANAR R(MemPtr)    = 0x%llx \n", ImageBufferAddrR);
		printf_s("Line Pitch buffer display (MemPtr)         = 0x%llx \n", ImageBufferLinePitch);
		//printf_s("Offset between Bands                       = 0x%llx \n", SensorParams->Ysize_Full_valid * ImageBufferLinePitch);
	}
	else if (RAW == 1)
	{
		ImageBufferAddr = LayerCreateGrabBuffer(&MilGrabBuffer, SensorParams->Xsize_Full, 1 * SensorParams->Ysize_Full, MonoType);  //include interpolation for DPC
		LUT_PATTERN = 3;

		ImageBufferLinePitch = MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL);
		LayerInitDisplay(MilGrabBuffer, &MilDisplay, 0);
		printf_s("Adresse buffer display (MemPtr)    = 0x%llx \n", ImageBufferAddr);
		printf_s("Line Pitch buffer display (MemPtr) = 0x%llx \n", ImageBufferLinePitch);

	}
	else if (COLOR_Y == 1)
	{
		ImageBufferAddr = LayerCreateGrabBuffer(&MilGrabBuffer, SensorParams->Xsize_Full_valid, 1 * SensorParams->Ysize_Full_valid, MonoType);
		LUT_PATTERN = 3;

		ImageBufferLinePitch = MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL);
		LayerInitDisplay(MilGrabBuffer, &MilDisplay, 0);
		printf_s("Adresse buffer display (MemPtr)    = 0x%llx \n", ImageBufferAddr);
		printf_s("Line Pitch buffer display (MemPtr) = 0x%llx \n", ImageBufferLinePitch);

	}

	//printf_s("\nDo you want to transfer grab images to host frame memory?  (0=No, 1=Yes) : ");
	//ch = _getch();
	ch = '1';

	if (ch == '0')
		DisplayOn = false;
	else
		DisplayOn = true;
	printf_s("\n");


	//---------------------
	// GRAB PARAMETERS
	//---------------------
	// For a full Y frame with Interpolation
	//GrabParams->Y_START = 0;                                                 // Dois etre multiple de 4	
	//GrabParams->Y_SIZE  = SensorParams->Ysize_Full;                          // Dois etre multiple de 4
	//GrabParams->Y_END   = GrabParams->Y_START + GrabParams->Y_SIZE - 1;

	// For a full valid frame ROI 
	if (SensorParams->IS_COLOR == 0) {
		OVERSCAN_Y = 0;
		GrabParams->Y_START = SensorParams->Ystart_valid;                          // Dois etre multiple de 4	
		GrabParams->Y_SIZE = SensorParams->Ysize_Full_valid;                      // Dois etre multiple de 4
		GrabParams->Y_END = GrabParams->Y_START + GrabParams->Y_SIZE - 1;
	}
	else if (RGB32 == 1 || YUV == 1 || PLANAR == 1 || COLOR_Y == 1) {
		OVERSCAN_Y = 4;
		GrabParams->Y_START = SensorParams->Ystart_valid;                          // Dois etre multiple de 4	
		GrabParams->Y_SIZE = SensorParams->Ysize_Full_valid + OVERSCAN_Y;          // Dois etre multiple de 4
		GrabParams->Y_END = GrabParams->Y_START + GrabParams->Y_SIZE - 1;       // On laisse passer 4 lignes d'interpolation pour le bayer, elles se feront couper au trim
	}
	else if (RAW == 1) {                                                          // Le raw est utilise pour le calcul du DPC, on va charcher la full surface
		OVERSCAN_Y = 0;
		GrabParams->Y_START = 0;                                                   // Dois etre multiple de 4	
		GrabParams->Y_SIZE = SensorParams->Ysize_Full;                            // Dois etre multiple de 4
		GrabParams->Y_END = GrabParams->Y_START + GrabParams->Y_SIZE - 1;        // On laisse passer 4 lignes d'interpolation pour le bayer	

		SensorParams->Ystart_valid = 0;                                            // we want all the lines to be transfered   interpolation included     
	}

	XGS_Ctrl->setBlackRef(0);
	XGS_Ctrl->setAnalogGain(1);        //unitary analog gain   
	XGS_Ctrl->setDigitalGain(0x20);    //unitary digital gain

	XGS_Ctrl->setExposure((M_UINT32)XGS_Ctrl->Get_Sensor_EXP_PRED_MAX(GrabParams->Y_SIZE, GrabParams->M_SUBSAMPLING_Y));
	XGS_Ctrl->enableStrobe(0, 0, 250, 1);
	// GRAB MODE
	// TRIGGER_SRC : NONE, IMMEDIATE, HW_TRIG, SW_TRIG
	// TRIGGER_ACT : RISING, FALLING , ANY_EDGE, LEVEL_HI, LEVEL_LO, TIMER 
	XGS_Ctrl->SetGrabMode(TRIGGER_SRC::HW_TRIG, TRIGGER_ACT::TIMER);


	//---------------------
    // Programming HW TIMER
    //---------------------
	double FPS = 10.0;
	XGS_Ctrl->StartHWTimerFPS(FPS);

	XGS_Ctrl->rXGSptr.ACQ.TRIGGER_MISSED.f.TRIGGER_MISSED_RST = 1;

	//---------------------
	// DMA PARAMETERS
	//---------------------
	DMAParams->SUB_X = 0;
	DMAParams->REVERSE_X = 0;
	DMAParams->REVERSE_Y = 0;

	DMAParams->FSTART = ImageBufferAddr;                // Adresse Mono/BGR32/PLANAR B pour DMA
	DMAParams->FSTART_G = ImageBufferAddrG;               // Adresse PLANAR G pour DMA
	DMAParams->FSTART_R = ImageBufferAddrR;               // Adresse PLANAR R pour DMA

	DMAParams->LINE_PITCH = (M_UINT32)ImageBufferLinePitch; // Adresse Mono?BGR32 pour DMA  

	if (SensorParams->IS_COLOR == 0) {

		BYTE_PER_PIXEL = 1;
		SensorParams->Xstart_valid = 4;                        // When color and DPC enabled, then only remove 2 pix  

		DMAParams->ROI_X_EN = 1;
		DMAParams->X_START = SensorParams->Xstart_valid;      // To remove interpolation pixels
		DMAParams->X_SIZE = SensorParams->Xsize_Full_valid;

		DMAParams->LINE_SIZE = BYTE_PER_PIXEL * DMAParams->X_SIZE / (DMAParams->SUB_X + 1);
		DMAParams->CSC = 0; // MONO

		DMAParams->ROI_Y_EN = 0;
		DMAParams->Y_START = 0;
		DMAParams->Y_SIZE = SensorParams->Ysize_Full_valid;

	}
	else
		if (RGB32 == 1) {

			BYTE_PER_PIXEL = 4;
			SensorParams->Xstart_valid = 2;                        // When color and DPC enabled, then only remove 2 pix instead of 4, DPC consumes 2 front and 2 back  

			DMAParams->ROI_X_EN = 1;
			DMAParams->X_START = SensorParams->Xstart_valid;      // To remove interpolation pixels
			DMAParams->X_SIZE = SensorParams->Xsize_Full_valid;

			DMAParams->LINE_SIZE = BYTE_PER_PIXEL * (DMAParams->X_SIZE) / (DMAParams->SUB_X + 1);
			DMAParams->CSC = 1; // BGR32

			DMAParams->ROI_Y_EN = 1;                                                   // Trim to cut 3 last lines after bayer 
			DMAParams->Y_START = 0;
			DMAParams->Y_SIZE = SensorParams->Ysize_Full_valid;
		}

		else if (PLANAR == 1)
		{
			BYTE_PER_PIXEL = 1;
			SensorParams->Xstart_valid = 2;                        // When color and DPC enabled, then only remove 2 pix instead of 4, DPC consumes 2 front and 2 back  

			DMAParams->ROI_X_EN = 1;
			DMAParams->X_START = SensorParams->Xstart_valid;      // To remove interpolation pixels
			DMAParams->X_SIZE = SensorParams->Xsize_Full_valid;

			DMAParams->LINE_SIZE = BYTE_PER_PIXEL * (DMAParams->X_SIZE) / (DMAParams->SUB_X + 1); //DPC removes 2 front + 2 rear
			DMAParams->CSC = 3; // PLANAR

			DMAParams->ROI_Y_EN = 1;                                                   // Trim to cut 3 last lines after bayer 
			DMAParams->Y_START = 0;
			DMAParams->Y_SIZE = SensorParams->Ysize_Full_valid;
		}
		else if (YUV == 1) {
			BYTE_PER_PIXEL = 2;
			SensorParams->Xstart_valid = 2;                        // When color and DPC enabled, then only remove 2 pix instead of 4, DPC consumes 2 front and 2 back  

			DMAParams->ROI_X_EN = 1;
			DMAParams->X_START = SensorParams->Xstart_valid;      // To remove interpolation pixels
			DMAParams->X_SIZE = SensorParams->Xsize_Full_valid;

			DMAParams->LINE_SIZE = BYTE_PER_PIXEL * (DMAParams->X_SIZE) / (DMAParams->SUB_X + 1);  //pour le moment
			DMAParams->CSC = 2; // YUV

			DMAParams->ROI_Y_EN = 1;                                                   // Trim to cut 3 last lines after bayer 
			DMAParams->Y_START = 0;
			DMAParams->Y_SIZE = SensorParams->Ysize_Full_valid;
		}
		else if (RAW == 1) {
			BYTE_PER_PIXEL = 1;
			SensorParams->Xstart_valid = 0;                        // In RAW mode exit all full pixels to identify DPC 

			DMAParams->ROI_X_EN = 0;
			DMAParams->X_START = SensorParams->Xstart_valid;       // On laisse passer le full-X avec toutes les interpolations  
			DMAParams->X_SIZE = SensorParams->Xsize_Full;       // On laisse passer le full-X avec toutes les interpolations  

			DMAParams->LINE_SIZE = BYTE_PER_PIXEL * (DMAParams->X_SIZE) / (DMAParams->SUB_X + 1);  //pour le moment
			DMAParams->CSC = 5; // RAW

			DMAParams->ROI_Y_EN = 0;
			DMAParams->Y_START = 0;                                // On laisse passer le full-Y avec toutes les interpolations  
			DMAParams->Y_SIZE = SensorParams->Ysize_Full;          // On laisse passer le full-Y avec toutes les interpolations    

		}
		else if (COLOR_Y == 1) {
			BYTE_PER_PIXEL = 1;
			SensorParams->Xstart_valid = 2;                        // When color and DPC enabled, then only remove 2 pix instead of 4, DPC consumes 2 front and 2 back  

			DMAParams->ROI_X_EN = 1;
			DMAParams->X_START = SensorParams->Xstart_valid;      // To remove interpolation pixels
			DMAParams->X_SIZE = SensorParams->Xsize_Full_valid;

			DMAParams->LINE_SIZE = BYTE_PER_PIXEL * DMAParams->X_SIZE / (DMAParams->SUB_X + 1);
			DMAParams->CSC = 4; // Y

			DMAParams->ROI_Y_EN = 1;
			DMAParams->Y_START = 0;
			DMAParams->Y_SIZE = SensorParams->Ysize_Full_valid;
		}



	//Transparent LUTs
	XGS_Data->ProgramLUT(LUT_PATTERN);
	XGS_Data->EnableLUT();

	printf_s("\n\nTest started at : ");
	XGS_Ctrl->PrintTime();


	//------------------------------------
	//  XGS Ctrl Debug 
	//------------------------------------
	//debug_ctrl16_int(0) <= xgs_exposure; --python_monitor0;  --resync to sysclk
	//debug_ctrl16_int(1) <= xgs_FOT;      --python_monitor1;  --resync to sysclk
	//debug_ctrl16_int(2) <= grab_mngr_trig_rdy;
	//debug_ctrl16_int(3) <= readout_cntr_FOT;
	//debug_ctrl16_int(4) <= readout_cntr_EO_FOT;
	//debug_ctrl16_int(5) <= curr_trig0;
	//debug_ctrl16_int(6) <= strobe;
	//debug_ctrl16_int(7) <= FOT;
	//debug_ctrl32_int(8) <= readout;              --(readout qui contient le FOT)
	//debug_ctrl32_int(9) <= readout_cntr2_armed;  --(readout qui contient pas le FOT)
	//debug_ctrl32_int(10) <= readout_stateD;
	//debug_ctrl16_int(11) <= REGFILE.ACQ.GRAB_STAT.GRAB_IDLE;
	//debug_ctrl16_int(12) <= REGFILE.ACQ.GRAB_CTRL.GRAB_CMD;
	//debug_ctrl16_int(13) <= REGFILE.ACQ.GRAB_CTRL.GRAB_SS;
	//debug_ctrl16_int(14) <= grab_pending;
	//debug_ctrl16_int(15) <= grab_active;
	XGS_Ctrl->rXGSptr.ACQ.DEBUG_PINS.f.DEBUG0_SEL = 31;
	XGS_Ctrl->rXGSptr.ACQ.DEBUG_PINS.f.DEBUG1_SEL = 5;
	XGS_Ctrl->rXGSptr.ACQ.DEBUG_PINS.f.DEBUG2_SEL = 17;
	XGS_Ctrl->rXGSptr.ACQ.DEBUG_PINS.f.DEBUG3_SEL = 18;
	//---------------------
	// START GRAB 
	//---------------------
	printf_s("\n");
	printf_s("\n  (q) Quit this test");
	printf_s("\n  (f) Dump image to .tiff file");
	printf_s("\n  (d) Dump XGS controller registers(PCIe)");
	printf_s("\n  (g) Change Analog Gain");
	printf_s("\n  (b) Change Black Offset(XGS Data Pedestal)");
	printf_s("\n  (e) Exposure Incr/Decr gap");
	printf_s("\n  (+) Increase Exposure");
	printf_s("\n  (-) Decrease Exposure");
	printf_s("\n  (p) Pause grab");
	printf_s("\n  (t) XGS test images");
	printf_s("\n");
	printf_s("\n  (r) Read current ROI configuration");
	printf_s("\n  (y) Set new ROI (Y-only)");
	printf_s("\n  (x) Set new ROI (X-only)");
	printf_s("\n  (E) FPGA Reverse X");
	printf_s("\n  (R) FPGA Reverse Y");
	printf_s("\n  (S) Subsampling mode");
	printf_s("\n");
	printf_s("\n  (D) Disable Image Display transfer (Max fps)");
	printf_s("\n  (C) Change Framerate");
	printf_s("\n\n");

	

	XGS_Ctrl->rXGSptr.ACQ.READOUT_CFG_FRAME_LINE.f.DUMMY_LINES = 0;


	//---------------------
	// Give SPI control to FPGA
	//---------------------
	XGS_Ctrl->EnableRegUpdate();

	while (Sortie == 0)
	{

		if (XGS_Ctrl->sXGSptr.ACQ.GRAB_CTRL.f.TRIGGER_OVERLAP == 0)
			XGS_Ctrl->WaitEndExpReadout();

		XGS_Data->SetDMA();
		XGS_Ctrl->SetGrabCMD(0, PolldoSleep);  // Ici on poll grab pending, s'il est a '1' on attend qu'il descende a '0'  avant de continuer


		if (FPS_On)
		{

			// Le max FPS est facile a calculer : Treadout2trigfall + Ttrigfall2FOTstart + Tfot + Treadout(3+Mline+1xEmb+YReadout+7exp+7dummy)
			// Tfot fixe en nmbre de lignes est plus securitaire car il permet un calcul plus precis sans imprecissions
			//
			// Le exp_max pour fps max est un peu plus tricky a calculer.
			// Avec le Xcerelator j'utilise une exposure_synthetique qui ne reflete pas le timing exact du real_integration, 
			// alors il est tres difficile de calculer le bon Exposure max. De plus ca peux expliquer aussi pourquoi il y a un 
			// width minimum sur le signal trig0 du senseur.

			printf_s("\r%dfps(%.2f), Calculated Max fps is %lf @Exp_max=~%.0lfus)        ", XGS_Ctrl->rXGSptr.ACQ.SENSOR_FPS.f.SENSOR_FPS,
				                                                                        XGS_Ctrl->rXGSptr.ACQ.SENSOR_FPS2.f.SENSOR_FPS / 10.0,
				                                                                        XGS_Ctrl->Get_Sensor_FPS_PRED_MAX(GrabParams->Y_SIZE, GrabParams->M_SUBSAMPLING_Y),
				                                                                        XGS_Ctrl->Get_Sensor_EXP_PRED_MAX(GrabParams->Y_SIZE, GrabParams->M_SUBSAMPLING_Y)
			);

		}
		Tmissed = XGS_Ctrl->rXGSptr.ACQ.TRIGGER_MISSED.f.TRIGGER_MISSED_CNTR;
		if (Tmissed != 0)
			printf_s("Tmissed = %d ", Tmissed);
		

	
		if (DisplayOn)
		//{
		//	//MappTimer(M_DEFAULT, M_TIMER_READ, &DisplayLength0);
			MbufControl(MilGrabBuffer, M_MODIFIED, M_DEFAULT);
		//	//MappTimer(M_DEFAULT, M_TIMER_READ, &DisplayLength1);
		//	//printf_s("%f", DisplayLength1 - DisplayLength0);
		//}



		if (_kbhit())
		{
			ch = _getch();
			switch (ch)
			{
			case 'q':
				Sortie = 1;
				XGS_Ctrl->SetGrabMode(TRIGGER_SRC::NONE, TRIGGER_ACT::LEVEL_HI);
				XGS_Ctrl->GrabAbort();
				XGS_Ctrl->StopHWTimer();
				XGS_Data->HiSpiClr();
				XGS_Ctrl->DisableXGS();
				printf_s("\n\n");
				printf_s("Exit! \n");
				break;

			case 'd':
				Sleep(100);
				XGS_Ctrl->XGS_PCIeCtrl_DumpFile();
				Sleep(100);
				break;

			case 'f':
				XGS_Ctrl->WaitEndExpReadout();
				Sleep(100);
				FileDumpNum++;
				MIL_TEXT_CHAR FileName[50];
				MosSprintf(FileName, 50, MIL_TEXT("./Images_dump/Image_Test0001_%d.tiff"), FileDumpNum);
#if M_MIL_UNICODE_API
				printf_s("\nPrinting .tiff file: %S\n", FileName);
#else
				printf_s("\nPrinting .tiff file: %s\n", FileName);
#endif
				MbufSave(FileName, MilGrabBuffer);
				break;


			case 'e':
				printf_s("\nEnter the ExposureIncr/Decr in us : ");
				scanf_s("%d", &ExposureIncr);
				printf_s("\n");
				break;

			case '+':
				XGS_Ctrl->setExposure(XGS_Ctrl->getExposure() + ExposureIncr);
				//printf_s("\r\t\tExposure set to: %d us\n  ", XGS_Ctrl->getExposure() + ExposureIncr);
				break;

			case '-':
				XGS_Ctrl->setExposure(XGS_Ctrl->getExposure() - ExposureIncr);
				//printf_s("\r\t\tExposure set to: %d us\n  ", XGS_Ctrl->getExposure() - ExposureIncr);
				break;

			case 'g':
				if (GrabParams->ANALOG_GAIN == 1) //if curr=1x -> set 2x
					XGS_Ctrl->setAnalogGain(2);
				else if (GrabParams->ANALOG_GAIN == 3) //if curr=2x -> set 4x
					XGS_Ctrl->setAnalogGain(4);
				else if (GrabParams->ANALOG_GAIN == 7) //if curr=4x -> set 1x
					XGS_Ctrl->setAnalogGain(1);
				printf_s("\n");
				break;

			case 'b':
				printf_s("\nEnter Black Offset in HEX (Data Pedestal, 0-0xfff LSB12) : 0x");
				scanf_s("%x", &BlackOffset);
				XGS_Ctrl->setBlackRef(BlackOffset);
				break;


			case 'p':
				printf_s("Paused. Press enter to restart grab...");
				getch_return = _getch();
				printf_s(" GO!\n");
				break;

			case 'r':
				XGS_Ctrl->WaitEndExpReadout();
				Sleep(100);
				XGS_Ctrl->DisableRegUpdate();
				Sleep(100);
				printf_s("\n\n");
				printf_s("Rev X is %d\n", XGS_Ctrl->rXGSptr.DMA.CSC.f.REVERSE_X);
				printf_s("Rev Y is %d\n", XGS_Ctrl->rXGSptr.DMA.CSC.f.REVERSE_Y);
				printf_s("\n");
				printf_s("Sub X is %d\n", XGS_Ctrl->rXGSptr.DMA.CSC.f.SUB_X);
				printf_s("Sub Y is %d\n", XGS_Ctrl->rXGSptr.ACQ.SENSOR_SUBSAMPLING.f.ACTIVE_SUBSAMPLING_Y);
				printf_s("\n");
				printf_s("X start is %d dec\n", XGS_Ctrl->rXGSptr.DMA.ROI_X.f.X_START - SensorParams->Xstart_valid);
				printf_s("X size  is %d dec\n", XGS_Ctrl->rXGSptr.DMA.ROI_X.f.X_SIZE);
				printf_s("\n");
				printf_s("Y start0 is %d dec\n", XGS_Ctrl->ReadSPI(0x381a) * 4 - SensorParams->Ystart_valid);
				printf_s("Y size0  is %d dec\n", XGS_Ctrl->ReadSPI(0x381c) * 4);
				printf_s("Y start1 is %d dec\n", XGS_Ctrl->ReadSPI(0x381e) * 4 - SensorParams->Ystart_valid);
				printf_s("Y size1  is %d dec\n", XGS_Ctrl->ReadSPI(0x3820) * 4);
				printf_s("\n");
				printf_s("Readout Lenght %d Lines, 0x%x, %d dec, time is %dns(without FOT)\n", XGS_Ctrl->rXGSptr.ACQ.READOUT_CFG_FRAME_LINE.f.CURR_FRAME_LINES, XGS_Ctrl->rXGSptr.ACQ.READOUT_CFG2.f.READOUT_LENGTH, XGS_Ctrl->rXGSptr.ACQ.READOUT_CFG2.f.READOUT_LENGTH, XGS_Ctrl->rXGSptr.ACQ.READOUT_CFG2.f.READOUT_LENGTH * 16);
				printf_s("\n");
				Sleep(100);
				XGS_Ctrl->EnableRegUpdate();
				break;

			case 'y':
				//
				// In color mode we need to add 4 lines at the end of frame for overscan line(for calculate the last line in color bayer mode).
				//
				if (RAW == 1)
					printf_s("\n\nEnter the new Size Y (1-based, multiple of 4x Lines) (Current is: %d (with interpolation)), max is %d : ", GrabParams->Y_SIZE - OVERSCAN_Y, SensorParams->Ysize_Full);
				else
					printf_s("\n\nEnter the new Size Y (1-based, multiple of 4x Lines) (Current is: %d), max is %d : ", GrabParams->Y_SIZE - OVERSCAN_Y, SensorParams->Ysize_Full_valid);
				scanf_s("%d", &XGSSize_Y);
				if (XGSSize_Y == 0) {
					printf_s("Size Y = 0 is not a valid size, try again : ");
					scanf_s("%d", &XGSSize_Y);
				}
				printf_s("\nEnter the new Offset Y (1-based, multiple of 4x Lines) (Current is: %d) : ", GrabParams->Y_START - SensorParams->Ystart_valid);

				scanf_s("%d", &XGSStart_Y);

				XGSSize_Y = XGSSize_Y + OVERSCAN_Y; // Adjust size to include 4 overscan if color mode (RGB+YUV+MONO_Y)

				GrabParams->Y_START = SensorParams->Ystart_valid + XGSStart_Y;
				GrabParams->Y_END = GrabParams->Y_START + (XGSSize_Y)-1;
				GrabParams->Y_SIZE = XGSSize_Y;
				DMAParams->Y_SIZE = XGSSize_Y - OVERSCAN_Y;   //remove overscan lines
				Pcie->rPcie_ptr.debug.dma_debug1.f.add_start = DMAParams->FSTART;                                                   // 0x10000080;
				Pcie->rPcie_ptr.debug.dma_debug2.f.add_overrun = DMAParams->FSTART + ((M_INT64)DMAParams->LINE_PITCH * (M_INT64)GrabParams->Y_SIZE);    // 0x10c00080;
				MbufClear(MilGrabBuffer, 0);
				printf_s("\nNEW calculated Max fps is %lf @Exp_max=~%.0lfus)\n", XGS_Ctrl->Get_Sensor_FPS_PRED_MAX(GrabParams->Y_SIZE, GrabParams->ACTIVE_SUBSAMPLING_Y), XGS_Ctrl->Get_Sensor_EXP_PRED_MAX(GrabParams->Y_SIZE, GrabParams->ACTIVE_SUBSAMPLING_Y));
				printf_s("Please adjust exposure time to increase FPS, current Exposure is %dus\n\n", XGS_Ctrl->getExposure());
				break;

			case 'x':
				XGS_Ctrl->WaitEndExpReadout();
				Sleep(100);
				if (RAW == 1)
					printf_s("\nEnter the new Size X (1-based) (Current is: %d (with interpolation)), max is %d : ", DMAParams->X_SIZE, SensorParams->Xsize_Full);
				else
					printf_s("\nEnter the new Size X (1-based) (Current is: %d), max is %d : ", DMAParams->X_SIZE, SensorParams->Xsize_Full_valid);
				scanf_s("%d", &XGSSize_X);
				if (XGSSize_X == 0) {
					printf_s("Size X = 0 is not a valid size, try again : ");
					scanf_s("%d", &XGSSize_X);
				}

				if (RAW == 1) {
					if (XGSSize_X != SensorParams->Xsize_Full)
						DMAParams->ROI_X_EN = 1;
				}

				printf_s("\n\nEnter the new Offset X (1-based) (Current is: %d) : ", DMAParams->X_START - SensorParams->Xstart_valid);
				scanf_s("%d", &XGSStart_X);
				DMAParams->X_START = SensorParams->Xstart_valid + XGSStart_X;
				DMAParams->X_SIZE = XGSSize_X;
				DMAParams->LINE_SIZE = BYTE_PER_PIXEL * (DMAParams->X_SIZE) / (DMAParams->SUB_X + 1);  //pour le moment

				MbufClear(MilGrabBuffer, 0);
				break;

			case 'S':
				XGS_Ctrl->WaitEndExpReadout();

				SubY = !SubY;

				XGS_Ctrl->GrabParams.ACTIVE_SUBSAMPLING_Y = SubY;
				if (SubY == 1)
				{
					if (SensorParams->IS_COLOR == 0)
						DMAParams->Y_SIZE = (GrabParams->Y_END - GrabParams->Y_START + 1) / 2;
					else
						DMAParams->Y_SIZE = (GrabParams->Y_SIZE - OVERSCAN_Y) / 2;

				}
				else
					DMAParams->Y_SIZE = GrabParams->Y_SIZE - OVERSCAN_Y;

				MbufClear(MilGrabBuffer, 0);
				printf_s("\nNEW calculated Max fps is %lf @Exp_max=~%.0lfus)\n", XGS_Ctrl->Get_Sensor_FPS_PRED_MAX(GrabParams->Y_SIZE, GrabParams->ACTIVE_SUBSAMPLING_Y), XGS_Ctrl->Get_Sensor_EXP_PRED_MAX(GrabParams->Y_SIZE, GrabParams->ACTIVE_SUBSAMPLING_Y));
				printf_s("Please adjust exposure time to increase FPS, current Exposure is %dus\n\n", XGS_Ctrl->getExposure());

				break;


			case 's':
				XGS_Ctrl->WaitEndExpReadout();

				printf_s("\n\n");
				printf_s("Subsampling X (0=NO, 1 to 15= Subsampling factor) ? : ");
				scanf_s("%d", &SubX);

				// We dont use SUB_X in sensor, no fps advantages , and noise is increased!
				// Using DMA subsampling 0(none) to 15 factor
				DMAParams->SUB_X = SubX;
				DMAParams->LINE_SIZE = BYTE_PER_PIXEL * DMAParams->X_SIZE / (DMAParams->SUB_X + 1);

				MbufClear(MilGrabBuffer, 0);
				break;

			case 'R':
				XGS_Ctrl->WaitEndExpReadout();
				Sleep(100);

				if (XGS_Data->DMAParams.REVERSE_Y == 1)
					XGS_Data->set_DMA_revY(0, DMAParams->Y_SIZE, GrabParams->ACTIVE_SUBSAMPLING_Y);
				else
					XGS_Data->set_DMA_revY(1, DMAParams->Y_SIZE, GrabParams->ACTIVE_SUBSAMPLING_Y);

				printf_s("RevX=%d , RevY=%d\n", XGS_Data->DMAParams.REVERSE_X, XGS_Data->DMAParams.REVERSE_Y);

				MbufClear(MilGrabBuffer, 0);
				break;

			case 'E':
				XGS_Ctrl->WaitEndExpReadout();
				Sleep(100);

				if (XGS_Data->DMAParams.REVERSE_X == 1)
					XGS_Data->set_DMA_revX(0);
				else
					XGS_Data->set_DMA_revX(1);

				printf_s("RevX=%d , RevY=%d\n", XGS_Data->DMAParams.REVERSE_X, XGS_Data->DMAParams.REVERSE_Y);
				break;

			case 't':
				XGS_Ctrl->WaitEndExpReadout();
				cout << "\n";
				XGSTestImageMode ++;
				if (XGSTestImageMode == 7)
				{
					XGSTestImageMode = 0;
					XGS_Ctrl->WriteSPI(0x3e0e, 0); // Normal image
				}

				// Programmable Flat Image
				if (XGSTestImageMode == 1) {
					cout << "Xgs Image Test Mode is set to Flat Image (Can be programmed to any value)\n" ;
					M_UINT32 Pixel_value = 0x3a6; // 0x1d3 << 1;
					XGS_Ctrl->WriteSPI(0x3e10, Pixel_value); // Test data Red channel
					XGS_Ctrl->WriteSPI(0x3e12, Pixel_value); // Test data Green-R channel
					XGS_Ctrl->WriteSPI(0x3e14, Pixel_value); // Test data Bleu channel
					XGS_Ctrl->WriteSPI(0x3e16, Pixel_value); // Test data Green-B channel
					XGS_Ctrl->WriteSPI(0x3e0e, 1);     // Solid color
				}
				//  Programmable Horizontal black and white lines
				if (XGSTestImageMode == 2) {
					cout << "Xgs Image Test Mode is set to Programmable Horizontal black and white lines (Can be programmed to any value)\n";
					XGS_Ctrl->WriteSPI(0x3e10, 0x1fff); // Test data Red channel
					XGS_Ctrl->WriteSPI(0x3e12, 0x1fff); // Test data Green-R channel
					XGS_Ctrl->WriteSPI(0x3e14, 0x0);    // Test data Bleu channel
					XGS_Ctrl->WriteSPI(0x3e16, 0x0);    // Test data Green-B channel
					XGS_Ctrl->WriteSPI(0x3e0e, 1);      // Solid color
				}
				//  Programmable Vertical black and white columns
				if (XGSTestImageMode == 3) {
					cout << "Xgs Image Test Mode is set to Programmable Vertical black and white columns (Can be programmed to any value)\n";
					XGS_Ctrl->WriteSPI(0x3e10, 0x1fff); // Test data Red channel
					XGS_Ctrl->WriteSPI(0x3e12, 0x0); // Test data Green-R channel
					XGS_Ctrl->WriteSPI(0x3e14, 0x0);    // Test data Bleu channel
					XGS_Ctrl->WriteSPI(0x3e16, 0x1fff);    // Test data Green-B channel
					XGS_Ctrl->WriteSPI(0x3e0e, 1);      // Solid color
				}
				//XGS_Ctrl->WriteSPI(0x3e0e, 2); // Color bars (BAYER)
				//XGS_Ctrl->WriteSPI(0x3e0e, 3); // fade to gray, all must be 0 or 1 (NE Marche PAS ??? a cause du 6 Lanes???)

				// diagonal gray x1
				if (XGSTestImageMode == 4) {
					cout << "Xgs Image Test Mode is set to Diagonal gray x1\n";
					XGS_Ctrl->WriteSPI(0x3e0e, 4); // diagonal gray x1
				}
				
				// diagonal gray x3	
				if (XGSTestImageMode == 5) {
					cout << "Xgs Image Test Mode is set to Diagonal gray x3\n";
					XGS_Ctrl->WriteSPI(0x3e0e, 5); // diagonal gray x3		
				}

				// White/Black bar(coarse)
				if (XGSTestImageMode == 6) {
					cout << "Xgs Image Test Mode is set to White/Black bar(coarse)\n";
					XGS_Ctrl->WriteSPI(0x3e0e, 6); // White/Black bar(coarse)  : TRES LARGE
				}

			    //XGS_Ctrl->WriteSPI(0x3e0e, 7);    // White/Black bar(fine)   (NE Marche PAS ???  a cause du 6 Lanes???)			
				cout << "\n";
				break;

			case 'D':

				if (DisplayOn == TRUE)
					DisplayOn = FALSE;
				else
					DisplayOn = TRUE;
				break;


			case 'C':
				XGS_Ctrl->StopHWTimer();
				XGS_Ctrl->rXGSptr.ACQ.TRIGGER_MISSED.f.TRIGGER_MISSED_CNTR = 1;
				cout << "\n\nEnter the new FrameRate (FPS, can be decimal) : ";
				scanf_s("%lf", &FPS);
				XGS_Ctrl->StartHWTimerFPS(FPS);
				cout << "\n";
				break;

			}



		}

	}

	printf_s("\r%dfps   ", XGS_Ctrl->rXGSptr.ACQ.SENSOR_FPS.f.SENSOR_FPS);

	//------------------------------
	// Free MIL Display
	//------------------------------
	if (SensorParams->IS_COLOR == 0 || (SensorParams->IS_COLOR == 1 && PLANAR == 0)) {
		MbufFree(MilGrabBuffer);
		MdispFree(MilDisplay);
	}
	else {
		MbufFree(MilGrabBufferB);
		MbufFree(MilGrabBufferG);
		MbufFree(MilGrabBufferR);
		MbufFree(MilGrabBuffer);
		//MbufFree(MilGrabBufferB);
		//MbufFree(MilGrabBufferG);
		//MbufFree(MilGrabBufferR);
		//MdispFree(MilDisplayB);
		//MdispFree(MilDisplayG);
		//MdispFree(MilDisplayR);
		MdispFree(MilDisplay);

	}

	//----------------------
	// Disable HW
	//----------------------
	XGS_Ctrl->DisableXGS();  //reset and disable clk

	printf_s("\n\n********************************\n");
	printf_s("*    End of Test0000.cpp    *\n");
	printf_s("********************************\n\n");

   }



