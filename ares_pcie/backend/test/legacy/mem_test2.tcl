set J2AXI [get_hw_axis hw_axi_1]
reset_hw_axi ${J2AXI}


########################################################################################################
########################################################################################################
########################################################################################################
proc write32 {j2axi address data} {
   create_hw_axi_txn write_txn ${j2axi} -quiet -type WRITE -address ${address} -len 1 -data ${data} -force
   run_hw_axi -quiet [get_hw_axi_txns write_txn]
}


proc read32 {j2axi address} {
   create_hw_axi_txn read_txn ${j2axi} -quiet -type READ -address ${address} -len 1 -force
   run_hw_axi -quiet [get_hw_axi_txns read_txn]
   # report_hw_axi_txn [get_hw_axi_txns read_txn]
   return [get_property DATA [get_hw_axi_txn read_txn]]
}


########################################################################################################
########################################################################################################
########################################################################################################
proc set_bit {j2axi address bit_index} {
     set read_value [expr 0x[read32 $j2axi $address]]
	 set bit_value [expr 1 << ${bit_index}]
     set modified_value [expr ${read_value} | ${bit_value}]
	 set hex_value [format %08x ${modified_value}]
	 write32 $j2axi $address $hex_value
     return [read32 $j2axi $address]
}



proc rpc_get_CSR {j2axi} {
  send_msg_id {USER 00-001} "INFO" "Reading /RPC2/CSR register"   
  set address 00000000
  return [read32 $j2axi $address]
}

proc rpc_get_IEN {j2axi} {
  send_msg_id {USER 00-002} "INFO" "Reading /RPC2/IEN register"   
  set address 00000004
  return [read32 $j2axi $address]
}

proc rpc_get_ISR {j2axi} {
  send_msg_id {USER 00-003} "INFO" "Reading /RPC2/ISR register"   
  set address 00000008
  return [read32 $j2axi $address]
}


proc rpc_get_ICR {j2axi} {
  send_msg_id {USER 00-004} "INFO" "Reading /RPC2/ICR register"   
  set address 0000000c
  return [read32 $j2axi $address]
}


proc rpc_get_MBR {j2axi} {
  send_msg_id {USER 00-005} "INFO" "Reading /RPC2/MBR register"   
  set address 00000010
  return [read32 $j2axi $address]
}


proc rpc_get_MCR {j2axi} {
  send_msg_id {USER 00-006} "INFO" "Reading /RPC2/MCR register"   
  set address 00000020
  return [read32 $j2axi $address]
}


proc rpc_get_MTR {j2axi} {
  send_msg_id {USER 00-007} "INFO" "Reading /RPC2/MTR register"   
  set address 00000030
  return [read32 $j2axi $address]
}


proc rpc_get_GPOR {j2axi} {
  send_msg_id {USER 00-008} "INFO" "Reading /RPC2/GPOR register"   
  set address 00000040
  return [read32 $j2axi $address]
}


proc rpc_get_WPR {j2axi} {
  send_msg_id {USER 00-009} "INFO" "Reading /RPC2/WPR register"   
  set address 00000044
  return [read32 $j2axi $address]
}


proc rpc_get_LBR {j2axi} {
  send_msg_id {USER 00-010} "INFO" "Reading /RPC2/LBR register"   
  set address 00000048
  return [read32 $j2axi $address]
}


proc rpc_get_TAR {j2axi} {
  send_msg_id {USER 00-010} "INFO" "Reading /RPC2/TAR register"   
  set address 0000004C
  return [read32 $j2axi $address]
}


proc rpc_set_MCR {j2axi value} {
  send_msg_id {USER 00-006} "INFO" "Setting /RPC2/MCR register"   
  set address 00000020
  return [write32 $j2axi $address $value]
}


proc rpc_set_MTR {j2axi value} {
  send_msg_id {USER 00-007} "INFO" "Reading /RPC2/MTR register"   
  set address 00000030
  return [write32 $j2axi $address $value]
}

proc rpc_set_LBR {j2axi value} {
  send_msg_id {USER 00-007} "INFO" "Reading /RPC2/LBR register"   
  set address 00000048
  return [write32 $j2axi $address $value]
}

proc hr_get_config_0 {j2axi} {
   set mcr_address 00000020
   ## Set the the memory config address space
   set_bit $j2axi $mcr_address 5
   
   ## 
   set config0_address 00000000
   return [read32 $j2axi $config0_address]
}


rpc_get_CSR $J2AXI
rpc_get_IEN $J2AXI
rpc_get_ISR $J2AXI
rpc_get_ICR $J2AXI
rpc_get_MBR $J2AXI
rpc_get_MCR $J2AXI
rpc_get_MTR $J2AXI
rpc_get_GPOR $J2AXI
rpc_get_WPR  $J2AXI
rpc_get_LBR  $J2AXI
rpc_get_TAR  $J2AXI

rpc_get_CSR $J2AXI
rpc_get_ISR $J2AXI
rpc_get_MBR $J2AXI

rpc_get_MCR $J2AXI
rpc_set_MCR $J2AXI 00000010
rpc_get_MCR $J2AXI

rpc_get_MTR $J2AXI
rpc_set_MTR $J2AXI 00000001
rpc_get_MTR $J2AXI

set MEM_BAR 80000000
write32 $J2AXI ${MEM_BAR} 00000000
read32 $J2AXI ${MEM_BAR}

rpc_set_MTR $J2AXI 22000001


for {set i 0} {$i < 16} {incr i} {
	set address [expr $MEM_BAR + 4 * $i]
    write32 $J2AXI ${address} $i
    #puts "Writing at address : ${address}; Data : $i" 

}

for {set i 0} {$i < 16} {incr i} {
	set address [expr $MEM_BAR + 4 * $i]
    set value [read32 $J2AXI ${address}]
    #set value deadbeef
    puts "Reading at address : ${address}; Data : $value" 

}


for {set i 0} {$i < 16} {incr i} {
	set address [expr $MEM_BAR + 4 * $i]
    write32 $J2AXI ${address} $i
    set value [read32 $J2AXI ${address}]
    send_msg_id {USER 00-007} "INFO" "Reading at address : ${address}; Data : $value" 

}




   create_hw_axi_txn write_txn ${J2AXI} -quiet -type WRITE -address 800000000 -len 4 -data {00000000_11111111_22222222_33333333} -force
   run_hw_axi -quiet [get_hw_axi_txns write_txn]

set ADDR 8000cd00
write32 $J2AXI ${ADDR} deadbeef
read32  $J2AXI ${ADDR}


write32 $J2AXI 80000000 aaaaaaaa
read32  $J2AXI 80000000
write32 $J2AXI 80000000 55555555
read32  $J2AXI 80000000
write32 $J2AXI 80000000 ffffffff
read32  $J2AXI 80000000
write32 $J2AXI 80000000 00000000
read32  $J2AXI 80000000
write32 $J2AXI 80000004 00000004
read32  $J2AXI 80000004
write32 $J2AXI 80000008 00000008
read32  $J2AXI 80000008
write32 $J2AXI 8000000c 0000000c
read32  $J2AXI 8000000c
write32 $J2AXI 80000010 00000010
read32  $J2AXI 80000010
write32 $J2AXI 80fffffc ff00ff00
read32  $J2AXI 80fffffc
write32 $J2AXI 80fffffc 00ff00ff
read32  $J2AXI 80fffffc









