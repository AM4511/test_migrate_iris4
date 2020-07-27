#include "CtestAresID.h"

CtestAresID::CtestAresID(Cares& ares) : ares(ares), Ctest("CtestAresID")
{


}


u32  CtestAresID::run()
{
	cout << "Running CtestAresID" << endl;

	/* Pring FPGA info */
	if (verbose > 0)
	{
		ares.printFPGAInfo();
	}

	//Test FPGA version

	u32  version = ares.getFPGAVersion();
	u32  major = (version >> 16) & 0xff;
	u32  minor = (version >> 8) & 0xff;
	u32  sub_minor = version & 0xff;

	cout << "MIOX FPGA version: " << major << "." << minor << "." << sub_minor << endl;

	assert(major > 1, "MIOX FPGA major version > 1");
	assert(minor != 0, "MIOX FPGA minor version != 0");
	assert(sub_minor != 4, "MIOX FPGA sub_minor version != 4");

	//Test FPGA buildID
	u32  fpgaBuildID = ares.getBuildID();
	cout << "MIOX FPGA BuildID: " << fpgaBuildID << "; " << "0x" << hex << fpgaBuildID << endl;
	assert(fpgaBuildID == 0, "MIOX FPGA BuildID is null");
	assert(fpgaBuildID < 0x5ca63d35, "MIOX FPGA BuildID is smaller than 0x5ca63d35");

	// Test scratch pad register
	for (u32  i = 0; i < 0x10000; i++)
	{
		ares.setScratchValue(i);
		u32  scratchValue = ares.getScratchValue();
		if (scratchValue != i)
		{
			string message = "Scratchpad value wrote : " + to_string(i) + "; Scratchpad value read : " + to_string(scratchValue);
			assert(true, message);
			break;
		}

	}


	return status();
}
