`timescale 1ns/1ps

import core_pkg::*;
import driver_pkg::*;
import hispi_pkg::*;
import tests_pkg::*;
//import scoreboard_pkg::*;

module testbench_dmwr();
	
	//parameter NUMBER_OF_BLOCK = 6;
	parameter NUMBER_OF_LANE = 4;
	parameter PIXEL_SIZE = 12;
	parameter AV_DATA_WIDTH=32;
	parameter AV_ADDR_WIDTH=8;
	parameter GPIO_NUMB_INPUT=8;
	parameter GPIO_NUMB_OUTPUT=8;
	parameter PIXELS_PER_LINE=384;
	parameter LINE_PER_FRAME=2;
	
	//clock and reset signal declaration
	bit avclk=1'b0;
	bit pixclk=1'b0;
	bit sysrst=1'b0;
	bit [5:0]  user_data_in;
	bit [1:0]  user_data_out;
	bit [63:0] irq;
	bit 	   rx_irq;

	
	Cscoreboard_hispi scoreboard;
	
	Cdriver_onsemi_xgs #(.NUMB_LANE(NUMBER_OF_LANE)) sensor_driver;
	Cdriver_avalon_mm  #(.DATA_WIDTH(AV_DATA_WIDTH),  .ADDR_WIDTH(AV_ADDR_WIDTH), .NUMB_INPUT_IO(GPIO_NUMB_INPUT),.NUMB_OUTPUT_IO(GPIO_NUMB_OUTPUT))  avalon_driver;
	
	Ctest0000 test0000;
	
	// Define the interfaces
	avalon_mm_interface #(.DATA_WIDTH(AV_DATA_WIDTH), .ADDR_WIDTH(AV_ADDR_WIDTH)) if_avmm(avclk);
	io_interface #(GPIO_NUMB_INPUT,GPIO_NUMB_OUTPUT) if_gpio();
	hispi_interface #(.NUMB_LANE(NUMBER_OF_LANE)) if_hispi(pixclk);
	axi_stream_interface #(.T_DATA_WIDTH(64)) axis_master(avclk, sysrst);
	axi_stream_interface #(.T_DATA_WIDTH(64)) axis_slave(avclk, sysrst);

	// Clock and Reset generation
	always #5 avclk = ~avclk;
	always #2.5 pixclk = ~pixclk;
	
	
/* -----\/----- EXCLUDED -----\/-----
	hispi_top 
		#(
			.FPGA_MANUFACTURER("XILINX"),
			.NUMBER_OF_LANE(NUMBER_OF_LANE),
			.PIXEL_SIZE(PIXEL_SIZE),
			.PIXELS_PER_LINE(PIXELS_PER_LINE),
			.LINES_PER_FRAME(LINE_PER_FRAME)
		)
		xhispi_top (
			.sysclk(avclk),
			.sysrst(sysrst),
			.reg_read(if_avmm.read),
			.reg_write(if_avmm.write),
			.reg_addr(if_avmm.address[7:2]),
			.reg_beN(if_avmm.be_n),
			.reg_writedata(if_avmm.write_data),
                        .reg_readdatavalid(),
			.reg_readdata(if_avmm.read_data),
			.hispi_serial_clk_p(if_hispi.hclk_p),
			.hispi_serial_clk_n(if_hispi.hclk_n),
			.hispi_data_p(if_hispi.data_p),
			.hispi_data_n(if_hispi.data_n),
			.m_axis_tready(axis_master.tready),
			.m_axis_tvalid(axis_master.tvalid),
			.m_axis_tdata(axis_master.tdata),
			.m_axis_tstrb(axis_master.tstrb),
			.m_axis_tlast(axis_master.tlast),
			.s_axis_tready(axis_slave.tready),
			.s_axis_tvalid(axis_slave.tvalid),
			.s_axis_tdata(axis_slave.tdata),
			.s_axis_tstrb(axis_slave.tstrb),
			.s_axis_tlast(axis_slave.tlast)
		);
 -----/\----- EXCLUDED -----/\----- */
	

	//Connect the GPIO
	assign if_gpio.input_io[0] = irq[22];
	assign user_data_in = if_gpio.output_io;
	assign if_avmm.wait_req = 1'b0;
	
	assign axis_master.tready = 1'b1;
	
	always @ (posedge avclk )
	begin
		if (sysrst == 1) begin
			axis_slave.tvalid <= 1'b0;
			axis_slave.tdata <= 0;
			axis_slave.tstrb <= 0;
			axis_slave.tlast<= 1'b0;
		end else begin	
			if (axis_master.tready==1'b1 && axis_master.tvalid == 1'b1 && axis_master.tlast ==1'b1) begin
				axis_slave.tvalid <= 1'b1;
				axis_slave.tdata <= 0;
				axis_slave.tstrb <= 1;
				axis_slave.tlast<= 1'b1;
			end else if(axis_slave.tvalid==1'b1 && axis_slave.tready == 1'b1) begin
				axis_slave.tvalid <= 1'b0;
				axis_slave.tdata <= 0;
				axis_slave.tstrb <= 0;
				axis_slave.tlast<= 1'b0;
			end
		end
	end
		
	
		
	initial begin
		sysrst <= 1;
		#30 sysrst <= 0;

		sensor_driver = new (if_hispi);
		avalon_driver = new(if_avmm,if_gpio);
		test0000 = new(sensor_driver.msgChannel, avalon_driver.msgChannel);
		//scoreboard = new(mii_if.slave);
		fork
			sensor_driver.run();
			avalon_driver.run();
			test0000.run();

		join 

		sensor_driver.teriminate();


	end

endmodule
