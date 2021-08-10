onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group x_trim_streamout /testbench/DUT/x_trim_streamout_inst/bclk
add wave -noupdate -expand -group x_trim_streamout /testbench/DUT/x_trim_streamout_inst/bclk_reset
add wave -noupdate -expand -group x_trim_streamout -expand -group {Flow control/Registerfile I/F} /testbench/DUT/x_trim_streamout_inst/bclk_pixel_width
add wave -noupdate -expand -group x_trim_streamout -expand -group {Flow control/Registerfile I/F} /testbench/DUT/x_trim_streamout_inst/bclk_x_reverse
add wave -noupdate -expand -group x_trim_streamout -expand -group {Flow control/Registerfile I/F} /testbench/DUT/x_trim_streamout_inst/bclk_buffer_rdy
add wave -noupdate -expand -group x_trim_streamout -expand -group {Flow control/Registerfile I/F} /testbench/DUT/x_trim_streamout_inst/bclk_full
add wave -noupdate -expand -group x_trim_streamout -expand -group {Command FiFo read I/F} /testbench/DUT/x_trim_streamout_inst/bclk_cmd_empty
add wave -noupdate -expand -group x_trim_streamout -expand -group {Command FiFo read I/F} /testbench/DUT/x_trim_streamout_inst/bclk_cmd_ren
add wave -noupdate -expand -group x_trim_streamout -expand -group {Command FiFo read I/F} /testbench/DUT/x_trim_streamout_inst/bclk_cmd_data
add wave -noupdate -expand -group x_trim_streamout -expand -group {Line buffer read I/F} -color Pink /testbench/DUT/x_trim_streamout_inst/bclk_read_en
add wave -noupdate -expand -group x_trim_streamout -expand -group {Line buffer read I/F} -color Pink /testbench/DUT/x_trim_streamout_inst/bclk_read_address
add wave -noupdate -expand -group x_trim_streamout -expand -group {Line buffer read I/F} -color Pink /testbench/DUT/x_trim_streamout_inst/bclk_read_data_valid
add wave -noupdate -expand -group x_trim_streamout -expand -group {Line buffer read I/F} -color Pink /testbench/DUT/x_trim_streamout_inst/bclk_read_data
add wave -noupdate -expand -group x_trim_streamout /testbench/DUT/x_trim_streamout_inst/bclk_last_read_data
add wave -noupdate -expand -group x_trim_streamout -expand -group FSM -color Cyan /testbench/DUT/x_trim_streamout_inst/bclk_state
add wave -noupdate -expand -group x_trim_streamout -expand -group FSM /testbench/DUT/x_trim_streamout_inst/bclk_word_cntr_treshold
add wave -noupdate -expand -group x_trim_streamout -expand -group FSM /testbench/DUT/x_trim_streamout_inst/bclk_word_cntr
add wave -noupdate -expand -group x_trim_streamout -expand -group FSM /testbench/DUT/x_trim_streamout_inst/bclk_row_cntr
add wave -noupdate -expand -group x_trim_streamout -expand -group FSM /testbench/DUT/x_trim_streamout_inst/bclk_used_buffer
add wave -noupdate -expand -group x_trim_streamout -expand -group FSM /testbench/DUT/x_trim_streamout_inst/bclk_transfer_done
add wave -noupdate -expand -group x_trim_streamout -expand -group {Command fields} -radix binary /testbench/DUT/x_trim_streamout_inst/bclk_cmd_sync
add wave -noupdate -expand -group x_trim_streamout -expand -group {Command fields} /testbench/DUT/x_trim_streamout_inst/bclk_cmd_size
add wave -noupdate -expand -group x_trim_streamout -expand -group {Command fields} /testbench/DUT/x_trim_streamout_inst/bclk_cmd_buff_ptr
add wave -noupdate -expand -group x_trim_streamout -expand -group {Command fields} /testbench/DUT/x_trim_streamout_inst/bclk_cmd_last_ben
add wave -noupdate -expand -group x_trim_streamout -color Magenta /testbench/DUT/x_trim_streamout_inst/bclk_read_en_int
add wave -noupdate -expand -group x_trim_streamout -color Gold /testbench/DUT/x_trim_streamout_inst/bclk_ack
add wave -noupdate -expand -group x_trim_streamout -expand -group {Align packer} -color Gold -radix binary /testbench/DUT/x_trim_streamout_inst/bclk_align_packer_valid_vect
add wave -noupdate -expand -group x_trim_streamout -expand -group {Align packer} -color Gold /testbench/DUT/x_trim_streamout_inst/bclk_align_packer_valid
add wave -noupdate -expand -group x_trim_streamout -expand -group {Align packer} -color Gold /testbench/DUT/x_trim_streamout_inst/bclk_align_packer
add wave -noupdate -expand -group x_trim_streamout -expand -group {Align packer} -color Gold -radix binary /testbench/DUT/x_trim_streamout_inst/bclk_align_packer_user
add wave -noupdate -expand -group x_trim_streamout -expand -group {Last pipeline} -color {Sky Blue} /testbench/DUT/x_trim_streamout_inst/bclk_align_mux_sel
add wave -noupdate -expand -group x_trim_streamout -expand -group {Last pipeline} -color {Sky Blue} /testbench/DUT/x_trim_streamout_inst/bclk_align_mux
add wave -noupdate -expand -group x_trim_streamout -expand -group {Last pipeline} -color {Sky Blue} /testbench/DUT/x_trim_streamout_inst/bclk_tvalid_int
add wave -noupdate -expand -group x_trim_streamout -expand -group {Last pipeline} -color {Sky Blue} /testbench/DUT/x_trim_streamout_inst/bclk_align_user
add wave -noupdate -expand -group x_trim_streamout -expand -group {Last pipeline} -color {Sky Blue} /testbench/DUT/x_trim_streamout_inst/bclk_align_data
add wave -noupdate -expand -group x_trim_streamout -expand -group {Axi streamout I/F} /testbench/DUT/x_trim_streamout_inst/bclk_tready
add wave -noupdate -expand -group x_trim_streamout -expand -group {Axi streamout I/F} /testbench/DUT/x_trim_streamout_inst/bclk_tvalid
add wave -noupdate -expand -group x_trim_streamout -expand -group {Axi streamout I/F} -radix binary /testbench/DUT/x_trim_streamout_inst/bclk_tuser
add wave -noupdate -expand -group x_trim_streamout -expand -group {Axi streamout I/F} /testbench/DUT/x_trim_streamout_inst/bclk_tlast
add wave -noupdate -expand -group x_trim_streamout -expand -group {Axi streamout I/F} /testbench/DUT/x_trim_streamout_inst/bclk_tdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5350696 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 298
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
WaveRestoreZoom {16259705 ps} {16292700 ps}
