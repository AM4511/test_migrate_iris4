-----------------------------------------------------------------------          
--                                                                               
-- FILE        : dmawr_sub4.vhd                                                  
--                                                                               
-- ENTITY      : dmawr_sub4                                               
--               (wrapper entity for component dmawr_sdram512)                    
--                                                                               
-- DESCRIPTION : DMA write, FID = 0xC011, subFID = 4, 1 x 512-bit bank                                         
--                                                                               
----------------------------------------------------------------------           

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_unsigned.all;
  use ieee.std_logic_arith.all;
  use IEEE.NUMERIC_STD.all;

entity dmawr_sub4 is
  generic (
     AXIS_DATA_WIDTH : integer := 64;  
     AXI_DATA_WIDTH  : integer := 512;
     AXI_ADDR_WIDTH  : integer := 33;
     AXI_BURST_SIZE  : integer := 16;  -- 4 to 32
     NB_DATA_ACC     : integer := 16   -- number of data to be accumulated before being evacuated (0 to 32)
  );
  port (

    ---------------------------------------------------------------------
    -- global 
    ---------------------------------------------------------------------
    sysrstN          : in  std_logic;
    sysclk           : in  std_logic;
  --  LSBOF            : in  std_logic_vector(6 downto 0);
    intevent         : out std_logic;
    
    ---------------------------------------------------------------------
    -- RegisterFile 
    ---------------------------------------------------------------------
      -- write address channel
    s_axi_awaddr     : in std_logic_vector(8 downto 0);
    s_axi_awvalid    : in std_logic;
    s_axi_awready    : out std_logic;
                                
    -- write data channel
    s_axi_wdata      : in std_logic_vector(63 downto 0);
    s_axi_wstrb      : in std_logic_vector((64/8)-1 downto 0); --This signal indicates which byte lanes to update in memory.
    s_axi_wvalid     : in std_logic;
    s_axi_wready     : out  std_logic;     
        
      -- write response channel
    s_axi_bresp      : out std_logic_vector(1 downto 0);
    s_axi_bvalid     : out std_logic;
    s_axi_bready     : in std_logic;          
    
      -- read address channel
    s_axi_araddr     : in std_logic_vector(8 downto 0);
    s_axi_arvalid    : in std_logic;
    s_axi_arready    : out std_logic;
      
      -- read data channel
    s_axi_rdata      : out std_logic_vector(63 downto 0);
    s_axi_rresp      : out std_logic_vector(1 downto 0);
    s_axi_rvalid     : out std_logic;
    s_axi_rready     : in std_logic;      
         
    ---------------------------------------------------------------------
    -- Sdram 
    ---------------------------------------------------------------------     
    -- write address channel signals
    m_axi_awid       : out std_logic_vector(2 downto 0);
    m_axi_awaddr     : out std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
    m_axi_awlen      : out std_logic_vector(7 downto 0);
    m_axi_awsize     : out std_logic_vector(2 downto 0);
    m_axi_awburst    : out std_logic_vector(1 downto 0);
    m_axi_awvalid    : out std_logic;
    m_axi_awready    : in std_logic;
      
    -- write data channel signals
    m_axi_wdata      : out std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
    m_axi_wstrb      : out std_logic_vector((AXI_DATA_WIDTH/8)-1 downto 0); --This signal indicates which byte lanes to update in memory.
    m_axi_wlast      : out std_logic;
    m_axi_wvalid     : out std_logic;
    m_axi_wready     : in  std_logic;     
      
    -- write response channel signals
    m_axi_bid        : in std_logic_vector(2 downto 0);
    m_axi_bresp      : in std_logic_vector(1 downto 0);
    m_axi_bvalid     : in std_logic;
    m_axi_bready     : out std_logic;       
         
    ----------------------------------------------------
    -- AXI stream interface (Slave port)
    ----------------------------------------------------
    s_axis_tready    : out std_logic;
    s_axis_tdest     : in std_logic_vector(7 downto 0);
    s_axis_tdata     : in std_logic_vector(AXIS_DATA_WIDTH-1 downto 0);
    s_axis_tkeep     : in std_logic_vector((AXIS_DATA_WIDTH/8)-1 downto 0);
    s_axis_tlast     : in std_logic; -- not used, eol in AXI stream video protocol
    s_axis_tuser     : in std_logic_vector((AXIS_DATA_WIDTH/8)-1 downto 0); -- not used, sof in AXI stream video protocol on bit0
    s_axis_tvalid    : in std_logic    
        

    );                                                                             
end dmawr_sub4;



architecture functional of dmawr_sub4 is

  component dmawr_sdram_top
    generic (
      SD_WRITEDATA_WIDTH : integer;
      SD_ADDR_WIDTH      : integer; 
      NB_DATA_ACC        : integer := 16;    -- number of data to be accumulated before being evacuated (0 to 32)
      NUMBER_OF_PLANES   : integer := 1;     -- max number of planes
      SI0_DATA_WIDTH     : integer := 64;    -- width of si0_data signal: 64, 128, etc.
  --    SI0_ADDR_WIDTH     : integer := 11;    -- width of si0_addr signal: 11 (for 64-bit data), 10 (for 128-bit data), etc.
      FPGA_ARCH          : string  := "ALTERA";
      FPGA_FAMILY        : string  := "STRATIX"  -- "STRATIX", "STRATIXII"

      );
    port (

      ----------------------------------------------------
      -- Reset, clock and mode signals
      ----------------------------------------------------
      sysrstN           : in  std_logic;
      sysclk            : in  std_logic;
      ----------------------------------------------------
      -- register port (slave)
      ----------------------------------------------------
      LNSIZE            : out integer;
      STARTADDR_lsb     : out integer;
      reg_write         : in  std_logic;
      reg_read          : in  std_logic;
      reg_addr          : in  std_logic_vector(8 downto 3);
      reg_writedata     : in  std_logic_vector(63 downto 0);
      reg_beN           : in  std_logic_vector(7 downto 0);
      reg_readdata      : out std_logic_vector(63 downto 0);
      ----------------------------------------------------
      -- AXI stream input port (slave)
      ----------------------------------------------------
      si0_write         : in  std_logic;
      si0_data          : in  std_logic_vector(SI0_DATA_WIDTH-1 downto 0);
      si0_beN           : in  std_logic_vector(SI0_DATA_WIDTH/8-1 downto 0);
      si0_wait          : out std_logic;
      ----------------------------------------------------
      -- AXI .... SDRAM (master), write only
      ----------------------------------------------------     
      sd_addr           : out std_logic_vector(SD_ADDR_WIDTH-1 downto 0);
      sd_wait           : in  std_logic;
      sd_write          : out std_logic;
      sd_writebeN       : out std_logic_vector(SD_WRITEDATA_WIDTH/8-1 downto 0);
      sd_writesync      : out std_logic_vector(1 downto 0);
      sd_writedata      : out std_logic_vector(SD_WRITEDATA_WIDTH-1 downto 0);
      sd_fifo_threshold : out std_logic;
      ----------------------------------------------------
      -- interrupt events
      ----------------------------------------------------
      LSBOF             : in  std_logic_vector(6 downto 0);
      intevent          : out std_logic

      );
  end component;
  
   component dmawr_axi_burst
   generic(
      AXI_ADDR_WIDTH   : integer;
      AXI_DATA_WIDTH   : integer;
      AXI_BURST_SIZE   : integer;  -- 4 to 32
      AXIS_DATA_WIDTH  : integer
   );
   port (
   
      rstN_in          : in  std_logic;
      clk_in           : in  std_logic;
      LNSIZE           : in  integer;
      STARTADDR_lsb    : in  integer;
      addr_in          : in  std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
      data_in          : in  std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
      threshold_in     : in  std_logic;
      sync_in          : in  std_logic_vector(1 downto 0);
      beN_in           : in  std_logic_vector((AXI_DATA_WIDTH/8)-1 downto 0);
      valid_in         : in  std_logic;
      wait_out         : out std_logic;
      
      -- write data channel signals
      m_axi_awid       : out std_logic_vector(2 downto 0);
      m_axi_awaddr     : out std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
      m_axi_awlen      : out std_logic_vector(7 downto 0);
      m_axi_awsize     : out std_logic_vector(2 downto 0);
      m_axi_awburst    : out std_logic_vector(1 downto 0);
      m_axi_awvalid    : out std_logic;
      m_axi_awready    : in std_logic;
        
      m_axi_wvalid     : out std_logic;
      m_axi_wready     : in  std_logic;     
      m_axi_wdata      : out std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
      m_axi_wstrb      : out std_logic_vector((AXI_DATA_WIDTH/8)-1 downto 0); --This signal indicates which byte lanes to update in memory.
      m_axi_wlast      : out std_logic;
        
      -- write response channel signal
      m_axi_bid        : in std_logic_vector(2 downto 0);
      m_axi_bresp      : in std_logic_vector(1 downto 0);
      m_axi_bvalid     : in std_logic;
      m_axi_bready     : out std_logic
   
   );
   end component dmawr_axi_burst;
  
  function Log2 (x : integer) return std_logic_vector is
      variable i : integer range 0 to 7;
   begin
      i := 0;  
      while (2**i < x) and i < 7 loop
         i := i + 1;
      end loop;
      return CONV_STD_LOGIC_VECTOR(i,3);
  end function;    

 -- signal si0_addr         : std_logic_vector(10 downto 0);
  signal si0_beN           : std_logic_vector(AXIS_DATA_WIDTH/8 -1 downto 0);
  signal si0_wait          : std_logic;
                           
  --sdram                  
  signal sd_wait           : std_logic;  
  signal sd_wait_ff        : std_logic;
  signal sd_addr           : std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
  signal sd_write          : std_logic;
  signal sd_writebeN       : std_logic_vector(AXI_DATA_WIDTH/8-1 downto 0);
  signal sd_writesync      : std_logic_vector(1 downto 0);
  signal sd_writedata      : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
  signal sd_fifo_threshold : std_logic;
  
  signal reg_read          : std_logic;
  signal reg_write         : std_logic;
  signal reg_addr          : std_logic_vector(8 downto 0);
  signal reg_readdata      : std_logic_vector(63 downto 0);
  signal reg_writedata     : std_logic_vector(63 downto 0);
  signal reg_beN           : std_logic_vector(7 downto 0);  
  signal axi_rvalid        : std_logic;
  
  signal axi_awvalid       : std_logic;
  signal axi_wvalid        : std_logic;
  signal axi_awready_ff    : std_logic;
  signal axi_wready_ff     : std_logic;
  
  signal LNSIZE            : integer;
  signal STARTADDR_lsb     : integer;
  
begin

---------------------------------------------------------------------------
-- Register - AXI4-LITE interface
--   *** assume Read and Write requests cannot arrive at the same time...
---------------------------------------------------------------------------

-- write address channel
s_axi_awready <= '1';
-- write data channel
s_axi_wready  <= '1';
-- write response channel
s_axi_bresp   <= (others => '0');
-- read address channel
s_axi_arready <= '1';
-- read data channel
s_axi_rdata   <= reg_readdata;
s_axi_rresp   <= (others => '0');
s_axi_rvalid  <= axi_rvalid;

process(sysclk, sysrstN)
begin
   if sysrstN = '0' then
      reg_addr        <= (others => '0'); 
      reg_writedata   <= (others => '0');
      reg_beN         <= (others => '1');     
      reg_write       <= '0';           
      axi_rvalid      <= '0';
      reg_read        <= '0';
      s_axi_bvalid    <= '0';
   elsif rising_edge(sysclk) then

      if s_axi_arvalid = '1' then
         reg_addr <= s_axi_araddr;
      elsif s_axi_awvalid = '1' then      
         reg_addr <= s_axi_awaddr;      
      end if;
   
      -- send write request
      reg_writedata   <= s_axi_wdata;
      reg_beN         <= not s_axi_wstrb;  
      reg_write       <= s_axi_wvalid;  
      
      -- write response channel
      if s_axi_wvalid = '1' then
         s_axi_bvalid <=  '1';
      elsif s_axi_bready = '1' then                 
         s_axi_bvalid <= '0';
      end if;
      
      -- send read request
      if s_axi_arvalid = '1' then
         reg_read <= '1';   
      elsif s_axi_rready = '1' and axi_rvalid = '1' then
         -- release read request when data was accepted on the read data channel
         reg_read <= '0';   
      end if;

      -- read data channel
      if s_axi_rready = '1' and axi_rvalid = '1' then                 
         -- release valid when data was accepted on the read data channel
         axi_rvalid <= '0';
      elsif reg_read = '1' then
         axi_rvalid <=  '1';
      end if;
                  
   end if;
end process;
  
  
  --------------------------------------
  -- AXI stream interface 
  ---------------------------------------
  --si0_addr      <= s_axis_tdest(1 downto 0) & "000000000";
 -- si0_addr      <= (others => '0');  -- not used
  si0_beN       <= not s_axis_tkeep; 
  
  s_axis_tready <= not si0_wait;
  
  
  ----------------------------------------------------                             
  -- DMA write, FID = 0xC011, subFID = 4, 1 x 512-bit bank                                                       
  ----------------------------------------------------                             
  xdmawr_sdram_top : dmawr_sdram_top
    generic map(

      SD_WRITEDATA_WIDTH => AXI_DATA_WIDTH,
      SD_ADDR_WIDTH      => AXI_ADDR_WIDTH,
      NB_DATA_ACC        => NB_DATA_ACC,     -- number of data to be accumulated before being evacuated (0 to 32)
      NUMBER_OF_PLANES   => 1,
      SI0_DATA_WIDTH     => AXIS_DATA_WIDTH,
  --    SI0_ADDR_WIDTH     => 11,
      FPGA_ARCH          => "XILINX_KU",
      FPGA_FAMILY        => "STRATIXV"


      )
    port map(

      sysrstN           => sysrstN,
      sysclk            => sysclk,
      LSBOF             => (others => '0'),--LSBOF,
      LNSIZE            => LNSIZE,
      STARTADDR_lsb     => STARTADDR_lsb,
      intevent          => intevent,
      reg_write         => reg_write,
      reg_read          => reg_read,
      reg_addr          => reg_addr(8 downto 3),
      reg_writedata     => reg_writedata,
      reg_beN           => reg_beN,
      reg_readdata      => reg_readdata,
      si0_write         => s_axis_tvalid,
    --  si0_addr      => si0_addr,
      si0_data          => s_axis_tdata,
      si0_beN           => si0_beN,
      si0_wait          => si0_wait,
      sd_addr           => sd_addr,
      sd_wait           => sd_wait,
      sd_write          => sd_write,
      sd_writebeN       => sd_writebeN,
      sd_writesync      => sd_writesync,
      sd_writedata      => sd_writedata,
      sd_fifo_threshold => sd_fifo_threshold

      );                               

   xdmawr_axi_burst: dmawr_axi_burst
   generic map(
      AXI_ADDR_WIDTH   => AXI_ADDR_WIDTH,
      AXI_DATA_WIDTH   => AXI_DATA_WIDTH,
      AXI_BURST_SIZE   => AXI_BURST_SIZE,
      AXIS_DATA_WIDTH  => AXIS_DATA_WIDTH
   )
   port map(
   
      rstN_in          => sysrstN,
      clk_in           => sysclk,
      LNSIZE           => LNSIZE,
      STARTADDR_lsb    => STARTADDR_lsb,
      addr_in          => sd_addr,
      data_in          => sd_writedata,
      threshold_in     => sd_fifo_threshold,
      sync_in          => sd_writesync,
      beN_in           => sd_writebeN,
      valid_in         => sd_write,
      wait_out         => sd_wait,
      
      -- write data channel signals
      m_axi_awid       => m_axi_awid,   
      m_axi_awaddr     => m_axi_awaddr, 
      m_axi_awlen      => m_axi_awlen,  
      m_axi_awsize     => m_axi_awsize, 
      m_axi_awburst    => m_axi_awburst,
      m_axi_awvalid    => m_axi_awvalid,
      m_axi_awready    => m_axi_awready,
        
      m_axi_wvalid     => m_axi_wvalid,
      m_axi_wready     => m_axi_wready,
      m_axi_wdata      => m_axi_wdata, 
      m_axi_wstrb      => m_axi_wstrb, 
      m_axi_wlast      => m_axi_wlast, 
        
      -- write response channel signal
      m_axi_bid        => m_axi_bid,  -- not used
      m_axi_bresp      => m_axi_bresp, 
      m_axi_bvalid     => m_axi_bvalid,
      m_axi_bready     => m_axi_bready
   
   );


end functional;
