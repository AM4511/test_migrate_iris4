/*
 * test0500
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

class Ctest0500 extends Ctest;
	Cdriver_axiMaio driver;
	CaxiMaio axiMaio;
	
	////////////////////////////////////////////////////////////
	// Class constructor
	////////////////////////////////////////////////////////////
	function new(Cdriver_axiMaio driver, Cscoreboard_mii scoreboard);
		super.new("test0500");
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
		int EXPECTED_INPUT_CONDITIONNING = 'h0;
	
		
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
		driver.wait_n(100);
		
		////////////////////////////////////////////////////////
		// Check for the InputConditionning[0]
		////////////////////////////////////////////////////////
		address = this.axiMaio.regfile.InputConditioning.InputConditioning[0].getAddress();
		$display("Reading Input Conditionning[0]");
		this.driver.read(address, readData, TRANSACTION_TIMEOUT);
		if (readData != EXPECTED_INPUT_CONDITIONNING) begin
			$sformat(message, "Expected read data 0x%x ; read data 0x%x", EXPECTED_INPUT_CONDITIONNING, readData);
			error(message);
		end
		
		this.driver.write(address, 'h2, 'hff, TRANSACTION_TIMEOUT);


		driver.set_output_io(0, 1);
		driver.set_output_io(0, 0);
		driver.wait_n(100);
		driver.set_output_io(0, 1);
		driver.set_output_io(0, 0);

		driver.wait_n(100);
		driver.pulse_output_io(0, 51);
		driver.wait_n(1000);
		driver.pulse_output_io(0, 5);

		////////////////////////////////////////////////////////
		// Test done, we quit
		////////////////////////////////////////////////////////
		driver.wait_n(1000);
		$display("Done...\n\n");
		say_goodbye();

	endtask;


	endclass
