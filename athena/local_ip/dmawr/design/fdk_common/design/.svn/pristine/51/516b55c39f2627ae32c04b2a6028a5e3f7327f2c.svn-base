----------------------------------------------------------------------
--  $HeadURL: svn://brainstorm/svn_ipcore/trunk/Matrox/Imaging/FDK/hw/cores/common/design/stream_packer_core.vhd $
--  $Revision: 9244 $
--  $Date: 2009-06-11 11:45:04 -0400 (Thu, 11 Jun 2009) $
--  $Author: palepin $
--
--  DESCRIPTION: Stream Packer core module
--
--             ________       ________     ________     ________     ________    
--            |  fifo  |     |        |   |        |   |        |   |        |   
--         -->|  with  |  -->|        |   |        |   |        |   |        |   
--  stream -->| resize |  -->|  pack  |-->| buffer |-->| resize |-->| buffer |-->  stream 
--    in   --> --------   -->|  mux   |   |        |   |  down  |   |        |      out
--         -->  --------  -->|        |   |        |   |        |   |        |   
--               --------    |        |   |        |   |        |   |        |   
--                --------    ¯¯¯¯¯¯¯¯     ¯¯¯¯¯¯¯¯     ¯¯¯¯¯¯¯¯     ¯¯¯¯¯¯¯¯    
--
--   widths:       |              |                         |                
--                  \              \                         \               
--                   |              |                         |              
--                   |              |   S_PACK_DATA_WIDTH     |              
--     SI_DATA_WIDTH | SO_DATA_WIDTH|           =             |       SO_DATA_WIDTH
--     (* SI_TOTAL)  | (* SI_TOTAL) | SO_DATA_WIDTH*SI_TOTAL  |              
--                   |              |                         |              
--
--
--  contains the following modules:
--      stream_fifo_core
--      stream_buffer_core
--      stream_packer_mux
--      stream_resize_down
--
--
--
--  Functionality: Packs a given number of streams into a single one
--
--        
--
--
--  Generics Description:
--  =====================
--
--    SI_TOTAL             : (integer)  
--
--                           total amount of stream inputs / number of contexts
--
--
--
--    SI_DATA_WIDTH        : (integer)  
--
--                           width of si_data signal: 64, 128, etc.
--
--
--
--    SO_DATA_WIDTH        : (integer)
--
--                           width of so_data signal: 64, 128, etc.
--
--
--
--    SI_FIFO_DEPTH        : (integer)
--
--                           maximum FIFO depth per context
--
--
--    SO_DATA_REGISTERED   : (boolean)
--
--                           register output signals so_write, so_sync, so_data and so_beN
--
-- 
--    SO_WAIT_REGISTERED   : (boolean)
--
--                           When SO_WAIT_REGISTERED is TRUE, the signal so_wait is routed directly and uniquely 
--                           to a register (flip-flop). This limits the fanout on this signal to '1' and can 
--                           thus help improve timings. Extra logic is added to make the addtition of a flip-flop
--                           on the so_wait signal transparent to the rest of the logic. A value of TRUE is 
--                           recommended when the stream output interface connects to a  
--                           stream output port of an IP. A value of FALSE is recommended when the stream output 
--                           interface is connected to internal logic of an IP.
--
--
--    FPGA_ARCH            : (string)
--
--                           valid values: "ALTERA"
--
--
--    FPGA_FAMILY          : (string)
--
--                           valid values: "STRATIX", "STRATIXII"
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

library work;
  use work.std_logic_2d.all; 

entity stream_packer_core is
  generic (

    SI_TOTAL             : integer := 1         ; -- number of stream input ports / number of contexts
    SI_DATA_WIDTH        : integer := 64        ; -- width of si_data signal: 64, 128, etc.
    SO_DATA_WIDTH        : integer := 64        ; -- width of so_data signal: 64, 128, etc.
    SI_FIFO_DEPTH        : integer := 16        ; -- maximum FIFO depth per context
    SO_DATA_REGISTERED   : boolean := TRUE      ; -- register output signals so_write, so_sync, so_data and so_beN
    SO_WAIT_REGISTERED   : boolean := TRUE      ; -- add a register on input signal so_wait and extra glue logic
    FPGA_ARCH            : string  := "ALTERA"  ;
    FPGA_FAMILY          : string  := "STRATIX"   -- "STRATIX", "STRATIXII"

  );
  port (

    ---------------------------------------------------------------------
    -- Reset, clock and mode signals
    ---------------------------------------------------------------------
    sysrstN              : in        std_logic;
    sysclk               : in        std_logic;
    ABORT                : in        std_logic;
    bit_depth            : in        integer := 8;
    nb_contexts          : in        integer := 4;
    context_enable       : in        std_logic_vector(3 downto 0);
    first_valid_context  : in        integer;               -- in case the first context(s) is (are) disabled
    ---------------------------------------------------------------------
    -- stream input port (slave)
    ---------------------------------------------------------------------
    si_write             : in        std_logic_vector  (SI_TOTAL-1 downto 0);
    si_sync              : in        STD_LOGIC_ARRAY_2D(SI_TOTAL-1 downto 0, 1 downto 0);
    si_data              : in        STD_LOGIC_ARRAY_2D(SI_TOTAL-1 downto 0, SI_DATA_WIDTH-1 downto 0);
    si_beN               : in        STD_LOGIC_ARRAY_2D(SI_TOTAL-1 downto 0, SI_DATA_WIDTH/8 - 1 downto 0);
    si_wait              : out       std_logic_vector  (SI_TOTAL-1 downto 0);
    ---------------------------------------------------------------------
    -- stream output port (master)  
    ---------------------------------------------------------------------
    so_write             : out       std_logic;
    so_sync              : out       std_logic_vector(1 downto 0);
    so_data              : out       std_logic_vector(SO_DATA_WIDTH-1 downto 0);
    so_beN               : out       std_logic_vector(SO_DATA_WIDTH/8 - 1 downto 0);
    so_wait              : in        std_logic;
    so_active            : out       std_logic

  );
end stream_packer_core;




architecture functional of stream_packer_core is

----------------------------------------------------
-- stream_fifo_core
----------------------------------------------------
component stream_fifo_core
  generic (

    SI_DATA_WIDTH        : integer := 64        ; -- width of si_data signal: 64, 128, etc.
    SO_DATA_WIDTH        : integer := 64        ; -- width of so_data signal: 64, 128, etc.
    DATA_CAPACITY        : integer := 1024      ; -- maximum FIFO capacity in terms of number of bits of data
    SO_WAIT_REGISTERED   : boolean := TRUE      ; -- add a register on input signal so_wait and extra glue logic
    BEN_ONLY_AT_EOL      : boolean := FALSE     ; -- special mode: when true, byte enables (on input side) are inactive only at end of line 
    FPGA_ARCH            : string  := "ALTERA"  ;
    FPGA_FAMILY          : string  := "STRATIX"   -- "STRATIX", "STRATIXII"

  );
  port (

    ----------------------------------------------------
    -- Reset, clock and mode signals
    ----------------------------------------------------
    sysrstN              : in        std_logic;
    sysclk               : in        std_logic;
    ABORT                : in        std_logic;
    ----------------------------------------------------
    -- stream input port (slave)
    ----------------------------------------------------
    si_write             : in        std_logic;
    si_sync              : in        std_logic_vector(1 downto 0);
    si_data              : in        std_logic_vector(SI_DATA_WIDTH-1 downto 0);
    si_beN               : in        std_logic_vector(SI_DATA_WIDTH/8 - 1 downto 0);
    si_wait              : out       std_logic;
    ----------------------------------------------------
    -- stream output port (master)  
    ----------------------------------------------------
    so_write             : out       std_logic;
    so_sync              : out       std_logic_vector(1 downto 0);
    so_data              : out       std_logic_vector(SO_DATA_WIDTH-1 downto 0);
    so_beN               : out       std_logic_vector(SO_DATA_WIDTH/8 - 1 downto 0);
    so_wait              : in        std_logic;
    so_active            : out       std_logic

  );
end component;


----------------------------------------------------
-- stream_buffer_core
----------------------------------------------------
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


----------------------------------------------------
-- stream_packer_mux
----------------------------------------------------
component stream_packer_mux
  generic (

    NUMBER_OF_CONTEXTS   : integer := 1         ; -- max number of contexts
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


  -----------------------------------------------------
  -- functions
  -----------------------------------------------------

  --  Function making an AND of a group of signals.
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
  -- constants
  -----------------------------------------------------

  -- stream_cat
  constant S_PACK_DATA_WIDTH     : integer := SO_DATA_WIDTH*SI_TOTAL;
  constant SI_FIFO_DATA_CAPACITY : integer := SI_FIFO_DEPTH*SI_DATA_WIDTH; -- maximum FIFO capacity in terms of number of bits of data


  -----------------------------------------------------
  -- types
  -----------------------------------------------------
  type ARRAY_IR_OF_SLV2               is array (integer range <>) of std_logic_vector(1 downto 0);
  type ARRAY_IR_OF_SI_DATA_WIDTH      is array (integer range <>) of std_logic_vector(SI_DATA_WIDTH-1 downto 0);
  type ARRAY_IR_OF_SI_BEN_WIDTH       is array (integer range <>) of std_logic_vector(SI_DATA_WIDTH/8-1 downto 0);
  type ARRAY_IR_OF_SO_DATA_WIDTH      is array (integer range <>) of std_logic_vector(SO_DATA_WIDTH-1 downto 0);
  type ARRAY_IR_OF_SO_BEN_WIDTH       is array (integer range <>) of std_logic_vector(SO_DATA_WIDTH/8-1 downto 0);



  -----------------------------------------------------
  -- signals
  -----------------------------------------------------

  -- stream input fifos
  signal si_fifo_sync            : ARRAY_IR_OF_SLV2         (SI_TOTAL-1 downto 0);
  signal si_fifo_data            : ARRAY_IR_OF_SI_DATA_WIDTH(SI_TOTAL-1 downto 0);
  signal si_fifo_beN             : ARRAY_IR_OF_SI_BEN_WIDTH (SI_TOTAL-1 downto 0);

  signal so_fifo_write           : std_logic_vector         (SI_TOTAL-1 downto 0);
  signal so_fifo_sync            : ARRAY_IR_OF_SLV2         (SI_TOTAL-1 downto 0);
  signal so_fifo_data            : ARRAY_IR_OF_SO_DATA_WIDTH(SI_TOTAL-1 downto 0);
  signal so_fifo_beN             : ARRAY_IR_OF_SO_BEN_WIDTH (SI_TOTAL-1 downto 0);
  signal so_fifo_wait            : std_logic_vector         (SI_TOTAL-1 downto 0);

  -- cat (concatenator)
  signal s_cat_disable          : std_logic_vector(SI_TOTAL-1 downto 0);
  
  signal s_cat_write            : std_logic;
  signal s_cat_sync             : std_logic_vector(1 downto 0);
  signal s_cat_data             : std_logic_vector(S_PACK_DATA_WIDTH-1 downto 0);
  signal s_cat_beN              : std_logic_vector(S_PACK_DATA_WIDTH/8 - 1 downto 0);
  signal s_cat_wait             : std_logic;
  

  -- packer multiplexer
  signal s_pack_data_unbuf      : std_logic_vector(S_PACK_DATA_WIDTH-1 downto 0);
  signal s_pack_beN_unbuf       : std_logic_vector(S_PACK_DATA_WIDTH/8 - 1 downto 0);

  signal s_pack_write           : std_logic;
  signal s_pack_sync            : std_logic_vector(1 downto 0);
  signal s_pack_data            : std_logic_vector(S_PACK_DATA_WIDTH-1 downto 0);
  signal s_pack_beN             : std_logic_vector(S_PACK_DATA_WIDTH/8 - 1 downto 0);
  signal s_pack_wait            : std_logic;

  -- resize
  signal s_resize_write         : std_logic;
  signal s_resize_sync          : std_logic_vector(1 downto 0);
  signal s_resize_data          : std_logic_vector(SO_DATA_WIDTH-1 downto 0);
  signal s_resize_beN           : std_logic_vector(SO_DATA_WIDTH/8 - 1 downto 0);
  signal s_resize_wait          : std_logic;

  --
  signal s_out_write            : std_logic;
  signal s_out_sync             : std_logic_vector(1 downto 0);
  signal s_out_data             : std_logic_vector(SO_DATA_WIDTH-1 downto 0);
  signal s_out_beN              : std_logic_vector(SO_DATA_WIDTH/8 - 1 downto 0);
  
begin

-----------------
-- s_cat_disable
-----------------
gen_s_cat_disable : for i in SI_TOTAL-1 downto 0 generate

  s_cat_disable(i) <= not context_enable(i) when nb_contexts > i else '1';

end generate gen_s_cat_disable;





  --------------------------------
  -- Input FIFOs with RESIZE
  --------------------------------
  gen_xstream_fifo_core_input : for i in SI_TOTAL-1 downto 0 generate
  begin

    si_fifo_sync(i) <= array2slv(si_sync, i);
    si_fifo_data(i) <= array2slv(si_data, i);
    si_fifo_beN (i) <= array2slv(si_beN , i);

    -----------------------------------------------------
    -- stream input fifos
    -----------------------------------------------------
    xstream_fifo_core_input : stream_fifo_core
      generic map (

        SI_DATA_WIDTH        => SI_DATA_WIDTH        ,
        SO_DATA_WIDTH        => SO_DATA_WIDTH        ,
        DATA_CAPACITY        => SI_FIFO_DATA_CAPACITY,
        SO_WAIT_REGISTERED   => FALSE                ,
        BEN_ONLY_AT_EOL      => TRUE                 ,
        FPGA_ARCH            => FPGA_ARCH            ,
        FPGA_FAMILY          => FPGA_FAMILY

      )
      port map (

        sysrstN              => sysrstN              ,
        sysclk               => sysclk               ,
        ABORT                => ABORT                ,
        si_write             => si_write     (i)     ,
        si_sync              => si_fifo_sync (i)     ,
        si_data              => si_fifo_data (i)     ,
        si_beN               => si_fifo_beN  (i)     ,
        si_wait              => si_wait      (i)     ,
        so_write             => so_fifo_write(i)     ,
        so_sync              => so_fifo_sync (i)     ,
        so_data              => so_fifo_data (i)     ,
        so_beN               => so_fifo_beN  (i)     ,
        so_wait              => so_fifo_wait (i)     ,
        so_active            => open

      );

  end generate gen_xstream_fifo_core_input; 









  -------------------------------------------------
  -- Concatenation of Input streams (after FIFOs)
  -------------------------------------------------
  gen_cat_data : for i in SI_TOTAL-1 downto 0 generate
  begin

    -----------------
    -- s_cat_data
    -----------------
    s_cat_data((i+1)*SO_DATA_WIDTH-1 downto i*SO_DATA_WIDTH) <= so_fifo_data(i) when context_enable(i) = '1' else (others => '0');


    -----------------
    -- s_cat_beN
    -----------------
    s_cat_beN((i+1)*SO_DATA_WIDTH/8-1 downto i*SO_DATA_WIDTH/8) <= so_fifo_beN(first_valid_context); -- use one context


    -----------------
    -- so_fifo_wait
    -----------------
    so_fifo_wait(i) <= (s_cat_wait and so_fifo_write(i)) or 
                       (not s_cat_write and so_fifo_write(i));


  end generate gen_cat_data; 


  -----------------
  -- s_cat_write
  -- force at 0 when all contexts are disabled.
  -----------------
  s_cat_write <= AndN(so_fifo_write or s_cat_disable) and not AndN(s_cat_disable); -- or so_fifo_done when misalignment... 


  -----------------
  -- s_cat_sync
  -----------------
  s_cat_sync  <= so_fifo_sync(first_valid_context); -- only use one context (they should all be identical)






----------------------------------------------------
-- stream_packer_mux
----------------------------------------------------
xstream_packer_mux : stream_packer_mux
  generic map (

    NUMBER_OF_CONTEXTS   => SI_TOTAL             ,
    S_DATA_WIDTH         => S_PACK_DATA_WIDTH

  )
  port map (

    bit_depth            => bit_depth            ,
    nb_contexts          => nb_contexts          ,
    si_data              => s_cat_data           ,
    si_beN               => s_cat_beN            ,
    so_data              => s_pack_data_unbuf    ,
    so_beN               => s_pack_beN_unbuf 

  );


----------------------------------------------------
-- stream_buffer_core
----------------------------------------------------
xstream_buffer_core_pack : stream_buffer_core
  generic map (

    S_DATA_WIDTH         => S_PACK_DATA_WIDTH    ,
    S_CONTEXT_WIDTH      => 0                    ,
    SI_BUS_REGISTERED    => TRUE                 ,
    SO_WAIT_REGISTERED   => FALSE

  )
  port map (

    sysrstN              => sysrstN              ,
    sysclk               => sysclk               ,
    si_write             => s_cat_write          ,
    si_sync              => s_cat_sync           ,
    si_data              => s_pack_data_unbuf    ,
    si_beN               => s_pack_beN_unbuf     ,
    si_wait              => s_cat_wait           ,
    si_context           => open                 ,
    so_write             => s_pack_write         ,
    so_sync              => s_pack_sync          ,
    so_data              => s_pack_data          ,
    so_beN               => s_pack_beN           ,
    so_wait              => s_pack_wait          ,
    so_context           => open                 

  );


----------------------------------------------------
-- stream_resize_down
----------------------------------------------------
xstream_resize_down : stream_resize_down
  generic map (

    SI_DATA_WIDTH        => S_PACK_DATA_WIDTH    ,
    SI_CONTEXT_WIDTH     => 0                    ,
    SO_DATA_WIDTH        => SO_DATA_WIDTH        

  )
  port map (

    sysrstN              => sysrstN              ,
    sysclk               => sysclk               ,
    ABORT                => ABORT                ,
    region_of_interest   => nb_contexts          ,
    si_write             => s_pack_write         ,
    si_sync              => s_pack_sync          ,
    si_data              => s_pack_data          ,
    si_beN               => s_pack_beN           ,
    si_wait              => s_pack_wait          ,
    si_context           => open                 ,
    so_write             => s_resize_write       ,
    so_sync              => s_resize_sync        ,
    so_data              => s_resize_data        ,
    so_beN               => s_resize_beN         ,
    so_wait              => s_resize_wait        ,
    so_context           => open                 ,
    so_active            => so_active

  );



----------------------------------------------------
-- stream_buffer_core
----------------------------------------------------
xstream_buffer_core_out : stream_buffer_core
  generic map (

    S_DATA_WIDTH         => SO_DATA_WIDTH        ,
    S_CONTEXT_WIDTH      => 0                    ,
    SI_BUS_REGISTERED    => SO_DATA_REGISTERED   ,
    SO_WAIT_REGISTERED   => SO_WAIT_REGISTERED

  )
  port map (

    sysrstN              => sysrstN              ,
    sysclk               => sysclk               ,
    si_write             => s_resize_write       ,
    si_sync              => s_resize_sync        ,
    si_data              => s_resize_data        ,
    si_beN               => s_resize_beN         ,
    si_wait              => s_resize_wait        ,
    si_context           => open                 ,
    so_write             => s_out_write          ,
    so_sync              => s_out_sync           ,
    so_data              => s_out_data           ,
    so_beN               => s_out_beN            ,
    so_wait              => so_wait              ,
    so_context           => open                 

  );

  
-- output
so_write <= s_out_write;
so_sync  <= s_out_sync ;
so_data  <= s_out_data ;
so_beN   <= s_out_beN  ;


end functional;



