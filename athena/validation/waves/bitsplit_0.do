onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group {Bit split 0} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/top_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/hispi_clk
add wave -noupdate -group {Bit split 0} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/top_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/hispi_reset
add wave -noupdate -group {Bit split 0} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/top_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/idle_character
add wave -noupdate -group {Bit split 0} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/top_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/hispi_phy_en
add wave -noupdate -group {Bit split 0} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/top_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/input_data
add wave -noupdate -group {Bit split 0} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/top_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/hispi_shift_register
add wave -noupdate -group {Bit split 0} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/top_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/hispi_lsb_ptr
add wave -noupdate -group {Bit split 0} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/top_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/hispi_lsb_ptr_reg
add wave -noupdate -group {Bit split 0} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/top_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/hispi_aligned_data_mux
add wave -noupdate -group {Bit split 0} -color Gold /testbench_athena/DUT/system_i/axiHiSPi_0/U0/top_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/idle_detected
add wave -noupdate -group {Bit split 0} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/top_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/load_data
add wave -noupdate -group {Bit split 0} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/top_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/hispi_clk_div2
add wave -noupdate -group {Bit split 0} -expand -group {Output Pixel I/F} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/top_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/pix_clk
add wave -noupdate -group {Bit split 0} -expand -group {Output Pixel I/F} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/top_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/xbit_split/pix_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {883647549 ps} 1} {{Cursor 2} {887197425 ps} 1} {{Cursor 3} {883658371 ps} 0}
quietly wave cursor active 3
configure wave -namecolwidth 210
configure wave -valuecolwidth 254
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
WaveRestoreZoom {883550157 ps} {884023343 ps}
