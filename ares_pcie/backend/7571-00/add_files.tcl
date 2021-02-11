################################################
# Add HDL source files
################################################
set FILE_LIST [list \
  [file normalize "${IPCORES_DIR}/common/design/mtxSCFIFO.vhd"]\
  [file normalize "${SRC_DIR}//tlp_completion.vhd"]\
  [file normalize "${SRC_DIR}//tlp_to_axi_master.vhd"]\
  [file normalize "${LOCAL_IP_DIR}/xil_cores_artix7/pcie_7x/pcie_7x.xci"]\
  [file normalize "${LOCAL_IP_DIR}/xil_cores_artix7/xil_pcie_reg_fifo/xil_pcie_reg_fifo.xci"]\
  [file normalize "${SRC_DIR}/osirispak.vhd"]\
  [file normalize "${REG_DIR}/regfile_ares.vhd"]\
  [file normalize "${SRC_DIR}/mem_util_pkg.vhd"]\
  [file normalize "${SRC_DIR}/spider_pak.vhd"]\
  [file normalize "${SRC_DIR}/Input_Conditioning.vhd"]\
  [file normalize "${SRC_DIR}/Output_Conditioning.vhd"]\
  [file normalize "${SRC_DIR}/pciepack.vhd"]\
  [file normalize "${SRC_DIR}/pcie_int_queue.vhd"]\
  [file normalize "${SRC_DIR}/pcie_irq_axi.vhd"]\
  [file normalize "${SRC_DIR}/pcie_reg.vhd"]\
  [file normalize "${SRC_DIR}/pcie_rx_axi.vhd"]\
  [file normalize "${SRC_DIR}/pcie_tx_axi.vhd"]\
  [file normalize "${SRC_DIR}/pcie_top.vhd"]\
  [file normalize "${SRC_DIR}/PWMoutput.vhd"]\
  [file normalize "${SRC_DIR}/quaddecoder.vhd"]\
  [file normalize "${SRC_DIR}/spider_pak.vhd"]\
  [file normalize "${SRC_DIR}/TickTable.vhd"]\
  [file normalize "${SRC_DIR}/timer.vhd"]\
  [file normalize "${SRC_DIR}/userio_bank.vhd"]\
  [file normalize "${SRC_DIR}/xil_ticktable.vhd"]\
  [file normalize "${SRC_DIR}/arbiter.vhd"]\
  [file normalize "${SRC_DIR}/ares_pcie.vhd"]
]

add_files -norecurse -fileset ${HDL_FILESET} $FILE_LIST
update_compile_order -fileset ${HDL_FILESET}


################################################
# Add constraints files
################################################
add_files -fileset ${CONSTRAINTS_FILESET} -norecurse ${XDC_DIR}/pinout.xdc

add_files -fileset ${CONSTRAINTS_FILESET} -norecurse ${XDC_DIR}/timing.sdc
add_files -fileset ${CONSTRAINTS_FILESET} -norecurse ${XDC_DIR}/hyperbus_hr142MHZ.sdc
add_files -fileset ${CONSTRAINTS_FILESET} -norecurse ${XDC_DIR}/ncsi_timings.sdc
add_files -fileset ${CONSTRAINTS_FILESET} -norecurse ${XDC_DIR}/axi_quad_spi.xdc
add_files -fileset ${CONSTRAINTS_FILESET} -norecurse ${XDC_DIR}/compile.xdc



add_files -fileset ${CONSTRAINTS_FILESET} -norecurse ${XDC_DIR}/timing_late.sdc
set_property PROCESSING_ORDER LATE [get_files  ${XDC_DIR}/timing_late.sdc]

set_property used_in_synthesis false [get_files  ${XDC_DIR}/compile.xdc]
# Needs to be processed late because of the set_property IOB false constraints
set_property PROCESSING_ORDER LATE   [get_files  ${XDC_DIR}/compile.xdc]

add_files -fileset ${CONSTRAINTS_FILESET} -norecurse ${XDC_DIR}/power.xdc
set_property used_in_synthesis false [get_files ${XDC_DIR}/power.xdc]
set_property PROCESSING_ORDER LATE [get_files ${XDC_DIR}/power.xdc]


# Target constraints file
set TARGET_CONSTRAIN_FILE [file normalize "${XDC_DIR}/new_constraints.xdc"]
add_files -fileset ${CONSTRAINTS_FILESET} -norecurse $TARGET_CONSTRAIN_FILE
set_property target_constrs_file $TARGET_CONSTRAIN_FILE ${CONSTRAINTS_FILESET}
