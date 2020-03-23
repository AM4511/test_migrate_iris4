
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
matrox.com:user:axiXGS_controller:1.0\
matrox.com:fdklib:dmawr_sub4:3.0\
xilinx.com:ip:axi_pcie:2.9\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:processing_system7:5.5\
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


# Hierarchical cell: zynq_system
proc create_hier_cell_zynq_system { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_zynq_system() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_GP

  create_bd_intf_pin -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 ZYNQ_FIXED_IO


  # Create pins
  create_bd_pin -dir I -type rst pcie_reset_n
  create_bd_pin -dir O -type clk zclk_100MHz
  create_bd_pin -dir O -type clk zclk_200MHz
  create_bd_pin -dir O -type clk zclk_62_5MHz
  create_bd_pin -dir O -from 0 -to 0 -type rst zreset625_interc
  create_bd_pin -dir O -from 0 -to 0 -type rst zreset625_periph
  create_bd_pin -dir O -from 0 -to 0 -type rst zresetn_interc
  create_bd_pin -dir O -from 0 -to 0 -type rst zresetn_periph

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
   CONFIG.PCW_ACT_APU_PERIPHERAL_FREQMHZ {666.666687} \
   CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.158730} \
   CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {62.500000} \
   CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {50.000000} \
   CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_TTC0_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC0_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC0_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {50.000000} \
   CONFIG.PCW_ACT_WDT_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ARMPLL_CTRL_FBDIV {40} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_CLK0_FREQ {100000000} \
   CONFIG.PCW_CLK1_FREQ {200000000} \
   CONFIG.PCW_CLK2_FREQ {62500000} \
   CONFIG.PCW_CLK3_FREQ {10000000} \
   CONFIG.PCW_CPU_CPU_PLL_FREQMHZ {1333.333} \
   CONFIG.PCW_CPU_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR0 {15} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR1 {7} \
   CONFIG.PCW_DDRPLL_CTRL_FBDIV {32} \
   CONFIG.PCW_DDR_DDR_PLL_FREQMHZ {1066.667} \
   CONFIG.PCW_DDR_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_DDR_RAM_HIGHADDR {0x3FFFFFFF} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_EN_CLK1_PORT {1} \
   CONFIG.PCW_EN_CLK2_PORT {1} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR1 {2} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR0 {4} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR1 {4} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK_CLK1_BUF {TRUE} \
   CONFIG.PCW_FCLK_CLK2_BUF {FALSE} \
   CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {62.5} \
   CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK1_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK2_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK3_ENABLE {0} \
   CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_IOPLL_CTRL_FBDIV {30} \
   CONFIG.PCW_IO_IO_PLL_FREQMHZ {1000.000} \
   CONFIG.PCW_PCAP_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_QSPI_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_SDIO_PERIPHERAL_DIVISOR0 {20} \
   CONFIG.PCW_SMC_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SPI_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TPIU_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_UART_PERIPHERAL_DIVISOR0 {20} \
   CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {533.333374} \
   CONFIG.PCW_UIPARAM_DDR_BANK_ADDR_COUNT {3} \
   CONFIG.PCW_UIPARAM_DDR_CL {7} \
   CONFIG.PCW_UIPARAM_DDR_COL_ADDR_COUNT {10} \
   CONFIG.PCW_UIPARAM_DDR_CWL {6} \
   CONFIG.PCW_UIPARAM_DDR_DEVICE_CAPACITY {2048 MBits} \
   CONFIG.PCW_UIPARAM_DDR_DRAM_WIDTH {8 Bits} \
   CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41J256M8 HX-15E} \
   CONFIG.PCW_UIPARAM_DDR_ROW_ADDR_COUNT {15} \
   CONFIG.PCW_UIPARAM_DDR_SPEED_BIN {DDR3_1066F} \
   CONFIG.PCW_UIPARAM_DDR_T_FAW {30.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RAS_MIN {36.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RC {49.5} \
   CONFIG.PCW_UIPARAM_DDR_T_RCD {7} \
   CONFIG.PCW_UIPARAM_DDR_T_RP {7} \
 ] $processing_system7_0

  # Create instance: reset_62_5MHz, and set properties
  set reset_62_5MHz [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 reset_62_5MHz ]

  # Create instance: rst_100MHz, and set properties
  set rst_100MHz [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_100MHz ]

  # Create interface connections
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_pins DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_pins ZYNQ_FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins M_AXI_GP] [get_bd_intf_pins processing_system7_0/M_AXI_GP0]

  # Create port connections
  connect_bd_net -net pcie_reset_n_1 [get_bd_pins pcie_reset_n] [get_bd_pins reset_62_5MHz/ext_reset_in]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins zclk_100MHz] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins rst_100MHz/slowest_sync_clk]
  connect_bd_net -net processing_system7_0_FCLK_CLK1 [get_bd_pins zclk_200MHz] [get_bd_pins processing_system7_0/FCLK_CLK1]
  connect_bd_net -net processing_system7_0_FCLK_CLK2 [get_bd_pins zclk_62_5MHz] [get_bd_pins processing_system7_0/FCLK_CLK2] [get_bd_pins reset_62_5MHz/slowest_sync_clk]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins reset_62_5MHz/aux_reset_in] [get_bd_pins rst_100MHz/ext_reset_in]
  connect_bd_net -net reset_62_5MHz_interconnect_aresetn [get_bd_pins zreset625_interc] [get_bd_pins reset_62_5MHz/interconnect_aresetn]
  connect_bd_net -net reset_62_5MHz_peripheral_aresetn [get_bd_pins zreset625_periph] [get_bd_pins reset_62_5MHz/peripheral_aresetn]
  connect_bd_net -net rst_100MHz_interconnect_aresetn [get_bd_pins zresetn_interc] [get_bd_pins rst_100MHz/interconnect_aresetn]
  connect_bd_net -net rst_ps7_0_50M_peripheral_aresetn [get_bd_pins zresetn_periph] [get_bd_pins rst_100MHz/peripheral_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: pcie_system
proc create_hier_cell_pcie_system { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_pcie_system() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_CTL

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie_mgt


  # Create pins
  create_bd_pin -dir O -type clk axi_ctl_aclk_out
  create_bd_pin -dir O -from 0 -to 0 -type rst interconnect_aresetn
  create_bd_pin -dir I -type clk pcie_clk100MHz
  create_bd_pin -dir I -type rst pcie_reset_in
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn
  create_bd_pin -dir O -type clk slowest_sync_clk

  # Create instance: axi_pcie_0, and set properties
  set axi_pcie_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_pcie:2.9 axi_pcie_0 ]
  set_property -dict [ list \
   CONFIG.AXIBAR_AS_0 {true} \
   CONFIG.BAR0_SCALE {Megabytes} \
   CONFIG.BAR0_SIZE {32} \
   CONFIG.BASE_CLASS_MENU {Input_devices} \
   CONFIG.CLASS_CODE {0x098000} \
   CONFIG.DEVICE_ID {0xaaaa} \
   CONFIG.ENABLE_CLASS_CODE {false} \
   CONFIG.INTERRUPT_PIN {false} \
   CONFIG.MAX_LINK_SPEED {2.5_GT/s} \
   CONFIG.M_AXI_DATA_WIDTH {64} \
   CONFIG.NO_OF_LANES {X1} \
   CONFIG.REV_ID {0x55} \
   CONFIG.SUBSYSTEM_ID {0xa5a5} \
   CONFIG.SUBSYSTEM_VENDOR_ID {0x102b} \
   CONFIG.SUB_CLASS_INTERFACE_MENU {Other_input_controller} \
   CONFIG.S_AXI_DATA_WIDTH {64} \
   CONFIG.S_AXI_SUPPORTS_NARROW_BURST {true} \
   CONFIG.VENDOR_ID {0x102b} \
   CONFIG.XLNX_REF_BOARD {ZC706} \
 ] $axi_pcie_0

  # Create instance: rst_axi_pcie_0_125M, and set properties
  set rst_axi_pcie_0_125M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_axi_pcie_0_125M ]
  set_property -dict [ list \
   CONFIG.RESET_BOARD_INTERFACE {reset} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $rst_axi_pcie_0_125M

  # Create interface connections
  connect_bd_intf_net -intf_net axi_interconnect_0_M03_AXI [get_bd_intf_pins S_AXI_CTL] [get_bd_intf_pins axi_pcie_0/S_AXI_CTL]
  connect_bd_intf_net -intf_net axi_pcie_0_M_AXI [get_bd_intf_pins M_AXI] [get_bd_intf_pins axi_pcie_0/M_AXI]
  connect_bd_intf_net -intf_net axi_pcie_0_pcie_7x_mgt [get_bd_intf_pins pcie_mgt] [get_bd_intf_pins axi_pcie_0/pcie_7x_mgt]
  connect_bd_intf_net -intf_net dmawr_sub4_0_m_axi [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_pcie_0/S_AXI]

  # Create port connections
  connect_bd_net -net ACLK_1 [get_bd_pins slowest_sync_clk] [get_bd_pins axi_pcie_0/axi_aclk_out] [get_bd_pins rst_axi_pcie_0_125M/slowest_sync_clk]
  connect_bd_net -net S00_ARESETN_1 [get_bd_pins interconnect_aresetn] [get_bd_pins rst_axi_pcie_0_125M/interconnect_aresetn]
  connect_bd_net -net axi_pcie_0_axi_ctl_aclk_out [get_bd_pins axi_ctl_aclk_out] [get_bd_pins axi_pcie_0/axi_ctl_aclk_out]
  connect_bd_net -net axi_pcie_0_mmcm_lock [get_bd_pins axi_pcie_0/mmcm_lock] [get_bd_pins rst_axi_pcie_0_125M/dcm_locked]
  connect_bd_net -net clk_100MHz_1 [get_bd_pins pcie_clk100MHz] [get_bd_pins axi_pcie_0/REFCLK]
  connect_bd_net -net rst_axi_pcie_0_125M_peripheral_aresetn [get_bd_pins peripheral_aresetn] [get_bd_pins axi_pcie_0/axi_aresetn] [get_bd_pins rst_axi_pcie_0_125M/peripheral_aresetn]
  connect_bd_net -net zynq_system_zresetn [get_bd_pins pcie_reset_in] [get_bd_pins rst_axi_pcie_0_125M/ext_reset_in]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: grab_path
proc create_hier_cell_grab_path { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_grab_path() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Master -vlnv matrox.com:user:Athena2Ares_if_rtl:1.0 anput_if

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi2

  create_bd_intf_pin -mode Master -vlnv matrox.com:user:XGS_controller_if_rtl:1.0 xgs_ctrl

  create_bd_intf_pin -mode Slave -vlnv matrox.com:user:hispi_if_rtl:1.0 xgs_hispi


  # Create pins
  create_bd_pin -dir I -type clk idelay_clk
  create_bd_pin -dir O -type intr irq_dma
  create_bd_pin -dir O -from 1 -to 0 led_out
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn
  create_bd_pin -dir I -type clk sysclk
  create_bd_pin -dir I -type rst sysrstN

  # Create instance: axiHiSPi_0, and set properties
  set axiHiSPi_0 [ create_bd_cell -type ip -vlnv matrox.com:Imaging:axiHiSPi:1.1.1 axiHiSPi_0 ]

  # Create instance: axiXGS_controller_0, and set properties
  set axiXGS_controller_0 [ create_bd_cell -type ip -vlnv matrox.com:user:axiXGS_controller:1.0 axiXGS_controller_0 ]
  set_property -dict [ list \
   CONFIG.G_KU706 {1} \
 ] $axiXGS_controller_0

  # Create instance: dmawr_sub4_0, and set properties
  set dmawr_sub4_0 [ create_bd_cell -type ip -vlnv matrox.com:fdklib:dmawr_sub4:3.0 dmawr_sub4_0 ]
  set_property -dict [ list \
   CONFIG.AXI_ADDR_WIDTH {32} \
   CONFIG.AXI_DATA_WIDTH {64} \
 ] $dmawr_sub4_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins axiXGS_controller_0/S_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins anput_if] [get_bd_intf_pins axiXGS_controller_0/Anput_if]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins xgs_ctrl] [get_bd_intf_pins axiXGS_controller_0/XGS_controller_if]
  connect_bd_intf_net -intf_net axiHiSPi_0_m_axis [get_bd_intf_pins axiHiSPi_0/m_axis] [get_bd_intf_pins dmawr_sub4_0/s_axis]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins s_axi1] [get_bd_intf_pins axiHiSPi_0/s_axi]
  connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI [get_bd_intf_pins s_axi2] [get_bd_intf_pins dmawr_sub4_0/s_axi]
  connect_bd_intf_net -intf_net dmawr_sub4_0_m_axi [get_bd_intf_pins m_axi] [get_bd_intf_pins dmawr_sub4_0/m_axi]
  connect_bd_intf_net -intf_net s_hispi_0_1 [get_bd_intf_pins xgs_hispi] [get_bd_intf_pins axiHiSPi_0/s_hispi]

  # Create port connections
  connect_bd_net -net ACLK_1 [get_bd_pins sysclk] [get_bd_pins axiHiSPi_0/axi_clk] [get_bd_pins dmawr_sub4_0/sysclk]
  connect_bd_net -net axiXGS_controller_0_led_out [get_bd_pins led_out] [get_bd_pins axiXGS_controller_0/led_out]
  connect_bd_net -net dmawr_sub4_0_intevent [get_bd_pins irq_dma] [get_bd_pins dmawr_sub4_0/intevent]
  connect_bd_net -net processing_system7_0_FCLK_CLK1 [get_bd_pins idelay_clk] [get_bd_pins axiHiSPi_0/idelay_clk]
  connect_bd_net -net rst_axi_pcie_0_125M_peripheral_aresetn [get_bd_pins sysrstN] [get_bd_pins axiHiSPi_0/axi_reset_n] [get_bd_pins dmawr_sub4_0/sysrstN]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins axiXGS_controller_0/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins axiXGS_controller_0/s_axi_aresetn]

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
  set PS_DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 PS_DDR ]

  set PS_FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 PS_FIXED_IO ]

  set anput_if [ create_bd_intf_port -mode Master -vlnv matrox.com:user:Athena2Ares_if_rtl:1.0 anput_if ]

  set pcie [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie ]

  set xgs [ create_bd_intf_port -mode Slave -vlnv matrox.com:user:hispi_if_rtl:1.0 xgs ]

  set xgs_ctrl [ create_bd_intf_port -mode Master -vlnv matrox.com:user:XGS_controller_if_rtl:1.0 xgs_ctrl ]


  # Create ports
  set led_out [ create_bd_port -dir O -from 1 -to 0 led_out ]
  set pcie_clk100MHz [ create_bd_port -dir I -type clk pcie_clk100MHz ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
 ] $pcie_clk100MHz
  set pcie_reset_n [ create_bd_port -dir I -type rst pcie_reset_n ]

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {4} \
   CONFIG.NUM_SI {2} \
 ] $axi_interconnect_0

  # Create instance: grab_path
  create_hier_cell_grab_path [current_bd_instance .] grab_path

  # Create instance: pcie_system
  create_hier_cell_pcie_system [current_bd_instance .] pcie_system

  # Create instance: zynq_system
  create_hier_cell_zynq_system [current_bd_instance .] zynq_system

  # Create interface connections
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins grab_path/s_axi1]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins axi_interconnect_0/M01_AXI] [get_bd_intf_pins grab_path/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI [get_bd_intf_pins axi_interconnect_0/M02_AXI] [get_bd_intf_pins grab_path/s_axi2]
  connect_bd_intf_net -intf_net axi_interconnect_0_M03_AXI [get_bd_intf_pins axi_interconnect_0/M03_AXI] [get_bd_intf_pins pcie_system/S_AXI_CTL]
  connect_bd_intf_net -intf_net axi_pcie_0_M_AXI [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins pcie_system/M_AXI]
  connect_bd_intf_net -intf_net axi_pcie_0_pcie_7x_mgt [get_bd_intf_ports pcie] [get_bd_intf_pins pcie_system/pcie_mgt]
  connect_bd_intf_net -intf_net dmawr_sub4_0_m_axi [get_bd_intf_pins grab_path/m_axi] [get_bd_intf_pins pcie_system/S_AXI]
  connect_bd_intf_net -intf_net grab_path_anput_if [get_bd_intf_ports anput_if] [get_bd_intf_pins grab_path/anput_if]
  connect_bd_intf_net -intf_net grab_path_xgs_ctrl [get_bd_intf_ports xgs_ctrl] [get_bd_intf_pins grab_path/xgs_ctrl]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports PS_FIXED_IO] [get_bd_intf_pins zynq_system/ZYNQ_FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins axi_interconnect_0/S01_AXI] [get_bd_intf_pins zynq_system/M_AXI_GP]
  connect_bd_intf_net -intf_net s_hispi_0_1 [get_bd_intf_ports xgs] [get_bd_intf_pins grab_path/xgs_hispi]
  connect_bd_intf_net -intf_net zynq_system_DDR [get_bd_intf_ports PS_DDR] [get_bd_intf_pins zynq_system/DDR]

  # Create port connections
  connect_bd_net -net ACLK_1 [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M02_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins grab_path/sysclk] [get_bd_pins pcie_system/slowest_sync_clk]
  connect_bd_net -net M01_ARESETN_1 [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins zynq_system/zreset625_interc]
  connect_bd_net -net S00_ARESETN_1 [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M02_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins pcie_system/interconnect_aresetn]
  connect_bd_net -net axi_pcie_0_axi_ctl_aclk_out [get_bd_pins axi_interconnect_0/M03_ACLK] [get_bd_pins pcie_system/axi_ctl_aclk_out]
  connect_bd_net -net clk_100MHz_1 [get_bd_ports pcie_clk100MHz] [get_bd_pins pcie_system/pcie_clk100MHz]
  connect_bd_net -net grab_path_led_out [get_bd_ports led_out] [get_bd_pins grab_path/led_out]
  connect_bd_net -net pcie_reset_n_1 [get_bd_ports pcie_reset_n] [get_bd_pins pcie_system/pcie_reset_in] [get_bd_pins zynq_system/pcie_reset_n]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi_interconnect_0/S01_ACLK] [get_bd_pins zynq_system/zclk_100MHz]
  connect_bd_net -net processing_system7_0_FCLK_CLK1 [get_bd_pins grab_path/idelay_clk] [get_bd_pins zynq_system/zclk_200MHz]
  connect_bd_net -net rst_axi_pcie_0_125M_peripheral_aresetn [get_bd_pins axi_interconnect_0/M03_ARESETN] [get_bd_pins grab_path/sysrstN] [get_bd_pins pcie_system/peripheral_aresetn]
  connect_bd_net -net zynq_hier_0_interconnect_aresetn_0 [get_bd_pins axi_interconnect_0/S01_ARESETN] [get_bd_pins zynq_system/zresetn_interc]
  connect_bd_net -net zynq_system_CLK62_5MHz [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins grab_path/s_axi_aclk] [get_bd_pins zynq_system/zclk_62_5MHz]
  connect_bd_net -net zynq_system_zreset625_periph [get_bd_pins grab_path/s_axi_aresetn] [get_bd_pins zynq_system/zreset625_periph]

  # Create address segments
  create_bd_addr_seg -range 0x000100000000 -offset 0x00000000 [get_bd_addr_spaces grab_path/dmawr_sub4_0/m_axi] [get_bd_addr_segs pcie_system/axi_pcie_0/S_AXI/BAR0] SEG_axi_pcie_0_BAR0
  create_bd_addr_seg -range 0x00001000 -offset 0x50000000 [get_bd_addr_spaces pcie_system/axi_pcie_0/M_AXI] [get_bd_addr_segs grab_path/axiHiSPi_0/s_axi/registerfile] SEG_axiHiSPi_0_registerfile
  create_bd_addr_seg -range 0x00010000 -offset 0x50020000 [get_bd_addr_spaces pcie_system/axi_pcie_0/M_AXI] [get_bd_addr_segs grab_path/axiXGS_controller_0/S_AXI/S_AXI_reg] SEG_axiXGS_controller_0_S_AXI_reg
  create_bd_addr_seg -range 0x10000000 -offset 0x40000000 [get_bd_addr_spaces pcie_system/axi_pcie_0/M_AXI] [get_bd_addr_segs pcie_system/axi_pcie_0/S_AXI_CTL/CTL0] SEG_axi_pcie_0_CTL0
  create_bd_addr_seg -range 0x00001000 -offset 0x50010000 [get_bd_addr_spaces pcie_system/axi_pcie_0/M_AXI] [get_bd_addr_segs grab_path/dmawr_sub4_0/s_axi/reg0] SEG_dmawr_sub4_0_reg0
  create_bd_addr_seg -range 0x00001000 -offset 0x50000000 [get_bd_addr_spaces zynq_system/processing_system7_0/Data] [get_bd_addr_segs grab_path/axiHiSPi_0/s_axi/registerfile] SEG_axiHiSPi_0_registerfile
  create_bd_addr_seg -range 0x00010000 -offset 0x50020000 [get_bd_addr_spaces zynq_system/processing_system7_0/Data] [get_bd_addr_segs grab_path/axiXGS_controller_0/S_AXI/S_AXI_reg] SEG_axiXGS_controller_0_S_AXI_reg
  create_bd_addr_seg -range 0x10000000 -offset 0x40000000 [get_bd_addr_spaces zynq_system/processing_system7_0/Data] [get_bd_addr_segs pcie_system/axi_pcie_0/S_AXI_CTL/CTL0] SEG_axi_pcie_0_CTL0
  create_bd_addr_seg -range 0x00001000 -offset 0x50010000 [get_bd_addr_spaces zynq_system/processing_system7_0/Data] [get_bd_addr_segs grab_path/dmawr_sub4_0/s_axi/reg0] SEG_dmawr_sub4_0_reg0


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


