
	/*
 * test0100
 * 
 * Category    : Test ToE double buffer mechanism
 * 
 * Description : Use one test list with the double buffer mechanism enabled
 *  
 * 
 */
	import core_pkg::*;
	import network_pkg::*;
	import gev_pkg::*;
	import driver_pkg::*;
	import scoreboard_pkg::*;
	import axiMaio_pkg::*;

	class Ctest0100 extends Ctest;
		static int MAX_PACKET_SIZE_IN_DW = 32;
		static int MAX_PACKET_COUNT      = 32; // Context list max size
		static int NUMBER_OF_PACKET_SENT = 2; // Context list max size
		static int currentPktID = 0;
		static int timeout = 100;

		Cdriver_axiMaio driver;
		Cethernet_frame eth0;
		Cscoreboard_mii scoreboard;
		CaxiMaio axiMaio;

		function new(Cdriver_axiMaio driver, Cscoreboard_mii scoreboard);
			super.new("test0100");
			this.driver = driver;
			this.scoreboard = scoreboard;
			this.axiMaio = new(driver,0);
		endfunction; // new

		task run();
			string message;


			static   shortint GEV_REQUEST_ID_MIN_VALUE = 16'hbbbb;
			static   shortint GEV_REQUEST_ID_MAX_VALUE = 16'hffff;
			static   int IRQ0_ID = 0;

			automatic 		int address = 0;

			automatic  int data = 0;
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
					// Reset the hardware
					driver.wait_n(100);
			        driver.reset();
			        driver.wait_n(100);
					
					// Create the toe list
					toe_list = new();

					gev_writereg_cmd[0] = new(flag, 0);
					gev_register = new(32'hdadadada, 32'hcacacaca);
					gev_writereg_cmd[0].register_list.push_back(gev_register);
					eth_frame[0] = gev_writereg_cmd[0].frame("Frame_gevmsg0",src_ip_addr, dest_ip_addr, src_port, dest_port,src_mac_addr,  dest_mac_addr);
					toe_list.add_frame(eth_frame[0]);

					gev_writereg_cmd[1] = new(flag, 0);
					gev_register = new(32'heaeaeaea, 32'hcacacaca);
					gev_writereg_cmd[1].register_list.push_back(gev_register);
					gev_register = new(32'hfafafafa, 32'hcacacaca);
					gev_writereg_cmd[1].register_list.push_back(gev_register);
					eth_frame[1] = gev_writereg_cmd[1].frame("Frame_gevmsg1",src_ip_addr, dest_ip_addr, src_port, dest_port,src_mac_addr,  dest_mac_addr);
					toe_list.add_frame(eth_frame[1]);


					this.axiMaio.add_toe_list(0,0,toe_list);


					////////////////////////////////////////////////////////
					//
					// Enable ToE controller
					//
					////////////////////////////////////////////////////////
					this.axiMaio.toeController[0].enable();



					////////////////////////////////////////////////////////
					//
					// Update the requestID range
					//
					////////////////////////////////////////////////////////
					this.axiMaio.toeController[0].set_requestID_range(GEV_REQUEST_ID_MIN_VALUE,GEV_REQUEST_ID_MAX_VALUE);


					////////////////////////////////////////////////////////
					//
					// Write the TOE_LIST[0] in the Message buffer[0] of the
					// axiMaio register file
					//
					////////////////////////////////////////////////////////
					//
					this.axiMaio.toeController[0].enable_double_buffer();
					this.axiMaio.toeController[0].write_toe_buffer();
					this.axiMaio.toeController[0].update_buffer();
					driver.wait_n(1000);
					



					////////////////////////////////////////////////////////
					//
					// Send a software trigger ToE on port 0
					//
					////////////////////////////////////////////////////////
					//this.axiMaio.send_software_trigger(0);


					// Wait for the 4 interrupts
					driver.wait_event(IRQ0_ID, 10000);
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
				gev_writereg_cmd[i].request_id = GEV_REQUEST_ID_MIN_VALUE + i;
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
