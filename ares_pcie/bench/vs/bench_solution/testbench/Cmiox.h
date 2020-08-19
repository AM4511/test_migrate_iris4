#include <string>
#include <iostream>
#include "mil.h"
#include "fdk.h"
#include "../../../../ipcores/pcie2AxiMaster/sdk/pcie2AxiMaster.h"

#pragma once

using namespace std;

class Cmiox
{
public:
	enum FirmwareType { MIL_UPGRADE = 0, NPI_GOLDEN = 1, ENGINEERING = 2 };
	const u32 bar0Size = 0x4000000; // 64 MB
	const u32 bar2Size = 0x400;     //1 KB;

	string name;
	volatile FPGA_PCIE2AXIMASTER_TYPE* regFilePtr;

	//Cmiox();

	// Constructors
	//Cmiox();
	Cmiox(string name, u64 pciBAR0, u64 pciBAR2);
	~Cmiox();

	int getBuildID();
	int getFPGAVersion();
	int getIPVersion();
	int getFID();
	int getScratchValue();
	void setScratchValue(int value);
	FirmwareType getFirmwareType();
	void printFPGAInfo();
	void printIPInfo();
	void freeMilBuffer();

	volatile u32* setAxiWindow(u32 id, u32 start, u32 stop, u32 axi_offset);
	void setAxiWindowTranslationOffset(u32 id, u32 axi_offset);
	void disableAllWindow();
	void disableWindow(u32 windowID);



private:
	volatile u32* hostWindow0Ptr;
	volatile u32* hostWindow2Ptr;
	MIL_ID   milBuffer0;
	MIL_ID   milBuffer2;

	volatile u32* allocate(u64 pciBar, u32 bar_size, MIL_ID* milBuffer);
};
