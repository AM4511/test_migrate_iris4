set me      [file normalize [info script]]
set my_path [file dirname $me]


puts "Running : ${me}"
puts "MY PATH : ${my_path}"


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
	
    set IPCORES_PATH [file normalize  $::{my_path}/../../..]

	set IP "${IPCORES_PATH}/axiHiSPi"
	puts "MY IP ${IP}"
	vsim -gui work.testbench_hispi work.glbl -L unisims_ver -L secureip -do "${IP}/validation/tcl/valid.do" -donotcollapsepartiallydriven -permit_unmatched_virtual_intf
	run -all
}
