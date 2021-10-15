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
#include "osincludes.h"

#include "XGS_Ctrl.h"
#include "XGS_Data.h"
#include "Pcie.h"
#include "Ares.h"
#include "flashupdate.h"

#include "I2C.h"

#include "SystemTree.h" 
#include "MilLayer.h"

#include <string>
#include <iostream>
#include <sstream>
using namespace std;


//#define bitstream_BuildID_min         0x0
#define bitstream_BuildID_min         0x5F58D07F

#define regfile_MAIO_ADD_OFFSET       0x00000000  //
#define regfile_XGS_ATHENA_ADD_OFFSET 0x00000000  //
#define regfile_I2C_ADD_OFFSET        0x00001000  // addresse reelle est 0x10000, mais on map la window2 PCIe sur 0x10000, avec un start a 0x1000
#define regfile_ARES_ADD_OFFSET       0x00000000  //

void TestTLP2AXI(CXGS_Ctrl* XGS_Ctrl);

void Help(CXGS_Ctrl* Camera);
void test_0000_Continu(CPcie* Pcie, CXGS_Ctrl* XGS_Ctrl, CXGS_Data* XGS_Data);
void test_0001_SWtrig(CPcie* Pcie, CXGS_Ctrl* XGS_Ctrl, CXGS_Data* XGS_Data);
void test_0002_Continu_2xROI(CPcie* Pcie, CXGS_Ctrl* XGS_Ctrl, CXGS_Data* XGS_Data);
void test_0003_HW_Timer(CPcie* Pcie, CXGS_Ctrl* XGS_Ctrl, CXGS_Data* XGS_Data);
void test_0004_Continu_FPS(CPcie* Pcie, CXGS_Ctrl* XGS_Ctrl, CXGS_Data* XGS_Data);
void test_0005_SWtrig_Random(CPcie* Pcie, CXGS_Ctrl* XGS_Ctrl, CXGS_Data* XGS_Data);
void test_0006_SWtrig_BlackCorr(CPcie* Pcie, CXGS_Ctrl* XGS_Ctrl, CXGS_Data* XGS_Data);
void test_0007_Continu(CPcie* Pcie, CXGS_Ctrl* XGS_Ctrl, CXGS_Data* XGS_Data);
void test_0009_Optics(CPcie* Pcie, CXGS_Ctrl* XGS_Ctrl, CXGS_Data* XGS_Data);
int test_0010_Continu_nbframes(CPcie* Pcie, CXGS_Ctrl* XGS_Ctrl, CXGS_Data* XGS_Data, M_UINT32 nbFrames, M_UINT32 FlatImageVal);

/* Main function. */
int main(void)
{
	M_UINT32 Athena_DevID = 0x5054;
	M_UINT32 Ares_DevID   = 0x5055;

	int sortie = 0;
	char ch;
	int getch_return;
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
	int fpgaSel = 0;
	int PowerUP = 0;
	// IRISx
	int nbFPGA = FindMultiFpga(0x102b, Athena_DevID, FPGAs);                 // Lets get the Bar0 address of the Iris FPGA


	if (nbFPGA == 0)
	{
		printf_s("Impossible to find Athena!!!\n");
		int i = _getch();
		return(1);
	}
	else
		if (nbFPGA == 1)
		{
			FPGA_used = 1;
		}
		else { FPGA_used = 1; } //prendre le premier par defaut

	M_UINT64 fpga_bar0_add = FPGAs[FPGA_used - 1].PhyRefReg_BAR0;
	M_UINT64 fpga_bar1_add = FPGAs[FPGA_used - 1].PhyRefReg_BAR1;
	M_UINT64 fpga_bar2_add = FPGAs[FPGA_used - 1].PhyRefReg_BAR2;

	MilLayerAlloc();

	int PCIe_config = MultiFpgaPCIeConfig(FPGA_used - 1, FPGAs);



	//------------------------------
	// Init ARES FPGAs, Regfile
	//------------------------------
	Struck_FPGAs ARES_FPGAs[16];

	// Ares (only one fpga)
	int Ares_nbFPGA = FindMultiFpga(0x102b, Ares_DevID, ARES_FPGAs);     // Lets get the Bar0 address of the ARES FPGA
	M_UINT64 Ares_fpga_bar0_add = ARES_FPGAs[0].PhyRefReg_BAR0;
	if (Ares_nbFPGA == 0) Ares_fpga_bar0_add = fpga_bar1_add;

	int Ares_PCIe_config = MultiFpgaPCIeConfig(0, ARES_FPGAs);


	if (nbFPGA == 1)
		printf_s("\nATHENA   %X.%X  BAR0=0x%08x,  BAR1=0x%08x \n", FPGAs[FPGA_used - 1].DevID, FPGAs[FPGA_used - 1].SubsystemID, FPGAs[FPGA_used - 1].PhyRefReg_BAR0, FPGAs[FPGA_used - 1].PhyRefReg_BAR1);
	else
		printf_s("ATHENA FPGA not detected\n");

	if (Ares_nbFPGA == 1)
		printf_s("ARES   %X.%X  BAR0=0x%08x\n", ARES_FPGAs[0].DevID, ARES_FPGAs[0].SubsystemID, ARES_FPGAs[0].PhyRefReg_BAR0);
	else
		printf_s("ARES FPGA not detected\n");

	//------------------------------
	// Init Global PCIe (Maio) REGISTER FILE
	//------------------------------
	volatile unsigned char* PCIe_regptr = getMilLayerRegisterPtr(0, fpga_bar1_add + regfile_MAIO_ADD_OFFSET);
	volatile FPGA_REGFILE_PCIE2AXIMASTER_TYPE& rPcie_ptr = (*(volatile FPGA_REGFILE_PCIE2AXIMASTER_TYPE*)(PCIe_regptr));

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
	// Init ARES REGISTER FILE
	//------------------------------
	volatile unsigned char* Ares_regptr = getMilLayerRegisterPtr(3, Ares_fpga_bar0_add + regfile_ARES_ADD_OFFSET);       // Lets put a pointer to the ARES FPGA
	volatile FPGA_REGFILE_ARES_TYPE& rAresptr = (*(volatile FPGA_REGFILE_ARES_TYPE*)(Ares_regptr));

	//------------------------------
	// Init class 
	//------------------------------
	CPcie* Pcie;
	Pcie = new CPcie(rPcie_ptr);
	Pcie->InitBar0Window();


	//------------------------------
	// Init class XGS CONTROLLER
	//------------------------------
	CXGS_Ctrl* XGS_Ctrl;
	XGS_Ctrl = new CXGS_Ctrl(rXGS_Athena_ptr, 16.000000, 15.625, rI2Cptr);    //32Mhz

	//------------------------------
	// Init class XGS DATAPATH
	//------------------------------
	CXGS_Data* XGS_Data;
	XGS_Data = new CXGS_Data(rXGS_Athena_ptr);

	//------------------------------
	// Init class I2C CONTROLLER
	//------------------------------
	CI2C* I2C;
	I2C = new CI2C(rI2Cptr);

	//------------------------------
	// Init class ARES fpga
	//------------------------------
	CAres* Ares;
	Ares = new CAres(rAresptr, Ares_nbFPGA);


	//------------------------------
	// Init class Flash ATHENA
	//------------------------------
	CFpgaEeprom* FpgaEeprom;
	FpgaEeprom = new CFpgaEeprom(fpga_bar1_add, 0x3F0000); //32Mb flash (we have 64Mb installed)

	//------------------------------
	// Init class Flash ARES
	//------------------------------
	CFpgaEeprom* FpgaEepromAres;
	FpgaEepromAres = new CFpgaEeprom(Ares_fpga_bar0_add, 0x3F0000); //32Mb flash (we have 64Mb installed)


	//-----------------------------------------------------
    // If PCIe x1 detected, reduce Framerate of the sensor
    //-----------------------------------------------------
	if ((FPGAs[0].LinkStatusReg & 0xff0000) == 0x210000)
	{
		XGS_Ctrl->GrabParams.XGS_LINE_SIZE_FACTOR = 1;
		printf_s("\n");
		printf_s("------------------------------------------------------------------\n");
		printf_s(" XGS FRAMERATE IS AT NOMINAL SPEED, SINCE FPGA IS IN PCIe Gen1 x2 \n");
		printf_s("------------------------------------------------------------------\n");
		printf_s("\n");
	}
	else
	{
		XGS_Ctrl->GrabParams.XGS_LINE_SIZE_FACTOR = 4;
    	printf_s("------------------------------------------------------------------\n");
		printf_s(" Athena PCIe is not at Gen1 x2 speed, something is wrong here!!!  \n");
		printf_s("------------------------------------------------------------------\n");
		printf_s("\n");
		printf_s("----------------------------------------------------------------------\n");
		printf_s(" XGS FRAMERATE IS NOT AT NOMINAL SPPED, SINCE FPGA IS IN PCIe Gen1 x1 \n");
		printf_s("----------------------------------------------------------------------\n");
		printf_s("\n");

	}

	//------------------------------
    // Print TAGs of regfile
    //------------------------------
	printf_s("\n");
	printf_s("XGS ATHENA Static_ID : 0x%X\n", rXGS_Athena_ptr.SYSTEM.TAG.f.VALUE);
	printf_s("XGS I2C Static_ID    : 0x%X\n", rI2Cptr.I2C.I2C_ID.f.ID);
	if(Ares_nbFPGA==1) 
	  printf_s("ARES Static_ID       : 0x%X\n", rAresptr.device_specific.fpga_id.f.fpga_id);
	
	printf_s("\n");


	//Print build ID
	printf_s("\nAthena FPGA Firmware is ID is %d (0x%X), builded on ", Pcie->rPcie_ptr.fpga.build_id.f.value , Pcie->rPcie_ptr.fpga.build_id.f.value );

	//Epoch to human understandable time
	time_t rawtime = Pcie->rPcie_ptr.fpga.build_id.f.value;
	struct tm  ts;
	char       buf[80];
	// Format time, "ddd yyyy-mm-dd hh:mm:ss zzz"
	ts = *localtime(&rawtime);
	strftime(buf, sizeof(buf), "%a %Y-%m-%d %H:%M:%S %Z", &ts);
	printf_s("%s\n", buf);

	if (Pcie->rPcie_ptr.fpga.version.f.firmware_type == 0)
		printf_s("Athena FPGA Firmware is UPDATE fpga \n");
	if (Pcie->rPcie_ptr.fpga.version.f.firmware_type == 1)
		printf_s("Athena FPGA Firmware is GOLDEN fpga \n");
	if (Pcie->rPcie_ptr.fpga.version.f.firmware_type == 2)
		printf_s("Athena FPGA Firmware is ING fpga\n");

	if (Pcie->rPcie_ptr.fpga.device.f.id == 0)
		printf_s("Athena FPGA Firmware is MONO-A50\n");
	if (Pcie->rPcie_ptr.fpga.device.f.id == 1)
		printf_s("Athena FPGA Firmware is MONO-A35\n");
	if (Pcie->rPcie_ptr.fpga.device.f.id == 2)
		printf_s("Athena FPGA Firmware is COLOR-A50\n");
	if (Pcie->rPcie_ptr.fpga.device.f.id == 3)
		printf_s("Athena FPGA Firmware is COLOR-A35\n");


	if (Ares_nbFPGA == 1)
	{
		printf_s("Ares   FPGA Build is ID is %d (0x%X), builded on ", rAresptr.device_specific.buildid.u32, rAresptr.device_specific.buildid.u32);
		//Epoch to human understandable time
		time_t rawtime = rAresptr.device_specific.buildid.u32;
		struct tm  ts;
		char       buf[80];
		// Format time, "ddd yyyy-mm-dd hh:mm:ss zzz"
		ts = *localtime(&rawtime);
		strftime(buf, sizeof(buf), "%a %Y-%m-%d %H:%M:%S %Z", &ts);
		printf_s("%s\n", buf);
	}


	// Generate a ERROR if FPGA is lower than a particular buildID
	M_UINT32 MinBuildID = (M_UINT32) bitstream_BuildID_min;
	if (Pcie->rPcie_ptr.fpga.build_id.f.value < MinBuildID)
	{
		printf_s("\n\n");
		printf_s("***************************************************************************************************\n"); 
		printf_s(" This build of JDK needs at least FPGA version %d (0x%X), program a new bitstream!\n", MinBuildID, MinBuildID); 
		printf_s("***************************************************************************************************\n");

		printf_s("\n\nPress any key to exit");
		getch_return = _getch();
		delete FpgaEeprom;
		delete XGS_Ctrl;
		delete XGS_Data;
		delete I2C;
		delete Pcie;
		IrisMilFree();
		exit(0);

	}





	// pour tester que le fix du bug TLP_2_AXI est repare
	//TestTLP2AXI(XGS_Ctrl);

	// test Arbitre
	//Pcie->ArbiterTest();
	//if (Ares_nbFPGA == 1)
	//	Ares->ArbiterTest();



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
				printf_s("\n\n");
				break;

			case 'r':
				printf_s("\nEnter Sensor starting address to Dump in hex : 0x");
				scanf_s("%x", &SPI_START);
				printf_s("\nEnter the number of register to read in DEC : ");
				scanf_s("%d", &SPI_RANGE);
				printf_s("\n\n");
				XGS_Ctrl->DumpRegSPI(SPI_START, SPI_RANGE);
				printf_s("\n\n");
				break;

			case 'D':
				XGS_Ctrl->ReadSPI_DumpFile();
				break;

			case 'w':
				printf_s("\nEnter Sensor address to Write in hex : 0x");
				scanf_s("%x", &address);
				printf_s("\nCurrent data in this register is : 0x%X\n", XGS_Ctrl->ReadSPI(address) );
				printf_s("\nEnter data to Write in hex : 0x");
				scanf_s("%x", &data);
				XGS_Ctrl->WriteSPI(address, data);		
				printf_s("\nCurrent data in this register is now : 0x%X (Readback of XGS after Write operation)\n", XGS_Ctrl->ReadSPI(address));
				printf_s("\n\n");
				break;

			case '0':
				test_0000_Continu(Pcie, XGS_Ctrl, XGS_Data);
				printf_s("\n\n");
				Help(XGS_Ctrl);
				break;

			case '1':
				test_0001_SWtrig(Pcie, XGS_Ctrl, XGS_Data);
				printf_s("\n\n");
				Help(XGS_Ctrl);
				break;

			case '2':
				test_0002_Continu_2xROI(Pcie, XGS_Ctrl, XGS_Data);
				printf_s("\n\n");
				Help(XGS_Ctrl);
				break;

			case '3':
				test_0003_HW_Timer(Pcie, XGS_Ctrl, XGS_Data);
				printf_s("\n\n");
				Help(XGS_Ctrl);
				break;

			case '4':
				test_0004_Continu_FPS(Pcie, XGS_Ctrl, XGS_Data);
				printf_s("\n\n");
				Help(XGS_Ctrl);
				break;

			case '5':
				test_0005_SWtrig_Random(Pcie, XGS_Ctrl, XGS_Data);
				printf_s("\n\n");
				Help(XGS_Ctrl);
				break;				

			case '6':
				test_0006_SWtrig_BlackCorr(Pcie, XGS_Ctrl, XGS_Data);
				printf_s("\n\n");
				Help(XGS_Ctrl);
				break;

			case '7':
				test_0007_Continu(Pcie, XGS_Ctrl, XGS_Data);
				printf_s("\n\n");
				Help(XGS_Ctrl);
				break;
				

			case '9':
				test_0009_Optics(Pcie, XGS_Ctrl, XGS_Data);
				printf_s("\n\n");
				Help(XGS_Ctrl);
				break;

			case 'a':
				printf_s("\nNumber of loops to execute? (One loop is IMGs : Live->Ramp->0x000->0xaaa->0x555) : ");
				scanf_s("%d", &NBiter);
				for (int i = 0; i < NBiter; i++)
				{
					
					PowerUP++;
					printf_s("\nPowerUP : %d/%d \n", PowerUP, NBiter * 5);
					if (test_0010_Continu_nbframes(Pcie, XGS_Ctrl, XGS_Data, 25, 0x1000) == 1) break;    //Live IMG
					PowerUP++;
					printf_s("\nPowerUP : %d/%d \n", PowerUP, NBiter * 5);
					if (test_0010_Continu_nbframes(Pcie, XGS_Ctrl, XGS_Data, 25, 0x2000) == 1) break;    //Ramp IMG
					PowerUP++;
					printf_s("\nPowerUP : %d/%d \n", PowerUP, NBiter * 5);
					if (test_0010_Continu_nbframes(Pcie, XGS_Ctrl, XGS_Data, 25, 0x000)  == 1) break;    //Flat IMG
					PowerUP++;
					printf_s("\nPowerUP : %d/%d \n", PowerUP, NBiter * 5);
					if (test_0010_Continu_nbframes(Pcie, XGS_Ctrl, XGS_Data, 25, 0xaaa)  == 1) break;    //Flat IMG
					PowerUP++;
					printf_s("\nPowerUP : %d/%d \n", PowerUP, NBiter * 5);
					if (test_0010_Continu_nbframes(Pcie, XGS_Ctrl, XGS_Data, 25, 0x555)  == 1) break;    //Flat IMG

				}	
				printf_s("\nTOTAL Sensor PowerUP executed : %d/%d \n", PowerUP, NBiter*5);
				break;

			case 'e':
				XGS_Ctrl->InitXGS();      //unreset, enable clk and load DCF
				printf_s("\n\n");
				break;

			case 'd':
				XGS_Ctrl->DisableXGS();   //reset and disable clk
				XGS_Data->HiSpiClr();
				printf_s("\n\n");
				break;


			case 'h':
				XGS_Data->HiSpiCalibrate(1);
				printf_s("You can do multiple calibrations with test '#' \n");
				break;
            
			case '#':
				printf_s("\nEnter number of HISPI calibrations to do : ");
				scanf_s("%d", &data);
				printf_s("\n");
				for (M_UINT32 i= 0; i < data+1; i++)
				{   
					printf_s("\rCalibration #%d", i);
					if ( XGS_Data->HiSpiCalibrate(0) == 0) break;

				}
				break;

			case 'i':
				printf_s("\nI2C Temp Read, Temperature is %dC\n", (I2C->Read_i2c(0, 0x4c, 0, 0, 1)) & 0xff);
				break;

			case 's':

				printf_s("\nQuel FPGA vous voulez utiliser? (0=Athena, 1=Ares) : ");
				scanf_s("%d", &fpgaSel);
				if (fpgaSel == 0) {
					Pcie->Read_QSPI_ID();
					for (int i = 0; i < 16; i++)
						printf_s("0x%08X 0x%08X\n", i * 4, Pcie->Read_QSPI_DW(i * 4));
				}
				else
				{
					Ares->Read_QSPI_ID();
					for (int i = 0; i < 16; i++)
						printf_s("0x%08X 0x%08X\n", i * 4, Ares->Read_QSPI_DW(i * 4));
				}
				break;

			case 'F':
				//printf_s("\nQuel FPGA vous voulez programmer? (0=Athena, 1=Ares) : ");
				//scanf_s("%d", &fpgaSel);
				//if (fpgaSel == 0) {
					printf_s("\n-----------------------------------");
					printf_s("\n    ATHENA FPGA Firmware update    ");
					printf_s("\n-----------------------------------");
					Pcie->Read_QSPI_ID();
					// Get the File name and location
					string cin_imagefilename;
					std::cout << "\nEnter the filename and path of the .firmware file (ex: c:\\athena_1599678296.firmware) : ";
					cin >> cin_imagefilename;
					
					MIL_UINT8 FlashResult= FpgaEeprom->FPGAROMApiFlashFromFile(cin_imagefilename);
					
					if(FlashResult==0)
					  printf_s("\nDone. Press 'q' to quit. Please do a shutdown power cycle to the Iris GTx Camera to load the new Athena fpga firmware\n\n");
					else
					  if (FlashResult == 1)
						printf_s("\nERROR DURING FLASH UPDATE. TRYING TO PROGRAM UPDATE FIRMWARE WHERE NO GOLDEN IS PRESENT. Press 'q' to quit. \n\n");
   					  else
					    printf_s("\nERROR DURING FLASH UPDATE. Press 'q' to quit. \n\n");


				//} else {
				//	if (Ares_nbFPGA == 1) {
				//		printf_s("\n---------------------------------");
				//		printf_s("\n    ARES FPGA Firmware update    ");
				//		printf_s("\n---------------------------------");
				//		Ares->Read_QSPI_ID();
				//		// Get the File name and location
				//		string cin_imagefilename;
				//		std::cout << "\nEnter the filename and path of the .firmware file (ex: c:\\ares_1599678296.firmware) : ";
				//		cin >> cin_imagefilename;
				//		FpgaEepromAres->FPGAROMApiFlashFromFile(cin_imagefilename);
				//		printf_s("\nDone. Press 'q' to quit. Please do a shutdown power cycle to the Iris GTx Camera to load the new Ares fpga firmware\n\n");
				//	}
				//	else {
				//		printf_s("\nARES fpga non detected, CODE-12!!!\n\n");
				//	}
				//
				//}
				break;


			}
		}//KBhit
	}//while

	printf_s("\n\nPress any key to exit");
	getch_return = _getch();
	
	delete FpgaEeprom;
	delete XGS_Ctrl;
	delete XGS_Data;
	delete I2C;
	delete Pcie;
	delete Ares;
	delete FpgaEepromAres;
	IrisMilFree();

	

	exit(0);






}  //main


//-----------------------
//  print help
//-----------------------
void Help(CXGS_Ctrl* XGS_Ctrl)
{

	printf_s("\n------------------------------------------------------------------------------");
	printf_s("\n");
	XGS_Ctrl->PrintTime();
	printf_s("\n  JDK - Bench IRIS 4 - MENU ");
	printf_s("\n");
	printf_s("\n  (q) Quit the app");
	printf_s("\n");
	printf_s("\n  (0) Grab Test Continu");
	printf_s("\n  (1) Grab Test SW trig - Manual");
	printf_s("\n  (2) Grab Test Continu, 2x Host Buffers");
	printf_s("\n  (3) Grab Test HW, Src is HW Timer");
	printf_s("\n  (4) Grag Test FPSmax, EXPmax");
	printf_s("\n  (5) Grag Test SW trig - Random");	
	printf_s("\n  (6) Grag Test SW trig - Stats on the PD and SN Black lines");
	printf_s("\n  (7) Grag Test Continu - DPC");
	printf_s("\n  (a) Grag Test CRC bug");
	printf_s("\n");
	printf_s("\n  (9) Grab Optics");
	printf_s("\n");
	printf_s("\n  (e) Enable XGS sensor (Enable clk + unreset + Load DCF)");
	printf_s("\n  (d) Disable XGS sensor (Disable clk + Reset)");
	printf_s("\n  (h) Calibrate HiSPI XGS sensor interafce");
	printf_s("\n");
	printf_s("\n  (D) Dump XGS sensor registers");
	printf_s("\n  (r) Dump XGS sensor registers range");
	printf_s("\n  (w) Write XGS sensor register");
	printf_s("\n");
	printf_s("\n  (i) Read I2C temp sensor");
	printf_s("\n  (s) Read QSPI identification");
	printf_s("\n  (F) Program Flash SPI firmware");
	printf_s("\n------------------------------------------------------------------------------\n\n");

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
	//printf_s("Ecriture et lecture 64 bits : %llX\n", READOUT64);
	//printf_s("Ecriture et lecture 32 bits=0x%x\n",   READOUT32);

	for (int j = 0; j < 10; j++) {
		//Test pour W/R PCIe ultra rapides
		for (int i = j * 100; i < ((j * 100) + 100); i++)
		{
			XGS_Ctrl->rXGSptr.ACQ.EXP_CTRL1.u32 = i;
			M_UINT32 readback = XGS_Ctrl->rXGSptr.ACQ.EXP_CTRL1.u32;
			if (readback != i) {
				printf_s("Test d'access PCIe R/W fail write=0x%x read=0x%x\n", i, readback);
				exit(0);
			}

		}
	}

}