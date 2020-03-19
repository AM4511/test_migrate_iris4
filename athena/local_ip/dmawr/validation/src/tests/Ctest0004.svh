/*
 * test0004
 * 
 * Description : Send 4 ToE on Port 0 triggered by Soft Trigger [3:0].
 *               Validate the request ID returned by the log buffer
 * 
 */
import core_pkg::*;
import network_pkg::*;
import gev_pkg::*;
import driver_pkg::*;
import scoreboard_pkg::*;
import axiMaio_pkg::*;

class Ctest0004 extends Ctest;
	static int MAX_PACKET_SIZE_IN_DW = 32;
	static int MAX_PACKET_COUNT      = 32; // Context list max size
	static int NUMBER_OF_PACKET_SENT = 4; // Context list max size
	static int currentPktID = 0;
	static int timeout = 100;

	Cdriver_axiMaio driver;
	Cethernet_frame eth0;
	Cscoreboard_mii scoreboard;

	function new(Cdriver_axiMaio driver, Cscoreboard_mii scoreboard);
		super.new("Test0004");
		this.driver = driver;
		this.scoreboard = scoreboard;
	endfunction; // new

	task run();
		string message;

		static   int BASE_ADDR_ToE[4] = {'hD00,'hD80,'hE00,'hE80};
		static   int BASE_ADDR_ToE_MSG_LIST[4] = {'h1000,'h2000,'h3000,'h4000};
		static   int REG_OFFSET_CTRL = 'h4;
		static   int REG_OFFSET_ENABLE_0 = 'h8;
		static   int REG_OFFSET_ENABLE_1 = 'hC;
		static   int REG_OFFSET_REQUEST_ID_RANGE = 'h10;
		static   int REG_OFFSET_REQUEST_ID = 'h14;
		static   int REG_OFFSET_IRQEN = 'h18;
		static   int IRQ0_ID = 0;
		static   int REG_OFFSET_IRQ_STATUS = 'h14;
		static   int REG_OFFSET_DEBUG = 'h18;
		static   int AXI_LITE_ETHERNET_SLAVE_OFFSET = 0;
		static   int ALE_GIE_OFFSET = 'h7F8;
		static   int ALE_RX_CTRL_OFFSET = 'h17FC;
		static   int REG_OFFSET_LOG_BUFFER_CTRL = 'hF00;
		static   int REG_OFFSET_LOG_BUFFER_DATA =  'hF04;


		static   shortint GEV_REQUEST_ID_MIN_VALUE = 16'h0800;
		static   shortint GEV_REQUEST_ID_MAX_VALUE = 16'hffff;
		automatic 		int address = 0;

		automatic  int data = 0;
		automatic  int read_data = 0;
		automatic  int timeout = 100;
		automatic  int read_mask = 'hffffffff;
		automatic  int NUMBER_OF_LOOP = 256;
		automatic  int toe0_bufferOffset = 'h1000;

		Cudp udp_packet;
		Cethernet_frame eth_frame;
		Cgev_writereg_cmd writereg_cmd_0;
		Cgev_register gev_register;
		Ctoe_buffer toe_buffer;
		Ctoe_list toe_list;
		stream_t gev_stream;
		stream_t udp_stream;
		stream_t eth_stream;
		stream32_t eth_stream32;
		stream32_t eth_framebuffer;

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


		driver.wait_n(100);
		driver.reset();
		driver.wait_n(100);

		eth0= new("noname", 0, 0);
		crc_result= eth0.get_crc32(crc_in);


		fork

			////////////////////////////////////////////////////////////
			//
			// FORK Process 1
			//
			////////////////////////////////////////////////////////////
			begin
				int TOE_CONTROLLER_ID = 0;
				int usedw;

				toe_buffer = new();
				toe_list = new();

				writereg_cmd_0 = new(flag, 0);
				gev_register = new(32'h40224, 32'h1);
				writereg_cmd_0.register_list.push_back(gev_register);

				toe_list.add_message(writereg_cmd_0);
				toe_list.src_mac_addr=src_mac_addr;
				toe_list.dest_mac_addr=dest_mac_addr;

				toe_list.src_ip_addr=src_ip_addr;
				toe_list.dest_ip_addr=dest_ip_addr;
				toe_list.src_port=src_port;
				toe_list.dest_port=dest_port;

				toe_buffer.add_toe_list(0, toe_list);

				////////////////////////////////////////////////////////
				//
				// Enable ToE controller
				//
				////////////////////////////////////////////////////////
				address = BASE_ADDR_ToE[0]+ REG_OFFSET_CTRL;
				data  =  1;
				driver.write(address,data,'hff,timeout);


				////////////////////////////////////////////////////////
				//
				// Update the requestID range
				//
				////////////////////////////////////////////////////////
				address = BASE_ADDR_ToE[0] + REG_OFFSET_REQUEST_ID_RANGE;
				data[15:0] =  int'(GEV_REQUEST_ID_MIN_VALUE);
				data[31:16] =  int'(GEV_REQUEST_ID_MAX_VALUE);
				driver.write(address,data,'hff,timeout);

				// Clr the request ID counter (load the new range)
				address = BASE_ADDR_ToE[0] + REG_OFFSET_REQUEST_ID;
				data =  1 << 31;
				driver.write(address,data,'hff,timeout);


				////////////////////////////////////////////////////////
				//
				// Write the TOE_LIST[0] in the Message buffer[0] of the
				// axiMaio register file
				//
				////////////////////////////////////////////////////////
				//  task  write_toe_buffer(input int toe_id, input Ctoe_buffer toe_buffer);

				driver.write_toe_buffer(TOE_CONTROLLER_ID, toe_buffer);
				driver.wait_n(1000);



				//Validate the 4 Soft trigger on controller 0

				for (int j = 0; j < NUMBER_OF_PACKET_SENT; j++) begin
					////////////////////////////////////////////////////////
					//
					// Send a software trigger ToE on port 0
					//
					////////////////////////////////////////////////////////

					// Enable Software trigger [j]
					address = K_ToE_0_EventEnable_0_ADDR;
					data =  1 << j;
					driver.write(address ,data,'hff,timeout);

					address = K_Runtime_Soft_ADDR;
					data =  1 << j;
					driver.write(address,data,'hff,timeout);


					// Wait for the interrupt
					driver.wait_event(IRQ0_ID, 10000);


					////////////////////////////////////////////////////////
					//
					// Read
					//
					////////////////////////////////////////////////////////
					address = REG_OFFSET_LOG_BUFFER_CTRL;
					driver.read(address,read_data,timeout);
					//driver.wait_n(100);
					usedw = (read_data>>16) & 'h7ff;

					if (usedw > 0 ) begin
						byte trigger_id;
						byte module_id;
						int expected_request_id = (GEV_REQUEST_ID_MIN_VALUE + j);

						// Pop data from the fifo
						data = 2;
						driver.write(address,data,'hff,timeout);

						// Read the pop data
						address = REG_OFFSET_LOG_BUFFER_DATA;
						driver.read(address,read_data,timeout);

						// Interpret the log info
						request_id = read_data & 'hffff;
						trigger_id = read_data >> 16 & 'hff;
						module_id  = read_data >> 30 & 'hff;
						
						// Validate the request ID
						if (request_id != expected_request_id) begin
							$sformat(message,"Expected GEV request ID 0x%h; read value: 0x%h",expected_request_id, request_id);
							super.error(message);

						end else begin

							$display("LOG BUFFER MODULE ID      : 0x%h", module_id);
						end
						
						$display("LOG BUFFER SRC TRIGGER ID : 0x%h", trigger_id);
						$display("LOG BUFFER GEV REQUEST ID : 0x%h", request_id);

					end


					////////////////////////////////////////////////////////
					//
					// Clear ToListESent  interrupt flag
					//
					////////////////////////////////////////////////////////
					address = BASE_ADDR_ToE[0] + REG_OFFSET_IRQ_STATUS;
					data =  4;
					driver.write(address,data,'hff,timeout);
					driver.wait_n(1000);


				end
			end // fork begin


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
			writereg_cmd_0.request_id = GEV_REQUEST_ID_MIN_VALUE + i;
			gev_stream = writereg_cmd_0.serialize();
			udp_packet = new(src_ip_addr, dest_ip_addr, src_port, dest_port);
			udp_packet.set_payload(gev_stream);
			udp_stream = udp_packet.serialize();

			// Wrap the message datagram in an Ethernet Frame
			eth_frame = new("frame0", dest_mac_addr, src_mac_addr);
			eth_frame.set_payload(udp_stream);
			eth_stream = eth_frame.serialize();

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
