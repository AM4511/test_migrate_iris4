----------------------------------------------------------------------
--  $HeadURL: svn://brainstorm/svn_ipcore/trunk/Matrox/Imaging/FDK/hw/cores/common/design/stream_packer_mux.vhd $
--  $Revision: 8445 $
--  $Date: 2009-02-11 19:07:39 -0500 (Wed, 11 Feb 2009) $
--  $Author: palepin $
--
--  DESCRIPTION: Stream Pack Multiplexer core module
--
--  contains the following modules:
--
--      stream_buffer_core
--
--
--  Functionality
--
--        
--
--
--  Generics Description:
--  =====================
--
--    NUMBER_OF_CONTEXTS   : (integer)  
--
--                           max number of contexts
--
--
--    S_DATA_WIDTH         : (integer)  
--
--                           width of s*_data signals: 64, 128, etc.
--
--
--
-- 
--  MODE        |                                       IN                                       |                                   OUT
-- ====================================================================================================================================================================
--              |                                                                                |
--  MODE_1C     |                                                            An-1 An-2 .. A1 A0  |                                                   An-1 An-2 .. A1 A0
--              |                                                                                |
--  MODE_2C_8   |                                         Bn-1 Bn-2 .. B1 B0 An-1 An-2 .. A1 A0  |                                   Bn-1 An-1 Bn-2 An-2 .. B1 A1 B0 A0
--              |                                                                                |
--  MODE_2C_16  |                                         Bn-1 Bn-2 .. B1 B0 An-1 An-2 .. A1 A0  |                                   Bn-1 Bn-2 An-1 An-2 .. B1 B0 A1 A0
--              |                                                                                |
--  MODE_3C_8   |                      Cn-1 Cn-2 .. C1 C0 Bn-1 Bn-2 .. B1 B0 An-1 An-2 .. A1 A0  |                   Cn-1 Bn-1 An-1 Cn-2 Bn-2 An-2 .. C1 B1 A1 C0 B0 A0
--              |                                                                                |   
--  MODE_3C_16  |                      Cn-1 Cn-2 .. C1 C0 Bn-1 Bn-2 .. B1 B0 An-1 An-2 .. A1 A0  |                   Cn-1 Cn-2 Bn-1 Bn-2 An-1 An-2 .. C1 C0 B1 B0 A1 A0
--              |                                                                                |
--  MODE_4C_8   |   Dn-1 Dn-2 .. D1 D0 Cn-1 Cn-2 .. C1 C0 Bn-1 Bn-2 .. B1 B0 An-1 An-2 .. A1 A0  |   Dn-1 Cn-1 Bn-1 An-1 Dn-2 Cn-2 Bn-2 An-2 .. D1 C1 B1 A1 D0 C0 B0 A0
--              |                                                                                |   
--  MODE_4C_16  |   Dn-1 Dn-2 .. D1 D0 Cn-1 Cn-2 .. C1 C0 Bn-1 Bn-2 .. B1 B0 An-1 An-2 .. A1 A0  |   Dn-1 Dn-2 Cn-1 Cn-2 Bn-1 Bn-2 An-1 An-2 .. D1 D0 C1 C0 B1 B0 A1 A0
--
-- 
--
-- add check S_DATA_WIDTH > ... ?
-----------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all; 
  use ieee.std_logic_unsigned.all;
  use ieee.std_logic_arith.all;

entity stream_packer_mux is
  generic (

    NUMBER_OF_CONTEXTS   : integer := 2         ; -- max number of contexts
    S_DATA_WIDTH         : integer := 64          -- width of s*_data signals: 64, 128, etc.

  );
  port (

    ----------------------------------------------------
    -- Mode
    ----------------------------------------------------
    bit_depth            : in        integer := 8;
    nb_contexts          : in        integer := 4;
    ----------------------------------------------------
    -- stream input port (slave)
    ----------------------------------------------------
    si_data              : in        std_logic_vector(S_DATA_WIDTH-1 downto 0);
    si_beN               : in        std_logic_vector(S_DATA_WIDTH/8 - 1 downto 0);
    ----------------------------------------------------
    -- stream output port (master)  
    ----------------------------------------------------
    so_data              : out       std_logic_vector(S_DATA_WIDTH-1 downto 0);
    so_beN               : out       std_logic_vector(S_DATA_WIDTH/8 - 1 downto 0)

  );
end stream_packer_mux;




architecture functional of stream_packer_mux is

  -----------------------------------------------------
  -- types
  -----------------------------------------------------
  type ARRAY_OF_INTEGER is array (integer range <>) of natural;
  type PACK_MODE_TYPE   is (MODE_1C, MODE_2C_8, MODE_2C_16, MODE_3C_8, MODE_3C_16, MODE_4C_8, MODE_4C_16);

  -----------------------------------------------------
  -- functions
  -----------------------------------------------------

  --  set_pack_mode
  function set_pack_mode     ( bit_depth   : integer;
                               nb_contexts : integer
                             ) return     PACK_MODE_TYPE is 
  begin

    -----------------------------------------------------------------
    --     nb_contexts         bit_depth                   pack_mode
    -----------------------------------------------------------------
    if    (nb_contexts = 2 and bit_depth =  8) then return MODE_2C_8;
    elsif (nb_contexts = 2 and bit_depth = 16) then return MODE_2C_16;
    elsif (nb_contexts = 3 and bit_depth =  8) then return MODE_3C_8;
    elsif (nb_contexts = 3 and bit_depth = 16) then return MODE_3C_16;
    elsif (nb_contexts = 4 and bit_depth =  8) then return MODE_4C_8;
    elsif (nb_contexts = 4 and bit_depth = 16) then return MODE_4C_16;
    else                                            return MODE_1C;
    end if;

  end set_pack_mode;


  -----------------------------------------------------
  -- constants
  -----------------------------------------------------
  constant S_DATA_BYTES             : integer := S_DATA_WIDTH/8;
  constant S_DATA_BYTES_PER_CONTEXT : integer := S_DATA_BYTES/NUMBER_OF_CONTEXTS;


  -----------------------------------------------------
  -- signals
  -----------------------------------------------------
  signal pack_mode              : PACK_MODE_TYPE;

  signal sel                    : ARRAY_OF_INTEGER(S_DATA_BYTES-1 downto 0);

--synthesis translate_off
  signal NUMBER_OF_CONTEXTS_signal       : integer := NUMBER_OF_CONTEXTS      ;
  signal S_DATA_WIDTH_signal             : integer := S_DATA_WIDTH            ;
  signal S_DATA_BYTES_signal             : integer := S_DATA_BYTES            ;
  signal S_DATA_BYTES_PER_CONTEXT_signal : integer := S_DATA_BYTES_PER_CONTEXT;
--synthesis translate_on

begin



pack_mode <= set_pack_mode(bit_depth, nb_contexts);



--------------------------------
-- generate process
--------------------------------
gen_mux : for b in S_DATA_BYTES-1 downto 0 generate

  ------------------
  -- sel
  ------------------
  sel(b) <= 
            -- MODE_1C
            b 
              when (pack_mode = MODE_1C and b < S_DATA_BYTES_PER_CONTEXT) or NUMBER_OF_CONTEXTS = 1 else

            -- MODE_2C_8
            b/2 + b mod 2 * S_DATA_BYTES_PER_CONTEXT 
              when pack_mode = MODE_2C_8 and b < 2*S_DATA_BYTES_PER_CONTEXT else

            -- MODE_2C_16
            (b/4)*2 + b mod 2 + b/2 mod 2 * S_DATA_BYTES_PER_CONTEXT
              when (pack_mode = MODE_2C_16 and b < 2*S_DATA_BYTES_PER_CONTEXT) or NUMBER_OF_CONTEXTS = 2 else

            -- MODE_3C_8
            b/3 + b mod 3 * S_DATA_BYTES_PER_CONTEXT 
              when pack_mode = MODE_3C_8 and b < 3*S_DATA_BYTES_PER_CONTEXT else

            -- MODE_3C_16
            (b/6)*2 + b mod 2 + b/2 mod 3 * S_DATA_BYTES_PER_CONTEXT
              when (pack_mode = MODE_3C_16 and b < 3*S_DATA_BYTES_PER_CONTEXT) or NUMBER_OF_CONTEXTS = 3 else

            -- MODE_4C_8
            b/4 + b mod 4 * S_DATA_BYTES_PER_CONTEXT 
              when pack_mode = MODE_4C_8 else

            -- MODE_4C_16
            (b/8)*2 + b mod 2 + b/2 mod 4 * S_DATA_BYTES_PER_CONTEXT;
              
              
  ------------------
  -- so_data
  -- use generate process to avoid synthesis error "left bound of range must be a constant"
  ------------------
  gen_so_data : for j in 7 downto 0 generate
  begin

    so_data(b*8 + j) <= si_data(sel(b)*8 + j);

  end generate gen_so_data; 


  ------------------
  -- so_beN
  ------------------
  so_beN(b) <= si_beN(sel(b));

end generate gen_mux; 


end functional;







