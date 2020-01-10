-----------------------------------------------------------------------
-- $HeadURL: svn://brainstorm/fpga/trunk/Matrox/Imaging/FPGA/TickTable_core.vhd$
-- $Author: jmansill $
-- $Revision:  $
-- $Date: 2010-05-25 07:07:15 -0400 (Tue, 25 May 2010) $
--
-- DESCRIPTION: Spider TickTable Core
--              la largeur de la table est determinee par la largeur du parametre TickTable_Out
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
use work.spider_pak.all;

entity TickTable is
   generic( int_number        : integer :=1;
            wa_int_number     : integer := 4; -- parametre deprecie, mis a une valeur par defaut juste pour etre backward compatible avec les top qui l'appellerait
            CLOCK_PERIOD      : integer :=30  -- 30 pour GPM, 40 pour GPM-Atom
           );
   port (
    ---------------------------------------------------------------------
    -- Reset and clock signals
    ---------------------------------------------------------------------
    sys_reset_n                          : in    std_logic;
    sys_clk                              : in    std_logic;
    
    ---------------------------------------------------------------------
    -- Inputs
    ---------------------------------------------------------------------
    TickClock_MUX                        : in  std_logic_vector;
    InputStampSource_MUX                 : in  std_logic_vector;
    
    ---------------------------------------------------------------------
    -- Output signal: noiseless
    ---------------------------------------------------------------------
    TickTable_Out                        : out   std_logic_vector;

    ---------------------------------------------------------------------
    -- IRQ for HALF done, ALL DONE and Wrap Around
    ---------------------------------------------------------------------
    Ticktable_half_IRQ                   : out   std_logic;
    Ticktable_WA_IRQ                     : out   std_logic;
    TickTable_latch_IRQ                  : out   std_logic := '0'; -- pour ne pas avoir a resetter
    
    ---------------------------------------------------------------------
    -- REGISTER 
    ---------------------------------------------------------------------
    regfile                              : inout TickTable_TYPE := INIT_TickTable_TYPE
  );
end TickTable;


architecture functional of TickTable is

-----------------------------------------------------
-- Components
-----------------------------------------------------
-- COMPONENT xil_ticktable
--   PORT (
--     clka  : IN  STD_LOGIC;
--     rsta  : IN  STD_LOGIC;
--     ena   : IN  STD_LOGIC;
--     wea   : IN  STD_LOGIC;--_VECTOR(0 DOWNTO 0);
--     addra : IN  STD_LOGIC_VECTOR(12 DOWNTO 0);
--     dina  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
--     douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
--     --clkb  : IN  STD_LOGIC;
--     rstb  : IN  STD_LOGIC;
--     enb   : IN  STD_LOGIC;
--     web   : IN  STD_LOGIC;--_VECTOR(0 DOWNTO 0);
--     addrb : IN  STD_LOGIC_VECTOR(12 DOWNTO 0);
--     dinb  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
--     doutb : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
--   );
-- END COMPONENT;

-- version parametrisee
component xil_ticktable is 
generic (
    RAM_WIDTH : integer := 16;                      -- Specify RAM data width
    RAM_PERFORMANCE : string := "LOW_LATENCY"       -- Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
    );

port (
        addra : in std_logic_vector(12 downto 0);     -- Port A Address bus, width determined from RAM_DEPTH
        addrb : in std_logic_vector(12 downto 0);     -- Port B Address bus, width determined from RAM_DEPTH
        dina  : in std_logic_vector(RAM_WIDTH-1 downto 0);		  -- Port A RAM input data
        dinb  : in std_logic_vector(RAM_WIDTH-1 downto 0);		  -- Port B RAM input data
        clka  : in std_logic;                       			  -- Clock
        wea   : in std_logic;                       			  -- Port A Write enable
        web   : in std_logic;                       			  -- Port B Write enable
        ena   : in std_logic;                       			  -- Port A RAM Enable, for additional power savings, disable port when not in use
        enb   : in std_logic;                       			  -- Port B RAM Enable, for additional power savings, disable port when not in use
        rsta  : in std_logic;                       			  -- Port A Output reset (does not affect memory contents)
        rstb  : in std_logic;                       			  -- Port B Output reset (does not affect memory contents)
--         regcea: in std_logic;                       			  -- Port A Output register enable
--         regceb: in std_logic;                       			  -- Port B Output register enable
        douta : out std_logic_vector(RAM_WIDTH-1 downto 0);   			  --  Port A RAM output data
        doutb : out std_logic_vector(RAM_WIDTH-1 downto 0)   			  --  Port B RAM output data
    );                                            

end component;



-----------------------------------------------------
-- signals
-----------------------------------------------------
constant TABLE_WIDTH             : integer := TickTable_Out'length; -- on determine la largeur en fonction de ce parametre

signal  sys_reset                : std_logic;

type    type_InputStampSource_AsInt is array (TICKTABLE_INPUTSTAMP_TYPE_ARRAY'range) of integer;
type    type_InputStampLatched      is array (TICKTABLE_INPUTSTAMP_TYPE_ARRAY'range) of std_logic_vector(31 downto 0);
signal  InputStampSource_AsInt   : type_InputStampSource_AsInt;
signal  InputStampLatched        : type_InputStampLatched;
signal  input_stamp_src          : std_logic_vector(TICKTABLE_INPUTSTAMP_TYPE_ARRAY'range);
signal  input_stamp_src_p1       : std_logic_vector(TICKTABLE_INPUTSTAMP_TYPE_ARRAY'range);
signal  input_stamp_src_ris      : std_logic_vector(TICKTABLE_INPUTSTAMP_TYPE_ARRAY'range);
signal  input_stamp_src_fal      : std_logic_vector(TICKTABLE_INPUTSTAMP_TYPE_ARRAY'range);
signal  input_stamp_activate     : std_logic_vector(TICKTABLE_INPUTSTAMP_TYPE_ARRAY'range);

signal  clk_cntr                 : std_logic_vector(12 downto 0);
signal  Clk_Int                  : std_logic;

signal  TickClkSource_AsInt      : integer;
signal  TickClock_MUX_CLK        : std_logic_vector(TickClock_MUX'high downto 0);
signal  Tick_clock_src           : std_logic;
signal  Tick_clock_src_p1        : std_logic;
signal  Tick_clock_src_ris       : std_logic;
signal  Tick_clock_src_fal       : std_logic;
signal  tick_clock               : std_logic;        -- signal qui clock le timestamp
signal  tick_clock_p1            : std_logic;
signal  tick_clock_p2            : std_logic;
signal  tick_clock_p3            : std_logic;
signal  tick_WEA                 : std_logic;--_vector(0 downto 0);
signal  tick_ENA                 : std_logic;
signal  tick_DOUTA               : std_logic_vector(2*TABLE_WIDTH-1 downto 0);
constant tick_DINA               : std_logic_vector(2*TABLE_WIDTH-1 downto 0):= (others => '0'); --Pour effacer une element de la tick table
signal  tick_ADDRA               : std_logic_vector(12 downto 0);

signal  TickTable_Out_int        : std_logic_vector(TABLE_WIDTH-1 downto 0);

signal  TimeStamp                : std_logic_vector(31 downto 0);
signal  TimeStamp_31b_p1         : std_logic;
signal  CurrentStampLatched      : std_logic_vector(31 downto 0);

type    type_acc_state is (acc_idle, acc_latch, acc_clear_read, acc_clear_write, acc_reset, acc_read, acc_write, acc_succ, acc_fail);

signal  next_acc_state        :  type_acc_state;
signal  curr_acc_state        :  type_acc_state;

signal  next_acc_latch_timestamp  :  std_logic;
signal  next_acc_WEB              :  std_logic;
signal  next_acc_ENB              :  std_logic;
signal  next_acc_latch_status     :  std_logic;
signal  next_acc_ok               :  std_logic;

signal  acc_latch_timestamp   :  std_logic;
signal  acc_WEB               :  std_logic;--_vector(0 downto 0);
signal  acc_ENB               :  std_logic;
signal  acc_DINB              :  std_logic_vector(2*TABLE_WIDTH-1 downto 0);
signal  acc_DOUTB             :  std_logic_vector(2*TABLE_WIDTH-1 downto 0);
signal  acc_ADDRB             :  std_logic_vector(12 downto 0);

signal  acc_latch_status      :  std_logic;
signal  acc_ok                :  std_logic;

signal  write_timestamp       :  std_logic_vector(31 downto 0);
signal  imm_access            :  std_logic;

signal  WriteStatus           :  std_logic;
signal  WriteDone             : std_logic;
signal  TimeStamp_MSB_P1      :  std_logic;

signal  ResetTimestamp_p1     :  std_logic;
signal  acc_reset_table       :  std_logic;
signal  next_acc_reset_table  :  std_logic;

signal  ClearTickTable_p1     :  std_logic;
signal  acc_clear_table       :  std_logic;
signal  next_acc_clear_table  :  std_logic;

begin

  --IRQ location in INT_STAT REGISTER
  regfile.CAPABILITIES_TICKTBL.INTNUM <= conv_std_logic_vector(int_number,5);
  --regfile.CAPABILITIES_TICKTBL.INTNUM_WA <= conv_std_logic_vector(wa_int_number,5); deprecie
  
  --Registre de periode
  regfile.TickTableClockPeriod.Period_ns <= conv_std_logic_vector(CLOCK_PERIOD, 8);

  GEN_INPUTSTAMP : for NB_IN_STAMP in TICKTABLE_INPUTSTAMP_TYPE_ARRAY'range generate

    -------------------------------------------------------
    -- INPUT STAMP SOURCE SELECT
    -------------------------------------------------------
    InputStampSource_AsInt(NB_IN_STAMP) <= CONV_integer(regfile.InputStamp(NB_IN_STAMP).InputStampSource);

    process(sys_clk)
    begin
      if rising_edge(sys_clk) then
        if InputStampSource_AsInt(NB_IN_STAMP) < InputStampSource_MUX'length then
          input_stamp_src(NB_IN_STAMP) <= InputStampSource_MUX(InputStampSource_AsInt(NB_IN_STAMP));
        else
          input_stamp_src(NB_IN_STAMP) <= '0';
        end if;
      end if;
    end process;  

    -------------------------------------------------------
    -- INPUT STAMP SOURCE  Edge/Level detect in ACTIVATION LOGIC
    -------------------------------------------------------
    process(input_stamp_src, input_stamp_src_p1)
    begin
      input_stamp_src_ris(NB_IN_STAMP)  <= input_stamp_src(NB_IN_STAMP) and not(input_stamp_src_p1(NB_IN_STAMP));   -- rising edge
      input_stamp_src_fal(NB_IN_STAMP)  <= not(input_stamp_src(NB_IN_STAMP)) and input_stamp_src_p1(NB_IN_STAMP);   -- falling edge
    end process;

    process(sys_clk)
    begin
      if rising_edge(sys_clk) then
        input_stamp_src_p1(NB_IN_STAMP) <= input_stamp_src(NB_IN_STAMP);
        case regfile.InputStamp(NB_IN_STAMP).InputStampActivation is
          when "00"   => input_stamp_activate(NB_IN_STAMP) <= input_stamp_src_ris(NB_IN_STAMP);                        --Rising Edge
          when "01"   => input_stamp_activate(NB_IN_STAMP) <= input_stamp_src_fal(NB_IN_STAMP);                        --Falling Edge
          when "10"   => input_stamp_activate(NB_IN_STAMP) <= input_stamp_src_ris(NB_IN_STAMP) or input_stamp_src_fal(NB_IN_STAMP); --ANY Edge
          when others => input_stamp_activate(NB_IN_STAMP) <= '0';
        end case;
      end if;
    end process;

    -------------------------------------------------------
    -- LATCH CURRENT TIME_STAMP COUNTER WITH HW INPUT
    -------------------------------------------------------
    process(sys_clk)
    begin
      if(rising_edge(sys_clk)) then
        if(sys_reset_n='0' or regfile.TickConfig.ResetTimestamp='1') then
          InputStampLatched(NB_IN_STAMP)     <= (others=>'0');
        elsif(regfile.InputStamp(NB_IN_STAMP).LatchInputStamp_En='1' and input_stamp_activate(NB_IN_STAMP)='1') then
          InputStampLatched(NB_IN_STAMP)     <= TimeStamp;
        end if;
        -- interruption sur les latchs
        -- on genere un set sur la meme conditions que le latch, en AND avec le enable de l'interruption
        regfile.LatchIntStat.LatchIntStat_set(NB_IN_STAMP) <= regfile.InputStamp(NB_IN_STAMP).LatchInputStamp_En and input_stamp_activate(NB_IN_STAMP) and regfile.InputStamp(NB_IN_STAMP).LatchInputIntEnable;
      end if;
    end process;

    regfile.InputStampLatched(NB_IN_STAMP).InputStamp <= InputStampLatched(NB_IN_STAMP);

  end generate;  -- INPUT STAMP SOURCE SELECT

  -- Je fais un OR de toutes les sources d'interrupt sur latch pour l'envoyer au registre principal
  orintprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if conv_integer(regfile.LatchIntStat.LatchIntStat) = 0 then  
        -- il n'y a aucune interruption active, on ne forward rien au registre global
        TickTable_latch_IRQ <= '0';
      else
        TickTable_latch_IRQ <= '1';
      end if;
    end if;
  end process;

  -------------------------------------------------------
  -- SLOW CLOCK GENERATION from 33.33333mhz (T=30ns)
  -- Default : Tclk =2048*30ns = 61.440us, 16.276 khz
  -------------------------------------------------------
  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if(sys_reset_n='0' or regfile.TickConfig.IntClock_en='0') then
        clk_cntr        <= (others=>'0');
      else
        clk_cntr        <= clk_cntr+'1';
        
      end if;
    end if;
  end process;

  Clk_Int <= Clk_cntr(12) when regfile.TickConfig.IntClock_sel="00" else     -- GPM:   4.069 khz    GPM-Atom:    3.05175 khz
             Clk_cntr(10) when regfile.TickConfig.IntClock_sel="01" else     -- GPM:  16.276 khz    GPM-Atom:     12.207 khz    (default)
             Clk_cntr(9)  when regfile.TickConfig.IntClock_sel="10" else     -- GPM:  32.552 khz    GPM-Atom:     24.414 khz
             Clk_cntr(7);                                                    -- GPM: 130.208 khz    GPM-Atom:     97.656 khz


  -------------------------------------------------------
  -- TICK CLOCK SOURCE LOGIC
  -------------------------------------------------------
  TickClock_MUX_CLK        <= TickClock_MUX & Clk_Int;
  
  TickClkSource_AsInt      <= CONV_integer(regfile.TickConfig.TickClock);

  process(sys_clk)
  begin
    if rising_edge(sys_clk) then

      if TickClkSource_AsInt < TickClock_MUX_CLK'length then
        Tick_clock_src <= TickClock_MUX_CLK(TickClkSource_AsInt);
      else
        Tick_clock_src <= '0';
      end if;
        
    end if;
  end process;


  -------------------------------------------------------
  -- TICK CLOCK SOURCE  Edge/Level detect in ACTIVATION LOGIC
  -------------------------------------------------------
  process(Tick_clock_src, Tick_clock_src_p1)
  begin
    Tick_clock_src_ris  <= Tick_clock_src and not(Tick_clock_src_p1);   -- rising edge
    Tick_clock_src_fal  <= not(Tick_clock_src) and Tick_clock_src_p1;   -- falling edge
  end process;


  -------------------------------------------------------
  -- INPUT CLOCK SOURCE  rising edge detect
  -------------------------------------------------------
  process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if(sys_reset_n='0') then
        Tick_clock_src_p1       <= '0';
        tick_clock              <= '0';
      else
        Tick_clock_src_p1 <= Tick_clock_src;
        case regfile.TickConfig.TickClockActivation is
          when "00"   => tick_clock        <= Tick_clock_src_ris;                        --Rising Edge
          when "01"   => tick_clock        <= Tick_clock_src_fal;                        --Falling Edge
          when "10"   => tick_clock        <= Tick_clock_src_ris or Tick_clock_src_fal;  --ANY Edge
          when others => tick_clock        <= '0';
        end case;
      end if;
    end if;
  end process;



  -------------------------------------------------------
  -- TIME_STAMP COUNTER
  -------------------------------------------------------
  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if(sys_reset_n='0' or regfile.TickConfig.ResetTimestamp='1') then
        TimeStamp       <= (others=>'0');
      elsif(tick_clock='1') then
        TimeStamp       <= TimeStamp+'1';
      end if;
    end if;
  end process;

  -------------------------------------------------------
  -- TIME_STAMP WRAP AROUND IRQ
  -------------------------------------------------------
  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if(sys_reset_n='0' or regfile.TickConfig.ResetTimestamp='1') then     -- faut reseter pour pas creer un IRQ
        TimeStamp_31b_p1 <= '0';
      else
        TimeStamp_31b_p1 <= TimeStamp(31);
      end if;
      
      if(sys_reset_n='0') then
        Ticktable_WA_IRQ  <= '0';
      elsif(TimeStamp(31)='0' and TimeStamp_31b_p1='1') then
        Ticktable_WA_IRQ  <= '1';
      else
        Ticktable_WA_IRQ  <= '0';
      end if;
      
    end if;
  end process;

  

  -------------------------------------------------------
  -- LATCH CURRENT TIME_STAMP COUNTER WITH SW-SS
  -------------------------------------------------------
  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if(sys_reset_n='0' or regfile.TickConfig.ResetTimestamp='1') then
        CurrentStampLatched     <= (others=>'0');
      elsif(regfile.TickConfig.LatchCurrentStamp='1') then
        CurrentStampLatched     <= TimeStamp;
      end if;
    end if;
  end process;
  
  regfile.CurrentStampLatched.CurrentStamp <= CurrentStampLatched;
  

-------------------------------------------------------
-- PORT A - TICK USEROUT from tick table
-------------------------------------------------------
  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if(sys_reset_n='0' or regfile.TickConfig.ResetTimestamp='1') then
        Tick_clock_p1      <= '0';
        Tick_clock_p2      <= '0';
        Tick_clock_p3      <= '0';
      else
        Tick_clock_p1   <= tick_clock;
        Tick_clock_p2   <= Tick_clock_p1;
        Tick_clock_p3   <= Tick_clock_p2;
      end if;
      
      if(sys_reset_n='0') then
        tick_ENA     <= '0';
      elsif(tick_clock = '1' or Tick_clock_p1='1') then    -- READ or WRITE
        tick_ENA     <= '1';
      else
        tick_ENA     <= '0';
      end if;
    end if;
  end process;

  tick_WEA <= Tick_clock_p2;

  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      for i in 0 to TABLE_WIDTH-1 loop
        if(sys_reset_n='0' or regfile.TickConfig.ResetTimestamp='1') then
          TickTable_Out_int(i)   <= '0';
        elsif(Tick_clock_p2 = '1') then
          if(tick_DOUTA(((i*2)+1) downto (i*2) ) = "01") or (tick_DOUTA(((i*2)+1) downto (i*2) ) = "11") then     -- Rising
            TickTable_Out_int(i) <= '1';
          elsif(tick_DOUTA(((i*2)+1) downto (i*2) ) = "10") then                                                  -- Falling
            TickTable_Out_int(i) <= '0';
          else                                                                                                    -- don't touch
            TickTable_Out_int(i) <= TickTable_Out_int(i);
          end if;
        elsif(Tick_clock_p3 = '1') then                                                                           -- Falling of the Rise then fall
          if(tick_DOUTA(((i*2)+1) downto (i*2) ) = "11") then
            TickTable_Out_int(i) <= '0';
          else
            TickTable_Out_int(i) <= TickTable_Out_int(i);
          end if;
        end if;
      end loop;
    end if;
  end process;

  TickTable_Out <= TickTable_Out_int;




-------------------------------------------------------
-- PORT B - VIRTUAL USER DATA WRITE-
-------------------------------------------------------
  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if(sys_reset_n='0') then
        ResetTimestamp_p1  <= '0';
        ClearTickTable_p1  <= '0';
      else
        ResetTimestamp_p1  <= regfile.TickConfig.ResetTimestamp;
        ClearTickTable_p1  <= regfile.TickConfig.ClearTickTable;
      end if;
    end if;
  end process;
  
  -------------------------------------------------------
  -- Control State machine
  -------------------------------------------------------

  process(curr_acc_state, regfile, tick_clock, tick_ENA, TimeStamp, write_timestamp, imm_access, ResetTimestamp_p1, ClearTickTable_p1)
  begin
    case curr_acc_state is
    
      when  acc_idle        => if(regfile.WriteCommand.ExecuteFutureWrite='1' or regfile.WriteCommand.ExecuteImmWrite='1' or regfile.TickConfig.ResetTimestamp='1' or regfile.TickConfig.ClearTickTable='1') then
                                 next_acc_state  <= acc_latch;
                               else
                                 next_acc_state  <= acc_idle;
                               end if;

      when  acc_latch       => if(ClearTickTable_p1='1') then
                                 next_acc_state  <= acc_clear_read;
                               elsif(ResetTimestamp_p1='0') then
                                 next_acc_state  <= acc_read;
                               else
                                 next_acc_state  <= acc_reset;
                               end if;

      when  acc_clear_read  => if(tick_clock='1' or tick_ENA='1') then   -- on re-initialise la lecture pour n'est pas tomber dans une collision
                                 next_acc_state  <= acc_clear_read;
                               else
                                 next_acc_state  <= acc_clear_write;
                               end if;

      when  acc_clear_write => if(write_timestamp(12 DOWNTO 0)=X"0000") then     --8k elements modified : Write start=0x0001, Last write is 0x0000,
                                 next_acc_state  <= acc_succ;
                               else
                                 next_acc_state  <= acc_clear_read;
                               end if;
                               
      when  acc_reset       => if(write_timestamp(12 DOWNTO 0)=X"0000") then     --8k
                                 next_acc_state  <= acc_succ;
                               else
                                 next_acc_state  <= acc_reset;
                               end if;
                               
      when  acc_read        => if(tick_clock='1' or tick_ENA='1') then   -- on re-initialise la lecture pour n'est pas tomber dans une collision
                                 next_acc_state  <= acc_read;
                               elsif(CONV_integer(write_timestamp) > CONV_integer(TimeStamp)) or 
                                    (write_timestamp(31 downto 13)="0000000000000000000" and TimeStamp(31 downto 13)="1111111111111111111" )  then     --pour la gestion du wrap around du buffer
                                 next_acc_state  <= acc_write;
                               else
                                 next_acc_state  <= acc_fail;
                               end if;
                                 
      when  acc_write       => next_acc_state  <=  acc_succ;

      when  acc_succ        => next_acc_state  <=  acc_idle;

      when  acc_fail        => if(imm_access='1') then                 -- on reprend l'access
                                 next_acc_state  <=  acc_latch;
                               else
                                 next_acc_state  <=  acc_idle;
                               end if;
    end case;
  end process;



  process(next_acc_state)
  begin
    case next_acc_state is
      when  acc_idle        => next_acc_latch_timestamp <='0';
                               next_acc_WEB             <='0';
                               next_acc_ENB             <='0';
                               next_acc_latch_status    <='0';
                               next_acc_ok              <='0';
                               next_acc_reset_table     <='0';
                               next_acc_clear_table     <='0';
                               
      when  acc_latch       => next_acc_latch_timestamp <='1';
                               next_acc_WEB             <='0';
                               next_acc_ENB             <='0';
                               next_acc_latch_status    <='0';
                               next_acc_ok              <='0';
                               next_acc_reset_table     <='0';
                               next_acc_clear_table     <='0';

      when  acc_clear_read  => next_acc_latch_timestamp <='0';
                               next_acc_WEB             <='0';
                               next_acc_ENB             <='1';
                               next_acc_latch_status    <='0';
                               next_acc_ok              <='0';
                               next_acc_reset_table     <='0';
                               next_acc_clear_table     <='0';

      when  acc_clear_write => next_acc_latch_timestamp <='0';
                               next_acc_WEB             <='1';
                               next_acc_ENB             <='1';
                               next_acc_latch_status    <='0';
                               next_acc_ok              <='0';
                               next_acc_reset_table     <='0';
                               next_acc_clear_table     <='1';

      when  acc_reset       => next_acc_latch_timestamp <='0';
                               next_acc_WEB             <='1';
                               next_acc_ENB             <='1';
                               next_acc_latch_status    <='0';
                               next_acc_ok              <='0';
                               next_acc_reset_table     <='1';
                               next_acc_clear_table     <='0';

      when  acc_read        => next_acc_latch_timestamp <='0';
                               next_acc_WEB             <='0';
                               next_acc_ENB             <='1';
                               next_acc_latch_status    <='0';
                               next_acc_ok              <='0';
                               next_acc_reset_table     <='0';
                               next_acc_clear_table     <='0';

      when  acc_write       => next_acc_latch_timestamp <='0';
                               next_acc_WEB             <='1';
                               next_acc_ENB             <='1';
                               next_acc_latch_status    <='0';
                               next_acc_ok              <='0';
                               next_acc_reset_table     <='0';
                               next_acc_clear_table     <='0';

      when  acc_succ        => next_acc_latch_timestamp <='0';
                               next_acc_WEB             <='0';
                               next_acc_ENB             <='0';
                               next_acc_latch_status    <='1';
                               next_acc_ok              <='1';
                               next_acc_reset_table     <='0';
                               next_acc_clear_table     <='0';

      when  acc_fail        => next_acc_latch_timestamp <='0';
                               next_acc_WEB             <='0';
                               next_acc_ENB             <='0';
                               next_acc_latch_status    <='1';
                               next_acc_ok              <='0';
                               next_acc_reset_table     <='0';
                               next_acc_clear_table     <='0';
    end case;
  end process;


  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if(sys_reset_n='0') then
        curr_acc_state      <= acc_idle;
        acc_latch_timestamp <='0';
        acc_WEB             <='0';
        acc_ENB             <='0';
        acc_latch_status    <='0';
        acc_ok              <='0';
        acc_reset_table     <='0';
        acc_clear_table     <='0';
      else
        curr_acc_state      <= next_acc_state;
        acc_latch_timestamp <= next_acc_latch_timestamp;
        acc_WEB             <= next_acc_WEB;
        acc_ENB             <= next_acc_ENB;
        acc_latch_status    <= next_acc_latch_status;
        acc_ok              <= next_acc_ok;
        acc_reset_table     <= next_acc_reset_table;
        acc_clear_table     <= next_acc_clear_table;
      end if;  
    end if;
  end process;



-------------------------------------------------------
-- Double buffer ADDRESS
-------------------------------------------------------
  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if(acc_latch_timestamp='1') then
        if(ClearTickTable_p1='1') then
          write_timestamp <= X"00000001";                       -- pour le clear on part de 0x0001 et on arrete a 0x0000, pour simplifier la logique genere
        elsif(imm_access='1' or ResetTimestamp_p1='1') then
          write_timestamp <= TimeStamp+'1';                 -- pour le reset on part de 0x0001 et on arrete a 0x0000, pour simplifier la logique genere
        else
          write_timestamp <= regfile.WriteTime.WriteTime;   --Future Access or Reset table : adresse initiale pour l'effacement.
        end if;
      elsif(acc_reset_table='1' or acc_clear_table='1') then
        write_timestamp <= write_timestamp+'1';             --Inc adresse d'effacement
      end if;
    end if;
  end process;


-------------------------------------------------------
-- IMMINENT ACCESS 
-------------------------------------------------------
  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
        if(regfile.WriteCommand.ExecuteImmWrite='1') and (regfile.TickConfig.ClearTickTable ='0' and ClearTickTable_P1 ='0' and WriteDone='1') then  -- Lors d'un clear on accepte pas d'autre CMD jusqu'a la fin du clear
          imm_access <= '1';
        elsif(acc_latch_status='1' and acc_ok='1') then        -- a la fin de l'access on efface le imm_access
          imm_access <= '0';
        else
          imm_access <= imm_access;
        end if;
    end if;
  end process;

-------------------------------------------------------
-- Formatting data to write into ticktable
-------------------------------------------------------
--   acc_DINB(1 downto 0)   <=  "00" when acc_reset_table='1' else regfile.WriteCommand.BitCmd  when regfile.WriteCommand.BitNum="000" else acc_DOUTB(1 downto 0);
--   acc_DINB(3 downto 2)   <=  "00" when acc_reset_table='1' else regfile.WriteCommand.BitCmd  when regfile.WriteCommand.BitNum="001" else acc_DOUTB(3 downto 2);
--   acc_DINB(5 downto 4)   <=  "00" when acc_reset_table='1' else regfile.WriteCommand.BitCmd  when regfile.WriteCommand.BitNum="010" else acc_DOUTB(5 downto 4);
--   acc_DINB(7 downto 6)   <=  "00" when acc_reset_table='1' else regfile.WriteCommand.BitCmd  when regfile.WriteCommand.BitNum="011" else acc_DOUTB(7 downto 6);
--   acc_DINB(9 downto 8)   <=  "00" when acc_reset_table='1' else regfile.WriteCommand.BitCmd  when regfile.WriteCommand.BitNum="100" else acc_DOUTB(9 downto 8);
--   acc_DINB(11 downto 10) <=  "00" when acc_reset_table='1' else regfile.WriteCommand.BitCmd  when regfile.WriteCommand.BitNum="101" else acc_DOUTB(11 downto 10);
--   acc_DINB(13 downto 12) <=  "00" when acc_reset_table='1' else regfile.WriteCommand.BitCmd  when regfile.WriteCommand.BitNum="110" else acc_DOUTB(13 downto 12);
--   acc_DINB(15 downto 14) <=  "00" when acc_reset_table='1' else regfile.WriteCommand.BitCmd  when regfile.WriteCommand.BitNum="111" else acc_DOUTB(15 downto 14);

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- jmansill: Bug trouve par schampagne lors d'un clear :
--
-- Lorsqu'un clear etait effectue sur un ou plusieurs userout, les userout qui n'etaient pas cleares, auraient pu etre corrompus par la 3) condition ci-dessous.
-- Le data ecrit dans la location du userout non cleare defini par regfile.WriteCommand.BitNum etait la valeur contenue dans regfile.WriteCommand.BitCmd au lieu 
-- de la valeur lue dans la RAM. Je regle le probleme dans le vhdl en rajoutant la condition acc_clear_table='0' dans 3).
--
-- Pour n'est pas regenerer tous les FPGAs, le driver va aller mettre regfile.WriteCommand.BitNum a la valeur d'un des bits qui vont etre cleares. Comme ca on evite le bug.
-- 
-- On augmente le feature_rev de la ticktable a 0x2, pour identifier ce probleme. 
--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  fdwriteloopgen: for i in 0 to TABLE_WIDTH-1 generate
    acc_DINB(i*2+1 downto i*2) <=  "00"                         when acc_reset_table='1' else                                                            --1)
                                   "00"                         when (acc_clear_table='1' and regfile.TickConfig.ClearMask(i) = '0') else                --2)
                                   regfile.WriteCommand.BitCmd  when (acc_clear_table='0' and conv_integer(regfile.WriteCommand.BitNum) = i) else        --3)
                                   acc_DOUTB(i*2+1 downto i*2);                                                                                          --4)
  end generate;

-------------------------------------------------------
-- WRITE TABLE STATUS and DONE READBACK
-------------------------------------------------------
  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if(sys_reset_n='0') then
        WriteStatus <= '0';
        WriteDone   <= '1';
      elsif(acc_latch_timestamp='1') then         -- on reset le status au debut de l'access (futur, immediat et reset)
        WriteStatus <= '0';
        WriteDone   <= '0';
      elsif(acc_latch_status='1')then
        WriteDone   <= '1';
        if(acc_ok='1') then
          WriteStatus <= '1';
        else
          WriteStatus <= '0';
        end if;
      else
        WriteStatus <= WriteStatus;
        WriteDone   <= WriteDone;
      end if;
    end if;
  end process;

  regfile.WriteCommand.WriteStatus <= WriteStatus;
  regfile.WriteCommand.WriteDone   <= WriteDone;

-------------------------------------------------------
-- IRQ GENERATION  FIRST HALF - SECOND HALF OF TICKTABLE
-------------------------------------------------------
  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if(sys_reset_n='0' or regfile.TickConfig.ResetTimestamp='1') then    -- faut reseter pour pas creer un IRQ
        TimeStamp_MSB_P1 <= '0';
      else
        TimeStamp_MSB_P1 <= TimeStamp(12);
      end if;
      
      if(sys_reset_n='0') then
        Ticktable_half_IRQ <= '0';
      elsif(regfile.TickConfig.EnableHalftableInt='1') then
        if(TimeStamp(12)='1' and TimeStamp_MSB_P1='0') or (TimeStamp(12)='0'and TimeStamp_MSB_P1='1') then
          Ticktable_half_IRQ <= '1';
        else
          Ticktable_half_IRQ <= '0';
        end if;
      else
        Ticktable_half_IRQ <= '0'; 
      end if;
    end if;
  end process;





-------------------------------------------------------
-- XILINX RAM for tick table
-------------------------------------------------------
sys_reset <= not(sys_reset_n);

tick_ADDRA <= TimeStamp(12 DOWNTO 0);             --Pour voir facilement ds SIM
acc_ADDRB  <= write_timestamp(12 DOWNTO 0);       --Pour voir facilement ds SIM

xil_ticktable_RAM : xil_ticktable
  generic map(
    RAM_WIDTH => tick_DINA'length
  )
  PORT MAP (
    clka   =>  sys_clk,
    rsta   =>  sys_reset,
    
    ena    =>  tick_ENA,
    wea    =>  tick_WEA,
    addra  =>  tick_ADDRA,
    dina   =>  tick_DINA,
    douta  =>  tick_DOUTA,
    
    --clkb   =>  sys_clk,
    rstb   =>  sys_reset,
    enb    =>  acc_ENB,
    web    =>  acc_WEB,
    addrb  =>  acc_ADDRB,
    dinb   =>  acc_DINB,
    doutb  =>  acc_DOUTB
  );




end functional;
    