//-----------------------------------------------
//
//  Optic test grab Iris4
//
//-----------------------------------------------

/* Headers */
#include <stdio.h> 
#include <stdlib.h> 
#include <conio.h> 
#include <time.h>
#include <math.h>
#include <Windows.h>

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
	unsigned long long ImageBufferAddr=0;
	int MonoType = 8;

	int Sortie = 0;
	char ch;

	bool CheckCRC   = true;
	bool DisplayOn  = true;
	int PolldoSleep =0;
	bool FPS_On     = true;

	M_UINT32 ExposureBase = 8000;
	M_UINT32 ExposureIncr = 10;
	M_UINT32 BlackOffset  = 0x100;
	M_UINT32 XGSSize_Y = 0;

	M_UINT32 SubX = 0;
	M_UINT32 SubY = 0;

	M_UINT32 XGSTestImageMode = 0;

	GrabParamStruct*   GrabParams   = XGS_Ctrl->getGrabParams();         // This is a Local Pointer to grab parameter structure
	SensorParamStruct* SensorParams = XGS_Ctrl->getSensorParams();
	DMAParamStruct*    DMAParams    = XGS_Data->getDMAParams();             // This is a Local Pointer to DMA parameter structure

	M_UINT32 FileDumpNum = 0;

	printf("\n\n********************************\n");
	printf(    "*    Executing Test0009_Optics.cpp    *\n");
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
	ImageBufferAddr = LayerCreateGrabBuffer(&MilGrabBuffer, SensorParams->Xsize_Full, SensorParams->Ysize_Full, MonoType);
	LayerInitDisplay(MilGrabBuffer, &MilDisplay, 1);
	printf("Adresse buffer display (MemPtr) = 0x%llx \n", ImageBufferAddr);

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
	GrabParams->Y_START = 4;                                                // 1-base Here - Dois etre multiple de 4	:  skip : 4 Interpolation (center image) 
	GrabParams->Y_END   = GrabParams->Y_START + SensorParams->Ysize_Full;	// 1-base Here - Dois etre multiple de 4
	//GrabParams->Y_END   = 8;

	GrabParams->SUBSAMPLING_X        = 0;
	GrabParams->M_SUBSAMPLING_Y      = 0;
	GrabParams->ACTIVE_SUBSAMPLING_Y = 0;

	XGS_Ctrl->setBlackRef(0);
	XGS_Ctrl->setAnalogGain(1);

	// GRAB MODE
	// TRIGGER_SRC : NONE, IMMEDIATE, HW_TRIG, SW_TRIG
	// TRIGGER_ACT : RISING, FALLING , ANY_EDGE, LEVEL_HI, LEVEL_LO, TIMER 
	XGS_Ctrl->SetGrabMode(SW_TRIG, RISING);

	//---------------------
    // DMA PARAMETERS
    //---------------------
	DMAParams->FSTART     = ImageBufferAddr;          // Adresse Mono pour DMA
	DMAParams->LINE_PITCH = SensorParams->Xsize_Full; // Full window MIL display
	DMAParams->LINE_SIZE  = SensorParams->Xsize_Full;



	printf("\n\nTest started at : ");
	XGS_Ctrl->PrintTime();


	 
	XGS_Ctrl->rXGSptr.ACQ.READOUT_CFG_FRAME_LINE.f.DUMMY_LINES = 0;


	//---------------------
	// Give SPI control to FPGA
	//---------------------
	XGS_Ctrl->EnableRegUpdate();

	// GRAB MODE
   // TRIGGER_SRC : NONE, IMMEDIATE, HW_TRIG, SW_TRIG
   // TRIGGER_ACT : RISING, FALLING , ANY_EDGE, LEVEL_HI, LEVEL_LO 
	XGS_Ctrl->SetGrabMode(SW_TRIG, RISING);

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

	std::wstring imagefilename;	
	std::wstring quit_character = L"q";	// to quit the loop

	std::wstring fullfilename;
	std::wstring f_str;

	const wchar_t* fullfilename2;


	printf("\nEnter the Base Exposure in us : ");
	scanf_s("%d", &ExposureBase);
	printf("\n");
	printf("\nEnter the Increment Exposure in us : ");
	scanf_s("%d", &ExposureIncr);
	printf("\n");

	// get the first middlefix
	std::cin.ignore();
    std::cout << "filename (press q to quit) : ";
	std::getline(std::wcin, imagefilename);

	
	while (imagefilename != quit_character)
	{

		M_UINT32 exp_time_1 = ExposureBase;
		M_UINT32 exp_time_2 = ExposureBase+(ExposureIncr);
		M_UINT32 exp_time_3 = ExposureBase+(ExposureIncr*2);
		M_UINT32 exp_time_4 = ExposureBase+(ExposureIncr*3);
		M_UINT32 exp_time_5 = ExposureBase+(ExposureIncr*4);

		// grabs and file save for every exposure time in the sequence.


		XGS_Ctrl->setExposure(exp_time_1);                 //Exposure in us		
		XGS_Data->SetDMA();
		XGS_Ctrl->SetGrabCMD(0, PolldoSleep);     // Ici on poll grab pending, s'il est a '1' on attend qu'il descende a '0'  avant de continuer, on program les paramettres de grab.
		XGS_Ctrl->SW_snapshot(0);                     // Ici on poll trig_rdy avant d'envoyer le trigger
		XGS_Ctrl->WaitEndExpReadout();
		MbufControl(MilGrabBuffer, M_MODIFIED, M_DEFAULT);
        
        // lines below for silly conversion and append
		fullfilename = imagefilename;
		fullfilename += L"_";
		f_str = std::to_wstring(exp_time_1);
		fullfilename += f_str;
		fullfilename += L".tiff";
		fullfilename2 = fullfilename.c_str();
		
	    MosSprintf(FileName, 50, fullfilename2);
		printf("\nPrinting .tiff file: %S\n", FileName);
		MbufSave(FileName, MilGrabBuffer);
		//      Sleep(2000);

		// grabs and file save for every exposure time in the sequence.

		XGS_Ctrl->setExposure(exp_time_2);                 //Exposure in us		
		XGS_Data->SetDMA();
		XGS_Ctrl->SetGrabCMD(0, PolldoSleep);     // Ici on poll grab pending, s'il est a '1' on attend qu'il descende a '0'  avant de continuer, on program les paramettres de grab.
		XGS_Ctrl->SW_snapshot(0);                     // Ici on poll trig_rdy avant d'envoyer le trigger
		XGS_Ctrl->WaitEndExpReadout();
		MbufControl(MilGrabBuffer, M_MODIFIED, M_DEFAULT);


		// lines below for silly conversion and append
		fullfilename = imagefilename;
		fullfilename += L"_";
		f_str = std::to_wstring(exp_time_2);
		fullfilename += f_str;
		fullfilename += L".tiff";
		fullfilename2 = fullfilename.c_str();

		MosSprintf(FileName, 50, fullfilename2);
		printf("\nPrinting .tiff file: %S\n", FileName);
		MbufSave(FileName, MilGrabBuffer);
		//      Sleep(2000);

		// grabs and file save for every exposure time in the sequence.
		//exp_time_str = std::to_string(exp_time_3);

		XGS_Ctrl->setExposure(exp_time_3);                 //Exposure in us		
		XGS_Data->SetDMA();
		XGS_Ctrl->SetGrabCMD(0, PolldoSleep);     // Ici on poll grab pending, s'il est a '1' on attend qu'il descende a '0'  avant de continuer, on program les paramettres de grab.
		XGS_Ctrl->SW_snapshot(0);                     // Ici on poll trig_rdy avant d'envoyer le trigger
		XGS_Ctrl->WaitEndExpReadout();
		MbufControl(MilGrabBuffer, M_MODIFIED, M_DEFAULT);


		// lines below for silly conversion and append
		fullfilename = imagefilename;
		fullfilename += L"_";
		f_str = std::to_wstring(exp_time_3);
		fullfilename += f_str;
		fullfilename += L".tiff";
		fullfilename2 = fullfilename.c_str();

		MosSprintf(FileName, 50, fullfilename2);
		printf("\nPrinting .tiff file: %S\n", FileName);
		MbufSave(FileName, MilGrabBuffer);
		//      Sleep(2000);

		// grabs and file save for every exposure time in the sequence.
		//exp_time_str = std::to_string(exp_time_4);

		XGS_Ctrl->setExposure(exp_time_4);                 //Exposure in us	
		XGS_Data->SetDMA();
		XGS_Ctrl->SetGrabCMD(0, PolldoSleep);     // Ici on poll grab pending, s'il est a '1' on attend qu'il descende a '0'  avant de continuer, on program les paramettres de grab.
		XGS_Ctrl->SW_snapshot(0);                     // Ici on poll trig_rdy avant d'envoyer le trigger
		XGS_Ctrl->WaitEndExpReadout();
		MbufControl(MilGrabBuffer, M_MODIFIED, M_DEFAULT);


		// lines below for silly conversion and append
		fullfilename = imagefilename;
		fullfilename += L"_";
		f_str = std::to_wstring(exp_time_4);
		fullfilename += f_str;
		fullfilename += L".tiff";
		fullfilename2 = fullfilename.c_str();

		MosSprintf(FileName, 50, fullfilename2);
		printf("\nPrinting .tiff file: %S\n", FileName);
		MbufSave(FileName, MilGrabBuffer);
		//      Sleep(2000);

		// grabs and file save for every exposure time in the sequence.
		//exp_time_str = std::to_string(exp_time_5);

		XGS_Ctrl->setExposure(exp_time_5);                 //Exposure in us		
		XGS_Data->SetDMA();
		XGS_Ctrl->SetGrabCMD(0, PolldoSleep);     // Ici on poll grab pending, s'il est a '1' on attend qu'il descende a '0'  avant de continuer, on program les paramettres de grab.
		XGS_Ctrl->SW_snapshot(0);                     // Ici on poll trig_rdy avant d'envoyer le trigger
		XGS_Ctrl->WaitEndExpReadout();
		MbufControl(MilGrabBuffer, M_MODIFIED, M_DEFAULT);


		// lines below for silly conversion and append
		fullfilename = imagefilename;
		fullfilename += L"_";
		f_str = std::to_wstring(exp_time_5);
		fullfilename += f_str;
		fullfilename += L".tiff";
		fullfilename2 = fullfilename.c_str();

		MosSprintf(FileName, 50, fullfilename2);
		printf("\nPrinting .tiff file: %S\n", FileName);
		MbufSave(FileName, MilGrabBuffer);
		//      Sleep(2000);


	    std::cout << "filename middlefix (press q to quit) : ";
		std::getline(std::wcin, imagefilename);


	}

   

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



