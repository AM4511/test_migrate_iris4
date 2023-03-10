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
	
  	set ATHENA                 $::env(IRIS4)/athena
	set IP                     ${ATHENA}/local_ip/dmawr2tlp
	
	puts "MY IP ${IP}"
	#vsim -gui work.testbench_dmawr2tlp work.glbl -L unisims_ver -L secureip -do "${IP}/validation/tcl/valid.do" -donotcollapsepartiallydriven -permit_unmatched_virtual_intf
	vsim -gui work.testbench_dmawr2tlp  -do "${IP}/validation/tcl/valid.do" -donotcollapsepartiallydriven -permit_unmatched_virtual_intf
	run -all
}
