--*****************************************************************************
--  $Source: J:/IRIS/FPGA/RCS_DATABASE/rcs/Spider_pak.vhd $
--  $Revision: 1.3 $
--  $Date: 2005/10/07 17:57:01 $
--  $Author: jlarin $
--
--   Project      :   Iris3 (Ares)
--
--   Unit         :   Spider_pak
--
--   Description  :   This file is used for type definition for spider submodule
--                    it is used to generate the project specific redirection
--                    of type on project specific register file
--
--   Change History:
--   Date       Initials    Description
--   
--*****************************************************************************

library ieee;
   use ieee.std_logic_1164.all;
   --use ieee.std_logic_arith.all;
   use work.regfile_ares_pack.all; -- nos definition de type vienne du registe file global


package Spider_pak is

  function log2(arg: integer) return integer;
  function OrN (arg: std_logic_vector) return std_logic;

  ---------------------------------------------------------------------------------
  -- REGISTERFILE TYPES
  ---------------------------------------------------------------------------------
  alias OUTPUTCONDITIONING_TYPE             is  work.regfile_ares_pack.OUTPUTCONDITIONING_TYPE;
  alias INIT_OUTPUTCONDITIONING_TYPE        is  work.regfile_ares_pack.INIT_OUTPUTCONDITIONING_TYPE;

  alias INPUTCONDITIONING_TYPE              is  work.regfile_ares_pack.INPUTCONDITIONING_TYPE;
  alias INIT_INPUTCONDITIONING_TYPE         is  work.regfile_ares_pack.INIT_INPUTCONDITIONING_TYPE;

  alias QUADRATURE_TYPE                     is  work.regfile_ares_pack.QUADRATURE_TYPE;
  alias INIT_QUADRATURE_TYPE                is  work.regfile_ares_pack.INIT_QUADRATURE_TYPE;

  alias TickTable_TYPE                      is  work.regfile_ares_pack.TickTable_TYPE;
  alias INIT_TICKTABLE_TYPE                 is  work.regfile_ares_pack.INIT_TICKTABLE_TYPE;
  alias TICKTABLE_INPUTSTAMP_TYPE_ARRAY     is  work.regfile_ares_pack.TICKTABLE_INPUTSTAMP_TYPE_ARRAY;

  alias Timer_TYPE                          is  work.regfile_ares_pack.Timer_TYPE;
  alias INIT_Timer_TYPE                     is  work.regfile_ares_pack.INIT_Timer_TYPE;

  alias IO_TYPE                             is  work.regfile_ares_pack.IO_TYPE;
  alias INIT_IO_TYPE                        is  work.regfile_ares_pack.INIT_IO_TYPE;

  alias ANALOGOUTPUT_TYPE                   is  work.regfile_ares_pack.ANALOGOUTPUT_TYPE;
  alias INIT_ANALOGOUTPUT_TYPE              is  work.regfile_ares_pack.INIT_ANALOGOUTPUT_TYPE;

  -- parce qu'on utilise seulement une instantiation de certains items, il faut patcher une limitation du FDK en generant des array de 1
  ------------------------------------------------------------------------------------------
  -- Array type: TICKTABLE_TYPE
  ------------------------------------------------------------------------------------------
  --type TICKTABLE_TYPE_ARRAY is array (0 downto 0) of TICKTABLE_TYPE;
  --constant INIT_TICKTABLE_TYPE_ARRAY : TICKTABLE_TYPE_ARRAY := (others => INIT_TICKTABLE_TYPE);

  --type QUADRATURE_TYPE_ARRAY is array (0 downto 0) of QUADRATURE_TYPE;
  --constant INIT_QUADRATURE_TYPE_ARRAY : QUADRATURE_TYPE_ARRAY := (others => INIT_QUADRATURE_TYPE);

  -- version pour le core PCIe.  Dans un monde ideal, il faudrait que ca se mappe tout seul avec la grandeur des vecteurs branche dessus. En fait, ca depend du core PCIe genere
  -- alors si on pouvait extraire ces generique du core sous-jacent, ca serait ideal.
  constant REG_ADDRLSB      : integer := 2;   -- 32 bits (4 bytes) granularity
  constant REG_ADDRMSB      : integer := 14;  -- 32k BAR0
    
end Spider_pak;

package body Spider_pak is

  ----------------------------------------------------------------------------
  --  log2 function
  ----------------------------------------------------------------------------
  function log2(arg: integer) return integer is
    variable tmp  : integer;
    variable tmp1 : integer;
  begin
    tmp  := arg;
    tmp1 := arg;
    if (arg=0 or arg=1) then
      return (0);
    else
      for i in 1 to 256 loop
        tmp  := tmp/2;
        tmp1 := tmp1 mod 2;
        if (((tmp = 1) and (tmp1 = 0)) or (tmp = 0)) then
          return(i);
        else
          tmp1 := tmp;
        end if;
      end loop;
    end if;
  end log2;

  -----------------------------------------------------------------------------
  -- Function making a OR of a group of signals
  -----------------------------------------------------------------------------
  function OrN (arg: std_logic_vector) return std_logic is
    variable result : std_logic;
  begin
    result := '0';

    for i in arg'range loop
      result := result or arg(i);
    end loop;

    return result;
  end OrN;

end Spider_pak;



