# Require the MS-Windows environment variable IPCORES and MTI_LIB_XILINX_PATH
# to be defined. 
#
# source $env(IRIS4)/athena/local_ip/XGS_athena/validation/tcl/create_modelsim_project.tcl
#
set MTI_LIB_XILINX_PATH    $env(MTI_LIB_XILINX_PATH)

set ATHENA                 $env(IRIS4)/athena
set IPCORES                ${ATHENA}/ipcores
set LOCAL_IP               ${ATHENA}/local_ip

set PROJECT_NAME           XGS_athena  
set ROOT_PATH              ${LOCAL_IP}/XGS_athena
set LIBRARY_NAME           ${PROJECT_NAME}.lib

set COMMON_SRC_PATH        ${IPCORES}/common/design
set VLIB_PATH              ${IPCORES}/vlib       

set XGS_MODEL_DIR           ${ATHENA}/testbench/models/XGS_model

set TESTBENCH_SRC_PATH     ${ROOT_PATH}/validation/src
set TEST_PATH              ${ROOT_PATH}/validation/tests
set DUT_SRC_PATH           ${ROOT_PATH}/hdl
set DMA_SRC_PATH           ${ROOT_PATH}/hdl/dma
set DATA_SRC_PATH          ${ROOT_PATH}/hdl/data
set CTRL_SRC_PATH          ${ROOT_PATH}/hdl/controller
set REGISTERFILE_PATH      ${ROOT_PATH}/registerfile

set MODELSIM_PROJECT_NAME  ${PROJECT_NAME}
set MODELSIM_PROJECT_PATH  ${ROOT_PATH}/validation/mti
set MODELSIM_INI           ${MODELSIM_PROJECT_PATH}/modelsim.ini

set LIBRARY_PATH           ${ROOT_PATH}/validation/mti/${LIBRARY_NAME}
set TCL_PATH               ${ROOT_PATH}/validation/tcl

set XILINX_IP_PATH         ${DATA_SRC_PATH}/phy/xilinx   



set common_fileset [join [list  [subst { 
${COMMON_SRC_PATH}/mtx_types_pkg.vhd
${COMMON_SRC_PATH}/dualPortRamVar.vhd \
${COMMON_SRC_PATH}/mtxDCFIFO.vhd \
${COMMON_SRC_PATH}/mtxSCFIFO.vhd \
${COMMON_SRC_PATH}/round_robin.vhd \
${COMMON_SRC_PATH}/axiSlave2RegFile.vhd
}
]
]
]


set technology_specific_fileset [join [list  [subst {
${XILINX_IP_PATH}/hispi_phy_xilinx/hispi_phy_xilinx_selectio_wiz.v
${XILINX_IP_PATH}/hispi_phy_xilinx/hispi_phy_xilinx.v
${XILINX_IP_PATH}/hispi_serdes.vhd
}
]
]
]

set dut_fileset [join [list  [subst { 
${REGISTERFILE_PATH}/regfile_xgs_athena.vhd \
${CTRL_SRC_PATH}/led_status.vhd \
${CTRL_SRC_PATH}/xgs_power.vhd \
${CTRL_SRC_PATH}/xgs_spi.vhd \
${CTRL_SRC_PATH}/xgs_ctrl.vhd \
${CTRL_SRC_PATH}/XGS_controller_top.vhd \
${DATA_SRC_PATH}/hispi_pack.vhd \
${DATA_SRC_PATH}/bit_split.vhd \
${DATA_SRC_PATH}/tap_controller.vhd \
${DATA_SRC_PATH}/lane_decoder.vhd \
${DATA_SRC_PATH}/hispi_phy.vhd \
${DATA_SRC_PATH}/lane_packer.vhd \
${DATA_SRC_PATH}/line_buffer.vhd \
${DATA_SRC_PATH}/axi_line_streamer.vhd \
${DATA_SRC_PATH}/xgs_hispi_top.vhd \
${DATA_SRC_PATH}/xgs_mono_pipeline.vhd \
${DMA_SRC_PATH}/dma_pack.vhd \
${DMA_SRC_PATH}/axi_stream_in.vhd \
${DMA_SRC_PATH}/dma_write.vhd \
${DMA_SRC_PATH}/regfile_dmawr2tlp.vhd \
${DMA_SRC_PATH}/dmawr2tlp.vhd \
${DUT_SRC_PATH}/XGS_athena.vhd
}
]
]
]


set model_file_list [join [list  [subst { 
[file normalize "${XGS_MODEL_DIR}/xgs_model_pkg.vhd"]\
[file normalize "${XGS_MODEL_DIR}/xgs_sensor_config.vhd"]\
[file normalize "${XGS_MODEL_DIR}/xgs_spi_i2c.vhd"]\
[file normalize "${XGS_MODEL_DIR}/xgs_image.vhd"]\
[file normalize "${XGS_MODEL_DIR}/xgs_hispi.vhd"]\
[file normalize "${XGS_MODEL_DIR}/xgs12m_chip.vhd"]
}
]
]
]


set testbench_fileset [join [list  [subst {
${TESTBENCH_SRC_PATH}/glbl.v \
${TESTBENCH_SRC_PATH}/xgs_athena_pkg.sv \
${TESTBENCH_SRC_PATH}/hispi_interface.sv \
${TESTBENCH_SRC_PATH}/tlp_interface.sv \
${LOCAL_IP}/pcie2AxiMaster_v3.0/design/regfile_pcie2AxiMaster.vhd 
${LOCAL_IP}/pcie2AxiMaster_v3.0/design/pciepack.vhd
${LOCAL_IP}/pcie2AxiMaster_v3.0/design/pcie_tx_axi.vhd \
${TESTBENCH_SRC_PATH}/testbench.sv
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
add_file_set $common_fileset
add_file_set $technology_specific_fileset
add_file_set $dut_fileset
add_file_set $model_file_list
add_file_set $testbench_fileset


############################################################
# Compile all files
############################################################
project compileall


############################################################
# Find compile order and Compile files
############################################################
source $TCL_PATH/util.tcl
