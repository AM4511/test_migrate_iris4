import core_pkg::*;
import network_pkg::*;
import gev_pkg::*;
import driver_pkg::*;
import scoreboard_pkg::*;
import axiMaio_pkg::*;


class Ctest0000 extends Ctest;
	static int timeout = 100;


	Cdriver_axiMaio driver;
	Cscoreboard_mii scoreboard;

	function new(Cdriver_axiMaio driver, Cscoreboard_mii scoreboard);
		super.new("Test0001");
		this.driver = driver;
		this.scoreboard = scoreboard;
	endfunction // new


	task writePacket(input int bufferOffset, int pktSize);
		//static int timeout = 100;
		automatic int pktData;
		automatic int pktDataPtr  = 4*(MAX_PACKET_COUNT + (currentPktID * MAX_PACKET_SIZE_IN_DW)); //Byte pointer
		automatic int hostContextPtr = bufferOffset + (currentPktID*4); // Byte pointer
		automatic int hostContextData = (pktSize<<12) | pktDataPtr;
		automatic int hostDataPtr    = bufferOffset + pktDataPtr; // Byte pointer

		$display("%t Write packet : 0x%h;",$time,currentPktID);

		driver.write(hostContextPtr, hostContextData, 'hff, timeout);

		// Write the dummy pktData
		for (int i=0; i<pktSize; i++)
		begin
			if (i==0)
				pktData = 'h005E0000;

			else if(i==1)
				pktData = 'h0000CEFA;
			else
				pktData = (currentPktID<<28) | i;

			driver.write(hostDataPtr+(4*i),pktData,'hff,timeout);
		end

		currentPktID++;

	endtask // writePacket


	//////////////////////////////////////////////////////////////
	//
	// Task  : endOfContext
	//
	// Description :
	//
	//////////////////////////////////////////////////////////////
	task endOfContext(input int bufferOffset);
		automatic  int offset = bufferOffset + currentPktID*4;
		static int  timeout = 100;
		automatic int endOfContextMarker = -1;

		$display("%t Write packet end of packet context",$time);


		// Write the context
		driver.write(offset,endOfContextMarker,'hff, timeout);
	endtask

	task run();
		static   int BASE_ADDR_ToE[4] = {'hD00,'hD80,'hE00,'hE80};
		static   int BASE_ADDR_ToE_MSG_LIST[4] = {'h1000,'h2000,'h3000,'h4000};
		static   int REG_OFFSET_REQUEST_ID_RANGE = 'h8;
		static   int REG_OFFSET_STATUS = 'hC;
		static   int REG_OFFSET_TRIGGER = 'h4;
		static   int REG_OFFSET_IRQ_EN = 'h10;
		static   int IRQ0_ID =0;
		static   int REG_OFFSET_IRQ_STATUS = 'h14;
		static   int REG_OFFSET_DEBUG = 'h18;
		static   int AXI_LITE_ETHERNET_SLAVE_OFFSET = 0;
		static   int ALE_GIE_OFFSET = 'h7F8;
		static   int ALE_RX_CTRL_OFFSET = 'h17FC;

		automatic  int address = 0;
		automatic  int data = 0;
		automatic  int ben = 'b1111111;
		automatic  int timeout = 100;
		automatic  int read_mask = 'hffffffff;
		automatic  int NUMBER_OF_LOOP = 256;
		automatic  int toe0_bufferOffset = 'h1000;


		driver.wait_n(100);
		driver.reset();
		driver.wait_n(100);

		fork

			////////////////////////////////////////////////////////////
			//
			// FORK Process 1
			//
			////////////////////////////////////////////////////////////
			begin
				////////////////////////////////////////////////////////
				//
				// Update the requestID range
				//
				////////////////////////////////////////////////////////
				address = BASE_ADDR_ToE[0] + REG_OFFSET_REQUEST_ID_RANGE;
				data =  'hffffaaaa;
				driver.write(address,data,'hff,timeout);

				// Clr the request ID counter (load the new range)
				address = BASE_ADDR_ToE[0] + REG_OFFSET_STATUS;
				data =  1 << 31;
				driver.write(address,data,'hff,timeout);

				////////////////////////////////////////////////////////
				//
				// Upload the single Message in the IP buffer list
				//
				////////////////////////////////////////////////////////
				//Write transaction
				writePacket(BASE_ADDR_ToE_MSG_LIST[0],16);
				//driver.wait_n(100);
				//writePacket(BASE_ADDR_ToE_MSG_LIST[0],16);
				endOfContext(BASE_ADDR_ToE_MSG_LIST[0]);
				driver.wait_n(1000);


				////////////////////////////////////////////////////////
				//
				// Enable ToEListSent  interrupt enable
				//
				////////////////////////////////////////////////////////
				address = BASE_ADDR_ToE[0] + REG_OFFSET_IRQ_EN;
				data =  4;
				driver.write(address,data,'hff,timeout);
				driver.wait_n(100);


				////////////////////////////////////////////////////////
				//
				// Send a software trigger ToE on port 0
				//
				////////////////////////////////////////////////////////
				address = BASE_ADDR_ToE[0] + REG_OFFSET_TRIGGER;
				data =  1;
				driver.write(address,data,'hff,timeout);

				// Wait for the interrupt
				driver.wait_event(IRQ0_ID, 10000);


				////////////////////////////////////////////////////////
				//
				// Clear ToListESent  interrupt flag
				//
				////////////////////////////////////////////////////////
				address = BASE_ADDR_ToE[0] + REG_OFFSET_IRQ_STATUS;
				data =  4;
				driver.write(address,data,'hff,timeout);
				driver.wait_n(1000);
			end // fork begin


			////////////////////////////////////////////////////////////
			//
			// FORK Process 2
			//
			////////////////////////////////////////////////////////////
			begin
				scoreboard.run();

			end

		join_any
		scoreboard.print_buffer();
		driver.teriminate();

	endtask; // endtask


endclass
