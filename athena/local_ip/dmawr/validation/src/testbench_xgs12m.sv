/******************************************************************************
** MODULE      :  testbench_xgs12m
**
** DESCRIPTION : axiHiSPi ip-core testbench
**
******************************************************************************/
`timescale 1ns / 1ps

import axi_vip_pkg::*;
import xgs12m_receiver_axi_vip_0_0_pkg::*;


module testbench_xgs12m();
 bit aclk = 1;
 bit aresetn=0;
 bit refclk =1;

 wire [3:0] GPIO;
  
 xil_axi_prot_t  prot = 0;
 
 xil_axi_ulong gpio_addr       =32'h00010000;
 xil_axi_ulong axiHiSPi_addr   =32'h00020000;
 xil_axi_ulong dec0_addr       =32'h000a0000;
 xil_axi_ulong dec1_addr       =32'h000b0000;
 xil_axi_ulong hispi_des0_addr =32'h000c0000;
 xil_axi_ulong hispi_des1_addr =32'h000d0000;
 xil_axi_ulong test_pat_addr   =32'h00120000;
 xil_axi_ulong remap_addr      =32'h00110000; 
 
   wire [31:0] M_AXI_araddr;
   wire [2:0]  M_AXI_arprot;
   wire        M_AXI_arready;
   wire        M_AXI_arvalid;
   wire [31:0] M_AXI_awaddr;
   wire [2:0]  M_AXI_awprot;
   wire        M_AXI_awready;
   wire        M_AXI_awvalid;
   wire        M_AXI_bready;
   wire [1:0]  M_AXI_bresp;
   wire        M_AXI_bvalid;
   wire [31:0] M_AXI_rdata;
   wire        M_AXI_rready;
   wire        M_AXI_rresp;
   wire        M_AXI_rvalid;
   wire [31:0] M_AXI_wdata;
   wire        M_AXI_wready;
   wire [3:0]  M_AXI_wstrb;
   wire        M_AXI_wvalid;
   
 bit [31:0] data_wr=32'h01234567;
 bit [31:0] data_rd;
 bit [15:0] XGS_data_rd;
 
 bit [11:0] test_numberclk_between_2lines;
 bit [15:0] test_number_frames;  
 bit [15:0] test_active_lines;
 bit [15:0] test_blank_lines;
 bit [15:0] test_fixed_data;
 
 wire Vcc  = 1;
 wire Grnd = 0; 
  
 bit XGS_MODEL_EXTCLK  = 0;
 bit XGS_MODEL_RESET_B = 0;

 wire [1:0] Sensor_HiSPI_clkP;
 wire [1:0] Sensor_HiSPI_clkN;
   
 wire [5:0] Sensor_HiSPI_dataP;
 wire [5:0] Sensor_HiSPI_dataN;
 
 
 reg XGS_MODEL_SCLK;   
 reg XGS_MODEL_SDATA;  
 reg XGS_MODEL_CS;     
 reg XGS_MODEL_SDATAOUT;
 
 bit trigger_int = 0;
 bit [15:0] line_time   = 16'h00e6;  //default model
 
 bit XGS_MODEL_SLAVE_TRIGGERED_MODE =1;
 
 XGS_PYTHON_IF xgs_spi();
   axi_lite_interface axil();
   
 xil_axi_resp_t resp;


  // Vivado ip integrator system (including vip)
  xgs12m_receiver_wrapper ipi_system (
    .GPIO_tri_o(GPIO), 
    .M_AXI_araddr(axil.araddr), 
    .M_AXI_arprot(axil.arprot), 
    .M_AXI_arready(axil.arready), 
    .M_AXI_arvalid(axil.arvalid), 
    .M_AXI_awaddr(axil.awaddr), 
    .M_AXI_awprot(axil.awprot), 
    .M_AXI_awready(axil.awready), 
    .M_AXI_awvalid(axil.awvalid), 
    .M_AXI_bready(axil.bready), 
    .M_AXI_bresp(axil.bresp), 
    .M_AXI_bvalid(axil.bvalid), 
    .M_AXI_rdata(axil.rdata), 
    .M_AXI_rready(axil.rready), 
    .M_AXI_rresp(axil.rresp), 
    .M_AXI_rvalid(axil.rvalid), 
    .M_AXI_wdata(axil.wdata), 
    .M_AXI_wready(axil.wready), 
    .M_AXI_wstrb(axil.wstrb), 
    .M_AXI_wvalid(axil.wvalid), 
    .aclk(aclk), 
    .aresetn(aresetn) 
  );



 axiHiSPi # (
    .FPGA_MANUFACTURER("XILINX"),
    .NUMBER_OF_LANE(6),
    .MUX_RATIO(4),
    .PIXELS_PER_LINE(4176),
    .LINES_PER_FRAME(3102),
    .PIXEL_SIZE(12)
    ) DUT (
    .axi_clk(aclk),
    .axi_reset_n(aresetn),
    .s_axi_awaddr(axil.awaddr),
    .s_axi_awprot(axil.awprot),
    .s_axi_awvalid(axil.awvalid),
    .s_axi_awready(axil.awready),
    .s_axi_wdata(axil.wdata),
    .s_axi_wstrb(axil.wstrb),
    .s_axi_wvalid(axil.wvalid),
    .s_axi_wready(axil.wready),
    .s_axi_bresp(axil.bresp),
    .s_axi_bvalid(axil.bvalid),
    .s_axi_bready(axil.bready),
    .s_axi_araddr(axil.araddr),
    .s_axi_arprot(axil.arprot),
    .s_axi_arvalid(axil.arvalid),
    .s_axi_arready(axil.arready),
    .s_axi_rdata(axil.rdata),
    .s_axi_rresp(axil.rresp),
    .s_axi_rvalid(axil.rvalid),
    .s_axi_rready(axil.rready),
    .idelay_clk(refclk),
    .hispi_io_clk_p( Sensor_HiSPI_clkP),
    .hispi_io_clk_n(Sensor_HiSPI_clkN),
    .hispi_io_data_p(Sensor_HiSPI_dataP),
    .hispi_io_data_n(Sensor_HiSPI_dataN),
    .m_axis_tready(1'b1),
    .m_axis_tvalid(),
    .m_axis_tuser(),
    .m_axis_tlast(),
    .m_axis_tdata()
    );



 
    xgs12m_chip #(
        //----------------------------------------------
        // Configuration for XGS12M with 24 HiSPI LANES
        //----------------------------------------------
        .G_MODEL_ID         (16'h0058),     // XGS12M
        .G_REV_ID           (16'h0002),     // XGS12M
        .G_NUM_PHY          (6),            // XGS12M
        .G_PXL_PER_COLRAM   (174),          // XGS12M
        .G_PXL_ARRAY_ROWS   (3100)          // XGS12M

        //----------------------------------------------
        // Configuration for XGS5M with 16 HiSPI LANES
        //----------------------------------------------        
        //.G_MODEL_ID         (16'h0358),     // XGS5M
        //.G_REV_ID           (16'h0000),     // XGS5M
        //.G_NUM_PHY          (4),            // XGS5M
        //.G_PXL_PER_COLRAM   (174),          // XGS5M
        //.G_PXL_ARRAY_ROWS   (2056)          // XGS5M  only active (2048+8=2056)      
        
        
    )
    XGS_MODEL(   
        .VAAHV_NPIX(), 
        .VREF1_BOT_0(),
        .VREF1_BOT_1(),
        .VREF1_TOP_0(),
        .VREF1_TOP_1(),
        .ATEST_BTM(), 
        .ATEST_TOP(),  
        .ASPARE_TOP(), 
        .ASPARE_BTM(), 
        
        .VRESPD_HI_0(),
        .VRESPD_HI_1(),
        .VRESFD_HI_0(),
        .VRESFD_HI_1(),
        .VSG_HI_0(),
        .VSG_HI_1(),
        .VRS_HI_0(),
        .VRS_HI_1(),
        .VTX1_HI_0(),
        .VTX1_HI_1(),
        .VTX0_HI_0(),
        .VTX0_HI_1(),
        .VRESFD_LO1_0(),
        .VRESFD_LO1_1(),
        .VRESFD_LO2_0(),
        .VRESFD_LO2_1(),
        .VRESPD_LO1_0(),
        .VRESPD_LO1_1(),
        .VSG_LO1_0(),
        .VSG_LO1_1(),
        .VTX1_LO1_0(),
        .VTX1_LO1_1(),
        .VTX1_LO2_0(),
        .VTX1_LO2_1(),
        .VTX0_LO1_0(),
        .VTX0_LO1_1(),
        .VPSUB_LO_0(),
        .VPSUB_LO_1(),                                
        .TEST(),
        .DSPARE0 (),
        .DSPARE1 (),
        .DSPARE2 (),

        .TRIGGER_INT(trigger_int), //il va falloir les brancher a l'interne!!!

        .MONITOR0(), //il va falloir les brancher a l'interne!!!
        .MONITOR1(), //il va falloir les brancher a l'interne!!!
        .MONITOR2(), //il va falloir les brancher a l'interne!!!                            
        
        .RESET_B(XGS_MODEL_RESET_B), 
        .EXTCLK(XGS_MODEL_EXTCLK),  
        .FWSI_EN(Vcc), 

        .SCLK(XGS_MODEL_SCLK),   
        .SDATA(XGS_MODEL_SDATA),  
        .CS(XGS_MODEL_CS),     
        .SDATAOUT(XGS_MODEL_SDATAOUT),

        .D_CLK_0_N(),
        .D_CLK_0_P(),
        .D_CLK_1_N(),
        .D_CLK_1_P(),
        .D_CLK_2_N(Sensor_HiSPI_clkN[0]),
        .D_CLK_2_P(Sensor_HiSPI_clkP[0]),
        .D_CLK_3_N(Sensor_HiSPI_clkN[1]),
        .D_CLK_3_P(Sensor_HiSPI_clkP[1]),
        .D_CLK_4_N(),
        .D_CLK_4_P(),
        .D_CLK_5_N(),
        .D_CLK_5_P(),

        .DATA_0_N (Sensor_HiSPI_dataN[0]),
        .DATA_0_P (Sensor_HiSPI_dataP[0]),
        .DATA_1_P (Sensor_HiSPI_dataP[1]),
        .DATA_1_N (Sensor_HiSPI_dataN[1]),
        .DATA_2_P (),                                
        .DATA_2_N (),                                
        .DATA_3_P (),
        .DATA_3_N (),
        .DATA_4_N (),
        .DATA_4_P (),
        .DATA_5_N (),
        .DATA_5_P (),
        .DATA_6_N (),
        .DATA_6_P (),
        .DATA_7_N (),
        .DATA_7_P (),
        .DATA_8_N (Sensor_HiSPI_dataN[2]),
        .DATA_8_P (Sensor_HiSPI_dataP[2]),
        .DATA_9_N (Sensor_HiSPI_dataN[3]),
        .DATA_9_P (Sensor_HiSPI_dataP[3]),
        .DATA_10_N(),
        .DATA_10_P(),
        .DATA_11_N(),
        .DATA_11_P(),
        .DATA_12_N(),
        .DATA_12_P(),
        .DATA_13_N(),
        .DATA_13_P(),
        .DATA_14_N(),
        .DATA_14_P(),
        .DATA_15_N(),
        .DATA_15_P(),
        .DATA_16_N(Sensor_HiSPI_dataN[4]),
        .DATA_16_P(Sensor_HiSPI_dataP[4]),
        .DATA_17_N(Sensor_HiSPI_dataN[5]),
        .DATA_17_P(Sensor_HiSPI_dataP[5]),
        .DATA_18_N(),
        .DATA_18_P(),
        .DATA_19_N(),
        .DATA_19_P(),
        .DATA_20_N(),
        .DATA_20_P(),
        .DATA_21_N(),
        .DATA_21_P(),
        .DATA_22_N(),
        .DATA_22_P(),
        .DATA_23_N(),
        .DATA_23_P()
    );            
            
 
 
xgs12m_receiver_axi_vip_0_0_mst_t    master_agent;

always #5ns     aclk             = ~aclk;                  //100Mhz regfile
always #2500ps  refclk           = ~refclk;                //200Mhz ref clk IO
always #15432ps XGS_MODEL_EXTCLK = ~XGS_MODEL_EXTCLK;      //refclk XGS @ 32.4Mhz


initial begin    
   
 
 

    //--------------------------------------------------------
    //
    // Create the master agent
    //
    //-------------------------------------------------------        
    master_agent = new("master vip agent", ipi_system.xgs12m_receiver_i.axi_vip_0.inst.IF);

    // set tag for agents for easy debug    
    master_agent.set_agent_tag("Master VIP");    
    
    // set print out verbosity level.    
    master_agent.set_verbosity(400);    
    
    //Start the agent    
    master_agent.start_master();    
    
    #160ns
    aresetn = 1;
 

    // MIn XGS model reset is 30 clk, set it to 50
    repeat(50)@(posedge XGS_MODEL_EXTCLK);
    XGS_MODEL_RESET_B = 1'b1;
    #200us
   
   
    //--------------------------------------------------------
    //
    // READ XGS MODEL ID
    //
    //-------------------------------------------------------        
    xgs_spi.ReadXGS_Model(16'h0000, XGS_data_rd);
    if (XGS_data_rd==16'h0058) 
      $info("XGS Model ID detected is 0x%x - XGS12M", XGS_data_rd);
    else if (XGS_data_rd==16'h0358) 
      $info("XGS Model ID detected is 0x%x - XGS5M", XGS_data_rd);
    else 
      $error("Unknown XGS Model ID. Read value : 0x%x", XGS_data_rd);

    
    //--------------------------------------------------------
    //
    // READ XGS REVISION ID
    //
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
    #500us
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
    #100ns
    //read GPIO add=0
    master_agent.AXI4LITE_READ_BURST(gpio_addr, prot, data_rd, resp);
    $display("GPIO add=0 data read is %x", data_rd);
    

    
    #100ns
    //read GPIO add=0
    master_agent.AXI4LITE_READ_BURST(gpio_addr, prot, data_rd, resp);
    $display("GPIO add=0 data read is %x", data_rd);
    
    
    
    
    
    //----------------------------------------
    //
    // Do some register tests with GPIO module
    //
    //----------------------------------------     
    #100ns
    // GPIO regadd=0 : 4 LSB bits are directly mapped to the 4x GPIO! other fields are RO
    data_wr =  32'h00000001;   
    master_agent.AXI4LITE_WRITE_BURST(gpio_addr, prot, data_wr, resp);
    #50ns
    data_wr =  32'h00000002;   
    master_agent.AXI4LITE_WRITE_BURST(gpio_addr, prot, data_wr, resp);
    #50ns
    data_wr =  32'h00000004;   
    master_agent.AXI4LITE_WRITE_BURST(gpio_addr, prot, data_wr, resp);
    #50ns
    data_wr =  32'h00000008;   
    master_agent.AXI4LITE_WRITE_BURST(gpio_addr, prot, data_wr, resp);    
    #50ns
    data_wr =  32'h0000000f;   
    master_agent.AXI4LITE_WRITE_BURST(gpio_addr, prot, data_wr, resp);        
        
    #500ns
    master_agent.AXI4LITE_READ_BURST(gpio_addr, prot, data_rd, resp);
     
    if(data_wr == data_rd)
      $display("GPIO Data match, test succeeded");
    else
      $display("GPIO Data do not match, test failed");
     
    
    //----------------------------------------
    //
    // Programming axiHiSPi
    //
    //----------------------------------------       
    master_agent.AXI4LITE_READ_BURST(axiHiSPi_addr+32'h00000000, prot, data_rd, resp);
    assert(data_rd == 32'h0058544d) $info("axiHiSPI tag : %s", data_rd);
    else $error("Bad Matrox TAG : 0x%x", data_rd);
   

    master_agent.AXI4LITE_WRITE_BURST(axiHiSPi_addr+32'h00000030, prot, 32'h00000001, resp);  
      $display("Enable capture");
   
    #100ns

    

    //--------------------------------------------------------
    //
    // PROGRAM XGS MODEL PART 2 - Set to output test mode image
    //
    //-------------------------------------------------------        
    // Dans le modele XGS  le decodage registres est fait :
    // register_map(1285) : (addresse & 0xfff) >>1  :  0x3a08=>1284
    
    XGS_MODEL_SLAVE_TRIGGERED_MODE=1;
    
    
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
      
      xgs_spi.WriteXGS_Model(16'h381c, test_active_lines/4);     // roi0_size  (kernel size is 4 lines)         
      xgs_spi.WriteXGS_Model(16'h383a, test_active_lines+1);     // frame_length cntx0 <= register_map(1053) :  Active + 1x Embeded 
      
      xgs_spi.WriteXGS_Model(16'h3800,16'h0030);                 // Slave + trigger mode   
      xgs_spi.WriteXGS_Model(16'h3800,16'h0031);                 // Enable sequencer
      
      //Simulate a 2 HW triggers here
      #50us;
      trigger_int =1;
      #30us;
      trigger_int =0;
      
/* -----\/----- EXCLUDED -----\/-----
      #100us;
      trigger_int =1;
      #30us;
      trigger_int =0;
 -----/\----- EXCLUDED -----/\----- */
    
    end
    
    
    
    // XGS MODEL FRAME IS 4176 pixels when test mode !!! 
    // voir p.Figure 37. Pixel Readout Order
    // voir p8 Figure 4. XGS 8000 Pixel Array
    // 4176 = 4 dummy + 24 BL K+ 4 dummy + 4 interpol + 4096 + 4 interpol + 4 dummy + 32 BLK + 4 dummy
    //
    //
    //
    //

     
     
    #500us
    $finish;
end

endmodule   




interface XGS_PYTHON_IF;
  
  initial begin
    testbench_xgs12m.XGS_MODEL_SCLK  = 0;
    testbench_xgs12m.XGS_MODEL_CS    = 1 ;
    testbench_xgs12m.XGS_MODEL_SDATA = 0;
  end;
  
  //----------------------------------------------
  // 
  //----------------------------------------------
  task automatic WriteXGS_Model(input int add, input int data);

    bit [14:0] model_addr;
    bit [15:0] model_data;
    
    model_addr = add;
    model_data = data;
    
    testbench_xgs12m.XGS_MODEL_SCLK  = 0;
    testbench_xgs12m.XGS_MODEL_CS    = 0 ;
    testbench_xgs12m.XGS_MODEL_SDATA = 0;
    #10ns; 
    
    //SEND ADDRESS
    for(int y = 15; y > 0; y -= 1)
    begin       
      testbench_xgs12m.XGS_MODEL_SCLK  = 0;   
      testbench_xgs12m.XGS_MODEL_CS    = 0;
      testbench_xgs12m.XGS_MODEL_SDATA = model_addr[(y-1)];
      #10ns;    
      testbench_xgs12m.XGS_MODEL_SCLK  = 1;
      #10ns;  
    end
    
    //SEND WRITE TAG
    testbench_xgs12m.XGS_MODEL_SCLK  = 0;   
    testbench_xgs12m.XGS_MODEL_CS    = 0;
    testbench_xgs12m.XGS_MODEL_SDATA = 0;  //Write=0
    #10ns;    
    testbench_xgs12m.XGS_MODEL_SCLK  = 1;
    #10ns;   

    //DATA
    for(int y = 16; y > 0; y -= 1)
    begin       
      testbench_xgs12m.XGS_MODEL_SCLK  = 0;   
      testbench_xgs12m.XGS_MODEL_CS    = 0;
      testbench_xgs12m.XGS_MODEL_SDATA = model_data[(y-1)];
      #10ns;    
      testbench_xgs12m.XGS_MODEL_SCLK  = 1;
      #10ns;  
    end
    
    testbench_xgs12m.XGS_MODEL_SCLK  = 0;
    testbench_xgs12m.XGS_MODEL_CS    = 0;
    testbench_xgs12m.XGS_MODEL_SDATA = 0;
    #10ns;     
    testbench_xgs12m.XGS_MODEL_SCLK  = 0;
    testbench_xgs12m.XGS_MODEL_CS    = 1;
    testbench_xgs12m.XGS_MODEL_SDATA = 0;
    #100ns;     
    
  endtask : WriteXGS_Model

  
  task automatic ReadXGS_Model(input int add, output int data);

    bit [14:0] model_addr;
    bit [15:0] model_data;
    
    model_addr = add;   
    
    testbench_xgs12m.XGS_MODEL_SCLK  = 0;
    testbench_xgs12m.XGS_MODEL_CS    = 0;
    testbench_xgs12m.XGS_MODEL_SDATA = 0;
    #10ns; 
    
    //SEND ADDRESS
    for(int y = 15; y > 0; y -= 1)
    begin       
      testbench_xgs12m.XGS_MODEL_SCLK  = 0;   
      testbench_xgs12m.XGS_MODEL_CS    = 0;
      testbench_xgs12m.XGS_MODEL_SDATA = model_addr[(y-1)];
      #10ns;    
      testbench_xgs12m.XGS_MODEL_SCLK  = 1;
      #10ns;  
    end
    
    //SEND READ TAG
    testbench_xgs12m.XGS_MODEL_SCLK  = 0;   
    testbench_xgs12m.XGS_MODEL_CS    = 0;
    testbench_xgs12m.XGS_MODEL_SDATA = 1;  //Read=1
    #10ns;    
    testbench_xgs12m.XGS_MODEL_SCLK  = 1;
    #10ns;   

    //GET DATA
    for(int y = 16; y > 0; y -= 1)
    begin       
      testbench_xgs12m.XGS_MODEL_SCLK  = 0;   
      testbench_xgs12m.XGS_MODEL_CS    = 0;
      testbench_xgs12m.XGS_MODEL_SDATA = 0;  
      #10ns;    
      testbench_xgs12m.XGS_MODEL_SCLK  = 1;
      model_data[(y-1)]                  = testbench_xgs12m.XGS_MODEL_SDATAOUT ;
      #10ns;  
    end
    
    data = model_data ;
    
    testbench_xgs12m.XGS_MODEL_SCLK  = 0;
    testbench_xgs12m.XGS_MODEL_CS    = 0;
    testbench_xgs12m.XGS_MODEL_SDATA = 0;
    #10ns;     
    testbench_xgs12m.XGS_MODEL_SCLK  = 0;
    testbench_xgs12m.XGS_MODEL_CS    = 1;
    testbench_xgs12m.XGS_MODEL_SDATA = 0; 
    #100ns;     
    
    
  endtask : ReadXGS_Model  

endinterface : XGS_PYTHON_IF



interface axi_lite_interface
  (input bit clk);

   // Define parameters
   parameter DATA_WIDTH = 32;
   parameter ADDR_WIDTH = 32;
   
   logic reset_n;
   
   // Axi write address channel
   logic awvalid;
   logic awready;
   logic [2:0] awprot;
   logic [ADDR_WIDTH-1:0] awaddr;


   // Axi write data channel
   logic 		  wvalid;
   logic 		  wready;
   logic [DATA_WIDTH/8-1:0] wstrb;
   logic [DATA_WIDTH-1:0]   wdata;


   // Axi write response channel
   logic 		    bready;
   logic 		    bvalid;
   logic [1:0] 		    bresp;


   // Axi read address channel
   logic 		    arvalid;
   logic 		    arready;
   logic [2:0] 		    arprot;
   logic [ADDR_WIDTH-1:0]   araddr;


   // Axi read data channel
   logic 		    rready;
   logic 		    rvalid;
   logic [DATA_WIDTH-1:0]   rdata;
   logic [1:0] 		    rresp;



   
   //////////////////////////////////////////////////////////////
   //
   // Port mode  : master
   //
   // Description : 
   //
   //////////////////////////////////////////////////////////////
   modport master (input  clk,
		   output reset_n,
		   output awvalid,
		   input  awready,
		   output awprot,
		   output awaddr,
		   output wvalid,
		   input  wready,
		   output wstrb,
		   output wdata,
		   output bready,
		   input  bvalid,
		   input  bresp,
		   output arvalid,
		   input  arready,
		   output arprot,
		   output araddr,
		   output rready,
		   input  rvalid,
		   input  rdata,
		   input  rresp
		   );


   //////////////////////////////////////////////////////////////
   //
   // Port mode  : slave
   //
   // Description : 
   //
   //////////////////////////////////////////////////////////////
   modport slave (input  clk,
		  input  reset_n,
		  input  awvalid,
		  output awready,
		  input  awprot,
		  input  awaddr,
		  input  wvalid,
		  output wready,
		  input  wstrb,
		  input  wdata,
		  input  bready,
		  output bvalid,
		  output bresp,
		  input  arvalid,
		  output arready,
		  input  arprot,
		  input  araddr,
		  input  rready,
		  output rvalid,
		  output rdata,
		  output rresp
		  );


endinterface // axi_lite_interface
