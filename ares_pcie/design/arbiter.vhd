-----------------------------------------------------------------------
--
-- DESCRIPTION: 
--
-- Arbitre simple, pour usage général.
-- 
-- Version 2 Requesters qui veulent accéder a la même ressource (ex. I2C : Driver et Bios), ce petit arbitre
-- fait la gestion des accèss.
--
-- Chaque requester a un registre, qui contient les fields  REQ/REC/ACK/DONE
--
-- REQ  : INPUT  write-only register(event)    : Demande l'accèss a une ressource
-- REC  : OUTPUT read-only register(Read Only) : Informe que la demande à la ressource a été reçue
-- ACK  : OUTPUT read-only register(Read Only) : Informe que la demande à la ressource a été accordée
-- DONE : INPUT  write-only register(event)    : Libère la ressource apres avoir terminé l'opération
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
	axi_clk	          : in std_logic;
	axi_reset_n	      : in std_logic;
	
	---------------------------------------------------------------------
    -- Regsiters
    ---------------------------------------------------------------------
    AGENT_REQ         : in    std_logic_vector(1 downto 0);  -- Write-Only register
    AGENT_REC         : out   std_logic_vector(1 downto 0);  -- Read-Only register
    AGENT_ACK         : out   std_logic_vector(1 downto 0);  -- Read-Only register
    AGENT_DONE        : in    std_logic_vector(1 downto 0)   -- Write-Only register

  );
  
end arbiter;


architecture functional of arbiter is


type ARBITER_FSM_TYPE is (IDLE, REQ_0_SEQ, WAIT_REQ0_END, REQ_1_SEQ, WAIT_REQ1_END);
signal arb_state : ARBITER_FSM_TYPE;
  
signal alternate_start : std_logic := '0';  

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
        alternate_start   <= '0';
      else
        case arb_state is
  
          ---------------------------------------------------------------------
          -- IDLE : AGENT_REQ(0) et AGENT_REQ(1) ne seront jamais '1' simultanement
          --        alors premier arrive, premier servi
          ---------------------------------------------------------------------
          when IDLE =>
            if (alternate_start='0') then      -- round robbin
              if (AGENT_REQ(0) = '1') then
                arb_state         <= REQ_0_SEQ;
                AGENT_REC(0)      <= '1';
                AGENT_ACK(0)      <= '1';
                AGENT_REC(1)      <= '0';
                AGENT_ACK(1)      <= '0';
                alternate_start   <= '1';
              elsif (AGENT_REQ(1) = '1')  then
                arb_state         <= REQ_1_SEQ;
                AGENT_REC(0)      <= '0';
                AGENT_ACK(0)      <= '0';
                AGENT_REC(1)      <= '1';
                AGENT_ACK(1)      <= '1';
                alternate_start   <= '0';
              else
                arb_state         <= IDLE;
                AGENT_REC(0)      <= '0';
                AGENT_ACK(0)      <= '0';
                AGENT_REC(1)      <= '0';
                AGENT_ACK(1)      <= '0';  
                alternate_start   <= alternate_start;
              end if;
            else  
              if (AGENT_REQ(1) = '1') then
                arb_state         <= REQ_1_SEQ;
                AGENT_REC(0)      <= '0';
                AGENT_ACK(0)      <= '0';
                AGENT_REC(1)      <= '1';
                AGENT_ACK(1)      <= '1';
                alternate_start   <= '0';
              elsif (AGENT_REQ(0) = '1')  then
                arb_state         <= REQ_0_SEQ;
                AGENT_REC(0)      <= '1';
                AGENT_ACK(0)      <= '1';
                AGENT_REC(1)      <= '0';
                AGENT_ACK(1)      <= '0';
                alternate_start   <= '1';
              else
                arb_state         <= IDLE;
                AGENT_REC(0)      <= '0';
                AGENT_ACK(0)      <= '0';
                AGENT_REC(1)      <= '0';
                AGENT_ACK(1)      <= '0';
                alternate_start   <= alternate_start;
              end if;
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
              alternate_start   <= '0';  
            elsif(AGENT_DONE(0) = '1') then
              arb_state         <= IDLE;
              AGENT_REC(0)      <= '0';
              AGENT_ACK(0)      <= '0';
              AGENT_REC(1)      <= '0';
              AGENT_ACK(1)      <= '0';	  
              alternate_start   <= alternate_start; 
            elsif(AGENT_REQ(1) = '1') then
              arb_state         <= WAIT_REQ0_END;
              AGENT_REC(0)      <= '1';
              AGENT_ACK(0)      <= '1';
              AGENT_REC(1)      <= '1';
              AGENT_ACK(1)      <= '0';	 
              alternate_start   <= '0';
            else    
              arb_state         <= REQ_0_SEQ;
              AGENT_REC(0)      <= '1';
              AGENT_ACK(0)      <= '1';
              AGENT_REC(1)      <= '0';
              AGENT_ACK(1)      <= '0'; 
              alternate_start   <= alternate_start;
  
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
              alternate_start   <= alternate_start;
            elsif (AGENT_DONE(0)= '1') then
              arb_state         <= REQ_1_SEQ;
              AGENT_REC(0)      <= '0';
              AGENT_ACK(0)      <= '0';
              AGENT_REC(1)      <= '1';
              AGENT_ACK(1)      <= '1'; 
              alternate_start   <= alternate_start;
            else
              arb_state         <= WAIT_REQ0_END;
              AGENT_REC(0)      <= '1';
              AGENT_ACK(0)      <= '1';
              AGENT_REC(1)      <= '1';
              AGENT_ACK(1)      <= '0'; 
              alternate_start   <= alternate_start;
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
              alternate_start   <= '1';
            elsif(AGENT_DONE(1) = '1') then
              arb_state         <= IDLE;
              AGENT_REC(0)      <= '0';
              AGENT_ACK(0)      <= '0';
              AGENT_REC(1)      <= '0';
              AGENT_ACK(1)      <= '0'; 
              alternate_start   <= alternate_start;
            elsif(AGENT_REQ(0) = '1') then
              arb_state         <= WAIT_REQ1_END;
              AGENT_REC(0)      <= '1';
              AGENT_ACK(0)      <= '0';
              AGENT_REC(1)      <= '1';
              AGENT_ACK(1)      <= '1';
              alternate_start   <= '1';
            else
              arb_state         <= REQ_1_SEQ;
              AGENT_REC(0)      <= '0';
              AGENT_ACK(0)      <= '0';
              AGENT_REC(1)      <= '1';
              AGENT_ACK(1)      <= '1'; 
              alternate_start   <= alternate_start;
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
              alternate_start   <= alternate_start;
			elsif (AGENT_DONE(1) = '1') then
              arb_state         <= REQ_0_SEQ;
              AGENT_REC(0)      <= '1';
              AGENT_ACK(0)      <= '1';
              AGENT_REC(1)      <= '0';
              AGENT_ACK(1)      <= '0'; 
              alternate_start   <= alternate_start;
            else
              arb_state         <= WAIT_REQ1_END;
              AGENT_REC(0)      <= '1';
              AGENT_ACK(0)      <= '0';
              AGENT_REC(1)      <= '1';
              AGENT_ACK(1)      <= '1';
              alternate_start   <= alternate_start;
            end if;  
        end case;
      end if;
    end if;
  end process;


end functional ;