#include "CaxiMaio.h"


CaxiMaio::CaxiMaio(string name, volatile u32* baseAddr)
{
	this->name = name;
	regFilePtr = (volatile FPGA_MAIO_REGISTERFILE_TYPE*)baseAddr;

}



u32  CaxiMaio::getIPVersion()
{
	return this->regFilePtr->info.version.u32 & 0xffffff;
}


u32  CaxiMaio::getTag()
{
	return this->regFilePtr->info.tag.u32 & 0xffffff;

}



u32  CaxiMaio::getFID()
{
	return this->regFilePtr->info.fid.u32;

}



u32  CaxiMaio::getScratchValue()
{
	return this->regFilePtr->info.scratchpad.u32;

}


void CaxiMaio::setScratchValue(u32  value)
{
	this->regFilePtr->info.scratchpad.u32 = value;

}



void CaxiMaio::printIPInfo()
{
	cout << endl << "axiMaio IP info : " << endl;
	// Print the FPGA version
	u32  fid = getFID();
	cout << "axiMaio function ID : " << fid << endl;

	// Print the IP version
	u32  version = getIPVersion();
	u32  major = (version >> 16) & 0xff;
	u32  minor = (version >> 8) & 0xff;
	u32  sub_minor = version & 0xff;
	cout << "axiMaio version : " << major << "." << minor << "." << sub_minor << endl;

}


CaxiMaio::~CaxiMaio()
{
}
