# ##################################################################################
# File         : archive.tcl
# Description  : TCL script used to release the hallux fpga project. 
# Example      : source $env(IRIS4)/athena/backend/artix7/archive.tcl
# ##################################################################################
set myself [info script]
puts "Running ${myself}"

# Extracting the Working directory
set MYSELF_DIR [file dirname ${myself}]
set ROOTDIR [file normalize "${MYSELF_DIR}/../.."]
puts "ROOTDIR:  ${ROOTDIR}"
set WORKDIR                $env(IRIS4)/athena
set IPCORES_DIR            ${WORKDIR}/ipcores
set LOCAL_IP_DIR           ${WORKDIR}/local_ip


#le code plus bas utilise la variable design_name. Or cet variable est cree dans le script create_spider*.tcl.  Si on referme le projet et on l'ouvre, cette variable est disparue
set design_name [current_project]
set top_entity_name [get_property top [current_fileset]]


#savoir la grandeur du FPGA, a partir du device (hardcode Artix-7 ici)
regexp xc7a([0-9]+)t [get_property part [current_project]] dummy_var device_number

# Allons chercher le BUILD_ID
set buildid_generic [lsearch -inline [get_property generic [current_fileset]] "FPGA_BUILD_DATE=*"]
set buildid [regsub -nocase "FPGA_BUILD_DATE=" $buildid_generic "" ]
puts stdout [format "Build date is: 0x%s" $buildid]

# Extract the FPGA Major version
set generic [lsearch -inline [get_property generic [current_fileset]] "FPGA_MAJOR_VERSION=*"]
set MAJOR [regsub -nocase "FPGA_MAJOR_VERSION=" $generic "" ]

# Extract the FPGA Minor version
set generic [lsearch -inline [get_property generic [current_fileset]] "FPGA_MINOR_VERSION=*"]
set MINOR [regsub -nocase "FPGA_MINOR_VERSION=" $generic "" ]


# Extract the FPGA Sub-Minor version
set generic [lsearch -inline [get_property generic [current_fileset]] "FPGA_SUB_MINOR_VERSION=*"]
set SUB_MINOR [regsub -nocase "FPGA_SUB_MINOR_VERSION=" $generic "" ]

set FPGA_VERSION "${MAJOR}.${MINOR}.${SUB_MINOR}"


set FPGA_DESCRIPTION "IrisGTX Athena FPGA"
set YEAR [clock format [clock seconds] -format {%Y}]
set BUILD_DATE [clock format ${buildid} -format "%Y-%m-%d  %H:%M:%S"]
set VIVADO_SHORT_VERSION [version -short]

set SYNTH_RUN [current_run -synthesis]
set IMPL_RUN  [current_run -implementation]
set DEVICE    [get_property part [current_project]]

open_run $IMPL_RUN

set project_directory [get_property  DIRECTORY [current_project]]
cd $project_directory

# Create the output dir
set OUTPUT_BASE_DIR "${project_directory}/output"
set OUTPUT_DIR $OUTPUT_BASE_DIR
set id 0
while {$id < 20} {
	
	set OUTPUT_DIR "${OUTPUT_BASE_DIR}/run_${id}"
	if { [file exist $OUTPUT_DIR] } {
		set id [expr $id + 1]
		} else {
		file mkdir ${OUTPUT_DIR}
			puts "Creating $OUTPUT_DIR"
			break
		}
} 

#set GENERIC_LIST [get_property generic [current_fileset]]
#set UPGRADE_OFFSET 0x400000
set UPGRADE_OFFSET 0x000000


set UPGRADE_BASE_NAME             $OUTPUT_DIR/${design_name}
set UPGRADE_BIT_FILENAME          ${UPGRADE_BASE_NAME}.bit
set UPGRADE_MCS_FILENAME          ${UPGRADE_BASE_NAME}.mcs
set UPGRADE_FIRMWARE_FILENAME     ${UPGRADE_BASE_NAME}.firmware


# Create upgrade firmware (bit+bin) + mcs
write_bitstream -bin_file -force $UPGRADE_BIT_FILENAME
write_cfgmem -force -format MCS -size 8 -interface SPIx4 -checksum  -loadbit "up ${UPGRADE_OFFSET} ${UPGRADE_BIT_FILENAME} " ${UPGRADE_MCS_FILENAME}


# ####################################################################################
# Generate .firmware
# ####################################################################################
set INFILE [open ${UPGRADE_MCS_FILENAME} r]
set OUTFILE [open ${UPGRADE_FIRMWARE_FILENAME} w]

puts $OUTFILE "Copyright (c) 1995-${YEAR} Matrox Electronic Systems Ltd."
puts $OUTFILE "All Rights Reserved."
puts $OUTFILE "";
puts $OUTFILE "$FPGA_DESCRIPTION"
puts $OUTFILE "FPGA Version   : $FPGA_VERSION"
puts $OUTFILE "BuildID        : $buildid"
puts $OUTFILE "Build date     : $BUILD_DATE"
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


#--------------------------------------------
# Create vivado archive project 
#--------------------------------------------
set VIVADO_PROJECT_DIR        [get_property DIRECTORY ${design_name}]
set VIVADO_PROJECT_DIR_NAME   [file tail ${VIVADO_PROJECT_DIR}]
# set tmp_dir                   ${OUTPUT_DIR}/tmp
# file mkdir $tmp_dir
# set ARCHIVE_FILE  ${OUTPUT_DIR}/${VIVADO_PROJECT_DIR_NAME}.xpr.zip
# archive_project ${ARCHIVE_FILE} -temp_dir  $tmp_dir -force -include_local_ip_cache -include_config_settings


#--------------------------------------------
# On cree les repertoires du nouveau build   
#--------------------------------------------
set pre_release_dir              "//milent/4SightHD/708 IRIS4/10 FPGA/firmwares/athena/prerelease/${VIVADO_PROJECT_DIR_NAME}"
set pre_release_rpt_dir          $pre_release_dir/rpt
set pre_release_registerfile_dir $pre_release_dir/registerfile
set pre_release_vivado_dir       $pre_release_dir/vivado

file mkdir $pre_release_dir
file mkdir $pre_release_rpt_dir
file mkdir $pre_release_registerfile_dir
file mkdir $pre_release_vivado_dir

file copy   -force  $OUTPUT_DIR $pre_release_dir

# Copie du fichier de probe 
set probe_file "$project_directory/${design_name}.runs/${IMPL_RUN}/debug_nets.ltx"
if [file exist $probe_file] {
	file copy -force $project_directory/${design_name}.runs/${IMPL_RUN}/debug_nets.ltx  $pre_release_dir
}

# Copie de qques rapports importants
file copy -force $project_directory/${design_name}.runs/${SYNTH_RUN}/${top_entity_name}_utilization_synth.rpt        $pre_release_rpt_dir
file copy -force $project_directory/${design_name}.runs/${IMPL_RUN}/${top_entity_name}_utilization_placed.rpt        $pre_release_rpt_dir
file copy -force $project_directory/${design_name}.runs/${IMPL_RUN}/${top_entity_name}_timing_summary_routed.rpt     $pre_release_rpt_dir
file copy -force $project_directory/${design_name}.runs/${IMPL_RUN}/${top_entity_name}_io_placed.rpt                 $pre_release_rpt_dir
file copy -force $project_directory/${design_name}.runs/${IMPL_RUN}/${top_entity_name}_clock_utilization_routed.rpt  $pre_release_rpt_dir

# Copie les fichiers du registerfile
set IP_PCIE2AXIMASTER_DIR  ${LOCAL_IP_DIR}/pcie2AxiMaster_v3.0
set IP_XGS_athena          ${LOCAL_IP_DIR}/XGS_athena
set IP_AXI_I2C             ${LOCAL_IP_DIR}/axi_i2c_1.0
set README_FILE            ${BACKEND_DIR}/Readme.txt
 
file copy -force ${IP_PCIE2AXIMASTER_DIR}/design/registerfile/pcie2AxiMaster.registerfile $pre_release_registerfile_dir
file copy -force ${IP_PCIE2AXIMASTER_DIR}/doc/pcie2AxiMaster_IPCore_Specification.docx    $pre_release_registerfile_dir
file copy -force ${IP_PCIE2AXIMASTER_DIR}/doc/pcie2AxiMaster.pdf                          $pre_release_registerfile_dir
file copy -force ${IP_PCIE2AXIMASTER_DIR}/sdk/pcie2AxiMaster.h                            $pre_release_registerfile_dir
file copy -force ${IP_PCIE2AXIMASTER_DIR}/misc/pcie2AxiMaster.sl                          $pre_release_registerfile_dir

file copy -force ${IP_XGS_athena}/registerfile/regfile_xgs_athena.registerfile            $pre_release_registerfile_dir
file copy -force ${IP_XGS_athena}/registerfile/regfile_xgs_athena.pdf                     $pre_release_registerfile_dir
file copy -force ${IP_XGS_athena}/registerfile/regfile_xgs_athena.h                       $pre_release_registerfile_dir
file copy -force ${IP_XGS_athena}/registerfile/regfile_xgs_athena.sl                      $pre_release_registerfile_dir

file copy -force ${IP_AXI_I2C}/registerfile/regfile_i2c.registerfile                      $pre_release_registerfile_dir
file copy -force ${IP_AXI_I2C}/registerfile/regfile_i2c.pdf                               $pre_release_registerfile_dir
file copy -force ${IP_AXI_I2C}/registerfile/regfile_i2c.h                                 $pre_release_registerfile_dir
file copy -force ${IP_AXI_I2C}/registerfile/regfile_i2c.sl                                $pre_release_registerfile_dir

puts "Done."
puts  [format "Please review the release in %s" [regsub -all "/" $pre_release_dir "\\\\"]]

