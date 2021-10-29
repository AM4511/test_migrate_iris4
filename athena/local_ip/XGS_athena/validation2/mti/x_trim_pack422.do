onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group x_trim_pack422 /testbench/DUT/x_trim_inst/x_trim_pack422_inst/bclk
add wave -noupdate -expand -group x_trim_pack422 /testbench/DUT/x_trim_inst/x_trim_pack422_inst/bclk_reset
add wave -noupdate -expand -group x_trim_pack422 /testbench/DUT/x_trim_inst/x_trim_pack422_inst/bclk_pack_en
add wave -noupdate -expand -group x_trim_pack422 -expand -group {AXI Stream input I/F} /testbench/DUT/x_trim_inst/x_trim_pack422_inst/bclk_tready
add wave -noupdate -expand -group x_trim_pack422 -expand -group {AXI Stream input I/F} /testbench/DUT/x_trim_inst/x_trim_pack422_inst/bclk_tvalid
add wave -noupdate -expand -group x_trim_pack422 -expand -group {AXI Stream input I/F} /testbench/DUT/x_trim_inst/x_trim_pack422_inst/bclk_tuser
add wave -noupdate -expand -group x_trim_pack422 -expand -group {AXI Stream input I/F} /testbench/DUT/x_trim_inst/x_trim_pack422_inst/bclk_tlast
add wave -noupdate -expand -group x_trim_pack422 -expand -group {AXI Stream input I/F} /testbench/DUT/x_trim_inst/x_trim_pack422_inst/bclk_tdata
add wave -noupdate -expand -group x_trim_pack422 /testbench/DUT/x_trim_inst/x_trim_pack422_inst/bclk_ack
add wave -noupdate -expand -group x_trim_pack422 /testbench/DUT/x_trim_inst/x_trim_pack422_inst/bclk_state
add wave -noupdate -expand -group x_trim_pack422 /testbench/DUT/x_trim_inst/x_trim_pack422_inst/bclk_tready_int
add wave -noupdate -expand -group x_trim_pack422 /testbench/DUT/x_trim_inst/x_trim_pack422_inst/bclk_word_cntr
add wave -noupdate -expand -group x_trim_pack422 -color Magenta /testbench/DUT/x_trim_inst/x_trim_pack422_inst/bclk_data_valid
add wave -noupdate -expand -group x_trim_pack422 -color Magenta /testbench/DUT/x_trim_inst/x_trim_pack422_inst/bclk_data
add wave -noupdate -expand -group x_trim_pack422 -expand -group {AXI Stream output I/F} /testbench/DUT/x_trim_inst/x_trim_pack422_inst/bclk_tready_out
add wave -noupdate -expand -group x_trim_pack422 -expand -group {AXI Stream output I/F} /testbench/DUT/x_trim_inst/x_trim_pack422_inst/bclk_tvalid_out
add wave -noupdate -expand -group x_trim_pack422 -expand -group {AXI Stream output I/F} /testbench/DUT/x_trim_inst/x_trim_pack422_inst/bclk_tuser_out
add wave -noupdate -expand -group x_trim_pack422 -expand -group {AXI Stream output I/F} /testbench/DUT/x_trim_inst/x_trim_pack422_inst/bclk_tlast_out
add wave -noupdate -expand -group x_trim_pack422 -expand -group {AXI Stream output I/F} /testbench/DUT/x_trim_inst/x_trim_pack422_inst/bclk_tdata_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3930061 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 166
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
WaveRestoreZoom {3824713 ps} {4049845 ps}
