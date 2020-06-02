onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_reset
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/streamer_en
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/streamer_busy
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/transfert_done
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/init_frame
add wave -noupdate -expand -group axi_line_streamer -radix unsigned /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/x_row_start
add wave -noupdate -expand -group axi_line_streamer -radix unsigned /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/x_row_stop
add wave -noupdate -expand -group axi_line_streamer -radix unsigned /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/y_row_start
add wave -noupdate -expand -group axi_line_streamer -radix unsigned /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/y_row_stop
add wave -noupdate -expand -group axi_line_streamer -expand -group {Line buffer I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/line_buffer_clr
add wave -noupdate -expand -group axi_line_streamer -expand -group {Line buffer I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/line_buffer_ready
add wave -noupdate -expand -group axi_line_streamer -expand -group {Line buffer I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/line_buffer_read
add wave -noupdate -expand -group axi_line_streamer -expand -group {Line buffer I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/line_buffer_ptr
add wave -noupdate -expand -group axi_line_streamer -expand -group {Line buffer I/F} -radix unsigned /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/line_buffer_address
add wave -noupdate -expand -group axi_line_streamer -expand -group {Line buffer I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/line_buffer_row_id
add wave -noupdate -expand -group axi_line_streamer -expand -group {Line buffer I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/line_buffer_data
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/m_wait
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/state
add wave -noupdate -expand -group axi_line_streamer -radix decimal /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/burst_length
add wave -noupdate -expand -group axi_line_streamer -radix unsigned /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/burst_cntr
add wave -noupdate -expand -group axi_line_streamer -radix unsigned /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/buffer_address
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/read_en
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/read_data_valid
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/first_row
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/last_row
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/buffer_read_ptr
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/start_transfer
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tvalid_int
add wave -noupdate -expand -group axi_line_streamer -expand -group {AXI Stream output I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tready
add wave -noupdate -expand -group axi_line_streamer -expand -group {AXI Stream output I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tvalid
add wave -noupdate -expand -group axi_line_streamer -expand -group {AXI Stream output I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tuser
add wave -noupdate -expand -group axi_line_streamer -expand -group {AXI Stream output I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tlast
add wave -noupdate -expand -group axi_line_streamer -expand -group {AXI Stream output I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1197301856 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 223
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {1196897853 ps} {1197913960 ps}
