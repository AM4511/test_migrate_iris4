#include "CzynqDDR2.h"

CzynqDDR2::CzynqDDR2(volatile void* baseAddress, u32 size)
{
	m_basePtr = baseAddress;
	m_size = size;
}

CzynqDDR2::~CzynqDDR2()
{
}


u8 CzynqDDR2::read_u8(u32 ddrByteOffset)
{
	u8 data;
	volatile u8* readPtr = (volatile u8*)m_basePtr + ddrByteOffset;
	data = *readPtr;
	return data;
}


u16 CzynqDDR2::read_u16(u32 ddrByteOffset)
{
	u16 data;
	volatile u16* readPtr = (volatile u16*)m_basePtr + ddrByteOffset / 2;
	data = *readPtr;
	return data;
}

u32 CzynqDDR2::read_u32(u32 ddrByteOffset)
{
	u32 data;
	volatile u32* readPtr = (u32*)m_basePtr + ddrByteOffset / 4;
	data = *readPtr;
	return data;
}


u64 CzynqDDR2::read_u64(u32 ddrByteOffset)
{
	u64 data;
	volatile u64* readPtr = (u64*)m_basePtr + ddrByteOffset / 8;
	data = *readPtr;
	return data;
}


void CzynqDDR2::write_u8(u32 ddrByteOffset, u8 data)
{
	volatile u8* writePtr = (volatile u8*)m_basePtr + ddrByteOffset;
	*writePtr = data;
}


void CzynqDDR2::write_u16(u32 ddrByteOffset, u16 data)
{
	volatile u16* writePtr = (volatile u16*)m_basePtr + ddrByteOffset / 2;
	*writePtr = data;
}


void CzynqDDR2::write_u32(u32 ddrByteOffset, u32 data)
{
	volatile u32* writePtr = (volatile u32*)m_basePtr + (ddrByteOffset / 4);
	*writePtr = data;
}


void CzynqDDR2::write_u64(u32 ddrByteOffset, u64 data)
{
	volatile u64* writePtr = (volatile u64*)m_basePtr + (ddrByteOffset / 8);
	*writePtr = data;
}

