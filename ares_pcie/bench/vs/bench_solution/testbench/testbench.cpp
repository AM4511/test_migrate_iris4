// testbench.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <string>
#include "fdk.h"
#include <CtestHyperRam.h>
#include <Cares.h>
#include <CtestAresID.h>
#include <CtestAresAxiWindow.h>
//#include <CtestQuadSpi.h>

#include <mil.h>
//#include "../../../../ipcores/axiMaio/sdk/maio_registerfile.h"
//#include <CaxiMaio.h>



int main()
{

	using namespace std;

	MIL_ID   MilApplication;
	MIL_ID   MilSystem;


	u64 PcieBAR0 = 0x80000000; //Axi system
	u64 PcieBAR2 = 0x84000000; //Pcie2AxiMaster bridge
	//u64 PcieBAR0 = 0x88000000; //Axi system
	//u64 PcieBAR2 = 0x8C000000; //Pcie2AxiMaster bridge
	int errCnt = 0;

	// Print the PCIe BAR for sanity check in the console
	cout << endl << "BAR0  : 0x" << hex << PcieBAR0 << endl;
	cout << "BAR2  : 0x" << hex << PcieBAR2 << endl;
	cout << "Press any key to continue..." << endl;
	char c = getchar();

	/* MIL Allocations */
	MappAlloc(M_DEFAULT, &MilApplication);
	MsysAlloc(M_SYSTEM_HOST, M_DEFAULT, M_DEFAULT, &MilSystem);

	/* Ares FPGA allocation*/
	string aresName("ares_0");
	Cares ares = Cares(aresName, PcieBAR0, PcieBAR2);

	// Create tests
	CtestAresID testAresID = CtestAresID(ares);
	//CtestAresAxiWindow testAresAxiWindow = CtestAresAxiWindow(ares);
	//CtestQuadSpi testQuadSpi = CtestQuadSpi(ares);
	CtestHyperRam testHyperRam = CtestHyperRam(ares);

	// Run tests

	errCnt += testAresID.run();
	//errCnt += testAresAxiWindow.run();
	//errCnt += testQuadSpi.run();
	errCnt += testHyperRam.run();

	ares.freeMilBuffer();
	MsysFree(MilSystem);
	MappFree(MilApplication);

	cout << endl << "Total error count : " << errCnt << endl;
	// End test
	cout << endl << "Press any key to exit..." << endl;
	
	
	c = getchar();
}
