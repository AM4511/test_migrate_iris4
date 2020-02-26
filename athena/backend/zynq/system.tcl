
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
   create_project project_1 myproj -part xc7z045ffg900-2
   set_property BOARD_PART xilinx.com:zc706:part0:1.4 [current_project]
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
xilinx.com:ip:axi_pcie:2.9\
matrox.com:fdklib:dmawr_sub4:3.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:clk_wiz:6.0\
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
  set hispi [ create_bd_intf_port -mode Slave -vlnv matrox.com:user:hispi_if_rtl:1.0 hispi ]

  set pcie_mgt [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie_mgt ]

  set ref_clk200MHz [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 ref_clk200MHz ]


  # Create ports
  set reset_0 [ create_bd_port -dir I -type rst reset_0 ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $reset_0

  # Create instance: axiHiSPi_0, and set properties
  set axiHiSPi_0 [ create_bd_cell -type ip -vlnv matrox.com:Imaging:axiHiSPi:1.1.1 axiHiSPi_0 ]

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {3} \
 ] $axi_interconnect_0

  # Create instance: axi_pcie_0, and set properties
  set axi_pcie_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_pcie:2.9 axi_pcie_0 ]
  set_property -dict [ list \
   CONFIG.AXIBAR_AS_0 {true} \
   CONFIG.BAR0_SCALE {Megabytes} \
   CONFIG.BAR0_SIZE {32} \
   CONFIG.DEVICE_ID {0x7012} \
   CONFIG.INTERRUPT_PIN {false} \
   CONFIG.MAX_LINK_SPEED {2.5_GT/s} \
   CONFIG.M_AXI_DATA_WIDTH {64} \
   CONFIG.NO_OF_LANES {X2} \
   CONFIG.S_AXI_DATA_WIDTH {64} \
   CONFIG.S_AXI_SUPPORTS_NARROW_BURST {true} \
   CONFIG.XLNX_REF_BOARD {ZC706} \
 ] $axi_pcie_0

  # Create instance: dmawr_sub4_0, and set properties
  set dmawr_sub4_0 [ create_bd_cell -type ip -vlnv matrox.com:fdklib:dmawr_sub4:3.0 dmawr_sub4_0 ]
  set_property -dict [ list \
   CONFIG.AXI_DATA_WIDTH {64} \
 ] $dmawr_sub4_0

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: refclk_wiz_0, and set properties
  set refclk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 refclk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {50.0} \
   CONFIG.CLKOUT1_DRIVES {BUFG} \
   CONFIG.CLKOUT1_JITTER {98.146} \
   CONFIG.CLKOUT1_PHASE_ERROR {89.971} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {200.000} \
   CONFIG.CLKOUT2_DRIVES {BUFG} \
   CONFIG.CLKOUT2_JITTER {112.316} \
   CONFIG.CLKOUT2_PHASE_ERROR {89.971} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLKOUT3_DRIVES {BUFG} \
   CONFIG.CLKOUT4_DRIVES {BUFG} \
   CONFIG.CLKOUT5_DRIVES {BUFG} \
   CONFIG.CLKOUT6_DRIVES {BUFG} \
   CONFIG.CLKOUT7_DRIVES {BUFG} \
   CONFIG.CLK_IN1_BOARD_INTERFACE {sys_diff_clock} \
   CONFIG.CLK_OUT1_PORT {idelay_clk200MHz} \
   CONFIG.CLK_OUT2_PORT {clk100MHz} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {5.000} \
   CONFIG.MMCM_CLKIN1_PERIOD {5.000} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {5.000} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {10} \
   CONFIG.NUM_OUT_CLKS {2} \
   CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
   CONFIG.RESET_BOARD_INTERFACE {reset} \
   CONFIG.SECONDARY_SOURCE {Single_ended_clock_capable_pin} \
   CONFIG.USE_PHASE_ALIGNMENT {false} \
 ] $refclk_wiz_0

  # Create instance: rst_axi_pcie_0_125M, and set properties
  set rst_axi_pcie_0_125M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_axi_pcie_0_125M ]
  set_property -dict [ list \
   CONFIG.RESET_BOARD_INTERFACE {reset} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $rst_axi_pcie_0_125M

  # Create interface connections
  connect_bd_intf_net -intf_net CLK_IN1_D_0_1 [get_bd_intf_ports ref_clk200MHz] [get_bd_intf_pins refclk_wiz_0/CLK_IN1_D]
  connect_bd_intf_net -intf_net axiHiSPi_0_m_axis [get_bd_intf_pins axiHiSPi_0/m_axis] [get_bd_intf_pins dmawr_sub4_0/s_axis]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axiHiSPi_0/s_axi] [get_bd_intf_pins axi_interconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins axi_interconnect_0/M01_AXI] [get_bd_intf_pins dmawr_sub4_0/s_axi]
  connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI [get_bd_intf_pins axi_interconnect_0/M02_AXI] [get_bd_intf_pins axi_pcie_0/S_AXI_CTL]
  connect_bd_intf_net -intf_net axi_pcie_0_M_AXI [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins axi_pcie_0/M_AXI]
  connect_bd_intf_net -intf_net axi_pcie_0_pcie_7x_mgt [get_bd_intf_ports pcie_mgt] [get_bd_intf_pins axi_pcie_0/pcie_7x_mgt]
  connect_bd_intf_net -intf_net dmawr_sub4_0_m_axi [get_bd_intf_pins axi_pcie_0/S_AXI] [get_bd_intf_pins dmawr_sub4_0/m_axi]
  connect_bd_intf_net -intf_net s_hispi_0_1 [get_bd_intf_ports hispi] [get_bd_intf_pins axiHiSPi_0/s_hispi]

  # Create port connections
  connect_bd_net -net ACLK_1 [get_bd_pins axiHiSPi_0/axi_clk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axi_pcie_0/axi_aclk_out] [get_bd_pins dmawr_sub4_0/sysclk] [get_bd_pins rst_axi_pcie_0_125M/slowest_sync_clk]
  connect_bd_net -net S00_ARESETN_1 [get_bd_pins axiHiSPi_0/axi_reset_n] [get_bd_pins axi_interconnect_0/S00_ARESETN]
  connect_bd_net -net axi_pcie_0_axi_ctl_aclk_out [get_bd_pins axi_interconnect_0/M02_ACLK] [get_bd_pins axi_pcie_0/axi_ctl_aclk_out]
  connect_bd_net -net clk_wiz_0_clk100MHz [get_bd_pins axi_pcie_0/REFCLK] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins refclk_wiz_0/clk100MHz]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins proc_sys_reset_0/dcm_locked] [get_bd_pins refclk_wiz_0/locked]
  connect_bd_net -net refclk_wiz_0_idelay_clk200MHz [get_bd_pins axiHiSPi_0/idelay_clk] [get_bd_pins refclk_wiz_0/idelay_clk200MHz]
  connect_bd_net -net reset_0_1 [get_bd_ports reset_0] [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins refclk_wiz_0/reset] [get_bd_pins rst_axi_pcie_0_125M/ext_reset_in]
  connect_bd_net -net rst_axi_pcie_0_125M_peripheral_aresetn [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_interconnect_0/M02_ARESETN] [get_bd_pins dmawr_sub4_0/sysrstN] [get_bd_pins rst_axi_pcie_0_125M/peripheral_aresetn]

  # Create address segments
  create_bd_addr_seg -range 0x00010000 -offset 0x44A00000 [get_bd_addr_spaces axi_pcie_0/M_AXI] [get_bd_addr_segs axiHiSPi_0/s_axi/registerfile] SEG_axiHiSPi_0_registerfile
  create_bd_addr_seg -range 0x10000000 -offset 0x00000000 [get_bd_addr_spaces axi_pcie_0/M_AXI] [get_bd_addr_segs axi_pcie_0/S_AXI_CTL/CTL0] SEG_axi_pcie_0_CTL0
  create_bd_addr_seg -range 0x00010000 -offset 0x44A10000 [get_bd_addr_spaces axi_pcie_0/M_AXI] [get_bd_addr_segs dmawr_sub4_0/s_axi/reg0] SEG_dmawr_sub4_0_reg0
  create_bd_addr_seg -range 0x000100000000 -offset 0x00000000 [get_bd_addr_spaces dmawr_sub4_0/m_axi] [get_bd_addr_segs axi_pcie_0/S_AXI/BAR0] SEG_axi_pcie_0_BAR0


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


