create_clock -period 10.000 -name pcie_refclk -waveform {0.000 5.000} [get_ports ref_clk_100MHz]
create_clock -period 10.000 -name pcie_refclk -waveform {0.000 5.000} [get_ports pcie_sys_clk_p]
 