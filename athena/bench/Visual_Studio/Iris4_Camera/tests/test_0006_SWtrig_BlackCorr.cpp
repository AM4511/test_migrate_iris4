//-----------------------------------------------
//
//  Corrtion du noir avec premieres lignes noire dans la region M-LINE 
//
//-----------------------------------------------

/* Headers */
#include "osincludes.h"

#include <mil.h>

#include "MilLayer.h"
#include "XGS_Ctrl.h"
#include "XGS_Data.h"





void test_0006_SWtrig_BlackCorr(CXGS_Ctrl* XGS_Ctrl, CXGS_Data* XGS_Data)
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
	printf(    "*    Executing Test0006    *\n");
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
	XGS_Ctrl->setExposure(30000);
	XGS_Ctrl->setBlackRef(BlackOffset);

	// For a full frame ROI 
	GrabParams->Y_START = 0;                                                //1-base Here - Dois etre multiple de 4	:  skip : 4 Interpolation (center image) 
	GrabParams->Y_END   = GrabParams->Y_START + SensorParams->Ysize_Full;   //1-base Here - Dois etre multiple de 4
	GrabParams->Y_SIZE  = GrabParams->Y_END - GrabParams->Y_START;          // 1-base Here - Dois etre multiple de 4

	GrabParams->SUBSAMPLING_X        = 0;
	GrabParams->M_SUBSAMPLING_Y      = 0;
	GrabParams->ACTIVE_SUBSAMPLING_Y = 0;

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
	printf("\n  (e) Exposure Incr/Decr gap");
	printf("\n  (+) Increase Exposure");
	printf("\n  (-) Decrease Exposure");
	printf("\n  (c) Calculate Stats on the PD and SN Black lines");

	printf("\n\n");



	XGS_Ctrl->rXGSptr.ACQ.READOUT_CFG_FRAME_LINE.f.DUMMY_LINES = 0;


	//---------------------
	// Give SPI control to FPGA
	//---------------------




	//------------------------------
	// Get 6 Black lines of M-LINES
	//------------------------------
	M_UINT32 M_LINES_REG = (0<<10) + 16;                      // 16 Black lines! (no suppressed)
	XGS_Ctrl->WriteSPI(0x389a, M_LINES_REG);                  // [14:10 -> Suppress M-lines] , [0:9 -> Total M-Lines] 
	XGS_Data->rXGSptr.ACQ.SENSOR_M_LINES.u32 = M_LINES_REG;   // [14:10 -> Suppress M-lines] , [0:9 -> Total M-Lines] 

	XGS_Data->rXGSptr.ACQ.SENSOR_M_LINES.f.M_LINES_DISPLAY = 1; // Setter a 1 pour transferer lignes noires vers le host

	XGS_Ctrl->EnableRegUpdate();



	while (Sortie == 0)
	{

		XGS_Data->SetDMA();
		XGS_Ctrl->SetGrabCMD(0, PolldoSleep);     // Ici on poll grab pending, s'il est a '1' on attend qu'il descende a '0'  avant de continuer
		XGS_Ctrl->SW_snapshot(0);                 // Ici on poll trig_rdy avant d'envoyer le trigger

		XGS_Ctrl->WaitEndExpReadout();
		MbufControl(MilGrabBuffer, M_MODIFIED, M_DEFAULT);
		XGS_Data->SetImagePixel8(LayerGetHostAddressBuffer(MilGrabBuffer), 0, GrabParams->Y_SIZE, MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL), 0xff); //reset overrun pixel


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

			case 'c':
				// Depending on the programmation : 
			    // The first 8 row readouts will include the photodiode(PD) dark current + storage node(SN) dark current
				// Any subsequent row readouts will have only the electrical black information with minimal storage node(SN) charge only

				double PD_SN_DARK_NOISE         = 0;
				M_UINT64 PD_SN_DARK_NOISE_ACC   = 0;

				double SN_DARK_NOISE            = 0;
				M_UINT64 SN_DARK_NOISE_ACC      = 0;

				for(M_UINT32 y= 0; y < 8; y++)
					for (M_UINT32 x = 0; x < XGS_Ctrl->SensorParams.Xsize_Full; x++)
					{
						PD_SN_DARK_NOISE_ACC = PD_SN_DARK_NOISE_ACC + XGS_Data->GetImagePixel8(LayerGetHostAddressBuffer(MilGrabBuffer), x, y, MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL));
					}
				PD_SN_DARK_NOISE = (double)PD_SN_DARK_NOISE_ACC / (double)(8 * XGS_Ctrl->SensorParams.Xsize_Full); //8 first lines are contains PD noise


				for (M_UINT32 y = 8; y < (XGS_Data->rXGSptr.ACQ.SENSOR_M_LINES.f.M_LINES_SENSOR); y++)
					for (M_UINT32 x = 0; x < XGS_Ctrl->SensorParams.Xsize_Full; x++)
					{
						SN_DARK_NOISE_ACC = SN_DARK_NOISE_ACC + XGS_Data->GetImagePixel8(LayerGetHostAddressBuffer(MilGrabBuffer), x, y, MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL));
					}
				SN_DARK_NOISE = (double)SN_DARK_NOISE_ACC / (double)((XGS_Data->rXGSptr.ACQ.SENSOR_M_LINES.f.M_LINES_SENSOR-8) * XGS_Ctrl->SensorParams.Xsize_Full);

				
				printf("M_LINES PD(PhotoDiode)+SN(StorageNode) Dark current Black mean = %f, Data Pedestal=%d\n", PD_SN_DARK_NOISE, BlackOffset/16);
				printf("M_LINES SN(StorageNode) Dark current Black mean                = %f, Data Pedestal=%d\n\n", SN_DARK_NOISE,    BlackOffset/16);
				break;

			}





		}

	}

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
	printf("*    End of Test0006.cpp    *\n");
	printf("********************************\n\n");

   }



