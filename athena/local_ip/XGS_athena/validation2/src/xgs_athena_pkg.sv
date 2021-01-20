/****************************************************************************
 * xgs_athena_pkg.sv
 ****************************************************************************/

/**
 * Package: xgs_athena_pkg
 *
 * TODO: Add package documentation
 */

package xgs_athena_pkg;
	import core_pkg::*;
	import driver_pkg::*;
	
	//typedef class CImage;
	//`include "Cimage.sv"
	
	typedef class Cscoreboard;
	`include "Cscoreboard.svh"

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
	
endpackage : xgs_athena_pkg








