
create_clock -period 10.000 -name ref_clk -waveform {0.000 5.000} [get_ports ref_clk]
create_clock -period 10.000 -name pcie_clk_p -waveform {0.000 5.000} [get_ports pcie_clk_p]


create_clock -period 2.570 -name {xgs_hispi_sclk_p[0]} -waveform {0.000 1.285} [get_ports {xgs_hispi_sclk_p[0]}]
create_clock -period 2.570 -name {xgs_hispi_sclk_p[1]} -waveform {0.000 1.285} [get_ports {xgs_hispi_sclk_p[1]}]



set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[0]}] -clock_fall -min -add_delay 1.440 [get_ports {xgs_hispi_sdata_n[*]}]
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[0]}] -clock_fall -max -add_delay 1.490 [get_ports {xgs_hispi_sdata_n[*]}]
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[0]}] -min -add_delay 1.440 [get_ports {xgs_hispi_sdata_n[*]}]
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[0]}] -max -add_delay 1.490 [get_ports {xgs_hispi_sdata_n[*]}]

set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[1]}] -clock_fall -min -add_delay 1.440 [get_ports {xgs_hispi_sdata_n[*]}]
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[1]}] -clock_fall -max -add_delay 1.490 [get_ports {xgs_hispi_sdata_n[*]}]
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[1]}] -min -add_delay 1.440 [get_ports {xgs_hispi_sdata_n[*]}]
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[1]}] -max -add_delay 1.490 [get_ports {xgs_hispi_sdata_n[*]}]


# Rename generated clock
set SYSTEM_PLL "xsystem_pb_wrapper/system_pb_i/clk_wiz_0/inst/plle2_adv_inst"
create_generated_clock -name idly_clk -source [get_pins ${SYSTEM_PLL}/CLKIN1] -master_clock [get_clocks ref_clk] [get_pins ${SYSTEM_PLL}/CLKOUT0]
create_generated_clock -name qspi_clk -source [get_pins ${SYSTEM_PLL}/CLKIN1] -master_clock [get_clocks ref_clk] [get_pins ${SYSTEM_PLL}/CLKOUT1]

# create_generated_clock -name hispi_clk_bottom -source [get_pins xsystem_pb_wrapper/system_pb_i/hispi_line_writer/axiHiSPi_0/U0/xhispi_top/bottom_hispi_phy/xhispi_serdes/xhispi_phy_xilinx/inst/clkout_buf_inst/I] -master_clock [get_clocks xgs_hispi_sclk_p[1]] [get_pins xsystem_pb_wrapper/system_pb_i/hispi_line_writer/axiHiSPi_0/U0/xhispi_top/bottom_hispi_phy/xhispi_serdes/xhispi_phy_xilinx/inst/clkout_buf_inst/O]

# create_generated_clock -name hispi_clk_top -source [get_pins xsystem_pb_wrapper/system_pb_i/hispi_line_writer/axiHiSPi_0/U0/xhispi_top/top_hispi_phy/xhispi_serdes/xhispi_phy_xilinx/inst/clkout_buf_inst/I] -master_clock [get_clocks xgs_hispi_sclk_p[0]] [get_pins xsystem_pb_wrapper/system_pb_i/hispi_line_writer/axiHiSPi_0/U0/xhispi_top/top_hispi_phy/xhispi_serdes/xhispi_phy_xilinx/inst/clkout_buf_inst/O]



# Timing exceptions
set_false_path -from [get_ports sys_rst_n]
set_clock_groups -asynchronous -group [get_clocks xgs_hispi_sclk_p[1]] -group [get_clocks xgs_hispi_sclk_p[0]]
#set_clock_groups -asynchronous -group [get_clocks hispi_clk_bottom] -group [get_clocks hispi_clk_top]


