onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/sclk_tvalid
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/sclk_tuser
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/sclk_tready
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/sclk_tlast
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/sclk_tdata
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/pclk_state
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/hclk_sync_detected
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/hclk_state
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/hclk_enable_datapath
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3853719781 ps} 0}
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
WaveRestoreZoom {5209550953 ps} {5416590035 ps}
