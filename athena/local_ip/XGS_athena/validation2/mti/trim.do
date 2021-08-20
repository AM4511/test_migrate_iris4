onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group trim -group {Registerfile Fields} /testbench/DUT/aclk_grab_queue_en
add wave -noupdate -expand -group trim -group {Registerfile Fields} /testbench/DUT/aclk_load_context
add wave -noupdate -expand -group trim -group {Registerfile Fields} /testbench/DUT/aclk_pixel_width
add wave -noupdate -expand -group trim -group {Registerfile Fields} /testbench/DUT/aclk_x_crop_en
add wave -noupdate -expand -group trim -group {Registerfile Fields} /testbench/DUT/aclk_x_start
add wave -noupdate -expand -group trim -group {Registerfile Fields} /testbench/DUT/aclk_x_size
add wave -noupdate -expand -group trim -group {Registerfile Fields} /testbench/DUT/aclk_x_scale
add wave -noupdate -expand -group trim -group {Registerfile Fields} /testbench/DUT/aclk_x_reverse
add wave -noupdate -expand -group trim -group {Registerfile Fields} /testbench/DUT/aclk_y_start
add wave -noupdate -expand -group trim -group {Registerfile Fields} /testbench/DUT/aclk_y_size
add wave -noupdate -expand -group trim /testbench/DUT/aclk
add wave -noupdate -expand -group trim /testbench/DUT/aclk_reset_n
add wave -noupdate -expand -group trim /testbench/DUT/aclk_reset
add wave -noupdate -expand -group trim -expand -group {Stream input I/F} /testbench/DUT/aclk_tready
add wave -noupdate -expand -group trim -expand -group {Stream input I/F} /testbench/DUT/aclk_tvalid
add wave -noupdate -expand -group trim -expand -group {Stream input I/F} /testbench/DUT/aclk_tuser
add wave -noupdate -expand -group trim -expand -group {Stream input I/F} /testbench/DUT/aclk_tlast
add wave -noupdate -expand -group trim -expand -group {Stream input I/F} /testbench/DUT/aclk_tdata
add wave -noupdate -expand -group trim -expand -group {Stream context} /testbench/DUT/aclk_ld_strm_ctx
add wave -noupdate -expand -group trim -expand -group {Stream context} /testbench/DUT/aclk_ld_strm_ctx_FF1
add wave -noupdate -expand -group trim -expand -group {Stream context} /testbench/DUT/aclk_ld_strm_ctx_FF2
add wave -noupdate -expand -group trim -expand -group {Stream context} /testbench/DUT/aclk_strm_context_in
add wave -noupdate -expand -group trim -expand -group {Stream context} /testbench/DUT/aclk_strm_context_P0
add wave -noupdate -expand -group trim -expand -group {Stream context} /testbench/DUT/aclk_strm_context_P1
add wave -noupdate -expand -group trim -expand -group {Stream context} /testbench/DUT/aclk_strm
add wave -noupdate -expand -group trim /testbench/DUT/aclk_tready_int
add wave -noupdate -expand -group trim /testbench/DUT/aclk_tvalid_int
add wave -noupdate -expand -group trim /testbench/DUT/aclk_tuser_int
add wave -noupdate -expand -group trim /testbench/DUT/aclk_tlast_int
add wave -noupdate -expand -group trim /testbench/DUT/aclk_tdata_int
add wave -noupdate -expand -group trim -expand -group {Stream output I/F} /testbench/DUT/bclk
add wave -noupdate -expand -group trim -expand -group {Stream output I/F} /testbench/DUT/bclk_reset_n
add wave -noupdate -expand -group trim -expand -group {Stream output I/F} /testbench/DUT/bclk_tready
add wave -noupdate -expand -group trim -expand -group {Stream output I/F} /testbench/DUT/bclk_tvalid
add wave -noupdate -expand -group trim -expand -group {Stream output I/F} /testbench/DUT/bclk_tuser
add wave -noupdate -expand -group trim -expand -group {Stream output I/F} /testbench/DUT/bclk_tlast
add wave -noupdate -expand -group trim -expand -group {Stream output I/F} /testbench/DUT/bclk_tdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2338668 ps} 0}
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
WaveRestoreZoom {0 ps} {18388812 ps}
