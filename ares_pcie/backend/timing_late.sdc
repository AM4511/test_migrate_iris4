
# ####################################################################
# Rename clock of the main PLL
# ####################################################################
set MAIN_PLL_INST [get_cells ares_pb_i/ares_pb_i/system_pll/inst/plle2_adv_inst]
create_generated_clock -name axi_clk100MHz     [get_pins $MAIN_PLL_INST/CLKOUT0]
create_generated_clock -name eth_clk125MHz     [get_pins $MAIN_PLL_INST/CLKOUT1]
create_generated_clock -name ncsi_clk50MHz     [get_pins $MAIN_PLL_INST/CLKOUT2]
create_generated_clock -name axiRpc100MHz      [get_pins $MAIN_PLL_INST/CLKOUT3]



# ####################################################################
# Rename user interface PCIe clock
# ####################################################################
create_generated_clock -name pcie_clk62_5MHz [get_pins xpcie_top/xxil_pcie/U0/inst/gt_top_i/pipe_wrapper_i/pipe_clock_int.pipe_clock_i/mmcm_i/CLKOUT2]


# ####################################################################
# Rename clock of the Hyperbus PLL
# ####################################################################
set HB_PLL_INST [get_cells ares_pb_i/ares_pb_i/rpc2_ctrl_controller_0/inst/rpc2_clk_ctrl_inst/inst_hram_clk_pll_1/inst/plle2_adv_inst]
create_generated_clock -name hb_clk166MHz_0   [get_pins $HB_PLL_INST/CLKOUT0]
create_generated_clock -name hb_clk166MHz_90  [get_pins $HB_PLL_INST/CLKOUT1]
create_generated_clock -name hb_clk166MHz_180 [get_pins $HB_PLL_INST/CLKOUT2]
create_generated_clock -name hb_clk166MHz_270 [get_pins $HB_PLL_INST/CLKOUT3]


# ####################################################################
# Asynchronous clock domains
# ####################################################################
set_clock_groups -asynchronous -group [get_clocks axiRpc100MHz]    -group [get_clocks axi_clk100MHz]
set_clock_groups -asynchronous -group [get_clocks axiRpc100MHz]    -group [get_clocks hb_clk166MHz_0]
set_clock_groups -asynchronous -group [get_clocks hb_clk166MHz_0]  -group [get_clocks axi_clk100MHz]
set_clock_groups -asynchronous -group [get_clocks hb_clk166MHz_0]  -group [get_clocks hb_rwds]
set_clock_groups -asynchronous -group [get_clocks hb_ck]           -group [get_clocks hb_rwds]
set_clock_groups -asynchronous -group [get_clocks pcie_clk62_5MHz] -group [get_clocks axi_clk100MHz]

#System resets
set_false_path -from [get_ports sys_rst_in_n]
set_false_path -from [get_ports espi_reset_n]

# From Athena FPGA
set_false_path -from [get_ports acq_led]
set_false_path -from [get_ports acq_exposure]
set_false_path -from [get_ports acq_strobe]
set_false_path -from [get_ports acq_trigger_ready]

set_false_path -from [get_ports user_rled_soc]
set_false_path -from [get_ports user_gled_soc]


set_false_path -to [get_ports acq_trigger] 
set_false_path -to [get_ports user_gled]
set_false_path -to [get_ports user_rled]


set_false_path -from [get_ports user_data_in[*]]
set_false_path -to [get_ports user_data_out[*]] 
set_false_path -to [get_ports pwm_out] 

set_false_path -to [get_ports debug_uart_txd] 
set_false_path -from [get_ports debug_uart_rxd]

set_false_path -to [get_cells -hierarchical -filter {NAME =~ *rpc2_ctrl_ip/rpc2_ctrl_sync_to_memclk/reg_*}]
set_false_path -from [get_cells -hierarchical -filter {NAME =~ *rpc2_ctrl_ip/rpc2_ctrl_sync_to_memclk/reg_*}]



	
	
	