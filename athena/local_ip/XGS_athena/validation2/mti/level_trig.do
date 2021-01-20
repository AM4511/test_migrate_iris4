onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/system_top/DUT/anput_ext_trig
add wave -noupdate /testbench/system_top/DUT/Inst_XGS_controller_top/Inst_xgs_ctrl/hw_trig
add wave -noupdate /testbench/system_top/DUT/Inst_XGS_controller_top/Inst_xgs_ctrl/hw_trig_miss
add wave -noupdate /testbench/system_top/DUT/Inst_XGS_controller_top/Inst_xgs_ctrl/sw_trig_miss
add wave -noupdate /testbench/system_top/DUT/regfile.ACQ.GRAB_CTRL.GRAB_CMD
add wave -noupdate /testbench/system_top/xgs_sclk
add wave -noupdate /testbench/system_top/xgs_monitor0
add wave -noupdate /testbench/system_top/xgs_monitor1
add wave -noupdate /testbench/system_top/DUT/Inst_XGS_controller_top/Inst_xgs_ctrl/curr_grab_mngr_state
add wave -noupdate /testbench/system_top/DUT/Inst_XGS_controller_top/Inst_xgs_ctrl/curr_trig_mngr_state
add wave -noupdate /testbench/system_top/s_axis_tx_tready
add wave -noupdate /testbench/system_top/s_axis_tx_tdata
add wave -noupdate /testbench/system_top/s_axis_tx_tlast
add wave -noupdate /testbench/system_top/s_axis_tx_tvalid
add wave -noupdate /testbench/system_top/anput_trig_rdy_out
add wave -noupdate /testbench/system_top/anput_exposure_out
add wave -noupdate /testbench/system_top/irq_dma
add wave -noupdate /testbench/system_top/DUT/Inst_XGS_controller_top/Inst_xgs_ctrl/ext_trig_p2
add wave -noupdate /testbench/system_top/DUT/Inst_XGS_controller_top/Inst_xgs_ctrl/ext_trig_p3
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2979992000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 104
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
WaveRestoreZoom {0 ps} {5623102800 ps}
