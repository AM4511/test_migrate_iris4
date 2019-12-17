
## Power analysis
set_load 10.000 [all_outputs]
set_property LOAD 10 [get_ports {GPO_0[0]}]
set_property LOAD 10 [get_ports {GPO_0[1]}]
set_property LOAD 10 [get_ports IENOn_0]
set_property LOAD 10 [get_ports RPC_CK_0]
set_property LOAD 10 [get_ports RPC_CK_N_0]
set_property LOAD 10 [get_ports RPC_CS0_N_0]
set_property LOAD 10 [get_ports RPC_CS1_N_0]
set_property LOAD 10 [get_ports {RPC_DQ_0[0]}]
set_property LOAD 10 [get_ports {RPC_DQ_0[1]}]
set_property LOAD 10 [get_ports {RPC_DQ_0[2]}]
set_property LOAD 10 [get_ports {RPC_DQ_0[3]}]
set_property LOAD 10 [get_ports {RPC_DQ_0[4]}]
set_property LOAD 10 [get_ports {RPC_DQ_0[5]}]
set_property LOAD 10 [get_ports {RPC_DQ_0[6]}]
set_property LOAD 10 [get_ports {RPC_DQ_0[7]}]
set_property LOAD 10 [get_ports RPC_RESET_N_0]
set_property LOAD 10 [get_ports RPC_RWDS_0]
set_property LOAD 10 [get_ports RPC_WP_N_0]
set_property LOAD 10 [get_ports espi_irq]
set_property LOAD 10 [get_ports ext_sync_ext_sync_en]
set_property LOAD 10 [get_ports ext_sync_ext_sync_out]
set_property LOAD 10 [get_ports rmii_tx_en]
set_property LOAD 10 [get_ports {rmii_txd[0]}]
set_property LOAD 10 [get_ports {rmii_txd[1]}]
set_property LOAD 10 [get_ports spi_io0_io]
set_property LOAD 10 [get_ports spi_io1_io]
set_property LOAD 10 [get_ports spi_io2_io]
set_property LOAD 10 [get_ports spi_io3_io]
set_property LOAD 10 [get_ports {spi_ss_io[0]}]
set_property LOAD 10 [get_ports startup_io_cfgclk]
set_property LOAD 10 [get_ports startup_io_cfgmclk]
set_property LOAD 10 [get_ports startup_io_eos]
set_property LOAD 10 [get_ports startup_io_preq]
set_property LOAD 10 [get_ports uart_txd]
set_property LOAD 10 [get_ports {user_data_out[0]}]
set_property LOAD 10 [get_ports {user_data_out[1]}]
set_property LOAD 10 [get_ports {user_data_out[2]}]
set_operating_conditions -ambient_temp 85.0
set_operating_conditions -board_layers 8to11
set_operating_conditions -board small
set_operating_conditions -heatsink high

set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets espi_clk_IBUF_BUFG]
