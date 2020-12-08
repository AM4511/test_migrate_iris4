`ifndef _io_interface_
`define _io_interface_


interface io_interface;
	parameter NUMB_INPUT_IO;
	parameter NUMB_OUTPUT_IO;
	wire   [NUMB_INPUT_IO-1:0] input_io;
	wire   [NUMB_OUTPUT_IO-1:0] output_io;
	logic  [NUMB_OUTPUT_IO-1:0] output_reg;

	assign output_io = output_reg;
endinterface // io_interface


`endif
