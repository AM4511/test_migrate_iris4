onerror {resume}
quietly virtual signal -install /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc { /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/LUT10_10_lut_data(19 downto 10)} LUT10_LUT_data1_10
quietly virtual signal -install /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc { /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/LUT10_10_lut_data(9 downto 0)} LUT10_LUT_data0_10
quietly virtual signal -install /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc { /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/LUT10_10_lut_data(9 downto 2)} LUT10_LUT_Pix1_8
quietly virtual signal -install /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc { /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/LUT10_10_lut_data(9 downto 2)} LUT10_LUT_Pix0_8
quietly virtual signal -install /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc { /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/LUT10_10_lut_data(19 downto 12)} LUT10_LUT_Pix1_8001
quietly virtual signal -install /testbench/system_top/DUT { /testbench/system_top/DUT/conv_tdata(19 downto 12)} conv_tdata_8_1
quietly virtual signal -install /testbench/system_top/DUT { /testbench/system_top/DUT/conv_tdata(9 downto 2)} conv_tdata_8_0
quietly virtual signal -install /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc { /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/dpc_data(19 downto 12)} dpc_data_8_1
quietly virtual signal -install /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc { /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/dpc_data(9 downto 2)} dpc_data_8_0
quietly virtual signal -install /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc { /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/m_axis_tdata(39 downto 32)} data_8_1
quietly virtual signal -install /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc { /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/m_axis_tdata(9 downto 2)} data_8_0
quietly virtual signal -install /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc { /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/m_axis_tdata(39 downto 32)} m_axis_data_8_pix1
quietly virtual signal -install /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc { /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/m_axis_tdata(7 downto 0)} m_axis_data_8_pix0
quietly virtual function -install /testbench/system_top -env /testbench/#INITIAL#72 { &{/testbench/system_top/s_axis_tx_tdata[38], /testbench/system_top/s_axis_tx_tdata[37], /testbench/system_top/s_axis_tx_tdata[36], /testbench/system_top/s_axis_tx_tdata[35], /testbench/system_top/s_axis_tx_tdata[34], /testbench/system_top/s_axis_tx_tdata[33], /testbench/system_top/s_axis_tx_tdata[32], /testbench/system_top/s_axis_tx_tdata[31], /testbench/system_top/s_axis_tx_tdata[47], /testbench/system_top/s_axis_tx_tdata[46], /testbench/system_top/s_axis_tx_tdata[45], /testbench/system_top/s_axis_tx_tdata[44], /testbench/system_top/s_axis_tx_tdata[43], /testbench/system_top/s_axis_tx_tdata[42], /testbench/system_top/s_axis_tx_tdata[41], /testbench/system_top/s_axis_tx_tdata[40], /testbench/system_top/s_axis_tx_tdata[39], /testbench/system_top/s_axis_tx_tdata[55], /testbench/system_top/s_axis_tx_tdata[54], /testbench/system_top/s_axis_tx_tdata[53], /testbench/system_top/s_axis_tx_tdata[52], /testbench/system_top/s_axis_tx_tdata[51], /testbench/system_top/s_axis_tx_tdata[50], /testbench/system_top/s_axis_tx_tdata[49], /testbench/system_top/s_axis_tx_tdata[48], /testbench/system_top/s_axis_tx_tdata[63], /testbench/system_top/s_axis_tx_tdata[62], /testbench/system_top/s_axis_tx_tdata[61], /testbench/system_top/s_axis_tx_tdata[60], /testbench/system_top/s_axis_tx_tdata[59], /testbench/system_top/s_axis_tx_tdata[58], /testbench/system_top/s_axis_tx_tdata[57], /testbench/system_top/s_axis_tx_tdata[56] }} s_axis_tx_data_DW0
quietly virtual signal -install /testbench/system_top/inst_pcie_tx_axi { (context /testbench/system_top/inst_pcie_tx_axi )( s_axis_tx_tdata(39 downto 32) & s_axis_tx_tdata(47 downto 40) & s_axis_tx_tdata(55 downto 48) & s_axis_tx_tdata(63 downto 56) )} DW0
quietly virtual signal -install /testbench/system_top/inst_pcie_tx_axi { (context /testbench/system_top/inst_pcie_tx_axi )( s_axis_tx_tdata(7 downto 0) & s_axis_tx_tdata(15 downto 8) & s_axis_tx_tdata(23 downto 16) & s_axis_tx_tdata(31 downto 24) )} DW1
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/system_top/XGS_MODEL_5000/xgs_image_inst/dataline
add wave -noupdate /testbench/system_top/XGS_MODEL_5000/xgs_image_inst/frame
add wave -noupdate -group {XGS SENSOR} /testbench/system_top/DUT/xgs_trig_int
add wave -noupdate -group {XGS SENSOR} /testbench/system_top/DUT/xgs_monitor0
add wave -noupdate -group {XGS SENSOR} /testbench/system_top/DUT/xgs_monitor1
add wave -noupdate -group {XGS SENSOR} /testbench/system_top/DUT/xgs_monitor2
add wave -noupdate -group {XGS SENSOR} -expand -subitemconfig {/testbench/system_top/DUT/regfile.BAYER.WB_MUL1 -expand /testbench/system_top/DUT/regfile.BAYER.WB_MUL2 -expand} /testbench/system_top/DUT/regfile.BAYER
add wave -noupdate -group {XGS SENSOR} -divider {AXI 2 MATROX}
add wave -noupdate -group {XGS SENSOR} /testbench/system_top/DUT/xgs_trig_int
add wave -noupdate -group {XGS SENSOR} /testbench/system_top/DUT/xgs_monitor0
add wave -noupdate -group {XGS SENSOR} /testbench/system_top/DUT/xgs_monitor1
add wave -noupdate -group {XGS SENSOR} /testbench/system_top/DUT/xgs_monitor2
add wave -noupdate -group {XGS SENSOR} -expand -subitemconfig {/testbench/system_top/DUT/regfile.BAYER.WB_MUL1 -expand /testbench/system_top/DUT/regfile.BAYER.WB_MUL2 -expand} /testbench/system_top/DUT/regfile.BAYER
add wave -noupdate -group {XGS SENSOR} -divider {AXI 2 MATROX}
add wave -noupdate -divider {Axis width conv}
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xaxis_width_conv/s_axis_tready
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xaxis_width_conv/s_axis_tvalid
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xaxis_width_conv/s_axis_tdata
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xaxis_width_conv/s_axis_tlast
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xaxis_width_conv/s_axis_tuser
add wave -noupdate -divider {New Divider}
add wave -noupdate /testbench/system_top/DUT/conv_tuser
add wave -noupdate /testbench/system_top/DUT/conv_tvalid
add wave -noupdate /testbench/system_top/DUT/conv_tready
add wave -noupdate /testbench/system_top/DUT/conv_tdata_8_1
add wave -noupdate /testbench/system_top/DUT/conv_tdata_8_0
add wave -noupdate /testbench/system_top/DUT/conv_tdata
add wave -noupdate /testbench/system_top/DUT/conv_tlast
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/s_axis_first_prefetch
add wave -noupdate -divider DPC
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/Xdpc_filter_color/REG_dpc_enable
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/Xdpc_filter_color/REG_dpc_enable_DB
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/Xdpc_filter_color/REG_dpc_enable_P1
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/axi_sof
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/axi_sol
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/axi_data_val
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/axi_data8
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/axi_eol
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/axi_eof
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/dpc_sof
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/dpc_sol
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/dpc_data_val
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/dpc_data_8_1
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/dpc_data_8_0
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/dpc_data
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/dpc_eol
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/dpc_eof
add wave -noupdate -divider WB
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/BAYER_EN
add wave -noupdate -divider BAYER
add wave -noupdate -divider LUT
add wave -noupdate /testbench/system_top/DUT/xregfile_xgs_athena/regfile
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/REG_LUT_BYPASS
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/LUT10_10_lut_sof
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/LUT10_10_lut_sol
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/LUT10_10_lut_data_val
add wave -noupdate -label LUT10_LUT_Pix1_8 /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/LUT10_LUT_Pix1_8001
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/LUT10_LUT_Pix0_8
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/LUT10_10_lut_eol
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/LUT10_10_lut_eof
add wave -noupdate -divider {COLOR AXIS_OUT}
add wave -noupdate -divider {New Divider}
add wave -noupdate -color {Medium Violet Red} /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/bayer_sof
add wave -noupdate -color {Medium Violet Red} /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/bayer_sol
add wave -noupdate -color {Medium Violet Red} /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/bayer_data_val
add wave -noupdate -color {Medium Violet Red} /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/bayer_data
add wave -noupdate -color {Medium Violet Red} /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/bayer_eol
add wave -noupdate -color {Medium Violet Red} /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/bayer_eof
add wave -noupdate -divider {COLOR OUTPUT AXIS}
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/m_axis_tvalid
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/m_axis_tready
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/m_axis_data_8_pix1
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/m_axis_data_8_pix0
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/m_axis_tdata
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/m_axis_tlast
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/m_axis_tuser
add wave -noupdate -divider {New Divider}
add wave -noupdate -expand -group AXI_PCIE /testbench/system_top/DUT/regfile.DMA.LINE_PITCH.VALUE
add wave -noupdate -expand -group AXI_PCIE /testbench/system_top/DUT/regfile.DMA.LINE_SIZE.VALUE
add wave -noupdate -expand -group AXI_PCIE /testbench/system_top/s_axis_tx_tuser
add wave -noupdate -expand -group AXI_PCIE /testbench/system_top/s_axis_tx_tvalid
add wave -noupdate -expand -group AXI_PCIE /testbench/system_top/s_axis_tx_tready
add wave -noupdate -expand -group AXI_PCIE /testbench/system_top/s_axis_tx_tdata
add wave -noupdate -expand -group AXI_PCIE /testbench/system_top/s_axis_tx_tlast
add wave -noupdate -divider DPC
add wave -noupdate -divider WB
add wave -noupdate -divider BAYER
add wave -noupdate -divider LUT
add wave -noupdate -divider {COLOR AXIS_OUT}
add wave -noupdate /testbench/system_top/DUT/trim_inst/aclk
add wave -noupdate -color Yellow /testbench/system_top/DUT/trim_inst/aclk_tuser
add wave -noupdate -color Yellow /testbench/system_top/DUT/trim_inst/aclk_tvalid
add wave -noupdate -color Yellow /testbench/system_top/DUT/trim_inst/aclk_tready
add wave -noupdate -color Yellow /testbench/system_top/DUT/trim_inst/aclk_tdata
add wave -noupdate -color Yellow /testbench/system_top/DUT/trim_inst/aclk_tlast
add wave -noupdate /testbench/system_top/DUT/trim_inst/aclk_x_crop_en
add wave -noupdate /testbench/system_top/DUT/trim_inst/aclk_x_reverse
add wave -noupdate /testbench/system_top/DUT/trim_inst/aclk_x_scale
add wave -noupdate /testbench/system_top/DUT/trim_inst/aclk_x_size
add wave -noupdate /testbench/system_top/DUT/trim_inst/aclk_x_start
add wave -noupdate /testbench/system_top/DUT/trim_inst/aclk_y_roi_en
add wave -noupdate /testbench/system_top/DUT/trim_inst/aclk_y_size
add wave -noupdate /testbench/system_top/DUT/trim_inst/aclk_y_start
add wave -noupdate /testbench/system_top/DUT/trim_inst/bclk
add wave -noupdate /testbench/system_top/DUT/trim_inst/bclk_reset_n
add wave -noupdate -color {Orange Red} /testbench/system_top/DUT/trim_inst/bclk_tvalid
add wave -noupdate -color {Orange Red} /testbench/system_top/DUT/trim_inst/bclk_tready
add wave -noupdate -color {Orange Red} /testbench/system_top/DUT/trim_inst/bclk_tdata
add wave -noupdate -color {Orange Red} /testbench/system_top/DUT/trim_inst/bclk_tuser
add wave -noupdate -color {Orange Red} /testbench/system_top/DUT/trim_inst/bclk_tlast
add wave -noupdate -divider {New Divider}
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_pixel_width
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_x_crop_en
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_x_start
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_x_size
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_x_scale
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_x_reverse
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_reset
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_tready
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_tvalid
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_tuser
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_tlast
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_tdata
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/bclk
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/bclk_reset_n
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/bclk_tready
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/bclk_tvalid
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/bclk_tuser
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/bclk_tlast
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/bclk_tdata
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_state
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_full
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_tready_int
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_init_word_ptr
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_word_ptr
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_buffer_ptr
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_init_buffer_ptr
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_init_subsampling
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_nxt_buffer
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_write_en
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_write_address
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_write_data
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_cmd_wen
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_cmd_full
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_cmd_data
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_cmd_sync
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_cmd_size
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_cmd_buff_ptr
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_cmd_last_ben
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_ack
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_pix_incr
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_crop_start
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_crop_stop
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_crop_size
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_crop_stop_mask_sel
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_crop_data_rdy
add wave -noupdate -group {TRIM INSIDE} -color Goldenrod /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_pix_cntr
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_valid_start
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_valid_stop
add wave -noupdate -group {TRIM INSIDE} -color Red /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_crop_window_valid
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_crop_packer
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_crop_packer_ben
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_crop_data_mux
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_crop_last_data_mux
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_crop_ben_mux
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_crop_mux_sel
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_crop_packer_valid
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_subs_empty
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_subs_data_valid
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_subs_last_data
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_subs_data
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_subs_ben
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/bclk_x_reverse_Meta
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/bclk_x_reverse
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/bclk_pixel_width
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/bclk_reset
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/bclk_full
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/bclk_row_cntr
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/bclk_read_address
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/bclk_read_en
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/bclk_read_data
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/bclk_used_buffer
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/bclk_transfer_done
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/bclk_init
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/bclk_buffer_rdy
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/bclk_cmd_ren
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/bclk_cmd_empty
add wave -noupdate -group {TRIM INSIDE} /testbench/system_top/DUT/trim_inst/x_trim_inst/bclk_cmd_data
add wave -noupdate -divider {New Divider}
add wave -noupdate /testbench/system_top/DUT/xregfile_xgs_athena/regfile.DMA
add wave -noupdate /testbench/system_top/DUT/xregfile_xgs_athena/regfile.DMA.ROI_X.X_START
add wave -noupdate -divider {New Divider}
add wave -noupdate -expand /testbench/system_top/DUT/xregfile_xgs_athena/regfile
add wave -noupdate -divider {PCIE OUT}
add wave -noupdate /testbench/system_top/s_axis_tx_tuser
add wave -noupdate /testbench/system_top/s_axis_tx_tvalid
add wave -noupdate /testbench/system_top/s_axis_tx_tready
add wave -noupdate -label s_axi_tx_data_DW1_reversed /testbench/system_top/inst_pcie_tx_axi/DW0
add wave -noupdate -label s_axi_tx_data_DW0_reversed /testbench/system_top/inst_pcie_tx_axi/DW1
add wave -noupdate /testbench/system_top/inst_pcie_tx_axi/s_axis_tx_tdata
add wave -noupdate /testbench/system_top/s_axis_tx_tlast
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 3} {6495328017 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 176
configure wave -valuecolwidth 170
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
WaveRestoreZoom {6495267971 ps} {6495381692 ps}
