//-----------------------------------------------
//
//  OS Specific functions
//
//-----------------------------------------------

/* Headers */
#include "osfunctions.h"

bool CreateOsMutex(OS_MUTEX *pMutex)
{
	bool RetVal = false;

	#ifdef __linux__
	if(pthread_mutex_init(pMutex, NULL) == 0)
		RetVal = true;
	#else
	if((*pMutex = CreateMutex(NULL, FALSE, NULL)) != NULL)
		RetVal = true;
	#endif

	return RetVal;
}

bool DestroyOsMutex(OS_MUTEX *pMutex)
{
	bool RetVal = false;

	#ifdef __linux__
	if(pthread_mutex_destroy(pMutex) == 0)
		RetVal = true;
	#else
	if(CloseHandle(*pMutex))
		RetVal = true;
	#endif

	return RetVal;
}

bool AcquireOsMutex(OS_MUTEX *pMutex)
{
	bool RetVal = false;

	#ifdef __linux__
	if(pthread_mutex_lock(pMutex) == 0)
		RetVal = true;
	#else
	if(WaitForSingleObject(*pMutex, INFINITE) == WAIT_OBJECT_0)
		RetVal = true;
	#endif

	return RetVal;
}

bool ReleaseOsMutex(OS_MUTEX *pMutex)
{
	bool RetVal = false;

	#ifdef __linux__
	if(pthread_mutex_unlock(pMutex) == 0)
		RetVal = true;
	#else
	if(ReleaseMutex(*pMutex))
		RetVal = true;
	#endif

	return RetVal;
}