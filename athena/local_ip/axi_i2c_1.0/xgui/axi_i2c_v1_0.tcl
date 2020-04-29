# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  ipgui::add_page $IPINST -name "Page 0"

  ipgui::add_param $IPINST -name "NI_ACCESS"
  ipgui::add_param $IPINST -name "SIMULATION"
  ipgui::add_param $IPINST -name "CLOCK_STRETCHING"
  ipgui::add_param $IPINST -name "G_SYS_CLK_PERIOD"

}

proc update_PARAM_VALUE.CLOCK_STRETCHING { PARAM_VALUE.CLOCK_STRETCHING } {
	# Procedure called to update CLOCK_STRETCHING when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CLOCK_STRETCHING { PARAM_VALUE.CLOCK_STRETCHING } {
	# Procedure called to validate CLOCK_STRETCHING
	return true
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

proc update_PARAM_VALUE.G_SYS_CLK_PERIOD { PARAM_VALUE.G_SYS_CLK_PERIOD } {
	# Procedure called to update G_SYS_CLK_PERIOD when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.G_SYS_CLK_PERIOD { PARAM_VALUE.G_SYS_CLK_PERIOD } {
	# Procedure called to validate G_SYS_CLK_PERIOD
	return true
}

proc update_PARAM_VALUE.NI_ACCESS { PARAM_VALUE.NI_ACCESS } {
	# Procedure called to update NI_ACCESS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NI_ACCESS { PARAM_VALUE.NI_ACCESS } {
	# Procedure called to validate NI_ACCESS
	return true
}

proc update_PARAM_VALUE.SIMULATION { PARAM_VALUE.SIMULATION } {
	# Procedure called to update SIMULATION when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SIMULATION { PARAM_VALUE.SIMULATION } {
	# Procedure called to validate SIMULATION
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_BASEADDR { PARAM_VALUE.C_S00_AXI_BASEADDR } {
	# Procedure called to update C_S00_AXI_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_BASEADDR { PARAM_VALUE.C_S00_AXI_BASEADDR } {
	# Procedure called to validate C_S00_AXI_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_HIGHADDR { PARAM_VALUE.C_S00_AXI_HIGHADDR } {
	# Procedure called to update C_S00_AXI_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_HIGHADDR { PARAM_VALUE.C_S00_AXI_HIGHADDR } {
	# Procedure called to validate C_S00_AXI_HIGHADDR
	return true
}


proc update_MODELPARAM_VALUE.NI_ACCESS { MODELPARAM_VALUE.NI_ACCESS PARAM_VALUE.NI_ACCESS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NI_ACCESS}] ${MODELPARAM_VALUE.NI_ACCESS}
}

proc update_MODELPARAM_VALUE.SIMULATION { MODELPARAM_VALUE.SIMULATION PARAM_VALUE.SIMULATION } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SIMULATION}] ${MODELPARAM_VALUE.SIMULATION}
}

proc update_MODELPARAM_VALUE.CLOCK_STRETCHING { MODELPARAM_VALUE.CLOCK_STRETCHING PARAM_VALUE.CLOCK_STRETCHING } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CLOCK_STRETCHING}] ${MODELPARAM_VALUE.CLOCK_STRETCHING}
}

proc update_MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.G_SYS_CLK_PERIOD { MODELPARAM_VALUE.G_SYS_CLK_PERIOD PARAM_VALUE.G_SYS_CLK_PERIOD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.G_SYS_CLK_PERIOD}] ${MODELPARAM_VALUE.G_SYS_CLK_PERIOD}
}

