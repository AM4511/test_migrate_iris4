#######################################################################################
## FPGA I/O clocks
#######################################################################################
create_clock -period 10.000 -name pcie_refClk -waveform {0.000 5.000} [get_ports pcie_sys_clk_p]
#create_clock -period 41.667 -name lpc_clk -waveform {0.000 20.833} [get_ports lpc_clk_24MHz]

set_false_path -from [get_ports sys_rst_n]
set_false_path -from [get_ports {user_data_in[*]}]
set_false_path -to [get_ports {user_data_out[*]}]


###################################################################################
## PoE NCSI clocks : The FPGA generates the 4 PoE NCSI clocks
###################################################################################
# create_generated_clock -name lan1_ncsi_clk -source  [get_pins oddrbuff_lan1_ncsi_clk/C] -divide_by 1 [get_ports lan1_ncsi_clk]
# create_generated_clock -name lan2_ncsi_clk -source  [get_pins oddrbuff_lan2_ncsi_clk/C] -divide_by 1 [get_ports lan2_ncsi_clk]
# create_generated_clock -name lan3_ncsi_clk -source  [get_pins oddrbuff_lan3_ncsi_clk/C] -divide_by 1 [get_ports lan3_ncsi_clk]
# create_generated_clock -name lan4_ncsi_clk -source  [get_pins oddrbuff_lan4_ncsi_clk/C] -divide_by 1 [get_ports lan4_ncsi_clk]


###################################################################################
## Rename NCSI internal clock generated by the phase alignment PLL ncsi_pll_50MHz.
## These are more convenient names for understanding and decrypting timing reports.
###################################################################################
# create_generated_clock -name ncsi_clk_int      [get_pins -hierarchical -filter {NAME =~ */eth_pll/inst/plle2_adv_inst/CLKOUT0}]
# create_generated_clock -name profinet1_clk_int [get_pins -hierarchical -filter {NAME =~ */eth_pll/inst/plle2_adv_inst/CLKOUT1}]
# create_generated_clock -name ncsi_clk_out      [get_pins -hierarchical -filter {NAME =~ */eth_pll/inst/plle2_adv_inst/CLKOUT2}]
# create_generated_clock -name eth_refclk_125MHz [get_pins -hierarchical -filter {NAME =~ */eth_pll/inst/plle2_adv_inst/CLKOUT3}]


###################################################################################
## Profinet Lan2 NCSI clock : The FPGA generates the Profinet Lan2 NCSI clock
##
## Profinet Lan1 NCSI clocks : The PCB clock buffer generates the Profinet Lan1
##
## Note : The clock profinet1_ncsi_clk is created "virtually". We know from measurment 
## on the bench that the phase difference between profinet1_ncsi_clk and profinet2_ncsi_clk
## is 2.4 ns (profinet1_ncsi_clk arrives 2,4 ns after profinet2_ncsi_clk at the i210
## on the pcb). This is what we try ro emulate below with the 
## create_generated_clock -name profinet1_ncsi_clk... command. This is a tricky 
## way of creating a delayed clock for setiing decent set_input_delay and  
## delay on the profinet 1 interface later below in this constraint file
##
###################################################################################
#create_generated_clock -name profinetclk      -source  [get_pins oddrbuff_profinet2_ncsi_clk/C] -divide_by 1 [get_ports profinet_clk]


###################################################################################
## Because of the PLL phase advance, we need to specify on which edge we want the 
## setup analyse to occur 
###################################################################################
# set_multicycle_path -from [get_clocks  "lan1_ncsi_clk"] -to [get_clocks  "ncsi_clk_int"] 2
# set_multicycle_path -from [get_clocks  "lan2_ncsi_clk"] -to [get_clocks  "ncsi_clk_int"] 2
# set_multicycle_path -from [get_clocks  "lan3_ncsi_clk"] -to [get_clocks  "ncsi_clk_int"] 2
# set_multicycle_path -from [get_clocks  "lan4_ncsi_clk"] -to [get_clocks  "ncsi_clk_int"] 2

# set_multicycle_path -from [get_clocks  "profinet1_ncsi_clk"] -to [get_clocks  "profinet1_clk_int"] 2
# set_multicycle_path -from [get_clocks  "profinet2_ncsi_clk"] -to [get_clocks  "ncsi_clk_int"] 2


# TOE NCSI internal derived clocks
# create_generated_clock -name toe_rmii2mac_0_rx_clk -source [get_pins -hierarchical -filter {NAME =~ *ncsi0/mii_to_rmii_0/U0/rmii2mac_rx_clk_bi_reg/C}] -divide_by 2 [get_pins -hierarchical -filter {NAME =~ *ncsi0/mii_to_rmii_0/U0/rmii2mac_rx_clk_bi_reg/Q}]
# create_generated_clock -name toe_rmii2mac_1_rx_clk -source [get_pins -hierarchical -filter {NAME =~ *ncsi1/mii_to_rmii_0/U0/rmii2mac_rx_clk_bi_reg/C}] -divide_by 2 [get_pins -hierarchical -filter {NAME =~ *ncsi1/mii_to_rmii_0/U0/rmii2mac_rx_clk_bi_reg/Q}]
# create_generated_clock -name toe_rmii2mac_2_rx_clk -source [get_pins -hierarchical -filter {NAME =~ *ncsi2/mii_to_rmii_0/U0/rmii2mac_rx_clk_bi_reg/C}] -divide_by 2 [get_pins -hierarchical -filter {NAME =~ *ncsi2/mii_to_rmii_0/U0/rmii2mac_rx_clk_bi_reg/Q}]
# create_generated_clock -name toe_rmii2mac_3_rx_clk -source [get_pins -hierarchical -filter {NAME =~ *ncsi3/mii_to_rmii_0/U0/rmii2mac_rx_clk_bi_reg/C}] -divide_by 2 [get_pins -hierarchical -filter {NAME =~ *ncsi3/mii_to_rmii_0/U0/rmii2mac_rx_clk_bi_reg/Q}]


# create_generated_clock -name toe_rmii2mac_0_tx_clk -source [get_pins -hierarchical -filter {NAME =~ *ncsi0/mii_to_rmii_0/U0/rmii2mac_tx_clk_bi_reg/C}] -divide_by 2 -invert [get_pins -hierarchical -filter {NAME =~ *ncsi0/mii_to_rmii_0/U0/rmii2mac_tx_clk_bi_reg/Q}]
# create_generated_clock -name toe_rmii2mac_1_tx_clk -source [get_pins -hierarchical -filter {NAME =~ *ncsi1/mii_to_rmii_0/U0/rmii2mac_tx_clk_bi_reg/C}] -divide_by 2 -invert [get_pins -hierarchical -filter {NAME =~ *ncsi1/mii_to_rmii_0/U0/rmii2mac_tx_clk_bi_reg/Q}]
# create_generated_clock -name toe_rmii2mac_2_tx_clk -source [get_pins -hierarchical -filter {NAME =~ *ncsi2/mii_to_rmii_0/U0/rmii2mac_tx_clk_bi_reg/C}] -divide_by 2 -invert [get_pins -hierarchical -filter {NAME =~ *ncsi2/mii_to_rmii_0/U0/rmii2mac_tx_clk_bi_reg/Q}]
# create_generated_clock -name toe_rmii2mac_3_tx_clk -source [get_pins -hierarchical -filter {NAME =~ *ncsi3/mii_to_rmii_0/U0/rmii2mac_tx_clk_bi_reg/C}] -divide_by 2 -invert [get_pins -hierarchical -filter {NAME =~ *ncsi3/mii_to_rmii_0/U0/rmii2mac_tx_clk_bi_reg/Q}]



# create_generated_clock -name profinet_1_rx_clk -source [get_pins -hierarchical -filter {NAME =~ *profinet_1/mii_to_rmii_0/U0/rmii2mac_rx_clk_bi_reg/C}] -divide_by 2 [get_pins -hierarchical -filter {NAME =~ *profinet_1/mii_to_rmii_0/U0/rmii2mac_rx_clk_bi_reg/Q}]
# create_generated_clock -name profinet_2_rx_clk -source [get_pins -hierarchical -filter {NAME =~ *profinet_2/mii_to_rmii_0/U0/rmii2mac_rx_clk_bi_reg/C}] -divide_by 2 [get_pins -hierarchical -filter {NAME =~ *profinet_2/mii_to_rmii_0/U0/rmii2mac_rx_clk_bi_reg/Q}]


# create_generated_clock -name profinet_1_tx_clk -source [get_pins -hierarchical -filter {NAME =~ *profinet_1/mii_to_rmii_0/U0/rmii2mac_tx_clk_bi_reg/C}] -divide_by 2 -invert [get_pins -hierarchical -filter {NAME =~ *profinet_1/mii_to_rmii_0/U0/rmii2mac_tx_clk_bi_reg/Q}]
# create_generated_clock -name profinet_2_tx_clk -source [get_pins -hierarchical -filter {NAME =~ *profinet_2/mii_to_rmii_0/U0/rmii2mac_tx_clk_bi_reg/C}] -divide_by 2 -invert [get_pins -hierarchical -filter {NAME =~ *profinet_2/mii_to_rmii_0/U0/rmii2mac_tx_clk_bi_reg/Q}]


# NCSI I/O timings of the intel I210

# Tco min = 2.5ns
# Tco max = 12.5 ns
set NCSI_MAX_INPUT_DELAY 12.500
set NCSI_MIN_INPUT_DELAY 2.500

# Tsu min = 3ns
# Thold min = -1ns
set NCSI_MAX_OUTPUT_DELAY 3.000
set NCSI_MIN_OUTPUT_DELAY -1.000

# ###################################################################################
# ## Profinet[1] NCSI
# ###################################################################################

### Port profinet1_ncsi_crs_dv

#set_input_delay -clock profinet_clk -max $NCSI_MAX_INPUT_DELAY [get_ports profinet1_ncsi_crs_dv]
#set_input_delay -clock profinet_clk -min $NCSI_MIN_INPUT_DELAY [get_ports profinet1_ncsi_crs_dv]


### Port profinet1_ncsi_rxd

#set_input_delay -clock profinet_clk -max $NCSI_MAX_INPUT_DELAY [get_ports profinet_rxd*]
#set_input_delay -clock profinet_clk -min $NCSI_MIN_INPUT_DELAY [get_ports profinet_rxd*]

### Port profinet1_ncsi_tx_en

#set_output_delay -clock profinet_clk -max $NCSI_MAX_OUTPUT_DELAY [get_ports profinet_tx_en]
#set_output_delay -clock profinet_clk -min $NCSI_MIN_OUTPUT_DELAY [get_ports profinet_tx_en]

### Port profinet1_ncsi_txd

#set_output_delay -clock profinet_clk -max $NCSI_MAX_OUTPUT_DELAY [get_ports profinet_txd*]
#set_output_delay -clock profinet_clk -min $NCSI_MIN_OUTPUT_DELAY [get_ports profinet_txd*]


