class Cscoreboard #(int AXIS_DATA_WIDTH=64, int AXIS_USER_WIDTH=4);
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
	
	int IgnorePrediction=0;

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
		int file_desc;
		
		//memory_entry entry;
        $timeformat(-9, 2, " ns", 20);

        file_desc = $fopen("./Cscoreboard.dump", "w");
		if (file_desc) $display("./Cscoreboard.dump open successfully");
		else $error("Can't open ./Cscoreboard.dump");
	   
		
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
			@(posedge this.axis.aclk);
			if (this.axis.tready == 1'b1 && this.axis.tvalid == 1'b1) begin

				/////////////////////////////////////////////////////////////////
				// DW0 + DW1 : Header
				/////////////////////////////////////////////////////////////////
				if (tlp_cntr == 0) begin
				
				    tlp_length =this.axis.tdata[9:0];
				    
					//$display("New TLP : %0d, tlp_length : %0d ", tlp_id, tlp_length  );

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
						//$display("Header DW3 is data %h", this.axis.tdata[63:32] );
				    	validate_DW(file_desc, nxt_pcie_address, this.axis.tdata[63:32]);			
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
					validate_DW(file_desc, nxt_pcie_address, this.axis.tdata[31:0]);
					nxt_pcie_address = nxt_pcie_address + 4;
					tlp_length--;
					
		            if(tlp_length!=0) begin  // pour n'est pas ecrire le dernier DW xxxxxxxx 
					  //$display("Data DW Hi is %h", this.axis.tdata[63:32] );
					  validate_DW(file_desc, nxt_pcie_address, this.axis.tdata[63:32]);
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
					if(tlp_id%50 ==0)
					  $display("TLP %0d completed!", tlp_id);
				end
			end
		end while (1);

	endtask




	/////////////////////////////////////////////////////////////////////////
	// Prediction de la rampe simple sans aucun processing
	/////////////////////////////////////////////////////////////////////////
    task predict_img(input Cimage Image, longint fstart, int line_size, int line_pitch, int REV_Y);

       int Initial_X_pix;
       int nbElements=0;	   
	   Pcie32_trans DW_pred;	   

   
       $display ("Image %h Predictor, XGS Xsize=%0d, XGS Ysize=%0d, fstart=0x%h, line_size=0x%h, line_pitch=0x%h ", ImagePredicted, Image.pgm_size_x, Image.pgm_size_y, fstart, line_size, line_pitch);       
       
       for(int y = 0; y < Image.pgm_size_y; y = y+1)
	     begin
         for(int x = 0; x < Image.pgm_size_x; x = x+4)
           begin
             
             DW_pred.Data32[31:24] = Image.get_pixel(x+3, y);
             DW_pred.Data32[23:16] = Image.get_pixel(x+2, y);
             DW_pred.Data32[15:8]  = Image.get_pixel(x+1, y);
             DW_pred.Data32[7:0]   = Image.get_pixel(x+0, y);
			 
			 if(REV_Y==0) begin
               DW_pred.Add64 = fstart + (line_pitch*y) + x ; 
			 end else begin
			   DW_pred.Add64 = fstart - (line_pitch*y) + x ;	 
			 end			
		 	 // mettre la transaction dans la queue.
		     this.Pcie32_queue.push_back(DW_pred);
		 	
             //$display ("Prediction :  0x%h, 0x%h", DW_pred.Add64, DW_pred.Data32);
		 	 nbElements++;
           end       
         end
	   $display ("NB_DW=%0d", nbElements);       

       ImagePredicted++;

    endtask
    

	
	/////////////////////////////////////////////////////////////////////////
	// Inline validation
	/////////////////////////////////////////////////////////////////////////
    task validate_DW(int file_desc, longint address, int data);    
      
	  int data_LE;
	  
      Pcie32_trans DW_pred;
	 	 	    
	  //$display ("Queue have %0d elements", this.Pcie32_queue.size() ); 
	  
	  //Big Endian to Little endian
	  data_LE[31:24] = data[7:0];
	  data_LE[23:16] = data[15:8];
	  data_LE[15:8]  = data[23:16];
	  data_LE[7:0]   = data[31:24]; 
	  	  
	  if (this.Pcie32_queue.size() > 0) begin
	    DW_pred = this.Pcie32_queue.pop_front();
	    if(IgnorePrediction==0) begin
		  
	      if(address!=DW_pred.Add64 || data_LE!=DW_pred.Data32) begin	
	        $error("ERROR predicted: 0x%h 0x%h , Simulated 0x%h 0x%h ", DW_pred.Add64, DW_pred.Data32, address, data_LE);
			//Print in the output file for debug
	        $fdisplay (file_desc, "ERROR predicted: 0x%h 0x%h , Simulated 0x%h 0x%h ", DW_pred.Add64, DW_pred.Data32, address, data_LE);
            number_of_errors++;	
            if(number_of_errors>0) begin
		      //#10us;
			  $fclose(file_desc);
		      $stop;           
		    end 
		  end else begin
		     // Print in the output file for debug
		     $fdisplay (file_desc, "0x%h 0x%h , Simulated 0x%h 0x%h ", DW_pred.Add64, DW_pred.Data32, address, data_LE);
          end		  
		end  
      end  else begin
	  	$error("Pcie prediction queue is empty and still have transactions pending!");
        number_of_errors++;	
	  
	  end
	    
	  
	
    endtask
    
    
endclass

