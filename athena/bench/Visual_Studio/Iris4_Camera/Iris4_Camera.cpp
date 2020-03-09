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

#include "Iris4.h"
#include "SystemTree.h" 
#include "MilLayer.h"

/* Main function. */
int main(void)
{

	int sortie = 0;
	char ch;
	//int answer;

	//unsigned long SPI_START;
	//unsigned long SPI_END;

	//unsigned long address;
	//unsigned long data;

	//------------------------------
	// Init ATHENA FPGAs, Regfile
	//------------------------------
	Struck_FPGAs FPGAs[16];
	Struck_FPGAs FPGAsTemp[16];

	Struck_FPGAs IDTs[16];

	int FPGA_used = 0;
	int NBiter = 1;
	int PD_Head = 1;

	// IRISx
	int nbFPGA = FindMultiFpga(0x102b, 0x5053, FPGAs);                 // Lets get the Bar0 address of the Iris FPGA
	
	if (nbFPGA == 0)
	{
		printf("Impossible to find Athena!!!\n");
		_getch();
		exit(1);
	}
	else
		if (nbFPGA == 1)
		{
			FPGA_used = 1;
		}

	unsigned long fpga_bar0_add = FPGAs[FPGA_used - 1].PhyRefReg_BAR0;
	unsigned long fpga_bar1_add = FPGAs[FPGA_used - 1].PhyRefReg_BAR1;
	unsigned long fpga_bar2_add = FPGAs[FPGA_used - 1].PhyRefReg_BAR2;

	unsigned char* IRIS4_regptr0 = getMilLayerRegisterPtr(fpga_bar0_add);         // Lets put a pointer to the FPGA Bar0 ATHENA/ANPUT


	int PCIe_config = MultiFpgaPCIeConfig(FPGA_used - 1, FPGAs);


	CIris4* Iris4;
	




	if (FPGAs[FPGA_used - 1].DevID == 0x5053) //IRIS4
	{

		Iris4 = new CIris4(16000000,  13888889,	IRIS4_regptr0);
		
		volatile FPGA_REGFILE_XGS_CTRL_TYPE* rXGSptr = Iris4->getRegisterCTRL();

		printf("\n\nATHENA Controller Static_ID: 0x%X,  %X.%X  BAR0=0x%08x,  BAR1=0x%08x \n", rXGSptr->SYSTEM.ID.f.STATICID,  FPGAs[FPGA_used - 1].DevID, FPGAs[FPGA_used - 1].SubsystemID, FPGAs[FPGA_used - 1].PhyRefReg_BAR0, FPGAs[FPGA_used - 1].PhyRefReg_BAR1);
	}



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

//			case 'd':
//				printf("\nEnter Sensor starting address to Dump (0 to 511) in dec : ");
//				scanf_s("%d", &SPI_START);
//				printf("\nEnter Sensor ending address to Dump (0 to 511) in dec : ");
//				scanf_s("%d", &SPI_END);
//				printf("\n\n");
//				Iris3->PythonDumpReg(SPI_START, SPI_END);
//				printf("\n\n");
//				Help(Iris3);
//				break;
//
//			case 'D':
//				Iris3->ReadSPI_DumpFile("PythonDump_All_Regs.txt");
//				break;
//
//			case 'w':
//				printf("\nEnter Sensor address to Write (0 to 511) in dec : ");
//				scanf_s("%d", &address);
//				printf("\nEnter Sensor data to Write in hex : 0x");
//				scanf_s("%x", &data);
//				printf("\n\n");
//				Iris3->PythonWriteReg(address, data);
//				printf("\n\n");
//				Help(Iris3);
//				break;
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


