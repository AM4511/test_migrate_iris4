onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group axi_stream_in2 /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/sclk
add wave -noupdate -expand -group axi_stream_in2 /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/srst_n
add wave -noupdate -expand -group axi_stream_in2 /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/clr_max_line_buffer_cnt
add wave -noupdate -expand -group axi_stream_in2 /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/line_ptr_width
add wave -noupdate -expand -group axi_stream_in2 /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/max_line_buffer_cnt
add wave -noupdate -expand -group axi_stream_in2 /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/pcie_back_pressure_detected
add wave -noupdate -expand -group axi_stream_in2 /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tready
add wave -noupdate -expand -group axi_stream_in2 /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tvalid
add wave -noupdate -expand -group axi_stream_in2 /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tdata
add wave -noupdate -expand -group axi_stream_in2 /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tlast
add wave -noupdate -expand -group axi_stream_in2 /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tuser
add wave -noupdate -expand -group axi_stream_in2 /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/start_of_frame
add wave -noupdate -expand -group axi_stream_in2 /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/line_ready
add wave -noupdate -expand -group axi_stream_in2 /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/line_transfered
add wave -noupdate -expand -group axi_stream_in2 /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/end_of_dma
add wave -noupdate -expand -group axi_stream_in2 /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/line_buffer_read_en
add wave -noupdate -expand -group axi_stream_in2 /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/line_buffer_read_address
add wave -noupdate -expand -group axi_stream_in2 /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/line_buffer_read_data
add wave -noupdate -expand -group axi_stream_in2 /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/wr_state
add wave -noupdate -expand -group axi_stream_in2 /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/wr_line_ptr
add wave -noupdate -expand -group axi_stream_in2 -expand -group sclk_info -expand -group {Write IF} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/sclk_info_wren
add wave -noupdate -expand -group axi_stream_in2 -expand -group sclk_info -expand -group {Write IF} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/sclk_info_wlength
add wave -noupdate -expand -group axi_stream_in2 -expand -group sclk_info -expand -group {Write IF} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/sclk_info_weof
add wave -noupdate -expand -group axi_stream_in2 -expand -group sclk_info -expand -group {Write IF} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/sclk_info_wbuff_id
add wave -noupdate -expand -group axi_stream_in2 -expand -group sclk_info -expand -group {Read IF} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/sclk_info_rden
add wave -noupdate -expand -group axi_stream_in2 -expand -group sclk_info -expand -group {Read IF} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/sclk_info_rlength
add wave -noupdate -expand -group axi_stream_in2 -expand -group sclk_info -expand -group {Read IF} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/sclk_info_reof
add wave -noupdate -expand -group axi_stream_in2 -expand -group sclk_info -expand -group {Read IF} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/sclk_info_rbuff_id
add wave -noupdate -expand -group axi_stream_in2 -expand -group {line buffer} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/buffer_write_en
add wave -noupdate -expand -group axi_stream_in2 -expand -group {line buffer} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/buffer_write_address
add wave -noupdate -expand -group axi_stream_in2 -expand -group {line buffer} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/buffer_write_ptr
add wave -noupdate -expand -group axi_stream_in2 -expand -group {line buffer} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/buffer_write_data
add wave -noupdate -expand -group axi_stream_in2 -expand -group {line buffer} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/buffer_read_en
add wave -noupdate -expand -group axi_stream_in2 -expand -group {line buffer} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/buffer_read_address
add wave -noupdate -expand -group axi_stream_in2 -expand -group {line buffer} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/buffer_read_en_P1
add wave -noupdate -expand -group axi_stream_in2 -expand -group {line buffer} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/buffer_read_data
add wave -noupdate -expand -group axi_stream_in2 /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/last_row
add wave -noupdate -expand -group axi_stream_in2 /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/read_sync
add wave -noupdate -expand -group axi_stream_in2 -color {Sky Blue} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/sclk_rd_last_data
add wave -noupdate -expand -group axi_stream_in2 -color Cyan /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/rd_state
add wave -noupdate -expand -group axi_stream_in2 /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/init_line_ptr
add wave -noupdate -expand -group axi_stream_in2 /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/incr_wr_line_ptr
add wave -noupdate -expand -group axi_stream_in2 /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/incr_rd_line_ptr
add wave -noupdate -expand -group axi_stream_in2 /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/rd_line_ptr
add wave -noupdate -expand -group axi_stream_in2 /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/line_ptr_mask
add wave -noupdate -expand -group axi_stream_in2 /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/distance_cntr
add wave -noupdate -expand -group axi_stream_in2 /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/max_distance
add wave -noupdate -expand -group axi_stream_in2 /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/line_buffer_full
add wave -noupdate -expand -group axi_stream_in2 /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/line_buffer_empty
add wave -noupdate -expand -group axi_stream_in2 /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/numb_line_buffer
add wave -noupdate -expand -group axi_stream_in2 /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/sclk_unpack
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5359848000 ps} 1} {{Cursor 2} {7271009805 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 229
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
configure wave -timeline 1
configure wave -timelineunits ns
update
WaveRestoreZoom {4172178991 ps} {4930743855 ps}
