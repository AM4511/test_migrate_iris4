/****************************************************************************
 * Ctoe_buffer.svh
 ****************************************************************************/

/**
 * Class: Ctoe_buffer
 *
 * TODO: Add class documentation
 */
class Ctoe_buffer;
	int data[1024];
	int data_ptr;
	function new();
		this.data_ptr = 64;
		//Clear the list map at the beginning of the buffer
		for (int i=0; i<63; i++) begin
			this.data[i] = 0;
		end
	endfunction


	function void add_toe_list (int event_id, Ctoe_list list);
		if (event_id > 63) begin
			$error("Bad event id");
		end else if (data[event_id] != 0)begin
			$error("Overwriting event id");
		end else if ((this.data_ptr + list.data.size()) > 1023) begin
			$error("Buffer overflow");
		end else begin

			// Build the ToE list
			list.buildlist();

			// Store the ToE list pointer in the List map.
			// To simplify the framework, we assumes ethernet
			// frame of 128 bytes max.
			this.data_ptr = 64*4 + (event_id * 128);
			this.data[event_id] = data_ptr;

			// Copy the list in the buffer object
			for (int i=0; i < list.data.size(); i++) begin
				this.data[(this.data_ptr/4)+i] = list.data[i];
			end
		end
	endfunction

	// Return the buffer size
	function int get_max_size();
		int last_active_event = 0;
		int last_list_offset = 0;
		for (int i=0; i<63; i++) begin
			if (this.data[i] > 0) begin
				last_active_event = i;
			end
		end
		if (this.data[last_active_event] == 0) begin
			return 0;
		end
		else begin
			last_list_offset = this.data[last_active_event] + (128/4);
			return  last_list_offset;
		end
	endfunction

	function void print();
		for (int i=0; i<this.data_ptr/4; i++) begin
			$display("Address : 0x%x; Data : 0x%x",4*i,  this.data[i]);
		end
	endfunction

endclass
