# ##################################################################################
# File         : athena_50t.tcl
# Description  : TCL script used to create athena fpga 50T. 
# ##################################################################################
set myself $env(IRIS4)/athena/backend/artix7_rev2/athena_50t.tcl
puts "Running ${myself}"

set BASE_NAME             "athena50t"
set DEVICE                "xc7a50ticpg236-1L"


# FPGA_DEVICE_ID (DEVICE ID MAP) :
# Generic passed to VHDL top level file by generic
#  0      : xc7a50ticpg236-1L
#  1      : xc7a35ticpg236-1L
#  Others : reserved
set FPGA_DEVICE_ID 0

# Generic passed to VHDL top level file by generic
set FPGA_IS_NPI_GOLDEN     0

# Flash programation offset 
# NPI Golden  : 0x000000)
# MIL Upgrade : 0x400000)
set FLASH_OFFSET 0x000000
