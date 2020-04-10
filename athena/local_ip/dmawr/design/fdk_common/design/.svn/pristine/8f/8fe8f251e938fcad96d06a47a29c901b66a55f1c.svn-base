----------------------------------------------------------------------
--  $HeadURL: svn://brainstorm/svn_ipcore/trunk/Matrox/Imaging/FDK/hw/cores/common/design/stream_shift_left.vhd $
--  $Revision: 8742 $
--  $Date: 2009-03-25 08:41:08 -0400 (Wed, 25 Mar 2009) $
--  $Author: palepin $
--
--  Description             : stream left shift module
--
--  Functionality           :
--
--  Generics Description    :
--
--
--  Note: si_context follows LSB of corresponding si_data
--
-----------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all; 
  use ieee.std_logic_unsigned.all;
  use ieee.std_logic_arith.all;

entity stream_shift_left is
  generic (

    S_DATA_WIDTH              : integer := 64  ;       -- width of s*_data signal: 64, 128, etc.
    S_CONTEXT_WIDTH           : integer := 0           -- width of s*_context signals

  );
  port (

    ----------------------------------------------------
    -- Reset, clock and mode signals
    ----------------------------------------------------
    sysrstN                   : in        std_logic;
    sysclk                    : in        std_logic;
    byteshift                 : in        integer;     -- byteshift = conv_integer(byteshift_slv), where byteshift_slv = std_logic_vector(log2(S_DATA_WIDTH/8)-1 downto 0)
    ----------------------------------------------------
    -- input stream
    ----------------------------------------------------
    si_write                  : in        std_logic;
    si_sync                   : in        std_logic_vector(1 downto 0);
    si_data                   : in        std_logic_vector(S_DATA_WIDTH-1 downto 0);
    si_beN                    : in        std_logic_vector(S_DATA_WIDTH/8-1 downto 0);
    si_wait                   : buffer    std_logic;
    si_flush                  : in        std_logic := '0';
    si_context                : in        std_logic_vector(S_CONTEXT_WIDTH downto 1) := (others => '0'); -- range shifted by 1 to prevent negative index
    ----------------------------------------------------
    -- output stream
    ----------------------------------------------------
    so_write                  : buffer    std_logic;
    so_sync                   : buffer    std_logic_vector(1 downto 0);
    so_data                   : buffer    std_logic_vector(S_DATA_WIDTH-1 downto 0);
    so_beN                    : buffer    std_logic_vector(S_DATA_WIDTH/8-1 downto 0);
    so_wait                   : in        std_logic;
    so_context                : buffer    std_logic_vector(S_CONTEXT_WIDTH downto 1) := (others => '0')  -- range shifted by 1 to prevent negative index

  );
end stream_shift_left;


architecture functional of stream_shift_left is


  -----------------------------------------------------
  --  AndN
  --  Function making an AND of a group of signals.
  -----------------------------------------------------

  function AndN (arg: std_logic_vector) return std_logic is
    variable result : std_logic;
  begin
    result := '1';

    for i in arg'range loop
      result := result and arg(i);
    end loop;

    return result;
  end AndN;


  -----------------------------------------------------
  -- bo2sl
  -- boolean to std_logic
  -----------------------------------------------------
  function bo2sl     ( s                  : boolean         
                     ) return               std_logic is

  begin
    case s is
      when false => return '0';
      when true  => return '1';
    end case;
  end bo2sl;


  -----------------------------------------------------
  -- signals
  -----------------------------------------------------

  signal si_sync_del               : std_logic_vector(1 downto 0);
  signal si_context_del            : std_logic_vector(S_CONTEXT_WIDTH downto 1);
  signal si_write_del              : std_logic;
  signal si_data_del               : std_logic_vector(S_DATA_WIDTH-1 downto 0);
  signal si_data_cat               : std_logic_vector(S_DATA_WIDTH-1 downto 0);
  signal si_beN_del                : std_logic_vector(S_DATA_WIDTH/8-1 downto 0);
  signal si_beN_cat                : std_logic_vector(S_DATA_WIDTH/8-1 downto 0);
  signal so_sof_byteshift          : std_logic;
  signal so_sol_byteshift          : std_logic;
  signal so_eol_byteshift          : std_logic;
  signal so_eof_byteshift          : std_logic;



begin



-------------------------------------------------------------------------------
-- clocked events
-------------------------------------------------------------------------------
process (sysrstN, sysclk)
   
begin  

  ----------
  -- reset
  ----------
  if (sysrstN = '0') then

    si_sync_del             <= (others => '0');
    si_context_del          <= (others => '0');
    so_sof_byteshift        <= '0';
    si_write_del            <= '0';
    si_data_del             <= (others => '0');
    si_beN_del              <= (others => '1');
    so_eof_byteshift        <= '0';


  elsif (sysclk'event and sysclk = '1') then                                         

    
    -----------------
    -- si_sync_del
    -- FLOPPED
    -----------------
    if (so_wait = '0' and so_write = '1' and so_sync(1) = '0') then -- sync = 00 (SOF) or 01 (EOL)
      si_sync_del  <= "10"; -- continue 
    elsif (so_wait = '0' and si_write = '1') then
      si_sync_del  <= si_sync;
    elsif (so_wait = '0' and so_write = '1' and so_sync = "11") then -- sync = 11 (EOF)
      si_sync_del  <= "00"; -- sof 
    else                                                                                                             
      si_sync_del  <= si_sync_del;
    end if;


    -----------------
    -- si_context_del
    -- FLOPPED
    -----------------
    if (so_wait = '0' and si_write = '1') then
      si_context_del <= si_context;
    else                                                                                                             
      si_context_del <= si_context_del;
    end if;


    -----------------
    -- si_write_del
    -- FLOPPED
    -----------------
    if (si_flush = '1' or
        byteshift = 0
       ) then
      si_write_del <= '0';
    elsif (so_wait = '1' or
           (si_write_del = '1' and si_sync_del /= "11" and so_write = '0')
          ) then
      si_write_del <= si_write_del;
    else                                                                                                             
      si_write_del <= si_write;
    end if;


    -----------------
    -- si_data_del
    -- FLOPPED
    -----------------
    if (si_wait = '0' and si_write = '1') then
      si_data_del <= si_data;
    else                                                                                                             
      si_data_del <= si_data_del;
    end if;
    

    -----------------
    -- si_beN_del
    -- FLOPPED
    -----------------
    if (si_flush = '1' and si_write = '0' and so_wait = '0') then
      si_beN_del <= (others => '1');
    elsif (si_wait = '0' and si_write = '1') then
      si_beN_del <= si_beN;
    else                                                                                                             
      si_beN_del <= si_beN_del;
    end if;
    

    -----------------
    -- so_sof_byteshift
    -- FLOPPED
    -----------------
    so_sof_byteshift <= -- SET
                        (si_write and bo2sl(byteshift /= 0) and bo2sl(si_sync = "00") and not so_wait and not so_sof_byteshift)
                        or (
                        -- RESET
                        not (not so_wait)
                        -- SAME VALUE
                        and so_sof_byteshift
                        );


    -----------------
    -- so_eof_byteshift
    -- FLOPPED
    -----------------
    so_eof_byteshift <= -- SET
                        (si_write and bo2sl(byteshift /= 0) and bo2sl(si_sync = "11") and not so_wait and not so_eof_byteshift)
                        or (
                        -- RESET
                        not (not so_wait)
                        -- SAME VALUE
                        and so_eof_byteshift
                        );


  end if;

end process;






  -----------------
  -- si_wait
  -----------------
  si_wait <= (si_write and 
              (so_wait or
               so_eol_byteshift or
               (bo2sl(byteshift /= 0) and bo2sl(si_sync = "00") and not so_sof_byteshift) or 
               (bo2sl(byteshift /= 0) and bo2sl(si_sync = "11") and not so_eof_byteshift)    
              )
             ) or
             (si_flush and so_wait);


  -----------------
  -- so_eol_byteshift
  -----------------
  so_eol_byteshift <= bo2sl(byteshift /= 0) and not si_sync(1) and si_sync_del(1);


  -----------------
  -- so_sol_byteshift
  -----------------
  so_sol_byteshift <= bo2sl(byteshift /= 0) and 
                      ((not si_sync(1) and not si_sync_del(1)) or
                       so_sof_byteshift
                      );


  -----------------
  -- si_data_cat
  -----------------
  gen_si_data_cat : for i in S_DATA_WIDTH/8 - 1 downto 0 generate
  begin

    si_data_cat(i*8+7 downto i*8) <= si_data(i*8+7 downto i*8) when (i + byteshift < S_DATA_WIDTH/8)
                                     else si_data_del(i*8+7 downto i*8);

  end generate gen_si_data_cat; 


  -----------------
  -- si_beN_cat
  -----------------
  gen_si_beN_cat : for i in S_DATA_WIDTH/8 - 1 downto 0 generate
  begin

    si_beN_cat(i) <= (si_beN(i) or so_eol_byteshift or so_eof_byteshift) when (i + byteshift < S_DATA_WIDTH/8)
                      else (si_beN_del(i) or so_sol_byteshift or so_eof_byteshift);

  end generate gen_si_beN_cat; 


  ---------------
  -- so_data (shift)
  ---------------
  gen_so_data : for i in so_data'range generate
  begin

    so_data(i) <= si_data_cat((i + so_data'length - byteshift*8) mod so_data'length);

  end generate gen_so_data; 


  ---------------
  -- so_beN (shift)
  ---------------
  gen_so_beN : for i in so_beN'range generate
  begin

    so_beN(i) <= si_beN_cat((i + so_beN'length - byteshift) mod so_beN'length);

  end generate gen_so_beN; 


  ---------------
  -- so_sync
  ---------------
  so_sync <= si_sync when (byteshift = 0) else si_sync_del;


  -----------------
  -- so_context
  -----------------
  so_context <= si_context when (byteshift = 0) else si_context_del;


  ---------------
  -- so_write
  ---------------
  so_write <= -- byteshift = 0
              (bo2sl(byteshift = 0) and si_write) or 
              -- byteshift /= 0
              (bo2sl(byteshift /= 0) and si_write and si_write_del and not AndN(so_beN)) or
              (bo2sl(byteshift /= 0) and si_flush and not AndN(so_beN)) or 
              so_eof_byteshift;


end functional;


















