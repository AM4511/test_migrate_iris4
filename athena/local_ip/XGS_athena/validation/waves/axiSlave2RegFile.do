onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group axiSlave2RegFile /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/axi_clk
add wave -noupdate -group axiSlave2RegFile /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/axi_reset_n
add wave -noupdate -group axiSlave2RegFile -expand -group {Write Address Channel} /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/axi_awvalid
add wave -noupdate -group axiSlave2RegFile -expand -group {Write Address Channel} /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/axi_awready
add wave -noupdate -group axiSlave2RegFile -expand -group {Write Address Channel} /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/axi_awprot
add wave -noupdate -group axiSlave2RegFile -expand -group {Write Address Channel} /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/axi_awaddr
add wave -noupdate -group axiSlave2RegFile -expand -group {Write Data Channel} /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/axi_wvalid
add wave -noupdate -group axiSlave2RegFile -expand -group {Write Data Channel} /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/axi_wready
add wave -noupdate -group axiSlave2RegFile -expand -group {Write Data Channel} /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/axi_wstrb
add wave -noupdate -group axiSlave2RegFile -expand -group {Write Data Channel} /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/axi_wdata
add wave -noupdate -group axiSlave2RegFile -expand -group {Write Response Channel} /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/axi_bready
add wave -noupdate -group axiSlave2RegFile -expand -group {Write Response Channel} /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/axi_bvalid
add wave -noupdate -group axiSlave2RegFile -expand -group {Write Response Channel} /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/axi_bresp
add wave -noupdate -group axiSlave2RegFile -expand -group {Read Address Channel} /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/axi_arvalid
add wave -noupdate -group axiSlave2RegFile -expand -group {Read Address Channel} /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/axi_arready
add wave -noupdate -group axiSlave2RegFile -expand -group {Read Address Channel} /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/axi_arprot
add wave -noupdate -group axiSlave2RegFile -expand -group {Read Address Channel} /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/axi_araddr
add wave -noupdate -group axiSlave2RegFile -expand -group {Read Response Channel} /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/axi_rready
add wave -noupdate -group axiSlave2RegFile -expand -group {Read Response Channel} /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/axi_rvalid
add wave -noupdate -group axiSlave2RegFile -expand -group {Read Response Channel} /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/axi_rdata
add wave -noupdate -group axiSlave2RegFile -expand -group {Read Response Channel} /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/axi_rresp
add wave -noupdate -group axiSlave2RegFile -expand -group {Registerfile I/F} /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/reg_read
add wave -noupdate -group axiSlave2RegFile -expand -group {Registerfile I/F} /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/reg_write
add wave -noupdate -group axiSlave2RegFile -expand -group {Registerfile I/F} /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/reg_addr
add wave -noupdate -group axiSlave2RegFile -expand -group {Registerfile I/F} /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/reg_beN
add wave -noupdate -group axiSlave2RegFile -expand -group {Registerfile I/F} /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/reg_writedata
add wave -noupdate -group axiSlave2RegFile -expand -group {Registerfile I/F} /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/reg_readdataValid
add wave -noupdate -group axiSlave2RegFile -expand -group {Registerfile I/F} /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/reg_readdata
add wave -noupdate -group axiSlave2RegFile /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/nxtState
add wave -noupdate -group axiSlave2RegFile /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/state
add wave -noupdate -group axiSlave2RegFile /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/axi_awready_ff
add wave -noupdate -group axiSlave2RegFile /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/axi_wready_ff
add wave -noupdate -group axiSlave2RegFile /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/axi_bvalid_ff
add wave -noupdate -group axiSlave2RegFile /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/axi_arready_ff
add wave -noupdate -group axiSlave2RegFile /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/axi_rvalid_ff
add wave -noupdate -group axiSlave2RegFile /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/axi_aw_ack
add wave -noupdate -group axiSlave2RegFile /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/axi_w_ack
add wave -noupdate -group axiSlave2RegFile /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/axi_b_ack
add wave -noupdate -group axiSlave2RegFile /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/axi_ar_ack
add wave -noupdate -group axiSlave2RegFile /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/axi_r_ack
add wave -noupdate -group axiSlave2RegFile /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/timeout_cntr
add wave -noupdate -group axiSlave2RegFile /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/TIMEOUT_VALUE
add wave -noupdate -group axiSlave2RegFile /testbench_dmawr2tlp/DUT/xaxiSlave2RegFile/timeout_err
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {999915286 ps} 0} {{Cursor 2} {1124573 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 211
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
WaveRestoreZoom {11290969 ps} {11432055 ps}
