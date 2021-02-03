/****************************************************************************
 * Cathena.svh
 ****************************************************************************/

/**
 * Class: Cathena
 * 
 * TODO: Add class documentation
 */
import driver_pkg::*;
import xgs_pkg::*;
import fdkide_pkg::*;
import regfile_xgs_athena_pkg::*;

class Cathena;
	parameter SPI_MODEL_ID_OFFSET          = 16'h000;
	parameter SPI_REVISION_NUMB_OFFSET     = 16'h31FE;
	parameter SPI_RESET_REGISTER_OFFSET    = 16'h3700;
	parameter SPI_UNKNOWN_REGISTER_OFFSET  = 16'h3e3e;
	parameter SPI_UNKNOWN_REGISTER_REG     = 16'h3e3e;
	parameter SPI_HISPI_CONTROL_COMMON_REG = 16'h3e28;
	parameter SPI_TEST_PATTERN_MODE_REG    = 16'h3e0e;
	parameter SPI_LINE_TIME_REG            = 16'h3810;
	parameter SPI_GENERAL_CONFIG0_REG      = 16'h3800;
	parameter SPI_MONITOR_REG              = 16'h3806;

	Cdriver_axil host; 
	Cregfile_xgs_athena regfile;
	Cxgs_sensor xgs_sensor;
	int line_time;

	function new(Cdriver_axil host, Cxgs_sensor xgs_sensor, int line_time = 'h02dc);
		this.host = host;
		this.xgs_sensor = xgs_sensor;
		this.regfile=new();
		
		// Is this really the best place to define the line time?
		this.line_time = line_time;
	endfunction

	

	////////////////////////////////////////////////////////////////
	// Task : xgs_spi_write
	////////////////////////////////////////////////////////////////
	task automatic xgs_spi_write(input int add, input int data, input int verbose = 1);
		
		if(verbose) $display("%t XGS spi write @addr: 0x%h; data: 0x%h", $time, add, data);
		
		// Address data
		regfile.ACQ.ACQ_SER_ADDATA.SER_ADD.set(add);
		regfile.ACQ.ACQ_SER_ADDATA.SER_DAT.set(data);
		this.host.reg_write(regfile.ACQ.ACQ_SER_ADDATA);
		
		// Control register
		regfile.ACQ.ACQ_SER_CTRL.SER_RF_SS.set(1);
		regfile.ACQ.ACQ_SER_CTRL.SER_RWn.set(0);
		regfile.ACQ.ACQ_SER_CTRL.SER_WF_SS.set(1);
		this.host.reg_write(regfile.ACQ.ACQ_SER_CTRL);
		if(verbose) $display("%t XGS spi write done\n", $time);
	endtask


	////////////////////////////////////////////////////////////////
	// Task : xgs_spi_read
	////////////////////////////////////////////////////////////////
	task automatic xgs_spi_read(input int add, output int data, input int verbose = 1);
		int data_rd;
		int axi_addr;
		int axi_poll_mask;
		int axi_expected_value;
		Cregister r;

		if(verbose) $display("%t XGS spi read @addr: 0x%h", $time, add);

		// Set the transaction address
		regfile.ACQ.ACQ_SER_ADDATA.SER_ADD.set(add);
		this.host.reg_write(regfile.ACQ.ACQ_SER_ADDATA);

		// Configure the transaction access (read transaction)
		regfile.ACQ.ACQ_SER_CTRL.SER_RWn.set(1);
		this.host.reg_write(regfile.ACQ.ACQ_SER_CTRL);
		
		// Snapshot the write transaction
		regfile.ACQ.ACQ_SER_CTRL.SER_WF_SS.set(1);
		this.host.reg_write(regfile.ACQ.ACQ_SER_CTRL);
		
		// Snapshot the read fifo
		regfile.ACQ.ACQ_SER_CTRL.SER_RF_SS.set(1);
		this.host.reg_write(regfile.ACQ.ACQ_SER_CTRL);
		
		// Poll for the data ready
		this.host.reg_poll(regfile.ACQ.ACQ_SER_STAT.SER_BUSY, .expectedData(0), .polling_period(1us));

		// Read and output the return data
		r = regfile.ACQ.ACQ_SER_STAT;
		this.host.reg_read(r);
		data= regfile.ACQ.ACQ_SER_STAT.SER_DAT_R.get();
		if(verbose) $display("%t XGS spi read done\n", $time);
	endtask

	//---------------------------------------
	//  Program XGS MODEL
	//---------------------------------------
	task turn_on_xgs();

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
		$display("XGS Controller wakes up sensor");
		//$display("  1. Write SENSOR_CTRL register @0x%h", SENSOR_CTRL_OFFSET);
		this.regfile.ACQ.SENSOR_CTRL.SENSOR_POWERUP.set(1);
		this.regfile.ACQ.SENSOR_CTRL.SENSOR_RESETN.set(1);
		this.host.reg_write(regfile.ACQ.SENSOR_CTRL);

		// Poll until clock enable and reset disable
		//$display("  2. Poll SENSOR_STAT register @0x%h", SENSOR_STAT_OFFSET);
		this.host.reg_poll(this.regfile.ACQ.SENSOR_STAT.SENSOR_POWERUP_DONE, .polling_period(1us));
		

		// SPI configure the XGS sensor model
		$display("SPI configure the XGS sensor model");

		// A minimum delay is required before we can start SPI transactions
		#200us;

			// SPI read XGS model id
		$display("  1. SPI read XGS model id and revision @0x%h", SPI_MODEL_ID_OFFSET);
		xgs_spi_read(SPI_MODEL_ID_OFFSET, data_rd);

		// Validate result
		if(data_rd==16'h0058) begin
			$display("XGS Model ID detected is 0x58, XGS12M");
		end
		else if(data_rd==16'h0358) begin
			$display("XGS Model ID detected is 0x358, XGS5M");
		end
		else if(data_rd==16'h0258) begin
			$display("XGS Model ID detected is 0x258, XGS16M");
		end
		else begin
			$error("XGS Model ID detected is %0d", data_rd);
		end

		// SPI read revision
		$display("  2. SPI read XGS revision number @0x%h", SPI_REVISION_NUMB_OFFSET);
		xgs_spi_read(SPI_REVISION_NUMB_OFFSET, data_rd);
		$display("Addres 0x31FE : XGS Revision ID detected is %x", data_rd);

		// SPI reset
		$display("  3. SPI write XGS register reset @0x%h", SPI_RESET_REGISTER_OFFSET);
		xgs_spi_write(SPI_RESET_REGISTER_OFFSET, 16'h001c);

		//- Wait at least 500us for the PLL to start and all clocks to be stable.
		#500us;

			//- REG Write = 0x3E3E, 0x0001
		$display("  4. SPI write XGS UNKNOWN register @0x%h", SPI_UNKNOWN_REGISTER_OFFSET);
		xgs_spi_write(SPI_UNKNOWN_REGISTER_OFFSET, 16'h0001);


		// XGS model : setting mux output ratio to 4:1
		// HISPI control common register
		// xgs_spi_write(16'h3e28,16'h2507);                     //mux 4:4
		// xgs_spi_write(16'h3e28,16'h2517);                     //mux 4:3
		// xgs_spi_write(16'h3e28,16'h2527);                     //mux 4:2
		$display("  5. SPI write XGS HiSPI control common register @0x%h", SPI_HISPI_CONTROL_COMMON_REG);
		xgs_spi_write(SPI_HISPI_CONTROL_COMMON_REG,16'h2537);    //mux 4:1
				
		// XGS model : Set line time (for 6 lanes)
		$display("  4.7 SPI write XGS set line time @0x%h", SPI_LINE_TIME_REG);
		line_time = 'h02dc;                              // default in model and in devware is 0xe6  (24 lanes), XGS12M register is 0x16e @32.4Mhz (T=30.864ns)
		xgs_spi_write(SPI_LINE_TIME_REG, line_time);      // register_map(1032) <= X"00E6";    --Address 0x3810 - line_time


		// XGS model : Slave Mode And ENABLE SEQUENCER
		$display("  4.8 SPI write XGS set general config @0x%h", SPI_GENERAL_CONFIG0_REG);
		xgs_spi_write(SPI_GENERAL_CONFIG0_REG,16'h0030);                 // Slave + trigger mode
		xgs_spi_write(SPI_GENERAL_CONFIG0_REG,16'h0031);                 // Enable sequencer


		// XGS model : Set Monitor pins
		$display("  4.9 SPI write XGS set monitor pins @0x%h", SPI_MONITOR_REG);
		monitor_0_reg = 16'h6;    // 0x6 : Real Integration  , 0x2 : Integrate
		monitor_1_reg = 16'h10;   // EFOT indication
		monitor_2_reg = 16'h1;    // New_line
		xgs_spi_write(SPI_MONITOR_REG, (monitor_2_reg<<10) + (monitor_1_reg<<5) + monitor_0_reg );      // Monitor Lines

		$display("XGS Controller wakes up sensor done\n");

	endtask
	
	
	//---------------------------------------
	//  Program XGS MODEL
	//---------------------------------------
	task setXGScontroller();
		string path;
		longint address;
		real xgs_bitrate_period;  //32.4Mhz ref clk*2 /12 bits per clk
		real xgs_ctrl_period;
		int EXP_FOT_TIME;
		int MLines;
		int MLines_supressed;
		int KEEP_OUT_TRIG_START_sysclk;
		int KEEP_OUT_TRIG_END_sysclk;

		// PROGRAM XGS CONTROLLER
		$display("5. SPI configure the XGS_athena IP-Core controller section");

		// A minimum delay is required before we can start
		// SPI transactions [AM] Why? Can this be removed?
		#50us;

			// XGS Controller : SENSOR REG_UPDATE =1
			// Give SPI control to XGS controller   : SENSOR REG_UPDATE =1
		$display("  5.1 Write register : %s", regfile.ACQ.SENSOR_CTRL.get_path());
		//host.write(SENSOR_CTRL_OFFSET, 16'h0012);
		this.regfile.ACQ.SENSOR_CTRL.SENSOR_RESETN.set(1);
		this.regfile.ACQ.SENSOR_CTRL.SENSOR_REG_UPDATE.set(1);
		this.host.reg_write(regfile.ACQ.SENSOR_CTRL);


		// XGS Controller : set the line time (in pixel clock)	
		$display("  5.2 Write READOUT_CFG3 (line time) register %s", this.regfile.ACQ.READOUT_CFG3.get_path());
		this.regfile.ACQ.READOUT_CFG3.LINE_TIME.set(this.line_time);
		this.host.reg_write(this.regfile.ACQ.READOUT_CFG3);
		
		// XGS Controller : exposure time during FOT
		$display("  5.3 Write EXP_FOT (exposure time during FOT) register %s", this.regfile.ACQ.EXP_FOT.get_path());
		xgs_ctrl_period     = 16.0; // Ref clock preiod
		xgs_bitrate_period  = (1000.0/32.4)/(2.0);  // 30.864197ns /2
		EXP_FOT_TIME        = 5360;  //5.36us calculated from start of FOT to end of real exposure
		
		this.regfile.ACQ.EXP_FOT.EXP_FOT_TIME.set(EXP_FOT_TIME);
		this.regfile.ACQ.EXP_FOT.EXP_FOT.set(1);   //Enable EXP during FOT
		this.host.reg_write(this.regfile.ACQ.EXP_FOT);

		// XGS Controller : Keepout trigger zone
		$display("  5.4 Write READOUT_CFG4 (Keepout trigger zone) register %s", this.regfile.ACQ.READOUT_CFG4.get_path());

		KEEP_OUT_TRIG_START_sysclk = ((line_time*xgs_bitrate_period) - 100 ) / xgs_ctrl_period;  //START Keepout trigger zone (100ns)
		KEEP_OUT_TRIG_END_sysclk   = (line_time*xgs_bitrate_period)/xgs_ctrl_period;             //END   Keepout trigger zone (100ns), this is more for testing, monitor will reset the counter
		//host.write(READOUT_CFG4_OFFSET, (KEEP_OUT_TRIG_END_sysclk<<16) + KEEP_OUT_TRIG_START_sysclk);
		this.regfile.ACQ.READOUT_CFG4.KEEP_OUT_TRIG_START.set(KEEP_OUT_TRIG_START_sysclk);
		this.regfile.ACQ.READOUT_CFG4.KEEP_OUT_TRIG_ENA.set(KEEP_OUT_TRIG_END_sysclk);
		this.host.reg_write(this.regfile.ACQ.READOUT_CFG4);
		
		//host.write(READOUT_CFG3_OFFSET, (0<<16) + line_time);      //Enable KEEP_OUT ZONE[bit 16]
		this.regfile.ACQ.READOUT_CFG3.LINE_TIME.set((0<<16) + line_time); //[AM] WHY this line?
		this.host.reg_write(this.regfile.ACQ.READOUT_CFG3);



		// XGS Controller : M_lines
		$display("  5.5 Write SENSOR_M_LINES register %s", this.regfile.ACQ.SENSOR_M_LINES.get_path());
		MLines           = 0;
		MLines_supressed = 0;
		//host.write(SENSOR_M_LINES_OFFSET, (MLines_supressed<<10)+ MLines);    //M_LINE REGISTER
		this.regfile.ACQ.SENSOR_M_LINES.M_LINES_SENSOR.set(MLines);
		this.regfile.ACQ.SENSOR_M_LINES.M_SUPPRESSED.set(MLines_supressed);
		this.host.reg_write(this.regfile.ACQ.SENSOR_M_LINES);
		
		// XGS Controller : Subsampling
		//$display("  5.6 Write SENSOR_SUBSAMPLING register @0x%h", SENSOR_SUBSAMPLING_OFFSET);
		//host.write(SENSOR_SUBSAMPLING_OFFSET, 'h8); //SUBY
		//host.write(SENSOR_SUBSAMPLING_OFFSET, 'h1); //SUBX
		//host.write(SENSOR_SUBSAMPLING_OFFSET, 'h9); //SUBX+Y
		//host.write(SENSOR_SUBSAMPLING_OFFSET, 0); //NO SUB

		// XGS Controller : Analog gain
		$display("  5.7 Write SENSOR_GAIN_ANA register %s", this.regfile.ACQ.SENSOR_GAIN_ANA.get_path());
		//host.write(SENSOR_GAIN_ANA_OFFSET, 2<<8);
		this.regfile.ACQ.SENSOR_GAIN_ANA.ANALOG_GAIN.set(2);
		$display("XGS_athen controller configuration done\n");
	endtask				

	//---------------------------------------
	//  DMA PARAMS
	//---------------------------------------
	task set_dma(longint fstart, int line_pitch, int line_size, int address_buss_width = 2);
		$display("5. XGS_athena IP-Core set DMA section");
		regfile.DMA.FSTART.VALUE.set(fstart);
		this.host.reg_write(regfile.DMA.FSTART);
		
		regfile.DMA.FSTART_HIGH.VALUE.set(fstart>>32);
		this.host.reg_write(regfile.DMA.FSTART_HIGH);
		
		regfile.DMA.LINE_PITCH.VALUE.set(line_pitch);
		this.host.reg_write(regfile.DMA.LINE_PITCH);
		
		regfile.DMA.LINE_SIZE.VALUE.set(line_size);
		this.host.reg_write(regfile.DMA.LINE_SIZE);
		
		regfile.DMA.OUTPUT_BUFFER.ADDRESS_BUS_WIDTH.set(address_buss_width);
		this.host.reg_write(regfile.DMA.OUTPUT_BUFFER);
		$display("XGS_athena IP-Core set DMA section done\n");
	endtask


	////////////////////////////////////////////////////////////////
	// Task : GenImage_XGS
	////////////////////////////////////////////////////////////////
	task automatic GenImage_XGS(input int ImgPattern);
		$display("XGS_athena generate sensor image");
		//super.super.xgs_model_GenImage = 1'b0;      
		xgs_spi_write(SPI_TEST_PATTERN_MODE_REG, ImgPattern);		
		//host.poll(BAR_XGS_ATHENA + 'h00000168, 0, (1<<16), .polling_period(1us));  // attendre la fin de l'ecriture au registre XGS via SPI!  
		this.host.reg_poll(regfile.ACQ.ACQ_SER_STAT.SER_BUSY, .expectedData(0), .polling_period(1us));

		#1ns;
		xgs_spi_write(8, 16'h0001);           // Cree le .pgm et loade le modele XGS vhdl dew facon SW par ecriture ds le modele
		#10us;		// [AM] Why this delay?
		xgs_spi_write(8, 16'h0000);
		$display("XGS_athena generate sensor image done\n");
	endtask
	
	
	///////////////////////////////////////////////////
	// DPC
	///////////////////////////////////////////////////
	task  set_dpc();
		int	DPC_PATTERN;
		int REG_DPC_PATTERN0_CFG;
		
		$display("Set DPC");
//		regfile.DMA.FSTART.VALUE.set(fstart);
//		this.host.reg_write(regfile.DMA.FSTART);
		

		
		REG_DPC_PATTERN0_CFG = 1;
		
		// Reset DPC_LIST_CTRL
		// host.write(super.Vlib.DPC_LIST_CTRL, 0);
		regfile.DPC.DPC_LIST_CTRL.data = 0;
		this.host.reg_write(regfile.DPC.DPC_LIST_CTRL);
		
		// Set the DPC list in write mode
		//host.write(super.Vlib.DPC_LIST_CTRL, (0<<15)+(1<<13) );                    //DPC_ENABLE= 0, DPC_PATTERN0_CFG=0, DPC_LIST_WRN=1
		regfile.DPC.DPC_LIST_CTRL.dpc_list_WRn.set(1);
		this.host.reg_write(regfile.DPC.DPC_LIST_CTRL);

		DPC_PATTERN = 85; 
		for (int i = 0; i < 16; i++)
		begin				
			host.write(super.Vlib.DPC_LIST_CTRL,  (1<<15)+(1<<13) + i );           // DPC_ENABLE= 0, DPC_PATTERN0_CFG=1, DPC_LIST_WRN=1, DPC_LIST_ADD						
			host.write(super.Vlib.DPC_LIST_DATA1, (i<<16)+i );                     // DPC_LIST_CORR_X = i, DPC_LIST_CORR_Y = i
			host.write(super.Vlib.DPC_LIST_DATA2,  DPC_PATTERN);                   // DPC_LIST_CORR_PATTERN = 0;
			host.write(super.Vlib.DPC_LIST_CTRL,  (1<<15)+(1<<13) + (1<<12) + i ); // DPC_ENABLE= 0, DPC_PATTERN0_CFG=1, DPC_LIST_WRN=1, DPC_LIST_ADD + SS

			//XGS_imageSRC.DPC_add(i, i, DPC_PATTERN);                    // Pour la prediction, ici j'incremente de 1 le nb de DPC a chaque appel          
		end

		DPC_PATTERN  = 170;
		for (int i = 16; i < 63; i++)
		begin				
			host.write(super.Vlib.DPC_LIST_CTRL,  (1<<15)+(1<<13) + i );           // DPC_ENABLE= 0, DPC_PATTERN0_CFG=1, DPC_LIST_WRN=1, DPC_LIST_ADD						
			host.write(super.Vlib.DPC_LIST_DATA1, (i<<16)+i );                     // DPC_LIST_CORR_X = i, DPC_LIST_CORR_Y = i
			host.write(super.Vlib.DPC_LIST_DATA2,  DPC_PATTERN);                   // DPC_LIST_CORR_PATTERN = 0;
			host.write(super.Vlib.DPC_LIST_CTRL,  (1<<15)+(1<<13) + (1<<12) + i ); // DPC_ENABLE= 0, DPC_PATTERN0_CFG=1, DPC_LIST_WRN=1, DPC_LIST_ADD + SS

			//XGS_imageSRC.DPC_add(i, i, DPC_PATTERN);                    // Pour la prediction, ici j'incremente de 1 le nb de DPC a chaque appel          
		end

		host.write(super.Vlib.DPC_LIST_CTRL,  (i<<16) + (REG_DPC_PATTERN0_CFG<<15)+(1<<14) );  // DPC_LIST_COUNT() + DPC_PATTERN0_CFG(15), DCP ENABLE(14)=1
		XGS_imageSRC.DPC_set_pattern_0_cfg(REG_DPC_PATTERN0_CFG);                   // Pour la prediction 
		XGS_imageSRC.DPC_set_firstlast_line_rem(0);                                 // Pour la prediction 

	endtask

	
	task automatic configure_testbench();
		// Assign the right XGS sensor model in the testbench
		case (this.xgs_sensor.model_id)
			// XGS12M
			'h58: begin
				host.set_output_io (0, 1);
				host.set_output_io (1, 0);
				$display("XGS_sensor configured as XGS16000");
			end
			// XGS5M
			'h358: begin
				host.set_output_io (0, 0);
				host.set_output_io (1, 0);
				$display("XGS_sensor configured as XGS16000");
			end
			// XGS16M
			'h258: begin
				host.set_output_io (0, 0);
				host.set_output_io (1, 1);
				$display("XGS_sensor configured as XGS16000");
			end
			default: begin
				$error("XGS_sensor : bad type : 0x%0h", this.xgs_sensor.model_id);
			end
		endcase
	endtask
		
		

endclass


