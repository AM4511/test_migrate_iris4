# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  ipgui::add_param $IPINST -name "G_SYS_CLK_PERIOD"
  ipgui::add_param $IPINST -name "G_SIMULATION"
  ipgui::add_param $IPINST -name "G_KU706"

}

proc update_PARAM_VALUE.C_S_AXI_ADDR_WIDTH { PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to update C_S_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_ADDR_WIDTH { PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_S_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXI_DATA_WIDTH { PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to update C_S_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_DATA_WIDTH { PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to validate C_S_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.G_KU706 { PARAM_VALUE.G_KU706 } {
	# Procedure called to update G_KU706 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.G_KU706 { PARAM_VALUE.G_KU706 } {
	# Procedure called to validate G_KU706
	return true
}

proc update_PARAM_VALUE.G_SIMULATION { PARAM_VALUE.G_SIMULATION } {
	# Procedure called to update G_SIMULATION when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.G_SIMULATION { PARAM_VALUE.G_SIMULATION } {
	# Procedure called to validate G_SIMULATION
	return true
}

proc update_PARAM_VALUE.G_SYS_CLK_PERIOD { PARAM_VALUE.G_SYS_CLK_PERIOD } {
	# Procedure called to update G_SYS_CLK_PERIOD when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.G_SYS_CLK_PERIOD { PARAM_VALUE.G_SYS_CLK_PERIOD } {
	# Procedure called to validate G_SYS_CLK_PERIOD
	return true
}

proc update_PARAM_VALUE.C_S_AXI_BASEADDR { PARAM_VALUE.C_S_AXI_BASEADDR } {
	# Procedure called to update C_S_AXI_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_BASEADDR { PARAM_VALUE.C_S_AXI_BASEADDR } {
	# Procedure called to validate C_S_AXI_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_S_AXI_HIGHADDR { PARAM_VALUE.C_S_AXI_HIGHADDR } {
	# Procedure called to update C_S_AXI_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_HIGHADDR { PARAM_VALUE.C_S_AXI_HIGHADDR } {
	# Procedure called to validate C_S_AXI_HIGHADDR
	return true
}


proc update_MODELPARAM_VALUE.G_SYS_CLK_PERIOD { MODELPARAM_VALUE.G_SYS_CLK_PERIOD PARAM_VALUE.G_SYS_CLK_PERIOD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.G_SYS_CLK_PERIOD}] ${MODELPARAM_VALUE.G_SYS_CLK_PERIOD}
}

proc update_MODELPARAM_VALUE.G_SIMULATION { MODELPARAM_VALUE.G_SIMULATION PARAM_VALUE.G_SIMULATION } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.G_SIMULATION}] ${MODELPARAM_VALUE.G_SIMULATION}
}

proc update_MODELPARAM_VALUE.G_KU706 { MODELPARAM_VALUE.G_KU706 PARAM_VALUE.G_KU706 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.G_KU706}] ${MODELPARAM_VALUE.G_KU706}
}

proc update_MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH}
}

