#pragma once
#include "Ctest.h"
#include "Cares.h"
#include "fdk.h"

using namespace std;
class CtestAresID :
	public Ctest
{
public:
	CtestAresID(Cares& ares);
	u32 run();

private:
	Cares& ares;
};

