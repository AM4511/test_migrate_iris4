/****************************************************************************
 * CmsgWrite.svh
 ****************************************************************************/

/**
 * Class: CmsgWrite
 * 
 * TODO: Add class documentation
 */
import image_pkg::*;

class CmsgSendFrame extends Cmessage;
	Cimage image;
	function new(int id = -1, Cimage image);
		super.new(id);
		this.image=image;
	endfunction

endclass


