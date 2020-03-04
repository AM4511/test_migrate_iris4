create_clock -period 2.570 -name FMC_HPC_CLK0_M2C_P -waveform {0.000 1.285} [get_ports FMC_HPC_CLK0_M2C_P]
create_clock -period 2.570 -name FMC_HPC_CLK1_M2C_P -waveform {0.000 1.285} [get_ports FMC_HPC_CLK1_M2C_P]
create_clock -period 10.000 -name PCIE_CLK_QO_P -waveform {0.000 5.000} [get_ports PCIE_CLK_QO_P]
