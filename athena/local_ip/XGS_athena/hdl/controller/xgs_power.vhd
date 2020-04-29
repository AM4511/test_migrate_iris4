-----------------------------------------------------------------------
-- File:        xgs_power.vhd
-- Decription:  
--              
-- This module contains:
-- 
-- Crontrol interface of POWER SEQUENCE for XGS CMOS sensor
--                                                                                                                       
-- Created by:  Javier Mansilla
-- Date:        
-- Project:     IRIS 3
------------------------------------------------------------------------------

library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.std_logic_unsigned.all;
  use IEEE.std_logic_arith.all;

library work;
  use work.regfile_xgs_athena_pack.all;


library UNISIM;
  use UNISIM.VCOMPONENTS.all;

entity xgs_power is
   generic(  G_SIMULATION     : integer    := 0;
             G_SYS_CLK_PERIOD : integer    := 16
          );
   port (  
           sys_reset_n                     : in  std_logic;      --SYSTEME
           sys_clk                         : in  std_logic;

           xgs_power_good                  : in  std_logic;      -- power good

           xgs_osc_en                      : out std_logic;
           xgs_reset_n                     : out std_logic;

           ---------------------------------------------------------------------------
           --  RegFile
           ---------------------------------------------------------------------------         
           regfile                         : inout REGFILE_XGS_ATHENA_TYPE := INIT_REGFILE_XGS_ATHENA_TYPE; -- Register file

        );
end xgs_power;


------------------------------------------------------
-- Begin architecture structure
------------------------------------------------------

architecture functional of xgs_power is


  ------------------------------------------
  --  SIGNALS DECLARATION
  ------------------------------------------

  attribute ASYNC_REG : string;

  --------------
  --  POWERUP   
  --------------
  type type_power_state is ( idle, eclk, ereset, done_ok, edelai, done_nok, dreset, dclk, ddelai );
  
  signal  curr_power_state     :  type_power_state;
  signal  next_power_state     :  type_power_state;


  signal next_xgs_osc_en       : std_logic;
  signal next_xgs_reset_n      : std_logic;
  signal next_power_cntr_en    : std_logic;
  signal next_goto_power       : std_logic_vector(2 downto 0);
  signal next_pup_done         : std_logic;
  signal next_pup_stat         : std_logic;
  signal next_xgs_powerdown    : std_logic;

  signal xgs_osc_en_int        : std_logic:='0';
  signal xgs_reset_n_int       : std_logic:='0';
  signal xgs_reset_n_ORED      : std_logic:='0';
  signal power_cntr_en         : std_logic;
  signal goto_power            : std_logic_vector(2 downto 0);
  signal pup_done              : std_logic;
  signal pup_stat              : std_logic;
  signal xgs_powerdown         : std_logic;

  signal power_cntr            : std_logic_vector(19 downto 0);

  type time_delay is record
    delai_5ms           : std_logic_vector(19 downto 0);  --SYNTH  5 ms delai 
    delai_5us           : std_logic_vector(19 downto 0);  --SIM    5 us delai 
    delai_200us         : std_logic_vector(19 downto 0);  --SIM  200 us delai 
  end record time_delay;

  signal powerup : time_delay;


BEGIN 



  -- Delais 
  powerup.delai_5ms  <= std_logic_vector(conv_unsigned(integer(  5000000/G_SYS_CLK_PERIOD ), 20));    --SYNTH 5 ms delai  
  powerup.delai_200us<= std_logic_vector(conv_unsigned(integer(   200000/G_SYS_CLK_PERIOD ), 20));    --SIM 200 us delai   
  powerup.delai_5us  <= std_logic_vector(conv_unsigned(integer(     5000/G_SYS_CLK_PERIOD ), 20));    --SIM   5 us delai  

 
 

  -------------------------------------------------------------------------------
  --
  -- POWER UP OF SENSOR
  --
  -------------------------------------------------------------------------------

  process(curr_power_state, REGFILE, power_cntr, goto_power, powerup, xgs_power_good )
  begin
    case curr_power_state is
      when  idle              =>  if(REGFILE.ACQ.SENSOR_CTRL.SENSOR_POWERUP='1' and xgs_power_good='1') then       -- POWERUP start
                                    next_power_state  <= eclk;
                                  else
                                    next_power_state  <= idle;
                                  end if;
                                  
      when  eclk              =>  next_power_state  <= edelai;

      when  ereset            =>  next_power_state  <= edelai;

      when  edelai            =>  if (G_SIMULATION=0 and power_cntr=powerup.delai_5ms) then      --SYNTH    5ms delai
                                    if(goto_power="101") then
                                      next_power_state  <= done_ok;
                                    elsif(goto_power="100") then
                                      next_power_state  <= ereset;                                      
                                    else
                                      next_power_state  <= edelai;
                                    end if;
                                  
                                  elsif (G_SIMULATION=1  and power_cntr=powerup.delai_5us) then    --SIM    5 us delai
                                    if(goto_power="100") then
                                      next_power_state  <= ereset;                                      
                                    else
                                      next_power_state  <= edelai;
                                    end if;
                                  
                                  elsif (G_SIMULATION=1  and power_cntr=powerup.delai_200us) then    --SIM, model wait 200us before start to answer
                                    if(goto_power="101") then
                                      next_power_state  <= done_ok;                                
                                    else
                                      next_power_state  <= edelai;
                                    end if;                                                                     
                                    
                                  else
                                    next_power_state  <= edelai;
                                  end if;

      when  done_ok           =>  if(REGFILE.ACQ.SENSOR_CTRL.SENSOR_POWERDOWN='1') then
                                    next_power_state  <= dreset;                              -- reverse powerup sequence(powerdown)
                                  else
                                    next_power_state  <= done_ok;
                                  end if;
                                  
      when  done_Nok          =>  if(REGFILE.ACQ.SENSOR_CTRL.SENSOR_POWERDOWN='1') then       -- In this case goto idle(something is not right!)
                                    next_power_state  <= idle;
                                  else
                                    next_power_state  <= done_Nok;
                                  end if;

      when  dreset            =>  next_power_state  <= ddelai;

      when  dclk              =>  next_power_state  <= ddelai;

      when  ddelai            =>  if (G_SIMULATION=0 and power_cntr=powerup.delai_5ms) or      --SYNTH 5ms delai
                                     (G_SIMULATION=1  and power_cntr=powerup.delai_5us) then    --SIM   5us delai
                                    if(goto_power="101") then
                                      next_power_state  <= dclk;
                                    elsif(goto_power="100") then
                                      next_power_state  <= idle;
                                    else
                                      next_power_state  <= ddelai;
                                    end if;
                                  else
                                    next_power_state  <= ddelai;
                                  end if;

    end case;
  end process;



  process(next_power_state, xgs_osc_en_int, xgs_reset_n_int, goto_power )
  begin
    case next_power_state is
      when  idle              =>  next_xgs_osc_en       <= '0';
                                  next_xgs_reset_n      <= '0';
                                  next_power_cntr_en    <= '0';
                                  next_goto_power       <= "000";
                                  next_pup_done         <= '0';
                                  next_pup_stat         <= '0';
                                  next_xgs_powerdown    <= '1';
                                  
      when  eclk              =>  next_xgs_osc_en       <= '1';
                                  next_xgs_reset_n      <= '0';
                                  next_power_cntr_en    <= '0';
                                  next_goto_power       <= "100";
                                  next_pup_done         <= '0';
                                  next_pup_stat         <= '0';
                                  next_xgs_powerdown    <= '0';

      when  ereset            =>  next_xgs_osc_en       <= '1';
                                  next_xgs_reset_n      <= '1';
                                  next_power_cntr_en    <= '0';
                                  next_goto_power       <= "101";
                                  next_pup_done         <= '0';
                                  next_pup_stat         <= '0';
                                  next_xgs_powerdown    <= '0';

      when  edelai            =>  next_xgs_osc_en       <= xgs_osc_en_int;
                                  next_xgs_reset_n      <= xgs_reset_n_int;
                                  next_power_cntr_en    <= '1';
                                  next_goto_power       <= goto_power;
                                  next_pup_done         <= '0';
                                  next_pup_stat         <= '0';
                                  next_xgs_powerdown    <= '0';

      when  done_ok           =>  next_xgs_osc_en       <= '1';
                                  next_xgs_reset_n      <= '1';
                                  next_power_cntr_en    <= '0';
                                  next_goto_power       <= "000";
                                  next_pup_done         <= '1';
                                  next_pup_stat         <= '1';
                                  next_xgs_powerdown    <= '0';

      when  done_nok          =>  next_xgs_osc_en       <= xgs_osc_en_int;
                                  next_xgs_reset_n      <= xgs_reset_n_int;
                                  next_power_cntr_en    <= '0';
                                  next_goto_power       <= "000";
                                  next_pup_done         <= '1';
                                  next_pup_stat         <= '0';
                                  next_xgs_powerdown    <= '0';

      when  dreset            =>  next_xgs_osc_en       <= '1';
                                  next_xgs_reset_n      <= '0';
                                  next_power_cntr_en    <= '0';
                                  next_goto_power       <= "101";
                                  next_pup_done         <= '0';
                                  next_pup_stat         <= '0';
                                  next_xgs_powerdown    <= '0';

      when  dclk              =>  next_xgs_osc_en       <= '0';
                                  next_xgs_reset_n      <= '0';
                                  next_power_cntr_en    <= '0';
                                  next_goto_power       <= "100";
                                  next_pup_done         <= '0';
                                  next_pup_stat         <= '0';  
                                  next_xgs_powerdown    <= '0';

      when  ddelai            =>  next_xgs_osc_en       <= xgs_osc_en_int;
                                  next_xgs_reset_n      <= xgs_reset_n_int;
                                  next_power_cntr_en    <= '1';
                                  next_goto_power       <= goto_power;
                                  next_pup_done         <= '0';
                                  next_pup_stat         <= '0';
                                  next_xgs_powerdown    <= '0';
                                  
    end case;
  end process;

  --clocked proccess
  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if(sys_reset_n='0') then
        curr_power_state      <= idle;
        xgs_osc_en_int        <= '0';
        xgs_reset_n_int       <= '0';
        power_cntr_en         <= '0';
        goto_power            <= "000";
        pup_done              <= '0';
        pup_stat              <= '0';
        xgs_powerdown         <= '1';
      else
        curr_power_state      <= next_power_state;
        xgs_osc_en_int        <= next_xgs_osc_en;
        xgs_reset_n_int       <= next_xgs_reset_n;
        power_cntr_en         <= next_power_cntr_en;
        goto_power            <= next_goto_power;
        pup_done              <= next_pup_done;
        pup_stat              <= next_pup_stat;
        xgs_powerdown         <= next_xgs_powerdown;
        
      end if;
    end if;
  end process;
  
  
  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if(power_cntr_en='0') then
        power_cntr <= (others=>'0');
      else
        power_cntr <= power_cntr+'1';
      end if;
    end if;
  end process;

  -----------------------
  --  OUTPUT FF IN IOB
  -----------------------
  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if(sys_reset_n='0') then
        xgs_osc_en        <= '0';
        xgs_reset_n       <= '0';
        xgs_reset_n_ORED  <= '0';
      else
        xgs_osc_en        <= xgs_osc_en_int;
        xgs_reset_n       <= xgs_reset_n_ORED;
        
        if(xgs_reset_n_int='1')then
          xgs_reset_n_ORED    <=  REGFILE.ACQ.SENSOR_CTRL.SENSOR_RESETN;   -- AFTER successfull PoweredUP,  this register can reset the sensor
        else
          xgs_reset_n_ORED    <= '0'; -- IN RESET
        end if;

      end if;
    end if;
  end process;

  -----------------------
  --  Status registers
  -----------------------
  
  REGFILE.ACQ.SENSOR_STAT.SENSOR_POWERDOWN     <=  xgs_powerdown;
  
  REGFILE.ACQ.SENSOR_STAT.SENSOR_POWERUP_DONE  <=  pup_done;
  REGFILE.ACQ.SENSOR_STAT.SENSOR_POWERUP_STAT  <=  pup_stat;

  REGFILE.ACQ.SENSOR_STAT.SENSOR_VCC_PG        <=  xgs_power_good;
  
  REGFILE.ACQ.SENSOR_STAT.SENSOR_OSC_EN        <=  xgs_osc_en_int;
  REGFILE.ACQ.SENSOR_STAT.SENSOR_RESETN        <=  xgs_reset_n_ORED;




end functional;