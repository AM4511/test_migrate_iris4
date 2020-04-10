/****************************************************************************
 * Cexternal.svh
 ****************************************************************************/

/**
 * Class: Cexternal
 *
 * TODO: Add class documentation
 */
class Cexternal extends Cnode;

	longint offset;

	function new(string name = "", longint offset = 0);
		super.new(name);
		this.offset=offset;
	endfunction

endclass


