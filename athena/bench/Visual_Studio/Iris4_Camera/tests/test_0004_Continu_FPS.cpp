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

void test_0004_Continu_FPS(CXGS_Ctrl* XGS_Ctrl, CXGS_Data* XGS_Data)
   {
	
	MIL_ID MilGrabBuffer;
	//MIL_ID MilDisplay;

	M_UINT64 ImageBufferAddr     =0;
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

	printf("\n\n********************************\n");
	printf(    "*    Executing Test0004.cpp    *\n");
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
	ImageBufferAddr     = LayerCreateGrabBuffer(&MilGrabBuffer, SensorParams->Xsize_Full, 2 * SensorParams->Ysize_Full, MonoType);
	printf("Adresse buffer display (MemPtr) = 0x%llx \n", ImageBufferAddr);


	//LayerInitDisplay(MilGrabBuffer, &MilDisplay, 1);

	//---------------------
    // GRAB PARAMETERS
    //---------------------
	XGS_Ctrl->setExposure(10000);

	// For a full frame ROI 
	GrabParams->Y_START = 4;                                                // 1-base Here - Dois etre multiple de 4	:  skip : 4 Interpolation (center image) 
	GrabParams->Y_END   = GrabParams->Y_START + SensorParams->Ysize_Full;	// 1-base Here - Dois etre multiple de 4
	//GrabParams->Y_END   = 8;

	GrabParams->SUBSAMPLING_X        = 0;
	GrabParams->M_SUBSAMPLING_Y      = 0;
	GrabParams->ACTIVE_SUBSAMPLING_Y = 0;

	XGS_Ctrl->setBlackRef(0xff); //lets put a base pixel value so even in the black a overpix pixel will be detected !
	XGS_Ctrl->setAnalogGain(1);

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



	//---------------------
	// START GRAB 
	//---------------------
	printf("\n");
	printf("\n  (q) Quit this test");
	printf("\n  (s) Start FPS test");
	printf("\n\n");


	XGS_Ctrl->rXGSptr.ACQ.READOUT_CFG_FRAME_LINE.f.DUMMY_LINES = 0;


	//---------------------
	// Give SPI control to FPGA
	//---------------------
	XGS_Ctrl->EnableRegUpdate();

	std::vector<int> ROI_Y_SIZE_vector;
	if(XGS_Ctrl->SensorParams.SENSOR_TYPE==16000)
	  ROI_Y_SIZE_vector = { 4000, 3072, 2048,1024, 512,256,128,64,32,16,8 };
	else
	  ROI_Y_SIZE_vector = { 3072, 2048,1024, 512,256,128,64,32,16,8 };


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
				XGS_Ctrl->SetGrabMode(NONE, LEVEL_HI);
				XGS_Ctrl->GrabAbort();
				XGS_Ctrl->DisableXGS();
				XGS_Data->HiSpiClr();
				printf("\n\n");
				printf("Exit! \n");
				break;


			case 's':
				M_UINT32 TimePerLoop=20;
				printf("Test FPS started with TimePerLoop=%d\n\n", TimePerLoop);


				//-------------------------------------------------
				// 1.0 Put minimum exposure and see how FPS is behave
				//--------------------------------------------------
				printf("1) Minimum ExposureTime FPS test\n\n");

				for (i = 0; i < ROI_Y_SIZE_vector.size(); i++) {
					XGS_Ctrl->setExposure_(100);
					GrabCmdCnt = 0;
					MbufClear(MilGrabBuffer, 0);  //clear to detect overruns of image at image+1 pixel
					GrabParams->Y_START = 4;
					GrabParams->Y_END   = GrabParams->Y_START + ROI_Y_SIZE_vector[i];

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

					double Sensor_FPS     = (double)XGS_Ctrl->rXGSptr.ACQ.SENSOR_FPS2.f.SENSOR_FPS / 10.0;
					double Sensor_PRED    = 1.0 / (double(XGS_Ctrl->SensorParams.ReadOutN_2_TrigN / 1000000000.0) + double(XGS_Ctrl->SensorParams.TrigN_2_FOT / 1000000000.0) + double((XGS_Ctrl->sXGSptr.ACQ.READOUT_CFG3.f.LINE_TIME * XGS_Ctrl->SensorPeriodNanoSecond / 1000000000.0) * (XGS_Ctrl->sXGSptr.ACQ.READOUT_CFG1.f.FOT_LENGTH_LINE + 3 + XGS_Ctrl->sXGSptr.ACQ.SENSOR_M_LINES.f.M_LINES_SENSOR + 1 + ((4 * XGS_Ctrl->sXGSptr.ACQ.SENSOR_ROI_Y_SIZE.f.Y_SIZE) / (1 + XGS_Ctrl->GrabParams.ACTIVE_SUBSAMPLING_Y)) + 7 + 7)));
					double Sensor_EXP_max = ((M_UINT64)(XGS_Ctrl->rXGSptr.ACQ.READOUT_CFG_FRAME_LINE.f.CURR_FRAME_LINES) * (M_UINT64)XGS_Ctrl->sXGSptr.ACQ.READOUT_CFG3.f.LINE_TIME * XGS_Ctrl->SensorPeriodNanoSecond / 1000.0)
						                    - double(XGS_Ctrl->SensorParams.FOTn_2_EXP / 1000) + double(XGS_Ctrl->SensorParams.ReadOutN_2_TrigN / 1000.0) + double(XGS_Ctrl->SensorParams.EXP_FOT_TIME / 1000.0);
						                    //EXP_FOT_TIME comprend : SensorParams.TrigN_2_FOT + 5360

					if (OverrunPixel != 0)
						break;

					printf("Y_SIZE: %4d\t Exp: %dus  \tSensor: %0.2lf    \t Predicted: %0.2lf \tExp_Max: ~%.0fus\n", ROI_Y_SIZE_vector[i], XGS_Ctrl->getExposure(), Sensor_FPS, Sensor_PRED, Sensor_EXP_max);

					ROI_Y_SIZE_vector_ExpMax[i] = Sensor_EXP_max;
					ROI_Y_SIZE_vector_FPSMax[i] = Sensor_PRED;

					XGS_Ctrl->WaitEndExpReadout();

				} //end for
				if (OverrunPixel != 0)
					printf("\n\nImage Overrun detected test STOPED computer crash possibility \n(Overrun pixel image : Image Start address= 0x%llX, Image End address 0x%llX, pixel value= 0x%X, Ysize=%d, LinePitch=0x%llX, GrabCount=%d)\n\n", ImageBufferAddr, ImageBufferAddr + (ROI_Y_SIZE_vector[i] * MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL)) - 0x4, OverrunPixel, ROI_Y_SIZE_vector[i], MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL), GrabCmdCnt);



				// S'il n'y a pas eu d'erreur
				if (OverrunPixel == 0) {
					
					MbufClear(MilGrabBuffer, 0);
					Sleep(100);

					//-----------------------------------------------------------------------------
					// 2.0 Lets put the exposure max theoric (-1Line) and see if the FPS still ok
					//------------------------------------------------------------------------------
					printf("\n2) Maximum ExposureTime(Exp_Max -1 Line) FPS test\n\n");
					for (i = 0; i < ROI_Y_SIZE_vector.size(); i++) {
						XGS_Ctrl->setExposure_((M_UINT32)(ROI_Y_SIZE_vector_ExpMax[i] - ((double)XGS_Ctrl->sXGSptr.ACQ.READOUT_CFG3.f.LINE_TIME * (double)XGS_Ctrl->SensorPeriodNanoSecond / 1000.0)));
						GrabCmdCnt = 0;
						MbufClear(MilGrabBuffer, 0);  //clear to detect overruns of image at image+1 pixel
						GrabParams->Y_START = 4;
						GrabParams->Y_END = GrabParams->Y_START + ROI_Y_SIZE_vector[i];

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

						double Sensor_FPS = (double)XGS_Ctrl->rXGSptr.ACQ.SENSOR_FPS2.f.SENSOR_FPS / 10.0;
						double Sensor_PRED = 1.0 / (double(XGS_Ctrl->SensorParams.ReadOutN_2_TrigN / 1000000000.0) + double(XGS_Ctrl->SensorParams.TrigN_2_FOT / 1000000000.0) + double((XGS_Ctrl->sXGSptr.ACQ.READOUT_CFG3.f.LINE_TIME * XGS_Ctrl->SensorPeriodNanoSecond / 1000000000.0) * (XGS_Ctrl->sXGSptr.ACQ.READOUT_CFG1.f.FOT_LENGTH_LINE + 3 + XGS_Ctrl->sXGSptr.ACQ.SENSOR_M_LINES.f.M_LINES_SENSOR + 1 + ((4 * XGS_Ctrl->sXGSptr.ACQ.SENSOR_ROI_Y_SIZE.f.Y_SIZE) / (1 + XGS_Ctrl->GrabParams.ACTIVE_SUBSAMPLING_Y)) + 7 + 7)));
						double Sensor_EXP_max = ((M_UINT64)(XGS_Ctrl->rXGSptr.ACQ.READOUT_CFG_FRAME_LINE.f.CURR_FRAME_LINES) * (M_UINT64)XGS_Ctrl->sXGSptr.ACQ.READOUT_CFG3.f.LINE_TIME * XGS_Ctrl->SensorPeriodNanoSecond / 1000.0)
							- double(XGS_Ctrl->SensorParams.FOTn_2_EXP / 1000) + double(XGS_Ctrl->SensorParams.ReadOutN_2_TrigN / 1000.0) + double(XGS_Ctrl->SensorParams.EXP_FOT_TIME / 1000.0);
						//EXP_FOT_TIME comprend : SensorParams.TrigN_2_FOT + 5360

						if (OverrunPixel != 0)
							break;

						printf("Y_SIZE: %4d\t Exp: %dus  \tSensor: %0.2lf     \t Predicted: %0.2lf \tExp_Max: ~%.0fus\n", ROI_Y_SIZE_vector[i], XGS_Ctrl->getExposure(), Sensor_FPS, Sensor_PRED, Sensor_EXP_max);

						XGS_Ctrl->WaitEndExpReadout();

					} //end for
					if (OverrunPixel != 0)
						printf("\n\nImage Overrun detected test STOPED computer crash possibility \n(Overrun pixel image : Image Start address= 0x%llX, Image End address 0x%llX, pixel value= 0x%X, Ysize=%d, LinePitch=0x%llX, GrabCount=%d)\n\n", ImageBufferAddr, ImageBufferAddr + (ROI_Y_SIZE_vector[i] * MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL)) - 0x4, OverrunPixel, ROI_Y_SIZE_vector[i], MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL), GrabCmdCnt);

				}

				// S'il n'y a pas eu d'erreur
				if (OverrunPixel == 0) {
					MbufClear(MilGrabBuffer, 0);
					Sleep(100);

					//-----------------------------------------------------------------------------
					// 3.0 Lets program an internal HW timer to generate Max FPS with Max Exp(-1L)
					//------------------------------------------------------------------------------
					XGS_Ctrl->SetGrabMode(HW_TRIG, TIMER);

					printf("\n3) Adaptative HW Timer with Maximum FPS and Maximum ExposureTime(Exp_Max -1 Line) FPS test\n\n");
					for (i = 0; i < ROI_Y_SIZE_vector.size(); i++) {
						XGS_Ctrl->StopHWTimer();

						XGS_Ctrl->StartHWTimerFPS(ROI_Y_SIZE_vector_FPSMax[i]);
						XGS_Ctrl->rXGSptr.ACQ.TRIGGER_MISSED.f.TRIGGER_MISSED_RST = 1;
						XGS_Ctrl->setExposure_((M_UINT32)(ROI_Y_SIZE_vector_ExpMax[i] - ((double)XGS_Ctrl->sXGSptr.ACQ.READOUT_CFG3.f.LINE_TIME * (double)XGS_Ctrl->SensorPeriodNanoSecond / 1000.0)));

						GrabCmdCnt = 0;
						MbufClear(MilGrabBuffer, 0);  //clear to detect overruns of image at image+1 pixel
						GrabParams->Y_START = 4;
						GrabParams->Y_END = GrabParams->Y_START + ROI_Y_SIZE_vector[i];

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

						double Sensor_FPS = (double)XGS_Ctrl->rXGSptr.ACQ.SENSOR_FPS2.f.SENSOR_FPS / 10.0;
						double Sensor_PRED = 1.0 / (double(XGS_Ctrl->SensorParams.ReadOutN_2_TrigN / 1000000000.0) + double(XGS_Ctrl->SensorParams.TrigN_2_FOT / 1000000000.0) + double((XGS_Ctrl->sXGSptr.ACQ.READOUT_CFG3.f.LINE_TIME * XGS_Ctrl->SensorPeriodNanoSecond / 1000000000.0) * (XGS_Ctrl->sXGSptr.ACQ.READOUT_CFG1.f.FOT_LENGTH_LINE + 3 + XGS_Ctrl->sXGSptr.ACQ.SENSOR_M_LINES.f.M_LINES_SENSOR + 1 + ((4 * XGS_Ctrl->sXGSptr.ACQ.SENSOR_ROI_Y_SIZE.f.Y_SIZE) / (1 + XGS_Ctrl->GrabParams.ACTIVE_SUBSAMPLING_Y)) + 7 + 7)));
						double Sensor_EXP_max = ((M_UINT64)(XGS_Ctrl->rXGSptr.ACQ.READOUT_CFG_FRAME_LINE.f.CURR_FRAME_LINES) * (M_UINT64)XGS_Ctrl->sXGSptr.ACQ.READOUT_CFG3.f.LINE_TIME * XGS_Ctrl->SensorPeriodNanoSecond / 1000.0)
							- double(XGS_Ctrl->SensorParams.FOTn_2_EXP / 1000) + double(XGS_Ctrl->SensorParams.ReadOutN_2_TrigN / 1000.0) + double(XGS_Ctrl->SensorParams.EXP_FOT_TIME / 1000.0);
						//EXP_FOT_TIME comprend : SensorParams.TrigN_2_FOT + 5360

						if (XGS_Ctrl->rXGSptr.ACQ.TRIGGER_MISSED.f.TRIGGER_MISSED_CNTR != 0)
							printf("Some trigger missed detected(%d)\n", XGS_Ctrl->rXGSptr.ACQ.TRIGGER_MISSED.f.TRIGGER_MISSED_CNTR);

						if (OverrunPixel != 0)
							break;

						printf("Y_SIZE: %4d\t Exp: %dus  \tSensor: %0.2lf     \t Predicted: %0.2lf \tExp_Max: ~%.0fus\n", ROI_Y_SIZE_vector[i], XGS_Ctrl->getExposure(), Sensor_FPS, Sensor_PRED, Sensor_EXP_max);

						XGS_Ctrl->WaitEndExpReadout();

					} //end for
					if (OverrunPixel != 0)
						printf("\n\nImage Overrun detected test STOPED computer crash possibility \n(Overrun pixel image : Image Start address= 0x%llX, Image End address 0x%llX, pixel value= 0x%X, Ysize=%d, LinePitch=0x%llX, GrabCount=%d)\n\n", ImageBufferAddr, ImageBufferAddr + (ROI_Y_SIZE_vector[i] * MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL)) - 0x4, OverrunPixel, ROI_Y_SIZE_vector[i], MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL), GrabCmdCnt);

				}


				break;
			} //end switch

			printf("\nEnd loop, press 's' or 'q'\n");


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

	printf("\n\n********************************\n");
	printf("*    End of Test0000.cpp    *\n");
	printf("********************************\n\n");

   }



