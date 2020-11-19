onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_reset
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/streamer_en
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/streamer_busy
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/transfert_done
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/init_frame
add wave -noupdate -group axi_line_streamer -expand /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/nb_lane_enabled
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/x_start
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/x_stop
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/y_start
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/y_size
add wave -noupdate -group axi_line_streamer -group {line buffer I/F} -color Turquoise /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_buffer_read_en
add wave -noupdate -group axi_line_streamer -group {line buffer I/F} -group Address -color Yellow /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_buffer_id
add wave -noupdate -group axi_line_streamer -group {line buffer I/F} -group Address -color Gold /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_buffer_lane_id
add wave -noupdate -group axi_line_streamer -group {line buffer I/F} -group Address -color Goldenrod /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_buffer_mux_id
add wave -noupdate -group axi_line_streamer -group {line buffer I/F} -group Address -color Salmon /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_buffer_word_ptr
add wave -noupdate -group axi_line_streamer -group {line buffer I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_buffer_empty_even
add wave -noupdate -group axi_line_streamer -group {line buffer I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_buffer_empty_odd
add wave -noupdate -group axi_line_streamer -group {line buffer I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_buffer_sync_even
add wave -noupdate -group axi_line_streamer -group {line buffer I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_buffer_data_even
add wave -noupdate -group axi_line_streamer -group {line buffer I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_buffer_sync_odd
add wave -noupdate -group axi_line_streamer -group {line buffer I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_buffer_data_odd
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/burst_length
add wave -noupdate -group axi_line_streamer -color Turquoise /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/state
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_x_start
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_x_stop
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_y_start
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_y_stop
add wave -noupdate -group axi_line_streamer -radix hexadecimal /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/word_cntr
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/word_cntr_en
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/word_cntr_init
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/mux_id_cntr
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/mux_id_cntr_en
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/mux_id_cntr_init
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/lane_id_cntr
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/lane_id_cntr_en
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/last_data
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/buffer_id_cntr
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/buffer_id_cntr_en
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_write_en
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_write_data
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_read_en
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_read_data
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_usedw
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_empty
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_full
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/m_wait
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/buffer_address
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/read_en
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/read_data_valid
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/first_row
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/last_row
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tvalid_int
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/pixel_ptr
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_data_packer
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_load_data
add wave -noupdate -group axi_line_streamer -expand -group {Stream output I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tready
add wave -noupdate -group axi_line_streamer -expand -group {Stream output I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tvalid
add wave -noupdate -group axi_line_streamer -expand -group {Stream output I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tuser
add wave -noupdate -group axi_line_streamer -expand -group {Stream output I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tlast
add wave -noupdate -group axi_line_streamer -expand -group {Stream output I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {189152 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 239
configure wave -valuecolwidth 145
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
WaveRestoreZoom {0 ps} {286479 ps}
