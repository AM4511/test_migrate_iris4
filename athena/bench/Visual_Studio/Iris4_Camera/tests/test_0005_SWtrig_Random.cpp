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
#include <process.h>

#include "MilLayer.h"
#include "XGS_Ctrl.h"
#include "XGS_Data.h"

extern int rand1(unsigned int val_max);
extern void srand1(unsigned int seed);

HANDLE AbortRunning_0005;
bool StopAbortThread_0005;

void AsyncAbortThread_0005(void* In)
{
	int nb_aborts_ok = 0;
	CXGS_Ctrl* XGS_Ctrl = (CXGS_Ctrl*)In;
	DWORD VarDelai;

	StopAbortThread_0005 = FALSE;

	while (StopAbortThread_0005 == FALSE)
	{
		WaitForSingleObject(AbortRunning_0005, INFINITE);

		nb_aborts_ok = nb_aborts_ok + XGS_Ctrl->GrabAbort();                  // Abort in FPGA

		printf(" NB Aborts: %d    ", nb_aborts_ok);

		ReleaseMutex(AbortRunning_0005);

		//VarDelai = (rand1(750) + 250); // Delai entre 250ms et 1000 ms
		VarDelai = rand1(250) + 500;
		Sleep(VarDelai);
	}
}



void test_0005_SWtrig_Random(CXGS_Ctrl* XGS_Ctrl, CXGS_Data* XGS_Data)
   {
	
	srand1((unsigned)clock());

	AbortRunning_0005 = CreateMutex(NULL, FALSE, NULL);


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

	int rand_exp_max  = 1000;
	int const_exp     = 1000;
	int random        = 0;

	M_UINT32 Overrun    = 0;
	M_UINT32 OverrunPixel=0;
	M_UINT32 SubX = 0;
	M_UINT32 SubY = 0;

	M_UINT32 ExposureIncr = 10;
	M_UINT32 BlackOffset  = 0x100;
	M_UINT32 XGSSize_Y = 0;
	GrabParamStruct*   GrabParams   = XGS_Ctrl->getGrabParams();         // This is a Local Pointer to grab parameter structure
	SensorParamStruct* SensorParams = XGS_Ctrl->getSensorParams();
	DMAParamStruct* DMAParams = XGS_Data->getDMAParams();                // This is a Local Pointer to DMA parameter structure

	M_UINT32 FileDumpNum = 0;

	printf("\n\n********************************\n");
	printf(    "*    Executing Test0005    *\n");
	printf(    "********************************\n\n");



	//------------------------------
    // INITIALIZE XGS SENSOR
    //------------------------------
	XGS_Ctrl->InitXGS();

	//-------------------------------------------
	// Calibrate and enable FPGA HiSPI interface
	//-------------------------------------------
	XGS_Data->HiSpiCalibrate();

	//---------------------
    //
    // MIL LAYER 
    //
    //---------------------
	// Init Display with correct X-Y parameters 
	ImageBufferAddr = LayerCreateGrabBuffer(&MilGrabBuffer, SensorParams->Xsize_Full, 2* SensorParams->Ysize_Full, MonoType);
	LayerInitDisplay(MilGrabBuffer, &MilDisplay, 1);
	printf("Adresse buffer display (MemPtr) = 0x%llx \n", ImageBufferAddr);


	//---------------------
    // GRAB PARAMETERS
    //---------------------
	XGS_Ctrl->setExposure(8000);

	// For a full frame ROI 
	GrabParams->Y_START = 0;                                                //1-base Here - Dois etre multiple de 4	:  skip : 4 Interpolation (center image) 
	GrabParams->Y_END   = GrabParams->Y_START + SensorParams->Ysize_Full;   //1-base Here - Dois etre multiple de 4
	//GrabParams->Y_END   = 8;

	GrabParams->SUBSAMPLING_X        = 0;
	GrabParams->M_SUBSAMPLING_Y      = 0;
	GrabParams->ACTIVE_SUBSAMPLING_Y = 0;

	XGS_Ctrl->setBlackRef(0);

	// GRAB MODE
	// TRIGGER_SRC : NONE, IMMEDIATE, HW_TRIG, SW_TRIG
	// TRIGGER_ACT : RISING, FALLING , ANY_EDGE, LEVEL_HI, LEVEL_LO 
	XGS_Ctrl->SetGrabMode(SW_TRIG, RISING);


	//---------------------
	// DMA PARAMETERS
	//---------------------
	DMAParams->FSTART     = ImageBufferAddr;          // Adresse Mono pour DMA
	DMAParams->LINE_PITCH = SensorParams->Xsize_Full; // Full window MIL display
	DMAParams->LINE_SIZE  = SensorParams->Xsize_Full;


	printf("\n\nTest started at : ");
	XGS_Ctrl->PrintTime();

	//------------------------------------
	//  XGS Ctrl Debug pin
	//------------------------------------
	// debug_pin(0) <= xgs_exposure;
	// debug_pin(1) <= xgs_FOT;     
	// debug_pin(2) <= grab_mngr_trig_rdy;
	// debug_pin(3) <= curr_db_BUFFER_ID_int;
	// debug_pin(4) <= hw_trig;  
	// debug_pin(5) <= curr_trig0;
	// debug_pin(6) <= strobe;
	// debug_pin(7) <= FOT;
	// debug_ctrl32_int(8)  <= readout;              --(readout qui contient le FOT)
	// debug_ctrl32_int(9)  <= readout_cntr2_armed;  --(readout qui contient pas le FOT)
	// debug_ctrl32_int(10) <= readout_stateD;
	// debug_pin(11) <= REGFILE.ACQ.GRAB_STAT.GRAB_IDLE;
	// debug_pin(12) <= REGFILE.ACQ.GRAB_CTRL.GRAB_CMD;
	// debug_pin(13) <= REGFILE.ACQ.GRAB_CTRL.GRAB_SS;
	// debug_pin(14) <= grab_pending;
	// debug_pin(15) <= grab_active;
	XGS_Ctrl->rXGSptr.ACQ.DEBUG_PINS.f.DEBUG0_SEL = 31;
	XGS_Ctrl->rXGSptr.ACQ.DEBUG_PINS.f.DEBUG1_SEL = 5;
	XGS_Ctrl->rXGSptr.ACQ.DEBUG_PINS.f.DEBUG2_SEL = 17;
	XGS_Ctrl->rXGSptr.ACQ.DEBUG_PINS.f.DEBUG3_SEL = 18;

	//---------------------
	// START GRAB 
	//---------------------
	printf("\n");

	printf("\n  (q) Quit this test");
	printf("\n  (A) Start second thread aborting (to be tested)");
	printf("\n  (r) Start randomize");
	printf("\n\n");

	unsigned long fps_reg;
	

	XGS_Ctrl->rXGSptr.ACQ.READOUT_CFG_FRAME_LINE.f.DUMMY_LINES = 0;


	//---------------------
	// Give SPI control to FPGA
	//---------------------
	XGS_Ctrl->EnableRegUpdate();

	while (Sortie == 0)
	{


		// Waiting for second async thread to fininsh the grab abort before start another grab
		WaitForSingleObject(AbortRunning_0005, INFINITE);

		if (random == 1)
		{
			XGS_Ctrl->setExposure_(rand1(rand_exp_max) + const_exp);          // Exposure in us
			XGS_Ctrl->setTriggerDelay(rand1(2000) + 0, 0);                    // Delay in us
			XGS_Ctrl->enableStrobe(1, rand1(2000), rand1(3000), 0);           // StrobeMode:0->start during Exp, START and END in us		
		}

		XGS_Data->SetDMA();
		XGS_Ctrl->SetGrabCMD(0, PolldoSleep);     // Ici on poll grab pending, s'il est a '1' on attend qu'il descende a '0'  avant de continuer
		XGS_Ctrl->SW_snapshot(0);                 // Ici on poll trig_rdy avant d'envoyer le trigger

		//Overrun detection
		OverrunPixel = XGS_Data->GetImagePixel8(LayerGetHostAddressBuffer(MilGrabBuffer), 0, GrabParams->Y_END-GrabParams->Y_START, MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL));
		if (OverrunPixel != 0)
		{
			Overrun++;
			printf("\rDMA Overflow detected: %d\n", Overrun);
			XGS_Data->SetImagePixel8(LayerGetHostAddressBuffer(MilGrabBuffer), 0, GrabParams->Y_END - GrabParams->Y_START, MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL), 0); //reset overrun pixel
		}


		ReleaseMutex(AbortRunning_0005);

		if (DisplayOn)
		{
			MbufControl(MilGrabBuffer, M_MODIFIED, M_DEFAULT);
		}

		if (_kbhit())
		{
			ch = _getch();
			switch (ch)
			{

			case 'A':
				_beginthread(AsyncAbortThread_0005, NULL, XGS_Ctrl);
				break;

			case 'r':
				if (random == 0)
				{
					random = 1;
					printf("\nEnter Const exp in us : ");
					scanf_s("%d", &const_exp);
					printf("\nEnter Random exp max in us : ");
					scanf_s("%d", &rand_exp_max);

					printf("\nExposure randomnized.\n");
				}
				else
				{
					random = 0;
					printf("\nFixed Exposure.\n");
				}
				break;


			case 'q':
				Sortie = 1;
				XGS_Ctrl->SetGrabMode(NONE, LEVEL_HI);
				XGS_Ctrl->GrabAbort();
				XGS_Ctrl->DisableXGS();
				XGS_Data->HiSpiClr();
				printf("\n\n");
				printf("Exit! \n");
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



