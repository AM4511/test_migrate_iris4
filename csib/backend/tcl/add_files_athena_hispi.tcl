################################################
# Add HDL source files
################################################
set FILE_LIST [list \
  [file normalize "${SRC_DIR}/csib_athena_hispi.vhd"]
]

add_files -norecurse -fileset ${HDL_FILESET} $FILE_LIST
update_compile_order -fileset ${HDL_FILESET}


################################################
# Add constraints files
################################################
add_files -fileset ${CONSTRAINTS_FILESET} -norecurse ${XDC_DIR}/pl_pinout.xdc
add_files -fileset ${CONSTRAINTS_FILESET} -norecurse ${XDC_DIR}/io_timing.sdc
add_files -fileset ${CONSTRAINTS_FILESET} -norecurse ${XDC_DIR}/implementation_timing_constraints.xdc
set_property used_in_synthesis false [get_files  ${XDC_DIR}/implementation_timing_constraints.xdc]
# Needs to be processed late because of the set_property IOB false constraints
set_property PROCESSING_ORDER LATE   [get_files  ${XDC_DIR}/implementation_timing_constraints.xdc]

# Target constraints file
set TARGET_CONSTRAIN_FILE [file normalize "${XDC_DIR}/new_constraints.xdc"]
add_files -fileset ${CONSTRAINTS_FILESET} -norecurse $TARGET_CONSTRAIN_FILE
set_property target_constrs_file $TARGET_CONSTRAIN_FILE ${CONSTRAINTS_FILESET}

