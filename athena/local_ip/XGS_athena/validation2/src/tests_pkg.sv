/****************************************************************************
 * test_pkg.sv
 ****************************************************************************/

/**
 * Package: tests_pkg
 *
 * TODO: Add package documentation
 */
package tests_pkg;
    
  `include "Ctest.svh"
  `include "./tests/test0001.svh"
  `include "./tests/test0002.svh"
  `include "./tests/test0003.svh"
  
  typedef class CTest;
  typedef class Test0001;
  typedef class Test0002;  
  typedef class Test0003;    



endpackage
