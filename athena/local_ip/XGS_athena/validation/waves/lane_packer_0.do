onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/sysclk
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/sysrst
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/packer_fifo_overrun
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/packer_fifo_underrun
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/enable
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/init_frame
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/odd_line
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/line_valid
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/busy
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/line_buffer_id
add wave -noupdate -expand -group {Lane packer 0} -group {Top FIFO I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/top_sync
add wave -noupdate -expand -group {Lane packer 0} -group {Top FIFO I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/top_fifo_read_en
add wave -noupdate -expand -group {Lane packer 0} -group {Top FIFO I/F} -color {Sky Blue} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/top_fifo_empty
add wave -noupdate -expand -group {Lane packer 0} -group {Top FIFO I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/top_fifo_read_data_valid
add wave -noupdate -expand -group {Lane packer 0} -group {Top FIFO I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/top_fifo_read_data
add wave -noupdate -expand -group {Lane packer 0} -expand -group {Bottom FiFo I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/bottom_sync
add wave -noupdate -expand -group {Lane packer 0} -expand -group {Bottom FiFo I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/bottom_fifo_read_en
add wave -noupdate -expand -group {Lane packer 0} -expand -group {Bottom FiFo I/F} -color {Sky Blue} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/bottom_fifo_empty
add wave -noupdate -expand -group {Lane packer 0} -expand -group {Bottom FiFo I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/bottom_fifo_read_data_valid
add wave -noupdate -expand -group {Lane packer 0} -expand -group {Bottom FiFo I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/bottom_fifo_read_data
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
add wave -noupdate -expand -group {Lane packer 0} -expand -group {FiFo wr I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/fifo_wr
add wave -noupdate -expand -group {Lane packer 0} -expand -group {FiFo wr I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/fifo_wdata
add wave -noupdate -expand -group {Lane packer 0} -expand -group {FiFo wr I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/fifo_full
add wave -noupdate -expand -group {Lane packer 0} -expand -group {FiFo read I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/fifo_rd
add wave -noupdate -expand -group {Lane packer 0} -expand -group {FiFo read I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/fifo_rdata
add wave -noupdate -expand -group {Lane packer 0} -expand -group {FiFo read I/F} -color {Cornflower Blue} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/fifo_empty
add wave -noupdate -expand -group {Lane packer 0} -expand -group {FiFo read I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/fifo_usedw
add wave -noupdate -expand -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/fifo_usedw_max
add wave -noupdate -expand -group {Lane packer 0} -expand -group {Line buffer I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/lane_packer_ack
add wave -noupdate -expand -group {Lane packer 0} -expand -group {Line buffer I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/lane_packer_req
add wave -noupdate -expand -group {Lane packer 0} -expand -group {Line buffer I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/lane_packer_write
add wave -noupdate -expand -group {Lane packer 0} -expand -group {Line buffer I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/lane_packer_addr
add wave -noupdate -expand -group {Lane packer 0} -expand -group {Line buffer I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/lane_packer_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors
quietly wave cursor active 0
configure wave -namecolwidth 234
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
configure wave -timelineunits us
update
WaveRestoreZoom {975720750 ps} {1347379088 ps}
