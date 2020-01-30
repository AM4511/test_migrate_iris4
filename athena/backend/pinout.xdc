

#----------------------------------------------
# 
# FPGA BANK 216 MGT (PCIe)
#
#----------------------------------------------
set_property PACKAGE_PIN B8 [get_ports pcie_clk_p]
set_property PACKAGE_PIN A8 [get_ports pcie_clk_n]


#----------------------------------------------
# 
# FPGA BANK 35 1.8V
#
# XGS CONTROL, PCIe RESET, REF clk 100mhz
#
#----------------------------------------------

set_property PACKAGE_PIN N3 [get_ports ref_clk]
set_property IOSTANDARD LVCMOS18 [get_ports ref_clk]


set_property PACKAGE_PIN G3 [get_ports xgs_clk_pll_en]
set_property DRIVE 8 [get_ports xgs_clk_pll_en]
set_property SLEW SLOW [get_ports xgs_clk_pll_en]
set_property IOSTANDARD LVCMOS18 [get_ports xgs_clk_pll_en]

set_property PACKAGE_PIN G2 [get_ports xgs_reset_n]
set_property DRIVE 8 [get_ports xgs_reset_n]
set_property SLEW SLOW [get_ports xgs_reset_n]
set_property IOSTANDARD LVCMOS18 [get_ports xgs_reset_n]

set_property PACKAGE_PIN J1 [get_ports xgs_sclk]
set_property DRIVE 8 [get_ports xgs_sclk]
set_property IOSTANDARD LVCMOS18 [get_ports xgs_sclk]
set_property SLEW SLOW [get_ports xgs_sclk]

set_property PACKAGE_PIN J2 [get_ports xgs_cs_n]
set_property IOSTANDARD LVCMOS18 [get_ports xgs_cs_n]
set_property DRIVE 8 [get_ports xgs_cs_n]
set_property SLEW SLOW [get_ports xgs_cs_n]

set_property PACKAGE_PIN H1 [get_ports xgs_sdout]
set_property DRIVE 8 [get_ports xgs_sdout]
set_property IOSTANDARD LVCMOS18 [get_ports xgs_sdout]
set_property SLEW SLOW [get_ports xgs_sdout]

set_property PACKAGE_PIN H2 [get_ports xgs_sdin]
set_property IOSTANDARD LVCMOS18 [get_ports xgs_sdin]

set_property PACKAGE_PIN L3 [get_ports xgs_trig_int]
set_property IOSTANDARD LVCMOS18 [get_ports xgs_trig_int]
set_property DRIVE 8 [get_ports xgs_trig_int]
set_property SLEW SLOW [get_ports xgs_trig_int]

set_property PACKAGE_PIN L2 [get_ports xgs_trig_rd]
set_property IOSTANDARD LVCMOS18 [get_ports xgs_trig_rd]
set_property DRIVE 8 [get_ports xgs_trig_rd]
set_property SLEW SLOW [get_ports xgs_trig_rd]

set_property PACKAGE_PIN K2 [get_ports xgs_fwsi_en]
set_property IOSTANDARD LVCMOS18 [get_ports xgs_fwsi_en]
set_property DRIVE 8 [get_ports xgs_fwsi_en]
set_property SLEW SLOW [get_ports xgs_fwsi_en]

set_property PACKAGE_PIN P1 [get_ports {xgs_monitor[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {xgs_monitor[0]}]

set_property PACKAGE_PIN N1 [get_ports {xgs_monitor[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {xgs_monitor[1]}]

set_property PACKAGE_PIN M1 [get_ports {xgs_monitor[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {xgs_monitor[2]}]




#----------------------------------------------
# 
# FPGA BANK 14 1.8V
#
# SPI, XGS Hispi(4-5), LED, Signal to other fpga, strappings
#
#----------------------------------------------

# SPI FW
set_property PACKAGE_PIN F18 [get_ports {cfg_spi_sd[3]}]
set_property DRIVE 8 [get_ports {cfg_spi_sd[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cfg_spi_sd[3]}]
set_property SLEW SLOW [get_ports {cfg_spi_sd[3]}]

set_property PACKAGE_PIN G18 [get_ports {cfg_spi_sd[2]}]
set_property DRIVE 8 [get_ports {cfg_spi_sd[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cfg_spi_sd[2]}]
set_property SLEW SLOW [get_ports {cfg_spi_sd[2]}]

set_property PACKAGE_PIN D19 [get_ports {cfg_spi_sd[1]}]
set_property DRIVE 8 [get_ports {cfg_spi_sd[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cfg_spi_sd[1]}]
set_property SLEW SLOW [get_ports {cfg_spi_sd[1]}]

set_property PACKAGE_PIN D18 [get_ports {cfg_spi_sd[0]}]
set_property DRIVE 8 [get_ports {cfg_spi_sd[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cfg_spi_sd[0]}]
set_property SLEW SLOW [get_ports {cfg_spi_sd[0]}]

set_property PACKAGE_PIN K19 [get_ports cfg_spi_cs_n]
set_property DRIVE 8 [get_ports cfg_spi_cs_n]
set_property IOSTANDARD LVCMOS18 [get_ports cfg_spi_cs_n]
set_property SLEW SLOW [get_ports cfg_spi_cs_n]

# Contraintes pour le SPI (voir AR# 57045)
set_property CONFIG_VOLTAGE 1.8 [current_design]
set_property CFGBVS GND [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]

# Sets the FPGA to use a falling edge clock for SPI data
# capture. This improves timing margins and may allow
# faster clock rates for configuration.
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE YES [current_design]

# La valeur du timer doit etre assez precisement calculee pour que le dual-boot soit fiable. (voir fichier cfg_timer.xls)
# IRIS4 : A recalculer!!!!
#
#set_property BITSTREAM.CONFIG.TIMER_CFG 32'h0000F61B [current_design]
#set_property BITSTREAM.CONFIG.CONFIGFALLBACK ENABLE [current_design]



# LEDs
set_property PACKAGE_PIN E19 [get_ports {led_out[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led_out[0]}]
set_property DRIVE 8 [get_ports {led_out[0]}]
set_property SLEW SLOW [get_ports {led_out[0]}]

set_property PACKAGE_PIN D17 [get_ports {led_out[1]}]
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

set_property PACKAGE_PIN G17  [get_ports {fpga_var_type[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fpga_var_type[0]}]
set_property PULLDOWN true [get_ports {fpga_var_type[0]}]

set_property PACKAGE_PIN H17 [get_ports {fpga_var_type[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fpga_var_type[1]}]
set_property PULLDOWN true [get_ports {fpga_var_type[1]}]


## # HiSPI(4)
## set_property PACKAGE_PIN M18 [get_ports {xgs_hispi_sclk_p[4]}]
## set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sclk_p[4]}]
## set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sclk_p[4]}]
## 
## set_property PACKAGE_PIN M19 [get_ports {xgs_hispi_sclk_n[4]}]
## set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sclk_n[4]}]
## set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sclk_n[4]}]
## 
## set_property PACKAGE_PIN P19 [get_ports {xgs_hispi_sdata_p[4]}]
## set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_p[4]}]
## set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sdata_p[4]}]
## 
## set_property PACKAGE_PIN R19 [get_ports {xgs_hispi_sdata_n[4]}]
## set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_n[4]}]
## set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sdata_n[4]}]
## 
## # HiSPI(5)
## set_property PACKAGE_PIN P18 [get_ports {xgs_hispi_sclk_p[5]}]
## set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sclk_p[5]}]
## set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sclk_p[5]}]
## 
## set_property PACKAGE_PIN R18 [get_ports {xgs_hispi_sclk_n[5]}]
## set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sclk_n[5]}]
## set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sclk_n[5]}]
## 
## set_property PACKAGE_PIN U19 [get_ports {xgs_hispi_sdata_p[5]}]
## set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_p[5]}]
## set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sdata_p[5]}]
## 
## set_property PACKAGE_PIN V19 [get_ports {xgs_hispi_sdata_n[5]}]
## set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_n[5]}]
## set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sdata_n[5]}]



#----------------------------------------------
# 
# FPGA BANK 34 1.8V
#
# XGS HiSPI 0,1,2,3
#
#----------------------------------------------

## # HiSPI(0)
## set_property PACKAGE_PIN U4 [get_ports {xgs_hispi_sclk_p[0]}]
## set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sclk_p[0]}]
## set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sclk_p[0]}]
## 
## set_property PACKAGE_PIN V4 [get_ports {xgs_hispi_sclk_n[0]}]
## set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sclk_n[0]}]
## set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sclk_n[0]}]
## 
## set_property PACKAGE_PIN V3 [get_ports {xgs_hispi_sdata_p[0]}]
## set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_p[0]}]
## set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sdata_p[0]}]
## 
## set_property PACKAGE_PIN W3 [get_ports {xgs_hispi_sdata_n[0]}]
## set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_n[0]}]
## set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sdata_n[0]}]
## 
## 
## # HiSPI(1)
## set_property PACKAGE_PIN W5 [get_ports {xgs_hispi_sclk_p[1]}]
## set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sclk_p[1]}]
## set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sclk_p[1]}]
## 
## set_property PACKAGE_PIN W4 [get_ports {xgs_hispi_sclk_n[1]}]
## set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sclk_n[1]}]
## set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sclk_n[1]}]
## 
## set_property PACKAGE_PIN U3 [get_ports {xgs_hispi_sdata_p[1]}]
## set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_p[1]}]
## set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sdata_p[1]}]
## 
## set_property PACKAGE_PIN U2 [get_ports {xgs_hispi_sdata_n[1]}]
## set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_n[1]}]
## set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sdata_n[1]}]
## 
## 
## # HiSPI(2)
## set_property PACKAGE_PIN W7 [get_ports {xgs_hispi_sclk_p[2]}]
## set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sclk_p[2]}]
## set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sclk_p[2]}]
## 
## set_property PACKAGE_PIN W6 [get_ports {xgs_hispi_sclk_n[2]}]
## set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sclk_n[2]}]
## set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sclk_n[2]}]
## 
## set_property PACKAGE_PIN U5 [get_ports {xgs_hispi_sdata_p[2]}]
## set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_p[2]}]
## set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sdata_p[2]}]
## 
## set_property PACKAGE_PIN V5 [get_ports {xgs_hispi_sdata_n[2]}]
## set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_n[2]}]
## set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sdata_n[2]}]
## 
## 
## # HiSPI(3)
## set_property PACKAGE_PIN U8 [get_ports {xgs_hispi_sclk_p[3]}]
## set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sclk_p[3]}]
## set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sclk_p[3]}]
## 
## set_property PACKAGE_PIN V8 [get_ports {xgs_hispi_sclk_n[3]}]
## set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sclk_n[3]}]
## set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sclk_n[3]}]
## 
## set_property PACKAGE_PIN U7 [get_ports {xgs_hispi_sdata_p[3]}]
## set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_p[3]}]
## set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sdata_p[3]}]
## 
## set_property PACKAGE_PIN V7 [get_ports {xgs_hispi_sdata_n[3]}]
## set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_n[3]}]
## set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sdata_n[3]}]


##--------------------------------------------------------------------------------------------------------
##
## Routing 6 DATA LANES + 2 CLK on same bank : 
##
## Sensor HiSPI CLK[2]  + Sensor HiSPI DATA[0] + HiSPI DATA[8] + HiSPI DATA[16]   --    TOP, EVEN HiSPI 
## Sensor HiSPI CLK[3]  + Sensor HiSPI DATA[1] + HiSPI DATA[9] + HiSPI DATA[17]   -- BOTTOM, ODD HiSPI  
##
## FPGA HiSPI CLK[0]    + FPGA HiSPI DATA[0] + FPGA DATA[1] + FPGA DATA[2]        --    TOP, EVEN HiSPI 
## FPGA HiSPI CLK[1]    + FPGA HiSPI DATA[3] + FPGA DATA[4] + FPGA DATA[5]        -- BOTTOM, ODD HiSPI   
##
## --TOP sensor readout
## Sensor HiSPI CLK[2]    => FPGA HiSPI CLK[0]
## Sensor HiSPI DATA[0]   => FPGA HiSPI DATA[0]
## Sensor HiSPI DATA[8]   => FPGA HiSPI DATA[1]
## Sensor HiSPI DATA[16]  => FPGA HiSPI DATA[2]
##
## --BOTTOM sensor readout
## Sensor HiSPI CLK[3]    => FPGA HiSPI CLK[1]
## Sensor HiSPI DATA[1]   => FPGA HiSPI DATA[3]
## Sensor HiSPI DATA[9]   => FPGA HiSPI DATA[4]
## Sensor HiSPI DATA[17]  => FPGA HiSPI DATA[5]
##
##---------------------------------------------------------------------------------------------------------


# FPGA HiSPI CLK[0]  : SENSOR HiSPI[2]
set_property PACKAGE_PIN W5 [get_ports {xgs_hispi_sclk_p[0]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sclk_p[0]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sclk_p[0]}]

set_property PACKAGE_PIN W4 [get_ports {xgs_hispi_sclk_n[0]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sclk_n[0]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sclk_n[0]}]


# FPGA HiSPI CLK[1]  : SENSOR HiSPI[3]
set_property PACKAGE_PIN W7 [get_ports {xgs_hispi_sclk_p[1]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sclk_p[1]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sclk_p[1]}]

set_property PACKAGE_PIN W6 [get_ports {xgs_hispi_sclk_n[1]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sclk_n[1]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sclk_n[1]}]



# FPGA HiSPI[0] : SENSOR HiSPI[0]
set_property PACKAGE_PIN R2 [get_ports {xgs_hispi_sdata_p[0]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_p[0]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sdata_p[0]}]

set_property PACKAGE_PIN T2 [get_ports {xgs_hispi_sdata_n[0]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_n[0]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sdata_n[0]}]


# FPGA HiSPI[1]  : SENSOR HiSPI[8] 
set_property PACKAGE_PIN T1 [get_ports {xgs_hispi_sdata_p[1]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_p[1]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sdata_p[1]}]

set_property PACKAGE_PIN U1 [get_ports {xgs_hispi_sdata_n[1]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_n[1]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sdata_n[1]}]


# FPGA HiSPI[2]  : SENSOR HiSPI[16]
set_property PACKAGE_PIN V2 [get_ports {xgs_hispi_sdata_p[2]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_p[2]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sdata_p[2]}]

set_property PACKAGE_PIN W2 [get_ports {xgs_hispi_sdata_n[2]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_n[2]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sdata_n[2]}]


# FPGA HiSPI[3]  : SENSOR HiSPI[1]
set_property PACKAGE_PIN V3 [get_ports {xgs_hispi_sdata_p[3]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_p[3]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sdata_p[3]}]

set_property PACKAGE_PIN W3 [get_ports {xgs_hispi_sdata_n[3]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_n[3]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sdata_n[3]}]


# FPGA HiSPI[4]  : SENSOR HiSPI[9]
set_property PACKAGE_PIN U5 [get_ports {xgs_hispi_sdata_p[4]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_p[4]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sdata_p[4]}]

set_property PACKAGE_PIN V5 [get_ports {xgs_hispi_sdata_n[4]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_n[4]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sdata_n[4]}]


# FPGA HiSPI[5]  : SENSOR HiSPI[17]
set_property PACKAGE_PIN U7 [get_ports {xgs_hispi_sdata_p[5]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_p[5]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sdata_p[5]}]

set_property PACKAGE_PIN V7 [get_ports {xgs_hispi_sdata_n[5]}]
set_property IOSTANDARD LVDS_25 [get_ports {xgs_hispi_sdata_n[5]}]
set_property DIFF_TERM FALSE [get_ports {xgs_hispi_sdata_n[5]}]





#----------------------------------------------
#
# BANK 16 - 3.3V
#
# Pcie reset, I2c, DEBUG, temp alert 
#
#----------------------------------------------
set_property PACKAGE_PIN B16 [get_ports sys_rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports sys_rst_n]

set_property PACKAGE_PIN A16 [get_ports {debug_data[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {debug_data[0]}]
set_property PULLDOWN true [get_ports {debug_data[0]}]
set_property DRIVE 4 [get_ports {debug_data[0]}]
set_property SLEW SLOW [get_ports {debug_data[0]}]

set_property PACKAGE_PIN A17 [get_ports {debug_data[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {debug_data[1]}]
set_property PULLDOWN true [get_ports {debug_data[1]}]
set_property DRIVE 4 [get_ports {debug_data[1]}]
set_property SLEW SLOW [get_ports {debug_data[1]}]

set_property PACKAGE_PIN B17 [get_ports {debug_data[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {debug_data[2]}]
set_property PULLDOWN true [get_ports {debug_data[2]}]
set_property DRIVE 4 [get_ports {debug_data[2]}]
set_property SLEW SLOW [get_ports {debug_data[2]}]

set_property PACKAGE_PIN B18 [get_ports {debug_data[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {debug_data[3]}]
set_property PULLDOWN true [get_ports {debug_data[3]}]
set_property DRIVE 4 [get_ports {debug_data[3]}]
set_property SLEW SLOW [get_ports {debug_data[3]}]

set_property PACKAGE_PIN B15 [get_ports smbclk]
set_property IOSTANDARD LVCMOS33 [get_ports smbclk]
set_property DRIVE 4 [get_ports smbclk]
set_property SLEW SLOW [get_ports smbclk]

set_property PACKAGE_PIN C15 [get_ports smbdata]
set_property IOSTANDARD LVCMOS33 [get_ports smbdata]
set_property DRIVE 4 [get_ports smbdata]
set_property SLEW SLOW [get_ports smbdata]

set_property PACKAGE_PIN A14 [get_ports temp_alertN]
set_property IOSTANDARD LVCMOS33 [get_ports temp_alertN]

