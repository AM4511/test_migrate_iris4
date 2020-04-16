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


void test_0001_SWtrig(CXGS_Ctrl* XGS_Ctrl)
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
	M_UINT32 nbGrab = 0;

	M_UINT32 ExposureIncr = 10;
	M_UINT32 BlackOffset  = 0x100;
	M_UINT32 XGSSize_Y = 0;
	GrabParamStruct*   GrabParams   = XGS_Ctrl->getGrabParams();         // This is a Local Pointer to grab parameter structure
	SensorParamStruct* SensorParams = XGS_Ctrl->getSensorParams();


	printf("\n\n********************************\n");
	printf(    "*    Executing Test0001.cpp    *\n");
	printf(    "********************************\n\n");



	//------------------------------
    // INITIALIZE XGS SENSOR
    //------------------------------
	XGS_Ctrl->InitXGS();


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
	XGS_Ctrl->setExposure(8000);

	// For a full frame ROI 
	GrabParams->Y_START = 0;                                               //1-base Here - Dois etre multiple de 4
	GrabParams->Y_END   = GrabParams->Y_START + SensorParams->Ysize_Full;  //1-base Here - Dois etre multiple de 4
	//GrabParams->Y_END   = 8;

	GrabParams->SUBSAMPLING_X        = 0;
	GrabParams->M_SUBSAMPLING_Y      = 0;
	GrabParams->ACTIVE_SUBSAMPLING_Y = 0;

	GrabParams->COLOR_SPACE = 0x0;

	XGS_Ctrl->setBlackRef(0);

	// GRAB MODE
	// TRIGGER_SRC : NONE, IMMEDIATE, HW_TRIG, SW_TRIG
	// TRIGGER_ACT : RISING, FALLING , ANY_EDGE, LEVEL_HI, LEVEL_LO 
	XGS_Ctrl->SetGrabMode(SW_TRIG, RISING);


	printf("\n\nTest started at : ");
	XGS_Ctrl->PrintTime();


	//---------------------
	// START GRAB 
	//---------------------
	XGS_Ctrl->sXGSptr.ACQ.DEBUG_PINS.u32 = 0;
	XGS_Ctrl->rXGSptr.ACQ.DEBUG_PINS.u32 = XGS_Ctrl->sXGSptr.ACQ.DEBUG_PINS.u32;

	printf("\n");
	printf("\n  (q) Quit this test");
	printf("\n  (f) Print current FPS");
	printf("\n  (d) Dump XGS controller registers(PCIe)");
	printf("\n  (g) Change Analog Gain");
	printf("\n  (b) Change Black Offset(XGS Data Pedestal)");
	printf("\n  (+) Increase Exposure");
	printf("\n  (-) Decrease Exposure");
	printf("\n  (e) Exposure Incr/Decr gap");
	printf("\n");
	printf("\n  (s) To do a SW snapshot");

	printf("\n\n");

	unsigned long fps_reg;
	

	XGS_Ctrl->rXGSptr.ACQ.READOUT_CFG_FRAME_LINE.f.DUMMY_LINES = 0;


	//---------------------
	// Give SPI control to FPGA
	//---------------------
	XGS_Ctrl->EnableRegUpdate();

	while (Sortie == 0)
	{

		if (XGS_Ctrl->sXGSptr.ACQ.GRAB_CTRL.f.TRIGGER_OVERLAP == 0)
			XGS_Ctrl->WaitEndExpReadout();

		//if (FPS_On)
		//{
		//	fps_reg = XGS_Ctrl->rXGSptr.ACQ.SENSOR_FPS.u32;
		//	printf("\r%dfps   ", XGS_Ctrl->rXGSptr.ACQ.SENSOR_FPS.f.SENSOR_FPS);
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
				XGS_Ctrl->SetGrabMode(NONE, LEVEL_HI);
				XGS_Ctrl->GrabAbort();
				printf("\n\n");
				printf("Exit! \n");
				break;

			case 'd':
				Sleep(100);
				XGS_Ctrl->XGS_PCIeCtrl_DumpFile();
				Sleep(100);
				break;

			case 'f':
				fps_reg = XGS_Ctrl->rXGSptr.ACQ.SENSOR_FPS.u32;
				printf("\r%dfps   ", XGS_Ctrl->rXGSptr.ACQ.SENSOR_FPS.f.SENSOR_FPS);
				break;

			case 'e':
				printf("\nEnter the ExposureIncr/Decr in us : ");
				scanf_s("%d", &ExposureIncr);
				printf("\n");
				break;

			case '+':
				XGS_Ctrl->setExposure(XGS_Ctrl->getExposure() + ExposureIncr);
				printf("\r\t\tExposure set to: %d us\n  ", XGS_Ctrl->getExposure() + ExposureIncr);
				break;

			case '-':
				XGS_Ctrl->setExposure(XGS_Ctrl->getExposure() - ExposureIncr);
				printf("\r\t\tExposure set to: %d us\n  ", XGS_Ctrl->getExposure() - ExposureIncr);
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
				printf("\nY start0 is 0x%x x4 (%d dec)\n", XGS_Ctrl->ReadSPI(0x381a), XGS_Ctrl->ReadSPI(0x381a)*4);
				printf("Y size0  is 0x%x x4 (%d dec)\n", XGS_Ctrl->ReadSPI(0x381c), XGS_Ctrl->ReadSPI(0x381c)*4 );
				printf("Y start1 is 0x%x x4 (%d dec)\n", XGS_Ctrl->ReadSPI(0x381e), XGS_Ctrl->ReadSPI(0x381e)*4 );
				printf("Y size1  is 0x%x x4 (%d dec)\n", XGS_Ctrl->ReadSPI(0x3820), XGS_Ctrl->ReadSPI(0x3820)*4 );
				printf("Readout Lenght %d Lines, 0x%x, %d dec, time is %dns(without FOT)\n", XGS_Ctrl->rXGSptr.ACQ.READOUT_CFG_FRAME_LINE.f.CURR_FRAME_LINES, XGS_Ctrl->rXGSptr.ACQ.READOUT_CFG2.f.READOUT_LENGTH, XGS_Ctrl->rXGSptr.ACQ.READOUT_CFG2.f.READOUT_LENGTH, XGS_Ctrl->rXGSptr.ACQ.READOUT_CFG2.f.READOUT_LENGTH *16);
				Sleep(100);
				XGS_Ctrl->EnableRegUpdate();
				break;

			case 'y':
				printf("\nEnter the new Size Y (1-based): ");
				scanf_s("%d", &XGSSize_Y);				
				GrabParams->Y_END = XGSSize_Y;


			case 's':
				Sortie = 0;

				XGS_Ctrl->SetGrabCMD(0, PolldoSleep);     // Ici on poll grab pending, s'il est a '1' on attend qu'il descende a '0'  avant de continuer
				XGS_Ctrl->SW_snapshot(0);                  // Ici on poll trig_rdy avant d'envoyer le trigger
				XGS_Ctrl->WaitEndExpReadout();
				//MbufControl(MilGrabBuffer, M_MODIFIED, M_DEFAULT);
				nbGrab++;
				printf("\rGrabSnapshot completed : %d           ", nbGrab);

				break;

			}



		}

	}

	fps_reg = XGS_Ctrl->rXGSptr.ACQ.SENSOR_FPS.u32;
	printf("\r%dfps   ", XGS_Ctrl->rXGSptr.ACQ.SENSOR_FPS.f.SENSOR_FPS);

	//------------------------------
	// Free MIL Display
	//------------------------------
	//MbufFree(MilGrabBuffer);
	//MdispFree(MilDisplay);




	//----------------------
	// Disable HW
	//----------------------
	XGS_Ctrl->DisableXGS();  //reset and disable clk

	printf("\n\n********************************\n");
	printf("*    End of Test0000.cpp    *\n");
	printf("********************************\n\n");

   }



