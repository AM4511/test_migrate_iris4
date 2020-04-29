
################################################################
# This is a generated script based on design: system
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2019.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source system_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7a50ticpg236-1L
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name system

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
matrox.com:Imaging:axiHiSPi:1.1.1\
matrox.com:user:axiXGS_controller:1.0\
matrox.com:user:AXI_i2c_Matrox:1.0\
xilinx.com:ip:clk_gen_sim:1.0\
matrox.com:user:dmawr2tlp:1.0.0\
matrox.com:user:modelAxiMasterLite:1.0\
matrox.com:user:xgs12m_model:1.0\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set anput [ create_bd_intf_port -mode Master -vlnv matrox.com:user:Athena2Ares_if_rtl:1.0 anput ]

  set dma_tlp [ create_bd_intf_port -mode Master -vlnv matrox.com:user:mtx_tlp_rtl:1.0 dma_tlp ]

  set i2c [ create_bd_intf_port -mode Master -vlnv matrox.com:user:I2C_Matrox_rtl:1.0 i2c ]


  # Create ports
  set led_out [ create_bd_port -dir O -from 1 -to 0 led_out ]

  # Create instance: axiHiSPi_0, and set properties
  set axiHiSPi_0 [ create_bd_cell -type ip -vlnv matrox.com:Imaging:axiHiSPi:1.1.1 axiHiSPi_0 ]

  # Create instance: axiXGS_controller_0, and set properties
  set axiXGS_controller_0 [ create_bd_cell -type ip -vlnv matrox.com:user:axiXGS_controller:1.0 axiXGS_controller_0 ]

  # Create instance: axi_i2c_0, and set properties
  set axi_i2c_0 [ create_bd_cell -type ip -vlnv matrox.com:user:AXI_i2c_Matrox:1.0 axi_i2c_0 ]
  set_property -dict [ list \
   CONFIG.CLOCK_STRETCHING {false} \
   CONFIG.NI_ACCESS {true} \
   CONFIG.SIMULATION {false} \
 ] $axi_i2c_0

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.ENABLE_ADVANCED_OPTIONS {1} \
   CONFIG.NUM_MI {4} \
   CONFIG.NUM_SI {1} \
 ] $axi_interconnect_0

  # Create instance: clk_gen_sim_0, and set properties
  set clk_gen_sim_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_gen_sim:1.0 clk_gen_sim_0 ]
  set_property -dict [ list \
   CONFIG.USER_AXI_CLK_0_FREQ {100} \
   CONFIG.USER_AXI_CLK_1_FREQ {200} \
   CONFIG.USER_NUM_OF_AXI_CLK {2} \
   CONFIG.USER_NUM_OF_SYS_CLK {0} \
   CONFIG.USER_SYS_CLK0_FREQ {200.000} \
 ] $clk_gen_sim_0

  # Create instance: dmawr2tlp_0, and set properties
  set dmawr2tlp_0 [ create_bd_cell -type ip -vlnv matrox.com:user:dmawr2tlp:1.0.0 dmawr2tlp_0 ]

  # Create instance: modelAxiMasterLite_0, and set properties
  set modelAxiMasterLite_0 [ create_bd_cell -type ip -vlnv matrox.com:user:modelAxiMasterLite:1.0 modelAxiMasterLite_0 ]
  set_property -dict [ list \
   CONFIG.ENABLE_INPUT_IO {true} \
   CONFIG.USER_IN_WIDTH {1} \
   CONFIG.USER_OUT_WIDTH {1} \
 ] $modelAxiMasterLite_0

  # Create instance: xgs12m_model_0, and set properties
  set xgs12m_model_0 [ create_bd_cell -type ip -vlnv matrox.com:user:xgs12m_model:1.0 xgs12m_model_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net axiHiSPi_0_m_axis [get_bd_intf_pins axiHiSPi_0/m_axis] [get_bd_intf_pins dmawr2tlp_0/s_axis]
  connect_bd_intf_net -intf_net axiXGS_controller_0_Anput_if [get_bd_intf_ports anput] [get_bd_intf_pins axiXGS_controller_0/Anput_if]
  connect_bd_intf_net -intf_net axiXGS_controller_0_XGS_controller_if [get_bd_intf_pins axiXGS_controller_0/XGS_controller_if] [get_bd_intf_pins xgs12m_model_0/xgs_ctrl]
  connect_bd_intf_net -intf_net axi_i2c_0_I2C_interface [get_bd_intf_ports i2c] [get_bd_intf_pins axi_i2c_0/I2C_interface]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axiXGS_controller_0/S_AXI] [get_bd_intf_pins axi_interconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins axi_i2c_0/S_AXI] [get_bd_intf_pins axi_interconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI [get_bd_intf_pins axiHiSPi_0/s_axi] [get_bd_intf_pins axi_interconnect_0/M02_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M03_AXI [get_bd_intf_pins axi_interconnect_0/M03_AXI] [get_bd_intf_pins dmawr2tlp_0/s_axi]
  connect_bd_intf_net -intf_net dmawr2tlp_0_dma_tlp [get_bd_intf_ports dma_tlp] [get_bd_intf_pins dmawr2tlp_0/dma_tlp]
  connect_bd_intf_net -intf_net modelAxiMasterLite_0_m_axi [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins modelAxiMasterLite_0/m_axi]
  connect_bd_intf_net -intf_net xgs12m_model_0_hispi_io [get_bd_intf_pins axiHiSPi_0/s_hispi] [get_bd_intf_pins xgs12m_model_0/hispi_io]

  # Create port connections
  connect_bd_net -net ACLK_1 [get_bd_pins axiHiSPi_0/axi_clk] [get_bd_pins axiXGS_controller_0/s_axi_aclk] [get_bd_pins axi_i2c_0/s_axi_aclk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_interconnect_0/M02_ACLK] [get_bd_pins axi_interconnect_0/M03_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins clk_gen_sim_0/axi_clk_0] [get_bd_pins dmawr2tlp_0/sys_clk] [get_bd_pins modelAxiMasterLite_0/axi_clk]
  connect_bd_net -net axiXGS_controller_0_led_out [get_bd_ports led_out] [get_bd_pins axiXGS_controller_0/led_out]
  connect_bd_net -net clk_gen_sim_0_axi_clk_1 [get_bd_pins axiHiSPi_0/idelay_clk] [get_bd_pins clk_gen_sim_0/axi_clk_1]
  connect_bd_net -net dmawr2tlp_0_intevent [get_bd_pins dmawr2tlp_0/intevent] [get_bd_pins modelAxiMasterLite_0/user_in]
  connect_bd_net -net pcie2AxiMaster_0_axim_rst_n [get_bd_pins axiHiSPi_0/axi_reset_n] [get_bd_pins axiXGS_controller_0/s_axi_aresetn] [get_bd_pins axi_i2c_0/s_axi_aresetn] [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_interconnect_0/M02_ARESETN] [get_bd_pins axi_interconnect_0/M03_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins clk_gen_sim_0/axi_rst_0_n] [get_bd_pins dmawr2tlp_0/sys_reset_n] [get_bd_pins modelAxiMasterLite_0/axi_reset_n]

  # Create address segments
  create_bd_addr_seg -range 0x00001000 -offset 0x00000000 [get_bd_addr_spaces modelAxiMasterLite_0/m_axi] [get_bd_addr_segs axiHiSPi_0/s_axi/registerfile] SEG_axiHiSPi_0_registerfile
  create_bd_addr_seg -range 0x00001000 -offset 0x00001000 [get_bd_addr_spaces modelAxiMasterLite_0/m_axi] [get_bd_addr_segs axiXGS_controller_0/S_AXI/S_AXI_reg] SEG_axiXGS_controller_0_S_AXI_reg
  create_bd_addr_seg -range 0x00001000 -offset 0x00002000 [get_bd_addr_spaces modelAxiMasterLite_0/m_axi] [get_bd_addr_segs axi_i2c_0/S_AXI/S_AXI_reg] SEG_axi_i2c_0_S_AXI_reg
  create_bd_addr_seg -range 0x00001000 -offset 0x00003000 [get_bd_addr_spaces modelAxiMasterLite_0/m_axi] [get_bd_addr_segs dmawr2tlp_0/s_axi/reg0] SEG_dmawr2tlp_0_reg0


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


