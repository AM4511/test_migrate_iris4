class Cscoreboard #(int AXIS_DATA_WIDTH=64, int AXIS_USER_WIDTH=2);
	int number_of_errors;

	//used to count the number of transactions
	int no_transactions;
	int dataBuffer [$];
	//creating virtual interface handle
	// -permit_unmatched_virtual_intf
	virtual tlp_interface tlp;


	//constructor
	//function new(virtual mii_interface.slave  mii);
	function new( virtual tlp_interface tlp);
		//		//getting the interface
		this.tlp = tlp;
		//
		this.number_of_errors=0;
		//		this.no_transactions=0;

	endfunction


	task init ();
		dataBuffer={};
		this.number_of_errors=0;
		this.no_transactions=0;
		this.tlp.dst_rdy_n <= 1'b1;
		this.tlp.grant <= 1'b0;
		//#100;
		//this.axi_strm.tready = 1'b1;
	endtask


	task run ();
		int transaction_active;

		int tlp_fmt_type;
		int tlp_length_in_dw;
		longint  tlp_address;
		int tlp_ldwbe_fdwbe;
		int tlp_attr;
		int tlp_transaction_id;
		int tlp_byte_count;
		int tlp_lower_address;
		int dw_count;
		longint data_array[$];


		/////////////////////////////////////////////////////////////////////////
		// Initialization
		/////////////////////////////////////////////////////////////////////////
		this.init();
		transaction_active = 0;


		/////////////////////////////////////////////////////////////////////////
		// Infinite loop
		/////////////////////////////////////////////////////////////////////////
		do begin
			@(posedge this.tlp.clk);
				/////////////////////////////////////////////////////////////////
				// Arbiter
				/////////////////////////////////////////////////////////////////
			if (this.tlp.req_to_send == 1'b1 && this.tlp.grant == 1'b0 && transaction_active == 0) begin
				this.tlp.grant <= 1'b1;


				/////////////////////////////////////////////////////////////////
				// Transaction parameters
				/////////////////////////////////////////////////////////////////
				transaction_active = 1;
				tlp_fmt_type = this.tlp.fmt_type;
				tlp_length_in_dw = this.tlp.length_in_dw;
				tlp_address = this.tlp.address & 2'b00;
				tlp_ldwbe_fdwbe = this.tlp.ldwbe_fdwbe;
				tlp_attr = this.tlp.attr;
				tlp_transaction_id = this.tlp.transaction_id;
				tlp_byte_count = this.tlp.byte_count;
				tlp_lower_address = this.tlp.lower_address;


			end else if (transaction_active == 1) begin
				this.tlp.grant <= 1'b0;

				if (transaction_active == 1 && this.tlp.src_rdy_n == 1'b0) begin
					data_array.push_back(this.tlp.data);
				end
			end

			/////////////////////////////////////////////////////////////////
			// Transaction handshake
			/////////////////////////////////////////////////////////////////
			if (transaction_active == 1) begin
				this.tlp.dst_rdy_n <= 1'b0;
			end
		end while (1);

	endtask

	//	task run ();
	//		int id;
	//		string sync;
	//		typedef struct {
	//			logic [63:0] data;
	//			logic [1:0]  sync;
	//		} stream_rec;
	//
	//		stream_rec rec;
	//		stream_rec strm[$] = {};
	//
	//
	//		// When we start the Scoreboard we first initialize it
	//		this.init();
	//
	//		id = 0;
	//		do begin
	//
	//			@(posedge this.axi_strm.clk) begin
	//				if (this.axi_strm.tvalid == 1'b1) begin
	//					rec.sync[0] = this.axi_strm.tuser;
	//					rec.sync[1] = this.axi_strm.tlast;
	//					if (this.axi_strm.tlast == 1'b0 && this.axi_strm.tuser == 1'b1) begin
	//						sync = "SOF";
	//					end
	//					else if (this.axi_strm.tlast == 1'b1 && this.axi_strm.tuser == 1'b0) begin
	//						sync = "EOF";
	//					end
	//					else begin
	//						sync = "CONT";
	//					end
	//
	//					rec.data = this.axi_strm.tdata;
	//
	//					strm.push_back(rec);
	//
	//					//$display("SCOREBOARD %s\t\t%d : 0x%h", sync, id, this.axi_strm.tdata);
	//					id++;
	//
	//				end
	//
	//				if (this.axi_strm.tlast == 1'b1) begin
	//					#1000;
	//						// Iterate through queue and access each class object
	//					foreach (strm[i])
	//						$display("SCOREBOARD %s\t\t%d : 0x%h", strm[i].sync, i, strm[i].data);
	//
	//					$display("SIMULATION COMPLETED SUCCESSFULLY");
	//					$finish();
	//				end
	//
	//			end
	//
	//
	//			//				if ( mii.rst_n == 0) begin
	//			//					dw_buffer = 0;
	//			//					nibble_ptr =0;
	//			//					tx_data=0;
	//			//					dataBuffer={};
	//			//				end
	//			//				else if (mii.tx_en == 1'b1) begin
	//			//					tx_data = mii.tx_data;
	//			//					dw_buffer = dw_buffer | (tx_data << nibble_ptr);
	//			//					nibble_ptr = nibble_ptr + 4;
	//			//					if (nibble_ptr == 32) begin
	//			//						dataBuffer.push_back(dw_buffer);
	//			//						nibble_ptr = 0;
	//			//						dw_buffer = 0;
	//			//						nibble_ptr =0;
	//			//
	//			//					end
	//			//				end
	//		end while (1);
	//	endtask


	/*******************************************************
	 *
	 *******************************************************/
	//	function int diff_buffer(int displayWireShark = 1, int ref_buffer[$]);
	//		int error;
	//		int buffer_size;
	//		int ref_buffer_size;
	//		int size_diff;
	//		byte status_char;
	//		longint qw_ref_buffer;
	//		longint qw_data_buffer;
	//		string str_ref_buffer;
	//		string str_data_buffer;
	//
	//		buffer_size = dataBuffer.size();
	//		ref_buffer_size = ref_buffer.size();
	//
	//		/*
	//	 * Test the buffer size
	//	 */
	//		assert (buffer_size == ref_buffer_size) else
	//		begin
	//			$error("compare_buffer: received buffer size: %d; reference buffer size: %d", buffer_size, ref_buffer_size);
	//		end
	//
	//
	//		/***********************************************
	//	 * Test each data entry from the buffer
	//	 ***********************************************/
	//		$display("Offset       Rcvd buff            Ref buff");
	//		error = 0;
	//		// TODO: Compare the CRC value
	//		for (int i=0; i < buffer_size; i+=2) begin
	//			status_char = " ";
	//
	//			qw_ref_buffer[31:0] = longint'(ref_buffer[i]);
	//			qw_data_buffer[31:0] = longint'(dataBuffer[i]);
	//
	//			if (i<buffer_size-1) begin
	//				qw_ref_buffer[63:32] = longint'(ref_buffer[i+1]);
	//				qw_data_buffer[63:32] = longint'(dataBuffer[i+1]);
	//			end
	//			else begin
	//				qw_ref_buffer[63:32] = 0;
	//				qw_data_buffer[63:32] = 0;
	//			end
	//
	//
	//
	//
	//			if (qw_ref_buffer != qw_data_buffer) begin
	//				status_char = "|";
	//				// We do not validate the CRC in the check.
	//				if (i<buffer_size-1) begin
	//					error++;
	//				end
	//
	//			end
	//			if (displayWireShark > 0) begin
	//				str_ref_buffer = "";
	//				str_data_buffer = "";
	//
	//				//
	//				for (int i=0; i<8; i++) begin
	//					$sformat(str_ref_buffer,"%s %2h",str_ref_buffer, byte'(qw_ref_buffer>>(8*i) & 8'hff));
	//					$sformat(str_data_buffer,"%s %2h",str_data_buffer, byte'(qw_data_buffer>>(8*i) & 8'hff));
	//				end
	//				$display("0x%x : %s %c %s", (4*i), str_data_buffer,status_char, str_ref_buffer);
	//
	//			end
	//			else begin
	//				$display("0x%x : 0x%x %c 0x%x", (4*i), qw_data_buffer,status_char, qw_ref_buffer);
	//			end
	//		end
	//		return error;
	//	endfunction
	//
	//
	//	function void print_buffer();
	//		int buffsize;
	//		buffsize = dataBuffer.size();
	//		for (int i=0; i<buffsize; i++) begin
	//			$display("0x%x",dataBuffer[i]);
	//		end
	//	endfunction
	//

endclass
