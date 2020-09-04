-----------------------------------------------------------------------
--
-- DESCRIPTION: 
--
-- Arbitre simple, pour usage general.
-- 
-- Version 2 Requesters qui veulent acceder a la meme ressource (ex. I2C : Driver et Bios), ce petit arbitre
-- fait la gestion des access.
--
-- Chaque requester a un registre, qui contient les fields  REQ/REC/ACK/DONE
--
-- REQ  : INPUT  write-only register : Demande l'access a une ressource
-- REC  : OUTPUT read-only register  : Informe que la demande a la ressource a ete recue
-- ACK  : OUTPUT read-only register  : Informe que la demande a la ressource a ete accordee
-- DONE : INPUT  write-only register : Libere la ressource apres avoir terminee l'operation
--
-----------------------------------------------------------------------
library ieee;
 use ieee.std_logic_1164.all;
 use IEEE.std_logic_unsigned.all;
 use IEEE.numeric_std.all;
 use IEEE.std_logic_arith.all;
 use std.textio.all ; 
 
library work;
  

entity arbiter is
   port(

    ---------------------------------------------------------------------
    -- Sys domain reset and clock signals (regfile domain)
    ---------------------------------------------------------------------
	-- Ports of Axi Slave Bus Interface S00_AXI
	axi_clk	    : in std_logic;
	axi_reset_n	: in std_logic;
	
	---------------------------------------------------------------------
    -- Regsiters
    ---------------------------------------------------------------------
    AGENT_REQ                            : in    std_logic_vector(1 downto 0);  -- Write-Only register
    AGENT_REC                            : out   std_logic_vector(1 downto 0);  -- Read-Only register
    AGENT_ACK                            : out   std_logic_vector(1 downto 0);  -- Read-Only register
    AGENT_DONE                           : in    std_logic_vector(1 downto 0)   -- Write-Only register

  );
  
end arbiter;


architecture functional of arbiter is


type ARBITER_FSM_TYPE is (IDLE, REQ_0_SEQ, WAIT_REQ0_END, REQ_1_SEQ, WAIT_REQ1_END);
signal arb_state : ARBITER_FSM_TYPE;
  
  

begin
  
  
  ---------------------------------------------------------------------
  -- STATE MACHINE
  ---------------------------------------------------------------------
  process (axi_clk) is
  begin
    if (rising_edge(axi_clk)) then
      if (axi_reset_n = '0') then
        arb_state         <= IDLE;
        AGENT_REC(0)      <= '0';
        AGENT_ACK(0)      <= '0';
        AGENT_REC(1)      <= '0';
        AGENT_ACK(1)      <= '0';  
      else
        case arb_state is
  
          ---------------------------------------------------------------------
          -- IDLE : AGENT_REQ(0) et AGENT_REQ(1) ne seront jamais '1' simultanement
		  --        alors premier arrive, premier servi
          ---------------------------------------------------------------------
          when IDLE =>
            if (AGENT_REQ(0) = '1') then
              arb_state         <= REQ_0_SEQ;
              AGENT_REC(0)      <= '1';
              AGENT_ACK(0)      <= '1';
              AGENT_REC(1)      <= '0';
              AGENT_ACK(1)      <= '0';	  
            elsif (AGENT_REQ(1) = '1') then
              arb_state         <= REQ_1_SEQ;
              AGENT_REC(0)      <= '0';
              AGENT_ACK(0)      <= '0';
              AGENT_REC(1)      <= '1';
              AGENT_ACK(1)      <= '1';	  	
            else
              arb_state         <= IDLE;
              AGENT_REC(0)      <= '0';
              AGENT_ACK(0)      <= '0';
              AGENT_REC(1)      <= '0';
              AGENT_ACK(1)      <= '0';	  
            end if;
  
          ---------------------------------------------------------------------
          -- REQ_0_SEQ : 
          ---------------------------------------------------------------------
          when REQ_0_SEQ =>
            if (AGENT_REQ(1) = '1' and AGENT_DONE(0) = '1') then
              arb_state         <= REQ_1_SEQ;
              AGENT_REC(0)      <= '0';
              AGENT_ACK(0)      <= '0';
              AGENT_REC(1)      <= '1';
              AGENT_ACK(1)      <= '1';	  
            elsif(AGENT_DONE(0) = '1') then
              arb_state         <= IDLE;
              AGENT_REC(0)      <= '0';
              AGENT_ACK(0)      <= '0';
              AGENT_REC(1)      <= '0';
              AGENT_ACK(1)      <= '0';	  
            elsif(AGENT_REQ(1) = '1') then
              arb_state         <= WAIT_REQ0_END;
              AGENT_REC(0)      <= '1';
              AGENT_ACK(0)      <= '1';
              AGENT_REC(1)      <= '1';
              AGENT_ACK(1)      <= '0';	  
            else		    
              arb_state         <= REQ_0_SEQ;
              AGENT_REC(0)      <= '1';
              AGENT_ACK(0)      <= '1';
              AGENT_REC(1)      <= '0';
              AGENT_ACK(1)      <= '0'; 
            end if;

          ---------------------------------------------------------------------
          -- WAIT_REQ0_END :  : REQ_1 pending
          ---------------------------------------------------------------------
          when WAIT_REQ0_END =>
		    if (AGENT_DONE(1)= '1') then       --aborted REQ
              arb_state         <= REQ_0_SEQ;
              AGENT_REC(0)      <= '1';
              AGENT_ACK(0)      <= '1';
              AGENT_REC(1)      <= '0';
              AGENT_ACK(1)      <= '0';	              
            elsif (AGENT_DONE(0)= '1') then
              arb_state         <= REQ_1_SEQ;
              AGENT_REC(0)      <= '0';
              AGENT_ACK(0)      <= '0';
              AGENT_REC(1)      <= '1';
              AGENT_ACK(1)      <= '1'; 
            else
              arb_state         <= WAIT_REQ0_END;
              AGENT_REC(0)      <= '1';
              AGENT_ACK(0)      <= '1';
              AGENT_REC(1)      <= '1';
              AGENT_ACK(1)      <= '0'; 
            end if;		  

          ---------------------------------------------------------------------
          -- REQ_1_SEQ : 
          ---------------------------------------------------------------------
          when REQ_1_SEQ =>
            if (AGENT_REQ(0) = '1' and AGENT_DONE(1) = '1') then
              arb_state         <= REQ_0_SEQ;
              AGENT_REC(0)      <= '1';
              AGENT_ACK(0)      <= '1';
              AGENT_REC(1)      <= '0';
              AGENT_ACK(1)      <= '0'; 
            elsif(AGENT_DONE(1) = '1') then
              arb_state         <= IDLE;
              AGENT_REC(0)      <= '0';
              AGENT_ACK(0)      <= '0';
              AGENT_REC(1)      <= '0';
              AGENT_ACK(1)      <= '0'; 
            elsif(AGENT_REQ(0) = '1') then
              arb_state         <= WAIT_REQ1_END;
              AGENT_REC(0)      <= '1';
              AGENT_ACK(0)      <= '0';
              AGENT_REC(1)      <= '1';
              AGENT_ACK(1)      <= '1';
            else
              arb_state         <= REQ_1_SEQ;
              AGENT_REC(0)      <= '0';
              AGENT_ACK(0)      <= '0';
              AGENT_REC(1)      <= '1';
              AGENT_ACK(1)      <= '1'; 
            end if;

          ---------------------------------------------------------------------
          -- WAIT_REQ1_END : REQ_0 pending
          ---------------------------------------------------------------------
          when WAIT_REQ1_END =>
            if (AGENT_DONE(0)= '1') then       --aborted REQ
              arb_state         <= REQ_1_SEQ;
              AGENT_REC(0)      <= '0';
              AGENT_ACK(0)      <= '0';
              AGENT_REC(1)      <= '1';
              AGENT_ACK(1)      <= '1';	              
			elsif (AGENT_DONE(1) = '1') then
              arb_state         <= REQ_0_SEQ;
              AGENT_REC(0)      <= '1';
              AGENT_ACK(0)      <= '1';
              AGENT_REC(1)      <= '0';
              AGENT_ACK(1)      <= '0'; 
            else
              arb_state         <= WAIT_REQ1_END;
              AGENT_REC(0)      <= '1';
              AGENT_ACK(0)      <= '0';
              AGENT_REC(1)      <= '1';
              AGENT_ACK(1)      <= '1';
            end if; 

        end case;
      end if;
    end if;
  end process;

end functional ;