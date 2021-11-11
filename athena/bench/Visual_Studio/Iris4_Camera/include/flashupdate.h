//==============================================================================
//
// Filename     :  FlashUpdate.h
// Owner        :  Matrox Imaging dept.
// Rev          :
// Content      :  FlashUpdate definition
//
// COPYRIGHT (c) Matrox Electronic Systems Ltd.
// All Rights Reserved
//==============================================================================
#include <locale>
#include <map>
#include <set>
#include <memory>
#include <queue>
#include <stdexcept>      // std::out_of_range
#include <array>
#include <map>
#include <list>
#include <array>
#include <vector>
#include <exception>
#include <string>
#include <sstream>
#include <fstream>
#include <algorithm>
#include <atomic>
#include <iostream>
#include <iomanip>
#include <mutex>
#include <thread>
#include <future>

#include "mbasictypes.h"
#include "mil.h"
#include "milstring.h"
#include "milos.h"

#include <math.h>
#include <vector>
#include "../../../../local_ip/pcie2AxiMaster_v3.0/registerfile/regfile_pcie2AxiMaster.h"

using namespace std;


#ifndef __FLASH_UPDATE_H
#define __FLASH_UPDATE_H

#define FPGA_SYNC_DWORD         0x665599AA  // Sync word 1 and word 2
#define FPGA_W_GENERAL1         0x6132   // Type 1 Write 1 word GENERAL_1
#define FPGA_W_GENERAL2         0x8132   // Type 1 Write 1 word GENERAL_1
#define FPGA_HEADER_MAX_LIMIT   128      // The bitstream head should not exceed 128 bytes

// FPGA return values
#define FPGA_SUCCESS            0
#define FPGA_ERROR              1
#define FPGA_ERR_BADEPROM       2
#define FPGA_ERR_BADRDBACK      3
#define FPGA_ERR_NOTSUPPORTED   4
#define FPGA_ERR_NO_DUALBOOT    5

#define FPGA_ROM_SIZE           0x800000

#define EEPROM_PAGE_SIZE        256
#define EEPROM_SECTOR_SIZE      65536
#define EEPROM_SUBSECTOR_SIZE   4096


#define FPGA_BIN_SIGNATURE          0x4E494223 //#BIN
#define FPGA_FST_SIGNATURE          0x54534623 //#FST

// FPGA EPROM commands
#define EPR_WRITE_ENABLE        0x06
#define EPR_WRITE_DISABLE       0x04
#define EPR_READ_STATUS         0x05
//#define EPR_READ_STATUS2        0x35  DO NOT USE FOR SEEPROM COMPATIBILITY
#define EPR_READ_BYTES          0x03
#define EPR_READ_SILICON_ID     0x9F
//#define EPR_WRITE_STATUS        0x01 DO NOT USE FOR SEEPROM COMPATIBILITY
#define EPR_WRITE_BYTES         0x02
#define EPR_ERASE_BULK          0xC7
#define EPR_ERASE_SECTOR        0xD8

// LocalCpuCom Request IDs.
#define LOCCPU_REPLY                   0x80
#define LOCCPU_HEARTBEAT               6
#define LOCCPU_EPR_ERASE_SECTOR     	14
#define LOCCPU_EPR_WRITE_PAGE  	      15
#define LOCCPU_EPR_ERASE_SUBSECTOR	   16
#define LOCCPU_EPR_WRITE_PAGE_RDBACK   17

#define LOCCPU_RESULT_OK          1
#define LOCCPU_RESULT_ERROR       0

#define FPGA_XLNX_ID_OFFSET     0x24        // Offset in image where the Xilinx Image Identification is stored.
#define FPGA_XLNX_ID            0x584C4E58  // Xilinx Image Id signature = 'XLNX'



// LocalCpuCom Headers.
#pragma pack( push , r1, 1  ) //Tells compiler to byte align the structure
typedef struct _LocalCpuComReqHead
{
   MIL_UINT8 ReqID;
   MIL_UINT16 Size;
}LocalCpuComReqHead;

typedef struct _LocalCpuComReplyHead
{
   MIL_UINT8 ReqID;
   MIL_UINT16 Size;
   MIL_UINT8 Result;
}LocalCpuComReplyHead;

#pragma pack( pop , r1 ) //End of byte alignment structure compilation


// Class representing the Eeprom of the FPGA
class CFpgaEeprom
   {
public:
   // Constructor/Destructor
   CFpgaEeprom(unsigned long long dwPhyAddress, DWORD dwEprSize);
   ~CFpgaEeprom();

   MIL_UINT8 FPGAROMApiFlashFromFile(string &ImageFileName);
   MIL_UINT8 FPGAROMApiFlashFromMemory(const std::vector<uint8_t>& Data);

   // Event used to terminate progress and update thread
   MIL_CONST_TEXT_PTR m_BoardName;

private:
   // Functions used to map/unmap the EepromCtrl register
   void MapPtr();
   void UnmapPtr();
   MIL_UINT8 EepromMemoryWrite(const std::vector<uint8_t>& Data);
   void SendEpromCommand(BYTE byOpCode, DWORD dwAddress, BYTE *pbyData, DWORD dwNbBytesToRead);
   void WaitForWriteInProgress(DWORD dwMilli, DWORD dwIncrement, BOOL WaitForNotWrEnLatch);
   bool CheckDualBootCompatibility(void);
   // Size of the FPGA Eeprom
   unsigned long m_dwFlashSize;



   // HANDLE on the progress window
#if !M_MIL_USE_LINUX
   HWND ProgressBar;
#else
   FILE* ProgressBar;
#endif

   // Indicates if we want to show or not the progress
   //bool m_bShowProgress;

   MIL_INT m_ShowGraphicProgressBar;
   MIL_INT m_ShowTextProgressBar;

   DWORD m_FirstEepromAddress;


   // Physical address of the SPI registers
   unsigned long long m_dwPhyAddr;

   // Virtual mapped address of the SPI register
   volatile FPGA_REGFILE_PCIE2AXIMASTER_SPI_TYPE *m_pEepromCtrl;
   FPGA_REGFILE_PCIE2AXIMASTER_SPI_TYPE m_EepromCtrlValue;

   // MIL ID of the buffer used to map the EepromCtrl register
   MIL_ID m_mBufId;

   const uint32_t m_EepromPageSize = 256;
   const std::string m_McsSignature = "MCS=";

}; /* class CEeprom */


#endif
