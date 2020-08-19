#pragma once

#include <sstream>
#include "fdk.h"
#include "Ctest.h"
#include "Cmiox.h"
#include "spiaccess.h"

using namespace std;

class CtestQuadSpi :
	public Ctest
{
public:
	CtestQuadSpi(Cmiox& miox);
	u32 run();

private:
	Cmiox& miox;
	volatile u32* zynqQspiWindowPtr;
};

