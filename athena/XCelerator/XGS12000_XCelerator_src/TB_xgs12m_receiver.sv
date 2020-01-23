`timescale 1ns / 1ps

//import axi_vip_v1_0_2_pkg::*;
import axi_vip_pkg::*;
import xgs12m_receiver_axi_vip_0_0_pkg::*;

module TB_xgs12m_receiver(  );
 
 bit aclk = 0;
 bit aresetn=0;
 bit REFCLK =0;
 
 bit [3:0] GPIO;
 
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
 
 xil_axi_resp_t resp;
 
 always    #5ns  aclk  = ~aclk;   //100Mhz regfile
 always #2500ps REFCLK =~REFCLK;  //200Mhz ref clk
 
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

                                .xgs_bus_0_d_clk_n(),
                                .xgs_bus_0_d_clk_p(),
                                .xgs_bus_0_data_n(),
                                .xgs_bus_0_data_p(),
                                .xgs_bus_1_d_clk_n(),
                                .xgs_bus_1_d_clk_p(),
                                .xgs_bus_1_data_n(),
                                .xgs_bus_1_data_p()                            
                            );
                    
// Declare agent

//design_1_axi_vip_0_0_mst_t      master_agent;

xgs12m_receiver_axi_vip_0_0_mst_t    master_agent;

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