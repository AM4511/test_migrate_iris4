onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group x_trim_streamout /testbench/DUT/inst_x_trim_streamout/bclk
add wave -noupdate -expand -group x_trim_streamout /testbench/DUT/inst_x_trim_streamout/bclk_reset
add wave -noupdate -expand -group x_trim_streamout /testbench/DUT/inst_x_trim_streamout/bclk_x_reverse
add wave -noupdate -expand -group x_trim_streamout /testbench/DUT/inst_x_trim_streamout/bclk_buffer_rdy
add wave -noupdate -expand -group x_trim_streamout /testbench/DUT/inst_x_trim_streamout/bclk_full
add wave -noupdate -expand -group x_trim_streamout -expand -group {cmd FiFo I/F} /testbench/DUT/inst_x_trim_streamout/bclk_cmd_empty
add wave -noupdate -expand -group x_trim_streamout -expand -group {cmd FiFo I/F} /testbench/DUT/inst_x_trim_streamout/bclk_cmd_ren
add wave -noupdate -expand -group x_trim_streamout -expand -group {cmd FiFo I/F} /testbench/DUT/inst_x_trim_streamout/bclk_cmd_data
add wave -noupdate -expand -group x_trim_streamout -expand -group {Line buffer FiFo} /testbench/DUT/inst_x_trim_streamout/bclk_read_en
add wave -noupdate -expand -group x_trim_streamout -expand -group {Line buffer FiFo} /testbench/DUT/inst_x_trim_streamout/bclk_read_address
add wave -noupdate -expand -group x_trim_streamout -expand -group {Line buffer FiFo} /testbench/DUT/inst_x_trim_streamout/bclk_read_data
add wave -noupdate -expand -group x_trim_streamout /testbench/DUT/inst_x_trim_streamout/bclk_pixel_width
add wave -noupdate -expand -group x_trim_streamout /testbench/DUT/inst_x_trim_streamout/bclk_read_en_int
add wave -noupdate -expand -group x_trim_streamout -color Cyan /testbench/DUT/inst_x_trim_streamout/bclk_state
add wave -noupdate -expand -group x_trim_streamout /testbench/DUT/inst_x_trim_streamout/bclk_init
add wave -noupdate -expand -group x_trim_streamout /testbench/DUT/inst_x_trim_streamout/bclk_row_cntr
add wave -noupdate -expand -group x_trim_streamout /testbench/DUT/inst_x_trim_streamout/bclk_used_buffer
add wave -noupdate -expand -group x_trim_streamout /testbench/DUT/inst_x_trim_streamout/bclk_transfer_done
add wave -noupdate -expand -group x_trim_streamout /testbench/DUT/inst_x_trim_streamout/bclk_cmd_sync
add wave -noupdate -expand -group x_trim_streamout /testbench/DUT/inst_x_trim_streamout/bclk_cmd_size
add wave -noupdate -expand -group x_trim_streamout /testbench/DUT/inst_x_trim_streamout/bclk_cmd_buff_ptr
add wave -noupdate -expand -group x_trim_streamout /testbench/DUT/inst_x_trim_streamout/bclk_cmd_last_ben
add wave -noupdate -expand -group x_trim_streamout /testbench/DUT/inst_x_trim_streamout/bclk_cntr
add wave -noupdate -expand -group x_trim_streamout /testbench/DUT/inst_x_trim_streamout/bclk_cntr_treshold
add wave -noupdate -expand -group x_trim_streamout /testbench/DUT/inst_x_trim_streamout/bclk_cntr_init
add wave -noupdate -expand -group x_trim_streamout /testbench/DUT/inst_x_trim_streamout/bclk_cntr_en
add wave -noupdate -expand -group x_trim_streamout /testbench/DUT/inst_x_trim_streamout/bclk_ack
add wave -noupdate -expand -group x_trim_streamout /testbench/DUT/inst_x_trim_streamout/bclk_tvalid_int
add wave -noupdate -expand -group x_trim_streamout /testbench/DUT/inst_x_trim_streamout/bclk_align_packer_en
add wave -noupdate -expand -group x_trim_streamout /testbench/DUT/inst_x_trim_streamout/bclk_align_packer
add wave -noupdate -expand -group x_trim_streamout /testbench/DUT/inst_x_trim_streamout/bclk_align_packer_ben
add wave -noupdate -expand -group x_trim_streamout /testbench/DUT/inst_x_trim_streamout/bclk_align_packer_valid
add wave -noupdate -expand -group x_trim_streamout /testbench/DUT/inst_x_trim_streamout/bclk_align_mux_sel
add wave -noupdate -expand -group x_trim_streamout /testbench/DUT/inst_x_trim_streamout/bclk_align_mux
add wave -noupdate -expand -group x_trim_streamout /testbench/DUT/inst_x_trim_streamout/bclk_align_data
add wave -noupdate -expand -group x_trim_streamout /testbench/DUT/inst_x_trim_streamout/bclk_align_data_valid
add wave -noupdate -expand -group x_trim_streamout /testbench/DUT/inst_x_trim_streamout/bclk_align_packer_user
add wave -noupdate -expand -group x_trim_streamout /testbench/DUT/inst_x_trim_streamout/bclk_align_user
add wave -noupdate -expand -group x_trim_streamout -expand -group {Axi streamout} /testbench/DUT/inst_x_trim_streamout/bclk_tready
add wave -noupdate -expand -group x_trim_streamout -expand -group {Axi streamout} /testbench/DUT/inst_x_trim_streamout/bclk_tvalid
add wave -noupdate -expand -group x_trim_streamout -expand -group {Axi streamout} /testbench/DUT/inst_x_trim_streamout/bclk_tuser
add wave -noupdate -expand -group x_trim_streamout -expand -group {Axi streamout} /testbench/DUT/inst_x_trim_streamout/bclk_tlast
add wave -noupdate -expand -group x_trim_streamout -expand -group {Axi streamout} /testbench/DUT/inst_x_trim_streamout/bclk_tdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4255336 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 210
configure wave -valuecolwidth 233
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
WaveRestoreZoom {0 ps} {18818625 ps}
