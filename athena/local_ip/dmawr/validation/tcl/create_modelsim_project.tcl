# Require the MS-Windows environment variable IPCORES and MTI_LIB_XILINX_PATH
# to be defined. 
#
# source $env(IPCORES)/axiHiSPi/validation/tcl/create_modelsim_project.tcl
#
set IPCORES              $env(IPCORES)
set IPCORES              $env(IRIS4)/athena/ipcores
set MTI_LIB_XILINX_PATH  $env(MTI_LIB_XILINX_PATH)
set MTI_LIB_ALTERA_PATH  $env(MTI_LIB_ALTERA_PATH)

set PROJECT_NAME  axiHiSPi  
set ROOT_PATH     ${IPCORES}/axiHiSPi
set LIBRARY_NAME  ${PROJECT_NAME}.lib

set COMMON_SRC_PATH        ${IPCORES}/common/design
set INTERFACES_SRC_PATH    ${IPCORES}/interfaces/sv
set VLIB_PATH              ${IPCORES}/vlib       

set TESTBENCH_SRC_PATH     ${ROOT_PATH}/validation/src
set TEST_PATH              ${ROOT_PATH}/validation/tests
set DUT_SRC_PATH           ${ROOT_PATH}/design

set MODELSIM_PROJECT_NAME  "${PROJECT_NAME}"
set MODELSIM_PROJECT_PATH  ${ROOT_PATH}/validation/mti
set MODELSIM_INI           ${MODELSIM_PROJECT_PATH}/modelsim.ini

set LIBRARY_PATH           ${ROOT_PATH}/validation/mti/${LIBRARY_NAME}
set TCL_PATH               ${ROOT_PATH}/validation/tcl

set INTEL_IP_PATH          ${DUT_SRC_PATH}/phy/intel   
set XILINX_IP_PATH         ${DUT_SRC_PATH}/phy/xilinx   

# INTEL SERDES
# set technology_specific_fileset [join [list  [subst {
# ${INTEL_IP_PATH}/hispi_phy_altera.vhd
# }
# ]
# ]
# ]

set technology_specific_fileset [join [list  [subst {
${XILINX_IP_PATH}/hispi_phy_xilinx/hispi_phy_xilinx_selectio_wiz.v
${XILINX_IP_PATH}/hispi_phy_xilinx/hispi_phy_xilinx.v
${XILINX_IP_PATH}/hispi_serdes.vhd
}
]
]
]

set dut_fileset [join [list  [subst { 
${COMMON_SRC_PATH}/mtx_types_pkg.vhd
${COMMON_SRC_PATH}/dualPortRamVar.vhd
${COMMON_SRC_PATH}/mtxDCFIFO.vhd
${COMMON_SRC_PATH}/mtxSCFIFO.vhd
${COMMON_SRC_PATH}/round_robin.vhd
${COMMON_SRC_PATH}/axiSlave2RegFile.vhd
${DUT_SRC_PATH}/hispi_pack.vhd
${DUT_SRC_PATH}/hispi_registerfile.vhd
${DUT_SRC_PATH}/lane_decoder.vhd
${DUT_SRC_PATH}/hispi_phy.vhd
${DUT_SRC_PATH}/lane_packer.vhd
${DUT_SRC_PATH}/line_buffer.vhd
${DUT_SRC_PATH}/axi_line_streamer.vhd
${DUT_SRC_PATH}/hispi_top.vhd
${DUT_SRC_PATH}/axiHiSPi.vhd
}
]
]
]

set testbench_fileset [join [list  [subst {
${TESTBENCH_SRC_PATH}/hispi_interface.sv
${TESTBENCH_SRC_PATH}/hispi_pkg.sv	
${TESTBENCH_SRC_PATH}/hispi_registerfile.sv		
${TEST_PATH}/tests_pkg.sv
${TESTBENCH_SRC_PATH}/testbench_hispi.sv
${TESTBENCH_SRC_PATH}/glbl.v
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

vmap unisims_ver ${MTI_LIB_XILINX_PATH}/unisims_ver
vmap secureip    ${MTI_LIB_XILINX_PATH}/secureip
vmap xpm         ${MTI_LIB_XILINX_PATH}/xpm

#vmap altera_mf ${MTI_LIB_ALTERA_PATH}/altera_mf

############################################################
# Add design files
############################################################{*}$testbench_fileset {*}$testlist_fileset
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

source ${VLIB_PATH}/tcl/vlib_fileset.do
add_file_set $technology_specific_fileset
add_file_set $dut_fileset
add_file_set $testbench_fileset


############################################################
# Compile all files
############################################################
project compileall


############################################################
# Find compile order and Compile files
############################################################
source $TCL_PATH/util.tcl

