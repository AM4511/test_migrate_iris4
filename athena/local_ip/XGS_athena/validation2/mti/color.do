onerror {resume}
quietly virtual signal -install /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color { /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/RAM_R_data(12 downto 0)} X_POS
quietly virtual signal -install /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color { /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/RAM_R_data(24 downto 13)} Y_POS
quietly virtual signal -install /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color { /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/RAM_R_data(32 downto 25)} Pattern
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/system_top/XGS_MODEL_5000/xgs_image_inst/dataline
add wave -noupdate /testbench/system_top/XGS_MODEL_5000/xgs_image_inst/frame
add wave -noupdate -group {XGS SENSOR} /testbench/system_top/DUT/xgs_trig_int
add wave -noupdate -group {XGS SENSOR} /testbench/system_top/DUT/xgs_monitor0
add wave -noupdate -group {XGS SENSOR} /testbench/system_top/DUT/xgs_monitor1
add wave -noupdate -group {XGS SENSOR} /testbench/system_top/DUT/xgs_monitor2
add wave -noupdate -group {XGS SENSOR} -group DPC_READED_PIX /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/RAM_R_enable
add wave -noupdate -group {XGS SENSOR} -group DPC_READED_PIX /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/RAM_R_address
add wave -noupdate -group {XGS SENSOR} -group DPC_READED_PIX /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/X_POS
add wave -noupdate -group {XGS SENSOR} -group DPC_READED_PIX /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/Y_POS
add wave -noupdate -group {XGS SENSOR} -group DPC_READED_PIX /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/Pattern
add wave -noupdate -group {XGS SENSOR} -group DPC_READED_PIX /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/RAM_R_end
add wave -noupdate -group {XGS SENSOR} -group DPC_READED_PIX /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/RAM_R_enable
add wave -noupdate -group {XGS SENSOR} -group DPC_READED_PIX /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/RAM_R_address
add wave -noupdate -group {XGS SENSOR} -group DPC_READED_PIX /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/X_POS
add wave -noupdate -group {XGS SENSOR} -group DPC_READED_PIX /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/Y_POS
add wave -noupdate -group {XGS SENSOR} -group DPC_READED_PIX /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/Pattern
add wave -noupdate -group {XGS SENSOR} -group DPC_READED_PIX /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/RAM_R_end
add wave -noupdate -group {XGS SENSOR} -expand -subitemconfig {/testbench/system_top/DUT/regfile.BAYER.BAYER_CFG -expand /testbench/system_top/DUT/regfile.BAYER.WB_MUL1 -expand /testbench/system_top/DUT/regfile.BAYER.WB_MUL2 -expand} /testbench/system_top/DUT/regfile.BAYER
add wave -noupdate -group {XGS SENSOR} -divider {AXI 2 MATROX}
add wave -noupdate -group {XGS SENSOR} /testbench/system_top/DUT/xgs_trig_int
add wave -noupdate -group {XGS SENSOR} /testbench/system_top/DUT/xgs_monitor0
add wave -noupdate -group {XGS SENSOR} /testbench/system_top/DUT/xgs_monitor1
add wave -noupdate -group {XGS SENSOR} /testbench/system_top/DUT/xgs_monitor2
add wave -noupdate -group {XGS SENSOR} -expand -subitemconfig {/testbench/system_top/DUT/regfile.BAYER.BAYER_CFG -expand /testbench/system_top/DUT/regfile.BAYER.WB_MUL1 -expand /testbench/system_top/DUT/regfile.BAYER.WB_MUL2 -expand} /testbench/system_top/DUT/regfile.BAYER
add wave -noupdate -group {XGS SENSOR} -divider {AXI 2 MATROX}
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/REG_BAYER_EN
add wave -noupdate -expand -group AXI_AMARCHAND /testbench/system_top/DUT/Xxgs_color_proc/s_axis_tvalid
add wave -noupdate -expand -group AXI_AMARCHAND /testbench/system_top/DUT/Xxgs_color_proc/s_axis_tready
add wave -noupdate -expand -group AXI_AMARCHAND /testbench/system_top/DUT/Xxgs_color_proc/s_axis_tdata
add wave -noupdate -expand -group AXI_AMARCHAND /testbench/system_top/DUT/Xxgs_color_proc/s_axis_tdata8
add wave -noupdate -expand -group AXI_AMARCHAND /testbench/system_top/DUT/Xxgs_color_proc/s_axis_tlast
add wave -noupdate -expand -group AXI_AMARCHAND /testbench/system_top/DUT/Xxgs_color_proc/s_axis_tuser
add wave -noupdate -expand -group AXI_AMARCHAND /testbench/system_top/DUT/Xxgs_color_proc/s_axis_tvalid
add wave -noupdate -expand -group AXI_AMARCHAND /testbench/system_top/DUT/Xxgs_color_proc/s_axis_tready
add wave -noupdate -expand -group AXI_AMARCHAND /testbench/system_top/DUT/Xxgs_color_proc/s_axis_tdata
add wave -noupdate -expand -group AXI_AMARCHAND /testbench/system_top/DUT/Xxgs_color_proc/s_axis_tdata8
add wave -noupdate -expand -group AXI_AMARCHAND /testbench/system_top/DUT/Xxgs_color_proc/s_axis_tlast
add wave -noupdate -expand -group AXI_AMARCHAND /testbench/system_top/DUT/Xxgs_color_proc/s_axis_tuser
add wave -noupdate -group AXIS_TO_MATROX /testbench/system_top/DUT/Xxgs_color_proc/axi_sof
add wave -noupdate -group AXIS_TO_MATROX /testbench/system_top/DUT/Xxgs_color_proc/axi_sol
add wave -noupdate -group AXIS_TO_MATROX /testbench/system_top/DUT/Xxgs_color_proc/axi_data_val
add wave -noupdate -group AXIS_TO_MATROX /testbench/system_top/DUT/Xxgs_color_proc/axi_data
add wave -noupdate -group AXIS_TO_MATROX /testbench/system_top/DUT/Xxgs_color_proc/axi_data8
add wave -noupdate -group AXIS_TO_MATROX /testbench/system_top/DUT/Xxgs_color_proc/axi_eol
add wave -noupdate -group AXIS_TO_MATROX /testbench/system_top/DUT/Xxgs_color_proc/axi_eof
add wave -noupdate -group AXIS_TO_MATROX /testbench/system_top/DUT/Xxgs_color_proc/axi_sof
add wave -noupdate -group AXIS_TO_MATROX /testbench/system_top/DUT/Xxgs_color_proc/axi_sol
add wave -noupdate -group AXIS_TO_MATROX /testbench/system_top/DUT/Xxgs_color_proc/axi_data_val
add wave -noupdate -group AXIS_TO_MATROX /testbench/system_top/DUT/Xxgs_color_proc/axi_data
add wave -noupdate -group AXIS_TO_MATROX /testbench/system_top/DUT/Xxgs_color_proc/axi_data8
add wave -noupdate -group AXIS_TO_MATROX /testbench/system_top/DUT/Xxgs_color_proc/axi_eol
add wave -noupdate -group AXIS_TO_MATROX /testbench/system_top/DUT/Xxgs_color_proc/axi_eof
add wave -noupdate -divider DPC
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/pix_clk
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/pix_reset_n
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/proc_eol
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/REG_dpc_pattern0_cfg
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/dpc_fifo_reset
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/dpc_fifo_reset_done
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/dpc_fifo_data_in
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/dpc_fifo_write_in
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/dpc_fifo_list_rdy
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/proc_enable
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/in_0
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/in_1
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/in_2
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/in_3
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/in_4
add wave -noupdate -group DPC -group DPC_CORE0 -color Gold /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/in_0_P1
add wave -noupdate -group DPC -group DPC_CORE0 -color Gold /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/in_1_P1
add wave -noupdate -group DPC -group DPC_CORE0 -color Gold /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/in_2_P1
add wave -noupdate -group DPC -group DPC_CORE0 -color Gold /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/in_3_P1
add wave -noupdate -group DPC -group DPC_CORE0 -color Gold /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/in_4_P1
add wave -noupdate -group DPC -group DPC_CORE0 -color Gold /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/Correct_this_P1
add wave -noupdate -group DPC -group DPC_CORE0 -color Gold /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/Correct_pattern_P1
add wave -noupdate -group DPC -group DPC_CORE0 -color {Medium Violet Red} /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/Curr_out
add wave -noupdate -group DPC -group DPC_CORE0 -color {Violet Red} /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/dpc_data_val
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/deadpix_exist
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/proc_X_pix_curr
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/proc_Y_pix_curr
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/proc_nxt_X_pix_corr
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/proc_nxt_Y_pix_corr
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/Correct_mode_P1
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/proc_enable_P1
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/dpc_fifo_srst
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/proc_nxt_pattern_corr
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/dpc_fifo_rd_en
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/dpc_fifo_dout
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/dpc_fifo_full
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/dpc_fifo_empty
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/dpc_rst_busy
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/dpc_rst_busy_P1
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/sum_comb
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/pix_clk
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/pix_reset_n
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/proc_eol
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/REG_dpc_pattern0_cfg
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/dpc_fifo_reset
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/dpc_fifo_reset_done
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/dpc_fifo_data_in
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/dpc_fifo_write_in
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/dpc_fifo_list_rdy
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/proc_enable
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/in_0
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/in_1
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/in_2
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/in_3
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/in_4
add wave -noupdate -group DPC -group DPC_CORE0 -color Gold /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/in_0_P1
add wave -noupdate -group DPC -group DPC_CORE0 -color Gold /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/in_1_P1
add wave -noupdate -group DPC -group DPC_CORE0 -color Gold /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/in_2_P1
add wave -noupdate -group DPC -group DPC_CORE0 -color Gold /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/in_3_P1
add wave -noupdate -group DPC -group DPC_CORE0 -color Gold /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/in_4_P1
add wave -noupdate -group DPC -group DPC_CORE0 -color Gold /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/Correct_this_P1
add wave -noupdate -group DPC -group DPC_CORE0 -color Gold /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/Correct_pattern_P1
add wave -noupdate -group DPC -group DPC_CORE0 -color {Medium Violet Red} /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/Curr_out
add wave -noupdate -group DPC -group DPC_CORE0 -color {Violet Red} /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/dpc_data_val
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/deadpix_exist
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/proc_X_pix_curr
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/proc_Y_pix_curr
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/proc_nxt_X_pix_corr
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/proc_nxt_Y_pix_corr
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/Correct_mode_P1
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/proc_enable_P1
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/dpc_fifo_srst
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/proc_nxt_pattern_corr
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/dpc_fifo_rd_en
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/dpc_fifo_dout
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/dpc_fifo_full
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/dpc_fifo_empty
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/dpc_rst_busy
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/dpc_rst_busy_P1
add wave -noupdate -group DPC -group DPC_CORE0 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(0)/Xdpc_kernel_proc_color/sum_comb
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/pix_clk
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/pix_reset_n
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/proc_enable
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/proc_eol
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/REG_dpc_pattern0_cfg
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/dpc_fifo_reset
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/dpc_fifo_reset_done
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/dpc_fifo_data_in
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/dpc_fifo_write_in
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/dpc_fifo_list_rdy
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/proc_enable
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/in_0
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/in_1
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/in_2
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/in_3
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/in_4
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/proc_X_pix_curr
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/proc_Y_pix_curr
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/proc_nxt_X_pix_corr
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/proc_nxt_Y_pix_corr
add wave -noupdate -group DPC -group DPC_CORE1 -color Gold /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/in_0_P1
add wave -noupdate -group DPC -group DPC_CORE1 -color Gold /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/in_1_P1
add wave -noupdate -group DPC -group DPC_CORE1 -color Gold /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/in_2_P1
add wave -noupdate -group DPC -group DPC_CORE1 -color Gold /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/in_3_P1
add wave -noupdate -group DPC -group DPC_CORE1 -color Gold /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/in_4_P1
add wave -noupdate -group DPC -group DPC_CORE1 -color Gold /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/Correct_this_P1
add wave -noupdate -group DPC -group DPC_CORE1 -color Gold /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/Correct_pattern_P1
add wave -noupdate -group DPC -group DPC_CORE1 -color {Violet Red} /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/Curr_out
add wave -noupdate -group DPC -group DPC_CORE1 -color {Violet Red} /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/dpc_data_val
add wave -noupdate -group DPC -group DPC_CORE1 -color {Violet Red} /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/dpc_fifo_srst
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/proc_nxt_pattern_corr
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/dpc_fifo_rd_en
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/dpc_fifo_dout
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/dpc_fifo_full
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/dpc_fifo_empty
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/dpc_rst_busy
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/dpc_rst_busy_P1
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/deadpix_exist
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/Correct_mode_P1
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/proc_enable_P1
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/sum_comb
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/pix_clk
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/pix_reset_n
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/proc_enable
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/proc_eol
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/REG_dpc_pattern0_cfg
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/dpc_fifo_reset
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/dpc_fifo_reset_done
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/dpc_fifo_data_in
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/dpc_fifo_write_in
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/dpc_fifo_list_rdy
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/proc_enable
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/in_0
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/in_1
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/in_2
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/in_3
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/in_4
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/proc_X_pix_curr
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/proc_Y_pix_curr
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/proc_nxt_X_pix_corr
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/proc_nxt_Y_pix_corr
add wave -noupdate -group DPC -group DPC_CORE1 -color Gold /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/in_0_P1
add wave -noupdate -group DPC -group DPC_CORE1 -color Gold /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/in_1_P1
add wave -noupdate -group DPC -group DPC_CORE1 -color Gold /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/in_2_P1
add wave -noupdate -group DPC -group DPC_CORE1 -color Gold /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/in_3_P1
add wave -noupdate -group DPC -group DPC_CORE1 -color Gold /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/in_4_P1
add wave -noupdate -group DPC -group DPC_CORE1 -color Gold /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/Correct_this_P1
add wave -noupdate -group DPC -group DPC_CORE1 -color Gold /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/Correct_pattern_P1
add wave -noupdate -group DPC -group DPC_CORE1 -color {Violet Red} /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/Curr_out
add wave -noupdate -group DPC -group DPC_CORE1 -color {Violet Red} /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/dpc_data_val
add wave -noupdate -group DPC -group DPC_CORE1 -color {Violet Red} /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/dpc_fifo_srst
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/proc_nxt_pattern_corr
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/dpc_fifo_rd_en
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/dpc_fifo_dout
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/dpc_fifo_full
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/dpc_fifo_empty
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/dpc_rst_busy
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/dpc_rst_busy_P1
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/deadpix_exist
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/Correct_mode_P1
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/proc_enable_P1
add wave -noupdate -group DPC -group DPC_CORE1 /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/GEN_2_CORE(1)/Xdpc_kernel_proc_color/sum_comb
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/axi_clk
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/axi_sof
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/axi_sol
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/axi_data_val
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/axi_data
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/axi_data16
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/axi_eol
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/axi_eof
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/kernel_sof
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/kernel_sol
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/kernel_pipeline_loaded
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/kernel_data_val
add wave -noupdate -group DPC -expand /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/kernel_5x1_curr
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/kernel_data
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/kernel_data_6x1_8bpp
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/kernel_eol
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/kernel_eof
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/dpc_sof
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/dpc_sol
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/dpc_data_val
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/dpc_data
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/dpc_data16
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/dpc_eol
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/dpc_eof
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/axi_clk
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/axi_sof
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/axi_sol
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/axi_data_val
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/axi_data
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/axi_data16
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/axi_eol
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/axi_eof
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/kernel_sof
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/kernel_sol
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/kernel_pipeline_loaded
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/kernel_data_val
add wave -noupdate -group DPC -expand /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/kernel_5x1_curr
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/kernel_data
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/kernel_data_6x1_8bpp
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/kernel_eol
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/kernel_eof
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/dpc_sof
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/dpc_sol
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/dpc_data_val
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/dpc_data
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/dpc_data16
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/dpc_eol
add wave -noupdate -group DPC /testbench/system_top/DUT/Xxgs_color_proc/Xdpc_filter_color/dpc_eof
add wave -noupdate -divider WB
add wave -noupdate -group WB /testbench/system_top/DUT/Xxgs_color_proc/WBIn_eof
add wave -noupdate -group WB /testbench/system_top/DUT/Xxgs_color_proc/WB_is_line_impaire
add wave -noupdate -group WB /testbench/system_top/DUT/Xxgs_color_proc/wb_b_acc
add wave -noupdate -group WB /testbench/system_top/DUT/Xxgs_color_proc/wb_g_acc
add wave -noupdate -group WB /testbench/system_top/DUT/Xxgs_color_proc/wb_r_acc
add wave -noupdate -group WB /testbench/system_top/DUT/Xxgs_color_proc/REG_WB_MULT_B
add wave -noupdate -group WB /testbench/system_top/DUT/Xxgs_color_proc/REG_WB_MULT_G
add wave -noupdate -group WB /testbench/system_top/DUT/Xxgs_color_proc/REG_WB_MULT_R
add wave -noupdate -group WB /testbench/system_top/DUT/Xxgs_color_proc/WB_is_line_impaire
add wave -noupdate -group WB /testbench/system_top/DUT/Xxgs_color_proc/C0_wb_factor
add wave -noupdate -group WB /testbench/system_top/DUT/Xxgs_color_proc/C1_wb_factor
add wave -noupdate -group WB /testbench/system_top/DUT/Xxgs_color_proc/wb_sof
add wave -noupdate -group WB /testbench/system_top/DUT/Xxgs_color_proc/wb_sol
add wave -noupdate -group WB /testbench/system_top/DUT/Xxgs_color_proc/wb_data_val
add wave -noupdate -group WB /testbench/system_top/DUT/Xxgs_color_proc/wb_data
add wave -noupdate -group WB /testbench/system_top/DUT/Xxgs_color_proc/wb_data8
add wave -noupdate -group WB /testbench/system_top/DUT/Xxgs_color_proc/wb_eol
add wave -noupdate -group WB /testbench/system_top/DUT/Xxgs_color_proc/wb_eof
add wave -noupdate -group WB /testbench/system_top/DUT/Xxgs_color_proc/WBIn_eof
add wave -noupdate -group WB /testbench/system_top/DUT/Xxgs_color_proc/WB_is_line_impaire
add wave -noupdate -group WB /testbench/system_top/DUT/Xxgs_color_proc/wb_b_acc
add wave -noupdate -group WB /testbench/system_top/DUT/Xxgs_color_proc/wb_g_acc
add wave -noupdate -group WB /testbench/system_top/DUT/Xxgs_color_proc/wb_r_acc
add wave -noupdate -group WB /testbench/system_top/DUT/Xxgs_color_proc/REG_WB_MULT_B
add wave -noupdate -group WB /testbench/system_top/DUT/Xxgs_color_proc/REG_WB_MULT_G
add wave -noupdate -group WB /testbench/system_top/DUT/Xxgs_color_proc/REG_WB_MULT_R
add wave -noupdate -group WB /testbench/system_top/DUT/Xxgs_color_proc/WB_is_line_impaire
add wave -noupdate -group WB /testbench/system_top/DUT/Xxgs_color_proc/C0_wb_factor
add wave -noupdate -group WB /testbench/system_top/DUT/Xxgs_color_proc/C1_wb_factor
add wave -noupdate -group WB /testbench/system_top/DUT/Xxgs_color_proc/wb_sof
add wave -noupdate -group WB /testbench/system_top/DUT/Xxgs_color_proc/wb_sol
add wave -noupdate -group WB /testbench/system_top/DUT/Xxgs_color_proc/wb_data_val
add wave -noupdate -group WB /testbench/system_top/DUT/Xxgs_color_proc/wb_data
add wave -noupdate -group WB /testbench/system_top/DUT/Xxgs_color_proc/wb_data8
add wave -noupdate -group WB /testbench/system_top/DUT/Xxgs_color_proc/wb_eol
add wave -noupdate -group WB /testbench/system_top/DUT/Xxgs_color_proc/wb_eof
add wave -noupdate -divider BAYER
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_sof
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_sol
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_data_val
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_data
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_eol
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_eof
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_overscan
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_data_val
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_data_val_p1
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/bayer_is_first_word
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_data_val_p2
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_data_val_p3
add wave -noupdate -group BAYER -color Gold /testbench/system_top/DUT/Xxgs_color_proc/bayer_write_enable
add wave -noupdate -group BAYER -color Gold /testbench/system_top/DUT/Xxgs_color_proc/bayer_w_ram_add
add wave -noupdate -group BAYER -color Gold /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_data_p2
add wave -noupdate -group BAYER -color {Medium Violet Red} /testbench/system_top/DUT/Xxgs_color_proc/bayer_read_enable
add wave -noupdate -group BAYER -color {Medium Violet Red} /testbench/system_top/DUT/Xxgs_color_proc/bayer_r_ram_add
add wave -noupdate -group BAYER -color {Medium Violet Red} /testbench/system_top/DUT/Xxgs_color_proc/bayer_r_ram_dat
add wave -noupdate -group BAYER -color Red /testbench/system_top/DUT/Xxgs_color_proc/BAYER_M0
add wave -noupdate -group BAYER -color Red /testbench/system_top/DUT/Xxgs_color_proc/BAYER_M1
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/C0_B_PIX_end_mosaic
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/C0_G_PIX_end_mosaic
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/C0_R_PIX_end_mosaic
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/C1_B_PIX_end_mosaic
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/C1_G_PIX_end_mosaic
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/C1_R_PIX_end_mosaic
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_eol_p1
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_eol_p2
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_eol_p3
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_eol_p4
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/bayer_sof
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/bayer_sol
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/bayer_data_val
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/bayer_data
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/bayer_eol
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/bayer_eof
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_sof
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_sol
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_data_val
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_data
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_eol
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_eof
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_overscan
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_data_val
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_data_val_p1
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/bayer_is_first_word
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_data_val_p2
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_data_val_p3
add wave -noupdate -group BAYER -color Gold /testbench/system_top/DUT/Xxgs_color_proc/bayer_write_enable
add wave -noupdate -group BAYER -color Gold /testbench/system_top/DUT/Xxgs_color_proc/bayer_w_ram_add
add wave -noupdate -group BAYER -color Gold /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_data_p2
add wave -noupdate -group BAYER -color {Medium Violet Red} /testbench/system_top/DUT/Xxgs_color_proc/bayer_read_enable
add wave -noupdate -group BAYER -color {Medium Violet Red} /testbench/system_top/DUT/Xxgs_color_proc/bayer_r_ram_add
add wave -noupdate -group BAYER -color {Medium Violet Red} /testbench/system_top/DUT/Xxgs_color_proc/bayer_r_ram_dat
add wave -noupdate -group BAYER -color Red /testbench/system_top/DUT/Xxgs_color_proc/BAYER_M0
add wave -noupdate -group BAYER -color Red /testbench/system_top/DUT/Xxgs_color_proc/BAYER_M1
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/C0_B_PIX_end_mosaic
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/C0_G_PIX_end_mosaic
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/C0_R_PIX_end_mosaic
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/C1_B_PIX_end_mosaic
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/C1_G_PIX_end_mosaic
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/C1_R_PIX_end_mosaic
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_eol_p1
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_eol_p2
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_eol_p3
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/BayerIn_eol_p4
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/bayer_sof
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/bayer_sol
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/bayer_data_val
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/bayer_data
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/bayer_eol
add wave -noupdate -group BAYER /testbench/system_top/DUT/Xxgs_color_proc/bayer_eof
add wave -noupdate -divider LUT
add wave -noupdate -expand -group LUT /testbench/system_top/DUT/Xxgs_color_proc/lut_sof
add wave -noupdate -expand -group LUT /testbench/system_top/DUT/Xxgs_color_proc/lut_sol
add wave -noupdate -expand -group LUT /testbench/system_top/DUT/Xxgs_color_proc/lut_data_val
add wave -noupdate -expand -group LUT /testbench/system_top/DUT/Xxgs_color_proc/lut_data
add wave -noupdate -expand -group LUT /testbench/system_top/DUT/Xxgs_color_proc/lut_eol
add wave -noupdate -expand -group LUT /testbench/system_top/DUT/Xxgs_color_proc/lut_eof
add wave -noupdate -expand -group LUT /testbench/system_top/DUT/Xxgs_color_proc/lut_sof
add wave -noupdate -expand -group LUT /testbench/system_top/DUT/Xxgs_color_proc/lut_sol
add wave -noupdate -expand -group LUT /testbench/system_top/DUT/Xxgs_color_proc/lut_data_val
add wave -noupdate -expand -group LUT /testbench/system_top/DUT/Xxgs_color_proc/lut_data
add wave -noupdate -expand -group LUT /testbench/system_top/DUT/Xxgs_color_proc/lut_eol
add wave -noupdate -expand -group LUT /testbench/system_top/DUT/Xxgs_color_proc/lut_eof
add wave -noupdate -divider {COLOR AXIS_OUT}
add wave -noupdate -expand -group AXIS_OUTPUT /testbench/system_top/DUT/Xxgs_color_proc/m_axis_tvalid
add wave -noupdate -expand -group AXIS_OUTPUT /testbench/system_top/DUT/Xxgs_color_proc/m_axis_tready
add wave -noupdate -expand -group AXIS_OUTPUT /testbench/system_top/DUT/Xxgs_color_proc/m_axis_tuser
add wave -noupdate -expand -group AXIS_OUTPUT /testbench/system_top/DUT/Xxgs_color_proc/m_axis_tdata
add wave -noupdate -expand -group AXIS_OUTPUT /testbench/system_top/DUT/Xxgs_color_proc/m_axis_tlast
add wave -noupdate -expand -group AXIS_OUTPUT /testbench/system_top/DUT/Xxgs_color_proc/m_axis_tvalid
add wave -noupdate -expand -group AXIS_OUTPUT /testbench/system_top/DUT/Xxgs_color_proc/m_axis_tready
add wave -noupdate -expand -group AXIS_OUTPUT /testbench/system_top/DUT/Xxgs_color_proc/m_axis_tuser
add wave -noupdate -expand -group AXIS_OUTPUT /testbench/system_top/DUT/Xxgs_color_proc/m_axis_tdata
add wave -noupdate -expand -group AXIS_OUTPUT /testbench/system_top/DUT/Xxgs_color_proc/m_axis_tlast
add wave -noupdate -expand -group AXI_PCIE /testbench/system_top/DUT/regfile.DMA.LINE_PITCH.VALUE
add wave -noupdate -expand -group AXI_PCIE /testbench/system_top/DUT/regfile.DMA.LINE_SIZE.VALUE
add wave -noupdate -expand -group AXI_PCIE /testbench/system_top/s_axis_tx_tuser
add wave -noupdate -expand -group AXI_PCIE /testbench/system_top/s_axis_tx_tvalid
add wave -noupdate -expand -group AXI_PCIE /testbench/system_top/s_axis_tx_tready
add wave -noupdate -expand -group AXI_PCIE /testbench/system_top/s_axis_tx_tdata
add wave -noupdate -expand -group AXI_PCIE /testbench/system_top/s_axis_tx_tlast
add wave -noupdate -expand -group AXI_PCIE /testbench/system_top/s_axis_tx_tuser
add wave -noupdate -expand -group AXI_PCIE /testbench/system_top/s_axis_tx_tvalid
add wave -noupdate -expand -group AXI_PCIE /testbench/system_top/s_axis_tx_tready
add wave -noupdate -expand -group AXI_PCIE /testbench/system_top/s_axis_tx_tdata
add wave -noupdate -expand -group AXI_PCIE /testbench/system_top/s_axis_tx_tlast
add wave -noupdate /testbench/system_top/XGS_MODEL_5000/xgs_image_inst/dataline
add wave -noupdate /testbench/system_top/XGS_MODEL_5000/xgs_image_inst/frame
add wave -noupdate /testbench/system_top/DUT/Xxgs_color_proc/REG_BAYER_EN
add wave -noupdate -divider DPC
add wave -noupdate -divider WB
add wave -noupdate -divider BAYER
add wave -noupdate -divider LUT
add wave -noupdate -divider {COLOR AXIS_OUT}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {261610109 ps} 0} {{Cursor 2} {2699004093 ps} 0} {{Cursor 3} {1925331534 ps} 0} {{Cursor 4} {1547482725 ps} 0}
quietly wave cursor active 4
configure wave -namecolwidth 204
configure wave -valuecolwidth 146
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
WaveRestoreZoom {1547418454 ps} {1547633420 ps}
