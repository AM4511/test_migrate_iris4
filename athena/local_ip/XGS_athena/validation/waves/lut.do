onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/DUT/xaxi_lut/axi_clk
add wave -noupdate /testbench/DUT/xaxi_lut/axi_reset_n
add wave -noupdate -color Yellow /testbench/DUT/xaxi_lut/s_axis_tvalid
add wave -noupdate -color Yellow /testbench/DUT/xaxi_lut/s_axis_tready
add wave -noupdate -color Yellow /testbench/DUT/xaxi_lut/s_axis_tlast
add wave -noupdate -color Yellow /testbench/DUT/xaxi_lut/s_axis_tuser
add wave -noupdate -color Yellow /testbench/DUT/xaxi_lut/s_axis_tdata
add wave -noupdate /testbench/DUT/xaxi_lut/axis_line_done
add wave -noupdate /testbench/DUT/xaxi_lut/axis_firstdata_done
add wave -noupdate -color Magenta /testbench/DUT/xaxi_lut/m_axis_tvalid
add wave -noupdate -color Magenta /testbench/DUT/xaxi_lut/m_axis_tready
add wave -noupdate -color Magenta /testbench/DUT/xaxi_lut/m_axis_tdata
add wave -noupdate -color Magenta /testbench/DUT/xaxi_lut/m_axis_tuser
add wave -noupdate -color Magenta /testbench/DUT/xaxi_lut/m_axis_tlast
add wave -noupdate /testbench/DUT/xaxi_lut/regfile
add wave -noupdate /testbench/DUT/xaxi_lut/RAM_W_enable
add wave -noupdate /testbench/DUT/xaxi_lut/RAM_W_address
add wave -noupdate /testbench/DUT/xaxi_lut/RAM_W_data
add wave -noupdate /testbench/DUT/xaxi_lut/RAM_R_enable
add wave -noupdate /testbench/DUT/xaxi_lut/RAM_R_address
add wave -noupdate /testbench/DUT/xaxi_lut/RAM_R_data
add wave -noupdate /testbench/DUT/xaxi_lut/s_axis_tdata_p1
add wave -noupdate /testbench/DUT/xaxi_lut/s_axis_tready_int
add wave -noupdate /testbench/DUT/xaxi_lut/m_axis_tvalid_int
add wave -noupdate /testbench/DUT/xaxi_lut/m_axis_tdata_int
add wave -noupdate /testbench/DUT/xaxi_lut/m_axis_tuser_int
add wave -noupdate /testbench/DUT/xaxi_lut/m_axis_tlast_int
add wave -noupdate /testbench/DUT/xaxi_lut/axi_pipeline
add wave -noupdate /testbench/DUT/xaxi_lut/buffer_tdata
add wave -noupdate /testbench/DUT/xaxi_lut/buffer_tuser
add wave -noupdate /testbench/DUT/xaxi_lut/buffer_tlast
add wave -noupdate -divider {New Divider}
add wave -noupdate /testbench/DUT/dcp_tvalid
add wave -noupdate /testbench/DUT/dcp_tready
add wave -noupdate /testbench/DUT/dcp_tdata
add wave -noupdate /testbench/DUT/dcp_tuser
add wave -noupdate /testbench/DUT/dcp_tlast
add wave -noupdate /testbench/DUT/lut_tvalid
add wave -noupdate /testbench/DUT/lut_tuser
add wave -noupdate /testbench/DUT/lut_tready
add wave -noupdate /testbench/DUT/lut_tlast
add wave -noupdate /testbench/DUT/lut_tdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1209608000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 232
configure wave -valuecolwidth 149
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
WaveRestoreZoom {1209349539 ps} {1209836631 ps}
