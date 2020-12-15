//-----------------------------------------------
//
//  Simple continu test grab Iris4
//
//-----------------------------------------------

/* Headers */
#include "osincludes.h"
#include "osfunctions.h"

#include <mil.h>

#include "MilLayer.h"
#include "XGS_Ctrl.h"
#include "XGS_Data.h"

extern int rand1(unsigned int val_max);
extern void srand1(unsigned int seed);

OS_MUTEX AbortRunning_0005;
bool StopAbortThread_0005;

#ifdef __linux__
void *AsyncAbortThread_0005(void* In)
#else
void AsyncAbortThread_0005(void* In)
#endif
{
	int nb_aborts_ok = 0;
	CXGS_Ctrl* XGS_Ctrl = (CXGS_Ctrl*)In;
	DWORD VarDelai;

	StopAbortThread_0005 = FALSE;

	while (StopAbortThread_0005 == FALSE)
	{
		if(!AcquireOsMutex(&AbortRunning_0005))
			printf_s("\nError acquiring mutex.\n");

		nb_aborts_ok = nb_aborts_ok + XGS_Ctrl->GrabAbort();                  // Abort in FPGA

		printf_s(" NB Aborts: %d    \r", nb_aborts_ok);

		if(!ReleaseOsMutex(&AbortRunning_0005))
			printf_s("\nError releasing mutex.\n");

		//VarDelai = (rand1(750) + 250); // Delai entre 250ms et 1000 ms
		VarDelai = rand1(250) + 500;
		Sleep(VarDelai);
	}

	#ifdef __linux__
	return NULL;
	#endif
}



void test_0005_SWtrig_Random(CXGS_Ctrl* XGS_Ctrl, CXGS_Data* XGS_Data)
   {
	
	srand1((unsigned)clock());

	if(!CreateOsMutex(&AbortRunning_0005))
		printf_s("\nError creating mutex.\n");

	#ifdef __linux__
	pthread_t pthreadid;
	#endif

	MIL_ID MilDisplay;
	MIL_ID MilGrabBuffer;
	M_UINT64 ImageBufferAddr=0;
	MIL_INT  ImageBufferLinePitch = 0;
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

	printf_s("\n\n********************************\n");
	printf_s(    "*    Executing Test0005    *\n");
	printf_s(    "********************************\n\n");



	//------------------------------
    // INITIALIZE XGS SENSOR
    //------------------------------
	XGS_Ctrl->InitXGS();

	//-------------------------------------------
	// Calibrate and enable FPGA HiSPI interface
	//-------------------------------------------
	XGS_Data->HiSpiCalibrate(1);

	//---------------------
    //
    // MIL LAYER 
    //
    //---------------------
	// Init Display with correct X-Y parameters 
	ImageBufferAddr      = LayerCreateGrabBuffer(&MilGrabBuffer, SensorParams->Xsize_Full, 2* SensorParams->Ysize_Full, MonoType);
	ImageBufferLinePitch = MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL);
	LayerInitDisplay(MilGrabBuffer, &MilDisplay, 1);
	printf_s("Adresse buffer display (MemPtr)    = 0x%llx \n", ImageBufferAddr);
	printf_s("Line Pitch buffer display (MemPtr) = 0x%llx \n", ImageBufferLinePitch);


	//---------------------
    // GRAB PARAMETERS
    //---------------------
	XGS_Ctrl->setExposure(8000);

	// For a full frame ROI 
	GrabParams->Y_START = 0;                                                //1-base Here - Dois etre multiple de 4	
	GrabParams->Y_END   = GrabParams->Y_START + SensorParams->Ysize_Full;   //1-base Here - Dois etre multiple de 4
	GrabParams->Y_SIZE  = GrabParams->Y_END - GrabParams->Y_START;          //1-base Here - Dois etre multiple de 4

	GrabParams->SUBSAMPLING_X        = 0;
	GrabParams->M_SUBSAMPLING_Y      = 0;
	GrabParams->ACTIVE_SUBSAMPLING_Y = 0;

	XGS_Ctrl->setBlackRef(0);
	XGS_Ctrl->setAnalogGain(1);        //unitary analog gain   
	XGS_Ctrl->setDigitalGain(0x20);    //unitary digital gain

	XGS_Ctrl->setExposure((M_UINT32)XGS_Ctrl->Get_Sensor_EXP_PRED_MAX(GrabParams->Y_SIZE, GrabParams->M_SUBSAMPLING_Y));

	// GRAB MODE
	// TRIGGER_SRC : NONE, IMMEDIATE, HW_TRIG, SW_TRIG
	// TRIGGER_ACT : RISING, FALLING , ANY_EDGE, LEVEL_HI, LEVEL_LO 
	XGS_Ctrl->SetGrabMode(TRIGGER_SRC::SW_TRIG, TRIGGER_ACT::RISING);


	//---------------------
	// DMA PARAMETERS
	//---------------------
	DMAParams->FSTART     = ImageBufferAddr;          // Adresse Mono pour DMA
	DMAParams->LINE_PITCH = (M_UINT32) ImageBufferLinePitch; 
	DMAParams->LINE_SIZE  = SensorParams->Xsize_Full; // Full window MIL display


	printf_s("\n\nTest started at : ");
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
	printf_s("\n");

	printf_s("\n  (q) Quit this test");
	printf_s("\n  (A) Start second thread aborting (to be tested)");
	printf_s("\n  (r) Start randomize");
	printf_s("\n\n");

	XGS_Ctrl->rXGSptr.ACQ.READOUT_CFG_FRAME_LINE.f.DUMMY_LINES = 0;


	//---------------------
	// Give SPI control to FPGA
	//---------------------
	XGS_Ctrl->EnableRegUpdate();

	while (Sortie == 0)
	{


		// Waiting for second async thread to fininsh the grab abort before start another grab
		if(!AcquireOsMutex(&AbortRunning_0005))
			printf_s("\nError acquiring mutex.\n");

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
		OverrunPixel = XGS_Data->GetImagePixel8(LayerGetHostAddressBuffer(MilGrabBuffer), 0, GrabParams->Y_SIZE, MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL));
		if (OverrunPixel != 0)
		{
			Overrun++;
			printf_s("\rDMA Overflow detected: %d\n", Overrun);
			XGS_Data->SetImagePixel8(LayerGetHostAddressBuffer(MilGrabBuffer), 0, GrabParams->Y_SIZE, MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL), 0); //reset overrun pixel
		}


		if(!ReleaseOsMutex(&AbortRunning_0005))
			printf_s("\nError releasing mutex.\n");

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
				#ifdef __linux__
				if(pthread_create(&pthreadid, NULL, AsyncAbortThread_0005, XGS_Ctrl) != 0)
					printf_s("\nError creating abort thread.\n");
				#else
				_beginthread(AsyncAbortThread_0005, NULL, XGS_Ctrl);
				#endif
				break;

			case 'r':
				if (random == 0)
				{
					random = 1;
					printf_s("\nEnter Const exp in us : ");
					scanf_s("%d", &const_exp);
					printf_s("\nEnter Random exp max in us : ");
					scanf_s("%d", &rand_exp_max);

					printf_s("\nExposure, Exposure delay, and Strobe randomnized.\n");
				}
				else
				{
					random = 0;
					printf_s("\nFixed Exposure.\n");
				}
				break;


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

	StopAbortThread_0005 = TRUE;
	Sleep(1500);
	if(!DestroyOsMutex(&AbortRunning_0005))
		printf_s("\nError destroying mutex.\n");

	printf_s("\n\n********************************\n");
	printf_s("*    End of Test0005.cpp    *\n");
	printf_s("********************************\n\n");

   }



