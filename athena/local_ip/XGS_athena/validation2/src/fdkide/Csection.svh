/****************************************************************************
 * Csection.svh
 ****************************************************************************/

/****************************************************************************
 * Cregister.svh
 ****************************************************************************/

/**
 * Class: Cregister
 * 
 * TODO: Add class documentation
 */
class Csection extends Caddressable;
    
	function new(Cnode parent, string name, longint offset);
		super.new(parent, name, offset);
	endfunction


endclass


