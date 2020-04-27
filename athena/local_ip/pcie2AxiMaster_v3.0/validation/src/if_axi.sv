
interface if_axi (input clk); 
   logic               awready;
   logic               awvalid;
   logic [23:0]        awid;    
   logic [31:0]        awaddr;  
   logic [7:0] 	       awlen;   
   logic [2:0] 	       awsize;  
   logic [1:0] 	       awburst; 
   logic [2:0] 	       awprot;  
   logic 	       wready;
   logic 	       wvalid;
   logic [31:0]        wdata;  
   logic [3:0] 	       wstrb;  
   logic 	       wlast ;
   logic 	       bvalid;
   logic 	       bready;
   logic [23:0]        bid;    
   logic [1:0] 	       bresp;  
   logic 	       arready;
   logic 	       arvalid;
   logic [23:0]        arid;    
   logic [31:0]        araddr;  
   logic [7:0] 	       arlen;   
   logic [2:0] 	       arsize;  
   logic [1:0] 	       arburst; 
   logic 	       rvalid;
   logic 	       rready;
   logic [23:0]        rid;    
   logic [1:0] 	       rresp;  
   logic 	       rlast;
   logic [31:0]        rdata; 

   
/* -----\/----- EXCLUDED -----\/-----
   task reset();
      @(posedge clk) begin
	 awvalid = 1'b0;
	 awid = 24'b0;
	 awaddr = 32'b0;
	 awlen = 8'b0;
	 awsize = 3'b0;
	 awburst = 2'b0;
	 awprot = 3'b0;
	 wready = 1'b0;
	 wvalid = 1'b0;
	 wdata = 32'b0;
	 wstrb = 1'b0;
	 wlast = 1'b0;
	 bvalid = 1'b0;
	 bready = 1'b0;
	 bid = 24'b0;
	 bresp = 2'b0;
	 arready = 1'b0;
	 arvalid = 1'b0;
	 arid = 24'b0;
	 araddr = 32'b0;
	 arlen = 8'b0;
	 arsize = 3'b0;
	 arburst = 2'b0;
	 rvalid = 1'b0;
	 rready = 1'b0;
	 $display ("@%g Applying reset", $time);
      end // task reset();
      #5;
 	 $display ("@%g Returning from reset", $time);
     
   endtask // reset
 -----/\----- EXCLUDED -----/\----- */
   
   task wait_n_cycles();

   endtask // reset

   modport master 
    (
/* -----\/----- EXCLUDED -----\/-----
     import reset,
     import wait_n_cycles,
 -----/\----- EXCLUDED -----/\----- */
     input  awready,
     output awvalid,
     output awid,
     output awaddr,
     output awlen,
     output awsize,
     output awburst,
     output awprot,
     input  wready,
     output wvalid,
     output wdata,
     output wstrb,
     output wlast,
     input  bvalid,
     output bready,
     input  bid,
     input  bresp,
     input  arready,
     output arvalid,
     output arid,
     output araddr,
     output arlen,
     output arsize,
     output arburst,
     input  rvalid,
     output rready,
     input  rid,
     input  rresp,
     input  rlast,
     input  rdata
     );
   
   
    modport slave 
   (
    output awready,
    input  awvalid,
    input  awid,
    input  awaddr,
    input  awlen,
    input  awsize,
    input  awburst,
    input  awprot,
    output wready,
    input  wvalid,
    input  wdata,
    input  wstrb,
    input  wlast,
    output bvalid,
    input  bready,
    output bid,
    output bresp,
    output arready,
    input  arvalid,
    input  arid,
    input  araddr,
    input  arlen,
    input  arsize,
    input  arburst,
    output rvalid,
    input  rready,
    output rid,
    output rresp,
    output rlast,
    output rdata
    );
   
      
endinterface : if_axi   


