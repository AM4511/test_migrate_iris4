//-----------------------------------------------
//
//  Simple continu test grab Iris4
//
//-----------------------------------------------

/* Headers */
#include <stdio.h> 
#include <stdlib.h> 
#include <conio.h> 
#include <time.h>
#include <math.h>
#include <Windows.h>
#include <mil.h>

#include "MilLayer.h"
#include "XGS_Ctrl.h"


void test_0000_Continu(CXGS_Ctrl* Camera)
   {
	
	MIL_ID MilDisplay;
	MIL_ID MilGrabBuffer;
	unsigned long long ImageBufferAddr=0;
	int MonoType = 8;

	int Sortie = 0;
	char ch;

	bool CheckCRC   = true;
	bool DisplayOn  = true;
	int PolldoSleep = 1;
	bool FPS_On     = true;
	M_UINT32 ExposureIncr = 10;

	GrabParamStruct*   GrabParams   = Camera->getGrabParams();         // This is a Local Pointer to grab parameter structure
	SensorParamStruct* SensorParams = Camera->getSensorParams();


	printf("\n\n********************************\n");
	printf(    "*    Executing Test0000.cpp    *\n");
	printf(    "********************************\n\n");



	//------------------------------
    // INITIALIZE XGS SENSOR
    //------------------------------
	Camera->InitXGS();


	//---------------------
    //
    // MIL LAYER 
    //
    //---------------------
	// Init Display with correct X-Y parameters 
	//ImageBufferAddr = LayerCreateGrabBuffer(&MilGrabBuffer, SensorParams->Xsize_Full, SensorParams->Ysize_Full, MonoType);
	//LayerInitDisplay(MilGrabBuffer, &MilDisplay, 1);

	GrabParams->FrameStart = ImageBufferAddr;

	printf("Adresse buffer display (MemPtr) = 0x%llx \n", ImageBufferAddr);



	//---------------------
    // GRAB PARAMETERS
    //---------------------
	Camera->setExposure(40000);

	// For a full frame ROI
	M_UINT32 ROI_Y_START = 0;                                         // Premiere ligne d'interpolation (si centree + 4)
	M_UINT32 ROI_Y_END   = ROI_Y_START + SensorParams->Ysize_Full;  

	GrabParams->SUBSAMPLING_X        = 0;
	GrabParams->M_SUBSAMPLING_Y      = 0;
	GrabParams->ACTIVE_SUBSAMPLING_Y = 0;

	GrabParams->COLOR_SPACE = 0x0;

	Camera->setBlackRef(0);

	// GRAB MODE
	// TRIGGER_SRC : NONE, IMMEDIATE, HW_TRIG, SW_TRIG
	// TRIGGER_ACT : RISING, FALLING , ANY_EDGE, LEVEL_HI, LEVEL_LO 
	Camera->SetGrabMode(IMMEDIATE, RISING);


	printf("\n\nTest started at : ");
	Camera->PrintTime();


	//---------------------
	// START GRAB 
	//---------------------
	Camera->sXGSptr.ACQ.DEBUG_PINS.u32 = 0;
	Camera->rXGSptr.ACQ.DEBUG_PINS.u32 = Camera->sXGSptr.ACQ.DEBUG_PINS.u32;

	printf("\n\n  (q) Quit this test");
	printf("\n  (f) Print current FPS");
	printf("\n  (d) Dump XGS controller registers(PCIe)");
	printf("\n  (+) Increase Exposure");
	printf("\n  (-) Decrease Exposure");
	printf("\n  (e) Exposure Incr/Decr gap");
	printf("\n\n");

	unsigned long fps_reg;
	

	Camera->rXGSptr.ACQ.READOUT_CFG_FRAME_LINE.f.DUMMY_LINES = 0;


	while (Sortie == 0)
	{

		if (Camera->sXGSptr.ACQ.GRAB_CTRL.f.TRIGGER_OVERLAP == 0)
			Camera->WaitEndExpReadout();

		Camera->SetGrabCMD(0, PolldoSleep);  // Ici on poll grab pending, s'il est a '1' on attend qu'il descende a '0'  avant de continuer


		//if (FPS_On)
		//{
		//	fps_reg = Camera->rXGSptr.ACQ.SENSOR_FPS.u32;
		//	printf("\r%dfps   ", Camera->rXGSptr.ACQ.SENSOR_FPS.f.SENSOR_FPS);
		//	//if ((fps_reg & 0xffff) == 0xffff)
		//    //{
		//	//	printf("\n\nERROR de lecture au registre du fpga fps, press enter to continue! 0x%X\n\n\n", fps_reg);
		//	//	_getch();
		//	//}
		//}


		//if (DisplayOn)
		//{
		//	//MappTimer(M_DEFAULT, M_TIMER_READ, &DisplayLength0);
		//	MbufControl(MilGrabBuffer, M_MODIFIED, M_DEFAULT);
		//	//MappTimer(M_DEFAULT, M_TIMER_READ, &DisplayLength1);
		//	//printf("%f", DisplayLength1 - DisplayLength0);
		//}



		if (_kbhit())
		{
			ch = _getch();
			switch (ch)
			{
			case 'q':
				Sortie = 1;
				Camera->SetGrabMode(NONE, LEVEL_HI);
				Camera->GrabAbort();
				printf("\n\n");
				printf("Exit! \n");
				break;

			case 'd':
				Sleep(100);
				Camera->XGS_PCIeCtrl_DumpFile();
				Sleep(100);
				break;

			case 'f':
				fps_reg = Camera->rXGSptr.ACQ.SENSOR_FPS.u32;
				printf("\r%dfps   ", Camera->rXGSptr.ACQ.SENSOR_FPS.f.SENSOR_FPS);
				break;

			case 'e':
				printf("\nEnter the ExposureIncr/Decr in us : ");
				scanf_s("%d", &ExposureIncr);
				printf("\n");
				break;

			case '+':
				Camera->setExposure(Camera->getExposure() + ExposureIncr);
				printf("\r\t\tExposure set to: %d us\n  ", Camera->getExposure() + ExposureIncr);
				break;

			case '-':
				Camera->setExposure(Camera->getExposure() - ExposureIncr);
				printf("\r\t\tExposure set to: %d us\n  ", Camera->getExposure() - ExposureIncr);
				break;

			case 'p':
				printf("Paused. Press enter to restart grab...");
				_getch();
				printf(" GO!\n");
				break;

			}



		}

	}

	fps_reg = Camera->rXGSptr.ACQ.SENSOR_FPS.u32;
	printf("\r%dfps   ", Camera->rXGSptr.ACQ.SENSOR_FPS.f.SENSOR_FPS);

	//------------------------------
	// Free MIL Display
	//------------------------------
	//MbufFree(MilGrabBuffer);
	//MdispFree(MilDisplay);




	//----------------------
	// Disable HW
	//----------------------
	Camera->DisableXGS();  //reset and disable clk

	printf("\n\n********************************\n");
	printf("*    End of Test0000.cpp    *\n");
	printf("********************************\n\n");

   }



