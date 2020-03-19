class Cscoreboard_hispi;
	int number_of_errors;

	//used to count the number of transactions
	int no_transactions;
	int dataBuffer [$];
	//creating virtual interface handle
	// -permit_unmatched_virtual_intf
	//virtual mii_interface  mii;


	//constructor
	//function new(virtual mii_interface.slave  mii);
	function new();
//		//getting the interface
//		this.mii = mii;
//
//		this.number_of_errors=0;
//		this.no_transactions=0;

	endfunction

	task init ();
//		dataBuffer={};
//		this.number_of_errors=0;
//		this.no_transactions=0;
	endtask

	task run ();
//		int dw_buffer;
//		int nibble_ptr;
//		int tx_data;
//		nibble_ptr = 0;
//		dw_buffer=0;
//		tx_data=0;
		
		// When we start the Scoreboard we first initialize it 
		this.init();
		
//		do begin
//
//			@(posedge mii.rx_clk) begin
//				if ( mii.rst_n == 0) begin
//					dw_buffer = 0;
//					nibble_ptr =0;
//					tx_data=0;
//					dataBuffer={};
//				end
//				else if (mii.tx_en == 1'b1) begin
//					tx_data = mii.tx_data;
//					dw_buffer = dw_buffer | (tx_data << nibble_ptr);
//					nibble_ptr = nibble_ptr + 4;
//					if (nibble_ptr == 32) begin
//						dataBuffer.push_back(dw_buffer);
//						nibble_ptr = 0;
//						dw_buffer = 0;
//						nibble_ptr =0;
//
//					end
//				end
//			end
//		end while (1);
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
