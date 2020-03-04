set me  [file normalize [info script]]
puts "Running : ${me}"

#####################################################
# Help Command
#####################################################
proc h {} {

set message {
	Matrox validation help

	h   : Display this help
	n   : Source util.tcl
	r   : Run the full simulation
}

puts $message
}

#####################################################
# n : New Command
#####################################################
proc n {} {
	source  $::me
}

#####################################################
# Runsim
#####################################################
proc r {} {
	puts "Running runsim"
	set IPCORES_PATH $::env(IPCORES)
	set IP ${IPCORES_PATH}/axiHiSPi
	vsim -gui work.testbench_hispi work.glbl -L unisims_ver -L secureip -do "${IP}/validation/tcl/valid.do" -donotcollapsepartiallydriven -permit_unmatched_virtual_intf
	run -all
}
