# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "AXIS_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MAX_PCIE_PAYLOAD_SIZE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NUMBER_OF_PLANE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "READ_ADDRESS_MSB" -parent ${Page_0}


}

proc update_PARAM_VALUE.AXIS_DATA_WIDTH { PARAM_VALUE.AXIS_DATA_WIDTH } {
	# Procedure called to update AXIS_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXIS_DATA_WIDTH { PARAM_VALUE.AXIS_DATA_WIDTH } {
	# Procedure called to validate AXIS_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.MAX_PCIE_PAYLOAD_SIZE { PARAM_VALUE.MAX_PCIE_PAYLOAD_SIZE } {
	# Procedure called to update MAX_PCIE_PAYLOAD_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAX_PCIE_PAYLOAD_SIZE { PARAM_VALUE.MAX_PCIE_PAYLOAD_SIZE } {
	# Procedure called to validate MAX_PCIE_PAYLOAD_SIZE
	return true
}

proc update_PARAM_VALUE.NUMBER_OF_PLANE { PARAM_VALUE.NUMBER_OF_PLANE } {
	# Procedure called to update NUMBER_OF_PLANE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NUMBER_OF_PLANE { PARAM_VALUE.NUMBER_OF_PLANE } {
	# Procedure called to validate NUMBER_OF_PLANE
	return true
}

proc update_PARAM_VALUE.READ_ADDRESS_MSB { PARAM_VALUE.READ_ADDRESS_MSB } {
	# Procedure called to update READ_ADDRESS_MSB when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.READ_ADDRESS_MSB { PARAM_VALUE.READ_ADDRESS_MSB } {
	# Procedure called to validate READ_ADDRESS_MSB
	return true
}


proc update_MODELPARAM_VALUE.NUMBER_OF_PLANE { MODELPARAM_VALUE.NUMBER_OF_PLANE PARAM_VALUE.NUMBER_OF_PLANE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NUMBER_OF_PLANE}] ${MODELPARAM_VALUE.NUMBER_OF_PLANE}
}

proc update_MODELPARAM_VALUE.READ_ADDRESS_MSB { MODELPARAM_VALUE.READ_ADDRESS_MSB PARAM_VALUE.READ_ADDRESS_MSB } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.READ_ADDRESS_MSB}] ${MODELPARAM_VALUE.READ_ADDRESS_MSB}
}

proc update_MODELPARAM_VALUE.MAX_PCIE_PAYLOAD_SIZE { MODELPARAM_VALUE.MAX_PCIE_PAYLOAD_SIZE PARAM_VALUE.MAX_PCIE_PAYLOAD_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAX_PCIE_PAYLOAD_SIZE}] ${MODELPARAM_VALUE.MAX_PCIE_PAYLOAD_SIZE}
}

proc update_MODELPARAM_VALUE.AXIS_DATA_WIDTH { MODELPARAM_VALUE.AXIS_DATA_WIDTH PARAM_VALUE.AXIS_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXIS_DATA_WIDTH}] ${MODELPARAM_VALUE.AXIS_DATA_WIDTH}
}

