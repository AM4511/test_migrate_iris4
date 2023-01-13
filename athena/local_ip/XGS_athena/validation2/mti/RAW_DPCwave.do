onerror {resume}
quietly virtual signal -install /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/Xdpc_filter_color { /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/Xdpc_filter_color/dpc_data(19 downto 12)} dcp_pix0
quietly virtual signal -install /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/Xdpc_filter_color { /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/Xdpc_filter_color/dpc_data(9 downto 2)} dcp_pix
quietly virtual signal -install /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/Xdpc_filter_color { /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/Xdpc_filter_color/axi_data(19 downto 12)} axi_data_1
quietly virtual signal -install /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/Xdpc_filter_color { /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/Xdpc_filter_color/axi_data(9 downto 2)} axi_data_0
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Yellow /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/Xdpc_filter_color/axi_sof
add wave -noupdate -color Yellow /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/Xdpc_filter_color/axi_sol
add wave -noupdate -color Yellow /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/Xdpc_filter_color/axi_data_val
add wave -noupdate -color Yellow /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/Xdpc_filter_color/axi_data
add wave -noupdate -color Yellow /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/Xdpc_filter_color/axi_data_1
add wave -noupdate -color Yellow /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/Xdpc_filter_color/axi_data_0
add wave -noupdate -color Yellow /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/Xdpc_filter_color/axi_eol
add wave -noupdate -color Yellow /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/Xdpc_filter_color/axi_eof
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/Xdpc_filter_color/dpc_sof
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/Xdpc_filter_color/dpc_sol
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/Xdpc_filter_color/dpc_data
add wave -noupdate -label dpc_pix1 /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/Xdpc_filter_color/dcp_pix0
add wave -noupdate -label dpc_pix0 /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/Xdpc_filter_color/dcp_pix
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/Xdpc_filter_color/dpc_eol
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/Xdpc_filter_color/dpc_eof_m1
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/Xdpc_filter_color/dpc_eof
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/Xdpc_filter_color/dpc_data_val
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/LUT10_10_lut_data_val
add wave -noupdate -color Yellow /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/axi_clk
add wave -noupdate -color Yellow /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/s_axis_tvalid
add wave -noupdate -color Yellow /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/s_axis_tuser
add wave -noupdate -color Yellow /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/s_axis_tready
add wave -noupdate -color Yellow /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/s_axis_tlast
add wave -noupdate -color Yellow /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/s_axis_tdata8
add wave -noupdate -color Yellow /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/s_axis_line_wait
add wave -noupdate -color Yellow /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/s_axis_line_gap
add wave -noupdate -color Red /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/axi_clk
add wave -noupdate -color Red /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/m_axis_tvalid
add wave -noupdate -color Red /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/m_axis_tready
add wave -noupdate -color Red /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/m_axis_tuser
add wave -noupdate -color Red /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/m_axis_tdata
add wave -noupdate -color Red /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/m_axis_tlast
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/m_axis_in_use
add wave -noupdate -color Yellow /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/m_axis_wait_data
add wave -noupdate -color Yellow /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/m_axis_wait
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/s_axis_tready_int
add wave -noupdate /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk
add wave -noupdate /testbench/system_top/DUT/trim_inst/y_trim_inst/aclk_y_roi_en
add wave -noupdate /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_tvalid
add wave -noupdate /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_state
add wave -noupdate /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_tuser
add wave -noupdate /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_tready
add wave -noupdate /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_tlast
add wave -noupdate /testbench/system_top/DUT/trim_inst/x_trim_inst/aclk_tdata
add wave -noupdate /testbench/system_top/DUT/regfile
add wave -noupdate /testbench/system_top/DUT/trim_tvalid
add wave -noupdate /testbench/system_top/DUT/trim_tready
add wave -noupdate /testbench/system_top/DUT/trim_tuser
add wave -noupdate /testbench/system_top/DUT/trim_tlast
add wave -noupdate /testbench/system_top/DUT/trim_tdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5634115708 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 158
configure wave -valuecolwidth 110
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
WaveRestoreZoom {5633615440 ps} {5635075107 ps}
