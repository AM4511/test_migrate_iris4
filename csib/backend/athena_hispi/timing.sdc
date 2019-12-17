create_clock -period 10.000 -name pcie_sys_clk_p -waveform {0.000 5.000} [get_ports pcie_sys_clk_p]

create_clock -period 10.000 -name ref_clk -waveform {0.000 5.000} [get_ports ref_clk]

create_clock -period 2.571 -name hispi_serial_clk_p_0 -waveform {0.000 1.286} [get_ports hispi_serial_clk_p_0[0]]
create_clock -period 2.571 -name hispi_serial_clk_p_1 -waveform {0.000 1.286} [get_ports hispi_serial_clk_p_0[1]]
create_clock -period 2.571 -name hispi_serial_clk_p_2 -waveform {0.000 1.286} [get_ports hispi_serial_clk_p_0[2]]
create_clock -period 2.571 -name hispi_serial_clk_p_3 -waveform {0.000 1.286} [get_ports hispi_serial_clk_p_0[3]]
create_clock -period 2.571 -name hispi_serial_clk_p_4 -waveform {0.000 1.286} [get_ports hispi_serial_clk_p_0[4]]
create_clock -period 2.571 -name hispi_serial_clk_p_5 -waveform {0.000 1.286} [get_ports hispi_serial_clk_p_0[5]]
 