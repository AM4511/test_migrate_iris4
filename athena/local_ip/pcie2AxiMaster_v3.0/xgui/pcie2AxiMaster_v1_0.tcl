# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set PCIe [ipgui::add_page $IPINST -name "PCIe"]
  set PCIE_VENDOR_ID [ipgui::add_param $IPINST -name "PCIE_VENDOR_ID" -parent ${PCIe}]
  set_property tooltip {Pcie Vendor ID (Matrox = 0x102b)} ${PCIE_VENDOR_ID}
  ipgui::add_param $IPINST -name "PCIE_SUBSYS_ID" -parent ${PCIe}
  ipgui::add_param $IPINST -name "PCIE_SUBSYS_VENDOR_ID" -parent ${PCIe}
  ipgui::add_param $IPINST -name "PCIE_REV_ID" -parent ${PCIe}
  ipgui::add_param $IPINST -name "PCIE_DEVICE_ID" -parent ${PCIe}

  #Adding Page
  set Interrupts [ipgui::add_page $IPINST -name "Interrupts"]
  set_property tooltip {Configure the host interrupts} ${Interrupts}
  set NUMB_IRQ [ipgui::add_param $IPINST -name "NUMB_IRQ" -parent ${Interrupts}]
  set_property tooltip {Select the number of Interrupt request signals} ${NUMB_IRQ}

  #Adding Page
  set Debug [ipgui::add_page $IPINST -name "Debug"]
  set_property tooltip {Enable the debug interface} ${Debug}
  set DEBUG_IN_WIDTH [ipgui::add_param $IPINST -name "DEBUG_IN_WIDTH" -parent ${Debug}]
  set_property tooltip {set the input signal bus width} ${DEBUG_IN_WIDTH}
  set DEBUG_OUT_WIDTH [ipgui::add_param $IPINST -name "DEBUG_OUT_WIDTH" -parent ${Debug}]
  set_property tooltip {Set the output signal bus width} ${DEBUG_OUT_WIDTH}


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

