`timescale 1ns/1ps

import core_pkg::*;
import driver_pkg::*;
import xgs_athena_pkg::*;
//import tests_pkg::*;

module testbench();
	parameter NUMBER_OF_LANE = 6; // 4 Not supported yet...
	parameter MUX_RATIO = 4;
	parameter PIXELS_PER_LINE=4176;
	parameter LINE_PER_FRAME=3102;
	parameter PIXEL_SIZE = 12;
	parameter NUMBER_ACTIVE_LINES = 8;
        parameter SYS_CLK_PERIOD= 16;
        parameter SENSOR_FREQ = 32400;
        parameter SIMULATION = 1;
        parameter KU706 = 0;

	parameter AXIL_DATA_WIDTH=32;
	parameter AXIL_ADDR_WIDTH=11;

	parameter GPIO_NUMB_INPUT=1;
	parameter GPIO_NUMB_OUTPUT=1;
	parameter MAX_PCIE_PAYLOAD_SIZE=128;

	parameter BAR_XGS_ATHENA   = 32'h00000000;
	parameter TAG_OFFSET = BAR_XGS_ATHENA + 'h00000000;
	parameter SCRATCHPAD_OFFSET = BAR_XGS_ATHENA + 'h0000000c;

	parameter FSTART_OFFSET         = 'h078;
	parameter FSTART_HIGH_OFFSET    = 'h07c;

	parameter FSTART_G_OFFSET       = 'h080;
	parameter FSTART_G_OFFSET_HIGH  = 'h084;

	parameter FSTART_R_OFFSET       = 'h088;
	parameter FSTART_R_OFFSET_HIGH  = 'h08C;

	parameter LINE_PITCH_OFFSET     = 'h090;

	parameter LINE_SIZE_OFFSET      = 'h094;

	parameter SENSOR_CTRL_OFFSET    = 'h0190;
	parameter SENSOR_STAT_OFFSET    = 'h0198;

    parameter SPI_MODEL_ID_OFFSET   = 16'h000;


	integer  address;
	integer  data;
	integer  ben;

	//clock and reset signal declaration
	bit 	    idelay_clk=1'b0;
	bit 	    axi_clk=1'b0;
	bit [5:0] user_data_in;
	bit [1:0] user_data_out;
	bit 	      intevent;
	bit [1:0]  context_strb;
	bit 	      cfg_bus_mast_en;
	bit [2:0]  cfg_setmaxpld;
	bit [7:0] 	   irq;

	reg 	      XGS_MODEL_SCLK;
	reg 	      XGS_MODEL_SDATA;
	reg 	      XGS_MODEL_CS;
	reg 	      XGS_MODEL_SDATAOUT;


   logic 	      xgs_power_good;
   logic 	      xgs_clk_pll_en;
   logic 	      xgs_reset_n;

   logic 	      xgs_fwsi_en;

   logic 	      xgs_sclk;
   logic 	      xgs_cs_n;
   logic 	      xgs_sdout;
   logic 	      xgs_sdin;

   logic 	      xgs_trig_int;
   logic 	      xgs_trig_rd;

   wire 	      xgs_monitor0;
   wire 	      xgs_monitor1;
   wire 	      xgs_monitor2;


   logic 	      anput_ext_trig;

   logic 	      anput_strobe_out;
   logic 	      anput_exposure_out;
   logic 	      anput_trig_rdy_out;

   // -- led_out(0) --> vert, led_out(1) --> rouge
   logic [1:0] 	      led_out;





	Cdriver_axil #(.DATA_WIDTH(AXIL_DATA_WIDTH), .ADDR_WIDTH(AXIL_ADDR_WIDTH), .NUMB_INPUT_IO(GPIO_NUMB_INPUT), .NUMB_OUTPUT_IO(GPIO_NUMB_OUTPUT)) axil_driver;
	Cscoreboard scoreboard;

	// Define the interfaces
	axi_lite_interface #(.DATA_WIDTH(AXIL_DATA_WIDTH), .ADDR_WIDTH(AXIL_ADDR_WIDTH)) axil(axi_clk);
	axi_stream_interface #(.T_DATA_WIDTH(64), .T_USER_WIDTH(4)) tx_axis(axi_clk, axil_reset_n);
	io_interface #(GPIO_NUMB_INPUT,GPIO_NUMB_OUTPUT) if_gpio();
	hispi_interface #(.NUMB_LANE(NUMBER_OF_LANE)) if_hispi(XGS_MODEL_EXTCLK);
	tlp_interface tlp();



	xgs12m_chip
		#(
			//----------------------------------------------
			// Configuration for XGS12M with 24 HiSPI LANES
			//----------------------------------------------
			.G_MODEL_ID         (16'h0058),     // XGS12M
			.G_REV_ID           (16'h0002),     // XGS12M
			.G_NUM_PHY          (6),            // XGS12M
			.G_PXL_PER_COLRAM   (174),          // XGS12M
			.G_PXL_ARRAY_ROWS   (3100)          // XGS12M

			//----------------------------------------------
			// Configuration for XGS5M with 16 HiSPI LANES
			//----------------------------------------------
			//.G_MODEL_ID         (16'h0358),     // XGS5M
			//.G_REV_ID           (16'h0000),     // XGS5M
			//.G_NUM_PHY          (4),            // XGS5M
			//.G_PXL_PER_COLRAM   (174),          // XGS5M
			//.G_PXL_ARRAY_ROWS   (2056)          // XGS5M  only active (2048+8=2056)
		)
		XGS_MODEL
		(
			.VAAHV_NPIX(),
			.VREF1_BOT_0(),
			.VREF1_BOT_1(),
			.VREF1_TOP_0(),
			.VREF1_TOP_1(),
			.ATEST_BTM(),
			.ATEST_TOP(),
			.ASPARE_TOP(),
			.ASPARE_BTM(),

			.VRESPD_HI_0(),
			.VRESPD_HI_1(),
			.VRESFD_HI_0(),
			.VRESFD_HI_1(),
			.VSG_HI_0(),
			.VSG_HI_1(),
			.VRS_HI_0(),
			.VRS_HI_1(),
			.VTX1_HI_0(),
			.VTX1_HI_1(),
			.VTX0_HI_0(),
			.VTX0_HI_1(),
			.VRESFD_LO1_0(),
			.VRESFD_LO1_1(),
			.VRESFD_LO2_0(),
			.VRESFD_LO2_1(),
			.VRESPD_LO1_0(),
			.VRESPD_LO1_1(),
			.VSG_LO1_0(),
			.VSG_LO1_1(),
			.VTX1_LO1_0(),
			.VTX1_LO1_1(),
			.VTX1_LO2_0(),
			.VTX1_LO2_1(),
			.VTX0_LO1_0(),
			.VTX0_LO1_1(),
			.VPSUB_LO_0(),
			.VPSUB_LO_1(),
			.TEST(1'b1),
			.DSPARE0 (),
			.DSPARE1 (),
			.DSPARE2 (),

			.TRIGGER_INT(xgs_trig_int),

			.MONITOR0(xgs_monitor0),
			.MONITOR1(xgs_monitor1),
			.MONITOR2(xgs_monitor2),

			.RESET_B(xgs_reset_n),
			.EXTCLK(if_hispi.refclk),
			.FWSI_EN(Vcc),

			.SCLK(xgs_sclk),
			.SDATA(xgs_sdout),
			.CS(xgs_cs_n),
			.SDATAOUT(xgs_sdin),

			.D_CLK_0_N(),
			.D_CLK_0_P(),
			.D_CLK_1_N(),
			.D_CLK_1_P(),

			.D_CLK_2_N(if_hispi.hclk_n[0]),
			.D_CLK_2_P(if_hispi.hclk_p[0]),
			.D_CLK_3_N(if_hispi.hclk_n[1]),
			.D_CLK_3_P(if_hispi.hclk_p[1]),
			.D_CLK_4_N(),
			.D_CLK_4_P(),
			.D_CLK_5_N(),
			.D_CLK_5_P(),

			.DATA_0_N (if_hispi.data_n[0]),
			.DATA_0_P (if_hispi.data_p[0]),
			.DATA_1_P (if_hispi.data_p[1]),
			.DATA_1_N (if_hispi.data_n[1]),
			.DATA_2_P (),
			.DATA_2_N (),
			.DATA_3_P (),
			.DATA_3_N (),
			.DATA_4_N (),
			.DATA_4_P (),
			.DATA_5_N (),
			.DATA_5_P (),
			.DATA_6_N (),
			.DATA_6_P (),
			.DATA_7_N (),
			.DATA_7_P (),
			.DATA_8_N (if_hispi.data_n[2]),
			.DATA_8_P (if_hispi.data_p[2]),
			.DATA_9_N (if_hispi.data_n[3]),
			.DATA_9_P (if_hispi.data_p[3]),
			.DATA_10_N(),
			.DATA_10_P(),
			.DATA_11_N(),
			.DATA_11_P(),
			.DATA_12_N(),
			.DATA_12_P(),
			.DATA_13_N(),
			.DATA_13_P(),
			.DATA_14_N(),
			.DATA_14_P(),
			.DATA_15_N(),
			.DATA_15_P(),
			.DATA_16_N(if_hispi.data_n[4]),
			.DATA_16_P(if_hispi.data_p[4]),
			.DATA_17_N(if_hispi.data_n[5]),
			.DATA_17_P(if_hispi.data_p[5]),
			.DATA_18_N(),
			.DATA_18_P(),
			.DATA_19_N(),
			.DATA_19_P(),
			.DATA_20_N(),
			.DATA_20_P(),
			.DATA_21_N(),
			.DATA_21_P(),
			.DATA_22_N(),
			.DATA_22_P(),
			.DATA_23_N(),
			.DATA_23_P()
		);




	XGS_athena  #(
			.ENABLE_IDELAYCTRL(),
			.NUMBER_OF_LANE(NUMBER_OF_LANE),
			.MUX_RATIO(MUX_RATIO),
			.PIXELS_PER_LINE(PIXELS_PER_LINE),
			.LINES_PER_FRAME(NUMBER_ACTIVE_LINES),
			.PIXEL_SIZE(PIXEL_SIZE),
			.MAX_PCIE_PAYLOAD_SIZE(MAX_PCIE_PAYLOAD_SIZE),
		        .SYS_CLK_PERIOD(SYS_CLK_PERIOD),
		        .SENSOR_FREQ(SENSOR_FREQ),
		        .SIMULATION(SIMULATION),
		        .KU706(KU706)
		      ) DUT (
			.axi_clk(axi_clk),
			.axi_reset_n(axil.reset_n),
			.irq(irq),
			.xgs_power_good(xgs_power_good),
			.xgs_clk_pll_en(xgs_clk_pll_en),
			.xgs_reset_n(xgs_reset_n),
			.xgs_fwsi_en(xgs_fwsi_en),
			.xgs_sclk(xgs_sclk),
			.xgs_cs_n(xgs_cs_n),
			.xgs_sdout(xgs_sdout),
			.xgs_sdin(xgs_sdin),
			.xgs_trig_int(xgs_trig_int),
			.xgs_trig_rd(xgs_trig_rd),
			.xgs_monitor0(xgs_monitor0),
			.xgs_monitor1(xgs_monitor1),
			.xgs_monitor2(xgs_monitor2),
			.anput_ext_trig(anput_ext_trig),
			.anput_strobe_out(anput_strobe_out),
			.anput_exposure_out(anput_exposure_out),
			.anput_trig_rdy_out(anput_trig_rdy_out),
			.led_out(led_out),
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
			.idelay_clk(idelay_clk),
			.hispi_io_clk_p(if_hispi.hclk_p),
			.hispi_io_clk_n(if_hispi.hclk_n),
			.hispi_io_data_p(if_hispi.data_p),
			.hispi_io_data_n(if_hispi.data_n),
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


	pcie_tx_axi #(.NB_PCIE_AGENTS(1), .AGENT_IS_64_BIT(1'b1), .C_DATA_WIDTH(64)) inst_pcie_tx_axi
		(
			.sys_clk(axi_clk),
			.sys_reset_n(axil.reset_n),
			.s_axis_tx_tready(tx_axis.tready),
			.s_axis_tx_tdata(tx_axis.tdata),
			.s_axis_tx_tkeep(),
			.s_axis_tx_tlast(tx_axis.tlast),
			.s_axis_tx_tvalid(tx_axis.tvalid),
			.s_axis_tx_tuser(tx_axis.tuser),
			.cfg_bus_number(8'hbb),
			.cfg_device_number(5'b10101),
			.cfg_no_snoop_en(1'b0),
			.cfg_relax_ord_en(1'b0),
			.tlp_out_req_to_send(tlp.req_to_send),
			.tlp_out_grant(tlp.grant),
			.tlp_out_fmt_type(tlp.fmt_type),
			.tlp_out_length_in_dw(tlp.length_in_dw),
			.tlp_out_src_rdy_n(tlp.src_rdy_n),
			.tlp_out_dst_rdy_n(tlp.dst_rdy_n),
			.tlp_out_data(tlp.data),
			.tlp_out_address(tlp.address),
			.tlp_out_ldwbe_fdwbe(tlp.ldwbe_fdwbe),
			.tlp_out_attr(tlp.attr),
			.tlp_out_transaction_id(tlp.transaction_id),
			.tlp_out_byte_count(tlp.byte_count),
			.tlp_out_lower_address(tlp.lower_address)
		);

	assign xgs_power_good = 1'b1;
	assign anput_ext_trig = 1'b0;


	assign cfg_bus_mast_en = 1'b1;
	assign tx_axis.tready = 1'b1;

	//Connect the GPIO
	assign if_gpio.input_io[0] = irq[0];
	assign user_data_in = if_gpio.output_io;

	assign tlp.clk = axi_clk;

	// Clock and Reset generation
	always #5 axi_clk = ~axi_clk;


	initial begin

		// Initialize classes
		axil_driver = new(axil, if_gpio);

/* -----\/----- EXCLUDED -----\/-----
		XGS_MODEL_SCLK  <= 0;
		XGS_MODEL_CS    <= 1 ;
		XGS_MODEL_SDATA <= 0;
 -----/\----- EXCLUDED -----/\----- */

		fork
			// Start the scorboard
			begin
				//scoreboard.run();
			end

			// Start the test
			begin
				int axi_addr;
				int axi_read_data;
				int axi_write_data;
				int axi_strb;
				int axi_poll_mask;
				int axi_expected_value;
				longint data;
				int data_rd;  // SPI read


				// Parameters
				longint fstart;
				int line_size;
				int line_pitch;


				fstart = 'hA0000000;
				line_size = 'h1000;
				line_pitch = 'h1000;

				///////////////////////////////////////////////////
				// STARTING POINT : Reset the testbench
				///////////////////////////////////////////////////
				$display("1. Reset the testbench");
				axil_driver.reset(10);
				// MIn XGS model reset is 30 clk, set it to 50
				axil_driver.wait_n(1000);


				///////////////////////////////////////////////////
				// Start setting up registers
				///////////////////////////////////////////////////
				$display("2. Starting register file accesses");


				///////////////////////////////////////////////////
				// Read the Matrox info register
				///////////////////////////////////////////////////
				axi_addr = TAG_OFFSET;
				$display("  2.1 Read the TAG register @0x%h", axi_addr);
				axil_driver.read(axi_addr, axi_read_data);
				assert (axi_read_data == 'h0058544d) else $error("Read error @0x%h", axi_addr);
				axil_driver.wait_n(10);


				///////////////////////////////////////////////////
				// Write/Read the scratch pad
				///////////////////////////////////////////////////
				axi_addr = SCRATCHPAD_OFFSET;
				axi_write_data = 'hcafefade;
				$display("  2.2 Write then Read back the SCRATCHPAD register @0x%h", axi_addr);
				axil_driver.write(axi_addr, axi_write_data);
				axil_driver.read(axi_addr, axi_read_data);
				assert (axi_read_data == axi_write_data) else $error("Write/Read error @0x%h", axi_addr);
				axil_driver.wait_n(10);


				///////////////////////////////////////////////////
				// DMA frame start register
				///////////////////////////////////////////////////
				$display("  2.3 Write FSTART register @0x%h", FSTART_OFFSET);
				axil_driver.write(FSTART_OFFSET, fstart);
				axil_driver.write(FSTART_HIGH_OFFSET, fstart>>32);
				axil_driver.wait_n(10);


				///////////////////////////////////////////////////
				// DMA line size register
				///////////////////////////////////////////////////
				$display("  2.4 Write LINESIZE register @0x%h", LINE_SIZE_OFFSET);
				axil_driver.write(LINE_SIZE_OFFSET, line_size);
				axil_driver.wait_n(10);


				///////////////////////////////////////////////////
				// DMA line pitch register
				///////////////////////////////////////////////////
				$display("  2.5 Write LINESIZE register @0x%h", LINE_PITCH_OFFSET);
				axil_driver.write(LINE_PITCH_OFFSET, line_pitch);
				axil_driver.wait_n(10);


				///////////////////////////////////////////////////
				// XGS Controller wakes up sensor
				///////////////////////////////////////////////////
				$display("3. XGS Controller wakes up sensor");
				$display("  3.1 Write SENSOR_CTRL register @0x%h", SENSOR_CTRL_OFFSET);
				axi_addr = SENSOR_CTRL_OFFSET;
				axi_write_data = 'h0003;
				axi_strb = 'h1;
				axil_driver.write(axi_addr, axi_write_data, axi_strb);


				///////////////////////////////////////////////////
				// Poll until clock enable and reset disable
				///////////////////////////////////////////////////
				$display("  3.2 Poll SENSOR_STAT register @0x%h", SENSOR_STAT_OFFSET);
				axi_addr = SENSOR_STAT_OFFSET;
				axi_poll_mask = 'h00000001;
				axi_expected_value = 'h00000001;
				axil_driver.poll(axi_addr, axi_expected_value, axi_poll_mask, .polling_period(1us));


				///////////////////////////////////////////////////
				// SPI configure the XGS sensor model
				///////////////////////////////////////////////////
				$display("4. SPI configure the XGS sensor model");


				///////////////////////////////////////////////////
				// SPI read XGS model id and revision
				///////////////////////////////////////////////////
				$display("  4.1 SPI read XGS model id and revision @0x%h", SPI_MODEL_ID_OFFSET);
				XGS_ReadSPI(SPI_MODEL_ID_OFFSET, data_rd);


				// Validate result
				if(data_rd==16'h0058) begin
					$display("XGS Model ID detected is 0x58, XGS12M");
				end
				else if(data_rd==16'h0358) begin
					$display("XGS Model ID detected is 0x358, XGS5M");
				end
				else begin
					$error("XGS Model ID detected is %d", data_rd);
				end


				///////////////////////////////////////////////////
				// Terminate the simulation
				///////////////////////////////////////////////////
				axil_driver.wait_n(1000);
				//axil_driver.terminate();

			end

		join;
		#1ms;
		$finish;
	end


	//----------------------------------------------
	//
	//----------------------------------------------
	task automatic XGS_WriteSPI(input int add, input int data);

		bit [14:0] model_addr;
		bit [15:0] model_data;

		model_addr = add;
		model_data = data;

		testbench.XGS_MODEL_SCLK  = 0;
		testbench.XGS_MODEL_CS    = 0 ;
		testbench.XGS_MODEL_SDATA = 0;
		#10ns;

			//SEND ADDRESS
		for(int y = 15; y > 0; y -= 1)
		begin
			testbench.XGS_MODEL_SCLK  = 0;
			testbench.XGS_MODEL_CS    = 0;
			testbench.XGS_MODEL_SDATA = model_addr[(y-1)];
			#10ns;
			testbench.XGS_MODEL_SCLK  = 1;
			#10ns;
		end

		//SEND WRITE TAG
		testbench.XGS_MODEL_SCLK  = 0;
		testbench.XGS_MODEL_CS    = 0;
		testbench.XGS_MODEL_SDATA = 0;  //Write=0
		#10ns;
		testbench.XGS_MODEL_SCLK  = 1;
		#10ns;

			//DATA
		for(int y = 16; y > 0; y -= 1)
		begin
			testbench.XGS_MODEL_SCLK  = 0;
			testbench.XGS_MODEL_CS    = 0;
			testbench.XGS_MODEL_SDATA = model_data[(y-1)];
			#10ns;
			testbench.XGS_MODEL_SCLK  = 1;
			#10ns;
		end

		testbench.XGS_MODEL_SCLK  = 0;
		testbench.XGS_MODEL_CS    = 0;
		testbench.XGS_MODEL_SDATA = 0;
		#10ns;
		testbench.XGS_MODEL_SCLK  = 0;
		testbench.XGS_MODEL_CS    = 1;
		testbench.XGS_MODEL_SDATA = 0;
		#100ns;

	endtask : XGS_WriteSPI


	task automatic XGS_ReadSPI(input int add, output int data);

		bit [14:0] model_addr;
		bit [15:0] model_data;

		model_addr = add;

		testbench.XGS_MODEL_SCLK  = 0;
		testbench.XGS_MODEL_CS    = 0;
		testbench.XGS_MODEL_SDATA = 0;
		#10ns;

			//SEND ADDRESS
		for(int y = 15; y > 0; y -= 1)
		begin
			testbench.XGS_MODEL_SCLK  = 0;
			testbench.XGS_MODEL_CS    = 0;
			testbench.XGS_MODEL_SDATA = model_addr[(y-1)];
			#10ns;
			testbench.XGS_MODEL_SCLK  = 1;
			#10ns;
		end

		//SEND READ TAG
		testbench.XGS_MODEL_SCLK  = 0;
		testbench.XGS_MODEL_CS    = 0;
		testbench.XGS_MODEL_SDATA = 1;  //Read=1
		#10ns;
		testbench.XGS_MODEL_SCLK  = 1;
		#10ns;

			//GET DATA
		for(int y = 16; y > 0; y -= 1)
		begin
			testbench.XGS_MODEL_SCLK  = 0;
			testbench.XGS_MODEL_CS    = 0;
			testbench.XGS_MODEL_SDATA = 0;
			#10ns;
			testbench.XGS_MODEL_SCLK  = 1;
			model_data[(y-1)]                  = testbench.XGS_MODEL_SDATAOUT ;
			#10ns;
		end

		data = model_data ;

		testbench.XGS_MODEL_SCLK  = 0;
		testbench.XGS_MODEL_CS    = 0;
		testbench.XGS_MODEL_SDATA = 0;
		#10ns;
		testbench.XGS_MODEL_SCLK  = 0;
		testbench.XGS_MODEL_CS    = 1;
		testbench.XGS_MODEL_SDATA = 0;
		#100ns;


	endtask : XGS_ReadSPI

endmodule

