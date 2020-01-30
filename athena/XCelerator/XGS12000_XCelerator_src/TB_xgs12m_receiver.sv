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
 
 bit [15:0] test_number_frames;  
 bit [15:0] test_active_lines;
 bit [15:0] test_blank_lines;
 bit [15:0] test_fixed_data;
 
 wire Vcc  = 1;
 wire Grnd = 0; 
  
 bit XGS_MODEL_EXTCLK  = 0;
 bit XGS_MODEL_RESET_B = 0;

 wire [5:0]  Sensor_HiSPI_clkP;
 wire [5:0]  Sensor_HiSPI_clkN;
 wire [23:0] Sensor_HiSPI_dataP;
 wire [23:0] Sensor_HiSPI_dataN;
 
 wire Top_HiSPI_clkP;
 wire Top_HiSPI_clkN;
 wire [11:0] Top_HiSPI_dataP;
 wire [11:0] Top_HiSPI_dataN; 
 
 wire Bottom_HiSPI_clkP;
 wire Bottom_HiSPI_clkN;
 wire [11:0] Bottom_HiSPI_dataP;
 wire [11:0] Bottom_HiSPI_dataN;
 
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
                                .M_AXIS_tready(Vcc),
                                .M_AXIS_tstrb(),
                                .M_AXIS_tuser(),
                                .M_AXIS_tvalid(),

                                .xgs_bus_0_d_clk_n(Top_HiSPI_clkN),
                                .xgs_bus_0_d_clk_p(Top_HiSPI_clkP),                                                               
                                .xgs_bus_0_data_n(Top_HiSPI_dataN),
                                .xgs_bus_0_data_p(Top_HiSPI_dataP),
                                
                                .xgs_bus_1_d_clk_n(Bottom_HiSPI_clkN),
                                .xgs_bus_1_d_clk_p(Bottom_HiSPI_clkP),                                                                                                                           
                                .xgs_bus_1_data_n(Bottom_HiSPI_dataN),
                                .xgs_bus_1_data_p(Bottom_HiSPI_dataP)                            
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

                                .D_CLK_0_N(Sensor_HiSPI_clkN[0]),
                                .D_CLK_0_P(Sensor_HiSPI_clkP[0]),
                                .D_CLK_1_N(Sensor_HiSPI_clkN[1]),
                                .D_CLK_1_P(Sensor_HiSPI_clkP[1]),
                                .D_CLK_2_N(Sensor_HiSPI_clkN[2]),
                                .D_CLK_2_P(Sensor_HiSPI_clkP[2]),
                                .D_CLK_3_N(Sensor_HiSPI_clkN[3]),
                                .D_CLK_3_P(Sensor_HiSPI_clkP[3]),
                                .D_CLK_4_N(Sensor_HiSPI_clkN[4]),
                                .D_CLK_4_P(Sensor_HiSPI_clkP[4]),
                                .D_CLK_5_N(Sensor_HiSPI_clkN[5]),
                                .D_CLK_5_P(Sensor_HiSPI_clkP[5]),

                                .DATA_0_N (Sensor_HiSPI_dataN[0]),
                                .DATA_0_P (Sensor_HiSPI_dataP[0]),
                                .DATA_1_P (Sensor_HiSPI_dataP[1]),
                                .DATA_1_N (Sensor_HiSPI_dataN[1]),
                                .DATA_2_P (Sensor_HiSPI_dataP[2]),                                
                                .DATA_2_N (Sensor_HiSPI_dataN[2]),                                
                                .DATA_3_P (Sensor_HiSPI_dataP[3]),
                                .DATA_3_N (Sensor_HiSPI_dataN[3]),
                                .DATA_4_N (Sensor_HiSPI_dataN[4]),
                                .DATA_4_P (Sensor_HiSPI_dataP[4]),
                                .DATA_5_N (Sensor_HiSPI_dataN[5]),
                                .DATA_5_P (Sensor_HiSPI_dataP[5]),
                                .DATA_6_N (Sensor_HiSPI_dataN[6]),
                                .DATA_6_P (Sensor_HiSPI_dataP[6]),
                                .DATA_7_N (Sensor_HiSPI_dataN[7]),
                                .DATA_7_P (Sensor_HiSPI_dataP[7]),
                                .DATA_8_N (Sensor_HiSPI_dataN[8]),
                                .DATA_8_P (Sensor_HiSPI_dataP[8]),
                                .DATA_9_N (Sensor_HiSPI_dataN[9]),
                                .DATA_9_P (Sensor_HiSPI_dataP[9]),
                                .DATA_10_N(Sensor_HiSPI_dataN[10]),
                                .DATA_10_P(Sensor_HiSPI_dataP[10]),
                                .DATA_11_N(Sensor_HiSPI_dataN[11]),
                                .DATA_11_P(Sensor_HiSPI_dataP[11]),
                                .DATA_12_N(Sensor_HiSPI_dataN[12]),
                                .DATA_12_P(Sensor_HiSPI_dataP[12]),
                                .DATA_13_N(Sensor_HiSPI_dataN[13]),
                                .DATA_13_P(Sensor_HiSPI_dataP[13]),
                                .DATA_14_N(Sensor_HiSPI_dataN[14]),
                                .DATA_14_P(Sensor_HiSPI_dataP[14]),
                                .DATA_15_N(Sensor_HiSPI_dataN[15]),
                                .DATA_15_P(Sensor_HiSPI_dataP[15]),
                                .DATA_16_N(Sensor_HiSPI_dataN[16]),
                                .DATA_16_P(Sensor_HiSPI_dataP[16]),
                                .DATA_17_N(Sensor_HiSPI_dataN[17]),
                                .DATA_17_P(Sensor_HiSPI_dataP[17]),
                                .DATA_18_N(Sensor_HiSPI_dataN[18]),
                                .DATA_18_P(Sensor_HiSPI_dataP[18]),
                                .DATA_19_N(Sensor_HiSPI_dataN[19]),
                                .DATA_19_P(Sensor_HiSPI_dataP[19]),
                                .DATA_20_N(Sensor_HiSPI_dataN[20]),
                                .DATA_20_P(Sensor_HiSPI_dataP[20]),
                                .DATA_21_N(Sensor_HiSPI_dataN[21]),
                                .DATA_21_P(Sensor_HiSPI_dataP[21]),
                                .DATA_22_N(Sensor_HiSPI_dataN[22]),
                                .DATA_22_P(Sensor_HiSPI_dataP[22]),
                                .DATA_23_N(Sensor_HiSPI_dataN[23]),
                                .DATA_23_P(Sensor_HiSPI_dataP[23])
                                
                                                             
                            );            
            
 
 
 
 //-----------------------
 // HiSPI : TOP
 //-----------------------
 assign Top_HiSPI_clkP      = Sensor_HiSPI_clkP[2];
 assign Top_HiSPI_clkN      = Sensor_HiSPI_clkN[2];
 
 assign Top_HiSPI_dataP[0]  = Sensor_HiSPI_dataP[0];
 assign Top_HiSPI_dataP[1]  = Sensor_HiSPI_dataP[2];
 assign Top_HiSPI_dataP[2]  = Sensor_HiSPI_dataP[4];
 assign Top_HiSPI_dataP[3]  = Sensor_HiSPI_dataP[6];
 assign Top_HiSPI_dataP[4]  = Sensor_HiSPI_dataP[8];
 assign Top_HiSPI_dataP[5]  = Sensor_HiSPI_dataP[10];
 assign Top_HiSPI_dataP[6]  = Sensor_HiSPI_dataP[12];
 assign Top_HiSPI_dataP[7]  = Sensor_HiSPI_dataP[14];
 assign Top_HiSPI_dataP[8]  = Sensor_HiSPI_dataP[16];
 assign Top_HiSPI_dataP[9]  = Sensor_HiSPI_dataP[18];
 assign Top_HiSPI_dataP[10] = Sensor_HiSPI_dataP[20];
 assign Top_HiSPI_dataP[11] = Sensor_HiSPI_dataP[22];
 
 assign Top_HiSPI_dataN[0]  = Sensor_HiSPI_dataN[0];
 assign Top_HiSPI_dataN[1]  = Sensor_HiSPI_dataN[2];
 assign Top_HiSPI_dataN[2]  = Sensor_HiSPI_dataN[4];
 assign Top_HiSPI_dataN[3]  = Sensor_HiSPI_dataN[6];
 assign Top_HiSPI_dataN[4]  = Sensor_HiSPI_dataN[8];
 assign Top_HiSPI_dataN[5]  = Sensor_HiSPI_dataN[10];
 assign Top_HiSPI_dataN[6]  = Sensor_HiSPI_dataN[12];
 assign Top_HiSPI_dataN[7]  = Sensor_HiSPI_dataN[14];
 assign Top_HiSPI_dataN[8]  = Sensor_HiSPI_dataN[16];
 assign Top_HiSPI_dataN[9]  = Sensor_HiSPI_dataN[18];
 assign Top_HiSPI_dataN[10] = Sensor_HiSPI_dataN[20];
 assign Top_HiSPI_dataN[11] = Sensor_HiSPI_dataN[22]; 
 
 //-----------------------
 // HiSPI : BOTTOM
 //-----------------------
 assign Bottom_HiSPI_clkP      = Sensor_HiSPI_clkP[3];
 assign Bottom_HiSPI_clkN      = Sensor_HiSPI_clkN[3]; 
 
 assign Bottom_HiSPI_dataP[0]  = Sensor_HiSPI_dataP[1];
 assign Bottom_HiSPI_dataP[1]  = Sensor_HiSPI_dataP[3];
 assign Bottom_HiSPI_dataP[2]  = Sensor_HiSPI_dataP[5];
 assign Bottom_HiSPI_dataP[3]  = Sensor_HiSPI_dataP[7];
 assign Bottom_HiSPI_dataP[4]  = Sensor_HiSPI_dataP[9];
 assign Bottom_HiSPI_dataP[5]  = Sensor_HiSPI_dataP[11];
 assign Bottom_HiSPI_dataP[6]  = Sensor_HiSPI_dataP[13];
 assign Bottom_HiSPI_dataP[7]  = Sensor_HiSPI_dataP[15];
 assign Bottom_HiSPI_dataP[8]  = Sensor_HiSPI_dataP[17];
 assign Bottom_HiSPI_dataP[9]  = Sensor_HiSPI_dataP[19];
 assign Bottom_HiSPI_dataP[10] = Sensor_HiSPI_dataP[21];
 assign Bottom_HiSPI_dataP[11] = Sensor_HiSPI_dataP[23];
 
 assign Bottom_HiSPI_dataN[0]  = Sensor_HiSPI_dataN[1];
 assign Bottom_HiSPI_dataN[1]  = Sensor_HiSPI_dataN[3];
 assign Bottom_HiSPI_dataN[2]  = Sensor_HiSPI_dataN[5];
 assign Bottom_HiSPI_dataN[3]  = Sensor_HiSPI_dataN[7];
 assign Bottom_HiSPI_dataN[4]  = Sensor_HiSPI_dataN[9];
 assign Bottom_HiSPI_dataN[5]  = Sensor_HiSPI_dataN[11];
 assign Bottom_HiSPI_dataN[6]  = Sensor_HiSPI_dataN[13];
 assign Bottom_HiSPI_dataN[7]  = Sensor_HiSPI_dataN[15];
 assign Bottom_HiSPI_dataN[8]  = Sensor_HiSPI_dataN[17];
 assign Bottom_HiSPI_dataN[9]  = Sensor_HiSPI_dataN[19];
 assign Bottom_HiSPI_dataN[10] = Sensor_HiSPI_dataN[21];
 assign Bottom_HiSPI_dataN[11] = Sensor_HiSPI_dataN[23]; 


 
 
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
   
   
    //--------------------------------------------------------
    //
    // READ XGS MODEL ID and REVISION
    //
    //-------------------------------------------------------        
    xgs_spi.ReadXGS_Model(16'h0000, XGS_data_rd);
    if(XGS_data_rd==16'h0058) begin
      $display("XGS Model ID detected is 0x58, XGS12K");
    end
    xgs_spi.ReadXGS_Model(16'h31FE, XGS_data_rd);
    $display("XGS Revision ID detected is %x", XGS_data_rd);
    

    
    //--------------------------------------------------------
    //
    // PROGRAM XGS MODEL PART 1 
    //
    //-------------------------------------------------------    

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
    // Programming HISPI Deserializer 0
    //
    //----------------------------------------       
    
    // XGS DESERIALIZER Programming Sequence
    // Enable FIFO reset ENABLE(0x10) bit 1 set to 1
    master_agent.AXI4LITE_READ_BURST(hispi_des0_addr+32'h00000010, prot, data_rd, resp);
    data_rd=data_rd|32'h00000002;
    master_agent.AXI4LITE_WRITE_BURST(hispi_des0_addr+32'h00000010, prot, data_rd, resp); 
    
    // Disable FIFO reset ENABLE(0x10) bit 1 set to 0
    master_agent.AXI4LITE_READ_BURST(hispi_des0_addr+32'h00000010, prot, data_rd, resp);
    data_rd=data_rd&32'hfffffffd;
    master_agent.AXI4LITE_WRITE_BURST(hispi_des0_addr+32'h00000010, prot, data_rd, resp);    
    
    // Set MANUAL_TAP(0xC) to a desired value, default 0x0000
    master_agent.AXI4LITE_WRITE_BURST(hispi_des0_addr+32'h0000000c, prot, 0, resp);  
    
    // Enable the used channels in the ENABLE_TRAINING(0x08) default 0xFFF (12 channels enabled)
    master_agent.AXI4LITE_WRITE_BURST(hispi_des0_addr+32'h00000008, prot, 32'h00000fff, resp);    
    
    // Configure registers to enable word alignment: set TRAINING(0x04) to the same value as the idle word of the DUT.
    master_agent.AXI4LITE_WRITE_BURST(hispi_des0_addr+32'h00000004, prot, 32'h000003a6, resp);
    
    // Configure the DUT to send out idle words
    // Done! (0x3A6)
    
    // Start the word alignment. Set bit 0 of the COMMAND register to 1. Poll bit 0 of the COMMAND register until it’s 0.
    master_agent.AXI4LITE_WRITE_BURST(hispi_des0_addr+32'h00000000, prot, 32'h00000001, resp);  
    
    //Si je commence tout de suite a poller, le bit de status est encore a 0!!!
    #100ns
    
   
    //----------------------------------------
    //
    // Programming HISPI Deserializer 1
    //
    //----------------------------------------       
    
    // XGS DESERIALIZER Programming Sequence
    // Enable FIFO reset ENABLE(0x10) bit 1 set to 1
    master_agent.AXI4LITE_READ_BURST(hispi_des1_addr+32'h00000010, prot, data_rd, resp);
    data_rd=data_rd|32'h00000002;
    master_agent.AXI4LITE_WRITE_BURST(hispi_des1_addr+32'h00000010, prot, data_rd, resp); 
    
    // Disable FIFO reset ENABLE(0x10) bit 1 set to 0
    master_agent.AXI4LITE_READ_BURST(hispi_des1_addr+32'h00000010, prot, data_rd, resp);
    data_rd=data_rd&32'hfffffffd;
    master_agent.AXI4LITE_WRITE_BURST(hispi_des1_addr+32'h00000010, prot, data_rd, resp);    
    
    // Set MANUAL_TAP(0xC) to a desired value, default 0x0000
    master_agent.AXI4LITE_WRITE_BURST(hispi_des1_addr+32'h0000000c, prot, 0, resp);  
    
    // Enable the used channels in the ENABLE_TRAINING(0x08) default 0xFFF (12 channels enabled)
    master_agent.AXI4LITE_WRITE_BURST(hispi_des1_addr+32'h00000008, prot, 32'h00000fff, resp);    
    
    // Configure registers to enable word alignment: set TRAINING(0x04) to the same value as the idle word of the DUT.
    master_agent.AXI4LITE_WRITE_BURST(hispi_des1_addr+32'h00000004, prot, 32'h000003a6, resp);
    
    // Configure the DUT to send out idle words
    // Done! (0x3A6)
    
    // Start the word alignment. Set bit 0 of the COMMAND register to 1. Poll bit 0 of the COMMAND register until it’s 0.
    master_agent.AXI4LITE_WRITE_BURST(hispi_des1_addr+32'h00000000, prot, 32'h00000001, resp);  
    
    //Si je commence tout de suite a poller, le bit de status est encore a 0!!!
    #100ns
    
    
    //--------------------------------------------------------
    //
    // Programming HISPI Waiting for LOCK FROM 0 and 1
    //
    //--------------------------------------------------------             
    do begin
        master_agent.AXI4LITE_READ_BURST(hispi_des0_addr+32'h00000000, prot, data_rd, resp);
    end
    while(data_rd[0]==1);
    $display("HiSPI Deserializer 0 - locked!!!");
      
    do begin
        master_agent.AXI4LITE_READ_BURST(hispi_des1_addr+32'h00000000, prot, data_rd, resp);
    end
    while(data_rd[0]==1);
    $display("HiSPI Deserializer 0 - locked!!!");
      
    // ENABLE FIFO_EN and EN_DECODER by putting ENABLE(0x10) to 0x05
    master_agent.AXI4LITE_WRITE_BURST(hispi_des0_addr+32'h00000010, prot, 32'h00000005, resp);       
    master_agent.AXI4LITE_WRITE_BURST(hispi_des1_addr+32'h00000010, prot, 32'h00000005, resp); 

        
    
    
    //----------------------------------------
    //
    // Programming Decoder 0
    //
    //----------------------------------------  
    
    //Program SYNC_WORD4 and CHANNEL_SETTINGS to the desired values.
    master_agent.AXI4LITE_WRITE_BURST(dec0_addr+32'h00000004, prot, data_rd, resp); 
    $display("DECODER 0 - SYNC WORD4 SETTINGS READ 0x%x", data_rd);
    //                                                                    EOL   SOL_I SOL_E   EOF   SOF_I SOF_E           
    master_agent.AXI4LITE_WRITE_BURST(dec0_addr+32'h00000004, prot, 32'b0_10100_10000_10001_0_11100_11000_11001, resp); 
    
    
    master_agent.AXI4LITE_WRITE_BURST(dec0_addr+32'h00000008, prot, data_rd, resp); 
    $display("DECODER 0 - CHANNEL SETTINGS READ 0x%X", data_rd);
    master_agent.AXI4LITE_WRITE_BURST(dec0_addr+32'h00000008, prot, 32'b00000000000000_111111111111_0_0_1100, resp); 
    
    
    //Follow all steps to program the deser block
    //DONE!!!!

    //Enable decoder by putting bit 0 of ENABLE register(0x00) to ‘1’
    //
    // Les comiques, dans leur sequence de registres a ecrire ils ne disent pas de enabler l'image! pourtant il le faut!!!
    // [0] Enable decoder
    // [1] write img to AXI
    // [2] write embbeded data to AXI
    // [3] write CRC to AXI
    // [4] Reset Fifo  
    master_agent.AXI4LITE_READ_BURST(dec0_addr+32'h00000000, prot, data_rd, resp);        
    data_rd=data_rd|32'h00000003;
    master_agent.AXI4LITE_WRITE_BURST(dec0_addr+32'h00000000, prot, data_rd, resp); 
    
    
    

    
    //----------------------------------------
    //
    // Programming Decoder 1
    //
    //----------------------------------------  
    
    //Program SYNC_WORD4 and CHANNEL_SETTINGS to the desired values.
    master_agent.AXI4LITE_WRITE_BURST(dec1_addr+32'h00000004, prot, data_rd, resp); 
    $display("DECODER 1 - SYNC WORD4 SETTINGS READ 0x%x", data_rd);
    //                                                                    EOL   SOL_I SOL_E   EOF   SOF_I SOF_E           
    master_agent.AXI4LITE_WRITE_BURST(dec1_addr+32'h00000004, prot, 32'b0_10100_10000_10001_0_11100_11000_11001, resp); 
    
    
    master_agent.AXI4LITE_WRITE_BURST(dec1_addr+32'h00000008, prot, data_rd, resp); 
    $display("DECODER 0 - CHANNEL SETTINGS READ 0x%X", data_rd);
    master_agent.AXI4LITE_WRITE_BURST(dec1_addr+32'h00000008, prot, 32'b00000000000000_111111111111_0_0_1100, resp); 
    
    
    //Follow all steps to program the deser block
    //DONE!!!!

    //Enable decoder by putting bit 0 of ENABLE register(0x00) to ‘1’
    //
    // Les comiques, dans leur sequence de registres a ecrire ils ne disent pas de enabler l'image! pourtant il le faut!!!
    // [0] Enable decoder
    // [1] write img to AXI
    // [2] write embbeded data to AXI
    // [3] write CRC to AXI
    // [4] Reset Fifo  
    master_agent.AXI4LITE_READ_BURST(dec1_addr+32'h00000000, prot, data_rd, resp);        
    data_rd=data_rd|32'h00000003;
    master_agent.AXI4LITE_WRITE_BURST(dec1_addr+32'h00000000, prot, data_rd, resp);     
    
    
    
    
    
    
    
    
 
    //----------------------------------------
    //
    // Programming REMAPPER
    //
    //----------------------------------------  
    
    //Enable Reset the FIFO by toggling bit 1 of the CONFIG register.
    master_agent.AXI4LITE_READ_BURST(remap_addr+32'h00000000, prot, data_rd, resp);
    master_agent.AXI4LITE_WRITE_BURST(remap_addr+32'h00000000, prot, data_rd+32'h00000002, resp);
    master_agent.AXI4LITE_WRITE_BURST(remap_addr+32'h00000000, prot, data_rd, resp);
    
    //Initialize the control BRAM block by toggling bit 5 of the CONFIG register.
    master_agent.AXI4LITE_READ_BURST(remap_addr+32'h00000000, prot, data_rd, resp);
    master_agent.AXI4LITE_WRITE_BURST(remap_addr+32'h00000000, prot, data_rd+32'h00000020, resp);
    master_agent.AXI4LITE_WRITE_BURST(remap_addr+32'h00000000, prot, data_rd, resp);
    
    //Set BRAM_READOUT_MODE, BRAM_PIXEL_0_LANE and REMAP_ENABLE according to your use-case.
    // [4]    REMAP_ENABLE       = 0
    // [6]    BRAM_PIXEL_0_LANE  = 1 : pixel0 is in lane1 ----> En full resolution, ligne paire, le pixel 0 sort sur la lane1!!! voir figure37 spec xgs12m
    // [11:8] BRAM_READOUT_MODE  = Incr readout
    master_agent.AXI4LITE_READ_BURST(remap_addr+32'h00000000, prot, data_rd, resp);
    master_agent.AXI4LITE_WRITE_BURST(remap_addr+32'h00000000, prot, data_rd+32'h00000010 + 32'h00000040 + 32'h00000000, resp);
    
    //Enable the FIFO by putting bit 0 of the CONFIG register (0x00) to ‘1’
    master_agent.AXI4LITE_READ_BURST(remap_addr+32'h00000000, prot, data_rd, resp);
    master_agent.AXI4LITE_WRITE_BURST(remap_addr+32'h00000000, prot, (data_rd|32'h00000001), resp);        
    
    

    //--------------------------------------------------------
    //
    // PROGRAM XGS MODEL PART 2 - Set to output test mode image
    //
    //-------------------------------------------------------        
    // Configure the DUT to capture images.
    // Pas besoin de ceci avec les test pattern du modele du senseur!
    //xgs_spi.WriteXGS_Model(16'h3800,16'h0001); //Enable sequencer

    // REG Write = 0x3E0E, <any value from 0x1 to 0x7>. This selects the testpattern to be sent 
    // 0=jmansill B&W increasing line pixel 0->4095...
    // 1=solid pattern
    // 3=fade t0 black
    // 4=diagonal  gary 1x
    // 5=diagonal  gary 3x
    // ... p.26 de la spec!!!
    xgs_spi.WriteXGS_Model(16'h3e0e,16'h0000);
    
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
    
    //- REG Write = 0x3A06, (0x8000 && <number of clock cycles between the start of two rows>)
    xgs_spi.WriteXGS_Model(16'h3A06,16'h80c8); //200clk
    
    //- REG Write = 0x3A08, <number of active lines transmitted for a test image frame>    
    test_active_lines = 8;  // 1=1line
    xgs_spi.WriteXGS_Model(16'h3A08, test_active_lines); // Cc registre est 1 based
    
    //- REG Write = 0x3A0A, 0x8000 && (<number of lines between the last row of the test image and the first row of the next test image> << 6) 
    //                             &&  <number of test image frames to be transmitted> 
    test_blank_lines = 4;      // 0=1line (correction is bellow)
    test_number_frames   = 5;  // 1=1frame
    xgs_spi.WriteXGS_Model(16'h3A0A,16'h0000 + ((test_blank_lines-1)<<6)  + (test_number_frames) ); 
    xgs_spi.WriteXGS_Model(16'h3A0A,16'h8000 + ((test_blank_lines-1)<<6)  + (test_number_frames) ); 
     
    // XGS MODEL FRAME IS 4176 pixels when test mode !!! 
    // voir p.Figure 37. Pixel Readout Order
    // voir p8 Figure 4. XGS 8000 Pixel Array
    // 4176 = 4 dummy + 24 BL K+ 4 dummy + 4 interpol + 4096 + 4 interpol + 4 dummy + 32 BLK + 4 dummy
    //
    //
    //
    //

     
     
    #250us
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
    TB_xgs12m_receiver.XGS_MODEL_CS    = 0;
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

 