`timescale 1ns / 1ps

//import axi_vip_v1_0_2_pkg::*;
import axi_vip_pkg::*;
import xgs12m_receiver_axi_vip_0_0_pkg::*;






module TB_xgs12m_receiver(  );
 
 bit aclk = 0;
 bit aresetn=0;
 bit REFCLK =0;

 wire [3:0] GPIO;
  
 xil_axi_prot_t  prot = 0;
 
 xil_axi_ulong gpio_addr       =32'h00010000;
 xil_axi_ulong dec0_addr       =32'h000a0000;
 xil_axi_ulong dec1_addr       =32'h000b0000;
 xil_axi_ulong hispi_des0_addr =32'h000c0000;
 xil_axi_ulong hispi_des1_addr =32'h000d0000;
 xil_axi_ulong test_pat_addr   =32'h00120000;
 xil_axi_ulong remap_addr      =32'h00110000; 
 
 
 bit [31:0] data_wr=32'h01234567;
 bit [31:0] data_rd;
 bit [15:0] XGS_data_rd;
 
 wire Vcc  = 1;
 wire Grnd = 0; 
  
 bit XGS_MODEL_EXTCLK  = 0;
 bit XGS_MODEL_RESET_B = 0;

 wire [5:0]HiSPI_clkP;
 wire [5:0]HiSPI_clkN;
 wire [23:0]HiSPI_dataP;
 wire [23:0]HiSPI_dataN;
 
 
 reg XGS_MODEL_SCLK;   
 reg XGS_MODEL_SDATA;  
 reg XGS_MODEL_CS;     
 reg XGS_MODEL_SDATAOUT;
 
 XGS_PYTHON_IF xgs_spi();
 
 xil_axi_resp_t resp;
 
 xgs12m_receiver_wrapper DUT(   .REFCLK(REFCLK),
                                .aclk(aclk),
                                .aresetn(aresetn),
                                
                                .GPIO_tri_o(GPIO),
                                
                                .M_AXIS_tdata(),
                                .M_AXIS_tdest(),
                                .M_AXIS_tid(),
                                .M_AXIS_tkeep(),
                                .M_AXIS_tlast(),
                                .M_AXIS_tready(),
                                .M_AXIS_tstrb(),
                                .M_AXIS_tuser(),
                                .M_AXIS_tvalid(),

                                .xgs_bus_0_d_clk_n(HiSPI_clkN[0]),
                                .xgs_bus_0_d_clk_p(HiSPI_clkP[0]),
                                .xgs_bus_0_data_n(HiSPI_dataP[11:0]),
                                .xgs_bus_0_data_p(HiSPI_dataN[11:0]),
                                .xgs_bus_1_d_clk_n(HiSPI_clkN[3]),
                                .xgs_bus_1_d_clk_p(HiSPI_clkP[3]),
                                .xgs_bus_1_data_n(HiSPI_dataP[23:12]),
                                .xgs_bus_1_data_p(HiSPI_dataN[23:12])                            
                            );
            

 xgs12m_chip       XGS_MODEL(   .VAAHV_NPIX(), 
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

                                .TRIGGER0(), //il va falloir les brancher a l'interne!!!
                                .TRIGGER1(), //il va falloir les brancher a l'interne!!!
                                .TRIGGER2(), //il va falloir les brancher a l'interne!!!

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

                                .D_CLK_0_N(HiSPI_clkN[0]),
                                .D_CLK_0_P(HiSPI_clkP[0]),
                                .D_CLK_1_N(HiSPI_clkN[1]),
                                .D_CLK_1_P(HiSPI_clkP[1]),
                                .D_CLK_2_N(HiSPI_clkN[2]),
                                .D_CLK_2_P(HiSPI_clkP[2]),
                                .D_CLK_3_N(HiSPI_clkN[3]),
                                .D_CLK_3_P(HiSPI_clkP[3]),
                                .D_CLK_4_N(HiSPI_clkN[3]),
                                .D_CLK_4_P(HiSPI_clkP[4]),
                                .D_CLK_5_N(HiSPI_clkN[5]),
                                .D_CLK_5_P(HiSPI_clkP[5]),

                                .DATA_0_N (HiSPI_dataN[0]),
                                .DATA_0_P (HiSPI_dataP[0]),
                                .DATA_1_P (HiSPI_dataP[1]),
                                .DATA_1_N (HiSPI_dataN[1]),
                                .DATA_2_P (HiSPI_dataP[2]),                                
                                .DATA_2_N (HiSPI_dataN[2]),                                
                                .DATA_3_P (HiSPI_dataP[3]),
                                .DATA_3_N (HiSPI_dataN[3]),
                                .DATA_4_N (HiSPI_dataN[4]),
                                .DATA_4_P (HiSPI_dataP[4]),
                                .DATA_5_N (HiSPI_dataN[5]),
                                .DATA_5_P (HiSPI_dataP[5]),
                                .DATA_6_N (HiSPI_dataN[6]),
                                .DATA_6_P (HiSPI_dataP[6]),
                                .DATA_7_N (HiSPI_dataN[7]),
                                .DATA_7_P (HiSPI_dataP[7]),
                                .DATA_8_N (HiSPI_dataN[8]),
                                .DATA_8_P (HiSPI_dataP[8]),
                                .DATA_9_N (HiSPI_dataN[9]),
                                .DATA_9_P (HiSPI_dataP[9]),
                                .DATA_10_N(HiSPI_dataN[10]),
                                .DATA_10_P(HiSPI_dataP[10]),
                                .DATA_11_N(HiSPI_dataN[11]),
                                .DATA_11_P(HiSPI_dataP[11]),
                                .DATA_12_N(HiSPI_dataN[12]),
                                .DATA_12_P(HiSPI_dataP[12]),
                                .DATA_13_N(HiSPI_dataN[13]),
                                .DATA_13_P(HiSPI_dataP[13]),
                                .DATA_14_N(HiSPI_dataN[14]),
                                .DATA_14_P(HiSPI_dataP[14]),
                                .DATA_15_N(HiSPI_dataN[15]),
                                .DATA_15_P(HiSPI_dataP[15]),
                                .DATA_16_N(HiSPI_dataN[16]),
                                .DATA_16_P(HiSPI_dataP[16]),
                                .DATA_17_N(HiSPI_dataN[17]),
                                .DATA_17_P(HiSPI_dataP[17]),
                                .DATA_18_N(HiSPI_dataN[18]),
                                .DATA_18_P(HiSPI_dataP[18]),
                                .DATA_19_N(HiSPI_dataN[19]),
                                .DATA_19_P(HiSPI_dataP[19]),
                                .DATA_20_N(HiSPI_dataN[20]),
                                .DATA_20_P(HiSPI_dataP[20]),
                                .DATA_21_N(HiSPI_dataN[21]),
                                .DATA_21_P(HiSPI_dataP[21]),
                                .DATA_22_N(HiSPI_dataN[22]),
                                .DATA_22_P(HiSPI_dataP[22]),
                                .DATA_23_N(HiSPI_dataN[23]),
                                .DATA_23_P(HiSPI_dataP[23])
                                
                                                             
                            );            
            
 
xgs12m_receiver_axi_vip_0_0_mst_t    master_agent;

always #5ns     aclk             = ~aclk;                  //100Mhz regfile
always #2500ps  REFCLK           = ~REFCLK;                //200Mhz ref clk IO
always #15432ps XGS_MODEL_EXTCLK = ~XGS_MODEL_EXTCLK;      //refclk XGS @ 32.4Mhz


initial begin    
   
 
 

    //Create an agent    
    master_agent = new("master vip agent", DUT.xgs12m_receiver_i.axi_vip_0.inst.IF);

    // set tag for agents for easy debug    
    master_agent.set_agent_tag("Master VIP");    
    
    // set print out verbosity level.    
    master_agent.set_verbosity(400);    
    
    //Start the agent    
    master_agent.start_master();    
    
    #50ns
    aresetn = 1;
 

    // MIn XGS model reset is 30 clk, set it to 50
    repeat(50)@(posedge XGS_MODEL_EXTCLK);
    XGS_MODEL_RESET_B = 1'b1;
    #200us
   
   
   
    xgs_spi.ReadXGS_Model(16'h0000, XGS_data_rd);
    if(XGS_data_rd==16'h0058) begin
      $display("XGS Model ID detected is 0x58, XGS12K");
    end
    xgs_spi.ReadXGS_Model(16'h31FE, XGS_data_rd);
    $display("XGS Revision ID detected is %x", XGS_data_rd);
    

    
    //The following registers must be programmed with the specified value to enable test image generation on the HiSPi interface.
    //The commands below specify the register address followed by the register value.
    //In case of I2C, it must use the I2C slave address 0x20/0x21 as defined in the datasheet.
    //- REG Write = 0x3700, 0x001C
     xgs_spi.WriteXGS_Model(16'h3700,16'h001c);
    //- Wait at least 500us for the PLL to start and all clocks to be stable.
    #500us
    //- REG Write = 0x3E3E, 0x0001
    xgs_spi.WriteXGS_Model(16'h3e3e,16'h0001);
    //- REG Write = 0x3E0E, <any value from 0x1 to 0x7>. This selects the testpattern to be sent
    xgs_spi.WriteXGS_Model(16'h3e3e,16'h0001);
    //- Optional : REG Write = 0x3E10, <test_data_red>
    //- Optional : REG Write = 0x3E12, <test_data_greenr>
    //- Optional : REG Write = 0x3E14, <test_data_blue>
    //- Optional : REG Write = 0x3E16, <test_data_greenb>
    //- REG Write = 0x3A06, (0x8000 && <number of clock cycles between the start of two rows>)
    xgs_spi.WriteXGS_Model(16'h3A06,16'h00c8); //200clk
    //- REG Write = 0x3A08, <number of active lines transmitted for a test image frame>
    xgs_spi.WriteXGS_Model(16'h3A08,16'h00c8); //200lines
    //- REG Write = 0x3A0A, 0x8000 && (<number of lines between the last row of the test image and the first row of the next test image> << 6) 
    //                             &&  <number of test image frames to be transmitted> 
    xgs_spi.WriteXGS_Model(16'h3A0A,16'h8002); //8 lines between images, 2 images

    #100ns
    //read GPIO add=0
    master_agent.AXI4LITE_READ_BURST(gpio_addr, prot, data_rd, resp);
    $display("GPIO add=0 data read is %x", data_rd);
    
    #100ns
    //read DECODER 0 add=0
    master_agent.AXI4LITE_READ_BURST(dec0_addr, prot, data_rd, resp);
    $display("DECODER 0 add=0 data read is %x", data_rd);
  
    #100ns
    //read DECODER 1 add=0
    master_agent.AXI4LITE_READ_BURST(dec1_addr, prot, data_rd, resp);
    $display("DECODER 1 add=0 data read is %x", data_rd);
  
    #100ns
    //read HISPI DES 0 add=0
    master_agent.AXI4LITE_READ_BURST(hispi_des0_addr, prot, data_rd, resp);
    $display("HISPI DES 0 add=0 data read is %x", data_rd);
  
    #100ns
    //read HISPI DES 1 add=0
    master_agent.AXI4LITE_READ_BURST(hispi_des1_addr, prot, data_rd, resp);
    $display("HISPI DES 1 add=0 data read is %x", data_rd);
  
    #100ns
    //read TEST PATTERN add=0
    master_agent.AXI4LITE_READ_BURST(test_pat_addr, prot, data_rd, resp);
    $display("TEST PATTERN add=0 data read is %x", data_rd);
  
    #100ns
    //read REMAPER add=0
    master_agent.AXI4LITE_READ_BURST(remap_addr, prot, data_rd, resp);
    $display("REMAPER add=0 data read is %x", data_rd);
    
    #100ns
    //read GPIO add=0
    master_agent.AXI4LITE_READ_BURST(gpio_addr, prot, data_rd, resp);
    $display("GPIO add=0 data read is %x", data_rd);
    
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
     
    #1000ns
    if(data_wr == data_rd)
      $display("Data match, test succeeded");
    else
      $display("Data do not match, test failed");
     
    $finish;
end

endmodule   







interface XGS_PYTHON_IF;
  
  initial begin
    TB_xgs12m_receiver.XGS_MODEL_SCLK  = 0;
    TB_xgs12m_receiver.XGS_MODEL_CS    = 1 ;
    TB_xgs12m_receiver.XGS_MODEL_SDATA = 0;
  end;
  
  //----------------------------------------------
  // 
  //----------------------------------------------
  task automatic WriteXGS_Model(input int add, input int data);

    bit [14:0] model_addr;
    bit [15:0] model_data;
    
    model_addr = add;
    model_data = data;
    
    TB_xgs12m_receiver.XGS_MODEL_SCLK  = 0;
    TB_xgs12m_receiver.XGS_MODEL_CS    = 0 ;
    TB_xgs12m_receiver.XGS_MODEL_SDATA = 0;
    #10ns; 
    
    //SEND ADDRESS
    for(int y = 15; y > 0; y -= 1)
    begin       
      TB_xgs12m_receiver.XGS_MODEL_SCLK  = 0;   
      TB_xgs12m_receiver.XGS_MODEL_CS    = 0;
      TB_xgs12m_receiver.XGS_MODEL_SDATA = model_addr[(y-1)];
      #10ns;    
      TB_xgs12m_receiver.XGS_MODEL_SCLK  = 1;
      #10ns;  
    end
    
    //SEND WRITE TAG
    TB_xgs12m_receiver.XGS_MODEL_SCLK  = 0;   
    TB_xgs12m_receiver.XGS_MODEL_CS    = 0;
    TB_xgs12m_receiver.XGS_MODEL_SDATA = 0;  //Write=0
    #10ns;    
    TB_xgs12m_receiver.XGS_MODEL_SCLK  = 1;
    #10ns;   

    //DATA
    for(int y = 16; y > 0; y -= 1)
    begin       
      TB_xgs12m_receiver.XGS_MODEL_SCLK  = 0;   
      TB_xgs12m_receiver.XGS_MODEL_CS    = 0;
      TB_xgs12m_receiver.XGS_MODEL_SDATA = model_data[(y-1)];
      #10ns;    
      TB_xgs12m_receiver.XGS_MODEL_SCLK  = 1;
      #10ns;  
    end
    
    TB_xgs12m_receiver.XGS_MODEL_SCLK  = 0;
    TB_xgs12m_receiver.XGS_MODEL_CS    = 0;
    TB_xgs12m_receiver.XGS_MODEL_SDATA = 0;
    #10ns;     
    TB_xgs12m_receiver.XGS_MODEL_SCLK  = 0;
    TB_xgs12m_receiver.XGS_MODEL_CS    = 1;
    TB_xgs12m_receiver.XGS_MODEL_SDATA = 0;
    #100ns;     
    
  endtask : WriteXGS_Model

  
  task automatic ReadXGS_Model(input int add, output int data);

    bit [14:0] model_addr;
    bit [15:0] model_data;
    
    model_addr = add;   
    
    TB_xgs12m_receiver.XGS_MODEL_SCLK  = 0;
    TB_xgs12m_receiver.XGS_MODEL_CS    = 0 ;
    TB_xgs12m_receiver.XGS_MODEL_SDATA = 0;
    #10ns; 
    
    //SEND ADDRESS
    for(int y = 15; y > 0; y -= 1)
    begin       
      TB_xgs12m_receiver.XGS_MODEL_SCLK  = 0;   
      TB_xgs12m_receiver.XGS_MODEL_CS    = 0;
      TB_xgs12m_receiver.XGS_MODEL_SDATA = model_addr[(y-1)];
      #10ns;    
      TB_xgs12m_receiver.XGS_MODEL_SCLK  = 1;
      #10ns;  
    end
    
    //SEND READ TAG
    TB_xgs12m_receiver.XGS_MODEL_SCLK  = 0;   
    TB_xgs12m_receiver.XGS_MODEL_CS    = 0;
    TB_xgs12m_receiver.XGS_MODEL_SDATA = 1;  //Read=1
    #10ns;    
    TB_xgs12m_receiver.XGS_MODEL_SCLK  = 1;
    #10ns;   

    //GET DATA
    for(int y = 16; y > 0; y -= 1)
    begin       
      TB_xgs12m_receiver.XGS_MODEL_SCLK  = 0;   
      TB_xgs12m_receiver.XGS_MODEL_CS    = 0;
      TB_xgs12m_receiver.XGS_MODEL_SDATA = 0;  
      #10ns;    
      TB_xgs12m_receiver.XGS_MODEL_SCLK  = 1;
      model_data[(y-1)]                  = TB_xgs12m_receiver.XGS_MODEL_SDATAOUT ;
      #10ns;  
    end
    
    data = model_data ;
    
    TB_xgs12m_receiver.XGS_MODEL_SCLK  = 0;
    TB_xgs12m_receiver.XGS_MODEL_CS    = 0;
    TB_xgs12m_receiver.XGS_MODEL_SDATA = 0;
    #10ns;     
    TB_xgs12m_receiver.XGS_MODEL_SCLK  = 0;
    TB_xgs12m_receiver.XGS_MODEL_CS    = 1;
    TB_xgs12m_receiver.XGS_MODEL_SDATA = 0;
    

    #100ns;     
    
    
  endtask : ReadXGS_Model  
  
endinterface : XGS_PYTHON_IF

 