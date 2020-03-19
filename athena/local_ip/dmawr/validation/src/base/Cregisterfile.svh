/****************************************************************************
 * Cregisterfile.svh
 ****************************************************************************/

/**
 * Class: Cregisterfile
 *
 * TODO: Add class documentation
 */
class Cregisterfile extends Cnode;
//	string name;
	int addrWidth;
	int dataWidth;
	int littleEndian;
	longint offset;

	function new(string name = "", longint offset = 0, int addrWidth = 10, int dataWidth=32, int littleEndian=1);
		super.new(name);
		this.addrWidth = addrWidth;
		this.dataWidth = dataWidth;
		this.littleEndian = littleEndian;
		this.offset = offset;
	endfunction


endclass


