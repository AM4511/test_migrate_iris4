# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0" -display_name {AXI stream slave  interface}]
  set_property tooltip {AXI stream slave  interface} ${Page_0}
  ipgui::add_param $IPINST -name "AXIS_DATA_WIDTH" -parent ${Page_0} -widget comboBox

  #Adding Page
  set AXI_master_write_interface [ipgui::add_page $IPINST -name "AXI master write interface"]
  set_property tooltip {AXI master write interface} ${AXI_master_write_interface}
  set AXI_ADDR_WIDTH [ipgui::add_param $IPINST -name "AXI_ADDR_WIDTH" -parent ${AXI_master_write_interface}]
  set_property tooltip {Set the Axi master interface address width} ${AXI_ADDR_WIDTH}
  set AXI_DATA_WIDTH [ipgui::add_param $IPINST -name "AXI_DATA_WIDTH" -parent ${AXI_master_write_interface} -widget comboBox]
  set_property tooltip {Set the Axi master interface data width} ${AXI_DATA_WIDTH}
  ipgui::add_param $IPINST -name "AXI_BURST_SIZE" -parent ${AXI_master_write_interface} -widget comboBox
  ipgui::add_param $IPINST -name "NB_DATA_ACC" -parent ${AXI_master_write_interface}


}

proc update_PARAM_VALUE.AXIS_DATA_WIDTH { PARAM_VALUE.AXIS_DATA_WIDTH } {
	# Procedure called to update AXIS_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXIS_DATA_WIDTH { PARAM_VALUE.AXIS_DATA_WIDTH } {
	# Procedure called to validate AXIS_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.AXI_ADDR_WIDTH { PARAM_VALUE.AXI_ADDR_WIDTH } {
	# Procedure called to update AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXI_ADDR_WIDTH { PARAM_VALUE.AXI_ADDR_WIDTH } {
	# Procedure called to validate AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.AXI_BURST_SIZE { PARAM_VALUE.AXI_BURST_SIZE } {
	# Procedure called to update AXI_BURST_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXI_BURST_SIZE { PARAM_VALUE.AXI_BURST_SIZE } {
	# Procedure called to validate AXI_BURST_SIZE
	return true
}

proc update_PARAM_VALUE.AXI_DATA_WIDTH { PARAM_VALUE.AXI_DATA_WIDTH } {
	# Procedure called to update AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXI_DATA_WIDTH { PARAM_VALUE.AXI_DATA_WIDTH } {
	# Procedure called to validate AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.NB_DATA_ACC { PARAM_VALUE.NB_DATA_ACC } {
	# Procedure called to update NB_DATA_ACC when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NB_DATA_ACC { PARAM_VALUE.NB_DATA_ACC } {
	# Procedure called to validate NB_DATA_ACC
	return true
}


proc update_MODELPARAM_VALUE.AXIS_DATA_WIDTH { MODELPARAM_VALUE.AXIS_DATA_WIDTH PARAM_VALUE.AXIS_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXIS_DATA_WIDTH}] ${MODELPARAM_VALUE.AXIS_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.AXI_DATA_WIDTH { MODELPARAM_VALUE.AXI_DATA_WIDTH PARAM_VALUE.AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.AXI_ADDR_WIDTH { MODELPARAM_VALUE.AXI_ADDR_WIDTH PARAM_VALUE.AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.AXI_BURST_SIZE { MODELPARAM_VALUE.AXI_BURST_SIZE PARAM_VALUE.AXI_BURST_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXI_BURST_SIZE}] ${MODELPARAM_VALUE.AXI_BURST_SIZE}
}

proc update_MODELPARAM_VALUE.NB_DATA_ACC { MODELPARAM_VALUE.NB_DATA_ACC PARAM_VALUE.NB_DATA_ACC } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NB_DATA_ACC}] ${MODELPARAM_VALUE.NB_DATA_ACC}
}

