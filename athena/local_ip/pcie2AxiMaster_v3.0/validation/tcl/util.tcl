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
	set IRIS4        $::env(IRIS4)
	set LOCAL_IP_DIR ${IRIS4}/local_ip
	set IPCORES_DIR  ${IRIS4}/ipcores
	set IP           ${LOCAL_IP_DIR}/pcie2AxiMaster_v3.0
	
	vsim -t fs -gui work.testbench work.glbl -L unisims_ver  -L xpm -L unimacro_ver -L secureip -L fifo_generator_v13_2_4 -do "${IP}/validation/tcl/valid.do"
	run -all
}


#####################################################
# Runsim
#####################################################
proc runsim {} {
	puts "Running runsim"
	set IRIS4        $::env(IRIS4)
	set LOCAL_IP_DIR ${IRIS4}/local_ip
	set IPCORES_DIR  ${IRIS4}/ipcores
	set IP           ${LOCAL_IP_DIR}/pcie2AxiMaster_v3.0
	

	vsim -gui work.testbench -do "${IP}/validation/tcl/valid.do"
}

