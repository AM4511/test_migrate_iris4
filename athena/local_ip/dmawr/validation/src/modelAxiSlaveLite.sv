`timescale 1ns/1ps

//import maiopack::*;
//`include "axi_lite_interface.sv"


module modelAxiSlaveLite #(parameter DATA_WIDTH=32,ADDR_WIDTH=12,timeout=100)
   (
	axi_lite_interface axi_s
);

	parameter   NUMB_MEM_WORD = (2**ADDR_WIDTH)/4;
	typedef enum logic[2:0] {S_IDLE, S_WAIT_DATA, S_RESP} TYPE_STATE;
	TYPE_STATE state;

	static int 	axi_write_address;
	static int 	axi_write_data;
	static int 	axi_write_strb;
	static int   timeout_cntr;
	static int   write_status;

	static bit   CHECK_OVERWRITE = 1'b1;



	bit [NUMB_MEM_WORD-1:0] [DATA_WIDTH-1:0] mem;

	int 					    mem_hit[NUMB_MEM_WORD];

	function void  setCheckOverWrite();
		CHECK_OVERWRITE =1'b1;
	endfunction

	function void  unsetCheckOverWrite();
		CHECK_OVERWRITE =1'b0;
	endfunction

	task mem_write(input int byte_address,
		bit [DATA_WIDTH-1:0] 				 data,
		bit [(DATA_WIDTH/8)-1:0] 			 ben,
		inout bit [DATA_WIDTH-1:0] [NUMB_MEM_WORD-1:0] mem,
		inout int 					 mem_hit[NUMB_MEM_WORD]
	);
		begin
			automatic int status = 0;
			automatic int word_address = byte_address/(DATA_WIDTH/8);

			// Verify location overwrite
			if (CHECK_OVERWRITE == 1'b1) begin
				assert (mem_hit[word_address] == 0)
				else begin
					$error("AXI Write: @addr: 0x%h => Address overwrite (%d times)",word_address, mem_hit[word_address]);
					status = 1;
				end
			end


			$display("%t MEMWRITE: 0x%h",$time,word_address);

			mem[word_address] = data;
			mem_hit[word_address]++;
		end
	endtask


	function  bit [DATA_WIDTH-1:0] mem_read(int address);
		begin
			return mem[address];
		end
	endfunction


	task mem_clr();
		begin
			for (int i=0; i<NUMB_MEM_WORD; i++) begin
				mem[i] = 0;
				mem_hit[i]=0;
			end
		end
	endtask


	always_ff @(posedge axi_s.axi_clk or negedge axi_s.axi_reset_n) begin
		//asynchronous reset
		if (axi_s.axi_reset_n == 0) begin
			state <=S_IDLE;
			timeout_cntr = timeout;
			axi_s.axi_awready<= 0;
			axi_s.axi_arready<= 0;
			axi_s.axi_wready<= 0;
			axi_s.axi_bvalid<= 0;
			axi_s.axi_bresp<= 0;
			axi_s.axi_rvalid<= 0;
			axi_s.axi_rdata<= 0;
			axi_s.axi_rresp<= 0;
			mem_clr();

		end

		else begin
			case(state)

				//////////////////////////////////////////////////////////////////
				//
				// Parking state
				//
				//////////////////////////////////////////////////////////////////
				S_IDLE : begin
					timeout_cntr = timeout;
					axi_s.axi_awready<= 1;
					axi_s.axi_arready<= 1;
					axi_s.axi_wready<= 1;
					axi_s.axi_bvalid<= 0;
					axi_s.axi_bresp<= 0;
					axi_s.axi_rvalid<= 0;
					axi_s.axi_rdata<= 0;
					axi_s.axi_rresp<= 0;

					if (axi_s.axi_awvalid == 1) begin
						axi_s.axi_awready <= 1;
						axi_write_address = axi_s.axi_awaddr;

						if (axi_s.axi_wvalid == 1)  begin
							axi_s.axi_wready<= 1;
							axi_write_data = axi_s.axi_wdata;
							axi_write_strb = axi_s.axi_wstrb;
							mem_write(axi_write_address, axi_write_data, axi_write_strb,mem, mem_hit);
							state <=S_RESP;
						end

						else
							state <= S_WAIT_DATA;

					end
				end

				//////////////////////////////////////////////////////////////////
				//
				// Write transaction wait for data
				//
				//////////////////////////////////////////////////////////////////
				S_WAIT_DATA :
				begin
					if (axi_s.axi_wvalid == 1)  begin
						axi_s.axi_wready<= 1;
						axi_write_data = axi_s.axi_wdata;
						axi_write_strb = axi_s.axi_wstrb;
						mem_write(axi_write_address, axi_write_data, axi_write_strb,mem, mem_hit);
						state <=S_RESP;

					end
					else
						begin
							timeout_cntr--;
							assert (timeout_cntr > 0) else $fatal("AXI Write: Data acknowledge timeout");
						end
				end


				//////////////////////////////////////////////////////////////////
				//
				// Write transaction response
				//
				//////////////////////////////////////////////////////////////////
				S_RESP :
				begin
					axi_s.axi_awready <= 0;
					axi_s.axi_arready <= 0;
					axi_s.axi_wready  <= 0;
					if (axi_s.axi_bready == 1)  begin
						axi_s.axi_bvalid <= 1;
						axi_s.axi_bresp <= write_status;
						state <=S_IDLE;

					end

				end


			endcase
		end
	end // always_ff @ (posedge axi_s.axi_clk or negedge axi_s.axi_reset_n)



endmodule
