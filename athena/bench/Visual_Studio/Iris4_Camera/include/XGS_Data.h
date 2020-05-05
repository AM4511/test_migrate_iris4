// XGS_Data.h



#include <math.h>
#include <vector>
#include "regfile_xgs_athena.h"
using namespace std;



//----------------------------
//-- Class CXGS_Data
//----------------------------
class CXGS_Data
{

public:
	
	CXGS_Data(volatile FPGA_REGFILE_XGS_ATHENA_TYPE& i_rXGSptr); //en attendant d'avoir un regfile pour le datapath
	~CXGS_Data();

	void Test();

	//Pointeur aux registres dans fpga 
	volatile FPGA_REGFILE_XGS_ATHENA_TYPE& rXGSptr;
	//Shadow registres  
	FPGA_REGFILE_XGS_ATHENA_TYPE sXGSptr;


private:
	
};
  

