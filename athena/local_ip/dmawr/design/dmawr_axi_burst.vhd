-----------------------------------------------------------------------          
--                                                                               
-- FILE        : dmawr_axi_burst.vhd                                                  
--                                                                               
-- ENTITY      : dmawr_axi_burst
--               
-- DESCRIPTION : combines single writes into bursts on the AXI4 bus
--
-- Author      : JDesilet
----------------------------------------------------------------------           

library ieee;
  use ieee.std_logic_1164.all;  
  use ieee.numeric_std.all;
  --use ieee.std_logic_arith.all;
  

entity dmawr_axi_burst is
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
end entity dmawr_axi_burst;


architecture functional of dmawr_axi_burst is

   -- State machine for requests to CLHS Core
   type REQSTATE_TYPE is (
      S_IDLE,
      S_LOAD,
      S_SEND_DATA,
   --   S_WAIT_BVALID,
      S_WAIT_DATA
   );
   
   function Log2 (x : integer) return integer is--std_logic_vector is
      variable i : integer range 0 to 7;
   begin
      i := 0;  
      while (2**i < x) and i < 7 loop
         i := i + 1;
      end loop;
      return i;--STD_LOGIC_VECTOR(to_unsigned(i,3));
   end function; 
   
   type ARRAY_OF_SLV_AXI_DATA  is array (integer range <>) of std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
   type ARRAY_OF_SLV_AXI_BEN   is array (integer range <>) of std_logic_vector(AXI_DATA_WIDTH/8-1 downto 0);
   
  
   signal curr_state         : REQSTATE_TYPE := S_IDLE; 
  
   signal m_axi_awlen_sig    : std_logic_vector(Log2(AXI_BURST_SIZE-1)-1 downto 0);
   signal data_to_send_burst : integer;
   signal data_to_send_line  : integer;
   
   signal m_axi_awvalid_sig  : std_logic;
   signal m_axi_wvalid_sig   : std_logic;
   signal m_axi_wlast_sig    : std_logic;
   
begin

   p_curr_state: process(clk_in, rstN_in)
   begin
      if (rstN_in = '0') then
         curr_state <= S_IDLE;
      elsif rising_edge(clk_in) then
      
         case curr_state is
         ------------------------------
         when S_IDLE =>
         -- In this state, we wait for threshold of fifo (min of request = burst is ready to be output) from ram_write_core module
         ------------------------------
            --if (valid_in = '1' and sync_in /= "11") then
            if (threshold_in = '1') then-- and not(sync_in = "11" and valid_in = '1')) then 
               curr_state <= S_LOAD;
            end if;

         ------------------------------            
         when S_LOAD =>
         -- In this state, we accept one data and address
         ------------------------------
            if (valid_in = '1') then
               if (sync_in /= "11") then
                  curr_state <= S_SEND_DATA;
               else
                  curr_state <= S_IDLE;
               end if;
            end if;
           
         ------------------------------
         when S_SEND_DATA =>
         -- In this state, we send the adresse and bursts of data and
         -- we wait for the wready which confirms that the data has been accepted         
         ------------------------------
            if (data_to_send_burst = 0 and m_axi_wready = '1') then
               --curr_state <= S_WAIT_BVALID;
               if (threshold_in = '1') then-- and not(sync_in = "11" and valid_in = '1')) then 
                  curr_state <= S_LOAD;
               else
                  curr_state <= S_WAIT_DATA;--S_IDLE;
               end if;
            end if;
            
    --     ------------------------------
    --     when S_WAIT_BVALID =>
    --     -- This state sets the nb of data to send (max is 4, but if less, adjust awlen) and waits
    --     -- for the bvalid (slave response from the previous write)
    --     ------------------------------
    --        if (m_axi_bvalid = '1') then
    --           if (threshold_in = '1') then-- and not(sync_in = "11" and valid_in = '1')) then 
    --              curr_state <= S_LOAD;
    --           else
    --              curr_state <= S_WAIT_DATA;--S_IDLE;
    --           end if;
    --        end if;
            
         ------------------------------
         when S_WAIT_DATA =>
         -- This state waits for the data threshold to start reading it
         ------------------------------            
            if (sync_in = "11" and valid_in = '1') or (threshold_in = '1')then
               curr_state <= S_LOAD;           
            end if;

         end case;            
      end if;  
   end process p_curr_state;
   
   process(clk_in) 
   begin
      if (rising_edge(clk_in)) then
         if (curr_state = S_LOAD) then -- or curr_state = S_WAIT_BVALID) then
            m_axi_awaddr <= addr_in;
         end if;
      end if;
   end process;
     
   process(clk_in) 
   begin
      if (rising_edge(clk_in)) then
         if (curr_state = S_LOAD and valid_in = '1' and sync_in /= "11" ) then-- and m_axi_awready = '1' and m_axi_wready = '1') then
            m_axi_awvalid_sig <= '1';
         else
            if (m_axi_awvalid_sig = '1' and m_axi_awready = '1') or curr_state = S_IDLE then
              m_axi_awvalid_sig <= '0';
            end if;
         end if;
      end if;
   end process;
   
   -- send the address for the next request when 4 data are ready or 1 to 3 data are ready and we are receiving a new line 
   -- so we need to send end-of-line data separately from start-of-line data, because they may not be consecutive in memory!
   -- Also at the end of frame, we need to output remaining data whatever the nb of data.
 --  data_ready_to_send <= (data_received = AXI_BURST_SIZE or 
 --                        (data_received /= 0 and data_received /= AXI_BURST_SIZE and (sync_in = "01" or sync_in = "11")));
   
   m_axi_awvalid <= m_axi_awvalid_sig;
   
   process(clk_in) 
   begin
      if (rising_edge(clk_in)) then
      
            -- send 1st data
         if (curr_state = S_LOAD and valid_in = '1' and sync_in /= "11" ) or-- and m_axi_awready = '1' and m_axi_awvalid_sig = '1') or
            -- send 2nd data if data_to_send is 2+                                    
            (curr_state = S_SEND_DATA and data_to_send_burst > 0) then 
            m_axi_wvalid_sig <= '1';
         else
            if (m_axi_wvalid_sig = '1' and m_axi_wready = '1') or curr_state = S_IDLE then
              m_axi_wvalid_sig <= '0';
            end if;
         end if;
      end if;
   end process;
   
   m_axi_wvalid <= m_axi_wvalid_sig;
   
   process(clk_in)
   begin
      if rising_edge(clk_in) then
         if curr_state = S_LOAD or (curr_state = S_SEND_DATA and m_axi_wvalid_sig = '1' and m_axi_wready = '1') then
            m_axi_wdata <= data_in;
            m_axi_wstrb <= not beN_in;
         end if;
      end if;
   end process;
   
   process(clk_in, rstN_in)
   begin
      if (rstN_in = '0') then
         data_to_send_line <= 0;
      elsif (rising_edge(clk_in)) then         
         -- reset condition
         if (curr_state = S_IDLE or --and sync_in(1) = '0') or 
             -- prepare for next beginning of line
            (m_axi_awready = '1' and m_axi_awvalid_sig = '1' and data_to_send_line < (AXI_BURST_SIZE+1)))then
            data_to_send_line <= (LNSIZE+STARTADDR_lsb+AXI_DATA_WIDTH/8-1)/(AXI_DATA_WIDTH/8);
         -- decrement condition
         else
           -- if (curr_state = S_SEND_DATA and m_axi_awvalid_sig = '1' and m_axi_awready = '1') then 
            if (m_axi_awready = '1' and m_axi_awvalid_sig = '1' and data_to_send_line > AXI_BURST_SIZE)then
               data_to_send_line <= data_to_send_line - AXI_BURST_SIZE;
            end if;
         end if;
      end if;   
   end process;
   
   process(clk_in, rstN_in)
   begin
      if (rstN_in = '0') then
         data_to_send_burst <= 0;
      elsif (rising_edge(clk_in)) then         
         -- reset condition
         if (curr_state = S_IDLE or --and sync_in(1) = '0') or 
             -- prepare for next beginning of line
           -- (curr_state = S_WAIT_BVALID and m_axi_awvalid_sig = '0')) then
            (curr_state = S_SEND_DATA and data_to_send_burst = 0 and m_axi_wready = '1')) then
            if (data_to_send_line > (AXI_BURST_SIZE-1))then
               data_to_send_burst <= AXI_BURST_SIZE - 1;
            -- decrement condition
            else           
           -- if (curr_state = S_WAIT_BVALID and m_axi_awvalid_sig = '0' and data_to_send_line < AXI_BURST_SIZE)then
               if (data_to_send_line /= 0) then
                  data_to_send_burst <= data_to_send_line - 1;
               end if;
            end if;
         else
            if (curr_state = S_SEND_DATA and m_axi_wready = '1' and m_axi_wvalid_sig = '1' and data_to_send_burst > 0) then
               data_to_send_burst <= data_to_send_burst - 1;
            end if;
         end if;
      end if;   
   end process;
   
   process(clk_in, rstN_in)
   begin
      if (rstN_in = '0') then
         m_axi_awlen_sig <= (others => '0');
      elsif rising_edge(clk_in) then
         if (curr_state = S_IDLE or curr_state = S_LOAD) then --(curr_state = S_WAIT_BVALID and m_axi_awvalid_sig = '0')) then
            m_axi_awlen_sig <= std_logic_vector(to_unsigned(data_to_send_burst,m_axi_awlen_sig'length));
         end if;
      end if;
   end process;
   
   process(m_axi_awlen_sig)
   begin
      for i in 0 to 7 loop   
         if (i < (m_axi_awlen_sig'left)+1) then
            m_axi_awlen(i) <= m_axi_awlen_sig(i);
         else
            m_axi_awlen(i) <= '0';
         end if;   
      end loop;
   end process;
   
   process(clk_in)
   begin
      if rising_edge(clk_in) then
         if (curr_state = S_SEND_DATA and m_axi_wvalid_sig = '1' and m_axi_wready = '1' and data_to_send_burst = 1) or
            (curr_state = S_LOAD and valid_in = '1' and sync_in /= "11" and data_to_send_burst = 0) then
            m_axi_wlast_sig <= '1';
         else
            if (m_axi_wready = '1' or curr_state = S_IDLE) then
              m_axi_wlast_sig <= '0';
            end if;
         end if;
      end if;
   end process;
   
   m_axi_wlast <= m_axi_wlast_sig;
   
   wait_out <= '0' when (curr_state = S_LOAD) or (curr_state = S_IDLE and sync_in = "11") or
                        (curr_state = S_SEND_DATA and m_axi_wready = '1' and data_to_send_burst /= 0)
                   else '1';
   
  
   m_axi_awid     <=  (others => '0'); 
   m_axi_awsize   <=  std_logic_vector(to_unsigned(Log2(AXI_DATA_WIDTH/8), 3));--"110";-- 64 bytes (maximum number of data bytes 011 =  8 bytes, 100 = 16 bytes, etc)
   m_axi_awburst  <=  "01";            -- burst type INCR
   m_axi_bready   <=  '1';
   
end functional;