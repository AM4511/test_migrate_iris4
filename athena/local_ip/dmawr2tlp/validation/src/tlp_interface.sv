/****************************************************************************
 * hispi_interface.sv
 ****************************************************************************/

/**
 * Interface: hispi_interface
 *
 * TODO: Add interface documentation
 */

`ifndef _tlp_interface_
	`define _tlp_interface_

	interface tlp_interface();
		logic 	       clk;
		logic 	       reset_n;
		logic 	       req_to_send;
		logic 	       grant;
		logic [6:0] 	       fmt_type;
		logic [9:0] 	       length_in_dw;
		logic 	       src_rdy_n;
		logic 	       dst_rdy_n;
		logic [63:0]        data;
		logic [63:2]        address;
		logic [7:0] 	       ldwbe_fdwbe;
		logic [1:0] 	       attr;
		logic [23:0]        transaction_id;
		logic [12:0]        byte_count;
		logic [6:0] 	       lower_address;


		//////////////////////////////////////////////////////////////
		//
		// Port mode  : master
		//
		// Description :
		//
		//////////////////////////////////////////////////////////////
		modport master (
				output req_to_send,
				input  grant,
				output fmt_type,
				output length_in_dw,
				output src_rdy_n,
				input  dst_rdy_n,
				output data,
				output address,
				output ldwbe_fdwbe,
				output attr,
				output transaction_id,
				output byte_count,
				output lower_address
			);


		//////////////////////////////////////////////////////////////
		//
		// Port mode  : slave
		//
		// Description :
		//
		//////////////////////////////////////////////////////////////
		modport slave (
				input  req_to_send,
				output grant,
				input  fmt_type,
				input  length_in_dw,
				input  src_rdy_n,
				output dst_rdy_n,
				input  data,
				input  address,
				input  ldwbe_fdwbe,
				input  attr,
				input  transaction_id,
				input  byte_count,
				input  lower_address
			);
	endinterface

`endif
