
create_clock -period 10.000 -name ref_clk -waveform {0.000 5.000} [get_ports ref_clk]

create_clock -period 10.000 -name pcie_clk_p -waveform {0.000 5.000} [get_ports pcie_clk_p]


create_clock -period 2.570 -name {xgs_hispi_sclk_p[0]} -waveform {0.000 1.285} [get_ports {xgs_hispi_sclk_p[0]}]
create_clock -period 2.570 -name {xgs_hispi_sclk_p[1]} -waveform {0.000 1.285} [get_ports {xgs_hispi_sclk_p[1]}]
create_clock -period 2.570 -name {xgs_hispi_sclk_p[2]} -waveform {0.000 1.285} [get_ports {xgs_hispi_sclk_p[2]}]
create_clock -period 2.570 -name {xgs_hispi_sclk_p[3]} -waveform {0.000 1.285} [get_ports {xgs_hispi_sclk_p[3]}]
create_clock -period 2.570 -name {xgs_hispi_sclk_p[4]} -waveform {0.000 1.285} [get_ports {xgs_hispi_sclk_p[4]}]
create_clock -period 2.570 -name {xgs_hispi_sclk_p[5]} -waveform {0.000 1.285} [get_ports {xgs_hispi_sclk_p[5]}]

set_false_path -from [get_ports sys_rst_n]


set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[0]}] -clock_fall -min -add_delay 1.440 [get_ports {xgs_hispi_sdata_n[*]}]
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[0]}] -clock_fall -max -add_delay 1.490 [get_ports {xgs_hispi_sdata_n[*]}]
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[0]}] -min -add_delay 1.440 [get_ports {xgs_hispi_sdata_n[*]}]
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[0]}] -max -add_delay 1.490 [get_ports {xgs_hispi_sdata_n[*]}]

set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[1]}] -clock_fall -min -add_delay 1.440 [get_ports {xgs_hispi_sdata_n[*]}]
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[1]}] -clock_fall -max -add_delay 1.490 [get_ports {xgs_hispi_sdata_n[*]}]
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[1]}] -min -add_delay 1.440 [get_ports {xgs_hispi_sdata_n[*]}]
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[1]}] -max -add_delay 1.490 [get_ports {xgs_hispi_sdata_n[*]}]

set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[2]}] -clock_fall -min -add_delay 1.440 [get_ports {xgs_hispi_sdata_n[*]}]
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[2]}] -clock_fall -max -add_delay 1.490 [get_ports {xgs_hispi_sdata_n[*]}]
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[2]}] -min -add_delay 1.440 [get_ports {xgs_hispi_sdata_n[*]}]
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[2]}] -max -add_delay 1.490 [get_ports {xgs_hispi_sdata_n[*]}]

set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[3]}] -clock_fall -min -add_delay 1.440 [get_ports {xgs_hispi_sdata_n[*]}]
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[3]}] -clock_fall -max -add_delay 1.490 [get_ports {xgs_hispi_sdata_n[*]}]
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[3]}] -min -add_delay 1.440 [get_ports {xgs_hispi_sdata_n[*]}]
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[3]}] -max -add_delay 1.490 [get_ports {xgs_hispi_sdata_n[*]}]
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[4]}] -clock_fall -min -add_delay 1.440 [get_ports {xgs_hispi_sdata_n[*]}]
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[4]}] -clock_fall -max -add_delay 1.490 [get_ports {xgs_hispi_sdata_n[*]}]
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[4]}] -min -add_delay 1.440 [get_ports {xgs_hispi_sdata_n[*]}]
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[4]}] -max -add_delay 1.490 [get_ports {xgs_hispi_sdata_n[*]}]

set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[5]}] -clock_fall -min -add_delay 1.440 [get_ports {xgs_hispi_sdata_n[*]}]
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[5]}] -clock_fall -max -add_delay 1.490 [get_ports {xgs_hispi_sdata_n[*]}]
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[5]}] -min -add_delay 1.440 [get_ports {xgs_hispi_sdata_n[*]}]
set_input_delay -clock [get_clocks {xgs_hispi_sclk_p[5]}] -max -add_delay 1.490 [get_ports {xgs_hispi_sdata_n[*]}]


