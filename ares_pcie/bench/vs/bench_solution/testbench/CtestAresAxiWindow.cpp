#include "CtestAresAxiWindow.h"


CtestAresAxiWindow::CtestAresAxiWindow(Cares& ares) : ares(ares), Ctest("CtestAresAxiWindow")
{
}


CtestAresAxiWindow::~CtestAresAxiWindow()
{
}

u32 CtestAresAxiWindow::run()
{

	cout << "Running CtestMioxAxiWindow" << endl;

	// Test the 4 different windows
	// Shift the windows through by increment of 4 Bytes
	u32  windowSize = 0x2000;
	u32  windowShiftOffset = 4;
	u32  numberIteration = 1024;

	cout << "Test BAR0 : sliding AXI windows. Window shift offset : " << windowShiftOffset << " Bytes; " << numberIteration << " shift iterations/window" <<endl;
	for (u32  windowID = 0; windowID < 4; windowID++)
	{
		test_slide_axi_window(windowID, windowSize, windowShiftOffset, numberIteration);
		cout << endl;
	}

	// Shift the windows through the whole 64MB
	windowShiftOffset = windowSize;
	numberIteration = ares.bar0Size / windowSize;
	cout << endl;
	cout << "Test BAR0 : sliding AXI windows. Window shift offset : " << windowShiftOffset << " Bytes; " << numberIteration << " shift iterations/window" << endl;
	for (u32  windowID = 0; windowID < 4; windowID++)
	{
		test_slide_axi_window(windowID, windowSize, windowShiftOffset, numberIteration);
		cout << endl;
	}

	verbose = 2;
	return status();
}

u32 CtestAresAxiWindow::test_slide_axi_window(u32  windowID, u32  windowSize, u32  windowShiftOffset, u32  iteration)
{
	double maxCount = iteration;
	double progress = 0;

	ares.disableAllWindow();
	volatile u32 * axiMaioPtr;
	u32  windowStart;
	u32  windowStop;
	string testStr = "  => window[" + to_string(windowID) + "]  ";

	//cout << endl << endl << "Sliding window[" << windowID << "] ";
	printProgress(testStr.c_str(), progress++ / maxCount);

	for (u32  i = 0; i < iteration; i++)
	{
		// Set the window at a position in the PCI BAR0 but keep it pointing 
		// always to the same axi base address (base address of axiMaio) 
		windowStart = i * windowShiftOffset;
		windowStop = windowStart + windowSize - 4;
		axiMaioPtr = ares.setAxiWindow(windowID, windowStart, windowStop, 0x0);


		// If the BAR0 window is pointing correctly to axiMaio then we can run 
		// the all axiMaio tests without any issues
		//CaxiMaio axiMaio = CaxiMaio("aximaio_0", axiMaioPtr);
		//CtestAxiMaio testAxiMaio = CtestAxiMaio(axiMaio);
		//testAxiMaio.verbose = 0;
		//errorCnt += testAxiMaio.run();
		printProgress(testStr.c_str(), progress++ / maxCount);

		// On error, stop
		if (errorCnt != 0)
		{
			cerr << "Loop " << dec << i << ": Window start : 0x" << hex << windowStart << ": Window stop : 0x" << hex << windowStop << endl;
			break;
		}

	}

	return status();
}