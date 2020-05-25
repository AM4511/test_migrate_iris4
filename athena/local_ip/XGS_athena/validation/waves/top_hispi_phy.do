onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hispi_serial_clk_p
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hispi_serial_clk_n
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hispi_serial_input_p
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hispi_serial_input_n
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/aclk
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/aclk_reset
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/aclk_idle_character
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/aclk_hispi_phy_en
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hispi_pix_clk
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/aclk_reset_phy
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/aclk_start_calibration
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/aclk_cal_done
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/aclk_cal_error
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/aclk_cal_tap_value
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/aclk_fifo_read_en
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/aclk_fifo_empty
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/aclk_fifo_read_data_valid
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/aclk_fifo_read_data
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/aclk_fifo_overrun
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/aclk_fifo_underrun
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/aclk_bit_locked
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/aclk_embeded_data
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/aclk_sof_flag
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/aclk_eof_flag
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/aclk_sol_flag
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/aclk_eol_flag
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_reset_vect
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_reset
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_state
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_start_calibration
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_serdes_data
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_lane_data
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_phy_areset
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/hclk_reset_counter
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/delay_reset
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/delay_tap_in
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/delay_tap_out
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/delay_data_ce
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/delay_data_inc
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/pclk_cal_en
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/pclk_cal_busy
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/pclk_cal_error
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/pclk_cal_load_tap
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/pclk_cal_tap_value
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/pix_clk
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/aclk_latch_cal_status
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/aclk_hispi_phy_en_ff
add wave -noupdate -expand -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/aclk_hispi_phy_en_rise
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {904230513 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 281
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
WaveRestoreZoom {904125421 ps} {904519516 ps}
