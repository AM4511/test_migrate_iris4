//==============================================================================
//
// Filename     :  FlashUpdate.cpp
// Owner        :  Matrox Imaging dept.
// Rev          :
// Content      :  Update the flash of Spider FPGA
// Compile flag :
//
// COPYRIGHT (c) Matrox Electronic Systems Ltd.
// All Rights Reserved
//==============================================================================

#include "osincludes.h"
#include "mil.h"

#include "flashupdate.h"
#include "string.h"

#include "milstring.h"
#include "IntelHexFormatDecoder.h"
#if M_MIL_USE_WINDOWS
#include <tchar.h>
#endif


/**************************************************************************************************
* Name:           CFpgaEeprom()
*
* Synopsis:       Constructor
*
* Note:
*
**************************************************************************************************/
CFpgaEeprom::CFpgaEeprom(unsigned long long dwPhyAddress, DWORD dwEprSize)
   {

   //m_bShowProgress = false;
   m_dwPhyAddr = 0;
//   m_pEepromCtrl = NULL;
   ProgressBar = NULL;
   m_FirstEepromAddress = 0;
//   m_pEepromCtrl = NULL;
//   m_EepromCtrlValue = {{0}, {0}};

   m_dwFlashSize = dwEprSize;
   if (dwPhyAddress)
      {
      m_dwPhyAddr = dwPhyAddress;
      MapPtr();
      }
   }
/**************************************************************************************************
* Name:           ~CFpgaEeprom()
*
* Synopsis:       Destructor
*
* Note:
*
**************************************************************************************************/
CFpgaEeprom::~CFpgaEeprom()
   {
   if (m_dwPhyAddr)
      {
      UnmapPtr();
      m_dwPhyAddr = 0;
      }
   }



/***************************************************************
Function Name:  FPGAROMApiFlashFromFile

Abstract:  This API function permits to Reflash completely the FPGA with a new 
           FST file
  
Params: 
ImageFileName: Name (with path) of the FST file

szReturnMessage: Pointer to a string, allocated by the caller with a
                 minimum size of STRING_BUFFER_SIZE, used to return an error
                 message to the caller.  Use NULL if you don't want to use 
                 this feature.

ProgressCallback: The caller can provide a function pointer as this 
                parameter if he wants to be called back to get the progress of the 
                flash operation.  The caller should then define a function that looks 
                like this: "void Progress(BYTE precentdone)".  The caller will be called
                back at every 5% increment completion.  The "precentdone" he
                will receive is a number between 0 and 100, representing a percentage 
                of total write operation done.  Use NULL if you dont want to use this feature.
	
Notes: Retrun TRUE for success, else FALSE
****************************************************************/
MIL_UINT8 CFpgaEeprom::FPGAROMApiFlashFromFile(string &ImageFileName)
   {
    MIL_UINT8 byRetVal = FPGA_SUCCESS;

   printf_s("\nNow Loading Bitstream file from firmware file, please wait... ");

   //auto File = UTF8Encoding::FromMilString(ImageFileName);
   auto File = ImageFileName;
   IntelHexFormatDecoder Decoder(m_McsSignature);
   auto Data = Decoder.Parse(File, FPGA_ROM_SIZE);

   // Data vector must be a multiple of m_EepromPageSize.
   if ((Data.size() % m_EepromPageSize) != 0)
   {
      auto Padding = m_EepromPageSize - (Data.size() % m_EepromPageSize);
      for (size_t i = 0; i < Padding; i++)
         Data.push_back(0xFF);
   }

   m_FirstEepromAddress = Decoder.BaseAddress();

   if(m_FirstEepromAddress==0)
       printf_s("\nLoaded Bitstream is a Golden image, bitstream in flash start at address 0x%X.", m_FirstEepromAddress);
   else
       printf_s("\nLoaded Bitstream is a Update image, bitstream in flash start at address 0x%X.", m_FirstEepromAddress);

   if ((m_FirstEepromAddress == 0) || CheckDualBootCompatibility() )
       byRetVal = FPGAROMApiFlashFromMemory(Data);
   else
       byRetVal = FPGA_ERR_NO_DUALBOOT;

   return byRetVal;

   }

/***************************************************************
Function Name:  FPGAROMApiFlashFromMemory

****************************************************************/
MIL_UINT8 CFpgaEeprom::FPGAROMApiFlashFromMemory(const std::vector<uint8_t>& Data)
{
   MIL_UINT8 EpromWriteStatus;
   EpromWriteStatus = EepromMemoryWrite(Data);
   return EpromWriteStatus;
}




/**************************************************************************************************
* Name:           UpdateProgressText()
*
* Synopsis:       Updates the progress indicator display.
*
* Note:
*
**************************************************************************************************/
//void CFpgaEeprom::UpdateProgressText(MIL_CONST_TEXT_PTR Message)
//{
//#if !M_MIL_USE_LINUX
//	if (m_bShowProgress)
//	{
//		if (ProgressBar)
//		{
//			SetWindowText(ProgressBar, Message);
//
//			MSG msg;
//			while (PeekMessage(&msg, ProgressBar, 0, 0, PM_REMOVE))
//			{
//				// Dispatch all messages
//				TranslateMessage(&msg);
//				DispatchMessage(&msg);
//			}
//		}
//	}
//#else
//   if (m_ShowTextProgressBar)
//   {
//      MOs_printf_s(Message);
//      MOs_printf_s(MT("\n"));
//   }
//   if (m_ShowGraphicProgressBar)
//   {
//      CMILString Text("XXX");
//      Text += Message;
//      LnxProgressBarSetText(ProgressBar, (MIL_CONST_TEXT_PTR)Text);
//   }
//#endif
//}


/**************************************************************************************************
* Name:           MapPtr()
*
* Synopsis:       Maps the Eeprom control pointer
*
* Note:
*
**************************************************************************************************/
void CFpgaEeprom::MapPtr()
   {
   MbufCreate2d(M_DEFAULT_HOST,
                4096,
                1,
                8 + M_UNSIGNED,
                M_IMAGE + M_MMX_ENABLED,
                M_PHYSICAL_ADDRESS + M_PITCH_BYTE,
                4096,
                (void *)m_dwPhyAddr,
                &m_mBufId);

   unsigned char * Ptr;
   MbufInquireUnsafe(m_mBufId, M_HOST_ADDRESS, &Ptr); // Unsafe because volatile argument is not supported.
   Ptr += offsetof(FPGA_REGFILE_PCIE2AXIMASTER_TYPE, spi);
   m_pEepromCtrl = (FPGA_REGFILE_PCIE2AXIMASTER_SPI_TYPE*)Ptr;
   }

/**************************************************************************************************
* Name:           UnmapPtr()
*
* Synopsis:       Unmaps the Eeprom control pointer
*
* Note:
*
**************************************************************************************************/
void CFpgaEeprom::UnmapPtr()
   {
   MbufFree(m_mBufId);

   m_mBufId = 0;

   m_pEepromCtrl = 0;
   }

/*===================================================================================
Function Name:  SendEpromCommand


Written by:  SCHA
General function that handles all operations of EPROM
Notes:
byOpCode:   OpCode of operation to do

dwAddress:  Not applicable to all operations, put 0 if not used

pbyData: Data for Read Bytes and Write Bytes operations.  Put NULL if not used

dwNbBytesToRead: For read operation, we need to know how many bytes to read
===================================================================================*/
void CFpgaEeprom::SendEpromCommand(BYTE byOpCode, DWORD dwAddress, BYTE *pbyData, DWORD dwNbBytesToRead)
   {
   int j;
   int NbDataBytes = 0;
   BYTE NbAddressBits = 0;
   BYTE TransactionDone = 0;
   BYTE SpiCmdDone = 0;
   BYTE SpiWriteBlockCap = 0;

   switch (byOpCode)
      {
      case EPR_WRITE_ENABLE:
         dwNbBytesToRead = 0;
         break;

      case EPR_WRITE_DISABLE:
         dwNbBytesToRead = 0;
         break;

      case EPR_READ_STATUS:
         dwNbBytesToRead = 1;
         break;

      case EPR_READ_BYTES:
         NbAddressBits = 24;
         break;

      case EPR_READ_SILICON_ID:
         dwNbBytesToRead = 3; // Override the value passed for convenience
         break;

    //  case EPR_WRITE_STATUS:   DO NOT USE FOR SEEPROM COMPATIBILITY
    //     dwNbBytesToRead = 0;
    //     NbDataBytes = 1;
    //     break;

      case EPR_WRITE_BYTES:
         NbAddressBits = 24;
         NbDataBytes = 256;
         dwNbBytesToRead = 0;
         break;

      case EPR_ERASE_BULK:
         dwNbBytesToRead = 0;
         break;

      case EPR_ERASE_SECTOR:
         NbAddressBits = 24;
         dwNbBytesToRead = 0;
         break;
      }
   SpiWriteBlockCap = m_pEepromCtrl->spiregout.f.spi_wb_cap;

   // Send opcode
   if (!SpiWriteBlockCap) do TransactionDone = m_pEepromCtrl->spiregout.f.spiwrtd; while (!TransactionDone);
   SpiCmdDone = ((NbAddressBits == 0) && (NbDataBytes == 0) && (dwNbBytesToRead == 0));
   m_EepromCtrlValue.spiregin.f.spidataw = byOpCode;
   m_EepromCtrlValue.spiregin.f.spirw = 0;
   m_EepromCtrlValue.spiregin.f.spicmddone = SpiCmdDone;
   m_EepromCtrlValue.spiregin.f.spitxst = 1;
   m_pEepromCtrl->spiregin.u32 = m_EepromCtrlValue.spiregin.u32;

   // Send Address if operation has address bytes
   while (NbAddressBits)
      {
      if (!SpiWriteBlockCap) do TransactionDone = m_pEepromCtrl->spiregout.f.spiwrtd; while (!TransactionDone);
      NbAddressBits -= 8;
      SpiCmdDone = (NbAddressBits == 0) && (byOpCode == EPR_ERASE_SECTOR);
      m_EepromCtrlValue.spiregin.f.spidataw = (BYTE)(dwAddress >> NbAddressBits);
      m_EepromCtrlValue.spiregin.f.spirw = 0;
      m_EepromCtrlValue.spiregin.f.spicmddone = SpiCmdDone;
      m_EepromCtrlValue.spiregin.f.spitxst = 1;
      m_pEepromCtrl->spiregin.u32 = m_EepromCtrlValue.spiregin.u32;
      }

   // Write data if it is a write operation
   for (j = 0; NbDataBytes; j++, NbDataBytes--)
      {
      if (!SpiWriteBlockCap) do TransactionDone = m_pEepromCtrl->spiregout.f.spiwrtd; while (!TransactionDone);
      m_EepromCtrlValue.spiregin.f.spidataw = pbyData[j];
      m_EepromCtrlValue.spiregin.f.spirw = 0;
      m_EepromCtrlValue.spiregin.f.spicmddone = (NbDataBytes == 1);
      m_EepromCtrlValue.spiregin.f.spitxst = 1;
      m_pEepromCtrl->spiregin.u32 = m_EepromCtrlValue.spiregin.u32;
      }
   if (SpiWriteBlockCap) do TransactionDone = m_pEepromCtrl->spiregout.f.spiwrtd; while (!TransactionDone);

   // Read data if it is a read operation
   for (j = 0; dwNbBytesToRead; j++, dwNbBytesToRead--)
      {
      do TransactionDone = m_pEepromCtrl->spiregout.f.spiwrtd; while (!TransactionDone);
      pbyData[j] = 0;
      m_EepromCtrlValue.spiregin.f.spirw = 1;
      m_EepromCtrlValue.spiregin.f.spicmddone = (dwNbBytesToRead == 1);
      m_EepromCtrlValue.spiregin.f.spitxst = 1;
      m_pEepromCtrl->spiregin.u32 = m_EepromCtrlValue.spiregin.u32;
      do TransactionDone = m_pEepromCtrl->spiregout.f.spiwrtd; while (!TransactionDone);
      pbyData[j] = m_pEepromCtrl->spiregout.f.spidatard;
      }
   }

/*===================================================================================
Function Name:  WaitForWriteInProgress


Written by:  SCHA
Wait function.  Will poll status register.

Notes:
===================================================================================*/
void CFpgaEeprom::WaitForWriteInProgress(DWORD dwMilli, DWORD dwIncrement, BOOL WaitForNotWrEnLatch)
   {
   BYTE byReadStatus;
   BYTE byStatusMask;
   DWORD dwIncMilli = 1;
   DWORD dwNbLoops = 0;

   if (WaitForNotWrEnLatch)
      byStatusMask = 0x3;  // Wait For WriteInProgress and WriteEnableLatch to be both false
   else
      byStatusMask = 0x1;  // Wait For WriteInProgress only

   SendEpromCommand(EPR_READ_STATUS, 0, &byReadStatus, 0);
   // First, try polling without sleep, because sleep could take more time we think in XP
   // We check BUSY bit but also Write enable BIT, both should be 0 before continuing
   while ((byReadStatus&byStatusMask) && (dwNbLoops < 500))
      {
      SendEpromCommand(EPR_READ_STATUS, 0, &byReadStatus, 0);
      dwNbLoops++;
      }
   // If 500 loops were not enough to get device not busy anymore, then use loop with sleep
   // We check BUSY bit but also Write enable BIT, both should be 0 before continuing
   while ((byReadStatus&byStatusMask) && (dwIncMilli < dwMilli))
      {
      Sleep(dwIncMilli);
      dwIncMilli += dwIncrement;
      SendEpromCommand(EPR_READ_STATUS, 0, &byReadStatus, 0);
      }
   }


/*===================================================================================
Function Name:  EepromMemoryWrite


Written by:  SCHA
Entry point function for FPGA full reflash operation

Notes:
===================================================================================*/
MIL_UINT8 CFpgaEeprom::EepromMemoryWrite(const std::vector<uint8_t>& Data)
   {
   DWORD dwSiliconId;
   BYTE byRetVal = FPGA_SUCCESS;
   DWORD retry = 0;
   DWORD dwProgressPercent = 0;
   DWORD dwAlignedImageSize = (DWORD)Data.size();

   // Enable SPI+SPI2
   m_EepromCtrlValue.spiregin.u32 = 0;
   m_EepromCtrlValue.spiregin.f.spi_enable = 1;
   m_pEepromCtrl->spiregin.u32 = m_EepromCtrlValue.spiregin.u32;

   // Check Silicon ID
   SendEpromCommand(EPR_READ_SILICON_ID, 0, (BYTE *)&dwSiliconId, 0);
   do
      {
      printf_s("\nNow clearing the grab flash eeprom, please wait...");
      DWORD lFlashOffset = 0;
      while ((m_FirstEepromAddress + lFlashOffset) < dwAlignedImageSize)
         {
         SendEpromCommand(EPR_WRITE_ENABLE, 0, NULL, 0);
         //Write Status cycle time: 15 ms max
         WaitForWriteInProgress(15, 1, FALSE);

         SendEpromCommand(EPR_ERASE_SECTOR, m_FirstEepromAddress + lFlashOffset, NULL, 0);
         lFlashOffset += EEPROM_SECTOR_SIZE;

         // Write bytes cycle time: 5 ms max
         WaitForWriteInProgress(150, 1, TRUE);

         dwProgressPercent = lFlashOffset * 100 / (dwAlignedImageSize - m_FirstEepromAddress);
         if (dwProgressPercent > 100)
             dwProgressPercent = 100;
         if (dwProgressPercent <= 100)
             printf_s("\rNow clearing the grab flash eeprom, please wait... %d%% ", dwProgressPercent);
         }

      printf_s("\nNow writing the FPGA file in the grab flash eeprom, please wait...");
      lFlashOffset = 0;
      while ((m_FirstEepromAddress + lFlashOffset) < dwAlignedImageSize)
         {
         SendEpromCommand(EPR_WRITE_ENABLE, 0, NULL, 0);
         //Write Status cycle time: 15 ms max
         WaitForWriteInProgress(15, 1, FALSE);

         SendEpromCommand(EPR_WRITE_BYTES, m_FirstEepromAddress + lFlashOffset, (BYTE *)&Data[m_FirstEepromAddress + lFlashOffset], 0);
         lFlashOffset += EEPROM_PAGE_SIZE;

         // Write bytes cycle time: 5 ms max
         WaitForWriteInProgress(5, 1, TRUE);
         dwProgressPercent = lFlashOffset * 100 / (dwAlignedImageSize - m_FirstEepromAddress);
         if (dwProgressPercent <= 100)
             printf_s("\rNow writing the FPGA file in the grab flash eeprom, please wait... %d%% ", dwProgressPercent);
         }
 
      // Verify data
      printf_s("\nNow verifying the FPGA file in the grab flash eeprom, please wait...");
      BYTE * pbyRdBckData = (BYTE *)malloc(m_dwFlashSize);
      if (pbyRdBckData)
         {
         lFlashOffset = 0;
         byRetVal = FPGA_SUCCESS;
         while ((m_FirstEepromAddress + lFlashOffset) < dwAlignedImageSize)
            {
            SendEpromCommand(EPR_READ_BYTES, m_FirstEepromAddress + lFlashOffset, &pbyRdBckData[lFlashOffset], EEPROM_PAGE_SIZE);
            for (DWORD ii = 0; ii < EEPROM_PAGE_SIZE; ii++)
               {
               if (pbyRdBckData[ii + lFlashOffset] != Data[m_FirstEepromAddress + ii + lFlashOffset])
                  {
                  byRetVal = FPGA_ERR_BADRDBACK;
                  break;
                  }
               }
            lFlashOffset += EEPROM_PAGE_SIZE;
            dwProgressPercent = lFlashOffset * 100 / (dwAlignedImageSize - m_FirstEepromAddress);
            if (dwProgressPercent <= 100)
                printf_s("\rNow verifying the FPGA file in the grab flash eeprom, please wait... %d%% ", dwProgressPercent);
            }

         //if (dwProgressPercent != 100)
         //  UpdateProgressWindow(100);
         free(pbyRdBckData);
         }
      } while ((retry++ < 3) && (byRetVal == FPGA_ERR_BADRDBACK));

      m_EepromCtrlValue.spiregin.f.spi_enable = 0;
      m_pEepromCtrl->spiregin.u32 = m_EepromCtrlValue.spiregin.u32;

      printf_s("\n");
      return byRetVal;
   }

bool CFpgaEeprom::CheckDualBootCompatibility()
{
    bool FoundDualBootCompatibility = false;
    int i;
    int LastIndexToCheck = (EEPROM_PAGE_SIZE - (2 * sizeof(DWORD)));
    const DWORD SyncWord = 0x665599AA;  // Bitstream should have in header: AA 99 55 66
    const DWORD WBSTAR_Ident = 0x01000230; // Warm Boot Start Address is identified by 30 02 00 01
    DWORD WBStar = 0;

    BYTE* pbyFpgaBootData = (BYTE*)malloc(EEPROM_PAGE_SIZE);

    // Enable SPI
    m_EepromCtrlValue.spiregin.u32 = 0;
    m_EepromCtrlValue.spiregin.f.spi_enable = 1;
    m_pEepromCtrl->spiregin.u32 = m_EepromCtrlValue.spiregin.u32;

    SendEpromCommand(EPR_READ_BYTES, 0x0, pbyFpgaBootData, EEPROM_PAGE_SIZE);

    // Disable SPI
    m_EepromCtrlValue.spiregin.f.spi_enable = 0;
    m_pEepromCtrl->spiregin.u32 = m_EepromCtrlValue.spiregin.u32;

    // Find Sync Word
    for (i = 0; i < LastIndexToCheck; i++)
    {
        if ((*(DWORD*)(pbyFpgaBootData + i)) == SyncWord)
        {
            break;
        }
    }

    i += 4;
    // Find Warm Boot Start Address.
    while (i < LastIndexToCheck)
    {
        if ((*(DWORD*)(pbyFpgaBootData + i)) == WBSTAR_Ident)
        {
            WBStar = (pbyFpgaBootData[i + 4] << 24) | (pbyFpgaBootData[i + 5] << 16) | (pbyFpgaBootData[i + 6] << 8) | (pbyFpgaBootData[i + 7]);
            break;
        }
        i++;
    }
    free(pbyFpgaBootData);

    WBStar &= 0x1FFFFFFF;
    if ((WBStar != 0) && (WBStar == m_FirstEepromAddress))
        FoundDualBootCompatibility = true;

    return FoundDualBootCompatibility;
}