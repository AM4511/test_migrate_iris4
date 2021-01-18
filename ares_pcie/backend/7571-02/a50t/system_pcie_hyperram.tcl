
################################################################
# This is a generated script based on design: ares_pb
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
# source ares_pb_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7a50ticpg236-1L
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name ares_pb

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
matrox.com:user:Lpc_to_AXI_prodcons:1.1\
xilinx.com:ip:axi_ethernet:7.1\
xilinx.com:ip:axi_dma:7.1\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:axi_intc:4.1\
xilinx.com:ip:axi_quad_spi:3.2\
xilinx.com:ip:axi_timer:2.0\
xilinx.com:ip:axi_uartlite:2.0\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:mdm:3.2\
xilinx.com:ip:microblaze:11.0\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:mii_to_rmii:2.0\
matrox.com:Imaging:rpc2_ctrl_controller:1.0\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:lmb_bram_if_cntlr:4.0\
xilinx.com:ip:lmb_v10:3.0\
xilinx.com:ip:blk_mem_gen:8.4\
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
  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 DEBUG_LMB

  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 DLMB

  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 ILMB


  # Create pins
  create_bd_pin -dir I -type rst SYS_Rst
  create_bd_pin -dir I -type clk clk_100MHz

  # Create instance: dlmb_bram_if_cntlr, and set properties
  set dlmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 dlmb_bram_if_cntlr ]
  set_property -dict [ list \
   CONFIG.C_ECC {0} \
   CONFIG.C_NUM_LMB {2} \
 ] $dlmb_bram_if_cntlr

  # Create instance: dlmb_v10, and set properties
  set dlmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 dlmb_v10 ]
  set_property -dict [ list \
   CONFIG.C_LMB_NUM_SLAVES {1} \
 ] $dlmb_v10

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

  # Create instance: lmb_v10_0, and set properties
  set lmb_v10_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 lmb_v10_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn [get_bd_intf_pins dlmb_bram_if_cntlr/SLMB1] [get_bd_intf_pins lmb_v10_0/LMB_Sl_0]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins DEBUG_LMB] [get_bd_intf_pins lmb_v10_0/LMB_M]
  connect_bd_intf_net -intf_net microblaze_1_dlmb [get_bd_intf_pins DLMB] [get_bd_intf_pins dlmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_1_dlmb_bus [get_bd_intf_pins dlmb_bram_if_cntlr/SLMB] [get_bd_intf_pins dlmb_v10/LMB_Sl_0]
  connect_bd_intf_net -intf_net microblaze_1_dlmb_cntlr [get_bd_intf_pins dlmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTA]
  connect_bd_intf_net -intf_net microblaze_1_ilmb [get_bd_intf_pins ILMB] [get_bd_intf_pins ilmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_1_ilmb_bus [get_bd_intf_pins ilmb_bram_if_cntlr/SLMB] [get_bd_intf_pins ilmb_v10/LMB_Sl_0]
  connect_bd_intf_net -intf_net microblaze_1_ilmb_cntlr [get_bd_intf_pins ilmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTB]

  # Create port connections
  connect_bd_net -net SYS_Rst_1 [get_bd_pins SYS_Rst] [get_bd_pins dlmb_bram_if_cntlr/LMB_Rst] [get_bd_pins dlmb_v10/SYS_Rst] [get_bd_pins ilmb_bram_if_cntlr/LMB_Rst] [get_bd_pins ilmb_v10/SYS_Rst] [get_bd_pins lmb_v10_0/SYS_Rst]
  connect_bd_net -net microblaze_1_Clk [get_bd_pins clk_100MHz] [get_bd_pins dlmb_bram_if_cntlr/LMB_Clk] [get_bd_pins dlmb_v10/LMB_Clk] [get_bd_pins ilmb_bram_if_cntlr/LMB_Clk] [get_bd_pins ilmb_v10/LMB_Clk] [get_bd_pins lmb_v10_0/LMB_Clk]

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
  set ProdCons_0 [ create_bd_intf_port -mode Slave -vlnv matrox.com:user:regfile_valid_posreset_rtl:1.0 ProdCons_0 ]

  set ProdCons_1 [ create_bd_intf_port -mode Slave -vlnv matrox.com:user:regfile_valid_posreset_rtl:1.0 ProdCons_1 ]

  set hb [ create_bd_intf_port -mode Master -vlnv matrox.com:user:hyperbus_rtl:1.0 hb ]

  set host2axi [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 host2axi ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {1} \
   CONFIG.MAX_BURST_LENGTH {256} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $host2axi

  set ncsi [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rmii_rtl:1.0 ncsi ]

  set profinet_led [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 profinet_led ]

  set spi [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:spi_rtl:1.0 spi ]

  set startup_io [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_startup_io:startup_io_rtl:1.0 startup_io ]

  set uart [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 uart ]


  # Create ports
  set clk_100MHz [ create_bd_port -dir I -type clk clk_100MHz ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_RESET {reset_n} \
   CONFIG.FREQ_HZ {100000000} \
 ] $clk_100MHz
  set host2axi_clk [ create_bd_port -dir I -type clk host2axi_clk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_RESET {host2axi_reset_n} \
 ] $host2axi_clk
  set host2axi_reset_n [ create_bd_port -dir I -type rst host2axi_reset_n ]
  set host_irq [ create_bd_port -dir O host_irq ]
  set ncsi_clk [ create_bd_port -dir O -type clk ncsi_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {50000000} \
 ] $ncsi_clk
  set reset_n [ create_bd_port -dir I -type rst reset_n ]

  # Create instance: Lpc_to_AXI_prodcons_0, and set properties
  set Lpc_to_AXI_prodcons_0 [ create_bd_cell -type ip -vlnv matrox.com:user:Lpc_to_AXI_prodcons:1.1 Lpc_to_AXI_prodcons_0 ]

  # Create instance: Lpc_to_AXI_prodcons_1, and set properties
  set Lpc_to_AXI_prodcons_1 [ create_bd_cell -type ip -vlnv matrox.com:user:Lpc_to_AXI_prodcons:1.1 Lpc_to_AXI_prodcons_1 ]

  # Create instance: axi_ethernet_0, and set properties
  set axi_ethernet_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernet:7.1 axi_ethernet_0 ]
  set_property -dict [ list \
   CONFIG.Include_IO {false} \
   CONFIG.PHY_TYPE {MII} \
   CONFIG.Statistics_Counters {false} \
 ] $axi_ethernet_0

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet_0/axi_rxd_arstn]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet_0/axi_rxs_arstn]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet_0/axi_txc_arstn]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet_0/axi_txd_arstn]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {m_axis_rxd:m_axis_rxs:s_axis_txc:s_axis_txd} \
   CONFIG.ASSOCIATED_RESET {axi_rxd_arstn:axi_rxs_arstn:axi_txc_arstn:axi_txd_arstn} \
 ] [get_bd_pins /axi_ethernet_0/axis_clk]

  set_property -dict [ list \
   CONFIG.SENSITIVITY {LEVEL_HIGH} \
 ] [get_bd_pins /axi_ethernet_0/interrupt]

  set_property -dict [ list \
   CONFIG.SENSITIVITY {EDGE_RISING} \
 ] [get_bd_pins /axi_ethernet_0/mac_irq]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet_0/phy_rst_n]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {s_axi} \
   CONFIG.ASSOCIATED_RESET {s_axi_lite_resetn} \
 ] [get_bd_pins /axi_ethernet_0/s_axi_lite_clk]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet_0/s_axi_lite_resetn]

  # Create instance: axi_ethernet_0_dma, and set properties
  set axi_ethernet_0_dma [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_ethernet_0_dma ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s_dre {1} \
   CONFIG.c_include_s2mm_dre {1} \
   CONFIG.c_sg_length_width {16} \
   CONFIG.c_sg_use_stsapp_length {1} \
 ] $axi_ethernet_0_dma

  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {0} \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_ALL_OUTPUTS_2 {0} \
   CONFIG.C_GPIO2_WIDTH {32} \
   CONFIG.C_GPIO_WIDTH {3} \
   CONFIG.C_IS_DUAL {0} \
   CONFIG.C_TRI_DEFAULT {0xFFFFFFFF} \
   CONFIG.C_TRI_DEFAULT_2 {0xFFFFFFFF} \
 ] $axi_gpio_0

  # Create instance: axi_intc_0, and set properties
  set axi_intc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_intc_0 ]
  set_property -dict [ list \
   CONFIG.C_HAS_FAST {0} \
 ] $axi_intc_0

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {6} \
   CONFIG.SYNCHRONIZATION_STAGES {2} \
 ] $axi_interconnect_0

  # Create instance: axi_quad_spi_0, and set properties
  set axi_quad_spi_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 axi_quad_spi_0 ]
  set_property -dict [ list \
   CONFIG.C_FIFO_DEPTH {16} \
   CONFIG.C_NUM_SS_BITS {1} \
   CONFIG.C_SCK_RATIO {2} \
   CONFIG.C_SPI_MEMORY {0} \
   CONFIG.C_SPI_MODE {2} \
   CONFIG.C_TYPE_OF_AXI4_INTERFACE {0} \
   CONFIG.C_USE_STARTUP {1} \
   CONFIG.C_XIP_MODE {0} \
 ] $axi_quad_spi_0

  # Create instance: axi_timer_0, and set properties
  set axi_timer_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer_0 ]
  set_property -dict [ list \
   CONFIG.enable_timer2 {0} \
 ] $axi_timer_0

  # Create instance: axi_timer_1, and set properties
  set axi_timer_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer_1 ]
  set_property -dict [ list \
   CONFIG.enable_timer2 {0} \
 ] $axi_timer_1

  # Create instance: axi_uartlite_0, and set properties
  set axi_uartlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0 ]
  set_property -dict [ list \
   CONFIG.C_BAUDRATE {115200} \
 ] $axi_uartlite_0

  # Create instance: logic_0, and set properties
  set logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 logic_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $logic_0

  # Create instance: mdm_0, and set properties
  set mdm_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mdm:3.2 mdm_0 ]
  set_property -dict [ list \
   CONFIG.C_ADDR_SIZE {32} \
   CONFIG.C_DBG_MEM_ACCESS {1} \
   CONFIG.C_MB_DBG_PORTS {1} \
   CONFIG.C_M_AXI_ADDR_WIDTH {32} \
   CONFIG.C_S_AXI_ADDR_WIDTH {4} \
   CONFIG.C_USE_CROSS_TRIGGER {0} \
   CONFIG.C_USE_UART {1} \
 ] $mdm_0

  # Create instance: microblaze_0, and set properties
  set microblaze_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 microblaze_0 ]
  set_property -dict [ list \
   CONFIG.C_ADDR_TAG_BITS {11} \
   CONFIG.C_AREA_OPTIMIZED {2} \
   CONFIG.C_CACHE_BYTE_SIZE {32768} \
   CONFIG.C_DCACHE_ADDR_TAG {11} \
   CONFIG.C_DCACHE_BYTE_SIZE {32768} \
   CONFIG.C_DEBUG_ENABLED {1} \
   CONFIG.C_D_AXI {1} \
   CONFIG.C_D_LMB {1} \
   CONFIG.C_I_LMB {1} \
   CONFIG.C_RESET_MSR_EIP {0} \
   CONFIG.C_USE_BRANCH_TARGET_CACHE {1} \
   CONFIG.C_USE_STACK_PROTECTION {1} \
   CONFIG.G_TEMPLATE_LIST {9} \
 ] $microblaze_0

  # Create instance: microblaze_0_axi_periph, and set properties
  set microblaze_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 microblaze_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.NUM_MI {12} \
   CONFIG.NUM_SI {1} \
   CONFIG.SYNCHRONIZATION_STAGES {2} \
 ] $microblaze_0_axi_periph

  # Create instance: microblaze_0_local_memory
  create_hier_cell_microblaze_0_local_memory [current_bd_instance .] microblaze_0_local_memory

  # Create instance: microblaze_0_xlconcat, and set properties
  set microblaze_0_xlconcat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 microblaze_0_xlconcat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {7} \
 ] $microblaze_0_xlconcat

  # Create instance: mii_to_rmii_0, and set properties
  set mii_to_rmii_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mii_to_rmii:2.0 mii_to_rmii_0 ]

  # Create instance: qspi_interconnect_1, and set properties
  set qspi_interconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 qspi_interconnect_1 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {2} \
 ] $qspi_interconnect_1

  # Create instance: rpc2_ctrl_controller_0, and set properties
  set rpc2_ctrl_controller_0 [ create_bd_cell -type ip -vlnv matrox.com:Imaging:rpc2_ctrl_controller:1.0 rpc2_ctrl_controller_0 ]
  set_property -dict [ list \
   CONFIG.C_AXI_MEM_ADDR_WIDTH {25} \
   CONFIG.C_AXI_MEM_ID_WIDTH {4} \
   CONFIG.C_ENABLE_WP {true} \
   CONFIG.DPRAM_MACRO_TYPE {0} \
   CONFIG.INPUT_FIXED_DELAY {11} \
 ] $rpc2_ctrl_controller_0

  # Create instance: system_pll, and set properties
  set system_pll [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 system_pll ]
  set_property -dict [ list \
   CONFIG.CLKOUT1_DRIVES {BUFG} \
   CONFIG.CLKOUT1_JITTER {130.958} \
   CONFIG.CLKOUT1_PHASE_ERROR {98.575} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {100} \
   CONFIG.CLKOUT2_DRIVES {BUFG} \
   CONFIG.CLKOUT2_JITTER {118.758} \
   CONFIG.CLKOUT2_PHASE_ERROR {98.575} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {166.667} \
   CONFIG.CLKOUT2_REQUESTED_PHASE {90} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLKOUT3_DRIVES {BUFG} \
   CONFIG.CLKOUT3_JITTER {151.636} \
   CONFIG.CLKOUT3_PHASE_ERROR {98.575} \
   CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {50} \
   CONFIG.CLKOUT3_USED {true} \
   CONFIG.CLKOUT4_DRIVES {BUFG} \
   CONFIG.CLKOUT4_JITTER {118.758} \
   CONFIG.CLKOUT4_PHASE_ERROR {98.575} \
   CONFIG.CLKOUT4_REQUESTED_OUT_FREQ {166.667} \
   CONFIG.CLKOUT4_USED {true} \
   CONFIG.CLKOUT5_DRIVES {BUFG} \
   CONFIG.CLKOUT5_JITTER {125.247} \
   CONFIG.CLKOUT5_PHASE_ERROR {98.575} \
   CONFIG.CLKOUT5_REQUESTED_OUT_FREQ {125} \
   CONFIG.CLKOUT5_REQUESTED_PHASE {0} \
   CONFIG.CLKOUT5_USED {true} \
   CONFIG.CLKOUT6_DRIVES {BUFG} \
   CONFIG.CLKOUT6_JITTER {114.829} \
   CONFIG.CLKOUT6_PHASE_ERROR {98.575} \
   CONFIG.CLKOUT6_REQUESTED_OUT_FREQ {200.000} \
   CONFIG.CLKOUT6_USED {true} \
   CONFIG.CLKOUT7_DRIVES {BUFG} \
   CONFIG.CLKOUT7_JITTER {151.636} \
   CONFIG.CLKOUT7_PHASE_ERROR {98.575} \
   CONFIG.CLKOUT7_REQUESTED_OUT_FREQ {50} \
   CONFIG.CLKOUT7_REQUESTED_PHASE {-40} \
   CONFIG.CLKOUT7_USED {true} \
   CONFIG.CLK_OUT1_PORT {clk100MHz} \
   CONFIG.CLK_OUT2_PORT {clkHyperRam_90} \
   CONFIG.CLK_OUT3_PORT {clk50MHz} \
   CONFIG.CLK_OUT4_PORT {clkHyperRam} \
   CONFIG.CLK_OUT5_PORT {clk125MHz} \
   CONFIG.CLK_OUT6_PORT {clk200MHz} \
   CONFIG.CLK_OUT7_PORT {clk50MHz_io} \
   CONFIG.FEEDBACK_SOURCE {FDBK_AUTO} \
   CONFIG.JITTER_SEL {No_Jitter} \
   CONFIG.MMCM_BANDWIDTH {OPTIMIZED} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {10.000} \
   CONFIG.MMCM_CLKIN1_PERIOD {10.000} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.000} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {10.000} \
   CONFIG.MMCM_CLKOUT0_DUTY_CYCLE {0.5} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {6} \
   CONFIG.MMCM_CLKOUT1_DUTY_CYCLE {0.5} \
   CONFIG.MMCM_CLKOUT1_PHASE {90.000} \
   CONFIG.MMCM_CLKOUT2_DIVIDE {20} \
   CONFIG.MMCM_CLKOUT2_DUTY_CYCLE {0.5} \
   CONFIG.MMCM_CLKOUT3_DIVIDE {6} \
   CONFIG.MMCM_CLKOUT3_DUTY_CYCLE {0.5} \
   CONFIG.MMCM_CLKOUT4_DIVIDE {8} \
   CONFIG.MMCM_CLKOUT4_DUTY_CYCLE {0.5} \
   CONFIG.MMCM_CLKOUT4_PHASE {0.000} \
   CONFIG.MMCM_CLKOUT5_DIVIDE {5} \
   CONFIG.MMCM_CLKOUT5_DUTY_CYCLE {0.5} \
   CONFIG.MMCM_CLKOUT6_DIVIDE {20} \
   CONFIG.MMCM_CLKOUT6_DUTY_CYCLE {0.5} \
   CONFIG.MMCM_CLKOUT6_PHASE {-38.250} \
   CONFIG.MMCM_COMPENSATION {ZHOLD} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.NUM_OUT_CLKS {7} \
   CONFIG.OVERRIDE_MMCM {false} \
   CONFIG.PRIMITIVE {MMCM} \
   CONFIG.PRIM_SOURCE {Single_ended_clock_capable_pin} \
   CONFIG.RESET_PORT {resetn} \
   CONFIG.RESET_TYPE {ACTIVE_LOW} \
   CONFIG.SECONDARY_SOURCE {Single_ended_clock_capable_pin} \
   CONFIG.USE_MIN_POWER {true} \
   CONFIG.USE_PHASE_ALIGNMENT {true} \
 ] $system_pll

  # Create instance: system_reset, and set properties
  set system_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 system_reset ]

  # Create interface connections
  connect_bd_intf_net -intf_net S01_AXI_0_1 [get_bd_intf_ports host2axi] [get_bd_intf_pins qspi_interconnect_1/S01_AXI]
  connect_bd_intf_net -intf_net axi_ethernet_0_dma_M_AXIS_CNTRL [get_bd_intf_pins axi_ethernet_0/s_axis_txc] [get_bd_intf_pins axi_ethernet_0_dma/M_AXIS_CNTRL]
  connect_bd_intf_net -intf_net axi_ethernet_0_dma_M_AXIS_MM2S [get_bd_intf_pins axi_ethernet_0/s_axis_txd] [get_bd_intf_pins axi_ethernet_0_dma/M_AXIS_MM2S]
  connect_bd_intf_net -intf_net axi_ethernet_0_dma_M_AXI_MM2S [get_bd_intf_pins axi_ethernet_0_dma/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_0/S03_AXI]
  connect_bd_intf_net -intf_net axi_ethernet_0_dma_M_AXI_S2MM [get_bd_intf_pins axi_ethernet_0_dma/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_0/S04_AXI]
  connect_bd_intf_net -intf_net axi_ethernet_0_dma_M_AXI_SG [get_bd_intf_pins axi_ethernet_0_dma/M_AXI_SG] [get_bd_intf_pins axi_interconnect_0/S02_AXI]
  connect_bd_intf_net -intf_net axi_ethernet_0_m_axis_rxd [get_bd_intf_pins axi_ethernet_0/m_axis_rxd] [get_bd_intf_pins axi_ethernet_0_dma/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net axi_ethernet_0_m_axis_rxs [get_bd_intf_pins axi_ethernet_0/m_axis_rxs] [get_bd_intf_pins axi_ethernet_0_dma/S_AXIS_STS]
  connect_bd_intf_net -intf_net axi_ethernet_0_mii [get_bd_intf_pins axi_ethernet_0/mii] [get_bd_intf_pins mii_to_rmii_0/MII]
  connect_bd_intf_net -intf_net axi_gpio_0_GPIO [get_bd_intf_ports profinet_led] [get_bd_intf_pins axi_gpio_0/GPIO]
  connect_bd_intf_net -intf_net axi_intc_0_interrupt [get_bd_intf_pins axi_intc_0/interrupt] [get_bd_intf_pins microblaze_0/INTERRUPT]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins rpc2_ctrl_controller_0/AXIm]
  connect_bd_intf_net -intf_net axi_quad_spi_0_SPI_0 [get_bd_intf_ports spi] [get_bd_intf_pins axi_quad_spi_0/SPI_0]
  connect_bd_intf_net -intf_net axi_quad_spi_0_STARTUP_IO [get_bd_intf_ports startup_io] [get_bd_intf_pins axi_quad_spi_0/STARTUP_IO]
  connect_bd_intf_net -intf_net axi_uartlite_0_UART [get_bd_intf_ports uart] [get_bd_intf_pins axi_uartlite_0/UART]
  connect_bd_intf_net -intf_net mdm_0_LMB_0 [get_bd_intf_pins mdm_0/LMB_0] [get_bd_intf_pins microblaze_0_local_memory/DEBUG_LMB]
  connect_bd_intf_net -intf_net mdm_0_M_AXI [get_bd_intf_pins axi_interconnect_0/S05_AXI] [get_bd_intf_pins mdm_0/M_AXI]
  connect_bd_intf_net -intf_net mdm_1_MBDEBUG_0 [get_bd_intf_pins mdm_0/MBDEBUG_0] [get_bd_intf_pins microblaze_0/DEBUG]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_DC [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins microblaze_0/M_AXI_DC]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_IC [get_bd_intf_pins axi_interconnect_0/S01_AXI] [get_bd_intf_pins microblaze_0/M_AXI_IC]
  connect_bd_intf_net -intf_net microblaze_0_axi_dp [get_bd_intf_pins microblaze_0/M_AXI_DP] [get_bd_intf_pins microblaze_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M00_AXI [get_bd_intf_pins axi_intc_0/s_axi] [get_bd_intf_pins microblaze_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M01_AXI [get_bd_intf_pins axi_uartlite_0/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M02_AXI [get_bd_intf_pins axi_ethernet_0/s_axi] [get_bd_intf_pins microblaze_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M03_AXI [get_bd_intf_pins axi_ethernet_0_dma/S_AXI_LITE] [get_bd_intf_pins microblaze_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M04_AXI [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M04_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M05_AXI [get_bd_intf_pins microblaze_0_axi_periph/M05_AXI] [get_bd_intf_pins qspi_interconnect_1/S00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M06_AXI [get_bd_intf_pins mdm_0/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M06_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M07_AXI [get_bd_intf_pins Lpc_to_AXI_prodcons_0/S00_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M07_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M08_AXI [get_bd_intf_pins axi_timer_0/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M08_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M09_AXI [get_bd_intf_pins Lpc_to_AXI_prodcons_1/S00_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M09_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M10_AXI [get_bd_intf_pins axi_timer_1/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M10_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M11_AXI [get_bd_intf_pins microblaze_0_axi_periph/M11_AXI] [get_bd_intf_pins rpc2_ctrl_controller_0/AXIr]
  connect_bd_intf_net -intf_net microblaze_1_dlmb_1 [get_bd_intf_pins microblaze_0/DLMB] [get_bd_intf_pins microblaze_0_local_memory/DLMB]
  connect_bd_intf_net -intf_net microblaze_1_ilmb_1 [get_bd_intf_pins microblaze_0/ILMB] [get_bd_intf_pins microblaze_0_local_memory/ILMB]
  connect_bd_intf_net -intf_net ncsi [get_bd_intf_ports ncsi] [get_bd_intf_pins mii_to_rmii_0/RMII_PHY_M]
  connect_bd_intf_net -intf_net qspi_interconnect_1_M00_AXI [get_bd_intf_pins axi_quad_spi_0/AXI_LITE] [get_bd_intf_pins qspi_interconnect_1/M00_AXI]
  connect_bd_intf_net -intf_net rf_0_1 [get_bd_intf_ports ProdCons_0] [get_bd_intf_pins Lpc_to_AXI_prodcons_0/rf]
  connect_bd_intf_net -intf_net rf_1 [get_bd_intf_ports ProdCons_1] [get_bd_intf_pins Lpc_to_AXI_prodcons_1/rf]
  connect_bd_intf_net -intf_net rpc2_ctrl_controller_0_hb [get_bd_intf_ports hb] [get_bd_intf_pins rpc2_ctrl_controller_0/hb]

  # Create port connections
  connect_bd_net -net Lpc_to_AXI_prodcons_1_host_irq [get_bd_ports host_irq] [get_bd_pins Lpc_to_AXI_prodcons_1/host_irq]
  connect_bd_net -net S01_ACLK_0_1 [get_bd_ports host2axi_clk] [get_bd_pins qspi_interconnect_1/S01_ACLK]
  connect_bd_net -net S01_ARESETN_0_1 [get_bd_ports host2axi_reset_n] [get_bd_pins qspi_interconnect_1/S01_ARESETN]
  connect_bd_net -net aresetn_1 [get_bd_ports reset_n] [get_bd_pins system_pll/resetn] [get_bd_pins system_reset/ext_reset_in]
  connect_bd_net -net axi_ethernet_0_dma_mm2s_cntrl_reset_out_n [get_bd_pins axi_ethernet_0/axi_txc_arstn] [get_bd_pins axi_ethernet_0_dma/mm2s_cntrl_reset_out_n]
  connect_bd_net -net axi_ethernet_0_dma_mm2s_introut [get_bd_pins axi_ethernet_0_dma/mm2s_introut] [get_bd_pins microblaze_0_xlconcat/In3]
  connect_bd_net -net axi_ethernet_0_dma_mm2s_prmry_reset_out_n [get_bd_pins axi_ethernet_0/axi_txd_arstn] [get_bd_pins axi_ethernet_0_dma/mm2s_prmry_reset_out_n]
  connect_bd_net -net axi_ethernet_0_dma_s2mm_introut [get_bd_pins axi_ethernet_0_dma/s2mm_introut] [get_bd_pins microblaze_0_xlconcat/In4]
  connect_bd_net -net axi_ethernet_0_dma_s2mm_sts_reset_out_n [get_bd_pins axi_ethernet_0/axi_rxs_arstn] [get_bd_pins axi_ethernet_0_dma/s2mm_sts_reset_out_n]
  connect_bd_net -net axi_ethernet_0_fifo_s2mm_prmry_reset_out_n [get_bd_pins axi_ethernet_0/axi_rxd_arstn] [get_bd_pins axi_ethernet_0_dma/s2mm_prmry_reset_out_n]
  connect_bd_net -net axi_ethernet_0_interrupt [get_bd_pins axi_ethernet_0/interrupt] [get_bd_pins microblaze_0_xlconcat/In2]
  connect_bd_net -net axi_ethernet_0_mac_irq [get_bd_pins axi_ethernet_0/mac_irq] [get_bd_pins microblaze_0_xlconcat/In1]
  connect_bd_net -net axi_ethernet_0_phy_rst_n [get_bd_pins axi_ethernet_0/phy_rst_n] [get_bd_pins mii_to_rmii_0/rst_n]
  connect_bd_net -net axi_quad_spi_0_ip2intc_irpt [get_bd_pins axi_quad_spi_0/ip2intc_irpt] [get_bd_pins microblaze_0_xlconcat/In5]
  connect_bd_net -net axi_timer_0_interrupt [get_bd_pins axi_timer_0/interrupt] [get_bd_pins microblaze_0_xlconcat/In0]
  connect_bd_net -net clk_100MHz_1 [get_bd_ports clk_100MHz] [get_bd_pins system_pll/clk_in1]
  connect_bd_net -net clk_wiz_0_clk50MHz [get_bd_pins axi_quad_spi_0/ext_spi_clk] [get_bd_pins mii_to_rmii_0/ref_clk] [get_bd_pins system_pll/clk50MHz]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins system_pll/locked] [get_bd_pins system_reset/dcm_locked]
  connect_bd_net -net mdm_1_Interrupt [get_bd_pins mdm_0/Interrupt] [get_bd_pins microblaze_0_xlconcat/In6]
  connect_bd_net -net mdm_1_debug_sys_rst [get_bd_pins mdm_0/Debug_SYS_Rst] [get_bd_pins system_reset/mb_debug_sys_rst]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins Lpc_to_AXI_prodcons_0/s00_axi_aclk] [get_bd_pins Lpc_to_AXI_prodcons_1/s00_axi_aclk] [get_bd_pins axi_ethernet_0/axis_clk] [get_bd_pins axi_ethernet_0/s_axi_lite_clk] [get_bd_pins axi_ethernet_0_dma/m_axi_mm2s_aclk] [get_bd_pins axi_ethernet_0_dma/m_axi_s2mm_aclk] [get_bd_pins axi_ethernet_0_dma/m_axi_sg_aclk] [get_bd_pins axi_ethernet_0_dma/s_axi_lite_aclk] [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins axi_intc_0/s_axi_aclk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axi_interconnect_0/S01_ACLK] [get_bd_pins axi_interconnect_0/S02_ACLK] [get_bd_pins axi_interconnect_0/S03_ACLK] [get_bd_pins axi_interconnect_0/S04_ACLK] [get_bd_pins axi_interconnect_0/S05_ACLK] [get_bd_pins axi_quad_spi_0/s_axi_aclk] [get_bd_pins axi_timer_0/s_axi_aclk] [get_bd_pins axi_timer_1/s_axi_aclk] [get_bd_pins axi_uartlite_0/s_axi_aclk] [get_bd_pins mdm_0/M_AXI_ACLK] [get_bd_pins mdm_0/S_AXI_ACLK] [get_bd_pins microblaze_0/Clk] [get_bd_pins microblaze_0_axi_periph/ACLK] [get_bd_pins microblaze_0_axi_periph/M00_ACLK] [get_bd_pins microblaze_0_axi_periph/M01_ACLK] [get_bd_pins microblaze_0_axi_periph/M02_ACLK] [get_bd_pins microblaze_0_axi_periph/M03_ACLK] [get_bd_pins microblaze_0_axi_periph/M04_ACLK] [get_bd_pins microblaze_0_axi_periph/M05_ACLK] [get_bd_pins microblaze_0_axi_periph/M06_ACLK] [get_bd_pins microblaze_0_axi_periph/M07_ACLK] [get_bd_pins microblaze_0_axi_periph/M08_ACLK] [get_bd_pins microblaze_0_axi_periph/M09_ACLK] [get_bd_pins microblaze_0_axi_periph/M10_ACLK] [get_bd_pins microblaze_0_axi_periph/M11_ACLK] [get_bd_pins microblaze_0_axi_periph/S00_ACLK] [get_bd_pins microblaze_0_local_memory/clk_100MHz] [get_bd_pins qspi_interconnect_1/ACLK] [get_bd_pins qspi_interconnect_1/M00_ACLK] [get_bd_pins qspi_interconnect_1/S00_ACLK] [get_bd_pins rpc2_ctrl_controller_0/AXIm_ACLK] [get_bd_pins rpc2_ctrl_controller_0/AXIr_ACLK] [get_bd_pins system_pll/clk100MHz] [get_bd_pins system_reset/slowest_sync_clk]
  connect_bd_net -net microblaze_0_xlconcat_dout [get_bd_pins axi_intc_0/intr] [get_bd_pins microblaze_0_xlconcat/dout]
  connect_bd_net -net rst_ddr2_mig_0_100M_interconnect_aresetn [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins axi_interconnect_0/S01_ARESETN] [get_bd_pins axi_interconnect_0/S02_ARESETN] [get_bd_pins axi_interconnect_0/S03_ARESETN] [get_bd_pins axi_interconnect_0/S04_ARESETN] [get_bd_pins axi_quad_spi_0/s_axi_aresetn] [get_bd_pins microblaze_0_axi_periph/ARESETN] [get_bd_pins qspi_interconnect_1/ARESETN] [get_bd_pins qspi_interconnect_1/M00_ARESETN] [get_bd_pins qspi_interconnect_1/S00_ARESETN] [get_bd_pins rpc2_ctrl_controller_0/AXIm_ARESETN] [get_bd_pins rpc2_ctrl_controller_0/AXIr_ARESETN] [get_bd_pins system_reset/interconnect_aresetn]
  connect_bd_net -net rst_ddr2_mig_0_100M_peripheral_aresetn [get_bd_pins Lpc_to_AXI_prodcons_0/s00_axi_aresetn] [get_bd_pins Lpc_to_AXI_prodcons_1/s00_axi_aresetn] [get_bd_pins axi_ethernet_0/s_axi_lite_resetn] [get_bd_pins axi_ethernet_0_dma/axi_resetn] [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins axi_intc_0/s_axi_aresetn] [get_bd_pins axi_interconnect_0/S05_ARESETN] [get_bd_pins axi_timer_0/s_axi_aresetn] [get_bd_pins axi_timer_1/s_axi_aresetn] [get_bd_pins axi_uartlite_0/s_axi_aresetn] [get_bd_pins mdm_0/M_AXI_ARESETN] [get_bd_pins mdm_0/S_AXI_ARESETN] [get_bd_pins microblaze_0_axi_periph/M00_ARESETN] [get_bd_pins microblaze_0_axi_periph/M01_ARESETN] [get_bd_pins microblaze_0_axi_periph/M02_ARESETN] [get_bd_pins microblaze_0_axi_periph/M03_ARESETN] [get_bd_pins microblaze_0_axi_periph/M04_ARESETN] [get_bd_pins microblaze_0_axi_periph/M05_ARESETN] [get_bd_pins microblaze_0_axi_periph/M06_ARESETN] [get_bd_pins microblaze_0_axi_periph/M07_ARESETN] [get_bd_pins microblaze_0_axi_periph/M08_ARESETN] [get_bd_pins microblaze_0_axi_periph/M09_ARESETN] [get_bd_pins microblaze_0_axi_periph/M10_ARESETN] [get_bd_pins microblaze_0_axi_periph/M11_ARESETN] [get_bd_pins microblaze_0_axi_periph/S00_ARESETN] [get_bd_pins system_reset/peripheral_aresetn]
  connect_bd_net -net system_pll_clk125MHz [get_bd_pins axi_ethernet_0/gtx_clk] [get_bd_pins system_pll/clk125MHz]
  connect_bd_net -net system_pll_clk200MHz [get_bd_pins rpc2_ctrl_controller_0/rpc_clk200MHz] [get_bd_pins system_pll/clk200MHz]
  connect_bd_net -net system_pll_clk50MHz_io [get_bd_ports ncsi_clk] [get_bd_pins system_pll/clk50MHz_io]
  connect_bd_net -net system_pll_clkHyperRam [get_bd_pins rpc2_ctrl_controller_0/rpc_clk166MHz] [get_bd_pins system_pll/clkHyperRam]
  connect_bd_net -net system_pll_clkHyperRam_90 [get_bd_pins rpc2_ctrl_controller_0/rpc_clk166MHz_90] [get_bd_pins system_pll/clkHyperRam_90]
  connect_bd_net -net system_reset_bus_struct_reset [get_bd_pins microblaze_0_local_memory/SYS_Rst] [get_bd_pins system_reset/bus_struct_reset]
  connect_bd_net -net system_reset_mb_reset [get_bd_pins microblaze_0/Reset] [get_bd_pins system_reset/mb_reset]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins axi_ethernet_0/mdio_mdio_i] [get_bd_pins logic_0/dout]

  # Create address segments
  create_bd_addr_seg -range 0x04000000 -offset 0x80000000 [get_bd_addr_spaces axi_ethernet_0_dma/Data_SG] [get_bd_addr_segs rpc2_ctrl_controller_0/AXIm/Mem] SEG_rpc2_ctrl_controller_0_Mem
  create_bd_addr_seg -range 0x04000000 -offset 0x80000000 [get_bd_addr_spaces axi_ethernet_0_dma/Data_MM2S] [get_bd_addr_segs rpc2_ctrl_controller_0/AXIm/Mem] SEG_rpc2_ctrl_controller_0_Mem
  create_bd_addr_seg -range 0x04000000 -offset 0x80000000 [get_bd_addr_spaces axi_ethernet_0_dma/Data_S2MM] [get_bd_addr_segs rpc2_ctrl_controller_0/AXIm/Mem] SEG_rpc2_ctrl_controller_0_Mem
  create_bd_addr_seg -range 0x00008000 -offset 0x00000000 [get_bd_addr_spaces mdm_0/Data] [get_bd_addr_segs microblaze_0_local_memory/dlmb_bram_if_cntlr/SLMB1/Mem] SEG_dlmb_bram_if_cntlr_Mem
  create_bd_addr_seg -range 0x04000000 -offset 0x80000000 [get_bd_addr_spaces mdm_0/Data] [get_bd_addr_segs rpc2_ctrl_controller_0/AXIm/Mem] SEG_rpc2_ctrl_controller_0_Mem
  create_bd_addr_seg -range 0x00010000 -offset 0x44A00000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs Lpc_to_AXI_prodcons_0/S00_AXI/S00_AXI_reg] SEG_Lpc_to_AXI_prodcons_0_S00_AXI_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x44A10000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs Lpc_to_AXI_prodcons_1/S00_AXI/S00_AXI_reg] SEG_Lpc_to_AXI_prodcons_1_S00_AXI_reg
  create_bd_addr_seg -range 0x00040000 -offset 0x40C00000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_ethernet_0/s_axi/Reg0] SEG_axi_ethernet_0_Reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x41E00000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_ethernet_0_dma/S_AXI_LITE/Reg] SEG_axi_ethernet_0_dma_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] SEG_axi_gpio_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41200000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_intc_0/S_AXI/Reg] SEG_axi_intc_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x45000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_quad_spi_0/AXI_LITE/Reg] SEG_axi_quad_spi_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41C00000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_timer_0/S_AXI/Reg] SEG_axi_timer_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41C10000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_timer_1/S_AXI/Reg] SEG_axi_timer_1_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40600000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_uartlite_0/S_AXI/Reg] SEG_axi_uartlite_0_Reg
  create_bd_addr_seg -range 0x00008000 -offset 0x00000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs microblaze_0_local_memory/dlmb_bram_if_cntlr/SLMB/Mem] SEG_dlmb_bram_if_cntlr_Mem
  create_bd_addr_seg -range 0x00008000 -offset 0x00000000 [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs microblaze_0_local_memory/ilmb_bram_if_cntlr/SLMB/Mem] SEG_ilmb_bram_if_cntlr_Mem
  create_bd_addr_seg -range 0x00001000 -offset 0x41400000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs mdm_0/S_AXI/Reg] SEG_mdm_1_Reg
  create_bd_addr_seg -range 0x04000000 -offset 0x80000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs rpc2_ctrl_controller_0/AXIm/Mem] SEG_rpc2_ctrl_controller_0_Mem
  create_bd_addr_seg -range 0x04000000 -offset 0x80000000 [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs rpc2_ctrl_controller_0/AXIm/Mem] SEG_rpc2_ctrl_controller_0_Mem
  create_bd_addr_seg -range 0x00001000 -offset 0x46000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs rpc2_ctrl_controller_0/AXIr/reg] SEG_rpc2_ctrl_controller_0_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x45000000 [get_bd_addr_spaces host2axi] [get_bd_addr_segs axi_quad_spi_0/AXI_LITE/Reg] SEG_axi_quad_spi_0_Reg

  # Exclude Address Segments
  create_bd_addr_seg -range 0x00010000 -offset 0x44A30000 [get_bd_addr_spaces axi_ethernet_0_dma/Data_MM2S] [get_bd_addr_segs rpc2_ctrl_controller_0/AXIr/reg] SEG_rpc2_ctrl_controller_0_reg
  exclude_bd_addr_seg [get_bd_addr_segs axi_ethernet_0_dma/Data_MM2S/SEG_rpc2_ctrl_controller_0_reg]

  create_bd_addr_seg -range 0x00010000 -offset 0x44A30000 [get_bd_addr_spaces axi_ethernet_0_dma/Data_S2MM] [get_bd_addr_segs rpc2_ctrl_controller_0/AXIr/reg] SEG_rpc2_ctrl_controller_0_reg
  exclude_bd_addr_seg [get_bd_addr_segs axi_ethernet_0_dma/Data_S2MM/SEG_rpc2_ctrl_controller_0_reg]

  create_bd_addr_seg -range 0x00010000 -offset 0x44A30000 [get_bd_addr_spaces axi_ethernet_0_dma/Data_SG] [get_bd_addr_segs rpc2_ctrl_controller_0/AXIr/reg] SEG_rpc2_ctrl_controller_0_reg
  exclude_bd_addr_seg [get_bd_addr_segs axi_ethernet_0_dma/Data_SG/SEG_rpc2_ctrl_controller_0_reg]



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


