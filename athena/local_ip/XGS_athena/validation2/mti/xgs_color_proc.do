onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/axi_clk
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/axi_reset_n
add wave -noupdate -expand -group xgs_color_proc -expand -group {Axi Stream Input} -color Gold /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/s_axis_tvalid
add wave -noupdate -expand -group xgs_color_proc -expand -group {Axi Stream Input} -color Gold /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/s_axis_tready
add wave -noupdate -expand -group xgs_color_proc -expand -group {Axi Stream Input} -color Gold /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/s_axis_tuser
add wave -noupdate -expand -group xgs_color_proc -expand -group {Axi Stream Input} -color Gold /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/s_axis_tlast
add wave -noupdate -expand -group xgs_color_proc -expand -group {Axi Stream Input} -color Gold /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/s_axis_tdata
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/m_axis_tready
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/m_axis_tvalid
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/m_axis_tuser
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/m_axis_tlast
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/m_axis_tdata
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/curr_Xstart
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/curr_Xend
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/curr_Ystart
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/curr_Yend
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/curr_Ysub
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/load_dma_context_EOFOT
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/REG_dpc_list_length
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/REG_dpc_ver
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/REG_dpc_enable
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/REG_dpc_pattern0_cfg
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/REG_dpc_list_wrn
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/REG_dpc_list_add
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/REG_dpc_list_ss
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/REG_dpc_list_count
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/REG_dpc_list_corr_pattern
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/REG_dpc_list_corr_y
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/REG_dpc_list_corr_x
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/REG_dpc_list_corr_rd
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/REG_wb_b_acc
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/REG_wb_g_acc
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/REG_wb_r_acc
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/REG_WB_MULT_R
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/REG_WB_MULT_G
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/REG_WB_MULT_B
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/REG_BAYER_EN
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/REG_LUT_BYPASS
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/REG_LUT_SEL
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/REG_LUT_SS
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/REG_LUT_WRN
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/REG_LUT_ADD
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/REG_LUT_DATA_W
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/s_axis_tready_int
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/s_axis_first_line
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/s_axis_first_prefetch
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/s_axis_line_gap
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/s_axis_line_wait
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/s_axis_frame_done
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/m_axis_first_line
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/m_axis_last_line
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/m_axis_tvalid_int
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/m_axis_tdata_int
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/m_axis_tuser_int
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/m_axis_wait_data
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/m_axis_wait
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/s_axis_sol_P1
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/s_axis_data_enable_P1
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/s_axis_data_enable_P2
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/s_axis_eol_P1
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/s_axis_eol_P2
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/s_axis_eol_P3
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/s_axis_eof_P1
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/s_axis_eof_P2
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/s_axis_eof_P3
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/s_axis_eof_P4
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/s_axis_data_in_P1
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/s_axis_data_in_P2
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/axi_sof
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/axi_sol
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/axi_data_val
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/axi_data
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/axi_eol
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/axi_eof
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/dpc_sof
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/dpc_sol
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/dpc_data_val
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/dpc_data
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/dpc_eol
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/dpc_eof
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/WBIn_sof
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/WBIn_sol
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/WBIn_data_val
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/WBIn_data
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/WBIn_eol
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/WBIn_eof
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/WBIn_sof_p1
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/WBIn_sol_p1
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/WBIn_data_val_p1
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/WBIn_data_p1
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/WBIn_eol_p1
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/WBIn_eof_p1
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/WBIn_sof_p2
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/WBIn_sol_p2
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/WBIn_data_val_p2
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/WBIn_eol_p2
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/WBIn_eof_p2
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/WB_is_line_impaire
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/C0_wb_factor
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/C0_wb_mult_res
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/C0_wb_data
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/C1_wb_factor
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/C1_wb_mult_res
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/C1_wb_data
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/wb_b_acc
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/wb_g_acc
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/wb_r_acc
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/wb_sof
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/wb_sol
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/wb_data_val
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/wb_data
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/wb_eol
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/wb_eof
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/BayerIn_overscan
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/BayerIn_sof
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/BayerIn_sol
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/BayerIn_data_val
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/BayerIn_data
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/BayerIn_eol
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/BayerIn_eof
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/bayer_is_line0
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/bayer_read_enable
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/bayer_r_ram_add
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/bayer_r_ram_dat
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/bayer_write_enable
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/bayer_w_ram_add
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/BayerIn_sol_p1
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/BayerIn_sol_p2
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/BayerIn_sol_p3
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/BayerIn_data_val_p1
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/BayerIn_data_val_p2
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/BayerIn_data_p1
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/BayerIn_data_p2
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/BayerIn_eol_p1
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/BayerIn_eol_p2
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/BayerIn_eol_p3
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/BayerIn_eol_p4
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/BayerIn_eof_p1
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/BayerIn_eof_p2
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/BayerIn_eof_p3
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/is_line_impaire
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/bayer_is_first_word
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/BAYER_M0
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/BAYER_M1
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/C0_moyenneP
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/C0_moyenneI
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/C0_R_PIX_end_mosaic
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/C0_G_PIX_end_mosaic
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/C0_B_PIX_end_mosaic
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/C1_moyenneP
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/C1_moyenneI
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/C1_R_PIX_end_mosaic
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/C1_G_PIX_end_mosaic
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/C1_B_PIX_end_mosaic
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/bayer_sof
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/bayer_sol
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/bayer_data_val
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/bayer_data
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/bayer_eol
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/bayer_eof
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/bayer_data_P1
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/LUT_RAM_W_enable
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/RAM_R_enable_ored
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/lut_sof
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/lut_sol
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/lut_data_val
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/lut_data
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/lut_eol
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/lut_eof
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/lut_eol_comb
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/raw_data
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/s_axis_tdata8
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/axi_data8
add wave -noupdate -expand -group xgs_color_proc /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/wb_data8
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {1520650989 ps}
