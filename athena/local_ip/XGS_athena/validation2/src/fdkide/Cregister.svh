/**
 * Class: Cregister
 * 
 * TODO: Add class documentation
 */
class Cregister extends Caddressable;
    longint data;
    
	function new(Cnode parent, string name, longint offset);
		super.new(parent, name, offset);
		this.data = 0;
	endfunction


endclass

