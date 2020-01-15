
set_property PACKAGE_PIN N3 [get_ports ref_clk]
set_property IOSTANDARD LVCMOS18 [get_ports ref_clk]

set_property PACKAGE_PIN G3 [get_ports sys_rst_n]
set_property PACKAGE_PIN D18 [get_ports {cfg_spi_sd[0]}]
set_property PACKAGE_PIN D19 [get_ports {cfg_spi_sd[1]}]
set_property PACKAGE_PIN G18 [get_ports {cfg_spi_sd[2]}]
set_property PACKAGE_PIN F18 [get_ports {cfg_spi_sd[3]}]
set_property PACKAGE_PIN K19 [get_ports cfg_spi_cs_n]
set_property PACKAGE_PIN B8 [get_ports pcie_clk_p]
set_property PACKAGE_PIN A8 [get_ports pcie_clk_n]
set_property PACKAGE_PIN N1 [get_ports {xgs_monitor[0]}]
set_property PACKAGE_PIN N2 [get_ports {xgs_monitor[1]}]
set_property PACKAGE_PIN M3 [get_ports {xgs_monitor[2]}]
set_property PACKAGE_PIN K3 [get_ports xgs_sdin]
set_property PACKAGE_PIN J3 [get_ports xgs_sdout]
set_property PACKAGE_PIN M2 [get_ports xgs_cs_n]
set_property PACKAGE_PIN M1 [get_ports xgs_sclk]
set_property PACKAGE_PIN R2 [get_ports xgs_reset_n]
set_property PACKAGE_PIN L2 [get_ports xgs_trig_rd]
set_property PACKAGE_PIN L3 [get_ports xgs_trig_int]
set_property PACKAGE_PIN H1 [get_ports xgs_fwsi_en]
set_property PACKAGE_PIN U3 [get_ports {xgs_hispi_sdata_p[0]}]
set_property PACKAGE_PIN U2 [get_ports {xgs_hispi_sdata_n[0]}]
set_property PACKAGE_PIN V2 [get_ports {xgs_hispi_sdata_p[1]}]
set_property PACKAGE_PIN W2 [get_ports {xgs_hispi_sdata_n[1]}]
set_property PACKAGE_PIN U5 [get_ports {xgs_hispi_sdata_p[2]}]
set_property PACKAGE_PIN V5 [get_ports {xgs_hispi_sdata_n[2]}]
set_property PACKAGE_PIN R3 [get_ports {xgs_hispi_sdata_p[3]}]
set_property PACKAGE_PIN T3 [get_ports {xgs_hispi_sdata_n[3]}]
set_property PACKAGE_PIN L18 [get_ports {xgs_hispi_sdata_p[4]}]
set_property PACKAGE_PIN K18 [get_ports {xgs_hispi_sdata_n[4]}]
set_property PACKAGE_PIN N18 [get_ports {xgs_hispi_sdata_p[5]}]
set_property PACKAGE_PIN N19 [get_ports {xgs_hispi_sdata_n[5]}]

set_property PACKAGE_PIN U4 [get_ports {xgs_hispi_sclk_p[0]}]
set_property PACKAGE_PIN V4 [get_ports {xgs_hispi_sclk_n[0]}]
set_property PACKAGE_PIN W5 [get_ports {xgs_hispi_sclk_p[1]}]
set_property PACKAGE_PIN W4 [get_ports {xgs_hispi_sclk_n[1]}]
set_property PACKAGE_PIN W7 [get_ports {xgs_hispi_sclk_p[2]}]
set_property PACKAGE_PIN W6 [get_ports {xgs_hispi_sclk_n[2]}]
set_property PACKAGE_PIN U8 [get_ports {xgs_hispi_sclk_p[3]}]
set_property PACKAGE_PIN V8 [get_ports {xgs_hispi_sclk_n[3]}]

set_property PACKAGE_PIN L17 [get_ports {xgs_hispi_sclk_p[4]}]
set_property PACKAGE_PIN K17 [get_ports {xgs_hispi_sclk_n[4]}]
set_property PACKAGE_PIN N17 [get_ports {xgs_hispi_sclk_p[5]}]
set_property PACKAGE_PIN P17 [get_ports {xgs_hispi_sclk_n[5]}]







set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sdata_n[5]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sdata_n[4]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sdata_n[3]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sdata_n[2]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sdata_n[1]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sdata_n[0]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sdata_p[5]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sdata_p[4]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sdata_p[3]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sdata_p[2]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sdata_p[1]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sdata_p[0]}]


set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sclk_n[5]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sclk_n[4]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sclk_n[3]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sclk_n[2]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sclk_n[1]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sclk_n[0]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sclk_p[5]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sclk_p[4]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sclk_p[3]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sclk_p[2]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sclk_p[1]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sclk_p[0]}]



set_property DRIVE 12 [get_ports xgs_cs_n]
set_property SLEW SLOW [get_ports xgs_cs_n]

set_property DRIVE 12 [get_ports xgs_reset_n]
set_property SLEW SLOW [get_ports xgs_reset_n]

set_property DRIVE 12 [get_ports xgs_sclk]
set_property SLEW SLOW [get_ports xgs_sclk]

set_property DRIVE 12 [get_ports xgs_sdout]
set_property SLEW SLOW [get_ports xgs_sdout]

set_property DRIVE 12 [get_ports xgs_trig_int]
set_property SLEW SLOW [get_ports xgs_trig_int]

set_property DRIVE 12 [get_ports xgs_trig_rd]
set_property SLEW SLOW [get_ports xgs_trig_rd]

set_property DRIVE 12 [get_ports xgs_fwsi_en]
set_property SLEW SLOW [get_ports xgs_fwsi_en]

set_property DRIVE 4 [get_ports {cfg_spi_sd[3]}]
set_property SLEW SLOW [get_ports {cfg_spi_sd[3]}]

set_property DRIVE 4 [get_ports {cfg_spi_sd[2]}]
set_property SLEW SLOW [get_ports {cfg_spi_sd[2]}]

set_property DRIVE 4 [get_ports {cfg_spi_sd[1]}]
set_property SLEW SLOW [get_ports {cfg_spi_sd[1]}]

set_property DRIVE 4 [get_ports {cfg_spi_sd[0]}]
set_property SLEW SLOW [get_ports {cfg_spi_sd[0]}]

set_property DRIVE 12 [get_ports cfg_spi_cs_n]
set_property SLEW SLOW [get_ports cfg_spi_cs_n]

set_property IOSTANDARD LVCMOS18 [get_ports {xgs_monitor[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {xgs_monitor[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {xgs_monitor[0]}]

set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_n[5]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_n[4]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_n[3]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_n[2]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_n[1]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_n[0]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_p[5]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_p[4]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_p[3]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_p[2]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_p[1]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_p[0]}]

set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sclk_n[5]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sclk_n[4]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sclk_n[3]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sclk_n[2]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sclk_n[1]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sclk_n[0]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sclk_p[5]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sclk_p[4]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sclk_p[3]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sclk_p[2]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sclk_p[1]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sclk_p[0]}]

set_property IOSTANDARD LVCMOS18 [get_ports sys_rst_n]
set_property IOSTANDARD LVCMOS18 [get_ports xgs_cs_n]
set_property IOSTANDARD LVCMOS18 [get_ports xgs_reset_n]
set_property IOSTANDARD LVCMOS18 [get_ports xgs_sclk]
set_property IOSTANDARD LVCMOS18 [get_ports xgs_sdin]
set_property IOSTANDARD LVCMOS18 [get_ports xgs_sdout]
set_property IOSTANDARD LVCMOS18 [get_ports xgs_trig_int]
set_property IOSTANDARD LVCMOS18 [get_ports xgs_trig_rd]
set_property IOSTANDARD LVCMOS18 [get_ports xgs_fwsi_en]
set_property IOSTANDARD LVCMOS18 [get_ports {cfg_spi_sd[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cfg_spi_sd[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cfg_spi_sd[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cfg_spi_sd[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports cfg_spi_cs_n]

#----------------------------------------------
#
# Debug, LED, Signal to other FPGA BANK 14
#
#----------------------------------------------
set_property PACKAGE_PIN A14 [get_ports {debug_data[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {debug_data[0]}]
set_property PULLDOWN true [get_ports {debug_data[0]}]

set_property PACKAGE_PIN B18 [get_ports {debug_data[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {debug_data[1]}]
set_property PULLDOWN true [get_ports {debug_data[1]}]

set_property PACKAGE_PIN B16 [get_ports {debug_data[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {debug_data[2]}]
set_property PULLDOWN true [get_ports {debug_data[2]}]

set_property PACKAGE_PIN B17 [get_ports {debug_data[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {debug_data[3]}]
set_property PULLDOWN true [get_ports {debug_data[3]}]

set_property PACKAGE_PIN G17 [get_ports {led_out[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led_out[0]}]
set_property DRIVE 8 [get_ports {led_out[0]}]
set_property SLEW SLOW [get_ports {led_out[0]}]

set_property PACKAGE_PIN H17 [get_ports {led_out[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led_out[1]}]
set_property DRIVE 8 [get_ports {led_out[1]}]
set_property SLEW SLOW [get_ports {led_out[1]}]

set_property PACKAGE_PIN G19 [get_ports strobe_out]
set_property IOSTANDARD LVCMOS18 [get_ports strobe_out]
set_property PULLDOWN true [get_ports strobe_out]
set_property DRIVE 8 [get_ports strobe_out]
set_property SLEW SLOW [get_ports strobe_out]

set_property PACKAGE_PIN H19 [get_ports exposure_out]
set_property IOSTANDARD LVCMOS18 [get_ports exposure_out]
set_property PULLDOWN true [get_ports exposure_out]
set_property DRIVE 8 [get_ports exposure_out]
set_property SLEW SLOW [get_ports exposure_out]

set_property PACKAGE_PIN J18 [get_ports trig_rdy_out]
set_property IOSTANDARD LVCMOS18 [get_ports trig_rdy_out]
set_property PULLDOWN true [get_ports trig_rdy_out]
set_property DRIVE 8 [get_ports trig_rdy_out]
set_property SLEW SLOW [get_ports trig_rdy_out]

set_property PACKAGE_PIN J17 [get_ports ext_trig]
set_property IOSTANDARD LVCMOS18 [get_ports ext_trig]


#----------------------------------------------
#
# I2C BANK 16 : I2c 3.3V and DEBUG 
#
#----------------------------------------------
set_property PACKAGE_PIN B15 [get_ports smbclk]
set_property IOSTANDARD LVCMOS33 [get_ports smbclk]
set_property DRIVE 4 [get_ports smbclk]
set_property SLEW SLOW [get_ports smbclk]

set_property PACKAGE_PIN C15 [get_ports smbdata]
set_property IOSTANDARD LVCMOS33 [get_ports smbdata]
set_property DRIVE 4 [get_ports smbdata]
set_property SLEW SLOW [get_ports smbdata]

