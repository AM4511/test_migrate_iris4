
interface if_tlp (input clk); 
   logic        tlp_in_valid;
   logic        tlp_in_accept_data;
   logic [6:0] 	tlp_in_fmt_type;
   logic [31:0] tlp_in_address;
   logic [10:0] tlp_in_length_in_dw;
   logic [1:0] 	tlp_in_attr;
   logic [23:0] tlp_in_transaction_id;
   logic [31:0] tlp_in_data;
   logic [3:0] 	tlp_in_byte_en;
   logic [12:0] tlp_in_byte_count;
   logic        tlp_out_req_to_send;
   logic        tlp_out_grant;
   logic [6:0] 	tlp_out_fmt_type;
   logic [9:0] 	tlp_out_length_in_dw;
   logic        tlp_out_src_rdy_n;
   logic        tlp_out_dst_rdy_n;
   logic [31:0] tlp_out_data;
   logic [63:2] tlp_out_address;
   logic [7:0] 	tlp_out_ldwbe_fdwbe;
   logic [1:0] 	tlp_out_attr;
   logic [23:0] tlp_out_transaction_id;
   logic [12:0] tlp_out_byte_count;
   logic [6:0] 	tlp_out_lower_address;


   clocking clk_if @(posedge clk); // clocking block for testbench
      default input #2ns output #2ns;
   endclocking

   
   modport endpoint 
   (
    clocking clk_if,
    output tlp_in_accept_data,
    input  tlp_in_valid, 
    input  tlp_in_fmt_type, 
    input  tlp_in_address, 
    input  tlp_in_length_in_dw, 
    input  tlp_in_attr, 
    input  tlp_in_transaction_id, 
    input  tlp_in_data, 
    input  tlp_in_byte_en, 
    input  tlp_in_byte_count, 
    output tlp_out_req_to_send, 
    input  tlp_out_grant,
    output tlp_out_fmt_type, 
    output tlp_out_length_in_dw, 
    output tlp_out_src_rdy_n, 
    input  tlp_out_dst_rdy_n,
    output tlp_out_data, 
    output tlp_out_address, 
    output tlp_out_ldwbe_fdwbe, 
    output tlp_out_attr, 
    output tlp_out_transaction_id, 
    output tlp_out_byte_count, 
    output tlp_out_lower_address 
    );
   
    modport host 
   (
    clocking clk_if,
    input  tlp_in_accept_data,
    output tlp_in_valid, 
    output tlp_in_fmt_type, 
    output tlp_in_address, 
    output tlp_in_length_in_dw, 
    output tlp_in_attr, 
    output tlp_in_transaction_id, 
    output tlp_in_data, 
    output tlp_in_byte_en, 
    output tlp_in_byte_count, 
    input  tlp_out_req_to_send, 
    output tlp_out_grant,
    input  tlp_out_fmt_type, 
    input  tlp_out_length_in_dw, 
    input  tlp_out_src_rdy_n, 
    output tlp_out_dst_rdy_n,
    input  tlp_out_data, 
    input  tlp_out_address, 
    input  tlp_out_ldwbe_fdwbe, 
    input  tlp_out_attr, 
    input  tlp_out_transaction_id, 
    input  tlp_out_byte_count, 
    input  tlp_out_lower_address 
    );
   
      
endinterface : if_tlp   


