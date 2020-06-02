onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/regfile
add wave -noupdate -expand -group xgs_mono_pipeline -expand -group {AXI Stream input} /testbench/DUT/xgs_mono_pipeline_inst/sclk
add wave -noupdate -expand -group xgs_mono_pipeline -expand -group {AXI Stream input} /testbench/DUT/xgs_mono_pipeline_inst/sclk_reset_n
add wave -noupdate -expand -group xgs_mono_pipeline -expand -group {AXI Stream input} /testbench/DUT/xgs_mono_pipeline_inst/sclk_tready
add wave -noupdate -expand -group xgs_mono_pipeline -expand -group {AXI Stream input} /testbench/DUT/xgs_mono_pipeline_inst/sclk_tvalid
add wave -noupdate -expand -group xgs_mono_pipeline -expand -group {AXI Stream input} /testbench/DUT/xgs_mono_pipeline_inst/sclk_tuser
add wave -noupdate -expand -group xgs_mono_pipeline -expand -group {AXI Stream input} /testbench/DUT/xgs_mono_pipeline_inst/sclk_tlast
add wave -noupdate -expand -group xgs_mono_pipeline -expand -group {AXI Stream input} /testbench/DUT/xgs_mono_pipeline_inst/sclk_tdata
add wave -noupdate -expand -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_state
add wave -noupdate -expand -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_reset
add wave -noupdate -expand -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_wen
add wave -noupdate -expand -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_data
add wave -noupdate -expand -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_full
add wave -noupdate -expand -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_data_phase
add wave -noupdate -expand -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_load_data
add wave -noupdate -expand -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_last_data
add wave -noupdate -expand -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_sync_packer
add wave -noupdate -expand -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_data_packer
add wave -noupdate -expand -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_packer_valid
add wave -noupdate -expand -group xgs_mono_pipeline -expand -group {SCLK pix counter} /testbench/DUT/xgs_mono_pipeline_inst/sclk_pix_cntr_en
add wave -noupdate -expand -group xgs_mono_pipeline -expand -group {SCLK pix counter} /testbench/DUT/xgs_mono_pipeline_inst/sclk_pix_cntr_init
add wave -noupdate -expand -group xgs_mono_pipeline -expand -group {SCLK pix counter} -color Cyan -radix unsigned /testbench/DUT/xgs_mono_pipeline_inst/sclk_pix_cntr
add wave -noupdate -expand -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_tvalid_int
add wave -noupdate -expand -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_read_data_valid
add wave -noupdate -expand -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_tlast_int
add wave -noupdate -expand -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_sync_packer
add wave -noupdate -expand -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_tlast_packer
add wave -noupdate -expand -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_empty
add wave -noupdate -expand -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_read
add wave -noupdate -expand -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_read_data
add wave -noupdate -expand -group xgs_mono_pipeline -expand -group {ACLK Pixel counter} /testbench/DUT/xgs_mono_pipeline_inst/aclk_pix_cntr_en
add wave -noupdate -expand -group xgs_mono_pipeline -expand -group {ACLK Pixel counter} /testbench/DUT/xgs_mono_pipeline_inst/aclk_pix_cntr_init
add wave -noupdate -expand -group xgs_mono_pipeline -expand -group {ACLK Pixel counter} -color Cyan -radix unsigned /testbench/DUT/xgs_mono_pipeline_inst/aclk_pix_cntr
add wave -noupdate -expand -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_tuser_int
add wave -noupdate -expand -group xgs_mono_pipeline -expand -group {AXI Stream output} /testbench/DUT/xgs_mono_pipeline_inst/aclk
add wave -noupdate -expand -group xgs_mono_pipeline -expand -group {AXI Stream output} /testbench/DUT/xgs_mono_pipeline_inst/aclk_reset_n
add wave -noupdate -expand -group xgs_mono_pipeline -expand -group {AXI Stream output} /testbench/DUT/xgs_mono_pipeline_inst/aclk_tready
add wave -noupdate -expand -group xgs_mono_pipeline -expand -group {AXI Stream output} /testbench/DUT/xgs_mono_pipeline_inst/aclk_tvalid
add wave -noupdate -expand -group xgs_mono_pipeline -expand -group {AXI Stream output} /testbench/DUT/xgs_mono_pipeline_inst/aclk_tuser
add wave -noupdate -expand -group xgs_mono_pipeline -expand -group {AXI Stream output} /testbench/DUT/xgs_mono_pipeline_inst/aclk_tlast
add wave -noupdate -expand -group xgs_mono_pipeline -expand -group {AXI Stream output} /testbench/DUT/xgs_mono_pipeline_inst/aclk_tdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1202768212 ps} 0} {{Cursor 2} {1992462296 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 357
configure wave -valuecolwidth 175
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
WaveRestoreZoom {1169217709 ps} {1268581958 ps}
