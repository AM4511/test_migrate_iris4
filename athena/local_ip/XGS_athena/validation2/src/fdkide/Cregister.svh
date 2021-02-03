/**
 * Class: Cregister
 * 
 * TODO: Add class documentation
 */
class Cregister extends Caddressable;
    longint data;
    int dirty;
    
	function new(Cnode parent, string name, longint offset);
		super.new(parent, name, offset);
		this.data = 0;
		this.dirty = 0;
	endfunction

	function void clr_dirty();
		Cfield field;
		this.dirty = 0;
			foreach(children[i]) begin
				$cast(field, children[i]);
			    field.dirty = 0;
			end
	endfunction
endclass

