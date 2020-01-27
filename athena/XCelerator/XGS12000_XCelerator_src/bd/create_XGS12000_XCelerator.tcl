#*****************************************************************************************
# Vivado (TM) v2018.2 (64-bit)
#
# create_XGS12000_XCelerator.tcl: Tcl script for re-creating project 'XGS12000_XCelerator'
#
# Generated by Vivado on Mon Nov 18 10:24:14 +0100 2019
# IP Build 2256618 on Thu Jun 14 22:10:49 MDT 2018
#
# This file contains the Vivado Tcl commands for re-creating the project to the state
# when this script was generated. In order to re-create the project, please source this
# file in the Vivado Tcl Shell.
#
# Modified by RafT
#
#*****************************************************************************************
# NOTE: In order to use this script, make sure to have this folder structure with the
#       source files:
# 
# <source_folder>/bd : containing the bd + this script
# <source_folder>/ip : include here all IP cores relevant for the project
# 
# The project target folder _xil_proj_dir_ can be located anywhere, configurable in the script
# default = 'D:/temp/XGS12000_XCelerator_prj'
#
#
#*****************************************************************************************
# Tcl commands to execute the script in Vivado GUI, update base_path to your environment:
# 
# set base_path $env(IRIS4)/athena/XCelerator
# source $base_path/XGS12000_XCelerator_src/bd/create_XGS12000_XCelerator.tcl
#
#*****************************************************************************************



namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}

# Set the reference directory for source file relative paths (by default the value is script directory path)
set origin_dir [_tcl::get_script_folder]

# Use origin directory path location variable, if specified in the tcl shell
if { [info exists ::origin_dir_loc] } {
  set origin_dir $::origin_dir_loc
}

# Set the project name
set _xil_proj_name_ "XGS12000_XCelerator"

# Use project name variable, if specified in the tcl shell
if { [info exists ::user_project_name] } {
  set _xil_proj_name_ $::user_project_name
}

# Set the project dir
set _xil_proj_dir_ "$base_path/vivado"
#set _xil_proj_dir_ $env(IRIS4)/athena/vivado/${VIVADO_SHORT_VERSION}/XGS12000_XCelerator_prj


# Use project dir variable, if specified in the tcl shell
if { [info exists ::user_project_dir] } {
  set _xil_proj_dir_ $::user_project_dir
}

variable script_file
set script_file "create_XGS12000_XCelerator.tcl"

# Help information for this script
proc help {} {
  variable script_file
  puts "\nDescription:"
  puts "Recreate a Vivado project from this script. The created project will be"
  puts "functionally equivalent to the original project for which this script was"
  puts "generated. The script contains commands for creating a project, filesets,"
  puts "runs, adding/importing sources and setting properties on various objects.\n"
  puts "Syntax:"
  puts "$script_file"
  puts "$script_file -tclargs \[--origin_dir <path>\]"
  puts "$script_file -tclargs \[--project_name <name>\]"
  puts "$script_file -tclargs \[--project_dir <dir>\]"
  puts "$script_file -tclargs \[--help\]\n"
  puts "Usage:"
  puts "Name                   Description"
  puts "-------------------------------------------------------------------------"
  puts "\[--origin_dir <path>\]  Determine source file paths wrt this path. Default"
  puts "                       origin_dir path value is \".\", otherwise, the value"
  puts "                       that was set with the \"-paths_relative_to\" switch"
  puts "                       when this script was generated.\n"
  puts "\[--project_name <name>\] Create project with the specified name. Default"
  puts "                       name is the name of the project from where this"
  puts "                       script was generated.\n"
  puts "\[--project_dir <dir>\] Create project with the specified path."
  puts "\[--help\]               Print help information for this script"
  puts "-------------------------------------------------------------------------\n"
  exit 0
}

if { $::argc > 0 } {
  for {set i 0} {$i < $::argc} {incr i} {
    set option [string trim [lindex $::argv $i]]
    switch -regexp -- $option {
      "--origin_dir"   { incr i; set origin_dir [lindex $::argv $i] }
      "--project_name" { incr i; set _xil_proj_name_ [lindex $::argv $i] }
      "--help"         { help }
      default {
        if { [regexp {^-} $option] } {
          puts "ERROR: Unknown option '$option' specified, please type '$script_file -tclargs --help' for usage info.\n"
          return 1
        }
      }
    }
  }
}

# Set the directory path for the original project from where this script was exported
set orig_proj_dir "[file normalize "$origin_dir/${_xil_proj_name_}"]"
set proj_dir "[file normalize "${_xil_proj_dir_}"]"

# Create project
#create_project ${_xil_proj_name_} $proj_dir/${_xil_proj_name_} -part xcku040-ffva1156-2-e -force
create_project ${_xil_proj_name_} $proj_dir -part xcku040-ffva1156-2-e -force


# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Reconstruct message rules
# None

# Set project properties
set obj [current_project]
set_property -name "compxlib.modelsim_compiled_library_dir" -value "D:/Xilinx/vivado_2018.2/questa_10_6a" -objects $obj
set_property -name "default_lib" -value "xil_defaultlib" -objects $obj
set_property -name "dsa.accelerator_binary_content" -value "bitstream" -objects $obj
set_property -name "dsa.accelerator_binary_format" -value "xclbin2" -objects $obj
set_property -name "dsa.description" -value "Vivado generated DSA" -objects $obj
set_property -name "dsa.dr_bd_base_address" -value "0" -objects $obj
set_property -name "dsa.emu_dir" -value "emu" -objects $obj
set_property -name "dsa.flash_interface_type" -value "bpix16" -objects $obj
set_property -name "dsa.flash_offset_address" -value "0" -objects $obj
set_property -name "dsa.flash_size" -value "1024" -objects $obj
set_property -name "dsa.host_architecture" -value "x86_64" -objects $obj
set_property -name "dsa.host_interface" -value "pcie" -objects $obj
set_property -name "dsa.num_compute_units" -value "60" -objects $obj
set_property -name "dsa.platform_state" -value "pre_synth" -objects $obj
set_property -name "dsa.uses_pr" -value "1" -objects $obj
set_property -name "dsa.vendor" -value "xilinx" -objects $obj
set_property -name "dsa.version" -value "0.0" -objects $obj
set_property -name "enable_vhdl_2008" -value "1" -objects $obj
set_property -name "ip_cache_permissions" -value "read write" -objects $obj
set_property -name "ip_output_repo" -value "$proj_dir/${_xil_proj_name_}.cache/ip" -objects $obj
set_property -name "mem.enable_memory_map_generation" -value "1" -objects $obj
set_property -name "part" -value "xcku040-ffva1156-2-e" -objects $obj
set_property -name "sim.central_dir" -value "$proj_dir/${_xil_proj_name_}.ip_user_files" -objects $obj
set_property -name "sim.ip.auto_export_scripts" -value "1" -objects $obj
set_property -name "simulator_language" -value "Mixed" -objects $obj
set_property -name "target_language" -value "Verilog" -objects $obj
set_property -name "target_simulator" -value "XSim" -objects $obj
set_property -name "webtalk.activehdl_export_sim" -value "2" -objects $obj
set_property -name "webtalk.ies_export_sim" -value "2" -objects $obj
set_property -name "webtalk.modelsim_export_sim" -value "2" -objects $obj
set_property -name "webtalk.modelsim_launch_sim" -value "4" -objects $obj
set_property -name "webtalk.questa_export_sim" -value "2" -objects $obj
set_property -name "webtalk.riviera_export_sim" -value "2" -objects $obj
set_property -name "webtalk.vcs_export_sim" -value "2" -objects $obj
set_property -name "webtalk.xsim_export_sim" -value "2" -objects $obj
set_property -name "webtalk.xsim_launch_sim" -value "7" -objects $obj
set_property -name "xpm_libraries" -value "XPM_CDC XPM_FIFO XPM_MEMORY" -objects $obj


# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Set IP repository paths
set obj [get_filesets sources_1]
#set_property "ip_repo_paths" "[file normalize "$origin_dir/../ip"]" $obj
set_property "ip_repo_paths" "[file normalize "$base_path/XGS12000_XCelerator_src/ip"]" $obj

# Rebuild user ip_repo's index before adding any source files
update_ip_catalog -rebuild

# Create BD xgs12m_receiver:
set design_name xgs12m_receiver
#source $origin_dir/BD_XGS12000_receiver.tcl
source $base_path/XGS12000_XCelerator_src/bd/BD_XGS12000_receiver_VIPlight.tcl
generate_target -force all [get_files ${design_name}.bd]

set bd_file $proj_dir/${_xil_proj_name_}.srcs/sources_1/bd/${design_name}/${design_name}.bd
open_bd_design $bd_file
make_wrapper -files [get_files $bd_file] -top 
add_files -norecurse $proj_dir/${_xil_proj_name_}.srcs/sources_1/bd/${design_name}/hdl/${design_name}_wrapper.v

#fichier qui manquent pour faire une simulation
set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse $base_path/XGS12000_XCelerator_src/TB_xgs12m_receiver.sv

add_files -fileset sim_1 -norecurse $base_path/../testbench/models/XGS_model/xgs_model_pkg.vhd
add_files -fileset sim_1 -norecurse $base_path/../testbench/models/XGS_model/xgs_hispi.vhd
add_files -fileset sim_1 -norecurse $base_path/../testbench/models/XGS_model/xgs_image.vhd
add_files -fileset sim_1 -norecurse $base_path/../testbench/models/XGS_model/xgs_sensor_config.vhd
add_files -fileset sim_1 -norecurse $base_path/../testbench/models/XGS_model/xgs_spi_i2c.vhd
add_files -fileset sim_1 -norecurse $base_path/../testbench/models/XGS_model/xgs12m_chip.vhd

set_property used_in_synthesis false [get_files  *xgs_model_pkg.vhd]
set_property used_in_synthesis false [get_files  *xgs_hispi.vhd]
set_property used_in_synthesis false [get_files  *xgs_image.vhd]
set_property used_in_synthesis false [get_files  *xgs_sensor_config.vhd]
set_property used_in_synthesis false [get_files  *xgs_spi_i2c.vhd]
set_property used_in_synthesis false [get_files  *xgs12m_chip.vhd]

exec xvhdl --work chip_lib --93_mode $base_path/../testbench/models/XGS_model/xgs_model_pkg.vhd
exec xvhdl --work chip_lib --93_mode $base_path/../testbench/models/XGS_model/xgs_hispi.vhd
exec xvhdl --work chip_lib --93_mode $base_path/../testbench/models/XGS_model/xgs_image.vhd
exec xvhdl --work chip_lib --93_mode $base_path/../testbench/models/XGS_model/xgs_sensor_config.vhd
exec xvhdl --work chip_lib --93_mode $base_path/../testbench/models/XGS_model/xgs_spi_i2c.vhd
exec xvhdl --work chip_lib --93_mode $base_path/../testbench/models/XGS_model/xgs12m_chip.vhd

# Set 'sources_1' fileset file properties for local files
#set file "hdl/xgs12m_receiver_wrapper.vhd"
set file "hdl/xgs12m_receiver_wrapper.v"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VERILOG" -objects $file_obj
add_files -fileset sim_1 -norecurse $base_path/XGS12000_XCelerator_src/tb_AXI_VIP_Master_behav.wcfg
set_property xsim.view $base_path/XGS12000_XCelerator_src/tb_AXI_VIP_Master_behav.wcfg [get_filesets sim_1]



# Set 'sources_1' fileset properties
set obj [get_filesets sources_1]
set_property -name "top" -value "xgs12m_receiver_wrapper" -objects $obj

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

# Set 'constrs_1' fileset object
set obj [get_filesets constrs_1]

# Empty (no sources present)

# Set 'constrs_1' fileset properties
set obj [get_filesets constrs_1]
set_property -name "target_part" -value "xcku040-ffva1156-2-e" -objects $obj

# Create 'synth_1' run (if not found)
if {[string equal [get_runs -quiet synth_1] ""]} {
    create_run -name synth_1 -part xcku040-ffva1156-2-e -flow {Vivado Synthesis 2018} -strategy "Vivado Synthesis Defaults" -report_strategy {No Reports} -constrset constrs_1
} else {
  set_property strategy "Vivado Synthesis Defaults" [get_runs synth_1]
  set_property flow "Vivado Synthesis 2018" [get_runs synth_1]
}
set obj [get_runs synth_1]
set_property set_report_strategy_name 1 $obj
set_property report_strategy {Vivado Synthesis Default Reports} $obj
set_property set_report_strategy_name 0 $obj
# Create 'synth_1_synth_report_utilization_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs synth_1] synth_1_synth_report_utilization_0] "" ] } {
  create_report_config -report_name synth_1_synth_report_utilization_0 -report_type report_utilization:1.0 -steps synth_design -runs synth_1
}
set obj [get_report_configs -of_objects [get_runs synth_1] synth_1_synth_report_utilization_0]
if { $obj != "" } {

}
set obj [get_runs synth_1]
set_property -name "part" -value "xcku040-ffva1156-2-e" -objects $obj
set_property -name "strategy" -value "Vivado Synthesis Defaults" -objects $obj

# set the current synth run
current_run -synthesis [get_runs synth_1]

update_compile_order -fileset sources_1
regenerate_bd_layout
save_bd_design


puts "INFO: Project created:${_xil_proj_name_}"
