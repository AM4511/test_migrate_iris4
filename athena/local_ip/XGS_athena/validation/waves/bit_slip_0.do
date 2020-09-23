onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group bit_slip /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/hclk
add wave -noupdate -expand -group bit_slip /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/hclk_reset
add wave -noupdate -expand -group bit_slip /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/hclk_idle_char
add wave -noupdate -expand -group bit_slip /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/hclk_data_lane
add wave -noupdate -expand -group bit_slip /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/hclk_phase
add wave -noupdate -expand -group bit_slip /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/hclk_shift_register
add wave -noupdate -expand -group bit_slip /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/hclk_lsb_ptr
add wave -noupdate -expand -group bit_slip -color {Violet Red} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/hclk_lsb_ptr_reg
add wave -noupdate -expand -group bit_slip /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/hclk_aligned_pixel_mux
add wave -noupdate -expand -group bit_slip /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/hclk_data
add wave -noupdate -expand -group bit_slip /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/hclk_sync_detected
add wave -noupdate -expand -group bit_slip /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/hclk_lock_cntr_max_value
add wave -noupdate -expand -group bit_slip /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/hclk_lock_cntr
add wave -noupdate -expand -group bit_slip /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/hclk_bit_locked
add wave -noupdate -expand -group bit_slip -color {Cornflower Blue} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/hclk_idle_detect_en
add wave -noupdate -expand -group bit_slip -color {Cornflower Blue} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/hclk_idle_detected
add wave -noupdate -expand -group bit_slip /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/hclk_hispi_phy_en
add wave -noupdate -expand -group bit_slip /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/hclk_crc_enable
add wave -noupdate -expand -group bit_slip /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/hclk_valid
add wave -noupdate -expand -group bit_slip /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/hclk_embedded
add wave -noupdate -expand -group bit_slip /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/hclk_done
add wave -noupdate -expand -group bit_slip /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/hclk_state
add wave -noupdate -expand -group bit_slip -expand -group {pclk I/F} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/pclk
add wave -noupdate -expand -group bit_slip -expand -group {pclk I/F} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/pclk_bit_locked
add wave -noupdate -expand -group bit_slip -expand -group {pclk I/F} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/pclk_valid
add wave -noupdate -expand -group bit_slip -expand -group {pclk I/F} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/pclk_embedded
add wave -noupdate -expand -group bit_slip -expand -group {pclk I/F} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/pclk_state
add wave -noupdate -expand -group bit_slip -expand -group {pclk I/F} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/pclk_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1198657193 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 206
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
WaveRestoreZoom {1198354176 ps} {1199467027 ps}
