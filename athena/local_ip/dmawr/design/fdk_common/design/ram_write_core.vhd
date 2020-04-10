-----------------------------------------------------------------------
-- $HeadURL: svn://brainstorm/svn_ipcore/trunk/Matrox/Imaging/FDK/hw/cores/common/design/ram_write_core.vhd $
-- $Revision: 8921 $
-- $Date: 2009-04-16 17:48:32 -0400 (Thu, 16 Apr 2009) $
-- $Author: palepin $
--
-- DESCRIPTION: Ram Write Master
--
--
--  contains the following module(s)/package(s):
--
--         std_logic_2d (package)
--         fifo_syncram
--         bus_buffer_core
--
-----------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all; 
  use ieee.std_logic_unsigned.all;
  use ieee.std_logic_arith.all;

library work;
  use work.std_logic_2d.all; 

entity ram_write_core is
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
    SW_WAIT_REGISTERED        : boolean := TRUE       ; -- add a register on input signal sw_wait and extra glue logic
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
    -- sw_fifo_ready is 1 when there is at least SW_THRESHOLD elements inside
    sw_fifo_threshold         : out       std_logic_vector  (SW_BANKS-1 downto 0);
    sw_wait                   : in        std_logic_vector  (SW_BANKS-1 downto 0)

    );

end ram_write_core;

architecture functional of ram_write_core is


-----------------------------------------------------
-- fifo_syncram
-----------------------------------------------------
component fifo_syncram
  generic (

    USE_RDEN             : boolean := TRUE;      -- if false, rden is hardwired to '1'
    BYTE_SIZE            : integer := 8;         -- 8 or 9
    WRDATA_WIDTH         : integer;              -- must be a multiple of BYTE_SIZE
    WRADDR_WIDTH         : integer;             
    RDDATA_WIDTH         : integer;              -- must be a multiple of BYTE_SIZE
    RDADDR_WIDTH         : integer;
    FPGA_ARCH            : string  := "ALTERA";
    FPGA_FAMILY          : string  := "STRATIX"  -- "STRATIX", "STRATIXII", "STRATIXIII", "STRATIXIV"

  );
  port (

    -------------------------------------------------
    -- fifo write port
    -------------------------------------------------
    wrclk                : in        std_logic;
    wren                 : in        std_logic;
    wraddr               : in        std_logic_vector(WRADDR_WIDTH-1 downto 0);
    wrdata               : in        std_logic_vector(WRDATA_WIDTH-1 downto 0);
    wrbena               : in        std_logic_vector(WRDATA_WIDTH/BYTE_SIZE-1 downto 0) :=  (others => '1');
    -------------------------------------------------
    -- fifo read port
    -------------------------------------------------
    rdclk                : in        std_logic;
    rden                 : in        std_logic := '1';
    rdaddr               : in        std_logic_vector(RDADDR_WIDTH-1 downto 0);
    rddata               : out       std_logic_vector(RDDATA_WIDTH-1 downto 0)

  );
end component;


-------------------------------------------------
-- bus_buffer_core
-------------------------------------------------
component bus_buffer_core
  generic (

    BUS_WIDTH                 : integer               ; -- width of A_bus/B_bus ports
    A_BUS_REGISTERED          : boolean := TRUE       ; -- add a register on A_bus input port
    B_WAIT_REGISTERED         : boolean := TRUE         -- add a register on B_wait input port and extra glue logic

  );
  port (

    ---------------------------------------------------------------------
    -- Reset, clock and mode signals
    ---------------------------------------------------------------------
    sysrstN                   : in        std_logic                     ;
    sysclk                    : in        std_logic                     ;
    ---------------------------------------------------------------------
    -- input side
    ---------------------------------------------------------------------
    A_bus_reset               : in        std_logic_vector(BUS_WIDTH-1 downto 0) := (others => '0');
    A_bus                     : in        std_logic_vector(BUS_WIDTH-1 downto 0);
    A_wait                    : buffer    std_logic                     ;
    ---------------------------------------------------------------------
    -- output side
    ---------------------------------------------------------------------
    B_bus                     : buffer    std_logic_vector(BUS_WIDTH-1 downto 0);
    B_wait                    : in        std_logic                     

  );
end component;




  -----------------------------------------------------
  -- log2
  -----------------------------------------------------
  function log2             ( arg                   : integer         
                            ) return                  integer is

  variable result       : integer := 0;
  variable comparevalue : integer := 1;
  begin

    assert arg /= 0
      report "invalid arg value 0 in log2"
      severity FAILURE;

    while (comparevalue < arg) loop
      comparevalue := comparevalue * 2;
      result := result + 1;
    end loop;

    return result;
  end;


  -----------------------------------------------------
  -- OrN
  -- Function making a OR of a group of signals.
  -----------------------------------------------------
  function OrN              ( arg                   : std_logic_vector
                            ) return                  std_logic is

  variable result : std_logic;
  begin
    result := '0';

    for i in arg'range loop
      result := result or arg(i);
    end loop;

    return result;
  end OrN;


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
  -- roundup
  -----------------------------------------------------
  function roundup          ( number                : integer;     
                              multiple              : integer
                            ) return                  integer is

  variable result : integer;
  begin

    result := (((number - 1) / multiple) + 1) * multiple;

    return result;
  end roundup;


  -----------------------------------------------------
  -- constants
  -----------------------------------------------------

  constant SW_BANKS_LOG2             : integer := log2(SW_BANKS);  

  constant RAM_DATA_WIDTH_DIV8_LOG2  : integer := log2(RAM_DATA_WIDTH/8);  

  constant WRBLOCKS                  : integer := (SW_DATA_WIDTH * SW_BANKS) / RAM_DATA_WIDTH;  
  constant WRBLOCKS_LOG2             : integer := log2(WRBLOCKS);  

  -- fifos (data, addr)
  constant FIFO_DEPTH                : integer := SW_FIFO_DEPTH;  
  constant FIFO_ADDR_WIDTH           : integer := log2(FIFO_DEPTH);  

  -- sram write data + sync (roundup to 8 because needs a multiple of BYTE_SIZE) + byte enables fifo 
  constant DFIFO_DATA_WIDTH          : integer := SW_DATA_WIDTH + 8 + SW_DATA_WIDTH/8;

  -- sram write address fifo 
  constant AFIFO_DATA_WIDTH          : integer := roundup(SW_ADDR_WIDTH, 8);

  constant SW_DATA_WIDTH_BYTE        : integer := SW_DATA_WIDTH/8;  
  constant SW_DATA_WIDTH_BYTE_LOG2   : integer := log2(SW_DATA_WIDTH_BYTE);  


  -----------------------------------------------------
  -- types
  -----------------------------------------------------

  type ARRAY_IR_OF_SW_DATA_WIDTH      is array (integer range <>) of std_logic_vector(SW_DATA_WIDTH-1    downto 0);
  type ARRAY_IR_OF_SW_SYNC_WIDTH      is array (integer range <>) of std_logic_vector(1  downto 0);
  type ARRAY_IR_OF_SW_BEN_WIDTH       is array (integer range <>) of std_logic_vector(SW_DATA_WIDTH/8-1  downto 0);
  type ARRAY_IR_OF_SW_ADDR_WIDTH      is array (integer range <>) of std_logic_vector(SW_ADDR_WIDTH-1    downto 0);

  type ARRAY_IR_OF_FIFO_ADDR_WIDTH is array (integer range <>) of std_logic_vector(FIFO_ADDR_WIDTH-1 downto 0);
-- modified to avoid error in quartus
  type ARRAY_IR_OF_DFIFO_DATA_WIDTH is array (integer range <>) of std_logic_vector(DFIFO_DATA_WIDTH-1 downto 0);

  type ARRAY_IR_OF_AFIFO_DATA_WIDTH is array (integer range <>) of std_logic_vector(AFIFO_DATA_WIDTH-1 downto 0);


  -----------------------------------------------------------------------------
  -- functions
  -----------------------------------------------------------------------------
   
  -----------------------------------------------------
  -- bo2sl
  -----------------------------------------------------
   function bo2sl(s : boolean) return std_logic is 
      begin
         case s is
        when false => return ('0');
            when true  => return ('1');
         end case;
      end bo2sl;


  -----------------------------------------------------
  -- slv2arr_data
  -----------------------------------------------------
  function slv2arr_data ( input   : ARRAY_IR_OF_SW_DATA_WIDTH;
                          j_high  : integer;
                          j_low   : integer
                        ) return    STD_LOGIC_ARRAY_2D is
  variable result : STD_LOGIC_ARRAY_2D(input'range, j_high downto j_low);
  begin
    for i in result'range(1) loop
      for j in result'range(2) loop
        result(i,j) := input(i)(j);  
      end loop;
    end loop;

    return result;
  end slv2arr_data;


  -----------------------------------------------------
  -- out2d_sw_addr 
  -----------------------------------------------------
  function out2d_sw_addr (input : ARRAY_IR_OF_SW_ADDR_WIDTH) return STD_LOGIC_ARRAY_2D is
  variable result : STD_LOGIC_ARRAY_2D(input'range, input(0)'range);
  begin
    for i in result'range(1) loop
      for j in result'range(2) loop
        result(i,j) := input(i)(j);  
      end loop;
    end loop;
    return result;
  end out2d_sw_addr;


  -----------------------------------------------------
  -- out2d_sw_data 
  -----------------------------------------------------
  function out2d_sw_data (input : ARRAY_IR_OF_SW_DATA_WIDTH) return STD_LOGIC_ARRAY_2D is
  variable result : STD_LOGIC_ARRAY_2D(input'range, input(0)'range);
  begin
    for i in result'range(1) loop
      for j in result'range(2) loop
        result(i,j) := input(i)(j);  
      end loop;
    end loop;
    return result;
  end out2d_sw_data;


  -----------------------------------------------------
  -- out2d_sw_ben 
  -----------------------------------------------------
  function out2d_sw_ben (input : ARRAY_IR_OF_SW_BEN_WIDTH) return STD_LOGIC_ARRAY_2D is
  variable result : STD_LOGIC_ARRAY_2D(input'range, input(0)'range);
  begin
    for i in result'range(1) loop
      for j in result'range(2) loop
        result(i,j) := input(i)(j);  
      end loop;
    end loop;
    return result;
  end out2d_sw_ben;

  -----------------------------------------------------
  -- out2d_sw_sync
  -----------------------------------------------------
  function out2d_sw_sync (input : ARRAY_IR_OF_SW_SYNC_WIDTH) return STD_LOGIC_ARRAY_2D is
  variable result : STD_LOGIC_ARRAY_2D(input'range, input(0)'range);
  begin
    for i in result'range(1) loop
      for j in result'range(2) loop
        result(i,j) := input(i)(j);  
      end loop;
    end loop;
    return result;
  end out2d_sw_sync;
  
  

  -----------------------------------------------------------------------------
  -- signals
  -----------------------------------------------------------------------------
  signal sr_wait_qsys     : std_logic_vector            (SW_BANKS-1 downto 0);

  -- bus_buffer_core (input)
  signal ramwr_bus                 : std_logic_vector(1 + ram_addr'length + ram_beN'length + ram_sync'length + ram_data'length - 1 downto 0);
  signal ramwr_buf_bus             : std_logic_vector(ramwr_bus'range);
  signal ram_write_int             : std_logic;
  signal ram_addr_int              : std_logic_vector(ram_addr'range);
  signal ram_data_int              : std_logic_vector(ram_data'range);
  signal ram_sync_int              : std_logic_vector(ram_sync'range);  
  signal ram_beN_int               : std_logic_vector(ram_beN'range);
  signal ram_wait_int              : std_logic;

  -- write to fifo
  signal sw_addr_com               : std_logic_vector(SW_ADDR_WIDTH-1 downto 0);
  signal sw_addr_com_int           : std_logic_vector(SW_ADDR_WIDTH-1 downto 0);
  signal fifo_wrblk                : std_logic_vector(WRBLOCKS-1 downto 0);

  -- dfifo: data
  signal dfifo_wren                : std_logic_vector            (SW_BANKS-1 downto 0);
  signal dfifo_wraddr              : ARRAY_IR_OF_FIFO_ADDR_WIDTH (SW_BANKS-1 downto 0);
  signal dfifo_wrdata              : ARRAY_IR_OF_DFIFO_DATA_WIDTH(SW_BANKS-1 downto 0);
  signal dfifo_rden                : std_logic_vector            (SW_BANKS-1 downto 0);
  signal dfifo_rdaddr              : ARRAY_IR_OF_FIFO_ADDR_WIDTH (SW_BANKS-1 downto 0);
  signal dfifo_rdaddr_int          : ARRAY_IR_OF_FIFO_ADDR_WIDTH (SW_BANKS-1 downto 0);
  signal dfifo_rdaddr_ff           : ARRAY_IR_OF_FIFO_ADDR_WIDTH (SW_BANKS-1 downto 0);
  signal dfifo_rddata              : ARRAY_IR_OF_DFIFO_DATA_WIDTH(SW_BANKS-1 downto 0);
  signal dfifo_used                : ARRAY_IR_OF_FIFO_ADDR_WIDTH (SW_BANKS-1 downto 0);
  signal dfifo_threshold_go        : std_logic_vector            (SW_BANKS-1 downto 0);

  -- afifo: address, byte enable, eol sync
  signal afifo_wren                : std_logic_vector            (SW_BANKS-1 downto 0);
  signal afifo_wraddr              : ARRAY_IR_OF_FIFO_ADDR_WIDTH (SW_BANKS-1 downto 0);
  signal afifo_wrdata              : ARRAY_IR_OF_AFIFO_DATA_WIDTH(SW_BANKS-1 downto 0);
  signal afifo_rden                : std_logic_vector            (SW_BANKS-1 downto 0);
  signal afifo_rdaddr              : ARRAY_IR_OF_FIFO_ADDR_WIDTH (SW_BANKS-1 downto 0);
  signal afifo_rddata              : ARRAY_IR_OF_AFIFO_DATA_WIDTH(SW_BANKS-1 downto 0);

  signal dfifo_sync                : ARRAY_IR_OF_SW_SYNC_WIDTH   (SW_BANKS-1 downto 0);
  signal dfifo_data_beN            : ARRAY_IR_OF_SW_BEN_WIDTH    (SW_BANKS-1 downto 0);

  signal fifo_almost_full_all      : std_logic;
  signal fifo_almost_full          : std_logic_vector(SW_BANKS-1 downto 0);

  -- read from fifo
  signal sw_writeN_out_m1          : std_logic_vector            (SW_BANKS-1 downto 0);      
  signal sw_writeN_out             : std_logic_vector            (SW_BANKS-1 downto 0);      
  signal sw_writeN_out_ff          : std_logic_vector            (SW_BANKS-1 downto 0);      
  signal sw_writeN_int             : std_logic_vector            (SW_BANKS-1 downto 0);      
  signal sw_rddatavalid            : std_logic_vector            (SW_BANKS-1 downto 0);      
  signal sw_wait_ff                : std_logic_vector            (SW_BANKS-1 downto 0);      
  signal sw_wait_int               : std_logic_vector            (SW_BANKS-1 downto 0);      
  signal sw_flush                  : std_logic_vector            (SW_BANKS-1 downto 0);      

  -- 2D output signals in port map
  signal sw_addr_out               : ARRAY_IR_OF_SW_ADDR_WIDTH   (SW_BANKS-1 downto 0);
  signal sw_data_out               : ARRAY_IR_OF_SW_DATA_WIDTH   (SW_BANKS-1 downto 0);
  signal sw_sync_out               : ARRAY_IR_OF_SW_SYNC_WIDTH   (SW_BANKS-1 downto 0);
  signal sw_beN_out                : ARRAY_IR_OF_SW_BEN_WIDTH    (SW_BANKS-1 downto 0);
  signal sw_addr_out_ff            : ARRAY_IR_OF_SW_ADDR_WIDTH   (SW_BANKS-1 downto 0);
  signal sw_data_out_ff            : ARRAY_IR_OF_SW_DATA_WIDTH   (SW_BANKS-1 downto 0);
  signal sw_sync_out_ff            : ARRAY_IR_OF_SW_SYNC_WIDTH   (SW_BANKS-1 downto 0);  
  signal sw_beN_out_ff             : ARRAY_IR_OF_SW_BEN_WIDTH    (SW_BANKS-1 downto 0);
  signal sw_addr_2d                : ARRAY_IR_OF_SW_ADDR_WIDTH   (SW_BANKS-1 downto 0);
  signal sw_data_2d                : ARRAY_IR_OF_SW_DATA_WIDTH   (SW_BANKS-1 downto 0);
  signal sw_sync_2d                : ARRAY_IR_OF_SW_SYNC_WIDTH   (SW_BANKS-1 downto 0);
  signal sw_beN_2d                 : ARRAY_IR_OF_SW_BEN_WIDTH    (SW_BANKS-1 downto 0);

--synthesis translate_off
  signal signal_DFIFO_DEPTH        : integer := FIFO_DEPTH;
  signal signal_dfifo_DATA_WIDTH   : integer := DFIFO_DATA_WIDTH;
  signal signal_dfifo_ADDR_WIDTH   : integer := FIFO_ADDR_WIDTH;

  signal signal_SW_DATA_WIDTH      : integer := SW_DATA_WIDTH ; -- width of sw_data signal : 32, 64, etc.  
  signal signal_SW_ADDR_WIDTH      : integer := SW_ADDR_WIDTH ; -- width of sw_data signal : 24
  signal signal_SW_BANKS           : integer := SW_BANKS      ; -- number of RAM banks: 2, 4
  signal signal_WRBLOCKS           : integer := WRBLOCKS;
  signal signal_WRBLOCKS_LOG2      : integer := WRBLOCKS_LOG2;
--synthesis translate_on


  signal sw_wait_qsys             : std_logic_vector(SW_BANKS-1 downto 0); 

-------------------------------------------------------------------------------
-- Debut des process
-------------------------------------------------------------------------------
begin


-------------------------------------------------
-- Verifications
-------------------------------------------------

--synthesis translate_off

  -------------------------------------
  -- SW_THRESHOLD < or = to FIFO_DEPTH
  -------------------------------------
  assert SW_THRESHOLD <= FIFO_DEPTH
    report "SW_THRESHOLD is greater than FIFO_DEPTH in ram_write_core module"
    severity FAILURE;


--synthesis translate_on



-------------------------------------------------
-- write command buffer (input)
-------------------------------------------------
xcmd_buffer : bus_buffer_core
  generic map (

    BUS_WIDTH                 =>  ramwr_bus'length         ,
    A_BUS_REGISTERED          =>  RAM_CMD_REGISTERED       ,
    B_WAIT_REGISTERED         =>  RAM_WAIT_REGISTERED

  )
  port map (

    sysrstN                   => sysrstN                   ,
    sysclk                    => sysclk                    ,
    A_bus_reset               => open                      ,
    A_bus                     => ramwr_bus                 ,
    A_wait                    => ram_wait                  ,
    B_bus                     => ramwr_buf_bus             ,
    B_wait                    => ram_wait_int

  );

ramwr_bus <= ram_write & ram_addr & ram_beN & ram_sync & ram_data;

ram_write_int <= ramwr_buf_bus(ramwr_bus'high);
ram_addr_int  <= ramwr_buf_bus(RAM_ADDR_WIDTH + RAM_DATA_WIDTH/8 + RAM_DATA_WIDTH+2 - 1 downto RAM_DATA_WIDTH/8 + RAM_DATA_WIDTH+2);
ram_beN_int   <= ramwr_buf_bus(RAM_DATA_WIDTH/8 + RAM_DATA_WIDTH+2 - 1 downto RAM_DATA_WIDTH+2);    
ram_sync_int  <= ramwr_buf_bus(RAM_DATA_WIDTH + 1 downto RAM_DATA_WIDTH);
ram_data_int  <= ramwr_buf_bus(ram_data'range);


-----------------------------------------------------
-- dfifo (fifo_syncram)
-- write data + byte enables
-----------------------------------------------------
gen_dfifo : for b in SW_BANKS-1 downto 0 generate
begin

  xdfifo : fifo_syncram
    generic map (

      USE_RDEN             => FALSE           ,
      BYTE_SIZE            => 8,--9               ,WRDATA_WIDTH has to be a multiple of BYTE_SIZE
      WRDATA_WIDTH         => DFIFO_DATA_WIDTH,
      WRADDR_WIDTH         => FIFO_ADDR_WIDTH ,
      RDDATA_WIDTH         => DFIFO_DATA_WIDTH,
      RDADDR_WIDTH         => FIFO_ADDR_WIDTH ,
      FPGA_ARCH            => FPGA_ARCH       ,
      FPGA_FAMILY          => FPGA_FAMILY

    )
    port map (

      wrclk                => sysclk         ,
      wren                 => dfifo_wren  (b),
      wraddr               => dfifo_wraddr(b),
      wrdata               => dfifo_wrdata(b),
      wrbena               => open           ,
      rdclk                => sysclk         ,
      rden                 => dfifo_rden  (b),
      rdaddr               => dfifo_rdaddr(b),
      rddata               => dfifo_rddata(b)

    );

end generate;


-----------------------------------------------------
-- afifo (fifo_syncram)
-- address + byte enables
-----------------------------------------------------
gen_afifo : for b in SW_BANKS-1 downto 0 generate
begin

  xafifo : fifo_syncram
    generic map (

      USE_RDEN             => FALSE           ,
      BYTE_SIZE            => 8               ,--WRDATA_WIDTH has to be a multiple of BYTE_SIZE
      WRDATA_WIDTH         => AFIFO_DATA_WIDTH,
      WRADDR_WIDTH         => FIFO_ADDR_WIDTH ,
      RDDATA_WIDTH         => AFIFO_DATA_WIDTH,
      RDADDR_WIDTH         => FIFO_ADDR_WIDTH ,
      FPGA_ARCH            => FPGA_ARCH       ,
      FPGA_FAMILY          => FPGA_FAMILY

    )
    port map (

      wrclk                => sysclk         ,
      wren                 => afifo_wren  (b),
      wraddr               => afifo_wraddr(b),
      wrdata               => afifo_wrdata(b),
      wrbena               => open           ,
      rdclk                => sysclk         ,
      rden                 => afifo_rden  (b),
      rdaddr               => afifo_rdaddr(b),
      rddata               => afifo_rddata(b)

    );

end generate;


-------------------------------------------------------------------------------
-- clockedEvents
-------------------------------------------------------------------------------
process (sysrstN, sysclk)
   
begin  

  ----------
  -- reset
  ----------
  if (sysrstN = '0') then

    ram_active                  <= '0';
    ram_wait_int                <= '0';
    sw_wait_ff                  <= (others => '0');

  elsif (sysclk'event and sysclk = '1') then                                         

    ram_wait_int                <= fifo_almost_full_all;
    --sw_wait_ff                  <= sw_wait;
    sw_wait_ff                  <= sw_wait_qsys;

    -----------------
    -- ram_active
    -- FLOPPED
    -----------------
    ram_active <= ram_write_int or
                 OrN(dfifo_rden) or
                 (not AndN(sw_writeN_out_m1)) or 
                 (not AndN(sw_writeN_out)) or 
                 (not AndN(sw_writeN_out_ff) and bo2sl(SW_WAIT_REGISTERED));
  
  
  end if;
      
end process; -- clockedEvents


--------------------------------
-- clocked events per bank
--------------------------------
gen_SW_BANKS_clocked : for b in SW_BANKS-1 downto 0 generate
begin

  process (sysrstN, sysclk)
    
  begin  

    ----------
    -- reset
    ----------
    if (sysrstN = '0') then

      dfifo_wraddr      (b) <= (others => '0');
      dfifo_rdaddr_int  (b) <= (others => '0');
      dfifo_rdaddr_ff   (b) <= (others => '0');
      dfifo_threshold_go(b) <= '1';
      sw_fifo_threshold (b) <= '0';
      sw_flush          (b) <= '0';
      sw_writeN_out_m1  (b) <= '1';
      sw_writeN_out     (b) <= '1';
      sw_addr_out       (b) <= (others => '0');
      sw_data_out       (b) <= (others => '0');
      sw_sync_out       (b) <= (others => '0');      
      sw_beN_out        (b) <= (others => '0');
      sw_writeN_out_ff  (b) <= '1';
      sw_addr_out_ff    (b) <= (others => '0');
      sw_data_out_ff    (b) <= (others => '0');
      sw_sync_out_ff    (b) <= (others => '0');
      sw_beN_out_ff     (b) <= (others => '0');
      sw_rddatavalid    (b) <= '0';


    elsif (sysclk'event and sysclk = '1') then                                         
      
      dfifo_rdaddr_ff(b) <= dfifo_rdaddr(b);


      -----------------
      -- dfifo_wraddr(b)
      -- note: dfifo_wraddr(b) <= dfifo_wraddr(b)
      -- FLOPPED
      -----------------
      if (ABORT = '1') then
        dfifo_wraddr(b) <= (others => '0');
      elsif (dfifo_wren(b) = '1') then
        dfifo_wraddr(b) <= unsigned(dfifo_wraddr(b)) + 1;
      else 
        dfifo_wraddr(b) <= dfifo_wraddr(b);
      end if;


      -----------------
      -- dfifo_rdaddr_int(b)
      -- FLOPPED
      -----------------
      if (ABORT = '1') then
        dfifo_rdaddr_int(b) <= (others => '0');
      elsif (dfifo_rden(b) = '1') then
        dfifo_rdaddr_int(b) <= unsigned(dfifo_rdaddr_int(b)) + 1;
      else
        dfifo_rdaddr_int(b) <= dfifo_rdaddr_int(b);
      end if;

      
      -----------------
      -- dfifo_threshold_go(b)
      -- FLOPPED
      -----------------
      dfifo_threshold_go(b) <= -- SET
                               (-- threshold met
                                bo2sl(dfifo_used(b) >= SW_THRESHOLD) or
                                -- flush
                                (bo2sl(dfifo_wraddr(b) /= dfifo_rdaddr_int(b)) and ram_flush)
                               )
                               or (
                               -- RESET
                               not (-- fifo empty (no write in progress)
                                    bo2sl(dfifo_wraddr(b) = dfifo_rdaddr_int(b))
                                   )
                               -- SAME VALUE
                               and dfifo_threshold_go(b)
                               );

      sw_fifo_threshold(b)  <= bo2sl(dfifo_used(b) >= SW_THRESHOLD) or 
                              -- reset the threshold  and sw_flush at the same time
                              (sw_flush(b) and not(not sw_writeN_int(b) and not sw_wait(b) and sw_sync_2d(b)(0) and sw_sync_2d(b)(1)));  

      if (dfifo_wren(b) = '1' and dfifo_sync(b) = "11") then
         sw_flush(b) <= '1';
      else
         -- eof is output from the current module
         if (sw_writeN_int(b) = '0' and sw_sync_2d(b) = "11" and sw_wait(b) = '0') then     
           sw_flush(b) <= '0';         
         end if;
      end if;

      -----------------
      -- sw_rddatavalid(b)
      -- FLOPPED
      -----------------
      sw_rddatavalid(b) <= -- SET
                           (dfifo_rden(b))
                           or (
                           -- RESET
                           not (not sw_wait_int(b)
                               )
                           -- SAME VALUE
                           and sw_rddatavalid(b)
                           );
                    

      -----------------
      -- sw_writeN_out_m1(b)
      -- FLOPPED
      -----------------
      sw_writeN_out_m1(b) <= not (dfifo_rden(b) or
                                  (not sw_writeN_out_m1(b) and sw_wait_int(b))
                                 );

      
      -----------------
      -- sw_writeN_out   (b)
      -- sw_addr_out     (b)
      -- sw_data_out     (b)
      -- sw_beN_out      (b)
      --
      -- sw_writeN_out_ff(b)
      -- sw_addr_out_ff  (b)
      -- sw_data_out_ff  (b)
      -- sw_beN_out_ff   (b)
      --
      -- FLOPPED
      -----------------
      if (sw_wait_int(b) = '0') then

        sw_writeN_out   (b)  <= sw_writeN_out_m1(b);
        sw_addr_out     (b)  <= afifo_rddata    (b)(SW_ADDR_WIDTH-1 downto 0);
        sw_data_out     (b)  <= dfifo_rddata    (b)(SW_DATA_WIDTH-1 downto 0);
        sw_sync_out     (b)  <= dfifo_rddata    (b)(SW_DATA_WIDTH+1 downto SW_DATA_WIDTH);
        sw_beN_out      (b)  <= dfifo_rddata    (b)(SW_DATA_WIDTH/8-1+SW_DATA_WIDTH+2 downto SW_DATA_WIDTH+2);

        sw_writeN_out_ff(b)  <= sw_writeN_out   (b);
        sw_addr_out_ff  (b)  <= sw_addr_out     (b);
        sw_data_out_ff  (b)  <= sw_data_out     (b);
        sw_sync_out_ff  (b)  <= sw_sync_out     (b);
        sw_beN_out_ff   (b)  <= sw_beN_out      (b);

      else                   

        sw_writeN_out   (b)  <= sw_writeN_out   (b);
        sw_addr_out     (b)  <= sw_addr_out     (b);
        sw_data_out     (b)  <= sw_data_out     (b);
        sw_sync_out     (b)  <= sw_sync_out     (b);
        sw_beN_out      (b)  <= sw_beN_out      (b);

        sw_writeN_out_ff(b)  <= sw_writeN_out_ff(b);
        sw_addr_out_ff  (b)  <= sw_addr_out_ff  (b);
        sw_data_out_ff  (b)  <= sw_data_out_ff  (b);
        sw_sync_out_ff  (b)  <= sw_sync_out_ff  (b);        
        sw_beN_out_ff   (b)  <= sw_beN_out_ff   (b);

      end if;

     
    end if;

  end process;
  
end generate gen_SW_BANKS_clocked;


  -----------------
  -- gen_WRBLOCKS_unclocked
  -----------------
  gen_WRBLOCKS_unclocked_multi : if WRBLOCKS > 1 generate
  begin
    gen_WRBLOCKS_unclocked : for blk in WRBLOCKS-1 downto 0 generate
    begin
    
      -----------------
      -- fifo_wrblk 
      -----------------
      fifo_wrblk(blk) <= ram_write_int and not ram_wait_int and bo2sl(conv_integer(ram_addr_int(WRBLOCKS_LOG2-1+RAM_DATA_WIDTH_DIV8_LOG2 downto RAM_DATA_WIDTH_DIV8_LOG2)) = blk);


    end generate gen_WRBLOCKS_unclocked;
  end generate gen_WRBLOCKS_unclocked_multi;

  gen_WRBLOCKS_unclocked_single : if WRBLOCKS = 1 generate
  begin
  
    -----------------
    -- fifo_wrblk 
    -----------------
    fifo_wrblk(0) <= ram_write_int and not ram_wait_int;


  end generate gen_WRBLOCKS_unclocked_single;

  --------------------------------
  -- gen_SW_BANKS_unclocked
  --------------------------------
  gen_SW_BANKS_unclocked : for b in SW_BANKS-1 downto 0 generate
  begin

    ---------------
    -- dfifo_used(b)
    ---------------
    dfifo_used(b) <= unsigned(dfifo_wraddr(b)) - unsigned(dfifo_rdaddr_int(b));

    --------------
    -- fifo_almost_full(b)
    --------------
    fifo_almost_full(b) <= bo2sl(dfifo_used(b) >= (FIFO_DEPTH - 4));


    ---------------
    -- dfifo_wren(b)
    -- note: dfifo_wren(b) = 0 if dfifo_data_beN(b) = (all 1's) -> beN
    --       we need to write to fifo when the sync = eof (all 1's) so that the next module receives the eof sync
    ---------------
                             
    dfifo_wren(b) <= fifo_wrblk(b*WRBLOCKS/SW_BANKS) and (not AndN(dfifo_data_beN(b)) or AndN(dfifo_sync(b)));

  
    ---------------
    -- dfifo_data_beN(b)
    ---------------
    dfifo_data_beN(b) <= ram_beN_int((b mod (SW_BANKS/WRBLOCKS)) * SW_DATA_WIDTH/8 + SW_DATA_WIDTH/8 - 1 downto (b mod (SW_BANKS/WRBLOCKS)) * SW_DATA_WIDTH/8);

    -----------------
    -- dfifo_sync(b)
    -----------------
    dfifo_sync(b) <= ram_sync_int((b mod (SW_BANKS/WRBLOCKS)) * 2 + 2 - 1 downto (b mod (SW_BANKS/WRBLOCKS)) * 2);
    
    ---------------
    -- dfifo_wrdata(b) = byte enable & sync &  data
    ---------------
                     -- 0's are to make it a multiple of BYTE_SIZE
    dfifo_wrdata(b) <= "000000" & dfifo_data_beN(b) & dfifo_sync(b) & ram_data_int((b mod (SW_BANKS/WRBLOCKS)) * SW_DATA_WIDTH + SW_DATA_WIDTH - 1 downto (b mod (SW_BANKS/WRBLOCKS)) * SW_DATA_WIDTH);


    ---------------
    -- dfifo_rden(b)
    --------------
    dfifo_rden(b) <= (bo2sl(dfifo_wraddr(b) /= dfifo_rdaddr_int(b)) and dfifo_threshold_go(b) and not sw_rddatavalid(b)) or
                     (bo2sl(dfifo_wraddr(b) /= dfifo_rdaddr_int(b)) and dfifo_threshold_go(b) and not sw_wait_int(b));
  

    ---------------
    -- dfifo_rdaddr(b)
    --------------
    dfifo_rdaddr(b) <= dfifo_rdaddr_int(b) when dfifo_rden(b) = '1' else dfifo_rdaddr_ff(b);
  

    ---------------
    -- afifo_wrdata(b)
    ---------------
    afifo_wrdata(b)(sw_addr_com'range) <= sw_addr_com;
    afifo_wrdata(b)(afifo_wrdata(b)'high downto sw_addr_com'length) <= (others => '0');


    ---------------
    -- afifo_rdaddr(b)
    ---------------
    afifo_rdaddr(b) <= dfifo_rdaddr(b);


    ---------------
    -- afifo_rden(b)
    ---------------
    afifo_rden(b) <= dfifo_rden(b);


    ---------------
    -- afifo_wraddr(b)
    ---------------
    afifo_wraddr(b) <= dfifo_wraddr(b);


    ---------------
    -- afifo_wren(b)
    ---------------
    afifo_wren(b) <= dfifo_wren(b);


    -----------------
    -- sw_writeN(b)
    -----------------
    sw_writeN_int(b) <= sw_writeN_out_ff(b) when (sw_wait_ff(b) = '1' and SW_WAIT_REGISTERED = TRUE) else sw_writeN_out(b);
    sw_writeN(b) <= sw_writeN_int(b);


    -----------------
    -- sw_addr_2d  (b)
    -- sw_data_2d  (b) 
    -- sw_sync_2d  (b)     
    -- sw_beN_2d   (b)  
    -----------------
    sw_addr_2d  (b) <= sw_addr_out_ff  (b) when (sw_wait_ff(b) = '1' and SW_WAIT_REGISTERED = TRUE) else sw_addr_out  (b);
    sw_data_2d  (b) <= sw_data_out_ff  (b) when (sw_wait_ff(b) = '1' and SW_WAIT_REGISTERED = TRUE) else sw_data_out  (b);
    sw_sync_2d  (b) <= sw_sync_out_ff  (b) when (sw_wait_ff(b) = '1' and SW_WAIT_REGISTERED = TRUE) else sw_sync_out  (b);    
    sw_beN_2d   (b) <= sw_beN_out_ff   (b) when (sw_wait_ff(b) = '1' and SW_WAIT_REGISTERED = TRUE) else sw_beN_out   (b);


  end generate gen_SW_BANKS_unclocked;




  -----------------
  -- sw_addr_com
  -- 1) shift ram_addr by SW_BANKS_LOG2
  -- 2) force LSBs to '0'
  -----------------
  sw_addr_com_int <= ram_addr_int(sw_addr_com_int'high + SW_BANKS_LOG2 downto SW_BANKS_LOG2);

  sw_addr_com(sw_addr_com'high downto SW_DATA_WIDTH_BYTE_LOG2) <= sw_addr_com_int(sw_addr_com'high downto SW_DATA_WIDTH_BYTE_LOG2);
  sw_addr_com(SW_DATA_WIDTH_BYTE_LOG2-1 downto 0) <= (others => '0');


  -----------------
  -- fifo_almost_full_all
  -----------------
  fifo_almost_full_all <= OrN(fifo_almost_full);


  -----------------
  -- 2D output signals in port map
  -- sw_addr 
  -- sw_data 
  -- sw_beN  
  -----------------
  sw_addr <= out2d_sw_addr(sw_addr_2d);
  sw_data <= out2d_sw_data(sw_data_2d);
  sw_sync <= out2d_sw_sync(sw_sync_2d);
  sw_beN  <= out2d_sw_ben (sw_beN_2d);


  --------------
  -- sw_wait_int
  --------------
  sw_wait_int <= sw_wait_ff when SW_WAIT_REGISTERED = TRUE else sw_wait_qsys;

  Loop_sw_wait_qsys: for i in 0 to SW_BANKS-1 generate
    sw_wait_qsys(i) <= sw_wait(i) and (not sw_writeN_int(i));
  end generate Loop_sw_wait_qsys;

end functional;


