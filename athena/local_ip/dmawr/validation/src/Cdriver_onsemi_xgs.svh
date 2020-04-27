
/****************************************************************************
 * Cdriver.svh
 ****************************************************************************/

/**
 * Class: Cdriver_axil
 *
 * TODO: Add class documentation
 */
`timescale 1ns/1ps

import core_pkg::Cdriver;
import core_pkg::Ctest;
import message_pkg::*;
import image_pkg::*;

class Cdriver_onsemi_xgs #(int NUMB_LANE=6) extends Cdriver;
	parameter PIXEL_WIDTH = 12;
	parameter OUTPUT_MUX_RATIO = 4;
	parameter TOTAL_LANE_COUNT = NUMB_LANE*OUTPUT_MUX_RATIO;
	parameter TOTAL_BAND_COUNT = TOTAL_LANE_COUNT/2;
	
	typedef reg [0:PIXEL_WIDTH-1] WORD_T;

	WORD_T all_one = {PIXEL_WIDTH{1'b1}};
	WORD_T all_zero = {PIXEL_WIDTH{1'b0}};

	protected virtual hispi_interface #(NUMB_LANE) hispi_if;
	Csensor_msg_channel msgChannel;
	real refclk_period;
	int pixel_size;
	int number_of_lane;
	WORD_T lane_buffer_array[TOTAL_LANE_COUNT][$];
	WORD_T output_lane_buffer_array[NUMB_LANE][$];

	int add_filler_code;
	int add_crc_code;
	//constructor
	function new(virtual hispi_interface #(NUMB_LANE)  hispi_if);
		//getting the interface
		super.new(1000,0);
		this.hispi_if = hispi_if;
		this.msgChannel = new();
		this.number_of_lane=1;
		this.pixel_size=PIXEL_WIDTH;
		this.refclk_period=2.5;
		this.add_filler_code=1;
		this.add_crc_code=0;
	endfunction

	// Start the driver
	task run();
		fork
			// Fork the command message parser
			parse_cmd();

			// Fork the serdes pll process
			serdes_pll();
		join_any
	endtask

	// Emulate the SERDES pll process
	task serdes_pll();
		for (int i=0;  i < 2;  i++) begin
			hispi_if.hclk_n[i] <= 1'b1;
			hispi_if.hclk_p[i] <= 1'b0;
		end
		
		while (1) begin
			@(posedge hispi_if.refclk,negedge hispi_if.refclk) begin
				for (int i=0;  i < 2;  i++) begin
					hispi_if.hclk_p[i] <=  hispi_if.refclk;
					hispi_if.hclk_n[i] <= ~hispi_if.refclk;
				end
			end
		end
	endtask

	// 
	task parse_cmd();
		Cmessage cmd_msg;
		
		CmsgInit init_msg;
		CmsgStop stop_msg;
		CmsgWait wait_msg;
		CmsgReset reset_msg;
		CmsgSendFrame send_frame_msg;
		int msg_id;
		
		//Command interpreter/dispatcher
		while (1) begin
			msgChannel.cmd_mbx.get(cmd_msg);
			msg_id = cmd_msg.id;
			
			//Init command message
			if ($cast(init_msg,cmd_msg)) begin
				this.init(init_msg.current_test);
			end
			//Wait State command message
			else if ($cast(wait_msg,cmd_msg)) begin
				this.wait_n(wait_msg.tick);
			end
			// Reset command message
			else if ($cast(reset_msg,cmd_msg))begin
				this.reset(reset_msg.tick);
			end
			else if ($cast(send_frame_msg,cmd_msg))begin
				this.send_frame(send_frame_msg.image);
			end
			// Stop command message
			else if ($cast(stop_msg,cmd_msg))begin
				if (stop_msg.tick > 0) begin
					this.wait_n(stop_msg.tick);
				end
				$display("Cdriver_onsemi_xgs => received stop message");
				break;
			end
		end
		
	endtask



	// Implement the init virtual function required by the parent
	task init(input Ctest current_test);
		super.init(current_test);
		this.reset();
	endtask

	
	//////////////////////////////////////////////////////////////
	//
	// Task  : throw_error
	//
	// Description : Set interface signals to a known value
	//
	//////////////////////////////////////////////////////////////
	function void throw_error(string message);
		$error(message);
		if (this.current_test != null) begin
			this.current_test.status.errors++;
		end
	endfunction

	
	//////////////////////////////////////////////////////////////
	//
	// Task  : mReset
	//
	// Description : Set interface signals to a known value
	//
	//////////////////////////////////////////////////////////////
	task reset(int cycles = 10);
		for (int j=0; j < number_of_lane; j++) begin
			hispi_if.data_p[j]  <= 1'b0;
			hispi_if.data_n[j]  <= 1'b1;
		end
		this.wait_n(cycles);
	endtask

	
	//////////////////////////////////////////////////////////////
	//
	// Task  : wait_n
	//
	// Description : Insert wait state for n clock cycles
	//
	//////////////////////////////////////////////////////////////
	task wait_n (int cycles);
		repeat(cycles) @(posedge hispi_if.refclk);
	endtask


	//////////////////////////////////////////////////////////////
	//
	// Task  : send_frame
	//
	// Description : Send an image of 1 frame
	//
	//////////////////////////////////////////////////////////////
	task send_frame(Cimage image);
		// Buff the image
		
		WORD_T current_lane_buffer[$];
		this.fill_stream_buffer(image);

		fork
	    begin
			for (int i = 0; i < NUMB_LANE; i++) begin
				fork
					automatic int lane_id =i;
					begin
						current_lane_buffer = this.output_lane_buffer_array[lane_id];
						stream_data(lane_id, current_lane_buffer);
					end
				join_none
			end
		end
		wait fork;
		join
	endtask

	
	//////////////////////////////////////////////////////////////
	//
	// Task  : stream_data
	//
	// Description : Stream data of lane lane_id on the hispi 
	//               interface
	//
	//////////////////////////////////////////////////////////////
	task stream_data(int lane_id, WORD_T lane_buffer[$]);
		int clock_id;
		string msg;
		$sformat(msg,"Lane[%d] : ", lane_id);
		$display("Phy: %d", lane_id);
		clock_id = (lane_id % 2 == 0) ? 0:1;
		while (lane_buffer.size() > 0) begin
			WORD_T data = lane_buffer.pop_front();
			$sformat(msg,"%s 0x%x", msg, data);
			for (int bit_index=0; bit_index<PIXEL_WIDTH; bit_index+=2) begin
				@(posedge hispi_if.hclk_p[clock_id]) begin
					hispi_if.data_p[lane_id] <= data[bit_index];
					hispi_if.data_n[lane_id] <= ~data[bit_index];
				end
				@(negedge hispi_if.hclk_p[clock_id]) begin
					hispi_if.data_p[lane_id] <= data[bit_index+1];
					hispi_if.data_n[lane_id] <= ~data[bit_index+1];
				end

			end
			
		end
		$display(msg);
	endtask

	
	function void fill_stream_buffer(Cimage image);
		for (int rowID=0; rowID<image.line_count; rowID++) begin
			Cpixel current_row[] = image.data[rowID];
			segment_row(current_row, rowID);
			print_buffers();
			
			
			// Beginning of line markers
			if (rowID==0) begin
				addSOF();
			end else begin
				addSOL();
			end
			
			// Filler code
			if (add_filler_code) begin
				addFLR();
			end
				
			// Pixels
			mux_lanes_in_stream_buffer_array();
			
			// End of line markers
			if (rowID == image.line_count-1) begin
				addEOF();
			end else begin
				addEOL();
			end
		end
		
	endfunction
	

	function void addSOF();
		WORD_T sync = all_zero;
		sync[0:4] = {1'b1,1'b1,1'b0,1'b0,1'b0};
		addSYNC(sync);
	endfunction
	
	function void addSOL();
		WORD_T sync = all_zero;
		sync[0:4] =  {1'b1,1'b0,1'b0,1'b0,1'b0};
		addSYNC(sync);
	endfunction
	
	function void addSOV();
		WORD_T sync = all_zero;
		sync[0:4] =  {1'b1,1'b0,1'b0,1'b1,1'b0};
		addSYNC(sync);
	endfunction

	function void addEOF();
		WORD_T sync = all_zero;
		sync[0:4] =  {1'b1,1'b1,1'b1,1'b0,1'b0};
		addSYNC(sync);
	endfunction

	function void addEOL();
		WORD_T sync = all_zero;
		sync[0:4] =  {1'b1,1'b0,1'b1,1'b0,1'b0};
		addSYNC(sync);
	endfunction

	function void addFLR();
		WORD_T flr = all_zero;
		flr[PIXEL_WIDTH-1] = 1'b1;
		for (int i=0; i<NUMB_LANE; i++) begin
			this.output_lane_buffer_array[i].push_back(flr);
		end
	endfunction

	function void addSYNC(WORD_T sync);
		for (int i=0; i<NUMB_LANE; i++) begin
			this.output_lane_buffer_array[i].push_back(all_one);
			this.output_lane_buffer_array[i].push_back(all_zero);
			this.output_lane_buffer_array[i].push_back(all_zero);
			this.output_lane_buffer_array[i].push_back(sync);
		end
	endfunction

	function void  mux_lanes_in_stream_buffer_array();
		WORD_T pixel_data;
		int internal_lane_id;
		int buffer_size=lane_buffer_array[0].size();
		
		for (int output_lane_id=0; output_lane_id<NUMB_LANE; output_lane_id+=2) begin
			//Clear the queue
			for (int i=0; i<buffer_size; i++) begin
	
				for (int j=0; j<OUTPUT_MUX_RATIO; j++) begin
					///////////////////////////////////////////
					// Top sensor lanes (we mux even lanes)
					///////////////////////////////////////////
					internal_lane_id = (output_lane_id*OUTPUT_MUX_RATIO)+(j*2);
					//pixel_data = lane_buffer_array[internal_lane_id][i];
					pixel_data = lane_buffer_array[internal_lane_id].pop_front();
					this.output_lane_buffer_array[output_lane_id].push_back(pixel_data);
					
					
					///////////////////////////////////////////
					// Bottom sensor lanes (we mux odd lanes)
					///////////////////////////////////////////
					internal_lane_id = (output_lane_id*OUTPUT_MUX_RATIO)+(j*2)+1;
					//pixel_data = lane_buffer_array[internal_lane_id][i];
					pixel_data = lane_buffer_array[internal_lane_id].pop_front();
					this.output_lane_buffer_array[output_lane_id+1].push_back(pixel_data);
				end
			end

		end
	endfunction

	function void  segment_row(Cpixel current_row[$], int row_number);
		WORD_T data_odd_pixel;
		WORD_T data_even_pixel;
		int col = 0;
		int lane_id =0;
		Cpixel padding_pixel;	
		//Determine if line number is even
		int is_odd_row = row_number % 2;
		int row_size = current_row.size();
		int band_width = row_size/TOTAL_BAND_COUNT;
			
		// Pad the row if required (must be a multiple of the number of lanes)
		while (row_size%TOTAL_LANE_COUNT != 0) begin
			padding_pixel= new(.numb_component(1), .component_size(12));
			current_row.push_back(padding_pixel);
			row_size = current_row.size();
		end
			

		// Assign data to lanes
		for (int pixID=0; pixID<row_size; pixID+=2) begin
			data_even_pixel = current_row[pixID].component[0];
			data_odd_pixel = current_row[pixID+1].component[0];
			
			if (is_odd_row) begin
				lane_buffer_array[lane_id].push_back(data_even_pixel);
				lane_buffer_array[lane_id+1].push_back(data_odd_pixel);
			end	else begin
				lane_buffer_array[lane_id].push_back(data_odd_pixel);
				lane_buffer_array[lane_id+1].push_back(data_even_pixel);	
			end

			if ((pixID+2) % band_width==0) begin
				lane_id+=2;
			end


			// Store data in the lane buffer
		end
	endfunction	
	
	function void  print_buffers();		
		for (int i=0; i<TOTAL_LANE_COUNT; i++) begin
			print_lane(lane_buffer_array[i],i);
		end
	endfunction	
		
	function void  print_lane(WORD_T lane[$],int lane_id);
		string msg;
		WORD_T data;
		int lane_size = lane.size();

		$sformat(msg,"Lane[%d] => ", lane_id);

		for (int i=0; i<lane_size; i++) begin
			data = lane[i];
			$sformat(msg,"%s, 0x%x", msg, data);
		end
		$display(msg);

	endfunction	

endclass
