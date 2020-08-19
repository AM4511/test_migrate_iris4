#pragma once
#include <string>
#include <iostream>
#include "fdk.h"

using namespace std;

#define PBSTR "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
#define PBWIDTH 60

class Ctest
{
public:
	string name;
	//Ctest();
	Ctest(string name);
	u32 status();
	virtual	u32 run();
	void assert(bool isError, string message);
	void assertErr(string message);
	u32 verbose;

protected:
	u32 errorCnt;
	u32 warningCnt;
	void printProgress(const char* str, double percentage);

};


