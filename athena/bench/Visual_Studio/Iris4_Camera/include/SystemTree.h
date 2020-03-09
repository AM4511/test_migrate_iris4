


#include <math.h>
#include <vector>
#include "mbasictypes.h"

struct Struck_FPGAs
	{
	M_UINT8  bus=0; 
	M_UINT8  dev=0;
	M_UINT8  func=0;
	M_UINT32 VenID = 0;
	M_UINT32 DevID = 0;
	M_UINT32 SubsystemID = 0;
	M_UINT32 PhyRefReg_BAR0=0;
	M_UINT32 PhyRefReg_BAR1=0;
	M_UINT32 PhyRefReg_BAR2= 0;
	M_UINT32 LinkStatusReg = 0;
	M_UINT32 BusNum = 0;

	} ;

M_UINT32 FindFpga(M_UINT32 vendorID, M_UINT32 devID);
M_UINT8 FindMultiFpga(M_UINT32 vendorID, M_UINT32 devID, Struck_FPGAs FPGAs[]);
int FpgaPCIeConfig(M_UINT32 vendorID, M_UINT32 devID);
int MultiFpgaPCIeConfig(M_UINT8 FPGA_used , Struck_FPGAs FPGAs[]);

