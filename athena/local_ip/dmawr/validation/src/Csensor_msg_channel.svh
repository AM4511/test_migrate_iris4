/****************************************************************************
 * Csensor_msg_channel.svh
 ****************************************************************************/

/**
 * Class: Csensor_msg_channel
 * 
 * TODO: Add class documentation
 */
class Csensor_msg_channel extends CmsgChannel;

	function new(int max_msg_pending=1);
		super.new(max_msg_pending);

	endfunction

	task send_frame(Cimage image);
		CmsgSendFrame msg;
		
		msg = new(this.message_id, image);
		cmd_mbx.put(msg);
		this.message_id++;
	endtask


endclass


