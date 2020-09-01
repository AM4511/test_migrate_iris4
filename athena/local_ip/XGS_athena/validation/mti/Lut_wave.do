onerror {resume}
quietly virtual signal -install /testbench/DUT/xaxi_lut { (context /testbench/DUT/xaxi_lut )( s_axis_tdata(79 downto 72) & s_axis_tdata(69 downto 62) & s_axis_tdata(59 downto 52) & s_axis_tdata(49 downto 42) & s_axis_tdata(39 downto 32) & s_axis_tdata(29 downto 22) & s_axis_tdata(19 downto 12) & s_axis_tdata(9 downto 2) )} s_axis_tdata64
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/DUT/xaxi_lut/axi_clk
add wave -noupdate /testbench/DUT/xaxi_lut/axi_reset_n
add wave -noupdate -color Magenta /testbench/DUT/xaxi_lut/s_axis_tvalid
add wave -noupdate -color Magenta /testbench/DUT/xaxi_lut/s_axis_tready
add wave -noupdate -color Magenta /testbench/DUT/xaxi_lut/s_axis_tuser
add wave -noupdate -color Magenta /testbench/DUT/xaxi_lut/s_axis_tlast
add wave -noupdate -color Magenta /testbench/DUT/xaxi_lut/s_axis_tdata
add wave -noupdate /testbench/DUT/xaxi_lut/s_axis_tdata64
add wave -noupdate /testbench/DUT/xaxi_lut/axi_state
add wave -noupdate -color Cyan /testbench/DUT/xaxi_lut/RAM_R_enable
add wave -noupdate -color Yellow /testbench/DUT/xaxi_lut/m_axis_tvalid
add wave -noupdate -color Yellow /testbench/DUT/xaxi_lut/m_axis_tready
add wave -noupdate -color Yellow /testbench/DUT/xaxi_lut/m_axis_tdata
add wave -noupdate -color Yellow /testbench/DUT/xaxi_lut/m_axis_tlast
add wave -noupdate -color Yellow /testbench/DUT/xaxi_lut/m_axis_tuser
add wave -noupdate /testbench/XGS_imageSRC
add wave -noupdate /testbench/DUT/xaxi_lut/regfile
add wave -noupdate /testbench/DUT/xaxi_lut/RAM_W_enable
add wave -noupdate /testbench/DUT/xaxi_lut/RAM_W_address
add wave -noupdate /testbench/DUT/xaxi_lut/RAM_W_data
add wave -noupdate -color Cyan /testbench/DUT/xaxi_lut/RAM_R_address
add wave -noupdate -color Cyan /testbench/DUT/xaxi_lut/RAM_R_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1209727699 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {1209446191 ps} {1209809716 ps}
