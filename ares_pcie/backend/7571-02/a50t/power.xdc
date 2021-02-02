# ##################################################################################
# File         : power.xdc
# Description  : XDC script used for the power analysis. 
#
# Example      : source $env(IRIS4)/ares_pcie/backend/7571-00/power.xdc
# 
# ##################################################################################

# All output loads set to 10pF
set_load 10.000 [all_outputs]
set_property LOAD 10 [get_ports acq_trigger]
set_property LOAD 10 [get_ports debug_uart_txd]
set_property LOAD 10 [get_ports espi_alert_n]
set_property LOAD 10 [get_ports {espi_io[0]}]
set_property LOAD 10 [get_ports {espi_io[1]}]
set_property LOAD 10 [get_ports {espi_io[2]}]
set_property LOAD 10 [get_ports {espi_io[3]}]
set_property LOAD 10 [get_ports hb_ck]
set_property LOAD 10 [get_ports hb_ck_n]
set_property LOAD 10 [get_ports hb_cs_n]
set_property LOAD 10 [get_ports {hb_dq[0]}]
set_property LOAD 10 [get_ports {hb_dq[1]}]
set_property LOAD 10 [get_ports {hb_dq[2]}]
set_property LOAD 10 [get_ports {hb_dq[3]}]
set_property LOAD 10 [get_ports {hb_dq[4]}]
set_property LOAD 10 [get_ports {hb_dq[5]}]
set_property LOAD 10 [get_ports {hb_dq[6]}]
set_property LOAD 10 [get_ports {hb_dq[7]}]
set_property LOAD 10 [get_ports hb_rst_n]
set_property LOAD 10 [get_ports hb_rwds]
set_property LOAD 10 [get_ports ncsi_clk]
set_property LOAD 10 [get_ports ncsi_tx_en]
set_property LOAD 10 [get_ports {ncsi_txd[0]}]
set_property LOAD 10 [get_ports {ncsi_txd[1]}]
set_property LOAD 10 [get_ports {pcie_txn[0]}]
set_property LOAD 10 [get_ports {pcie_txp[0]}]
set_property LOAD 10 [get_ports pwm_out]
set_property LOAD 10 [get_ports spi_cs_n]
set_property LOAD 10 [get_ports {spi_sd[0]}]
set_property LOAD 10 [get_ports {spi_sd[1]}]
set_property LOAD 10 [get_ports {spi_sd[2]}]
set_property LOAD 10 [get_ports {spi_sd[3]}]
set_property LOAD 10 [get_ports status_gled]
set_property LOAD 10 [get_ports status_rled]
set_property LOAD 10 [get_ports sys_rst_out_n]
set_property LOAD 10 [get_ports {user_data_out[0]}]
set_property LOAD 10 [get_ports {user_data_out[1]}]
set_property LOAD 10 [get_ports {user_data_out[2]}]
set_property LOAD 10 [get_ports user_gled]
set_property LOAD 10 [get_ports user_rled]

# Operating conditions
set_operating_conditions -ambient_temp 85.0
set_operating_conditions -board_layers 8to11
set_operating_conditions -board small
set_operating_conditions -heatsink high


