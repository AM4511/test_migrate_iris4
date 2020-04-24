----------------------------------------------------------------------
--  $HeadURL: svn://brainstorm/svn_ipcore/trunk/Matrox/Imaging/FDK/hw/cores/common/design/stream_resize_down.vhd $
--  $Revision: 9244 $
--  $Date: 2009-06-11 11:45:04 -0400 (Thu, 11 Jun 2009) $
--  $Author: palepin $
--
--  DESCRIPTION: Stream resize (scale DOWN) module
--
--  Functionality
--
--  The ABORT signal forces a reset of the logic. When '1', all signals on the stream 
--  input interface are ignored and the si_wait signal goes to '0'.
--  Furthermore no new transaction is initiated on the stream output interface.
--  Note that a transaction that was already initiated on the stream output port will 
--  be completed, meaning that if a transaction is being held by an active wait, it will 
--  be held until the wait signal (so_wait) is disactivated by the destination. 
-- 
--  The so_active signal indicates that there is an active outstanding master 
--  transaction on the stream output interface. Master transactions being held by an 
--  active wait will cause the so_active to stay at 1, regardless of the state of the 
--  ABORT signal. As long as the so_active signal is '1', The IP's ACTIVE signal should 
--  stay at '1'.
--
-- 
--  Note: si_wait can go to 1 even if si_write = 0
--        
--
--
--  Generics Description:
--  =====================
--
--    SI_DATA_WIDTH        : (integer)  
--
--                           width of si_data signal: 64, 128, etc.
--
--
--
--    SI_CONTEXT_WIDTH     : (integer)  
--
--                           width of si_context signal
--
--
--
--    SO_DATA_WIDTH        : (integer)
--
--                           width of so_data signal: 64, 128, etc.
--
--
--
-- 
-- 
--
-----------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all; 
  use ieee.std_logic_unsigned.all;
  use ieee.std_logic_arith.all;

entity stream_resize_down is
  generic (

    SI_DATA_WIDTH        : integer := 64        ; -- width of si_data signal: 64, 128, etc.
    SI_CONTEXT_WIDTH     : integer := 0         ; -- width of si_context signal
    SO_DATA_WIDTH        : integer := 64          -- width of so_data signal: 64, 128, etc.

  );
  port (

    ----------------------------------------------------
    -- Reset, clock and mode signals
    ----------------------------------------------------
    sysrstN              : in        std_logic;
    sysclk               : in        std_logic;
    ABORT                : in        std_logic := '0';
    region_of_interest   : in        integer range 1 to SI_DATA_WIDTH/SO_DATA_WIDTH := SI_DATA_WIDTH/SO_DATA_WIDTH; -- region_of_interest / (SI_DATA_WIDTH/SO_DATA_WIDTH) = portion of input stream to pass (starting with LSB)
    ----------------------------------------------------
    -- stream input port (slave)
    ----------------------------------------------------
    si_write             : in        std_logic;
    si_sync              : in        std_logic_vector(1 downto 0);
    si_data              : in        std_logic_vector(SI_DATA_WIDTH-1 downto 0);
    si_beN               : in        std_logic_vector(SI_DATA_WIDTH/8 - 1 downto 0);
    si_wait              : out       std_logic;
    si_context           : in        std_logic_vector(SI_CONTEXT_WIDTH downto 1) := (others => '0'); -- range shifted by 1 to prevent negative index
    ----------------------------------------------------
    -- stream output port (master)  
    ----------------------------------------------------
    so_write             : out       std_logic;
    so_sync              : out       std_logic_vector(1 downto 0);
    so_data              : out       std_logic_vector(SO_DATA_WIDTH-1 downto 0);
    so_beN               : out       std_logic_vector(SO_DATA_WIDTH/8 - 1 downto 0);
    so_wait              : in        std_logic;
    so_context           : out       std_logic_vector(SI_CONTEXT_WIDTH*SO_DATA_WIDTH/SI_DATA_WIDTH downto 1) := (others => '0'); -- range shifted by 1 to prevent negative index
    so_active            : out       std_logic

  );
end stream_resize_down;




architecture functional of stream_resize_down is

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

  signal si_write_ff            : std_logic;
  signal si_sync_ff             : std_logic_vector(1 downto 0);
  signal si_data_ff             : std_logic_vector(SI_DATA_WIDTH-1 downto 0);
  signal si_beN_ff              : std_logic_vector(SI_DATA_WIDTH/8 - 1 downto 0);
  signal si_wait_int            : std_logic;

  signal so_write_int           : std_logic;
  signal so_write_out           : std_logic;
  signal so_write_stretch       : std_logic;
  signal so_sync_out            : std_logic_vector(1 downto 0);
  signal so_sync_sol            : std_logic_vector(1 downto 0);
  signal force_so_sync_sol      : std_logic;
  signal so_data_out            : std_logic_vector(SO_DATA_WIDTH-1 downto 0);
  signal so_beN_out             : std_logic_vector(SO_DATA_WIDTH/8 - 1 downto 0);

  signal si_context_ff          : std_logic_vector(si_context'range);
  signal so_context_out         : std_logic_vector(so_context'range);

  -- bus width mismatch signals
  signal i                      : integer range 0 to SI_DATA_WIDTH/SO_DATA_WIDTH-1 := 0;

  
begin


-------------------------------------------------
-- Verifications
-------------------------------------------------

--synthesis translate_off

  -------------------------------------
  -- region_of_interest /= 0
  -------------------------------------
  assert region_of_interest /= 0
    report "region_of_interest cannot be 0 in stream_resize_down module"
    severity FAILURE;


--synthesis translate_on



  -------------------------------------------------------------------------------
  -- clocked events
  -------------------------------------------------------------------------------
  process (sysrstN, sysclk)
  
  begin  

    ----------
    -- reset
    ----------
    if (sysrstN = '0') then

      si_write_ff           <= '0';
      si_sync_ff            <= (others => '0');
      si_data_ff            <= (others => '0');
      si_beN_ff             <= (others => '0');
      si_context_ff         <= (others => '0');
      i                     <= 0;
      so_sync_out           <= (others => '0');
      so_sync_sol           <= (others => '0');
      force_so_sync_sol     <= '0';
      so_write_stretch      <= '0';

    elsif (sysclk'event and sysclk = '1') then                                         

      if (si_wait_int = '0') then
        si_write_ff   <= si_write;
        si_sync_ff    <= si_sync ;
        si_data_ff    <= si_data ;
        si_beN_ff     <= si_beN  ;
        si_context_ff <= si_context;
      else
        si_write_ff   <= si_write_ff;
        si_sync_ff    <= si_sync_ff ;
        si_data_ff    <= si_data_ff ;
        si_beN_ff     <= si_beN_ff  ;
        si_context_ff <= si_context_ff;
      end if;
      
      
      -----------------
      -- i
      -- FLOPPED
      -----------------
      if ((si_write = '1' and si_wait_int = '0' and si_sync(1) = '0') or 
          (so_write_int = '1' and so_wait = '0' and so_sync_out /= "11" and i = region_of_interest - 1) or
          ABORT = '1'
         ) then -- SOF, EOL
        i <= 0;
      elsif (so_write_int = '1' and so_wait = '0' and so_sync_out /= "11") then
        i <= (i + 1) mod (SI_DATA_WIDTH/SO_DATA_WIDTH);
      else
        i <= i;
      end if;

      
      -----------------
      -- so_sync_sol
      -- FLOPPED
      -----------------
      if (si_write = '1' and si_sync(1) = '0' and not 
          (force_so_sync_sol = '1' and (so_write_out = '0' or so_wait = '1'))
         ) then
        so_sync_sol <= si_sync;
      else
        so_sync_sol <= so_sync_sol;
      end if;


      -----------------
      -- force_so_sync_sol
      -- FLOPPED
      -----------------
      force_so_sync_sol <= -- SET
                           (si_write and not si_sync(1))
                           or (
                           -- RESET
                           not (so_write_out and not so_wait)
                           -- SAME VALUE
                           and force_so_sync_sol
                           );
                    
                          
      -----------------
      -- so_sync_out
      -- FLOPPED
      -----------------
      if (so_write_int = '1' and so_wait = '1') then
        so_sync_out <= so_sync_out;
      elsif (force_so_sync_sol = '1' and not (so_write_out = '1' and so_wait = '0')) then
        so_sync_out <= so_sync_sol;
      elsif (si_write = '1' and si_wait_int = '0') then
        so_sync_out <= si_sync;
      else
        so_sync_out <= "10";
      end if;


      -----------------
      -- so_write_stretch
      -- FLOPPED
      -----------------
      so_write_stretch  <= so_write_int and so_wait;


    end if;

  end process;


  -------------------------------------------------------------------------------
  -- unclocked events
  -------------------------------------------------------------------------------

  -----------------
  -- so_write_int
  -----------------
  so_write_int <= si_write_ff or 
                  (bo2sl(i /= 0) and bo2sl(si_sync /= "11") and si_write) or
                  so_write_stretch;


  -----------------
  -- so_data
  -----------------
  gen_so_data : for j in so_data'range generate
  begin

    so_data(j) <= si_data_ff(i*SO_DATA_WIDTH + j);

  end generate gen_so_data; 


  -----------------
  -- so_beN_out
  -----------------
  gen_so_beN_out : for j in so_beN_out'range generate
  begin

    so_beN_out(j) <= si_beN_ff (i*SO_DATA_WIDTH/8 + j);

  end generate gen_so_beN_out; 


  -----------------
  -- so_context_out
  -----------------
  gen_so_context_out : for j in so_context_out'range generate
  begin

    so_context_out(j) <= si_context_ff (i*so_context_out'length + j);

  end generate gen_so_context_out; 


  -----------------
  -- si_wait_int
  -----------------
  si_wait_int <= not ABORT and 
                 (
                  (so_write_int and so_wait) or 
                  (so_write_int and bo2sl(i /= region_of_interest-1) and bo2sl(si_sync_ff /= "11"))
                 );


  -----------------
  -- so_active
  -----------------
  so_active <= so_write_int;


  -----------------
  -- so_write_out
  -----------------
  so_write_out <= (not AndN(so_beN_out) or AndN(so_sync_out)) and so_write_int;

  -----------------
  -- output signals
  -----------------
  so_write   <= so_write_out;
  so_beN     <= so_beN_out;
  so_sync    <= so_sync_out;
  si_wait    <= si_wait_int;

  so_context <= so_context_out;


end functional;





