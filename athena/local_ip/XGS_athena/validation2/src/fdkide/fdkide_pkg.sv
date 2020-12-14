/****************************************************************************
 * fdkide_pkg.sv
 ****************************************************************************/

/**
 * Package: fdkide_pkg
 * 
 * TODO: Add package documentation
 */
package fdkide_pkg;

	typedef class Cnode;
	typedef class Caddressable;
	typedef class Cfield;
	typedef class Cregister;
	typedef class Csection;
	typedef class Cexternal;
	
	`include "Cnode.svh"
	`include "Caddressable.svh"
	`include "Cfield.svh"
	`include "Cregister.svh"
	`include "Csection.svh"
	`include "Cexternal.svh"
	
endpackage


