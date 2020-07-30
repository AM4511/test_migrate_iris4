// osincludes.h

#pragma once
#ifndef _OSINCLUDES_
#define _OSINCLUDES_


#include <stdio.h> 
#include <stdlib.h> 

#ifdef __linux__

#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <string.h>

#define DWORD       uint32_t
#define BYTE        uint8_t
#define BOOL        uint8_t
#define WINAPI 
#define LPVOID      void*
#define HANDLE      void*
#define INFINITE    0xFFFFFFFF
#define RETTHREAD   void*
#define WCHAR       wchar_t

#define TRUE        1
#define FALSE       0

#define MAX_PATH    512

// For MosGetch and MosKbhit
#include "mil.h"

#define _getch      MosGetch
#define _kbhit      MosKbhit

#define scanf_s     scanf

#define Sleep(n)    usleep(n*1000)

#else

#include "stdafx.h"
#include <conio.h> 
#include <Windows.h>
#include <process.h>

#endif

#include <time.h>
#include <math.h>


#endif // _OSINCLUDES_