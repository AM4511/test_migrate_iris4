# ##################################################################################
# File         : firmwares.tcl
# Description  : TCL script used to release the hallux fpga project. 
# Example      : source $env(IRIS4)/ares_pcie/backend/report_implementation.tcl
# ##################################################################################
set myself [info script]
puts "Running ${myself}"

set REPORT_DIR ${OUTPUT_DIR}/reports

file mkdir ${REPORT_DIR}

################################################
# Generate Power report
################################################
set REPORT_NAME "power_${PROJECT_NAME}"
set_load 10 [all_outputs]
set_operating_conditions -ambient_temp 85.0
set_operating_conditions -board_layers 8to11
set_operating_conditions -board small
set_operating_conditions -heatsink high

report_power -file ${REPORT_DIR}/${REPORT_NAME}.txt -name ${REPORT_NAME}

################################################
# Generate HiSPi IO report
################################################
set IO_HISPI_DATA [get_ports {xgs_hispi_sdata_p[*]}]

# Input timings 
report_timing -rise_from [get_ports $IO_HISPI_DATA] -max_paths 64 -nworst 4 -delay_type min_max -name src_sync_edge_ddr_in_rise -file ${REPORT_DIR}/hispi_data_in_rise.txt;
report_timing -fall_from [get_ports $IO_HISPI_DATA] -max_paths 64 -nworst 4 -delay_type min_max -name src_sync_edge_ddr_in_fall -file ${REPORT_DIR}/hispi_data_in_fall.txt;
