----------------------------------------------------------------------
--  $HeadURL: svn://brainstorm/svn_ipcore/trunk/Matrox/Imaging/FDK/hw/cores/common/design/stream_resize.vhd $
--  $Revision: 9244 $
--  $Date: 2009-06-11 11:45:04 -0400 (Thu, 11 Jun 2009) $
--  $Author: palepin $
--
--  DESCRIPTION: Stream resize core module
--
--  contains the following modules:
--
--         stream_resize_up
--         stream_resize_down
--
--
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
--        
--  sol_shift : start of line shift
--              represents a LEFT shift (only for resize up)
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
-----------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all; 
  use ieee.std_logic_unsigned.all;
  use ieee.std_logic_arith.all;

entity stream_resize is
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
    sol_shift            : in        integer range 0 to SO_DATA_WIDTH/8-1 := 0; -- start of line shift (only for resize up)
    ----------------------------------------------------
    -- stream input port (slave)
    ----------------------------------------------------
    si_write             : in        std_logic;
    si_sync              : in        std_logic_vector(1 downto 0);
    si_data              : in        std_logic_vector(SI_DATA_WIDTH-1 downto 0);
    si_beN               : in        std_logic_vector(SI_DATA_WIDTH/8 - 1 downto 0);
    si_wait              : out       std_logic;
    si_flush             : in        std_logic := '0'; -- only for resize up
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
end stream_resize;




architecture functional of stream_resize is

----------------------------------------------------
-- stream_resize_up
----------------------------------------------------
component stream_resize_up
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
end component;  
  

----------------------------------------------------
-- stream_resize_down
----------------------------------------------------
component stream_resize_down
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
end component;  
  


begin





--=============================================================================== 
--                                SCALE UP
--=============================================================================== 

gen_scaleup: if SI_DATA_WIDTH < SO_DATA_WIDTH generate

  xstream_resize_up : stream_resize_up
    generic map (

      SI_DATA_WIDTH        => SI_DATA_WIDTH        ,
      SI_CONTEXT_WIDTH     => SI_CONTEXT_WIDTH     ,
      SO_DATA_WIDTH        => SO_DATA_WIDTH

    )
    port map (

      sysrstN              => sysrstN              ,
      sysclk               => sysclk               ,
      ABORT                => ABORT                ,
      region_of_interest   => open                 , -- use all
      sol_shift            => sol_shift            ,
      si_write             => si_write             ,
      si_sync              => si_sync              ,
      si_data              => si_data              ,
      si_beN               => si_beN               ,
      si_wait              => si_wait              ,
      si_flush             => si_flush             ,
      si_context           => si_context           ,
      so_write             => so_write             ,
      so_sync              => so_sync              ,
      so_data              => so_data              ,
      so_beN               => so_beN               ,
      so_wait              => so_wait              ,
      so_context           => so_context           ,
      so_active            => so_active

    );

end generate gen_scaleup;




--=============================================================================== 
--                                SCALE DOWN
--=============================================================================== 

gen_scaledown: if SI_DATA_WIDTH > SO_DATA_WIDTH generate

  xstream_resize_down : stream_resize_down
    generic map (

      SI_DATA_WIDTH        => SI_DATA_WIDTH        ,
      SI_CONTEXT_WIDTH     => SI_CONTEXT_WIDTH     ,
      SO_DATA_WIDTH        => SO_DATA_WIDTH       

    )
    port map (

      sysrstN              => sysrstN              ,
      sysclk               => sysclk               ,
      ABORT                => ABORT                ,
      region_of_interest   => open                 , -- use all
      si_write             => si_write             ,
      si_sync              => si_sync              ,
      si_data              => si_data              ,
      si_beN               => si_beN               ,
      si_wait              => si_wait              ,
      si_context           => si_context           ,
      so_write             => so_write             ,
      so_sync              => so_sync              ,
      so_data              => so_data              ,
      so_beN               => so_beN               ,
      so_wait              => so_wait              ,
      so_context           => so_context           ,
      so_active            => so_active

    );

end generate gen_scaledown;



--=============================================================================== 
--                                NO SCALE
--=============================================================================== 

gen_noscale: if SI_DATA_WIDTH = SO_DATA_WIDTH generate

  so_write  <= si_write;
  so_sync   <= si_sync;
  so_data   <= si_data;
  so_beN    <= si_beN;
  si_wait   <= so_wait;

  so_active <= si_write;
  
  so_context <= si_context;
  
end generate gen_noscale;






end functional;





