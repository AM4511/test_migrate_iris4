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

#include "I2C.h"

#include "mtxservmanager.h"

#include <iostream>

#include <algorithm>
#include <vector>
using namespace std;




volatile FPGA_REGFILE_I2C_TYPE* CI2C::getRegisterI2C(void)
{
	return rI2C;
}






//--------------------------------------------------------
//  I2C WRITE FUNCTION
//
//  MEM Access (I2Cindex needed) : NIacc = 0 (avec cycle adresse)
//   IO Access (I2Cindex needed) : NIacc = 1
//--------------------------------------------------------
void CI2C::Write_i2c(int BUSsel, int DEVid, int NIacc, int I2Cindex, M_UINT32  DATAWrite, char id_[20])
{

	rI2C->I2C.I2C_CTRL1.u32 = (DEVid << 1) + 0;  // DevID + Write access

	rI2C->I2C.I2C_CTRL0.u32 = (I2Cindex << 24) + (NIacc << 23) + (BUSsel << 17) + DATAWrite;

	rI2C->I2C.I2C_CTRL0.u32 = (I2Cindex << 24) + (NIacc << 23) + (BUSsel << 17) + DATAWrite + 0x10000;

	//pooling busy register
	while (rI2C->I2C.I2C_CTRL1.f.BUSY == 1) {}

	//validate protocol error
	if (rI2C->I2C.I2C_CTRL1.f.I2C_ERROR == 1)
	{
		printf("\n\n  I2C WRITE ERROR: Protocol BusSel=%d, id=%s, addr=0x%X data=0x%X\n", BUSsel, id_, I2Cindex, DATAWrite);

	}

}



