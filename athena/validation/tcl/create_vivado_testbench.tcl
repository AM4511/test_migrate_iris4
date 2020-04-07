# ##################################################################################
# File         : create_athena.tcl
# Description  : TCL script used to create the MIOX fpga project. 
#
# Example      : source $env(IRIS4)/athena/validation/tcl/create_vivado_testbench.tcl
# 
# ##################################################################################
set myself [info script]
puts "Running ${myself}"


set PROJECT_NAME validation_athena
set DEVICE "xc7a50ticpg236-1L"

set VIVADO_SHORT_VERSION [version -short]


set WORKDIR            $env(IRIS4)/athena
set MODELSIM_LIB       $env(MTI_LIB_XILINX_PATH)

# IP repositories
set IPCORES_DIR        ${WORKDIR}/ipcores
set LOCAL_IP_DIR       ${WORKDIR}/local_ip
set SRC_DIR            ${WORKDIR}/design
				       
set VIVADO_DIR         ${WORKDIR}/vivado/${VIVADO_SHORT_VERSION}
set PROJECT_DIR        ${VIVADO_DIR}/${PROJECT_NAME}
set VALIDATION_DIR     ${WORKDIR}/validation
set VALIDATION_SRCDIR  ${WORKDIR}/validation/src

set TCL_DIR            ${VALIDATION_DIR}/tcl
set SYSTEM_DIR         ${VALIDATION_DIR}/tcl


set IP_USER_FILES      ${PROJECT_DIR}/${PROJECT_NAME}.ip_user_files 
set IP_COMPILED_LIBS   ${IP_USER_FILES}/ipstatic 

set AXI_SYSTEM_BD_FILE ${SYSTEM_DIR}/ipi_testbench_v2.tcl


###################################################################################
# Define the builID using the Unix epoch (time in seconds since midnight 1/1/1970)
###################################################################################
set FPGA_BUILD_DATE [clock seconds]
set BUILD_TIME  [clock format ${FPGA_BUILD_DATE} -format "%Y-%m-%d %H:%M:%S"]

puts "FPGA_BUILD_DATE =  $FPGA_BUILD_DATE (${BUILD_TIME})"

file mkdir $PROJECT_DIR

cd $PROJECT_DIR
file delete -force ${PROJECT_NAME}.xpr


###################################################################################
# Create the Xilinx project
###################################################################################
create_project -force ${PROJECT_NAME} -part ${DEVICE}

set_property target_language Verilog [current_project]
set_property simulator_language Mixed [current_project]
set_property target_simulator ModelSim [current_project]
set_property default_lib work [current_project]

set_property  ip_repo_paths  [list ${IPCORES_DIR} ${LOCAL_IP_DIR}] [current_project]
update_ip_catalog


################################################
# Block design
################################################
source ${AXI_SYSTEM_BD_FILE}


## Create the Wrapper file
set BD_FILE [get_files "*system.bd"]
set BD_WRAPPER_FILE [make_wrapper -files [get_files "$BD_FILE"] -top]
add_files -norecurse -force $BD_WRAPPER_FILE

reset_target all ${BD_FILE}

## Generate Bloc design global (Out of context does not work)
set_property synth_checkpoint_mode None [get_files ${BD_FILE}]
generate_target all ${BD_FILE}

add_files -norecurse ${VALIDATION_SRCDIR}/testbench_athena.sv

set_property TOP testbench_athena [get_filesets sim_1]



#set OUTPUT_DIR       "D:/work/iris4/athena/validation"
# set IP_USER_FILES    "D:/work/iris4/athena/vivado/2019.1/validation_athena/validation_athena.ip_user_files"
#set IP_COMPILED_LIBS "D:/work/iris4/athena/vivado/2019.1/validation_athena/validation_athena.ip_user_files/ipstatic"

export_simulation  -lib_map_path ${MODELSIM_LIB} -absolute_path -force -directory ${VALIDATION_DIR} -simulator modelsim  -ip_user_files_dir ${IP_USER_FILES} -ipstatic_source_dir ${IP_COMPILED_LIBS}   -use_ip_compiled_libs 
report_compile_order -of_objects [get_filesets sim_1] -used_in simulation -file  ${VALIDATION_DIR}/output_list.txt

file mkdir ${VALIDATION_DIR}/modelsim/modelsim_lib



################################################
# Generate IP-Integrator system
################################################
#set HDL_FILESET [get_filesets sources_1]
#set CONSTRAINTS_FILESET [get_filesets constrs_1]


puts "** Done."



