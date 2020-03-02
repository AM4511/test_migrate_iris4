----------------------------------------------------------------------
--  $HeadURL: svn://brainstorm/svn_ipcore/trunk/Matrox/Imaging/FDK/hw/cores/common/design/stream_buffer_core.vhd $
--  $Revision: 8647 $
--  $Date: 2009-03-11 14:59:23 -0400 (Wed, 11 Mar 2009) $
--  $Author: palepin $
--
--  Description             : Stream buffer core module
--
--  Functionality           : adds a pipeline to a stream to help meet timings.
--
--  Generics Description    : S_DATA_WIDTH          = width of si_data and so_data signals
--                            SI_BUS_REGISTERED     = registers input signals si_write, si_sync, si_data and si_beN
--                            SO_WAIT_REGISTERED    = registers input signal so_wait
--
--  Modules Used            : bus_buffer_core
--                            
--  Packages Used           : 
--                            
--
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;


entity stream_buffer_core is
  generic (
    BUS_INTERFACE      : string  := "SOPC";  -- SOPC/QSYS/AXI4.
    S_DATA_WIDTH       : integer := 64;  -- width of s*_data signal: 64, 128, etc.
    S_CONTEXT_WIDTH    : integer := 0;  -- width of s*_context signals
    SI_BUS_REGISTERED  : boolean := true;
    SO_WAIT_REGISTERED : boolean := true
    );
  port (
    ----------------------------------------------------
    -- Reset, clock and mode signals
    ----------------------------------------------------
    sysrstN    : in     std_logic;
    sysclk     : in     std_logic;
    ----------------------------------------------------
    -- stream input port (slave)
    ----------------------------------------------------
    si_write   : in     std_logic;
    si_sync    : in     std_logic_vector(1 downto 0);
    si_data    : in     std_logic_vector(S_DATA_WIDTH-1 downto 0);
    si_beN     : in     std_logic_vector(S_DATA_WIDTH/8 - 1 downto 0);
    si_wait    : buffer std_logic;
    si_context : in     std_logic_vector(S_CONTEXT_WIDTH downto 1) := (others => '0');  -- range shifted by 1 to prevent negative index
    ----------------------------------------------------
    -- stream output port (master)  
    ----------------------------------------------------
    so_write   : buffer std_logic;
    so_sync    : buffer std_logic_vector(1 downto 0);
    so_data    : buffer std_logic_vector(S_DATA_WIDTH-1 downto 0);
    so_beN     : buffer std_logic_vector(S_DATA_WIDTH/8 - 1 downto 0);
    so_wait    : in     std_logic;
    so_context : buffer std_logic_vector(S_CONTEXT_WIDTH downto 1) := (others => '0')  -- range shifted by 1 to prevent negative index
    );
end stream_buffer_core;




architecture functional of stream_buffer_core is


-------------------------------------------------
-- bus_buffer_core
-------------------------------------------------
  component bus_buffer_core
    generic (
      BUS_WIDTH         : integer;      -- width of A_bus/B_bus ports
      A_BUS_REGISTERED  : boolean := true;  -- add a register on A_bus input port
      B_WAIT_REGISTERED : boolean := true  -- add a register on B_wait input port and extra glue logic
      );
    port (

      ---------------------------------------------------------------------
      -- Reset, clock and mode signals
      ---------------------------------------------------------------------
      sysrstN     : in     std_logic;
      sysclk      : in     std_logic;
      ---------------------------------------------------------------------
      -- input side
      ---------------------------------------------------------------------
      A_bus_reset : in     std_logic_vector(BUS_WIDTH-1 downto 0) := (others => '0');
      A_bus       : in     std_logic_vector(BUS_WIDTH-1 downto 0);
      A_wait      : buffer std_logic;
      ---------------------------------------------------------------------
      -- output side
      ---------------------------------------------------------------------
      B_bus       : buffer std_logic_vector(BUS_WIDTH-1 downto 0);
      B_wait      : in     std_logic

      );
  end component;


  -----------------------------------------------------
  -- signals
  -----------------------------------------------------
  signal si_bus        : std_logic_vector(1 + si_context'length + si_sync'length + si_beN'length + si_data'length - 1 downto 0);
  signal so_bus        : std_logic_vector(si_bus'range);
  signal internal_wait : std_logic;

begin


-------------------------------------------------
-- bus_buffer_core
-------------------------------------------------
  xbuffer : bus_buffer_core
    generic map (
      BUS_WIDTH         => si_bus'length,
      A_BUS_REGISTERED  => SI_BUS_REGISTERED,
      B_WAIT_REGISTERED => SO_WAIT_REGISTERED
      )
    port map (
      sysrstN     => sysrstN,
      sysclk      => sysclk,
      A_bus_reset => open,
      A_bus       => si_bus,
      A_wait      => si_wait,
      B_bus       => so_bus,
      B_wait      => internal_wait
      );


  -----------------
  -- si_bus
  -----------------
  si_bus <= si_write & si_context & si_sync & si_beN & si_data;


  --------------------
  -- QSYS Wait Signal
  --------------------
  internal_wait <= so_wait and so_write when (BUS_INTERFACE = "QSYS") else
                   so_wait;


  -----------------
  -- so_write
  -- so_sync 
  -- so_beN  
  -- so_data 
  -----------------
  so_write   <= so_bus(so_bus'high);
  so_context <= so_bus(so_context'length + so_sync'length + so_beN'length + so_data'length - 1 downto so_sync'length + so_beN'length + so_data'length);
  so_sync    <= so_bus(so_sync'length + so_beN'length + so_data'length - 1 downto so_beN'length + so_data'length);
  so_beN     <= so_bus(so_beN'length + so_data'length - 1 downto so_data'length);
  so_data    <= so_bus(so_data'range);


end functional;

