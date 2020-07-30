//-----------------------------------------------
//
//  Simple continu test grab Iris4
//
//-----------------------------------------------

/* Headers */
#include "osincludes.h"

#include <mil.h>

#include "MilLayer.h"
#include "XGS_Ctrl.h"
#include "XGS_Data.h"

void test_0002_Continu_2xROI(CXGS_Ctrl* XGS_Ctrl, CXGS_Data* XGS_Data)
   {
	
	MIL_ID MilDisplay;
	MIL_ID MilGrabBuffer;
	unsigned long long ImageBufferAddr=0;

	MIL_ID MilDisplay2;
	MIL_ID MilGrabBuffer2;
	unsigned long long ImageBufferAddr2 = 0;

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

	int ROI_sel   = 0;

	GrabParamStruct*   GrabParams   = XGS_Ctrl->getGrabParams();         // This is a Local Pointer to grab parameter structure
	SensorParamStruct* SensorParams = XGS_Ctrl->getSensorParams();
	DMAParamStruct*    DMAParams    = XGS_Data->getDMAParams();             // This is a Local Pointer to DMA parameter structure

	M_UINT32 FileDumpNum = 0;

	printf("\n\n**************************************\n");
	printf(    "*    Executing Test0002_2xROIcpp    *\n");
	printf(    "**************************************\n\n");



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

	// Init Display with correct X-Y parameters 
	ImageBufferAddr2 = LayerCreateGrabBuffer(&MilGrabBuffer2, SensorParams->Xsize_Full, 2 * SensorParams->Ysize_Full, MonoType);
	LayerInitDisplay(MilGrabBuffer2, &MilDisplay2, 1);
	printf("Adresse buffer display (MemPtr) = 0x%llx \n", ImageBufferAddr2);

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
	GrabParams->Y_START = 4;                                                //1-base Here - Dois etre multiple de 4	:  skip : 4 Interpolation (center image) 
	GrabParams->Y_END   = GrabParams->Y_START + SensorParams->Ysize_Full;	//1-base Here - Dois etre multiple de 4										

	GrabParams->SUBSAMPLING_X        = 0;
	GrabParams->M_SUBSAMPLING_Y      = 0;
	GrabParams->ACTIVE_SUBSAMPLING_Y = 0;

	XGS_Ctrl->setBlackRef(0);

	// GRAB MODE
	// TRIGGER_SRC : NONE, IMMEDIATE, HW_TRIG, SW_TRIG
	// TRIGGER_ACT : RISING, FALLING , ANY_EDGE, LEVEL_HI, LEVEL_LO 
	XGS_Ctrl->SetGrabMode(IMMEDIATE, RISING);





	printf("\n\nTest started at : ");
	XGS_Ctrl->PrintTime();


	//------------------------------------
	//  XGS Ctrl Debug pin
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
	
	XGS_Ctrl->rXGSptr.ACQ.DEBUG_PINS.f.DEBUG0_SEL = 10; 


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
	printf("\n  (y) Set new ROI (Y-only)");
	printf("\n  (r) Read current ROI configuration in XGS");
	printf("\n  (S) Subsampling mode");
	printf("\n\n");

	unsigned long fps_reg;
	

	XGS_Ctrl->rXGSptr.ACQ.READOUT_CFG_FRAME_LINE.f.DUMMY_LINES = 0;


	//---------------------
	// Give SPI control to FPGA
	//---------------------
	XGS_Ctrl->EnableRegUpdate();

	while (Sortie == 0)
	{
		//Sleep(1000);
		if (ROI_sel == 0) {
			//---------------------
            // DMA PARAMETERS 1/4 frame
            //---------------------
			DMAParams->FSTART                = ImageBufferAddr;          // Adresse Mono pour DMA
			DMAParams->LINE_PITCH            = SensorParams->Xsize_Full; // Full window MIL display
			DMAParams->LINE_SIZE             = SensorParams->Xsize_Full;
			GrabParams->SUBSAMPLING_X        = 0;
			GrabParams->M_SUBSAMPLING_Y      = 0;
			GrabParams->ACTIVE_SUBSAMPLING_Y = 0;
			XGS_Ctrl->setBlackRef(0x0);
			XGS_Ctrl->setAnalogGain(1);  //1-2-4
			XGS_Ctrl->setExposure(20000);
			GrabParams->Y_START = 4;                                                //1-base Here - Dois etre multiple de 4	:  skip : 4 Interpolation (center image) 
			GrabParams->Y_END = GrabParams->Y_START + SensorParams->Ysize_Full/4;	//1-base Here - Dois etre multiple de 4										

		} else 
	  	  if (ROI_sel == 1)  {
			 //---------------------
             // DMA PARAMETERS 1/4 frame
             //---------------------
			 DMAParams->FSTART                = ImageBufferAddr+(SensorParams->Xsize_Full* SensorParams->Ysize_Full / 4);          // Adresse Mono pour DMA
			 DMAParams->LINE_PITCH            = SensorParams->Xsize_Full;  // Full window MIL display
			 DMAParams->LINE_SIZE             = SensorParams->Xsize_Full;
			 GrabParams->SUBSAMPLING_X        = 0;
			 GrabParams->M_SUBSAMPLING_Y      = 0;
			 GrabParams->ACTIVE_SUBSAMPLING_Y = 0;
			 XGS_Ctrl->setBlackRef(0);
			 XGS_Ctrl->setAnalogGain(1);  //1-2-4
			 XGS_Ctrl->setExposure(40000);
			 GrabParams->Y_START = 4+SensorParams->Ysize_Full/4;                                                //1-base Here - Dois etre multiple de 4	:  skip : 4 Interpolation (center image) 
			 GrabParams->Y_END   = GrabParams->Y_START + SensorParams->Ysize_Full/4;	//1-base Here - Dois etre multiple de 4										
		  } else
			  if (ROI_sel == 2) {
				  //---------------------
				  // DMA PARAMETERS  1/4 frame
				  //---------------------
				  DMAParams->FSTART = ImageBufferAddr + (SensorParams->Xsize_Full * SensorParams->Ysize_Full / 2);          // Adresse Mono pour DMA
				  DMAParams->LINE_PITCH = SensorParams->Xsize_Full;  // Full window MIL display
				  DMAParams->LINE_SIZE = SensorParams->Xsize_Full;
				  GrabParams->SUBSAMPLING_X = 0;
				  GrabParams->M_SUBSAMPLING_Y = 0;
				  GrabParams->ACTIVE_SUBSAMPLING_Y = 0;
				  XGS_Ctrl->setBlackRef(0);
				  XGS_Ctrl->setAnalogGain(1);  //1-2-4
				  XGS_Ctrl->setExposure(60000);
				  GrabParams->Y_START = 4 + SensorParams->Ysize_Full / 2;                                                //1-base Here - Dois etre multiple de 4	:  skip : 4 Interpolation (center image) 
				  GrabParams->Y_END = GrabParams->Y_START + SensorParams->Ysize_Full / 4;	//1-base Here - Dois etre multiple de 4										
			  }
			  else
				  if (ROI_sel ==  3) {
					  //---------------------
					  // DMA PARAMETERS  1/4 frame
					  //---------------------
					  DMAParams->FSTART = ImageBufferAddr + (SensorParams->Xsize_Full * SensorParams->Ysize_Full * 3 / 4);          // Adresse Mono pour DMA
					  DMAParams->LINE_PITCH = SensorParams->Xsize_Full;  // Full window MIL display
					  DMAParams->LINE_SIZE = SensorParams->Xsize_Full;
					  GrabParams->SUBSAMPLING_X = 0;
					  GrabParams->M_SUBSAMPLING_Y = 0;
					  GrabParams->ACTIVE_SUBSAMPLING_Y = 0;
					  XGS_Ctrl->setBlackRef(0);
					  XGS_Ctrl->setAnalogGain(1);  //1-2-4
					  XGS_Ctrl->setExposure(80000);
					  GrabParams->Y_START = 4 + SensorParams->Ysize_Full *3 / 4;                                                //1-base Here - Dois etre multiple de 4	:  skip : 4 Interpolation (center image) 
					  GrabParams->Y_END = GrabParams->Y_START + SensorParams->Ysize_Full / 4;	//1-base Here - Dois etre multiple de 4										
				  }
				  else
					  if (ROI_sel == 4) {
						  //---------------------
						  // DMA PARAMETERS 1 full frame
						  //---------------------
						  DMAParams->FSTART = ImageBufferAddr2;          // Adresse Mono pour DMA
						  DMAParams->LINE_PITCH = SensorParams->Xsize_Full;  // Full window MIL display
						  DMAParams->LINE_SIZE  = SensorParams->Xsize_Full;
						  GrabParams->SUBSAMPLING_X        = 0;
						  GrabParams->M_SUBSAMPLING_Y      = 0;
						  GrabParams->ACTIVE_SUBSAMPLING_Y = 0;
						  XGS_Ctrl->setBlackRef(0);
						  XGS_Ctrl->setAnalogGain(1);  //1-2-4
						  XGS_Ctrl->setExposure(30000);
						  GrabParams->Y_START = 4 ;                   //1-base Here - Dois etre multiple de 4	:  skip : 4 Interpolation (center image) 
						  GrabParams->Y_END   = GrabParams->Y_START + SensorParams->Ysize_Full;	//1-base Here - Dois etre multiple de 4										
					  }


		XGS_Data->SetDMA();
		XGS_Ctrl->SetGrabCMD(0, PolldoSleep);  // Ici on poll grab pending, s'il est a '1' on attend qu'il descende a '0'  avant de continuer

		XGS_Ctrl->WaitEndExpReadout();


		if (ROI_sel == 0 || ROI_sel == 1 || ROI_sel == 2 || ROI_sel == 3) {
			MbufControl(MilGrabBuffer, M_MODIFIED, M_DEFAULT);
		}
		else {
			MbufControl(MilGrabBuffer2, M_MODIFIED, M_DEFAULT);
		}


		ROI_sel++;
	    if(ROI_sel == 5)
		  ROI_sel = 0;

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
#if M_MIL_UNICODE_API
				printf("\nPrinting .tiff file: %S\n", FileName);
#else
				printf("\nPrinting .tiff file: %s\n", FileName);
#endif
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

	MbufFree(MilGrabBuffer2);
	MdispFree(MilDisplay2);


	//----------------------
	// Disable HW
	//----------------------
	XGS_Ctrl->DisableXGS();  //reset and disable clk

	printf("\n\n********************************\n");
	printf("*    End of Test0000.cpp    *\n");
	printf("********************************\n\n");

   }



