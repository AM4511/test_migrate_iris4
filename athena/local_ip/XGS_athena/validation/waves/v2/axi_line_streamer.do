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
add wave -noupdate -expand -group axi_line_streamer -expand -group {Current ROI context} -radix unsigned -childformat {{/testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_x_start(12) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_x_start(11) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_x_start(10) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_x_start(9) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_x_start(8) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_x_start(7) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_x_start(6) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_x_start(5) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_x_start(4) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_x_start(3) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_x_start(2) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_x_start(1) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_x_start(0) -radix unsigned}} -subitemconfig {/testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_x_start(12) {-height 15 -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_x_start(11) {-height 15 -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_x_start(10) {-height 15 -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_x_start(9) {-height 15 -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_x_start(8) {-height 15 -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_x_start(7) {-height 15 -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_x_start(6) {-height 15 -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_x_start(5) {-height 15 -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_x_start(4) {-height 15 -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_x_start(3) {-height 15 -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_x_start(2) {-height 15 -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_x_start(1) {-height 15 -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_x_start(0) {-height 15 -radix unsigned}} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_x_start
add wave -noupdate -expand -group axi_line_streamer -expand -group {Current ROI context} -radix unsigned /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_x_stop
add wave -noupdate -expand -group axi_line_streamer -expand -group {Current ROI context} -radix unsigned /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_y_start
add wave -noupdate -expand -group axi_line_streamer -expand -group {Current ROI context} -radix unsigned /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_y_stop
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/read_en
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/read_data_valid
add wave -noupdate -expand -group axi_line_streamer -expand -group {Lane packer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/odd_line
add wave -noupdate -expand -group axi_line_streamer -expand -group {Lane packer} -color Blue /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_load_data
add wave -noupdate -expand -group axi_line_streamer -expand -group {Lane packer} -color Orchid /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_data_packer_rdy
add wave -noupdate -expand -group axi_line_streamer -expand -group {Lane packer} -color Orchid -radix unsigned -childformat {{/testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/pixel_cntr(12) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/pixel_cntr(11) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/pixel_cntr(10) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/pixel_cntr(9) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/pixel_cntr(8) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/pixel_cntr(7) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/pixel_cntr(6) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/pixel_cntr(5) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/pixel_cntr(4) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/pixel_cntr(3) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/pixel_cntr(2) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/pixel_cntr(1) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/pixel_cntr(0) -radix unsigned}} -subitemconfig {/testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/pixel_cntr(12) {-color Orchid -height 15 -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/pixel_cntr(11) {-color Orchid -height 15 -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/pixel_cntr(10) {-color Orchid -height 15 -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/pixel_cntr(9) {-color Orchid -height 15 -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/pixel_cntr(8) {-color Orchid -height 15 -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/pixel_cntr(7) {-color Orchid -height 15 -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/pixel_cntr(6) {-color Orchid -height 15 -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/pixel_cntr(5) {-color Orchid -height 15 -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/pixel_cntr(4) {-color Orchid -height 15 -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/pixel_cntr(3) {-color Orchid -height 15 -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/pixel_cntr(2) {-color Orchid -height 15 -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/pixel_cntr(1) {-color Orchid -height 15 -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/pixel_cntr(0) {-color Orchid -height 15 -radix unsigned}} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/pixel_cntr
add wave -noupdate -expand -group axi_line_streamer -expand -group {Lane packer} -color {Steel Blue} -radix decimal /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/pixel_ptr
add wave -noupdate -expand -group axi_line_streamer -expand -group {Lane packer} -color {Steel Blue} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_data_packer
add wave -noupdate -expand -group axi_line_streamer -expand -group {Lane packer} -color Coral /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_valid_x_roi
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
add wave -noupdate -expand -group axi_line_streamer -color Turquoise /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/state
add wave -noupdate -expand -group axi_line_streamer -expand -group {FiFo Write I/F} -expand -subitemconfig {/testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_write_sync(3) {-color Gray90 -height 15} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_write_sync(2) {-color Gray90 -height 15} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_write_sync(1) {-color Gray90 -height 15} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_write_sync(0) {-color Gray90 -height 15}} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_write_sync
add wave -noupdate -expand -group axi_line_streamer -expand -group {FiFo Write I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_write_aggregated_data
add wave -noupdate -expand -group axi_line_streamer -expand -group {FiFo Write I/F} -color Khaki /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_write_en
add wave -noupdate -expand -group axi_line_streamer -expand -group {FiFo Write I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_write_data
add wave -noupdate -expand -group axi_line_streamer -expand -group {FiFo Read I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_read_en
add wave -noupdate -expand -group axi_line_streamer -expand -group {FiFo Read I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_read_sync
add wave -noupdate -expand -group axi_line_streamer -expand -group {FiFo Read I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_read_data
add wave -noupdate -expand -group axi_line_streamer -expand -group {FiFo Read I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_usedw
add wave -noupdate -expand -group axi_line_streamer -expand -group {FiFo Read I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_empty
add wave -noupdate -expand -group axi_line_streamer -expand -group {FiFo Read I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_full
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/strm_state
add wave -noupdate -expand -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/m_wait
add wave -noupdate -expand -group axi_line_streamer -color Gold /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/read_data_valid
add wave -noupdate -expand -group axi_line_streamer -expand -group {Stream output I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tready
add wave -noupdate -expand -group axi_line_streamer -expand -group {Stream output I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tvalid
add wave -noupdate -expand -group axi_line_streamer -expand -group {Stream output I/F} -expand /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tuser
add wave -noupdate -expand -group axi_line_streamer -expand -group {Stream output I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tlast
add wave -noupdate -expand -group axi_line_streamer -expand -group {Stream output I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 3} {1216225033 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 239
configure wave -valuecolwidth 433
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
WaveRestoreZoom {1204670751 ps} {1339195950 ps}
