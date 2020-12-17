/****************************************************************************
 * test_pkg.sv
 ****************************************************************************/

/**
 * Package: tests_pkg
 *
 * TODO: Add package documentation
 */
package tests_pkg;
    
	typedef class Test0001;
	typedef class Test0002;  
	typedef class Test0003;  
	typedef class Test2000;  
	typedef class Test9999;  
	
	`include "test0001.svh"
	`include "test0002.svh"
	`include "test0003.svh"
	`include "test2000.svh"
	`include "test9999.svh"
  



endpackage
