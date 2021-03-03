# ##################################################################################
# File         : power.xdc
# Description  : XDC script used for the power analysis.
#
# Example      : source $env(IRIS4)/ares_pcie/backend/7571-00/power.xdc
#
# ##################################################################################

# All output loads set to 10pF
set_load 10.000 [all_outputs]


# Operating conditions
set_operating_conditions -ambient_temp 85.0
set_operating_conditions -board_layers 8to11
set_operating_conditions -board small
set_operating_conditions -heatsink high


