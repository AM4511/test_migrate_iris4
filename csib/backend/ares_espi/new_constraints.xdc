create_clock -period 10.000 -name pcie_sys_clk_p -waveform {0.000 5.000} [get_ports pcie_sys_clk_p]
create_generated_clock -name xsystem_pb_wrapper/system_pb_i/profinet_system/sect_profinet/mii_to_rmii_0/U0/rmii2mac_rx_clk -source [get_pins xsystem_pb_wrapper/system_pb_i/clk_wiz_0/inst/plle2_adv_inst/CLKOUT1] -divide_by 2 [get_pins xsystem_pb_wrapper/system_pb_i/profinet_system/sect_profinet/mii_to_rmii_0/U0/rmii2mac_rx_clk_bi_reg/Q]
create_generated_clock -name xsystem_pb_wrapper/system_pb_i/profinet_system/sect_profinet/mii_to_rmii_0/U0/rmii2mac_tx_clk -source [get_pins xsystem_pb_wrapper/system_pb_i/clk_wiz_0/inst/plle2_adv_inst/CLKOUT1] -divide_by 2 [get_pins xsystem_pb_wrapper/system_pb_i/profinet_system/sect_profinet/mii_to_rmii_0/U0/rmii2mac_tx_clk_bi_reg/Q]

set_property PACKAGE_PIN U17 [get_ports {fpga_straps[0]}]
set_property PACKAGE_PIN U18 [get_ports {fpga_straps[1]}]
set_property PACKAGE_PIN U19 [get_ports {fpga_straps[2]}]
set_property PACKAGE_PIN V19 [get_ports {fpga_straps[3]}]

set_property IOSTANDARD LVCMOS33 [get_ports rmii_clk_out]
set_property PACKAGE_PIN N3 [get_ports rmii_clk_out]
