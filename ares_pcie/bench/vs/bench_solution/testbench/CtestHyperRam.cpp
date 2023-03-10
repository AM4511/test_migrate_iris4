#include "CtestHyperRam.h"


CtestHyperRam::CtestHyperRam(Cares& ares) : Ctest("CtestHyperRam"), m_ares(ares)
{

	u32 registerWindowStart = 0x00000000; // 32MB high
	u32 registerWindowStop = 0x00000FFF;
	u32 registerWindowOffset = 0x00000000; // AXI Offset


	u32 memoryWindowStart = 0x00400000; // 32MB high
	u32 memoryWindowStop = 0x007FFFFF;
	u32 memoryWindowOffset = 0x00400000; // AXI Offset

	volatile u32* regfilePtr = ares.setAxiWindow(0, registerWindowStart, registerWindowStop, registerWindowOffset);
	volatile void* memoryBaseAddr = ares.setAxiWindow(1, memoryWindowStart, memoryWindowStop, memoryWindowOffset);
	m_rpc2Ctrl = new Crpc2Ctrl("rpc2ctrl", regfilePtr, memoryBaseAddr);
}


CtestHyperRam::~CtestHyperRam()
{
	delete m_rpc2Ctrl;
}

u32 CtestHyperRam::run()
{
	cout << "Running CtestHyperRam" << endl;

	// Test a single access
	test_single_access();

	// Test a ramp
	u32 start = 0x0;
	u32 stop = 0x0400000; // 4MB
	//stop = 0x1000000 - 1; // 4MB
	u32 initValue = 0x0;
	int32 increment = -1;
	u32 clearBufferValue = 0xcafefade;
	u32 numberIterations = 10000;

	for (u32 j = 0; j < numberIterations; j++)
	{
		cout << "###################################################################" << endl;
		cout << "###################################################################" << endl;
		cout << "## TESTLOOP : " << std::dec << j << endl;
		cout << "###################################################################" << endl;
		cout << "###################################################################" << endl;

		for (u32 i = 0; i < 1; i++)
		{
			cout << endl;
			cout << "###################################################################" << endl;
			cout << "## BAR0 AXI window[" << std::dec << i << "] ramp test 32MB                     " << endl;
			cout << "###################################################################" << endl;
			clear32(start, stop, clearBufferValue);
			//test_ramp_u8(start, stop - 4, (u8)initValue, (u8)increment);
			//test_ramp_u16(start, stop - 4, (u16)initValue, (u16)increment);
			test_ramp_u32(start, stop, initValue, increment);
			//test_ramp_u64(start, stop, (u64)initValue, (u64)increment);
			//test_ramp_u8_turbo(start, stop, (u8)initValue, (u8)increment);
			//test_ramp_u16_turbo(start, stop, (u16)initValue, (u16)increment);
		}
	}
	return status();
}

u32 CtestHyperRam::test_single_access()
{
	u32 address = 0x0;
	u32 writeData = 0xdeadbeef;
	u32 readData = 0;
	char message[256];

	double time;
	MappTimer(M_DEFAULT, M_TIMER_RESET + M_SYNCHRONOUS, M_NULL);

	// Single DDR2 write/read access
	m_rpc2Ctrl->write_u32(address, writeData);
	readData = m_rpc2Ctrl->read_u32(address);

	// Compare result
	if (readData != writeData)
	{
		sprintf_s(message, sizeof(message), "@0x%x : write32 data = 0x%x; readData = 0x%x; ", address, writeData, readData);
		assert(true, message);
	}
	MappTimer(M_DEFAULT, M_TIMER_READ + M_SYNCHRONOUS, &time);
	sprintf_s(message, sizeof(message), "test_single_access time : %.3f ms. : OK\n", time * 1000);
	cout << message;
	//return status();
	return 0;
}

u32 CtestHyperRam::clear32(u32 start, u32 stop, u32 clearValue)
{
	u32 address = start;
	u32 monitorStep = stop / 100;
	u32 stepCntr = 0;
	u32  percentage = 0;
	double time;
	char message[256];


	/////////////////////////////////////////////////////////////////////////////////
	// Write loop
	/////////////////////////////////////////////////////////////////////////////////
	MappTimer(M_DEFAULT, M_TIMER_RESET + M_SYNCHRONOUS, M_NULL);
	do
	{
		m_rpc2Ctrl->write_u32(address, clearValue);

		// Monitor
		if (stepCntr > monitorStep)
		{
			stepCntr = 0;
			percentage++;
			printProgress("Clear u32 32MB      : ", percentage / 100.00);
		}

		stepCntr += 4;
		address += 4;
	} while (address < stop);
	printProgress("Clear u32 32MB      : ", 1.00);

	// Print duration
	MappTimer(M_DEFAULT, M_TIMER_READ + M_SYNCHRONOUS, &time);
	sprintf_s(message, sizeof(message), " Duration: %.3f ms.", time * 1000);
	cout << message << endl;
	//return status();
	return 0;
}


u32 CtestHyperRam::test_ramp_u8(u32 start, u32 stop, u8 initValue, u8 increment)
{
	u32 address = start;
	u8 data = 0;
	u32 monitorStep = stop / 100;
	u32 stepCntr = 0;
	u32  percentage = 0;
	double time;
	char message[256];


	/////////////////////////////////////////////////////////////////////////////////
	// Write loop
	/////////////////////////////////////////////////////////////////////////////////
	MappTimer(M_DEFAULT, M_TIMER_RESET + M_SYNCHRONOUS, M_NULL);
	do
	{
		//m_rpc2Ctrl->write_u8(address, data);

		// Monitor
		if (stepCntr > monitorStep)
		{
			stepCntr = 0;
			percentage++;
			printProgress("Write u8 32MB ramp  : ", percentage / 100.00);
		}

		stepCntr += 1;
		address += 1;
		data++;
	} while (address < stop);

	// Print duration
	MappTimer(M_DEFAULT, M_TIMER_READ + M_SYNCHRONOUS, &time);
	sprintf_s(message, sizeof(message), " Duration: %.3f ms.", time * 1000);
	cout << message << endl;

	/////////////////////////////////////////////////////////////////////////////////
	// Read loop
	/////////////////////////////////////////////////////////////////////////////////
	u8 expectedData = 0;
	address = start;
	stepCntr = 0;
	percentage = 0;
	MappTimer(M_DEFAULT, M_TIMER_RESET + M_SYNCHRONOUS, M_NULL);

	do
	{
		u8 readData = 0;

		// Single DDR2 read access
		//readData = m_rpc2Ctrl->read_u8(address);

		// Monitor
		if (stepCntr > monitorStep)
		{
			stepCntr = 0;
			percentage++;
			printProgress("Read  u8 32MB ramp  : ", percentage / 100.00);
		}

		//// Compare result
		if (readData != expectedData)
		{
			char message[256];
			sprintf_s(message, sizeof(message), "@0x%x : write u8 data = 0x%x; read u8 data = 0x%x; ", address, expectedData, readData);
			assert(true, message);
		}

		stepCntr += 1;
		address += 1;
		expectedData++;

	} while (address < stop);

	// Print duration
	MappTimer(M_DEFAULT, M_TIMER_READ + M_SYNCHRONOUS, &time);
	sprintf_s(message, sizeof(message), " Duration: %.3f ms.", time * 1000);
	cout << message << endl;

	//return status();
	return 0;

}



u32 CtestHyperRam::test_ramp_u16(u32 start, u32 stop, u16 initValue, u16 increment)
{
	u32 address = start;
	u16 data = 0;
	u32 monitorStep = stop / 100;
	u32 stepCntr = 0;
	u32  percentage = 0;
	double time;
	char message[256];


	/////////////////////////////////////////////////////////////////////////////////
	// Write loop
	/////////////////////////////////////////////////////////////////////////////////
	MappTimer(M_DEFAULT, M_TIMER_RESET + M_SYNCHRONOUS, M_NULL);
	do
	{
		//m_rpc2Ctrl->write_u16(address, data);

		// Monitor
		if (stepCntr > monitorStep)
		{
			stepCntr = 0;
			percentage++;
			printProgress("Write u16 32MB ramp : ", percentage / 100.00);
		}

		stepCntr += 2;
		address += 2;
		data++;
	} while (address < stop);

	// Print duration
	MappTimer(M_DEFAULT, M_TIMER_READ + M_SYNCHRONOUS, &time);
	sprintf_s(message, sizeof(message), " Duration: %.3f ms.", time * 1000);
	cout << message << endl;

	/////////////////////////////////////////////////////////////////////////////////
	// Read loop
	/////////////////////////////////////////////////////////////////////////////////
	u16 expectedData = 0;
	address = start;
	stepCntr = 0;
	percentage = 0;
	MappTimer(M_DEFAULT, M_TIMER_RESET + M_SYNCHRONOUS, M_NULL);

	do
	{
		u16 readData = 0;

		// Single DDR2 read access
		//readData = m_rpc2Ctrl->read_u16(address);

		// Monitor
		if (stepCntr > monitorStep)
		{
			stepCntr = 0;
			percentage++;
			printProgress("Read  u16 32MB ramp : ", percentage / 100.00);
		}

		//// Compare result
		if (readData != expectedData)
		{
			char message[256];
			sprintf_s(message, sizeof(message), "@0x%x : write u16 data = 0x%x; read u8 data = 0x%x; ", address, expectedData, readData);
			assert(true, message);
		}

		stepCntr += 2;
		address += 2;
		expectedData++;

	} while (address < stop);

	// Print duration
	MappTimer(M_DEFAULT, M_TIMER_READ + M_SYNCHRONOUS, &time);
	sprintf_s(message, sizeof(message), " Duration: %.3f ms.", time * 1000);
	cout << message << endl;

	//return status();
	return 0;
}

u32 CtestHyperRam::test_ramp_u32(u32 start, u32 stop, u32 initValue, int32 increment)
{
	u32 address = start;
	u32 data = 0;
	u32 monitorStep = stop / 100;
	u32 stepCntr = 0;
	u32  percentage = 0;
	double time;
	char message[256];


	/////////////////////////////////////////////////////////////////////////////////
	// Write loop
	/////////////////////////////////////////////////////////////////////////////////
	MappTimer(M_DEFAULT, M_TIMER_RESET + M_SYNCHRONOUS, M_NULL);
	do
	{
		m_rpc2Ctrl->write_u32(address, data);

		// Monitor
		if (stepCntr > monitorStep)
		{
			stepCntr = 0;
			percentage++;
			printProgress("Write u32 32MB ramp : ", percentage / 100.00);
		}

		stepCntr += 4;
		address += 4;
		data++;
	} while (address < stop);

	// Print duration
	MappTimer(M_DEFAULT, M_TIMER_READ + M_SYNCHRONOUS, &time);
	sprintf_s(message, sizeof(message), " Duration: %.3f ms.", time * 1000);
	cout << message << endl;

	/////////////////////////////////////////////////////////////////////////////////
	// Read loop
	/////////////////////////////////////////////////////////////////////////////////
	u32 expectedData = 0;
	address = start;
	stepCntr = 0;
	percentage = 0;
	MappTimer(M_DEFAULT, M_TIMER_RESET + M_SYNCHRONOUS, M_NULL);

	do
	{
		u32 readData;

		// Single DDR2 read access
		readData = m_rpc2Ctrl->read_u32(address);

		// Monitor
		if (stepCntr > monitorStep)
		{
			stepCntr = 0;
			percentage++;
			printProgress("Read  u32 32MB ramp : ", percentage / 100.00);
		}

		//// Compare result
		if (readData != expectedData)
		{
			char message[256];
			sprintf_s(message, sizeof(message), "@0x%x : write32 data = 0x%x; readData = 0x%x; ", address, expectedData, readData);
			assert(true, message);
		}

		stepCntr += 4;
		address += 4;
		expectedData++;

	} while (address < stop);

	// Print duration
	MappTimer(M_DEFAULT, M_TIMER_READ + M_SYNCHRONOUS, &time);
	sprintf_s(message, sizeof(message), " Duration: %.3f ms.", time * 1000);
	cout << message << endl;

	//return status();
	return 0;
}

u32 CtestHyperRam::test_ramp_u64(u32 start, u32 stop, u64 initValue, u64 increment)
{
	u32 address = start;
	u64 data = 0;
	u32 monitorStep = stop / 100;
	u32 stepCntr = 0;
	u32  percentage = 0;
	double time;
	char message[256];


	/////////////////////////////////////////////////////////////////////////////////
	// Write loop
	/////////////////////////////////////////////////////////////////////////////////
	MappTimer(M_DEFAULT, M_TIMER_RESET + M_SYNCHRONOUS, M_NULL);
	do
	{
		//m_rpc2Ctrl->write_u64(address, data);

		// Monitor
		if (stepCntr > monitorStep)
		{
			stepCntr = 0;
			percentage++;
			printProgress("Write u64 32MB ramp : ", percentage / 100.00);
		}

		stepCntr += 8;
		address += 8;
		data++;
	} while (address < stop);

	// Print duration
	MappTimer(M_DEFAULT, M_TIMER_READ + M_SYNCHRONOUS, &time);
	sprintf_s(message, sizeof(message), " Duration: %.3f ms.", time * 1000);
	cout << message << endl;

	/////////////////////////////////////////////////////////////////////////////////
	// Read loop
	/////////////////////////////////////////////////////////////////////////////////
	u64 expectedData = 0;
	address = start;
	stepCntr = 0;
	percentage = 0;
	MappTimer(M_DEFAULT, M_TIMER_RESET + M_SYNCHRONOUS, M_NULL);

	do
	{
		u64 readData = 0;

		// Single DDR2 read access
		//readData = m_rpc2Ctrl->read_u64(address);

		// Monitor
		if (stepCntr > monitorStep)
		{
			stepCntr = 0;
			percentage++;
			printProgress("Read  u64 32MB ramp : ", percentage / 100.00);
		}

		//// Compare result
		if (readData != expectedData)
		{
			char message[256];
			sprintf_s(message, sizeof(message), "@0x%x : write u64 data = 0x%x; read u8 data = 0x%x; ", address, expectedData, readData);
			assert(true, message);
		}

		stepCntr += 8;
		address += 8;
		expectedData++;

	} while (address < stop);

	// Print duration
	MappTimer(M_DEFAULT, M_TIMER_READ + M_SYNCHRONOUS, &time);
	sprintf_s(message, sizeof(message), " Duration: %.3f ms.", time * 1000);
	cout << message << endl;

	//return status();
	return 0;
}

u32 CtestHyperRam::test_ramp_u8_turbo(u32 start, u32 stop, u8 initValue, u8 increment)
{
	u32 errorData = 0xcafefade;
	//u32 address = start;
	u8 data = 0;
	//u32 monitorStep = stop / 100;
	u32 stepCntr = 0;
	u32  percentage = 0;
	double time;
	char message[256];
	u8 expectedData;
	u8 readData;
	volatile u8* readPtr;
	volatile u8* writePtr;
	volatile u32* errorPtr;
	writePtr = 0x0;
	//writePtr = (u8*)m_rpc2Ctrl->m_basePtr;
	//errorPtr = (u32*)m_rpc2Ctrl->m_basePtr;

	volatile u8* stopOffset = writePtr + stop;

	/////////////////////////////////////////////////////////////////////////////////
	// Write loop
	/////////////////////////////////////////////////////////////////////////////////
	MappTimer(M_DEFAULT, M_TIMER_RESET + M_SYNCHRONOUS, M_NULL);
	sprintf_s(message, sizeof(message), "Writing u8 ramp\n");
	cout << message << endl;
	do
	{
		*writePtr = data;
		writePtr++;
		data++;
	} while (writePtr < stopOffset);

	// Print duration
	MappTimer(M_DEFAULT, M_TIMER_READ + M_SYNCHRONOUS, &time);
	sprintf_s(message, sizeof(message), " Duration: %.3f ms.", time * 1000);
	cout << message << endl;


	/////////////////////////////////////////////////////////////////////////////////
	// Read loop
	/////////////////////////////////////////////////////////////////////////////////
	MappTimer(M_DEFAULT, M_TIMER_RESET + M_SYNCHRONOUS, M_NULL);
	sprintf_s(message, sizeof(message), "Reading u8 ramp\n");
	cout << message << endl;

	// Initialize data
	//readPtr = (u8*)m_rpc2Ctrl->m_basePtr;
	expectedData = 0;
	/*do
	{*/
	// Single DDR2 read access 
	//readData = *readPtr;

	//// Compare result
	//if (readData != expectedData)
	//{
	////	*errorPtr = errorData;
	//	char message[256];
	//	sprintf_s(message, sizeof(message), "\nError : @0x%p : write u8 data = 0x%x; read u8 data = 0x%x; ", readPtr, expectedData, readData);
	//	assert(true, message);
	//}

	//readPtr++;
	expectedData++;

	//} while (readPtr < stopOffset);

	// Print duration
	MappTimer(M_DEFAULT, M_TIMER_READ + M_SYNCHRONOUS, &time);
	sprintf_s(message, sizeof(message), " Duration: %.3f ms.", time * 1000);
	cout << message << endl;
	return 0;
}

u32 CtestHyperRam::test_ramp_u16_turbo(u32 start, u32 stop, u16 initValue, u16 increment)
{
	u16 data = 0;

	u16 expectedData;
	u16 readData;
	volatile u16* readPtr;
	volatile u16* writePtr;
	volatile u16* stopOffset;
	volatile u32* errorPtr;

	u32 stepCntr = 0;
	u32  percentage = 0;
	u32 errorData = 0xcafefade;

	double time;
	char message[256];

	//writePtr = (u16*)m_rpc2Ctrl->m_basePtr;
	//errorPtr = (u32*)m_rpc2Ctrl->m_basePtr;
	//stopOffset = writePtr + stop / 2;


	/////////////////////////////////////////////////////////////////////////////////
	// Write loop
	/////////////////////////////////////////////////////////////////////////////////
	MappTimer(M_DEFAULT, M_TIMER_RESET + M_SYNCHRONOUS, M_NULL);
	sprintf_s(message, sizeof(message), "Writing u16 ramp\n");
	cout << message << endl;
	/*do
	{
		*writePtr = data;
		writePtr++;
		data++;
	} while (writePtr < stopOffset);*/

	// Print duration
	MappTimer(M_DEFAULT, M_TIMER_READ + M_SYNCHRONOUS, &time);
	sprintf_s(message, sizeof(message), " Duration: %.3f ms.", time * 1000);
	cout << message << endl;


	/////////////////////////////////////////////////////////////////////////////////
	// Read loop
	/////////////////////////////////////////////////////////////////////////////////
	MappTimer(M_DEFAULT, M_TIMER_RESET + M_SYNCHRONOUS, M_NULL);
	sprintf_s(message, sizeof(message), "Reading u16 ramp\n");
	cout << message << endl;

	// Initialize data
	//readPtr = (u16*)m_rpc2Ctrl->m_basePtr;
	expectedData = 0;
	//do
	//{
	//	// Single DDR2 read access 
	//	//readData = *readPtr;

	//	//// Compare result
	//	//if (readData != expectedData)
	//	//{
	//	//	//*errorPtr = errorData;
	//	//	char message[256];
	//	//	sprintf_s(message, sizeof(message), "\nError : @0x%p : write u16 data = 0x%x; read u16 data = 0x%x; ", readPtr, expectedData, readData);
	//	//	assert(true, message);
	//	//}

	//	readPtr++;
	//	expectedData++;

	//} while (readPtr < stopOffset);

	// Print duration
	MappTimer(M_DEFAULT, M_TIMER_READ + M_SYNCHRONOUS, &time);
	sprintf_s(message, sizeof(message), " Duration: %.3f ms.", time * 1000);
	cout << message << endl;
	return 0;
}


u32 CtestHyperRam::software_trigger()
{
	u32 writeData = 0xcafefade;
	volatile u32* writePtr;
	//writePtr = (u32*)m_rpc2Ctrl->m_basePtr;
	//*writePtr = writeData;
	return 0;
}
