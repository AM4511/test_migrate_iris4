/****************************************************************************
 * Cregister.svh
 ****************************************************************************/

/**
 * Class: Cregister
 *
 * TODO: Add class documentation
 */
class Cregister extends Cnode;
	longint offset = 0;

	function new(string name = "", longint offset = 0);
		super.new(name);
		this.offset = offset;
	endfunction


endclass


