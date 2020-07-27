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
	int errCnt = 0;


	/* MIL Allocations */
	MappAlloc(M_DEFAULT, &MilApplication);
	MsysAlloc(M_SYSTEM_HOST, M_DEFAULT, M_DEFAULT, &MilSystem);

	/* Ares FPGA allocation*/
	string aresName("ares_0");
	Cares ares = Cares(aresName, PcieBAR0, PcieBAR2);

	// Create tests
	CtestAresID testMioxID = CtestAresID(ares);
	CtestAresAxiWindow testAresAxiWindow = CtestAresAxiWindow(ares);
	//CtestQuadSpi testQuadSpi = CtestQuadSpi(ares);
	CtestHyperRam testDDR2 = CtestHyperRam(ares);

	// Run tests
	errCnt += testMioxID.run();
	//errCnt += testMioxAxiWindow.run();
	//errCnt += testQuadSpi.run();
	errCnt += testDDR2.run();

	ares.freeMilBuffer();
	MsysFree(MilSystem);
	MappFree(MilApplication);

	// End test
	cout << endl << "Press any key to exit..." << endl;
	char c = getchar();
}
