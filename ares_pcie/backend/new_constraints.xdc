create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list xpcie_top/xxil_pcie/U0/inst/gt_top_i/pipe_wrapper_i/pipe_clock_int.pipe_clock_i/user_clk2]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 4 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {xpcie_top/xtlp_to_axi_master/state[0]} {xpcie_top/xtlp_to_axi_master/state[1]} {xpcie_top/xtlp_to_axi_master/state[2]} {xpcie_top/xtlp_to_axi_master/state[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 7 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {xpcie_top/xtlp_to_axi_master/tlp_in_fmt_type[0]} {xpcie_top/xtlp_to_axi_master/tlp_in_fmt_type[1]} {xpcie_top/xtlp_to_axi_master/tlp_in_fmt_type[2]} {xpcie_top/xtlp_to_axi_master/tlp_in_fmt_type[3]} {xpcie_top/xtlp_to_axi_master/tlp_in_fmt_type[4]} {xpcie_top/xtlp_to_axi_master/tlp_in_fmt_type[5]} {xpcie_top/xtlp_to_axi_master/tlp_in_fmt_type[6]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 8 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {xpcie_top/xtlp_to_axi_master/tlp_out_ldwbe_fdwbe[0]} {xpcie_top/xtlp_to_axi_master/tlp_out_ldwbe_fdwbe[1]} {xpcie_top/xtlp_to_axi_master/tlp_out_ldwbe_fdwbe[2]} {xpcie_top/xtlp_to_axi_master/tlp_out_ldwbe_fdwbe[3]} {xpcie_top/xtlp_to_axi_master/tlp_out_ldwbe_fdwbe[4]} {xpcie_top/xtlp_to_axi_master/tlp_out_ldwbe_fdwbe[5]} {xpcie_top/xtlp_to_axi_master/tlp_out_ldwbe_fdwbe[6]} {xpcie_top/xtlp_to_axi_master/tlp_out_ldwbe_fdwbe[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 2 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {xpcie_top/xtlp_to_axi_master/tlp_in_attr[0]} {xpcie_top/xtlp_to_axi_master/tlp_in_attr[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 32 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {xpcie_top/xtlp_to_axi_master/tlp_in_address[0]} {xpcie_top/xtlp_to_axi_master/tlp_in_address[1]} {xpcie_top/xtlp_to_axi_master/tlp_in_address[2]} {xpcie_top/xtlp_to_axi_master/tlp_in_address[3]} {xpcie_top/xtlp_to_axi_master/tlp_in_address[4]} {xpcie_top/xtlp_to_axi_master/tlp_in_address[5]} {xpcie_top/xtlp_to_axi_master/tlp_in_address[6]} {xpcie_top/xtlp_to_axi_master/tlp_in_address[7]} {xpcie_top/xtlp_to_axi_master/tlp_in_address[8]} {xpcie_top/xtlp_to_axi_master/tlp_in_address[9]} {xpcie_top/xtlp_to_axi_master/tlp_in_address[10]} {xpcie_top/xtlp_to_axi_master/tlp_in_address[11]} {xpcie_top/xtlp_to_axi_master/tlp_in_address[12]} {xpcie_top/xtlp_to_axi_master/tlp_in_address[13]} {xpcie_top/xtlp_to_axi_master/tlp_in_address[14]} {xpcie_top/xtlp_to_axi_master/tlp_in_address[15]} {xpcie_top/xtlp_to_axi_master/tlp_in_address[16]} {xpcie_top/xtlp_to_axi_master/tlp_in_address[17]} {xpcie_top/xtlp_to_axi_master/tlp_in_address[18]} {xpcie_top/xtlp_to_axi_master/tlp_in_address[19]} {xpcie_top/xtlp_to_axi_master/tlp_in_address[20]} {xpcie_top/xtlp_to_axi_master/tlp_in_address[21]} {xpcie_top/xtlp_to_axi_master/tlp_in_address[22]} {xpcie_top/xtlp_to_axi_master/tlp_in_address[23]} {xpcie_top/xtlp_to_axi_master/tlp_in_address[24]} {xpcie_top/xtlp_to_axi_master/tlp_in_address[25]} {xpcie_top/xtlp_to_axi_master/tlp_in_address[26]} {xpcie_top/xtlp_to_axi_master/tlp_in_address[27]} {xpcie_top/xtlp_to_axi_master/tlp_in_address[28]} {xpcie_top/xtlp_to_axi_master/tlp_in_address[29]} {xpcie_top/xtlp_to_axi_master/tlp_in_address[30]} {xpcie_top/xtlp_to_axi_master/tlp_in_address[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 24 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {xpcie_top/xtlp_to_axi_master/tlp_out_transaction_id[0]} {xpcie_top/xtlp_to_axi_master/tlp_out_transaction_id[1]} {xpcie_top/xtlp_to_axi_master/tlp_out_transaction_id[2]} {xpcie_top/xtlp_to_axi_master/tlp_out_transaction_id[3]} {xpcie_top/xtlp_to_axi_master/tlp_out_transaction_id[4]} {xpcie_top/xtlp_to_axi_master/tlp_out_transaction_id[5]} {xpcie_top/xtlp_to_axi_master/tlp_out_transaction_id[6]} {xpcie_top/xtlp_to_axi_master/tlp_out_transaction_id[7]} {xpcie_top/xtlp_to_axi_master/tlp_out_transaction_id[8]} {xpcie_top/xtlp_to_axi_master/tlp_out_transaction_id[9]} {xpcie_top/xtlp_to_axi_master/tlp_out_transaction_id[10]} {xpcie_top/xtlp_to_axi_master/tlp_out_transaction_id[11]} {xpcie_top/xtlp_to_axi_master/tlp_out_transaction_id[12]} {xpcie_top/xtlp_to_axi_master/tlp_out_transaction_id[13]} {xpcie_top/xtlp_to_axi_master/tlp_out_transaction_id[14]} {xpcie_top/xtlp_to_axi_master/tlp_out_transaction_id[15]} {xpcie_top/xtlp_to_axi_master/tlp_out_transaction_id[16]} {xpcie_top/xtlp_to_axi_master/tlp_out_transaction_id[17]} {xpcie_top/xtlp_to_axi_master/tlp_out_transaction_id[18]} {xpcie_top/xtlp_to_axi_master/tlp_out_transaction_id[19]} {xpcie_top/xtlp_to_axi_master/tlp_out_transaction_id[20]} {xpcie_top/xtlp_to_axi_master/tlp_out_transaction_id[21]} {xpcie_top/xtlp_to_axi_master/tlp_out_transaction_id[22]} {xpcie_top/xtlp_to_axi_master/tlp_out_transaction_id[23]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 2 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {xpcie_top/xtlp_to_axi_master/tlp_out_attr[0]} {xpcie_top/xtlp_to_axi_master/tlp_out_attr[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 32 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {xpcie_top/xtlp_to_axi_master/axim_rdata[0]} {xpcie_top/xtlp_to_axi_master/axim_rdata[1]} {xpcie_top/xtlp_to_axi_master/axim_rdata[2]} {xpcie_top/xtlp_to_axi_master/axim_rdata[3]} {xpcie_top/xtlp_to_axi_master/axim_rdata[4]} {xpcie_top/xtlp_to_axi_master/axim_rdata[5]} {xpcie_top/xtlp_to_axi_master/axim_rdata[6]} {xpcie_top/xtlp_to_axi_master/axim_rdata[7]} {xpcie_top/xtlp_to_axi_master/axim_rdata[8]} {xpcie_top/xtlp_to_axi_master/axim_rdata[9]} {xpcie_top/xtlp_to_axi_master/axim_rdata[10]} {xpcie_top/xtlp_to_axi_master/axim_rdata[11]} {xpcie_top/xtlp_to_axi_master/axim_rdata[12]} {xpcie_top/xtlp_to_axi_master/axim_rdata[13]} {xpcie_top/xtlp_to_axi_master/axim_rdata[14]} {xpcie_top/xtlp_to_axi_master/axim_rdata[15]} {xpcie_top/xtlp_to_axi_master/axim_rdata[16]} {xpcie_top/xtlp_to_axi_master/axim_rdata[17]} {xpcie_top/xtlp_to_axi_master/axim_rdata[18]} {xpcie_top/xtlp_to_axi_master/axim_rdata[19]} {xpcie_top/xtlp_to_axi_master/axim_rdata[20]} {xpcie_top/xtlp_to_axi_master/axim_rdata[21]} {xpcie_top/xtlp_to_axi_master/axim_rdata[22]} {xpcie_top/xtlp_to_axi_master/axim_rdata[23]} {xpcie_top/xtlp_to_axi_master/axim_rdata[24]} {xpcie_top/xtlp_to_axi_master/axim_rdata[25]} {xpcie_top/xtlp_to_axi_master/axim_rdata[26]} {xpcie_top/xtlp_to_axi_master/axim_rdata[27]} {xpcie_top/xtlp_to_axi_master/axim_rdata[28]} {xpcie_top/xtlp_to_axi_master/axim_rdata[29]} {xpcie_top/xtlp_to_axi_master/axim_rdata[30]} {xpcie_top/xtlp_to_axi_master/axim_rdata[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 32 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {xpcie_top/xtlp_to_axi_master/axim_araddr[0]} {xpcie_top/xtlp_to_axi_master/axim_araddr[1]} {xpcie_top/xtlp_to_axi_master/axim_araddr[2]} {xpcie_top/xtlp_to_axi_master/axim_araddr[3]} {xpcie_top/xtlp_to_axi_master/axim_araddr[4]} {xpcie_top/xtlp_to_axi_master/axim_araddr[5]} {xpcie_top/xtlp_to_axi_master/axim_araddr[6]} {xpcie_top/xtlp_to_axi_master/axim_araddr[7]} {xpcie_top/xtlp_to_axi_master/axim_araddr[8]} {xpcie_top/xtlp_to_axi_master/axim_araddr[9]} {xpcie_top/xtlp_to_axi_master/axim_araddr[10]} {xpcie_top/xtlp_to_axi_master/axim_araddr[11]} {xpcie_top/xtlp_to_axi_master/axim_araddr[12]} {xpcie_top/xtlp_to_axi_master/axim_araddr[13]} {xpcie_top/xtlp_to_axi_master/axim_araddr[14]} {xpcie_top/xtlp_to_axi_master/axim_araddr[15]} {xpcie_top/xtlp_to_axi_master/axim_araddr[16]} {xpcie_top/xtlp_to_axi_master/axim_araddr[17]} {xpcie_top/xtlp_to_axi_master/axim_araddr[18]} {xpcie_top/xtlp_to_axi_master/axim_araddr[19]} {xpcie_top/xtlp_to_axi_master/axim_araddr[20]} {xpcie_top/xtlp_to_axi_master/axim_araddr[21]} {xpcie_top/xtlp_to_axi_master/axim_araddr[22]} {xpcie_top/xtlp_to_axi_master/axim_araddr[23]} {xpcie_top/xtlp_to_axi_master/axim_araddr[24]} {xpcie_top/xtlp_to_axi_master/axim_araddr[25]} {xpcie_top/xtlp_to_axi_master/axim_araddr[26]} {xpcie_top/xtlp_to_axi_master/axim_araddr[27]} {xpcie_top/xtlp_to_axi_master/axim_araddr[28]} {xpcie_top/xtlp_to_axi_master/axim_araddr[29]} {xpcie_top/xtlp_to_axi_master/axim_araddr[30]} {xpcie_top/xtlp_to_axi_master/axim_araddr[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 32 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {xpcie_top/xtlp_to_axi_master/axim_wdata[0]} {xpcie_top/xtlp_to_axi_master/axim_wdata[1]} {xpcie_top/xtlp_to_axi_master/axim_wdata[2]} {xpcie_top/xtlp_to_axi_master/axim_wdata[3]} {xpcie_top/xtlp_to_axi_master/axim_wdata[4]} {xpcie_top/xtlp_to_axi_master/axim_wdata[5]} {xpcie_top/xtlp_to_axi_master/axim_wdata[6]} {xpcie_top/xtlp_to_axi_master/axim_wdata[7]} {xpcie_top/xtlp_to_axi_master/axim_wdata[8]} {xpcie_top/xtlp_to_axi_master/axim_wdata[9]} {xpcie_top/xtlp_to_axi_master/axim_wdata[10]} {xpcie_top/xtlp_to_axi_master/axim_wdata[11]} {xpcie_top/xtlp_to_axi_master/axim_wdata[12]} {xpcie_top/xtlp_to_axi_master/axim_wdata[13]} {xpcie_top/xtlp_to_axi_master/axim_wdata[14]} {xpcie_top/xtlp_to_axi_master/axim_wdata[15]} {xpcie_top/xtlp_to_axi_master/axim_wdata[16]} {xpcie_top/xtlp_to_axi_master/axim_wdata[17]} {xpcie_top/xtlp_to_axi_master/axim_wdata[18]} {xpcie_top/xtlp_to_axi_master/axim_wdata[19]} {xpcie_top/xtlp_to_axi_master/axim_wdata[20]} {xpcie_top/xtlp_to_axi_master/axim_wdata[21]} {xpcie_top/xtlp_to_axi_master/axim_wdata[22]} {xpcie_top/xtlp_to_axi_master/axim_wdata[23]} {xpcie_top/xtlp_to_axi_master/axim_wdata[24]} {xpcie_top/xtlp_to_axi_master/axim_wdata[25]} {xpcie_top/xtlp_to_axi_master/axim_wdata[26]} {xpcie_top/xtlp_to_axi_master/axim_wdata[27]} {xpcie_top/xtlp_to_axi_master/axim_wdata[28]} {xpcie_top/xtlp_to_axi_master/axim_wdata[29]} {xpcie_top/xtlp_to_axi_master/axim_wdata[30]} {xpcie_top/xtlp_to_axi_master/axim_wdata[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 31 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {xpcie_top/xtlp_to_axi_master/tlp_abort_cntr_value[0]} {xpcie_top/xtlp_to_axi_master/tlp_abort_cntr_value[1]} {xpcie_top/xtlp_to_axi_master/tlp_abort_cntr_value[2]} {xpcie_top/xtlp_to_axi_master/tlp_abort_cntr_value[3]} {xpcie_top/xtlp_to_axi_master/tlp_abort_cntr_value[4]} {xpcie_top/xtlp_to_axi_master/tlp_abort_cntr_value[5]} {xpcie_top/xtlp_to_axi_master/tlp_abort_cntr_value[6]} {xpcie_top/xtlp_to_axi_master/tlp_abort_cntr_value[7]} {xpcie_top/xtlp_to_axi_master/tlp_abort_cntr_value[8]} {xpcie_top/xtlp_to_axi_master/tlp_abort_cntr_value[9]} {xpcie_top/xtlp_to_axi_master/tlp_abort_cntr_value[10]} {xpcie_top/xtlp_to_axi_master/tlp_abort_cntr_value[11]} {xpcie_top/xtlp_to_axi_master/tlp_abort_cntr_value[12]} {xpcie_top/xtlp_to_axi_master/tlp_abort_cntr_value[13]} {xpcie_top/xtlp_to_axi_master/tlp_abort_cntr_value[14]} {xpcie_top/xtlp_to_axi_master/tlp_abort_cntr_value[15]} {xpcie_top/xtlp_to_axi_master/tlp_abort_cntr_value[16]} {xpcie_top/xtlp_to_axi_master/tlp_abort_cntr_value[17]} {xpcie_top/xtlp_to_axi_master/tlp_abort_cntr_value[18]} {xpcie_top/xtlp_to_axi_master/tlp_abort_cntr_value[19]} {xpcie_top/xtlp_to_axi_master/tlp_abort_cntr_value[20]} {xpcie_top/xtlp_to_axi_master/tlp_abort_cntr_value[21]} {xpcie_top/xtlp_to_axi_master/tlp_abort_cntr_value[22]} {xpcie_top/xtlp_to_axi_master/tlp_abort_cntr_value[23]} {xpcie_top/xtlp_to_axi_master/tlp_abort_cntr_value[24]} {xpcie_top/xtlp_to_axi_master/tlp_abort_cntr_value[25]} {xpcie_top/xtlp_to_axi_master/tlp_abort_cntr_value[26]} {xpcie_top/xtlp_to_axi_master/tlp_abort_cntr_value[27]} {xpcie_top/xtlp_to_axi_master/tlp_abort_cntr_value[28]} {xpcie_top/xtlp_to_axi_master/tlp_abort_cntr_value[29]} {xpcie_top/xtlp_to_axi_master/tlp_abort_cntr_value[30]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 11 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {xpcie_top/xtlp_to_axi_master/tlp_in_length_in_dw[0]} {xpcie_top/xtlp_to_axi_master/tlp_in_length_in_dw[1]} {xpcie_top/xtlp_to_axi_master/tlp_in_length_in_dw[2]} {xpcie_top/xtlp_to_axi_master/tlp_in_length_in_dw[3]} {xpcie_top/xtlp_to_axi_master/tlp_in_length_in_dw[4]} {xpcie_top/xtlp_to_axi_master/tlp_in_length_in_dw[5]} {xpcie_top/xtlp_to_axi_master/tlp_in_length_in_dw[6]} {xpcie_top/xtlp_to_axi_master/tlp_in_length_in_dw[7]} {xpcie_top/xtlp_to_axi_master/tlp_in_length_in_dw[8]} {xpcie_top/xtlp_to_axi_master/tlp_in_length_in_dw[9]} {xpcie_top/xtlp_to_axi_master/tlp_in_length_in_dw[10]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 4 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {xpcie_top/xtlp_to_axi_master/hit_window[0]} {xpcie_top/xtlp_to_axi_master/hit_window[1]} {xpcie_top/xtlp_to_axi_master/hit_window[2]} {xpcie_top/xtlp_to_axi_master/hit_window[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 8 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {xpcie_top/xtlp_to_axi_master/axim_awlen[0]} {xpcie_top/xtlp_to_axi_master/axim_awlen[1]} {xpcie_top/xtlp_to_axi_master/axim_awlen[2]} {xpcie_top/xtlp_to_axi_master/axim_awlen[3]} {xpcie_top/xtlp_to_axi_master/axim_awlen[4]} {xpcie_top/xtlp_to_axi_master/axim_awlen[5]} {xpcie_top/xtlp_to_axi_master/axim_awlen[6]} {xpcie_top/xtlp_to_axi_master/axim_awlen[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 24 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {xpcie_top/xtlp_to_axi_master/tlp_in_transaction_id[0]} {xpcie_top/xtlp_to_axi_master/tlp_in_transaction_id[1]} {xpcie_top/xtlp_to_axi_master/tlp_in_transaction_id[2]} {xpcie_top/xtlp_to_axi_master/tlp_in_transaction_id[3]} {xpcie_top/xtlp_to_axi_master/tlp_in_transaction_id[4]} {xpcie_top/xtlp_to_axi_master/tlp_in_transaction_id[5]} {xpcie_top/xtlp_to_axi_master/tlp_in_transaction_id[6]} {xpcie_top/xtlp_to_axi_master/tlp_in_transaction_id[7]} {xpcie_top/xtlp_to_axi_master/tlp_in_transaction_id[8]} {xpcie_top/xtlp_to_axi_master/tlp_in_transaction_id[9]} {xpcie_top/xtlp_to_axi_master/tlp_in_transaction_id[10]} {xpcie_top/xtlp_to_axi_master/tlp_in_transaction_id[11]} {xpcie_top/xtlp_to_axi_master/tlp_in_transaction_id[12]} {xpcie_top/xtlp_to_axi_master/tlp_in_transaction_id[13]} {xpcie_top/xtlp_to_axi_master/tlp_in_transaction_id[14]} {xpcie_top/xtlp_to_axi_master/tlp_in_transaction_id[15]} {xpcie_top/xtlp_to_axi_master/tlp_in_transaction_id[16]} {xpcie_top/xtlp_to_axi_master/tlp_in_transaction_id[17]} {xpcie_top/xtlp_to_axi_master/tlp_in_transaction_id[18]} {xpcie_top/xtlp_to_axi_master/tlp_in_transaction_id[19]} {xpcie_top/xtlp_to_axi_master/tlp_in_transaction_id[20]} {xpcie_top/xtlp_to_axi_master/tlp_in_transaction_id[21]} {xpcie_top/xtlp_to_axi_master/tlp_in_transaction_id[22]} {xpcie_top/xtlp_to_axi_master/tlp_in_transaction_id[23]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 32 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {xpcie_top/xtlp_to_axi_master/tlp_out_data[0]} {xpcie_top/xtlp_to_axi_master/tlp_out_data[1]} {xpcie_top/xtlp_to_axi_master/tlp_out_data[2]} {xpcie_top/xtlp_to_axi_master/tlp_out_data[3]} {xpcie_top/xtlp_to_axi_master/tlp_out_data[4]} {xpcie_top/xtlp_to_axi_master/tlp_out_data[5]} {xpcie_top/xtlp_to_axi_master/tlp_out_data[6]} {xpcie_top/xtlp_to_axi_master/tlp_out_data[7]} {xpcie_top/xtlp_to_axi_master/tlp_out_data[8]} {xpcie_top/xtlp_to_axi_master/tlp_out_data[9]} {xpcie_top/xtlp_to_axi_master/tlp_out_data[10]} {xpcie_top/xtlp_to_axi_master/tlp_out_data[11]} {xpcie_top/xtlp_to_axi_master/tlp_out_data[12]} {xpcie_top/xtlp_to_axi_master/tlp_out_data[13]} {xpcie_top/xtlp_to_axi_master/tlp_out_data[14]} {xpcie_top/xtlp_to_axi_master/tlp_out_data[15]} {xpcie_top/xtlp_to_axi_master/tlp_out_data[16]} {xpcie_top/xtlp_to_axi_master/tlp_out_data[17]} {xpcie_top/xtlp_to_axi_master/tlp_out_data[18]} {xpcie_top/xtlp_to_axi_master/tlp_out_data[19]} {xpcie_top/xtlp_to_axi_master/tlp_out_data[20]} {xpcie_top/xtlp_to_axi_master/tlp_out_data[21]} {xpcie_top/xtlp_to_axi_master/tlp_out_data[22]} {xpcie_top/xtlp_to_axi_master/tlp_out_data[23]} {xpcie_top/xtlp_to_axi_master/tlp_out_data[24]} {xpcie_top/xtlp_to_axi_master/tlp_out_data[25]} {xpcie_top/xtlp_to_axi_master/tlp_out_data[26]} {xpcie_top/xtlp_to_axi_master/tlp_out_data[27]} {xpcie_top/xtlp_to_axi_master/tlp_out_data[28]} {xpcie_top/xtlp_to_axi_master/tlp_out_data[29]} {xpcie_top/xtlp_to_axi_master/tlp_out_data[30]} {xpcie_top/xtlp_to_axi_master/tlp_out_data[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 10 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {xpcie_top/xtlp_to_axi_master/tlp_out_length_in_dw[0]} {xpcie_top/xtlp_to_axi_master/tlp_out_length_in_dw[1]} {xpcie_top/xtlp_to_axi_master/tlp_out_length_in_dw[2]} {xpcie_top/xtlp_to_axi_master/tlp_out_length_in_dw[3]} {xpcie_top/xtlp_to_axi_master/tlp_out_length_in_dw[4]} {xpcie_top/xtlp_to_axi_master/tlp_out_length_in_dw[5]} {xpcie_top/xtlp_to_axi_master/tlp_out_length_in_dw[6]} {xpcie_top/xtlp_to_axi_master/tlp_out_length_in_dw[7]} {xpcie_top/xtlp_to_axi_master/tlp_out_length_in_dw[8]} {xpcie_top/xtlp_to_axi_master/tlp_out_length_in_dw[9]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 4 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {xpcie_top/xtlp_to_axi_master/window_en[0]} {xpcie_top/xtlp_to_axi_master/window_en[1]} {xpcie_top/xtlp_to_axi_master/window_en[2]} {xpcie_top/xtlp_to_axi_master/window_en[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 32 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list {xpcie_top/xtlp_to_axi_master/tlp_in_data[0]} {xpcie_top/xtlp_to_axi_master/tlp_in_data[1]} {xpcie_top/xtlp_to_axi_master/tlp_in_data[2]} {xpcie_top/xtlp_to_axi_master/tlp_in_data[3]} {xpcie_top/xtlp_to_axi_master/tlp_in_data[4]} {xpcie_top/xtlp_to_axi_master/tlp_in_data[5]} {xpcie_top/xtlp_to_axi_master/tlp_in_data[6]} {xpcie_top/xtlp_to_axi_master/tlp_in_data[7]} {xpcie_top/xtlp_to_axi_master/tlp_in_data[8]} {xpcie_top/xtlp_to_axi_master/tlp_in_data[9]} {xpcie_top/xtlp_to_axi_master/tlp_in_data[10]} {xpcie_top/xtlp_to_axi_master/tlp_in_data[11]} {xpcie_top/xtlp_to_axi_master/tlp_in_data[12]} {xpcie_top/xtlp_to_axi_master/tlp_in_data[13]} {xpcie_top/xtlp_to_axi_master/tlp_in_data[14]} {xpcie_top/xtlp_to_axi_master/tlp_in_data[15]} {xpcie_top/xtlp_to_axi_master/tlp_in_data[16]} {xpcie_top/xtlp_to_axi_master/tlp_in_data[17]} {xpcie_top/xtlp_to_axi_master/tlp_in_data[18]} {xpcie_top/xtlp_to_axi_master/tlp_in_data[19]} {xpcie_top/xtlp_to_axi_master/tlp_in_data[20]} {xpcie_top/xtlp_to_axi_master/tlp_in_data[21]} {xpcie_top/xtlp_to_axi_master/tlp_in_data[22]} {xpcie_top/xtlp_to_axi_master/tlp_in_data[23]} {xpcie_top/xtlp_to_axi_master/tlp_in_data[24]} {xpcie_top/xtlp_to_axi_master/tlp_in_data[25]} {xpcie_top/xtlp_to_axi_master/tlp_in_data[26]} {xpcie_top/xtlp_to_axi_master/tlp_in_data[27]} {xpcie_top/xtlp_to_axi_master/tlp_in_data[28]} {xpcie_top/xtlp_to_axi_master/tlp_in_data[29]} {xpcie_top/xtlp_to_axi_master/tlp_in_data[30]} {xpcie_top/xtlp_to_axi_master/tlp_in_data[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 4 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list {xpcie_top/xtlp_to_axi_master/axim_wstrb[0]} {xpcie_top/xtlp_to_axi_master/axim_wstrb[1]} {xpcie_top/xtlp_to_axi_master/axim_wstrb[2]} {xpcie_top/xtlp_to_axi_master/axim_wstrb[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 1 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list {xpcie_top/xtlp_to_axi_master/axim_arid[0]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 32 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list {xpcie_top/xtlp_to_axi_master/axim_awaddr[0]} {xpcie_top/xtlp_to_axi_master/axim_awaddr[1]} {xpcie_top/xtlp_to_axi_master/axim_awaddr[2]} {xpcie_top/xtlp_to_axi_master/axim_awaddr[3]} {xpcie_top/xtlp_to_axi_master/axim_awaddr[4]} {xpcie_top/xtlp_to_axi_master/axim_awaddr[5]} {xpcie_top/xtlp_to_axi_master/axim_awaddr[6]} {xpcie_top/xtlp_to_axi_master/axim_awaddr[7]} {xpcie_top/xtlp_to_axi_master/axim_awaddr[8]} {xpcie_top/xtlp_to_axi_master/axim_awaddr[9]} {xpcie_top/xtlp_to_axi_master/axim_awaddr[10]} {xpcie_top/xtlp_to_axi_master/axim_awaddr[11]} {xpcie_top/xtlp_to_axi_master/axim_awaddr[12]} {xpcie_top/xtlp_to_axi_master/axim_awaddr[13]} {xpcie_top/xtlp_to_axi_master/axim_awaddr[14]} {xpcie_top/xtlp_to_axi_master/axim_awaddr[15]} {xpcie_top/xtlp_to_axi_master/axim_awaddr[16]} {xpcie_top/xtlp_to_axi_master/axim_awaddr[17]} {xpcie_top/xtlp_to_axi_master/axim_awaddr[18]} {xpcie_top/xtlp_to_axi_master/axim_awaddr[19]} {xpcie_top/xtlp_to_axi_master/axim_awaddr[20]} {xpcie_top/xtlp_to_axi_master/axim_awaddr[21]} {xpcie_top/xtlp_to_axi_master/axim_awaddr[22]} {xpcie_top/xtlp_to_axi_master/axim_awaddr[23]} {xpcie_top/xtlp_to_axi_master/axim_awaddr[24]} {xpcie_top/xtlp_to_axi_master/axim_awaddr[25]} {xpcie_top/xtlp_to_axi_master/axim_awaddr[26]} {xpcie_top/xtlp_to_axi_master/axim_awaddr[27]} {xpcie_top/xtlp_to_axi_master/axim_awaddr[28]} {xpcie_top/xtlp_to_axi_master/axim_awaddr[29]} {xpcie_top/xtlp_to_axi_master/axim_awaddr[30]} {xpcie_top/xtlp_to_axi_master/axim_awaddr[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 1 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list {xpcie_top/xtlp_to_axi_master/axim_wid[0]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 8 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list {xpcie_top/xtlp_to_axi_master/axim_arlen[0]} {xpcie_top/xtlp_to_axi_master/axim_arlen[1]} {xpcie_top/xtlp_to_axi_master/axim_arlen[2]} {xpcie_top/xtlp_to_axi_master/axim_arlen[3]} {xpcie_top/xtlp_to_axi_master/axim_arlen[4]} {xpcie_top/xtlp_to_axi_master/axim_arlen[5]} {xpcie_top/xtlp_to_axi_master/axim_arlen[6]} {xpcie_top/xtlp_to_axi_master/axim_arlen[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 62 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list {xpcie_top/xtlp_to_axi_master/tlp_out_address[2]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[3]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[4]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[5]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[6]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[7]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[8]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[9]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[10]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[11]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[12]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[13]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[14]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[15]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[16]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[17]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[18]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[19]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[20]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[21]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[22]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[23]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[24]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[25]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[26]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[27]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[28]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[29]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[30]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[31]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[32]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[33]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[34]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[35]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[36]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[37]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[38]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[39]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[40]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[41]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[42]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[43]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[44]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[45]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[46]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[47]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[48]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[49]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[50]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[51]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[52]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[53]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[54]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[55]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[56]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[57]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[58]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[59]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[60]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[61]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[62]} {xpcie_top/xtlp_to_axi_master/tlp_out_address[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 13 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list {xpcie_top/xtlp_to_axi_master/tlp_out_byte_count[0]} {xpcie_top/xtlp_to_axi_master/tlp_out_byte_count[1]} {xpcie_top/xtlp_to_axi_master/tlp_out_byte_count[2]} {xpcie_top/xtlp_to_axi_master/tlp_out_byte_count[3]} {xpcie_top/xtlp_to_axi_master/tlp_out_byte_count[4]} {xpcie_top/xtlp_to_axi_master/tlp_out_byte_count[5]} {xpcie_top/xtlp_to_axi_master/tlp_out_byte_count[6]} {xpcie_top/xtlp_to_axi_master/tlp_out_byte_count[7]} {xpcie_top/xtlp_to_axi_master/tlp_out_byte_count[8]} {xpcie_top/xtlp_to_axi_master/tlp_out_byte_count[9]} {xpcie_top/xtlp_to_axi_master/tlp_out_byte_count[10]} {xpcie_top/xtlp_to_axi_master/tlp_out_byte_count[11]} {xpcie_top/xtlp_to_axi_master/tlp_out_byte_count[12]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 1 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list {xpcie_top/xtlp_to_axi_master/axim_awid[0]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
set_property port_width 13 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list {xpcie_top/xtlp_to_axi_master/tlp_in_byte_count[0]} {xpcie_top/xtlp_to_axi_master/tlp_in_byte_count[1]} {xpcie_top/xtlp_to_axi_master/tlp_in_byte_count[2]} {xpcie_top/xtlp_to_axi_master/tlp_in_byte_count[3]} {xpcie_top/xtlp_to_axi_master/tlp_in_byte_count[4]} {xpcie_top/xtlp_to_axi_master/tlp_in_byte_count[5]} {xpcie_top/xtlp_to_axi_master/tlp_in_byte_count[6]} {xpcie_top/xtlp_to_axi_master/tlp_in_byte_count[7]} {xpcie_top/xtlp_to_axi_master/tlp_in_byte_count[8]} {xpcie_top/xtlp_to_axi_master/tlp_in_byte_count[9]} {xpcie_top/xtlp_to_axi_master/tlp_in_byte_count[10]} {xpcie_top/xtlp_to_axi_master/tlp_in_byte_count[11]} {xpcie_top/xtlp_to_axi_master/tlp_in_byte_count[12]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe28]
set_property port_width 7 [get_debug_ports u_ila_0/probe28]
connect_debug_port u_ila_0/probe28 [get_nets [list {xpcie_top/xtlp_to_axi_master/tlp_out_lower_address[0]} {xpcie_top/xtlp_to_axi_master/tlp_out_lower_address[1]} {xpcie_top/xtlp_to_axi_master/tlp_out_lower_address[2]} {xpcie_top/xtlp_to_axi_master/tlp_out_lower_address[3]} {xpcie_top/xtlp_to_axi_master/tlp_out_lower_address[4]} {xpcie_top/xtlp_to_axi_master/tlp_out_lower_address[5]} {xpcie_top/xtlp_to_axi_master/tlp_out_lower_address[6]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe29]
set_property port_width 4 [get_debug_ports u_ila_0/probe29]
connect_debug_port u_ila_0/probe29 [get_nets [list {xpcie_top/xtlp_to_axi_master/tlp_in_byte_en[0]} {xpcie_top/xtlp_to_axi_master/tlp_in_byte_en[1]} {xpcie_top/xtlp_to_axi_master/tlp_in_byte_en[2]} {xpcie_top/xtlp_to_axi_master/tlp_in_byte_en[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe30]
set_property port_width 32 [get_debug_ports u_ila_0/probe30]
connect_debug_port u_ila_0/probe30 [get_nets [list {xpcie_top/xtlp_to_axi_master/tlp_timeout_value[0]} {xpcie_top/xtlp_to_axi_master/tlp_timeout_value[1]} {xpcie_top/xtlp_to_axi_master/tlp_timeout_value[2]} {xpcie_top/xtlp_to_axi_master/tlp_timeout_value[3]} {xpcie_top/xtlp_to_axi_master/tlp_timeout_value[4]} {xpcie_top/xtlp_to_axi_master/tlp_timeout_value[5]} {xpcie_top/xtlp_to_axi_master/tlp_timeout_value[6]} {xpcie_top/xtlp_to_axi_master/tlp_timeout_value[7]} {xpcie_top/xtlp_to_axi_master/tlp_timeout_value[8]} {xpcie_top/xtlp_to_axi_master/tlp_timeout_value[9]} {xpcie_top/xtlp_to_axi_master/tlp_timeout_value[10]} {xpcie_top/xtlp_to_axi_master/tlp_timeout_value[11]} {xpcie_top/xtlp_to_axi_master/tlp_timeout_value[12]} {xpcie_top/xtlp_to_axi_master/tlp_timeout_value[13]} {xpcie_top/xtlp_to_axi_master/tlp_timeout_value[14]} {xpcie_top/xtlp_to_axi_master/tlp_timeout_value[15]} {xpcie_top/xtlp_to_axi_master/tlp_timeout_value[16]} {xpcie_top/xtlp_to_axi_master/tlp_timeout_value[17]} {xpcie_top/xtlp_to_axi_master/tlp_timeout_value[18]} {xpcie_top/xtlp_to_axi_master/tlp_timeout_value[19]} {xpcie_top/xtlp_to_axi_master/tlp_timeout_value[20]} {xpcie_top/xtlp_to_axi_master/tlp_timeout_value[21]} {xpcie_top/xtlp_to_axi_master/tlp_timeout_value[22]} {xpcie_top/xtlp_to_axi_master/tlp_timeout_value[23]} {xpcie_top/xtlp_to_axi_master/tlp_timeout_value[24]} {xpcie_top/xtlp_to_axi_master/tlp_timeout_value[25]} {xpcie_top/xtlp_to_axi_master/tlp_timeout_value[26]} {xpcie_top/xtlp_to_axi_master/tlp_timeout_value[27]} {xpcie_top/xtlp_to_axi_master/tlp_timeout_value[28]} {xpcie_top/xtlp_to_axi_master/tlp_timeout_value[29]} {xpcie_top/xtlp_to_axi_master/tlp_timeout_value[30]} {xpcie_top/xtlp_to_axi_master/tlp_timeout_value[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe31]
set_property port_width 32 [get_debug_ports u_ila_0/probe31]
connect_debug_port u_ila_0/probe31 [get_nets [list {xpcie_top/xtlp_to_axi_master/axi_translated_address[0]} {xpcie_top/xtlp_to_axi_master/axi_translated_address[1]} {xpcie_top/xtlp_to_axi_master/axi_translated_address[2]} {xpcie_top/xtlp_to_axi_master/axi_translated_address[3]} {xpcie_top/xtlp_to_axi_master/axi_translated_address[4]} {xpcie_top/xtlp_to_axi_master/axi_translated_address[5]} {xpcie_top/xtlp_to_axi_master/axi_translated_address[6]} {xpcie_top/xtlp_to_axi_master/axi_translated_address[7]} {xpcie_top/xtlp_to_axi_master/axi_translated_address[8]} {xpcie_top/xtlp_to_axi_master/axi_translated_address[9]} {xpcie_top/xtlp_to_axi_master/axi_translated_address[10]} {xpcie_top/xtlp_to_axi_master/axi_translated_address[11]} {xpcie_top/xtlp_to_axi_master/axi_translated_address[12]} {xpcie_top/xtlp_to_axi_master/axi_translated_address[13]} {xpcie_top/xtlp_to_axi_master/axi_translated_address[14]} {xpcie_top/xtlp_to_axi_master/axi_translated_address[15]} {xpcie_top/xtlp_to_axi_master/axi_translated_address[16]} {xpcie_top/xtlp_to_axi_master/axi_translated_address[17]} {xpcie_top/xtlp_to_axi_master/axi_translated_address[18]} {xpcie_top/xtlp_to_axi_master/axi_translated_address[19]} {xpcie_top/xtlp_to_axi_master/axi_translated_address[20]} {xpcie_top/xtlp_to_axi_master/axi_translated_address[21]} {xpcie_top/xtlp_to_axi_master/axi_translated_address[22]} {xpcie_top/xtlp_to_axi_master/axi_translated_address[23]} {xpcie_top/xtlp_to_axi_master/axi_translated_address[24]} {xpcie_top/xtlp_to_axi_master/axi_translated_address[25]} {xpcie_top/xtlp_to_axi_master/axi_translated_address[26]} {xpcie_top/xtlp_to_axi_master/axi_translated_address[27]} {xpcie_top/xtlp_to_axi_master/axi_translated_address[28]} {xpcie_top/xtlp_to_axi_master/axi_translated_address[29]} {xpcie_top/xtlp_to_axi_master/axi_translated_address[30]} {xpcie_top/xtlp_to_axi_master/axi_translated_address[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe32]
set_property port_width 1 [get_debug_ports u_ila_0/probe32]
connect_debug_port u_ila_0/probe32 [get_nets [list xpcie_top/xtlp_to_axi_master/axim_arready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe33]
set_property port_width 1 [get_debug_ports u_ila_0/probe33]
connect_debug_port u_ila_0/probe33 [get_nets [list xpcie_top/xtlp_to_axi_master/axim_arvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe34]
set_property port_width 1 [get_debug_ports u_ila_0/probe34]
connect_debug_port u_ila_0/probe34 [get_nets [list xpcie_top/xtlp_to_axi_master/axim_awready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe35]
set_property port_width 1 [get_debug_ports u_ila_0/probe35]
connect_debug_port u_ila_0/probe35 [get_nets [list xpcie_top/xtlp_to_axi_master/axim_awvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe36]
set_property port_width 1 [get_debug_ports u_ila_0/probe36]
connect_debug_port u_ila_0/probe36 [get_nets [list xpcie_top/xtlp_to_axi_master/axim_bready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe37]
set_property port_width 1 [get_debug_ports u_ila_0/probe37]
connect_debug_port u_ila_0/probe37 [get_nets [list xpcie_top/xtlp_to_axi_master/axim_bvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe38]
set_property port_width 1 [get_debug_ports u_ila_0/probe38]
connect_debug_port u_ila_0/probe38 [get_nets [list xpcie_top/xtlp_to_axi_master/axim_rlast]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe39]
set_property port_width 1 [get_debug_ports u_ila_0/probe39]
connect_debug_port u_ila_0/probe39 [get_nets [list xpcie_top/xtlp_to_axi_master/axim_rready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe40]
set_property port_width 1 [get_debug_ports u_ila_0/probe40]
connect_debug_port u_ila_0/probe40 [get_nets [list xpcie_top/xtlp_to_axi_master/axim_rvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe41]
set_property port_width 1 [get_debug_ports u_ila_0/probe41]
connect_debug_port u_ila_0/probe41 [get_nets [list xpcie_top/xtlp_to_axi_master/axim_wlast]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe42]
set_property port_width 1 [get_debug_ports u_ila_0/probe42]
connect_debug_port u_ila_0/probe42 [get_nets [list xpcie_top/xtlp_to_axi_master/axim_wready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe43]
set_property port_width 1 [get_debug_ports u_ila_0/probe43]
connect_debug_port u_ila_0/probe43 [get_nets [list xpcie_top/xtlp_to_axi_master/axim_wvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe44]
set_property port_width 1 [get_debug_ports u_ila_0/probe44]
connect_debug_port u_ila_0/probe44 [get_nets [list xpcie_top/xtlp_to_axi_master/tlp_abort_cntr_init]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe45]
set_property port_width 1 [get_debug_ports u_ila_0/probe45]
connect_debug_port u_ila_0/probe45 [get_nets [list xpcie_top/xtlp_to_axi_master/tlp_in_abort]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe46]
set_property port_width 1 [get_debug_ports u_ila_0/probe46]
connect_debug_port u_ila_0/probe46 [get_nets [list xpcie_top/xtlp_to_axi_master/tlp_in_accept_data]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe47]
set_property port_width 1 [get_debug_ports u_ila_0/probe47]
connect_debug_port u_ila_0/probe47 [get_nets [list xpcie_top/xtlp_to_axi_master/tlp_in_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe48]
set_property port_width 1 [get_debug_ports u_ila_0/probe48]
connect_debug_port u_ila_0/probe48 [get_nets [list xpcie_top/xtlp_to_axi_master/tlp_out_dst_rdy_n]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe49]
set_property port_width 1 [get_debug_ports u_ila_0/probe49]
connect_debug_port u_ila_0/probe49 [get_nets [list xpcie_top/xtlp_to_axi_master/tlp_out_grant]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe50]
set_property port_width 1 [get_debug_ports u_ila_0/probe50]
connect_debug_port u_ila_0/probe50 [get_nets [list xpcie_top/xtlp_to_axi_master/tlp_out_req_to_send]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe51]
set_property port_width 1 [get_debug_ports u_ila_0/probe51]
connect_debug_port u_ila_0/probe51 [get_nets [list xpcie_top/xtlp_to_axi_master/tlp_out_src_rdy_n]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets pclk]
