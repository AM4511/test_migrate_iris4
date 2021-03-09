`timescale 1ns/1ps

/* -----\/----- EXCLUDED -----\/-----
import tests_pkg::*;
import scoreboard_pkg::*;
import axi_mm_pkg::*;
import driver_pkg::*;
import tests_pkg::*;
 -----/\----- EXCLUDED -----/\----- */

module testbench();
	parameter X_SIZE = 256;
	parameter Y_SIZE = 4;
	parameter X_ROI_START = 0;
	parameter X_ROI_SIZE = 256;
	parameter X_REVERSE = 0;

	parameter WATCHDOG_MAX_CNT = 1000;

	//	typedef struct {
	//		bit [3:0] user;
	//		bit [63:0] data;
	//	} data_beat;

	typedef struct {
		int row_id;
		bit [63:0] data[$];
	} data_row;



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
	int watchdog;
	int error;
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








		aclk_reset_n = 1'b1;
		bclk_reset_n = 1'b1;



		////////////////////////////////////////////////////////
		// Create src data
		////////////////////////////////////////////////////////
		aclk_x_reverse = X_REVERSE;
		aclk_x_start = X_ROI_START;
		aclk_x_size = X_ROI_SIZE;
		aclk_x_stop = aclk_x_start + aclk_x_size -1;

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

		fork
			begin
				int byte_id;
				int row_id;
				int i,j,k;
				bit [63:0] db;
				bit tlast;
				bit [3:0] user;
				int stream_size;
				bit [63:0] data_queue[$];
				data_row axi_src_stream[$];
				data_row curr_row;


				////////////////////////////////////////////////////////
				// Create src stream
				////////////////////////////////////////////////////////
				for (j=0;  j<Y_SIZE;  j++) begin
					curr_row.data = {};
					curr_row.row_id = j;

					for (i=0;  i<X_SIZE;  i++) begin
						////////////////////////////////////////////////
						// Data ramp
						////////////////////////////////////////////////
						byte_id = i % 8;
						if (i<8) begin
							//db[byte_id*8 +: 8] = j;
							db[byte_id*8 +: 8] = i;
						end else begin
							db[byte_id*8 +: 8] = i;
						end

						if (byte_id == 7) begin
							curr_row.data.push_back(db);
							db = 0;
						end
					end
					axi_src_stream.push_back(curr_row);
				end


				////////////////////////////////////////////////////////
				// Send the stream
				////////////////////////////////////////////////////////
				#1000;
				j=0;
				// Start of frame
				while (j < Y_SIZE) begin
					$display("#########################################################################");
					$display("# %%Sending row : %d",j);
					$display("#########################################################################");
					curr_row = axi_src_stream.pop_front();
					row_id = curr_row.row_id;
					data_queue = curr_row.data;
					stream_size = curr_row.data.size();
					i=0;
					#1000ns;
					while (i<stream_size) begin
						@(posedge aclk);
						if (aclk_tready == 1'b1) begin
							db = data_queue.pop_front();
							$display("%d Data : 0x%016h", row_id, db);

							// Determining stream sync
							user = 4'b0000;
							tlast = 1'b0;
							if (i == 0) begin
								if (j==0) user[0] = 1'b1; //SOF
								else user[2] = 1'b1; //SOL
							end else if (i == stream_size-1) begin
								tlast = 1'b1;
								if (j==Y_SIZE-1) user[1] = 1'b1; //EOF
								else user[3] = 1'b1; //EOL
							end
							aclk_tvalid = 1'b1;
							aclk_tuser = user;
							aclk_tdata = db;
							aclk_tlast = tlast;
							i++;

						end
					end
					// Deassert axi stream I/F
					@(posedge aclk);
					aclk_tvalid = 1'b0;
					aclk_tlast = 1'b0;
					aclk_tuser = 0;
					aclk_tdata = 0;
					j++;
				end

				#1000;
			end


			////////////////////////////////////////////////////////
			// Scoreboard : Store the received stream
			////////////////////////////////////////////////////////
			begin
				int i;
				int j;
				byte c;
				//data_row curr_row;
				//bit [63:0] db;
				bit [3:0] user;
				int byte_id;
				int row_size;

				int axi_received_stream_size;
				data_row axi_received_stream[$];
				data_row received_row;
				bit [63:0] received_row_data[$];
				bit [63:0] received_db;
				int received_row_id;
				int received_row_size;

				data_row axi_predicted_stream[$];
				data_row pred_row;
				bit [63:0] pred_row_data[$];
				bit [63:0] pred_db;
				int pred_row_id;
				int pred_row_size;

				int longest_row_size;

				///////////////////////////////////////////////////////
				// Capturing data
				////////////////////////////////////////////////////////
				watchdog = WATCHDOG_MAX_CNT;
				error =0;
				j = 0;

				while (1) begin

					@(posedge bclk);
					if (bclk_tvalid == 1'b1) begin
						user = bclk_tuser;
						received_db = bclk_tdata;
						received_row_data.push_back(received_db);
						if (bclk_tlast == 1'b1) begin
							received_row.data = received_row_data;
							received_row.row_id = j;
							axi_received_stream.push_back(received_row);
							j++;

							// At EOF we are done
							if (bclk_tuser[1] == 1'b1) begin
								break;
							end
						end

						// reset the watchdog
						watchdog = WATCHDOG_MAX_CNT;
					end


					assert (watchdog) else $fatal("Watchdog error");
					watchdog--;

				end

				#1000ns;

					///////////////////////////////////////////////////////
					// Create predicted stream
					////////////////////////////////////////////////////////
				if (aclk_x_reverse == 0) begin
					for (j=0;  j<Y_SIZE;  j++) begin
						byte_id = 0;
						for (i=aclk_x_start;  i<= aclk_x_stop;  i++) begin
							////////////////////////////////////////////////
							// Data ramp
							////////////////////////////////////////////////
							pred_db[byte_id*8 +: 8] = i;

							if (byte_id == 7) begin
								pred_row_data.push_back(pred_db);
								byte_id = 0;
								pred_db = 0;
							end else
								byte_id++;
						end
						pred_row.row_id = j;
						pred_row.data = pred_row_data;
						axi_predicted_stream.push_back(pred_row);
					end

				end else begin
					for (j=0;  j<Y_SIZE;  j++) begin
						byte_id = 7;
						for (i=aclk_x_start;  i<= aclk_x_stop;  i++) begin
							////////////////////////////////////////////////
							// Data ramp
							////////////////////////////////////////////////
							pred_db[byte_id*8 +: 8] = i;

							if (byte_id == 0) begin
								pred_row_data.push_front(pred_db);
								byte_id = 7;
								pred_db = 0;
							end else begin
								byte_id--;
							end
						end
						pred_row.row_id = j;
						pred_row.data = pred_row_data;
						axi_predicted_stream.push_back(pred_row);
					end

				end


				////////////////////////////////////////////////////////
				// Validate results
				////////////////////////////////////////////////////////
				$display("\n\n\n");
				$display("###########################################################################");
				$display("###########################################################################");
				$display("##########################   Validating results   #########################");
				$display("###########################################################################");
				$display("###########################################################################");

				assert (axi_received_stream.size() == axi_predicted_stream.size()) else
				begin
					$error("Validation : received row count : %d; predicted row count : %d", axi_received_stream.size(), axi_predicted_stream.size());
					error++;
				end

				axi_received_stream_size = axi_received_stream.size();
				for (j=0; j<axi_received_stream_size; j++) begin
					//Validate each row the stream
					received_row = axi_received_stream.pop_front();
					received_row_id = received_row.row_id;
					received_row_data = received_row.data;
					received_row_size = received_row_data.size();

					pred_row = axi_predicted_stream.pop_front();
					pred_row_id = pred_row.row_id;
					pred_row_data = pred_row.data;
					pred_row_size = pred_row_data.size();

					// Validate row_id
					assert (received_row_id == pred_row_id) else
					begin
						$error("Received row ID : %d; Predicted row ID : %d", received_row_id, pred_row_id);
						error++;
					end

					// Validate row size
					assert (received_row_size == pred_row_size) else
					begin
						$error("Received row size : %d; Predicted row size : %d", received_row_size, pred_row_size);
						error++;
					end

					// Validate each data beat
					$display("Received row[%0d]       Predicted row[%0d]", received_row_id, pred_row_id);
					longest_row_size =  (received_row_size >= pred_row_size) ? received_row_size : pred_row_size;
					for (i=0; i<longest_row_size; i++) begin
						c = " ";
						received_db= received_row_data.pop_front();
						pred_db = pred_row_data.pop_front();
						if (received_db != pred_db) begin
							c = "|";
							error++;
						end
						$display("0x%016h %c  0x%016h", received_db, c,pred_db);
					end

					$display("\n\n");

				end
			end
		join;
			$display("=====================================================================");
		$display("Total error : %-0d", error);

		#10000;
		$stop();
	end
endmodule
