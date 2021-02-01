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
	M_UINT32 Y_SIZE;
	M_UINT32 REVERSE_Y;
	M_UINT32 REVERSE_X;
	M_UINT32 SUB_X;

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

	void PrintTime();

	void HiSpiClr();
	int HiSpiCalibrate(int echoo);
	void SetDMA();
	M_UINT32 HiSpiCheck(M_UINT64 GrabCmd);

	M_UINT32 GetImagePixel8(M_UINT64 ImageBufferAddr_SRC, M_UINT32 X_POS, M_UINT32 Y_POS, M_UINT64 LINE_PITCH);
	void     SetImagePixel8(M_UINT64 ImageBufferAddr_SRC, M_UINT32 X_POS, M_UINT32 Y_POS, M_UINT64 LINE_PITCH, M_UINT32 PixelValue);

	void ProgramLUT(M_UINT32 LUT_TYPE);
	void EnableLUT(void);
	void DisableLUT(void);

	//Pointeur aux registres dans fpga 
	volatile FPGA_REGFILE_XGS_ATHENA_TYPE& rXGSptr;
	//Shadow registres  
	FPGA_REGFILE_XGS_ATHENA_TYPE sXGSptr;

	void set_DMA_revY(M_UINT32 REV_Y, M_UINT32 Y_SIZE);
	void set_DMA_revX(M_UINT32 REV_X);
	void set_DMA_subX(M_UINT32 SUB_X);



private:
	
};
  

