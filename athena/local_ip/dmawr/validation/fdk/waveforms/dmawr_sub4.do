onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {DMA Write sub 4}
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub4_0/sysclk
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub4_0/sysrstN
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub4_0/intevent
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub4_0/LSBOF
add wave -noupdate -divider {Register I/F}
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub4_0/reg_cs
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub4_0/reg_read
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub4_0/reg_write
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub4_0/reg_addr
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub4_0/reg_beN
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub4_0/reg_writedata
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub4_0/reg_readdata
add wave -noupdate -divider {Stream input I/F}
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub4_0/sd_wait
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub4_0/si0_write
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub4_0/si0_addr
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub4_0/si0_beN
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub4_0/si0_data
add wave -noupdate -divider {SDRAM I/F}
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub4_0/si0_wait
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub4_0/sd_write
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub4_0/sd_addr
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub4_0/sd_writebeN
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub4_0/sd_writedata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4350100 ps} 0}
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
configure wave -timelineunits ns
update
WaveRestoreZoom {2738600 ps} {5477100 ps}
