
################################################################
# This is a generated script based on design: system_pb
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
# source system_pb_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7a50ticpg236-1L
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name system_pb

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
matrox.com:user:AXI_i2c_Matrox:1.0\
matrox.com:Imaging:XGS_athena:1.0.0\
xilinx.com:ip:clk_wiz:6.0\
matrox.com:Imaging:pcie2AxiMaster:3.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:axi_bram_ctrl:4.1\
xilinx.com:ip:blk_mem_gen:8.4\
xilinx.com:ip:drp_bridge:1.0\
xilinx.com:ip:jtag_axi:1.2\
xilinx.com:ip:microblaze:11.0\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:lmb_bram_if_cntlr:4.0\
xilinx.com:ip:lmb_v10:3.0\
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


# Hierarchical cell: microblaze_0_local_memory
proc create_hier_cell_microblaze_0_local_memory { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_microblaze_0_local_memory() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 LMB_M

  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 LMB_M1


  # Create pins
  create_bd_pin -dir I -type clk AXI_aclk
  create_bd_pin -dir I -type rst SYS_Rst

  # Create instance: blk_mem_gen_1, and set properties
  set blk_mem_gen_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_1 ]
  set_property -dict [ list \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_1

  # Create instance: dlmb_bram_if_cntlr, and set properties
  set dlmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 dlmb_bram_if_cntlr ]

  # Create instance: dlmb_v10, and set properties
  set dlmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 dlmb_v10 ]

  # Create instance: ilmb_bram_if_cntlr1, and set properties
  set ilmb_bram_if_cntlr1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 ilmb_bram_if_cntlr1 ]

  # Create instance: ilmb_v10, and set properties
  set ilmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 ilmb_v10 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn [get_bd_intf_pins ilmb_bram_if_cntlr1/SLMB] [get_bd_intf_pins ilmb_v10/LMB_Sl_0]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins dlmb_bram_if_cntlr/SLMB] [get_bd_intf_pins dlmb_v10/LMB_Sl_0]
  connect_bd_intf_net -intf_net dlmb_bram_if_cntlr_BRAM_PORT [get_bd_intf_pins blk_mem_gen_1/BRAM_PORTA] [get_bd_intf_pins dlmb_bram_if_cntlr/BRAM_PORT]
  connect_bd_intf_net -intf_net ilmb_bram_if_cntlr1_BRAM_PORT [get_bd_intf_pins blk_mem_gen_1/BRAM_PORTB] [get_bd_intf_pins ilmb_bram_if_cntlr1/BRAM_PORT]
  connect_bd_intf_net -intf_net microblaze_0_DLMB [get_bd_intf_pins LMB_M] [get_bd_intf_pins dlmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_ILMB [get_bd_intf_pins LMB_M1] [get_bd_intf_pins ilmb_v10/LMB_M]

  # Create port connections
  connect_bd_net -net Net [get_bd_pins AXI_aclk] [get_bd_pins dlmb_bram_if_cntlr/LMB_Clk] [get_bd_pins dlmb_v10/LMB_Clk] [get_bd_pins ilmb_bram_if_cntlr1/LMB_Clk] [get_bd_pins ilmb_v10/LMB_Clk]
  connect_bd_net -net Net1 [get_bd_pins SYS_Rst] [get_bd_pins dlmb_bram_if_cntlr/LMB_Rst] [get_bd_pins dlmb_v10/SYS_Rst] [get_bd_pins ilmb_bram_if_cntlr1/LMB_Rst] [get_bd_pins ilmb_v10/SYS_Rst]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: eyescan_microblaze_system
proc create_hier_cell_eyescan_microblaze_system { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_eyescan_microblaze_system() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:drp_rtl:1.0 DRP0

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:drp_rtl:1.0 DRP1


  # Create pins
  create_bd_pin -dir I -type clk ext_ch_gt_drpclk_in
  create_bd_pin -dir I -type rst ext_reset_in

  # Create instance: axi_bram_ctrl_0, and set properties
  set axi_bram_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0 ]

  # Create instance: axi_interconnect_1, and set properties
  set axi_interconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_1 ]
  set_property -dict [ list \
   CONFIG.ENABLE_ADVANCED_OPTIONS {1} \
   CONFIG.NUM_MI {3} \
   CONFIG.NUM_SI {2} \
 ] $axi_interconnect_1

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0 ]
  set_property -dict [ list \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_0

  # Create instance: drp_bridge_0, and set properties
  set drp_bridge_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:drp_bridge:1.0 drp_bridge_0 ]

  # Create instance: drp_bridge_1, and set properties
  set drp_bridge_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:drp_bridge:1.0 drp_bridge_1 ]

  # Create instance: jtag_axi_0, and set properties
  set jtag_axi_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:jtag_axi:1.2 jtag_axi_0 ]

  # Create instance: microblaze_0, and set properties
  set microblaze_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 microblaze_0 ]
  set_property -dict [ list \
   CONFIG.C_DEBUG_ENABLED {0} \
   CONFIG.C_D_AXI {1} \
 ] $microblaze_0

  # Create instance: microblaze_0_local_memory
  create_hier_cell_microblaze_0_local_memory $hier_obj microblaze_0_local_memory

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]
  set_property -dict [ list \
   CONFIG.C_AUX_RESET_HIGH {0} \
 ] $proc_sys_reset_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {32} \
 ] $xlconstant_1

  # Create interface connections
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins axi_interconnect_1/S00_AXI] [get_bd_intf_pins microblaze_0/M_AXI_DP]
  connect_bd_intf_net -intf_net S01_AXI_1 [get_bd_intf_pins axi_interconnect_1/S01_AXI] [get_bd_intf_pins jtag_axi_0/M_AXI]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTB [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTB] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTB]
  connect_bd_intf_net -intf_net axi_interconnect_1_M00_AXI [get_bd_intf_pins axi_interconnect_1/M00_AXI] [get_bd_intf_pins drp_bridge_0/AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M01_AXI [get_bd_intf_pins axi_interconnect_1/M01_AXI] [get_bd_intf_pins drp_bridge_1/AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M02_AXI [get_bd_intf_pins axi_bram_ctrl_0/S_AXI] [get_bd_intf_pins axi_interconnect_1/M02_AXI]
  connect_bd_intf_net -intf_net drp_bridge_0_DRP [get_bd_intf_pins DRP0] [get_bd_intf_pins drp_bridge_0/DRP]
  connect_bd_intf_net -intf_net drp_bridge_1_DRP [get_bd_intf_pins DRP1] [get_bd_intf_pins drp_bridge_1/DRP]
  connect_bd_intf_net -intf_net microblaze_0_DLMB [get_bd_intf_pins microblaze_0/DLMB] [get_bd_intf_pins microblaze_0_local_memory/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_ILMB [get_bd_intf_pins microblaze_0/ILMB] [get_bd_intf_pins microblaze_0_local_memory/LMB_M1]

  # Create port connections
  connect_bd_net -net ARESETN_1 [get_bd_pins ext_reset_in] [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net SYS_Rst_1 [get_bd_pins microblaze_0_local_memory/SYS_Rst] [get_bd_pins proc_sys_reset_0/bus_struct_reset]
  connect_bd_net -net pcie2AxiMaster_0_ext_ch_gt_drpclk [get_bd_pins ext_ch_gt_drpclk_in] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk] [get_bd_pins axi_interconnect_1/ACLK] [get_bd_pins axi_interconnect_1/M00_ACLK] [get_bd_pins axi_interconnect_1/M01_ACLK] [get_bd_pins axi_interconnect_1/M02_ACLK] [get_bd_pins axi_interconnect_1/S00_ACLK] [get_bd_pins axi_interconnect_1/S01_ACLK] [get_bd_pins drp_bridge_0/AXI_aclk] [get_bd_pins drp_bridge_1/AXI_aclk] [get_bd_pins jtag_axi_0/aclk] [get_bd_pins microblaze_0/Clk] [get_bd_pins microblaze_0_local_memory/AXI_aclk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins axi_interconnect_1/ARESETN] [get_bd_pins jtag_axi_0/aresetn] [get_bd_pins proc_sys_reset_0/interconnect_aresetn]
  connect_bd_net -net proc_sys_reset_0_mb_reset [get_bd_pins microblaze_0/Reset] [get_bd_pins proc_sys_reset_0/mb_reset]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn_1 [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn] [get_bd_pins axi_interconnect_1/M00_ARESETN] [get_bd_pins axi_interconnect_1/M01_ARESETN] [get_bd_pins axi_interconnect_1/M02_ARESETN] [get_bd_pins axi_interconnect_1/S00_ARESETN] [get_bd_pins axi_interconnect_1/S01_ARESETN] [get_bd_pins drp_bridge_0/AXI_aresetn] [get_bd_pins drp_bridge_1/AXI_aresetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins microblaze_0/Interrupt] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins microblaze_0/Interrupt_Address] [get_bd_pins xlconstant_1/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}


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
  set Anput [ create_bd_intf_port -mode Master -vlnv matrox.com:user:Athena2Ares_if_rtl:1.0 Anput ]

  set I2C_if [ create_bd_intf_port -mode Master -vlnv matrox.com:user:I2C_Matrox_rtl:1.0 I2C_if ]

  set SPI [ create_bd_intf_port -mode Master -vlnv matrox.com:MatroxIP:mtxSPI_rtl:1.0 SPI ]

  set hispi [ create_bd_intf_port -mode Slave -vlnv matrox.com:user:hispi_if_rtl:1.0 hispi ]

  set info [ create_bd_intf_port -mode Slave -vlnv matrox.com:Imaging:FPGA_Info_rtl:1.0 info ]

  set pcie [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie ]

  set xgs_ctrl [ create_bd_intf_port -mode Master -vlnv matrox.com:user:XGS_controller_if_rtl:1.0 xgs_ctrl ]


  # Create ports
  set debug_out [ create_bd_port -dir O -from 3 -to 0 debug_out ]
  set ext_ch_gt_drpclk_in [ create_bd_port -dir I -type clk ext_ch_gt_drpclk_in ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
 ] $ext_ch_gt_drpclk_in
  set ext_ch_gt_drpclk_out [ create_bd_port -dir O ext_ch_gt_drpclk_out ]
  set led_out [ create_bd_port -dir O -from 1 -to 0 led_out ]
  set pcie_sys_clk [ create_bd_port -dir I -type clk pcie_sys_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
 ] $pcie_sys_clk
  set pcie_sys_rst_n [ create_bd_port -dir I -type rst pcie_sys_rst_n ]
  set ref_clk [ create_bd_port -dir I -type clk ref_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
 ] $ref_clk

  # Create instance: AXI_i2c_Matrox_0, and set properties
  set AXI_i2c_Matrox_0 [ create_bd_cell -type ip -vlnv matrox.com:user:AXI_i2c_Matrox:1.0 AXI_i2c_Matrox_0 ]
  set_property -dict [ list \
   CONFIG.CLOCK_STRETCHING {true} \
   CONFIG.NI_ACCESS {true} \
 ] $AXI_i2c_Matrox_0

  # Create instance: XGS_athena_0, and set properties
  set XGS_athena_0 [ create_bd_cell -type ip -vlnv matrox.com:Imaging:XGS_athena:1.0.0 XGS_athena_0 ]
  set_property -dict [ list \
   CONFIG.BOOL_ENABLE_IDELAYCTRL {true} \
   CONFIG.COLOR {1} \
   CONFIG.ENABLE_IDELAYCTRL {1} \
   CONFIG.MAX_PCIE_PAYLOAD_SIZE {256} \
   CONFIG.SENSOR_FREQ {32000} \
 ] $XGS_athena_0

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKOUT1_JITTER {114.829} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {200.000} \
   CONFIG.CLKOUT2_JITTER {130.958} \
   CONFIG.CLKOUT2_PHASE_ERROR {98.575} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLK_OUT1_PORT {refclk200MHz} \
   CONFIG.CLK_OUT2_PORT {sclk100MHz} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {5.000} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {10} \
   CONFIG.NUM_OUT_CLKS {2} \
   CONFIG.RESET_PORT {resetn} \
   CONFIG.RESET_TYPE {ACTIVE_LOW} \
   CONFIG.USE_LOCKED {true} \
   CONFIG.USE_RESET {true} \
 ] $clk_wiz_0

  # Create instance: eyescan_microblaze_system
  create_hier_cell_eyescan_microblaze_system [current_bd_instance .] eyescan_microblaze_system

  # Create instance: pcie2AxiMaster_0, and set properties
  set pcie2AxiMaster_0 [ create_bd_cell -type ip -vlnv matrox.com:Imaging:pcie2AxiMaster:3.0 pcie2AxiMaster_0 ]
  set_property -dict [ list \
   CONFIG.BOOL_ENABLE_DMA {true} \
   CONFIG.BOOL_ENABLE_SPI {true} \
   CONFIG.BOOL_ENABLE_SW_IRQ {true} \
   CONFIG.ENABLE_DMA {1} \
   CONFIG.ENABLE_MTX_SPI {1} \
   CONFIG.ENABLE_SW_IRQ {1} \
   CONFIG.NUMB_IRQ {9} \
   CONFIG.PCIE_DEVICE_ID {20564} \
   CONFIG.PCIE_NB_LANES {2} \
 ] $pcie2AxiMaster_0

  # Create instance: sys_reset_0, and set properties
  set sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 sys_reset_0 ]

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {8} \
 ] $xlconcat_0

  # Create interface connections
  connect_bd_intf_net -intf_net AXI_i2c_Matrox_0_I2C_interface [get_bd_intf_ports I2C_if] [get_bd_intf_pins AXI_i2c_Matrox_0/I2C_interface]
  connect_bd_intf_net -intf_net XGS_athena_0_Athena2Anput [get_bd_intf_ports Anput] [get_bd_intf_pins XGS_athena_0/Athena2Anput]
  connect_bd_intf_net -intf_net XGS_athena_0_XGS_Controller_IF [get_bd_intf_ports xgs_ctrl] [get_bd_intf_pins XGS_athena_0/XGS_Controller_IF]
  connect_bd_intf_net -intf_net XGS_athena_0_tlp [get_bd_intf_pins XGS_athena_0/tlp] [get_bd_intf_pins pcie2AxiMaster_0/dma_tlp]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins AXI_i2c_Matrox_0/S_AXI] [get_bd_intf_pins axi_interconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins XGS_athena_0/s_axi] [get_bd_intf_pins axi_interconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net drp_bridge_0_DRP [get_bd_intf_pins eyescan_microblaze_system/DRP0] [get_bd_intf_pins pcie2AxiMaster_0/DRP_0]
  connect_bd_intf_net -intf_net drp_bridge_1_DRP [get_bd_intf_pins eyescan_microblaze_system/DRP1] [get_bd_intf_pins pcie2AxiMaster_0/DRP_1]
  connect_bd_intf_net -intf_net hispi_1 [get_bd_intf_ports hispi] [get_bd_intf_pins XGS_athena_0/hispi]
  connect_bd_intf_net -intf_net info_1 [get_bd_intf_ports info] [get_bd_intf_pins pcie2AxiMaster_0/FPGA_Info]
  connect_bd_intf_net -intf_net pcie2AxiMaster_0_M_AXI [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins pcie2AxiMaster_0/M_AXI]
  connect_bd_intf_net -intf_net pcie2AxiMaster_0_mtxSPI [get_bd_intf_ports SPI] [get_bd_intf_pins pcie2AxiMaster_0/mtxSPI]
  connect_bd_intf_net -intf_net pcie2AxiMaster_0_pcie_mgt [get_bd_intf_ports pcie] [get_bd_intf_pins pcie2AxiMaster_0/pcie_mgt]

  # Create port connections
  connect_bd_net -net ARESETN_1 [get_bd_pins AXI_i2c_Matrox_0/s_axi_aresetn] [get_bd_pins XGS_athena_0/aclk_reset_n] [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins pcie2AxiMaster_0/axim_rst_n]
  connect_bd_net -net XGS_athena_0_debug_out [get_bd_ports debug_out] [get_bd_pins XGS_athena_0/debug_out]
  connect_bd_net -net XGS_athena_0_irq [get_bd_pins XGS_athena_0/irq] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net XGS_athena_0_led_out [get_bd_ports led_out] [get_bd_pins XGS_athena_0/led_out]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins XGS_athena_0/sclk] [get_bd_pins clk_wiz_0/sclk100MHz] [get_bd_pins sys_reset_0/slowest_sync_clk]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins sys_reset_0/dcm_locked]
  connect_bd_net -net clk_wiz_0_refclk200MHz [get_bd_pins XGS_athena_0/idelay_clk] [get_bd_pins clk_wiz_0/refclk200MHz]
  connect_bd_net -net pcie2AxiMaster_0_axim_clk [get_bd_pins AXI_i2c_Matrox_0/s_axi_aclk] [get_bd_pins XGS_athena_0/aclk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins pcie2AxiMaster_0/axim_clk]
  connect_bd_net -net pcie2AxiMaster_0_ext_ch_gt_drpclk [get_bd_ports ext_ch_gt_drpclk_in] [get_bd_pins eyescan_microblaze_system/ext_ch_gt_drpclk_in]
  connect_bd_net -net pcie2AxiMaster_0_ext_ch_gt_drpclk1 [get_bd_ports ext_ch_gt_drpclk_out] [get_bd_pins pcie2AxiMaster_0/ext_ch_gt_drpclk]
  connect_bd_net -net pcie2AxiMaster_0_sw_irq [get_bd_pins pcie2AxiMaster_0/sw_irq] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net pcie2AxiMaster_0_user_lnk_up [get_bd_pins eyescan_microblaze_system/ext_reset_in] [get_bd_pins pcie2AxiMaster_0/user_lnk_up]
  connect_bd_net -net pcie_sys_clk_1 [get_bd_ports pcie_sys_clk] [get_bd_pins pcie2AxiMaster_0/pcie_sys_clk]
  connect_bd_net -net pcie_sys_rst_n_1 [get_bd_ports pcie_sys_rst_n] [get_bd_pins clk_wiz_0/resetn] [get_bd_pins pcie2AxiMaster_0/pcie_sys_rst_n] [get_bd_pins sys_reset_0/ext_reset_in]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins XGS_athena_0/sclk_reset_n] [get_bd_pins sys_reset_0/peripheral_aresetn]
  connect_bd_net -net ref_clk_1 [get_bd_ports ref_clk] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins pcie2AxiMaster_0/irq_event] [get_bd_pins xlconcat_0/dout]

  # Create address segments
  create_bd_addr_seg -range 0x00001000 -offset 0x40010000 [get_bd_addr_spaces pcie2AxiMaster_0/M_AXI] [get_bd_addr_segs AXI_i2c_Matrox_0/S_AXI/S_AXI_reg] SEG_AXI_i2c_Matrox_0_S_AXI_reg
  create_bd_addr_seg -range 0x00001000 -offset 0x40000000 [get_bd_addr_spaces pcie2AxiMaster_0/M_AXI] [get_bd_addr_segs XGS_athena_0/s_axi/reg0] SEG_XGS_athena_0_reg0
  create_bd_addr_seg -range 0x00001000 -offset 0xC2000000 [get_bd_addr_spaces eyescan_microblaze_system/jtag_axi_0/Data] [get_bd_addr_segs eyescan_microblaze_system/axi_bram_ctrl_0/S_AXI/Mem0] SEG_axi_bram_ctrl_0_Mem0
  create_bd_addr_seg -range 0x00001000 -offset 0xC0000000 [get_bd_addr_spaces eyescan_microblaze_system/jtag_axi_0/Data] [get_bd_addr_segs eyescan_microblaze_system/drp_bridge_0/AXI/reg0] SEG_drp_bridge_0_reg0
  create_bd_addr_seg -range 0x00001000 -offset 0xC0001000 [get_bd_addr_spaces eyescan_microblaze_system/jtag_axi_0/Data] [get_bd_addr_segs eyescan_microblaze_system/drp_bridge_1/AXI/reg0] SEG_drp_bridge_1_reg0
  create_bd_addr_seg -range 0x00001000 -offset 0xC2000000 [get_bd_addr_spaces eyescan_microblaze_system/microblaze_0/Data] [get_bd_addr_segs eyescan_microblaze_system/axi_bram_ctrl_0/S_AXI/Mem0] SEG_axi_bram_ctrl_0_Mem0
  create_bd_addr_seg -range 0x00004000 -offset 0x00000000 [get_bd_addr_spaces eyescan_microblaze_system/microblaze_0/Data] [get_bd_addr_segs eyescan_microblaze_system/microblaze_0_local_memory/dlmb_bram_if_cntlr/SLMB/Mem] SEG_dlmb_bram_if_cntlr_Mem
  create_bd_addr_seg -range 0x00001000 -offset 0xC0000000 [get_bd_addr_spaces eyescan_microblaze_system/microblaze_0/Data] [get_bd_addr_segs eyescan_microblaze_system/drp_bridge_0/AXI/reg0] SEG_drp_bridge_0_reg0
  create_bd_addr_seg -range 0x00001000 -offset 0xC0001000 [get_bd_addr_spaces eyescan_microblaze_system/microblaze_0/Data] [get_bd_addr_segs eyescan_microblaze_system/drp_bridge_1/AXI/reg0] SEG_drp_bridge_1_reg0
  create_bd_addr_seg -range 0x00004000 -offset 0x00000000 [get_bd_addr_spaces eyescan_microblaze_system/microblaze_0/Instruction] [get_bd_addr_segs eyescan_microblaze_system/microblaze_0_local_memory/ilmb_bram_if_cntlr1/SLMB/Mem] SEG_ilmb_bram_if_cntlr1_Mem


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


