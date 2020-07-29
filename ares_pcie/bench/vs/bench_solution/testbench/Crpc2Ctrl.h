#pragma once
#include <string>
#include <iostream>
#include "fdk.h"
#include "../../../../ipcores/rpc2_ctrl_controller/registerfile/output/rpc2_ctrl_regfile.h"

using namespace std;
class Crpc2Ctrl
{
public:
	Crpc2Ctrl(string name, volatile u32* regBaseAddr, volatile void* memoryBaseAddr);
	void init();
	u8 read_u8(u32 ddrByteOffset);
	u16 read_u16(u32 ddrByteOffset);
	u32 read_u32(u32 ddrByteOffset);
	u64 read_u64(u32 ddrByteOffset);
	void write_u8(u32 ddrByteOffset, u8 data);
	void write_u16(u32 ddrByteOffset, u16 data);
	void write_u32(u32 ddrByteOffset, u32 data);
	void write_u64(u32 ddrByteOffset, u64 data);


	//void printIPInfo();
	~Crpc2Ctrl();
	string name;
	volatile FPGA_RPC2_CTRL_REGFILE_TYPE* m_regFilePtr;
	volatile void* m_basePtr;

private:

};
