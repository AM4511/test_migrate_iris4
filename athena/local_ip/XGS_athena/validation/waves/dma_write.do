onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group dma_write /testbench/DUT/xdmawr2tlp/xdma_write/sys_clk
add wave -noupdate -expand -group dma_write /testbench/DUT/xdmawr2tlp/xdma_write/sys_reset_n
add wave -noupdate -expand -group dma_write /testbench/DUT/xdmawr2tlp/xdma_write/cfg_bus_mast_en
add wave -noupdate -expand -group dma_write /testbench/DUT/xdmawr2tlp/xdma_write/cfg_setmaxpld
add wave -noupdate -expand -group dma_write -expand -group {DMA Parameters} /testbench/DUT/xdmawr2tlp/xdma_write/host_number_of_plane
add wave -noupdate -expand -group dma_write -expand -group {DMA Parameters} /testbench/DUT/xdmawr2tlp/xdma_write/host_write_address
add wave -noupdate -expand -group dma_write -expand -group {DMA Parameters} /testbench/DUT/xdmawr2tlp/xdma_write/host_line_pitch
add wave -noupdate -expand -group dma_write -expand -group {DMA Parameters} /testbench/DUT/xdmawr2tlp/xdma_write/host_line_size
add wave -noupdate -expand -group dma_write -expand -group {DMA Parameters} /testbench/DUT/xdmawr2tlp/xdma_write/host_reverse_y
add wave -noupdate -expand -group dma_write -group {axi_stream_in I/F} /testbench/DUT/xdmawr2tlp/xdma_write/dma_idle
add wave -noupdate -expand -group dma_write -group {axi_stream_in I/F} /testbench/DUT/xdmawr2tlp/xdma_write/dma_pcie_state
add wave -noupdate -expand -group dma_write -group {axi_stream_in I/F} /testbench/DUT/xdmawr2tlp/xdma_write/start_of_frame
add wave -noupdate -expand -group dma_write -group {axi_stream_in I/F} /testbench/DUT/xdmawr2tlp/xdma_write/line_ready
add wave -noupdate -expand -group dma_write -group {axi_stream_in I/F} /testbench/DUT/xdmawr2tlp/xdma_write/line_transfered
add wave -noupdate -expand -group dma_write -group {axi_stream_in I/F} /testbench/DUT/xdmawr2tlp/xdma_write/end_of_dma
add wave -noupdate -expand -group dma_write -group {axi_stream_in I/F} /testbench/DUT/xdmawr2tlp/xdma_write/read_enable_out
add wave -noupdate -expand -group dma_write -group {axi_stream_in I/F} /testbench/DUT/xdmawr2tlp/xdma_write/read_address
add wave -noupdate -expand -group dma_write -group {axi_stream_in I/F} /testbench/DUT/xdmawr2tlp/xdma_write/read_data
add wave -noupdate -expand -group dma_write /testbench/DUT/xdmawr2tlp/xdma_write/dma_toreach_4kb
add wave -noupdate -expand -group dma_write /testbench/DUT/xdmawr2tlp/xdma_write/dma_maxpayload
add wave -noupdate -expand -group dma_write /testbench/DUT/xdmawr2tlp/xdma_write/dma_maxpayload_static_and_pcie
add wave -noupdate -expand -group dma_write /testbench/DUT/xdmawr2tlp/xdma_write/dma_maxpayload_no_offset
add wave -noupdate -expand -group dma_write /testbench/DUT/xdmawr2tlp/xdma_write/remain_bcnt
add wave -noupdate -expand -group dma_write /testbench/DUT/xdmawr2tlp/xdma_write/bytecnt
add wave -noupdate -expand -group dma_write /testbench/DUT/xdmawr2tlp/xdma_write/dwcnt
add wave -noupdate -expand -group dma_write /testbench/DUT/xdmawr2tlp/xdma_write/curr_dwcnt
add wave -noupdate -expand -group dma_write /testbench/DUT/xdmawr2tlp/xdma_write/data_byte_offset
add wave -noupdate -expand -group dma_write /testbench/DUT/xdmawr2tlp/xdma_write/dw_misalig
add wave -noupdate -expand -group dma_write /testbench/DUT/xdmawr2tlp/xdma_write/ldwbe_misalig
add wave -noupdate -expand -group dma_write /testbench/DUT/xdmawr2tlp/xdma_write/ldwbe_tobe
add wave -noupdate -expand -group dma_write -expand -group FSM -color Gold /testbench/DUT/xdmawr2tlp/xdma_write/nxt_dma_pcie_ctrl_state
add wave -noupdate -expand -group dma_write -expand -group FSM -color Gold /testbench/DUT/xdmawr2tlp/xdma_write/dma_pcie_ctrl_state
add wave -noupdate -expand -group dma_write /testbench/DUT/xdmawr2tlp/xdma_write/end_of_line
add wave -noupdate -expand -group dma_write /testbench/DUT/xdmawr2tlp/xdma_write/line_offset
add wave -noupdate -expand -group dma_write /testbench/DUT/xdmawr2tlp/xdma_write/dma_tlp_addr_buf
add wave -noupdate -expand -group dma_write /testbench/DUT/xdmawr2tlp/xdma_write/nb_pcie_dout
add wave -noupdate -expand -group dma_write /testbench/DUT/xdmawr2tlp/xdma_write/dma_tlp_fdwbe
add wave -noupdate -expand -group dma_write /testbench/DUT/xdmawr2tlp/xdma_write/dma_tlp_ldwbe
add wave -noupdate -expand -group dma_write /testbench/DUT/xdmawr2tlp/xdma_write/line_ready_meta
add wave -noupdate -expand -group dma_write /testbench/DUT/xdmawr2tlp/xdma_write/line_ready_sysclk
add wave -noupdate -expand -group dma_write /testbench/DUT/xdmawr2tlp/xdma_write/end_of_dma_sysclk
add wave -noupdate -expand -group dma_write /testbench/DUT/xdmawr2tlp/xdma_write/first_write_of_line
add wave -noupdate -expand -group dma_write /testbench/DUT/xdmawr2tlp/xdma_write/plane_counter
add wave -noupdate -expand -group dma_write /testbench/DUT/xdmawr2tlp/xdma_write/ram_output_enable
add wave -noupdate -expand -group dma_write /testbench/DUT/xdmawr2tlp/xdma_write/read_data_delayed
add wave -noupdate -expand -group dma_write /testbench/DUT/xdmawr2tlp/xdma_write/byte_shift
add wave -noupdate -expand -group dma_write -expand -group {TLP I/F} /testbench/DUT/xdmawr2tlp/xdma_write/tlp_req_to_send
add wave -noupdate -expand -group dma_write -expand -group {TLP I/F} /testbench/DUT/xdmawr2tlp/xdma_write/tlp_grant
add wave -noupdate -expand -group dma_write -expand -group {TLP I/F} /testbench/DUT/xdmawr2tlp/xdma_write/tlp_fmt_type
add wave -noupdate -expand -group dma_write -expand -group {TLP I/F} /testbench/DUT/xdmawr2tlp/xdma_write/tlp_length_in_dw
add wave -noupdate -expand -group dma_write -expand -group {TLP I/F} /testbench/DUT/xdmawr2tlp/xdma_write/tlp_address
add wave -noupdate -expand -group dma_write -expand -group {TLP I/F} /testbench/DUT/xdmawr2tlp/xdma_write/tlp_ldwbe_fdwbe
add wave -noupdate -expand -group dma_write -expand -group {TLP I/F} /testbench/DUT/xdmawr2tlp/xdma_write/tlp_attr
add wave -noupdate -expand -group dma_write -expand -group {TLP I/F} /testbench/DUT/xdmawr2tlp/xdma_write/tlp_transaction_id
add wave -noupdate -expand -group dma_write -expand -group {TLP I/F} /testbench/DUT/xdmawr2tlp/xdma_write/tlp_byte_count
add wave -noupdate -expand -group dma_write -expand -group {TLP I/F} /testbench/DUT/xdmawr2tlp/xdma_write/tlp_lower_address
add wave -noupdate -expand -group dma_write -expand -group {TLP I/F} /testbench/DUT/xdmawr2tlp/xdma_write/tlp_src_rdy_n
add wave -noupdate -expand -group dma_write -expand -group {TLP I/F} /testbench/DUT/xdmawr2tlp/xdma_write/tlp_dst_rdy_n
add wave -noupdate -expand -group dma_write -expand -group {TLP I/F} /testbench/DUT/xdmawr2tlp/xdma_write/tlp_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1168507529 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 357
configure wave -valuecolwidth 175
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
WaveRestoreZoom {1045565852 ps} {1230423933 ps}
