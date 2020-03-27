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




CXGS_Ctrl::CXGS_Ctrl(volatile FPGA_REGFILE_XGS_CTRL_TYPE& i_rXGSptr, double setSysPer, double setSensorPer):
	rXGSptr(i_rXGSptr)
{

	SystemPeriodNanoSecond = setSysPer;
	SensorPeriodNanoSecond = setSensorPer;

	memset(&sXGSptr, 0, sizeof(sXGSptr));
	memcpy(&sXGSptr, (const void*)& rXGSptr, sizeof(sXGSptr));

}


CXGS_Ctrl::~CXGS_Ctrl()
{


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

	// Code NO OK
	//sXGSptr.ACQ.ACQ_SER_ADDATA.u32 = (address & 0x7fff) + ((data & 0xffff) << 16); 
	//rXGSptr.ACQ.ACQ_SER_ADDATA.u32 = sXGSptr.ACQ.ACQ_SER_ADDATA.u32;               // Set address and data to write in sensor

	//rXGSptr.ACQ.ACQ_SER_CTRL.f.SER_CMD   = 0x0;                                   // Sensor access type
	//rXGSptr.ACQ.ACQ_SER_CTRL.f.SER_RWN   = 0x0;                                   // Write access  
	//rXGSptr.ACQ.ACQ_SER_CTRL.f.SER_WF_SS = 0x1;                                   // Write the command to the queue fifo
	//Sleep(100);
	//rXGSptr.ACQ.ACQ_SER_CTRL.f.SER_RF_SS = 0x1;                                   // Write the command to the queue fifo
	

	//CODE OK
	sXGSptr.ACQ.ACQ_SER_ADDATA.u32 = (address & 0x7fff) + ((data & 0xffff) << 16);
	rXGSptr.ACQ.ACQ_SER_ADDATA.u32 = sXGSptr.ACQ.ACQ_SER_ADDATA.u32;               // Set address and data to write in sensor
	rXGSptr.ACQ.ACQ_SER_CTRL.u32 = 0x00000;
	rXGSptr.ACQ.ACQ_SER_CTRL.u32 = 0x00001;
	Sleep(100);
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

	//CODE NO OK
	//sXGSptr.ACQ.ACQ_SER_ADDATA.u32 = (address & 0x7fff) ;
	//rXGSptr.ACQ.ACQ_SER_ADDATA.u32 = sXGSptr.ACQ.ACQ_SER_ADDATA.u32;               // Set address and data to write in sensor
	//
	//rXGSptr.ACQ.ACQ_SER_CTRL.f.SER_CMD   = 0x0;                                    // Sensor access type
	//rXGSptr.ACQ.ACQ_SER_CTRL.f.SER_RWN   = 0x1;                                    // Write access  
	//rXGSptr.ACQ.ACQ_SER_CTRL.f.SER_WF_SS = 0x1;                                    // Write the command to the queue fifo
	//
	////rXGSptr.ACQ.ACQ_SER_CTRL.f.SER_RF_SS = 0x1;                                   // Write the command to the queue fifo
	//Sleep(100);
	//rXGSptr.ACQ.ACQ_SER_CTRL.u32 = 0x10010;
	

	//CODE OK
	sXGSptr.ACQ.ACQ_SER_ADDATA.u32 = (address & 0x7fff);
	rXGSptr.ACQ.ACQ_SER_ADDATA.u32 = sXGSptr.ACQ.ACQ_SER_ADDATA.u32;               // Set address and data to write in sensor
	rXGSptr.ACQ.ACQ_SER_CTRL.u32 = 0x10000;
	rXGSptr.ACQ.ACQ_SER_CTRL.u32 = 0x10001;
	Sleep(100);
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
		rXGSptr.ACQ.SENSOR_CTRL.f.SENSOR_POWERDOWN = 1;

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
	rXGSptr.ACQ.SENSOR_CTRL.f.SENSOR_RESETN = 1; //reset is controlled by the state machine, this field is to overwrite if needed
	rXGSptr.ACQ.SENSOR_CTRL.f.SENSOR_POWERUP = 1;
	
	// Wait for done
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
	
	


	if (DataRead == 0x0358) 
		printf("XGS Model ID detected is 0x358, XGS5M");

	if (DataRead == 0x0058) {
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
	} 

	

	Initialize_sensor();             // Wait until the sensor is ready to receive register writes 
	Check_otpm_depended_uploads();   // OTM write
	//Enable6lanes();                  
	Enable24lanes();

	Activate_sensor(); 

	// Program monitor pins in XGS
	M_UINT32 monitor_0_reg = 0x6;    // 0x6 : Real Integration  , 0x2 : Integrate
	M_UINT32 monitor_1_reg = 0x10;   // EFOT indication
	M_UINT32 monitor_2_reg = 0x1;    // New_line
	WriteSPI(0x3806, (monitor_2_reg<<10) + (monitor_1_reg<<5) + monitor_0_reg );    // Monitor Lines

	// Copy some "mirror" registers from Sensor to FPGA
	rXGSptr.ACQ.SENSOR_GAIN_ANA.u32        = ReadSPI(0x3844);   //Analog Gain
	rXGSptr.ACQ.SENSOR_SUBSAMPLING.u32     = ReadSPI(0x383c);   //Subsampling
	rXGSptr.ACQ.SENSOR_M_LINES.u32         = ReadSPI(0x389a);   //M_LINES cntx(0)
	rXGSptr.ACQ.SENSOR_F_LINES.u32         = ReadSPI(0x389C);   //F_LINES cntx(0)
	rXGSptr.ACQ.READOUT_CFG3.f.LINE_TIME   = ReadSPI(0x3810);   //LINETIME


	M_UINT32 EXP_FOT_TIME     = 5360;  //5.36us calculated from start of FOT to end of real exposure in dev board
	
	//Enable EXP during FOT
	rXGSptr.ACQ.EXP_FOT.f.EXP_FOT_TIME = (M_UINT32) ((double)EXP_FOT_TIME / SystemPeriodNanoSecond);
	rXGSptr.ACQ.EXP_FOT.f.EXP_FOT      = 1;

	//Trigger KeepOut zone
	rXGSptr.ACQ.READOUT_CFG4.f.KEEP_OUT_TRIG_START = (M_UINT32)(double((rXGSptr.ACQ.READOUT_CFG3.f.LINE_TIME * SensorPeriodNanoSecond) - 100) / SystemPeriodNanoSecond);   //START Keepout trigger zone (100ns)
	rXGSptr.ACQ.READOUT_CFG4.f.KEEP_OUT_TRIG_END   = (M_UINT32)(double( rXGSptr.ACQ.READOUT_CFG3.f.LINE_TIME * SensorPeriodNanoSecond) / SystemPeriodNanoSecond);           //END   Keepout trigger zone (100ns), this is more for testing, monitor will reset the counter 
	rXGSptr.ACQ.READOUT_CFG3.f.KEEP_OUT_TRIG_ENA   = 1;

    // Give SPI control to XGS controller   : SENSOR REG_UPDATE =1 
	rXGSptr.ACQ.SENSOR_CTRL.f.SENSOR_REG_UPTATE = 1;


}


//-----------------------------------------
// PowerUp and wait until Sensor is rdy
//-----------------------------------------
void CXGS_Ctrl::Initialize_sensor() {

	//	Wait until the sensor is ready to receive register writes: (REG 0x3706[3:0] = 0x3) : POLL_REG = 0x3706, 0x000F, != 0x3, DELAY = 25, TIMEOUT = 500
	PollRegSPI(0x3706, 0xF, 0x3, 25, 40);
	
}



//-----------------------------------------
// Check if need to optimize XGS register
//-----------------------------------------
void CXGS_Ctrl::Check_otpm_depended_uploads() {

	// Checking the version of OTPM and uploading settings accordingly, reg 0x3700[5] needs to be enabled to read the OTPM version
	// apbase.log("Checking OTPM version (enable register 0x3700[5] = 1) -. reg 0x3016[3:0]")
	WriteSPI(0x3700, 0x0020);
	Sleep(50);
	//otpmversion = reg.reg(0x3016).bitfield(0xF).uncached_value
	M_UINT32 otpmversion = ReadSPI(0x3016);
	printf("XGS OTPM version : 0x%X\n", otpmversion);
	WriteSPI(0x3700, 0x0000);

	if (otpmversion == 0) {

		printf("\n\nL version otpmversion devrait etre a 1 avec ce senseur!\n\n");
		exit(1);

		//apbase.log("Loading required register uploads")
		//apbase.load_preset("Req_Reg_Up")
		printf("XGS Loading required register uploads\n");
		WriteSPI(0x3428, 0xA620);
		WriteSPI(0x342A, 0x0000);
		WriteSPI(0x3430, 0x20B6);
		WriteSPI(0x3842, 0x0000);

		WriteSPI(0x38E2, 0x0000);

		WriteSPI(0x38E4, 0x0019);
		WriteSPI(0x38E6, 0x0019);
		WriteSPI(0x38E8, 0x0019);

		WriteSPI(0x3934, 0x0108);
		WriteSPI(0x3938, 0x0108);
		WriteSPI(0x393C, 0x0108);

		WriteSPI(0x3992, 0x0001);

		WriteSPI(0x389A, 0x0802); //M-lines

		WriteSPI(0x38EA, 0x003E);
		WriteSPI(0x38EC, 0x003E);
		WriteSPI(0x38EE, 0x003E);

		WriteSPI(0x38CA, 0x0707);
		WriteSPI(0x38CC, 0x0007);

		//apbase.log("Loading timing uploads")
		//apbase.load_preset("FSM_Up")
		//REG_BURST = 0x4000, ...
		printf("XGS Loading timing uploads\n");
		M_UINT32 REG_BURST1[500] = { 0x4000, 0x0001, 0x817C, 0x0012, 0xA97C, 0x000F, 0xA97C, 0x000C, 0xA97C, 0x0001, 0x817C, 0x501F, 0x817C, 0x501F, 0x817C, 0x5017, 0x817C, 0x500F, 0x817C, 0x5A01, 0x817C, 0x5F02, 0x817C, 0x5A01, 0x817C, 0x501F, 0x817C, 0x501F, 0x817C, 0x501F, 0x817C, 0x501F, 0x817C, 0x501F, 0x817C, 0x5015, 0x817C, 0x500F, 0x817C, 0x500F, 0x817C, 0x5001, 0x817C, 0x5502, 0x817C, 0x501A, 0x817C, 0x5008, 0x817C, 0x5000, 0x817C , 0xcafefade };
		M_UINT32 REG_BURST2[500] = { 0x4064, 0x5021, 0x0071, 0x5022, 0x007d, 0x5a21, 0x007d, 0x5f22, 0x007d, 0x5a21, 0x007d, 0x5034, 0x007d, 0x502f, 0x007d, 0x5027, 0x007d, 0x5021, 0x007d, 0x5522, 0x007d, 0x5021, 0x007d, 0x5022, 0x007d, 0x5031, 0x0071, 0x502f, 0x0071, 0x5022, 0x0071, 0x0021, 0x0071, 0x0031, 0x5071, 0x002f, 0x5071, 0x0023, 0x5071, 0x0021, 0x0071, 0xa032, 0x0071, 0xa02b, 0x0071, 0x2021, 0x0071, 0x200f, 0x2071, 0x200a, 0x2071, 0x2001, 0x0071, 0x600b, 0x0071, 0x4001, 0x0071, 0x400f, 0x0871, 0x400a, 0x0871, 0x4001, 0x0071, 0x501f, 0x0071, 0x501b, 0x0071, 0x500f, 0x0071, 0x5001, 0x0070, 0x5001, 0x0072, 0x5000, 0x0072, 0xcafefade };
		M_UINT32 REG_BURST3[500] = { 0x40F8, 0x5001, 0x0072, 0x501A, 0x0072, 0x500D, 0x0072, 0x5001, 0x0070, 0x5032, 0x00F0, 0x5021, 0x00F0, 0x5021, 0x0070, 0x5020, 0x0071, 0xcafefade };
		M_UINT32 REG_BURST4[500] = { 0x4118, 0x5011, 0x0072, 0x500f, 0x0072, 0x500c, 0x0072, 0x501a, 0x0072, 0x500d, 0x0072, 0x5001, 0x0070, 0x5032, 0x00f0, 0x5021, 0x00f0, 0x5021, 0x0070, 0x5020, 0x0071, 0xcafefade };
		M_UINT32 REG_BURST5[500] = { 0x4140, 0x501A, 0x0072, 0x500B, 0x0072, 0x501A, 0x0072, 0x500D, 0x0072, 0x5001, 0x0070, 0x5032, 0x00F0, 0x5021, 0x00f0, 0x5021, 0x0070, 0x5020, 0x0071, 0xcafefade };
		M_UINT32 REG_BURST6[500] = { 0x4164, 0x501F, 0x0072, 0x501F, 0x0072, 0x5013, 0x0072, 0x5007, 0x0072, 0x501A, 0x0072, 0x500D, 0x0072, 0x5001, 0x0070, 0x5032, 0x00f0, 0x5021, 0x00F0, 0x5021, 0x0070, 0x5020, 0x0071, 0xcafefade };
		M_UINT32 REG_BURST7[500] = { 0x4190, 0x5012, 0x0072, 0x500f, 0x0072, 0x5008, 0x0072, 0x501a, 0x0072, 0x500d, 0x0072, 0x5001, 0x0070, 0x5032, 0x00f0, 0x5021, 0x00f0, 0x5021, 0x0070, 0x5020, 0x0071, 0xcafefade };

		WriteSPI_BURST(REG_BURST1);
		WriteSPI_BURST(REG_BURST2);
		WriteSPI_BURST(REG_BURST3);
		WriteSPI_BURST(REG_BURST4);
		WriteSPI_BURST(REG_BURST5);
		WriteSPI_BURST(REG_BURST6);
		WriteSPI_BURST(REG_BURST7);
		
		//apbase.load_preset("LSM_Up")
		//No updates required as the default values are good
		printf("XGS Loading LSM_Up, No updates required as the default values are good\n");


		//apbase.load_preset("ALSM_Up")
		printf("XGS Loading ALSM_Up\n");
		M_UINT32 REG_BURST8[500] = { 0x6420, 0x0002, 0x001c, 0x0001, 0x0000, 0x0004, 0x0160, 0x0041, 0x0160, 0x0042, 0x0160, 0x0043, 0x0160, 0x0042, 0x0060, 0x0042, 0x1060, 0x0001, 0x1060, 0x0001, 0x9060, 0x0002, 0x9060, 0x0006, 0x9060, 0x0081, 0x9060, 0x0081, 0x1060, 0x0022, 0x1060, 0x0028, 0x1060, 0x0001, 0x1020, 0x0001, 0x1000, 0x2001, 0x1000, 0x0002, 0x1000, 0x0008, 0x1200, 0x0003, 0x1000, 0x0002, 0x1004, 0x0001, 0x5000, 0xc001, 0x5002, 0xe001, 0x5002, 0xc001, 0x7002, 0x8001, 0x5002, 0x8001, 0x5002, 0x8901, 0x5002, 0xbe01, 0x5002, 0x8001, 0x7002, 0xc001, 0x5002, 0x4001, 0x5002, 0x4901, 0x5002, 0x7e01, 0x5002, 0x4001, 0x7002, 0x0001, 0x5002, 0x0001, 0x5002, 0x0901, 0x5002, 0x3e01, 0x5002, 0x0001, 0x7002, 0x4001, 0x5002, 0xc001, 0x5001, 0xc901, 0x5001, 0xfe01, 0x5001, 0xc001, 0x7001, 0x8001, 0x5001, 0x8001, 0x5001, 0x8901, 0x5001, 0xbe01, 0x5001, 0x8001, 0x7001, 0xc001, 0x5001, 0x4001, 0x5001, 0x4901, 0x5001, 0x7e01, 0x5001, 0x4001, 0x7001, 0x0001, 0x5001, 0x0001, 0x5001, 0x0901, 0x5001, 0x3e01, 0x5001, 0x0001, 0x7001, 0x4001, 0x5001, 0xc001, 0x5000, 0xc901, 0x5000, 0xfe01, 0x5000, 0xc001, 0x7000, 0x8001, 0x5000, 0x8001, 0x5000, 0x8901, 0x5000, 0x9e01, 0x5000, 0x8002, 0x5000, 0x0001, 0x1000, 0x0001, 0x100c, 0x0001, 0x106c, 0x001f, 0x1060, 0x0005, 0x1060, 0x0001, 0x1020, 0x0005, 0x1000, 0x8001, 0x5003, 0xa001, 0x1003, 0x8001, 0x1003, 0x8001, 0x1003, 0xc001, 0x1003, 0xc001, 0x3003, 0xc001, 0x1003, 0x4001, 0x1003, 0x4801, 0x1003, 0x4901, 0x1003, 0x7e01, 0x1003, 0x4001, 0x1003, 0x4001, 0x1003, 0x4001, 0x1003, 0x0001, 0x3003, 0x0001, 0x1003, 0x0001, 0x1003, 0x0801, 0x1003, 0x0901, 0x1003, 0x3e01, 0x1003, 0x0001, 0x3003, 0x4001, 0x1003, 0xc001, 0x1002, 0xc801, 0x1002, 0xc901, 0x1002, 0xfe01, 0x1002, 0xc001, 0x3002, 0x8001, 0x1002, 0x8001, 0x1002, 0x8801, 0x1002, 0x8901, 0x1002, 0xbe01, 0x1002, 0x8001, 0x3002, 0xc001, 0x1002, 0x4001, 0x1002, 0x4901, 0x1002, 0x7e01, 0x1002, 0x4001, 0x3002, 0x0001, 0x1002, 0x0001, 0x1002, 0x0901, 0x1002, 0x3e01, 0x1002, 0x0001, 0x3002, 0x4001, 0x1002, 0xc001, 0x1001, 0xc901, 0x1001, 0xfe01, 0x1001, 0xc001, 0x3001, 0x8001, 0x1001, 0x8001, 0x1001, 0x8901, 0x1001, 0xbe01, 0x1001, 0x8001, 0x3001, 0xc001, 0x1001, 0x4001, 0x1001, 0x4901, 0x1001, 0x7e01, 0x1001, 0x4001, 0x3001, 0x0001, 0x1001, 0x0001, 0x1001, 0x0901, 0x1001, 0x3e01, 0x1001, 0x0001, 0x3001, 0x4001, 0x1001, 0xc001, 0x1000, 0xc901, 0x1000, 0xfe01, 0x1000, 0xc001, 0x3000, 0x8001, 0x1000, 0x8001, 0x1000, 0x8901, 0x1000, 0x9e01, 0x1000, 0x8001, 0x1000, 0x0001, 0x1000, 0x0000, 0x1000, 0xcafefade };
		WriteSPI_BURST(REG_BURST8);

	}
	if (otpmversion != 0) {
		printf("No timing uploads necessary for OTPM version: 0x%X\n", otpmversion);
		printf("Loading required register uploads\n");

		//apbase.load_preset("Req_Reg_Up_1")
		//Section Req_Reg_Up_1:
		WriteSPI(0x38EA, 0x003E);
		WriteSPI(0x38EC, 0x003E);
		WriteSPI(0x38EE, 0x003E);

		WriteSPI(0x38CA, 0x0707);
		WriteSPI(0x38CC, 0x0007);
		WriteSPI(0x389A, 0x0C03); //M-lines 3-3
	}
}


//----------------------------------------------------
// This fonction load specific registers for MUX mode
//----------------------------------------------------
void CXGS_Ctrl::Enable6lanes(void) {

	// mux mode dependent uploads
	// Loading 6 lanes 12 bit specific settings
	WriteSPI(0x38C4, 0x0600);

	WriteSPI(0x3A00, 0x000D);
	WriteSPI(0x3A02, 0x0001);

	WriteSPI(0x3E00, 0x0001);
	WriteSPI(0x3E28, 0x2537);
	WriteSPI(0x3E80, 0x000D);

	WriteSPI(0x3810, 0x02DC); // minimum line time
  
    // Not used in slave mode:
	//LOG = Setting framerate to 28FPS
	//REG = 0x383A, 0x0C58
	//LOG = Setting 5ms exposure time
	//REG = 0x3840, 0x01ba
	//REG = 0x3842, 0x01c4

}

void CXGS_Ctrl::Enable24lanes(void) {

	// Loading 24 lanes 12 bit specific settings
	WriteSPI(0x38C4, 0x1300);

	WriteSPI(0x3A00, 0x000A);
	WriteSPI(0x3A02, 0x0001);

	WriteSPI(0x3E00, 0x0008);
	WriteSPI(0x3E28, 0x2507);
	WriteSPI(0x3E80, 0x0001);

	WriteSPI(0x3810, 0x00E6); // minimum line time

	//LOG = Setting framerate to 90FPS
	WriteSPI(0x383A, 0x0C3A);

	//LOG = Setting 5ms exposure time
	WriteSPI(0x3840, 0x0580);
	WriteSPI(0x3842, 0x009c);
}

//----------------------
// Activating sensor
//----------------------
void CXGS_Ctrl::Activate_sensor() {
	M_UINT32 read;

	// Enable PLL and Analog blocks: REG = 0x3700, 0x001c
	WriteSPI(0x3700, 0x001c);

	printf("POlling for innitialisation complete\n");

	// Check if initialization is complete (REG 0x3706[7:0] = 0xEB): POLL_REG = 0x3706, 0x00FF, != 0xEB, DELAY = 25, TIMEOUT = 500
	PollRegSPI(0x3706, 0x00FF, 0xEB, 25, 40);


	// Slave mode + Trigger mode
	M_UINT32 GeneralConfig0 = ReadSPI(0x3800);   
	WriteSPI(0x3800, GeneralConfig0 | 0x30); 

	//Enable sequencer : BITFIELD = 0x3800, 0x0001, 1
	WriteSPI_Bit(0x3800, 0, 1);

	read = ReadSPI(0x3800);
	if (read == 0x31)
		printf("XGS sequencer enable!!!\n\n\n");
	
	//on arrete ici pour le moment
	exit(1);
}