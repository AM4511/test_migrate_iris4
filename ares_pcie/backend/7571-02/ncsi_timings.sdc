
###################################################################################
## Rename NCSI internal clock generated by the phase alignment PLL.
## These are more convenient names for understanding and decrypting timing reports.
###################################################################################
#create_generated_clock -name pll_ncsi_clk_int [get_pins -hierarchical -filter {NAME =~ */ares_pb_i/system_pll/inst/plle2_adv_inst/CLKOUT2}]
#create_generated_clock -name pll_ncsi_clk_io  [get_pins -hierarchical -filter {NAME =~ */ares_pb_i/system_pll/inst/plle2_adv_inst/CLKOUT3}]


###################################################################################
## NCSI output clock : The FPGA generates the NCSI clocks for the i210. This clock
## is generated by a an ODDR buffer. So it is source synchronous with the data and
## inverted by 180 Deg. This will guarantee enough setup and hold on the interface.
###################################################################################
#create_generated_clock -name ncsi_clk_io -source  [get_pins ncsi_clk_oddr/C] -invert -divide_by 1 [get_ports ncsi_clk]


# NCSI internal derived clocks
create_generated_clock -name ncsi_rx_int_clk -source [get_pins -hierarchical -filter {NAME =~ *U0/rmii2mac_rx_clk_bi_reg/C}] -divide_by 2 [get_pins -hierarchical -filter {NAME =~ *U0/rmii2mac_rx_clk_bi_reg/Q}]
create_generated_clock -name ncsi_tx_int_clk -source [get_pins -hierarchical -filter {NAME =~ *U0/rmii2mac_tx_clk_bi_reg/C}] -divide_by 2 -invert [get_pins -hierarchical -filter {NAME =~ *U0/rmii2mac_tx_clk_bi_reg/Q}]

# NCSI I/O timings of the intel I210

# Tco min = 2.5ns
# Tco max = 12.5 ns

# Tsu min = 3ns
# Thold min = -1ns


# ###################################################################################
# ## NCSI
# ###################################################################################

# Port ncsi_crs_dv


## Port profinet1_ncsi_rxd

## Port profinet1_ncsi_tx_en

## Port profinet1_ncsi_txd














