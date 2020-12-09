onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group top_lane_decoder_0 -group {HiSPi I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/hclk
add wave -noupdate -expand -group top_lane_decoder_0 -group {HiSPi I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/hclk_reset
add wave -noupdate -expand -group top_lane_decoder_0 -group {HiSPi I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/hclk_lane_enable
add wave -noupdate -expand -group top_lane_decoder_0 -group {HiSPi I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/hclk_data_lane
add wave -noupdate -expand -group top_lane_decoder_0 -group {PCLK I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk
add wave -noupdate -expand -group top_lane_decoder_0 -group {PCLK I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_reset
add wave -noupdate -expand -group top_lane_decoder_0 -group {PCLK I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_cal_en
add wave -noupdate -expand -group top_lane_decoder_0 -group {PCLK I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_cal_start_monitor
add wave -noupdate -expand -group top_lane_decoder_0 -group {PCLK I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_tap_cntr
add wave -noupdate -expand -group top_lane_decoder_0 -group {PCLK I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_valid
add wave -noupdate -expand -group top_lane_decoder_0 -group {PCLK I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_cal_monitor_done
add wave -noupdate -expand -group top_lane_decoder_0 -group {PCLK I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_cal_busy
add wave -noupdate -expand -group top_lane_decoder_0 -group {PCLK I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_cal_tap_value
add wave -noupdate -expand -group top_lane_decoder_0 -group {PCLK I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_tap_histogram
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/rclk
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/rclk_reset
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/regfile
add wave -noupdate -expand -group top_lane_decoder_0 -expand -group {Pixel packer} -color Pink /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_data
add wave -noupdate -expand -group top_lane_decoder_0 -expand -group {Pixel packer} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_pixel
add wave -noupdate -expand -group top_lane_decoder_0 -expand -group {Pixel packer} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_phase_cntr
add wave -noupdate -expand -group top_lane_decoder_0 -expand -group {Pixel packer} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_packer_0
add wave -noupdate -expand -group top_lane_decoder_0 -expand -group {Pixel packer} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_packer_1
add wave -noupdate -expand -group top_lane_decoder_0 -expand -group {Pixel packer} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_packer_2
add wave -noupdate -expand -group top_lane_decoder_0 -expand -group {Pixel packer} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_packer_3
add wave -noupdate -expand -group top_lane_decoder_0 -expand -group {Pixel packer} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_packer_valid
add wave -noupdate -expand -group top_lane_decoder_0 -expand -group {Pixel packer} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_packer_mux
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_bit_locked
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_cal_busy_int
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_cal_error
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_hispi_phy_en
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_hispi_data_path_en
add wave -noupdate -expand -group top_lane_decoder_0 -color Gold /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_embedded
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_sof_pending
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_sof_flag
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_set_buff_ready
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_buff_ready
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_buffer_init
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_buffer_data
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_buffer_sync
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_buffer_id
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_buffer_mux_id
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_word_ptr
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_init_word_ptr
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_incr_word_ptr
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_buffer_wen
add wave -noupdate -expand -group top_lane_decoder_0 -color Turquoise /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_state
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_sync
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_sync_error
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_crc_enable
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_crc_init
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_crc_en
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_crc_error
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_computed_crc1
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_computed_crc2
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_eol
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/pclk_sof
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/sclk_eol
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/rclk_enable_hispi
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/rclk_enable_datapath
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/rclk_buffer_overrun
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/rclk_buffer_underrun
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/rclk_sync_error
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/rclk_tap_histogram
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/rclk_cal_busy_rise
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/rclk_cal_busy_fall
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/rclk_cal_done
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/rclk_cal_error
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/rclk_bit_locked
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/rclk_bit_locked_fall
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/rclk_crc_error
add wave -noupdate -expand -group top_lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/async_idle_character
add wave -noupdate -expand -group top_lane_decoder_0 -expand -group {Lane buffer I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/sclk
add wave -noupdate -expand -group top_lane_decoder_0 -expand -group {Lane buffer I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/sclk_reset
add wave -noupdate -expand -group top_lane_decoder_0 -expand -group {Lane buffer I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/sclk_sof
add wave -noupdate -expand -group top_lane_decoder_0 -expand -group {Lane buffer I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/sclk_buffer_empty
add wave -noupdate -expand -group top_lane_decoder_0 -expand -group {Lane buffer I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/sclk_buffer_read_en
add wave -noupdate -expand -group top_lane_decoder_0 -expand -group {Lane buffer I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/sclk_buffer_id
add wave -noupdate -expand -group top_lane_decoder_0 -expand -group {Lane buffer I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/sclk_buffer_mux_id
add wave -noupdate -expand -group top_lane_decoder_0 -expand -group {Lane buffer I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/sclk_buffer_word_ptr
add wave -noupdate -expand -group top_lane_decoder_0 -expand -group {Lane buffer I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/sclk_buffer_sync
add wave -noupdate -expand -group top_lane_decoder_0 -expand -group {Lane buffer I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/sclk_buffer_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1199993321 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 239
configure wave -valuecolwidth 269
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
WaveRestoreZoom {1196737857 ps} {1205154158 ps}
