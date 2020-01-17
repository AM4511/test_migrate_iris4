create_clock -period 10.000 -name pcie_refclk -waveform {0.000 5.000} [get_ports pcie_refclk_p]


# Center-Aligned Double Data Rate Source Synchronous Inputs
#
# For a center-aligned Source Synchronous interface, the clock
# transition is aligned with the center of the data valid window.
# The same clock edge is used for launching and capturing the
# data. The constraints below rely on the default timing
# analysis (setup = 1/2 cycle, hold = 0 cycle).
#
# input                  ____________________
# clock    _____________|                    |_____________
#                       |                    |
#                dv_bre | dv_are      dv_bfe | dv_afe
#               <------>|<------>    <------>|<------>
#          _    ________|________    ________|________    _
# data     _XXXX____Rise_Data____XXXX____Fall_Data____XXXX_
#

create_clock -period 2.570 -name hispi_serial_clk_0 [get_ports {hispi_serial_clk_p[0]}]
create_clock -period 2.570 -name hispi_serial_clk_1 [get_ports {hispi_serial_clk_p[1]}]
create_clock -period 2.570 -name hispi_serial_clk_2 [get_ports {hispi_serial_clk_p[2]}]
create_clock -period 2.570 -name hispi_serial_clk_3 [get_ports {hispi_serial_clk_p[3]}]
create_clock -period 2.570 -name hispi_serial_clk_4 [get_ports {hispi_serial_clk_p[4]}]
create_clock -period 2.570 -name hispi_serial_clk_5 [get_ports {hispi_serial_clk_p[5]}]


set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {xsystem_pb_wrapper/system_pb_i/hispi_line_writer/axiHiSPi_0/U0/xhispi_top/G_HISPI_PHY[1].xhispi_phy/xhispi_serdes/xhispi_phy_xilinx/inst/clkout_buf_inst/O}]] -group [get_clocks -of_objects [get_pins xsystem_pb_wrapper/system_pb_i/clk_wiz_0/inst/mmcm_adv_inst/CLKOUT0]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {xsystem_pb_wrapper/system_pb_i/hispi_line_writer/axiHiSPi_0/U0/xhispi_top/G_HISPI_PHY[0].xhispi_phy/xhispi_serdes/xhispi_phy_xilinx/inst/clkout_buf_inst/O}]] -group [get_clocks -of_objects [get_pins xsystem_pb_wrapper/system_pb_i/clk_wiz_0/inst/mmcm_adv_inst/CLKOUT0]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {xsystem_pb_wrapper/system_pb_i/hispi_line_writer/axiHiSPi_0/U0/xhispi_top/G_HISPI_PHY[2].xhispi_phy/xhispi_serdes/xhispi_phy_xilinx/inst/clkout_buf_inst/O}]] -group [get_clocks -of_objects [get_pins xsystem_pb_wrapper/system_pb_i/clk_wiz_0/inst/mmcm_adv_inst/CLKOUT0]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {xsystem_pb_wrapper/system_pb_i/hispi_line_writer/axiHiSPi_0/U0/xhispi_top/G_HISPI_PHY[0].xhispi_phy/xhispi_serdes/xhispi_phy_xilinx/inst/clkout_buf_inst/O}]] -group [get_clocks -of_objects [get_pins xsystem_pb_wrapper/system_pb_i/clk_wiz_0/inst/mmcm_adv_inst/CLKOUT0]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {xsystem_pb_wrapper/system_pb_i/hispi_line_writer/axiHiSPi_0/U0/xhispi_top/G_HISPI_PHY[1].xhispi_phy/xhispi_serdes/xhispi_phy_xilinx/inst/clkout_buf_inst/O}]] -group [get_clocks -of_objects [get_pins xsystem_pb_wrapper/system_pb_i/clk_wiz_0/inst/mmcm_adv_inst/CLKOUT0]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {xsystem_pb_wrapper/system_pb_i/hispi_line_writer/axiHiSPi_0/U0/xhispi_top/G_HISPI_PHY[2].xhispi_phy/xhispi_serdes/xhispi_phy_xilinx/inst/clkout_buf_inst/O}]] -group [get_clocks -of_objects [get_pins xsystem_pb_wrapper/system_pb_i/clk_wiz_0/inst/mmcm_adv_inst/CLKOUT0]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {xsystem_pb_wrapper/system_pb_i/hispi_line_writer/axiHiSPi_0/U0/xhispi_top/G_HISPI_PHY[3].xhispi_phy/xhispi_serdes/xhispi_phy_xilinx/inst/clkout_buf_inst/O}]] -group [get_clocks -of_objects [get_pins xsystem_pb_wrapper/system_pb_i/clk_wiz_0/inst/mmcm_adv_inst/CLKOUT0]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {xsystem_pb_wrapper/system_pb_i/hispi_line_writer/axiHiSPi_0/U0/xhispi_top/G_HISPI_PHY[4].xhispi_phy/xhispi_serdes/xhispi_phy_xilinx/inst/clkout_buf_inst/O}]] -group [get_clocks -of_objects [get_pins xsystem_pb_wrapper/system_pb_i/clk_wiz_0/inst/mmcm_adv_inst/CLKOUT0]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {xsystem_pb_wrapper/system_pb_i/hispi_line_writer/axiHiSPi_0/U0/xhispi_top/G_HISPI_PHY[5].xhispi_phy/xhispi_serdes/xhispi_phy_xilinx/inst/clkout_buf_inst/O}]] -group [get_clocks -of_objects [get_pins xsystem_pb_wrapper/system_pb_i/clk_wiz_0/inst/mmcm_adv_inst/CLKOUT0]]


# ##############################################################
# HiSPI PHY 0
# ##############################################################

# Input Delay Constraint
set_input_delay -clock [get_clocks hispi_serial_clk_p_0] -max 0.771 [get_ports [get_ports {hispi_data_n[0]}]]
set_input_delay -clock [get_clocks hispi_serial_clk_p_0] -min 0.514 [get_ports [get_ports {hispi_data_n[0]}]]
set_input_delay -clock [get_clocks hispi_serial_clk_p_0] -clock_fall -max -add_delay 0.771 [get_ports [get_ports {hispi_data_n[0]}]]
set_input_delay -clock [get_clocks hispi_serial_clk_p_0] -clock_fall -min -add_delay 0.514 [get_ports [get_ports {hispi_data_n[0]}]]


# ##############################################################
# HiSPI PHY 1
# ##############################################################

# Input Delay Constraint
set_input_delay -clock [get_clocks hispi_serial_clk_p_1] -max 0.771 [get_ports [get_ports {hispi_data_n[1]}]]
set_input_delay -clock [get_clocks hispi_serial_clk_p_1] -min 0.514 [get_ports [get_ports {hispi_data_n[1]}]]
set_input_delay -clock [get_clocks hispi_serial_clk_p_1] -clock_fall -max -add_delay 0.771 [get_ports [get_ports {hispi_data_n[1]}]]
set_input_delay -clock [get_clocks hispi_serial_clk_p_1] -clock_fall -min -add_delay 0.514 [get_ports [get_ports {hispi_data_n[1]}]]

# ##############################################################
# HiSPI PHY 2
# ##############################################################

# Input Delay Constraint
set_input_delay -clock [get_clocks hispi_serial_clk_p_2] -max 0.771 [get_ports [get_ports {hispi_data_n[2]}]]
set_input_delay -clock [get_clocks hispi_serial_clk_p_2] -min 0.514 [get_ports [get_ports {hispi_data_n[2]}]]
set_input_delay -clock [get_clocks hispi_serial_clk_p_2] -clock_fall -max -add_delay 0.771 [get_ports [get_ports {hispi_data_n[2]}]]
set_input_delay -clock [get_clocks hispi_serial_clk_p_2] -clock_fall -min -add_delay 0.514 [get_ports [get_ports {hispi_data_n[2]}]]


# ##############################################################
# HiSPI PHY 3
# ##############################################################

# Input Delay Constraint
set_input_delay -clock [get_clocks hispi_serial_clk_p_3] -max 0.771 [get_ports [get_ports {hispi_data_n[3]}]]
set_input_delay -clock [get_clocks hispi_serial_clk_p_3] -min 0.514 [get_ports [get_ports {hispi_data_n[3]}]]
set_input_delay -clock [get_clocks hispi_serial_clk_p_3] -clock_fall -max -add_delay 0.771 [get_ports [get_ports {hispi_data_n[3]}]]
set_input_delay -clock [get_clocks hispi_serial_clk_p_3] -clock_fall -min -add_delay 0.514 [get_ports [get_ports {hispi_data_n[3]}]]


# ##############################################################
# HiSPI PHY 4
# ##############################################################

# Input Delay Constraint
set_input_delay -clock [get_clocks hispi_serial_clk_p_4] -max 0.771 [get_ports [get_ports {hispi_data_n[4]}]]
set_input_delay -clock [get_clocks hispi_serial_clk_p_4] -min 0.514 [get_ports [get_ports {hispi_data_n[4]}]]
set_input_delay -clock [get_clocks hispi_serial_clk_p_4] -clock_fall -max -add_delay 0.771 [get_ports [get_ports {hispi_data_n[4]}]]
set_input_delay -clock [get_clocks hispi_serial_clk_p_4] -clock_fall -min -add_delay 0.514 [get_ports [get_ports {hispi_data_n[4]}]]


# ##############################################################
# HiSPI PHY 5
# ##############################################################

# Input Delay Constraint
set_input_delay -clock [get_clocks hispi_serial_clk_p_5] -max 0.771 [get_ports [get_ports {hispi_data_n[5]}]]
set_input_delay -clock [get_clocks hispi_serial_clk_p_5] -min 0.514 [get_ports [get_ports {hispi_data_n[5]}]]
set_input_delay -clock [get_clocks hispi_serial_clk_p_5] -clock_fall -max -add_delay 0.771 [get_ports [get_ports {hispi_data_n[5]}]]
set_input_delay -clock [get_clocks hispi_serial_clk_p_5] -clock_fall -min -add_delay 0.514 [get_ports [get_ports {hispi_data_n[5]}]]


# Report Timing Template
#report_timing -rise_from [get_ports $hispi_input] -max_paths 20 -nworst 2 -delay_type min_max -name src_sync_cntr_ddr_in_rise  -file src_sync_cntr_ddr_in_rise.txt;
#report_timing -fall_from [get_ports $hispi_input] -max_paths 20 -nworst 2 -delay_type min_max -name src_sync_cntr_ddr_in_fall  -file src_sync_cntr_ddr_in_fall.txt;



