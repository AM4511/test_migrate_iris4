
# example : do D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/tcl/runsim.tcl

set ROOT_DIR $::env(PCIE2AXIMASTER)
set VALIDATION_DIR $ROOT_DIR/validation
set TCL_DIR $ROOT_DIR/tcl
set SCRIPT_PATH  [ file normalize [ info script ] ]


cd $VALIDATION_DIR

vsim -gui -t ps pcie2AxiMaster.top


proc aa { } {
 do $SCRIPT_PATH
}
