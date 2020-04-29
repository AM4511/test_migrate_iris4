# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ENABLE_IDELAYCTRL" -parent ${Page_0}
  ipgui::add_param $IPINST -name "LINES_PER_FRAME" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MAX_PCIE_PAYLOAD_SIZE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MUX_RATIO" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NUMBER_OF_LANE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PIXELS_PER_LINE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PIXEL_SIZE" -parent ${Page_0}


}

proc update_PARAM_VALUE.ENABLE_IDELAYCTRL { PARAM_VALUE.ENABLE_IDELAYCTRL } {
	# Procedure called to update ENABLE_IDELAYCTRL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ENABLE_IDELAYCTRL { PARAM_VALUE.ENABLE_IDELAYCTRL } {
	# Procedure called to validate ENABLE_IDELAYCTRL
	return true
}

proc update_PARAM_VALUE.LINES_PER_FRAME { PARAM_VALUE.LINES_PER_FRAME } {
	# Procedure called to update LINES_PER_FRAME when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LINES_PER_FRAME { PARAM_VALUE.LINES_PER_FRAME } {
	# Procedure called to validate LINES_PER_FRAME
	return true
}

proc update_PARAM_VALUE.MAX_PCIE_PAYLOAD_SIZE { PARAM_VALUE.MAX_PCIE_PAYLOAD_SIZE } {
	# Procedure called to update MAX_PCIE_PAYLOAD_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAX_PCIE_PAYLOAD_SIZE { PARAM_VALUE.MAX_PCIE_PAYLOAD_SIZE } {
	# Procedure called to validate MAX_PCIE_PAYLOAD_SIZE
	return true
}

proc update_PARAM_VALUE.MUX_RATIO { PARAM_VALUE.MUX_RATIO } {
	# Procedure called to update MUX_RATIO when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MUX_RATIO { PARAM_VALUE.MUX_RATIO } {
	# Procedure called to validate MUX_RATIO
	return true
}

proc update_PARAM_VALUE.NUMBER_OF_LANE { PARAM_VALUE.NUMBER_OF_LANE } {
	# Procedure called to update NUMBER_OF_LANE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NUMBER_OF_LANE { PARAM_VALUE.NUMBER_OF_LANE } {
	# Procedure called to validate NUMBER_OF_LANE
	return true
}

proc update_PARAM_VALUE.PIXELS_PER_LINE { PARAM_VALUE.PIXELS_PER_LINE } {
	# Procedure called to update PIXELS_PER_LINE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PIXELS_PER_LINE { PARAM_VALUE.PIXELS_PER_LINE } {
	# Procedure called to validate PIXELS_PER_LINE
	return true
}

proc update_PARAM_VALUE.PIXEL_SIZE { PARAM_VALUE.PIXEL_SIZE } {
	# Procedure called to update PIXEL_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PIXEL_SIZE { PARAM_VALUE.PIXEL_SIZE } {
	# Procedure called to validate PIXEL_SIZE
	return true
}


proc update_MODELPARAM_VALUE.ENABLE_IDELAYCTRL { MODELPARAM_VALUE.ENABLE_IDELAYCTRL PARAM_VALUE.ENABLE_IDELAYCTRL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ENABLE_IDELAYCTRL}] ${MODELPARAM_VALUE.ENABLE_IDELAYCTRL}
}

proc update_MODELPARAM_VALUE.NUMBER_OF_LANE { MODELPARAM_VALUE.NUMBER_OF_LANE PARAM_VALUE.NUMBER_OF_LANE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NUMBER_OF_LANE}] ${MODELPARAM_VALUE.NUMBER_OF_LANE}
}

proc update_MODELPARAM_VALUE.MUX_RATIO { MODELPARAM_VALUE.MUX_RATIO PARAM_VALUE.MUX_RATIO } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MUX_RATIO}] ${MODELPARAM_VALUE.MUX_RATIO}
}

proc update_MODELPARAM_VALUE.PIXELS_PER_LINE { MODELPARAM_VALUE.PIXELS_PER_LINE PARAM_VALUE.PIXELS_PER_LINE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PIXELS_PER_LINE}] ${MODELPARAM_VALUE.PIXELS_PER_LINE}
}

proc update_MODELPARAM_VALUE.LINES_PER_FRAME { MODELPARAM_VALUE.LINES_PER_FRAME PARAM_VALUE.LINES_PER_FRAME } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LINES_PER_FRAME}] ${MODELPARAM_VALUE.LINES_PER_FRAME}
}

proc update_MODELPARAM_VALUE.PIXEL_SIZE { MODELPARAM_VALUE.PIXEL_SIZE PARAM_VALUE.PIXEL_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PIXEL_SIZE}] ${MODELPARAM_VALUE.PIXEL_SIZE}
}

proc update_MODELPARAM_VALUE.MAX_PCIE_PAYLOAD_SIZE { MODELPARAM_VALUE.MAX_PCIE_PAYLOAD_SIZE PARAM_VALUE.MAX_PCIE_PAYLOAD_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAX_PCIE_PAYLOAD_SIZE}] ${MODELPARAM_VALUE.MAX_PCIE_PAYLOAD_SIZE}
}

