####################################################
## Pinout compatibility
####################################################

####################################################
## Pin assignment
####################################################
set_property PACKAGE_PIN M18 [get_ports ref_clk_100MHz]
set_property PACKAGE_PIN J1  [get_ports sys_rst_in_n]
set_property PACKAGE_PIN H1  [get_ports sys_rst_out_n]


####################################################
## FPGA straps
####################################################
set_property PACKAGE_PIN U18 [get_ports {fpga_straps[3]}]
set_property PACKAGE_PIN V17 [get_ports {fpga_straps[2]}]
set_property PACKAGE_PIN W16 [get_ports {fpga_straps[1]}]
set_property PACKAGE_PIN W17 [get_ports {fpga_straps[0]}]


set_property IOSTANDARD LVCMOS18 [get_ports {fpga_straps[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fpga_straps[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fpga_straps[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fpga_straps[0]}]

set_property PULLUP true [get_ports {fpga_straps[3]}]
set_property PULLUP true [get_ports {fpga_straps[2]}]
set_property PULLUP true [get_ports {fpga_straps[1]}]
set_property PULLUP true [get_ports {fpga_straps[0]}]

####################################################
## eSPI interface
####################################################
set_property PACKAGE_PIN J17 [get_ports espi_reset_n]
set_property PACKAGE_PIN K17 [get_ports espi_clk]
set_property PACKAGE_PIN E19 [get_ports espi_alert_n]
set_property PACKAGE_PIN L18 [get_ports espi_cs_n]
set_property PACKAGE_PIN G19 [get_ports {espi_io[3]}]
set_property PACKAGE_PIN H19 [get_ports {espi_io[2]}]
set_property PACKAGE_PIN J18 [get_ports {espi_io[1]}]
set_property PACKAGE_PIN K18 [get_ports {espi_io[0]}]



####################################################
## PCIe interface
####################################################
set_property LOC GTPE2_CHANNEL_X0Y0 [get_cells {xpcie_top/xxil_pcie/U0/inst/gt_top_i/pipe_wrapper_i/pipe_lane[0].gt_wrapper_i/gtp_channel.gtpe2_channel_i}]
set_property PACKAGE_PIN B8 [get_ports pcie_sys_clk_p]
set_property PACKAGE_PIN A8 [get_ports pcie_sys_clk_n]
set_property PACKAGE_PIN A4 [get_ports {pcie_rxn[0]}]
set_property PACKAGE_PIN B4 [get_ports {pcie_rxp[0]}]
set_property PACKAGE_PIN D1 [get_ports {pcie_txn[0]}]
set_property PACKAGE_PIN D2 [get_ports {pcie_txp[0]}]


####################################################
## CPU debug interface
####################################################
set_property PACKAGE_PIN N19 [get_ports debug_uart_rxd]
set_property PACKAGE_PIN N18 [get_ports debug_uart_txd]


####################################################
## CPU debug interface
####################################################
set_property PACKAGE_PIN B18 [get_ports {acq_led[0]}]
set_property PACKAGE_PIN A18 [get_ports {acq_led[1]}]
set_property PACKAGE_PIN C15 [get_ports acq_exposure]
set_property PACKAGE_PIN B15 [get_ports acq_strobe]
set_property PACKAGE_PIN A17 [get_ports acq_trigger_ready]
set_property PACKAGE_PIN A16 [get_ports acq_trigger]




####################################################
## User leds
####################################################
set_property PACKAGE_PIN A14 [get_ports user_rled_soc]
set_property PACKAGE_PIN A15 [get_ports user_gled_soc]
set_property PACKAGE_PIN U4 [get_ports user_rled]
set_property PACKAGE_PIN U2 [get_ports user_gled]
set_property PACKAGE_PIN U1 [get_ports status_rled]
set_property PACKAGE_PIN U5 [get_ports status_gled]


####################################################
## NCSI interface
####################################################
set_property PACKAGE_PIN N3 [get_ports ncsi_clk]
set_property PACKAGE_PIN N1 [get_ports {ncsi_rxd[0]}]
set_property PACKAGE_PIN M1 [get_ports {ncsi_rxd[1]}]
set_property PACKAGE_PIN M3 [get_ports {ncsi_txd[0]}]
set_property PACKAGE_PIN L3 [get_ports {ncsi_txd[1]}]
set_property PACKAGE_PIN M2 [get_ports ncsi_rx_crs_dv]
set_property PACKAGE_PIN N2 [get_ports ncsi_tx_en]

## Set the IOB property on IOs
set_property IOB TRUE [get_ports {ncsi_rxd[*]}]
set_property IOB TRUE [get_ports ncsi_rx_crs_dv]
set_property IOB TRUE [get_ports {ncsi_txd[*]}]
set_property IOB TRUE [get_ports ncsi_tx_en]



set_property PULLUP true [get_ports {ncsi_rxd[1]}]
set_property PULLUP true [get_ports {ncsi_rxd[0]}]


####################################################
## Configuration flash interface
####################################################
set_property PACKAGE_PIN K19 [get_ports spi_cs_n]
set_property PACKAGE_PIN D18 [get_ports {spi_sd[0]}]
set_property PACKAGE_PIN D19 [get_ports {spi_sd[1]}]
set_property PACKAGE_PIN G18 [get_ports {spi_sd[2]}]
set_property PACKAGE_PIN F18 [get_ports {spi_sd[3]}]


####################################################
## Hyperram (hr) interface
####################################################
set_property PACKAGE_PIN P18 [get_ports hb_ck]
set_property PACKAGE_PIN R18 [get_ports hb_ck_n]
set_property PACKAGE_PIN T17 [get_ports hb_cs_n]


# ###################################################
# This is the new Hyper bus pinout after the design
# review. The modifications were induced by the pin
# swapping in the cad (Board layout). AM - 28/02/2020
# ###################################################
set_property PACKAGE_PIN V14 [get_ports {hb_dq[0]}]
set_property PACKAGE_PIN V15 [get_ports {hb_dq[1]}]
set_property PACKAGE_PIN W13 [get_ports {hb_dq[2]}]
set_property PACKAGE_PIN W14 [get_ports {hb_dq[3]}]
set_property PACKAGE_PIN V13 [get_ports {hb_dq[4]}]
set_property PACKAGE_PIN W15 [get_ports {hb_dq[5]}]
set_property PACKAGE_PIN U15 [get_ports {hb_dq[6]}]
set_property PACKAGE_PIN U14 [get_ports {hb_dq[7]}]


set_property PACKAGE_PIN R19 [get_ports hb_rst_n]

# IMPORTANT The following pin Has been moved from V16 
# on PCB 7571-00 to N17 on PCB 7571-02. See JIRA IRIS4-242
# 
set_property PACKAGE_PIN N17 [get_ports hb_rwds]





set_property PACKAGE_PIN V2 [get_ports pwm_out]


set_property PACKAGE_PIN R2 [get_ports {user_data_in[0]}]
set_property PACKAGE_PIN T2 [get_ports {user_data_in[1]}]
set_property PACKAGE_PIN T1 [get_ports {user_data_in[2]}]
set_property PACKAGE_PIN R3 [get_ports {user_data_in[3]}]
set_property PACKAGE_PIN T3 [get_ports {user_data_out[0]}]
set_property PACKAGE_PIN U8 [get_ports {user_data_out[1]}]
set_property PACKAGE_PIN U7 [get_ports {user_data_out[2]}]

set_property PULLUP true [get_ports {user_data_in[3]}]
set_property PULLUP true [get_ports {user_data_in[2]}]
set_property PULLUP true [get_ports {user_data_in[1]}]
set_property PULLUP true [get_ports {user_data_in[0]}]

 
set_property IOSTANDARD LVCMOS18 [get_ports {acq_led[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {acq_led[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {espi_io[3]}]
set_property DRIVE 4 [get_ports {espi_io[3]}]
set_property SLEW SLOW [get_ports {espi_io[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {espi_io[2]}]
set_property DRIVE 4 [get_ports {espi_io[2]}]
set_property SLEW SLOW [get_ports {espi_io[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {espi_io[1]}]
set_property DRIVE 4 [get_ports {espi_io[1]}]
set_property SLEW SLOW [get_ports {espi_io[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {espi_io[0]}]
set_property DRIVE 4 [get_ports {espi_io[0]}]
set_property SLEW SLOW [get_ports {espi_io[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {user_data_out[2]}]
set_property DRIVE 4 [get_ports {user_data_out[2]}]
set_property SLEW SLOW [get_ports {user_data_out[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {user_data_out[1]}]
set_property DRIVE 4 [get_ports {user_data_out[1]}]
set_property SLEW SLOW [get_ports {user_data_out[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {user_data_out[0]}]
set_property DRIVE 4 [get_ports {user_data_out[0]}]
set_property SLEW SLOW [get_ports {user_data_out[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {user_data_in[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {user_data_in[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {user_data_in[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {user_data_in[0]}]

###############################################################
# Hyperram
###############################################################
set_property IOSTANDARD LVCMOS18 [get_ports {hb_dq[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {hb_dq[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {hb_dq[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {hb_dq[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {hb_dq[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {hb_dq[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {hb_dq[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {hb_dq[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports hb_ck]
set_property IOSTANDARD LVCMOS18 [get_ports hb_ck_n]
set_property IOSTANDARD LVCMOS18 [get_ports hb_cs_n]
set_property IOSTANDARD LVCMOS18 [get_ports hb_rwds]

set_property DRIVE 12 [get_ports {hb_dq[7]}]
set_property DRIVE 12 [get_ports {hb_dq[3]}]
set_property DRIVE 12 [get_ports {hb_dq[6]}]
set_property DRIVE 12 [get_ports {hb_dq[5]}]
set_property DRIVE 12 [get_ports {hb_dq[4]}]
set_property DRIVE 12 [get_ports {hb_dq[2]}]
set_property DRIVE 12 [get_ports {hb_dq[1]}]
set_property DRIVE 12 [get_ports {hb_dq[0]}]
set_property DRIVE 12 [get_ports hb_ck]
set_property DRIVE 12 [get_ports hb_ck_n]
set_property DRIVE 12 [get_ports hb_cs_n]
set_property DRIVE 12 [get_ports hb_rwds]

set_property SLEW FAST [get_ports {hb_dq[7]}]
set_property SLEW FAST [get_ports {hb_dq[6]}]
set_property SLEW FAST [get_ports {hb_dq[5]}]
set_property SLEW FAST [get_ports {hb_dq[4]}]
set_property SLEW FAST [get_ports {hb_dq[3]}]
set_property SLEW FAST [get_ports {hb_dq[2]}]
set_property SLEW FAST [get_ports {hb_dq[1]}]
set_property SLEW FAST [get_ports {hb_dq[0]}]
set_property SLEW FAST [get_ports hb_ck]
set_property SLEW FAST [get_ports hb_ck_n]
set_property SLEW FAST [get_ports hb_cs_n]
set_property SLEW FAST [get_ports hb_rwds]



set_property IOSTANDARD LVCMOS18 [get_ports acq_exposure]
set_property IOSTANDARD LVCMOS18 [get_ports acq_strobe]
set_property IOSTANDARD LVCMOS18 [get_ports acq_trigger_ready]


set_property IOSTANDARD LVCMOS18 [get_ports espi_clk]
set_property IOSTANDARD LVCMOS18 [get_ports espi_cs_n]
set_property IOSTANDARD LVCMOS18 [get_ports espi_reset_n]
set_property IOSTANDARD LVCMOS18 [get_ports user_rled_soc]
set_property IOSTANDARD LVCMOS18 [get_ports hb_rst_n]
set_property DRIVE 4 [get_ports hb_rst_n]
set_property SLEW FAST [get_ports hb_rst_n]
set_property IOSTANDARD LVCMOS18 [get_ports spi_cs_n]
set_property DRIVE 4 [get_ports spi_cs_n]
set_property SLEW SLOW [get_ports spi_cs_n]
set_property DRIVE 4 [get_ports {spi_sd[*]}]
set_property SLEW SLOW [get_ports {spi_sd[*]}]
set_property IOSTANDARD LVCMOS18 [get_ports user_gled_soc]

set_property IOSTANDARD LVCMOS18 [get_ports {spi_sd[*]}]
set_property IOSTANDARD LVCMOS18 [get_ports ref_clk_100MHz]
set_property IOSTANDARD LVCMOS33 [get_ports sys_rst_in_n]
set_property IOSTANDARD LVCMOS33 [get_ports sys_rst_out_n]
set_property IOSTANDARD LVCMOS18 [get_ports debug_uart_rxd]
set_property IOSTANDARD LVCMOS18 [get_ports debug_uart_txd]
set_property DRIVE 4 [get_ports debug_uart_txd]
set_property SLEW SLOW [get_ports debug_uart_txd]
set_property DRIVE 4 [get_ports ncsi_clk]
set_property IOSTANDARD LVCMOS33 [get_ports ncsi_clk]
set_property IOSTANDARD LVCMOS33 [get_ports {ncsi_rxd[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ncsi_rxd[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ncsi_txd[1]}]
set_property DRIVE 4 [get_ports {ncsi_txd[1]}]
set_property SLEW SLOW [get_ports {ncsi_txd[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ncsi_txd[0]}]
set_property DRIVE 4 [get_ports {ncsi_txd[0]}]
set_property SLEW SLOW [get_ports {ncsi_txd[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports ncsi_rx_crs_dv]
set_property IOSTANDARD LVCMOS33 [get_ports ncsi_tx_en]
set_property DRIVE 4 [get_ports ncsi_tx_en]
set_property SLEW SLOW [get_ports ncsi_tx_en]
set_property IOSTANDARD LVCMOS18 [get_ports acq_trigger]
set_property DRIVE 4 [get_ports acq_trigger]
set_property SLEW SLOW [get_ports acq_trigger]
set_property IOSTANDARD LVCMOS18 [get_ports espi_alert_n]
set_property DRIVE 4 [get_ports espi_alert_n]
set_property SLEW SLOW [get_ports espi_alert_n]
set_property IOSTANDARD LVCMOS33 [get_ports pwm_out]
set_property DRIVE 4 [get_ports pwm_out]
set_property SLEW SLOW [get_ports pwm_out]
set_property IOSTANDARD LVCMOS33 [get_ports status_gled]
set_property DRIVE 4 [get_ports status_gled]
set_property SLEW SLOW [get_ports status_gled]
set_property IOSTANDARD LVCMOS33 [get_ports status_rled]
set_property DRIVE 4 [get_ports status_rled]
set_property SLEW SLOW [get_ports status_rled]
set_property IOSTANDARD LVCMOS33 [get_ports user_gled]
set_property DRIVE 4 [get_ports user_gled]
set_property SLEW SLOW [get_ports user_gled]
set_property IOSTANDARD LVCMOS33 [get_ports user_rled]
set_property DRIVE 4 [get_ports user_rled]
set_property SLEW SLOW [get_ports user_rled]
