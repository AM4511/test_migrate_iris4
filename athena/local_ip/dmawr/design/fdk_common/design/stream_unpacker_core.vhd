----------------------------------------------------------------------
--  $HeadURL: svn://brainstorm/svn_ipcore/trunk/Matrox/Imaging/FDK/hw/cores/common/design/stream_unpacker_core.vhd $
--  $Revision: 9244 $
--  $Date: 2009-06-11 11:45:04 -0400 (Thu, 11 Jun 2009) $
--  $Author: palepin $
--
--  DESCRIPTION: Stream Unpacker core module
--
--
--            ________     ________     ________     ________      
--           |        |   |        |   |        |   |  fifo  |     
--           |        |   |        |   |        |-->|  with  |  -->
--  stream-->| resize |-->| unpack |-->| buffer |-->| resize |  -->  stream 
--    in     |   up   |   |  mux   |   |        |--> --------   -->   out
--           |        |   |        |   |        |-->  --------  -->
--           |        |   |        |   |        |      --------    
--            ¯¯¯¯¯¯¯¯     ¯¯¯¯¯¯¯¯     ¯¯¯¯¯¯¯¯        --------   
--
--               |                         |               |
--   widths:      \                         \               \
--                 |                         |               |
--                 |   S_PACK_DATA_WIDTH     |               |
--   SI_DATA_WIDTH |           =             | SI_DATA_WIDTH | SO_DATA_WIDTH
--                 | SI_DATA_WIDTH*SO_TOTAL  | (* SO_TOTAL)  | (* SO_TOTAL)
--                 |                         |               |
--
--
--
--
--  contains the following modules:
--      stream_fifo_core
--      stream_buffer_core
--      stream_unpacker_mux
--      stream_resize_up
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
--    SI_DATA_WIDTH        : (integer)
--
--                           width of si_data signal: 64, 128, etc.
--
--
--
--    SO_TOTAL             : (integer)  
--
--                           total amount of stream outputs / number of contexts
--
--
--
--    SO_DATA_WIDTH        : (integer)  
--
--                           width of so_data signal: 64, 128, etc.
--
--
--
--    SO_FIFO_DEPTH        : (integer)
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

entity stream_unpacker_core is
  generic (

    SI_DATA_WIDTH        : integer := 64        ; -- width of si_data signal: 64, 128, etc.
    SO_TOTAL             : integer := 1         ; -- number of stream output ports / number of contexts
    SO_DATA_WIDTH        : integer := 64        ; -- width of so_data signal: 64, 128, etc.
    SO_FIFO_DEPTH        : integer := 16        ; -- maximum FIFO depth per context
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
    ---------------------------------------------------------------------
    -- stream output port (master)  
    ---------------------------------------------------------------------
    si_write             : in        std_logic;
    si_sync              : in        std_logic_vector(1 downto 0);
    si_data              : in        std_logic_vector(SI_DATA_WIDTH-1 downto 0);
    si_beN               : in        std_logic_vector(SI_DATA_WIDTH/8 - 1 downto 0);
    si_wait              : out       std_logic;
    ---------------------------------------------------------------------
    -- stream input port (slave)
    ---------------------------------------------------------------------
    so_write             : out       std_logic_vector  (SO_TOTAL-1 downto 0);
    so_sync              : out       STD_LOGIC_ARRAY_2D(SO_TOTAL-1 downto 0, 1 downto 0);
    so_data              : out       STD_LOGIC_ARRAY_2D(SO_TOTAL-1 downto 0, SO_DATA_WIDTH-1 downto 0);
    so_beN               : out       STD_LOGIC_ARRAY_2D(SO_TOTAL-1 downto 0, SO_DATA_WIDTH/8 - 1 downto 0);
    so_wait              : in        std_logic_vector  (SO_TOTAL-1 downto 0);
    so_active            : out       std_logic

  );
end stream_unpacker_core;




architecture functional of stream_unpacker_core is

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
-- stream_unpacker_mux
----------------------------------------------------
component stream_unpacker_mux
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
end component;


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


  -----------------------------------------------------
  -- functions
  -----------------------------------------------------

  --  Function making a OR of a group of signals.
  function OrN (arg: std_logic_vector) return std_logic is
    variable result : std_logic;
  begin
    result := '0';

    for i in arg'range loop
      result := result or arg(i);
    end loop;

    return result;
  end OrN;
  

  -----------------------------------------------------
  -- constants
  -----------------------------------------------------

  -- stream_cat
  constant S_PACK_DATA_WIDTH     : integer := SI_DATA_WIDTH*SO_TOTAL;
  constant SO_FIFO_DATA_CAPACITY : integer := SO_FIFO_DEPTH*SO_DATA_WIDTH; -- maximum FIFO capacity in terms of number of bits of data


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

  -- resize
  signal s_resize_write         : std_logic;
  signal s_resize_sync          : std_logic_vector(1 downto 0);
  signal s_resize_data          : std_logic_vector(S_PACK_DATA_WIDTH-1 downto 0);
  signal s_resize_beN           : std_logic_vector(S_PACK_DATA_WIDTH/8 - 1 downto 0);
  signal s_resize_wait          : std_logic;

  -- packer multiplexer
  signal s_unpack_data          : std_logic_vector(S_PACK_DATA_WIDTH-1 downto 0);
  signal s_unpack_beN           : std_logic_vector(S_PACK_DATA_WIDTH/8 - 1 downto 0);

  -- buffer (after unpacker)
  signal s_unpack_buf_write     : std_logic;
  signal s_unpack_buf_sync      : std_logic_vector(1 downto 0);
  signal s_unpack_buf_data      : std_logic_vector(S_PACK_DATA_WIDTH-1 downto 0);
  signal s_unpack_buf_beN       : std_logic_vector(S_PACK_DATA_WIDTH/8 - 1 downto 0);
  signal s_unpack_buf_wait      : std_logic;

  -- cat (de-concatenator)
  signal s_cat_disable          : std_logic_vector(SO_TOTAL-1 downto 0);
  
  -- stream output fifos
  signal s_fifo_write           : std_logic_vector         (SO_TOTAL-1 downto 0);
  signal s_fifo_write_ff        : std_logic_vector         (SO_TOTAL-1 downto 0);
  signal s_fifo_sync            : ARRAY_IR_OF_SLV2         (SO_TOTAL-1 downto 0);
  signal s_fifo_data            : ARRAY_IR_OF_SI_DATA_WIDTH(SO_TOTAL-1 downto 0);
  signal s_fifo_beN             : ARRAY_IR_OF_SI_BEN_WIDTH (SO_TOTAL-1 downto 0);
  signal s_fifo_wait            : std_logic_vector         (SO_TOTAL-1 downto 0);

  signal so_write_out           : std_logic_vector         (SO_TOTAL-1 downto 0);
  signal so_sync_out            : ARRAY_IR_OF_SLV2         (SO_TOTAL-1 downto 0);
  signal so_data_out            : ARRAY_IR_OF_SO_DATA_WIDTH(SO_TOTAL-1 downto 0);
  signal so_beN_out             : ARRAY_IR_OF_SO_BEN_WIDTH (SO_TOTAL-1 downto 0);
  signal so_wait_out            : std_logic_vector         (SO_TOTAL-1 downto 0);


--synthesis translate_off
  signal signal_SO_FIFO_DATA_CAPACITY : integer := SO_FIFO_DATA_CAPACITY;
--synthesis translate_on

begin

----------------------------------------------------
-- stream_resize_up
----------------------------------------------------
xstream_resize_up : stream_resize_up
  generic map (

    SI_DATA_WIDTH        => SI_DATA_WIDTH        ,
    SO_DATA_WIDTH        => S_PACK_DATA_WIDTH       

  )
  port map (

    sysrstN              => sysrstN              ,
    sysclk               => sysclk               ,
    ABORT                => ABORT                ,
    region_of_interest   => nb_contexts          ,
    sol_shift            => open                 ,
    si_write             => si_write             ,
    si_sync              => si_sync              ,
    si_data              => si_data              ,
    si_beN               => si_beN               ,
    si_wait              => si_wait              ,
    si_flush             => open                 ,
    si_context           => open                 ,
    so_write             => s_resize_write       ,
    so_sync              => s_resize_sync        ,
    so_data              => s_resize_data        ,
    so_beN               => s_resize_beN         ,
    so_wait              => s_resize_wait        ,
    so_context           => open                 ,
    so_active            => open

  );


----------------------------------------------------
-- stream_unpacker_mux
----------------------------------------------------
xstream_unpacker_mux : stream_unpacker_mux
  generic map (

    NUMBER_OF_CONTEXTS   => SO_TOTAL             ,
    S_DATA_WIDTH         => S_PACK_DATA_WIDTH

  )
  port map (

    bit_depth            => bit_depth            ,
    nb_contexts          => nb_contexts          ,
    si_data              => s_resize_data        ,
    si_beN               => s_resize_beN         ,
    so_data              => s_unpack_data        ,
    so_beN               => s_unpack_beN

  );


----------------------------------------------------
-- stream_buffer_core (after unpack, before decat)
----------------------------------------------------
xstream_buffer_core_unpack : stream_buffer_core
  generic map (

    S_DATA_WIDTH         => S_PACK_DATA_WIDTH    ,
    S_CONTEXT_WIDTH      => 0                    ,
    SI_BUS_REGISTERED    => TRUE                 ,
    SO_WAIT_REGISTERED   => FALSE             

  )
  port map (

    sysrstN              => sysrstN              ,
    sysclk               => sysclk               ,
    si_write             => s_resize_write       ,
    si_sync              => s_resize_sync        ,
    si_data              => s_unpack_data        ,
    si_beN               => s_unpack_beN         ,
    si_wait              => s_resize_wait        ,
    si_context           => open                 ,
    so_write             => s_unpack_buf_write   ,
    so_sync              => s_unpack_buf_sync    ,
    so_data              => s_unpack_buf_data    ,
    so_beN               => s_unpack_buf_beN     ,
    so_wait              => s_unpack_buf_wait    ,
    so_context           => open       

  );




-------------------------------------------------------------------------------
-- clocked events
-------------------------------------------------------------------------------
process (sysrstN, sysclk)
   
begin  

  ----------
  -- reset
  ----------
  if (sysrstN = '0') then

    s_fifo_write_ff               <= (others => '0');

  elsif (sysclk'event and sysclk = '1') then                                         


    s_fifo_write_ff <= s_fifo_write;


  end if;

end process;


-----------------
-- s_cat_disable
-----------------
gen_s_cat_disable : for i in SO_TOTAL-1 downto 0 generate

  s_cat_disable(i) <= not context_enable(i) when nb_contexts > i else '1';

end generate gen_s_cat_disable;



  -------------------------------------------------
  -- De-Concatenation of Input stream
  -------------------------------------------------
  gen_cat_data : for i in SO_TOTAL-1 downto 0 generate
  begin

    -----------------
    -- s_fifo_data
    -----------------
    s_fifo_data(i) <= s_unpack_buf_data((i+1)*SI_DATA_WIDTH-1 downto i*SI_DATA_WIDTH);


    -----------------
    -- s_fifo_beN
    -----------------
    s_fifo_beN(i) <= s_unpack_buf_beN((i+1)*SI_DATA_WIDTH/8-1 downto i*SI_DATA_WIDTH/8);


    -----------------
    -- s_fifo_write
    -----------------
    s_fifo_write(i) <= (s_unpack_buf_write and not s_unpack_buf_wait and not s_cat_disable(i)) or 
                       (s_fifo_write_ff(i) and s_fifo_wait(i));
    

    -----------------
    -- s_fifo_sync
    -----------------
    s_fifo_sync(i) <= s_unpack_buf_sync;
    

  end generate gen_cat_data; 


  -----------------
  -- s_unpack_buf_wait
  -----------------
  s_unpack_buf_wait <= OrN(s_fifo_wait and not s_cat_disable);
  
  


  --------------------------------
  -- Output FIFOs with RESIZE
  --------------------------------
  gen_xstream_fifo_core_output : for i in SO_TOTAL-1 downto 0 generate
  begin

    -----------------------------------------------------
    -- stream input fifos
    -----------------------------------------------------
    xstream_fifo_core_output : stream_fifo_core
      generic map (

        SI_DATA_WIDTH        => SI_DATA_WIDTH        ,
        SO_DATA_WIDTH        => SO_DATA_WIDTH        ,
        DATA_CAPACITY        => SO_FIFO_DATA_CAPACITY,
        SO_WAIT_REGISTERED   => FALSE                ,
        BEN_ONLY_AT_EOL      => TRUE                 ,
        FPGA_ARCH            => FPGA_ARCH            ,
        FPGA_FAMILY          => FPGA_FAMILY

      )
      port map (

        sysrstN              => sysrstN              ,
        sysclk               => sysclk               ,
        ABORT                => ABORT                ,
        si_write             => s_fifo_write(i)      ,
        si_sync              => s_fifo_sync (i)      ,
        si_data              => s_fifo_data (i)      ,
        si_beN               => s_fifo_beN  (i)      ,
        si_wait              => s_fifo_wait (i)      ,
        so_write             => so_write_out(i)      ,
        so_sync              => so_sync_out (i)      ,
        so_data              => so_data_out (i)      ,
        so_beN               => so_beN_out  (i)      ,
        so_wait              => so_wait_out (i)      ,
        so_active            => open

      );


        so_write(i) <= so_write_out (i);

        gen_so_sync : for j in 1 downto 0 generate

          so_sync(i,j)         <= so_sync_out(i)(j);

        end generate gen_so_sync;
        
        gen_so_data : for j in SO_DATA_WIDTH-1 downto 0 generate

          so_data(i,j)         <= so_data_out(i)(j);

        end generate gen_so_data;
        
        gen_so_beN : for j in SO_DATA_WIDTH/8-1 downto 0 generate

          so_beN(i,j)         <= so_beN_out(i)(j);

        end generate gen_so_beN;
        
        so_wait_out(i) <= so_wait(i);


  end generate gen_xstream_fifo_core_output; 



end functional;



