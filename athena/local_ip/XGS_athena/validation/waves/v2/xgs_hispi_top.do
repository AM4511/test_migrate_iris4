onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group xgs_hispi_top -group {HiSPi I/O} /testbench/DUT/x_xgs_hispi_top/hispi_io_clk_p
add wave -noupdate -expand -group xgs_hispi_top -group {HiSPi I/O} /testbench/DUT/x_xgs_hispi_top/hispi_io_clk_n
add wave -noupdate -expand -group xgs_hispi_top -group {HiSPi I/O} /testbench/DUT/x_xgs_hispi_top/hispi_io_data_p
add wave -noupdate -expand -group xgs_hispi_top -group {HiSPi I/O} /testbench/DUT/x_xgs_hispi_top/hispi_io_data_n
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk_reset_n
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/rclk
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/rclk_reset_n
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/regfile
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/rclk_irq_error
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/hispi_start_calibration
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/hispi_calibration_active
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/hispi_pix_clk
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/hispi_eof
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/hispi_ystart
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/hispi_ysize
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/idelay_clk
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/rclk_reset
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/rclk_irq_error_vect
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk_reset
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk_reset_phy
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk_pll_locked_Meta
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk_pll_locked
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk_calibration_req
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk_calibration_pending
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk_start_calibration
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk_calibration_done
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk_xgs_ctrl_calib_req_Meta
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk_xgs_ctrl_calib_req
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/top_lanes_p
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/top_lanes_n
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/bottom_lanes_p
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/bottom_lanes_n
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/frame_overrun_error
add wave -noupdate -expand -group xgs_hispi_top -color Cyan /testbench/DUT/x_xgs_hispi_top/state
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/state_mapping
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk_buffer_empty_top
add wave -noupdate -expand -group xgs_hispi_top -color {Blue Violet} /testbench/DUT/x_xgs_hispi_top/sclk_sof_pending
add wave -noupdate -expand -group xgs_hispi_top -expand -subitemconfig {/testbench/DUT/x_xgs_hispi_top/sclk_sof_top(0) {-color Magenta -height 15}} /testbench/DUT/x_xgs_hispi_top/sclk_sof_top
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk_buffer_data_top
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk_buffer_empty_bottom
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk_buffer_data_bottom
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk_buffer_read_en
add wave -noupdate -expand -group xgs_hispi_top -expand -group {Line buffer address} -color Gold /testbench/DUT/x_xgs_hispi_top/sclk_buffer_lane_id
add wave -noupdate -expand -group xgs_hispi_top -expand -group {Line buffer address} -color Gold /testbench/DUT/x_xgs_hispi_top/sclk_buffer_mux_id
add wave -noupdate -expand -group xgs_hispi_top -expand -group {Line buffer address} -color Gold /testbench/DUT/x_xgs_hispi_top/sclk_buffer_word_ptr
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk_transfer_done
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/nb_lane_enabled
add wave -noupdate -expand -group xgs_hispi_top -color Khaki /testbench/DUT/x_xgs_hispi_top/init_frame
add wave -noupdate -expand -group xgs_hispi_top -color Khaki /testbench/DUT/x_xgs_hispi_top/frame_done
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/enable_hispi
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/aggregated_fifo_overrun
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/aggregated_fifo_underrun
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/aggregated_cal_error
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/aggregated_sync_error
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/aggregated_crc_error
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/fifo_error
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/crc_error
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/aggregated_bit_lock_error
add wave -noupdate -expand -group xgs_hispi_top -expand -group {AXI stream out} /testbench/DUT/x_xgs_hispi_top/sclk_tready
add wave -noupdate -expand -group xgs_hispi_top -expand -group {AXI stream out} /testbench/DUT/x_xgs_hispi_top/sclk_tvalid
add wave -noupdate -expand -group xgs_hispi_top -expand -group {AXI stream out} /testbench/DUT/x_xgs_hispi_top/sclk_tuser
add wave -noupdate -expand -group xgs_hispi_top -expand -group {AXI stream out} /testbench/DUT/x_xgs_hispi_top/sclk_tlast
add wave -noupdate -expand -group xgs_hispi_top -expand -group {AXI stream out} /testbench/DUT/x_xgs_hispi_top/sclk_tdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2266927355 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 303
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
configure wave -timelineunits ns
update
WaveRestoreZoom {2258268444 ps} {2273067254 ps}
