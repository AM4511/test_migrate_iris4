library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- TITI CACA
entity AxiSlave2Reg is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line

		-- Width of S_AXI data bus
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		-- Width of S_AXI address bus
		C_S_AXI_ADDR_WIDTH	: integer	:= 12
	);
	port (
		-- Users to add ports here
        ---------------------------------------------------------------------------
        -- FDK IDE registerfile interface
        ---------------------------------------------------------------------------
        reg_read          : out std_logic;
        reg_write         : out std_logic;
        reg_addr          : out std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 2);
        reg_beN           : out std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
        reg_writedata     : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        reg_readdataValid : in  std_logic;
        reg_readdata      : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);

		-- User ports ends
		-- Do not modify the ports beyond this line

		-- Global Clock Signal
		S_AXI_ACLK	: in std_logic;
		-- Global Reset Signal. This Signal is Active LOW
		S_AXI_ARESETN	: in std_logic;
		-- Write address (issued by master, acceped by Slave)
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		-- Write address valid. This signal indicates that the master signaling
    		-- valid write address and control information.
		S_AXI_AWVALID	: in std_logic;
		-- Write address ready. This signal indicates that the slave is ready
    		-- to accept an address and associated control signals.
		S_AXI_AWREADY	: out std_logic;
		-- Write data (issued by master, acceped by Slave) 
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		-- Write strobes. This signal indicates which byte lanes hold
    		-- valid data. There is one write strobe bit for each eight
    		-- bits of the write data bus.    
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		-- Write valid. This signal indicates that valid write
    		-- data and strobes are available.
		S_AXI_WVALID	: in std_logic;
		-- Write ready. This signal indicates that the slave
    		-- can accept the write data.
		S_AXI_WREADY	: out std_logic;
		-- Write response. This signal indicates the status
    		-- of the write transaction.
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		-- Write response valid. This signal indicates that the channel
    		-- is signaling a valid write response.
		S_AXI_BVALID	: out std_logic;
		-- Response ready. This signal indicates that the master
    		-- can accept a write response.
		S_AXI_BREADY	: in std_logic;
		-- Read address (issued by master, acceped by Slave)
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		-- Protection type. This signal indicates the privilege
    		-- and security level of the transaction, and whether the
    		-- transaction is a data access or an instruction access.
		--S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		-- Read address valid. This signal indicates that the channel
    		-- is signaling valid read address and control information.
		S_AXI_ARVALID	: in std_logic;
		-- Read address ready. This signal indicates that the slave is
    		-- ready to accept an address and associated control signals.
		S_AXI_ARREADY	: out std_logic;
		-- Read data (issued by slave)
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		-- Read response. This signal indicates the status of the
    		-- read transfer.
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		-- Read valid. This signal indicates that the channel is
    		-- signaling the required read data.
		S_AXI_RVALID	: out std_logic;
		-- Read ready. This signal indicates that the master can
    		-- accept the read data and response information.
		S_AXI_RREADY	: in std_logic
	);
end AxiSlave2Reg;

architecture arch_imp of AxiSlave2Reg is

  type T_FSM_STATE is (S_RESET,
                       S_IDLE,
                       S_WAIT_WRITEDATA,
                       S_BRESP,
                       S_RADDR,
                       S_RRESP
                       );

  signal state    : T_FSM_STATE := S_IDLE;
  signal nxtState : T_FSM_STATE := S_IDLE;

  signal axi_awready_ff : std_logic;
  signal axi_wready_ff  : std_logic;
  signal axi_bvalid_ff  : std_logic;
  signal axi_arready_ff : std_logic;
  signal axi_rvalid_ff  : std_logic;
  signal axi_rdata_ff   : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);

  signal axi_aw_ack    : std_logic;
  signal axi_w_ack     : std_logic;
  signal axi_b_ack     : std_logic;
  signal axi_ar_ack    : std_logic;
  signal axi_r_ack     : std_logic;
    
  signal reg_addr_int  : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 2);
  
begin

   S_AXI_BRESP   <= "00";
   S_AXI_RRESP   <= "00";
   
   S_AXI_AWREADY <= axi_awready_ff;
   S_AXI_WREADY  <= axi_wready_ff;
   S_AXI_BVALID  <= axi_bvalid_ff;
   S_AXI_ARREADY <= axi_arready_ff;
   S_AXI_RVALID  <= axi_rvalid_ff;
   S_AXI_RDATA   <= axi_rdata_ff;

   axi_aw_ack    <= S_AXI_AWVALID and axi_awready_ff;
   axi_w_ack     <= S_AXI_WVALID  and axi_wready_ff;
   axi_b_ack     <= S_AXI_BREADY  and axi_bvalid_ff;
   axi_ar_ack    <= S_AXI_ARVALID and axi_arready_ff;
   axi_r_ack     <= S_AXI_RREADY  and axi_rvalid_ff;
   
   reg_addr      <= reg_addr_int;
      
   p_nxtState : process(state, S_AXI_AWVALID, axi_wready_ff, S_AXI_WVALID, S_AXI_ARVALID, S_AXI_BREADY, axi_bvalid_ff, axi_rvalid_ff, S_AXI_RREADY)
   begin
 
     case state is
       -------------------------------------------------------------------------
       -- State       : S_RESET
       -- Description : Reset State
       -------------------------------------------------------------------------
       when S_RESET =>
         nxtState <= S_IDLE;
 
       -------------------------------------------------------------------------
       -- State       : S_IDLE
       -- Description : The parking state. We wait for the next transaction from
       -- the host
       -------------------------------------------------------------------------
       when S_IDLE =>
         -----------------------------------------------------------------------
         -- AXI Write transaction
         -----------------------------------------------------------------------
         if (S_AXI_AWVALID = '1') then
             nxtState <= S_WAIT_WRITEDATA;
 
         -----------------------------------------------------------------------
         -- AXI Read transaction
         -----------------------------------------------------------------------
         elsif (S_AXI_ARVALID = '1') then
           nxtState <= S_RADDR;
         else
           nxtState <= S_IDLE;
         end if;
 
       -------------------------------------------------------------------------
       -- State       : S_WAIT_WRITEDATA
       -- Description : Wait state. We wait for the data arrival in this state
       -------------------------------------------------------------------------
       when S_WAIT_WRITEDATA =>
         if (axi_wready_ff = '1' and S_AXI_WVALID = '1') then
           -- We received the write data
           nxtState <= S_BRESP;
         else
           -- Still waiting for the write data
           nxtState <= S_WAIT_WRITEDATA;
         end if;
 
       -------------------------------------------------------------------------
       -- State       : S_BRESP
       -- Description : Write transaction response
       -------------------------------------------------------------------------
       when S_BRESP =>
         if (S_AXI_BREADY = '1' and axi_bvalid_ff = '1') then
           nxtState <= S_IDLE;
         else
           nxtState <= S_BRESP;
         end if;
 
       -------------------------------------------------------------------------
       -- State       : S_RADDR
       -- Description : Read transaction 
       -------------------------------------------------------------------------
       when S_RADDR =>
         nxtState <= S_RRESP;
 
       -------------------------------------------------------------------------
       -- State       : S_RRESP
       -- Description : Read transaction response
       -------------------------------------------------------------------------
       when S_RRESP =>
         if (axi_rvalid_ff = '1' and S_AXI_RREADY = '1') then
           nxtState <= S_IDLE;
         else
           nxtState <= S_RRESP;
         end if;
 
     end case;
   end process p_nxtState;
 
   -----------------------------------------------------------------------------
   -- Implement state machine
   -----------------------------------------------------------------------------
   p_state : process (S_AXI_ARESETN, S_AXI_ACLK)
   begin
      if (S_AXI_ARESETN = '0') then
         state <= S_RESET;
      elsif (rising_edge(S_AXI_ACLK)) then
         state <= nxtState;
      end if;
   end process p_state;
  
   -----------------------------------------------------------------------------
   -- Implement axi_awready_ff generation
   -- axi_awready_ff is asserted for one S_AXI_ACLK clock cycle when both
   -- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready_ff is
   -- de-asserted when reset is low.
   -----------------------------------------------------------------------------
   p_axi_awready_ff : process (S_AXI_ARESETN, S_AXI_ACLK)
   begin
      if (S_AXI_ARESETN = '0') then
         axi_awready_ff <= '0';
      elsif (rising_edge(S_AXI_ACLK)) then
         if (axi_awready_ff = '1' and S_AXI_AWVALID = '1') then
            axi_awready_ff <= '0';
         elsif (nxtState = S_WAIT_WRITEDATA) then
            axi_awready_ff <= '1';
         else
            axi_awready_ff <= axi_awready_ff;
         end if;
      end if;
   end process p_axi_awready_ff;
   
   
   -----------------------------------------------------------------------------
   -- Implement axi_wready_ff generation
   -- axi_wready_ff is asserted for one S_AXI_ACLK clock cycle when both
   -- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready_ff is 
   -- de-asserted when reset is low. 
   -----------------------------------------------------------------------------
   p_axi_wready_ff : process (S_AXI_ARESETN, S_AXI_ACLK)
   begin
      if (S_AXI_ARESETN = '0') then
         axi_wready_ff <= '0';
      elsif (rising_edge(S_AXI_ACLK)) then
         if (axi_wready_ff = '1' and S_AXI_WVALID = '1') then
            axi_wready_ff <= '0';
         elsif (nxtState = S_WAIT_WRITEDATA) then
           -- On accepte le data des qu'on a l'adresse        
            axi_wready_ff <= '1';
         else  
            axi_wready_ff <= axi_wready_ff;
         end if;
      end if;
   end process p_axi_wready_ff;
  
   -----------------------------------------------------------------------------
   -- 
   -----------------------------------------------------------------------------
   p_axi_bvalid_ff : process (S_AXI_ARESETN, S_AXI_ACLK)
   begin
      if (S_AXI_ARESETN = '0') then
         axi_bvalid_ff <= '0';
      elsif (rising_edge(S_AXI_ACLK)) then
         if (nxtState = S_BRESP) then
            axi_bvalid_ff <= '1';
         else
            axi_bvalid_ff <= '0';
         end if;
      end if;
   end process p_axi_bvalid_ff;
 
   -----------------------------------------------------------------------------
   -- Implement axi_arready_ff generation
   -- axi_arready_ff is asserted for one S_AXI_ACLK clock cycle when
   -- S_AXI_ARVALID is asserted. axi_arready_ff is 
   -- de-asserted when reset is low. 
   ----------------------------------------------------------------------------- 
   p_axi_arready_ff : process (S_AXI_ARESETN, S_AXI_ACLK)
   begin
      if (S_AXI_ARESETN = '0') then
         axi_arready_ff <= '0';
      elsif (rising_edge(S_AXI_ACLK)) then
         if (axi_arready_ff = '1') then
           axi_arready_ff <= '0';
         elsif (S_AXI_ARVALID = '1') then
           axi_arready_ff <= '1';
         else
           axi_arready_ff <= axi_arready_ff;
         end if;
     end if;
   end process p_axi_arready_ff;
 
 
   p_axi_rvalid_ff : process (S_AXI_ARESETN, S_AXI_ACLK)
   begin
      if (S_AXI_ARESETN = '0') then
         axi_rvalid_ff <= '0';
      elsif rising_edge(S_AXI_ACLK) then
         if (nxtState = S_RRESP and reg_readdataValid = '1') then
            axi_rvalid_ff <= '1';
         elsif (axi_rvalid_ff = '1' and S_AXI_RREADY = '1') then
            axi_rvalid_ff <= '0';
         end if;
     end if;
   end process p_axi_rvalid_ff;
 
   p_axi_rdata : process(S_AXI_ARESETN, S_AXI_ACLK)
   begin
      if (S_AXI_ARESETN = '0') then
         axi_rdata_ff <= (others=>'0');
      elsif (rising_edge (S_AXI_ACLK)) then
         if (nxtState = S_RRESP and reg_readdataValid = '1') then
            axi_rdata_ff <= reg_readdata;
         else  
            axi_rdata_ff <= axi_rdata_ff;
         end if;
      end if;
   end process p_axi_rdata;
  
   -----------------------------------------------------------------------------
   -- 
   -----------------------------------------------------------------------------
   p_reg_addr : process(S_AXI_ARESETN, S_AXI_ACLK)
   begin
      if (S_AXI_ARESETN = '0') then
         reg_addr_int <= (others=>'0');
      elsif (rising_edge (S_AXI_ACLK)) then
         if (S_AXI_AWVALID = '1') then
            reg_addr_int <= S_AXI_AWADDR(S_AXI_AWADDR'high downto 2); -- on flush les 2 LSB car on est en 32 bits, alors il devraient etre non-significatif (ou toujours 0).
         elsif (S_AXI_ARVALID = '1') then
            reg_addr_int <= S_AXI_ARADDR(S_AXI_AWADDR'high downto 2); -- on flush les 2 LSB car on est en 32 bits, alors il devraient etre non-significatif (ou toujours 0).
         else   
            reg_addr_int <= reg_addr_int;
         end if;
     end if;
   end process p_reg_addr;
 
 
   p_reg_write : process(S_AXI_ARESETN, S_AXI_ACLK)
   begin
       if (S_AXI_ARESETN = '0') then
         reg_write <= '0';
       elsif (rising_edge (S_AXI_ACLK)) then
          if (axi_w_ack = '1') then -- actif quand on ramasse le data a ecrire, donc un seul coup de clock!
            reg_write <= '1';
          else
            reg_write <= '0';
          end if;
     end if;
   end process p_reg_write;
 
 
   p_reg_writedata : process (S_AXI_ARESETN, S_AXI_ACLK)
   begin
       if (S_AXI_ARESETN = '0') then
          reg_beN       <= (others=>'0');
          reg_writedata <= (others=>'0');
       elsif rising_edge(S_AXI_ACLK) then
          if (S_AXI_WVALID = '1' and axi_wready_ff = '1') then
             reg_beN       <= not S_AXI_WSTRB;
             reg_writedata <= S_AXI_WDATA;
          else  
             reg_beN       <= (others=>'0');
             reg_writedata <= (others=>'0');
          end if;
     end if;
   end process p_reg_writedata;
 
 
   p_reg_read : process(S_AXI_ARESETN, S_AXI_ACLK)
   begin
      if (S_AXI_ARESETN = '0') then
         reg_read <= '0';
      elsif (rising_edge (S_AXI_ACLK)) then
         if (nxtState = S_RADDR) then
            reg_read <= '1';
         else
            reg_read <= '0';
         end if;
     end if;
   end process p_reg_read;
 

end arch_imp;
