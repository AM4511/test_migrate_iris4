#include "Crpc2Ctrl.h"


Crpc2Ctrl::Crpc2Ctrl(string name, volatile u32* regBaseAddr, volatile void* memoryBaseAddr)
{
	this->name = name;
	m_regFilePtr = (volatile FPGA_RPC2_CTRL_REGFILE_TYPE*) regBaseAddr;
	m_basePtr = memoryBaseAddr;
	this->init();
}

void Crpc2Ctrl::init()
{
	this->m_regFilePtr->mcr->u32 = 0x00000010;
	this->m_regFilePtr->mtr->u32 = 0x00000001;
}


u8 Crpc2Ctrl::read_u8(u32 readOffset)
{
	u8 data;
	volatile u8* readPtr = (volatile u8*)m_basePtr + readOffset;
	data = *readPtr;
	return data;
}


u16 Crpc2Ctrl::read_u16(u32 readOffset)
{
	u16 data;
	volatile u16* readPtr = (volatile u16*)m_basePtr + readOffset / 2;
	data = *readPtr;
	return data;
}

u32 Crpc2Ctrl::read_u32(u32 readOffset)
{
	u32 data;
	volatile u32* readPtr = (u32*)m_basePtr + readOffset / 4;
	data = *readPtr;
	return data;
}


u64 Crpc2Ctrl::read_u64(u32 readOffset)
{
	u64 data;
	volatile u64* readPtr = (u64*)m_basePtr + readOffset / 8;
	data = *readPtr;
	return data;
}


void Crpc2Ctrl::write_u8(u32 writeOffset, u8 data)
{
	volatile u8* writePtr = (volatile u8*)m_basePtr + writeOffset;
	*writePtr = data;
}


void Crpc2Ctrl::write_u16(u32 writeOffset, u16 data)
{
	volatile u16* writePtr = (volatile u16*)m_basePtr + writeOffset / 2;
	*writePtr = data;
}


void Crpc2Ctrl::write_u32(u32 writeOffset, u32 data)
{
	volatile u32* writePtr = (volatile u32*)m_basePtr + (writeOffset / 4);
	*writePtr = data;
}


void Crpc2Ctrl::write_u64(u32 writeOffset, u64 data)
{
	volatile u64* writePtr = (volatile u64*)m_basePtr + (writeOffset / 8);
	*writePtr = data;
}


Crpc2Ctrl::~Crpc2Ctrl()
{
}
