/****************************************************************************
 * Cfield.svh
 ****************************************************************************/

/**
 * Class: Cfield
 * 
 * TODO: Add class documentation
 */
//import regfile_pack::Cregister;
//import fdkide_pkg::*;
class Cfield extends Cnode;
	int left;
	int right;
	int size;
	longint reset_value;
	int dirty;
	FDK_FIELD_TYPE field_type;
		
	function new(Cnode parent, string name, FDK_FIELD_TYPE field_type, int left, int right, longint reset_value = 0);
		super.new(parent, name);
		this.field_type = field_type;
		this.left = left;
		this.right = right;
		this.size = left-right+1;
		this.reset_value = reset_value;
		this.reset();
		this.dirty = 0;
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
		this.set_dirty();
	endfunction

	function void set_dirty(int dirty = 1);
		Cregister r;
		this.dirty = dirty;
		$cast(r, this.parent);
		if (r != null && this.dirty >0) begin
			r.dirty = 1;
		end
		
	endfunction

	function void reset();
		longint mask;
		Cregister parent_register;
		$cast(parent_register, parent);
		
		mask = (~(-1 << size)) << this.right;
		parent_register.data = (parent_register.data & ~mask) | ((this.reset_value<<this.right) & mask);
	endfunction
	


endclass


