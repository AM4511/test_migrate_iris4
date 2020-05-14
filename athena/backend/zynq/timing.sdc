# #####################################################################################
# IO clocks
# #####################################################################################
create_clock -period 5.000 -name io_sysclk_ref_clk200 -waveform {0.000 2.500} [get_ports SYSCLK_P]
create_clock -period 10.000 -name io_pcie_ref_clk -waveform {0.000 5.000} [get_ports PCIE_CLK_QO_P]



####################################################################################################################
# FROM the XGS12M data sheet
# Clock and Data streams are transmitted in quadrature to
# simplify data recovery on the receiving end. Usually direct
# sampling of the data with the received clock is possible but
# this does not preclude the use of additional de-skewing and
# retiming mechanisms to improve timing margins.
# HiSPI IOs
# Tclk = 2.57 ns
# Tduty = 42-58%
# Tjit = 40-50 ns
# UI = 1.28 ns
# Clock-Data skew = +/- 0.1UI
# Trise-fall = 310ps
####################################################################################################################

####################################################################################################################
# FROME THE XILINX XDC template
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
####################################################################################################################
set clock_period        2.570;             # Period of input clock (full-period)
set dv_bre              0.386;             # Data valid before the rising clock edge (60% *clock_period/2) /2
set dv_are              0.386;             # Data valid after the rising clock edge
set dv_bfe              0.386;             # Data valid before the falling clock edge
set dv_afe              0.386;             # Data valid after the falling clock edge


# set_input_delay -clock $input_clock -max [expr $input_clock_period/2 - $dv_bfe] [get_ports $input_ports];
# set_input_delay -clock $input_clock -min $dv_are                                [get_ports $input_ports];
# set_input_delay -clock $input_clock -max [expr $input_clock_period/2 - $dv_bre] [get_ports $input_ports] -clock_fall -add_delay;
# set_input_delay -clock $input_clock -min $dv_afe                                [get_ports $input_ports] -clock_fall -add_delay;

set max_delay_rise_edge [expr $clock_period/2 - $dv_bfe]
set min_delay_rise_edge $dv_are 

set max_delay_fall_edge [expr $clock_period/2 - $dv_bre]
set min_delay_fall_edge $dv_afe 



# #####################################################################################
# IO LANES HiSPi Top interface
# #####################################################################################
create_clock -period ${clock_period}  -name io_hispi_clk_top    -waveform {0.000 1.285} [get_ports FMC_HPC_CLK0_M2C_P]

# HiSPi Lane 0
set_input_delay -clock [get_clocks io_hispi_clk_top] -min -add_delay ${min_delay_rise_edge} [get_ports FMC_HPC_LA11_P]
set_input_delay -clock [get_clocks io_hispi_clk_top] -max -add_delay ${max_delay_rise_edge} [get_ports FMC_HPC_LA11_P]
set_input_delay -clock [get_clocks io_hispi_clk_top] -clock_fall -min -add_delay ${min_delay_fall_edge} [get_ports FMC_HPC_LA11_P]
set_input_delay -clock [get_clocks io_hispi_clk_top] -clock_fall -max -add_delay ${max_delay_fall_edge} [get_ports FMC_HPC_LA11_P]

# HiSPi Lane 8
set_input_delay -clock [get_clocks io_hispi_clk_top] -min -add_delay ${min_delay_rise_edge} [get_ports FMC_HPC_LA07_P]
set_input_delay -clock [get_clocks io_hispi_clk_top] -max -add_delay ${max_delay_rise_edge} [get_ports FMC_HPC_LA07_P]
set_input_delay -clock [get_clocks io_hispi_clk_top] -clock_fall -min -add_delay ${min_delay_fall_edge} [get_ports FMC_HPC_LA07_P]
set_input_delay -clock [get_clocks io_hispi_clk_top] -clock_fall -max -add_delay ${max_delay_fall_edge} [get_ports FMC_HPC_LA07_P]

# HiSPi Lane 16
set_input_delay -clock [get_clocks io_hispi_clk_top] -min -add_delay ${min_delay_rise_edge} [get_ports FMC_HPC_LA03_P]
set_input_delay -clock [get_clocks io_hispi_clk_top] -max -add_delay ${max_delay_rise_edge} [get_ports FMC_HPC_LA03_P]
set_input_delay -clock [get_clocks io_hispi_clk_top] -clock_fall -min -add_delay ${min_delay_fall_edge} [get_ports FMC_HPC_LA03_P]
set_input_delay -clock [get_clocks io_hispi_clk_top] -clock_fall -max -add_delay ${max_delay_fall_edge} [get_ports FMC_HPC_LA03_P]

# #####################################################################################
# IO LANES HiSPi Bottom interface
# #####################################################################################
create_clock -period ${clock_period}  -name io_hispi_clk_bottom -waveform {0.000 1.285} [get_ports FMC_HPC_CLK1_M2C_P]


# HiSPi Lane 1
set_input_delay -clock [get_clocks io_hispi_clk_bottom] -min -add_delay ${min_delay_rise_edge} [get_ports FMC_HPC_LA28_P]
set_input_delay -clock [get_clocks io_hispi_clk_bottom] -max -add_delay ${max_delay_rise_edge} [get_ports FMC_HPC_LA28_P]
set_input_delay -clock [get_clocks io_hispi_clk_bottom] -clock_fall -min -add_delay ${min_delay_fall_edge} [get_ports FMC_HPC_LA28_P]
set_input_delay -clock [get_clocks io_hispi_clk_bottom] -clock_fall -max -add_delay ${max_delay_fall_edge} [get_ports FMC_HPC_LA28_P]


# HiSPi Lane 9
set_input_delay -clock [get_clocks io_hispi_clk_bottom] -min -add_delay ${min_delay_rise_edge} [get_ports FMC_HPC_LA27_P]
set_input_delay -clock [get_clocks io_hispi_clk_bottom] -max -add_delay ${max_delay_rise_edge} [get_ports FMC_HPC_LA27_P]
set_input_delay -clock [get_clocks io_hispi_clk_bottom] -clock_fall -min -add_delay ${min_delay_fall_edge} [get_ports FMC_HPC_LA27_P]
set_input_delay -clock [get_clocks io_hispi_clk_bottom] -clock_fall -max -add_delay ${max_delay_fall_edge} [get_ports FMC_HPC_LA27_P]


# HiSPi Lane 17
set_input_delay -clock [get_clocks io_hispi_clk_bottom] -min -add_delay ${min_delay_rise_edge} [get_ports FMC_HPC_LA23_P]
set_input_delay -clock [get_clocks io_hispi_clk_bottom] -max -add_delay ${max_delay_rise_edge} [get_ports FMC_HPC_LA23_P]
set_input_delay -clock [get_clocks io_hispi_clk_bottom] -clock_fall -min -add_delay ${min_delay_fall_edge} [get_ports FMC_HPC_LA23_P]
set_input_delay -clock [get_clocks io_hispi_clk_bottom] -clock_fall -max -add_delay ${max_delay_fall_edge} [get_ports FMC_HPC_LA23_P]



set_false_path -rise_from [get_clocks io_hispi_clk_top] -rise_to [get_clocks io_hispi_clk_top]
set_false_path -fall_from [get_clocks io_hispi_clk_top] -fall_to [get_clocks io_hispi_clk_top]
set_false_path -rise_from [get_clocks io_hispi_clk_bottom] -rise_to [get_clocks io_hispi_clk_bottom]
set_false_path -fall_from [get_clocks io_hispi_clk_bottom] -fall_to [get_clocks io_hispi_clk_bottom]


# Report Timing Template
# report_timing -rise_from [get_ports $input_ports] -max_paths 20 -nworst 2 -delay_type min_max -name src_sync_cntr_ddr_in_rise  -file src_sync_cntr_ddr_in_rise.txt;
# report_timing -fall_from [get_ports $input_ports] -max_paths 20 -nworst 2 -delay_type min_max -name src_sync_cntr_ddr_in_fall  -file src_sync_cntr_ddr_in_fall.txt;
          


# ###################################################################################################################
# Rename generated clock : userclk1
# ###################################################################################################################
set src_pin [get_pins xsystem_wrapper/system_i/pcie2AxiMaster_0/U0/xxil_pcie/pcie_7x_0_xil_wrapper/inst/inst/gt_top_i/pipe_wrapper_i/pipe_clock_int.pipe_clock_i/mmcm_i/CLKIN1] 
set clk_pin [get_pins xsystem_wrapper/system_i/pcie2AxiMaster_0/U0/xxil_pcie/pcie_7x_0_xil_wrapper/inst/inst/gt_top_i/pipe_wrapper_i/pipe_clock_int.pipe_clock_i/mmcm_i/CLKOUT2]
create_generated_clock -name axiClk62MHz -source $src_pin -master_clock [get_clocks txoutclk_x0y0] $clk_pin


# ###################################################################################################################
# Rename generated clock : hclk
# ###################################################################################################################
set src_pin [get_pins xsystem_wrapper/system_i/XGS_athena_0/U0/x_xgs_hispi_top/xbottom_hispi_phy/xhispi_serdes/xhispi_phy_xilinx/inst/clkout_buf_inst/I]
set clk_pin [get_pins xsystem_wrapper/system_i/XGS_athena_0/U0/x_xgs_hispi_top/xbottom_hispi_phy/xhispi_serdes/xhispi_phy_xilinx/inst/clkout_buf_inst/O]
create_generated_clock -name hclk_bottom -source $src_pin -master_clock [get_clocks io_hispi_clk_bottom] $clk_pin


# ###################################################################################################################
# Rename generated clock : hclk_1
# ###################################################################################################################
set src_pin [get_pins xsystem_wrapper/system_i/XGS_athena_0/U0/x_xgs_hispi_top/xtop_hispi_phy/xhispi_serdes/xhispi_phy_xilinx/inst/clkout_buf_inst/I]
set clk_pin [get_pins xsystem_wrapper/system_i/XGS_athena_0/U0/x_xgs_hispi_top/xtop_hispi_phy/xhispi_serdes/xhispi_phy_xilinx/inst/clkout_buf_inst/O]
create_generated_clock -name hclk_top -source $src_pin -master_clock [get_clocks io_hispi_clk_top] $clk_pin


# ###################################################################################################################
# Top pixel clock (Generated clock)
# ###################################################################################################################
set src_pin [get_pins xsystem_wrapper/system_i/XGS_athena_0/U0/x_xgs_hispi_top/xtop_hispi_phy/xpclk_buffer/I] 
set clk_pin [get_pins xsystem_wrapper/system_i/XGS_athena_0/U0/x_xgs_hispi_top/xtop_hispi_phy/xpclk_buffer/O]
create_generated_clock -name pclk_top -source $src_pin -master_clock [get_clocks hclk_top] $clk_pin


# ###################################################################################################################
# Bottom pixel clock (Generated clock)
# ###################################################################################################################
set src_pin [get_pins xsystem_wrapper/system_i/XGS_athena_0/U0/x_xgs_hispi_top/xbottom_hispi_phy/xpclk_buffer/I] 
set clk_pin [get_pins xsystem_wrapper/system_i/XGS_athena_0/U0/x_xgs_hispi_top/xbottom_hispi_phy/xpclk_buffer/O]
create_generated_clock -name pclk_bottom -source $src_pin -master_clock [get_clocks hclk_bottom] $clk_pin

# ###################################################################################################################
# Clock domain crossing false path
# ###################################################################################################################
set_clock_groups -asynchronous -group [get_clocks axiClk62MHz] -group [get_clocks hclk_bottom] 
set_clock_groups -asynchronous -group [get_clocks axiClk62MHz] -group [get_clocks hclk_top] 
set_clock_groups -asynchronous -group [get_clocks axiClk62MHz] -group [get_clocks pclk_top] 
set_clock_groups -asynchronous -group [get_clocks axiClk62MHz] -group [get_clocks pclk_bottom] 

# set_clock_groups -asynchronous -group [get_clocks axiClk62MHz] -group [get_clocks pixClk_0] 
# set_clock_groups -asynchronous -group [get_clocks axiClk62MHz] -group [get_clocks pixClk_1] 
# set_clock_groups -asynchronous -group [get_clocks axiClk62MHz] -group [get_clocks pixClk_2] 
# set_clock_groups -asynchronous -group [get_clocks axiClk62MHz] -group [get_clocks pixClk_3] 
# set_clock_groups -asynchronous -group [get_clocks axiClk62MHz] -group [get_clocks pixClk_4] 
# set_clock_groups -asynchronous -group [get_clocks axiClk62MHz] -group [get_clocks pixClk_5] 



# ###################################################################################################################
#  SMBus TIMING CONTRAINTS
# ###################################################################################################################
create_generated_clock -name i2c_clk_div_384 -source [get_pins */*/*/*/Xi2c_if/Gen_i2c_clk_from_625.i2c_clk_div_384_reg/C] -divide_by 384 [get_pins */*/*/*/Xi2c_if/Gen_i2c_clk_from_625.i2c_clk_div_384_reg/Q]
#par design, les path des registres vers la clock I2C ne sont pas critiques (ni en setup, ni en hold) car la valeur est ecrite dans le registre plusieurs centaines de clocks avant d'etre utilise.
set_false_path -from [get_pins */*/*/*/Xregfile_i2c/*I2C*/C] -to [get_clocks i2c_clk_div_384]

# ff in the IOB
# clk cannot be placed in REG IOB becase it is used internally!
#set_property IOB TRUE [get_cells {xi2c_if/GEN_X1_ser_data_out.clk_outx_reg[0]}]
set_property IOB TRUE [get_cells {*/*/*/*/Xi2c_if/GEN_X1_ser_data_out.data_outx_reg[0]}]

#je rajoute le datapath_only pour enlever le check de hold.  Le check de setup etait mauvais de toute facon!
set_max_delay -datapath_only -from [get_ports smbdata] -to [get_clocks i2c_clk_div_384] 16.500
set_min_delay -from [get_ports smbdata] -to [get_clocks i2c_clk_div_384] 0.000

set_max_delay -from [get_clocks i2c_clk_div_384] -to [get_ports smbclk] 16.500
set_min_delay -from [get_clocks i2c_clk_div_384] -to [get_ports smbclk] 0.000

set_max_delay -from [get_clocks i2c_clk_div_384] -to [get_ports smbdata] 16.000
set_min_delay -from [get_clocks i2c_clk_div_384] -to [get_ports smbdata] 0.000

set_false_path -to [get_pins */*/*/*/Xi2c_if/triggerresync/dst_cycle_int_reg/D]
set_false_path -to [get_pins */*/*/*/Xi2c_if/triggerresync/domain_dst_change_p1_reg/D]

#------------------------------------------------------------
#  XGS CONTROLLER TIMING CONTRAINTS
#------------------------------------------------------------

# INPUTS
set_false_path -from [get_ports {FMC_HPC_LA16_P}]

set_max_delay -from [get_ports FMC_HPC_LA14_N] -to [get_clocks axiClk62MHz] 15.000
set_min_delay -from [get_ports FMC_HPC_LA14_N] -to [get_clocks axiClk62MHz] 0.000

# OUTPUTS
set_max_delay -from [get_clocks axiClk62MHz] -to [get_ports {FMC_HPC_LA15_P}] 15.000
set_min_delay -from [get_clocks axiClk62MHz] -to [get_ports {FMC_HPC_LA15_P}] 0.000

set_max_delay -from [get_clocks axiClk62MHz] -to [get_ports {FMC_HPC_LA13_P FMC_HPC_LA14_P FMC_HPC_LA13_N}] 15.000
set_min_delay -from [get_clocks axiClk62MHz] -to [get_ports {FMC_HPC_LA13_P FMC_HPC_LA14_P FMC_HPC_LA13_N}] 0.000

set_false_path -to [get_ports {USER_SMA_CLOCK_P}]
set_false_path -to [get_ports {USER_SMA_CLOCK_P}]

set_false_path -to [get_ports {GPIO_LED_LEFT}]
set_false_path -to [get_ports {GPIO_LED_CENTER}]
set_false_path -to [get_ports {GPIO_LED_RIGHT}]
set_false_path -to [get_ports {GPIO_LED_0}]




