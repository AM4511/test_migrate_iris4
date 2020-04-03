//
//

#define _CRT_SECURE_NO_DEPRECATE

#include "stdafx.h"
#include <stdio.h> 
#include <stdlib.h> 
#include <conio.h> 
#include <time.h>

#include <string>
using std::string;

#include "XGS_Ctrl.h"

#include "mtxservmanager.h"

#include <iostream>

#include <algorithm>
#include <vector>
using namespace std;




CXGS_Ctrl::CXGS_Ctrl(volatile FPGA_REGFILE_XGS_CTRL_TYPE& i_rXGSptr, double setSysPerFs, double setSensorPerFs):
	rXGSptr(i_rXGSptr)
{

	SystemPeriodNanoSecond = setSysPerFs;
	SensorPeriodNanoSecond = setSensorPerFs;

	memset(&sXGSptr, 0, sizeof(sXGSptr));
	memcpy(&sXGSptr, (const void*)& rXGSptr, sizeof(sXGSptr));


	//------------------------------------
// GrabParams
//------------------------------------
	GrabParams = {
		0,              //TRIGGER_OVERLAP_BUFFn
		1,              //TRIGGER OVERLAP 
		NONE,           //TRIGGER_SRC;
		RISING,         //TRIGGER_ACT;
		EXP_TIMED_MODE, //EXPOSURE_LEV_MODE;

		0x4c4b4,       //ExposureSS, 5us
		0x0,           //ExposureDS,
		0x0,           //ExposureTS,

		0x0,           //TRIGGER_DELAY;

		0x0,           //STROBE_E;
		0x0,           //STROBE_MODE;
		0x0,           //STROBE_START;
		0xfffffff,     //STROBE_END;

		0x00000000,    //FrameStart
		0x00000000,    //FrameStartG
		0x00000000,    //FrameStartB
		0x500,         //LinePitch, 1280pix
		0x0,           //COLOR_SPACE;

		0,             //Y_START
		480,           //Y_END	

		0,             //roi2 Y_START
		480,           //roi2 Y_END	

		0xf,           //BLACK_OFFSET

		0x0 ,          //ANALOG GAIN
 		0,             //REVERSE_Y
		0,             //MONO10

        0,             //M_SUBSAMPLING_Y;
	    0,             //ACTIVE_SUBSAMPLING_Y;
	    0,             //SUBSAMPLING_X;

	    0,             //FOT;

	    0,             //XSM_DELAY;

	};

	//------------------------------------
	// SensorParams
	//------------------------------------
	SensorParams = {

		0,             //Sensor Type
		24,            //XGSmax HISPI channels 
		1280,          //Xsize_Full
		1024,          //Ysize_Full
		1280,          //Xsize_BL;

		0,             //FOT;
		0,             //BL_LINES;
		0,             //EXP_DUMMY_LINES;



	};




}



CXGS_Ctrl::~CXGS_Ctrl()
{


}


GrabParamStruct* CXGS_Ctrl::getGrabParams(void)
{
	return &GrabParams;
}

SensorParamStruct* CXGS_Ctrl::getSensorParams(void)
{
	return &SensorParams;
}




//volatile FPGA_REGFILE_XGS_CTRL_TYPE* CXGS_Ctrl::getRegisterXGS_Ctrl(void)
//{
//	return rXGSptr;
//}




//------------------------------------------------------------------------------------
// XGS SPI WRITE  
//------------------------------------------------------------------------------------
void CXGS_Ctrl::WriteSPI(M_UINT32 address, M_UINT32 data)
{


/*
    //CODE test
	sXGSptr.ACQ.ACQ_SER_ADDATA.u32 = (address & 0x7fff) + ((data & 0xffff) << 16);
	rXGSptr.ACQ.ACQ_SER_ADDATA.u32 = sXGSptr.ACQ.ACQ_SER_ADDATA.u32;               // Set address and data to write in sensor

	sXGSptr.ACQ.ACQ_SER_CTRL.u32 = 0x0000;
	rXGSptr.ACQ.ACQ_SER_CTRL.u32 = sXGSptr.ACQ.ACQ_SER_CTRL.u32;

	sXGSptr.ACQ.ACQ_SER_CTRL.u32 = 0x0001;
	rXGSptr.ACQ.ACQ_SER_CTRL.u32 = sXGSptr.ACQ.ACQ_SER_CTRL.u32;
	sXGSptr.ACQ.ACQ_SER_CTRL.u32 = 0x0000;
	
	while ((rXGSptr.ACQ.ACQ_SER_STAT.u32 &0xff000000 ) != 0x00000000);
	
	sXGSptr.ACQ.ACQ_SER_CTRL.u32 = 0x0010;
	rXGSptr.ACQ.ACQ_SER_CTRL.u32 = sXGSptr.ACQ.ACQ_SER_CTRL.u32;
	sXGSptr.ACQ.ACQ_SER_CTRL.u32 = 0x0000;

	while ( (rXGSptr.ACQ.ACQ_SER_STAT.u32 & 0x00ff0000) == 0x00010000);

*/



 	//CODE OK
	sXGSptr.ACQ.ACQ_SER_ADDATA.u32 = (address & 0x7fff) + ((data & 0xffff) << 16);
	rXGSptr.ACQ.ACQ_SER_ADDATA.u32 = sXGSptr.ACQ.ACQ_SER_ADDATA.u32;               // Set address and data to write in sensor
	rXGSptr.ACQ.ACQ_SER_CTRL.u32 = 0x00000;
	rXGSptr.ACQ.ACQ_SER_CTRL.u32 = 0x00001;
	Sleep(100);                                                                  // Si je mets pas le sleep ici le compilateur optimize le volatile et le REad ne se fait pas!!!
	rXGSptr.ACQ.ACQ_SER_CTRL.u32 = 0x00010;

  	while (rXGSptr.ACQ.ACQ_SER_STAT.f.SER_BUSY == 0x1);                          // Loop wait for the access end



}


//------------------------------------------------------------------------------------
// XGS SPI WRITE BURST 
//------------------------------------------------------------------------------------
void CXGS_Ctrl::WriteSPI_BURST(M_UINT32 tableau[500])
{
	int i = 0;
	M_UINT32 add;
	M_UINT32 data;
	printf("   SPI WRITE BURST : ");
	while (tableau[i + 1] != 0xcafefade) {  //cafefade is End character
		add = tableau[0] + (i*2);
		data = tableau[i + 1];
		WriteSPI(add, data);
		//printf("\nSPI WRITE BURST : number=%d add=0x%X data=0x%X", i, add, data);
		i++;
	}
	//printf("\n");
	printf("\r   SPI WRITE BURST : total writes=%d\n", i);
}

//------------------------------------------------------------------------------------
// XGS SPI WRITE BIT : This function write one bit of the serial register 
// Bit2Write : is the location to write (bit is 0 based)
//------------------------------------------------------------------------------------
void CXGS_Ctrl::WriteSPI_Bit(M_UINT32 address, M_UINT32 Bit2Write, M_UINT32 data)
{
	// Make mask
	M_UINT32 mask = 0;

	mask = mask | (1 << Bit2Write);

	M_UINT32 notmask = 65535 - mask; // 0xffff = 65535

	// Read back what is in this register
	M_UINT32 CurrentValue = ReadSPI(address);

	// Bit-wise operations using the mask to get the new value
	M_UINT32 ShiftedValue = (data << Bit2Write);
	M_UINT32 NewValue = (CurrentValue & notmask) | (ShiftedValue & mask);
	// Upload new value
	WriteSPI(address, NewValue);

	Sleep(1);

	//Verify wrote data 
	M_UINT32 verify = ReadSPI(address);
	Sleep(1);
	if (verify != NewValue) {
		printf("\n\nSPI VERIFY FAIL\n\n\n");
		exit(1);
	}

};


//----------------------------------------------------
// XGS SPI READ
//----------------------------------------------------
M_UINT32 CXGS_Ctrl::ReadSPI(M_UINT32 address)
{

//	//CODE NO OK
//	sXGSptr.ACQ.ACQ_SER_ADDATA.u32 = (address & 0x7fff) ;
//	rXGSptr.ACQ.ACQ_SER_ADDATA.u32 = sXGSptr.ACQ.ACQ_SER_ADDATA.u32;               // Set address and data to write in sensor
//	
//	rXGSptr.ACQ.ACQ_SER_CTRL.u32 = 0;
//	rXGSptr.ACQ.ACQ_SER_CTRL.f.SER_CMD   = 0x0;                                    // Sensor access type
//	rXGSptr.ACQ.ACQ_SER_CTRL.f.SER_RWN   = 0x1;                                    // Write access  
//	rXGSptr.ACQ.ACQ_SER_CTRL.f.SER_WF_SS = 0x1;                                    // Write the command to the queue fifo
//	M_UINT32 dataread = rXGSptr.ACQ.ACQ_SER_CTRL.u32;
//	rXGSptr.ACQ.ACQ_SER_CTRL.u32 = dataread + 0x10;
//	//rXGSptr.ACQ.ACQ_SER_CTRL.f.SER_RF_SS = 0x1;                                   // Write the command to the queue fifo
//	//rXGSptr.ACQ.ACQ_SER_CTRL.f.SER_RF_SS = 0x0;
//																				  //Sleep(100);
//	//rXGSptr.ACQ.ACQ_SER_CTRL.u32 = 0x10010;
	
//no snoop??? relax reordering ???


//	//CODE OK
	sXGSptr.ACQ.ACQ_SER_ADDATA.u32 = (address & 0x7fff);
	rXGSptr.ACQ.ACQ_SER_ADDATA.u32 = sXGSptr.ACQ.ACQ_SER_ADDATA.u32;               // Set address and data to write in sensor
	rXGSptr.ACQ.ACQ_SER_CTRL.u32 = 0x10000;
	rXGSptr.ACQ.ACQ_SER_CTRL.u32 = 0x10001;
	Sleep(100);
	//while (rXGSptr.ACQ.ACQ_SER_STAT.f.SER_FIFO_EMPTY == 0x1);

    rXGSptr.ACQ.ACQ_SER_CTRL.u32 = 0x10010;

	while (rXGSptr.ACQ.ACQ_SER_STAT.f.SER_BUSY == 0x1);     // Loop wait for the access end

	return ((rXGSptr.ACQ.ACQ_SER_STAT.u32) & 0xffff);       // Return the read value 


}


//----------------------------------------------------------
// This function polls one register
//----------------------------------------------------------
void CXGS_Ctrl::PollRegSPI(M_UINT32 address, M_UINT32 maskN, M_UINT32 Data2Poll, M_UINT32 Delay, M_UINT32 TimeOut)
{
	M_UINT32 DataRead = 0x0;
	M_UINT32 nb_iter  = 0x0;

	DataRead = ReadSPI(address);

	while ( (DataRead & maskN) != Data2Poll)
	{
		Sleep(Delay);
		DataRead = ReadSPI(address);
		nb_iter++;

		if (nb_iter > TimeOut)
		{
			printf("CXGS_Ctrl::PollReg :  nombre maximum de polling atteint dans la fonction de polling du XGS controller! EXIT");
			exit(1);
		}
	}
	printf("XGS polling @ add =0x%X, received data 0x%X\n", address, DataRead);

}

//----------------------------------------------------------
// This function dumps regfile to a file
//----------------------------------------------------------
void CXGS_Ctrl::ReadSPI_DumpFile()
{
	FILE* f_dump;
	int   f_dump_Open = FALSE;

	if (f_dump_Open != TRUE)
	{
		f_dump_Open = TRUE;
		f_dump = fopen("PythonDump_All_Regs.txt", "w+t");

		if (f_dump == NULL)
		{
			printf("ERROR when trying to open file PythonDump_All_Regs.txt \n");
			exit(1);
		}
		else
		{
			printf("\nDump of XGSregisters into file PythonDump_All_Regs.txt  \n");
			fprintf(f_dump, "XGS SPI REgister Dump\n\n");
			fprintf(f_dump, "Add\tData\n\n");
			
			fprintf(f_dump, "0x%04X\t0x%04X\n",    0x0, ReadSPI(0x0000));
			fprintf(f_dump, "0x%04X\t0x%04X\n",    0x2, ReadSPI(0x0002));
			
			fprintf(f_dump, "0x%04X\t0x%04X\n", 0x3012, ReadSPI(0x3012));

			fprintf(f_dump, "0x%04X\t0x%04X\n", 0x3602, ReadSPI(0x3602));

			fprintf(f_dump, "0x%04X\t0x%04X\n", 0x3700, ReadSPI(0x3700));

			for (int i = 0x3800; i < 0x38c0; i = i + 2)
			{
				fprintf(f_dump, "0x%04X\t0x%04X\n", i, ReadSPI(i));
			}

			for (int i = 0x3e0e; i < 0x3e84; i = i + 2)
			{
				fprintf(f_dump, "0x%04X\t0x%04X\n", i, ReadSPI(i));
			}
			fclose(f_dump);
			f_dump_Open = FALSE;

		}
	}
}




//----------------------------------------------------------
// This function dumps one section of the XGS regfile
//----------------------------------------------------
void CXGS_Ctrl::DumpRegSPI(M_UINT32 SPI_START, M_UINT32 SPI_END)
{
	M_UINT32 address;
	M_UINT32 dataread;

	if (SPI_END >= SPI_START && SPI_END < 512)
	{
		for (address = SPI_START; address < SPI_END + 1; address++)
		{
			dataread = ReadSPI(address);
			printf("Add=%d, Data=0x%X \n", address, dataread);
		}
		printf("Done.\n");
	}
	else
		printf("Bad Address range to read from sensor! \n");

}



//----------------------------------------------------------
// This function Inits the XGS sensor from XGS12M-REV2.ini
//----------------------------------------------------------
void CXGS_Ctrl::InitXGS()
{
	M_UINT32 iter = 0;
	M_UINT32 DataRead;

	// Sensor already POWERED, POWERDOWN!
	if (rXGSptr.ACQ.SENSOR_STAT.f.SENSOR_POWERUP_DONE == 1 && rXGSptr.ACQ.SENSOR_STAT.f.SENSOR_POWERUP_STAT == 1) {
		printf("XGS already Powerup, powerdown ");
		
		sXGSptr.ACQ.SENSOR_CTRL.f.SENSOR_POWERDOWN = 1;
		rXGSptr.ACQ.SENSOR_CTRL.u32 = sXGSptr.ACQ.SENSOR_CTRL.u32;
		sXGSptr.ACQ.SENSOR_CTRL.f.SENSOR_POWERDOWN = 0;

		// Wait for dowerdown
		DataRead = rXGSptr.ACQ.SENSOR_STAT.f.SENSOR_POWERDOWN;
		while (DataRead == 0) {
			Sleep(1);
			DataRead = rXGSptr.ACQ.SENSOR_STAT.f.SENSOR_POWERDOWN;
			iter++;
			if (iter == 1000) {
				printf("fail!\n\n");
				exit(1);
			}
		}
		printf("done!\n\n");
	}
	Sleep(100);

	// WakeUP XGS SENSOR : unreset and enable clk to the sensor : SENSOR_POWERUP
	sXGSptr.ACQ.SENSOR_CTRL.f.SENSOR_RESETN = 1; //reset is controlled by the state machine, this field is to overwrite if needed
	sXGSptr.ACQ.SENSOR_CTRL.f.SENSOR_POWERUP = 1;
	rXGSptr.ACQ.SENSOR_CTRL.u32 = sXGSptr.ACQ.SENSOR_CTRL.u32;
	sXGSptr.ACQ.SENSOR_CTRL.f.SENSOR_POWERUP = 0;

	// Wait for done
	iter = 0;
	DataRead = rXGSptr.ACQ.SENSOR_STAT.f.SENSOR_POWERUP_DONE;
	while (DataRead == 0) {
		Sleep(1);
		DataRead = rXGSptr.ACQ.SENSOR_STAT.f.SENSOR_POWERUP_DONE;
		iter++;
		if (iter == 1000) {
			printf("Powerup done fail\n\n");
			exit(1);
		}
	}
	if (rXGSptr.ACQ.SENSOR_STAT.f.SENSOR_POWERUP_STAT==0) { //powerup fail
		printf("Powerup stat fail\n");
		exit(1);
	}
	printf("XGS Powerup done OK\n\n");

	Sleep(100);

	// READ XGS MODEL ID and REVISION
	sXGSptr.ACQ.SENSOR_CTRL.f.SENSOR_REG_UPTATE = 0;
	rXGSptr.ACQ.SENSOR_CTRL.u32 = sXGSptr.ACQ.SENSOR_CTRL.u32;

	DataRead = ReadSPI(0x0);
	if (DataRead == 0x0358) 
		printf("XGS Model ID detected is 0x358, XGS5M");

	else if (DataRead == 0x0058) {
		printf("XGS Model ID detected is 0x58, XGS12M\n");
		DataRead = ReadSPI(0x2);
		printf("XGS RevNum Major: 0x%X, XGS RevNum Minor: 0x%X\n", DataRead&0xff, (DataRead & 0xff00)>>16);

		DataRead = ReadSPI(0x3012);

		if(((DataRead&0x1c)>>2) == 0)
		  printf("XGS Resolution is 12Mp\n");
		if (((DataRead & 0x1c)>> 2) == 3)
			printf("XGS Resolution is 8Mp\n");

		if (((DataRead & 0x60) >> 5) == 0)
			printf("XGS Speedgrade is 24 ports\n");
		if (((DataRead & 0x60) >> 5) == 1)
			printf("XGS Speedgrade is 12 ports\n");
		if (((DataRead & 0x60) >> 5) == 3)
			printf("XGS Speedgrade is 6 ports\n");

		if ((DataRead & 0x3)  == 1)
			printf("XGS is COLOR\n");
		if ((DataRead & 0x3) == 2)
			printf("XGS is MONO\n");

		SetGrabParamsInit12000(6);
		LoadDCF_12K(6);
	}
	else
	{
		printf("\n\nSenseur XGS id=0x%X non reconnu. EXIT \n\n", DataRead);
		exit(1);
	}

	

	M_UINT32 EXP_FOT_TIME     = 5360;  //5.36us calculated from start of FOT to end of real exposure in dev board
	
	//Enable EXP during FOT
	sXGSptr.ACQ.EXP_FOT.f.EXP_FOT_TIME = (M_UINT32) ((double)EXP_FOT_TIME / SystemPeriodNanoSecond);
	sXGSptr.ACQ.EXP_FOT.f.EXP_FOT      = 1;
	rXGSptr.ACQ.EXP_FOT.u32 = sXGSptr.ACQ.EXP_FOT.u32;

	//Trigger KeepOut zone
	sXGSptr.ACQ.READOUT_CFG4.f.KEEP_OUT_TRIG_START = (M_UINT32)(double((sXGSptr.ACQ.READOUT_CFG3.f.LINE_TIME * SensorPeriodNanoSecond) - 100) / SystemPeriodNanoSecond);   //START Keepout trigger zone (100ns)
	sXGSptr.ACQ.READOUT_CFG4.f.KEEP_OUT_TRIG_END   = (M_UINT32)(double( sXGSptr.ACQ.READOUT_CFG3.f.LINE_TIME * SensorPeriodNanoSecond) / SystemPeriodNanoSecond);           //END   Keepout trigger zone (100ns), this is more for testing, monitor will reset the counter 	
	rXGSptr.ACQ.READOUT_CFG4.u32= sXGSptr.ACQ.READOUT_CFG4.u32;
	
	sXGSptr.ACQ.READOUT_CFG3.f.KEEP_OUT_TRIG_ENA   = 1;
	rXGSptr.ACQ.READOUT_CFG3.u32                   = sXGSptr.ACQ.READOUT_CFG3.u32;

 

}




//----------------------------------------------------
//
//  Print Time
//
//----------------------------------------------------
void CXGS_Ctrl::PrintTime(void)
{

	time_t ltime;
	wchar_t buf[26];
	errno_t err;

	time(&ltime);

	err = _wctime_s(buf, 26, &ltime);
	if (err != 0)
	{
		printf("Invalid Arguments for _wctime_s. Error Code: %d\n", err);
	}
	wprintf_s(L"Current time is %s", buf);

}



//----------------------------------------------------------
// This function Disable the XGS sensor
//----------------------------------------------------------
void CXGS_Ctrl::DisableXGS()
{
	M_UINT32 iter = 0;
	M_UINT32 DataRead;

	// Sensor already POWERED, POWERDOWN!
	if (rXGSptr.ACQ.SENSOR_STAT.f.SENSOR_POWERUP_DONE == 1 && rXGSptr.ACQ.SENSOR_STAT.f.SENSOR_POWERUP_STAT == 1) {
		printf("Disabling XGS (disable clk and reset)... ");
		sXGSptr.ACQ.SENSOR_CTRL.f.SENSOR_POWERDOWN = 1;
		rXGSptr.ACQ.SENSOR_CTRL.u32 = sXGSptr.ACQ.SENSOR_CTRL.u32;
		sXGSptr.ACQ.SENSOR_CTRL.f.SENSOR_POWERDOWN = 0;  //wo

		// Wait for dowerdown
		DataRead = rXGSptr.ACQ.SENSOR_STAT.f.SENSOR_POWERDOWN;
		while (DataRead == 0) {
			Sleep(1);
			DataRead = rXGSptr.ACQ.SENSOR_STAT.f.SENSOR_POWERDOWN;
			iter++;
			if (iter == 1000) {
				printf("fail!\n\n");
				exit(1);
			}
		}
		printf("done!\n\n");
	}
	Sleep(100);
}



//----------------------------------------------------
//  setExposure : in us  
//----------------------------------------------------
void CXGS_Ctrl::setExposure(M_UINT32 exposure_ss_us)
{

	if (exposure_ss_us >= 10 && exposure_ss_us < 4200000)
		GrabParams.Exposure = (M_UINT32)((double)exposure_ss_us * 1000.0 / SystemPeriodNanoSecond); // Exposure in us	
}


//----------------------------------------------------
//  setBalckRef
//----------------------------------------------------
void CXGS_Ctrl::setBlackRef(int value)
{
	GrabParams.BLACK_OFFSET = value;
}

//----------------------------------------------------
//  Set GRAB MODE
//----------------------------------------------------
void CXGS_Ctrl::SetGrabMode(TRIGGER_SRC TRIGGER_SOURCE, TRIGGER_ACT TRIGGER_ACTIVATION)
{
	GrabParams.TRIGGER_ACT = TRIGGER_ACTIVATION;
	GrabParams.TRIGGER_SRC = TRIGGER_SOURCE;
}

//----------------------------------------------------
//  Sensor Enable REGISTER UPDATE
//----------------------------------------------------
void CXGS_Ctrl::EnableRegUpdate(void)
{
	sXGSptr.ACQ.SENSOR_CTRL.f.SENSOR_REG_UPTATE = 1;   // Enable REGISTER UPDATE
	rXGSptr.ACQ.SENSOR_CTRL.u32 = sXGSptr.ACQ.SENSOR_CTRL.u32;
}

//----------------------------------------------------
//  Sensor Disable REGISTER UPDATE
//----------------------------------------------------
void CXGS_Ctrl::DisableRegUpdate(void)
{

	WaitEndExpReadout();
	sXGSptr.ACQ.SENSOR_CTRL.f.SENSOR_REG_UPTATE = 0;   // Disable REGISTER UPDATE
	rXGSptr.ACQ.SENSOR_CTRL.u32 = sXGSptr.ACQ.SENSOR_CTRL.u32;
}


//----------------------------------------------------
//  Wait for end of EXPOSURE+Readout
//----------------------------------------------------
void CXGS_Ctrl::WaitEndExpReadout(void)
{
	int loop_nb = 0;


	while (rXGSptr.ACQ.GRAB_STAT.f.GRAB_IDLE == 0)
	{// Sequence not finish yet
	//wait for grab idle
		loop_nb++;
		if (loop_nb == 2000)
		{
			printf("ERROR TIMEOUT : GRAB IDLE=0, depuis 2 secondes!\n");
			return;
		}
		Sleep(1);
	}

	// Case we are in LVDS 4x with extended ROT time in the sensor, the Sequencer readout will fininsh before Datapath readout
	// this while will wait for the end of datapath readout before going forward.
	loop_nb = 0;

	while (rXGSptr.ACQ.GRAB_STAT.f.GRAB_READOUT == 1)
		//printf("\n NB loop in wait for GRAB_IDLE %d", loop_nb);
	{
		//wait for grab idle
		loop_nb++;
		if (loop_nb == 2000)
		{
			printf("ERROR TIMEOUT : GRAB Readout=1, depuis 2 secondes!\n");
			return;
		}
		Sleep(1);
	}


}


//--------------------------------------------------------
//  GRAB ABORT
//--------------------------------------------------------
int CXGS_Ctrl::GrabAbort()
{
	M_UINT32 loop_nb = 0;
	M_UINT32 max_iter = 0xffffff;

	sXGSptr.ACQ.GRAB_CTRL.f.ABORT_GRAB = 1;
	rXGSptr.ACQ.GRAB_CTRL.u32          = sXGSptr.ACQ.GRAB_CTRL.u32;
	sXGSptr.ACQ.GRAB_CTRL.f.ABORT_GRAB = 0;

	while (rXGSptr.ACQ.GRAB_STAT.f.ABORT_DONE == 0)
	{
		if (loop_nb == 1000)
		{
			printf("\n\nGRAB NOT ABORTED FOR 2 seconds, something gone wrong!\n\n");

			printf("  Grab Idle        = %d\n",   rXGSptr.ACQ.GRAB_STAT.f.GRAB_IDLE);
			printf("  Grab Active      = %d\n",   rXGSptr.ACQ.GRAB_STAT.f.GRAB_ACTIVE);
			printf("  Grab Pending     = %d\n",   rXGSptr.ACQ.GRAB_STAT.f.GRAB_PENDING);
			printf("  Grab Exposure    = %d\n",   rXGSptr.ACQ.GRAB_STAT.f.GRAB_EXPOSURE);
			printf("  Grab Readout     = %d\n",   rXGSptr.ACQ.GRAB_STAT.f.GRAB_READOUT);
			printf("  Grab FOT         = %d\n",   rXGSptr.ACQ.GRAB_STAT.f.GRAB_FOT);
			printf("  GRAB_MNGR_STATE  = 0x%x\n", rXGSptr.ACQ.GRAB_STAT.f.GRAB_MNGR_STAT);
			printf("  TIMER_MNGR_STATE = 0x%x\n", rXGSptr.ACQ.GRAB_STAT.f.TIMER_MNGR_STAT);
			printf("  TRIG_MNGR_STATE  = 0x%x\n", rXGSptr.ACQ.GRAB_STAT.f.TRIG_MNGR_STAT);
			printf("  Grab TRIG RDY    = %d\n",   rXGSptr.ACQ.GRAB_STAT.f.TRIGGER_RDY);
			printf("  SPI FIFO_EMPTY   = %d\n",   rXGSptr.ACQ.ACQ_SER_STAT.f.SER_FIFO_EMPTY);
			printf("  ABORT_DONE       = %d\n",   rXGSptr.ACQ.GRAB_STAT.f.ABORT_DONE);
			printf("  ABORT_PET        = %d\n",   rXGSptr.ACQ.GRAB_STAT.f.ABORT_PET);
			printf("  ABORT_DELAI      = %d\n",   rXGSptr.ACQ.GRAB_STAT.f.ABORT_DELAI);

			if (rXGSptr.ACQ.GRAB_STAT.f.ABORT_MNGR_STAT == 0)
				printf("  ABORT_MNGR_STATE = Idle\n");
			if (rXGSptr.ACQ.GRAB_STAT.f.ABORT_MNGR_STAT == 1)
				printf("  ABORT_MNGR_STATE = Abort_states\n");
			if (rXGSptr.ACQ.GRAB_STAT.f.ABORT_MNGR_STAT == 2)
				printf("  ABORT_MNGR_STATE = Abort_cmd_flags\n");
			if (rXGSptr.ACQ.GRAB_STAT.f.ABORT_MNGR_STAT == 3)
				printf("  ABORT_MNGR_STATE = Abort_ser_fifo\n");
			if (rXGSptr.ACQ.GRAB_STAT.f.ABORT_MNGR_STAT == 4)
				printf("  ABORT_MNGR_STATE = Abort_dma\n");
			if (rXGSptr.ACQ.GRAB_STAT.f.ABORT_MNGR_STAT == 5)
				printf("  ABORT_MNGR_STATE = Abort_irq\n");

			printf("\n\nPress any key to continue.\n\n");
			_getch();
			break;
		}
		Sleep(1);
		loop_nb++;
	}

	if (rXGSptr.ACQ.GRAB_STAT.f.GRAB_IDLE == 0 ||
		rXGSptr.ACQ.GRAB_STAT.f.GRAB_ACTIVE == 1 ||
		rXGSptr.ACQ.GRAB_STAT.f.GRAB_PENDING == 1 ||
		rXGSptr.ACQ.GRAB_STAT.f.GRAB_EXPOSURE == 1 ||
		rXGSptr.ACQ.GRAB_STAT.f.GRAB_READOUT == 1 ||
		rXGSptr.ACQ.GRAB_STAT.f.GRAB_FOT == 1 ||
		rXGSptr.ACQ.GRAB_STAT.f.GRAB_MNGR_STAT != 0 ||
		rXGSptr.ACQ.GRAB_STAT.f.TIMER_MNGR_STAT != 0 ||
		rXGSptr.ACQ.GRAB_STAT.f.TRIG_MNGR_STAT != 0 ||
		rXGSptr.ACQ.GRAB_STAT.f.TRIGGER_RDY == 1 ||
		rXGSptr.ACQ.ACQ_SER_STAT.f.SER_FIFO_EMPTY == 0
		)
	{
		printf("\n\nGRAB ABORT NOT FINISH AS IT SHOULD!!\n\n");

		printf("Grab Idle        = %d\n",   rXGSptr.ACQ.GRAB_STAT.f.GRAB_IDLE);
		printf("Grab Active      = %d\n",   rXGSptr.ACQ.GRAB_STAT.f.GRAB_ACTIVE);
		printf("Grab Pending     = %d\n",   rXGSptr.ACQ.GRAB_STAT.f.GRAB_PENDING);
		printf("Grab Exposure    = %d\n",   rXGSptr.ACQ.GRAB_STAT.f.GRAB_EXPOSURE);
		printf("Grab Readout     = %d\n",   rXGSptr.ACQ.GRAB_STAT.f.GRAB_READOUT);
		printf("Grab FOT         = %d\n",   rXGSptr.ACQ.GRAB_STAT.f.GRAB_FOT);
		printf("GRAB_MNGR_STATE  = 0x%x\n", rXGSptr.ACQ.GRAB_STAT.f.GRAB_MNGR_STAT);
		printf("TIMER_MNGR_STATE = 0x%x\n", rXGSptr.ACQ.GRAB_STAT.f.TIMER_MNGR_STAT);
		printf("TRIG_MNGR_STATE  = 0x%x\n", rXGSptr.ACQ.GRAB_STAT.f.TRIG_MNGR_STAT);
		printf("Grab TRIG RDY    = %d\n\n", rXGSptr.ACQ.GRAB_STAT.f.TRIGGER_RDY);
		printf("SPI FIFO_EMPTY   = %d\n\n", rXGSptr.ACQ.ACQ_SER_STAT.f.SER_FIFO_EMPTY);
		printf("ABORT_DONE       = %d\n\n", rXGSptr.ACQ.GRAB_STAT.f.ABORT_DONE);
		printf("ABORT_PET        = %d\n\n", rXGSptr.ACQ.GRAB_STAT.f.ABORT_PET);
		printf("ABORT_DELAI      = %d\n\n", rXGSptr.ACQ.GRAB_STAT.f.ABORT_DELAI);

		return(0);
		_getch();

	}

	else
		return(1);

}



//----------------------------------------------------
//  GRAB CMD
//----------------------------------------------------
void CXGS_Ctrl::SetGrabCMD(unsigned long Throttling, int DoSleep)
{

	M_UINT32 loop_nb = 0;
	M_UINT32 max_iter = 0xffffff;

	while (rXGSptr.ACQ.GRAB_STAT.f.GRAB_PENDING == 1)
	{
		if (loop_nb == max_iter)
		{
			printf("\n\nERROR : GRAB_PENDING TIMEOUT ! in proccess Camera->SetGrabCMD(void) \n");
			//PrintFPGAGrabLogicState();
			break;
		}
		loop_nb++;
		if (DoSleep == 1) Sleep(1); // This Sleep will decrease CPU usage but also decrease max framerate !!!!
	}

	if (loop_nb != max_iter)
	{

		SetGrabParams(Throttling);
		
		sXGSptr.ACQ.GRAB_CTRL.f.GRAB_CMD = 1;
		rXGSptr.ACQ.GRAB_CTRL.u32        = sXGSptr.ACQ.GRAB_CTRL.u32;
		sXGSptr.ACQ.GRAB_CTRL.f.GRAB_CMD = 0;

	}
}



//----------------------------------------------------
//  Set GRAB PARAMS
//----------------------------------------------------
void CXGS_Ctrl::SetGrabParams(unsigned long Throttling)
{

	//int nbLVDS = getLVDS_ch_used();

	int SubBinX = 1;
	int SubBinY = 1;

	
	sXGSptr.ACQ.SENSOR_ROI_Y_START.f.Y_START = GrabParams.Y_START;
	rXGSptr.ACQ.SENSOR_ROI_Y_START.u32 = sXGSptr.ACQ.SENSOR_ROI_Y_START.u32;
	
	sXGSptr.ACQ.SENSOR_ROI2_Y_SIZE.f.Y_SIZE  = GrabParams.Y_END - GrabParams.Y_START;
	rXGSptr.ACQ.SENSOR_ROI2_Y_SIZE.u32 = sXGSptr.ACQ.SENSOR_ROI2_Y_SIZE.u32;

	if (sXGSptr.ACQ.GRAB_CTRL.f.GRAB_ROI2_EN == 1)
	{
		sXGSptr.ACQ.SENSOR_ROI2_Y_START.f.Y_START = GrabParams.Y_START_ROI2;
		rXGSptr.ACQ.SENSOR_ROI2_Y_START.u32 = sXGSptr.ACQ.SENSOR_ROI2_Y_START.u32;

		sXGSptr.ACQ.SENSOR_ROI2_Y_SIZE.f.Y_SIZE   = GrabParams.Y_END_ROI2 - GrabParams.Y_START_ROI2;	
		rXGSptr.ACQ.SENSOR_ROI2_Y_SIZE.u32 = sXGSptr.ACQ.SENSOR_ROI2_Y_SIZE.u32;
	}
	
	sXGSptr.ACQ.EXP_CTRL1.f.EXPOSURE_SS       = GrabParams.Exposure;
	sXGSptr.ACQ.EXP_CTRL1.f.EXPOSURE_LEV_MODE = GrabParams.EXPOSURE_LEV_MODE;
	rXGSptr.ACQ.EXP_CTRL1.u32                 = sXGSptr.ACQ.EXP_CTRL1.u32;

	sXGSptr.ACQ.TRIGGER_DELAY.f.TRIGGER_DELAY = GrabParams.TRIGGER_DELAY;
	rXGSptr.ACQ.TRIGGER_DELAY.u32             = sXGSptr.ACQ.TRIGGER_DELAY.u32;

	sXGSptr.ACQ.STROBE_CTRL2.f.STROBE_END     = GrabParams.STROBE_END;
	sXGSptr.ACQ.STROBE_CTRL2.f.STROBE_MODE    = GrabParams.STROBE_MODE;
	rXGSptr.ACQ.STROBE_CTRL2.u32 = sXGSptr.ACQ.STROBE_CTRL2.u32;

	sXGSptr.ACQ.STROBE_CTRL1.f.STROBE_START   = GrabParams.STROBE_START;
	sXGSptr.ACQ.STROBE_CTRL1.f.STROBE_E       = GrabParams.STROBE_E;
	rXGSptr.ACQ.STROBE_CTRL1.u32 = sXGSptr.ACQ.STROBE_CTRL1.u32;

	//sDMA.GRAB_INIT_ADDR.u32 = GrabParams.FrameStart & 0xffffffff;                   // Lo DW ADD64
	//rDMA.GRAB_INIT_ADDR.u32 = sDMA.GRAB_INIT_ADDR.u32;
	//
	//sDMA.GRAB_INIT_ADDR_HI.u32 = (GrabParams.FrameStart & 0xffffffff00000000) >> 32;   // Hi DW ADD64
	//rDMA.GRAB_INIT_ADDR_HI.u32 = sDMA.GRAB_INIT_ADDR_HI.u32;
	//
	//sDMA.GRAB_GREEN_ADDR.u32 = GrabParams.FrameStartG & 0xffffffff;                   // Lo DW ADD64
	//rDMA.GRAB_GREEN_ADDR.u32 = sDMA.GRAB_GREEN_ADDR.u32;
	//
	//sDMA.GRAB_GREEN_ADDR_HI.u32 = (GrabParams.FrameStartG & 0xffffffff00000000) >> 32;   // Hi DW ADD64
	//rDMA.GRAB_GREEN_ADDR_HI.u32 = sDMA.GRAB_GREEN_ADDR_HI.u32;
	//
	//sDMA.GRAB_RED_ADDR.u32 = GrabParams.FrameStartR & 0xffffffff;                   // Lo DW ADD64
	//rDMA.GRAB_RED_ADDR.u32 = sDMA.GRAB_RED_ADDR.u32;
	//
	//sDMA.GRAB_RED_ADDR_HI.u32 = (GrabParams.FrameStartR & 0xffffffff00000000) >> 32;   // Hi DW ADD64
	//rDMA.GRAB_RED_ADDR_HI.u32 = sDMA.GRAB_RED_ADDR_HI.u32;
	//
	//sDMA.GRAB_LINE_PITCH.u32 = GrabParams.LinePitch;
	//rDMA.GRAB_LINE_PITCH.u32 = sDMA.GRAB_LINE_PITCH.u32;
	//
	//sDMA.GRAB_CSC.f.COLOR_SPACE = GrabParams.COLOR_SPACE;
	//sDMA.GRAB_CSC.f.GRAB_REVX = GrabParams.REVERSE_X;
	//sDMA.GRAB_CSC.f.MONO10 = GrabParams.MONO10;
	//rDMA.GRAB_CSC.u32 = sDMA.GRAB_CSC.u32;


	// A implementer plus tard
	//sXGSptr.ACQ.SENSOR_BLACK_CAL.f.BLACK_OFFSET = GrabParams.BLACK_OFFSET;
	//rXGSptr.ACQ.SENSOR_BLACK_CAL.u32 = sXGSptr.ACQ.SENSOR_BLACK_CAL.u32;

	sXGSptr.ACQ.SENSOR_GAIN_ANA.f.ANALOG_GAIN = GrabParams.ANALOG_GAIN;
	rXGSptr.ACQ.SENSOR_GAIN_ANA.u32 = sXGSptr.ACQ.SENSOR_GAIN_ANA.u32;

	//sDMA.GRAB_CSC.f.REVERSE_Y = GrabParams.REVERSE_Y;

	sXGSptr.ACQ.SENSOR_SUBSAMPLING.f.M_SUBSAMPLING_Y      = GrabParams.M_SUBSAMPLING_Y;
	sXGSptr.ACQ.SENSOR_SUBSAMPLING.f.ACTIVE_SUBSAMPLING_Y = GrabParams.ACTIVE_SUBSAMPLING_Y;
	sXGSptr.ACQ.SENSOR_SUBSAMPLING.f.SUBSAMPLING_X        = GrabParams.SUBSAMPLING_X;
	rXGSptr.ACQ.SENSOR_SUBSAMPLING.u32 = sXGSptr.ACQ.SENSOR_SUBSAMPLING.u32;

	//rXGSptr.ACQ.GRAB_CTRL.f.BUFFER_ID                     = GrabParams.GRAB_BUFFER_ID;
	sXGSptr.ACQ.GRAB_CTRL.f.TRIGGER_ACT                   = GrabParams.TRIGGER_ACT;
	sXGSptr.ACQ.GRAB_CTRL.f.TRIGGER_SRC                   = GrabParams.TRIGGER_SRC;
	sXGSptr.ACQ.GRAB_CTRL.f.TRIGGER_OVERLAP               = GrabParams.TRIGGER_OVERLAP;
	sXGSptr.ACQ.GRAB_CTRL.f.TRIGGER_OVERLAP_BUFFN         = GrabParams.TRIGGER_OVERLAP_BUFFN;
	rXGSptr.ACQ.GRAB_CTRL.u32                             = sXGSptr.ACQ.GRAB_CTRL.u32;
}

