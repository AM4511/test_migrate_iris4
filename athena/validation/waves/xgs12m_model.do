onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group XGS12m_model /testbench_athena/DUT/system_i/xgs12m_model_0/RESET_B
add wave -noupdate -expand -group XGS12m_model /testbench_athena/DUT/system_i/xgs12m_model_0/FWSI_EN
add wave -noupdate -expand -group XGS12m_model /testbench_athena/DUT/system_i/xgs12m_model_0/TRIGGER_INT
add wave -noupdate -expand -group XGS12m_model -group {HiSPi I/F} /testbench_athena/DUT/system_i/xgs12m_model_0/hispi_io_clk_p
add wave -noupdate -expand -group XGS12m_model -group {HiSPi I/F} /testbench_athena/DUT/system_i/xgs12m_model_0/hispi_io_clk_n
add wave -noupdate -expand -group XGS12m_model -group {HiSPi I/F} /testbench_athena/DUT/system_i/xgs12m_model_0/hispi_io_data_p
add wave -noupdate -expand -group XGS12m_model -group {HiSPi I/F} /testbench_athena/DUT/system_i/xgs12m_model_0/hispi_io_data_n
add wave -noupdate -expand -group XGS12m_model -group {SPI I/F} /testbench_athena/DUT/system_i/xgs12m_model_0/SCLK
add wave -noupdate -expand -group XGS12m_model -group {SPI I/F} /testbench_athena/DUT/system_i/xgs12m_model_0/CS
add wave -noupdate -expand -group XGS12m_model -group {SPI I/F} /testbench_athena/DUT/system_i/xgs12m_model_0/SDATA
add wave -noupdate -expand -group XGS12m_model -group {SPI I/F} /testbench_athena/DUT/system_i/xgs12m_model_0/SDATAOUT
add wave -noupdate -expand -group XGS12m_model -group Monitor /testbench_athena/DUT/system_i/xgs12m_model_0/MONITOR0
add wave -noupdate -expand -group XGS12m_model -group Monitor /testbench_athena/DUT/system_i/xgs12m_model_0/MONITOR1
add wave -noupdate -expand -group XGS12m_model -group Monitor /testbench_athena/DUT/system_i/xgs12m_model_0/MONITOR2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {168467665 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 210
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
configure wave -timeline 1
configure wave -timelineunits ns
update
WaveRestoreZoom {227697362 ps} {959098490 ps}
