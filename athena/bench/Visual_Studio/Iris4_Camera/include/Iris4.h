// Iris4.h



#include <math.h>
#include <vector>
#include "regfile_xgs_ctrl.h"
using namespace std;


//----------------------------
//-- Class Iris4
//----------------------------
class CIris4
{

public:
	CIris4(long long setSysPerFs, long long setSensorPerFs, unsigned char* IRIS4_regptr0)
	{

		SystemPeriodFemtoSecond = setSysPerFs;
		SensorPeriodFemtoSecond = setSensorPerFs;

		rXGSptr = (FPGA_REGFILE_XGS_CTRL_TYPE*)(IRIS4_regptr0 + 0x0);     // Offset du premier registre du regfileXGS ctrl par rapport au BAR0

	}


	~CIris4()
	{


	}
	
	volatile FPGA_REGFILE_XGS_CTRL_TYPE* rXGSptr;

	volatile FPGA_REGFILE_XGS_CTRL_TYPE* getRegisterCTRL(void);

private:
	

	long long SystemPeriodFemtoSecond;
	long long SensorPeriodFemtoSecond;





};
  

