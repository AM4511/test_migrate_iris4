/****************************************************************************
 * Cnode.svh
 ****************************************************************************/

/**
 * Class: Cnode
 * 
 * TODO: Add class documentation
 */
class Cnode;
	string name;
	Cnode parent;
	
	function new(Cnode parent, string name);
		this.name = name;
		this.parent = parent;
	endfunction

	function string get_path();
		string path;
		
		// If we are a root node (no parent)
		if (parent == null) begin
			path = {"/",this.name};
		end 
		// If parent is of  type Caddressable
		else begin
			path = {parent.get_path(),"/",this.name};
		end	

		return path;
	endfunction

endclass


