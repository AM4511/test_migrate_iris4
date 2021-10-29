//-----------------------------------------------
//
//  Simple continu test grab Iris4, defined number of frames
//
//  Mono only
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

int test_0010_Continu_nbframes(CPcie* Pcie, CXGS_Ctrl* XGS_Ctrl, CXGS_Data* XGS_Data, M_UINT32 nbFrames, M_UINT32 FlatImageVal)
   {
	
	MIL_ID MilDisplay;
	MIL_ID MilGrabBuffer;
	M_UINT64 ImageBufferAddr      = 0;
	MIL_INT  ImageBufferLinePitch = 0;

	int getch_return;
	int MonoType = 8;

	int Sortie = 0;
	char ch;

	bool CheckCRC   = true;
	bool DisplayOn  = true;
	int PolldoSleep =0;
	bool FPS_On     = true;

	int Error_exit = 0;

	M_UINT32 ExposureIncr = 10;
	M_UINT32 BlackOffset  = 0x100;

	M_UINT32 XGSStart_Y = 0;
	M_UINT32 XGSSize_Y = 0;
	M_UINT32 XGSStart_X = 0;
	M_UINT32 XGSSize_X = 0;

	M_UINT32 SubX = 0;
	M_UINT32 SubY = 0;

	M_UINT32 XGSTestImageMode = 0;

	GrabParamStruct*   GrabParams   = XGS_Ctrl->getGrabParams();         // This is a Local Pointer to grab parameter structure
	SensorParamStruct* SensorParams = XGS_Ctrl->getSensorParams();
	DMAParamStruct*    DMAParams    = XGS_Data->getDMAParams();             // This is a Local Pointer to DMA parameter structure

	M_UINT32 FileDumpNum = 0;

	M_UINT32 Overrun      = 0;
	M_UINT32 OverrunPixel = 0;

	M_UINT32 LUT_PATTERN = 0;

	M_UINT32 DigGain = 0x20; // Unitary gain

	M_UINT64 GrabCmd = 0;

	printf_s("\n\n********************************\n");
	printf_s(    "*    Executing Test0010.cpp    *\n"); 
	printf_s(    "********************************\n\n");



	//-------------------
	// Reduce linerate
	//-------------------
	//XGS_Ctrl->GrabParams.XGS_LINE_SIZE_FACTOR = 2;

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
	ImageBufferAddr = LayerCreateGrabBuffer(&MilGrabBuffer, SensorParams->Xsize_Full_valid, 1 * SensorParams->Ysize_Full_valid, MonoType);
	LUT_PATTERN = 0;

	ImageBufferLinePitch = MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL);
	LayerInitDisplay(MilGrabBuffer, &MilDisplay, 1);
	printf_s("Adresse buffer display (MemPtr)    = 0x%llx \n", ImageBufferAddr);
	printf_s("Line Pitch buffer display (MemPtr) = 0x%llx \n", ImageBufferLinePitch);




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
		GrabParams->Y_START = SensorParams->Ystart_valid;                          // Dois etre multiple de 4	
		GrabParams->Y_SIZE = SensorParams->Ysize_Full_valid;                       // Dois etre multiple de 4
		GrabParams->Y_END = GrabParams->Y_START + GrabParams->Y_SIZE - 1;
	}
	else {
		printf_s("No COLOR SUPPORT IN THIS TEST, press enter to quit\n\n");
		Sortie = 1;
		_getch();
	}

	GrabParams->M_SUBSAMPLING_Y = 0;
	GrabParams->ACTIVE_SUBSAMPLING_Y = 0;

	XGS_Ctrl->setBlackRef(0);
	XGS_Ctrl->setAnalogGain(1);        //unitary analog gain   
	XGS_Ctrl->setDigitalGain(0x20);    //unitary digital gain

	XGS_Ctrl->setExposure((M_UINT32)XGS_Ctrl->Get_Sensor_EXP_PRED_MAX(GrabParams->Y_SIZE, GrabParams->M_SUBSAMPLING_Y));


	// GRAB MODE
	// TRIGGER_SRC : NONE, IMMEDIATE, HW_TRIG, SW_TRIG
	// TRIGGER_ACT : RISING, FALLING , ANY_EDGE, LEVEL_HI, LEVEL_LO 
	XGS_Ctrl->SetGrabMode(TRIGGER_SRC::IMMEDIATE, TRIGGER_ACT::RISING);


	//---------------------
	// DMA PARAMETERS
	//---------------------
	DMAParams->ROI_X_EN = 1;
	DMAParams->X_START = SensorParams->Xstart_valid;      // To remove interpolation pixels
	DMAParams->X_SIZE = SensorParams->Xsize_Full_valid;

	DMAParams->SUB_X = 0;
	DMAParams->REVERSE_X = 0;
	DMAParams->REVERSE_Y = 0;

	DMAParams->FSTART = ImageBufferAddr;          // Adresse Mono pour DMA
	DMAParams->LINE_PITCH = (M_UINT32)ImageBufferLinePitch;
	DMAParams->LINE_SIZE = DMAParams->X_SIZE / (DMAParams->SUB_X + 1);


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
	//debug_ctrl16_int(7) <= strobe;
	//debug_ctrl32_int(8) <= readout;              --(readout qui contient le FOT)
	//debug_ctrl32_int(9) <= readout_cntr2_armed;  --(readout qui contient pas le FOT)
	//debug_ctrl32_int(10) <= readout_stateD;
	//debug_ctrl16_int(11) <= REGFILE.ACQ.GRAB_STAT.GRAB_IDLE;
	//debug_ctrl16_int(12) <= REGFILE.ACQ.GRAB_CTRL.GRAB_CMD;
	//debug_ctrl16_int(13) <= REGFILE.ACQ.GRAB_CTRL.GRAB_SS;
	//debug_ctrl16_int(14) <= grab_pending;
	//debug_ctrl16_int(15) <= grab_active;
	//debug_ctrl32_int(16) <= xgs_monitor2_metasync;
	//debug_ctrl32_int(17) <= keep_out_zone;
	//debug_ctrl32_int(18) <= xgs_trig_int_delayed;


	//---- DO NOT MODIFY FROM HERE

	// https://imgconf.matrox.com:8443/display/IRIS4/XGS+Controller+timings+specs
	// 1) Setup de mesure pour FOT, ReadOutN_2_TrigN, TrigN_2_FOT, EXP_FOT, EXP_FOT_TIME	       [TEST0001 - Grab Trigger Single Snapshoot]
	//      Probe1 : Signal Trig_Int sur le sensor board(R238 sur le sensor board 7572 - 00)
	//      Probe2 : Monitor0, Real Intégration(J204 sur le sensor board 7572 - 00)
	//      Probe3 : Monitor1, EFOT(J204 sur le sensor board 7572 - 00)
	//      Probe4 : Debug0(R254  sur le sensor board 7572 - 00), avec Debug0 = Signal interne FPGA Readout(WritePcie BAR0 + 0x1e0[4:0] = 0x8)
	//
	XGS_Ctrl->rXGSptr.ACQ.DEBUG_PINS.f.DEBUG0_SEL = 8;
	XGS_Ctrl->rXGSptr.ACQ.DEBUG_PINS.f.DEBUG1_SEL = 8;
	XGS_Ctrl->rXGSptr.ACQ.DEBUG_PINS.f.DEBUG2_SEL = 8;
	XGS_Ctrl->rXGSptr.ACQ.DEBUG_PINS.f.DEBUG3_SEL = 8;

	// https://imgconf.matrox.com:8443/display/IRIS4/XGS+Controller+timings+specs
	// 2) Setup de mesure pour FOTn_2_EXP(Pour calcul Exposure Max)                               	[TEST0000 - Grab continu]
	//      Probe1 : Signal Trig_Int sur le sensor board(R238 sur le sensor board 7572 - 00)
	//      Probe2 : Monitor0, Real Intégration(J204 sur le sensor board 7572 - 00)
	//      Probe3 : Monitor1, EFOT(J204 sur le sensor board 7572 - 00)
	//      Probe4 : Debug0(R254  sur le sensor board 7572 - 00), avec Debug0 = Signal interne FPGA FOT interne(WritePcie BAR0 + 0x1e0[4:0] = 0x7)
	//
	XGS_Ctrl->rXGSptr.ACQ.DEBUG_PINS.f.DEBUG0_SEL = 7;
	XGS_Ctrl->rXGSptr.ACQ.DEBUG_PINS.f.DEBUG1_SEL = 7;
	XGS_Ctrl->rXGSptr.ACQ.DEBUG_PINS.f.DEBUG2_SEL = 7;
	XGS_Ctrl->rXGSptr.ACQ.DEBUG_PINS.f.DEBUG3_SEL = 7;

	// https://imgconf.matrox.com:8443/display/IRIS4/XGS+Controller+timings+specs                   [TEST0000 - Grab continu]
    // 3) Setup de mesure pour KEEP_OUT_ZONE_START
    //      Probe1 : Monitor2, NEW_LINE(J204 sur le sensor board 7572 - 00), ce signal dure 1 clk pixel clock(15.625ns avec  un oscillateur de 32 Mhz)
    //      Probe2 : Debug0(R254  sur le sensor board 7572 - 00), avec Debug0 = Signal interne FPGA keep_out_zone(WritePcie BAR0 + 0x1e0[4:0] = 0x11 (17))
    //      Probe3 : Debug1(R256  sur le sensor board 7572 - 00), avec Debug1 = Signal interne FPGA xgs_trig_int_delayed(WritePcie BAR0 + 0x1e0[12:8] = 0x12 (18))
    //      Probe4 : Debug2(R256  sur le sensor board 7572 - 00), avec Debug2 = Signal interne FPGA curr_trig0(WritePcie BAR0 + 0x1e0[20:16] = 0x5 (5))
    //
    XGS_Ctrl->rXGSptr.ACQ.DEBUG_PINS.f.DEBUG0_SEL = 17;
    XGS_Ctrl->rXGSptr.ACQ.DEBUG_PINS.f.DEBUG1_SEL = 18;
    XGS_Ctrl->rXGSptr.ACQ.DEBUG_PINS.f.DEBUG2_SEL = 5;
    XGS_Ctrl->rXGSptr.ACQ.DEBUG_PINS.f.DEBUG3_SEL = 31; //not used


	//---- END OF DO NOT MODIFY FROM HERE




	//---------------------
	// START GRAB 
	//---------------------
	//printf_s("\n");
	//printf_s("\n  (q) Quit this test");
	//printf_s("\n  (f) Dump image to .tiff file");
	//printf_s("\n  (d) Dump XGS controller registers(PCIe)");
	//printf_s("\n  (g) Change Analog Gain");
	//printf_s("\n  (b) Change Black Offset(XGS Data Pedestal)");
	//printf_s("\n  (e) Exposure Incr/Decr gap");
	//printf_s("\n  (+) Increase Exposure");
	//printf_s("\n  (-) Decrease Exposure");
	//printf_s("\n  (p) Pause grab");
	//printf_s("\n  (t) XGS test images");
	//printf_s("\n  (y) Set new ROI (Y-only)");
	//printf_s("\n  (r) Read current ROI configuration in XGS");
	//printf_s("\n  (S) Subsampling mode");
	//printf_s("\n  (D) Disable Image Display transfer (Max fps)");
	//printf_s("\n  (T) Fpga Monitor(Temp and Supplies)");
	//printf_s("\n  (l) Program LUT");
	//printf_s("\n  (2) Digital Gain +1 (XGS Dig Gain)");
	//printf_s("\n  (1) Digital Gain -1 (XGS Dig Gain)");
	//printf_s("\n  (x) Dump XGS registers");
	//
	//
	//printf_s("\n\n");

	XGS_Ctrl->rXGSptr.ACQ.READOUT_CFG_FRAME_LINE.f.DUMMY_LINES = 0;


	// For debug DMA overrun with any 12Mpix sensor
	Pcie->rPcie_ptr.debug.dma_debug1.f.add_start   = DMAParams->FSTART;                                                            // 0x10000080;
	Pcie->rPcie_ptr.debug.dma_debug2.f.add_overrun = (DMAParams->FSTART + ((M_INT64)DMAParams->LINE_PITCH * (M_INT64)GrabParams->Y_SIZE)) ;    // 0x10c00080;



	if (XGS_Ctrl->rXGSptr.HISPI.STATUS.f.CRC_ERROR == 1) printf_s("CRC error before grab loop start!!!\n");


	//---------------------
	// Give SPI control to FPGA
	//---------------------
	XGS_Ctrl->EnableRegUpdate();

	printf_s("\nCalculated Max fps is %lf @Exp_max=~%.0lfus)\n", XGS_Ctrl->Get_Sensor_FPS_PRED_MAX(GrabParams->Y_SIZE, GrabParams->M_SUBSAMPLING_Y), XGS_Ctrl->Get_Sensor_EXP_PRED_MAX(GrabParams->Y_SIZE, GrabParams->M_SUBSAMPLING_Y));


	if (FlatImageVal == 0x1000) {                // LIVE IMAGE
		printf_s("\n\nUSING LIVE IMAGE FOR THIS TEST\n\n");
	} else
		if (FlatImageVal == 0x2000) {            // RAMP : diagonal gray x1
			printf_s("\n\nUSING RAMP IMAGE FOR THIS TEST\n\n");
			XGS_Ctrl->WriteSPI(0x3e0e, 4); // 
		}
		else
		{
			printf_s("\n\nUSING FLAT IMAGE FOR THIS TEST WITH VALUE 0x%X\n\n", FlatImageVal & 0xfff);
			
			M_UINT32 pixelval = FlatImageVal & 0xfff;
			XGS_Ctrl->WriteSPI(0x3e10, pixelval << 1); // Test data Red channel
			XGS_Ctrl->WriteSPI(0x3e12, pixelval << 1); // Test data Green-R channel
			XGS_Ctrl->WriteSPI(0x3e14, pixelval << 1); // Test data Bleu channel
			XGS_Ctrl->WriteSPI(0x3e16, pixelval << 1); // Test data Green-B channel
			XGS_Ctrl->WriteSPI(0x3e0e, 1);             // Solid color
		}




	while (Sortie == 0)
	{

		if (XGS_Ctrl->sXGSptr.ACQ.GRAB_CTRL.f.TRIGGER_OVERLAP == 0)
			XGS_Ctrl->WaitEndExpReadout();

		XGS_Data->SetDMA();
		XGS_Ctrl->SetGrabCMD(0, PolldoSleep);  // Ici on poll grab pending, s'il est a '1' on attend qu'il descende a '0'  avant de continuer
		GrabCmd++;

		if (GrabCmd == nbFrames)
		{
			Sleep(1000);
			Sortie = 1;
			XGS_Ctrl->SetGrabMode(TRIGGER_SRC::NONE, TRIGGER_ACT::LEVEL_HI);
			XGS_Ctrl->GrabAbort();

			// DISABLE HISPI
			XGS_Ctrl->sXGSptr.HISPI.CTRL.f.ENABLE_DATA_PATH = 0;
			XGS_Ctrl->rXGSptr.HISPI.CTRL.u32 = XGS_Ctrl->sXGSptr.HISPI.CTRL.u32;
			Sleep(100);
			XGS_Ctrl->sXGSptr.HISPI.CTRL.f.ENABLE_HISPI = 0;
			XGS_Ctrl->sXGSptr.HISPI.CTRL.f.SW_CLR_IDELAYCTRL = 0;
			XGS_Ctrl->sXGSptr.HISPI.CTRL.f.SW_CLR_HISPI = 1;
			XGS_Ctrl->rXGSptr.HISPI.CTRL.u32 = XGS_Ctrl->sXGSptr.HISPI.CTRL.u32;
			Sleep(100);

			XGS_Ctrl->DisableXGS();
			printf_s("\n\n");
			break;
		}

		//XGS_Ctrl->WaitEndExpReadout();

		Sortie = XGS_Data->HiSpiCheck(GrabCmd);

		if (Sortie == 1)
		{

			Error_exit = 1 ;

			Sleep(100);

			MbufControl(MilGrabBuffer, M_MODIFIED, M_DEFAULT);

			FileDumpNum++;
			MIL_TEXT_CHAR FileName[50];
			MosSprintf(FileName, 50, MIL_TEXT("./Image_Test0000_%d_CRC_ERR.tiff"), FileDumpNum);
#if M_MIL_UNICODE_API
			printf_s("\nPrinting .tiff file: %S\n", FileName);
#else
			printf_s("\nPrinting .tiff file: %s\n", FileName);
#endif
			MbufSave(FileName, MilGrabBuffer);
		}



		if (FPS_On)
		{

			// Le max FPS est facile a calculer : Treadout2trigfall + Ttrigfall2FOTstart + Tfot + Treadout(3+Mline+1xEmb+YReadout+7exp+7dummy)
			// Tfot fixe en nmbre de lignes est plus securitaire car il permet un calcul plus precis sans imprecissions
			//
			// Le exp_max pour fps max est un peu plus tricky a calculer.
			// Avec le Xcerelator j'utilise une exposure_synthetique qui ne reflete pas le timing exact du real_integration, 
			// alors il est tres difficile de calculer le bon Exposure max. De plus ca peux expliquer aussi pourquoi il y a un 
			// width minimum sur le signal trig0 du senseur.

			//printf_s("\r%dfps", XGS_Ctrl->rXGSptr.ACQ.SENSOR_FPS.f.SENSOR_FPS );   //  <---- plante ici!!!
			//printf_s("(%.2f), Calculated Max fps is ", XGS_Ctrl->rXGSptr.ACQ.SENSOR_FPS2.f.SENSOR_FPS / 10.0);
			//printf_s("%lf @Exp_max=", XGS_Ctrl->Get_Sensor_FPS_PRED_MAX(GrabParams->Y_SIZE, GrabParams->M_SUBSAMPLING_Y) );
			//printf_s("~%.0lfus)        ", XGS_Ctrl->Get_Sensor_EXP_PRED_MAX(GrabParams->Y_SIZE, GrabParams->M_SUBSAMPLING_Y) );


			printf_s("\r%dfps(%.2f), Calculated Max fps is %lf @Exp_max=~%.0lfus)        ", XGS_Ctrl->rXGSptr.ACQ.SENSOR_FPS.f.SENSOR_FPS,
				                                                                            XGS_Ctrl->rXGSptr.ACQ.SENSOR_FPS2.f.SENSOR_FPS / 10.0,
				                                                                            XGS_Ctrl->Get_Sensor_FPS_PRED_MAX(GrabParams->Y_SIZE, GrabParams->M_SUBSAMPLING_Y),
				                                                                            XGS_Ctrl->Get_Sensor_EXP_PRED_MAX(GrabParams->Y_SIZE, GrabParams->M_SUBSAMPLING_Y)	);


		}

	

		if (DisplayOn)
		//{
		//	//MappTimer(M_DEFAULT, M_TIMER_READ, &DisplayLength0);
			MbufControl(MilGrabBuffer, M_MODIFIED, M_DEFAULT);
		//	//MappTimer(M_DEFAULT, M_TIMER_READ, &DisplayLength1);
		//	//printf_s("%f", DisplayLength1 - DisplayLength0);
		//}
		

		//Overrun detection
		OverrunPixel = XGS_Data->GetImagePixel8(LayerGetHostAddressBuffer(MilGrabBuffer), 0, GrabParams->Y_SIZE, MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL));
		if (OverrunPixel != 0)
		{
			Overrun++;
			printf_s(" DMA Overflow detected: %d\n", Overrun);
			//printf_s("Press enter to continue...\n");
			//_getch();
			XGS_Data->SetImagePixel8(LayerGetHostAddressBuffer(MilGrabBuffer), 0, GrabParams->Y_SIZE, MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL), 0); //reset overrun pixel

		}



		if (_kbhit())
		{
			ch = _getch();
			switch (ch)
			{
			case 'q':
				Sortie = 1;
				XGS_Ctrl->SetGrabMode(TRIGGER_SRC::NONE, TRIGGER_ACT::LEVEL_HI);
				XGS_Ctrl->GrabAbort();
				XGS_Data->HiSpiClr();
				XGS_Ctrl->DisableXGS();
				printf_s("\n\n");
				printf_s("Exit! \n");
				break;


			}

		}

	}

	//------------------------------
	// Free MIL Display
	//------------------------------
	MbufFree(MilGrabBuffer);
	MdispFree(MilDisplay);

	//----------------------
	// Disable HW
	//----------------------
	XGS_Ctrl->DisableXGS();  //reset and disable clk

	printf_s("\n\n********************************\n");
	printf_s("*    End of Test0010.cpp    *\n");
	printf_s("********************************\n\n");

	return Error_exit;
   }



