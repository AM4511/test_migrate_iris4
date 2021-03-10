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
	set IPCORES_PATH $::env(IRIS4)/athena/local_ip
	set IP ${IPCORES_PATH}/XGS_athena
	vsim -gui work.testbench -do "${IP}/validation2/tcl/valid.do" -donotcollapsepartiallydriven -permit_unmatched_virtual_intf
	run -all
}

