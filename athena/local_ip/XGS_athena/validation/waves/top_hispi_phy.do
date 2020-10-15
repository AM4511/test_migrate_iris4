onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hispi_serial_clk_p
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hispi_serial_clk_n
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hispi_serial_input_p
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hispi_serial_input_n
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hispi_pix_clk
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/rclk
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/rclk_reset
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/regfile
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/sclk
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/sclk_reset
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/sclk_reset_phy
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/sclk_start_calibration
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/sclk_calibration_done
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/sclk_fifo_read_en
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/sclk_fifo_empty
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/sclk_fifo_read_data_valid
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/sclk_fifo_read_data
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/sclk_sof_flag
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/sclk_eof_flag
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/sclk_sol_flag
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/sclk_eol_flag
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/bitslip
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_div2
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_reset_vect
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_reset
add wave -noupdate -expand -group top_hispi_phy -color Gold /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_start_calibration
add wave -noupdate -expand -group top_hispi_phy -color Gold /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_state
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_calibration_done
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_serdes_data
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_lane_data
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_lane_enabled
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_lane_reset
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_tap_cntr
add wave -noupdate -expand -group top_hispi_phy -radix binary /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_cal_start_monitor_pulse
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/pclk_cal_start_monitor
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_manual_calibration_en
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_manual_calibration_load
add wave -noupdate -expand -group top_hispi_phy -color Plum /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_reset
add wave -noupdate -expand -group top_hispi_phy -color Plum -radix unsigned -childformat {{/testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_tap_in(14) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_tap_in(13) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_tap_in(12) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_tap_in(11) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_tap_in(10) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_tap_in(9) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_tap_in(8) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_tap_in(7) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_tap_in(6) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_tap_in(5) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_tap_in(4) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_tap_in(3) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_tap_in(2) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_tap_in(1) -radix unsigned} {/testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_tap_in(0) -radix unsigned}} -subitemconfig {/testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_tap_in(14) {-color Plum -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_tap_in(13) {-color Plum -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_tap_in(12) {-color Plum -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_tap_in(11) {-color Plum -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_tap_in(10) {-color Plum -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_tap_in(9) {-color Plum -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_tap_in(8) {-color Plum -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_tap_in(7) {-color Plum -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_tap_in(6) {-color Plum -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_tap_in(5) {-color Plum -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_tap_in(4) {-color Plum -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_tap_in(3) {-color Plum -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_tap_in(2) {-color Plum -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_tap_in(1) {-color Plum -radix unsigned} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_tap_in(0) {-color Plum -radix unsigned}} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_tap_in
add wave -noupdate -expand -group top_hispi_phy -color Plum /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_tap_out
add wave -noupdate -expand -group top_hispi_phy -color Plum /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_data_ce
add wave -noupdate -expand -group top_hispi_phy -color Plum /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_delay_data_inc
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/pclk
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/pclk_cal_en
add wave -noupdate -expand -group top_hispi_phy -expand /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/pclk_cal_monitor_done
add wave -noupdate -expand -group top_hispi_phy -expand /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/pclk_cal_busy
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/pclk_cal_tap_value
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/rclk_latch_cal_status
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/rclk_manual_calibration_tap
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/rclk_cal_tap_value
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/rclk_nb_lanes
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1036753136 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 301
configure wave -valuecolwidth 264
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
WaveRestoreZoom {1014927273 ps} {1051128292 ps}
