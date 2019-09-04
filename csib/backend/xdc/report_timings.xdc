report_timing -to [get_ports *ncsi_clk*] -delay_type min_max -max_paths 10 -sort_by group -input_pins -routable_nets -name CLK_DELAY_TO_NCSI
report_timing -from [get_ports -filter { NAME =~ "*ncsi*" && DIRECTION == "IN" }] -delay_type min_max -max_paths 10 -sort_by group -input_pins -routable_nets -name NCSI_INPUT
report_timing -to [get_ports -filter { NAME =~ "*ncsi_tx*" && DIRECTION == "OUT" }] -delay_type min_max -max_paths 10 -sort_by group -input_pins -routable_nets -name NCSI_OUTPUT

report_timing -to [get_ports {lan1_ncsi_clk lan2_ncsi_clk lan3_ncsi_clk lan4_ncsi_clk profinet2_ncsi_clk}] -delay_type min_max -max_paths 10 -sort_by group -input_pins -routable_nets -name timing_1


# Report timing for calculating the delay for the profinet1 interface
report_timing -rise_from [get_clocks ncsi_clk_out] -rise_to [get_ports lan1_ncsi_clk] -delay_type min_max -max_paths 10 -sort_by group -input_pins -routable_nets -name lan1_ncsi_clk_delay
report_timing -rise_from [get_clocks ncsi_clk_out] -rise_to [get_ports lan2_ncsi_clk] -delay_type min_max -max_paths 10 -sort_by group -input_pins -routable_nets -name lan2_ncsi_clk_delay
report_timing -rise_from [get_clocks ncsi_clk_out] -rise_to [get_ports lan3_ncsi_clk] -delay_type min_max -max_paths 10 -sort_by group -input_pins -routable_nets -name lan3_ncsi_clk_delay
report_timing -rise_from [get_clocks ncsi_clk_out] -rise_to [get_ports lan4_ncsi_clk] -delay_type min_max -max_paths 10 -sort_by group -input_pins -routable_nets -name lan4_ncsi_clk_delay



# Output from FPGA
report_timing  -to [get_ports profinet1_ncsi_tx_en]  -delay_type min_max -max_paths 10 -sort_by group  -routable_nets -name profinet1_ncsi_tx_en
report_timing  -to [get_ports profinet1_ncsi_txd[0]] -delay_type min_max -max_paths 10 -sort_by group  -routable_nets -name profinet1_ncsi_txd[0]
report_timing  -to [get_ports profinet1_ncsi_txd[1]] -delay_type min_max -max_paths 10 -sort_by group  -routable_nets -name profinet1_ncsi_txd[1]

# Input from FPGA

report_timing  -from [get_ports profinet1_ncsi_rxd[0]]  -delay_type min_max -max_paths 10 -sort_by group  -routable_nets -name profinet1_ncsi_rxd[0]
report_timing  -from [get_ports profinet1_ncsi_rxd[1]]  -delay_type min_max -max_paths 10 -sort_by group  -routable_nets -name profinet1_ncsi_rxd[1]
report_timing  -from [get_ports profinet1_ncsi_crs_dv]  -delay_type min_max -max_paths 10 -sort_by group  -routable_nets -name profinet1_ncsi_crs_dv



create_generated_clock -name profinet1_clk_int -source [get_pins xmiox_pb_wrapper/miox_pb_i/clk_wiz_0/inst/plle2_adv_inst/CLKIN1] -edges {1 2 3} -edge_shift {0.2 0.2 0.2} [get_pins xmiox_pb_wrapper/miox_pb_i/clk_wiz_0/inst/plle2_adv_inst/CLKOUT1]

-add -master_clock  clk_fpga_1 