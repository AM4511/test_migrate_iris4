#include "Cmiox.h"


//
//Cmiox::Cmiox()
//{
//	hostWindow0Ptr = nullptr;
//	hostWindow2Ptr = nullptr;
//	milBuffer0 = 0x0;
//	milBuffer2 = 0x0;
//}

Cmiox::Cmiox(string name, u64 pciBAR0, u64 pciBAR2)
{

	name = name;
	hostWindow0Ptr = allocate(pciBAR0, bar0Size, &milBuffer0);
	hostWindow2Ptr = allocate(pciBAR2, bar2Size, &milBuffer2);

	regFilePtr = (volatile FPGA_PCIE2AXIMASTER_TYPE*)hostWindow2Ptr;

}

volatile u32* Cmiox::setAxiWindow(u32 id, u32 start, u32 stop, u32 axi_offset)
{
	volatile u32* windowBaseAddr = nullptr;
	if (id < 0)
	{
		cerr << "Window id must be greather than 0" << endl;
		return windowBaseAddr;
	}
	if (id > 3)
	{
		cerr << "Window id must be smaller than 3" << endl;
		return windowBaseAddr;
	}
	if (start > stop)
	{
		cerr << "Window start offset must be smaller or equal to stop offset" << endl;
		return windowBaseAddr;
	}
	if (stop > bar0Size)
	{
		cerr << "Window stop offset must be smaller than bar0Size" << bar0Size << endl;
		return windowBaseAddr;
	}

	// From here we are safe to configure the window
	regFilePtr->axi_window[id].pci_bar0_start.u32 = start;
	regFilePtr->axi_window[id].pci_bar0_stop.u32 = stop;
	regFilePtr->axi_window[id].axi_translation.u32 = axi_offset;
	regFilePtr->axi_window[id].ctrl.u32 = 0x1;
	windowBaseAddr = (volatile u32*)((volatile u8*)this->hostWindow0Ptr + start);

	return windowBaseAddr;
}


void Cmiox::setAxiWindowTranslationOffset(u32 id, u32 axi_offset)
{
	regFilePtr->axi_window[id].axi_translation.u32 = axi_offset;
}

void Cmiox::disableAllWindow()
{
	for (u32 i = 0; i < 4; i++)
	{
		disableWindow(i);
	}
}

void Cmiox::disableWindow(u32 windowID)
{
	this->regFilePtr->axi_window[windowID].ctrl.f.enable = 0x0;
}



volatile u32* Cmiox::allocate(u64 pcieBAR, u32 barSize, MIL_ID * milBuffer)
{

	volatile u32* hostWindowPtr = nullptr;

	MbufCreate2d(M_DEFAULT_HOST,
		barSize,
		1,
		8 + M_UNSIGNED,
		M_IMAGE + M_MMX_ENABLED,
		M_PHYSICAL_ADDRESS + M_PITCH_BYTE,
		barSize,
		(void*)pcieBAR,
		milBuffer);

	//pcieBARPtr = (volatile u64*)MbufInquire(*milBuffer, M_HOST_ADDRESS, M_NULL);
	MbufInquireUnsafe(*milBuffer, M_HOST_ADDRESS, &hostWindowPtr);
	return hostWindowPtr;


}

int Cmiox::getBuildID()
{
	return this->regFilePtr->fpga.build_id.u32;
}


int Cmiox::getFPGAVersion()
{
	return this->regFilePtr->fpga.version.u32;
}


int Cmiox::getIPVersion()
{
	return this->regFilePtr->info.version.u32;
}


int Cmiox::getFID()
{
	return this->regFilePtr->info.fid.u32;

}



int Cmiox::getScratchValue()
{
	return this->regFilePtr->info.scratchpad.u32;

}


void Cmiox::setScratchValue(int value)
{
	this->regFilePtr->info.scratchpad.u32 = value;

}

Cmiox::FirmwareType Cmiox::getFirmwareType()
{
	return (FirmwareType)this->regFilePtr->fpga.version.f.firmware_type;
}


void Cmiox::printFPGAInfo()
{
	// Print the FPGA version
	int version = getFPGAVersion();
	int major = (version >> 16) & 0xff;
	int minor = (version >> 8) & 0xff;
	int sub_minor = version & 0xff;
	cout << "FPGA version : " << major << "." << minor << "." << sub_minor << endl;

	// Print the FPGA build info
	int fpgaBuildID = getBuildID();
	cout << "FPGA buildID : " << fpgaBuildID << endl;

	// Print the FPGA firmware type
	Cmiox::FirmwareType  bitstreamType = getFirmwareType();
	switch (bitstreamType)
	{
	case Cmiox::MIL_UPGRADE:
		cout << "Firmware type : MIL_UPGRADE" << endl;
		break;
	case Cmiox::NPI_GOLDEN:
		cout << "Firmware type : NPI_GOLDEN" << endl;
		break;
	case Cmiox::ENGINEERING:
		cout << "Firmware type : ENGINEERING" << endl;
		break;
	default:
		break;
	}
}


void Cmiox::printIPInfo()
{
	// Print the FPGA version
	int version = getIPVersion();
	int major = (version >> 16) & 0xff;
	int minor = (version >> 8) & 0xff;
	int sub_minor = version & 0xff;
	cout << "Pcie2AxiMaster version : " << major << "." << minor << "." << sub_minor << endl;



	// Print the FPGA firmware type
	Cmiox::FirmwareType  bitstreamType = getFirmwareType();
	switch (bitstreamType)
	{
	case Cmiox::MIL_UPGRADE:
		cout << "Firmware type : MIL_UPGRADE" << endl;
		break;
	case Cmiox::NPI_GOLDEN:
		cout << "Firmware type : NPI_GOLDEN" << endl;
		break;
	case Cmiox::ENGINEERING:
		cout << "Firmware type : ENGINEERING" << endl;
		break;
	default:
		break;
	}
}

void Cmiox::freeMilBuffer()
{
	MbufFree(milBuffer0);
	MbufFree(milBuffer2);
	milBuffer0 = 0;
	milBuffer2 = 0;
}

Cmiox::~Cmiox()
{
}
