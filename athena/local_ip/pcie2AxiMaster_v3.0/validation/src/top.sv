module top();
 timeunit 1ns;
   bit clk;
   bit reset_n;

   initial
     forever #5 clk <= ~clk;

   if_tlp t(clk); // tlp interface instantiation
   if_axi a(clk); // axi interface instantiation
    

   testbench TB
     (
      .clk(clk),
      .reset_n(reset_n),
      .tlp(t),
      .axi_s(a)
      );

   
   tlp_to_axi_master dut
     (
      .sys_clk(clk),     
      .sys_reset_n(reset_n), 
      .tlp_in_valid(t.tlp_in_valid),       
      .tlp_in_accept_data(t.tlp_in_accept_data), 
      .tlp_in_fmt_type(t.tlp_in_fmt_type),       
      .tlp_in_address(t.tlp_in_address),        
      .tlp_in_length_in_dw(t.tlp_in_length_in_dw),   
      .tlp_in_attr(t.tlp_in_attr),           
      .tlp_in_transaction_id(t.tlp_in_transaction_id), 
      .tlp_in_data(t.tlp_in_data),           
      .tlp_in_byte_en(t.tlp_in_byte_en),        
      .tlp_in_byte_count(t.tlp_in_byte_count),     
      .tlp_out_req_to_send(t.tlp_out_req_to_send), 
      .tlp_out_grant(t.tlp_out_grant),       
      .tlp_out_fmt_type(t.tlp_out_fmt_type),     
      .tlp_out_length_in_dw(t.tlp_out_length_in_dw), 
      .tlp_out_src_rdy_n(t.tlp_out_src_rdy_n), 
      .tlp_out_dst_rdy_n(t.tlp_out_dst_rdy_n), 
      .tlp_out_data(t.tlp_out_data),      
      .tlp_out_address(t.tlp_out_address),     
      .tlp_out_ldwbe_fdwbe(t.tlp_out_ldwbe_fdwbe), 
      .tlp_out_attr(t.tlp_out_attr),           
      .tlp_out_transaction_id(t.tlp_out_transaction_id), 
      .tlp_out_byte_count(t.tlp_out_byte_count),     
      .tlp_out_lower_address(t.tlp_out_lower_address),  
      .M_AXI_AWREADY(a.awready), 
      .M_AXI_AWVALID(a.awvalid), 
      .M_AXI_AWID(a.awid),    
      .M_AXI_AWADDR(a.awaddr),  
      .M_AXI_AWLEN(a.awlen),   
      .M_AXI_AWSIZE(a.awsize),  
      .M_AXI_AWBURST(a.awburst), 
      .M_AXI_AWPROT(a.awprot),  
      .M_AXI_WREADY(a.wready), 
      .M_AXI_WVALID(a.wvalid), 
      .M_AXI_WDATA(a.wdata),  
      .M_AXI_WSTRB(a.wstrb),  
      .M_AXI_WLAST(a.wlast),  
      .M_AXI_BVALID(a.bvalid), 
      .M_AXI_BREADY(a.bready), 
      .M_AXI_BID(a.bid),    
      .M_AXI_BRESP(a.bresp),  
      .M_AXI_ARREADY(a.arready), 
      .M_AXI_ARVALID(a.arvalid), 
      .M_AXI_ARID(a.arid),    
      .M_AXI_ARADDR(a.araddr),  
      .M_AXI_ARLEN(a.arlen),   
      .M_AXI_ARSIZE(a.arsize),  
      .M_AXI_ARBURST(a.arburst), 
      .M_AXI_RVALID(a.rvalid), 
      .M_AXI_RREADY(a.rready), 
      .M_AXI_RID(a.rid),    
      .M_AXI_RRESP(a.rresp),  
      .M_AXI_RLAST(a.rlast), 
      .M_AXI_RDATA(a.rdata) 
      );

endmodule

