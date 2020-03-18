// I2C.h



#include <math.h>
#include <vector>
#include "regfile_i2c.h"
using namespace std;


//----------------------------
//-- Class I2C
//----------------------------
class CI2C
{

public:
	CI2C(unsigned char* IRIS4_regptr0, M_UINT32 MemOffset)
	{

		rI2C = (FPGA_REGFILE_I2C_TYPE*)(IRIS4_regptr0 + MemOffset); // Offset du premier registre du I2C par rapport au BAR0

	}


	~CI2C()
	{


	}
	
	volatile FPGA_REGFILE_I2C_TYPE* rI2C;       // HW pointer to reg
	volatile FPGA_REGFILE_I2C_TYPE* getRegisterI2C(void);

	// Fonctions
	//void Write_i2c(int BUSsel, int DEVid, int NIacc, int I2Cindex, M_UINT32  DATAWrite, char id_[20]);
	void Write_i2c(int BUSsel, int DEVid, int NIacc, int I2Cindex, M_UINT32  DATAWrite, char id_[20]);
	void Write_i2c(volatile FPGA_REGFILE_I2C_TYPE& rI2C, int BUSsel, int DEVid, int NIacc, int I2Cindex, M_UINT32  DATAWrite, char id_[20]);


private:
	






};
  

