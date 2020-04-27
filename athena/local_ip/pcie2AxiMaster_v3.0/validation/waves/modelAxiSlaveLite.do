onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider ModelAXISlave
add wave -noupdate /testbench/axiSlave/MEM_DEPTH
add wave -noupdate /testbench/axiSlave/axi_clk
add wave -noupdate /testbench/axiSlave/axi_reset_n
add wave -noupdate -divider {AXI Write Address Channel}
add wave -noupdate /testbench/axiSlave/axi_awvalid
add wave -noupdate /testbench/axiSlave/axi_awready
add wave -noupdate /testbench/axiSlave/axi_awprot
add wave -noupdate /testbench/axiSlave/axi_awaddr
add wave -noupdate -divider {AXI Write Data Channel}
add wave -noupdate /testbench/axiSlave/axi_wvalid
add wave -noupdate /testbench/axiSlave/axi_wready
add wave -noupdate /testbench/axiSlave/axi_wstrb
add wave -noupdate /testbench/axiSlave/axi_wdata
add wave -noupdate /testbench/axiSlave/axi_bready
add wave -noupdate -divider {AXI Write Response Channel}
add wave -noupdate /testbench/axiSlave/axi_bvalid
add wave -noupdate /testbench/axiSlave/axi_bresp
add wave -noupdate -divider {AXI Read address Channel}
add wave -noupdate /testbench/axiSlave/axi_arvalid
add wave -noupdate /testbench/axiSlave/axi_arready
add wave -noupdate /testbench/axiSlave/axi_arprot
add wave -noupdate /testbench/axiSlave/axi_araddr
add wave -noupdate /testbench/axiSlave/axi_rready
add wave -noupdate /testbench/axiSlave/axi_rvalid
add wave -noupdate /testbench/axiSlave/axi_rdata
add wave -noupdate /testbench/axiSlave/axi_rresp
add wave -noupdate -divider {AXI Read address Channel}
add wave -noupdate /testbench/axiSlave/reg_write
add wave -noupdate /testbench/axiSlave/reg_read
add wave -noupdate /testbench/axiSlave/reg_addr
add wave -noupdate /testbench/axiSlave/reg_beN
add wave -noupdate /testbench/axiSlave/reg_writedata
add wave -noupdate /testbench/axiSlave/reg_readdataValid
add wave -noupdate /testbench/axiSlave/reg_readdata
add wave -noupdate -divider {AXI Read address Channel}
add wave -noupdate /testbench/axiSlave/ram
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {49595211314 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 224
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
WaveRestoreZoom {45123152503 fs} {50510504285 fs}
