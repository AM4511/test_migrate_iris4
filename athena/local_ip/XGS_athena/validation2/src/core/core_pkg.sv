/****************************************************************************
 * core_pkg.sv
 ****************************************************************************/

/**
 * Package: core_pkg
 *
 * TODO: Add package documentation
 */
package core_pkg;
	// this is a forward type definition (For the `include section below)
	typedef class CVlib;
	typedef class Cstatus;
	typedef class Ctest;

	`include "CVlib.svh"
	`include "Cstatus.svh"
	`include "Ctest.svh"

endpackage