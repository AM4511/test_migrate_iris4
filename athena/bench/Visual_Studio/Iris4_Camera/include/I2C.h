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
	CI2C(volatile FPGA_REGFILE_I2C_TYPE& i_rI2Cptr);
	~CI2C();
	
	
	
	//Pointeur aux registres dans fpga 
	volatile FPGA_REGFILE_I2C_TYPE& rI2Cptr;

	// Fonctions I2C
	void Write_i2c(int BUSsel, int DEVid, int NIacc, int I2Cindex, M_UINT32  DATAWrite);// , char id_[20]);
	M_UINT32 Read_i2c(int BUSsel, int DEVid, int NIacc, int I2Cindex, int print_err);
	void Read_i2c_predic(int BUSsel, int DEVid, int NIacc, int I2Cindex, M_UINT32 DATAWrite);



private:
	






};
  

