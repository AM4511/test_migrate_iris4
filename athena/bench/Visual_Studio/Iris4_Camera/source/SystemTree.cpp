// 
//

#define _CRT_SECURE_NO_DEPRECATE

#include "stdafx.h"
#include <stdio.h> 
#include <stdlib.h> 
#include <conio.h> 
#include <time.h>
#include <string>


#include "SystemTree.h"
#include "mtxservmanager.h"

#include <iostream>
#include <algorithm>
#include <vector>


//------------------------------------
// Look for specific FPGA in the system
//------------------------------------
M_UINT32 FindFpga(M_UINT32 vendorID, M_UINT32 devID)
   {
   //---------------------
   // FIND FPGA vars 
   //---------------------
   MSM_HANDLE MSMHandle = NULL;
   MSM_UINT32 PhyRefReg;
   MSM_UINT32 SubsystemID = 0;
   int fpga_founded = 0;

   MSMAttach(&MSMHandle);
   if(MSMHandle != NULL)
      {
      MSM_UINT8 bus = 0, dev = 0, func = 0;
      printf("\n");

      bus = 0;
      dev = 0;
      func = 0;
      MSMFindDevice(MSMHandle, vendorID, devID, &bus, &dev, &func, 0);
      MSMReadConfig(MSMHandle, bus, dev, func, 0x10, 1, &PhyRefReg);       // [Base Address 0]

      MSMReadConfig(MSMHandle, bus, dev, func, 0x2c, 1, &SubsystemID);  // [SubsystemID & SubsystemVendorID]
      PhyRefReg = PhyRefReg & 0xFFFFFFF0;

      if((SubsystemID & 0xffff) == 0x102b)
         { //fpga founded
         fpga_founded = 1;
		 printf("Found FPGA %X:%X %d: b:%x, d%x, f%x, BAR0=0x%x \n", vendorID, devID,0, bus, dev, func, PhyRefReg);
         return(PhyRefReg);
         }
      else return(0);
      }
   else return(0);
   }


//------------------------------------
// Look for specific FPGA in the system
//------------------------------------
M_UINT8 FindMultiFpga(M_UINT32 vendorID, M_UINT32 devID, Struck_FPGAs FPGAs[])
	{
	//---------------------
	// FIND FPGA vars 
	//---------------------
	
	//struct Struck_FPGAs FPGAs[8];

	
	MSM_HANDLE MSMHandle = NULL;

	MSM_UINT32 SubsystemID = 0;
	int fpga_founded = 0;

	MSMAttach(&MSMHandle);
	if(MSMHandle != NULL)
		{
		printf("\n");

		for(int i = 0; i < 16; i++)
			{
			MSMFindDevice(MSMHandle, vendorID, devID, &FPGAs[i].bus, &FPGAs[i].dev, &FPGAs[i].func, i);
		
			MSMReadConfig(MSMHandle, FPGAs[i].bus, FPGAs[i].dev, FPGAs[i].func, 0x10, 1, &FPGAs[i].PhyRefReg_BAR0);  // [Base Address 0]
			MSMReadConfig(MSMHandle, FPGAs[i].bus, FPGAs[i].dev, FPGAs[i].func, 0x18, 1, &FPGAs[i].PhyRefReg_BAR1);  // [Base Address 1]
			MSMReadConfig(MSMHandle, FPGAs[i].bus, FPGAs[i].dev, FPGAs[i].func, 0x20, 1, &FPGAs[i].PhyRefReg_BAR2);  // [Base Address 2]
			
			FPGAs[i].PhyRefReg_BAR0 = FPGAs[i].PhyRefReg_BAR0 & 0xFFFFFFF0;
			FPGAs[i].PhyRefReg_BAR1 = FPGAs[i].PhyRefReg_BAR1 & 0xFFFFFFF0;
			FPGAs[i].PhyRefReg_BAR2 = FPGAs[i].PhyRefReg_BAR2 & 0xFFFFFFF0;

			MSMReadConfig(MSMHandle, FPGAs[i].bus, FPGAs[i].dev, FPGAs[i].func, 0x00, 1, &FPGAs[i].DevID);        // [DevID & SubsystemVendorID]
			MSMReadConfig(MSMHandle, FPGAs[i].bus, FPGAs[i].dev, FPGAs[i].func, 0x2c, 1, &FPGAs[i].SubsystemID);  // [SubsystemID & SubsystemVendorID]

			FPGAs[i].VenID       = (FPGAs[i].DevID & 0x0000ffff);
			FPGAs[i].DevID       = (FPGAs[i].DevID & 0xffff0000) >> 16;
			FPGAs[i].SubsystemID = (FPGAs[i].SubsystemID & 0xffff0000) >> 16;

			MSMReadConfig(MSMHandle, FPGAs[i].bus, FPGAs[i].dev, FPGAs[i].func, 0x50, 1, &FPGAs[i].LinkStatusReg);  // [Link status register]
			MSMReadConfig(MSMHandle, FPGAs[i].bus, FPGAs[i].dev, FPGAs[i].func, 0x18, 1, &FPGAs[i].BusNum);  // [Link Bus numbers]


			if(FPGAs[i].DevID == devID)
			     { //fpga founded
			       fpga_founded++;
				   if(FPGAs[i].DevID == devID)
				     printf("Found GTR ATHENA FPGA %X.%X.%X    B:%x, D%x, F%x,  BAR0=0x%08x \n", vendorID, devID, FPGAs[i].SubsystemID, FPGAs[i].bus, FPGAs[i].dev, FPGAs[i].func, FPGAs[i].PhyRefReg_BAR0);
				   //if(FPGAs[i].DevID == 0x5300)
				   // printf("(%d) Found N3 ANPUT FPGA %X.%X.%X    B:%x, D%x, F%x,  BAR0=0x%08x,  BAR1=0x%08x \n",i+1, vendorID, devID, FPGAs[i].SubsystemID, FPGAs[i].bus, FPGAs[i].dev, FPGAs[i].func, FPGAs[i].PhyRefReg_BAR0, FPGAs[i].PhyRefReg_BAR1);
				   if(FPGAs[i].DevID == 0x806A || FPGAs[i].DevID == 0x808c)
					   {
					   printf("Found IDT Bridge %X.%X    B:%x, D%x, F%x, PrimBusNo:%d, SecBusNo:%d,  ", vendorID, devID, FPGAs[i].bus, FPGAs[i].dev, FPGAs[i].func, FPGAs[i].BusNum & 0xff, ((FPGAs[i].BusNum)>>8) & 0xff);
				   
					   printf("Primary PCIe is set in G%dx%d \n", ((FPGAs[i].LinkStatusReg) >> 16) & 0x3, ((FPGAs[i].LinkStatusReg) >> 20) & 0x3f);
					   

					   }

			     }
			}

		return(fpga_founded);
		
		}
	else return(0);
	}


//------------------------------------
// Look for specific FPGA in the system
//------------------------------------
int FpgaPCIeConfig(M_UINT32 vendorID, M_UINT32 devID)
{
	//---------------------
	// FIND FPGA vars 
	//---------------------
	MSM_HANDLE MSMHandle = NULL;
	MSM_UINT32 LinkStatus;
    MSM_UINT32 MasterBit = 0x100007;
	MSMAttach(&MSMHandle);
	if (MSMHandle != NULL)
	{
		MSM_UINT8 bus = 0, dev = 0, func = 0;
		bus = 0;
		dev = 0;
		func = 0;
		MSMFindDevice(MSMHandle, vendorID, devID, &bus, &dev, &func, 0);
		MSMReadConfig(MSMHandle, bus, dev, func, 0x70, 1, &LinkStatus);       // [link Status]
        MSMWriteConfig(MSMHandle, bus, dev, func, 0x04, 1, &MasterBit);

		if ((LinkStatus & 0xff0000) == 0x110000)     { printf("\nUsed FPGA is set in PCIE Gen1 x1\n"); return(0); }   // G1 x1
		else if ((LinkStatus & 0xff0000) == 0x120000){ printf("\nUsed FPGA is set in PCIE Gen2 x1\n"); return(1); }   // G2 x1
        else if ((LinkStatus & 0xff0000) == 0x210000){ printf("\nUsed FPGA is set in PCIE Gen1 x2\n"); return(2); }   // G1 x2
		else if ((LinkStatus & 0xff0000) == 0x220000){ printf("\nUsed FPGA is set in PCIE Gen2 x2\n"); return(3); }   // G2 x2
		else return(0);
			
	}
	else return(0);
}


int MultiFpgaPCIeConfig(M_UINT8 FPGA_used, Struck_FPGAs FPGAs[])
	{
	//---------------------
	// FIND FPGA vars 
	//---------------------
	MSM_HANDLE MSMHandle = NULL;
	MSM_UINT32 LinkStatus;
	MSM_UINT32 MasterBit = 0x100007;
	MSMAttach(&MSMHandle);
	if(MSMHandle != NULL)
		{
		MSM_UINT8 bus = 0, dev = 0, func = 0;
		bus = 0;
		dev = 0;
		func = 0;
		MSMReadConfig(MSMHandle,  FPGAs[FPGA_used].bus, FPGAs[FPGA_used].dev, FPGAs[FPGA_used].func, 0x70, 1, &LinkStatus);       // [link Status]
		MSMWriteConfig(MSMHandle, FPGAs[FPGA_used].bus, FPGAs[FPGA_used].dev, FPGAs[FPGA_used].func, 0x04, 1, &MasterBit);

		if((LinkStatus & 0xff0000)      == 0x110000) { printf("\nFPGA is set in PCIE Gen1 x1\n"); return(0); }   // G1 x1
		else if((LinkStatus & 0xff0000) == 0x120000) { printf("\nFPGA is set in PCIE Gen2 x1\n"); return(1); }   // G2 x1
		else if((LinkStatus & 0xff0000) == 0x210000) { printf("\nFPGA is set in PCIE Gen1 x2\n"); return(2); }   // G1 x2
		else if((LinkStatus & 0xff0000) == 0x220000) { printf("\nFPGA is set in PCIE Gen2 x2\n"); return(3); }   // G2 x2
		else return(0);

		}
	else return(0);
	}

