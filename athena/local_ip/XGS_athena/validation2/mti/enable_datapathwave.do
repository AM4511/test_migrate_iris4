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
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/hclk_idle_detected
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/hclk_idle_detect_en
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/hclk_lock_cntr
add wave -noupdate -color Red /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/hclk_bit_locked
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/hclk_state
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/hclk_sync_detected
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/SYNC_MARKER
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/PIXEL_SIZE
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/PHY_OUTPUT_WIDTH
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/pclk_valid
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/pclk_state
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/pclk_embedded
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/pclk_data
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/pclk_cal_busy
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/pclk_bit_locked
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/pclk
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/HISPI_WORDS_PER_SYNC_CODE
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/HISPI_SHIFT_REGISTER_SIZE
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/hclk_valid
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/HCLK_SYNC_SOL
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/HCLK_SYNC_SOF
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/HCLK_SYNC_EOL
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/HCLK_SYNC_EOF
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/hclk_shift_register
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/hclk_reset
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/hclk_phase
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/hclk_lsb_ptr_reg
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/hclk_lsb_ptr
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/hclk_lock_cntr_max_value
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/hclk_lane_enable
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/hclk_idle_char
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/hclk_enable_datapath
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/hclk_embedded
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/hclk_done
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/hclk_data_lane
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/hclk_data
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/hclk_crc_enable
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/hclk_aligned_pixel_mux
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xbit_split/hclk
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3950404065 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 187
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
WaveRestoreZoom {3546292607 ps} {7232203033 ps}
