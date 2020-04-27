/*
 * test0400
 * 
 * Category    : Test timer[0]
 * 
 * Description : NOT FUNCTIONNAL YET. WORK IN PROGRESS
 *  
 * 
 */
import core_pkg::*;
import network_pkg::*;
import gev_pkg::*;
import driver_pkg::*;
import scoreboard_pkg::*;
import axiMaio_pkg::*;

class Ctest0400 extends Ctest;
	static int timeout = 100;
	Cdriver_axiMaio driver;
	CaxiMaio axiMaio;
	
	function new(Cdriver_axiMaio driver, Cscoreboard_mii scoreboard);
		super.new("test0400");
		this.driver = driver;
		this.axiMaio = new(driver,0);
	endfunction // new

	task run();
		string message;
		longint address;

		int clockPeriod;
		int expectedClockPeriod = 80;

		////////////////////////////////////////////////////////////
		// FORK Process 1
		////////////////////////////////////////////////////////////
		// Reset the hardware
		driver.wait_n(100);
		driver.reset();
		driver.wait_n(100);
			        

		////////////////////////////////////////////////////////
		// Initialize the axiMAIO
		////////////////////////////////////////////////////////
		this.axiMaio.init();
		
		address = this.axiMaio.regfile.Timer[0].TimerClockPeriod.getAddress();
		this.driver.read(address, clockPeriod, timeout);
		if (expectedClockPeriod != clockPeriod) begin
			$sformat(message,"Expected clock period %d ; read clock period %d",expectedClockPeriod, clockPeriod);
			error(message);
		end
		driver.wait_n(10);

		say_goodbye();


	endtask; // endtask


	endclass
