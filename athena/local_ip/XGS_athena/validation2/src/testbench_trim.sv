`timescale 1ns/1ps


module testbench();
   parameter TEST_NAME = "UNKNOWN";
   parameter COLOR_SPACE = 0;  // COLOR_SPACE
   parameter Y_SIZE = 5;       // size in rows
   parameter X_SIZE = 256;     // size in pixels
   parameter X_ROI_EN = 1;
   parameter X_ROI_START = 0;  // size in pixels
   parameter X_ROI_SIZE = 128; // size in pixels
   parameter X_REVERSE = 0;
   parameter X_SCALING = 0;    // size in pixels
   parameter Y_ROI_EN = 0;
   parameter Y_ROI_START = 0;  // size in pixels
   parameter Y_ROI_SIZE = Y_SIZE-1; // size in pixels

   parameter WATCHDOG_MAX_CNT = 100000;


   typedef struct {
      int 	  row_id;
      bit [63:0]  data[$];
   } data_row;



   //clock and reset signal declaration
   bit 		  aclk;
   bit 		  aclk_reset_n;
   bit 		  aclk_tready;
   bit 		  aclk_tvalid;
   bit 		  aclk_tlast;

   bit [3:0] 	  aclk_tuser;
   bit [63:0] 	  aclk_tdata;
   bit [2:0] 	  aclk_color_space;
   bit [12:0] 	  aclk_x_size;
   bit [12:0] 	  aclk_x_start;
   bit [12:0] 	  aclk_x_stop;
   bit [3:0] 	  aclk_x_scale;
   bit 		  aclk_x_crop_en;
   bit 		  aclk_x_reverse;
   bit 		  aclk_y_roi_en;
   bit [12:0] 	  aclk_y_size;
   bit [12:0] 	  aclk_y_start;
   bit 		  bclk;
   bit 		  bclk_reset_n;
   bit 		  bclk_tready;
   bit 		  bclk_tvalid;
   bit 		  bclk_tlast;
   bit [3:0] 	  bclk_tuser;
   bit [63:0] 	  bclk_tdata;

   bit 		  aclk_grab_queue_en;
   bit [1:0] 	  aclk_load_context;

   int 	  src_pixel_width;
   int 	  pred_pixel_width;

   // Clock and Reset generation
   //always #2.7 sys_clk          = ~sys_clk;
   always #5 aclk    = ~aclk;
   always #6.5 bclk  = ~bclk;
   //assign bclk_tready = 1;
   int 		  watchdog;
   int 		  error;


   trim DUT(
	    .aclk_grab_queue_en(aclk_grab_queue_en),
	    .aclk_load_context(aclk_load_context),
	    .aclk_color_space(aclk_color_space),
	    .aclk_x_crop_en(aclk_x_crop_en),
	    .aclk_x_start(aclk_x_start),
	    .aclk_x_size(aclk_x_size),
	    .aclk_x_scale(aclk_x_scale),
	    .aclk_x_reverse(aclk_x_reverse),    
            .aclk_y_roi_en(aclk_y_roi_en),
	    .aclk_y_start(aclk_y_start),
            .aclk_y_size(aclk_y_size),
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

      aclk_grab_queue_en = 1'b0;
      aclk_load_context = 2'b0;


      ////////////////////////////////////////////////////////
      // Create src data
      ////////////////////////////////////////////////////////
      //aclk_pixel_width = src_pixel_width; // in bytes
      aclk_color_space = COLOR_SPACE;
      	case (COLOR_SPACE) 
	  0 : src_pixel_width = 1; 
	  1 : src_pixel_width = 4;
	  2 : src_pixel_width = 4; 
	  5 : src_pixel_width = 4;
	  default : src_pixel_width = 1; 
	endcase
      	case (COLOR_SPACE) 
	  0 : pred_pixel_width = 1; 
	  1 : pred_pixel_width = 4;
	  2 : pred_pixel_width = 2; 
	  5 : pred_pixel_width = 1;
	  default : src_pixel_width = 1; 
	endcase
      // Reverse setting
      aclk_x_reverse = X_REVERSE;

      // ROI setting
      aclk_x_crop_en = X_ROI_EN;
      aclk_x_start   = X_ROI_START;
      aclk_x_size    = X_ROI_SIZE;
      aclk_x_stop    = aclk_x_start + aclk_x_size -1;
      aclk_x_scale   = X_SCALING;
      aclk_y_start   = Y_ROI_START;
      aclk_y_size    = Y_ROI_SIZE;
      aclk_y_roi_en  = Y_ROI_EN;

      
      $display("\n\n");
      $display("DISPLAY         : %s",TEST_NAME);
      $display("COLOR_SPACE     : %0d",COLOR_SPACE);
      $display("SRC_PIXEL_WIDTH : %0d",src_pixel_width);
      $display("X_REVERSE       : %0d",aclk_x_reverse);
      $display("X_ROI_EN        : %0d",aclk_x_crop_en);
      $display("X_ROI_START     : %0d",aclk_x_start);
      $display("X_ROI_SIZE      : %0d",aclk_x_size);
      $display("X_SCALING       : %0d",aclk_x_scale);

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
	    int byte_ptr;
	    int pixel_ptr;
	    int row_id;
	    int c, i,j,k;
	    bit [63:0] db;
	    bit        tlast;
	    bit [3:0]  user;
	    int        stream_size;
	    bit [63:0] data_queue[$];
	    data_row axi_src_stream[$];
	    data_row curr_row;


	    ////////////////////////////////////////////////////////
	    // Create src stream
	    ////////////////////////////////////////////////////////

	    // Process each row of the frame
	    for (j=0;  j < Y_SIZE;  j++) begin
	       curr_row.data = {};
	       curr_row.row_id = j;
	       byte_ptr = 0;
	       db = 0;
	       
               // Process each pixel of a row
	       for (i=0;  i < X_SIZE;  i++) begin
		   
		  pixel_ptr = (src_pixel_width*i)%8;
		  
		  // Process each component of a pixel
		  for (c=0; c< src_pixel_width; c++) begin
		     
		     db[byte_ptr*8 +: 8] = i;

		     if (byte_ptr == 7) begin
			curr_row.data.push_back(db);
			db = 0;
		        byte_ptr = 0;
		     end
		     else begin
			byte_ptr++;
		     end
		  end 
	       end//End of for i
	       
	       axi_src_stream.push_back(curr_row);
	    end


	    ////////////////////////////////////////////////////////
	    // Send the stream
	    ////////////////////////////////////////////////////////
	    #1000;
	    j=0;
	    // Start of frame
	    while (j < Y_SIZE) begin
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
	    bit [7:0] pix_value;
	    byte      c;
	    int       s;
	    int       cntr;
	    int       mask_size;
	    longint   byte_mask;
	    int       subs_cntr;

	    bit [3:0] user;
	    int       byte_ptr;
	    int       row_size;
	    bit [7:0] byte_stream[$];

	    int       axi_received_stream_size;
	    data_row axi_received_stream[];
	    data_row received_row;
	    bit [63:0] received_row_data[$];
	    bit [63:0] received_db;
	    int        received_row_id;
	    int        received_row_size;

	    data_row axi_predicted_stream[];
	    data_row pred_row;
	    bit [63:0] pred_row_data[$];
	    bit [63:0] reverse_row_data[$];
	    bit [63:0] pred_db;
	    bit [63:0] reverse_db;
	    int        pred_row_id;
	    int        pred_row_size;

	    int        longest_row_size;

	    axi_received_stream = new[Y_ROI_SIZE];
	    axi_predicted_stream = new[Y_ROI_SIZE];
	    

	    ///////////////////////////////////////////////////////
	    // Capturing data
	    ////////////////////////////////////////////////////////
	    watchdog = WATCHDOG_MAX_CNT;
	    error =0;
	    j = 0;
	    cntr =0;
	    while (1) begin

	       @(posedge bclk);
	       if (bclk_tvalid == 1'b1 && bclk_tready == 1'b1) begin
		  user = bclk_tuser;
		  received_db = bclk_tdata;
		  received_row_data.push_back(received_db);
		  if (bclk_tlast == 1'b1) begin
		     received_row.data = received_row_data;
		     received_row.row_id = j;
		     axi_received_stream[j] = received_row;
		     j++;
		     received_row_data.delete();


		     // At EOF we are done
		     if (bclk_tuser[1] == 1'b1) begin
			break;
		     end
		  end

		  // reset the watchdog
		  watchdog = WATCHDOG_MAX_CNT;
	       end

	       begin
		  /////////////////////////////////////////////////////////
		  //
		  /////////////////////////////////////////////////////////
		  bclk_tready = 1'b1;
		  

		  // At EOF we are done
		  if (bclk_tuser[1] == 1'b1 && bclk_tvalid == 1'b1 && bclk_tready == 1'b1) begin
		     break;
		  end
		  cntr++;
	       end


	       assert (watchdog) else begin
		  $error("Watchdog error");
		  error++;
		  $stop();
	       end
	       watchdog--;

	    end

	    #1000ns;


	    ///////////////////////////////////////////////////////
	    // Create predicted stream
	    ////////////////////////////////////////////////////////
	    // If cropping disabled the ROI becomes the original image size
	    if (aclk_x_crop_en == 0) begin
	       aclk_x_start = 0;
	       aclk_x_stop = X_SIZE-1;
	    end


	    // Process each row
	    for (j=0;  j < Y_ROI_SIZE;  j++) begin
	       subs_cntr = 0;
	       // Process each pixel of the current row
	       for (i=aclk_x_start;  i<= aclk_x_stop;  i++) begin
		  if (subs_cntr % (X_SCALING+1) == 0) begin
		     for (c = 0; c < pred_pixel_width; c++) begin
			byte_stream.push_back(i);
		     end
		  end 
		  subs_cntr++;
	       end


	       // Process current row in forward scan
	       if (aclk_x_reverse == 1'b0) begin
		  byte_ptr = 0;
		  pred_db = 0;
		  while (byte_stream.size() > 0) begin
		     pix_value = byte_stream.pop_front();

		     pred_db[byte_ptr*8 +: 8] = pix_value;

		     if (byte_ptr == 7 || byte_stream.size() == 0) begin
			pred_row_data.push_back(pred_db);
			byte_ptr = 0;
			pred_db = 0;
		     end else
		       byte_ptr++;


		  end
		  // Process current row in reverse scan
	       end	else begin
		  byte_ptr = 0;
		  pred_db = 0;
		  while (byte_stream.size() > 0) begin
		     pix_value = byte_stream.pop_back();

		     pred_db[byte_ptr*8 +: 8] = pix_value;

		     if (byte_ptr == 7 || byte_stream.size() == 0) begin
			pred_row_data.push_back(pred_db);
			byte_ptr = 0;
			pred_db = 0;
		     end else
		       byte_ptr++;

		  end
	       end

	       pred_row.row_id = j;
	       pred_row.data = pred_row_data;
	       pred_row_data.delete();
	       axi_predicted_stream[j] = pred_row;
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
	       received_row = axi_received_stream[j];
	       received_row_id = received_row.row_id;
	       received_row_data = received_row.data;
	       received_row_size = received_row_data.size();

	       pred_row = axi_predicted_stream[j];
	       pred_row_id = pred_row.row_id;
	       pred_row_data = pred_row.data;
	       pred_row_size = pred_row_data.size();

	       // Validate row_id
	       assert (received_row_id == pred_row_id) else
		 begin
		    $error("Received row ID : %0d; Predicted row ID : %0d", received_row_id, pred_row_id);
		    error++;
		 end

	       // Validate row size
	       assert (received_row_size == pred_row_size) else
		 begin
		    $error("Received row size : %0d; Predicted row size : %0d", received_row_size, pred_row_size);
		    error++;
		 end

	       // Validate each data beat
	       $display("Received row[%0d]       Predicted row[%0d]", received_row_id, pred_row_id);
	       longest_row_size =  (received_row_size >= pred_row_size) ? received_row_size : pred_row_size;
	       
               // mask_size = 8 * ((X_ROI_SIZE + X_SIZE) % 8);

	       // mask_size (in bits) = 8 * (Window size in pixel mod scaling factor) mod 8 bytes
               mask_size = 8 * (((aclk_x_stop - aclk_x_start + 1)/(X_SCALING + 1) * pred_pixel_width ) % 8);
	       byte_mask = ~(-1 << mask_size);
	       for (i=0; i<longest_row_size; i++) begin
		  c = " ";
		  received_db = received_row_data.pop_front();
		  pred_db = pred_row_data.pop_front();

		  if (i < longest_row_size-1 || mask_size == 0) begin
		     if (received_db != pred_db) begin
			c = "|";
			error++;
		     end
		     $display("0x%016h %c  0x%016h", received_db, c,pred_db);
		  end else begin
		     if ((received_db & byte_mask) != (pred_db & byte_mask)) begin
			c = "|";
			error++;
		     end
		     $display("0x%016h %c  0x%016h (mask=0x%016h)", received_db, c,pred_db, byte_mask);
		  end
	       end

	       $display("\n\n");
	       received_row.data.delete();

	    end
	 end
      join;

      $display("=====================================================================");
      $display("Total error : %-0d", error);

      #10000;
      $stop();
   end

endmodule
