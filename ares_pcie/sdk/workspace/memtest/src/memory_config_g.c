/* This file is automatically generated based on your hardware design. */
#include "memory_config.h"
#include"xstatus.h"

struct memory_range_s memory_ranges[] = {
	/* microblaze_0_local_memory_dlmb_bram_if_cntlr_Mem memory will not be tested since application resides in the same memory */
	{
		"rpc2_ctrl_controller_0_Mem",
		"rpc2_ctrl_controller_0",
		0x80000000,
		67108864,
	},
};

int init_rpc2_ctrl(){
	// Set the MCR register (DEVTYPE = Hyper Ram)
	setHYPERBUSI_MCR(XPAR_RPC2_CTRL_CONTROLLER_0_AXI_REG_BASEADDR, DEVTYPE_BIT, CS0_SEL);
	DWORD *reg_value = NULL;
	getHYPERBUSI_MCR(XPAR_RPC2_CTRL_CONTROLLER_0_AXI_REG_BASEADDR, reg_value, CS0_SEL);
	if(*reg_value != DEVTYPE_BIT){
		print("MCR register is not configured for Hyper Ram");
		return XST_FAILURE;
	}

	// Set the MTR register (Latency = 6 clock cycles)
	setHYPERBUSI_MTR(XPAR_RPC2_CTRL_CONTROLLER_0_AXI_REG_BASEADDR, BIT0, CS0_SEL);
	getHYPERBUSI_MTR(XPAR_RPC2_CTRL_CONTROLLER_0_AXI_REG_BASEADDR, reg_value, CS0_SEL);
	if(*reg_value != BIT0){
		print("MTR register is not configured for Latency 6 clock cycles");
		return XST_FAILURE;
	}
	return XST_SUCCESS;
}


int n_memory_ranges = 1;
