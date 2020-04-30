/****************************************************************************
 * hispi_interface.sv
 ****************************************************************************/

/**
 * Interface: hispi_interface
 *
 * TODO: Add interface documentation
 */

`ifndef _hispi_interface_
	`define _hispi_interface_

	interface hispi_interface(input logic refclk);
		// Define parameters
		parameter int NUMB_LANE;
		logic  data_n[NUMB_LANE-1:0];
		logic  data_p[NUMB_LANE-1:0];
		logic  hclk_n[1:0];
		logic  hclk_p[1:0];

   
		//////////////////////////////////////////////////////////////
		//
		// Port mode  : master
		//
		// Description : 
		//
		//////////////////////////////////////////////////////////////
		modport master (
				input  refclk,
				
				output hclk_p,
				output hclk_n,
				output data_p,
				output data_n
			);


		//////////////////////////////////////////////////////////////
		//
		// Port mode  : slave
		//
		// Description : 
		//
		//////////////////////////////////////////////////////////////
		modport slave (
				input hclk_p,
				input hclk_n,
				input data_p,
				input data_n
			);

	endinterface

`endif
