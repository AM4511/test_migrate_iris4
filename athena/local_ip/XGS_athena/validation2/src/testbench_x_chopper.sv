`timescale 1ns/1ps

/* -----\/----- EXCLUDED -----\/-----
import tests_pkg::*;
import scoreboard_pkg::*;
import axi_mm_pkg::*;
import driver_pkg::*;
import tests_pkg::*;
 -----/\----- EXCLUDED -----/\----- */

module testbench();
	parameter X_SIZE = 1024;
	parameter Y_SIZE = 4;

	typedef struct {
		bit [3:0] user;
		bit [63:0] data;
	} data_beat;



	//clock and reset signal declaration
	bit aclk;
	bit aclk_reset_n;
	bit aclk_tready;
	bit aclk_tvalid;
	bit aclk_tlast;

	bit [3:0]  aclk_tuser;
	bit [63:0] aclk_tdata;
	bit [15:0] aclk_x_size;
	bit [15:0] aclk_x_start;
	bit [15:0] aclk_x_stop;
	bit [3:0] aclk_x_scale;
	bit aclk_x_reverse;

	bit bclk;
	bit bclk_reset_n;
	bit bclk_tready;
	bit bclk_tvalid;
	bit bclk_tlast;
	bit [3:0] bclk_tuser;
	bit [63:0] bclk_tdata;

	// Clock and Reset generation
	//always #2.7 sys_clk          = ~sys_clk;
	always #5 aclk    = ~aclk;
	always #6.5 bclk  = ~bclk;
	assign bclk_tready = 1;

	x_chopper DUT(
			.aclk_x_start(aclk_x_start),
			.aclk_x_size(aclk_x_size),
			.aclk_x_scale(aclk_x_scale),
			.aclk_x_reverse(aclk_x_reverse),
			.aclk(aclk),
			.aclk_reset_n(aclk_reset_n),
			.aclk_tready(aclk_tready),
			.aclk_tvalid(aclk_tvalid),
			.aclk_tuser(aclk_tuser),
			.aclk_tlast(aclk_tlast),
			.aclk_tdata(aclk_tdata),
			.bclk(bclk),
			.bclk_reset_n(bclk_reset_n),
			.bclk_tready(bclk_tready),
			.bclk_tvalid(bclk_tvalid),
			.bclk_tuser(bclk_tuser),
			.bclk_tlast(bclk_tlast),
			.bclk_tdata(bclk_tdata)
		);


	initial begin
		int byte_id;
		data_beat db;
		data_beat axi_stream[$];

		aclk_reset_n = 1'b1;
		bclk_reset_n = 1'b1;



		////////////////////////////////////////////////////////
		// Create src data
		////////////////////////////////////////////////////////
		aclk_x_start = 12;
		aclk_x_size = 116;


		// Reset interface
		#100;
		@(posedge aclk);
		aclk_reset_n = 1'b0;
		@(posedge bclk);
		bclk_reset_n = 1'b0;
		#100;
		@(posedge aclk);
		aclk_reset_n = 1'b1;
		@(posedge bclk);
		bclk_reset_n = 1'b1;


		////////////////////////////////////////////////////////
		// Create src data
		////////////////////////////////////////////////////////
		for (int j=0;  j<Y_SIZE;  j++) begin
			db.user = 4'b0000;
			for (int i=0;  i<X_SIZE;  i++) begin
				////////////////////////////////////////////////
				// Determine sync
				////////////////////////////////////////////////
				if (i == 0) begin
					// start of frame
					if (j == 0) db.user[0] = 1'b1;
					// start of line
					else db.user[2] = 1'b1;
				end else
				if (i == X_SIZE-1) begin
					// End of frame
					if (j == Y_SIZE-1)
						db.user[1] = 1'b1;
					// End of line
					else
						db.user[3] = 1'b1;
				end

				////////////////////////////////////////////////
				// Data ramp
				////////////////////////////////////////////////
				byte_id = i % 8;
				db.data[byte_id*8 +: 8] = i;

				if (byte_id == 7) begin
					axi_stream.push_back(db);
					db.data = 0;
					db.user = 0;
				end
			end
		end


		#1000;

			////////////////////////////////////////////////////////
			// Send the stream
			////////////////////////////////////////////////////////
		while (axi_stream.size() > 0) begin
			@(posedge aclk);
			if (aclk_tready == 1'b1) begin
				db = axi_stream.pop_front();
				aclk_tvalid = 1'b1;
				aclk_tuser = db.user;
				aclk_tdata = db.data;
				if (db.user[1] == 1'b1 || db.user[3] == 1'b1) begin
					aclk_tlast = 1'b1;
					@(posedge aclk);
					aclk_tvalid = 1'b0;
					aclk_tlast = 1'b0;
					aclk_tuser = 0;
					aclk_tdata = 0;
					#1000;
				end
			end
		end

		//		@(posedge aclk);
		//        aclk_tvalid = 1'b0;
		//		aclk_tlast = 1'b0;
		//		aclk_tuser = 0;
		//		aclk_tdata = 0;


		// Reset interface
		#10000;
		$stop();

	end
endmodule
