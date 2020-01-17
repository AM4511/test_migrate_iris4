create_clock -period 10.000 -name pcie_refclk -waveform {0.000 5.000} [get_ports ref_clk_100MHz]
create_clock -period 10.000 -name pcie_refclk -waveform {0.000 5.000} [get_ports pcie_sys_clk_p]


create_generated_clock -name rmii2mac_rx_clk -source [get_pins ares_pb_i/ares_pb_i/clk_wiz_0/inst/plle2_adv_inst/CLKOUT2] -divide_by 2 [get_pins ares_pb_i/ares_pb_i/mii_to_rmii_0/U0/rmii2mac_rx_clk_bi_reg/Q]
create_generated_clock -name rmii2mac_tx_clk -source [get_pins ares_pb_i/ares_pb_i/clk_wiz_0/inst/plle2_adv_inst/CLKOUT2] -divide_by 2 [get_pins ares_pb_i/ares_pb_i/mii_to_rmii_0/U0/rmii2mac_tx_clk_bi_reg/Q]
create_generated_clock -name hb_ck -source [get_pins ares_pb_i/ares_pb_i/rpc2_ctrl_controller_0/inst/rpc2_ctrl_io/io_oddr_ck/ODDR_inst/C] -divide_by 1 [get_ports hb_ck]
create_generated_clock -name hb_ck_n -source [get_pins ares_pb_i/ares_pb_i/rpc2_ctrl_controller_0/inst/rpc2_ctrl_io/io_oddr_ckn/ODDR_inst/C] -divide_by 1 -invert [get_ports hb_ck_n]


#l'horloge MCLK de la configuration est a 65MHz +/- 50%
#create_clock -name config_mclk -period 10.25 [get_nets cfgmclk]

# enlever tous les false path de resynchronisation de domaine (signaux finissant en _meta
#set_false_path -to [get_cells -hierarchical  -filter {NAME =~ *Lpc_to_AXI_prodcons*/*/*_meta_reg}]
#set_false_path -to [get_cells -hier -filter {NAME =~ *Lpc_to_AXI_prodcons*/*/dst_data_reg*}]

#le signal qui sort du Microblaze et va trigger le grab sur la clock pci ne doit pas etre clocke.
#contrainte endpoint a endpoint
#set_false_path -from [get_pins {pbgen.ares_pb_i/axi_gpio_0/U0/gpio_core_1/Dual.gpio2_Data_Out_reg[0]/C}] -to [get_pins pbgen.profinet_internal_output_meta_reg/D]
#contrainte de clock a clock
#set_false_path -from [get_clocks clk_pll_i] -to [get_clocks userclk1]
#faisons quelque chose d'hybride, au cas ou la source change de nom
#set_false_path -from [get_clocks clk_pll_i] -to [get_pins pbgen.profinet_internal_output_meta_reg/D]

