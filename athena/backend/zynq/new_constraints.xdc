

create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER true [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 8192 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list xsystem_wrapper/system_i/pcie2AxiMaster_0/U0/xxil_pcie/pcie_7x_0_xil_wrapper/inst/inst/gt_top_i/pipe_wrapper_i/pipe_clock_int.pipe_clock_i/mmcm_i_0]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 32 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_readdata[0]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_readdata[1]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_readdata[2]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_readdata[3]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_readdata[4]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_readdata[5]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_readdata[6]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_readdata[7]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_readdata[8]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_readdata[9]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_readdata[10]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_readdata[11]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_readdata[12]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_readdata[13]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_readdata[14]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_readdata[15]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_readdata[16]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_readdata[17]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_readdata[18]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_readdata[19]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_readdata[20]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_readdata[21]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_readdata[22]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_readdata[23]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_readdata[24]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_readdata[25]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_readdata[26]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_readdata[27]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_readdata[28]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_readdata[29]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_readdata[30]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_readdata[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 3 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {xsystem_wrapper/system_i/axiXGS_controller_0/U0/regfile[ACQ][ACQ_SER_ADDATA][SER_DAT][13]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/regfile[ACQ][ACQ_SER_ADDATA][SER_DAT][14]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/regfile[ACQ][ACQ_SER_ADDATA][SER_DAT][15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 32 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_writedata[0]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_writedata[1]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_writedata[2]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_writedata[3]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_writedata[4]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_writedata[5]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_writedata[6]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_writedata[7]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_writedata[8]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_writedata[9]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_writedata[10]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_writedata[11]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_writedata[12]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_writedata[13]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_writedata[14]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_writedata[15]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_writedata[16]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_writedata[17]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_writedata[18]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_writedata[19]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_writedata[20]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_writedata[21]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_writedata[22]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_writedata[23]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_writedata[24]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_writedata[25]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_writedata[26]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_writedata[27]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_writedata[28]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_writedata[29]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_writedata[30]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_writedata[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 11 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {xsystem_wrapper/system_i/axiXGS_controller_0/U0/regfile[ACQ][ACQ_SER_STAT][SER_DAT_R][1]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/regfile[ACQ][ACQ_SER_STAT][SER_DAT_R][2]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/regfile[ACQ][ACQ_SER_STAT][SER_DAT_R][3]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/regfile[ACQ][ACQ_SER_STAT][SER_DAT_R][4]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/regfile[ACQ][ACQ_SER_STAT][SER_DAT_R][5]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/regfile[ACQ][ACQ_SER_STAT][SER_DAT_R][6]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/regfile[ACQ][ACQ_SER_STAT][SER_DAT_R][7]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/regfile[ACQ][ACQ_SER_STAT][SER_DAT_R][8]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/regfile[ACQ][ACQ_SER_STAT][SER_DAT_R][9]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/regfile[ACQ][ACQ_SER_STAT][SER_DAT_R][10]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/regfile[ACQ][ACQ_SER_STAT][SER_DAT_R][15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 10 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {xsystem_wrapper/system_i/axiXGS_controller_0/U0/X_AxiSlave2Reg/reg_addr[2]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/X_AxiSlave2Reg/reg_addr[3]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/X_AxiSlave2Reg/reg_addr[4]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/X_AxiSlave2Reg/reg_addr[5]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/X_AxiSlave2Reg/reg_addr[6]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/X_AxiSlave2Reg/reg_addr[7]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/X_AxiSlave2Reg/reg_addr[8]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/X_AxiSlave2Reg/reg_addr[9]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/X_AxiSlave2Reg/reg_addr[10]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/X_AxiSlave2Reg/reg_addr[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 4 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {xsystem_wrapper/system_i/axiXGS_controller_0/U0/X_AxiSlave2Reg/reg_beN[0]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/X_AxiSlave2Reg/reg_beN[1]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/X_AxiSlave2Reg/reg_beN[2]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/X_AxiSlave2Reg/reg_beN[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 15 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {xsystem_wrapper/system_i/axiXGS_controller_0/U0/Xregfile_xgs/regfile[ACQ][ACQ_SER_ADDATA][SER_ADD][0]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/Xregfile_xgs/regfile[ACQ][ACQ_SER_ADDATA][SER_ADD][1]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/Xregfile_xgs/regfile[ACQ][ACQ_SER_ADDATA][SER_ADD][2]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/Xregfile_xgs/regfile[ACQ][ACQ_SER_ADDATA][SER_ADD][3]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/Xregfile_xgs/regfile[ACQ][ACQ_SER_ADDATA][SER_ADD][4]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/Xregfile_xgs/regfile[ACQ][ACQ_SER_ADDATA][SER_ADD][5]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/Xregfile_xgs/regfile[ACQ][ACQ_SER_ADDATA][SER_ADD][6]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/Xregfile_xgs/regfile[ACQ][ACQ_SER_ADDATA][SER_ADD][7]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/Xregfile_xgs/regfile[ACQ][ACQ_SER_ADDATA][SER_ADD][8]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/Xregfile_xgs/regfile[ACQ][ACQ_SER_ADDATA][SER_ADD][9]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/Xregfile_xgs/regfile[ACQ][ACQ_SER_ADDATA][SER_ADD][10]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/Xregfile_xgs/regfile[ACQ][ACQ_SER_ADDATA][SER_ADD][11]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/Xregfile_xgs/regfile[ACQ][ACQ_SER_ADDATA][SER_ADD][12]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/Xregfile_xgs/regfile[ACQ][ACQ_SER_ADDATA][SER_ADD][13]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/Xregfile_xgs/regfile[ACQ][ACQ_SER_ADDATA][SER_ADD][14]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 13 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {xsystem_wrapper/system_i/axiXGS_controller_0/U0/Xregfile_xgs/regfile[ACQ][ACQ_SER_ADDATA][SER_DAT][0]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/Xregfile_xgs/regfile[ACQ][ACQ_SER_ADDATA][SER_DAT][1]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/Xregfile_xgs/regfile[ACQ][ACQ_SER_ADDATA][SER_DAT][2]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/Xregfile_xgs/regfile[ACQ][ACQ_SER_ADDATA][SER_DAT][3]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/Xregfile_xgs/regfile[ACQ][ACQ_SER_ADDATA][SER_DAT][4]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/Xregfile_xgs/regfile[ACQ][ACQ_SER_ADDATA][SER_DAT][5]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/Xregfile_xgs/regfile[ACQ][ACQ_SER_ADDATA][SER_DAT][6]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/Xregfile_xgs/regfile[ACQ][ACQ_SER_ADDATA][SER_DAT][7]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/Xregfile_xgs/regfile[ACQ][ACQ_SER_ADDATA][SER_DAT][8]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/Xregfile_xgs/regfile[ACQ][ACQ_SER_ADDATA][SER_DAT][9]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/Xregfile_xgs/regfile[ACQ][ACQ_SER_ADDATA][SER_DAT][10]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/Xregfile_xgs/regfile[ACQ][ACQ_SER_ADDATA][SER_DAT][11]} {xsystem_wrapper/system_i/axiXGS_controller_0/U0/Xregfile_xgs/regfile[ACQ][ACQ_SER_ADDATA][SER_DAT][12]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_read]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list xsystem_wrapper/system_i/axiXGS_controller_0/U0/reg_readdatavalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 1 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list xsystem_wrapper/system_i/axiXGS_controller_0/U0/X_AxiSlave2Reg/reg_write]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {xsystem_wrapper/system_i/axiXGS_controller_0/U0/regfile[ACQ][ACQ_SER_CTRL][SER_RF_SS]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {xsystem_wrapper/system_i/axiXGS_controller_0/U0/regfile[ACQ][ACQ_SER_CTRL][SER_RWn]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {xsystem_wrapper/system_i/axiXGS_controller_0/U0/regfile[ACQ][ACQ_SER_CTRL][SER_WF_SS]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {xsystem_wrapper/system_i/axiXGS_controller_0/U0/regfile[ACQ][ACQ_SER_STAT][SER_BUSY]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 1 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {xsystem_wrapper/system_i/axiXGS_controller_0/U0/regfile[ACQ][ACQ_SER_STAT][SER_FIFO_EMPTY]}]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets u_ila_0_mmcm_i_0]
