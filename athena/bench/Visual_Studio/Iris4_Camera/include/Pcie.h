// PCIe.h



#include <math.h>
#include <vector>
#include "../../../../local_ip/pcie2AxiMaster_v3.0/sdk/pcie2AxiMaster.h"
using namespace std;



//----------------------------
//-- Class CPcie (MAIO)
//----------------------------
class CPcie
{

public:
	
	CPcie(volatile FPGA_PCIE2AXIMASTER_TYPE& i_rPcie); 
	~CPcie();



	//Pointeur aux registres dans fpga 
	volatile FPGA_PCIE2AXIMASTER_TYPE& rPcie_ptr;
	//Shadow registres  
	FPGA_PCIE2AXIMASTER_TYPE sPcie_ptr;

	void InitBar0Window(void);
	M_UINT32 Read_QSPI_ID(void);

private:
	
};
  

