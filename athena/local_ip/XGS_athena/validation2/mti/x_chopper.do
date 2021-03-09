onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group x_chopper /testbench/DUT/aclk_reset_n
add wave -noupdate -expand -group x_chopper /testbench/DUT/aclk_reset
add wave -noupdate -expand -group x_chopper -expand -group {Registerfile parameters} /testbench/DUT/aclk_x_size
add wave -noupdate -expand -group x_chopper -expand -group {Registerfile parameters} /testbench/DUT/aclk_x_start
add wave -noupdate -expand -group x_chopper -expand -group {Registerfile parameters} /testbench/DUT/aclk_x_scale
add wave -noupdate -expand -group x_chopper -expand -group {Registerfile parameters} /testbench/DUT/aclk_x_reverse
add wave -noupdate -expand -group x_chopper -expand -group {Axi stream in} /testbench/DUT/aclk_tready_int
add wave -noupdate -expand -group x_chopper -expand -group {Axi stream in} /testbench/DUT/aclk_tready
add wave -noupdate -expand -group x_chopper -expand -group {Axi stream in} /testbench/DUT/aclk_tvalid
add wave -noupdate -expand -group x_chopper -expand -group {Axi stream in} /testbench/DUT/aclk_tlast
add wave -noupdate -expand -group x_chopper -expand -group {Axi stream in} -expand /testbench/DUT/aclk_tuser
add wave -noupdate -expand -group x_chopper -expand -group {Axi stream in} /testbench/DUT/aclk_tdata
add wave -noupdate -expand -group x_chopper -color Magenta /testbench/DUT/aclk_ack
add wave -noupdate -expand -group x_chopper -expand -group {Pixel cntr} /testbench/DUT/aclk_pixel_width
add wave -noupdate -expand -group x_chopper -expand -group {Pixel cntr} -radix decimal /testbench/DUT/aclk_valid_start
add wave -noupdate -expand -group x_chopper -expand -group {Pixel cntr} -radix decimal /testbench/DUT/aclk_valid_stop
add wave -noupdate -expand -group x_chopper -expand -group {Pixel cntr} /testbench/DUT/aclk_pix_incr
add wave -noupdate -expand -group x_chopper -expand -group {Pixel cntr} -radix decimal /testbench/DUT/aclk_pix_cntr
add wave -noupdate -expand -group x_chopper -expand -group {Croping module} /testbench/DUT/aclk_crop_start
add wave -noupdate -expand -group x_chopper -expand -group {Croping module} -radix unsigned /testbench/DUT/aclk_crop_stop
add wave -noupdate -expand -group x_chopper -expand -group {Croping module} -radix decimal /testbench/DUT/aclk_crop_size
add wave -noupdate -expand -group x_chopper -expand -group {Croping module} -color Magenta /testbench/DUT/aclk
add wave -noupdate -expand -group x_chopper -expand -group {Croping module} /testbench/DUT/aclk_crop_window_valid
add wave -noupdate -expand -group x_chopper -expand -group {Croping module} -color Gold -radix binary /testbench/DUT/aclk_crop_packer_valid
add wave -noupdate -expand -group x_chopper -expand -group {Croping module} -color Gold /testbench/DUT/aclk_crop_packer
add wave -noupdate -expand -group x_chopper -expand -group {Croping module} /testbench/DUT/aclk_crop_packer_ben
add wave -noupdate -expand -group x_chopper -expand -group {Croping module} /testbench/DUT/aclk_crop_stop_mask_sel
add wave -noupdate -expand -group x_chopper -expand -group {Croping module} -color {Sky Blue} /testbench/DUT/aclk_crop_mux_sel
add wave -noupdate -expand -group x_chopper -expand -group {Croping module} -color {Sky Blue} /testbench/DUT/aclk_crop_ben_mux
add wave -noupdate -expand -group x_chopper -expand -group {Croping module} -color Pink /testbench/DUT/aclk_crop_data_rdy
add wave -noupdate -expand -group x_chopper -expand -group {Croping module} -color Pink /testbench/DUT/aclk_crop_data_mux
add wave -noupdate -expand -group x_chopper /testbench/DUT/aclk_eof_pndg
add wave -noupdate -expand -group x_chopper -color Orchid /testbench/DUT/aclk_state
add wave -noupdate -expand -group x_chopper /testbench/DUT/aclk_full
add wave -noupdate -expand -group x_chopper -expand -group {Line buffer write} /testbench/DUT/aclk_init_word_ptr
add wave -noupdate -expand -group x_chopper -expand -group {Line buffer write} /testbench/DUT/aclk_word_ptr
add wave -noupdate -expand -group x_chopper -expand -group {Line buffer write} /testbench/DUT/aclk_buffer_ptr
add wave -noupdate -expand -group x_chopper -expand -group {Line buffer write} /testbench/DUT/aclk_init_buffer_ptr
add wave -noupdate -expand -group x_chopper -expand -group {Line buffer write} /testbench/DUT/aclk_nxt_buffer
add wave -noupdate -expand -group x_chopper -expand -group {Line buffer write} -color {Cornflower Blue} /testbench/DUT/aclk_write_en
add wave -noupdate -expand -group x_chopper -expand -group {Line buffer write} -color {Cornflower Blue} /testbench/DUT/aclk_write_address
add wave -noupdate -expand -group x_chopper -expand -group {Line buffer write} -color {Cornflower Blue} /testbench/DUT/aclk_write_data
add wave -noupdate -expand -group x_chopper -group {aclk Cmd FiFo} /testbench/DUT/aclk_cmd_full
add wave -noupdate -expand -group x_chopper -group {aclk Cmd FiFo} /testbench/DUT/aclk_cmd_wen
add wave -noupdate -expand -group x_chopper -group {aclk Cmd FiFo} /testbench/DUT/aclk_cmd_data
add wave -noupdate -expand -group x_chopper -group {aclk Cmd FiFo} /testbench/DUT/aclk_cmd_sync
add wave -noupdate -expand -group x_chopper -group {aclk Cmd FiFo} /testbench/DUT/aclk_cmd_size
add wave -noupdate -expand -group x_chopper -group {aclk Cmd FiFo} /testbench/DUT/aclk_cmd_buff_ptr
add wave -noupdate -expand -group x_chopper -group {bclk Cmd buffer} /testbench/DUT/bclk_cmd_ren
add wave -noupdate -expand -group x_chopper -group {bclk Cmd buffer} /testbench/DUT/bclk_cmd_empty
add wave -noupdate -expand -group x_chopper -group {bclk Cmd buffer} /testbench/DUT/aclk_cmd_sync
add wave -noupdate -expand -group x_chopper -group {bclk Cmd buffer} /testbench/DUT/bclk_cmd_data
add wave -noupdate -expand -group x_chopper -group {bclk Cmd buffer} /testbench/DUT/bclk_cmd_sync
add wave -noupdate -expand -group x_chopper -group {bclk Cmd buffer} /testbench/DUT/bclk_cmd_size
add wave -noupdate -expand -group x_chopper -group {bclk Cmd buffer} /testbench/DUT/bclk_cmd_buff_ptr
add wave -noupdate -expand -group x_chopper /testbench/DUT/bclk_reset
add wave -noupdate -expand -group x_chopper /testbench/DUT/bclk_state
add wave -noupdate -expand -group x_chopper /testbench/DUT/bclk_used_buffer
add wave -noupdate -expand -group x_chopper /testbench/DUT/bclk_transfer_done
add wave -noupdate -expand -group x_chopper /testbench/DUT/bclk_init
add wave -noupdate -expand -group x_chopper /testbench/DUT/bclk_buffer_rdy
add wave -noupdate -expand -group x_chopper /testbench/DUT/bclk_full
add wave -noupdate -expand -group x_chopper /testbench/DUT/bclk_empty
add wave -noupdate -expand -group x_chopper /testbench/DUT/bclk_row_cntr
add wave -noupdate -expand -group x_chopper /testbench/DUT/bclk_x_reverse_Meta
add wave -noupdate -expand -group x_chopper /testbench/DUT/bclk_x_reverse
add wave -noupdate -expand -group x_chopper -group {bclk Cntr} /testbench/DUT/bclk_cntr_init
add wave -noupdate -expand -group x_chopper -group {bclk Cntr} /testbench/DUT/bclk_cntr_en
add wave -noupdate -expand -group x_chopper -group {bclk Cntr} /testbench/DUT/bclk_cntr_treshold
add wave -noupdate -expand -group x_chopper -group {bclk Cntr} /testbench/DUT/bclk_cntr
add wave -noupdate -expand -group x_chopper -expand -group {Line buffer read} -color Magenta /testbench/DUT/bclk_read_en
add wave -noupdate -expand -group x_chopper -expand -group {Line buffer read} /testbench/DUT/bclk_read_address
add wave -noupdate -expand -group x_chopper -expand -group {Line buffer read} /testbench/DUT/bclk_read_data
add wave -noupdate -expand -group x_chopper -group {bclk Reverse packer} /testbench/DUT/bclk_align_packer_en
add wave -noupdate -expand -group x_chopper -group {bclk Reverse packer} /testbench/DUT/bclk_align_packer
add wave -noupdate -expand -group x_chopper -group {bclk Reverse packer} /testbench/DUT/bclk_align_packer_ben
add wave -noupdate -expand -group x_chopper -group {bclk Reverse packer} -expand /testbench/DUT/bclk_align_packer_valid
add wave -noupdate -expand -group x_chopper -group {bclk Reverse packer} /testbench/DUT/bclk_align_mux_sel
add wave -noupdate -expand -group x_chopper -group {bclk Reverse packer} /testbench/DUT/bclk_align_mux
add wave -noupdate -expand -group x_chopper -group {bclk Reverse packer} -color Turquoise /testbench/DUT/bclk_align_data_valid
add wave -noupdate -expand -group x_chopper -group {bclk Reverse packer} /testbench/DUT/bclk_align_data
add wave -noupdate -expand -group x_chopper -expand -group {Axi Stream out} /testbench/DUT/bclk
add wave -noupdate -expand -group x_chopper -expand -group {Axi Stream out} /testbench/DUT/bclk_reset_n
add wave -noupdate -expand -group x_chopper -expand -group {Axi Stream out} /testbench/DUT/bclk_tready
add wave -noupdate -expand -group x_chopper -expand -group {Axi Stream out} /testbench/DUT/bclk_tvalid
add wave -noupdate -expand -group x_chopper -expand -group {Axi Stream out} /testbench/DUT/bclk_tuser
add wave -noupdate -expand -group x_chopper -expand -group {Axi Stream out} /testbench/DUT/bclk_tlast
add wave -noupdate -expand -group x_chopper -expand -group {Axi Stream out} /testbench/DUT/bclk_tdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2688350 ps} 0}
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
WaveRestoreZoom {0 ps} {13902525 ps}
