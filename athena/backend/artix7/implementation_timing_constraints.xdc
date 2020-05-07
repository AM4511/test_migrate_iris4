set_operating_conditions -process maximum
set_load 10.000 [all_outputs]
set_property LOAD 10 [get_ports cfg_spi_cs_n]
set_property LOAD 10 [get_ports {cfg_spi_sd[0]}]
set_property LOAD 10 [get_ports {cfg_spi_sd[1]}]
set_property LOAD 10 [get_ports {cfg_spi_sd[2]}]
set_property LOAD 10 [get_ports {cfg_spi_sd[3]}]
set_property LOAD 10 [get_ports {debug_data[0]}]
set_property LOAD 10 [get_ports {debug_data[1]}]
set_property LOAD 10 [get_ports {debug_data[2]}]
set_property LOAD 10 [get_ports {debug_data[3]}]
set_property LOAD 10 [get_ports exposure_out]
set_property LOAD 10 [get_ports {led_out[0]}]
set_property LOAD 10 [get_ports {led_out[1]}]
set_property LOAD 10 [get_ports {pcie_tx_n[0]}]
set_property LOAD 10 [get_ports {pcie_tx_p[0]}]
set_property LOAD 10 [get_ports smbclk]
set_property LOAD 10 [get_ports smbdata]
set_property LOAD 10 [get_ports strobe_out]
set_property LOAD 10 [get_ports trig_rdy_out]
set_property LOAD 10 [get_ports xgs_clk_pll_en]
set_property LOAD 10 [get_ports xgs_cs_n]
set_property LOAD 10 [get_ports xgs_fwsi_en]
set_property LOAD 10 [get_ports xgs_reset_n]
set_property LOAD 10 [get_ports xgs_sclk]
set_property LOAD 10 [get_ports xgs_sdout]
set_property LOAD 10 [get_ports xgs_trig_int]
set_property LOAD 10 [get_ports xgs_trig_rd]
set_operating_conditions -ambient_temp 85.0
set_operating_conditions -airflow 0
set_operating_conditions -board_layers 8to11
set_operating_conditions -board small
set_operating_conditions -heatsink none














