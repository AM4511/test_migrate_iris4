
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
xilinx.com:ip:axi_quad_spi:3.2\
xilinx.com:ip:clk_wiz:6.0\
matrox.com:Imaging:axiHiSPi:1.1.1\
matrox.com:fdklib:dmawr_sub4:3.0\
xilinx.com:ip:util_reduced_logic:2.0\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:axi_pcie:2.9\
xilinx.com:ip:proc_sys_reset:5.0\
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


# Hierarchical cell: pcie_0
proc create_hier_cell_pcie_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_pcie_0() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M01_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M02_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_pcie


  # Create pins
  create_bd_pin -dir I -type rst ext_reset_n
  create_bd_pin -dir I host_irq
  create_bd_pin -dir O paxiclk
  create_bd_pin -dir I -type clk pcie_clk_100MHz
  create_bd_pin -dir O -from 0 -to 0 -type rst presetn

  # Create instance: axi_interconnect_1, and set properties
  set axi_interconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_1 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {4} \
 ] $axi_interconnect_1

  # Create instance: axi_pcie_0, and set properties
  set axi_pcie_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_pcie:2.9 axi_pcie_0 ]
  set_property -dict [ list \
   CONFIG.AXIBAR_AS_0 {true} \
   CONFIG.BAR0_SCALE {Megabytes} \
   CONFIG.BAR0_SIZE {32} \
   CONFIG.BAR1_ENABLED {true} \
   CONFIG.BAR1_SCALE {Megabytes} \
   CONFIG.BAR1_SIZE {1} \
   CONFIG.BAR1_TYPE {Memory} \
   CONFIG.BAR_64BIT {true} \
   CONFIG.BASE_CLASS_MENU {Input_devices} \
   CONFIG.DEVICE_ID {0x7012} \
   CONFIG.INTERRUPT_PIN {true} \
   CONFIG.MAX_LINK_SPEED {2.5_GT/s} \
   CONFIG.M_AXI_DATA_WIDTH {64} \
   CONFIG.NO_OF_LANES {X2} \
   CONFIG.SLOT_CLOCK_CONFIG {true} \
   CONFIG.SUB_CLASS_INTERFACE_MENU {Other_input_controller} \
   CONFIG.S_AXI_DATA_WIDTH {64} \
   CONFIG.S_AXI_SUPPORTS_NARROW_BURST {false} \
   CONFIG.shared_logic_in_core {false} \
 ] $axi_pcie_0

  # Create instance: pcie_reset_n, and set properties
  set pcie_reset_n [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 pcie_reset_n ]

  # Create interface connections
  connect_bd_intf_net -intf_net axi_interconnect_1_M00_AXI [get_bd_intf_pins M00_AXI] [get_bd_intf_pins axi_interconnect_1/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M01_AXI [get_bd_intf_pins M01_AXI] [get_bd_intf_pins axi_interconnect_1/M01_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M02_AXI [get_bd_intf_pins M02_AXI] [get_bd_intf_pins axi_interconnect_1/M02_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M03_AXI [get_bd_intf_pins axi_interconnect_1/M03_AXI] [get_bd_intf_pins axi_pcie_0/S_AXI_CTL]
  connect_bd_intf_net -intf_net axi_pcie_0_M_AXI [get_bd_intf_pins axi_interconnect_1/S00_AXI] [get_bd_intf_pins axi_pcie_0/M_AXI]
  connect_bd_intf_net -intf_net axi_pcie_0_pcie_7x_mgt [get_bd_intf_pins pcie] [get_bd_intf_pins axi_pcie_0/pcie_7x_mgt]
  connect_bd_intf_net -intf_net hispi_line_writer_m_dma [get_bd_intf_pins s_axi_pcie] [get_bd_intf_pins axi_pcie_0/S_AXI]

  # Create port connections
  connect_bd_net -net ARESETN_1 [get_bd_pins axi_interconnect_1/ARESETN] [get_bd_pins axi_interconnect_1/M00_ARESETN] [get_bd_pins axi_interconnect_1/M01_ARESETN] [get_bd_pins axi_interconnect_1/M02_ARESETN] [get_bd_pins axi_interconnect_1/M03_ARESETN] [get_bd_pins axi_interconnect_1/S00_ARESETN] [get_bd_pins pcie_reset_n/interconnect_aresetn]
  connect_bd_net -net axi_pcie_0_axi_aclk_out [get_bd_pins paxiclk] [get_bd_pins axi_interconnect_1/ACLK] [get_bd_pins axi_interconnect_1/M00_ACLK] [get_bd_pins axi_interconnect_1/M01_ACLK] [get_bd_pins axi_interconnect_1/M02_ACLK] [get_bd_pins axi_interconnect_1/S00_ACLK] [get_bd_pins axi_pcie_0/axi_aclk_out] [get_bd_pins pcie_reset_n/slowest_sync_clk]
  connect_bd_net -net axi_pcie_0_axi_ctl_aclk_out [get_bd_pins axi_interconnect_1/M03_ACLK] [get_bd_pins axi_pcie_0/axi_ctl_aclk_out]
  connect_bd_net -net axi_pcie_0_mmcm_lock [get_bd_pins axi_pcie_0/mmcm_lock] [get_bd_pins pcie_reset_n/dcm_locked]
  connect_bd_net -net pcie_clk_100MHz_1 [get_bd_pins pcie_clk_100MHz] [get_bd_pins axi_pcie_0/REFCLK]
  connect_bd_net -net pcie_reset_n_peripheral_aresetn [get_bd_pins presetn] [get_bd_pins axi_pcie_0/axi_aresetn] [get_bd_pins pcie_reset_n/peripheral_aresetn]
  connect_bd_net -net sys_rst_n_1 [get_bd_pins ext_reset_n] [get_bd_pins pcie_reset_n/ext_reset_in]
  connect_bd_net -net util_reduced_logic_0_Res [get_bd_pins host_irq] [get_bd_pins axi_pcie_0/INTX_MSI_Request]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: irq_logic
proc create_hier_cell_irq_logic { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_irq_logic() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 0 -to 0 In0
  create_bd_pin -dir I -from 0 -to 0 In1
  create_bd_pin -dir O Res

  # Create instance: util_reduced_logic_0, and set properties
  set util_reduced_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {2} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_reduced_logic_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]

  # Create port connections
  connect_bd_net -net axi_quad_spi_0_ip2intc_irpt [get_bd_pins In1] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net hispi_line_writer_irq_dma [get_bd_pins In0] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net util_reduced_logic_0_Res [get_bd_pins Res] [get_bd_pins util_reduced_logic_0/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins util_reduced_logic_0/Op1] [get_bd_pins xlconcat_0/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hispi_line_writer
proc create_hier_cell_hispi_line_writer { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_hispi_line_writer() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Slave -vlnv matrox.com:user:hispi_if_rtl:1.0 hispi

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_dma

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_reg_dma

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_reg_hispi


  # Create pins
  create_bd_pin -dir I -type clk axi_clk
  create_bd_pin -dir I -type rst axi_reset_n
  create_bd_pin -dir I -type clk idelay_clk
  create_bd_pin -dir O -type intr irq_dma

  # Create instance: axiHiSPi_0, and set properties
  set axiHiSPi_0 [ create_bd_cell -type ip -vlnv matrox.com:Imaging:axiHiSPi:1.1.1 axiHiSPi_0 ]
  set_property -dict [ list \
   CONFIG.FPGA_MANUFACTURER {XILINX} \
   CONFIG.NUMBER_OF_LANE {6} \
 ] $axiHiSPi_0

  # Create instance: dmawr_sub4_0, and set properties
  set dmawr_sub4_0 [ create_bd_cell -type ip -vlnv matrox.com:fdklib:dmawr_sub4:3.0 dmawr_sub4_0 ]
  set_property -dict [ list \
   CONFIG.AXI_ADDR_WIDTH {32} \
   CONFIG.AXI_DATA_WIDTH {64} \
 ] $dmawr_sub4_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_reg_dma] [get_bd_intf_pins dmawr_sub4_0/s_axi]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins hispi] [get_bd_intf_pins axiHiSPi_0/s_hispi]
  connect_bd_intf_net -intf_net axiHiSPi_0_m_axis [get_bd_intf_pins axiHiSPi_0/m_axis] [get_bd_intf_pins dmawr_sub4_0/s_axis]
  connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI [get_bd_intf_pins s_reg_hispi] [get_bd_intf_pins axiHiSPi_0/s_axi]
  connect_bd_intf_net -intf_net dmawr_sub4_0_m_axi [get_bd_intf_pins m_dma] [get_bd_intf_pins dmawr_sub4_0/m_axi]

  # Create port connections
  connect_bd_net -net axi_clk_1 [get_bd_pins axi_clk] [get_bd_pins axiHiSPi_0/axi_clk] [get_bd_pins dmawr_sub4_0/sysclk]
  connect_bd_net -net axi_reset_n_1 [get_bd_pins axi_reset_n] [get_bd_pins axiHiSPi_0/axi_reset_n] [get_bd_pins dmawr_sub4_0/sysrstN]
  connect_bd_net -net dmawr_sub4_0_intevent [get_bd_pins irq_dma] [get_bd_pins dmawr_sub4_0/intevent]
  connect_bd_net -net idelay_clk_0_1 [get_bd_pins idelay_clk] [get_bd_pins axiHiSPi_0/idelay_clk]

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
  set cfg_qspi [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:spi_rtl:1.0 cfg_qspi ]

  set cfg_startup_io [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_startup_io:startup_io_rtl:1.0 cfg_startup_io ]

  set pcie [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie ]

  set xgs [ create_bd_intf_port -mode Slave -vlnv matrox.com:user:hispi_if_rtl:1.0 xgs ]


  # Create ports
  set ext_reset_n [ create_bd_port -dir I -type rst ext_reset_n ]
  set pcie_clk_100MHz [ create_bd_port -dir I -type clk pcie_clk_100MHz ]
  set ref_clk [ create_bd_port -dir I -type clk ref_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {50000000} \
 ] $ref_clk

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

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {200.0} \
   CONFIG.CLKOUT1_DRIVES {BUFG} \
   CONFIG.CLKOUT1_JITTER {142.107} \
   CONFIG.CLKOUT1_PHASE_ERROR {164.985} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {200.000} \
   CONFIG.CLKOUT1_USED {true} \
   CONFIG.CLKOUT2_DRIVES {BUFG} \
   CONFIG.CLKOUT2_JITTER {192.113} \
   CONFIG.CLKOUT2_PHASE_ERROR {164.985} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {50.000} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLKOUT3_DRIVES {BUFG} \
   CONFIG.CLKOUT3_JITTER {114.829} \
   CONFIG.CLKOUT3_PHASE_ERROR {98.575} \
   CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {200.000} \
   CONFIG.CLKOUT3_USED {false} \
   CONFIG.CLKOUT4_DRIVES {BUFG} \
   CONFIG.CLKOUT5_DRIVES {BUFG} \
   CONFIG.CLKOUT6_DRIVES {BUFG} \
   CONFIG.CLKOUT7_DRIVES {BUFG} \
   CONFIG.CLK_OUT1_PORT {idly_clk} \
   CONFIG.CLK_OUT2_PORT {qspi_clk} \
   CONFIG.CLK_OUT3_PORT {idly_clk} \
   CONFIG.JITTER_SEL {No_Jitter} \
   CONFIG.MMCM_BANDWIDTH {OPTIMIZED} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {20} \
   CONFIG.MMCM_CLKIN1_PERIOD {20.000} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {5} \
   CONFIG.MMCM_CLKOUT0_DUTY_CYCLE {0.5} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {20} \
   CONFIG.MMCM_CLKOUT1_DUTY_CYCLE {0.5} \
   CONFIG.MMCM_CLKOUT2_DIVIDE {1} \
   CONFIG.MMCM_CLKOUT2_DUTY_CYCLE {0.5} \
   CONFIG.MMCM_COMPENSATION {ZHOLD} \
   CONFIG.NUM_OUT_CLKS {2} \
   CONFIG.PRIMITIVE {PLL} \
   CONFIG.PRIM_IN_FREQ {50.000} \
   CONFIG.PRIM_SOURCE {Single_ended_clock_capable_pin} \
   CONFIG.RESET_PORT {resetn} \
   CONFIG.RESET_TYPE {ACTIVE_LOW} \
   CONFIG.SECONDARY_SOURCE {Single_ended_clock_capable_pin} \
   CONFIG.USE_MIN_POWER {true} \
   CONFIG.USE_PHASE_ALIGNMENT {false} \
 ] $clk_wiz_0

  # Create instance: hispi_line_writer
  create_hier_cell_hispi_line_writer [current_bd_instance .] hispi_line_writer

  # Create instance: irq_logic
  create_hier_cell_irq_logic [current_bd_instance .] irq_logic

  # Create instance: pcie_0
  create_hier_cell_pcie_0 [current_bd_instance .] pcie_0

  # Create interface connections
  connect_bd_intf_net -intf_net axi_interconnect_1_M00_AXI [get_bd_intf_pins hispi_line_writer/s_reg_hispi] [get_bd_intf_pins pcie_0/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M01_AXI [get_bd_intf_pins hispi_line_writer/s_reg_dma] [get_bd_intf_pins pcie_0/M01_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M03_AXI [get_bd_intf_pins axi_quad_spi_0/AXI_LITE] [get_bd_intf_pins pcie_0/M02_AXI]
  connect_bd_intf_net -intf_net axi_pcie_0_pcie_7x_mgt [get_bd_intf_ports pcie] [get_bd_intf_pins pcie_0/pcie]
  connect_bd_intf_net -intf_net axi_quad_spi_0_SPI_0 [get_bd_intf_ports cfg_qspi] [get_bd_intf_pins axi_quad_spi_0/SPI_0]
  connect_bd_intf_net -intf_net axi_quad_spi_0_STARTUP_IO [get_bd_intf_ports cfg_startup_io] [get_bd_intf_pins axi_quad_spi_0/STARTUP_IO]
  connect_bd_intf_net -intf_net hispi_line_writer_m_dma [get_bd_intf_pins hispi_line_writer/m_dma] [get_bd_intf_pins pcie_0/s_axi_pcie]
  connect_bd_intf_net -intf_net s_hispi_0_1 [get_bd_intf_ports xgs] [get_bd_intf_pins hispi_line_writer/hispi]

  # Create port connections
  connect_bd_net -net axi_pcie_0_axi_ctl_aclk_out [get_bd_pins axi_quad_spi_0/s_axi_aclk] [get_bd_pins hispi_line_writer/axi_clk] [get_bd_pins pcie_0/paxiclk]
  connect_bd_net -net axi_quad_spi_0_ip2intc_irpt [get_bd_pins axi_quad_spi_0/ip2intc_irpt] [get_bd_pins irq_logic/In1]
  connect_bd_net -net clk_wiz_0_idly_clk [get_bd_pins clk_wiz_0/idly_clk] [get_bd_pins hispi_line_writer/idelay_clk]
  connect_bd_net -net clk_wiz_0_qspi_clk [get_bd_pins axi_quad_spi_0/ext_spi_clk] [get_bd_pins clk_wiz_0/qspi_clk]
  connect_bd_net -net e_n_1 [get_bd_ports ext_reset_n] [get_bd_pins clk_wiz_0/resetn] [get_bd_pins pcie_0/ext_reset_n]
  connect_bd_net -net hispi_line_writer_irq_dma [get_bd_pins hispi_line_writer/irq_dma] [get_bd_pins irq_logic/In0]
  connect_bd_net -net pcie_clk_100MHz_1 [get_bd_ports pcie_clk_100MHz] [get_bd_pins pcie_0/pcie_clk_100MHz]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins axi_quad_spi_0/s_axi_aresetn] [get_bd_pins hispi_line_writer/axi_reset_n] [get_bd_pins pcie_0/presetn]
  connect_bd_net -net ref_clk_1 [get_bd_ports ref_clk] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net util_reduced_logic_0_Res [get_bd_pins irq_logic/Res] [get_bd_pins pcie_0/host_irq]

  # Create address segments
  create_bd_addr_seg -range 0x000100000000 -offset 0x00000000 [get_bd_addr_spaces hispi_line_writer/dmawr_sub4_0/m_axi] [get_bd_addr_segs pcie_0/axi_pcie_0/S_AXI/BAR0] SEG_axi_pcie_0_BAR0
  create_bd_addr_seg -range 0x00001000 -offset 0x00020000 [get_bd_addr_spaces pcie_0/axi_pcie_0/M_AXI] [get_bd_addr_segs hispi_line_writer/axiHiSPi_0/s_axi/registerfile] SEG_axiHiSPi_0_registerfile
  create_bd_addr_seg -range 0x00010000 -offset 0x00000000 [get_bd_addr_spaces pcie_0/axi_pcie_0/M_AXI] [get_bd_addr_segs pcie_0/axi_pcie_0/S_AXI_CTL/CTL0] SEG_axi_pcie_0_CTL0
  create_bd_addr_seg -range 0x00001000 -offset 0x00010000 [get_bd_addr_spaces pcie_0/axi_pcie_0/M_AXI] [get_bd_addr_segs axi_quad_spi_0/AXI_LITE/Reg] SEG_axi_quad_spi_0_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0x00030000 [get_bd_addr_spaces pcie_0/axi_pcie_0/M_AXI] [get_bd_addr_segs hispi_line_writer/dmawr_sub4_0/s_axi/reg0] SEG_dmawr_sub4_0_reg0


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


