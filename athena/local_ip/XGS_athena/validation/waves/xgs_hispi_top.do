onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/axi_clk
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/axi_reset_n
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/regfile
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/idelay_clk
add wave -noupdate -expand -group xgs_hispi_top -expand -group {HiSPi I/F} /testbench/DUT/x_xgs_hispi_top/hispi_io_clk_p
add wave -noupdate -expand -group xgs_hispi_top -expand -group {HiSPi I/F} /testbench/DUT/x_xgs_hispi_top/hispi_io_clk_n
add wave -noupdate -expand -group xgs_hispi_top -expand -group {HiSPi I/F} /testbench/DUT/x_xgs_hispi_top/hispi_io_data_p
add wave -noupdate -expand -group xgs_hispi_top -expand -group {HiSPi I/F} /testbench/DUT/x_xgs_hispi_top/hispi_io_data_n
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/axi_reset
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/idle_character
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/new_line_pending
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/new_frame_pending
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk_cal_en
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/sclk_cal_error
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/cal_done
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/calibrate_en
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/top_cal_busy
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/top_cal_done
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/top_cal_error
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/top_cal_tap_value
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/top_lanes_p
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/top_lanes_n
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/top_embeded_data
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/top_sof_flag
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/top_eof_flag
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/top_sol_flag
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/top_eol_flag
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/top_fifo_read_en
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/top_fifo_empty
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/top_fifo_read_data_valid
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/top_fifo_read_data
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/bottom_cal_busy
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/bottom_cal_done
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/bottom_cal_error
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/bottom_cal_tap_value
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/bottom_lanes_p
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/bottom_lanes_n
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/bottom_embeded_data
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/bottom_sof_flag
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/bottom_eof_flag
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/bottom_sol_flag
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/bottom_eol_flag
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/bottom_fifo_read_en
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/bottom_fifo_empty
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/bottom_fifo_read_data_valid
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/bottom_fifo_read_data
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/state
add wave -noupdate -expand -group xgs_hispi_top -color {Medium Violet Red} /testbench/DUT/x_xgs_hispi_top/init_frame
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/row_id
add wave -noupdate -expand -group xgs_hispi_top -expand /testbench/DUT/x_xgs_hispi_top/packer_busy
add wave -noupdate -expand -group xgs_hispi_top -color {Cornflower Blue} /testbench/DUT/x_xgs_hispi_top/all_packer_idle
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/init_lane_packer
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/line_buffer_id
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/packer_fifo_overrun
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/packer_fifo_underrun
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/frame_cntr
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/line_cntr
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/line_valid
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/transfert_done
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
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/strm_packer_sel
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/strm_buffer_sel
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/strm_sbuff_clr
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/strm_sbuff_rden
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/strm_sbuff_data_valid
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/strm_sbuff_rddata
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/strm_sbuff_count
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/buffer_enable
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/number_of_row
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/line_buffer_read
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/line_buffer_ptr
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/line_buffer_address
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/line_buffer_count
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/line_buffer_line_id
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/line_buffer_data
add wave -noupdate -expand -group xgs_hispi_top /testbench/DUT/x_xgs_hispi_top/capture_enable
add wave -noupdate -expand -group xgs_hispi_top -group {Axi Stream out} /testbench/DUT/x_xgs_hispi_top/m_axis_tready
add wave -noupdate -expand -group xgs_hispi_top -group {Axi Stream out} /testbench/DUT/x_xgs_hispi_top/m_axis_tvalid
add wave -noupdate -expand -group xgs_hispi_top -group {Axi Stream out} /testbench/DUT/x_xgs_hispi_top/m_axis_tuser
add wave -noupdate -expand -group xgs_hispi_top -group {Axi Stream out} /testbench/DUT/x_xgs_hispi_top/m_axis_tlast
add wave -noupdate -expand -group xgs_hispi_top -group {Axi Stream out} /testbench/DUT/x_xgs_hispi_top/m_axis_tdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 3} {319908443 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 234
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
WaveRestoreZoom {0 ps} {693448595 ps}
