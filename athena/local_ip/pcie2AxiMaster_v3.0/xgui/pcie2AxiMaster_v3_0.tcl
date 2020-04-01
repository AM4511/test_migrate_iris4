# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set PCIe [ipgui::add_page $IPINST -name "PCIe"]
  set_property tooltip {Set the PCIe parameters} ${PCIe}
  ipgui::add_param $IPINST -name "PCIE_VENDOR_ID" -parent ${PCIe}
  ipgui::add_param $IPINST -name "PCIE_DEVICE_ID" -parent ${PCIe}
  ipgui::add_param $IPINST -name "PCIE_REV_ID" -parent ${PCIe}
  ipgui::add_param $IPINST -name "PCIE_SUBSYS_VENDOR_ID" -parent ${PCIe}
  ipgui::add_param $IPINST -name "PCIE_SUBSYS_ID" -parent ${PCIe}

  #Adding Page
  set AXI [ipgui::add_page $IPINST -name "AXI"]
  ipgui::add_param $IPINST -name "AXI_ID_WIDTH" -parent ${AXI} -widget comboBox

  #Adding Page
  set Host [ipgui::add_page $IPINST -name "Host"]
  ipgui::add_param $IPINST -name "NUMB_IRQ" -parent ${Host}

  #Adding Page
  set Misc [ipgui::add_page $IPINST -name "Misc"]
  #Adding Group
  set Debug [ipgui::add_group $IPINST -name "Debug" -parent ${Misc}]
  ipgui::add_param $IPINST -name "DEBUG_OUT_WIDTH" -parent ${Debug}
  ipgui::add_param $IPINST -name "DEBUG_IN_WIDTH" -parent ${Debug}



}

proc update_PARAM_VALUE.AXI_ID_WIDTH { PARAM_VALUE.AXI_ID_WIDTH } {
	# Procedure called to update AXI_ID_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXI_ID_WIDTH { PARAM_VALUE.AXI_ID_WIDTH } {
	# Procedure called to validate AXI_ID_WIDTH
	return true
}

proc update_PARAM_VALUE.DEBUG_IN_WIDTH { PARAM_VALUE.DEBUG_IN_WIDTH } {
	# Procedure called to update DEBUG_IN_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DEBUG_IN_WIDTH { PARAM_VALUE.DEBUG_IN_WIDTH } {
	# Procedure called to validate DEBUG_IN_WIDTH
	return true
}

proc update_PARAM_VALUE.DEBUG_OUT_WIDTH { PARAM_VALUE.DEBUG_OUT_WIDTH } {
	# Procedure called to update DEBUG_OUT_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DEBUG_OUT_WIDTH { PARAM_VALUE.DEBUG_OUT_WIDTH } {
	# Procedure called to validate DEBUG_OUT_WIDTH
	return true
}

proc update_PARAM_VALUE.NUMB_IRQ { PARAM_VALUE.NUMB_IRQ } {
	# Procedure called to update NUMB_IRQ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NUMB_IRQ { PARAM_VALUE.NUMB_IRQ } {
	# Procedure called to validate NUMB_IRQ
	return true
}

proc update_PARAM_VALUE.PCIE_DEVICE_ID { PARAM_VALUE.PCIE_DEVICE_ID } {
	# Procedure called to update PCIE_DEVICE_ID when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PCIE_DEVICE_ID { PARAM_VALUE.PCIE_DEVICE_ID } {
	# Procedure called to validate PCIE_DEVICE_ID
	return true
}

proc update_PARAM_VALUE.PCIE_REV_ID { PARAM_VALUE.PCIE_REV_ID } {
	# Procedure called to update PCIE_REV_ID when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PCIE_REV_ID { PARAM_VALUE.PCIE_REV_ID } {
	# Procedure called to validate PCIE_REV_ID
	return true
}

proc update_PARAM_VALUE.PCIE_SUBSYS_ID { PARAM_VALUE.PCIE_SUBSYS_ID } {
	# Procedure called to update PCIE_SUBSYS_ID when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PCIE_SUBSYS_ID { PARAM_VALUE.PCIE_SUBSYS_ID } {
	# Procedure called to validate PCIE_SUBSYS_ID
	return true
}

proc update_PARAM_VALUE.PCIE_SUBSYS_VENDOR_ID { PARAM_VALUE.PCIE_SUBSYS_VENDOR_ID } {
	# Procedure called to update PCIE_SUBSYS_VENDOR_ID when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PCIE_SUBSYS_VENDOR_ID { PARAM_VALUE.PCIE_SUBSYS_VENDOR_ID } {
	# Procedure called to validate PCIE_SUBSYS_VENDOR_ID
	return true
}

proc update_PARAM_VALUE.PCIE_VENDOR_ID { PARAM_VALUE.PCIE_VENDOR_ID } {
	# Procedure called to update PCIE_VENDOR_ID when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PCIE_VENDOR_ID { PARAM_VALUE.PCIE_VENDOR_ID } {
	# Procedure called to validate PCIE_VENDOR_ID
	return true
}


proc update_MODELPARAM_VALUE.NUMB_IRQ { MODELPARAM_VALUE.NUMB_IRQ PARAM_VALUE.NUMB_IRQ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NUMB_IRQ}] ${MODELPARAM_VALUE.NUMB_IRQ}
}

proc update_MODELPARAM_VALUE.PCIE_VENDOR_ID { MODELPARAM_VALUE.PCIE_VENDOR_ID PARAM_VALUE.PCIE_VENDOR_ID } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PCIE_VENDOR_ID}] ${MODELPARAM_VALUE.PCIE_VENDOR_ID}
}

proc update_MODELPARAM_VALUE.PCIE_DEVICE_ID { MODELPARAM_VALUE.PCIE_DEVICE_ID PARAM_VALUE.PCIE_DEVICE_ID } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PCIE_DEVICE_ID}] ${MODELPARAM_VALUE.PCIE_DEVICE_ID}
}

proc update_MODELPARAM_VALUE.PCIE_REV_ID { MODELPARAM_VALUE.PCIE_REV_ID PARAM_VALUE.PCIE_REV_ID } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PCIE_REV_ID}] ${MODELPARAM_VALUE.PCIE_REV_ID}
}

proc update_MODELPARAM_VALUE.PCIE_SUBSYS_VENDOR_ID { MODELPARAM_VALUE.PCIE_SUBSYS_VENDOR_ID PARAM_VALUE.PCIE_SUBSYS_VENDOR_ID } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PCIE_SUBSYS_VENDOR_ID}] ${MODELPARAM_VALUE.PCIE_SUBSYS_VENDOR_ID}
}

proc update_MODELPARAM_VALUE.PCIE_SUBSYS_ID { MODELPARAM_VALUE.PCIE_SUBSYS_ID PARAM_VALUE.PCIE_SUBSYS_ID } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PCIE_SUBSYS_ID}] ${MODELPARAM_VALUE.PCIE_SUBSYS_ID}
}

proc update_MODELPARAM_VALUE.DEBUG_IN_WIDTH { MODELPARAM_VALUE.DEBUG_IN_WIDTH PARAM_VALUE.DEBUG_IN_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DEBUG_IN_WIDTH}] ${MODELPARAM_VALUE.DEBUG_IN_WIDTH}
}

proc update_MODELPARAM_VALUE.DEBUG_OUT_WIDTH { MODELPARAM_VALUE.DEBUG_OUT_WIDTH PARAM_VALUE.DEBUG_OUT_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DEBUG_OUT_WIDTH}] ${MODELPARAM_VALUE.DEBUG_OUT_WIDTH}
}

proc update_MODELPARAM_VALUE.AXI_ID_WIDTH { MODELPARAM_VALUE.AXI_ID_WIDTH PARAM_VALUE.AXI_ID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXI_ID_WIDTH}] ${MODELPARAM_VALUE.AXI_ID_WIDTH}
}

