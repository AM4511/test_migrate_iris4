// XGS_Ctrl.h



#include <math.h>
#include <vector>
#include "../../../../local_ip/XGS_athena/registerfile/regfile_xgs_athena.h"
using namespace std;




enum TRIGGER_SRC { NONE = 0, IMMEDIATE = 1, HW_TRIG = 2, SW_TRIG = 3, BURST = 4};
enum TRIGGER_ACT { RISING = 0, FALLING = 1, ANY_EDGE = 2, LEVEL_HI = 3, LEVEL_LO = 4, TIMER = 5 };
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

	M_UINT32 Y_START;
	M_UINT32 Y_END;

	M_UINT32 Y_START_ROI2;
	M_UINT32 Y_END_ROI2;

	M_UINT32 BLACK_OFFSET;

	M_UINT32 ANALOG_GAIN;
	M_UINT32 REVERSE_Y;
	M_UINT32 MONO10;

	M_UINT32 M_SUBSAMPLING_Y;
	M_UINT32 ACTIVE_SUBSAMPLING_Y;
	M_UINT32 SUBSAMPLING_X;

	M_UINT32 FOT;

	M_UINT32 XSM_DELAY;

	M_UINT32 XGS_LINE_SIZE_FACTOR;
	
};

struct SensorParamStruct
{
	M_UINT32 SENSOR_TYPE;
	M_UINT32 XGS_HiSPI_Ch;
	M_UINT32 XGS_X_START;
	M_UINT32 XGS_X_END;
	M_UINT32 XGS_X_SIZE;
	M_UINT32 Xsize_Full;
	M_UINT32 Ysize_Full;
	M_UINT32 Xsize_BL;

	M_UINT32 FOT;
	M_UINT32 BL_LINES;
	M_UINT32 EXP_DUMMY_LINES;

	M_UINT32 Trig_2_EXP;          // in ns
	M_UINT32 ReadOutN_2_TrigN;    // in ns
	M_UINT32 TrigN_2_FOT;         // in ns
	M_UINT32 EXP_FOT;             // in ns
	M_UINT32 EXP_FOT_TIME;        // in ns (Total)
	M_UINT32 KEEP_OUT_ZONE_START; // in pix clk
	
};





//----------------------------
//-- Class Iris4
//----------------------------
class CXGS_Ctrl
{

public:
	
	CXGS_Ctrl(volatile FPGA_REGFILE_XGS_ATHENA_TYPE& i_rXGSptr, double setSysPer, double setSensorPer);
	~CXGS_Ctrl();

	SensorParamStruct* getSensorParams(void);
	GrabParamStruct*   getGrabParams(void);

	GrabParamStruct   GrabParams;
	SensorParamStruct SensorParams;

	double SystemPeriodNanoSecond = 16.000000;
	//double SensorPeriodNanoSecond = 15.432099; //32.4Mhz
	double SensorPeriodNanoSecond = 15.625000; //32Mhz
	
	M_UINT32 CurrExposure;

	void PrintTime(void);

	//Pointeur aux registres dans fpga 
	volatile FPGA_REGFILE_XGS_ATHENA_TYPE& rXGSptr;
	//Shadow registres  
	FPGA_REGFILE_XGS_ATHENA_TYPE sXGSptr;

	// SPI interface 
	void WriteSPI(M_UINT32 address, M_UINT32 data);
	void WriteSPI_BURST(M_UINT32 tableau[500]);
	void WriteSPI_Bit(M_UINT32 address, M_UINT32 Bit2Write,  M_UINT32 data);
	M_UINT32 ReadSPI(M_UINT32 address);
	void PollRegSPI(M_UINT32 address, M_UINT32 maskN, M_UINT32 Data2Poll, M_UINT32 Delay, M_UINT32 TimeOut);
	void DumpRegSPI(M_UINT32 SPI_START, M_UINT32 SPI_RANGE);
	void ReadSPI_DumpFile(void);

	void InitXGS(void);
	void DisableXGS(void);

	void SetGrabParams(unsigned long Throttling = 0);
	M_UINT32 getExposure(void);
	void setExposure(M_UINT32 exposure_ss_us);
	void setAnalogGain(M_UINT32 gain);
	void setBlackRef(int value);
	void SetGrabMode(TRIGGER_SRC TRIGGER_SOURCE, TRIGGER_ACT TRIGGER_ACTIVATION);
	void EnableRegUpdate(void);
	void DisableRegUpdate(void);
	void WaitEndExpReadout(void);
	int  GrabAbort(void);
	void SetGrabCMD(unsigned long Throttling, int DoSleep);
	void SW_snapshot(int DoSleep);

	void XGS_PCIeCtrl_DumpFile(void);

	void StartHWTimerFPS(double FPS);
	void StartHWTimer(M_UINT32 TIMERDELAY, M_UINT32 TIMERDURATION);
	void StopHWTimer(void);

private:
	
	//Common for all DCF
	void XGS_Config_Monitor(void);
	void XGS_WaitRdy(void);
	void XGS_Activate_sensor(void);
	void XGS_CopyMirror_regs(void);
	void XGS_SetConfigFPGA(void);

	//XGS 16
	void XGS16M_SetGrabParamsInit16000(int lanes);
	void XGS16M_LoadDCF(int lanes);
	void XGS16M_Check_otpm_depended_uploads(void);
	void XGS16M_Enable6lanes(void);

	//XGS 12/9.6/8
	void XGS12M_SetGrabParamsInit12000(int lanes);
	void XGS12M_SetGrabParamsInit9400(int lanes);
	void XGS12M_SetGrabParamsInit8000(int lanes);
	void XGS12M_LoadDCF(int lanes);
	void XGS12M_Check_otpm_depended_uploads(void);
	void XGS12M_Enable6lanes(void);
	void XGS12M_Req_Reg_Up_0(void);
	void XGS12M_Req_Reg_Up_2(void);
	void XGS12M_Timing_Up(void);



	//XGS 5/3/1.3
	void XGS5M_SetGrabParamsInit5000(int lanes);
	void XGS5M_LoadDCF(int lanes);
	void XGS5M_Check_otpm_depended_uploads(void);
	void XGS5M_Enable4lanes(void);
};
  

