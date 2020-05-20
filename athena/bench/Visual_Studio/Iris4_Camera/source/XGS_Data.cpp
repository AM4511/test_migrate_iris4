//
//

#define _CRT_SECURE_NO_DEPRECATE

#include "stdafx.h"
#include <stdio.h> 
#include <stdlib.h> 
#include <conio.h> 
#include <time.h>

#include <string>
using std::string;

#include "XGS_Data.h"

#include "mtxservmanager.h"

#include <iostream>

#include <algorithm>
#include <vector>
using namespace std;




CXGS_Data::CXGS_Data(volatile FPGA_REGFILE_XGS_ATHENA_TYPE& i_rXGSptr):
	rXGSptr(i_rXGSptr)
{
	memset(&sXGSptr, 0, sizeof(sXGSptr));
	memcpy(&sXGSptr, (const void*)& rXGSptr, sizeof(sXGSptr));

	//------------------------------------
    // GrabParams
    //------------------------------------
	DMAParams = {
		0,	  // M_UINT64 FSTART;
	    0,    // M_UINT64 FSTART_G;
	    0,    // M_UINT64 FSTART_R;
	    0,    // M_UINT32 LINE_PITCH;
	    0,    // M_UINT32 LINE_SIZE;
	    0,    // M_UINT32 COLOR_SPACE;
	};


}


CXGS_Data::~CXGS_Data()
{


}

//--------------------------------------------------------------------
// Cette fonction retourne le pointeur de la table de paramettre dma
//--------------------------------------------------------------------
DMAParamStruct* CXGS_Data::getDMAParams(void)
{
	return &DMAParams;
}



//--------------------------------------------------------------------
// Cette fonction Reset l'interface HiSPI
//--------------------------------------------------------------------
void CXGS_Data::HiSpiClr(void)
{
	printf("HiSPI logic reseted\n");
	sXGSptr.HISPI.CTRL.f.ENABLE_HISPI      = 0;
	sXGSptr.HISPI.CTRL.f.SW_CLR_IDELAYCTRL = 0;
	sXGSptr.HISPI.CTRL.f.SW_CLR_HISPI      = 1;
	rXGSptr.HISPI.CTRL.u32                 = sXGSptr.HISPI.CTRL.u32;
	Sleep(100);
	sXGSptr.HISPI.CTRL.f.SW_CLR_HISPI      = 0;
    rXGSptr.HISPI.CTRL.u32                 = sXGSptr.HISPI.CTRL.u32;
	Sleep(100);
}

//--------------------------------------------------------------------
// Cette fonction Calibre l'interface HiSPI
//--------------------------------------------------------------------
void CXGS_Data::HiSpiCalibrate(void)
{
	int count = 0;
	
	printf("HiSPI calibration...  ");
	sXGSptr.HISPI.CTRL.f.ENABLE_HISPI    = 1;
	sXGSptr.HISPI.CTRL.f.SW_CALIB_SERDES = 1;
	rXGSptr.HISPI.CTRL.u32               = sXGSptr.HISPI.CTRL.u32;
	sXGSptr.HISPI.CTRL.f.SW_CALIB_SERDES = 0;
	
	do 
	{
		Sleep(1);
		count++;
		if (count == 100) break;

	} while (rXGSptr.HISPI.STATUS.f.CALIBRATION_DONE == 0);

	if (rXGSptr.HISPI.STATUS.f.CALIBRATION_ERROR == 1 || rXGSptr.HISPI.STATUS.f.CALIBRATION_DONE == 0)
	{
		printf("Calibration ERROR\n");
		printf("  HISPI_STATUS          : 0x%X\n", rXGSptr.HISPI.STATUS.u32);
		printf("  IDELAYCTRL_STATUS     : 0x%X\n", rXGSptr.HISPI.IDELAYCTRL_STATUS.u32);
		printf("  LANE_DECODER_STATUS_0 : 0x%X\n", rXGSptr.HISPI.LANE_DECODER_STATUS[0].u32);
		printf("  LANE_DECODER_STATUS_1 : 0x%X\n", rXGSptr.HISPI.LANE_DECODER_STATUS[1].u32);
		printf("  LANE_DECODER_STATUS_2 : 0x%X\n", rXGSptr.HISPI.LANE_DECODER_STATUS[2].u32);
		printf("  LANE_DECODER_STATUS_3 : 0x%X\n", rXGSptr.HISPI.LANE_DECODER_STATUS[3].u32);
		printf("  LANE_DECODER_STATUS_4 : 0x%X\n", rXGSptr.HISPI.LANE_DECODER_STATUS[4].u32);
		printf("  LANE_DECODER_STATUS_5 : 0x%X\n", rXGSptr.HISPI.LANE_DECODER_STATUS[5].u32);
	}

	if (rXGSptr.HISPI.STATUS.f.CALIBRATION_ERROR == 0 && rXGSptr.HISPI.STATUS.f.CALIBRATION_DONE == 1) {
		printf("Calibration OK\n");
		rXGSptr.HISPI.CTRL.f.ENABLE_DATA_PATH = 1;
	}
}



//--------------------------------------------------------------------
// Cette fonction Programme les registres DMA
//--------------------------------------------------------------------
void CXGS_Data::SetDMA(void)
{
	//printf("Set DMA parameters\n");

	sXGSptr.DMA.CTRL.f.GRAB_QUEUE_EN = 1;
	rXGSptr.DMA.CTRL.u32             = sXGSptr.DMA.CTRL.u32;

    sXGSptr.DMA.FSTART.u32           = DMAParams.FSTART & 0xffffffff;                      // Lo DW ADD64
	rXGSptr.DMA.FSTART.u32           = sXGSptr.DMA.FSTART.u32;
								     
	sXGSptr.DMA.FSTART_HIGH.u32      = (DMAParams.FSTART & 0xffffffff00000000) >> 32;
	rXGSptr.DMA.FSTART_HIGH.u32      = sXGSptr.DMA.FSTART_HIGH.u32;
								     
	sXGSptr.DMA.FSTART_G.u32         = DMAParams.FSTART_G & 0xffffffff;                    // Lo DW ADD64
	rXGSptr.DMA.FSTART_G.u32         = sXGSptr.DMA.FSTART_G.u32;
								     
	sXGSptr.DMA.FSTART_G_HIGH.u32    = (DMAParams.FSTART_G & 0xffffffff00000000) >> 32;
	rXGSptr.DMA.FSTART_G_HIGH.u32    = sXGSptr.DMA.FSTART_G_HIGH.u32;
								     
	sXGSptr.DMA.FSTART_R.u32         = DMAParams.FSTART_R & 0xffffffff;                    // Lo DW ADD64
	rXGSptr.DMA.FSTART_R.u32         = sXGSptr.DMA.FSTART_R.u32;
								     
	sXGSptr.DMA.FSTART_R_HIGH.u32    = (DMAParams.FSTART_R & 0xffffffff00000000) >> 32;
	rXGSptr.DMA.FSTART_R_HIGH.u32    = sXGSptr.DMA.FSTART_R_HIGH.u32;
								     
	sXGSptr.DMA.LINE_PITCH.u32       = DMAParams.LINE_PITCH;
	rXGSptr.DMA.LINE_PITCH.u32       = sXGSptr.DMA.LINE_PITCH.u32;
								     
	sXGSptr.DMA.LINE_SIZE.u32        = DMAParams.LINE_SIZE;
	rXGSptr.DMA.LINE_SIZE.u32        = sXGSptr.DMA.LINE_SIZE.u32;
}

