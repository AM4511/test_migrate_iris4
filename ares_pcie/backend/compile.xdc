set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 2 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]
set_property CFGBVS GND [current_design]
set_property CONFIG_MODE SPIx2 [current_design]

set_property BITSTREAM.CONFIG.SPI_FALL_EDGE YES [current_design]
# Sets the FPGA to use a falling edge clock for SPI data
# capture. This improves timing margins and may allow
# faster clock rates for configuration.
#la valeur du timer doit etre assez precisement calculee pour que le dual-boot soit fiable. (voir fichier cfg_timer.xls)
set_property BITSTREAM.CONFIG.TIMER_CFG 32'h0000F61B [current_design]
set_property BITSTREAM.CONFIG.CONFIGFALLBACK ENABLE [current_design]

set_property BITSTREAM.CONFIG.UNUSEDPIN Pullnone [current_design]


#################################################################
## Data for the power report
#################################################################
set_property LOAD 10 [get_ports acq_trigger]
set_property LOAD 10 [get_ports debug_uart_txd]
set_property LOAD 10 [get_ports espi_alert_n]
set_property LOAD 10 [get_ports {espi_io[0]}]
set_property LOAD 10 [get_ports {espi_io[1]}]
set_property LOAD 10 [get_ports {espi_io[2]}]
set_property LOAD 10 [get_ports {espi_io[3]}]
set_property LOAD 10 [get_ports hb_ck]
set_property LOAD 10 [get_ports hb_ck_n]
set_property LOAD 10 [get_ports hb_cs_n]
set_property LOAD 10 [get_ports {hb_dq[0]}]
set_property LOAD 10 [get_ports {hb_dq[1]}]
set_property LOAD 10 [get_ports {hb_dq[2]}]
set_property LOAD 10 [get_ports {hb_dq[3]}]
set_property LOAD 10 [get_ports {hb_dq[4]}]
set_property LOAD 10 [get_ports {hb_dq[5]}]
set_property LOAD 10 [get_ports {hb_dq[6]}]
set_property LOAD 10 [get_ports {hb_dq[7]}]
set_property LOAD 10 [get_ports hb_rst_n]
set_property LOAD 10 [get_ports hb_rwds]
set_property LOAD 10 [get_ports hb_wp_n]
set_property LOAD 10 [get_ports ncsi_clk]
set_property LOAD 10 [get_ports ncsi_tx_en]
set_property LOAD 10 [get_ports {ncsi_txd[0]}]
set_property LOAD 10 [get_ports {ncsi_txd[1]}]
set_property LOAD 10 [get_ports {pcie_txn[0]}]
set_property LOAD 10 [get_ports {pcie_txp[0]}]
set_property LOAD 10 [get_ports pwm_out]
set_property LOAD 10 [get_ports spi_cs_n]
set_property LOAD 10 [get_ports {spi_sd[0]}]
set_property LOAD 10 [get_ports {spi_sd[1]}]
set_property LOAD 10 [get_ports {spi_sd[2]}]
set_property LOAD 10 [get_ports {spi_sd[3]}]
set_property LOAD 10 [get_ports status_gled]
set_property LOAD 10 [get_ports status_rled]
set_property LOAD 10 [get_ports sys_rst_out_n]
set_property LOAD 10 [get_ports {user_data_out[0]}]
set_property LOAD 10 [get_ports {user_data_out[1]}]
set_property LOAD 10 [get_ports {user_data_out[2]}]
set_property LOAD 10 [get_ports user_gled]
set_property LOAD 10 [get_ports user_rled]

# current_instance */axi_ethernet_0/U0/eth_mac/U0
# set_property IOB FALSE [get_cells {mii_interface/mii_txd*reg[*]}]
# set_property IOB FALSE [get_cells mii_interface/mii_tx_e*reg]
# set_property IOB FALSE [get_cells mii_interface/rx*_to_mac*reg]
# set_property IOB FALSE [get_cells {mii_interface/rx*_to_mac*reg[*]}]
# current_instance -quiet


