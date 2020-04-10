onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {DMAWr Sub2}
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub2_0/sysrstN
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub2_0/sysclk
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub2_0/LSBOF
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub2_0/intevent
add wave -noupdate -divider {register File}
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub2_0/reg_cs
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub2_0/reg_read
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub2_0/reg_write
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub2_0/reg_addr
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub2_0/reg_readdata
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub2_0/reg_writedata
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub2_0/reg_beN
add wave -noupdate -radix hexadecimal -childformat {{/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.header -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user -radix hexadecimal -childformat {{/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstfstart -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstlnpitch -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstlnsize -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstnbline -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstfstart1 -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstfstart2 -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstfstart3 -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl -radix hexadecimal -childformat {{/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.rsvd0 -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.bufclr -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.dte3 -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.dte2 -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.dte1 -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.dte0 -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.bitwdth -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.nbcontx -radix hexadecimal -childformat {{/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.nbcontx(1) -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.nbcontx(0) -radix hexadecimal}}}}} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstclrptrn -radix hexadecimal}}}} -subitemconfig {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.header {-radix hexadecimal} /testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user {-radix hexadecimal -childformat {{/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstfstart -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstlnpitch -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstlnsize -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstnbline -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstfstart1 -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstfstart2 -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstfstart3 -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl -radix hexadecimal -childformat {{/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.rsvd0 -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.bufclr -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.dte3 -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.dte2 -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.dte1 -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.dte0 -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.bitwdth -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.nbcontx -radix hexadecimal -childformat {{/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.nbcontx(1) -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.nbcontx(0) -radix hexadecimal}}}}} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstclrptrn -radix hexadecimal}} -expand} /testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstfstart {-radix hexadecimal} /testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstlnpitch {-radix hexadecimal} /testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstlnsize {-radix hexadecimal} /testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstnbline {-radix hexadecimal} /testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstfstart1 {-radix hexadecimal} /testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstfstart2 {-radix hexadecimal} /testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstfstart3 {-radix hexadecimal} /testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl {-radix hexadecimal -childformat {{/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.rsvd0 -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.bufclr -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.dte3 -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.dte2 -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.dte1 -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.dte0 -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.bitwdth -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.nbcontx -radix hexadecimal -childformat {{/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.nbcontx(1) -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.nbcontx(0) -radix hexadecimal}}}} -expand} /testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.rsvd0 {-radix hexadecimal} /testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.bufclr {-radix hexadecimal} /testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.dte3 {-radix hexadecimal} /testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.dte2 {-radix hexadecimal} /testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.dte1 {-radix hexadecimal} /testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.dte0 {-radix hexadecimal} /testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.bitwdth {-radix hexadecimal} /testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.nbcontx {-radix hexadecimal -childformat {{/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.nbcontx(1) -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.nbcontx(0) -radix hexadecimal}} -expand} /testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.nbcontx(1) {-radix hexadecimal} /testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstctrl.nbcontx(0) {-radix hexadecimal} /testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile.user.dstclrptrn {-radix hexadecimal}} /testbench/xavalon_system/dmawr_sub2_0/xdmawr_sram_top/xdmawr_core/xregfile_dmawr/regfile
add wave -noupdate -divider {Stream Input Port}
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub2_0/si0_wait
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub2_0/si0_write
add wave -noupdate -radix hexadecimal -childformat {{/testbench/xavalon_system/dmawr_sub2_0/si0_addr(10) -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/si0_addr(9) -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/si0_addr(8) -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/si0_addr(7) -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/si0_addr(6) -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/si0_addr(5) -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/si0_addr(4) -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/si0_addr(3) -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/si0_addr(2) -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/si0_addr(1) -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/si0_addr(0) -radix hexadecimal}} -subitemconfig {/testbench/xavalon_system/dmawr_sub2_0/si0_addr(10) {-height 15 -radix hexadecimal} /testbench/xavalon_system/dmawr_sub2_0/si0_addr(9) {-height 15 -radix hexadecimal} /testbench/xavalon_system/dmawr_sub2_0/si0_addr(8) {-height 15 -radix hexadecimal} /testbench/xavalon_system/dmawr_sub2_0/si0_addr(7) {-height 15 -radix hexadecimal} /testbench/xavalon_system/dmawr_sub2_0/si0_addr(6) {-height 15 -radix hexadecimal} /testbench/xavalon_system/dmawr_sub2_0/si0_addr(5) {-height 15 -radix hexadecimal} /testbench/xavalon_system/dmawr_sub2_0/si0_addr(4) {-height 15 -radix hexadecimal} /testbench/xavalon_system/dmawr_sub2_0/si0_addr(3) {-height 15 -radix hexadecimal} /testbench/xavalon_system/dmawr_sub2_0/si0_addr(2) {-height 15 -radix hexadecimal} /testbench/xavalon_system/dmawr_sub2_0/si0_addr(1) {-height 15 -radix hexadecimal} /testbench/xavalon_system/dmawr_sub2_0/si0_addr(0) {-height 15 -radix hexadecimal}} /testbench/xavalon_system/dmawr_sub2_0/si0_addr
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub2_0/si0_data
add wave -noupdate -radix hexadecimal -childformat {{/testbench/xavalon_system/dmawr_sub2_0/si0_beN(7) -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/si0_beN(6) -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/si0_beN(5) -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/si0_beN(4) -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/si0_beN(3) -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/si0_beN(2) -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/si0_beN(1) -radix hexadecimal} {/testbench/xavalon_system/dmawr_sub2_0/si0_beN(0) -radix hexadecimal}} -subitemconfig {/testbench/xavalon_system/dmawr_sub2_0/si0_beN(7) {-height 15 -radix hexadecimal} /testbench/xavalon_system/dmawr_sub2_0/si0_beN(6) {-height 15 -radix hexadecimal} /testbench/xavalon_system/dmawr_sub2_0/si0_beN(5) {-height 15 -radix hexadecimal} /testbench/xavalon_system/dmawr_sub2_0/si0_beN(4) {-height 15 -radix hexadecimal} /testbench/xavalon_system/dmawr_sub2_0/si0_beN(3) {-height 15 -radix hexadecimal} /testbench/xavalon_system/dmawr_sub2_0/si0_beN(2) {-height 15 -radix hexadecimal} /testbench/xavalon_system/dmawr_sub2_0/si0_beN(1) {-height 15 -radix hexadecimal} /testbench/xavalon_system/dmawr_sub2_0/si0_beN(0) {-height 15 -radix hexadecimal}} /testbench/xavalon_system/dmawr_sub2_0/si0_beN
add wave -noupdate -divider {SRAM 0}
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub2_0/sw0_wait
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub2_0/sw0_writeN
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub2_0/sw0_addr
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub2_0/sw0_beN
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub2_0/sw0_data
add wave -noupdate -divider {SRAM 1}
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub2_0/sw1_wait
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub2_0/sw1_writeN
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub2_0/sw1_addr
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub2_0/sw1_beN
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub2_0/sw1_data
add wave -noupdate -divider {SRAM 2}
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub2_0/sw2_wait
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub2_0/sw2_writeN
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub2_0/sw2_addr
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub2_0/sw2_beN
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub2_0/sw2_data
add wave -noupdate -divider {SRAM 3}
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub2_0/sw3_wait
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub2_0/sw3_writeN
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub2_0/sw3_addr
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub2_0/sw3_beN
add wave -noupdate -radix hexadecimal /testbench/xavalon_system/dmawr_sub2_0/sw3_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3933700 ps} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 136
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
WaveRestoreZoom {3850400 ps} {4767100 ps}
