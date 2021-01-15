# ##################################################################################
# File         : archive.tcl
# Description  : TCL script used to release the hallux fpga project. 
# Example      : source $env(IRIS4)/athena/backend/artix7/archive.tcl
# ##################################################################################
set myself [info script]
puts "Running ${myself}"


# Extract the current project top design name
set design_name [current_project]
set top_entity_name [get_property top [current_fileset]]


#savoir la grandeur du FPGA, a partir du device (hardcode Artix-7 ici)
regexp xc7a([0-9]+)t [get_property part [current_project]] dummy_var device_number

# Extracting the BUILD_ID
set buildid_generic [lsearch -inline [get_property generic [current_fileset]] "FPGA_BUILD_DATE=*"]
set buildid [regsub -nocase "FPGA_BUILD_DATE=" $buildid_generic "" ]
puts stdout [format "Build date is: %s" $buildid]

set SYNTH_RUN [current_run -synthesis]
set IMPL_RUN  [current_run -implementation]


open_run $IMPL_RUN

set project_directory [get_property  DIRECTORY [current_project]]
cd $project_directory

#--------------------------------------------
# Create vivado archive project 
#--------------------------------------------
set VIVADO_PROJECT_DIR        [get_property DIRECTORY ${design_name}]
set VIVADO_PROJECT_DIR_NAME   [file tail ${VIVADO_PROJECT_DIR}]


#--------------------------------------------
# On cree les repertoires du nouveau build   
#--------------------------------------------
set pre_release_dir              "//milent/4SightHD/708 IRIS4/10 FPGA/firmwares/athena/prerelease/${FPGA_FULL_VERSION}/${VIVADO_PROJECT_DIR_NAME}"
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
 
file copy -force ${IP_PCIE2AXIMASTER_DIR}/doc/pcie2AxiMaster_IPCore_Specification.docx     $pre_release_registerfile_dir
file copy -force ${IP_PCIE2AXIMASTER_DIR}/registerfile/regfile_pcie2AxiMaster.registerfile $pre_release_registerfile_dir
file copy -force ${IP_PCIE2AXIMASTER_DIR}/registerfile/regfile_pcie2AxiMaster.pdf          $pre_release_registerfile_dir
file copy -force ${IP_PCIE2AXIMASTER_DIR}/registerfile/regfile_pcie2AxiMaster.h            $pre_release_registerfile_dir
file copy -force ${IP_PCIE2AXIMASTER_DIR}/registerfile/regfile_pcie2AxiMaster.sl           $pre_release_registerfile_dir

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

