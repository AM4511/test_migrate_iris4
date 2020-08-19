#include "CtestAxiMaio.h"



CtestAxiMaio::CtestAxiMaio(CaxiMaio& axiMaio) : axiMaio(axiMaio), Ctest("CtestAxiMaio")
{
}

CtestAxiMaio::~CtestAxiMaio()
{
}


u32 CtestAxiMaio::run()
{

	// Validate that tag = "MTX" (matrox  IP)
	if (axiMaio.getTag() != 0x58544d)
	{
		assert(true, "AxiMaio : Invalid Matrox tag");
		return status();
	}

	// Validate that function ID = 
	if (axiMaio.getFID() != 0x0)
	{
		assert(true, "AxiMaio : Invalid function ID");
		return status();
	}


	/* Pring IP info */
	if (verbose > 0)
		axiMaio.printIPInfo();

	//Test FPGA version
	u32 version = axiMaio.getIPVersion();
	u32 major = (version >> 16) & 0xff;
	u32 minor = (version >> 8) & 0xff;
	u32 sub_minor = version & 0xff;
	assert(major != 1, "\nAxiMaio major version != 1");
	assert(minor != 7, "\nAxiMaio minor version != 7");
	//assert(sub_minor != 0, "\nAxiMaio sub_minor version != 0");


	// Test scratch pad register
	for (u32 i = 0; i < 0x100; i++)
	{
		axiMaio.setScratchValue(i);
		u32 scratchValue = axiMaio.getScratchValue();
		if (scratchValue != i)
		{
			string message = "Scratchpad value wrote : " + to_string(i) + "; Scratchpad value read : " + to_string(scratchValue);
			assert(true, message);
			break;
		}

	}

	return status();
}
