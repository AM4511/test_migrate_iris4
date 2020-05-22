
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
xilinx.com:ip:xlconstant:1.1\
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
  set Anput [ create_bd_intf_port -mode Master -vlnv matrox.com:user:Athena2Ares_if_rtl:1.0 Anput ]

  set I2C_if [ create_bd_intf_port -mode Master -vlnv matrox.com:user:I2C_Matrox_rtl:1.0 I2C_if ]

  set SPI [ create_bd_intf_port -mode Master -vlnv matrox.com:MatroxIP:mtxSPI_rtl:1.0 SPI ]

  set hispi [ create_bd_intf_port -mode Slave -vlnv matrox.com:user:hispi_if_rtl:1.0 hispi ]

  set info [ create_bd_intf_port -mode Slave -vlnv matrox.com:Imaging:FPGA_Info_rtl:1.0 info ]

  set pcie [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie ]

  set xgs_ctrl [ create_bd_intf_port -mode Master -vlnv matrox.com:user:XGS_controller_if_rtl:1.0 xgs_ctrl ]


  # Create ports
  set debug_out [ create_bd_port -dir O -from 3 -to 0 debug_out ]
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
   CONFIG.NI_ACCESS {true} \
 ] $AXI_i2c_Matrox_0

  # Create instance: XGS_athena_0, and set properties
  set XGS_athena_0 [ create_bd_cell -type ip -vlnv matrox.com:Imaging:XGS_athena:1.0.0 XGS_athena_0 ]
  set_property -dict [ list \
   CONFIG.BOOL_ENABLE_IDELAYCTRL {true} \
   CONFIG.ENABLE_IDELAYCTRL {1} \
   CONFIG.KU706 {0} \
   CONFIG.SENSOR_FREQ {32000} \
 ] $XGS_athena_0

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKOUT1_JITTER {114.829} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {200.000} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {5.000} \
   CONFIG.RESET_PORT {resetn} \
   CONFIG.RESET_TYPE {ACTIVE_LOW} \
   CONFIG.USE_LOCKED {true} \
   CONFIG.USE_RESET {true} \
 ] $clk_wiz_0

  # Create instance: pcie2AxiMaster_0, and set properties
  set pcie2AxiMaster_0 [ create_bd_cell -type ip -vlnv matrox.com:Imaging:pcie2AxiMaster:3.0 pcie2AxiMaster_0 ]
  set_property -dict [ list \
   CONFIG.BOOL_ENABLE_DMA {true} \
   CONFIG.BOOL_ENABLE_SPI {true} \
   CONFIG.ENABLE_DMA {1} \
   CONFIG.ENABLE_MTX_SPI {1} \
   CONFIG.PCIE_DEVICE_ID {20564} \
 ] $pcie2AxiMaster_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {8} \
 ] $xlconstant_0

  # Create interface connections
  connect_bd_intf_net -intf_net AXI_i2c_Matrox_0_I2C_interface [get_bd_intf_ports I2C_if] [get_bd_intf_pins AXI_i2c_Matrox_0/I2C_interface]
  connect_bd_intf_net -intf_net XGS_athena_0_Athena2Anput [get_bd_intf_ports Anput] [get_bd_intf_pins XGS_athena_0/Athena2Anput]
  connect_bd_intf_net -intf_net XGS_athena_0_XGS_Controller_IF [get_bd_intf_ports xgs_ctrl] [get_bd_intf_pins XGS_athena_0/XGS_Controller_IF]
  connect_bd_intf_net -intf_net XGS_athena_0_tlp [get_bd_intf_pins XGS_athena_0/tlp] [get_bd_intf_pins pcie2AxiMaster_0/dma_tlp]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins AXI_i2c_Matrox_0/S_AXI] [get_bd_intf_pins axi_interconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins XGS_athena_0/s_axi] [get_bd_intf_pins axi_interconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net hispi_1 [get_bd_intf_ports hispi] [get_bd_intf_pins XGS_athena_0/hispi]
  connect_bd_intf_net -intf_net info_1 [get_bd_intf_ports info] [get_bd_intf_pins pcie2AxiMaster_0/FPGA_Info]
  connect_bd_intf_net -intf_net pcie2AxiMaster_0_M_AXI [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins pcie2AxiMaster_0/M_AXI]
  connect_bd_intf_net -intf_net pcie2AxiMaster_0_mtxSPI [get_bd_intf_ports SPI] [get_bd_intf_pins pcie2AxiMaster_0/mtxSPI]
  connect_bd_intf_net -intf_net pcie2AxiMaster_0_pcie_mgt [get_bd_intf_ports pcie] [get_bd_intf_pins pcie2AxiMaster_0/pcie_mgt]

  # Create port connections
  connect_bd_net -net ARESETN_1 [get_bd_pins AXI_i2c_Matrox_0/s_axi_aresetn] [get_bd_pins XGS_athena_0/axi_reset_n] [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins clk_wiz_0/resetn] [get_bd_pins pcie2AxiMaster_0/axim_rst_n]
  connect_bd_net -net XGS_athena_0_debug_out [get_bd_ports debug_out] [get_bd_pins XGS_athena_0/debug_out]
  connect_bd_net -net XGS_athena_0_led_out [get_bd_ports led_out] [get_bd_pins XGS_athena_0/led_out]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins XGS_athena_0/idelay_clk] [get_bd_pins clk_wiz_0/clk_out1]
  connect_bd_net -net pcie2AxiMaster_0_axim_clk [get_bd_pins AXI_i2c_Matrox_0/s_axi_aclk] [get_bd_pins XGS_athena_0/axi_clk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins pcie2AxiMaster_0/axim_clk]
  connect_bd_net -net pcie_sys_clk_1 [get_bd_ports pcie_sys_clk] [get_bd_pins pcie2AxiMaster_0/pcie_sys_clk]
  connect_bd_net -net pcie_sys_rst_n_1 [get_bd_ports pcie_sys_rst_n] [get_bd_pins pcie2AxiMaster_0/pcie_sys_rst_n]
  connect_bd_net -net ref_clk_1 [get_bd_ports ref_clk] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins pcie2AxiMaster_0/irq_event] [get_bd_pins xlconstant_0/dout]

  # Create address segments
  create_bd_addr_seg -range 0x00001000 -offset 0x40010000 [get_bd_addr_spaces pcie2AxiMaster_0/M_AXI] [get_bd_addr_segs AXI_i2c_Matrox_0/S_AXI/S_AXI_reg] SEG_AXI_i2c_Matrox_0_S_AXI_reg
  create_bd_addr_seg -range 0x00001000 -offset 0x40000000 [get_bd_addr_spaces pcie2AxiMaster_0/M_AXI] [get_bd_addr_segs XGS_athena_0/s_axi/reg0] SEG_XGS_athena_0_reg0


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


common::send_msg_id "BD_TCL-1000" "WARNING" "This Tcl script was generated from a block design that has not been validated. It is possible that design <$design_name> may result in errors during validation."

