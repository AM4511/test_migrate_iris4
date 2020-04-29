//////////////////////////////////////////////////////////////////////////////////////
//
// PCIE2AXI master validation testbench
//
//
//
//////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps

import axi_mm_pkg::*;

module testbench();
   
	///////////////////////////////////////////////////////////////
	// Simulation parameters declaration
	///////////////////////////////////////////////////////////////
	parameter NUMB_IRQ = 64;
	parameter AXI_ID_WIDTH = 6;
	parameter AXI_DATA_WIDTH=32;
	parameter AXI_ADDR_WIDTH=32;
   
	///////////////////////////////////////////////////////////////
	// Interconnect signals and interfaces declaration
	///////////////////////////////////////////////////////////////
	logic   pcie_sys_rst_n;
	logic   pcie_sys_clk_p;
	logic   pcie_sys_clk_n;
	logic   pci_exp_rxp;
	logic   pci_exp_rxn;
	logic   pci_exp_txp;
	logic   pci_exp_txn;

	logic       axi_clk;
	logic [NUMB_IRQ-1:0] irq_event;
   
	Caxi_mm_slave #(AXI_ID_WIDTH,AXI_DATA_WIDTH,AXI_ADDR_WIDTH) model_axi_slave;
	axi_mm_interface #(AXI_ID_WIDTH,AXI_DATA_WIDTH,AXI_ADDR_WIDTH) axi_if(axi_clk);

	
	///////////////////////////////////////////////////////////////
	// NSYS pcie model instantiation
	///////////////////////////////////////////////////////////////
	modelPCIe #(
			.SIM_BASE_PATH("."), 
			.UBUS_BADDR(16'h1000), 
			.UBUS_SIZE(256), 
			.REF_CLOCK(100), 
			.PCIE_LANE_COUNT(1),
			.NUM_GPIN(1),
			.NUM_GPOUT(NUMB_IRQ)
		)
		pcie_model (
			.pcie_sys_rst_n(pcie_sys_rst_n),
			.pcie_sys_clk_p(pcie_sys_clk_p),
			.pcie_sys_clk_n(pcie_sys_clk_n),
			.pcie_rx_p(pci_exp_txp),
			.pcie_rx_n(pci_exp_txn),
			.pcie_tx_p(pci_exp_rxp),
			.pcie_tx_n(pci_exp_rxn),
			.gpio_in(1'b0),
			.gpio_out(irq_event)
		);

   
	///////////////////////////////////////////////////////////////
	// PCIE2AXI master DUT instantiation
	///////////////////////////////////////////////////////////////
	pcie2AxiMaster #(
			.NUMB_IRQ(NUMB_IRQ),
			.PCIE_VENDOR_ID(16'h102B),
			.PCIE_DEVICE_ID(16'haaaa),
			.PCIE_REV_ID(8'h55),
			.PCIE_SUBSYS_VENDOR_ID(16'h102B),
			.PCIE_SUBSYS_ID(16'habcd),
			.AXI_ID_WIDTH(AXI_ID_WIDTH),
			.DEBUG_IN_WIDTH(8),
			.DEBUG_OUT_WIDTH(8)
		) 
		dut
		(
			.pcie_sys_rst_n(pcie_sys_rst_n),
			.pcie_sys_clk(pcie_sys_clk_p),  
			.pcie_rxp(pci_exp_rxp),   
			.pcie_rxn(pci_exp_rxn),   
			.pcie_txp(pci_exp_txp),   
			.pcie_txn(pci_exp_txn),   
			.fpga_build_id('hdeadbeef),
			.fpga_major_ver(8'haa),
			.fpga_minor_ver(8'hbb),
			.fpga_sub_minor_ver(8'hcc),
			.fpga_firmware_type(8'h00),
			.fpga_device_id(8'h00),
			.board_info(4'h0),
			.debug_in(8'h00),
			.debug_out(),
			.spi_cs_n(),
			.spi_sdout(),
			.spi_sdin(1'b0),
			.irq_event(irq_event),
			.axim_clk(axi_clk),   
			.axim_rst_n(axi_if.areset_n), 
			.axim_awready(axi_if.awready), 
			.axim_awvalid(axi_if.awvalid), 
			.axim_awid(axi_if.awid),
			.axim_awaddr(axi_if.awaddr),  
			.axim_awlen(axi_if.awlen),   
			.axim_awsize(axi_if.awsize),  
			.axim_awburst(axi_if.awburst),
			.axim_awlock(axi_if.awlock),
			.axim_awcache(axi_if.awcache),
			.axim_awprot(axi_if.awprot),  
			.axim_awqos(axi_if.awqos),
			.axim_wready(axi_if.wready), 
			.axim_wvalid(axi_if.wvalid), 
			.axim_wid(axi_if.wid),
			.axim_wdata(axi_if.wdata),  
			.axim_wstrb(axi_if.wstrb),  
			.axim_wlast(axi_if.wlast),  
			.axim_bvalid(axi_if.bvalid), 
			.axim_bready(axi_if.bready), 
			.axim_bid(axi_if.bid),
			.axim_bresp(axi_if.bresp),  
			.axim_arready(axi_if.arready), 
			.axim_arvalid(axi_if.arvalid), 
			.axim_arid(axi_if.arid),
			.axim_araddr(axi_if.araddr),  
			.axim_arlen(axi_if.arlen),   
			.axim_arsize(axi_if.arsize),  
			.axim_arburst(axi_if.arburst),
			.axim_arlock(axi_if.arlock),
			.axim_arcache(axi_if.arcache),
			.axim_arprot(axi_if.arprot),
			.axim_arqos(axi_if.arqos),
			.axim_rready(axi_if.rready), 
			.axim_rvalid(axi_if.rvalid), 
			.axim_rid(axi_if.rid),
			.axim_rdata(axi_if.rdata), 
			.axim_rresp(axi_if.rresp),  
			.axim_rlast(axi_if.rlast) 
		);

   
	initial begin
		// Call the AXI slave model constructor
		// And start it (infinite while loop)
		model_axi_slave =  new(axi_if);
		model_axi_slave.run();
	end

endmodule
