onerror {resume}
quietly virtual signal -install /testbench/DUT/xdpc_filter { (context /testbench/DUT/xdpc_filter )( s_axis_tdata(79 downto 72) & s_axis_tdata(69 downto 62) & s_axis_tdata(59 downto 52) & s_axis_tdata(49 downto 42) & s_axis_tdata(39 downto 32) & s_axis_tdata(29 downto 22) & s_axis_tdata(19 downto 12) & s_axis_tdata(9 downto 2) )} s_axis_tdata64
quietly WaveActivateNextPane {} 0
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xoutput_fifo/wClk
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xoutput_fifo/rClk
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/pclk
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/hclk
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/hclk_reset
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/hclk_data_lane
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_cal_en
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_cal_busy
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_cal_load_tap
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_cal_tap_value
add wave -noupdate -group lane_decoder_0 -group {Register file} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/rclk
add wave -noupdate -group lane_decoder_0 -group {Register file} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/rclk_reset
add wave -noupdate -group lane_decoder_0 -group {Register file} -expand -subitemconfig {/testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/regfile.HISPI -expand /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/regfile.HISPI.STATUS -expand /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/regfile.HISPI.IDELAYCTRL_STATUS -expand /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/regfile.HISPI.LANE_DECODER_STATUS -expand /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/regfile.HISPI.LANE_DECODER_STATUS(0) -expand /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/regfile.HISPI.TAP_HISTOGRAM -expand /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/regfile.HISPI.LANE_PACKER_STATUS -expand} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/regfile
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_reset_Meta1
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_reset_Meta2
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_reset
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_shift_register
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_data
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_data_p1
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_bit_locked
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_cal_busy_int
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_cal_error
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_hispi_phy_en
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_hispi_data_path_en
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_embeded_data
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_sof_flag
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_eof_flag
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_sol_flag
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_eol_flag
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_fifo_overrun
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_fifo_wen
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_fifo_full
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_packer_mux
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_state
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_dataCntr
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_sync_detected
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_packer_valid
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_sync_error
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_packer_0_valid
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_packer_1_valid
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_packer_2_valid
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_packer_3_valid
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_packer_0
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_packer_1
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_packer_2
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_packer_3
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_crc_enable
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_tap_histogram
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/sclk_fifo_empty_int
add wave -noupdate -group lane_decoder_0 /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/sclk_fifo_underrun
add wave -noupdate -group lane_decoder_0 -expand -group {rclk Clock domain} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/rclk_enable_hispi
add wave -noupdate -group lane_decoder_0 -expand -group {rclk Clock domain} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/rclk_sync_error
add wave -noupdate -group lane_decoder_0 -expand -group {rclk Clock domain} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/rclk_cal_busy_rise
add wave -noupdate -group lane_decoder_0 -expand -group {rclk Clock domain} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/rclk_cal_busy_fall
add wave -noupdate -group lane_decoder_0 -expand -group {rclk Clock domain} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/rclk_tap_histogram
add wave -noupdate -group lane_decoder_0 -expand -group {rclk Clock domain} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/rclk_fifo_overrun
add wave -noupdate -group lane_decoder_0 -expand -group {rclk Clock domain} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/rclk_fifo_underrun
add wave -noupdate -group lane_decoder_0 -expand -group {rclk Clock domain} -divider {To Registerfile}
add wave -noupdate -group lane_decoder_0 -expand -group {rclk Clock domain} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/rclk_cal_done
add wave -noupdate -group lane_decoder_0 -expand -group {rclk Clock domain} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/rclk_cal_error
add wave -noupdate -group lane_decoder_0 -expand -group {rclk Clock domain} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/rclk_bit_locked_fall
add wave -noupdate -group lane_decoder_0 -expand -group {rclk Clock domain} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/rclk_bit_locked
add wave -noupdate -group lane_decoder_0 -expand -group {FiFo output Interface} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/sclk
add wave -noupdate -group lane_decoder_0 -expand -group {FiFo output Interface} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/sclk_reset
add wave -noupdate -group lane_decoder_0 -expand -group {FiFo output Interface} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/sclk_fifo_read_en
add wave -noupdate -group lane_decoder_0 -expand -group {FiFo output Interface} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/sclk_fifo_empty
add wave -noupdate -group lane_decoder_0 -expand -group {FiFo output Interface} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/sclk_fifo_read_data_valid
add wave -noupdate -group lane_decoder_0 -expand -group {FiFo output Interface} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/sclk_fifo_read_data
add wave -noupdate -group lane_decoder_0 -expand -group {FiFo output Interface} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/sclk_sof_flag
add wave -noupdate -group lane_decoder_0 -expand -group {FiFo output Interface} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/sclk_eof_flag
add wave -noupdate -group lane_decoder_0 -expand -group {FiFo output Interface} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/sclk_sol_flag
add wave -noupdate -group lane_decoder_0 -expand -group {FiFo output Interface} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/sclk_eol_flag
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/rclk
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/rclk_reset
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/regfile
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/sclk
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/sclk_reset
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/enable
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/init_packer
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/odd_line
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/line_valid
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/busy
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/line_buffer_id
add wave -noupdate -group {Lane packer 0} -expand -group {top decoder I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/top_sync
add wave -noupdate -group {Lane packer 0} -expand -group {top decoder I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/top_fifo_read_en
add wave -noupdate -group {Lane packer 0} -expand -group {top decoder I/F} -color Magenta /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/top_fifo_empty
add wave -noupdate -group {Lane packer 0} -expand -group {top decoder I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/top_fifo_read_data_valid
add wave -noupdate -group {Lane packer 0} -expand -group {top decoder I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/top_fifo_read_data
add wave -noupdate -group {Lane packer 0} -expand -group {bottom decoder I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/bottom_sync
add wave -noupdate -group {Lane packer 0} -expand -group {bottom decoder I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/bottom_fifo_read_en
add wave -noupdate -group {Lane packer 0} -expand -group {bottom decoder I/F} -color Magenta /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/bottom_fifo_empty
add wave -noupdate -group {Lane packer 0} -expand -group {bottom decoder I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/bottom_fifo_read_data_valid
add wave -noupdate -group {Lane packer 0} -expand -group {bottom decoder I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/bottom_fifo_read_data
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/state
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/output_state
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/packer_max_count
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/load_data
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/pix_packer_wren
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/pix_packer
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/pix_offset_stripe_0
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/pix_offset_stripe_1
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/pix_offset_stripe_2
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/pix_offset_stripe_3
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/pix_offset_mux
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/pix_in_cntr
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/line_buffer_offset
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/lane_decoder_read
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/lane_id
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/pix_even
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/pix_odd
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/fifo_rd
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/fifo_wr
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/fifo_wdata
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/fifo_rdata
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/fifo_full
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/fifo_empty
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/fifo_usedw
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/fifo_usedw_max
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/packer_fifo_overrun
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/packer_fifo_underrun
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/rclk_packer_fifo_overrun
add wave -noupdate -group {Lane packer 0} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/rclk_packer_fifo_underrun
add wave -noupdate -group {Lane packer 0} -group {Line buffer I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/lane_packer_ack
add wave -noupdate -group {Lane packer 0} -group {Line buffer I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/lane_packer_req
add wave -noupdate -group {Lane packer 0} -group {Line buffer I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/lane_packer_write
add wave -noupdate -group {Lane packer 0} -group {Line buffer I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/lane_packer_addr
add wave -noupdate -group {Lane packer 0} -group {Line buffer I/F} /testbench/DUT/x_xgs_hispi_top/G_lane_packer(0)/xlane_packer/lane_packer_data
add wave -noupdate -group {line buffer} /testbench/DUT/x_xgs_hispi_top/xline_buffer/sysclk
add wave -noupdate -group {line buffer} /testbench/DUT/x_xgs_hispi_top/xline_buffer/sysrst
add wave -noupdate -group {line buffer} /testbench/DUT/x_xgs_hispi_top/xline_buffer/buffer_enable
add wave -noupdate -group {line buffer} /testbench/DUT/x_xgs_hispi_top/xline_buffer/init_frame
add wave -noupdate -group {line buffer} -expand -group {Input I/F} /testbench/DUT/x_xgs_hispi_top/xline_buffer/nxtBuffer
add wave -noupdate -group {line buffer} -expand -group {Input I/F} /testbench/DUT/x_xgs_hispi_top/xline_buffer/lane_packer_req
add wave -noupdate -group {line buffer} -expand -group {Input I/F} /testbench/DUT/x_xgs_hispi_top/xline_buffer/lane_packer_ack
add wave -noupdate -group {line buffer} -expand -group {Input I/F} -radix unsigned /testbench/DUT/x_xgs_hispi_top/xline_buffer/row_id
add wave -noupdate -group {line buffer} -expand -group {Input I/F} /testbench/DUT/x_xgs_hispi_top/xline_buffer/buff_write
add wave -noupdate -group {line buffer} -expand -group {Input I/F} /testbench/DUT/x_xgs_hispi_top/xline_buffer/buff_addr
add wave -noupdate -group {line buffer} -expand -group {Input I/F} /testbench/DUT/x_xgs_hispi_top/xline_buffer/buff_data
add wave -noupdate -group {line buffer} /testbench/DUT/x_xgs_hispi_top/xline_buffer/sysrst_n
add wave -noupdate -group {line buffer} /testbench/DUT/x_xgs_hispi_top/xline_buffer/lane_grant
add wave -noupdate -group {line buffer} /testbench/DUT/x_xgs_hispi_top/xline_buffer/write_buffer_ptr
add wave -noupdate -group {line buffer} /testbench/DUT/x_xgs_hispi_top/xline_buffer/pixel_id
add wave -noupdate -group {line buffer} -expand /testbench/DUT/x_xgs_hispi_top/xline_buffer/buffer_row_id
add wave -noupdate -group {line buffer} /testbench/DUT/x_xgs_hispi_top/xline_buffer/buffer_row_info
add wave -noupdate -group {line buffer} /testbench/DUT/x_xgs_hispi_top/xline_buffer/buffer_write_en
add wave -noupdate -group {line buffer} /testbench/DUT/x_xgs_hispi_top/xline_buffer/buffer_write_address
add wave -noupdate -group {line buffer} /testbench/DUT/x_xgs_hispi_top/xline_buffer/buffer_write_data
add wave -noupdate -group {line buffer} /testbench/DUT/x_xgs_hispi_top/xline_buffer/buffer_read_address
add wave -noupdate -group {line buffer} -expand /testbench/DUT/x_xgs_hispi_top/xline_buffer/buffer_ready
add wave -noupdate -group {line buffer} /testbench/DUT/x_xgs_hispi_top/xline_buffer/nxtBuffer_ff
add wave -noupdate -group {line buffer} -expand -group {Output I/F} /testbench/DUT/x_xgs_hispi_top/xline_buffer/line_buffer_clr
add wave -noupdate -group {line buffer} -expand -group {Output I/F} /testbench/DUT/x_xgs_hispi_top/xline_buffer/line_buffer_ready
add wave -noupdate -group {line buffer} -expand -group {Output I/F} /testbench/DUT/x_xgs_hispi_top/xline_buffer/line_buffer_read
add wave -noupdate -group {line buffer} -expand -group {Output I/F} /testbench/DUT/x_xgs_hispi_top/xline_buffer/line_buffer_ptr
add wave -noupdate -group {line buffer} -expand -group {Output I/F} /testbench/DUT/x_xgs_hispi_top/xline_buffer/line_buffer_address
add wave -noupdate -group {line buffer} -expand -group {Output I/F} -radix unsigned /testbench/DUT/x_xgs_hispi_top/xline_buffer/line_buffer_row_id
add wave -noupdate -group {line buffer} -expand -group {Output I/F} /testbench/DUT/x_xgs_hispi_top/xline_buffer/line_buffer_data
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_reset
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/streamer_en
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/streamer_busy
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/transfert_done
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/init_frame
add wave -noupdate -group axi_line_streamer -radix unsigned /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/x_row_start
add wave -noupdate -group axi_line_streamer -radix unsigned /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/x_row_stop
add wave -noupdate -group axi_line_streamer -radix unsigned /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/y_row_start
add wave -noupdate -group axi_line_streamer -radix unsigned /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/y_row_stop
add wave -noupdate -group axi_line_streamer -group {Line buffer I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/line_buffer_clr
add wave -noupdate -group axi_line_streamer -group {Line buffer I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/line_buffer_ready
add wave -noupdate -group axi_line_streamer -group {Line buffer I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/line_buffer_read
add wave -noupdate -group axi_line_streamer -group {Line buffer I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/line_buffer_ptr
add wave -noupdate -group axi_line_streamer -group {Line buffer I/F} -radix unsigned /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/line_buffer_address
add wave -noupdate -group axi_line_streamer -group {Line buffer I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/line_buffer_row_id
add wave -noupdate -group axi_line_streamer -group {Line buffer I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/line_buffer_data
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/m_wait
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/state
add wave -noupdate -group axi_line_streamer -radix decimal /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/burst_length
add wave -noupdate -group axi_line_streamer -radix unsigned /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/burst_cntr
add wave -noupdate -group axi_line_streamer -radix unsigned /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/buffer_address
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/read_en
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/read_data_valid
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/first_row
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/last_row
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/buffer_read_ptr
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/start_transfer
add wave -noupdate -group axi_line_streamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tvalid_int
add wave -noupdate -group axi_line_streamer -expand -group {AXI Stream output I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tready
add wave -noupdate -group axi_line_streamer -expand -group {AXI Stream output I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tvalid
add wave -noupdate -group axi_line_streamer -expand -group {AXI Stream output I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tuser
add wave -noupdate -group axi_line_streamer -expand -group {AXI Stream output I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tlast
add wave -noupdate -group axi_line_streamer -expand -group {AXI Stream output I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tdata
add wave -noupdate -group mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/regfile
add wave -noupdate -group mono_pipeline -color {Dark Orchid} /testbench/DUT/xgs_mono_pipeline_inst/sclk
add wave -noupdate -group mono_pipeline -color {Dark Orchid} /testbench/DUT/xgs_mono_pipeline_inst/sclk_reset_n
add wave -noupdate -group mono_pipeline -color {Dark Orchid} /testbench/DUT/xgs_mono_pipeline_inst/sclk_tuser
add wave -noupdate -group mono_pipeline -color {Dark Orchid} /testbench/DUT/xgs_mono_pipeline_inst/sclk_tvalid
add wave -noupdate -group mono_pipeline -color {Dark Orchid} /testbench/DUT/xgs_mono_pipeline_inst/sclk_tready
add wave -noupdate -group mono_pipeline -color {Dark Orchid} /testbench/DUT/xgs_mono_pipeline_inst/sclk_tdata
add wave -noupdate -group mono_pipeline -color {Dark Orchid} /testbench/DUT/xgs_mono_pipeline_inst/sclk_tlast
add wave -noupdate -group mono_pipeline -color Gold /testbench/DUT/xgs_mono_pipeline_inst/aclk
add wave -noupdate -group mono_pipeline -color Gold /testbench/DUT/xgs_mono_pipeline_inst/aclk_reset_n
add wave -noupdate -group mono_pipeline -color Gold /testbench/DUT/xgs_mono_pipeline_inst/aclk_tuser
add wave -noupdate -group mono_pipeline -color Gold /testbench/DUT/xgs_mono_pipeline_inst/aclk_tvalid
add wave -noupdate -group mono_pipeline -color Gold /testbench/DUT/xgs_mono_pipeline_inst/aclk_tready
add wave -noupdate -group mono_pipeline -color Gold /testbench/DUT/xgs_mono_pipeline_inst/aclk_tdata
add wave -noupdate -group mono_pipeline -color Gold /testbench/DUT/xgs_mono_pipeline_inst/aclk_tlast
add wave -noupdate -group mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_state
add wave -noupdate -group mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_reset
add wave -noupdate -group mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_wen
add wave -noupdate -group mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_full
add wave -noupdate -group mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_data_phase
add wave -noupdate -group mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_data
add wave -noupdate -group mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_load_data
add wave -noupdate -group mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_last_data
add wave -noupdate -group mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_sync_packer
add wave -noupdate -group mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_data_packer
add wave -noupdate -group mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_packer_valid
add wave -noupdate -group mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_pix_cntr
add wave -noupdate -group mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_pix_cntr_en
add wave -noupdate -group mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_pix_cntr_init
add wave -noupdate -group mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_read
add wave -noupdate -group mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_read_data
add wave -noupdate -group mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_empty
add wave -noupdate -group mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_tvalid_int
add wave -noupdate -group mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_read_data_valid
add wave -noupdate -group mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_tlast_int
add wave -noupdate -group mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_sync_packer
add wave -noupdate -group mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_tlast_packer
add wave -noupdate -group mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_pix_cntr
add wave -noupdate -group mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_pix_cntr_en
add wave -noupdate -group mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_pix_cntr_init
add wave -noupdate -group mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_tuser_int
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/pix_reset_n
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/sys_clk
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/sys_reset_n
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/curr_Xstart
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/curr_Xend
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/curr_Ystart
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/curr_Yend
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/REG_color
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/REG_dpc_enable
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/REG_dpc_pattern0_cfg
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/REG_dpc_fifo_rst
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/REG_dpc_fifo_ovr
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/REG_dpc_fifo_und
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/REG_dpc_list_wrn
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/REG_dpc_list_add
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/REG_dpc_list_ss
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/REG_dpc_list_count
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/REG_dpc_list_corr_pattern
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/REG_dpc_list_corr_y
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/REG_dpc_list_corr_x
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/REG_dpc_list_corr_rd
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/REG_dpc_firstlast_line_rem
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/pix_reset
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/s_axis_tready_int
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/curr_Xstart_integer
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/curr_Xend_integer
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/BAYER_Sensor
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/REG_dpc_enable_P1
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/REG_dpc_enable_P2
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/REG_dpc_enable_DB
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/dpc_sol_P1
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/dpc_data_enable_start
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/dpc_data_enable_stop
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/dpc_data_enable_P1
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/dpc_data_bypass
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/dpc_data_in_100_P1
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/dpc_data_in_100_P2
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/dpc_eol_P1
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/dpc_eol_P2
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/dpc_eol_P3
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/dpc_eof_P1
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/dpc_eof_P2
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/dpc_eof_P3
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/dpc_eof_P4
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/dpc_kernel_10x3_sof
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/dpc_kernel_10x3_sol
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/dpc_kernel_10x3_eol
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/dpc_kernel_10x3_eof
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/kernel_10x3_sof
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/kernel_10x3_sol
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/kernel_10x3_eol
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/kernel_10x3_en
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/kernel_10x3_out
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/kernel_10x3_eof
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/kernel_10x3_curr
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/proc_X_pix_curr
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/proc_first_col
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/proc_last_col
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/kernel_10x3_sof_P1
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/kernel_10x3_sol_P1
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/kernel_10x3_en_P1
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/kernel_10x3_eol_P1
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/kernel_10x3_eof_P1
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/kernel_10x3_sol_P2
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/kernel_10x3_en_P2
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/kernel_10x3_eol_P2
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/kernel_10x3_eof_P2
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/kernel_10x3_sol_P3
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/kernel_10x3_en_P3
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/kernel_10x3_eol_P3
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/kernel_10x3_eof_P3
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/kernel_10x3_sol_P4
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/kernel_10x3_en_P4
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/kernel_10x3_eol_P4
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/kernel_10x3_eof_P4
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/proc_sol
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/proc_en
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/proc_data
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/proc_eol
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/proc_eof
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/kernel_10x3_first_line
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/kernel_10x3_last_line
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/kernel_10x3_first_col
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/kernel_10x3_last_col
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/Pix_corr
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/Pix_corr_sof
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/Pix_corr_sol
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/Pix_corr_en
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/Pix_corr_eol
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/Pix_corr_eof
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/RAM_R_enable
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/RAM_R_enable_P1
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/RAM_R_address
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/RAM_R_data
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/RAM_R_end
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/RAM_R_end_P1
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/RAM_W_data
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/dpc_fifo_reset
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/dpc_fifo_reset_P1
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/dpc_fifo_reset_P2
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/dpc_fifo_reset_P3
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/dpc_fifo_reset_P4
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/dpc_fifo_reset_P5
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/dpc_fifo_reset_P6
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/dpc_fifo_reset_P7
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/dpc_fifo_data
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/dpc_fifo_write
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/dpc_fifo_list_rdy
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/alias_proc_data_3
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/alias_proc_data_2
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/alias_proc_data_1
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/alias_proc_data_0
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/alias_dpc_data_in_100_4_P2
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/alias_dpc_data_in_100_3_P2
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/alias_dpc_data_in_100_2_P2
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/alias_dpc_data_in_100_1_P2
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/alias_dpc_data_in_100_0_P2
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/alias_dpc_data_in_100_L_P2
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/alias_dpc_data_in_100_3_P1
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/alias_dpc_data_in_100_2_P1
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/alias_dpc_data_in_100_1_P1
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/alias_dpc_data_in_100_0_P1
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/alias_fpnprnu_corr_data_3
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/alias_fpnprnu_corr_data_2
add wave -noupdate -expand -group dcp /testbench/DUT/xdpc_filter/alias_fpnprnu_corr_data_0
add wave -noupdate -divider {AXI SLAVE}
add wave -noupdate -color {Medium Violet Red} /testbench/DUT/xdpc_filter/s_axis_tvalid
add wave -noupdate -color {Medium Violet Red} /testbench/DUT/xdpc_filter/s_axis_tready
add wave -noupdate -color {Medium Violet Red} /testbench/DUT/xdpc_filter/s_axis_tuser
add wave -noupdate -color {Medium Violet Red} /testbench/DUT/xdpc_filter/s_axis_tdata
add wave -noupdate /testbench/DUT/xdpc_filter/s_axis_tdata64
add wave -noupdate -color {Medium Violet Red} /testbench/DUT/xdpc_filter/s_axis_tlast
add wave -noupdate /testbench/DUT/xdpc_filter/s_axis_tready_int
add wave -noupdate /testbench/DUT/xdpc_filter/s_axis_first_line
add wave -noupdate /testbench/DUT/xdpc_filter/s_axis_first_prefetch
add wave -noupdate /testbench/DUT/xdpc_filter/s_axis_prefetch
add wave -noupdate /testbench/DUT/xdpc_filter/s_axis_prefetch_done
add wave -noupdate /testbench/DUT/xdpc_filter/s_axis_prefetch_cnt
add wave -noupdate -divider {Kernel 10x3 IN}
add wave -noupdate /testbench/DUT/xdpc_filter/dpc_kernel_10x3_sof
add wave -noupdate /testbench/DUT/xdpc_filter/dpc_kernel_10x3_sol
add wave -noupdate /testbench/DUT/xdpc_filter/dpc_data_enable_P1
add wave -noupdate /testbench/DUT/xdpc_filter/dpc_data_in_100_P2
add wave -noupdate /testbench/DUT/xdpc_filter/dpc_kernel_10x3_eol
add wave -noupdate /testbench/DUT/xdpc_filter/dpc_kernel_10x3_eof
add wave -noupdate -divider {Kernel 10x3 OUT}
add wave -noupdate /testbench/DUT/xdpc_filter/kernel_10x3_sof
add wave -noupdate /testbench/DUT/xdpc_filter/kernel_10x3_sol
add wave -noupdate /testbench/DUT/xdpc_filter/kernel_10x3_en
add wave -noupdate /testbench/DUT/xdpc_filter/kernel_10x3_out
add wave -noupdate /testbench/DUT/xdpc_filter/kernel_10x3_eol
add wave -noupdate /testbench/DUT/xdpc_filter/kernel_10x3_eof
add wave -noupdate /testbench/DUT/xdpc_filter/kernel_10x3_first_line
add wave -noupdate /testbench/DUT/xdpc_filter/kernel_10x3_last_line
add wave -noupdate /testbench/DUT/xdpc_filter/kernel_10x3_first_col
add wave -noupdate /testbench/DUT/xdpc_filter/kernel_10x3_last_col
add wave -noupdate -divider {PROC OUT}
add wave -noupdate /testbench/DUT/xdpc_filter/proc_sol
add wave -noupdate /testbench/DUT/xdpc_filter/proc_en
add wave -noupdate /testbench/DUT/xdpc_filter/proc_data
add wave -noupdate /testbench/DUT/xdpc_filter/proc_eol
add wave -noupdate /testbench/DUT/xdpc_filter/proc_eof
add wave -noupdate -divider {New Divider}
add wave -noupdate /testbench/DUT/xdpc_filter/Pix_corr_sof
add wave -noupdate /testbench/DUT/xdpc_filter/Pix_corr_sol
add wave -noupdate /testbench/DUT/xdpc_filter/Pix_corr_en
add wave -noupdate /testbench/DUT/xdpc_filter/Pix_corr
add wave -noupdate /testbench/DUT/xdpc_filter/Pix_corr_eol
add wave -noupdate /testbench/DUT/xdpc_filter/Pix_corr_eof
add wave -noupdate /testbench/DUT/xdpc_filter/m_axis_wait
add wave -noupdate /testbench/DUT/xdpc_filter/m_axis_wait_data
add wave -noupdate /testbench/DUT/xdpc_filter/m_axis_tvalid_int
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {AXI MASTER}
add wave -noupdate /testbench/DUT/xdpc_filter/pix_clk
add wave -noupdate -color Yellow /testbench/DUT/xdpc_filter/m_axis_tvalid
add wave -noupdate -color Yellow /testbench/DUT/xdpc_filter/m_axis_tready
add wave -noupdate -color Yellow /testbench/DUT/xdpc_filter/m_axis_tuser
add wave -noupdate -color Yellow /testbench/DUT/xdpc_filter/m_axis_tdata
add wave -noupdate -color Yellow -label m_axis_tdata64 /testbench/DUT/aclk_tdata64
add wave -noupdate -color Yellow /testbench/DUT/xdpc_filter/m_axis_tlast
add wave -noupdate /testbench/DUT/xdpc_filter/m_axis_tdata_int
add wave -noupdate /testbench/DUT/xdpc_filter/m_axis_wait_data
add wave -noupdate /testbench/DUT/xdpc_filter/m_axis_wait
add wave -noupdate -divider {New Divider}
add wave -noupdate /testbench/DUT/xdpc_filter/Xdpc_kernel_10x3/first_col_out
add wave -noupdate /testbench/DUT/xdpc_filter/Xdpc_kernel_10x3/first_line_out
add wave -noupdate /testbench/DUT/xdpc_filter/Xdpc_kernel_10x3/last_col_out
add wave -noupdate /testbench/DUT/xdpc_filter/Xdpc_kernel_10x3/last_line_out
add wave -noupdate /testbench/DUT/xdpc_filter/Xdpc_kernel_10x3/start_of_frame_out
add wave -noupdate /testbench/DUT/xdpc_filter/Xdpc_kernel_10x3/start_of_line_out
add wave -noupdate /testbench/DUT/xdpc_filter/Xdpc_kernel_10x3/neighbor_en
add wave -noupdate /testbench/DUT/xdpc_filter/Xdpc_kernel_10x3/neighbor_out
add wave -noupdate /testbench/DUT/xdpc_filter/Xdpc_kernel_10x3/end_of_line_out
add wave -noupdate /testbench/DUT/xdpc_filter/Xdpc_kernel_10x3/end_of_frame_out
add wave -noupdate -divider {New Divider}
add wave -noupdate /testbench/DUT/xdpc_filter/Xdpc_kernel_10x3/eof_os
add wave -noupdate /testbench/DUT/xdpc_filter/Xdpc_kernel_10x3/m_axis_ack
add wave -noupdate /testbench/DUT/xdpc_filter/Xdpc_kernel_10x3/last_line_fifo_rd_started
add wave -noupdate /testbench/DUT/xdpc_filter/Xdpc_kernel_10x3/last_line_fifo_rd_prefetch
add wave -noupdate /testbench/DUT/xdpc_filter/Xdpc_kernel_10x3/last_line_fifo_rd
add wave -noupdate /testbench/DUT/xdpc_filter/Xdpc_kernel_10x3/last_line_fifo_en
add wave -noupdate /testbench/DUT/xdpc_filter/Xdpc_kernel_10x3/eol_P1
add wave -noupdate -radix unsigned /testbench/DUT/xdpc_filter/Xdpc_kernel_10x3/last_line_fifo_rd_cntr
add wave -noupdate /testbench/DUT/xdpc_filter/Xdpc_kernel_10x3/lbuff_wren_first
add wave -noupdate /testbench/DUT/xdpc_filter/Xdpc_kernel_10x3/lbuff_wren_second
add wave -noupdate -radix unsigned /testbench/DUT/xdpc_filter/Xdpc_kernel_10x3/lbuff_line_length
add wave -noupdate /testbench/DUT/xdpc_filter/Xdpc_kernel_10x3/last_line_fifo_rd_P1
add wave -noupdate /testbench/DUT/xdpc_filter/Xdpc_kernel_10x3/lbuff_first_empty
add wave -noupdate /testbench/DUT/xdpc_filter/Xdpc_kernel_10x3/last_line_fifo_rd_P2
add wave -noupdate /testbench/DUT/xdpc_filter/Xdpc_kernel_10x3/last_line_fifo_rd_P3
add wave -noupdate /testbench/DUT/xdpc_filter/Xdpc_kernel_10x3/last_line_fifo_eol_P2
add wave -noupdate /testbench/DUT/xdpc_filter/Xdpc_kernel_10x3/last_line_fifo_eol_P1
add wave -noupdate /testbench/DUT/xdpc_filter/Xdpc_kernel_10x3/last_line_fifo_eol
add wave -noupdate /testbench/DUT/xdpc_filter/alias_fpnprnu_corr_data_1
add wave -noupdate /testbench/DUT/xdpc_filter/Xdpc_kernel_10x3/lbuff_second_empty
add wave -noupdate /testbench/DUT/xdpc_filter/Xdpc_kernel_10x3/lbuff_first_full
add wave -noupdate /testbench/DUT/xdpc_filter/Xdpc_kernel_10x3/lbuff_second_full
add wave -noupdate /testbench/DUT/xdpc_filter/Xdpc_kernel_10x3/lbuff_first_overflow
add wave -noupdate /testbench/DUT/xdpc_filter/Xdpc_kernel_10x3/lbuff_second_overflow
add wave -noupdate /testbench/DUT/xdpc_filter/Xdpc_kernel_10x3/lbuff_first_underflow
add wave -noupdate /testbench/DUT/xdpc_filter/Xdpc_kernel_10x3/lbuff_second_underflow
add wave -noupdate -divider {New Divider}
add wave -noupdate -group TLP /testbench/DUT/tlp_transaction_id
add wave -noupdate -group TLP /testbench/DUT/tlp_req_to_send
add wave -noupdate -group TLP /testbench/DUT/tlp_grant
add wave -noupdate -group TLP /testbench/DUT/tlp_length_in_dw
add wave -noupdate -group TLP /testbench/DUT/tlp_byte_count
add wave -noupdate -group TLP /testbench/DUT/tlp_src_rdy_n
add wave -noupdate -group TLP /testbench/DUT/tlp_dst_rdy_n
add wave -noupdate -group TLP /testbench/DUT/tlp_data
add wave -noupdate -group TLP /testbench/DUT/tlp_lower_address
add wave -noupdate -group TLP /testbench/DUT/tlp_ldwbe_fdwbe
add wave -noupdate -group TLP /testbench/DUT/tlp_fmt_type
add wave -noupdate -group TLP /testbench/DUT/tlp_attr
add wave -noupdate -group TLP /testbench/DUT/tlp_address
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 8} {1543709737 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 186
configure wave -valuecolwidth 171
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
WaveRestoreZoom {1501559610 ps} {1714152871 ps}
