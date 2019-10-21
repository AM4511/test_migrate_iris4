
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
   create_project project_1 myproj -part xc7a35ticpg236-1L
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
matrox.com:Imaging:axiMaio:1.7\
xilinx.com:ip:axi_pcie:2.9\
xilinx.com:ip:axi_quad_spi:3.2\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:proc_sys_reset:5.0\
matrox.com:Imaging:axiHiSPi:1.1.1\
xilinx.com:ip:axi_mm2s_mapper:1.1\
xilinx.com:ip:util_reduced_logic:2.0\
xilinx.com:ip:xlconcat:2.1\
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
  create_bd_pin -dir I -from 7 -to 0 irq_spi
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
   CONFIG.C_SIZE {29} \
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
   CONFIG.IN7_WIDTH {8} \
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
  connect_bd_net -net In7_0_1 [get_bd_pins irq_spi] [get_bd_pins xlconcat_0/In7]
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi


  # Create pins
  create_bd_pin -dir I -type clk axi_clk
  create_bd_pin -dir I -type rst axi_reset_n
  create_bd_pin -dir I -from 5 -to 0 hispi_data_n_0
  create_bd_pin -dir I -from 5 -to 0 hispi_data_p_0
  create_bd_pin -dir I -from 5 -to 0 hispi_serial_clk_n_0
  create_bd_pin -dir I -from 5 -to 0 hispi_serial_clk_p_0

  # Create instance: axiHiSPi_0, and set properties
  set axiHiSPi_0 [ create_bd_cell -type ip -vlnv matrox.com:Imaging:axiHiSPi:1.1.1 axiHiSPi_0 ]

  # Create instance: axi_mm2s_mapper_0, and set properties
  set axi_mm2s_mapper_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_mm2s_mapper:1.1 axi_mm2s_mapper_0 ]
  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.INTERFACES {M_AXI} \
   CONFIG.TDATA_NUM_BYTES {8} \
 ] $axi_mm2s_mapper_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins M_AXI] [get_bd_intf_pins axi_mm2s_mapper_0/M_AXI]
  connect_bd_intf_net -intf_net axiHiSPi_0_m_axis [get_bd_intf_pins axiHiSPi_0/m_axis] [get_bd_intf_pins axi_mm2s_mapper_0/S_AXIS]
  connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI [get_bd_intf_pins s_axi] [get_bd_intf_pins axiHiSPi_0/s_axi]
  connect_bd_intf_net -intf_net axi_mm2s_mapper_0_M_AXIS [get_bd_intf_pins axiHiSPi_0/s_axis] [get_bd_intf_pins axi_mm2s_mapper_0/M_AXIS]

  # Create port connections
  connect_bd_net -net Profinet_axi_clk_100MHz1 [get_bd_pins axi_clk] [get_bd_pins axiHiSPi_0/axi_clk] [get_bd_pins axi_mm2s_mapper_0/aclk]
  connect_bd_net -net hispi_data_n_0_1 [get_bd_pins hispi_data_n_0] [get_bd_pins axiHiSPi_0/hispi_data_n]
  connect_bd_net -net hispi_data_p_0_1 [get_bd_pins hispi_data_p_0] [get_bd_pins axiHiSPi_0/hispi_data_p]
  connect_bd_net -net hispi_serial_clk_n_0_1 [get_bd_pins hispi_serial_clk_n_0] [get_bd_pins axiHiSPi_0/hispi_serial_clk_n]
  connect_bd_net -net hispi_serial_clk_p_0_1 [get_bd_pins hispi_serial_clk_p_0] [get_bd_pins axiHiSPi_0/hispi_serial_clk_p]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins axi_reset_n] [get_bd_pins axiHiSPi_0/axi_reset_n] [get_bd_pins axi_mm2s_mapper_0/aresetn]

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
  set SPI_0_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:spi_rtl:1.0 SPI_0_0 ]

  set STARTUP_IO_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_startup_io:startup_io_rtl:1.0 STARTUP_IO_0 ]

  set ext_sync_0 [ create_bd_intf_port -mode Master -vlnv matrox.com:user:ext_sync_rtl:1.0 ext_sync_0 ]

  set pcie [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie ]


  # Create ports
  set PCIE_REFCLK_100MHz [ create_bd_port -dir I -type clk PCIE_REFCLK_100MHz ]
  set PCIE_RESET_N [ create_bd_port -dir I -type rst PCIE_RESET_N ]
  set hispi_data_n_0 [ create_bd_port -dir I -from 5 -to 0 hispi_data_n_0 ]
  set hispi_data_p_0 [ create_bd_port -dir I -from 5 -to 0 hispi_data_p_0 ]
  set hispi_serial_clk_n_0 [ create_bd_port -dir I -from 5 -to 0 hispi_serial_clk_n_0 ]
  set hispi_serial_clk_p_0 [ create_bd_port -dir I -from 5 -to 0 hispi_serial_clk_p_0 ]
  set ref_clk [ create_bd_port -dir I -type clk ref_clk ]
  set user_data_in [ create_bd_port -dir I -from 3 -to 0 user_data_in ]
  set user_data_out [ create_bd_port -dir O -from 2 -to 0 user_data_out ]

  # Create instance: axiMaio_0, and set properties
  set axiMaio_0 [ create_bd_cell -type ip -vlnv matrox.com:Imaging:axiMaio:1.7 axiMaio_0 ]
  set_property -dict [ list \
   CONFIG.NUM_QUAD_DEC {1} \
   CONFIG.NUM_TICK_TABLE {1} \
   CONFIG.NUM_TIMER {8} \
   CONFIG.NUM_TOE_CONTROLLER {0} \
   CONFIG.NUM_USER_INPUT {4} \
   CONFIG.NUM_USER_OUTPUT {3} \
   CONFIG.TICK_TABLE_WIDTH {4} \
 ] $axiMaio_0

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {5} \
   CONFIG.NUM_SI {2} \
 ] $axi_interconnect_0

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
   CONFIG.HIGHADDR {0x40000FFF} \
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
   CONFIG.CLKOUT2_JITTER {151.636} \
   CONFIG.CLKOUT2_PHASE_ERROR {98.575} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {50.000} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLK_OUT1_PORT {axi_clk} \
   CONFIG.CLK_OUT2_PORT {qspi_clk} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {20} \
   CONFIG.NUM_OUT_CLKS {2} \
   CONFIG.RESET_PORT {resetn} \
   CONFIG.RESET_TYPE {ACTIVE_LOW} \
 ] $clk_wiz_0

  # Create instance: hispi_line_writer
  create_hier_cell_hispi_line_writer [current_bd_instance .] hispi_line_writer

  # Create instance: interrupt_mapping
  create_hier_cell_interrupt_mapping [current_bd_instance .] interrupt_mapping

  # Create instance: pcie_axi_reset, and set properties
  set pcie_axi_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 pcie_axi_reset ]

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net axiMaio_0_ext_sync [get_bd_intf_ports ext_sync_0] [get_bd_intf_pins axiMaio_0/ext_sync]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins axi_pcie_0/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins axi_interconnect_0/M01_AXI] [get_bd_intf_pins axi_pcie_0/S_AXI_CTL]
  connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI [get_bd_intf_pins axi_interconnect_0/M02_AXI] [get_bd_intf_pins hispi_line_writer/s_axi]
  connect_bd_intf_net -intf_net axi_interconnect_0_M03_AXI [get_bd_intf_pins axiMaio_0/s_axi] [get_bd_intf_pins axi_interconnect_0/M03_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M04_AXI [get_bd_intf_pins axi_interconnect_0/M04_AXI] [get_bd_intf_pins axi_quad_spi_0/AXI_LITE]
  connect_bd_intf_net -intf_net axi_pcie_0_M_AXI [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins axi_pcie_0/M_AXI]
  connect_bd_intf_net -intf_net axi_pcie_0_pcie_7x_mgt [get_bd_intf_ports pcie] [get_bd_intf_pins axi_pcie_0/pcie_7x_mgt]
  connect_bd_intf_net -intf_net axi_quad_spi_0_SPI_0 [get_bd_intf_ports SPI_0_0] [get_bd_intf_pins axi_quad_spi_0/SPI_0]
  connect_bd_intf_net -intf_net axi_quad_spi_0_STARTUP_IO [get_bd_intf_ports STARTUP_IO_0] [get_bd_intf_pins axi_quad_spi_0/STARTUP_IO]
  connect_bd_intf_net -intf_net hispi_line_writer_M_AXI [get_bd_intf_pins axi_interconnect_0/S01_AXI] [get_bd_intf_pins hispi_line_writer/M_AXI]

  # Create port connections
  connect_bd_net -net M01_ACLK_1 [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_pcie_0/axi_ctl_aclk_out]
  connect_bd_net -net PCIE_REFCLK_100MHz_2 [get_bd_ports PCIE_REFCLK_100MHz] [get_bd_pins axi_pcie_0/REFCLK]
  connect_bd_net -net PCIE_RESET_N_1 [get_bd_ports PCIE_RESET_N] [get_bd_pins clk_wiz_0/resetn] [get_bd_pins pcie_axi_reset/ext_reset_in] [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net axiMaio_0_irq_event_io [get_bd_pins axiMaio_0/irq_event_io] [get_bd_pins interrupt_mapping/irq_io]
  connect_bd_net -net axiMaio_0_irq_event_tick [get_bd_pins axiMaio_0/irq_event_tick] [get_bd_pins interrupt_mapping/irq_tick]
  connect_bd_net -net axiMaio_0_irq_event_tick_stamp_latched [get_bd_pins axiMaio_0/irq_event_tick_stamp_latched] [get_bd_pins interrupt_mapping/irq_tick_latch]
  connect_bd_net -net axiMaio_0_irq_event_tick_wrap [get_bd_pins axiMaio_0/irq_event_tick_wrap] [get_bd_pins interrupt_mapping/irq_tick_wa]
  connect_bd_net -net axiMaio_0_irq_event_timer_end [get_bd_pins axiMaio_0/irq_event_timer_end] [get_bd_pins interrupt_mapping/irq_timer_stop]
  connect_bd_net -net axiMaio_0_irq_event_timer_start [get_bd_pins axiMaio_0/irq_event_timer_start] [get_bd_pins interrupt_mapping/irq_timer_start]
  connect_bd_net -net axiMaio_0_user_data_out [get_bd_ports user_data_out] [get_bd_pins axiMaio_0/user_data_out]
  connect_bd_net -net axi_pcie_0_axi_aclk_out [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axi_pcie_0/axi_aclk_out] [get_bd_pins pcie_axi_reset/slowest_sync_clk]
  connect_bd_net -net axi_pcie_0_mmcm_lock [get_bd_pins axi_pcie_0/mmcm_lock] [get_bd_pins pcie_axi_reset/dcm_locked]
  connect_bd_net -net axi_quad_spi_0_ip2intc_irpt [get_bd_pins axi_quad_spi_0/ip2intc_irpt] [get_bd_pins interrupt_mapping/irq_spi]
  connect_bd_net -net clk_in1_0_1 [get_bd_ports ref_clk] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net clk_wiz_0_axi_clk [get_bd_pins axiMaio_0/axi_aclk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M02_ACLK] [get_bd_pins axi_interconnect_0/M03_ACLK] [get_bd_pins axi_interconnect_0/M04_ACLK] [get_bd_pins axi_interconnect_0/S01_ACLK] [get_bd_pins axi_quad_spi_0/s_axi_aclk] [get_bd_pins clk_wiz_0/axi_clk] [get_bd_pins hispi_line_writer/axi_clk]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_0/dcm_locked]
  connect_bd_net -net clk_wiz_0_qspi_clk [get_bd_pins axi_quad_spi_0/ext_spi_clk] [get_bd_pins clk_wiz_0/qspi_clk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
  connect_bd_net -net hispi_data_n_0_1 [get_bd_ports hispi_data_n_0] [get_bd_pins hispi_line_writer/hispi_data_n_0]
  connect_bd_net -net hispi_data_p_0_1 [get_bd_ports hispi_data_p_0] [get_bd_pins hispi_line_writer/hispi_data_p_0]
  connect_bd_net -net hispi_serial_clk_n_0_1 [get_bd_ports hispi_serial_clk_n_0] [get_bd_pins hispi_line_writer/hispi_serial_clk_n_0]
  connect_bd_net -net hispi_serial_clk_p_0_1 [get_bd_ports hispi_serial_clk_p_0] [get_bd_pins hispi_line_writer/hispi_serial_clk_p_0]
  connect_bd_net -net interrupt_mapping_irq_event [get_bd_pins axi_pcie_0/INTX_MSI_Request] [get_bd_pins interrupt_mapping/irq_event]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins axi_pcie_0/axi_aresetn] [get_bd_pins pcie_axi_reset/interconnect_aresetn]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn1 [get_bd_pins axiMaio_0/axi_aresetn] [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_0/M02_ARESETN] [get_bd_pins axi_interconnect_0/M03_ARESETN] [get_bd_pins axi_interconnect_0/M04_ARESETN] [get_bd_pins axi_interconnect_0/S01_ARESETN] [get_bd_pins axi_quad_spi_0/s_axi_aresetn] [get_bd_pins hispi_line_writer/axi_reset_n] [get_bd_pins proc_sys_reset_0/interconnect_aresetn]
  connect_bd_net -net user_data_in_1 [get_bd_ports user_data_in] [get_bd_pins axiMaio_0/user_data_in]

  # Create address segments
  create_bd_addr_seg -range 0x00010000 -offset 0x90000000 [get_bd_addr_spaces axi_pcie_0/M_AXI] [get_bd_addr_segs axiMaio_0/s_axi/reg0] SEG_axiMaio_0_reg0
  create_bd_addr_seg -range 0x10000000 -offset 0x80000000 [get_bd_addr_spaces axi_pcie_0/M_AXI] [get_bd_addr_segs axi_pcie_0/S_AXI_CTL/CTL0] SEG_axi_pcie_0_CTL0
  create_bd_addr_seg -range 0x00010000 -offset 0x90010000 [get_bd_addr_spaces axi_pcie_0/M_AXI] [get_bd_addr_segs axi_quad_spi_0/AXI_LITE/Reg] SEG_axi_quad_spi_0_Reg
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces hispi_line_writer/axi_mm2s_mapper_0/Bridge] [get_bd_addr_segs axi_pcie_0/S_AXI/BAR0] SEG_axi_pcie_0_BAR0

  # Exclude Address Segments
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_pcie_0/M_AXI] [get_bd_addr_segs axi_pcie_0/S_AXI/BAR0] SEG_axi_pcie_0_BAR0
  exclude_bd_addr_seg [get_bd_addr_segs axi_pcie_0/M_AXI/SEG_axi_pcie_0_BAR0]

  create_bd_addr_seg -range 0x00010000 -offset 0x90000000 [get_bd_addr_spaces hispi_line_writer/axi_mm2s_mapper_0/Bridge] [get_bd_addr_segs axiMaio_0/s_axi/reg0] SEG_axiMaio_0_reg0
  exclude_bd_addr_seg [get_bd_addr_segs hispi_line_writer/axi_mm2s_mapper_0/Bridge/SEG_axiMaio_0_reg0]

  create_bd_addr_seg -range 0x10000000 -offset 0x80000000 [get_bd_addr_spaces hispi_line_writer/axi_mm2s_mapper_0/Bridge] [get_bd_addr_segs axi_pcie_0/S_AXI_CTL/CTL0] SEG_axi_pcie_0_CTL0
  exclude_bd_addr_seg [get_bd_addr_segs hispi_line_writer/axi_mm2s_mapper_0/Bridge/SEG_axi_pcie_0_CTL0]

  create_bd_addr_seg -range 0x00010000 -offset 0x90010000 [get_bd_addr_spaces hispi_line_writer/axi_mm2s_mapper_0/Bridge] [get_bd_addr_segs axi_quad_spi_0/AXI_LITE/Reg] SEG_axi_quad_spi_0_Reg
  exclude_bd_addr_seg [get_bd_addr_segs hispi_line_writer/axi_mm2s_mapper_0/Bridge/SEG_axi_quad_spi_0_Reg]



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


