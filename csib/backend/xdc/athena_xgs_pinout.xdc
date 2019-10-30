
set_property PACKAGE_PIN A16 [get_ports ref_clk]
set_property PACKAGE_PIN C16 [get_ports {hispi_data_p[1]}]
set_property PACKAGE_PIN B16 [get_ports {hispi_data_n[1]}]
set_property PACKAGE_PIN V13 [get_ports {hispi_data_p[2]}]
set_property PACKAGE_PIN V14 [get_ports {hispi_data_n[2]}]
set_property PACKAGE_PIN V15 [get_ports {hispi_data_p[5]}]
set_property PACKAGE_PIN W15 [get_ports {hispi_data_n[5]}]
set_property PACKAGE_PIN W13 [get_ports {hispi_data_p[4]}]
set_property PACKAGE_PIN W14 [get_ports {hispi_data_n[4]}]
set_property PACKAGE_PIN C15 [get_ports {hispi_serial_clk_p[0]}]
set_property PACKAGE_PIN B15 [get_ports {hispi_serial_clk_n[0]}]
set_property PACKAGE_PIN V17 [get_ports {spi_sd[3]}]
set_property PACKAGE_PIN M18 [get_ports {hispi_serial_clk_p[5]}]
set_property PACKAGE_PIN M19 [get_ports {hispi_serial_clk_n[5]}]
set_property PACKAGE_PIN W16 [get_ports {spi_sd[2]}]
set_property PACKAGE_PIN W17 [get_ports {spi_sd[1]}]
set_property PACKAGE_PIN U14 [get_ports {spi_sd[0]}]
set_property PACKAGE_PIN N17 [get_ports {hispi_serial_clk_p[4]}]
set_property PACKAGE_PIN P17 [get_ports {hispi_serial_clk_n[4]}]
set_property PACKAGE_PIN C17 [get_ports {hispi_serial_clk_p[1]}]
set_property PACKAGE_PIN B17 [get_ports {hispi_serial_clk_n[1]}]
set_property PACKAGE_PIN L17 [get_ports {hispi_serial_clk_p[3]}]
set_property PACKAGE_PIN K17 [get_ports {hispi_serial_clk_n[3]}]
set_property PACKAGE_PIN P18 [get_ports {hispi_serial_clk_p[2]}]
set_property PACKAGE_PIN R18 [get_ports {hispi_serial_clk_n[2]}]
set_property PACKAGE_PIN U15 [get_ports {hispi_data_p[3]}]
set_property PACKAGE_PIN U16 [get_ports {hispi_data_n[3]}]
set_property PACKAGE_PIN B18 [get_ports {hispi_data_p[0]}]
set_property PACKAGE_PIN A18 [get_ports {hispi_data_n[0]}]
set_property PACKAGE_PIN U18 [get_ports sys_rst_n]
set_property PACKAGE_PIN B8 [get_ports pcie_sys_clk_p]
set_property PACKAGE_PIN A8 [get_ports pcie_sys_clk_n]
set_property PACKAGE_PIN V16 [get_ports spi_cs_n]


set_property IOSTANDARD LVCMOS18 [get_ports ref_clk]

set_property IOSTANDARD LVDS_25 [get_ports {hispi_serial_clk_p[*]}]
set_property DIFF_TERM false [get_ports {hispi_serial_clk_p[*]}]

set_property IOSTANDARD LVDS_25 [get_ports {hispi_data_n[*]}]
set_property DIFF_TERM false [get_ports {hispi_data_n[*]}]

set_property IOSTANDARD LVCMOS18 [get_ports sys_rst_n]
set_property IOSTANDARD LVCMOS18 [get_ports {spi_sd[*]}]
set_property DRIVE 12 [get_ports {spi_sd[*]}]
set_property SLEW SLOW [get_ports {spi_sd[*]}]

set_property IOSTANDARD LVCMOS18 [get_ports spi_cs_n]
set_property DRIVE 12 [get_ports spi_cs_n]
set_property SLEW SLOW [get_ports spi_cs_n]

