// osfunctions.h

#pragma once
#ifndef _OSFUNCTIONS_
#define _OSFUNCTIONS_


#include <stdio.h> 
#include <stdlib.h> 

#ifdef __linux__

#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <string.h>
#include <pthread.h>

#define OS_MUTEX pthread_mutex_t

#else

#include "stdafx.h"
#include <conio.h> 
#include <Windows.h>

#define OS_MUTEX HANDLE

#endif


bool CreateOsMutex(OS_MUTEX *pMutex);
bool DestroyOsMutex(OS_MUTEX *pMutex);
bool AcquireOsMutex(OS_MUTEX *pMutex);
bool ReleaseOsMutex(OS_MUTEX *pMutex);


#endif // _OSFUNCTIONS_