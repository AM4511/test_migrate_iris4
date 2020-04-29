onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider tlp_to_axi_master
add wave -noupdate /testbench/dut/xtlp_to_axi_master/sys_clk
add wave -noupdate /testbench/dut/xtlp_to_axi_master/sys_reset_n
add wave -noupdate -divider {TLP IN Interface}
add wave -noupdate /testbench/dut/xtlp_to_axi_master/tlp_in_valid
add wave -noupdate /testbench/dut/xtlp_to_axi_master/tlp_in_abort
add wave -noupdate /testbench/dut/xtlp_to_axi_master/tlp_in_accept_data
add wave -noupdate /testbench/dut/xtlp_to_axi_master/tlp_in_fmt_type
add wave -noupdate /testbench/dut/xtlp_to_axi_master/tlp_in_address
add wave -noupdate /testbench/dut/xtlp_to_axi_master/tlp_in_length_in_dw
add wave -noupdate /testbench/dut/xtlp_to_axi_master/tlp_in_attr
add wave -noupdate /testbench/dut/xtlp_to_axi_master/tlp_in_transaction_id
add wave -noupdate /testbench/dut/xtlp_to_axi_master/tlp_in_data
add wave -noupdate /testbench/dut/xtlp_to_axi_master/tlp_in_byte_en
add wave -noupdate /testbench/dut/xtlp_to_axi_master/tlp_in_byte_count
add wave -noupdate -divider {TLP OUT Interface}
add wave -noupdate /testbench/dut/xtlp_to_axi_master/tlp_out_req_to_send
add wave -noupdate /testbench/dut/xtlp_to_axi_master/tlp_out_grant
add wave -noupdate /testbench/dut/xtlp_to_axi_master/tlp_out_fmt_type
add wave -noupdate /testbench/dut/xtlp_to_axi_master/tlp_out_length_in_dw
add wave -noupdate /testbench/dut/xtlp_to_axi_master/tlp_out_src_rdy_n
add wave -noupdate /testbench/dut/xtlp_to_axi_master/tlp_out_dst_rdy_n
add wave -noupdate /testbench/dut/xtlp_to_axi_master/tlp_out_data
add wave -noupdate /testbench/dut/xtlp_to_axi_master/tlp_out_address
add wave -noupdate /testbench/dut/xtlp_to_axi_master/tlp_out_ldwbe_fdwbe
add wave -noupdate /testbench/dut/xtlp_to_axi_master/tlp_out_attr
add wave -noupdate /testbench/dut/xtlp_to_axi_master/tlp_out_transaction_id
add wave -noupdate /testbench/dut/xtlp_to_axi_master/tlp_out_byte_count
add wave -noupdate /testbench/dut/xtlp_to_axi_master/tlp_out_lower_address
add wave -noupdate /testbench/dut/xtlp_to_axi_master/tlp_timeout_value
add wave -noupdate /testbench/dut/xtlp_to_axi_master/tlp_abort_cntr_init
add wave -noupdate /testbench/dut/xtlp_to_axi_master/tlp_abort_cntr_value
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axi_window
add wave -noupdate -divider System
add wave -noupdate /testbench/dut/xtlp_to_axi_master/sys_reset
add wave -noupdate -divider FSM
add wave -noupdate /testbench/dut/xtlp_to_axi_master/nxtState
add wave -noupdate /testbench/dut/xtlp_to_axi_master/state
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axi_aw_ack
add wave -noupdate /testbench/dut/xtlp_to_axi_master/isWrite
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axi_awid
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axi_awaddr
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axi_awlen
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axi_awvalid
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axi_wdata
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axi_wstrb
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axi_wlast
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axi_wvalid
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axi_bready
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axi_arid
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axi_araddr
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axi_arlen
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axi_arvalid
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axi_rready
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axi_w_ack
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axi_b_ack
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axi_ar_ack
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axi_r_ack
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axi_translated_address
add wave -noupdate /testbench/dut/xtlp_to_axi_master/dw_burst_counter
add wave -noupdate /testbench/dut/xtlp_to_axi_master/load_tlp_data
add wave -noupdate /testbench/dut/xtlp_to_axi_master/compl_req
add wave -noupdate /testbench/dut/xtlp_to_axi_master/compl_pending
add wave -noupdate /testbench/dut/xtlp_to_axi_master/window_en
add wave -noupdate /testbench/dut/xtlp_to_axi_master/hit_window
add wave -noupdate /testbench/dut/xtlp_to_axi_master/timeout_cntr
add wave -noupdate /testbench/dut/xtlp_to_axi_master/transaction_timeout
add wave -noupdate /testbench/dut/xtlp_to_axi_master/timeout_cntr_init
add wave -noupdate /testbench/dut/xtlp_to_axi_master/tlp_abort_cntr
add wave -noupdate -divider {AXI Write address Channel}
add wave -noupdate -color {Cornflower Blue} /testbench/dut/xtlp_to_axi_master/axim_awready
add wave -noupdate -color {Cornflower Blue} /testbench/dut/xtlp_to_axi_master/axim_awvalid
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axim_awid
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axim_awaddr
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axim_awlen
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axim_awsize
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axim_awburst
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axim_awlock
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axim_awcache
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axim_awprot
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axim_awqos
add wave -noupdate -divider {AXI Write data Channel}
add wave -noupdate -color {Blue Violet} /testbench/dut/xtlp_to_axi_master/axim_wready
add wave -noupdate -color {Blue Violet} /testbench/dut/xtlp_to_axi_master/axim_wvalid
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axim_wdata
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axim_wstrb
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axim_wlast
add wave -noupdate -divider {AXI Write response Channel}
add wave -noupdate -color Pink /testbench/dut/xtlp_to_axi_master/axim_bvalid
add wave -noupdate -color Pink /testbench/dut/xtlp_to_axi_master/axim_bready
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axim_bid
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axim_bresp
add wave -noupdate -divider {AXI Read address Channel}
add wave -noupdate -color Magenta /testbench/dut/xtlp_to_axi_master/axim_arready
add wave -noupdate -color Magenta /testbench/dut/xtlp_to_axi_master/axim_arvalid
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axim_arid
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axim_araddr
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axim_arlen
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axim_arsize
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axim_arburst
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axim_arlock
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axim_arcache
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axim_arprot
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axim_arqos
add wave -noupdate -divider {AXI Read response Channel}
add wave -noupdate -color Violet /testbench/dut/xtlp_to_axi_master/axim_rready
add wave -noupdate -color Violet /testbench/dut/xtlp_to_axi_master/axim_rvalid
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axim_rid
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axim_rdata
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axim_rresp
add wave -noupdate /testbench/dut/xtlp_to_axi_master/axim_rlast
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {776364513 fs} 0}
quietly wave cursor active 0
configure wave -namecolwidth 261
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 fs} {2566929495 fs}
