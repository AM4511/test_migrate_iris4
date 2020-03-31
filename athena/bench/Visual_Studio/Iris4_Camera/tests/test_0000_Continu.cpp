//-----------------------------------------------
//
//  Simple continu test grab Iris4
//
//-----------------------------------------------

/* Headers */
#include <stdio.h> 
#include <stdlib.h> 
#include <conio.h> 
#include <time.h>
#include <math.h>
#include <Windows.h>
#include <mil.h>

#include "MilLayer.h"
#include "XGS_Ctrl.h"


void test_0000_Continu(CXGS_Ctrl* Camera)
   {
	
	M_UINT32 data = Camera->ReadSPI(0x0);

	printf("hello world 0x%X", data);
	
   }



