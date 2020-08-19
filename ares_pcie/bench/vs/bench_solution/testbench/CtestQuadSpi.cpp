#include "CtestQuadSpi.h"


CtestQuadSpi::CtestQuadSpi(Cmiox& miox) : miox(miox), Ctest("CtestQuadSpi")
{
	u32  zynqQspiWindowStart = 0xd000;
	u32  zynqQspiWindowStop = 0xe000;
	u32  zynqQspiWindowOffset = 0xe000d000;

	zynqQspiWindowPtr = miox.setAxiWindow(1, zynqQspiWindowStart, zynqQspiWindowStop, zynqQspiWindowOffset);

}


u32 CtestQuadSpi::run()
{
	cout << "Running CtestQuadSpi" << endl;

	char  message[255];

	CZynqQSpiAccess zynqQSpi = CZynqQSpiAccess(zynqQspiWindowPtr);
	uint8_t ReadBuffer[MAX_DATA + DATA_OFFSET + DUMMY_SIZE] = { 0 };
	zynqQSpi.Init();
	u32  flashID = zynqQSpi.FlashReadID();

	// Check manufacturer ID. Micron = 0x20
	u32  flashManufacturerID = flashID >> 8 & 0xff;
	message[0] = 0;
	sprintf_s(message, sizeof(message), "0x%x; Unknown flash device. Micron deviceID is 0x20", flashManufacturerID);
	assert(flashManufacturerID != 0x20, string(message));

	// Check flash type. 
	u32  flashType = flashID >> 16 & 0xff;
	message[0] = 0;
	sprintf_s(message, sizeof(message), "0x%x; Unknown flash type. Micron flash type should be : 0xBA", flashType);
	assert(flashType != 0xba, string(message));

	// Check flash capacity. 
	u32  flashCapacity = flashID >> 24 & 0xff;
	message[0] = 0;
	sprintf_s(message, sizeof(message), "0x%x; Undefined flash capacity. Micron flash capacity should be : 0x18", flashCapacity);
	assert(flashCapacity != 0x18, string(message));

	zynqQSpi.FlashRead(0, MAX_DATA, READ_CMD, ReadBuffer);
	return status();
}
