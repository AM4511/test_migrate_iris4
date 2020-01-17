------------------------------------------------------------------------------
-- File:        gige_quaddecoder.vhd
-- Decription:  Quadrature decoder for rotary encoders
--              
--              
-- 
-- Created by:  Jean-Francois Larin ing #121322
-- Date:        30 avril 2010
-- Project:     GatorEye
--
-- Modified by : Javier Mansilla
-- Date:         13 aout 2013
-- Project:      4sight GP fanless - RealTime IO
--
--
--
------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
library work;
--use work.regfile_spider_lpc_pack.all;
use work.spider_pak.all;


entity quaddecoder is
    port(
      sys_reset_n           : in  std_logic;
      sys_clk               : in  std_logic;

      DecoderCntrLatch_Src_MUX    : in  std_logic_vector;

      line_inputs           : in  std_logic_vector; -- all the possible event input lines.
      
      Qdecoder_out0         : out std_logic;
      --Qdecoder_out1         : out std_logic;
      
      regfile               : inout QUADRATURE_TYPE := INIT_QUADRATURE_TYPE
);
end quaddecoder;

architecture functionnal of quaddecoder is

  signal position_counter           : std_logic_vector(31 downto 0);
  signal max_position               : std_logic_vector(position_counter'range);
  signal counter_reset              : std_logic;
  --signal position_stamp             : std_logic_vector(position_counter'range);
  --signal counter_reset_p1           : std_logic;

  signal rewinded                   : std_logic;
  signal position_reset_muxed       : std_logic;
  signal position_reset_muxed_p1    : std_logic;
  signal counter_reset_activation   : std_logic;

  signal cwtick                     : std_logic;
  signal ccwtick                    : std_logic;  
  signal phase_A                    : std_logic;
  signal phase_B                    : std_logic;
  signal phase_A_p1                 : std_logic;
  signal phase_B_p1                 : std_logic;

  signal clockwisetick              : std_logic;
  signal counterclockwisetick       : std_logic;
  signal anytick                    : std_logic;
  signal newtick                    : std_logic;

  signal event_inputs               : std_logic_vector(line_inputs'length+1 downto 0);
  signal newtick_regen              : std_logic;

  --for latch coounter
  signal  DecoderCntrLatch_Src_AsInt       : integer;
  signal  DecoderCntrLatch_Source          : std_logic;
  signal  DecoderCntrLatch_Source_p1       : std_logic;
  signal  DecoderCntrLatch_Source_ris      : std_logic;
  signal  DecoderCntrLatch_Source_fal      : std_logic;
  signal  DecoderCntrLatch_activate        : std_logic:='0';
  signal  DecoderCntrLatch_activate_P1     : std_logic:='0';
  signal  DecoderCntrLatched               : std_logic_vector(position_counter'range):=(others=>'0');
  signal  DecoderCntrLatched_SW            : std_logic_vector(position_counter'range):=(others=>'0');

  
   
begin


  -------------------------------------------------------
  -- DECODER COUNTER LATCH SOURCE SELECT
  -------------------------------------------------------
  DecoderCntrLatch_Src_AsInt <= CONV_integer(regfile.DecoderCntrLatch_Cfg.DecoderCntrLatch_Src);

  process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if DecoderCntrLatch_Src_AsInt < DecoderCntrLatch_Src_MUX'length then
        DecoderCntrLatch_Source <= DecoderCntrLatch_Src_MUX(DecoderCntrLatch_Src_AsInt);
      else
        DecoderCntrLatch_Source <= '0';
      end if;
    end if;
  end process;

  -------------------------------------------------------
  -- DECODER COUNTER LATCH  Edge/Level detect in ACTIVATION LOGIC
  -------------------------------------------------------
  process(DecoderCntrLatch_Source, DecoderCntrLatch_Source_p1)
  begin
    DecoderCntrLatch_Source_ris  <= DecoderCntrLatch_Source and not(DecoderCntrLatch_Source_p1);   -- rising edge
    DecoderCntrLatch_Source_fal  <= not(DecoderCntrLatch_Source) and DecoderCntrLatch_Source_p1;   -- falling edge
  end process;

  process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      DecoderCntrLatch_Source_p1   <= DecoderCntrLatch_Source;
      -- On relentie le latch de un clk au cas ou on latche avec le meme signal que le quad compte.
      -- sinon on aurait la valeur precedente.
      DecoderCntrLatch_activate_P1 <= DecoderCntrLatch_activate;

      case regfile.DecoderCntrLatch_Cfg.DecoderCntrLatch_Act is
        when "00"   => DecoderCntrLatch_activate <= DecoderCntrLatch_Source_ris;                                --Rising Edge
        when "01"   => DecoderCntrLatch_activate <= DecoderCntrLatch_Source_fal;                                --Falling Edge
        when "10"   => DecoderCntrLatch_activate <= DecoderCntrLatch_Source_ris or DecoderCntrLatch_Source_fal; --ANY Edge
        when others => DecoderCntrLatch_activate <= '0';
      end case;
    end if;
  end process;

  -------------------------------------------------------
  -- LATCH CURRENT DECODER COUNTER COUNTER WITH HW INPUT
  -------------------------------------------------------
  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if(regfile.DecoderCntrLatch_Cfg.DecoderCntrLatch_En='1' and DecoderCntrLatch_activate_P1='1')  then
        DecoderCntrLatched     <= position_counter;
      end if;
    end if;
  end process;

  regfile.DecoderCntrLatched.DecoderCntr <= DecoderCntrLatched;

  ---------------------------------------------------------
  -- LATCH CURRENT DECODER COUNTER COUNTER WITH SW Snapshot
  ---------------------------------------------------------
  process(sys_clk)
  begin
    if(rising_edge(sys_clk)) then
      if(regfile.DecoderCntrLatch_Cfg.DecoderCntrLatch_SW='1')  then
        DecoderCntrLatched_SW     <= position_counter;
      end if;
    end if;
  end process;

  regfile.DecoderCntrLatched_SW.DecoderCntr <= DecoderCntrLatched_SW;




  -------------
  -- COUNTER --
  -------------
  countervalueprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then 
      if counter_reset = '1' then
        position_counter <= (others => '0');
      elsif cwtick = '1' then
        position_counter <= position_counter + 1;
      elsif ccwtick = '1' then
        position_counter <= position_counter - 1;
      end if;
    end if;
  end process;

  counter_reset <= '1' when  (sys_reset_n = '0' or regfile.DecoderCfg.QuadEnable='0' or regfile.PositionReset.soft_PositionReset='1' or counter_reset_activation='1') else '0';

  ------------
  -- REWIND --
  ------------
  rewindedprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if counter_reset = '1' then
        rewinded <= '0';
      elsif ccwtick = '1' then
        rewinded <= '1';  -- forcement, si on recule, on devient recule...
      elsif position_counter = max_position then
        rewinded <= '0';
      end if;
    end if;
  end process;
        
  -- on sauvegarde la position maximale de l'encodeur tout juste avant qu'il commence a reculer
  maxposprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if counter_reset = '1' then
        max_position <= (others => '0');
      elsif ccwtick = '1' and rewinded = '0' then
        max_position <= position_counter;
      end if;
    end if;
  end process;


  ---------------------------------
  -- MULTIPLEXOR FOR PHASE INPUT --
  ---------------------------------
  phamuxprc:process(line_inputs,regfile,sys_clk)
  begin
    if rising_edge(sys_clk) then 
      if conv_integer(regfile.DecoderInput.ASelector) < line_inputs'length then
        phase_A <= line_inputs(conv_integer(regfile.DecoderInput.ASelector));
      else
        phase_A <= '0';
      end if;
    end if;
  end process;

  phbmuxprc:process(line_inputs,regfile,sys_clk)
  begin
    if rising_edge(sys_clk) then 
      if conv_integer(regfile.DecoderInput.ASelector) < line_inputs'length then
        phase_B <= line_inputs(conv_integer(regfile.DecoderInput.BSelector));
      else
        phase_B <= '0';
      end if;
    end if;
  end process;

  --------------------
  -- PHASE DECODING --
  --------------------
  phdecprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      phase_A_p1 <= phase_A;
      phase_B_p1 <= phase_B;
      
      
      if regfile.DecoderCfg.QuadEnable='1' and phase_A = phase_B and phase_A = phase_B_p1 and phase_A /= phase_A_p1 then
        -- Transistion sur A ou A va rejoindre le niveau de B
        cwtick <= '1';
      elsif regfile.DecoderCfg.QuadEnable='1' and phase_A = phase_A_p1 and phase_A = phase_B_p1 and phase_A /= phase_B then
        -- Transistion sur B ou B se sépare de A
        cwtick <= '1';
      else
        cwtick <= '0';
      end if;

      if regfile.DecoderCfg.QuadEnable='1' and phase_A /= phase_B and phase_A /= phase_B_p1 and phase_A /= phase_A_p1 then
        -- Transistion sur A ou A se separe du niveau de B
        ccwtick <= '1';
      elsif regfile.DecoderCfg.QuadEnable='1' and phase_A = phase_A_p1 and phase_A /= phase_B_p1 and phase_A = phase_B then
        -- Transistion sur B ou B va rejoindre le niveau de A
        ccwtick <= '1';
      else
        ccwtick <= '0';
      end if;
      -- pour les autres transitions (illegales) on fait rien.
    end if;
  end process;
                
  ---------------------
  -- RESET SELECTION --
  ---------------------
  event_inputs(line_inputs'length+1 downto 0) <= newtick_regen & line_inputs & '0';              -- When set to 0x0, disable this mux, and only teh SW reset can reset the counter
  
  resetmuxprc:process(event_inputs,regfile)
  begin
    if conv_integer(regfile.PositionReset.PositionResetSource) < event_inputs'length then
      position_reset_muxed <= event_inputs(conv_integer(regfile.PositionReset.PositionResetSource));
    else
      position_reset_muxed <= '0';
    end if;
  end process;
  
  resetactprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      position_reset_muxed_p1 <= position_reset_muxed;
  
      case conv_integer(regfile.PositionReset.PositionResetActivation) is
        when 0 =>
          counter_reset_activation <= position_reset_muxed and not position_reset_muxed_p1;
        when 1 =>
          counter_reset_activation <= not position_reset_muxed and position_reset_muxed_p1;
      end case;
  
    end if;
  end process;

  -----------------------------
  -- GENERATION OF OUTPUTS   --
  -----------------------------

  process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      -- Generate Outputs
      clockwisetick         <= cwtick;
      counterclockwisetick  <= ccwtick;
      anytick               <= cwtick or ccwtick;
      newtick               <= cwtick and not rewinded;
      if(cwtick='1' and rewinded='0' and (regfile.DecoderPosTrigger.PositionTrigger = position_counter +'1')) then
        newtick_regen         <= '1';
      else
        newtick_regen         <= '0';
      end if;
    end if;
  end process;

  
  process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      case conv_integer(regfile.DecoderCfg.DecOutSource0) is
        when 0 =>
          Qdecoder_out0 <= newtick;
        when 1 =>
          Qdecoder_out0 <= clockwisetick;
        when 2 =>
          Qdecoder_out0 <= counterclockwisetick;
        when 3 =>
          Qdecoder_out0 <= anytick;
        when 4 =>
          Qdecoder_out0 <= newtick_regen;
        when others =>
          Qdecoder_out0 <= '0';
      end case;
    end if;
  end process;
  

--   process(sys_clk)
--   begin
--     if rising_edge(sys_clk) then
--       case conv_integer(regfile.DecoderCfg.DecOutSource1) is
--         when 0 =>
--           Qdecoder_out1 <= newtick;
--         when 1 =>
--           Qdecoder_out1 <= clockwisetick;
--         when 2 =>
--           Qdecoder_out1 <= counterclockwisetick;
--         when 3 =>
--           Qdecoder_out1 <= anytick;
--         when 4 =>
--           Qdecoder_out1 <= newtick_regen;
--         when others =>
--           Qdecoder_out1 <= '0';
--       end case;
--     end if;
--   end process;



end functionnal;



