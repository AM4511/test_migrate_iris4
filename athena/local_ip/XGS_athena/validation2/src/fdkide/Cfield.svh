/****************************************************************************
 * Cfield.svh
 ****************************************************************************/

/**
 * Class: Cfield
 * 
 * TODO: Add class documentation
 */
 //import regfile_pack::Cregister;
 
class Cfield extends Cnode;
	int left;
	int right;
	int size;
	longint reset_value;
	
	function new(Cnode parent, string name, int left, int right, longint reset_value = 0);
		super.new(parent, name);
		this.left = left;
		this.right = right;
		this.size = left-right+1;
		this.reset_value = reset_value;
		this.reset();
	endfunction

	function void reset();
		this.set(reset_value);
	endfunction
	
	function longint get();
		longint value;
		longint mask;
		Cregister parent_register;
		$cast(parent_register, parent);
		mask = ~(-1 << this.size);
		value = (parent_register.data>>right) & mask;
		return value;
	endfunction
	
	function void set(longint value = 0);
		longint value2;
		longint mask;
		Cregister parent_register;
		$cast(parent_register, parent);
		
		mask = (~(-1 << size)) << this.right;
		value2 = (parent_register.data & ~mask) | ((value<<this.right) & mask);
		parent_register.data = value2;
	endfunction

endclass


