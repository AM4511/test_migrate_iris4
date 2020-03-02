---------------------------------------------------------------------------------------
--  $HeadURL: svn://brainstorm/svn_ipcore/trunk/Matrox/Imaging/FDK/hw/cores/dmawr/design/dmawr_pack.vhd $
--  $Revision: 9279 $
--  $Date: 2009-06-17 18:51:23 -0400 (Wed, 17 Jun 2009) $
--  $Author: palepin $
--
--   Unite        :   package file for dma write module
--
--   Description  :   
--
---------------------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_unsigned.all;
  use ieee.std_logic_arith.all;


package dmawr_pack is


  ------------------------------------------------------------------------------
  -- IPHWVER : IP HardWare VERsion                  
  --
  -- This field indicates the functional hardware revision associated with the 
  -- current IP build. The hardware version is incremented for any new build that
  -- includes a functional change (bug fixes, performance issue, functionality, 
  -- etc). This field is reset to zero whenever the register structure minor or 
  -- major field is incremented. Note: when IPHWVER needs to be incremented and 
  -- value = 31, increment the register structure minor field (IPMNVER).
  --                            
  --                            
  --  History:                           
  --                            
  --  MJ.MN.HW     Description of changes
  --  ==========================================================================================
  --   1. 0. 1     Header structure 1.2
  --   1. 0. 2     Header structure 1.4
  --   1. 0. 3     support for cropping (hor.crop. disabled when LNSIZE = 0, 
  --               vert.crop. disabled when NBLINE = 0)
  --   1. 0. 4     support for single 128-bit bank (correction of a few bugs)
  --   1. 0. 5     modification to threshold logic
  --   1. 0. 6     added generic to control flopping of sw_wait signal
  --   1. 0. 7     corrected data corruption bug as seen in test5236 for pif
  --   1. 0. 8     added stream input fifo
  --   1. 0. 9     use new regfile
  --   1. 1. 0     increased LNPITCH width to 17 bits
  --   1. 1. 1     new regfile with modifications to byte enable logic
  --   1. 1. 2     no longer register incoming wait on sram write interface
  --   1. 1. 3     redesign including new modules stream_crop_core, stream_shift_core and ram_write_core
  --   1. 1. 4     corrected bug in stream_crop_core (cropping less than required)
  --   2. 0. 0     new subFID definitions
  --   2. 0. 1     new ram_write_core (no functional difference)
  --   2. 0. 2     new subFID definitions: 0x3, 0x4
  --   2. 1. 0     support for multi-context, modifications to registers, new subFID definitions: 0x5, 0x6
  --   2. 1. 1     increase SW_ADDR_WIDTH in dmawr_sdram_top to 32 (from 28)
  --   2. 1. 2     change threshold to 28
  --   2. 2. 0     increase lnpitch, lnsize, to 32bits
  --                            
  ------------------------------------------------------------------------------   
  constant IPHWVER         : integer := 0; -- max value = 31 (see note above)




  ------------------------------------------------------------------------------
  -- functions
  ------------------------------------------------------------------------------
  function log2             ( arg                   : integer         
                            ) return                  integer;

  function low               ( arg1                 : integer;        
                               arg2                 : integer         
                             ) return                 integer;

  function high              ( arg1                 : integer;        
                               arg2                 : integer         
                             ) return                 integer;

  function bo2sl            ( s                     : boolean         
                            ) return                  std_logic;

  function OrN              ( arg                   : std_logic_vector
                            ) return                  std_logic;

  function AndN             ( arg                   : std_logic_vector
                            ) return                  std_logic;



end dmawr_pack;






package body dmawr_pack is

  -----------------------------------------------------
  -- log2
  -----------------------------------------------------
  function log2             ( arg                   : integer         
                            ) return                  integer is

  variable result       : integer := 0;
  variable comparevalue : integer := 1;
  begin

    assert arg /= 0
      report "invalid arg value 0 in log2"
      severity FAILURE;

    while (comparevalue < arg) loop
      comparevalue := comparevalue * 2;
      result := result + 1;
    end loop;

    return result;
  end;


  -----------------------------------------------------
  -- low
  -----------------------------------------------------
  function low               ( arg1                 : integer;        
                               arg2                 : integer         
                             ) return                 integer is

  variable result : integer;
  begin

    if (arg1 < arg2) then
      result := arg1;
    else
      result := arg2;
    end if;

    return result;
  end;


  -----------------------------------------------------
  -- high
  -----------------------------------------------------
  function high              ( arg1                 : integer;        
                               arg2                 : integer         
                             ) return                 integer is

  variable result : integer;
  begin

    if (arg1 > arg2) then
      result := arg1;
    else
      result := arg2;
    end if;

    return result;
  end;


  -----------------------------------------------------
  -- bo2sl
  -- boolean to std_logic
  -----------------------------------------------------
  function bo2sl            ( s                     : boolean         
                            ) return                  std_logic is

  begin
    case s is
      when false => return '0';
      when true  => return '1';
    end case;
  end bo2sl;


  -----------------------------------------------------
  -- OrN
  -- Function making a OR of a group of signals.
  -----------------------------------------------------
  function OrN              ( arg                   : std_logic_vector
                            ) return                  std_logic is

  variable result : std_logic;
  begin
    result := '0';

    for i in arg'range loop
      result := result or arg(i);
    end loop;

    return result;
  end OrN;


  -----------------------------------------------------
  -- AndN
  -- Function making an AND of a group of signals.
  -----------------------------------------------------
  function AndN             ( arg                   : std_logic_vector
                            ) return                  std_logic is

  variable result : std_logic;
  begin
    result := '1';

    for i in arg'range loop
      result := result and arg(i);
    end loop;

    return result;
  end AndN;
  

end dmawr_pack;



