onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {PCIe RX}
add wave -noupdate /testbench/dut/xpcie_rx/sys_reset_n
add wave -noupdate /testbench/dut/xpcie_rx/user_lnk_up
add wave -noupdate -divider {PCIe Xilinx IP Core I/F}
add wave -noupdate /testbench/dut/xpcie_rx/m_axis_rx_tvalid
add wave -noupdate /testbench/dut/xpcie_rx/m_axis_rx_tready
add wave -noupdate /testbench/dut/xpcie_rx/m_axis_rx_tlast
add wave -noupdate /testbench/dut/xpcie_rx/m_axis_rx_tdata
add wave -noupdate /testbench/dut/xpcie_rx/m_axis_rx_tkeep
add wave -noupdate /testbench/dut/xpcie_rx/m_axis_rx_tuser
add wave -noupdate /testbench/dut/xpcie_rx/rx_np_ok
add wave -noupdate /testbench/dut/xpcie_rx/rx_np_req
add wave -noupdate /testbench/dut/xpcie_rx/nxt_count_data
add wave -noupdate /testbench/dut/xpcie_rx/count_data
add wave -noupdate -divider {TLP IN I/F}
add wave -noupdate -expand -subitemconfig {/testbench/dut/xpcie_rx/tlp_in_valid(0) {-color Cyan -height 15}} /testbench/dut/xpcie_rx/tlp_in_valid
add wave -noupdate /testbench/dut/xpcie_rx/sys_clk
add wave -noupdate -expand -subitemconfig {/testbench/dut/xpcie_rx/tlp_in_accept_data(0) {-color {Blue Violet} -height 15}} /testbench/dut/xpcie_rx/tlp_in_accept_data
add wave -noupdate -color Cyan /testbench/dut/xpcie_rx/tlp_in_valid(0)
add wave -noupdate /testbench/dut/xpcie_rx/tlp_in_abort
add wave -noupdate /testbench/dut/xpcie_rx/tlp_in_fmt_type
add wave -noupdate /testbench/dut/xpcie_rx/tlp_in_address
add wave -noupdate /testbench/dut/xpcie_rx/tlp_in_length_in_dw
add wave -noupdate /testbench/dut/xpcie_rx/tlp_in_attr
add wave -noupdate /testbench/dut/xpcie_rx/tlp_in_transaction_id
add wave -noupdate /testbench/dut/xpcie_rx/tlp_in_data
add wave -noupdate /testbench/dut/xpcie_rx/tlp_in_byte_en
add wave -noupdate /testbench/dut/xpcie_rx/tlp_in_byte_count
add wave -noupdate -divider {Configuration I/F}
add wave -noupdate /testbench/dut/xpcie_rx/cfg_err_cpl_unexpect
add wave -noupdate /testbench/dut/xpcie_rx/cfg_err_posted
add wave -noupdate /testbench/dut/xpcie_rx/cfg_err_malformed
add wave -noupdate /testbench/dut/xpcie_rx/cfg_err_ur
add wave -noupdate /testbench/dut/xpcie_rx/cfg_err_cpl_abort
add wave -noupdate /testbench/dut/xpcie_rx/cfg_err_tlp_cpl_header
add wave -noupdate /testbench/dut/xpcie_rx/cfg_err_cpl_rdy
add wave -noupdate /testbench/dut/xpcie_rx/cfg_err_locked
add wave -noupdate -divider {TLP Rx FSM}
add wave -noupdate /testbench/dut/xpcie_rx/nxt_tlp_rx_state
add wave -noupdate /testbench/dut/xpcie_rx/tlp_rx_state
add wave -noupdate /testbench/dut/xpcie_rx/nxt_head_fmt
add wave -noupdate /testbench/dut/xpcie_rx/head_fmt
add wave -noupdate /testbench/dut/xpcie_rx/nxt_head_type
add wave -noupdate /testbench/dut/xpcie_rx/head_type
add wave -noupdate /testbench/dut/xpcie_rx/nxt_head_ep
add wave -noupdate /testbench/dut/xpcie_rx/head_ep
add wave -noupdate /testbench/dut/xpcie_rx/nxt_head_attr
add wave -noupdate /testbench/dut/xpcie_rx/head_attr
add wave -noupdate /testbench/dut/xpcie_rx/nxt_head_length
add wave -noupdate /testbench/dut/xpcie_rx/head_length
add wave -noupdate /testbench/dut/xpcie_rx/nxt_head_req_id
add wave -noupdate /testbench/dut/xpcie_rx/head_req_id
add wave -noupdate /testbench/dut/xpcie_rx/nxt_head_tag
add wave -noupdate /testbench/dut/xpcie_rx/head_tag
add wave -noupdate /testbench/dut/xpcie_rx/nxt_head_fdwbe
add wave -noupdate /testbench/dut/xpcie_rx/head_fdwbe
add wave -noupdate /testbench/dut/xpcie_rx/nxt_head_ldwbe
add wave -noupdate /testbench/dut/xpcie_rx/head_ldwbe
add wave -noupdate /testbench/dut/xpcie_rx/nxt_byte_cnt
add wave -noupdate /testbench/dut/xpcie_rx/byte_cnt
add wave -noupdate /testbench/dut/xpcie_rx/nxt_lower_add
add wave -noupdate /testbench/dut/xpcie_rx/lower_add
add wave -noupdate /testbench/dut/xpcie_rx/current_agent
add wave -noupdate /testbench/dut/xpcie_rx/wait_acknowledge
add wave -noupdate /testbench/dut/xpcie_rx/dropped_tlp
add wave -noupdate /testbench/dut/xpcie_rx/packet_started
add wave -noupdate /testbench/dut/xpcie_rx/tready
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {47341594085 fs} 0}
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
configure wave -timeline 1
configure wave -timelineunits ms
update
WaveRestoreZoom {45103831293 fs} {48374421799 fs}
