onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/regfile
add wave -noupdate -group xgs_mono_pipeline -group {AXI Stream input I/F} /testbench/DUT/xgs_mono_pipeline_inst/sclk
add wave -noupdate -group xgs_mono_pipeline -group {AXI Stream input I/F} /testbench/DUT/xgs_mono_pipeline_inst/sclk_reset_n
add wave -noupdate -group xgs_mono_pipeline -group {AXI Stream input I/F} /testbench/DUT/xgs_mono_pipeline_inst/sclk_tready
add wave -noupdate -group xgs_mono_pipeline -group {AXI Stream input I/F} /testbench/DUT/xgs_mono_pipeline_inst/sclk_tvalid
add wave -noupdate -group xgs_mono_pipeline -group {AXI Stream input I/F} /testbench/DUT/xgs_mono_pipeline_inst/sclk_tuser
add wave -noupdate -group xgs_mono_pipeline -group {AXI Stream input I/F} /testbench/DUT/xgs_mono_pipeline_inst/sclk_tlast
add wave -noupdate -group xgs_mono_pipeline -group {AXI Stream input I/F} /testbench/DUT/xgs_mono_pipeline_inst/sclk_tdata
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_state
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_reset
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_wen
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_data
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_full
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_data_phase
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_load_data
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_last_data
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_sync_packer
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_data_packer
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_packer_valid
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_read
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_read_data
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_empty
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_tvalid_int
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_read_data_valid
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_acknowledge
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_tlast_int
add wave -noupdate -group xgs_mono_pipeline -group {AXI Stream out I/F} /testbench/DUT/xgs_mono_pipeline_inst/aclk
add wave -noupdate -group xgs_mono_pipeline -group {AXI Stream out I/F} /testbench/DUT/xgs_mono_pipeline_inst/aclk_reset_n
add wave -noupdate -group xgs_mono_pipeline -group {AXI Stream out I/F} /testbench/DUT/xgs_mono_pipeline_inst/aclk_tready
add wave -noupdate -group xgs_mono_pipeline -group {AXI Stream out I/F} /testbench/DUT/xgs_mono_pipeline_inst/aclk_tvalid
add wave -noupdate -group xgs_mono_pipeline -group {AXI Stream out I/F} /testbench/DUT/xgs_mono_pipeline_inst/aclk_tuser
add wave -noupdate -group xgs_mono_pipeline -group {AXI Stream out I/F} /testbench/DUT/xgs_mono_pipeline_inst/aclk_tlast
add wave -noupdate -group xgs_mono_pipeline -group {AXI Stream out I/F} /testbench/DUT/xgs_mono_pipeline_inst/aclk_tdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1209025000 ps} 0} {{Cursor 2} {1446428586 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 257
configure wave -valuecolwidth 226
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
WaveRestoreZoom {0 ps} {2025291639 ps}
