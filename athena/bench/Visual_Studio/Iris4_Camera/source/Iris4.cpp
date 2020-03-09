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

#include "Iris4.h"

#include "mtxservmanager.h"

#include <iostream>
#include <algorithm>
#include <vector>
using namespace std;




volatile FPGA_REGFILE_XGS_CTRL_TYPE* CIris4::getRegisterCTRL(void)
{
	return rXGSptr;
}


