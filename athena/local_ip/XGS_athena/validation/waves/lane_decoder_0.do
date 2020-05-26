onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/hclk
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/hclk_reset
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/hclk_data_lane
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_cal_en
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_cal_busy
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_cal_load_tap
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_cal_tap_value
add wave -noupdate -expand -group lane_decoder_0 -expand -group {Register file} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/rclk
add wave -noupdate -expand -group lane_decoder_0 -expand -group {Register file} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/rclk_reset
add wave -noupdate -expand -group lane_decoder_0 -expand -group {Register file} -expand -subitemconfig {/testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/regfile.HISPI -expand /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/regfile.HISPI.STATUS -expand /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/regfile.HISPI.IDELAYCTRL_STATUS -expand /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/regfile.HISPI.LANE_DECODER_STATUS -expand /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/regfile.HISPI.LANE_DECODER_STATUS(0) -expand /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/regfile.HISPI.TAP_HISTOGRAM -expand /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/regfile.HISPI.LANE_PACKER_STATUS -expand} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/regfile
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_reset_Meta1
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_reset_Meta2
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_reset
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_shift_register
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_data
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_data_p1
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_bit_locked
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_cal_busy_int
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_cal_error
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_hispi_phy_en
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_hispi_data_path_en
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_embeded_data
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_sof_flag
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_eof_flag
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_sol_flag
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_eol_flag
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_fifo_overrun
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_fifo_wen
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_fifo_full
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_packer_mux
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_state
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_dataCntr
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_sync_detected
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_packer_valid
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_sync_error
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_packer_0_valid
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_packer_1_valid
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_packer_2_valid
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_packer_3_valid
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_packer_0
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_packer_1
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_packer_2
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_packer_3
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_crc_enable
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_tap_histogram
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/sclk_fifo_empty_int
add wave -noupdate -expand -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/sclk_fifo_underrun
add wave -noupdate -expand -group lane_decoder_0 -expand -group {rclk Clock domain} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/rclk_enable_hispi
add wave -noupdate -expand -group lane_decoder_0 -expand -group {rclk Clock domain} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/rclk_sync_error
add wave -noupdate -expand -group lane_decoder_0 -expand -group {rclk Clock domain} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/rclk_cal_busy_rise
add wave -noupdate -expand -group lane_decoder_0 -expand -group {rclk Clock domain} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/rclk_cal_busy_fall
add wave -noupdate -expand -group lane_decoder_0 -expand -group {rclk Clock domain} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/rclk_tap_histogram
add wave -noupdate -expand -group lane_decoder_0 -expand -group {rclk Clock domain} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/rclk_fifo_overrun
add wave -noupdate -expand -group lane_decoder_0 -expand -group {rclk Clock domain} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/rclk_fifo_underrun
add wave -noupdate -expand -group lane_decoder_0 -expand -group {rclk Clock domain} -divider {To Registerfile}
add wave -noupdate -expand -group lane_decoder_0 -expand -group {rclk Clock domain} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/rclk_cal_done
add wave -noupdate -expand -group lane_decoder_0 -expand -group {rclk Clock domain} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/rclk_cal_error
add wave -noupdate -expand -group lane_decoder_0 -expand -group {rclk Clock domain} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/rclk_bit_locked_fall
add wave -noupdate -expand -group lane_decoder_0 -expand -group {rclk Clock domain} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/rclk_bit_locked
add wave -noupdate -expand -group lane_decoder_0 -expand -group {FiFo output Interface} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/sclk
add wave -noupdate -expand -group lane_decoder_0 -expand -group {FiFo output Interface} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/sclk_reset
add wave -noupdate -expand -group lane_decoder_0 -expand -group {FiFo output Interface} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/sclk_fifo_read_en
add wave -noupdate -expand -group lane_decoder_0 -expand -group {FiFo output Interface} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/sclk_fifo_empty
add wave -noupdate -expand -group lane_decoder_0 -expand -group {FiFo output Interface} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/sclk_fifo_read_data_valid
add wave -noupdate -expand -group lane_decoder_0 -expand -group {FiFo output Interface} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/sclk_fifo_read_data
add wave -noupdate -expand -group lane_decoder_0 -expand -group {FiFo output Interface} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/sclk_sof_flag
add wave -noupdate -expand -group lane_decoder_0 -expand -group {FiFo output Interface} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/sclk_eof_flag
add wave -noupdate -expand -group lane_decoder_0 -expand -group {FiFo output Interface} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/sclk_sol_flag
add wave -noupdate -expand -group lane_decoder_0 -expand -group {FiFo output Interface} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/sclk_eol_flag
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {720212323 ps} 0} {{Cursor 2} {1193806672 ps} 0}
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
WaveRestoreZoom {0 ps} {3296194530 ps}
