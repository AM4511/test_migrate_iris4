
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
xilinx.com:ip:axi_ethernetlite:3.0\
xilinx.com:ip:axi_uartlite:2.0\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:mii_to_rmii:2.0\
matrox.com:Imaging:pcie2AxiMaster:2.0\
xilinx.com:ip:proc_sys_reset:5.0\
matrox.com:Imaging:rpc2_ctrl_controller:1.0\
xilinx.com:ip:clk_wiz:6.0\
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
  set FPGA_Info [ create_bd_intf_port -mode Slave -vlnv matrox.com:Imaging:FPGA_Info_rtl:1.0 FPGA_Info ]

  set hb [ create_bd_intf_port -mode Master -vlnv matrox.com:user:hyperbus_rtl:1.0 hb ]

  set mtxSPI_0 [ create_bd_intf_port -mode Master -vlnv matrox.com:MatroxIP:mtxSPI_rtl:1.0 mtxSPI_0 ]

  set ncsi [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rmii_rtl:1.0 ncsi ]

  set pcie_mgt_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie_mgt_0 ]

  set uart [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 uart ]


  # Create ports
  set ncsi_clk [ create_bd_port -dir O -type clk ncsi_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {50000000} \
 ] $ncsi_clk
  set pcie_refclk [ create_bd_port -dir I -type clk pcie_refclk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
 ] $pcie_refclk
  set refclk_50MHz [ create_bd_port -dir I -type clk refclk_50MHz ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_RESET {} \
   CONFIG.FREQ_HZ {50000000} \
 ] $refclk_50MHz
  set reset_n [ create_bd_port -dir I -type rst reset_n ]

  # Create instance: axi_ethernetlite_0, and set properties
  set axi_ethernetlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernetlite:3.0 axi_ethernetlite_0 ]
  set_property -dict [ list \
   CONFIG.C_INCLUDE_GLOBAL_BUFFERS {0} \
   CONFIG.C_INCLUDE_MDIO {0} \
 ] $axi_ethernetlite_0

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {5} \
 ] $axi_interconnect_0

  # Create instance: axi_uartlite_0, and set properties
  set axi_uartlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0 ]
  set_property -dict [ list \
   CONFIG.C_BAUDRATE {115200} \
 ] $axi_uartlite_0

  # Create instance: irq_constant, and set properties
  set irq_constant [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 irq_constant ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $irq_constant

  # Create instance: mii_to_rmii_0, and set properties
  set mii_to_rmii_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mii_to_rmii:2.0 mii_to_rmii_0 ]

  # Create instance: pcie2AxiMaster_0, and set properties
  set pcie2AxiMaster_0 [ create_bd_cell -type ip -vlnv matrox.com:Imaging:pcie2AxiMaster:2.0 pcie2AxiMaster_0 ]
  set_property -dict [ list \
   CONFIG.AXI_ID_WIDTH {2} \
   CONFIG.NUMB_IRQ {1} \
   CONFIG.PCIE_DEVICE_ID {43981} \
   CONFIG.PCIE_SUBSYS_VENDOR_ID {4139} \
 ] $pcie2AxiMaster_0

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
   CONFIG.CLKIN1_JITTER_PS {100.0} \
   CONFIG.CLKOUT1_JITTER {136.421} \
   CONFIG.CLKOUT1_PHASE_ERROR {114.212} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {133.333} \
   CONFIG.CLKOUT2_JITTER {136.421} \
   CONFIG.CLKOUT2_PHASE_ERROR {114.212} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {133.333} \
   CONFIG.CLKOUT2_REQUESTED_PHASE {90.000} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLKOUT3_JITTER {126.455} \
   CONFIG.CLKOUT3_PHASE_ERROR {114.212} \
   CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {200.000} \
   CONFIG.CLKOUT3_USED {true} \
   CONFIG.CLK_OUT1_PORT {rpc_clk} \
   CONFIG.CLK_OUT2_PORT {rpc_clk90} \
   CONFIG.CLK_OUT3_PORT {clk200MHz} \
   CONFIG.ENABLE_CLOCK_MONITOR {false} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {16.000} \
   CONFIG.MMCM_CLKIN1_PERIOD {20.000} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {6.000} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {6} \
   CONFIG.MMCM_CLKOUT1_PHASE {90.000} \
   CONFIG.MMCM_CLKOUT2_DIVIDE {4} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.NUM_OUT_CLKS {3} \
   CONFIG.PRIMITIVE {MMCM} \
   CONFIG.PRIM_SOURCE {Global_buffer} \
   CONFIG.RESET_PORT {resetn} \
   CONFIG.RESET_TYPE {ACTIVE_LOW} \
   CONFIG.USE_LOCKED {false} \
 ] $rpc_pll

  # Create instance: system_pll, and set properties
  set system_pll [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 system_pll ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {100.0} \
   CONFIG.CLKOUT1_DRIVES {BUFG} \
   CONFIG.CLKOUT1_JITTER {145.553} \
   CONFIG.CLKOUT1_PHASE_ERROR {124.502} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {100} \
   CONFIG.CLKOUT2_DRIVES {BUFG} \
   CONFIG.CLKOUT2_JITTER {167.927} \
   CONFIG.CLKOUT2_PHASE_ERROR {124.502} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {50} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLKOUT3_DRIVES {BUFG} \
   CONFIG.CLKOUT3_JITTER {167.927} \
   CONFIG.CLKOUT3_PHASE_ERROR {124.502} \
   CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {50} \
   CONFIG.CLKOUT3_REQUESTED_PHASE {-40} \
   CONFIG.CLKOUT3_USED {true} \
   CONFIG.CLKOUT4_DRIVES {BUFG} \
   CONFIG.CLKOUT4_JITTER {161.087} \
   CONFIG.CLKOUT4_PHASE_ERROR {144.334} \
   CONFIG.CLKOUT4_REQUESTED_OUT_FREQ {100.000} \
   CONFIG.CLKOUT4_REQUESTED_PHASE {0.000} \
   CONFIG.CLKOUT4_USED {false} \
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
   CONFIG.CLK_OUT4_PORT {clk_out4} \
   CONFIG.CLK_OUT5_PORT {clk_out5} \
   CONFIG.CLK_OUT6_PORT {clk_out6} \
   CONFIG.CLK_OUT7_PORT {clk_out7} \
   CONFIG.FEEDBACK_SOURCE {FDBK_AUTO} \
   CONFIG.JITTER_SEL {No_Jitter} \
   CONFIG.MMCM_BANDWIDTH {OPTIMIZED} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {13.000} \
   CONFIG.MMCM_CLKIN1_PERIOD {20.000} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {6.500} \
   CONFIG.MMCM_CLKOUT0_DUTY_CYCLE {0.5} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {13} \
   CONFIG.MMCM_CLKOUT1_DUTY_CYCLE {0.5} \
   CONFIG.MMCM_CLKOUT2_DIVIDE {13} \
   CONFIG.MMCM_CLKOUT2_DUTY_CYCLE {0.5} \
   CONFIG.MMCM_CLKOUT2_PHASE {-38.077} \
   CONFIG.MMCM_CLKOUT3_DIVIDE {1} \
   CONFIG.MMCM_CLKOUT3_DUTY_CYCLE {0.500} \
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
   CONFIG.NUM_OUT_CLKS {3} \
   CONFIG.PRIMITIVE {MMCM} \
   CONFIG.PRIM_SOURCE {Global_buffer} \
   CONFIG.RESET_PORT {resetn} \
   CONFIG.RESET_TYPE {ACTIVE_LOW} \
   CONFIG.SECONDARY_SOURCE {Single_ended_clock_capable_pin} \
   CONFIG.USE_MIN_POWER {true} \
   CONFIG.USE_PHASE_ALIGNMENT {true} \
 ] $system_pll

  # Create interface connections
  connect_bd_intf_net -intf_net FPGA_Info_0_1 [get_bd_intf_ports FPGA_Info] [get_bd_intf_pins pcie2AxiMaster_0/FPGA_Info]
  connect_bd_intf_net -intf_net axi_ethernetlite_0_MII [get_bd_intf_pins axi_ethernetlite_0/MII] [get_bd_intf_pins mii_to_rmii_0/MII]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins rpc2_ctrl_controller_0/AXIm]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins axi_interconnect_0/M01_AXI] [get_bd_intf_pins rpc2_ctrl_controller_0/AXIr]
  connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI [get_bd_intf_pins axi_ethernetlite_0/S_AXI] [get_bd_intf_pins axi_interconnect_0/M02_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M03_AXI [get_bd_intf_pins axi_interconnect_0/M03_AXI] [get_bd_intf_pins axi_uartlite_0/S_AXI]
  connect_bd_intf_net -intf_net axi_uartlite_0_UART [get_bd_intf_ports uart] [get_bd_intf_pins axi_uartlite_0/UART]
  connect_bd_intf_net -intf_net ncsi [get_bd_intf_ports ncsi] [get_bd_intf_pins mii_to_rmii_0/RMII_PHY_M]
  connect_bd_intf_net -intf_net pcie2AxiMaster_0_M_AXI [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins pcie2AxiMaster_0/M_AXI]
  connect_bd_intf_net -intf_net pcie2AxiMaster_0_mtxSPI [get_bd_intf_ports mtxSPI_0] [get_bd_intf_pins pcie2AxiMaster_0/mtxSPI]
  connect_bd_intf_net -intf_net pcie2AxiMaster_0_pcie_mgt [get_bd_intf_ports pcie_mgt_0] [get_bd_intf_pins pcie2AxiMaster_0/pcie_mgt]
  connect_bd_intf_net -intf_net rpc2_ctrl_controller_0_hb [get_bd_intf_ports hb] [get_bd_intf_pins rpc2_ctrl_controller_0/hb]

  # Create port connections
  connect_bd_net -net aresetn_1 [get_bd_ports reset_n] [get_bd_pins pcie2AxiMaster_0/pcie_sys_rst_n] [get_bd_pins reset_100MHz/ext_reset_in] [get_bd_pins rpc_pll/resetn] [get_bd_pins system_pll/resetn]
  connect_bd_net -net clk_wiz_0_clk50MHz [get_bd_pins mii_to_rmii_0/ref_clk] [get_bd_pins system_pll/clk50MHz]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins axi_ethernetlite_0/s_axi_aclk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_interconnect_0/M02_ACLK] [get_bd_pins axi_interconnect_0/M03_ACLK] [get_bd_pins axi_interconnect_0/M04_ACLK] [get_bd_pins axi_uartlite_0/s_axi_aclk] [get_bd_pins reset_100MHz/slowest_sync_clk] [get_bd_pins rpc2_ctrl_controller_0/AXIm_ACLK] [get_bd_pins rpc2_ctrl_controller_0/AXIr_ACLK] [get_bd_pins system_pll/clk100MHz]
  connect_bd_net -net pcie2AxiMaster_0_axim_clk [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins pcie2AxiMaster_0/axim_clk]
  connect_bd_net -net pcie2AxiMaster_0_axim_rst_n [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins pcie2AxiMaster_0/axim_rst_n]
  connect_bd_net -net refclk [get_bd_ports refclk_50MHz] [get_bd_pins rpc_pll/clk_in1] [get_bd_pins system_pll/clk_in1]
  connect_bd_net -net reset_100MHz_interconnect_aresetn [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins reset_100MHz/interconnect_aresetn]
  connect_bd_net -net rpc_pll_clk200MHz [get_bd_pins rpc2_ctrl_controller_0/rpc_clk200MHz] [get_bd_pins rpc_pll/clk200MHz]
  connect_bd_net -net rpc_pll_rpc_clk [get_bd_pins rpc2_ctrl_controller_0/rpc_clk166MHz] [get_bd_pins rpc_pll/rpc_clk]
  connect_bd_net -net rpc_pll_rpc_clk90 [get_bd_pins rpc2_ctrl_controller_0/rpc_clk166MHz_90] [get_bd_pins rpc_pll/rpc_clk90]
  connect_bd_net -net rst_ddr2_mig_0_100M_peripheral_aresetn [get_bd_pins axi_ethernetlite_0/s_axi_aresetn] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_interconnect_0/M02_ARESETN] [get_bd_pins axi_interconnect_0/M03_ARESETN] [get_bd_pins axi_interconnect_0/M04_ARESETN] [get_bd_pins axi_uartlite_0/s_axi_aresetn] [get_bd_pins mii_to_rmii_0/rst_n] [get_bd_pins reset_100MHz/peripheral_aresetn] [get_bd_pins rpc2_ctrl_controller_0/AXIm_ARESETN] [get_bd_pins rpc2_ctrl_controller_0/AXIr_ARESETN]
  connect_bd_net -net system_pll_clk50MHz_io [get_bd_ports ncsi_clk] [get_bd_pins system_pll/clk50MHz_io]
  connect_bd_net -net system_pll_locked [get_bd_pins reset_100MHz/dcm_locked] [get_bd_pins system_pll/locked]
  connect_bd_net -net util_ds_buf_0_IBUF_OUT [get_bd_ports pcie_refclk] [get_bd_pins pcie2AxiMaster_0/pcie_sys_clk]
  connect_bd_net -net xlconstant_2_dout [get_bd_pins irq_constant/dout] [get_bd_pins pcie2AxiMaster_0/irq_event]

  # Create address segments
  create_bd_addr_seg -range 0x00002000 -offset 0x00040000 [get_bd_addr_spaces pcie2AxiMaster_0/M_AXI] [get_bd_addr_segs axi_ethernetlite_0/S_AXI/Reg] SEG_axi_ethernetlite_0_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0x00020000 [get_bd_addr_spaces pcie2AxiMaster_0/M_AXI] [get_bd_addr_segs axi_uartlite_0/S_AXI/Reg] SEG_axi_uartlite_0_Reg
  create_bd_addr_seg -range 0x00400000 -offset 0x00400000 [get_bd_addr_spaces pcie2AxiMaster_0/M_AXI] [get_bd_addr_segs rpc2_ctrl_controller_0/AXIm/memory] SEG_rpc2_ctrl_controller_0_memory
  create_bd_addr_seg -range 0x00001000 -offset 0x00000000 [get_bd_addr_spaces pcie2AxiMaster_0/M_AXI] [get_bd_addr_segs rpc2_ctrl_controller_0/AXIr/reg] SEG_rpc2_ctrl_controller_0_reg


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


