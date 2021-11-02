onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/system_top/DUT/xgs_trig_int
add wave -noupdate /testbench/system_top/DUT/xgs_monitor0
add wave -noupdate /testbench/system_top/DUT/xgs_monitor1
add wave -noupdate /testbench/system_top/DUT/xgs_monitor2
add wave -noupdate /testbench/system_top/DUT/hispi_ystart
add wave -noupdate /testbench/system_top/DUT/hispi_ysize
add wave -noupdate /testbench/system_top/DUT/hispi_yend
add wave -noupdate /testbench/system_top/DUT/hispi_ydiv2_en
add wave -noupdate /testbench/system_top/DUT/hispi_xstart
add wave -noupdate /testbench/system_top/DUT/hispi_xsize
add wave -noupdate /testbench/system_top/DUT/hispi_xend
add wave -noupdate /testbench/system_top/DUT/hispi_subY
add wave -noupdate /testbench/system_top/DUT/hispi_subX
add wave -noupdate -divider DPC_IN
add wave -noupdate /testbench/system_top/DUT/aclk_tvalid
add wave -noupdate /testbench/system_top/DUT/aclk_tready
add wave -noupdate /testbench/system_top/DUT/aclk_tuser
add wave -noupdate /testbench/system_top/DUT/aclk_tdata
add wave -noupdate /testbench/system_top/DUT/aclk_tlast
add wave -noupdate -divider {DPC_OUT - LUT IN}
add wave -noupdate /testbench/system_top/DUT/dcp_tvalid
add wave -noupdate /testbench/system_top/DUT/dcp_tready
add wave -noupdate /testbench/system_top/DUT/dcp_tuser
add wave -noupdate /testbench/system_top/DUT/dcp_tdata
add wave -noupdate /testbench/system_top/DUT/dcp_tlast
add wave -noupdate -divider {LUT_OUT - TRIM IN}
add wave -noupdate /testbench/system_top/DUT/trim_tvalid
add wave -noupdate /testbench/system_top/DUT/trim_tready
add wave -noupdate /testbench/system_top/DUT/trim_tuser
add wave -noupdate /testbench/system_top/DUT/trim_tlast
add wave -noupdate /testbench/system_top/DUT/trim_tdata
add wave -noupdate -divider {TRIM OUT}
add wave -noupdate /testbench/system_top/DUT/dma_tvalid
add wave -noupdate /testbench/system_top/DUT/dma_tready
add wave -noupdate /testbench/system_top/DUT/dma_tuser
add wave -noupdate /testbench/system_top/DUT/dma_tdata
add wave -noupdate /testbench/system_top/DUT/dma_tlast
add wave -noupdate -divider {New Divider}
add wave -noupdate /testbench/system_top/DUT/xdmawr2tlp/tlp_transaction_id
add wave -noupdate /testbench/system_top/DUT/xdmawr2tlp/tlp_req_to_send
add wave -noupdate /testbench/system_top/DUT/xdmawr2tlp/tlp_lower_address
add wave -noupdate /testbench/system_top/DUT/xdmawr2tlp/tlp_length_in_dw
add wave -noupdate /testbench/system_top/DUT/xdmawr2tlp/tlp_ldwbe_fdwbe
add wave -noupdate /testbench/system_top/DUT/xdmawr2tlp/tlp_grant
add wave -noupdate /testbench/system_top/DUT/xdmawr2tlp/tlp_fmt_type
add wave -noupdate /testbench/system_top/DUT/xdmawr2tlp/tlp_src_rdy_n
add wave -noupdate /testbench/system_top/DUT/xdmawr2tlp/tlp_dst_rdy_n
add wave -noupdate /testbench/system_top/DUT/xdmawr2tlp/tlp_data
add wave -noupdate /testbench/system_top/DUT/xdmawr2tlp/tlp_byte_count
add wave -noupdate /testbench/system_top/DUT/xdmawr2tlp/tlp_attr
add wave -noupdate /testbench/system_top/DUT/xdmawr2tlp/tlp_address
add wave -noupdate -divider {New Divider}
add wave -noupdate /testbench/system_top/inst_pcie_tx_axi/s_axis_tx_tvalid
add wave -noupdate /testbench/system_top/inst_pcie_tx_axi/s_axis_tx_tready
add wave -noupdate /testbench/system_top/inst_pcie_tx_axi/s_axis_tx_tuser
add wave -noupdate /testbench/system_top/inst_pcie_tx_axi/s_axis_tx_tlast
add wave -noupdate /testbench/system_top/inst_pcie_tx_axi/s_axis_tx_tdata
add wave -noupdate -divider {New Divider}
add wave -noupdate /testbench/system_top/DUT/trim_inst/aclk_strm_context_P0
add wave -noupdate /testbench/system_top/DUT/trim_inst/aclk_strm_context_P1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5827224130 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 280
configure wave -valuecolwidth 210
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
WaveRestoreZoom {5827025361 ps} {5827506206 ps}
