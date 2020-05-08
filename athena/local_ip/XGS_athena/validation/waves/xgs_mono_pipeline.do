onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/SIMULATION
add wave -noupdate -expand -group xgs_mono_pipeline -divider {SCLK DOMAIN}
add wave -noupdate -expand -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/regfile
add wave -noupdate -expand -group xgs_mono_pipeline -expand -group {AXI Stream input I/F} /testbench/DUT/xgs_mono_pipeline_inst/sclk
add wave -noupdate -expand -group xgs_mono_pipeline -expand -group {AXI Stream input I/F} /testbench/DUT/xgs_mono_pipeline_inst/sclk_reset_n
add wave -noupdate -expand -group xgs_mono_pipeline -expand -group {AXI Stream input I/F} /testbench/DUT/xgs_mono_pipeline_inst/sclk_tready
add wave -noupdate -expand -group xgs_mono_pipeline -expand -group {AXI Stream input I/F} /testbench/DUT/xgs_mono_pipeline_inst/sclk_tvalid
add wave -noupdate -expand -group xgs_mono_pipeline -expand -group {AXI Stream input I/F} /testbench/DUT/xgs_mono_pipeline_inst/sclk_tuser
add wave -noupdate -expand -group xgs_mono_pipeline -expand -group {AXI Stream input I/F} /testbench/DUT/xgs_mono_pipeline_inst/sclk_tdata
add wave -noupdate -expand -group xgs_mono_pipeline -expand -group {AXI Stream input I/F} /testbench/DUT/xgs_mono_pipeline_inst/sclk_tlast
add wave -noupdate -expand -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_data_phase
add wave -noupdate -expand -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_load_data
add wave -noupdate -expand -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_last_data
add wave -noupdate -expand -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_sync_packer
add wave -noupdate -expand -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_data_packer
add wave -noupdate -expand -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_packer_valid
add wave -noupdate -expand -group xgs_mono_pipeline -expand -group {FiFo write I/F} /testbench/DUT/xgs_mono_pipeline_inst/sclk_wen
add wave -noupdate -expand -group xgs_mono_pipeline -expand -group {FiFo write I/F} /testbench/DUT/xgs_mono_pipeline_inst/sclk_data
add wave -noupdate -expand -group xgs_mono_pipeline -expand -group {FiFo write I/F} /testbench/DUT/xgs_mono_pipeline_inst/sclk_full
add wave -noupdate -expand -group xgs_mono_pipeline -divider {OUTPUT FIFO}
add wave -noupdate -expand -group xgs_mono_pipeline -group {output fifo} /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/aClr
add wave -noupdate -expand -group xgs_mono_pipeline -group {output fifo} /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/wClk
add wave -noupdate -expand -group xgs_mono_pipeline -group {output fifo} /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/wEn
add wave -noupdate -expand -group xgs_mono_pipeline -group {output fifo} /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/wData
add wave -noupdate -expand -group xgs_mono_pipeline -group {output fifo} /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/wFull
add wave -noupdate -expand -group xgs_mono_pipeline -group {output fifo} /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/rClk
add wave -noupdate -expand -group xgs_mono_pipeline -group {output fifo} /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/rEn
add wave -noupdate -expand -group xgs_mono_pipeline -group {output fifo} /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/rData
add wave -noupdate -expand -group xgs_mono_pipeline -group {output fifo} /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/rEmpty
add wave -noupdate -expand -group xgs_mono_pipeline -group {output fifo} /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/wClr
add wave -noupdate -expand -group xgs_mono_pipeline -group {output fifo} /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/wClr_FF
add wave -noupdate -expand -group xgs_mono_pipeline -group {output fifo} /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/wPtr
add wave -noupdate -expand -group xgs_mono_pipeline -group {output fifo} /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/wPtrNxt
add wave -noupdate -expand -group xgs_mono_pipeline -group {output fifo} /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/wPtrGray
add wave -noupdate -expand -group xgs_mono_pipeline -group {output fifo} /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/wPtrGrayNxt
add wave -noupdate -expand -group xgs_mono_pipeline -group {output fifo} /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/wRdPtrGray
add wave -noupdate -expand -group xgs_mono_pipeline -group {output fifo} /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/wRdPtrGray_Meta
add wave -noupdate -expand -group xgs_mono_pipeline -group {output fifo} /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/wFullInt
add wave -noupdate -expand -group xgs_mono_pipeline -group {output fifo} /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/wFiFoWrEn
add wave -noupdate -expand -group xgs_mono_pipeline -group {output fifo} /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/rClr
add wave -noupdate -expand -group xgs_mono_pipeline -group {output fifo} /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/rClr_FF
add wave -noupdate -expand -group xgs_mono_pipeline -group {output fifo} /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/rPtr
add wave -noupdate -expand -group xgs_mono_pipeline -group {output fifo} /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/rPtrNxt
add wave -noupdate -expand -group xgs_mono_pipeline -group {output fifo} /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/rPtrGray
add wave -noupdate -expand -group xgs_mono_pipeline -group {output fifo} /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/rPtrGrayNxt
add wave -noupdate -expand -group xgs_mono_pipeline -group {output fifo} /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/rWrPtrGray
add wave -noupdate -expand -group xgs_mono_pipeline -group {output fifo} /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/rWrPtrGray_Meta
add wave -noupdate -expand -group xgs_mono_pipeline -group {output fifo} /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/rEmptyInt
add wave -noupdate -expand -group xgs_mono_pipeline -group {output fifo} /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/rFiFoRdEn
add wave -noupdate -expand -group xgs_mono_pipeline -divider {ACLK DOMAIN}
add wave -noupdate -expand -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk
add wave -noupdate -expand -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_reset_n
add wave -noupdate -expand -group xgs_mono_pipeline -expand -group {FiFo read I/F} -color {Sky Blue} /testbench/DUT/xgs_mono_pipeline_inst/aclk_empty
add wave -noupdate -expand -group xgs_mono_pipeline -expand -group {FiFo read I/F} /testbench/DUT/xgs_mono_pipeline_inst/aclk_read
add wave -noupdate -expand -group xgs_mono_pipeline -expand -group {FiFo read I/F} /testbench/DUT/xgs_mono_pipeline_inst/aclk_read_data
add wave -noupdate -expand -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_state
add wave -noupdate -expand -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_read_data_valid
add wave -noupdate -expand -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_tvalid_int
add wave -noupdate -expand -group xgs_mono_pipeline -group {AXI Stream Output I/F} /testbench/DUT/xgs_mono_pipeline_inst/aclk_tready
add wave -noupdate -expand -group xgs_mono_pipeline -group {AXI Stream Output I/F} /testbench/DUT/xgs_mono_pipeline_inst/aclk_tvalid
add wave -noupdate -expand -group xgs_mono_pipeline -group {AXI Stream Output I/F} -color Magenta /testbench/DUT/xgs_mono_pipeline_inst/aclk_tlast
add wave -noupdate -expand -group xgs_mono_pipeline -group {AXI Stream Output I/F} /testbench/DUT/xgs_mono_pipeline_inst/aclk_tuser
add wave -noupdate -expand -group xgs_mono_pipeline -group {AXI Stream Output I/F} -color Pink /testbench/DUT/xgs_mono_pipeline_inst/aclk_acknowledge
add wave -noupdate -expand -group xgs_mono_pipeline -group {AXI Stream Output I/F} /testbench/DUT/xgs_mono_pipeline_inst/aclk_tdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 3} {1154929533 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 185
configure wave -valuecolwidth 148
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
configure wave -timelineunits us
update
WaveRestoreZoom {1018189625 ps} {1244962775 ps}
