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

	
	//---------------------------------------
	//  DMA PARAMS
	//---------------------------------------
	task set_dma(longint fstart, int line_pitch, int line_size, int address_buss_width = 2);
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
	endtask


	////////////////////////////////////////////////////////////////
	// Task : xgs_spi_write
	////////////////////////////////////////////////////////////////
	task automatic xgs_spi_write(input int add, input int data);
		// Address data
		regfile.ACQ.ACQ_SER_ADDATA.SER_ADD.set(add);
		regfile.ACQ.ACQ_SER_ADDATA.SER_DAT.set(data);
		this.host.reg_write(regfile.ACQ.ACQ_SER_ADDATA);
		
		// Control register
		regfile.ACQ.ACQ_SER_CTRL.SER_RF_SS.set(1);
		regfile.ACQ.ACQ_SER_CTRL.SER_RWn.set(0);
		regfile.ACQ.ACQ_SER_CTRL.SER_WF_SS.set(1);
		this.host.reg_write(regfile.ACQ.ACQ_SER_CTRL);
	endtask


	////////////////////////////////////////////////////////////////
	// Task : xgs_spi_read
	////////////////////////////////////////////////////////////////
	task automatic xgs_spi_read(input int add, output int data);
		int data_rd;
		int axi_addr;
		int axi_poll_mask;
		int axi_expected_value;
		Cregister r;

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


	endtask

endclass


