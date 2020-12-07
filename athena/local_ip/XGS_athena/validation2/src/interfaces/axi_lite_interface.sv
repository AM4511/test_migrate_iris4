`ifndef _axi_lite_interface_
	`define _axi_lite_interface_


	interface axi_lite_interface ();

		// Define parameters
		parameter DATA_WIDTH = 32;
		parameter ADDR_WIDTH = 11;
   
        logic clk;
		logic reset_n;
   
		// Axi write address channel
		logic    awvalid;
		logic    awready;
		logic [2:0] awprot;
		logic [ADDR_WIDTH-1:0] awaddr;


		// Axi write data channel
		logic 		  wvalid;
		logic 		  wready;
		logic [DATA_WIDTH/8-1:0] wstrb;
		logic [DATA_WIDTH-1:0]   wdata;


		// Axi write response channel
		logic 		    bready;
		logic 		    bvalid;
		logic [1:0]     bresp;


		// Axi read address channel
		logic 		           arvalid;
		logic 		           arready;
		logic [2:0] 		   arprot;
		logic [ADDR_WIDTH-1:0] araddr;


		// Axi read data channel
		logic 		           rready;
		logic 		           rvalid;
		logic [DATA_WIDTH-1:0] rdata;
		logic [1:0] 		   rresp;



   
		//////////////////////////////////////////////////////////////
		//
		// Port mode  : master
		//
		// Description : 
		//
		//////////////////////////////////////////////////////////////
		modport master (
				input  clk,
				output reset_n,
				output awvalid,
				input  awready,
				output awprot,
				output awaddr,
				output wvalid,
				input  wready,
				output wstrb,
				output wdata,
				output bready,
				input  bvalid,
				input  bresp,
				output arvalid,
				input  arready,
				output arprot,
				output araddr,
				output rready,
				input  rvalid,
				input  rdata,
				input  rresp
			);


		//////////////////////////////////////////////////////////////
		//
		// Port mode  : slave
		//
		// Description : 
		//
		//////////////////////////////////////////////////////////////
		modport slave (
				input  clk,
				input  reset_n,
				input  awvalid,
				output awready,
				input  awprot,
				input  awaddr,
				input  wvalid,
				output wready,
				input  wstrb,
				input  wdata,
				input  bready,
				output bvalid,
				output bresp,
				input  arvalid,
				output arready,
				input  arprot,
				input  araddr,
				input  rready,
				output rvalid,
				output rdata,
				output rresp
			);


	endinterface // axi_lite_interface

`endif


