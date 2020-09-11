//==============================================================================
//
// Filename     :  dsyst.cpp
// Owner        :  Matrox Imaging dept.
// Rev          :
// Content      :  MDHwSpecSystem member functions
//
// COPYRIGHT (c) Matrox Electronic Systems Ltd.
// All Rights Reserved
//==============================================================================
#include <includes.h>

MIL_INT ComputeBlockSize(MIL_DOUBLE Factor, MIL_DOUBLE SizeY, MIL_DOUBLE CurBlkNb, MIL_DOUBLE NbBlksInBuf);

using namespace MatroxElectronicSystemsLtd_DCFInfo;
using namespace std;

//==============================================================================
//
//   Name:       MDHwSpecSystem()
//
//   Synopsis:   Constructor.
//
//   Parameters: MIL_INT Number         : Device number to allocate
//               MIL_INT64 InitFlag     : Initialization flag.
//               MIL_INT *ErrorFlag     : Pointer to error code.
//               MDHwSpecDriver *DrvPtr : Driver pointer.
//               ThreadContextPtr       : Thread context object pointer.
//
//==============================================================================
MDHwSpecSystem::MDHwSpecSystem(MIL_CONST_TEXT_PTR pSystemDescriptor, MIL_INT Number, MIL_INT64 InitFlag, MIL_CONST_TEXT_PTR pDeviceName, MIL_INT *ErrorFlag, MDDriverThreadContext *ThreadContextPtr) :
   MDGeniCamDeviceSystem(pSystemDescriptor, Number, InitFlag, pDeviceName, ErrorFlag)
   {
   CDrvTimer     Timer;
   CError        lError;
   CCommandFIFO *LLThreadHandle = 0;
   MIL_UINT32    lBuildIdInFile = 0;
   FIRMWARE_FILE_HEADER FirmwareFileHeader;

   m_FocusDelaycDllHandle = M_NULL;
   m_VariopticGetDelay = nullptr;

   // Open an handle to the driver kernel-mode.
   OpenHandleToDriver(MT("IrisGTX"), ThreadContextPtr);
   m_IrisGtxFpgaUpgradeDone = false;
   if(GetDeviceHandle() == INVALID_HANDLE_VALUE)
      {
      lError.Log(M_SYSTEM_ERROR_2, 1);    //System not found or already allocated
      goto end;
      }

   lError = LLGetBoardTypeAndFirmwareVersion(GetDeviceHandle(), &m_FlashInfo, ThreadContextPtr);
   if(lError.StatusLogged())
      {
      ErrorCode(lError.SystemErrorNumber(), lError.SystemSubMessage1());
      goto end;
      }

   lError = DecodeFirmwareFileHeader(FirmwareFileHeader);
   lBuildIdInFile = FirmwareFileHeader.BuildId;
   //lError = GetFirmwareVersionFromFile(m_FlashInfo.head[0].HeadType, m_FlashInfo.head[0].BoardRevision, lBuildIdInFile);
   if(lError.ErrorLogged())
      {
      ErrorCode(lError.SystemErrorNumber(), lError.SystemSubMessage1());
      goto end;
      }

   //A build id of 0 in file indicates that the firmware file is not present
   //we should therefore use the firmware we have.
   if((lBuildIdInFile != 0) && (m_FlashInfo.head[0].BuildId[0] != lBuildIdInFile))
      {
      if(InitFlag & M_NO_FPGA_UPGRADE)
         {
         lError.Log(M_SYSTEM_ERROR_6, 1);   // Inform the user that firmware update is mandatory.
         ErrorCode(lError.SystemErrorNumber(), lError.SystemSubMessage1());
         goto end;
         }

      bool EnableFirmwareUpdatePopup1 = true;
      bool DoUpdate = true;
      CMILString KeyName(MT("IrisGTX"));
      CMILString ValueName1(MT("EnableFirmwareUpdatePopup1"));
      MIL_INT32 RegValue1 = 0;
      MRegAccess Key(M_MIL_IMAGING_BOARD, KeyName);

      if(Key.ValueExists(ValueName1))
         {
         if(Key.GetValue(ValueName1, RegValue1))
            EnableFirmwareUpdatePopup1 = RegValue1 ? true : false;
         }
      if(EnableFirmwareUpdatePopup1)
         {
         MIL_INT iFirmwareUpdaterPresent = FirmwareUpdaterPresent();
         if(iFirmwareUpdaterPresent)
            {
            DoUpdate = false;
            if(!(iFirmwareUpdaterPresent & M_FIRMWARE_UPDATER_STARTED))
               {
               if(MilMessageBox(MT("The firmware on the Matrox IrisGTX needs to be updated before continuing. Do you want to launch firmware updater?"), MT("Matrox IrisGTX Firmware Update"), MB_YESNO | MB_ICONWARNING | MB_SYSTEMMODAL) == IDYES)
                  {
                  FirmwareUpdaterStart();
                  }
               }
            }
         else
            {
            if(MilMessageBox(MT("The firmware on the Matrox IrisGTX needs to be updated before continuing. The PC will be SHUTDOWN and any unsaved work will be lost. Please close all programs, before continuing."), MT("Matrox IrisGTX Firmware Update"), MB_OKCANCEL | MB_ICONWARNING | MB_SYSTEMMODAL) != IDOK)
               DoUpdate = false;
            }
         }

      if(DoUpdate)
         {
         FlashUpdate(0, lError, ThreadContextPtr);
         if(lError.ErrorLogged())
            {
            ErrorCode(lError.SystemErrorNumber(), lError.SystemSubMessage1());
            goto end;
            }
         }
      else
         {
         lError.Reset();
         lError.Log(M_SYSTEM_ERROR_2, 4);   //FPGA firmware update needed.
         ErrorCode(lError.SystemErrorNumber(), lError.SystemSubMessage1());
         goto end;
         }
      }
   else if(m_FlashInfo.head[0].BuildId[0] < 0x5EFA1223)
      {
      lError.Reset();
      lError.Log(M_SYSTEM_ERROR_2, 4);   //FPGA firmware update needed.
      ErrorCode(lError.SystemErrorNumber(), lError.SystemSubMessage1());
      goto end;
      }


   LLsysAlloc(ThreadContextPtr->LLThreadHandle(),
              InitFlag,
              &m_Id,
              &m_RegistryInfo,
              lError,
              ThreadContextPtr);

   if(lError.ErrorLogged())
      goto end;

   NbMaxDigitizer(1);

   // Create allocation Thread
   LLThreadAlloc(SystemId(), M_NORMAL, &LLThreadHandle, lError, ThreadContextPtr);

   if(LLThreadHandle == 0)
      {
      ErrorCode(M_MEMORY_ERROR_0, 1);
      goto end;
      }

   SyncThreadHandle(LLThreadHandle);

   // Allocate User Hook handler
   mp_UserHook = new CUserHook(GetDeviceNumber(), SystemId().DeviceHandle);

   if(!mp_UserHook)
      {
      ErrorCode(M_MEMORY_ERROR_0, 1);
      goto end;
      }

   // Register one hook thread
   SetNbBufModifiedThreads(1);

   m_FocusDelaycDllHandle = MilLoadLibraryAndTrace(MT("milirisgtxfocusdelay.dll"));
   if(m_FocusDelaycDllHandle)
      {
      m_VariopticGetDelay = (IRISGTX_FOCUS_DELAY)MilGetProcAddress(m_FocusDelaycDllHandle, MIL_FUNC_NAME("VariopticGetDelay"));
      }

end:

   if(lError.ErrorLogged())
      {
      ErrorCode(lError.SystemErrorNumber(), lError.SystemSubMessage1());

      if(mp_UserHook)
         {
         mp_UserHook->UnRegisterHookFunction(HOOK_TYPE_BUF_MODIFIED, this, ThreadContextPtr);
         SetNbBufModifiedThreads(0);
         }


      if(SyncThreadHandle())
         {
         LLThreadFree(SystemId(), SyncThreadHandle(), lError, ThreadContextPtr);
         SyncThreadHandle(0);
         }

      if(GetDeviceHandle())
         {
         LLsysFree(SystemId(), ThreadContextPtr->LLThreadHandle(), lError, ThreadContextPtr);
         }
      }
   else
      {
      // Don't do this if it's already done.
      if(!CLog::GetInstance()->IsBufferAllocate())
         {
         SYS_INQUIRE lSysInquire;

         // ok no error Create Clog if Enable in the registry
         MIL_INT64 PhyAddrOfMsgBuffer = 0;
         lSysInquire.InquireType = M_MSG_BUFFER_PHYSICAL_ADDRESS;
         lSysInquire.ThreadHandle = ThreadContextPtr->LLThreadHandle();
         LLsysInquire(SystemId(), lSysInquire, lError, ThreadContextPtr);
         PhyAddrOfMsgBuffer = (MIL_INT)lSysInquire.InquiredValue;

         if(PhyAddrOfMsgBuffer)
            {
            // Inquire the size of the buffer
            MIL_UINT SizeOfMsgBuffer = 0;
            lSysInquire.InquireType = M_MSG_BUFFER_SIZE;
            lSysInquire.ThreadHandle = ThreadContextPtr->LLThreadHandle();
            LLsysInquire(SystemId(), lSysInquire, lError, ThreadContextPtr);
            SizeOfMsgBuffer = (MIL_INT)lSysInquire.InquiredValue;

            // Create buffer in user mode, if kernel buffer is properly initialized
            if(CLog::GetInstance()->AllocBuffer((MIL_UINT)PhyAddrOfMsgBuffer, SizeOfMsgBuffer) == M_NO_ERROR)
               {
               // Open DriverLogViewer.exe
               STARTUPINFO si;
               ZeroMemory(&si, sizeof(si));
               si.cb = sizeof(si);
               PROCESS_INFORMATION MsgLogProcess;
               ZeroMemory(&MsgLogProcess, sizeof(MsgLogProcess));
#if !M_MIL_USE_LINUX
               HWND MesLogHandle = FindWindow(NULL, MT("Driver Log Viewer"));

               if(!MesLogHandle)
                  {
                  // When compile in Unicode, we need to pass to CreateProcess()
                  // a non-const string
                  MIL_TEXT_CHAR CmdLineStr[] = MT("\"DriverLogViewer.EXE");

                  if(CreateProcess(NULL,               // name of executable module
                     CmdLineStr,         // command line string
                     NULL,               // Process handle not inheritable
                     NULL,               // Thread handle not inheritable
                     FALSE,              // handle inheritance option
                     0,                  // NO creation flags
                     NULL,               // new environment block
                     NULL,               // current directory name
                     &si,                // startup information
                     &MsgLogProcess)   // process information
                     )
                     {
                     WaitForInputIdle(MsgLogProcess.hProcess, INFINITE);
                     MesLogHandle = FindWindow(NULL, MT("Driver Log Viewer"));
                     }

                  // We don't need these handles.
                  if(MsgLogProcess.hThread)
                     CloseHandle(MsgLogProcess.hThread);
                  if(MsgLogProcess.hProcess)
                     CloseHandle(MsgLogProcess.hProcess);
                  }
#else
               HWND MesLogHandle=0;
#endif

               COPYDATASTRUCT Data;
               MTX_MESSAGE_INFO_BUFFER_64 MtxInfoBuffer;
               MtxInfoBuffer.Size = SizeOfMsgBuffer;
               MtxInfoBuffer.PhyAddr = PhyAddrOfMsgBuffer;
               MtxInfoBuffer.CpuSpeed = CLog::GetInstance()->GetCpuSpeed();
               Data.dwData = e64Struct;
               Data.cbData = sizeof(MTX_MESSAGE_INFO_BUFFER_64);
               Data.lpData = &MtxInfoBuffer;

#if !M_MIL_USE_LINUX
               SendMessage(MesLogHandle, WM_COPYDATA, NULL, (LPARAM)&Data);
#endif

               if(m_RegistryInfo.EnableExpensiveLogs)
                  CLog::GetInstance()->EnableLog(eLogTypeExpensive);

               if(m_RegistryInfo.EnableBufCmdLogs || m_RegistryInfo.EnableAllDrvLogs)
                  CLog::GetInstance()->EnableLog(eLogTypeBufCmds);

               if(m_RegistryInfo.EnableCALogs || m_RegistryInfo.EnableAllDrvLogs)
                  CLog::GetInstance()->EnableLog(eLogTypeCA);

               if(m_RegistryInfo.EnableIntHndLogs || m_RegistryInfo.EnableAllDrvLogs)
                  CLog::GetInstance()->EnableLog(eLogTypeIntHnd);

               if(m_RegistryInfo.EnableCDLogs || m_RegistryInfo.EnableAllDrvLogs)
                  CLog::GetInstance()->EnableLog(eLogTypeCD);

               if(m_RegistryInfo.EnableCmdLogs || m_RegistryInfo.EnableAllDrvLogs)
                  CLog::GetInstance()->EnableLog(eLogTypeCmds);

               if(m_RegistryInfo.EnableDigCmdLogs || m_RegistryInfo.EnableAllDrvLogs)
                  CLog::GetInstance()->EnableLog(eLogTypeDigCmds);

               if(m_RegistryInfo.EnableGULogs || m_RegistryInfo.EnableAllDrvLogs)
                  CLog::GetInstance()->EnableLog(eLogTypeGU);

               if(m_RegistryInfo.EnableSysCmdLogs || m_RegistryInfo.EnableAllDrvLogs)
                  CLog::GetInstance()->EnableLog(eLogTypeSysCmds);

               if(m_RegistryInfo.EnableEventCmdLogs || m_RegistryInfo.EnableAllDrvLogs)
                  CLog::GetInstance()->EnableLog(eLogTypeEventCmds);

               if(m_RegistryInfo.EnableTULogs || m_RegistryInfo.EnableAllDrvLogs)
                  CLog::GetInstance()->EnableLog(eLogTypeTU);

               if(m_RegistryInfo.EnableErrorLogs || m_RegistryInfo.EnableAllDrvLogs)
                  CLog::GetInstance()->EnableLog(eLogTypeError);

               if(m_RegistryInfo.EnableUserHookLogs || m_RegistryInfo.EnableAllDrvLogs)
                  CLog::GetInstance()->EnableLog(eLogTypeUserHooks);

               if(m_RegistryInfo.EnableDigProcessLogs || m_RegistryInfo.EnableAllDrvLogs)
                  CLog::GetInstance()->EnableLog(eLogTypeDigProcess);
               }
            }
         }

      }

   *ErrorFlag = ErrorCode();
   }

/////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    Name:         MDHwSpecSystem::GetFirmwarePath
//
//    Parameters:   CMILString &oPath:
//
//    Return value: CError:
//
//    Comments:
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
CError MDHwSpecSystem::GetFirmwarePath(CMILString &oPath)
   {
   CError lError;
   CMILString KeyName(MT("IrisGTX"));
   CMILString ValueName(MT("FirmwarePath"));

   MRegAccess Key(M_MIL_IMAGING_BOARD, KeyName);

   if(Key.ValueExists(ValueName))
      {
      if(!Key.GetValue(ValueName, oPath))
         lError.Log(M_IRISGTX_FLASH_ERROR_1, 1);   //Could not find the firmware upgrade file.
      }
   else
      {
      lError.Log(M_IRISGTX_FLASH_ERROR_1, 1);   //Could not find the firmware upgrade file.
      }
   return lError;
   }

/****************************************************************************************************
*
*     Name:         MDHwSpecSystem::DecodeFirmwareFileHeader
*
*
*
****************************************************************************************************/
CError MDHwSpecSystem::DecodeFirmwareFileHeader(FIRMWARE_FILE_HEADER &FileHeader)
{
   CError lError;
   CMILString        FirmwarePath;
   MIL_INT HeaderFieldsRead = 0;
   std::string line;

   lError = GetFirmwarePath(FirmwarePath);
   if (!lError.ErrorLogged())
   {
      FirmwarePath += MIL_TEXT("/FpgaRom.firmware");
   }

   std::ifstream infile(FirmwarePath);
   if (!infile.is_open())
   {
      lError.Log(M_IRISGTX_FLASH_ERROR_1, 3);
      return lError;
   }

   while (std::getline(infile, line) && (HeaderFieldsRead < 3))
   {
      auto found = line.find("FPGA Version");
      if (found != std::string::npos)
      {
         found = line.find(": ");
         FileHeader.FpgaVersion = line.substr(found + 2, std::string::npos);
         HeaderFieldsRead++;
         continue;
      }

      found = line.find("BuildID");
      if (found != std::string::npos)
      {
         found = line.find(": ");
         auto sBuildId = line.substr(found + 2, std::string::npos);
         FileHeader.BuildId = static_cast<uint32_t>(std::stoul(sBuildId));
         HeaderFieldsRead++;
         continue;
      }

      found = line.find("Build date");
      if (found != std::string::npos)
      {
         found = line.find(": ");
         FileHeader.BuildDate = line.substr(found + 2, std::string::npos);
         HeaderFieldsRead++;
         continue;
      }
   }

   if (HeaderFieldsRead < 3)
      lError.Log(M_IRISGTX_FLASH_ERROR_1, 3);

   return lError;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    Name:         MDHwSpecSystem::GetInstalledFirmwareVersion
//
//    Parameters:   MIL_UINT BoardType:
//                  MIL_UINT &oBuildId:
//
//    Return value: void:
//
//    Comments:
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
CError MDHwSpecSystem::GetFirmwareVersionFromFile(MIL_UINT BoardType, MIL_UINT32 BoardRevision, MIL_UINT32 &oBuildId)
   {
   UNREFERENCED_PARAMETER(BoardType);
   CError lError;
   //Initialize version
   oBuildId       = 0;
   MIL_FILE          hFile            = NULL;
   MIL_INT8         *FileHeader       = NULL;
   MIL_INT8         *FileHeaderPtr    = NULL;
   MIL_CINT32        FileHeaderSize   = 1024;
   CMILString        FirmwarePath;

   lError = GetFirmwarePath(FirmwarePath);
   if(!lError.ErrorLogged())
      {
      FileHeader = new MIL_INT8[FileHeaderSize];
      if(!FileHeader)
         goto end;
      FileHeader[FileHeaderSize - 1] = 0;
      switch(BoardRevision & 0xF)
         {
         case 4:
            FirmwarePath += MIL_TEXT("/FpgaRomN2.fst");
            break;
         case 3:
            FirmwarePath += MIL_TEXT("/FpgaRomN1.fst");
            break;
         case 2:
            FirmwarePath += MIL_TEXT("/FpgaRomN0.fst");
            break;
         case 1:
            FirmwarePath += MIL_TEXT("/FpgaRomG2x8.fst");
            break;
         case 0:
            FirmwarePath += MIL_TEXT("/FpgaRom.firmware");
            break;
         }
      MOs_fopen_s(&hFile, (LPCMILSTR)FirmwarePath, MT("rb"));

      if(hFile == NULL)
         goto end;

      MOs_fread(FileHeader, sizeof(MIL_INT8), FileHeaderSize - 1, hFile);
      FileHeaderPtr = FileHeader;

      while (MOs_ANSIstrnicmp("#FPGATimestamp:", FileHeaderPtr, MOs_ANSIstrlen("#FPGATimestamp:")))
         {
         FileHeaderPtr++;
         if ((FileHeaderPtr - FileHeader) > (FileHeaderSize * sizeof(MIL_INT8)))
            {
            lError.Log(M_IRISGTX_FLASH_ERROR_1, 3);  //Could not update FPGA, invalid .ttf file or file not found.
            goto end;
            }
         }

      FileHeaderPtr += MOs_ANSIstrlen("#FPGATimestamp:");

#if M_MIL_USING_SAFE_CRT
      MOs_ANSIsscanf_s(FileHeaderPtr, "%x", &oBuildId);
#else
      MOs_ANSIsscanf(FileHeaderPtr, "%x", &oBuildId);
#endif
      }

end:

   if(hFile)
      MOs_fclose(hFile);

   if(FileHeader)
      delete [] FileHeader;

   return lError;
   }

/////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    Name:         MDHwSpecSystem::FlashUpdate
//
//    Parameters:   MIL_INT Mode:
//                  MIL_UINT iBoardType:
//                  CError &iError:
//                  MDDriverThreadContext *iThreadContextPtr:
//
//    Return value: void:
//
//    Comments:
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
void MDHwSpecSystem::FlashUpdate(MIL_INT index, CError &iError, MDDriverThreadContext *ipThreadContext)
   {
   UNREFERENCED_PARAMETER(ipThreadContext);
   MIL_UINT8        *MemPtr                           = NULL;
   CMILString        FirmwarePath;
   MIL_HANDLE        lMatroxSysAllocMutex             = NULL;
   bool              EnableFirmwareUpdatePopup2       = true;
   bool              EnableRebootOnFirmwareUpdate     = true;
   MIL_INT32         lFirmwareShutdownWaitTimeInSec   = 0;
#if M_MIL_USE_LINUX
   MIL_INT32         lTimeout                         = 0;
   CMILString        ValueName3(MT("FirmwareShutdownWaitTimeInMin"));
#else
   MIL_INT32         lTimeout                         = 0;
   CMILString        ValueName3(MT("FirmwareShutdownWaitTimeInSec"));
#endif
   MIL_INT32         RegValue2                        = 0;
   MIL_INT32         RegValue4                        = 0;
   CMILString        KeyName(MT("IrisGTX"));
   CMILString        ValueName2(MT("EnableFirmwareUpdatePopup2"));
   CMILString        ValueName4(MT("EnableRebootOnFirmwareUpdate"));
   MRegAccess        Key(M_MIL_IMAGING_BOARD, KeyName);
   bool              Reboot                           = false;

   lMatroxSysAllocMutex = MilCreateMutex(NULL, TRUE, MT("MatroxFirmwareUpdateMutex"));

   if(!lMatroxSysAllocMutex)
      {
      iError.Log(M_SYSTEM_ERROR_5, 2);    //Can't synchronize execution properly
      goto end;
      }
#if !M_MIL_USE_LINUX
   else if(GetRebootState())
      {
      iError.Log(M_SYSTEM_ERROR_5, 4);    //Shutdown in progress, can't start a new flash update
      goto end;
      }
   else if(GetLastError() == ERROR_ALREADY_EXISTS)
      {
      bool Success;
      Success = (MilWaitForSingleObject(lMatroxSysAllocMutex, MIL_INFINITE) == MIL_WAIT_OBJECT_0);
      }
#endif

   iError = GetFirmwarePath(FirmwarePath);
   if(iError.ErrorLogged())
      goto end;
   else
      {
      CFpgaEeprom lFpgaEeprom = CFpgaEeprom(SystemId(), MIL_TEXT("IrisGTX"), m_FlashInfo.head[index].PhyAddr[1], 0x3F0000);
      FirmwarePath += MIL_TEXT("/FpgaRom.firmware");
      lFpgaEeprom.FPGAROMApiFlashFromFile(FirmwarePath, true);

      if (iError.ErrorLogged())
         {
         goto end;
         }

      Reboot = true;
      }
   end:;
 
   if(lMatroxSysAllocMutex)
      {
      MilReleaseMutex(lMatroxSysAllocMutex);
      MilCloseHandle(lMatroxSysAllocMutex);
      }

   if(!iError.ErrorLogged() && Reboot)
      {
      if(Key.ValueExists(ValueName2))
         {
         if(Key.GetValue(ValueName2, RegValue2))
            EnableFirmwareUpdatePopup2 = RegValue2? true: false;
         }

      if(Key.ValueExists(ValueName3))
         {
         if(Key.GetValue(ValueName3, lFirmwareShutdownWaitTimeInSec))
            if(lFirmwareShutdownWaitTimeInSec >= 0 && lFirmwareShutdownWaitTimeInSec <= 30)
               lTimeout = lFirmwareShutdownWaitTimeInSec;
         }
      if(Key.ValueExists(ValueName4))
         {
         if(Key.GetValue(ValueName4, RegValue4))
            EnableRebootOnFirmwareUpdate = RegValue4? true: false;
         }

      // If, on an Iris GTX, we have the popups enabled, verify if FPGA update on I/O FPGA is required.
      // If so, we don't want to display the poppups and and do shutdown before the job is done on the I/O FPGA.
      if (IsGTXCamera() && (EnableFirmwareUpdatePopup2 || EnableRebootOnFirmwareUpdate))
         {
         MIL_ID AuxIoSysId = 0;
         MAsysAlloc(M_DEFAULT, MT("M_NULL"), 0, M_NO_FPGA_UPGRADE | M_FROM_ACQUISITION_DRIVER, &AuxIoSysId);
         MIL_INT ErrorCode = MfuncGetError(M_NULL, M_INTERNAL + M_THREAD_CURRENT, M_NULL);
         if (ErrorCode != M_NULL_ERROR)
            {
            MIL_INT SubErrorCode = MfuncGetError(M_NULL, M_INTERNAL_SUB + M_THREAD_CURRENT, M_NULL);
            MfuncErrorReport(M_NULL, M_NULL, M_NULL, M_NULL, M_NULL, M_NULL); // Reset the error
            if ((ErrorCode == (M_SYSTEM_ERROR_6 - M_IRISGTX_ERROR_SYSTEM_START_CODE + M_MTXAUXIO_ERROR_SYSTEM_START_CODE)) &&
                (SubErrorCode == 1))
               {
               EnableFirmwareUpdatePopup2 = false;
               EnableRebootOnFirmwareUpdate = false;
               m_IrisGtxFpgaUpgradeDone = true;
               }
            }
         if (AuxIoSysId)
            MAsysFree(AuxIoSysId);
         }

      if(EnableFirmwareUpdatePopup2)
         MilMessageBox(MT("Finished updating Matrox IrisGTX firmware. Click on the OK button to shutdown your system. Note: if you have other boards to update, perform the required updates before clicking on the OK button."), MT("Matrox IrisGTX firmware update"),MB_OK|MB_ICONWARNING|MB_SYSTEMMODAL);

      if(EnableRebootOnFirmwareUpdate)
         {
         if(!ShutDownProcess(MT("Matrox IrisGTX firmware has been updated, the system will be SHUTDOWN and MUST be POWERED-OFF for the modifications to take effect."), lTimeout))
            {
            iError.Log(M_IRISGTX_FLASH_ERROR_1, 4);
            MilMessageBox(MT("The Matrox IrisGTX firmware has been updated, please SHUTDOWN and POWER-OFF your system for the modifications to take effect."), MT("Matrox IrisGTX Firmware Update"), MB_OK);
            }
         else
            {
            MappControl(M_ERROR, M_PRINT_DISABLE);
            exit(0);
            }
         }
      }

   if(MemPtr)
      delete [] MemPtr;
   }

//==============================================================================
//
//   Name:       ~MDHwSpecSystem()
//
//   Synopsis:   Destructor.
//
//==============================================================================
MDHwSpecSystem::~MDHwSpecSystem()
   {
   LockDriver();
   MDDriverThreadContext *ThreadContextPtr = gDriverWrapper.GetInstance()->GetThreadContext(0);
   UnlockDriver();

   CError lError;

   if(m_FocusDelaycDllHandle)
      {
      MilFreeLibrary(m_FocusDelaycDllHandle);
      m_FocusDelaycDllHandle = NULL;
      }

   // delete UserHook
   if(mp_UserHook)
      {
      delete mp_UserHook;
      mp_UserHook = NULL;
      }

   // Free allocation thread
   if(SyncThreadHandle())
      {
      CError lError;
      LLThreadFree(SystemId(), SyncThreadHandle(), lError, ThreadContextPtr);
      }

   if(SystemId().DeviceHandle)
      LLsysFree(SystemId(), ThreadContextPtr->LLThreadHandle(), lError, ThreadContextPtr);

   }

//==============================================================================
//
//   Name:       SysInquire()
//
//   Synopsis:   Inquire the system settings.
//
//   Parameters: MIL_INT64 ParamToInquire  : Parameter to inquire.
//               void *Ptr                 : Pointer to the returned value.
//               ThreadContextPtr          : Thread context object pointer.
//
//   Returns:    MIL_INT Status : M_VALID -> valid call
//                                M_INVALID -> not supported call
//
//==============================================================================
MIL_INT MDHwSpecSystem::SysInquire(MIL_INT64 ParamToInquire, void *Ptr, MDDriverThreadContext *ThreadContextPtr)
   {
   MIL_INT          InvalidCall      = M_VALID;
   MIL_INT          lDevNb           = 0;
   CError           lError;
   MIL_INT64        lParamToInquire = ParamToInquire;

   if(M_STRING_SIZE_BIT_SET(ParamToInquire))
      lParamToInquire = M_STRIP_STRING_SIZE_BIT(ParamToInquire);

   if(ParamToInquire == M_NUMBER_OF_GRAB_BLOCKS + 0 ||
      ParamToInquire == M_GRAB_BLOCK_FACTOR     + 0)
      {
      ParamToInquire = ParamToInquire;
      lDevNb = 0;
      }
   else if( ParamToInquire == M_NUMBER_OF_GRAB_BLOCKS + 1 ||
            ParamToInquire == M_GRAB_BLOCK_FACTOR     + 1)
      {
      ParamToInquire = ParamToInquire - 1;
      lDevNb = 1;
      }
   else if( ParamToInquire == M_NUMBER_OF_GRAB_BLOCKS + 2 ||
            ParamToInquire == M_GRAB_BLOCK_FACTOR     + 2)
      {
      ParamToInquire = ParamToInquire - 2;
      lDevNb = 2;
      }
   else if( ParamToInquire == M_NUMBER_OF_GRAB_BLOCKS + 3 ||
            ParamToInquire == M_GRAB_BLOCK_FACTOR     + 3)
      {
      ParamToInquire = ParamToInquire - 3;
      lDevNb = 3;
      }

   switch(lParamToInquire)
      {
      case M_PROCESSOR_NUM:
         *(MIL_INT *)Ptr = 0;
         break;
      case M_BUFCOPY_SUPPORTED:
         *(MIL_INT *)Ptr = M_YES;
         break;
      case M_SYSTEM_TYPE:
         *(MIL_INT *)Ptr = M_SYSTEM_IRIS_GTX_TYPE;
         break;
      case M_SYSTEM_NAME:
         if(M_STRING_SIZE_BIT_SET(ParamToInquire))
            *(MIL_INT*)Ptr = 8;
         else
            MOs_strcpy_s((MIL_TEXT_CHAR *)Ptr, 8, MT("IrisGTX"));
         break;
      case M_NATIVE_ID:
         *(MIL_INT *)Ptr = (MIL_INT)GetDeviceHandle();
         break;
      case M_LIVE_GRAB:
         *(MIL_INT *)Ptr = M_ENABLE;
         break;
      case M_DCF_SUPPORTED:
         *(MIL_INT *)Ptr = M_YES;
         break;
      case M_COMPRESSION_SUPPORTED:
         *(MIL_INT *)Ptr = M_NO;
         break;
      case M_COMPRESSION_MODULE_PRESENT:
         *(MIL_INT *)Ptr = M_FALSE;
         break;
      case M_LOW_LEVEL_SYSTEM_ID:
         *(MIL_INT *)Ptr = (MIL_INT)GetDeviceHandle();
         break;
      case M_MULTITHREAD_SUPPORT:
         *(MIL_INT *)Ptr = M_YES;
         break;
      case M_ASYNCHRONOUS_CALL_SUPPORT:
         *(MIL_INT *)Ptr = M_YES;
         break;
      case M_TIMEOUT:
         {
         LLThreadInquire(SystemId(), ThreadContextPtr->LLThreadHandle(), ParamToInquire, (MIL_UINT *)Ptr, lError, ThreadContextPtr);
         // Convert from ms to sec.
         if(*(MIL_UINT *)Ptr != M_INFINITE)
            *(MIL_UINT *)Ptr /= 1000;
         }
         break;
      case M_THREAD_PRIORITY:
         {
         MIL_UINT InquireVal = 0;
         ThrInquire(0, M_THREAD_PRIORITY, &InquireVal, ThreadContextPtr);
         *(MIL_UINT *)Ptr = (MIL_UINT)InquireVal;
         }
         break;
         // EEPROM SysInquires done by MtxAux driver
         //case M_EEPROM_SIZE:
      case M_MODIFIED_BUFFER_HOOK_MODE:
         if(GetBufModifiedHookMode() == M_SINGLE_THREAD)
            *(MIL_INT *)Ptr = GetBufModifiedHookMode();
         else
            *(MIL_INT *)Ptr = GetBufModifiedHookMode() + GetNbBufModifiedThreads();
         break;
      case M_DEFAULT_PITCH_BYTE_MULTIPLE:
         {
         MIL_INT InquireValue;
         // Send this control to my associated system id
         MsysInquire(HostSystemId(), M_DEFAULT_PITCH_BYTE_MULTIPLE, &InquireValue);
         *(MIL_INT *)Ptr = InquireValue;
         }
         break;
         //case M_CUSTOMER_PRODUCT_ID:
         // Leave inquire of M_CUSTOMER_PRODUCT_ID to MtxAux driver
      case M_DIGITIZER_NUM:
         *(MIL_INT*)Ptr = NbMaxDigitizer();
         break;
      case M_COM_SUPPORTED:
         *(MIL_INT *)Ptr = M_YES; // McomAlloc() is supported on an Iris GTX system
         break;
      case M_LIGHTING_BRIGHT_FIELD:  // Iris GTX does not support M_LIGHTING_BRIGHT_FIELD in sysInquire, only in DigInquire
         ErrorCode(M_INQUIRE_ERROR_0, 1); //Inquire type is not supported
         break;
      case M_FIRMWARE_REVISION:
         *(MIL_INT *)Ptr = m_FlashInfo.head[0].BuildId[0];
         break;
      case M_FIRMWARE_BUILDDATE:
         *(MIL_INT *)Ptr = m_FlashInfo.head[0].BuildId[0];
         break;
      case M_BOARD_REVISION_SENSOR:
         *(MIL_INT *)Ptr = m_FlashInfo.head[0].NpiHeadData.PCBRev;
         break;
      case M_PRODUCT_SENSOR:
         CMILString::CopyStringToUserString((MIL_INT8 *)(m_FlashInfo.head[0].NpiHeadData.SensorModel), Ptr, M_GET_CLIENT_TEXT_ENCODING(ParamToInquire));
         break;
     case M_PRODUCT_SENSOR + M_STRING_SIZE:
        *(MIL_INT *)Ptr = MOs_ANSIstrlen((MIL_INT8 *)m_FlashInfo.head[0].NpiHeadData.SensorModel);
        break;
     default:
         {
         SYS_INQUIRE lSysInquire;
         lSysInquire.InquireType = ParamToInquire;
         lSysInquire.ThreadHandle = ThreadContextPtr->LLThreadHandle();
         LLsysInquire(SystemId(), lSysInquire, lError, ThreadContextPtr);
         if (!lError.ErrorLogged())
            {
            if (M_IN_SYS_INQUIRE_MIL_INT64_RANGE(ParamToInquire))
               {
               *(MIL_INT64*)Ptr = lSysInquire.InquiredValue;
               }
            else
               {
               switch (ParamToInquire)
                  {
                  case M_PERFORMANCE_LOGS:
                     *((PERF_STATS*)Ptr) = lSysInquire.PerformanceData;
                     break;
                     //case M_SERIAL_NUMBER:
                     // M_SERIAL_NUMBER in SysInquire should be handled by MtxAux driver
                     //   {
                     //   // Serial Number is always 8 char long.
                     //   // We need to convert in Unicode, if the drivers run in Unicode
                     //   // and in ascii otherwise. This code is good for all the case.
                     //   MIL_INT8 SerialNumberInChar[9] = {0};
                     //   MDrv_memcpy(SerialNumberInChar, &Ps.InquiredValue, 8);
                     //   SerialNumberInChar[8] = '\0';
                     //   CMILString SerialNumberString;
                     //   SerialNumberString.InitFromASCII(SerialNumberInChar);
                     //   MOs_strcpy_s(((MIL_TEXT_CHAR*)InquireValue), SerialNumberString.Length()+1, (LPCMILSTR)SerialNumberString);
                     //   }
                     //   break;
                  case M_TEMPERATURE_FPGA:
                  case M_CAMERA + M_TEMPERATURE_FPGA + M_DIGITIZER_DEV0:
                  case M_CAMERA + M_TEMPERATURE_FPGA + M_DIGITIZER_DEV1:
                  case M_CAMERA + M_TEMPERATURE_FPGA + M_DIGITIZER_DEV2:
                  case M_CAMERA + M_TEMPERATURE_FPGA + M_DIGITIZER_DEV3:
                  case M_CAMERA + M_TEMPERATURE_FPGA + M_DIGITIZER_DEV4:
                  case M_BOARD + M_TEMPERATURE_FPGA + M_DIGITIZER_DEV0:
                  case M_BOARD + M_TEMPERATURE_FPGA + M_DIGITIZER_DEV1:
                  case M_BOARD + M_TEMPERATURE_FPGA + M_DIGITIZER_DEV2:
                  case M_BOARD + M_TEMPERATURE_FPGA + M_DIGITIZER_DEV3:
                  case M_BOARD + M_TEMPERATURE_FPGA + M_DIGITIZER_DEV4:
                  case M_TEMPERATURE_FPGA_MAX_MEASURED:
                     {
                     MIL_DOUBLE dValue = (MIL_DOUBLE)lSysInquire.InquiredValue;
                     dValue = (dValue*503.975 / 4096.0) - 273.15;
                     *(MIL_DOUBLE*)Ptr = dValue;
                     }
                     break;
                  case M_VOLTAGE_FGPA_VCCINT:
                  case M_VOLTAGE_FPGA_VCCINT_MIN_MEASURED:
                  case M_VOLTAGE_FPGA_VCCINT_MAX_MEASURED:
                  case M_VOLTAGE_FPGA_VCCAUX:
                  case M_VOLTAGE_FPGA_VCCAUX_MIN_MEASURED:
                  case M_VOLTAGE_FPGA_VCCAUX_MAX_MEASURED:
                  case M_VOLTAGE_FPGA_VCCBRAM:
                  case M_VOLTAGE_FPGA_VCCBRAM_MIN_MEASURED:
                  case M_VOLTAGE_FPGA_VCCBRAM_MAX_MEASURED:
                  case M_VOLTAGE_FPGA_VREFP:
                     {
                     MIL_DOUBLE dValue = (MIL_DOUBLE)lSysInquire.InquiredValue;
                     dValue = (dValue / 4096.0) * 3.0;
                     *(MIL_DOUBLE*)Ptr = dValue;
                     }
                     break;
                  case M_TEMPERATURE_IMAGE_SENSOR + M_DEV0:
                  case M_TEMPERATURE_IMAGE_SENSOR + M_DEV1:
                  case M_TEMPERATURE_IMAGE_SENSOR + M_DEV2:
                  case M_TEMPERATURE_IMAGE_SENSOR + M_DEV3:
                  case M_TEMPERATURE_IMAGE_SENSOR + M_DEV4:
                  case M_TEMPERATURE_IMAGE_SENSOR + M_DIGITIZER_DEV0:
                  case M_TEMPERATURE_IMAGE_SENSOR + M_DIGITIZER_DEV1:
                  case M_TEMPERATURE_IMAGE_SENSOR + M_DIGITIZER_DEV2:
                  case M_TEMPERATURE_IMAGE_SENSOR + M_DIGITIZER_DEV3:
                  case M_TEMPERATURE_IMAGE_SENSOR + M_DIGITIZER_DEV4:
                     *(MIL_DOUBLE*)Ptr = (MIL_DOUBLE)lSysInquire.InquiredValue;
                     break;
                  default:
                     *(MIL_INT *)Ptr = (MIL_INT)lSysInquire.InquiredValue;
                     break;
                  }
               }
            }

         // Check if the call was handled by the low level library
         // Do not call the base driver if driver handled the call
         if(lError.CallNotSupported())
            {
            MIL_INT RetVal = M_INVALID;
            if(m_FlashInfo.head[0].IsGTXCamera)
               RetVal = MAsysInquire(M_NULL, ParamToInquire, Ptr);
            if(RetVal == M_INVALID)
               {
               // Clear errors
               MfuncErrorReport(M_NULL, M_NULL, M_NULL, M_NULL, M_NULL, M_NULL);
               // Relay it to the base class if it cant be handled
               InvalidCall = MDGeniCamDeviceSystem::SysInquire(ParamToInquire, Ptr, ThreadContextPtr);
               }
            else
               {
               // Convert value if inquire returs M_CC_IO2, 3 or 4
               if(((ParamToInquire >= M_TIMER_TRIGGER_SOURCE + M_TIMER1) && (ParamToInquire <= M_TIMER_TRIGGER_SOURCE + M_TIMER16)) ||
                  ((ParamToInquire >= M_TIMER_ARM_SOURCE + M_TIMER1) && (ParamToInquire <= M_TIMER_ARM_SOURCE + M_TIMER16)) ||
                  ((ParamToInquire >= M_IO_SOURCE + M_AUX_IO0) && (ParamToInquire <= M_IO_SOURCE + M_AUX_IO16)))
                  {
                  switch(*(MIL_INT *)Ptr)
                     {
                     case M_CC_IO2:
                        *(MIL_INT *)Ptr = M_EXPOSURE;
                        break;
                     case M_CC_IO3:
                        *(MIL_INT *)Ptr = M_TIMER_STROBE;
                        break;
                     case M_CC_IO4:
                        *(MIL_INT *)Ptr = M_GRAB_TRIGGER_READY;
                        break;
                     }
                  }

               }
            // Reset error code if handled by the base class
            if(InvalidCall == M_VALID)
               ErrorCode(M_NO_ERROR);
            }
         }
         break;
      }
   return(InvalidCall);
   }

//==============================================================================
//
//   Name:       SysControl()
//
//   Synopsis:   Control the system settings.
//
//   Parameters: MIL_INT64 ControlType  : Parameter to control.
//               MIL_INT ControlValue   : Value to set control to.
//               ThreadContextPtr       : Thread context object pointer.
//
//   Returns:    MIL_INT Status : M_VALID -> valid call
//                                M_INVALID -> not supported call
//
//==============================================================================
   MIL_INT MDHwSpecSystem::SysControl(MIL_INT64 ControlType, const MULTI_TYPES& CtrlValue, MDDriverThreadContext *ThreadContextPtr)
   {
   MIL_INT          InvalidCall      = M_VALID;
   MIL_INT          lDevNb           = 0;
   CError           lError;
   MIL_INT          MIControlValue = CtrlValue;

   if(ControlType == M_NUMBER_OF_GRAB_BLOCKS + 0 ||
      ControlType == M_GRAB_BLOCK_FACTOR     + 0)
      {
      ControlType = ControlType;
      lDevNb = 0;
      }
   else if( ControlType == M_NUMBER_OF_GRAB_BLOCKS + 1 ||
            ControlType == M_GRAB_BLOCK_FACTOR     + 1)
      {
      ControlType = ControlType - 1;
      lDevNb = 1;
      }
   else if( ControlType == M_NUMBER_OF_GRAB_BLOCKS + 2 ||
            ControlType == M_GRAB_BLOCK_FACTOR     + 2)
      {
      ControlType = ControlType - 2;
      lDevNb = 2;
      }
   else if( ControlType == M_NUMBER_OF_GRAB_BLOCKS + 3 ||
            ControlType == M_GRAB_BLOCK_FACTOR     + 3)
      {
      ControlType = ControlType - 3;
      lDevNb = 3;
      }

      {
      if(ControlType == M_MIL_ID_INTERNAL)
         {
         MilId(M_MITOMID(MIControlValue));
         if (IsGTXCamera()) // On GTX camera, send this SystemId to the MtxAux driver
            MAsysControl(M_NULL, ControlType, MIControlValue);
         mp_UserHook->RegisterHookFunction(HOOK_TYPE_BUF_MODIFIED, this, &m_BufModified, MilId(), ThreadContextPtr);
         // Allocate internal GENICAM XMLs.
         AllocateGenICamProxysFromXMLsInResource(M_MITOMID(MIControlValue));
         }
      else if(ControlType == M_TIMEOUT)
         {
         if (MIControlValue >= -1) // M_INFINITE = -1
            {
            if (MIControlValue == M_DEFAULT)
               MIControlValue = m_RegistryInfo.ThreadTimeoutValue;

            MIL_INT Timeout = MIControlValue;

            // Convert from sec to ms
            if (MIControlValue != M_INFINITE)
               Timeout *= 1000;

            ThrControl(0, ControlType, Timeout, ThreadContextPtr);
            }
         else
            {
            ErrorCode(M_CONTROL_ERROR_0, 3); //Invalid control value specified.
            }
         }
      else if((ControlType == M_THREAD_CANCEL    ) ||
              (ControlType == M_THREAD_HALT      ))
         {
         ThrControl(0, ControlType, CtrlValue, ThreadContextPtr);
         }
      else if(ControlType == M_DEBUG_BUFFER_TO_FILE)
         {
         MIL_INT lFileSuffix = MIControlValue;
         CMILString FileName;
         FileName.FormatStr(MT("%s%ld.mim"), MT("IrisGTXDump"), lFileSuffix);

         CLog::GetInstance()->Log(this, eCLOG_DUMP);
         CLog::GetInstance()->DumpLogToFile(FileName.c_str());
         }
      else if(ControlType == M_DEFAULT_PITCH_BYTE_MULTIPLE)
         {
         // Send this control to my associated system id
         MsysControl(HostSystemId(), M_DEFAULT_PITCH_BYTE_MULTIPLE, MIControlValue);
         }
      else if(ControlType == M_FIRMWARE_UPDATE)
         {
         if (MIControlValue == M_DEFAULT)
            {
            //FlashUpdate(M_DEFAULT, BoardType(), BoardRevision(), lError, ThreadContextPtr);
            if(lError.ErrorLogged())
               {
               ErrorCode(lError.SystemErrorNumber(), lError.SystemSubMessage1());
               goto end;
               }
            }
         else
            ErrorCode(M_CONTROL_ERROR_0, 3); //Invalid control value specified.
         }
      //else if(ControlType == M_CUSTOMER_PRODUCT_ID)
      // Leave control of M_CUSTOMER_PRODUCT_ID to MtxAux driver
      else if (ControlType == M_MODIFIED_BUFFER_HOOK_MODE)
         {
         MIL_INT lDigDevNbAlloc = 0;
         CError  lError;
         bool bErrorFlagged = false;

         // Clear error only if previous error is to signal a unsupported control
         if (ErrorCode() == M_CONTROL_ERROR_0 && ErrorSubNb() == 1)
            {
            ErrorCode(M_NO_ERROR);
            }

         SysInquire(M_DIGITIZER_NUM_ALLOCATED, &lDigDevNbAlloc, ThreadContextPtr);

         if (lDigDevNbAlloc)
            {
            ErrorCode(M_SYSTEM_ERROR_1, 2); //Unable to perform operation while digitizer is allocated.
            bErrorFlagged = true;
            }

         if (!bErrorFlagged)
            {
            if ((MIControlValue == M_SINGLE_THREAD) || (MIControlValue == M_DEFAULT))
               {
               // Unregister existing hooks if needed
               for (MIL_UINT NbThreads = 0; NbThreads < (GetNbBufModifiedThreads() - 1); NbThreads++)
                  {
                  mp_UserHook->UnRegisterHookFunction(HOOK_TYPE_BUF_MODIFIED, this, ThreadContextPtr);
                  }

               SetNbBufModifiedThreads(1);
               SetBufModifiedHookMode(M_SINGLE_THREAD);
               }
            else if (MIControlValue & M_MULTI_THREAD)
               {
               SYSTEM_INFO   SystemInformation;
               MIL_UINT      NbThreads = (MIControlValue & ~(M_MULTI_THREAD | M_NO_LIMIT));
               MIL_UINT      NoLimit = (MIControlValue & M_NO_LIMIT);

               GetSystemInfo(&SystemInformation);

               // default is set to nb processor
               if (NbThreads == 0)
                  NbThreads = ((SystemInformation.dwNumberOfProcessors >= 16) ? 16 : SystemInformation.dwNumberOfProcessors);

               if (NoLimit || NbThreads <= SystemInformation.dwNumberOfProcessors)
                  {
                  if (NbThreads > GetNbBufModifiedThreads())
                     {
                     // Add hooks on System
                     for (MIL_UINT Hook = 0; Hook < (NbThreads - GetNbBufModifiedThreads()); Hook++)
                        {
                        mp_UserHook->RegisterHookFunction(HOOK_TYPE_BUF_MODIFIED, this, &m_BufModified, MilId(), ThreadContextPtr);
                        }

                     SetNbBufModifiedThreads(NbThreads);
                     }
                  SetBufModifiedHookMode(M_MULTI_THREAD);
                  }
               else
                  {
                  ErrorCode(M_CONTROL_ERROR_0, 3); //Invalid control value specified.
                  bErrorFlagged = true;
                  }
               }
            else
               {
               ErrorCode(M_CONTROL_ERROR_0, 3); //Invalid control value specified.
               bErrorFlagged = true;
               }
            }
         }
      else if (ControlType == M_LIGHTING_BRIGHT_FIELD) // Iris GTX does not support M_LIGHTING_BRIGHT_FIELD in sysControl, only in DigControl
         {
         ErrorCode(M_CONTROL_ERROR_0, 1); //Invalid control type.
         }
      else
         {
         // Relay the call to the low level library
         LLsysControl(SystemId(), ThreadContextPtr->LLThreadHandle(), ControlType, MIControlValue, lError, ThreadContextPtr);

         // Check if the call was handled by the low level library
         // Do not call the base driver if driver handled the call
         // If the call was not handle by the low-level library, then first try MilAux
         if (lError.CallNotSupported())
            {
            MIL_INT RetVal = M_INVALID;
            if(m_FlashInfo.head[0].IsGTXCamera)
               {
               if (((ControlType >= M_TIMER_TRIGGER_SOURCE + M_TIMER1) && (ControlType <= M_TIMER_TRIGGER_SOURCE + M_TIMER16)) ||
                  ((ControlType >= M_TIMER_ARM_SOURCE + M_TIMER1) && (ControlType <= M_TIMER_ARM_SOURCE + M_TIMER16)) ||
                  ((ControlType >= M_IO_SOURCE + M_AUX_IO0) && (ControlType <= M_IO_SOURCE + M_AUX_IO16)) )
                  {
                  // In case of multi head camera, use generic pin names.
                  switch(MIControlValue)
                     {
                     case M_EXPOSURE:
                        MIControlValue = M_CC_IO2;
                        break;
                     case M_TIMER_STROBE:
                        MIControlValue = M_CC_IO3;
                        break;
                     case M_GRAB_TRIGGER_READY:
                        MIControlValue = M_CC_IO4;
                        break;
                     }
                  }
               RetVal = MAsysControl(M_NULL, ControlType, MIControlValue);
               }
            if(RetVal == M_INVALID)
               {
               // Relay it to the base class if it cant be handled
               MfuncErrorReport(M_NULL, M_NULL, M_NULL, M_NULL, M_NULL, M_NULL);
               InvalidCall = MDGeniCamDeviceSystem::SysControl(ControlType, CtrlValue, ThreadContextPtr);
               }
               
            }            
         else if(lError.ErrorLogged() && !((lError.SystemErrorNumber() == M_CONTROL_ERROR_0) && (lError.SystemSubMessage1() == 1)))
            InvalidCall = M_ERROR_PENDING;
         }
      }

end:
   if(ErrorCode() && !((ErrorCode() == M_CONTROL_ERROR_0) && (ErrorSub(1) == 1)) && (InvalidCall != M_INVALID))
      InvalidCall = M_ERROR_PENDING;

   return(InvalidCall);
   }

//==============================================================================
//
//   Name:       SysConfigAccess()
//
//   Synopsis:   Access PCI configuration space of PCI devices.
//
//   Parameters: MIL_INT VendorId         : Vendor ID of the device to access.
//               MIL_INT DeviceId         : Device ID of the device to access.
//               MIL_INT DeviceNum        : Device number (offset) M_DEFAULT, M_DEV0,...
//               MIL_INT64 OperationFlag  : M_DEFAULT.
//               MIL_INT64 OperationType  : M_READ, or M_WRITE
//               MIL_INT Offset           : Offset to read (in long).
//               MIL_INT Size             : Number of long to read.
//               void   *UserArrayPtr     : Pointer t array for returned/written value.
//
//==============================================================================
MIL_INT MDHwSpecSystem::SysConfigAccess(MIL_INT                VendorId,
                                        MIL_INT                DeviceId,
                                        MIL_INT                DeviceNum,
                                        MIL_INT64              OperationFlag,
                                        MIL_INT64              OperationType,
                                        MIL_INT                Offset,
                                        MIL_INT                Size,
                                        void                  *UserArrayPtr,
                                        MDDriverThreadContext *ThreadContextPtr)
   {
   UNREFERENCED_PARAMETER(ThreadContextPtr);
   UNREFERENCED_PARAMETER(VendorId);
   UNREFERENCED_PARAMETER(DeviceId);
   UNREFERENCED_PARAMETER(DeviceNum);
   CError lError;

   if(OperationFlag == M_RESERVED_FOR_INTERNAL_USE_SYS_CONFIG)
      {
      if(m_FlashInfo.head[0].IsGTXCamera)
         {
         MAsysConfigAccess(MilId(),
                           VendorId,
                           DeviceId,
                           DeviceNum,
                           OperationFlag,
                           OperationType,
                           Offset,
                           Size,
                           UserArrayPtr);
         }
      }
   else if (OperationFlag == M_REGISTER_ACCESS)
      {
      if ((DeviceNum != 0) || ((Offset + Size) > sizeof(m_FlashInfo.head[0].NpiHeadData)))
         lError.Log(M_SYSTEM_ERROR_4, 1);
      else
         {
         if (OperationType == M_READ)
            MDrv_memcpy(UserArrayPtr, &m_FlashInfo.head[0].NpiHeadData, Size);
         else
            lError.Log(M_SYSTEM_ERROR_3, 3);
         }
      }
   else
      {
      lError.Log(M_SYSTEM_ERROR_3, 2); // Control flag not supported.
      }

//end:;
   if(lError.ErrorLogged())
      ErrorCode(lError.SystemErrorNumber(), lError.SystemSubMessage1());

   return(M_VALID);
   }

//==========================================================================
//
// Name:           SysHookFunction()
//
// Synopsis:       Attach a user predefined function to an event
//
// Parameters:     MIL_INT        HookType       : Type of event hooked
//                 MIL_SYS_HOOK_FUNCTION_PTR HookHandlerPtr : User function ptr to hook.
//                 void           *UserDataPtr   : User data Ptr.
//                 ThreadContextPtr              : Thread context object pointer.
//==========================================================================
MIL_INT MDHwSpecSystem::SysHookFunction(MIL_INT HookType, MIL_SYS_HOOK_FUNCTION_PTR HookHandlerPtr, void *UserDataPtr, MDDriverThreadContext *ThreadContextPtr)
   {
   UNREFERENCED_PARAMETER(ThreadContextPtr);
   bool lUnhook = false;
   MIL_INT InitialHookType = HookType;

   if(HookType & M_UNHOOK)
      {
      lUnhook = true;
      HookType &= ~M_UNHOOK;
      }

   if(m_FlashInfo.head[0].IsGTXCamera)
      MAsysHookFunction(MilId(), InitialHookType, (MIL_SYS_HOOK_FUNCTION_PTR)HookHandlerPtr, UserDataPtr);

   return M_VALID;
   }

MIL_INT MDHwSpecSystem::SysGetHookInfo(MIL_ID HookContextId, MIL_INT64 InfoType, void *UserPtr, MIL_INT *Error)
{
   UNREFERENCED_PARAMETER(Error);
   if(m_FlashInfo.head[0].IsGTXCamera)
      MAsysGetHookInfo(M_NULL, HookContextId, InfoType, UserPtr);
   return M_VALID;
}


//==========================================================================
//
// Name:           SysIoAlloc()
//
// Synopsis:       Allocate an I/O command list
//
// Parameters:     MIL_INT64  IoObjectNum:   The number of the I/O command list to allocate
//                 MIL_INT64  InitFlag:      (Type) For now, this is always M_IO_COMMAND_LIST
//                 void       InitValue :    (CounterSrc).  The source of the I/O command list
//                 MD_ID      *IoObjectId:   i/o OBJECT id TO RETURN
//                 ThreadContextPtr:         Thread context object pointer.
//==========================================================================
MIL_INT MDHwSpecSystem::SysIoAlloc(MIL_INT64 IoObjectNum, MIL_INT64 InitFlag, MIL_INT64 InitValue, MD_ID *IoObjectPtr, MDDriverThreadContext *ThreadContextPtr)
{
   UNREFERENCED_PARAMETER(ThreadContextPtr);
   if(m_FlashInfo.head[0].IsGTXCamera)
      MAsysIoAlloc(M_NULL, IoObjectNum, InitFlag, InitValue, IoObjectPtr);
   return M_VALID;
}

//==========================================================================
//
// Name:           SysIoFree()
//
// Synopsis:       Free an I/O command list
//
// Parameters:     MD_ID IoObjectId              : The ID of the I/O command list
//                 ThreadContextPtr              : Thread context object pointer.
//==========================================================================
MIL_INT MDHwSpecSystem::SysIoFree(MD_ID IoObjectId, MDDriverThreadContext  *ThreadContextPtr)
{
   UNREFERENCED_PARAMETER(ThreadContextPtr);
   if(m_FlashInfo.head[0].IsGTXCamera)
      MAsysIoFree(IoObjectId);

   return M_VALID;
}

//==========================================================================
//
// Name:           SysIoControl()
//
// Synopsis:       Control an I/O command list
//
// Parameters:     MD_ID IoObjectId              : The ID of the I/O command list
//                 MIL_INT64 ControlType         : Control type
//                 MIL_INT64 ControlValue        : Control value
//                 ThreadContextPtr              : Thread context object pointer.
//==========================================================================
MIL_INT MDHwSpecSystem::SysIoControl(MD_ID IoObjectId, MIL_INT64 ControlType, const MULTI_TYPES& CtrlValue, MDDriverThreadContext  *ThreadContextPtr)
{
   UNREFERENCED_PARAMETER(ThreadContextPtr);
   MULTI_TYPES ControlValue = CtrlValue;
   // If it is an internal signal, convert it to grab value
   if ((ControlType >= M_REFERENCE_LATCH_TRIGGER_SOURCE + M_LATCH1) && (ControlType <= M_REFERENCE_LATCH_TRIGGER_SOURCE + M_LATCH4))
   {
      MIL_INT64 MIControlValue = CtrlValue;
      switch (MIControlValue)
      {
      case M_EXPOSURE:
         MIControlValue = M_CC_IO2;
         break;
      case M_TIMER_STROBE:
         MIControlValue = M_CC_IO3;
         break;
      case M_GRAB_TRIGGER_READY:
         MIControlValue = M_CC_IO4;
         break;
      }
      ControlValue = MIControlValue;
   }

#if M_MIL_USE_64BIT
   if (M_IN_SYS_IO_INQUIRE_DOUBLE_RANGE(ControlType))
   {
   if(m_FlashInfo.head[0].IsGTXCamera)
         MAsysIoControlDouble(IoObjectId, ControlType, ControlValue);
   }
   else
   {
   if(m_FlashInfo.head[0].IsGTXCamera)
         MAsysIoControlInt64(IoObjectId, ControlType, ControlValue);
   }
#else
   {
   if(m_FlashInfo.head[0].IsGTXCamera)
         MAsysIoControl(IoObjectId, ControlType, ControlValue);
   }
#endif
   return M_VALID;
}

//==========================================================================
//
// Name:           SysIoInquire()
//
// Synopsis:       Inquire an I/O command list
//
// Parameters:     MD_ID IoObjectId              : The ID of the I/O command list
//                 MIL_INT64 InquireType         : The type of inquire
//                 MIL_INT64 InquireValue        : The value of the inquire
//                 ThreadContextPtr              : Thread context object pointer.
//==========================================================================
MIL_INT MDHwSpecSystem::SysIoInquire(MD_ID IoObjectId, MIL_INT64 InquireType, void *InquireValue, MDDriverThreadContext  *ThreadContextPtr)
{
   UNREFERENCED_PARAMETER(ThreadContextPtr);
   if(m_FlashInfo.head[0].IsGTXCamera)
   {
      MAsysIoInquire(IoObjectId, InquireType, InquireValue);

      // If it is an internal signal, convert it to grab value
      if ((InquireType >= M_REFERENCE_LATCH_TRIGGER_SOURCE + M_LATCH1) && (InquireType <= M_REFERENCE_LATCH_TRIGGER_SOURCE + M_LATCH4))
      {
         switch (*(MIL_INT *)InquireValue)
         {
         case M_CC_IO2:
            *(MIL_INT *)InquireValue = M_EXPOSURE;
            break;
         case M_CC_IO3:
            *(MIL_INT *)InquireValue = M_TIMER_STROBE;
            break;
         case M_CC_IO4:
            *(MIL_INT *)InquireValue = M_GRAB_TRIGGER_READY;
            break;
         }
      }
   }
return M_VALID;
}

//==========================================================================
//
// Name:           SysIoCommandRegister()
//
// Synopsis:       Register an I/O command in the I/O command list
//
// Parameters:     MD_ID IoObjectId                  : The ID of the I/O command list
//                 MIL_INT64 Operation               : Operation on the command list.
//                 MIL_INT64 ReferenceStamp          : Reference from wich a command is registered
//                 MIL_DOUBLE DelayFromReferenceStamp: Delay from the reference
//                 MIL_DOUBLE Duration               : The duration of the operation, only when it is a pulse.
//                 MIL_INT64  BitToOperate           : The bit of the I/O command list to operate.
//                 MIL_INT   *CommandStatusPtr       : The status of the operation.
//                 ThreadContextPtr                  : Thread context object pointer.
//==========================================================================
MIL_INT MDHwSpecSystem::SysIoCommandRegister(MD_ID                   IoObjectId,
                                             MIL_INT64               Operation,
                                             MIL_INT64               ReferenceStamp,
                                             MIL_DOUBLE              DelayFromReferenceStamp,
                                             MIL_DOUBLE              Duration,
                                             MIL_INT64               BitToOperate,
                                             MIL_INT                *CommandStatusPtr,
                                             MDDriverThreadContext  *ThreadContextPtr)
{
   UNREFERENCED_PARAMETER(ThreadContextPtr);
   if(m_FlashInfo.head[0].IsGTXCamera)
      MAsysIoCommandRegister(IoObjectId, Operation, ReferenceStamp, DelayFromReferenceStamp, Duration, BitToOperate, CommandStatusPtr);
   return M_VALID;
}

//==========================================================================
//
// Name:           SysLocalCpuCom()
//
// Synopsis:       Communicate with FPGA Local CPU (Microblaze) with input and output buffer
//
// Parameters:     MD_ID SystemId             : The Id of the system
//                 MIL_INT ProcNb,            : Processor number, not used
//                 void *InData,              : Input buffer pointer
//                 MIL_INT InDataSize,        : Input buffer size
//                 void *OutData,             : Out buffer pointer  
//                 MIL_UINT OutDataSize,      : Output buffer size
//                 MIL_INT *Status,           : Status of the operation
//                 ThreadContextPtr           : Thread context object pointer.
//
//==========================================================================
MIL_INT MDHwSpecSystem::SysLocalCpuCom(MD_ID                  SystemId,
                                       MIL_INT                ProcNb,
                                       void                  *InData,
                                       MIL_INT                InDataSize,
                                       void                  *OutData,
                                       MIL_INT                OutDataSize,
                                       MIL_INT               *Status,
                                       MDDriverThreadContext *ThreadContextPtr)
{
   UNREFERENCED_PARAMETER(ThreadContextPtr);
   if(m_FlashInfo.head[0].IsGTXCamera)
      MAsysLocalCpuCom(SystemId, ProcNb, InData, (MIL_UINT32)InDataSize, OutData, (MIL_UINT32)OutDataSize, Status);
   return M_VALID;
}



//==============================================================================
//
//   Name:       BufFree()
//
//   Synopsis:   Free the system platform memory previously allocated.
//
//   Parameters: MD_ID Buffer ID    : Buffer to free.
//               ThreadContextPtr   : Thread context object pointer.
//
//==============================================================================
MIL_INT MDHwSpecSystem::BufFree(MD_ID BufferId, MDDriverThreadContext *ThreadContextPtr)
   {
   CError              lError;
   MDHwSpecBufferInfo *BufferInfoPtr    = Buffers[BufferId];

   if(BufferInfoPtr)
      {
      // Free buffer on host if any
      if(BufferInfoPtr->HostId())
         {
         MbufFree(BufferInfoPtr->HostId());
         BufferInfoPtr->HostId(0);
         }

      if(BufferInfoPtr->NativeBufferId())
         {
         if(!BufferInfoPtr->IsAssociatedWithDriver())
            {
            BUF_FREE BufFree;
            BufFree.ThreadHandle   = ThreadContextPtr->LLThreadHandle();
            BufFree.iBufferHandle  = BufferInfoPtr->NativeBufferId();

            LLBufFree(SystemId(), BufFree, lError, ThreadContextPtr);

            if(lError.ErrorLogged())
               goto end;
            }
         BufferInfoPtr->NativeBufferId(0);
         }

      Buffers.Erase(BufferId);
      }
end:
   return(M_VALID);
   }

//==============================================================================
//
//   Name:       BufInquire()
//
//   Synopsis:   Inquire buffer information.
//
//   Parameters: MD_ID SystemID         : ID of the system to use.
//               MD_ID BufferId         : ID of the buffer.
//               MIL_INT ParamToInquire : Parameter to inquire.
//               void *Ptr              : Pointer to the returned value.
//               ThreadContextPtr       : Thread context object pointer.
//
//==============================================================================
MIL_INT MDHwSpecSystem::BufInquire(MD_ID BufferId, MIL_INT64 ParamToInquire, void *Ptr, MDDriverThreadContext *ThreadContextPtr)
   {
   MIL_INT             Done             = M_VALID;
   bool                UseHostInquire   = false;
   MDHwSpecBufferInfo *BufferInfoPtr    = Buffers[BufferId];

   if(BufferInfoPtr == NULL)
      {
      ErrorCode(M_BUFFER_ERROR_0, 4);
      goto End;
      }

   if(!BufferInfoPtr->IsAllocatedOnHost() && BufferInfoPtr->NativeBufferId())
      {
      switch(ParamToInquire)
         {
         case M_PHYSICAL_ADDRESS_REMOTE:
            {
            if((BufferInfoPtr->Format() & M_PLANAR) && (BufferInfoPtr->SizeBand() != 1))
               {
               Ptr = NULL;
               }
            else
               {
               CError      lError;
               BUF_INQUIRE BufInquire;

               BufInquire.ThreadHandle  = ThreadContextPtr->LLThreadHandle();
               BufInquire.iBufferHandle = BufferInfoPtr->NativeBufferId();
               BufInquire.iInquireType  = (MIL_UINT)ParamToInquire;

               LLBufInquire(SystemId(), BufInquire, lError, ThreadContextPtr);

               *(MIL_UINT*)Ptr = BufInquire.olInquiredValue[0];
               }
            UseHostInquire = false;
            }
            break;
         default:
            UseHostInquire = true;
            break;
         }
      }
   else
      {
      UseHostInquire = true;
      }

   if(UseHostInquire)
      Done = MDDeviceSystem::BufInquire(BufferId, ParamToInquire, Ptr, ThreadContextPtr);

End:
   return(Done);
   }

//==============================================================================
//
//   Name:       BufControl()
//
//   Synopsis:   Permit to control the behavior of a digitizer.
//
//   Parameters: MD_ID BufferId        : Buffer to use.
//               MIL_INT ControlType   : Type of control to change.
//               MIL_MULTI_TYPES_BW Value : Value for the control parameter.
//               ThreadContextPtr      : Thread context object pointer.
//
//==============================================================================
MIL_INT MDHwSpecSystem::BufControl(MD_ID BufferId, MIL_INT64 ControlType, const MULTI_TYPES& ControlValue, MDDriverThreadContext *ThreadContextPtr)
   {
   return MDDeviceSystem::BufControl(BufferId, ControlType, ControlValue, ThreadContextPtr);
   }

//==============================================================================
//
//   Name:       BufChildColor2d()
//
//   Synopsis:   Allocate a child data buffer within a color parent buffer
//
//   Parameters: MD_ID ParentBufferId  : ParentBufferId.
//               MIL_INT Band          : Index of the color band
//               MIL_INT OffX          : X offset for get.
//               MIL_INT OffY          : Y offset for get.
//               MIL_INT SizeX         : X size of get.
//               MIL_INT SizeY         : Y size of get.
//               MD_ID *ChildBufferId  : New Buffer id of the buffer
//               ThreadContextPtr      : Thread context object pointer.
//
//==============================================================================
MIL_INT MDHwSpecSystem::BufChildColor2d(MD_ID ParentBufferId, MIL_INT Band, MIL_INT OffsetX, MIL_INT OffsetY, MIL_INT SizeX, MIL_INT SizeY, MD_ID *ChildBufferId, MDDriverThreadContext * ThreadContextPtr)
   {
   bool                AllocationFailed      = false;
   MDHwSpecBufferInfo *BufferInfoPtr         = 0;
   MDHwSpecBufferInfo *ParentBufferInfoPtr   = 0;
   MDHwSpecBufferInfo *AncestorBufferInfoPtr = 0;
   MIL_ID              HostId                = 0;
   void               *LLChildBufferHandle   = 0;
   MIL_INT             BandIndex             = 0;
   CError              lError;
   *ChildBufferId = 0;

   ParentBufferInfoPtr   = Buffers[ParentBufferId];
   AncestorBufferInfoPtr = Buffers[ParentBufferInfoPtr->AncestorId()];

   if(ParentBufferInfoPtr)
      {
      // Allocate buffer on the host
      MbufChildColor2d(ParentBufferInfoPtr->HostId(), Band, OffsetX, OffsetY, SizeX, SizeY, &HostId);

      if(!HostId)
         {
         AllocationFailed=true;
         goto end;
         }

      // Calculate Band Index
      MIL_INT64 BufFormat = (ParentBufferInfoPtr->Format() & M_INTERNAL_FORMAT);

      if(Band == M_ALL_BAND)
         {
         BandIndex = Band;
         }
      else if((Band == M_RED) || (Band == M_GREEN) || (Band == M_BLUE))
         {
         switch(BufFormat)
            {
            // planar formats
            case M_MONO1:
            case M_MONO8:
            case M_MONO16:
            case M_MONO32:
               {
               if(Band == M_RED)
                  {
                  BandIndex = 0;
                  }
               else
                  {
                  ErrorCode(M_BUFFER_ERROR_1, 1);
                  goto end;
                  }
               }
               break;
            case M_RGB3:
            case M_RGB24:
            case M_RGB32:
            case M_RGB48:
            case M_RGB96:
               {
               if(Band == M_RED)
                  BandIndex = 0;
               else if(Band == M_GREEN)
                  BandIndex = 1;
               else if(Band == M_BLUE)
                  BandIndex = 2;
               }
               break;
            case M_BGR24:
            case M_BGR32:
               {
               if(Band == M_RED)
                  BandIndex = 3;
               else if(Band == M_GREEN)
                  BandIndex= 2;
               else if(Band == M_BLUE)
                  BandIndex = 1;
               }
               break;
            case M_YUV16:
               {
               if(Band == M_Y)
                  BandIndex = 0;
               else if(Band == M_U)
                  BandIndex = 1;
               else if(Band == M_V)
                  BandIndex = 2;
               }
               break;
            default:
               {
               if(ParentBufferInfoPtr->SizeBand() >= 3)
                  {
                  if(Band == M_RED)
                     BandIndex = 0;
                  else if(Band == M_GREEN)
                     BandIndex = 1;
                  else if(Band == M_BLUE)
                     BandIndex = 2;
                  }
               else
                  {
                  BandIndex = 0;
                  }
               }
            }
         }
      else
         {
         if((Band >= 0) && (Band < ParentBufferInfoPtr->SizeBand()))
            BandIndex = Band;
         else
            {
            ErrorCode(M_BUFFER_ERROR_1, 1);
            goto end;
            }
         }

      // Special case for kernels, lut and results since they are on host.
      if(ParentBufferInfoPtr->NativeBufferId())
         {
         BUF_CHILD BufChild;

         BufChild.Init();
         BufChild.ThreadHandle         = SyncThreadHandle();
         BufChild.iParentBufferHandle  = ParentBufferInfoPtr->NativeBufferId();
         BufChild.iOffsetX             = OffsetX;
         BufChild.iOffsetY             = OffsetY;
         BufChild.iSizeX               = SizeX;
         BufChild.iSizeY               = SizeY;
         BufChild.oBufferHandle        = NULL;
         BufChild.iBand                = BandIndex;

          // Allocate on-board buffer
         LLBufChild(SystemId(), BufChild, lError, ThreadContextPtr);

         if(lError.ErrorLogged())
            {
            AllocationFailed = true;
            goto end;
            }

         LLChildBufferHandle = BufChild.oBufferHandle;
         }

      // Create the BufferInfo object
      BufferInfoPtr = Buffers.Create<MDHwSpecBufferInfo>(this);
      if(!BufferInfoPtr)
         {
         ErrorCode(M_MEMORY_ERROR_0, 1);
         AllocationFailed = true;
         goto end;
         }

      *ChildBufferId = BufferInfoPtr->MDId();

      // Inquire MIL buffer info structure
      BufferInfoPtr->Init(HostId);
      BufferInfoPtr->ParentId(ParentBufferId);
      BufferInfoPtr->AncestorId(ParentBufferInfoPtr->AncestorId());
      BufferInfoPtr->MDId(*ChildBufferId);
      BufferInfoPtr->HostId(HostId);

      // Update physical address
      // Set physical addresses to 64 bit
      for(int i = 0; i < ParentBufferInfoPtr->SizeBand(); i++)
         BufferInfoPtr->I64PhysAddresses(i, (PHYSICAL_ADDRESS_TYPE)((MIL_UINT)BufferInfoPtr->BandPhysPtr(i)));

      // Adapt format to MIL Format
      BufferInfoPtr->OrgAttribute(BufferInfoPtr->Attribute() | (ParentBufferInfoPtr->Attribute() & IRIS_GTX_BUFFER_FORMAT_MASK));
      BufferInfoPtr->Attribute(BufferInfoPtr->Attribute() | (ParentBufferInfoPtr->Attribute() & IRIS_GTX_BUFFER_FORMAT_MASK));
      BufferInfoPtr->Format(BufferInfoPtr->Format() | (ParentBufferInfoPtr->Format() & IRIS_GTX_BUFFER_FORMAT_MASK));
      BufferInfoPtr->NativeBufferId(LLChildBufferHandle);

      if(ParentBufferInfoPtr->YCbCrRange())
         BufControl(BufferInfoPtr->MDId(), M_YCBCR_RANGE, ParentBufferInfoPtr->YCbCrRange(), ThreadContextPtr);
      }

   end:

   // Free everything if allocation was not successful.
   if(AllocationFailed)
      {
      // Deallocate the Host buffer if any
      if(HostId)
         MbufFree(HostId);

      if(LLChildBufferHandle)
         {
         BUF_FREE BufFree;
         BufFree.Init();
         BufFree.ThreadHandle   = ThreadContextPtr->LLThreadHandle();
         BufFree.iBufferHandle  = LLChildBufferHandle;

         LLBufFree(SystemId(), BufFree, lError, ThreadContextPtr);

         LLChildBufferHandle = 0;
         }

      if(*ChildBufferId)
         {
         BufferInfoPtr->HostId(0);

         Buffers[*ChildBufferId];
         *ChildBufferId = 0L;
         }
      }

   return(M_VALID);
   }

//==============================================================================
//
//   Name:       DigAlloc()
//
//   Synopsis:   Allocate a digitizer on the system platform.
//
//   Parameters: MIL_TEXT_PTR FileName : Digitizer configuration file.
//               MIL_INT DigNumber     : Digitizer number
//               MIL_INT64 InitFlag    : Initialization flag.
//               MD_ID *DigitizerId    : New digitizer ID.
//               ThreadContextPtr      : Thread context object pointer.
//
//==============================================================================
MIL_INT MDHwSpecSystem::DigAlloc(MIL_TEXT_PTR           Format,
                                 MIL_INT                DigNumber,
                                 MIL_INT64              InitFlag,
                                 MD_ID                 *DigitizerId,
                                 MDDriverThreadContext *ThreadContextPtr)
   {
   CError            lError;
   CError            lNonFatalError;
   MIL_INT           lErrorFlag;
   CDigConfig       *lpDigConfig       = NULL;
   MDHwSpecDigitizerInfo  *lpDigInfo         = NULL;
   MIL_UINT          Hook              = 0;
   DIG_ALLOC         lDigAlloc;
   DIG_INQUIRE       lDigInquire;
   CAMERA            lCamera;
   vector<MIL_STRING> lGenICamSettings;
   bool              IsDcfLoaded = false;

   *DigitizerId = 0;
   MilLockGuard Lock(m_CSectionGlobal);

   //Do some parameter checking
   if ((InitFlag != M_DEFAULT) && (InitFlag != M_FAST))
      {
      lError.Log(M_DIGITIZER_ERROR_0, 2); //Invalid InitFlag.
      goto end;
      }

   if(DigNumber != M_DEV0)
      {
      lError.Log(M_DIGITIZER_ERROR_0, 1); //Device number not supported.
      goto end;
      }

   // set M_DEFAULT in info_register_rev so the kernel mode initialize the camera struct.
   lCamera.camera.description.info_register_rev = M_DEFAULT;
   lCamera.flag.description.info_register_rev = 1;

   //Load the DCF
   if (MOs_strnicmp(Format, MT("M_DEFAULT"), 10) != 0)
   {
      lGenICamSettings.clear();
      lError = DigLoadDcf(Format, &lCamera, lGenICamSettings, InitFlag);
      if (lError.ErrorLogged())
         goto end;
      IsDcfLoaded = true;
   }

   //Allocate a digitizer structure that will be used in all
   //subsequent DigXXX calls.
   lpDigConfig = new CDigConfig(DigNumber, InitFlag, lCamera);

   if(!lpDigConfig)
      {
      lError.Log(M_MEMORY_ERROR_0, 1);
      goto end;
      }

   lpDigInfo = Digitizers.Create<MDHwSpecDigitizerInfo>(this, Format, DigNumber, InitFlag, lpDigConfig, lCamera, &lErrorFlag);
   if (!lpDigInfo)
      {
      lError.Log(M_MEMORY_ERROR_0, 1);
      goto end;
      }
   lpDigInfo->LogList(M_DISABLE);

   *DigitizerId = lpDigConfig->MDId = lpDigInfo->MDId();

   //Initialize dig alloc structure for kernel mode.
   lDigAlloc.DigConfig     = *lpDigConfig;
   lDigAlloc.SystemId      = SystemId();
   lDigAlloc.ThreadHandle  = ThreadContextPtr->LLThreadHandle();
   lDigAlloc.DCF           = lCamera;
   lDigAlloc.InitFlag      = InitFlag;

   //Make the LowLevel call
   LLDigAlloc(SystemId(), lDigAlloc, lError, ThreadContextPtr);
   if(lError.ErrorLogged())
      {
      goto end;
      }

   //Record the kernel handle for this digitizer returned by GrabUnit
   if (lDigAlloc.DigConfig.GrabUnitHandle == NULL || lDigAlloc.DigConfig.DigitizerHandle == NULL)
      {
      lError.Log(M_DIGITIZER_ERROR_1, 2);     //Invalid low-level handle returned.
      goto end;
      }

   lpDigConfig->GrabUnitHandle = lDigAlloc.DigConfig.GrabUnitHandle;
   lpDigConfig->DigitizerHandle = lDigAlloc.DigConfig.DigitizerHandle;

   if (lCamera.camera.description.info_register_rev == M_DEFAULT)
      {
      // We got the DCF parameters from the kernel mode...
      // Now init the digconfig.      
      lpDigInfo->DCF = lDigAlloc.DCF;

      lpDigConfig->Properties.SizeX = lDigAlloc.DCF.camera.description.info_xsize;
      lpDigConfig->Properties.SizeY = lDigAlloc.DCF.camera.description.info_ysize;
      lpDigConfig->Properties.SourceSizeX = lDigAlloc.DCF.camera.description.info_xsize;
      lpDigConfig->Properties.SourceSizeY = lDigAlloc.DCF.camera.description.info_ysize;
      lpDigConfig->Properties.SizeBit = lDigAlloc.DCF.camera.description.info_depth;
      lpDigConfig->Properties.SizeBand = lDigAlloc.DCF.camera.description.info_band;
      lpDigConfig->Properties.BayerInfo = lDigAlloc.DCF.camera.description.info_bayer;
      if(lDigAlloc.DCF.camera.description.info_bayer)
         {
         lpDigConfig->Properties.BayerEnable(true);
         lpDigConfig->Properties.ColorMode = M_RGB;
         }
      }

   // Register the hooks functions for grab buf modified.
   for(Hook = 0; Hook < GetNbBufModifiedThreads(); Hook++)
      {
      mp_UserHook->RegisterHookFunction((HOOK_TYPE_DIG_BUF_MODIFIED | lpDigConfig->MDId), this, &m_BufModified, MilId(), ThreadContextPtr);
      if(ErrorCode() != M_NO_ERROR)
         goto end;
      }

   lDigInquire.DigConfig      = *lpDigConfig;
   lDigInquire.InquireType    = M_GRAB_TRIGGER_STATE;
   lDigInquire.ThreadHandle   = ThreadContextPtr->LLThreadHandle();

   LLDigInquire(SystemId(), lDigInquire, lError, ThreadContextPtr);

   if(M_ENABLE == lDigInquire.InquiredValue)
      {
      lpDigConfig->Properties.GrabTriggerMode = M_ENABLE;
      }
    else
      lpDigConfig->Properties.GrabTriggerMode = M_DISABLE;

   //Load the DCF
   if (IsDcfLoaded)
      {
      // Set the setting of the DCF, it will be programmed when we receive the MdigControl(M_MIL_ID_INTERNAL) of the digitizer.
      lpDigInfo->SetGenICamDCFSettings(lGenICamSettings);
      }

end:
   //If an error occurred, log it to MIL.
   if(lError.ErrorLogged())
      {
      // If kernel call succeded, cleanup
      if(lDigAlloc.DigConfig.GrabUnitHandle)
         {
         DigFree(*DigitizerId, ThreadContextPtr);
         }
      else
         {

         if(*DigitizerId)
            Digitizers.Erase(*DigitizerId);

         if(lpDigConfig)
            delete lpDigConfig;
         }
      // MIL uses this to know if valid...
      *DigitizerId = 0;
      // Log error.
      ErrorCode(lError.SystemErrorNumber(), lError.SystemSubMessage1());
      }
   else if (lNonFatalError.ErrorLogged())
      {
      ErrorCode(lNonFatalError.SystemErrorNumber(), lNonFatalError.SystemSubMessage1());
      }
   else
      {
      // Wait for decoder to lock for analog
      if(lCamera.camera.description.info_signaltype == 1)
         {
         // SD needs more time to lock then HD
         if(lpDigInfo->SizeX() <= 768)
            Sleep(16*(DWORD)lpDigInfo->GrabPeriod());
         else
            Sleep(3*(DWORD)lpDigInfo->GrabPeriod());
         }

      if(m_FlashInfo.head[0].IsGTXCamera)
         {
         // Upon success of digAlloc, initialize M_LIGHTING_BRIGHT_FIELD
         MAsysControl(M_NULL, M_LIGHTING_BRIGHT_FIELD, M_DEFAULT);
         }

      // Set Focus value on lens if persistence is on
      MIL_INT Focus = 0;
      DigInquire(*DigitizerId, M_FOCUS, &Focus, ThreadContextPtr);
      // If controlable lens is present
      if (Focus != M_INVALID)
         {
         MIL_INT FocusPersistence = M_DISABLE;
         MIL_INT FocusPersistentValue = M_INVALID;
         DigInquire(*DigitizerId, M_FOCUS_PERSISTENCE, &FocusPersistence, ThreadContextPtr);
         DigInquire(*DigitizerId, M_FOCUS_PERSISTENT_VALUE, &FocusPersistentValue, ThreadContextPtr);
         if((FocusPersistence == M_ENABLE) && (FocusPersistentValue != M_INVALID) && (FocusPersistentValue != Focus))
            DigControl(*DigitizerId, M_FOCUS+M_WAIT, FocusPersistentValue, ThreadContextPtr);
         }
      }
   return(M_VALID);
   }

//==============================================================================
//
//   Name:       DigFree()
//
//   Synopsis:   Free the digitizer previously allocated.
//
//   Parameters: MD_ID Digitizer ID : Digitizer to free.
//               ThreadContextPtr   : Thread context object pointer.
//
//==============================================================================
MIL_INT MDHwSpecSystem::DigFree(MD_ID DigitizerId, MDDriverThreadContext *ThreadContextPtr)
   {
   CError                 lError;
   DIG_FREE               lDigFree;
   MDDigitizerInfo       *lpDigitizerInfo  = Digitizers[DigitizerId];
   CDigConfig            *lpDigConfig      = lpDigitizerInfo->GetDigConfig();

   lDigFree.DigConfig      = *lpDigConfig;
   lDigFree.ThreadHandle   = ThreadContextPtr->LLThreadHandle();
   lDigFree.SystemId       = SystemId();

   // Wait for grab to finished
   DigGrabWait(DigitizerId, M_GRAB_END, ThreadContextPtr);

   if(ErrorCode())
      {
      //Reset error and abort grab!
      ErrorCode(M_NO_ERROR);

      DigControl(DigitizerId, M_GRAB_ABORT, M_DEFAULT, ThreadContextPtr);
      }

   lpDigitizerInfo->CleanUp();

   //Make the LowLevel call
   LLDigFree(SystemId(), lDigFree, lError, ThreadContextPtr);

   // UnRegister the hooks functions for grab buf modified.
   for(MIL_UINT Hook = 0; Hook < GetNbBufModifiedThreads(); Hook++)
      mp_UserHook->UnRegisterHookFunction((HOOK_TYPE_DIG_BUF_MODIFIED | lpDigConfig->MDId), this, ThreadContextPtr);

   // Call base class to remove GenICam proxies.
   MDGeniCamDeviceSystem::DigFree(DigitizerId, ThreadContextPtr);

   Digitizers.Erase(DigitizerId);

   if(lpDigConfig->Properties.WhiteBalanceBufUserId())
      MbufFree(lpDigConfig->Properties.WhiteBalanceBufUserId());

   delete lpDigConfig;

   return(M_VALID);
   }

/****************************************************************************************************
*
*     Name:         MDHwSpecSystem::DigGrab
*
*     Parameters:   MD_ID DigitizerId:
*                   MD_ID BufferId:
*                   MIL_INT  NbIteration:
*                   MDDriverThreadContext *ThreadContextPtr:
*
****************************************************************************************************/
MIL_INT MDHwSpecSystem::DigGrab(MD_ID DigitizerId, MD_ID BufferId, MIL_INT NbIteration, MDDriverThreadContext *ThreadContextPtr)
   {
   CError                 lError;
   MDHwSpecBufferInfo    *lpBufInfo       = Buffers[BufferId];
   MDHwSpecDigitizerInfo *lpDigInfo       = Digitizers[DigitizerId];
   CDigConfig            *lpDigConfig     = lpDigInfo->GetDigConfig();
   CHwSpecDigProperties  *lpProperties    = &(lpDigConfig->Properties);
   DIG_GRAB               lDigGrab;
   bool                   lDoUnlock = true;
   lpDigInfo->Lock();

   if(NbIteration != M_FOREVER && DigCheckValidGrab(DigitizerId, BufferId, NbIteration, ThreadContextPtr) == M_INVALID)
      {
      ErrorCode(M_DIGITIZER_ERROR_3, 3); //Invalid buffer format.
      goto end;
      }

   //Validate source offset and source size
   if((lpProperties->SourceSizeX + lpProperties->SourceOffsetX) > (MIL_INT)lpDigInfo->DCF.camera.description.info_xsize)
      ErrorCode(M_DIGITIZER_ERROR_0, 4);    //Invalid digitizer source size and/or source offset.
   else if((lpProperties->SourceSizeY + lpProperties->SourceOffsetY) > (MIL_INT)lpDigInfo->DCF.camera.description.info_ysize)
      ErrorCode(M_DIGITIZER_ERROR_0, 4);    //Invalid digitizer source size and/or source offset.

   //Validate bayer on board
   if((!lpProperties->BayerEnable()) && (lpBufInfo->GetBufferProperties().SizeBand != 1))
      ErrorCode(M_DIGITIZER_ERROR_3, 3);    //Invalid buffer format or size.

   if((m_FlashInfo.head[0].BoardRevision & 0xF) == 1)
      {
      //Nexis and G2x8 don't support 10 bit grab...
      if(lpBufInfo->GetBufferProperties().BitsPerPixel > 8)
         ErrorCode(M_DIGITIZER_ERROR_3, 3);    //Invalid buffer format or size.
      }

   if(!ErrorCode())
      {
      if(NbIteration == M_FOREVER)
         {
         lpDigInfo->ContinuousGrabInProgress(true);
         lpDigInfo->ContinuousGrabBufId(BufferId);
         }

      DigPrepareGrab(DigitizerId, NbIteration, ThreadContextPtr->LLThreadHandle(), lDigGrab);

      DigPrepareXfer(BufferId, lpDigInfo, lDigGrab.iBufProperties);

      if(NbIteration != M_FOREVER)
         {
         if(lpBufInfo->MilId())
            {
            //If it's a MIL buffer, always lock it...
            //In the callback, we will decide if we need to make the MbufControlArea
            MbufControl(lpBufInfo->MilId(), M_DRIVER_ASYNC_CALL, M_INCREMENT_ASYNC);
            }
         }

      lpDigInfo->Unlock();
      lDoUnlock = false;

      //Make the LowLevel call
      LLDigGrab(SystemId(), lDigGrab, lError, ThreadContextPtr);

      if(lError.ErrorLogged())
         {
         if(NbIteration == M_FOREVER)
            {
            lpDigInfo->ContinuousGrabInProgress(false);
            }

         ErrorCode(lError.SystemErrorNumber(), lError.SystemSubMessage1());

         if(lError.SystemErrorNumber() == M_GRAB_ERROR_0 && lError.SystemSubMessage1() == 1)  //Synchronization lost (Time out).
            {
            //We have a sync loss, abort grab
            SysControl(M_THREAD_COMMANDS_ABORT, M_THREAD_CURRENT, ThreadContextPtr);
            DigControl(DigitizerId, M_GRAB_ABORT, M_DEFAULT, ThreadContextPtr);
            }
         }
      }

end:

   if(lDoUnlock)
      lpDigInfo->Unlock();

   return(M_VALID);
   }

/****************************************************************************************************
*
*     Name:         MDHwSpecSystem::DigPrepareGrab
*
*     Parameters:   MD_ID DigitizerId:
*                   MIL_INT NbIteration:
*                   HANDLE iLLThreadHandle:
*                   DIG_GRAB &oDigGrab:
*
****************************************************************************************************/
void MDHwSpecSystem::DigPrepareGrab(MD_ID DigitizerId, MIL_INT NbIteration, CCommandFIFO *iLLThreadHandle, DIG_GRAB &oDigGrab)
   {
   MDDigitizerInfo       *lpDigInfo    = Digitizers[DigitizerId];
   CDigConfig            *lpDigConfig  = lpDigInfo->GetDigConfig();

   MDrv_memcpy(&(oDigGrab.DigConfig), lpDigConfig, sizeof(CDigConfig));

   oDigGrab.ThreadHandle     = iLLThreadHandle;
   oDigGrab.SystemId         = SystemId();
   oDigGrab.oGrabCmdHandle   = 0;
   oDigGrab.IsContinuousGrab = false;

   if(NbIteration == M_FOREVER)
      oDigGrab.IsContinuousGrab = true;
   }

/****************************************************************************************************
*
*     Name:         MDHwSpecSystem::DigPrepareXfer
*
*     Parameters:   MD_ID                   BufferId:
*                   MDDigitizerInfo        *iDigInfo
*                   GRAB_BUFFER_PROPERTIES &oGrabBufProp:
*
****************************************************************************************************/
void MDHwSpecSystem::DigPrepareXfer(MD_ID BufferId, MDHwSpecDigitizerInfo *iDigInfo, GRAB_BUFFER_PROPERTIES &oGrabBufProp, MIL_INT iBufferIndex/* = -1*/, bool iPrepareChunkData /* false*/)
   {
   UNREFERENCED_PARAMETER(iPrepareChunkData);
   MDHwSpecBufferInfo *lpBufInfo  = Buffers[BufferId];

   double  lGrabScaleX                    = iDigInfo->GrabScaleX();
   double  lGrabScaleY                    = iDigInfo->GrabScaleY();
   MIL_INT lShift                         = 0;
   oGrabBufProp.iDestBuffer               = lpBufInfo->GetBufferProperties();
   oGrabBufProp.iDestBuffer.BufferIndex   = iBufferIndex;
   oGrabBufProp.iOnBrdUserBufHnd          = lpBufInfo->NativeBufferId();

   //Calculate dynamic fill destination scaling.
   if(lGrabScaleX == M_FILL_DESTINATION)
      {
      lGrabScaleX =  ((double)lpBufInfo->SizeX()) / ((double)iDigInfo->DCF.camera.description.info_xsize);
      lGrabScaleX = AdjustScaleToFitHw(lGrabScaleX);
      }
   if(lGrabScaleY == M_FILL_DESTINATION)
      {
      lGrabScaleY = ((double)lpBufInfo->SizeY()) / ((double)iDigInfo->DCF.camera.description.info_ysize);
      lGrabScaleY = AdjustScaleToFitHw(lGrabScaleY);
      }

   //Check for pixel depth conversion
   if(lpBufInfo->SizeBit() < (MIL_INT)(iDigInfo->DCF.camera.description.info_depth))
      {
      MIL_INT BitsDiff = ((MIL_INT)iDigInfo->DCF.camera.description.info_depth) - lpBufInfo->SizeBit();
      switch(BitsDiff)
         {
         case 2:
            lShift = 1;
            break;
         case 4:
            lShift = 2;
            break;
         case 6:
            lShift = 3;
            break;
         case 8:
            lShift = 4;
            break;
         }
      }
   }

//==============================================================================
//
//   Name:       AdjustScaleToFitHw()
//
//   Synopsis:   Adjusts the scale to fit what the HW can do.
//
//   Parameters: MIL_DOUBLE : iScale : scale to adjust
//
//   Return value: MIL_DOUBLE : adjusted scale
//
//==============================================================================
MIL_DOUBLE MDHwSpecSystem::AdjustScaleToFitHw(MIL_DOUBLE iScale)
   {
   if(iScale >= 1.0)
      iScale = 1.0;
   else if(iScale >= (1.0/2.0))
      iScale = (1.0/2.0);
   else if(iScale >= (1.0/3.0))
      iScale = (1.0/3.0);
   else if(iScale >= (1.0/4.0))
      iScale = (1.0/4.0);
   else if(iScale >= (1.0/5.0))
      iScale = (1.0/5.0);
   else if(iScale >= (1.0/6.0))
      iScale = (1.0/6.0);
   else if(iScale >= (1.0/7.0))
      iScale = (1.0/7.0);
   else if(iScale >= (1.0/8.0))
      iScale = (1.0/8.0);
   else if(iScale >= (1.0/9.0))
      iScale = (1.0/9.0);
   else if(iScale >= (1.0/10.0))
      iScale = (1.0/10.0);
   else if(iScale >= (1.0/11.0))
      iScale = (1.0/11.0);
   else if(iScale >= (1.0/12.0))
      iScale = (1.0/12.0);
   else if(iScale >= (1.0/13.0))
      iScale = (1.0/13.0);
   else if(iScale >= (1.0/14.0))
      iScale = (1.0/14.0);
   else if(iScale >= (1.0/15.0))
      iScale = (1.0/15.0);
   else if(iScale >= (1.0/16.0))
      iScale = (1.0/16.0);

   return iScale;
   }

//==============================================================================
//
//   Name:       DigCheckValidGrab()
//
//   Synopsis:   Check if the grab can be performed in specified buffer.
//
//   Parameters: MD_ID DigitizerID  : Digitizer to use.
//               MD_ID BufferId     : Buffer to use.
//               MIL_INT NbIteration: Number of frames/field.
//               ThreadContextPtr   : Thread context object pointer.
//
//==============================================================================
MIL_INT MDHwSpecSystem::DigCheckValidGrab(MD_ID DigitizerId, MD_ID BufferId, MIL_INT NbIteration, MDDriverThreadContext *ThreadContextPtr)
   {
   UNREFERENCED_PARAMETER(NbIteration);
   UNREFERENCED_PARAMETER(ThreadContextPtr);
   MIL_INT                ValidGrab       = M_VALID;
   MDHwSpecBufferInfo    *lpBufInfo       = Buffers[BufferId];
   MDDigitizerInfo       *lpDigInfo       = Digitizers[DigitizerId];

   if(lpDigInfo->SourceSizeX() <= 0)
      {
      ValidGrab = M_INVALID;
      }
   else if(lpDigInfo->SourceOffsetX() + lpDigInfo->SourceSizeX() > lpDigInfo->SizeX())
      {
      ValidGrab = M_INVALID;
      }
   else if(lpDigInfo->SourceSizeY() <= 0)
      {
      ValidGrab = M_INVALID;
      }
   else if(lpDigInfo->SourceOffsetY() + lpDigInfo->SourceSizeY() > lpDigInfo->SizeY())
      {
      ValidGrab = M_INVALID;
      }

   if(lpBufInfo->Format() & M_DRV_ON_BOARD)
      { 
         ValidGrab = M_INVALID;
      }
   // TBM when we got the transfert unit that supporting all the stuff
   else if(!(  ((lpBufInfo->Format() & M_INTERNAL_FORMAT) == M_MONO8)      ||
               ((lpBufInfo->Format() & M_INTERNAL_FORMAT) == M_MONO16)     ||
               ((lpBufInfo->Format() & M_INTERNAL_FORMAT) == M_RGB24)      ||
               ((lpBufInfo->Format() & M_INTERNAL_FORMAT) == M_BGR24)      ||
               ((lpBufInfo->Format() & M_INTERNAL_FORMAT) == M_BGR32)      ||
               ((lpBufInfo->Format() & M_INTERNAL_FORMAT) == M_YUV16)      ||
               ((lpBufInfo->Format() & M_INTERNAL_FORMAT) == M_YUV16_YUYV) ||
               ((lpBufInfo->Format() & M_INTERNAL_FORMAT) == M_YUV16_UYVY)))
      {
      ValidGrab = M_INVALID;
      }

   // If we have a color sensor and bayer is enabled and we provided a 16 bit buffer, return M_INVALID.
   CDigConfig *lpDigConfig = lpDigInfo->GetDigConfig();
   if ((m_FlashInfo.head[0].HeadType & 0x01000000) && // Color sensor
       (lpDigConfig->Properties.BayerEnable()) &&  // Bayer is enabled 
       ((lpBufInfo->Format() & M_INTERNAL_FORMAT) == M_MONO16)) // We have a 16 bit buffer
      {
      ValidGrab = M_INVALID;
      }

   return ValidGrab;
   }

//==============================================================================
//
//   Name:       DigHalt()
//
//   Synopsis:   Stop a grab.
//
//   Parameters: MD_ID Digitizer ID : Digitizer to free
//               ThreadContextPtr   : Thread context object pointer.
//
//==============================================================================
MIL_INT MDHwSpecSystem::DigHalt(MD_ID DigitizerId, MDDriverThreadContext *ThreadContextPtr)
   {
   CError                 lError;
   MDDigitizerInfo       *lpDigInfo      = Digitizers[DigitizerId];
   CDigConfig            *lpDigConfig    = lpDigInfo->GetDigConfig();
   DIG_HALT               lDigHalt;

   lDigHalt.DigConfig = *lpDigConfig;
   lDigHalt.SystemId  = SystemId();

   //Make the LowLevel call
   LLDigHalt(SystemId(), lDigHalt, lError, ThreadContextPtr);

   lpDigInfo->ContinuousGrabInProgress(false);

   return(M_VALID);
   }

//==============================================================================
//
//   Name:       DigControl()
//
//   Synopsis:   Control the behavior of a digitizer.
//
//   Parameters: MD_ID DigitizerID     : Digitizer to use.
//               MIL_INT64 ControlType : Type of control to change.
//               MIL_MULTI_TYPES_BW Value : Value for the control parameter
//               ThreadContextPtr      : Thread context object pointer.
//
//==============================================================================
MIL_INT MDHwSpecSystem::DigControl(MD_ID DigitizerId, MIL_INT64 ControlType, const MULTI_TYPES& CtrlValue, MDDriverThreadContext *ThreadContextPtr)
   {
   MDHwSpecDigitizerInfo *lpDigitizerInfo = (MDHwSpecDigitizerInfo*)Digitizers[DigitizerId];
   bool                   lRestartContinuousGrab = false;
   bool                   lbLock = true;
   MIL_ID                 lGrabBuffer = 0;
   CError                 lError;
   bool                   lDispatchImmediate = (ControlType & M_DIG_DISPATCH_IMMEDIATE) ? true : false;

   if (M_DIG_CAM_BRD_BITS_SET(ControlType))
      {
      ErrorCode(M_DIGITIZER_ERROR_7, 1);  //M_BOARD and M_CAMERA cannot be used together.
      goto end;
      }
   else if (M_DIG_CAM_BIT_SET(ControlType))
      {
      ErrorCode(M_DIGITIZER_ERROR_7, 2);  //M_CAMERA is not supported on this system.
      goto end;
      }

   ControlType = M_DIG_STRIP_BRD_BIT(ControlType);
   ControlType &= ~M_DIG_DISPATCH_IMMEDIATE;

   // Determine the case where we don't want to Lock.
   if (ControlType == M_GRAB_ABORT)
      {
      lbLock = false;
      }
   else if ((ControlType == M_GRAB_TRIGGER_STATE) || (ControlType == M_GRAB_TRIGGER_SOFTWARE))
      {
      // This test need to be inside this if, because we need to cast to an integer
      // and for some ControlType it's not possible (correct) if MIL_MULTI_TYPES_BW
      // contain a double. It's not a problem in Win32 where MIL_MULTI_TYPES_BW is a double.
      if (CtrlValue == M_ACTIVATE)
         lbLock = false;
      }

   if (lbLock)
      lpDigitizerInfo->Lock();

   if (lpDigitizerInfo->MustStopGrabAtDigControl(ControlType, CtrlValue) == true)
      {
      lRestartContinuousGrab = true;
      lGrabBuffer = lpDigitizerInfo->ContinuousGrabBufId();
      MDHwSpecSystem::DigHalt(DigitizerId, ThreadContextPtr);
      if (ErrorCode())
         ErrorCode(M_NO_ERROR);
      }

   switch (ControlType)
      {
      case M_GRAB_TIMEOUT:
         {
         MIL_INT lIntValue = CtrlValue;
         switch (lIntValue)
            {
            case M_DEFAULT:
               lpDigitizerInfo->GrabTimeout(M_DEFAULT);
               break;
            case M_INFINITE:
               lpDigitizerInfo->GrabTimeout(M_INFINITE);
               break;
            case 0:
               ErrorCode(M_CONTROL_ERROR_0, 3); //Invalid control value.
               break;
            default:
               lpDigitizerInfo->GrabTimeout(lIntValue);
               break;
            }
         }
         break;
      case M_GRAB_MODE:
         {
         MIL_INT lIntValue = CtrlValue;
         switch (lIntValue)
            {
            case M_DEFAULT:
            case M_SYNCHRONOUS:
               lpDigitizerInfo->GrabMode(M_SYNCHRONOUS);
               break;
            case M_ASYNCHRONOUS:
            case M_ASYNCHRONOUS_QUEUED:
               lpDigitizerInfo->GrabMode(lIntValue);
               break;
            default:
               ErrorCode(M_CONTROL_ERROR_0, 3); //Invalid control value.
               break;
            }
         }
         break;
      case M_COMMAND_QUEUE_MODE:
         switch((MIL_INT)CtrlValue)
            {
            case M_QUEUED:
            case M_DEFAULT:
               lpDigitizerInfo->ControlDispatchMode(M_QUEUED);
               break;
            case M_IMMEDIATE:
               lpDigitizerInfo->ControlDispatchMode(M_IMMEDIATE);
               break;
            default:
               ErrorCode(M_CONTROL_ERROR_0, 3); //Invalid control value.
               break;
            }
         break;
      case M_GRAB_HALT_ON_NEXT_FIELD:
         // Do nothing for now.
         break;
      case M_GRAB_COLOR:
         switch((MIL_INT)CtrlValue)
            {
            case M_DEFAULT:
            case M_ENABLE:
               lpDigitizerInfo->ColorKill(M_DISABLE);
               break;
            case M_DISABLE:
               lpDigitizerInfo->ColorKill(M_ENABLE);
               break;
            default:
               ErrorCode(M_CONTROL_ERROR_0, 3); //Invalid control value.
               break;
            }
         break;
      case M_GRAB_TRIGGER_SOFTWARE:
         {
         MIL_INT lIntValue = CtrlValue;
         if (lIntValue == M_ACTIVATE)
            DigControl(DigitizerId, M_GRAB_TRIGGER_STATE, M_ACTIVATE, ThreadContextPtr);
         else
            ErrorCode(M_CONTROL_ERROR_0, 3); //Invalid control value.
         }
         break;
      case M_LUT_ID:
         DigLut(DigitizerId, CtrlValue, ThreadContextPtr);
         break;
      case M_WHITE_BALANCE:
         {
         MIL_INT lIntValue = CtrlValue;
         CDigConfig *lpDigConfig = lpDigitizerInfo->GetDigConfig();
         if((lpDigConfig->Properties.BayerInfo == 0) || (false == lpDigConfig->Properties.BayerEnable()))
            ErrorCode(M_CONTROL_ERROR_0, 1);
         else
            {
            //Must stop grab before continuing
            if(!lpDigitizerInfo->ContinuousGrabInProgress())
               DigGrabWait(DigitizerId, M_GRAB_END, ThreadContextPtr);

            if(lIntValue == M_CALCULATE)
               {
               //Allocate the coefficients buffers if needed
               AllocateWhiteBalanceCoefBuf(DigitizerId, ThreadContextPtr);

               if (ErrorCode() == M_NO_ERROR)
                  InitializeWhiteBalanceCoefBuf(DigitizerId, M_NULL, ThreadContextPtr);
               }
            else if ((lIntValue == M_ENABLE) && (lpDigConfig->Properties.WhiteBalanceBufUserId() == M_NULL))
               {
               //Allocate the coefficients buffers if needed
               AllocateWhiteBalanceCoefBuf(DigitizerId, ThreadContextPtr);

               if (ErrorCode() == M_NO_ERROR)
                  InitializeWhiteBalanceCoefBuf(DigitizerId, M_NULL, ThreadContextPtr);
               }
            else if(lIntValue == M_ENABLE)
               {
               InitializeWhiteBalanceCoefBuf(DigitizerId, lpDigConfig->Properties.WhiteBalanceBufUserId(), ThreadContextPtr);
               lpDigConfig->Properties.WhiteBalanceEnable(true);
               }
            else if(lIntValue == M_DISABLE)
               {
               WB_COEF_IOCTL lIoctl;
               lIoctl.GrabUnitHandle = lpDigConfig->GrabUnitHandle;
               lpDigConfig->Properties.WhiteBalanceEnable(false);
               lIoctl.WhiteBalanceCoeff[0] = lIoctl.WhiteBalanceCoeff[1] = lIoctl.WhiteBalanceCoeff[2] = 0x1000;
               ThreadContextPtr->DrvIoCtl(SystemId().DeviceHandle,
                                          (DWORD)IOCTL_SET_WB_COEF,
                                          &lIoctl,
                                          sizeof(lIoctl),
                                          NULL,
                                          0);
               }
            else
               ErrorCode(M_CONTROL_ERROR_0, 3); //Invalid control value.
            }
         }
         break;
      case M_BAYER_COEFFICIENTS_ID:
         {
         CDigConfig *lpDigConfig = lpDigitizerInfo->GetDigConfig();
         if((lpDigConfig->Properties.BayerInfo == 0) || (false == lpDigConfig->Properties.BayerEnable()))
            ErrorCode(M_CONTROL_ERROR_0, 1);
         else
            {
            MIL_INT32 lIntValue = CtrlValue;
            if((lIntValue == M_DEFAULT) || (lIntValue == M_NULL))
               {
               DigControl(DigitizerId, M_WHITE_BALANCE, M_DISABLE, ThreadContextPtr);
               }
            else
               {
               //Allocate the white balance coefficient buffers if needed
               AllocateWhiteBalanceCoefBuf(DigitizerId, ThreadContextPtr);

               if (ErrorCode() == M_NO_ERROR)
                  InitializeWhiteBalanceCoefBuf(DigitizerId, lIntValue, ThreadContextPtr);
               }
            }
         }
         break;
      case M_LIGHTING_BRIGHT_FIELD:
         {
         if(m_FlashInfo.head[0].IsGTXCamera)
            MAsysControl(M_NULL, M_LIGHTING_BRIGHT_FIELD, CtrlValue);
         else
            ErrorCode(M_CONTROL_ERROR_0, 1); //Control type not supported.
         }
         break;
      case M_FOCUS_PERSISTENCE:
         {
         MIL_INT iValue = CtrlValue;
         CMILString KeyName(FOCUS_PERSISTENCE_REGKEY);
         CMILString ValueName(FOCUS_PERSISTENCE_REGVALUE);
         MIL_INT32 RegValue = 0;
         MRegAccess Key(M_MIL_CURRENT_USER_RUNTIME, KeyName, true);

         if ((iValue == M_DISABLE) || (iValue == M_DEFAULT))
            {
            RegValue = 0;
            Key.SetValue(ValueName, RegValue);
            }
         else if (iValue == M_ENABLE)
            {
            RegValue = 1;
            Key.SetValue(ValueName, RegValue);
            }
         else
            {
            ErrorCode(M_CONTROL_ERROR_0, 3); //Invalid control value.
            }
         }
         break;
      case M_FOCUS_PERSISTENT_VALUE:
         {
         MIL_INT iValue = CtrlValue;
         CMILString KeyName(FOCUS_PERSISTENCE_REGKEY);
         CMILString ValueName(FOCUS_PERSISTENT_VALUE_REGVALUE);
         if ((iValue>=0)&&(iValue<=1023))
            {
            MRegAccess Key(M_MIL_CURRENT_USER_RUNTIME, KeyName, true);
            Key.SetValue(ValueName, iValue);
            }
         else
            {
            ErrorCode(M_CONTROL_ERROR_0, 3); //Invalid control value.
            }
         }
         break;
      default:
         {
         MIL_INT iValue = CtrlValue;
         CDigConfig *lpDigConfig = lpDigitizerInfo->GetDigConfig();

         MULTI_TYPES ModifiedCtrlValue = CtrlValue;

         switch (ControlType)
            {
            case M_BLACK_REF:
               ModifiedCtrlValue = 255 - MIL_DOUBLE(CtrlValue);
               break;
            case M_GAIN_DIGITAL:
               ControlType = M_GAIN_DIGITAL + M_GRAB_INPUT_GAIN;
               if(iValue == M_DEFAULT)
                  ModifiedCtrlValue = lpDigitizerInfo->SetDigitalGain(1.0);
               else if((iValue >= 1) && (iValue <= 8))
                  ModifiedCtrlValue = lpDigitizerInfo->SetDigitalGain(CtrlValue);
               else
                  ErrorCode(M_CONTROL_ERROR_0, 3); //Invalid control value.
               break;
            case M_GAIN:
               ControlType = M_GAIN_DIGITAL + M_GRAB_INPUT_GAIN;
               if(iValue == M_DEFAULT)
                  ModifiedCtrlValue = lpDigitizerInfo->SetGain(0);
               else if((iValue >= 0) && (iValue <= 255))
                  ModifiedCtrlValue = lpDigitizerInfo->SetGain(iValue);
               else
                  ErrorCode(M_CONTROL_ERROR_0, 3); //Invalid control value.
               break;
            case M_GRAB_INPUT_GAIN:
               ControlType = M_GAIN_DIGITAL + M_GRAB_INPUT_GAIN;
               if(iValue == M_DEFAULT)
                  ModifiedCtrlValue = lpDigitizerInfo->SetAnalogGain(M_GAIN0);
               else if((iValue >= M_GAIN0) && (iValue <= M_GAIN5))
                  ModifiedCtrlValue = lpDigitizerInfo->SetAnalogGain(iValue);
               else
                  ErrorCode(M_CONTROL_ERROR_0, 3); //Invalid control value.
               break;
            case M_GRAB_SCALE:
            case M_GRAB_SCALE_X:
            case M_GRAB_SCALE_Y:
               if(iValue == M_DEFAULT)
                  ModifiedCtrlValue = 1.0;
               else
                  {
                  if((MIL_DOUBLE(CtrlValue) == 0.5) || (MIL_DOUBLE(CtrlValue) == 1.0))
                     ModifiedCtrlValue = 1.0 / MIL_DOUBLE(CtrlValue);
                  else
                     ErrorCode(M_CONTROL_ERROR_0, 3); //Invalid control value.
                  }
               break;
            case M_GRAB_TRIGGER_STATE:
               {
               if (iValue != M_ACTIVATE)
                  lpDigitizerInfo->GrabTriggerMode(iValue);
               }
               break;
            case M_GRAB_DIRECTION_X:
               {
               switch (iValue)
                  {
                  case M_FORWARD:
                  case M_DEFAULT:
                     lpDigitizerInfo->GrabDirectionX(M_FORWARD);
                     break;
                  case M_REVERSE:
                     lpDigitizerInfo->GrabDirectionX(M_REVERSE);
                      break;
                  default:
                     ErrorCode(M_CONTROL_ERROR_0, 3); //Invalid control value.
                     break;
                  }
               }
               break;
            case  M_GRAB_DIRECTION_Y:
               {
               switch (iValue)
                  {
                  case M_FORWARD:
                  case M_DEFAULT:
                     lpDigitizerInfo->GrabDirectionY(M_FORWARD);
                     break;
                  case M_REVERSE:
                     lpDigitizerInfo->GrabDirectionY(M_REVERSE);
                     break;
                  default:
                     ErrorCode(M_CONTROL_ERROR_0, 3); //Invalid control value.
                     break;
                  }
               }
               break;
            case M_GRAB_TRIGGER_SOURCE:
               {
               if(iValue != M_SOFTWARE)
                  {
                  if(m_FlashInfo.head[0].IsGTXCamera)
                     MAsysControl(M_NULL, M_IO_SOURCE + M_CC_IO1, CtrlValue);
                  ModifiedCtrlValue = MIL_INT64(M_AUX_IO0);
                  }
               }
               break;
            case M_BAYER_CONVERSION:
               {
               CDigConfig *lpDigConfig = lpDigitizerInfo->GetDigConfig();
               if(lpDigConfig->Properties.BayerInfo == 0)
                  ErrorCode(M_CONTROL_ERROR_0, 1);
               else
                  {
                  switch(iValue)
                     {
                     case M_DISABLE:
                        lpDigConfig->Properties.BayerEnable(false);
                        break;
                     case M_ENABLE:
                        if(lpDigConfig->Properties.BayerInfo != 0x0)
                           lpDigConfig->Properties.BayerEnable(true);
                        else
                           ErrorCode(M_CONTROL_ERROR_4, 1);
                        break;
                     case M_DEFAULT:
                        if(lpDigConfig->Properties.BayerInfo == 0x0)
                           lpDigConfig->Properties.BayerEnable(false);
                        else
                           lpDigConfig->Properties.BayerEnable(true);
                        break;
                     default:
                        ErrorCode(M_CONTROL_ERROR_0, 3); //Invalid control value.
                        break;
                     }
                  }
               }
               break;
            case M_GRAB_LUT_PALETTE:
               {
               CDigConfig *lpDigConfig = lpDigitizerInfo->GetDigConfig();
               if((lpDigConfig->Properties.BayerInfo == 0) && ((m_FlashInfo.head[0].BoardRevision & 0xF) == 0))
                  ErrorCode(M_CONTROL_ERROR_0, 1);
               else
                  lpDigitizerInfo->m_LUTPalette = iValue;
               }
               break;
            }
         // Check if any error pending
         MIL_INT ErrorPending = ErrorCode();
         if (!ErrorPending)
            {
            // Relay the call to the low level library
            DIG_CONTROL lDigControl;

            lDigControl.SystemId = SystemId();
            lDigControl.DigConfig = *lpDigConfig;
            lDigControl.ControlType = ControlType;
            if ((lpDigitizerInfo->ControlDispatchMode() == M_IMMEDIATE) || lDispatchImmediate)
               lDigControl.ControlType |= M_DIG_DISPATCH_IMMEDIATE;

            lDigControl.ControlValue = ModifiedCtrlValue;
            lDigControl.ThreadHandle = ThreadContextPtr->LLThreadHandle();

            LLDigControl(SystemId(), lDigControl, lError, ThreadContextPtr);
            }
         switch(ControlType)
            {
            case M_FOCUS_WAIT:
               {
               ThrWait(0, M_THREAD_WAIT, NULL, ThreadContextPtr);  // Wait for low-level operation to complete
               MIL_INT64 deltapos = abs((MIL_INT64)CtrlValue - lpDigitizerInfo->m_Focus);
               if(m_VariopticGetDelay)
                  {
                  MIL_DOUBLE timeToWait = m_VariopticGetDelay((unsigned int)deltapos, m_FlashInfo.head[0].LensId, m_FlashInfo.head[0].LensVer);
                  MappTimer(M_TIMER_WAIT, &timeToWait);
                  }
               }
               // Intentionally no break to store the control value.
            case M_FOCUS:
               lpDigitizerInfo->m_Focus = CtrlValue;
               break;
            }
         // Check if the call was handled by the low level library
         // Do not call the base driver if driver handled the call
         if (lError.CallNotSupported() && !ErrorPending)
            {
            // Relay it to the base class if it cant be handled
            MIL_INT Done = MDGeniCamDeviceSystem::DigControl(DigitizerId, ControlType, CtrlValue, ThreadContextPtr);

            // Reset error code if handled by the base class
            if (Done)
               ErrorCode(M_NO_ERROR);
            }
         }
         break;
      }

   if (!(lError.ErrorLogged()) && (lRestartContinuousGrab == true))
      {
      //Update continuous grab manager to apply the control
      MDHwSpecSystem::DigGrab(DigitizerId, lGrabBuffer, M_FOREVER, ThreadContextPtr);
      }
   else if (lError.ErrorLogged())
      ErrorCode(lError.SystemErrorNumber(), lError.SystemSubMessage1());

   if (lbLock)
      lpDigitizerInfo->Unlock();

end:;

   return(M_VALID);
   }

/****************************************************************************************************
*
*     Name:         MDHwSpecSystem::AllocateWhiteBalanceCoefBuf
*
*     Parameters:   MD_ID  DigitizerId:
*                   MDDriverThreadContext *ThreadContextPtr:
*
****************************************************************************************************/
void MDHwSpecSystem::AllocateWhiteBalanceCoefBuf(MD_ID DigitizerId, MDDriverThreadContext *ThreadContextPtr)
{
   UNREFERENCED_PARAMETER(ThreadContextPtr);
   MDDigitizerInfo *lpDigitizerInfo = Digitizers[DigitizerId];
   CDigConfig *lpDigConfig = lpDigitizerInfo->GetDigConfig();

   if (lpDigConfig->Properties.WhiteBalanceBufUserId() == M_NULL)
   {
      MIL_ID lWBDriverBuffer = M_NULL;
      MbufAllocColor(MilId(), 1, 3, 1, 32 + M_FLOAT, M_ARRAY, &lWBDriverBuffer);

      lpDigConfig->Properties.WhiteBalanceBufUserId(lWBDriverBuffer);
      lpDigConfig->Properties.WhiteBalanceEnable(true);

      if ((lpDigConfig->Properties.WhiteBalanceBufUserId() == M_NULL))
      {
         ErrorCode(M_MEMORY_ERROR_0, 2); //Not enough memory to allocate buffer.
      }
   }
   else if (!(lpDigConfig->Properties.WhiteBalanceEnable()))
      lpDigConfig->Properties.WhiteBalanceEnable(true);
}

/****************************************************************************************************
*
*     Name:         MDHwSpecSystem::InitializeWhiteBalanceCoefBuf
*
*     Parameters:   MD_ID  DigitizerId:
*                   MIL_ID CoefBufId:
*                   MDDriverThreadContext *ThreadContextPtr:
*
****************************************************************************************************/
void MDHwSpecSystem::InitializeWhiteBalanceCoefBuf(MD_ID  DigitizerId, MIL_ID CoefBufId, MDDriverThreadContext *ThreadContextPtr)
   {
   MDDigitizerInfo *lpDigitizerInfo = Digitizers[DigitizerId];
   CDigConfig *lpDigConfig = lpDigitizerInfo->GetDigConfig();
   MIL_ID  lBayerCoefId = lpDigConfig->Properties.WhiteBalanceBufUserId();
   MIL_INT lBayerFilterType;
   float   UserWhiteBalanceCoeff[3] = {0};
   WB_COEF_IOCTL ioctl;
   int i;

   //Determine the type of filter we need
   if(lpDigitizerInfo->BayerInfo() == 0x1)
      {
      //lBayerFilterType = M_BAYER_GB;
      if(lpDigitizerInfo->GrabDirectionX() == M_FORWARD)
         {
         if(lpDigitizerInfo->GrabDirectionY() == M_FORWARD)
            lBayerFilterType = M_BAYER_GB;
         else // X FOWARD && Y REVERSE
            lBayerFilterType = M_BAYER_RG;
         }
      else // X REVERSE
         {
         if(lpDigitizerInfo->GrabDirectionY() == M_FORWARD)
            lBayerFilterType = M_BAYER_BG;
         else // X REVERSE && Y REVERSE
            lBayerFilterType = M_BAYER_GR;
         }
      }
   else if(lpDigitizerInfo->BayerInfo() == 0x2)
      {
      //lBayerFilterType = M_BAYER_BG;
      if(lpDigitizerInfo->GrabDirectionX() == M_FORWARD)
         {
         if(lpDigitizerInfo->GrabDirectionY() == M_FORWARD)
            lBayerFilterType = M_BAYER_BG;
         else // X FOWARD && Y REVERSE
            lBayerFilterType = M_BAYER_GR;
         }
      else // X REVERSE
         {
         if(lpDigitizerInfo->GrabDirectionY() == M_FORWARD)
            lBayerFilterType = M_BAYER_GB;
         else // X REVERSE && Y REVERSE
            lBayerFilterType = M_BAYER_RG;
         }
      }
   else if(lpDigitizerInfo->BayerInfo() == 0x3)
      {
      //lBayerFilterType = M_BAYER_RG;
      if(lpDigitizerInfo->GrabDirectionX() == M_FORWARD)
         {
         if(lpDigitizerInfo->GrabDirectionY() == M_FORWARD)
            lBayerFilterType = M_BAYER_RG;
         else // X FOWARD && Y REVERSE
            lBayerFilterType = M_BAYER_GB;
         }
      else // X REVERSE
         {
         if(lpDigitizerInfo->GrabDirectionY() == M_FORWARD)
            lBayerFilterType = M_BAYER_GR;
         else // X REVERSE && Y REVERSE
            lBayerFilterType = M_BAYER_BG;
         }
      }
   else if(lpDigitizerInfo->BayerInfo() == 0x4)
      {
      //lBayerFilterType = M_BAYER_GR;
      if(lpDigitizerInfo->GrabDirectionX() == M_FORWARD)
         {
         if(lpDigitizerInfo->GrabDirectionY() == M_FORWARD)
            lBayerFilterType = M_BAYER_GR;
         else // X FOWARD && Y REVERSE
            lBayerFilterType = M_BAYER_BG;
         }
      else // X REVERSE
         {
         if(lpDigitizerInfo->GrabDirectionY() == M_FORWARD)
            lBayerFilterType = M_BAYER_RG;
         else // X REVERSE && Y REVERSE
            lBayerFilterType = M_BAYER_GB;
         }
      }
   else
      {
      ErrorCode(M_IRISGTX_GRAB_ERROR_0, 1); //Invalid bayer filter specified.
      goto end;
      }

   if(CoefBufId == M_NULL)
      {
      MIL_INT lOrgGrabMode;
      bool lIsChangGrabMode = false;
      MD_ID lGrabBuffer;
      MD_ID lProcBuffer;
      MIL_INT lTriggerMode;
      MIL_INT lTriggerSource;

      DigInquire(DigitizerId, M_GRAB_MODE, &lOrgGrabMode, ThreadContextPtr);
      if (lOrgGrabMode != M_ASYNCHRONOUS)
         {
         lIsChangGrabMode = true;
         DigControl(DigitizerId, M_GRAB_MODE, M_ASYNCHRONOUS, ThreadContextPtr);
         }

      //We do not have any coefficients to use,
      //we must grab a frame and compute the white balance coefficients
      BufCreateColor(1,
                     lpDigConfig->Properties.SizeX,
                     lpDigConfig->Properties.SizeY,
                     lpDigConfig->Properties.SizeBit == 8 ? 8 + M_UNSIGNED : 16 + M_UNSIGNED,
                     M_IMAGE + M_GRAB + M_PROC + M_NON_PAGED + (lpDigConfig->Properties.SizeBit == 8 ? M_MONO8 : M_MONO16),
                     0,
                     0,
                     NULL,
                     &lGrabBuffer,
                     ThreadContextPtr);
      BufCreateColor(3,
                     lpDigConfig->Properties.SizeX,
                     lpDigConfig->Properties.SizeY,
                     lpDigConfig->Properties.SizeBit == 8 ? 8 + M_UNSIGNED : 16 + M_UNSIGNED,
                     M_IMAGE + M_GRAB + M_PROC + M_PLANAR + (lpDigConfig->Properties.SizeBit == 8 ? M_RGB24 : M_RGB48),
                     0,
                     0,
                     NULL,
                     &lProcBuffer,
                     ThreadContextPtr);

      if(lGrabBuffer == M_NULL || lProcBuffer == M_NULL)
         {
         ErrorCode(M_MEMORY_ERROR_0, 2); //Not enough memory to allocate buffer.

         if(lGrabBuffer)
            BufFree(lGrabBuffer, ThreadContextPtr);

         if(lProcBuffer)
            BufFree(lProcBuffer, ThreadContextPtr);

         if (lIsChangGrabMode)
            DigControl(DigitizerId, M_GRAB_MODE, lOrgGrabMode, ThreadContextPtr);

         goto end;
         }

      //Grab the raw bayer data
      MIL_INT lIsBayerActif;
      DigInquire(DigitizerId, M_BAYER_CONVERSION, &lIsBayerActif, ThreadContextPtr);
      DigControl(DigitizerId, M_BAYER_CONVERSION, M_DISABLE, ThreadContextPtr);

      //If in trigger mode, set software trigger for source
      DigInquire(DigitizerId, M_GRAB_TRIGGER_STATE, &lTriggerMode, ThreadContextPtr);
      DigInquire(DigitizerId, M_GRAB_TRIGGER_SOURCE, &lTriggerSource, ThreadContextPtr);

      if ((lTriggerMode == M_ENABLE)&&(lTriggerSource != M_SOFTWARE))
         {
         DigControl(DigitizerId, M_GRAB_TRIGGER_SOURCE, M_SOFTWARE, ThreadContextPtr);
         }

      DigGrab(DigitizerId, lGrabBuffer, 1, ThreadContextPtr);

      //If in trigger mode, send a software trigger
      if (lTriggerMode == M_ENABLE)
         {
         DigControl(DigitizerId, M_GRAB_TRIGGER_STATE, M_ACTIVATE, ThreadContextPtr);
         }

      DigGrabWait(DigitizerId, M_GRAB_END, ThreadContextPtr);
      DigControl(DigitizerId, M_BAYER_CONVERSION, lIsBayerActif, ThreadContextPtr);

      // Put back original trigger source
      if ((lTriggerMode == M_ENABLE)&&(lTriggerSource != M_SOFTWARE))
         {
         DigControl(DigitizerId, M_GRAB_TRIGGER_SOURCE, lTriggerSource, ThreadContextPtr);
         }

      //Calculate bayer coefficients once, and duplicate it for mono buffers
      //and once for RGB buffers
      MbufBayer(Buffers[lGrabBuffer]->HostId(),
                  Buffers[lProcBuffer]->HostId(),
                  lBayerCoefId,
                  lBayerFilterType + M_WHITE_BALANCE_CALCULATE);

      //Free the buffers used for calculating the white balance coefficients.
      BufFree(lGrabBuffer, ThreadContextPtr);
      BufFree(lProcBuffer, ThreadContextPtr);

      if (lIsChangGrabMode)
         DigControl(DigitizerId, M_GRAB_MODE, lOrgGrabMode, ThreadContextPtr);
      }
   else
      {
      MbufCopy(CoefBufId, lBayerCoefId);
      }

   //Retrieve the data the user is giving us.
   MbufGet1d(lBayerCoefId, 0, 3, &UserWhiteBalanceCoeff);

   //Convert the coefficients in a format usable by DMA.
   //Case for bayer to RGB (8 or 16 bits)
   ioctl.GrabUnitHandle = lpDigConfig->GrabUnitHandle;
   for(i = 0; i < 3; i++)
      ioctl.WhiteBalanceCoeff[i] = ((MIL_UINT16)(UserWhiteBalanceCoeff[i] * (float)(1 << 12)));

   ThreadContextPtr->DrvIoCtl(SystemId().DeviceHandle,
                              (DWORD)IOCTL_SET_WB_COEF,
                              &ioctl,
                              sizeof(ioctl),
                              NULL,
                              0);
end:

   return;
   }

   //==============================================================================
//
//   Name:       DigGrabWait()
//
//   Synopsis:   Wait for the end of the grab in progress on the specified
//               digitizer. The digitizer must be in asynchronous mode.
//
//   Parameters: MD_ID DigitizerID : Digitizer to use.
//               MIL_INT Flag      : Grab stop mode.
//               ThreadContextPtr  : Thread context object pointer.
//
//==============================================================================
MIL_INT MDHwSpecSystem::DigGrabWait(MD_ID DigitizerId, MIL_INT64 Flag, MDDriverThreadContext *ThreadContextPtr)
   {
   MDDigitizerInfo       *lpDigInfo        = Digitizers[DigitizerId];
   CDigConfig            *lpDigConfig      = lpDigInfo->GetDigConfig();
   DIG_GRAB_WAIT          lData;

   lData.DigConfig      = *lpDigConfig;
   lData.ThreadHandle   = ThreadContextPtr->LLThreadHandle();
   lData.SystemId       = SystemId();
   lData.WaitFlag       = Flag;

   if(Flag != M_GRAB_END && Flag != M_GRAB_FRAME_END)
      {
      ErrorCode(M_DIGITIZER_ERROR_3, 1);  //Invalid wait flag specified.
      goto End;
      }

   if(CLog::GetInstance()->IsLogEnable(eLogTypeDigCmds) && Flag == M_GRAB_END)
      CLog::GetInstance()->Log(this, eDIGGRABWAIT_GRAB_END);
   else if(CLog::GetInstance()->IsLogEnable(eLogTypeDigCmds) && Flag == M_GRAB_FRAME_END)
      CLog::GetInstance()->Log(this, eDIGGRABWAIT_GRAB_FRAME_END);

   LLDigGrabWait(SystemId(), lData, ThreadContextPtr);

   if (ErrorCode())
      {
      if (ErrorCode() == M_GRAB_ERROR_0 && ThreadContextPtr->ErrorSubNb() == 1)  //Synchronization lost (Time out).
         {
         //We have a sync loss, abort grab
         SysControl(M_THREAD_COMMANDS_ABORT, M_THREAD_CURRENT, ThreadContextPtr);
         DigControl(DigitizerId, M_GRAB_ABORT, M_DEFAULT, ThreadContextPtr);
         }
      }

   if(CLog::GetInstance()->IsLogEnable(eLogTypeDigCmds))
      CLog::GetInstance()->Log(this, eDIGGRABWAIT_END);

End:
   return(M_VALID);
   }

//==============================================================================
//
//   Name:       MIL_INT DigInquire()
//
//   Synopsis:   Inquire the digitizer settings.
//
//   Parameters: MD_ID Digitizer ID      : ID of the digitizer
//               MIL_INT64 ParamToInquire: Parameter to inquire
//               void *Ptr               : Pointer to the returned value
//               ThreadContextPtr        : Thread context object pointer.
//
//==============================================================================
MIL_INT MDHwSpecSystem::DigInquire(MD_ID DigitizerId, MIL_INT64 ParamToInquire, void *Ptr, MDDriverThreadContext *ThreadContextPtr)
   {
   MIL_INT                lRetval         = M_VALID;
   MDHwSpecDigitizerInfo     *lpDigitizerInfo = (MDHwSpecDigitizerInfo*)Digitizers[DigitizerId];
   CDigConfig                *lpDigConfig = lpDigitizerInfo->GetDigConfig();
   CError                 lError;

   if(M_DIG_CAM_BRD_BITS_SET(ParamToInquire))
      {
      ErrorCode(M_DIGITIZER_ERROR_7, 1);  //M_BOARD and M_CAMERA cannot be used together.
      goto end;
      }
   else if(M_DIG_CAM_BIT_SET(ParamToInquire))
      {
      ErrorCode(M_DIGITIZER_ERROR_7, 2);  //M_CAMERA is not supported on this system.
      goto end;
      }

   ParamToInquire = M_DIG_STRIP_BRD_BIT(ParamToInquire);

   if(
      (ParamToInquire == M_TIMER_DURATION          )  ||
      (ParamToInquire == M_TIMER_DELAY    )  ||
      (ParamToInquire == M_TIMER_OUTPUT_INVERTER          )  ||
      (ParamToInquire == M_TIMER_STATE               )  ||
      (ParamToInquire == M_TIMER_TRIGGER_ACTIVATION  )  ||
      (ParamToInquire == M_TIMER_TRIGGER_SOURCE        )  ||
      (ParamToInquire == M_TIMER_CLOCK_SOURCE  )  ||
      (ParamToInquire == M_TIMER_TRIGGER_MISSED)  ||
      (ParamToInquire == M_TIMER_DURATION+M_TIMER1          )  ||
      (ParamToInquire == M_TIMER_DELAY+M_TIMER1    )  ||
      (ParamToInquire == M_TIMER_OUTPUT_INVERTER+M_TIMER1          )  ||
      (ParamToInquire == M_TIMER_STATE+M_TIMER1               )  ||
      (ParamToInquire == M_TIMER_TRIGGER_ACTIVATION+M_TIMER1  )  ||
      (ParamToInquire == M_TIMER_TRIGGER_SOURCE+M_TIMER1        )  ||
      (ParamToInquire == M_TIMER_CLOCK_SOURCE+M_TIMER1  )  ||
      (ParamToInquire == M_TIMER_TRIGGER_MISSED+M_TIMER1)  ||
      (ParamToInquire == M_TIMER_DURATION+M_TIMER2          )  ||
      (ParamToInquire == M_TIMER_DELAY+M_TIMER2    )  ||
      (ParamToInquire == M_TIMER_OUTPUT_INVERTER+M_TIMER2          )  ||
      (ParamToInquire == M_TIMER_STATE+M_TIMER2               )  ||
      (ParamToInquire == M_TIMER_TRIGGER_ACTIVATION+M_TIMER2  )  ||
      (ParamToInquire == M_TIMER_TRIGGER_SOURCE+M_TIMER2        )  ||
      (ParamToInquire == M_TIMER_CLOCK_SOURCE+M_TIMER2  )  ||
      (ParamToInquire == M_TIMER_TRIGGER_MISSED+M_TIMER2)  ||
      (ParamToInquire == M_TIMER_DURATION+M_TIMER3          )  ||
      (ParamToInquire == M_TIMER_DELAY+M_TIMER3    )  ||
      (ParamToInquire == M_TIMER_OUTPUT_INVERTER+M_TIMER3          )  ||
      (ParamToInquire == M_TIMER_STATE+M_TIMER3               )  ||
      (ParamToInquire == M_TIMER_TRIGGER_ACTIVATION+M_TIMER3  )  ||
      (ParamToInquire == M_TIMER_TRIGGER_SOURCE+M_TIMER3        )  ||
      (ParamToInquire == M_TIMER_CLOCK_SOURCE+M_TIMER3  )  ||
      (ParamToInquire == M_TIMER_TRIGGER_MISSED+M_TIMER3)  ||
      (ParamToInquire == M_TIMER_DURATION+M_TIMER4          )  ||
      (ParamToInquire == M_TIMER_DELAY+M_TIMER4    )  ||
      (ParamToInquire == M_TIMER_OUTPUT_INVERTER+M_TIMER4          )  ||
      (ParamToInquire == M_TIMER_STATE+M_TIMER4               )  ||
      (ParamToInquire == M_TIMER_TRIGGER_ACTIVATION+M_TIMER4  )  ||
      (ParamToInquire == M_TIMER_TRIGGER_SOURCE+M_TIMER4        )  ||
      (ParamToInquire == M_TIMER_CLOCK_SOURCE+M_TIMER4  )  ||
      (ParamToInquire == M_TIMER_TRIGGER_MISSED+M_TIMER4)  ||
      (ParamToInquire == M_GRAB_LINE_COUNTER                    )  ||
      (ParamToInquire == M_HUE_REF) ||
      (ParamToInquire == M_SATURATION_REF) ||
      (ParamToInquire == M_COUPLING_MODE))
      {
      ErrorCode(M_INQUIRE_ERROR_0, 1); //Inquire type not supported.
      }
   else
      {
      switch(ParamToInquire)
         {
         case M_SERIAL_NUMBER:
            {
            auto DevNb = lpDigConfig->Properties.DevNb;
            char TempSerial[10];
            memset(TempSerial, 0, sizeof(TempSerial));
            memcpy(TempSerial, m_FlashInfo.head[DevNb].NpiHeadData.SerialNumSensorBoard, sizeof(m_FlashInfo.head[DevNb].NpiHeadData.SerialNumSensorBoard));
            CMILString SerialNumberString;
            SerialNumberString.InitFromASCII(TempSerial);
            MOs_strcpy_s(((MIL_TEXT_CHAR*)Ptr), SerialNumberString.Length()+1, (LPCMILSTR)SerialNumberString);
            }
            break;
         case M_SERIAL_NUMBER + M_STRING_SIZE:
            {
            *(MIL_INT *)Ptr = sizeof(m_FlashInfo.head[0].NpiHeadData.SerialNumSensorBoard) + 1;
            }
            break;
         case M_DIGITIZER_TYPE + M_DEV0:
            *(MIL_INT *)Ptr = m_FlashInfo.head[0].HeadType;
            break;
         case M_CLIP_SRC_SUPPORTED:
            *(MIL_INT *)Ptr = M_YES;
            break;
         case M_CLIP_DST_SUPPORTED:
            *(MIL_INT *)Ptr = M_YES;
            break;
         case M_GRAB_8_BITS_SUPPORTED:
            *(MIL_INT *)Ptr = M_YES;
            break;
         case M_GRAB_15_BITS_SUPPORTED:
            *(MIL_INT *)Ptr = M_NO;
            break;
         case M_GRAB_16_BITS_SUPPORTED:
            *(MIL_INT *)Ptr = M_YES;
            break;
         case M_GRAB_24_BITS_SUPPORTED:
            *(MIL_INT *)Ptr = M_NO;
            break;
         case M_GRAB_32_BITS_SUPPORTED:
            *(MIL_INT *)Ptr = M_YES;
            break;
         case M_HOOK_FUNCTION_SUPPORTED:
            *(MIL_INT *)Ptr = M_YES;
            break;
         case M_GRAB_SCALE_X_SUPPORTED:
         case M_GRAB_SCALE_Y_SUPPORTED:
            if((*(double *)Ptr == 1.0)      || (*(double *)Ptr == 1.0/2.0)  )
               *(double *)Ptr = (double) M_YES;
            else
               *(double *)Ptr = (double) M_NO;
            break;
         case M_FORMAT:
            MOs_strcpy_s((MIL_TEXT_PTR)Ptr, MOs_strlen(lpDigitizerInfo->Format())+1, lpDigitizerInfo->Format());
            break;
         case M_FORMAT + M_STRING_SIZE:
            *(MIL_INT *)Ptr = MOs_strlen(lpDigitizerInfo->Format())+1;
            break;
         case M_NUMBER:
            *(MIL_INT *)Ptr = lpDigitizerInfo->Number();
            break;
         case M_INIT_FLAG:
            *(MIL_INT *)Ptr = M_MI64TOMI(lpDigitizerInfo->InitFlag());

            if(!M_MIL_INT64_CASTABLE_TO_MIL_INT(lpDigitizerInfo->InitFlag()))
               {
               ErrorCode(M_INQUIRE_ERROR_1, 1);
               }
            break;
         case M_EXTENDED_INIT_FLAG:
            *(MIL_INT64 *)Ptr = lpDigitizerInfo->InitFlag();
            break;
         case M_SIZE_X:
            *(MIL_INT *)Ptr = lpDigitizerInfo->SizeX();
            break;
         case M_SIZE_Y:
            *(MIL_INT *)Ptr = lpDigitizerInfo->SizeY();
            break;
         case M_SIZE_X + M_MIN_VALUE:
            *(MIL_INT *)Ptr = 32;
            break;
         case M_SIZE_Y + M_MIN_VALUE:
            *(MIL_INT *)Ptr = 2;
            break;
         case M_SIZE_X + M_MAX_VALUE:
            *(MIL_INT *)Ptr = lpDigitizerInfo->SizeX();
            break;
         case M_SIZE_Y + M_MAX_VALUE:
            *(MIL_INT *)Ptr = lpDigitizerInfo->SizeY();
            break;
         case M_SIZE_BIT:
            *(MIL_INT *)Ptr = lpDigitizerInfo->SizeBit();
            break;
         case M_TYPE:
            switch(lpDigitizerInfo->SizeBit())
               {
               case 8:     *(MIL_INT *)Ptr = 8 | M_UNSIGNED;break;
               case 10:
               case 12:
               case 14:
               case 16:    *(MIL_INT *)Ptr = 16 | M_UNSIGNED; break;
               case 32:    *(MIL_INT *)Ptr = 32 | M_UNSIGNED; break;
               default:    *(MIL_INT *)Ptr = 0;
               }
            break;
         case M_SIZE_BAND:
            if((lpDigConfig->Properties.BayerInfo != 0) && (lpDigConfig->Properties.BayerEnable() == true))
               *(MIL_INT *)Ptr = 3;
            else
               *(MIL_INT *)Ptr = lpDigitizerInfo->SizeBand();
            break;
         case M_SOURCE_DATA_FORMAT:
            if(lpDigConfig->Properties.BayerInfo != 0)
               *(MIL_INT *)Ptr = M_PLANAR + M_RGB24;
            else
               *(MIL_INT *)Ptr = M_PLANAR + M_MONO8;
            break;
         case M_SIZE_BAND_LUT:
            if((lpDigConfig->Properties.BayerInfo != 0) && (lpDigConfig->Properties.BayerEnable() == true))
               *(MIL_INT *)Ptr = 3;
            else
               *(MIL_INT *)Ptr = lpDigitizerInfo->SizeBandLut();
            break;
         case M_GRAB_MODE:
            *(MIL_INT *)Ptr = lpDigitizerInfo->GrabMode();
            break;
         case M_GRAB_FRAME_NUM:
            *(MIL_INT *)Ptr = lpDigitizerInfo->GrabFrameNum();
            break;
         case M_GRAB_DIRECTION_X:
            *(MIL_INT *)Ptr = lpDigitizerInfo->GrabDirectionX();
            break;
         case M_GRAB_DIRECTION_Y:
            *(MIL_INT *)Ptr = lpDigitizerInfo->GrabDirectionY();
            break;
         case M_GRAB_TIMEOUT:
            if(lpDigitizerInfo->GrabTimeout() != M_DEFAULT)
               *(MIL_INT *)Ptr = lpDigitizerInfo->GrabTimeout();
            else
               {
               if(lpDigitizerInfo->GrabTriggerMode() == M_ENABLE)
                  *(MIL_INT *)Ptr = M_INFINITE;
               else
                  *(MIL_INT *)Ptr = (((5*lpDigitizerInfo->GrabPeriod()) < 5000) ? 5000 : (5*lpDigitizerInfo->GrabPeriod()));
               }
             break;
         case M_COMMAND_QUEUE_MODE:
            *(MIL_INT *)Ptr = lpDigitizerInfo->ControlDispatchMode();
            break;
         case M_CHANNEL_NUM:
            *(MIL_INT *)Ptr = 1;
            break;
         case M_GRAB_HALT_ON_NEXT_FIELD: // Not supported for now:
            *(MIL_INT *)Ptr = M_DISABLE;
            break;
         case M_COLOR_MODE:
            *(MIL_INT *)Ptr = lpDigitizerInfo->ColorMode();
            break;
         case M_GRAB_COLOR:
            if(lpDigitizerInfo->ColorKill() == M_DISABLE)
               *(MIL_INT *)Ptr = M_ENABLE;
            else
            if(lpDigitizerInfo->ColorKill() == M_ENABLE)
               *(MIL_INT *)Ptr = M_DISABLE;
            break;
         case M_DIG_OK_TO_BE_FREED:
            *(MIL_INT *)Ptr = M_YES;
            break;
         case M_CAMERA_PRESENT:
            *(MIL_INT *)Ptr = M_YES;
            break;
         case M_WHITE_BALANCE:
            {
            if((lpDigConfig->Properties.BayerInfo) && lpDigConfig->Properties.BayerEnable())
               *(MIL_INT *)Ptr = (lpDigConfig->Properties.WhiteBalanceEnable()) ? M_ENABLE : M_DISABLE;
            else
               *(MIL_INT *)Ptr = M_DISABLE;
            }
            break;
         case M_BAYER_COEFFICIENTS_ID:
            {
            if((lpDigConfig->Properties.BayerInfo) && lpDigConfig->Properties.BayerEnable())
               *(MIL_INT *)Ptr = (lpDigConfig->Properties.WhiteBalanceBufUserId() ? lpDigConfig->Properties.WhiteBalanceBufUserId() : M_NULL);
            else
               *(MIL_INT *)Ptr = M_NULL;
            }
            break;
         case M_BAYER_CONVERSION:
            {
            if(lpDigConfig->Properties.BayerInfo)
               *(MIL_INT *)Ptr = lpDigConfig->Properties.BayerEnable() ? M_ENABLE : M_DISABLE;
            else
               ErrorCode(M_CONTROL_ERROR_0, 1);
            }
            break;
         case M_BAYER_PATTERN:
            {
            switch(lpDigConfig->Properties.BayerInfo)
               {
               case 0x1:
                  *(MIL_INT *)Ptr = M_BAYER_GB;
                  break;
               case 0x2:
                  *(MIL_INT *)Ptr = M_BAYER_BG;
                  break;
               case 0x3:
                  *(MIL_INT *)Ptr = M_BAYER_RG;
                  break;
               case 0x4:
                  *(MIL_INT *)Ptr = M_BAYER_GR;
                  break;
               default:
                  *(MIL_INT *)Ptr = M_NULL;
                  break;
               }
            }
            break;
         case M_GAIN_DIGITAL:
            *(MIL_DOUBLE *)Ptr = lpDigitizerInfo->GetDigitalGain();
            break;
         case M_GAIN:
            *(MIL_INT *)Ptr = lpDigitizerInfo->GetGain();
            break;
         case M_GRAB_INPUT_GAIN:
            *(MIL_INT *)Ptr = lpDigitizerInfo->GetAnalogGain();
            break;
         case M_LIGHTING_BRIGHT_FIELD:
            if (m_FlashInfo.head[0].IsGTXCamera)
               MAsysInquire(M_NULL, M_LIGHTING_BRIGHT_FIELD, Ptr);
            else
               ErrorCode(M_INQUIRE_ERROR_0, 1); //Inquire type not supported.
            break;
         case M_GRAB_PERIOD:
            {
            auto DevNb = lpDigConfig->Properties.DevNb;
            switch(m_FlashInfo.head[DevNb].HeadType)
               {
               case M_300C:
                  *(MIL_INT*)Ptr = (MIL_INT)(1000 * 1 / 147);
                  break;
               case M_300:
               case M_300NIR:
                  *(MIL_INT*)Ptr = (MIL_INT)(1000 * 1 / 293);
                  break;
               case M_1300C:
                  *(MIL_INT*)Ptr = (MIL_INT)(1000 * 1 / 42.5);
                  break;
               case M_1300:
               case M_1300NIR:
                  *(MIL_INT*)Ptr = (MIL_INT)(1000 * 1 / 85);
                  break;
               case M_2000C:
                  *(MIL_INT*)Ptr = (MIL_INT)(1000 * 1 / 22.5);
                  break;
               case M_2000:
               case M_2000NIR:
                  *(MIL_INT*)Ptr = (MIL_INT)(1000 * 1 / 45.9);
                  break;
               case M_5000C:
                  *(MIL_INT*)Ptr = (MIL_INT)(1000 * 1 / 10.5);
                  break;
               case M_5000:
               case M_5000NIR:
                  *(MIL_INT*)Ptr = (MIL_INT)(1000 * 1 / 21.4);
                  break;
               }
            }
            break;
         case M_FOCUS_PERSISTENCE:
            {
            CMILString KeyName(FOCUS_PERSISTENCE_REGKEY);
            CMILString ValueName(FOCUS_PERSISTENCE_REGVALUE);
            MIL_INT32 RegValue = 0;
            MIL_INT Persistence = M_DISABLE;
            MRegAccess Key(M_MIL_CURRENT_USER_RUNTIME, KeyName, false);

            if (Key.ValueExists(ValueName))
               {
               if (Key.GetValue(ValueName, RegValue))
                  Persistence = RegValue ? M_ENABLE : M_DISABLE;
               }
            *(MIL_INT*)Ptr = Persistence;
            }
            break;
         case M_FOCUS_PERSISTENT_VALUE:
            {
            CMILString KeyName(FOCUS_PERSISTENCE_REGKEY);
            CMILString ValueName(FOCUS_PERSISTENT_VALUE_REGVALUE);
            MIL_INT32 RegValue = 0;
            MIL_INT PersistentValue = M_INVALID;
            MRegAccess Key(M_MIL_CURRENT_USER_RUNTIME, KeyName, false);

            if (Key.ValueExists(ValueName))
               {
               if (Key.GetValue(ValueName, RegValue))
                  PersistentValue = RegValue;
               }
            *(MIL_INT*)Ptr = PersistentValue;
            }
            break;
         default:
            {
            DIG_INQUIRE lDigInquire;

            lDigInquire.SystemId = SystemId();
            lDigInquire.DigConfig = *lpDigConfig;
            lDigInquire.InquireType = ParamToInquire;
            lDigInquire.ThreadHandle  = ThreadContextPtr->LLThreadHandle();

            if ((ParamToInquire == M_SELECTED_FRAME_RATE_FOR_BUFFER)||
                (ParamToInquire == M_EXPOSURE_TIME_MAX_FOR_BUFFER))
                {
                // We receive from MIL the MD_ID of the buffer
                MD_ID BufId = (MIL_ID)(*(MIL_DOUBLE *)Ptr);
                // Get the BufInfo pointer.  In MIL10.20, we should do instead:
                // MDHwSpecBufferInfo *lpBufInfo = (MDHwSpecBufferInfo *) GetBufferInfo(BufId);
                MDHwSpecBufferInfo *lpBufInfo = Buffers[BufId];
                MIL_INT BufferPropertiesPtrInt = (MIL_INT)&(lpBufInfo->GetBufferProperties());
                lDigInquire.InquiredValue = (MIL_INT64)BufferPropertiesPtrInt;
                }

            // Check if any error pending
            MIL_INT ErrorPending = ErrorCode();

            // Relay the call to the low level library
            LLDigInquire(SystemId(), lDigInquire, lError, ThreadContextPtr);

            // Check if the call was handled by the low level library
            // Do not call the base driver if driver handled the call
            if(lError.CallNotSupported() && !ErrorPending)
               {
               // Relay it to the base class if it cant be handled
               lRetval = MDGeniCamDeviceSystem::DigInquire(DigitizerId, ParamToInquire, Ptr, ThreadContextPtr);

               // Reset error code if handled by the base class
               if (lRetval == M_VALID)
                  ErrorCode(M_NO_ERROR);
               }
            else if(!lError.ErrorLogged() && !ErrorPending)
               {
               switch(ParamToInquire)
                  {
                  case M_BLACK_REF:
                     *(MIL_DOUBLE *)Ptr = 255 - (MIL_DOUBLE)lDigInquire.InquiredValue;
                     break;
                  case M_GRAB_SCALE_X:
                  case M_GRAB_SCALE_Y:
                     *(MIL_DOUBLE *)Ptr = 1.0 / (MIL_DOUBLE)lDigInquire.InquiredValue;
                     break;
                  case M_SELECTED_FRAME_RATE:
                  case M_SELECTED_FRAME_RATE_FOR_BUFFER:
                        *(MIL_DOUBLE *)Ptr = (MIL_DOUBLE)(1.0 / (lDigInquire.InquiredValue * 1e-15));
                     break;
                  case M_GRAB_TRIGGER_SOURCE:
                     if(lDigInquire.InquiredValue == M_AUX_IO0)
                        {
                        lDigInquire.InquiredValue = 0;
                        if(m_FlashInfo.head[0].IsGTXCamera)
                           MAsysInquire(M_NULL, M_IO_SOURCE + M_CC_IO1, &lDigInquire.InquiredValue);
                        }
                     *((MIL_INT *)Ptr) = (MIL_INT)lDigInquire.InquiredValue;
                     break;
                  case M_FOCUS_TEMPERATURE:
                     if (lDigInquire.InquiredValue == MIL_UINT32_MAX)
                        *((MIL_DOUBLE *)Ptr) = M_UNKNOWN;
                     else
                        {
                        // Convert to degrees Celcius with formula from Varioptics
                        MIL_DOUBLE AdcValue = (MIL_DOUBLE)lDigInquire.InquiredValue;
                        MIL_DOUBLE LogTerm = 0;
                        MIL_DOUBLE DenomTerm = 0;
                        if (AdcValue == 0) AdcValue = 1;  //This should not happen, but just in case
                        if (AdcValue == 255) AdcValue = 254; //This should not happen, but just in case
                        LogTerm = (82 * (1 - (AdcValue / 255))) / (100 * (AdcValue/255));
                        DenomTerm = log(LogTerm)/4330 + 0.003354016;
                        *((MIL_DOUBLE *)Ptr) = (1 / DenomTerm) - 273.15;
                        }
                     break;
                  default:
                     if(M_IN_DIG_INQUIRE_DOUBLE_RANGE(ParamToInquire))
                        {
                        *((MIL_DOUBLE *)Ptr) = (MIL_DOUBLE)lDigInquire.InquiredValue;
                        }
                     else if(M_IN_DIG_INQUIRE_MIL_INT64_RANGE(ParamToInquire))
                        {
                        *((MIL_INT64 *)Ptr) = (MIL_INT64)lDigInquire.InquiredValue;
                        }
                     else if(M_IN_DIG_INQUIRE_MIL_ID_RANGE(ParamToInquire))
                        {
                        *((MIL_ID *)Ptr) = (MIL_ID)lDigInquire.InquiredValue;
                        }
                     else
                        {
                        *((MIL_INT *)Ptr) = (MIL_INT)lDigInquire.InquiredValue;
                        }
                  }
               }
            else
               ErrorCode(lError.SystemErrorNumber(), lError.SystemSubMessage1());
            }
            break;
         }
      }

end:;

   return(lRetval);
   }

//==============================================================================
//
//   Name:       DigHookFunction()
//
//   Synopsis:   Hook a function to a specific event.
//
//   Parameters: MD_ID Digitizer ID        : ID of the digitizer.
//               MIL_INT HookType          : Type of event to hook.
//
//                                           Grabbing events:
//                                           M_GRAB_END
//                                           M_GRAB_FRAME_END
//                                           M_GRAB_FIELD_END
//                                           M_GRAB_FIELD_END_ODD
//                                           M_GRAB_FIELD_END_EVEN
//                                           Grabbing or not events:
//                                           M_FIELD_START
//                                           M_FIELD_START_ODD
//                                           M_FIELD_START_EVEN
//
//               void *(MIL_DIG_HOOK_FUNCTION_PTR)HandlerPtr          : Pointer to the function to hook.
//               void *UserPtr             : Pointer to user data structure.
//               ThreadContextPtr          : Thread context object pointer.
//
//==============================================================================
MIL_INT MDHwSpecSystem::DigHookFunction(MD_ID DigitizerId, MIL_INT HookType, MIL_DIG_HOOK_FUNCTION_PTR iHandlerPtr, void *UserPtr, MDDriverThreadContext *ThreadContextPtr)
   {
   MDDigitizerInfo       *DigitizerInfoPtr = Digitizers[DigitizerId];
   CDigConfig            *lpDigConfig = DigitizerInfoPtr->GetDigConfig();
   bool                   lContinuousGrabInProgress = false;
   MIL_DIG_HOOK_FUNCTION_PTR HandlerPtr = (MIL_DIG_HOOK_FUNCTION_PTR)iHandlerPtr;

   if(HookType & M_UNHOOK)
      {
      HookType &= ~M_UNHOOK;
      HandlerPtr = M_NULL;
      UserPtr = M_NULL;
      }

   if(DigitizerInfoPtr->ContinuousGrabInProgress())
      {
      lContinuousGrabInProgress = true;
      DigHalt(DigitizerId, ThreadContextPtr);
      if(ErrorCode())
         ErrorCode(M_NO_ERROR);
      }

   switch(HookType)
      {
      case M_FEATURE_CHANGE + M_ALL:
      case M_FEATURE_CHANGE + M_SINGLE:
      case M_FEATURE_CHANGE:
         MDGeniCamDeviceSystem::DigHookFunction(DigitizerId, HookType, HandlerPtr, UserPtr, ThreadContextPtr);
         break;
      case M_GRAB_START:
         {
         if(UserPtr)
            {
            lpDigConfig->Properties.m_Hooks.GrabStart.Add(HandlerPtr, UserPtr);
            mp_UserHook->RegisterHookFunction((HOOK_TYPE_GRAB_START | DigitizerInfoPtr->Number()), this, &lpDigConfig->Properties.m_Hooks.GrabStart, MilId(), ThreadContextPtr);
            LLHook(HookType, lpDigConfig, true, ThreadContextPtr);
            }
         else
            {
            LLHook(HookType, lpDigConfig, false, ThreadContextPtr);
            mp_UserHook->UnRegisterHookFunction((HOOK_TYPE_GRAB_START | DigitizerInfoPtr->Number()), this, ThreadContextPtr);
            lpDigConfig->Properties.m_Hooks.GrabStart.Add(HandlerPtr, UserPtr);
            }
         }
         break;
      case M_GRAB_FRAME_START:
         {
         if(UserPtr)
            {
            lpDigConfig->Properties.m_Hooks.GrabFrameStart.Add(HandlerPtr, UserPtr);
            mp_UserHook->RegisterHookFunction((HOOK_TYPE_GRAB_FRAME_START | DigitizerInfoPtr->Number()), this, &lpDigConfig->Properties.m_Hooks.GrabFrameStart, MilId(), ThreadContextPtr);
            LLHook(HookType, lpDigConfig, true, ThreadContextPtr);
            }
         else
            {
            LLHook(HookType, lpDigConfig, false, ThreadContextPtr);
            mp_UserHook->UnRegisterHookFunction((HOOK_TYPE_GRAB_FRAME_START | DigitizerInfoPtr->Number()), this, ThreadContextPtr);
            lpDigConfig->Properties.m_Hooks.GrabFrameStart.Add(HandlerPtr, UserPtr);
            }
         }
         break;
      case M_GRAB_END:
         {
         if(UserPtr)
            {
            lpDigConfig->Properties.m_Hooks.GrabEnd.Add(HandlerPtr, UserPtr); 
            mp_UserHook->RegisterHookFunction((HOOK_TYPE_GRAB_END | DigitizerInfoPtr->Number()), this, &lpDigConfig->Properties.m_Hooks.GrabEnd, MilId(), ThreadContextPtr);
            }
         else
            {
            mp_UserHook->UnRegisterHookFunction((HOOK_TYPE_GRAB_END | DigitizerInfoPtr->Number()), this, ThreadContextPtr);
            lpDigConfig->Properties.m_Hooks.GrabEnd.Add(HandlerPtr, UserPtr); 
            }
         }
         break;
      case M_GRAB_FRAME_END:
         {
         if(UserPtr)
            {
            lpDigConfig->Properties.m_Hooks.GrabFrameEnd.Add(HandlerPtr, UserPtr); 
            mp_UserHook->RegisterHookFunction((HOOK_TYPE_GRAB_FRAME_END | DigitizerInfoPtr->Number()), this, &lpDigConfig->Properties.m_Hooks.GrabFrameEnd, MilId(), ThreadContextPtr);
            }
         else
            {
            mp_UserHook->UnRegisterHookFunction((HOOK_TYPE_GRAB_FRAME_END | DigitizerInfoPtr->Number()), this, ThreadContextPtr);
            lpDigConfig->Properties.m_Hooks.GrabFrameEnd.Add(HandlerPtr, UserPtr); 
            }
         }
         break;
      case M_EXPOSURE_START:
         {
         if(UserPtr)
            {
            lpDigConfig->Properties.m_Hooks.GrabExposureStart.Add(HandlerPtr, UserPtr); 
            mp_UserHook->RegisterHookFunction((HOOK_TYPE_GRAB_EXPOSURE_START | DigitizerInfoPtr->Number()), this, &lpDigConfig->Properties.m_Hooks.GrabExposureStart, MilId(), ThreadContextPtr);
            LLHook(HookType, lpDigConfig, true, ThreadContextPtr);
            }
         else
            {
            LLHook(HookType, lpDigConfig, false, ThreadContextPtr);
            mp_UserHook->UnRegisterHookFunction((HOOK_TYPE_GRAB_EXPOSURE_START | DigitizerInfoPtr->Number()), this, ThreadContextPtr);
            lpDigConfig->Properties.m_Hooks.GrabExposureStart.Add(HandlerPtr, UserPtr); 
            }
         }
         break;
      case M_EXPOSURE_END:
         {
         if(UserPtr)
            {
            lpDigConfig->Properties.m_Hooks.GrabExposureEnd.Add(HandlerPtr, UserPtr);
            mp_UserHook->RegisterHookFunction((HOOK_TYPE_GRAB_EXPOSURE_END | DigitizerInfoPtr->Number()), this, &lpDigConfig->Properties.m_Hooks.GrabExposureEnd, MilId(), ThreadContextPtr);
            LLHook(HookType, lpDigConfig, true, ThreadContextPtr);
            }
         else
            {
            LLHook(HookType, lpDigConfig, false, ThreadContextPtr);
            mp_UserHook->UnRegisterHookFunction((HOOK_TYPE_GRAB_EXPOSURE_END | DigitizerInfoPtr->Number()), this, ThreadContextPtr);
            lpDigConfig->Properties.m_Hooks.GrabExposureEnd.Add(HandlerPtr, UserPtr);
            }
         }
         break;
      case M_TIMER_START + M_TIMER_STROBE:
         {
         if(UserPtr)
            {
            lpDigConfig->Properties.m_Hooks.StrobeTimerStart.Add(HandlerPtr, UserPtr);
            mp_UserHook->RegisterHookFunction((HOOK_TYPE_STROBE_START | DigitizerInfoPtr->Number()), this, &lpDigConfig->Properties.m_Hooks.StrobeTimerStart, MilId(), ThreadContextPtr);
            LLHook(HookType, lpDigConfig, true, ThreadContextPtr);
            }
         else
            {
            LLHook(HookType, lpDigConfig, false, ThreadContextPtr);
            mp_UserHook->UnRegisterHookFunction((HOOK_TYPE_STROBE_START | DigitizerInfoPtr->Number()), this, ThreadContextPtr);
            lpDigConfig->Properties.m_Hooks.StrobeTimerStart.Add(HandlerPtr, UserPtr);
            }
         }
         break;
      case M_TIMER_END + M_TIMER_STROBE:
         {
         if(UserPtr)
            {
            lpDigConfig->Properties.m_Hooks.StrobeTimerEnd.Add(HandlerPtr, UserPtr); 
            mp_UserHook->RegisterHookFunction((HOOK_TYPE_STROBE_END | DigitizerInfoPtr->Number()), this, &lpDigConfig->Properties.m_Hooks.StrobeTimerEnd, MilId(), ThreadContextPtr);
            LLHook(HookType, lpDigConfig, true, ThreadContextPtr);
            }
         else
            {
            LLHook(HookType, lpDigConfig, false, ThreadContextPtr);
            mp_UserHook->UnRegisterHookFunction((HOOK_TYPE_STROBE_END | DigitizerInfoPtr->Number()), this, ThreadContextPtr);
            lpDigConfig->Properties.m_Hooks.StrobeTimerEnd.Add(HandlerPtr, UserPtr); 
            }
         }
         break;
      default:
         ErrorCode(M_HOOK_ERROR_0, 1);//Invalid hook type specified
      }

   if(lContinuousGrabInProgress)
      DigGrab(DigitizerId, DigitizerInfoPtr->ContinuousGrabBufId(), M_FOREVER, ThreadContextPtr);

   return(M_VALID);
   }

/****************************************************************************************************
*
*     Name:         MDHwSpecSystem::DigGetHookInfo
*
*     Parameters:   MIL_ID HookContextId,
*                   MIL_INT InfoType,
*                   void *UserPtr,
*                   MIL_INT *Error
*
****************************************************************************************************/
MIL_INT MDHwSpecSystem::DigGetHookInfo(MIL_ID HookContextId, MIL_INT64 InfoType, void *UserPtr, MIL_INT *Error, MDDriverThreadContext *ThreadContextPtr)
   {
   UNREFERENCED_PARAMETER(ThreadContextPtr);
   HOOK_ELEMENT_INFO* lpHookElementInfo = nullptr;
   DRIVER_HOOK_CONTEXT *lpHookContext = nullptr;
   HookData *lpHookData = nullptr;
   *Error = M_NULL_ERROR;

   MfuncInquire(HookContextId, M_OBJECT_PTR, &lpHookElementInfo);
   lpHookContext = &lpHookElementInfo->m_HookContext;
   if(lpHookContext->Size != sizeof(DRIVER_HOOK_CONTEXT))
      {
      lpHookData = reinterpret_cast<HookData*>(lpHookContext);
      lpHookContext = nullptr;
      }

   if(lpHookContext)
      {
      switch(InfoType)
         {
         case M_MODIFIED_BUFFER+M_BUFFER_ID:
            *(MIL_ID *)UserPtr = lpHookContext->BufferId;

            if(lpHookContext->BufferId == M_NULL)
               {
               ErrorCode(M_DIG_GET_HOOK_INFO_ERROR_0, 2);   // The requested InfoType is not valid for this hook type.
               *Error = M_ERROR;
               }
            break;

         case M_MODIFIED_BUFFER+M_BUFFER_INDEX:
            *(MIL_INT *)UserPtr = lpHookContext->BufferIndex;

            if(lpHookContext->BufferIndex == -1)
               {
               ErrorCode(M_DIG_GET_HOOK_INFO_ERROR_0, 2);   // The requested InfoType is not valid for this hook type.
               *Error = M_ERROR;
               }
            break;

         case M_MODIFIED_BUFFER+M_REGION_OFFSET_X:
            *(MIL_INT *)UserPtr = lpHookContext->RegionOffsetX;

            if(lpHookContext->BufferId == M_NULL)
               {
               ErrorCode(M_DIG_GET_HOOK_INFO_ERROR_0, 2);   // The requested InfoType is not valid for this hook type.
               *Error = M_ERROR;
               }
            break;

         case M_MODIFIED_BUFFER+M_REGION_OFFSET_Y:
            *(MIL_INT *)UserPtr = lpHookContext->RegionOffsetY;

            if(lpHookContext->BufferId == M_NULL)
               {
               ErrorCode(M_DIG_GET_HOOK_INFO_ERROR_0, 2);   // The requested InfoType is not valid for this hook type.
               *Error = M_ERROR;
               }
            break;

         case M_MODIFIED_BUFFER+M_REGION_SIZE_X:
            *(MIL_INT *)UserPtr = lpHookContext->RegionSizeX;

            if(lpHookContext->BufferId == M_NULL)
               {
               ErrorCode(M_DIG_GET_HOOK_INFO_ERROR_0, 2);   // The requested InfoType is not valid for this hook type.
               *Error = M_ERROR;
               }
            break;

         case M_MODIFIED_BUFFER+M_REGION_SIZE_Y:
            *(MIL_INT *)UserPtr = lpHookContext->RegionSizeY;

            if(lpHookContext->BufferId == M_NULL)
               {
               ErrorCode(M_DIG_GET_HOOK_INFO_ERROR_0, 2);   // The requested InfoType is not valid for this hook type.
               *Error = M_ERROR;
               }
            break;

         case M_TIME_STAMP:
            *(MIL_DOUBLE *)UserPtr = lpHookContext->EventTimeStamp;
            break;

         case M_TIME_STAMP+M_TIMER_IO:
            *(MIL_DOUBLE *)UserPtr = lpHookContext->EventTimeStampIo;
            break;

         case M_DIGITIZER_ID:
            *(MIL_ID *)UserPtr = lpHookContext->DigitizerId;
            break;

         case M_DRIVER_HOOK_CONTEXT_PTR:
            {
            DRIVER_HOOK_CONTEXT *lpUserHookContext = (DRIVER_HOOK_CONTEXT *)UserPtr;

            if((lpUserHookContext->Size) && (lpUserHookContext->Size <= lpHookContext->Size))
               MDrv_memcpy(lpUserHookContext, lpHookContext, lpUserHookContext->Size);
            else
               {
               ErrorCode(M_DIG_GET_HOOK_INFO_ERROR_0, 2);   // The requested InfoType is not valid for this hook type.
               *Error = M_ERROR;
               }
            }
            break;
         case M_CORRUPTED_FRAME:
            *(MIL_INT*)UserPtr = lpHookContext->CorruptedFrame;
         break;
         case M_GRAB_TRIGGER_MISSED:
            *(MIL_INT*)UserPtr = lpHookContext->TriggerMissed;
            break;

         case M_REFERENCE_LATCH_VALUE + M_IO_COMMAND_LIST1 + M_LATCH1:
            *(MIL_INT64*)UserPtr = lpHookContext->RefLatchValue[0];
            break;

         case M_REFERENCE_LATCH_VALUE + M_IO_COMMAND_LIST1 + M_LATCH2:
            *(MIL_INT64*)UserPtr = lpHookContext->RefLatchValue[1];
            break;

         default:
            ErrorCode(M_DIG_GET_HOOK_INFO_ERROR_0, 1);   // The requested InfoType is not valid.
            *Error = M_ERROR;
            break;
         }
      }
   else if(lpHookData)
      {
      FeatureHookController::GetHookInfo(HookContextId, InfoType, UserPtr, Error);
      }
   else
      {
      *Error = M_ERROR;
      }

   return (M_VALID);
   }

/****************************************************************************************************
*
*     Name:         MDHwSpecSystem::LLHook
*
*     Parameters:    MIL_INT HookType 
*                    CDigConfig *ipDigConfig    
*                    bool Enable                   : Enable or not
*                    ThreadContextPtr
*
****************************************************************************************************/
void MDHwSpecSystem::LLHook(MIL_INT HookType,CDigConfig *ipDigConfig,bool Enable,MDDriverThreadContext *ThreadContextPtr)
{
DIG_HOOK lDigHook;

   lDigHook.ThreadHandle   = ThreadContextPtr->LLThreadHandle();
   lDigHook.SystemId       = SystemId();
   lDigHook.HookType       = HookType;

   if(Enable)
      lDigHook.UnHook         = M_DEFAULT;
   else
      lDigHook.UnHook         = M_UNHOOK;

   MDrv_memcpy(&(lDigHook.DigConfig), ipDigConfig, sizeof(CDigConfig));

      // Relay the call to the low level library
   LLDigHook(SystemId(), lDigHook, ThreadContextPtr);

}

/****************************************************************************************************
*
*     Name:         MDDeviceDriver::DigLut
*
*     Parameters:
*                   MD_ID SystemId:
*                   MD_ID DigitizerId:
*                   MIL_ID BufferId:
*                   MDDriverThreadContext *ThreadContextPtr:
*
*     Return value:
*                   MIL_INT:
*
*     Comments:
*
****************************************************************************************************/
MIL_INT MDHwSpecSystem::DigLut(MD_ID DigitizerId,
                               MIL_ID BufferId,
                               MDDriverThreadContext *ThreadContextPtr)
   {
   MIL_INT           lRetval = M_VALID;
   MIL_INT           lDigSizeBit = 0;
   MDHwSpecDigitizerInfo  *lpDigitizerInfo = (MDHwSpecDigitizerInfo*)Digitizers[DigitizerId];
   bool              lRestartContinuousGrab = false;
   CError            lError;
   MIL_ID            lGrabBuffer = 0L;
   DIG_LUT          *lDigLut = NULL;
   MIL_INT32         lBufSizeBit = 0;
   MIL_INT           lBandSize = 0;
   MilBufferInfo     *lpBufInfo = NULL;

   DigInquire(DigitizerId, M_SIZE_BIT, &lDigSizeBit, ThreadContextPtr);
   MIL_INT lDigitizerLutSize = MAKE_INT64(1) << lDigSizeBit;

   if (lDigSizeBit > 10)
      ErrorCode(M_DIGLUT_ERROR_0, 2); //Invalid buffer format.

   if ((BufferId != M_DEFAULT_LUT) && (BufferId != M_DEFAULT))
      {
      MIL_INT64 Attr;
      MfuncInquire(BufferId, M_OBJECT_TYPE_EXTENDED, &Attr);
      if (Attr == M_LUT)
         {
         MilBufferInfo *lpBufInfo = (MilBufferInfo *)MbufInquire(BufferId, M_BUFFER_INFO, M_NULL);
         if (lpBufInfo->SizeBit() > 16)
            ErrorCode(M_DIGLUT_ERROR_0, 4); //Invalid buffer format.

         if ((lpBufInfo->SizeX() < lDigitizerLutSize)) // Lut 12 bits max
            ErrorCode(M_DIGLUT_ERROR_0, 3); //Invalid buffer format.
         }
      else
         ErrorCode(M_BUFFER_ERROR_0, 1); //Invalid buffer attribute.
      }

   if (!ErrorCode())
      {
      if (lpDigitizerInfo->ContinuousGrabInProgress())
         {
         lRestartContinuousGrab = true;
         lGrabBuffer = lpDigitizerInfo->ContinuousGrabBufId();
         MDHwSpecSystem::DigHalt(DigitizerId, ThreadContextPtr);
         if (ErrorCode())
            ErrorCode(M_NO_ERROR);
         }

      if ((BufferId == M_DEFAULT_LUT) || (BufferId == M_DEFAULT))
         {
         MIL_INT lAdditionnalBytes = 0;
         lpDigitizerInfo->LutId(M_DEFAULT);
         lpDigitizerInfo->SizeBandLut(1);

         lDigitizerLutSize = 1024;
         lBufSizeBit = 16L;

         lAdditionnalBytes = lDigitizerLutSize * (lBufSizeBit / 8);

         //Allocate a buffer large enough so that all the data can be copied by the kernel driver
         lDigLut = new (lAdditionnalBytes)DIG_LUT;

         lDigLut->iActualSize = sizeof(DIG_LUT) + lAdditionnalBytes;

         for (MIL_INT i = 0; i<lDigitizerLutSize; i++)
            ((MIL_INT16 *)lDigLut->Data)[i] = (MIL_UINT16)i;

         lDigLut->iLutType = M_MONO;
         lDigLut->iNbElem = lDigitizerLutSize;
         lDigLut->iLutSizeBit = lBufSizeBit;
         lDigLut->iLutResetType = M_DEFAULT;
         }
      else
         {
         MIL_INT lAdditionnalBytes = 0;
         lpBufInfo = (MilBufferInfo *)MbufInquire(BufferId, M_BUFFER_INFO, M_NULL);

         lpDigitizerInfo->LutId(BufferId);
         lpDigitizerInfo->SizeBandLut(lpBufInfo->SizeBand());

         lBandSize = lpBufInfo->SizeX() * (lpBufInfo->SizeBit() / 8);
         lDigitizerLutSize = lAdditionnalBytes = lBandSize * lpBufInfo->SizeBand();

         //Allocate a buffer large enough so that all the data can be copied by the kernel driver
         lDigLut = new (lAdditionnalBytes)DIG_LUT;

         lDigLut->iActualSize = sizeof(DIG_LUT) + lAdditionnalBytes;

         if(lpBufInfo->SizeBand() == 1)
            MDrv_memcpy(lDigLut->Data, (void*)lpBufInfo->HostAddress(), lAdditionnalBytes);
         else if(lpBufInfo->SizeBand() == 3)
            {
            MDrv_memcpy(lDigLut->Data, (void*)lpBufInfo->BandHostAddress(0), lBandSize);
            MDrv_memcpy((void*)(lDigLut->Data + lBandSize), (void*)lpBufInfo->BandHostAddress(1), lBandSize);
            MDrv_memcpy((void*)(lDigLut->Data + 2 * lBandSize), (void*)lpBufInfo->BandHostAddress(2), lBandSize);
            }

         lDigLut->iLutType = (lpBufInfo->SizeBand() == 1) ? M_MONO : M_COLOR;
         lDigLut->iNbElem = lpBufInfo->SizeX();
         lDigLut->iLutSizeBit = lpBufInfo->SizeBit();
         lDigLut->iLutResetType = 0;
         }

      CDigConfig *lpDigConfig = lpDigitizerInfo->GetDigConfig();
      lDigLut->SystemId = SystemId();
      lDigLut->DigConfig = *lpDigConfig;
      lDigLut->ThreadHandle = ThreadContextPtr->LLThreadHandle();

      // Check if any error pending
      MIL_INT ErrorPending = ErrorCode();
      // Relay the call to the low level library

      if (!ErrorPending)
         LLDigLut(SystemId(), lDigLut, lError, ThreadContextPtr);

      // Check if the call was handled by the low level library
      // Do not call the base driver if driver handled the call
      if (lError.CallNotSupported() && !ErrorPending)
         {
         // Relay it to the base class if it cant be handled
         lRetval = MDDeviceSystem::DigLut(DigitizerId, BufferId, ThreadContextPtr);

         // Reset error code if handled by the base class
         if (lRetval == M_VALID)
            ErrorCode(M_NO_ERROR);
         }

      if (!(lError.ErrorLogged()) && !ErrorPending && (lRestartContinuousGrab == true))
         {
         //Update continuous grab manager to apply the control
         MDHwSpecSystem::DigGrab(DigitizerId, lGrabBuffer, M_FOREVER, ThreadContextPtr);
         }

      if (lDigLut)
         {
         delete lDigLut;
         lDigLut = NULL;
         }
      }

   return lRetval;
   }

/****************************************************************************************************
*
*     Name:         ComputeBlockSize
*
*     Parameters:
*                   MIL_DOUBLE Factor:           Factor used to change the way the blocks are sized
*                   MIL_DOUBLE SizeY:            Total number of lines in buffer to convert to blocks
*                   MIL_DOUBLE CurBlkNb:         Current block number whose block size we wish to compute
*                   MIL_DOUBLE NbBlksInBuf:      Total number of blocks that constitutes buffer.
*
*     Return value:
*                   MIL_INT: The size of the CurBlockNb in the buffer whose total size is SizeY
*
*     Comments:     This equation is actually a financial equation used to compute the payment on
*                   the principal for a given period for an investment based on periodic, constant
*                   payments and a constant interest rate (see ppmt function in MS Excel).
*
*                   The usual input parameters to this function would be:
*                   InterestRate                         (Factor)
*                   OriginalBalance                      (NbLines)
*                   Toatl number of periods              (NbBlksInBuf)
*                   Period to compute the principal paid (CurBlkNb)
*
****************************************************************************************************/
MIL_INT ComputeBlockSize(MIL_DOUBLE Factor, MIL_DOUBLE SizeY, MIL_DOUBLE CurBlkNb, MIL_DOUBLE NbBlksInBuf)
   {
   double Result;
   double Numerator;
   double Denominator;

   if(Factor != 0.0)
      {
      Factor = Factor / NbBlksInBuf;

      Numerator = pow((1.0 + Factor), (CurBlkNb - 1.0));
      Denominator =  pow((1.0 + Factor), NbBlksInBuf) - 1.0;

      Result = Factor * SizeY * (Numerator / Denominator);
      }
   else
      {
      Result = SizeY / NbBlksInBuf;
      }

   return M_DTOMI(Result);
   }

//==============================================================================
//
//   Name:       DoCheckAndSetParam()
//
//   Synopsis:   Do board specific checking and if needed set default parameters.
//
//   Parameters: MIL_INT SizeBand     : Nb of bands.
//               MIL_INT SizeX        : X dimension of buffer.
//               MIL_INT SizeY        : Y dimension of buffer.
//               MIL_INT Type         : Pixel depth in bit and signed or unsigned.
//               MIL_INT64 Attribute  : Target use of this buffer.
//               MIL_INT64 ControlFlag: Creation control flag.
//               MIL_INT Pitch        : Pitch value.
//               MIL_INT TargetSize   : Used for jpeg2000 buffers.
//               void *pArrayOfData   : Pointer to an array of data.
//               CError Error         : Error log.
//
//   Comments:   This methods should be used in BufCreateColor() only.
//
//==============================================================================
void MDHwSpecSystem::DoCheckAndSetParam(MIL_INT               &SizeBand,
                                        MIL_INT               &SizeX,
                                        MIL_INT               &SizeY,
                                        MIL_INT               &Type,
                                        MIL_INT64             &Attribute,
                                        MIL_INT64             &ControlFlag,
                                        MIL_INT               &Pitch,
                                        MIL_INT               &TargetSize,
                                        void                  *pArrayOfData,
                                        CError                &Error)
   {
   UNREFERENCED_PARAMETER(TargetSize);
   UNREFERENCED_PARAMETER(SizeX);
   UNREFERENCED_PARAMETER(SizeY);
   UNREFERENCED_PARAMETER(Pitch);
   UNREFERENCED_PARAMETER(pArrayOfData);
   UNREFERENCED_PARAMETER(ControlFlag);

   // The user must specify the internal format when he specify M_PACKED.
   if( (Attribute & M_IMAGE) && (Attribute & M_PACKED) && ((Attribute & M_INTERNAL_FORMAT) == 0 ) )
      {
      Error.Log(M_BUFFER_ERROR_5, 3);
      goto end;
      }

   ////////////////////////////////////////////////////////////////////////
   // On-board buffer.
   ////////////////////////////////////////////////////////////////////////
   if(Attribute & M_DRV_ON_BOARD)
      {
      Error.Log(M_BUFFER_ERROR_2, 2);
      goto end;
      }

   if((Attribute & M_IMAGE) && (Attribute & M_GRAB))
      {
      // If the internal_format is not specified add one.
      // The default 8-bit 3 band buffer is YUV16|M_PACKED.
      // *** HERE the buffer are not M_PACKED (i.e. M_PLANAR or nothing specify) ***
      // *** The user must specify the internal format when he specify M_PACKED  ***
      if( (Attribute & M_INTERNAL_FORMAT) == 0 )
         {
         if(SizeBand == 3) 
            {
            switch(Type & M_SIZE_BIT_MASK)
               {
               case 8:
                  if(Attribute & M_DISP)
                     Attribute |= (M_BGR32| M_PACKED);
                  else
                     Attribute |= (M_RGB24 | M_PLANAR); 
                  break;

               case 16:
                  Attribute |= (M_YUV16 | M_PACKED);
                  break;

               case 1:
               case 32:
               default:
                  Error.Log(M_BUFFER_ERROR_2, 2);
                  goto end;
                  break;
               }
            }
         else // Not a 3 band buffer.
            {
            switch(Type & M_SIZE_BIT_MASK)
               {
               case 8:
                  Attribute |= (M_MONO8 | M_PLANAR);
                  break;

               case 16:
                  Attribute |= (M_MONO16 | M_PLANAR);
                  break;

               case 1:
               case 32:
               default:
                  Error.Log(M_BUFFER_ERROR_2, 2);
                  goto end;
                  break;
               }
            }
         }
      }

   end:

   return;
   }

//==============================================================================
//
//   Name:       DoCheckParamForGrab()
//
//   Synopsis:   Do board specific checking for grab buffer (on-board or off-board).
//
//   Parameters: MIL_INT SizeBand     : Nb of bands.
//               MIL_INT SizeX        : X dimension of buffer.
//               MIL_INT SizeY        : Y dimension of buffer.
//               MIL_INT Type         : Pixel depth in bit and signed or unsigned.
//               MIL_INT64 Attribute  : Target use of this buffer.
//               MIL_INT64 ControlFlag: Creation control flag.
//               MIL_INT Pitch        : Pitch value.
//               MIL_INT TargetSize   : Used for jpeg2000 buffers.
//               void *pArrayOfData   : Pointer to an array of data.
//               CError Error         : Error log.
//
//   Comments:   This methods should be used in BufCreateColor() only.
//
//==============================================================================
void MDHwSpecSystem::DoCheckParamForGrab(MIL_INT        SizeBand,
                                         MIL_INT        SizeX,
                                         MIL_INT        SizeY,
                                         MIL_INT        Type,
                                         MIL_INT64      Attribute,
                                         MIL_INT64      ControlFlag,
                                         MIL_INT        Pitch,
                                         MIL_INT        TargetSize,
                                         void   * const pArrayOfData,
                                         CError        &Error)
   {
   UNREFERENCED_PARAMETER(TargetSize);
   UNREFERENCED_PARAMETER(SizeX);
   UNREFERENCED_PARAMETER(SizeY);
   UNREFERENCED_PARAMETER(SizeBand);
   UNREFERENCED_PARAMETER(Pitch);
   UNREFERENCED_PARAMETER(pArrayOfData);
   UNREFERENCED_PARAMETER(ControlFlag);
   ////////////////////////////////////////////////////////////////////////
   // Grab buffers, on-board and off-board.
   ////////////////////////////////////////////////////////////////////////
   if((Attribute & M_IMAGE) && (Attribute & M_GRAB))
      {
      if(Attribute & M_COMPRESS)
         {
         Error.Log(M_BUFFER_ERROR_5, 1);
         goto end;
         }

      if((Type == (32 + M_FLOAT)) ||
         (Attribute & M_FLIP) ||
         (Attribute & M_PAGED))
         {
         Error.Log(M_BUFFER_ERROR_2, 2);
         goto end;
         }

      if(Type & M_SIGNED)
         {
         Error.Log(M_BUFFER_ERROR_2, 4);
         goto end;
         }

      // Accepted buffer types.
      switch(Type & M_SIZE_BIT_MASK)
         {
         case 8:
         case 16:
            break;

         default:
            Error.Log(M_BUFFER_ERROR_2, 3);
            goto end;
            break;
         }

      if(m_FlashInfo.head[0].HeadType & 0x01000000) // color sensor
         {
         // Accepted grab buffers.
         switch(Attribute & (M_INTERNAL_FORMAT | M_PLANAR | M_PACKED))
            {
            // Planar formats.
            // T.BM.
            // Add Buffer when hardware supported its.
            case M_MONO8 | M_PLANAR:
            case M_MONO16 | M_PLANAR:

               // Pack formats.
            case M_BGR32 | M_PACKED:
            case M_YUV16 | M_PACKED:
            case M_YUV16_YUYV | M_PACKED:

               // Format supported only on-host
            case M_RGB24 | M_PLANAR:
               // Buffer format accepted!
               break;

            default:
               Error.Log(M_BUFFER_ERROR_2, 2);
               goto end;
               break;
            }
         }
      else
         {
         switch(Attribute & (M_INTERNAL_FORMAT | M_PLANAR | M_PACKED))
            {
            // Planar formats.
            // T.BM.
            // Add Buffer when hardware supported its.
            case M_MONO8 | M_PLANAR:
            case M_MONO16 | M_PLANAR:
               break;

            default:
               Error.Log(M_BUFFER_ERROR_2, 2);
               goto end;
               break;
            }
         }
      }

   end:

   return;
   }

//==============================================================================
//
//   Name:       DoGetBufferFormatMask()
//
//   Synopsis:   Get the board specific buffer format mask.
//
//   Return value:
//               MIL_INT64: buffer format mask.
//
//   Comments:   This methods should be used in BufCreateColor() only.
//
//==============================================================================
MIL_INT64 MDHwSpecSystem::DoGetBufferFormatMask() const
   {
   return IRIS_GTX_BUFFER_FORMAT_MASK;
   }

//==============================================================================
//
//   Name:       DoGetAddressAlignment()
//
//   Synopsis:   Get the board specific address alignment for M_NON_PAGED and
//               M_IMAGE buffer allocation.
//
//   Return value:
//               MIL_INT: Address alignment.
//
//   Comments:   This methods should be used in BufCreateColor() only.
//
//==============================================================================
MIL_INT MDHwSpecSystem::DoGetAddressAlignment() const
   {
   return 0;
   }


/// <summary>
/// Reads the manifest table.
/// </summary>
/// <param name="pDigInfo">The p dig information.</param>
/// <param name="ThreadContextPtr">The thread context PTR.</param>
void MDHwSpecSystem::ReadManifestTable(MD_ID DigitizerId, MDDriverThreadContext* ThreadContextPtr)
   {
   UNREFERENCED_PARAMETER(ThreadContextPtr);
   UNREFERENCED_PARAMETER(DigitizerId);
   UNREFERENCED_PARAMETER(ThreadContextPtr);
   }

MIL_INT MDHwSpecSystem::DigControlFeature(MD_ID DigitizerId, MIL_INT64 ControlFlag, MIL_CONST_TEXT_PTR FeatureName, MIL_INT64 UserVarType,
                                          void *UserVarPtr, MIL_INT PtrSize, MDDriverThreadContext *ThreadContextPtr)
   {
   try
      {
      MDGeniCamDeviceSystem::DigControlFeature(DigitizerId, ControlFlag, FeatureName, UserVarType, UserVarPtr, PtrSize, ThreadContextPtr);
      }
   catch(GenICam::GenericException &e)
      {
      CMILString SubError2 = CMILString(MIL_TEXT("Description: ")) + CMILString::CreateASCII(e.what());
      ErrorCodeDynamic(M_GENICAM_CONTROLFEATURE_ERROR_0, MIL_TEXT("A GenICam exception occurred."), (MIL_CONST_TEXT_PTR)SubError2);
      }
   return M_VALID;
   }

MIL_INT MDHwSpecSystem::DigInquireFeature(MD_ID DigitizerId, MIL_INT64 ControlFlag, MIL_CONST_TEXT_PTR FeatureName, MIL_INT64 UserVarType,
                                          void *UserVarPtr, MIL_INT PtrSize, MDDriverThreadContext *ThreadContextPtr)
   {
   try
      {
      MDGeniCamDeviceSystem::DigInquireFeature(DigitizerId, ControlFlag, FeatureName, UserVarType, UserVarPtr, PtrSize, ThreadContextPtr);
      }
   catch(GenICam::GenericException &e)
      {
      GenICam::GenericException lex = e;
      ErrorCode(M_GENICAM_INQUIREFEATURE_ERROR_0, 2);
      }

   return M_VALID;
   }

//==============================================================================
//
//   Name:       AllocateGenICamPort()
//
//   Synopsis:   Allocates a GenICamPort to be used with base class AllocateGenICamProxysFromXMLsInResource.
//               This port is used to access the decoders and FPGAs.
//
//   Parameters:  MDHwSpecDigitizerInfo *ipDigitizerInfo
//               ThreadContextPtr      : Thread context object pointer.
//
//==============================================================================
std::vector<std::shared_ptr<CMilTransportLayerBase>> MDHwSpecSystem::AllocateGenICamPort(const MIL_STRING& PortName, MIL_ID iObjId, const XmlResource& Resource)
   {
   vector<shared_ptr<CMilTransportLayerBase>> Ports = MDGeniCamDeviceSystem::AllocateGenICamPort(PortName, iObjId, Resource);

   if (iObjId && (Ports.size() == 0))
      {
      MIL_INT64 objectType = 0;
      MobjInquire(iObjId, M_OBJECT_TYPE, &objectType);
      if (objectType == M_DIGITIZER) // The digitizer part only
         {
         struct _Info
            {
            MIL_UINT64 Address;
            MIL_INT  NumberOfDevices;
            bool IsReal; // true if real hardware.
            PORT_ADDRESS::BUS_TYPE type;
            };

         std::map<MIL_STRING, _Info> decoderPorts
            {
                  {MIL_TEXT("python_sensor"), {0, 1, true, PORT_ADDRESS::SPI}},
                  {MIL_TEXT("regfile_athena"), {0, 1, true, PORT_ADDRESS::FPGA}},
            };

         auto iAddress = decoderPorts.find(PortName);
         if (iAddress != decoderPorts.end())
            {
            MDDigitizerInfo* lpDigInfo = nullptr;
            {
            auto Fn = [](MDHwSpecDigitizerInfo& Dig, MIL_INT DigNum) { return Dig.GetDigConfig()->MilId == DigNum; };
            lpDigInfo = Digitizers.Find(Fn, iObjId);
            }
            for (int i = 0; i < iAddress->second.NumberOfDevices; i++)
               {
               if (iAddress->second.IsReal)
                  {
                  auto pPort = make_shared<CTransportLayerHwSpec>(this, lpDigInfo, iAddress->second.type);
                  pPort->m_Name = PortName;
                  pPort->SetOffset(iAddress->second.Address);
                  Ports.push_back(pPort);
                  }
               else
                  {
                  auto pPort = make_shared<CTransportLayerHwSpecNoHw>(this->MilId());
                  pPort->m_Name = PortName;
                  pPort->Init(i);
                  Ports.push_back(pPort);
                  }
               }
            }
         }
      }
   return Ports;
   }
