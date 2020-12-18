
/****************************************************************************
 * Cdriver.svh
 ****************************************************************************/

/**
 * Class: Cdriver_axil
 *
 * TODO: Add class documentation
 */

import fdkide_pkg::*;


class Cdriver_axil #(int DATA_WIDTH=32, int ADDR_WIDTH=11, int NUMB_INPUT_IO=1, int NUMB_OUTPUT_IO=1);

	virtual axi_lite_interface #(DATA_WIDTH, ADDR_WIDTH) axil;
	virtual io_interface #(NUMB_INPUT_IO, NUMB_OUTPUT_IO) gpio;

	//constructor
	function new(virtual axi_lite_interface #(DATA_WIDTH, ADDR_WIDTH) axil, virtual io_interface #(NUMB_INPUT_IO, NUMB_OUTPUT_IO) gpio);
		//getting the interface
		//super.new(1000,0);
		this.axil     = axil;
		this.gpio     = gpio;
		this.axil.reset_n <= 1'b1;
	endfunction


	// Implement the init virtual function required by the parent
	//task init(input Ctest current_test);
	//	super.init(current_test);
	//	this.reset();
	//endtask

	//////////////////////////////////////////////////////////////
	//
	// Task  : throw_error
	//
	// Description : Set interface signals to a known value
	//
	//////////////////////////////////////////////////////////////
	function void throw_error(string message);
		$error(message);
		//if (this.current_test != null) begin
		//	this.current_test.status.errors++;
		//end
	endfunction

	//////////////////////////////////////////////////////////////
	//
	// Task  : mReset
	//
	// Description : Set interface signals to a known value
	//
	//////////////////////////////////////////////////////////////
	task reset(int cycles = 10);
		// Asynchronous reset
		axil.reset_n <= 1'b0;
		axil.awvalid <= 1'b0;
		axil.awprot  <= 1'b0;
		axil.awaddr  <= 1'b0;
		axil.wvalid  <= 1'b0;
		axil.wstrb   <= 1'b0;
		axil.wdata   <= 1'b0;
		axil.bready  <= 1'b0;
		axil.arvalid <= 1'b0;
		axil.arprot  <= 1'b0;
		axil.araddr  <= 1'b0;
		axil.rready  <= 1'b0;

		for (int i=0; i<gpio.NUMB_OUTPUT_IO; i++) begin
			gpio.output_reg[i] = 1'b0;
		end

		// Set the reset width
		this.wait_n(cycles);
		axil.reset_n <= 1'b1;

	endtask


	//////////////////////////////////////////////////////////////
	//
	// Task  : wait_n
	//
	// Description : Insert wait state for n clock cycles
	//
	//////////////////////////////////////////////////////////////
	task wait_n (int cycles);
		do
		begin
			@(posedge axil.clk);
			cycles = cycles-1;
		end
		while (cycles>0);
	endtask


	//////////////////////////////////////////////////////////////
	//
	// Task  : wait_event
	//
	// Description : Blocking task. Wait for a given event to
	//               occur before resuming operation.
	//
	//////////////////////////////////////////////////////////////
	task wait_event (input int eventID, input int timeout_count);
		automatic int timeout_cntr = timeout_count;
		do
		begin
			@(posedge axil.clk);
			if (gpio.input_io[eventID] == 1'b1) begin
				$display("%t Event detected on gpio.input_io[%d]",$time, eventID);
				return;
			end
			else timeout_cntr--;
		end
		while (timeout_cntr>0);

		// Wait long enough, we reached the timeout
		$fatal(1,"Wait for event timeout");
	endtask


	//////////////////////////////////////////////////////////////
	//
	// Task  : wait_events
	//
	// Description : Blocking task. Wait for a given number of events to
	//               occur before resuming operation.
	//
	//////////////////////////////////////////////////////////////
	task wait_events (input int eventID, input int number_of_events, input int timeout_count);
		automatic int timeout_cntr = timeout_count;
		automatic int event_cntr   = 0;
		do
		begin
			@(posedge axil.clk);
			if (gpio.input_io[eventID] == 1'b1) begin
				event_cntr = event_cntr+1;
				$display("%0t Event #%0d/%0d detected on gpio.input_io[%0d]",$time, event_cntr, number_of_events, eventID);

				if(event_cntr == number_of_events) begin
					return;
				end
			end
			else timeout_cntr--;
		end
		while (timeout_cntr>0);

		// Wait long enough, we reached the timeout
		$fatal(1,"Wait for event timeout");
	endtask


	//////////////////////////////////////////////////////////////
	//
	// Task  : set_output_io
	//
	// Description : Blocking task. Wait for a given event to
	//               occur before resuming operation.
	//
	//////////////////////////////////////////////////////////////
	task set_output_io (input int IO_ID, input int value=1);
		begin
			@(posedge axil.clk);
			if (value == 0) begin
				$display("%t Setting gpio.output_io[%d] to 1'b0",$time, IO_ID);
				gpio.output_reg[IO_ID] = 1'b0;
			end else begin
				$display("%t Setting gpio.output_io[%d] to 1'b1",$time, IO_ID);
				gpio.output_reg[IO_ID] = 1'b1;
			end
		end
	endtask


	//////////////////////////////////////////////////////////////
	//
	// Task  : pulse_output_io
	//
	// Description : Blocking task. Wait for a given event to
	//               occur before resuming operation.
	//
	//////////////////////////////////////////////////////////////
	task pulse_output_io (input int IO_ID, input int number_of_ck_cycles=1);
		int cycle_cntr;

		begin
			cycle_cntr = number_of_ck_cycles;
			$display("%t Setting a pulse on output_io.gpio[%d]",$time, IO_ID);
			do
			begin
				@(posedge axil.clk);
				gpio.output_reg[IO_ID] = ~gpio.output_io[IO_ID];
				number_of_ck_cycles--;
			end
			while (number_of_ck_cycles > 0);
		end
	endtask


	//////////////////////////////////////////////////////////////
	//
	// Task  : write
	//
	// Description : Produce AXI Lite Write transaction
	//
	//////////////////////////////////////////////////////////////
	task write (
		input int inputAddr,
		input int inputData,
		input int inputStrb = 'hf,
		input int timeout_count = 1000,
		input int verbose = 1
		);
		automatic int timeout_cntr = timeout_count;

		@(posedge axil.clk);
		axil.awprot  <= 3'b000;
		axil.awvalid <= 1'b1;
		axil.awaddr  <= inputAddr;
		axil.wvalid  <= 1'b1;
		axil.wstrb   <= inputStrb;
		axil.wdata   <= inputData;
		axil.arprot  <= 3'b000;
		axil.araddr  <= 1'b0;
		axil.rready  <= 1'b0;
		axil.bready  <= 1'b1;

		if(verbose) $display("%t AXI Write : Addr: 0x%h; Data: 0x%h, BeN: 0x%h",$time, inputAddr, inputData, inputStrb);

		/////////////////////////////////////////////////////////
		// Address acknowledge
		/////////////////////////////////////////////////////////
		do
		begin
			@(posedge axil.clk);

				// Check address acknowledge timeout
			timeout_cntr--;
			assert (timeout_cntr > 0) else $fatal(1,"AXI Write: Address acknowledge timeout");

		end
		while (axil.awready != 1);

		// De-assert awvalid
		axil.awvalid <= 1'b0;


		/////////////////////////////////////////////////////////
		// Data acknowledge
		/////////////////////////////////////////////////////////
		timeout_cntr = timeout_count;

		while ((axil.wvalid == 1) &&  (axil.wready != 1))
		begin
			@(posedge axil.clk);

				// Check data acknowledge timeout
			timeout_cntr--;
			assert (timeout_cntr > 0) else $fatal(1,"AXI Write: Data acknowledge timeout");
		end

		// De-assert wvalid
		axil.wvalid <=  1'b0;


		/////////////////////////////////////////////////////////
		// Data response acknowledge
		/////////////////////////////////////////////////////////
		timeout_cntr = timeout_count;

		while (axil.bvalid != 1 )
		begin
			@(posedge axil.clk);

				// Check write response timeout
			timeout_cntr--;
			assert (timeout_cntr > 0) else $fatal(1,"AXI Write: Response acknowledge timeout");
		end

		// Deassert bready
		axil.bready <= 1'b0;


		/////////////////////////////////////////////////////////
		// Validate write response status
		/////////////////////////////////////////////////////////
		assert (axil.bresp == 0) else throw_error("Bad axi write response");

	endtask

	//////////////////////////////////////////////////////////////
	//
	// Task  : reg_write
	//
	// Description : Produce AXI Lite register Write transaction
	//
	//////////////////////////////////////////////////////////////
	task reg_write (
		input Cregister register,
		input int timeout_count = 1000,
		input int verbose = 1
		);
		
		int inputAddr;
		int inputData;	
		int inputStrb;
		string path;
		Cfield field;
 	
		inputAddr = register.get_address();
		inputData = register.data;
		inputStrb = 'hf;
		
		// Verbose the transaction
		path = register.get_path();
		if(verbose) $display("%t AXI write register\t: %s\t@addr: 0x%h; data: 0x%h", $time, path, inputAddr, inputData);
		
		// Call low level axi write
		this.write (inputAddr, inputData,inputStrb,timeout_count,0);
		
		//Emulate the auto clear done in the real hardware register
		foreach (register.children[i]) begin
			$cast(field, register.children[i]);	
			if (field.field_type == WO) begin
				field.set(0);
			end else if (field.field_type == RW2C) begin
				field.set(0);
			end
		end
			
		register.clr_dirty();
	endtask

	
	//////////////////////////////////////////////////////////////
	//
	// Task  : reg_read
	//
	// Description : Execute AXI Lite Read transaction
	//
	//////////////////////////////////////////////////////////////
	task reg_read (
		inout Cregister register,
		input int timeout_count = 1000,
		input int verbose = 1
		);
		string path;
		longint readData;
		int inputAddr;
		
		
		inputAddr = register.get_address();

		// Verbose the transaction
		path = register.get_path();
		if(verbose) $display("%t AXI read register\t: %s\t@addr: 0x%h", $time, path, inputAddr);

		
		// Call low level axi read
		this.read (inputAddr,readData,timeout_count,0);
		register.data = readData;
	endtask
	
	//////////////////////////////////////////////////////////////
	//
	// Task  : reg_poll
	//
	// Description : Polling
	//
	//////////////////////////////////////////////////////////////
	task reg_poll (
		input Cnode node,
		input int expectedData = 1,
		input int mask = 'hffffffff,
		input time polling_period = 1us,
		input int max_iteration = 1000,
		input int verbose = 1
		);
		
		Cregister register;
		Cfield field;
		int reg_mask;
		int reg_addr;
		int msb;
		int lsb;
		int size;
		int reg_expected_data;
		string path;

		//////////////////////////////////////////////////////////
		// Node is a field
		//////////////////////////////////////////////////////////
		if ($cast(field, node)) begin
			$cast(register,field.parent);
			lsb = field.right;
			msb = field.left;
			size = msb-lsb+1;
			reg_mask = (~(-1 << size) << lsb);
			reg_expected_data = expectedData << lsb;
			reg_addr = register.get_address();

			// Verbose the transaction
			path = node.get_path();
			if(verbose) $display("%t AXI poll field\t: %s\t@addr: 0x%h; expected data: 0x%h", $time, path, reg_addr, reg_expected_data);

		end 		
		
		//////////////////////////////////////////////////////////
		// Node is a register
		//////////////////////////////////////////////////////////
		else if ($cast(register, node))begin
			reg_mask = mask;
			reg_expected_data = expectedData;
			reg_addr = register.get_address();
			
			// Verbose the transaction
			path = node.get_path();
			if(verbose) $display("%t AXI poll register\t: %s\t@addr: 0x%h; expected data: 0x%h", $time, path, reg_addr, reg_expected_data);
	
		end
		
		this.poll (
				.inputAddr(reg_addr),
				.expectedData(expectedData),
				.mask(reg_mask),
				.polling_period(polling_period),
				.max_iteration(max_iteration),
				.verbose(0)
			);
		
	endtask

	//////////////////////////////////////////////////////////////
	//
	// Task  : poll
	//
	// Description : Execute AXI Lite poll transaction
	//
	//////////////////////////////////////////////////////////////
	task poll (
		input int inputAddr,
		input int expectedData,
		input int mask = 'hffffffff,
		input time polling_period = 10us,
		input int max_iteration = 1000,
		input int verbose = 1
		);
		int masked_data;
		int axi_data;
		int iteration_cntr = 0;


		//////////////////////////////////////////////////////////
		// Start polling
		//////////////////////////////////////////////////////////
		if(verbose) $display("Polling @0x%h ", inputAddr);
		do
		begin
			// Wait for the timeout value
			#(polling_period*1ns);
			read(inputAddr, axi_data, .verbose(0));
			masked_data = (axi_data & mask);

			if (iteration_cntr == max_iteration) begin
				$write("\n\n\t");
				$fatal(1,"#### Polling max count reached at address 0x%h; expected data : 0x%h ####\n\n", inputAddr, expectedData);
			end
			// Progression bar
			iteration_cntr++;
		end
		while(masked_data != expectedData);

		if(verbose) $display("Polling succeded in %d iterations!!!", iteration_cntr);
	endtask // poll


	//////////////////////////////////////////////////////////////
	//
	// Task  : read
	//
	// Description : Execute AXI Lite Read transaction
	//
	//////////////////////////////////////////////////////////////
	task read (
		input int inputAddr,
		output int readData,
		input int timeout_count = 1000,
		input int verbose = 1
		);
		automatic int timeout_cntr = timeout_count;

		@(posedge axil.clk);
		axil.arvalid <= 1'b1;
		axil.arprot  <= 1'b0;
		axil.araddr  <= inputAddr;
		axil.rready  <= 1'b1;


		if(verbose) $display("%t AXI Read  : Addr: 0x%h",$time, inputAddr);

		/////////////////////////////////////////////////////////
		// Address acknowledge
		/////////////////////////////////////////////////////////
		do
		begin
			@(posedge axil.clk);

				// Check address acknowledge timeout
			timeout_cntr--;
			assert (timeout_cntr > 0) else
			begin
				$fatal(1,"AXI Read: Address acknowledge timeout");
				terminate();
			end
		end
		while (axil.arready != 1);

		// De-assert arvalid
		axil.arvalid <= 1'b0;


		/////////////////////////////////////////////////////////
		// Data acknowledge
		/////////////////////////////////////////////////////////
		timeout_cntr = timeout_count;

		while (axil.rvalid != 1 )
		begin
			@(posedge axil.clk);

				// Check write response timeout
			timeout_cntr--;
			assert (timeout_cntr > 0) else $fatal(1,"AXI Read: Data response acknowledge timeout");
		end

		// Deassert rready
		axil.rready <= 1'b0;


		/////////////////////////////////////////////////////////
		// Validate masked read data vs expected data
		/////////////////////////////////////////////////////////
		readData = axil.rdata;
		if(verbose) $display("\t\tRead data: 0x%h",readData);

			//		assert ((axil.rdata & readMask) == expectedData)
			//			$display("%t  Data: 0x%h",$time,axil.rdata);
			//		else
			//		begin
			//			string message;
			//			$sformat(message, "%t  Returned data: 0x%h",$time,axil.rdata);
			//			this.throw_error(message);
			//		end

		/////////////////////////////////////////////////////////
		// Validate read response status
		/////////////////////////////////////////////////////////
		assert (axil.rresp == 0) else this.throw_error("Bad axi read response");

	endtask // mRead


	//////////////////////////////////////////////////////////////
	//
	// Task  : read_modify_write
	//
	// Description : Execute AXI Lite Read transaction
	//
	//////////////////////////////////////////////////////////////
	task read_modify_write (
		input int inputAddr,
		input int writeData,
		input int writeMask,
		input int timeout_count = 1000
		);

		int data;

		this.read (inputAddr, data,timeout_count);

		data = data | (writeData & writeMask);
		this.write (inputAddr,data,'hff,timeout_count);

	endtask // read_modify_write

	//////////////////////////////////////////////////////////////
	//
	// Task  : terminate
	//
	// Description : Execute AXI Lite Read transaction
	//
	//////////////////////////////////////////////////////////////
	task terminate();

		$display("\n\n");
		$display("*************************************");
		$display("*********** TEST STATUS *************");
		$display("*************************************");
		$display("\n\n");

		#10 $display(" SIMULATION TERMINATION at %t",$time);
		$finish;
	endtask // terminate


	endclass
