# ##################################################################################
# File         : create_athena.tcl
# Description  : TCL script used to create the MIOX fpga project. 
#
# Example      : source $env(IRIS4)/athena/backend/artix7/create_athena.tcl
#                source $env(IRIS4)/athena/backend/artix7/firmwares.tcl
#                source $env(IRIS4)/athena/backend/artix7/report_implementation.tcl
#                source $env(IRIS4)/athena/backend/artix7/archive.tcl
# ##################################################################################
#set myself $env(IRIS4)/athena/backend/artix7/create_athena2.tcl
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
# 0.1.0 : Fixed the PHY BIT LOCK ERROR   (See JIRA : IRIS4-248)
#         Changed the project name created by thhe backend script. Now the buildID is given as HEX (easier to match in hex with bench tools)
#
# 0.2.0 : Redesigne the xgs_hispi_top module. Significantly reduced the number of ram block required 
#             Removed the central line buffer
#             Each lane_decoder contains its own local line_buffer (split in 4 sub-buffers for 4 lines)
#             Remove the lane_packer module. Now the top and bottom lanes are packed in the axi_line_streamer module
#         UPDATED THE REGISTERFILE. 
#             Removed HISPI.LANE_PACKER_STATUS registers
#
# 0.3.0 : Modified backend scripts for generating all flavor of athena FPGA
#         Fixed the HiSPi CRC issue  (See JIRA : MT-2021)
#
# 0.3.1 : Fixed DMA image flick-ering (load of DMA address is now on the rising of strobe signal)
#
# 0.3.2 : Fixed I2C, Enable I2C stretching for Liquid lens in the matrox I2C AXI IP
#
# 0.3.3 : Implemented mono processing path including
#              ** X_ROI (cropping)
#              ** X_subsampling [0:15]
#              ** X_reverse
#
# 0.4.0 : Implemented Golden upgrade mechanism
#         Connected the register field fpga.version.firmware type to the Athena top level Generic : FPGA_IS_NPI_GOLDEN       
#
# 0.5.0 : Added support for color mode
#          
# 0.5.1 : Added support for Planar color mode, YUV Subsampling and RGB to Y conversion
#         Complete universal Trim module for Mono and Color fpga
#
# 0.5.2 : Added support for dummy grab(enable data path), after the confirmation of Onsemi that a dummy grab must 
#         be done after dcf load to avoid one frame lost at minimum exposure   
#
# 0.5.3 : Fix support for dummy grab(enable data path), when activating dummy grab, fpga generates phy_bit_locked_error because   
#         signal hclk_idle_detected was masked by logic.  
#
# 0.5.4 : COLOR FPGA : Add support for DPC with Raw images (for NPI) and also add support for Bayer images with DPC disabled.
#
set FPGA_MAJOR_VERSION     0
set FPGA_MINOR_VERSION     5
set FPGA_SUB_MINOR_VERSION 4

set EYE_SCAN               0

set SYNTH_RUN "synth_1"
set IMPL_RUN  "impl_1"
set JOB_COUNT  4

set VIVADO_SHORT_VERSION [version -short]

# Directory structure
set SRC_DIR      ${WORKDIR}/design
set IPCORES_DIR  ${WORKDIR}/ipcores
set LOCAL_IP_DIR ${WORKDIR}/local_ip
set TCL_DIR      ${BACKEND_DIR}
set SYSTEM_DIR   ${BACKEND_DIR}
set XDC_DIR      ${BACKEND_DIR}

set ARCHIVE_SCRIPT     ${TCL_DIR}/archive.tcl
set FIRMWARE_SCRIPT    ${TCL_DIR}/firmwares.tcl
set FILESET_SCRIPT     ${TCL_DIR}/add_files.tcl
set REPORT_FILE        ${BACKEND_DIR}/report_implementation.tcl

#---------------------------
# Source GTX Block Design
#---------------------------
if {$EYE_SCAN == 0} {
  set AXI_SYSTEM_BD_FILE ${SYSTEM_DIR}/system.tcl
} else {
  set AXI_SYSTEM_BD_FILE ${SYSTEM_DIR}/system_EyeScan.tcl
}

set FPGA_FULL_VERSION  "v${FPGA_MAJOR_VERSION}.${FPGA_MINOR_VERSION}.${FPGA_SUB_MINOR_VERSION}"
set VIVADO_DIR         ${WORKDIR}/vivado/${FPGA_FULL_VERSION}


###################################################################################
# Define the builID using the Unix epoch (time in seconds since midnight 1/1/1970)
###################################################################################
set FPGA_BUILD_DATE [clock seconds]
set BUILD_TIME  [clock format ${FPGA_BUILD_DATE} -format "%Y-%m-%d %H:%M:%S"]
set HEX_BUILD_DATE [format "0x%08x" $FPGA_BUILD_DATE]

puts "FPGA_BUILD_DATE =  $HEX_BUILD_DATE (${BUILD_TIME})"

set PROJECT_NAME  ${BASE_NAME}_${HEX_BUILD_DATE}

if {$COLOR_FPGA == 0} {
  if {$FPGA_IS_NPI_GOLDEN==1} {
    set PROJECT_DIR  ${VIVADO_DIR}/golden/${PROJECT_NAME}
  } else {
    set PROJECT_DIR  ${VIVADO_DIR}/upgrade/${PROJECT_NAME}
  }
} else {
  #_changed _color to _rgb in order to reduce path length
  if {$FPGA_IS_NPI_GOLDEN==1} {
    set PROJECT_DIR  ${VIVADO_DIR}/golden/${PROJECT_NAME}_rgb
  } else {
    set PROJECT_DIR  ${VIVADO_DIR}/upgrade/${PROJECT_NAME}_rgb
  }
}

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
set_property XPM_LIBRARIES {XPM_FIFO} [current_project]

set_property  ip_repo_paths  [list ${LOCAL_IP_DIR} ${IPCORES_DIR} ] [current_project]
update_ip_catalog



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

# MONO/COLOR Set property COLOR of Block design XGS_athena_0 
set_property -dict [list CONFIG.COLOR ${COLOR_FPGA}] [get_bd_cells XGS_athena_0]

## Generate Bloc design global (Out of context does not work)
set_property synth_checkpoint_mode None [get_files ${BD_FILE}]
generate_target all ${BD_FILE}

#######################################################
# Assign .elf to microblaze if EYE_SCAM IS ENABLED :)
#######################################################
if {$EYE_SCAN == 1} {
  add_files -norecurse C:/work/iris4/athena/backend/artix7/eyescan_software.elf
  set_property SCOPED_TO_REF system_pb [get_files -all -of_objects [get_fileset sources_1] {C:/work/iris4/athena/backend/artix7/eyescan_software.elf}]
  set_property SCOPED_TO_CELLS { eyescan_microblaze_system/microblaze_0 } [get_files -all -of_objects [get_fileset sources_1] {C:/work/iris4/athena/backend/artix7/eyescan_software.elf}]
}

################################################
# Top level Generics
################################################
set_property top athena [current_fileset]

set generic_list [list FPGA_BUILD_DATE=${FPGA_BUILD_DATE} FPGA_MAJOR_VERSION=${FPGA_MAJOR_VERSION} FPGA_MINOR_VERSION=${FPGA_MINOR_VERSION} FPGA_SUB_MINOR_VERSION=${FPGA_SUB_MINOR_VERSION} FPGA_IS_NPI_GOLDEN=${FPGA_IS_NPI_GOLDEN} FPGA_DEVICE_ID=${FPGA_DEVICE_ID}]
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
