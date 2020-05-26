onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk_reset_n
add wave -noupdate -expand -group xgs_hispi_top -group {registerfile I/F} /testbench/DUT/x_xgs_hispi_top/rclk
add wave -noupdate -expand -group xgs_hispi_top -group {registerfile I/F} /testbench/DUT/x_xgs_hispi_top/rclk_reset_n
add wave -noupdate -expand -group xgs_hispi_top -group {registerfile I/F} /testbench/DUT/x_xgs_hispi_top/regfile
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/hispi_start_calibration
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/hispi_calibration_active
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/hispi_pix_clk
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/hispi_eof
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/idelay_clk
add wave -noupdate -expand -group xgs_hispi_top -expand -group {HiSPi I/O} /testbench/DUT/x_xgs_hispi_top/hispi_io_clk_p
add wave -noupdate -expand -group xgs_hispi_top -expand -group {HiSPi I/O} /testbench/DUT/x_xgs_hispi_top/hispi_io_clk_n
add wave -noupdate -expand -group xgs_hispi_top -expand -group {HiSPi I/O} /testbench/DUT/x_xgs_hispi_top/hispi_io_data_p
add wave -noupdate -expand -group xgs_hispi_top -expand -group {HiSPi I/O} /testbench/DUT/x_xgs_hispi_top/hispi_io_data_n
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk_tready
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk_tvalid
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk_tuser
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk_tlast
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk_tdata
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk_reset
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/new_line_pending
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/new_frame_pending
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk_reset_phy
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk_pll_locked_Meta
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk_pll_locked
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk_calibration_req
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk_calibration_pending
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk_start_calibration
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk_calibration_done
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk_cal_error
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk_xgs_ctrl_calib_req_Meta
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk_xgs_ctrl_calib_req
add wave -noupdate -expand -group xgs_hispi_top -expand -group {TOP } /testbench/DUT/x_xgs_hispi_top/top_cal_done
add wave -noupdate -expand -group xgs_hispi_top -expand -group {TOP } /testbench/DUT/x_xgs_hispi_top/top_lanes_p
add wave -noupdate -expand -group xgs_hispi_top -expand -group {TOP } /testbench/DUT/x_xgs_hispi_top/top_lanes_n
add wave -noupdate -expand -group xgs_hispi_top -expand -group {TOP } /testbench/DUT/x_xgs_hispi_top/top_sof_flag
add wave -noupdate -expand -group xgs_hispi_top -expand -group {TOP } /testbench/DUT/x_xgs_hispi_top/top_eof_flag
add wave -noupdate -expand -group xgs_hispi_top -expand -group {TOP } /testbench/DUT/x_xgs_hispi_top/top_sol_flag
add wave -noupdate -expand -group xgs_hispi_top -expand -group {TOP } /testbench/DUT/x_xgs_hispi_top/top_eol_flag
add wave -noupdate -expand -group xgs_hispi_top -expand -group {TOP } /testbench/DUT/x_xgs_hispi_top/top_fifo_read_en
add wave -noupdate -expand -group xgs_hispi_top -expand -group {TOP } /testbench/DUT/x_xgs_hispi_top/top_fifo_empty
add wave -noupdate -expand -group xgs_hispi_top -expand -group {TOP } /testbench/DUT/x_xgs_hispi_top/top_fifo_read_data_valid
add wave -noupdate -expand -group xgs_hispi_top -expand -group {TOP } /testbench/DUT/x_xgs_hispi_top/top_fifo_read_data
add wave -noupdate -expand -group xgs_hispi_top -expand -group Bottom /testbench/DUT/x_xgs_hispi_top/bottom_cal_done
add wave -noupdate -expand -group xgs_hispi_top -expand -group Bottom /testbench/DUT/x_xgs_hispi_top/bottom_lanes_p
add wave -noupdate -expand -group xgs_hispi_top -expand -group Bottom /testbench/DUT/x_xgs_hispi_top/bottom_lanes_n
add wave -noupdate -expand -group xgs_hispi_top -expand -group Bottom /testbench/DUT/x_xgs_hispi_top/bottom_sof_flag
add wave -noupdate -expand -group xgs_hispi_top -expand -group Bottom /testbench/DUT/x_xgs_hispi_top/bottom_eof_flag
add wave -noupdate -expand -group xgs_hispi_top -expand -group Bottom /testbench/DUT/x_xgs_hispi_top/bottom_sol_flag
add wave -noupdate -expand -group xgs_hispi_top -expand -group Bottom /testbench/DUT/x_xgs_hispi_top/bottom_eol_flag
add wave -noupdate -expand -group xgs_hispi_top -expand -group Bottom /testbench/DUT/x_xgs_hispi_top/bottom_fifo_read_en
add wave -noupdate -expand -group xgs_hispi_top -expand -group Bottom /testbench/DUT/x_xgs_hispi_top/bottom_fifo_empty
add wave -noupdate -expand -group xgs_hispi_top -expand -group Bottom /testbench/DUT/x_xgs_hispi_top/bottom_fifo_read_data_valid
add wave -noupdate -expand -group xgs_hispi_top -expand -group Bottom /testbench/DUT/x_xgs_hispi_top/bottom_fifo_read_data
add wave -noupdate -expand -group xgs_hispi_top -color Yellow /testbench/DUT/x_xgs_hispi_top/state
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/state_mapping
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/row_id
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/row_last
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/packer_busy
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/all_packer_idle
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/init_lane_packer
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/line_buffer_id
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/packer_fifo_overrun
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/packer_fifo_underrun
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/frame_cntr
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/line_cntr
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/line_valid
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/transfert_done
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/init_frame
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/lane_packer_ack
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/lane_packer_req
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/lane_packer_write
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/lane_packer_addr
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/lane_packer_data
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/packer_enable
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/nxtBuffer
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/clrBuffer
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/line_buffer_ready
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/buff_write
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/buff_addr
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/buff_data
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sync
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/hispi_eof_pulse
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/buffer_enable
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/y_row_start
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/y_row_stop
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/line_buffer_read
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/line_buffer_ptr
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/line_buffer_address
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/line_buffer_count
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/line_buffer_row_id
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/line_buffer_data
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/enable_hispi
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/aggregated_fifo_overrun
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/aggregated_fifo_underrun
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/aggregated_cal_error
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/aggregated_sync_error
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/aggregated_packer_fifo_overrun
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/aggregated_packer_fifo_underrun
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/fifo_error
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/aggregated_bit_lock_error
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/rclk_reset
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1209291556 ps} 0}
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
WaveRestoreZoom {993897967 ps} {1007384349 ps}
