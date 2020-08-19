
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
xilinx.com:ip:axi_ethernetlite:3.0\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:axi_quad_spi:3.2\
xilinx.com:ip:axi_uartlite:2.0\
xilinx.com:ip:jtag_axi:1.2\
xilinx.com:ip:mii_to_rmii:2.0\
xilinx.com:ip:proc_sys_reset:5.0\
matrox.com:Imaging:rpc2_ctrl_controller:1.0\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:system_ila:1.1\
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
  set ProdCons_1 [ create_bd_intf_port -mode Slave -vlnv matrox.com:user:regfile_valid_posreset_rtl:1.0 ProdCons_1 ]

  set hb [ create_bd_intf_port -mode Master -vlnv matrox.com:user:hyperbus_rtl:1.0 hb ]

  set ncsi [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rmii_rtl:1.0 ncsi ]

  set spi [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:spi_rtl:1.0 spi ]

  set uart [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 uart ]


  # Create ports
  set cfgmclk [ create_bd_port -dir O cfgmclk ]
  set clk_100MHz [ create_bd_port -dir I -type clk clk_100MHz ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
 ] $clk_100MHz
  set ext_ProdCons_addr [ create_bd_port -dir I -from 10 -to 0 ext_ProdCons_addr ]
  set ext_ProdCons_readData [ create_bd_port -dir O -from 31 -to 0 ext_ProdCons_readData ]
  set ext_ProdCons_readDataValid [ create_bd_port -dir O -from 0 -to 0 ext_ProdCons_readDataValid ]
  set ext_ProdCons_readEn [ create_bd_port -dir I ext_ProdCons_readEn ]
  set ext_ProdCons_writeEn [ create_bd_port -dir I ext_ProdCons_writeEn ]
  set ext_writeBeN [ create_bd_port -dir I -from 3 -to 0 ext_writeBeN ]
  set ext_writeData [ create_bd_port -dir I -from 31 -to 0 ext_writeData ]
  set gpio_3states_en [ create_bd_port -dir O -from 2 -to 0 gpio_3states_en ]
  set gpio_in [ create_bd_port -dir I -from 2 -to 0 gpio_in ]
  set gpio_out [ create_bd_port -dir O -from 2 -to 0 gpio_out ]
  set host_irq [ create_bd_port -dir O host_irq ]
  set ncsi_clk [ create_bd_port -dir O -type clk ncsi_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {50000000} \
 ] $ncsi_clk
  set reset_n [ create_bd_port -dir I -type rst reset_n ]
  set sysclk [ create_bd_port -dir I sysclk ]
  set sysrst [ create_bd_port -dir I sysrst ]

  # Create instance: Lpc_to_AXI_prodcons_1, and set properties
  set Lpc_to_AXI_prodcons_1 [ create_bd_cell -type ip -vlnv matrox.com:user:Lpc_to_AXI_prodcons:1.1 Lpc_to_AXI_prodcons_1 ]

  # Create instance: axi_ethernetlite_0, and set properties
  set axi_ethernetlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernetlite:3.0 axi_ethernetlite_0 ]
  set_property -dict [ list \
   CONFIG.C_INCLUDE_GLOBAL_BUFFERS {0} \
   CONFIG.C_INCLUDE_MDIO {0} \
 ] $axi_ethernetlite_0

  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {0} \
   CONFIG.C_GPIO_WIDTH {3} \
 ] $axi_gpio_0

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {7} \
 ] $axi_interconnect_0

  # Create instance: axi_quad_spi_0, and set properties
  set axi_quad_spi_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 axi_quad_spi_0 ]
  set_property -dict [ list \
   CONFIG.C_FIFO_DEPTH {256} \
   CONFIG.C_SCK_RATIO {2} \
   CONFIG.C_SPI_MODE {2} \
   CONFIG.C_TYPE_OF_AXI4_INTERFACE {1} \
   CONFIG.C_USE_STARTUP {1} \
 ] $axi_quad_spi_0

  # Create instance: axi_uartlite_0, and set properties
  set axi_uartlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0 ]
  set_property -dict [ list \
   CONFIG.C_BAUDRATE {115200} \
 ] $axi_uartlite_0

  # Create instance: jtag_axi_0, and set properties
  set jtag_axi_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:jtag_axi:1.2 jtag_axi_0 ]
  set_property -dict [ list \
   CONFIG.PROTOCOL {2} \
 ] $jtag_axi_0

  # Create instance: mii_to_rmii_0, and set properties
  set mii_to_rmii_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mii_to_rmii:2.0 mii_to_rmii_0 ]

  # Create instance: reset_100MHz, and set properties
  set reset_100MHz [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 reset_100MHz ]

  # Create instance: rpc2_ctrl_controller_0, and set properties
  set rpc2_ctrl_controller_0 [ create_bd_cell -type ip -vlnv matrox.com:Imaging:rpc2_ctrl_controller:1.0 rpc2_ctrl_controller_0 ]
  set_property -dict [ list \
   CONFIG.C_AXI_MEM_ADDR_WIDTH {25} \
   CONFIG.C_ENABLE_WP {true} \
 ] $rpc2_ctrl_controller_0

  # Create instance: rpc_pll, and set properties
  set rpc_pll [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 rpc_pll ]
  set_property -dict [ list \
   CONFIG.CLKOUT1_JITTER {130.958} \
   CONFIG.CLKOUT1_PHASE_ERROR {98.575} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {100.000} \
   CONFIG.CLKOUT2_JITTER {130.958} \
   CONFIG.CLKOUT2_PHASE_ERROR {98.575} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {100.000} \
   CONFIG.CLKOUT2_REQUESTED_PHASE {90.000} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLKOUT3_JITTER {161.941} \
   CONFIG.CLKOUT3_PHASE_ERROR {218.145} \
   CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {100.000} \
   CONFIG.CLKOUT3_USED {false} \
   CONFIG.CLK_OUT1_PORT {rpc_clk} \
   CONFIG.CLK_OUT2_PORT {rpc_clk90} \
   CONFIG.CLK_OUT3_PORT {clk_out3} \
   CONFIG.ENABLE_CLOCK_MONITOR {false} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {10.000} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {10.000} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {10} \
   CONFIG.MMCM_CLKOUT1_PHASE {90.000} \
   CONFIG.MMCM_CLKOUT2_DIVIDE {1} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.NUM_OUT_CLKS {2} \
   CONFIG.PRIMITIVE {MMCM} \
   CONFIG.RESET_PORT {resetn} \
   CONFIG.RESET_TYPE {ACTIVE_LOW} \
   CONFIG.USE_LOCKED {false} \
 ] $rpc_pll

  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [ list \
   CONFIG.C_MON_TYPE {INTERFACE} \
   CONFIG.C_NUM_MONITOR_SLOTS {3} \
   CONFIG.C_SLOT_0_APC_EN {1} \
   CONFIG.C_SLOT_0_AXI_AR_SEL_DATA {1} \
   CONFIG.C_SLOT_0_AXI_AR_SEL_TRIG {1} \
   CONFIG.C_SLOT_0_AXI_AW_SEL_DATA {1} \
   CONFIG.C_SLOT_0_AXI_AW_SEL_TRIG {1} \
   CONFIG.C_SLOT_0_AXI_B_SEL_DATA {1} \
   CONFIG.C_SLOT_0_AXI_B_SEL_TRIG {1} \
   CONFIG.C_SLOT_0_AXI_R_SEL_DATA {1} \
   CONFIG.C_SLOT_0_AXI_R_SEL_TRIG {1} \
   CONFIG.C_SLOT_0_AXI_W_SEL_DATA {1} \
   CONFIG.C_SLOT_0_AXI_W_SEL_TRIG {1} \
   CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:aximm_rtl:1.0} \
   CONFIG.C_SLOT_1_APC_EN {0} \
   CONFIG.C_SLOT_1_AXI_AR_SEL_DATA {1} \
   CONFIG.C_SLOT_1_AXI_AR_SEL_TRIG {1} \
   CONFIG.C_SLOT_1_AXI_AW_SEL_DATA {1} \
   CONFIG.C_SLOT_1_AXI_AW_SEL_TRIG {1} \
   CONFIG.C_SLOT_1_AXI_B_SEL_DATA {1} \
   CONFIG.C_SLOT_1_AXI_B_SEL_TRIG {1} \
   CONFIG.C_SLOT_1_AXI_R_SEL_DATA {1} \
   CONFIG.C_SLOT_1_AXI_R_SEL_TRIG {1} \
   CONFIG.C_SLOT_1_AXI_W_SEL_DATA {1} \
   CONFIG.C_SLOT_1_AXI_W_SEL_TRIG {1} \
   CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:aximm_rtl:1.0} \
   CONFIG.C_SLOT_2_APC_EN {0} \
   CONFIG.C_SLOT_2_AXI_AR_SEL_DATA {1} \
   CONFIG.C_SLOT_2_AXI_AR_SEL_TRIG {1} \
   CONFIG.C_SLOT_2_AXI_AW_SEL_DATA {1} \
   CONFIG.C_SLOT_2_AXI_AW_SEL_TRIG {1} \
   CONFIG.C_SLOT_2_AXI_B_SEL_DATA {1} \
   CONFIG.C_SLOT_2_AXI_B_SEL_TRIG {1} \
   CONFIG.C_SLOT_2_AXI_R_SEL_DATA {1} \
   CONFIG.C_SLOT_2_AXI_R_SEL_TRIG {1} \
   CONFIG.C_SLOT_2_AXI_W_SEL_DATA {1} \
   CONFIG.C_SLOT_2_AXI_W_SEL_TRIG {1} \
   CONFIG.C_SLOT_2_INTF_TYPE {xilinx.com:interface:aximm_rtl:1.0} \
   CONFIG.C_SLOT_3_APC_EN {0} \
   CONFIG.C_SLOT_3_AXI_AR_SEL_DATA {1} \
   CONFIG.C_SLOT_3_AXI_AR_SEL_TRIG {1} \
   CONFIG.C_SLOT_3_AXI_AW_SEL_DATA {1} \
   CONFIG.C_SLOT_3_AXI_AW_SEL_TRIG {1} \
   CONFIG.C_SLOT_3_AXI_B_SEL_DATA {1} \
   CONFIG.C_SLOT_3_AXI_B_SEL_TRIG {1} \
   CONFIG.C_SLOT_3_AXI_R_SEL_DATA {1} \
   CONFIG.C_SLOT_3_AXI_R_SEL_TRIG {1} \
   CONFIG.C_SLOT_3_AXI_W_SEL_DATA {1} \
   CONFIG.C_SLOT_3_AXI_W_SEL_TRIG {1} \
   CONFIG.C_SLOT_3_INTF_TYPE {xilinx.com:interface:aximm_rtl:1.0} \
   CONFIG.C_SLOT_3_TYPE {0} \
   CONFIG.C_SLOT_4_APC_EN {0} \
   CONFIG.C_SLOT_4_AXI_AR_SEL_DATA {1} \
   CONFIG.C_SLOT_4_AXI_AR_SEL_TRIG {1} \
   CONFIG.C_SLOT_4_AXI_AW_SEL_DATA {1} \
   CONFIG.C_SLOT_4_AXI_AW_SEL_TRIG {1} \
   CONFIG.C_SLOT_4_AXI_B_SEL_DATA {1} \
   CONFIG.C_SLOT_4_AXI_B_SEL_TRIG {1} \
   CONFIG.C_SLOT_4_AXI_R_SEL_DATA {1} \
   CONFIG.C_SLOT_4_AXI_R_SEL_TRIG {1} \
   CONFIG.C_SLOT_4_AXI_W_SEL_DATA {1} \
   CONFIG.C_SLOT_4_AXI_W_SEL_TRIG {1} \
   CONFIG.C_SLOT_4_INTF_TYPE {xilinx.com:interface:aximm_rtl:1.0} \
 ] $system_ila_0

  # Create instance: system_pll, and set properties
  set system_pll [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 system_pll ]
  set_property -dict [ list \
   CONFIG.CLKOUT1_DRIVES {BUFG} \
   CONFIG.CLKOUT1_JITTER {144.719} \
   CONFIG.CLKOUT1_PHASE_ERROR {114.212} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {100} \
   CONFIG.CLKOUT2_DRIVES {BUFG} \
   CONFIG.CLKOUT2_JITTER {167.017} \
   CONFIG.CLKOUT2_PHASE_ERROR {114.212} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {50} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLKOUT3_DRIVES {BUFG} \
   CONFIG.CLKOUT3_JITTER {167.017} \
   CONFIG.CLKOUT3_PHASE_ERROR {114.212} \
   CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {50} \
   CONFIG.CLKOUT3_REQUESTED_PHASE {-40} \
   CONFIG.CLKOUT3_USED {true} \
   CONFIG.CLKOUT4_DRIVES {BUFG} \
   CONFIG.CLKOUT4_JITTER {126.455} \
   CONFIG.CLKOUT4_PHASE_ERROR {114.212} \
   CONFIG.CLKOUT4_REQUESTED_OUT_FREQ {200.000} \
   CONFIG.CLKOUT4_REQUESTED_PHASE {0.000} \
   CONFIG.CLKOUT4_USED {true} \
   CONFIG.CLKOUT5_DRIVES {BUFG} \
   CONFIG.CLKOUT5_JITTER {137.096} \
   CONFIG.CLKOUT5_PHASE_ERROR {116.405} \
   CONFIG.CLKOUT5_REQUESTED_OUT_FREQ {100.000} \
   CONFIG.CLKOUT5_REQUESTED_PHASE {0.000} \
   CONFIG.CLKOUT5_USED {false} \
   CONFIG.CLKOUT6_DRIVES {BUFG} \
   CONFIG.CLKOUT6_JITTER {114.829} \
   CONFIG.CLKOUT6_PHASE_ERROR {98.575} \
   CONFIG.CLKOUT6_REQUESTED_OUT_FREQ {100.000} \
   CONFIG.CLKOUT6_USED {false} \
   CONFIG.CLKOUT7_DRIVES {BUFG} \
   CONFIG.CLKOUT7_JITTER {151.636} \
   CONFIG.CLKOUT7_PHASE_ERROR {98.575} \
   CONFIG.CLKOUT7_REQUESTED_OUT_FREQ {100.000} \
   CONFIG.CLKOUT7_REQUESTED_PHASE {0.000} \
   CONFIG.CLKOUT7_USED {false} \
   CONFIG.CLK_OUT1_PORT {clk100MHz} \
   CONFIG.CLK_OUT2_PORT {clk50MHz} \
   CONFIG.CLK_OUT3_PORT {clk50MHz_io} \
   CONFIG.CLK_OUT4_PORT {clk200MHz} \
   CONFIG.CLK_OUT5_PORT {clk_out5} \
   CONFIG.CLK_OUT6_PORT {clk_out6} \
   CONFIG.CLK_OUT7_PORT {clk_out7} \
   CONFIG.FEEDBACK_SOURCE {FDBK_AUTO} \
   CONFIG.JITTER_SEL {No_Jitter} \
   CONFIG.MMCM_BANDWIDTH {OPTIMIZED} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {8.000} \
   CONFIG.MMCM_CLKIN1_PERIOD {10.000} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.000} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {8.000} \
   CONFIG.MMCM_CLKOUT0_DUTY_CYCLE {0.5} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {16} \
   CONFIG.MMCM_CLKOUT1_DUTY_CYCLE {0.5} \
   CONFIG.MMCM_CLKOUT2_DIVIDE {16} \
   CONFIG.MMCM_CLKOUT2_DUTY_CYCLE {0.5} \
   CONFIG.MMCM_CLKOUT2_PHASE {-39.375} \
   CONFIG.MMCM_CLKOUT3_DIVIDE {4} \
   CONFIG.MMCM_CLKOUT3_DUTY_CYCLE {0.5} \
   CONFIG.MMCM_CLKOUT3_PHASE {0.000} \
   CONFIG.MMCM_CLKOUT4_DIVIDE {1} \
   CONFIG.MMCM_CLKOUT4_DUTY_CYCLE {0.500} \
   CONFIG.MMCM_CLKOUT4_PHASE {0.000} \
   CONFIG.MMCM_CLKOUT5_DIVIDE {1} \
   CONFIG.MMCM_CLKOUT5_DUTY_CYCLE {0.500} \
   CONFIG.MMCM_CLKOUT6_DIVIDE {1} \
   CONFIG.MMCM_CLKOUT6_DUTY_CYCLE {0.500} \
   CONFIG.MMCM_CLKOUT6_PHASE {0.000} \
   CONFIG.MMCM_COMPENSATION {ZHOLD} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.NUM_OUT_CLKS {4} \
   CONFIG.PRIMITIVE {MMCM} \
   CONFIG.PRIM_SOURCE {Single_ended_clock_capable_pin} \
   CONFIG.RESET_PORT {resetn} \
   CONFIG.RESET_TYPE {ACTIVE_LOW} \
   CONFIG.SECONDARY_SOURCE {Single_ended_clock_capable_pin} \
   CONFIG.USE_MIN_POWER {true} \
   CONFIG.USE_PHASE_ALIGNMENT {true} \
 ] $system_pll

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {32} \
 ] $xlconstant_0

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_1

  # Create interface connections
  connect_bd_intf_net -intf_net axi_ethernetlite_0_MII [get_bd_intf_pins axi_ethernetlite_0/MII] [get_bd_intf_pins mii_to_rmii_0/MII]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins rpc2_ctrl_controller_0/AXIm]
connect_bd_intf_net -intf_net [get_bd_intf_nets axi_interconnect_0_M00_AXI] [get_bd_intf_pins rpc2_ctrl_controller_0/AXIm] [get_bd_intf_pins system_ila_0/SLOT_1_AXI]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets axi_interconnect_0_M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins axi_interconnect_0/M01_AXI] [get_bd_intf_pins rpc2_ctrl_controller_0/AXIr]
connect_bd_intf_net -intf_net [get_bd_intf_nets axi_interconnect_0_M01_AXI] [get_bd_intf_pins rpc2_ctrl_controller_0/AXIr] [get_bd_intf_pins system_ila_0/SLOT_2_AXI]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets axi_interconnect_0_M01_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI [get_bd_intf_pins axi_ethernetlite_0/S_AXI] [get_bd_intf_pins axi_interconnect_0/M02_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M03_AXI [get_bd_intf_pins axi_interconnect_0/M03_AXI] [get_bd_intf_pins axi_uartlite_0/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M04_AXI [get_bd_intf_pins axi_interconnect_0/M04_AXI] [get_bd_intf_pins axi_quad_spi_0/AXI_FULL]
  connect_bd_intf_net -intf_net axi_interconnect_0_M05_AXI [get_bd_intf_pins Lpc_to_AXI_prodcons_1/S00_AXI] [get_bd_intf_pins axi_interconnect_0/M05_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M06_AXI [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins axi_interconnect_0/M06_AXI]
  connect_bd_intf_net -intf_net axi_quad_spi_0_SPI_0 [get_bd_intf_ports spi] [get_bd_intf_pins axi_quad_spi_0/SPI_0]
  connect_bd_intf_net -intf_net axi_uartlite_0_UART [get_bd_intf_ports uart] [get_bd_intf_pins axi_uartlite_0/UART]
  connect_bd_intf_net -intf_net jtag_axi_0_M_AXI [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins jtag_axi_0/M_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets jtag_axi_0_M_AXI] [get_bd_intf_pins jtag_axi_0/M_AXI] [get_bd_intf_pins system_ila_0/SLOT_0_AXI]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets jtag_axi_0_M_AXI]
  connect_bd_intf_net -intf_net ncsi [get_bd_intf_ports ncsi] [get_bd_intf_pins mii_to_rmii_0/RMII_PHY_M]
  connect_bd_intf_net -intf_net rf_1 [get_bd_intf_ports ProdCons_1] [get_bd_intf_pins Lpc_to_AXI_prodcons_1/rf]
  connect_bd_intf_net -intf_net rpc2_ctrl_controller_0_hb [get_bd_intf_ports hb] [get_bd_intf_pins rpc2_ctrl_controller_0/hb]

  # Create port connections
  connect_bd_net -net Lpc_to_AXI_prodcons_1_host_irq [get_bd_ports host_irq] [get_bd_pins Lpc_to_AXI_prodcons_1/host_irq]
  connect_bd_net -net aresetn_1 [get_bd_ports reset_n] [get_bd_pins reset_100MHz/ext_reset_in] [get_bd_pins rpc_pll/resetn] [get_bd_pins system_pll/resetn]
  connect_bd_net -net axi_gpio_0_gpio_io_o [get_bd_ports gpio_out] [get_bd_pins axi_gpio_0/gpio_io_o]
  connect_bd_net -net axi_gpio_0_gpio_io_t [get_bd_ports gpio_3states_en] [get_bd_pins axi_gpio_0/gpio_io_t]
  connect_bd_net -net axi_quad_spi_0_cfgmclk [get_bd_ports cfgmclk] [get_bd_pins axi_quad_spi_0/cfgmclk]
  connect_bd_net -net clk_100MHz_1 [get_bd_ports clk_100MHz] [get_bd_pins rpc_pll/clk_in1] [get_bd_pins system_pll/clk_in1]
  connect_bd_net -net clk_wiz_0_clk50MHz [get_bd_pins axi_quad_spi_0/ext_spi_clk] [get_bd_pins mii_to_rmii_0/ref_clk] [get_bd_pins system_pll/clk50MHz]
  connect_bd_net -net gpio_in_1 [get_bd_ports gpio_in] [get_bd_pins axi_gpio_0/gpio_io_i]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins Lpc_to_AXI_prodcons_1/s00_axi_aclk] [get_bd_pins axi_ethernetlite_0/s_axi_aclk] [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_interconnect_0/M02_ACLK] [get_bd_pins axi_interconnect_0/M03_ACLK] [get_bd_pins axi_interconnect_0/M04_ACLK] [get_bd_pins axi_interconnect_0/M05_ACLK] [get_bd_pins axi_interconnect_0/M06_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axi_quad_spi_0/s_axi4_aclk] [get_bd_pins axi_uartlite_0/s_axi_aclk] [get_bd_pins jtag_axi_0/aclk] [get_bd_pins reset_100MHz/slowest_sync_clk] [get_bd_pins rpc2_ctrl_controller_0/AXIm_ACLK] [get_bd_pins rpc2_ctrl_controller_0/AXIr_ACLK] [get_bd_pins system_ila_0/clk] [get_bd_pins system_pll/clk100MHz]
  connect_bd_net -net reset_100MHz_interconnect_aresetn [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins jtag_axi_0/aresetn] [get_bd_pins reset_100MHz/interconnect_aresetn]
  connect_bd_net -net rpc_pll_rpc_clk [get_bd_pins rpc2_ctrl_controller_0/rpc_clk166MHz] [get_bd_pins rpc_pll/rpc_clk]
  connect_bd_net -net rpc_pll_rpc_clk90 [get_bd_pins rpc2_ctrl_controller_0/rpc_clk166MHz_90] [get_bd_pins rpc_pll/rpc_clk90]
  connect_bd_net -net rst_ddr2_mig_0_100M_peripheral_aresetn [get_bd_pins Lpc_to_AXI_prodcons_1/s00_axi_aresetn] [get_bd_pins axi_ethernetlite_0/s_axi_aresetn] [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_interconnect_0/M02_ARESETN] [get_bd_pins axi_interconnect_0/M03_ARESETN] [get_bd_pins axi_interconnect_0/M04_ARESETN] [get_bd_pins axi_interconnect_0/M05_ARESETN] [get_bd_pins axi_interconnect_0/M06_ARESETN] [get_bd_pins axi_quad_spi_0/s_axi4_aresetn] [get_bd_pins axi_uartlite_0/s_axi_aresetn] [get_bd_pins mii_to_rmii_0/rst_n] [get_bd_pins reset_100MHz/peripheral_aresetn] [get_bd_pins rpc2_ctrl_controller_0/AXIm_ARESETN] [get_bd_pins rpc2_ctrl_controller_0/AXIr_ARESETN] [get_bd_pins system_ila_0/resetn]
  connect_bd_net -net system_pll_clk200MHz [get_bd_pins rpc2_ctrl_controller_0/rpc_clk200MHz] [get_bd_pins system_pll/clk200MHz]
  connect_bd_net -net system_pll_clk50MHz_io [get_bd_ports ncsi_clk] [get_bd_pins system_pll/clk50MHz_io]
  connect_bd_net -net system_pll_locked [get_bd_pins reset_100MHz/dcm_locked] [get_bd_pins system_pll/locked]
  connect_bd_net -net xlconstant_0_dout [get_bd_ports ext_ProdCons_readData] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_ports ext_ProdCons_readDataValid] [get_bd_pins xlconstant_1/dout]

  # Create address segments
  create_bd_addr_seg -range 0x00002000 -offset 0x00006000 [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs Lpc_to_AXI_prodcons_1/S00_AXI/S00_AXI_reg] SEG_Lpc_to_AXI_prodcons_1_S00_AXI_reg
  create_bd_addr_seg -range 0x00002000 -offset 0x00004000 [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs axi_ethernetlite_0/S_AXI/Reg] SEG_axi_ethernetlite_0_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0x00008000 [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] SEG_axi_gpio_0_Reg
  create_bd_addr_seg -range 0x00100000 -offset 0x00100000 [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs axi_quad_spi_0/aximm/MEM0] SEG_axi_quad_spi_0_MEM0
  create_bd_addr_seg -range 0x00001000 -offset 0x00001000 [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs axi_uartlite_0/S_AXI/Reg] SEG_axi_uartlite_0_Reg
  create_bd_addr_seg -range 0x02000000 -offset 0x80000000 [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs rpc2_ctrl_controller_0/AXIm/memory] SEG_rpc2_ctrl_controller_0_memory
  create_bd_addr_seg -range 0x00001000 -offset 0x00000000 [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs rpc2_ctrl_controller_0/AXIr/reg] SEG_rpc2_ctrl_controller_0_reg


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


