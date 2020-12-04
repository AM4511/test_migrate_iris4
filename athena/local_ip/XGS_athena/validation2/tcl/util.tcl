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
# Run simimulation with one test
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


#####################################################
# Run simulation with a test list
#####################################################
proc s {args} {
    .main clear

	set testlist [list 0001 0002 0003]
    set currtest 1
	
  	set ATHENA                 $::env(IRIS4)/athena
	set IP                     ${ATHENA}/local_ip/XGS_athena
     
    foreach i $testlist {  
       puts "Running runsim with test${i}"	
	   vsim -gui work.testbench work.glbl -L unisims_ver -L secureip -do "${IP}/validation/tcl/valid.do" -donotcollapsepartiallydriven -permit_unmatched_virtual_intf +TestNumber=$i -quiet -l  "test${i}_vsim.log"  -nostdout -keepstdout 
       run -all
	   if { [examine /testbench/nb_errors] != "32'h00000000"} {
	     puts "ERROR IN SIMULATION test${i}!!!"	
         set testresult_array(${currtest}) FAIL	
         incr currtest
	   }  else {
	 	 puts "SIMULATION PASSED test${i}!!!"	
         set testresult_array(${currtest}) PASS	
		 incr currtest
	   }
	   quit -sim
	}   
    
	# Print all results
	puts " "
	puts " "
    puts "---------------------------------"
    puts " Results of test list simuation  "
    puts "---------------------------------"
	set currtest 1
    foreach i $testlist {
	    puts "test${i}_result : $testresult_array(${currtest})" 
		incr currtest
	}
	
  
	
}








puts "Running : ${me}"
puts "MY PATH : ${my_path}"
puts " "
puts [helpme]


