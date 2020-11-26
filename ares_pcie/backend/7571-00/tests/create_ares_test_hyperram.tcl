# ##################################################################################
# File         : create_ares_test_hyperram.tcl
# Description  : TCL script used to create the ares FPGA firmware for the IRIS-GTX 
#                project and instantiate an HyperRam memory test in the microblaze 
#                local memory. 
#
# Example      : source $env(IRIS4)/ares_pcie/backend/7571-00/tests/create_ares_test_hyperram.tcl
# 
# write_bd_tcl -force $env(IRIS4)/ares_pcie/backend/7571-00/system_pcie_hyperram.tcl
#
# ##################################################################################
set myself [info script]
puts "Running ${myself}"

# ################################################################
# FPGA versions : 
# 0.0.1 : First version (Project setup)
# 0.0.2 : Set HyperRam freq to 125MHz, automatically generate HDF file
# 0.0.3 : Changed project naming scheme. The buildID is now in hex radix (easier to match in development tools)
#         Set the following parameters in the create_ares.tcl script 
#             * FPGA_GOLDEN     = false (MIL upgrade firmware)
#			  * FPGA_ID         = 0x11  (IrisGTX PCIe, Artix7 - A50-1L)
#			  * FPGA_BUILD_DATE = current date (epoch HEX)
#         The RPC2_CTRL now configure the tap delay from the GUI of the ip-core
#
# 0.0.4 : Fixed the Hyperram readback data sampling and increased operating frequency(See JIRA : IRIS4-242)
#         The Hyperram controller run @166.667MHz (Still 2 setup timing violations i.e. 26ps on hb_dq[7] and 11 ps on hb_dq[4])
#         Open a new BAR on PCIE and connect the tlp_to_aximaster
#         Set pcie deviceID to 0x5055 and sub-systemID to 0x0600
#         
# 0.0.5 : Connect the microblaze debugger directly to the memory blocks (local memory and hyperram)
#         Debugged PCIe BAR2 accesses
#
# 0.0.6 : New firmware name scheme. Required to support the new 7571-02 PCB (FPGA pinout modification)
#             ** The new name scheme is: ares_<PCB_VERSION>_<FPGA_DEVICE>_<BUILD_ID>
#         Updated register file :
#                  @0x0020 (FPGA_ID[4:0]) Added new bits definition on field Device_specific.FPGA_ID.FPGA_ID
#                  @0x0020 (FPGA_ID[31:28]) Created new field Device_specific.FPGA_ID.FPGA_STRAPS (report the FPGA PCB straps)
#         Enabled pull-ups on fpga_straps IO pins.
#         Connected  fpga_straps IO to the registerfield Device_specific.FPGA_ID.FPGA_STRAPS
#         Set the correct FPGA_ID to 0x11 (d'17)
# ################################################################
set FPGA_MAJOR_VERSION     0
set FPGA_MINOR_VERSION     0
set FPGA_SUB_MINOR_VERSION 6


set BASE_NAME  ares_7571_00_a50t_cfg0001
set DEVICE "xc7a50ticpg236-1L"
set VIVADO_SHORT_VERSION [version -short]

# #################################################################
#  ARES FPGA_ID (FPGA DEVICE ID MAP) :
# #################################################################
# 0x00 Reserved
# 0x01 Spartan6 LX9 fpga used on Y7449-00 (deprecated)
# 0x02 Spartan6 LX16 fpga used on Y7449-01,02
# 0x03 Artix7 A35T fpga used on Y7471-00 (deprecated)
# 0x04 Artix7 A50T fpga used on Y7471-01
# 0x05 Artix7 A50T fpga used on Y7471-02
# 0x06 Artix7 A50T fpga used on Y7449-03
# 0x07 Artix7 Spider PCIe on Advanced IO board
# 0x08 Artix7 Ares PCIe (Iris3 Spider+Profiblaze on Y7478-00)
# 0x09 Artix7 Ares PCIe (Iris3 Spider+Profiblaze on Y7478-01)
# 0x0A:0x0F   Reserved
# 0x10 Iris GTX, Artix7 Ares PCIe, Artix7 A35T on Y7571-[00,01]
# 0x11 Iris GTX, Artix7 Ares PCIe, Artix7 A50T on Y7571-[00,01]
# 0x12 Iris GTX, Artix7 Ares PCIe, Artix7 A35T on Y7571-02
# 0x13 Iris GTX, Artix7 Ares PCIe, Artix7 A50T on Y7571-02
set FPGA_ID 17; # 0x11 Iris GTX, Artix7 Ares PCIe, Artix7 A50T on Y7571-[00,01]

set FPGA_GOLDEN     "false"


set WORKDIR      $env(IRIS4)/ares_pcie
set IPCORES_DIR  ${WORKDIR}/ipcores
set LOCAL_IP_DIR ${WORKDIR}/local_ip
set VIVADO_DIR   D:/vivado
set BACKEND_DIR  ${WORKDIR}/backend/7571-00
set TCL_DIR      ${BACKEND_DIR}
set SYSTEM_DIR   ${BACKEND_DIR}

set SRC_DIR            ${WORKDIR}/design
set REG_DIR            ${WORKDIR}/registerfile
set XDC_DIR            ${BACKEND_DIR}

set ARCHIVE_SCRIPT     ${TCL_DIR}/archive.tcl
set FIRMWARE_SCRIPT    ${TCL_DIR}/firmwares.tcl
set FILESET_SCRIPT     ${TCL_DIR}/add_files.tcl
set AXI_SYSTEM_BD_FILE ${SYSTEM_DIR}/system_pcie_hyperram.tcl
set REPORT_FILE        ${BACKEND_DIR}/report_implementation.tcl
set ELF_FILE           ${WORKDIR}/sdk/workspace/memtest/Debug/memtest.elf


set SYNTH_RUN "synth_1"
set IMPL_RUN  "impl_1"
set JOB_COUNT  4





###################################################################################
# Define the builID using the Unix epoch (time in seconds since midnight 1/1/1970)
###################################################################################
set FPGA_BUILD_DATE [clock seconds]
set BUILD_TIME  [clock format ${FPGA_BUILD_DATE} -format "%Y-%m-%d %H:%M:%S"]
set HEX_BUILD_DATE [format "0x%08x" $FPGA_BUILD_DATE]
puts "BUILD DATE =  ${BUILD_TIME}  ($HEX_BUILD_DATE)"

set PROJECT_NAME ${BASE_NAME}_${HEX_BUILD_DATE}
set PROJECT_DIR  ${VIVADO_DIR}/${PROJECT_NAME}
set PCB_DIR      ${PROJECT_DIR}/${PROJECT_NAME}.board_level
set SDK_DIR      ${PROJECT_DIR}/${PROJECT_NAME}.sdk
set RUN_DIR      ${PROJECT_DIR}/${PROJECT_NAME}.runs
set XPR_DIR      ${PROJECT_DIR}/${PROJECT_NAME}.xpr
				 
###################################################################################
# Create the project directories
###################################################################################
file mkdir      $PROJECT_DIR
file mkdir      $PCB_DIR

file delete -force ${XPR_DIR}
file delete -force ${RUN_DIR}


###################################################################################
# Create the Xilinx project
###################################################################################
cd $PROJECT_DIR
create_project -force ${PROJECT_NAME} -part ${DEVICE}

set_property target_language VHDL [current_project]
set_property simulator_language Mixed [current_project]
set_property target_simulator ModelSim [current_project]
set_property default_lib work [current_project]

set_property  ip_repo_paths  [list ${LOCAL_IP_DIR} ${IPCORES_DIR}] [current_project]
update_ip_catalog


################################################
# Generate IP-Integrator system
################################################
set HDL_FILESET [get_filesets sources_1]
set CONSTRAINTS_FILESET [get_filesets constrs_1]


source ${AXI_SYSTEM_BD_FILE}
regenerate_bd_layout


## Create the Wrapper file
set BD_FILE [get_files "ares_pb.bd"]
set BD_WRAPPER_FILE [make_wrapper -files [get_files "$BD_FILE"] -top]
add_files -norecurse -force $BD_WRAPPER_FILE

reset_target all ${BD_FILE}

## Generate Bloc design global (Out of context does not work)
set_property synth_checkpoint_mode None [get_files ${BD_FILE}]
generate_target all ${BD_FILE}
export_ip_user_files -of_objects ${BD_FILE} -no_script -sync -force


################################################
# Associate .elf file
################################################
set IMPL_FILE_SET [get_fileset sources_1]
set SIM_FILE_SET  [get_fileset sim_1]

add_files -fileset ${IMPL_FILE_SET} -norecurse ${ELF_FILE}
set_property used_in_simulation false [get_files ${ELF_FILE}]
set_property SCOPED_TO_REF ares_pb [get_files -all -of_objects ${IMPL_FILE_SET} ${ELF_FILE}]
set_property SCOPED_TO_CELLS { microblaze_0 } [get_files -all -of_objects ${IMPL_FILE_SET} ${ELF_FILE}]

add_files -fileset ${SIM_FILE_SET}  -norecurse ${ELF_FILE}
set_property SCOPED_TO_REF ares_pb [get_files -all -of_objects ${SIM_FILE_SET} ${ELF_FILE}]
set_property SCOPED_TO_CELLS { microblaze_0 } [get_files -all -of_objects ${SIM_FILE_SET} ${ELF_FILE}]


################################################
# Add project files (HDL, Constraints, IP, etc)
################################################
source ${FILESET_SCRIPT}


################################################
# Top level Generics
################################################
set generic_list [list    \
GOLDEN=${FPGA_GOLDEN}     \
BUILD_ID=${FPGA_BUILD_DATE} \
FPGA_ID=${FPGA_ID}        \
FPGA_MAJOR_VERSION=${FPGA_MAJOR_VERSION} \
FPGA_MINOR_VERSION=${FPGA_MINOR_VERSION} \
FPGA_SUB_MINOR_VERSION=${FPGA_SUB_MINOR_VERSION}]
set_property generic  ${generic_list} ${HDL_FILESET}


## Touchup to patch 
set_property is_enabled false [get_files  bd_a352_mac_0_clocks.xdc]

################################################
# Generate synthesis run
################################################
reset_run   ${SYNTH_RUN}
set_property strategy Flow_PerfOptimized_high [get_runs ${SYNTH_RUN}]
launch_runs ${SYNTH_RUN} -jobs ${JOB_COUNT}
wait_on_run ${SYNTH_RUN}


################################################
# Set strategy
################################################
#set_property strategy Flow_PerfOptimized_high [get_runs ${SYNTH_RUN}]
#set_property strategy Performance_Explore [get_runs $IMPL_RUN]


################################################
# Generate implementation run
################################################
current_run [get_runs $IMPL_RUN]
set_property strategy Performance_ExtraTimingOpt [get_runs $IMPL_RUN]
set_msg_config -id {Vivado 12-1790} -new_severity {WARNING}
launch_runs ${IMPL_RUN} -to_step write_bitstream -jobs ${JOB_COUNT}
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
# Generate firmware file
################################################
source ${FIRMWARE_SCRIPT}


################################################
# Generate hdf file
################################################
set top_entity_name [get_property top [current_fileset]]
set SYSDEF_FILE ${RUN_DIR}/${IMPL_RUN}/${top_entity_name}.sysdef
set HDF_FILE    ${SDK_DIR}/${top_entity_name}.hdf
file mkdir      $SDK_DIR

if { [file exists $SYSDEF_FILE] } {               
  if { [file exists $SDK_DIR] } {
      file copy -force ${SYSDEF_FILE} ${HDF_FILE}
      puts "copy ${SYSDEF_FILE} to ${HDF_FILE}"
  } else {
       puts "$SDK_DIR does not exist"
  }
} else {
  puts "$SYSDEF_FILE does not exist"
}


################################################
# Run Backend script
################################################
source  $REPORT_FILE

set route_status [get_property  STATUS [get_runs $IMPL_RUN]]
if [string match "route_design Complete, Failed Timing!" $route_status] {
     puts "** Timing error. You have to source $ARCHIVE_SCRIPT manually"
} elseif [string match "write_bitstream Complete!" $route_status] {
	 puts "** Write_bitstream Complete. Generating image"
 	 source  $ARCHIVE_SCRIPT
} else {
	 puts "** Run status: $route_status. Unknown status"
 }

puts "** Done."