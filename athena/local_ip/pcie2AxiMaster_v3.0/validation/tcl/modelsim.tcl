################################################
# Matrox Project info                          #
################################################
set PROJECT_PATH $env(MAIO)
set PROJECT_NAME  maio
    
puts "Running $PROJECT_PATH/.setup"



################################################
# Project environment variable                 #
################################################
set SNAP_PATH      $PROJECT_PATH/snap
set BACKEND_DIR    $PROJECT_PATH/backend
set VALIDATE_DIR   $PROJECT_PATH/validation
set SIM_DIR        $PROJECT_PATH/validation/mti
set MODELSIM       $PROJECT_PATH/validation/mti/modelsim.ini
set WORK_LIB       $PROJECT_PATH/validation/mti/maio.lib
set TESTBENCH      "tb"


puts ""
puts "SNAP_PATH    : $SNAP_PATH"
puts "BACKEND_DIR  : $BACKEND_DIR"
puts "MODELSIM     : $MODELSIM"
puts "VALIDATE_DIR : $VALIDATE_DIR"
puts "SIM_DIR      : $SIM_DIR"
puts "WORK_LIB     : $WORK_LIB"
puts "TESTBENCH    : $TESTBENCH"


################################################
# Go to working directory                      #
################################################
puts "Working directory : ${SIM_DIR}"
cd ${SIM_DIR}

################################################
# Map Modelsim work library                    #
################################################
vmap work ${WORK_LIB}
vsim work.${TESTBENCH}

add log -r /*
