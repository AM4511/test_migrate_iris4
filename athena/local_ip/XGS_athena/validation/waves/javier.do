onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group TLP /testbench/inst_pcie_tx_axi/tlp_out_req_to_send
add wave -noupdate -group TLP /testbench/inst_pcie_tx_axi/tlp_out_grant
add wave -noupdate -group TLP /testbench/inst_pcie_tx_axi/tlp_out_fmt_type
add wave -noupdate -group TLP /testbench/inst_pcie_tx_axi/tlp_out_length_in_dw
add wave -noupdate -group TLP /testbench/inst_pcie_tx_axi/tlp_out_src_rdy_n
add wave -noupdate -group TLP /testbench/inst_pcie_tx_axi/tlp_out_dst_rdy_n
add wave -noupdate -group TLP /testbench/inst_pcie_tx_axi/tlp_out_data
add wave -noupdate -group TLP /testbench/inst_pcie_tx_axi/tlp_out_address
add wave -noupdate -group TLP /testbench/inst_pcie_tx_axi/tlp_out_ldwbe_fdwbe
add wave -noupdate -subitemconfig {/testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/regfile.ACQ -expand} /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/regfile
add wave -noupdate /testbench/DUT/x_xgs_hispi_top/bottom_sof_flag(0)
add wave -noupdate /testbench/DUT/x_xgs_hispi_top/bottom_sol_flag(0)
add wave -noupdate /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_packer_0_valid
add wave -noupdate /testbench/DUT/x_xgs_hispi_top/bottom_eol_flag(0)
add wave -noupdate /testbench/DUT/x_xgs_hispi_top/bottom_eof_flag(0)
add wave -noupdate -divider {New Divider}
add wave -noupdate /testbench/DUT/xgs_mono_pipeline_inst/aclk
add wave -noupdate /testbench/DUT/xgs_mono_pipeline_inst/aclk_tready
add wave -noupdate /testbench/DUT/xgs_mono_pipeline_inst/aclk_tvalid
add wave -noupdate /testbench/DUT/xgs_mono_pipeline_inst/aclk_tdata
add wave -noupdate /testbench/DUT/xgs_mono_pipeline_inst/aclk_tlast
add wave -noupdate /testbench/DUT/xgs_mono_pipeline_inst/aclk_tuser
add wave -noupdate -divider {New Divider}
add wave -noupdate /testbench/inst_pcie_tx_axi/sys_clk
add wave -noupdate /testbench/inst_pcie_tx_axi/sys_reset_n
add wave -noupdate /testbench/inst_pcie_tx_axi/s_axis_tx_tready
add wave -noupdate /testbench/inst_pcie_tx_axi/s_axis_tx_tvalid
add wave -noupdate /testbench/inst_pcie_tx_axi/s_axis_tx_tdata
add wave -noupdate /testbench/inst_pcie_tx_axi/s_axis_tx_tlast
add wave -noupdate /testbench/inst_pcie_tx_axi/s_axis_tx_tuser
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1211230748 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 237
configure wave -valuecolwidth 187
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
WaveRestoreZoom {1162795989 ps} {1215197708 ps}
