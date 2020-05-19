class Cscoreboard #(int AXIS_DATA_WIDTH=64, int AXIS_USER_WIDTH=2);
	//	class memory_entry;
	//		longint pcie_address;
	//		int pcie_data;
	//		function new(longint address, int data);
	//			this.pcie_address = address;
	//			this.pcie_data = data;
	//		endfunction
	//	endclass


	int number_of_errors;

	//used to count the number of transactions
	int no_transactions;
	int dataBuffer [$];
	//creating virtual interface handle
	// -permit_unmatched_virtual_intf
	//virtual tlp_interface tlp;
	virtual axi_stream_interface #(.T_DATA_WIDTH(AXIS_DATA_WIDTH), .T_USER_WIDTH(AXIS_USER_WIDTH)) axis;


	//constructor
	//function new(virtual mii_interface.slave  mii);
	function new(virtual axi_stream_interface #(.T_DATA_WIDTH(AXIS_DATA_WIDTH), .T_USER_WIDTH(AXIS_USER_WIDTH)) axis);
		//		//getting the interface
		this.axis = axis;
		//
		this.number_of_errors=0;
		//		this.no_transactions=0;

	endfunction


	task init ();
		dataBuffer={};
		this.number_of_errors=0;
		this.no_transactions=0;
		this.axis.tready = 1'b1;
	endtask


	task run ();
		int transaction_active;
		int tlp_cntr;
		int data_array[longint];
		int address_array[$];
		bit [9:0] pcie_length;
		bit [1:0] pcie_at;
		bit [1:0] pcie_attr;
		bit [1:0] pcie_fmt;
		bit [4:0] pcie_type;
		int header_dw;
		int has_data;
		bit [3:0] first_dw_be;
		bit [3:0] last_dw_be;
		bit [7:0] pcie_tag;
		bit [15:0] requester_id;
		longint pcie_address;
		int tlp_id;
		//memory_entry entry;

		/////////////////////////////////////////////////////////////////////////
		// Initialization
		/////////////////////////////////////////////////////////////////////////
		this.init();
		transaction_active = 0;
		tlp_cntr = 0;
		tlp_id=0;

		/////////////////////////////////////////////////////////////////////////
		// Infinite loop
		/////////////////////////////////////////////////////////////////////////
		do begin
			@(posedge this.axis.clk);
			if (this.axis.tready == 1'b1 && this.axis.tready == 1'b1) begin

				/////////////////////////////////////////////////////////////////
				// DW0 : Header
				/////////////////////////////////////////////////////////////////
				if (tlp_cntr == 0) begin
					$display("New TLP : %d", tlp_id);

					pcie_type = this.axis.tdata[28:24];

					// PCIE format
					pcie_fmt = this.axis.tdata[31:29];
					if (pcie_fmt[0] == 1'b1) begin
						header_dw = 4;
					end	else begin
						header_dw = 3;
					end
					if (pcie_fmt[1] == 1'b1) begin
						has_data = 1;
					end	else begin
						has_data = 0;
					end
					/////////////////////////////////////////////////////////////
					// DW1 : Header
					/////////////////////////////////////////////////////////////
					first_dw_be = this.axis.tdata[3:0];
					last_dw_be = this.axis.tdata[7:4];
					pcie_tag = this.axis.tdata[15:8];
					requester_id = this.axis.tdata[31:16];
					tlp_cntr++;
				end

				/////////////////////////////////////////////////////////////////
				// DW3:DW2 : Header
				/////////////////////////////////////////////////////////////////
				else if (tlp_cntr == 1) begin
					pcie_address = this.axis.tdata[63:0];
					if (header_dw==3) begin
						pcie_address = this.axis.tdata[31:0];
						//entry = new(pcie_address, this.axis.tdata[63:32]);
						data_array[pcie_address] = this.axis.tdata[63:32];
						pcie_address = pcie_address + 4;
					end else if (header_dw==4) begin
						pcie_address = this.axis.tdata[63:0];
					end
					tlp_cntr++;
				end

				/////////////////////////////////////////////////////////////////
				// DW4 > : payload
				/////////////////////////////////////////////////////////////////
				else if (tlp_cntr > 1 && has_data > 0) begin
					//entry = new (pcie_address, this.axis.tdata[31:0]);
					//data_array.push_back(entry);
					data_array[pcie_address] = this.axis.tdata[31:0];
					pcie_address = pcie_address + 4;

					//entry = new (pcie_address, this.axis.tdata[63:32]);
					data_array[pcie_address] = this.axis.tdata[63:32];
					pcie_address = pcie_address + 4;
					tlp_cntr++;
				end


				/////////////////////////////////////////////////////////////////
				// Last Data beat of the transaction
				/////////////////////////////////////////////////////////////////
				if (this.axis.tlast == 1'b1) begin
					tlp_cntr = 0;
					tlp_id++;
					$display("TLP %d completed!", tlp_id);
					//int(data_array);
				end
			end
		end while (1);

	endtask


	function void print ();
		//		longint address;
		//		int data;
		//		memory_entry entry;
		//
		//		$display("PRINTING MEMORY ARRAY");
		//
		//		for (int i=0; i<data_array.size(); i++) begin
		//			entry = data_array[i];
		//			address = entry.pcie_address;
		//			data = entry.pcie_data;
		//			$display ("address = 0x%h; data = 0x%h", address, data);
		//		end
		//
		//		//		foreach () begin
		//		//			address = entry.pcie_address;
		//		//			//data = entry.data;
		//		//			$display ("address = 0x%h; data = 0x%h", entry.address, entry.data);
//		//		end
	endfunction

endclass
