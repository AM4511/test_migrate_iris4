//-----------------------------------------------
//
//  This is the main function. 
//
//
//  To COMPILE THIS CODE FOR XP:
//  IRIS3->Properties->Configuration Properties->General->Platform toolset -> Visual Studio 2013 - Windows XP (v120_xp)
//
//  Others:
//  IRIS3->Properties->Configuration Properties->General->Platform toolset -> Visual Studio 2013 (v120)
//
//-----------------------------------------------

/* Headers */
#include <stdio.h> 
#include <stdlib.h> 

#include "stdafx.h"
#include <conio.h> 
#include <time.h>

#include <Windows.h>

#include "XGS_Ctrl.h"
#include "I2C.h"
#include "SystemTree.h" 
#include "MilLayer.h"

/* Main function. */
int main(void)
{
	M_UINT32 DevID= 0x1514;
	int sortie = 0;
	char ch;
	//int answer;

	M_UINT32 SPI_START;
	M_UINT32 SPI_END;

	M_UINT32 address;
	M_UINT32 data;
	M_UINT32 I2C_readdata;

	//------------------------------
	// Init ATHENA FPGAs, Regfile
	//------------------------------
	Struck_FPGAs FPGAs[16];
	Struck_FPGAs FPGAsTemp[16];

	int FPGA_used = 0;
	int NBiter = 1;
	int PD_Head = 1;

	// IRISx
	int nbFPGA = FindMultiFpga(0x102b, DevID, FPGAs);                 // Lets get the Bar0 address of the Iris FPGA
	
	if (nbFPGA == 0)
	{
		printf("Impossible to find Athena!!!\n");
		int i =_getch();
		return(1);
	}
	else
		if (nbFPGA == 1)
		{
			FPGA_used = 1;
		}
		else { FPGA_used = 1;  } //prendre le premier par defaut

	M_UINT64 fpga_bar0_add = FPGAs[FPGA_used - 1].PhyRefReg_BAR0;
	M_UINT64 fpga_bar1_add = FPGAs[FPGA_used - 1].PhyRefReg_BAR1;
	M_UINT64 fpga_bar2_add = FPGAs[FPGA_used - 1].PhyRefReg_BAR2;

	MilLayerAlloc();
	unsigned char* XGS_regptr   = getMilLayerRegisterPtr(fpga_bar0_add+0x00000);   // Lets put a pointer to the FPGA XGS ctrl
	unsigned char* I2C_regptr   = getMilLayerRegisterPtr(fpga_bar0_add+0x10000);   // Lets put a pointer to the FPGA I2C

	int PCIe_config = MultiFpgaPCIeConfig(FPGA_used - 1, FPGAs);

	printf("\n\nATHENA   %X.%X  BAR0=0x%08x,  BAR1=0x%08x \n", FPGAs[FPGA_used - 1].DevID, FPGAs[FPGA_used - 1].SubsystemID, FPGAs[FPGA_used - 1].PhyRefReg_BAR0, FPGAs[FPGA_used - 1].PhyRefReg_BAR1);

	//------------------------------
	// Program Maio PCIe window 0
	//------------------------------
	MIL_ID MilRegBuf1;
	volatile M_UINT32* RegPtr_bar1;

	MbufCreate2d(
		M_DEFAULT_HOST,
		1000,
		1,
		8 + M_UNSIGNED,
		M_IMAGE + M_MMX_ENABLED,
		M_PHYSICAL_ADDRESS,
		1000,
		(void**)fpga_bar1_add,
		&MilRegBuf1
	);

	RegPtr_bar1 = (M_UINT32*)MbufInquire(MilRegBuf1, M_HOST_ADDRESS, M_NULL);

	printf("\n\nMaio ID is 0x%X, programming PCIe Window0 \n", *RegPtr_bar1 + (0x000 / 4));
	*(RegPtr_bar1 + (0x100 / 4)) = 0x0;         //pci_bar0_disable 
	*(RegPtr_bar1 + (0x104 / 4)) = 0x0;         //pci_bar0_start
	*(RegPtr_bar1 + (0x108 / 4)) = 0x20000;     //pci_bar0_End (8k)
	*(RegPtr_bar1 + (0x10c / 4)) = 0x40000000;  //pci_bar0_size 
	*(RegPtr_bar1 + (0x100 / 4)) = 0x1;         //pci_bar0_enable

	



	//Init class XGS CONTROLLER
	CXGS_Ctrl* XGS_Ctrl = new CXGS_Ctrl(XGS_regptr, 16.000000, 15.432099);
    volatile FPGA_REGFILE_XGS_CTRL_TYPE* rXGSptr = XGS_Ctrl->getRegisterXGS_Ctrl();
	printf("\nXGS Controller Static_ID : 0x%X\n", rXGSptr->SYSTEM.ID.f.STATICID);


	//Init class I2C CONTROLLER
	CI2C* I2C = new CI2C(I2C_regptr);
	volatile FPGA_REGFILE_I2C_TYPE*      rI2Cptr = I2C->getRegisterI2C();
	printf("\nI2C Controller Static_ID : 0x%X\n\n", rI2Cptr->I2C.I2C_ID.u32);


/*
	//--------------------------------------------
    // TEST D'acces I2C vers EPROM I2c DU 7C706
    //--------------------------------------------
	//test de ecriture lecture du Eprom I2C  sur 7C706 (M24c08, U9)
	I2C->Write_i2c(0, 0x74, 1, 0, 0x04);  //enable channel 2  on mux translator : EPROM M24c08
	Sleep(200);

	//Write Eprom
	I2C->Write_i2c(0, 0x54, 0, 0, 0x0);  //write add=0
	Sleep(200);
	I2C->Write_i2c(0, 0x54, 0, 1, 0xc);  //write add=1
	Sleep(200);
	I2C->Write_i2c(0, 0x54, 0, 2, 0xa);  //write add=2
	Sleep(200);
	I2C->Write_i2c(0, 0x54, 0, 3, 0xf);  //write add=3
	Sleep(200);
	I2C->Write_i2c(0, 0x54, 0, 4, 0xe);  //write add=4
	Sleep(200);
	I2C->Write_i2c(0, 0x54, 0, 5, 0xf);  //write add=5
	Sleep(200);
	I2C->Write_i2c(0, 0x54, 0, 6, 0xa);  //write add=6
	Sleep(200);
	I2C->Write_i2c(0, 0x54, 0, 7, 0xd);  //write add=7
	Sleep(200);
	I2C->Write_i2c(0, 0x54, 0, 8, 0xe);  //write add=8 
	Sleep(200);
	I2C->Write_i2c(0, 0x54, 0, 0, 0x0);  //write add=0 <---- set the internal pointer to add=0+1
	Sleep(200);

	//Read Eprom
	for (int i = 0; i < 8; i++) {
		I2C_readdata = I2C->Read_i2c(0, 0x54, 1, 0, 0);  //read current internal pointer add
		Sleep(500);
		printf("\nI2C read from eprom : 0x%X\n", I2C_readdata);
		Sleep(100);
	}

*/

	//--------------------------------------------
	// Access I2C vers Xcelerator PCA9654E (0x20, 7 bits), ENABLE PMIC
	//--------------------------------------------
	I2C->Write_i2c(0, 0x74, 1, 0, 0x20);  // Enable channel 5 FMC HPC (non-index access)
	Sleep(200);

	//Is PMIC enable already?
	if (((I2C->Read_i2c(0, 0x20, 0, 3, 0) & 0x1) == 0) && ((I2C->Read_i2c(0, 0x20, 0, 0, 0) & 0x1) == 0x1) && ((I2C->Read_i2c(0, 0x20, 0, 0, 0) & 0x2) == 0x2)) {  // Si ioxpander bit0=output ET output0=1(HWEN) ET Input1=1 (PowerGood)
		printf("Xcerelator PMIC already enable, PowerDown PMIC, ");
		I2C->Write_i2c(0, 0x20, 0, 1, 0x0);              // Write add=1 (Write 1 to output0 : HWEN=0)
		
		while ( (I2C->Read_i2c(0, 0x20, 0, 0, 0) & 0x2) == 0x2) {  // Wait for Power Good from PMIC to be inactive
			I2C_readdata = I2C->Read_i2c(0, 0x20, 0, 0, 0);
			Sleep(100);
		}
		printf("Done. \n\n");
	}
	
	printf("Xcerelator PMIC Starting, ");
	I2C->Write_i2c(0, 0x20, 0, 3, 0xfe);             // Write add=3 (Configuration output : bit 0 is output now : HWEN to enable PMIC)
	Sleep(1);

	I2C->Write_i2c(0, 0x20, 0, 1, 0x1);              // Write add=1 (Write 1 to output0 : HWEN=1)
	Sleep(1);

	while ( (I2C->Read_i2c(0, 0x20, 0, 0, 0) & 0x2) == 0) {  // Wait for Power Good to be active from PMIC
		I2C_readdata = I2C->Read_i2c(0, 0x20, 0, 0, 0);  
		Sleep(10);
	}
	printf("Done. \n\n");

	//------------------------------
	// INITIALIZE XGS SENSOR
	//------------------------------
	XGS_Ctrl->InitXGS();





	//------------------------------
	//
	//  LOOP
	//
	//------------------------------
	while (sortie == 0)
	{

		if (_kbhit())
		{
			ch = _getch();
			switch (ch)
			{
			case 'q':
				sortie = 1;
				printf("\n\n");
				break;

			case 'd':
				printf("\nEnter Sensor starting address to Dump in hex : 0x");
				scanf_s("%x", &SPI_START);
				printf("\nEnter Sensor ending address to Dump in hex : 0x");
				scanf_s("%d", &SPI_END);
				printf("\n\n");
				XGS_Ctrl->DumpRegSPI(SPI_START, SPI_END);
				printf("\n\n");
				break;

			case 'D':
				XGS_Ctrl->ReadSPI_DumpFile();
				break;

			case 'w':
				printf("\nEnter Sensor address to Write in hex : 0x");
				scanf_s("%x", &address);
				printf("\nEnter Sensor data to Write in hex : 0x");
				scanf_s("%x", &data);
				printf("\n\n");
				XGS_Ctrl->WriteSPI(address, data);		
				printf("\n\n");
				break;
//
//			case 'p':
//				Iris3->PowerEnable();
//				printf("\n\n");
//				Help(Iris3);
//				break;
//
//			case 'e':
//				Iris3->EnablePython();
//				printf("\n\n");
//				// Help(Iris3);
//				break;
//
//			case 'r':
//				Iris3->DisablePython();
//				printf("\n\n");
//				Help(Iris3);
//				break;
//
//			case 's':
//				Iris3->PowerDisable();
//				printf("\n\n");
//				Help(Iris3);
//				break;
//
//
			}
		}//KBhit
	}//while

	printf("\n\nPress any key to exit");

	//if(Iris4!= NULL) delete Iris4;
	IrisMilFree();
	exit(0);






}  //main


