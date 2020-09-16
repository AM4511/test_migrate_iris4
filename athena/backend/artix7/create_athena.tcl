# ##################################################################################
# File         : create_athena.tcl
# Description  : TCL script used to create the MIOX fpga project. 
#
# Example      : source $env(IRIS4)/athena/backend/artix7/create_athena.tcl
#
# ##################################################################################
set myself [info script]
puts "Running ${myself}"


# FPGA versions : 
# 0.0.1 : First version (Project setup)
# 0.0.2 : New axiHiSPi
# 0.0.3 : New XGS_athena ip-core
# 0.0.5 : First version that grab frames
# 0.0.6 : XGS_athena now support 4 and 6 lanes sensors through DCF
# 0.0.7 : XGS_athena now report CRC errors, implements LUT, implements MSI IRQ, Fix a HiSPi calibration issue
#
# 0.0.8 : XGS_athena no HiSPI differential termination resistor on fpga, added General Arbiter to Logic. 
#
# 0.0.9 : XGS_athena/DMA, output line buffer structure now configurable (Fix PCIe back pressure problem); 
#         Parameterized XGS_athena to support max_payload size upto 1024
#         Set Xilinx PCI endpoint PCIe max payload size to 256 
#         Fixed IRQ masking/enabling in the Queue mechanism (PCIE2AXIMASTER)
#         Added a SW interrupt bit in pcie2aximaster (for debug)
#
set FPGA_MAJOR_VERSION     0
set FPGA_MINOR_VERSION     0
set FPGA_SUB_MINOR_VERSION 9


set BASE_NAME athena
#set DEVICE "xc7a35ticpg236-1L"
set DEVICE "xc7a50ticpg236-1L"
set VIVADO_SHORT_VERSION [version -short]


# Define a MIL upgrade firmware
set FPGA_IS_NPI_GOLDEN     0


# FPGA_DEVICE_ID (DEVICE ID MAP) :
#  0      : xc7z015iclg485-1
#  1      : TBD
#  2      : TBD
#  Others : reserved
set FPGA_DEVICE_ID 0

set WORKDIR      $env(IRIS4)/athena

# IP repositories
set IPCORES_DIR  ${WORKDIR}/ipcores
set LOCAL_IP_DIR ${WORKDIR}/local_ip

set VIVADO_DIR  ${WORKDIR}/vivado/${VIVADO_SHORT_VERSION}
set BACKEND_DIR ${WORKDIR}/backend/artix7
set TCL_DIR     ${BACKEND_DIR}
set SYSTEM_DIR  ${BACKEND_DIR}
set SRC_DIR     ${WORKDIR}/design
set XDC_DIR     ${BACKEND_DIR}

set ARCHIVE_SCRIPT     ${TCL_DIR}/archive.tcl
set FIRMWARE_SCRIPT    ${TCL_DIR}/firmwares.tcl
set FILESET_SCRIPT     ${TCL_DIR}/add_files.tcl
set AXI_SYSTEM_BD_FILE ${SYSTEM_DIR}/system.tcl
set REPORT_FILE        ${BACKEND_DIR}/report_implementation.tcl


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

file mkdir $PROJECT_DIR

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



set_property  ip_repo_paths  [list ${LOCAL_IP_DIR} ${IPCORES_DIR} ] [current_project]
update_ip_catalog

set_property XPM_LIBRARIES {XPM_FIFO} [current_project]






################################################
# Generate IP-Integrator system
################################################
set HDL_FILESET [get_filesets sources_1]
set CONSTRAINTS_FILESET [get_filesets constrs_1]


################################################
# Add project files (HDL, Constraints, IP, etc)
################################################
source ${FILESET_SCRIPT}


################################################
# Block design
################################################
source ${AXI_SYSTEM_BD_FILE}

## Create the Wrapper file
set BD_FILE [get_files "*system_pb.bd"]
set BD_WRAPPER_FILE [make_wrapper -files [get_files "$BD_FILE"] -top]
add_files -norecurse -force $BD_WRAPPER_FILE

reset_target all ${BD_FILE}

## Generate Bloc design global (Out of context does not work)
set_property synth_checkpoint_mode None [get_files ${BD_FILE}]
generate_target all ${BD_FILE}
#export_ip_user_files -of_objects ${BD_FILE} -no_script -sync -force


################################################
# Top level Generics
################################################
set_property top athena [current_fileset]

set generic_list [list FPGA_BUILD_DATE=${FPGA_BUILD_DATE} FPGA_MAJOR_VERSION=${FPGA_MAJOR_VERSION} FPGA_MINOR_VERSION=${FPGA_MINOR_VERSION} FPGA_SUB_MINOR_VERSION=${FPGA_SUB_MINOR_VERSION} FPGA_BUILD_DATE=${FPGA_BUILD_DATE} FPGA_IS_NPI_GOLDEN=${FPGA_IS_NPI_GOLDEN} FPGA_DEVICE_ID=${FPGA_DEVICE_ID}]
set_property generic  ${generic_list} ${HDL_FILESET}



################################################
# To evaluate runtime
################################################
set t0 [clock clicks -millisec]

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
#open_run ${IMPL_RUN}
#write_vhdl ${PCB_DIR}/pinout_${PROJECT_NAME}.vhd -mode pin_planning -force
#write_csv  ${PCB_DIR}/pinout_${PROJECT_NAME}.csv -force
#report_io -file ${PCB_DIR}/pinout_${PROJECT_NAME}.txt -format text -name io_${PROJECT_NAME}
#report_power -file ${PCB_DIR}/power_${PROJECT_NAME}.txt -name power_${PROJECT_NAME}

 
################################################
# Run Backend script
################################################
source  $FIRMWARE_SCRIPT
source  $REPORT_FILE
	
################################################
# Run archive script
################################################
set TOTAL_SETUP_NEGATIVE_SLACK [get_property  STATS.TNS [get_runs $IMPL_RUN]]
set TOTAL_HOLD_NEGATIVE_SLACK  [get_property  STATS.THS [get_runs $IMPL_RUN]]
set TOTAL_FAILED_NETS          [get_property  STATS.FAILED_NETS [get_runs $IMPL_RUN]]
set ROUTE_STATUS               [get_property  STATUS [get_runs $IMPL_RUN]]

if {$TOTAL_FAILED_NETS > 0} {
	 puts "** Compilation contains timing errors. You have to source $ARCHIVE_SCRIPT manually"
     close_design
	 
} elseif [string match "route_design Complete!" $ROUTE_STATUS] {
	 puts "** Write_bitstream Completed. Releasing project in the pre-release folder"
 	 source  $ARCHIVE_SCRIPT
} else {
	 puts "** Route status: $ROUTE_STATUS  Unknown route status"
}

puts stderr "Runtime [expr {([clock clicks -millisec]-$t0)/60000.}] min" ;# RS

puts "** Done."
