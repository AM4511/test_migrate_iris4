----------------------------------------------------------------------
-- $HeadURL: svn://brainstorm/svn_ipcore/trunk/Matrox/Imaging/FDK/hw/cores/dmawr/design/dmawr_sdram_top.vhd $
-- $Revision: 9321 $
-- $Date: 2009-07-08 16:51:12 -0400 (Wed, 08 Jul 2009) $
-- $Author: mpoirie1 $
--
-- DESCRIPTION: dma write module
--
-- Contains the following modules:
--
--                dmawr_core
--
--
--
--  Functionality:
--
--    - supports byte alignment
--    - fifos optimized for independent ram arbiters
--
-----------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all; 
  use ieee.std_logic_unsigned.all;
  use ieee.std_logic_arith.all;

library work;
  use work.dmawr_pack.all; 
  use work.std_logic_2d.all;


-------------------------------------------------
-- dmawr_sdram_top
-------------------------------------------------
entity dmawr_sdram_top is
  generic (

    SD_WRITEDATA_WIDTH   : integer;
    SD_ADDR_WIDTH        : integer;               -- width of sd_addr signal
    NB_DATA_ACC          : integer := 16;         -- number of data to be accumulated before being evacuated (0 to 32)
    NUMBER_OF_PLANES     : integer := 1;          -- max number of planes
    SI0_DATA_WIDTH       : integer := 64;         -- width of si0_data signal: 64, 128, etc.
 --   SI0_ADDR_WIDTH       : integer := 11;       -- width of si0_addr signal: 11 (for 64-bit data), 10 (for 128-bit data), etc.
    FPGA_ARCH            : string  := "ALTERA";
    FPGA_FAMILY          : string  := "STRATIX"   -- "STRATIX", "STRATIXII"

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
    LNSIZE               : out       integer;
    STARTADDR_lsb        : out       integer;
    reg_write            : in        std_logic;                       
    reg_read             : in        std_logic;                       
    reg_addr             : in        std_logic_vector(8 downto 3);   
    reg_writedata        : in        std_logic_vector(63 downto 0);   
    reg_beN              : in        std_logic_vector(7 downto 0);   
    reg_readdata         : out       std_logic_vector(63 downto 0);   
    ----------------------------------------------------
    -- stream input port (slave)
    ----------------------------------------------------
    si0_write            : in        std_logic;
  --  si0_addr             : in        std_logic_vector(13 downto 3);
    si0_data             : in        std_logic_vector(SI0_DATA_WIDTH-1 downto 0);
    si0_beN              : in        std_logic_vector(SI0_DATA_WIDTH/8-1 downto 0);
    si0_wait             : out       std_logic;
    ----------------------------------------------------
    -- SDRAM (master), write only
    ----------------------------------------------------
    sd_addr              : out       std_logic_vector(SD_ADDR_WIDTH-1 downto 0);
    sd_wait              : in        std_logic;
    sd_write             : out       std_logic;
    sd_writebeN          : out       std_logic_vector(SD_WRITEDATA_WIDTH/8-1 downto 0);
    sd_writesync         : out       std_logic_vector(1 downto 0);
    sd_writedata         : out       std_logic_vector(SD_WRITEDATA_WIDTH-1 downto 0);
    sd_fifo_threshold    : out       std_logic;
    ----------------------------------------------------
    -- interrupt events
    ----------------------------------------------------
    LSBOF                : in        std_logic_vector(6 downto 0);
    intevent             : out       std_logic

  );
end dmawr_sdram_top;


architecture functional of dmawr_sdram_top is

  -----------------------------------------------------
  -- constants
  -----------------------------------------------------
  constant SW_BANKS              : integer := 1;               -- number of RAM banks: 1, 2, 4

--  constant SW_ADDR_WIDTH         : integer := sd_addr'length;
  constant SW_FIFO_DEPTH         : integer := 64;
  constant SW_WAIT_REGISTERED    : boolean := FALSE;
  
  constant MAX_BURST_PER_CONTEXT : integer := 32; -- number of consecutive writes to one context before switching to the next context (minimum 2)
  constant SI_TOTAL              : integer := 1;

 
-------------------------------------------------
-- dmawr_core
-------------------------------------------------
component dmawr_core is
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
    LNSIZE_out           : out       integer;
    STARTADDR_lsb        : out       integer;
    reg_write            : in        std_logic;                       
    reg_read             : in        std_logic;                       
    reg_addr             : in        std_logic_vector(8 downto 3);   
    reg_writedata        : in        std_logic_vector(63 downto 0);   
    reg_beN              : in        std_logic_vector(7 downto 0);   
    reg_readdata         : out       std_logic_vector(63 downto 0);   
    ----------------------------------------------------
    -- stream input port (slave)
    ----------------------------------------------------
    si_write             : in        std_logic_vector  (SI_TOTAL-1 downto 0);
    -- not valid si_sync              : in        STD_LOGIC_ARRAY_2D(SI_TOTAL-1 downto 0, 1 downto 0);
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
end component;


  -----------------------------------------------------
  -- signals
  -----------------------------------------------------
  signal sw_writeN            : std_logic_vector  (SW_BANKS-1 downto 0);      
  signal sw_addr              : STD_LOGIC_ARRAY_2D(SW_BANKS-1 downto 0, SD_ADDR_WIDTH-1 downto 0);
  signal sw_data              : STD_LOGIC_ARRAY_2D(SW_BANKS-1 downto 0, SD_WRITEDATA_WIDTH-1 downto 0);
  signal sw_fifo_threshold    : std_logic_vector  (SW_BANKS-1 downto 0);
  signal sw_sync              : STD_LOGIC_ARRAY_2D(SW_BANKS-1 downto 0, 1 downto 0);
  signal sw_beN               : STD_LOGIC_ARRAY_2D(SW_BANKS-1 downto 0, SD_WRITEDATA_WIDTH/8-1 downto 0);
  signal sw_wait              : std_logic_vector  (SW_BANKS-1 downto 0);      

--  signal si0_sync             : std_logic_vector(1 downto 0);      
  
  signal si_write             : std_logic_vector  (SI_TOTAL-1 downto 0);
--  signal si_sync              : STD_LOGIC_ARRAY_2D(SI_TOTAL-1 downto 0, 1 downto 0);
  signal si_data              : STD_LOGIC_ARRAY_2D(SI_TOTAL-1 downto 0, SI0_DATA_WIDTH-1 downto 0);
  signal si_beN               : STD_LOGIC_ARRAY_2D(SI_TOTAL-1 downto 0, SI0_DATA_WIDTH/8-1 downto 0);
  signal si_wait              : std_logic_vector  (SI_TOTAL-1 downto 0);
  
begin

  --------------------------------
  -- sd_* signal generation
  --------------------------------
  sd_addr           <= array2slv(sw_addr, 0);
                    
  sd_write          <= not sw_writeN(0);          
  sd_writebeN       <= array2slv(sw_beN , 0); 
  sd_writesync      <= array2slv(sw_sync, 0);  
  sd_writedata      <= array2slv(sw_data, 0);     
  sd_fifo_threshold <= sw_fifo_threshold(0);

  sw_wait(0)    <= sd_wait;


  --------------------------------
  -- si* signals
  --------------------------------
--  si0_sync <= si0_addr(13 downto 12);

  si_write(0) <= si0_write;

--  gen_si_sync0 : for i in si0_sync'range generate
--  begin
--    si_sync(0, i) <= si0_sync(i);
--  end generate gen_si_sync0; 

  gen_si_data0 : for i in si0_data'range generate
  begin
    si_data(0, i) <= si0_data(i);
  end generate gen_si_data0; 

  gen_si_beN0 : for i in si0_beN'range generate
  begin
    si_beN(0, i) <= si0_beN(i);
  end generate gen_si_beN0; 

  si0_wait <= si_wait(0);




-------------------------------------------------
-- dmawr_core
-------------------------------------------------
xdmawr_core : dmawr_core
  generic map (

    NUMBER_OF_PLANES     => NUMBER_OF_PLANES     ,
    MAX_BURST_PER_CONTEXT=> MAX_BURST_PER_CONTEXT,
    SI_TOTAL             => SI_TOTAL             ,
    SI_DATA_WIDTH        => SI0_DATA_WIDTH       ,
    SW_DATA_WIDTH        => SD_WRITEDATA_WIDTH   ,
    SW_ADDR_WIDTH        => SD_ADDR_WIDTH        ,
    SW_BANKS             => SW_BANKS             ,
    SW_THRESHOLD         => NB_DATA_ACC          ,
    SW_FIFO_DEPTH        => SW_FIFO_DEPTH        ,
    SW_WAIT_REGISTERED   => SW_WAIT_REGISTERED   ,
    FPGA_ARCH            => FPGA_ARCH            ,
    FPGA_FAMILY          => FPGA_FAMILY

  )
  port map (

    sysrstN              => sysrstN      ,
    sysclk               => sysclk       ,
    LNSIZE_out           => LNSIZE       ,
    STARTADDR_lsb        => STARTADDR_lsb,
    reg_write            => reg_write    ,        
    reg_read             => reg_read     ,        
    reg_addr             => reg_addr     ,        
    reg_writedata        => reg_writedata,        
    reg_beN              => reg_beN      ,        
    reg_readdata         => reg_readdata ,        
    si_write             => si_write     ,
    -- not valid si_sync              => si_sync      ,
    si_data              => si_data      ,
    si_beN               => si_beN       ,
    si_wait              => si_wait      ,
    sw_writeN            => sw_writeN    ,
    sw_addr              => sw_addr      ,
    sw_data              => sw_data      ,
    sw_sync              => sw_sync      ,
    sw_beN               => sw_beN       ,
    sw_fifo_threshold    => sw_fifo_threshold,
    sw_wait              => sw_wait      ,
    LSBOF                => LSBOF        ,
    intevent             => intevent

  );

end functional;



