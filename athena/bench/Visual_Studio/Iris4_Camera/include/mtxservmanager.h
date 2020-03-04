/*

Copyright (c) Matrox Electronic Systems. All rights reserved.

Module Name:

 mtxservmanager.h

Abstract:

    This header will declare the C API (Application Programming Interface)
    for the mtxservmanager (Matrox Services manager) driver.

Revision History:

--*/

#ifndef __MTXSERVMANAGER_API_H__
#define __MTXSERVMANAGER_API_H__

// Generate environment define

#if defined(_WIN32)

#define MSM_API_USE_WINDOWS   1
#define MSM_API_USE_LINUX     0

#elif defined(__linux__)

#define MSM_API_USE_WINDOWS   0
#define MSM_API_USE_LINUX     1

#else

#error "Unknown Operating System"

#endif

// now check for 32/64 bits

#if defined(_WIN64) || defined(__LP64__) || defined(__x86_64__)

#define MSM_API_USE_64BIT     1

#else

#define MSM_API_USE_64BIT     0

#endif

// now check if we are in user or driver mode

#if defined(DRIVER_CODE) || defined(_IM_DRIVER_CODE)   // this define will be present in the driver building script

#define MSM_API_DRIVER_CODE       1
#define MSM_API_USER_CODE         0

#else

#define MSM_API_DRIVER_CODE       0
#define MSM_API_USER_CODE         1

#endif

#if MSM_API_USE_WINDOWS
#define MSM_UNUSED_ARG(VAR)   VAR
#else
#define MSM_UNUSED_ARG(VAR)
#endif

// type definition
#ifndef __LIC_STRUCT_H__
typedef unsigned char      MSM_UINT8;
typedef char               MSM_INT8;
typedef unsigned short     MSM_UINT16;
typedef int                MSM_INT32;
typedef unsigned int       MSM_UINT32;

#if MSM_API_USE_64BIT && MSM_API_USE_LINUX
typedef long               MSM_INT64;
typedef unsigned long      MSM_UINT64;
#else
typedef long long          MSM_INT64;
typedef unsigned long long MSM_UINT64;
#endif
#endif // __LIC_STRUCT_H__

#if MSM_API_USE_64BIT
typedef MSM_UINT64       MSM_UINTPTR;
typedef MSM_UINT64       MSM_SIZE;
#else
typedef MSM_UINT32       MSM_UINTPTR;
typedef MSM_UINT32       MSM_SIZE;
#endif

typedef void*        MSM_HANDLE; // the MtxServManager handle is an hidden structure
typedef MSM_HANDLE*  PMSM_HANDLE;

// for the names, we must keep the case identical
#if MSM_API_USER_CODE

#if MSM_API_USE_WINDOWS
#define MSM_KERNEL_NAME    
#define MSM_USER_NAME      "\\\\.\\mtxservmanager"

#elif MSM_API_USE_LINUX
#define MSM_KERNEL_NAME    "/dev/mil/mtxservmanager"
#define MSM_USER_NAME      MSM_KERNEL_NAME
#endif

#elif MSM_API_DRIVER_CODE

#if MSM_API_USE_WINDOWS

#define MSM_KERNEL_NAME    L"\\Device\\mtxservmanager"
#define MSM_USER_NAME      L"\\DosDevices\\mtxservmanager"

#elif MSM_API_USE_LINUX
#define MSM_KERNEL_NAME    "/dev/mil/mtxservmanager"
#define MSM_USER_NAME      MSM_KERNEL_NAME
#endif
#endif


#if MSM_API_USE_WINDOWS
#include <wchar.h>
#define MSM_TEXT(quote) L ## quote
typedef wchar_t    MSM_CHAR;
#else
#define MSM_TEXT(quote) quote
typedef char         MSM_CHAR;
#endif

typedef MSM_UINT64   MSM_STATUS;
typedef MSM_UINT64   MSM_REGOSHANDLE;
typedef MSM_UINT32   MSM_REGTYPE;

#define MSM_REGHANDLE_FLAG_USER     1
typedef struct _MSM_REGHANDLE_INTERNAL
{
   MSM_REGOSHANDLE   RegHandle;
   MSM_UINT64        Flags;
} MSM_REGHANDLE_INTERNAL;

typedef void* MSM_REGHANDLE;

#ifdef __cplusplus
typedef bool MSM_BOOL;
#define MSM_NULL     0
#else
typedef int  MSM_BOOL;
#define true         1
#define false        0
#define MSM_NULL     ((void*)0)
#endif

// status code macros
#define MSM_STATUS_EXTRACT_ERROR(S)           (S & 0xffff0000)
#define MSM_STATUS_EXTRACT_DETAIL(S)          (S & 0x0000ffff)
#define MSM_STATUS_CREATE(S, D)            ((MSM_STATUS)((S & 0xffff0000) | (D & 0x0000ffff)))

#ifndef MSM_MAX
#define MSM_MAX(a,b)            (((a) > (b)) ? (a) : (b))
#endif

#ifndef MSM_MIN
#define MSM_MIN(a,b)            (((a) < (b)) ? (a) : (b))
#endif


// value definitions

// MAJOR status code

// when the upper 16 bit are 0, we have special code that will start with MSM_STATUS_
#define MSM_STATUS_SUCCESS                   0x00000000
#define MSM_STATUS_NO_DEVICE                 0x00000001
#define MSM_STATUS_MORE_DATA                 0x00000002
#define MSM_STATUS_DONT_EXIST                0x00000003
#define MSM_STATUS_PRIVATE_DATA_NOT_PRESENT  0x00000004
#define MSM_STATUS_NOT_PCIE                  0x00000005
#define MSM_STATUS_ASPM_ALREADY_CLEARED      0x00000006

#define MSM_ERROR_INVALID_HANDLE             0x00010000
#define MSM_ERROR_CANNOT_CREATE_HANDLE       0x00020000
#define MSM_ERROR_OS_ERROR                   0x00030000
#define MSM_ERROR_INVALID_PARAMETER          0x00040000
#define MSM_ERROR_OUT_OF_MEMORY              0x00080000
#define MSM_ERROR_REGISTRY                   0x00100000

// MINOR status code (code 0 is reserved for MSM_STATUS_SUCCESS)
#define MSM_DETAIL_DRIVER_HANDLE             0x00000001
#define MSM_DETAIL_OUT_OF_MEMORY             0x00000002
#define MSM_DETAIL_CANNOT_OPEN_DRIVER        0x00000003
#define MSM_DETAIL_IO_CONTROL                0x00000004
#define MSM_DETAIL_NULL_DATA_POINTER         0x00000005
#define MSM_DETAIL_NON_4_MULT_REG_NB         0x00000006
#define MSM_DETAIL_TOO_MANY_REGISTERS        0x00000007
#define MSM_DETAIL_OUT_OF_BOUND              0x00000008
#define MSM_DETAIL_NULL_BUS_NUMBER           0x00000009
#define MSM_DETAIL_NULL_DEVICE_NUMBER        0x0000000A
#define MSM_DETAIL_NULL_FUNCTION_NUMBER      0x0000000B
#define MSM_DETAIL_NULL_BAR_SIZE             0x0000000C
#define MSM_DETAIL_NULL_NAME                 0x0000000D
#define MSM_DETAIL_NULL_BAR_ADDRESS          0x0000000E
#define MSM_DETAIL_NAME_TOO_LONG             0x0000000F
#define MSM_DETAIL_NULL_LICENSE_MASK         0x00000010
#define MSM_DETAIL_NULL_LICENSE_INFO         0x00000011
#define MSM_DETAIL_INEXISTANT_BUS            0x00000012
#define MSM_DETAIL_INEXISTANT_DEVICE         0x00000013
#define MSM_DETAIL_CANNOT_OPEN_REGISTRY_KEY  0x00000014
#define MSM_DETAIL_CANNOT_QUERY_REGISTRY_KEY 0x00000015
#define MSM_DETAIL_NO_RESOURCES_FOUND        0x00000016
#define MSM_DETAIL_NO_LICENSE_FOR_BOARD      0x00000017
#define MSM_DETAIL_INVALID_BOARD_TYPE        0x00000018
#define MSM_DETAIL_NULL_DRIVER_INFO          0x00000019
#define MSM_DETAIL_NOT_SUPPORTED             0x0000001A
#define MSM_DETAIL_INVALID_ROOT              0x0000001B
#define MSM_DETAIL_REGISTRY_HANDLE           0x0000001C
#define MSM_DETAIL_NULL_SIZE                 0x0000001D
#define MSM_DETAIL_UNKNOWN_REG_TYPE          0x0000001E
#define MSM_DETAIL_INVALID_REG_TYPE          0x0000001F
#define MSM_DETAIL_CANNOT_WRITE_REGISTRY_KEY 0x00000020
#define MSM_DETAIL_CANNOT_DELETE_VALUE       0x00000021
#define MSM_DETAIL_REGISTRY_OPCODE           0x00000022
#define MSM_DETAIL_REGISTRY_DATA             0x00000023
#define MSM_DETAIL_CANNOT_CLOSE_REGISTRY_KEY 0x00000024
#define MSM_DETAIL_CANNOT_DELETE_KEY         0x00000025
#define MSM_DETAIL_NULL_HANDLE               0x00000026
#define MSM_DETAIL_BAD_FLAGS                 0x00000027
#define MSM_DETAIL_INVALID_MODE              0x00000028
#define MSM_DETAIL_SYSCALL_FAILED            0x00000029
#define MSM_DETAIL_BAD_IRQL                  0x0000002A
#define MSM_DETAIL_ASPM_FAILED               0x0000002B
#define MSM_DETAIL_OUTPUT_TOO_SMALL          0x0000002C


// control codes
#if MSM_API_USE_LINUX
#include <asm/ioctl.h>
typedef struct _MtxServMsgPack
{
   void*       send;      // data send to kernel
   void*       receive;   // data returned from kernel
   MSM_UINT32  inSize;    // data size of send msg
   MSM_UINT32  outSize;   // data size of returned msg
   MSM_UINT32  iocode;
}MtxServMsgPack;

#define MSM_LINUX_CONTROL_ID           0xF1
#define MSM_LINUX_CONTROL              _IOWR(MSM_LINUX_CONTROL_ID, 0, struct _MtxServMsgPack)
#endif

#define MSM_MAGIC_NUMBER               0
#define MSM_MAKE_VALID_IOCTL(A)        (MSM_MAGIC_NUMBER | A)

#define MSM_CONTROL_READ_CONFIG        MSM_MAKE_VALID_IOCTL(0)
#define MSM_CONTROL_WRITE_CONFIG       MSM_MAKE_VALID_IOCTL(1)
#define MSM_CONTROL_FIND_DEVICE        MSM_MAKE_VALID_IOCTL(2)
#define MSM_CONTROL_GET_SIZE           MSM_MAKE_VALID_IOCTL(3)
#define MSM_CONTROL_GET_SIZE_REG       MSM_MAKE_VALID_IOCTL(4)
#define MSM_CONTROL_DEPRECATED_FUNC    MSM_MAKE_VALID_IOCTL(5) //GetLicenseMask is deprecated and has been replaced by GetLicensesMasks
#define MSM_CONTROL_GET_LICENSE        MSM_MAKE_VALID_IOCTL(6)
#define MSM_CONTROL_ADD_LICENSE        MSM_MAKE_VALID_IOCTL(7)
#define MSM_CONTROL_GET_DRIVER_INFO    MSM_MAKE_VALID_IOCTL(8)
#define MSM_CONTROL_RESCAN_PCI         MSM_MAKE_VALID_IOCTL(9)
#define MSM_CONTROL_FETCH_PCI          MSM_MAKE_VALID_IOCTL(10)
#define MSM_CONTROL_REGISTRY           MSM_MAKE_VALID_IOCTL(11)
#define MSM_CONTROL_GET_DEV_INFO       MSM_MAKE_VALID_IOCTL(12)
#define MSM_CONTROL_PUT_DEV_INFO       MSM_MAKE_VALID_IOCTL(13)
#define MSM_CONTROL_IO_ACCESS          MSM_MAKE_VALID_IOCTL(14)
#define MSM_CONTROL_MSR_ACCESS         MSM_MAKE_VALID_IOCTL(15)
#define MSM_CONTROL_GET_LICENSES_MASK  MSM_MAKE_VALID_IOCTL(16)
#define MSM_CONTROL_ASPM_ACCESS        MSM_MAKE_VALID_IOCTL(17)

// version information
#define MSM_DRIVER_INFO_VERSION1       1
#define MSM_DRIVER_INFO_VERSION2       2
#define MSM_DRIVER_INFO_VERSION3       3
#define MSM_DRIVER_INFO_VERSION4       4

#define MSM_DRIVER_INFO_VERSION        MSM_DRIVER_INFO_VERSION4

#define MSM_DRIVER_MINOR_VERSION       2
#define MSM_DRIVER_MAJOR_VERSION       10 // increment the major version only with an API modification
#define MSM_DRIVER_VERSION             ((MSM_DRIVER_MAJOR_VERSION << 16) + MSM_DRIVER_MINOR_VERSION)

#define MSM_DRIVER_GET_MAJOR_VERSION(V)   ((V >> 16) & 0xffff)
#define MSM_DRIVER_GET_MINOR_VERSION(V)   (V & 0xffff)

// registry flags

// MSMRegOpenKey Mode:
#define MSM_REG_READ                0  // by default, we are always on read access. The define exists only for readability
#define MSM_REG_WRITE               0x10000
#define MSM_REG_VOLATILE            0x20000
#define MSM_REG_CREATE              0x40000
#define MSM_REG_USER_MODE           0x80000

#define MSM_REG_LOCAL_MACHINE       0
#define MSM_REG_CURRENT_USER        (1 | MSM_REG_USER_MODE)   // for all key that is not accessible by the driver, or this flag
// #define MSM_REG_ ROOTNAME        2 - 0xFFFF  (we reserve 16 bits for future predefine value)
//                                  for example, the root of the driver registry tree
#define MSM_REG_ROOTNAME_MASK       0xFFFF

// Registry type
#define MSM_REG_ANY                 0
#define MSM_REG_DWORD               1
#define MSM_REG_QWORD               2
#define MSM_REG_STRING              3
#define MSM_REG_STRING_EXPAND       4
#define MSM_REG_BINARY              5
#define MSM_REG_UNKNOWN             6

// Opcode Values
#define MSM_REG_OPEN                0
#define MSM_REG_CLOSE               1
#define MSM_REG_READ_VALUE          2
#define MSM_REG_WRITE_VALUE         3
#define MSM_REG_DELETE_KEY          4
#define MSM_REG_DELETE_VALUE        5
#define MSM_REG_VALUE_EXISTS        6

// IO Operation modes
#define MSM_IO_OP_READ_BYTE         0
#define MSM_IO_OP_READ_WORD         1
#define MSM_IO_OP_READ_DWORD        2
#define MSM_IO_OP_WRITE_BYTE        3
#define MSM_IO_OP_WRITE_WORD        4
#define MSM_IO_OP_WRITE_DWORD       5

// MSR Operation modes
#define MSM_MSR_OP_READ             0
#define MSM_MSR_OP_WRITE            1

// ASPM operation
#define MSM_ASPM_CLEAR              0
#define MSM_ASPM_INQUIRE            1
#define MSM_ASPM_CLEAR_ALL_MATROX   2
#define MSM_ASPM_CLEAR_COND_MTX     3

// ASPM Inquire results
#define MSM_ASPM_STATE_UNDETERMINED    0
#define MSM_ASPM_STATE_ENABLED         1
#define MSM_ASPM_STATE_DISABLED        2
#define MSM_ASPM_STATE_NOT_PCIE        3
#define MSM_ASPM_STATE_PARENT_ENABLED  4


// user flags
#define MSM_FIND_DEVICE_NOT_FOUND   0
#define MSM_FIND_DEVICE_FOUND       1

#define MSM_ALL_ID                  ((MSM_UINT16)0xFFFF)

// internal flags
#define MSM_PCI_FETCH_SIZE          32

// private data flags

#define MSM_REPLACE_DATA                     1
#define MSM_APPEND_DATA                      2
#define MSM_ADD_DATA                         4

#define MSM_SUPPORTED_PUT_DATA_FLAGS         (MSM_REPLACE_DATA /* | MSM_APPEND_DATA | MSM_ADD_DATA */ )

// Private data known values
#define MSM_GATOR_EYE_INFO                   0x1000

// various definition
#define FILE_DEVICE_SERVMNGR           0xba46
#define MSM_IOCTL_INDEX                2048
#define MSM_GET_SIZE_REG_NAME_LENGTH   256

#define MSM_MAX_BUS  255
#define MSM_MAX_DEV   32
#define MSM_MAX_FUNC   8


#if MSM_API_USE_WINDOWS

#define MSM_IOCTL_CODE(X) CTL_CODE(FILE_DEVICE_SERVMNGR, MSM_IOCTL_INDEX + X, METHOD_BUFFERED, FILE_ANY_ACCESS)
#define EXTRACT_IOCTL_SERVMNGR_CODE(x)  ((((MSM_UINT32)(x) >> 2) - MSM_IOCTL_INDEX) & 0xfff)

#endif

//#include "licstruct.h"
//typedef MSM_UINT32 DevMaskType[MAX_NUMBER_OF_EEPROM];


typedef struct _MSM_DRIVER_INFORMATION_VER1
{
   MSM_UINT32 StructVersion;
   MSM_UINT32 StructSize;
   MSM_UINT64 Version;
} MSM_DRIVER_INFORMATION_VER1;

typedef struct _MSM_DRIVER_INFORMATION_VER2
{
   MSM_UINT32 StructVersion;
   MSM_UINT32 StructSize;
   MSM_UINT64 Version;
   MSM_UINT32 NumOfPCIItem;
   MSM_UINT32 Reserved;
} MSM_DRIVER_INFORMATION_VER2;

typedef struct _MSM_DRIVER_INFORMATION_VER3
{
   MSM_UINT32 StructVersion;
   MSM_UINT32 StructSize;
   MSM_UINT64 Version;
   MSM_UINT32 NumOfPCIItem;
   MSM_UINT32 SleepCounter;
   MSM_UINT64 DriverStartTime;
   MSM_UINT64 LastLicenseInvalidate;
} MSM_DRIVER_INFORMATION_VER3;

typedef struct _MSM_DRIVER_INFORMATION_VER4
   {
   MSM_UINT32 StructVersion;
   MSM_UINT32 StructSize;
   MSM_UINT64 Version;
   MSM_UINT32 NumOfPCIItem;
   MSM_UINT32 SleepCounter;
   MSM_UINT64 DriverStartTime;
   MSM_UINT64 LastLicenseInvalidate;
   MSM_UINT64 LowestPCIAddress;
   } MSM_DRIVER_INFORMATION_VER4;

typedef MSM_DRIVER_INFORMATION_VER4 MSM_DRIVER_INFORMATION;

typedef struct _MSM_PCI_ITEM
{
   MSM_UINT16  VendorId;
   MSM_UINT16  DeviceId;
   MSM_UINT16  SubSystemId;
   MSM_UINT16  SubVendorId;
   MSM_UINT8   BusNb;
   MSM_UINT8   DevNb;
   MSM_UINT8   FuncNb;
   MSM_UINT8   SecBusNb;   // 0 if not a bridge
} MSM_PCI_ITEM;
// structure definition for the user/kernel interface

typedef struct _MSM_IOCTL_CONFIG_ACCESS
{
   MSM_UINT32  Data[64];
   MSM_STATUS  IOStatus;
   MSM_UINT8   BusNb;
   MSM_UINT8   DevNb;
   MSM_UINT8   FuncNb;
   MSM_UINT8   RegNb;
   MSM_UINT8   NumOfReg;
   MSM_UINT8   Reserved[3];   // to pad the structure to a multiple of 4 bytes
} MSM_IOCTL_CONFIG_ACCESS;

typedef struct _MSM_IOCTL_GETSIZE
{
   MSM_UINT64  Size;
   MSM_STATUS  IOStatus;
   MSM_UINT32  Reserved;   // for padding purposes
   MSM_UINT8   BusNb;
   MSM_UINT8   DevNb;
   MSM_UINT8   FuncNb;
   MSM_UINT8   RegNb;
} MSM_IOCTL_GETSIZE;

typedef struct _MSM_IOCTL_FIND_DEVICE
{
   MSM_STATUS  IOStatus;
   MSM_UINT32  Index;
   MSM_UINT16  VendorId;
   MSM_UINT16  DeviceId;
   MSM_UINT8   BusNb;
   MSM_UINT8   DevNb;
   MSM_UINT8   FuncNb;
   MSM_UINT8   Found;
} MSM_IOCTL_FIND_DEVICE;

typedef struct _MSM_IOCTL_RESCAN_PCI
{
   MSM_STATUS  IOStatus;
} MSM_IOCTL_RESCAN_PCI;

typedef struct _MSM_IOCTL_GET_SIZE_REG
{
   MSM_STATUS  IOStatus;
   MSM_UINT64  BarAddress[6];
   MSM_UINT64  BarSize[6];
   MSM_INT8    RegName[MSM_GET_SIZE_REG_NAME_LENGTH];
} MSM_IOCTL_GET_SIZE_REG;

//typedef struct _MSM_IOCTL_GET_LICENSE_MASK
//{
//   MSM_STATUS  IOStatus;
//   TLicenser  Mask;
//} MSM_IOCTL_GET_LICENSE_MASK;

//typedef struct _MSM_IOCTL_GET_LICENSES_MASK
//{
//   MSM_STATUS  IOStatus;
//   TLicenser   Mask;
//   MSM_UINT32  DevicesMask[MAX_NUMBER_OF_EEPROM];
//} MSM_IOCTL_GET_LICENSES_MASK;

//typedef struct _MSM_IOCTL_LICENSE_INFO
//{
//   MSM_STATUS           IOStatus;
//   MTXSER_LICENSE_INFO  LicenseInfo;
//} MSM_IOCTL_LICENSE_INFO;

typedef struct _MSM_IOCTL_DEVICE_INFO
{
   MSM_STATUS           IOStatus;
   MSM_UINT64           Length;
   MSM_UINT64           Flags;
   MSM_UINT32           DataID;
   MSM_UINT32           Data[1];
} MSM_IOCTL_PRIVATE_DATA;

typedef struct _MSM_IOCTL_GET_DRIVER_INFO
{
   MSM_UINT64  Version;
   MSM_STATUS  IOStatus;
   union _MSM_VERSIONS_DRV_INFO
   {
      MSM_DRIVER_INFORMATION_VER1   Version1;
      MSM_DRIVER_INFORMATION_VER2   Version2;
      MSM_DRIVER_INFORMATION_VER3   Version3;
      MSM_DRIVER_INFORMATION_VER4   Version4;
   } versions;
} MSM_IOCTL_GET_DRIVER_INFO;

typedef struct _MSM_IOCTL_FETCH_PCI
{
   MSM_STATUS     IOStatus;
   MSM_UINT32     StartIndex;
   MSM_UINT32     EndIndex;
   MSM_PCI_ITEM   PCIItem[MSM_PCI_FETCH_SIZE];

} MSM_IOCTL_FETCH_PCI;

typedef struct _MSM_IOCTL_REGISTRY
{
   MSM_STATUS        IOStatus;
   MSM_UINT64        RegOpcode;
   MSM_REGOSHANDLE   RegHandle;
   MSM_UINT64        Mode;
   MSM_UINT64        NameOffset;
   MSM_UINT64        NameSize;
   MSM_UINT64        DataOffset;
   MSM_UINT64        DataSize;
   MSM_REGTYPE       RegType;
   MSM_UINT32        Reserved;
} MSM_IOCTL_REGISTRY;

typedef struct _MSM_IOCTL_IO_OPERATION
{
   MSM_STATUS        IOStatus;
   MSM_UINT64        Mode;
   MSM_UINT32        IOAddress;
   MSM_UINT32        IOData;
} MSM_IOCTL_IO_OPERATION;

typedef struct _MSM_IOCTL_MSR_OPERATION
{
   MSM_STATUS        IOStatus;
   MSM_UINT64        Mode;
   MSM_UINT64        MSRData;
   MSM_UINT32        MSRAddr;
   MSM_UINT32        Reserved;
} MSM_IOCTL_MSR_OPERATION;

typedef struct _MSM_IOCTL_ASPM_OPERATION
   {
   MSM_STATUS IOStatus;
   MSM_UINT64  Operation;
   MSM_UINT32  Data;
   MSM_UINT8   BusNb;
   MSM_UINT8   DevNb;
   MSM_UINT8   FuncNb;
   MSM_UINT8   Reserved;
   } MSM_IOCTL_ASPM_OPERATION;

// function prototypes
// they will all have a C Linkage

#ifdef __cplusplus
extern "C"
{
#endif

MSM_STATUS MSMAttach(PMSM_HANDLE opMSMHandle);
MSM_STATUS MSMDetach(MSM_HANDLE iMSMHandle);
MSM_STATUS MSMReadConfig(MSM_HANDLE iMSMHandle, MSM_UINT8 iBusNb, MSM_UINT8 iDevNb, MSM_UINT8 iFuncNb, MSM_UINT8 iRegNb, MSM_UINT8 iNumRegToRead, MSM_UINT32* opReadData);
MSM_STATUS MSMWriteConfig(MSM_HANDLE iMSMHandle, MSM_UINT8 iBusNb,MSM_UINT8 iDevNb, MSM_UINT8 iFuncNb, MSM_UINT8 iRegNb, MSM_UINT8 iNumRegToWrite, MSM_UINT32* ipWriteData);
MSM_STATUS MSMFindDevice(MSM_HANDLE iMSMHandle, MSM_UINT16 iVendorId, MSM_UINT16 iDeviceId, MSM_UINT8* iopBusNb, MSM_UINT8* iopDevNb, MSM_UINT8* iopFuncNb, MSM_UINT32 iIndex);
MSM_STATUS MSMFindDeviceEx(MSM_HANDLE iMSMHandle, MSM_UINT16 iVendorId, MSM_UINT16 iDeviceId, MSM_UINT16 iSubSystemId, MSM_UINT16 iSubVendorId, MSM_UINT8* iopBusNb, MSM_UINT8* iopDevNb, MSM_UINT8* iopFuncNb, MSM_UINT32 iIndex);
MSM_STATUS MSMRescanPCI(MSM_HANDLE iMSMHandle);
MSM_STATUS MSMGetBarSize(MSM_HANDLE iMSMHandle, MSM_UINT8 iBusNb, MSM_UINT8 iDevNb, MSM_UINT8 iFuncNb, MSM_UINT8 iRegNb, MSM_UINT64 * opBarSize);
MSM_STATUS MSMGetBarSizeFromRegistry(MSM_HANDLE iMSMHandle, char* ipName, MSM_UINT64 ipBarAddress[6], MSM_UINT64 opBarSize[6]);
//MSM_STATUS MSMGetLicensesMask(MSM_HANDLE iMSMHandle, TLicenser *opMask, DevMaskType* DevicesMasks);
//MSM_STATUS MSMGetLicenseInfo(MSM_HANDLE iMSMHandle, MTXSER_LICENSE_INFO *iopLicenseInfo);
//MSM_STATUS MSMAddLicenseInfo(MSM_HANDLE iMSMHandle, MTXSER_LICENSE_INFO *ipLicenseInfo);
MSM_STATUS MSMGetDriverInfo(MSM_HANDLE iMSMHandle, MSM_DRIVER_INFORMATION *iopInfo);
MSM_STATUS MSMGetPciDeviceArray(MSM_HANDLE iMSMHandle, MSM_UINT32 *opNumDevice, MSM_PCI_ITEM **opPCIArray);
MSM_STATUS MSMPutPrivateData(MSM_HANDLE iMSMHandle, MSM_UINT32 iDataID, MSM_SIZE iLength, void* ipDataPtr, MSM_UINT64 iFlags);
MSM_STATUS MSMGetPrivateData(MSM_HANDLE iMSMHandle, MSM_UINT32 iDataID, MSM_SIZE iLength, void* opDataPtr, MSM_UINT64 iFlags, MSM_SIZE *opDataLength);
MSM_STATUS MSMIORead8(MSM_HANDLE iMSMHandle, MSM_UINT32 iAddress, MSM_UINT8 *opData);
MSM_STATUS MSMIOWrite8(MSM_HANDLE iMSMHandle, MSM_UINT32 iAddress, MSM_UINT8 iData);
MSM_STATUS MSMIORead16(MSM_HANDLE iMSMHandle, MSM_UINT32 iAddress, MSM_UINT16 *opData);
MSM_STATUS MSMIOWrite16(MSM_HANDLE iMSMHandle, MSM_UINT32 iAddress, MSM_UINT16 iData);
MSM_STATUS MSMIORead32(MSM_HANDLE iMSMHandle, MSM_UINT32 iAddress, MSM_UINT32 *opData);
MSM_STATUS MSMIOWrite32(MSM_HANDLE iMSMHandle, MSM_UINT32 iAddress, MSM_UINT32 iData);
MSM_STATUS MSMMSRWrite(MSM_HANDLE iMSMHandle, MSM_UINT32 iAddress, MSM_UINT64 iData);
MSM_STATUS MSMMSRRead(MSM_HANDLE iMSMHandle, MSM_UINT32 iAddress, MSM_UINT64 *opData);
MSM_STATUS MSMASPMControl(MSM_HANDLE iMSMHandle, MSM_UINT8 iBusNb, MSM_UINT8 iDevNb, MSM_UINT8 iFuncNb, MSM_UINT64 iCommmand, MSM_UINT32 *iopResult);

#if MSM_API_USE_WINDOWS && MSM_API_USER_CODE // For now, will bring it to the other OS/mode later
MSM_STATUS MSMRegOpenKey(MSM_HANDLE iMSMHandle, const MSM_CHAR *ipKeyName, MSM_UINT64 iMode, MSM_REGHANDLE *opRegHandle);
MSM_STATUS MSMRegCloseKey(MSM_HANDLE iMSMHandle, MSM_REGHANDLE iRegHandle);
MSM_STATUS MSMRegReadValue(MSM_HANDLE iMSMHandle, MSM_REGHANDLE iRegHandle, const MSM_CHAR *ipValueName, void *opData, MSM_SIZE *iopSize, MSM_REGTYPE *iopReadType);
MSM_STATUS MSMRegWriteValue(MSM_HANDLE iMSMHandle, MSM_REGHANDLE iRegHandle, const MSM_CHAR *ipValueName, const void *ipData, MSM_SIZE iSize, MSM_REGTYPE iWriteType);
MSM_STATUS MSMRegDeleteValue(MSM_HANDLE iMSMHandle, MSM_REGHANDLE iRegHandle, const MSM_CHAR *ipValueName);
MSM_STATUS MSMRegDeleteKey(MSM_HANDLE iMSMHandle, MSM_UINT64 iMode, const MSM_CHAR *ipKeyName);
MSM_STATUS MSMRegValueExist(MSM_HANDLE iMSMHandle, MSM_REGHANDLE iRegHandle, const MSM_CHAR *ipValueName);
#endif // MSM_API_USE_WINDOWS && MSM_API_USER_CODE

void       MSMMemset(void* dst, int data, MSM_SIZE length);

#if MSM_API_DRIVER_CODE && MSM_API_USE_LINUX
int MtxServKernelIoctl (int cmd, void *msg);
#endif

#ifdef __cplusplus
}
#endif


#endif // __MTXMEMMANAGER_API_H__
