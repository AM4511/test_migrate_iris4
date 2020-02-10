
# Loading additional proc with user specified bodies to compute parameter values.
source [file join [file dirname [file dirname [info script]]] gui/axi_xgs_hispi_deser_v2_0.gtcl]

# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0" -display_name {General parameters}]
  set_property tooltip {General parameters} ${Page_0}
  ipgui::add_param $IPINST -name "C_NROF_DATACONN" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "C_M_AXIS_TDATA_WIDTH" -parent ${Page_0}

  #Adding Page
  set Advanced [ipgui::add_page $IPINST -name "Advanced"]
  set C_SERDES_FAMILY [ipgui::add_param $IPINST -name "C_SERDES_FAMILY" -parent ${Advanced} -widget comboBox]
  set_property tooltip {FPGA Serdes Family} ${C_SERDES_FAMILY}


}

proc update_PARAM_VALUE.C_M_AXIS_TDATA_WIDTH { PARAM_VALUE.C_M_AXIS_TDATA_WIDTH PARAM_VALUE.C_NROF_DATACONN PARAM_VALUE.C_INPUT_DATAWIDTH } {
	# Procedure called to update C_M_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
	
	set C_M_AXIS_TDATA_WIDTH ${PARAM_VALUE.C_M_AXIS_TDATA_WIDTH}
	set C_NROF_DATACONN ${PARAM_VALUE.C_NROF_DATACONN}
	set C_INPUT_DATAWIDTH ${PARAM_VALUE.C_INPUT_DATAWIDTH}
	set values(C_NROF_DATACONN) [get_property value $C_NROF_DATACONN]
	set values(C_INPUT_DATAWIDTH) [get_property value $C_INPUT_DATAWIDTH]
	set_property value [gen_USERPARAMETER_C_M_AXIS_TDATA_WIDTH_VALUE $values(C_NROF_DATACONN) $values(C_INPUT_DATAWIDTH)] $C_M_AXIS_TDATA_WIDTH
}

proc validate_PARAM_VALUE.C_M_AXIS_TDATA_WIDTH { PARAM_VALUE.C_M_AXIS_TDATA_WIDTH } {
	# Procedure called to validate C_M_AXIS_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_INPUT_DATAWIDTH { PARAM_VALUE.C_INPUT_DATAWIDTH } {
	# Procedure called to update C_INPUT_DATAWIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_INPUT_DATAWIDTH { PARAM_VALUE.C_INPUT_DATAWIDTH } {
	# Procedure called to validate C_INPUT_DATAWIDTH
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

proc update_PARAM_VALUE.C_REFCLK_F { PARAM_VALUE.C_REFCLK_F } {
	# Procedure called to update C_REFCLK_F when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_REFCLK_F { PARAM_VALUE.C_REFCLK_F } {
	# Procedure called to validate C_REFCLK_F
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to update C_S00_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_S00_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to update C_S00_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to validate C_S00_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_SERDES_DATAWIDTH { PARAM_VALUE.C_SERDES_DATAWIDTH } {
	# Procedure called to update C_SERDES_DATAWIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_SERDES_DATAWIDTH { PARAM_VALUE.C_SERDES_DATAWIDTH } {
	# Procedure called to validate C_SERDES_DATAWIDTH
	return true
}

proc update_PARAM_VALUE.C_SERDES_FAMILY { PARAM_VALUE.C_SERDES_FAMILY } {
	# Procedure called to update C_SERDES_FAMILY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_SERDES_FAMILY { PARAM_VALUE.C_SERDES_FAMILY } {
	# Procedure called to validate C_SERDES_FAMILY
	return true
}

proc update_PARAM_VALUE.C_SIM { PARAM_VALUE.C_SIM } {
	# Procedure called to update C_SIM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_SIM { PARAM_VALUE.C_SIM } {
	# Procedure called to validate C_SIM
	return true
}


proc update_MODELPARAM_VALUE.C_M_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.C_M_AXIS_TDATA_WIDTH PARAM_VALUE.C_M_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_M_AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_SIM { MODELPARAM_VALUE.C_SIM PARAM_VALUE.C_SIM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_SIM}] ${MODELPARAM_VALUE.C_SIM}
}

proc update_MODELPARAM_VALUE.C_NROF_DATACONN { MODELPARAM_VALUE.C_NROF_DATACONN PARAM_VALUE.C_NROF_DATACONN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_NROF_DATACONN}] ${MODELPARAM_VALUE.C_NROF_DATACONN}
}

proc update_MODELPARAM_VALUE.C_INPUT_DATAWIDTH { MODELPARAM_VALUE.C_INPUT_DATAWIDTH PARAM_VALUE.C_INPUT_DATAWIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_INPUT_DATAWIDTH}] ${MODELPARAM_VALUE.C_INPUT_DATAWIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXIS_TUSER_WIDTH { MODELPARAM_VALUE.C_M_AXIS_TUSER_WIDTH PARAM_VALUE.C_M_AXIS_TUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXIS_TUSER_WIDTH}] ${MODELPARAM_VALUE.C_M_AXIS_TUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_SERDES_FAMILY { MODELPARAM_VALUE.C_SERDES_FAMILY PARAM_VALUE.C_SERDES_FAMILY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_SERDES_FAMILY}] ${MODELPARAM_VALUE.C_SERDES_FAMILY}
}

proc update_MODELPARAM_VALUE.C_REFCLK_F { MODELPARAM_VALUE.C_REFCLK_F PARAM_VALUE.C_REFCLK_F } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_REFCLK_F}] ${MODELPARAM_VALUE.C_REFCLK_F}
}

proc update_MODELPARAM_VALUE.C_SERDES_DATAWIDTH { MODELPARAM_VALUE.C_SERDES_DATAWIDTH PARAM_VALUE.C_SERDES_DATAWIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_SERDES_DATAWIDTH}] ${MODELPARAM_VALUE.C_SERDES_DATAWIDTH}
}

