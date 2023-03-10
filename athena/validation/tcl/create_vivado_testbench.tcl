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
set WAVES_DIR          ${VALIDATION_DIR}/waves


set IP_USER_FILES      ${PROJECT_DIR}/${PROJECT_NAME}.ip_user_files 
set IP_COMPILED_LIBS   ${IP_USER_FILES}/ipstatic 

set AXI_SYSTEM_BD_FILE ${SYSTEM_DIR}/ipi_testbench_v2.tcl
set WAVE_FILE          ${WAVES_DIR}/all_waves.do

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

set_property -name {modelsim.simulate.custom_wave_do} -value ${WAVE_FILE} -objects [get_filesets sim_1]


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


################################################
# Add files required for the testbench
################################################
add_files -norecurse ${LOCAL_IP_DIR}/pcie2AxiMaster_v3.0/design/regfile_pcie2AxiMaster.vhd 
add_files -norecurse ${LOCAL_IP_DIR}/pcie2AxiMaster_v3.0/design/pciepack.vhd
add_files -norecurse ${LOCAL_IP_DIR}/pcie2AxiMaster_v3.0/design/pcie_tx_axi.vhd 

add_files -norecurse ${LOCAL_IP_DIR}/dmawr2tlp/validation/src/tlp_interface.sv
add_files -norecurse ${IPCORES_DIR}/interfaces/sv/axi_stream_interface.sv

add_files -norecurse ${VALIDATION_SRCDIR}/testbench_athena.sv

set_property TOP testbench_athena [get_filesets sim_1]
update_compile_order -fileset sources_1


################################################
# Export simulation framework for Modelsim
################################################
export_simulation  -lib_map_path ${MODELSIM_LIB} -absolute_path -force -directory ${VALIDATION_DIR} -simulator modelsim  -ip_user_files_dir ${IP_USER_FILES} -ipstatic_source_dir ${IP_COMPILED_LIBS}   -use_ip_compiled_libs 
file copy -force ${VALIDATION_DIR}/util/touchup.sh ${VALIDATION_DIR}/modelsim
file copy -force ${WAVE_FILE} ${VALIDATION_DIR}/modelsim/wave.do


puts "** Done."



