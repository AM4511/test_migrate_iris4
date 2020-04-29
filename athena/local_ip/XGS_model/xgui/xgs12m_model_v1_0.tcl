# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "G_PXL_ARRAY_ROWS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "G_PXL_PER_COLRAM" -parent ${Page_0}


}

proc update_PARAM_VALUE.G_PXL_ARRAY_ROWS { PARAM_VALUE.G_PXL_ARRAY_ROWS } {
	# Procedure called to update G_PXL_ARRAY_ROWS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.G_PXL_ARRAY_ROWS { PARAM_VALUE.G_PXL_ARRAY_ROWS } {
	# Procedure called to validate G_PXL_ARRAY_ROWS
	return true
}

proc update_PARAM_VALUE.G_PXL_PER_COLRAM { PARAM_VALUE.G_PXL_PER_COLRAM } {
	# Procedure called to update G_PXL_PER_COLRAM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.G_PXL_PER_COLRAM { PARAM_VALUE.G_PXL_PER_COLRAM } {
	# Procedure called to validate G_PXL_PER_COLRAM
	return true
}


proc update_MODELPARAM_VALUE.G_PXL_PER_COLRAM { MODELPARAM_VALUE.G_PXL_PER_COLRAM PARAM_VALUE.G_PXL_PER_COLRAM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.G_PXL_PER_COLRAM}] ${MODELPARAM_VALUE.G_PXL_PER_COLRAM}
}

proc update_MODELPARAM_VALUE.G_PXL_ARRAY_ROWS { MODELPARAM_VALUE.G_PXL_ARRAY_ROWS PARAM_VALUE.G_PXL_ARRAY_ROWS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.G_PXL_ARRAY_ROWS}] ${MODELPARAM_VALUE.G_PXL_ARRAY_ROWS}
}

