// Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2015.2_AR66788 (win64) Build 1266856 Fri Jun 26 16:35:25 MDT 2015
// Date        : Mon Jun 06 14:47:26 2016
// Host        : jlarin7 running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode synth_stub C:/work/iris3/Ares_A7/mig_core/ddr2/ddr2_stub.v
// Design      : ddr2
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tfgg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module ddr2(ddr2_dq, ddr2_dqs_n, ddr2_dqs_p, ddr2_addr, ddr2_ba, ddr2_ras_n, ddr2_cas_n, ddr2_we_n, ddr2_ck_p, ddr2_ck_n, ddr2_cke, ddr2_dm, ddr2_odt, sys_clk_i, clk_ref_i, ui_clk, ui_clk_sync_rst, mmcm_locked, aresetn, app_sr_req, app_ref_req, app_zq_req, app_sr_active, app_ref_ack, app_zq_ack, s_axi_awid, s_axi_awaddr, s_axi_awlen, s_axi_awsize, s_axi_awburst, s_axi_awlock, s_axi_awcache, s_axi_awprot, s_axi_awqos, s_axi_awvalid, s_axi_awready, s_axi_wdata, s_axi_wstrb, s_axi_wlast, s_axi_wvalid, s_axi_wready, s_axi_bready, s_axi_bid, s_axi_bresp, s_axi_bvalid, s_axi_arid, s_axi_araddr, s_axi_arlen, s_axi_arsize, s_axi_arburst, s_axi_arlock, s_axi_arcache, s_axi_arprot, s_axi_arqos, s_axi_arvalid, s_axi_arready, s_axi_rready, s_axi_rid, s_axi_rdata, s_axi_rresp, s_axi_rlast, s_axi_rvalid, init_calib_complete, sys_rst)
/* synthesis syn_black_box black_box_pad_pin="ddr2_dq[7:0],ddr2_dqs_n[0:0],ddr2_dqs_p[0:0],ddr2_addr[12:0],ddr2_ba[1:0],ddr2_ras_n,ddr2_cas_n,ddr2_we_n,ddr2_ck_p[0:0],ddr2_ck_n[0:0],ddr2_cke[0:0],ddr2_dm[0:0],ddr2_odt[0:0],sys_clk_i,clk_ref_i,ui_clk,ui_clk_sync_rst,mmcm_locked,aresetn,app_sr_req,app_ref_req,app_zq_req,app_sr_active,app_ref_ack,app_zq_ack,s_axi_awid[3:0],s_axi_awaddr[31:0],s_axi_awlen[7:0],s_axi_awsize[2:0],s_axi_awburst[1:0],s_axi_awlock[0:0],s_axi_awcache[3:0],s_axi_awprot[2:0],s_axi_awqos[3:0],s_axi_awvalid,s_axi_awready,s_axi_wdata[31:0],s_axi_wstrb[3:0],s_axi_wlast,s_axi_wvalid,s_axi_wready,s_axi_bready,s_axi_bid[3:0],s_axi_bresp[1:0],s_axi_bvalid,s_axi_arid[3:0],s_axi_araddr[31:0],s_axi_arlen[7:0],s_axi_arsize[2:0],s_axi_arburst[1:0],s_axi_arlock[0:0],s_axi_arcache[3:0],s_axi_arprot[2:0],s_axi_arqos[3:0],s_axi_arvalid,s_axi_arready,s_axi_rready,s_axi_rid[3:0],s_axi_rdata[31:0],s_axi_rresp[1:0],s_axi_rlast,s_axi_rvalid,init_calib_complete,sys_rst" */;
  inout [7:0]ddr2_dq;
  inout [0:0]ddr2_dqs_n;
  inout [0:0]ddr2_dqs_p;
  output [12:0]ddr2_addr;
  output [1:0]ddr2_ba;
  output ddr2_ras_n;
  output ddr2_cas_n;
  output ddr2_we_n;
  output [0:0]ddr2_ck_p;
  output [0:0]ddr2_ck_n;
  output [0:0]ddr2_cke;
  output [0:0]ddr2_dm;
  output [0:0]ddr2_odt;
  input sys_clk_i;
  input clk_ref_i;
  output ui_clk;
  output ui_clk_sync_rst;
  output mmcm_locked;
  input aresetn;
  input app_sr_req;
  input app_ref_req;
  input app_zq_req;
  output app_sr_active;
  output app_ref_ack;
  output app_zq_ack;
  input [3:0]s_axi_awid;
  input [31:0]s_axi_awaddr;
  input [7:0]s_axi_awlen;
  input [2:0]s_axi_awsize;
  input [1:0]s_axi_awburst;
  input [0:0]s_axi_awlock;
  input [3:0]s_axi_awcache;
  input [2:0]s_axi_awprot;
  input [3:0]s_axi_awqos;
  input s_axi_awvalid;
  output s_axi_awready;
  input [31:0]s_axi_wdata;
  input [3:0]s_axi_wstrb;
  input s_axi_wlast;
  input s_axi_wvalid;
  output s_axi_wready;
  input s_axi_bready;
  output [3:0]s_axi_bid;
  output [1:0]s_axi_bresp;
  output s_axi_bvalid;
  input [3:0]s_axi_arid;
  input [31:0]s_axi_araddr;
  input [7:0]s_axi_arlen;
  input [2:0]s_axi_arsize;
  input [1:0]s_axi_arburst;
  input [0:0]s_axi_arlock;
  input [3:0]s_axi_arcache;
  input [2:0]s_axi_arprot;
  input [3:0]s_axi_arqos;
  input s_axi_arvalid;
  output s_axi_arready;
  input s_axi_rready;
  output [3:0]s_axi_rid;
  output [31:0]s_axi_rdata;
  output [1:0]s_axi_rresp;
  output s_axi_rlast;
  output s_axi_rvalid;
  output init_calib_complete;
  input sys_rst;
endmodule
