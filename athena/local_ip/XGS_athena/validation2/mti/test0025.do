onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group dma_line_buffer /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk
add wave -noupdate -expand -group dma_line_buffer /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/srst_n
add wave -noupdate -expand -group dma_line_buffer /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_unpack
add wave -noupdate -expand -group dma_line_buffer -expand -group {Info write I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_info_wren
add wave -noupdate -expand -group dma_line_buffer -expand -group {Info write I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_info_wlength
add wave -noupdate -expand -group dma_line_buffer -expand -group {Info write I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_info_weof
add wave -noupdate -expand -group dma_line_buffer -expand -group {Info write I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_info_wbuff_id
add wave -noupdate -expand -group dma_line_buffer -expand -group {Info Read I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_info_rden
add wave -noupdate -expand -group dma_line_buffer -expand -group {Info Read I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_info_rlength
add wave -noupdate -expand -group dma_line_buffer -expand -group {Info Read I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_info_reof
add wave -noupdate -expand -group dma_line_buffer -expand -group {Info Read I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_info_rbuff_id
add wave -noupdate -expand -group dma_line_buffer -expand -group {Data Write I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_wren
add wave -noupdate -expand -group dma_line_buffer -expand -group {Data Write I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_wraddress
add wave -noupdate -expand -group dma_line_buffer -expand -group {Data Write I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_wrdata
add wave -noupdate -expand -group dma_line_buffer -expand -group {Data Read I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_rden
add wave -noupdate -expand -group dma_line_buffer -expand -group {Data Read I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_rdaddress
add wave -noupdate -expand -group dma_line_buffer -expand -group {Data Read I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_rddata
add wave -noupdate -expand -group dma_line_buffer /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/srst
add wave -noupdate -expand -group dma_line_buffer /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_buffer_read_address
add wave -noupdate -expand -group dma_line_buffer /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_buffer_write_address
add wave -noupdate -expand -group dma_line_buffer /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_buffer_read_en
add wave -noupdate -expand -group dma_line_buffer /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_buffer_write_en
add wave -noupdate -expand -group dma_line_buffer /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_rdaddress_P1
add wave -noupdate -expand -group dma_line_buffer /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_buffer_read_data_mux
add wave -noupdate -expand -group dma_line_buffer /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_info_wrdata
add wave -noupdate -expand -group dma_line_buffer /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_info_rddata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1437768021 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 294
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
WaveRestoreZoom {0 ps} {3654912470 ps}
