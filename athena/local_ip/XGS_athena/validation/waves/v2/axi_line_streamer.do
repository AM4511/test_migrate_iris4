onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_reset
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/streamer_en
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/streamer_busy
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/transfert_done
add wave -noupdate -expand -group axi_line_streamer -color {Orange Red} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/init_frame
add wave -noupdate -expand -group axi_line_streamer -expand /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/nb_lane_enabled
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/x_start
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/x_stop
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/y_start
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/y_size
add wave -noupdate -expand -group axi_line_streamer -expand -group {line buffer I/F} -color Turquoise /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_buffer_read_en
add wave -noupdate -expand -group axi_line_streamer -expand -group {line buffer I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_buffer_empty_top
add wave -noupdate -expand -group axi_line_streamer -expand -group {line buffer I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_buffer_sync_top
add wave -noupdate -expand -group axi_line_streamer -expand -group {line buffer I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_buffer_data_top
add wave -noupdate -expand -group axi_line_streamer -expand -group {line buffer I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_buffer_empty_bottom
add wave -noupdate -expand -group axi_line_streamer -expand -group {line buffer I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_buffer_sync_bottom
add wave -noupdate -expand -group axi_line_streamer -expand -group {line buffer I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_buffer_data_bottom
add wave -noupdate -expand -group axi_line_streamer -expand -group {line buffer I/F} -group Address -color Yellow /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_buffer_id
add wave -noupdate -expand -group axi_line_streamer -expand -group {line buffer I/F} -group Address -color Gold /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_buffer_lane_id
add wave -noupdate -expand -group axi_line_streamer -expand -group {line buffer I/F} -group Address -color Goldenrod /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_buffer_mux_id
add wave -noupdate -expand -group axi_line_streamer -expand -group {line buffer I/F} -group Address -color Salmon /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_buffer_word_ptr
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/burst_length
add wave -noupdate -expand -group axi_line_streamer -color Turquoise /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/state
add wave -noupdate -expand -group axi_line_streamer -expand -group {Current ROI context} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_x_start
add wave -noupdate -expand -group axi_line_streamer -expand -group {Current ROI context} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_x_stop
add wave -noupdate -expand -group axi_line_streamer -expand -group {Current ROI context} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_y_start
add wave -noupdate -expand -group axi_line_streamer -expand -group {Current ROI context} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_y_stop
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/read_en
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/read_data_valid
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/odd_line
add wave -noupdate -expand -group axi_line_streamer -radix decimal /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/pixel_ptr
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_data_packer
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_write_en
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_write_data
add wave -noupdate -expand -group axi_line_streamer -color Goldenrod /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/line_cntr
add wave -noupdate -expand -group axi_line_streamer -color Pink /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/first_row
add wave -noupdate -expand -group axi_line_streamer -color Pink /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/last_row
add wave -noupdate -expand -group axi_line_streamer -radix hexadecimal /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/word_cntr
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/word_cntr_en
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/word_cntr_init
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/mux_id_cntr
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/mux_id_cntr_en
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/lane_id_cntr
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/lane_id_cntr_en
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/last_data
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/buffer_id_cntr
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/buffer_id_cntr_en
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_read_en
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_read_data
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_usedw
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_empty
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_full
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/m_wait
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tvalid_int
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_load_data
add wave -noupdate -expand -group axi_line_streamer -expand -group {Stream output I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tready
add wave -noupdate -expand -group axi_line_streamer -expand -group {Stream output I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tvalid
add wave -noupdate -expand -group axi_line_streamer -expand -group {Stream output I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tuser
add wave -noupdate -expand -group axi_line_streamer -expand -group {Stream output I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tlast
add wave -noupdate -expand -group axi_line_streamer -expand -group {Stream output I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {1209375000 ps} 1} {{Cursor 3} {15502 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 239
configure wave -valuecolwidth 132
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
WaveRestoreZoom {0 ps} {1050328650 ps}
