# ##################################################################################
# File         : create_flash_image.tcl
# Description  : TCL script used to create the MIOX fpga project. 
#
# Example      : source $env(IRIS4)/athena/backend/zynq/sdk/create_flash_image.tcl
#                                
# ##################################################################################
set myself [info script]
puts "Running ${myself}"

set WORKDIR      $env(IRIS4)/athena

set VIVADO_PROJECT_NAME  [current_project]
set VIVADO_PROJECT_DIR   [get_property DIRECTORY ${VIVADO_PROJECT_NAME}]

source ${VIVADO_PROJECT_DIR}/env.tcl

set YEAR                    [clock format [clock seconds] -format {%Y}]
set FPGA_DESCRIPTION        "Athena Zynq MIL upgrade FPGA"
set FPGA_VERSION            "${FPGA_MAJOR_VERSION}.${FPGA_MINOR_VERSION}.${FPGA_SUB_MINOR_VERSION}"
set UPGRADE_OFFSET          0x00000

set OUTPUT_DIR              ${VIVADO_PROJECT_DIR}/output
set WORKSPACE_DIR           ${VIVADO_PROJECT_DIR}/${VIVADO_PROJECT_NAME}.sdk
set XSCT_SCRIPT             ${WORKDIR}/backend/zynq/sdk/xsct_script.tcl
set BIF_FILE                ${WORKDIR}/sdk/bif/fsbl.bif
set BITSTREAM_FILE_NAME     ${BASE_NAME}.bit
set BITSTREAM_FILE          ${VIVADO_PROJECT_DIR}/${VIVADO_PROJECT_NAME}.runs/${IMPL_RUN}/${BITSTREAM_FILE_NAME}
set IMAGE_NAME              flash_${VIVADO_PROJECT_NAME}
set MCS_IMAGE_NAME          ${IMAGE_NAME}.mcs
set BIN_IMAGE_NAME          ${IMAGE_NAME}.bin
set MIL_UPGRADE_IMAGE_NAME  ${BASE_NAME}.firmware

file mkdir $OUTPUT_DIR
file copy -force ${BITSTREAM_FILE} ${OUTPUT_DIR}

set SYSDEF_FILE ${VIVADO_PROJECT_DIR}/${VIVADO_PROJECT_NAME}.runs/${IMPL_RUN}/${BASE_NAME}.sysdef
set HDF_FILE    ${WORKSPACE_DIR}/athena_top.hdf

# ####################################################################################
# Run the Vivado SDK using the xsct shell TCL script ${XSCT_SCRIPT}
# ####################################################################################
 if [file exist ${SYSDEF_FILE}] {
     file mkdir $WORKSPACE_DIR
     file copy  -force ${SYSDEF_FILE} ${HDF_FILE}
     set SDK_DIR ${WORKDIR}/sdk
     exec xsct  ${XSCT_SCRIPT} $VIVADO_PROJECT_DIR $VIVADO_PROJECT_NAME $SDK_DIR $HDF_FILE $OUTPUT_DIR $WORKSPACE_DIR
}

# ####################################################################################
# Create flash images (.mcs and .bin)
# ####################################################################################
cd ${OUTPUT_DIR}
exec bootgen -image ${BIF_FILE} -arch zynq -o $MCS_IMAGE_NAME
exec bootgen -image ${BIF_FILE} -arch zynq -o $BIN_IMAGE_NAME


# ####################################################################################
# Generate the MIL .firmware file for the Firmware update tool
# ####################################################################################
set INFILE  [open ${MCS_IMAGE_NAME} r]
set OUTFILE [open ${MIL_UPGRADE_IMAGE_NAME} w]

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


cd ${VIVADO_PROJECT_DIR}
puts "${myself} : Done!"
