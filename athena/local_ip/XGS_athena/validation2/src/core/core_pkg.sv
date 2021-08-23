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
	typedef class Cimage;
	typedef class Cscoreboard;
	typedef class Cstatus;
	typedef class Ctest;
	typedef class Cvlib;

	`include "Cimage.svh"
	`include "Cscoreboard.svh"
	`include "Cstatus.svh"
	`include "Ctest.svh"
	`include "Cvlib.svh"
	
	//Grab SOURCE
	const int IMMEDIATE=1; 
	const int HW_TRIG=2; 
	const int SW_TRIG=3; 
	const int SFNC=4; 
    
	//Grab ACTivation
	const int NONE=0; 
	const int RISING=0; 
	const int FALLING=1; 
	const int ANY=2; 
	const int LEVEL_HI=3; 
	const int LEVEL_LO=4;
endpackage : core_pkg