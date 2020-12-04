
`ifndef _axi_stream_interface_
	`define _axi_lite_interface_


	interface axi_stream_interface ();
		// Define parameters
		parameter T_DATA_WIDTH = 64;
		parameter T_USER_WIDTH = 4;
        
        logic aclk;
		logic areset_n;
		logic tready;
		logic tvalid;
		logic [T_DATA_WIDTH-1:0]     tdata;
		logic [(T_DATA_WIDTH/8)-1:0] tstrb;
		logic                        tlast;
		logic  [T_USER_WIDTH-1:0]    tuser;

   
    	//For inter packet Back pressure
    	reg        tx_axis_done;
		reg        tready_packet_delai_cfg = 1;  // 0=Static, 1=random
		reg [15:0] tready_packet_delai     = 0;  // InterPacket Back Pressure : 0 = tready statique a 1,   1 = tready a 0 durant un cycle apres le tlast ...
		reg [15:0] tready_packet_delai_db  = 0;  
		reg        tready_packet_cntr_en;
		reg [15:0] tready_packet_cntr;
		bit [31:0] tready_packet_random; 
		bit [31:0] tready_packet_random_min=1; 
		bit [31:0] tready_packet_random_max=15;      


		//////////////////////////////////////////////////////////////
		//
		// Port mode  : master
		//
		// Description : 
		//
		//////////////////////////////////////////////////////////////
		modport master (
				input  aclk,
				input  areset_n,
				input  tready,
				output tvalid,
				output tdata,
				output tstrb,
				output tlast,
				output tuser
			);


		//////////////////////////////////////////////////////////////
		//
		// Port mode  : slave
		//
		// Description : 
		//
		//////////////////////////////////////////////////////////////
		modport slave (
			    input  aclk,
				input  areset_n,
				output tready,
				input  tvalid,
				input  tdata,
				input  tstrb,
				input  tlast,
				input  tuser
			);


	    always @(posedge aclk) tready         <= 1'b1 ;
		

		///////////////////////////////////////////////
		//
		// Back pressure to AXI tready
		//
		/////////////////////////////////////////////// 
		// For in-packet Back pressure (on est assure que le PCI va rentrer le TLP sans wait PG054):
    	//   If the core transmit AXI4-Stream interface accepts the start of a TLP by asserting
    	//   s_axis_tx_tready, it is guaranteed to accept the complete TLP with a size up to the
    	//   value contained in the Max_Payload_Size field of the PCI Express Device Capability Register
    	//   (offset 04H)

		always @(posedge aclk)
			if (areset_n==0) begin
				tready                 <= 1'b1 ;
	
				tready_packet_cntr_en  <= 0;
				tready_packet_cntr     <= 16'b0;

    	        tx_axis_done           <= 1;
	
			end else if (tvalid==1 && tx_axis_done==1) begin  //first data of burst of 16x Qwords
				tready                 <= 1'b1 ;
	
				if (tready_packet_delai_cfg==0) begin
				  tready_packet_delai_db = tready_packet_delai;
				end else begin
				  tready_packet_random   = $urandom_range(tready_packet_random_max, tready_packet_random_min);				
				  tready_packet_delai_db = tready_packet_random;
				end

				tready_packet_cntr_en  <= 0;
				tready_packet_cntr     <= 16'b0;

    	        tx_axis_done           <= 0;
	
			end else if (tvalid==1'b1 && tlast==1'b1 && tready_packet_delai_db==0) begin
				tready                 <= 1'b1 ;
	
				tready_packet_cntr_en  <= 0;
				tready_packet_cntr     <= 16'b0;

    	        tx_axis_done           <= 1;

			end else if (tvalid==1'b1 && tlast==1'b1) begin
				tready                <= 1'b0 ;
	
				tready_packet_cntr_en  <= 1;
				tready_packet_cntr     <= 16'b0;

    	        tx_axis_done           <= 1;


				//------------------------  
				// inter packet delay  
				//------------------------
			end else if (tready_packet_cntr_en==1 && tready_packet_cntr!= (tready_packet_delai_db-1))  begin    
			
				tready                 <= 1'b0 ;
	
				tready_packet_cntr_en  <= 1;
				tready_packet_cntr     <= tready_packet_cntr + 16'd1;

    	        tx_axis_done           <= tx_axis_done;

			end else if (tready_packet_cntr_en==1 && tready_packet_cntr== (tready_packet_delai_db-1))  begin    
			
				tready                 <= 1'b1 ;

				tready_packet_cntr_en  <= 0;
				tready_packet_cntr     <= 16'b0;

    	        tx_axis_done           <= tx_axis_done;

			end






	endinterface // _axi_stream_interface_

`endif
