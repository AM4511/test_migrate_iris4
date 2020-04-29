# #####################################################################################
# IO clocks
# #####################################################################################
create_clock -period 10.000 -name io_pcie_ref_clk     -waveform {0.000 5.000} [get_ports PCIE_CLK_QO_P]
# create_clock -period 2.570  -name io_hispi_clk_top    -waveform {0.000 1.285} [get_ports FMC_HPC_CLK0_M2C_P]
# create_clock -period 2.570  -name io_hispi_clk_bottom -waveform {0.000 1.285} [get_ports FMC_HPC_CLK1_M2C_P]

# #####################################################################################
# IO LANES HiSPi Top interface
# #####################################################################################
# HiSPi Lane 0
# set_input_delay -clock [get_clocks io_hispi_clk_top] -min -add_delay 1.440 [get_ports FMC_HPC_LA11_P]
# set_input_delay -clock [get_clocks io_hispi_clk_top] -max -add_delay 1.490 [get_ports FMC_HPC_LA11_P]
# set_input_delay -clock [get_clocks io_hispi_clk_top] -clock_fall -min -add_delay 1.440 [get_ports FMC_HPC_LA11_P]
# set_input_delay -clock [get_clocks io_hispi_clk_top] -clock_fall -max -add_delay 1.490 [get_ports FMC_HPC_LA11_P]

# HiSPi Lane 8
# set_input_delay -clock [get_clocks io_hispi_clk_top] -min -add_delay 1.440 [get_ports FMC_HPC_LA07_P]
# set_input_delay -clock [get_clocks io_hispi_clk_top] -max -add_delay 1.490 [get_ports FMC_HPC_LA07_P]
# set_input_delay -clock [get_clocks io_hispi_clk_top] -clock_fall -min -add_delay 1.440 [get_ports FMC_HPC_LA07_P]
# set_input_delay -clock [get_clocks io_hispi_clk_top] -clock_fall -max -add_delay 1.490 [get_ports FMC_HPC_LA07_P]

# HiSPi Lane 16
# set_input_delay -clock [get_clocks io_hispi_clk_top] -min -add_delay 1.440 [get_ports FMC_HPC_LA03_P]
# set_input_delay -clock [get_clocks io_hispi_clk_top] -max -add_delay 1.490 [get_ports FMC_HPC_LA03_P]
# set_input_delay -clock [get_clocks io_hispi_clk_top] -clock_fall -min -add_delay 1.440 [get_ports FMC_HPC_LA03_P]
# set_input_delay -clock [get_clocks io_hispi_clk_top] -clock_fall -max -add_delay 1.490 [get_ports FMC_HPC_LA03_P]

# #####################################################################################
# IO LANES HiSPi Bottom interface
# #####################################################################################
# HiSPi Lane 1
# set_input_delay -clock [get_clocks io_hispi_clk_bottom] -min -add_delay 1.440 [get_ports FMC_HPC_LA28_P]
# set_input_delay -clock [get_clocks io_hispi_clk_bottom] -max -add_delay 1.490 [get_ports FMC_HPC_LA28_P]
# set_input_delay -clock [get_clocks io_hispi_clk_bottom] -clock_fall -min -add_delay 1.440 [get_ports FMC_HPC_LA28_P]
# set_input_delay -clock [get_clocks io_hispi_clk_bottom] -clock_fall -max -add_delay 1.490 [get_ports FMC_HPC_LA28_P]

# HiSPi Lane 9
# set_input_delay -clock [get_clocks io_hispi_clk_bottom] -min -add_delay 1.440 [get_ports FMC_HPC_LA27_P]
# set_input_delay -clock [get_clocks io_hispi_clk_bottom] -max -add_delay 1.490 [get_ports FMC_HPC_LA27_P]
# set_input_delay -clock [get_clocks io_hispi_clk_bottom] -clock_fall -min -add_delay 1.440 [get_ports FMC_HPC_LA27_P]
# set_input_delay -clock [get_clocks io_hispi_clk_bottom] -clock_fall -max -add_delay 1.490 [get_ports FMC_HPC_LA27_P]


# HiSPi Lane 17
# set_input_delay -clock [get_clocks io_hispi_clk_bottom] -min -add_delay 1.440 [get_ports FMC_HPC_LA23_P]
# set_input_delay -clock [get_clocks io_hispi_clk_bottom] -max -add_delay 1.490 [get_ports FMC_HPC_LA23_P]
# set_input_delay -clock [get_clocks io_hispi_clk_bottom] -clock_fall -min -add_delay 1.440 [get_ports FMC_HPC_LA23_P]
# set_input_delay -clock [get_clocks io_hispi_clk_bottom] -clock_fall -max -add_delay 1.490 [get_ports FMC_HPC_LA23_P]




# #####################################################################################
# HISPI Internal logic : SERDES clocks
# #####################################################################################

# TOP SERDES generated clock "hispi_clk_top"
# set SRC_PIN  [get_pins -hierarchical -filter {NAME =~ */top_hispi_phy/xhispi_serdes/xhispi_phy_xilinx/inst/clkout_buf_inst/I}]
# set DEST_PIN [get_pins -hierarchical -filter {NAME =~ */top_hispi_phy/xhispi_serdes/xhispi_phy_xilinx/inst/clkout_buf_inst/O}]
# create_generated_clock -name hispi_clk_top -source $SRC_PIN -master_clock [get_clocks io_hispi_clk_top] $DEST_PIN

# Bottom SERDES generated clock "hispi_clk_bottom"
# set SRC_PIN  [get_pins -hierarchical -filter {NAME =~ */bottom_hispi_phy/xhispi_serdes/xhispi_phy_xilinx/inst/clkout_buf_inst/I}]
# set DEST_PIN [get_pins -hierarchical -filter {NAME =~ */bottom_hispi_phy/xhispi_serdes/xhispi_phy_xilinx/inst/clkout_buf_inst/O}]
# create_generated_clock -name hispi_clk_bottom -source $SRC_PIN -master_clock [get_clocks io_hispi_clk_bottom] $DEST_PIN

# Top phy, pixel clock 0 (XGS lane 0)
# set SRC_PIN  [get_pins -hierarchical -filter {NAME =~ */top_hispi_phy/G_lane_decoder[0].inst_lane_decoder/xbit_split/hispi_clk_div2_reg/C}]
# set DEST_PIN [get_pins -hierarchical -filter {NAME =~ */top_hispi_phy/G_lane_decoder[0].inst_lane_decoder/xbit_split/hispi_clk_div2_reg/Q}]
# create_generated_clock -name top_pix_clk_0 -divide_by 2 -source $SRC_PIN  $DEST_PIN

# Top phy, pixel clock 1 (XGS lane 8)
# set SRC_PIN  [get_pins -hierarchical -filter {NAME =~ */top_hispi_phy/G_lane_decoder[1].inst_lane_decoder/xbit_split/hispi_clk_div2_reg/C}]
# set DEST_PIN [get_pins -hierarchical -filter {NAME =~ */top_hispi_phy/G_lane_decoder[1].inst_lane_decoder/xbit_split/hispi_clk_div2_reg/Q}]
# create_generated_clock -name top_pix_clk_1 -divide_by 2 -source $SRC_PIN  $DEST_PIN

# Top phy, pixel clock 2 (XGS lane 16)
# set SRC_PIN  [get_pins -hierarchical -filter {NAME =~ */top_hispi_phy/G_lane_decoder[2].inst_lane_decoder/xbit_split/hispi_clk_div2_reg/C}]
# set DEST_PIN [get_pins -hierarchical -filter {NAME =~ */top_hispi_phy/G_lane_decoder[2].inst_lane_decoder/xbit_split/hispi_clk_div2_reg/Q}]
# create_generated_clock -name top_pix_clk_2 -divide_by 2 -source $SRC_PIN  $DEST_PIN

# Bottom phy, pixel clock 0 (XGS lane 1)
# set SRC_PIN  [get_pins -hierarchical -filter {NAME =~ */bottom_hispi_phy/G_lane_decoder[0].inst_lane_decoder/xbit_split/hispi_clk_div2_reg/C}]
# set DEST_PIN [get_pins -hierarchical -filter {NAME =~ */bottom_hispi_phy/G_lane_decoder[0].inst_lane_decoder/xbit_split/hispi_clk_div2_reg/Q}]
# create_generated_clock -name bottom_pix_clk_0 -divide_by 2 -source $SRC_PIN  $DEST_PIN

# Bottom phy, pixel clock 1 (XGS lane 9)
# set SRC_PIN  [get_pins -hierarchical -filter {NAME =~ */bottom_hispi_phy/G_lane_decoder[1].inst_lane_decoder/xbit_split/hispi_clk_div2_reg/C}]
# set DEST_PIN [get_pins -hierarchical -filter {NAME =~ */bottom_hispi_phy/G_lane_decoder[1].inst_lane_decoder/xbit_split/hispi_clk_div2_reg/Q}]
# create_generated_clock -name bottom_pix_clk_1 -divide_by 2 -source $SRC_PIN  $DEST_PIN

# Bottom phy, pixel clock 2 (XGS lane 17)
# set SRC_PIN  [get_pins -hierarchical -filter {NAME =~ */bottom_hispi_phy/G_lane_decoder[2].inst_lane_decoder/xbit_split/hispi_clk_div2_reg/C}]
# set DEST_PIN [get_pins -hierarchical -filter {NAME =~ */bottom_hispi_phy/G_lane_decoder[2].inst_lane_decoder/xbit_split/hispi_clk_div2_reg/Q}]
# create_generated_clock -name bottom_pix_clk_2 -divide_by 2 -source $SRC_PIN  $DEST_PIN


# Asynchronous clock groups
# set_clock_groups -name ASYNC_CLK_GROUP_A  -asynchronous  -group [get_clocks clk_125mhz] -group [get_clocks hispi_clk_top] -group [get_clocks hispi_clk_bottom]
# set_clock_groups -name ASYNC_CLK_GROUP_B  -asynchronous  -group [get_clocks clk_125mhz] -group [get_clocks -filter {NAME =~ *pix_clk*}]

