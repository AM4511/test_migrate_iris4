onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group trim_inst.do /testbench/system_top/DUT/trim_inst/aclk_grab_queue_en
add wave -noupdate -expand -group trim_inst.do /testbench/system_top/DUT/trim_inst/aclk_load_context
add wave -noupdate -expand -group trim_inst.do /testbench/system_top/DUT/trim_inst/aclk_color_space
add wave -noupdate -expand -group trim_inst.do /testbench/system_top/DUT/trim_inst/aclk_x_crop_en
add wave -noupdate -expand -group trim_inst.do /testbench/system_top/DUT/trim_inst/aclk_x_start
add wave -noupdate -expand -group trim_inst.do /testbench/system_top/DUT/trim_inst/aclk_x_size
add wave -noupdate -expand -group trim_inst.do /testbench/system_top/DUT/trim_inst/aclk_x_scale
add wave -noupdate -expand -group trim_inst.do /testbench/system_top/DUT/trim_inst/aclk_x_reverse
add wave -noupdate -expand -group trim_inst.do /testbench/system_top/DUT/trim_inst/aclk_y_roi_en
add wave -noupdate -expand -group trim_inst.do /testbench/system_top/DUT/trim_inst/aclk_y_start
add wave -noupdate -expand -group trim_inst.do /testbench/system_top/DUT/trim_inst/aclk_y_size
add wave -noupdate -expand -group trim_inst.do /testbench/system_top/DUT/trim_inst/aclk
add wave -noupdate -expand -group trim_inst.do /testbench/system_top/DUT/trim_inst/aclk_reset_n
add wave -noupdate -expand -group trim_inst.do -group {AXIS stream input I/F} /testbench/system_top/DUT/trim_inst/aclk_tready
add wave -noupdate -expand -group trim_inst.do -group {AXIS stream input I/F} /testbench/system_top/DUT/trim_inst/aclk_tvalid
add wave -noupdate -expand -group trim_inst.do -group {AXIS stream input I/F} /testbench/system_top/DUT/trim_inst/aclk_tlast
add wave -noupdate -expand -group trim_inst.do -group {AXIS stream input I/F} /testbench/system_top/DUT/trim_inst/aclk_tuser
add wave -noupdate -expand -group trim_inst.do -group {AXIS stream input I/F} /testbench/system_top/DUT/trim_inst/aclk_tdata
add wave -noupdate -expand -group trim_inst.do /testbench/system_top/DUT/trim_inst/bclk
add wave -noupdate -expand -group trim_inst.do /testbench/system_top/DUT/trim_inst/bclk_reset_n
add wave -noupdate -expand -group trim_inst.do /testbench/system_top/DUT/trim_inst/bclk_tready
add wave -noupdate -expand -group trim_inst.do -expand -group {AXIS stream output I/F} /testbench/system_top/DUT/trim_inst/bclk_tvalid
add wave -noupdate -expand -group trim_inst.do -expand -group {AXIS stream output I/F} /testbench/system_top/DUT/trim_inst/bclk_tuser
add wave -noupdate -expand -group trim_inst.do -expand -group {AXIS stream output I/F} /testbench/system_top/DUT/trim_inst/bclk_tlast
add wave -noupdate -expand -group trim_inst.do -expand -group {AXIS stream output I/F} /testbench/system_top/DUT/trim_inst/bclk_tdata
add wave -noupdate -expand -group trim_inst.do /testbench/system_top/DUT/trim_inst/aclk_reset
add wave -noupdate -expand -group trim_inst.do /testbench/system_top/DUT/trim_inst/aclk_strm_context_in
add wave -noupdate -expand -group trim_inst.do /testbench/system_top/DUT/trim_inst/aclk_strm_context_P0
add wave -noupdate -expand -group trim_inst.do /testbench/system_top/DUT/trim_inst/aclk_strm_context_P1
add wave -noupdate -expand -group trim_inst.do /testbench/system_top/DUT/trim_inst/aclk_strm
add wave -noupdate -expand -group trim_inst.do /testbench/system_top/DUT/trim_inst/aclk_ld_strm_ctx
add wave -noupdate -expand -group trim_inst.do /testbench/system_top/DUT/trim_inst/aclk_ld_strm_ctx_FF1
add wave -noupdate -expand -group trim_inst.do /testbench/system_top/DUT/trim_inst/aclk_ld_strm_ctx_FF2
add wave -noupdate -expand -group trim_inst.do /testbench/system_top/DUT/trim_inst/aclk_tready_int
add wave -noupdate -expand -group trim_inst.do /testbench/system_top/DUT/trim_inst/aclk_tvalid_int
add wave -noupdate -expand -group trim_inst.do /testbench/system_top/DUT/trim_inst/aclk_tuser_int
add wave -noupdate -expand -group trim_inst.do /testbench/system_top/DUT/trim_inst/aclk_tlast_int
add wave -noupdate -expand -group trim_inst.do /testbench/system_top/DUT/trim_inst/aclk_tdata_int
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5655066846 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 227
configure wave -valuecolwidth 146
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
WaveRestoreZoom {5654952145 ps} {5655927102 ps}
