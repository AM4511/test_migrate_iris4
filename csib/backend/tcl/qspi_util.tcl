exec program_flash -f D:/git/gitlab/4sightev6/miox/vivado/2018.2/bif/BOOT.bin -fsbl D:/git/gitlab/4sightev6/miox/vivado/2018.2/miox_1539894061/miox.sdk/fsbl/Debug/fsbl.elf -flash_type qspi_single -blank_check -verify -cable type xilinx_tcf url tcp:IMG-NPI-037:3121

exec program_flash -f D:/git/gitlab/4sightev6/miox/vivado/2018.2/bif/BOOT.bin -fsbl  D:/git/gitlab/4sightev6/miox/vivado/2018.2/miox_1539894061/miox.sdk/fsbl_flash_programing/Debug/fsbl_flash_programing.elf -flash_type qspi_single -blank_check -verify -cable type xilinx_tcf url tcp:IMG-NPI-037:3121

exec program_flash -f D:/git/gitlab/4sightev6/miox/vivado/2018.2/bif/BOOT.bin -fsbl  D:/git/gitlab/4sightev6/miox/vivado/2018.2/miox_1539894061/miox.sdk/fsbl_flash_programing/Debug/fsbl_flash_programing.elf -flash_type qspi_single -blank_check -verify -cable type xilinx_tcf url tcp:IMG-NPI-037:3121

exec program_flash -f D:/git/gitlab/4sightev6/miox/vivado/2018.2/bif/BOOT.bin -offset 0x0 -flash_type qspi_single -fsbl D:/git/gitlab/4sightev6/miox/vivado/2018.2/miox_1539894061/miox.sdk/fsbl/Debug/fsbl.elf -cable type xilinx_tcf url TCP:IMG-NPI-037:3121 


connect -url tcp:IMG-NPI-037:3121
connect -url tcp:4SGP-008:3121

targets
ta 2
source D:/git/gitlab/4sightev6/miox/vivado/2018.2/miox_1539894061/miox.sdk/miox_top_hw_platform_0/ps7_init.tcl
ps7_post_config

dow -data D:/git/gitlab/4sightev6/miox/vivado/2018.2/bif/BOOT.bin 0xFC000000
dow -data D:/git/gitlab/4sightev6/miox/vivado/2018.2/bif/BOOT.mcs

dow D:/git/gitlab/4sightev6/miox/vivado/2018.2/miox_1539894061/miox.sdk/fsbl/Debug/fsbl.elf




[Place 30-73] Invalid constraint on register 'xmiox_pb_wrapper/miox_pb_i/ToE_0/axi_ethernetlite_0/U0/IOFFS_GEN2.DVD_FF'. It has the property IOB=TRUE, but it is not driving or driven by any IO element.


xmiox_pb_wrapper/miox_pb_i/ToE_0/axi_ethernetlite_0/U0/IOFFS_GEN2.DVD_FF

set_property IOB FALSE [get_cells xmiox_pb_wrapper/miox_pb_i/ToE_0/axi_ethernetlite_0/U0/IOFFS_GEN2.DVD_FF]
set_property IOB FALSE [get_cells xmiox_pb_wrapper/miox_pb_i/ToE_0/axi_ethernetlite_0/U0/IOFFS_GEN2.RER_FF]
set_property IOB FALSE [get_cells xmiox_pb_wrapper/miox_pb_i/ToE_0/axi_ethernetlite_0/U0/IOFFS_GEN2.TEN_FF]
set_property IOB FALSE [get_cells xmiox_pb_wrapper/miox_pb_i/ToE_0/axi_ethernetlite_0/U0/IOFFS_GEN2.RX_FF_I]
set_property IOB FALSE [get_cells xmiox_pb_wrapper/miox_pb_i/ToE_0/axi_ethernetlite_0/U0/IOFFS_GEN2.TX_FF_I]



xmiox_pb_wrapper/miox_pb_i/ToE_0/axi_ethernetlite_0/U0/IOFFS_GEN2.RER_FF
xmiox_pb_wrapper/miox_pb_i/ToE_0/axi_ethernetlite_0/U0/IOFFS_GEN2.TEN_FF
xmiox_pb_wrapper/miox_pb_i/ToE_0/axi_ethernetlite_0/U0/IOFFS_GEN[0].RX_FF_I
xmiox_pb_wrapper/miox_pb_i/ToE_0/axi_ethernetlite_0/U0/IOFFS_GEN[0].TX_FF_I
xmiox_pb_wrapper/miox_pb_i/ToE_0/axi_ethernetlite_0/U0/IOFFS_GEN[1].RX_FF_I
xmiox_pb_wrapper/miox_pb_i/ToE_0/axi_ethernetlite_0/U0/IOFFS_GEN[1].TX_FF_I
xmiox_pb_wrapper/miox_pb_i/ToE_0/axi_ethernetlite_0/U0/IOFFS_GEN[2].RX_FF_I
xmiox_pb_wrapper/miox_pb_i/ToE_0/axi_ethernetlite_0/U0/IOFFS_GEN[2].TX_FF_I
xmiox_pb_wrapper/miox_pb_i/ToE_0/axi_ethernetlite_0/U0/IOFFS_GEN[3].RX_FF_I
xmiox_pb_wrapper/miox_pb_i/ToE_0/axi_ethernetlite_0/U0/IOFFS_GEN[3].TX_FF_I



get_cells  xmiox_pb_wrapper/miox_pb_i/ToE_0/axi_ethernetlite_0/U0/IOFFS_GEN2.RER_FF
xmiox_pb_wrapper/miox_pb_i/ToE_0/axi_ethernetlite_0/U0/IOFFS_GEN2.TEN_FF
xmiox_pb_wrapper/miox_pb_i/ToE_0/axi_ethernetlite_0/U0/IOFFS_GEN[0].RX_FF_I
xmiox_pb_wrapper/miox_pb_i/ToE_0/axi_ethernetlite_0/U0/IOFFS_GEN[0].TX_FF_I


set_property IOB FALSE [get_cells -hierarchical -filter {NAME =~*axi_ethernetlite_0/U0/IOFFS_GEN2.RER_FF}]
set_property IOB FALSE [get_cells -hierarchical -filter {NAME =~*axi_ethernetlite_0/U0/IOFFS_GEN2.TEN_FF}]
set_property IOB FALSE [get_cells -hierarchical -filter {NAME =~*axi_ethernetlite_0/U0/IOFFS_GEN[*].RX_FF_I}]
set_property IOB FALSE [get_cells -hierarchical -filter {NAME =~*axi_ethernetlite_0/U0/IOFFS_GEN[*].TX_FF_I}]

set_property IOB FALSE [get_cells -hierarchical -filter {NAME =~*axi_ethernetlite_0/U0/IOFFS_GEN2.DVD_FF}]




