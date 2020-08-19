onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/rclk
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/rclk_reset
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/regfile
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/sclk
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/sclk_reset
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/enable
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/init_packer
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/odd_line
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/line_valid
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/busy
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/line_buffer_id
add wave -noupdate -expand -group {Lane packer 0} -radix decimal /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/rclk_pixel_mux_ratio
add wave -noupdate -expand -group {Lane packer 0} -radix decimal /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/rclk_pixel_per_lane
add wave -noupdate -expand -group {Lane packer 0} -radix decimal /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/rclk_pixel_per_stripe
add wave -noupdate -expand -group {Lane packer 0} -radix decimal /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/rclk_pixel_per_packer
add wave -noupdate -expand -group {Lane packer 0} -expand -group {top decoder I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/top_sync
add wave -noupdate -expand -group {Lane packer 0} -expand -group {top decoder I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/top_fifo_read_en
add wave -noupdate -expand -group {Lane packer 0} -expand -group {top decoder I/F} -color Magenta /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/top_fifo_empty
add wave -noupdate -expand -group {Lane packer 0} -expand -group {top decoder I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/top_fifo_read_data_valid
add wave -noupdate -expand -group {Lane packer 0} -expand -group {top decoder I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/top_fifo_read_data
add wave -noupdate -expand -group {Lane packer 0} -expand -group {bottom decoder I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/bottom_sync
add wave -noupdate -expand -group {Lane packer 0} -expand -group {bottom decoder I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/bottom_fifo_read_en
add wave -noupdate -expand -group {Lane packer 0} -expand -group {bottom decoder I/F} -color Magenta /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/bottom_fifo_empty
add wave -noupdate -expand -group {Lane packer 0} -expand -group {bottom decoder I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/bottom_fifo_read_data_valid
add wave -noupdate -expand -group {Lane packer 0} -expand -group {bottom decoder I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/bottom_fifo_read_data
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/state
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/output_state
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/packer_max_count
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/load_data
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/pix_packer_wren
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/pix_packer
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/pix_offset_stripe_0
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/pix_offset_stripe_1
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/pix_offset_stripe_2
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/pix_offset_stripe_3
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/pix_offset_mux
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/pix_in_cntr
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/line_buffer_offset
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/lane_decoder_read
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/lane_id
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/pix_even
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/pix_odd
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/fifo_rd
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/fifo_wr
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/fifo_wdata
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/fifo_rdata
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/fifo_full
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/fifo_empty
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/fifo_usedw
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/fifo_usedw_max
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/packer_fifo_overrun
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/packer_fifo_underrun
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/rclk_packer_fifo_overrun
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/rclk_packer_fifo_underrun
add wave -noupdate -expand -group {Lane packer 0} -expand -group {Line buffer I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/lane_packer_ack
add wave -noupdate -expand -group {Lane packer 0} -expand -group {Line buffer I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/lane_packer_req
add wave -noupdate -expand -group {Lane packer 0} -expand -group {Line buffer I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/lane_packer_write
add wave -noupdate -expand -group {Lane packer 0} -expand -group {Line buffer I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/lane_packer_addr
add wave -noupdate -expand -group {Lane packer 0} -expand -group {Line buffer I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/lane_packer_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {250066765 ps} 0} {{Cursor 2} {671900581 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 339
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
WaveRestoreZoom {0 ps} {1100215923 ps}
