
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
xilinx.com:ip:clk_wiz:6.0\
matrox.com:Imaging:axiHiSPi:1.1.1\
matrox.com:Imaging:axiMaio:1.7\
xilinx.com:ip:axi_mm2s_mapper:1.1\
xilinx.com:ip:axi_pcie:2.9\
xilinx.com:ip:axi_quad_spi:3.2\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:axi_timer:2.0\
xilinx.com:ip:axi_uartlite:2.0\
xilinx.com:ip:mdm:3.2\
xilinx.com:ip:microblaze:11.0\
xilinx.com:ip:axi_intc:4.1\
xilinx.com:ip:xlconcat:2.1\
matrox.com:Imaging:rpc2_ctrl_controller:1.0\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:util_reduced_logic:2.0\
xilinx.com:ip:lmb_bram_if_cntlr:4.0\
xilinx.com:ip:lmb_v10:3.0\
xilinx.com:ip:blk_mem_gen:8.4\
xilinx.com:ip:axi_dma:7.1\
xilinx.com:ip:axi_ethernet:7.1\
xilinx.com:ip:mii_to_rmii:2.0\
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


# Hierarchical cell: sect_profinet
proc create_hier_cell_sect_profinet { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_sect_profinet() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_dma_rd

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_dma_sg

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_dma_wr

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 mdio

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:rmii_rtl:1.0 rmii

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_dma

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_ethernet


  # Create pins
  create_bd_pin -dir O -type intr dmard_irq
  create_bd_pin -dir O -type intr dmawr_irq
  create_bd_pin -dir O -type intr eth_irq
  create_bd_pin -dir I -type clk gtx_clk_125MHz
  create_bd_pin -dir O -type intr mac_irq
  create_bd_pin -dir I -type clk ncsi_clk_50MHz
  create_bd_pin -dir I -type clk sysclk_100MHz
  create_bd_pin -dir I -type rst sysrst_n

  # Create instance: axi_dma_0, and set properties
  set axi_dma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_0 ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s_dre {1} \
   CONFIG.c_include_s2mm_dre {1} \
   CONFIG.c_micro_dma {0} \
   CONFIG.c_sg_include_stscntrl_strm {1} \
   CONFIG.c_sg_length_width {16} \
   CONFIG.c_sg_use_stsapp_length {1} \
 ] $axi_dma_0

  # Create instance: axi_ethernet_0, and set properties
  set axi_ethernet_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernet:7.1 axi_ethernet_0 ]
  set_property -dict [ list \
   CONFIG.Include_IO {false} \
   CONFIG.PHY_TYPE {MII} \
 ] $axi_ethernet_0

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /profinet_system/sect_profinet/axi_ethernet_0/axi_rxd_arstn]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /profinet_system/sect_profinet/axi_ethernet_0/axi_rxs_arstn]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /profinet_system/sect_profinet/axi_ethernet_0/axi_txc_arstn]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /profinet_system/sect_profinet/axi_ethernet_0/axi_txd_arstn]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {m_axis_rxd:m_axis_rxs:s_axis_txc:s_axis_txd} \
   CONFIG.ASSOCIATED_RESET {axi_rxd_arstn:axi_rxs_arstn:axi_txc_arstn:axi_txd_arstn} \
 ] [get_bd_pins /profinet_system/sect_profinet/axi_ethernet_0/axis_clk]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
 ] [get_bd_pins /profinet_system/sect_profinet/axi_ethernet_0/gtx_clk]

  set_property -dict [ list \
   CONFIG.SENSITIVITY {LEVEL_HIGH} \
 ] [get_bd_pins /profinet_system/sect_profinet/axi_ethernet_0/interrupt]

  set_property -dict [ list \
   CONFIG.SENSITIVITY {EDGE_RISING} \
 ] [get_bd_pins /profinet_system/sect_profinet/axi_ethernet_0/mac_irq]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /profinet_system/sect_profinet/axi_ethernet_0/phy_rst_n]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {s_axi} \
   CONFIG.ASSOCIATED_RESET {s_axi_lite_resetn} \
 ] [get_bd_pins /profinet_system/sect_profinet/axi_ethernet_0/s_axi_lite_clk]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /profinet_system/sect_profinet/axi_ethernet_0/s_axi_lite_resetn]

  # Create instance: mii_to_rmii_0, and set properties
  set mii_to_rmii_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mii_to_rmii:2.0 mii_to_rmii_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_axi_ethernet] [get_bd_intf_pins axi_ethernet_0/s_axi]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins s_axi_dma] [get_bd_intf_pins axi_dma_0/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins rmii] [get_bd_intf_pins mii_to_rmii_0/RMII_PHY_M]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins m_axi_dma_sg] [get_bd_intf_pins axi_dma_0/M_AXI_SG]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins m_axi_dma_rd] [get_bd_intf_pins axi_dma_0/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins m_axi_dma_wr] [get_bd_intf_pins axi_dma_0/M_AXI_S2MM]
  connect_bd_intf_net -intf_net Conn7 [get_bd_intf_pins mdio] [get_bd_intf_pins axi_ethernet_0/mdio]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXIS_CNTRL [get_bd_intf_pins axi_dma_0/M_AXIS_CNTRL] [get_bd_intf_pins axi_ethernet_0/s_axis_txc]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXIS_MM2S [get_bd_intf_pins axi_dma_0/M_AXIS_MM2S] [get_bd_intf_pins axi_ethernet_0/s_axis_txd]
  connect_bd_intf_net -intf_net axi_ethernet_0_m_axis_rxd [get_bd_intf_pins axi_dma_0/S_AXIS_S2MM] [get_bd_intf_pins axi_ethernet_0/m_axis_rxd]
  connect_bd_intf_net -intf_net axi_ethernet_0_m_axis_rxs [get_bd_intf_pins axi_dma_0/S_AXIS_STS] [get_bd_intf_pins axi_ethernet_0/m_axis_rxs]
  connect_bd_intf_net -intf_net axi_ethernet_0_mii [get_bd_intf_pins axi_ethernet_0/mii] [get_bd_intf_pins mii_to_rmii_0/MII]

  # Create port connections
  connect_bd_net -net axi_dma_0_mm2s_cntrl_reset_out_n [get_bd_pins axi_dma_0/mm2s_cntrl_reset_out_n] [get_bd_pins axi_ethernet_0/axi_txc_arstn]
  connect_bd_net -net axi_dma_0_mm2s_introut [get_bd_pins dmard_irq] [get_bd_pins axi_dma_0/mm2s_introut]
  connect_bd_net -net axi_dma_0_mm2s_prmry_reset_out_n [get_bd_pins axi_dma_0/mm2s_prmry_reset_out_n] [get_bd_pins axi_ethernet_0/axi_txd_arstn]
  connect_bd_net -net axi_dma_0_s2mm_introut [get_bd_pins dmawr_irq] [get_bd_pins axi_dma_0/s2mm_introut]
  connect_bd_net -net axi_dma_0_s2mm_prmry_reset_out_n [get_bd_pins axi_dma_0/s2mm_prmry_reset_out_n] [get_bd_pins axi_ethernet_0/axi_rxd_arstn]
  connect_bd_net -net axi_dma_0_s2mm_sts_reset_out_n [get_bd_pins axi_dma_0/s2mm_sts_reset_out_n] [get_bd_pins axi_ethernet_0/axi_rxs_arstn]
  connect_bd_net -net axi_ethernet_0_interrupt [get_bd_pins eth_irq] [get_bd_pins axi_ethernet_0/interrupt]
  connect_bd_net -net axi_ethernet_0_mac_irq [get_bd_pins mac_irq] [get_bd_pins axi_ethernet_0/mac_irq]
  connect_bd_net -net axi_ethernet_0_phy_rst_n [get_bd_pins axi_ethernet_0/phy_rst_n] [get_bd_pins mii_to_rmii_0/rst_n]
  connect_bd_net -net axi_resetn_0_1 [get_bd_pins sysrst_n] [get_bd_pins axi_dma_0/axi_resetn] [get_bd_pins axi_ethernet_0/s_axi_lite_resetn]
  connect_bd_net -net gtx_clk_0_1 [get_bd_pins gtx_clk_125MHz] [get_bd_pins axi_ethernet_0/gtx_clk]
  connect_bd_net -net ref_clk_0_1 [get_bd_pins ncsi_clk_50MHz] [get_bd_pins mii_to_rmii_0/ref_clk]
  connect_bd_net -net s_axi_lite_aclk_0_1 [get_bd_pins sysclk_100MHz] [get_bd_pins axi_dma_0/m_axi_mm2s_aclk] [get_bd_pins axi_dma_0/m_axi_s2mm_aclk] [get_bd_pins axi_dma_0/m_axi_sg_aclk] [get_bd_pins axi_dma_0/s_axi_lite_aclk] [get_bd_pins axi_ethernet_0/axis_clk] [get_bd_pins axi_ethernet_0/s_axi_lite_clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

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
  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 DLMB

  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 ILMB


  # Create pins
  create_bd_pin -dir I -type clk Clk
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
  set lmb_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 lmb_bram ]
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
  connect_bd_net -net microblaze_0_Clk [get_bd_pins Clk] [get_bd_pins dlmb_bram_if_cntlr/LMB_Clk] [get_bd_pins dlmb_v10/LMB_Clk] [get_bd_pins ilmb_bram_if_cntlr/LMB_Clk] [get_bd_pins ilmb_v10/LMB_Clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: interrupt_mapping
proc create_hier_cell_interrupt_mapping { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_interrupt_mapping() - Empty argument(s)!"}
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

  # Create pins
  create_bd_pin -dir O irq_event
  create_bd_pin -dir I -from 0 -to 0 irq_io
  create_bd_pin -dir I -from 0 -to 0 irq_qspi
  create_bd_pin -dir I -from 0 -to 0 irq_tick
  create_bd_pin -dir I -from 0 -to 0 irq_tick_latch
  create_bd_pin -dir I -from 0 -to 0 irq_tick_wa
  create_bd_pin -dir I -from 7 -to 0 irq_timer_start
  create_bd_pin -dir I -from 7 -to 0 irq_timer_stop

  # Create instance: util_reduced_logic_0, and set properties
  set util_reduced_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {16} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_reduced_logic_0

  # Create instance: util_reduced_logic_1, and set properties
  set util_reduced_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_1 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {22} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_reduced_logic_1

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN10_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.IN3_WIDTH {1} \
   CONFIG.IN4_WIDTH {8} \
   CONFIG.IN5_WIDTH {8} \
   CONFIG.IN6_WIDTH {1} \
   CONFIG.IN7_WIDTH {1} \
   CONFIG.IN8_WIDTH {8} \
   CONFIG.IN9_WIDTH {1} \
   CONFIG.NUM_PORTS {8} \
 ] $xlconcat_0

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {8} \
   CONFIG.IN1_WIDTH {8} \
 ] $xlconcat_1

  # Create port connections
  connect_bd_net -net In7_0_1 [get_bd_pins irq_qspi] [get_bd_pins xlconcat_0/In7]
  connect_bd_net -net Net [get_bd_pins irq_timer_stop] [get_bd_pins xlconcat_0/In5] [get_bd_pins xlconcat_1/In1]
  connect_bd_net -net axiMaio_0_irq_event_io [get_bd_pins irq_io] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net axiMaio_0_irq_event_tick [get_bd_pins irq_tick] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net axiMaio_0_irq_event_tick_wrap [get_bd_pins irq_tick_wa] [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net axiMaio_0_irq_event_timer_start [get_bd_pins irq_timer_start] [get_bd_pins xlconcat_0/In4] [get_bd_pins xlconcat_1/In0]
  connect_bd_net -net irq_tick_latch_1 [get_bd_pins irq_tick_latch] [get_bd_pins xlconcat_0/In6]
  connect_bd_net -net util_reduced_logic_0_Res [get_bd_pins util_reduced_logic_0/Res] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net util_reduced_logic_1_Res [get_bd_pins irq_event] [get_bd_pins util_reduced_logic_1/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins util_reduced_logic_1/Op1] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins util_reduced_logic_0/Op1] [get_bd_pins xlconcat_1/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: profinet_system
proc create_hier_cell_profinet_system { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_profinet_system() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_host

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:rmii_rtl:1.0 rmii_0

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 uart


  # Create pins
  create_bd_pin -dir O -from 1 -to 0 GPO_0
  create_bd_pin -dir O IENOn_0
  create_bd_pin -dir O RPC_CK_0
  create_bd_pin -dir O RPC_CK_N_0
  create_bd_pin -dir O RPC_CS0_N_0
  create_bd_pin -dir O RPC_CS1_N_0
  create_bd_pin -dir IO -from 7 -to 0 RPC_DQ_0
  create_bd_pin -dir O RPC_RESET_N_0
  create_bd_pin -dir IO RPC_RWDS_0
  create_bd_pin -dir O RPC_WP_N_0
  create_bd_pin -dir I dcm_locked
  create_bd_pin -dir I -type rst ext_rst_n
  create_bd_pin -dir I -type clk gtx_clk_125MHz_0
  create_bd_pin -dir I -type clk ncsi_clk_50MHz_0
  create_bd_pin -dir O -from 0 -to 0 sys_rst_n
  create_bd_pin -dir I -type clk sysclk_100MHz

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {3} \
   CONFIG.NUM_SI {5} \
 ] $axi_interconnect_0

  # Create instance: axi_timer_0, and set properties
  set axi_timer_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer_0 ]

  # Create instance: axi_timer_1, and set properties
  set axi_timer_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer_1 ]

  # Create instance: axi_uartlite_0, and set properties
  set axi_uartlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0 ]

  # Create instance: mdm_1, and set properties
  set mdm_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mdm:3.2 mdm_1 ]
  set_property -dict [ list \
   CONFIG.C_ADDR_SIZE {32} \
   CONFIG.C_M_AXI_ADDR_WIDTH {32} \
   CONFIG.C_USE_UART {1} \
 ] $mdm_1

  # Create instance: microblaze_0, and set properties
  set microblaze_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 microblaze_0 ]
  set_property -dict [ list \
   CONFIG.C_CACHE_BYTE_SIZE {65536} \
   CONFIG.C_DCACHE_BYTE_SIZE {65536} \
   CONFIG.C_DEBUG_ENABLED {1} \
   CONFIG.C_D_AXI {1} \
   CONFIG.C_D_LMB {1} \
   CONFIG.C_I_LMB {1} \
   CONFIG.C_USE_DCACHE {1} \
   CONFIG.C_USE_ICACHE {1} \
 ] $microblaze_0

  # Create instance: microblaze_0_axi_intc, and set properties
  set microblaze_0_axi_intc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 microblaze_0_axi_intc ]
  set_property -dict [ list \
   CONFIG.C_HAS_FAST {1} \
 ] $microblaze_0_axi_intc

  # Create instance: microblaze_0_axi_periph, and set properties
  set microblaze_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 microblaze_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.NUM_MI {7} \
 ] $microblaze_0_axi_periph

  # Create instance: microblaze_0_local_memory
  create_hier_cell_microblaze_0_local_memory $hier_obj microblaze_0_local_memory

  # Create instance: microblaze_0_xlconcat, and set properties
  set microblaze_0_xlconcat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 microblaze_0_xlconcat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {7} \
 ] $microblaze_0_xlconcat

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: rpc2_ctrl_controller_0, and set properties
  set rpc2_ctrl_controller_0 [ create_bd_cell -type ip -vlnv matrox.com:Imaging:rpc2_ctrl_controller:1.0 rpc2_ctrl_controller_0 ]

  # Create instance: rst_Clk_100M, and set properties
  set rst_Clk_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_Clk_100M ]

  # Create instance: sect_profinet
  create_hier_cell_sect_profinet $hier_obj sect_profinet

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins m_axi_host] [get_bd_intf_pins axi_interconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins uart] [get_bd_intf_pins axi_uartlite_0/UART]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins rmii_0] [get_bd_intf_pins sect_profinet/rmii]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins axi_interconnect_0/M01_AXI] [get_bd_intf_pins rpc2_ctrl_controller_0/AXIm]
  connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI [get_bd_intf_pins axi_interconnect_0/M02_AXI] [get_bd_intf_pins rpc2_ctrl_controller_0/AXIr]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_DC [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins microblaze_0/M_AXI_DC]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_IC [get_bd_intf_pins axi_interconnect_0/S01_AXI] [get_bd_intf_pins microblaze_0/M_AXI_IC]
  connect_bd_intf_net -intf_net microblaze_0_axi_dp [get_bd_intf_pins microblaze_0/M_AXI_DP] [get_bd_intf_pins microblaze_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M02_AXI [get_bd_intf_pins axi_timer_0/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M03_AXI [get_bd_intf_pins axi_timer_1/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M04_AXI [get_bd_intf_pins axi_uartlite_0/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M04_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M05_AXI [get_bd_intf_pins microblaze_0_axi_periph/M05_AXI] [get_bd_intf_pins sect_profinet/s_axi_ethernet]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M06_AXI [get_bd_intf_pins microblaze_0_axi_periph/M06_AXI] [get_bd_intf_pins sect_profinet/s_axi_dma]
  connect_bd_intf_net -intf_net microblaze_0_debug [get_bd_intf_pins mdm_1/MBDEBUG_0] [get_bd_intf_pins microblaze_0/DEBUG]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_1 [get_bd_intf_pins microblaze_0/DLMB] [get_bd_intf_pins microblaze_0_local_memory/DLMB]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_1 [get_bd_intf_pins microblaze_0/ILMB] [get_bd_intf_pins microblaze_0_local_memory/ILMB]
  connect_bd_intf_net -intf_net microblaze_0_intc_axi [get_bd_intf_pins microblaze_0_axi_intc/s_axi] [get_bd_intf_pins microblaze_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_interrupt [get_bd_intf_pins microblaze_0/INTERRUPT] [get_bd_intf_pins microblaze_0_axi_intc/interrupt]
  connect_bd_intf_net -intf_net microblaze_0_mdm_axi [get_bd_intf_pins mdm_1/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net sect_profinet_m_axi_dma_rd [get_bd_intf_pins axi_interconnect_0/S02_AXI] [get_bd_intf_pins sect_profinet/m_axi_dma_rd]
  connect_bd_intf_net -intf_net sect_profinet_m_axi_dma_sg [get_bd_intf_pins axi_interconnect_0/S04_AXI] [get_bd_intf_pins sect_profinet/m_axi_dma_sg]
  connect_bd_intf_net -intf_net sect_profinet_m_axi_dma_wr [get_bd_intf_pins axi_interconnect_0/S03_AXI] [get_bd_intf_pins sect_profinet/m_axi_dma_wr]

  # Create port connections
  connect_bd_net -net ARESETN_1 [get_bd_pins microblaze_0_axi_periph/ARESETN] [get_bd_pins rst_Clk_100M/interconnect_aresetn]
  connect_bd_net -net Net [get_bd_pins RPC_RWDS_0] [get_bd_pins rpc2_ctrl_controller_0/RPC_RWDS]
  connect_bd_net -net Net1 [get_bd_pins RPC_DQ_0] [get_bd_pins rpc2_ctrl_controller_0/RPC_DQ]
  connect_bd_net -net PCIE_RESET_N_1 [get_bd_pins ext_rst_n] [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net axi_timer_0_interrupt [get_bd_pins axi_timer_0/interrupt] [get_bd_pins microblaze_0_xlconcat/In0]
  connect_bd_net -net axi_timer_1_interrupt [get_bd_pins axi_timer_1/interrupt] [get_bd_pins microblaze_0_xlconcat/In1]
  connect_bd_net -net axi_uartlite_0_interrupt [get_bd_pins axi_uartlite_0/interrupt] [get_bd_pins microblaze_0_xlconcat/In2]
  connect_bd_net -net dcm_locked_1 [get_bd_pins dcm_locked] [get_bd_pins proc_sys_reset_0/dcm_locked]
  connect_bd_net -net gtx_clk_125MHz_1 [get_bd_pins gtx_clk_125MHz_0] [get_bd_pins sect_profinet/gtx_clk_125MHz]
  connect_bd_net -net mdm_1_debug_sys_rst [get_bd_pins mdm_1/Debug_SYS_Rst] [get_bd_pins rst_Clk_100M/mb_debug_sys_rst]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins sysclk_100MHz] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_interconnect_0/M02_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axi_interconnect_0/S01_ACLK] [get_bd_pins axi_interconnect_0/S02_ACLK] [get_bd_pins axi_interconnect_0/S03_ACLK] [get_bd_pins axi_interconnect_0/S04_ACLK] [get_bd_pins axi_timer_0/s_axi_aclk] [get_bd_pins axi_timer_1/s_axi_aclk] [get_bd_pins axi_uartlite_0/s_axi_aclk] [get_bd_pins mdm_1/S_AXI_ACLK] [get_bd_pins microblaze_0/Clk] [get_bd_pins microblaze_0_axi_intc/processor_clk] [get_bd_pins microblaze_0_axi_intc/s_axi_aclk] [get_bd_pins microblaze_0_axi_periph/ACLK] [get_bd_pins microblaze_0_axi_periph/M00_ACLK] [get_bd_pins microblaze_0_axi_periph/M01_ACLK] [get_bd_pins microblaze_0_axi_periph/M02_ACLK] [get_bd_pins microblaze_0_axi_periph/M03_ACLK] [get_bd_pins microblaze_0_axi_periph/M04_ACLK] [get_bd_pins microblaze_0_axi_periph/M05_ACLK] [get_bd_pins microblaze_0_axi_periph/M06_ACLK] [get_bd_pins microblaze_0_axi_periph/S00_ACLK] [get_bd_pins microblaze_0_local_memory/Clk] [get_bd_pins rpc2_ctrl_controller_0/AXIm_ACLK] [get_bd_pins rpc2_ctrl_controller_0/AXIr_ACLK] [get_bd_pins rpc2_ctrl_controller_0/ref_clk] [get_bd_pins rpc2_ctrl_controller_0/sys_clk] [get_bd_pins rst_Clk_100M/slowest_sync_clk] [get_bd_pins sect_profinet/sysclk_100MHz]
  connect_bd_net -net microblaze_0_intr [get_bd_pins microblaze_0_axi_intc/intr] [get_bd_pins microblaze_0_xlconcat/dout]
  connect_bd_net -net ncsi_clk_50MHz_1 [get_bd_pins ncsi_clk_50MHz_0] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins sect_profinet/ncsi_clk_50MHz]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins proc_sys_reset_0/interconnect_aresetn] [get_bd_pins rst_Clk_100M/ext_reset_in]
  connect_bd_net -net rpc2_ctrl_controller_0_GPO [get_bd_pins GPO_0] [get_bd_pins rpc2_ctrl_controller_0/GPO]
  connect_bd_net -net rpc2_ctrl_controller_0_IENOn [get_bd_pins IENOn_0] [get_bd_pins rpc2_ctrl_controller_0/IENOn]
  connect_bd_net -net rpc2_ctrl_controller_0_RPC_CK [get_bd_pins RPC_CK_0] [get_bd_pins rpc2_ctrl_controller_0/RPC_CK]
  connect_bd_net -net rpc2_ctrl_controller_0_RPC_CK_N [get_bd_pins RPC_CK_N_0] [get_bd_pins rpc2_ctrl_controller_0/RPC_CK_N]
  connect_bd_net -net rpc2_ctrl_controller_0_RPC_CS0_N [get_bd_pins RPC_CS0_N_0] [get_bd_pins rpc2_ctrl_controller_0/RPC_CS0_N]
  connect_bd_net -net rpc2_ctrl_controller_0_RPC_CS1_N [get_bd_pins RPC_CS1_N_0] [get_bd_pins rpc2_ctrl_controller_0/RPC_CS1_N]
  connect_bd_net -net rpc2_ctrl_controller_0_RPC_RESET_N [get_bd_pins RPC_RESET_N_0] [get_bd_pins rpc2_ctrl_controller_0/RPC_RESET_N]
  connect_bd_net -net rpc2_ctrl_controller_0_RPC_WP_N [get_bd_pins RPC_WP_N_0] [get_bd_pins rpc2_ctrl_controller_0/RPC_WP_N]
  connect_bd_net -net rst_Clk_100M_bus_struct_reset [get_bd_pins microblaze_0_local_memory/SYS_Rst] [get_bd_pins rst_Clk_100M/bus_struct_reset]
  connect_bd_net -net rst_Clk_100M_mb_reset [get_bd_pins microblaze_0/Reset] [get_bd_pins microblaze_0_axi_intc/processor_rst] [get_bd_pins rst_Clk_100M/mb_reset]
  connect_bd_net -net rst_Clk_100M_peripheral_aresetn [get_bd_pins sys_rst_n] [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_interconnect_0/M02_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins axi_interconnect_0/S01_ARESETN] [get_bd_pins axi_interconnect_0/S02_ARESETN] [get_bd_pins axi_interconnect_0/S03_ARESETN] [get_bd_pins axi_interconnect_0/S04_ARESETN] [get_bd_pins axi_uartlite_0/s_axi_aresetn] [get_bd_pins mdm_1/S_AXI_ARESETN] [get_bd_pins microblaze_0_axi_intc/s_axi_aresetn] [get_bd_pins microblaze_0_axi_periph/M00_ARESETN] [get_bd_pins microblaze_0_axi_periph/M01_ARESETN] [get_bd_pins microblaze_0_axi_periph/M02_ARESETN] [get_bd_pins microblaze_0_axi_periph/M03_ARESETN] [get_bd_pins microblaze_0_axi_periph/M04_ARESETN] [get_bd_pins microblaze_0_axi_periph/M05_ARESETN] [get_bd_pins microblaze_0_axi_periph/M06_ARESETN] [get_bd_pins microblaze_0_axi_periph/S00_ARESETN] [get_bd_pins rpc2_ctrl_controller_0/AXIm_ARESETN] [get_bd_pins rpc2_ctrl_controller_0/AXIr_ARESETN] [get_bd_pins rpc2_ctrl_controller_0/RPC_RSTO_N] [get_bd_pins rst_Clk_100M/peripheral_aresetn] [get_bd_pins sect_profinet/sysrst_n]
  connect_bd_net -net sect_profinet_dmard_irq [get_bd_pins microblaze_0_xlconcat/In5] [get_bd_pins sect_profinet/dmard_irq]
  connect_bd_net -net sect_profinet_dmawr_irq [get_bd_pins microblaze_0_xlconcat/In6] [get_bd_pins sect_profinet/dmawr_irq]
  connect_bd_net -net sect_profinet_eth_irq [get_bd_pins microblaze_0_xlconcat/In4] [get_bd_pins sect_profinet/eth_irq]
  connect_bd_net -net sect_profinet_mac_irq [get_bd_pins microblaze_0_xlconcat/In3] [get_bd_pins sect_profinet/mac_irq]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins rpc2_ctrl_controller_0/RPC_INT_N] [get_bd_pins xlconstant_0/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: host_system
proc create_hier_cell_host_system { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_host_system() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:spi_rtl:1.0 SPI_0_0

  create_bd_intf_pin -mode Master -vlnv xilinx.com:display_startup_io:startup_io_rtl:1.0 STARTUP_IO_0

  create_bd_intf_pin -mode Master -vlnv matrox.com:user:ext_sync_rtl:1.0 ext_sync

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_mb


  # Create pins
  create_bd_pin -dir I -type rst ext_rst_n
  create_bd_pin -dir I -type clk ext_spi_clk
  create_bd_pin -dir I -from 5 -to 0 hispi_data_n_0
  create_bd_pin -dir I -from 5 -to 0 hispi_data_p_0
  create_bd_pin -dir I -from 5 -to 0 hispi_serial_clk_n_0
  create_bd_pin -dir I -from 5 -to 0 hispi_serial_clk_p_0
  create_bd_pin -dir I -type clk pcie_refck_100MHz
  create_bd_pin -dir I -type rst sys_rst_n
  create_bd_pin -dir I sysclk_100MHz
  create_bd_pin -dir I -from 3 -to 0 user_data_in
  create_bd_pin -dir O -from 2 -to 0 user_data_out

  # Create instance: axiHiSPi_0, and set properties
  set axiHiSPi_0 [ create_bd_cell -type ip -vlnv matrox.com:Imaging:axiHiSPi:1.1.1 axiHiSPi_0 ]

  # Create instance: axiMaio_0, and set properties
  set axiMaio_0 [ create_bd_cell -type ip -vlnv matrox.com:Imaging:axiMaio:1.7 axiMaio_0 ]
  set_property -dict [ list \
   CONFIG.NUM_QUAD_DEC {1} \
   CONFIG.NUM_TICK_TABLE {1} \
   CONFIG.NUM_TIMER {8} \
   CONFIG.NUM_USER_INPUT {4} \
   CONFIG.NUM_USER_OUTPUT {3} \
   CONFIG.TICK_TABLE_WIDTH {4} \
 ] $axiMaio_0

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {2} \
 ] $axi_interconnect_0

  # Create instance: axi_interconnect_1, and set properties
  set axi_interconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_1 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {4} \
 ] $axi_interconnect_1

  # Create instance: axi_mm2s_mapper_0, and set properties
  set axi_mm2s_mapper_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_mm2s_mapper:1.1 axi_mm2s_mapper_0 ]
  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.INTERFACES {M_AXI} \
   CONFIG.TDATA_NUM_BYTES {8} \
 ] $axi_mm2s_mapper_0

  # Create instance: axi_pcie_0, and set properties
  set axi_pcie_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_pcie:2.9 axi_pcie_0 ]
  set_property -dict [ list \
   CONFIG.AXIBAR_AS_0 {false} \
   CONFIG.BAR0_SCALE {Megabytes} \
   CONFIG.BAR0_SIZE {32} \
   CONFIG.BAR1_ENABLED {false} \
   CONFIG.BAR1_SCALE {N/A} \
   CONFIG.BAR1_SIZE {8} \
   CONFIG.BAR1_TYPE {N/A} \
   CONFIG.BAR_64BIT {false} \
   CONFIG.BASE_CLASS_MENU {Input_devices} \
   CONFIG.DEVICE_ID {0x7012} \
   CONFIG.HIGHADDR {0x40000FFF} \
   CONFIG.INCLUDE_BAROFFSET_REG {false} \
   CONFIG.INTERRUPT_PIN {true} \
   CONFIG.MAX_LINK_SPEED {2.5_GT/s} \
   CONFIG.M_AXI_DATA_WIDTH {64} \
   CONFIG.NO_OF_LANES {X2} \
   CONFIG.SLOT_CLOCK_CONFIG {true} \
   CONFIG.SUB_CLASS_INTERFACE_MENU {Other_input_controller} \
   CONFIG.S_AXI_DATA_WIDTH {64} \
   CONFIG.S_AXI_SUPPORTS_NARROW_BURST {true} \
   CONFIG.VENDOR_ID {0x102b} \
   CONFIG.shared_logic_in_core {false} \
 ] $axi_pcie_0

  # Create instance: axi_quad_spi_0, and set properties
  set axi_quad_spi_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 axi_quad_spi_0 ]
  set_property -dict [ list \
   CONFIG.C_FIFO_DEPTH {16} \
   CONFIG.C_NUM_SS_BITS {1} \
   CONFIG.C_SCK_RATIO {2} \
   CONFIG.C_SHARED_STARTUP {0} \
   CONFIG.C_SPI_MODE {2} \
   CONFIG.C_TYPE_OF_AXI4_INTERFACE {0} \
   CONFIG.C_USE_STARTUP {1} \
   CONFIG.C_USE_STARTUP_INT {1} \
   CONFIG.C_XIP_MODE {0} \
 ] $axi_quad_spi_0

  # Create instance: interrupt_mapping
  create_hier_cell_interrupt_mapping $hier_obj interrupt_mapping

  # Create instance: pcie_axi_reset, and set properties
  set pcie_axi_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 pcie_axi_reset ]

  # Create interface connections
  connect_bd_intf_net -intf_net axiHiSPi_0_m_axis [get_bd_intf_pins axiHiSPi_0/m_axis] [get_bd_intf_pins axi_mm2s_mapper_0/S_AXIS]
  connect_bd_intf_net -intf_net axiMaio_0_ext_sync [get_bd_intf_pins ext_sync] [get_bd_intf_pins axiMaio_0/ext_sync]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins axi_pcie_0/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M00_AXI [get_bd_intf_pins axiMaio_0/s_axi] [get_bd_intf_pins axi_interconnect_1/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M01_AXI [get_bd_intf_pins axiHiSPi_0/s_axi] [get_bd_intf_pins axi_interconnect_1/M01_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M02_AXI [get_bd_intf_pins axi_interconnect_1/M02_AXI] [get_bd_intf_pins axi_quad_spi_0/AXI_LITE]
  connect_bd_intf_net -intf_net axi_interconnect_1_M03_AXI [get_bd_intf_pins axi_interconnect_1/M03_AXI] [get_bd_intf_pins axi_pcie_0/S_AXI_CTL]
  connect_bd_intf_net -intf_net axi_mm2s_mapper_0_M_AXI [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins axi_mm2s_mapper_0/M_AXI]
  connect_bd_intf_net -intf_net axi_mm2s_mapper_0_M_AXIS [get_bd_intf_pins axiHiSPi_0/s_axis] [get_bd_intf_pins axi_mm2s_mapper_0/M_AXIS]
  connect_bd_intf_net -intf_net axi_pcie_0_M_AXI [get_bd_intf_pins axi_interconnect_1/S00_AXI] [get_bd_intf_pins axi_pcie_0/M_AXI]
  connect_bd_intf_net -intf_net axi_pcie_0_pcie_7x_mgt [get_bd_intf_pins pcie] [get_bd_intf_pins axi_pcie_0/pcie_7x_mgt]
  connect_bd_intf_net -intf_net axi_quad_spi_0_SPI_0 [get_bd_intf_pins SPI_0_0] [get_bd_intf_pins axi_quad_spi_0/SPI_0]
  connect_bd_intf_net -intf_net axi_quad_spi_0_STARTUP_IO [get_bd_intf_pins STARTUP_IO_0] [get_bd_intf_pins axi_quad_spi_0/STARTUP_IO]
  connect_bd_intf_net -intf_net s_axi_mb_1 [get_bd_intf_pins s_axi_mb] [get_bd_intf_pins axi_interconnect_0/S01_AXI]

  # Create port connections
  connect_bd_net -net ARESETN_1 [get_bd_pins axiHiSPi_0/axi_reset_n] [get_bd_pins axiMaio_0/axi_aresetn] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins axi_interconnect_1/M00_ARESETN] [get_bd_pins axi_interconnect_1/M01_ARESETN] [get_bd_pins axi_interconnect_1/M02_ARESETN] [get_bd_pins axi_interconnect_1/M03_ARESETN] [get_bd_pins axi_interconnect_1/S00_ARESETN] [get_bd_pins axi_mm2s_mapper_0/aresetn] [get_bd_pins axi_pcie_0/axi_aresetn] [get_bd_pins axi_quad_spi_0/s_axi_aresetn] [get_bd_pins pcie_axi_reset/peripheral_aresetn]
  connect_bd_net -net PCIE_REFCLK_100MHz_2 [get_bd_pins pcie_refck_100MHz] [get_bd_pins axi_pcie_0/REFCLK]
  connect_bd_net -net PCIE_RESET_N_1 [get_bd_pins ext_rst_n] [get_bd_pins pcie_axi_reset/ext_reset_in]
  connect_bd_net -net S01_ARESETN_1 [get_bd_pins sys_rst_n] [get_bd_pins axi_interconnect_0/S01_ARESETN]
  connect_bd_net -net axiMaio_0_irq_event_io [get_bd_pins axiMaio_0/irq_event_io] [get_bd_pins interrupt_mapping/irq_io]
  connect_bd_net -net axiMaio_0_irq_event_tick [get_bd_pins axiMaio_0/irq_event_tick] [get_bd_pins interrupt_mapping/irq_tick]
  connect_bd_net -net axiMaio_0_irq_event_tick_stamp_latched [get_bd_pins axiMaio_0/irq_event_tick_stamp_latched] [get_bd_pins interrupt_mapping/irq_tick_latch]
  connect_bd_net -net axiMaio_0_irq_event_tick_wrap [get_bd_pins axiMaio_0/irq_event_tick_wrap] [get_bd_pins interrupt_mapping/irq_tick_wa]
  connect_bd_net -net axiMaio_0_irq_event_timer_end [get_bd_pins axiMaio_0/irq_event_timer_end] [get_bd_pins interrupt_mapping/irq_timer_stop]
  connect_bd_net -net axiMaio_0_irq_event_timer_start [get_bd_pins axiMaio_0/irq_event_timer_start] [get_bd_pins interrupt_mapping/irq_timer_start]
  connect_bd_net -net axiMaio_0_user_data_out [get_bd_pins user_data_out] [get_bd_pins axiMaio_0/user_data_out]
  connect_bd_net -net axi_pcie_0_axi_aclk_out [get_bd_pins axiHiSPi_0/axi_clk] [get_bd_pins axiMaio_0/axi_aclk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axi_interconnect_1/ACLK] [get_bd_pins axi_interconnect_1/M00_ACLK] [get_bd_pins axi_interconnect_1/M01_ACLK] [get_bd_pins axi_interconnect_1/M02_ACLK] [get_bd_pins axi_interconnect_1/S00_ACLK] [get_bd_pins axi_mm2s_mapper_0/aclk] [get_bd_pins axi_pcie_0/axi_aclk_out] [get_bd_pins axi_quad_spi_0/s_axi_aclk] [get_bd_pins pcie_axi_reset/slowest_sync_clk]
  connect_bd_net -net axi_pcie_0_axi_ctl_aclk_out [get_bd_pins axi_interconnect_1/M03_ACLK] [get_bd_pins axi_pcie_0/axi_ctl_aclk_out]
  connect_bd_net -net axi_pcie_0_mmcm_lock [get_bd_pins axi_pcie_0/mmcm_lock] [get_bd_pins pcie_axi_reset/dcm_locked]
  connect_bd_net -net axi_quad_spi_0_ip2intc_irpt [get_bd_pins axi_quad_spi_0/ip2intc_irpt] [get_bd_pins interrupt_mapping/irq_qspi]
  connect_bd_net -net clk_wiz_0_qspi_clk [get_bd_pins ext_spi_clk] [get_bd_pins axi_quad_spi_0/ext_spi_clk]
  connect_bd_net -net hispi_data_n_0_1 [get_bd_pins hispi_data_n_0] [get_bd_pins axiHiSPi_0/hispi_data_n]
  connect_bd_net -net hispi_data_p_0_1 [get_bd_pins hispi_data_p_0] [get_bd_pins axiHiSPi_0/hispi_data_p]
  connect_bd_net -net hispi_serial_clk_n_0_1 [get_bd_pins hispi_serial_clk_n_0] [get_bd_pins axiHiSPi_0/hispi_serial_clk_n]
  connect_bd_net -net hispi_serial_clk_p_0_1 [get_bd_pins hispi_serial_clk_p_0] [get_bd_pins axiHiSPi_0/hispi_serial_clk_p]
  connect_bd_net -net interrupt_mapping_irq_event [get_bd_pins axi_pcie_0/INTX_MSI_Request] [get_bd_pins interrupt_mapping/irq_event]
  connect_bd_net -net pcie_axi_reset_interconnect_aresetn [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_1/ARESETN] [get_bd_pins pcie_axi_reset/interconnect_aresetn]
  connect_bd_net -net sysclk_100MHz_1 [get_bd_pins sysclk_100MHz] [get_bd_pins axi_interconnect_0/S01_ACLK]
  connect_bd_net -net user_data_in_0_1 [get_bd_pins user_data_in] [get_bd_pins axiMaio_0/user_data_in]

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
  set ext_sync [ create_bd_intf_port -mode Master -vlnv matrox.com:user:ext_sync_rtl:1.0 ext_sync ]

  set pcie [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie ]

  set rmii [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rmii_rtl:1.0 rmii ]

  set spi [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:spi_rtl:1.0 spi ]

  set startup_io [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_startup_io:startup_io_rtl:1.0 startup_io ]

  set uart [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 uart ]


  # Create ports
  set GPO_0 [ create_bd_port -dir O -from 1 -to 0 GPO_0 ]
  set IENOn_0 [ create_bd_port -dir O IENOn_0 ]
  set RPC_CK_0 [ create_bd_port -dir O RPC_CK_0 ]
  set RPC_CK_N_0 [ create_bd_port -dir O RPC_CK_N_0 ]
  set RPC_CS0_N_0 [ create_bd_port -dir O RPC_CS0_N_0 ]
  set RPC_CS1_N_0 [ create_bd_port -dir O RPC_CS1_N_0 ]
  set RPC_DQ_0 [ create_bd_port -dir IO -from 7 -to 0 RPC_DQ_0 ]
  set RPC_RESET_N_0 [ create_bd_port -dir O RPC_RESET_N_0 ]
  set RPC_RWDS_0 [ create_bd_port -dir IO RPC_RWDS_0 ]
  set RPC_WP_N_0 [ create_bd_port -dir O RPC_WP_N_0 ]
  set ext_rst_n [ create_bd_port -dir I -type rst ext_rst_n ]
  set hispi_data_n [ create_bd_port -dir I -from 5 -to 0 hispi_data_n ]
  set hispi_data_p [ create_bd_port -dir I -from 5 -to 0 hispi_data_p ]
  set hispi_serial_clk_n [ create_bd_port -dir I -from 5 -to 0 hispi_serial_clk_n ]
  set hispi_serial_clk_p [ create_bd_port -dir I -from 5 -to 0 hispi_serial_clk_p ]
  set pcie_refclk_100MHz [ create_bd_port -dir I -type clk pcie_refclk_100MHz ]
  set ref_clk_100MHz [ create_bd_port -dir I -type clk ref_clk_100MHz ]
  set user_data_in [ create_bd_port -dir I -from 3 -to 0 user_data_in ]
  set user_data_out [ create_bd_port -dir O -from 2 -to 0 user_data_out ]

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKOUT2_JITTER {151.636} \
   CONFIG.CLKOUT2_PHASE_ERROR {98.575} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {50.000} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLKOUT3_JITTER {125.247} \
   CONFIG.CLKOUT3_PHASE_ERROR {98.575} \
   CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {125.000} \
   CONFIG.CLKOUT3_USED {true} \
   CONFIG.CLK_OUT1_PORT {ref_clk_100MHz} \
   CONFIG.CLK_OUT2_PORT {ref_clk_50MHz} \
   CONFIG.CLK_OUT3_PORT {ref_clk_125MHz} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {20} \
   CONFIG.MMCM_CLKOUT2_DIVIDE {8} \
   CONFIG.NUM_OUT_CLKS {3} \
   CONFIG.RESET_PORT {resetn} \
   CONFIG.RESET_TYPE {ACTIVE_LOW} \
 ] $clk_wiz_0

  # Create instance: host_system
  create_hier_cell_host_system [current_bd_instance .] host_system

  # Create instance: profinet_system
  create_hier_cell_profinet_system [current_bd_instance .] profinet_system

  # Create interface connections
  connect_bd_intf_net -intf_net axiMaio_0_ext_sync [get_bd_intf_ports ext_sync] [get_bd_intf_pins host_system/ext_sync]
  connect_bd_intf_net -intf_net axi_pcie_0_pcie_7x_mgt [get_bd_intf_ports pcie] [get_bd_intf_pins host_system/pcie]
  connect_bd_intf_net -intf_net axi_quad_spi_0_SPI_0 [get_bd_intf_ports spi] [get_bd_intf_pins host_system/SPI_0_0]
  connect_bd_intf_net -intf_net axi_quad_spi_0_STARTUP_IO [get_bd_intf_ports startup_io] [get_bd_intf_pins host_system/STARTUP_IO_0]
  connect_bd_intf_net -intf_net profinet_system_m_axi_host [get_bd_intf_pins host_system/s_axi_mb] [get_bd_intf_pins profinet_system/m_axi_host]
  connect_bd_intf_net -intf_net sect_mb_UART_0 [get_bd_intf_ports uart] [get_bd_intf_pins profinet_system/uart]
  connect_bd_intf_net -intf_net sect_mb_rmii_0 [get_bd_intf_ports rmii] [get_bd_intf_pins profinet_system/rmii_0]

  # Create port connections
  connect_bd_net -net Net [get_bd_ports RPC_RWDS_0] [get_bd_pins profinet_system/RPC_RWDS_0]
  connect_bd_net -net Net1 [get_bd_ports RPC_DQ_0] [get_bd_pins profinet_system/RPC_DQ_0]
  connect_bd_net -net PCIE_REFCLK_100MHz_2 [get_bd_ports pcie_refclk_100MHz] [get_bd_pins host_system/pcie_refck_100MHz]
  connect_bd_net -net PCIE_RESET_N_1 [get_bd_ports ext_rst_n] [get_bd_pins clk_wiz_0/resetn] [get_bd_pins host_system/ext_rst_n] [get_bd_pins profinet_system/ext_rst_n]
  connect_bd_net -net axiMaio_0_user_data_out [get_bd_ports user_data_out] [get_bd_pins host_system/user_data_out]
  connect_bd_net -net clk_in1_0_1 [get_bd_ports ref_clk_100MHz] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net clk_wiz_0_axi_clk [get_bd_pins clk_wiz_0/ref_clk_100MHz] [get_bd_pins host_system/sysclk_100MHz] [get_bd_pins profinet_system/sysclk_100MHz]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins profinet_system/dcm_locked]
  connect_bd_net -net clk_wiz_0_qspi_clk [get_bd_pins clk_wiz_0/ref_clk_50MHz] [get_bd_pins host_system/ext_spi_clk] [get_bd_pins profinet_system/ncsi_clk_50MHz_0]
  connect_bd_net -net clk_wiz_0_ref_clk_125MHz [get_bd_pins clk_wiz_0/ref_clk_125MHz] [get_bd_pins profinet_system/gtx_clk_125MHz_0]
  connect_bd_net -net hispi_data_n_0_1 [get_bd_ports hispi_data_n] [get_bd_pins host_system/hispi_data_n_0]
  connect_bd_net -net hispi_data_p_0_1 [get_bd_ports hispi_data_p] [get_bd_pins host_system/hispi_data_p_0]
  connect_bd_net -net hispi_serial_clk_n_0_1 [get_bd_ports hispi_serial_clk_n] [get_bd_pins host_system/hispi_serial_clk_n_0]
  connect_bd_net -net hispi_serial_clk_p_0_1 [get_bd_ports hispi_serial_clk_p] [get_bd_pins host_system/hispi_serial_clk_p_0]
  connect_bd_net -net profinet_system_GPO_0 [get_bd_ports GPO_0] [get_bd_pins profinet_system/GPO_0]
  connect_bd_net -net profinet_system_IENOn_0 [get_bd_ports IENOn_0] [get_bd_pins profinet_system/IENOn_0]
  connect_bd_net -net profinet_system_RPC_CK_0 [get_bd_ports RPC_CK_0] [get_bd_pins profinet_system/RPC_CK_0]
  connect_bd_net -net profinet_system_RPC_CK_N_0 [get_bd_ports RPC_CK_N_0] [get_bd_pins profinet_system/RPC_CK_N_0]
  connect_bd_net -net profinet_system_RPC_CS0_N_0 [get_bd_ports RPC_CS0_N_0] [get_bd_pins profinet_system/RPC_CS0_N_0]
  connect_bd_net -net profinet_system_RPC_CS1_N_0 [get_bd_ports RPC_CS1_N_0] [get_bd_pins profinet_system/RPC_CS1_N_0]
  connect_bd_net -net profinet_system_RPC_RESET_N_0 [get_bd_ports RPC_RESET_N_0] [get_bd_pins profinet_system/RPC_RESET_N_0]
  connect_bd_net -net profinet_system_RPC_WP_N_0 [get_bd_ports RPC_WP_N_0] [get_bd_pins profinet_system/RPC_WP_N_0]
  connect_bd_net -net profinet_system_sys_rst_n [get_bd_pins host_system/sys_rst_n] [get_bd_pins profinet_system/sys_rst_n]
  connect_bd_net -net user_data_in_0_1 [get_bd_ports user_data_in] [get_bd_pins host_system/user_data_in]

  # Create address segments
  create_bd_addr_seg -range 0x80000000 -offset 0x80000000 [get_bd_addr_spaces host_system/axi_mm2s_mapper_0/Bridge] [get_bd_addr_segs host_system/axi_pcie_0/S_AXI/BAR0] SEG_axi_pcie_0_BAR0
  create_bd_addr_seg -range 0x00010000 -offset 0x44A00000 [get_bd_addr_spaces host_system/axi_pcie_0/M_AXI] [get_bd_addr_segs host_system/axiMaio_0/s_axi/reg0] SEG_axiMaio_0_reg0
  create_bd_addr_seg -range 0x10000000 -offset 0x00000000 [get_bd_addr_spaces host_system/axi_pcie_0/M_AXI] [get_bd_addr_segs host_system/axi_pcie_0/S_AXI_CTL/CTL0] SEG_axi_pcie_0_CTL0
  create_bd_addr_seg -range 0x00010000 -offset 0x44A10000 [get_bd_addr_spaces host_system/axi_pcie_0/M_AXI] [get_bd_addr_segs host_system/axi_quad_spi_0/AXI_LITE/Reg] SEG_axi_quad_spi_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41E00000 [get_bd_addr_spaces profinet_system/microblaze_0/Data] [get_bd_addr_segs profinet_system/sect_profinet/axi_dma_0/S_AXI_LITE/Reg] SEG_axi_dma_0_Reg
  create_bd_addr_seg -range 0x00040000 -offset 0x40C00000 [get_bd_addr_spaces profinet_system/microblaze_0/Data] [get_bd_addr_segs profinet_system/sect_profinet/axi_ethernet_0/s_axi/Reg0] SEG_axi_ethernet_0_Reg0
  create_bd_addr_seg -range 0x80000000 -offset 0x80000000 [get_bd_addr_spaces profinet_system/microblaze_0/Data] [get_bd_addr_segs host_system/axi_pcie_0/S_AXI/BAR0] SEG_axi_pcie_0_BAR0
  create_bd_addr_seg -range 0x80000000 -offset 0x80000000 [get_bd_addr_spaces profinet_system/microblaze_0/Instruction] [get_bd_addr_segs host_system/axi_pcie_0/S_AXI/BAR0] SEG_axi_pcie_0_BAR0
  create_bd_addr_seg -range 0x00010000 -offset 0x41C00000 [get_bd_addr_spaces profinet_system/microblaze_0/Data] [get_bd_addr_segs profinet_system/axi_timer_0/S_AXI/Reg] SEG_axi_timer_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41C10000 [get_bd_addr_spaces profinet_system/microblaze_0/Data] [get_bd_addr_segs profinet_system/axi_timer_1/S_AXI/Reg] SEG_axi_timer_1_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40600000 [get_bd_addr_spaces profinet_system/microblaze_0/Data] [get_bd_addr_segs profinet_system/axi_uartlite_0/S_AXI/Reg] SEG_axi_uartlite_0_Reg
  create_bd_addr_seg -range 0x00002000 -offset 0x00000000 [get_bd_addr_spaces profinet_system/microblaze_0/Data] [get_bd_addr_segs profinet_system/microblaze_0_local_memory/dlmb_bram_if_cntlr/SLMB/Mem] SEG_dlmb_bram_if_cntlr_Mem
  create_bd_addr_seg -range 0x00002000 -offset 0x00000000 [get_bd_addr_spaces profinet_system/microblaze_0/Instruction] [get_bd_addr_segs profinet_system/microblaze_0_local_memory/ilmb_bram_if_cntlr/SLMB/Mem] SEG_ilmb_bram_if_cntlr_Mem
  create_bd_addr_seg -range 0x00001000 -offset 0x41400000 [get_bd_addr_spaces profinet_system/microblaze_0/Data] [get_bd_addr_segs profinet_system/mdm_1/S_AXI/Reg] SEG_mdm_1_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41200000 [get_bd_addr_spaces profinet_system/microblaze_0/Data] [get_bd_addr_segs profinet_system/microblaze_0_axi_intc/S_AXI/Reg] SEG_microblaze_0_axi_intc_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x44A00000 [get_bd_addr_spaces profinet_system/microblaze_0/Data] [get_bd_addr_segs profinet_system/rpc2_ctrl_controller_0/AXIr/reg0] SEG_rpc2_ctrl_controller_0_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x44A00000 [get_bd_addr_spaces profinet_system/microblaze_0/Instruction] [get_bd_addr_segs profinet_system/rpc2_ctrl_controller_0/AXIr/reg0] SEG_rpc2_ctrl_controller_0_reg0
  create_bd_addr_seg -range 0x00100000 -offset 0x44B00000 [get_bd_addr_spaces profinet_system/microblaze_0/Data] [get_bd_addr_segs profinet_system/rpc2_ctrl_controller_0/AXIm/reg0] SEG_rpc2_ctrl_controller_0_reg01
  create_bd_addr_seg -range 0x00100000 -offset 0x44B00000 [get_bd_addr_spaces profinet_system/microblaze_0/Instruction] [get_bd_addr_segs profinet_system/rpc2_ctrl_controller_0/AXIm/reg0] SEG_rpc2_ctrl_controller_0_reg03
  create_bd_addr_seg -range 0x80000000 -offset 0x80000000 [get_bd_addr_spaces profinet_system/sect_profinet/axi_dma_0/Data_SG] [get_bd_addr_segs host_system/axi_pcie_0/S_AXI/BAR0] SEG_axi_pcie_0_BAR0
  create_bd_addr_seg -range 0x80000000 -offset 0x80000000 [get_bd_addr_spaces profinet_system/sect_profinet/axi_dma_0/Data_MM2S] [get_bd_addr_segs host_system/axi_pcie_0/S_AXI/BAR0] SEG_axi_pcie_0_BAR0
  create_bd_addr_seg -range 0x80000000 -offset 0x80000000 [get_bd_addr_spaces profinet_system/sect_profinet/axi_dma_0/Data_S2MM] [get_bd_addr_segs host_system/axi_pcie_0/S_AXI/BAR0] SEG_axi_pcie_0_BAR0

  # Exclude Address Segments
  create_bd_addr_seg -range 0x00010000 -offset 0x44A00000 [get_bd_addr_spaces profinet_system/sect_profinet/axi_dma_0/Data_MM2S] [get_bd_addr_segs profinet_system/rpc2_ctrl_controller_0/AXIr/reg0] SEG_rpc2_ctrl_controller_0_reg0
  exclude_bd_addr_seg [get_bd_addr_segs profinet_system/sect_profinet/axi_dma_0/Data_MM2S/SEG_rpc2_ctrl_controller_0_reg0]

  create_bd_addr_seg -range 0x00100000 -offset 0x44B00000 [get_bd_addr_spaces profinet_system/sect_profinet/axi_dma_0/Data_MM2S] [get_bd_addr_segs profinet_system/rpc2_ctrl_controller_0/AXIm/reg0] SEG_rpc2_ctrl_controller_0_reg05
  exclude_bd_addr_seg [get_bd_addr_segs profinet_system/sect_profinet/axi_dma_0/Data_MM2S/SEG_rpc2_ctrl_controller_0_reg05]

  create_bd_addr_seg -range 0x00010000 -offset 0x44A00000 [get_bd_addr_spaces profinet_system/sect_profinet/axi_dma_0/Data_S2MM] [get_bd_addr_segs profinet_system/rpc2_ctrl_controller_0/AXIr/reg0] SEG_rpc2_ctrl_controller_0_reg0
  exclude_bd_addr_seg [get_bd_addr_segs profinet_system/sect_profinet/axi_dma_0/Data_S2MM/SEG_rpc2_ctrl_controller_0_reg0]

  create_bd_addr_seg -range 0x00100000 -offset 0x44B00000 [get_bd_addr_spaces profinet_system/sect_profinet/axi_dma_0/Data_S2MM] [get_bd_addr_segs profinet_system/rpc2_ctrl_controller_0/AXIm/reg0] SEG_rpc2_ctrl_controller_0_reg07
  exclude_bd_addr_seg [get_bd_addr_segs profinet_system/sect_profinet/axi_dma_0/Data_S2MM/SEG_rpc2_ctrl_controller_0_reg07]

  create_bd_addr_seg -range 0x00010000 -offset 0x44A00000 [get_bd_addr_spaces profinet_system/sect_profinet/axi_dma_0/Data_SG] [get_bd_addr_segs profinet_system/rpc2_ctrl_controller_0/AXIr/reg0] SEG_rpc2_ctrl_controller_0_reg0
  exclude_bd_addr_seg [get_bd_addr_segs profinet_system/sect_profinet/axi_dma_0/Data_SG/SEG_rpc2_ctrl_controller_0_reg0]

  create_bd_addr_seg -range 0x00100000 -offset 0x44B00000 [get_bd_addr_spaces profinet_system/sect_profinet/axi_dma_0/Data_SG] [get_bd_addr_segs profinet_system/rpc2_ctrl_controller_0/AXIm/reg0] SEG_rpc2_ctrl_controller_0_reg09
  exclude_bd_addr_seg [get_bd_addr_segs profinet_system/sect_profinet/axi_dma_0/Data_SG/SEG_rpc2_ctrl_controller_0_reg09]



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


