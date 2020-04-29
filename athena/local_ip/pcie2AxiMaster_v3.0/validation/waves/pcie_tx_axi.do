onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/dut/xpcie_tx/sys_clk
add wave -noupdate /testbench/dut/xpcie_tx/sys_reset_n
add wave -noupdate -divider {TLP I/F}
add wave -noupdate -expand /testbench/dut/xpcie_tx/tlp_out_req_to_send
add wave -noupdate /testbench/dut/xpcie_tx/tlp_out_req_to_send(2)
add wave -noupdate /testbench/dut/xpcie_tx/tlp_out_req_to_send(1)
add wave -noupdate /testbench/dut/xpcie_tx/tlp_out_req_to_send(0)
add wave -noupdate /testbench/dut/xpcie_tx/tlp_out_grant
add wave -noupdate -expand -subitemconfig {/testbench/dut/xpcie_tx/tlp_out_fmt_type(0) -expand} /testbench/dut/xpcie_tx/tlp_out_fmt_type
add wave -noupdate /testbench/dut/xpcie_tx/tlp_out_length_in_dw
add wave -noupdate -expand /testbench/dut/xpcie_tx/tlp_out_src_rdy_n
add wave -noupdate /testbench/dut/xpcie_tx/tlp_out_src_rdy_n(2)
add wave -noupdate /testbench/dut/xpcie_tx/tlp_out_src_rdy_n(1)
add wave -noupdate /testbench/dut/xpcie_tx/tlp_out_src_rdy_n(0)
add wave -noupdate -expand /testbench/dut/xpcie_tx/tlp_out_dst_rdy_n
add wave -noupdate /testbench/dut/xpcie_tx/tlp_out_dst_rdy_n(2)
add wave -noupdate /testbench/dut/xpcie_tx/tlp_out_dst_rdy_n(1)
add wave -noupdate /testbench/dut/xpcie_tx/tlp_out_dst_rdy_n(0)
add wave -noupdate /testbench/dut/xpcie_tx/tlp_out_data
add wave -noupdate /testbench/dut/xpcie_tx/tlp_out_address
add wave -noupdate /testbench/dut/xpcie_tx/tlp_out_ldwbe_fdwbe
add wave -noupdate /testbench/dut/xpcie_tx/tlp_out_attr
add wave -noupdate /testbench/dut/xpcie_tx/tlp_out_transaction_id
add wave -noupdate /testbench/dut/xpcie_tx/tlp_out_byte_count
add wave -noupdate /testbench/dut/xpcie_tx/tlp_out_lower_address
add wave -noupdate -divider {TLP I/F}
add wave -noupdate /testbench/dut/xpcie_tx/nxt_tlp_tx_state
add wave -noupdate /testbench/dut/xpcie_tx/tlp_tx_state
add wave -noupdate /testbench/dut/xpcie_tx/nxt_gnt_id
add wave -noupdate /testbench/dut/xpcie_tx/gnt_id
add wave -noupdate /testbench/dut/xpcie_tx/tvalid
add wave -noupdate /testbench/dut/xpcie_tx/dst_rdy
add wave -noupdate /testbench/dut/xpcie_tx/new_grant
add wave -noupdate /testbench/dut/xpcie_tx/fmt_type
add wave -noupdate /testbench/dut/xpcie_tx/tlp_length
add wave -noupdate /testbench/dut/xpcie_tx/byte_count
add wave -noupdate /testbench/dut/xpcie_tx/ldwbe_fdwbe
add wave -noupdate /testbench/dut/xpcie_tx/transaction_id
add wave -noupdate /testbench/dut/xpcie_tx/lower_address
add wave -noupdate /testbench/dut/xpcie_tx/address
add wave -noupdate /testbench/dut/xpcie_tx/attr
add wave -noupdate /testbench/dut/xpcie_tx/tlp_out_data_p1
add wave -noupdate -divider PCIE
add wave -noupdate /testbench/dut/xpcie_tx/s_axis_tx_tready
add wave -noupdate /testbench/dut/xpcie_tx/s_axis_tx_tdata
add wave -noupdate /testbench/dut/xpcie_tx/s_axis_tx_tkeep
add wave -noupdate /testbench/dut/xpcie_tx/s_axis_tx_tlast
add wave -noupdate /testbench/dut/xpcie_tx/s_axis_tx_tvalid
add wave -noupdate /testbench/dut/xpcie_tx/s_axis_tx_tuser
add wave -noupdate /testbench/dut/xpcie_tx/cfg_bus_number
add wave -noupdate /testbench/dut/xpcie_tx/cfg_device_number
add wave -noupdate /testbench/dut/xpcie_tx/cfg_no_snoop_en
add wave -noupdate /testbench/dut/xpcie_tx/cfg_relax_ord_en
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {46220216002 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 180
configure wave -valuecolwidth 407
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
configure wave -timelineunits ns
update
WaveRestoreZoom {46015476959 fs} {46230991742 fs}
