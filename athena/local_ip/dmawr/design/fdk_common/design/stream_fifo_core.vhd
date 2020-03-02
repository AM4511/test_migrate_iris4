----------------------------------------------------------------------
--  $HeadURL: svn://brainstorm/svn_ipcore/trunk/Matrox/Imaging/FDK/hw/cores/common/design/stream_fifo_core.vhd $
--  $Revision: 9244 $
--  $Date: 2009-06-11 11:45:04 -0400 (Thu, 11 Jun 2009) $
--  $Author: palepin $
--
--  DESCRIPTION: Stream FIFO core module
--
--  contains the following modules:
--
--         fifo_syncram
--
--
--  Functionality
--
--  The ABORT signal forces a reset of the FIFO. When '1', the FIFO ignores
--  all signals on the stream input interface and the si_wait signal goes to '0'.
--  Furthermore no new transaction is initiated on the stream output interface
--  (i.e. FIFO content is forever lost, it is not flushed). Note that a transaction that
--  was already initiated on the stream output port will be completed, meaning
--  that if a transaction is being held by an active wait, it will be held until
--  the wait signal (so_wait) is disactivated by the destination. 
-- 
--  The so_active signal indicates that the fifo has an active outstanding master 
--  transaction on the stream output interface. Master transactions being held by an 
--  active wait will cause the so_active to stay at 1, regardless of the state of the 
--  ABORT signal. As long as the so_active signal is '1', The IP's ACTIVE signal should 
--  stay at '1'. The so_active signal is flopped.
--
-- 
--  Note: si_wait can go to 1 even if si_write = 0
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
--    SO_DATA_WIDTH        : (integer)
--
--                           width of so_data signal: 64, 128, etc.
--
--
--
--    DATA_CAPACITY        : (integer)
--
--                           maximum FIFO capacity in terms of number of bits of data. 
--                           Valid values are 2exp(n)*1024 where n = 0, 1, 2, etc.
--
--
--
--    SO_WAIT_REGISTERED   : (boolean)
--
--                           When SO_WAIT_REGISTERED is TRUE, the signal so_wait is routed directly and uniquely 
--                           to a register (flip-flop). This limits the fanout on this signal to '1' and can 
--                           thus help improve timings. Extra logic is added to make the addtition of a flip-flop
--                           on the so_wait signal transparent to the rest of the logic. A value of TRUE is 
--                           recommended when the stream output interface of the stream_fifo_core connects to a  
--                           stream output port of an IP (i.e. when the stream_fifo_core is used as a stream output fifo
--                           that connects directly to the switch of the system). A value of FALSE is recommended
--                           when the stream output interface of the stream_fifo_core is connected to internal logic of 
--                           an IP (i.e. when the stream_fifo_core is used as a stream input fifo).
--
--
--
--    BEN_ONLY_AT_EOL      : (boolean)
--
--                           When BEN_ONLY_AT_EOL is TRUE, the FIFO expects inactive byte enables 
--                           only at the end of a line. In this mode, the FIFO logic will not forward data
--                           when all the byte enables for a given data on output are inactive (this 
--                           is applicable at the end of a line when the SO_DATA_WIDTH is smaller than the 
--                           SI_DATA_WIDTH). Here is an example: 
--                           for SI_DATA_WIDTH = 128 and SO_DATA_WIDTH = 64, a data with byte
--                           enables = 0xFF00 on the input side will result in 2 writes on the output side
--                           when BEN_ONLY_AT_EOL is FALSE (the first write with byte enables = 0x00, the 
--                           second with byte enables = 0xFF), but only 1 write when BEN_ONLY_AT_EOL is TRUE.
--                           The value of BEN_ONLY_AT_EOL should usually be FALSE unless the design can
--                           guarantee that byte enables are used only at EOL (such as is the case with
--                           the dma read module).
--
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

--MTX_START_SUPPRESS
-- altera message_level Level1
-- altera message_off 10030 10873
--MTX_END_SUPPRESS

library ieee;
  use ieee.std_logic_1164.all; 
  use ieee.std_logic_unsigned.all;
  use ieee.std_logic_arith.all;

entity stream_fifo_core is
  generic (

    SI_DATA_WIDTH        : integer := 64        ; -- width of si_data signal: 64, 128, etc.
    SO_DATA_WIDTH        : integer := 64        ; -- width of so_data signal: 64, 128, etc.
    DATA_CAPACITY        : integer := 1024      ; -- maximum FIFO capacity in terms of number of bits of data
    VACANCY_LEVEL        : integer := 1024      ; -- referenve level used for vacancy signal
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
    vacancy              : out       std_logic; -- vacancy = 1 when remaining fifo capacity < VACANCY_LEVEL
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
end stream_fifo_core;




architecture functional of stream_fifo_core is

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


  -----------------------------------------------------
  -- max
  -----------------------------------------------------
  function max       ( arg1               : integer;        
                       arg2               : integer         
                     ) return               integer is
                     
  variable result : integer;
  begin

    if (arg1 > arg2) then
      result := arg1;
    else
      result := arg2;
    end if;

    return result;
  end;


  -----------------------------------------------------
  -- log2
  -----------------------------------------------------
  function log2      ( arg                : integer         
                     ) return               integer is
                     
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
  -- AndN
  -- Function making an AND of a group of signals.
  -----------------------------------------------------
  function AndN      ( arg                : std_logic_vector
                     ) return               std_logic is

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

  -- data + byte enables fifo
  constant S_DATA_WIDTH       : integer := max(SI_DATA_WIDTH,SO_DATA_WIDTH);
  constant DFIFO_DATA_WIDTH   : integer := S_DATA_WIDTH+S_DATA_WIDTH/8;
  constant DFIFO_SRAM_DEPTH   : integer := DATA_CAPACITY/S_DATA_WIDTH;  
  constant DFIFO_ADDR_WIDTH   : integer := log2(DATA_CAPACITY/S_DATA_WIDTH);

  -- sync fifo
  constant SFIFO_DATA_WIDTH   : integer := 8;
  constant SFIFO_ADDR_WIDTH   : integer := DFIFO_ADDR_WIDTH;

  constant WRBLOCKS           : integer := S_DATA_WIDTH / SI_DATA_WIDTH;

  constant RDBLOCKS           : integer := S_DATA_WIDTH / SO_DATA_WIDTH;

  -----------------------------------------------------
  -- signals
  -----------------------------------------------------

  -- stream input flopped
  signal si_write_ff            : std_logic;
  signal si_sync_ff             : std_logic_vector(1 downto 0);
  signal si_data_ff             : std_logic_vector(SI_DATA_WIDTH-1 downto 0);
  signal si_beN_ff              : std_logic_vector(SI_DATA_WIDTH/8 - 1 downto 0);

  signal si_wait_almost_full_m1 : std_logic;
  signal si_wait_almost_full    : std_logic;
  signal si_wait_eol_m1         : std_logic;
  signal si_wait_eol            : std_logic;
  signal si_wait_int            : std_logic;
  signal si_wait_out            : std_logic;

  -- stream output
  signal so_write_out_m1        : std_logic;
  signal so_write_out           : std_logic;
  signal so_sync_out_m1         : std_logic_vector(1 downto 0);
  signal so_sync_out            : std_logic_vector(1 downto 0);
  signal so_data_out_m1         : std_logic_vector(SO_DATA_WIDTH-1 downto 0);
  signal so_data_out            : std_logic_vector(SO_DATA_WIDTH-1 downto 0);
  signal so_beN_out_m1          : std_logic_vector(SO_DATA_WIDTH/8 - 1 downto 0);
  signal so_beN_out             : std_logic_vector(SO_DATA_WIDTH/8 - 1 downto 0);
  signal so_wait_int            : std_logic;
  signal so_wait_ff             : std_logic;
  signal so_write_out_ff        : std_logic;
  signal so_sync_out_ff         : std_logic_vector(1 downto 0);
  signal so_data_out_ff         : std_logic_vector(SO_DATA_WIDTH-1 downto 0);
  signal so_beN_out_ff          : std_logic_vector(SO_DATA_WIDTH/8 - 1 downto 0);

  -- bus width mismatch signals
  signal wrblk                  : integer := 0;
  signal rdblk                  : integer := 0;
  
  -- data fifo signals
  --signal dfifo_wrclock          : std_logic;
  signal dfifo_wraddr           : std_logic_vector(DFIFO_ADDR_WIDTH downto 0);  -- add 1 for fifo full logic
  signal dfifo_wren             : std_logic;
  signal dfifo_wrdata           : std_logic_vector(DFIFO_DATA_WIDTH-1 downto 0);
  signal dfifo_wrbena           : std_logic_vector(DFIFO_DATA_WIDTH/9-1 downto 0);
  --signal dfifo_rdclock          : std_logic;
  signal dfifo_rdaddr           : std_logic_vector(DFIFO_ADDR_WIDTH downto 0);  -- add 1 for fifo full logic
  signal dfifo_rdaddr_int       : std_logic_vector(DFIFO_ADDR_WIDTH downto 0);  -- add 1 for fifo full logic
  signal dfifo_rdaddr_ff        : std_logic_vector(DFIFO_ADDR_WIDTH downto 0);  -- add 1 for fifo full logic
  signal dfifo_rden             : std_logic;
  signal dfifo_rddata           : std_logic_vector(DFIFO_DATA_WIDTH-1 downto 0);

  -- sync fifo signals
  --signal sfifo_wrclock          : std_logic;
  signal sfifo_wraddr           : std_logic_vector(SFIFO_ADDR_WIDTH downto 0);
  signal sfifo_wren             : std_logic;
  signal sfifo_wrdata           : std_logic_vector(SFIFO_DATA_WIDTH-1 downto 0);
  --signal sfifo_rdclock          : std_logic;
  signal sfifo_rdaddr           : std_logic_vector(SFIFO_ADDR_WIDTH downto 0);
  signal sfifo_rden             : std_logic;
  signal sfifo_rddata           : std_logic_vector(SFIFO_DATA_WIDTH-1 downto 0);

  -- fifo full logic
  signal dfifo_used             : std_logic_vector(dfifo_wraddr'range);
  signal dfifo_almost_full      : std_logic;

--synthesis translate_off
  signal signal_DATA_CAPACITY      : integer := DATA_CAPACITY    ;
  signal signal_S_DATA_WIDTH       : integer := S_DATA_WIDTH     ;
  signal signal_DFIFO_DATA_WIDTH   : integer := DFIFO_DATA_WIDTH ;
  signal signal_DFIFO_SRAM_DEPTH   : integer := DFIFO_SRAM_DEPTH ;
  signal signal_DFIFO_ADDR_WIDTH   : integer := DFIFO_ADDR_WIDTH ;
--synthesis translate_on

begin

  -----------------------------------------------------
  -- data + byte enables fifo
  -----------------------------------------------------
  xdfifo : fifo_syncram
  generic map (

    USE_RDEN             => FALSE           ,
    BYTE_SIZE            => 9               ,
    WRDATA_WIDTH         => DFIFO_DATA_WIDTH,
    WRADDR_WIDTH         => DFIFO_ADDR_WIDTH,
    RDDATA_WIDTH         => DFIFO_DATA_WIDTH,
    RDADDR_WIDTH         => DFIFO_ADDR_WIDTH,
    FPGA_ARCH            => FPGA_ARCH       ,
    FPGA_FAMILY          => FPGA_FAMILY

  )
  port map (

    wrclk                => sysclk      ,
    wren                 => dfifo_wren  ,
    wraddr               => dfifo_wraddr(DFIFO_ADDR_WIDTH-1 downto 0),
    wrdata               => dfifo_wrdata,
    wrbena               => dfifo_wrbena,
    rdclk                => sysclk      ,
    rden                 => dfifo_rden  ,
    rdaddr               => dfifo_rdaddr(DFIFO_ADDR_WIDTH-1 downto 0),
    rddata               => dfifo_rddata

  );


  -----------------------------------------------------
  -- sync fifo
  -----------------------------------------------------
  xsfifo : fifo_syncram
  generic map (

    USE_RDEN             => FALSE           ,
    BYTE_SIZE            => 8               ,
    WRDATA_WIDTH         => SFIFO_DATA_WIDTH,
    WRADDR_WIDTH         => SFIFO_ADDR_WIDTH,
    RDDATA_WIDTH         => SFIFO_DATA_WIDTH,
    RDADDR_WIDTH         => SFIFO_ADDR_WIDTH,
    FPGA_ARCH            => FPGA_ARCH       ,
    FPGA_FAMILY          => FPGA_FAMILY

  )
  port map (

    wrclk                => sysclk      ,
    wren                 => sfifo_wren  ,
    wraddr               => sfifo_wraddr(SFIFO_ADDR_WIDTH-1 downto 0),
    wrdata               => sfifo_wrdata,
    wrbena               => open,
    rdclk                => sysclk      ,
    rden                 => sfifo_rden  ,
    rdaddr               => sfifo_rdaddr(SFIFO_ADDR_WIDTH-1 downto 0),
    rddata               => sfifo_rddata

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

    so_active               <= '0';

    si_write_ff             <= '0';
    si_sync_ff              <= (others => '0');
    si_data_ff              <= (others => '0');
    si_beN_ff               <= (others => '0');

    si_wait_almost_full     <= '0';
    si_wait_eol             <= '0';
    si_wait                 <= '0';
    si_wait_int             <= '0';
    
    wrblk                   <= 0;
    rdblk                   <= 0;

    dfifo_rdaddr_int        <= (others => '0');
    dfifo_rdaddr_ff         <= (others => '0');
    dfifo_wraddr            <= (others => '0');

    so_write_out_m1         <= '0';
    so_write_out            <= '0';
    so_sync_out             <= (others => '0');
    so_data_out             <= (others => '0');
    so_beN_out              <= (others => '0');
    so_wait_ff              <= '0';
    so_write_out_ff         <= '0';
    so_sync_out_ff          <= (others => '0');
    so_data_out_ff          <= (others => '0');
    so_beN_out_ff           <= (others => '0');

  elsif (sysclk'event and sysclk = '1') then                                         

    
    si_wait_almost_full     <= si_wait_almost_full_m1;
    si_wait_eol             <= si_wait_eol_m1;
    si_wait                 <= si_wait_out;
    si_wait_int             <= si_wait_out;
    dfifo_rdaddr_ff         <= dfifo_rdaddr;
    so_wait_ff              <= so_wait;



    -----------------
    -- so_active
    -- FLOPPED
    -----------------
    so_active <= so_write_out_m1 or
                 so_write_out or 
                 (so_write_out_ff and bo2sl(SO_WAIT_REGISTERED));


    --------------
    -- si_write_ff
    -- si_sync_ff
    -- si_data_ff
    -- si_beN_ff
    -- FLOPPED
    --------------
    if (si_wait_int = '0') then
      si_write_ff <= si_write;
      si_sync_ff  <= si_sync ;
      si_data_ff  <= si_data ;
      si_beN_ff   <= si_beN  ;
    else
      si_write_ff <= si_write_ff;
      si_sync_ff  <= si_sync_ff ;
      si_data_ff  <= si_data_ff ;
      si_beN_ff   <= si_beN_ff  ;
    end if;

    
    --------------
    -- wrblk
    -- FLOPPED
    --------------
    if (ABORT = '1' or
        -- eol
        si_wait_eol = '1' or
        -- eof
        (dfifo_wren = '1' and si_sync_ff = "11")
       ) then 
      wrblk <= 0;
    elsif (dfifo_wren = '1') then
      wrblk <= (wrblk + 1) mod (WRBLOCKS);
    else  
      wrblk <= wrblk;
    end if;
    
    
    --------------
    -- rdblk
    -- FLOPPED
    --------------
    if (ABORT = '1' or
        dfifo_rden = '1'
        ) then 
      rdblk <= 0;
    elsif ((dfifo_wraddr /= dfifo_rdaddr_int and so_wait_int = '0') or
           (rdblk /= RDBLOCKS-1 and so_wait_int = '0')
          ) then
      rdblk <= (rdblk + 1)mod(RDBLOCKS);
    else  
      rdblk <= rdblk;
    end if;
    
    
    --------------
    -- dfifo_wraddr
    -- FLOPPED
    --------------
    if (ABORT = '1') then
      dfifo_wraddr <= (others => '0');
    elsif (-- eol
           si_wait_eol = '1' or
           -- eof
           (dfifo_wren = '1' and si_sync_ff = "11") or
           -- continuous data (after writing to entire width of dfifo)
           (dfifo_wren = '1' and wrblk = WRBLOCKS-1)
          ) then
      dfifo_wraddr <= dfifo_wraddr + 1;
    else
      dfifo_wraddr <= dfifo_wraddr;
    end if;


    --------------
    -- dfifo_rdaddr_int
    -- FLOPPED
    --------------
    if (ABORT = '1') then
      dfifo_rdaddr_int <= (others => '0');
    elsif (dfifo_rden = '1') then
      dfifo_rdaddr_int <= dfifo_rdaddr_int + 1;
    else
      dfifo_rdaddr_int <= dfifo_rdaddr_int;
    end if;


    --------------
    -- so_write_out_m1
    -- FLOPPED
    --------------
    if (-- new data available
        (ABORT = '0' and dfifo_wraddr /= dfifo_rdaddr_int) or
        -- multi-block read (when FIFO width greater than stream out width)
        (ABORT = '0' and so_write_out_m1 = '1' and rdblk /= RDBLOCKS-1 and 
         sfifo_rddata(so_sync_out'range) /= "11") or -- EOF = "11"
        -- wait on stream out port
        (ABORT = '0' and so_wait_int = '1' and so_write_out_m1 = '1')
       ) then
      so_write_out_m1 <= '1';
    else
      so_write_out_m1 <= '0';
    end if;


    --------------
    -- so_write_out
    -- so_sync_out
    -- so_data_out
    -- so_beN_out
    -- for so_write_out: condition "and not AndN(so_beN_out_m1)" assumes byte enables used only at end of line and
    --                   is used to prevent unecessary writes
    -- FLOPPED
    --------------
    if (so_wait_int = '0') then

      so_write_out    <= so_write_out_m1 and (not bo2sl(BEN_ONLY_AT_EOL) or not AndN(so_beN_out_m1) or bo2sl(so_sync_out_m1 = "11" and rdblk = 0));
      so_sync_out     <= so_sync_out_m1; 
      so_data_out     <= so_data_out_m1;
      so_beN_out      <= so_beN_out_m1 ;

      so_write_out_ff <= so_write_out;
      so_sync_out_ff  <= so_sync_out ;
      so_data_out_ff  <= so_data_out ;
      so_beN_out_ff   <= so_beN_out  ;

    else

      so_write_out    <= so_write_out;
      so_sync_out     <= so_sync_out ;
      so_data_out     <= so_data_out ;
      so_beN_out      <= so_beN_out  ;

      so_write_out_ff <= so_write_out_ff;
      so_sync_out_ff  <= so_sync_out_ff ; 
      so_data_out_ff  <= so_data_out_ff ; 
      so_beN_out_ff   <= so_beN_out_ff  ;  

    end if;

  end if;

end process;







  --------------
  -- dfifo_wrdata (data)
  --   [ 7: 0] = data
  --   [    8] = beN
  --------------
  gen_dfifo_wrdata : for i in WRBLOCKS-1 downto 0 generate
  begin

    gen_dfifo_wrdata2 : for j in (DFIFO_DATA_WIDTH/WRBLOCKS)/9-1 downto 0 generate
    begin

      dfifo_wrdata(i*DFIFO_DATA_WIDTH/WRBLOCKS + (j+1)*9 -2 downto i*DFIFO_DATA_WIDTH/WRBLOCKS + j*9)  <= si_data_ff((j+1)*8-1 downto j*8);      

    end generate gen_dfifo_wrdata2; 

  end generate gen_dfifo_wrdata; 


  --------------
  -- dfifo_wrdata (byte enables)
  --   [ 7: 0] = data
  --   [    8] = beN
  --------------
  gen_dfifo_wrdata_beN : for i in WRBLOCKS-1 downto 0 generate
  begin

    gen_dfifo_wrdata_beN2 : for j in (DFIFO_DATA_WIDTH/WRBLOCKS)/9-1 downto 0 generate
    begin

      dfifo_wrdata(i*DFIFO_DATA_WIDTH/WRBLOCKS + (j+1)*9 -1)  <= '1' when (wrblk = 0 and i /= 0) else si_beN_ff(j);

    end generate gen_dfifo_wrdata_beN2; 

  end generate gen_dfifo_wrdata_beN; 


  --------------
  -- sfifo_wrdata
  --   [ 1: 0] = sync
  --------------
  sfifo_wrdata(si_sync'length-1 downto 0) <= si_sync_ff;
  sfifo_wrdata(sfifo_wrdata'high downto si_sync'length) <= (others => '0');

  --------------
  -- dfifo_wrbena
  -- active high byte enables for writing to FIFO
  -- Note: write to all block when wrblk = 0 to disbale byte enables for all superior blocks
  --------------
  gen_dfifo_wrbena : for i in WRBLOCKS-1 downto 0 generate
  begin

    dfifo_wrbena((i+1)*SI_DATA_WIDTH/8-1 downto i*SI_DATA_WIDTH/8) <= (others => '1') when (wrblk = 0 or i = wrblk) else (others => '0');

  end generate gen_dfifo_wrbena; 
 
 
  --------------
  -- dfifo_wren
  --------------
  dfifo_wren <= si_write_ff and not si_wait_almost_full and not si_wait_eol;
  
 
  --------------
  -- dfifo_rden
  --------------
  dfifo_rden <= (bo2sl(dfifo_wraddr /= dfifo_rdaddr_int) and not so_wait_int and so_write_out_m1 and bo2sl(rdblk = RDBLOCKS-1)) or
                (bo2sl(dfifo_wraddr /= dfifo_rdaddr_int) and not so_write_out_m1);


  ---------------
  -- dfifo_rdaddr
  --------------
  dfifo_rdaddr <= dfifo_rdaddr_int when dfifo_rden = '1' else dfifo_rdaddr_ff;
  

  --------------
  -- sfifo_rdaddr
  -- sfifo_wraddr
  -- sfifo_rden  
  -- sfifo_wren  
  --------------
  sfifo_rdaddr <= dfifo_rdaddr;
  sfifo_wraddr <= dfifo_wraddr;
  sfifo_rden   <= dfifo_rden;        
  sfifo_wren   <= dfifo_wren and bo2sl(wrblk = 0);        


  --------------
  -- dfifo_used
  --------------
  dfifo_used <=   dfifo_wraddr(dfifo_wraddr'high downto dfifo_wraddr'high - dfifo_used'high)
                - dfifo_rdaddr_int(dfifo_rdaddr'high downto dfifo_rdaddr'high - dfifo_used'high);


  --------------
  -- dfifo_almost_full
  --------------
  dfifo_almost_full <= bo2sl(conv_integer(dfifo_used) > (DFIFO_SRAM_DEPTH-3));


  -----------------
  -- si_wait_almost_full_m1
  -----------------
  si_wait_almost_full_m1 <= dfifo_almost_full;


  -----------------
  -- si_wait_eol_m1
  -- used to increment sram address
  -- systematically adds a pause when sync EOL (01) or EOF (11) except when,
  -- on the next clock, sram write address points to an address in the FIFO that has
  -- not yet been written to. This is true in the following 2 cases:
  --   1) si_write_ff = 1 and wrblk = WRBLOCKS-1
  --   2) si_write_ff = 0 and wrblk = 0
  --   3) si_write_ff = 1 and si_sync_ff = "11" (EOF)
  -----------------
  si_wait_eol_m1 <= si_write and bo2sl(si_sync(0) = '1') and not si_wait_int 
                    and not (-- case 1
                             (si_write_ff and bo2sl(wrblk = WRBLOCKS-1)) or
                             -- case 2
                             (not si_write_ff and bo2sl(wrblk = 0)) or
                             -- case 3
                             (si_write_ff and bo2sl(si_sync_ff = "11"))
                            );


  --------------
  -- si_wait_out
  --------------
  si_wait_out <= si_wait_almost_full_m1 or si_wait_eol_m1;


  --------------
  -- so_sync_out_m1
  --------------
  so_sync_out_m1 <= sfifo_rddata(so_sync_out'range) when (rdblk = 0 or so_write_out = '0') else "10"; -- 10 = CONT


  --------------
  -- so_data_out_m1
  --------------
  gen_data_out : for i in SO_DATA_WIDTH/8-1 downto 0 generate
  begin

    gen_data_out2 : for j in 7 downto 0 generate
    begin

      so_data_out_m1(i*8+j) <= dfifo_rddata((rdblk*(DFIFO_DATA_WIDTH/RDBLOCKS))+i*9+j);

    end generate gen_data_out2;

  end generate gen_data_out; 

  
  --------------
  -- so_beN_out_m1
  --------------
  gen_beN_out : for i in SO_DATA_WIDTH/8-1 downto 0 generate
  begin

    so_beN_out_m1 (i) <= dfifo_rddata((rdblk*(DFIFO_DATA_WIDTH/RDBLOCKS))+i*9+8);

  end generate gen_beN_out; 


  --------------
  -- so_write
  -- so_sync 
  -- so_data 
  -- so_beN  
  --------------
  so_write <= so_write_out_ff when (so_wait_ff = '1' and SO_WAIT_REGISTERED = TRUE) else so_write_out;
  so_sync  <= so_sync_out_ff  when (so_wait_ff = '1' and SO_WAIT_REGISTERED = TRUE) else so_sync_out ;
  so_data  <= so_data_out_ff  when (so_wait_ff = '1' and SO_WAIT_REGISTERED = TRUE) else so_data_out ;
  so_beN   <= so_beN_out_ff   when (so_wait_ff = '1' and SO_WAIT_REGISTERED = TRUE) else so_beN_out  ;


  --------------
  -- so_wait_int
  --------------
  so_wait_int <= so_wait_ff when SO_WAIT_REGISTERED = TRUE else so_wait;


  --------------
  -- vacancy
  --------------
  vacancy <= bo2sl(conv_integer(dfifo_used) < VACANCY_LEVEL/S_DATA_WIDTH);


end functional;

