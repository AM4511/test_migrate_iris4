# ##################################################################################
# File         : create_athena_50t.tcl
# Description  : TCL script used to create athena fpga 50T. 
#
# Example      : source $env(IRIS4)/athena/backend/artix7/create_athena_50t.tcl
#
# ##################################################################################
set DEBUG 0

if {$DEBUG == 0} {
  set myself [info script]
} else {
  set myself $env(IRIS4)/athena/backend/artix7/create_athena_50t.tcl
}


# ##################################################################################
#
# ##################################################################################
if {[file exists $myself ]} {
   puts "Running ${myself}"
   set BACKEND_DIR [file normalize [file dirname ${myself}]]
   set WORKDIR   [file normalize [file join ${BACKEND_DIR} "../.."]]
   
   set BASE_NAME             "athena50t"
   set DEVICE                "xc7a50ticpg236-1L"
   
   # FPGA_DEVICE_ID (DEVICE ID MAP) :
   # Generic passed to VHDL top level file by generic
   #  0      : xc7a50ticpg236-1L (MONO)
   #  1      : xc7a35ticpg236-1L (MONO)
   #  2      : xc7a50ticpg236-1L (COLOR)
   #  3      : xc7a35ticpg236-1L (COLOR)
   #  Others : reserved
   set FPGA_DEVICE_ID 0
   
   # Generic passed to VHDL top level file by generic
   # 0      : MIL upgrade firmware
   # 1      : NPI golden firmware
   # 2      : Engineering firmware
   # Others : Reserved
   set FPGA_IS_NPI_GOLDEN 2
   
   # Flash programation offset 
   # NPI Golden  : 0x000000
   # Engineering : 0x000000
   # MIL Upgrade : 0x400000
   set FLASH_OFFSET 0x000000
   
   # ############################################
   # Starting generation script
   # ############################################
   source $BACKEND_DIR/create_athena.tcl
   
} else {
   puts "Error : script $myself does not exist!!!"

}
