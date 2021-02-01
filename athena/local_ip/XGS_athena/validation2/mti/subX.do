onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/system_top/DUT/idelay_clk
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/sclk_pll_locked
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/state
add wave -noupdate /testbench/system_top/DUT/regfile.HISPI.IDELAYCTRL_STATUS.PLL_LOCKED
add wave -noupdate -expand -subitemconfig {/testbench/system_top/DUT/regfile.HISPI -expand /testbench/system_top/DUT/regfile.HISPI.CTRL -expand /testbench/system_top/DUT/regfile.HISPI.STATUS -expand /testbench/system_top/DUT/regfile.HISPI.IDELAYCTRL_STATUS -expand} /testbench/system_top/DUT/regfile
add wave -noupdate /testbench/system_top/DUT/regfile.ACQ.GRAB_CTRL.GRAB_CMD
add wave -noupdate /testbench/system_top/xgs_sclk
add wave -noupdate /testbench/system_top/xgs_monitor0
add wave -noupdate /testbench/system_top/xgs_monitor1
add wave -noupdate -color Orange -radix decimal /testbench/system_top/DUT/x_xgs_hispi_top/sclk_x_start
add wave -noupdate -color Orange -radix unsigned /testbench/system_top/DUT/x_xgs_hispi_top/sclk_x_stop
add wave -noupdate -color {Indian Red} /testbench/system_top/DUT/x_xgs_hispi_top/sclk_tuser
add wave -noupdate -color {Indian Red} /testbench/system_top/DUT/x_xgs_hispi_top/sclk_tvalid
add wave -noupdate -color {Indian Red} /testbench/system_top/DUT/x_xgs_hispi_top/sclk_tready
add wave -noupdate -color {Indian Red} /testbench/system_top/DUT/x_xgs_hispi_top/sclk_tdata
add wave -noupdate -color {Indian Red} /testbench/system_top/DUT/x_xgs_hispi_top/sclk_tlast
add wave -noupdate /testbench/system_top/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_valid_x_roi
add wave -noupdate /testbench/system_top/DUT/xdpc_filter/alias_fpnprnu_corr_data_3
add wave -noupdate /testbench/system_top/DUT/xdpc_filter/alias_fpnprnu_corr_data_2
add wave -noupdate /testbench/system_top/DUT/xdpc_filter/alias_fpnprnu_corr_data_1
add wave -noupdate /testbench/system_top/DUT/xdpc_filter/alias_fpnprnu_corr_data_0
add wave -noupdate /testbench/system_top/DUT/xgs_mono_pipeline_inst/aclk_tdata
add wave -noupdate /testbench/system_top/DUT/xgs_mono_pipeline_inst/aclk_tvalid
add wave -noupdate /testbench/system_top/DUT/xgs_mono_pipeline_inst/aclk_tready
add wave -noupdate /testbench/system_top/DUT/xgs_mono_pipeline_inst/aclk_tlast
add wave -noupdate /testbench/system_top/DUT/Inst_XGS_controller_top/Inst_xgs_ctrl/curr_grab_mngr_state
add wave -noupdate /testbench/system_top/DUT/Inst_XGS_controller_top/Inst_xgs_ctrl/curr_trig_mngr_state
add wave -noupdate /testbench/system_top/s_axis_tx_tready
add wave -noupdate /testbench/system_top/s_axis_tx_tvalid
add wave -noupdate /testbench/system_top/s_axis_tx_tdata
add wave -noupdate /testbench/system_top/s_axis_tx_tlast
add wave -noupdate /testbench/system_top/anput_trig_rdy_out
add wave -noupdate /testbench/system_top/anput_exposure_out
add wave -noupdate /testbench/system_top/irq_dma
add wave -noupdate /testbench/system_top/DUT/Inst_XGS_controller_top/Inst_xgs_ctrl/ext_trig_p2
add wave -noupdate /testbench/system_top/DUT/Inst_XGS_controller_top/Inst_xgs_ctrl/ext_trig_p3
add wave -noupdate /testbench/system_top/XGS_MODEL_12000/x_subsampling
add wave -noupdate /testbench/system_top/XGS_MODEL_12000/x_subsampling_DB
add wave -noupdate /testbench/system_top/XGS_MODEL_12000/xgs_image_inst/frame(1)
add wave -noupdate /testbench/system_top/XGS_MODEL_12000/xgs_image_inst/dataline
add wave -noupdate /testbench/system_top/XGS_MODEL_12000/xgs_image_inst/dataline_nxt
add wave -noupdate /testbench/system_top/DUT/regfile.DMA.LINE_SIZE
add wave -noupdate /testbench/system_top/DUT/regfile.DMA.OUTPUT_BUFFER
add wave -noupdate /testbench/system_top/DUT/regfile.HISPI.FRAME_CFG_X_VALID
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1250613364 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 239
configure wave -valuecolwidth 171
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
WaveRestoreZoom {0 ps} {8188798811 ps}
