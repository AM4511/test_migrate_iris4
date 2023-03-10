onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group dmawr2tlp /testbench/system_top/DUT/xdmawr2tlp/sclk
add wave -noupdate -expand -group dmawr2tlp /testbench/system_top/DUT/xdmawr2tlp/srst_n
add wave -noupdate -expand -group dmawr2tlp /testbench/system_top/DUT/xdmawr2tlp/intevent
add wave -noupdate -expand -group dmawr2tlp /testbench/system_top/DUT/xdmawr2tlp/context_strb
add wave -noupdate -expand -group dmawr2tlp /testbench/system_top/DUT/xdmawr2tlp/regfile
add wave -noupdate -expand -group dmawr2tlp -expand -group {AXIS stream input I/F} /testbench/system_top/DUT/xdmawr2tlp/tready
add wave -noupdate -expand -group dmawr2tlp -expand -group {AXIS stream input I/F} /testbench/system_top/DUT/xdmawr2tlp/tvalid
add wave -noupdate -expand -group dmawr2tlp -expand -group {AXIS stream input I/F} /testbench/system_top/DUT/xdmawr2tlp/tdata
add wave -noupdate -expand -group dmawr2tlp -expand -group {AXIS stream input I/F} /testbench/system_top/DUT/xdmawr2tlp/tuser
add wave -noupdate -expand -group dmawr2tlp -expand -group {AXIS stream input I/F} /testbench/system_top/DUT/xdmawr2tlp/tlast
add wave -noupdate -expand -group dmawr2tlp /testbench/system_top/DUT/xdmawr2tlp/cfg_bus_mast_en
add wave -noupdate -expand -group dmawr2tlp /testbench/system_top/DUT/xdmawr2tlp/cfg_setmaxpld
add wave -noupdate -expand -group dmawr2tlp -expand -group {TLP I/F} /testbench/system_top/DUT/xdmawr2tlp/tlp_grant
add wave -noupdate -expand -group dmawr2tlp -expand -group {TLP I/F} /testbench/system_top/DUT/xdmawr2tlp/tlp_fmt_type
add wave -noupdate -expand -group dmawr2tlp -expand -group {TLP I/F} /testbench/system_top/DUT/xdmawr2tlp/tlp_ldwbe_fdwbe
add wave -noupdate -expand -group dmawr2tlp -expand -group {TLP I/F} /testbench/system_top/DUT/xdmawr2tlp/tlp_attr
add wave -noupdate -expand -group dmawr2tlp -expand -group {TLP I/F} /testbench/system_top/DUT/xdmawr2tlp/tlp_transaction_id
add wave -noupdate -expand -group dmawr2tlp -expand -group {TLP I/F} /testbench/system_top/DUT/xdmawr2tlp/tlp_byte_count
add wave -noupdate -expand -group dmawr2tlp -expand -group {TLP I/F} /testbench/system_top/DUT/xdmawr2tlp/tlp_lower_address
add wave -noupdate -expand -group dmawr2tlp -expand -group {TLP I/F} /testbench/system_top/DUT/xdmawr2tlp/tlp_length_in_dw
add wave -noupdate -expand -group dmawr2tlp -expand -group {TLP I/F} /testbench/system_top/DUT/xdmawr2tlp/tlp_req_to_send
add wave -noupdate -expand -group dmawr2tlp -expand -group {TLP I/F} /testbench/system_top/DUT/xdmawr2tlp/tlp_src_rdy_n
add wave -noupdate -expand -group dmawr2tlp -expand -group {TLP I/F} /testbench/system_top/DUT/xdmawr2tlp/tlp_dst_rdy_n
add wave -noupdate -expand -group dmawr2tlp -expand -group {TLP I/F} /testbench/system_top/DUT/xdmawr2tlp/tlp_address
add wave -noupdate -expand -group dmawr2tlp -expand -group {TLP I/F} /testbench/system_top/DUT/xdmawr2tlp/tlp_data
add wave -noupdate -expand -group dmawr2tlp /testbench/system_top/DUT/xdmawr2tlp/dma_idle
add wave -noupdate -expand -group dmawr2tlp /testbench/system_top/DUT/xdmawr2tlp/dma_pcie_state
add wave -noupdate -expand -group dmawr2tlp /testbench/system_top/DUT/xdmawr2tlp/start_of_frame
add wave -noupdate -expand -group dmawr2tlp /testbench/system_top/DUT/xdmawr2tlp/line_ready
add wave -noupdate -expand -group dmawr2tlp /testbench/system_top/DUT/xdmawr2tlp/line_transfered
add wave -noupdate -expand -group dmawr2tlp /testbench/system_top/DUT/xdmawr2tlp/end_of_dma
add wave -noupdate -expand -group dmawr2tlp /testbench/system_top/DUT/xdmawr2tlp/line_buffer_read_en
add wave -noupdate -expand -group dmawr2tlp /testbench/system_top/DUT/xdmawr2tlp/line_buffer_read_address
add wave -noupdate -expand -group dmawr2tlp /testbench/system_top/DUT/xdmawr2tlp/line_buffer_read_data
add wave -noupdate -expand -group dmawr2tlp /testbench/system_top/DUT/xdmawr2tlp/color_space
add wave -noupdate -expand -group dmawr2tlp /testbench/system_top/DUT/xdmawr2tlp/clr_max_line_buffer_cnt
add wave -noupdate -expand -group dmawr2tlp /testbench/system_top/DUT/xdmawr2tlp/line_ptr_width
add wave -noupdate -expand -group dmawr2tlp /testbench/system_top/DUT/xdmawr2tlp/max_line_buffer_cnt
add wave -noupdate -expand -group dmawr2tlp /testbench/system_top/DUT/xdmawr2tlp/pcie_back_pressure_detected
add wave -noupdate -expand -group dmawr2tlp /testbench/system_top/DUT/xdmawr2tlp/dbg_fifo_error
add wave -noupdate -expand -group dmawr2tlp /testbench/system_top/DUT/xdmawr2tlp/context_strb_P1
add wave -noupdate -expand -group dmawr2tlp /testbench/system_top/DUT/xdmawr2tlp/dma_context_mapping
add wave -noupdate -expand -group dmawr2tlp /testbench/system_top/DUT/xdmawr2tlp/dma_context_p0
add wave -noupdate -expand -group dmawr2tlp /testbench/system_top/DUT/xdmawr2tlp/dma_context_P1
add wave -noupdate -expand -group dmawr2tlp /testbench/system_top/DUT/xdmawr2tlp/dma_context_mux
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5656439967 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 227
configure wave -valuecolwidth 146
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
WaveRestoreZoom {5656353313 ps} {5656539751 ps}
