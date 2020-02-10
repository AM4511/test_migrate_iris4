
# Loading additional proc with user specified bodies to compute parameter values.
source [file join [file dirname [file dirname [info script]]] gui/xgs12m_remapper_v3_0.gtcl]

# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "C_NROF_DATACONN" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "C_S_AXIS_TDATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_M_AXIS_TDATA_WIDTH" -parent ${Page_0}


}

proc update_PARAM_VALUE.C_S_AXIS_TDATA_WIDTH { PARAM_VALUE.C_S_AXIS_TDATA_WIDTH PARAM_VALUE.C_NROF_DATACONN PARAM_VALUE.C_INPUT_DATAWIDTH } {
	# Procedure called to update C_S_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
	
	set C_S_AXIS_TDATA_WIDTH ${PARAM_VALUE.C_S_AXIS_TDATA_WIDTH}
	set C_NROF_DATACONN ${PARAM_VALUE.C_NROF_DATACONN}
	set C_INPUT_DATAWIDTH ${PARAM_VALUE.C_INPUT_DATAWIDTH}
	set values(C_NROF_DATACONN) [get_property value $C_NROF_DATACONN]
	set values(C_INPUT_DATAWIDTH) [get_property value $C_INPUT_DATAWIDTH]
	set_property value [gen_USERPARAMETER_C_S_AXIS_TDATA_WIDTH_VALUE $values(C_NROF_DATACONN) $values(C_INPUT_DATAWIDTH)] $C_S_AXIS_TDATA_WIDTH
}

proc validate_PARAM_VALUE.C_S_AXIS_TDATA_WIDTH { PARAM_VALUE.C_S_AXIS_TDATA_WIDTH } {
	# Procedure called to validate C_S_AXIS_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_AXIS_TDEST_WIDTH { PARAM_VALUE.C_AXIS_TDEST_WIDTH } {
	# Procedure called to update C_AXIS_TDEST_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXIS_TDEST_WIDTH { PARAM_VALUE.C_AXIS_TDEST_WIDTH } {
	# Procedure called to validate C_AXIS_TDEST_WIDTH
	return true
}

proc update_PARAM_VALUE.C_AXIS_TID_WIDTH { PARAM_VALUE.C_AXIS_TID_WIDTH } {
	# Procedure called to update C_AXIS_TID_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXIS_TID_WIDTH { PARAM_VALUE.C_AXIS_TID_WIDTH } {
	# Procedure called to validate C_AXIS_TID_WIDTH
	return true
}

proc update_PARAM_VALUE.C_INPUT_DATAWIDTH { PARAM_VALUE.C_INPUT_DATAWIDTH } {
	# Procedure called to update C_INPUT_DATAWIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_INPUT_DATAWIDTH { PARAM_VALUE.C_INPUT_DATAWIDTH } {
	# Procedure called to validate C_INPUT_DATAWIDTH
	return true
}

proc update_PARAM_VALUE.C_M_AXIS_TDATA_WIDTH { PARAM_VALUE.C_M_AXIS_TDATA_WIDTH } {
	# Procedure called to update C_M_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXIS_TDATA_WIDTH { PARAM_VALUE.C_M_AXIS_TDATA_WIDTH } {
	# Procedure called to validate C_M_AXIS_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M_AXIS_TUSER_WIDTH { PARAM_VALUE.C_M_AXIS_TUSER_WIDTH } {
	# Procedure called to update C_M_AXIS_TUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXIS_TUSER_WIDTH { PARAM_VALUE.C_M_AXIS_TUSER_WIDTH } {
	# Procedure called to validate C_M_AXIS_TUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_NROF_DATACONN { PARAM_VALUE.C_NROF_DATACONN } {
	# Procedure called to update C_NROF_DATACONN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_NROF_DATACONN { PARAM_VALUE.C_NROF_DATACONN } {
	# Procedure called to validate C_NROF_DATACONN
	return true
}

proc update_PARAM_VALUE.C_OUTPUT_DATAWIDTH { PARAM_VALUE.C_OUTPUT_DATAWIDTH } {
	# Procedure called to update C_OUTPUT_DATAWIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_OUTPUT_DATAWIDTH { PARAM_VALUE.C_OUTPUT_DATAWIDTH } {
	# Procedure called to validate C_OUTPUT_DATAWIDTH
	return true
}

proc update_PARAM_VALUE.C_PLATFORM { PARAM_VALUE.C_PLATFORM } {
	# Procedure called to update C_PLATFORM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_PLATFORM { PARAM_VALUE.C_PLATFORM } {
	# Procedure called to validate C_PLATFORM
	return true
}

proc update_PARAM_VALUE.C_S_AXIS_TUSER_WIDTH { PARAM_VALUE.C_S_AXIS_TUSER_WIDTH } {
	# Procedure called to update C_S_AXIS_TUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXIS_TUSER_WIDTH { PARAM_VALUE.C_S_AXIS_TUSER_WIDTH } {
	# Procedure called to validate C_S_AXIS_TUSER_WIDTH
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


proc update_MODELPARAM_VALUE.C_PLATFORM { MODELPARAM_VALUE.C_PLATFORM PARAM_VALUE.C_PLATFORM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_PLATFORM}] ${MODELPARAM_VALUE.C_PLATFORM}
}

proc update_MODELPARAM_VALUE.C_NROF_DATACONN { MODELPARAM_VALUE.C_NROF_DATACONN PARAM_VALUE.C_NROF_DATACONN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_NROF_DATACONN}] ${MODELPARAM_VALUE.C_NROF_DATACONN}
}

proc update_MODELPARAM_VALUE.C_INPUT_DATAWIDTH { MODELPARAM_VALUE.C_INPUT_DATAWIDTH PARAM_VALUE.C_INPUT_DATAWIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_INPUT_DATAWIDTH}] ${MODELPARAM_VALUE.C_INPUT_DATAWIDTH}
}

proc update_MODELPARAM_VALUE.C_OUTPUT_DATAWIDTH { MODELPARAM_VALUE.C_OUTPUT_DATAWIDTH PARAM_VALUE.C_OUTPUT_DATAWIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_OUTPUT_DATAWIDTH}] ${MODELPARAM_VALUE.C_OUTPUT_DATAWIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.C_S_AXIS_TDATA_WIDTH PARAM_VALUE.C_S_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_S_AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_AXIS_TID_WIDTH { MODELPARAM_VALUE.C_AXIS_TID_WIDTH PARAM_VALUE.C_AXIS_TID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXIS_TID_WIDTH}] ${MODELPARAM_VALUE.C_AXIS_TID_WIDTH}
}

proc update_MODELPARAM_VALUE.C_AXIS_TDEST_WIDTH { MODELPARAM_VALUE.C_AXIS_TDEST_WIDTH PARAM_VALUE.C_AXIS_TDEST_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXIS_TDEST_WIDTH}] ${MODELPARAM_VALUE.C_AXIS_TDEST_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.C_M_AXIS_TDATA_WIDTH PARAM_VALUE.C_M_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_M_AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXIS_TUSER_WIDTH { MODELPARAM_VALUE.C_S_AXIS_TUSER_WIDTH PARAM_VALUE.C_S_AXIS_TUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXIS_TUSER_WIDTH}] ${MODELPARAM_VALUE.C_S_AXIS_TUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXIS_TUSER_WIDTH { MODELPARAM_VALUE.C_M_AXIS_TUSER_WIDTH PARAM_VALUE.C_M_AXIS_TUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXIS_TUSER_WIDTH}] ${MODELPARAM_VALUE.C_M_AXIS_TUSER_WIDTH}
}

