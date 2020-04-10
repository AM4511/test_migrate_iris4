/*
 * test0000
 * 
 * Category    : Registerfile
 * 
 * Description : Test the register accesses in the Info section. 
 *
 */
import core_pkg::*;
import network_pkg::*;
import gev_pkg::*;
import driver_pkg::*;
import scoreboard_pkg::*;
import axiMaio_pkg::*;

class Ctest0000 extends Ctest;
	Cdriver_axiMaio driver;
	CaxiMaio axiMaio;
	
	////////////////////////////////////////////////////////////
	// Class constructor
	////////////////////////////////////////////////////////////
	function new(Cdriver_axiMaio driver, Cscoreboard_mii scoreboard);
		super.new("test0000");
		this.driver = driver;
		this.axiMaio = new(driver,0);
	endfunction // new

	
	////////////////////////////////////////////////////////////
	// Run command
	////////////////////////////////////////////////////////////
	task run();
		string message;
		longint address;
		int readData;

		int TRANSACTION_TIMEOUT = 100;
		int EXPECTED_MTX_TAG = 'h58544d;
		int EXPECTED_FID = 0;
		int EXPECTED_VERSION = 'h10500;
		int EXPECTED_CAPABILITY = 'h0;
		int EXPECTED_SCRATCHPAD_VALUE = 'h0;
		
		////////////////////////////////////////////////////////////
		// Reset hardware
		////////////////////////////////////////////////////////////
		driver.wait_n(100);
		driver.reset();
		driver.wait_n(100);


		////////////////////////////////////////////////////////
		// Initialize the axiMAIO
		////////////////////////////////////////////////////////
		this.axiMaio.init();
		
		
		////////////////////////////////////////////////////////
		// Check for the Matrox tag "MTX"
		////////////////////////////////////////////////////////
		address = this.axiMaio.regfile.Info.tag.getAddress();
		$display("Reading Matrox IP-Core Tag");
		this.driver.read(address, readData, TRANSACTION_TIMEOUT);
		if (readData != EXPECTED_MTX_TAG) begin
			$sformat(message, "Expected read data 0x%x ; read data 0x%x", EXPECTED_MTX_TAG, readData);
			error(message);
		end

		////////////////////////////////////////////////////////
        // Check for the Matrox IP-Core Function ID"
		////////////////////////////////////////////////////////
		address = this.axiMaio.regfile.Info.fid.getAddress();
		$display("Reading axiMaio IP-Core Function ID");
		this.driver.read(address, readData, TRANSACTION_TIMEOUT);
		if (readData != EXPECTED_FID) begin
			$sformat(message, "Expected read data 0x%x ; read data 0x%x", EXPECTED_FID, readData);
			error(message);
		end
		
		////////////////////////////////////////////////////////
		// Check for the Matrox IP-Core version
		////////////////////////////////////////////////////////
		address = this.axiMaio.regfile.Info.version.getAddress();
		$display("Reading axiMaio IP-Core registerfile version");
		this.driver.read(address, readData, TRANSACTION_TIMEOUT);
		if (readData != EXPECTED_VERSION) begin
			$sformat(message, "Expected read data 0x%x ; read data 0x%x", EXPECTED_FID, readData);
			error(message);
		end

		////////////////////////////////////////////////////////
		// Check for the Matrox IP-Core capability
		////////////////////////////////////////////////////////
		address = this.axiMaio.regfile.Info.capability.getAddress();
		$display("Reading axiMaio IP-Core capability register");
		this.driver.read(address, readData, TRANSACTION_TIMEOUT);
		if (readData != EXPECTED_CAPABILITY) begin
			$sformat(message, "Expected read data 0x%x ; read data 0x%x", EXPECTED_FID, readData);
			error(message);
		end

		////////////////////////////////////////////////////////
		// Check for the Matrox IP-Core scratchpad register
		////////////////////////////////////////////////////////
		address = this.axiMaio.regfile.Info.scratchpad.getAddress();
		$display("Reading axiMaio IP-Core scratchpad register");
		this.driver.read(address, readData, TRANSACTION_TIMEOUT);
		
		if (readData != EXPECTED_SCRATCHPAD_VALUE) begin
			$sformat(message, "Expected read data 0x%x ; read data 0x%x", EXPECTED_SCRATCHPAD_VALUE, readData);
			error(message);
		end

		// Writing back to the scratchpad
		$display("Writing to axiMaio IP-Core scratchpad register");
		EXPECTED_SCRATCHPAD_VALUE = 'hDEADBEEF;
		this.driver.write(address, EXPECTED_SCRATCHPAD_VALUE, 'hFF, TRANSACTION_TIMEOUT);

		// Reading back to the scratchpad
		$display("Reading axiMaio IP-Core scratchpad register");
		this.driver.read(address, readData, TRANSACTION_TIMEOUT);
		
		if (readData != EXPECTED_SCRATCHPAD_VALUE) begin
			$sformat(message, "Expected read data 0x%x ; read data 0x%x", EXPECTED_SCRATCHPAD_VALUE, readData);
			error(message);
		end

		driver.wait_n(10);
		
		////////////////////////////////////////////////////////
		// Test done, we quit
		////////////////////////////////////////////////////////
		$display("Done...\n\n");
		say_goodbye();

	endtask;


	endclass
