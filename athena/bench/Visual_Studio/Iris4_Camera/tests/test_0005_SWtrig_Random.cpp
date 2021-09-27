//-----------------------------------------------
//
//  Simple continu test grab Iris4
//  Exposure aleatoire et thread abort
//
//  Mono et Couleur
//-----------------------------------------------

/* Headers */
#include "osincludes.h"
#include "osfunctions.h"

#include <mil.h>

#include "MilLayer.h"
#include "XGS_Ctrl.h"
#include "XGS_Data.h"
#include "Pcie.h"

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



void test_0005_SWtrig_Random(CPcie* Pcie, CXGS_Ctrl* XGS_Ctrl, CXGS_Data* XGS_Data)
   {
	
	srand1((unsigned)clock());

	if(!CreateOsMutex(&AbortRunning_0005))
		printf_s("\nError creating mutex.\n");

	#ifdef __linux__
	pthread_t pthreadid;
	#endif

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

	M_UINT32 XGSStart_Y = 0;
	M_UINT32 XGSSize_Y = 0;
	M_UINT32 OVERSCAN_Y = 0;

	M_UINT32 XGSStart_X = 0;
	M_UINT32 XGSSize_X = 0;

	M_UINT32 LUT_PATTERN = 0;

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
	printf_s("2: PLANAR (not supported yet) \n");
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
	// PLANAR TRANSFER (NOT SUPPORTED YET)
	//--------------------------------
	else if (PLANAR == 1)
	{
		//ImageBufferAddr = LayerCreateGrabBuffer(&MilGrabBufferB, SensorParams->Xsize_Full_valid, 1 * SensorParams->Ysize_Full_valid, MonoType);
		//LayerInitDisplay(MilGrabBufferB, &MilDisplayB, 2);
		//
		//ImageBufferAddrG = LayerCreateGrabBuffer(&MilGrabBufferG, SensorParams->Xsize_Full_valid, 1 * SensorParams->Ysize_Full_valid, MonoType);
		//LayerInitDisplay(MilGrabBufferG, &MilDisplayG, 3);
		//
		//ImageBufferAddrR = LayerCreateGrabBuffer(&MilGrabBufferR, SensorParams->Xsize_Full_valid, 1 * SensorParams->Ysize_Full_valid, MonoType);
		//LayerInitDisplay(MilGrabBufferR, &MilDisplayR, 4);

		ImageBufferAddr = LayerCreateGrabBuffer(&MilGrabBuffer, SensorParams->Xsize_Full_valid, 1 * SensorParams->Ysize_Full_valid, PlanarType);

		ImageBufferLinePitch = MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL);

		MbufChildColor(MilGrabBuffer, M_BLUE, &MilGrabBufferB);
		MbufChildColor(MilGrabBuffer, M_GREEN, &MilGrabBufferG);
		MbufChildColor(MilGrabBuffer, M_RED, &MilGrabBufferR);

		ImageBufferAddr = LayerGetHostAddressBuffer(MilGrabBufferB);
		ImageBufferAddrG = LayerGetHostAddressBuffer(MilGrabBufferG);
		ImageBufferAddrR = LayerGetHostAddressBuffer(MilGrabBufferR);

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


	GrabParams->M_SUBSAMPLING_Y = 0;
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
		OverrunPixel = XGS_Data->GetImagePixel8(LayerGetHostAddressBuffer(MilGrabBuffer), 0, DMAParams->Y_SIZE, MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL));
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
					printf_s("\nEnter Constant exposure in us : ");
					scanf_s("%d", &const_exp);
					printf_s("\nEnter Random exposure max in us : ");
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



