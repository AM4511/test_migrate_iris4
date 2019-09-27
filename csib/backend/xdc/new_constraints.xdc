#set_switching_activity -toggle_rate 0.000 -static_probability 0.000 [get_nets xsystem_pb_wrapper/system_pb_i/axiMaio_0/U0/xaxiMaio/xmaio_registerfile/p_0_in]
#set_switching_activity -toggle_rate 0.000 -static_probability 0.000 [get_nets xsystem_pb_wrapper/system_pb_i/xdma_0/inst/system_pb_xdma_0_0_pcie2_to_pcie3_wrapper_i/pcie2_ip_i/U0/inst/user_reset_out]
#set_switching_activity -toggle_rate 0.000 -static_probability 1.000 [get_nets {xsystem_pb_wrapper/system_pb_i/clk_reset_mngr/axi_reset_mngr/U0/peripheral_aresetn[0]}]
#set_operating_conditions -grade extended
