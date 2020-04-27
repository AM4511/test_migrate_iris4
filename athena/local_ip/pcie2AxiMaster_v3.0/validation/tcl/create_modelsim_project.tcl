# Require the MS-Windows environment variable IPCORES and MTI_LIB_XILINX_PATH
# to be defined. 
#
# source $env(IPCORES)/pcie2AxiMaster_v3.0/validation/tcl/create_modelsim_project.tcl
#
set IRIS4                $env(IRIS4)
set IPCORES              ${IRIS4}/athena/local_ip
set MTI_LIB_XILINX_PATH  $env(MTI_LIB_XILINX_PATH)
set MTI_LIB_MATROX_PATH  $env(MTI_LIB_MATROX_PATH)

set ROOT_PATH  ${IPCORES}/pcie2AxiMaster_v3.0
set PROJECT_NAME pcie2AxiMaster_v3.0  
set LIBRARY_NAME ${PROJECT_NAME}.lib

set COMMON_SRC_PATH        ${IPCORES}/common/design

set XIL_PCIE_ENDPOINT      ${ROOT_PATH}/cores/pcie_7x_0
set XIL_PCIE_FIFO          ${ROOT_PATH}/cores/xil_pcie_reg_fifo

set INTERFACES_SRC_PATH    ${IPCORES}/interfaces/sv
set VLIB_PATH              ${IPCORES}/vlib       

set AXI_MODEL_SLAVE_LITE      ${IPCORES}/axiModelSlaveLite
set TESTBENCH_SRC_PATH     ${ROOT_PATH}/validation/src
set TEST_PATH              ${ROOT_PATH}/validation/src/tests
set DUT_SRC_PATH           ${ROOT_PATH}/design

set MODELSIM_PROJECT_NAME  "${PROJECT_NAME}"
set MODELSIM_PROJECT_PATH  ${ROOT_PATH}/validation/mti
set MODELSIM_INI           ${MODELSIM_PROJECT_PATH}/../modelsim.ini

set LIBRARY_PATH           ${ROOT_PATH}/validation/mti/${LIBRARY_NAME}
set TCL_PATH               ${ROOT_PATH}/validation/tcl

set pcie_endpoint_fileset [join [list  [subst { 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_pipe_clock.v 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_pipe_eq.v 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_pipe_drp.v 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_pipe_rate.v 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_pipe_reset.v 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_pipe_sync.v 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_gtp_pipe_rate.v 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_gtp_pipe_drp.v 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_gtp_pipe_reset.v 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_pipe_user.v 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_pipe_wrapper.v 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_qpll_drp.v 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_qpll_reset.v 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_qpll_wrapper.v 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_rxeq_scan.v 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_pcie_top.v 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_core_top.v 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_axi_basic_rx_null_gen.v 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_axi_basic_rx_pipeline.v 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_axi_basic_rx.v 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_axi_basic_top.v 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_axi_basic_tx_pipeline.v 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_axi_basic_tx_thrtl_ctl.v 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_axi_basic_tx.v 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_pcie_7x.v 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_pcie_bram_7x.v 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_pcie_bram_top_7x.v 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_pcie_brams_7x.v 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_pcie_pipe_lane.v 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_pcie_pipe_misc.v 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_pcie_pipe_pipeline.v 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_gt_top.v 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_gt_common.v 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_gtp_cpllpd_ovrd.v 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_gtx_cpllpd_ovrd.v 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_gt_rx_valid_filter_7x.v 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_gt_wrapper.v 
${XIL_PCIE_ENDPOINT}/source/pcie_7x_0_pcie2_top.v 
${XIL_PCIE_ENDPOINT}/sim/pcie_7x_0.v 
}
]
]
]

set pcie_fifo_fileset [join [list  [subst {
${XIL_PCIE_FIFO}/hdl/fifo_generator_v13_4_rfs.v
${XIL_PCIE_FIFO}/simulation/fifo_generator_vlog_beh.v 
${XIL_PCIE_FIFO}/sim/xil_pcie_reg_fifo.v
}
]
]
]

set dut_fileset [join [list  [subst { 
${COMMON_SRC_PATH}/mtxSCFIFO.vhd
${DUT_SRC_PATH}/regfile_pcie2AxiMaster.vhd
${DUT_SRC_PATH}/spi_if.vhd
${DUT_SRC_PATH}/int_queue_pak.vhd
${DUT_SRC_PATH}/pciepack.vhd      
${DUT_SRC_PATH}/pcie_reg.vhd
${DUT_SRC_PATH}/pcie_int_queue.vhd
${DUT_SRC_PATH}/pcie_irq_axi.vhd     
${DUT_SRC_PATH}/pcie_rx_axi.vhd      
${DUT_SRC_PATH}/pcie_tx_axi.vhd      
${DUT_SRC_PATH}/tlp_completion.vhd   
${DUT_SRC_PATH}/tlp_to_axi_master.vhd
${DUT_SRC_PATH}/pcie_7x_0_mtx_wrapper.v
${DUT_SRC_PATH}/pcie2AxiMaster.vhd   
}
]
]
]


set testbench_fileset [join [list  [subst {
#${COMMON_SRC_PATH}/axiSlave2RegFile.vhd
#${AXI_MODEL_SLAVE_LITE}/design/axiModelSlaveLite.vhd
#${INTERFACES_SRC_PATH}/axi_mm_interface.sv
${TESTBENCH_SRC_PATH}/testbench.sv
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

vmap unisim                 ${MTI_LIB_XILINX_PATH}/unisim
vmap unisims_ver            ${MTI_LIB_XILINX_PATH}/unisims_ver

vmap unimacro               ${MTI_LIB_XILINX_PATH}/unimacro
vmap unimacro_ver           ${MTI_LIB_XILINX_PATH}/unimacro_ver
vmap fifo_generator_v13_2_4 ${MTI_LIB_XILINX_PATH}/fifo_generator_v13_2_4

vmap secureip               ${MTI_LIB_XILINX_PATH}/secureip
vmap xpm                    ${MTI_LIB_XILINX_PATH}/xpm
vmap dw04                   ${MTI_LIB_MATROX_PATH}/dw04
vmap dware                  ${MTI_LIB_MATROX_PATH}/dware
vmap matrox                 ${MTI_LIB_MATROX_PATH}/matrox
vmap gtech                  ${MTI_LIB_MATROX_PATH}/GTECH

############################################################
# Add design files
############################################################
proc add_file_set {file_set} {
    foreach filePath $file_set {
        if { [file exists $filePath ] } {
            project addfile $filePath
        } else {
    	puts  "File does not exist $filePath"
    
        }
    }
}

############################################################
# Add design filesets in Modelsim
############################################################
source ${IPCORES}/modelPCIe/validation/load_files.tcl
add_file_set $modelPCIe_fileset
add_file_set $pcie_endpoint_fileset
add_file_set $pcie_fifo_fileset
add_file_set $dut_fileset
source ${VLIB_PATH}/tcl/vlib_fileset.do
add_file_set $testbench_fileset


############################################################
# Compile all files
############################################################
project compileall


############################################################
# Find compile order and Compile files
############################################################
source $TCL_PATH/util.tcl

