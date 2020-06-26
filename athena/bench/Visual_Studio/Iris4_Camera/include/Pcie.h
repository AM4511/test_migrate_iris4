// PCIe.h



#include <math.h>
#include <vector>
#include "../../../../local_ip/pcie2AxiMaster_v3.0/design/registerfile/regfile_pcie2AxiMaster.h"
using namespace std;



//----------------------------
//-- Class CPcie (MAIO)
//----------------------------
class CPcie
{

public:
	
	CPcie(volatile FPGA_REGFILE_PCIE2AXIMASTER_TYPE& i_rPcie); 
	~CPcie();



	//Pointeur aux registres dans fpga 
	volatile FPGA_REGFILE_PCIE2AXIMASTER_TYPE& rPcie_ptr;
	//Shadow registres  
	FPGA_REGFILE_PCIE2AXIMASTER_TYPE sPcie_ptr;

	void InitBar0Window(void);
	M_UINT32 Read_QSPI_ID(void);
	M_UINT32 Read_QSPI_DW(M_UINT32 address);

private:
	
};
  

