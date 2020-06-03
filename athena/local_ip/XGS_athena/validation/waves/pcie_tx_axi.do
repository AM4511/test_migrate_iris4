onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group pcie_tx_axi /testbench/inst_pcie_tx_axi/sys_clk
add wave -noupdate -expand -group pcie_tx_axi /testbench/inst_pcie_tx_axi/sys_reset_n
add wave -noupdate -expand -group pcie_tx_axi /testbench/inst_pcie_tx_axi/cfg_bus_number
add wave -noupdate -expand -group pcie_tx_axi /testbench/inst_pcie_tx_axi/cfg_device_number
add wave -noupdate -expand -group pcie_tx_axi /testbench/inst_pcie_tx_axi/cfg_no_snoop_en
add wave -noupdate -expand -group pcie_tx_axi /testbench/inst_pcie_tx_axi/cfg_relax_ord_en
add wave -noupdate -expand -group pcie_tx_axi -expand -group {TLP I/F} -color {Orange Red} /testbench/inst_pcie_tx_axi/tlp_out_req_to_send
add wave -noupdate -expand -group pcie_tx_axi -expand -group {TLP I/F} -color {Orange Red} /testbench/inst_pcie_tx_axi/tlp_out_grant
add wave -noupdate -expand -group pcie_tx_axi -expand -group {TLP I/F} /testbench/inst_pcie_tx_axi/tlp_out_fmt_type
add wave -noupdate -expand -group pcie_tx_axi -expand -group {TLP I/F} /testbench/inst_pcie_tx_axi/tlp_out_length_in_dw
add wave -noupdate -expand -group pcie_tx_axi -expand -group {TLP I/F} /testbench/inst_pcie_tx_axi/tlp_out_address
add wave -noupdate -expand -group pcie_tx_axi -expand -group {TLP I/F} /testbench/inst_pcie_tx_axi/tlp_out_ldwbe_fdwbe
add wave -noupdate -expand -group pcie_tx_axi -expand -group {TLP I/F} /testbench/inst_pcie_tx_axi/tlp_out_attr
add wave -noupdate -expand -group pcie_tx_axi -expand -group {TLP I/F} /testbench/inst_pcie_tx_axi/tlp_out_transaction_id
add wave -noupdate -expand -group pcie_tx_axi -expand -group {TLP I/F} /testbench/inst_pcie_tx_axi/tlp_out_byte_count
add wave -noupdate -expand -group pcie_tx_axi -expand -group {TLP I/F} /testbench/inst_pcie_tx_axi/tlp_out_lower_address
add wave -noupdate -expand -group pcie_tx_axi -expand -group {TLP I/F} -expand -group {TLP data} -color Magenta /testbench/inst_pcie_tx_axi/tlp_out_src_rdy_n
add wave -noupdate -expand -group pcie_tx_axi -expand -group {TLP I/F} -expand -group {TLP data} -color Magenta /testbench/inst_pcie_tx_axi/tlp_out_dst_rdy_n
add wave -noupdate -expand -group pcie_tx_axi -expand -group {TLP I/F} -expand -group {TLP data} -color Magenta /testbench/inst_pcie_tx_axi/tlp_out_data
add wave -noupdate -expand -group pcie_tx_axi /testbench/inst_pcie_tx_axi/nxt_tlp_tx_state
add wave -noupdate -expand -group pcie_tx_axi /testbench/inst_pcie_tx_axi/tlp_tx_state
add wave -noupdate -expand -group pcie_tx_axi /testbench/inst_pcie_tx_axi/nxt_gnt_id
add wave -noupdate -expand -group pcie_tx_axi /testbench/inst_pcie_tx_axi/gnt_id
add wave -noupdate -expand -group pcie_tx_axi /testbench/inst_pcie_tx_axi/tvalid
add wave -noupdate -expand -group pcie_tx_axi /testbench/inst_pcie_tx_axi/dst_rdy
add wave -noupdate -expand -group pcie_tx_axi /testbench/inst_pcie_tx_axi/new_grant
add wave -noupdate -expand -group pcie_tx_axi /testbench/inst_pcie_tx_axi/fmt_type
add wave -noupdate -expand -group pcie_tx_axi /testbench/inst_pcie_tx_axi/tlp_length
add wave -noupdate -expand -group pcie_tx_axi /testbench/inst_pcie_tx_axi/byte_count
add wave -noupdate -expand -group pcie_tx_axi /testbench/inst_pcie_tx_axi/ldwbe_fdwbe
add wave -noupdate -expand -group pcie_tx_axi /testbench/inst_pcie_tx_axi/transaction_id
add wave -noupdate -expand -group pcie_tx_axi /testbench/inst_pcie_tx_axi/lower_address
add wave -noupdate -expand -group pcie_tx_axi /testbench/inst_pcie_tx_axi/address
add wave -noupdate -expand -group pcie_tx_axi /testbench/inst_pcie_tx_axi/attr
add wave -noupdate -expand -group pcie_tx_axi /testbench/inst_pcie_tx_axi/tlp_out_data_p1
add wave -noupdate -expand -group pcie_tx_axi -expand -group {AXI Stream output I/F} /testbench/inst_pcie_tx_axi/s_axis_tx_tready
add wave -noupdate -expand -group pcie_tx_axi -expand -group {AXI Stream output I/F} /testbench/inst_pcie_tx_axi/s_axis_tx_tdata
add wave -noupdate -expand -group pcie_tx_axi -expand -group {AXI Stream output I/F} /testbench/inst_pcie_tx_axi/s_axis_tx_tkeep
add wave -noupdate -expand -group pcie_tx_axi -expand -group {AXI Stream output I/F} /testbench/inst_pcie_tx_axi/s_axis_tx_tlast
add wave -noupdate -expand -group pcie_tx_axi -expand -group {AXI Stream output I/F} /testbench/inst_pcie_tx_axi/s_axis_tx_tvalid
add wave -noupdate -expand -group pcie_tx_axi -expand -group {AXI Stream output I/F} /testbench/inst_pcie_tx_axi/s_axis_tx_tuser
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3954085406 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 357
configure wave -valuecolwidth 175
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
WaveRestoreZoom {3954001728 ps} {3954199137 ps}
