/*

Copyright (c) Matrox Electronic Systems. All rights reserved.

Module Name:

 mtxservmanager.cpp

Abstract:

    This source will define the C API (Application Programming Interface)
    for the mtxservmanager (Matrox Services manager) driver.

Revision History:

--*/
#include "stdafx.h"
#include "mtxservmanager.h"

// now include directories depending on the OS and user or kernel mode

#if MSM_API_USE_WINDOWS
#include <stddef.h>
#if MSM_API_USER_CODE

#include <windows.h>
#define MSM_USER_REG_SUPPORT 1

#elif MSM_API_DRIVER_CODE

#define MSM_USER_REG_SUPPORT 0

#if !M_MIL_USE_PHARLAP
#ifdef __cplusplus
extern "C"
{
#endif

#include <ntddk.h>
#include <ntstrsafe.h>

#ifdef __cplusplus
}
#endif
#else //M_MIL_USE_PHARLAP
#include "plddk.h"
#endif //!M_MIL_USE_PHARLAP

#endif

#elif MSM_API_USE_LINUX

#define MSM_USER_REG_SUPPORT 0

#if MSM_API_USER_CODE
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <errno.h>

#elif MSM_API_DRIVER_CODE
#define offsetof(Type, Member) __builtin_offsetof(Type, Member)
#include "linux-interface.h"

#endif

#else

#define MSM_USER_REG_SUPPORT 0

#error "No Operating system specified"

#endif

// internal data structures
typedef struct _MSM_API_INTERNAL_HANDLE
{
#if MSM_API_USE_WINDOWS

#if MSM_API_USER_CODE

   HANDLE   DriverHandle;

#elif MSM_API_DRIVER_CODE

   PFILE_OBJECT   FileObject;
   PDEVICE_OBJECT DeviceObject;

#endif   // MSM_API_YYY_CODE

#elif MSM_API_USE_LINUX

   int   DriverHandle;

#if MSM_API_USER_CODE

#elif MSM_API_DRIVER_CODE

#endif   // MSM_API_YYY_CODE
#endif   // MSM_API_USE_ZZZ

   MSM_UINT32     NumOfPCIItem;
   MSM_PCI_ITEM   *PCIArray;
} MSM_API_INTERNAL_HANDLE;

// internal functions

static void* MSMAllocMemory(MSM_SIZE size, MSM_BOOL ZeroMemory);
static void  MSMFreeMemory(void *ptr);
static MSM_STATUS MSMDrvIoCtl(MSM_API_INTERNAL_HANDLE *drvHandle, MSM_UINT32 iocode, void* dataIn, MSM_UINT32 sizeIn, void*dataOut, MSM_UINT32 sizeOut);
static void MSMInternalMemcpy(void *DstPtr, void* SrcPtr, MSM_SIZE Length);
static MSM_STATUS MSMFetchPCIData(MSM_API_INTERNAL_HANDLE *drvHandle);

#if MSM_API_USE_WINDOWS && MSM_API_USER_CODE // For now, will bring it to the other OS/mode later
static MSM_IOCTL_REGISTRY* MSMAllocControlRegistry(MSM_UINT64 Opcode, MSM_REGHANDLE RegHandle, MSM_UINT64 Mode, MSM_REGTYPE RegType, const MSM_CHAR* Name, MSM_SIZE DataSize, void *Data, MSM_BOOL CopyData, MSM_UINT32 *RegSize);
static MSM_SIZE MSMStrLength(const MSM_CHAR* Name);
#endif // MSM_API_USE_WINDOWS && MSM_API_USER_CODE

#if MSM_API_USE_WINDOWS && MSM_API_USER_CODE
static void MSMInternalStrcpy(char *DstStr, MSM_SIZE DstLength, char* SrcStr);
#endif

// internal macro

///////////////////////////////////////////////////////////////////
//
// The API functions
//
///////////////////////////////////////////////////////////////////

//--------------------------------------------------------------
//
// Name:          MSMAttach
//
// Description:   create a connection to the mtxservmanager driver
//
// Parameters:    MSMHandle: pointer to the device handle
//
// Return:        the status of the function
//
// Notes:
//
//--------------------------------------------------------------
MSM_STATUS MSMAttach(PMSM_HANDLE opMSMHandle)
{
   MSM_API_INTERNAL_HANDLE *internalHandle = MSM_NULL;
   MSM_BOOL HandleCreated = false;
   *opMSMHandle = MSM_NULL;  // set the HANDLE to MSM_NULL so to catch any problem

   internalHandle = (MSM_API_INTERNAL_HANDLE*)MSMAllocMemory(sizeof(MSM_API_INTERNAL_HANDLE), true);

   // check if we have allocated the structure
   if(internalHandle == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_CANNOT_CREATE_HANDLE, MSM_DETAIL_OUT_OF_MEMORY);
   }

   // now connect to the driver
   // this step is unique per OS

#if MSM_API_USER_CODE && MSM_API_USE_WINDOWS
   internalHandle->DriverHandle = CreateFileA( MSM_USER_NAME, GENERIC_READ | GENERIC_WRITE, 0,
      MSM_NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL | FILE_FLAG_OVERLAPPED, MSM_NULL);

   if(internalHandle->DriverHandle != INVALID_HANDLE_VALUE)
   {
      HandleCreated = true;
   }
#endif

#if MSM_API_USER_CODE && MSM_API_USE_LINUX
   internalHandle->DriverHandle = TEMP_FAILURE_RETRY(open(MSM_USER_NAME, O_RDWR));

   if(internalHandle->DriverHandle != -1)
   {
      HandleCreated = true;
   }
#endif

#if MSM_API_DRIVER_CODE && MSM_API_USE_WINDOWS
   NTSTATUS        Status;

   UNICODE_STRING DeviceName;
   RtlInitUnicodeString(&DeviceName,MSM_KERNEL_NAME);

   // Try to establish link with Dma Driver.
   Status = IoGetDeviceObjectPointer(&DeviceName, FILE_ALL_ACCESS, &internalHandle->FileObject, &internalHandle->DeviceObject);

   if(NT_SUCCESS(Status))
   {
      HandleCreated = true;
   }
#endif

#if MSM_API_DRIVER_CODE && MSM_API_USE_LINUX
   HandleCreated = true;
   // we do not open the driver as we have access to it's function
#endif

   // we now check if the handle was created and exit the function
   if(!HandleCreated)
   {
      MSMFreeMemory(internalHandle);
      return MSM_STATUS_CREATE(MSM_ERROR_CANNOT_CREATE_HANDLE,MSM_DETAIL_CANNOT_OPEN_DRIVER);
   }

   *opMSMHandle = (MSM_HANDLE)internalHandle;

   // get the PCI array
   MSMFetchPCIData(internalHandle);
   
   return MSM_STATUS_SUCCESS;
}

//--------------------------------------------------------------
//
// Name:    MSMDetach
//
// Description: this function will close the connection to the driver
//              and free the previously allocated memory
//
// Parameters: iMSMHandle: the handle to the driver
//
// Return:  the status of the function
//
// Notes:
//
//--------------------------------------------------------------
MSM_STATUS MSMDetach(MSM_HANDLE iMSMHandle)
{
   MSM_API_INTERNAL_HANDLE *internalHandle = (MSM_API_INTERNAL_HANDLE*)iMSMHandle;
   if(iMSMHandle == MSM_NULL)
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_HANDLE, MSM_DETAIL_DRIVER_HANDLE);

#if MSM_API_USER_CODE && MSM_API_USE_WINDOWS
   CloseHandle(internalHandle->DriverHandle);
#endif

#if MSM_API_USER_CODE && MSM_API_USE_LINUX
   close(internalHandle->DriverHandle);
#endif

#if MSM_API_DRIVER_CODE && MSM_API_USE_WINDOWS
   ObDereferenceObject(internalHandle->FileObject);
#endif

#if MSM_API_DRIVER_CODE && MSM_API_USE_LINUX
   // we do not close the driver as we have access to it's function
#endif

   if(internalHandle->PCIArray != MSM_NULL)
   {
      MSMFreeMemory(internalHandle->PCIArray);
   }
   MSMFreeMemory(iMSMHandle);

   return MSM_STATUS_SUCCESS;
}

//--------------------------------------------------------------
//
// Name:    MSMReadConfig
//
// Description: this function will read from 1 to 64
//              PCI configuration space 32 bits entry
//
// Parameters: iMSMHandle: the handle to the device driver
//             iBusNb:  the bus number where the device is located
//             iDevNb:  the device number where the device is located
//             iFuncNb: the function number of the device
//             iRegNb:  the offset of the register to read
//             iNumRegToRead: the amount of data to read
//             opReadData: storage location for the data
//
// Return:  the status of the function
//
// Notes:
//
//--------------------------------------------------------------
MSM_STATUS MSMReadConfig(MSM_HANDLE iMSMHandle, MSM_UINT8 iBusNb, MSM_UINT8 iDevNb, MSM_UINT8 iFuncNb, MSM_UINT8 iRegNb, MSM_UINT8 iNumRegToRead, MSM_UINT32* opReadData)
{
   MSM_API_INTERNAL_HANDLE *internalHandle = (MSM_API_INTERNAL_HANDLE*)iMSMHandle;
   MSM_STATUS              IOStatus = MSM_STATUS_SUCCESS;
   MSM_IOCTL_CONFIG_ACCESS configAccess;
#if MSM_API_USER_CODE && MSM_API_USE_LINUX
   memset(&configAccess, 0, sizeof(MSM_IOCTL_CONFIG_ACCESS));
#endif   

   if(iMSMHandle == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_HANDLE, MSM_DETAIL_DRIVER_HANDLE);
   }

   if(opReadData == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NULL_DATA_POINTER);
   }

   if(iRegNb & 0x3)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NON_4_MULT_REG_NB);
   }

   if(iNumRegToRead > 64)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_TOO_MANY_REGISTERS);
   }

   if(( (iRegNb >> 2) + iNumRegToRead) > 64)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_OUT_OF_BOUND);
   }

   configAccess.BusNb = iBusNb;
   configAccess.DevNb = iDevNb;
   configAccess.FuncNb = iFuncNb;
   configAccess.NumOfReg = iNumRegToRead;
   configAccess.RegNb = iRegNb;

   IOStatus = MSMDrvIoCtl(internalHandle, MSM_CONTROL_READ_CONFIG, &configAccess, sizeof(configAccess), &configAccess, sizeof(configAccess));

   // check if the IO control has succeeded
   if(IOStatus != MSM_STATUS_SUCCESS)
   {
      return IOStatus;
   }

   MSMInternalMemcpy(opReadData, configAccess.Data, sizeof(MSM_UINT32) * iNumRegToRead);

   return configAccess.IOStatus;
}

//--------------------------------------------------------------
//
// Name: MSMWriteConfig
//
// Description: this function will write a 32 bit register
//              in the PCI configuration space of the desired device
//
// Parameters: iMSMHandle: handle to the device driver
//             iBusNb: bus number of the device
//             iDevNb: device number of the device
//             iFuncNb: function number of the device
//             iRegNb: index of the location to write to
//             iWriteData: the data to write in the PCI configuration space
//
// Return:  the status of the function
//
// Notes:
//
//--------------------------------------------------------------
MSM_STATUS MSMWriteConfig(MSM_HANDLE iMSMHandle, MSM_UINT8 iBusNb,MSM_UINT8 iDevNb, MSM_UINT8 iFuncNb, MSM_UINT8 iRegNb, MSM_UINT8 iNumRegToWrite, MSM_UINT32* ipWriteData)
{
   MSM_API_INTERNAL_HANDLE *internalHandle = (MSM_API_INTERNAL_HANDLE*)iMSMHandle;
   MSM_STATUS              IOStatus = MSM_STATUS_SUCCESS;
   MSM_IOCTL_CONFIG_ACCESS configAccess;


   if(iMSMHandle == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_HANDLE, MSM_DETAIL_DRIVER_HANDLE);
   }

   if(iRegNb & 0x3)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NON_4_MULT_REG_NB);
   }

   if(iNumRegToWrite > 64)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_TOO_MANY_REGISTERS);
   }

   if(( (iRegNb >> 2) + iNumRegToWrite) > 64)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_OUT_OF_BOUND);
   }

   if(ipWriteData == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NULL_DATA_POINTER);
   }

   configAccess.BusNb = iBusNb;
   configAccess.DevNb = iDevNb;
   configAccess.FuncNb = iFuncNb;
   configAccess.NumOfReg = 1;
   configAccess.RegNb = iRegNb;
   configAccess.NumOfReg = iNumRegToWrite;

   MSMInternalMemcpy(configAccess.Data, ipWriteData, sizeof(MSM_UINT32) * iNumRegToWrite);

   IOStatus = MSMDrvIoCtl(internalHandle, MSM_CONTROL_WRITE_CONFIG, &configAccess, sizeof(configAccess), &configAccess, sizeof(configAccess));

   // check if the IO control has succeeded
   if(IOStatus != MSM_STATUS_SUCCESS)
   {
      return IOStatus;
   }

   return configAccess.IOStatus;
}

//--------------------------------------------------------------
//
// Name: MSMFindDevice
//
// Description: this function will search for a specific device
//              and return it's location
//
// Parameters: iMSMHandle: handle to the device driver
//             iVendorId: the PCI vendor ID of the device we are looking for
//             iDeviceId: the PCI device ID
//             iopBusNb: the starting bus number in input and the found location in output
//             iopDevNb: the starting device number in input and the found location in output
//             iopFuncNb: the starting function number in input and the found location in output
//             iIndex: the number of device to skip (0 to return the first)
//
// Return:  the status of the function
//
// Notes:
//
//--------------------------------------------------------------
MSM_STATUS MSMFindDevice(MSM_HANDLE iMSMHandle, MSM_UINT16 iVendorId, MSM_UINT16 iDeviceId, MSM_UINT8* iopBusNb, MSM_UINT8* iopDevNb, MSM_UINT8* iopFuncNb, MSM_UINT32 iIndex)
{
   MSM_API_INTERNAL_HANDLE *internalHandle = (MSM_API_INTERNAL_HANDLE*)iMSMHandle;
   MSM_STATUS              IOStatus = MSM_STATUS_SUCCESS;

   if(iMSMHandle == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_HANDLE, MSM_DETAIL_DRIVER_HANDLE);
   }

   if(iopBusNb == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NULL_BUS_NUMBER);
   }

   if(iopDevNb == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NULL_DEVICE_NUMBER);
   }

   if(iopFuncNb == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NULL_FUNCTION_NUMBER);
   }

   // fall back case when we do not have the PCI array
   // we could also have a method to bypass the PCI device cache
   if(internalHandle->NumOfPCIItem == 0)
   {
      MSM_IOCTL_FIND_DEVICE   findDevice;
      findDevice.BusNb = *iopBusNb;
      findDevice.DevNb = *iopDevNb;
      findDevice.FuncNb = *iopFuncNb;
      findDevice.Index = iIndex;
      findDevice.DeviceId = iDeviceId;
      findDevice.VendorId = iVendorId;

      IOStatus = MSMDrvIoCtl(internalHandle, MSM_CONTROL_FIND_DEVICE, &findDevice, sizeof(findDevice), &findDevice, sizeof(findDevice));

      // check if the IO control has succeeded
      if(IOStatus != MSM_STATUS_SUCCESS)
      {
         return IOStatus;
      }

      if(findDevice.Found == MSM_FIND_DEVICE_FOUND)
      {
         *iopBusNb = findDevice.BusNb;
         *iopDevNb = findDevice.DevNb;
         *iopFuncNb = findDevice.FuncNb;
      }

      return findDevice.IOStatus;
   }

   return MSMFindDeviceEx(iMSMHandle, iVendorId, iDeviceId, MSM_ALL_ID, MSM_ALL_ID, iopBusNb, iopDevNb, iopFuncNb, iIndex);
}

//--------------------------------------------------------------
//
// Name: MSMFindDeviceEx
//
// Description: this function will search for a specific device
//              and return it's location
//
// Parameters: iMSMHandle: handle to the device driver
//             iVendorId: the PCI vendor ID of the device we are looking for
//             iDeviceId: the PCI device ID
//             iSubSystemId: the subsystem ID of the device
//             iSubVendorId:  the sub vendor ID of the device
//             iopBusNb: the starting bus number in input and the found location in output
//             iopDevNb: the starting device number in input and the found location in output
//             iopFuncNb: the starting function number in input and the found location in output
//             iIndex: the number of device to skip (0 to return the first)
//
// Return:  the status of the function
//
// Notes:
//
//--------------------------------------------------------------
MSM_STATUS MSMFindDeviceEx(MSM_HANDLE iMSMHandle, MSM_UINT16 iVendorId, MSM_UINT16 iDeviceId, MSM_UINT16 iSubSystemId, MSM_UINT16 iSubVendorId, MSM_UINT8* iopBusNb, MSM_UINT8* iopDevNb, MSM_UINT8* iopFuncNb, MSM_UINT32 iIndex)
{
   MSM_API_INTERNAL_HANDLE *internalHandle = (MSM_API_INTERNAL_HANDLE*)iMSMHandle;
   MSM_STATUS              IOStatus = MSM_STATUS_SUCCESS;
   MSM_UINT32              curIndex = 0;
   MSM_PCI_ITEM           *curPci = MSM_NULL;
   MSM_BOOL                foundDevice = false;
   MSM_UINT32              nbDevFound = 0;

   if(iMSMHandle == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_HANDLE, MSM_DETAIL_DRIVER_HANDLE);
   }

   if(iopBusNb == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NULL_BUS_NUMBER);
   }

   if(iopDevNb == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NULL_DEVICE_NUMBER);
   }

   if(iopFuncNb == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NULL_FUNCTION_NUMBER);
   }

   // fallback case when we do not have the PCI array
   // we could also have a method to bypass the PCI device cache
   if(internalHandle->PCIArray == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_HANDLE, MSM_DETAIL_NULL_DATA_POINTER);
   }

   curPci = internalHandle->PCIArray;

   // check the validity of the starting PCI location
   if(*iopFuncNb >=  MSM_MAX_FUNC)
   {
      *iopDevNb = *iopDevNb + 1;
      *iopFuncNb = 0;
   }

   if(*iopDevNb >=  MSM_MAX_DEV)
   {
      if(*iopBusNb == MSM_MAX_BUS)
      {
         return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_OUT_OF_BOUND);
      }

      *iopBusNb = *iopBusNb + 1;
      *iopDevNb = 0;
      
   }

   // find the first device
   while((curIndex < internalHandle->NumOfPCIItem) && !foundDevice)
   {
      if(((curPci->BusNb == *iopBusNb) && (curPci->DevNb == *iopDevNb) && (curPci->FuncNb == *iopFuncNb)) ||(curPci->BusNb > *iopBusNb) || ((curPci->BusNb == *iopBusNb) && (curPci->DevNb > *iopDevNb)) || ((curPci->BusNb == *iopBusNb) && (curPci->DevNb == *iopDevNb) && (curPci->FuncNb > *iopFuncNb)))
      {
         foundDevice = true;
      }
      else
      {
         curIndex++;
         curPci++;
      }
   }

   // reset the found device
   foundDevice = false;

   while((curIndex < internalHandle->NumOfPCIItem) && !foundDevice)
   {
      if((curPci->VendorId == iVendorId) && (curPci->DeviceId == iDeviceId))
      {
         if( ((iSubSystemId ==  MSM_ALL_ID) || (iSubSystemId == curPci->SubSystemId)) &&
            ((iSubVendorId  ==  MSM_ALL_ID) || (iSubVendorId == curPci->SubVendorId)))
         {
            if(nbDevFound == iIndex)
            {
               foundDevice = true;
               *iopBusNb  = curPci->BusNb;
               *iopDevNb  = curPci->DevNb;
               *iopFuncNb = curPci->FuncNb;
            }
            else
            {
               nbDevFound++;
            }
         }
      }

      if(!foundDevice)
      {
         curIndex++;
         curPci++;
      }
   }

   if(!foundDevice)
      IOStatus = MSM_STATUS_NO_DEVICE;

   return IOStatus;
}

//--------------------------------------------------------------
//
// Name: MSMGetPciDeviceArray
//
// Description: this function will return the number of PCI 
//              devices in the system and a pointer to the array
//
// Parameters: iMSMHandle: handle to the device driver
//
// Return:  the status of the function
//
// Notes:
//
//--------------------------------------------------------------
MSM_STATUS MSMGetPciDeviceArray(MSM_HANDLE iMSMHandle, MSM_UINT32 *opNumDevice, MSM_PCI_ITEM **opPCIArray)
{
   MSM_API_INTERNAL_HANDLE *internalHandle = (MSM_API_INTERNAL_HANDLE*)iMSMHandle;

   if(iMSMHandle == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_HANDLE, MSM_DETAIL_DRIVER_HANDLE);
   }

   if(opNumDevice != MSM_NULL)
      *opNumDevice = internalHandle->NumOfPCIItem;

   if(opPCIArray != MSM_NULL)
      *opPCIArray = internalHandle->PCIArray;

   return MSM_STATUS_SUCCESS;
}

//--------------------------------------------------------------
//
// Name: MSMRescanPCI
//
// Description: this function will update the driver list of PCI devices
//
// Parameters: iMSMHandle: handle to the device driver
//
// Return:  the status of the function
//
// Notes:
//
//--------------------------------------------------------------
MSM_STATUS MSMRescanPCI(MSM_HANDLE iMSMHandle)
{
   MSM_API_INTERNAL_HANDLE *internalHandle = (MSM_API_INTERNAL_HANDLE*)iMSMHandle;
   MSM_STATUS              IOStatus = MSM_STATUS_SUCCESS;
   MSM_IOCTL_RESCAN_PCI    rescanPCI;

   if(iMSMHandle == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_HANDLE, MSM_DETAIL_DRIVER_HANDLE);
   }


   IOStatus = MSMDrvIoCtl(internalHandle, MSM_CONTROL_RESCAN_PCI, &rescanPCI, sizeof(rescanPCI), &rescanPCI, sizeof(rescanPCI));

   // check if the IO control has succeeded
   if(IOStatus != MSM_STATUS_SUCCESS)
   {
      return IOStatus;
   }

   // now fetch the PCI list
   return MSMFetchPCIData(internalHandle);
   
}

//--------------------------------------------------------------
//
// Name: MSMGetBarSize
//
// Description: this function will return the BAR size requested
//
// Parameters: iMSMHandle: handle to the device driver
//             iBusNb: bus number of the desired device
//             iDevNb: device number of the desired device
//             iFuncNb: function number of the desired device
//             iRegNb: the offset in the configuration space of the BAR
//             opBarSize: pointer to store the size of the BAR
//
// Return:  the status of the function
//
// Notes:
//
//--------------------------------------------------------------
MSM_STATUS MSMGetBarSize(MSM_HANDLE iMSMHandle, MSM_UINT8 iBusNb, MSM_UINT8 iDevNb, MSM_UINT8 iFuncNb, MSM_UINT8 iRegNb, MSM_UINT64 * opBarSize)
{
   MSM_API_INTERNAL_HANDLE *internalHandle = (MSM_API_INTERNAL_HANDLE*)iMSMHandle;
   MSM_STATUS              IOStatus = MSM_STATUS_SUCCESS;
   MSM_IOCTL_GETSIZE       getSize;

   if(iMSMHandle == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_HANDLE, MSM_DETAIL_DRIVER_HANDLE);
   }

   if(opBarSize == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NULL_BAR_SIZE);
   }

   if(iRegNb & 0x3)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NON_4_MULT_REG_NB);
   }


   getSize.BusNb = iBusNb;
   getSize.DevNb = iDevNb;
   getSize.FuncNb = iFuncNb;
   getSize.RegNb = iRegNb;
   getSize.Size = 0;


   IOStatus = MSMDrvIoCtl(internalHandle, MSM_CONTROL_GET_SIZE, &getSize, sizeof(getSize), &getSize, sizeof(getSize));

   // check if the IO control has succeeded
   if(IOStatus != MSM_STATUS_SUCCESS)
   {
      return IOStatus;
   }

   *opBarSize = getSize.Size;

   return getSize.IOStatus;
}

//--------------------------------------------------------------
//
// Name: MSMGetBarSizeFromRegistry
//
// Description: this function will fetch the BAR size and address
//              from the Windows registry
//
// Parameters: iMSMHandle: handle to the device driver
//             ipName: the name of the device to inquire
//             opBarAddress: array of BAR address
//             opBarSize: array of BAR size
//
// Return:  the status of the function
//
// Notes:
//
//--------------------------------------------------------------
MSM_STATUS MSMGetBarSizeFromRegistry(MSM_HANDLE iMSMHandle, char* ipName, MSM_UINT64 ipBarAddress[6], MSM_UINT64 opBarSize[6])
{
#if MSM_API_USE_WINDOWS && MSM_API_USER_CODE
   MSM_API_INTERNAL_HANDLE *internalHandle = (MSM_API_INTERNAL_HANDLE*)iMSMHandle;
   MSM_STATUS              IOStatus = MSM_STATUS_SUCCESS;
   MSM_IOCTL_GET_SIZE_REG  getSizeReg;

   if(iMSMHandle == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_HANDLE, MSM_DETAIL_DRIVER_HANDLE);
   }

   if(ipName == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NULL_NAME);
   }

   if(ipBarAddress == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NULL_BAR_ADDRESS);
   }

   if(opBarSize == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NULL_BAR_SIZE);
   }

   if(strlen(ipName) > MSM_GET_SIZE_REG_NAME_LENGTH)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NAME_TOO_LONG);
   }

   MSMInternalStrcpy(getSizeReg.RegName, MSM_GET_SIZE_REG_NAME_LENGTH, ipName);
   MSMInternalMemcpy(getSizeReg.BarAddress, ipBarAddress, sizeof(getSizeReg.BarAddress));
   MSMInternalMemcpy(getSizeReg.BarSize, opBarSize, sizeof(getSizeReg.BarSize));

   IOStatus = MSMDrvIoCtl(internalHandle, MSM_CONTROL_GET_SIZE_REG, &getSizeReg, sizeof(getSizeReg), &getSizeReg, sizeof(getSizeReg));

   // check if the IO control has succeeded
   if(IOStatus != MSM_STATUS_SUCCESS)
   {
      memset(getSizeReg.BarSize, 0, sizeof(getSizeReg.BarSize));
      return IOStatus;
   }

   MSMInternalMemcpy(opBarSize, getSizeReg.BarSize, sizeof(getSizeReg.BarSize));


   return getSizeReg.IOStatus;
#else
   MSM_UNUSED_ARG(opBarSize);
   MSM_UNUSED_ARG(ipBarAddress);
   MSM_UNUSED_ARG(ipName);
   MSM_UNUSED_ARG(iMSMHandle);
   return MSM_STATUS_CREATE(MSM_ERROR_OS_ERROR, MSM_DETAIL_NOT_SUPPORTED);
#endif
}

//--------------------------------------------------------------
//
// Name: MSMGetLicensesMask
//
// Description: get the mask for the license
//
// Parameters: iMSMHandle: the handle to the device driver
//             opMask: pointer to where to store the mask
//             DevMaskType* DevicesMasks: Devices masks
//
// Return:  the status of the function
//
// Notes:
//
//--------------------------------------------------------------
//MSM_STATUS MSMGetLicensesMask(MSM_HANDLE iMSMHandle, TLicenser *opMask, DevMaskType* DevicesMasks)
//{
//   MSM_API_INTERNAL_HANDLE    *internalHandle = (MSM_API_INTERNAL_HANDLE*)iMSMHandle;
//   MSM_STATUS                 IOStatus = MSM_STATUS_SUCCESS;
//   MSM_IOCTL_GET_LICENSES_MASK licensesMask;
//
//   if(iMSMHandle == MSM_NULL)
//      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_HANDLE, MSM_DETAIL_DRIVER_HANDLE);
//
//   if(opMask == MSM_NULL)
//      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NULL_LICENSE_MASK);
//
//   IOStatus = MSMDrvIoCtl(internalHandle, MSM_CONTROL_GET_LICENSES_MASK, &licensesMask, sizeof(licensesMask), &licensesMask, sizeof(licensesMask));
//
//   // check if the IO control has succeeded
//   if(IOStatus != MSM_STATUS_SUCCESS)
//   {
//      return IOStatus;
//   }
//
//   *opMask = licensesMask.Mask;
//
//   for(int b = 0; b < MAX_NUMBER_OF_EEPROM; b++)
//      {
//      (*DevicesMasks)[b] = licensesMask.DevicesMask[b];
//      }
//
//   return licensesMask.IOStatus;
//}


//--------------------------------------------------------------
//
// Name: MSMGetLicenseInfo
//
// Description: this function will return the license information
//              for a specific board type
//
// Parameters: iMSMHandle: handle to the device driver
//             iopLicenseInfo: pointer to where to store the license
//
// Return:  the status of the function
//
// Notes:
//
//--------------------------------------------------------------
//MSM_STATUS MSMGetLicenseInfo(MSM_HANDLE iMSMHandle, MTXSER_LICENSE_INFO *iopLicenseInfo)
//{
//   MSM_API_INTERNAL_HANDLE *internalHandle = (MSM_API_INTERNAL_HANDLE*)iMSMHandle;
//   MSM_STATUS              IOStatus = MSM_STATUS_SUCCESS;
//   MSM_IOCTL_LICENSE_INFO  licenseInfo;
//
//   if(iMSMHandle == MSM_NULL)
//   {
//      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_HANDLE, MSM_DETAIL_DRIVER_HANDLE);
//   }
//
//   if(iopLicenseInfo == MSM_NULL)
//   {
//      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NULL_LICENSE_INFO);
//   }
//
//   MSMInternalMemcpy(&licenseInfo.LicenseInfo, iopLicenseInfo, sizeof(MTXSER_LICENSE_INFO));
//
//   IOStatus = MSMDrvIoCtl(internalHandle, MSM_CONTROL_GET_LICENSE, &licenseInfo, sizeof(licenseInfo), &licenseInfo, sizeof(licenseInfo));
//
//   // check if the IO control has succeeded
//   if(IOStatus != MSM_STATUS_SUCCESS)
//   {
//      return IOStatus;
//   }
//
//   MSMInternalMemcpy(iopLicenseInfo, &licenseInfo.LicenseInfo, sizeof(MTXSER_LICENSE_INFO));
//
//   return licenseInfo.IOStatus;
//}

//--------------------------------------------------------------
//
// Name: MSMGetPrivateData
//
// Description: this function will return private data from the driver
//
// Parameters: iMSMHandle: handle to the device driver
//             iDataID: ID of the private data to fetch
//             iLength: size of the array that will contain the fetched data
//             opDataPtr: storage space for the data
//             iFlags: flags for the function
//             opDataLength: size of the data element in the driver
//
// Return:  the status of the function
//
// Notes:
//
//--------------------------------------------------------------
//MSM_STATUS MSMGetPrivateData(MSM_HANDLE iMSMHandle, MSM_UINT32 iDataID, MSM_SIZE iLength, void* opDataPtr, MSM_UINT64 iFlags, MSM_SIZE *opDataLength)
//{
//   MSM_API_INTERNAL_HANDLE *internalHandle = (MSM_API_INTERNAL_HANDLE*)iMSMHandle;
//   MSM_STATUS              IOStatus = MSM_STATUS_SUCCESS;
//   MSM_IOCTL_PRIVATE_DATA   *pDevInfo = MSM_NULL;
//   MSM_UINT32 structSize = (MSM_UINT32)iLength + offsetof(MSM_IOCTL_PRIVATE_DATA, Data);
//
//   if(iMSMHandle == MSM_NULL)
//   {
//      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_HANDLE, MSM_DETAIL_DRIVER_HANDLE);
//   }
//
//   if(opDataPtr == MSM_NULL)
//   {
//      // if the data pointer is NULL, we put the length to 0 and return the length of the data element
//      iLength = 0;
//   }
//
//   pDevInfo = (MSM_IOCTL_PRIVATE_DATA*)MSMAllocMemory(structSize, true);
//
//
//   if(pDevInfo == MSM_NULL)
//   {
//      return MSM_STATUS_CREATE(MSM_ERROR_OUT_OF_MEMORY, MSM_DETAIL_OUT_OF_MEMORY);
//   }
//
//   pDevInfo->DataID = iDataID;
//   pDevInfo->Flags  = iFlags;
//   pDevInfo->Length = iLength;
//
//   IOStatus = MSMDrvIoCtl(internalHandle, MSM_CONTROL_GET_DEV_INFO, pDevInfo, structSize, pDevInfo, structSize);
//
//   // check if the IO control has succeeded
//   if(IOStatus != MSM_STATUS_SUCCESS)
//   {
//      MSMFreeMemory(pDevInfo);
//      return IOStatus;
//   }
//
//   if((opDataPtr != MSM_NULL) && (pDevInfo->Length > 0))
//      MSMInternalMemcpy(opDataPtr, pDevInfo->Data, (MSM_SIZE)MSM_MIN(iLength, pDevInfo->Length));
//
//   if(opDataLength != MSM_NULL)
//      *opDataLength = (MSM_SIZE)pDevInfo->Length;
//
//   MSM_STATUS RetStatus = pDevInfo->IOStatus;
//   MSMFreeMemory(pDevInfo);
//   return RetStatus;
//}

//--------------------------------------------------------------
//
// Name: MSMAddLicenseInfo
//
// Description: this function will add a license to the driver
//
// Parameters: iMSMHandle: handle to the device driver
//             ipLicenseInfo: pointer to the license to add
//
// Return:  the status of the function
//
// Notes:
//
//--------------------------------------------------------------
//MSM_STATUS MSMAddLicenseInfo(MSM_HANDLE iMSMHandle, MTXSER_LICENSE_INFO *ipLicenseInfo)
//{
//   MSM_API_INTERNAL_HANDLE *internalHandle = (MSM_API_INTERNAL_HANDLE*)iMSMHandle;
//   MSM_STATUS              IOStatus = MSM_STATUS_SUCCESS;
//   MSM_IOCTL_LICENSE_INFO  licenseInfo;
//
//   if(iMSMHandle == MSM_NULL)
//   {
//      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_HANDLE, MSM_DETAIL_DRIVER_HANDLE);
//   }
//
//   if(ipLicenseInfo == MSM_NULL)
//   {
//      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NULL_LICENSE_INFO);
//   }
//
//   MSMInternalMemcpy(&licenseInfo.LicenseInfo, ipLicenseInfo, sizeof(MTXSER_LICENSE_INFO));
//
//#if !defined(_MSC_VER) || (_MSC_VER >= 1600) // so the old WDK can build it
//   static_assert(sizeof(MSM_IOCTL_LICENSE_INFO) == 336, "unexpected size");
//#endif
//   IOStatus = MSMDrvIoCtl(internalHandle, MSM_CONTROL_ADD_LICENSE, &licenseInfo, sizeof(licenseInfo), &licenseInfo, sizeof(licenseInfo));
//
//   // check if the IO control has succeeded
//   if(IOStatus != MSM_STATUS_SUCCESS)
//   {
//      return IOStatus;
//   }
//
//   return licenseInfo.IOStatus;
//}

//--------------------------------------------------------------
//
// Name: MSMIORead8
//
// Description: this function will read 8 bits of data from an IO port
//
// Parameters: iMSMHandle: handle to the device driver
//             iAddress: the IO port address
//             opData: pointer to receive the read result
//
// Return:  the status of the function
//
// Notes:
//
//--------------------------------------------------------------
MSM_STATUS MSMIORead8(MSM_HANDLE iMSMHandle, MSM_UINT32 iAddress, MSM_UINT8 *opData)
{
   MSM_API_INTERNAL_HANDLE *internalHandle = (MSM_API_INTERNAL_HANDLE*)iMSMHandle;
   MSM_STATUS              IOStatus = MSM_STATUS_SUCCESS;
   MSM_IOCTL_IO_OPERATION  IOOperation = {0};

   if(iMSMHandle == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_HANDLE, MSM_DETAIL_DRIVER_HANDLE);
   }

   if(opData == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NULL_DATA_POINTER);
   }

   IOOperation.IOAddress = iAddress;
   IOOperation.Mode = MSM_IO_OP_READ_BYTE;

   IOStatus = MSMDrvIoCtl(internalHandle, MSM_CONTROL_IO_ACCESS, &IOOperation, sizeof(IOOperation), &IOOperation, sizeof(IOOperation));

   // check if the IO control has succeeded
   if(IOStatus != MSM_STATUS_SUCCESS)
   {
      return IOStatus;
   }

   *opData = (MSM_UINT8)IOOperation.IOData;

   return IOOperation.IOStatus;
}

//--------------------------------------------------------------
//
// Name: MSMIOWrite8
//
// Description: this function will read 8 bits of data to an IO port
//
// Parameters: iMSMHandle: handle to the device driver
//             iAddress: the IO port address
//             opData: data to write
//
// Return:  the status of the function
//
// Notes:
//
//--------------------------------------------------------------
MSM_STATUS MSMIOWrite8(MSM_HANDLE iMSMHandle, MSM_UINT32 iAddress, MSM_UINT8 iData)
{
   MSM_API_INTERNAL_HANDLE *internalHandle = (MSM_API_INTERNAL_HANDLE*)iMSMHandle;
   MSM_STATUS              IOStatus = MSM_STATUS_SUCCESS;
   MSM_IOCTL_IO_OPERATION  IOOperation = {0};

   if(iMSMHandle == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_HANDLE, MSM_DETAIL_DRIVER_HANDLE);
   }


   IOOperation.IOAddress = iAddress;
   IOOperation.Mode = MSM_IO_OP_WRITE_BYTE;
   IOOperation.IOData = iData;

   IOStatus = MSMDrvIoCtl(internalHandle, MSM_CONTROL_IO_ACCESS, &IOOperation, sizeof(IOOperation), &IOOperation, sizeof(IOOperation));

   // check if the IO control has succeeded
   if(IOStatus != MSM_STATUS_SUCCESS)
   {
      return IOStatus;
   }

   return IOOperation.IOStatus;
}

//--------------------------------------------------------------
//
// Name: MSMIORead16
//
// Description: this function will read 16 bits of data from an IO port
//
// Parameters: iMSMHandle: handle to the device driver
//             iAddress: the IO port address
//             opData: pointer to receive the read result
//
// Return:  the status of the function
//
// Notes:
//
//--------------------------------------------------------------
MSM_STATUS MSMIORead16(MSM_HANDLE iMSMHandle, MSM_UINT32 iAddress, MSM_UINT16 *opData)
{
   MSM_API_INTERNAL_HANDLE *internalHandle = (MSM_API_INTERNAL_HANDLE*)iMSMHandle;
   MSM_STATUS              IOStatus = MSM_STATUS_SUCCESS;
   MSM_IOCTL_IO_OPERATION  IOOperation = {0};

   if(iMSMHandle == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_HANDLE, MSM_DETAIL_DRIVER_HANDLE);
   }

   if(opData == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NULL_DATA_POINTER);
   }

   IOOperation.IOAddress = iAddress;
   IOOperation.Mode = MSM_IO_OP_READ_WORD;

   IOStatus = MSMDrvIoCtl(internalHandle, MSM_CONTROL_IO_ACCESS, &IOOperation, sizeof(IOOperation), &IOOperation, sizeof(IOOperation));

   // check if the IO control has succeeded
   if(IOStatus != MSM_STATUS_SUCCESS)
   {
      return IOStatus;
   }

   *opData = (MSM_UINT16)IOOperation.IOData;

   return IOOperation.IOStatus;
}


//--------------------------------------------------------------
//
// Name: MSMIOWrite16
//
// Description: this function will read 16 bits of data to an IO port
//
// Parameters: iMSMHandle: handle to the device driver
//             iAddress: the IO port address
//             opData: data to write
//
// Return:  the status of the function
//
// Notes:
//
//--------------------------------------------------------------
MSM_STATUS MSMIOWrite16(MSM_HANDLE iMSMHandle, MSM_UINT32 iAddress, MSM_UINT16 iData)\
{
   MSM_API_INTERNAL_HANDLE *internalHandle = (MSM_API_INTERNAL_HANDLE*)iMSMHandle;
   MSM_STATUS              IOStatus = MSM_STATUS_SUCCESS;
   MSM_IOCTL_IO_OPERATION  IOOperation = {0};

   if(iMSMHandle == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_HANDLE, MSM_DETAIL_DRIVER_HANDLE);
   }


   IOOperation.IOAddress = iAddress;
   IOOperation.Mode = MSM_IO_OP_WRITE_WORD;
   IOOperation.IOData = iData;

   IOStatus = MSMDrvIoCtl(internalHandle, MSM_CONTROL_IO_ACCESS, &IOOperation, sizeof(IOOperation), &IOOperation, sizeof(IOOperation));

   // check if the IO control has succeeded
   if(IOStatus != MSM_STATUS_SUCCESS)
   {
      return IOStatus;
   }

   return IOOperation.IOStatus;
}



//--------------------------------------------------------------
//
// Name: MSMIORead32
//
// Description: this function will read 32 bits of data from an IO port
//
// Parameters: iMSMHandle: handle to the device driver
//             iAddress: the IO port address
//             opData: pointer to receive the read result
//
// Return:  the status of the function
//
// Notes:
//
//--------------------------------------------------------------
MSM_STATUS MSMIORead32(MSM_HANDLE iMSMHandle, MSM_UINT32 iAddress, MSM_UINT32 *opData)
{
   MSM_API_INTERNAL_HANDLE *internalHandle = (MSM_API_INTERNAL_HANDLE*)iMSMHandle;
   MSM_STATUS              IOStatus = MSM_STATUS_SUCCESS;
   MSM_IOCTL_IO_OPERATION  IOOperation = {0};

   if(iMSMHandle == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_HANDLE, MSM_DETAIL_DRIVER_HANDLE);
   }

   if(opData == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NULL_DATA_POINTER);
   }

   IOOperation.IOAddress = iAddress;
   IOOperation.Mode = MSM_IO_OP_READ_DWORD;

   IOStatus = MSMDrvIoCtl(internalHandle, MSM_CONTROL_IO_ACCESS, &IOOperation, sizeof(IOOperation), &IOOperation, sizeof(IOOperation));

   // check if the IO control has succeeded
   if(IOStatus != MSM_STATUS_SUCCESS)
   {
      return IOStatus;
   }

   *opData = IOOperation.IOData;

   return IOOperation.IOStatus;
}

//--------------------------------------------------------------
//
// Name: MSMIOWrite32
//
// Description: this function will read 32 bits of data to an IO port
//
// Parameters: iMSMHandle: handle to the device driver
//             iAddress: the IO port address
//             opData: data to write
//
// Return:  the status of the function
//
// Notes:
//
//--------------------------------------------------------------
MSM_STATUS MSMIOWrite32(MSM_HANDLE iMSMHandle, MSM_UINT32 iAddress, MSM_UINT32 iData)
{
   MSM_API_INTERNAL_HANDLE *internalHandle = (MSM_API_INTERNAL_HANDLE*)iMSMHandle;
   MSM_STATUS              IOStatus = MSM_STATUS_SUCCESS;
   MSM_IOCTL_IO_OPERATION  IOOperation = {0};

   if(iMSMHandle == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_HANDLE, MSM_DETAIL_DRIVER_HANDLE);
   }


   IOOperation.IOAddress = iAddress;
   IOOperation.Mode = MSM_IO_OP_WRITE_DWORD;
   IOOperation.IOData = iData;

   IOStatus = MSMDrvIoCtl(internalHandle, MSM_CONTROL_IO_ACCESS, &IOOperation, sizeof(IOOperation), &IOOperation, sizeof(IOOperation));

   // check if the IO control has succeeded
   if(IOStatus != MSM_STATUS_SUCCESS)
   {
      return IOStatus;
   }

   return IOOperation.IOStatus;
}


//--------------------------------------------------------------
//
// Name: MSMMSRWrite
//
// Description: this function will write a CPU MSR
//
// Parameters: iMSMHandle: handle to the device driver
//             iAddress:   the MSR index
//             iData:      data to write
//
// Return:  the status of the function
//
// Notes:
//
//--------------------------------------------------------------
MSM_STATUS MSMMSRWrite(MSM_HANDLE iMSMHandle, MSM_UINT32 iAddress, MSM_UINT64 iData)
{
   MSM_API_INTERNAL_HANDLE *internalHandle = (MSM_API_INTERNAL_HANDLE*)iMSMHandle;
   MSM_STATUS               IOStatus = MSM_STATUS_SUCCESS;
   MSM_IOCTL_MSR_OPERATION  MSROperation = {0};

   if(iMSMHandle == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_HANDLE, MSM_DETAIL_DRIVER_HANDLE);
   }


   MSROperation.MSRAddr = iAddress;
   MSROperation.Mode = MSM_MSR_OP_WRITE;
   MSROperation.MSRData = iData;

   IOStatus = MSMDrvIoCtl(internalHandle, MSM_CONTROL_MSR_ACCESS, &MSROperation, sizeof(MSROperation), &MSROperation, sizeof(MSROperation));

   // check if the IO control has succeeded
   if(IOStatus != MSM_STATUS_SUCCESS)
   {
      return IOStatus;
   }

   return MSROperation.IOStatus;
}

//--------------------------------------------------------------
//
// Name: MSMMSRRead
//
// Description: this function will read a CPU MSR
//
// Parameters: iMSMHandle: handle to the device driver
//             iAddress:   the MSR index
//             opData:     pointer to receive the read data
//
// Return:  the status of the function
//
// Notes:
//
//--------------------------------------------------------------
MSM_STATUS MSMMSRRead(MSM_HANDLE iMSMHandle, MSM_UINT32 iAddress, MSM_UINT64 *opData)
{
   MSM_API_INTERNAL_HANDLE *internalHandle = (MSM_API_INTERNAL_HANDLE*)iMSMHandle;
   MSM_STATUS               IOStatus = MSM_STATUS_SUCCESS;
   MSM_IOCTL_MSR_OPERATION  MSROperation = {0};

   if(iMSMHandle == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_HANDLE, MSM_DETAIL_DRIVER_HANDLE);
   }

   if(opData == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NULL_DATA_POINTER);
   }

   MSROperation.MSRAddr = iAddress;
   MSROperation.Mode = MSM_MSR_OP_READ;

   IOStatus = MSMDrvIoCtl(internalHandle, MSM_CONTROL_MSR_ACCESS, &MSROperation, sizeof(MSROperation), &MSROperation, sizeof(MSROperation));

   // check if the IO control has succeeded
   if(IOStatus != MSM_STATUS_SUCCESS)
   {
      return IOStatus;
   }

   *opData = MSROperation.MSRData;
   return MSROperation.IOStatus;

}

//--------------------------------------------------------------
//
// Name: MSMASPMControl
//
// Description: this function will work on the ASPM feature
//
// Parameters: iMSMHandle: handle to the device driver
//             iBusNb:  the bus number where the device is located
//             iDevNb:  the device number where the device is located
//             iFuncNb: the function number of the device
//             iCommand: indicates the operation to perform
//             opResult: pointer to the optional result
//
// Return:  the status of the function
//
// Notes:
//
//--------------------------------------------------------------
MSM_STATUS MSMASPMControl(MSM_HANDLE iMSMHandle, MSM_UINT8 iBusNb, MSM_UINT8 iDevNb, MSM_UINT8 iFuncNb, MSM_UINT64 iCommmand, MSM_UINT32 *iopResult)
   {
   MSM_API_INTERNAL_HANDLE *internalHandle = (MSM_API_INTERNAL_HANDLE*)iMSMHandle;
   MSM_STATUS               IOStatus = MSM_STATUS_SUCCESS;
   MSM_IOCTL_ASPM_OPERATION ASPMOperation = {0};

   if(iMSMHandle == MSM_NULL)
      {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_HANDLE, MSM_DETAIL_DRIVER_HANDLE);
      }


   ASPMOperation.Operation = iCommmand;
   ASPMOperation.BusNb = iBusNb;
   ASPMOperation.Data = (iopResult == MSM_NULL) ? 0 : *iopResult;
   ASPMOperation.DevNb = iDevNb;
   ASPMOperation.FuncNb = iFuncNb;

   IOStatus = MSMDrvIoCtl(internalHandle, MSM_CONTROL_ASPM_ACCESS, &ASPMOperation, sizeof(ASPMOperation), &ASPMOperation, sizeof(ASPMOperation));

   // check if the IO control has succeeded
   if(IOStatus != MSM_STATUS_SUCCESS)
      {
      return IOStatus;
      }

   if(iopResult != MSM_NULL)
      *iopResult= ASPMOperation.Data;
   return ASPMOperation.IOStatus;

   }

//--------------------------------------------------------------
//
// Name: MSMPutPrivateData
//
// Description: this function will store private data in the driver
//
// Parameters: iMSMHandle: handle to the device driver
//             iDataID: ID of the data element
//             iLength: length of the data to store
//             ipDataPtr: pointer to the data to store
//             iFlags: flags for the function
//
// Return:  the status of the function
//
// Notes:
//
//--------------------------------------------------------------
MSM_STATUS MSMPutPrivateData(MSM_HANDLE iMSMHandle, MSM_UINT32 iDataID, MSM_SIZE iLength, void* ipDataPtr, MSM_UINT64 iFlags)
{
   MSM_API_INTERNAL_HANDLE *internalHandle = (MSM_API_INTERNAL_HANDLE*)iMSMHandle;
   MSM_STATUS              IOStatus = MSM_STATUS_SUCCESS;
   MSM_IOCTL_PRIVATE_DATA   *pDevInfo = MSM_NULL;

   if(iMSMHandle == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_HANDLE, MSM_DETAIL_DRIVER_HANDLE);
   }

   if(ipDataPtr == MSM_NULL)
   {
      iLength = 0;
   }

   MSM_UINT32 structSize = (MSM_UINT32)iLength + offsetof(MSM_IOCTL_PRIVATE_DATA, Data);
   pDevInfo = (MSM_IOCTL_PRIVATE_DATA*)MSMAllocMemory(structSize, true);


   if(pDevInfo == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_OUT_OF_MEMORY, MSM_DETAIL_OUT_OF_MEMORY);
   }

   pDevInfo->DataID = iDataID;
   pDevInfo->Flags  = iFlags;
   pDevInfo->Length = iLength;
   MSMInternalMemcpy(pDevInfo->Data, ipDataPtr, iLength);

   IOStatus = MSMDrvIoCtl(internalHandle, MSM_CONTROL_PUT_DEV_INFO, pDevInfo, structSize, pDevInfo, structSize);

   // check if the IO control has succeeded
   if(IOStatus != MSM_STATUS_SUCCESS)
   {
      MSMFreeMemory(pDevInfo);
      return IOStatus;
   }


   MSM_STATUS RetStatus = pDevInfo->IOStatus;
   MSMFreeMemory(pDevInfo);
   return RetStatus;
}

//--------------------------------------------------------------
//
// Name:    MSMGetDriverInfo
//
// Description:   get info about the driver
//
// Parameters: iMSMHandle: handle to the driver
//             iopInfo: pointer containing info about the driver
//
// Return:  the status of the function
//
// Notes:
//
//--------------------------------------------------------------
MSM_STATUS MSMGetDriverInfo(MSM_HANDLE iMSMHandle, MSM_DRIVER_INFORMATION *iopInfo)
{
   MSM_API_INTERNAL_HANDLE *internalHandle = (MSM_API_INTERNAL_HANDLE*)iMSMHandle;
   MSM_STATUS              IOStatus = MSM_STATUS_SUCCESS;
   MSM_IOCTL_GET_DRIVER_INFO ioGetDrvInfo;

   if(iopInfo == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER,MSM_DETAIL_NULL_DRIVER_INFO);
   }

   if(iMSMHandle == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_HANDLE, MSM_DETAIL_DRIVER_HANDLE);
   }

   ioGetDrvInfo.Version = iopInfo->StructVersion;

   // copy the data for the driver
   MSMInternalMemcpy(&ioGetDrvInfo.versions.Version2, iopInfo, MSM_MIN(iopInfo->StructSize, sizeof(ioGetDrvInfo.versions)));


   IOStatus = MSMDrvIoCtl(internalHandle, MSM_CONTROL_GET_DRIVER_INFO, &ioGetDrvInfo, sizeof(ioGetDrvInfo), &ioGetDrvInfo, sizeof(ioGetDrvInfo));

   // check if the IO control has succeeded
   if(IOStatus != MSM_STATUS_SUCCESS)
   {
      return IOStatus;
   }
   // clear the target
   MSM_UINT32 OldSize = iopInfo->StructSize;
   MSMMemset(iopInfo, 0, iopInfo->StructSize);
   iopInfo->StructSize = OldSize;

   // copy the data back from the driver
   MSMInternalMemcpy(iopInfo, &ioGetDrvInfo.versions.Version1, MSM_MIN(ioGetDrvInfo.versions.Version1.StructSize, MSM_MIN(iopInfo->StructSize, sizeof(ioGetDrvInfo.versions))));

   return ioGetDrvInfo.IOStatus;
}

#if MSM_API_USE_WINDOWS && MSM_API_USER_CODE // For now, will bring it to the other OS/mode later

#if MSM_USER_REG_SUPPORT && MSM_API_USE_WINDOWS
inline HKEY REGTOHKEY(MSM_REGHANDLE Reg)
{
   if(Reg != NULL)
      return (HKEY)((MSM_UINTPTR)(((MSM_REGHANDLE_INTERNAL*)Reg)->RegHandle));
   return MSM_NULL;
}
#endif

//--------------------------------------------------------------
//
// Name:          MSMRegOpenKey
//
// Description:   open a registry key
//
// Parameters:    iMSMHandle: handle to the driver
//                ipKeyName:  the key to open
//                iMode:      the mode flags to be applied
//                opRegHandle: pointer to receive the handle
//
// Return:
//
// Notes:
//
//--------------------------------------------------------------
MSM_STATUS MSMRegOpenKey(MSM_HANDLE iMSMHandle, const MSM_CHAR *ipKeyName, MSM_UINT64 iMode, MSM_REGHANDLE *opRegHandle)
{
   MSM_STATUS RetStatus = MSM_STATUS_SUCCESS;
   MSM_API_INTERNAL_HANDLE *internalHandle = (MSM_API_INTERNAL_HANDLE*)iMSMHandle;

   if(ipKeyName == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NULL_NAME);
   }

   if(opRegHandle == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NULL_HANDLE);
   }

   MSM_REGHANDLE_INTERNAL *internalReg = (MSM_REGHANDLE_INTERNAL*)MSMAllocMemory(sizeof(MSM_REGHANDLE_INTERNAL), true);

   if(internalReg == MSM_NULL)
      return MSM_STATUS_CREATE(MSM_ERROR_OUT_OF_MEMORY, MSM_DETAIL_REGISTRY_HANDLE);

   if((iMSMHandle != MSM_NULL) && !(iMode & MSM_REG_USER_MODE))
   {
      MSM_UINT32 regInfoSize = 0;
      MSM_IOCTL_REGISTRY *regInfo = MSMAllocControlRegistry(MSM_REG_OPEN, 0, iMode, MSM_REG_ANY, ipKeyName, 0, MSM_NULL, false, &regInfoSize);
      
      if(regInfo != MSM_NULL)
      {
         RetStatus = MSMDrvIoCtl(internalHandle, MSM_CONTROL_REGISTRY, regInfo, regInfoSize, regInfo, regInfoSize);

         // check if the IO control has succeeded
         if(RetStatus == MSM_STATUS_SUCCESS)
         {
            RetStatus = regInfo->IOStatus;
            if(RetStatus == MSM_STATUS_SUCCESS)
               internalReg->RegHandle = regInfo->RegHandle;            
         }

         MSMFreeMemory(regInfo);
      }
      else
      {
         RetStatus = MSM_STATUS_CREATE(MSM_ERROR_OUT_OF_MEMORY, MSM_DETAIL_DRIVER_HANDLE);
      }
   }
   else if(iMode & MSM_REG_USER_MODE)
   {
#if MSM_USER_REG_SUPPORT
#if MSM_API_USE_WINDOWS
      HKEY  RootKey = NULL;
      HKEY  RegKey = NULL;
      LONG  RetCode;
      switch(iMode & MSM_REG_ROOTNAME_MASK)
      {
      case MSM_REG_LOCAL_MACHINE:
         RootKey = HKEY_LOCAL_MACHINE;
         break;
      case MSM_REG_CURRENT_USER:
         RootKey = HKEY_CURRENT_USER;
         break;
      default:
         RetStatus = MSM_STATUS_CREATE(MSM_ERROR_REGISTRY, MSM_DETAIL_INVALID_ROOT);
      }

      if(RetStatus == MSM_STATUS_SUCCESS)
      {
         if(iMode & (MSM_REG_WRITE | MSM_REG_CREATE))
         {
            RetCode = RegCreateKeyExW(RootKey, (LPCWSTR)ipKeyName, 0, NULL, (iMode & MSM_REG_VOLATILE) ? REG_OPTION_VOLATILE : REG_OPTION_NON_VOLATILE, 
               KEY_READ | ((iMode & MSM_REG_WRITE) ? KEY_ALL_ACCESS : 0), NULL, &RegKey, NULL);
         }
         else
         {
            RetCode = RegOpenKeyExW(RootKey, (LPCWSTR)ipKeyName, 0, KEY_READ, &RegKey);
         }

         if(RetCode != ERROR_SUCCESS)
         {
            RetStatus = MSM_STATUS_CREATE(MSM_ERROR_REGISTRY, MSM_DETAIL_CANNOT_OPEN_REGISTRY_KEY);
         }
         else
         {
            internalReg->RegHandle = (MSM_UINTPTR)RegKey;
            internalReg->Flags = MSM_REGHANDLE_FLAG_USER;
         }
      }
#elif MSM_API_USE_LINUX
#endif
#else
      return MSM_STATUS_CREATE(MSM_ERROR_REGISTRY, MSM_DETAIL_NOT_SUPPORTED);
#endif // MSM_USER_REG_SUPPORT
   }
   else
      RetStatus = MSM_STATUS_CREATE(MSM_ERROR_REGISTRY, MSM_DETAIL_NOT_SUPPORTED);

   if(RetStatus != MSM_STATUS_SUCCESS)
      MSMFreeMemory(internalReg);
   else
      *opRegHandle = (MSM_REGHANDLE)internalReg;

   return RetStatus;
}

//--------------------------------------------------------------
//
// Name:          MSMRegCloseKey
//
// Description:   close a previously open registry key
//
// Parameters:    iMSMHandle: handle to the driver
//                iRegHandle: handle to close
//
// Return:  the status of the function
//
// Notes:
//
//--------------------------------------------------------------
MSM_STATUS MSMRegCloseKey(MSM_HANDLE iMSMHandle, MSM_REGHANDLE iRegHandle)
{
   MSM_STATUS retCode = MSM_STATUS_SUCCESS;
   if(iRegHandle == 0)
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_REGISTRY_HANDLE);

   MSM_API_INTERNAL_HANDLE *internalHandle = (MSM_API_INTERNAL_HANDLE*)iMSMHandle;
   MSM_REGHANDLE_INTERNAL *internalReg = (MSM_REGHANDLE_INTERNAL *)iRegHandle;

   if((iMSMHandle != MSM_NULL) && !(internalReg->Flags & MSM_REGHANDLE_FLAG_USER))
   {
      MSM_UINT32 regInfoSize = 0;
      MSM_IOCTL_REGISTRY *regInfo = MSMAllocControlRegistry(MSM_REG_CLOSE, iRegHandle,  0, MSM_REG_ANY, MSM_NULL, 0, MSM_NULL, false, &regInfoSize);

      if(regInfo == MSM_NULL)
      {
         MSMFreeMemory(internalReg);
         return MSM_STATUS_CREATE(MSM_ERROR_OUT_OF_MEMORY, MSM_DETAIL_REGISTRY_DATA);
      }

      retCode = MSMDrvIoCtl(internalHandle, MSM_CONTROL_REGISTRY, regInfo, regInfoSize, regInfo, regInfoSize);

      // check if the IO control has succeeded
      if(retCode == MSM_STATUS_SUCCESS)
      {
         retCode = regInfo->IOStatus;
      }

      MSMFreeMemory(regInfo);
   }
   else if(internalReg->Flags & MSM_REGHANDLE_FLAG_USER)
   {
#if MSM_USER_REG_SUPPORT
#if MSM_API_USE_WINDOWS
      RegCloseKey(REGTOHKEY(iRegHandle));
#elif MSM_API_USE_LINUX
#endif
#else
      MSMFreeMemory(internalReg);
      return MSM_STATUS_CREATE(MSM_ERROR_REGISTRY, MSM_DETAIL_NOT_SUPPORTED);
#endif // MSM_USER_REG_SUPPORT
   }
   else
      retCode = MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NOT_SUPPORTED);

   MSMFreeMemory(internalReg);

   return retCode;
}

//--------------------------------------------------------------
//
// Name:          MSMRegReadValue
//
// Description:   read a value from the registry
//
// Parameters:    iMSMHandle: handle to the driver
//                iRegHandle: handle to the registry key
//                ipValueName: name of the value to read from
//                opData: pointer to store the data
//                iopSize: size of the input data and on return,
//                         size in the registry
//                iopReadType: expected type of value. On return, the real type
//
// Return:  the status of the function
//
// Notes:
//
//--------------------------------------------------------------
MSM_STATUS MSMRegReadValue(MSM_HANDLE iMSMHandle, MSM_REGHANDLE iRegHandle, const MSM_CHAR *ipValueName, void *opData, MSM_SIZE *iopSize, MSM_REGTYPE *iopReadType)
{
   MSM_STATUS retCode = MSM_STATUS_SUCCESS;
   MSM_API_INTERNAL_HANDLE *internalHandle = (MSM_API_INTERNAL_HANDLE*)iMSMHandle;

   if(iRegHandle == 0)
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_REGISTRY_HANDLE);

   if(ipValueName == MSM_NULL)
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NULL_NAME);

   if(iopSize == MSM_NULL)
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NULL_SIZE);

   MSM_REGHANDLE_INTERNAL* internalReg = (MSM_REGHANDLE_INTERNAL*)iRegHandle;

   if((iMSMHandle != MSM_NULL) && !(internalReg->Flags & MSM_REGHANDLE_FLAG_USER))
   {
      MSM_UINT32 regInfoSize = 0;
      MSM_IOCTL_REGISTRY *regInfo = MSMAllocControlRegistry(MSM_REG_READ_VALUE, iRegHandle,  0, *iopReadType, ipValueName, *iopSize, opData, false, &regInfoSize);

      if(regInfo != MSM_NULL)
      {
         retCode = MSMDrvIoCtl(internalHandle, MSM_CONTROL_REGISTRY, regInfo, regInfoSize, regInfo, regInfoSize);

         // check if the IO control has succeeded
         if(retCode == MSM_STATUS_SUCCESS)
         {
            retCode = regInfo->IOStatus;

            *iopSize = (MSM_SIZE)regInfo->DataSize;
            if(retCode == MSM_STATUS_SUCCESS)
            {
               // copy the data back
               // the data is always after the regInfo data structure
               MSMInternalMemcpy(opData, (void*)((MSM_UINTPTR)regInfo + (MSM_UINTPTR)regInfo->DataOffset) , (MSM_SIZE)regInfo->DataSize);
            }

            if(*iopReadType != MSM_REG_ANY)
            {
               if(*iopReadType != regInfo->RegType)
               {
                  retCode = MSM_STATUS_CREATE(MSM_ERROR_REGISTRY, MSM_DETAIL_INVALID_REG_TYPE);
               }
            }
            *iopReadType = regInfo->RegType;
         }
         MSMFreeMemory(regInfo);
      }
      else
         retCode = MSM_STATUS_CREATE(MSM_ERROR_OUT_OF_MEMORY, MSM_DETAIL_REGISTRY_DATA);
   }
   else if(internalReg->Flags & MSM_REGHANDLE_FLAG_USER)
   {
#if MSM_USER_REG_SUPPORT
#if MSM_API_USE_WINDOWS
      LONG opResult;
      DWORD RegType;
      DWORD RegSize = (DWORD)*iopSize;
      opResult = RegQueryValueExW(REGTOHKEY(iRegHandle), (LPCWSTR)ipValueName, 0, &RegType, (LPBYTE)opData,&RegSize);

      if((opResult == ERROR_SUCCESS) || (opResult == ERROR_MORE_DATA))
      {
         if(iopReadType != MSM_NULL)
         {
            MSM_REGTYPE curType;
            switch(RegType)
            {
            case REG_DWORD:
               curType = MSM_REG_DWORD;
               break;
            case REG_QWORD:
               curType = MSM_REG_QWORD;
               break;
            case REG_SZ:
               curType = MSM_REG_STRING;
               break;
            case REG_EXPAND_SZ:
               curType = MSM_REG_STRING_EXPAND;
               break;
            case REG_BINARY:
               curType = MSM_REG_BINARY;
               break;
            default:
               curType = MSM_REG_UNKNOWN;
               break;
            }
            if(*iopReadType != MSM_REG_ANY)
            {
               if(*iopReadType != curType)
               {
                  retCode = MSM_STATUS_CREATE(MSM_ERROR_REGISTRY, MSM_DETAIL_INVALID_REG_TYPE);
               }
            }
            *iopReadType = curType;

         }
         *iopSize = RegSize;

         if(opResult == ERROR_MORE_DATA)
            retCode = MSM_STATUS_MORE_DATA;
      }
      else
      {
         retCode = MSM_STATUS_CREATE(MSM_ERROR_OS_ERROR, MSM_DETAIL_CANNOT_QUERY_REGISTRY_KEY);
      }

#elif MSM_API_USE_LINUX
#endif
#else
      retCode = MSM_STATUS_CREATE(MSM_ERROR_REGISTRY, MSM_DETAIL_NOT_SUPPORTED);
#endif // MSM_USER_REG_SUPPORT
   }
   else
      retCode = MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NOT_SUPPORTED);

   return retCode;
}

//--------------------------------------------------------------
//
// Name:          MSMRegWriteValue
//
// Description:   write a value in the registry
//
// Parameters:    iMSMHandle: handle to the driver
//                iRegHandle: handle to a registry key
//                ipValueName: name of the value to write
//                ipData:  data to write
//                iSize:   size of the data to write (in bytes)
//                iWriteType: the type of the value
//
// Return:  the status of the function
//
// Notes:
//
//--------------------------------------------------------------
MSM_STATUS MSMRegWriteValue(MSM_HANDLE iMSMHandle, MSM_REGHANDLE iRegHandle, const MSM_CHAR *ipValueName, const void *ipData, MSM_SIZE iSize, MSM_REGTYPE iWriteType)
{
   MSM_STATUS retCode = MSM_STATUS_SUCCESS;
   if(iRegHandle == 0)
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_REGISTRY_HANDLE);

   if(ipValueName == MSM_NULL)
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NULL_NAME);

   if(ipData == MSM_NULL)
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NULL_DATA_POINTER);

   MSM_API_INTERNAL_HANDLE *internalHandle = (MSM_API_INTERNAL_HANDLE*)iMSMHandle;

   MSM_REGHANDLE_INTERNAL* internalReg = (MSM_REGHANDLE_INTERNAL*)iRegHandle;

   if((iMSMHandle != MSM_NULL) && !(internalReg->Flags & MSM_REGHANDLE_FLAG_USER))
   {
      MSM_UINT32 regInfoSize = 0;
      MSM_IOCTL_REGISTRY *regInfo = MSMAllocControlRegistry(MSM_REG_WRITE_VALUE, iRegHandle,  0, iWriteType, ipValueName, iSize, (void*)ipData, true, &regInfoSize);

      if(regInfo != MSM_NULL)
      {
         retCode = MSMDrvIoCtl(internalHandle, MSM_CONTROL_REGISTRY, regInfo, regInfoSize, regInfo, regInfoSize);

         // check if the IO control has succeeded
         if(retCode == MSM_STATUS_SUCCESS)
         {
            retCode = regInfo->IOStatus;
         }

         MSMFreeMemory(regInfo);
      }
      else
         retCode = MSM_STATUS_CREATE(MSM_ERROR_OUT_OF_MEMORY, MSM_DETAIL_REGISTRY_DATA);
   }
   else if(internalReg->Flags & MSM_REGHANDLE_FLAG_USER)
   {
#if MSM_USER_REG_SUPPORT
#if MSM_API_USE_WINDOWS
      DWORD curType = REG_NONE;
      switch(iWriteType)
      {
      case MSM_REG_DWORD:
         curType = REG_DWORD;
         break;
      case MSM_REG_QWORD:
         curType = REG_QWORD;
         break;
      case MSM_REG_STRING:
         curType = REG_SZ;
         break;
      case MSM_REG_STRING_EXPAND:
         curType = REG_EXPAND_SZ;
         break;
      case MSM_REG_BINARY:
         curType = REG_BINARY;
         break;
      default:
         retCode = MSM_STATUS_CREATE(MSM_ERROR_REGISTRY, MSM_DETAIL_INVALID_REG_TYPE);
      }

      if(retCode == MSM_STATUS_SUCCESS)
      {
         LONG opResult = RegSetValueExW(REGTOHKEY(iRegHandle), (LPCWSTR)ipValueName,0, curType,(const BYTE*)ipData, (DWORD)iSize);

         if(opResult != ERROR_SUCCESS)
            retCode = MSM_STATUS_CREATE(MSM_ERROR_REGISTRY, MSM_DETAIL_CANNOT_WRITE_REGISTRY_KEY);
      }
#elif MSM_API_USE_LINUX
#endif
#else
      retCode = MSM_STATUS_CREATE(MSM_ERROR_REGISTRY, MSM_DETAIL_NOT_SUPPORTED);
#endif // MSM_USER_REG_SUPPORT
   }
   else
      retCode = MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NOT_SUPPORTED);

   return retCode;
}

//--------------------------------------------------------------
//
// Name:       MSMRegDeleteValue
//
// Description:   delete a value from the registry
//
// Parameters: iMSMHandle: handle to the driver
//             iRegHandle: handle to the registry
//             ipValueName: name of the value to delete
//
// Return:  the status of the function
//
// Notes:
//
//--------------------------------------------------------------
MSM_STATUS MSMRegDeleteValue(MSM_HANDLE iMSMHandle, MSM_REGHANDLE iRegHandle, const MSM_CHAR *ipValueName)
{
   MSM_STATUS retCode = MSM_STATUS_SUCCESS;
   
   if(iRegHandle == 0)
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_REGISTRY_HANDLE);

   if(ipValueName == MSM_NULL)
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NULL_NAME);

   MSM_API_INTERNAL_HANDLE *internalHandle = (MSM_API_INTERNAL_HANDLE*)iMSMHandle;
   MSM_REGHANDLE_INTERNAL* internalReg = (MSM_REGHANDLE_INTERNAL*)iRegHandle;
   if((iMSMHandle != MSM_NULL) && !(internalReg->Flags & MSM_REGHANDLE_FLAG_USER))
   {
      MSM_UINT32 regInfoSize = 0;
      MSM_IOCTL_REGISTRY *regInfo = MSMAllocControlRegistry(MSM_REG_DELETE_VALUE, iRegHandle,  0, MSM_REG_ANY, ipValueName, 0, MSM_NULL, false, &regInfoSize);

      if(regInfo != MSM_NULL)
      {
         retCode = MSMDrvIoCtl(internalHandle, MSM_CONTROL_REGISTRY, regInfo, regInfoSize, regInfo, regInfoSize);

         // check if the IO control has succeeded
         if(retCode == MSM_STATUS_SUCCESS)
         {
            retCode = regInfo->IOStatus;
         }
         
         MSMFreeMemory(regInfo);
      }
      else
         retCode = MSM_STATUS_CREATE(MSM_ERROR_OUT_OF_MEMORY, MSM_DETAIL_REGISTRY_DATA);
   }
   else if(internalReg->Flags & MSM_REGHANDLE_FLAG_USER)
   {
#if MSM_USER_REG_SUPPORT
#if MSM_API_USE_WINDOWS
      LONG opResult = RegDeleteValueW(REGTOHKEY(iRegHandle), (LPCWSTR)ipValueName);

      if(opResult != ERROR_SUCCESS)
         retCode = MSM_STATUS_CREATE(MSM_ERROR_REGISTRY, MSM_DETAIL_CANNOT_DELETE_VALUE);

#elif MSM_API_USE_LINUX
#endif
#else
      retCode = MSM_STATUS_CREATE(MSM_ERROR_REGISTRY, MSM_DETAIL_NOT_SUPPORTED);
#endif // MSM_USER_REG_SUPPORT
   }
   else
      retCode = MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NOT_SUPPORTED);

   return retCode;
}

//--------------------------------------------------------------
//
// Name:       MSMRegDeleteKey
//
// Description: delete a key from the registry
//
// Parameters: iMSMHandle: handle to the driver
//             iMode: specify the root registry entry
//             ipKeyName: the key to delete
//
// Return:  the status of the function
//
// Notes:
//
//--------------------------------------------------------------
MSM_STATUS MSMRegDeleteKey(MSM_HANDLE iMSMHandle, MSM_UINT64 iMode, const MSM_CHAR *ipKeyName)
{
   MSM_STATUS retCode = MSM_STATUS_SUCCESS;

   if(ipKeyName == MSM_NULL)
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NULL_NAME);

   MSM_API_INTERNAL_HANDLE *internalHandle = (MSM_API_INTERNAL_HANDLE*)iMSMHandle;

   if((iMSMHandle != MSM_NULL) && !(iMode & MSM_REG_USER_MODE))
   {
      MSM_UINT32 regInfoSize = 0;
      MSM_IOCTL_REGISTRY *regInfo = MSMAllocControlRegistry(MSM_REG_DELETE_KEY, MSM_NULL,  iMode, MSM_REG_ANY, ipKeyName, 0, MSM_NULL, false, &regInfoSize);

      if(regInfo == MSM_NULL)
      {
         retCode = MSMDrvIoCtl(internalHandle, MSM_CONTROL_REGISTRY, regInfo, regInfoSize, regInfo, regInfoSize);

         // check if the IO control has succeeded
         if(retCode == MSM_STATUS_SUCCESS)
         {
            retCode = regInfo->IOStatus;
         }

         MSMFreeMemory(regInfo);
      }
      else
         retCode = MSM_STATUS_CREATE(MSM_ERROR_OUT_OF_MEMORY, MSM_DETAIL_REGISTRY_DATA);

   }
   else if(iMode & MSM_REG_USER_MODE)
   {
#if MSM_USER_REG_SUPPORT
#if MSM_API_USE_WINDOWS
      HKEY  RootKey = NULL;
      switch(iMode & MSM_REG_ROOTNAME_MASK)
      {
      case MSM_REG_LOCAL_MACHINE:
         RootKey = HKEY_LOCAL_MACHINE;
         break;
      case MSM_REG_CURRENT_USER:
         RootKey = HKEY_CURRENT_USER;
         break;
      default:
         retCode = MSM_STATUS_CREATE(MSM_ERROR_REGISTRY, MSM_DETAIL_INVALID_ROOT);
      }
      if(retCode == MSM_STATUS_SUCCESS)
      {
         if(RegDeleteKeyW(RootKey, (LPCWSTR)ipKeyName) != ERROR_SUCCESS)
            retCode = MSM_STATUS_CREATE(MSM_ERROR_REGISTRY, MSM_DETAIL_CANNOT_DELETE_KEY);
      }
#elif MSM_API_USE_LINUX
#endif
#else
      retCode = MSM_STATUS_CREATE(MSM_ERROR_REGISTRY, MSM_DETAIL_NOT_SUPPORTED);
#endif // MSM_USER_REG_SUPPORT
   }
   else
      retCode = MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NOT_SUPPORTED);

   return retCode;
}

//--------------------------------------------------------------
//
// Name:    MSMRegValueExist
//
// Description: determine if a value exists in the registry
//
// Parameters: iMSMHandle: handle to the driver
//             iRegHandle: handle to the registry
//             ipValueName: name of the value to check for existence
//
// Return:  the status of the function
//
// Notes:
//
//--------------------------------------------------------------
MSM_STATUS MSMRegValueExist(MSM_HANDLE iMSMHandle, MSM_REGHANDLE iRegHandle, const MSM_CHAR *ipValueName)
{
   MSM_STATUS retCode = MSM_STATUS_SUCCESS;
   if(iRegHandle == 0)
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_REGISTRY_HANDLE);

   if(ipValueName == MSM_NULL)
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NULL_NAME);

   MSM_API_INTERNAL_HANDLE *internalHandle = (MSM_API_INTERNAL_HANDLE*)iMSMHandle;
   MSM_REGHANDLE_INTERNAL* internalReg = (MSM_REGHANDLE_INTERNAL*)iRegHandle;

   if((iMSMHandle != MSM_NULL) && !(internalReg->Flags & MSM_REGHANDLE_FLAG_USER))
   {
      MSM_UINT32 regInfoSize = 0;
      MSM_IOCTL_REGISTRY *regInfo = MSMAllocControlRegistry(MSM_REG_VALUE_EXISTS, iRegHandle,  0, MSM_REG_ANY, ipValueName, 0, MSM_NULL, false, &regInfoSize);

      if(regInfo != MSM_NULL)
      {
         retCode = MSMDrvIoCtl(internalHandle, MSM_CONTROL_REGISTRY, regInfo, regInfoSize, regInfo, regInfoSize);

         // check if the IO control has succeeded
         if(retCode == MSM_STATUS_SUCCESS)
         {
            retCode = regInfo->IOStatus;
         }

         MSMFreeMemory(regInfo);
      }
      else
         retCode = MSM_STATUS_CREATE(MSM_ERROR_OUT_OF_MEMORY, MSM_DETAIL_REGISTRY_DATA);
   }
   else if(internalReg->Flags & MSM_REGHANDLE_FLAG_USER)
   {
#if MSM_USER_REG_SUPPORT
#if MSM_API_USE_WINDOWS
      DWORD dataSize = 0;
      DWORD regType;
      LONG OpResult = RegQueryValueExW(REGTOHKEY(iRegHandle), (LPCWSTR)ipValueName, NULL, &regType, NULL, &dataSize);
      if((OpResult != ERROR_SUCCESS) && (OpResult != ERROR_MORE_DATA))
         retCode = MSM_STATUS_DONT_EXIST;

#elif MSM_API_USE_LINUX
#endif
#else
      retCode = MSM_STATUS_CREATE(MSM_ERROR_REGISTRY, MSM_DETAIL_NOT_SUPPORTED);
#endif
   }
   else
      retCode = MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER, MSM_DETAIL_NOT_SUPPORTED);

   return retCode;
}
#endif // MSM_API_USE_WINDOWS && MSM_API_USER_CODE

///////////////////////////////////////////////////////////////////
//
// static functions
//
///////////////////////////////////////////////////////////////////

//--------------------------------------------------------------
//
// Name:    MSMAllocMemory
//
// Description: allocate memory on the OS heap
//
// Parameters: size: the number of bytes to allocate
//             ZeroMemory: indicates if we clear the memory after a successful alloc
//
// Return:  the pointer to the allocated memory
//
// Notes:
//
//--------------------------------------------------------------
static void* MSMAllocMemory(MSM_SIZE size, MSM_BOOL ZeroMemory)
{
   void * retPtr;
#if MSM_API_USER_CODE
   retPtr = malloc(size);
#else
#if MSM_API_USE_WINDOWS
   retPtr = ExAllocatePoolWithTag(NonPagedPool, size, 'amem');
#else
   retPtr = MDrv_memalloc(size);
#endif   // MSM_API_USE_WINDOWS
#endif   // MSM_API_USER_MODE

   if(ZeroMemory && (retPtr != MSM_NULL))
   {
#if MSM_API_DRIVER_CODE && MSM_API_USE_WINDOWS
      RtlZeroMemory(retPtr, size);
#elif MSM_API_DRIVER_CODE && MSM_API_USE_LINUX
      MDrv_memset(retPtr, 0, size);
#else
      memset(retPtr, 0, size);
#endif
   }
   return retPtr;
}

//--------------------------------------------------------------
//
// Name:    MSMFreeMemory
//
// Description: free previously allocated memory
//
// Parameters: ptr: the pointer to the allocated memory
//
// Return:
//
// Notes:
//
//--------------------------------------------------------------
static void  MSMFreeMemory(void *ptr)
{
#if MSM_API_USER_CODE
   free(ptr);
#else
#if MSM_API_USE_WINDOWS
   ExFreePool(ptr);
#else
   MDrv_memfree(ptr);
#endif   // MSM_API_USE_WINDOWS
#endif   // MSM_API_USER_MODE
}

///////////////////////////////////////////////////////////////////
//
// specific functions
//
///////////////////////////////////////////////////////////////////

//--------------------------------------------------------------
//
// Name:    MSMDrvIoCtl
//
// Description: this function will call the driver function
//
// Parameters: drvHandle: handle to the driver
//             iocode: index of the function to execute
//             dataIn: pointer to the data to send
//             sizeIn: size of the input data
//             dataOut: pointer to the data to receive
//             sizeOut: size of the output data
//
// Return:
//
// Notes:
//
//--------------------------------------------------------------
MSM_STATUS MSMDrvIoCtl(MSM_API_INTERNAL_HANDLE *drvHandle, MSM_UINT32 iocode, void* dataIn, MSM_UINT32 sizeIn, void*dataOut, MSM_UINT32 sizeOut)
{
   MSM_STATUS status = MSM_STATUS_SUCCESS;
#if MSM_API_USER_CODE && MSM_API_USE_WINDOWS
   OVERLAPPED overlapped;
   memset(&overlapped, 0, sizeof(OVERLAPPED));
   overlapped.hEvent = CreateEvent(MSM_NULL,TRUE,TRUE,MSM_NULL);

   DWORD cbReturned = 0;

   /* call the driver to initialize some little things!
    * And check existence of the board.
    */
   if ( !DeviceIoControl(drvHandle->DriverHandle, MSM_IOCTL_CODE(iocode),
            dataIn, sizeIn,
            dataOut,sizeOut,
            &cbReturned,&overlapped))
   {
      if(GetLastError() != ERROR_IO_PENDING)
      {
         status = MSM_STATUS_CREATE(MSM_ERROR_OS_ERROR,MSM_DETAIL_IO_CONTROL);
      }
      else
         {
         if(!GetOverlappedResult(drvHandle->DriverHandle,&overlapped,&cbReturned,TRUE))
            status = MSM_STATUS_CREATE(MSM_ERROR_OS_ERROR,MSM_DETAIL_IO_CONTROL);
         }

   }
   CloseHandle(overlapped.hEvent);

#endif

#if MSM_API_USER_CODE && MSM_API_USE_LINUX
   MtxServMsgPack msgPack;
   // Pack message to send to driver
   msgPack.send     = dataIn;
   msgPack.receive  = dataOut;
   msgPack.inSize   = sizeIn;
   msgPack.outSize  = sizeOut;
   msgPack.iocode   = iocode;

   int retval = ioctl(drvHandle->DriverHandle, MSM_LINUX_CONTROL, &msgPack);

   if(retval == -1)
      status = MSM_STATUS_CREATE(MSM_ERROR_OS_ERROR,MSM_DETAIL_IO_CONTROL);

#endif

#if MSM_API_DRIVER_CODE && MSM_API_USE_WINDOWS
   PIRP            pIrp = MSM_NULL;
   IO_STATUS_BLOCK IrpStatus = {0};
   NTSTATUS        Status = STATUS_SUCCESS;
   
   if(KeGetCurrentIrql() > PASSIVE_LEVEL)
      return MSM_STATUS_CREATE(MSM_ERROR_OS_ERROR,MSM_DETAIL_BAD_IRQL);
   
   PKEVENT         ReqEvent = (PKEVENT)MSMAllocMemory(sizeof(KEVENT), false);

   if(ReqEvent == MSM_NULL)
      return MSM_STATUS_CREATE(MSM_ERROR_OUT_OF_MEMORY,MSM_DETAIL_OUT_OF_MEMORY);

   // check if we are at PASSIVE level
   PAGED_CODE();

   KeInitializeEvent(ReqEvent, NotificationEvent , FALSE);

   if(drvHandle->DeviceObject != MSM_NULL)
   {
      pIrp = IoBuildDeviceIoControlRequest(MSM_IOCTL_CODE(iocode),
                                              drvHandle->DeviceObject,
                                              dataIn,
                                              sizeIn,
                                              dataOut,
                                              sizeOut,
                                              FALSE,         // not an internal Dev. Io Control
                                              ReqEvent,
                                              &IrpStatus);
   }

   if(pIrp != MSM_NULL)
   {
      Status = IoCallDriver(drvHandle->DeviceObject, pIrp);
      if(Status == STATUS_PENDING)
      {
         KeWaitForSingleObject(ReqEvent, Executive, KernelMode, FALSE, MSM_NULL);
         Status = IrpStatus.Status;
      }
   }

   if(!NT_SUCCESS(Status) || (pIrp == MSM_NULL))
      status = MSM_STATUS_CREATE(MSM_ERROR_OS_ERROR,MSM_DETAIL_IO_CONTROL);;

   MSMFreeMemory(ReqEvent);

#endif

#if MSM_API_DRIVER_CODE && MSM_API_USE_LINUX
   MtxServMsgPack msgPack;
   int retval;
   // Pack message to send to driver
   msgPack.send     = dataIn;
   msgPack.receive  = dataOut;
   msgPack.inSize   = sizeIn;
   msgPack.outSize  = sizeOut;
   msgPack.iocode   = iocode;

   retval = MtxServKernelIoctl(MSM_LINUX_CONTROL, &msgPack);

   if(retval == -1)
      status = MSM_STATUS_CREATE(MSM_ERROR_OS_ERROR,MSM_DETAIL_IO_CONTROL);
#endif

   return status;
}

void MSMMemset(void* dst, int data, MSM_SIZE length)
{
#if MSM_API_DRIVER_CODE && MSM_API_USE_LINUX
   MDrv_memset(dst,data,length);
#else
   memset(dst,data,length);
#endif
}

//--------------------------------------------------------------
//
// Name:    MSMInternalMemcpy
//
// Description: this function will perform a memory copy
//
// Parameters: DstPtr: pointer to the destination
//             SrcPtr: pointer to the source
//             Length: the number of bytes to copy
//
// Return:
//
// Notes:
//
//--------------------------------------------------------------
static void MSMInternalMemcpy(void *DstPtr, void* SrcPtr, MSM_SIZE Length)
{
#if  MSM_API_DRIVER_CODE && MSM_API_USE_WINDOWS
   RtlCopyMemory(DstPtr, SrcPtr, Length);
#elif MSM_API_DRIVER_CODE && MSM_API_USE_LINUX
   MDrv_memcpy(DstPtr, SrcPtr, Length);
#else
   memcpy(DstPtr, SrcPtr, Length);
#endif
}

//--------------------------------------------------------------
//
// Name:    MSMInternalStrcpy
//
// Description: this function will perform a string copy
//
// Parameters: DstStr: pointer to the destination string
//             SrcStr: pointer to the source string
//             DstLength: the number of characters in the destination string
//
// Return:
//
// Notes:
//
//--------------------------------------------------------------
#if MSM_API_USE_WINDOWS && MSM_API_USER_CODE
static void MSMInternalStrcpy(char *DstStr, MSM_SIZE DstLength, char* SrcStr)
{
#if !defined(_MSC_VER) || (_MSC_VER < 1400)
   DstLength = DstLength; // unused parameter
   strcpy(DstStr, SrcStr);
#else
   strcpy_s(DstStr, DstLength, SrcStr);
#endif
}
#endif

//--------------------------------------------------------------
//
// Name:    MSMFetchPCIData
//
// Description: this function will fetch the PCI array from the driver
//
// Parameters: drvHandle: pointer to the driver handle
//
// Return:
//
// Notes:
//
//--------------------------------------------------------------
static MSM_STATUS MSMFetchPCIData(MSM_API_INTERNAL_HANDLE *drvHandle)
{
   MSM_STATUS status = MSM_STATUS_SUCCESS;
   MSM_DRIVER_INFORMATION drvInfo;

   if(drvHandle == MSM_NULL)
   {
      return MSM_STATUS_CREATE(MSM_ERROR_INVALID_PARAMETER,MSM_DETAIL_NULL_DRIVER_INFO);
   }
   
   MSMMemset(&drvInfo, 0, sizeof(drvInfo));
   drvInfo.StructVersion = MSM_DRIVER_INFO_VERSION;
   drvInfo.StructSize = sizeof(drvInfo);
   if(MSMGetDriverInfo((MSM_HANDLE)drvHandle, &drvInfo) == MSM_STATUS_SUCCESS)
   {
      if(drvInfo.NumOfPCIItem > drvHandle->NumOfPCIItem)
      {
         // we must allocate/reallocate the PCI array
         if(drvHandle->PCIArray != MSM_NULL)
         {
            MSMFreeMemory(drvHandle->PCIArray);
         }
         drvHandle->PCIArray = (MSM_PCI_ITEM*)MSMAllocMemory(sizeof(MSM_PCI_ITEM) * drvInfo.NumOfPCIItem, true); 
      }

      if(drvHandle->PCIArray != MSM_NULL)
      {
         // now get the data from the driver
         MSM_IOCTL_FETCH_PCI fetchPci;

         MSM_UINT32 maxIter = (drvInfo.NumOfPCIItem / MSM_PCI_FETCH_SIZE) + (((drvInfo.NumOfPCIItem % MSM_PCI_FETCH_SIZE) == 0 ) ? 0 : 1);

         drvHandle->NumOfPCIItem = drvInfo.NumOfPCIItem;
         fetchPci.StartIndex = 0;

         while(maxIter > 0)
         {
            fetchPci.EndIndex = MSM_MIN((fetchPci.StartIndex + MSM_PCI_FETCH_SIZE), drvHandle->NumOfPCIItem) - 1;

            status = MSMDrvIoCtl(drvHandle,MSM_CONTROL_FETCH_PCI, &fetchPci, sizeof(fetchPci), &fetchPci, sizeof(fetchPci));

            if(status != MSM_STATUS_SUCCESS)
               break;

            MSMInternalMemcpy(&drvHandle->PCIArray[fetchPci.StartIndex], fetchPci.PCIItem, sizeof(MSM_PCI_ITEM) * (fetchPci.EndIndex - fetchPci.StartIndex + 1));

            fetchPci.StartIndex += MSM_PCI_FETCH_SIZE;
            maxIter--;
         }


         if(status != MSM_STATUS_SUCCESS)
         {
            drvHandle->NumOfPCIItem = 0;
            drvHandle->PCIArray = MSM_NULL;
         }

      }
      else
      {
         drvHandle->NumOfPCIItem = 0;
      }
   }
  
   return status;
}

#if MSM_API_USE_WINDOWS && MSM_API_USER_CODE // For now, will bring it to the other OS/mode later
//--------------------------------------------------------------
//
// Name:       MSMAllocControlRegistry
//
// Description: allocate and init the data structure to pass to the driver
//
// Parameters: Opcode: the registry function to perform
//             RegHandle: registry handle
//             Mode: the mode argument
//             RegType: the type of the registry entry
//             Name: the name of the key or value
//             DataSize: the number of bytes for the input/output data
//             Data: pointer to the data region
//             CopyData: indicates if we copy the data in the structure
//             RegSize: pointer to receive the size of the allocated structure
//
// Return:  a pointer to the newly allocated structure
//
// Notes:
//
//--------------------------------------------------------------
MSM_IOCTL_REGISTRY* MSMAllocControlRegistry(MSM_UINT64 Opcode, MSM_REGHANDLE RegHandle, MSM_UINT64 Mode, MSM_REGTYPE RegType, const MSM_CHAR* Name, MSM_SIZE DataSize, void *Data, MSM_BOOL CopyData, MSM_UINT32 *RegSize)
{
   MSM_SIZE NameLength = 0;
   MSM_SIZE StructSize = sizeof(MSM_IOCTL_REGISTRY);
   MSM_IOCTL_REGISTRY* retSt = MSM_NULL;

   if(Name != MSM_NULL)
   {
      NameLength = (MSMStrLength(Name) + 1) * sizeof(MSM_CHAR);
   }

   StructSize += NameLength;
   StructSize += DataSize;

   retSt = (MSM_IOCTL_REGISTRY*)MSMAllocMemory(StructSize, true);

   if(retSt != MSM_NULL)
   {
      // we start with the data section 
      // this is to optimize the transfer back from the driver
      // if the name was set before the data we would have to copy
      // the name along with the data
      if(Data != MSM_NULL)
      {
         retSt->DataOffset = sizeof(MSM_IOCTL_REGISTRY);
         retSt->DataSize   = DataSize;

         if(CopyData)
         {
            unsigned char* DataPtr = (unsigned char*)retSt;
            DataPtr += retSt->DataOffset;
            MSMInternalMemcpy(DataPtr, Data, DataSize);
         }
      }

      if(Name != MSM_NULL)
      {
         retSt->NameOffset = sizeof(MSM_IOCTL_REGISTRY) + retSt->DataSize;
         retSt->NameSize   = NameLength ; // for terminating character
         unsigned char* DataPtr = (unsigned char*)retSt;
         DataPtr += retSt->NameOffset;

         MSMInternalMemcpy(DataPtr, (void*)Name, (MSM_SIZE)retSt->NameSize);
      }

      retSt->Mode       = Mode;
      retSt->RegOpcode  = Opcode;
      retSt->RegType    = RegType;

      if(RegHandle != MSM_NULL)
      {
         retSt->RegHandle  = ((MSM_REGHANDLE_INTERNAL*)RegHandle)->RegHandle;
      }
      
      *RegSize          = (MSM_UINT32)StructSize;
   }

   return retSt;
      
}

//--------------------------------------------------------------
//
// Name:       MSMStrLength
//
// Description: returns the string length
//
// Parameters: Name: a NULL terminated string
//
// Return:  the length of the string
//
// Notes:
//
//--------------------------------------------------------------
MSM_SIZE MSMStrLength(const MSM_CHAR* Name)
{
#if MSM_API_USER_CODE
#if MSM_API_USE_WINDOWS
   return wcslen((LPCWSTR)Name);
#elif MSM_API_USE_LINUX
   return strlen(Name);
#endif
#else
#if MSM_API_USE_WINDOWS
#elif MSM_API_USE_LINUX
#endif
#endif
}
#endif // MSM_API_USE_WINDOWS && MSM_API_USER_CODE


