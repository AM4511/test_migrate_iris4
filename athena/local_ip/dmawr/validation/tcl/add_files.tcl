################################################
# Add validation source files
################################################
set AXI_HISPI_FILE_LIST [list \
 # [file normalize "${COMMON_DIR}/design/mtx_types_pkg.vhd"] \
 # [file normalize "${COMMON_DIR}/design/axiSlave2RegFile.vhd"] \
 # [file normalize "${COMMON_DIR}/design/dualPortRamVar.vhd"] \
 # [file normalize "${COMMON_DIR}/design/mtxDCFIFO.vhd"] \
 # [file normalize "${COMMON_DIR}/design/mtxSCFIFO.vhd"] \
 # [file normalize "${COMMON_DIR}/design/round_robin.vhd"] \
 # [file normalize "${DESIGN_DIR}/hispi_pack.vhd"] \
 # [file normalize "${DESIGN_DIR}/phy/xilinx/hispi_phy_xilinx/hispi_phy_xilinx.xci"] \
 # [file normalize "${DESIGN_DIR}/phy/xilinx/hispi_serdes.vhd"] \
 # [file normalize "${DESIGN_DIR}/lane_decoder.vhd"] \
 # [file normalize "${DESIGN_DIR}/hispi_phy.vhd"] \
 # [file normalize "${DESIGN_DIR}/bit_split.vhd"] \
 # [file normalize "${DESIGN_DIR}/lane_packer.vhd"] \
 # [file normalize "${DESIGN_DIR}/line_buffer.vhd"] \
 # [file normalize "${DESIGN_DIR}/multi_line_buffer.vhd"] \
 # [file normalize "${DESIGN_DIR}/axi_line_streamer.vhd"] \
 # [file normalize "${DESIGN_DIR}/hispi_registerfile.vhd"] \
 # [file normalize "${DESIGN_DIR}/hispi_top.vhd"] \
 # [file normalize "${DESIGN_DIR}/axiHiSPi.vhd"] \
]
add_files -norecurse -fileset ${VALIDATION_FILESET} $AXI_HISPI_FILE_LIST


set MODEL_FILE_LIST [list \
 # [file normalize "${XGS_MODEL_DIR}/xgs_model_pkg.vhd"]\
 # [file normalize "${XGS_MODEL_DIR}/xgs_sensor_config.vhd"]\
 # [file normalize "${XGS_MODEL_DIR}/xgs_spi_i2c.vhd"]\
 # [file normalize "${XGS_MODEL_DIR}/xgs_image.vhd"]\
 # [file normalize "${XGS_MODEL_DIR}/xgs_hispi.vhd"]\
 # [file normalize "${XGS_MODEL_DIR}/xgs12m_chip.vhd"]
]

add_files -norecurse -fileset ${VALIDATION_FILESET} $MODEL_FILE_LIST

set TESTBENCH_FILE_LIST [list \
 # [file normalize "${SRC_DIR}/testbench_xgs12m.sv"]\

]
add_files -norecurse -fileset ${VALIDATION_FILESET} $TESTBENCH_FILE_LIST

