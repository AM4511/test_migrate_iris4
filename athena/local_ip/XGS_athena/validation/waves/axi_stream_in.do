onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group axi_stream_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/sclk
add wave -noupdate -expand -group axi_stream_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/srst_n
add wave -noupdate -expand -group axi_stream_in -expand -group {AXI Stream input I/F} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tready
add wave -noupdate -expand -group axi_stream_in -expand -group {AXI Stream input I/F} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tvalid
add wave -noupdate -expand -group axi_stream_in -expand -group {AXI Stream input I/F} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tdata
add wave -noupdate -expand -group axi_stream_in -expand -group {AXI Stream input I/F} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tlast
add wave -noupdate -expand -group axi_stream_in -expand -group {AXI Stream input I/F} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tuser
add wave -noupdate -expand -group axi_stream_in -color {Cornflower Blue} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/state
add wave -noupdate -expand -group axi_stream_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/buffer_rdy
add wave -noupdate -expand -group axi_stream_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/buffer_empty
add wave -noupdate -expand -group axi_stream_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/buffer_write_ptr
add wave -noupdate -expand -group axi_stream_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/last_row
add wave -noupdate -expand -group axi_stream_in -color {Cornflower Blue} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/double_buffer_ptr
add wave -noupdate -expand -group axi_stream_in -expand -group {Buffer write I/F} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/buffer_write_en
add wave -noupdate -expand -group axi_stream_in -expand -group {Buffer write I/F} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/buffer_write_address
add wave -noupdate -expand -group axi_stream_in -expand -group {Buffer write I/F} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/buffer_write_data
add wave -noupdate -expand -group axi_stream_in -expand -group {Buffer read I/F} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/buffer_read_en
add wave -noupdate -expand -group axi_stream_in -expand -group {Buffer read I/F} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/buffer_read_address
add wave -noupdate -expand -group axi_stream_in -expand -group {Buffer read I/F} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/buffer_read_data
add wave -noupdate -expand -group axi_stream_in -color {Cornflower Blue} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/output_state
add wave -noupdate -expand -group axi_stream_in -expand -group {Line buffer I/F} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/start_of_frame
add wave -noupdate -expand -group axi_stream_in -expand -group {Line buffer I/F} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/line_ready
add wave -noupdate -expand -group axi_stream_in -expand -group {Line buffer I/F} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/line_transfered
add wave -noupdate -expand -group axi_stream_in -expand -group {Line buffer I/F} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/end_of_dma
add wave -noupdate -expand -group axi_stream_in -expand -group {Line buffer I/F} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/line_buffer_read_en
add wave -noupdate -expand -group axi_stream_in -expand -group {Line buffer I/F} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/line_buffer_read_address
add wave -noupdate -expand -group axi_stream_in -expand -group {Line buffer I/F} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/line_buffer_read_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1822088114 ps} 0} {{Cursor 2} {1197704000 ps} 1}
quietly wave cursor active 1
configure wave -namecolwidth 217
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
WaveRestoreZoom {0 ps} {1549968 ns}
