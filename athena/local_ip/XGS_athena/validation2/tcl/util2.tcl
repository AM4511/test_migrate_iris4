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
	a   : Run all
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

proc a {} {
    set PIXEL_WIDTH 1
    set Y_SIZE 5
    set X_SIZE_RANGE {256}
    set X_ROI_EN 1
    set X_ROI_START 1
    set X_ROI_SIZE_MIN 128
    set X_ROI_SIZE_MAX 136
    set X_REVERSE_RANGE {0 1}
    set X_SCALING 0

    set IPCORES_PATH $::env(IRIS4)/athena/local_ip
    set IP ${IPCORES_PATH}/XGS_athena

    set test_id 0

    foreach X_SIZE $X_SIZE_RANGE {
	for {set X_ROI_SIZE $X_ROI_SIZE_MIN} {$X_ROI_SIZE < $X_ROI_SIZE_MAX} {incr X_ROI_SIZE} {
	    foreach X_REVERSE $X_REVERSE_RANGE {

		set test_name  "Test${test_id}"

		set PARAMETER_LIST "-gTEST_NAME=${test_name} -gPIXEL_WIDTH=${PIXEL_WIDTH} -gY_SIZE=${Y_SIZE} -gX_SIZE=${X_SIZE} -gX_ROI_EN=${X_ROI_EN} -gX_ROI_START=${X_ROI_START} -gX_ROI_SIZE=${X_ROI_SIZE} -gX_REVERSE=${X_REVERSE} -gX_SCALING=${X_SCALING}"
		set logfile "${test_name}.log"

		puts "#############################################################################################"
		puts "## Running ${test_name}"
		puts "#############################################################################################"
		puts "Test        : $test_name"
		puts "Y_SIZE      : $Y_SIZE"
		puts "X_SIZE      : $X_SIZE"
		puts "X_ROI_START : $X_ROI_START"
		puts "X_ROI_SIZE  : $X_ROI_SIZE"
		puts "X_REVERSE   : $X_REVERSE"
		puts "X_SCALING   : $X_SCALING"

		vsim -gui work.testbench -do "${IP}/validation2/tcl/valid.do" $PARAMETER_LIST -donotcollapsepartiallydriven -permit_unmatched_virtual_intf -l ${logfile}
		run -all
		incr test_id

	    }
	}
    }
    puts "Done!"
}

