onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/sysclk
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/sysrst
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/idle_character
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/hispi_phy_en
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/hispi_soft_reset
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/cal_en
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/cal_busy
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/cal_error
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/cal_load_tap
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/cal_tap_value
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/hispi_serial_clk_p
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/hispi_serial_clk_n
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/hispi_serial_input_p
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/hispi_serial_input_n
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/fifo_read_clk
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/fifo_read_en
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/fifo_empty
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/fifo_read_data_valid
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/fifo_read_data
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/embeded_data
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/sof_flag
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/eof_flag
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/sol_flag
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/eol_flag
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/hispi_reset
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/hispi_reset_Meta
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/hispi_clk
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/hispi_serdes_data
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/hispi_data
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/hispi_lane_data
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/hispi_phy_areset
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/hispi_reset_counter
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/hispi_fifo_full
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/hispi_fifo_wen
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/hispi_fifo_aggregated_write_data
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/hispi_data_valid
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/buffer_address
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/hispi_decoded_sync
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/delay_reset
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/delay_data_ce
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/delay_data_inc
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/delay_tap_in
add wave -noupdate -group top_hispi_phy /testbench/DUT/x_xgs_hispi_top/top_hispi_phy/delay_tap_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2617578415 ps} 0} {{Cursor 2} {348392041 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 150
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
WaveRestoreZoom {273553920 ps} {607478361 ps}
