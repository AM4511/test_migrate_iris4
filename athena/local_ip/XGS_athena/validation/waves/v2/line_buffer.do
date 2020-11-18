onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group line_buffer -expand -group {PCLK write I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer_v2/pclk
add wave -noupdate -expand -group line_buffer -expand -group {PCLK write I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer_v2/pclk_reset
add wave -noupdate -expand -group line_buffer -expand -group {PCLK write I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer_v2/pclk_init
add wave -noupdate -expand -group line_buffer -expand -group {PCLK write I/F} -color Gold /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer_v2/pclk_write_en
add wave -noupdate -expand -group line_buffer -expand -group {PCLK write I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer_v2/pclk_data
add wave -noupdate -expand -group line_buffer -expand -group {PCLK write I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer_v2/pclk_sync
add wave -noupdate -expand -group line_buffer -expand -group {PCLK write I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer_v2/pclk_buffer_id
add wave -noupdate -expand -group line_buffer -expand -group {PCLK write I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer_v2/pclk_mux_id
add wave -noupdate -expand -group line_buffer -expand -group {PCLK write I/F} -color {Medium Slate Blue} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer_v2/pclk_word_ptr
add wave -noupdate -expand -group line_buffer -expand -group {PCLK write I/F} -expand /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer_v2/pclk_set_buff_ready
add wave -noupdate -expand -group line_buffer -expand -group {PCLK write I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer_v2/pclk_buff_ready
add wave -noupdate -expand -group line_buffer /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer_v2/pclk_write_address
add wave -noupdate -expand -group line_buffer /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer_v2/pclk_write_data
add wave -noupdate -expand -group line_buffer /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer_v2/pclk_word_count
add wave -noupdate -expand -group line_buffer /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer_v2/sclk_read_address
add wave -noupdate -expand -group line_buffer /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer_v2/sclk_read_data
add wave -noupdate -expand -group line_buffer /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer_v2/sclk_buffer_empty
add wave -noupdate -expand -group line_buffer -expand /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer_v2/sclk_set_buff_ready
add wave -noupdate -expand -group line_buffer /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer_v2/sclk_buff_ready_ff
add wave -noupdate -expand -group line_buffer -expand /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer_v2/sclk_word_count_array
add wave -noupdate -expand -group line_buffer -expand -group {SCLK read I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer_v2/sclk
add wave -noupdate -expand -group line_buffer -expand -group {SCLK read I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer_v2/sclk_reset
add wave -noupdate -expand -group line_buffer -expand -group {SCLK read I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer_v2/sclk_empty
add wave -noupdate -expand -group line_buffer -expand -group {SCLK read I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer_v2/sclk_read_en
add wave -noupdate -expand -group line_buffer -expand -group {SCLK read I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer_v2/sclk_buffer_id
add wave -noupdate -expand -group line_buffer -expand -group {SCLK read I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer_v2/sclk_mux_id
add wave -noupdate -expand -group line_buffer -expand -group {SCLK read I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer_v2/sclk_word_ptr
add wave -noupdate -expand -group line_buffer -expand -group {SCLK read I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer_v2/sclk_sync
add wave -noupdate -expand -group line_buffer -expand -group {SCLK read I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer_v2/sclk_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1167016359 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 239
configure wave -valuecolwidth 145
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
WaveRestoreZoom {0 ps} {1402682021 ps}
