

# Center-Aligned Double Data Rate Source Synchronous Inputs
#
# For a center-aligned Source Synchronous interface, the clock
# transition is aligned with the center of the data valid window.
# The same clock edge is used for launching and capturing the
# data. The constraints below rely on the default timing
# analysis (setup = 1/2 cycle, hold = 0 cycle).
#
# input                  ____________________
# clock    _____________|                    |_____________
#                       |                    |
#                dv_bre | dv_are      dv_bfe | dv_afe
#               <------>|<------>    <------>|<------>
#          _    ________|________    ________|________    _
# data     _XXXX____Rise_Data____XXXX____Fall_Data____XXXX_
#




# ##############################################################
# HiSPI PHY 0
# ##############################################################

# Input Delay Constraint


# ##############################################################
# HiSPI PHY 1
# ##############################################################

# Input Delay Constraint

# ##############################################################
# HiSPI PHY 2
# ##############################################################

# Input Delay Constraint


# ##############################################################
# HiSPI PHY 3
# ##############################################################

# Input Delay Constraint


# ##############################################################
# HiSPI PHY 4
# ##############################################################

# Input Delay Constraint


# ##############################################################
# HiSPI PHY 5
# ##############################################################

# Input Delay Constraint


# Report Timing Template
#report_timing -rise_from [get_ports $hispi_input] -max_paths 20 -nworst 2 -delay_type min_max -name src_sync_cntr_ddr_in_rise  -file src_sync_cntr_ddr_in_rise.txt;
#report_timing -fall_from [get_ports $hispi_input] -max_paths 20 -nworst 2 -delay_type min_max -name src_sync_cntr_ddr_in_fall  -file src_sync_cntr_ddr_in_fall.txt;



