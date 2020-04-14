####################################################################################################################
# Create Athena IO Clocks
####################################################################################################################
create_clock -period 10.000 -name ref_clk -waveform {0.000 5.000} [get_ports ref_clk]
create_clock -period 10.000 -name pcie_clk_p -waveform {0.000 5.000} [get_ports pcie_clk_p]


####################################################################################################################
# Create HiSPi input clock
####################################################################################################################
create_clock -period 2.570 -name {xgs_hispi_sclk_p[0]} -waveform {0.000 1.285} [get_ports {xgs_hispi_sclk_p[0]}]
create_clock -period 2.570 -name {xgs_hispi_sclk_p[1]} -waveform {0.000 1.285} [get_ports {xgs_hispi_sclk_p[1]}]


####################################################################################################################
# FROM the XGS12M data sheet
# HiSPI IOs
# Tclk = 2.57 ns
# Tduty = 42-58%
# Tjit = 40-50 ns 
# UI = 1.28 ns
# Clock-Data skew = +/- 0.1UI
# Trise-fall = 310ps
# PCB_MIN_DELAY = PCB Min data delay + PCB max clock delay
# PCB_MAX_DELAY = PCB Max data delay + PCB min clock delay
# MAX_INPUT_DELAY = MAX_DATAPATH - MIN_CLK_PATH = UI/2 + Clock-Data_skew_max = 0.768ns
# MIN_INPUT_DELAY = MIN_DATAPATH + MAX_CLK_PATH = UI/2 + Clock-Data_skew_min = 0.512ns
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
set input_clock_period  2.57;                                    # Period of input clock (full-period)
set dv_bre              0.512;                                   # Data valid before the rising clock edge
set dv_are              0.512;                                   # Data valid after the rising clock edge
set dv_bfe              0.512;                                   # Data valid before the falling clock edge
set dv_afe              0.512;                                   # Data valid after the falling clock edge


####################################################################################################################
## XGS12M even lanes
####################################################################################################################
set input_clock         [get_clocks {xgs_hispi_sclk_p[0]}];
set input_ports         [get_ports {xgs_hispi_sdata_p[0] xgs_hispi_sdata_p[2] xgs_hispi_sdata_p[4]}];

# Input Delay Constraint
set_input_delay -clock $input_clock -max [expr $input_clock_period/2 - $dv_bfe] [get_ports $input_ports];
set_input_delay -clock $input_clock -min $dv_are                                [get_ports $input_ports];
set_input_delay -clock $input_clock -max [expr $input_clock_period/2 - $dv_bre] [get_ports $input_ports] -clock_fall -add_delay;
set_input_delay -clock $input_clock -min $dv_afe                                [get_ports $input_ports] -clock_fall -add_delay;


####################################################################################################################
## XGS12M odd lanes
####################################################################################################################
set input_clock         [get_clocks {xgs_hispi_sclk_p[1]}];
set input_ports         [get_ports {xgs_hispi_sdata_p[1] xgs_hispi_sdata_p[3] xgs_hispi_sdata_p[5]}];

# Input Delay Constraint
set_input_delay -clock $input_clock -max [expr $input_clock_period/2 - $dv_bfe] [get_ports $input_ports];
set_input_delay -clock $input_clock -min $dv_are                                [get_ports $input_ports];
set_input_delay -clock $input_clock -max [expr $input_clock_period/2 - $dv_bre] [get_ports $input_ports] -clock_fall -add_delay;
set_input_delay -clock $input_clock -min $dv_afe                                [get_ports $input_ports] -clock_fall -add_delay;





####################################################################################################################
# Top pixel clock (Generated clock)
####################################################################################################################
set TOP_SRC_CLK_PIN     [get_pins  -hier -filter {NAME =~"*axiHiSPi_0/U0/top_hispi_phy/xhispi_serdes/xhispi_phy_xilinx/inst/clkout_buf_inst/O"}]
set TOP_PIX_CLK_PIN_0   [get_pins  -hier -filter {NAME =~"*axiHiSPi_0/U0/top_hispi_phy/G_lane_decoder[0].inst_lane_decoder/xbit_split/hispi_clk_div2_reg/Q"}]
set TOP_PIX_CLK_PIN_1   [get_pins  -hier -filter {NAME =~"*axiHiSPi_0/U0/top_hispi_phy/G_lane_decoder[1].inst_lane_decoder/xbit_split/hispi_clk_div2_reg/Q"}]
set TOP_PIX_CLK_PIN_2   [get_pins  -hier -filter {NAME =~"*axiHiSPi_0/U0/top_hispi_phy/G_lane_decoder[2].inst_lane_decoder/xbit_split/hispi_clk_div2_reg/Q"}]

create_generated_clock -name pixClk_0 -divide_by 2  -source $TOP_SRC_CLK_PIN  $TOP_PIX_CLK_PIN_0
create_generated_clock -name pixClk_2 -divide_by 2  -source $TOP_SRC_CLK_PIN  $TOP_PIX_CLK_PIN_1
create_generated_clock -name pixClk_4 -divide_by 2  -source $TOP_SRC_CLK_PIN  $TOP_PIX_CLK_PIN_2

####################################################################################################################
# Bottom pixel clock (Generated clock)
####################################################################################################################
set BOTTOM_SRC_CLK_PIN   [get_pins  -hier -filter {NAME =~"*axiHiSPi_0/U0/bottom_hispi_phy/xhispi_serdes/xhispi_phy_xilinx/inst/clkout_buf_inst/O"}]
set BOTTOM_PIX_CLK_PIN_0 [get_pins  -hier -filter {NAME =~"*axiHiSPi_0/U0/bottom_hispi_phy/G_lane_decoder[0].inst_lane_decoder/xbit_split/hispi_clk_div2_reg/Q"}]
set BOTTOM_PIX_CLK_PIN_1 [get_pins  -hier -filter {NAME =~"*axiHiSPi_0/U0/bottom_hispi_phy/G_lane_decoder[1].inst_lane_decoder/xbit_split/hispi_clk_div2_reg/Q"}]
set BOTTOM_PIX_CLK_PIN_2 [get_pins  -hier -filter {NAME =~"*axiHiSPi_0/U0/bottom_hispi_phy/G_lane_decoder[2].inst_lane_decoder/xbit_split/hispi_clk_div2_reg/Q"}]

create_generated_clock -name pixClk_1 -divide_by 2  -source $BOTTOM_SRC_CLK_PIN  $BOTTOM_PIX_CLK_PIN_0
create_generated_clock -name pixClk_3 -divide_by 2  -source $BOTTOM_SRC_CLK_PIN  $BOTTOM_PIX_CLK_PIN_1
create_generated_clock -name pixClk_5 -divide_by 2  -source $BOTTOM_SRC_CLK_PIN  $BOTTOM_PIX_CLK_PIN_2


####################################################################################################################
# Rename generated clock
####################################################################################################################
create_generated_clock -name idly_clk -source [get_pins xsystem_pb_wrapper/system_pb_i/clk_wiz_0/inst/plle2_adv_inst/CLKIN1] -master_clock ref_clk [get_pins xsystem_pb_wrapper/system_pb_i/clk_wiz_0/inst/plle2_adv_inst/CLKOUT0]
create_generated_clock -name qspi_clk -source [get_pins xsystem_pb_wrapper/system_pb_i/clk_wiz_0/inst/plle2_adv_inst/CLKIN1] -master_clock ref_clk [get_pins xsystem_pb_wrapper/system_pb_i/clk_wiz_0/inst/plle2_adv_inst/CLKOUT1]


# Timing exceptions
set_false_path -from [get_ports sys_rst_n]
set_clock_groups -asynchronous -group [get_clocks {xgs_hispi_sclk_p[1]}] -group [get_clocks {xgs_hispi_sclk_p[0]}]

