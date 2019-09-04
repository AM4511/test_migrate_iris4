
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
   create_project project_1 myproj -part xc7z015clg485-1
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
matrox.com:Imaging:axiMaio:1.6\
matrox.com:user:mtxLPCUarts:1.0\
matrox.com:Imaging:pcie2AxiMaster:1.0\
xilinx.com:ip:mii_to_rmii:2.0\
xilinx.com:ip:xadc_wiz:3.3\
xilinx.com:ip:processing_system7:5.5\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:util_reduced_logic:2.0\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:axi_ethernetlite:3.0\
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


# Hierarchical cell: ncsi3
proc create_hier_cell_ncsi3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_ncsi3() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_0

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:rmii_rtl:1.0 ncsi


  # Create pins
  create_bd_pin -dir I -type clk axi_clk100MHz
  create_bd_pin -dir I axi_reset_n
  create_bd_pin -dir I -type clk ncsi_clk50MHz
  create_bd_pin -dir O -type intr ncsi_irq
  create_bd_pin -dir I -type rst ncsi_rst_n

  # Create instance: axi_ethernetlite_0, and set properties
  set axi_ethernetlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernetlite:3.0 axi_ethernetlite_0 ]
  set_property -dict [ list \
   CONFIG.C_INCLUDE_GLOBAL_BUFFERS {0} \
   CONFIG.C_INCLUDE_INTERNAL_LOOPBACK {1} \
   CONFIG.C_INCLUDE_MDIO {0} \
 ] $axi_ethernetlite_0

  # Create instance: mii_to_rmii_0, and set properties
  set mii_to_rmii_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mii_to_rmii:2.0 mii_to_rmii_0 ]
  set_property -dict [ list \
   CONFIG.C_INCLUDE_BUF {0} \
 ] $mii_to_rmii_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins ncsi] [get_bd_intf_pins mii_to_rmii_0/RMII_PHY_M]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI_0] [get_bd_intf_pins axi_ethernetlite_0/S_AXI]
  connect_bd_intf_net -intf_net axi_ethernetlite_0_MII [get_bd_intf_pins axi_ethernetlite_0/MII] [get_bd_intf_pins mii_to_rmii_0/MII]

  # Create port connections
  connect_bd_net -net Net [get_bd_pins axi_reset_n] [get_bd_pins axi_ethernetlite_0/s_axi_aresetn]
  connect_bd_net -net axi_ethernetlite_0_ip2intc_irpt [get_bd_pins ncsi_irq] [get_bd_pins axi_ethernetlite_0/ip2intc_irpt]
  connect_bd_net -net ncsi_rst_n_1 [get_bd_pins ncsi_rst_n] [get_bd_pins mii_to_rmii_0/rst_n]
  connect_bd_net -net ref_clk_0_1 [get_bd_pins ncsi_clk50MHz] [get_bd_pins mii_to_rmii_0/ref_clk]
  connect_bd_net -net s_axi_aclk_0_1 [get_bd_pins axi_clk100MHz] [get_bd_pins axi_ethernetlite_0/s_axi_aclk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: ncsi2
proc create_hier_cell_ncsi2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_ncsi2() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_0

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:rmii_rtl:1.0 ncsi


  # Create pins
  create_bd_pin -dir I -type clk axi_clk100MHz
  create_bd_pin -dir I axi_reset_n
  create_bd_pin -dir I -type clk ncsi_clk50MHz
  create_bd_pin -dir O -type intr ncsi_irq
  create_bd_pin -dir I -type rst ncsi_rst_n

  # Create instance: axi_ethernetlite_0, and set properties
  set axi_ethernetlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernetlite:3.0 axi_ethernetlite_0 ]
  set_property -dict [ list \
   CONFIG.C_INCLUDE_GLOBAL_BUFFERS {0} \
   CONFIG.C_INCLUDE_INTERNAL_LOOPBACK {1} \
   CONFIG.C_INCLUDE_MDIO {0} \
 ] $axi_ethernetlite_0

  # Create instance: mii_to_rmii_0, and set properties
  set mii_to_rmii_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mii_to_rmii:2.0 mii_to_rmii_0 ]
  set_property -dict [ list \
   CONFIG.C_INCLUDE_BUF {0} \
 ] $mii_to_rmii_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins ncsi] [get_bd_intf_pins mii_to_rmii_0/RMII_PHY_M]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI_0] [get_bd_intf_pins axi_ethernetlite_0/S_AXI]
  connect_bd_intf_net -intf_net axi_ethernetlite_0_MII [get_bd_intf_pins axi_ethernetlite_0/MII] [get_bd_intf_pins mii_to_rmii_0/MII]

  # Create port connections
  connect_bd_net -net Net [get_bd_pins axi_reset_n] [get_bd_pins axi_ethernetlite_0/s_axi_aresetn]
  connect_bd_net -net axi_ethernetlite_0_ip2intc_irpt [get_bd_pins ncsi_irq] [get_bd_pins axi_ethernetlite_0/ip2intc_irpt]
  connect_bd_net -net ncsi_rst_n_1 [get_bd_pins ncsi_rst_n] [get_bd_pins mii_to_rmii_0/rst_n]
  connect_bd_net -net ref_clk_0_1 [get_bd_pins ncsi_clk50MHz] [get_bd_pins mii_to_rmii_0/ref_clk]
  connect_bd_net -net s_axi_aclk_0_1 [get_bd_pins axi_clk100MHz] [get_bd_pins axi_ethernetlite_0/s_axi_aclk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: ncsi1
proc create_hier_cell_ncsi1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_ncsi1() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_0

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:rmii_rtl:1.0 ncsi


  # Create pins
  create_bd_pin -dir I -type clk axi_clk100MHz
  create_bd_pin -dir I axi_reset_n
  create_bd_pin -dir I -type clk ncsi_clk50MHz
  create_bd_pin -dir O -type intr ncsi_irq
  create_bd_pin -dir I -type rst ncsi_rst_n

  # Create instance: axi_ethernetlite_0, and set properties
  set axi_ethernetlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernetlite:3.0 axi_ethernetlite_0 ]
  set_property -dict [ list \
   CONFIG.C_INCLUDE_GLOBAL_BUFFERS {0} \
   CONFIG.C_INCLUDE_INTERNAL_LOOPBACK {1} \
   CONFIG.C_INCLUDE_MDIO {0} \
 ] $axi_ethernetlite_0

  # Create instance: mii_to_rmii_0, and set properties
  set mii_to_rmii_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mii_to_rmii:2.0 mii_to_rmii_0 ]
  set_property -dict [ list \
   CONFIG.C_INCLUDE_BUF {0} \
 ] $mii_to_rmii_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins ncsi] [get_bd_intf_pins mii_to_rmii_0/RMII_PHY_M]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI_0] [get_bd_intf_pins axi_ethernetlite_0/S_AXI]
  connect_bd_intf_net -intf_net axi_ethernetlite_0_MII [get_bd_intf_pins axi_ethernetlite_0/MII] [get_bd_intf_pins mii_to_rmii_0/MII]

  # Create port connections
  connect_bd_net -net Net [get_bd_pins axi_reset_n] [get_bd_pins axi_ethernetlite_0/s_axi_aresetn]
  connect_bd_net -net axi_ethernetlite_0_ip2intc_irpt [get_bd_pins ncsi_irq] [get_bd_pins axi_ethernetlite_0/ip2intc_irpt]
  connect_bd_net -net ncsi_rst_n_1 [get_bd_pins ncsi_rst_n] [get_bd_pins mii_to_rmii_0/rst_n]
  connect_bd_net -net ref_clk_0_1 [get_bd_pins ncsi_clk50MHz] [get_bd_pins mii_to_rmii_0/ref_clk]
  connect_bd_net -net s_axi_aclk_0_1 [get_bd_pins axi_clk100MHz] [get_bd_pins axi_ethernetlite_0/s_axi_aclk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: ncsi0
proc create_hier_cell_ncsi0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_ncsi0() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:rmii_rtl:1.0 ncsi

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_ncsi_1


  # Create pins
  create_bd_pin -dir I -type clk axi_clk100MHz
  create_bd_pin -dir I axi_reset_n
  create_bd_pin -dir I -type clk ncsi_clk50MHz
  create_bd_pin -dir O -type intr ncsi_irq
  create_bd_pin -dir I -type rst ncsi_rst_n

  # Create instance: axi_ethernetlite_0, and set properties
  set axi_ethernetlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernetlite:3.0 axi_ethernetlite_0 ]
  set_property -dict [ list \
   CONFIG.C_INCLUDE_GLOBAL_BUFFERS {0} \
   CONFIG.C_INCLUDE_INTERNAL_LOOPBACK {1} \
   CONFIG.C_INCLUDE_MDIO {0} \
 ] $axi_ethernetlite_0

  # Create instance: mii_to_rmii_0, and set properties
  set mii_to_rmii_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mii_to_rmii:2.0 mii_to_rmii_0 ]
  set_property -dict [ list \
   CONFIG.C_INCLUDE_BUF {0} \
 ] $mii_to_rmii_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins ncsi] [get_bd_intf_pins mii_to_rmii_0/RMII_PHY_M]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins s_axi_ncsi_1] [get_bd_intf_pins axi_ethernetlite_0/S_AXI]
  connect_bd_intf_net -intf_net axi_ethernetlite_0_MII [get_bd_intf_pins axi_ethernetlite_0/MII] [get_bd_intf_pins mii_to_rmii_0/MII]

  # Create port connections
  connect_bd_net -net Net [get_bd_pins axi_reset_n] [get_bd_pins axi_ethernetlite_0/s_axi_aresetn]
  connect_bd_net -net axi_ethernetlite_0_ip2intc_irpt [get_bd_pins ncsi_irq] [get_bd_pins axi_ethernetlite_0/ip2intc_irpt]
  connect_bd_net -net ncsi_rst_n_1 [get_bd_pins ncsi_rst_n] [get_bd_pins mii_to_rmii_0/rst_n]
  connect_bd_net -net ref_clk_0_1 [get_bd_pins ncsi_clk50MHz] [get_bd_pins mii_to_rmii_0/ref_clk]
  connect_bd_net -net s_axi_aclk_0_1 [get_bd_pins axi_clk100MHz] [get_bd_pins axi_ethernetlite_0/s_axi_aclk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: ncsi_system
proc create_hier_cell_ncsi_system { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_ncsi_system() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:rmii_rtl:1.0 ncsi_0

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:rmii_rtl:1.0 ncsi_1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:rmii_rtl:1.0 ncsi_2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:rmii_rtl:1.0 ncsi_3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_ncsi_0

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_ncsi_1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_ncsi_2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_ncsi_3


  # Create pins
  create_bd_pin -dir I axi_clk_100MHz
  create_bd_pin -dir I axi_reset_n
  create_bd_pin -dir I -type clk ncsi_clk50MHz
  create_bd_pin -dir I -type rst ncsi_rst_n

  # Create instance: ncsi0
  create_hier_cell_ncsi0 $hier_obj ncsi0

  # Create instance: ncsi1
  create_hier_cell_ncsi1 $hier_obj ncsi1

  # Create instance: ncsi2
  create_hier_cell_ncsi2 $hier_obj ncsi2

  # Create instance: ncsi3
  create_hier_cell_ncsi3 $hier_obj ncsi3

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_axi_ncsi_0] [get_bd_intf_pins ncsi0/s_axi_ncsi_1]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins s_axi_ncsi_1] [get_bd_intf_pins ncsi1/S_AXI_0]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins s_axi_ncsi_2] [get_bd_intf_pins ncsi2/S_AXI_0]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins s_axi_ncsi_3] [get_bd_intf_pins ncsi3/S_AXI_0]
  connect_bd_intf_net -intf_net Conn7 [get_bd_intf_pins ncsi_0] [get_bd_intf_pins ncsi0/ncsi]
  connect_bd_intf_net -intf_net ncsi1_ncsi [get_bd_intf_pins ncsi_1] [get_bd_intf_pins ncsi1/ncsi]
  connect_bd_intf_net -intf_net ncsi2_ncsi [get_bd_intf_pins ncsi_2] [get_bd_intf_pins ncsi2/ncsi]
  connect_bd_intf_net -intf_net ncsi3_ncsi [get_bd_intf_pins ncsi_3] [get_bd_intf_pins ncsi3/ncsi]

  # Create port connections
  connect_bd_net -net axi_clk_100MHz_1 [get_bd_pins axi_clk_100MHz] [get_bd_pins ncsi0/axi_clk100MHz] [get_bd_pins ncsi1/axi_clk100MHz] [get_bd_pins ncsi2/axi_clk100MHz] [get_bd_pins ncsi3/axi_clk100MHz]
  connect_bd_net -net axi_reset_n_1 [get_bd_pins axi_reset_n] [get_bd_pins ncsi0/axi_reset_n] [get_bd_pins ncsi1/axi_reset_n] [get_bd_pins ncsi2/axi_reset_n] [get_bd_pins ncsi3/axi_reset_n]
  connect_bd_net -net ncsi_clk50MHz_1 [get_bd_pins ncsi_clk50MHz] [get_bd_pins ncsi0/ncsi_clk50MHz] [get_bd_pins ncsi1/ncsi_clk50MHz] [get_bd_pins ncsi2/ncsi_clk50MHz] [get_bd_pins ncsi3/ncsi_clk50MHz]
  connect_bd_net -net ncsi_rst_n_1 [get_bd_pins ncsi_rst_n] [get_bd_pins ncsi0/ncsi_rst_n] [get_bd_pins ncsi1/ncsi_rst_n] [get_bd_pins ncsi2/ncsi_rst_n] [get_bd_pins ncsi3/ncsi_rst_n]

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
  create_bd_pin -dir O -from 63 -to 0 irq_event
  create_bd_pin -dir I -from 0 -to 0 irq_io
  create_bd_pin -dir I -from 1 -to 0 irq_tick
  create_bd_pin -dir I -from 1 -to 0 irq_tick_latch
  create_bd_pin -dir I -from 1 -to 0 irq_tick_wa
  create_bd_pin -dir I -from 15 -to 0 irq_timer_start
  create_bd_pin -dir I -from 15 -to 0 irq_timer_stop

  # Create instance: util_reduced_logic_0, and set properties
  set util_reduced_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {32} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_reduced_logic_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN10_WIDTH {1} \
   CONFIG.IN1_WIDTH {2} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.IN3_WIDTH {2} \
   CONFIG.IN4_WIDTH {1} \
   CONFIG.IN5_WIDTH {2} \
   CONFIG.IN6_WIDTH {23} \
   CONFIG.IN7_WIDTH {16} \
   CONFIG.IN8_WIDTH {16} \
   CONFIG.IN9_WIDTH {1} \
   CONFIG.NUM_PORTS {9} \
 ] $xlconcat_0

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {16} \
   CONFIG.IN1_WIDTH {16} \
 ] $xlconcat_1

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {23} \
 ] $xlconstant_1

  # Create port connections
  connect_bd_net -net axiMaio_0_irq_event_io [get_bd_pins irq_io] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net axiMaio_0_irq_event_tick [get_bd_pins irq_tick] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net axiMaio_0_irq_event_tick_stamp_latched [get_bd_pins irq_tick_latch] [get_bd_pins xlconcat_0/In5]
  connect_bd_net -net axiMaio_0_irq_event_tick_wrap [get_bd_pins irq_tick_wa] [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net axiMaio_0_irq_event_timer_end [get_bd_pins irq_timer_stop] [get_bd_pins xlconcat_0/In8] [get_bd_pins xlconcat_1/In1]
  connect_bd_net -net axiMaio_0_irq_event_timer_start [get_bd_pins irq_timer_start] [get_bd_pins xlconcat_0/In7] [get_bd_pins xlconcat_1/In0]
  connect_bd_net -net util_reduced_logic_0_Res [get_bd_pins util_reduced_logic_0/Res] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins irq_event] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins util_reduced_logic_0/Op1] [get_bd_pins xlconcat_1/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconcat_0/In4] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins xlconcat_0/In6] [get_bd_pins xlconstant_1/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: clk_reset_mngr
proc create_hier_cell_clk_reset_mngr { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_clk_reset_mngr() - Empty argument(s)!"}
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
  create_bd_pin -dir O axi_clk_100MHz
  create_bd_pin -dir O -from 0 -to 0 -type rst axi_reset_n
  create_bd_pin -dir I -type rst ext_reset_n
  create_bd_pin -dir O -type clk ncsi_clk50MHz
  create_bd_pin -dir O -type clk ncsi_clk50MHz_io
  create_bd_pin -dir O -from 0 -to 0 -type rst ncsi_reset_n
  create_bd_pin -dir O -type clk profinet1_clk_50MHz
  create_bd_pin -dir O -from 0 -to 0 -type rst profinet1_reset_n
  create_bd_pin -dir I -type clk ref_clk_100MHz

  # Create instance: axi_reset_mngr, and set properties
  set axi_reset_mngr [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 axi_reset_mngr ]
  set_property -dict [ list \
   CONFIG.C_NUM_PERP_RST {1} \
 ] $axi_reset_mngr

  # Create instance: eth_pll, and set properties
  set eth_pll [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 eth_pll ]
  set_property -dict [ list \
   CONFIG.AXI_DRP {false} \
   CONFIG.CLKOUT1_DRIVES {BUFGCE} \
   CONFIG.CLKOUT1_JITTER {159.475} \
   CONFIG.CLKOUT1_PHASE_ERROR {105.461} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {50.000} \
   CONFIG.CLKOUT1_REQUESTED_PHASE {0} \
   CONFIG.CLKOUT2_DRIVES {BUFGCE} \
   CONFIG.CLKOUT2_JITTER {159.475} \
   CONFIG.CLKOUT2_PHASE_ERROR {105.461} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {50.000} \
   CONFIG.CLKOUT2_REQUESTED_PHASE {-40} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLKOUT3_DRIVES {BUFGCE} \
   CONFIG.CLKOUT3_JITTER {159.475} \
   CONFIG.CLKOUT3_PHASE_ERROR {105.461} \
   CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {50.000} \
   CONFIG.CLKOUT3_REQUESTED_PHASE {42} \
   CONFIG.CLKOUT3_USED {true} \
   CONFIG.CLKOUT4_DRIVES {BUFGCE} \
   CONFIG.CLKOUT4_JITTER {159.475} \
   CONFIG.CLKOUT4_PHASE_ERROR {105.461} \
   CONFIG.CLKOUT4_REQUESTED_OUT_FREQ {100.000} \
   CONFIG.CLKOUT4_USED {false} \
   CONFIG.CLKOUT5_DRIVES {BUFGCE} \
   CONFIG.CLKOUT5_REQUESTED_OUT_FREQ {100.000} \
   CONFIG.CLKOUT6_DRIVES {BUFGCE} \
   CONFIG.CLKOUT6_REQUESTED_OUT_FREQ {100.000} \
   CONFIG.CLKOUT7_DRIVES {BUFGCE} \
   CONFIG.CLKOUT7_REQUESTED_OUT_FREQ {100.000} \
   CONFIG.CLK_OUT1_PORT {ncsi_clk_int} \
   CONFIG.CLK_OUT2_PORT {ncsi_clk_io} \
   CONFIG.CLK_OUT3_PORT {profinet1_clk_int} \
   CONFIG.CLK_OUT4_PORT {clk_out4} \
   CONFIG.ENABLE_CLOCK_MONITOR {false} \
   CONFIG.FEEDBACK_SOURCE {FDBK_AUTO} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {9} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.000} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {18} \
   CONFIG.MMCM_CLKOUT0_PHASE {0.000} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {18} \
   CONFIG.MMCM_CLKOUT1_PHASE {-40.000} \
   CONFIG.MMCM_CLKOUT2_DIVIDE {18} \
   CONFIG.MMCM_CLKOUT2_PHASE {42.500} \
   CONFIG.MMCM_CLKOUT3_DIVIDE {1} \
   CONFIG.MMCM_COMPENSATION {ZHOLD} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.NUM_OUT_CLKS {3} \
   CONFIG.PHASE_DUTY_CONFIG {false} \
   CONFIG.PRIMITIVE {PLL} \
   CONFIG.PRIM_SOURCE {Global_buffer} \
   CONFIG.RESET_PORT {reset} \
   CONFIG.RESET_TYPE {ACTIVE_HIGH} \
   CONFIG.USE_DYN_RECONFIG {false} \
   CONFIG.USE_FREQ_SYNTH {true} \
   CONFIG.USE_LOCKED {true} \
   CONFIG.USE_RESET {false} \
   CONFIG.USE_SAFE_CLOCK_STARTUP {true} \
 ] $eth_pll

  # Create instance: ncsi_reset_mngr, and set properties
  set ncsi_reset_mngr [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 ncsi_reset_mngr ]

  # Create instance: profinet1_reset_mngr, and set properties
  set profinet1_reset_mngr [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 profinet1_reset_mngr ]
  set_property -dict [ list \
   CONFIG.C_NUM_PERP_RST {1} \
 ] $profinet1_reset_mngr

  # Create port connections
  connect_bd_net -net Profinet_axi_clk_100MHz1 [get_bd_pins axi_clk_100MHz] [get_bd_pins ref_clk_100MHz] [get_bd_pins axi_reset_mngr/slowest_sync_clk] [get_bd_pins eth_pll/clk_in1]
  connect_bd_net -net eth_pll_locked [get_bd_pins axi_reset_mngr/dcm_locked] [get_bd_pins eth_pll/locked] [get_bd_pins ncsi_reset_mngr/dcm_locked] [get_bd_pins profinet1_reset_mngr/dcm_locked]
  connect_bd_net -net eth_pll_ncsi_clk_int [get_bd_pins ncsi_clk50MHz] [get_bd_pins eth_pll/ncsi_clk_int] [get_bd_pins ncsi_reset_mngr/slowest_sync_clk]
  connect_bd_net -net eth_pll_ncsi_clk_io [get_bd_pins ncsi_clk50MHz_io] [get_bd_pins eth_pll/ncsi_clk_io]
  connect_bd_net -net eth_pll_profinet1_clk_int [get_bd_pins profinet1_clk_50MHz] [get_bd_pins eth_pll/profinet1_clk_int] [get_bd_pins profinet1_reset_mngr/slowest_sync_clk]
  connect_bd_net -net eth_reset_mngr_peripheral_aresetn [get_bd_pins axi_reset_n] [get_bd_pins axi_reset_mngr/peripheral_aresetn]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins ncsi_reset_n] [get_bd_pins ncsi_reset_mngr/peripheral_aresetn]
  connect_bd_net -net profinet1_reset_mngr_peripheral_aresetn [get_bd_pins profinet1_reset_n] [get_bd_pins profinet1_reset_mngr/peripheral_aresetn]
  connect_bd_net -net zync_soc_FCLK_RESET0_N [get_bd_pins ext_reset_n] [get_bd_pins axi_reset_mngr/ext_reset_in] [get_bd_pins ncsi_reset_mngr/ext_reset_in] [get_bd_pins profinet1_reset_mngr/ext_reset_in]

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
  set FPGA_Info_0 [ create_bd_intf_port -mode Slave -vlnv matrox.com:Imaging:FPGA_Info_rtl:1.0 FPGA_Info_0 ]

  set UART_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 UART_0 ]

  set UART_1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 UART_1 ]

  set UART_DBG [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 UART_DBG ]

  set Vp_Vn_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vp_Vn_0 ]

  set ddr [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 ddr ]

  set ext_sync_0 [ create_bd_intf_port -mode Master -vlnv matrox.com:user:ext_sync_rtl:1.0 ext_sync_0 ]

  set fixed_io [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 fixed_io ]

  set lpc [ create_bd_intf_port -mode Slave -vlnv matrox.com:MatroxIP:lpc_rtl:1.0 lpc ]

  set mtxSPI_0 [ create_bd_intf_port -mode Master -vlnv matrox.com:MatroxIP:mtxSPI_rtl:1.0 mtxSPI_0 ]

  set ncsi_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rmii_rtl:1.0 ncsi_0 ]

  set ncsi_1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rmii_rtl:1.0 ncsi_1 ]

  set ncsi_2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rmii_rtl:1.0 ncsi_2 ]

  set ncsi_3 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rmii_rtl:1.0 ncsi_3 ]

  set ncsi_4 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rmii_rtl:1.0 ncsi_4 ]

  set ncsi_5 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rmii_rtl:1.0 ncsi_5 ]

  set pcie [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie ]


  # Create ports
  set PCIE_REFCLK_100MHz [ create_bd_port -dir I -type clk PCIE_REFCLK_100MHz ]
  set PCIE_RESET_N [ create_bd_port -dir I -type rst PCIE_RESET_N ]
  set debug_in [ create_bd_port -dir I -from 31 -to 0 debug_in ]
  set debug_out [ create_bd_port -dir O -from 31 -to 0 debug_out ]
  set ncsi_clk_out [ create_bd_port -dir O -type clk ncsi_clk_out ]
  set transmission_active_0 [ create_bd_port -dir O transmission_active_0 ]
  set transmission_active_1 [ create_bd_port -dir O transmission_active_1 ]
  set user_data_in [ create_bd_port -dir I -from 7 -to 0 user_data_in ]
  set user_data_out [ create_bd_port -dir O -from 7 -to 0 user_data_out ]

  # Create instance: axiMaio_0, and set properties
  set axiMaio_0 [ create_bd_cell -type ip -vlnv matrox.com:Imaging:axiMaio:1.6 axiMaio_0 ]
  set_property -dict [ list \
   CONFIG.NUM_TOE_CONTROLLER {0} \
   CONFIG.NUM_USER_INPUT {8} \
   CONFIG.NUM_USER_OUTPUT {8} \
 ] $axiMaio_0

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {7} \
 ] $axi_interconnect_0

  # Create instance: clk_reset_mngr
  create_hier_cell_clk_reset_mngr [current_bd_instance .] clk_reset_mngr

  # Create instance: interrupt_mapping
  create_hier_cell_interrupt_mapping [current_bd_instance .] interrupt_mapping

  # Create instance: mtxLPCUarts_0, and set properties
  set mtxLPCUarts_0 [ create_bd_cell -type ip -vlnv matrox.com:user:mtxLPCUarts:1.0 mtxLPCUarts_0 ]
  set_property -dict [ list \
   CONFIG.NUMB_UART {2} \
 ] $mtxLPCUarts_0

  # Create instance: ncsi_system
  create_hier_cell_ncsi_system [current_bd_instance .] ncsi_system

  # Create instance: pcie2AxiMaster_0, and set properties
  set pcie2AxiMaster_0 [ create_bd_cell -type ip -vlnv matrox.com:Imaging:pcie2AxiMaster:1.0 pcie2AxiMaster_0 ]
  set_property -dict [ list \
   CONFIG.DEBUG_IN_WIDTH {32} \
   CONFIG.DEBUG_OUT_WIDTH {32} \
   CONFIG.NUMB_IRQ {64} \
   CONFIG.PCIE_DEVICE_ID {18056} \
   CONFIG.PCIE_REV_ID {1} \
   CONFIG.PCIE_SUBSYS_ID {1024} \
 ] $pcie2AxiMaster_0

  # Create instance: profinet1_mii_to_rmii, and set properties
  set profinet1_mii_to_rmii [ create_bd_cell -type ip -vlnv xilinx.com:ip:mii_to_rmii:2.0 profinet1_mii_to_rmii ]
  set_property -dict [ list \
   CONFIG.C_FIXED_SPEED {1} \
   CONFIG.C_MODE {1} \
   CONFIG.C_SPEED_100 {1} \
 ] $profinet1_mii_to_rmii

  # Create instance: profinet2_mii_to_rmii, and set properties
  set profinet2_mii_to_rmii [ create_bd_cell -type ip -vlnv xilinx.com:ip:mii_to_rmii:2.0 profinet2_mii_to_rmii ]
  set_property -dict [ list \
   CONFIG.C_FIXED_SPEED {1} \
   CONFIG.C_MODE {1} \
   CONFIG.C_SPEED_100 {1} \
 ] $profinet2_mii_to_rmii

  # Create instance: xadc, and set properties
  set xadc [ create_bd_cell -type ip -vlnv xilinx.com:ip:xadc_wiz:3.3 xadc ]
  set_property -dict [ list \
   CONFIG.ADC_OFFSET_AND_GAIN_CALIBRATION {true} \
   CONFIG.ADC_OFFSET_CALIBRATION {false} \
   CONFIG.CHANNEL_AVERAGING {16} \
   CONFIG.CHANNEL_ENABLE_VP_VN {false} \
   CONFIG.ENABLE_AXI4STREAM {false} \
   CONFIG.ENABLE_CALIBRATION_AVERAGING {true} \
   CONFIG.ENABLE_EXTERNAL_MUX {false} \
   CONFIG.ENABLE_RESET {false} \
   CONFIG.ENABLE_TEMP_BUS {false} \
   CONFIG.ENABLE_VCCDDRO_ALARM {false} \
   CONFIG.ENABLE_VCCPAUX_ALARM {false} \
   CONFIG.ENABLE_VCCPINT_ALARM {false} \
   CONFIG.EXTERNAL_MUX_CHANNEL {VP_VN} \
   CONFIG.INTERFACE_SELECTION {Enable_AXI} \
   CONFIG.OT_ALARM {false} \
   CONFIG.SEQUENCER_MODE {Off} \
   CONFIG.SINGLE_CHANNEL_SELECTION {TEMPERATURE} \
   CONFIG.TIMING_MODE {Continuous} \
   CONFIG.USER_TEMP_ALARM {false} \
   CONFIG.VCCAUX_ALARM {false} \
   CONFIG.VCCINT_ALARM {false} \
   CONFIG.XADC_STARUP_SELECTION {single_channel} \
 ] $xadc

  # Create instance: zync_soc, and set properties
  set zync_soc [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 zync_soc ]
  set_property -dict [ list \
   CONFIG.PCW_ACT_APU_PERIPHERAL_FREQMHZ {600.000000} \
   CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.169492} \
   CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {125.000000} \
   CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {125.000000} \
   CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_TTC0_CLK0_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_TTC0_CLK1_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_TTC0_CLK2_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_TTC1_CLK0_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_TTC1_CLK1_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_TTC1_CLK2_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_WDT_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {600} \
   CONFIG.PCW_ARMPLL_CTRL_FBDIV {24} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_CLK0_FREQ {100000000} \
   CONFIG.PCW_CLK1_FREQ {10000000} \
   CONFIG.PCW_CLK2_FREQ {10000000} \
   CONFIG.PCW_CLK3_FREQ {10000000} \
   CONFIG.PCW_CPU_CPU_PLL_FREQMHZ {1200.000} \
   CONFIG.PCW_CPU_PERIPHERAL_CLKSRC {ARM PLL} \
   CONFIG.PCW_CPU_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_CRYSTAL_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR0 {59} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR1 {2} \
   CONFIG.PCW_DDRPLL_CTRL_FBDIV {24} \
   CONFIG.PCW_DDR_DDR_PLL_FREQMHZ {1200.000} \
   CONFIG.PCW_DDR_PERIPHERAL_DIVISOR0 {4} \
   CONFIG.PCW_DDR_RAM_HIGHADDR {0x07FFFFFF} \
   CONFIG.PCW_ENET0_ENET0_IO {EMIO} \
   CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {0} \
   CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC {External} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {1000 Mbps} \
   CONFIG.PCW_ENET0_RESET_ENABLE {0} \
   CONFIG.PCW_ENET1_ENET1_IO {EMIO} \
   CONFIG.PCW_ENET1_GRP_MDIO_ENABLE {0} \
   CONFIG.PCW_ENET1_PERIPHERAL_CLKSRC {External} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_FREQMHZ {1000 Mbps} \
   CONFIG.PCW_ENET1_RESET_ENABLE {0} \
   CONFIG.PCW_ENET_RESET_ENABLE {0} \
   CONFIG.PCW_ENET_RESET_SELECT {<Select>} \
   CONFIG.PCW_EN_CLK0_PORT {1} \
   CONFIG.PCW_EN_CLK1_PORT {0} \
   CONFIG.PCW_EN_CLK2_PORT {0} \
   CONFIG.PCW_EN_CLK3_PORT {0} \
   CONFIG.PCW_EN_DDR {1} \
   CONFIG.PCW_EN_EMIO_ENET0 {1} \
   CONFIG.PCW_EN_EMIO_ENET1 {1} \
   CONFIG.PCW_EN_EMIO_GPIO {0} \
   CONFIG.PCW_EN_EMIO_MODEM_UART0 {1} \
   CONFIG.PCW_EN_EMIO_TTC0 {0} \
   CONFIG.PCW_EN_EMIO_TTC1 {0} \
   CONFIG.PCW_EN_EMIO_UART0 {1} \
   CONFIG.PCW_EN_EMIO_WDT {0} \
   CONFIG.PCW_EN_ENET0 {1} \
   CONFIG.PCW_EN_ENET1 {1} \
   CONFIG.PCW_EN_GPIO {0} \
   CONFIG.PCW_EN_MODEM_UART0 {1} \
   CONFIG.PCW_EN_QSPI {1} \
   CONFIG.PCW_EN_RST1_PORT {0} \
   CONFIG.PCW_EN_RST2_PORT {0} \
   CONFIG.PCW_EN_RST3_PORT {0} \
   CONFIG.PCW_EN_TTC0 {0} \
   CONFIG.PCW_EN_TTC1 {0} \
   CONFIG.PCW_EN_UART0 {1} \
   CONFIG.PCW_EN_UART1 {0} \
   CONFIG.PCW_EN_WDT {0} \
   CONFIG.PCW_FCLK0_PERIPHERAL_CLKSRC {ARM PLL} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR0 {4} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR1 {3} \
   CONFIG.PCW_FCLK1_PERIPHERAL_CLKSRC {ARM PLL} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK2_PERIPHERAL_CLKSRC {ARM PLL} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK_CLK0_BUF {TRUE} \
   CONFIG.PCW_FCLK_CLK1_BUF {FALSE} \
   CONFIG.PCW_FCLK_CLK2_BUF {FALSE} \
   CONFIG.PCW_FCLK_CLK3_BUF {FALSE} \
   CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {125} \
   CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK1_ENABLE {0} \
   CONFIG.PCW_FPGA_FCLK2_ENABLE {0} \
   CONFIG.PCW_FPGA_FCLK3_ENABLE {0} \
   CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {0} \
   CONFIG.PCW_GPIO_EMIO_GPIO_IO {<Select>} \
   CONFIG.PCW_GPIO_EMIO_GPIO_WIDTH {64} \
   CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {0} \
   CONFIG.PCW_GPIO_MIO_GPIO_IO {<Select>} \
   CONFIG.PCW_I2C0_RESET_ENABLE {0} \
   CONFIG.PCW_I2C1_RESET_ENABLE {0} \
   CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ {25} \
   CONFIG.PCW_I2C_RESET_ENABLE {0} \
   CONFIG.PCW_IOPLL_CTRL_FBDIV {32} \
   CONFIG.PCW_IO_IO_PLL_FREQMHZ {1600.000} \
   CONFIG.PCW_IRQ_F2P_INTR {1} \
   CONFIG.PCW_MIO_0_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_0_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_0_PULLUP {<Select>} \
   CONFIG.PCW_MIO_0_SLEW {<Select>} \
   CONFIG.PCW_MIO_10_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_10_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_10_PULLUP {<Select>} \
   CONFIG.PCW_MIO_10_SLEW {<Select>} \
   CONFIG.PCW_MIO_11_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_11_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_11_PULLUP {<Select>} \
   CONFIG.PCW_MIO_11_SLEW {<Select>} \
   CONFIG.PCW_MIO_12_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_12_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_12_PULLUP {<Select>} \
   CONFIG.PCW_MIO_12_SLEW {<Select>} \
   CONFIG.PCW_MIO_13_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_13_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_13_PULLUP {<Select>} \
   CONFIG.PCW_MIO_13_SLEW {<Select>} \
   CONFIG.PCW_MIO_14_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_14_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_14_PULLUP {<Select>} \
   CONFIG.PCW_MIO_14_SLEW {<Select>} \
   CONFIG.PCW_MIO_15_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_15_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_15_PULLUP {<Select>} \
   CONFIG.PCW_MIO_15_SLEW {<Select>} \
   CONFIG.PCW_MIO_16_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_16_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_16_PULLUP {<Select>} \
   CONFIG.PCW_MIO_16_SLEW {<Select>} \
   CONFIG.PCW_MIO_17_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_17_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_17_PULLUP {<Select>} \
   CONFIG.PCW_MIO_17_SLEW {<Select>} \
   CONFIG.PCW_MIO_18_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_18_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_18_PULLUP {<Select>} \
   CONFIG.PCW_MIO_18_SLEW {<Select>} \
   CONFIG.PCW_MIO_19_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_19_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_19_PULLUP {<Select>} \
   CONFIG.PCW_MIO_19_SLEW {<Select>} \
   CONFIG.PCW_MIO_1_DIRECTION {out} \
   CONFIG.PCW_MIO_1_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_1_PULLUP {enabled} \
   CONFIG.PCW_MIO_1_SLEW {slow} \
   CONFIG.PCW_MIO_20_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_20_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_20_PULLUP {<Select>} \
   CONFIG.PCW_MIO_20_SLEW {<Select>} \
   CONFIG.PCW_MIO_21_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_21_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_21_PULLUP {<Select>} \
   CONFIG.PCW_MIO_21_SLEW {<Select>} \
   CONFIG.PCW_MIO_22_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_22_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_22_PULLUP {<Select>} \
   CONFIG.PCW_MIO_22_SLEW {<Select>} \
   CONFIG.PCW_MIO_23_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_23_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_23_PULLUP {<Select>} \
   CONFIG.PCW_MIO_23_SLEW {<Select>} \
   CONFIG.PCW_MIO_24_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_24_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_24_PULLUP {<Select>} \
   CONFIG.PCW_MIO_24_SLEW {<Select>} \
   CONFIG.PCW_MIO_25_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_25_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_25_PULLUP {<Select>} \
   CONFIG.PCW_MIO_25_SLEW {<Select>} \
   CONFIG.PCW_MIO_26_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_26_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_26_PULLUP {<Select>} \
   CONFIG.PCW_MIO_26_SLEW {<Select>} \
   CONFIG.PCW_MIO_27_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_27_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_27_PULLUP {<Select>} \
   CONFIG.PCW_MIO_27_SLEW {<Select>} \
   CONFIG.PCW_MIO_28_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_28_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_28_PULLUP {<Select>} \
   CONFIG.PCW_MIO_28_SLEW {<Select>} \
   CONFIG.PCW_MIO_29_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_29_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_29_PULLUP {<Select>} \
   CONFIG.PCW_MIO_29_SLEW {<Select>} \
   CONFIG.PCW_MIO_2_DIRECTION {inout} \
   CONFIG.PCW_MIO_2_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_2_PULLUP {disabled} \
   CONFIG.PCW_MIO_2_SLEW {slow} \
   CONFIG.PCW_MIO_30_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_30_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_30_PULLUP {<Select>} \
   CONFIG.PCW_MIO_30_SLEW {<Select>} \
   CONFIG.PCW_MIO_31_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_31_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_31_PULLUP {<Select>} \
   CONFIG.PCW_MIO_31_SLEW {<Select>} \
   CONFIG.PCW_MIO_32_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_32_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_32_PULLUP {<Select>} \
   CONFIG.PCW_MIO_32_SLEW {<Select>} \
   CONFIG.PCW_MIO_33_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_33_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_33_PULLUP {<Select>} \
   CONFIG.PCW_MIO_33_SLEW {<Select>} \
   CONFIG.PCW_MIO_34_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_34_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_34_PULLUP {<Select>} \
   CONFIG.PCW_MIO_34_SLEW {<Select>} \
   CONFIG.PCW_MIO_35_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_35_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_35_PULLUP {<Select>} \
   CONFIG.PCW_MIO_35_SLEW {<Select>} \
   CONFIG.PCW_MIO_36_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_36_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_36_PULLUP {<Select>} \
   CONFIG.PCW_MIO_36_SLEW {<Select>} \
   CONFIG.PCW_MIO_37_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_37_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_37_PULLUP {<Select>} \
   CONFIG.PCW_MIO_37_SLEW {<Select>} \
   CONFIG.PCW_MIO_38_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_38_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_38_PULLUP {<Select>} \
   CONFIG.PCW_MIO_38_SLEW {<Select>} \
   CONFIG.PCW_MIO_39_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_39_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_39_PULLUP {<Select>} \
   CONFIG.PCW_MIO_39_SLEW {<Select>} \
   CONFIG.PCW_MIO_3_DIRECTION {inout} \
   CONFIG.PCW_MIO_3_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_3_PULLUP {disabled} \
   CONFIG.PCW_MIO_3_SLEW {slow} \
   CONFIG.PCW_MIO_40_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_40_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_40_PULLUP {<Select>} \
   CONFIG.PCW_MIO_40_SLEW {<Select>} \
   CONFIG.PCW_MIO_41_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_41_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_41_PULLUP {<Select>} \
   CONFIG.PCW_MIO_41_SLEW {<Select>} \
   CONFIG.PCW_MIO_42_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_42_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_42_PULLUP {<Select>} \
   CONFIG.PCW_MIO_42_SLEW {<Select>} \
   CONFIG.PCW_MIO_43_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_43_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_43_PULLUP {<Select>} \
   CONFIG.PCW_MIO_43_SLEW {<Select>} \
   CONFIG.PCW_MIO_44_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_44_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_44_PULLUP {<Select>} \
   CONFIG.PCW_MIO_44_SLEW {<Select>} \
   CONFIG.PCW_MIO_45_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_45_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_45_PULLUP {<Select>} \
   CONFIG.PCW_MIO_45_SLEW {<Select>} \
   CONFIG.PCW_MIO_46_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_46_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_46_PULLUP {<Select>} \
   CONFIG.PCW_MIO_46_SLEW {<Select>} \
   CONFIG.PCW_MIO_47_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_47_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_47_PULLUP {<Select>} \
   CONFIG.PCW_MIO_47_SLEW {<Select>} \
   CONFIG.PCW_MIO_48_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_48_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_48_PULLUP {<Select>} \
   CONFIG.PCW_MIO_48_SLEW {<Select>} \
   CONFIG.PCW_MIO_49_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_49_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_49_PULLUP {<Select>} \
   CONFIG.PCW_MIO_49_SLEW {<Select>} \
   CONFIG.PCW_MIO_4_DIRECTION {inout} \
   CONFIG.PCW_MIO_4_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_4_PULLUP {disabled} \
   CONFIG.PCW_MIO_4_SLEW {slow} \
   CONFIG.PCW_MIO_50_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_50_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_50_PULLUP {<Select>} \
   CONFIG.PCW_MIO_50_SLEW {<Select>} \
   CONFIG.PCW_MIO_51_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_51_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_51_PULLUP {<Select>} \
   CONFIG.PCW_MIO_51_SLEW {<Select>} \
   CONFIG.PCW_MIO_52_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_52_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_52_PULLUP {<Select>} \
   CONFIG.PCW_MIO_52_SLEW {<Select>} \
   CONFIG.PCW_MIO_53_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_53_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_53_PULLUP {<Select>} \
   CONFIG.PCW_MIO_53_SLEW {<Select>} \
   CONFIG.PCW_MIO_5_DIRECTION {inout} \
   CONFIG.PCW_MIO_5_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_5_PULLUP {disabled} \
   CONFIG.PCW_MIO_5_SLEW {slow} \
   CONFIG.PCW_MIO_6_DIRECTION {out} \
   CONFIG.PCW_MIO_6_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_6_PULLUP {disabled} \
   CONFIG.PCW_MIO_6_SLEW {slow} \
   CONFIG.PCW_MIO_7_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_7_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_7_PULLUP {<Select>} \
   CONFIG.PCW_MIO_7_SLEW {<Select>} \
   CONFIG.PCW_MIO_8_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_8_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_8_PULLUP {<Select>} \
   CONFIG.PCW_MIO_8_SLEW {<Select>} \
   CONFIG.PCW_MIO_9_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_9_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_9_PULLUP {<Select>} \
   CONFIG.PCW_MIO_9_SLEW {<Select>} \
   CONFIG.PCW_MIO_TREE_PERIPHERALS {unassigned#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned} \
   CONFIG.PCW_MIO_TREE_SIGNALS {unassigned#qspi0_ss_b#qspi0_io[0]#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]/HOLD_B#qspi0_sclk#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned} \
   CONFIG.PCW_M_AXI_GP0_ENABLE_STATIC_REMAP {0} \
   CONFIG.PCW_M_AXI_GP0_THREAD_ID_WIDTH {12} \
   CONFIG.PCW_NAND_GRP_D8_ENABLE {0} \
   CONFIG.PCW_NAND_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_A25_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_INT_ENABLE {0} \
   CONFIG.PCW_NOR_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY0 {0.230} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY1 {0.221} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY2 {0.227} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY3 {0.245} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_0 {0.090} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_1 {0.098} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_2 {0.103} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_3 {0.064} \
   CONFIG.PCW_PCAP_PERIPHERAL_DIVISOR0 {8} \
   CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {0} \
   CONFIG.PCW_QSPI_GRP_IO1_ENABLE {0} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO {MIO 1 .. 6} \
   CONFIG.PCW_QSPI_GRP_SS1_ENABLE {0} \
   CONFIG.PCW_QSPI_INTERNAL_HIGHADDRESS {0xFCFFFFFF} \
   CONFIG.PCW_QSPI_PERIPHERAL_CLKSRC {ARM PLL} \
   CONFIG.PCW_QSPI_PERIPHERAL_DIVISOR0 {12} \
   CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_QSPI_QSPI_IO {MIO 1 .. 6} \
   CONFIG.PCW_SDIO_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SINGLE_QSPI_DATA_MODE {x4} \
   CONFIG.PCW_SMC_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SPI_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_S_AXI_HP0_DATA_WIDTH {32} \
   CONFIG.PCW_S_AXI_HP1_DATA_WIDTH {32} \
   CONFIG.PCW_TPIU_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC0_CLK0_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_CLK1_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_CLK2_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_TTC0_TTC0_IO {<Select>} \
   CONFIG.PCW_TTC1_CLK0_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC1_CLK1_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC1_CLK2_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_TTC1_TTC1_IO {<Select>} \
   CONFIG.PCW_TTC_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_UART0_GRP_FULL_ENABLE {1} \
   CONFIG.PCW_UART0_GRP_FULL_IO {EMIO} \
   CONFIG.PCW_UART0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_UART0_UART0_IO {EMIO} \
   CONFIG.PCW_UART1_GRP_FULL_ENABLE {0} \
   CONFIG.PCW_UART1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_UART_PERIPHERAL_DIVISOR0 {16} \
   CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_UART_PERIPHERAL_VALID {1} \
   CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {300.000000} \
   CONFIG.PCW_UIPARAM_DDR_AL {0} \
   CONFIG.PCW_UIPARAM_DDR_BANK_ADDR_COUNT {3} \
   CONFIG.PCW_UIPARAM_DDR_BL {8} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.230} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.221} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.227} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.245} \
   CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {16 Bit} \
   CONFIG.PCW_UIPARAM_DDR_CL {5} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_LENGTH_MM {31.81} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_LENGTH_MM {31.81} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_LENGTH_MM {31.81} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_LENGTH_MM {31.81} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_STOP_EN {0} \
   CONFIG.PCW_UIPARAM_DDR_COL_ADDR_COUNT {10} \
   CONFIG.PCW_UIPARAM_DDR_CWL {3} \
   CONFIG.PCW_UIPARAM_DDR_DEVICE_CAPACITY {1024 MBits} \
   CONFIG.PCW_UIPARAM_DDR_DQS_0_LENGTH_MM {17.42} \
   CONFIG.PCW_UIPARAM_DDR_DQS_1_LENGTH_MM {15.98} \
   CONFIG.PCW_UIPARAM_DDR_DQS_2_LENGTH_MM {15.98} \
   CONFIG.PCW_UIPARAM_DDR_DQS_3_LENGTH_MM {15.98} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {0.090} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {0.098} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {0.103} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {0.064} \
   CONFIG.PCW_UIPARAM_DDR_DQ_0_LENGTH_MM {17.43} \
   CONFIG.PCW_UIPARAM_DDR_DQ_1_LENGTH_MM {15.93} \
   CONFIG.PCW_UIPARAM_DDR_DQ_2_LENGTH_MM {15.93} \
   CONFIG.PCW_UIPARAM_DDR_DQ_3_LENGTH_MM {15.93} \
   CONFIG.PCW_UIPARAM_DDR_DRAM_WIDTH {16 Bits} \
   CONFIG.PCW_UIPARAM_DDR_ECC {Disabled} \
   CONFIG.PCW_UIPARAM_DDR_ENABLE {1} \
   CONFIG.PCW_UIPARAM_DDR_FREQ_MHZ {300} \
   CONFIG.PCW_UIPARAM_DDR_HIGH_TEMP {Normal (0-85)} \
   CONFIG.PCW_UIPARAM_DDR_MEMORY_TYPE {DDR 2} \
   CONFIG.PCW_UIPARAM_DDR_PARTNO {Custom} \
   CONFIG.PCW_UIPARAM_DDR_ROW_ADDR_COUNT {13} \
   CONFIG.PCW_UIPARAM_DDR_SPEED_BIN {DDR2_800D} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {0} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {0} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {0} \
   CONFIG.PCW_UIPARAM_DDR_T_FAW {45.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RAS_MIN {45.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RC {55} \
   CONFIG.PCW_UIPARAM_DDR_T_RCD {5} \
   CONFIG.PCW_UIPARAM_DDR_T_RP {5} \
   CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {1} \
   CONFIG.PCW_UIPARAM_GENERATE_SUMMARY {NONE} \
   CONFIG.PCW_USB0_RESET_ENABLE {0} \
   CONFIG.PCW_USB1_RESET_ENABLE {0} \
   CONFIG.PCW_USB_RESET_ENABLE {0} \
   CONFIG.PCW_USE_CORESIGHT {0} \
   CONFIG.PCW_USE_DEFAULT_ACP_USER_VAL {0} \
   CONFIG.PCW_USE_EXPANDED_IOP {0} \
   CONFIG.PCW_USE_EXPANDED_PS_SLCR_REGISTERS {0} \
   CONFIG.PCW_USE_FABRIC_INTERRUPT {0} \
   CONFIG.PCW_USE_HIGH_OCM {0} \
   CONFIG.PCW_USE_M_AXI_GP0 {0} \
   CONFIG.PCW_USE_M_AXI_GP1 {0} \
   CONFIG.PCW_USE_PS_SLCR_REGISTERS {0} \
   CONFIG.PCW_USE_S_AXI_ACP {0} \
   CONFIG.PCW_USE_S_AXI_GP0 {1} \
   CONFIG.PCW_USE_S_AXI_GP1 {0} \
   CONFIG.PCW_USE_S_AXI_HP0 {0} \
   CONFIG.PCW_USE_S_AXI_HP1 {0} \
   CONFIG.PCW_USE_S_AXI_HP2 {0} \
   CONFIG.PCW_WDT_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_WDT_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_WDT_WDT_IO {<Select>} \
 ] $zync_soc

  # Create interface connections
  connect_bd_intf_net -intf_net Conn [get_bd_intf_ports pcie] [get_bd_intf_pins pcie2AxiMaster_0/pcie_mgt]
  connect_bd_intf_net -intf_net FPGA_Info_0_1 [get_bd_intf_ports FPGA_Info_0] [get_bd_intf_pins pcie2AxiMaster_0/FPGA_Info]
  connect_bd_intf_net -intf_net Profinet_UART_0_0 [get_bd_intf_ports UART_DBG] [get_bd_intf_pins zync_soc/UART_0]
  connect_bd_intf_net -intf_net Profinet_ddr [get_bd_intf_ports ddr] [get_bd_intf_pins zync_soc/DDR]
  connect_bd_intf_net -intf_net Profinet_fixed_io [get_bd_intf_ports fixed_io] [get_bd_intf_pins zync_soc/FIXED_IO]
  connect_bd_intf_net -intf_net Vp_Vn_0_1 [get_bd_intf_ports Vp_Vn_0] [get_bd_intf_pins xadc/Vp_Vn]
  connect_bd_intf_net -intf_net axiMaio_0_ext_sync [get_bd_intf_ports ext_sync_0] [get_bd_intf_pins axiMaio_0/ext_sync]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins zync_soc/S_AXI_GP0]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins axiMaio_0/s_axi] [get_bd_intf_pins axi_interconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M06_AXI [get_bd_intf_pins axi_interconnect_0/M06_AXI] [get_bd_intf_pins xadc/s_axi_lite]
  connect_bd_intf_net -intf_net lpc_1 [get_bd_intf_ports lpc] [get_bd_intf_pins mtxLPCUarts_0/lpc]
  connect_bd_intf_net -intf_net mii_to_rmii_0_RMII_PHY_M [get_bd_intf_ports ncsi_4] [get_bd_intf_pins profinet1_mii_to_rmii/RMII_PHY_M]
  connect_bd_intf_net -intf_net mii_to_rmii_1_RMII_PHY_M [get_bd_intf_ports ncsi_5] [get_bd_intf_pins profinet2_mii_to_rmii/RMII_PHY_M]
  connect_bd_intf_net -intf_net mtxLPCUarts_0_UART_0 [get_bd_intf_ports UART_0] [get_bd_intf_pins mtxLPCUarts_0/UART_0]
  connect_bd_intf_net -intf_net mtxLPCUarts_0_UART_1 [get_bd_intf_ports UART_1] [get_bd_intf_pins mtxLPCUarts_0/UART_1]
  connect_bd_intf_net -intf_net ncsi_system_ncsi_0 [get_bd_intf_ports ncsi_0] [get_bd_intf_pins ncsi_system/ncsi_0]
  connect_bd_intf_net -intf_net ncsi_system_ncsi_1 [get_bd_intf_ports ncsi_1] [get_bd_intf_pins ncsi_system/ncsi_1]
  connect_bd_intf_net -intf_net ncsi_system_ncsi_2 [get_bd_intf_ports ncsi_2] [get_bd_intf_pins ncsi_system/ncsi_2]
  connect_bd_intf_net -intf_net ncsi_system_ncsi_3 [get_bd_intf_ports ncsi_3] [get_bd_intf_pins ncsi_system/ncsi_3]
  connect_bd_intf_net -intf_net pcie2AxiMaster_0_M_AXI [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins pcie2AxiMaster_0/M_AXI]
  connect_bd_intf_net -intf_net pcie2AxiMaster_0_mtxSPI [get_bd_intf_ports mtxSPI_0] [get_bd_intf_pins pcie2AxiMaster_0/mtxSPI]
  connect_bd_intf_net -intf_net s_axi_ncsi_0_1 [get_bd_intf_pins axi_interconnect_0/M02_AXI] [get_bd_intf_pins ncsi_system/s_axi_ncsi_0]
  connect_bd_intf_net -intf_net s_axi_ncsi_1_1 [get_bd_intf_pins axi_interconnect_0/M03_AXI] [get_bd_intf_pins ncsi_system/s_axi_ncsi_1]
  connect_bd_intf_net -intf_net s_axi_ncsi_2_1 [get_bd_intf_pins axi_interconnect_0/M04_AXI] [get_bd_intf_pins ncsi_system/s_axi_ncsi_2]
  connect_bd_intf_net -intf_net s_axi_ncsi_3_1 [get_bd_intf_pins axi_interconnect_0/M05_AXI] [get_bd_intf_pins ncsi_system/s_axi_ncsi_3]
  connect_bd_intf_net -intf_net zync_soc_GMII_ETHERNET_0 [get_bd_intf_pins profinet1_mii_to_rmii/GMII] [get_bd_intf_pins zync_soc/GMII_ETHERNET_0]
  connect_bd_intf_net -intf_net zync_soc_GMII_ETHERNET_1 [get_bd_intf_pins profinet2_mii_to_rmii/GMII] [get_bd_intf_pins zync_soc/GMII_ETHERNET_1]

  # Create port connections
  connect_bd_net -net PCIE_REFCLK_100MHz_1 [get_bd_ports PCIE_REFCLK_100MHz] [get_bd_pins pcie2AxiMaster_0/pcie_sys_clk]
  connect_bd_net -net PCIE_RESET_N_1 [get_bd_ports PCIE_RESET_N] [get_bd_pins pcie2AxiMaster_0/pcie_sys_rst_n]
  connect_bd_net -net Profinet_axi_clk_100MHz1 [get_bd_pins axiMaio_0/axi_aclk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_interconnect_0/M02_ACLK] [get_bd_pins axi_interconnect_0/M03_ACLK] [get_bd_pins axi_interconnect_0/M04_ACLK] [get_bd_pins axi_interconnect_0/M05_ACLK] [get_bd_pins axi_interconnect_0/M06_ACLK] [get_bd_pins clk_reset_mngr/axi_clk_100MHz] [get_bd_pins ncsi_system/axi_clk_100MHz] [get_bd_pins xadc/s_axi_aclk] [get_bd_pins zync_soc/S_AXI_GP0_ACLK]
  connect_bd_net -net axiMaio_0_irq_event_io [get_bd_pins axiMaio_0/irq_event_io] [get_bd_pins interrupt_mapping/irq_io]
  connect_bd_net -net axiMaio_0_irq_event_tick [get_bd_pins axiMaio_0/irq_event_tick] [get_bd_pins interrupt_mapping/irq_tick]
  connect_bd_net -net axiMaio_0_irq_event_tick_stamp_latched [get_bd_pins axiMaio_0/irq_event_tick_stamp_latched] [get_bd_pins interrupt_mapping/irq_tick_latch]
  connect_bd_net -net axiMaio_0_irq_event_tick_wrap [get_bd_pins axiMaio_0/irq_event_tick_wrap] [get_bd_pins interrupt_mapping/irq_tick_wa]
  connect_bd_net -net axiMaio_0_irq_event_timer_end [get_bd_pins axiMaio_0/irq_event_timer_end] [get_bd_pins interrupt_mapping/irq_timer_stop]
  connect_bd_net -net axiMaio_0_irq_event_timer_start [get_bd_pins axiMaio_0/irq_event_timer_start] [get_bd_pins interrupt_mapping/irq_timer_start]
  connect_bd_net -net axiMaio_0_user_data_out [get_bd_ports user_data_out] [get_bd_pins axiMaio_0/user_data_out]
  connect_bd_net -net clk_reset_mngr_ncsi_clk50MHz_out [get_bd_ports ncsi_clk_out] [get_bd_pins clk_reset_mngr/ncsi_clk50MHz_io]
  connect_bd_net -net clk_reset_mngr_profinet1_clk_100MHz [get_bd_pins clk_reset_mngr/profinet1_clk_50MHz] [get_bd_pins profinet1_mii_to_rmii/ref_clk]
  connect_bd_net -net clk_reset_mngr_profinet1_reset_n [get_bd_pins clk_reset_mngr/profinet1_reset_n] [get_bd_pins profinet1_mii_to_rmii/rst_n]
  connect_bd_net -net debug_in_0_1 [get_bd_ports debug_in] [get_bd_pins pcie2AxiMaster_0/debug_in]
  connect_bd_net -net eth_pll_ncsi_clk_int [get_bd_pins clk_reset_mngr/ncsi_clk50MHz] [get_bd_pins ncsi_system/ncsi_clk50MHz] [get_bd_pins profinet2_mii_to_rmii/ref_clk]
  connect_bd_net -net interrupt_mapping_irq_event [get_bd_pins interrupt_mapping/irq_event] [get_bd_pins pcie2AxiMaster_0/irq_event]
  connect_bd_net -net mtxLPCUarts_0_transmission_active_0 [get_bd_ports transmission_active_0] [get_bd_pins mtxLPCUarts_0/transmission_active_0]
  connect_bd_net -net mtxLPCUarts_0_transmission_active_1 [get_bd_ports transmission_active_1] [get_bd_pins mtxLPCUarts_0/transmission_active_1]
  connect_bd_net -net ncsi_rst_n_1 [get_bd_pins clk_reset_mngr/ncsi_reset_n] [get_bd_pins ncsi_system/ncsi_rst_n] [get_bd_pins profinet2_mii_to_rmii/rst_n]
  connect_bd_net -net pcie2AxiMaster_0_M_AXI_CLK [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins pcie2AxiMaster_0/M_AXI_CLK]
  connect_bd_net -net pcie2AxiMaster_0_M_AXI_RST_N [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins pcie2AxiMaster_0/M_AXI_RST_N]
  connect_bd_net -net pcie2AxiMaster_0_debug_out [get_bd_ports debug_out] [get_bd_pins pcie2AxiMaster_0/debug_out]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins axiMaio_0/axi_aresetn] [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_interconnect_0/M02_ARESETN] [get_bd_pins axi_interconnect_0/M03_ARESETN] [get_bd_pins axi_interconnect_0/M04_ARESETN] [get_bd_pins axi_interconnect_0/M05_ARESETN] [get_bd_pins axi_interconnect_0/M06_ARESETN] [get_bd_pins clk_reset_mngr/axi_reset_n] [get_bd_pins ncsi_system/axi_reset_n] [get_bd_pins xadc/s_axi_aresetn]
  connect_bd_net -net user_data_in_1 [get_bd_ports user_data_in] [get_bd_pins axiMaio_0/user_data_in]
  connect_bd_net -net zync_soc_FCLK_CLK0 [get_bd_pins clk_reset_mngr/ref_clk_100MHz] [get_bd_pins zync_soc/FCLK_CLK0]
  connect_bd_net -net zync_soc_FCLK_RESET0_N [get_bd_pins clk_reset_mngr/ext_reset_n] [get_bd_pins zync_soc/FCLK_RESET0_N]

  # Create address segments
  create_bd_addr_seg -range 0x00008000 -offset 0x00000000 [get_bd_addr_spaces pcie2AxiMaster_0/M_AXI] [get_bd_addr_segs axiMaio_0/s_axi/reg0] SEG_axiMaio_0_reg0
  create_bd_addr_seg -range 0x00002000 -offset 0x00010000 [get_bd_addr_spaces pcie2AxiMaster_0/M_AXI] [get_bd_addr_segs ncsi_system/ncsi0/axi_ethernetlite_0/S_AXI/Reg] SEG_axi_ethernetlite_0_Reg
  create_bd_addr_seg -range 0x00002000 -offset 0x00012000 [get_bd_addr_spaces pcie2AxiMaster_0/M_AXI] [get_bd_addr_segs ncsi_system/ncsi1/axi_ethernetlite_0/S_AXI/Reg] SEG_axi_ethernetlite_0_Reg1
  create_bd_addr_seg -range 0x00002000 -offset 0x00014000 [get_bd_addr_spaces pcie2AxiMaster_0/M_AXI] [get_bd_addr_segs ncsi_system/ncsi2/axi_ethernetlite_0/S_AXI/Reg] SEG_axi_ethernetlite_0_Reg2
  create_bd_addr_seg -range 0x00002000 -offset 0x00016000 [get_bd_addr_spaces pcie2AxiMaster_0/M_AXI] [get_bd_addr_segs ncsi_system/ncsi3/axi_ethernetlite_0/S_AXI/Reg] SEG_axi_ethernetlite_0_Reg3
  create_bd_addr_seg -range 0x00010000 -offset 0x00020000 [get_bd_addr_spaces pcie2AxiMaster_0/M_AXI] [get_bd_addr_segs xadc/s_axi_lite/Reg] SEG_xadc_Reg
  create_bd_addr_seg -range 0x08000000 -offset 0x08000000 [get_bd_addr_spaces pcie2AxiMaster_0/M_AXI] [get_bd_addr_segs zync_soc/S_AXI_GP0/GP0_DDR_LOWOCM] SEG_zync_soc_GP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x00400000 -offset 0xE0000000 [get_bd_addr_spaces pcie2AxiMaster_0/M_AXI] [get_bd_addr_segs zync_soc/S_AXI_GP0/GP0_IOP] SEG_zync_soc_GP0_IOP
  create_bd_addr_seg -range 0x01000000 -offset 0xFC000000 [get_bd_addr_spaces pcie2AxiMaster_0/M_AXI] [get_bd_addr_segs zync_soc/S_AXI_GP0/GP0_QSPI_LINEAR] SEG_zync_soc_GP0_QSPI_LINEAR


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


