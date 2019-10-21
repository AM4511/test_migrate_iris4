#Implementation physical constraints

# The following constraints patch bad constraint6s defined in the axi_ethernetlite
#set_property IOB false [get_cells -hierarchical -filter {NAME =~*axi_ethernetlite*RX_FF_I}]
#set_property IOB false [get_cells -hierarchical -filter {NAME =~*axi_ethernetlite*TX_FF_I}]
#set_property IOB false [get_cells -hierarchical -filter {NAME =~*axi_ethernetlite*DVD_FF}]
#set_property IOB false [get_cells -hierarchical -filter {NAME =~*axi_ethernetlite*RER_FF}]
#set_property IOB false [get_cells -hierarchical -filter {NAME =~*axi_ethernetlite*TEN_FF}]


## Configuration voltage
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]






