
# Loading additional proc with user specified bodies to compute parameter values.
source [file join [file dirname [file dirname [info script]]] gui/XGS_athena_v1_0.gtcl]

# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Controller [ipgui::add_page $IPINST -name "Controller" -display_name {XGS_Controller}]
  set_property tooltip {XGS controller configuration} ${Controller}
  set SYS_CLK_PERIOD [ipgui::add_param $IPINST -name "SYS_CLK_PERIOD" -parent ${Controller}]
  set_property tooltip {Set the system clock period (units in ns)} ${SYS_CLK_PERIOD}
  set SENSOR_FREQ [ipgui::add_param $IPINST -name "SENSOR_FREQ" -parent ${Controller}]
  set_property tooltip {Sensor frequency (units in KHz)} ${SENSOR_FREQ}

  #Adding Page
  set DMA [ipgui::add_page $IPINST -name "DMA"]
  set_property tooltip {DMA controller configuration} ${DMA}
  ipgui::add_param $IPINST -name "MAX_PCIE_PAYLOAD_SIZE" -parent ${DMA} -widget comboBox

  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0" -display_name {HiSPi}]
  set_property tooltip {HiSPi interface configuration} ${Page_0}
  set NUMBER_OF_LANE [ipgui::add_param $IPINST -name "NUMBER_OF_LANE" -parent ${Page_0} -widget comboBox]
  set_property tooltip {Number of physical lanes connected on the board} ${NUMBER_OF_LANE}
  set BOOL_ENABLE_IDELAYCTRL [ipgui::add_param $IPINST -name "BOOL_ENABLE_IDELAYCTRL" -parent ${Page_0}]
  set_property tooltip {Instantiate the Xilinx  Idelayctrl IP-Core} ${BOOL_ENABLE_IDELAYCTRL}


}

proc update_PARAM_VALUE.ENABLE_IDELAYCTRL { PARAM_VALUE.ENABLE_IDELAYCTRL PARAM_VALUE.BOOL_ENABLE_IDELAYCTRL } {
	# Procedure called to update ENABLE_IDELAYCTRL when any of the dependent parameters in the arguments change
	
	set ENABLE_IDELAYCTRL ${PARAM_VALUE.ENABLE_IDELAYCTRL}
	set BOOL_ENABLE_IDELAYCTRL ${PARAM_VALUE.BOOL_ENABLE_IDELAYCTRL}
	set values(BOOL_ENABLE_IDELAYCTRL) [get_property value $BOOL_ENABLE_IDELAYCTRL]
	set_property value [gen_USERPARAMETER_ENABLE_IDELAYCTRL_VALUE $values(BOOL_ENABLE_IDELAYCTRL)] $ENABLE_IDELAYCTRL
}

proc validate_PARAM_VALUE.ENABLE_IDELAYCTRL { PARAM_VALUE.ENABLE_IDELAYCTRL } {
	# Procedure called to validate ENABLE_IDELAYCTRL
	return true
}

proc update_PARAM_VALUE.BOOL_ENABLE_IDELAYCTRL { PARAM_VALUE.BOOL_ENABLE_IDELAYCTRL } {
	# Procedure called to update BOOL_ENABLE_IDELAYCTRL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BOOL_ENABLE_IDELAYCTRL { PARAM_VALUE.BOOL_ENABLE_IDELAYCTRL } {
	# Procedure called to validate BOOL_ENABLE_IDELAYCTRL
	return true
}

proc update_PARAM_VALUE.MAX_PCIE_PAYLOAD_SIZE { PARAM_VALUE.MAX_PCIE_PAYLOAD_SIZE } {
	# Procedure called to update MAX_PCIE_PAYLOAD_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAX_PCIE_PAYLOAD_SIZE { PARAM_VALUE.MAX_PCIE_PAYLOAD_SIZE } {
	# Procedure called to validate MAX_PCIE_PAYLOAD_SIZE
	return true
}

proc update_PARAM_VALUE.NUMBER_OF_LANE { PARAM_VALUE.NUMBER_OF_LANE } {
	# Procedure called to update NUMBER_OF_LANE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NUMBER_OF_LANE { PARAM_VALUE.NUMBER_OF_LANE } {
	# Procedure called to validate NUMBER_OF_LANE
	return true
}

proc update_PARAM_VALUE.SENSOR_FREQ { PARAM_VALUE.SENSOR_FREQ } {
	# Procedure called to update SENSOR_FREQ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SENSOR_FREQ { PARAM_VALUE.SENSOR_FREQ } {
	# Procedure called to validate SENSOR_FREQ
	return true
}

proc update_PARAM_VALUE.SIMULATION { PARAM_VALUE.SIMULATION } {
	# Procedure called to update SIMULATION when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SIMULATION { PARAM_VALUE.SIMULATION } {
	# Procedure called to validate SIMULATION
	return true
}

proc update_PARAM_VALUE.SYS_CLK_PERIOD { PARAM_VALUE.SYS_CLK_PERIOD } {
	# Procedure called to update SYS_CLK_PERIOD when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SYS_CLK_PERIOD { PARAM_VALUE.SYS_CLK_PERIOD } {
	# Procedure called to validate SYS_CLK_PERIOD
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

proc update_MODELPARAM_VALUE.MAX_PCIE_PAYLOAD_SIZE { MODELPARAM_VALUE.MAX_PCIE_PAYLOAD_SIZE PARAM_VALUE.MAX_PCIE_PAYLOAD_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAX_PCIE_PAYLOAD_SIZE}] ${MODELPARAM_VALUE.MAX_PCIE_PAYLOAD_SIZE}
}

proc update_MODELPARAM_VALUE.SYS_CLK_PERIOD { MODELPARAM_VALUE.SYS_CLK_PERIOD PARAM_VALUE.SYS_CLK_PERIOD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SYS_CLK_PERIOD}] ${MODELPARAM_VALUE.SYS_CLK_PERIOD}
}

proc update_MODELPARAM_VALUE.SENSOR_FREQ { MODELPARAM_VALUE.SENSOR_FREQ PARAM_VALUE.SENSOR_FREQ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SENSOR_FREQ}] ${MODELPARAM_VALUE.SENSOR_FREQ}
}

proc update_MODELPARAM_VALUE.SIMULATION { MODELPARAM_VALUE.SIMULATION PARAM_VALUE.SIMULATION } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SIMULATION}] ${MODELPARAM_VALUE.SIMULATION}
}

