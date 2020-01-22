################################################
# Add HDL source files
################################################
set FILE_LIST [list \
  [file normalize "${WORKDIR}/cores/xil_cores_artix7/pcie_7x/pcie_7x.xci"]\
  [file normalize "${WORKDIR}/cores/xil_cores_artix7/xil_pcie_reg_fifo/xil_pcie_reg_fifo.xci"]\
  [file normalize "${SRC_DIR}/osirispak.vhd"]\
  [file normalize "${SRC_DIR}/regfile_ares.vhd"]\
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
  [file normalize "${SRC_DIR}/ares_pcie.vhd"]
]

add_files -norecurse -fileset ${HDL_FILESET} $FILE_LIST
update_compile_order -fileset ${HDL_FILESET}


################################################
# Add constraints files
################################################
add_files -fileset ${CONSTRAINTS_FILESET} -norecurse ${XDC_DIR}/pinout.xdc

add_files -fileset ${CONSTRAINTS_FILESET} -norecurse ${XDC_DIR}/timing.sdc
add_files -fileset ${CONSTRAINTS_FILESET} -norecurse ${XDC_DIR}/hyperbus.sdc
add_files -fileset ${CONSTRAINTS_FILESET} -norecurse ${XDC_DIR}/ncsi_timings.sdc
add_files -fileset ${CONSTRAINTS_FILESET} -norecurse ${XDC_DIR}/compile.xdc
set_property used_in_synthesis false [get_files  ${XDC_DIR}/compile.xdc]
# Needs to be processed late because of the set_property IOB false constraints
set_property PROCESSING_ORDER LATE   [get_files  ${XDC_DIR}/compile.xdc]


#add_files -fileset ${CONSTRAINTS_FILESET} -norecurse ${XDC_DIR}/pcie_7x-PCIE_X0Y0.xdc
#add_files -fileset ${CONSTRAINTS_FILESET} -norecurse ${IPCORES_DIR}/xil_cores_artix7/ddr2-100MHz_in/ddr2/user_design/constraints/ddr2.xdc


#add_files -fileset ${CONSTRAINTS_FILESET} -norecurse  ${XDC_DIR}/mb_spi_access.xdc
#set_property PROCESSING_ORDER LATE [get_files  ${XDC_DIR}/mb_spi_access.xdc]


# Target constraints file
set TARGET_CONSTRAIN_FILE [file normalize "${XDC_DIR}/new_constraints.xdc"]
add_files -fileset ${CONSTRAINTS_FILESET} -norecurse $TARGET_CONSTRAIN_FILE
set_property target_constrs_file $TARGET_CONSTRAIN_FILE ${CONSTRAINTS_FILESET}

# Problem with a Xilinx constraint file
set CONSTRAINT_FILE [get_files bd_a352_mac_0_clocks.xdc]
set_property IS_ENABLED 0 ${CONSTRAINT_FILE}
