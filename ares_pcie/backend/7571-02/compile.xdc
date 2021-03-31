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
set_property BITSTREAM.CONFIG.TIMER_CFG 0x0000F61B [current_design]
set_property BITSTREAM.CONFIG.CONFIGFALLBACK ENABLE [current_design]

set_property BITSTREAM.CONFIG.UNUSEDPIN Pullnone [current_design]
