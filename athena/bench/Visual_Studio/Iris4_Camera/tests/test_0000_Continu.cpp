//-----------------------------------------------
//
//  Simple continu test grab Iris4
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

void test_0000_Continu(CPcie* Pcie, CXGS_Ctrl* XGS_Ctrl, CXGS_Data* XGS_Data)
   {
	
	MIL_ID MilDisplay;
	MIL_ID MilGrabBuffer;
	M_UINT64 ImageBufferAddr      = 0;
	MIL_INT  ImageBufferLinePitch = 0;

	int getch_return;
	int MonoType = 8;
	int RGB32Type = 32;

	int Sortie = 0;
	char ch;

	bool CheckCRC   = true;
	bool DisplayOn  = true;
	int PolldoSleep =0;
	bool FPS_On     = true;

	M_UINT32 ExposureIncr = 10;
	M_UINT32 BlackOffset  = 0x100;
	M_UINT32 XGSSize_Y = 0;

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
	printf_s(    "*    Executing Test0000.cpp    *\n"); 
	printf_s(    "********************************\n\n");



	//-------------------
	// Reduce linerate
	//-------------------
	//XGS_Ctrl->GrabParams.XGS_LINE_SIZE_FACTOR = 2;

	//------------------------------
    // INITIALIZE XGS SENSOR
    //------------------------------
	XGS_Ctrl->InitXGS();
	M_UINT32 SensorSpi_0x3402 = XGS_Ctrl->ReadSPI(0x3402);

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
	if (SensorParams->IS_COLOR == 0) {
	  ImageBufferAddr = LayerCreateGrabBuffer(&MilGrabBuffer, SensorParams->Xsize_Full, 2 * SensorParams->Ysize_Full, MonoType);
	  LUT_PATTERN = 0;
	}
	else{
	  ImageBufferAddr = LayerCreateGrabBuffer(&MilGrabBuffer, SensorParams->Xsize_Full, 2 * SensorParams->Ysize_Full, RGB32Type);
	  LUT_PATTERN = 3;
	  XGS_Ctrl->rXGSptr.BAYER.WB_MUL1.f.WB_MULT_B = 0x1000;
	  XGS_Ctrl->rXGSptr.BAYER.WB_MUL1.f.WB_MULT_G = 0x1000;
	  XGS_Ctrl->rXGSptr.BAYER.WB_MUL2.f.WB_MULT_R = 0x1000;
	  XGS_Ctrl->rXGSptr.BAYER.BAYER_CFG.f.BAYER_EN = 1;
    }

	ImageBufferLinePitch= MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL);
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
	// For a full frame ROI 
	GrabParams->Y_START = 1;                                                // 1-base Here - Dois etre multiple de 4	
	GrabParams->Y_END   = GrabParams->Y_START + SensorParams->Ysize_Full;	// 1-base Here - Dois etre multiple de 4
	GrabParams->Y_SIZE  = GrabParams->Y_END - GrabParams->Y_START;          // 1-base Here - Dois etre multiple de 4


	GrabParams->SUBSAMPLING_X        = 0;
	GrabParams->M_SUBSAMPLING_Y      = 0;
	GrabParams->ACTIVE_SUBSAMPLING_Y = 0;

	XGS_Ctrl->setBlackRef(0);
	XGS_Ctrl->setAnalogGain(1);        //unitary analog gain   
	XGS_Ctrl->setDigitalGain(0x20);    //unitary digital gain

	XGS_Ctrl->setExposure((M_UINT32)XGS_Ctrl->Get_Sensor_EXP_PRED_MAX(GrabParams->Y_SIZE, GrabParams->M_SUBSAMPLING_Y) );


	// GRAB MODE
	// TRIGGER_SRC : NONE, IMMEDIATE, HW_TRIG, SW_TRIG
	// TRIGGER_ACT : RISING, FALLING , ANY_EDGE, LEVEL_HI, LEVEL_LO 
	XGS_Ctrl->SetGrabMode(TRIGGER_SRC::IMMEDIATE, TRIGGER_ACT::RISING);


	//---------------------
    // DMA PARAMETERS
    //---------------------
	DMAParams->FSTART     = ImageBufferAddr;          // Adresse Mono pour DMA
	DMAParams->LINE_PITCH = (M_UINT32)ImageBufferLinePitch;     
	DMAParams->LINE_SIZE  = SensorParams->Xsize_Full; // Full window MIL display


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
	printf_s("\n  (y) Set new ROI (Y-only)");
	printf_s("\n  (r) Read current ROI configuration in XGS");
	printf_s("\n  (S) Subsampling mode");
	printf_s("\n  (R) FPGA Reverse Y");
	printf_s("\n  (D) Disable Image Display transfer (Max fps)");
	printf_s("\n  (T) Fpga Monitor(Temp and Supplies)");
	printf_s("\n  (l) Program LUT");
	printf_s("\n  (2) Digital Gain +1 (XGS Dig Gain)");
	printf_s("\n  (1) Digital Gain -1 (XGS Dig Gain)");
	printf_s("\n  (B) White Balance Color Sensor");
	printf_s("\n  (x) Dump XGS registers");


	printf_s("\n\n");

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

	// Test Mode images - Diagonal gray x1
	//XGS_Ctrl->WriteSPI(0x3e0e, 4); // diagonal gray x1

	// Test Mode images - Flat Image
	//M_UINT32 pixelval= 0x3a0;
	//XGS_Ctrl->WriteSPI(0x3e10, pixelval << 1); // Test data Red channel
	//XGS_Ctrl->WriteSPI(0x3e12, pixelval << 1); // Test data Green-R channel
	//XGS_Ctrl->WriteSPI(0x3e14, pixelval << 1); // Test data Bleu channel
	//XGS_Ctrl->WriteSPI(0x3e16, pixelval << 1); // Test data Green-B channel
	//XGS_Ctrl->WriteSPI(0x3e0e, 1);             // Solid color



	while (Sortie == 0)
	{

		if (XGS_Ctrl->sXGSptr.ACQ.GRAB_CTRL.f.TRIGGER_OVERLAP == 0)
			XGS_Ctrl->WaitEndExpReadout();

		XGS_Data->SetDMA();
		XGS_Ctrl->SetGrabCMD(0, PolldoSleep);  // Ici on poll grab pending, s'il est a '1' on attend qu'il descende a '0'  avant de continuer
		GrabCmd++;


		//XGS_Ctrl->WaitEndExpReadout();

		Sortie = XGS_Data->HiSpiCheck(GrabCmd);

		if (Sortie == 1)
		{

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
				MosSprintf(FileName, 50, MIL_TEXT("./Image_Test0001_%d.tiff"), FileDumpNum);
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
				Sleep(1000);
				XGS_Ctrl->DisableRegUpdate();
				Sleep(100);
				printf_s("\nY start0 is 0x%x x4 (%d dec)\n", XGS_Ctrl->ReadSPI(0x381a), XGS_Ctrl->ReadSPI(0x381a) * 4);
				printf_s("Y size0  is 0x%x x4 (%d dec)\n", XGS_Ctrl->ReadSPI(0x381c), XGS_Ctrl->ReadSPI(0x381c) * 4);
				printf_s("Y start1 is 0x%x x4 (%d dec)\n", XGS_Ctrl->ReadSPI(0x381e), XGS_Ctrl->ReadSPI(0x381e) * 4);
				printf_s("Y size1  is 0x%x x4 (%d dec)\n", XGS_Ctrl->ReadSPI(0x3820), XGS_Ctrl->ReadSPI(0x3820) * 4);
				printf_s("Readout Lenght %d Lines, 0x%x, %d dec, time is %dns(without FOT)\n", XGS_Ctrl->rXGSptr.ACQ.READOUT_CFG_FRAME_LINE.f.CURR_FRAME_LINES, XGS_Ctrl->rXGSptr.ACQ.READOUT_CFG2.f.READOUT_LENGTH, XGS_Ctrl->rXGSptr.ACQ.READOUT_CFG2.f.READOUT_LENGTH, XGS_Ctrl->rXGSptr.ACQ.READOUT_CFG2.f.READOUT_LENGTH * 16);
				Sleep(100);
				XGS_Ctrl->EnableRegUpdate();
				break;

			case 'y':
				printf_s("\n\nEnter the new Size Y (1-based, multiple of 4x Lines) (Current is: %d), max is %d : ", GrabParams->Y_SIZE, SensorParams->Ysize_Full);
				scanf_s("%d", &XGSSize_Y);
				GrabParams->Y_END = GrabParams->Y_START + (XGSSize_Y)-1;
				GrabParams->Y_SIZE = XGSSize_Y;
				DMAParams->Y_SIZE  = XGSSize_Y;
				Pcie->rPcie_ptr.debug.dma_debug1.f.add_start = DMAParams->FSTART;                                                   // 0x10000080;
				Pcie->rPcie_ptr.debug.dma_debug2.f.add_overrun = DMAParams->FSTART + ((M_INT64)DMAParams->LINE_PITCH * (M_INT64)GrabParams->Y_SIZE);    // 0x10c00080;
				MbufClear(MilGrabBuffer, 0);
				printf_s("\nNEW calculated Max fps is %lf @Exp_max=~%.0lfus)\n", XGS_Ctrl->Get_Sensor_FPS_PRED_MAX(GrabParams->Y_SIZE, GrabParams->ACTIVE_SUBSAMPLING_Y), XGS_Ctrl->Get_Sensor_EXP_PRED_MAX(GrabParams->Y_SIZE, GrabParams->ACTIVE_SUBSAMPLING_Y));
				printf_s("Please adjust exposure time to increase FPS, current Exposure is %dus\n\n", XGS_Ctrl->getExposure());
				break;

			case 'S':
				XGS_Ctrl->WaitEndExpReadout();

				printf_s("\n\n");
				printf_s("Subsampling X (0=NO, 1=YES) ? : ");
				scanf_s("%d", &SubX);
				printf_s("Subsampling Y (0=NO, 1=YES) ? : ");
				scanf_s("%d", &SubY);

				XGS_Ctrl->GrabParams.SUBSAMPLING_X        = SubX;
				XGS_Ctrl->GrabParams.ACTIVE_SUBSAMPLING_Y = SubY;

				if(SubY== 1)
					DMAParams->Y_SIZE = (GrabParams->Y_END - GrabParams->Y_START + 1 )/2;
				else
					DMAParams->Y_SIZE = (GrabParams->Y_END - GrabParams->Y_START + 1);

				if (SubX == 1) {

                    // see AND9878/D
                    // Increased Row Noise in Mono Subsampling
					// When enabling SUBSAMPLING_X register 0x383C[0] for any of the contexts on a mono configured device(reg 0x3800[1] = 0x0), which results in the read−1−skip−1
                    // configuration for subsampling, the device shows increased row noise.The row noise can be decreased by changing register 0x3402 to 0x1919. The downside of 
                    // this change is that the power consumption will increase by 42 mW on average.
					XGS_Ctrl->WriteSPI(0x3402, 0x1919);

					// Set Location of first valid x pixel(including Interpolation)
					XGS_Ctrl->sXGSptr.HISPI.FRAME_CFG_X_VALID.f.X_START = XGS_Ctrl->SensorParams.XGS_X_START-16;
					XGS_Ctrl->sXGSptr.HISPI.FRAME_CFG_X_VALID.f.X_END   = XGS_Ctrl->SensorParams.XGS_X_START-16 + ((XGS_Ctrl->SensorParams.XGS_X_END + 1 - XGS_Ctrl->SensorParams.XGS_X_START) / 2)-1;
					XGS_Ctrl->rXGSptr.HISPI.FRAME_CFG_X_VALID.u32       = XGS_Ctrl->sXGSptr.HISPI.FRAME_CFG_X_VALID.u32;

					XGS_Data->DMAParams.LINE_SIZE = SensorParams->Xsize_Full / 2;
				}
				else{

					XGS_Ctrl->WriteSPI(0x3402, SensorSpi_0x3402);

					XGS_Ctrl->sXGSptr.HISPI.FRAME_CFG_X_VALID.f.X_START = XGS_Ctrl->SensorParams.XGS_X_START;
					XGS_Ctrl->sXGSptr.HISPI.FRAME_CFG_X_VALID.f.X_END   = XGS_Ctrl->SensorParams.XGS_X_END;
			   	    XGS_Ctrl->rXGSptr.HISPI.FRAME_CFG_X_VALID.u32       = XGS_Ctrl->sXGSptr.HISPI.FRAME_CFG_X_VALID.u32;

					XGS_Data->DMAParams.LINE_SIZE = SensorParams->Xsize_Full;
					
			    }

				MbufClear(MilGrabBuffer, 0);
				printf_s("\nNEW calculated Max fps is %lf @Exp_max=~%.0lfus)\n", XGS_Ctrl->Get_Sensor_FPS_PRED_MAX(GrabParams->Y_SIZE, GrabParams->ACTIVE_SUBSAMPLING_Y), XGS_Ctrl->Get_Sensor_EXP_PRED_MAX(GrabParams->Y_SIZE, GrabParams->ACTIVE_SUBSAMPLING_Y));
				printf_s("Please adjust exposure time to increase FPS, current Exposure is %dus\n\n", XGS_Ctrl->getExposure() );

				break;

			case 't':
				XGS_Ctrl->WaitEndExpReadout();
				cout << "\n";
				XGSTestImageMode ++;
				if (XGSTestImageMode == 7)
				{
					cout << "\nXgs Image Test Mode is Live Mode\n";
					XGSTestImageMode = 0;
					XGS_Ctrl->WriteSPI(0x3e0e, 0); // Normal image
				}

				// Programmable Flat Image
				if (XGSTestImageMode == 1) {
					cout << "\nXgs Image Test Mode is set to Flat Image (Can be programmed to any value), enter pixel 12 bit value : 0x" ;
					M_UINT32 pixelvalue;
					scanf_s("%x", &pixelvalue);

					XGS_Ctrl->WriteSPI(0x3e10, pixelvalue << 1); // Test data Red channel
					XGS_Ctrl->WriteSPI(0x3e12, pixelvalue << 1); // Test data Green-R channel
					XGS_Ctrl->WriteSPI(0x3e14, pixelvalue << 1); // Test data Bleu channel
					XGS_Ctrl->WriteSPI(0x3e16, pixelvalue << 1); // Test data Green-B channel
					XGS_Ctrl->WriteSPI(0x3e0e, 1);     // Solid color
				}
				//  Programmable Horizontal black and white lines
				if (XGSTestImageMode == 2) {
					cout << "\nXgs Image Test Mode is set to Programmable Horizontal black and white lines (Can be programmed to any value)\n";
					XGS_Ctrl->WriteSPI(0x3e10, 0x1fff); // Test data Red channel
					XGS_Ctrl->WriteSPI(0x3e12, 0x1fff); // Test data Green-R channel
					XGS_Ctrl->WriteSPI(0x3e14, 0x0);    // Test data Bleu channel
					XGS_Ctrl->WriteSPI(0x3e16, 0x0);    // Test data Green-B channel
					XGS_Ctrl->WriteSPI(0x3e0e, 1);      // Solid color
				}
				//  Programmable Vertical black and white columns
				if (XGSTestImageMode == 3) {
					cout << "\nXgs Image Test Mode is set to Programmable Vertical black and white columns (Can be programmed to any value)\n";
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
					cout << "\nXgs Image Test Mode is set to Diagonal gray x1\n";
					XGS_Ctrl->WriteSPI(0x3e0e, 4); // diagonal gray x1
				}
				
				// diagonal gray x3	
				if (XGSTestImageMode == 5) {
					cout << "\nXgs Image Test Mode is set to Diagonal gray x3\n";
					XGS_Ctrl->WriteSPI(0x3e0e, 5); // diagonal gray x3		
				}

				// White/Black bar(coarse)
				if (XGSTestImageMode == 6) {
					cout << "\nXgs Image Test Mode is set to White/Black bar(coarse)\n";
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
            
			case 'T':
				XGS_Ctrl->FPGASystemMon();
				break;

			case 'l':	
				XGS_Ctrl->WaitEndExpReadout();
				Sleep(100);
				LUT_PATTERN++;
				if (LUT_PATTERN == 4) LUT_PATTERN = 0;
				XGS_Data->ProgramLUT(LUT_PATTERN);
				XGS_Data->EnableLUT();
				break;
            
			case '2':
				if (DigGain == 127) 
				  DigGain = 127;
				else
				  DigGain++;				
				XGS_Ctrl->setDigitalGain(DigGain);
                break;

			case '1':
				if (DigGain == 1)
					DigGain = 1;
				else
					DigGain--;
				XGS_Ctrl->setDigitalGain(DigGain);
				break;

			case 'x':
				XGS_Ctrl->WaitEndExpReadout();
				Sleep(100);
				XGS_Ctrl->ReadSPI_DumpFile();
				break;

			case 'R':
				XGS_Ctrl->WaitEndExpReadout();
				Sleep(100);

				if(XGS_Data->DMAParams.REVERSE_Y==1)
				  XGS_Data->set_DMA_revY(0, GrabParams->Y_SIZE);
				else
				  XGS_Data->set_DMA_revY(1, GrabParams->Y_SIZE);
				  
				break;

			case 'B':				
				cout << "\nCalculating White Balance...\n";
				XGS_Ctrl->WaitEndExpReadout();
				Sleep(200);
				XGS_Ctrl->SetGrabCMD(0, PolldoSleep);  // Ici on poll grab pending, s'il est a '1' on attend qu'il descende a '0'  avant de continuer
				GrabCmd++;
				XGS_Ctrl->WaitEndExpReadout();
				Sleep(100);
				XGS_Ctrl->rXGSptr.BAYER.WB_MUL1.f.WB_MULT_B = unsigned long(4096 * (float(XGS_Ctrl->rXGSptr.BAYER.WB_G_ACC.f.G_ACC >> 1) / float(XGS_Ctrl->rXGSptr.BAYER.WB_B_ACC.f.B_ACC)));
				XGS_Ctrl->rXGSptr.BAYER.WB_MUL1.f.WB_MULT_G = 0x1000;
				XGS_Ctrl->rXGSptr.BAYER.WB_MUL2.f.WB_MULT_R = unsigned long(4096 * (float(XGS_Ctrl->rXGSptr.BAYER.WB_G_ACC.f.G_ACC >> 1) / float(XGS_Ctrl->rXGSptr.BAYER.WB_R_ACC.f.R_ACC)));			
				break;


			}

		}

	}

    printf_s("\r%dfps   ", XGS_Ctrl->rXGSptr.ACQ.SENSOR_FPS.f.SENSOR_FPS);

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
	printf_s("*    End of Test0000.cpp    *\n");
	printf_s("********************************\n\n");

   }



