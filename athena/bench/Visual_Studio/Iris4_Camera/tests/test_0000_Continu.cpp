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
	unsigned long long ImageBufferAddr=0;
	int MonoType = 8;

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

	printf("\n\n********************************\n");
	printf(    "*    Executing Test0000.cpp    *\n");
	printf(    "********************************\n\n");



	//------------------------------
    // INITIALIZE XGS SENSOR
    //------------------------------
	XGS_Ctrl->InitXGS();

	//---------------------------------
	// Calibrate FPGA HiSPI interface
	//---------------------------------
	XGS_Data->HiSpiCalibrate();

	//---------------------
    //
    // MIL LAYER 
    //
    //---------------------
	// Init Display with correct X-Y parameters 
	ImageBufferAddr = LayerCreateGrabBuffer(&MilGrabBuffer, SensorParams->Xsize_Full, 2*SensorParams->Ysize_Full, MonoType);
	LayerInitDisplay(MilGrabBuffer, &MilDisplay, 1);
	printf("Adresse buffer display (MemPtr) = 0x%llx \n", ImageBufferAddr);

	//printf("\nDo you want to transfer grab images to host frame memory?  (0=No, 1=Yes) : ");
	//ch = _getch();
	ch = '1';

	if (ch == '0')
		DisplayOn = false;
	else
		DisplayOn = true;
	printf("\n");


	//---------------------
    // GRAB PARAMETERS
    //---------------------
	XGS_Ctrl->setExposure(30000);

	// For a full frame ROI 
	GrabParams->Y_START = 4;                                                // 1-base Here - Dois etre multiple de 4	:  skip : 4 Interpolation (center image) 
	GrabParams->Y_END   = GrabParams->Y_START + SensorParams->Ysize_Full;	// 1-base Here - Dois etre multiple de 4
	//GrabParams->Y_END   = 8;

	GrabParams->SUBSAMPLING_X        = 0;
	GrabParams->M_SUBSAMPLING_Y      = 0;
	GrabParams->ACTIVE_SUBSAMPLING_Y = 0;

	XGS_Ctrl->setBlackRef(0);

	// GRAB MODE
	// TRIGGER_SRC : NONE, IMMEDIATE, HW_TRIG, SW_TRIG
	// TRIGGER_ACT : RISING, FALLING , ANY_EDGE, LEVEL_HI, LEVEL_LO 
	XGS_Ctrl->SetGrabMode(IMMEDIATE, RISING);


	//---------------------
    // DMA PARAMETERS
    //---------------------
	DMAParams->FSTART     = ImageBufferAddr;          // Adresse Mono pour DMA
	DMAParams->LINE_PITCH = SensorParams->Xsize_Full; // Full window MIL display
	DMAParams->LINE_SIZE  = SensorParams->Xsize_Full;



	printf("\n\nTest started at : ");
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
	XGS_Ctrl->rXGSptr.ACQ.DEBUG_PINS.f.DEBUG0_SEL = 31; 
	XGS_Ctrl->rXGSptr.ACQ.DEBUG_PINS.f.DEBUG1_SEL = 5;
	XGS_Ctrl->rXGSptr.ACQ.DEBUG_PINS.f.DEBUG2_SEL = 17;
	XGS_Ctrl->rXGSptr.ACQ.DEBUG_PINS.f.DEBUG3_SEL = 18;

	//Setup de mesure pour FOT, ReadOutN_2_TrigN, TrigN_2_FOT, EXP_FOT, EXP_FOT_TIME
	XGS_Ctrl->rXGSptr.ACQ.DEBUG_PINS.f.DEBUG0_SEL = 8;
	XGS_Ctrl->rXGSptr.ACQ.DEBUG_PINS.f.DEBUG1_SEL = 8;
	XGS_Ctrl->rXGSptr.ACQ.DEBUG_PINS.f.DEBUG2_SEL = 8;
	XGS_Ctrl->rXGSptr.ACQ.DEBUG_PINS.f.DEBUG3_SEL = 8;

	// Setup de mesure pour KEEP_OUT_ZONE_START
	//XGS_Ctrl->rXGSptr.ACQ.DEBUG_PINS.f.DEBUG0_SEL = ;
	//XGS_Ctrl->rXGSptr.ACQ.DEBUG_PINS.f.DEBUG1_SEL = ;
	//XGS_Ctrl->rXGSptr.ACQ.DEBUG_PINS.f.DEBUG2_SEL = ;
	//XGS_Ctrl->rXGSptr.ACQ.DEBUG_PINS.f.DEBUG3_SEL = ;

	//---------------------
	// START GRAB 
	//---------------------
	printf("\n");
	printf("\n  (q) Quit this test");
	printf("\n  (f) Dump image to .tiff file");
	printf("\n  (d) Dump XGS controller registers(PCIe)");
	printf("\n  (g) Change Analog Gain");
	printf("\n  (b) Change Black Offset(XGS Data Pedestal)");
	printf("\n  (e) Exposure Incr/Decr gap");
	printf("\n  (+) Increase Exposure");
	printf("\n  (-) Decrease Exposure");
	printf("\n  (p) Pause grab");
	printf("\n  (t) XGS test images");
	printf("\n  (y) Set new ROI (Y-only)");
	printf("\n  (r) Read current ROI configuration in XGS");
	printf("\n  (S) Subsampling mode");
	printf("\n  (D) Disable Image Display transfer (Max fps)");
	printf("\n\n");

	unsigned long fps_reg;
	

	XGS_Ctrl->rXGSptr.ACQ.READOUT_CFG_FRAME_LINE.f.DUMMY_LINES = 0;


	// For debug DMA overrun with full 12Mpix sensor
	Pcie->rPcie_ptr.debug.dma_debug1.f.add_start   = 0x10000080;
	Pcie->rPcie_ptr.debug.dma_debug2.f.add_overrun = 0x10c00080;

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

		//XGS_Ctrl->WaitEndExpReadout();



		if (FPS_On)
		{

			// Le max FPS est facile a calculer : Treadout2trigfall + Ttrigfall2FOTstart + Tfot + Treadout(3+Mline+1xEmb+YReadout+7exp+7dummy)
			// Tfot fixe en nmbre de lignes est plus securitaire car il permet un calcul plus precis sans imprecissions
			//
			// Le exp_max pour fps max est un peu plus tricky a calculer.
			// Avec le Xcerelator j'utilise une exposure_synthetique qui ne reflete pas le timing exact du real_integration, 
			// alors il est tres difficile de calculer le bon Exposure max. De plus ca peux expliquer aussi pourquoi il y a un 
			// width minimum sur le signal trig0 du senseur.

			fps_reg = XGS_Ctrl->rXGSptr.ACQ.SENSOR_FPS.u32;

			printf("\r%dfps(%.2f), Calculated Max fps is %f @Exp_max=~%.0fus)        ", XGS_Ctrl->rXGSptr.ACQ.SENSOR_FPS.f.SENSOR_FPS, XGS_Ctrl->rXGSptr.ACQ.SENSOR_FPS2.f.SENSOR_FPS/10.0,
				1.0 / (double(XGS_Ctrl->SensorParams.ReadOutN_2_TrigN / 1000000000.0) + double(XGS_Ctrl->SensorParams.TrigN_2_FOT / 1000000000.0) + double((XGS_Ctrl->sXGSptr.ACQ.READOUT_CFG3.f.LINE_TIME * XGS_Ctrl->SensorPeriodNanoSecond / 1000000000.0) * double(XGS_Ctrl->sXGSptr.ACQ.READOUT_CFG1.f.FOT_LENGTH_LINE + 3 + XGS_Ctrl->sXGSptr.ACQ.SENSOR_M_LINES.f.M_LINES_SENSOR + 1 + ((4 * XGS_Ctrl->sXGSptr.ACQ.SENSOR_ROI_Y_SIZE.f.Y_SIZE) / (1 + XGS_Ctrl->GrabParams.ACTIVE_SUBSAMPLING_Y)) + 7 + 7))),
				((XGS_Ctrl->rXGSptr.ACQ.READOUT_CFG_FRAME_LINE.f.CURR_FRAME_LINES) * XGS_Ctrl->sXGSptr.ACQ.READOUT_CFG3.f.LINE_TIME * XGS_Ctrl->SensorPeriodNanoSecond / 1000.0)
				- double(XGS_Ctrl->SensorParams.Trig_2_EXP / 1000) + double(XGS_Ctrl->SensorParams.ReadOutN_2_TrigN / 1000.0) + double(XGS_Ctrl->SensorParams.EXP_FOT_TIME / 1000.0)
				//EXP_FOT_TIME comprend : SensorParams.TrigN_2_FOT + 5360
			);
		}

		
	
		if (DisplayOn)
		//{
		//	//MappTimer(M_DEFAULT, M_TIMER_READ, &DisplayLength0);
			MbufControl(MilGrabBuffer, M_MODIFIED, M_DEFAULT);
		//	//MappTimer(M_DEFAULT, M_TIMER_READ, &DisplayLength1);
		//	//printf("%f", DisplayLength1 - DisplayLength0);
		//}


		//Overrun detection
		OverrunPixel = XGS_Data->GetImagePixel8(LayerGetHostAddressBuffer(MilGrabBuffer), 0, GrabParams->Y_END - GrabParams->Y_START, MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL));
		if (OverrunPixel != 0)
		{
			Overrun++;
			printf(" DMA Overflow detected: %d\n", Overrun);
			//printf("Press enter to continue...\n");
			//_getch();
			XGS_Data->SetImagePixel8(LayerGetHostAddressBuffer(MilGrabBuffer), 0, GrabParams->Y_END - GrabParams->Y_START, MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL), 0); //reset overrun pixel

		}




		if (_kbhit())
		{
			ch = _getch();
			switch (ch)
			{
			case 'q':
				Sortie = 1;
				XGS_Ctrl->SetGrabMode(NONE, LEVEL_HI);
				XGS_Ctrl->GrabAbort();
				XGS_Ctrl->DisableXGS();
				XGS_Data->HiSpiClr();
				printf("\n\n");
				printf("Exit! \n");
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
				if(sizeof(MIL_TEXT_CHAR) == 1)
					printf("\nPrinting .tiff file: %s\n", FileName);
				else
					printf("\nPrinting .tiff file: %S\n", FileName);
				MbufSave(FileName, MilGrabBuffer);
				break;


			case 'e':
				printf("\nEnter the ExposureIncr/Decr in us : ");
				scanf_s("%d", &ExposureIncr);
				printf("\n");
				break;

			case '+':
				XGS_Ctrl->setExposure(XGS_Ctrl->getExposure() + ExposureIncr);
				//printf("\r\t\tExposure set to: %d us\n  ", XGS_Ctrl->getExposure() + ExposureIncr);
				break;

			case '-':
				XGS_Ctrl->setExposure(XGS_Ctrl->getExposure() - ExposureIncr);
				//printf("\r\t\tExposure set to: %d us\n  ", XGS_Ctrl->getExposure() - ExposureIncr);
				break;

			case 'g':
				if (GrabParams->ANALOG_GAIN == 1) //if curr=1x -> set 2x
					XGS_Ctrl->setAnalogGain(2);
				else if (GrabParams->ANALOG_GAIN == 3) //if curr=2x -> set 4x
					XGS_Ctrl->setAnalogGain(4);
				else if (GrabParams->ANALOG_GAIN == 7) //if curr=4x -> set 1x
					XGS_Ctrl->setAnalogGain(1);
				printf("\n");
				break;

			case 'b':
				printf("\nEnter Black Offset in HEX (Data Pedestal, 0-0xfff LSB12) : 0x");
				scanf_s("%x", &BlackOffset);
				XGS_Ctrl->setBlackRef(BlackOffset);
				break;


			case 'p':
				printf("Paused. Press enter to restart grab...");
				_getch();
				printf(" GO!\n");
				break;

			case 'r':
				Sleep(1000);
				XGS_Ctrl->DisableRegUpdate();
				Sleep(100);
				printf("\nY start0 is 0x%x x4 (%d dec)\n", XGS_Ctrl->ReadSPI(0x381a), XGS_Ctrl->ReadSPI(0x381a) * 4);
				printf("Y size0  is 0x%x x4 (%d dec)\n", XGS_Ctrl->ReadSPI(0x381c), XGS_Ctrl->ReadSPI(0x381c) * 4);
				printf("Y start1 is 0x%x x4 (%d dec)\n", XGS_Ctrl->ReadSPI(0x381e), XGS_Ctrl->ReadSPI(0x381e) * 4);
				printf("Y size1  is 0x%x x4 (%d dec)\n", XGS_Ctrl->ReadSPI(0x3820), XGS_Ctrl->ReadSPI(0x3820) * 4);
				printf("Readout Lenght %d Lines, 0x%x, %d dec, time is %dns(without FOT)\n", XGS_Ctrl->rXGSptr.ACQ.READOUT_CFG_FRAME_LINE.f.CURR_FRAME_LINES, XGS_Ctrl->rXGSptr.ACQ.READOUT_CFG2.f.READOUT_LENGTH, XGS_Ctrl->rXGSptr.ACQ.READOUT_CFG2.f.READOUT_LENGTH, XGS_Ctrl->rXGSptr.ACQ.READOUT_CFG2.f.READOUT_LENGTH * 16);
				Sleep(100);
				XGS_Ctrl->EnableRegUpdate();
				break;

			case 'y':
				printf("\nEnter the new Size Y (1-based) (Current is: %d) ", GrabParams->Y_END);
				scanf_s("%d", &XGSSize_Y);
				GrabParams->Y_END = GrabParams->Y_START + XGSSize_Y;
				break;

			case 'S':
				XGS_Ctrl->WaitEndExpReadout();

				printf("\n\n");
				printf("Subsampling X (0=NO, 1=YES) ? : ");
				scanf_s("%d", &SubX);
				printf("Subsampling Y (0=NO, 1=YES) ? : ");
				scanf_s("%d", &SubY);

				XGS_Ctrl->GrabParams.SUBSAMPLING_X = SubX;
				XGS_Ctrl->GrabParams.ACTIVE_SUBSAMPLING_Y = SubY;

				printf("\n");

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
					XGS_Ctrl->WriteSPI(0x3e10, 0x7ff); // Test data Red channel
					XGS_Ctrl->WriteSPI(0x3e12, 0x7ff); // Test data Green-R channel
					XGS_Ctrl->WriteSPI(0x3e14, 0x7ff); // Test data Bleu channel
					XGS_Ctrl->WriteSPI(0x3e16, 0x7ff); // Test data Green-B channel
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

			}



		}

	}

	fps_reg = XGS_Ctrl->rXGSptr.ACQ.SENSOR_FPS.u32;
	printf("\r%dfps   ", XGS_Ctrl->rXGSptr.ACQ.SENSOR_FPS.f.SENSOR_FPS);

	//------------------------------
	// Free MIL Display
	//------------------------------
	MbufFree(MilGrabBuffer);
	MdispFree(MilDisplay);

	//----------------------
	// Disable HW
	//----------------------
	XGS_Ctrl->DisableXGS();  //reset and disable clk

	printf("\n\n********************************\n");
	printf("*    End of Test0000.cpp    *\n");
	printf("********************************\n\n");

   }



