`timescale 1ns/1ps

import fpga_cfg_pkg::*;

module system_top(

    // Regfile interface with host
	input logic aclk,
	input logic aclk_reset_n,
	input logic [10:0] aclk_awaddr,
	input logic [2:0] aclk_awprot,
	input logic aclk_awvalid,
	output logic aclk_awready,
	input logic [31:0] aclk_wdata,
	input logic [3:0] aclk_wstrb,
	input logic aclk_wvalid,
	output logic aclk_wready,
	output logic [1:0] aclk_bresp,
	output logic aclk_bvalid,
	input logic aclk_bready,
	input logic [10:0] aclk_araddr,
	input logic [2:0] aclk_arprot,
	input logic aclk_arvalid,
	output logic aclk_arready,
	output logic [31:0] aclk_rdata,
	output logic [1 :0] aclk_rresp,
	output logic aclk_rvalid,
	input logic aclk_rready,

    // AXI STREAM interface with host (output to HOST)
	input  logic s_axis_tx_tready,
	output logic [63:0] s_axis_tx_tdata,
	output logic s_axis_tx_tlast,
	output logic s_axis_tx_tvalid,
	output logic [3:0] s_axis_tx_tuser,

	output logic irq_dma,
	input  logic [1:0] XGSmodel_sel,
	input  logic anput_ext_trig

);

	parameter NUMBER_OF_LANE = 6; // 4 Not supported yet...
	parameter MUX_RATIO = 4;
	parameter PIXELS_PER_LINE=4176;
	parameter LINE_PER_FRAME=3102;
	parameter PIXEL_SIZE = 12;
	parameter NUMBER_ACTIVE_LINES = 8;
	parameter SYS_CLK_PERIOD= 16;
	parameter SENSOR_FREQ = 32400;
	parameter SIMULATION = 1;
	parameter EXPOSURE=50;
	//parameter COLOR = 1;

	parameter AXIL_DATA_WIDTH = 32;
	parameter AXIL_ADDR_WIDTH = 11;
	parameter AXIS_DATA_WIDTH = 64;
	parameter AXIS_USER_WIDTH = 4;
	parameter GPIO_NUMB_INPUT = 1;
	parameter GPIO_NUMB_OUTPUT = 1;
	parameter MAX_PCIE_PAYLOAD_SIZE = 256; // 128, 256, 512. 1024
	parameter HISPI_IDLE_CHARACTER = 12'h3A6;

	parameter BAR_XGS_ATHENA        = 32'h00000000;

	// XGS_athena system
	parameter TAG_OFFSET            = 'h0000;
	parameter SCRATCHPAD_OFFSET     = 'h000c;

    parameter XGS_TYPE = 5000;

	integer  address;
	integer  data;
	integer  ben;
	integer  i;

	//clock and reset signal declaration
	bit 	   idelay_clk=1'b0;
	bit 	   sclk=1'b0;
	bit 	   sclk_reset_n;
	bit 	   pcie_clk=1'b0;
	bit 	   cfg_bus_mast_en;
	bit [2:0]  cfg_setmaxpld;
	bit [7:0]  irq;
	bit 	   XGS_MODEL_EXTCLK  = 0;

	logic 	   xgs_power_good;
	logic 	   xgs_clk_pll_en;
	logic 	   xgs_reset_n;
	logic 	   xgs_fwsi_en;

	logic 	   xgs_sclk;
	logic 	   xgs_cs_n;
	logic 	   xgs_sdout;
	logic 	   xgs_sdin;
	logic 	   xgs_monitor0;
	logic 	   xgs_monitor1;
	logic 	   xgs_monitor2;
	logic 	   xgs_trig_int;
	logic 	   xgs_trig_rd;

	logic 	   xgs_reset_n_5000;
	logic 	   refclk_5000;
	logic 	   xgs_sclk_5000;
	logic 	   xgs_cs_n_5000;
	logic 	   xgs_sdout_5000;
	logic 	   xgs_sdin_5000;
	wire 	   xgs_monitor0_5000;
	wire 	   xgs_monitor1_5000;
	wire 	   xgs_monitor2_5000;
	logic 	   xgs_trig_int_5000;
	logic 	   xgs_trig_rd_5000;

	logic 	   xgs_reset_n_12000;
	logic 	   refclk_12000;
	logic 	   xgs_sclk_12000;
	logic 	   xgs_cs_n_12000;
	logic 	   xgs_sdout_12000;
	logic 	   xgs_sdin_12000;
	wire 	   xgs_monitor0_12000;
	wire 	   xgs_monitor1_12000;
	wire 	   xgs_monitor2_12000;
	logic 	   xgs_trig_int_12000;
	logic 	   xgs_trig_rd_12000;

	logic 	   xgs_reset_n_16000;
	logic 	   refclk_16000;
	logic 	   xgs_sclk_16000;
	logic 	   xgs_cs_n_16000;
	logic 	   xgs_sdout_16000;
	logic 	   xgs_sdin_16000;
	wire 	   xgs_monitor0_16000;
	wire 	   xgs_monitor1_16000;
	wire 	   xgs_monitor2_16000;
	logic 	   xgs_trig_int_16000;
	logic 	   xgs_trig_rd_16000;

	//logic 	   anput_ext_trig;
	logic 	   anput_strobe_out;
	logic 	   anput_exposure_out;
	logic 	   anput_trig_rdy_out;

	// -- led_out(0) --> vert, led_out(1) --> rouge
	logic [1:0] led_out;

    // Interfaces between modules
	axi_stream_interface #(.T_DATA_WIDTH(AXIS_DATA_WIDTH), .T_USER_WIDTH(AXIS_USER_WIDTH)) tx_axis();
	io_interface #(GPIO_NUMB_INPUT,GPIO_NUMB_OUTPUT) if_gpio();

	hispi_interface #(.NUMB_LANE(NUMBER_OF_LANE)) if_hispi(XGS_MODEL_EXTCLK);
	hispi_interface #(.NUMB_LANE(NUMBER_OF_LANE)) if_hispi_5000(XGS_MODEL_EXTCLK);
	hispi_interface #(.NUMB_LANE(NUMBER_OF_LANE)) if_hispi_12000(XGS_MODEL_EXTCLK);
	hispi_interface #(.NUMB_LANE(NUMBER_OF_LANE)) if_hispi_16000(XGS_MODEL_EXTCLK);

	tlp_interface tlp();


    //---------------------------------------
	//  MODELE XGS 5000
	//---------------------------------------
	xgs12m_chip
		#(
    		.G_xgs_image_file_dec   ("XGS_image_5000_dec.pgm"),
    		.G_xgs_image_file_hex12 ("XGS_image_5000_hex12.pgm"),
    		.G_xgs_image_file_hex8  ("XGS_image_5000_hex8.pgm"),
			.G_MODEL_ID         (16'h0358),
			.G_REV_ID           (16'h0000),
			.G_NUM_PHY          (4),
			.G_PXL_PER_COLRAM   (174),
			.G_PXL_ARRAY_ROWS   (2078)
			//.G_PXL_ARRAY_ROWS   (1000)
		)
		XGS_MODEL_5000
		(
			.xgs_model_GenImage(1'b0),

			.TRIGGER_INT(xgs_trig_int_5000),

			.MONITOR0(xgs_monitor0_5000),
			.MONITOR1(xgs_monitor1_5000),
			.MONITOR2(xgs_monitor2_5000),

			.RESET_B(xgs_reset_n_5000),
			.EXTCLK(refclk_5000),
			.FWSI_EN(1'b1),

			.SCLK(xgs_sclk_5000),
			.SDATA(xgs_sdout_5000),
			.CS(xgs_cs_n_5000),
			.SDATAOUT(xgs_sdin_5000),

			.D_CLK_0_N(),
			.D_CLK_0_P(),
			.D_CLK_1_N(),
			.D_CLK_1_P(),

			.D_CLK_2_N(if_hispi_5000.hclk_n[0]),
			.D_CLK_2_P(if_hispi_5000.hclk_p[0]),
			.D_CLK_3_N(if_hispi_5000.hclk_n[1]),
			.D_CLK_3_P(if_hispi_5000.hclk_p[1]),
			.D_CLK_4_N(),
			.D_CLK_4_P(),
			.D_CLK_5_N(),
			.D_CLK_5_P(),

			.DATA_0_N (if_hispi_5000.data_n[0]),
			.DATA_0_P (if_hispi_5000.data_p[0]),
			.DATA_1_P (if_hispi_5000.data_p[1]),
			.DATA_1_N (if_hispi_5000.data_n[1]),
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
			.DATA_8_N (if_hispi_5000.data_n[2]),
			.DATA_8_P (if_hispi_5000.data_p[2]),
			.DATA_9_N (if_hispi_5000.data_n[3]),
			.DATA_9_P (if_hispi_5000.data_p[3]),
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
			.DATA_16_N(if_hispi_5000.data_n[4]),
			.DATA_16_P(if_hispi_5000.data_p[4]),
			.DATA_17_N(if_hispi_5000.data_n[5]),
			.DATA_17_P(if_hispi_5000.data_p[5]),
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


    //---------------------------------------
	//  MODELE XGS 12000
	//---------------------------------------
	xgs12m_chip
		#(
	   		.G_xgs_image_file_dec   ("XGS_image_12000_dec.pgm"),
	   		.G_xgs_image_file_hex12 ("XGS_image_12000_hex12.pgm"),
	   		.G_xgs_image_file_hex8  ("XGS_image_12000_hex8.pgm"),
			.G_MODEL_ID         (16'h0058),
			.G_REV_ID           (16'h0002),
			.G_NUM_PHY          (6),
			.G_PXL_PER_COLRAM   (174),
			.G_PXL_ARRAY_ROWS   (3102)
			//.G_PXL_ARRAY_ROWS   (1000)
		)
		XGS_MODEL_12000
		(
			.xgs_model_GenImage(1'b0),

			.TRIGGER_INT(xgs_trig_int_12000),
			.MONITOR0(xgs_monitor0_12000),
			.MONITOR1(xgs_monitor1_12000),
			.MONITOR2(xgs_monitor2_12000),
			.RESET_B(xgs_reset_n_12000),
			.EXTCLK(refclk_12000),
			.FWSI_EN(1'b1),
			.SCLK(xgs_sclk_12000),
			.SDATA(xgs_sdout_12000),
			.CS(xgs_cs_n_12000),
			.SDATAOUT(xgs_sdin_12000),
			.D_CLK_0_N(),
			.D_CLK_0_P(),
			.D_CLK_1_N(),
			.D_CLK_1_P(),
			.D_CLK_2_N(if_hispi_12000.hclk_n[0]),
			.D_CLK_2_P(if_hispi_12000.hclk_p[0]),
			.D_CLK_3_N(if_hispi_12000.hclk_n[1]),
			.D_CLK_3_P(if_hispi_12000.hclk_p[1]),
			.D_CLK_4_N(),
			.D_CLK_4_P(),
			.D_CLK_5_N(),
			.D_CLK_5_P(),
			.DATA_0_N (if_hispi_12000.data_n[0]),
			.DATA_0_P (if_hispi_12000.data_p[0]),
			.DATA_1_P (if_hispi_12000.data_p[1]),
			.DATA_1_N (if_hispi_12000.data_n[1]),
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
			.DATA_8_N (if_hispi_12000.data_n[2]),
			.DATA_8_P (if_hispi_12000.data_p[2]),
			.DATA_9_N (if_hispi_12000.data_n[3]),
			.DATA_9_P (if_hispi_12000.data_p[3]),
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
			.DATA_16_N(if_hispi_12000.data_n[4]),
			.DATA_16_P(if_hispi_12000.data_p[4]),
			.DATA_17_N(if_hispi_12000.data_n[5]),
			.DATA_17_P(if_hispi_12000.data_p[5]),
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

    //---------------------------------------
	//  MODELE XGS 16000
	//---------------------------------------
	xgs12m_chip
		#(
    		.G_xgs_image_file_dec   ("XGS_image_16000_dec.pgm"),
    		.G_xgs_image_file_hex12 ("XGS_image_16000_hex12.pgm"),
   		    .G_xgs_image_file_hex8  ("XGS_image_16000_hex8.pgm"),

			.G_MODEL_ID         (16'h0258),
			.G_REV_ID           (16'h0000),
			.G_NUM_PHY          (6),
			.G_PXL_PER_COLRAM   (174),
			.G_PXL_ARRAY_ROWS   (4030)
			//.G_PXL_ARRAY_ROWS   (1000)
		)
		XGS_MODEL_16000
		(
			.xgs_model_GenImage(1'b0),

			.TRIGGER_INT(xgs_trig_int_16000),

			.MONITOR0(xgs_monitor0_16000),
			.MONITOR1(xgs_monitor1_16000),
			.MONITOR2(xgs_monitor2_16000),

			.RESET_B(xgs_reset_n_16000),
			.EXTCLK(refclk_16000),
			.FWSI_EN(1'b1),

			.SCLK(xgs_sclk_16000),
			.SDATA(xgs_sdout_16000),
			.CS(xgs_cs_n_16000),
			.SDATAOUT(xgs_sdin_16000),

			.D_CLK_0_N(),
			.D_CLK_0_P(),
			.D_CLK_1_N(),
			.D_CLK_1_P(),

			.D_CLK_2_N(if_hispi_16000.hclk_n[0]),
			.D_CLK_2_P(if_hispi_16000.hclk_p[0]),
			.D_CLK_3_N(if_hispi_16000.hclk_n[1]),
			.D_CLK_3_P(if_hispi_16000.hclk_p[1]),
			.D_CLK_4_N(),
			.D_CLK_4_P(),
			.D_CLK_5_N(),
			.D_CLK_5_P(),

			.DATA_0_N (if_hispi_16000.data_n[0]),
			.DATA_0_P (if_hispi_16000.data_p[0]),
			.DATA_1_P (if_hispi_16000.data_p[1]),
			.DATA_1_N (if_hispi_16000.data_n[1]),
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
			.DATA_8_N (if_hispi_16000.data_n[2]),
			.DATA_8_P (if_hispi_16000.data_p[2]),
			.DATA_9_N (if_hispi_16000.data_n[3]),
			.DATA_9_P (if_hispi_16000.data_p[3]),
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
			.DATA_16_N(if_hispi_16000.data_n[4]),
			.DATA_16_P(if_hispi_16000.data_p[4]),
			.DATA_17_N(if_hispi_16000.data_n[5]),
			.DATA_17_P(if_hispi_16000.data_p[5]),
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

    always @(*) begin

		if(XGSmodel_sel == 0) begin

			xgs_reset_n_12000 = 0;
			xgs_sclk_12000    = 0;
			xgs_sdout_12000   = 0;
			xgs_cs_n_12000    = 1;
    	    refclk_12000      = 0;
		    xgs_trig_int_12000= 0;

			xgs_reset_n_16000 = 0;
			xgs_sclk_16000    = 0;
			xgs_sdout_16000   = 0;
			xgs_cs_n_16000    = 1;
    	    refclk_16000      = 0;
		    xgs_trig_int_16000= 0;

			if_hispi.hclk_n[0] = if_hispi_5000.hclk_n[0];
			if_hispi.hclk_p[0] = if_hispi_5000.hclk_p[0];
			if_hispi.hclk_n[1] = if_hispi_5000.hclk_n[1];
			if_hispi.hclk_p[1] = if_hispi_5000.hclk_p[1];

			if_hispi.data_n[0] = if_hispi_5000.data_n[0];
			if_hispi.data_p[0] = if_hispi_5000.data_p[0];
			if_hispi.data_n[1] = if_hispi_5000.data_n[1];
			if_hispi.data_p[1] = if_hispi_5000.data_p[1];

			if_hispi.data_n[2] = if_hispi_5000.data_n[2];
			if_hispi.data_p[2] = if_hispi_5000.data_p[2];
			if_hispi.data_n[3] = if_hispi_5000.data_n[3];
			if_hispi.data_p[3] = if_hispi_5000.data_p[3];

			if_hispi.data_n[4] = if_hispi_5000.data_n[4];
			if_hispi.data_p[4] = if_hispi_5000.data_p[4];
			if_hispi.data_n[5] = if_hispi_5000.data_n[5];
			if_hispi.data_p[5] = if_hispi_5000.data_p[5];

			xgs_monitor0     = xgs_monitor0_5000;
			xgs_monitor1     = xgs_monitor1_5000;
			xgs_monitor2     = xgs_monitor2_5000;
			xgs_sdin         = xgs_sdin_5000;

    	    refclk_5000      = XGS_MODEL_EXTCLK;
			xgs_reset_n_5000 = xgs_reset_n;
			xgs_sclk_5000    = xgs_sclk;
			xgs_cs_n_5000    = xgs_cs_n;
			xgs_sdout_5000   = xgs_sdout;
			xgs_trig_int_5000= xgs_trig_int;

		end else
			if(XGSmodel_sel == 1) begin

				xgs_reset_n_5000  = 0;
				xgs_sclk_5000     = 0;
				xgs_sdout_5000    = 0;
				xgs_cs_n_5000     = 1;
    	        refclk_5000       = 0;
		        xgs_trig_int_5000 = 0;

				xgs_reset_n_16000 = 0;
				xgs_sclk_16000    = 0;
				xgs_sdout_16000   = 0;
				xgs_cs_n_16000    = 1;
    	    	refclk_16000      = 0;
		    	xgs_trig_int_16000= 0;

				if_hispi.hclk_n[0] = if_hispi_12000.hclk_n[0];
				if_hispi.hclk_p[0] = if_hispi_12000.hclk_p[0];
				if_hispi.hclk_n[1] = if_hispi_12000.hclk_n[1];
				if_hispi.hclk_p[1] = if_hispi_12000.hclk_p[1];

				if_hispi.data_n[0] = if_hispi_12000.data_n[0];
				if_hispi.data_p[0] = if_hispi_12000.data_p[0];
				if_hispi.data_n[1] = if_hispi_12000.data_n[1];
				if_hispi.data_p[1] = if_hispi_12000.data_p[1];

				if_hispi.data_n[2] = if_hispi_12000.data_n[2];
				if_hispi.data_p[2] = if_hispi_12000.data_p[2];
				if_hispi.data_n[3] = if_hispi_12000.data_n[3];
				if_hispi.data_p[3] = if_hispi_12000.data_p[3];

				if_hispi.data_n[4] = if_hispi_12000.data_n[4];
				if_hispi.data_p[4] = if_hispi_12000.data_p[4];
				if_hispi.data_n[5] = if_hispi_12000.data_n[5];
				if_hispi.data_p[5] = if_hispi_12000.data_p[5];

				xgs_monitor0     = xgs_monitor0_12000;
				xgs_monitor1     = xgs_monitor1_12000;
				xgs_monitor2     = xgs_monitor2_12000;
				xgs_sdin         = xgs_sdin_12000;

    	        refclk_12000      = XGS_MODEL_EXTCLK;
				xgs_reset_n_12000 = xgs_reset_n;
				xgs_sclk_12000    = xgs_sclk;
				xgs_cs_n_12000    = xgs_cs_n;
				xgs_sdout_12000   = xgs_sdout;
			    xgs_trig_int_12000= xgs_trig_int;

			end

			else
				if(XGSmodel_sel == 2) begin

					xgs_reset_n_5000  = 0;
					xgs_sclk_5000     = 0;
					xgs_sdout_5000    = 0;
					xgs_cs_n_5000     = 1;
    	        	refclk_5000       = 0;
		        	xgs_trig_int_5000 = 0;

					xgs_reset_n_12000 = 0;
					xgs_sclk_12000    = 0;
					xgs_sdout_12000   = 0;
					xgs_cs_n_12000    = 1;
    	        	refclk_12000      = 0;
		        	xgs_trig_int_12000= 0;

					if_hispi.hclk_n[0] = if_hispi_16000.hclk_n[0];
					if_hispi.hclk_p[0] = if_hispi_16000.hclk_p[0];
					if_hispi.hclk_n[1] = if_hispi_16000.hclk_n[1];
					if_hispi.hclk_p[1] = if_hispi_16000.hclk_p[1];

					if_hispi.data_n[0] = if_hispi_16000.data_n[0];
					if_hispi.data_p[0] = if_hispi_16000.data_p[0];
					if_hispi.data_n[1] = if_hispi_16000.data_n[1];
					if_hispi.data_p[1] = if_hispi_16000.data_p[1];

					if_hispi.data_n[2] = if_hispi_16000.data_n[2];
					if_hispi.data_p[2] = if_hispi_16000.data_p[2];
					if_hispi.data_n[3] = if_hispi_16000.data_n[3];
					if_hispi.data_p[3] = if_hispi_16000.data_p[3];

					if_hispi.data_n[4] = if_hispi_16000.data_n[4];
					if_hispi.data_p[4] = if_hispi_16000.data_p[4];
					if_hispi.data_n[5] = if_hispi_16000.data_n[5];
					if_hispi.data_p[5] = if_hispi_16000.data_p[5];

					xgs_monitor0     = xgs_monitor0_16000;
					xgs_monitor1     = xgs_monitor1_16000;
					xgs_monitor2     = xgs_monitor2_16000;
					xgs_sdin         = xgs_sdin_16000;

    	        	refclk_16000      = XGS_MODEL_EXTCLK;
					xgs_reset_n_16000 = xgs_reset_n;
					xgs_sclk_16000    = xgs_sclk;
					xgs_cs_n_16000    = xgs_cs_n;
					xgs_sdout_16000   = xgs_sdout;
			    	xgs_trig_int_16000= xgs_trig_int;
				end

	end







	XGS_athena  #(
			.ENABLE_IDELAYCTRL(),
			.NUMBER_OF_LANE(NUMBER_OF_LANE),
			.MAX_PCIE_PAYLOAD_SIZE(MAX_PCIE_PAYLOAD_SIZE),
			.SYS_CLK_PERIOD(SYS_CLK_PERIOD),
			.SENSOR_FREQ(SENSOR_FREQ),
			.SIMULATION(SIMULATION),
			.COLOR(COLOR)
		) DUT (
			.aclk(aclk),
			.aclk_reset_n(aclk_reset_n),
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
			.aclk_awaddr(aclk_awaddr),
			.aclk_awprot(aclk_awprot),
			.aclk_awvalid(aclk_awvalid),
			.aclk_awready(aclk_awready),
			.aclk_wdata(aclk_wdata),
			.aclk_wstrb(aclk_wstrb),
			.aclk_wvalid(aclk_wvalid),
			.aclk_wready(aclk_wready),
			.aclk_bresp(aclk_bresp),
			.aclk_bvalid(aclk_bvalid),
			.aclk_bready(aclk_bready),
			.aclk_araddr(aclk_araddr),
			.aclk_arprot(aclk_arprot),
			.aclk_arvalid(aclk_arvalid),
			.aclk_arready(aclk_arready),
			.aclk_rdata(aclk_rdata),
			.aclk_rresp(aclk_rresp),
			.aclk_rvalid(aclk_rvalid),
			.aclk_rready(aclk_rready),
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

    assign irq_dma = irq[0];

	pcie_tx_axi #(.NB_PCIE_AGENTS(1), .AGENT_IS_64_BIT(1'b1), .C_DATA_WIDTH(64)) inst_pcie_tx_axi
		(
			.sys_clk(aclk),
			.sys_reset_n(aclk_reset_n),
			.s_axis_tx_tready(s_axis_tx_tready), // No back pressure from PCIe
			.s_axis_tx_tdata(s_axis_tx_tdata),
			.s_axis_tx_tkeep(),
			.s_axis_tx_tlast(s_axis_tx_tlast),
			.s_axis_tx_tvalid(s_axis_tx_tvalid),
			.s_axis_tx_tuser(s_axis_tx_tuser),
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
    // 200mhz pour le idelay ctrl
	always #2.5 idelay_clk = ~idelay_clk;

	assign xgs_power_good = 1'b1;
	//assign anput_ext_trig = 1'b0;

	assign cfg_bus_mast_en = 1'b1;

	// PCIE Device Control Register (Offset 08h); bits 7:5
    //	000b 128 bytes max payload size
    //	001b 256 bytes max payload size
    //	010b 512 bytes max payload size
    //	011b 1024 bytes max payload size
	//  Others, not supported
	assign cfg_setmaxpld = 3'b001;
	//assign tx_axis.tready = 1'b1;

	// TLP interface clock (pcie clk)
	assign tlp.clk = pcie_clk;

	always_ff @(posedge sclk)
	begin
		sclk_reset_n <= aclk_reset_n;
	end


endmodule

