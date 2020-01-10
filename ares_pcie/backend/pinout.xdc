#set_property IOSTANDARD LVCMOS33 [get_ports dummy_connected_io]
set_property IOSTANDARD LVCMOS33 [get_ports {ncsi_rxd[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ncsi_rxd[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ncsi_txd[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ncsi_txd[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports ncsi_rx_crs_dv]
set_property IOSTANDARD LVCMOS33 [get_ports ncsi_txen]

set_property IOSTANDARD LVCMOS33 [get_ports {user_data_in[0] user_data_in[1] user_data_in[2] user_data_in[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {acq_exposure acq_strobe acq_trigger_ready}]

set_property IOSTANDARD LVCMOS33 [get_ports {user_data_out[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pwm_out}]
set_property IOSTANDARD LVCMOS33 [get_ports ncsi_clk]
set_property IOSTANDARD LVCMOS33 [get_ports pcie_sys_rst_n]
set_property IOSTANDARD LVCMOS18 [get_ports spi_csN]
set_property IOSTANDARD LVCMOS18 [get_ports spi_sdin]
set_property IOSTANDARD LVCMOS18 [get_ports spi_sdout]

set_property IOSTANDARD LVCMOS18 [get_ports acq_led]
set_property IOSTANDARD LVCMOS18 [get_ports user_rled_soc]
set_property IOSTANDARD LVCMOS18 [get_ports user_gled_soc]
set_property IOSTANDARD LVCMOS18 [get_ports acq_trigger]

set_property IOSTANDARD LVCMOS33 [get_ports user_rled]
set_property IOSTANDARD LVCMOS33 [get_ports user_gled]
set_property IOSTANDARD LVCMOS33 [get_ports status_rled]
set_property IOSTANDARD LVCMOS33 [get_ports status_gled]

set_property PACKAGE_PIN A14 [get_ports user_rled_soc]
set_property PACKAGE_PIN A15 [get_ports user_gled_soc]
set_property PACKAGE_PIN A16 [get_ports acq_trigger]

set_property PACKAGE_PIN U4 [get_ports user_rled]
set_property PACKAGE_PIN U2 [get_ports user_gled]
set_property PACKAGE_PIN U1 [get_ports status_rled]
set_property PACKAGE_PIN U5 [get_ports status_gled]

set_property IOSTANDARD LVCMOS18 [get_ports uart_txd]
set_property PACKAGE_PIN N17 [get_ports uart_txd]

#set_property IOSTANDARD LVCMOS18 [get_ports debug_out]
#set_property PACKAGE_PIN B17 [get_ports debug_out]

set_property PACKAGE_PIN A17 [get_ports {acq_trigger_ready}]
set_property PACKAGE_PIN B15 [get_ports {acq_strobe}]
set_property PACKAGE_PIN C15 [get_ports {acq_exposure}]
set_property PACKAGE_PIN R3 [get_ports {user_data_in[3]}]
set_property PACKAGE_PIN T1 [get_ports {user_data_in[2]}]
set_property PACKAGE_PIN T2 [get_ports {user_data_in[1]}]
set_property PACKAGE_PIN R2 [get_ports {user_data_in[0]}]
#set_property PACKAGE_PIN M2 [get_ports dummy_connected_io]
set_property PACKAGE_PIN P3 [get_ports {ncsi_rxd[1]}]
set_property PACKAGE_PIN N1 [get_ports {ncsi_rxd[0]}]
set_property PACKAGE_PIN L3 [get_ports {ncsi_txd[1]}]
set_property PACKAGE_PIN M3 [get_ports {ncsi_txd[0]}]
set_property PACKAGE_PIN M1 [get_ports ncsi_rx_crs_dv]
set_property PACKAGE_PIN N2 [get_ports ncsi_txen]
set_property PACKAGE_PIN N3 [get_ports ncsi_clk]
set_property PACKAGE_PIN G3 [get_ports pcie_sys_rst_n]
set_property PACKAGE_PIN K19 [get_ports spi_csN]
set_property PACKAGE_PIN D19 [get_ports spi_sdin]
set_property PACKAGE_PIN D18 [get_ports spi_sdout]
set_property PACKAGE_PIN D2 [get_ports {pcie_tx_p[0]}]


#set_property PACKAGE_PIN V8 [get_ports {user_data_out[3]}]
set_property PACKAGE_PIN V2 [get_ports {pwm_out}]
set_property PACKAGE_PIN U7 [get_ports {user_data_out[2]}]
set_property PACKAGE_PIN U8 [get_ports {user_data_out[1]}]
set_property PACKAGE_PIN T3 [get_ports {user_data_out[0]}]

#--------------------------------
#
# PCIe - BANK 216, MGT 1.8V
#
#--------------------------------
set_property PACKAGE_PIN B8 [get_ports pcie_sys_clk_p]
set_property PACKAGE_PIN A8 [get_ports pcie_sys_clk_n]

set_property PACKAGE_PIN A18 [get_ports {acq_led[1]}]
set_property PACKAGE_PIN B18 [get_ports {acq_led[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports pwrrst]
set_property PACKAGE_PIN L17 [get_ports pwrrst]