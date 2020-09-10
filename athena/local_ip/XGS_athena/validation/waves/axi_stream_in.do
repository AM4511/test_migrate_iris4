onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group axi_stream_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/sclk
add wave -noupdate -expand -group axi_stream_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/srst_n
add wave -noupdate -expand -group axi_stream_in -expand -group {AXI Stream input port} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tready
add wave -noupdate -expand -group axi_stream_in -expand -group {AXI Stream input port} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tvalid
add wave -noupdate -expand -group axi_stream_in -expand -group {AXI Stream input port} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tdata
add wave -noupdate -expand -group axi_stream_in -expand -group {AXI Stream input port} -color Gold /testbench/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tlast
add wave -noupdate -expand -group axi_stream_in -expand -group {AXI Stream input port} -expand /testbench/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tuser
add wave -noupdate -expand -group axi_stream_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/numb_line_buffer
add wave -noupdate -expand -group axi_stream_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/state
add wave -noupdate -expand -group axi_stream_in -expand -group {Line ptr} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/line_ptr_mask
add wave -noupdate -expand -group axi_stream_in -expand -group {Line ptr} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/init_line_ptr
add wave -noupdate -expand -group axi_stream_in -expand -group {Line ptr} -color Cyan /testbench/DUT/xdmawr2tlp/xaxi_stream_in/incr_wr_line_ptr
add wave -noupdate -expand -group axi_stream_in -expand -group {Line ptr} -color Cyan /testbench/DUT/xdmawr2tlp/xaxi_stream_in/incr_rd_line_ptr
add wave -noupdate -expand -group axi_stream_in -expand -group {Line ptr} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/rd_line_ptr
add wave -noupdate -expand -group axi_stream_in -expand -group {Line ptr} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/rd_word_ptr
add wave -noupdate -expand -group axi_stream_in -expand -group {Line ptr} -expand /testbench/DUT/xdmawr2tlp/xaxi_stream_in/distance_cntr
add wave -noupdate -expand -group axi_stream_in -expand -group {Line ptr} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/line_buffer_full
add wave -noupdate -expand -group axi_stream_in -expand -group {Line ptr} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/line_buffer_empty
add wave -noupdate -expand -group axi_stream_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/read_sync
add wave -noupdate -expand -group axi_stream_in -expand -group {Buffer Write I/F} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/wr_line_ptr
add wave -noupdate -expand -group axi_stream_in -expand -group {Buffer Write I/F} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/wr_word_ptr
add wave -noupdate -expand -group axi_stream_in -expand -group {Buffer Write I/F} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/buffer_write_en
add wave -noupdate -expand -group axi_stream_in -expand -group {Buffer Write I/F} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/buffer_write_address
add wave -noupdate -expand -group axi_stream_in -expand -group {Buffer Write I/F} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/buffer_write_ptr
add wave -noupdate -expand -group axi_stream_in -expand -group {Buffer Write I/F} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/buffer_write_data
add wave -noupdate -expand -group axi_stream_in -expand -group {Buffer Read I/F} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/buffer_read_en
add wave -noupdate -expand -group axi_stream_in -expand -group {Buffer Read I/F} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/buffer_read_address
add wave -noupdate -expand -group axi_stream_in -expand -group {Buffer Read I/F} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/buffer_read_data
add wave -noupdate -expand -group axi_stream_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/output_state
add wave -noupdate -expand -group axi_stream_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/last_row
add wave -noupdate -expand -group axi_stream_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/wait_line_flushed
add wave -noupdate -expand -group axi_stream_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/back_pressure_cntr
add wave -noupdate -expand -group axi_stream_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/max_back_pressure
add wave -noupdate -expand -group axi_stream_in -expand -group {DMA I/F} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/start_of_frame
add wave -noupdate -expand -group axi_stream_in -expand -group {DMA I/F} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/line_ready
add wave -noupdate -expand -group axi_stream_in -expand -group {DMA I/F} -color Gold /testbench/DUT/xdmawr2tlp/xaxi_stream_in/line_transfered
add wave -noupdate -expand -group axi_stream_in -expand -group {DMA I/F} -color {Medium Slate Blue} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/end_of_dma
add wave -noupdate -expand -group axi_stream_in -expand -group {DMA I/F} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/line_buffer_read_en
add wave -noupdate -expand -group axi_stream_in -expand -group {DMA I/F} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/line_buffer_read_address
add wave -noupdate -expand -group axi_stream_in -expand -group {DMA I/F} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/line_buffer_read_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1548696000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 237
configure wave -valuecolwidth 176
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
WaveRestoreZoom {1139809775 ps} {1380161887 ps}
