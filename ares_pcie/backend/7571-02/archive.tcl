# ##################################################################################
# File         : archive.tcl
# Description  : TCL script used to release the hallux fpga project. 
# Example      : source $env(IRIS4)/ares_pcie/backend/7571-02/archive.tcl
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
set pre_release_dir              "//milent/4SightHD/708 IRIS4/10 FPGA/firmwares/ares/prerelease/${FPGA_FULL_VERSION}/${VIVADO_PROJECT_DIR_NAME}"
set pre_release_sdk_dir          $pre_release_dir/sdk
set pre_release_rpt_dir          $pre_release_dir/rpt
set pre_release_registerfile_dir $pre_release_dir/registerfile
set pre_release_vivado_dir       $pre_release_dir/vivado

file mkdir $pre_release_dir
file mkdir $pre_release_rpt_dir
file mkdir $pre_release_registerfile_dir
file mkdir $pre_release_vivado_dir

# Copy SDK dir
file copy   -force  $SDK_DIR $pre_release_sdk_dir
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
set ARES_REGFILE_DIR  ${WORKDIR}/registerfile
set RPC_REGFILE_DIR   ${IPCORES_DIR}/rpc2_ctrl_controller/registerfile

file copy -force ${ARES_REGFILE_DIR}/regfile_ares.registerfile     $pre_release_registerfile_dir
file copy -force ${ARES_REGFILE_DIR}/regfile_ares.h                $pre_release_registerfile_dir
file copy -force ${ARES_REGFILE_DIR}/regfile_ares.sl               $pre_release_registerfile_dir
file copy -force ${ARES_REGFILE_DIR}/regfile_ares.pdf              $pre_release_registerfile_dir

file copy -force ${RPC_REGFILE_DIR}/rpc2_ctrl_regfile.registerfile $pre_release_registerfile_dir
file copy -force ${RPC_REGFILE_DIR}/output/rpc2_ctrl_regfile.h     $pre_release_registerfile_dir
file copy -force ${RPC_REGFILE_DIR}/output/rpc2_ctrl_regfile.sl    $pre_release_registerfile_dir
file copy -force ${RPC_REGFILE_DIR}/output/rpc2_ctrl_regfile.pdf   $pre_release_registerfile_dir

puts "Done."
puts  [format "Please review the release in %s" [regsub -all "/" $pre_release_dir "\\\\"]]

