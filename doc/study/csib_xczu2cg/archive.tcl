# ##################################################################################
# File         : archive.tcl
# Description  : TCL script used to release the hallux fpga project. 
# Example      : source D:/git/gitlab/4sightev6/miox/backend/tcl/archive.tcl
# ##################################################################################
set myself [info script]
puts "Running ${myself}"


#--------------------------------------------
# On cree les repertoires du nouveau build   
#--------------------------------------------
set pre_release_dir  "//typhoon/proj/4sight-ev6/bitstreams/prerelease/${PROJECT_NAME}"
set ARCHIVE_IMAGE_DIR   $pre_release_dir/firmwares
set ARCHIVE_REGFILE_DIR $pre_release_dir/regfile
set ARCHIVE_SDK_DIR     $pre_release_dir/sdk
set ARCHIVE_VIVADO_DIR  $pre_release_dir/vivado

set IP_PCIE2AXIMASTER_DIR ${IPCORES_DIR}/pcie2AxiMaster
set IP_AXIMAIO_DIR        ${IPCORES_DIR}/axiMaio
set README_FILE           ${BACKEND_DIR}/Readme.txt

# Create archive folders 
file mkdir $pre_release_dir
file mkdir ${ARCHIVE_IMAGE_DIR}
file mkdir ${ARCHIVE_REGFILE_DIR}
file mkdir ${ARCHIVE_SDK_DIR}
file mkdir ${ARCHIVE_VIVADO_DIR}

# Copy firmwares 
file copy -force ${OUTPUT_DIR}/${BITSTREAM_FILE_NAME}  $ARCHIVE_IMAGE_DIR
file copy -force ${OUTPUT_DIR}/${BIN_IMAGE_NAME}       $ARCHIVE_IMAGE_DIR
file copy -force ${OUTPUT_DIR}/${MCS_IMAGE_NAME}       $ARCHIVE_IMAGE_DIR
file copy -force ${OUTPUT_DIR}/${UPGRADE_IMAGE_NAME}   $ARCHIVE_IMAGE_DIR
file copy -force ${OUTPUT_DIR}/fsbl.elf                $ARCHIVE_IMAGE_DIR

# Copy the Readme file
file copy -force ${README_FILE} ${pre_release_dir}

# Copy sdk files
file copy -force ${HDF_FILE} $ARCHIVE_SDK_DIR

# Copy pcie2AxiMaster register files
file copy -force ${IP_PCIE2AXIMASTER_DIR}/doc/pcie2AxiMaster.pdf  $ARCHIVE_REGFILE_DIR
file copy -force ${IP_PCIE2AXIMASTER_DIR}/sdk/pcie2AxiMaster.h    $ARCHIVE_REGFILE_DIR
file copy -force ${IP_PCIE2AXIMASTER_DIR}/misc/pcie2AxiMaster.sl  $ARCHIVE_REGFILE_DIR
file copy -force ${IP_PCIE2AXIMASTER_DIR}/misc/pcie2AxiMaster.xml $ARCHIVE_REGFILE_DIR

# Copy axiMaio register files
file copy -force ${IP_AXIMAIO_DIR}/doc/maio_registerfile.pdf  $ARCHIVE_REGFILE_DIR
file copy -force ${IP_AXIMAIO_DIR}/sdk/maio_registerfile.h    $ARCHIVE_REGFILE_DIR
file copy -force ${IP_AXIMAIO_DIR}/misc/maio_registerfile.sl  $ARCHIVE_REGFILE_DIR
file copy -force ${IP_AXIMAIO_DIR}/misc/maio_registerfile.xml $ARCHIVE_REGFILE_DIR

puts "Archive completed"
puts stdout [format "Files can be retrieved here : %s " [regsub -all "/" $pre_release_dir "\\"]]

