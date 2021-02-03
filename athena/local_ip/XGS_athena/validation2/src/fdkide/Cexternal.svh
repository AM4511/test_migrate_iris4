/****************************************************************************
 * Csection.svh
 ****************************************************************************/

/****************************************************************************
 * Cregister.svh
 ****************************************************************************/
class Cexternal extends Caddressable;
    
	function new(Cnode parent, string name, longint offset);
		super.new(parent, name,offset);
	endfunction


endclass


