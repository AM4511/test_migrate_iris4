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
	Cnode children [$];
	
	// Constructor
	function new(Cnode parent, string name);
		this.name = name;
		this.parent = parent;
		if (parent != null) begin
			parent.children.push_back(this);
		end
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

	function Cnode get_root_node();
		Cnode n;
		
		// Recursion
		n = this.parent;
		while (n != null) begin
			n= this.parent.parent;
		end
		return n;
	endfunction


endclass


