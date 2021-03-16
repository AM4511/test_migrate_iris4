onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group x_trim_subsampling /testbench/DUT/x_trim_subsampling_inst/aclk
add wave -noupdate -expand -group x_trim_subsampling /testbench/DUT/x_trim_subsampling_inst/aclk_reset
add wave -noupdate -expand -group x_trim_subsampling /testbench/DUT/x_trim_subsampling_inst/aclk_pixel_width
add wave -noupdate -expand -group x_trim_subsampling /testbench/DUT/x_trim_subsampling_inst/aclk_x_subsampling
add wave -noupdate -expand -group x_trim_subsampling /testbench/DUT/x_trim_subsampling_inst/aclk_init
add wave -noupdate -expand -group x_trim_subsampling /testbench/DUT/x_trim_subsampling_inst/aclk_en
add wave -noupdate -expand -group x_trim_subsampling /testbench/DUT/x_trim_subsampling_inst/aclk_last_data_in
add wave -noupdate -expand -group x_trim_subsampling /testbench/DUT/x_trim_subsampling_inst/aclk_data_in
add wave -noupdate -expand -group x_trim_subsampling /testbench/DUT/x_trim_subsampling_inst/aclk_ben_in
add wave -noupdate -expand -group x_trim_subsampling -color Cyan /testbench/DUT/x_trim_subsampling_inst/state
add wave -noupdate -expand -group x_trim_subsampling /testbench/DUT/x_trim_subsampling_inst/pix_per_clk
add wave -noupdate -expand -group x_trim_subsampling -group Subsampling -expand /testbench/DUT/x_trim_subsampling_inst/subs_cntr
add wave -noupdate -expand -group x_trim_subsampling -group Subsampling -radix binary -childformat {{/testbench/DUT/x_trim_subsampling_inst/subs_lut(15) -radix binary} {/testbench/DUT/x_trim_subsampling_inst/subs_lut(14) -radix binary} {/testbench/DUT/x_trim_subsampling_inst/subs_lut(13) -radix binary} {/testbench/DUT/x_trim_subsampling_inst/subs_lut(12) -radix binary} {/testbench/DUT/x_trim_subsampling_inst/subs_lut(11) -radix binary} {/testbench/DUT/x_trim_subsampling_inst/subs_lut(10) -radix binary} {/testbench/DUT/x_trim_subsampling_inst/subs_lut(9) -radix binary} {/testbench/DUT/x_trim_subsampling_inst/subs_lut(8) -radix binary} {/testbench/DUT/x_trim_subsampling_inst/subs_lut(7) -radix binary} {/testbench/DUT/x_trim_subsampling_inst/subs_lut(6) -radix binary} {/testbench/DUT/x_trim_subsampling_inst/subs_lut(5) -radix binary} {/testbench/DUT/x_trim_subsampling_inst/subs_lut(4) -radix binary} {/testbench/DUT/x_trim_subsampling_inst/subs_lut(3) -radix binary} {/testbench/DUT/x_trim_subsampling_inst/subs_lut(2) -radix binary} {/testbench/DUT/x_trim_subsampling_inst/subs_lut(1) -radix binary} {/testbench/DUT/x_trim_subsampling_inst/subs_lut(0) -radix binary}} -subitemconfig {/testbench/DUT/x_trim_subsampling_inst/subs_lut(15) {-height 15 -radix binary} /testbench/DUT/x_trim_subsampling_inst/subs_lut(14) {-height 15 -radix binary} /testbench/DUT/x_trim_subsampling_inst/subs_lut(13) {-height 15 -radix binary} /testbench/DUT/x_trim_subsampling_inst/subs_lut(12) {-height 15 -radix binary} /testbench/DUT/x_trim_subsampling_inst/subs_lut(11) {-height 15 -radix binary} /testbench/DUT/x_trim_subsampling_inst/subs_lut(10) {-height 15 -radix binary} /testbench/DUT/x_trim_subsampling_inst/subs_lut(9) {-height 15 -radix binary} /testbench/DUT/x_trim_subsampling_inst/subs_lut(8) {-height 15 -radix binary} /testbench/DUT/x_trim_subsampling_inst/subs_lut(7) {-height 15 -radix binary} /testbench/DUT/x_trim_subsampling_inst/subs_lut(6) {-height 15 -radix binary} /testbench/DUT/x_trim_subsampling_inst/subs_lut(5) {-height 15 -radix binary} /testbench/DUT/x_trim_subsampling_inst/subs_lut(4) {-height 15 -radix binary} /testbench/DUT/x_trim_subsampling_inst/subs_lut(3) {-height 15 -radix binary} /testbench/DUT/x_trim_subsampling_inst/subs_lut(2) {-height 15 -radix binary} /testbench/DUT/x_trim_subsampling_inst/subs_lut(1) {-height 15 -radix binary} /testbench/DUT/x_trim_subsampling_inst/subs_lut(0) {-height 15 -radix binary}} /testbench/DUT/x_trim_subsampling_inst/subs_lut
add wave -noupdate -expand -group x_trim_subsampling -group Subsampling -radix binary -childformat {{/testbench/DUT/x_trim_subsampling_inst/subs_ben(7) -radix binary} {/testbench/DUT/x_trim_subsampling_inst/subs_ben(6) -radix binary} {/testbench/DUT/x_trim_subsampling_inst/subs_ben(5) -radix binary} {/testbench/DUT/x_trim_subsampling_inst/subs_ben(4) -radix binary} {/testbench/DUT/x_trim_subsampling_inst/subs_ben(3) -radix binary} {/testbench/DUT/x_trim_subsampling_inst/subs_ben(2) -radix binary} {/testbench/DUT/x_trim_subsampling_inst/subs_ben(1) -radix binary} {/testbench/DUT/x_trim_subsampling_inst/subs_ben(0) -radix binary}} -expand -subitemconfig {/testbench/DUT/x_trim_subsampling_inst/subs_ben(7) {-height 15 -radix binary} /testbench/DUT/x_trim_subsampling_inst/subs_ben(6) {-height 15 -radix binary} /testbench/DUT/x_trim_subsampling_inst/subs_ben(5) {-height 15 -radix binary} /testbench/DUT/x_trim_subsampling_inst/subs_ben(4) {-height 15 -radix binary} /testbench/DUT/x_trim_subsampling_inst/subs_ben(3) {-height 15 -radix binary} /testbench/DUT/x_trim_subsampling_inst/subs_ben(2) {-height 15 -radix binary} /testbench/DUT/x_trim_subsampling_inst/subs_ben(1) {-height 15 -radix binary} /testbench/DUT/x_trim_subsampling_inst/subs_ben(0) {-height 15 -radix binary}} /testbench/DUT/x_trim_subsampling_inst/subs_ben
add wave -noupdate -expand -group x_trim_subsampling -expand -group P1 /testbench/DUT/x_trim_subsampling_inst/p1_ld
add wave -noupdate -expand -group x_trim_subsampling -expand -group P1 /testbench/DUT/x_trim_subsampling_inst/p1_valid
add wave -noupdate -expand -group x_trim_subsampling -expand -group P1 -radix binary /testbench/DUT/x_trim_subsampling_inst/p1_ben
add wave -noupdate -expand -group x_trim_subsampling -expand -group P1 -radix hexadecimal /testbench/DUT/x_trim_subsampling_inst/p1_data
add wave -noupdate -expand -group x_trim_subsampling -expand -group P2 /testbench/DUT/x_trim_subsampling_inst/p2_ld
add wave -noupdate -expand -group x_trim_subsampling -expand -group P2 /testbench/DUT/x_trim_subsampling_inst/p2_valid
add wave -noupdate -expand -group x_trim_subsampling -expand -group P2 -radix binary /testbench/DUT/x_trim_subsampling_inst/p2_ben
add wave -noupdate -expand -group x_trim_subsampling -expand -group P2 /testbench/DUT/x_trim_subsampling_inst/p2_data
add wave -noupdate -expand -group x_trim_subsampling -expand -group P2 -radix unsigned /testbench/DUT/x_trim_subsampling_inst/p2_byte_cnt
add wave -noupdate -expand -group x_trim_subsampling -expand -group P3 /testbench/DUT/x_trim_subsampling_inst/p3_ld
add wave -noupdate -expand -group x_trim_subsampling -expand -group P3 /testbench/DUT/x_trim_subsampling_inst/p3_last_data
add wave -noupdate -expand -group x_trim_subsampling -expand -group P3 /testbench/DUT/x_trim_subsampling_inst/p3_valid
add wave -noupdate -expand -group x_trim_subsampling -expand -group P3 /testbench/DUT/x_trim_subsampling_inst/p3_data
add wave -noupdate -expand -group x_trim_subsampling -expand -group P3 /testbench/DUT/x_trim_subsampling_inst/p3_ben
add wave -noupdate -expand -group x_trim_subsampling -expand -group P3 /testbench/DUT/x_trim_subsampling_inst/p3_byte_ptr
add wave -noupdate -expand -group x_trim_subsampling -expand -group {Data ouput} /testbench/DUT/x_trim_subsampling_inst/aclk_last_data_out
add wave -noupdate -expand -group x_trim_subsampling -expand -group {Data ouput} /testbench/DUT/x_trim_subsampling_inst/aclk_data_valid_out
add wave -noupdate -expand -group x_trim_subsampling -expand -group {Data ouput} /testbench/DUT/x_trim_subsampling_inst/aclk_data_out
add wave -noupdate -expand -group x_trim_subsampling -expand -group {Data ouput} /testbench/DUT/x_trim_subsampling_inst/aclk_ben_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2434583 ps} 0}
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
WaveRestoreZoom {2189161 ps} {2735655 ps}
