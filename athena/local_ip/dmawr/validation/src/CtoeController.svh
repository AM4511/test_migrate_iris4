
	/****************************************************************************
 * Ctoe_buffer.svh
 ****************************************************************************/

	/**
 * Class: Ctoe_buffer
 *
 * TODO: Add class documentation
 */
	class CtoeController;
		static   int REG_OFFSET_CTRL = 'h4;
		static   int REG_OFFSET_REQUEST_ID_RANGE = 'h10;
		static   int REG_OFFSET_REQUEST_ID = 'h14;
		static   int REG_OFFSET_EVENT_ENABLE_0 = 'h8;
		static   int REG_OFFSET_EVENT_ENABLE_1 = 'hc;

		static    int timeout = 100;

		int base_addr;
		int frame_buffer_address;

		int enabled;
		Ctoe_buffer toe_buffer;
		Cdriver_axiMaio driver;
		SEC_ToE registerfile;
		
		function new(Cdriver_axiMaio driver,SEC_ToE registerfile);
			this.driver = driver;
			this.toe_buffer = new();
			this.registerfile = registerfile;
		endfunction


		function void add_toe_list(int eventID, Ctoe_list toe_list);
			this.toe_buffer.add_toe_list(eventID, toe_list);
		endfunction

		task enable();
			int address;

			address = this.base_addr + REG_OFFSET_CTRL;
			this.driver.write(address,1,'hff,timeout);
		endtask

		task  set_requestID_range(shortint min_value, shortint max_value);
			int address;
			int data;

			address = this.base_addr + REG_OFFSET_REQUEST_ID_RANGE;
			data[15:0] =  int'(min_value);
			data[31:16] =  int'(max_value);
			this.driver.write(address,data,'hff,timeout);

			// Clr the request ID counter (load the new range)
			address = this.base_addr + REG_OFFSET_REQUEST_ID;
			data =  1 << 31;
			this.driver.write(address,data,'hff,timeout);

		endtask

//		task enable_software_trigger();
//			int address;
//			int data;
//			address = this.base_addr + REG_OFFSET_EVENT_ENABLE_0;
//			data =  1 << id;
//			driver.write(address ,data,'hff,timeout);
//		endtask

		task enable_src_trig(int src_id=0, int value=1);
			int inputAddr;
			int writeData;
			int writeMask;

			if (src_id <32) begin
				inputAddr = this.base_addr + REG_OFFSET_EVENT_ENABLE_0;
				writeMask = 1 <<  src_id;
				writeData = (value == 0) ? 0 : (1 <<  src_id);
				this.driver.read_modify_write(inputAddr,writeData,writeMask,this.timeout);
			end else if (src_id <64) begin
				inputAddr = this.base_addr + REG_OFFSET_EVENT_ENABLE_1;
				writeMask = 1 <<  (src_id-32);
				writeData = 1 <<   (value == 0) ? 0 : (1 <<  (src_id-32));
				this.driver.read_modify_write(inputAddr,writeData,writeMask,this.timeout);
			end

		endtask

		task  enable_double_buffer();
			int address;
			int data;
			int mask;
			address = this.base_addr + REG_OFFSET_CTRL;
			data =  1 << 6;
			mask =  1 << 6;
			driver.read_modify_write(address ,data,mask,timeout);
		endtask

		task  update_buffer();
			int address;
			int data;
			int mask;
			address = this.base_addr + REG_OFFSET_CTRL;
			data =  1 << 7;
			mask =  1 << 7;
			driver.read_modify_write(address ,data,mask,timeout);
		endtask

		task  write_toe_buffer();
			//this.driver.write_toe_buffer(this.id, toe_buffer);
			//	task  write_toe_buffer(input int toe_id, input Ctoe_buffer toe_buffer);
			int address;
			int data;
			int strb;
			int buffer_size;


			buffer_size = this.toe_buffer.get_max_size();

			for (int i=0; i< buffer_size; i++) begin
				address = this.frame_buffer_address + i*4;
				data = toe_buffer.data[i];
				strb = 32'hff;
				this.driver.write(address, data, strb, this.timeout);
			end

		endtask

	endclass
