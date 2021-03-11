# Require the MS-Windows environment variable IPCORES and MTI_LIB_XILINX_PATH
# to be defined. 
#
# source $env(IRIS4)/athena/local_ip/XGS_athena/validation2/tcl/create_modelsim_x_chopper.tcl
#
set validation_dir         validation2        

set MTI_LIB_XILINX_PATH    $env(MTI_LIB_XILINX_PATH)

set ATHENA                 $env(IRIS4)/athena
set IPCORES                ${ATHENA}/ipcores
set LOCAL_IP               ${ATHENA}/local_ip

set PROJECT_NAME           x_trim  
set ROOT_PATH              ${LOCAL_IP}/XGS_athena
set LIBRARY_NAME           ${PROJECT_NAME}.lib

set COMMON_SRC_PATH        ${IPCORES}/common/design
set VLIB_PATH              ${IPCORES}/vlib       

set XGS_MODEL_DIR           ${ATHENA}/testbench/models/XGS_model

set TESTBENCH_SRC_PATH     ${ROOT_PATH}/${validation_dir}/src
set DUT_SRC_PATH           ${ROOT_PATH}/hdl
set DMA_SRC_PATH           ${ROOT_PATH}/hdl/dma
set DATA_SRC_PATH          ${ROOT_PATH}/hdl/data
set CTRL_SRC_PATH          ${ROOT_PATH}/hdl/controller
set SYSMON_SRC_PATH        ${ROOT_PATH}/hdl/system_monitor
set REGISTERFILE_PATH      ${ROOT_PATH}/registerfile

set MODELSIM_PROJECT_NAME  ${PROJECT_NAME}
set MODELSIM_PROJECT_PATH  ${ROOT_PATH}/${validation_dir}/mti
set MODELSIM_INI           ${MODELSIM_PROJECT_PATH}/modelsim.ini

set LIBRARY_PATH           ${ROOT_PATH}/${validation_dir}/mti/${LIBRARY_NAME}
set TCL_PATH               ${ROOT_PATH}/${validation_dir}/tcl

set XILINX_IP_PATH         ${DATA_SRC_PATH}/phy   



set common_fileset [join [list  [subst { 
${COMMON_SRC_PATH}/mtx_types_pkg.vhd
${COMMON_SRC_PATH}/dualPortRamVar.vhd \
${COMMON_SRC_PATH}/mtxDCFIFO.vhd \
${COMMON_SRC_PATH}/mtxSCFIFO.vhd \
${COMMON_SRC_PATH}/round_robin.vhd \
${COMMON_SRC_PATH}/mtx_resync.vhd \
${COMMON_SRC_PATH}/axiSlave2RegFile.vhd
}
]
]
]


set dut_fileset [join [list  [subst { 
${DATA_SRC_PATH}/x_trim_streamout.vhd
${DATA_SRC_PATH}/x_trim.vhd
}
]
]
]


set testbench_fileset [join [list  [subst {
${TESTBENCH_SRC_PATH}/testbench_x_trim.sv
}
]
]
]

		
############################################################
# Create the modelsim project file
############################################################
project new $MODELSIM_PROJECT_PATH  $MODELSIM_PROJECT_NAME $LIBRARY_NAME $MODELSIM_INI 


############################################################
# Create the library
############################################################
vlib $LIBRARY_PATH
vmap ${LIBRARY_NAME}  $LIBRARY_PATH
vmap work $LIBRARY_PATH


############################################################
# Add design files
############################################################
proc add_file_set {file_set} {
    foreach filePath $file_set {
        if { [file exists $filePath ] } {
    	#puts  "Adding file $filePath"
            project addfile $filePath
        } else {
    	puts  "File does not exist $filePath"
    
        }
    }
}

#source ${VLIB_PATH}/tcl/vlib_fileset.do
add_file_set $common_fileset
add_file_set $dut_fileset
add_file_set $testbench_fileset


############################################################
# Compile all files
############################################################
project compileall


############################################################
# Find compile order and Compile files
############################################################
source $TCL_PATH/util2.tcl
