-----------------------------------------------------------------------
-- $HeadURL: svn://brainstorm/fpga/trunk/Matrox/Imaging/FPGA/Timer.vhd$
-- $Author: jmansill $
-- $Revision:  $
-- $Date: 2010-05-25 07:07:15 -0400 (Tue, 25 May 2010) $
--
-- DESCRIPTION: Spider General timer

-- 
-- 
-- 
-- 
-- 
--
--
-- Created by:  Javier Mansilla
-- Date:        30 juillet 2013
-- Project:     Spider GPM
--
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--use work.regfile_spider_lpc_pack.all;
use work.spider_pak.all;

entity Timer is
    generic(  int_number      : integer :=3;                -- interrupt bit where the interrupts are forwarded
              LPC_PERIOD      : integer :=30);              -- 30 pour GPM, 40 pour GPM-Atom
  port (
    ---------------------------------------------------------------------
    -- Reset and clock signals
    ---------------------------------------------------------------------
    sys_reset_n                          : in  std_logic;
    sys_clk                              : in  std_logic;
    
    ---------------------------------------------------------------------
    -- Inputs
    ---------------------------------------------------------------------
    TimerArmSource_MUX                   : in  std_logic_vector;
    TimerTriggerSource_MUX               : in  std_logic_vector;
    ClockSource_MUX                      : in  std_logic_vector;
    
    ---------------------------------------------------------------------
    -- Output
    ---------------------------------------------------------------------
    Timer_Output                         : out  std_logic; 

    ---------------------------------------------------------------------
    -- IRQ
    ---------------------------------------------------------------------
    Timer_start_IRQ                      : out  std_logic; 
    Timer_end_IRQ                        : out  std_logic;
    
    ---------------------------------------------------------------------
    -- REGISTER 
    ---------------------------------------------------------------------
    regfile                              : inout Timer_TYPE := INIT_Timer_TYPE
    
     
  );
end Timer;


architecture functional of Timer is


-----------------------------------------------------
-- signals
-----------------------------------------------------
signal  TimerArmSource_AsInt     :  integer;
signal  arm_src                  :  std_logic;
signal  arm_act_edge_ris         :  std_logic;
signal  arm_act_edge_fal         :  std_logic;
signal  arm_act_lev_high         :  std_logic;
signal  arm_act_lev_low          :  std_logic;
signal  arm_src_p1               :  std_logic;
signal  arm_activate             :  std_logic;
signal  arm_activate_logic       :  std_logic;
signal  TimerArmSource_MUX_SW    :  std_logic_vector(TimerArmSource_MUX'length downto 0);

signal  TimerTriggerSource_AsInt :  integer;
signal  trig_src                 :  std_logic;
signal  trig_src_p1              :  std_logic;
signal  trig_src_logic           :  std_logic;
signal  trig_src_logic_p1        :  std_logic;
signal  trig_act_edge_ris        :  std_logic;
signal  trig_act_edge_fal        :  std_logic;
signal  trig_act_lev_high        :  std_logic;
signal  trig_act_lev_low         :  std_logic;
signal  trig_activate            :  std_logic;
signal  trig_src_logic_D         :  std_logic;
signal  trig_src_logic_E         :  std_logic;
signal  trig_activate_logic      :  std_logic;
signal  trig_activate_logic_p1   :  std_logic;
signal  TimerTriggerSource_MUX_SW:  std_logic_vector(TimerTriggerSource_MUX'length + 1 downto 0);


signal  DelayClkSource_AsInt     :  integer;
signal  Delay_clock_src          :  std_logic;
signal  Delay_clock_src_p1       :  std_logic;
signal  Delay_clock_act_edge_ris :  std_logic;
signal  Delay_clock_act_edge_fal :  std_logic; 
signal  Delay_clock_activate     :  std_logic;

signal  clk_cntr                 :  std_logic_vector(4 downto 0);
signal  Clk_Int                  :  std_logic;
signal  TimerClkSource_AsInt     :  integer;
signal  Timer_clock_src          :  std_logic;
signal  Timer_clock_src_p1       :  std_logic;
signal  Timer_clock_act_edge_ris :  std_logic;
signal  Timer_clock_act_edge_fal :  std_logic; 
signal  Timer_clock_activate     :  std_logic;

signal  ClockSource_MUX_CLK      :  std_logic_vector(ClockSource_MUX'length downto 0);   -- pour inclure l'horloge

type    type_timer_crtl_state is (  timer_idle,
                                    timer_WaitOnArm,
                                    timer_WaitOnTrigger,
                                    timer_Delaying,
                                    timer_Active,
                                    timer_Measure
                                 );

signal  curr_timer_crtl_state    :  type_timer_crtl_state;
signal  curr_timer_crtl_state_p1 :  type_timer_crtl_state;
signal  next_timer_crtl_state    :  type_timer_crtl_state;
signal  TimerState               :  std_logic_vector(2 downto 0);

signal  next_timer_out           :  std_logic;
signal  timer_out                :  std_logic;
signal  next_timer_rst_clk_int   :  std_logic;
signal  timer_rst_clk_int        :  std_logic;


signal  timer_cntr               :  std_logic_vector(31 downto 0);


signal  timer_mesuring                 : std_logic;
signal  timer_irq_start_event_timer    : std_logic;
signal  timer_irq_end_event_timer      : std_logic;
signal  timer_irq_start_event_counter  : std_logic;
signal  timer_irq_end_event_counter    : std_logic;

signal  trigger_overlap_db             : std_logic;
signal  next_timer_running             : std_logic;
signal  timer_running                  : std_logic;

begin

  --IRQ location in INT_STAT REGISTER
  regfile.CAPABILITIES_TIMER.INTNUM <= conv_std_logic_vector(int_number,5);


  --Registre de periode
  regfile.TimerClockPeriod.Period_ns <= conv_std_logic_vector(LPC_PERIOD*8, 16);

  -------------------------------------------------------
  -- ARM SOURCE LOGIC
  -------------------------------------------------------
  TimerArmSource_AsInt  <= CONV_integer(regfile.TimerTriggerArm.TimerArmSource);
  TimerArmSource_MUX_SW <= TimerArmSource_MUX & regfile.TimerTriggerArm.Soft_TimerArm;


  process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if TimerArmSource_AsInt < TimerArmSource_MUX_SW'length then
        arm_src <= TimerArmSource_MUX_SW(TimerArmSource_AsInt);
      else
        arm_src <= '0';
      end if;
    end if;
  end process;




  -------------------------------------------------------
  -- ARM Edge/Level detect in ACTIVATION LOGIC
  -------------------------------------------------------
  process(arm_src, arm_src_p1)
  begin
    arm_act_edge_ris  <= arm_src and not(arm_src_p1);   -- rising edge
    arm_act_edge_fal  <= not(arm_src) and arm_src_p1;   -- falling edge
    arm_act_lev_high  <= arm_src;                       -- level high
    arm_act_lev_low   <= not(arm_src);                  -- level low
  end process;

  process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      arm_src_p1 <= arm_src;
      case regfile.TimerTriggerArm.TimerArmActivation is
        when "000"  => arm_activate <= arm_act_edge_ris;                        --Rising Edge
        when "001"  => arm_activate <= arm_act_edge_fal;                        --Falling Edge
        when "010"  => arm_activate <= arm_act_edge_ris or arm_act_edge_fal;    --ANY Edge
        when "011"  => arm_activate <= arm_act_lev_low;                         --Level LOW
        when "100"  => arm_activate <= arm_act_lev_high;                        --Level HI
        when others => arm_activate <= '0';
      end case;
    end if;
  end process;

  -- When added the logical in th etrigger path, we add a ff on the path
  -- this ff is necessary to match the path of the trig.
  process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      arm_activate_logic <= arm_activate;
    end if;
  end process;


  -------------------------------------------------------
  -- TRIGGER SOURCE LOGIC
  -------------------------------------------------------
  TimerTriggerSource_AsInt  <= CONV_integer(regfile.TimerTriggerArm.TimerTriggerSource);

  TimerTriggerSource_MUX_SW <= TimerTriggerSource_MUX & regfile.TimerTriggerArm.Soft_TimerTrigger & '0';


  process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if TimerTriggerSource_AsInt < TimerTriggerSource_MUX_SW'length then
        trig_src <= TimerTriggerSource_MUX_SW(TimerTriggerSource_AsInt);
      else
        trig_src <= '0';
      end if;
    end if;
  end process;


  -------------------------------------------------------
  -- TRIGGER Edge/Level detect in ACTIVATION LOGIC
  -------------------------------------------------------
  process(trig_src, trig_src_p1)
  begin
      trig_act_edge_ris  <= trig_src and not(trig_src_p1);       -- rising edge
      trig_act_edge_fal  <= not(trig_src) and trig_src_p1;       -- falling edge
      trig_act_lev_high  <= trig_src;                           -- level high
      trig_act_lev_low   <= not(trig_src);                      -- level low
  end process;

  process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      trig_src_p1      <= trig_src;
      case regfile.TimerTriggerArm.TimerTriggerActivation is
        when "000"  => trig_activate <= trig_act_edge_ris;                            --Rising Edge
        when "001"  => trig_activate <= trig_act_edge_fal;                            --Falling Edge
        when "010"  => trig_activate <= trig_act_edge_ris or trig_act_edge_fal;       --ANY Edge
        when "011"  => trig_activate <= trig_act_lev_low;                             --Level LOW
        when "100"  => trig_activate <= trig_act_lev_high;                            --Level HI
        when others => trig_activate <= '0';
      end case;
    end if;
  end process;


  -------------------------------------------------------
  --
  --  PROGRAMMABLE COMBINATORIAL LOGIC FF
  --
  -------------------------------------------------------
  process(trig_activate, arm_activate, regfile.TimerTriggerArm.TimerTriggerLogicDSel)
  begin
    if(regfile.TimerTriggerArm.TimerTriggerLogicDSel="00") then
      trig_src_logic_D  <= trig_activate;
    elsif(regfile.TimerTriggerArm.TimerTriggerLogicDSel="01") then
      trig_src_logic_D  <= trig_activate AND arm_activate;
    elsif(regfile.TimerTriggerArm.TimerTriggerLogicDSel="10") then
      trig_src_logic_D  <= trig_activate OR arm_activate;
    else
      trig_src_logic_D  <= trig_activate XOR arm_activate;
    end if;
  end process;

  process(trig_activate, arm_activate, regfile.TimerTriggerArm.TimerTriggerLogicESel)
  begin
    if(regfile.TimerTriggerArm.TimerTriggerLogicESel="00") then
      trig_src_logic_E  <= '1';
    elsif(regfile.TimerTriggerArm.TimerTriggerLogicESel="01") then
      trig_src_logic_E  <= arm_activate;
    elsif(regfile.TimerTriggerArm.TimerTriggerLogicESel="10") then
      trig_src_logic_E  <= trig_activate AND arm_activate;
    else
      trig_src_logic_E  <= trig_activate OR arm_activate;
    end if;
  end process;

  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if(sys_reset_n='0') then
        trig_activate_logic    <= '0';
      elsif(trig_src_logic_E  = '1') then
        trig_activate_logic    <= trig_src_logic_D;
      end if;

      if(sys_reset_n='0') then
        trig_activate_logic_p1 <= '0';
      else
        trig_activate_logic_p1 <= trig_activate_logic;
      end if;

    end if;
  end process;
  
  -------------------------------------------------------
  -- SLOW CLOCK GENERATION from 33.33333mhz (T=30ns)
  -- Default : Tclk =8*30 = 240 ns, 4.166666 mhz
  -------------------------------------------------------
  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if(sys_reset_n='0' or timer_rst_clk_int='1') then
        clk_cntr        <= (others=>'0');
      elsif( curr_timer_crtl_state = timer_Delaying and  regfile.TimerClockSource.DelayClockSource="0000") or
           ( curr_timer_crtl_state = timer_Active   and  regfile.TimerClockSource.TimerClockSource="0000") or
           ( curr_timer_crtl_state = timer_Measure  and  regfile.TimerClockSource.TimerClockSource="0000") then
         clk_cntr        <= clk_cntr+'1';
      end if;
    end if;
  end process;

  Clk_Int <= Clk_cntr(1) when regfile.TimerClockSource.IntClock_sel="00" else     --  GPm: 8.333333 mhz  GPm-Atom: 6.25000 mhz
             Clk_cntr(2) when regfile.TimerClockSource.IntClock_sel="01" else     --  GPm: 4.166666 mhz  GPm-Atom: 3.12500 mhz   (default)
             Clk_cntr(3) when regfile.TimerClockSource.IntClock_sel="10" else     --  GPm: 2.083333 mhz  GPm-Atom: 1.56250 mhz
             Clk_cntr(4);                                                         --  GPm: 1.041666 mhz  GPm-Atom: 0.78125 mhz




  -------------------------------------------------------
  -- DELAY CLOCK SOURCE LOGIC
  -------------------------------------------------------
  DelayClkSource_AsInt <= CONV_integer(regfile.TimerClockSource.DelayClockSource);
  ClockSource_MUX_CLK  <= ClockSource_MUX & Clk_Int;

  process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if DelayClkSource_AsInt < ClockSource_MUX_CLK'length then
        Delay_clock_src <= ClockSource_MUX_CLK(DelayClkSource_AsInt);
      else
        Delay_clock_src <= '0';
      end if;
    end if;
  end process;


  -------------------------------------------------------
  -- DELAY Edge detect in CLOCK ACTIVATION LOGIC
  -------------------------------------------------------
  process(Delay_clock_src, Delay_clock_src_p1)
  begin
      Delay_clock_act_edge_ris  <= Delay_clock_src and not(Delay_clock_src_p1);       -- rising edge
      Delay_clock_act_edge_fal  <= not(Delay_clock_src) and Delay_clock_src_p1;       -- falling edge
  end process;

  process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      Delay_clock_src_p1 <= Delay_clock_src;

      case regfile.TimerClockSource.DelayClockActivation is
        when "00"   => Delay_clock_activate <= Delay_clock_act_edge_ris;                             --Rising Edge
        when "01"   => Delay_clock_activate <= Delay_clock_act_edge_fal;                             --Falling Edge
        when "10"   => Delay_clock_activate <= Delay_clock_act_edge_ris or Delay_clock_act_edge_fal; --ANY Edge
        when others => Delay_clock_activate <= '0';
      end case;
      
    end if;
  end process;                                


  -------------------------------------------------------
  -- TIMER CLOCK SOURCE LOGIC
  -------------------------------------------------------
  TimerClkSource_AsInt <= CONV_integer(regfile.TimerClockSource.TimerClockSource);

  process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if TimerClkSource_AsInt < ClockSource_MUX_CLK'length then
        timer_clock_src <= ClockSource_MUX_CLK(TimerClkSource_AsInt);
      else
        timer_clock_src <= '0';
      end if;
    end if;
  end process;


  -------------------------------------------------------
  -- TIMER Edge detect in CLOCK ACTIVATION LOGIC
  -------------------------------------------------------
  process(timer_clock_src, timer_clock_src_p1)
  begin
      timer_clock_act_edge_ris  <= timer_clock_src and not(timer_clock_src_p1);       -- rising edge
      timer_clock_act_edge_fal  <= not(timer_clock_src) and timer_clock_src_p1;       -- falling edge
  end process;

  process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      timer_clock_src_p1 <= timer_clock_src;

      case regfile.TimerClockSource.TimerClockActivation is
        when "00"    => timer_clock_activate <= timer_clock_act_edge_ris;                             --Rising Edge
        when "01"    => timer_clock_activate <= timer_clock_act_edge_fal;                             --Falling Edge
        when "10"    => timer_clock_activate <= timer_clock_act_edge_ris or timer_clock_act_edge_fal; --ANY Edge
        when others  => timer_clock_activate <= '0';
      end case;
      
    end if;
  end process;

  -------------------------------------------------------
  -- Control State machine
  -------------------------------------------------------

  process(curr_timer_crtl_state, regfile, arm_activate_logic, trig_activate_logic, timer_cntr, trigger_overlap_db)
  begin
    case curr_timer_crtl_state is
    
      when  timer_idle            => if(regfile.TimerStatus.TimerEnable='1') then       --START the state machine
                                       next_timer_crtl_state  <=  timer_WaitOnArm;      --Wait for Arm
                                     else
                                       next_timer_crtl_state  <=  timer_idle;
                                     end if;

      when  timer_WaitOnArm       => if(regfile.TimerStatus.TimerEnable='0') then       --Reset the state machine
                                       next_timer_crtl_state  <=  timer_idle;
                                     elsif(regfile.TimerTriggerArm.TimerArmEnable='1') then  -- Wait for arm event
                                       if(arm_activate_logic='1') then
                                         next_timer_crtl_state  <=  timer_WaitOnTrigger;
                                       else
                                         next_timer_crtl_state  <=  timer_WaitOnArm;
                                       end if;
                                     else
                                       next_timer_crtl_state  <=  timer_WaitOnTrigger;       -- DONT Wait for arm event, go to wait on trigger
                                     end if;

      when  timer_WaitOnTrigger   => if(regfile.TimerStatus.TimerEnable='0') then       --Reset the state machine
                                       next_timer_crtl_state  <=  timer_idle;
                                     elsif(regfile.TimerTriggerArm.TimerMesurement='1' and trig_activate_logic='1') then
                                       next_timer_crtl_state  <=  timer_Measure;
                                     elsif(regfile.TimerTriggerArm.TimerMesurement='0' and (trig_activate_logic='1' or regfile.TimerTriggerArm.TimerTriggerSource="000000" or trigger_overlap_db='1') ) then        -- trigger event activate received OR bypass because of continuous
                                       next_timer_crtl_state  <=  timer_Delaying;
                                     else
                                       next_timer_crtl_state  <=  timer_WaitOnTrigger;
                                     end if;

      when  timer_Delaying        => if(regfile.TimerStatus.TimerEnable='0') then       --Reset the state machine
                                       next_timer_crtl_state  <=  timer_idle;
                                     elsif(trigger_overlap_db='1' and regfile.TimerTriggerArm.TimerTriggerOverlap="10") then      --Overlap trigger and RESET
                                       next_timer_crtl_state  <=  timer_WaitOnTrigger;
                                     elsif(timer_cntr=regfile.TimerDelayValue.TimerDelayValue) then
                                       next_timer_crtl_state  <=  timer_Active;
                                     else
                                       next_timer_crtl_state  <=  timer_Delaying ;
                                     end if;

      when  timer_Active          => if(regfile.TimerStatus.TimerEnable='0') then       --Reset the state machine
                                       next_timer_crtl_state  <=  timer_idle;
                                     elsif(trigger_overlap_db='1' and regfile.TimerTriggerArm.TimerTriggerOverlap="10") then      --Overlap trigger and RESET
                                       next_timer_crtl_state  <=  timer_WaitOnTrigger;
                                     elsif(timer_cntr=regfile.TimerDuration.TimerDuration) then
                                       if(regfile.TimerTriggerArm.TimerTriggerSource="000000") then  --Continuous mode
                                         next_timer_crtl_state  <=  timer_Delaying;
                                       elsif(trigger_overlap_db='1') then           --Overlap trigger and LATCH
                                         next_timer_crtl_state  <=  timer_WaitOnTrigger;
                                       else
                                         next_timer_crtl_state  <=  timer_WaitOnArm;
                                       end if;
                                     else
                                       next_timer_crtl_state  <=  timer_Active;
                                     end if;

      when  timer_Measure         => if(regfile.TimerStatus.TimerEnable='0') then  --Reset the state machine
                                       next_timer_crtl_state  <=  timer_idle;
                                     elsif(regfile.TimerTriggerArm.TimerMesurement='0') then
                                       next_timer_crtl_state  <=  timer_WaitOnArm;
                                     else
                                       next_timer_crtl_state  <=  timer_Measure;
                                     end if;

    end case;
  end process;



  process(next_timer_crtl_state,trig_src_logic_p1,trig_activate_logic)
  begin
    case next_timer_crtl_state is
      when  timer_idle          =>  next_timer_out         <= '0';
                                    next_timer_rst_clk_int <= '1';
                                    next_timer_running     <= '0';
                                    
      when  timer_WaitOnArm     =>  next_timer_out         <= '0';
                                    next_timer_rst_clk_int <= '1';
                                    next_timer_running     <= '0';
                                    
      when  timer_WaitOnTrigger =>  next_timer_out         <= '0';
                                    next_timer_rst_clk_int <= '1';
                                    next_timer_running     <= '0';
                                    
      when  timer_Delaying      =>  next_timer_out         <= '0';
                                    next_timer_rst_clk_int <= '0';
                                    next_timer_running     <= '1';
                                    
      when  timer_Active        =>  next_timer_out         <= '1';
                                    next_timer_rst_clk_int <= '0';
                                    next_timer_running     <= '1';

      when  timer_Measure       =>  next_timer_out         <= trig_activate_logic;           --back door pour sebastien pour sortir le signal logique
                                    next_timer_rst_clk_int <= '0';
                                    next_timer_running     <= '0';
    end case;
  end process;


  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if(sys_reset_n='0') then
        curr_timer_crtl_state    <= timer_idle;
        curr_timer_crtl_state_p1 <= timer_idle;
        timer_out                <= '0';
        timer_rst_clk_int        <= '1';
        timer_running            <= '0';
      else
        curr_timer_crtl_state    <= next_timer_crtl_state;
        curr_timer_crtl_state_p1 <= curr_timer_crtl_state;
        timer_out                <= next_timer_out;
        timer_rst_clk_int        <= next_timer_rst_clk_int;
        timer_running            <= next_timer_running;
      end if;  
    end if;
  end process;



  --------------------------------------------------
  --  COUNTER - 32 bits                           --
  --------------------------------------------------
  process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if(sys_reset_n = '0') then
        timer_cntr <= (others =>'0');
      else
        if (regfile.TimerStatus.TimerCntrReset='1' or regfile.TimerStatus.TimerEnable='0')                      or                            --Reset the timer
           (regfile.TimerStatus.TimerLatchAndReset='1' and timer_irq_end_event_counter='1')                     or
           (regfile.TimerStatus.TimerLatchAndReset='1' and regfile.TimerStatus.TimerLatchValue ='1')            or
           (curr_timer_crtl_state = timer_Delaying and timer_cntr = regfile.TimerDelayValue.TimerDelayValue)    or
           (curr_timer_crtl_state = timer_Active   and timer_cntr = regfile.TimerDuration.TimerDuration)        or
           (curr_timer_crtl_state = timer_Measure  and regfile.TimerTriggerArm.TimerMesurement='0')             or
           (curr_timer_crtl_state = timer_WaitOnTrigger)                                                        then

          timer_cntr <= (others =>'0');
       
        elsif (curr_timer_crtl_state = timer_Delaying and delay_clock_activate='1') or 
              (curr_timer_crtl_state = timer_Active   and timer_clock_activate='1') or
              (curr_timer_crtl_state = timer_Measure  and timer_clock_activate='1' and trig_activate_logic_p1='1') then
          timer_cntr <= std_logic_vector(timer_cntr + '1');
        end if;
      end if; 
      
    end if;
  end process;


  --------------------------------------------------
  --  Timer output                                --
  --------------------------------------------------
  Timer_output <= timer_out when (regfile.TimerStatus.TimerInversion='0') else not(timer_out);

  --------------------------------------------------
  --  Timer Latched value                         --
  --------------------------------------------------
  process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if(regfile.TimerStatus.TimerLatchValue ='1' or timer_irq_end_event_counter='1' or (trigger_overlap_db='1' and curr_timer_crtl_state=timer_WaitOnTrigger and regfile.TimerTriggerArm.TimerTriggerOverlap="10")) then     -- on latch 1) registre SW,   2) A la fin du pulse qu'on mesure,   3) Trigger overlap with RESET
        regfile.TimerLatchedValue.TimerLatchedValue <= timer_cntr;
      end if;
    end if;
  end process;


  --------------------------------------------------
  --  Combinatorial Timer State                   --
  --------------------------------------------------
  process(curr_timer_crtl_state)
  begin
    case curr_timer_crtl_state is
      when  timer_idle          =>  TimerState  <= "000";
      when  timer_WaitOnArm     =>  TimerState  <= "001";
      when  timer_WaitOnTrigger =>  TimerState  <= "010";
      when  timer_Delaying      =>  TimerState  <= "011";
      when  timer_Active        =>  TimerState  <= "100";
      when  timer_Measure       =>  TimerState  <= "101";
    end case;
  end process;

  --------------------------------------------------
  --  CURR Timer State                            --
  --------------------------------------------------
  regfile.TimerStatus.TimerStatus  <= TimerState;

  --------------------------------------------------
  --  LATCHED Timer State                         --
  --------------------------------------------------
  process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if(regfile.TimerStatus.TimerLatchValue ='1') then
        regfile.TimerStatus.TimerStatus_Latched  <= TimerState;
      end if;
    end if;
  end process;




  --------------------------------------------------
  --  TIMER IRQ  (START/END)                      --
  --------------------------------------------------
  process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if(sys_reset_n = '0') then
        timer_irq_start_event_timer <= '0';
        timer_irq_end_event_timer   <= '0';
      else
        if (curr_timer_crtl_state = timer_Active and curr_timer_crtl_state_p1 /= timer_Active) then    -- Entering active -> START IRQ
          timer_irq_start_event_timer <= '1';
        else 
          timer_irq_start_event_timer <= '0';
        end if;

        if (curr_timer_crtl_state_p1 = timer_Active and curr_timer_crtl_state /= timer_Active and regfile.TimerStatus.TimerEnable='1')  then             -- Exiting active -> timer_Delaying or timer_WaitOnArm : END IRQ
        --if (curr_timer_crtl_state = timer_Active and timer_cntr = regfile.TimerDuration.TimerDuration)  then     -- reaching max value of counter
          timer_irq_end_event_timer   <= '1';
        else
          timer_irq_end_event_timer   <= '0';
        end if;

      end if; 
      
    end if;
  end process;

  --------------------------------------------------
  --  COUNTER IRQ  (START/END)                      --
  --------------------------------------------------
 process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if(sys_reset_n = '0') then
        timer_mesuring                <= '0';
        timer_irq_start_event_counter <= '0';
        timer_irq_end_event_counter   <= '0';
      else
        if (regfile.TimerStatus.TimerEnable='0'  or curr_timer_crtl_state /= timer_Measure)   then
          timer_mesuring                <= '0';
          timer_irq_start_event_counter <= '0';
          timer_irq_end_event_counter   <= '0';
        elsif (timer_mesuring = '0' and curr_timer_crtl_state = timer_Measure and trig_activate_logic_p1='1') then
          timer_mesuring                <= '1';
          timer_irq_start_event_counter <= '1';
          timer_irq_end_event_counter   <= '0';
        elsif (timer_mesuring = '1' and curr_timer_crtl_state = timer_Measure  and trig_activate_logic_p1='0') then
          timer_mesuring                <= '0';
          timer_irq_start_event_counter <= '0';
          timer_irq_end_event_counter   <= '1';
        else
          timer_mesuring                <= timer_mesuring;
          timer_irq_start_event_counter <= '0';
          timer_irq_end_event_counter   <= '0';
        end if;
      end if; 
    end if;
  end process;



  -------------------------
  -- IRQ mask
  -------------------------
  Timer_start_IRQ  <=    ( (timer_irq_start_event_timer or timer_irq_start_event_counter) and regfile.TimerStatus.TimerStartIntmaskn);   -- L'interrupt apparait seulement si le mask le permet, le registre IRQ sera plus haut dans la hierarchie.
  Timer_end_IRQ    <=    ( (timer_irq_end_event_timer   or timer_irq_end_event_counter)   and regfile.TimerStatus.TimerEndIntmaskn);     -- L'interrupt apparait seulement si le mask le permet, le registre IRQ sera plus haut dans la hierarchie.





  --------------------------------------------------
  --  TIMER TRIGGER LATCH OR RESET
  --------------------------------------------------
  process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if(sys_reset_n = '0') then
        trigger_overlap_db <= '0';
      else
        if(timer_running='1' and (regfile.TimerTriggerArm.TimerTriggerOverlap="01" or regfile.TimerTriggerArm.TimerTriggerOverlap="10") ) then
          if(trig_activate_logic='1') then
            if(regfile.TimerTriggerArm.TimerArmEnable='0' and regfile.TimerTriggerArm.TimerTriggerSource/="00000") then
              trigger_overlap_db <= '1';
            end if;
          end if;
        else
          trigger_overlap_db <= '0';
        end if;
      end if;
    end if;
  end process;


end functional;




