---------------------------------------------------------------------------------------
-- $HeadURL: svn://brainstorm/svn_ipcore/trunk/Matrox/Imaging/FDK/hw/cores/common/design/std_logic_2d.vhd $
-- $Revision: 8578 $
-- $Date: 2009-02-25 16:16:40 -0500 (Wed, 25 Feb 2009) $
-- $Author: palepin $
--
--  Unite        :   Package using 2-D arrays of std_logic_vector types
--
--  Description  :   
--
---------------------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_arith.all;

package std_logic_2d is


  ------------------------------------------------------------------------------
  -- types
  ------------------------------------------------------------------------------
  type STD_LOGIC_ARRAY_2D is array (integer range <>, integer range <>) of std_logic;



  ------------------------------------------------------------------------------
  -- functions
  ------------------------------------------------------------------------------

  function array2slv        ( array_in              : STD_LOGIC_ARRAY_2D;
                              index                 : integer
                            ) return                  std_logic_vector;

  procedure slv2array       ( signal   arg_slv      : in std_logic_vector;
                              constant index        : in integer;
                              signal   result_array : out STD_LOGIC_ARRAY_2D
                            );

end std_logic_2d;







package body std_logic_2d is

  -----------------------------------------------------
  -- array2slv
  -----------------------------------------------------
  function array2slv        ( array_in              : STD_LOGIC_ARRAY_2D;
                              index                 : integer
                            ) return                  std_logic_vector is

  variable result : std_logic_vector(array_in'range(2));
  begin
    for i in array_in'range(2) loop
      result(i) := array_in(index, i);
    end loop;
    return result;
  end array2slv;

  -----------------------------------------------------
  -- slv2array
  -- result_array(index, range) <= arg_slv(range)
  -----------------------------------------------------
  procedure slv2array       ( signal   arg_slv      : in std_logic_vector;
                              constant index        : in integer;
                              signal   result_array : out STD_LOGIC_ARRAY_2D
                            ) is

  begin
    for i in arg_slv'range loop
      result_array(index, i) <= arg_slv(i);
    end loop;

  end procedure slv2array;




end std_logic_2d;





