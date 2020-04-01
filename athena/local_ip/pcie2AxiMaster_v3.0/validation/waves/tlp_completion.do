onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider tlp_completion
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/sys_clk
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/sys_reset
add wave -noupdate -divider {Completion Interface}
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/compl_req
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/compl_pending
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/compl_fmt_type
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/compl_lower_address
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/compl_length_in_dw
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/compl_length_in_bytes
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/compl_attr
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/compl_transaction_id
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/read_data_valid
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/read_last_data
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/read_data
add wave -noupdate -divider {Completion Interface}
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/state
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/compl_fmt_type_ff
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/compl_lower_address_ff
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/compl_length_in_dw_ff
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/compl_length_in_bytes_ff
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/compl_attr_ff
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/compl_transaction_id_ff
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/compl_dw_cntr
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/qw_packer_valid
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/qw_packer
add wave -noupdate -divider {write fifo I/F}
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/fifo_full
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/fifo_wren
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/fifo_din
add wave -noupdate -divider {read fifo I/F}
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/fifo_empty
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/fifo_usedw
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/fifo_rden
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/fifo_dout
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/fifo_und
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/fifo_ovr
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/tlp_dw_cntr
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/tlp_cntr
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/tlp_ack
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/tlp_lower_address
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/tlp_src_rdy
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/bytes_count
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/first_dw_byte_cnt
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/last_dw_byte_cnt
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/compl_byte_cntr
add wave -noupdate -divider {Completion Interface}
add wave -noupdate -label {TLP request} /testbench/dut/xtlp_to_axi_master/xtlp_completion/tlp_out_req_to_send
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/tlp_out_grant
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/tlp_out_attr
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/tlp_out_transaction_id
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/tlp_out_byte_count
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/tlp_out_lower_address
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/tlp_out_fmt_type
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/tlp_out_length_in_dw
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/tlp_out_src_rdy_n
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/tlp_out_dst_rdy_n
add wave -noupdate /testbench/dut/xtlp_to_axi_master/xtlp_completion/tlp_out_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {46279894036 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 269
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
configure wave -timelineunits ns
update
WaveRestoreZoom {46192607226 fs} {46345156151 fs}
