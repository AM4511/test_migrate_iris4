onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sysclk
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sysrst
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/streamer_en
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/streamer_busy
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/transfert_done
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/init_frame
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/y_row_start
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/y_row_stop
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/clrBuffer
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/line_buffer_ready
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/line_buffer_read
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/line_buffer_ptr
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/line_buffer_address
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/line_buffer_count
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/line_buffer_row_id
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/line_buffer_data
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/m_wait
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/state
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/burst_length
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/burst_cntr
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/read_en
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/read_data_valid
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/first_row
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/last_row
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/buffer_ptr
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/start_transfer
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/m_axis_tvalid_int
add wave -noupdate -expand -group axi_line_streamer -expand -group {AXI Stream I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/m_axis_tready
add wave -noupdate -expand -group axi_line_streamer -expand -group {AXI Stream I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/m_axis_tvalid
add wave -noupdate -expand -group axi_line_streamer -expand -group {AXI Stream I/F} -color Orchid -expand -subitemconfig {/testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/m_axis_tuser(3) {-color Orchid} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/m_axis_tuser(2) {-color Orchid} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/m_axis_tuser(1) {-color Orchid} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/m_axis_tuser(0) {-color Orchid}} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/m_axis_tuser
add wave -noupdate -expand -group axi_line_streamer -expand -group {AXI Stream I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/m_axis_tlast
add wave -noupdate -expand -group axi_line_streamer -expand -group {AXI Stream I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/m_axis_tdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1559510542 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 308
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
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {2088859500 ps}
