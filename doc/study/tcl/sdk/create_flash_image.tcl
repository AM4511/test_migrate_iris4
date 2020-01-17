# ##################################################################################
# File         : create_flash_image.tcl
# Description  : TCL script used to create the CSIB fpga project. 
#
# Example      : source $env(CSIB)/backend/tcl/sdk/create_flash_image.tcl
#
# ##################################################################################
set myself [info script]
puts "Running ${myself}"

set PROJECT_NAME  [current_project]
set PROJECT_DIR   [get_property DIRECTORY ${PROJECT_NAME}]

set YEAR             [clock format [clock seconds] -format {%Y}]
set FPGA_DESCRIPTION "CSIB Zynq MIL upgrade FPGA"
set FPGA_VERSION     "${FPGA_MAJOR_VERSION}.${FPGA_MINOR_VERSION}.${FPGA_SUB_MINOR_VERSION}"
set UPGRADE_OFFSET   0x00000

set OUTPUT_DIR          ${PROJECT_DIR}/output
set WORKSPACE_DIR       ${PROJECT_DIR}/${PROJECT_NAME}.sdk
set XSCT_SCRIPT         ${TCL_DIR}/sdk/xsct_script.tcl
set BIF_FILE            ${SDK_DIR}/bif/fsbl.bif
set BITSTREAM_FILE_NAME csib_top.bit
set BITSTREAM_FILE      ${PROJECT_DIR}/${PROJECT_NAME}.runs/${IMPL_RUN}/${BITSTREAM_FILE_NAME}
set IMAGE_NAME         "flash_${PROJECT_NAME}"

set MCS_IMAGE_NAME     "${IMAGE_NAME}.mcs"
set BIN_IMAGE_NAME     "${IMAGE_NAME}.bin"
set UPGRADE_IMAGE_NAME "${IMAGE_NAME}.firmware"

file mkdir $OUTPUT_DIR
file copy -force ${BITSTREAM_FILE} ${OUTPUT_DIR}

set SYSDEF_FILE ${PROJECT_DIR}/${PROJECT_NAME}.runs/${IMPL_RUN}/csib_top.sysdef
set HDF_FILE    ${WORKSPACE_DIR}/csib_top.hdf

 if [file exist ${SYSDEF_FILE}] {
	file mkdir $WORKSPACE_DIR
	file copy  -force ${SYSDEF_FILE} ${HDF_FILE}
	exec xsct  ${XSCT_SCRIPT} $PROJECT_DIR $PROJECT_NAME $SDK_DIR $HDF_FILE $OUTPUT_DIR $WORKSPACE_DIR
}

# Create image
cd ${OUTPUT_DIR}
exec bootgen -image ${BIF_FILE} -arch zynq -o $MCS_IMAGE_NAME
exec bootgen -image ${BIF_FILE} -arch zynq -o $BIN_IMAGE_NAME


# ####################################################################################
# Generate .firmware
# ####################################################################################
set INFILE  [open ${MCS_IMAGE_NAME} r]
set OUTFILE [open ${UPGRADE_IMAGE_NAME} w]

puts $OUTFILE "Copyright (c) 1995-${YEAR} Matrox Electronic Systems Ltd."
puts $OUTFILE "All Rights Reserved."
puts $OUTFILE "";
puts $OUTFILE "$FPGA_DESCRIPTION"
puts $OUTFILE "FPGA Version   : $FPGA_VERSION"
puts $OUTFILE "BuildID        : ${FPGA_BUILD_DATE}"
puts $OUTFILE "Build date     : $BUILD_TIME"
puts $OUTFILE "Vivado version : $VIVADO_SHORT_VERSION"
puts $OUTFILE "Device         : $DEVICE"
puts $OUTFILE "Firmware type  : UPGRADE"
puts $OUTFILE "Flash offset   : ${UPGRADE_OFFSET}"


# Generic section
puts $OUTFILE "\n";
puts $OUTFILE "MCS="

while { [gets $INFILE line] >= 0 } {
    puts $OUTFILE $line
}

close $INFILE
close $OUTFILE


cd ${PROJECT_DIR}
puts "${myself} : Done!"
