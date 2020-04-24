----------------------------------------------------------------------
-- $HeadURL: svn://brainstorm/svn_ipcore/trunk/Matrox/Imaging/FDK/hw/cores/dmawr/design/dmawr_core.vhd $
-- $Revision: 10119 $
-- $Date: 2010-04-23 15:37:52 -0400 (Fri, 23 Apr 2010) $
-- $Author: mpoirie1 $
--
-- DESCRIPTION: dma write module
--
--
--                               bypass when in SINGLE-CONTEXT
--                                    ________/\________
--                                   /                  \                           
--            ________     ______     ________     ____      _______     ________     ________     _________
--           |        |   |      |   |        |   |    \    |       |   |        |   |        |   |         |
--           |        |   |      |   |        |-->|     |   |       |   |        |   |        |   |         |     
--  stream-->| buffer |-->| crop |-->| unpack |-->| mux |-->| shift |-->| buffer |-->| resize |-->|   ram   |---> ram 
--    in     |        |   |      |   |        |-->|     |   | left  |   |        |   |   up   |   |  write  |    write
--           |        |   |      |   |        |-->|     |   |       |   |        |   |        |   |         |
--           |        |   |      |   |   *    |   |    /    |       |   |        |   |        |   |    *    |
--            ¯¯¯¯¯¯¯¯     ¯¯¯¯¯¯     ¯¯¯¯¯¯¯¯     ¯¯¯¯      ¯¯¯¯¯¯¯     ¯¯¯¯¯¯¯¯     ¯¯¯¯¯¯¯¯     ¯¯¯¯¯¯¯¯¯ 
--  * contains FIFOs
--                                    |                  |                                |
--   data widths:                      \                  \                                \
--                                      |                  |                                |
--                                      |  SI_DATA_WIDTH   |                                |
--               SI_DATA_WIDTH          |        *         |        SI_DATA_WIDTH           |    RAM_DATA_WIDTH
--                                      | NUMBER_OF_PLANES |                                | 
--                                      |                  |                                |
--
--
--
--
--  Functionality           : supports byte alignment
--
--  Modules Used            : regfile_dmawr
--                            stream_buffer_core
--                            stream_crop_core
--                            stream_unpacker_core
--                            stream_shift_core
--                            stream_resize
--                            ram_write_core
--                
--  Packages Used           : std_logic_2d
--                            dmawr_pack
--                            regpack_dmawr
--
--
--
-- Notes for debug: 
--      - use tmp_timeout_counter to force simulation to end after long delay (this allows to force a dump of the sram)
--      - multi-context: uncomment "assert so_resize_context(1 downto 0) = so_resize_context(3 downto 2)" to allow extra 
--        verification (if error occurs, it can indicate an error in the logic)
--
--  to support seperate clock domains for sram, need to change counters to gray counters
--
----------------------------------------------------------------------- 

--MTX_START_SUPPRESS
-- altera message_level Level1
-- altera message_off 10030 10036 10445 
--MTX_END_SUPPRESS

library ieee;
  use ieee.std_logic_1164.all; 
  use ieee.numeric_std.all;
--  use ieee.std_logic_unsigned.all;
--  use ieee.std_logic_arith.all;

library work;
  use work.std_logic_2d.all;
  use work.dmawr_pack.all;
  use work.regfile_dmawr_pack.all;  

entity dmawr_core is
  generic (

    NUMBER_OF_PLANES     : integer := 1          ; -- max number of planes
    MAX_BURST_PER_CONTEXT: integer := 1          ; -- number of consecutive writes to one context before switching to the next context
    SI_TOTAL             : integer := 1          ; -- number of stream input ports
    SI_DATA_WIDTH        : integer := 64         ; -- width of si_data signal: 64, 128, etc.
    SW_DATA_WIDTH        : integer               ; -- width of sw_data signal : 32, 64, etc.  
    SW_ADDR_WIDTH        : integer               ; -- width of sw_addr signal : 24
    SW_BANKS             : integer               ; -- number of RAM banks: 1, 2, 4
    SW_THRESHOLD         : integer               ; -- amount of data to be accumulated in sram fifo before being evacuated
    SW_FIFO_DEPTH        : integer := 16         ; -- number of blocks of SW_DATA_WIDTH bits in FIFO
    SW_WAIT_REGISTERED   : boolean := TRUE       ; -- add a register on input signal sw_wait and extra glue logic
    FPGA_ARCH            : string  := "ALTERA"   ;
    FPGA_FAMILY          : string  := "STRATIX"    -- "STRATIX", "STRATIXII"

  );
  port (

    ----------------------------------------------------
    -- Reset, clock and mode signals
    ----------------------------------------------------
    sysrstN              : in        std_logic;
    sysclk               : in        std_logic;
    ----------------------------------------------------
    -- register port (slave)
    ----------------------------------------------------
    reg_write            : in        std_logic;                       
    reg_read             : in        std_logic;                       
    reg_addr             : in        std_logic_vector(8 downto 3);   
    reg_writedata        : in        std_logic_vector(63 downto 0);   
    reg_beN              : in        std_logic_vector(7 downto 0);   
    reg_readdata         : out       std_logic_vector(63 downto 0);  
    LNSIZE_out           : out       integer;  
    STARTADDR_lsb        : out       integer;
    ----------------------------------------------------
    -- stream input port (slave)
    ----------------------------------------------------
    si_write             : in        std_logic_vector  (SI_TOTAL-1 downto 0);
 -- not valid   si_sync              : in        STD_LOGIC_ARRAY_2D(SI_TOTAL-1 downto 0, 1 downto 0);
    si_data              : in        STD_LOGIC_ARRAY_2D(SI_TOTAL-1 downto 0, SI_DATA_WIDTH-1 downto 0);
    si_beN               : in        STD_LOGIC_ARRAY_2D(SI_TOTAL-1 downto 0, SI_DATA_WIDTH/8-1 downto 0);
    si_wait              : out       std_logic_vector  (SI_TOTAL-1 downto 0);
    ----------------------------------------------------
    -- ram write (master)
    ----------------------------------------------------
    sw_writeN            : out       std_logic_vector  (SW_BANKS-1 downto 0);      
    sw_addr              : out       STD_LOGIC_ARRAY_2D(SW_BANKS-1 downto 0, SW_ADDR_WIDTH-1 downto 0);
    sw_data              : out       STD_LOGIC_ARRAY_2D(SW_BANKS-1 downto 0, SW_DATA_WIDTH-1 downto 0);
    sw_sync              : out       STD_LOGIC_ARRAY_2D(SW_BANKS-1 downto 0, 1 downto 0);
    sw_beN               : out       STD_LOGIC_ARRAY_2D(SW_BANKS-1 downto 0, SW_DATA_WIDTH/8-1 downto 0);
    sw_fifo_threshold    : out       std_logic_vector  (SW_BANKS-1 downto 0);
    sw_wait              : in        std_logic_vector  (SW_BANKS-1 downto 0);      
    ----------------------------------------------------
    -- interrupt events
    ----------------------------------------------------
    LSBOF                : in        std_logic_vector(6 downto 0);
    intevent             : out       std_logic

  );
end dmawr_core;

architecture functional of dmawr_core is


----------------------------
-- regfile_dmawr
----------------------------
component regfile_dmawr 
   port (
      sysrstN       : in    std_logic;                                     -- System reset
      sysclk        : in    std_logic;                                     -- System clock
      regfile       : inout REGFILE_DMAWR_TYPE := INIT_REGFILE_DMAWR_TYPE; -- Register file
      ------------------------------------------------------------------------------------
      -- Interface name: registerFileIF
      -- Description: 
      ------------------------------------------------------------------------------------
      reg_read      : in    std_logic;                                     -- Read
      reg_write     : in    std_logic;                                     -- Write
      reg_addr      : in    std_logic_vector(8 downto 3);                  -- Address
      reg_beN       : in    std_logic_vector(7 downto 0);                  -- Byte enable
      reg_writedata : in    std_logic_vector(63 downto 0);                 -- Write data
      reg_readdata  : out   std_logic_vector(63 downto 0)                  -- Read data
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


-------------------------------------------------
-- stream_crop_core
-------------------------------------------------
component stream_crop_core
  generic (

    MAX_LNSIZE                : integer := 2**20-1;     
    MAX_NBLINE                : integer := 2**20-1;
    S_DATA_WIDTH              : integer := 64     ;     -- width of s*_data signal: 64, 128, etc.
    PIPELINE_OUTPUT           : boolean := TRUE   ;       
    SO_WAIT_REGISTERED        : boolean := TRUE       

  );
  port (

    ----------------------------------------------------
    -- Reset, clock and mode signals
    ----------------------------------------------------
    sysrstN              : in        std_logic;
    sysclk               : in        std_logic;
    ABORT                : in        std_logic;
    LNSIZE               : in        integer;     -- 0 = no horizontal cropping
    NBLINE               : in        integer;     -- 0 = no vertical cropping
    ----------------------------------------------------
    -- stream input port (slave)
    ----------------------------------------------------
    si_write             : in        std_logic;
    si_sync              : in        std_logic_vector(1 downto 0);
    si_data              : in        std_logic_vector(S_DATA_WIDTH-1 downto 0);
    si_beN               : in        std_logic_vector(S_DATA_WIDTH/8 - 1 downto 0);
    si_wait              : buffer    std_logic;
    ----------------------------------------------------
    -- stream output port (master)  
    ----------------------------------------------------
    so_write             : buffer    std_logic;
    so_sync              : buffer    std_logic_vector(1 downto 0);
    so_data              : buffer    std_logic_vector(S_DATA_WIDTH-1 downto 0);
    so_beN               : buffer    std_logic_vector(S_DATA_WIDTH/8 - 1 downto 0);
    so_wait              : in        std_logic

  );
end component;



----------------------------------------------------
-- stream_unpacker_core
----------------------------------------------------
component stream_unpacker_core
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
end component;


-------------------------------------------------
-- stream_shift_core
-------------------------------------------------
component stream_shift_core
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
end component;


----------------------------------------------------
-- stream_resize
----------------------------------------------------
component stream_resize
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
end component;


-------------------------------------------------
-- ram_write_core
-------------------------------------------------
component ram_write_core
  generic (

    RAM_DATA_WIDTH            : integer               ; -- width of ram_data signal : 32, 64, etc.  
    RAM_ADDR_WIDTH            : integer               ; -- width of ram_addr signal
    RAM_CMD_REGISTERED        : boolean := TRUE       ; -- register input signals ram_write, ram_addr, ram_data and ram_beN
    RAM_WAIT_REGISTERED       : boolean := FALSE      ; -- register output signal ram_wait and add extra glue logic
    SW_DATA_WIDTH             : integer               ; -- width of sw_data signal : 32, 64, etc.  
    SW_ADDR_WIDTH             : integer               ; -- width of sw_addr signal : 24
    SW_BANKS                  : integer               ; -- number of RAM banks: 1, 2, 4
    SW_THRESHOLD              : integer               ; -- amount of data to be accumulated in sram fifo before being evacuated
    SW_FIFO_DEPTH             : integer := 16         ; -- number of blocks of SW_DATA_WIDTH bits in FIFO
    SW_WAIT_REGISTERED        : boolean := TRUE       ; -- register on input signal sw_wait and extra glue logic
    FPGA_ARCH                 : string  := "ALTERA"   ;
    FPGA_FAMILY               : string  := "STRATIXII"  -- "STRATIX", "STRATIXII"

  );
  port (

    ---------------------------------------------------------------------
    -- Reset, clock and mode signals
    ---------------------------------------------------------------------
    sysrstN                   : in        std_logic                     ;
    sysclk                    : in        std_logic                     ;
    ABORT                     : in        std_logic := '0'              ;
    ---------------------------------------------------------------------
    -- write command
    ---------------------------------------------------------------------
    ram_write                 : in        std_logic                     ;
    ram_addr                  : in        std_logic_vector(RAM_ADDR_WIDTH-1 downto 0); 
    ram_data                  : in        std_logic_vector(RAM_DATA_WIDTH-1 downto 0);
    ram_sync                  : in        std_logic_vector(1 downto 0);
    ram_beN                   : in        std_logic_vector(RAM_DATA_WIDTH/8-1 downto 0);
    ram_flush                 : in        std_logic                     ;
    ram_wait                  : buffer    std_logic                     ;
    ram_active                : buffer    std_logic                     ;
    ---------------------------------------------------------------------
    -- write master port
    ---------------------------------------------------------------------
    sw_writeN                 : out       std_logic_vector  (SW_BANKS-1 downto 0);      
    sw_addr                   : out       STD_LOGIC_ARRAY_2D(SW_BANKS-1 downto 0, SW_ADDR_WIDTH-1 downto 0);
    sw_data                   : out       STD_LOGIC_ARRAY_2D(SW_BANKS-1 downto 0, SW_DATA_WIDTH-1 downto 0);
    sw_sync                   : out       STD_LOGIC_ARRAY_2D(SW_BANKS-1 downto 0, 1 downto 0);
    sw_beN                    : out       STD_LOGIC_ARRAY_2D(SW_BANKS-1 downto 0, SW_DATA_WIDTH/8-1 downto 0);
    sw_fifo_threshold         : out       std_logic_vector  (SW_BANKS-1 downto 0);
    sw_wait                   : in        std_logic_vector  (SW_BANKS-1 downto 0)

    );

end component;


  -----------------------------------------------------
  -- constants
  -----------------------------------------------------
  constant RAM_DATA_WIDTH            : integer := SW_BANKS*SW_DATA_WIDTH;

  constant SW_BANKS_LOG2             : integer := log2(SW_BANKS);  
  constant LNPITCH_RESOLUTION        : integer := log2(RAM_DATA_WIDTH/8);  

  -- ram_write_core
  constant SW_DFIFO_DEPTH            : integer := SW_FIFO_DEPTH;  
  constant SW_AFIFO_DEPTH            : integer := SW_DFIFO_DEPTH;

  -- regfile_dmawr
  constant IPHWVER_slv               : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(IPHWVER,  5));

  constant SOF  : std_logic_vector(1 downto 0) := "00";
  constant SOL  : std_logic_vector(1 downto 0) := "01";
  constant CNT  : std_logic_vector(1 downto 0) := "10";
  constant EOF  : std_logic_vector(1 downto 0) := "11";

  -----------------------------------------------------
  -- types
  -----------------------------------------------------
  type ARRAY_OF_INTEGER                is array (integer range <>) of integer;
  type ARRAY_OF_UNSIGNED36             is array (natural range <>) of unsigned(35 downto 0);
  type ARRAY_IR_OF_SLV32               is array (integer range <>) of std_logic_vector(31 downto 0);
  type ARRAY_OF_SLV31                  is array (integer range <>) of std_logic_vector(30 downto 0);
  type ARRAY_OF_SLV32                  is array (integer range <>) of std_logic_vector(31 downto 0);
  type ARRAY_OF_SLV36                  is array (integer range <>) of std_logic_vector(35 downto 0);
  type ARRAY_OF_SLV2                   is array (integer range <>) of std_logic_vector( 1 downto 0);
  type ARRAY_OF_AG_ADDR                is array (integer range <>) of std_logic_vector(SW_ADDR_WIDTH+SW_BANKS_LOG2-1 downto 0);
  type ARRAY_OF_RAM_DATA_WIDTH         is array (integer range <>) of std_logic_vector(RAM_DATA_WIDTH-1 downto 0);
  type ARRAY_OF_RAM_SYNC_WIDTH         is array (integer range <>) of std_logic_vector(1 downto 0);  
  type ARRAY_OF_RAM_BEN_WIDTH          is array (integer range <>) of std_logic_vector(RAM_DATA_WIDTH/8-1 downto 0);
  type ARRAY_OF_SI_DATA_WIDTH          is array (integer range <>) of std_logic_vector(SI_DATA_WIDTH-1 downto 0);
  type ARRAY_OF_SI_BEN_WIDTH           is array (integer range <>) of std_logic_vector(SI_DATA_WIDTH/8-1 downto 0);
  
 
  -----------------------------------------------------
  -- signals
  -----------------------------------------------------

  -- general
  signal stream_active               : std_logic;
  signal dmawr_end                   : std_logic;

  -- register signals
  signal regfile                     : REGFILE_DMAWR_TYPE := INIT_REGFILE_DMAWR_TYPE;
  signal FSTART                      : ARRAY_OF_SLV36(3 downto 0);
  signal LNPITCH                     : std_logic_vector(35 downto 0) := (others=> '0');--ARRAY_OF_SLV36(SI_TOTAL-1 downto 0) := (others => (others=> '0'));
  signal ABORT                       : std_logic;
  signal SNPPDG                      : std_logic;
  signal ACTIVE                      : std_logic;
  signal SNPSHT                      : std_logic;
  signal LNSIZE                      : ARRAY_OF_SLV31(SI_TOTAL-1 downto 0);
  signal LNSIZE_int                  : ARRAY_OF_INTEGER(SI_TOTAL-1 downto 0);
  signal NBLINE                      : ARRAY_OF_SLV31(SI_TOTAL-1 downto 0);
  signal NBLINE_int                  : ARRAY_OF_INTEGER(SI_TOTAL-1 downto 0);
  signal BUFCLR                      : std_logic;  
  signal DTE                         : std_logic_vector(3 downto 0);
  signal BITWDTH                     : std_logic;
  signal NBCONTX                     : std_logic_vector(1 downto 0);
  signal CLRPTRN                     : std_logic_vector(31 downto 0);

  -- multi-context
  signal bit_depth                   : integer;
  signal nb_contexts                 : integer range 1 to 4;
  signal context_enable              : std_logic_vector(3 downto 0) := (others => '0');
  signal total_active_context        : integer range 1 to 4;
  signal change_context_pre          : std_logic;
  signal change_context              : std_logic;
  signal change_context_ff           : std_logic;
  signal context                     : integer range 0 to NUMBER_OF_PLANES-1;
  signal context_list                : ARRAY_OF_INTEGER(3 downto 0) := (others => 0);
  signal context_list_sel            : integer range 3 downto 0 := 0;

  -- stream generation
  signal xcntr                     : integer range 0 to 2**16 - 1;
  signal ycntr                     : integer range 0 to 2**20 - 1;
  signal sof_done                  : std_logic;
  signal eof_done                  : std_logic;
  signal sg_write                  : std_logic;
  signal sg_sync                   : std_logic_vector(1 downto 0);
  signal sg_data                   : std_logic_vector(SI_DATA_WIDTH-1 downto 0);
  signal sg_beN                    : std_logic_vector(SI_DATA_WIDTH/8-1 downto 0);
  signal sg_wait                   : std_logic_vector(SI_TOTAL-1 downto 0);
  signal si_data_ff                : ARRAY_OF_SI_DATA_WIDTH(SI_TOTAL-1 downto 0);
  signal si_beN_ff                 : ARRAY_OF_SI_BEN_WIDTH(SI_TOTAL-1 downto 0);
  
  --attribute mark_debug : string;
  --attribute mark_debug of sg_sync         : signal is "true";
  --attribute mark_debug of sg_write        : signal is "true";  
  
  -- stream input port 
  signal s_write                   : std_logic_vector      (SI_TOTAL-1 downto 0);
  signal s_sync                    : ARRAY_OF_SLV2         (SI_TOTAL-1 downto 0);
  signal s_data                    : ARRAY_OF_SI_DATA_WIDTH(SI_TOTAL-1 downto 0);
  signal s_beN                     : ARRAY_OF_SI_BEN_WIDTH (SI_TOTAL-1 downto 0);
  signal s_wait                    : std_logic_vector      (SI_TOTAL-1 downto 0);

  -- stream_buffer_core
  signal s_buf_write                 : std_logic_vector      (SI_TOTAL-1 downto 0);
  signal s_buf_sync                  : ARRAY_OF_SLV2         (SI_TOTAL-1 downto 0);
  signal s_buf_data                  : ARRAY_OF_SI_DATA_WIDTH(SI_TOTAL-1 downto 0);
  signal s_buf_beN                   : ARRAY_OF_SI_BEN_WIDTH (SI_TOTAL-1 downto 0); 
  signal s_buf_wait                  : std_logic_vector      (SI_TOTAL-1 downto 0);
  signal s_buf_wait_int              : std_logic_vector      (SI_TOTAL-1 downto 0);
  signal s_buf_sof                   : std_logic_vector      (SI_TOTAL-1 downto 0);

  -- stream_crop_core
  signal crop_write                  : std_logic_vector      (SI_TOTAL-1 downto 0);
  signal crop_sync                   : ARRAY_OF_SLV2         (SI_TOTAL-1 downto 0);
  signal crop_data                   : ARRAY_OF_SI_DATA_WIDTH(SI_TOTAL-1 downto 0);
  signal crop_beN                    : ARRAY_OF_SI_BEN_WIDTH (SI_TOTAL-1 downto 0);
  signal crop_wait                   : std_logic_vector      (SI_TOTAL-1 downto 0);
  
  -- stream_unpacker_core
  signal s_unpack_write              : std_logic_vector         (NUMBER_OF_PLANES-1 downto 0) := (others => '0');
  signal s_unpack_sync               : STD_LOGIC_ARRAY_2D       (NUMBER_OF_PLANES-1 downto 0, 1 downto 0);
  signal s_unpack_data               : STD_LOGIC_ARRAY_2D       (NUMBER_OF_PLANES-1 downto 0, SI_DATA_WIDTH-1 downto 0);
  signal s_unpack_beN                : STD_LOGIC_ARRAY_2D       (NUMBER_OF_PLANES-1 downto 0, SI_DATA_WIDTH/8 - 1 downto 0);
  signal s_unpack_wait               : std_logic_vector         (NUMBER_OF_PLANES-1 downto 0);

  -- context signals before mux
  signal ctx_byteshift               : ARRAY_OF_INTEGER(3 downto 0) := (others => 0);
  signal ctx_sol_shift               : ARRAY_OF_INTEGER(3 downto 0) := (others => 0);
  signal ctx_write                   : std_logic_vector         (NUMBER_OF_PLANES-1 downto 0);
  signal ctx_sync                    : ARRAY_OF_SLV2            (NUMBER_OF_PLANES-1 downto 0);
  signal ctx_data                    : ARRAY_OF_SI_DATA_WIDTH   (NUMBER_OF_PLANES-1 downto 0);
  signal ctx_beN                     : ARRAY_OF_SI_BEN_WIDTH    (NUMBER_OF_PLANES-1 downto 0);
  signal ctx_wait                    : std_logic_vector         (NUMBER_OF_PLANES-1 downto 0);
  signal ctx_force_cont              : std_logic_vector         (NUMBER_OF_PLANES-1 downto 0);

  -- context arbitration
  signal ctx_counter1                : integer range 0 to MAX_BURST_PER_CONTEXT*RAM_DATA_WIDTH/SI_DATA_WIDTH-1;
  signal ctx_counter1_x              : ARRAY_OF_INTEGER(3 downto 0) := (others => 0);
  signal ctx_counter2_int            : integer range 0 to RAM_DATA_WIDTH/SI_DATA_WIDTH-1;
  signal ctx_counter2_init           : integer range 0 to RAM_DATA_WIDTH/SI_DATA_WIDTH-1;
  signal ctx_counter2                : integer range 0 to RAM_DATA_WIDTH/SI_DATA_WIDTH-1;

  -- shift left
  signal si_shift_byteshift          : integer;
  signal si_shift_write              : std_logic;
  signal si_shift_write_masked       : std_logic;
  signal si_shift_sync               : std_logic_vector(1 downto 0);
  signal si_shift_data               : std_logic_vector(SI_DATA_WIDTH-1 downto 0);
  signal si_shift_beN                : std_logic_vector(SI_DATA_WIDTH/8-1 downto 0);
  signal si_shift_wait               : std_logic;
  signal si_shift_wait_ff            : std_logic;
  signal si_shift_flush              : std_logic;
  signal si_shift_context            : std_logic_vector(log2(NUMBER_OF_PLANES) downto 1);
  signal si_shift_sol                : std_logic;
  signal si_shift_eof                : std_logic;
  signal si_shift_eof_detected       : std_logic;

  signal so_shift_write              : std_logic;
  signal so_shift_sync               : std_logic_vector(1 downto 0);
  signal so_shift_data               : std_logic_vector(SI_DATA_WIDTH-1 downto 0);
  signal so_shift_beN                : std_logic_vector(SI_DATA_WIDTH/8-1 downto 0);
  signal so_shift_wait               : std_logic;
  signal so_shift_context            : std_logic_vector(log2(NUMBER_OF_PLANES) downto 1);

  -- resize up
  signal sol_shift                   : integer range 0 to RAM_DATA_WIDTH/8-1 := 0;

  signal si_resize_write             : std_logic;               
  signal si_resize_sync              : std_logic_vector(1 downto 0);
  signal si_resize_data              : std_logic_vector(SI_DATA_WIDTH-1 downto 0);
  signal si_resize_beN               : std_logic_vector(SI_DATA_WIDTH/8-1 downto 0);
  signal si_resize_wait              : std_logic;
  signal si_resize_flush             : std_logic;
  signal si_resize_context           : std_logic_vector(log2(NUMBER_OF_PLANES) downto 1);

  signal so_resize_write             : std_logic;               
  signal so_resize_sync              : std_logic_vector(1 downto 0);
  signal so_resize_data              : std_logic_vector(RAM_DATA_WIDTH-1 downto 0);
  signal so_resize_beN               : std_logic_vector(RAM_DATA_WIDTH/8-1 downto 0);
  signal so_resize_wait              : std_logic;
  signal so_resize_context           : std_logic_vector(log2(NUMBER_OF_PLANES)*RAM_DATA_WIDTH/SI_DATA_WIDTH downto 1);
  signal so_resize_sol               : std_logic;
  signal so_resize_sof               : std_logic;
  signal so_resize_eof               : std_logic;

  -- before mux for ram access
  signal ram_eof_ctx                 : std_logic_vector         (NUMBER_OF_PLANES-1 downto 0);
  signal ram_addr_ctx                : ARRAY_OF_AG_ADDR         (NUMBER_OF_PLANES-1 downto 0);
  signal ram_addr_int_ctx            : ARRAY_OF_AG_ADDR         (NUMBER_OF_PLANES-1 downto 0);
  signal ram_addr_nxtline_ctx        : ARRAY_OF_AG_ADDR         (NUMBER_OF_PLANES-1 downto 0);
  signal ram_addr_nxtline_ctx_36b    : ARRAY_OF_SLV36           (NUMBER_OF_PLANES-1 downto 0);

  -- ram_write_core
  signal ram_addr                    : std_logic_vector(SW_ADDR_WIDTH+SW_BANKS_LOG2-1 downto 0); 
  signal ram_data                    : std_logic_vector(RAM_DATA_WIDTH-1 downto 0);
  signal ram_sync                    : std_logic_vector(1 downto 0);
  signal ram_beN                     : std_logic_vector(RAM_DATA_WIDTH/8-1 downto 0);
  signal ram_write                   : std_logic;
  signal ram_flush                   : std_logic;
  signal ram_wait                    : std_logic;
  signal ram_active                  : std_logic;
  signal ram_context                 : integer range 0 to NUMBER_OF_PLANES-1;

  signal tmp_timeout_counter         : integer := 0;
  signal assert_error                : std_logic;


--synthesis translate_off
  signal signal_SI_DATA_WIDTH        : integer := SI_DATA_WIDTH ; -- width of si_data signal: 64, 128, etc.
  signal signal_SW_DATA_WIDTH        : integer := SW_DATA_WIDTH ; -- width of sw_data signal : 32, 64, etc.  
  signal signal_SW_ADDR_WIDTH        : integer := SW_ADDR_WIDTH ; -- width of sw_addr signal : 24
  signal signal_SW_BANKS             : integer := SW_BANKS      ; -- number of RAM banks: 2, 4
  signal signal_RAM_DATA_WIDTH       : integer := RAM_DATA_WIDTH;
--synthesis translate_on











begin


--synthesis translate_off

  -------------------------------------------------
  -- Verify that SW_THRESHOLD < or = to SW_FIFO_DEPTH
  -------------------------------------------------
  assert SW_THRESHOLD <= SW_FIFO_DEPTH
    report "SW_THRESHOLD is greater than SW_FIFO_DEPTH in dmawr_core module"
    severity FAILURE;

  assert assert_error /= '1'
    report "assert_error"
    severity FAILURE;

--  assert so_resize_context(1 downto 0) = so_resize_context(3 downto 2)
--    report "so_resize_context(1 downto 0) /= so_resize_context(3 downto 2) in dmawr_core module"
--    severity FAILURE;

--synthesis translate_on





  ----------------------------
  -- regfile_dmawr
  ----------------------------
  xregfile_dmawr : regfile_dmawr
   port map (
       sysclk         => sysclk,
       sysrstN        => sysrstN,
       regfile        => regfile,
       reg_read       => reg_read, 
       reg_write      => reg_write,
       reg_addr       => reg_addr,
       reg_beN        => reg_beN,
       reg_writedata  => reg_writedata,
       reg_readdata   => reg_readdata
   );

  regfile.header.fint.lsbof       <= LSBOF;
  regfile.header.fversion.IPHWVER <= IPHWVER_slv;                                                               
  regfile.header.fversion.SUBFID  <= X"00" when (SW_BANKS = 1 and NUMBER_OF_PLANES = 1 and SW_THRESHOLD /= 0 and SW_DATA_WIDTH = 128) else -- 1 x 128-bit sdram bank
                                     X"01" when (SW_BANKS = 2 and NUMBER_OF_PLANES = 1 and SW_THRESHOLD = 0)                          else -- 2 x 32-bit sram banks
                                     X"02" when (SW_BANKS = 4 and NUMBER_OF_PLANES = 1 and SW_THRESHOLD = 0)                          else -- 4 x 32-bit sram banks
                                     X"03" when (SW_BANKS = 1 and NUMBER_OF_PLANES = 1 and SW_THRESHOLD /= 0 and SW_DATA_WIDTH = 256) else -- 1 x 256-bit sdram bank
                                     X"04" when (SW_BANKS = 1 and NUMBER_OF_PLANES = 1 and SW_THRESHOLD /= 0 and SW_DATA_WIDTH = 512 and SI_TOTAL = 1) else -- 1 x 512-bit sdram bank
                                     X"05" when (SW_BANKS = 1 and NUMBER_OF_PLANES = 4 and SW_THRESHOLD /= 0 and SW_DATA_WIDTH = 512) else -- 1 x 512-bit sdram bank, 4 contexts
                                     X"06" when (SW_BANKS = 1 and NUMBER_OF_PLANES = 1 and SW_THRESHOLD /= 0 and SW_DATA_WIDTH = 512 and SI_TOTAL = 4) else -- 1 x 512-bit sdram bank, 4 streams
                                     X"07" when (SW_BANKS = 1 and NUMBER_OF_PLANES = 1 and SW_THRESHOLD /= 0 and SW_DATA_WIDTH = 512 and SI_TOTAL = 2) else -- 1 x 512-bit sdram bank, 2 streams
                                     X"FF";
  regfile.header.fctrl.snppdg     <= SNPPDG;  
  regfile.header.fctrl.active     <= ACTIVE;

  SNPSHT     <= regfile.header.fctrl.SNPSHT;
  ABORT      <= regfile.header.fctrl.ABORT;

  FSTART(0)  <= regfile.user.dstfstart.FSTART;
  FSTART(1)  <= regfile.user.dstfstart1.FSTART;
  FSTART(2)  <= regfile.user.dstfstart2.FSTART;
  FSTART(3)  <= regfile.user.dstfstart3.FSTART;

  LNPITCH(LNPITCH'left downto LNPITCH_RESOLUTION) <= regfile.user.dstlnpitch.LNPITCH(LNPITCH'left downto LNPITCH_RESOLUTION);--conv_integer(LNPITCH_MASKED(0));
  LNPITCH(LNPITCH_RESOLUTION-1 downto 0) <= (others => '0');

  LNSIZE(0)  <= regfile.user.dstlnsize.LNSIZE;
  NBLINE(0)  <= regfile.user.dstnbline.NBLINE;

  BUFCLR     <= regfile.user.dstctrl.BUFCLR;
  DTE(3)     <= regfile.user.dstctrl.DTE3;
  DTE(2)     <= regfile.user.dstctrl.DTE2;
  DTE(1)     <= regfile.user.dstctrl.DTE1;
  DTE(0)     <= regfile.user.dstctrl.DTE0;
  BITWDTH    <= regfile.user.dstctrl.BITWDTH;
  NBCONTX    <= regfile.user.dstctrl.NBCONTX;

  CLRPTRN    <= regfile.user.dstclrptrn.CLRPTRN;

  bit_depth   <= 8 when BITWDTH = '0' else 16;
  --nb_contexts <= low(conv_integer(NBCONTX) + 1, NUMBER_OF_PLANES);
  nb_contexts <= to_integer(unsigned(NBCONTX)) + 1 when (to_integer(unsigned(NBCONTX)) + 1) < NUMBER_OF_PLANES else NUMBER_OF_PLANES;


  ------------------
  -- total_active_context
  ------------------
  total_active_context <= 4 when context_enable = "1111" else
                          3 when context_enable = "0111" or context_enable = "1011" or context_enable = "1101" or context_enable = "1110" else
                          2 when context_enable = "0011" or context_enable = "0101" or context_enable = "1001" or 
                                 context_enable = "0110" or context_enable = "1010" or context_enable = "1100" else
                          1;

  ------------------
  -- context_list
  ------------------
  context_list(0) <= 0 when context_enable(0) = '1' else
                     1 when context_enable(1) = '1' else
                     2 when context_enable(2) = '1' else
                     3 when context_enable(3) = '1' else
                     0;

  context_list(1) <= 1 when context_enable(0) = '1' and context_enable(1) = '1' else
                     2 when (context_enable(0) = '1' or context_enable(1) = '1') and context_enable(2) = '1' else
                     3;

  context_list(2) <= 2 when context_enable(0) = '1' and context_enable(1) = '1' and context_enable(2) = '1' else
                     3;

  context_list(3) <= 3;


  ----------------------------
  -- Stream generator
  ----------------------------
  -- Generate sync, write and beN.
  -- Keep a count of the number of pixels and number of lines sent.
  stream_gen_p: process(sysclk, sysrstN)
  begin
    if sysrstN = '0' then
      xcntr      <= 0;
      ycntr      <= 0;
      sg_write   <= '0';
      sg_sync    <= CNT;--(others => '0');
      eof_done   <= '0';
      sof_done   <= '0';
    elsif sysclk'event and sysclk = '1' then
    
      -- Hold current values when destination is not ready
	    --   when using the dest clear pattern     -- when using the input data; supports only one stream input!
      if ((OrN(sg_wait) = '0' and BUFCLR = '1' and SNPSHT = '1') or (s_wait(0) = '0' and si_write(0) = '1' and BUFCLR = '0' and SNPPDG = '1' and sof_done = '0'))  then
        -- Beginning of frame
        if (LNSIZE_int(0) > SI_DATA_WIDTH/8) then
           xcntr    <= LNSIZE_int(0) - SI_DATA_WIDTH/8;
        else
           xcntr    <= 0;
        end if;
        ycntr    <= to_integer(unsigned(NBLINE(0))) - 1;            
        sg_write <= '1';
        sg_sync  <= SOF;
        eof_done <= '0';
        sof_done   <= '1';
      
      elsif ((OrN(sg_wait) = '0' and BUFCLR = '1') or (s_wait(0) = '0' and si_write(0) = '1' and BUFCLR = '0')) and eof_done = '0' and (SNPPDG = '1' or ACTIVE = '1')  then

        sg_write <= '1';

        if xcntr = 0 and ycntr = 0 then
          -- End of frame
          sg_sync  <= EOF;
          eof_done <= '1';
        elsif xcntr = 0 then
          -- Beginning of line
          if (LNSIZE_int(0) > SI_DATA_WIDTH/8) then
            xcntr  <= LNSIZE_int(0) - SI_DATA_WIDTH/8;
          else
            xcntr  <= 0;
          end if;
          ycntr    <= ycntr - 1;
          sg_sync  <= SOL;
        elsif xcntr < SI_DATA_WIDTH/8 then
          -- Last slice of line
          xcntr    <= 0;
          sg_sync  <= CNT;
        else
          xcntr    <= xcntr - SI_DATA_WIDTH/8;
          sg_sync  <= CNT;
        end if;
      elsif (s_wait(0) = '0' and sg_write = '1' and BUFCLR = '0' and xcntr = 0 and ycntr = 0 and eof_done = '0' and (SNPPDG = '1' or ACTIVE = '1')) then
        -- End of frame
        sg_write <= '1'; 
        sg_sync  <= EOF;
        eof_done <= '1';
      elsif eof_done = '1' and ((OrN(sg_wait) = '0' and BUFCLR = '1') or (s_wait(0) = '0' and BUFCLR = '0')) then
        sg_write <= '0';
        sg_sync  <= CNT;
        sof_done <= '0';
      elsif (s_wait(0) = '0' and si_write(0) = '0' and BUFCLR = '0') then
         sg_write <= '0';
      end if;
    end if;
  end process stream_gen_p;

  gen_sg_data: for i in SI_DATA_WIDTH/32-1 downto 0 generate
     sg_data(((i+1)*32)-1 downto (i*32)) <= CLRPTRN;
  end generate;
  
  -- Byte enable on last slice of line depends on LNSIZE
  -- but it is readjusted in the stream_crop module.
  sg_beN  <= (others => '1') when sg_sync = EOF else (others => '0');


gen_stream_in : for i in SI_TOTAL-1 downto 0 generate

   process(sysclk)
   begin
      if rising_edge(sysclk) then
         if (s_wait(i) = '0') then
            si_data_ff(i)<= array2slv(si_data, i);
            si_beN_ff(i) <= array2slv(si_beN, i);
         end if;
      end if;
   end process;


    -- Select between stream input port (si) and internal stream generation (sg).
    -- Stream generation is used to clear the memory with a programmable pattern.
    --
    -- *** sync signal for the stream input has to be regenerated with the stream generation logic.
    -- *** Use the write signal from the stream generation logic on EOF, because the write signal
    --     on the stream input is not always 1. EOF occurs after the last valid data has been transmitted.
    ------------------
    -- s_write
    -- s_sync 
    -- s_data 
    -- s_beN  
    -- s_wait 
    ------------------
    s_write(i) <= sg_write;-- when (BUFCLR = '1' or (BUFCLR = '0' and sg_sync = EOF)) else si_write(i);
    s_sync (i) <= sg_sync;
    s_data (i) <= sg_data  when BUFCLR = '1' else si_data_ff(i);
    s_beN  (i) <= sg_beN   when BUFCLR = '1' or sg_sync = EOF else si_beN_ff(i);
    si_wait(i) <= s_wait(i) or (not SNPPDG and not ACTIVE) when BUFCLR = '0' else '0';
    sg_wait(i) <= s_wait(i) when BUFCLR = '1' else '0';



  ----------------------------------------------------
  -- stream_buffer_core
  ----------------------------------------------------
  xstream_buffer_core_in : stream_buffer_core
    generic map (

      S_DATA_WIDTH         => SI_DATA_WIDTH        ,
      S_CONTEXT_WIDTH      => 0                    ,
      SI_BUS_REGISTERED    => TRUE                 ,
      SO_WAIT_REGISTERED   => FALSE

    )
    port map (

      sysrstN              => sysrstN              ,
      sysclk               => sysclk               ,
      si_write             => s_write    (i)       ,
      si_sync              => s_sync     (i)       ,
      si_data              => s_data     (i)       ,
      si_beN               => s_beN      (i)       ,
      si_wait              => s_wait     (i)       ,
      si_context           => open                 ,
      so_write             => s_buf_write(i)       ,
      so_sync              => s_buf_sync (i)       ,
      so_data              => s_buf_data (i)       ,
      so_beN               => s_buf_beN  (i)       ,
      so_wait              => s_buf_wait (i)       ,
      so_context           => open       

    );


    ------------------
    -- s_buf_wait(i)
    ------------------
    s_buf_wait(i) <= s_buf_wait_int(i) and stream_active;


  -------------------------------------------------
  -- stream_crop_core
  -------------------------------------------------
  xstream_crop_core : stream_crop_core
    generic map (
      MAX_LNSIZE           => 16#7FFFFFFF#,
      MAX_NBLINE           => 16#7FFFFFFF#,
      S_DATA_WIDTH         => SI_DATA_WIDTH        ,
      PIPELINE_OUTPUT      => TRUE                 ,       
      SO_WAIT_REGISTERED   => FALSE

    )
    port map (

      sysrstN              => sysrstN              ,
      sysclk               => sysclk               ,
      ABORT                => ABORT                ,
      LNSIZE               => LNSIZE_int(i)        ,
      NBLINE               => NBLINE_int(i)        ,
      si_write             => s_buf_write    (i)   ,
      si_sync              => s_buf_sync     (i)   ,
      si_data              => s_buf_data     (i)   ,
      si_beN               => s_buf_beN      (i)   ,
      si_wait              => s_buf_wait_int (i)   ,
      so_write             => crop_write     (i)   ,
      so_sync              => crop_sync      (i)   ,
      so_data              => crop_data      (i)   ,
      so_beN               => crop_beN       (i)   ,
      so_wait              => crop_wait      (i)     

    );

    LNSIZE_int(i) <= to_integer(unsigned(LNSIZE(i)));
    NBLINE_int(i) <= to_integer(unsigned(NBLINE(i)));
    
  ----------------------------------------------------
  -- Bypass unpacker when NUMBER_OF_PLANES = 1
  ----------------------------------------------------
  gen_BYPASS: if NUMBER_OF_PLANES = 1 generate

    ctx_write(i) <= crop_write(i);
    ctx_sync (i) <= crop_sync (i);
    ctx_data (i) <= crop_data (i);
    ctx_beN  (i) <= crop_beN  (i);

    crop_wait(i) <= ctx_wait(i);

  end generate gen_BYPASS;

end generate gen_stream_in;

LNSIZE_out <= LNSIZE_int(0);


----------------------------------------------------
-- Do not bypass unpacker when NUMBER_OF_PLANES > 1
----------------------------------------------------
gen_unpacker : if NUMBER_OF_PLANES > 1 generate

  ----------------------------------------------------
  -- stream_unpacker_core
  ----------------------------------------------------
  xstream_unpacker_core : stream_unpacker_core
    generic map (

      SI_DATA_WIDTH        => SI_DATA_WIDTH        ,
      SO_TOTAL             => NUMBER_OF_PLANES     ,
      SO_DATA_WIDTH        => SI_DATA_WIDTH        ,
      SO_FIFO_DEPTH        => 2*MAX_BURST_PER_CONTEXT*RAM_DATA_WIDTH/SI_DATA_WIDTH,
      SO_DATA_REGISTERED   => TRUE                 ,
      SO_WAIT_REGISTERED   => FALSE                ,
      FPGA_ARCH            => FPGA_ARCH            ,
      FPGA_FAMILY          => FPGA_FAMILY

    )
    port map (

      sysrstN              => sysrstN              ,
      sysclk               => sysclk               ,
      ABORT                => ABORT                ,
      bit_depth            => bit_depth            ,
      nb_contexts          => nb_contexts          ,
      context_enable       => context_enable       ,
      si_write             => crop_write    (0)    ,
      si_sync              => crop_sync     (0)    ,
      si_data              => crop_data     (0)    ,
      si_beN               => crop_beN      (0)    ,
      si_wait              => crop_wait     (0)    ,
      so_write             => s_unpack_write       ,
      so_sync              => s_unpack_sync        ,
      so_data              => s_unpack_data        ,
      so_beN               => s_unpack_beN         ,
      so_wait              => s_unpack_wait        ,
      so_active            => open                     -- not used???

    );

  gen_2d_loop : for i in NUMBER_OF_PLANES-1 downto 0 generate
  begin

    ------------------
    -- ctx_sync(i)
    -- ctx_data(i)
    -- ctx_beN (i)
    ------------------
    ctx_sync(i) <= array2slv(s_unpack_sync, i) when ctx_force_cont(i) = '0' else "10";
    ctx_data(i) <= array2slv(s_unpack_data, i);
    ctx_beN (i) <= array2slv(s_unpack_beN , i);

  end generate gen_2d_loop;
  

  ------------------
  -- ctx_write
  ------------------
  ctx_write <= s_unpack_write;

  
  ------------------
  -- s_unpack_wait
  ------------------
  s_unpack_wait <= ctx_wait;


end generate gen_unpacker;


STARTADDR_lsb <= ctx_sol_shift(0);

--------------------------------
-- GENERATE process
--------------------------------
gen_context_unclocked : for i in NUMBER_OF_PLANES-1 downto 0 generate
begin

  ------------------
  -- ctx_byteshift(i)
  ------------------
  ctx_byteshift(i) <= to_integer(unsigned(FSTART(i))) mod (SI_DATA_WIDTH/8);


  -----------------
  -- ctx_sol_shift(i)
  -----------------
  ctx_sol_shift(i) <= to_integer(unsigned(FSTART(i))) mod (RAM_DATA_WIDTH/8);


  ------------------
  -- context_enable(i)
  ------------------
  context_enable(i) <= DTE(i) when nb_contexts > i else '0';


  -----------------
  -- ctx_wait(i)
  -----------------
  ctx_wait(i) <= si_shift_wait or 
                 (ctx_write(i) and bo2sl(context /= i)) or
                 (change_context_pre and ctx_write(i) and bo2sl(si_shift_sync = "01")) or
                 (si_shift_flush and not si_shift_eof);


  -----------------
  -- ram_addr_ctx(i)
  -----------------
  ram_addr_ctx(i) <= ram_addr_nxtline_ctx(i) when (so_resize_sol = '1') else ram_addr_int_ctx(i);


end generate gen_context_unclocked; 


  

--------------------------------
-- GENERATE process
--------------------------------
gen_context_clocked : for i in NUMBER_OF_PLANES-1 downto 0 generate
begin

  ram_addr_nxtline_ctx_36b(i) <= std_logic_vector(unsigned(ram_addr_nxtline_ctx(i)) + unsigned(LNPITCH));

  -------------------------------------------------------------------------------
  -- clocked events
  -------------------------------------------------------------------------------
  process (sysrstN, sysclk)
  
  begin  

    ----------
    -- reset
    ----------
    if (sysrstN = '0') then

      ctx_counter1_x      (i) <= 0;
      ram_addr_int_ctx    (i) <= (others => '0');
      ram_addr_nxtline_ctx(i) <= (others => '0');
      ram_eof_ctx         (i) <= '0';
      ctx_force_cont      (i) <= '0';


    elsif (sysclk'event and sysclk = '1') then                                         

      -----------------
      -- ctx_counter1_x(i)
      -- FLOPPED
      -----------------
      if (ACTIVE = '0' or
          NUMBER_OF_PLANES = 1 or
          total_active_context = 1
         ) then
        ctx_counter1_x(i) <= 0;
      elsif (ctx_write(i) = '1' and ctx_wait(i) = '0' and i = context) then
        ctx_counter1_x(i) <= (ctx_counter1_x(i) + 1) mod (MAX_BURST_PER_CONTEXT*RAM_DATA_WIDTH/SI_DATA_WIDTH);
      else
        ctx_counter1_x(i) <= ctx_counter1_x(i);
      end  if;

      
      -----------------
      -- ctx_force_cont(i)
      -- FLOPPED
      -----------------
      if (si_shift_write_masked = '1' and si_shift_sync = "01" and si_shift_flush = '1' and context = i) then
        ctx_force_cont(i) <= '1';
      elsif (ctx_wait(i) = '0' ) then
        ctx_force_cont(i) <= '0';
      else 
        ctx_force_cont(i) <= ctx_force_cont(i);
      end if;


      -----------------
      -- ram_addr_int_ctx(i)
      -- FLOPPED
      -----------------
      if (so_resize_write = '1' and so_resize_wait = '0' and i = ram_context) then
        ram_addr_int_ctx(i) <= std_logic_vector(unsigned(ram_addr_ctx(i)) + RAM_DATA_WIDTH/8);
      else
        ram_addr_int_ctx(i) <= ram_addr_int_ctx(i);
      end if;


      -----------------
      -- ram_addr_nxtline_ctx(i)
      -- FLOPPED
      -----------------
      if (stream_active = '0' and so_resize_sof = '0') then
        ram_addr_nxtline_ctx(i)(ram_addr_nxtline_ctx(i)'range) <= FSTART(i)(ram_addr_nxtline_ctx(i)'range);--conv_std_logic_vector(FSTART(i), ram_addr_nxtline_ctx(i)'length);
      elsif (so_resize_sol = '1' and i = ram_context) then
        ram_addr_nxtline_ctx(i)(ram_addr_nxtline_ctx(i)'range) <= ram_addr_nxtline_ctx_36b(i)(ram_addr_nxtline_ctx(i)'range);
      else
        ram_addr_nxtline_ctx(i) <= ram_addr_nxtline_ctx(i);
      end if;


      --------------
      -- ram_eof_ctx(i)
      -- FLOPPED
      --------------
      if (stream_active = '0') then
        ram_eof_ctx(i) <= '0';
      elsif ((so_resize_eof = '1' and i = ram_context) or
             (context_enable(i) = '0')
            ) then
        ram_eof_ctx(i) <= '1';
      else
        ram_eof_ctx(i) <= ram_eof_ctx(i);
      end if;


    end if;

  end process;

end generate gen_context_clocked; 


  ------------------
  -- context
  ------------------
  context <= context_list(context_list_sel);


  ------------------
  -- change_context
  ------------------
  change_context <= (bo2sl(NUMBER_OF_PLANES > 1) and bo2sl(total_active_context > 1) and 
                     (
                      (change_context_pre and bo2sl(ctx_counter2 = RAM_DATA_WIDTH/SI_DATA_WIDTH-1) and si_shift_write) or
                      (change_context_pre and si_shift_write and bo2sl(si_shift_sync = "01")) or
                      si_shift_eof -- change context on eof
                     )
                    ) or
                    (change_context_ff and si_shift_wait_ff);


  ------------------
  -- ctx_counter1
  ------------------
  ctx_counter1 <= ctx_counter1_x(context);


  ------------------
  -- ctx_counter2
  ------------------
  ctx_counter2 <= ctx_counter2_init when (si_shift_sol = '1' or change_context_ff = '1') else ctx_counter2_int;


  ------------------
  -- ctx_counter2_init
  ------------------
  ctx_counter2_init <= ctx_sol_shift(context) / (SI_DATA_WIDTH/8);


  ------------------
  -- si_shift_byteshift
  -- si_shift_write
  -- si_shift_sync
  -- si_shift_data
  -- si_shift_beN 
  ------------------
  si_shift_byteshift <= ctx_byteshift(context);
  si_shift_write     <= ctx_write    (context);
  si_shift_sync      <= ctx_sync     (context);
  si_shift_data      <= ctx_data     (context);
  si_shift_beN       <= ctx_beN      (context);


  ------------------
  -- si_shift_flush    
  ------------------
  si_shift_flush <= bo2sl(si_shift_byteshift /= 0) and change_context;


  ------------------
  -- si_shift_write_masked
  ------------------
  si_shift_write_masked <= si_shift_write and not (change_context_pre and bo2sl(si_shift_sync = "01"));


  ------------------
  -- si_shift_context
  ------------------
  gen_NUMPLANES: if (NUMBER_OF_PLANES > 1) generate
    si_shift_context <= std_logic_vector(to_unsigned(context,log2(NUMBER_OF_PLANES-1)));
  end generate gen_NUMPLANES;
  gen_NUMPLANE: if (NUMBER_OF_PLANES = 1) generate
    si_shift_context <= (others => '0');
  end generate gen_NUMPLANE;


  ------------------
  -- si_shift_SOL
  ------------------
  si_shift_sol <= si_shift_write and si_shift_sync(0);
  

  ------------------
  -- si_shift_eof
  ------------------
  si_shift_eof <= si_shift_write and bo2sl(si_shift_sync = "11") and stream_active;


-------------------------------------------------
-- stream_shift_core
-------------------------------------------------
xstream_shift_core : stream_shift_core
  generic map (

    S_DATA_WIDTH              => SI_DATA_WIDTH      ,
    SHIFT_LEFT_NOT_RIGHT      => TRUE               ,
    S_CONTEXT_WIDTH           => si_shift_context'length,
    PIPELINE_OUTPUT           => FALSE              ,
    SO_WAIT_REGISTERED        => FALSE       

  )
  port map (

    sysrstN                   => sysrstN            ,
    sysclk                    => sysclk             ,
    byteshift                 => si_shift_byteshift ,
    si_write                  => si_shift_write_masked,
    si_sync                   => si_shift_sync      ,
    si_data                   => si_shift_data      ,
    si_beN                    => si_shift_beN       ,
    si_wait                   => si_shift_wait      ,
    si_flush                  => si_shift_flush     ,
    si_context                => si_shift_context   ,
    so_write                  => so_shift_write     ,
    so_sync                   => so_shift_sync      ,
    so_data                   => so_shift_data      ,
    so_beN                    => so_shift_beN       ,
    so_wait                   => so_shift_wait      ,     
    so_context                => so_shift_context

  );


  ------------------
  -- sol_shift
  ------------------
  sol_shift <= ctx_sol_shift(to_integer(unsigned(si_resize_context))) when (NUMBER_OF_PLANES > 1) else ctx_sol_shift(0);


----------------------------------------------------
-- stream_buffer_core
----------------------------------------------------
xstream_buffer_core_shift2resize : stream_buffer_core
  generic map (

    S_DATA_WIDTH         => SI_DATA_WIDTH        ,
    S_CONTEXT_WIDTH      => so_shift_context'length,
    SI_BUS_REGISTERED    => TRUE                 ,
    SO_WAIT_REGISTERED   => FALSE

  )
  port map (

    sysrstN              => sysrstN              ,
    sysclk               => sysclk               ,
    si_write             => so_shift_write       ,
    si_sync              => so_shift_sync        ,
    si_data              => so_shift_data        ,
    si_beN               => so_shift_beN         ,
    si_wait              => so_shift_wait        ,
    si_context           => so_shift_context     ,
    so_write             => si_resize_write      ,
    so_sync              => si_resize_sync       ,
    so_data              => si_resize_data       ,
    so_beN               => si_resize_beN        ,
    so_wait              => si_resize_wait       ,
    so_context           => si_resize_context  
                            
  );


  ------------------
  -- si_resize_flush
  ------------------
  si_resize_flush <= bo2sl(so_shift_context /= si_resize_context) and bo2sl(NUMBER_OF_PLANES > 1);


----------------------------------------------------
-- stream_resize
----------------------------------------------------
xstream_resize : stream_resize
  generic map (

    SI_DATA_WIDTH        => SI_DATA_WIDTH        ,
    SI_CONTEXT_WIDTH     => si_resize_context'length,
    SO_DATA_WIDTH        => RAM_DATA_WIDTH
  )
  port map (

    sysrstN              => sysrstN              ,
    sysclk               => sysclk               ,
    ABORT                => ABORT                ,
    sol_shift            => sol_shift            ,
    si_write             => si_resize_write      ,
    si_sync              => si_resize_sync       ,
    si_data              => si_resize_data       ,
    si_beN               => si_resize_beN        ,
    si_wait              => si_resize_wait       ,
    si_flush             => si_resize_flush      ,
    si_context           => si_resize_context    ,
    so_write             => so_resize_write      ,
    so_sync              => so_resize_sync       ,
    so_data              => so_resize_data       ,
    so_beN               => so_resize_beN        ,
    so_wait              => so_resize_wait       ,
    so_context           => so_resize_context    ,
    so_active            => open                       -- ??

  );


  -----------------
  -- so_resize_sol
  -- sync[1] = '0' => SOF or SOL
  -----------------
  so_resize_sol <= so_resize_write and not so_resize_wait and not so_resize_sync(1);


  -----------------
  -- so_resize_sof
  -- sync = "00" => SOF
  -----------------
  so_resize_sof <= so_resize_write and not so_resize_wait and bo2sl(so_resize_sync = "00");


  -----------------
  -- so_resize_eof
  -- sync = "11" => EOF
  -----------------
  so_resize_eof <= so_resize_write and not so_resize_wait and bo2sl(so_resize_sync = "11");-- and stream_active;


  -----------------
  -- so_resize_wait
  -----------------
  so_resize_wait <= ram_wait; 


-------------------------------------------------
-- ram_write_core
-------------------------------------------------
xram_write_core : ram_write_core
  generic map (

    RAM_DATA_WIDTH            => ram_data'length           ,
    RAM_ADDR_WIDTH            => ram_addr'length           ,
    RAM_CMD_REGISTERED        => TRUE                      ,
    RAM_WAIT_REGISTERED       => FALSE                     ,
    SW_DATA_WIDTH             => SW_DATA_WIDTH             ,
    SW_ADDR_WIDTH             => SW_ADDR_WIDTH             ,
    SW_BANKS                  => SW_BANKS                  ,
    SW_THRESHOLD              => SW_THRESHOLD              ,
    SW_FIFO_DEPTH             => SW_FIFO_DEPTH             ,
    SW_WAIT_REGISTERED        => SW_WAIT_REGISTERED        ,
    FPGA_ARCH                 => FPGA_ARCH                 ,
    FPGA_FAMILY               => FPGA_FAMILY               

  )
  port map (

    sysrstN                   => sysrstN                   ,
    sysclk                    => sysclk                    ,
    ABORT                     => ABORT                     ,
    ram_write                 => ram_write                 ,
    ram_addr                  => ram_addr                  ,
    ram_data                  => ram_data                  ,
    ram_sync                  => ram_sync                  ,    
    ram_beN                   => ram_beN                   ,
    ram_flush                 => ram_flush                 ,
    ram_wait                  => ram_wait                  ,
    ram_active                => ram_active                ,
    sw_writeN                 => sw_writeN                 ,
    sw_addr                   => sw_addr                   ,
    sw_data                   => sw_data                   ,
    sw_sync                   => sw_sync                   ,    
    sw_beN                    => sw_beN                    ,
    sw_fifo_threshold         => sw_fifo_threshold         ,
    sw_wait                   => sw_wait                   

    );


  -----------------
  -- ram_context
  -----------------
  ram_context <= to_integer(unsigned(so_resize_context(si_resize_context'range))) when (NUMBER_OF_PLANES > 1) else 0;
  
  
  -----------------
  -- ram_write
  -----------------
  ram_write <= stream_active and so_resize_write;-- and bo2sl(so_resize_sync /= "11");


  -----------------
  -- ram_data
  -----------------
  ram_data <= so_resize_data;


  --------------------
  -- ram_sync
  --------------------
  ram_sync <= so_resize_sync;
  
  -----------------
  -- ram_beN
  -----------------
  ram_beN <= so_resize_beN;


  -----------------
  -- ram_addr
  -----------------
  ram_addr <= ram_addr_ctx(ram_context);


-------------------------------------------------------------------------------
-- clocked events
-------------------------------------------------------------------------------
process (sysrstN, sysclk)
   
begin  

  ----------
  -- reset
  ----------
  if (sysrstN = '0') then

    ACTIVE                 <= '0';
    SNPPDG                 <= '0';
    stream_active          <= '0';
    intevent               <= '0';
    si_shift_wait_ff       <= '0';
    si_shift_eof_detected  <= '0';
    change_context_pre     <= '0';
    change_context_ff      <= '0';
    context_list_sel       <= 0;
    ctx_counter2_int       <= 0;
    assert_error           <= '0';

  elsif (sysclk'event and sysclk = '1') then                                         


    if (OrN(ram_eof_ctx) = '1') then
      tmp_timeout_counter <= tmp_timeout_counter+1;
    end if;


    assert_error <= '0'; --ACTIVE and si_resize_flush and not so_shift_write;

    si_shift_wait_ff  <= si_shift_wait;
    change_context_ff <= change_context;


    -----------------
    -- ACTIVE
    -- FLOPPED
    -----------------
    ACTIVE <= -- RESET
              not (ABORT or
                   dmawr_end
                  )
              and (
              -- SET
              (s_buf_sof(0)
              ) or
              -- SAME VALUE
              ACTIVE
              );


    -----------------
    -- stream_active
    -- FLOPPED
    -----------------
    stream_active <= -- RESET
                     not (ABORT or
                          AndN(ram_eof_ctx) or
--                          bo2sl(tmp_timeout_counter > 10000) or
                          -- special case: all context_enable = 0
                          (not OrN(context_enable) and bo2sl(crop_sync(0) = "11") and crop_write(0) and not crop_wait(0))
                         )
                     and (
                     -- SET
                     (s_buf_sof(0)
                     ) or
                     -- SAME VALUE
                     stream_active
                     );


    --------------
    -- SNPPDG
    -- FLOPPED
    --------------
    SNPPDG <=  -- SET
               (SNPSHT and not ABORT)
               or (
               -- RESET
               not (s_buf_sof(0) or
                    ABORT
                   )
               -- SAME VALUE
               and SNPPDG
               );


    -----------------
    -- intevent 
    -- FLOPPED
    -----------------
    intevent <= dmawr_end; 


    -----------------
    -- si_shift_eof_detected
    -- FLOPPED
    -----------------
    si_shift_eof_detected <= -- SET
                             (si_shift_eof and not si_shift_wait)
                             or (
                             -- RESET
                             not (not stream_active)
                             -- SAME VALUE
                             and si_shift_eof_detected
                             );


    -----------------
    -- change_context_pre
    -- precondition to change contexts based on expiration of ctx_counter1
    -- Note: when si_shift_eof is detected, change context only on other si_shift_eof events (i.e. flush out all data for each context)
    -- FLOPPED
    -----------------
    change_context_pre <=  -- SET
                           (bo2sl(ctx_counter1 = MAX_BURST_PER_CONTEXT*RAM_DATA_WIDTH/SI_DATA_WIDTH-1) and si_shift_write and not si_shift_wait
                            and not si_shift_eof and not si_shift_eof_detected)
                           or (
                           -- RESET
                           not (change_context and not si_shift_wait)
                           -- SAME VALUE
                           and change_context_pre
                           );


    --------------
    -- ctx_counter2_int 
    -- FLOPPED
    --------------
    if (ACTIVE = '0' or
        (change_context = '1' and si_shift_wait = '0') or
        NUMBER_OF_PLANES = 1 or
        total_active_context = 1
       ) then
      ctx_counter2_int <= ctx_counter2_init;
    elsif (si_shift_write = '1' and si_shift_wait = '0') then
      ctx_counter2_int <= (ctx_counter2 + 1) mod (RAM_DATA_WIDTH/SI_DATA_WIDTH);
    else
      ctx_counter2_int <= ctx_counter2;
    end  if;
    
    
    --------------
    -- context_list_sel    
    -- FLOPPED
    --------------
    if (ACTIVE = '0' or --?
        (change_context = '1' and si_shift_wait = '0' and context_list_sel = total_active_context-1)
       ) then
      context_list_sel <= 0;
    elsif (change_context = '1' and si_shift_wait = '0') then
      context_list_sel <= context_list_sel + 1;
    else
      context_list_sel <= context_list_sel;
    end if;


  end if;

end process;



  -----------------
  -- s_buf_sof(0)
  -- sync = "00" => SOF
  -----------------
  s_buf_sof(0) <= s_buf_write(0) and not s_buf_wait(0) and bo2sl(s_buf_sync(0) = "00") and SNPPDG;

  
  -----------------
  -- ram_flush
  -----------------
  ram_flush <= not stream_active and active;


  -----------------
  -- dmawr_end
  -----------------
  dmawr_end <= ACTIVE and not stream_active and not ram_active;
  

end functional;



