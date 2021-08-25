onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group y_trim /testbench/DUT/y_trim_inst/aclk_y_roi_en
add wave -noupdate -expand -group y_trim /testbench/DUT/y_trim_inst/aclk_y_start
add wave -noupdate -expand -group y_trim /testbench/DUT/y_trim_inst/aclk_y_size
add wave -noupdate -expand -group y_trim /testbench/DUT/y_trim_inst/aclk
add wave -noupdate -expand -group y_trim /testbench/DUT/y_trim_inst/aclk_reset
add wave -noupdate -expand -group y_trim -expand -group {Stream input I/F} /testbench/DUT/y_trim_inst/aclk_tready
add wave -noupdate -expand -group y_trim -expand -group {Stream input I/F} /testbench/DUT/y_trim_inst/aclk_tvalid
add wave -noupdate -expand -group y_trim -expand -group {Stream input I/F} -expand /testbench/DUT/y_trim_inst/aclk_tuser
add wave -noupdate -expand -group y_trim -expand -group {Stream input I/F} /testbench/DUT/y_trim_inst/aclk_tlast
add wave -noupdate -expand -group y_trim -expand -group {Stream input I/F} /testbench/DUT/y_trim_inst/aclk_tdata
add wave -noupdate -expand -group y_trim /testbench/DUT/y_trim_inst/aclk_ack
add wave -noupdate -expand -group y_trim /testbench/DUT/y_trim_inst/aclk_state
add wave -noupdate -expand -group y_trim /testbench/DUT/y_trim_inst/aclk_y_stop
add wave -noupdate -expand -group y_trim /testbench/DUT/y_trim_inst/aclk_line_cntr
add wave -noupdate -expand -group y_trim /testbench/DUT/y_trim_inst/aclk_line_valid
add wave -noupdate -expand -group y_trim /testbench/DUT/y_trim_inst/aclk_tvalid_int
add wave -noupdate -expand -group y_trim /testbench/DUT/y_trim_inst/aclk_tuser_int
add wave -noupdate -expand -group y_trim /testbench/DUT/y_trim_inst/aclk_tlast_int
add wave -noupdate -expand -group y_trim /testbench/DUT/y_trim_inst/aclk_tdata_int
add wave -noupdate -expand -group y_trim -expand -group {Stream output I/F} /testbench/DUT/y_trim_inst/aclk_tready_out
add wave -noupdate -expand -group y_trim -expand -group {Stream output I/F} /testbench/DUT/y_trim_inst/aclk_tvalid_out
add wave -noupdate -expand -group y_trim -expand -group {Stream output I/F} /testbench/DUT/y_trim_inst/aclk_tuser_out
add wave -noupdate -expand -group y_trim -expand -group {Stream output I/F} /testbench/DUT/y_trim_inst/aclk_tlast_out
add wave -noupdate -expand -group y_trim -expand -group {Stream output I/F} /testbench/DUT/y_trim_inst/aclk_tdata_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9003756 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {29657602 ps} {43560127 ps}
