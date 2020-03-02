----------------------------------------------------------------------
--  $HeadURL: svn://brainstorm/svn_ipcore/trunk/Matrox/Imaging/FDK/hw/cores/common/design/stream_resize_up.vhd $
--  $Revision: 9244 $
--  $Date: 2009-06-11 11:45:04 -0400 (Thu, 11 Jun 2009) $
--  $Author: palepin $
--
--  DESCRIPTION: Stream resize (scale UP) module
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
--  stay at '1'. The so_active signal is flopped.
--
-- 
--  Note: si_wait can go to 1 even if si_write = 0
--        
-- Note: if si_flush = '1' and si_write = '1', then the input data will be flushed on the next clock
--       if si_flush = '1' and si_write = '0', then the concatenated data (already present) will be flushed on the next clock
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

entity stream_resize_up is
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
    region_of_interest   : in        integer range 1 to SO_DATA_WIDTH/SI_DATA_WIDTH := SO_DATA_WIDTH/SI_DATA_WIDTH; -- region_of_interest / (SO_DATA_WIDTH/SI_DATA_WIDTH) = portion of output stream to fill (starting with LSB)
    sol_shift            : in        integer range 0 to SO_DATA_WIDTH/8-1 := 0; -- start of line shift
    ----------------------------------------------------
    -- stream input port (slave)
    ----------------------------------------------------
    si_write             : in        std_logic;
    si_sync              : in        std_logic_vector(1 downto 0);
    si_data              : in        std_logic_vector(SI_DATA_WIDTH-1 downto 0);
    si_beN               : in        std_logic_vector(SI_DATA_WIDTH/8 - 1 downto 0);
    si_wait              : out       std_logic;
    si_flush             : in        std_logic := '0';
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
end stream_resize_up;




architecture functional of stream_resize_up is

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

  signal si_wait_int            : std_logic;

  signal so_write_out           : std_logic;
  signal so_write_out_m1        : std_logic;
  signal so_sync_out            : std_logic_vector(1 downto 0);
  signal so_data_out            : std_logic_vector(SO_DATA_WIDTH-1 downto 0);
  signal so_beN_out             : std_logic_vector(SO_DATA_WIDTH/8 - 1 downto 0);

  signal so_context_out         : std_logic_vector(SI_CONTEXT_WIDTH*SO_DATA_WIDTH/SI_DATA_WIDTH downto 1); -- range shifted by 1 to prevent negative index

  -- bus width mismatch signals
  signal i                      : integer range 0 to SO_DATA_WIDTH/SI_DATA_WIDTH-1 := 0;
  signal i_sol                  : integer range 0 to SO_DATA_WIDTH/SI_DATA_WIDTH-1 := 0;

  signal flush                  : std_logic;
  signal flush_m1               : std_logic;

  signal valid_data             : std_logic;
  
  
begin




-------------------------------------------------
-- Verifications
-------------------------------------------------

--synthesis translate_off

  -------------------------------------
  -- region_of_interest /= 0
  -------------------------------------
  assert region_of_interest /= 0
    report "region_of_interest cannot be 0 in stream_resize_up module"
    severity FAILURE;


  -------------------------------------
  -- sol_shift <= SO_DATA_WIDTH
  -------------------------------------
  assert sol_shift < SO_DATA_WIDTH/8
    report "sol_shift must be smaller than SO_DATA_WIDTH/8 in stream_resize_up module"
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

      i                     <= 0;
      so_sync_out           <= (others => '0');
      so_write_out          <= '0';
      flush                 <= '0';
      so_active             <= '0';
      valid_data            <= '0';

    elsif (sysclk'event and sysclk = '1') then                                         

      so_write_out <= so_write_out_m1;


      -----------------
      -- flush
      -- FLOPPED
      -----------------
      if (so_wait = '0' or so_write_out = '0') then
        flush <= flush_m1;
      else
        flush <= flush;
      end if;


      -----------------
      -- i
      -- FLOPPED
      -----------------
      if ((si_write = '1' and si_wait_int = '0' and i = region_of_interest-1) or
          (si_flush = '1' and si_wait_int = '0' and so_wait = '0')
         ) then
        i <= 0;
      elsif ((si_write = '1' and si_sync /= "10" and i /= i_sol) or
             flush_m1 = '1' or
             ABORT = '1'
            ) then
        i <= i_sol;
      elsif (si_write = '1' and si_wait_int = '0') then
        i <= (i + 1) mod (SO_DATA_WIDTH/SI_DATA_WIDTH);
      else
        i <= i;
      end if;


      -----------------
      -- so_sync_out
      -- FLOPPED
      -----------------
      if ((i /= 0 and si_sync = "10") or
          flush_m1 = '1' or
          si_write = '0' or
          (so_write_out = '1' and so_wait = '1')
         ) then
        so_sync_out  <= so_sync_out;
      else
        so_sync_out  <= si_sync;
      end if;


      -----------------
      -- so_active
      -- FLOPPED
      -----------------
      so_active <= so_write_out_m1 or
                   so_write_out;


      -----------------
      -- valid_data
      -- '1' => so_data_out contains valid data
      -- FLOPPED
      -----------------
      if (si_write = '1' and si_wait_int = '0') then
        valid_data <= '1';
      elsif (so_write_out = '1' and so_wait = '0') then
        valid_data <= '0';
      else
        valid_data <= valid_data;
      end if;


    end if;

  end process;

  --------------------------------
  -- GENERATE process
  --------------------------------
  gen_databen : for k in SO_DATA_WIDTH/SI_DATA_WIDTH-1 downto 0 generate
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

        so_data_out((k+1)*SI_DATA_WIDTH-1     downto k*SI_DATA_WIDTH)      <= (others => '0');
        so_beN_out ((k+1)*SI_DATA_WIDTH/8-1   downto k*SI_DATA_WIDTH/8)    <= (others => '1');
        so_context_out((k+1)*SI_CONTEXT_WIDTH downto k*SI_CONTEXT_WIDTH+1) <= (others => '0');

      elsif (sysclk'event and sysclk = '1') then                         

        -----------------
        -- so_data_out
        -----------------
        if (si_write = '1' and si_wait_int = '0' and k = i) then
          so_data_out((k+1)*SI_DATA_WIDTH-1 downto k*SI_DATA_WIDTH) <= si_data ;
        else
          so_data_out((k+1)*SI_DATA_WIDTH-1 downto k*SI_DATA_WIDTH) <= so_data_out((k+1)*SI_DATA_WIDTH-1 downto k*SI_DATA_WIDTH)  ;
        end if;
      

        -----------------
        -- so_beN_out
        -----------------
        if ((si_write = '1' and si_wait_int = '0' and k = i) or
            (si_write = '1' and si_wait_int = '0' and si_sync /= "10" and k = i_sol)   
           ) then
          so_beN_out ((k+1)*SI_DATA_WIDTH/8-1 downto k*SI_DATA_WIDTH/8) <= si_beN  ;
        elsif ((si_write = '1' and si_wait_int = '0' and si_sync = "10" and i = 0) or
               (si_write = '1' and si_wait_int = '0' and si_sync /= "10" and i = i_sol) or
               valid_data = '0' or
               (flush = '1' and so_wait = '0')
              ) then
          so_beN_out ((k+1)*SI_DATA_WIDTH/8-1 downto k*SI_DATA_WIDTH/8) <= (others => '1');
        else
          so_beN_out ((k+1)*SI_DATA_WIDTH/8-1 downto k*SI_DATA_WIDTH/8) <= so_beN_out ((k+1)*SI_DATA_WIDTH/8-1 downto k*SI_DATA_WIDTH/8);
        end if;


        -----------------
        -- so_context_out
        -----------------
        if (si_write = '1' and si_wait_int = '0' and k = i) then
          so_context_out((k+1)*SI_CONTEXT_WIDTH downto k*SI_CONTEXT_WIDTH+1) <= si_context;
        elsif ((si_write = '1' and si_wait_int = '0' and si_sync = "10" and i = 0) or
               (si_write = '1' and si_wait_int = '0' and si_sync /= "10" and i = i_sol) or
               valid_data = '0' or
               (flush = '1' and so_wait = '0')
              ) then
          so_context_out((k+1)*SI_CONTEXT_WIDTH downto k*SI_CONTEXT_WIDTH+1) <= si_context; -- nice to have feature: add new port so_context_init (default value to be assigned )
        else
          so_context_out((k+1)*SI_CONTEXT_WIDTH downto k*SI_CONTEXT_WIDTH+1) <= so_context_out((k+1)*SI_CONTEXT_WIDTH downto k*SI_CONTEXT_WIDTH+1);
        end if;
      
      end if;

    end process;


  end generate gen_databen; 



  -------------------------------------------------------------------------------
  -- unclocked events
  -------------------------------------------------------------------------------

  -----------------
  -- i_sol
  -----------------
  i_sol <= sol_shift/(SI_DATA_WIDTH/8);


  -----------------
  -- flush_m1
  -----------------
  flush_m1 <= (si_write and valid_data and bo2sl(i /= 0) and bo2sl(si_sync /= "10") and not so_write_out);

  
  -----------------
  -- so_write_out
  -----------------
  so_write_out_m1 <= (so_write_out and so_wait) or
                     (flush_m1 and not ABORT) or
                     (si_flush and not si_write and valid_data and not ABORT and not so_write_out) or
                     (si_write and not ABORT and not si_wait_int and bo2sl(i = region_of_interest-1)) or
                     (si_write and not ABORT and not si_wait_int and si_flush) or
                     (si_write and not ABORT and bo2sl(si_sync = "11"));


  -----------------
  -- si_wait_int
  -----------------
  si_wait_int <= not ABORT and 
                 (
                  (so_wait and so_write_out and si_write) or
                  (so_wait and si_flush) or
                  flush_m1 or
                  (si_write and not si_sync(1) and bo2sl(i /= i_sol)) -- si_sync = "00" (sof) or "01" (eol) or 
                 );


  -----------------
  -- output signals
  -----------------
  so_write   <= so_write_out;
  so_sync    <= so_sync_out;
  so_data    <= so_data_out;
  so_beN     <= so_beN_out;
  si_wait    <= si_wait_int;

  so_context <= so_context_out;



end functional;





