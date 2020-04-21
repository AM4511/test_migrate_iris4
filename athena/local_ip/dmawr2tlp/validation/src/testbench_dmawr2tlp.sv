`timescale 1ns/1ps

import core_pkg::*;
import driver_pkg::*;
import dmawr2tlp_pkg::*;
//import tests_pkg::*;

module testbench_dmawr2tlp();
	parameter DATA_WIDTH=32;
	parameter AXIS_DATA_WIDTH=64;
	parameter AXIS_USER_WIDTH=2;
	parameter ADDR_WIDTH=8;
	parameter GPIO_NUMB_INPUT=8;
	parameter GPIO_NUMB_OUTPUT=8;

	integer  address;
	integer  data;
	integer  ben;

	//clock and reset signal declaration
	bit 	    idelay_clk=1'b0;
	bit 	    axi_clk=1'b0;
	bit [5:0] user_data_in;
	bit [1:0] user_data_out;
	bit [63:0] irq;
	bit 	      intevent;
	bit [1:0]  context_strb;
	bit 	      cfg_bus_mast_en;
	bit [2:0]  cfg_setmaxpld;


	Cdriver_axil #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH), .NUMB_INPUT_IO(GPIO_NUMB_INPUT), .NUMB_OUTPUT_IO(GPIO_NUMB_OUTPUT)) axil_driver;
	Cdriver_axis #(.DATA_WIDTH(AXIS_DATA_WIDTH), .USER_WIDTH(AXIS_USER_WIDTH)) axis_driver;
	Cscoreboard_dmawr2tlp scoreboard;
	//Ctest0000 test0000;

	// Define the interfaces
	axi_lite_interface #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) axil(axi_clk);
	axi_stream_interface #(.T_DATA_WIDTH(64), .T_USER_WIDTH(AXIS_USER_WIDTH)) axis(axi_clk, axil_reset_n);
	io_interface #(GPIO_NUMB_INPUT,GPIO_NUMB_OUTPUT) if_gpio();
	tlp_interface tlp();


	dmawr2tlp #(.NUMBER_OF_PLANE(1), .MAX_PCIE_PAYLOAD_SIZE(128)) DUT
		(
			.axi_clk(axi_clk),
			.axi_reset_n(axil.reset_n),
			.intevent(intevent),
			.context_strb(context_strb),
			.s_axi_awaddr(axil.awaddr),
			.s_axi_awprot(axil.awprot),
			.s_axi_awvalid(axil.awvalid),
			.s_axi_awready(axil.awready),
			.s_axi_wdata(axil.wdata),
			.s_axi_wstrb(axil.wstrb),
			.s_axi_wvalid(axil.wvalid),
			.s_axi_wready(axil.wready),
			.s_axi_bresp(axil.bresp),
			.s_axi_bvalid(axil.bvalid),
			.s_axi_bready(axil.bready),
			.s_axi_araddr(axil.araddr),
			.s_axi_arprot(axil.arprot),
			.s_axi_arvalid(axil.arvalid),
			.s_axi_arready(axil.arready),
			.s_axi_rdata(axil.rdata),
			.s_axi_rresp(axil.rresp),
			.s_axi_rvalid(axil.rvalid),
			.s_axi_rready(axil.rready),
			.s_axis_tready(axis.tready),
			.s_axis_tvalid(axis.tvalid),
			.s_axis_tdata(axis.tdata),
			.s_axis_tuser(axis.tuser),
			.s_axis_tlast(axis.tlast),
			.cfg_bus_mast_en(cfg_bus_mast_en),
			.cfg_setmaxpld(cfg_setmaxpld),
			.tlp_req_to_send(tlp.req_to_send),
			.tlp_grant(tlp.grant),
			.tlp_fmt_type(tlp.fmt_type),
			.tlp_length_in_dw(tlp.length_in_dw),
			.tlp_src_rdy_n(tlp.src_rdy_n),
			.tlp_dst_rdy_n(tlp.dst_rdy_n),
			.tlp_data(tlp.data),
			.tlp_address(tlp.address),
			.tlp_ldwbe_fdwbe(tlp.ldwbe_fdwbe),
			.tlp_attr(tlp.attr),
			.tlp_transaction_id(tlp.transaction_id),
			.tlp_byte_count(tlp.byte_count),
			.tlp_lower_address(tlp.lower_address)
		);


	//Connect the GPIO
	assign if_gpio.input_io[0] = irq[22];
	assign user_data_in = if_gpio.output_io;


	// Clock and Reset generation
	always #5 axi_clk = ~axi_clk;


	initial begin

		// Initialize classes
		axil_driver = new(axil, if_gpio);

		axis_driver = new(axis);
		scoreboard  = new(tlp);

		fork
			// Start the scorboard
			begin
				scoreboard.run();
			end

			// Start the test
			begin
				int axi_address;
				int axi_read_data;
				int axi_write_data;
				logic [AXIS_DATA_WIDTH-1:0] stream_data[$];
				logic [AXIS_USER_WIDTH-1:0] stream_user[$];
				logic [AXIS_USER_WIDTH-1:0] sync;


				$display("Reset driver models");
				axis_driver.reset(10);
				axil_driver.reset(10);
				// MIn XGS model reset is 30 clk, set it to 50
				axil_driver.wait_n(1000);


				$display("Registerfile access");


				///////////////////////////////////////////////////
				// Read the Matrox info register
				///////////////////////////////////////////////////
				axi_address = 'h00000000;
				$display("Read the info register @0x%h", axi_address);
				axil_driver.read(axi_address, axi_read_data);
				assert (axi_read_data == 'h0058544d) else $error("Read error @0x%h", axi_address);
				axil_driver.wait_n(10);


				///////////////////////////////////////////////////
				// Write/Read the scratch pad
				///////////////////////////////////////////////////
				axi_address = 'h00000010;
				axi_write_data = 'hcafefade;
				$display("Write/Read back the scratch register @0x%h", axi_address);
				axil_driver.write(axi_address, axi_write_data);
				axil_driver.read(axi_address, axi_read_data);
				assert (axi_read_data == axi_write_data) else $error("Write/Read error @0x%h", axi_address);
				axil_driver.wait_n(10);


				///////////////////////////////////////////////////
				// Construct the video stream
				///////////////////////////////////////////////////
				stream_data = {};
				stream_user = {};
				for (int counter=0; counter<100; counter++) begin
					stream_data.push_back(counter);

					// Calculate sync
					case (counter)
						0 : sync = 2'b01;
						100 : sync = 2'b10;
						default: sync = 2'b00;
					endcase
					stream_user.push_back(sync);
				end


				///////////////////////////////////////////////////
				// Send the video stream
				///////////////////////////////////////////////////
				axis_driver.write(stream_data, stream_user);


				///////////////////////////////////////////////////
				// Terminate the simulation
				///////////////////////////////////////////////////
				axil_driver.wait_n(100);
				axil_driver.terminate();

			end

		join_any;
		#1ms;
		$finish;
	end



endmodule

