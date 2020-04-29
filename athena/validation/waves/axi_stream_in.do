onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {AXI Stream Input} /testbench_athena/DUT/system_i/dmawr2tlp_0/U0/xaxi_stream_in/axi_clk
add wave -noupdate -expand -group {AXI Stream Input} /testbench_athena/DUT/system_i/dmawr2tlp_0/U0/xaxi_stream_in/axi_reset_n
add wave -noupdate -expand -group {AXI Stream Input} /testbench_athena/DUT/system_i/dmawr2tlp_0/U0/xaxi_stream_in/s_axis_tready
add wave -noupdate -expand -group {AXI Stream Input} /testbench_athena/DUT/system_i/dmawr2tlp_0/U0/xaxi_stream_in/s_axis_tvalid
add wave -noupdate -expand -group {AXI Stream Input} /testbench_athena/DUT/system_i/dmawr2tlp_0/U0/xaxi_stream_in/s_axis_tdata
add wave -noupdate -expand -group {AXI Stream Input} /testbench_athena/DUT/system_i/dmawr2tlp_0/U0/xaxi_stream_in/s_axis_tlast
add wave -noupdate -expand -group {AXI Stream Input} -expand /testbench_athena/DUT/system_i/dmawr2tlp_0/U0/xaxi_stream_in/s_axis_tuser
add wave -noupdate -expand -group {AXI Stream Input} /testbench_athena/DUT/system_i/dmawr2tlp_0/U0/xaxi_stream_in/state
add wave -noupdate -expand -group {AXI Stream Input} /testbench_athena/DUT/system_i/dmawr2tlp_0/U0/xaxi_stream_in/buffer_write_en
add wave -noupdate -expand -group {AXI Stream Input} /testbench_athena/DUT/system_i/dmawr2tlp_0/U0/xaxi_stream_in/buffer_write_address
add wave -noupdate -expand -group {AXI Stream Input} /testbench_athena/DUT/system_i/dmawr2tlp_0/U0/xaxi_stream_in/buffer_write_data
add wave -noupdate -expand -group {AXI Stream Input} /testbench_athena/DUT/system_i/dmawr2tlp_0/U0/xaxi_stream_in/buffer_read_en
add wave -noupdate -expand -group {AXI Stream Input} /testbench_athena/DUT/system_i/dmawr2tlp_0/U0/xaxi_stream_in/buffer_read_address
add wave -noupdate -expand -group {AXI Stream Input} /testbench_athena/DUT/system_i/dmawr2tlp_0/U0/xaxi_stream_in/buffer_read_data
add wave -noupdate -expand -group {AXI Stream Input} -expand -group {Line buffer I/F} /testbench_athena/DUT/system_i/dmawr2tlp_0/U0/xaxi_stream_in/start_of_frame
add wave -noupdate -expand -group {AXI Stream Input} -expand -group {Line buffer I/F} /testbench_athena/DUT/system_i/dmawr2tlp_0/U0/xaxi_stream_in/line_ready
add wave -noupdate -expand -group {AXI Stream Input} -expand -group {Line buffer I/F} /testbench_athena/DUT/system_i/dmawr2tlp_0/U0/xaxi_stream_in/line_transfered
add wave -noupdate -expand -group {AXI Stream Input} -expand -group {Line buffer I/F} /testbench_athena/DUT/system_i/dmawr2tlp_0/U0/xaxi_stream_in/end_of_dma
add wave -noupdate -expand -group {AXI Stream Input} -expand -group {Line buffer I/F} /testbench_athena/DUT/system_i/dmawr2tlp_0/U0/xaxi_stream_in/line_buffer_read_en
add wave -noupdate -expand -group {AXI Stream Input} -expand -group {Line buffer I/F} /testbench_athena/DUT/system_i/dmawr2tlp_0/U0/xaxi_stream_in/line_buffer_read_address
add wave -noupdate -expand -group {AXI Stream Input} -expand -group {Line buffer I/F} /testbench_athena/DUT/system_i/dmawr2tlp_0/U0/xaxi_stream_in/line_buffer_read_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {965883967 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 228
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
WaveRestoreZoom {914479349 ps} {1191025449 ps}
