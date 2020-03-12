# ##################################################################################
# File         : xsct_script.tcl
# Description  : Xilinx XSCT TCL script used to create the athena_zc706 sdk project. 
#
# Reference    : http://www.xilinx.com/support/documentation/sw_manuals/xilinx2018_3/ug1208-xsct-reference-guide.pdf
#                http://www.xilinx.com/support/documentation/sw_manuals/xilinx2018_3/ug1283-bootgen-user-guide.pdf
# Example      : source $env(IRIS4)/athena/backend/zynq/sdk/xsct_script.tcl $project_path $project_name $hdf_file
#
# ##################################################################################
set myself [info script]
puts "Running ${myself}"

set debug 0

if {$debug == 0} {
   set PROJECT_DIR   [lindex $argv 0]
   set PROJECT_NAME  [lindex $argv 1]
   set SDK_DIR       [lindex $argv 2]
   set HDF_FILE      [lindex $argv 3]
   set OUTPUT_DIR    [lindex $argv 4]
   set WORKSPACE_DIR [lindex $argv 5]
   puts [lindex $argv 0]

} else {
  set BASE_NAME     athena_zc706
  set PROJECT_NAME  ${BASE_NAME}_1583776950
  set BUILD_DATE    
  set PROJECT_DIR   $env(IRIS4)/athena/vivado/2019.1/${PROJECT_NAME}
  set SDK_DIR       $env(IRIS4)/athena/sdk
  set OUTPUT_DIR    ${PROJECT_DIR}/output
  set WORKSPACE_DIR ${PROJECT_DIR}/${PROJECT_NAME}.sdk
  set HDF_FILE      ${WORKSPACE_DIR}/${BASE_NAME}.hdf
}
puts "PROJECT_DIR   ${PROJECT_DIR}"  
puts "PROJECT_NAME  ${PROJECT_NAME}"  
puts "SDK_DIR       ${SDK_DIR}"
puts "HDF_FILE      ${HDF_FILE}"     
puts "OUTPUT_DIR    ${OUTPUT_DIR}"
puts "WORKSPACE_DIR ${WORKSPACE_DIR}"

set HW_PROJECT_NAME  ${PROJECT_NAME}_hw
set BSP_PROJECT_NAME ${PROJECT_NAME}_bsp
set PROCESSOR        "ps7_cortexa9_0"
set OS_NAME          "standalone"

set FSBL_PROJECT_NAME  "fsbl"
set FSBL_PROJECT_PATH  "${WORKSPACE_DIR}/${FSBL_PROJECT_NAME}"
set FSBL_IMPORT_PATH   "${SDK_DIR}/${FSBL_PROJECT_NAME}"

set CONFIGURATION      "Debug"
set BOOTLOADER_ELF_FILE ${FSBL_PROJECT_PATH}/${CONFIGURATION}/${FSBL_PROJECT_NAME}.elf

# set the Eclipse SDK workspace
if {$debug == 0} {
	setws ${WORKSPACE_DIR}
}

# Create the hardware project
createhw  -name ${HW_PROJECT_NAME}   -hwspec ${HDF_FILE}

# Create the FSBL project
createapp -name ${FSBL_PROJECT_NAME} -app {Zynq FSBL} -proc ${PROCESSOR} -hwproject ${HW_PROJECT_NAME} -os ${OS_NAME}
configapp -app  ${FSBL_PROJECT_NAME}  define-compiler-symbols FSBL_DEBUG
projects -build 

# Copy the compiled .elf image to the output directory  
file copy -force ${BOOTLOADER_ELF_FILE} ${OUTPUT_DIR}

puts "${myself}: Done!"
