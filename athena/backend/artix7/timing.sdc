####################################################################################################################
# Create Athena IO Clocks
####################################################################################################################
create_clock -period 10.000 -name ref_clk -waveform {0.000 5.000} [get_ports ref_clk]
create_clock -period 10.000 -name pcie_clk_p -waveform {0.000 5.000} [get_ports pcie_clk_p]

#create_clock -period 16.000 -name axi_clk -waveform {0.000 8.000} [get_pins xsystem_pb_wrapper/system_pb_i/pcie2AxiMaster_0/U0/xxil_pcie/pcie_7x_0_xil_wrapper/inst/inst/gt_top_i/pipe_wrapper_i/pipe_clock_int.pipe_clock_i/INT_USERCLK2_OUT]
#
#create_clock -period 16.000 -name userclk1  -waveform {0.000 8.000} get_pins xsystem_pb_wrapper/system_pb_i/pcie2AxiMaster_0/U0/xxil_pcie/pcie_7x_0_xil_wrapper/inst/inst/gt_top_i/pipe_wrapper_i/pipe_clock_int.pipe_clock_i/userclk1_i1.usrclk1_i1/O
#xsystem_pb_wrapper/system_pb_i/pcie2AxiMaster_0/U0/xxil_pcie/pcie_7x_0_xil_wrapper/inst/inst/gt_top_i/pipe_wrapper_i/pipe_clock_int.pipe_clock_i/INT_USERCLK2_OUT
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


####################################################################################################################
## XGS12M even lanes
####################################################################################################################

# Input Delay Constraint
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[0]}] -max 0.773 [get_ports [get_ports {{xgs_hispi_sdata_p[0]} {xgs_hispi_sdata_p[2]} {xgs_hispi_sdata_p[4]}}]]
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[0]}] -min 0.512 [get_ports [get_ports {{xgs_hispi_sdata_p[0]} {xgs_hispi_sdata_p[2]} {xgs_hispi_sdata_p[4]}}]]
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[0]}] -clock_fall -max -add_delay 0.773 [get_ports [get_ports {{xgs_hispi_sdata_p[0]} {xgs_hispi_sdata_p[2]} {xgs_hispi_sdata_p[4]}}]]
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[0]}] -clock_fall -min -add_delay 0.512 [get_ports [get_ports {{xgs_hispi_sdata_p[0]} {xgs_hispi_sdata_p[2]} {xgs_hispi_sdata_p[4]}}]]


set_multicycle_path -setup -from [get_ports {{xgs_hispi_sdata_p[0]} {xgs_hispi_sdata_p[2]} {xgs_hispi_sdata_p[4]}}] -to [get_clocks {xgs_hispi_sclk_p[0]}] 0
set_multicycle_path -hold -from [get_ports {{xgs_hispi_sdata_p[0]} {xgs_hispi_sdata_p[2]} {xgs_hispi_sdata_p[4]}}] -to [get_clocks {xgs_hispi_sclk_p[0]}] -1

set_false_path -rise_from [get_clocks {xgs_hispi_sclk_p[0]}] -rise_to [get_clocks {xgs_hispi_sclk_p[0]}]
set_false_path -fall_from [get_clocks {xgs_hispi_sclk_p[0]}] -fall_to [get_clocks {xgs_hispi_sclk_p[0]}]


####################################################################################################################
## XGS12M odd lanes
####################################################################################################################

# Input Delay Constraint
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[1]}] -max 0.773 [get_ports [get_ports {{xgs_hispi_sdata_p[1]} {xgs_hispi_sdata_p[3]} {xgs_hispi_sdata_p[5]}}]]
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[1]}] -min 0.512 [get_ports [get_ports {{xgs_hispi_sdata_p[1]} {xgs_hispi_sdata_p[3]} {xgs_hispi_sdata_p[5]}}]]
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[1]}] -clock_fall -max -add_delay 0.773 [get_ports [get_ports {{xgs_hispi_sdata_p[1]} {xgs_hispi_sdata_p[3]} {xgs_hispi_sdata_p[5]}}]]
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[1]}] -clock_fall -min -add_delay 0.512 [get_ports [get_ports {{xgs_hispi_sdata_p[1]} {xgs_hispi_sdata_p[3]} {xgs_hispi_sdata_p[5]}}]]


set_multicycle_path -setup -from [get_ports {{xgs_hispi_sdata_p[1]} {xgs_hispi_sdata_p[3]} {xgs_hispi_sdata_p[5]}}] -to [get_clocks {xgs_hispi_sclk_p[1]}] 0
set_multicycle_path -hold -from [get_ports {{xgs_hispi_sdata_p[1]} {xgs_hispi_sdata_p[3]} {xgs_hispi_sdata_p[5]}}] -to [get_clocks {xgs_hispi_sclk_p[1]}] -1

set_false_path -rise_from [get_clocks {xgs_hispi_sclk_p[1]}] -rise_to [get_clocks {xgs_hispi_sclk_p[1]}]
set_false_path -fall_from [get_clocks {xgs_hispi_sclk_p[1]}] -fall_to [get_clocks {xgs_hispi_sclk_p[1]}]



####################################################################################################################
# Top pixel clock (Generated clock)
####################################################################################################################

create_generated_clock -name pixClk_0 -source [get_pins -hier -filter {NAME =~"*XGS_athena_0/U0/x_xgs_hispi_top/xtop_hispi_phy/xhispi_serdes/xhispi_phy_xilinx/inst/clkout_buf_inst/O"}] -divide_by 2 [get_pins -hier -filter {NAME =~"*XGS_athena_0/U0/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder[0].inst_lane_decoder/xbit_split/hclk_div2_reg/Q"}]
create_generated_clock -name pixClk_2 -source [get_pins -hier -filter {NAME =~"*XGS_athena_0/U0/x_xgs_hispi_top/xtop_hispi_phy/xhispi_serdes/xhispi_phy_xilinx/inst/clkout_buf_inst/O"}] -divide_by 2 [get_pins -hier -filter {NAME =~"*XGS_athena_0/U0/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder[1].inst_lane_decoder/xbit_split/hclk_div2_reg/Q"}]
create_generated_clock -name pixClk_4 -source [get_pins -hier -filter {NAME =~"*XGS_athena_0/U0/x_xgs_hispi_top/xtop_hispi_phy/xhispi_serdes/xhispi_phy_xilinx/inst/clkout_buf_inst/O"}] -divide_by 2 [get_pins -hier -filter {NAME =~"*XGS_athena_0/U0/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder[2].inst_lane_decoder/xbit_split/hclk_div2_reg/Q"}]

####################################################################################################################
# Bottom pixel clock (Generated clock)
####################################################################################################################

create_generated_clock -name pixClk_1 -source [get_pins -hier -filter {NAME =~"*XGS_athena_0/U0/x_xgs_hispi_top/xbottom_hispi_phy/xhispi_serdes/xhispi_phy_xilinx/inst/clkout_buf_inst/O"}] -divide_by 2 [get_pins -hier -filter {NAME =~"*XGS_athena_0/U0/x_xgs_hispi_top/xbottom_hispi_phy/G_lane_decoder[0].inst_lane_decoder/xbit_split/hclk_div2_reg/Q"}]
create_generated_clock -name pixClk_3 -source [get_pins -hier -filter {NAME =~"*XGS_athena_0/U0/x_xgs_hispi_top/xbottom_hispi_phy/xhispi_serdes/xhispi_phy_xilinx/inst/clkout_buf_inst/O"}] -divide_by 2 [get_pins -hier -filter {NAME =~"*XGS_athena_0/U0/x_xgs_hispi_top/xbottom_hispi_phy/G_lane_decoder[1].inst_lane_decoder/xbit_split/hclk_div2_reg/Q"}]
create_generated_clock -name pixClk_5 -source [get_pins -hier -filter {NAME =~"*XGS_athena_0/U0/x_xgs_hispi_top/xbottom_hispi_phy/xhispi_serdes/xhispi_phy_xilinx/inst/clkout_buf_inst/O"}] -divide_by 2 [get_pins -hier -filter {NAME =~"*XGS_athena_0/U0/x_xgs_hispi_top/xbottom_hispi_phy/G_lane_decoder[2].inst_lane_decoder/xbit_split/hclk_div2_reg/Q"}]


####################################################################################################################
# Rename generated clock
####################################################################################################################
#create_generated_clock -name idly_clk -source [get_pins xsystem_pb_wrapper/system_pb_i/clk_wiz_0/inst/plle2_adv_inst/CLKIN1] -master_clock ref_clk [get_pins xsystem_pb_wrapper/system_pb_i/clk_wiz_0/inst/plle2_adv_inst/CLKOUT0]
#create_generated_clock -name qspi_clk -source [get_pins xsystem_pb_wrapper/system_pb_i/clk_wiz_0/inst/plle2_adv_inst/CLKIN1] -master_clock ref_clk [get_pins xsystem_pb_wrapper/system_pb_i/clk_wiz_0/inst/plle2_adv_inst/CLKOUT1]


# Timing exceptions
set_false_path -from [get_ports sys_rst_n]
set_clock_groups -asynchronous -group [get_clocks {xgs_hispi_sclk_p[1]}] -group [get_clocks {xgs_hispi_sclk_p[0]}]


#------------------------------------------------------------
#  SMBus TIMING CONTRAINTS
#------------------------------------------------------------
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
set_false_path -from [get_ports {xgs_monitor[?]}]
set_false_path -from [get_ports xgs_power_good]

set_max_delay -from [get_ports xgs_sdin] -to [get_clocks userclk1] 15.000
set_min_delay -from [get_ports xgs_sdin] -to [get_clocks userclk1] 0.000


# OUTPUTS
set_max_delay -from [get_clocks userclk1] -to [get_ports {xgs_clk_pll_en xgs_reset_n xgs_fwsi_en}] 15.000
set_min_delay -from [get_clocks userclk1] -to [get_ports {xgs_clk_pll_en xgs_reset_n xgs_fwsi_en}] 0.000

set_property IOB TRUE [get_cells */*/*/*/Inst_XGS_controller_top/Inst_xgs_ctrl/xgs_trig_int_reg]

set_max_delay -from [get_clocks userclk1] -to [get_ports {xgs_trig_int xgs_trig_rd}] 15.000
set_min_delay -from [get_clocks userclk1] -to [get_ports {xgs_trig_int xgs_trig_rd}] 0.000

set_max_delay -from [get_clocks userclk1] -to [get_ports {xgs_sclk xgs_cs_n xgs_sdout}] 15.000
set_min_delay -from [get_clocks userclk1] -to [get_ports {xgs_sclk xgs_cs_n xgs_sdout}] 0.000

set_false_path -to [get_ports {led_out[?]}]
set_false_path -to [get_ports {debug_data[?]}]


# TO/FROM ANPUT
set_false_path -to [get_ports exposure_out]
set_false_path -to [get_ports strobe_out]
set_false_path -to [get_ports trig_rdy_out]
set_false_path -from [get_ports ext_trig]







