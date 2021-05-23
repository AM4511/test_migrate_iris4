########################################################################
#
########################################################################
#
state S_START_OF_PACKET:
  ###################################################
  # Detect start of packet
  ###################################################
  if ((ares_pb_i/ares_pb_i/system_ila_0/U0/net_slot_1_axis_tvalid == 1'b1) && (ares_pb_i/ares_pb_i/system_ila_0/U0/net_slot_1_axis_tready == 1'b1) && (ares_pb_i/ares_pb_i/system_ila_0/U0/net_slot_1_axis_tdata == 32'h0AFC2000))  then
    goto S_END_OF_PACKET;
    #trigger;

	
  ###################################################
  # Else wait for next packet
  ###################################################
  else
    goto S_START_OF_PACKET;
  endif
	    		

state S_END_OF_PACKET:

  if (ares_pb_i/ares_pb_i/system_ila_0/U0/net_slot_1_axis_tlast == 1'bR) then
    goto S_START_OF_PACKET;

  elseif ((ares_pb_i/ares_pb_i/system_ila_0/U0/net_slot_1_axis_tvalid == 1'b1) && (ares_pb_i/ares_pb_i/system_ila_0/U0/net_slot_1_axis_tready == 1'b1) && (ares_pb_i/ares_pb_i/system_ila_0/U0/net_slot_1_axis_tdata == 32'h00000000))  then
    trigger;
  else
    goto S_END_OF_PACKET;
  endif
  