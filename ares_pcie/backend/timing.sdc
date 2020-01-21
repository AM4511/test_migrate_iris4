create_clock -period 10.000 -name pcie_refclk -waveform {0.000 5.000} [get_ports ref_clk_100MHz]
create_clock -period 10.000 -name pcie_refclk -waveform {0.000 5.000} [get_ports pcie_sys_clk_p]


create_generated_clock -name rmii2mac_rx_clk -source [get_pins ares_pb_i/ares_pb_i/clk_wiz_0/inst/plle2_adv_inst/CLKOUT2] -divide_by 2 [get_pins ares_pb_i/ares_pb_i/mii_to_rmii_0/U0/rmii2mac_rx_clk_bi_reg/Q]
create_generated_clock -name rmii2mac_tx_clk -source [get_pins ares_pb_i/ares_pb_i/clk_wiz_0/inst/plle2_adv_inst/CLKOUT2] -divide_by 2 [get_pins ares_pb_i/ares_pb_i/mii_to_rmii_0/U0/rmii2mac_tx_clk_bi_reg/Q]
create_generated_clock -name hb_ck -source [get_pins ares_pb_i/ares_pb_i/rpc2_ctrl_controller_0/inst/rpc2_ctrl_io/io_oddr_ck/ODDR_inst/C] -divide_by 1 [get_ports hb_ck]
create_generated_clock -name hb_ck_n -source [get_pins ares_pb_i/ares_pb_i/rpc2_ctrl_controller_0/inst/rpc2_ctrl_io/io_oddr_ckn/ODDR_inst/C] -divide_by 1 -invert [get_ports hb_ck_n]


#l'horloge MCLK de la configuration est a 65MHz +/- 50%
#create_clock -name config_mclk -period 10.25 [get_nets cfgmclk]

# enlever tous les false path de resynchronisation de domaine (signaux finissant en _meta
#set_false_path -to [get_cells -hierarchical  -filter {NAME =~ *Lpc_to_AXI_prodcons*/*/*_meta_reg}]
#set_false_path -to [get_cells -hier -filter {NAME =~ *Lpc_to_AXI_prodcons*/*/dst_data_reg*}]

#le signal qui sort du Microblaze et va trigger le grab sur la clock pci ne doit pas etre clocke.
#contrainte endpoint a endpoint
#set_false_path -from [get_pins {pbgen.ares_pb_i/axi_gpio_0/U0/gpio_core_1/Dual.gpio2_Data_Out_reg[0]/C}] -to [get_pins pbgen.profinet_internal_output_meta_reg/D]
#contrainte de clock a clock
#set_false_path -from [get_clocks clk_pll_i] -to [get_clocks userclk1]
#faisons quelque chose d'hybride, au cas ou la source change de nom
#set_false_path -from [get_clocks clk_pll_i] -to [get_pins pbgen.profinet_internal_output_meta_reg/D]




# #############################################################################
# CLOCK NAME  : rds_clk 
# DESCRIPTION : RPC IP-Core receive clock on hb_rwds pin 
# FREQUENCY   : 166MHz (6.0241 ns)
# DUTY CYCLE  : 50%
# UNCERTAINTY : 15% of clock period.
# #############################################################################
set RDS_CK "rds_read_clk"
set RDS_CLOCK_PERIOD  6.024
create_clock -name  $RDS_CK -period $RDS_CLOCK_PERIOD [get_ports hb_rwds]
set_clock_uncertainty [expr 0.15 * $RDS_CLOCK_PERIOD] [get_clocks $RDS_CK]


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
set input_clock         $RDS_CK;           # Name of input clock
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





# Report Timing Template
#report_timing -rise_from [get_ports $input_ports] -max_paths 20 -nworst 1 -delay_type min_max -name src_sync_edge_ddr_in_rise -file src_sync_edge_ddr_in_rise.txt;
#report_timing -fall_from [get_ports $input_ports] -max_paths 20 -nworst 1 -delay_type min_max -name src_sync_edge_ddr_in_fall -file src_sync_edge_ddr_in_fall.txt;
          
       




# #############################################################################
# CLOCK NAME  : hb_ck 
# DESCRIPTION : RPC IP-Core clock pin to the hyperram chip 
# FREQUENCY   : 166MHz (6.0241 ns)
# DUTY CYCLE  : 50%
# UNCERTAINTY : 15% of clock period.
# #############################################################################
set RDS_CK "hb_ck"
set CLOCK_SOURCE [get_pins ares_pb_i/ares_pb_i/rpc2_ctrl_controller_0/inst/rpc2_ctrl_io/io_oddr_ck/ODDR_inst/C]
create_generated_clock -name $RDS_CK -source $CLOCK_SOURCE -multiply_by 1 [get_ports hb_ck]	   


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

set fwclk        $RDS_CK;            # forwarded clock name (generated using create_generated_clock at output clock port)        
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
        
	