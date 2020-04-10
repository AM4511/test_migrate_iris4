
create_clock -period 10.000 -name ref_clk -waveform {0.000 5.000} [get_ports ref_clk]
create_clock -period 10.000 -name pcie_clk_p -waveform {0.000 5.000} [get_ports pcie_clk_p]


create_clock -period 2.570 -name {xgs_hispi_sclk_p[0]} -waveform {0.000 1.285} [get_ports {xgs_hispi_sclk_p[0]}]
create_clock -period 2.570 -name {xgs_hispi_sclk_p[1]} -waveform {0.000 1.285} [get_ports {xgs_hispi_sclk_p[1]}]


####################################################################################################################
# HiSPI IOs
####################################################################################################################
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[0]}] -clock_fall -min -add_delay 1.440 [get_ports {xgs_hispi_sdata_p[*]}]
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[0]}] -clock_fall -max -add_delay 1.490 [get_ports {xgs_hispi_sdata_p[*]}]
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[0]}] -min -add_delay 1.440 [get_ports {xgs_hispi_sdata_p[*]}]
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[0]}] -max -add_delay 1.490 [get_ports {xgs_hispi_sdata_p[*]}]

set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[1]}] -clock_fall -min -add_delay 1.440 [get_ports {xgs_hispi_sdata_p[*]}]
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[1]}] -clock_fall -max -add_delay 1.490 [get_ports {xgs_hispi_sdata_p[*]}]
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[1]}] -min -add_delay 1.440 [get_ports {xgs_hispi_sdata_p[*]}]
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[1]}] -max -add_delay 1.490 [get_ports {xgs_hispi_sdata_p[*]}]

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

