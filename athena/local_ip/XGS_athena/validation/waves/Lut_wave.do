onerror {resume}
quietly virtual signal -install /testbench/DUT/xaxi_lut { (context /testbench/DUT/xaxi_lut )( s_axis_tdata(79 downto 72) & s_axis_tdata(69 downto 62) & s_axis_tdata(59 downto 52) & s_axis_tdata(49 downto 42) & s_axis_tdata(39 downto 32) & s_axis_tdata(29 downto 22) & s_axis_tdata(19 downto 12) & s_axis_tdata(9 downto 2) )} s_axis_tdata64
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/DUT/xaxi_lut/axi_clk
add wave -noupdate /testbench/DUT/xaxi_lut/axi_reset_n
add wave -noupdate -color Magenta /testbench/DUT/xaxi_lut/s_axis_tvalid
add wave -noupdate -color Magenta /testbench/DUT/xaxi_lut/s_axis_tready
add wave -noupdate -color Magenta /testbench/DUT/xaxi_lut/s_axis_tuser
add wave -noupdate -color Magenta /testbench/DUT/xaxi_lut/s_axis_tlast
add wave -noupdate -color Magenta /testbench/DUT/xaxi_lut/s_axis_tdata
add wave -noupdate /testbench/DUT/xaxi_lut/s_axis_tdata64
add wave -noupdate /testbench/DUT/xaxi_lut/axi_state
add wave -noupdate -color Cyan /testbench/DUT/xaxi_lut/RAM_R_enable
add wave -noupdate -color Yellow /testbench/DUT/xaxi_lut/m_axis_tvalid
add wave -noupdate -color Yellow /testbench/DUT/xaxi_lut/m_axis_tready
add wave -noupdate -color Yellow /testbench/DUT/xaxi_lut/m_axis_tdata
add wave -noupdate -color Yellow /testbench/DUT/xaxi_lut/m_axis_tlast
add wave -noupdate -color Yellow /testbench/DUT/xaxi_lut/m_axis_tuser
add wave -noupdate /testbench/DUT/xaxi_lut/regfile
add wave -noupdate /testbench/DUT/xaxi_lut/RAM_W_enable
add wave -noupdate /testbench/DUT/xaxi_lut/RAM_W_address
add wave -noupdate /testbench/DUT/xaxi_lut/RAM_W_data
add wave -noupdate -color Cyan /testbench/DUT/xaxi_lut/RAM_R_address
add wave -noupdate -color Cyan /testbench/DUT/xaxi_lut/RAM_R_data
add wave -noupdate -divider {New Divider}
add wave -noupdate /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_crc_enable
add wave -noupdate /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_crc_en
add wave -noupdate /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_state
add wave -noupdate /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_computed_crc2
add wave -noupdate /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_computed_crc1
add wave -noupdate /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_data_p1
add wave -noupdate /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_crc_error
add wave -noupdate /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/rclk_crc_error
add wave -noupdate -expand /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/regfile.HISPI.LANE_DECODER_STATUS
add wave -noupdate -color Magenta /testbench/tready_packet_delai
add wave -noupdate /testbench/dma_irq_cntr
add wave -noupdate /testbench/inst_pcie_tx_axi/sys_clk
add wave -noupdate /testbench/inst_pcie_tx_axi/s_axis_tx_tvalid
add wave -noupdate /testbench/inst_pcie_tx_axi/s_axis_tx_tready
add wave -noupdate /testbench/inst_pcie_tx_axi/s_axis_tx_tlast
add wave -noupdate /testbench/inst_pcie_tx_axi/s_axis_tx_tuser
add wave -noupdate /testbench/inst_pcie_tx_axi/s_axis_tx_tdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1197747126 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 154
configure wave -valuecolwidth 148
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
WaveRestoreZoom {1125030144 ps} {1274448210 ps}
