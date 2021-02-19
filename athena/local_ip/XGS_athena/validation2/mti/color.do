onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/axi_reset_n
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/axi_clk
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/m_axis_tready
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/m_axis_tvalid
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/m_axis_tuser
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/m_axis_tlast
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/m_axis_tdata
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/bayer_is_line0
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/bayer_read_enable
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/bayer_r_ram_add
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/bayer_r_ram_dat
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/bayer_write_enable
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/bayer_w_ram_add
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_sol_p1
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_sol_p2
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_sol_p3
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_data_val_p1
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_data_val_p2
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_data_val_p3
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_data_p1
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_data_p2
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_eol_p1
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_eol_p2
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_eol_p3
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_eol_p4
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_eof_p1
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_eof_p2
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_eof_p3
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/is_line_impaire
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/BAYER_M0
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/BAYER_M1
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/C0_moyenneP
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/C0_moyenneI
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/C0_R_PIX_end_mosaic
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/C0_G_PIX_end_mosaic
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/C0_B_PIX_end_mosaic
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/C1_moyenneP
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/C1_moyenneI
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/C1_R_PIX_end_mosaic
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/C1_G_PIX_end_mosaic
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/C1_B_PIX_end_mosaic
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/BAYER_EXPANSION
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/s_axis_sol_P1
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/s_axis_eol_P1
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/s_axis_eol_P2
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/s_axis_eol_P3
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/s_axis_eof_P1
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/s_axis_eof_P2
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/s_axis_eof_P3
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/s_axis_eof_P4
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/s_axis_data_in_P1
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/s_axis_data_in_P2
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/s_axis_data_enable_stop
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/s_axis_data_enable_start
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/s_axis_data_enable_P1
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/s_axis_first_line
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/s_axis_first_prefetch
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/s_axis_frame_done
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/s_axis_line_gap
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/s_axis_line_wait
add wave -noupdate -divider DPC
add wave -noupdate -divider {COLOR AXIS_IN}
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/s_axis_first_prefetch
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/s_axis_tvalid
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/s_axis_tready
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/s_axis_tdata
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/s_axis_tdata8
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/s_axis_tuser
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/s_axis_tlast
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/s_axis_data_in_P1
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/s_axis_data_in_P2
add wave -noupdate -divider {COLOR AXIS_OUT}
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/m_axis_tvalid
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/m_axis_tready
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/m_axis_tuser
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/m_axis_tdata
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/m_axis_tlast
add wave -noupdate -divider {AXIS to Matrox}
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/axi_sof
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/axi_sol
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/axi_data_val
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/axi_data
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/axi_data8
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/axi_eol
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/axi_eof
add wave -noupdate -divider {WB output}
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/REG_WB_MULT_B
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/REG_WB_MULT_G
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/REG_WB_MULT_R
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/WB_is_line_impaire
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/C0_wb_factor
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/C1_wb_factor
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/wb_sof
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/wb_sol
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/wb_data_val
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/wb_data
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/wb_data8
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/wb_eol
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/wb_eof
add wave -noupdate -divider {Bayer INPUT}
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_sof
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_sol
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_data_val
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_data
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_eol
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_eof
add wave -noupdate -divider {New Divider}
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_overscan
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_data_val
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_data_val_p1
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/bayer_is_first_word
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_data_val_p2
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_data_val_p3
add wave -noupdate -color Gold /testbench/system_top/DUT/Xxgs_color_proc/bayer_write_enable
add wave -noupdate -color Gold /testbench/system_top/DUT/Xxgs_color_proc/bayer_w_ram_add
add wave -noupdate -color Gold /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_data_p2
add wave -noupdate -color {Medium Violet Red} /testbench/system_top/DUT/Xxgs_color_proc/bayer_read_enable
add wave -noupdate -color {Medium Violet Red} /testbench/system_top/DUT/Xxgs_color_proc/bayer_r_ram_add
add wave -noupdate -color {Medium Violet Red} /testbench/system_top/DUT/Xxgs_color_proc/bayer_r_ram_dat
add wave -noupdate -color Red /testbench/system_top/DUT/Xxgs_color_proc/BAYER_M0
add wave -noupdate -color Red /testbench/system_top/DUT/Xxgs_color_proc/BAYER_M1
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/C0_B_PIX_end_mosaic
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/C0_G_PIX_end_mosaic
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/C0_R_PIX_end_mosaic
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/C1_B_PIX_end_mosaic
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/C1_G_PIX_end_mosaic
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/C1_R_PIX_end_mosaic
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_eol_p1
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_eol_p2
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_eol_p3
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_eol_p4
add wave -noupdate -divider {Bayer OUTPUTS}
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/bayer_sof
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/bayer_sol
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/bayer_data_val
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/bayer_data
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/bayer_eol
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/bayer_eof
add wave -noupdate -divider LUT
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/lut_sof
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/lut_sol
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/lut_data_val
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/lut_data
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/lut_eol
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/lut_eof
add wave -noupdate -divider {AXI MASTER}
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/m_axis_first_line
add wave -noupdate -group DPCorr /testbench/system_top/DUT/Xxgs_color_proc/m_axis_last_line
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/m_axis_tdata_int
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/m_axis_tuser_int
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/m_axis_tvalid_int
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/m_axis_wait
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/m_axis_wait_data
add wave -noupdate -divider {New Divider}
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/m_axis_tvalid
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/m_axis_tready
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/m_axis_tuser
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/m_axis_tdata
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/m_axis_tlast
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1517392381 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 204
configure wave -valuecolwidth 138
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
WaveRestoreZoom {0 ps} {1593488400 ps}
