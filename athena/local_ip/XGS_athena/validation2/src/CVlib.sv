// Fichier DutPkg.sv
//
// Classe CDut
//
// Description:
// La classe CDut contient les modules servant a envoyer des stimulis au device-under-test
//
`timescale 1ns / 1ps

package CVlibPkg;
import core_pkg::*;   //Cstatus is inside
import driver_pkg::*;



class CVlib;


    parameter BAR_XGS_ATHENA        = 32'h00000000;
	parameter HISPI_IDLE_CHARACTER  = 12'h3A6;

	// XGS_athena DMA
	parameter FSTART_OFFSET         = 'h078;
	parameter FSTART_HIGH_OFFSET    = 'h07c;
	parameter FSTART_G_OFFSET       = 'h080;
	parameter FSTART_G_OFFSET_HIGH  = 'h084;
	parameter FSTART_R_OFFSET       = 'h088;
	parameter FSTART_R_OFFSET_HIGH  = 'h08C;
	parameter LINE_PITCH_OFFSET     = 'h090;
	parameter LINE_SIZE_OFFSET      = 'h094;
	parameter OUTPUT_BUFFER_OFFSET  = 'h0A8;
	
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
	parameter HISPI_CTRL_OFFSET            = 'h0400;
	parameter HISPI_IDLE_CHARACTER_OFFSET  = 'h040C;
	parameter HISPI_PHY_OFFSET             = 'h0410;
	parameter FRAME_CFG_OFFSET             = 'h0414;	
	parameter FRAME_CFG_X_VALID_OFFSET     = 'h0418;
	parameter HISPI_DEBUG_OFFSET           = 'h0460;

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

    // DPC
    parameter DPC_CAPABILITIES             = 16'h480;
	parameter DPC_LIST_CTRL                = 16'h484;
    parameter DPC_LIST_STAT                = 16'h488; 
    parameter DPC_LIST_DATA1               = 16'h48c; 
    parameter DPC_LIST_DATA2               = 16'h490; 
    parameter DPC_LIST_DATA1_RD            = 16'h494;    
    parameter DPC_LIST_DATA2_RD            = 16'h498;     

    // LUT
    parameter LUT_CAPABILITIES             = 16'h4B0;
	parameter LUT_CTRL                     = 16'h4B4;
	parameter LUT_RB                       = 16'h4B8;

	// I2C
	parameter I2C_ID_OFFSET                = 32'h00010000;	
	parameter I2C_CTRL0_OFFSET             = 32'h00010008;	
	parameter I2C_CTRL1_OFFSET             = 32'h00010010;	
	parameter I2C_SEMAPHORE_OFFSET         = 32'h00010018;	

	/////////////////////////////
	// XGS Sensor parameter 
	/////////////////////////////
    int P_MODEL_ID;       
    int P_REV_ID ;        
    int P_NUM_LANES;      
    int P_PXL_PER_COLRAM ;
    int P_PXL_ARRAY_ROWS; 

    int P_INTERPOLATION;  
    int P_LEFT_DUMMY_0;   
    int P_LEFT_BLACKREF;  
    int P_LEFT_DUMMY_1;   
    int P_ROI_WIDTH;  
    int P_RIGHT_DUMMY_0;  
    int P_RIGHT_BLACKREF; 
    int P_RIGHT_DUMMY_1;  

    int P_TOP_DUMMY;      
    int P_BOTTOM_DUMMY_0; 
    int P_BOTTOM_BLACKREF;
    int P_BOTTOM_DUMMY_1; 
    int P_LINE_PTR_WIDTH; 

    int MODEL_X_START;
    int MODEL_X_END; 
   
		




    /////////////////////////////
	// DMA parameter 
	/////////////////////////////
    longint fstart;
	int line_pitch;
	int line_size;
	int output_buffer_value;

    /////////////////////////////
	// ctrl parameter 
	/////////////////////////////
    int line_time;
	real xgs_ctrl_period;


    Cstatus TestStatus;
    Cdriver_axil host; 
    virtual axi_stream_interface tx_axis_if;


    function new( Cdriver_axil host, Cstatus TestStatus, virtual axi_stream_interface tx_axis_if);
        
        this.host          = host;
		this.tx_axis_if    = tx_axis_if;
        this.TestStatus    = TestStatus;

    endfunction


    
    //---------------------------------------
    //  Load XGS CONFIGURATION
    //---------------------------------------
    task setXGS_sensor(int sensor_type);
    
		if(sensor_type==5000) begin
          $display("XGS Sensor is XGS5000");
          
		  //Choose XGS 5000 in system top fro SIM
		  host.set_output_io (0, 0);
		  host.set_output_io (1, 0);
		  
		  P_MODEL_ID       =  16'h0358;
		  P_REV_ID         =  16'h0000;
		  P_NUM_LANES      =  4;
		  P_PXL_PER_COLRAM =  174;
		  P_PXL_ARRAY_ROWS =  2078;
		  
		  P_INTERPOLATION  =  4;
		  P_LEFT_DUMMY_0   =  50;
		  P_LEFT_BLACKREF  =  34;
		  P_LEFT_DUMMY_1   =  4;
		  P_ROI_WIDTH      =  2592;
		  P_RIGHT_DUMMY_0  =  4;
		  P_RIGHT_BLACKREF =  42;
		  P_RIGHT_DUMMY_1  =  50;
		  
		  P_TOP_DUMMY       =  7;
		  P_BOTTOM_DUMMY_0  =  4;
		  P_BOTTOM_BLACKREF =  8;
		  P_BOTTOM_DUMMY_1  =  3;
		  P_LINE_PTR_WIDTH  =  2;
        end else 
		if(sensor_type==12000) begin	     
          $display("XGS Sensor is XGS12000");

		  //Choose XGS 12000 in system top fro SIM
		  host.set_output_io (0, 1);
		  host.set_output_io (1, 0);

		  P_MODEL_ID       =  16'h0058;
		  P_REV_ID         =  16'h0002;
		  P_NUM_LANES      =  6;
		  P_PXL_PER_COLRAM =  174;
		  P_PXL_ARRAY_ROWS =  3102;
		 
          P_INTERPOLATION  =  4;
		  P_LEFT_DUMMY_0   =  4;
		  P_LEFT_BLACKREF  =  24;
		  P_LEFT_DUMMY_1   =  4;
		  P_ROI_WIDTH      =  4096;
		  P_RIGHT_DUMMY_0  =  4;
		  P_RIGHT_BLACKREF =  24;
		  P_RIGHT_DUMMY_1  =  4;
		 
          P_TOP_DUMMY       =  7;
		  P_BOTTOM_DUMMY_0  =  4;
		  P_BOTTOM_BLACKREF =  24;
		  P_BOTTOM_DUMMY_1  =  3;
		  P_LINE_PTR_WIDTH  =  2;
        end else 
		if(sensor_type==16000) begin	     
          $display("XGS Sensor is XGS16000");
		  
		  //Choose XGS 16000 in system top fro SIM
		  host.set_output_io (0, 0);
		  host.set_output_io (1, 1);

		  P_MODEL_ID       =  16'h0258;
		  P_REV_ID         =  16'h0000;
		  P_NUM_LANES      =  6;
		  P_PXL_PER_COLRAM =  174;
		  P_PXL_ARRAY_ROWS =  4030;
		 
          P_INTERPOLATION  =  4;
		  P_LEFT_DUMMY_0   =  4;
		  P_LEFT_BLACKREF  =  24;
		  P_LEFT_DUMMY_1   =  52;
		  P_ROI_WIDTH      =  4000;
		  P_RIGHT_DUMMY_0  =  52;
		  P_RIGHT_BLACKREF =  32;
		  P_RIGHT_DUMMY_1  =  4;
		 
          P_TOP_DUMMY       =  7;
		  P_BOTTOM_DUMMY_0  =  4;
		  P_BOTTOM_BLACKREF =  8;
		  P_BOTTOM_DUMMY_1  =  3;
		  P_LINE_PTR_WIDTH  =  2;
        end
     endtask : setXGS_sensor





    //---------------------------------------
    //  DMA PARAMS
    //---------------------------------------
    task setDMA(longint fstart, int line_pitch);
   

      this.fstart     = fstart;
	  this.line_pitch = line_pitch;
	  this.line_size  = P_ROI_WIDTH;

	  // DMA frame start register
	  $display("  2.3 Write FSTART register @0x%h", FSTART_OFFSET);
	  host.write(FSTART_OFFSET, fstart);
	  host.write(FSTART_HIGH_OFFSET, fstart>>32);
	  host.wait_n(10);

      // DMA line pitch register
	  $display("  2.5 Write LINESIZE register @0x%h", LINE_PITCH_OFFSET);
	  host.write(LINE_PITCH_OFFSET, line_pitch);
	  host.wait_n(10);

	  // DMA line size register
	  $display("  2.4 Write LINESIZE register @0x%h", LINE_SIZE_OFFSET);
	  host.write(LINE_SIZE_OFFSET, P_ROI_WIDTH);
	  host.wait_n(10);

	  // DMA output buffer configuration
	  $display("  2.6 Write OUTPUT_BUFFER register @0x%h", OUTPUT_BUFFER_OFFSET);
	  output_buffer_value =  P_LINE_PTR_WIDTH << 24;
	  host.write(OUTPUT_BUFFER_OFFSET, output_buffer_value);
	  host.wait_n(10);

    endtask : setDMA


    //---------------------------------------
    //  Program XGS MODEL
    //---------------------------------------
    task setXGSmodel();

        int data_rd;
		int axi_addr;
		int axi_write_data;
        int axi_strb;
        int axi_poll_mask;
		int axi_expected_value;
      
        int monitor_0_reg;
        int monitor_1_reg;
        int monitor_2_reg;	  


		// XGS Controller wakes up sensor
		$display("3. XGS Controller wakes up sensor");
		$display("  3.1 Write SENSOR_CTRL register @0x%h", SENSOR_CTRL_OFFSET);
		axi_addr = SENSOR_CTRL_OFFSET;
		axi_write_data = 'h0003;
		axi_strb = 'h1;
		host.write(axi_addr, axi_write_data, axi_strb);

		// Poll until clock enable and reset disable
		$display("  3.2 Poll SENSOR_STAT register @0x%h", SENSOR_STAT_OFFSET);
		axi_addr = SENSOR_STAT_OFFSET;
		axi_poll_mask = 'h00000001;
		axi_expected_value = 'h00000001;
		host.poll(axi_addr, axi_expected_value, axi_poll_mask, .polling_period(1us));


		// SPI configure the XGS sensor model
		$display("4. SPI configure the XGS sensor model");

		// A minimum delay is required before we can start SPI transactions
		#200us;

		// SPI read XGS model id
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

    	// SPI read revision
		$display("  4.2 SPI read XGS revision number @0x%h", SPI_REVISION_NUMB_OFFSET);
		XGS_ReadSPI(SPI_REVISION_NUMB_OFFSET, data_rd);
		$display("Addres 0x31FE : XGS Revision ID detected is %x", data_rd);

		// SPI reset
		$display("  4.3 SPI write XGS register reset @0x%h", SPI_RESET_REGISTER_REG);
		XGS_WriteSPI(SPI_RESET_REGISTER_REG, 16'h001c);

		//- Wait at least 500us for the PLL to start and all clocks to be stable.
		#500us;

		//- REG Write = 0x3E3E, 0x0001
		$display("  4.4 SPI write XGS UNKNOWN register @0x%h", SPI_UNKNOWN_REGISTER_REG);
		XGS_WriteSPI(SPI_UNKNOWN_REGISTER_REG, 16'h0001);


		// XGS model : setting mux output ratio to 4:1
		// HISPI control common register
		// XGS_WriteSPI(16'h3e28,16'h2507);                     //mux 4:4
		// XGS_WriteSPI(16'h3e28,16'h2517);                     //mux 4:3
		// XGS_WriteSPI(16'h3e28,16'h2527);                     //mux 4:2
		$display("  4.5 SPI write XGS HiSPI control common register @0x%h", SPI_HISPI_CONTROL_COMMON_REG);
		XGS_WriteSPI(SPI_HISPI_CONTROL_COMMON_REG,16'h2537);    //mux 4:1
				
		// XGS model : Set line time (for 6 lanes)
		$display("  4.7 SPI write XGS set line time @0x%h", SPI_LINE_TIME_REG);
		line_time = 'h02dc;                              // default in model and in devware is 0xe6  (24 lanes), XGS12M register is 0x16e @32.4Mhz (T=30.864ns)
		XGS_WriteSPI(SPI_LINE_TIME_REG, line_time);      // register_map(1032) <= X"00E6";    --Address 0x3810 - line_time


		// XGS model : Slave Mode And ENABLE SEQUENCER
		$display("  4.8 SPI write XGS set general config @0x%h", SPI_GENERAL_CONFIG0_REG);
		XGS_WriteSPI(SPI_GENERAL_CONFIG0_REG,16'h0030);                 // Slave + trigger mode
		XGS_WriteSPI(SPI_GENERAL_CONFIG0_REG,16'h0031);                 // Enable sequencer


		// XGS model : Set Monitor pins
		$display("  4.9 SPI write XGS set monitor pins @0x%h", SPI_MONITOR_REG);
		monitor_0_reg = 16'h6;    // 0x6 : Real Integration  , 0x2 : Integrate
		monitor_1_reg = 16'h10;   // EFOT indication
		monitor_2_reg = 16'h1;    // New_line
		XGS_WriteSPI(SPI_MONITOR_REG, (monitor_2_reg<<10) + (monitor_1_reg<<5) + monitor_0_reg );      // Monitor Lines


    endtask : setXGSmodel



	////////////////////////////////////////////////////////////////
	// Task : GenImage_XGS
	////////////////////////////////////////////////////////////////
	task automatic GenImage_XGS(input int ImgPattern);
		//super.super.xgs_model_GenImage = 1'b0;      
		XGS_WriteSPI(SPI_TEST_PATTERN_MODE_REG, ImgPattern);		
		host.poll(BAR_XGS_ATHENA + 'h00000168, 0, (1<<16), .polling_period(1us));  // attendre la fin de l'ecriture au registre XGS via SPI!  
		#1ns;
		XGS_WriteSPI(8, 16'h0001);           // Cree le .pgm et loade le modele XGS vhdl dew facon SW par ecriture ds le modele
		#10us;		
		XGS_WriteSPI(8, 16'h0000);
	endtask : GenImage_XGS	
	



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




    //---------------------------------------
    //  Program XGS MODEL
    //---------------------------------------
    task setXGScontroller();

        real xgs_bitrate_period;  //32.4Mhz ref clk*2 /12 bits per clk
		int EXP_FOT_TIME;
		int MLines;
		int MLines_supressed;
		int KEEP_OUT_TRIG_START_sysclk;
		int KEEP_OUT_TRIG_END_sysclk;

		// PROGRAM XGS CONTROLLER
		$display("5. SPI configure the XGS_athena IP-Core controller section");

		// A minimum delay is required before we can start
		// SPI transactions
		#50us;

		// XGS Controller : SENSOR REG_UPDATE =1
		// Give SPI control to XGS controller   : SENSOR REG_UPDATE =1
		$display("  5.1 Write SENSOR_CTRL register @0x%h", SENSOR_CTRL_OFFSET);
		host.write(SENSOR_CTRL_OFFSET, 16'h0012);

		// XGS Controller : set the line time (in pixel clock)
		// LINE_TIME
		// default in model and in devware is 0xe6  (24 lanes), XGS12M register is 0x16e @32.4Mhz (T=30.864ns)
		// default              in devware is 0xf4  (18 lanes)
		// default              in devware is 0x16e (12 lanes)
		// default              in devware is 0x2dc (6 lanes)
		$display("  5.2 Write READOUT_CFG3 (line time) register @0x%h", READOUT_CFG3_OFFSET);
		host.write(READOUT_CFG3_OFFSET, line_time);

		// XGS Controller : exposure time during FOT
		$display("  5.3 Write EXP_FOT (exposure time during FOT) register @0x%h", EXP_FOT_OFFSET);
		xgs_ctrl_period     = 16.0; // Ref clock preiod
		xgs_bitrate_period  = (1000.0/32.4)/(2.0);  // 30.864197ns /2

		EXP_FOT_TIME        = 5360;  //5.36us calculated from start of FOT to end of real exposure
		host.write(EXP_FOT_OFFSET, (1<<16) + (EXP_FOT_TIME/xgs_ctrl_period ));      //Enable EXP during FOT


		// XGS Controller : Keepout trigger zone
		$display("  5.4 Write READOUT_CFG4 (Keepout trigger zone) register @0x%h", READOUT_CFG4_OFFSET);

		KEEP_OUT_TRIG_START_sysclk = ((line_time*xgs_bitrate_period) - 100 ) / xgs_ctrl_period;  //START Keepout trigger zone (100ns)
		KEEP_OUT_TRIG_END_sysclk   = (line_time*xgs_bitrate_period)/xgs_ctrl_period;             //END   Keepout trigger zone (100ns), this is more for testing, monitor will reset the counter
		host.write(READOUT_CFG4_OFFSET, (KEEP_OUT_TRIG_END_sysclk<<16) + KEEP_OUT_TRIG_START_sysclk);
		host.write(READOUT_CFG3_OFFSET, (0<<16) + line_time);      //Enable KEEP_OUT ZONE[bit 16]



		// XGS Controller : M_lines
		$display("  5.5 Write SENSOR_M_LINES register @0x%h", SENSOR_M_LINES_OFFSET);
		MLines           = 0;
		MLines_supressed = 0;
		host.write(SENSOR_M_LINES_OFFSET, (MLines_supressed<<10)+ MLines);    //M_LINE REGISTER

		// XGS Controller : Subsampling
		//$display("  5.6 Write SENSOR_SUBSAMPLING register @0x%h", SENSOR_SUBSAMPLING_OFFSET);
		//host.write(SENSOR_SUBSAMPLING_OFFSET, 'h8); //SUBY
		//host.write(SENSOR_SUBSAMPLING_OFFSET, 'h1); //SUBX
		//host.write(SENSOR_SUBSAMPLING_OFFSET, 'h9); //SUBX+Y
		host.write(SENSOR_SUBSAMPLING_OFFSET, 0); //NO SUB

		// XGS Controller : Analog gain
		$display("  5.7 Write SENSOR_GAIN_ANA register @0x%h", SENSOR_GAIN_ANA_OFFSET);
		host.write(SENSOR_GAIN_ANA_OFFSET, 2<<8);

    endtask : setXGScontroller				



    //---------------------------------------
    //  setHISPI
    //---------------------------------------
    task setHISPI();

		bit [31:0] manual_calib;
        bit [31:0] register_data;
				
		// PROGRAM XGS HiSPi interface
		$display("6. Configure the XGS_athena IP-Core HiSPi section");


		// XGS HiSPi : Control
		$display("  6.1 Write IDLE_CHARACTER register @0x%h", HISPI_IDLE_CHARACTER_OFFSET);
		host.write(HISPI_IDLE_CHARACTER_OFFSET,  HISPI_IDLE_CHARACTER);

		// XGS HiSPi : Control, 6 lanes, mux 4
		$display("  6.2 Write CTRL register @0x%h", HISPI_CTRL_OFFSET);
		host.write(HISPI_CTRL_OFFSET, 'h4603);


		// XGS HiSPi : Control, 6 lanes, mux 4
		$display("  6.3 Write PHY register @0x%h", HISPI_PHY_OFFSET);
		register_data = 0;
		register_data[25:16] =  P_PXL_PER_COLRAM;
		register_data[2:0]   =  P_NUM_LANES;
		
		host.write(HISPI_PHY_OFFSET, register_data);

		$display("  6.4 Write FRAME_CFG register @0x%h", FRAME_CFG_OFFSET);
		host.write(FRAME_CFG_OFFSET, 'h0c1e1050); // Pour XGS12M
		
		// XGS HiSPi : DEBUG Enable manual calibration
		$display("  6.5 Write DEBUG register @0x%h", HISPI_DEBUG_OFFSET);
		manual_calib[4:0] = 5'b10101; // TAP lane 0
		manual_calib[9:5] = 5'b10101; // TAP lane 1
		manual_calib[14:10] = 5'b10101; // TAP lane 2
		manual_calib[19:15] = 5'b10101; // TAP lane 3
		manual_calib[24:20] = 5'b10101; // TAP lane 4
		manual_calib[29:25] = 5'b10101; // TAP lane 5

		manual_calib[30] = 1'b1; // Load calibration tap
		manual_calib[31] = 1'b1; // Manual calib enable

		host.write(HISPI_DEBUG_OFFSET, manual_calib);
		#100ns;

		// XGS HiSPi : DEBUG Disable manual calibration
		$display("  6.6 Write DEBUG register @0x%h", HISPI_DEBUG_OFFSET);
		manual_calib = 'hC0000000; // Manual calib enable
		host.write(HISPI_DEBUG_OFFSET, manual_calib);
		#100ns;
		manual_calib = 'h00000000; // Manual calib enable
		host.write(HISPI_DEBUG_OFFSET, manual_calib);
		#100ns;

		// XGS HiSPi : Control Start a calibration
		$display("  6.7 Write CTRL register @0x%h", HISPI_CTRL_OFFSET);
		host.write(HISPI_CTRL_OFFSET, 'h4607);

 	endtask : 	setHISPI		

    //---------------------------------------
    //  setHISPI_X_window X Origine
    //---------------------------------------
    task setHISPI_X_window();
		bit [31:0] reg_value;
		///////////////////////////////////////////////////
		// Program X Origin of valid data, in HiSPI
		///////////////////////////////////////////////////
		// X origin 
		//MODEL_X_START  = 32;                    // 32, est non centre.  36 est le origine pour une image de 4096 pixels centree.
		//MODEL_X_END    = MODEL_X_START+4096-1;  
		
		//Image centree max 4096             			
		//MODEL_X_START  = P_LEFT_DUMMY_0 + P_LEFT_BLACKREF + P_LEFT_DUMMY_1 + P_INTERPOLATION;
		//MODEL_X_END    = MODEL_X_START+P_ROI_WIDTH-1;              			
		
		//Image qui part a 0,  max 4096 (on dumpe 8 pixels a la fin, comme si on dumpait 8 dummys)
		MODEL_X_START  = P_LEFT_DUMMY_0 + P_LEFT_BLACKREF + P_LEFT_DUMMY_1;
		MODEL_X_END    = MODEL_X_START + P_ROI_WIDTH -1;              			
		
		reg_value = (MODEL_X_END<<16) + MODEL_X_START;
		host.write(FRAME_CFG_X_VALID_OFFSET,  reg_value);	
	
	endtask : 	setHISPI_X_window



    //---------------------------------------
    //  testI2Csemaphore
    //---------------------------------------
    task testI2Csemaphore();		
		bit [31:0] axi_read_data;
		$display("7. Test I2C semaphore read register");
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
    endtask : testI2Csemaphore
 	 



endclass : CVlib


endpackage : CVlibPkg