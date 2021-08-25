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
	r   : Run the default simulation
	a   : Run simulation with a range of image configurations
}

    puts $message
}

#####################################################
# n : New Command
#####################################################
proc n {} {
    set IPCORES_PATH $::env(IRIS4)/athena/local_ip
    set IP ${IPCORES_PATH}/XGS_athena
    source $IP/validation2/tcl/trim/util.tcl
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
	set DEBUG 1
	
	# In debug mode run a specific configuration
    if {$DEBUG == 1} {
	set PIXEL_WIDTH 4
	set Y_SIZE 5
	set X_SIZE_RANGE {128}
    set Y_ROI_EN 1
	set Y_ROI_SIZE 3
	set Y_ROI_START 1
	set X_ROI_EN 0
	set X_ROI_START 1
	set X_ROI_SIZE_MIN 127
	set X_ROI_SIZE_MAX 128
	set X_REVERSE_RANGE {0}
	set X_SCALING_RANGE {0}
    } else {
    # In non debug mode run a range of different configurations
	set PIXEL_WIDTH 4
	set Y_SIZE 3
	set X_SIZE_RANGE {1024}
	set Y_ROI_EN 0
	set Y_ROI_SIZE 3
	set Y_ROI_START 0
	set X_ROI_EN 1
	set X_ROI_START 1
	set X_ROI_SIZE_MIN 128
	set X_ROI_SIZE_MAX 136
	set X_REVERSE_RANGE {0 1}
	set X_SCALING_RANGE {0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15}
	#set X_SCALING_RANGE {15}
    }
    set IPCORES_PATH $::env(IRIS4)/athena/local_ip
    set IP ${IPCORES_PATH}/XGS_athena

    set test_id 0

    foreach X_SIZE $X_SIZE_RANGE {
	for {set X_ROI_SIZE $X_ROI_SIZE_MIN} {$X_ROI_SIZE < $X_ROI_SIZE_MAX} {incr X_ROI_SIZE} {
	    foreach X_REVERSE $X_REVERSE_RANGE {
		foreach X_SCALING $X_SCALING_RANGE {

		    set test_name  "Test${test_id}"

		    # set PARAMETER_LIST "{-GTEST_NAME=${test_name}} -gPIXEL_WIDTH=${PIXEL_WIDTH} -gY_SIZE=${Y_SIZE} -gX_SIZE=${X_SIZE} -gX_ROI_EN=${X_ROI_EN} -gX_ROI_START=${X_ROI_START} -gX_ROI_SIZE=${X_ROI_SIZE} -gX_REVERSE=${X_REVERSE} {-GX_SCALING=${X_SCALING}}"
		    set logfile "${test_name}.log"

		    vsim -gui work.testbench -do "${IP}/validation2/tcl/valid.do" -GTEST_NAME=${test_name} -GPIXEL_WIDTH=${PIXEL_WIDTH} -GY_SIZE=${Y_SIZE} -GX_SIZE=${X_SIZE} -GX_ROI_EN=${X_ROI_EN} -GX_ROI_START=${X_ROI_START} -GX_ROI_SIZE=${X_ROI_SIZE} -GX_REVERSE=${X_REVERSE} -GX_SCALING=${X_SCALING} -GY_ROI_EN=${Y_ROI_EN} -GY_ROI_SIZE=${Y_ROI_SIZE} -GY_ROI_START=${Y_ROI_START} -donotcollapsepartiallydriven -permit_unmatched_virtual_intf -l ${logfile}
		    run -all
		    set ERR_CNT [examine /testbench/error]
		    if { [examine /testbench/error] != "32'h00000000"} {
			puts "ERR CNT : ${ERR_CNT}"
			puts "ERROR IN SIMULATION ${test_name}!!!"
			return

		    }  else {
			puts "SIMULATION PASSED ${test_name}!!!"

		    }
			if {$DEBUG == 0} {
			  quit -sim
			}
		    incr test_id

		}
	    }
	}
    }
    puts "Done!"
}
