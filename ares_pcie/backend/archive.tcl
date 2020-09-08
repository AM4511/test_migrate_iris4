# ##################################################################################
# File         : archive.tcl
# Description  : TCL script used to release the hallux fpga project. 
# Example      : source $env(IRIS4)/ares_pcie/backend/artix7/archive.tcl
# ##################################################################################
set myself [info script]
puts "Running ${myself}"

# Extracting the Working directory
set WORKDIR                $env(IRIS4)/ares_pcie
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


set FPGA_DESCRIPTION "IrisGTX Ares PCIe FPGA"
set YEAR [clock format [clock seconds] -format {%Y}]
set BUILD_DATE [clock format ${buildid} -format "%Y-%m-%d  %H:%M:%S"]
set VIVADO_SHORT_VERSION [version -short]

set SYNTH_RUN [current_run -synthesis]
set IMPL_RUN  [current_run -implementation]
set DEVICE    [get_property part [current_project]]

open_run $IMPL_RUN

set project_directory [get_property  DIRECTORY [current_project]]
cd $project_directory

#--------------------------------------------
# Create the output dir
#--------------------------------------------
set OUTPUT_BASE_DIR "${project_directory}/output"
set OUTPUT_DIR $OUTPUT_BASE_DIR
set SDK_DIR  $project_directory/${design_name}.sdk
set RUNS_DIR $project_directory/${design_name}.runs
set IMPL_DIR ${RUNS_DIR}/${IMPL_RUN}


#--------------------------------------------
# On cree les repertoires du nouveau build   
#--------------------------------------------
set pre_release_dir              "//milent/4SightHD/708 IRIS4/10 FPGA/firmwares/ares/prerelease/${design_name}"
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


#--------------------------------------------
# Copie les fichiers du registerfile
#--------------------------------------------
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


#--------------------------------------------
# Copie de qques rapports importants
#--------------------------------------------
file copy -force $project_directory/${design_name}.runs/${SYNTH_RUN}/${top_entity_name}_utilization_synth.rpt        $pre_release_rpt_dir
file copy -force $project_directory/${design_name}.runs/${IMPL_RUN}/${top_entity_name}_utilization_placed.rpt        $pre_release_rpt_dir
file copy -force $project_directory/${design_name}.runs/${IMPL_RUN}/${top_entity_name}_timing_summary_routed.rpt     $pre_release_rpt_dir
file copy -force $project_directory/${design_name}.runs/${IMPL_RUN}/${top_entity_name}_io_placed.rpt                 $pre_release_rpt_dir
file copy -force $project_directory/${design_name}.runs/${IMPL_RUN}/${top_entity_name}_clock_utilization_routed.rpt  $pre_release_rpt_dir


puts "Done."
puts  [format "Please review the release in %s" [regsub -all "/" $pre_release_dir "\\\\"]]

