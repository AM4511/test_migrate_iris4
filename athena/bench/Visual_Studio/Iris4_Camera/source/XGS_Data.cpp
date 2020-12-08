//
//

#define _CRT_SECURE_NO_DEPRECATE

#include "osincludes.h"

#include <string>
using std::string;

#include "XGS_Data.h"

#include "mtxservmanager.h"
#include "MilLayer.h"

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


//----------------------------------------------------
//
//  Print Time
//
//----------------------------------------------------
void CXGS_Data::PrintTime(void)
{

	time_t ltime;
	char* buf;

	time(&ltime);

	buf = ctime(&ltime);
	if (!buf)
	{
		printf("Invalid Arguments for ctime.\n");
	}
	printf("Current time is %s", buf);

}

//--------------------------------------------------------------------
// Cette fonction Reset l'interface HiSPI
//--------------------------------------------------------------------
void CXGS_Data::HiSpiClr(void)
{
	printf("HiSPI logic reseted\n");
	sXGSptr.HISPI.CTRL.f.ENABLE_DATA_PATH  = 0;
	rXGSptr.HISPI.CTRL.u32                 = sXGSptr.HISPI.CTRL.u32;
	Sleep(100);

	// RESET HISPI
	sXGSptr.HISPI.CTRL.f.ENABLE_HISPI      = 0;
	sXGSptr.HISPI.CTRL.f.SW_CLR_IDELAYCTRL = 0;
	sXGSptr.HISPI.CTRL.f.SW_CLR_HISPI      = 1;
	rXGSptr.HISPI.CTRL.u32                 = sXGSptr.HISPI.CTRL.u32;
	Sleep(100);
	
	// RESET all LANE_DECODER_STATUS ERRORS (R/W2C)
	sXGSptr.HISPI.LANE_DECODER_STATUS[0].u32   = rXGSptr.HISPI.LANE_DECODER_STATUS[0].u32;
	rXGSptr.HISPI.LANE_DECODER_STATUS[0].u32   = sXGSptr.HISPI.LANE_DECODER_STATUS[0].u32;
	sXGSptr.HISPI.LANE_DECODER_STATUS[1].u32   = rXGSptr.HISPI.LANE_DECODER_STATUS[1].u32;
	rXGSptr.HISPI.LANE_DECODER_STATUS[1].u32   = sXGSptr.HISPI.LANE_DECODER_STATUS[1].u32;
	sXGSptr.HISPI.LANE_DECODER_STATUS[2].u32   = rXGSptr.HISPI.LANE_DECODER_STATUS[2].u32;
	rXGSptr.HISPI.LANE_DECODER_STATUS[2].u32   = sXGSptr.HISPI.LANE_DECODER_STATUS[2].u32;
	sXGSptr.HISPI.LANE_DECODER_STATUS[3].u32   = rXGSptr.HISPI.LANE_DECODER_STATUS[3].u32;
	rXGSptr.HISPI.LANE_DECODER_STATUS[3].u32   = sXGSptr.HISPI.LANE_DECODER_STATUS[3].u32;
	sXGSptr.HISPI.LANE_DECODER_STATUS[4].u32   = rXGSptr.HISPI.LANE_DECODER_STATUS[4].u32;
	rXGSptr.HISPI.LANE_DECODER_STATUS[4].u32   = sXGSptr.HISPI.LANE_DECODER_STATUS[4].u32;
	sXGSptr.HISPI.LANE_DECODER_STATUS[5].u32   = rXGSptr.HISPI.LANE_DECODER_STATUS[5].u32;
	rXGSptr.HISPI.LANE_DECODER_STATUS[5].u32   = sXGSptr.HISPI.LANE_DECODER_STATUS[5].u32;

	// RESET all LANE_PACKER_STATUS ERRORS (R/W2C)
	/*
	sXGSptr.HISPI.LANE_PACKER_STATUS[0].u32    = rXGSptr.HISPI.LANE_PACKER_STATUS[0].u32;
	rXGSptr.HISPI.LANE_PACKER_STATUS[0].u32    = sXGSptr.HISPI.LANE_PACKER_STATUS[0].u32;
	sXGSptr.HISPI.LANE_PACKER_STATUS[1].u32    = rXGSptr.HISPI.LANE_PACKER_STATUS[1].u32;
	rXGSptr.HISPI.LANE_PACKER_STATUS[1].u32    = sXGSptr.HISPI.LANE_PACKER_STATUS[1].u32;
	sXGSptr.HISPI.LANE_PACKER_STATUS[2].u32    = rXGSptr.HISPI.LANE_PACKER_STATUS[2].u32;
	rXGSptr.HISPI.LANE_PACKER_STATUS[2].u32    = sXGSptr.HISPI.LANE_PACKER_STATUS[2].u32;
	*/
	// UN-RESET HISPI
	sXGSptr.HISPI.CTRL.f.SW_CLR_HISPI      = 0;
    rXGSptr.HISPI.CTRL.u32                 = sXGSptr.HISPI.CTRL.u32;
	Sleep(100);
}

//--------------------------------------------------------------------
// Cette fonction Calibre l'interface HiSPI
//--------------------------------------------------------------------
int CXGS_Data::HiSpiCalibrate(int echoo)
{
	int count = 0;
	
	//clear old flags
	rXGSptr.HISPI.LANE_DECODER_STATUS[0].u32 = 0xffffffff; //all flags are R or RWc2
	rXGSptr.HISPI.LANE_DECODER_STATUS[1].u32 = 0xffffffff; //all flags are R or RWc2
	rXGSptr.HISPI.LANE_DECODER_STATUS[2].u32 = 0xffffffff; //all flags are R or RWc2
	rXGSptr.HISPI.LANE_DECODER_STATUS[3].u32 = 0xffffffff; //all flags are R or RWc2
	rXGSptr.HISPI.LANE_DECODER_STATUS[4].u32 = 0xffffffff; //all flags are R or RWc2
	rXGSptr.HISPI.LANE_DECODER_STATUS[5].u32 = 0xffffffff; //all flags are R or RWc2

	//rXGSptr.HISPI.LANE_PACKER_STATUS[0].u32 = 0xffffffff; //all flags are R or RWc2
	//rXGSptr.HISPI.LANE_PACKER_STATUS[1].u32 = 0xffffffff; //all flags are R or RWc2
	//rXGSptr.HISPI.LANE_PACKER_STATUS[2].u32 = 0xffffffff; //all flags are R or RWc2
	
    //At least, is sensor powerOn an unreset ?
	if ((rXGSptr.ACQ.SENSOR_STAT.u32 & 0x3103) == 0x3103) {
		if(echoo==1) printf("\nStarting HiSPI calibration...  ");
		sXGSptr.HISPI.CTRL.f.ENABLE_HISPI = 1;
		sXGSptr.HISPI.CTRL.f.SW_CALIB_SERDES = 1;
		rXGSptr.HISPI.CTRL.u32 = sXGSptr.HISPI.CTRL.u32;
		sXGSptr.HISPI.CTRL.f.SW_CALIB_SERDES = 0;

		do
		{
			Sleep(1);
			count++;
			if (count == 100) break;

		} while (rXGSptr.HISPI.STATUS.f.CALIBRATION_DONE == 0);

		sXGSptr.HISPI.STATUS.u32 = rXGSptr.HISPI.STATUS.u32;
		if (sXGSptr.HISPI.STATUS.f.CALIBRATION_ERROR == 1 || sXGSptr.HISPI.STATUS.f.CALIBRATION_DONE == 0 || sXGSptr.HISPI.STATUS.f.PHY_BIT_LOCKED_ERROR == 1 || sXGSptr.HISPI.STATUS.f.CRC_ERROR == 1)
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
			//printf("  LANE_PACKER_STATUS_0  : 0x%X\n", rXGSptr.HISPI.LANE_PACKER_STATUS[0].u32);
			//printf("  LANE_PACKER_STATUS_1  : 0x%X\n", rXGSptr.HISPI.LANE_PACKER_STATUS[1].u32);
			//printf("  LANE_PACKER_STATUS_2  : 0x%X\n", rXGSptr.HISPI.LANE_PACKER_STATUS[2].u32);
			return 0;
		}

		if (sXGSptr.HISPI.STATUS.f.CALIBRATION_ERROR == 0 && sXGSptr.HISPI.STATUS.f.CALIBRATION_DONE == 1) {
			if (echoo == 1) printf("Calibration OK \n");
			sXGSptr.HISPI.CTRL.f.ENABLE_DATA_PATH = 1;
			rXGSptr.HISPI.CTRL.u32 = sXGSptr.HISPI.CTRL.u32;
			return 1;
		}
	}
	else {
		printf("Sensor not poweredUP!!! \n");
		return 0;
	}
	printf("Why the heck we ended up here??? \n");
	return 0;
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



//---------------------------------------------------------------------------------------
//
// Cette fonction retourne un pixel 8 bits de l'image en memoire Host
//
// Si cette fonction est utilise pour detecter des overruns de l'image (test0004):
//
// 1) Le BUffer DMA dois etre plus grand que la taille de l'image totale pour utiliser cette
//    fonction.
//
// 2) Le buffer DMA est initialise a 0 lors du alloc, la detection peux-etre detecte si le 
//    pixel retourne est different de 0
//
//---------------------------------------------------------------------------------------
M_UINT32 CXGS_Data::GetImagePixel8(M_UINT64 ImageBufferAddr_SRC, M_UINT32 X_POS, M_UINT32 Y_POS, M_UINT64 LINE_PITCH)
{
	M_UINT32 PixelValue = 0;
	M_UINT64 PixelAdd = 0;

	volatile M_UINT8* SrcImgPtr;
	SrcImgPtr = (M_UINT8*)ImageBufferAddr_SRC;

	//Address generation
	PixelAdd   = (LINE_PITCH * ((M_UINT64)Y_POS)) + X_POS ;  // Location in the image valid in memory
	PixelValue = *(SrcImgPtr + PixelAdd);                    // Read 8bit pixel from image

    return(PixelValue);
}

void CXGS_Data::SetImagePixel8(M_UINT64 ImageBufferAddr_SRC, M_UINT32 X_POS, M_UINT32 Y_POS, M_UINT64 LINE_PITCH, M_UINT32 PixelValue)
{
	M_UINT64 PixelAdd   = 0;

	volatile M_UINT8* SrcImgPtr;
	SrcImgPtr = (M_UINT8*)ImageBufferAddr_SRC;

	//Address generation
	PixelAdd = (LINE_PITCH * ((M_UINT64)Y_POS)) + X_POS;    // Location in the image valid in memory
	*(SrcImgPtr + PixelAdd)= PixelValue;                    // Write 8bit pixel from image

}


//---------------------------------------------------------------------------------------
//
// Check for HISPI errors
//
//---------------------------------------------------------------------------------------

M_UINT32 CXGS_Data::HiSpiCheck(void)
{
	M_UINT32 Register;

	M_UINT32 Reg_HISPI_CTRL;
	M_UINT32 Reg_HISPI_STATUS;
	M_UINT32 Reg_HISPI_DEC_STATUS[6]  = {0,0,0,0,0,0};
	M_UINT32 Reg_HISPI_PACK_STATUS[3] = {0,0,0};
	int i = 0;

	M_UINT32 error_detect=0;
	char ch;
	M_UINT32 Stop_test = 0;

	Register         = rXGSptr.HISPI.STATUS.u32;
	Reg_HISPI_STATUS = Register;
	if ( (Register & 0x00000002) == 0x002)  { printf("\nHISPI_STATUS, CALIBRATION ERROR");    error_detect = 1; }
	if ( (Register & 0x00000004) == 0x004)  { printf("\nHISPI_STATUS, FIFO ERROR");			  error_detect = 1; }
	if ( (Register & 0x00000008) == 0x008)  { printf("\nHISPI_STATUS, PHY_BIT_LOCKED_ERROR"); error_detect = 1; }
	if ( (Register & 0x00000010) == 0x010)  { printf("\nHISPI_STATUS, CRC_ERROR");            error_detect = 1; }


	for (M_UINT32 i = 0; i < rXGSptr.HISPI.PHY.f.NB_LANES; i++)
	{
		Register                = rXGSptr.HISPI.LANE_DECODER_STATUS[i].u32;
		Reg_HISPI_DEC_STATUS[i] = Register;
		if ( (Register & 0x00000001)  == 0x001)  { printf("\nLANE_DECODER_STATUS_[%d], FIFO_OVERRUN", i);           error_detect = 1; } 
		if ( (Register & 0x00000002)  == 0x002)  { printf("\nLANE_DECODER_STATUS_[%d], FIFO_UNDERRUN", i);			error_detect = 1; } 
		if ( (Register & 0x00000008)  == 0x008)  { printf("\nLANE_DECODER_STATUS_[%d], CALIBRATION_ERROR", i);		error_detect = 1; } 
		if ( (Register & 0x00002000)  == 0x2000) { printf("\nLANE_DECODER_STATUS_[%d], PHY_BIT_LOCKED_ERROR", i);	error_detect = 1; }
		if ( (Register & 0x00004000)  == 0x4000) { printf("\nLANE_DECODER_STATUS_[%d], PHY_SYNC_ERROR", i);			error_detect = 1; }
		if ( (Register & 0x00008000)  == 0x8000) { printf("\nLANE_DECODER_STATUS_[%d], CRC_ERROR", i);			    error_detect = 1; }
	}

	/*for (M_UINT32 i = 0; i < (rXGSptr.HISPI.PHY.f.NB_LANES/2); i++)
	{
		Register                 = rXGSptr.HISPI.LANE_PACKER_STATUS[i].u32;
		Reg_HISPI_PACK_STATUS[i] = Register;
		if ( (Register & 0x00000001) == 0x001) { printf("\nLANE_PACKER_STATUS_[%d], FIFO_OVERRUN", i);              error_detect = 1; }
		if ( (Register & 0x00000002) == 0x002) { printf("\nLANE_PACKER_STATUS_[%d], FIFO_UNDERRUN", i);				error_detect = 1; }
	}		*/					   

	if (error_detect == 1)
	{
		printf("\n\n");
		printf("DMA.OUTPUT_BUFFER.f.MAX_LINE_BUFF_CNT   : 0x%X\n", rXGSptr.DMA.OUTPUT_BUFFER.f.MAX_LINE_BUFF_CNT);
		printf("DMA.OUTPUT_BUFFER.f.PCIE_BACK_PRESSURE  : 0x%X\n", rXGSptr.DMA.OUTPUT_BUFFER.f.PCIE_BACK_PRESSURE);
		printf("\n");
		Reg_HISPI_CTRL = rXGSptr.HISPI.CTRL.u32;
		printf("HISPI CTRL         : 0x%X\n",   Reg_HISPI_CTRL);
		printf("HISPI STATUS       : 0x%X\n",   Reg_HISPI_STATUS);
		printf("HISPI DEC0_STATUS  : 0x%X\n",   Reg_HISPI_DEC_STATUS[0]);
		printf("HISPI DEC1_STATUS  : 0x%X\n",   Reg_HISPI_DEC_STATUS[1]);
		printf("HISPI DEC2_STATUS  : 0x%X\n",   Reg_HISPI_DEC_STATUS[2]);
		printf("HISPI DEC3_STATUS  : 0x%X\n",   Reg_HISPI_DEC_STATUS[3]);
		printf("HISPI DEC4_STATUS  : 0x%X\n",   Reg_HISPI_DEC_STATUS[4]);
		printf("HISPI DEC5_STATUS  : 0x%X\n",   Reg_HISPI_DEC_STATUS[5]);
		printf("HISPI PACK0_STATUS : 0x%X\n",   Reg_HISPI_PACK_STATUS[0]);
		printf("HISPI PACK1_STATUS : 0x%X\n",   Reg_HISPI_PACK_STATUS[1]);
		printf("HISPI PACK2_STATUS : 0x%X\n", Reg_HISPI_PACK_STATUS[2]);
		for (M_UINT32 i = 0; i < rXGSptr.HISPI.PHY.f.NB_LANES; i++)
			printf("TAP_HISTOGRAM_%d : 0x%X\n", i, rXGSptr.HISPI.TAP_HISTOGRAM[i].u32);

		printf("\n\nError detected at : ");
		PrintTime();

		if (rXGSptr.DMA.TLP.f.MAX_PAYLOAD != rXGSptr.DMA.TLP.f.CFG_MAX_PLD) {
			if (rXGSptr.DMA.TLP.f.CFG_MAX_PLD == 0) printf("\nFifo overrun Warning: PCIe MAX payload annonced by fpga is %d bytes, Bios program  128 bytes  \n", rXGSptr.DMA.TLP.f.MAX_PAYLOAD);
			if (rXGSptr.DMA.TLP.f.CFG_MAX_PLD == 1) printf("\nFifo overrun Warning: PCIe MAX payload annonced by fpga is %d bytes, Bios program  256 bytes  \n", rXGSptr.DMA.TLP.f.MAX_PAYLOAD);
			if (rXGSptr.DMA.TLP.f.CFG_MAX_PLD == 2) printf("\nFifo overrun Warning: PCIe MAX payload annonced by fpga is %d bytes, Bios program  512 bytes  \n", rXGSptr.DMA.TLP.f.MAX_PAYLOAD);
			if (rXGSptr.DMA.TLP.f.CFG_MAX_PLD == 3) printf("\nFifo overrun Warning: PCIe MAX payload annonced by fpga is %d bytes, Bios program 1024 bytes \n", rXGSptr.DMA.TLP.f.MAX_PAYLOAD);
		}
		
		if (rXGSptr.DMA.TLP.f.MAX_PAYLOAD == 256 and rXGSptr.DMA.TLP.f.CFG_MAX_PLD==0)  // bios program 128
			printf("\nFifo overrun Warning: PCIe MAX payload annonced by fpga is %d bytes, Bios program  128 bytes  \n", rXGSptr.DMA.TLP.f.MAX_PAYLOAD);
		if (rXGSptr.DMA.TLP.f.MAX_PAYLOAD == 256 and rXGSptr.DMA.TLP.f.CFG_MAX_PLD == 1)  // bios program 256
			printf("\nPCIe MAX payload is optimal (256 bytes)  \n");

		printf("\nPress 'c' to continue without recover HI_SPI\n");
		printf("Press 'r' to try to recover HI_SPI and continue this test\n");
		printf("Press 'q' to quit this test and try to recover HI_SPI\n");

		ch = _getch();

		switch (ch)
		{
		case 'q':
			Stop_test = 1;
			HiSpiClr();
			HiSpiCalibrate(1);
			break;

		case 'c':
			printf("\n(c) Continuing...\n");
			Stop_test = 0;
			break;

		case 'r':
			printf("\n(r) Recovering...\n");
			Stop_test = 0;
			HiSpiClr();
			HiSpiCalibrate(1);
			break;
		}
	}

	return Stop_test;
}


//---------------------------------------------------------------------------------------
//
// Program LUTs
//
//---------------------------------------------------------------------------------------
void CXGS_Data::ProgramLUT(M_UINT32 LUT_TYPE)
{
	rXGSptr.LUT.LUT_CTRL.f.LUT_BYPASS = 1; // bypass
	rXGSptr.LUT.LUT_CTRL.f.LUT_SEL    = 8; // All LUT
	rXGSptr.LUT.LUT_CTRL.f.LUT_WRN    = 1; // WRITE LUT
	
	//Transparent 10 a 8 (Compression 10 a 8) 
	if (LUT_TYPE == 0) { 
		printf("\nLUT is now 10 to 8 bits Compression (Transparent)\n");
		for (int i = 0; i < 1024; i++) {
			rXGSptr.LUT.LUT_CTRL.f.LUT_ADD    = i;
			rXGSptr.LUT.LUT_CTRL.f.LUT_DATA_W = i>>2;
			rXGSptr.LUT.LUT_CTRL.f.LUT_SS     = 1;
		}
	}
	//Inverted 10 a 8 (8 MSB) 
	else if (LUT_TYPE == 1) {
		printf("\nLUT is now 10 to 8 bits Compression (Inverted)\n");
		for (int i = 0; i < 1024; i++) {
			rXGSptr.LUT.LUT_CTRL.f.LUT_ADD = i;
			rXGSptr.LUT.LUT_CTRL.f.LUT_DATA_W = 255-(i >> 2);
			rXGSptr.LUT.LUT_CTRL.f.LUT_SS = 1;
		}
	}
	//Transparent 10 a 8 (8 LSB  of 10 bits) 
	else if (LUT_TYPE == 2) {
		printf("\nLUT is now 10 to 8 bits, 8LSB bits of 10 bits\n");
		for (int i = 0; i < 256; i++) {
			rXGSptr.LUT.LUT_CTRL.f.LUT_ADD    = i;
			rXGSptr.LUT.LUT_CTRL.f.LUT_DATA_W = i ;
			rXGSptr.LUT.LUT_CTRL.f.LUT_SS     = 1;
		}
		for (int i = 256; i < 1024; i++) {
			rXGSptr.LUT.LUT_CTRL.f.LUT_ADD    = i;
			rXGSptr.LUT.LUT_CTRL.f.LUT_DATA_W = 0xff;
			rXGSptr.LUT.LUT_CTRL.f.LUT_SS     = 1;
		}

	}


}


void CXGS_Data::EnableLUT(void)
{
	rXGSptr.LUT.LUT_CTRL.f.LUT_BYPASS = 0;
}


void CXGS_Data::DisableLUT(void)
{
	rXGSptr.LUT.LUT_CTRL.f.LUT_BYPASS = 1;
}

