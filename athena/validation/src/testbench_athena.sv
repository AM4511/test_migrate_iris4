`timescale 1ns/1ps

import driver_pkg::*;

module testbench_athena();

 //  parameter master_agent = "DUT.system_i.modelAxiMasterLite_0.inst";
   
   parameter xgs_ctrl_addr   = 32'h00020000;
   parameter AXI_DATA_WIDTH   = 32;
   parameter AXI_ADDR_WIDTH   = 32;
   parameter GPIO_INPUT_WIDTH   = 1;
   parameter GPIO_OUTPUT_WIDTH   = 1;
   
   int axi_address;
   int axi_data;
   int axi_strb;
   int timeout = 10000;
   
   //clock and reset signal declaration
   bit axiClk100MHz;
   bit idelayClk;
   bit axiReset_n;
   bit dma_irq;

   
   Cdriver_axil #(.DATA_WIDTH(AXI_DATA_WIDTH),.ADDR_WIDTH(AXI_ADDR_WIDTH), .NUMB_INPUT_IO(GPIO_INPUT_WIDTH), .NUMB_OUTPUT_IO(GPIO_OUTPUT_WIDTH)) master_agent;

   
   // Interface
   axi_lite_interface #(.DATA_WIDTH(AXI_DATA_WIDTH), .ADDR_WIDTH(AXI_ADDR_WIDTH)) axil(axiClk100MHz);
   io_interface #(.NUMB_INPUT_IO(GPIO_INPUT_WIDTH),.NUMB_OUTPUT_IO(GPIO_OUTPUT_WIDTH)) gpio_if();

   
   // Clock and Reset generation
   always #5 axiClk100MHz = ~axiClk100MHz;
   always #2.5  idelayClk = ~idelayClk;

   
   
   system_wrapper DUT 
     (
      .anput_exposure(),
      .anput_ext_trig(),
      .anput_strobe(),
      .anput_trig_rdy(),
      .axiClk100MHz(axiClk100MHz),
      .axiReset_n(axiReset_n),
      .dma_irq(dma_irq),
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
      .idelayClk(idelayClk),
      .led_out(),
      .s_axil_if_araddr(axil.araddr),
      .s_axil_if_arprot(axil.arprot),
      .s_axil_if_arready(axil.arready),
      .s_axil_if_arvalid(axil.arvalid),
      .s_axil_if_awaddr(axil.awaddr),
      .s_axil_if_awprot(axil.awprot),
      .s_axil_if_awready(axil.awready),
      .s_axil_if_awvalid(axil.awvalid),
      .s_axil_if_bready(axil.bready),
      .s_axil_if_bresp(axil.bresp),
      .s_axil_if_bvalid(axil.bvalid),
      .s_axil_if_rdata(axil.rdata),
      .s_axil_if_rready(axil.rready),
      .s_axil_if_rresp(axil.rresp),
      .s_axil_if_rvalid(axil.rvalid),
      .s_axil_if_wdata(axil.wdata),
      .s_axil_if_wready(axil.wready),
      .s_axil_if_wstrb(axil.wstrb),
      .s_axil_if_wvalid(axil.wvalid)
      );
   
 assign gpio_if.input_io[0] = dma_irq;

   initial 
     begin

	
	//////////////////////////////////////////////////////////
	//
	// Start Simulation
	//
	//////////////////////////////////////////////////////////
	master_agent = new(axil, gpio_if);

	master_agent.reset(100);
	master_agent.wait_n(1000);
	
        master_agent.terminate();

/* -----\/----- EXCLUDED -----\/-----
	master_agent.wait_n(1000);
	master_agent.terminate();
 -----/\----- EXCLUDED -----/\----- */
	
	
/* -----\/----- EXCLUDED -----\/-----
	DUT.system_i.modelAxiMasterLite_0.inst.wait_n(1000);

	
	//////////////////////////////////////////////////////////
	//
	// WakeUP XGS SENSOR : 
	// Remove reset and enable clk to the sensor  SENSOR_POWERUP
	//
	//////////////////////////////////////////////////////////
	//..master_agent.AXI4LITE_WRITE_BURST(axil.nt.AXI4LITE_WRITE_BURST(xgs_ctrl_addr+16'h0190()(), prot, 16'h0003, resp);
	axi_address = xgs_ctrl_addr + 32'h00000190;
	axi_data    = 32'h00000003;
	axi_strb    = 32'h00000001;
	
	DUT.system_i.modelAxiMasterLite_0.inst.write(axi_address,axi_data,axi_strb,timeout);
	
	
	// Check status for Clock enable and reset disable
	do 
	  begin
	     // master_agent.AXI4LITE_READ_BURST(xgs_ctrl_addr+32'h00000198, prot, data_rd, resp);
	     axi_address = xgs_ctrl_addr + 32'h00000198;
	     DUT.system_i.modelAxiMasterLite_0.inst.read(axi_address,axi_data,timeout);
	  end
	while(axi_data&32'h00000001==0); 


	//////////////////////////////////////////////////////////
	//
	// Read XGS MODEL_ID and REVISION
	//
	//////////////////////////////////////////////////////////
/-* -----\/----- EXCLUDED -----\/-----
	XGS_ReadSPI(16'h0000, data_rd);
	if(data_rd==16'h0058) begin
	   $display("XGS Model ID detected is 0x58, XGS12M");
	end
	if(data_rd==16'h0358) begin
	   $display("XGS Model ID detected is 0x358, XGS5M");
	end
 -----/\----- EXCLUDED -----/\----- *-/
 -----/\----- EXCLUDED -----/\----- */
	
 	end

endmodule

