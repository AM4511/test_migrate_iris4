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
add wave -noupdate -divider {Axis width conv INPUT}
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xaxis_width_conv/axi_clk
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xaxis_width_conv/axi_reset_n
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xaxis_width_conv/s_axis_tvalid
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xaxis_width_conv/s_axis_tready
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xaxis_width_conv/s_axis_tuser
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xaxis_width_conv/s_axis_tlast
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xaxis_width_conv/s_axis_tdata
add wave -noupdate -divider {Axis width conv OUTPUT}
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xaxis_width_conv/m_axis_tvalid
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xaxis_width_conv/m_axis_tready
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xaxis_width_conv/m_axis_tuser
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xaxis_width_conv/m_axis_tlast
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xaxis_width_conv/s_axis_tdata_64
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xaxis_width_conv/m_axis_tdata
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xaxis_width_conv/m_axis_tdata_16
add wave -noupdate -divider {COLOR AXIS_OUT}
add wave -noupdate /testbench/system_top/DUT/trim_inst/aclk
add wave -noupdate -color Yellow /testbench/system_top/DUT/trim_inst/aclk_tuser
add wave -noupdate -color Yellow /testbench/system_top/DUT/trim_inst/aclk_tvalid
add wave -noupdate -color Yellow /testbench/system_top/DUT/trim_inst/aclk_tready
add wave -noupdate -color Yellow /testbench/system_top/DUT/trim_inst/aclk_tdata
add wave -noupdate -color Yellow /testbench/system_top/DUT/trim_inst/aclk_tlast
add wave -noupdate -divider TRIM_OUT
add wave -noupdate /testbench/system_top/DUT/trim_inst/bclk
add wave -noupdate /testbench/system_top/DUT/trim_inst/bclk_reset_n
add wave -noupdate -color {Orange Red} /testbench/system_top/DUT/trim_inst/bclk_tvalid
add wave -noupdate -color {Orange Red} /testbench/system_top/DUT/trim_inst/bclk_tready
add wave -noupdate -color {Orange Red} /testbench/system_top/DUT/trim_inst/bclk_tdata
add wave -noupdate -color {Orange Red} /testbench/system_top/DUT/trim_inst/bclk_tuser
add wave -noupdate -color {Orange Red} /testbench/system_top/DUT/trim_inst/bclk_tlast
add wave -noupdate -divider {New Divider}
add wave -noupdate /testbench/system_top/DUT/xregfile_xgs_athena/regfile
add wave -noupdate -divider {PCIE OUT}
add wave -noupdate /testbench/system_top/s_axis_tx_tuser
add wave -noupdate /testbench/system_top/s_axis_tx_tvalid
add wave -noupdate /testbench/system_top/s_axis_tx_tready
add wave -noupdate -label s_axi_tx_data_DW1_reversed /testbench/system_top/inst_pcie_tx_axi/DW0
add wave -noupdate -label s_axi_tx_data_DW0_reversed /testbench/system_top/inst_pcie_tx_axi/DW1
add wave -noupdate /testbench/system_top/inst_pcie_tx_axi/s_axis_tx_tdata
add wave -noupdate /testbench/system_top/s_axis_tx_tlast
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 3} {5682832719 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 216
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
WaveRestoreZoom {5482865286 ps} {6402600387 ps}
