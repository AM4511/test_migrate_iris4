# ##################################################################################
# File         : create_upgrade_athena_50t_color.tcl
# Description  : TCL script used to create UPGRADE COLOR athena fpga 50T. 
#
# Example      : source $env(IRIS4)/athena/backend/artix7/create_upgrade_athena_50t_color.tcl
#
# ##################################################################################
set DEBUG 0

if {$DEBUG == 0} {
  set myself [info script]
} else {
  set myself $env(IRIS4)/athena/backend/artix7/create_upgrade_athena_50t_color.tcl
}


# ##################################################################################
#
# ##################################################################################
if {[file exists $myself ]} {
   puts "Running ${myself}"
   set BACKEND_DIR [file normalize [file dirname ${myself}]]
   set WORKDIR   [file normalize [file join ${BACKEND_DIR} "../.."]]

   set BASE_NAME             "upgrade_athena50t"
   set DEVICE                "xc7a50ticpg236-1L"
   
   # FPGA_DEVICE_ID (DEVICE ID MAP) :
   # Generic passed to VHDL top level file by generic
   #  0      : xc7a50ticpg236-1L
   #  1      : xc7a35ticpg236-1L
   #  Others : reserved
   set FPGA_DEVICE_ID 0
   
   # Generic passed to VHDL top level file by generic
   # 0      : MIL upgrade firmware
   # 1      : NPI golden firmware
   # 2      : Engineering firmware
   # Others : Reserved
   set FPGA_IS_NPI_GOLDEN 0
   
   # Flash programation offset 
   # NPI Golden  : 0x000000)
   # MIL Upgrade : 0x400000)
   set FLASH_OFFSET     0x400000

   # Compile a COLOR pipeline fpga, Set Block design XGS_athena_0 parameter COLOR=1
   set COLOR_FPGA 1
   
   # ############################################
   # Starting generation script
   # ############################################
   if {${DEBUG} == 0} {
   source $BACKEND_DIR/create_athena.tcl
   }
   
} else {
   puts "Error : script $myself does not exist!!!"

}
