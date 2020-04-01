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
	set IP ${IPCORES_PATH}/pcie2AxiMaster
	vsim -t fs -gui work.testbench work.glbl -L unisims_ver  -L xpm -L unimacro_ver -L secureip -L fifo_generator_v13_2_4 -do "${IP}/validation/tcl/valid.do"
	run -all
}


#####################################################
# Runsim
#####################################################
proc runsim {} {
	puts "Running runsim"
	set IPCORES_PATH $::env(IPCORES)
	set ROOT_PATH    ${IPCORES_PATH}/pcie2AxiMaster
	vsim -gui work.testbench -do "${ROOT_PATH}/validation/tcl/valid.do"
}

