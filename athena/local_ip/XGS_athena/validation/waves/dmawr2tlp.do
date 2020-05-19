onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group dmawr2tlp /testbench/DUT/xdmawr2tlp/xaxi_stream_in/sclk
add wave -noupdate -expand -group dmawr2tlp /testbench/DUT/xdmawr2tlp/xaxi_stream_in/srst_n
add wave -noupdate -expand -group dmawr2tlp -group {AXI Stream Input} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tready
add wave -noupdate -expand -group dmawr2tlp -group {AXI Stream Input} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tvalid
add wave -noupdate -expand -group dmawr2tlp -group {AXI Stream Input} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tdata
add wave -noupdate -expand -group dmawr2tlp -group {AXI Stream Input} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tlast
add wave -noupdate -expand -group dmawr2tlp -group {AXI Stream Input} -expand -subitemconfig {/testbench/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tuser(3) {-color Gold -height 15} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tuser(2) {-color Gold -height 15} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tuser(1) {-color Gold -height 15} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tuser(0) {-color Gold -height 15}} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tuser
add wave -noupdate -expand -group dmawr2tlp -color {Cornflower Blue} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/last_row
add wave -noupdate -expand -group dmawr2tlp -color Turquoise /testbench/DUT/xdmawr2tlp/xaxi_stream_in/state
add wave -noupdate -expand -group dmawr2tlp /testbench/DUT/xdmawr2tlp/xaxi_stream_in/buffer_write_en
add wave -noupdate -expand -group dmawr2tlp /testbench/DUT/xdmawr2tlp/xaxi_stream_in/buffer_write_address
add wave -noupdate -expand -group dmawr2tlp /testbench/DUT/xdmawr2tlp/xaxi_stream_in/buffer_write_data
add wave -noupdate -expand -group dmawr2tlp /testbench/DUT/xdmawr2tlp/xaxi_stream_in/buffer_read_en
add wave -noupdate -expand -group dmawr2tlp /testbench/DUT/xdmawr2tlp/xaxi_stream_in/buffer_read_address
add wave -noupdate -expand -group dmawr2tlp /testbench/DUT/xdmawr2tlp/xaxi_stream_in/buffer_read_data
add wave -noupdate -expand -group dmawr2tlp -expand -group {DMA_WR I/F} -color Yellow /testbench/DUT/xdmawr2tlp/xaxi_stream_in/start_of_frame
add wave -noupdate -expand -group dmawr2tlp -expand -group {DMA_WR I/F} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/line_ready
add wave -noupdate -expand -group dmawr2tlp -expand -group {DMA_WR I/F} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/line_transfered
add wave -noupdate -expand -group dmawr2tlp -expand -group {DMA_WR I/F} -color {Medium Violet Red} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/end_of_dma
add wave -noupdate -expand -group dmawr2tlp -expand -group {DMA_WR I/F} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/line_buffer_read_en
add wave -noupdate -expand -group dmawr2tlp -expand -group {DMA_WR I/F} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/line_buffer_read_address
add wave -noupdate -expand -group dmawr2tlp -expand -group {DMA_WR I/F} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/line_buffer_read_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1331503644 ps} 0}
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
WaveRestoreZoom {0 ps} {2471211750 ps}
