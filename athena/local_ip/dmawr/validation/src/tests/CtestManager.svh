/*
 * CtestManager
 * 
 * Description : Send 4 ToE on Port 0 triggered by Soft Trigger [3:0].
 *               each event uses a different list of frame. Each list 
 *               contains only one frame.
 * 
 */
	import core_pkg::*;
	import network_pkg::*;
	import gev_pkg::*;
	import driver_pkg::*;
	import scoreboard_pkg::*;
	import axiMaio_pkg::*;

	class CtestManager extends Ctest;
		static int TEST0000_EN = 0;

//		static int TEST0001_EN = 1;
//		static int TEST0002_EN = 0;
//		static int TEST0003_EN = 0;
//		static int TEST0004_EN = 0;
//		static int TEST0005_EN = 0;
//		static int TEST0006_EN = 0;
//		static int TEST0010_EN = 0;
//		static int TEST0011_EN = 0;
//
//		// Test double buffering
		static int TEST0100_EN = 0;
		static int TEST0101_EN = 0;
		static int TEST0110_EN = 0;
		static int TEST0200_EN = 0;
		static int TEST0300_EN = 0;
		static int TEST0400_EN = 0;
		static int TEST0500_EN = 1;

		string statusList[$];
		Cdriver_axiMaio driver;
		Cethernet_frame eth0;
		Cscoreboard_mii scoreboard;
		int total_error;
		int total_warning;

		function new(Cdriver_axiMaio driver, Cscoreboard_mii scoreboard);
			super.new("TestManager");
			this.driver = driver;
			this.scoreboard = scoreboard;
			this.total_error = 0;
			this.total_warning = 0;
		endfunction; // new

		function string status_to_str(Ctest test);
			string status;
			$sformat(status,"%s  %d %d      %s",test.name, test.status.errors, test.status.warnings, (test.status.errors) ? "FAILED":"passed");
			return status;
		endfunction; // new

		task run();
			string status;
			if (TEST0000_EN != 0) begin
				Ctest0000 test;
				test = new(driver,scoreboard);
				test.run();
				statusList.push_back(status_to_str(test));
			end
//			if (TEST0001_EN != 0) begin
//				Ctest0001 test;
//				test = new(driver,scoreboard);
//				test.run();
//				statusList.push_back(status_to_str(test));
//			end
//			if (TEST0002_EN != 0) begin
//				Ctest0002 test;
//				test = new(driver,scoreboard);
//				test.run();
//				statusList.push_back(status_to_str(test));
//			end
//			if (TEST0003_EN != 0) begin
//				Ctest0003 test;
//				test = new(driver,scoreboard);
//				test.run();
//				statusList.push_back(status_to_str(test));
//			end
//			if (TEST0004_EN != 0) begin
//				Ctest0004 test;
//				test = new(driver,scoreboard);
//				test.run();
//				statusList.push_back(status_to_str(test));
//			end
//			if (TEST0005_EN != 0) begin
//				Ctest0005 test;
//				test = new(driver,scoreboard);
//				test.run();
//				statusList.push_back(status_to_str(test));
//			end
//			if (TEST0006_EN != 0) begin
//				Ctest0006 test;
//				test = new(driver,scoreboard);
//				test.run();
//				statusList.push_back(status_to_str(test));
//			end
//			if (TEST0010_EN != 0) begin
//				Ctest0010 test;
//				test = new(driver,scoreboard);
//				test.run();
//				statusList.push_back(status_to_str(test));
//			end
//			if (TEST0011_EN != 0) begin
//				Ctest0011 test;
//				test = new(driver,scoreboard);
//				test.run();
//				statusList.push_back(status_to_str(test));
//			end
			if (TEST0100_EN != 0) begin
				Ctest0100 test;
				test = new(driver,scoreboard);
				test.run();
				statusList.push_back(status_to_str(test));
			end
//			if (TEST0101_EN != 0) begin
//				Ctest0101 test;
//				test = new(driver,scoreboard);
//				test.run();
//				statusList.push_back(status_to_str(test));
//
//			end
			if (TEST0110_EN != 0) begin
				Ctest0110 test;
				test = new(driver,scoreboard);
				test.run();
				statusList.push_back(status_to_str(test));
			end

			if (TEST0200_EN != 0) begin
				Ctest0200 test;
				test = new(driver,scoreboard);
				test.run();
				statusList.push_back(status_to_str(test));
			end
			if (TEST0300_EN != 0) begin
				Ctest0300 test;
				test = new(driver,scoreboard);
				test.run();
				statusList.push_back(status_to_str(test));
			end
			if (TEST0400_EN != 0) begin
				Ctest0400 test;
				test = new(driver,scoreboard);
				test.run();
				statusList.push_back(status_to_str(test));
			end
			if (TEST0500_EN != 0) begin
				Ctest0500 test;
				test = new(driver,scoreboard);
				test.run();
				statusList.push_back(status_to_str(test));
			end

			// Print the test list status
			$display("======================================================================");
			$display("== Global summary");
			$display("======================================================================");
			$display("Test             Errors     Warnings   Status");

			foreach(statusList[i]) begin
				$display("%s",statusList[i]);
			end
		endtask;


	endclass
