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
	CI2C(unsigned char* I2C_regptr)
	{

		rI2C = (FPGA_REGFILE_I2C_TYPE*)(I2C_regptr); // Offset du premier registre du I2C 

	}


	~CI2C()
	{


	}
	
	volatile FPGA_REGFILE_I2C_TYPE* rI2C;       // HW pointer to reg
	volatile FPGA_REGFILE_I2C_TYPE* getRegisterI2C(void);

	// Fonctions I2C
	void Write_i2c(int BUSsel, int DEVid, int NIacc, int I2Cindex, M_UINT32  DATAWrite);// , char id_[20]);
	M_UINT32 Read_i2c(int BUSsel, int DEVid, int NIacc, int I2Cindex, int print_err);
	void Read_i2c_predic(int BUSsel, int DEVid, int NIacc, int I2Cindex, M_UINT32 DATAWrite);



private:
	






};
  

