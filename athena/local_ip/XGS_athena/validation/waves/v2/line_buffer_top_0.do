onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -subitemconfig {/testbench/DUT/xregfile_xgs_athena/regfile.HISPI -expand /testbench/DUT/xregfile_xgs_athena/regfile.HISPI.STATUS -expand /testbench/DUT/xregfile_xgs_athena/regfile.HISPI.STATUS.FIFO_ERROR {-color Magenta} /testbench/DUT/xregfile_xgs_athena/regfile.HISPI.LANE_DECODER_STATUS -expand /testbench/DUT/xregfile_xgs_athena/regfile.HISPI.LANE_DECODER_STATUS(5) -expand /testbench/DUT/xregfile_xgs_athena/regfile.HISPI.LANE_DECODER_STATUS(1) -expand /testbench/DUT/xregfile_xgs_athena/regfile.HISPI.LANE_DECODER_STATUS(0) -expand} /testbench/DUT/xregfile_xgs_athena/regfile
add wave -noupdate -expand -group {line_buffer Top(0)} -expand -group {line_buffer Top(0)} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer/pclk
add wave -noupdate -expand -group {line_buffer Top(0)} -expand -group {line_buffer Top(0)} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer/pclk_reset
add wave -noupdate -expand -group {line_buffer Top(0)} -expand -group {line_buffer Top(0)} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer/pclk_init
add wave -noupdate -expand -group {line_buffer Top(0)} -expand -group {line_buffer Top(0)} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer/pclk_write_en
add wave -noupdate -expand -group {line_buffer Top(0)} -expand -group {line_buffer Top(0)} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer/pclk_data
add wave -noupdate -expand -group {line_buffer Top(0)} -expand -group {line_buffer Top(0)} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer/pclk_sync
add wave -noupdate -expand -group {line_buffer Top(0)} -expand -group {line_buffer Top(0)} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer/pclk_nxt_buffer
add wave -noupdate -expand -group {line_buffer Top(0)} -expand -group {line_buffer Top(0)} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer/pclk_full
add wave -noupdate -expand -group {line_buffer Top(0)} -expand -group {line_buffer Top(0)} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer/pclk_mux_id
add wave -noupdate -expand -group {line_buffer Top(0)} -expand -group {line_buffer Top(0)} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer/pclk_word_ptr
add wave -noupdate -expand -group {line_buffer Top(0)} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer/pclk_write_address
add wave -noupdate -expand -group {line_buffer Top(0)} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer/pclk_write_data
add wave -noupdate -expand -group {line_buffer Top(0)} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer/sclk_read_address
add wave -noupdate -expand -group {line_buffer Top(0)} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer/sclk_init
add wave -noupdate -expand -group {line_buffer Top(0)} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer/sclk_read_data
add wave -noupdate -expand -group {line_buffer Top(0)} -color Gold /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer/pclk_buffer_ptr
add wave -noupdate -expand -group {line_buffer Top(0)} -color Gold /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer/sclk_buffer_ptr
add wave -noupdate -expand -group {line_buffer Top(0)} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer/sclk_full
add wave -noupdate -expand -group {line_buffer Top(0)} -expand -group used_word_cntr /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer/sclk_buffer_rdy
add wave -noupdate -expand -group {line_buffer Top(0)} -expand -group used_word_cntr /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer/sclk_used_buffer
add wave -noupdate -expand -group {line_buffer Top(0)} -expand -group used_word_cntr /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer/sclk_transfer_done
add wave -noupdate -expand -group {line_buffer Top(0)} -expand -group {Read I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer/sclk
add wave -noupdate -expand -group {line_buffer Top(0)} -expand -group {Read I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer/sclk_reset
add wave -noupdate -expand -group {line_buffer Top(0)} -expand -group {Read I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer/sclk_read_en
add wave -noupdate -expand -group {line_buffer Top(0)} -expand -group {Read I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer/sclk_transfer_done
add wave -noupdate -expand -group {line_buffer Top(0)} -expand -group {Read I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer/sclk_empty
add wave -noupdate -expand -group {line_buffer Top(0)} -expand -group {Read I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer/sclk_mux_id
add wave -noupdate -expand -group {line_buffer Top(0)} -expand -group {Read I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer/sclk_word_ptr
add wave -noupdate -expand -group {line_buffer Top(0)} -expand -group {Read I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer/sclk_sync
add wave -noupdate -expand -group {line_buffer Top(0)} -expand -group {Read I/F} /testbench/DUT/x_xgs_hispi_top/xhispi_phy_top/G_lane_decoder(0)/xlane_decoder/xline_buffer/sclk_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1607435384 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 227
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
WaveRestoreZoom {0 ps} {2362365107 ps}
