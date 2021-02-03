//
//

#define _CRT_SECURE_NO_DEPRECATE

#include "osincludes.h"

#include <string>
using std::string;

#include "I2C.h"

#include "mtxservmanager.h"

#include <iostream>

#include <algorithm>
#include <vector>
using namespace std;




CI2C::CI2C(volatile FPGA_REGFILE_I2C_TYPE& i_rI2Cptr) :
	rI2Cptr(i_rI2Cptr)
{

}


CI2C::~CI2C()
{

}






//--------------------------------------------------------
//  I2C WRITE FUNCTION
//
//  BUSsel=0 (Iris4 only have one interface)
//
//  MEM Access (I2Cindex needed)    : NIacc = 0 (avec cycle adresse)
//   IO Access (NO I2Cindex needed) : NIacc = 1
//--------------------------------------------------------
void CI2C::Write_i2c(int BUSsel, int DEVid, int NIacc, int I2Cindex, M_UINT32  DATAWrite)
{
	rI2Cptr.I2C.I2C_CTRL1.u32 = (DEVid << 1) + 0;  // DevID + Write access

	rI2Cptr.I2C.I2C_CTRL0.u32 = (I2Cindex << 24) + (NIacc << 23) + (BUSsel << 17) + DATAWrite;

	rI2Cptr.I2C.I2C_CTRL0.u32 = (I2Cindex << 24) + (NIacc << 23) + (BUSsel << 17) + DATAWrite + 0x10000;

	//pooling busy register
	while (rI2Cptr.I2C.I2C_CTRL1.f.BUSY == 1) {}

	//validate protocol error
	if (rI2Cptr.I2C.I2C_CTRL1.f.I2C_ERROR == 1)
	{
		printf_s("\n\n  I2C WRITE ERROR: Protocol BusSel=%d, addr=0x%X data=0x%X\n", BUSsel,  I2Cindex, DATAWrite);

	}

}



//--------------------------------------------------------
//  I2C READ FUNCTION with prediction
//
//  BUSsel=0 (Iris4 only have one interface)
//
//  MEM Access (I2Cindex needed)    : NIacc = 0 (avec cycle adresse)
//   IO Access (NO I2Cindex needed) : NIacc = 1
//
//--------------------------------------------------------
void CI2C::Read_i2c_predic(int BUSsel, int DEVid, int NIacc, int I2Cindex, M_UINT32 DATAWrite)//, char id_[20])
{

	int errorflag;
	int loop_nb = 0;

	rI2Cptr.I2C.I2C_CTRL1.u32 = (DEVid << 1) + 1;  // DevID + Read access

	rI2Cptr.I2C.I2C_CTRL0.u32 = (I2Cindex << 24) + (NIacc << 23) + (BUSsel << 17);

	rI2Cptr.I2C.I2C_CTRL0.u32 = (I2Cindex << 24) + (NIacc << 23) + (BUSsel << 17) + 0x10000;

	//pooling busy register
	while (rI2Cptr.I2C.I2C_CTRL1.f.BUSY == 1) {}

	//validate protocol error
	if (rI2Cptr.I2C.I2C_CTRL1.f.I2C_ERROR == 1)
	{
		printf_s("\nI2C READ ERROR: Protocol BusSel=%d\n", BUSsel);
		errorflag = 1;
	}
	else errorflag = 0;

	//validate readback data if no protocol error
	if (errorflag == 0)
	{
		if ((DATAWrite & 0xff) != rI2Cptr.I2C.I2C_CTRL0.f.I2C_DATA_READ)
			printf_s("\nI2C READ ERROR: Data VAlidation, DataW=0x%x DataR=0x%x \n", DATAWrite, rI2Cptr.I2C.I2C_CTRL0.f.I2C_DATA_READ);
	}

}

//--------------------------------------------------------
//  I2C READ FUNCTION, return readed value
//
//  BUSsel=0 (Iris4 only have one interface)
//
//  MEM Access (I2Cindex needed)    : NIacc = 0 (avec cycle adresse)
//   IO Access (NO I2Cindex needed) : NIacc = 1
//--------------------------------------------------------
M_UINT32 CI2C::Read_i2c(int BUSsel, int DEVid, int NIacc, int I2Cindex,  int print_err)
{
	int loop_nb = 0;

	rI2Cptr.I2C.I2C_CTRL1.u32 = (DEVid << 1) + 1;  // DevID + Read access

	rI2Cptr.I2C.I2C_CTRL0.u32 = (I2Cindex << 24) + (NIacc << 23) + (BUSsel << 17);

	rI2Cptr.I2C.I2C_CTRL0.u32 = (I2Cindex << 24) + (NIacc << 23) + (BUSsel << 17) + 0x10000;

	//pooling busy register
	while (rI2Cptr.I2C.I2C_CTRL1.f.BUSY == 1) {}

	//validate protocol error
	if (rI2Cptr.I2C.I2C_CTRL1.f.I2C_ERROR == 1)
	{
		if (print_err == 1) printf_s("\nI2C READ ERROR: Protocol BusSel=%d\n", BUSsel);
	}

	return(rI2Cptr.I2C.I2C_CTRL0.f.I2C_DATA_READ);

}

