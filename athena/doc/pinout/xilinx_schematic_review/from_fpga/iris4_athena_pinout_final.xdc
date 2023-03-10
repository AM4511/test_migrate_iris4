set_property PACKAGE_PIN A6 [get_ports {pcie_rx_n[0]}]
set_property PACKAGE_PIN B6 [get_ports {pcie_rx_p[0]}]
set_property PACKAGE_PIN A2 [get_ports {pcie_tx_n[0]}]
set_property PACKAGE_PIN B2 [get_ports {pcie_tx_p[0]}]
set_property PACKAGE_PIN A4 [get_ports {pcie_rx_n[1]}]
set_property PACKAGE_PIN B4 [get_ports {pcie_rx_p[1]}]
set_property PACKAGE_PIN D1 [get_ports {pcie_tx_n[1]}]
set_property PACKAGE_PIN D2 [get_ports {pcie_tx_p[1]}]
set_property PACKAGE_PIN B8 [get_ports pcie_clk_p]
set_property PACKAGE_PIN A8 [get_ports pcie_clk_n]
set_property PACKAGE_PIN N3 [get_ports ref_clk]
set_property PACKAGE_PIN G3 [get_ports xgs_clk_pll_en]
set_property PACKAGE_PIN G2 [get_ports xgs_reset_n]
set_property PACKAGE_PIN J1 [get_ports xgs_sclk]
set_property PACKAGE_PIN J2 [get_ports xgs_cs_n]
set_property PACKAGE_PIN H1 [get_ports xgs_sdout]
set_property PACKAGE_PIN H2 [get_ports xgs_sdin]
set_property PACKAGE_PIN L3 [get_ports xgs_trig_int]
set_property PACKAGE_PIN L2 [get_ports xgs_trig_rd]
set_property PACKAGE_PIN K2 [get_ports xgs_fwsi_en]
set_property PACKAGE_PIN P1 [get_ports {xgs_monitor[0]}]
set_property PACKAGE_PIN N1 [get_ports {xgs_monitor[1]}]
set_property PACKAGE_PIN M1 [get_ports {xgs_monitor[2]}]
set_property PACKAGE_PIN F18 [get_ports {cfg_spi_sd[3]}]
set_property PACKAGE_PIN G18 [get_ports {cfg_spi_sd[2]}]
set_property PACKAGE_PIN D19 [get_ports {cfg_spi_sd[1]}]
set_property PACKAGE_PIN D18 [get_ports {cfg_spi_sd[0]}]
set_property PACKAGE_PIN K19 [get_ports cfg_spi_cs_n]
set_property PACKAGE_PIN E19 [get_ports {led_out[0]}]
set_property PACKAGE_PIN D17 [get_ports {led_out[1]}]
set_property PACKAGE_PIN G19 [get_ports strobe_out]
set_property PACKAGE_PIN H19 [get_ports exposure_out]
set_property PACKAGE_PIN J18 [get_ports trig_rdy_out]
set_property PACKAGE_PIN J17 [get_ports ext_trig]
set_property PACKAGE_PIN G17 [get_ports {fpga_var_type[0]}]
set_property PACKAGE_PIN H17 [get_ports {fpga_var_type[1]}]
set_property PACKAGE_PIN W5 [get_ports {xgs_hispi_sclk_p[0]}]
set_property PACKAGE_PIN W4 [get_ports {xgs_hispi_sclk_n[0]}]
set_property PACKAGE_PIN W7 [get_ports {xgs_hispi_sclk_p[1]}]
set_property PACKAGE_PIN W6 [get_ports {xgs_hispi_sclk_n[1]}]
set_property PACKAGE_PIN V3 [get_ports {xgs_hispi_sdata_p[0]}]
set_property PACKAGE_PIN W3 [get_ports {xgs_hispi_sdata_n[0]}]
set_property PACKAGE_PIN T1 [get_ports {xgs_hispi_sdata_p[1]}]
set_property PACKAGE_PIN U1 [get_ports {xgs_hispi_sdata_n[1]}]
set_property PACKAGE_PIN U5 [get_ports {xgs_hispi_sdata_p[2]}]
set_property PACKAGE_PIN V5 [get_ports {xgs_hispi_sdata_n[2]}]
set_property PACKAGE_PIN R2 [get_ports {xgs_hispi_sdata_p[3]}]
set_property PACKAGE_PIN T2 [get_ports {xgs_hispi_sdata_n[3]}]
set_property PACKAGE_PIN U7 [get_ports {xgs_hispi_sdata_p[4]}]
set_property PACKAGE_PIN V7 [get_ports {xgs_hispi_sdata_n[4]}]
set_property PACKAGE_PIN V2 [get_ports {xgs_hispi_sdata_p[5]}]
set_property PACKAGE_PIN W2 [get_ports {xgs_hispi_sdata_n[5]}]
set_property PACKAGE_PIN B16 [get_ports sys_rst_n]
set_property PACKAGE_PIN A16 [get_ports {debug_data[0]}]
set_property PACKAGE_PIN A17 [get_ports {debug_data[1]}]
set_property PACKAGE_PIN B17 [get_ports {debug_data[2]}]
set_property PACKAGE_PIN B18 [get_ports {debug_data[3]}]
set_property PACKAGE_PIN B15 [get_ports smbclk]
set_property PACKAGE_PIN C15 [get_ports smbdata]
set_property PACKAGE_PIN A14 [get_ports temp_alertN]
set_property PACKAGE_PIN A18 [get_ports xgs_power_good]
set_property DIRECTION IN [get_ports {xgs_monitor[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {xgs_monitor[2]}]
set_property DIRECTION IN [get_ports {xgs_monitor[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {xgs_monitor[1]}]
set_property DIRECTION IN [get_ports {xgs_monitor[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {xgs_monitor[0]}]
set_property DIRECTION IN [get_ports {fpga_var_type[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fpga_var_type[1]}]
set_property PULLDOWN true [get_ports {fpga_var_type[1]}]
set_property DIRECTION IN [get_ports {fpga_var_type[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fpga_var_type[0]}]
set_property PULLDOWN true [get_ports {fpga_var_type[0]}]
set_property DIRECTION IN [get_ports xgs_power_good]
set_property IOSTANDARD LVCMOS33 [get_ports xgs_power_good]
set_property DIRECTION INOUT [get_ports smbclk]
set_property IOSTANDARD LVCMOS33 [get_ports smbclk]
set_property DRIVE 4 [get_ports smbclk]
set_property SLEW SLOW [get_ports smbclk]
set_property DIRECTION IN [get_ports ext_trig]
set_property IOSTANDARD LVCMOS18 [get_ports ext_trig]
set_property DIRECTION IN [get_ports temp_alertN]
set_property IOSTANDARD LVCMOS33 [get_ports temp_alertN]
set_property DIRECTION IN [get_ports xgs_sdin]
set_property IOSTANDARD LVCMOS18 [get_ports xgs_sdin]
set_property DIRECTION INOUT [get_ports smbdata]
set_property IOSTANDARD LVCMOS33 [get_ports smbdata]
set_property DRIVE 4 [get_ports smbdata]
set_property SLEW SLOW [get_ports smbdata]
set_property DIRECTION IN [get_ports {xgs_hispi_sdata_n[5]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_n[5]}]
set_property DIFF_TERM TRUE [get_ports {xgs_hispi_sdata_n[5]}]
set_property DIRECTION IN [get_ports {xgs_hispi_sdata_n[4]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_n[4]}]
set_property DIFF_TERM TRUE [get_ports {xgs_hispi_sdata_n[4]}]
set_property DIRECTION IN [get_ports {xgs_hispi_sdata_n[3]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_n[3]}]
set_property DIFF_TERM TRUE [get_ports {xgs_hispi_sdata_n[3]}]
set_property DIRECTION IN [get_ports {xgs_hispi_sdata_n[2]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_n[2]}]
set_property DIFF_TERM TRUE [get_ports {xgs_hispi_sdata_n[2]}]
set_property DIRECTION IN [get_ports {xgs_hispi_sdata_n[1]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_n[1]}]
set_property DIFF_TERM TRUE [get_ports {xgs_hispi_sdata_n[1]}]
set_property DIRECTION IN [get_ports {xgs_hispi_sdata_n[0]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_n[0]}]
set_property DIFF_TERM TRUE [get_ports {xgs_hispi_sdata_n[0]}]
set_property DIRECTION IN [get_ports {xgs_hispi_sdata_p[5]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_p[5]}]
set_property DIFF_TERM TRUE [get_ports {xgs_hispi_sdata_p[5]}]
set_property DIRECTION IN [get_ports {xgs_hispi_sdata_p[4]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_p[4]}]
set_property DIFF_TERM TRUE [get_ports {xgs_hispi_sdata_p[4]}]
set_property DIRECTION IN [get_ports {xgs_hispi_sdata_p[3]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_p[3]}]
set_property DIFF_TERM TRUE [get_ports {xgs_hispi_sdata_p[3]}]
set_property DIRECTION IN [get_ports {xgs_hispi_sdata_p[2]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_p[2]}]
set_property DIFF_TERM TRUE [get_ports {xgs_hispi_sdata_p[2]}]
set_property DIRECTION IN [get_ports {xgs_hispi_sdata_p[1]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_p[1]}]
set_property DIFF_TERM TRUE [get_ports {xgs_hispi_sdata_p[1]}]
set_property DIRECTION IN [get_ports {xgs_hispi_sdata_p[0]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_p[0]}]
set_property DIFF_TERM TRUE [get_ports {xgs_hispi_sdata_p[0]}]
set_property DIRECTION IN [get_ports {xgs_hispi_sclk_n[1]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sclk_n[1]}]
set_property DIFF_TERM TRUE [get_ports {xgs_hispi_sclk_n[1]}]
set_property DIRECTION IN [get_ports {xgs_hispi_sclk_n[0]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sclk_n[0]}]
set_property DIFF_TERM TRUE [get_ports {xgs_hispi_sclk_n[0]}]
set_property DIRECTION IN [get_ports {xgs_hispi_sclk_p[1]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sclk_p[1]}]
set_property DIFF_TERM TRUE [get_ports {xgs_hispi_sclk_p[1]}]
set_property DIRECTION IN [get_ports {xgs_hispi_sclk_p[0]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sclk_p[0]}]
set_property DIFF_TERM TRUE [get_ports {xgs_hispi_sclk_p[0]}]
set_property DIRECTION IN [get_ports sys_rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports sys_rst_n]
set_property DIRECTION IN [get_ports ref_clk]
set_property IOSTANDARD LVCMOS18 [get_ports ref_clk]
set_property DIRECTION IN [get_ports {pcie_rx_n[1]}]
set_property DIRECTION IN [get_ports {pcie_rx_n[0]}]
set_property DIRECTION IN [get_ports {pcie_rx_p[1]}]
set_property DIRECTION IN [get_ports {pcie_rx_p[0]}]
set_property DIRECTION OUT [get_ports {pcie_tx_n[1]}]
set_property DIRECTION OUT [get_ports {pcie_tx_n[0]}]
set_property DIRECTION OUT [get_ports {pcie_tx_p[1]}]
set_property DIRECTION OUT [get_ports {pcie_tx_p[0]}]
set_property DIRECTION OUT [get_ports {debug_data[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {debug_data[3]}]
set_property DRIVE 4 [get_ports {debug_data[3]}]
set_property SLEW SLOW [get_ports {debug_data[3]}]
set_property PULLDOWN true [get_ports {debug_data[3]}]
set_property DIRECTION OUT [get_ports {debug_data[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {debug_data[2]}]
set_property DRIVE 4 [get_ports {debug_data[2]}]
set_property SLEW SLOW [get_ports {debug_data[2]}]
set_property PULLDOWN true [get_ports {debug_data[2]}]
set_property DIRECTION OUT [get_ports {debug_data[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {debug_data[1]}]
set_property DRIVE 4 [get_ports {debug_data[1]}]
set_property SLEW SLOW [get_ports {debug_data[1]}]
set_property PULLDOWN true [get_ports {debug_data[1]}]
set_property DIRECTION OUT [get_ports {debug_data[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {debug_data[0]}]
set_property DRIVE 4 [get_ports {debug_data[0]}]
set_property SLEW SLOW [get_ports {debug_data[0]}]
set_property PULLDOWN true [get_ports {debug_data[0]}]
set_property DIRECTION OUT [get_ports {led_out[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led_out[1]}]
set_property DRIVE 8 [get_ports {led_out[1]}]
set_property SLEW SLOW [get_ports {led_out[1]}]
set_property DIRECTION OUT [get_ports {led_out[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led_out[0]}]
set_property DRIVE 8 [get_ports {led_out[0]}]
set_property SLEW SLOW [get_ports {led_out[0]}]
set_property DIRECTION OUT [get_ports exposure_out]
set_property IOSTANDARD LVCMOS18 [get_ports exposure_out]
set_property DRIVE 8 [get_ports exposure_out]
set_property SLEW SLOW [get_ports exposure_out]
set_property PULLDOWN true [get_ports exposure_out]
set_property DIRECTION IN [get_ports pcie_clk_n]
set_property DIRECTION IN [get_ports pcie_clk_p]
set_property DIRECTION OUT [get_ports strobe_out]
set_property IOSTANDARD LVCMOS18 [get_ports strobe_out]
set_property DRIVE 8 [get_ports strobe_out]
set_property SLEW SLOW [get_ports strobe_out]
set_property PULLDOWN true [get_ports strobe_out]
set_property DIRECTION OUT [get_ports trig_rdy_out]
set_property IOSTANDARD LVCMOS18 [get_ports trig_rdy_out]
set_property DRIVE 8 [get_ports trig_rdy_out]
set_property SLEW SLOW [get_ports trig_rdy_out]
set_property PULLDOWN true [get_ports trig_rdy_out]
set_property DIRECTION OUT [get_ports xgs_clk_pll_en]
set_property IOSTANDARD LVCMOS18 [get_ports xgs_clk_pll_en]
set_property DRIVE 8 [get_ports xgs_clk_pll_en]
set_property SLEW SLOW [get_ports xgs_clk_pll_en]
set_property DIRECTION OUT [get_ports xgs_cs_n]
set_property IOSTANDARD LVCMOS18 [get_ports xgs_cs_n]
set_property DRIVE 8 [get_ports xgs_cs_n]
set_property SLEW SLOW [get_ports xgs_cs_n]
set_property DIRECTION OUT [get_ports xgs_fwsi_en]
set_property IOSTANDARD LVCMOS18 [get_ports xgs_fwsi_en]
set_property DRIVE 8 [get_ports xgs_fwsi_en]
set_property SLEW SLOW [get_ports xgs_fwsi_en]
set_property DIRECTION OUT [get_ports xgs_reset_n]
set_property IOSTANDARD LVCMOS18 [get_ports xgs_reset_n]
set_property DRIVE 8 [get_ports xgs_reset_n]
set_property SLEW SLOW [get_ports xgs_reset_n]
set_property DIRECTION OUT [get_ports xgs_sclk]
set_property IOSTANDARD LVCMOS18 [get_ports xgs_sclk]
set_property DRIVE 8 [get_ports xgs_sclk]
set_property SLEW SLOW [get_ports xgs_sclk]
set_property DIRECTION OUT [get_ports xgs_sdout]
set_property IOSTANDARD LVCMOS18 [get_ports xgs_sdout]
set_property DRIVE 8 [get_ports xgs_sdout]
set_property SLEW SLOW [get_ports xgs_sdout]
set_property DIRECTION OUT [get_ports xgs_trig_int]
set_property IOSTANDARD LVCMOS18 [get_ports xgs_trig_int]
set_property DRIVE 8 [get_ports xgs_trig_int]
set_property SLEW SLOW [get_ports xgs_trig_int]
set_property DIRECTION OUT [get_ports xgs_trig_rd]
set_property IOSTANDARD LVCMOS18 [get_ports xgs_trig_rd]
set_property DRIVE 8 [get_ports xgs_trig_rd]
set_property SLEW SLOW [get_ports xgs_trig_rd]
set_property DIRECTION INOUT [get_ports {cfg_spi_sd[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cfg_spi_sd[3]}]
set_property DRIVE 8 [get_ports {cfg_spi_sd[3]}]
set_property SLEW SLOW [get_ports {cfg_spi_sd[3]}]
set_property DIRECTION INOUT [get_ports {cfg_spi_sd[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cfg_spi_sd[2]}]
set_property DRIVE 8 [get_ports {cfg_spi_sd[2]}]
set_property SLEW SLOW [get_ports {cfg_spi_sd[2]}]
set_property DIRECTION INOUT [get_ports {cfg_spi_sd[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cfg_spi_sd[1]}]
set_property DRIVE 8 [get_ports {cfg_spi_sd[1]}]
set_property SLEW SLOW [get_ports {cfg_spi_sd[1]}]
set_property DIRECTION INOUT [get_ports {cfg_spi_sd[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cfg_spi_sd[0]}]
set_property DRIVE 8 [get_ports {cfg_spi_sd[0]}]
set_property SLEW SLOW [get_ports {cfg_spi_sd[0]}]
set_property DIRECTION INOUT [get_ports cfg_spi_cs_n]
set_property IOSTANDARD LVCMOS18 [get_ports cfg_spi_cs_n]
set_property DRIVE 8 [get_ports cfg_spi_cs_n]
set_property SLEW SLOW [get_ports cfg_spi_cs_n]
current_instance xsystem_pb_wrapper/system_pb_i/axi_quad_spi_0/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.RX_FIFO_II/gnuram_async_fifo.xpm_fifo_base_inst/gen_cdc_pntr.rd_pntr_cdc_inst
create_waiver -type CDC -id {CDC-6} -user "xpm_cdc" -desc "The CDC-6 warning is waived as it is safe in the context of XPM_CDC_GRAY." -internal -from [get_pins -quiet src_gray_ff_reg*/C] -to [get_pins -quiet dest_graysync_ff_reg*/D] -timestamp "Mon Mar 30 22:30:01 GMT 2020"
current_instance -quiet
current_instance xsystem_pb_wrapper/system_pb_i/axi_quad_spi_0/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.TX_FIFO_II/xpm_fifo_instance.xpm_fifo_async_inst/gnuram_async_fifo.xpm_fifo_base_inst/gen_cdc_pntr.wr_pntr_cdc_inst
create_waiver -type CDC -id {CDC-6} -user "xpm_cdc" -desc "The CDC-6 warning is waived as it is safe in the context of XPM_CDC_GRAY." -internal -from [get_pins -quiet src_gray_ff_reg*/C] -to [get_pins -quiet dest_graysync_ff_reg*/D] -timestamp "Mon Mar 30 22:30:01 GMT 2020"
current_instance -quiet
current_instance xsystem_pb_wrapper/system_pb_i/axi_quad_spi_0/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.TX_FIFO_II/xpm_fifo_instance.xpm_fifo_async_inst/gnuram_async_fifo.xpm_fifo_base_inst/gen_cdc_pntr.rd_pntr_cdc_inst
create_waiver -type CDC -id {CDC-6} -user "xpm_cdc" -desc "The CDC-6 warning is waived as it is safe in the context of XPM_CDC_GRAY." -internal -from [get_pins -quiet src_gray_ff_reg*/C] -to [get_pins -quiet dest_graysync_ff_reg*/D] -timestamp "Mon Mar 30 22:30:01 GMT 2020"
current_instance -quiet
current_instance xsystem_pb_wrapper/system_pb_i/axi_quad_spi_0/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.RX_FIFO_II/gnuram_async_fifo.xpm_fifo_base_inst/gen_cdc_pntr.wr_pntr_cdc_inst
create_waiver -type CDC -id {CDC-6} -user "xpm_cdc" -desc "The CDC-6 warning is waived as it is safe in the context of XPM_CDC_GRAY." -internal -from [get_pins -quiet src_gray_ff_reg*/C] -to [get_pins -quiet dest_graysync_ff_reg*/D] -timestamp "Mon Mar 30 22:30:01 GMT 2020"
current_instance -quiet
current_instance xsystem_pb_wrapper/system_pb_i/axi_quad_spi_0/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.RX_FIFO_II/gnuram_async_fifo.xpm_fifo_base_inst/gen_cdc_pntr.wr_pntr_cdc_dc_inst
create_waiver -type CDC -id {CDC-6} -user "xpm_cdc" -desc "The CDC-6 warning is waived as it is safe in the context of XPM_CDC_GRAY." -internal -from [get_pins -quiet src_gray_ff_reg*/C] -to [get_pins -quiet dest_graysync_ff_reg*/D] -timestamp "Mon Mar 30 22:30:01 GMT 2020"
current_instance -quiet
current_instance xsystem_pb_wrapper/system_pb_i/axi_quad_spi_0/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/FIFO_EXISTS.TX_FIFO_II/xpm_fifo_instance.xpm_fifo_async_inst/gnuram_async_fifo.xpm_fifo_base_inst/gen_cdc_pntr.rd_pntr_cdc_dc_inst
create_waiver -type CDC -id {CDC-6} -user "xpm_cdc" -desc "The CDC-6 warning is waived as it is safe in the context of XPM_CDC_GRAY." -internal -from [get_pins -quiet src_gray_ff_reg*/C] -to [get_pins -quiet dest_graysync_ff_reg*/D] -timestamp "Mon Mar 30 22:30:01 GMT 2020"
current_instance -quiet
current_instance xsystem_pb_wrapper/system_pb_i/pcie_0/axi_pcie_0/U0/comp_axi_enhanced_pcie/comp_enhanced_core_top_wrap/axi_pcie_enhanced_core_top_i/pcie_7x_v2_0_2_inst/debug_wrapper_U/jtag_axi4l_m_inst/U0/jtag_axi_engine_u/tx_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/rd_pntr_cdc_inst
create_waiver -type CDC -id {CDC-6} -user "xpm_cdc" -desc "The CDC-6 warning is waived as it is safe in the context of XPM_CDC_GRAY." -internal -from [get_pins -quiet src_gray_ff_reg*/C] -to [get_pins -quiet dest_graysync_ff_reg*/D] -timestamp "Mon Mar 30 22:30:01 GMT 2020"
current_instance -quiet
current_instance xsystem_pb_wrapper/system_pb_i/pcie_0/axi_pcie_0/U0/comp_axi_enhanced_pcie/comp_enhanced_core_top_wrap/axi_pcie_enhanced_core_top_i/pcie_7x_v2_0_2_inst/debug_wrapper_U/jtag_axi4l_m_inst/U0/jtag_axi_engine_u/rx_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/wr_pntr_cdc_inst
create_waiver -type CDC -id {CDC-6} -user "xpm_cdc" -desc "The CDC-6 warning is waived as it is safe in the context of XPM_CDC_GRAY." -internal -from [get_pins -quiet src_gray_ff_reg*/C] -to [get_pins -quiet dest_graysync_ff_reg*/D] -timestamp "Mon Mar 30 22:30:01 GMT 2020"
current_instance -quiet
current_instance xsystem_pb_wrapper/system_pb_i/pcie_0/axi_pcie_0/U0/comp_axi_enhanced_pcie/comp_enhanced_core_top_wrap/axi_pcie_enhanced_core_top_i/pcie_7x_v2_0_2_inst/debug_wrapper_U/jtag_axi4l_m_inst/U0/jtag_axi_engine_u/rx_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/rd_pntr_cdc_inst
create_waiver -type CDC -id {CDC-6} -user "xpm_cdc" -desc "The CDC-6 warning is waived as it is safe in the context of XPM_CDC_GRAY." -internal -from [get_pins -quiet src_gray_ff_reg*/C] -to [get_pins -quiet dest_graysync_ff_reg*/D] -timestamp "Mon Mar 30 22:30:01 GMT 2020"
current_instance -quiet
current_instance xsystem_pb_wrapper/system_pb_i/pcie_0/axi_pcie_0/U0/comp_axi_enhanced_pcie/comp_enhanced_core_top_wrap/axi_pcie_enhanced_core_top_i/pcie_7x_v2_0_2_inst/debug_wrapper_U/jtag_axi4l_m_inst/U0/jtag_axi_engine_u/tx_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/wr_pntr_cdc_inst
create_waiver -type CDC -id {CDC-6} -user "xpm_cdc" -desc "The CDC-6 warning is waived as it is safe in the context of XPM_CDC_GRAY." -internal -from [get_pins -quiet src_gray_ff_reg*/C] -to [get_pins -quiet dest_graysync_ff_reg*/D] -timestamp "Mon Mar 30 22:30:01 GMT 2020"
current_instance -quiet
current_instance xsystem_pb_wrapper/system_pb_i/pcie_0/axi_pcie_0/U0/comp_axi_enhanced_pcie/comp_enhanced_core_top_wrap/axi_pcie_enhanced_core_top_i/pcie_7x_v2_0_2_inst/debug_wrapper_U/jtag_axi4l_m_inst/U0/jtag_axi_engine_u/wr_cmd_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/rd_pntr_cdc_inst
create_waiver -type CDC -id {CDC-6} -user "xpm_cdc" -desc "The CDC-6 warning is waived as it is safe in the context of XPM_CDC_GRAY." -internal -from [get_pins -quiet src_gray_ff_reg*/C] -to [get_pins -quiet dest_graysync_ff_reg*/D] -timestamp "Mon Mar 30 22:30:01 GMT 2020"
current_instance -quiet
current_instance xsystem_pb_wrapper/system_pb_i/pcie_0/axi_pcie_0/U0/comp_axi_enhanced_pcie/comp_enhanced_core_top_wrap/axi_pcie_enhanced_core_top_i/pcie_7x_v2_0_2_inst/debug_wrapper_U/jtag_axi4l_m_inst/U0/jtag_axi_engine_u/rd_cmd_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/wr_pntr_cdc_inst
create_waiver -type CDC -id {CDC-6} -user "xpm_cdc" -desc "The CDC-6 warning is waived as it is safe in the context of XPM_CDC_GRAY." -internal -from [get_pins -quiet src_gray_ff_reg*/C] -to [get_pins -quiet dest_graysync_ff_reg*/D] -timestamp "Mon Mar 30 22:30:01 GMT 2020"
current_instance -quiet
current_instance xsystem_pb_wrapper/system_pb_i/pcie_0/axi_pcie_0/U0/comp_axi_enhanced_pcie/comp_enhanced_core_top_wrap/axi_pcie_enhanced_core_top_i/pcie_7x_v2_0_2_inst/debug_wrapper_U/jtag_axi4l_m_inst/U0/jtag_axi_engine_u/rd_cmd_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/rd_pntr_cdc_inst
create_waiver -type CDC -id {CDC-6} -user "xpm_cdc" -desc "The CDC-6 warning is waived as it is safe in the context of XPM_CDC_GRAY." -internal -from [get_pins -quiet src_gray_ff_reg*/C] -to [get_pins -quiet dest_graysync_ff_reg*/D] -timestamp "Mon Mar 30 22:30:01 GMT 2020"
current_instance -quiet
current_instance xsystem_pb_wrapper/system_pb_i/pcie_0/axi_pcie_0/U0/comp_axi_enhanced_pcie/comp_enhanced_core_top_wrap/axi_pcie_enhanced_core_top_i/pcie_7x_v2_0_2_inst/debug_wrapper_U/jtag_axi4l_m_inst/U0/jtag_axi_engine_u/wr_cmd_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/wr_pntr_cdc_inst
create_waiver -type CDC -id {CDC-6} -user "xpm_cdc" -desc "The CDC-6 warning is waived as it is safe in the context of XPM_CDC_GRAY." -internal -from [get_pins -quiet src_gray_ff_reg*/C] -to [get_pins -quiet dest_graysync_ff_reg*/D] -timestamp "Mon Mar 30 22:30:01 GMT 2020"
current_instance -quiet
current_instance xsystem_pb_wrapper/system_pb_i/pcie_0/axi_interconnect_1/m03_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_ar/handshake
create_waiver -type CDC -id {CDC-15} -user "xpm_cdc" -desc "The CDC-15 warning is waived as it is safe in the context of XPM_CDC_HANDSHAKE." -internal -from [get_pins -quiet src_hsdata_ff_reg*/C] -to [get_pins -quiet dest_hsdata_ff_reg*/D] -timestamp "Mon Mar 30 22:30:01 GMT 2020"
current_instance -quiet
current_instance xsystem_pb_wrapper/system_pb_i/pcie_0/axi_interconnect_1/m03_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_w/handshake
create_waiver -type CDC -id {CDC-15} -user "xpm_cdc" -desc "The CDC-15 warning is waived as it is safe in the context of XPM_CDC_HANDSHAKE." -internal -from [get_pins -quiet src_hsdata_ff_reg*/C] -to [get_pins -quiet dest_hsdata_ff_reg*/D] -timestamp "Mon Mar 30 22:30:01 GMT 2020"
current_instance -quiet
current_instance xsystem_pb_wrapper/system_pb_i/pcie_0/axi_interconnect_1/m03_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_b/handshake
create_waiver -type CDC -id {CDC-15} -user "xpm_cdc" -desc "The CDC-15 warning is waived as it is safe in the context of XPM_CDC_HANDSHAKE." -internal -from [get_pins -quiet src_hsdata_ff_reg*/C] -to [get_pins -quiet dest_hsdata_ff_reg*/D] -timestamp "Mon Mar 30 22:30:01 GMT 2020"
current_instance -quiet
current_instance xsystem_pb_wrapper/system_pb_i/pcie_0/axi_interconnect_1/m03_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_resp_r/handshake
create_waiver -type CDC -id {CDC-15} -user "xpm_cdc" -desc "The CDC-15 warning is waived as it is safe in the context of XPM_CDC_HANDSHAKE." -internal -from [get_pins -quiet src_hsdata_ff_reg*/C] -to [get_pins -quiet dest_hsdata_ff_reg*/D] -timestamp "Mon Mar 30 22:30:01 GMT 2020"
current_instance -quiet
current_instance xsystem_pb_wrapper/system_pb_i/pcie_0/axi_interconnect_1/m03_couplers/auto_cc/inst/gen_clock_conv.gen_async_lite_conv.clock_conv_lite_fwd_aw/handshake
create_waiver -type CDC -id {CDC-15} -user "xpm_cdc" -desc "The CDC-15 warning is waived as it is safe in the context of XPM_CDC_HANDSHAKE." -internal -from [get_pins -quiet src_hsdata_ff_reg*/C] -to [get_pins -quiet dest_hsdata_ff_reg*/D] -timestamp "Mon Mar 30 22:30:01 GMT 2020"
#revert back to original instance
current_instance -quiet
