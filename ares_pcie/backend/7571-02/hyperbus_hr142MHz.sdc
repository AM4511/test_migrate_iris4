# RDS CLK: 133 MHZ
#set RDS_CLOCK_PERIOD 7.500
#100 MHz version
#create_clock -period 10.000 -name VIRT_CLK
#create_clock -period 10.000 -name RDS_CLK [get_ports hb_rwds]

#125 MHz version
#create_clock -period 8.000 -name VIRT_CLK
#create_clock -period 8.000 -name RDS_CLK [get_ports hb_rwds]

#142.857 MHz version
# Fix tap delay set to 15
create_clock -period 7.000 -name VIRT_CLK
create_clock -period 7.000 -name RDS_CLK [get_ports hb_rwds]

set_clock_uncertainty -from [get_clocks VIRT_CLK] -to [get_clocks RDS_CLK] 0.100

#150.0 MHz version
#create_clock -period 6.667 -name VIRT_CLK
#create_clock -period 6.667 -name RDS_CLK [get_ports hb_rwds]

#166.666 MHz version
# TAP delay set to 14
#create_clock -period 6.000 -name VIRT_CLK
#create_clock -period 6.000 -name RDS_CLK [get_ports hb_rwds]

#set_clock_uncertainty -from [get_clocks VIRT_CLK] -to [get_clocks *RDS*] 0.300 j'enleve au départ, pour ne pas me nuire, car je me demande si le 0.3 améliore ou détériore le timing

#ceci est un artefact de merge, je le laisse en commentaire parce que c'est plus propre au final que mes multiples versions plus haut.
#create_clock -period ${RDS_CLOCK_PERIOD} -name VIRT_CLK
#create_clock -period ${RDS_CLOCK_PERIOD} -name RDS_CLK [get_ports hb_rwds]
#set_clock_uncertainty -from [get_clocks VIRT_CLK] -to [get_clocks RDS_CLK] 0.300


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

# Input Delay Constraint, cheating method, based on wrong clock set at 100 MHz, hence 1/2 period = 5 and input_delay = 5 +/- 0.45.
#set_input_delay -clock VIRT_CLK -max 5.450 [get_ports {hb_dq[*]}]
#set_input_delay -clock VIRT_CLK -min 4.550 [get_ports {hb_dq[*]}]
#set_input_delay -clock VIRT_CLK -clock_fall -max -add_delay 5.450 [get_ports {hb_dq[*]}]
#set_input_delay -clock VIRT_CLK -clock_fall -min -add_delay 4.550 [get_ports {hb_dq[*]}]

#cheating method, clock a 125 MHz
#set_input_delay -clock VIRT_CLK -max 4.450 [get_ports {hb_dq[*]}]
#set_input_delay -clock VIRT_CLK -min 3.550 [get_ports {hb_dq[*]}]
#set_input_delay -clock VIRT_CLK -clock_fall -max -add_delay 4.450 [get_ports {hb_dq[*]}]
#set_input_delay -clock VIRT_CLK -clock_fall -min -add_delay 3.550 [get_ports {hb_dq[*]}]

#cheating method, clock a 142.857 MHz
#set_input_delay -clock VIRT_CLK -max 3.950 [get_ports {hb_dq[*]}]
#set_input_delay -clock VIRT_CLK -min 3.050 [get_ports {hb_dq[*]}]
#set_input_delay -clock VIRT_CLK -clock_fall -max -add_delay 3.950 [get_ports {hb_dq[*]}]
#set_input_delay -clock VIRT_CLK -clock_fall -min -add_delay 3.050 [get_ports {hb_dq[*]}]

#methode propre, delai d'invalidite autour du hb_rwds
set_input_delay -clock VIRT_CLK -max 0.450 [get_ports {hb_dq[*]}]
set_input_delay -clock VIRT_CLK -min -0.450 [get_ports {hb_dq[*]}]
set_input_delay -clock VIRT_CLK -clock_fall -max -add_delay 0.450 [get_ports {hb_dq[*]}]
set_input_delay -clock VIRT_CLK -clock_fall -min -add_delay -0.450 [get_ports {hb_dq[*]}]
#methode propre, on retarde rwds pour sampler, il faut donc clocker le data de 0 ns avec la clock de 0 ns, puis enlever les paths impossibles
set_multicycle_path -from [get_clocks VIRT_CLK] -to [get_clocks RDS_CLK] 0
set_false_path -setup -rise_from [get_clocks VIRT_CLK] -fall_to [get_clocks RDS_CLK]
set_false_path -setup -fall_from [get_clocks VIRT_CLK] -rise_to [get_clocks RDS_CLK]
#methode propre, correction pour le hold
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

#set fwclk        RPC_CK;     # forwarded clock name (generated using create_generated_clock at output clock port)
#set tsu_r        1.000;      # destination device setup time requirement for rising edge
#set thd_r        1.000;      # destination device hold time requirement for rising edge
#set tsu_f        1.000;      # destination device setup time requirement for falling edge
#set thd_f        1.000;      # destination device hold time requirement for falling edge
#set trce_dly_max 0.000;      # maximum board trace delay
#set trce_dly_min 0.000;      # minimum board trace delay
#set output_ports {hb_dq[*]}; # list of output ports

# Output Delay Constraints
# le input setup et hold sur la ram varie en fonction de la requence d'operation
# a 100 MHz:
#set hbram_setup_hold 1.000
# a 133 MHz:
#set hbram_setup_hold 0.800
# a 166 MHz:
set_output_delay -clock RPC_CK -max 0.600 [get_ports {{hb_dq[*]} hb_rwds}]
set_output_delay -clock RPC_CK -min -0.600 [get_ports {{hb_dq[*]} hb_rwds}]
set_output_delay -clock RPC_CK -clock_fall -max -add_delay 0.600 [get_ports {{hb_dq[*]} hb_rwds}]
set_output_delay -clock RPC_CK -clock_fall -min -add_delay -0.600 [get_ports {{hb_dq[*]} hb_rwds}]

# RDS_CLK est la strobe utilise en input. Elle ne doit pas etre utilise pour clocker sa propre pin
set_false_path -from [get_clocks RDS_CLK] -to [get_ports hb_rwds]

# Report Timing Template
#report_timing -rise_to [get_ports $output_ports] -max_paths 20 -nworst 2 -delay_type min_max -name src_sync_ddr_out_rise -file src_sync_ddr_out_rise.txt;
#report_timing -fall_to [get_ports $output_ports] -max_paths 20 -nworst 2 -delay_type min_max -name src_sync_ddr_out_fall -file src_sync_ddr_out_fall.txt;



# Exceptions
set_false_path -to [get_pins ares_pb_i/ares_pb_i/rpc2_ctrl_controller_0/inst/rpc2_ctrl_io/reset_clk90_Meta_reg/PRE]
set_false_path -to [get_pins ares_pb_i/ares_pb_i/rpc2_ctrl_controller_0/inst/rpc2_ctrl_io/reset_clk90_reg/PRE]

# Max delay to the input fifo write_enable pin
set_max_delay -from [get_pins ares_pb_i/ares_pb_i/rpc2_ctrl_controller_0/inst/rpc2_ctrl_ip/rpc2_ctrl_mem/rpc2_ctrl_mem_logic/rpc2_ctrl_core/rds_valid_delayed_reg/C] 1.500






