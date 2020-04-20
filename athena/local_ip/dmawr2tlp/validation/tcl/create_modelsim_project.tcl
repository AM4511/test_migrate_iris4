# Require the MS-Windows environment variable IPCORES and MTI_LIB_XILINX_PATH
# to be defined. 
#
# source  $env(IRIS4)/athena/local_ip/dmawr2tlp/validation/tcl/create_modelsim_project.tcl
#
set MTI_LIB_XILINX_PATH    $env(MTI_LIB_XILINX_PATH)

set ATHENA                 $env(IRIS4)/athena
set IPCORES                ${ATHENA}/ipcores
set LOCAL_IP               ${ATHENA}/local_ip

set PROJECT_NAME           dmawr2tlp  
set ROOT_PATH              ${LOCAL_IP}/dmawr2tlp
set LIBRARY_NAME           ${PROJECT_NAME}.lib

set COMMON_SRC_PATH        ${IPCORES}/common/design
#set INTERFACES_SRC_PATH    ${IPCORES}/interfaces/sv
set VLIB_PATH              ${IPCORES}/vlib       

#set XGS_MODEL_DIR           ${ATHENA}/testbench/models/XGS_model

set TESTBENCH_SRC_PATH     ${ROOT_PATH}/validation/src
set TEST_PATH              ${ROOT_PATH}/validation/tests
set DUT_SRC_PATH           ${ROOT_PATH}/design
set REGISTERFILE_PATH      ${ROOT_PATH}/registerfile

set MODELSIM_PROJECT_NAME  ${PROJECT_NAME}
set MODELSIM_PROJECT_PATH  ${ROOT_PATH}/validation/mti
set MODELSIM_INI           ${MODELSIM_PROJECT_PATH}/modelsim.ini

set LIBRARY_PATH           ${ROOT_PATH}/validation/mti/${LIBRARY_NAME}
set TCL_PATH               ${ROOT_PATH}/validation/tcl

#set INTEL_IP_PATH          ${DUT_SRC_PATH}/phy/intel   
set XILINX_IP_PATH         ${DUT_SRC_PATH}/phy/xilinx   


# set technology_specific_fileset [join [list  [subst {
# ${XILINX_IP_PATH}/hispi_phy_xilinx/hispi_phy_xilinx_selectio_wiz.v
# ${XILINX_IP_PATH}/hispi_phy_xilinx/hispi_phy_xilinx.v
# ${XILINX_IP_PATH}/hispi_serdes.vhd
# }
# ]
# ]
# ]

set dut_fileset [join [list  [subst { 
${COMMON_SRC_PATH}/mtx_types_pkg.vhd
${COMMON_SRC_PATH}/dualPortRamVar.vhd
${COMMON_SRC_PATH}/axiSlave2RegFile.vhd
${DUT_SRC_PATH}/dma_pack.vhd
${DUT_SRC_PATH}/axi_stream_in.vhd
${DUT_SRC_PATH}/dma_write.vhd
${DUT_SRC_PATH}/regfile_dma2tlp.vhd
${DUT_SRC_PATH}/dmawr2tlp.vhd
}
]
]
]


# set model_file_list [list \
 # [file normalize "${XGS_MODEL_DIR}/xgs_model_pkg.vhd"]\
 # [file normalize "${XGS_MODEL_DIR}/xgs_sensor_config.vhd"]\
 # [file normalize "${XGS_MODEL_DIR}/xgs_spi_i2c.vhd"]\
 # [file normalize "${XGS_MODEL_DIR}/xgs_image.vhd"]\
 # [file normalize "${XGS_MODEL_DIR}/xgs_hispi.vhd"]\
 # [file normalize "${XGS_MODEL_DIR}/xgs12m_chip.vhd"]
# ]


# set testbench_fileset [join [list  [subst {
# ${REGISTERFILE_PATH}/hispi_registerfile.sv		
# ${TESTBENCH_SRC_PATH}/glbl.v
# ${TESTBENCH_SRC_PATH}/hispi_interface.sv
# ${TESTBENCH_SRC_PATH}/hispi_pkg.sv	
# ${TESTBENCH_SRC_PATH}/testbench_hispi.sv
# ${TEST_PATH}/tests_pkg.sv
# }
# ]
# ]
# ]

		
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

vmap unisim      ${MTI_LIB_XILINX_PATH}/unisim
vmap unisims_ver ${MTI_LIB_XILINX_PATH}/unisims_ver
vmap secureip    ${MTI_LIB_XILINX_PATH}/secureip
vmap xpm         ${MTI_LIB_XILINX_PATH}/xpm


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

source ${VLIB_PATH}/tcl/vlib_fileset.do
#add_file_set $technology_specific_fileset
add_file_set $dut_fileset
#add_file_set $model_file_list
#add_file_set $testbench_fileset


############################################################
# Compile all files
############################################################
project compileall


############################################################
# Find compile order and Compile files
############################################################
source $TCL_PATH/util.tcl

