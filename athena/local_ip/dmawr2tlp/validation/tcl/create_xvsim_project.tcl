# ##################################################################################
# File         : create_XCelerator_artix7.tcl
# Description  : TCL script used to create the validation framework for the XGS ipcores
#
# Example      : source $env(IRIS4)/athena/ipcores/axiHiSPi/validation/tcl/create_xvsim_project.tcl
#
# ##################################################################################
set myself [info script]
puts "Running ${myself}"


# FPGA versions : 
# 0.0.1 : First version (Project setup)
set FPGA_MAJOR_VERSION     0
set FPGA_MINOR_VERSION     0
set FPGA_SUB_MINOR_VERSION 1


set BASE_NAME axiHispi
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

set ROOTDIR      $env(IRIS4)/athena

# IP repositories
set IPCORES_DIR     ${ROOTDIR}/ipcores
set COMMON_DIR      ${IPCORES_DIR}/common
set LOCAL_IP_DIR    ${ROOTDIR}/local_ip/ip
set IP_DIR          ${IPCORES_DIR}/axiHiSPi

set DESIGN_DIR      ${IP_DIR}/design

set VALIDATION_DIR  ${IP_DIR}/validation
set VIVADO_DIR      ${VALIDATION_DIR}/vivado/${VIVADO_SHORT_VERSION}
set TCL_DIR         ${VALIDATION_DIR}/tcl
set SRC_DIR         ${VALIDATION_DIR}/src
set XGS_MODEL_DIR   ${ROOTDIR}/testbench/models/XGS_model

set FILESET_SCRIPT     ${TCL_DIR}/add_files.tcl
set AXI_SYSTEM_BD_FILE ${TCL_DIR}/xgs12m_ipi_system.tcl
set VALIDATION_FILESET "sources_1" 
set SIMULATION_FILESET "sim_1"

###################################################################################
# Define the builID using the Unix epoch (time in seconds since midnight 1/1/1970)
###################################################################################
set FPGA_BUILD_DATE [clock seconds]
set BUILD_TIME  [clock format ${FPGA_BUILD_DATE} -format "%Y-%m-%d %H:%M:%S"]

puts "FPGA_BUILD_DATE =  $FPGA_BUILD_DATE (${BUILD_TIME})"
set PROJECT_NAME  ${BASE_NAME}_validation

set PROJECT_DIR  ${VIVADO_DIR}/${PROJECT_NAME}
file mkdir $PROJECT_DIR

cd $PROJECT_DIR

###################################################################################
# Create the Xilinx project
###################################################################################
create_project -force ${PROJECT_NAME} -part ${DEVICE}

set_property target_language VHDL [current_project]

set_property  ip_repo_paths  [list ${IPCORES_DIR} ${LOCAL_IP_DIR}] [current_project]
update_ip_catalog


################################################
# Block design
################################################
source ${AXI_SYSTEM_BD_FILE}


## Generate Bloc design global (Out of context does not work)
set BD_FILE [get_files "*xgs12m_receiver.bd"]
set_property synth_checkpoint_mode None [get_files ${BD_FILE}]
generate_target all ${BD_FILE}

################################################
# Create the Wrapper file
################################################
set BD_WRAPPER_FILE [make_wrapper -files [get_files "$BD_FILE"] -top]
add_files -norecurse -force $BD_WRAPPER_FILE


################################################
# Add project files (HDL, Constraints, IP, etc)
################################################
source ${FILESET_SCRIPT}

################################################
# Add project files (HDL, Constraints, IP, etc)
################################################
set WAVE_FILE ${VALIDATION_DIR}/waves/testbench_xgs12m_behav.wcfg
add_files -fileset  ${SIMULATION_FILESET} -norecurse ${WAVE_FILE}

################################################
# Set simulation properties
################################################
set SIM_OBJ [get_filesets  ${SIMULATION_FILESET}]
set_property xsim.view -value ${WAVE_FILE} -objects ${SIM_OBJ}
set_property -name {xsim.simulate.log_all_signals} -value {true} -objects ${SIM_OBJ}
set_property -name {xsim.simulate.no_quit} -value {true} -objects ${SIM_OBJ}
set_property -name {xsim.simulate.runtime} -value {1000us} -objects ${SIM_OBJ}

# Util command : XSIM compile
proc xc {} {
	launch_simulation -step compile -verbose
}

# Util command : XSIM elaborate
proc xe {} {
	launch_simulation -step elaborate
}

# Util command : XSIM simulate
proc xs {} {
	launch_simulation -step simulate
}

# Util command : XSIM all stept
proc xa {} {
	launch_simulation -step all
}

################################################
# Start simulation
################################################
xa

puts "** Done."



