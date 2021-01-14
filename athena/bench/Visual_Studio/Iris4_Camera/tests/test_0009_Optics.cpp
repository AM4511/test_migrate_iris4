//-----------------------------------------------
//
//  Optic test grab Iris4
//
//-----------------------------------------------

/* Headers */
#include "osincludes.h"

#include <string>
#include <iostream>
#include <sstream>
using namespace std;

#include <mil.h>

#include "MilLayer.h"
#include "XGS_Ctrl.h"
#include "XGS_Data.h"

void test_0009_Optics(CXGS_Ctrl* XGS_Ctrl, CXGS_Data* XGS_Data)
   {
	
	MIL_ID MilDisplay;
	MIL_ID MilGrabBuffer;
	M_UINT64 ImageBufferAddr = 0;
	MIL_INT  ImageBufferLinePitch = 0;
	int MonoType = 8;

	int Sortie = 0;
	char ch;

	bool CheckCRC   = true;
	bool DisplayOn  = true;
	int PolldoSleep =0;
	bool FPS_On     = true;

	M_UINT32 DefaultGain;
	M_UINT32 DefaultDigGain;
	M_UINT32 DefaultBlackOffset;

	M_UINT32 ExposureBase = 8000;
	M_UINT32 ExposureIncr = 10;
	M_UINT32 ExposureIter = 5;

	M_UINT32 exp_time     = 1000;

    M_UINT32 XGSSize_Y = 0;

	M_UINT32 SubX = 0;
	M_UINT32 SubY = 0;

	M_UINT32 XGSTestImageMode = 0;

	GrabParamStruct*   GrabParams   = XGS_Ctrl->getGrabParams();         // This is a Local Pointer to grab parameter structure
	SensorParamStruct* SensorParams = XGS_Ctrl->getSensorParams();
	DMAParamStruct*    DMAParams    = XGS_Data->getDMAParams();             // This is a Local Pointer to DMA parameter structure

	M_UINT32 FileDumpNum = 0;

	printf_s("\n\n********************************\n");
	printf_s(    "*    Executing Test0009_Optics.cpp    *\n");
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
	ImageBufferAddr = LayerCreateGrabBuffer(&MilGrabBuffer, SensorParams->Xsize_Full, SensorParams->Ysize_Full, MonoType);
	ImageBufferLinePitch = MbufInquire(MilGrabBuffer, M_PITCH_BYTE, M_NULL);
	LayerInitDisplay(MilGrabBuffer, &MilDisplay, 1);
	printf_s("Adresse buffer display (MemPtr)    = 0x%llx \n", ImageBufferAddr);
	printf_s("Line Pitch buffer display (MemPtr) = 0x%llx \n", ImageBufferLinePitch);

	//printf_s("\nDo you want to transfer grab images to host frame memory?  (0=No, 1=Yes) : ");
	//ch = _getch();
	ch = '1';

	if (ch == '0')
		DisplayOn = false;
	else
		DisplayOn = true;
	printf_s("\n");


	//---------------------
    // GRAB PARAMETERS
    //---------------------

	// For a full frame ROI 
	GrabParams->Y_START = 0;                                                // 1-base Here - Dois etre multiple de 4	:  skip : 4 Interpolation (center image) 
	GrabParams->Y_END   = GrabParams->Y_START + SensorParams->Ysize_Full;	// 1-base Here - Dois etre multiple de 4
	GrabParams->Y_SIZE  = GrabParams->Y_END - GrabParams->Y_START;          // 1-base Here - Dois etre multiple de 4


	GrabParams->SUBSAMPLING_X        = 0;
	GrabParams->M_SUBSAMPLING_Y      = 0;
	GrabParams->ACTIVE_SUBSAMPLING_Y = 0;

	XGS_Ctrl->setBlackRef(0);
	XGS_Ctrl->setAnalogGain(1);
	XGS_Ctrl->setDigitalGain(0x20);  // gain= 1/32 *32

	XGS_Ctrl->setExposure( (M_UINT32) XGS_Ctrl->Get_Sensor_EXP_PRED_MAX(GrabParams->Y_SIZE, GrabParams->M_SUBSAMPLING_Y));


	// GRAB MODE
	// TRIGGER_SRC : NONE, IMMEDIATE, HW_TRIG, SW_TRIG
	// TRIGGER_ACT : RISING, FALLING , ANY_EDGE, LEVEL_HI, LEVEL_LO, TIMER 
	XGS_Ctrl->SetGrabMode(TRIGGER_SRC::SW_TRIG, TRIGGER_ACT::RISING);

	//---------------------
    // DMA PARAMETERS
    //---------------------
	DMAParams->FSTART     = ImageBufferAddr;          // Adresse Mono pour DMA
	DMAParams->LINE_PITCH = (M_UINT32)ImageBufferLinePitch;
	DMAParams->LINE_SIZE  = SensorParams->Xsize_Full; // Full window MIL display



	printf_s("\n\nTest started at : ");
	XGS_Ctrl->PrintTime();
	printf_s("\n\n");

	 
	XGS_Ctrl->rXGSptr.ACQ.READOUT_CFG_FRAME_LINE.f.DUMMY_LINES = 0;


	//---------------------
	// Give SPI control to FPGA
	//---------------------
	XGS_Ctrl->EnableRegUpdate();

	// GRAB MODE
   // TRIGGER_SRC : NONE, IMMEDIATE, HW_TRIG, SW_TRIG
   // TRIGGER_ACT : RISING, FALLING , ANY_EDGE, LEVEL_HI, LEVEL_LO 
	XGS_Ctrl->SetGrabMode(TRIGGER_SRC::SW_TRIG, TRIGGER_ACT::RISING);

	// GTX image plane position testing in preparation for GTX
	// abeaudoi - june 2020

	/*
	The goal is to take a sequence of images with different exposure times.
	We do this several times with various numbers of shims between the sensor board and the
	case+lens to see the effect of image quality.
	To ease the post processing we want to encode information in the file names.
	File name structure : [some general name]_[some specific info]_[exposuretime].tiff
	
	-some general name : something like the date and setup information
	
	-some specific info : idealy encode the number of shims used a dot separeted int values in 1/1000 inch.
	ex: no shim would be "0", 2 10/1000" inch and a 5/5000" shims stacked would be "10.10.5".
	This will later be parsed by the processing function.
	
	-exposuretime : exposure time in milliseconds

	The exposure time values are asked every time, the file name corresponding to the 
	[some general name]_[some specific info]
	part of the filename also.

	I use wstrings instead of strings everywhere because thats the only I could get dynamic string names into
	file names.

	*/

	//mil stuff
	MIL_TEXT_CHAR FileName[50];	

	string cin_imagefilename;
	//string cin_quit_character = "q";	// to quit the loop
	string cin_use_old_params = "n";

	// Get the first File name
	std::cout << "Enter output filename (press q to quit) : ";
	cin >> cin_imagefilename;

	while (cin_imagefilename != "q")
	{
		if (cin_use_old_params == "n") {
			printf_s("\nEnter default AnalogGain(1-2-4)         : ");
			scanf_s("%d", &DefaultGain);
			printf_s("\nEnter default DigitalGain(0-127, ou 32=Gain unitaire, step gain 1/32) : ");
			scanf_s("%d", &DefaultDigGain);
			printf_s("\nEnter default Balck Offset(12bit, HEX)  : 0x");
			scanf_s("%x", &DefaultBlackOffset);
			printf_s("\nEnter the Base Exposure in us           : ");
			scanf_s("%d", &ExposureBase);
			printf_s("\nEnter the Increment Exposure in us      : ");
			scanf_s("%d", &ExposureIncr);
			printf_s("\nEnter the number of iterations          : ");
			scanf_s("%d", &ExposureIter);
			printf_s("\n");
			XGS_Ctrl->setAnalogGain(DefaultGain);
			XGS_Ctrl->setDigitalGain(DefaultDigGain);  // ceci va faire saturer le senseur XGS
			XGS_Ctrl->setBlackRef(DefaultBlackOffset);
			printf_s("\n");
		}
		exp_time = ExposureBase;

		for (M_UINT32 iteration = 0; iteration < ExposureIter; iteration++) {

			// grabs and file save for every exposure time in the sequence.
			XGS_Ctrl->setExposure(exp_time);                 // Exposure in us		
			XGS_Data->SetDMA();
			XGS_Ctrl->SetGrabCMD(0, PolldoSleep);            // Ici on poll grab pending, s'il est a '1' on attend qu'il descende a '0'  avant de continuer, on program les paramettres de grab.
			XGS_Ctrl->SW_snapshot(0);                        // Ici on poll trig_rdy avant d'envoyer le trigger
			XGS_Ctrl->WaitEndExpReadout();
			MbufControl(MilGrabBuffer, M_MODIFIED, M_DEFAULT);

#if M_MIL_UNICODE_API
			MosSprintf(FileName, 50, MIL_TEXT("%S_%d.tiff"), cin_imagefilename.c_str(), exp_time);
			printf_s("Printing .tiff file: %S\n\n", FileName);
#else
			MosSprintf(FileName, 50, MIL_TEXT("%s_%d.tiff"), cin_imagefilename.c_str(), exp_time);
			printf_s("Printing .tiff file: %s\n\n", FileName);
#endif

			MbufSave(FileName, MilGrabBuffer);

			exp_time = exp_time + ExposureIncr;
		}

		// Get the following File name
		std::cout << "Enter output filename (press q to quit) : ";
		cin >> cin_imagefilename;

		if (cin_imagefilename != "q") {
			std::cout << "Use same grab parameters? (y or n) : ";
			cin >> cin_use_old_params;
			printf_s("\n");
		}

	}

   

	//------------------------------
	// Free MIL Display
	//------------------------------
	MbufFree(MilGrabBuffer);
	MdispFree(MilDisplay);

	//----------------------
	// Disable HW
	//----------------------
	XGS_Ctrl->SetGrabMode(TRIGGER_SRC::NONE, TRIGGER_ACT::LEVEL_HI);
	XGS_Ctrl->GrabAbort();
	XGS_Data->HiSpiClr();
	XGS_Ctrl->DisableXGS();

	printf_s("\n\n********************************\n");
	printf_s("*    End of Test0009.cpp    *\n");
	printf_s("********************************\n\n");

   }



