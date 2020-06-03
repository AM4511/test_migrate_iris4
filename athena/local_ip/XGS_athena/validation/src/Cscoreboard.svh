import xgs_athena_pkg::*;

class Cscoreboard #(int AXIS_DATA_WIDTH=64, int AXIS_USER_WIDTH=2);
	//	class memory_entry;
	//		longint pcie_address;
	//		int pcie_data;
	//		function new(longint address, int data);
	//			this.pcie_address = address;
	//			this.pcie_data = data;
	//		endfunction
	//	endclass


	// Parameters
    
    int ImagePredicted =0;
	
	typedef struct {
      int Data32;
      longint Add64;
    } Pcie32_trans;
    typedef Pcie32_trans;
	
    Pcie32_trans Pcie32_queue[$];
	
	
	int number_of_errors=0;

	//used to count the number of transactions
	int no_transactions;

	//creating virtual interface handle
	// -permit_unmatched_virtual_intf
	//virtual tlp_interface tlp;
	virtual axi_stream_interface #(.T_DATA_WIDTH(AXIS_DATA_WIDTH), .T_USER_WIDTH(AXIS_USER_WIDTH)) axis;


	//constructor
	//function new(virtual mii_interface.slave  mii);
    function new(virtual axi_stream_interface #(.T_DATA_WIDTH(AXIS_DATA_WIDTH), .T_USER_WIDTH(AXIS_USER_WIDTH)) axis);
        //		//getting the interface
		this.axis = axis;
		//
		this.number_of_errors=0;
		//		this.no_transactions=0;

	endfunction


	task init ();
		this.number_of_errors=0;
		this.no_transactions=0;
		this.axis.tready = 1'b1;
	endtask


	task run ();
		int transaction_active;
		int tlp_cntr;
		int tlp_length;
		int address_array[$];
		bit [9:0] pcie_length;
		bit [1:0] pcie_at;
		bit [1:0] pcie_attr;
		bit [6:0] pcie_fmt_type;
		int header_dw;
		int has_data;
		bit [3:0] first_dw_be;
		bit [3:0] last_dw_be;
		bit [7:0] pcie_tag;
		bit [15:0] requester_id;
		longint nxt_pcie_address;
		int tlp_id;
		//memory_entry entry;

		/////////////////////////////////////////////////////////////////////////
		// Initialization
		/////////////////////////////////////////////////////////////////////////
		this.init();
		transaction_active = 0;
		tlp_cntr = 0;
		tlp_id=0;


		/////////////////////////////////////////////////////////////////////////
		// Infinite loop
		/////////////////////////////////////////////////////////////////////////
		do begin
			@(posedge this.axis.clk);
			if (this.axis.tready == 1'b1 && this.axis.tvalid == 1'b1) begin

				/////////////////////////////////////////////////////////////////
				// DW0 + DW1 : Header
				/////////////////////////////////////////////////////////////////
				if (tlp_cntr == 0) begin
				
				    tlp_length =this.axis.tdata[9:0];
				    
					//$display("New TLP : %d, tlp_length : %d ", tlp_id, tlp_length  );

					// PCIE format
					pcie_fmt_type = this.axis.tdata[30:24];

					if (pcie_fmt_type[5] == 1'b1) begin
						header_dw = 4;
					end	else begin
						header_dw = 3;
					end
					if (pcie_fmt_type[6] == 1'b1) begin
						has_data = 1;
					end	else begin
						has_data = 0;
					end

					first_dw_be  = this.axis.tdata[35:32];
                    //$display("FDWBE is %h", first_dw_be );

					last_dw_be   = this.axis.tdata[39:36];
                    //$display("LDWBE is %h", last_dw_be );

					pcie_tag     = this.axis.tdata[47:40];
					requester_id = this.axis.tdata[63:48];
					tlp_cntr++;
				end

				/////////////////////////////////////////////////////////////////
				// DW3 + DW2 : Header
				/////////////////////////////////////////////////////////////////
				else if (tlp_cntr == 1) begin
					
					if (header_dw==3 && has_data == 1) begin
						nxt_pcie_address[63:32] = 0;
						nxt_pcie_address[31:0]  = this.axis.tdata[31:0];
						$display("Header DW3 is data %h", this.axis.tdata[63:32] );
				    	validate_DW(nxt_pcie_address, this.axis.tdata[63:32]);			
						nxt_pcie_address = nxt_pcie_address + 4;
						tlp_length--;
					end else if (header_dw==4) begin
						nxt_pcie_address = this.axis.tdata[63:0];
					end
					tlp_cntr++;
				end

				/////////////////////////////////////////////////////////////////
				// DW4 > : payload
				/////////////////////////////////////////////////////////////////
				else if (tlp_cntr > 1 && has_data > 0) begin
					
					//$display("Data DW Lo is %h", this.axis.tdata[31:0] );
					validate_DW(nxt_pcie_address, this.axis.tdata[31:0]);
					nxt_pcie_address = nxt_pcie_address + 4;
					tlp_length--;
					
		            if(tlp_length!=0) begin  // pour n'est pas ecrire le dernier DW xxxxxxxx 
					  //$display("Data DW Hi is %h", this.axis.tdata[63:32] );
					  validate_DW(nxt_pcie_address, this.axis.tdata[63:32]);
					  nxt_pcie_address = nxt_pcie_address + 4;
					  tlp_length--;
					end;
					
					tlp_cntr++;
				end


				/////////////////////////////////////////////////////////////////
				// Last Data beat of the transaction
				/////////////////////////////////////////////////////////////////
				if (this.axis.tlast == 1'b1) begin
					tlp_cntr = 0;
					tlp_id++;
					$display("TLP %d completed!", tlp_id);
				end
			end
		end while (1);

	endtask




	/////////////////////////////////////////////////////////////////////////
	// Prediction de la rampe simple sans aucun processing
	/////////////////////////////////////////////////////////////////////////
    task predict_img(input CImage Image, int X_start, X_end, int Y_start, int Y_size, longint fstart, int line_size, int line_pitch);

       int Initial_X_pix;
       int nbElements=0;	   
	   Pcie32_trans DW_pred;	   

	   // temp XGS12M
	   int D0_end     = 4;
	   int BL0_end    = D0_end  + 24;
	   int D1_end     = BL0_end + 4;
	   int Valid_end  = D1_end  + 4 + 4096 + 4;
	   int D2_end     = Valid_end + 4;
	   int BL1_end    = D2_end  + 32;
	   int D3_end     = BL1_end + 4;
	   
       $display ("Image %h Predictor, XGS Y_start=%d, XGS Y_size=%d, fstart=0x%h, line_size=0x%h, line_pitch=0x%h ", ImagePredicted, Y_start, Y_size, fstart, line_size, line_pitch);       
       
       for(int y = 0; y < Y_size; y = y+1)
	     begin
         for(int x = X_start; x < X_end; x = x+4)
           begin
             
			//if(x<D0_end) begin
            //    DW_pred.Data32[31:0] = 32'h0d0d0d0d;			 
			//  end else
			//    if(x<BL0_end) begin
            //      DW_pred.Data32[31:0] = 32'h00000000;
			//    end else
            //      if(x<D1_end) begin
            //        DW_pred.Data32[31:0] = 32'h0d0d0d0d;			 
			//      end else  
			//        if(x<Valid_end) begin
            //          Initial_X_pix= (Y_start+y)%253 + x - D1_end; // rampe		   
            //          DW_pred.Data32[31:24] = Initial_X_pix + 3;
            //          DW_pred.Data32[23:16] = Initial_X_pix + 2;
            //          DW_pred.Data32[15:8]  = Initial_X_pix + 1;
            //          DW_pred.Data32[7:0]   = Initial_X_pix + 0;
            //        end else
			//          if(x<D2_end) begin
            //            DW_pred.Data32[31:0] = 32'h0d0d0d0d;			 
			//          end else
			//            if(x<BL1_end) begin
            //              DW_pred.Data32[31:0] = 32'h00000000;
			//            end else
			//        	   DW_pred.Data32[31:0] = 32'h0d0d0d0d;
			
             DW_pred.Data32[31:24] = Image.get_pixel(x+3, Y_start+y);
             DW_pred.Data32[23:16] = Image.get_pixel(x+2, Y_start+y);
             DW_pred.Data32[15:8]  = Image.get_pixel(x+1, Y_start+y);
             DW_pred.Data32[7:0]   = Image.get_pixel(x+0, Y_start+y);
			
             DW_pred.Add64 = fstart + (line_pitch*y) + (x-X_start) ; 
             			
		 	 // mettre la transaction dans la queue.
		     this.Pcie32_queue.push_back(DW_pred);
		 	
             //$display ("Prediction :  0x%h, 0x%h", DW_pred.Add64, DW_pred.Data32);
		 	 nbElements++;
           end       
         end
	   $display ("NB_DW=%d", nbElements);       

       ImagePredicted++;

    endtask
    

	
	/////////////////////////////////////////////////////////////////////////
	// Inline validation
	/////////////////////////////////////////////////////////////////////////
    task validate_DW(longint address, int data);    
      
	  int data_LE;
	  
      Pcie32_trans DW_pred;
	 	 	    
	  //$display ("Queue have %d elements", this.Pcie32_queue.size() ); 
	  
	  //Big Endian to Little endian
	  data_LE[31:24] = data[7:0];
	  data_LE[23:16] = data[15:8];
	  data_LE[15:8]  = data[23:16];
	  data_LE[7:0]   = data[31:24]; 
	  	  
	  if (this.Pcie32_queue.size() > 0) begin
	    DW_pred = this.Pcie32_queue.pop_front();
	  
	    if(address!=DW_pred.Add64 || data_LE!=DW_pred.Data32) begin	
	     $display ("ERROR predicted: 0x%h 0x%h , Simulated 0x%h 0x%h ", DW_pred.Add64, DW_pred.Data32, address, data_LE);
         number_of_errors++;	
         if(number_of_errors>0) begin
		   //#10us;
		   $stop;           
		 end 
		end 		 
      end  else begin
	  	$display ("ERROR Pcie queue is empty and still have transactions pending!");
	  
	  end
	    
	  
	
    endtask
    
    
endclass

