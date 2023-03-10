/******************************************************************************
 *
 * Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
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

#include <stdio.h>
#include <stdlib.h>
#include "xparameters.h"
#include "xil_types.h"
#include "xstatus.h"
#include "xil_testmem.h"

#include "platform.h"
#include "memory_config.h"
#include "xil_printf.h"
#include "xuartlite_l.h"

/*
 * memory_test.c: Test memory ranges present in the Hardware Design.
 *
 * This application runs with D-Caches disabled. As a result cacheline requests
 * will not be generated.
 *
 * For MicroBlaze/PowerPC, the BSP doesn't enable caches and this application
 * enables only I-Caches. For ARM, the BSP enables caches by default, so this
 * application disables D-Caches before running memory tests.
 */

void putnum(unsigned int num);

XStatus test_memory_range(struct memory_range_s *range) {
	XStatus status;

	/* This application uses print statements instead of xil_printf/printf
	 * to reduce the text size.
	 *
	 * The default linker script generated for this application does not have
	 * heap memory allocated. This implies that this program cannot use any
	 * routines that allocate memory on heap (printf is one such function).
	 * If you'd like to add such functions, then please generate a linker script
	 * that does allocate sufficient heap memory.
	 */

	print("Testing memory region: ");
	print(range->name);
	print("\n\r");
	print("    Memory Controller: ");
	print(range->ip);
	print("\n\r");
#ifdef __MICROBLAZE__
	print("         Base Address: 0x");
	putnum(range->base);
	print("\n\r");
	print("                 Size: 0x");
	putnum(range->size);
	print(" bytes \n\r");
#else
	xil_printf("         Base Address: 0x%lx \n\r",range->base);
	xil_printf("                 Size: 0x%lx bytes \n\r",range->size);
#endif

	u32 size =  0x100000;


	xil_printf("          Tested Size: 0x%08lx bytes \n\r",size);

	status = Xil_TestMem32((u32*) range->base, size/4, 0xAAAA5555,
			XIL_TESTMEM_ALLMEMTESTS);
	if (status == XST_SUCCESS) {
		print("          32-bit test: PASSED\n\r");
	} else {
		print("          32-bit test: FAILED\n\r");
		return status;
	}

	status = Xil_TestMem16((u16*) range->base, size/2, 0xAA55,
			XIL_TESTMEM_ALLMEMTESTS);
	if (status == XST_SUCCESS) {
		print("          16-bit test: PASSED\n\r");
	} else {
		print("          16-bit test: FAILED\n\r");
		return status;
	}

	status = Xil_TestMem8((u8*) range->base, size, 0xA5,
			XIL_TESTMEM_ALLMEMTESTS);
	if (status == XST_SUCCESS) {
		print("           8-bit test: PASSED\n\r");
	} else {
		print("           8-bit test: FAILED\n\r");
		return status;
	}

	return XST_SUCCESS;

}

int main() {
	XStatus status;
	int i;
	int j;
	char c;
	// Initialize the platform
	init_platform();

	// Initialize the HyperRam memory controller
	init_rpc2_ctrl();


	// Clear the terminal
    #define ASCII_ESC 27
	xil_printf( "%c[2J%c[H", ASCII_ESC , ASCII_ESC );

	//Wait for user input to start the test
	print("\r\nPlease press any key to start the HyperRam memory test application : ");
	c = getchar();

	print("\r\n\n--Starting HyperRam Memory Test Application--\n\r");
	print("NOTE: This application runs with D-Cache disabled.\n\r");
	print("As a result, cacheline requests will not be generated\n\r");

	j=0;
	while (1) {

		 if (!XUartLite_IsReceiveEmpty (STDIN_BASEADDRESS))
		 {

			    c = (char) XUartLite_RecvByte (STDIN_BASEADDRESS);
				print("\n\n\n\tPaused. Press any key to restart\n\r");
				c = getchar();
		 }

		xil_printf("\n\nTest loop : %d\n", j);
		for (i = 0; i < n_memory_ranges; i++) {
			status = test_memory_range(&memory_ranges[i]);
			if (status != XST_SUCCESS) {
				exit(1);
			}
		}
		j++;
	}
	//DWORD *reg_value = NULL;


	get_rpc2_ctrl_status();
	print("--Memory Test Application Complete--\n\r");

	cleanup_platform();
	return 0;
}
