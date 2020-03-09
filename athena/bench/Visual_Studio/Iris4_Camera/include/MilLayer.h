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
#include "mil.h"

unsigned char * getMilLayerRegisterPtr(unsigned long fpga_bar0_add);
unsigned char * getMilLayerRegisterPtr2(unsigned long fpga_bar0_add);

unsigned long long  LayerCreateGrabBuffer(MIL_ID *GrabBuffer, unsigned long Xsize, unsigned long Ysize, int PixelType_bpp=8);
void LayerInitDisplay(MIL_ID GrabBuffer, MIL_ID *MilDisplay, int DisplayNum = 1);
void LayerInitDisplay(MIL_ID GrabBuffer, MIL_ID *MilDisplay, char DisplayInfo[20]);
unsigned long long  LayerGetHostAddressBuffer(MIL_ID GrabBuffer);

void IrisMilFree(void);

#endif