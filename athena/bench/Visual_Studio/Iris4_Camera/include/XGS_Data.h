// XGS_Data.h



#include <math.h>
#include <vector>
#include "hispi_registerfile.h"
using namespace std;



//----------------------------
//-- Class CXGS_Data
//----------------------------
class CXGS_Data
{

public:
	
	CXGS_Data(volatile FPGA_HISPI_REGISTERFILE_TYPE& i_rXGSptr); //en attendant d'avoir un regfile pour le datapath
	~CXGS_Data();

	void Test();

	//Pointeur aux registres dans fpga 
	volatile FPGA_HISPI_REGISTERFILE_TYPE& rXGSptr;
	//Shadow registres  
	FPGA_HISPI_REGISTERFILE_TYPE sXGSptr;


private:
	
};
  

