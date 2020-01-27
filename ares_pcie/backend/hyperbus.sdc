# #############################################################################
# CLOCK NAME  : rds_clk 
# DESCRIPTION : RPC IP-Core receive clock on hb_rwds pin 
# FREQUENCY   : 166MHz (6.0241 ns)
# DUTY CYCLE  : 50%
# UNCERTAINTY : 15% of clock period.
# #############################################################################
set HB_RWDS "hb_rwds"
set RDS_CLOCK_PERIOD  6.024
create_clock -name  $HB_RWDS -period $RDS_CLOCK_PERIOD [get_ports hb_rwds]
set_clock_uncertainty [expr 0.15 * $RDS_CLOCK_PERIOD] [get_clocks $HB_RWDS]


# #############################################################################
# CLOCK NAME  : hb_ck 
# DESCRIPTION : RPC IP-Core clock pin to the hyperram chip 
# FREQUENCY   : 166MHz (6.0241 ns)
# DUTY CYCLE  : 50%
# UNCERTAINTY : 15% of clock period.
# #############################################################################
set HB_CK "hb_ck"
set CLOCK_SOURCE [get_pins ares_pb_i/ares_pb_i/rpc2_ctrl_controller_0/inst/rpc2_ctrl_io/io_oddr_ck/ODDR_inst/C]
create_generated_clock -name $HB_CK -source $CLOCK_SOURCE -multiply_by 1 [get_ports hb_ck]	   


# #############################################################################
# During read data transfers, RWDS is a read data strobe with data values edge 
# aligned with the transitions of RWDS.
#
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
set input_clock         $HB_RWDS;           # Name of input clock
set input_clock_period  $RDS_CLOCK_PERIOD;     # Period of input clock (full-period)
set skew_bre            0.600;             # Data invalid before the rising clock edge
set skew_are            0.600;             # Data invalid after the rising clock edge
set skew_bfe            0.600;             # Data invalid before the falling clock edge
set skew_afe            0.600;             # Data invalid after the falling clock edge
set input_ports         {hb_dq[*]};        # List of input ports

# Input Delay Constraint
# Generated from the previous rising edge and sample on the first falling edge 
set MAX_DELAY [expr $input_clock_period/2 + $skew_afe]
set MIN_DELAY [expr $input_clock_period/2 - $skew_bfe]
set_input_delay -clock $input_clock -max $MAX_DELAY [get_ports $input_ports];
set_input_delay -clock $input_clock -min $MIN_DELAY [get_ports $input_ports];

# Generated from the previous falling edge and sample on the first rising edge
set MAX_DELAY [expr $input_clock_period/2 + $skew_are]
set MIN_DELAY [expr $input_clock_period/2 - $skew_bre] 
set_input_delay -clock $input_clock -max $MAX_DELAY [get_ports $input_ports] -clock_fall -add_delay;
set_input_delay -clock $input_clock -min $MIN_DELAY [get_ports $input_ports] -clock_fall -add_delay;

# Latch at the Ram block on the clock falling edge is a false path
set_false_path -rise_from [get_clocks $input_clock] -fall_to [get_clocks $input_clock]
# Latch at the FF stage  on the rising edge is a false path
set_false_path -fall_from [get_clocks $input_clock] -rise_to [get_clocks $input_clock]




# Report Timing Template
#report_timing -rise_from [get_ports $input_ports] -max_paths 20 -nworst 1 -delay_type min_max -name src_sync_edge_ddr_in_rise -file src_sync_edge_ddr_in_rise.txt;
#report_timing -fall_from [get_ports $input_ports] -max_paths 20 -nworst 1 -delay_type min_max -name src_sync_edge_ddr_in_fall -file src_sync_edge_ddr_in_fall.txt;
          
       



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

set fwclk        $HB_CK;            # forwarded clock name (generated using create_generated_clock at output clock port)        
set tsu_r        0.600;              # destination device setup time requirement for rising edge
set thd_r        0.600;              # destination device hold time requirement for rising edge
set tsu_f        0.600;              # destination device setup time requirement for falling edge
set thd_f        0.600;              # destination device hold time requirement for falling edge
set trce_dly_max 0.000;              # maximum board trace delay
set trce_dly_min 0.000;              # minimum board trace delay
set output_ports {hb_dq[*] hb_rwds}; # list of output ports

# Output Delay Constraints
set_output_delay -clock $fwclk -max [expr $trce_dly_max + $tsu_r] [get_ports $output_ports];
set_output_delay -clock $fwclk -min [expr $trce_dly_min - $thd_r] [get_ports $output_ports];
set_output_delay -clock $fwclk -max [expr $trce_dly_max + $tsu_f] [get_ports $output_ports] -clock_fall -add_delay;
set_output_delay -clock $fwclk -min [expr $trce_dly_min - $thd_f] [get_ports $output_ports] -clock_fall -add_delay;

# Report Timing Template
# report_timing -rise_to [get_ports $output_ports] -max_paths 20 -nworst 2 -delay_type min_max -name src_sync_ddr_out_rise -file src_sync_ddr_out_rise.txt;
# report_timing -fall_to [get_ports $output_ports] -max_paths 20 -nworst 2 -delay_type min_max -name src_sync_ddr_out_fall -file src_sync_ddr_out_fall.txt;
        
	
	
	
	
set_false_path -to [get_cells -hierarchical -filter {NAME =~ */adr_fifo_synchronizer/rd_ptr_fx_s1_reg}]
set_false_path -to [get_cells -hierarchical -filter {NAME =~ */adr_fifo_synchronizer/wr_ptr_fx_s1_reg}]
	

set_false_path -from [get_pins ares_pb_i/ares_pb_i/rpc2_ctrl_controller_0/inst/rpc2_ctrl_ip/rpc2_ctrl_mem/rpc2_ctrl_mem_logic/rpc2_ctrl_core/dq_io_tri_reg/C] -to [get_ports {hb_dq[*]}]
set_false_path -from [get_pins ares_pb_i/ares_pb_i/rpc2_ctrl_controller_0/inst/rpc2_ctrl_ip/rpc2_ctrl_mem/rpc2_ctrl_mem_logic/rpc2_ctrl_core/rwds_io_tri_reg/C] -to [get_ports hb_rwds]
