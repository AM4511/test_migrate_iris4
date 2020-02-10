
################################################################
# This is a generated script based on design: xgs12m_receiver
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
# source xgs12m_receiver_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7a50ticpg236-1L
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name xgs12m_receiver

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
xilinx.com:ip:axi_gpio:2.0\
onsemi.com:user:axi_video_xgs_decoder:2.0\
xilinx.com:ip:axi_vip:1.1\
onsemi.com:user:axi_xgs_hispi_deser:2.0\
xilinx.com:ip:axis_combiner:1.1\
xilinx.com:ip:axis_switch:1.1\
onsemi.com:user:test_pattern_generator:2.0\
onsemi.com:user:xgs12m_remapper:3.0\
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
  set GPIO [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 GPIO ]

  set M_AXIS [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS ]

  set xgs_bus_0 [ create_bd_intf_port -mode Slave -vlnv onsemi.com:user:xgs_bus_rtl:1.0 xgs_bus_0 ]

  set xgs_bus_1 [ create_bd_intf_port -mode Slave -vlnv onsemi.com:user:xgs_bus_rtl:1.0 xgs_bus_1 ]


  # Create ports
  set REFCLK [ create_bd_port -dir I REFCLK ]
  set aclk [ create_bd_port -dir I -type clk aclk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_RESET {aresetn} \
 ] $aclk
  set aresetn [ create_bd_port -dir I -type rst aresetn ]

  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {4} \
 ] $axi_gpio_0

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {7} \
 ] $axi_interconnect_0

  # Create instance: axi_video_xgs_decoder_0, and set properties
  set axi_video_xgs_decoder_0 [ create_bd_cell -type ip -vlnv onsemi.com:user:axi_video_xgs_decoder:2.0 axi_video_xgs_decoder_0 ]

  # Create instance: axi_video_xgs_decoder_1, and set properties
  set axi_video_xgs_decoder_1 [ create_bd_cell -type ip -vlnv onsemi.com:user:axi_video_xgs_decoder:2.0 axi_video_xgs_decoder_1 ]
  set_property -dict [ list \
   CONFIG.NumberOffEnables {0} \
 ] $axi_video_xgs_decoder_1

  # Create instance: axi_vip_0, and set properties
  set axi_vip_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_0 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.PROTOCOL {AXI4LITE} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW {0} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
 ] $axi_vip_0

  # Create instance: axi_xgs_hispi_deser_0, and set properties
  set axi_xgs_hispi_deser_0 [ create_bd_cell -type ip -vlnv onsemi.com:user:axi_xgs_hispi_deser:2.0 axi_xgs_hispi_deser_0 ]

  # Create instance: axi_xgs_hispi_deser_1, and set properties
  set axi_xgs_hispi_deser_1 [ create_bd_cell -type ip -vlnv onsemi.com:user:axi_xgs_hispi_deser:2.0 axi_xgs_hispi_deser_1 ]

  # Create instance: axis_combiner_0, and set properties
  set axis_combiner_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_combiner:1.1 axis_combiner_0 ]

  # Create instance: axis_switch_0, and set properties
  set axis_switch_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_switch:1.1 axis_switch_0 ]

  # Create instance: test_pattern_generat_0, and set properties
  set test_pattern_generat_0 [ create_bd_cell -type ip -vlnv onsemi.com:user:test_pattern_generator:2.0 test_pattern_generat_0 ]
  set_property -dict [ list \
   CONFIG.C_M00_AXIS_TDATA_WIDTH {512} \
   CONFIG.C_M00_AXIS_TUSER_WIDTH {64} \
   CONFIG.C_S00_AXI_ADDR_WIDTH {12} \
 ] $test_pattern_generat_0

  # Create instance: xgs12m_remapper_0, and set properties
  set xgs12m_remapper_0 [ create_bd_cell -type ip -vlnv onsemi.com:user:xgs12m_remapper:3.0 xgs12m_remapper_0 ]
  set_property -dict [ list \
   CONFIG.C_M_AXIS_TUSER_WIDTH {3} \
   CONFIG.C_S_AXIS_TUSER_WIDTH {3} \
 ] $xgs12m_remapper_0

  # Create interface connections
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins axi_vip_0/M_AXI]
  connect_bd_intf_net -intf_net axi_gpio_0_GPIO [get_bd_intf_ports GPIO] [get_bd_intf_pins axi_gpio_0/GPIO]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins axi_interconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins axi_interconnect_0/M01_AXI] [get_bd_intf_pins axi_xgs_hispi_deser_0/S00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI [get_bd_intf_pins axi_interconnect_0/M02_AXI] [get_bd_intf_pins axi_video_xgs_decoder_0/S00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M03_AXI [get_bd_intf_pins axi_interconnect_0/M03_AXI] [get_bd_intf_pins axi_xgs_hispi_deser_1/S00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M04_AXI [get_bd_intf_pins axi_interconnect_0/M04_AXI] [get_bd_intf_pins axi_video_xgs_decoder_1/S00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M05_AXI [get_bd_intf_pins axi_interconnect_0/M05_AXI] [get_bd_intf_pins xgs12m_remapper_0/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M06_AXI [get_bd_intf_pins axi_interconnect_0/M06_AXI] [get_bd_intf_pins test_pattern_generat_0/s00_axi]
  connect_bd_intf_net -intf_net axi_video_xgs_decoder_0_M_AXIS_VIDEO [get_bd_intf_pins axi_video_xgs_decoder_0/M_AXIS_VIDEO] [get_bd_intf_pins axis_combiner_0/S00_AXIS]
  connect_bd_intf_net -intf_net axi_video_xgs_decoder_1_M_AXIS_VIDEO [get_bd_intf_pins axi_video_xgs_decoder_1/M_AXIS_VIDEO] [get_bd_intf_pins axis_combiner_0/S01_AXIS]
  connect_bd_intf_net -intf_net axi_xgs_hispi_deser_0_M_AXIS [get_bd_intf_pins axi_video_xgs_decoder_0/S00_AXIS] [get_bd_intf_pins axi_xgs_hispi_deser_0/M_AXIS]
  connect_bd_intf_net -intf_net axi_xgs_hispi_deser_1_M_AXIS [get_bd_intf_pins axi_video_xgs_decoder_1/S00_AXIS] [get_bd_intf_pins axi_xgs_hispi_deser_1/M_AXIS]
  connect_bd_intf_net -intf_net axis_combiner_0_M_AXIS [get_bd_intf_pins axis_combiner_0/M_AXIS] [get_bd_intf_pins xgs12m_remapper_0/S_AXIS_VIDEO]
  connect_bd_intf_net -intf_net axis_switch_0_M00_AXIS [get_bd_intf_ports M_AXIS] [get_bd_intf_pins axis_switch_0/M00_AXIS]
  connect_bd_intf_net -intf_net test_pattern_generat_0_m00_axis [get_bd_intf_pins axis_switch_0/S01_AXIS] [get_bd_intf_pins test_pattern_generat_0/m00_axis]
  connect_bd_intf_net -intf_net xgs12m_remapper_0_M_AXIS_VIDEO [get_bd_intf_pins axis_switch_0/S00_AXIS] [get_bd_intf_pins xgs12m_remapper_0/M_AXIS_VIDEO]
  connect_bd_intf_net -intf_net xgs_bus_0_1 [get_bd_intf_ports xgs_bus_0] [get_bd_intf_pins axi_xgs_hispi_deser_0/xgs_bus]
  connect_bd_intf_net -intf_net xgs_bus_1_1 [get_bd_intf_ports xgs_bus_1] [get_bd_intf_pins axi_xgs_hispi_deser_1/xgs_bus]

  # Create port connections
  connect_bd_net -net REFCLK_1 [get_bd_ports REFCLK] [get_bd_pins axi_xgs_hispi_deser_0/REFCLK] [get_bd_pins axi_xgs_hispi_deser_1/REFCLK]
  connect_bd_net -net aclk_0_1 [get_bd_ports aclk] [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_interconnect_0/M02_ACLK] [get_bd_pins axi_interconnect_0/M03_ACLK] [get_bd_pins axi_interconnect_0/M04_ACLK] [get_bd_pins axi_interconnect_0/M05_ACLK] [get_bd_pins axi_interconnect_0/M06_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axi_video_xgs_decoder_0/M_AXIS_VIDEO_ACLK] [get_bd_pins axi_video_xgs_decoder_0/S00_AXI_ACLK] [get_bd_pins axi_video_xgs_decoder_1/M_AXIS_VIDEO_ACLK] [get_bd_pins axi_video_xgs_decoder_1/S00_AXI_ACLK] [get_bd_pins axi_vip_0/aclk] [get_bd_pins axi_xgs_hispi_deser_0/M_AXIS_ACLK] [get_bd_pins axi_xgs_hispi_deser_0/S00_AXI_ACLK] [get_bd_pins axi_xgs_hispi_deser_1/M_AXIS_ACLK] [get_bd_pins axi_xgs_hispi_deser_1/S00_AXI_ACLK] [get_bd_pins axis_combiner_0/aclk] [get_bd_pins axis_switch_0/aclk] [get_bd_pins test_pattern_generat_0/m00_axis_aclk] [get_bd_pins test_pattern_generat_0/s00_axi_aclk] [get_bd_pins xgs12m_remapper_0/AXIS_VIDEO_ACLK] [get_bd_pins xgs12m_remapper_0/S_AXI_ACLK]
  connect_bd_net -net aresetn_0_1 [get_bd_ports aresetn] [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_interconnect_0/M02_ARESETN] [get_bd_pins axi_interconnect_0/M03_ARESETN] [get_bd_pins axi_interconnect_0/M04_ARESETN] [get_bd_pins axi_interconnect_0/M05_ARESETN] [get_bd_pins axi_interconnect_0/M06_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins axi_video_xgs_decoder_0/M_AXIS_VIDEO_ARESETN] [get_bd_pins axi_video_xgs_decoder_0/S00_AXI_ARESETN] [get_bd_pins axi_video_xgs_decoder_1/M_AXIS_VIDEO_ARESETN] [get_bd_pins axi_video_xgs_decoder_1/S00_AXI_ARESETN] [get_bd_pins axi_vip_0/aresetn] [get_bd_pins axi_xgs_hispi_deser_0/M_AXIS_ARESETN] [get_bd_pins axi_xgs_hispi_deser_0/S00_AXI_ARESETN] [get_bd_pins axi_xgs_hispi_deser_1/M_AXIS_ARESETN] [get_bd_pins axi_xgs_hispi_deser_1/S00_AXI_ARESETN] [get_bd_pins axis_combiner_0/aresetn] [get_bd_pins axis_switch_0/aresetn] [get_bd_pins test_pattern_generat_0/m00_axis_aresetn] [get_bd_pins test_pattern_generat_0/s00_axi_aresetn] [get_bd_pins xgs12m_remapper_0/AXIS_VIDEO_ARESETN] [get_bd_pins xgs12m_remapper_0/S_AXI_ARESETN]
  connect_bd_net -net axi_video_xgs_decoder_0_EN_DECODER_OUT_1 [get_bd_pins axi_video_xgs_decoder_0/EN_DECODER_IN] [get_bd_pins axi_video_xgs_decoder_0/EN_DECODER_OUT_1]
  connect_bd_net -net axi_video_xgs_decoder_0_EN_DECODER_OUT_2 [get_bd_pins axi_video_xgs_decoder_0/EN_DECODER_OUT_2] [get_bd_pins axi_video_xgs_decoder_1/EN_DECODER_IN]
  connect_bd_net -net axi_xgs_hispi_deser_0_FIFO_EN_OUT [get_bd_pins axi_xgs_hispi_deser_0/FIFO_EN] [get_bd_pins axi_xgs_hispi_deser_0/FIFO_EN_OUT]
  connect_bd_net -net axi_xgs_hispi_deser_1_FIFO_EN_OUT [get_bd_pins axi_xgs_hispi_deser_1/FIFO_EN] [get_bd_pins axi_xgs_hispi_deser_1/FIFO_EN_OUT]

  # Create address segments
  create_bd_addr_seg -range 0x00010000 -offset 0x00010000 [get_bd_addr_spaces axi_vip_0/Master_AXI] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] SEG_axi_gpio_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x000A0000 [get_bd_addr_spaces axi_vip_0/Master_AXI] [get_bd_addr_segs axi_video_xgs_decoder_0/S00_AXI/reg0] SEG_axi_video_xgs_decoder_0_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x000B0000 [get_bd_addr_spaces axi_vip_0/Master_AXI] [get_bd_addr_segs axi_video_xgs_decoder_1/S00_AXI/reg0] SEG_axi_video_xgs_decoder_1_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x000C0000 [get_bd_addr_spaces axi_vip_0/Master_AXI] [get_bd_addr_segs axi_xgs_hispi_deser_0/S00_AXI/reg0] SEG_axi_xgs_hispi_deser_0_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x000D0000 [get_bd_addr_spaces axi_vip_0/Master_AXI] [get_bd_addr_segs axi_xgs_hispi_deser_1/S00_AXI/reg0] SEG_axi_xgs_hispi_deser_1_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x00120000 [get_bd_addr_spaces axi_vip_0/Master_AXI] [get_bd_addr_segs test_pattern_generat_0/s00_axi/reg0] SEG_test_pattern_generat_0_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x00110000 [get_bd_addr_spaces axi_vip_0/Master_AXI] [get_bd_addr_segs xgs12m_remapper_0/S_AXI/reg0] SEG_xgs12m_remapper_0_reg0


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


