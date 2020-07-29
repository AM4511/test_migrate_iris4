# RDS CLK: 133 MHZ
set RDS_CLOCK_PERIOD 7.500
create_clock -period ${RDS_CLOCK_PERIOD} -name VIRT_CLK
create_clock -period ${RDS_CLOCK_PERIOD} -name RDS_CLK [get_ports hb_rwds]
set_clock_uncertainty -from [get_clocks VIRT_CLK] -to [get_clocks  RDS_CLK] 0.300

set_input_delay -clock VIRT_CLK  0.45      [get_ports {hb_dq[*]}]
set_input_delay -clock VIRT_CLK -0.45 -min [get_ports {hb_dq[*]}]
set_input_delay -clock VIRT_CLK  0.45      [get_ports {hb_dq[*]}] -clock_fall -add_delay
set_input_delay -clock VIRT_CLK -0.45 -min [get_ports {hb_dq[*]}] -clock_fall -add_delay

# This effectively the capture edge back by one full clock period.
set_multicycle_path 0 -from [get_clocks VIRT_CLK] -to [get_clocks RDS_CLK]

# So now lets look at our four paths
# 
#     a) Launch  at 0ns to capture a -5ns (from 5ns pulled back one complete clock period)
#     b) Launch at 5ns to capture at 0ns (from 10ns)
#     c) Launch at 0ns to capture at 0ns (from 10ns) - this is the correct one! (Don't forget the delay line on the clock path in the FPGA that shift the clock)
#     d) Launch at 5ns to capture at 5ns (from 15ns) - this is the other correct one  (Don't forget the delay line on the clock path in the FPGA that shift the clock)
# 
#  Clearly, though, now a) and b) are not just incorrect, but they will fail. So we need to disable them
set_false_path -setup -rise_from [get_clocks VIRT_CLK] -fall_to [get_clocks RDS_CLK]; # diable a)
set_false_path -setup -fall_from [get_clocks VIRT_CLK] -rise_to [get_clocks RDS_CLK]; # diable b) 


# So now we have the correct setup checks. The hold checks are even more complicated; I won't go through the details, but they need these:

set_multicycle_path -1 -hold -from [get_clocks VIRT_CLK] -to [get_clocks RDS_CLK]
set_false_path -hold -rise_from [get_clocks VIRT_CLK] -rise_to [get_clocks RDS_CLK];
set_false_path -hold -fall_from [get_clocks VIRT_CLK] -fall_to [get_clocks RDS_CLK]; 

# Edge-Aligned Double Data Rate Source Synchronous Inputs
# (Using a direct FF connection)
#
# For an edge-aligned Source Synchronous interface, the clock
# transition occurs at the same time as the data transitions.
# In this template, the clock is aligned with the beginning of the
# data. The constraints below rely on the default timing
# analysis (setup = 1/2 cycle, hold = 0 cycle).
#
# input            _________________________________
# clock  _________|                                 |___________________________
#                 |                                 |                 
#         skew_bre|skew_are                 skew_bfe|skew_afe
#         <------>|<------>                 <------>|<------>
#        _        |        _________________        |        _________________
# data   _XXXXXXXXXXXXXXXXX____Rise_Data____XXXXXXXXXXXXXXXXX____Fall_Data____XX
#
# For better understanding on this cheating method for defining timings on source 
# synchronous DDR inputs (Edge aligned) see the following link:
#    https://forums.xilinx.com/t5/Timing-Analysis/How-to-constraint-Same-Edge-capture-edge-aligned-DDR-input/m-p/646009#M8411
################set input_clock         VIRT_CLK;            # Name of input clock
################set input_clock_period  ${RDS_CLOCK_PERIOD}; # Period of input clock (full-period)
################set skew_bre            0.800;               # Data invalid before the rising clock edge
################set skew_are            0.800;               # Data invalid after the rising clock edge
################set skew_bfe            0.800;               # Data invalid before the falling clock edge
################set skew_afe            0.800;               # Data invalid after the falling clock edge
################set input_ports         {hb_dq[*]};          # List of input ports
################
################# Input Delay Constraint
################set_input_delay -clock $input_clock -max [expr $input_clock_period/2 + $skew_afe] [get_ports $input_ports];
################set_input_delay -clock $input_clock -min [expr $input_clock_period/2 - $skew_bfe] [get_ports $input_ports];
################set_input_delay -clock $input_clock -max [expr $input_clock_period/2 + $skew_are] [get_ports $input_ports] -clock_fall -add_delay;
################set_input_delay -clock $input_clock -min [expr $input_clock_period/2 - $skew_bre] [get_ports $input_ports] -clock_fall -add_delay;
################
################# Report Timing Template
################# report_timing -rise_from [get_ports {hb_dq[*]}] -max_paths 32 -nworst 1 -delay_type min_max -name src_sync_edge_ddr_in_rise -file src_sync_edge_ddr_in_rise.txt;
################# report_timing -fall_from [get_ports {hb_dq[*]}] -max_paths 32 -nworst 1 -delay_type min_max -name src_sync_edge_ddr_in_fall -file src_sync_edge_ddr_in_fall.txt;
################          
        


# set HB_CK "hb_ck"
# set CLOCK_SOURCE []
# create_generated_clock -name $HB_CK -source $CLOCK_SOURCE -multiply_by 1 [get_ports hb_ck]

create_generated_clock -name RPC_CK -source [get_pins ares_pb_i/ares_pb_i/rpc2_ctrl_controller_0/inst/rpc2_ctrl_io/io_oddr_ck/ODDR_inst/C] -multiply_by 1 -invert [get_ports hb_ck]

# set_output_delay -clock [get_clocks RPC_CK] -min -1.000 [get_ports {hb_dq[*]}]
# set_output_delay -clock [get_clocks RPC_CK] -max  1.000 [get_ports {hb_dq[*]}]
# set_output_delay -clock [get_clocks RPC_CK] -min -1.000 [get_ports {hb_dq[*]}] -clock_fall -add_delay
# set_output_delay -clock [get_clocks RPC_CK] -max  1.000 [get_ports {hb_dq[*]}] -clock_fall -add_delay


# set_output_delay -clock [get_clocks RPC_CK] -min -0.600 [get_ports {hb_dq[*]}]
# set_output_delay -clock [get_clocks RPC_CK] -max 0.600 [get_ports {hb_dq[*]}]
# set_output_delay -clock [get_clocks RPC_CK] -clock_fall -min -add_delay -0.600 [get_ports {hb_dq[*]}]
# set_output_delay -clock [get_clocks RPC_CK] -clock_fall -max -add_delay 0.600 [get_ports {hb_dq[*]}]





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
set fwclk        RPC_CK;     # forwarded clock name (generated using create_generated_clock at output clock port)        
set tsu_r        1.000;      # destination device setup time requirement for rising edge
set thd_r        1.000;      # destination device hold time requirement for rising edge
set tsu_f        1.000;      # destination device setup time requirement for falling edge
set thd_f        1.000;      # destination device hold time requirement for falling edge
set trce_dly_max 0.000;      # maximum board trace delay
set trce_dly_min 0.000;      # minimum board trace delay
set output_ports {hb_dq[*]}; # list of output ports

# Output Delay Constraints
set_output_delay -clock $fwclk -max [expr $trce_dly_max + $tsu_r] [get_ports $output_ports];
set_output_delay -clock $fwclk -min [expr $trce_dly_min - $thd_r] [get_ports $output_ports];
set_output_delay -clock $fwclk -max [expr $trce_dly_max + $tsu_f] [get_ports $output_ports] -clock_fall -add_delay;
set_output_delay -clock $fwclk -min [expr $trce_dly_min - $thd_f] [get_ports $output_ports] -clock_fall -add_delay;

# Report Timing Template
#report_timing -rise_to [get_ports $output_ports] -max_paths 20 -nworst 2 -delay_type min_max -name src_sync_ddr_out_rise -file src_sync_ddr_out_rise.txt;
#report_timing -fall_to [get_ports $output_ports] -max_paths 20 -nworst 2 -delay_type min_max -name src_sync_ddr_out_fall -file src_sync_ddr_out_fall.txt;
        
	


















# # #############################################################################
# # CLOCK NAME  : rds_clk
# # DESCRIPTION : RPC IP-Core receive clock on hb_rwds pin
# # FREQUENCY   : 166MHz (6.0241 ns)
# # DUTY CYCLE  : 50%
# # UNCERTAINTY : 15% of clock period.
# # #############################################################################
# set HB_RWDS "hb_rwds"
# set RDS_CLOCK_PERIOD  6.024
# create_clock -name  $HB_RWDS -period $RDS_CLOCK_PERIOD [get_ports hb_rwds]
# set_clock_uncertainty [expr 0.15 * $RDS_CLOCK_PERIOD] [get_clocks $HB_RWDS]


# # #############################################################################
# # CLOCK NAME  : hb_ck
# # DESCRIPTION : RPC IP-Core clock pin to the hyperram chip
# # FREQUENCY   : 166MHz (6.0241 ns)
# # DUTY CYCLE  : 50%
# # PHASE       : 180 Deg. (inverted)
# # UNCERTAINTY : 15% of clock period.
# # #############################################################################
# set HB_CK "hb_ck"
# set CLOCK_SOURCE [get_pins ares_pb_i/ares_pb_i/rpc2_ctrl_controller_0/inst/rpc2_ctrl_io/io_oddr_ck/ODDR_inst/C]
# create_generated_clock -name $HB_CK -source $CLOCK_SOURCE -multiply_by 1 [get_ports hb_ck]


# # #############################################################################
# # PORT NAME   : hb_cs_n
# # DESCRIPTION : RPC IP-Core chip select not
# # DIRECTION   : Output
# # SPEC PARAMs :
# #               - TCSS : 3 ns - Chip Select Setup to next CK Rising Edge
# #               - TCSH : 0 ns - Chip Select Hold After CK Falling Edge
# #                               Note : the RPC2 controler will hold at least
# #                                      for on extra clock cycle CS# low berore
# #                                      deasserting it. This value is set in
# #                                      the RPC2 register fields MTR/[R|W]CSH
# #
# # #############################################################################
# set fwclk           $HB_CK;             # forwarded clock name
# set tsu_r           3.000;              # destination device setup time. Sampled on rising edge
# set thd_r           0.000;              # destination device hold time. Sampled on falling edge
# set MTR_RW_CSH_MIN  $RDS_CLOCK_PERIOD;  # MTR/[R|W]CSH safety extra clock cycle
# set trce_dly_max    0.000;              # maximum board trace delay
# set trce_dly_min    0.000;              # minimum board trace delay
# set output_ports    {hb_cs_n};          # Name of output ports

# set_output_delay -clock $fwclk -max [expr $trce_dly_max + $tsu_r] [get_ports $output_ports];
# set_output_delay -clock $fwclk -min [expr $trce_dly_min - $thd_r] -clock_fall [get_ports $output_ports];

# set_multicycle_path -from [get_pins ares_pb_i/ares_pb_i/rpc2_ctrl_controller_0/inst/rpc2_ctrl_io/io_oddr_cs0n/ODDR_inst/C] -to [get_clocks hb_ck] 2
# set_multicycle_path -from [get_pins ares_pb_i/ares_pb_i/rpc2_ctrl_controller_0/inst/rpc2_ctrl_io/io_oddr_cs0n/ODDR_inst/C] -to [get_clocks hb_ck] -hold 1

# set_false_path -hold -from [get_pins ares_pb_i/ares_pb_i/rpc2_ctrl_controller_0/inst/rpc2_ctrl_io/io_oddr_cs0n/ODDR_inst/C] -rise_to [get_clocks hb_ck]



# # #############################################################################
# # During read data transfers, RWDS is a read data strobe with data values edge
# # aligned with the transitions of RWDS.
# #
# # Edge-Aligned Double Data Rate Source Synchronous Inputs
# # (Using a direct FF connection)
# #
# # For an edge-aligned Source Synchronous interface, the clock
# # transition occurs at the same time as the data transitions.
# # In this template, the clock is aligned with the beginning of the
# # data. The constraints below rely on the default timing
# # analysis (setup = 1/2 cycle, hold = 0 cycle).
# #
# # input            _________________________________
# # clock  _________|                                 |___________________________
# #                 |                                 |
# #         skew_bre|skew_are                 skew_bfe|skew_afe
# #         <------>|<------>                 <------>|<------>
# #        _        |        _________________        |        _________________
# # data   _XXXXXXXXXXXXXXXXX____Rise_Data____XXXXXXXXXXXXXXXXX____Fall_Data____XX
# #
# set input_clock         $HB_RWDS;           # Name of input clock
# set input_clock_period  $RDS_CLOCK_PERIOD;     # Period of input clock (full-period)
# set skew_bre            0.600;             # Data invalid before the rising clock edge
# set skew_are            0.600;             # Data invalid after the rising clock edge
# set skew_bfe            0.600;             # Data invalid before the falling clock edge
# set skew_afe            0.600;             # Data invalid after the falling clock edge
# set input_ports         {hb_dq[*]};        # List of input ports

# # Input Delay Constraint
# # Generated from the previous rising edge and sample on the first falling edge
# set MAX_DELAY [expr $input_clock_period/2 + $skew_afe]
# set MIN_DELAY [expr $input_clock_period/2 - $skew_bfe]
# set_input_delay -clock $input_clock -max $MAX_DELAY [get_ports $input_ports];
# set_input_delay -clock $input_clock -min $MIN_DELAY [get_ports $input_ports];

# # Generated from the previous falling edge and sample on the first rising edge
# set MAX_DELAY [expr $input_clock_period/2 + $skew_are]
# set MIN_DELAY [expr $input_clock_period/2 - $skew_bre]
# set_input_delay -clock $input_clock -max $MAX_DELAY [get_ports $input_ports] -clock_fall -add_delay;
# set_input_delay -clock $input_clock -min $MIN_DELAY [get_ports $input_ports] -clock_fall -add_delay;

# # Latch at the Ram block on the clock falling edge is a false path
# set_false_path -rise_from [get_clocks $input_clock] -fall_to [get_clocks $input_clock]
# # Latch at the FF stage  on the rising edge is a false path
# set_false_path -fall_from [get_clocks $input_clock] -rise_to [get_clocks $input_clock]


# # Input to the reset resynchronizer is false path
# set_false_path -to [get_cells -hierarchical -filter {NAME =~ *rpc2_ctrl_io/reset_clk90_Meta_reg}]
# set_false_path -to [get_cells -hierarchical -filter {NAME =~ *rpc2_ctrl_io/reset_clk90_reg}]




# #  Double Data Rate Source Synchronous Outputs
# #
# #  Source synchronous output interfaces can be constrained either by the max data skew
# #  relative to the generated clock or by the destination device setup/hold requirements.
# #
# #  Setup/Hold Case:
# #  Setup and hold requirements for the destination device and board trace delays are known.
# #
# # forwarded                        _________________________________
# # clock                 __________|                                 |______________
# #                                 |                                 |
# #                           tsu_r |  thd_r                    tsu_f | thd_f
# #                         <------>|<------->                <------>|<----->
# #                         ________|_________                ________|_______
# # data @ destination   XXX__________________XXXXXXXXXXXXXXXX________________XXXXX
# #
# # Example of creating generated clock at clock output port
# # create_generated_clock -name <gen_clock_name> -multiply_by 1 -source [get_pins <source_pin>] [get_ports <output_clock_port>]
# # gen_clock_name is the name of forwarded clock here. It should be used below for defining "fwclk".

# set fwclk        $HB_CK;             # forwarded clock name (generated using create_generated_clock at output clock port)
# set tsu_r        0.600;              # destination device setup time requirement for rising edge
# set thd_r        0.600;              # destination device hold time requirement for rising edge
# set tsu_f        0.600;              # destination device setup time requirement for falling edge
# set thd_f        0.600;              # destination device hold time requirement for falling edge
# set trce_dly_max 0.000;              # maximum board trace delay
# set trce_dly_min 0.000;              # minimum board trace delay
# set output_ports {hb_dq[*] hb_rwds}; # list of output ports

# # Output Delay Constraints
# set_output_delay -clock $fwclk -max [expr $trce_dly_max + $tsu_r] [get_ports $output_ports];
# set_output_delay -clock $fwclk -min [expr $trce_dly_min - $thd_r] [get_ports $output_ports];
# set_output_delay -clock $fwclk -max [expr $trce_dly_max + $tsu_f] [get_ports $output_ports] -clock_fall -add_delay;
# set_output_delay -clock $fwclk -min [expr $trce_dly_min - $thd_f] [get_ports $output_ports] -clock_fall -add_delay;


# set_false_path -from [get_pins ares_pb_i/ares_pb_i/rpc2_ctrl_controller_0/inst/rpc2_ctrl_ip/rpc2_ctrl_mem/rpc2_ctrl_mem_logic/rpc2_ctrl_core/dq_io_tri_reg/C] -to [get_ports {hb_dq[*]}]
# set_false_path -from [get_pins ares_pb_i/ares_pb_i/rpc2_ctrl_controller_0/inst/rpc2_ctrl_ip/rpc2_ctrl_mem/rpc2_ctrl_mem_logic/rpc2_ctrl_core/rwds_io_tri_reg/C] -to [get_ports hb_rwds]



set_false_path -to [get_pins ares_pb_i/ares_pb_i/rpc2_ctrl_controller_0/inst/rpc2_ctrl_io/reset_clk90_Meta_reg/PRE]
set_false_path -to [get_pins ares_pb_i/ares_pb_i/rpc2_ctrl_controller_0/inst/rpc2_ctrl_io/reset_clk90_reg/PRE]

# To trick the router (hold time fix)
#set_max_delay -from [get_clocks VIRT_CLK] -to [get_clocks RDS_CLK] 7.5
