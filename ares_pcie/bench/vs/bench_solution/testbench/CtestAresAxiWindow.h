#pragma once
#include "fdk.h"
#include "Cares.h"
#include "Ctest.h"
//#include "CtestAxiMaio.h"

using namespace std;
class CtestAresAxiWindow :
	public Ctest
{
public:
	CtestAresAxiWindow(Cares& ares);
	~CtestAresAxiWindow();
	u32 run();

private:
	Cares& ares;
	u32 test_slide_axi_window(u32  windowID, u32  windowSize, u32  windowShiftOffset, u32  iteration);

};

