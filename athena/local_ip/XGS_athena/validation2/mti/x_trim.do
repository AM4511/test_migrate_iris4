onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group x_trim /testbench/DUT/aclk
add wave -noupdate -expand -group x_trim /testbench/DUT/aclk_reset_n
add wave -noupdate -expand -group x_trim -group registerfile /testbench/DUT/aclk_x_start
add wave -noupdate -expand -group x_trim -group registerfile /testbench/DUT/aclk_x_size
add wave -noupdate -expand -group x_trim -group registerfile /testbench/DUT/aclk_x_scale
add wave -noupdate -expand -group x_trim -group registerfile /testbench/DUT/aclk_x_reverse
add wave -noupdate -expand -group x_trim -expand -group {Axi Stream input} /testbench/DUT/aclk_tready
add wave -noupdate -expand -group x_trim -expand -group {Axi Stream input} /testbench/DUT/aclk_tvalid
add wave -noupdate -expand -group x_trim -expand -group {Axi Stream input} /testbench/DUT/aclk_tuser
add wave -noupdate -expand -group x_trim -expand -group {Axi Stream input} /testbench/DUT/aclk_tlast
add wave -noupdate -expand -group x_trim -expand -group {Axi Stream input} /testbench/DUT/aclk_tdata
add wave -noupdate -expand -group x_trim /testbench/DUT/aclk_pixel_width
add wave -noupdate -expand -group x_trim /testbench/DUT/aclk_reset
add wave -noupdate -expand -group x_trim /testbench/DUT/aclk_state
add wave -noupdate -expand -group x_trim /testbench/DUT/aclk_full
add wave -noupdate -expand -group x_trim /testbench/DUT/aclk_tready_int
add wave -noupdate -expand -group x_trim /testbench/DUT/aclk_init_word_ptr
add wave -noupdate -expand -group x_trim /testbench/DUT/aclk_word_ptr
add wave -noupdate -expand -group x_trim /testbench/DUT/aclk_buffer_ptr
add wave -noupdate -expand -group x_trim /testbench/DUT/aclk_init_buffer_ptr
add wave -noupdate -expand -group x_trim /testbench/DUT/aclk_nxt_buffer
add wave -noupdate -expand -group x_trim /testbench/DUT/aclk_last_data_in
add wave -noupdate -expand -group x_trim -expand -group {subsampling out} /testbench/DUT/aclk_subs_data_valid
add wave -noupdate -expand -group x_trim -expand -group {subsampling out} /testbench/DUT/aclk_subs_last_data
add wave -noupdate -expand -group x_trim -expand -group {subsampling out} /testbench/DUT/aclk_subs_data
add wave -noupdate -expand -group x_trim -expand -group {subsampling out} /testbench/DUT/aclk_subs_ben
add wave -noupdate -expand -group x_trim -color Cyan /testbench/DUT/aclk_write_en
add wave -noupdate -expand -group x_trim /testbench/DUT/aclk_write_address
add wave -noupdate -expand -group x_trim /testbench/DUT/aclk_write_data
add wave -noupdate -expand -group x_trim -group {Command FiFo (write I/F)} /testbench/DUT/aclk_cmd_wen
add wave -noupdate -expand -group x_trim -group {Command FiFo (write I/F)} /testbench/DUT/aclk_cmd_full
add wave -noupdate -expand -group x_trim -group {Command FiFo (write I/F)} /testbench/DUT/aclk_cmd_data
add wave -noupdate -expand -group x_trim -group {Command FiFo (write I/F)} /testbench/DUT/aclk_cmd_sync
add wave -noupdate -expand -group x_trim -group {Command FiFo (write I/F)} /testbench/DUT/aclk_cmd_size
add wave -noupdate -expand -group x_trim -group {Command FiFo (write I/F)} /testbench/DUT/aclk_cmd_buff_ptr
add wave -noupdate -expand -group x_trim -group {Command FiFo (write I/F)} /testbench/DUT/aclk_cmd_last_ben
add wave -noupdate -expand -group x_trim /testbench/DUT/aclk_ack
add wave -noupdate -expand -group x_trim /testbench/DUT/aclk_pix_cntr
add wave -noupdate -expand -group x_trim /testbench/DUT/aclk_pix_incr
add wave -noupdate -expand -group x_trim /testbench/DUT/aclk_valid_start
add wave -noupdate -expand -group x_trim /testbench/DUT/aclk_valid_stop
add wave -noupdate -expand -group x_trim /testbench/DUT/aclk_eof_pndg
add wave -noupdate -expand -group x_trim -expand -group {Cropping packer} /testbench/DUT/aclk_crop_start
add wave -noupdate -expand -group x_trim -expand -group {Cropping packer} /testbench/DUT/aclk_crop_stop
add wave -noupdate -expand -group x_trim -expand -group {Cropping packer} /testbench/DUT/aclk_crop_size
add wave -noupdate -expand -group x_trim -expand -group {Cropping packer} /testbench/DUT/aclk_crop_stop_mask_sel
add wave -noupdate -expand -group x_trim -expand -group {Cropping packer} /testbench/DUT/aclk_crop_data_rdy
add wave -noupdate -expand -group x_trim -expand -group {Cropping packer} /testbench/DUT/aclk_crop_window_valid
add wave -noupdate -expand -group x_trim -expand -group {Cropping packer} /testbench/DUT/aclk_crop_packer
add wave -noupdate -expand -group x_trim -expand -group {Cropping packer} /testbench/DUT/aclk_crop_packer_ben
add wave -noupdate -expand -group x_trim -expand -group {Cropping packer} /testbench/DUT/aclk_crop_data_mux
add wave -noupdate -expand -group x_trim -expand -group {Cropping packer} /testbench/DUT/aclk_crop_ben_mux
add wave -noupdate -expand -group x_trim -expand -group {Cropping packer} /testbench/DUT/aclk_crop_mux_sel
add wave -noupdate -expand -group x_trim -expand -group {Cropping packer} /testbench/DUT/aclk_crop_packer_valid
add wave -noupdate -expand -group x_trim /testbench/DUT/bclk_pixel_width
add wave -noupdate -expand -group x_trim /testbench/DUT/bclk_x_reverse_Meta
add wave -noupdate -expand -group x_trim /testbench/DUT/bclk_x_reverse
add wave -noupdate -expand -group x_trim /testbench/DUT/bclk_reset
add wave -noupdate -expand -group x_trim /testbench/DUT/bclk_full
add wave -noupdate -expand -group x_trim /testbench/DUT/bclk_empty
add wave -noupdate -expand -group x_trim /testbench/DUT/bclk_row_cntr
add wave -noupdate -expand -group x_trim /testbench/DUT/bclk_read_address
add wave -noupdate -expand -group x_trim /testbench/DUT/bclk_read_en
add wave -noupdate -expand -group x_trim /testbench/DUT/bclk_read_data
add wave -noupdate -expand -group x_trim /testbench/DUT/bclk_used_buffer
add wave -noupdate -expand -group x_trim /testbench/DUT/bclk_transfer_done
add wave -noupdate -expand -group x_trim /testbench/DUT/bclk_init
add wave -noupdate -expand -group x_trim /testbench/DUT/bclk_buffer_rdy
add wave -noupdate -expand -group x_trim -group {Command FiFo (read I/F)} /testbench/DUT/bclk_cmd_ren
add wave -noupdate -expand -group x_trim -group {Command FiFo (read I/F)} /testbench/DUT/bclk_cmd_empty
add wave -noupdate -expand -group x_trim -group {Command FiFo (read I/F)} /testbench/DUT/bclk_cmd_data
add wave -noupdate -expand -group x_trim -group {Command FiFo (read I/F)} /testbench/DUT/bclk_cmd_sync
add wave -noupdate -expand -group x_trim -group {Command FiFo (read I/F)} /testbench/DUT/bclk_cmd_size
add wave -noupdate -expand -group x_trim -group {Command FiFo (read I/F)} /testbench/DUT/bclk_cmd_last_ben
add wave -noupdate -expand -group x_trim -group {Command FiFo (read I/F)} /testbench/DUT/bclk_cmd_buff_ptr
add wave -noupdate -expand -group x_trim -group {AXI stream output} /testbench/DUT/bclk
add wave -noupdate -expand -group x_trim -group {AXI stream output} /testbench/DUT/bclk_reset_n
add wave -noupdate -expand -group x_trim -group {AXI stream output} /testbench/DUT/bclk_tready
add wave -noupdate -expand -group x_trim -group {AXI stream output} /testbench/DUT/bclk_tvalid
add wave -noupdate -expand -group x_trim -group {AXI stream output} /testbench/DUT/bclk_tuser
add wave -noupdate -expand -group x_trim -group {AXI stream output} /testbench/DUT/bclk_tlast
add wave -noupdate -expand -group x_trim -group {AXI stream output} /testbench/DUT/bclk_tdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2323056 ps} 0}
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
WaveRestoreZoom {2271217 ps} {2523691 ps}
