onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group dma_line_buffer /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk
add wave -noupdate -expand -group dma_line_buffer /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/srst_n
add wave -noupdate -expand -group dma_line_buffer /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_unpack
add wave -noupdate -expand -group dma_line_buffer -group {Info buffer Write I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_info_wren
add wave -noupdate -expand -group dma_line_buffer -group {Info buffer Write I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_info_wlength
add wave -noupdate -expand -group dma_line_buffer -group {Info buffer Write I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_info_weof
add wave -noupdate -expand -group dma_line_buffer -group {Info buffer Write I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_info_wbuff_id
add wave -noupdate -expand -group dma_line_buffer -group {Line Buffer Write I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_wren
add wave -noupdate -expand -group dma_line_buffer -group {Line Buffer Write I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_wraddress
add wave -noupdate -expand -group dma_line_buffer -group {Line Buffer Write I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_wrdata
add wave -noupdate -expand -group dma_line_buffer /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/srst
add wave -noupdate -expand -group dma_line_buffer /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_buffer_read_address
add wave -noupdate -expand -group dma_line_buffer /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_buffer_write_address
add wave -noupdate -expand -group dma_line_buffer /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_buffer_read_en
add wave -noupdate -expand -group dma_line_buffer /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_buffer_write_en
add wave -noupdate -expand -group dma_line_buffer /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_buffer_read_data_mux
add wave -noupdate -expand -group dma_line_buffer /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_info_wrdata
add wave -noupdate -expand -group dma_line_buffer /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_info_rddata
add wave -noupdate -expand -group dma_line_buffer -expand -group {Info buffer Read I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_info_rden
add wave -noupdate -expand -group dma_line_buffer -expand -group {Info buffer Read I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_info_rlength
add wave -noupdate -expand -group dma_line_buffer -expand -group {Info buffer Read I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_info_reof
add wave -noupdate -expand -group dma_line_buffer -expand -group {Info buffer Read I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_info_rbuff_id
add wave -noupdate -expand -group dma_line_buffer -expand -group {Line Buffer Read I/F} -color Gold /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_buffer_read_buffer_ptr
add wave -noupdate -expand -group dma_line_buffer -expand -group {Line Buffer Read I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_rden
add wave -noupdate -expand -group dma_line_buffer -expand -group {Line Buffer Read I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_rdaddress
add wave -noupdate -expand -group dma_line_buffer -expand -group {Line Buffer Read I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_rddata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5826336780 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 217
configure wave -valuecolwidth 220
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
WaveRestoreZoom {5826135741 ps} {5826533659 ps}
