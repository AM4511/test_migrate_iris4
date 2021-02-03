/****************************************************************************
 * Cnode.svh
 ****************************************************************************/

/**
 * Class: Caddressable
 * 
 * TODO: Add class documentation
 */
class Caddressable extends Cnode;
	longint offset;

	function new(Cnode parent, string name, longint offset = 0);
		super.new(parent, name);
	    
		this.offset = offset;
	endfunction

	function longint get_address();
		longint address;
		Caddressable addressable_parent;
		
		// If we are a root node (no parent)
		if (parent == null) begin
			address = this.offset;
		end 
		// If parent is of  type Caddressable
		else if($cast(addressable_parent, parent)) begin
			// Our address is parent address plus our offset from parent
			address = addressable_parent.get_address() + this.offset;
		end	
		else begin
			$error("FDKIDE : Parent node is not type of Caddressable");
			address = -1;
		end

		return address;
	endfunction

endclass


