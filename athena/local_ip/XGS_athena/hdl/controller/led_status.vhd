
-----------------------------------------------------------------------
-- File:        led_status.vhd
-- Decription:  This module will drive the status led
--               
-- This module contains:
--                                                                                                                       
-- Created by:  Javier Mansilla
-- Date:        
-- Project:     IRIS 4
------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

library work;
                         
entity led_status is
   generic( G_SYS_CLK_PERIOD : integer    := 16     -- Sysclock period
          );
   port (   
     sys_reset_n         : in  std_logic;
     sys_clk             : in  std_logic;

     pix_clk             : in  std_logic;

     led_out             : out std_logic_vector(1 downto 0);
     reg_pixclk_error    : out std_logic;
     
     Green_Led_event_sys : in std_logic:='0';
     
     REG_LED_TEST        : in  std_logic                    := '0';
     REG_LED_TEST_COLOR  : in  std_logic_vector(1 downto 0) := "00"

  );
end led_status;


------------------------------------------------------
-- Begin architecture structure
------------------------------------------------------

architecture functional of led_status is

  signal  cnt       :  std_logic; 
  signal  led_cntr  :  std_logic_vector(24 downto 0); 

  type  def_led_head_onoff_currentState  is ( off_state ,
                                              on_state_0,
                                              on_state_1  
                                            );
  signal  led_head_onoff_currentState : def_led_head_onoff_currentState;
  
  signal  head_onoff_cntr     : std_logic_vector(5 downto 0):= (others=>'0');
  signal  head_onoff_cntr_sys : std_logic_vector(7 downto 0);
  signal  head_onoff_cntr3_p1 : std_logic;
  signal  head_onoff_cntr3_p2 : std_logic;
  signal  head_onoff_cntr3_p3 : std_logic;
  signal  countsys            : std_logic;            
  signal  reset_countsys      : std_logic;
  signal  toggle_led_cntr_head_off : std_logic_vector(25 downto 0);        

  signal led_out_ff           : std_logic_vector(1 downto 0);

BEGIN


  ---------------------------------------------------------------------
  --
  -- LED STATUS
  --
  --  RG
  --  00 -> LED OFF
  --  01 -> GREEN
  --  10 -> RED
  --  11 -> ORANGE
  --
  ---------------------------------------------------------------------

  process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if(sys_reset_n = '0') then
        led_out_ff  <= "11";                                    --ORANGE AT RESET
      elsif(REG_LED_TEST='1') then                              --TEST MODE GTr STANDARD
        led_out_ff  <=  REG_LED_TEST_COLOR;       
      elsif(led_head_onoff_currentState = off_state) then       --PIXEL CLK FAILURE
        led_out_ff(1)   <= '1'; 
        
        if((G_SYS_CLK_PERIOD=16)and toggle_led_cntr_head_off(24)='0')then
          led_out_ff(0) <=  '0';
        elsif(G_SYS_CLK_PERIOD=8 and toggle_led_cntr_head_off(25)='0')then
          led_out_ff(0) <=  '0';
        else
          led_out_ff(0) <=  '1';
        end if;
      else                                     -- Clignotement Vert
        led_out_ff(0) <=  '1';                 -- GREEN (ON/OFF)
        if(cnt='0') then                       -- RED   (ON/OFF)
          led_out_ff(1) <=  '1';
        else 
          led_out_ff(1) <=  '0';
        end if;
      end if;  
      
      if(sys_reset_n = '0') then
        cnt      <= '0';
      elsif(led_cntr="0000000000000000000000000") then
        cnt      <= '0';
      elsif(Green_Led_event_sys='1') then
        cnt      <= '1';
      end if;

      if(sys_reset_n = '0') then
        led_cntr  <= (others=>'1');
      elsif(led_cntr="0000000000000000000000000" or Green_Led_event_sys='1') then
        if(G_SYS_CLK_PERIOD=16) then
          led_cntr(24)          <= '0';
          led_cntr(23 downto 0) <= (others=>'1');
        elsif(G_SYS_CLK_PERIOD=8) then
          led_cntr(23 downto 0) <= (others=>'1');
        end if;
      elsif(cnt ='1') then
        led_cntr <= std_logic_vector(led_cntr-'1');
      end if;
        
    end if;
  end process;    

  -- SI on est en mode de test on veux valider les pullup-pulldowns des leds
  --led_out <= "ZZ" when  (REG_LED_TEST_COLOR="10" and REG_LED_TEST='1') else led_out_ff;
  led_out <= led_out_ff;
  
  --------------------------------------------------
  --
  --  LED QUI CLIGNOTE LORSQU'IL N'Y A PAS DE DCLK 
  --
  --------------------------------------------------
  
  process(pix_clk)       --Ceci compte toujours
  begin
    if(pix_clk'event and pix_clk='1') then
      head_onoff_cntr <= std_logic_vector(head_onoff_cntr+'1');
    end if;
  end process;

  process(sys_clk)       --Ceci compte toujours
  begin
    if(sys_clk'event and sys_clk='1') then
      if(sys_reset_n='0') then   
        head_onoff_cntr_sys <= "00000000";
      elsif(reset_countsys='1') then
        head_onoff_cntr_sys <= "00000000";
      elsif(countsys='1') then
        head_onoff_cntr_sys <= std_logic_vector(head_onoff_cntr_sys+'1');
      end if;

      if(sys_reset_n='0') then   
        toggle_led_cntr_head_off <= (others=>'0');
      else
        
        if(G_SYS_CLK_PERIOD=16)then
          toggle_led_cntr_head_off(25)          <= '0';
          toggle_led_cntr_head_off(24 downto 0) <= std_logic_vector(toggle_led_cntr_head_off(24 downto 0)+'1');
        elsif(G_SYS_CLK_PERIOD=8)then
          toggle_led_cntr_head_off(25 downto 0) <= std_logic_vector(toggle_led_cntr_head_off(25 downto 0)+'1');
        end if;
      end if;  
    end if;
  end process;


  process(sys_clk)       --pipelines sync
  begin
    if(sys_clk'event and sys_clk='1') then
      if(sys_reset_n='0') then 
        head_onoff_cntr3_p1 <= '0';
        head_onoff_cntr3_p2 <= '0';
        head_onoff_cntr3_p3 <= '0';
      else
        head_onoff_cntr3_p1 <= head_onoff_cntr(5);
        head_onoff_cntr3_p2 <= head_onoff_cntr3_p1;
        head_onoff_cntr3_p3 <= head_onoff_cntr3_p2;
      end if;  
    end if;
  end process;
      
  process(sys_clk)
  begin
  if(sys_clk'event and sys_clk='1') then
    if(sys_reset_n='0') then
      led_head_onoff_currentState <= off_state;
      countsys                    <='0';
      reset_countsys              <='1';
    else
      case led_head_onoff_currentState is

        when off_state  =>  if(head_onoff_cntr3_p3='1' and head_onoff_cntr3_p2='0') or (head_onoff_cntr3_p3='0' and head_onoff_cntr3_p2='1') then 
                              led_head_onoff_currentState  <= on_state_0;
                              countsys                     <='0';
                              reset_countsys               <='1';
                            else
                              led_head_onoff_currentState  <= off_state;
                              countsys                     <='0';
                              reset_countsys               <='0';
                            end if;

        when on_state_0 =>  if(head_onoff_cntr3_p3='1' and head_onoff_cntr3_p2='0') then -- falling
                              led_head_onoff_currentState  <= on_state_1;
                              countsys                     <='0';
                              reset_countsys               <='1';
                            elsif(head_onoff_cntr_sys="11111111")then
                              led_head_onoff_currentState  <= off_state;
                              countsys                     <='0';
                              reset_countsys               <='1';
                            else
                              led_head_onoff_currentState  <= on_state_0;
                              countsys                     <='1';
                              reset_countsys               <='0';
                            end if;

        when on_state_1 =>  if(head_onoff_cntr3_p3='0' and head_onoff_cntr3_p2='1')    then -- rising
                              led_head_onoff_currentState  <= on_state_0;
                              countsys                     <='0';
                              reset_countsys               <='1';
                            elsif(head_onoff_cntr_sys="11111111")then
                              led_head_onoff_currentState  <= off_state;
                              countsys                     <='0';
                              reset_countsys               <='1';
                            else
                              led_head_onoff_currentState  <= on_state_1;
                              countsys                     <='1';
                              reset_countsys               <='0';
                            end if;

      end case;
    end if;  
  end if;
  end process;


  process(sys_clk)       -- registre
  begin
    if(sys_clk'event and sys_clk='1') then
      if(sys_reset_n='0') then 
        reg_pixclk_error    <= '1';
      else
        if(led_head_onoff_currentState=off_state) then
          reg_pixclk_error    <= '1';
        else
          reg_pixclk_error    <= '0';
        end if;
      end if;  
    end if;
  end process;

















END functional;