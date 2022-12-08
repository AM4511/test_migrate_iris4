
################################################################
# This is a generated script based on design: eyescan_subsystem
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
set scripts_vivado_version 2016.3
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
# source eyescan_subsystem_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7a35tcsg325-2
}


# CHANGE DESIGN NAME HERE
set design_name eyescan_subsystem

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

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: microblaze_0_local_memory
proc create_hier_cell_microblaze_0_local_memory { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" create_hier_cell_microblaze_0_local_memory() - Empty argument(s)!"}
     return
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

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 DLMB
  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 ILMB

  # Create pins
  create_bd_pin -dir I -type clk LMB_Clk
  create_bd_pin -dir I -type rst SYS_Rst

  # Create instance: dlmb_bram_if_cntlr, and set properties
  set dlmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 dlmb_bram_if_cntlr ]
  set_property -dict [ list \
CONFIG.C_ECC {0} \
 ] $dlmb_bram_if_cntlr

  # Create instance: dlmb_v10, and set properties
  set dlmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 dlmb_v10 ]

  # Create instance: ilmb_bram_if_cntlr, and set properties
  set ilmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 ilmb_bram_if_cntlr ]
  set_property -dict [ list \
CONFIG.C_ECC {0} \
 ] $ilmb_bram_if_cntlr

  # Create instance: ilmb_v10, and set properties
  set ilmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 ilmb_v10 ]

  # Create instance: lmb_bram, and set properties
  set lmb_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 lmb_bram ]
  set_property -dict [ list \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $lmb_bram

  # Create interface connections
  connect_bd_intf_net -intf_net microblaze_0_dlmb [get_bd_intf_pins DLMB] [get_bd_intf_pins dlmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_bus [get_bd_intf_pins dlmb_bram_if_cntlr/SLMB] [get_bd_intf_pins dlmb_v10/LMB_Sl_0]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_cntlr [get_bd_intf_pins dlmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTA]
  connect_bd_intf_net -intf_net microblaze_0_ilmb [get_bd_intf_pins ILMB] [get_bd_intf_pins ilmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_bus [get_bd_intf_pins ilmb_bram_if_cntlr/SLMB] [get_bd_intf_pins ilmb_v10/LMB_Sl_0]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_cntlr [get_bd_intf_pins ilmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTB]

  # Create port connections
  connect_bd_net -net SYS_Rst_1 [get_bd_pins SYS_Rst] [get_bd_pins dlmb_bram_if_cntlr/LMB_Rst] [get_bd_pins dlmb_v10/SYS_Rst] [get_bd_pins ilmb_bram_if_cntlr/LMB_Rst] [get_bd_pins ilmb_v10/SYS_Rst]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins LMB_Clk] [get_bd_pins dlmb_bram_if_cntlr/LMB_Clk] [get_bd_pins dlmb_v10/LMB_Clk] [get_bd_pins ilmb_bram_if_cntlr/LMB_Clk] [get_bd_pins ilmb_v10/LMB_Clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: DRP_Bridge_hier
proc create_hier_cell_DRP_Bridge_hier { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" create_hier_cell_DRP_Bridge_hier() - Empty argument(s)!"}
     return
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

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 AXI0
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 AXI1
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:drp_rtl:1.0 DRP0
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:drp_rtl:1.0 DRP1

  # Create pins
  create_bd_pin -dir I -type clk AXI_aclk
  create_bd_pin -dir I -from 0 -to 0 -type rst AXI_aresetn

  # Create instance: drp_bridge_0, and set properties
  set drp_bridge_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:drp_bridge:1.0 drp_bridge_0 ]
  set_property -dict [ list \
CONFIG.C_S_AXI_ADDR_WIDTH {20} \
 ] $drp_bridge_0

  # Create instance: drp_bridge_1, and set properties
  set drp_bridge_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:drp_bridge:1.0 drp_bridge_1 ]
  set_property -dict [ list \
CONFIG.C_S_AXI_ADDR_WIDTH {20} \
 ] $drp_bridge_1

  # Create interface connections
  connect_bd_intf_net -intf_net drp_mux_0_gt_drp [get_bd_intf_pins DRP0] [get_bd_intf_pins drp_bridge_0/DRP]
  connect_bd_intf_net -intf_net drp_mux_1_gt_drp [get_bd_intf_pins DRP1] [get_bd_intf_pins drp_bridge_1/DRP]
  connect_bd_intf_net -intf_net microblaze_1_axi_periph_m00_axi [get_bd_intf_pins AXI0] [get_bd_intf_pins drp_bridge_0/AXI]
  connect_bd_intf_net -intf_net microblaze_1_axi_periph_m01_axi [get_bd_intf_pins AXI1] [get_bd_intf_pins drp_bridge_1/AXI]

  # Create port connections
  connect_bd_net -net axi_aclk_1 [get_bd_pins AXI_aclk] [get_bd_pins drp_bridge_0/AXI_aclk] [get_bd_pins drp_bridge_1/AXI_aclk]
  connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins AXI_aresetn] [get_bd_pins drp_bridge_0/AXI_aresetn] [get_bd_pins drp_bridge_1/AXI_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder

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
  set gt_drp_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:drp_rtl:1.0 gt_drp_0 ]
  set gt_drp_1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:drp_rtl:1.0 gt_drp_1 ]

  # Create ports
  set AXI_aclk [ create_bd_port -dir I -type clk AXI_aclk ]
  set reset [ create_bd_port -dir I -type rst reset ]
  set_property -dict [ list \
CONFIG.POLARITY {ACTIVE_LOW} \
 ] $reset

  # Create instance: DRP_Bridge_hier
  create_hier_cell_DRP_Bridge_hier [current_bd_instance .] DRP_Bridge_hier

  # Create instance: axi_bram_ctrl_0, and set properties
  set axi_bram_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 axi_bram_ctrl_0 ]

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 blk_mem_gen_0 ]
  set_property -dict [ list \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $blk_mem_gen_0

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $blk_mem_gen_0

  # Create instance: jtag_axi_0, and set properties
  set jtag_axi_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:jtag_axi:1.2 jtag_axi_0 ]

  # Create instance: mdm_1, and set properties
  set mdm_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mdm:3.2 mdm_1 ]

  # Create instance: microblaze_0, and set properties
  set microblaze_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:10.0 microblaze_0 ]
  set_property -dict [ list \
CONFIG.C_DEBUG_ENABLED {1} \
CONFIG.C_D_AXI {1} \
CONFIG.C_D_LMB {1} \
CONFIG.C_I_LMB {1} \
 ] $microblaze_0

  # Create instance: microblaze_0_axi_periph, and set properties
  set microblaze_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 microblaze_0_axi_periph ]
  set_property -dict [ list \
CONFIG.NUM_MI {3} \
CONFIG.NUM_SI {2} \
 ] $microblaze_0_axi_periph

  # Create instance: microblaze_0_local_memory
  create_hier_cell_microblaze_0_local_memory [current_bd_instance .] microblaze_0_local_memory

  # Create instance: rst_AXI_aclk_100M, and set properties
  set rst_AXI_aclk_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_AXI_aclk_100M ]

  # Create interface connections
  connect_bd_intf_net -intf_net DRP_Bridge_hier_DRP0 [get_bd_intf_ports gt_drp_0] [get_bd_intf_pins DRP_Bridge_hier/DRP0]
  connect_bd_intf_net -intf_net DRP_Bridge_hier_DRP1 [get_bd_intf_ports gt_drp_1] [get_bd_intf_pins DRP_Bridge_hier/DRP1]
  connect_bd_intf_net -intf_net S01_AXI_1 [get_bd_intf_pins jtag_axi_0/M_AXI] [get_bd_intf_pins microblaze_0_axi_periph/S01_AXI]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTB [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTB] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTB]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_DP [get_bd_intf_pins microblaze_0/M_AXI_DP] [get_bd_intf_pins microblaze_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M00_AXI [get_bd_intf_pins DRP_Bridge_hier/AXI0] [get_bd_intf_pins microblaze_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M01_AXI [get_bd_intf_pins DRP_Bridge_hier/AXI1] [get_bd_intf_pins microblaze_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M02_AXI [get_bd_intf_pins axi_bram_ctrl_0/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net microblaze_0_debug [get_bd_intf_pins mdm_1/MBDEBUG_0] [get_bd_intf_pins microblaze_0/DEBUG]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_1 [get_bd_intf_pins microblaze_0/DLMB] [get_bd_intf_pins microblaze_0_local_memory/DLMB]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_1 [get_bd_intf_pins microblaze_0/ILMB] [get_bd_intf_pins microblaze_0_local_memory/ILMB]

  # Create port connections
  connect_bd_net -net mdm_1_debug_sys_rst [get_bd_pins mdm_1/Debug_SYS_Rst] [get_bd_pins rst_AXI_aclk_100M/mb_debug_sys_rst]
  connect_bd_net -net microblaze_0_Clk [get_bd_ports AXI_aclk] [get_bd_pins DRP_Bridge_hier/AXI_aclk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk] [get_bd_pins jtag_axi_0/aclk] [get_bd_pins microblaze_0/Clk] [get_bd_pins microblaze_0_axi_periph/ACLK] [get_bd_pins microblaze_0_axi_periph/M00_ACLK] [get_bd_pins microblaze_0_axi_periph/M01_ACLK] [get_bd_pins microblaze_0_axi_periph/M02_ACLK] [get_bd_pins microblaze_0_axi_periph/S00_ACLK] [get_bd_pins microblaze_0_axi_periph/S01_ACLK] [get_bd_pins microblaze_0_local_memory/LMB_Clk] [get_bd_pins rst_AXI_aclk_100M/slowest_sync_clk]
  connect_bd_net -net reset_1 [get_bd_ports reset] [get_bd_pins rst_AXI_aclk_100M/ext_reset_in]
  connect_bd_net -net rst_AXI_aclk_100M_bus_struct_reset [get_bd_pins microblaze_0_local_memory/SYS_Rst] [get_bd_pins rst_AXI_aclk_100M/bus_struct_reset]
  connect_bd_net -net rst_AXI_aclk_100M_interconnect_aresetn [get_bd_pins jtag_axi_0/aresetn] [get_bd_pins microblaze_0_axi_periph/ARESETN] [get_bd_pins rst_AXI_aclk_100M/interconnect_aresetn]
  connect_bd_net -net rst_AXI_aclk_100M_mb_reset [get_bd_pins microblaze_0/Reset] [get_bd_pins rst_AXI_aclk_100M/mb_reset]
  connect_bd_net -net rst_AXI_aclk_100M_peripheral_aresetn [get_bd_pins DRP_Bridge_hier/AXI_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn] [get_bd_pins microblaze_0_axi_periph/M00_ARESETN] [get_bd_pins microblaze_0_axi_periph/M01_ARESETN] [get_bd_pins microblaze_0_axi_periph/M02_ARESETN] [get_bd_pins microblaze_0_axi_periph/S00_ARESETN] [get_bd_pins microblaze_0_axi_periph/S01_ARESETN] [get_bd_pins rst_AXI_aclk_100M/peripheral_aresetn]

  # Create address segments
  create_bd_addr_seg -range 0x00001000 -offset 0xC2000000 [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] SEG_axi_bram_ctrl_0_Mem0
  create_bd_addr_seg -range 0x00001000 -offset 0xC0000000 [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs DRP_Bridge_hier/drp_bridge_0/AXI/reg0] SEG_drp_bridge_0_reg0
  create_bd_addr_seg -range 0x00001000 -offset 0xC0001000 [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs DRP_Bridge_hier/drp_bridge_1/AXI/reg0] SEG_drp_bridge_1_reg0
  create_bd_addr_seg -range 0x00001000 -offset 0xC2000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] SEG_axi_bram_ctrl_0_Mem0
  create_bd_addr_seg -range 0x00004000 -offset 0x00000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs microblaze_0_local_memory/dlmb_bram_if_cntlr/SLMB/Mem] SEG_dlmb_bram_if_cntlr_Mem
  create_bd_addr_seg -range 0x00001000 -offset 0xC0000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs DRP_Bridge_hier/drp_bridge_0/AXI/reg0] SEG_drp_bridge_0_reg0
  create_bd_addr_seg -range 0x00001000 -offset 0xC0001000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs DRP_Bridge_hier/drp_bridge_1/AXI/reg0] SEG_drp_bridge_1_reg0
  create_bd_addr_seg -range 0x00004000 -offset 0x00000000 [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs microblaze_0_local_memory/ilmb_bram_if_cntlr/SLMB/Mem] SEG_ilmb_bram_if_cntlr_Mem

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.6.5b  2016-09-06 bk=1.3687 VDI=39 GEI=35 GUI=JA:1.6
#  -string -flagsOSRD
preplace port gt_drp_0 -pg 1 -y 80 -defaultsOSRD
preplace port gt_drp_1 -pg 1 -y 200 -defaultsOSRD
preplace port AXI_aclk -pg 1 -y 170 -defaultsOSRD
preplace port reset -pg 1 -y 590 -defaultsOSRD
preplace inst microblaze_0_axi_periph -pg 1 -lvl 3 -y 180 -defaultsOSRD
preplace inst jtag_axi_0 -pg 1 -lvl 2 -y 70 -defaultsOSRD
preplace inst DRP_Bridge_hier -pg 1 -lvl 4 -y 80 -defaultsOSRD
preplace inst blk_mem_gen_0 -pg 1 -lvl 5 -y 340 -defaultsOSRD
preplace inst rst_AXI_aclk_100M -pg 1 -lvl 1 -y 610 -defaultsOSRD
preplace inst mdm_1 -pg 1 -lvl 1 -y 450 -defaultsOSRD
preplace inst microblaze_0 -pg 1 -lvl 2 -y 450 -defaultsOSRD
preplace inst microblaze_0_local_memory -pg 1 -lvl 3 -y 460 -defaultsOSRD
preplace inst axi_bram_ctrl_0 -pg 1 -lvl 4 -y 340 -defaultsOSRD
preplace netloc axi_bram_ctrl_0_BRAM_PORTA 1 4 1 N
preplace netloc rst_AXI_aclk_100M_interconnect_aresetn 1 1 2 370 630 850
preplace netloc microblaze_0_Clk 1 0 4 20 170 360 170 860 370 1150
preplace netloc axi_bram_ctrl_0_BRAM_PORTB 1 4 1 N
preplace netloc microblaze_0_axi_periph_M00_AXI 1 3 1 1130
preplace netloc microblaze_0_M_AXI_DP 1 2 1 840
preplace netloc microblaze_0_ilmb_1 1 2 1 N
preplace netloc rst_AXI_aclk_100M_bus_struct_reset 1 1 2 N 590 860J
preplace netloc DRP_Bridge_hier_DRP0 1 4 2 NJ 70 1760J
preplace netloc rst_AXI_aclk_100M_peripheral_aresetn 1 1 3 NJ 650 870 650 1160
preplace netloc DRP_Bridge_hier_DRP1 1 4 2 NJ 90 1760J
preplace netloc microblaze_0_axi_periph_M01_AXI 1 3 1 1140
preplace netloc rst_AXI_aclk_100M_mb_reset 1 1 1 380
preplace netloc S01_AXI_1 1 2 1 N
preplace netloc microblaze_0_axi_periph_M02_AXI 1 3 1 1130
preplace netloc microblaze_0_dlmb_1 1 2 1 N
preplace netloc microblaze_0_debug 1 1 1 N
preplace netloc reset_1 1 0 1 NJ
preplace netloc mdm_1_debug_sys_rst 1 0 2 30 510 350
levelinfo -pg 1 0 190 620 1000 1340 1660 1780 -top 0 -bot 700
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


