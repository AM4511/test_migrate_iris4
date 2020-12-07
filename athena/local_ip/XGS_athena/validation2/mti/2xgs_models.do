onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/system_top/xgs_reset_n_5000
add wave -noupdate /testbench/system_top/refclk_5000
add wave -noupdate /testbench/system_top/xgs_sclk_5000
add wave -noupdate /testbench/system_top/xgs_cs_n_5000
add wave -noupdate /testbench/system_top/xgs_sdout_5000
add wave -noupdate /testbench/system_top/xgs_sdin_5000
add wave -noupdate /testbench/system_top/xgs_trig_int_5000
add wave -noupdate /testbench/system_top/xgs_monitor0_5000
add wave -noupdate /testbench/system_top/xgs_monitor1_5000
add wave -noupdate /testbench/system_top/xgs_monitor2_5000
add wave -noupdate /testbench/system_top/xgs_trig_rd_5000
add wave -noupdate /testbench/system_top/xgs_reset_n_12000
add wave -noupdate -divider {New Divider}
add wave -noupdate /testbench/system_top/refclk_12000
add wave -noupdate /testbench/system_top/xgs_sclk_12000
add wave -noupdate /testbench/system_top/xgs_cs_n_12000
add wave -noupdate /testbench/system_top/xgs_sdout_12000
add wave -noupdate /testbench/system_top/xgs_sdin_12000
add wave -noupdate /testbench/system_top/xgs_monitor0_12000
add wave -noupdate /testbench/system_top/xgs_monitor1_12000
add wave -noupdate /testbench/system_top/xgs_monitor2_12000
add wave -noupdate /testbench/system_top/xgs_trig_int_12000
add wave -noupdate /testbench/system_top/xgs_trig_rd_12000
add wave -noupdate -divider {New Divider}
add wave -noupdate /testbench/system_top/xgs_sclk
add wave -noupdate /testbench/system_top/xgs_cs_n
add wave -noupdate /testbench/system_top/xgs_sdout
add wave -noupdate /testbench/system_top/xgs_sdin
add wave -noupdate /testbench/system_top/xgs_monitor0
add wave -noupdate /testbench/system_top/xgs_monitor1
add wave -noupdate /testbench/system_top/xgs_monitor2
add wave -noupdate /testbench/system_top/xgs_trig_int
add wave -noupdate /testbench/system_top/xgs_trig_rd
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1358215128 ps} 0}
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
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {329620820 ps} {1879333642 ps}
