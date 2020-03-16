// XGS_Ctrl.h



#include <math.h>
#include <vector>
#include "regfile_xgs_ctrl.h"
using namespace std;


//----------------------------
//-- Class Iris4
//----------------------------
class CXGS_Ctrl
{

public:
	CXGS_Ctrl(double setSysPer, double setSensorPer, unsigned char* IRIS4_regptr0)
	{

		double SystemPeriodNanoSecond = setSysPer;
		double SensorPeriodNanoSecond = setSensorPer;

		rXGSptr = (FPGA_REGFILE_XGS_CTRL_TYPE*)(IRIS4_regptr0 + 0x0);     // Offset du premier registre du regfileXGS ctrl par rapport au BAR0

		memset(&sXGSptr, 0, sizeof(sXGSptr));                             // Init shadow
		memcpy(&sXGSptr, (const void*)& rXGSptr, sizeof(sXGSptr));

	}


	~CXGS_Ctrl()
	{


	}
	
	volatile FPGA_REGFILE_XGS_CTRL_TYPE* rXGSptr;       // HW pointer to reg
	FPGA_REGFILE_XGS_CTRL_TYPE*          sXGSptr;       // Shadow registers

	volatile FPGA_REGFILE_XGS_CTRL_TYPE* getRegisterXGS_Ctrl(void);

	// SPI interface 
	void WriteSPI(M_UINT32 address, M_UINT32 data);
	void WriteSPI_Bit(M_UINT32 address, M_UINT32 Bit2Write,  M_UINT32 data);
	M_UINT32 ReadSPI(M_UINT32 address);
	void PollRegSPI(M_UINT32 address, M_UINT32 maskN, M_UINT32 Data2Poll, M_UINT32 Delay, M_UINT32 TimeOut);
	void DumpRegSPI(M_UINT32 SPI_START, M_UINT32 SPI_END);
	void ReadSPI_DumpFile(void);

	void InitXGS(void);

	void Initialize_sensor(void);
	void Check_otpm_depended_uploads(void);
	void Enable6lanes(void);
	void Activate_sensor(void);


private:
	

	double SystemPeriodNanoSecond;
	double SensorPeriodNanoSecond;





};
  

