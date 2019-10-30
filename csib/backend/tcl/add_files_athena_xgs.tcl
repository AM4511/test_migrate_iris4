################################################
# Add HDL source files
################################################
set FILE_LIST [list \
  [file normalize "${SRC_DIR}/athena_xgs.vhd"]
]

add_files -norecurse -fileset ${HDL_FILESET} $FILE_LIST
update_compile_order -fileset ${HDL_FILESET}


################################################
# Add constraints files
################################################
add_files -fileset ${CONSTRAINTS_FILESET} -norecurse ${XDC_DIR}/athena_xgs_pinout.xdc
add_files -fileset ${CONSTRAINTS_FILESET} -norecurse ${XDC_DIR}/athena_xgs_timing.sdc
add_files -fileset ${CONSTRAINTS_FILESET} -norecurse ${XDC_DIR}/athena_xgs_compile.xdc
set_property used_in_synthesis false [get_files  ${XDC_DIR}/athena_xgs_compile.xdc]
# Needs to be processed late because of the set_property IOB false constraints
set_property PROCESSING_ORDER LATE   [get_files  ${XDC_DIR}/athena_xgs_compile.xdc]

# Target constraints file
set TARGET_CONSTRAIN_FILE [file normalize "${XDC_DIR}/new_constraints.xdc"]
add_files -fileset ${CONSTRAINTS_FILESET} -norecurse $TARGET_CONSTRAIN_FILE
set_property target_constrs_file $TARGET_CONSTRAIN_FILE ${CONSTRAINTS_FILESET}

