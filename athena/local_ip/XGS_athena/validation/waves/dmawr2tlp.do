onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group dmawr2tlp /testbench_dmawr2tlp/DUT/axi_clk
add wave -noupdate -expand -group dmawr2tlp /testbench_dmawr2tlp/DUT/axi_reset_n
add wave -noupdate -expand -group dmawr2tlp /testbench_dmawr2tlp/DUT/intevent
add wave -noupdate -expand -group dmawr2tlp /testbench_dmawr2tlp/DUT/context_strb
add wave -noupdate -expand -group dmawr2tlp -group {AXI Register file I/F} /testbench_dmawr2tlp/DUT/s_axi_awaddr
add wave -noupdate -expand -group dmawr2tlp -group {AXI Register file I/F} /testbench_dmawr2tlp/DUT/s_axi_awprot
add wave -noupdate -expand -group dmawr2tlp -group {AXI Register file I/F} /testbench_dmawr2tlp/DUT/s_axi_awvalid
add wave -noupdate -expand -group dmawr2tlp -group {AXI Register file I/F} /testbench_dmawr2tlp/DUT/s_axi_awready
add wave -noupdate -expand -group dmawr2tlp -group {AXI Register file I/F} /testbench_dmawr2tlp/DUT/s_axi_wdata
add wave -noupdate -expand -group dmawr2tlp -group {AXI Register file I/F} /testbench_dmawr2tlp/DUT/s_axi_wstrb
add wave -noupdate -expand -group dmawr2tlp -group {AXI Register file I/F} /testbench_dmawr2tlp/DUT/s_axi_wvalid
add wave -noupdate -expand -group dmawr2tlp -group {AXI Register file I/F} /testbench_dmawr2tlp/DUT/s_axi_wready
add wave -noupdate -expand -group dmawr2tlp -group {AXI Register file I/F} /testbench_dmawr2tlp/DUT/s_axi_bresp
add wave -noupdate -expand -group dmawr2tlp -group {AXI Register file I/F} /testbench_dmawr2tlp/DUT/s_axi_bvalid
add wave -noupdate -expand -group dmawr2tlp -group {AXI Register file I/F} /testbench_dmawr2tlp/DUT/s_axi_bready
add wave -noupdate -expand -group dmawr2tlp -group {AXI Register file I/F} /testbench_dmawr2tlp/DUT/s_axi_araddr
add wave -noupdate -expand -group dmawr2tlp -group {AXI Register file I/F} /testbench_dmawr2tlp/DUT/s_axi_arprot
add wave -noupdate -expand -group dmawr2tlp -group {AXI Register file I/F} /testbench_dmawr2tlp/DUT/s_axi_arvalid
add wave -noupdate -expand -group dmawr2tlp -group {AXI Register file I/F} /testbench_dmawr2tlp/DUT/s_axi_arready
add wave -noupdate -expand -group dmawr2tlp -group {AXI Register file I/F} /testbench_dmawr2tlp/DUT/s_axi_rdata
add wave -noupdate -expand -group dmawr2tlp -group {AXI Register file I/F} /testbench_dmawr2tlp/DUT/s_axi_rresp
add wave -noupdate -expand -group dmawr2tlp -group {AXI Register file I/F} /testbench_dmawr2tlp/DUT/s_axi_rvalid
add wave -noupdate -expand -group dmawr2tlp -group {AXI Register file I/F} /testbench_dmawr2tlp/DUT/s_axi_rready
add wave -noupdate -expand -group dmawr2tlp -group {AXI Stream Slave I/F} /testbench_dmawr2tlp/DUT/s_axis_tready
add wave -noupdate -expand -group dmawr2tlp -group {AXI Stream Slave I/F} /testbench_dmawr2tlp/DUT/s_axis_tvalid
add wave -noupdate -expand -group dmawr2tlp -group {AXI Stream Slave I/F} /testbench_dmawr2tlp/DUT/s_axis_tdata
add wave -noupdate -expand -group dmawr2tlp -group {AXI Stream Slave I/F} /testbench_dmawr2tlp/DUT/s_axis_tuser
add wave -noupdate -expand -group dmawr2tlp -group {AXI Stream Slave I/F} /testbench_dmawr2tlp/DUT/s_axis_tlast
add wave -noupdate -expand -group dmawr2tlp /testbench_dmawr2tlp/DUT/cfg_bus_mast_en
add wave -noupdate -expand -group dmawr2tlp /testbench_dmawr2tlp/DUT/cfg_setmaxpld
add wave -noupdate -expand -group dmawr2tlp /testbench_dmawr2tlp/DUT/reg_read
add wave -noupdate -expand -group dmawr2tlp /testbench_dmawr2tlp/DUT/reg_write
add wave -noupdate -expand -group dmawr2tlp /testbench_dmawr2tlp/DUT/reg_addr
add wave -noupdate -expand -group dmawr2tlp /testbench_dmawr2tlp/DUT/reg_beN
add wave -noupdate -expand -group dmawr2tlp /testbench_dmawr2tlp/DUT/reg_writedata
add wave -noupdate -expand -group dmawr2tlp /testbench_dmawr2tlp/DUT/reg_readdatavalid
add wave -noupdate -expand -group dmawr2tlp /testbench_dmawr2tlp/DUT/reg_readdata
add wave -noupdate -expand -group dmawr2tlp -expand -subitemconfig {/testbench_dmawr2tlp/DUT/regfile.dma -expand} /testbench_dmawr2tlp/DUT/regfile
add wave -noupdate -expand -group dmawr2tlp /testbench_dmawr2tlp/DUT/dma_idle
add wave -noupdate -expand -group dmawr2tlp /testbench_dmawr2tlp/DUT/dma_pcie_state
add wave -noupdate -expand -group dmawr2tlp /testbench_dmawr2tlp/DUT/start_of_frame
add wave -noupdate -expand -group dmawr2tlp /testbench_dmawr2tlp/DUT/line_ready
add wave -noupdate -expand -group dmawr2tlp /testbench_dmawr2tlp/DUT/line_transfered
add wave -noupdate -expand -group dmawr2tlp /testbench_dmawr2tlp/DUT/end_of_dma
add wave -noupdate -expand -group dmawr2tlp /testbench_dmawr2tlp/DUT/line_buffer_read_en
add wave -noupdate -expand -group dmawr2tlp /testbench_dmawr2tlp/DUT/line_buffer_read_address
add wave -noupdate -expand -group dmawr2tlp /testbench_dmawr2tlp/DUT/line_buffer_read_data
add wave -noupdate -expand -group dmawr2tlp /testbench_dmawr2tlp/DUT/dma_context_mapping
add wave -noupdate -expand -group dmawr2tlp /testbench_dmawr2tlp/DUT/dma_context_p0
add wave -noupdate -expand -group dmawr2tlp /testbench_dmawr2tlp/DUT/dma_context_P1
add wave -noupdate -expand -group dmawr2tlp /testbench_dmawr2tlp/DUT/dma_context_mux
add wave -noupdate -expand -group dmawr2tlp -expand -group {TLP I/F} /testbench_dmawr2tlp/DUT/tlp_req_to_send
add wave -noupdate -expand -group dmawr2tlp -expand -group {TLP I/F} /testbench_dmawr2tlp/DUT/tlp_grant
add wave -noupdate -expand -group dmawr2tlp -expand -group {TLP I/F} /testbench_dmawr2tlp/DUT/tlp_fmt_type
add wave -noupdate -expand -group dmawr2tlp -expand -group {TLP I/F} /testbench_dmawr2tlp/DUT/tlp_length_in_dw
add wave -noupdate -expand -group dmawr2tlp -expand -group {TLP I/F} /testbench_dmawr2tlp/DUT/tlp_src_rdy_n
add wave -noupdate -expand -group dmawr2tlp -expand -group {TLP I/F} /testbench_dmawr2tlp/DUT/tlp_dst_rdy_n
add wave -noupdate -expand -group dmawr2tlp -expand -group {TLP I/F} /testbench_dmawr2tlp/DUT/tlp_data
add wave -noupdate -expand -group dmawr2tlp -expand -group {TLP I/F} /testbench_dmawr2tlp/DUT/tlp_address
add wave -noupdate -expand -group dmawr2tlp -expand -group {TLP I/F} /testbench_dmawr2tlp/DUT/tlp_ldwbe_fdwbe
add wave -noupdate -expand -group dmawr2tlp -expand -group {TLP I/F} /testbench_dmawr2tlp/DUT/tlp_attr
add wave -noupdate -expand -group dmawr2tlp -expand -group {TLP I/F} /testbench_dmawr2tlp/DUT/tlp_transaction_id
add wave -noupdate -expand -group dmawr2tlp -expand -group {TLP I/F} /testbench_dmawr2tlp/DUT/tlp_byte_count
add wave -noupdate -expand -group dmawr2tlp -expand -group {TLP I/F} /testbench_dmawr2tlp/DUT/tlp_lower_address
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {13109060 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 259
configure wave -valuecolwidth 339
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 1
configure wave -timelineunits ns
update
WaveRestoreZoom {11588127 ps} {15528626 ps}
