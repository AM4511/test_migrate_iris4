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
	
	CXGS_Ctrl(volatile FPGA_REGFILE_XGS_CTRL_TYPE& i_rXGSptr, double setSysPer, double setSensorPer);
	~CXGS_Ctrl();

	//Pointeur aux registres dans fpga 
	volatile FPGA_REGFILE_XGS_CTRL_TYPE& rXGSptr;
	//Shadow registres  
	FPGA_REGFILE_XGS_CTRL_TYPE sXGSptr;

	// SPI interface 
	void WriteSPI(M_UINT32 address, M_UINT32 data);
	void WriteSPI_BURST(M_UINT32 tableau[500]);
	void WriteSPI_Bit(M_UINT32 address, M_UINT32 Bit2Write,  M_UINT32 data);
	M_UINT32 ReadSPI(M_UINT32 address);
	void PollRegSPI(M_UINT32 address, M_UINT32 maskN, M_UINT32 Data2Poll, M_UINT32 Delay, M_UINT32 TimeOut);
	void DumpRegSPI(M_UINT32 SPI_START, M_UINT32 SPI_END);
	void ReadSPI_DumpFile(void);

	void InitXGS(void);

	void Initialize_sensor(void);
	void Check_otpm_depended_uploads(void);
	void Enable6lanes(void);
	void Enable24lanes(void);
	void Activate_sensor(void);


private:
	
	double SystemPeriodNanoSecond= 16.000000;
	double SensorPeriodNanoSecond= 15.432099;

	enum TRIGGER_SRC { NONE = 0, IMMEDIATE = 1, HW_TRIG = 2, SW_TRIG = 3, BURST = 4 };
	enum TRIGGER_ACT { RISING = 0, FALLING = 1, ANY_EDGE = 2, LEVEL_HI = 3, LEVEL_LO = 4 };
	enum LEVEL_EXP_MODE { EXP_TIMED_MODE = 0, EXP_TRIGGER_WIDTH = 1 };

	struct GrabParamStruct
	{
		M_UINT32 TRIGGER_OVERLAP_BUFFN;
		M_UINT32 TRIGGER_OVERLAP;
		TRIGGER_SRC TRIGGER_SRC;
		TRIGGER_ACT TRIGGER_ACT;
		LEVEL_EXP_MODE EXPOSURE_LEV_MODE;

		M_UINT32 Exposure;
		M_UINT32 ExposureDS;
		M_UINT32 ExposureTS;

		M_UINT32 TRIGGER_DELAY;

		M_UINT32 STROBE_E;
		M_UINT32 STROBE_MODE;
		M_UINT32 STROBE_START;
		M_UINT32 STROBE_END;

		M_UINT32 GRAB_BUFFER_ID;
		M_UINT64 FrameStart;
		M_UINT64 FrameStartG;
		M_UINT64 FrameStartR;
		M_UINT32 LinePitch;
		M_UINT32 COLOR_SPACE;
		M_UINT32 X_START;
		M_UINT32 X_END;
		M_UINT32 Y_START;
		M_UINT32 Y_END;

		M_UINT32 X_START_ROI2;
		M_UINT32 X_END_ROI2;
		M_UINT32 Y_START_ROI2;
		M_UINT32 Y_END_ROI2;

		M_UINT32 BLACK_OFFSET;

		M_UINT32 MUX_GAINSW0;
		M_UINT32 AFE_GAIN0;
		M_UINT32 REVERSE_Y;
		M_UINT32 REVERSE_X;
		M_UINT32 MONO10;
		M_UINT32 BINNING_MODE;
		M_UINT32 SUB_MODE;

		M_UINT32 BINNING;
		M_UINT32 SUBSAMPLING;

		M_UINT32 FOT;
		M_UINT32 ROT;
		M_UINT32 ROT_BIN;

		M_UINT32 XSM_DELAY;

	};

	struct SensorParamStruct
	{
		M_UINT32 SENSOR_TYPE;

		M_UINT32 Python_LVDS_Ch;

		M_UINT32 Xsize_Full;
		M_UINT32 Ysize_Full;
		M_UINT32 Xsize_BL;

		M_UINT32 DelaiDummyBLExp; //This delai is the delai in NZROT between the BL line before and after exposure starts in PET engin
		M_UINT32 FOT;
		M_UINT32 ROT;
		M_UINT32 ROT_BIN;
		M_UINT32 BL_LINES;
		M_UINT32 EXP_DUMMY_LINES;

	};



};
  

