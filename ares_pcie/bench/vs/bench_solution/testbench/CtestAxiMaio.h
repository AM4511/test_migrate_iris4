#pragma once
#include "Ctest.h"
#include "CaxiMaio.h"
#include "fdk.h"

class CtestAxiMaio :
	public Ctest
{
public:
	CtestAxiMaio(CaxiMaio& axiMaio);
	~CtestAxiMaio();
	u32 run();
	CaxiMaio& axiMaio;
};

