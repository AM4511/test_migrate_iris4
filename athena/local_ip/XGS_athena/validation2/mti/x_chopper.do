onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group DMAWR2TLP /testbench/system_top/DUT/xdmawr2tlp/tready
add wave -noupdate -expand -group DMAWR2TLP /testbench/system_top/DUT/xdmawr2tlp/tvalid
add wave -noupdate -expand -group DMAWR2TLP /testbench/system_top/DUT/xdmawr2tlp/tdata
add wave -noupdate -expand -group DMAWR2TLP /testbench/system_top/DUT/xdmawr2tlp/tuser
add wave -noupdate -expand -group DMAWR2TLP /testbench/system_top/DUT/xdmawr2tlp/tlast
add wave -noupdate -expand -group x_chopper /testbench/system_top/DUT/inst_x_chopper/aclk_x_size
add wave -noupdate -expand -group x_chopper /testbench/system_top/DUT/inst_x_chopper/aclk_x_start
add wave -noupdate -expand -group x_chopper /testbench/system_top/DUT/inst_x_chopper/aclk_x_stop
add wave -noupdate -expand -group x_chopper /testbench/system_top/DUT/inst_x_chopper/aclk_x_scale
add wave -noupdate -expand -group x_chopper /testbench/system_top/DUT/inst_x_chopper/aclk_x_reverse
add wave -noupdate -expand -group x_chopper /testbench/system_top/DUT/inst_x_chopper/aclk
add wave -noupdate -expand -group x_chopper /testbench/system_top/DUT/inst_x_chopper/aclk_reset_n
add wave -noupdate -expand -group x_chopper -expand -group {Axi Stream input} /testbench/system_top/DUT/inst_x_chopper/aclk_tready
add wave -noupdate -expand -group x_chopper -expand -group {Axi Stream input} /testbench/system_top/DUT/inst_x_chopper/aclk_tvalid
add wave -noupdate -expand -group x_chopper -expand -group {Axi Stream input} /testbench/system_top/DUT/inst_x_chopper/aclk_tuser
add wave -noupdate -expand -group x_chopper -expand -group {Axi Stream input} /testbench/system_top/DUT/inst_x_chopper/aclk_tlast
add wave -noupdate -expand -group x_chopper -expand -group {Axi Stream input} /testbench/system_top/DUT/inst_x_chopper/aclk_tdata
add wave -noupdate -expand -group x_chopper /testbench/system_top/DUT/inst_x_chopper/aclk_reset
add wave -noupdate -expand -group x_chopper -color Cyan /testbench/system_top/DUT/inst_x_chopper/aclk_state
add wave -noupdate -expand -group x_chopper /testbench/system_top/DUT/inst_x_chopper/aclk_buffer_ptr
add wave -noupdate -expand -group x_chopper /testbench/system_top/DUT/inst_x_chopper/aclk_word_ptr
add wave -noupdate -expand -group x_chopper /testbench/system_top/DUT/inst_x_chopper/aclk_full
add wave -noupdate -expand -group x_chopper /testbench/system_top/DUT/inst_x_chopper/aclk_nxt_buffer
add wave -noupdate -expand -group x_chopper /testbench/system_top/DUT/inst_x_chopper/aclk_init_word_ptr
add wave -noupdate -expand -group x_chopper /testbench/system_top/DUT/inst_x_chopper/aclk_write_en
add wave -noupdate -expand -group x_chopper -radix unsigned /testbench/system_top/DUT/inst_x_chopper/aclk_write_address
add wave -noupdate -expand -group x_chopper /testbench/system_top/DUT/inst_x_chopper/aclk_write_data
add wave -noupdate -expand -group x_chopper -expand -group aclk_cmd_fifo /testbench/system_top/DUT/inst_x_chopper/aclk_cmd_full
add wave -noupdate -expand -group x_chopper -expand -group aclk_cmd_fifo -color Gold /testbench/system_top/DUT/inst_x_chopper/aclk_cmd_wen
add wave -noupdate -expand -group x_chopper -expand -group aclk_cmd_fifo /testbench/system_top/DUT/inst_x_chopper/aclk_cmd_sync
add wave -noupdate -expand -group x_chopper -expand -group aclk_cmd_fifo /testbench/system_top/DUT/inst_x_chopper/aclk_cmd_size
add wave -noupdate -expand -group x_chopper -expand -group aclk_cmd_fifo /testbench/system_top/DUT/inst_x_chopper/aclk_cmd_buff_ptr
add wave -noupdate -expand -group x_chopper -expand -group aclk_cmd_fifo /testbench/system_top/DUT/inst_x_chopper/aclk_cmd_data
add wave -noupdate -expand -group x_chopper -expand -group bclk_cmd_fifo -color {Green Yellow} /testbench/system_top/DUT/inst_x_chopper/bclk_cmd_ren
add wave -noupdate -expand -group x_chopper -expand -group bclk_cmd_fifo /testbench/system_top/DUT/inst_x_chopper/bclk_cmd_empty
add wave -noupdate -expand -group x_chopper -expand -group bclk_cmd_fifo /testbench/system_top/DUT/inst_x_chopper/bclk_cmd_data
add wave -noupdate -expand -group x_chopper -expand -group bclk_cmd_fifo /testbench/system_top/DUT/inst_x_chopper/bclk_cmd_sync
add wave -noupdate -expand -group x_chopper -expand -group bclk_cmd_fifo /testbench/system_top/DUT/inst_x_chopper/bclk_cmd_size
add wave -noupdate -expand -group x_chopper -expand -group bclk_cmd_fifo /testbench/system_top/DUT/inst_x_chopper/bclk_cmd_buff_ptr
add wave -noupdate -expand -group x_chopper /testbench/system_top/DUT/inst_x_chopper/bclk
add wave -noupdate -expand -group x_chopper /testbench/system_top/DUT/inst_x_chopper/bclk_reset_n
add wave -noupdate -expand -group x_chopper /testbench/system_top/DUT/inst_x_chopper/bclk_reset
add wave -noupdate -expand -group x_chopper -color {Medium Orchid} /testbench/system_top/DUT/inst_x_chopper/bclk_state
add wave -noupdate -expand -group x_chopper -expand -group bclk_flow_ctrl /testbench/system_top/DUT/inst_x_chopper/bclk_buffer_rdy
add wave -noupdate -expand -group x_chopper -expand -group bclk_flow_ctrl /testbench/system_top/DUT/inst_x_chopper/bclk_transfer_done
add wave -noupdate -expand -group x_chopper -expand -group bclk_flow_ctrl /testbench/system_top/DUT/inst_x_chopper/bclk_empty
add wave -noupdate -expand -group x_chopper -expand -group bclk_flow_ctrl /testbench/system_top/DUT/inst_x_chopper/bclk_full
add wave -noupdate -expand -group x_chopper -expand -group bclk_flow_ctrl /testbench/system_top/DUT/inst_x_chopper/bclk_used_buffer
add wave -noupdate -expand -group x_chopper /testbench/system_top/DUT/inst_x_chopper/bclk_row_cntr
add wave -noupdate -expand -group x_chopper /testbench/system_top/DUT/inst_x_chopper/bclk_read_address
add wave -noupdate -expand -group x_chopper /testbench/system_top/DUT/inst_x_chopper/bclk_read_en
add wave -noupdate -expand -group x_chopper /testbench/system_top/DUT/inst_x_chopper/bclk_read_data
add wave -noupdate -expand -group x_chopper /testbench/system_top/DUT/inst_x_chopper/bclk_init
add wave -noupdate -expand -group x_chopper -expand -group bclk_cntr /testbench/system_top/DUT/inst_x_chopper/bclk_cntr
add wave -noupdate -expand -group x_chopper -expand -group bclk_cntr /testbench/system_top/DUT/inst_x_chopper/bclk_cntr_init
add wave -noupdate -expand -group x_chopper -expand -group bclk_cntr /testbench/system_top/DUT/inst_x_chopper/bclk_cntr_en
add wave -noupdate -expand -group x_chopper -expand -group {Axi Stream output} /testbench/system_top/DUT/inst_x_chopper/bclk_tready
add wave -noupdate -expand -group x_chopper -expand -group {Axi Stream output} /testbench/system_top/DUT/inst_x_chopper/bclk_tvalid
add wave -noupdate -expand -group x_chopper -expand -group {Axi Stream output} /testbench/system_top/DUT/inst_x_chopper/bclk_tuser
add wave -noupdate -expand -group x_chopper -expand -group {Axi Stream output} /testbench/system_top/DUT/inst_x_chopper/bclk_tlast
add wave -noupdate -expand -group x_chopper -expand -group {Axi Stream output} /testbench/system_top/DUT/inst_x_chopper/bclk_tdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1579144000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 202
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
WaveRestoreZoom {0 ps} {136353364 ps}
