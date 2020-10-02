# Synchronous DDR inputs (Edge aligned) see the following link:
#    https://forums.xilinx.com/t5/Timing-Analysis/How-to-constraint-Same-Edge-capture-edge-aligned-DDR-input/m-p/646009#M8411# RDS CLK: 133 MHZ
create_clock -period 7.500 -name VIRT_CLK
create_clock -period 7.500 -name RDS_CLK [get_ports hb_rwds]
set_clock_uncertainty -from [get_clocks VIRT_CLK] -to [get_clocks RDS_CLK] 0.300

set_input_delay -clock VIRT_CLK 0.450 [get_ports {hb_dq[*]}]
set_input_delay -clock VIRT_CLK -min -0.450 [get_ports {hb_dq[*]}]
set_input_delay -clock VIRT_CLK -clock_fall -add_delay 0.450 [get_ports {hb_dq[*]}]
set_input_delay -clock VIRT_CLK -clock_fall -min -add_delay -0.450 [get_ports {hb_dq[*]}]

# This effectively the capture edge back by one full clock period.
set_multicycle_path -from [get_clocks VIRT_CLK] -to [get_clocks RDS_CLK] 0

# So now lets look at our four paths
#
#     a) Launch  at 0ns to capture a -5ns (from 5ns pulled back one complete clock period)
#     b) Launch at 5ns to capture at 0ns (from 10ns)
#     c) Launch at 0ns to capture at 0ns (from 10ns) - this is the correct one! (Don't forget the delay line on the clock path in the FPGA that shift the clock)
#     d) Launch at 5ns to capture at 5ns (from 15ns) - this is the other correct one  (Don't forget the delay line on the clock path in the FPGA that shift the clock)
#
#  Clearly, though, now a) and b) are not just incorrect, but they will fail. So we need to disable them
set_false_path -setup -rise_from [get_clocks VIRT_CLK] -fall_to [get_clocks RDS_CLK]
set_false_path -setup -fall_from [get_clocks VIRT_CLK] -rise_to [get_clocks RDS_CLK]


# So now we have the correct setup checks. The hold checks are even more complicated; I won't go through the details, but they need these:

set_multicycle_path -hold -from [get_clocks VIRT_CLK] -to [get_clocks RDS_CLK] -1
set_false_path -hold -rise_from [get_clocks VIRT_CLK] -rise_to [get_clocks RDS_CLK]
set_false_path -hold -fall_from [get_clocks VIRT_CLK] -fall_to [get_clocks RDS_CLK]



#  Double Data Rate Source Synchronous Outputs
#
#  Source synchronous output interfaces can be constrained either by the max data skew
#  relative to the generated clock or by the destination device setup/hold requirements.
#
#  Setup/Hold Case:
#  Setup and hold requirements for the destination device and board trace delays are known.
#
# forwarded                        _________________________________
# clock                 __________|                                 |______________
#                                 |                                 |
#                           tsu_r |  thd_r                    tsu_f | thd_f
#                         <------>|<------->                <------>|<----->
#                         ________|_________                ________|_______
# data @ destination   XXX__________________XXXXXXXXXXXXXXXX________________XXXXX
#
# Example of creating generated clock at clock output port
# create_generated_clock -name <gen_clock_name> -multiply_by 1 -source [get_pins <source_pin>] [get_ports <output_clock_port>]
# gen_clock_name is the name of forwarded clock here. It should be used below for defining "fwclk".
create_generated_clock -name RPC_CK -source [get_pins ares_pb_i/ares_pb_i/rpc2_ctrl_controller_0/inst/rpc2_ctrl_io/io_oddr_ck/ODDR_inst/C] -multiply_by 1 -invert [get_ports hb_ck]

# Output Delay Constraints
set_output_delay -clock RPC_CK -max 1.000 [get_ports {hb_dq[*]}]
set_output_delay -clock RPC_CK -min -1.000 [get_ports {hb_dq[*]}]
set_output_delay -clock RPC_CK -clock_fall -max -add_delay 1.000 [get_ports {hb_dq[*]}]
set_output_delay -clock RPC_CK -clock_fall -min -add_delay -1.000 [get_ports {hb_dq[*]}]



# Report Timing Template
#report_timing -rise_to [get_ports $output_ports] -max_paths 20 -nworst 2 -delay_type min_max -name src_sync_ddr_out_rise -file src_sync_ddr_out_rise.txt;
#report_timing -fall_to [get_ports $output_ports] -max_paths 20 -nworst 2 -delay_type min_max -name src_sync_ddr_out_fall -file src_sync_ddr_out_fall.txt;


set_false_path -to [get_pins ares_pb_i/ares_pb_i/rpc2_ctrl_controller_0/inst/rpc2_ctrl_io/reset_clk90_Meta_reg/PRE]
set_false_path -to [get_pins ares_pb_i/ares_pb_i/rpc2_ctrl_controller_0/inst/rpc2_ctrl_io/reset_clk90_reg/PRE]


