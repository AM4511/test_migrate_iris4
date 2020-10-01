onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hispi_serial_clk_p
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hispi_serial_clk_n
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hispi_serial_input_p
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hispi_serial_input_n
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hispi_pix_clk
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/rclk
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/rclk_reset
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/regfile
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/bitslip
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_div2
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_reset_vect
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_reset
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_state
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_lane_enable
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_start_calibration
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_calibration_pending
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_calibration_done
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_serdes_data
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_lane_data
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_manual_calibration_en
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_manual_calibration_load
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_lane_reset
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_tap_cntr
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_cal_start_monitor_pulse
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_reset
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_tap_in
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_tap_out
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_data_ce
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_data_inc
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_latch_cal_status
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_cal_en_pulse
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_wait_cntr
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/pclk
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/pclk_reset
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/pclk_reset_Meta1
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/pclk_reset_Meta2
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/pclk_cal_en
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/pclk_cal_start_monitor
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/pclk_cal_monitor_done
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/pclk_cal_busy
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/pclk_valid
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/pclk_cal_tap_value
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/pclk_tap_histogram
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/pclk_tap_cntr
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/rclk_latch_cal_status
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/rclk_manual_calibration_tap
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/rclk_cal_tap_value
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/rclk_nb_lanes
add wave -noupdate -expand -group hispi_phy_top /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/rclk_tap_histogram
add wave -noupdate -expand -group hispi_phy_top -expand -group {FiFo read I/F} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/sclk
add wave -noupdate -expand -group hispi_phy_top -expand -group {FiFo read I/F} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/sclk_reset
add wave -noupdate -expand -group hispi_phy_top -expand -group {FiFo read I/F} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/sclk_reset_phy
add wave -noupdate -expand -group hispi_phy_top -expand -group {FiFo read I/F} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/sclk_start_calibration
add wave -noupdate -expand -group hispi_phy_top -expand -group {FiFo read I/F} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/sclk_calibration_done
add wave -noupdate -expand -group hispi_phy_top -expand -group {FiFo read I/F} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/sclk_fifo_empty
add wave -noupdate -expand -group hispi_phy_top -expand -group {FiFo read I/F} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/sclk_fifo_read_en
add wave -noupdate -expand -group hispi_phy_top -expand -group {FiFo read I/F} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/sclk_fifo_read_data_valid
add wave -noupdate -expand -group hispi_phy_top -expand -group {FiFo read I/F} -expand /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/sclk_fifo_read_data
add wave -noupdate -expand -group hispi_phy_top -expand -group {FiFo read I/F} -expand /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/sclk_fifo_read_sync
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1272368877 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 262
configure wave -valuecolwidth 191
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
WaveRestoreZoom {1231812540 ps} {1232024868 ps}
