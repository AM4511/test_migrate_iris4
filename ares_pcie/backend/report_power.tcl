# ##################################################################################
# File         : firmwares.tcl
# Description  : TCL script used to release the hallux fpga project. 
# Example      : source $env(IRIS4)/ares_pcie/backend/report_power.tcl
# ##################################################################################
set myself [info script]
puts "Running ${myself}"

set REPORT_DIR ${OUTPUT_DIR}/power
set_load 10 [all_outputs]
set_operating_conditions -ambient_temp 85.0
set_operating_conditions -board_layers 8to11
set_operating_conditions -board small
set_operating_conditions -heatsink high

file mkdir ${REPORT_DIR}
report_power -file ${REPORT_DIR}/ares_pcie_power.txt  -name {ares_pcie_power}
