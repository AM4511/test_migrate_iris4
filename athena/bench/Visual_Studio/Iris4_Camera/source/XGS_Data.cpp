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
// Cette fonction Programme les registres DMA
//--------------------------------------------------------------------
void CXGS_Data::SetDMA(void)
{
	//printf("Set DMA parameters\n");

    sXGSptr.DMA.FSTART.u32         = DMAParams.FSTART & 0xffffffff;                      // Lo DW ADD64
	rXGSptr.DMA.FSTART.u32         = sXGSptr.DMA.FSTART.u32;

	sXGSptr.DMA.FSTART_HIGH.u32    = (DMAParams.FSTART & 0xffffffff00000000) >> 32;
	rXGSptr.DMA.FSTART_HIGH.u32    = sXGSptr.DMA.FSTART_HIGH.u32;

	sXGSptr.DMA.FSTART_G.u32       = DMAParams.FSTART_G & 0xffffffff;                    // Lo DW ADD64
	rXGSptr.DMA.FSTART_G.u32       = sXGSptr.DMA.FSTART_G.u32;

	sXGSptr.DMA.FSTART_G_HIGH.u32  = (DMAParams.FSTART_G & 0xffffffff00000000) >> 32;
	rXGSptr.DMA.FSTART_G_HIGH.u32  = sXGSptr.DMA.FSTART_G_HIGH.u32;

	sXGSptr.DMA.FSTART_R.u32       = DMAParams.FSTART_R & 0xffffffff;                    // Lo DW ADD64
	rXGSptr.DMA.FSTART_R.u32       = sXGSptr.DMA.FSTART_R.u32;

	sXGSptr.DMA.FSTART_R_HIGH.u32  = (DMAParams.FSTART_R & 0xffffffff00000000) >> 32;
	rXGSptr.DMA.FSTART_R_HIGH.u32  = sXGSptr.DMA.FSTART_R_HIGH.u32;

	sXGSptr.DMA.LINE_PITCH.u32     = DMAParams.LINE_PITCH;
	rXGSptr.DMA.LINE_PITCH.u32     = sXGSptr.DMA.LINE_PITCH.u32;

	sXGSptr.DMA.LINE_SIZE.u32      = DMAParams.LINE_SIZE;
	rXGSptr.DMA.LINE_SIZE.u32      = sXGSptr.DMA.LINE_SIZE.u32;
}


