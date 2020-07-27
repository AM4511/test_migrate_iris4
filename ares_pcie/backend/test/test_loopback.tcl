rpc_set_LBR $J2AXI 00000001
rpc_get_LBR $J2AXI
for {set i 0} {$i < 2} {incr i} {

set MEM_BAR 80000004
    write32 $J2AXI ${MEM_BAR} dddddddd
    read32  $J2AXI ${MEM_BAR}
}

for {set i 0} {$i < 1} {incr i} {
	set address [expr $MEM_BAR + 4 * $i]
    send_msg_id {USER 00-007} "INFO" "Writing at address : ${address}; Data : $i" 
    write32 $J2AXI ${address} $i
   
    set value [read32 $J2AXI ${address}]
    send_msg_id {USER 00-007} "INFO" "Reading at address : ${address}; Data : $value" 
}


rpc_set_LBR $J2AXI 00000000
rpc_get_LBR $J2AXI
