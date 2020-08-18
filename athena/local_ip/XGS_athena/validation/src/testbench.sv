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
        parameter EXPOSURE = 50;
	parameter AXIL_DATA_WIDTH = 32;
	parameter AXIL_ADDR_WIDTH = 11;
	parameter AXIS_DATA_WIDTH = 64;
	parameter AXIS_USER_WIDTH = 4;
	parameter GPIO_NUMB_INPUT = 1;
	parameter GPIO_NUMB_OUTPUT = 1;
	parameter MAX_PCIE_PAYLOAD_SIZE = 128;
	parameter HISPI_IDLE_CHARACTER = 12'h3A6;

	parameter BAR_XGS_ATHENA        = 32'h00000000;

	// XGS_athena system
	parameter TAG_OFFSET            = 'h0000;
	parameter SCRATCHPAD_OFFSET     = 'h000c;

	// XGS_athena DMA
	parameter FSTART_OFFSET         = 'h078;
	parameter FSTART_HIGH_OFFSET    = 'h07c;
	parameter FSTART_G_OFFSET       = 'h080;
	parameter FSTART_G_OFFSET_HIGH  = 'h084;
	parameter FSTART_R_OFFSET       = 'h088;
	parameter FSTART_R_OFFSET_HIGH  = 'h08C;
	parameter LINE_PITCH_OFFSET     = 'h090;
	parameter LINE_SIZE_OFFSET      = 'h094;

	// XGS_athena controller
	parameter GRAB_CTRL_OFFSET          = 'h0100;
	parameter READOUT_CFG3_OFFSET       = 'h0120;
	parameter READOUT_CFG4_OFFSET       = 'h0124;
	parameter EXP_CTRL1_OFFSET          = 'h0128;
	parameter SENSOR_CTRL_OFFSET        = 'h0190;
	parameter SENSOR_STAT_OFFSET        = 'h0198;
	parameter SENSOR_SUBSAMPLING_OFFSET = 'h019c;
	parameter SENSOR_GAIN_ANA_OFFSET    = 'h01a4;
	parameter SENSOR_ROI_Y_START_OFFSET = 'h01a8;
	parameter SENSOR_ROI_Y_SIZE_OFFSET  = 'h01ac;
	parameter SENSOR_M_LINES_OFFSET     = 'h01b8;
	parameter EXP_FOT_OFFSET            = 'h02b8;




	// XGS_athena HiSPi
	parameter HISPI_CTRL_OFFSET                = 'h0400;
	parameter HISPI_CTRL_IDLE_CHARACTER_OFFSET = 'h040C;
    parameter FRAME_CFG_OFFSET                 = 'h0410;	
	parameter FRAME_CFG_X_VALID_OFFSET         = 'h0414;
	parameter HISPI_DEBUG_OFFSET               = 'h045C;

	// XGS sensor SPI Parameters
	parameter SPI_MODEL_ID_OFFSET          = 16'h000;
	parameter SPI_REVISION_NUMB_OFFSET     = 16'h31FE;
	parameter SPI_RESET_REGISTER_REG       = 16'h3700;
	parameter SPI_UNKNOWN_REGISTER_REG     = 16'h3e3e;
	parameter SPI_HISPI_CONTROL_COMMON_REG = 16'h3e28;
	parameter SPI_TEST_PATTERN_MODE_REG    = 16'h3e0e;
	parameter SPI_LINE_TIME_REG            = 16'h3810;
	parameter SPI_GENERAL_CONFIG0_REG      = 16'h3800;
	parameter SPI_MONITOR_REG              = 16'h3806;

	// I2C
	parameter I2C_ID_OFFSET                       = 32'h00010000;	
	parameter I2C_CTRL0_OFFSET                    = 32'h00010008;	
	parameter I2C_CTRL1_OFFSET                    = 32'h00010010;	
	parameter I2C_SEMAPHORE_OFFSET                = 32'h00010018;	

	integer  address;
	integer  data;
	integer  ben;
	integer  dma_irq_cntr = 0;

	//clock and reset signal declaration
	bit 	    idelay_clk=1'b0;
	//bit 	    axi_clk=1'b0;
	bit 	    sclk=1'b0;
	bit 	    sclk_reset_n;
	bit 	    pcie_clk=1'b0;
	bit [5:0] user_data_in;
	bit [1:0] user_data_out;
	bit 	      intevent;
	bit [1:0]  context_strb;
	bit 	      cfg_bus_mast_en;
	bit [2:0]  cfg_setmaxpld;
	bit [7:0] 	   irq;
	bit 	      XGS_MODEL_EXTCLK  = 0;

	//	reg 	      XGS_MODEL_SCLK;
	//	reg 	      XGS_MODEL_SDATA;
	//	reg 	      XGS_MODEL_CS;
	//	reg 	      XGS_MODEL_SDATAOUT;


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

	bit           xgs_model_GenImage = 0;
    
	logic 	      anput_ext_trig;

	logic 	      anput_strobe_out;
	logic 	      anput_exposure_out;
	logic 	      anput_trig_rdy_out;

	// -- led_out(0) --> vert, led_out(1) --> rouge
	logic [1:0] 	      led_out;

	logic pcie_reset_n = 0;



	
	

	Cdriver_axil #(.DATA_WIDTH(AXIL_DATA_WIDTH), .ADDR_WIDTH(AXIL_ADDR_WIDTH), .NUMB_INPUT_IO(GPIO_NUMB_INPUT), .NUMB_OUTPUT_IO(GPIO_NUMB_OUTPUT)) host;
	Cscoreboard #(.AXIS_DATA_WIDTH(AXIS_DATA_WIDTH), .AXIS_USER_WIDTH(AXIS_USER_WIDTH)) scoreboard;
    CImage XGS_imageSRC;
    CImage XGS_image;
	
	// Define the interfaces
	axi_lite_interface #(.DATA_WIDTH(AXIL_DATA_WIDTH), .ADDR_WIDTH(AXIL_ADDR_WIDTH)) pcie_axi(pcie_clk);
	axi_stream_interface #(.T_DATA_WIDTH(AXIS_DATA_WIDTH), .T_USER_WIDTH(AXIS_USER_WIDTH)) tx_axis(pcie_clk, pcie_reset_n);
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
			.G_PXL_PER_COLRAM   (174),          // XGS12M (4176)
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
		    .xgs_model_GenImage(xgs_model_GenImage), 
			 
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
			.FWSI_EN(1'b1),

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
			.SIMULATION(SIMULATION)
		) DUT (
			.aclk(pcie_clk),
			.aclk_reset_n(pcie_axi.reset_n),
			.sclk(sclk),
			.sclk_reset_n(sclk_reset_n),
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
			.debug_out(),
			.aclk_awaddr(pcie_axi.awaddr),
			.aclk_awprot(pcie_axi.awprot),
			.aclk_awvalid(pcie_axi.awvalid),
			.aclk_awready(pcie_axi.awready),
			.aclk_wdata(pcie_axi.wdata),
			.aclk_wstrb(pcie_axi.wstrb),
			.aclk_wvalid(pcie_axi.wvalid),
			.aclk_wready(pcie_axi.wready),
			.aclk_bresp(pcie_axi.bresp),
			.aclk_bvalid(pcie_axi.bvalid),
			.aclk_bready(pcie_axi.bready),
			.aclk_araddr(pcie_axi.araddr),
			.aclk_arprot(pcie_axi.arprot),
			.aclk_arvalid(pcie_axi.arvalid),
			.aclk_arready(pcie_axi.arready),
			.aclk_rdata(pcie_axi.rdata),
			.aclk_rresp(pcie_axi.rresp),
			.aclk_rvalid(pcie_axi.rvalid),
			.aclk_rready(pcie_axi.rready),
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
			.sys_clk(pcie_clk),
			.sys_reset_n(pcie_axi.reset_n),
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


	// System clock (100 MHz)
	always #5 sclk = ~sclk;
	// PCIe clk (62.5MHz)
	always #8 pcie_clk = ~pcie_clk;
	// HiSPi reference clock (32.4Mhz)
	always #15432ps XGS_MODEL_EXTCLK = ~XGS_MODEL_EXTCLK;


	assign xgs_power_good = 1'b1;
	assign anput_ext_trig = 1'b0;


	assign cfg_bus_mast_en = 1'b1;
	assign tx_axis.tready = 1'b1;

	//Connect the GPIO
	assign if_gpio.input_io[0] = irq[0];
	assign user_data_in = if_gpio.output_io;

	// TLP interface clock (pcie clk)
	assign tlp.clk = pcie_clk;

	always_ff @(posedge sclk)
	begin
		sclk_reset_n <= pcie_axi.reset_n;
	end

	always_ff @(posedge irq[0])
	begin
		dma_irq_cntr++;
	end

	// Clock and Reset generation
	//always #5 axi_clk = ~axi_clk;

	initial begin

		// Initialize classes
		host = new(pcie_axi, if_gpio);
		scoreboard = new(tx_axis);
        XGS_imageSRC   = new();
        XGS_image      = new();
	
		
		fork
			// Start the scorboard
			begin
				scoreboard.run();
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
				real xgs_ctrl_period;
				real xgs_bitrate_period;  //32.4Mhz ref clk*2 /12 bits per clk
				int EXP_FOT_TIME;
				
				int ROI_Y_START;
				int ROI_Y_SIZE;

				int ROI_X_START;
				int ROI_X_END;

				// int EXPOSURE=50; -> now defined as a parameter
				int KEEP_OUT_TRIG_START_sysclk;
				int KEEP_OUT_TRIG_END_sysclk;
				int MLines;
				int MLines_supressed;
				bit [31:0] manual_calib;

				// Parameters
				longint fstart;
				int line_size;
				int line_pitch;

				int line_time;
				int monitor_0_reg;
				int monitor_1_reg;
				int monitor_2_reg;
                                int test_nb_images;


			        test_nb_images =0;
				fstart = 'hA0000000;
				line_size = 'h1000;
				line_pitch = 'h1000;



				///////////////////////////////////////////////////
				// STARTING POINT : Reset the testbench
				///////////////////////////////////////////////////
				$display("1. Reset the testbench");
				host.reset(10);
				// MIn XGS model reset is 30 clk, set it to 50
				host.wait_n(1000);

				#160ns
					pcie_reset_n = 1'b1;

				///////////////////////////////////////////////////
				// Start setting up registers
				///////////////////////////////////////////////////
				$display("2. Starting XGS_athena register file accesses");


				///////////////////////////////////////////////////
				// Read the Matrox info register
				///////////////////////////////////////////////////
				axi_addr = TAG_OFFSET;
				$display("  2.1 Read the TAG register @0x%h", axi_addr);
				host.read(axi_addr, axi_read_data);
				assert (axi_read_data == 'h0058544d) else $error("Read error @0x%h", axi_addr);
				host.wait_n(10);


				///////////////////////////////////////////////////
				// Write/Read the scratch pad
				///////////////////////////////////////////////////
				axi_addr = SCRATCHPAD_OFFSET;
				axi_write_data = 'hcafefade;
				$display("  2.2 Write then Read back the SCRATCHPAD register @0x%h", axi_addr);
				host.write(axi_addr, axi_write_data);
				host.read(axi_addr, axi_read_data);
				assert (axi_read_data == axi_write_data) else $error("Write/Read error @0x%h", axi_addr);
				host.wait_n(10);


				///////////////////////////////////////////////////
				// DMA frame start register
				///////////////////////////////////////////////////
				$display("  2.3 Write FSTART register @0x%h", FSTART_OFFSET);
				host.write(FSTART_OFFSET, fstart);
				host.write(FSTART_HIGH_OFFSET, fstart>>32);
				host.wait_n(10);


				///////////////////////////////////////////////////
				// DMA line size register
				///////////////////////////////////////////////////
				$display("  2.4 Write LINESIZE register @0x%h", LINE_SIZE_OFFSET);
				host.write(LINE_SIZE_OFFSET, line_size);
				host.wait_n(10);


				///////////////////////////////////////////////////
				// DMA line pitch register
				///////////////////////////////////////////////////
				$display("  2.5 Write LINESIZE register @0x%h", LINE_PITCH_OFFSET);
				host.write(LINE_PITCH_OFFSET, line_pitch);
				host.wait_n(10);


				///////////////////////////////////////////////////
				// XGS Controller wakes up sensor
				///////////////////////////////////////////////////
				$display("3. XGS Controller wakes up sensor");
				$display("  3.1 Write SENSOR_CTRL register @0x%h", SENSOR_CTRL_OFFSET);
				axi_addr = SENSOR_CTRL_OFFSET;
				axi_write_data = 'h0003;
				axi_strb = 'h1;
				host.write(axi_addr, axi_write_data, axi_strb);


				///////////////////////////////////////////////////
				// Poll until clock enable and reset disable
				///////////////////////////////////////////////////
				$display("  3.2 Poll SENSOR_STAT register @0x%h", SENSOR_STAT_OFFSET);
				axi_addr = SENSOR_STAT_OFFSET;
				axi_poll_mask = 'h00000001;
				axi_expected_value = 'h00000001;
				host.poll(axi_addr, axi_expected_value, axi_poll_mask, .polling_period(1us));


				///////////////////////////////////////////////////
				// SPI configure the XGS sensor model
				///////////////////////////////////////////////////
				$display("4. SPI configure the XGS sensor model");

				// A minimum delay is required before we can start
				// SPI transactions
				#200us;


				///////////////////////////////////////////////////
				// SPI read XGS model id
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
					$error("XGS Model ID detected is %0d", data_rd);
				end


				///////////////////////////////////////////////////
				// SPI read revision
				///////////////////////////////////////////////////
				$display("  4.2 SPI read XGS revision number @0x%h", SPI_REVISION_NUMB_OFFSET);
				XGS_ReadSPI(SPI_REVISION_NUMB_OFFSET, data_rd);
				$display("Addres 0x31FE : XGS Revision ID detected is %x", data_rd);


				///////////////////////////////////////////////////
				// SPI reset
				///////////////////////////////////////////////////
				$display("  4.3 SPI write XGS register reset @0x%h", SPI_RESET_REGISTER_REG);
				XGS_WriteSPI(SPI_RESET_REGISTER_REG, 16'h001c);

				//- Wait at least 500us for the PLL to start and all clocks to be stable.
				#500us;
				//- REG Write = 0x3E3E, 0x0001
				$display("  4.4 SPI write XGS UNKNOWN register @0x%h", SPI_UNKNOWN_REGISTER_REG);
				XGS_WriteSPI(SPI_UNKNOWN_REGISTER_REG, 16'h0001);


				///////////////////////////////////////////////////
				// XGS model : setting mux output ratio to 4:1
				///////////////////////////////////////////////////
				// HISPI control common register
				// XGS_WriteSPI(16'h3e28,16'h2507);                     //mux 4:4
				// XGS_WriteSPI(16'h3e28,16'h2517);                     //mux 4:3
				// XGS_WriteSPI(16'h3e28,16'h2527);                     //mux 4:2
				$display("  4.5 SPI write XGS HiSPI control common register @0x%h", SPI_HISPI_CONTROL_COMMON_REG);
				XGS_WriteSPI(SPI_HISPI_CONTROL_COMMON_REG,16'h2537);    //mux 4:1
		
				
				///////////////////////////////////////////////////
				// XGS model : Set line time (for 6 lanes)
				///////////////////////////////////////////////////
				$display("  4.7 SPI write XGS set line time @0x%h", SPI_LINE_TIME_REG);
				line_time             = 'h02dc;                  // default in model and in devware is 0xe6  (24 lanes), XGS12M register is 0x16e @32.4Mhz (T=30.864ns)
				XGS_WriteSPI(SPI_LINE_TIME_REG, line_time);      // register_map(1032) <= X"00E6";    --Address 0x3810 - line_time


				///////////////////////////////////////////////////
				// XGS model : Slave Mode And ENABLE SEQUENCER
				///////////////////////////////////////////////////
				$display("  4.8 SPI write XGS set general config @0x%h", SPI_GENERAL_CONFIG0_REG);
				XGS_WriteSPI(SPI_GENERAL_CONFIG0_REG,16'h0030);                 // Slave + trigger mode
				XGS_WriteSPI(SPI_GENERAL_CONFIG0_REG,16'h0031);                 // Enable sequencer


				///////////////////////////////////////////////////
				// XGS model : Set Monitor pins
				///////////////////////////////////////////////////
				$display("  4.9 SPI write XGS set monitor pins @0x%h", SPI_MONITOR_REG);
				monitor_0_reg = 16'h6;    // 0x6 : Real Integration  , 0x2 : Integrate
				monitor_1_reg = 16'h10;   // EFOT indication
				monitor_2_reg = 16'h1;    // New_line
				XGS_WriteSPI(SPI_MONITOR_REG, (monitor_2_reg<<10) + (monitor_1_reg<<5) + monitor_0_reg );      // Monitor Lines


				///////////////////////////////////////////////////
				// PROGRAM XGS CONTROLLER
				///////////////////////////////////////////////////
				$display("5. SPI configure the XGS_athena IP-Core controller section");

				// A minimum delay is required before we can start
				// SPI transactions
				#50us;


				///////////////////////////////////////////////////
				// XGS Controller : SENSOR REG_UPDATE =1
				///////////////////////////////////////////////////
				// Give SPI control to XGS controller   : SENSOR REG_UPDATE =1
				$display("  5.1 Write SENSOR_CTRL register @0x%h", SENSOR_CTRL_OFFSET);
				host.write(SENSOR_CTRL_OFFSET, 16'h0012);


				///////////////////////////////////////////////////
				// XGS Controller : set the line time (in pixel clock)
				///////////////////////////////////////////////////
				// LINE_TIME
				// default in model and in devware is 0xe6  (24 lanes), XGS12M register is 0x16e @32.4Mhz (T=30.864ns)
				// default              in devware is 0xf4  (18 lanes)
				// default              in devware is 0x16e (12 lanes)
				// default              in devware is 0x2dc (6 lanes)
				$display("  5.2 Write READOUT_CFG3 (line time) register @0x%h", READOUT_CFG3_OFFSET);
				host.write(READOUT_CFG3_OFFSET, line_time);


				///////////////////////////////////////////////////
				// XGS Controller : exposure time during FOT
				///////////////////////////////////////////////////
				$display("  5.3 Write EXP_FOT (exposure time during FOT) register @0x%h", EXP_FOT_OFFSET);
				xgs_ctrl_period     = 16.0; // Ref clock preiod
				xgs_bitrate_period  = (1000.0/32.4)/(2.0);  // 30.864197ns /2

				EXP_FOT_TIME        = 5360;  //5.36us calculated from start of FOT to end of real exposure
				host.write(EXP_FOT_OFFSET, (1<<16) + (EXP_FOT_TIME/xgs_ctrl_period ));      //Enable EXP during FOT


				///////////////////////////////////////////////////
				// XGS Controller : Keepout trigger zone
				///////////////////////////////////////////////////
				$display("  5.4 Write READOUT_CFG4 (Keepout trigger zone) register @0x%h", READOUT_CFG4_OFFSET);

				KEEP_OUT_TRIG_START_sysclk = ((line_time*xgs_bitrate_period) - 100 ) / xgs_ctrl_period;  //START Keepout trigger zone (100ns)
				KEEP_OUT_TRIG_END_sysclk   = (line_time*xgs_bitrate_period)/xgs_ctrl_period;             //END   Keepout trigger zone (100ns), this is more for testing, monitor will reset the counter
				host.write(READOUT_CFG4_OFFSET, (KEEP_OUT_TRIG_END_sysclk<<16) + KEEP_OUT_TRIG_START_sysclk);
				host.write(READOUT_CFG3_OFFSET, (0<<16) + line_time);      //Enable KEEP_OUT ZONE[bit 16]



				///////////////////////////////////////////////////
				// XGS Controller : M_lines
				///////////////////////////////////////////////////
				$display("  5.5 Write SENSOR_M_LINES register @0x%h", SENSOR_M_LINES_OFFSET);
				MLines           = 0;
				MLines_supressed = 0;
				host.write(SENSOR_M_LINES_OFFSET, (MLines_supressed<<10)+ MLines);    //M_LINE REGISTER


				///////////////////////////////////////////////////
				// XGS Controller : Subsampling
				///////////////////////////////////////////////////
				$display("  5.6 Write SENSOR_SUBSAMPLING register @0x%h", SENSOR_SUBSAMPLING_OFFSET);
				host.write(SENSOR_SUBSAMPLING_OFFSET, 0);


				///////////////////////////////////////////////////
				// XGS Controller : Analog gain
				///////////////////////////////////////////////////
				$display("  5.7 Write SENSOR_GAIN_ANA register @0x%h", SENSOR_GAIN_ANA_OFFSET);
				host.write(SENSOR_GAIN_ANA_OFFSET, 2<<8);






				///////////////////////////////////////////////////
				// PROGRAM XGS HiSPi interface
				///////////////////////////////////////////////////
				$display("6. Configure the XGS_athena IP-Core HiSPi section");


				///////////////////////////////////////////////////
				// XGS HiSPi : Control
				///////////////////////////////////////////////////
				$display("  6.1 Write IDLE_CHARACTER register @0x%h", HISPI_CTRL_IDLE_CHARACTER_OFFSET);
				host.write(HISPI_CTRL_IDLE_CHARACTER_OFFSET,  HISPI_IDLE_CHARACTER);

				///////////////////////////////////////////////////
				// XGS HiSPi : Control, 6 lanes, mux 4
				///////////////////////////////////////////////////
				$display("  6.1 Write CTRL register @0x%h", HISPI_CTRL_OFFSET);
				host.write(HISPI_CTRL_OFFSET, 'h4603);


                $display("  6.1 Write FRAME_CFG register @0x%h", FRAME_CFG_OFFSET);
				host.write(FRAME_CFG_OFFSET, 'h0c1e1050); // Pour XGS12M


                ///////////////////////////////////////////////////
				// TEST i2c SEMAPHORE
				///////////////////////////////////////////////////
                host.write(I2C_SEMAPHORE_OFFSET, 1);
				host.read(I2C_SEMAPHORE_OFFSET, axi_read_data);
				host.read(I2C_SEMAPHORE_OFFSET, axi_read_data);
				host.read(I2C_SEMAPHORE_OFFSET, axi_read_data);
				host.read(I2C_SEMAPHORE_OFFSET, axi_read_data);
                host.write(I2C_SEMAPHORE_OFFSET, 1);
				host.read(I2C_SEMAPHORE_OFFSET, axi_read_data);
				host.read(I2C_SEMAPHORE_OFFSET, axi_read_data);
				host.read(I2C_SEMAPHORE_OFFSET, axi_read_data);
				host.read(I2C_SEMAPHORE_OFFSET, axi_read_data);
				
				///////////////////////////////////////////////////
				// XGS HiSPi : DEBUG Enable manual calibration
				///////////////////////////////////////////////////
				$display("  6.2 Write DEBUG register @0x%h", HISPI_DEBUG_OFFSET);
				manual_calib[4:0] = 5'b10101; // TAP lane 0
				manual_calib[9:5] = 5'b10101; // TAP lane 1
				manual_calib[14:10] = 5'b10101; // TAP lane 2
				manual_calib[19:15] = 5'b10101; // TAP lane 3
				manual_calib[24:20] = 5'b10101; // TAP lane 4
				manual_calib[29:25] = 5'b10101; // TAP lane 5

				manual_calib[30] = 1'b1; // Load calibration tap
				manual_calib[31] = 1'b1; // Manual calib enable

				host.write(HISPI_DEBUG_OFFSET, manual_calib);
				#100ns


				///////////////////////////////////////////////////
				// XGS HiSPi : DEBUG Disable manual calibration
				///////////////////////////////////////////////////
				$display("  6.3 Write DEBUG register @0x%h", HISPI_DEBUG_OFFSET);
				manual_calib = 'hC0000000; // Manual calib enable
				host.write(HISPI_DEBUG_OFFSET, manual_calib);
				#100ns
				manual_calib = 'h00000000; // Manual calib enable
				host.write(HISPI_DEBUG_OFFSET, manual_calib);
				#100ns


				///////////////////////////////////////////////////
				// XGS HiSPi : Control Start a calibration
				///////////////////////////////////////////////////
				$display("  6.4 Write CTRL register @0x%h", HISPI_CTRL_OFFSET);
				host.write(HISPI_CTRL_OFFSET, 'h4607);


				//-------------------------------------------------
				// Generation de l'image du senseur XGS  
				//
				// XGS Image Pattern : 
				//   0 : Random 12 bpp
                //   1 : Ramp 12bpp
                //   2 : Ramp 8bpp (MSB, +16pixel 12bpp)	
                //				
				//--------------------------------------------------
				GenImage_XGS(2);                                     // Le modele XGS cree le .pgm et loade dans le vhdl
				XGS_imageSRC.load_image;                                // Load le .pgm dans la class SystemVerilog
        		XGS_imageSRC.reduce_bit_depth();                        // Converti Image 14bpp a 8bpp (LSR 4)        		
				
				
				
				///////////////////////////////////////////////////
				// Program X Origin of valid data, in HiSPI
				///////////////////////////////////////////////////
                // X origin 
				ROI_X_START  = 32;                    // 32, est non centre.  36 est le origine pour une image de 4096 pixels centree.
                ROI_X_END    = ROI_X_START+4096-1;              			
				
				host.write(FRAME_CFG_X_VALID_OFFSET,  (ROI_X_END<<16)+ ROI_X_START);	

				///////////////////////////////////////////////////
				// Trigger ROI #0
				///////////////////////////////////////////////////
				ROI_Y_START = 0;    // Doit etre multiple de 4 
				ROI_Y_SIZE  = 4;      // Doit etre multiple de 4, (ROI_Y_START+ROI_Y_SIZE) <= 3100 est le max qu'on peut mettre, attention!
				$display("IMAGE Trigger #0, Xstart=%0d, Xend=%0d (Xsize=%0d)), Ystart=%0d, Ysize=%0d", ROI_X_START, ROI_X_END,  (ROI_X_END-ROI_X_START+1), ROI_Y_START, ROI_Y_SIZE);
				host.write(SENSOR_ROI_Y_START_OFFSET, ROI_Y_START/4);
				host.write(SENSOR_ROI_Y_SIZE_OFFSET, ROI_Y_SIZE/4);
				host.write(EXP_CTRL1_OFFSET, EXPOSURE * (1000.0 /xgs_ctrl_period));  // Exposure 50us @100mhz
				host.write(GRAB_CTRL_OFFSET, (1<<15)+(1<<8)+1);                      // Grab_ctrl: source is immediate + trig_overlap + grab cmd
                test_nb_images++;

                XGS_image = XGS_imageSRC.copy;
				XGS_image.crop(ROI_X_START, ROI_X_END, ROI_Y_START, (ROI_Y_START + ROI_Y_SIZE-1) );
				scoreboard.predict_img(XGS_image, fstart, line_size, line_pitch);

				///////////////////////////////////////////////////
				// Trigger ROI #1
				///////////////////////////////////////////////////
				ROI_Y_START = 3088;    // Doit etre multiple de 4 
				ROI_Y_SIZE  = 12;      // Doit etre multiple de 4, (ROI_Y_START+ROI_Y_SIZE) <= 3100 est le max qu'on peut mettre, attention!
				$display("IMAGE Trigger #1, Xstart=%0d, Xend=%0d (Xsize=%0d)), Ystart=%0d, Ysize=%0d", ROI_X_START, ROI_X_END,  (ROI_X_END-ROI_X_START+1), ROI_Y_START, ROI_Y_SIZE);
				host.write(SENSOR_ROI_Y_START_OFFSET, ROI_Y_START/4);
				host.write(SENSOR_ROI_Y_SIZE_OFFSET, ROI_Y_SIZE/4);
				host.write(EXP_CTRL1_OFFSET, EXPOSURE * (1000.0 /xgs_ctrl_period));  // Exposure 50us @100mhz
				host.write(GRAB_CTRL_OFFSET, (1<<15)+(1<<8)+1);                      // Grab_ctrl: source is immediate + trig_overlap + grab cmd
                test_nb_images++;

                XGS_image = XGS_imageSRC.copy;
				XGS_image.crop(ROI_X_START, ROI_X_END, ROI_Y_START, (ROI_Y_START + ROI_Y_SIZE-1) );
				scoreboard.predict_img(XGS_image, fstart, line_size, line_pitch);		
				
				
				///////////////////////////////////////////////////
				// Wait for 2 end of DMA irq event
				///////////////////////////////////////////////////
				while (dma_irq_cntr != test_nb_images) begin
					#1us;
				end
				
				
				// Terminate the simulation
				///////////////////////////////////////////////////
				//host.wait_n(1000);

			end

		join_any;

		///////////////////////////////////////////////////
		// Terminate the successfull simulation
		///////////////////////////////////////////////////
		#1us;
		$display("######################################################");
		$display("###         Simulation completed successfully      ###");
		$display("###                                                ###");
		$display("###           BRAVO CHAMPION, WELL DONE!!!         ###");
		$display("######################################################");
		$finish;
	end


	////////////////////////////////////////////////////////////////
	// Task : XGS_WriteSPI
	////////////////////////////////////////////////////////////////
	task automatic XGS_WriteSPI(input int add, input int data);
		host.write(BAR_XGS_ATHENA+16'h0160,(data<<16) + add);
		host.write(BAR_XGS_ATHENA+16'h0158,(0<<16) + 1);               // write cmd "WRITE SERIAL" into fifo
		host.write(BAR_XGS_ATHENA+16'h0158, 1<<4);                     // read from fifo
	endtask : XGS_WriteSPI


	////////////////////////////////////////////////////////////////
	// Task : XGS_ReadSPI
	////////////////////////////////////////////////////////////////
	task automatic XGS_ReadSPI(input int add, output int data);
		int data_rd;
		int axi_addr;
		int axi_poll_mask;
		int axi_expected_value;

		host.write(BAR_XGS_ATHENA+16'h0160, add);
		host.write(BAR_XGS_ATHENA+16'h0158, (1<<16) + 1);               // write cmd "READ SERIAL" into fifo
		host.write(BAR_XGS_ATHENA+16'h0158, 1<<4);                      // read from fifo

		axi_addr = BAR_XGS_ATHENA + 'h00000168;
		axi_poll_mask = (1<<16);
		axi_expected_value = 0;
		host.poll(axi_addr, axi_expected_value, axi_poll_mask, .polling_period(1us));

		host.read(axi_addr, data_rd);
		data= data_rd & 'h0000ffff;
	endtask : XGS_ReadSPI


	////////////////////////////////////////////////////////////////
	// Task : XGS_ReadSPI
	////////////////////////////////////////////////////////////////
	task automatic GenImage_XGS(input int ImgPattern);
		xgs_model_GenImage = 1'b0;      
	    XGS_WriteSPI(SPI_TEST_PATTERN_MODE_REG, ImgPattern);		
		host.poll(BAR_XGS_ATHENA + 'h00000168, 0, (1<<16), .polling_period(1us));  // attendre la fin de l'ecriture au registre XGS via SPI!  
	    #1ns;
		xgs_model_GenImage = 1'b1;      // Cree le .pgm et loade le modele XGS vhdl
	    #1ns;
		xgs_model_GenImage = 1'b0;     
	    #1ns;		
	endtask : GenImage_XGS	
	

endmodule

