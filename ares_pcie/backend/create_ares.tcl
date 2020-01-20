# ##################################################################################
# File         : create_csib.tcl
# Description  : TCL script used to create the MIOX fpga project. 
#
# Example      : source $env(IRIS4)/ares_pcie/backend/create_ares.tcl
# 
# ##################################################################################
set myself [info script]
puts "Running ${myself}"


# FPGA versions : 
# 0.0.1 : First version (Project setup)
set FPGA_MAJOR_VERSION     0
set FPGA_MINOR_VERSION     0
set FPGA_SUB_MINOR_VERSION 1


set BASE_NAME  ares_xc7a50t
set DEVICE "xc7a50ticpg236-1L"
set VIVADO_SHORT_VERSION [version -short]


# Define a MIL upgrade firmware
set FPGA_IS_NPI_GOLDEN     0


# FPGA_DEVICE_ID (DEVICE ID MAP) :
#  0      : xc7a50ticpg236-1L
#  1      : xc7a35ticpg236-1L
#  2      : TBD
#  Others : reserved
set FPGA_DEVICE_ID 0

set WORKDIR     $env(IRIS4)/ares_pcie
set IPCORES_DIR "${WORKDIR}/cores $env(IRIS4)/ipcores"
set VIVADO_DIR  ${WORKDIR}/vivado/${VIVADO_SHORT_VERSION}
set BACKEND_DIR ${WORKDIR}/backend
set TCL_DIR     ${BACKEND_DIR}
set SYSTEM_DIR  ${BACKEND_DIR}

set SRC_DIR            ${WORKDIR}/design
set REG_DIR            ${WORKDIR}/registerfile
set XDC_DIR            ${BACKEND_DIR}

set ARCHIVE_SCRIPT     ${TCL_DIR}/archive.tcl
set FILESET_SCRIPT     ${TCL_DIR}/add_files.tcl
set AXI_SYSTEM_BD_FILE ${SYSTEM_DIR}/system_pcie_hyperram.tcl


set SYNTH_RUN "synth_1"
set IMPL_RUN  "impl_1"
set JOB_COUNT  4


###################################################################################
# Define the builID using the Unix epoch (time in seconds since midnight 1/1/1970)
###################################################################################
set FPGA_BUILD_DATE [clock seconds]
set BUILD_TIME  [clock format ${FPGA_BUILD_DATE} -format "%Y-%m-%d %H:%M:%S"]

puts "FPGA_BUILD_DATE =  $FPGA_BUILD_DATE (${BUILD_TIME})"
set PROJECT_NAME  ${BASE_NAME}_${FPGA_BUILD_DATE}

set PROJECT_DIR  ${VIVADO_DIR}/${PROJECT_NAME}
set PCB_DIR      ${PROJECT_DIR}/${PROJECT_NAME}.board_level

file mkdir $PROJECT_DIR
file mkdir $PCB_DIR

cd $PROJECT_DIR
file delete -force ${PROJECT_NAME}.xpr
file delete -force ${PROJECT_NAME}.runs


###################################################################################
# Create the Xilinx project
###################################################################################
create_project -force ${PROJECT_NAME} -part ${DEVICE}

set_property target_language VHDL [current_project]
set_property simulator_language Mixed [current_project]
set_property target_simulator ModelSim [current_project]
set_property default_lib work [current_project]

set_property  ip_repo_paths  ${IPCORES_DIR} [current_project]
update_ip_catalog


################################################
# Generate IP-Integrator system
################################################
set HDL_FILESET [get_filesets sources_1]
set CONSTRAINTS_FILESET [get_filesets constrs_1]


source ${AXI_SYSTEM_BD_FILE}
regenerate_bd_layout
#validate_bd_design
#save_bd_design


## Create the Wrapper file
set BD_FILE [get_files "*ares_pb.bd"]
set BD_WRAPPER_FILE [make_wrapper -files [get_files "$BD_FILE"] -top]
add_files -norecurse -force $BD_WRAPPER_FILE

reset_target all ${BD_FILE}

## Generate Bloc design global (Out of context does not work)
set_property synth_checkpoint_mode None [get_files ${BD_FILE}]
generate_target all ${BD_FILE}
export_ip_user_files -of_objects ${BD_FILE} -no_script -sync -force


################################################
# Add project files (HDL, Constraints, IP, etc)
################################################
source ${FILESET_SCRIPT}

################################################
# Top level Generics
################################################
set generic_list [list FPGA_BUILD_DATE=${FPGA_BUILD_DATE} FPGA_MAJOR_VERSION=${FPGA_MAJOR_VERSION} FPGA_MINOR_VERSION=${FPGA_MINOR_VERSION} FPGA_SUB_MINOR_VERSION=${FPGA_SUB_MINOR_VERSION} FPGA_BUILD_DATE=${FPGA_BUILD_DATE} FPGA_IS_NPI_GOLDEN=${FPGA_IS_NPI_GOLDEN} FPGA_DEVICE_ID=${FPGA_DEVICE_ID}]
set_property generic  ${generic_list} ${HDL_FILESET}

################################################
# Generate synthesis run
################################################
reset_run   ${SYNTH_RUN}
launch_runs ${SYNTH_RUN} -jobs ${JOB_COUNT}
wait_on_run ${SYNTH_RUN}


################################################
# Generate implementation run
################################################
current_run [get_runs $IMPL_RUN]
set_property strategy Performance_ExtraTimingOpt [get_runs $IMPL_RUN]
launch_runs ${IMPL_RUN} -jobs ${JOB_COUNT}
wait_on_run ${IMPL_RUN}


################################################
# Export board level info
################################################
open_run ${IMPL_RUN}
write_vhdl ${PCB_DIR}/pinout_${PROJECT_NAME}.vhd -mode pin_planning -force
write_csv  ${PCB_DIR}/pinout_${PROJECT_NAME}.csv -force
report_io -file ${PCB_DIR}/pinout_${PROJECT_NAME}.txt -format text -name io_${PROJECT_NAME}
report_power -file ${PCB_DIR}/power_${PROJECT_NAME}.txt -name power_${PROJECT_NAME}
close_design


################################################
# Run Backend script
################################################
set route_status [get_property  STATUS [get_runs $IMPL_RUN]]
if [string match "route_design Complete, Failed Timing!" $route_status] {
     puts "** Timing error. You have to source $ARCHIVE_SCRIPT manually"
} elseif [string match "write_bitstream Complete!" $route_status] {
	 puts "** Write_bitstream Complete. Generating image"
	 #source  $SDK_SCRIPT
 	 source  $ARCHIVE_SCRIPT
} else {
	 puts "** Run status: $route_status. Unknown status"
 }

puts "** Done."



