onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group {HiSPi PHY TOP} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hispi_serial_clk_p
add wave -noupdate -group {HiSPi PHY TOP} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hispi_serial_clk_n
add wave -noupdate -group {HiSPi PHY TOP} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hispi_serial_input_p
add wave -noupdate -group {HiSPi PHY TOP} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hispi_serial_input_n
add wave -noupdate -group {HiSPi PHY TOP} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hispi_pix_clk
add wave -noupdate -group {HiSPi PHY TOP} -group {Registerfile I/F} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/rclk
add wave -noupdate -group {HiSPi PHY TOP} -group {Registerfile I/F} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/rclk_reset
add wave -noupdate -group {HiSPi PHY TOP} -group {Registerfile I/F} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/regfile
add wave -noupdate -group {HiSPi PHY TOP} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk
add wave -noupdate -group {HiSPi PHY TOP} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_div2
add wave -noupdate -group {HiSPi PHY TOP} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_reset_vect
add wave -noupdate -group {HiSPi PHY TOP} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_reset
add wave -noupdate -group {HiSPi PHY TOP} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_state
add wave -noupdate -group {HiSPi PHY TOP} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_start_calibration
add wave -noupdate -group {HiSPi PHY TOP} -color {Steel Blue} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_calibration_done
add wave -noupdate -group {HiSPi PHY TOP} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_serdes_data
add wave -noupdate -group {HiSPi PHY TOP} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_lane_data
add wave -noupdate -group {HiSPi PHY TOP} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_manual_calibration_en
add wave -noupdate -group {HiSPi PHY TOP} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_manual_calibration_load
add wave -noupdate -group {HiSPi PHY TOP} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/delay_reset
add wave -noupdate -group {HiSPi PHY TOP} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/delay_tap_in
add wave -noupdate -group {HiSPi PHY TOP} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/delay_tap_out
add wave -noupdate -group {HiSPi PHY TOP} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/delay_data_ce
add wave -noupdate -group {HiSPi PHY TOP} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/delay_data_inc
add wave -noupdate -group {HiSPi PHY TOP} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/pclk
add wave -noupdate -group {HiSPi PHY TOP} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/pclk_cal_en
add wave -noupdate -group {HiSPi PHY TOP} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/pclk_cal_busy
add wave -noupdate -group {HiSPi PHY TOP} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/pclk_cal_load_tap
add wave -noupdate -group {HiSPi PHY TOP} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/pclk_cal_tap_value
add wave -noupdate -group {HiSPi PHY TOP} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/rclk_latch_cal_status
add wave -noupdate -group {HiSPi PHY TOP} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/rclk_manual_calibration_tap
add wave -noupdate -group {HiSPi PHY TOP} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/rclk_cal_tap_value
add wave -noupdate -group {HiSPi PHY TOP} -expand -group {Lane Packer FiFo read I/F} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/sclk
add wave -noupdate -group {HiSPi PHY TOP} -expand -group {Lane Packer FiFo read I/F} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/sclk_reset
add wave -noupdate -group {HiSPi PHY TOP} -expand -group {Lane Packer FiFo read I/F} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/sclk_reset_phy
add wave -noupdate -group {HiSPi PHY TOP} -expand -group {Lane Packer FiFo read I/F} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/sclk_start_calibration
add wave -noupdate -group {HiSPi PHY TOP} -expand -group {Lane Packer FiFo read I/F} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/sclk_calibration_done
add wave -noupdate -group {HiSPi PHY TOP} -expand -group {Lane Packer FiFo read I/F} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/sclk_fifo_read_en
add wave -noupdate -group {HiSPi PHY TOP} -expand -group {Lane Packer FiFo read I/F} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/sclk_fifo_empty
add wave -noupdate -group {HiSPi PHY TOP} -expand -group {Lane Packer FiFo read I/F} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/sclk_fifo_read_data_valid
add wave -noupdate -group {HiSPi PHY TOP} -expand -group {Lane Packer FiFo read I/F} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/sclk_fifo_read_data
add wave -noupdate -group {HiSPi PHY TOP} -expand -group {Lane Packer FiFo read I/F} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/sclk_sof_flag
add wave -noupdate -group {HiSPi PHY TOP} -expand -group {Lane Packer FiFo read I/F} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/sclk_eof_flag
add wave -noupdate -group {HiSPi PHY TOP} -expand -group {Lane Packer FiFo read I/F} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/sclk_sol_flag
add wave -noupdate -group {HiSPi PHY TOP} -expand -group {Lane Packer FiFo read I/F} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/sclk_eol_flag
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1157948316 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 257
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
WaveRestoreZoom {0 ps} {2396573359 ps}
