
## Power analysis
set_load 10.000 [all_outputs]
set_property LOAD 10 [get_ports spi_cs_n]
set_property LOAD 10 [get_ports {spi_sd[0]}]
set_property LOAD 10 [get_ports {spi_sd[1]}]
set_property LOAD 10 [get_ports {spi_sd[2]}]
set_property LOAD 10 [get_ports {spi_sd[3]}]
set_operating_conditions -ambient_temp 85.0
set_operating_conditions -board_layers 8to11
set_operating_conditions -board small
set_operating_conditions -heatsink high

