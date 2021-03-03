# ##################################################################################
# File         : create_ares_50t_rev0.tcl
# Description  : TCL script used to create the MIOX fpga project. 
#
# Example      : source $env(IRIS4)/ares_pcie/backend/7571-02/create_ares_50t_rev2_166MHz.tcl
# 
# set NO_REPORT  1
# set NO_ARCHIVE 1
# ##################################################################################
set DEBUG 0


if {${DEBUG} == 1} {
  set myself $env(IRIS4)/ares_pcie/backend/7571-02/create_ares_50t_rev2_166MHz.tcl
} else {
  set myself [info script]
}


# ##################################################################################
#
# ##################################################################################
if {[file exists $myself ]} {
   puts "Running ${myself}"
   set BACKEND_DIR [file normalize [file dirname ${myself}]]
   set WORKDIR   [file normalize [file join ${BACKEND_DIR} "../.."]]
   set BASE_NAME  ares_7571_02_a50t_hr166
   set DEVICE "xc7a50ticpg236-1L"

   set AXI_SYSTEM_BD_FILE ${BACKEND_DIR}/system_pcie_hyperram_hr166MHz.tcl
   set HYPERRAM_SDC_FILE  ${BACKEND_DIR}/hyperbus_hr166MHz.sdc

   # #################################################################
   #  ARES FPGA_ID (FPGA DEVICE ID MAP) :
   # #################################################################
   # 0x00 Reserved
   # 0x01 Spartan6 LX9 fpga used on Y7449-00 (deprecated)
   # 0x02 Spartan6 LX16 fpga used on Y7449-01,02
   # 0x03 Artix7 A35T fpga used on Y7471-00 (deprecated)
   # 0x04 Artix7 A50T fpga used on Y7471-01
   # 0x05 Artix7 A50T fpga used on Y7471-02
   # 0x06 Artix7 A50T fpga used on Y7449-03
   # 0x07 Artix7 Spider PCIe on Advanced IO board
   # 0x08 Artix7 Ares PCIe (Iris3 Spider+Profiblaze on Y7478-00)
   # 0x09 Artix7 Ares PCIe (Iris3 Spider+Profiblaze on Y7478-01)
   # 0x0A:0x0F   Reserved
   # 0x10 Iris GTX, Artix7 Ares PCIe, Artix7 A35T on Y7571-[00,01]
   # 0x11 Iris GTX, Artix7 Ares PCIe, Artix7 A50T on Y7571-[00,01]
   # 0x12 Iris GTX, Artix7 Ares PCIe, Artix7 A35T on Y7571-02
   # 0x13 Iris GTX, Artix7 Ares PCIe, Artix7 A50T on Y7571-02
   set FPGA_ID 19; # 0x13 Iris GTX, Artix7 Ares PCIe, Artix7 A50T on Y7571-02
   
   # Generic passed to VHDL top level file by generic
   set FPGA_IS_NPI_GOLDEN     "false"

   # Flash programation offset 
   # NPI Golden  : 0x000000)
   # MIL Upgrade : 0x400000)
   set FLASH_OFFSET 0x000000
   
   # ############################################
   # Starting generation script
   # ############################################
   if {${DEBUG} == 0} {
     source $BACKEND_DIR/create_ares.tcl
   }


} else {
   puts "Error : script $myself does not exist!!!"

}
