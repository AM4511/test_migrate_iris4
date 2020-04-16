//
//

#define _CRT_SECURE_NO_DEPRECATE

#include "stdafx.h"
#include <stdio.h> 
#include <stdlib.h> 
#include <conio.h> 
#include <time.h>

#include <string>
using std::string;

#include "XGS_Data.h"

#include "mtxservmanager.h"

#include <iostream>

#include <algorithm>
#include <vector>
using namespace std;




CXGS_Data::CXGS_Data(volatile FPGA_HISPI_REGISTERFILE_TYPE& i_rXGSptr):
	rXGSptr(i_rXGSptr)
{
	memset(&sXGSptr, 0, sizeof(sXGSptr));
	memcpy(&sXGSptr, (const void*)& rXGSptr, sizeof(sXGSptr));
}


CXGS_Data::~CXGS_Data()
{


}


void CXGS_Data::Test(void)
{
	printf("DataPath info Tag is 0x%X\n", rXGSptr.info.tag.u32);

}