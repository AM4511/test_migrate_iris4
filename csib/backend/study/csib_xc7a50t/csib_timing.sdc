create_clock -period 10.000 -name pcie_sys_clk_p -waveform {0.000 5.000} [get_ports pcie_sys_clk_p]


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
set hispi_clk_root_name         "";      # Name of input clock
set input_clock_period  2.570;                        # Period of input clock (full-period)
set UI                  [expr $input_clock_period/2]; # Unit interval is half the clock period
set dv_bre              [expr ($UI/2) - 0.1*$UI];                      # Data valid before the rising clock edge
set dv_are              [expr ($UI/2) - 0.1*$UI];                      # Data valid after the rising clock edge
set dv_bfe              [expr ($UI/2) - 0.1*$UI];                      # Data valid before the falling clock edge
set dv_afe              [expr ($UI/2) - 0.1*$UI];                      # Data valid after the falling clock edge

create_clock -period ${input_clock_period} -name hispi_serial_clk_p_0 [get_ports {hispi_serial_clk_p[0]}]
create_clock -period ${input_clock_period} -name hispi_serial_clk_p_1 [get_ports {hispi_serial_clk_p[1]}]
create_clock -period ${input_clock_period} -name hispi_serial_clk_p_2 [get_ports {hispi_serial_clk_p[2]}]
create_clock -period ${input_clock_period} -name hispi_serial_clk_p_3 [get_ports {hispi_serial_clk_p[3]}]
create_clock -period ${input_clock_period} -name hispi_serial_clk_p_4 [get_ports {hispi_serial_clk_p[4]}]
create_clock -period ${input_clock_period} -name hispi_serial_clk_p_5 [get_ports {hispi_serial_clk_p[5]}]

set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {xsystem_pb_wrapper/system_pb_i/hispi_line_writer/axiHiSPi_0/U0/xhispi_top/G_HISPI_PHY[0].xhispi_phy/xhispi_serdes/xhispi_phy_xilinx/inst/clkout_buf_inst/O}]] -group [get_clocks -of_objects [get_pins xsystem_pb_wrapper/system_pb_i/clk_wiz_0/inst/mmcm_adv_inst/CLKOUT0]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {xsystem_pb_wrapper/system_pb_i/hispi_line_writer/axiHiSPi_0/U0/xhispi_top/G_HISPI_PHY[1].xhispi_phy/xhispi_serdes/xhispi_phy_xilinx/inst/clkout_buf_inst/O}]] -group [get_clocks -of_objects [get_pins xsystem_pb_wrapper/system_pb_i/clk_wiz_0/inst/mmcm_adv_inst/CLKOUT0]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {xsystem_pb_wrapper/system_pb_i/hispi_line_writer/axiHiSPi_0/U0/xhispi_top/G_HISPI_PHY[2].xhispi_phy/xhispi_serdes/xhispi_phy_xilinx/inst/clkout_buf_inst/O}]] -group [get_clocks -of_objects [get_pins xsystem_pb_wrapper/system_pb_i/clk_wiz_0/inst/mmcm_adv_inst/CLKOUT0]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {xsystem_pb_wrapper/system_pb_i/hispi_line_writer/axiHiSPi_0/U0/xhispi_top/G_HISPI_PHY[3].xhispi_phy/xhispi_serdes/xhispi_phy_xilinx/inst/clkout_buf_inst/O}]] -group [get_clocks -of_objects [get_pins xsystem_pb_wrapper/system_pb_i/clk_wiz_0/inst/mmcm_adv_inst/CLKOUT0]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {xsystem_pb_wrapper/system_pb_i/hispi_line_writer/axiHiSPi_0/U0/xhispi_top/G_HISPI_PHY[4].xhispi_phy/xhispi_serdes/xhispi_phy_xilinx/inst/clkout_buf_inst/O}]] -group [get_clocks -of_objects [get_pins xsystem_pb_wrapper/system_pb_i/clk_wiz_0/inst/mmcm_adv_inst/CLKOUT0]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {xsystem_pb_wrapper/system_pb_i/hispi_line_writer/axiHiSPi_0/U0/xhispi_top/G_HISPI_PHY[5].xhispi_phy/xhispi_serdes/xhispi_phy_xilinx/inst/clkout_buf_inst/O}]] -group [get_clocks -of_objects [get_pins xsystem_pb_wrapper/system_pb_i/clk_wiz_0/inst/mmcm_adv_inst/CLKOUT0]]


# ##############################################################
# HiSPI PHY 0
# ##############################################################
set hispi_clk   [get_clocks {hispi_serial_clk_p_0}];
set hispi_input [get_ports {hispi_data_n[0]}];

# Input Delay Constraint
set_input_delay -clock $hispi_clk -max [expr $input_clock_period/2 - $dv_bfe] [get_ports $hispi_input];
set_input_delay -clock $hispi_clk -min $dv_are                                [get_ports $hispi_input];
set_input_delay -clock $hispi_clk -max [expr $input_clock_period/2 - $dv_bre] [get_ports $hispi_input] -clock_fall -add_delay;
set_input_delay -clock $hispi_clk -min $dv_afe                                [get_ports $hispi_input] -clock_fall -add_delay;


# ##############################################################
# HiSPI PHY 1
# ##############################################################
set hispi_clk   [get_clocks {hispi_serial_clk_p_1}];
set hispi_input [get_ports {hispi_data_n[1]}];

# Input Delay Constraint
set_input_delay -clock $hispi_clk -max [expr $input_clock_period/2 - $dv_bfe] [get_ports $hispi_input];
set_input_delay -clock $hispi_clk -min $dv_are                                [get_ports $hispi_input];
set_input_delay -clock $hispi_clk -max [expr $input_clock_period/2 - $dv_bre] [get_ports $hispi_input] -clock_fall -add_delay;
set_input_delay -clock $hispi_clk -min $dv_afe                                [get_ports $hispi_input] -clock_fall -add_delay;

# ##############################################################
# HiSPI PHY 2
# ##############################################################
set hispi_clk   [get_clocks {hispi_serial_clk_p_2}];
set hispi_input [get_ports {hispi_data_n[2]}];

# Input Delay Constraint
set_input_delay -clock $hispi_clk -max [expr $input_clock_period/2 - $dv_bfe] [get_ports $hispi_input];
set_input_delay -clock $hispi_clk -min $dv_are                                [get_ports $hispi_input];
set_input_delay -clock $hispi_clk -max [expr $input_clock_period/2 - $dv_bre] [get_ports $hispi_input] -clock_fall -add_delay;
set_input_delay -clock $hispi_clk -min $dv_afe                                [get_ports $hispi_input] -clock_fall -add_delay;


# ##############################################################
# HiSPI PHY 3
# ##############################################################
set hispi_clk   [get_clocks {hispi_serial_clk_p_3}];
set hispi_input [get_ports {hispi_data_n[3]}];

# Input Delay Constraint
set_input_delay -clock $hispi_clk -max [expr $input_clock_period/2 - $dv_bfe] [get_ports $hispi_input];
set_input_delay -clock $hispi_clk -min $dv_are                                [get_ports $hispi_input];
set_input_delay -clock $hispi_clk -max [expr $input_clock_period/2 - $dv_bre] [get_ports $hispi_input] -clock_fall -add_delay;
set_input_delay -clock $hispi_clk -min $dv_afe                                [get_ports $hispi_input] -clock_fall -add_delay;


# ##############################################################
# HiSPI PHY 4
# ##############################################################
set hispi_clk   [get_clocks {hispi_serial_clk_p_4}];
set hispi_input [get_ports {hispi_data_n[4]}];

# Input Delay Constraint
set_input_delay -clock $hispi_clk -max [expr $input_clock_period/2 - $dv_bfe] [get_ports $hispi_input];
set_input_delay -clock $hispi_clk -min $dv_are                                [get_ports $hispi_input];
set_input_delay -clock $hispi_clk -max [expr $input_clock_period/2 - $dv_bre] [get_ports $hispi_input] -clock_fall -add_delay;
set_input_delay -clock $hispi_clk -min $dv_afe                                [get_ports $hispi_input] -clock_fall -add_delay;


# ##############################################################
# HiSPI PHY 5
# ##############################################################
set hispi_clk   [get_clocks {hispi_serial_clk_p_5}];
set hispi_input [get_ports {hispi_data_n[5]}];

# Input Delay Constraint
set_input_delay -clock $hispi_clk -max [expr $input_clock_period/2 - $dv_bfe] [get_ports $hispi_input];
set_input_delay -clock $hispi_clk -min $dv_are                                [get_ports $hispi_input];
set_input_delay -clock $hispi_clk -max [expr $input_clock_period/2 - $dv_bre] [get_ports $hispi_input] -clock_fall -add_delay;
set_input_delay -clock $hispi_clk -min $dv_afe                                [get_ports $hispi_input] -clock_fall -add_delay;


# Report Timing Template
#report_timing -rise_from [get_ports $hispi_input] -max_paths 20 -nworst 2 -delay_type min_max -name src_sync_cntr_ddr_in_rise  -file src_sync_cntr_ddr_in_rise.txt;
#report_timing -fall_from [get_ports $hispi_input] -max_paths 20 -nworst 2 -delay_type min_max -name src_sync_cntr_ddr_in_fall  -file src_sync_cntr_ddr_in_fall.txt;
          
        