#pragma once
#include "fdk.h"

class CzynqDDR2
{
public:
	CzynqDDR2(volatile void* baseAddress, u32 size);
	~CzynqDDR2();
	u8 read_u8(u32 ddrByteOffset);
	u16 read_u16(u32 ddrByteOffset);
	u32 read_u32(u32 ddrByteOffset);
	u64 read_u64(u32 ddrByteOffset);
	void write_u8(u32 ddrByteOffset, u8 data);
	void write_u16(u32 ddrByteOffset, u16 data);
	void write_u32(u32 address, u32 data);
	void write_u64(u32 ddrByteOffset, u64 data);
	u32 m_size;
	volatile void* m_basePtr;
};

