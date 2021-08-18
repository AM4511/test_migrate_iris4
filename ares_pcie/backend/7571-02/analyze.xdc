
# Report Timing Template
report_timing -rise_from [get_ports {hb_dq[0]}] -max_paths 20 -nworst 20 -delay_type min_max -name src_sync_ddr_in_rise
report_timing -fall_from [get_ports {hb_dq[0]}] -max_paths 20 -nworst 20 -delay_type min_max -name src_sync_ddr_in_fall


# Report Timing Template
report_timing -rise_from [get_clocks VIRT_CLK] -through [get_ports {hb_dq[0]}] -max_paths 20 -nworst 20 -delay_type min_max -name src_sync_ddr_in_rise
report_timing -fall_from [get_clocks VIRT_CLK] -through [get_ports {hb_dq[0]}] -max_paths 20 -nworst 20 -delay_type min_max -name src_sync_ddr_in_fall


report_timing -to [get_pins -hierarchical -filter {NAME=~*rpc2_ctrl_dqin_block/dqinfifo/mem_reg*/I}] -max_paths 64 -nworst 20 -delay_type max -name src_sync_ddr_in_setup_rise
report_timing -to [get_pins -hierarchical -filter {NAME=~*rpc2_ctrl_dqin_block/dqinfifo/mem_reg*/I}] -max_paths 64 -nworst 20 -delay_type min -name src_sync_ddr_in_hold_rise

