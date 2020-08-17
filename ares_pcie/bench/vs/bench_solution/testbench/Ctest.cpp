#include "Ctest.h"

using namespace std;


Ctest::Ctest(string name = "")
{
	this->name = name;
	errorCnt = 0;
	warningCnt = 0;
	verbose = 0;
}


u32 Ctest::status()
{
	if (verbose > 1)
	{
		cerr << endl;
		cerr << "==================================================" << endl;
		cerr << "Test " << name << " status : ";

	}
	
	if (errorCnt > 0)
	{
		cerr << "\tFail. Error count : " << errorCnt << endl;
	}
	else
	{
		if (verbose > 1)
		{
			cout << "\tPass" << endl;
		}
	}

	return errorCnt;
}

u32 Ctest::run()
{

	return 0;
}

void Ctest::assert(bool isError, string message)
{
	if (isError)
	{
		cerr << endl << "### Error : " << message << endl;
		errorCnt++;
		cout << endl << "Press any key to continue..." << endl;
		char c = getchar();
	}
}

void Ctest::assertErr(string message)
{
	assert(true, message);
}

void  Ctest::printProgress(const char* str, double percentage)
{
	u32 val = (int)(percentage * 100);
	u32 lpad = (int)(percentage * PBWIDTH);
	u32 rpad = PBWIDTH - lpad;
	printf("\r%s%3d%% [%.*s%*s]", str, val, lpad, PBSTR, rpad, "");
	fflush(stdout);
}