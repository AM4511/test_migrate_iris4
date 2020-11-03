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
#set_property LOAD 10 [get_ports hb_wp_n]

# current_instance */axi_ethernet_0/U0/eth_mac/U0
# set_property IOB FALSE [get_cells {mii_interface/mii_txd*reg[*]}]
# set_property IOB FALSE [get_cells mii_interface/mii_tx_e*reg]
# set_property IOB FALSE [get_cells mii_interface/rx*_to_mac*reg]
# set_property IOB FALSE [get_cells {mii_interface/rx*_to_mac*reg[*]}]
# current_instance -quiet









