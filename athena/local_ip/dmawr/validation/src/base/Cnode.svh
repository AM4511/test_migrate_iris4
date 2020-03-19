/****************************************************************************
 * Cnode.svh
 ****************************************************************************/

/**
 * Class: Cnode
 * 
 * TODO: Add class documentation
 */
class Cnode;
	Cnode parent;
	longint offset;

	function new(Cnode parent = null, longint offset=0);
		this.parent = parent;
		this.offset = offset;
	endfunction


	////////////////////////////////////////////////////////////////////////////////
	// FUNCTION NAME: getAddress(string childName)
	// DESCRIPTION:   Find a children node from its given name.
	// PARAMETERS:    string childName : Child name of the node
	// RETURN VALUE:  longint 
	////////////////////////////////////////////////////////////////////////////////
	function longint getAddress();
		longint address = offset;
		Cnode current_node = this.parent;
		while (current_node != null) begin
			address = address + current_node.offset;
			current_node = current_node.parent;
		end
		return address;
	endfunction

	////////////////////////////////////////////////////////////////////////////////
	// FUNCTION NAME: getChild(string childName)
	// DESCRIPTION:   Find a children node from its given name.
	// PARAMETERS:    string childName : Child name of the node
	// RETURN VALUE:  Cnode 
	////////////////////////////////////////////////////////////////////////////////
//	function Cnode getChild(string childName);
//
//		// Loop through each child until find the corresponding
//		foreach(this.childList[idx]) begin
//			if (this.childList[idx].name.compare(childName)) begin
//				return this.childList[idx];
//			end
//		end
//		return null;
//	endfunction


	////////////////////////////////////////////////////////////////////////////////
	// FUNCTION NAME: Cnode getNode(string nodePath)
	// DESCRIPTION:   Retrieve a node object from a path given as a string.
	// PARAMETERS:    string nodePath : the path as a string.
	// RETURN VALUE:  Cnode : a pointer to the found node. NULL if not found. 
	////////////////////////////////////////////////////////////////////////////////
	function Cnode getRootNode();
		Cnode parent_node = this.parent;
		while (parent_node != null) begin
			parent_node = parent_node.parent;
		end
		return parent_node;
	endfunction

	
	////////////////////////////////////////////////////////////////////////////////
	// FUNCTION NAME: string getFullPath()
	// DESCRIPTION:   Return the full path of the current node as a string.
	// PARAMETERS:    none
	// RETURN VALUE:  string
	////////////////////////////////////////////////////////////////////////////////
//	function string getFullPath();
//		string node_path = this.name;
//		Cnode parent_node = this.parent;
//		while (parent_node != null) begin
//			parent_node = parent_node.parent;
//			node_path = {this.name, "/", node_path};
//		end
//		return node_path;
//
//	endfunction


	////////////////////////////////////////////////////////////////////////////////
	// FUNCTION NAME: Cnode getNode(string nodePath)
	// DESCRIPTION:   Retrieve a node object from a path given as a string.
	// PARAMETERS:    string nodePath : the path as a string.
	// RETURN VALUE:  Cnode : a pointer to the found node. NULL if not found. 
	////////////////////////////////////////////////////////////////////////////////
	//	function Cnode getNode(string nodePath);
	//		Cnode currentNode;
	//		return currentNode;
	//	endfunction
	//	

	////////////////////////////////////////////////////////////////////////////////
	// FUNCTION NAME: void CfdkNode::printInfo()
	// DESCRIPTION:   Print in the console informations about the current node.
	// PARAMETERS:    void
	// RETURN VALUE:  void
	// REMARKS:       
	////////////////////////////////////////////////////////////////////////////////
//	function Cnode getNode(string path);
//		Cnode currentNode = this;
//		Cnode target_node = null;
//		string path_token[$];
//		string del = "/";
//		string token;
//		int start = 0;
//		int stop = 0;
//		
//		// Trim the white spaces from the path, just in case...
//		string str = trim(path);
//		
//		// Extract path segments from the 
//		for (int i = 0; i < str.len(); i=i+1) begin	
//			if (str.getc(i) == del) begin
//				// Search path start at the root node
//				if (i==0) begin
//					currentNode = getRootNode();
//				end
//				// Search path start at the current node
//				else if (i > start ) begin
//					token = str.substr(start,i-1);
//					path_token.push_back(token);
//				end		
//				start = i+1;
//			end
//		end

		//		foreach (path_token[token]) begin
		//			if (! currentNode.name.compare(path_token[token].name)) begin
		//				return null;
		//			end
		//		end 
		
//		return currentNode;
//	endfunction
	
	
//	function string trim(string str);
//		// Stripping the front spaces from the string :
//		while (str.substr(0,0) == " ") begin
//			str = str.substr(1, str.len()-1);
//		end
//		
//		// Stripping the trail spaces from the string :
//		while (str.substr(str.len()-1, str.len()-1) == " ") begin
//			str = str.substr(0, str.len()-2); 
//		end
//		return str;
//	endfunction

endclass


