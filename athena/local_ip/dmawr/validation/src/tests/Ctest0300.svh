/*
 * test0300
 * 
 * Category    : Test timer[0]
 * 
 * Description : NOT FUNCTIONNAL YET. WORK IN PROGRESS
 *  
 * 
 */
	import core_pkg::*;
	import network_pkg::*;
	import gev_pkg::*;
	import driver_pkg::*;
	import scoreboard_pkg::*;
	import axiMaio_pkg::*;

	class Ctest0300 extends Ctest;
		static int MAX_PACKET_SIZE_IN_DW = 32;
		static int MAX_PACKET_COUNT      = 32; // Context list max size
		static int NUMBER_OF_PACKET_SENT = 2; // Context list max size
		static int currentPktID = 0;
		static int timeout = 100;
		static int INPUT_ID = 0;
		static int RISING_EDGE = 0;
		static int INT_EN = 1;
		
		Cdriver_axiMaio driver;
		Cethernet_frame eth0;
		Cscoreboard_mii scoreboard;
		CaxiMaio axiMaio;

		function new(Cdriver_axiMaio driver, Cscoreboard_mii scoreboard);
			super.new("test0300");
			this.driver = driver;
			this.scoreboard = scoreboard;
			this.axiMaio = new(driver,0);
		endfunction; // new

		task run();
			string message;
			int CONTROLLER_0 = 0;
			int IO_INPUT[6] = this.axiMaio.INPUT_I0_ID;
			static int IRQ0_ID = 0;

			automatic int address = 0;

			automatic  int data = 0;
			automatic  int strb = 'hf;
			automatic  int read_data = 0;
			automatic  int timeout = 100;
			automatic  int read_mask = 'hffffffff;
			automatic  int NUMBER_OF_LOOP = 256;
			automatic  int toe0_bufferOffset = 'h1000;

			Cethernet_frame eth_frame[2];

			Cgev_writereg_cmd gev_writereg_cmd[2];
			Cgev_register gev_register;
			Ctoe_list toe_list;
			shortint request_id = 10;
			byte     flag = 0;
			// Validation
			longint dest_mac_addr = 64'h003053352eb2;
			longint src_mac_addr = 64'h0020fc321dd8;

			int src_ip_addr = 'h00a9fed5f7;
			int dest_ip_addr = 'h0a9fe0a42;

			shortint src_port = 16'hfa18;
			shortint dest_port = 16'h0f74;
			stream_t crc_in = {0};
			int crc_result;
			stream_t crc_stream;
			stream_t eth_stream;
			stream32_t eth_stream32;
			stream32_t eth_framebuffer;


			fork

				////////////////////////////////////////////////////////////
				//
				// FORK Process 1
				//
				////////////////////////////////////////////////////////////
				begin
					int clockPeriod;
					
					// Reset the hardware
					driver.wait_n(100);
			        driver.reset();
			        driver.wait_n(100);
			        
			      

					////////////////////////////////////////////////////////
                    // 
                    // Initialize the axiMAIO
                    //
					////////////////////////////////////////////////////////
					// Create the toe list
					this.axiMaio.init();
					//
					address = 'h504;
					this.driver.read(address, clockPeriod, timeout);
					driver.wait_n(10);
					

					// Timer delay
					address = 'h510;
					data = 'h0;
					this.driver.write(address, data, strb, timeout);
					driver.wait_n(10);

					// Timer delay
					address = 'h514;
					data = 'h800;
					this.driver.write(address, data, strb, timeout);
					driver.wait_n(10);

					// Timer Status
					driver.wait_n(1000);
					address = 'h51c;
					data = 'h30001;
					this.driver.write(address, data, strb, timeout);
					driver.wait_n(10);
					

					////////////////////////////////////////////////////////
					//
					// Send a software trigger ToE on port 0
					//
					////////////////////////////////////////////////////////
					//this.axiMaio.send_software_trigger(0);
					driver.set_output_io(0, 1);

					// Wait for the 4 interrupts
					driver.wait_event(IRQ0_ID, 100000);
					driver.wait_n(10);

					this.axiMaio.set_output_pin(0);
					driver.wait_n(10);
					this.axiMaio.set_output_pin(1);
					driver.wait_n(10);
					
					////////////////////////////////////////////////////////
					//
					// Clear ToListESent  interrupt flag
					//
					////////////////////////////////////////////////////////
					driver.wait_n(1000);


				end


				////////////////////////////////////////////////////////////
				//
				// FORK Process 2 (Run forever)
				//
				////////////////////////////////////////////////////////////
				begin
					scoreboard.run();

				end

				// Since process 2 run forever; process 1 will exit the fork (join_any)
			join_any


			////////////////////////////////////////////////////////////
			//
			// Create a prediction buffer and compare it with with the
			// the received buffer of the scoreboard.
			//
			////////////////////////////////////////////////////////////
			// Wrap the message in an UDP datagram
			for (int i = 0; i < NUMBER_OF_PACKET_SENT; i++) begin
				Cethernet_frame gev_cmd_frame;

				// Predicted requestID
				gev_writereg_cmd[i].request_id = this.axiMaio.GEV_REQUEST_ID_MIN_VALUE + i;
				gev_cmd_frame = gev_writereg_cmd[i].frame("Frame_gevmsg0",src_ip_addr, dest_ip_addr, src_port, dest_port,src_mac_addr,  dest_mac_addr);


				// Pad to align on 32 bits border like in the axi ethernetlite				
				while (gev_cmd_frame.size() % 4 > 0 ) begin
					gev_cmd_frame.payload.push_back(0);
				end

				eth_stream = gev_cmd_frame.serialize();

				// Create a 32 bits Little endian stream
				eth_stream32 = stream_to_stream32_reverse(eth_stream);
				eth_stream32.push_front(32'hD5555555);
				eth_stream32.push_front(32'h55555555);

				//Concatenate the new  frame in the frame buffer
				eth_framebuffer= {eth_framebuffer, eth_stream32};
			end

			super.status.errors += scoreboard.diff_buffer(1,eth_framebuffer);
			say_goodbye();


		endtask; // endtask


	endclass
