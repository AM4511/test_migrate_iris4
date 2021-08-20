onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group x_trim -group {Registerfile I/F} /testbench/DUT/x_trim_inst/aclk_pixel_width
add wave -noupdate -expand -group x_trim -group {Registerfile I/F} /testbench/DUT/x_trim_inst/aclk_x_crop_en
add wave -noupdate -expand -group x_trim -group {Registerfile I/F} /testbench/DUT/x_trim_inst/aclk_x_start
add wave -noupdate -expand -group x_trim -group {Registerfile I/F} /testbench/DUT/x_trim_inst/aclk_x_size
add wave -noupdate -expand -group x_trim -group {Registerfile I/F} /testbench/DUT/x_trim_inst/aclk_x_scale
add wave -noupdate -expand -group x_trim -group {Registerfile I/F} /testbench/DUT/x_trim_inst/aclk_x_reverse
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk
add wave -noupdate -expand -group x_trim -expand -group {Stream Input I/F} /testbench/DUT/x_trim_inst/aclk_tready
add wave -noupdate -expand -group x_trim -expand -group {Stream Input I/F} /testbench/DUT/x_trim_inst/aclk_tvalid
add wave -noupdate -expand -group x_trim -expand -group {Stream Input I/F} /testbench/DUT/x_trim_inst/aclk_tuser
add wave -noupdate -expand -group x_trim -expand -group {Stream Input I/F} /testbench/DUT/x_trim_inst/aclk_tlast
add wave -noupdate -expand -group x_trim -expand -group {Stream Input I/F} /testbench/DUT/x_trim_inst/aclk_tdata
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_reset
add wave -noupdate -expand -group x_trim -color {Medium Orchid} /testbench/DUT/x_trim_inst/aclk_state
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_full
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_tready_int
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_init_word_ptr
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_word_ptr
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_buffer_ptr
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_init_buffer_ptr
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_init_subsampling
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_nxt_buffer
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_write_en
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_write_address
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_write_data
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_cmd_wen
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_cmd_full
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_cmd_data
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_cmd_sync
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_cmd_size
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_cmd_buff_ptr
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_cmd_last_ben
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_ack
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_pix_cntr
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_pix_incr
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_valid_start
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_valid_stop
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_crop_start
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_crop_stop
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_crop_size
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_crop_stop_mask_sel
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_crop_data_rdy
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_crop_window_valid
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_crop_packer
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_crop_packer_ben
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_crop_data_mux
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_crop_last_data_mux
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_crop_ben_mux
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_crop_mux_sel
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_crop_packer_valid
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_subs_empty
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_subs_data_valid
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_subs_last_data
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_subs_data
add wave -noupdate -expand -group x_trim /testbench/DUT/x_trim_inst/aclk_subs_ben
add wave -noupdate -expand -group x_trim -group bclk_domain /testbench/DUT/x_trim_inst/bclk
add wave -noupdate -expand -group x_trim -group bclk_domain /testbench/DUT/x_trim_inst/bclk_reset_n
add wave -noupdate -expand -group x_trim -group bclk_domain /testbench/DUT/x_trim_inst/bclk_x_reverse_Meta
add wave -noupdate -expand -group x_trim -group bclk_domain /testbench/DUT/x_trim_inst/bclk_x_reverse
add wave -noupdate -expand -group x_trim -group bclk_domain /testbench/DUT/x_trim_inst/bclk_pixel_width
add wave -noupdate -expand -group x_trim -group bclk_domain /testbench/DUT/x_trim_inst/bclk_reset
add wave -noupdate -expand -group x_trim -group bclk_domain /testbench/DUT/x_trim_inst/bclk_full
add wave -noupdate -expand -group x_trim -group bclk_domain /testbench/DUT/x_trim_inst/bclk_row_cntr
add wave -noupdate -expand -group x_trim -group bclk_domain /testbench/DUT/x_trim_inst/bclk_read_address
add wave -noupdate -expand -group x_trim -group bclk_domain /testbench/DUT/x_trim_inst/bclk_read_en
add wave -noupdate -expand -group x_trim -group bclk_domain /testbench/DUT/x_trim_inst/bclk_read_data
add wave -noupdate -expand -group x_trim -group bclk_domain /testbench/DUT/x_trim_inst/bclk_used_buffer
add wave -noupdate -expand -group x_trim -group bclk_domain /testbench/DUT/x_trim_inst/bclk_transfer_done
add wave -noupdate -expand -group x_trim -group bclk_domain /testbench/DUT/x_trim_inst/bclk_init
add wave -noupdate -expand -group x_trim -group bclk_domain /testbench/DUT/x_trim_inst/bclk_buffer_rdy
add wave -noupdate -expand -group x_trim -group bclk_domain /testbench/DUT/x_trim_inst/bclk_cmd_ren
add wave -noupdate -expand -group x_trim -group bclk_domain /testbench/DUT/x_trim_inst/bclk_cmd_data
add wave -noupdate -expand -group x_trim -group bclk_domain /testbench/DUT/x_trim_inst/bclk_cmd_empty
add wave -noupdate -expand -group x_trim -group {Stream output I/F} /testbench/DUT/x_trim_inst/bclk_tready
add wave -noupdate -expand -group x_trim -group {Stream output I/F} /testbench/DUT/x_trim_inst/bclk_tvalid
add wave -noupdate -expand -group x_trim -group {Stream output I/F} /testbench/DUT/x_trim_inst/bclk_tuser
add wave -noupdate -expand -group x_trim -group {Stream output I/F} /testbench/DUT/x_trim_inst/bclk_tlast
add wave -noupdate -expand -group x_trim -group {Stream output I/F} /testbench/DUT/x_trim_inst/bclk_tdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2057241 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 223
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
WaveRestoreZoom {0 ps} {18968250 ps}
