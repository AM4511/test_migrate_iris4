`timescale 1ns/1ps

import driver_pkg::*;

module testbench_athena();

	//  parameter master_agent = "DUT.system_i.modelAxiMasterLite_0.inst";

	parameter BAR_XGS_CTRL   = 32'h00000000;
	parameter BAR_AXIHISPI   = 32'h00001000;

	parameter AXI_DATA_WIDTH   = 32;
	parameter AXI_ADDR_WIDTH   = 32;
	parameter GPIO_INPUT_WIDTH   = 1;
	parameter GPIO_OUTPUT_WIDTH   = 1;

	int axi_addr;
	int axi_data;
	int axi_strb;
	int axi_poll_mask;
	int axi_expected_value;
	int data_rd;
	int timeout = 10000;

	int MLines;
	int MLines_supressed;
	int FLines;
	int FLines_supressed;
 
	int ROI_YSTART;
	int ROI_YSIZE;
	int EXPOSURE;
	int EXP_FOT_TIME;

	
	//clock and reset signal declaration
	bit axiClk100MHz;
	bit idelayClk;
	bit axiReset_n;
	bit dma_irq;
        bit pciAxiReset_n;
        bit pcieAxiClk62MHz;
	bit [15:0] line_time   = 16'h00e6;  //default model
	bit [4:0] monitor_0_reg;
	bit [4:0] monitor_1_reg;
	bit [4:0] monitor_2_reg;
	bit [15:0] KEEP_OUT_TRIG_START_sysclk;
	bit [15:0] KEEP_OUT_TRIG_END_sysclk;
	
	real xgs_ctrl_period     = 10.0;
	real xgs_bitrate_period  = (1000.0/32.4)/(2.0*12.0);  //32.4Mhz ref clk*2 /12 bits per clk

	
	Cdriver_axil #(.DATA_WIDTH(AXI_DATA_WIDTH),.ADDR_WIDTH(AXI_ADDR_WIDTH), .NUMB_INPUT_IO(GPIO_INPUT_WIDTH), .NUMB_OUTPUT_IO(GPIO_OUTPUT_WIDTH)) master_agent;


	// Interface
	axi_lite_interface #(.DATA_WIDTH(AXI_DATA_WIDTH), .ADDR_WIDTH(AXI_ADDR_WIDTH)) axil(axiClk100MHz);
	io_interface #(.NUMB_INPUT_IO(GPIO_INPUT_WIDTH),.NUMB_OUTPUT_IO(GPIO_OUTPUT_WIDTH)) gpio_if();


	// Clock and Reset generation
	//always #5 axiClk100MHz = ~axiClk100MHz; TODO
	always #2.5  idelayClk = ~idelayClk;
	always #5    axiClk100MHz = ~axiClk100MHz;
	always #8    pcieAxiClk62MHz =~pcieAxiClk62MHz;


	task automatic XGS_WriteSPI(input int add, input int data);
		master_agent.write(BAR_XGS_CTRL+16'h0160,(data<<16) + add);
		master_agent.write(BAR_XGS_CTRL+16'h0158,(0<<16) + 1);               // write cmd "WRITE SERIAL" into fifo
		master_agent.write(BAR_XGS_CTRL+16'h0158, 1<<4);                      // read from fifo
	endtask : XGS_WriteSPI


	task automatic XGS_ReadSPI(input int add, output int data);
		int data_rd;
		master_agent.write(BAR_XGS_CTRL+16'h0160, add);
		master_agent.write(BAR_XGS_CTRL+16'h0158, (1<<16) + 1);               // write cmd "READ SERIAL" into fifo
		master_agent.write(BAR_XGS_CTRL+16'h0158, 1<<4);                      // read from fifo

		//wait for read access to be done, and return data to SV
//		do
//		begin
//			master_agent.read(BAR_XGS_CTRL+32'h00000168, data_rd);
//		end
//		while(data_rd[16] == 1);
		axi_addr = BAR_XGS_CTRL + 'h00000168;
		axi_poll_mask = (1<<16);
		axi_expected_value = 0;
		master_agent.poll(axi_addr, axi_expected_value, axi_poll_mask, .polling_period(1us));


		master_agent.read(axi_addr, data_rd);
		data= data_rd & 'h0000ffff;
	endtask : XGS_ReadSPI



	system_wrapper DUT
		(
			.anput_exposure(),
			.anput_ext_trig(),
			.anput_strobe(),
			.anput_trig_rdy(),
			.axiClk100MHz(axiClk100MHz),
			.axiReset_n(axil.reset_n),
			.pciAxiReset_n(pciAxiReset_n),
                        .pcieAxiClk62MHz(pcieAxiClk62MHz),
			.dma_irq(dma_irq),
			.dma_tlp_cfg_bus_mast_en(),
			.dma_tlp_cfg_setmaxpld(),
			.dma_tlp_tlp_address(),
			.dma_tlp_tlp_attr(),
			.dma_tlp_tlp_byte_count(),
			.dma_tlp_tlp_data(),
			.dma_tlp_tlp_dst_rdy_n(),
			.dma_tlp_tlp_fmt_type(),
			.dma_tlp_tlp_grant(),
			.dma_tlp_tlp_ldwbe_fdwbe(),
			.dma_tlp_tlp_length_in_dw(),
			.dma_tlp_tlp_lower_address(),
			.dma_tlp_tlp_req_to_send(),
			.dma_tlp_tlp_src_rdy_n(),
			.dma_tlp_tlp_transaction_id(),
			.i2c_i2c_sdata(),
			.i2c_i2c_slk(),
			.idelayClk(idelayClk),
			.led_out(),
			.s_axil_if_araddr(axil.araddr),
			.s_axil_if_arprot(axil.arprot),
			.s_axil_if_arready(axil.arready),
			.s_axil_if_arvalid(axil.arvalid),
			.s_axil_if_awaddr(axil.awaddr),
			.s_axil_if_awprot(axil.awprot),
			.s_axil_if_awready(axil.awready),
			.s_axil_if_awvalid(axil.awvalid),
			.s_axil_if_bready(axil.bready),
			.s_axil_if_bresp(axil.bresp),
			.s_axil_if_bvalid(axil.bvalid),
			.s_axil_if_rdata(axil.rdata),
			.s_axil_if_rready(axil.rready),
			.s_axil_if_rresp(axil.rresp),
			.s_axil_if_rvalid(axil.rvalid),
			.s_axil_if_wdata(axil.wdata),
			.s_axil_if_wready(axil.wready),
			.s_axil_if_wstrb(axil.wstrb),
			.s_axil_if_wvalid(axil.wvalid),
			.xgs_power_good(1'b1)
		);

	assign gpio_if.input_io[0] = dma_irq;

	initial
	begin


	        #100 pciAxiReset_n = 1'b1;

	   
		//////////////////////////////////////////////////////////
		//
		// Start Simulation
		//
		//////////////////////////////////////////////////////////
		master_agent = new(axil, gpio_if);

		master_agent.reset(100);
		master_agent.wait_n(1000);


		//--------------------------------------------------------
		//
		// WakeUP XGS SENSOR : unreset and enable clk to the sensor : SENSOR_POWERUP
		//
		//-------------------------------------------------------
		axi_addr = BAR_XGS_CTRL+32'h0190;
		axi_data = 'h0003;
		axi_strb = 'h1;
		master_agent.write(axi_addr, axi_data, axi_strb, timeout);

		//Poll until clock enable and reset disable
		axi_addr = BAR_XGS_CTRL + 'h00000198;
		axi_poll_mask = 'h00000001;
		axi_expected_value = 'h00000001;
		master_agent.poll(axi_addr, axi_expected_value, axi_poll_mask, .polling_period(1us));

		//--------------------------------------------------------
		//
		// READ XGS MODEL ID and REVISION
		//
		//-------------------------------------------------------
		XGS_ReadSPI(16'h0000, data_rd);
		if(data_rd==16'h0058) begin
			$display("XGS Model ID detected is 0x58, XGS12M");
		end
		else if(data_rd==16'h0358) begin
			$display("XGS Model ID detected is 0x358, XGS5M");
		end
		else begin
			$error("XGS Model ID detected is %d", data_rd);
		end


		//--------------------------------------------------------
		//
		// PROGRAM XGS MODEL PART 1
		//
		//-------------------------------------------------------

		// default dans le model XGS:
		// ---------------------------------
		// register_map(0)    <= G_MODEL_ID; --Address 0x3000 - model_id
		// register_map(255)  <= G_REV_ID;   --Address 0x31FE - revision_id
		// register_map(1024) <= X"0002";    --Address 0x3800 - general_config0
		// register_map(1026) <= X"1111";    --Address 0x3804 - contexts_reg
		// register_map(1032) <= X"00E6";    --Address 0x3810 - line_time
		// register_map(1812) <= X"2507";    --Address 0x3E28 - hispi_control_common
		// register_map(1817) <= X"03A6";    --Address 0x3E32 - hispi_blanking_data
    
    
		// Dans le modele XGS  le decodage registres est fait :
		// register_map(1285) : (addresse & 0xfff) >>1  :  0x3a08=>1284
    
		//The following registers must be programmed with the specified value to enable test image generation on the HiSPi interface.
		//The commands below specify the register address followed by the register value.
		//In case of I2C, it must use the I2C slave address 0x20/0x21 as defined in the datasheet.
		//- REG Write = 0x3700, 0x001C
		XGS_WriteSPI(16'h3700,16'h001c);
		//- Wait at least 500us for the PLL to start and all clocks to be stable.
		#500us;
			//- REG Write = 0x3E3E, 0x0001
		XGS_WriteSPI(16'h3e3e,16'h0001);
    
		//--------------------------------------------------------
		// XGS model : setting mux output ratio to 4:1
		//-------------------------------------------------------
		// HISPI control common register
		// XGS_WriteSPI(16'h3e28,16'h2507); //mux 4:4
		// XGS_WriteSPI(16'h3e28,16'h2517); //mux 4:3
		// XGS_WriteSPI(16'h3e28,16'h2527); //mux 4:2
		XGS_WriteSPI(16'h3e28,16'h2537);    //mux 4:1

		
		//--------------------------------------------------------
		// Validate the presence of the HiSPi Matrox tag
		//-------------------------------------------------------
		$display("Reading Matrox Tag");
		master_agent.read(BAR_AXIHISPI, data_rd);
		$display("Matrox Tag : 0x%x", data_rd);
		if (data_rd != 'h0058544d) begin
			$fatal("Matrox Tag not found at address : 0x%x", BAR_AXIHISPI);
		end


		//-------------------------------------------------------
		// Set HiSPi capture enable bit
		//-------------------------------------------------------
		$display("Enabling axiHiSPi module");
		master_agent.write(BAR_AXIHISPI + 'h30, 1);







		
		//--------------------------------------------------------
		//
		// PROGRAM XGS MODEL PART 2 - Set to output test mode image
		//
		//-------------------------------------------------------
		// Dans le modele XGS  le decodage registres est fait :
		// register_map(1285) : (addresse & 0xfff) >>1  :  0x3a08=>1284
    

    
		//XGS_MODEL_SLAVE_TRIGGERED_MODE=0
		//  // REG Write = 0x3E0E, <any value from 0x1 to 0x7>. This selects the testpattern to be sent
		//  // 0=jmansill B&W diagonal ramp 0->4095...
		//  // 1=solid pattern
		//  // 3=fade t0 black
		//  // 4=diagonal  gary 1x
		//  // 5=diagonal  gary 3x
		//  // ... p.26 de la spec!!!
		//  XGS_WriteSPI(16'h3e0e,16'h0000);  //add=1799
		//
		//  //- Optional : REG Write = 0x3E10, <test_data_red>
		//  //- Optional : REG Write = 0x3E12, <test_data_greenr>
		//  //- Optional : REG Write = 0x3E14, <test_data_blue>
		//  //- Optional : REG Write = 0x3E16, <test_data_greenb>
		//  // Finalement en "solid pattern", il faut ecrire la valeur du pixel ici, sinon le modele genere des 0x001 partout.
		//  // de plus le modele declare un signal [12:0] et utilise seulement [12:1]...
		//  test_fixed_data = 16'h00ca;
		//  XGS_WriteSPI(16'h3E10, test_fixed_data<<1);
		//  XGS_WriteSPI(16'h3E12, test_fixed_data<<1);
		//  XGS_WriteSPI(16'h3E14, test_fixed_data<<1);
		//  XGS_WriteSPI(16'h3E16, test_fixed_data<<1);
		//
		//  //- REG Write = 0x3A08, <number of active lines transmitted for a test image frame>
		//  test_active_lines = 8;  // 1=1line
		//  XGS_WriteSPI(16'h3A08, test_active_lines); // Cc registre est 1 based
		//
		//  //- REG Write = 0x3A06, (number of clock cycles between the start of two rows)
		//  test_numberclk_between_2lines = 12'h0c8; // 200clk
		//  XGS_WriteSPI(16'h3A06, test_numberclk_between_2lines); //Enable test mode(0x8000) + 200clk
		//
		//  //- REG Write = 0x3A0A, 0x8000 && (<number of lines between the last row of the test image and the first row of the next test image> << 6)
		//  //                             &&  <number of test image frames to be transmitted>
		//  test_blank_lines              = 4;       // 0=1line (correction is bellow)
		//  test_number_frames            = 5;       // 1=1frame
		//  XGS_WriteSPI(16'h3A0A,16'h8000 + ((test_blank_lines-1)<<6)  + (test_number_frames) );  //0x8000 is to latch registers
		//
		//  //- REG Write = 0x3A06, (0x8000 is enable test mode)
		//  XGS_WriteSPI(16'h3A06,16'h8000+ test_numberclk_between_2lines); //Enable sequencer test mode
		//

    
		XGS_WriteSPI(16'h3e0e,16'h0000);                 // Image Diagonal ramp:  line0 start=0, line1 start=1, line2 start=2...

		// jmansill : SET Slave triggered mode
    
		// default              in devware is 00E6  (24 lanes)
		// default              in devware is 0xf4  (18 lanes)
		// default              in devware is 0x16e (12 lanes)
		// default              in devware is 0x2dc (6 lanes)
                                                     
		//--------------------------------------------------------
		// IMPORTANT LINE TIME POUR 6 lanes
		//--------------------------------------------------------
		line_time             = 'h02dc;                  // default in model and in devware is 0xe6  (24 lanes), XGS12M register is 0x16e @32.4Mhz (T=30.864ns)
		XGS_WriteSPI(16'h3810, line_time);               // register_map(1032) <= X"00E6";    --Address 0x3810 - line_time

		XGS_WriteSPI(16'h3800,16'h0030);                 // Slave + trigger mode
		XGS_WriteSPI(16'h3800,16'h0031);                 // Enable sequencer

		monitor_0_reg = 16'h6;    // 0x6 : Real Integration  , 0x2 : Integrate
		monitor_1_reg = 16'h10;   // EFOT indication
		monitor_2_reg = 16'h1;    // New_line
		XGS_WriteSPI(16'h3806, (monitor_2_reg<<10) + (monitor_1_reg<<5) + monitor_0_reg );      // Monitor Lines
      
    
		#50us;
    
		// XGS MODEL FRAME IS 4176 pixels when test mode !!!
		// voir p.Figure 37. Pixel Readout Order
		// voir p8 Figure 4. XGS 8000 Pixel Array
		// 4176 = 4 dummy + 24 BL K+ 4 dummy + 4 interpol + 4096 + 4 interpol + 4 dummy + 32 BLK + 4 dummy


		//--------------------------------------------------------
		//
		// PROGRAM XGS CONTROLLER
		//
		//-------------------------------------------------------
    
		// Give SPI control to XGS controller   : SENSOR REG_UPDATE =1
		master_agent.write(BAR_XGS_CTRL+16'h0190, 16'h0012);

		xgs_ctrl_period     = 16.0;
		xgs_bitrate_period  = (1000.0/32.4)/(2.0);  // 30.864197ns /2
    
		EXP_FOT_TIME        = 5360;  //5.36us calculated from start of FOT to end of real exposure
    
		// LINE_TIME
		// default in model and in devware is 0xe6  (24 lanes), XGS12M register is 0x16e @32.4Mhz (T=30.864ns)
		// default              in devware is 0xf4  (18 lanes)
		// default              in devware is 0x16e (12 lanes)
		// default              in devware is 0x2dc (6 lanes)
     
		master_agent.write(BAR_XGS_CTRL+32'h00000120, line_time);                                      //LineTime in pixel CLK
    
		master_agent.write(BAR_XGS_CTRL+32'h000002b8, (1<<16) + (EXP_FOT_TIME/xgs_ctrl_period ));      //Enable EXP during FOT
       
  
		KEEP_OUT_TRIG_START_sysclk = ((line_time*xgs_bitrate_period) - 100 ) / xgs_ctrl_period;  //START Keepout trigger zone (100ns)
		KEEP_OUT_TRIG_END_sysclk   = (line_time*xgs_bitrate_period)/xgs_ctrl_period;             //END   Keepout trigger zone (100ns), this is more for testing, monitor will reset the counter
		master_agent.write(BAR_XGS_CTRL+32'h00000124, (KEEP_OUT_TRIG_END_sysclk<<16) + KEEP_OUT_TRIG_START_sysclk);
		master_agent.write(BAR_XGS_CTRL+32'h00000120, (0<<16) + line_time);      //Enable KEEP_OUT ZONE[bit 16]
 
		// XGS CONTROLLER readout_length calculated in FPGA now!!!!
		//
		// TOTAL_NB_LINES <= "11" +                                                -- 3 is first dummy lines after FOT
		//                    REGFILE.ACQ.SENSOR_M_LINES.M_LINES +                 -- Black lines for calibartion
		//                    REGFILE.ACQ.SENSOR_F_LINES.F_LINES +                 -- F_lines, where are located F_LINES ???
		//                    '1' +                                                -- Embededd line
		//                    ('0'& REGFILE.ACQ.SENSOR_ROI_Y_SIZE.Y_SIZE & "00")+  -- Y_size is a 4 line multipler
		//                    '1';                                                 -- For jitter
		//
		//  INTERNAL_READOUT_LENGTH_FLOAT <=   TOTAL_NB_LINES *  REGFILE.ACQ.READOUT_CFG3.LINE_TIME * SENSOR_PERIOD;
		MLines                = 0;
		MLines_supressed      = 0;
		FLines                = 0;
		FLines_supressed      = 0;
    
		master_agent.write(BAR_XGS_CTRL+16'h01d8, (MLines_supressed<<10)+ MLines);    //M_LINE REGISTER
		master_agent.write(BAR_XGS_CTRL+16'h01dc,(FLines_supressed<<10)+ FLines);    //F_LINE REGISTER

        
		//Set XGS registers (mirroir)
		master_agent.write(BAR_XGS_CTRL+32'h000001a0, 0);                 // Subsampling
		master_agent.write(BAR_XGS_CTRL+32'h000001a4, 2<<8);                 // Analog Gain
    
		ROI_YSTART   =  0;
		ROI_YSIZE    = 16;
		EXPOSURE     = 50;  //in us
		master_agent.write(BAR_XGS_CTRL+32'h000001a8, ROI_YSTART/4);                                        // Y START  (kernel is 4)
		master_agent.write(BAR_XGS_CTRL+32'h000001ac, ROI_YSIZE/4);                                         // Y SIZE   (kernel is 4)
		master_agent.write(BAR_XGS_CTRL+32'h00000128, EXPOSURE * (1000.0 /xgs_ctrl_period));               // Exposure 50us @100mhz
		master_agent.write(BAR_XGS_CTRL+32'h00000100, (1<<15)+(1<<8)+1);                                    // Grab_ctrl: source is immediate + trig_overlap + grab cmd

		//master_agent.AXI4LITE_WRITE_BURST(BAR_XGS_CTRL+32'h00000100, prot, (1<<15)+(3<<8)+1, resp);                 // Grab_ctrl: source is sw ss + trig_overlap + grab cmd
		//#5us
		//master_agent.AXI4LITE_WRITE_BURST(BAR_XGS_CTRL+32'h00000100, prot, (1<<15)+(3<<8)+(1<<4), resp);            // Grab_ctrl: sw ss !
  
    
		ROI_YSTART   =   8;
		ROI_YSIZE    =   8;
		EXPOSURE     =  50;  //in us
		master_agent.write(BAR_XGS_CTRL+32'h000001a8, ROI_YSTART/4);                                       // Y START  (kernel is 4)
		master_agent.write(BAR_XGS_CTRL+32'h000001ac, ROI_YSIZE/4);                                        // Y SIZE   (kernel is 4)
		master_agent.write(BAR_XGS_CTRL+32'h00000128, EXPOSURE * (1000.0 /xgs_ctrl_period));               // Exposure 50us @100mhz
		master_agent.write(BAR_XGS_CTRL+32'h00000100, (1<<15)+(1<<8)+1);                                   // Grab_ctrl: source is immediate + trig_overlap + grab cmd

    
    
    
		#1ms;

			//--------------------------------------------------------
			//
			// End of the simulation
			//
			//-------------------------------------------------------
		master_agent.wait_n(1000);
		master_agent.terminate();

	end

endmodule



