class Cscoreboard_tlp;
	int number_of_errors;

	int dataBuffer [$];
	virtual tlp_interface tlp;


	//constructor
	function new(virtual tlp_interface tlp);
		this.tlp = tlp;
		this.number_of_errors=0;

	endfunction

	task init ();
		dataBuffer={};
		this.number_of_errors=0;
		#100
			//this.axi_strm.tready = 1'b1;
	endtask

	task run ();
		int id;
		string sync;
		typedef struct {
			logic [63:0] data;
			logic [1:0] sync;
		} stream_rec;
		
		stream_rec rec;
		stream_rec strm[$] = {};

		
		// When we start the Scoreboard we first initialize it
		this.init();

		id = 0;
		do begin

			@(posedge this.axi_strm.clk) begin
				if (this.axi_strm.tvalid == 1'b1) begin
					rec.sync[0] = this.axi_strm.tuser;
					rec.sync[1] = this.axi_strm.tlast;
					if (this.axi_strm.tlast == 1'b0 && this.axi_strm.tuser == 1'b1) begin
						sync = "SOF";
					end
					else if (this.axi_strm.tlast == 1'b1 && this.axi_strm.tuser == 1'b0) begin
						sync = "EOF";
					end
					else begin
						sync = "CONT";
					end

					rec.data = this.axi_strm.tdata;

					strm.push_back(rec);

					//$display("SCOREBOARD %s\t\t%d : 0x%h", sync, id, this.axi_strm.tdata);
					id++;
							
				end

				if (this.axi_strm.tlast == 1'b1) begin
					#1000;
						// Iterate through queue and access each class object
					foreach (strm[i])
						$display("SCOREBOARD %s\t\t%d : 0x%h", strm[i].sync, i, strm[i].data);

					$display("SIMULATION COMPLETED SUCCESSFULLY");
					$finish();
				end

			end
			
		end while (1);
	endtask


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
