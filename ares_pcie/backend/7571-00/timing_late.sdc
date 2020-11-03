# ####################################################################
# Rename clock of the main PLL
# ####################################################################
create_generated_clock -name axi_clk100MHz [get_pins ares_pb_i/ares_pb_i/system_pll/inst/mmcm_adv_inst/CLKOUT0]
create_generated_clock -name eth_clk125MHz [get_pins ares_pb_i/ares_pb_i/system_pll/inst/mmcm_adv_inst/CLKOUT4]
create_generated_clock -name ncsi_clk50MHz [get_pins ares_pb_i/ares_pb_i/system_pll/inst/mmcm_adv_inst/CLKOUT2]

create_generated_clock -name rpc_clk_0 [get_pins ares_pb_i/ares_pb_i/system_pll/inst/mmcm_adv_inst/CLKOUT3]
create_generated_clock -name rpc_clk_90 [get_pins ares_pb_i/ares_pb_i/system_pll/inst/mmcm_adv_inst/CLKOUT1]
create_generated_clock -name rpc_clk_200MHz [get_pins ares_pb_i/ares_pb_i/system_pll/inst/mmcm_adv_inst/CLKOUT5]

#version second MMCM a 150 MHz
#create_generated_clock -name rpc_clk_0      [get_pins ares_pb_i/ares_pb_i/hbclockwiz/inst/mmcm_adv_inst/CLKOUT0]
#create_generated_clock -name rpc_clk_90     [get_pins ares_pb_i/ares_pb_i/hbclockwiz/inst/mmcm_adv_inst/CLKOUT1]
#create_generated_clock -name rpc_clk_200MHz [get_pins ares_pb_i/ares_pb_i/hbclockwiz/inst/mmcm_adv_inst/CLKOUT2]


# ####################################################################
# Rename user interface PCIe clock
# ####################################################################
create_generated_clock -name sysclk [get_pins xpcie_top/xxil_pcie/U0/inst/gt_top_i/pipe_wrapper_i/pipe_clock_int.pipe_clock_i/mmcm_i/CLKOUT2]


# ####################################################################
# Asynchronous clock domains
# ####################################################################
set_clock_groups -asynchronous -group [get_clocks axi_clk100MHz] -group [get_clocks sysclk]
set_clock_groups -asynchronous -group [get_clocks axi_clk100MHz] -group [get_clocks rpc_clk_0]
set_clock_groups -asynchronous -group [get_clocks axi_clk100MHz] -group [get_clocks rpc_clk_200MHz]
set_clock_groups -asynchronous -group [get_clocks rpc_clk_0] -group [get_clocks rpc_clk_200MHz]
set_clock_groups -asynchronous -group [get_clocks RDS_CLK] -group [get_clocks rpc_clk_0]
set_clock_groups -asynchronous -group [get_clocks RPC_CK] -group [get_clocks rpc_clk_0]

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


set_false_path -from [get_ports {user_data_in[*]}]
set_false_path -to [get_ports {user_data_out[*]}]
set_false_path -to [get_ports pwm_out]

set_false_path -to [get_ports debug_uart_txd]
set_false_path -from [get_ports debug_uart_rxd]

###################################################################################
## Because of the PLL phase advance, we need to specify on which edge we want the
## setup analyse to occur
###################################################################################







