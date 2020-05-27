onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {line buffer} /testbench/DUT/x_xgs_hispi_top/xline_buffer/sysclk
add wave -noupdate -expand -group {line buffer} /testbench/DUT/x_xgs_hispi_top/xline_buffer/sysrst
add wave -noupdate -expand -group {line buffer} /testbench/DUT/x_xgs_hispi_top/xline_buffer/buffer_enable
add wave -noupdate -expand -group {line buffer} /testbench/DUT/x_xgs_hispi_top/xline_buffer/init_frame
add wave -noupdate -expand -group {line buffer} -expand -group {Input I/F} /testbench/DUT/x_xgs_hispi_top/xline_buffer/nxtBuffer
add wave -noupdate -expand -group {line buffer} -expand -group {Input I/F} /testbench/DUT/x_xgs_hispi_top/xline_buffer/lane_packer_req
add wave -noupdate -expand -group {line buffer} -expand -group {Input I/F} /testbench/DUT/x_xgs_hispi_top/xline_buffer/lane_packer_ack
add wave -noupdate -expand -group {line buffer} -expand -group {Input I/F} -radix unsigned /testbench/DUT/x_xgs_hispi_top/xline_buffer/row_id
add wave -noupdate -expand -group {line buffer} -expand -group {Input I/F} /testbench/DUT/x_xgs_hispi_top/xline_buffer/buff_write
add wave -noupdate -expand -group {line buffer} -expand -group {Input I/F} /testbench/DUT/x_xgs_hispi_top/xline_buffer/buff_addr
add wave -noupdate -expand -group {line buffer} -expand -group {Input I/F} /testbench/DUT/x_xgs_hispi_top/xline_buffer/buff_data
add wave -noupdate -expand -group {line buffer} /testbench/DUT/x_xgs_hispi_top/xline_buffer/sysrst_n
add wave -noupdate -expand -group {line buffer} /testbench/DUT/x_xgs_hispi_top/xline_buffer/lane_grant
add wave -noupdate -expand -group {line buffer} /testbench/DUT/x_xgs_hispi_top/xline_buffer/write_buffer_ptr
add wave -noupdate -expand -group {line buffer} /testbench/DUT/x_xgs_hispi_top/xline_buffer/pixel_id
add wave -noupdate -expand -group {line buffer} -expand /testbench/DUT/x_xgs_hispi_top/xline_buffer/buffer_row_id
add wave -noupdate -expand -group {line buffer} /testbench/DUT/x_xgs_hispi_top/xline_buffer/buffer_row_info
add wave -noupdate -expand -group {line buffer} /testbench/DUT/x_xgs_hispi_top/xline_buffer/buffer_write_en
add wave -noupdate -expand -group {line buffer} /testbench/DUT/x_xgs_hispi_top/xline_buffer/buffer_write_address
add wave -noupdate -expand -group {line buffer} /testbench/DUT/x_xgs_hispi_top/xline_buffer/buffer_write_data
add wave -noupdate -expand -group {line buffer} /testbench/DUT/x_xgs_hispi_top/xline_buffer/buffer_read_address
add wave -noupdate -expand -group {line buffer} /testbench/DUT/x_xgs_hispi_top/xline_buffer/nxtBuffer_ff
add wave -noupdate -expand -group {line buffer} -group {Output I/F} -expand /testbench/DUT/x_xgs_hispi_top/xline_buffer/clrBuffer
add wave -noupdate -expand -group {line buffer} -group {Output I/F} /testbench/DUT/x_xgs_hispi_top/xline_buffer/line_buffer_ready
add wave -noupdate -expand -group {line buffer} -group {Output I/F} /testbench/DUT/x_xgs_hispi_top/xline_buffer/line_buffer_read
add wave -noupdate -expand -group {line buffer} -group {Output I/F} /testbench/DUT/x_xgs_hispi_top/xline_buffer/line_buffer_ptr
add wave -noupdate -expand -group {line buffer} -group {Output I/F} /testbench/DUT/x_xgs_hispi_top/xline_buffer/line_buffer_address
add wave -noupdate -expand -group {line buffer} -group {Output I/F} -radix unsigned /testbench/DUT/x_xgs_hispi_top/xline_buffer/line_buffer_row_id
add wave -noupdate -expand -group {line buffer} -group {Output I/F} /testbench/DUT/x_xgs_hispi_top/xline_buffer/line_buffer_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {14795501 ps} 0} {{Cursor 2} {1114986228 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 257
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
WaveRestoreZoom {0 ps} {2953097583 ps}
