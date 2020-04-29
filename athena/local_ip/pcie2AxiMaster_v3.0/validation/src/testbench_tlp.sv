// Testbench.sv

module testbench(clk, reset_n, tlp, axi_s);

   input  logic  clk;
   output  logic reset_n = 1'b1;
   if_tlp.host   tlp;
   if_axi.slave  axi_s;
   
   
   task wait_n_cycles(int number_of_cycles);
      int cntr;
      cntr = 0;
      while(cntr<number_of_cycles)
	begin
	   @(posedge clk) begin
	      cntr++;
	   end
	end
   endtask
   

   task reset(int number_of_cycles);
      $display ("@%g Asseerting reset_n low", $time);
      reset_n = 1'b0;
      tlp.tlp_in_valid = 1'b0; 
      tlp.tlp_in_fmt_type = 7'b0; 
      tlp.tlp_in_address = 32'b0; 
      tlp.tlp_in_length_in_dw = 11'b0; 
      tlp.tlp_in_attr = 2'b0; 
      tlp.tlp_in_transaction_id = 24'b0; 
      tlp.tlp_in_data = 32'b0; 
      tlp.tlp_in_byte_en = 4'b0; 
      tlp.tlp_in_byte_count = 13'b0; 
      tlp.tlp_out_grant = 1'b0;
      tlp.tlp_out_dst_rdy_n = 1'b0;
      wait_n_cycles(number_of_cycles);
      $display ("@%g de-asseerting reset_n ", $time);
      reset_n = 1'b1;
   endtask


   task send_tlp_write(transaction_id, byte_count, int start_address, int data[]);
      int i;
      int dataCount;
      logic [6:0] fmt_type;
      logic [1:0] attributes;
      
      fmt_type   = 7'b1000000;
      attributes = 2'b00;
      dataCount  = data.size();

      i=0;
      
      while (i < dataCount) begin
	 @(posedge clk) begin
	      tlp.tlp_in_valid = 1;
	      tlp.tlp_in_fmt_type = fmt_type;
	      tlp.tlp_in_attr = attributes;
	      tlp.tlp_in_transaction_id = transaction_id;
	      tlp.tlp_in_address = start_address;
	      tlp.tlp_in_length_in_dw = dataCount;
	      tlp.tlp_in_data = data[i];
	      tlp.tlp_in_byte_en = 15;
	      tlp.tlp_in_byte_count = byte_count;
	    if (tlp.tlp_in_accept_data == 1'b1) begin
	       i = i + 1; //Non blocking assignment
	    end
	 end

      end 

      
      @(posedge clk) begin
	 tlp.tlp_in_valid <= 0;
      end
      
   endtask // send_tlp_write

   task init_axi_s();
      axi_s.awready <= 1;
      axi_s.wready <= 1;
   endtask
   
   initial begin
      wait_n_cycles(10);
      reset(10);
      init_axi_s();
      wait_n_cycles(100);
      send_tlp_write(0,0,0, {10,20,30,40});
      wait_n_cycles(100);
   end
   
endmodule
