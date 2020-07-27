#pragma once
#include <string>
#include <iostream>
#include "fdk.h"
#include "../../../../ipcores/axiMaio/sdk/maio_registerfile.h"

using namespace std;
class CaxiMaio
{
public:
	CaxiMaio(string name, volatile u32* baseAddr);
	u32  getIPVersion();
	u32  getTag();
	u32  getFID();
	u32  getScratchValue();
	void setScratchValue(u32  value);
	void printIPInfo();
	~CaxiMaio();
	string name;
	volatile FPGA_MAIO_REGISTERFILE_TYPE* regFilePtr;

private:

};
