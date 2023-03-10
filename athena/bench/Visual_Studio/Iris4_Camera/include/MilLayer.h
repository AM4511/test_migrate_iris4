//-----------------------------------------------
//
//  To COMPILE THIS CODE FOR XP:
//  IRIS3->Properties->Configuration Properties->General->Platform toolset -> Visual Studio 2013 - Windows XP (v120_xp)
//
//  Others:
//  IRIS3->Properties->Configuration Properties->General->Platform toolset -> Visual Studio 2013 (v120)
//
//-----------------------------------------------

#pragma once
#ifndef _MILLAYER_
#define _MILLAYER_

/* Headers */
#include "mbasictypes.h"
#include "mil.h"

void MilLayerAlloc(void);

volatile unsigned char * getMilLayerRegisterPtr(M_UINT32 regId, M_UINT64 fpga_bar0_add);
//unsigned char * getMilLayerRegisterPtr2(M_UINT64 fpga_bar0_add);

M_UINT64  LayerCreateGrabBuffer(MIL_ID *GrabBuffer, M_UINT32 Xsize, M_UINT32 Ysize, int PixelType_bpp=8);
void LayerInitDisplay(MIL_ID GrabBuffer, MIL_ID *MilDisplay, int DisplayNum = 1);
void LayerInitDisplay(MIL_ID GrabBuffer, MIL_ID *MilDisplay, char DisplayInfo[20]);
M_UINT64  LayerGetHostAddressBuffer(MIL_ID GrabBuffer);
M_UINT64  LayerGetPhysicalAddressBuffer(MIL_ID GrabBuffer);
void IrisMilFree(void);

#endif