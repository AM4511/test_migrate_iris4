----------------------------------------------------------------------
--  $HeadURL: svn://brainstorm/svn_ipcore/trunk/Matrox/Imaging/FDK/hw/cores/common/design/stream_shift_core.vhd $
--  $Revision: 9391 $
--  $Date: 2009-08-06 12:55:08 -0400 (Thu, 06 Aug 2009) $
--  $Author: mpoirie1 $
--
--  Description             : stream shifter module
--
--  Functionality           :
--
--  Generics Description    : S_DATA_WIDTH              = width of si_data and so_data signals: 64, 128, etc.
--                            SHIFT_LEFT_NOT_RIGHT      = select between LEFT or RIGHT shift
--                            PIPELINE_OUTPUT           = register output signals so_write, so_sync, so_data and so_beN
--
--  Modules Used            : stream_shift_right
--                            stream_shift_left 
--                            stream_buffer_core
--
-----------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all; 
  use ieee.std_logic_unsigned.all;
  use ieee.std_logic_arith.all;

entity stream_shift_core is
  generic (

    S_DATA_WIDTH              : integer := 64  ;       -- width of s*_data signal: 64, 128, etc.
    SHIFT_LEFT_NOT_RIGHT      : boolean := TRUE;       
    S_CONTEXT_WIDTH           : integer := 0   ;       -- width of s*_context signals
    PIPELINE_OUTPUT           : boolean := TRUE;      
    SO_WAIT_REGISTERED        : boolean := TRUE       

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
    si_flush                  : in        std_logic := '0'; -- only implemented for left shift
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
end stream_shift_core;


architecture functional of stream_shift_core is


-------------------------------------------------
-- stream_shift_left
-------------------------------------------------
component stream_shift_left
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
    si_flush                  : in        std_logic;
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
end component;


-------------------------------------------------
-- stream_shift_right
-------------------------------------------------
component stream_shift_right
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
end component;


-------------------------------------------------
-- stream_buffer_core
-------------------------------------------------
component stream_buffer_core 
  generic (

    S_DATA_WIDTH         : integer := 64        ; -- width of s*_data signal: 64, 128, etc.
    S_CONTEXT_WIDTH      : integer := 0         ; -- width of s*_context signals
    SI_BUS_REGISTERED    : boolean := TRUE      ;
    SO_WAIT_REGISTERED   : boolean := TRUE      

  );
  port (

    ----------------------------------------------------
    -- Reset, clock and mode signals
    ----------------------------------------------------
    sysrstN              : in        std_logic;
    sysclk               : in        std_logic;
    ----------------------------------------------------
    -- stream input port (slave)
    ----------------------------------------------------
    si_write             : in        std_logic;
    si_sync              : in        std_logic_vector(1 downto 0);
    si_data              : in        std_logic_vector(S_DATA_WIDTH-1 downto 0);
    si_beN               : in        std_logic_vector(S_DATA_WIDTH/8 - 1 downto 0);
    si_wait              : buffer    std_logic;
    si_context           : in        std_logic_vector(S_CONTEXT_WIDTH downto 1) := (others => '0'); -- range shifted by 1 to prevent negative index
    ----------------------------------------------------
    -- stream output port (master)  
    ----------------------------------------------------
    so_write             : buffer    std_logic;
    so_sync              : buffer    std_logic_vector(1 downto 0);
    so_data              : buffer    std_logic_vector(S_DATA_WIDTH-1 downto 0);
    so_beN               : buffer    std_logic_vector(S_DATA_WIDTH/8 - 1 downto 0);
    so_wait              : in        std_logic;
    so_context           : buffer    std_logic_vector(S_CONTEXT_WIDTH downto 1) := (others => '0')  -- range shifted by 1 to prevent negative index

  );
end component;


  -----------------------------------------------------
  -- signals
  -----------------------------------------------------

  signal left_wait                   : std_logic;
  signal left_write                  : std_logic;
  signal left_sync                   : std_logic_vector(1 downto 0);
  signal left_data                   : std_logic_vector(S_DATA_WIDTH-1 downto 0);
  signal left_beN                    : std_logic_vector(S_DATA_WIDTH/8-1 downto 0);
  signal left_context                : std_logic_vector(S_CONTEXT_WIDTH downto 1);

  signal right_wait                  : std_logic;
  signal right_write                 : std_logic;
  signal right_sync                  : std_logic_vector(1 downto 0);
  signal right_data                  : std_logic_vector(S_DATA_WIDTH-1 downto 0);
  signal right_beN                   : std_logic_vector(S_DATA_WIDTH/8-1 downto 0);
  signal right_context               : std_logic_vector(S_CONTEXT_WIDTH downto 1);

  signal si_wait_int                 : std_logic;
 
  signal shift_wait                  : std_logic;
  signal shift_write                 : std_logic;
  signal shift_sync                  : std_logic_vector(1 downto 0);
  signal shift_data                  : std_logic_vector(S_DATA_WIDTH-1 downto 0);
  signal shift_beN                   : std_logic_vector(S_DATA_WIDTH/8-1 downto 0);
  signal shift_context               : std_logic_vector(S_CONTEXT_WIDTH downto 1);




begin

si_wait <= si_wait_int;

-------------------------------------------------
-- stream_shift_left
-------------------------------------------------
gen_shift_left : if SHIFT_LEFT_NOT_RIGHT = TRUE generate

  xstream_shift_left : stream_shift_left
  generic map (

    S_DATA_WIDTH              => S_DATA_WIDTH              ,
    S_CONTEXT_WIDTH           => S_CONTEXT_WIDTH

  )
  port map (                  

    sysrstN                   => sysrstN                   ,
    sysclk                    => sysclk                    ,
    byteshift                 => byteshift                 ,
    si_write                  => si_write                  ,
    si_sync                   => si_sync                   ,
    si_data                   => si_data                   ,
    si_beN                    => si_beN                    ,
    si_wait                   => left_wait                 ,
    si_flush                  => si_flush                  ,
    si_context                => si_context                ,
    so_write                  => left_write                ,
    so_sync                   => left_sync                 ,
    so_data                   => left_data                 ,
    so_beN                    => left_beN                  ,
    so_wait                   => shift_wait                ,   
    so_context                => left_context

  );

  -----------------
  -- si_wait 
  -----------------
  si_wait_int   <= left_wait;

  -----------------
  -- shift_write
  -- shift_sync 
  -- shift_beN  
  -- shift_data 
  -----------------
  shift_write   <= left_write;
  shift_sync    <= left_sync;
  shift_data    <= left_data;
  shift_beN     <= left_beN;
  shift_context <= left_context;
  
end generate;

-------------------------------------------------
-- stream_shift_right
-------------------------------------------------
gen_shift_right : if SHIFT_LEFT_NOT_RIGHT = FALSE generate

  xstream_shift_right : stream_shift_right
  generic map (

    S_DATA_WIDTH              => S_DATA_WIDTH              ,
    S_CONTEXT_WIDTH           => S_CONTEXT_WIDTH

  )
  port map (                  

    sysrstN                   => sysrstN                   ,
    sysclk                    => sysclk                    ,
    byteshift                 => byteshift                 ,
    si_write                  => si_write                  ,
    si_sync                   => si_sync                   ,
    si_data                   => si_data                   ,
    si_beN                    => si_beN                    ,
    si_wait                   => right_wait                ,
    si_context                => si_context                ,
    so_write                  => right_write               ,
    so_sync                   => right_sync                ,
    so_data                   => right_data                ,
    so_beN                    => right_beN                 ,
    so_wait                   => shift_wait                ,   
    so_context                => right_context

  );

  -----------------
  -- si_wait 
  -----------------
  si_wait_int   <= right_wait ;

  -----------------
  -- shift_write
  -- shift_sync 
  -- shift_beN  
  -- shift_data 
  -----------------
  shift_write   <= right_write  ;
  shift_sync    <= right_sync   ;
  shift_data    <= right_data   ;
  shift_beN     <= right_beN    ;
  shift_context <= right_context;

end generate;


-------------------------------------------------
-- stream_buffer_core
-------------------------------------------------
xstream_buffer_core : stream_buffer_core 
  generic map (

    S_DATA_WIDTH         => S_DATA_WIDTH         ,
    S_CONTEXT_WIDTH      => S_CONTEXT_WIDTH      ,
    SI_BUS_REGISTERED    => PIPELINE_OUTPUT      ,
    SO_WAIT_REGISTERED   => SO_WAIT_REGISTERED

  )
  port map (

    sysrstN              => sysrstN              ,
    sysclk               => sysclk               ,
    si_write             => shift_write          ,
    si_sync              => shift_sync           ,
    si_data              => shift_data           ,
    si_beN               => shift_beN            ,
    si_wait              => shift_wait           ,
    si_context           => shift_context        ,
    so_write             => so_write             ,
    so_sync              => so_sync              ,
    so_data              => so_data              ,
    so_beN               => so_beN               ,
    so_wait              => so_wait              ,
    so_context           => so_context

  );


end functional;
