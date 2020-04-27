onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group axi_stream_in /testbench_dmawr2tlp/DUT/xaxi_stream_in/axi_clk
add wave -noupdate -expand -group axi_stream_in /testbench_dmawr2tlp/DUT/xaxi_stream_in/axi_reset_n
add wave -noupdate -expand -group axi_stream_in -expand -group {AXI Stream input} /testbench_dmawr2tlp/DUT/xaxi_stream_in/s_axis_tready
add wave -noupdate -expand -group axi_stream_in -expand -group {AXI Stream input} /testbench_dmawr2tlp/DUT/xaxi_stream_in/s_axis_tvalid
add wave -noupdate -expand -group axi_stream_in -expand -group {AXI Stream input} /testbench_dmawr2tlp/DUT/xaxi_stream_in/s_axis_tdata
add wave -noupdate -expand -group axi_stream_in -expand -group {AXI Stream input} /testbench_dmawr2tlp/DUT/xaxi_stream_in/s_axis_tlast
add wave -noupdate -expand -group axi_stream_in -expand -group {AXI Stream input} /testbench_dmawr2tlp/DUT/xaxi_stream_in/s_axis_tuser
add wave -noupdate -expand -group axi_stream_in /testbench_dmawr2tlp/DUT/xaxi_stream_in/state
add wave -noupdate -expand -group axi_stream_in /testbench_dmawr2tlp/DUT/xaxi_stream_in/buffer_write_en
add wave -noupdate -expand -group axi_stream_in /testbench_dmawr2tlp/DUT/xaxi_stream_in/buffer_write_address
add wave -noupdate -expand -group axi_stream_in /testbench_dmawr2tlp/DUT/xaxi_stream_in/buffer_write_data
add wave -noupdate -expand -group axi_stream_in /testbench_dmawr2tlp/DUT/xaxi_stream_in/buffer_read_en
add wave -noupdate -expand -group axi_stream_in /testbench_dmawr2tlp/DUT/xaxi_stream_in/buffer_read_address
add wave -noupdate -expand -group axi_stream_in /testbench_dmawr2tlp/DUT/xaxi_stream_in/buffer_read_data
add wave -noupdate -expand -group axi_stream_in -expand -group {Line buffer I/F} -color Turquoise /testbench_dmawr2tlp/DUT/xaxi_stream_in/start_of_frame
add wave -noupdate -expand -group axi_stream_in -expand -group {Line buffer I/F} /testbench_dmawr2tlp/DUT/xaxi_stream_in/line_ready
add wave -noupdate -expand -group axi_stream_in -expand -group {Line buffer I/F} -color {Steel Blue} /testbench_dmawr2tlp/DUT/xaxi_stream_in/line_transfered
add wave -noupdate -expand -group axi_stream_in -expand -group {Line buffer I/F} /testbench_dmawr2tlp/DUT/xaxi_stream_in/end_of_dma
add wave -noupdate -expand -group axi_stream_in -expand -group {Line buffer I/F} /testbench_dmawr2tlp/DUT/xaxi_stream_in/line_buffer_read_en
add wave -noupdate -expand -group axi_stream_in -expand -group {Line buffer I/F} /testbench_dmawr2tlp/DUT/xaxi_stream_in/line_buffer_read_address
add wave -noupdate -expand -group axi_stream_in -expand -group {Line buffer I/F} /testbench_dmawr2tlp/DUT/xaxi_stream_in/line_buffer_read_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {25341194 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 259
configure wave -valuecolwidth 182
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
WaveRestoreZoom {8253968 ps} {35301587 ps}
