set me      [file normalize [info script]]
set my_path [file dirname $me]



#####################################################
# Help Command
#####################################################
proc helpme {} {

set message {
	Matrox validation help

	h       : Display this help
	n       : Source util.tcl
	r       : Run tests specific enabled in testbech.sv
	r 0001  : Run specific test (Here test0001)
	s       : Run all test defined in util.tcl
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
proc r {args} {
	puts "Running runsim"

  	set ATHENA                 $::env(IRIS4)/athena
	set IP                     ${ATHENA}/local_ip/XGS_athena
	
	puts "MY IP ${IP}"

    if {[llength $args] == 1} {
	  set testnumber [lindex $args 0]
      puts "Running Simulation with defined test${testnumber}"
	  vsim -gui work.testbench work.glbl -L unisims_ver -L secureip -do "${IP}/validation/tcl/valid.do" -donotcollapsepartiallydriven -permit_unmatched_virtual_intf +TestNumber=${testnumber}
    } else {
      vsim -gui work.testbench work.glbl -L unisims_ver -L secureip -do "${IP}/validation/tcl/valid.do" -donotcollapsepartiallydriven -permit_unmatched_virtual_intf 
    }

	run -all
}


proc s {args} {
    .main clear

	set testlist [list 0001 0002 0003]
	set testlistresult [list 0 0 0]
    set testnumber 0
	
  	set ATHENA                 $::env(IRIS4)/athena
	set IP                     ${ATHENA}/local_ip/XGS_athena
     
    foreach i $testlist {  
       puts "Running runsim with test${i}"	
	   vsim -gui work.testbench work.glbl -L unisims_ver -L secureip -do "${IP}/validation/tcl/valid.do" -donotcollapsepartiallydriven -permit_unmatched_virtual_intf +TestNumber=$i -quiet -l  "test${i}_vsim.log"  -nostdout -keepstdout 
       run -all
	   if { [examine /testbench/nb_errors] != "32'h00000000"} {
	     puts "ERROR IN SIMULATION test${i}!!!"	
         #set test${i}_result FAIL		 
	   }  else {
	 	 puts "SIMULATION PASSED test${i}!!!"	
		 #set test${i}_result PASS	
	   }
	   quit -sim
	   #.main clear

       #foreach i $testlist {  
	   #   puts "test${i}_result " $test${i}_result
	   # 
	   #}

    }
	
}








puts "Running : ${me}"
puts "MY PATH : ${my_path}"
puts " "
puts [helpme]


