onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/yuv_sof
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/yuv_sol
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/yuv_data_val
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/yuv_data
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/yuv_eol
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/yuv_eof
add wave -noupdate -divider {New Divider}
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/m_axis_tvalid
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/m_axis_tready
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/m_axis_tuser
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/m_axis_tdata
add wave -noupdate /testbench/system_top/DUT/G_COLOR_PIPELINE/Xxgs_color_proc/m_axis_tlast
add wave -noupdate -divider {New Divider}
add wave -noupdate /testbench/system_top/inst_pcie_tx_axi/s_axis_tx_tvalid
add wave -noupdate /testbench/system_top/inst_pcie_tx_axi/s_axis_tx_tready
add wave -noupdate /testbench/system_top/inst_pcie_tx_axi/s_axis_tx_tuser
add wave -noupdate /testbench/system_top/inst_pcie_tx_axi/s_axis_tx_tdata
add wave -noupdate /testbench/system_top/inst_pcie_tx_axi/s_axis_tx_tlast
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1357455861 ps} 0}
quietly wave cursor active 1
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
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {3036961200 ps}
