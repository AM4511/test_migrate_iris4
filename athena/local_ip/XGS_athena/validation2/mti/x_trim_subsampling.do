onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group x_trim_subsampling /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/aclk
add wave -noupdate -expand -group x_trim_subsampling /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/aclk_reset
add wave -noupdate -expand -group x_trim_subsampling /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/aclk_pixel_width
add wave -noupdate -expand -group x_trim_subsampling /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/aclk_x_subsampling
add wave -noupdate -expand -group x_trim_subsampling /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/aclk_init
add wave -noupdate -expand -group x_trim_subsampling /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/aclk_en
add wave -noupdate -expand -group x_trim_subsampling /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/aclk_last_data_in
add wave -noupdate -expand -group x_trim_subsampling -radix binary /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/aclk_ben_in
add wave -noupdate -expand -group x_trim_subsampling /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/aclk_data_in
add wave -noupdate -expand -group x_trim_subsampling /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/state
add wave -noupdate -expand -group x_trim_subsampling /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/subs_cntr
add wave -noupdate -expand -group x_trim_subsampling /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/subs_lut
add wave -noupdate -expand -group x_trim_subsampling /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/pix_per_clk
add wave -noupdate -expand -group x_trim_subsampling /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/modulo_count
add wave -noupdate -expand -group x_trim_subsampling /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/subs_ben
add wave -noupdate -expand -group x_trim_subsampling /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/subs_mask
add wave -noupdate -expand -group x_trim_subsampling -group P1 /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/p1_ld
add wave -noupdate -expand -group x_trim_subsampling -group P1 /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/p1_valid
add wave -noupdate -expand -group x_trim_subsampling -group P1 /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/p1_last_data
add wave -noupdate -expand -group x_trim_subsampling -group P1 /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/p1_data
add wave -noupdate -expand -group x_trim_subsampling -group P1 /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/p1_ben
add wave -noupdate -expand -group x_trim_subsampling -group P2 /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/p2_ld
add wave -noupdate -expand -group x_trim_subsampling -group P2 /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/p2_valid
add wave -noupdate -expand -group x_trim_subsampling -group P2 /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/p2_last_data
add wave -noupdate -expand -group x_trim_subsampling -group P2 /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/p2_data
add wave -noupdate -expand -group x_trim_subsampling -group P2 /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/p2_ben
add wave -noupdate -expand -group x_trim_subsampling -group P2 /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/p2_byte_cnt
add wave -noupdate -expand -group x_trim_subsampling -group P3 /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/p3_ld
add wave -noupdate -expand -group x_trim_subsampling -group P3 /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/p3_valid
add wave -noupdate -expand -group x_trim_subsampling -group P3 /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/p3_last_data
add wave -noupdate -expand -group x_trim_subsampling -group P3 /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/p3_data
add wave -noupdate -expand -group x_trim_subsampling -group P3 /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/p3_ben
add wave -noupdate -expand -group x_trim_subsampling -group P3 /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/p3_byte_ptr
add wave -noupdate -expand -group x_trim_subsampling -expand -group {Data ouput} /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/aclk_empty
add wave -noupdate -expand -group x_trim_subsampling -expand -group {Data ouput} /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/aclk_data_valid_out
add wave -noupdate -expand -group x_trim_subsampling -expand -group {Data ouput} /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/aclk_last_data_out
add wave -noupdate -expand -group x_trim_subsampling -expand -group {Data ouput} -radix binary /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/aclk_ben_out
add wave -noupdate -expand -group x_trim_subsampling -expand -group {Data ouput} /testbench/DUT/x_trim_inst/x_trim_subsampling_inst/aclk_data_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3610853 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 246
configure wave -valuecolwidth 261
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
WaveRestoreZoom {18676663 ps} {18874913 ps}
