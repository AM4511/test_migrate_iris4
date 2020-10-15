// Ares.h



#include <math.h>
#include <vector>
#include "../../../../../ares_pcie/registerfile/regfile_ares.h"
using namespace std;


//----------------------------
//-- Class CAres 
//----------------------------
class CAres
{

public:
	
	CAres(volatile FPGA_REGFILE_ARES_TYPE& i_rAres, int AresDetected);
	~CAres();



	//Pointeur aux registres dans fpga 
	volatile FPGA_REGFILE_ARES_TYPE& rAres_ptr;
	//Shadow registres  
	//FPGA_REGFILE_ARES_TYPE sAres_ptr;

	M_UINT32 Read_QSPI_ID(void);
	M_UINT32 Read_QSPI_DW(M_UINT32 address);
	void ArbiterTest(void);


private:
	
};
  

