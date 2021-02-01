/******************************************************************************
 *
 * Copyright (C) 2010 - 2015 Xilinx, Inc.  All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Use of the Software is limited solely to applications:
 * (a) running on a Xilinx device, or
 * (b) that interact with a Xilinx device through a bus or interconnect.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
 * OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 * Except as contained in this notice, the name of the Xilinx shall not be used
 * in advertising or otherwise to promote the sale, use or other dealings in
 * this Software without prior written authorization from Xilinx.
 *
 ******************************************************************************/

#include "xparameters.h"
#include "xil_cache.h"

#include "platform_config.h"

/*
 * Uncomment one of the following two lines, depending on the target,
 * if ps7/psu init source files are added in the source directory for
 * compiling example outside of SDK.
 */
/*#include "ps7_init.h"*/
/*#include "psu_init.h"*/

#ifdef STDOUT_IS_16550
#include "xuartns550_l.h"

#define UART_BAUD 9600
#endif

void enable_caches() {
#ifdef __PPC__
	Xil_ICacheEnableRegion(CACHEABLE_REGION_MASK);
	Xil_DCacheEnableRegion(CACHEABLE_REGION_MASK);
#elif __MICROBLAZE__
#ifdef XPAR_MICROBLAZE_USE_ICACHE
	Xil_ICacheEnable();
#endif
#ifdef XPAR_MICROBLAZE_USE_DCACHE
	Xil_DCacheEnable();
#endif
#endif
}

void disable_caches() {
#ifdef __MICROBLAZE__
#ifdef XPAR_MICROBLAZE_USE_DCACHE
	Xil_DCacheDisable();
#endif
#ifdef XPAR_MICROBLAZE_USE_ICACHE
	Xil_ICacheDisable();
#endif
#endif
}

void init_uart() {
#ifdef STDOUT_IS_16550
	XUartNs550_SetBaud(STDOUT_BASEADDR, XPAR_XUARTNS550_CLOCK_HZ, UART_BAUD);
	XUartNs550_SetLineControlReg(STDOUT_BASEADDR, XUN_LCR_8_DATA_BITS);
#endif
	/* Bootrom/BSP configures PS7/PSU UART to 115200 bps */
}

void init_platform() {
	/*
	 * If you want to run this example outside of SDK,
	 * uncomment one of the following two lines and also #include "ps7_init.h"
	 * or #include "ps7_init.h" at the top, depending on the target.
	 * Make sure that the ps7/psu_init.c and ps7/psu_init.h files are included
	 * along with this example source files for compilation.
	 */
	/* ps7_init();*/
	/* psu_init();*/
	//enable_caches();
	// init_uart();
	//init_rpc2_ctrl();
}

void cleanup_platform() {
	disable_caches();
}

int init_rpc2_ctrl() {
	print("Initializing HyperRam controller\n\r");

	////////////////////////////////////////////////////////
	// Read the status register as a sanity check
	////////////////////////////////////////////////////////
	get_rpc2_ctrl_status();

	////////////////////////////////////////////////////////
	// Set the memory controller in Hyperram mode
	////////////////////////////////////////////////////////
	setHYPERBUSI_MCR(XPAR_RPC2_CTRL_CONTROLLER_0_AXI_REG_BASEADDR, DEVTYPE_BIT,
	CS0_SEL);
	DWORD *reg_value = NULL;
	getHYPERBUSI_MCR(XPAR_RPC2_CTRL_CONTROLLER_0_AXI_REG_BASEADDR, reg_value,
	CS0_SEL);
	if (*reg_value != DEVTYPE_BIT) {
		print("MCR register is not configured for Hyper Ram\n\r");
		return XST_FAILURE;
	}

	////////////////////////////////////////////////////////
	// Set the latency timer to 6 clock cycles
	////////////////////////////////////////////////////////
	setHYPERBUSI_MTR(XPAR_RPC2_CTRL_CONTROLLER_0_AXI_REG_BASEADDR, BIT0,
	CS0_SEL);
	getHYPERBUSI_MTR(XPAR_RPC2_CTRL_CONTROLLER_0_AXI_REG_BASEADDR, reg_value,
	CS0_SEL);
	if (*reg_value != BIT0) {
		print("MTR register is not configured for Latency 6 clock cycles\n\r");
		return XST_FAILURE;
	}

	////////////////////////////////////////////////////////
	// Configure the memory chip configuration register
	////////////////////////////////////////////////////////
	// Enable Hyper ram configuration space MCR(5) = '1'
	setHYPERBUSI_MCR_CRT(XPAR_RPC2_CTRL_CONTROLLER_0_AXI_REG_BASEADDR, 1,
			CS0_SEL);
	getHYPERBUSI_MCR_CRT(XPAR_RPC2_CTRL_CONTROLLER_0_AXI_REG_BASEADDR,
			reg_value, CS0_SEL);
	if (*reg_value != BIT0) {
		print("MCR register is not configured to access memory configuration register\n\r");
		return XST_FAILURE;
	}


	////////////////////////////////////////////////////////
	// Memory read manufacturer ID
	////////////////////////////////////////////////////////
	u32 *memory_base_addr = 0x80000000;
	u32 *hyperram_reg_id0 = memory_base_addr + 0x00000000;
	u32 *hyperram_reg_cfg0 = memory_base_addr + (0x00001000)/4;
	u32 WordMem32;

	WordMem32 = *(hyperram_reg_id0);
	WordMem32 = *(hyperram_reg_cfg0);

	*(hyperram_reg_cfg0) = (WordMem32 & ~3) | 0x1;
	WordMem32 = *(hyperram_reg_cfg0);

	// Enable Hyper ram configuration space MCR(5) = '0'
	setHYPERBUSI_MCR_CRT(XPAR_RPC2_CTRL_CONTROLLER_0_AXI_REG_BASEADDR, 0,
			CS0_SEL);
	getHYPERBUSI_MCR_CRT(XPAR_RPC2_CTRL_CONTROLLER_0_AXI_REG_BASEADDR,
			reg_value, CS0_SEL);
	if (*reg_value != 0) {
		print("MCR register is not configured to access memory space\n\r");
		return XST_FAILURE;
	}

	////////////////////////////////////////////////////////
	// Read the status register as a sanity check
	////////////////////////////////////////////////////////
	return get_rpc2_ctrl_status();

}

int get_rpc2_ctrl_status() {
	DWORD *reg_value = NULL;

	getHYPERBUSI_CSR(XPAR_RPC2_CTRL_CONTROLLER_0_AXI_REG_BASEADDR, reg_value);
	if (*reg_value != 0x0) {
		xil_printf("CSR status register errors : 0x%08x\n\r", *reg_value);
		return XST_FAILURE;
	}
	xil_printf("CSR status register : 0x%08x\n\r", *reg_value);

	return XST_SUCCESS;
}

