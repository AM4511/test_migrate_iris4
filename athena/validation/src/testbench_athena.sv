`timescale 1ns/1ps

module testbench_athena();



   system_wrapper DUT 
     (
      .anput_exposure(),
      .anput_ext_trig(),
      .anput_strobe(),
      .anput_trig_rdy(),
      .dma_tlp_cfg_bus_mast_en(),
      .dma_tlp_cfg_setmaxpld(),
      .dma_tlp_tlp_address(),
      .dma_tlp_tlp_attr(),
      .dma_tlp_tlp_byte_count(),
      .dma_tlp_tlp_data(),
      .dma_tlp_tlp_dst_rdy_n(),
      .dma_tlp_tlp_fmt_type(),
      .dma_tlp_tlp_grant(),
      .dma_tlp_tlp_ldwbe_fdwbe(),
      .dma_tlp_tlp_length_in_dw(),
      .dma_tlp_tlp_lower_address(),
      .dma_tlp_tlp_req_to_send(),
      .dma_tlp_tlp_src_rdy_n(),
      .dma_tlp_tlp_transaction_id(),
      .i2c_i2c_sdata(),
      .i2c_i2c_slk(),
      .led_out()
      );

    
   initial 
     begin
	DUT.system_i.modelAxiMasterLite_0.inst.wait_n(10);
	DUT.system_i.modelAxiMasterLite_0.inst.teriminate();
	
	//DUT.system_i.modelAxiMasterLite_0.inst.terminate();
	
	//DUT.system_i.modelAxiMasterLite_0.wait_n(10);
	//DUT.system_i.modelAxiMasterLite_0.terminate;
	
       // DUT.modelAxiMasterLite_0.wait_n(10);
      //  DUT.modelAxiMasterLite_0.terminate(10);
     end

 
endmodule


/* -----\/----- EXCLUDED -----\/-----


      
      // Initialize classes
      axilmaster = new(axil, if_gpio);
      
      // Time = 0ns
      axil.reset_n <= 0;

      #160ns;
      axil.reset_n <= 1;

      // MIn XGS model reset is 30 clk, set it to 50
      repeat(50)@(posedge XGS_MODEL_EXTCLK);
      XGS_MODEL_RESET_B = 1'b1;
      #200us;
      
      
      //--------------------------------------------------------
      // READ XGS MODEL ID
      //-------------------------------------------------------        
      xgs_spi.ReadXGS_Model(16'h0000, XGS_data_rd);
      if (XGS_data_rd==16'h0058) 
	$info("XGS Model ID detected is 0x%x - XGS12M", XGS_data_rd);
      else if (XGS_data_rd==16'h0358) 
	$info("XGS Model ID detected is 0x%x - XGS5M", XGS_data_rd);
      else 
	$error("Unknown XGS Model ID. Read value : 0x%x", XGS_data_rd);

      
      //--------------------------------------------------------
      // READ XGS REVISION ID
      //-------------------------------------------------------        
      xgs_spi.ReadXGS_Model(16'h31FE, XGS_data_rd);
      $info("Addres 0x31FE : XGS Revision ID detected is %x", XGS_data_rd);

      
      //--------------------------------------------------------
      //
      // PROGRAM XGS MODEL PART 1 
      //
      //-------------------------------------------------------    

      // default dans le model XGS:
      // ---------------------------------
      // register_map(0)    <= G_MODEL_ID; --Address 0x3000 - model_id
      // register_map(255)  <= G_REV_ID;   --Address 0x31FE - revision_id
      // register_map(1024) <= X"0002";    --Address 0x3800 - general_config0
      // register_map(1026) <= X"1111";    --Address 0x3804 - contexts_reg
      // register_map(1032) <= X"00E6";    --Address 0x3810 - line_time
      // register_map(1812) <= X"2507";    --Address 0x3E28 - hispi_control_common
      // register_map(1817) <= X"03A6";    --Address 0x3E32 - hispi_blanking_data
      
      
      // Dans le modele XGS  le decodage registres est fait :
      // register_map(1285) : (addresse & 0xfff) >>1  :  0x3a08=>1284
      
      //The following registers must be programmed with the specified value to enable test image generation on the HiSPi interface.
      //The commands below specify the register address followed by the register value.
      //In case of I2C, it must use the I2C slave address 0x20/0x21 as defined in the datasheet.
      //- REG Write = 0x3700, 0x001C
      xgs_spi.WriteXGS_Model(16'h3700,16'h001c);
      //- Wait at least 500us for the PLL to start and all clocks to be stable.
      #500us;
      
	//- REG Write = 0x3E3E, 0x0001
      xgs_spi.WriteXGS_Model(16'h3e3e,16'h0001);
      
      //jmansill HISPI control common register
      //xgs_spi.WriteXGS_Model(16'h3e28,16'h2507); //mux 4:4
      //xgs_spi.WriteXGS_Model(16'h3e28,16'h2517); //mux 4:3
      //xgs_spi.WriteXGS_Model(16'h3e28,16'h2527); //mux 4:2
      xgs_spi.WriteXGS_Model(16'h3e28,16'h2537);   //mux 4:1
      
      //--------------------------------------------------------
      //
      // Do some register tests in all Block design modules
      //
      //-------------------------------------------------------     
      address='h30;
      data='h1;
      ben='h1;
      
      $display("Enable the axiHiSPi core");
      
      axilmaster.write(address, data, ben, 1000);
      #100ns;
      
      
      if(XGS_MODEL_SLAVE_TRIGGERED_MODE==0) begin
	 // REG Write = 0x3E0E, <any value from 0x1 to 0x7>. This selects the testpattern to be sent 
	 // 0=jmansill B&W diagonal ramp 0->4095...
	 // 1=solid pattern
	 // 3=fade t0 black
	 // 4=diagonal  gary 1x
	 // 5=diagonal  gary 3x
	 // ... p.26 de la spec!!!
	 xgs_spi.WriteXGS_Model(16'h3e0e,16'h0000);  //add=1799
	 
	 //- Optional : REG Write = 0x3E10, <test_data_red>
	 //- Optional : REG Write = 0x3E12, <test_data_greenr>
	 //- Optional : REG Write = 0x3E14, <test_data_blue>
	 //- Optional : REG Write = 0x3E16, <test_data_greenb>
	 // Finalement en "solid pattern", il faut ecrire la valeur du pixel ici, sinon le modele genere des 0x001 partout.
	 // de plus le modele declare un signal [12:0] et utilise seulement [12:1]...
	 test_fixed_data = 16'h00ca;
	 xgs_spi.WriteXGS_Model(16'h3E10, test_fixed_data<<1);
	 xgs_spi.WriteXGS_Model(16'h3E12, test_fixed_data<<1);
	 xgs_spi.WriteXGS_Model(16'h3E14, test_fixed_data<<1);
	 xgs_spi.WriteXGS_Model(16'h3E16, test_fixed_data<<1);      
	 
	 //- REG Write = 0x3A08, <number of active lines transmitted for a test image frame>    
	 test_active_lines = 8;  // 1=1line
	 xgs_spi.WriteXGS_Model(16'h3A08, test_active_lines); // Cc registre est 1 based
	 
	 //- REG Write = 0x3A06, (number of clock cycles between the start of two rows)
	 test_numberclk_between_2lines = 12'h0c8; // 200clk
	 xgs_spi.WriteXGS_Model(16'h3A06, test_numberclk_between_2lines); //Enable test mode(0x8000) + 200clk 
         
	 //- REG Write = 0x3A0A, 0x8000 && (<number of lines between the last row of the test image and the first row of the next test image> << 6) 
	 //                             &&  <number of test image frames to be transmitted> 
	 test_blank_lines              = 4;       // 0=1line (correction is bellow)
	 test_number_frames            = 5;       // 1=1frame
	 xgs_spi.WriteXGS_Model(16'h3A0A,16'h8000 + ((test_blank_lines-1)<<6)  + (test_number_frames) );  //0x8000 is to latch registers
         
	 //- REG Write = 0x3A06, (0x8000 is enable test mode)
	 xgs_spi.WriteXGS_Model(16'h3A06,16'h8000+ test_numberclk_between_2lines); //Enable sequencer test mode      
	 
      end  
      
      if(XGS_MODEL_SLAVE_TRIGGERED_MODE==1) begin
	 
	 // jmansill : Slave triggered mode    
	 
	 test_active_lines             = 8;                         // One-based
	 //line_time                     = 16'h0e6;                   // default in model is 0xe6, XGS12M register is 0x16e
	 line_time                     = 4*16'h0e6;                   // default in model is 0xe6, XGS12M register is 0x16e
	 
	 xgs_spi.WriteXGS_Model(16'h3e0e,16'h0000);                 // Image Diagonal ramp:  line0 start=0, line1 start=1, line2 start=2...
	 
	 xgs_spi.WriteXGS_Model(16'h3810, line_time);               // register_map(1032) <= X"00E6";    --Address 0x3810 - line_time
	 
	 xgs_spi.WriteXGS_Model(16'h383e, 16'h0001);                // ROI active context0

	 xgs_spi.WriteXGS_Model(16'h381c, test_active_lines/4);     // roi0_size  (kernel size is 4 lines)         
	 xgs_spi.WriteXGS_Model(16'h383a, test_active_lines+1);     // frame_length cntx0 <= register_map(1053) :  Active + 1x Embeded 
	 
	 xgs_spi.WriteXGS_Model(16'h3800,16'h0030);                 // Slave + trigger mode   
	 xgs_spi.WriteXGS_Model(16'h3800,16'h0031);                 // Enable sequencer
	 
	 //Simulate a 2 HW triggers here
	 #50us;
	 trigger_int =1;
	 #30us;
	 trigger_int =0;
	 
	 /-* -----\/----- EXCLUDED -----\/-----
	  #100us;
	  trigger_int =1;
	  #30us;
	  trigger_int =0;
	  -----/\----- EXCLUDED -----/\----- *-/
	 
      end
      
      
      
      
      //test0000.run();
      #1ms;
      $finish;
   end
   
   
   
endmodule





interface XGS_PYTHON_IF;
   
   initial begin
      testbench_hispi.XGS_MODEL_SCLK  = 0;
      testbench_hispi.XGS_MODEL_CS    = 1 ;
      testbench_hispi.XGS_MODEL_SDATA = 0;
   end;
   
   //----------------------------------------------
   // 
   //----------------------------------------------
   task automatic WriteXGS_Model(input int add, input int data);

      bit [14:0] model_addr;
      bit [15:0] model_data;
      
      model_addr = add;
      model_data = data;
      
      testbench_hispi.XGS_MODEL_SCLK  = 0;
      testbench_hispi.XGS_MODEL_CS    = 0 ;
      testbench_hispi.XGS_MODEL_SDATA = 0;
      #10ns; 
      
      //SEND ADDRESS
      for(int y = 15; y > 0; y -= 1)
	begin       
	   testbench_hispi.XGS_MODEL_SCLK  = 0;   
	   testbench_hispi.XGS_MODEL_CS    = 0;
	   testbench_hispi.XGS_MODEL_SDATA = model_addr[(y-1)];
	   #10ns;    
	   testbench_hispi.XGS_MODEL_SCLK  = 1;
	   #10ns;  
	end
      
      //SEND WRITE TAG
      testbench_hispi.XGS_MODEL_SCLK  = 0;   
      testbench_hispi.XGS_MODEL_CS    = 0;
      testbench_hispi.XGS_MODEL_SDATA = 0;  //Write=0
      #10ns;    
      testbench_hispi.XGS_MODEL_SCLK  = 1;
      #10ns;   

      //DATA
      for(int y = 16; y > 0; y -= 1)
	begin       
	   testbench_hispi.XGS_MODEL_SCLK  = 0;   
	   testbench_hispi.XGS_MODEL_CS    = 0;
	   testbench_hispi.XGS_MODEL_SDATA = model_data[(y-1)];
	   #10ns;    
	   testbench_hispi.XGS_MODEL_SCLK  = 1;
	   #10ns;  
	end
      
      testbench_hispi.XGS_MODEL_SCLK  = 0;
      testbench_hispi.XGS_MODEL_CS    = 0;
      testbench_hispi.XGS_MODEL_SDATA = 0;
      #10ns;     
      testbench_hispi.XGS_MODEL_SCLK  = 0;
      testbench_hispi.XGS_MODEL_CS    = 1;
      testbench_hispi.XGS_MODEL_SDATA = 0;
      #100ns;     
      
   endtask : WriteXGS_Model

   
   task automatic ReadXGS_Model(input int add, output int data);

      bit [14:0] model_addr;
      bit [15:0] model_data;
      
      model_addr = add;   
      
      testbench_hispi.XGS_MODEL_SCLK  = 0;
      testbench_hispi.XGS_MODEL_CS    = 0;
      testbench_hispi.XGS_MODEL_SDATA = 0;
      #10ns; 
      
      //SEND ADDRESS
      for(int y = 15; y > 0; y -= 1)
	begin       
	   testbench_hispi.XGS_MODEL_SCLK  = 0;   
	   testbench_hispi.XGS_MODEL_CS    = 0;
	   testbench_hispi.XGS_MODEL_SDATA = model_addr[(y-1)];
	   #10ns;    
	   testbench_hispi.XGS_MODEL_SCLK  = 1;
	   #10ns;  
	end
      
      //SEND READ TAG
      testbench_hispi.XGS_MODEL_SCLK  = 0;   
      testbench_hispi.XGS_MODEL_CS    = 0;
      testbench_hispi.XGS_MODEL_SDATA = 1;  //Read=1
      #10ns;    
      testbench_hispi.XGS_MODEL_SCLK  = 1;
      #10ns;   

      //GET DATA
      for(int y = 16; y > 0; y -= 1)
	begin       
	   testbench_hispi.XGS_MODEL_SCLK  = 0;   
	   testbench_hispi.XGS_MODEL_CS    = 0;
	   testbench_hispi.XGS_MODEL_SDATA = 0;  
	   #10ns;    
	   testbench_hispi.XGS_MODEL_SCLK  = 1;
	   model_data[(y-1)]                  = testbench_hispi.XGS_MODEL_SDATAOUT ;
	   #10ns;  
	end
      
      data = model_data ;
      
      testbench_hispi.XGS_MODEL_SCLK  = 0;
      testbench_hispi.XGS_MODEL_CS    = 0;
      testbench_hispi.XGS_MODEL_SDATA = 0;
      #10ns;     
      testbench_hispi.XGS_MODEL_SCLK  = 0;
      testbench_hispi.XGS_MODEL_CS    = 1;
      testbench_hispi.XGS_MODEL_SDATA = 0; 
      #100ns;     
      
      
   endtask : ReadXGS_Model  

endinterface : XGS_PYTHON_IF
 -----/\----- EXCLUDED -----/\----- */

