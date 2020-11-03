# ##################################################################################
# File         : firmwares.tcl
# Description  : TCL script used to release the hallux fpga project. 
# Example      : source $env(IRIS4)/ares_pcie/backend/report_implementation.tcl
# ##################################################################################
set myself [info script]
puts "Running ${myself}"

set design_name [current_project]
set project_directory [get_property  DIRECTORY [current_project]]


set IMPL_RUN  [current_run -implementation]

open_run $IMPL_RUN


set OUTPUT_DIR ${project_directory}/output
set REPORT_DIR ${OUTPUT_DIR}/reports
file mkdir ${REPORT_DIR}

################################################
# Generate Power report
################################################
set_load 10 [all_outputs]
set_operating_conditions -ambient_temp 85.0
set_operating_conditions -board_layers 8to11
set_operating_conditions -board small
set_operating_conditions -heatsink high

report_power -file ${REPORT_DIR}/ares_pcie_power.txt  -name {ares_pcie_power}

################################################
# Generate Hyperram IO report
################################################
set HYPERRAM_DQ [get_ports {hb_dq[*]}]

# Input timings 
report_timing -rise_from [get_ports $HYPERRAM_DQ] -max_paths 64 -nworst 4 -delay_type min_max -name src_sync_edge_ddr_in_rise -file ${REPORT_DIR}/hyperram_ddr_in_rise.txt;
report_timing -fall_from [get_ports $HYPERRAM_DQ] -max_paths 64 -nworst 4 -delay_type min_max -name src_sync_edge_ddr_in_fall -file ${REPORT_DIR}/hyperram_ddr_in_fall.txt;

# Output timings 
report_timing -rise_to [get_ports $HYPERRAM_DQ] -max_paths 64 -nworst 4 -delay_type min_max -name src_sync_ddr_out_rise -file ${REPORT_DIR}/hyperram_ddr_out_rise.txt;
report_timing -fall_to [get_ports $HYPERRAM_DQ] -max_paths 64 -nworst 4 -delay_type min_max -name src_sync_ddr_out_fall -file ${REPORT_DIR}/hyperram_ddr_out_fall.txt;

