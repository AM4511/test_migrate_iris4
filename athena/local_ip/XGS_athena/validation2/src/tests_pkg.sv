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
  `include "./tests/test0004.svh"
  `include "./tests/test0005.svh"
  `include "./tests/test0006.svh"
  `include "./tests/test0007.svh"
  `include "./tests/test0008.svh"
  `include "./tests/test0009.svh"
  `include "./tests/test0010.svh"
  `include "./tests/test0020.svh"
  `include "./tests/test0021.svh"

  typedef class CTest;
  typedef class Test0001;
  typedef class Test0002;  
  typedef class Test0003;    
  typedef class Test0004;   
  typedef class Test0005; 
  typedef class Test0006;   
  typedef class Test0007;
  typedef class Test0008;
  typedef class Test0009;
  typedef class Test0010;
  typedef class Test0020;
  typedef class Test0021;  
endpackage
