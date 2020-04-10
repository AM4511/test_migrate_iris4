-----------------------------------------------------------------------
-- $HeadURL: svn://brainstorm/fpga/trunk/Matrox/Imaging/FPGA/Iris2/cores/common/design/event_cross_domain.vhd $
-- $Author: jlarin $
-- $Revision: 8099 $
-- $Date: 2011-12-07 12:14:43 -0500 (Wed, 07 Dec 2011) $
--
------------------------------------------------------------------------------

-- File:        event_cross_domain.vhd
--
-- Decription:  Petit code pour faire passer un cycle d'un signal d'un 
--              signal d'un domaine d'horloge a un autre, sans se soucier des
--              domaines  asynchrones. Fait pour faire passer des snapshoots
--              et interruptions d'un domaine a un autre. Le niveau par defaut est '0' 
--              
--
--              Note 1:  Si la source est beaucoup plus rapide que la destination, la
--                       destination risque de manquer des snapshoots.
--                       A tenir en compte, ce petit bout de code ne s'applique 
--                       pas a toutes les situations! 
--
--              Note 2:  false paths:    domain_src_ack_p1      
--                       (resynch)       domain_src_ack_p2   
--                                       domain_dst_change_p1
--                                       domain_dst_change_p2
--
--              Note 3:  false path      src_cycle_p1 ->  dst_cycle
--                       (stable)
--
-- Created by:  jmansill
-- Date:        27 fevrier 2008
-- Project:     IRIS2
------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity event_cross_domain is
  generic(
    POSITIVE_LOGIC_SRC_RST : boolean := FALSE;
    POSITIVE_LOGIC_DST_RST : boolean := FALSE
  );
  port(
    src_rst_n       : in     std_logic;
    dst_rst_n       : in     std_logic;
    
    src_clk         : in     std_logic; 
    dst_clk         : in     std_logic; 

    src_cycle       : in     std_logic;
    dst_cycle       : out    std_logic
  );
end event_cross_domain;



architecture functionnal of event_cross_domain is

type src_state_type is (idle, wait_ack, wait_nack);
signal src_currentState      :  src_state_type;

type dst_state_type is (idle, load, ack);
signal dst_currentState      :  dst_state_type;

signal src_rst_n_fixed        : std_logic;
signal dst_rst_n_fixed        : std_logic;

signal  src_cycle_p1          : std_logic;         -- Pipe dans le domaine source
signal  src_change            : std_logic;         -- Signal source qui signale un changement ds le bus
signal  domain_src_ack_p1     : std_logic;         -- false path (resynch)
signal  domain_src_ack_p2     : std_logic;         -- false path (resynch)
signal  domain_dst_change_p1  : std_logic;         -- false path (resynch)
signal  domain_dst_change_p2  : std_logic;         -- false path (resynch)
signal  dst_ack               : std_logic;         -- Signal destination qui signale la reception du changemant

signal dst_cycle_int          : std_logic;         -- Signal de sortie interne au module

attribute ASYNC_REG : string;
attribute ASYNC_REG of domain_src_ack_p1     : signal is "TRUE";
attribute ASYNC_REG of domain_src_ack_p2     : signal is "TRUE";
attribute ASYNC_REG of domain_dst_change_p1  : signal is "TRUE";
attribute ASYNC_REG of domain_dst_change_p2  : signal is "TRUE";




Begin

  -- pour reutiliser ce joli module avec un signal de polarite positive en entree
  -- Le Generique est par defaut au comportement classique
  srcfixpolprc: process(src_rst_n)
  begin
    if POSITIVE_LOGIC_SRC_RST = FALSE then
      src_rst_n_fixed <= src_rst_n;
    else
      src_rst_n_fixed <= not src_rst_n;
    end if;
  end process;

  -- pour reutiliser ce joli module avec un signal de polarite positive en entree
  -- Le Generique est par defaut au comportement classique
  dstfixpolprc: process(dst_rst_n)
  begin
    if POSITIVE_LOGIC_DST_RST = FALSE then
      dst_rst_n_fixed <= dst_rst_n;
    else
      dst_rst_n_fixed <= not dst_rst_n;
    end if;
  end process;
  
  ----------------------------------
  -- Assignation du signal externe
  ----------------------------------
  dst_cycle <= dst_cycle_int;
  
  process(src_clk)
  begin
    if rising_edge(src_clk) then
      if (src_rst_n_fixed = '0') then
        src_cycle_p1   <=   '0';
      elsif(src_change  = '0') then  
        src_cycle_p1   <=  src_cycle;
      else
        src_cycle_p1   <=  src_cycle_p1;
      end if;
    end if;
  end process;

--------------------------
--  STATE SOURCE
--------------------------
   process(src_clk)
   begin
   if rising_edge(src_clk) then
     if(src_rst_n_fixed='0') then
       src_currentState      <= idle;
       src_change            <= '0';
     else
       case src_currentState is
         when idle     =>  if(src_cycle /= src_cycle_p1) then
                             src_currentState      <= wait_ack;
                             src_change            <= '1';
                           else
                             src_currentState      <= idle;
                             src_change            <= '0';
                           end if;

         when wait_ack =>  if(domain_src_ack_p2='1') then
                             src_currentState    <= wait_nack;
                             src_change          <= '0';
                           else
                             src_currentState    <= wait_ack;
                             src_change          <= '1';
                           end if;

         when wait_nack => if(domain_src_ack_p2='0') then
                             src_currentState    <= idle;
                             src_change          <= '0';
                           else
                             src_currentState    <= wait_nack;
                             src_change          <= '0';
                           end if;

                          
                          
       end case;
     end if;  
   end if;
  end process;

--------------------------
--  RESYNC SOURCE
--------------------------
  process(src_clk)
  begin
    if rising_edge(src_clk) then
      if (src_rst_n_fixed = '0') then
        domain_src_ack_p1  <= '0'; 
        domain_src_ack_p2  <= '0';
      else
        domain_src_ack_p1  <= dst_ack; 
        domain_src_ack_p2  <= domain_src_ack_p1;
      end if;
    end if;
  end process;

--------------------------
--  RESYNC DESTINATION
--------------------------
  process(dst_clk)
  begin
    if rising_edge(dst_clk) then
      if (dst_rst_n_fixed = '0') then
        domain_dst_change_p1  <= '0';
        domain_dst_change_p2  <= '0';
      else
        domain_dst_change_p1  <=  src_change;
        domain_dst_change_p2  <=  domain_dst_change_p1;
      end if;
    end if;
  end process;



--------------------------
--  STATE DESTINATION
--------------------------
  process(dst_clk)
  begin
    if rising_edge(dst_clk) then
      if(dst_rst_n_fixed='0') then
        dst_currentState  <= idle;
        dst_ack           <= '0';
        dst_cycle_int     <= '0';
      else
        case dst_currentState is
           when idle     =>  dst_cycle_int     <= dst_cycle_int;
                             if(domain_dst_change_p2='1') then
                              dst_currentState <= load;
                              dst_ack          <= '0';
                            else
                              dst_currentState <= idle;
                              dst_ack          <= '0';
                            end if;

           when load     => dst_currentState   <= ack;
                            dst_cycle_int      <= src_cycle_p1;             -- ICI le bus est stable on loade!
                                                                           
           when ack      => dst_cycle_int      <= '0';                      -- ICI le bus est stable on loade!
                            if(domain_dst_change_p2='0') then               -- ICI on ramene la vieille valeur!
                              dst_currentState <= idle;
                              dst_ack          <= '0';
                            else
                              dst_currentState <= ack;
                              dst_ack          <= '1';
                            end if;
        end case;
      end if;  
    end if;
  end process;


end functionnal;