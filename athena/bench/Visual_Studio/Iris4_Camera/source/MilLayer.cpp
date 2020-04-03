//-----------------------------------------------
//
//  Library of functions using MIL for IRIS3
//
//-----------------------------------------------
#include "MilLayer.h"


//-----------------------------------
// MIL IDs  variables
//-----------------------------------
MIL_ID   LayerMilApplication;
MIL_ID   LayerMilSystem;
MIL_ID   LayerMilRegBuf[10];
//MIL_ID   LayerMilRegBuf2;

void MilLayerAlloc(void)
{

	//---------------------
	//
	// MIL ALLOCs
	//
	//---------------------
	MappAlloc(M_DEFAULT, &LayerMilApplication);
	MsysAlloc(M_SYSTEM_HOST, M_DEFAULT, M_DEFAULT, &LayerMilSystem);
}


unsigned char * getMilLayerRegisterPtr(M_UINT32 regId, M_UINT64 fpga_bar0_add)
   {

    MbufCreate2d(M_DEFAULT_HOST,
                8192,
                1,
                8 + M_UNSIGNED,
                M_IMAGE + M_MMX_ENABLED,
                M_PHYSICAL_ADDRESS + M_PITCH_BYTE,
                8192,
                (void **)fpga_bar0_add,
                &LayerMilRegBuf[regId]);

   unsigned char * RegPtr = (unsigned char*)MbufInquire(LayerMilRegBuf[regId], M_HOST_ADDRESS, M_NULL);

   return RegPtr;
   }

/*
unsigned char * getMilLayerRegisterPtr2(M_UINT64 fpga_bar0_add)
	{

	MbufCreate2d(M_DEFAULT_HOST,
				 8192,
				 1,
				 8 + M_UNSIGNED,
				 M_IMAGE + M_MMX_ENABLED,
				 M_PHYSICAL_ADDRESS + M_PITCH_BYTE,
				 8192,
				 (void **)fpga_bar0_add,
				 &LayerMilRegBuf2);

	unsigned char * RegPtr = (unsigned char*)MbufInquire(LayerMilRegBuf2, M_HOST_ADDRESS, M_NULL);

	return RegPtr;
	}

	*/

//----------------------------------------------------
// Create ONE grab buffer and return address
//----------------------------------------------------
M_UINT64  LayerCreateGrabBuffer(MIL_ID *GrabBuffer, M_UINT32 Xsize, M_UINT32 Ysize, int PixelType_bpp)
   {
   if(PixelType_bpp == 8) //8bpp
	   {
	   MbufAllocColor(M_DEFAULT_HOST,
					  1,                                   // one band
					  MIL_INT(Xsize),
					  MIL_INT(Ysize),
					  M_UNSIGNED + 8,
					  M_IMAGE + M_DISP + M_NON_PAGED + M_MONO8,
					  GrabBuffer);
	   }
   else if(PixelType_bpp == 10) //10bpp
	   {
	   MbufAllocColor(M_DEFAULT_HOST,
					  1,                                   // one band
					  MIL_INT(Xsize),
					  MIL_INT(Ysize),
					  M_UNSIGNED + 16,
					  M_IMAGE + M_DISP + M_NON_PAGED + M_MONO16,
					  GrabBuffer);
	   }
   else if(PixelType_bpp == 16) //16bpp YUV 4:2:2
      {
      MbufAllocColor(M_DEFAULT_HOST,
                     3,                                   // 3 band
                     MIL_INT(Xsize),
                     MIL_INT(Ysize),
                     M_UNSIGNED + 8,
                     M_IMAGE + M_DISP + M_NON_PAGED + M_PACKED + M_YUV16_YUYV,
                     GrabBuffer);
      }


   else if(PixelType_bpp == 32) //32bpp RGB
      {
      MbufAllocColor(M_DEFAULT_HOST,
                     3,                                   // 3 band
                     MIL_INT(Xsize),
                     MIL_INT(Ysize),
                     M_UNSIGNED + 8,
                     M_IMAGE + M_DISP + M_NON_PAGED + M_PACKED + M_BGR32,
                     GrabBuffer);
      }


   MbufClear(*GrabBuffer, 0);

   return(MbufInquire(*GrabBuffer, M_PHYSICAL_ADDRESS, M_NULL));

   }


//----------------------------------------------------
// Get HOST addres of buffer
//----------------------------------------------------
M_UINT64  LayerGetHostAddressBuffer(MIL_ID GrabBuffer)
   {
   return(MbufInquire(GrabBuffer, M_HOST_ADDRESS, M_NULL));
   }



//----------------------------------------------------
// Initialisation of Display
//----------------------------------------------------
void LayerInitDisplay(MIL_ID GrabBuffer, MIL_ID *MilDisplay, int DisplayNum)
   {
   char title[15];

   sprintf_s(title, "MIL Display %d", DisplayNum);

   //---------------------
   //
   // Create display
   //
   //---------------------
   MdispAlloc(M_DEFAULT_HOST, M_DEFAULT, MIL_TEXT("M_DEFAULT"), M_DEFAULT, MilDisplay);
   //MdispControl(*MilDisplay, M_TITLE, M_PTR_TO_DOUBLE(title));
   MdispSelect(*MilDisplay, GrabBuffer);
   MbufControl(GrabBuffer, M_MODIFIED, M_DEFAULT);   // <-- update display here

   }

//void LayerInitDisplay(MIL_ID GrabBuffer, MIL_ID *MilDisplay, char DisplayInfo[20])
//   {
//   char title[50];
//
//   sprintf_s(title, "MIL Display %s", DisplayInfo);
//
//   //---------------------
//   //
//   // Create display
//   //
//   //---------------------
//   MdispAlloc(M_DEFAULT_HOST, M_DEFAULT, MIL_TEXT("M_DEFAULT"), M_DEFAULT, MilDisplay);
//   MdispControl(*MilDisplay, M_TITLE, M_PTR_TO_DOUBLE(title));
//   MdispSelect(*MilDisplay, GrabBuffer);
//   MbufControl(GrabBuffer, M_MODIFIED, M_DEFAULT);   // <-- update display here
//
//   }



void IrisMilFree(void)
   {
   for (int i=0 ;i<10;i++)
     MbufFree(LayerMilRegBuf[i]);

   MsysFree(LayerMilSystem);
   MappFree(LayerMilApplication);
   }


