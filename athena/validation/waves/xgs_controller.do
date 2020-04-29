onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {AXI XGS Controller}
add wave -noupdate /testbench_athena/DUT/system_i/axiXGS_controller_0/xgs_reset_n
add wave -noupdate /testbench_athena/DUT/system_i/axiXGS_controller_0/xgs_fwsi_en
add wave -noupdate /testbench_athena/DUT/system_i/axiXGS_controller_0/xgs_power_good
add wave -noupdate /testbench_athena/DUT/system_i/axiXGS_controller_0/xgs_clk_pll_en
add wave -noupdate -expand -group {SPI I/F} /testbench_athena/DUT/system_i/axiXGS_controller_0/xgs_sclk
add wave -noupdate -expand -group {SPI I/F} /testbench_athena/DUT/system_i/axiXGS_controller_0/xgs_cs_n
add wave -noupdate -expand -group {SPI I/F} /testbench_athena/DUT/system_i/axiXGS_controller_0/xgs_sdin
add wave -noupdate -expand -group {SPI I/F} /testbench_athena/DUT/system_i/axiXGS_controller_0/xgs_sdout
add wave -noupdate /testbench_athena/DUT/system_i/axiXGS_controller_0/xgs_trig_int
add wave -noupdate /testbench_athena/DUT/system_i/axiXGS_controller_0/xgs_trig_rd
add wave -noupdate /testbench_athena/DUT/system_i/axiXGS_controller_0/xgs_monitor0
add wave -noupdate /testbench_athena/DUT/system_i/axiXGS_controller_0/xgs_monitor1
add wave -noupdate /testbench_athena/DUT/system_i/axiXGS_controller_0/xgs_monitor2
add wave -noupdate -expand -group {Ares I/F} /testbench_athena/DUT/system_i/axiXGS_controller_0/anput_ext_trig
add wave -noupdate -expand -group {Ares I/F} /testbench_athena/DUT/system_i/axiXGS_controller_0/anput_strobe_out
add wave -noupdate -expand -group {Ares I/F} /testbench_athena/DUT/system_i/axiXGS_controller_0/anput_exposure_out
add wave -noupdate -expand -group {Ares I/F} /testbench_athena/DUT/system_i/axiXGS_controller_0/anput_trig_rdy_out
add wave -noupdate /testbench_athena/DUT/system_i/axiXGS_controller_0/led_out
add wave -noupdate -expand -group {AXI Slave interface} /testbench_athena/DUT/system_i/axiXGS_controller_0/s_axi_aclk
add wave -noupdate -expand -group {AXI Slave interface} /testbench_athena/DUT/system_i/axiXGS_controller_0/s_axi_aresetn
add wave -noupdate -expand -group {AXI Slave interface} -group {Write Address Channel} /testbench_athena/DUT/system_i/axiXGS_controller_0/s_axi_awready
add wave -noupdate -expand -group {AXI Slave interface} -group {Write Address Channel} /testbench_athena/DUT/system_i/axiXGS_controller_0/s_axi_awvalid
add wave -noupdate -expand -group {AXI Slave interface} -group {Write Address Channel} /testbench_athena/DUT/system_i/axiXGS_controller_0/s_axi_awaddr
add wave -noupdate -expand -group {AXI Slave interface} -group {Write Address Channel} /testbench_athena/DUT/system_i/axiXGS_controller_0/s_axi_awprot
add wave -noupdate -expand -group {AXI Slave interface} -group {Write Data Channel} /testbench_athena/DUT/system_i/axiXGS_controller_0/s_axi_wready
add wave -noupdate -expand -group {AXI Slave interface} -group {Write Data Channel} /testbench_athena/DUT/system_i/axiXGS_controller_0/s_axi_wvalid
add wave -noupdate -expand -group {AXI Slave interface} -group {Write Data Channel} /testbench_athena/DUT/system_i/axiXGS_controller_0/s_axi_wstrb
add wave -noupdate -expand -group {AXI Slave interface} -group {Write Data Channel} /testbench_athena/DUT/system_i/axiXGS_controller_0/s_axi_wdata
add wave -noupdate -expand -group {AXI Slave interface} -group {Write Response Channel} /testbench_athena/DUT/system_i/axiXGS_controller_0/s_axi_bready
add wave -noupdate -expand -group {AXI Slave interface} -group {Write Response Channel} /testbench_athena/DUT/system_i/axiXGS_controller_0/s_axi_bvalid
add wave -noupdate -expand -group {AXI Slave interface} -group {Write Response Channel} /testbench_athena/DUT/system_i/axiXGS_controller_0/s_axi_bresp
add wave -noupdate -expand -group {AXI Slave interface} -group {Read Address Channel} /testbench_athena/DUT/system_i/axiXGS_controller_0/s_axi_arready
add wave -noupdate -expand -group {AXI Slave interface} -group {Read Address Channel} /testbench_athena/DUT/system_i/axiXGS_controller_0/s_axi_arvalid
add wave -noupdate -expand -group {AXI Slave interface} -group {Read Address Channel} /testbench_athena/DUT/system_i/axiXGS_controller_0/s_axi_araddr
add wave -noupdate -expand -group {AXI Slave interface} -group {Read Address Channel} /testbench_athena/DUT/system_i/axiXGS_controller_0/s_axi_arprot
add wave -noupdate -expand -group {AXI Slave interface} -group {Read Data Channel} /testbench_athena/DUT/system_i/axiXGS_controller_0/s_axi_rready
add wave -noupdate -expand -group {AXI Slave interface} -group {Read Data Channel} /testbench_athena/DUT/system_i/axiXGS_controller_0/s_axi_rvalid
add wave -noupdate -expand -group {AXI Slave interface} -group {Read Data Channel} /testbench_athena/DUT/system_i/axiXGS_controller_0/s_axi_rdata
add wave -noupdate -expand -group {AXI Slave interface} -group {Read Data Channel} /testbench_athena/DUT/system_i/axiXGS_controller_0/s_axi_rresp
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {14392880 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 205
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
configure wave -timelineunits ps
update
WaveRestoreZoom {8090032 ps} {21923965 ps}
