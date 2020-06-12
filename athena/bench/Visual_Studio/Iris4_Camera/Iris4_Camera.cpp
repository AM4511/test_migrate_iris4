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
#include "XGS_Data.h"
#include "Pcie.h"

#include "I2C.h"

#include "SystemTree.h" 
#include "MilLayer.h"



#define regfile_MAIO_ADD_OFFSET       0x00000000  //
#define regfile_XGS_ATHENA_ADD_OFFSET 0x00000000  //
#define regfile_I2C_ADD_OFFSET        0x00010000  //

void TestTLP2AXI(CXGS_Ctrl* XGS_Ctrl);

void Help(CXGS_Ctrl* Camera);
void test_0000_Continu(CXGS_Ctrl* XGS_Ctrl, CXGS_Data* XGS_Data);
void test_0001_SWtrig(CXGS_Ctrl* XGS_Ctrl, CXGS_Data* XGS_Data);
void test_0002_Continu_2xROI(CXGS_Ctrl* XGS_Ctrl, CXGS_Data* XGS_Data);
void test_0003_HW_Timer(CXGS_Ctrl* XGS_Ctrl, CXGS_Data* XGS_Data);

void test_0009_Optics(CXGS_Ctrl* XGS_Ctrl, CXGS_Data* XGS_Data);

/* Main function. */
int main(void)
{
	M_UINT32 DevID= 0x5054;
	int sortie = 0;
	char ch;
	//int answer;

	M_UINT32 SPI_START;
	M_UINT32 SPI_RANGE;

	M_UINT32 address;
	M_UINT32 data;

	//------------------------------
	// Init ATHENA FPGAs, Regfile
	//------------------------------
	Struck_FPGAs FPGAs[16];

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

    int PCIe_config = MultiFpgaPCIeConfig(FPGA_used - 1, FPGAs);

	printf("\n\nATHENA   %X.%X  BAR0=0x%08x,  BAR1=0x%08x \n", FPGAs[FPGA_used - 1].DevID, FPGAs[FPGA_used - 1].SubsystemID, FPGAs[FPGA_used - 1].PhyRefReg_BAR0, FPGAs[FPGA_used - 1].PhyRefReg_BAR1);


	//------------------------------
	// Init Global PCIe (Maio) REGISTER FILE
	//------------------------------
	volatile unsigned char* PCIe_regptr = getMilLayerRegisterPtr(0, fpga_bar1_add + regfile_MAIO_ADD_OFFSET);
	volatile FPGA_PCIE2AXIMASTER_TYPE& rPcie_ptr = (*(volatile FPGA_PCIE2AXIMASTER_TYPE*)(PCIe_regptr));

	//------------------------------
	// Init Global XGS Athena REGISTER FILE
	//------------------------------
	volatile unsigned char* XGS_Athena_regptr = getMilLayerRegisterPtr(1, fpga_bar0_add + regfile_XGS_ATHENA_ADD_OFFSET);   // Lets put a pointer to the FPGA XGS ctrl
	volatile FPGA_REGFILE_XGS_ATHENA_TYPE& rXGS_Athena_ptr = (*(volatile FPGA_REGFILE_XGS_ATHENA_TYPE*)(XGS_Athena_regptr));

	//------------------------------
	// Init I2C REGISTER FILE
	//------------------------------
	volatile unsigned char* I2C_regptr = getMilLayerRegisterPtr(2, fpga_bar0_add + regfile_I2C_ADD_OFFSET);       // Lets put a pointer to the FPGA I2C
	volatile FPGA_REGFILE_I2C_TYPE& rI2Cptr = (*(volatile FPGA_REGFILE_I2C_TYPE*)(I2C_regptr));


	//------------------------------
	// Init class 
	//------------------------------
	CPcie* Pcie;
	Pcie = new CPcie(rPcie_ptr);

	Pcie->InitBar0Window();

	//------------------------------
	// Init class XGS CONTROLLER
	//------------------------------
	CXGS_Ctrl *XGS_Ctrl;
	//XGS_Ctrl = new CXGS_Ctrl(rXGSptr, 16.000000, 15.432099); //32.4Mhz
	XGS_Ctrl = new CXGS_Ctrl(rXGS_Athena_ptr, 16.000000, 15.625);    //32Mhz

	//------------------------------
    // Init class XGS DATAPATH
    //------------------------------
	CXGS_Data* XGS_Data;
	XGS_Data = new CXGS_Data(rXGS_Athena_ptr);
	
	//------------------------------
	// Init class I2C CONTROLLER
	//------------------------------
	CI2C *I2C;
	I2C = new CI2C(rI2Cptr);



	//-----------------------------------------------------
    // If PCIe x1 detected, reduce Framerate of the sensor
    //-----------------------------------------------------
	if ((FPGAs[0].LinkStatusReg & 0xff0000) == 0x210000)
	{
		XGS_Ctrl->GrabParams.XGS_LINE_SIZE_FACTOR = 1;
		printf("\n");
		printf("------------------------------------------------------------------\n");
		printf(" XGS FRAMERATE IS AT NOMINAL SPEED, SINCE FPGA IS IN PCIe Gen1 x2 \n");
		printf("------------------------------------------------------------------\n");
		printf("\n");
	}
	else
	{

    	printf("------------------------------------------------------------------\n");
		printf(" Athena PCIe is not at Gen1 x2 speed, something is wrong here!!!  \n");
		printf("------------------------------------------------------------------\n");
		printf("\n");
		exit(0);
	}

	//------------------------------
    // Print TAGs of regfile
    //------------------------------
	printf("\n");
	printf("XGS ATHENA Static_ID : 0x%X\n", rXGS_Athena_ptr.SYSTEM.TAG.f.VALUE);
	printf("XGS I2C Static_ID    : 0x%X\n", rI2Cptr.I2C.I2C_ID.f.ID);
	printf("\n");


	//Print build ID
	printf("\n\nFPGA Build is ID is %d (0x%X) \n", Pcie->rPcie_ptr.fpga.build_id.f.value , Pcie->rPcie_ptr.fpga.build_id.f.value );


	// pour tester que le fix du bug TLP_2_AXI est repare
	TestTLP2AXI(XGS_Ctrl);

	Help(XGS_Ctrl);

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
				XGS_Ctrl->DisableXGS();
				XGS_Data->HiSpiClr();
				sortie = 1;
				printf("\n\n");
				break;

			case 'r':
				printf("\nEnter Sensor starting address to Dump in hex : 0x");
				scanf_s("%x", &SPI_START);
				printf("\nEnter the number of register to read in DEC : ");
				scanf_s("%d", &SPI_RANGE);
				printf("\n\n");
				XGS_Ctrl->DumpRegSPI(SPI_START, SPI_RANGE);
				printf("\n\n");
				break;

			case 'D':
				XGS_Ctrl->ReadSPI_DumpFile();
				break;

			case 'w':
				printf("\nEnter Sensor address to Write in hex : 0x");
				scanf_s("%x", &address);
				printf("\nCurrent data in this register is : 0x%X\n", XGS_Ctrl->ReadSPI(address) );
				printf("\nEnter data to Write in hex : 0x");
				scanf_s("%x", &data);
				XGS_Ctrl->WriteSPI(address, data);		
				printf("\nCurrent data in this register is now : 0x%X (Readback of XGS after Write operation)\n", XGS_Ctrl->ReadSPI(address));
				printf("\n\n");
				break;

			case '0':
				test_0000_Continu(XGS_Ctrl, XGS_Data);
				printf("\n\n");
				Help(XGS_Ctrl);
				break;

			case '1':
				test_0001_SWtrig(XGS_Ctrl, XGS_Data);
				printf("\n\n");
				Help(XGS_Ctrl);
				break;

			case '2':
				test_0002_Continu_2xROI(XGS_Ctrl, XGS_Data);
				printf("\n\n");
				Help(XGS_Ctrl);
				break;

			case '3':
				test_0003_HW_Timer(XGS_Ctrl, XGS_Data);
				printf("\n\n");
				Help(XGS_Ctrl);
				break;

			case '9':
				test_0009_Optics(XGS_Ctrl, XGS_Data);
				printf("\n\n");
				Help(XGS_Ctrl);
				break;

			case 'e':
				XGS_Ctrl->InitXGS();      //unreset, enable clk and load DCF
				printf("\n\n");
				break;

			case 'd':
				XGS_Ctrl->DisableXGS();   //reset and disable clk
				XGS_Data->HiSpiClr();
				printf("\n\n");
				break;


			case 'h':
				XGS_Data->HiSpiCalibrate();
				break;
            
			case 's':
				Pcie->Read_QSPI_ID();
				for(int i=0; i<16; i++)
				  printf ("0x%08X 0x%08X\n", i*4, Pcie->Read_QSPI_DW(i*4) );
				break;

			}
		}//KBhit
	}//while

	printf("\n\nPress any key to exit");
	_getch();
	

	delete XGS_Ctrl;
	delete XGS_Data;
	delete I2C;
	delete Pcie;
	IrisMilFree();



	exit(0);






}  //main


//-----------------------
//  print help
//-----------------------
void Help(CXGS_Ctrl* XGS_Ctrl)
{

	printf("\n------------------------------------------------------------------------------");
	printf("\n");
	XGS_Ctrl->PrintTime();
	printf("\n  JDK - Bench IRIS 4 - MENU ");
	printf("\n");
	printf("\n  (q) Quit the app");
	printf("\n");
	printf("\n  (0) Grab Test Continu");
	printf("\n  (1) Grab Test SW trig - Manual");
	printf("\n  (2) Grab Test Continu, 2x Host Buffers");
	printf("\n  (3) Grab Test HW, Src is HW Timer");
	printf("\n");
	printf("\n  (9) Grab Optics");
	printf("\n");
	printf("\n  (e) Enable XGS sensor (Enable clk + unreset + Load DCF)");
	printf("\n  (d) Disable XGS sensor (Disable clk + Reset)");
	printf("\n  (h) Calibrate HiSPI XGS sensor interafce");
	printf("\n");
	printf("\n  (D) Dump XGS sensor registers");
	printf("\n  (r) Dump XGS sensor registers range");
	printf("\n  (w) Write XGS sensor register");
	printf("\n");
	printf("\n  (s) Read QSPI identification");
	printf("\n------------------------------------------------------------------------------\n\n");

}





//--------------------------------------------------------
//  TEST TLP 2 AXI bug 
//--------------------------------------------------------
void TestTLP2AXI(CXGS_Ctrl* XGS_Ctrl)
{
	//// Test du fix TLP_2_AXI avec W/R 64 bits et W/R 32bits 
	//// Faut modifier le regfile : regsitre READOUT_CFG3 ajouter le field .u64 pour pouvoir l'acceder en 64bits

	// /**************************************************************************
	// * Register name : READOUT_CFG3
	// ***************************************************************************/
	// typedef union
	// {
	// 	 M_UINT64 u64;
	//   ...
	//
	//// Attention quand on met ce registres 64bits le regfile est tout offset!!!
	////Access 64 bits
	//XGS_Ctrl->rXGSptr.ACQ.READOUT_CFG3.u64 = 0xcafefade0000caca;
	//M_UINT64 READOUT64 = XGS_Ctrl->rXGSptr.ACQ.READOUT_CFG3.u64;
	////Access 32 bits
	//XGS_Ctrl->rXGSptr.ACQ.READOUT_CFG3.u32 = 0x0000cafe;
	//M_UINT32  READOUT32 = XGS_Ctrl->rXGSptr.ACQ.READOUT_CFG3.u32;
	//printf("Ecriture et lecture 64 bits : %llX\n", READOUT64);
	//printf("Ecriture et lecture 32 bits=0x%x\n",   READOUT32);

	for (int j = 0; j < 10; j++) {
		//Test pour W/R PCIe ultra rapides
		for (int i = j * 100; i < ((j * 100) + 100); i++)
		{
			XGS_Ctrl->rXGSptr.ACQ.EXP_CTRL1.u32 = i;
			M_UINT32 readback = XGS_Ctrl->rXGSptr.ACQ.EXP_CTRL1.u32;
			if (readback != i) {
				printf("Test d'access PCIe R/W fail write=0x%x read=0x%x\n", i, readback);
				exit(0);
			}

		}
	}

}