// XGS_Data.h



#include <math.h>
#include <vector>
#include "../../../../local_ip/XGS_athena/registerfile/regfile_xgs_athena.h"
using namespace std;



struct DMAParamStruct
{
	M_UINT64 FSTART;
	M_UINT64 FSTART_G;
	M_UINT64 FSTART_R;
	M_UINT32 LINE_PITCH;
	M_UINT32 LINE_SIZE;
	M_UINT32 COLOR_SPACE;
};


//----------------------------
//-- Class CXGS_Data
//----------------------------
class CXGS_Data
{

public:
	
	CXGS_Data(volatile FPGA_REGFILE_XGS_ATHENA_TYPE& i_rXGSptr); //en attendant d'avoir un regfile pour le datapath
	~CXGS_Data();

	DMAParamStruct DMAParams;
	DMAParamStruct* getDMAParams(void);

	void HiSpiClr();
	void HiSpiCalibrate();
	void SetDMA();
	M_UINT32 HiSpiCheck();

	M_UINT32 GetImagePixel8(M_UINT64 ImageBufferAddr_SRC, M_UINT32 X_POS, M_UINT32 Y_POS, M_UINT64 LINE_PITCH);
	void     SetImagePixel8(M_UINT64 ImageBufferAddr_SRC, M_UINT32 X_POS, M_UINT32 Y_POS, M_UINT64 LINE_PITCH, M_UINT32 PixelValue);
	//Pointeur aux registres dans fpga 
	volatile FPGA_REGFILE_XGS_ATHENA_TYPE& rXGSptr;
	//Shadow registres  
	FPGA_REGFILE_XGS_ATHENA_TYPE sXGSptr;


private:
	
};
  

