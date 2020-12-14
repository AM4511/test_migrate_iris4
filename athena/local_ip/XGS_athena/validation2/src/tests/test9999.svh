/**********************************************************************
 * Name : Test2000
 * Target : XGS 12000 MONO
 * 
 * Description : Send a single frame
 *
 **********************************************************************/
import tests_pkg::*;
import driver_pkg::*;
import xgs_athena_pkg::*;
import fdkide_pkg::*;
import regfile_pack::*;



class Test9999 extends CTest;

	//parameter AXIS_DATA_WIDTH  = 64;
	//parameter AXIS_USER_WIDTH  = 4;

	Cdriver_axil  host;
	virtual axi_stream_interface tx_axis_if;


	function new(Cdriver_axil host, virtual axi_stream_interface tx_axis_if);
		super.new("Test9999", host, tx_axis_if);
		this.host       = host;
		this.tx_axis_if = tx_axis_if;
	endfunction

	task run();
		Cscoreboard  scoreboard;
		Cregfile_xgs_athena regfile;
		

		
        ////////////////////////////////////////////////////////////
		// Initialize the test
		////////////////////////////////////////////////////////////
		scoreboard     = new(tx_axis_if);
		regfile        = new(.name("regfile"));
		super.say_hello();   

		
		////////////////////////////////////////////////////////////
		// Initialize the test
		////////////////////////////////////////////////////////////
		fork
			string path;
			begin
				scoreboard.run();
			end  


			begin    
				int register_value; 
				int field_value; 
				Cregister curr_register;
				int curr_register_addr;
				string curr_register_path;
				int major_version;
				int minor_version;
				int hw_version;
				
				//-------------------------------------------------
				// Reset the testbench
				//-------------------------------------------------

				host.reset(20);
				#100us;

				//-------------------------------------------------
				// Read the version register
				//-------------------------------------------------
				curr_register = regfile.SYSTEM.VERSION;
				curr_register_addr = regfile.SYSTEM.VERSION.get_address();
				curr_register_path = regfile.SYSTEM.VERSION.get_path();
				
				host.reg_read(curr_register);
			    major_version = regfile.SYSTEM.VERSION.MAJOR.get();	
			    minor_version = regfile.SYSTEM.VERSION.MINOR.get();	
			    hw_version = regfile.SYSTEM.VERSION.HW.get();
			    
				$display("Register path : %s", curr_register_path);
				$display("Version formated value : 0x%8h", regfile.SYSTEM.VERSION.data);
				$display("Version formated value : %0d.%0d.%0d", major_version, minor_version, hw_version);
				
				//-------------------------------------------------
				// Read/Write/Read back to the scratch pad register
				//-------------------------------------------------
				curr_register = regfile.SYSTEM.SCRATCHPAD;
				curr_register_addr = regfile.SYSTEM.SCRATCHPAD.get_address();
				curr_register_path = regfile.SYSTEM.SCRATCHPAD.get_path();
				
				// First read
				host.reg_read(curr_register);
				field_value = regfile.SYSTEM.SCRATCHPAD.VALUE.get();	
			    
				$display("Register path : %s", curr_register_path);
				$display("Register addr : @0x%h", curr_register_addr);
				$display("Scratchpad field value : 0x%8h", field_value);
	
				// Write
				regfile.SYSTEM.SCRATCHPAD.VALUE.set('hcafefade);
				host.reg_write(curr_register);
				
				// First read
				host.reg_read(curr_register);
				register_value = regfile.SYSTEM.SCRATCHPAD.data;	
				field_value = regfile.SYSTEM.SCRATCHPAD.VALUE.get();	
			    
				$display("Scratchpad register value : 0x%8h", register_value);
				$display("Scratchpad field value : 0x%8h", field_value);
				
				#250us;				
				super.say_goodbye();  
			end

		join_any;	

	endtask
    
endclass
