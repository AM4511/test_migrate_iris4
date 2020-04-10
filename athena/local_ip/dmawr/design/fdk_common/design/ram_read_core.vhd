-----------------------------------------------------------------------
-- $HeadURL: svn://brainstorm/svn_ipcore/trunk/Matrox/Imaging/FDK/hw/cores/common/design/ram_read_core.vhd $
-- $Revision: 9391 $
-- $Date: 2009-08-06 12:55:08 -0400 (Thu, 06 Aug 2009) $
-- $Author: mpoirie1 $
--
-- DESCRIPTION: Ram Read Master module
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
  use ieee.numeric_std.all;
  
package ram_read_core_pack is

  function log2(arg:integer) return integer; 
end ram_read_core_pack;

package body ram_read_core_pack is
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

end package body;

library ieee;
  use ieee.std_logic_1164.all; 
  use ieee.numeric_std.all;
  --use ieee.std_logic_unsigned.all;
  --use ieee.std_logic_arith.all;

library work;
  use work.std_logic_2d.all; 
  use work.ram_read_core_pack.all;

entity ram_read_core is
  generic (

    RAM_ADDR_WIDTH            : integer               ; -- width of ram_addr signal
    RAM_CONTEXT_WIDTH         : integer               ; -- width of ram_context/ram_data_context signals
    RAM_CMD_FIFO_DEPTH        : integer := 16         ; -- depth of address FIFO (command side)
   -- RAM_CMD_THRESHOLD         : integer := 0          ; -- minimum number of addresses accumulated in command fifo required before initiating accesses to ram
    RAM_DATA_THRESHOLD        : integer := 0          ; -- minimum number of free data locations required before initiating accesses to ram
    RAM_CMD_REGISTERED        : boolean := FALSE      ; -- register input signals ram_read, ram_addr, ram_beN and ram_context
    RAM_WAIT_REGISTERED       : boolean := FALSE      ; -- register output signal ram_wait and add extra glue logic
    RAM_DATA_FIFO_DEPTH       : integer := 16         ; -- depth of data FIFO (readback side)
    RAM_DATA_REGISTERED       : boolean := FALSE      ; -- register output signals ram_datavalid, ram_data and ram_data_context
    RAM_DATA_WAIT_REGISTERED  : boolean := FALSE      ; -- register input signal ram_data_wait and add extra glue logic
	RD_BURST_SIZE             : integer := 1          ; -- one read request equals RD_BURST_SIZE of SR_DATA_WIDTH bits
    SR_BANKS                  : integer               ; -- number of RAM banks: 1, 2, 4
    SR_ADDR_WIDTH             : integer               ; -- width of sr_addr signal : 24
    SR_DATA_WIDTH             : integer               ; -- width of sr_data signal : 32, 64, etc.  
    SR_WAIT_REGISTERED        : boolean := TRUE       ; -- register input signal sr_wait and add extra glue logic
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
    -- read command
    ---------------------------------------------------------------------
    ram_read                  : in        std_logic                     ;
    ram_addr                  : in        std_logic_vector(RAM_ADDR_WIDTH-1 downto 0);
    --ram_beN                   : in        std_logic_vector(SR_DATA_WIDTH*SR_BANKS/8-1 downto 0) := (others => '0');
    ram_context               : in        std_logic_vector(RAM_CONTEXT_WIDTH downto 1)          := (others => '0'); -- range shifted by 1 to prevent negative index
    ram_flush                 : in        std_logic                     ;
    ram_wait                  : buffer    std_logic                     ;
    ram_active                : buffer    std_logic                     ;
    ---------------------------------------------------------------------
    -- data readback 
    ---------------------------------------------------------------------
    ram_datavalid             : buffer    std_logic                     ;
    ram_data                  : buffer    std_logic_vector(SR_DATA_WIDTH*SR_BANKS-1 downto 0);
    ram_data_context          : buffer    std_logic_vector(RAM_CONTEXT_WIDTH downto 1); -- range shifted by 1 to prevent negative index
    ram_data_wait             : in        std_logic                     ;
    ---------------------------------------------------------------------
    -- read master port
    ---------------------------------------------------------------------
    sr_readN                  : out       std_logic_vector  (SR_BANKS-1 downto 0);      
    sr_addr                   : out       STD_LOGIC_ARRAY_2D(SR_BANKS-1 downto 0, SR_ADDR_WIDTH-1 downto 0);
	sr_arlen_1base            : out       STD_LOGIC_ARRAY_2D(SR_BANKS-1 downto 0, log2(RD_BURST_SIZE) downto 0);
    sr_data                   : in        STD_LOGIC_ARRAY_2D(SR_BANKS-1 downto 0, SR_DATA_WIDTH-1 downto 0);
    sr_datavalid              : in        std_logic_vector  (SR_BANKS-1 downto 0);
    sr_wait                   : in        std_logic_vector  (SR_BANKS-1 downto 0)      

    );

end ram_read_core;


architecture functional of ram_read_core is


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

  constant SR_ADDR_PITCH             : integer := SR_DATA_WIDTH/8;  
  constant SR_ADDR_PITCH_LOG2        : integer := log2(SR_ADDR_PITCH);  

  -- sram read address fifo , added the sync eol
  constant AFIFO_DATA_WIDTH          : integer := roundup(SR_ADDR_WIDTH+4, 8);
  constant AFIFO_DEPTH               : integer := RAM_CMD_FIFO_DEPTH;
  constant AFIFO_ADDR_WIDTH          : integer := log2(AFIFO_DEPTH);  

  -- sram read data fifo 
  constant DFIFO_DATA_WIDTH          : integer := SR_DATA_WIDTH;  
  constant DFIFO_DEPTH               : integer := RAM_DATA_FIFO_DEPTH;
  constant DFIFO_ADDR_WIDTH          : integer := log2(DFIFO_DEPTH);
  constant DFIFO_DATA_THRESHOLD      : integer := RAM_DATA_THRESHOLD;
  
  -- byte enable/sync fifo
  constant BFIFO_DATA_WIDTH          : integer := roundup(RAM_CONTEXT_WIDTH+SR_BANKS, 8);
  constant BFIFO_DEPTH               : integer := DFIFO_DEPTH;
  constant BFIFO_ADDR_WIDTH          : integer := log2(BFIFO_DEPTH);
  

  -----------------------------------------------------
  -- types
  -----------------------------------------------------

  type ARRAY_IR_OF_SLV_SR_ADDR_WIDTH is array (integer range <>) of std_logic_vector(SR_ADDR_WIDTH-1 downto 0);
  type ARRAY_IR_OF_SLV_SR_ARLEN_WIDTH is array (integer range <>) of std_logic_vector(log2(RD_BURST_SIZE) downto 0);

  type ARRAY_IR_OF_AFIFO_ADDR_WIDTH  is array (integer range <>) of std_logic_vector(AFIFO_ADDR_WIDTH-1 downto 0);
  type ARRAY_IR_OF_AFIFO_DATA_WIDTH  is array (integer range <>) of std_logic_vector(AFIFO_DATA_WIDTH-1 downto 0);

  type ARRAY_IR_OF_DFIFO_ADDR_WIDTH  is array (integer range <>) of std_logic_vector(DFIFO_ADDR_WIDTH-1 downto 0);
  type ARRAY_IR_OF_DFIFO_USED_WIDTH  is array (integer range <>) of std_logic_vector(DFIFO_ADDR_WIDTH downto 0);
  type ARRAY_IR_OF_DFIFO_DATA_WIDTH  is array (integer range <>) of std_logic_vector(DFIFO_DATA_WIDTH-1 downto 0);

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
  -- out2d_sr_addr 
  -----------------------------------------------------
  function out2d_sr_addr (input : ARRAY_IR_OF_SLV_SR_ADDR_WIDTH) return STD_LOGIC_ARRAY_2D is
  variable result : STD_LOGIC_ARRAY_2D(input'range, input(0)'range);
  begin
    for i in result'range(1) loop
      for j in result'range(2) loop
        result(i,j) := input(i)(j);  
      end loop;
    end loop;
    return result;
  end out2d_sr_addr;

  -----------------------------------------------------
  -- out2d_sr_arlen 
  -----------------------------------------------------
  function out2d_sr_arlen (input : ARRAY_IR_OF_SLV_SR_ARLEN_WIDTH) return STD_LOGIC_ARRAY_2D is
  variable result : STD_LOGIC_ARRAY_2D(input'range, input(0)'range);
  begin
    for i in result'range(1) loop
      for j in result'range(2) loop
        result(i,j) := input(i)(j);  
      end loop;
    end loop;
    return result;
  end out2d_sr_arlen;
  
  
  

  -----------------------------------------------------------------------------
  -- signals
  -----------------------------------------------------------------------------

  -- read command buffer (input)
  signal cmd_bus                     : std_logic_vector(1 + ram_addr'length + ram_context'length - 1 downto 0);
  signal cmd_buf_bus                 : std_logic_vector(cmd_bus'range);
  signal ram_wait_buf                : std_logic;
  signal ram_read_buf                : std_logic;
  signal ram_addr_buf                : std_logic_vector(ram_addr'range);
  signal ram_beN_buf                 : std_logic_vector(ram_data'length/8-1 downto 0);
  signal ram_context_buf             : std_logic_vector(ram_context'range);

  -- afifo (address fifo)
  signal afifo_wrdata                : ARRAY_IR_OF_AFIFO_DATA_WIDTH(SR_BANKS-1 downto 0) := (others => (others => '0'));
  signal afifo_rdaddr                : ARRAY_IR_OF_AFIFO_ADDR_WIDTH(SR_BANKS-1 downto 0);
  signal afifo_rdaddr_int            : ARRAY_IR_OF_AFIFO_ADDR_WIDTH(SR_BANKS-1 downto 0);
  signal afifo_rdaddr_ff             : ARRAY_IR_OF_AFIFO_ADDR_WIDTH(SR_BANKS-1 downto 0);
  signal afifo_rden                  : std_logic_vector            (SR_BANKS-1 downto 0);
  signal afifo_wraddr                : ARRAY_IR_OF_AFIFO_ADDR_WIDTH(SR_BANKS-1 downto 0);
  signal afifo_wren                  : std_logic_vector            (SR_BANKS-1 downto 0);
  signal afifo_rddata                : ARRAY_IR_OF_AFIFO_DATA_WIDTH(SR_BANKS-1 downto 0);
  signal afifo_full                  : std_logic_vector            (SR_BANKS-1 downto 0);
  signal afifo_full_all              : std_logic;
  signal afifo_used                  : ARRAY_IR_OF_AFIFO_ADDR_WIDTH(SR_BANKS-1 downto 0);
  signal afifo_threshold_go          : std_logic_vector            (SR_BANKS-1 downto 0);
  signal afifo_rd_cntr               : ARRAY_IR_OF_SLV_SR_ARLEN_WIDTH(SR_BANKS-1 downto 0);

  -- bfifo (byte enable + read invalidator fifo)
  signal bfifo_wrdata                : std_logic_vector (BFIFO_DATA_WIDTH-1 downto 0) := (others => '0');
  signal bfifo_rdaddr                : std_logic_vector (BFIFO_ADDR_WIDTH-1 downto 0);
  signal bfifo_rdaddr_int            : std_logic_vector (BFIFO_ADDR_WIDTH-1 downto 0);
  signal bfifo_rdaddr_ff             : std_logic_vector (BFIFO_ADDR_WIDTH-1 downto 0);
  signal bfifo_rden                  : std_logic                                     ;
  signal bfifo_wraddr                : std_logic_vector (BFIFO_ADDR_WIDTH-1 downto 0);
  signal bfifo_wren                  : std_logic                                     ;
  signal bfifo_rddata                : std_logic_vector (BFIFO_DATA_WIDTH-1 downto 0);
  signal bfifo_rddatavalid           : std_logic;
  signal bfifo_full                  : std_logic;


  -- sr (sram read)
  signal sr_readN_m1                 : std_logic_vector            (SR_BANKS-1 downto 0);
  signal sr_readN_m2                 : std_logic_vector            (SR_BANKS-1 downto 0);  
  signal sr_readN_out                : std_logic_vector            (SR_BANKS-1 downto 0);      
  signal sr_readN_out_ff             : std_logic_vector            (SR_BANKS-1 downto 0); 
  signal sr_readN_int                : std_logic_vector            (SR_BANKS-1 downto 0);      
  signal sr_wait_int                 : std_logic_vector            (SR_BANKS-1 downto 0);      
  signal sr_wait_ff                  : std_logic_vector            (SR_BANKS-1 downto 0);      
  signal sr_wait_qsys                : std_logic_vector            (SR_BANKS-1 downto 0);
      
  -- dfifo (data fifo)
  signal dfifo_wrdata                : ARRAY_IR_OF_DFIFO_DATA_WIDTH(SR_BANKS-1 downto 0);
  signal dfifo_rdaddr                : ARRAY_IR_OF_DFIFO_ADDR_WIDTH(SR_BANKS-1 downto 0);
  signal dfifo_rden                  : std_logic_vector            (SR_BANKS-1 downto 0);
  signal dfifo_wraddr                : ARRAY_IR_OF_DFIFO_ADDR_WIDTH(SR_BANKS-1 downto 0);
  signal dfifo_wren                  : std_logic_vector            (SR_BANKS-1 downto 0);
  signal dfifo_rddata                : ARRAY_IR_OF_DFIFO_DATA_WIDTH(SR_BANKS-1 downto 0);
  signal dfifo_rddatavalid           : std_logic_vector            (SR_BANKS-1 downto 0);
  signal dfifo_rdmask                : std_logic_vector            (SR_BANKS-1 downto 0);
  signal dfifo_used                  : ARRAY_IR_OF_DFIFO_USED_WIDTH(SR_BANKS-1 downto 0);
    
  -- read data readback buffer (output)
  signal data_bus                    : std_logic_vector(1 + ram_data'length + ram_data_context'length - 1 downto 0);
  signal data_buf_bus                : std_logic_vector(data_bus'range);
  signal ram_data_wait_int           : std_logic;
  signal ram_datavalid_int           : std_logic;
  signal ram_data_int                : std_logic_vector(ram_data'range);
  signal ram_data_context_int        : std_logic_vector(ram_data_context'range);

  -- 2D output signals in port map
  signal sr_addr_out                 : ARRAY_IR_OF_SLV_SR_ADDR_WIDTH(SR_BANKS-1 downto 0);
  signal sr_addr_out_ff              : ARRAY_IR_OF_SLV_SR_ADDR_WIDTH(SR_BANKS-1 downto 0);
  signal sr_addr_2d                  : ARRAY_IR_OF_SLV_SR_ADDR_WIDTH(SR_BANKS-1 downto 0);
  signal sr_arlen_1base_out          : ARRAY_IR_OF_SLV_SR_ARLEN_WIDTH(SR_BANKS-1 downto 0);
  signal sr_arlen_1base_out_ff       : ARRAY_IR_OF_SLV_SR_ARLEN_WIDTH(SR_BANKS-1 downto 0);
  signal sr_arlen_1base_2d           : ARRAY_IR_OF_SLV_SR_ARLEN_WIDTH(SR_BANKS-1 downto 0);

  -- synthesis translate_off
  signal signal_AFIFO_DATA_WIDTH     : integer := AFIFO_DATA_WIDTH;
  signal signal_AFIFO_DEPTH          : integer := AFIFO_DEPTH     ;
  signal signal_AFIFO_ADDR_WIDTH     : integer := AFIFO_ADDR_WIDTH;
  signal signal_DFIFO_DATA_WIDTH     : integer := DFIFO_DATA_WIDTH;
  signal signal_DFIFO_DEPTH          : integer := DFIFO_DEPTH     ;
  signal signal_DFIFO_ADDR_WIDTH     : integer := DFIFO_ADDR_WIDTH;
  signal signal_BFIFO_DATA_WIDTH     : integer := BFIFO_DATA_WIDTH;
  signal signal_BFIFO_DEPTH          : integer := BFIFO_DEPTH     ;
  signal signal_BFIFO_ADDR_WIDTH     : integer := BFIFO_ADDR_WIDTH;
  -- synthesis translate_on


-------------------------------------------------------------------------------
-- Debut des process
-------------------------------------------------------------------------------
begin


  Loop_sr_wait_qsys: for i in 0 to SR_BANKS-1 generate
    sr_wait_qsys(i) <= sr_wait(i) and (not sr_readN_int(i));
  end generate Loop_sr_wait_qsys;

-------------------------------------------------
-- Verifications
-------------------------------------------------

--synthesis translate_off

  -------------------------------------
  -- RD_BURST_SIZE must be < or = to AFIFO_DEPTH
  -------------------------------------
  assert RD_BURST_SIZE <= AFIFO_DEPTH
    report "RD_BURST_SIZE is greater than AFIFO_DEPTH in ram_read_core module"
    severity FAILURE;


  -------------------------------------
  -- RAM_DATA_THRESHOLD must be < or = to DFIFO_DEPTH
  -------------------------------------
  assert RAM_DATA_THRESHOLD <= DFIFO_DEPTH
    report "RAM_DATA_THRESHOLD is greater than DFIFO_DEPTH in ram_read_core module"
    severity FAILURE;


  -------------------------------------
  -- DFIFO_DEPTH must be > or = to AFIFO_DEPTH
  -------------------------------------
  assert DFIFO_DEPTH >= AFIFO_DEPTH
    report "DFIFO_DEPTH is smaller than AFIFO_DEPTH in ram_read_core module"
    severity FAILURE;


--synthesis translate_on



-------------------------------------------------
-- read command buffer (input)
-------------------------------------------------
xcmd_buffer : bus_buffer_core
  generic map (

    BUS_WIDTH                 =>  cmd_bus'length           ,
    A_BUS_REGISTERED          =>  RAM_CMD_REGISTERED       ,
    B_WAIT_REGISTERED         =>  RAM_WAIT_REGISTERED

  )
  port map (

    sysrstN                   => sysrstN                   ,
    sysclk                    => sysclk                    ,
    A_bus_reset               => open                      ,
    A_bus                     => cmd_bus                   ,
    A_wait                    => ram_wait                  ,
    B_bus                     => cmd_buf_bus               ,
    B_wait                    => ram_wait_buf      

  );

--cmd_bus <= ram_read & ram_addr & ram_beN & ram_context;
-- byte enable is already in ram_context
cmd_bus <= ram_read & ram_addr & ram_context;

ram_read_buf     <= cmd_buf_bus(cmd_bus'high);
--ram_addr_buf     <= cmd_buf_bus(ram_addr'length + ram_beN'length + RAM_CONTEXT_WIDTH - 1 downto ram_beN'length + RAM_CONTEXT_WIDTH);
--ram_beN_buf      <= cmd_buf_bus(ram_beN'length + RAM_CONTEXT_WIDTH - 1 downto RAM_CONTEXT_WIDTH);
ram_addr_buf     <= cmd_buf_bus(ram_addr'length + RAM_CONTEXT_WIDTH - 1 downto RAM_CONTEXT_WIDTH);
ram_beN_buf      <= cmd_buf_bus(ram_beN_buf'length + 4 - 1 downto 4); -- part of ram_context_buf
ram_context_buf  <= cmd_buf_bus(RAM_CONTEXT_WIDTH-1 downto 0);


-----------------------------------------------------
-- afifo_rd (fifo_syncram)
-----------------------------------------------------
gen_afifo : for b in SR_BANKS-1 downto 0 generate
begin

  afifo : fifo_syncram
    generic map (

      USE_RDEN             => FALSE           ,
      BYTE_SIZE            => 8               ,
      WRDATA_WIDTH         => AFIFO_DATA_WIDTH,
      WRADDR_WIDTH         => AFIFO_ADDR_WIDTH,
      RDDATA_WIDTH         => AFIFO_DATA_WIDTH,
      RDADDR_WIDTH         => AFIFO_ADDR_WIDTH,
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


-----------------------------------------------------
-- bfifo (fifo_syncram)
-----------------------------------------------------
bfifo : fifo_syncram
  generic map (

    USE_RDEN             => FALSE           ,
    BYTE_SIZE            => 8               ,
    WRDATA_WIDTH         => BFIFO_DATA_WIDTH,
    WRADDR_WIDTH         => BFIFO_ADDR_WIDTH,
    RDDATA_WIDTH         => BFIFO_DATA_WIDTH,
    RDADDR_WIDTH         => BFIFO_ADDR_WIDTH,
    FPGA_ARCH            => FPGA_ARCH       ,   
    FPGA_FAMILY          => FPGA_FAMILY 

  )
  port map (

    wrclk                => sysclk      ,
    wren                 => bfifo_wren  ,
    wraddr               => bfifo_wraddr,
    wrdata               => bfifo_wrdata,
    wrbena               => open        ,
    rdclk                => sysclk      ,
    rden                 => bfifo_rden  ,
    rdaddr               => bfifo_rdaddr,
    rddata               => bfifo_rddata

  );


-----------------------------------------------------
-- dfifo (fifo_syncram)
-----------------------------------------------------
gen_dfifo : for b in SR_BANKS-1 downto 0 generate
begin

  dfifo : fifo_syncram
    generic map (

      USE_RDEN             => FALSE           ,
      BYTE_SIZE            => 8               ,
      WRDATA_WIDTH         => DFIFO_DATA_WIDTH,
      WRADDR_WIDTH         => DFIFO_ADDR_WIDTH,
      RDDATA_WIDTH         => DFIFO_DATA_WIDTH,
      RDADDR_WIDTH         => DFIFO_ADDR_WIDTH,
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


-------------------------------------------------
-- read data readback buffer (output)
-------------------------------------------------
xdata_buffer : bus_buffer_core
  generic map (

    BUS_WIDTH                 =>  data_bus'length          ,
    A_BUS_REGISTERED          =>  RAM_DATA_REGISTERED      ,
    B_WAIT_REGISTERED         =>  RAM_DATA_WAIT_REGISTERED

  )
  port map (

    sysrstN                   => sysrstN                   ,
    sysclk                    => sysclk                    ,
    A_bus_reset               => open                      ,
    A_bus                     => data_bus                  ,
    A_wait                    => ram_data_wait_int         ,
    B_bus                     => data_buf_bus              ,
    B_wait                    => ram_data_wait      

  );

data_bus <= ram_datavalid_int & ram_data_int & ram_data_context_int;

ram_datavalid    <= data_buf_bus(data_bus'high);
ram_data         <= data_buf_bus(ram_data'length + RAM_CONTEXT_WIDTH - 1 downto RAM_CONTEXT_WIDTH); 
ram_data_context <= data_buf_bus(RAM_CONTEXT_WIDTH-1 downto 0);




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

    bfifo_wraddr                <= (others => '0');
    bfifo_rdaddr_int            <= (others => '0');
    bfifo_rdaddr_ff             <= (others => '0');
    bfifo_rddatavalid           <= '0';
    
    sr_wait_ff                  <= (others => '0');

  elsif (sysclk'event and sysclk = '1') then                                         

    sr_wait_ff                  <= sr_wait_qsys;
    bfifo_rdaddr_ff             <= bfifo_rdaddr;


    -----------------
    -- ram_active
    -- FLOPPED
    -----------------
    ram_active <= ram_read_buf or
                  bo2sl(bfifo_rdaddr_int /= bfifo_wraddr) or
                  (bfifo_rddatavalid);
  
  
    -----------------
    -- bfifo_wraddr 
    -- FLOPPED
    -----------------
    if (bfifo_wren = '1') then
      bfifo_wraddr <= std_logic_vector(unsigned(bfifo_wraddr) + 1);
    else 
      bfifo_wraddr <= bfifo_wraddr;
    end if;


    --------------
    -- bfifo_rdaddr_int
    -- FLOPPED
    --------------
    if (bfifo_rden = '1') then
      bfifo_rdaddr_int <= std_logic_vector(unsigned(bfifo_rdaddr_int) + 1);
    else
      bfifo_rdaddr_int <= bfifo_rdaddr_int;
    end if;
    
    
    --------------
    -- bfifo_rddatavalid
    -- FLOPPED
    --------------
    bfifo_rddatavalid <= -- SET
                         (bfifo_rden)
                         or (
                         -- RESET
                         not (ram_datavalid_int and not ram_data_wait_int)
                         -- SAME VALUE
                         and bfifo_rddatavalid
                         );    


  end if;
  
end process; -- clockedEvents



  --------------
  -- bfifo_wren
  -- FLOPPED
  --------------
  bfifo_wren <= ram_read_buf and not ram_wait_buf;


  --------------
  -- bfifo_wrdata[RAM_CONTEXT_WIDTH+SR_BANKS-1 : SR_BANKS] : context including sync and burst enable
  -- bfifo_wrdata[SR_BANKS-1 : 0]                          : read invalidators (1 per bank)
  --------------
  bfifo_wrdata(RAM_CONTEXT_WIDTH+SR_BANKS-1 downto SR_BANKS) <= ram_context_buf;
  bfifo_wrdata(SR_BANKS-1 downto 0)                          <= afifo_wren;

  
--------------------------------
-- clocked events per bank
--------------------------------
gen_SR_BANKS_clocked : for b in SR_BANKS-1 downto 0 generate
begin

  process (sysrstN, sysclk)
    
  begin  

    ----------
    -- reset
    ----------
    if (sysrstN = '0') then

      afifo_wraddr      (b) <= (others => '0');
      afifo_rdaddr_int  (b) <= (others => '0');
      afifo_rdaddr_ff   (b) <= (others => '0');
      afifo_full        (b) <= '0';
      afifo_threshold_go(b) <= '1';
      afifo_rd_cntr     (b) <= (others => '0');
      sr_readN_m1       (b) <= '1';
      sr_readN_m2       (b) <= '1';
      sr_readN_out      (b) <= '1';
      sr_readN_out_ff   (b) <= '1';
	  sr_arlen_1base_out      (b) <= (others => '0');
      sr_addr_out       (b) <= (others => '0');
	  sr_arlen_1base_out_ff   (b) <= (others => '0');
      sr_addr_out_ff    (b) <= (others => '0');
      dfifo_wraddr      (b) <= (others => '0');
      dfifo_rdaddr      (b) <= (others => '0');
      dfifo_rddatavalid (b) <= '0';
      dfifo_used        (b) <= (others => '0');
    
      
    elsif (sysclk'event and sysclk = '1') then                                         


      afifo_rdaddr_ff(b) <= afifo_rdaddr(b);

      --------------
      -- afifo_wraddr(b)
      -- FLOPPED
      --------------
      if (afifo_wren(b) = '1') then
        afifo_wraddr(b) <= std_logic_vector(unsigned(afifo_wraddr(b)) + 1);
      else 
        afifo_wraddr(b) <= afifo_wraddr(b);
      end if;


      -----------------
      -- afifo_rdaddr_int(b)
      -- FLOPPED
      -----------------
      if (afifo_rden(b) = '1') then
        afifo_rdaddr_int(b) <= std_logic_vector(unsigned(afifo_rdaddr_int(b)) + 1);
      else
        afifo_rdaddr_int(b) <= afifo_rdaddr_int(b);
      end if;

        
      --------------
      -- afifo_full(b)
      -- FLOPPED
      --------------
      afifo_full(b) <= bo2sl(unsigned(afifo_used(b)) > AFIFO_DEPTH - 4);


      -----------------
      -- afifo_threshold_go(b)
      -- FLOPPED
      -----------------
      afifo_threshold_go(b) <= -- SET
                               (-- abort
                                ABORT or
                                -- threshold met
                                (bo2sl(afifo_wraddr(b) /= afifo_rdaddr_int(b)) and 
                                 bo2sl(unsigned(afifo_used(b)) >= RD_BURST_SIZE) and bo2sl(unsigned(dfifo_used(b)) < DFIFO_DEPTH - DFIFO_DATA_THRESHOLD)) or
                                -- flush
                                (bo2sl(afifo_wraddr(b) /= afifo_rdaddr_int(b)) and 
                                 ram_flush and bo2sl(unsigned(dfifo_used(b)) < DFIFO_DEPTH - DFIFO_DATA_THRESHOLD)) or
                                -- transaction already in progress
                                (not sr_readN_m2(b) and sr_wait_qsys(b))
                               )
                               or (
                               -- RESET
                               not (-- no read from fifo
                                    not afifo_rden(b) or
                                    -- no more free locations in data FIFO, 
                                    bo2sl(unsigned(dfifo_used(b)) > DFIFO_DEPTH-2)
                                   )
                               -- SAME VALUE
                               and afifo_threshold_go(b)
                               );


      -----------------
      -- sr_readN_m1(b)
      -- FLOPPED
      -----------------
      sr_readN_m1(b) <= not (afifo_rden(b) or
                             (not sr_readN_m1(b) and sr_wait_int(b))
                            );

      
      -----------------
      -- sr_readN_out(b)
      -- sr_addr_out (b)
      --
      -- FLOPPED
      -----------------
      if (sr_wait_int(b) = '1') then

        sr_readN_m2          (b)  <= sr_readN_m2   (b);
		sr_arlen_1base_out   (b)  <= sr_arlen_1base_out   (b);
        sr_addr_out          (b)  <= sr_addr_out    (b);

        sr_readN_out         (b)  <= sr_readN_out(b);
        sr_readN_out_ff      (b)  <= sr_readN_out_ff(b);
		sr_arlen_1base_out_ff(b)  <= sr_arlen_1base_out_ff(b);
        sr_addr_out_ff       (b)  <= sr_addr_out_ff (b);
        

      else                   

        sr_readN_m2   (b)  <= sr_readN_m1(b);
        
        -- for read burst, we output only address when we read nb of addresses equal to read burst
        -- or we are at the eol
        if ((unsigned(afifo_rd_cntr(b)) = RD_BURST_SIZE) or (afifo_rddata(b)(AFIFO_DATA_WIDTH-2) = '1')) then
           sr_readN_out(b)  <= sr_readN_m1(b);
        else
           sr_readN_out(b)  <= '1';
        end if;
        
		sr_arlen_1base_out(b)  <= afifo_rd_cntr(b);
    --    sr_arlen_1base_out   (b)  <= '1'; -- arlen in 1024bits unit
        
        -- store the first address of the burst
        if (unsigned(afifo_rd_cntr(b)) = 1) then
           sr_addr_out    (b)(sr_addr'high(2) downto SR_ADDR_PITCH_LOG2) <= afifo_rddata(b)(sr_addr'high(2) - SR_ADDR_PITCH_LOG2 downto 0);
        end if;
        sr_addr_out    (b)(SR_ADDR_PITCH_LOG2-1 downto 0)             <= (others => '0');

        sr_readN_out_ff(b)  <= sr_readN_out(b);
		sr_arlen_1base_out_ff(b)  <= sr_arlen_1base_out(b);
        sr_addr_out_ff (b)  <= sr_addr_out (b);

      end if;
      
      if (sr_wait_int(b) = '0') then
            -- read counter has reached its maximum value, set to RD_BURST_SIZE or we just reached to end of line address
        if ((unsigned(afifo_rd_cntr(b)) = RD_BURST_SIZE) or (afifo_rddata(b)(AFIFO_DATA_WIDTH-2) = '1')) then
            afifo_rd_cntr(b) <= (others => '0');
            if (afifo_rden(b) = '1') then
              afifo_rd_cntr(b)(0) <= '1';
            end if;
          
        else
          if (afifo_rden(b) = '1') then
            afifo_rd_cntr(b) <= std_logic_vector(unsigned(afifo_rd_cntr(b)) + 1);
          end if;
        end if;  
      end if;

      --------------
      -- dfifo_wraddr(b)
      -- FLOPPED
      --------------
      if (dfifo_wren(b) = '1') then
        dfifo_wraddr(b) <= std_logic_vector(unsigned(dfifo_wraddr(b)) + 1);
      else 
        dfifo_wraddr(b) <= dfifo_wraddr(b);
      end if;
      

      --------------
      -- dfifo_rdaddr(b)
      -- FLOPPED
      --------------
      if (dfifo_rden(b) = '1') then
         dfifo_rdaddr(b) <= std_logic_vector(unsigned(dfifo_rdaddr(b)) + 1);
      end if;

      --------------
      -- dfifo_rddatavalid(b)
      -- FLOPPED
      --------------
      dfifo_rddatavalid(b) <= -- SET
                              (dfifo_rden(b))
                              or (
                              -- RESET
                              not (ram_datavalid_int and not ram_data_wait_int and not dfifo_rdmask(b))
                              -- SAME VALUE
                              and dfifo_rddatavalid(b)
                              );
      

      ---------------
      -- dfifo_used(b)
      -- FLOPPED
      ---------------
      if (ABORT = '1') then
        dfifo_used(b) <= (others => '0');
      elsif (afifo_rden(b) = '1' and dfifo_rden(b) = '0') then
        dfifo_used(b) <= std_logic_vector(unsigned(dfifo_used(b)) + 1);
      elsif (afifo_rden(b) = '0' and dfifo_rden(b) = '1') then
        dfifo_used(b) <= std_logic_vector(unsigned(dfifo_used(b)) - 1);	
      else
        dfifo_used(b) <= dfifo_used(b);
      end if;


    end if;

  end process;
  
end generate gen_SR_BANKS_clocked;


  --------------------------------
  -- gen_SR_BANKS_unclocked
  --------------------------------
  gen_SR_BANKS_unclocked : for b in SR_BANKS-1 downto 0 generate
  begin

    --------------
    -- afifo_wrdata(b) 
    --------------                                                                                                                 ------------- extra +ram_context_buf'right is added because ram_context_buf is (left downto 1)!!!
    afifo_wrdata(b)(ram_addr_buf'high - log2((SR_DATA_WIDTH/8)*SR_BANKS) downto 0) <= ram_addr_buf(ram_addr_buf'high downto log2((SR_DATA_WIDTH/8)*SR_BANKS));
    afifo_wrdata(b)(AFIFO_DATA_WIDTH-5 downto ram_addr_buf'high - log2((SR_DATA_WIDTH/8)*SR_BANKS) + 1) <= (others => '0');
    afifo_wrdata(b)(AFIFO_DATA_WIDTH-1 downto AFIFO_DATA_WIDTH-4) <= ram_context_buf(4 downto 1);--ram_context_buf(3); -- sync eol


    --------------
    -- afifo_wren(b)
    --------------
    afifo_wren(b) <= ram_read_buf and not AndN(ram_beN_buf(SR_DATA_WIDTH/8 * (b + 1) - 1 downto (SR_DATA_WIDTH/8) * b)) and not ram_wait_buf;
                       

    --------------
    -- afifo_rden(b)
    --------------
    --afifo_rden(b) <= bo2sl(afifo_wraddr(b) /= afifo_rdaddr_int(b)) and afifo_threshold_go(b) and not (not sr_readN_m1(b) and sr_wait_int(b));
    afifo_rden(b) <= bo2sl(afifo_wraddr(b) /= afifo_rdaddr_int(b)) and afifo_threshold_go(b) and not sr_wait_int(b);

    ---------------
    -- afifo_rdaddr(b)
    --------------
    afifo_rdaddr(b) <= afifo_rdaddr_int(b) when afifo_rden(b) = '1' else afifo_rdaddr_ff(b);
  

    ---------------
    -- afifo_used(b)
    ---------------
    afifo_used(b) <= std_logic_vector(unsigned(afifo_wraddr(b)) - unsigned(afifo_rdaddr_int(b)));


    --------------
    -- dfifo_rden(b)
    --------------
    dfifo_rden(b) <= bo2sl(dfifo_wraddr(b) /= dfifo_rdaddr(b)) and not
                     ( 
                       -- wait 
                       ram_data_wait_int or
                       -- data is masked
                       (dfifo_rddatavalid(b) and dfifo_rdmask(b)) or
                       -- some but not all data is ready 
                       (dfifo_rddatavalid(b) and not ram_datavalid_int)
                     );



    --------------
    -- dfifo_wrdata(b)
    --------------
    dfifo_wrdata(b) <= array2slv(sr_data, b);


    -----------------
    -- sr_readN(b)
    -----------------
    sr_readN_int(b) <= sr_readN_out_ff(b) when (sr_wait_ff(b) = '1' and SR_WAIT_REGISTERED = TRUE) else sr_readN_out(b);
    sr_readN(b) <=  sr_readN_int(b);


    -----------------
    -- sr_addr_2d(b)
    -----------------
    sr_addr_2d(b) <= sr_addr_out_ff (b) when (sr_wait_ff(b) = '1' and SR_WAIT_REGISTERED = TRUE) else sr_addr_out (b);

	-----------------
	-- sr_arlen_1base_2d(b)
	-----------------
    sr_arlen_1base_2d(b) <= sr_arlen_1base_out_ff(b) when (sr_wait_ff(b) = '1' and SR_WAIT_REGISTERED = TRUE) else sr_arlen_1base_out (b);
	
    -----------------
    -- ram_data_int
    -----------------
    ram_data_int((b+1)*SR_DATA_WIDTH-1 downto b*SR_DATA_WIDTH) <= dfifo_rddata(b);


  end generate gen_SR_BANKS_unclocked;


  --------------
  -- afifo_full_all
  --------------
  afifo_full_all <= OrN(afifo_full);


  --------------
  -- bfifo_rden
  --------------
  bfifo_rden <= bo2sl(bfifo_rdaddr_int /= bfifo_wraddr) and
                (
                 not bfifo_rddatavalid or
                 (ram_datavalid_int and not ram_data_wait_int)
                );


  ---------------
  -- bfifo_rdaddr
  --------------
  bfifo_rdaddr <= bfifo_rdaddr_int when bfifo_rden = '1' else bfifo_rdaddr_ff;
  

  --------------
  -- bfifo_full
  --------------
  bfifo_full <= bo2sl(unsigned(bfifo_wraddr) - unsigned(bfifo_rdaddr_int) > BFIFO_DEPTH - 5);


  -----------------
  -- 2D output signals in port map
  -- sr_addr
  -----------------
  sr_addr <= out2d_sr_addr(sr_addr_2d);
  
  
  -----------------
  -- 2D output signals in port map
  -- sr_arlen_1base
  -----------------
  sr_arlen_1base <= out2d_sr_arlen(sr_arlen_1base_2d);

  
  --------------
  -- dfifo_wren
  --------------
  dfifo_wren <= sr_datavalid;


  --------------
  -- sr_wait_int
  --------------
  sr_wait_int <= sr_wait_ff when SR_WAIT_REGISTERED = TRUE else sr_wait_qsys;


  -----------------
  -- ram_wait_buf
  -----------------
  ram_wait_buf <= afifo_full_all or bfifo_full;


  -----------------
  -- dfifo_rdmask
  -----------------
  dfifo_rdmask <= not bfifo_rddata(SR_BANKS-1 downto 0);
  
  
  -----------------
  -- ram_datavalid_int
  -----------------
  ram_datavalid_int <= bfifo_rddatavalid and AndN(dfifo_rddatavalid or dfifo_rdmask);


  ------------------------------------------------------------------------------------------------------
  -- ram_data_context_int
  -- SR_BANKS-1:0 = rd mask (afifo_wren)
  -- 3+SR_BANKS:SR_BANKS = syncs
  -- 4+SR_BANKS+RAM_BEN_WIDTH-1:4+SR_BANKS = byte enables
  -- Be aware that bfifo_rddata was rounded up to multiple of 8, so last bits could/should not be used
  ------------------------------------------------------------------------------------------------------     
  ram_data_context_int(ram_data_context_int'left downto 1) <= bfifo_rddata(4+SR_BANKS+SR_DATA_WIDTH*SR_BANKS/8-1 downto SR_BANKS);
 


end functional;


