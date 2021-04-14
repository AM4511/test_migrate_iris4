//-----------------------------------------------
//
//  Simple continu pour scanner les 
//
//-----------------------------------------------

/* Headers */
#include "osincludes.h"

#include <chrono>
#include <iostream>
using namespace std;

#include <mil.h>

#include "MilLayer.h"
#include "XGS_Ctrl.h"
#include "XGS_Data.h"
#include "Pcie.h"

void test_0004_Continu_FPS(CPcie* Pcie, CXGS_Ctrl* XGS_Ctrl, CXGS_Data* XGS_Data)
   {
	
	MIL_ID MilGrabBuffer;
	//MIL_ID MilDisplay;

	M_UINT64 ImageBufferAddr=0;
	M_UINT64 ImageBufferLinePitch = 0;

	int MonoType = 8;
	M_UINT32 i = 0;
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

	M_UINT32 OverrunPixel        = 0;
	M_UINT32 OverrunPixelValue   = 0;
	M_UINT32 OVERRUN_OFFSET_LINE = 4; // ATTENTION !!!! '0', nous detectons des overruns!!!!

	M_UINT32 GrabCmdCnt = 0;

	M_UINT32 FileDumpNum = 0;

	printf_s("\n\n********************************\n");
	printf_s(    "*    Executing Test0004.cpp    *\n");
	printf_s(    "********************************\n\n");


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
	ImageBufferAddr     = LayerCreateGrabBuffer(&MilGrabBuffer, SensorParams->Xsize_Full_valid, 2 * SensorParams->Ysize_Full_valid, MonoType);
	ImageBufferLinePitch = MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL);
	printf_s("Adresse buffer display (MemPtr)    = 0x%llx \n", ImageBufferAddr);
	printf_s("Line Pitch buffer display (MemPtr) = 0x%llx \n", ImageBufferLinePitch);

	//LayerInitDisplay(MilGrabBuffer, &MilDisplay, 1);

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
		GrabParams->Y_START = SensorParams->Ystart_valid;                          // Dois etre multiple de 4	
		GrabParams->Y_SIZE = SensorParams->Ysize_Full_valid;                       // Dois etre multiple de 4
		GrabParams->Y_END = GrabParams->Y_START + GrabParams->Y_SIZE - 1 + 4;      // On laisse passer 4 lignes d'interpolation pour le bayer
	}

	XGS_Ctrl->setBlackRef(0xff); //lets put a base pixel value so even in the black a overpix pixel will be detected !
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



	printf_s("\n\nTest started at : ");
	XGS_Ctrl->PrintTime();



	//---------------------
	// START GRAB 
	//---------------------
	printf_s("\n");
	printf_s("\n  (q) Quit this test");
	printf_s("\n  (s) Start FPS test");
	printf_s("\n\n");


	XGS_Ctrl->rXGSptr.ACQ.READOUT_CFG_FRAME_LINE.f.DUMMY_LINES = 0;


	//---------------------
	// Give SPI control to FPGA
	//---------------------
	XGS_Ctrl->EnableRegUpdate();

	std::vector<int> ROI_Y_SIZE_vector;
	if(XGS_Ctrl->SensorParams.SENSOR_TYPE==16000)
	  ROI_Y_SIZE_vector = { 4000, 3072, 2048,1024, 512,256,128,64,32,16,8 };
	else
	  if (XGS_Ctrl->SensorParams.SENSOR_TYPE == 12000)
		ROI_Y_SIZE_vector = { 3072, 2048,1024, 512,256,128,64,32,16,8 }; 
	  else
		if (XGS_Ctrl->SensorParams.SENSOR_TYPE == 5000)
		  ROI_Y_SIZE_vector = { 2048,1024, 512,256,128,64,32,16,8 };
		else
		  if (XGS_Ctrl->SensorParams.SENSOR_TYPE == 8000)
			ROI_Y_SIZE_vector = { 2160, 2048, 1200, 1024, 512,256,128,64,32,16,8 };
		  else
			if (XGS_Ctrl->SensorParams.SENSOR_TYPE == 2000)
			  ROI_Y_SIZE_vector = { 1200,1024, 512,256,128,64,32,16,8 };
			else
			  {}



	//ROI_Y_SIZE_vector = { 1024, 2048, 3072 };
	
	std::vector<int>::size_type vector_size = ROI_Y_SIZE_vector.size();
	vector<double> ROI_Y_SIZE_vector_ExpMax(ROI_Y_SIZE_vector.begin(), ROI_Y_SIZE_vector.end());
	vector<double> ROI_Y_SIZE_vector_FPSMax(ROI_Y_SIZE_vector.begin(), ROI_Y_SIZE_vector.end());


	while (Sortie == 0)
	{

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


			case 's':
				M_UINT32 TimePerLoop=20;
				printf_s("Test FPS started with TimePerLoop=%d\n\n", TimePerLoop);


				//-------------------------------------------------
				// 1.0 Put minimum exposure and see how FPS is behave
				//--------------------------------------------------
				printf_s("1) Minimum ExposureTime FPS test\n\n");

				for (i = 0; i < ROI_Y_SIZE_vector.size(); i++) {
					XGS_Ctrl->setExposure_(100);
					GrabCmdCnt = 0;
					MbufClear(MilGrabBuffer, 0);  //clear to detect overruns of image at image+1 pixel
					GrabParams->Y_START = SensorParams->Ystart_valid;
					GrabParams->Y_END   = GrabParams->Y_START + ROI_Y_SIZE_vector[i];
					GrabParams->Y_SIZE  = GrabParams->Y_END - GrabParams->Y_START;          // 1-base Here - Dois etre multiple de 4


					// Run each sequence for TimePerLoop seconds
					auto start = std::chrono::system_clock::now();
					auto end = std::chrono::system_clock::now();

					while ((std::chrono::duration_cast<std::chrono::seconds>(end - start).count() != TimePerLoop))
					{
						XGS_Data->SetDMA();
						XGS_Ctrl->SetGrabCMD(0, PolldoSleep);  // Ici on poll grab pending, s'il est a '1' on attend qu'il descende a '0'  avant de continuer
						end = std::chrono::system_clock::now();
						GrabCmdCnt++;

						// Test for overrun of DMA
						OverrunPixel = XGS_Data->GetImagePixel8(LayerGetHostAddressBuffer(MilGrabBuffer), 0, ROI_Y_SIZE_vector[i] + OVERRUN_OFFSET_LINE, MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL));
						if (OverrunPixel != 0)
							break;

					} //end while

					double Sensor_FPS         = (double)XGS_Ctrl->rXGSptr.ACQ.SENSOR_FPS2.f.SENSOR_FPS / 10.0;
					double Sensor_FPS_PRED    = XGS_Ctrl->Get_Sensor_FPS_PRED_MAX(GrabParams->Y_SIZE, GrabParams->M_SUBSAMPLING_Y);
					double Sensor_EXP_max     = XGS_Ctrl->Get_Sensor_EXP_PRED_MAX(GrabParams->Y_SIZE, GrabParams->M_SUBSAMPLING_Y);

					if (OverrunPixel != 0)
						break;

					printf_s("Y_SIZE: %4d\t Exp: %dus  \tSensor: %0.2lf    \t Predicted: %0.2lf \tExp_Max: ~%.0lfus\n", ROI_Y_SIZE_vector[i], XGS_Ctrl->getExposure(), Sensor_FPS, Sensor_FPS_PRED, Sensor_EXP_max);

					ROI_Y_SIZE_vector_ExpMax[i] = Sensor_EXP_max;
					ROI_Y_SIZE_vector_FPSMax[i] = Sensor_FPS_PRED;

					XGS_Ctrl->WaitEndExpReadout();

				} //end for
				if (OverrunPixel != 0)
					printf_s("\n\nImage Overrun detected test STOPED computer crash possibility \n(Overrun pixel image : Image Start address= 0x%llX, Image End address 0x%llX, pixel value= 0x%X, Ysize=%d, LinePitch=0x%llX, GrabCount=%d)\n\n", ImageBufferAddr, ImageBufferAddr + (ROI_Y_SIZE_vector[i] * MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL)) - 0x4, OverrunPixel, ROI_Y_SIZE_vector[i], MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL), GrabCmdCnt);



				// S'il n'y a pas eu d'erreur
				if (OverrunPixel == 0) {
					
					MbufClear(MilGrabBuffer, 0);
					Sleep(100);

					//-----------------------------------------------------------------------------
					// 2.0 Lets put the exposure max theoric (-1Line) and see if the FPS still ok
					//------------------------------------------------------------------------------
					printf_s("\n2) Maximum ExposureTime(Exp_Max -1 Line) FPS test\n\n");
					for (i = 0; i < ROI_Y_SIZE_vector.size(); i++) {
						XGS_Ctrl->setExposure_((M_UINT32)(ROI_Y_SIZE_vector_ExpMax[i] - ((double)XGS_Ctrl->sXGSptr.ACQ.READOUT_CFG3.f.LINE_TIME * (double)XGS_Ctrl->SensorPeriodNanoSecond / 1000.0)));
						GrabCmdCnt = 0;
						MbufClear(MilGrabBuffer, 0);  //clear to detect overruns of image at image+1 pixel
						GrabParams->Y_START = SensorParams->Ystart_valid;
						GrabParams->Y_END   = GrabParams->Y_START + ROI_Y_SIZE_vector[i];
						GrabParams->Y_SIZE  = GrabParams->Y_END - GrabParams->Y_START;          // 1-base Here - Dois etre multiple de 4

						// Run each  for TimePesequencerLoop seconds
						auto start = std::chrono::system_clock::now();
						auto end = std::chrono::system_clock::now();

						while ((std::chrono::duration_cast<std::chrono::seconds>(end - start).count() != TimePerLoop))
						{
							XGS_Data->SetDMA();
							XGS_Ctrl->SetGrabCMD(0, PolldoSleep);  // Ici on poll grab pending, s'il est a '1' on attend qu'il descende a '0'  avant de continuer
							end = std::chrono::system_clock::now();
							GrabCmdCnt++;

							// Test for overrun of DMA
							OverrunPixel = XGS_Data->GetImagePixel8(LayerGetHostAddressBuffer(MilGrabBuffer), 0, ROI_Y_SIZE_vector[i] + OVERRUN_OFFSET_LINE, MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL));
							if (OverrunPixel != 0)
								break;


						} //end while

						double Sensor_FPS      = (double)XGS_Ctrl->rXGSptr.ACQ.SENSOR_FPS2.f.SENSOR_FPS / 10.0;
						double Sensor_FPS_PRED = XGS_Ctrl->Get_Sensor_FPS_PRED_MAX(GrabParams->Y_SIZE, GrabParams->M_SUBSAMPLING_Y);
						double Sensor_EXP_max  = XGS_Ctrl->Get_Sensor_EXP_PRED_MAX(GrabParams->Y_SIZE, GrabParams->M_SUBSAMPLING_Y);

						if (OverrunPixel != 0)
							break;

						printf_s("Y_SIZE: %4d\t Exp: %dus  \tSensor: %0.2lf     \t Predicted: %0.2lf \tExp_Max: ~%.0lfus\n", ROI_Y_SIZE_vector[i], XGS_Ctrl->getExposure(), Sensor_FPS, Sensor_FPS_PRED, Sensor_EXP_max);

						XGS_Ctrl->WaitEndExpReadout();

					} //end for
					if (OverrunPixel != 0)
						printf_s("\n\nImage Overrun detected test STOPED computer crash possibility \n(Overrun pixel image : Image Start address= 0x%llX, Image End address 0x%llX, pixel value= 0x%X, Ysize=%d, LinePitch=0x%llX, GrabCount=%d)\n\n", ImageBufferAddr, ImageBufferAddr + (ROI_Y_SIZE_vector[i] * MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL)) - 0x4, OverrunPixel, ROI_Y_SIZE_vector[i], MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL), GrabCmdCnt);

				}

				// S'il n'y a pas eu d'erreur
				if (OverrunPixel == 0) {
					MbufClear(MilGrabBuffer, 0);
					Sleep(100);

					//-----------------------------------------------------------------------------
					// 3.0 Lets program an internal HW timer to generate Max FPS with Max Exp(-1L)
					//------------------------------------------------------------------------------
					XGS_Ctrl->SetGrabMode(TRIGGER_SRC::HW_TRIG, TRIGGER_ACT::TIMER);

					printf_s("\n3) Adaptative HW Timer with Maximum FPS and Maximum ExposureTime(Exp_Max -1 Line) FPS test\n\n");
					for (i = 0; i < ROI_Y_SIZE_vector.size(); i++) {
						XGS_Ctrl->StopHWTimer();

						XGS_Ctrl->StartHWTimerFPS(ROI_Y_SIZE_vector_FPSMax[i]);
						XGS_Ctrl->rXGSptr.ACQ.TRIGGER_MISSED.f.TRIGGER_MISSED_RST = 1;
						XGS_Ctrl->setExposure_((M_UINT32)(ROI_Y_SIZE_vector_ExpMax[i] - ((double)XGS_Ctrl->sXGSptr.ACQ.READOUT_CFG3.f.LINE_TIME * (double)XGS_Ctrl->SensorPeriodNanoSecond / 1000.0)));

						GrabCmdCnt = 0;
						MbufClear(MilGrabBuffer, 0);  //clear to detect overruns of image at image+1 pixel
						GrabParams->Y_START = SensorParams->Ystart_valid;
						GrabParams->Y_END   = GrabParams->Y_START + ROI_Y_SIZE_vector[i];
						GrabParams->Y_SIZE  = GrabParams->Y_END - GrabParams->Y_START;          // 1-base Here - Dois etre multiple de 4

						// Run each sequence for TimePerLoop seconds
						auto start = std::chrono::system_clock::now();
						auto end = std::chrono::system_clock::now();

						while ((std::chrono::duration_cast<std::chrono::seconds>(end - start).count() != TimePerLoop))
						{
							XGS_Data->SetDMA();
							XGS_Ctrl->SetGrabCMD(0, PolldoSleep);  // Ici on poll grab pending, s'il est a '1' on attend qu'il descende a '0'  avant de continuer
							end = std::chrono::system_clock::now();
							GrabCmdCnt++;

							// Test for overrun of DMA
							OverrunPixel = XGS_Data->GetImagePixel8(LayerGetHostAddressBuffer(MilGrabBuffer), 0, ROI_Y_SIZE_vector[i] + OVERRUN_OFFSET_LINE, MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL));
							if (OverrunPixel != 0)
								break;

						} //end while

						double Sensor_FPS      = (double)XGS_Ctrl->rXGSptr.ACQ.SENSOR_FPS2.f.SENSOR_FPS / 10.0;
						double Sensor_FPS_PRED = XGS_Ctrl->Get_Sensor_FPS_PRED_MAX(GrabParams->Y_SIZE, GrabParams->M_SUBSAMPLING_Y);
						double Sensor_EXP_max  = XGS_Ctrl->Get_Sensor_EXP_PRED_MAX(GrabParams->Y_SIZE, GrabParams->M_SUBSAMPLING_Y);

						if (XGS_Ctrl->rXGSptr.ACQ.TRIGGER_MISSED.f.TRIGGER_MISSED_CNTR != 0)
							printf_s("Some trigger missed detected(%d)\n", XGS_Ctrl->rXGSptr.ACQ.TRIGGER_MISSED.f.TRIGGER_MISSED_CNTR);

						if (OverrunPixel != 0)
							break;

						printf_s("Y_SIZE: %4d\t Exp: %dus  \tSensor: %0.2lf     \t Predicted: %0.2lf \tExp_Max: ~%.0lfus\n", ROI_Y_SIZE_vector[i], XGS_Ctrl->getExposure(), Sensor_FPS, Sensor_FPS_PRED, Sensor_EXP_max);

						XGS_Ctrl->WaitEndExpReadout();

					} //end for
					if (OverrunPixel != 0)
						printf_s("\n\nImage Overrun detected test STOPED computer crash possibility \n(Overrun pixel image : Image Start address= 0x%llX, Image End address 0x%llX, pixel value= 0x%X, Ysize=%d, LinePitch=0x%llX, GrabCount=%d)\n\n", ImageBufferAddr, ImageBufferAddr + (ROI_Y_SIZE_vector[i] * MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL)) - 0x4, OverrunPixel, ROI_Y_SIZE_vector[i], MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL), GrabCmdCnt);

				}


				break;
			} //end switch

			printf_s("\nEnd loop, press 's' or 'q'\n");


		}  // end kb hit

	} // end while sortie


	//------------------------------
	// Free MIL Display
	//------------------------------
	MbufFree(MilGrabBuffer);
	//MdispFree(MilDisplay);

	//----------------------
	// Disable HW
	//----------------------
	XGS_Ctrl->DisableXGS();  //reset and disable clk

	printf_s("\n\n********************************\n");
	printf_s("*    End of Test0000.cpp    *\n");
	printf_s("********************************\n\n");

   }



