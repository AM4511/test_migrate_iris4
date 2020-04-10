/****************************************************************************
 * Cdriver_maio.svh
 ****************************************************************************/

/**
 * Class: CaxiMaio
 *
 * TODO: Add class documentation
 */
import driver_pkg::*;

class CaxiMaio;
	static const int SOFTWARE_TRIG_ID[4] = {0,1,2,3};
	static const int INPUT_I0_ID[6] = {8,9,10,11,12,13};
	static const int TIMER_ID[16] = {16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31};
	int timeout;
	Cdriver_axiMaio driver;
	Cmaio_registerfile regfile;
	CtoeController toeController[4];

	static   int FRAME_BUFFER_SIZE = 'h1000; //Bytes
	static   int FRAME_BUFFER_BASE_ADDR = 'h1000; //Bytes
	static   int TRANSACTION_TIMEOUT= 100;
	static   shortint GEV_REQUEST_ID_MIN_VALUE = 16'hbbbb;
	static   shortint GEV_REQUEST_ID_MAX_VALUE = 16'hffff;
	static   int IRQ0_ID = 0;
	static   int AXI_LITE_ETHERNET_SLAVE_OFFSET = 0;
	static   int ALE_GIE_OFFSET = 'h7F8;
	static   int ALE_RX_CTRL_OFFSET = 'h17FC;
	static   int REG_OFFSET_LOG_BUFFER_CTRL = 'hF00;
	static   int REG_OFFSET_LOG_BUFFER_DATA =  'hF04;


	function new(Cdriver_axiMaio driver, int base_addr);
		this.driver = driver;
		this.regfile  = new(base_addr);
		this.timeout = TRANSACTION_TIMEOUT;
		for (int i=0; i<4; i++) begin
			this.toeController[i] = new(driver, this.regfile.ToE[i]);
		end
	endfunction


	function void add_toe_list(int controllerID, int eventID, Ctoe_list toe_list);
		this.toeController[controllerID].add_toe_list(eventID, toe_list);
	endfunction


	/////////////////////////////////////////////////
	// Initialize the axiMaio
	/////////////////////////////////////////////////
	task init();
		// Set the default GeV requestID range
		//		this.toeController[0].set_requestID_range(GEV_REQUEST_ID_MIN_VALUE,GEV_REQUEST_ID_MAX_VALUE);
		//		this.toeController[1].set_requestID_range(GEV_REQUEST_ID_MIN_VALUE,GEV_REQUEST_ID_MAX_VALUE);
		//		this.toeController[2].set_requestID_range(GEV_REQUEST_ID_MIN_VALUE,GEV_REQUEST_ID_MAX_VALUE);
		//		this.toeController[3].set_requestID_range(GEV_REQUEST_ID_MIN_VALUE,GEV_REQUEST_ID_MAX_VALUE);
	endtask


	task send_software_trigger(int id);
		int address;
		int data;

		//this.regfile.getNode("");
		// Enable Software trigger
		//this.toeController[id].enable_src_trig(id);

		address = 0;// this.base_addr + REG_OFFSET_SOFT_TRIGGER;
		data =  1 << id;
		driver.write(address ,data,'hff,timeout);
	endtask

	task enable_input_io(int input_id=0,int edge_detect=0 ,int int_en=0);
		int reg_addr;
		int writeData;
		int writeMask;
		int timeout_count;

		writeMask = 1 <<  input_id;

		/////////////////////////////////////////////////////////
		// Edge detection
		/////////////////////////////////////////////////////////
		// Any edge detection
		if (edge_detect > 1 ) begin
			// Set IO_ANYEDGE register
			reg_addr = 'h11c;
			writeData = 1 <<  input_id;
			this.driver.read_modify_write(reg_addr,writeData,writeMask,this.timeout);

		end if 	(edge_detect == 0) begin
			// Clear IO_ANYEDGE register
			reg_addr = 'h11c;
			writeData = 0;
			this.driver.read_modify_write(reg_addr,writeData,writeMask,this.timeout);

			// Set IO_POL register to rising edge
			reg_addr = 'h110;
			writeData = 0;
			this.driver.read_modify_write(reg_addr,writeData,writeMask,this.timeout);

		end if (edge_detect == 1) begin
			// Clear IO_ANYEDGE register
			reg_addr = 'h11c;
			writeData = 0;
			this.driver.read_modify_write(reg_addr,writeData,writeMask,this.timeout);

			// Set IO_POL register to falling edge
			reg_addr = 'h110;
			writeData = 1 << input_id;
			this.driver.read_modify_write(reg_addr,writeData,writeMask,this.timeout);
		end

		/////////////////////////////////////////////////////////
		// IO_INTMASKn @0x118
		// Note : Mask not : 0 = Int Enabled, 1 = Int disabled
		/////////////////////////////////////////////////////////
		reg_addr = 'h118;
		writeData = (int_en == 0) ? 0 : (1 <<  input_id);
		this.driver.read_modify_write(reg_addr,writeData,writeMask,this.timeout);
	endtask

	task set_output_pin(int output_id=0, int value=1);
		int reg_addr;
		int writeData;
		int writeMask;
		int timeout_count;

		writeMask = 1 <<  output_id;
		reg_addr = 'h188;
		writeData = (value  <<  output_id) & writeMask;
		this.driver.read_modify_write(reg_addr,writeData,writeMask,this.timeout);
	endtask

	task  set_requestID_range(shortint min_value, shortint max_value);
		int address;
		int data;

		// TODO: debug 
		address = 0;// TBD this.base_addr + REG_OFFSET_REQUEST_ID_RANGE;
		data[15:0] =  int'(min_value);
		data[31:16] =  int'(max_value);
		this.driver.write(address,data,'hff,timeout);

		// TODO: debug 
		// Clr the request ID counter (load the new range)
		address = 0; // this.base_addr + REG_OFFSET_REQUEST_ID;
		data =  1 << 31;
		this.driver.write(address,data,'hff,timeout);

	endtask

endclass


