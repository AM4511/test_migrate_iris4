# (c) Copyright 2009 - 2012 Xilinx, Inc. All rights reserved.
#
# This file contains confidential and proprietary information
# of Xilinx, Inc. and is protected under U.S. and
# international copyright and other intellectual property
# laws.
#
# DISCLAIMER
# This disclaimer is not a license and does not grant any
# rights to the materials distributed herewith. Except as
# otherwise provided in a valid license issued to you by
# Xilinx, and to the maximum extent permitted by applicable
# law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
# WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
# AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
# BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
# INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
# (2) Xilinx shall not be liable (whether in contract or tort,
# including negligence, or under any other theory of
# liability) for any loss or damage of any kind or nature
# related to, arising under or in connection with these
# materials, including for any direct, or any indirect,
# special, incidental, or consequential loss or damage
# (including loss of data, profits, goodwill, or any type of
# loss or damage suffered as a result of any action brought
# by a third party) even if such damage or loss was
# reasonably foreseeable or Xilinx had been advised of the
# possibility of the same.
#
# CRITICAL APPLICATIONS
# Xilinx products are not designed or intended to be fail-
# safe, or for use in any application requiring fail-safe
# performance, such as life-support or safety devices or
# systems, Class III medical devices, nuclear facilities,
# applications related to the deployment of airbags, or any
# other applications that could lead to death, personal
# injury, or severe property or environmental damage
# (individually and collectively, "Critical
# Applications"). Customer assumes the sole risk and
# liability of any use of Xilinx products in Critical
# Applications, subject only to applicable laws and
# regulations governing limitations on product liability.
#
# THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
# PART OF THIS FILE AT ALL TIMES.


## IOB constraints ######
set_property IOB TRUE [get_cells -hierarchical -filter {NAME =~*IO*_I_REG}]

#####################################################################################################
# The following section list the board specific constraints (with/without STARTUPE2/E3 primitive)   #
# as per guidance given in product guide.                                                           #
# User should uncomment, update constraints based on board delays and use                           #
#####################################################################################################

#####################################################################################################
# STARTUPE2 primitive included inside IP                                                            #
#####################################################################################################

#### All the delay numbers have to be provided by the user

#### CCLK delay is 0.5, 7.5 ns min/max for Artix7-1LI; refer Data sheet (DS181)
#### Consider the max delay for worst case analysis


#### Following are the ISSI IS25WP064A SPI device parameters
#### Max Tco
#### Min Tco
#### Setup time requirement
#### Hold time requirement

# TBD
#### Following are the board/trace delay numbers
#### Assumption is that all Data lines are matched
##### End of user provided delay numbers

#### This is to ensure min routing delay from SCK generation to STARTUP input
#### User should change this value based on the results having more delay on this net reduces the Fmax
set_min_delay -from [get_pins -hier *SCK_O_reg_reg/C] -to [get_pins -hier *USRCCLKO] 0.100
set_max_delay -datapath_only -from [get_pins -hier *SCK_O_reg_reg/C] -to [get_pins -hier *USRCCLKO] 3.000

#### Following command creates a divide by 2 clock
#### It also takes into account the delay added by STARTUP block to route the CCLK
create_generated_clock -name clk_sck -source [get_pins -hierarchical *axi_quad_spi_0/ext_spi_clk] -edges {3 5 7} -edge_shift {7.500 7.500 7.500} [get_pins -hierarchical *USRCCLKO]

#### Data is captured into FPGA on the second rising edge of ext_spi_clk after the SCK falling edge
#### Data is driven by the FPGA on every alternate rising_edge of ext_spi_clk
set_input_delay -clock clk_sck -clock_fall -max 8.000 [get_ports spi_sd]
set_input_delay -clock clk_sck -clock_fall -min 0.000 [get_ports spi_sd]
set_multicycle_path -setup -from [get_clocks clk_sck] -to [get_clocks -of_objects [get_pins -hierarchical */ext_spi_clk]] 2
set_multicycle_path -hold -end -from [get_clocks clk_sck] -to [get_clocks -of_objects [get_pins -hierarchical */ext_spi_clk]] 1

#### Data is captured into SPI on the following rising edge of SCK
#### Data is driven by the IP on alternate rising_edge of the ext_spi_clk
set_output_delay -clock [get_clocks clk_sck] -max 2.000 [get_ports spi_sd]
set_output_delay -clock [get_clocks clk_sck] -min -2.000 [get_ports spi_sd]
set_multicycle_path -setup -start -from [get_clocks -of_objects [get_pins -hierarchical */ext_spi_clk]] -to [get_clocks clk_sck] 2
set_multicycle_path -hold -from [get_clocks -of_objects [get_pins -hierarchical */ext_spi_clk]] -to [get_clocks clk_sck] 1



