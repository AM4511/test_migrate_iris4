-----------------------------------------------------------------------
-- $HeadURL: svn://brainstorm/fpga/trunk/Matrox/Imaging/FPGA/Iris3/cores/i2c/design/i2c_if.vhd $
-- $Author: jmansill $
-- $Revision: 18754 $
-- $Date: 2018-06-21 10:14:44 -0400 (Thu, 21 Jun 2018) $
--
-- DESCRIPTION: TOP DU CORE I2C
-- 
-- VHDL Behavioral Description of an Automatic I2C Interface
-- Date : June 6th 2000
-- Author : Nicolas Ouellet
-- Modifie par : Jean-Francois Larin, jmansill
-- Matrox Electronic Systems Ltd.
--
-- TO DO list:
--
-- Currently, every access (clock cycle) is divided in 3 states.  In the first state
-- the clock is low and the data is set.  In the middle state, the clock is high. In the
-- last state the clock is low (so the clock stays low at least 2 times longer than the
-- high state, as the ADV7185 spec specifies...
-- First, we should add clock stretching.  To do that, we have to raise the clock
-- and then wait until the clock has risen (because the target device MAY hold the clock
-- down) and then start counting the high time. If we have 3 state, we can use an input frequency
-- 3 times the nominal data rate. If we add the clock stretching, then we must add 1 clock cycle
-- while the clock is high. 
--
-- The proposition is to overclock and add 3 generics. first generics is the length of the
-- first state (clock low) in clock cycles.  The second is the length of the clock high. The
-- Third is the length of the last state (Clock low).  Then the real total clock low time will
-- be the sum of the first and last state clock time and the nominal frequency (when the target
-- doesn't hold the clock) will be the input frequency divided by (Tlow1+Thigh+Tlow2+1)
-- (+1) is for the time the machine waits to check the clock
--
--
-- jmansill- 8 Novembre 2005 
-- Ajoute le support pour les read 1 byte sans adresse, pour pouvoir supporter les Eprom sur le CCU
-- Le generique NI_ACCESS a ete ajoute.
--
-- jmansill 25 fevrier 2008
-- Rentre le bus register file genere par le fdk.
-- Enleve les instances event_resync
--
-- jmansill 10 mars
-- Enleve l'appel au log2, ca ne marche pas avec une seule interface. Le registre de selection est de 
-- 2 bits ds le registerfile, comme ca on apourrait avoir jusqu'a 4 if. Dans l'Iris on aura juste une. 
-- Nexis2 pourrait avoir besoin de plus, on va donc laisser le feature la. Il consomme pas de logique 
-- en synthese.
-- 
-- jmansill 10 mars 2011
-- Le data envoye par le fpga sort maintenant une demi-periode clock interne apres le falling de smb_clk externe.
-- Avant il sortait une periode apres le falling de smb_clk externe. Le but est de respecter le holdtime sur le data.
-- La facon que ca ete fait a ete de relentir le smb_clk externe d'une demie periode interne.
-- On arrange le setup/hold time du sdata lors du REPEATED START, en allongeant le clock high et le data high de un clk
-- On arrange le setup time Tsu-sto du sdata lors du STOP, en allongeant le data low d'un clk
--
-- jmansill 10 novembre 2014
-- Le bit BUSY de l'interface tombe a '1' au moment precis ou on recoit le snapShot. Pas besoin de faire un delai avant de poller le bit de busy
-- Lorsqu'il y avait une erreur de protocole sur un cycle d'index(ACK non envoye par le slave), le core ne generait pas la condition de 
-- STOP correctement. C'est maintenant corrige.
--
-- jlarin 28 janvier 2016
-- j'ai ajoute le clock stretching. Essentiellement, a chaque fois qu'on monte la clock, on regarde une demi-clock plus tard si elle est montee. 
-- Dans tous les cas normaux, elle devrait etre monte et on continue normalement. Si le slave fait du clock stretching, alors on restera dans l'etat high un coup de clock de plus.
-- Cette lecture du signal clock nous empeche de retarder la clock qu'on envoie a l'exterieur d'une demi-clock interne. J'ai donc du enlever ce delai. 
-- D'ailleur, la spec I2C mentionne un hold de 0 ns. Alors ce delai devait etre une patch project specific?
-------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library work;
use work.regfile_i2c_pack.all;

library UNISIM;
  use UNISIM.VCOMPONENTS.all;


entity i2c_if is
  generic(
      NB_INTERFACE      : integer;
      NI_ACCESS         : boolean := FALSE;
      C3_SIMULATION     : boolean := FALSE;
      CLOCK_STRETCHING  : boolean := FALSE; -- par default, comportement classique.
      G_SYS_CLK_PERIOD  : integer := 16      -- Sysclock period
    );
  port(
    sys_reset_n         : in std_logic; 
    sys_clk             : in std_logic;         -- System clock (Register domain)

    -- serial external interface
    ser_clk             : inout   std_logic_vector(NB_INTERFACE - 1 downto 0);              -- output clock to i2c clock pin
    ser_data            : inout std_logic_vector(NB_INTERFACE - 1 downto 0);              -- i/o serial data to/from i2c data pin

    regfile             : inout REGFILE_I2C_TYPE := INIT_REGFILE_I2C_TYPE
  );
end i2c_if;

architecture functionnal of i2c_if is


  component resetsync
  generic (
    ACTIVE_HIGH_RESETIN  : boolean := TRUE
  );
  port (
    clk                  : in        std_logic; -- synchronization clock
    resetin              : in        std_logic; -- input reset 
    resetoutP            : out       std_logic; -- active high synchronized reset
    resetoutN            : out       std_logic  -- active low  synchronized reset
  );
  end component;


  component event_cross_domain
    port(
      src_rst_n       : in     std_logic;
      dst_rst_n       : in     std_logic;
    
      src_clk         : in     std_logic; 
      dst_clk         : in     std_logic; 

      src_cycle       : in     std_logic;
      dst_cycle       : out    std_logic
    );
  end component;

  -- ********************** ser_clk state machine declaration ******************
  type    clk_states is (CLK_IDLE, CLK_DATA_LOW_BEGIN, CLK_DATA_HIGH,CLK_DATA_LOW_END,
                         CLK_START_BEGIN_HIGH, CLK_START_MIDDLE_HIGH,	CLK_START_LOW,
                         CLK_REP_START_BEGIN_LOW, CLK_REP_START_BEGIN_HIGH,
                         CLK_REP_START_END_HIGH, CLK_REP_START_END_HIGH2,CLK_REP_START_END_LOW,
                         CLK_STOP_BEGIN, CLK_STOP_MIDDLE, CLK_STOP_MIDDLE2, CLK_STOP_END);

  signal    clk_current_state, clk_next_state : clk_states;
  -- ***************************************************************************

  -- ********************** another state machine declaration ******************
  type    data_states is (IDLE, START, SEND_DEVICE_ID,
                ACK_DEVICE_ID, SEND_INDEX, ACK_INDEX, WRITE_DATA,
                ACK_WRITE_DATA, REPEATED_START,	SEND_READ_DEVICE_ID,
                ACK_READ_DEVICE_ID, READ_DATA, SEND_READ_NACK,STOP);

  signal    data_current_state, data_next_state : data_states;

  -- ***************************************************************************

  -- *********************** internal signal declaration ***********************
  signal ser_clk_in_pin  : std_logic_vector(NB_INTERFACE-1 downto 0);
  
  signal ser_data_in     : std_logic;
  signal ser_data_in_pin : std_logic_vector(NB_INTERFACE-1 downto 0);
  
  signal sr_out        : std_logic_vector (7 downto 0);
  signal sr_in         : std_logic_vector (7 downto 0);
  signal div_clk       : std_logic; -- divided clock, one cycle in advance, combinatorial
  signal clk_out       : std_logic; -- divided clock, flopped to remove glitch
  signal clk_outx      : std_logic_vector(NB_INTERFACE-1 downto 0); -- divided clock, flopped to remove glitch
  --signal clk_outx90    : std_logic_vector(NB_INTERFACE-1 downto 0); -- divided clock, flopped to remove glitch
  signal sampled_ser_clk  : std_logic;
  
  signal no_msb_i2c_device_id: std_logic_vector (7 downto 0);  -- device id left shifted

  signal bitcount           : integer range 0 to 8;   -- bit counter, to know we finished sending the 8 bits.
  signal data_outx          : std_logic_vector(NB_INTERFACE-1 downto 0); -- what do we drive out

  signal next_data_out      : std_logic; -- what do we drive out, before the flop
  signal error_detected_int : std_logic; -- the State machine detected an error
  signal load_bitcount      : std_logic; -- trigger a reload to 8 of the bit counter for the 8 bit data transfer
  signal update_data_state  : std_logic; -- enable signal saying that a phase is finished and we can to to the next bit/phase.
  signal trigger_resync     : std_logic;
  signal error_state        : std_logic;

  -- registers
  signal i2c_status_no_timing_error         : std_logic_vector(4 downto 0);
  signal index_trigger      : std_logic;               -- transaction trigger from auto i2c index reg
  signal i2c_dataw          : std_logic_vector (7 downto 0);   -- data to be written
  signal r_w_bit_in         : std_logic;
  signal i2c_datar          : std_logic_vector (7 downto 0);  -- read data from I2c device
  signal i2c_index          : std_logic_vector (31 downto 24); -- decoder 1 auto i2c index
  
  signal NI_acc            : std_logic;                       -- Non indexed read/write
  
  signal i2c_device_id      : std_logic_vector (7 downto 1);   -- decoder 1 auto i2c device id

  signal device_sel_data    : std_logic_vector(18 downto 17); -- bit 17 and up select the target device

  signal tx_done            : std_logic;
  signal tx_done_p1         : std_logic;
  signal tx_done_p2         : std_logic;
  signal tx_done_p3         : std_logic;
  
  signal i2c_reset_n        : std_logic;
  signal i2c_clk            : std_logic;         -- Serial reference clock (low frequency clock)
  signal i2c_clk_div_cntr   : std_logic_vector(8 downto 0);
  signal i2c_clk_div_384    : std_logic;
  signal i2c_clk_div_768    : std_logic;
  
begin

  -----------------------------------------------
  --  SysClock division and reset regeneration
  -----------------------------------------------
  resetsync_i2c : resetsync
  generic map(
    ACTIVE_HIGH_RESETIN  => FALSE
  )
  port map(
    clk                  => i2c_clk,          -- synchronization clock
    resetin              => sys_reset_n,      -- input reset 
    resetoutP            => open,             -- active high synchronized reset
    resetoutN            => i2c_reset_n       -- active low  synchronized reset
  );



Gen_i2c_clk_from_625 : if(G_SYS_CLK_PERIOD=16) generate
begin
  process (sys_clk)
  begin
    if (sys_clk'event and sys_clk='0') then
      if (sys_reset_n = '0') then
        i2c_clk_div_cntr <= (others=>'0');
        i2c_clk_div_384  <= '0';
      elsif(C3_SIMULATION=FALSE) then 
        if(i2c_clk_div_cntr="011000000") then           -- count to 192
          i2c_clk_div_cntr <= (others=>'0');
          i2c_clk_div_384  <= not(i2c_clk_div_384);
        else 
          i2c_clk_div_cntr <= std_logic_vector(i2c_clk_div_cntr + '1');
          i2c_clk_div_384  <= i2c_clk_div_384;
        end if;
      else
        if(i2c_clk_div_cntr="000000001") then           -- count to 1(SIMULATION ONLY)
          i2c_clk_div_cntr <= (others=>'0');
          i2c_clk_div_384  <= not(i2c_clk_div_384);
        else 
          i2c_clk_div_cntr <= std_logic_vector(i2c_clk_div_cntr + '1');
          i2c_clk_div_384  <= i2c_clk_div_384;
        end if;
      end if;  
    end if;
  end process;

  i2c_clk <= i2c_clk_div_384;

end generate Gen_i2c_clk_from_625;



Gen_i2c_clk_from_125 : if(G_SYS_CLK_PERIOD=8) generate
begin
  process (sys_clk)
  begin
    if (sys_clk'event and sys_clk='0') then
      if (sys_reset_n = '0') then
        i2c_clk_div_cntr <= (others=>'0');
        i2c_clk_div_768  <= '0';
      elsif(C3_SIMULATION=FALSE) then 
        if(i2c_clk_div_cntr="110000000") then           -- count to 384
          i2c_clk_div_cntr <= (others=>'0');
          i2c_clk_div_768  <= not(i2c_clk_div_768);
        else 
          i2c_clk_div_cntr <= std_logic_vector(i2c_clk_div_cntr + '1');
          i2c_clk_div_768  <= i2c_clk_div_768;
        end if;
      else
        if(i2c_clk_div_cntr="000000001") then           -- count to 1(SIMULATION ONLY)
          i2c_clk_div_cntr <= (others=>'0');
          i2c_clk_div_768  <= not(i2c_clk_div_768);
        else 
          i2c_clk_div_cntr <= std_logic_vector(i2c_clk_div_cntr + '1');
          i2c_clk_div_768  <= i2c_clk_div_768;
        end if;
      end if;  
    end if;
  end process;

  i2c_clk <= i2c_clk_div_768;

end generate Gen_i2c_clk_from_125;

  
  -----------------------------------------------
  --  OLD I2C LOGIC START
  -----------------------------------------------
  -- version generique
  GEN_INTERFACE :  for i in 0 to (NB_INTERFACE-1) generate
    
    IOCLKBUFTinst : IOBUF
      port map(
        O  => ser_clk_in_pin(i),  -- Buffer output
        IO => ser_clk(i),         -- Buffer inout port (connect directly to top-level port)
        I  => '0',                -- Buffer input
        T  => clk_outx(i)         -- 3-state enable input, high=input, low=output
    );
    
  end generate;


  -- version generique
  iobuftoutgen : for i in 0 to NB_INTERFACE-1 generate
      IOBUFTinst : IOBUF
      port map(
        O  => ser_data_in_pin(i), -- Buffer output
        IO => ser_data(i),        -- Buffer inout port (connect directly to top-level port)
        I  => '0',                -- Buffer input
        T  => data_outx(i)        -- 3-state enable input, high=input, low=output
      );
  end generate;

  inputselprc: process(device_sel_data, ser_data_in_pin)
    variable devsel : integer;
  begin
    devsel := conv_integer(device_sel_data);
    if devsel < ser_data_in_pin'length then
      ser_data_in <= ser_data_in_pin(devsel);
    else
      ser_data_in <= '0';
    end if;
  end process;


  ---------------
  -- REGISTERS --
  ---------------
  device_sel_data <=  regfile.I2C.I2C_CTRL0.BUS_SEL;

  gen_NI_ACC_reg_T : if NI_ACCESS = TRUE generate
    NI_acc <=  regfile.I2C.I2C_CTRL0.NI_ACC;
  end generate;
  
  gen_NI_ACC_reg_F : if NI_ACCESS = FALSE generate
    NI_acc <= '0';
  end generate;

  index_trigger       <=  regfile.I2C.I2C_CTRL0.TRIGGER;  -- Signal a resynchroniser --jmansill

  -- Signaux statiques a synchroniser de maniere simple.
  -- Le signal index_trigger qui est resynchronise demarre le processus. On veux quand meme que les autres signaux de configuration soient statiques.
  -- Normalement, c'est le fait que le logiciel n'ecrit pas dans le registre quand le module est busy qui nous assure que la configuration est statique
  -- Cependant, l'outil de synthese, place&route ne le sait pas. On reflop donc les donnees ici pour le garantir.
  configprc: process(i2c_clk)
  begin
    if rising_edge(i2c_clk) then
      if trigger_resync = '1' then -- durera un seul clock, garanti par le design de event_cross_domain
        i2c_dataw           <=  regfile.I2C.I2C_CTRL0.I2C_DATA_WRITE;
        i2c_index           <=  regfile.I2C.I2C_CTRL0.I2C_INDEX;
        i2c_device_id       <=  regfile.I2C.I2C_CTRL1.I2C_DEVICE_ID;
        r_w_bit_in          <=  regfile.I2C.I2C_CTRL1.I2C_RW;
      end if;
    end if;
  end process;
  
  regfile.I2C.I2C_CTRL0.I2C_DATA_READ  <= i2c_datar;
  regfile.I2C.I2C_CTRL1.I2C_ERROR      <= i2c_status_no_timing_error(4);
  regfile.I2C.I2C_CTRL1.BUSY           <= i2c_status_no_timing_error(3);
  regfile.I2C.I2C_CTRL1.WRITING        <= i2c_status_no_timing_error(2);
  regfile.I2C.I2C_CTRL1.READING        <= i2c_status_no_timing_error(1);


  triggerresync: event_cross_domain
    port map(
      src_rst_n       => sys_reset_n,
      dst_rst_n       => i2c_reset_n,
    
      src_clk         => sys_clk, 
      dst_clk         => i2c_clk, 

      src_cycle       => index_trigger,
      dst_cycle       => trigger_resync
    );

  no_msb_i2c_device_id <= i2c_device_id & "0"; 

  -- on flop pour pouvoir enlever le glitch de timing
  process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      -- generate status bits
      i2c_status_no_timing_error(0) <= '0'; -- no polling yet

      -- reading bit
      if(sys_reset_n='0') then
        i2c_status_no_timing_error(1) <= '0';
      elsif(index_trigger='1') then
        i2c_status_no_timing_error(1) <=  regfile.I2C.I2C_CTRL1.I2C_RW;
      elsif(tx_done_p2='0' and tx_done_p3='1') then
        i2c_status_no_timing_error(1) <= '0';
      end if;

      -- writing bit
      if(sys_reset_n='0') then
        i2c_status_no_timing_error(2) <= '0';
      elsif(index_trigger='1') then
        i2c_status_no_timing_error(2) <=  not regfile.I2C.I2C_CTRL1.I2C_RW;
      elsif(tx_done_p2='0' and tx_done_p3='1') then
        i2c_status_no_timing_error(2) <= '0';
      end if;

      -- busy bit
      if(sys_reset_n='0') then
        i2c_status_no_timing_error(3) <= '0';
      elsif(index_trigger='1') then
        i2c_status_no_timing_error(3) <= '1';
      elsif(tx_done_p2='0' and tx_done_p3='1') then
        i2c_status_no_timing_error(3) <= '0';
      end if;

      i2c_status_no_timing_error(4) <= error_state;
    end if;
  end process;

  -- Fin de la transaction
  process (i2c_reset_n, i2c_clk)
  begin
    if (i2c_reset_n = '0') then
      tx_done  <=  '0';
    elsif (i2c_clk = '1' and i2c_clk'event) then
      if(clk_current_state  = CLK_STOP_END) then   -- Le code va toujours passer par ici
        tx_done             <=  '1';
      else
        tx_done             <=  '0';
      end if;
    end if;
  end process;

  process (sys_reset_n, sys_clk)
  begin
    if (sys_reset_n = '0') then
      tx_done_p1  <=  '0';
      tx_done_p2  <=  '0';
      tx_done_p3  <=  '0';
    elsif (sys_clk = '1' and sys_clk'event) then
      tx_done_p1  <=  tx_done;
      tx_done_p2  <=  tx_done_p1;
      tx_done_p3  <=  tx_done_p2;
    end if;
  end process;


  error_ff: process(i2c_reset_n, i2c_clk)
  begin
    if i2c_reset_n = '0' then
      error_state <= '0';
    elsif rising_edge(i2c_clk) then
      if data_current_state = START then
        error_state <= '0'; -- remove the error when we start a cycle
      elsif error_detected_int = '1' then
        error_state <= '1';
      else
        error_state <= error_state;
      end if;
    end if;
  end process;

  -- counter to support the state machine
  bitcount_prc: process(i2c_reset_n, i2c_clk)
  begin
    if i2c_reset_n = '0' then
      bitcount <= 0;
    elsif rising_edge(i2c_clk) then
      if load_bitcount = '1' then
        bitcount <= 7;
      elsif update_data_state = '1' then
        if bitcount /= 0 then
          bitcount <= bitcount - 1;
        else
          -- bitcount is 0, stay there.
          bitcount <= 0;
        end if;
      end if;
    end if;
  end process;

NI_acc_PROC_T : if NI_ACCESS = TRUE generate
  shift_register_output: process(i2c_reset_n, i2c_clk)
  begin
    if i2c_reset_n = '0' then
      sr_out <= (others => '0');
    elsif rising_edge(i2c_clk) then
      if (data_current_state = START and NI_acc='0') or (data_current_state = START and NI_acc='1' and r_w_bit_in='0') then
        sr_out <= no_msb_i2c_device_id;
      elsif data_current_state = ACK_DEVICE_ID and NI_acc='0' then
        sr_out <= i2c_index;
      elsif (data_current_state = ACK_INDEX) or (NI_acc='1' and data_current_state = ACK_DEVICE_ID) then
        sr_out <= i2c_dataw;
      elsif data_current_state = REPEATED_START  or (data_current_state = START and NI_acc='1' and r_w_bit_in='1')then  --NI_ACCESS_READ
        sr_out <= no_msb_i2c_device_id or x"01"; -- set the read bit
      else
        --if clk_out = '1' then -- now we use clk_out because we have to anticipate the update_data_state because we must register data_out
        -- on ne peut plus utiliser clk_out car il y a du clock stretching. Nous allons utiliser le prochain etat de la clock
        if clk_next_state = CLK_DATA_LOW_END then -- nous shiftons les donnees que pendant le vecteur de data, donc seulement cet etat.
          -- shift the data
          sr_out <= sr_out(sr_out'high -1 downto 0) & '-';
        else
          sr_out <= sr_out;
        end if;
      end if;
    end if;
  end process;
end generate;

NI_acc_PROC_F : if NI_ACCESS = FALSE generate
  shift_register_output: process(i2c_reset_n, i2c_clk)
  begin
    if i2c_reset_n = '0' then
      sr_out <= (others => '0');
    elsif rising_edge(i2c_clk) then
      if data_current_state = START then
        sr_out <= no_msb_i2c_device_id;
      elsif data_current_state = ACK_DEVICE_ID then
        sr_out <= i2c_index;
      elsif data_current_state = ACK_INDEX then
        sr_out <= i2c_dataw;
      elsif data_current_state = REPEATED_START then
        sr_out <= no_msb_i2c_device_id or x"01"; -- set the read bit
      else
        if clk_out = '1' then -- now we use clk_out because we have to anticipate the update_data_state because we must register data_out
          -- shift the data
          sr_out <= sr_out(sr_out'high -1 downto 0) & '-';
        else
          sr_out <= sr_out;
        end if;
      end if;
    end if;
  end process;
end generate;


  shift_register_input: process(i2c_reset_n, i2c_clk)
  begin
    if i2c_reset_n = '0' then
      sr_in <= (others => '0');
    elsif rising_edge(i2c_clk) then
      if clk_current_state = CLK_DATA_HIGH and clk_next_state = CLK_DATA_LOW_END then -- we sample the data on the falling edge of the clock we drive out
                                                                                      -- alternativement, nous pourrions clocker sur le falling edge du i2c_clk en plein milieu du clock high
        sr_in <= sr_in(sr_in'high-1 downto 0) & ser_data_in;
      end if;
    end if;
  end process;

  -- output data to register file
  odrf: process(i2c_clk, i2c_reset_n)
  begin
    if i2c_reset_n = '0' then
      i2c_datar <= (others => '0');
    elsif rising_edge(i2c_clk) then
      if (data_current_state = SEND_READ_NACK) and (clk_current_state = CLK_DATA_HIGH) then
        -- on a des probleme avec la lecture du 'H', alors on converti naturellement en '1'
        for i in 7 downto 0 loop
          if (sr_in(i) = '1') or (sr_in(i) = 'H') then
            i2c_datar(i) <= '1';
          else
            i2c_datar(i) <= '0';
          end if;
        end loop;
--        i2c_datar <= sr_in(7 downto 0);
      end if;
    end if;	
  end process;

  -- pour faire du clock stretching, nous devons regarder la clock en entre. Lorsqu'on la laisse monter par le pullup, il est possible qu'un autre agent la tienne bas.
  -- on flop la clock en entree, sur le falling edge de la clock I2C, pour eliminer la metastabilite. Le I2C est tellement lent que tous les problemes de metastabilite seront elimines.
  inputclkflopprc: process(i2c_clk, device_sel_data)
    variable devsel : integer;
  begin
    devsel := conv_integer(device_sel_data);
    if falling_edge(i2c_clk) then
      if devsel < ser_clk'length then
        sampled_ser_clk <= ser_clk_in_pin(devsel);
      else
        sampled_ser_clk <= '1';
      end if;
    end if;
  end process;

  -- serial clock change of state logic
  process (i2c_reset_n, i2c_clk)
  begin
    if (i2c_reset_n = '0') then
      clk_current_state <=  CLK_IDLE;
    elsif (i2c_clk = '1' and i2c_clk'event) then
      clk_current_state <=  clk_next_state;
    end if;
  end process;

  -- serial clock state machine
  i2c_clk_state_machine: process (clk_current_state, trigger_resync,data_current_state,r_w_bit_in, sampled_ser_clk)
  begin

    -- default values
    update_data_state <= '0'; -- the data state machine should not change

    case clk_current_state is

      -- clock is idle when no transaction is running
      -- on ne verifie pas le clock stretching ici.  Si on slave stretch en fin de transaction, on va bloquer dans le stop. 
      -- Seul un master peut descendre la clock en idle, nous ne supportons pas le multi-master
      when CLK_IDLE =>
        if trigger_resync = '1' then
          clk_next_state <= CLK_START_BEGIN_HIGH;
          div_clk <= '1';
        else
          clk_next_state <= CLK_IDLE;
          div_clk <= '1';
        end if;

      -- happens when a transaction is triggered and data is falling
      -- (i2c start condition)
      when CLK_START_BEGIN_HIGH =>
        clk_next_state <= CLK_START_MIDDLE_HIGH;
        div_clk <= '1';

      when CLK_START_MIDDLE_HIGH =>
        clk_next_state <= CLK_START_LOW;
        div_clk <= '0';

      when CLK_START_LOW =>
        clk_next_state <= CLK_DATA_LOW_BEGIN;
        div_clk <= '0';
        update_data_state <= '1'; -- we finished this data state, we can go to the next data state

      -- clock is low
      when CLK_DATA_LOW_BEGIN =>
        if data_current_state = STOP then -- if there is an error in the middle of some transfer
          -- we get here instead of stop. If we detect that, we jump to stop.
          clk_next_state <= CLK_STOP_MIDDLE;
          div_clk     <= '1';
        else
          clk_next_state  <= CLK_DATA_HIGH;
          div_clk     <= '1';
        end if;

      -- clock is high
      when CLK_DATA_HIGH =>
        if CLOCK_STRETCHING = TRUE and sampled_ser_clk = '0' then
          -- un agent tient la clock basse, on reste ici un coup de clock de plus.
          clk_next_state  <= CLK_DATA_HIGH;
          div_clk     <= '1';
        else
          clk_next_state  <= CLK_DATA_LOW_END;
          div_clk     <= '0';
        end if;

      when CLK_DATA_LOW_END =>
        update_data_state <= '1';
        case data_current_state is
          when SEND_DEVICE_ID =>
            clk_next_state  <= CLK_DATA_LOW_BEGIN;
            div_clk <= '0';
          when ACK_DEVICE_ID =>
            clk_next_state  <= CLK_DATA_LOW_BEGIN;
            div_clk <= '0';
          when SEND_INDEX =>
            clk_next_state  <= CLK_DATA_LOW_BEGIN;
            div_clk <= '0';
          when ACK_INDEX =>
            if r_w_bit_in = '1' then
              -- we are reading, next state is the repeated start
              clk_next_state <= CLK_REP_START_BEGIN_LOW;
              div_clk     <= '0';
            else
              -- we write the data, send data right away
              clk_next_state  <= CLK_DATA_LOW_BEGIN;
              div_clk <= '0';
            end if;
          when WRITE_DATA =>
            clk_next_state  <= CLK_DATA_LOW_BEGIN;
            div_clk <= '0';
          when ACK_WRITE_DATA =>
            clk_next_state  <= CLK_STOP_BEGIN;
            div_clk     <= '0';
          when SEND_READ_DEVICE_ID =>
            clk_next_state  <= CLK_DATA_LOW_BEGIN;
            div_clk <= '0';
          when ACK_READ_DEVICE_ID =>
            clk_next_state  <= CLK_DATA_LOW_BEGIN;
            div_clk <= '0';
          when READ_DATA =>
            clk_next_state  <= CLK_DATA_LOW_BEGIN;
            div_clk <= '0';
          when SEND_READ_NACK =>
            clk_next_state  <= CLK_STOP_BEGIN;
            div_clk     <= '0';
          when others =>
            clk_next_state <= CLK_IDLE;
            div_clk <= '1';
-- synopsys translate_off
            -- should never happen
            assert false
              report "Unplanned state"
              severity FAILURE;
-- synopsys translate_on
--                , REPEATED_START,
--                , ,STOP);
        end case;

      -- repeated start have to be done in 5 cycles to respect all timings.
      -- the clock is low-high-high-high-low.
      when CLK_REP_START_BEGIN_LOW =>
        if data_current_state = STOP then -- if there is an error in the middle of some transfer
          -- we get here instead of stop. If we detect that, we jump to stop.
          clk_next_state <= CLK_STOP_MIDDLE;
          div_clk     <= '1';
        else
          clk_next_state  <= CLK_REP_START_BEGIN_HIGH;
          div_clk     <= '1';
        end if;
        
      when CLK_REP_START_BEGIN_HIGH =>
        if CLOCK_STRETCHING = TRUE and sampled_ser_clk = '0' then
          -- un agent tient la clock basse, on reste ici un coup de clock de plus.
          clk_next_state  <= CLK_REP_START_BEGIN_HIGH;
          div_clk     <= '1';
        else
          clk_next_state  <= CLK_REP_START_END_HIGH;
          div_clk     <= '1';
        end if;

      when CLK_REP_START_END_HIGH =>
        clk_next_state  <= CLK_REP_START_END_HIGH2;
        div_clk     <= '1';

      when CLK_REP_START_END_HIGH2 =>
        clk_next_state  <= CLK_REP_START_END_LOW;
        div_clk     <= '0';

      when CLK_REP_START_END_LOW =>
        clk_next_state  <= CLK_DATA_LOW_BEGIN;
        div_clk <= '0';
        update_data_state <= '1';

      -- stop is done un 4 cycles
      when CLK_STOP_BEGIN =>
        clk_next_state  <= CLK_STOP_MIDDLE;
        div_clk     <= '1';

      when CLK_STOP_MIDDLE =>
        if CLOCK_STRETCHING = TRUE and sampled_ser_clk = '0' then
          -- un agent tient la clock basse, on reste ici un coup de clock de plus.
          clk_next_state  <= CLK_STOP_MIDDLE;
          div_clk     <= '1';
        else
          clk_next_state  <= CLK_STOP_MIDDLE2;
          div_clk     <= '1';
        end if;

      when CLK_STOP_MIDDLE2 =>
        clk_next_state  <= CLK_STOP_END;
        div_clk     <= '1';

      when CLK_STOP_END =>
        clk_next_state  <= CLK_IDLE;
        div_clk <= '1';
        update_data_state <= '1';

    end case;
  end process;


  -- serial data change of state logic
  process (i2c_reset_n, i2c_clk)
  begin
    if (i2c_reset_n = '0') then
      data_current_state  <=  IDLE;
      clk_out             <= '1';
    elsif (i2c_clk = '1' and i2c_clk'event) then
      data_current_state  <=  data_next_state;
      clk_out             <=  div_clk;         -- div_clk is 1 clock in advance of the actual data want to output, so we register
    end if;
  end process;


  GEN_X1_ser_data_out : if(NB_INTERFACE=1) generate
    -- serial data change of state logic
    process (i2c_reset_n, i2c_clk)
    begin
      if (i2c_reset_n = '0') then
        clk_outx  <= (others => '1');
        data_outx <= (others => '1');
      elsif (i2c_clk = '1' and i2c_clk'event) then
        if(device_sel_data="00") then
          clk_outx(0)  <= div_clk;             -- TO OUTPUT 0 : div_clk is 1 clock in advance of the actual data want to output, so we register
          data_outx(0) <= next_data_out;
        else
          clk_outx(0)  <= '1';
          data_outx(0) <= '1';
        end if;
      end if;
    end process;
    
--     --CLK SHIFT 90 DEGRES
--     process (i2c_reset_n, i2c_clk)
--     begin
--       if (i2c_reset_n = '0') then
--         clk_outx90  <= (others => '1');
--       elsif (i2c_clk = '0' and i2c_clk'event) then
--         if(device_sel_data="00") then
--           clk_outx90(0)  <= clk_outx(0);
--         else
--           clk_outx90(0)  <= '1';
--         end if;
--       end if;
--     end process;
    
    
  end generate;

  GEN_X2_ser_data_out : if(NB_INTERFACE=2) generate
    -- serial data change of state logic
    process (i2c_reset_n, i2c_clk)
    begin
      if (i2c_reset_n = '0') then
        clk_outx  <= (others => '1');
        data_outx <= (others => '1');
      elsif (i2c_clk = '1' and i2c_clk'event) then
        if(device_sel_data="00") then
          clk_outx(0)  <= div_clk;             -- TO OUTPUT 0 : div_clk is 1 clock in advance of the actual data want to output, so we register
          data_outx(0) <= next_data_out;
        else
          clk_outx(0)  <= '1';
          data_outx(0) <= '1';
        end if;
        if(device_sel_data="01") then
          clk_outx(1)  <= div_clk;             -- TO OUTPUT 1 : div_clk is 1 clock in advance of the actual data want to output, so we register
          data_outx(1) <= next_data_out;
        else
          clk_outx(1)  <= '1';
          data_outx(1) <= '1';
        end if;
      end if;
    end process;

--     -- CLK SHIFT 90 DEGRES
--     process (i2c_reset_n, i2c_clk)
--     begin
--       if (i2c_reset_n = '0') then
--         clk_outx90  <= (others => '1');
--       elsif (i2c_clk = '0' and i2c_clk'event) then
--         if(device_sel_data="00") then
--           clk_outx90(0)  <= clk_outx(0);
--         else
--           clk_outx90(0)  <= '1';
--         end if;
--         if(device_sel_data="01") then
--           clk_outx90(1)  <= clk_outx(1);
--         else
--           clk_outx90(1)  <= '1';
--         end if;
--       end if;
--     end process;



  end generate;

  GEN_X4_ser_data_out : if(NB_INTERFACE=4) generate
    -- serial data change of state logic
    process (i2c_reset_n, i2c_clk)
    begin
      if (i2c_reset_n = '0') then
        clk_outx  <= (others => '1');
        data_outx <= (others => '1');
      elsif (i2c_clk = '1' and i2c_clk'event) then
        if(device_sel_data="00") then
          clk_outx(0)  <= div_clk;             -- TO OUTPUT 0 : div_clk is 1 clock in advance of the actual data want to output, so we register
          data_outx(0) <= next_data_out;
        else
          clk_outx(0)  <= '1';
          data_outx(0) <= '1';
        end if;
        
        if(device_sel_data="01") then
          clk_outx(1)  <= div_clk;             -- TO OUTPUT 1 : div_clk is 1 clock in advance of the actual data want to output, so we register
          data_outx(1) <= next_data_out;
        else
          clk_outx(1)  <= '1';
          data_outx(1) <= '1';
        end if;

        if(device_sel_data="10") then
          clk_outx(2)  <= div_clk;             -- TO OUTPUT 2 : div_clk is 1 clock in advance of the actual data want to output, so we register
          data_outx(2) <= next_data_out;
        else
          clk_outx(2)  <= '1';
          data_outx(2) <= '1';
        end if;

        if(device_sel_data="11") then
          clk_outx(3)  <= div_clk;             -- TO OUTPUT 3 : div_clk is 1 clock in advance of the actual data want to output, so we register
          data_outx(3) <= next_data_out;
        else
          clk_outx(3)  <= '1';
          data_outx(3) <= '1';
        end if;
        
      end if;
    end process;
    
    
--     -- CLK SHIFT 90 DEGRES
--     process (i2c_reset_n, i2c_clk)
--     begin
--       if (i2c_reset_n = '0') then
--         clk_outx90  <= (others => '1');
--       elsif (i2c_clk = '0' and i2c_clk'event) then
--         if(device_sel_data="00") then
--           clk_outx90(0)  <= clk_outx(0);
--         else
--           clk_outx90(0)  <= '1';
--         end if;
--         if(device_sel_data="01") then
--           clk_outx90(1)  <= clk_outx(1);
--         else
--           clk_outx90(1)  <= '1';
--         end if;
--         if(device_sel_data="10") then
--           clk_outx90(2)  <= clk_outx(2);
--         else
--           clk_outx90(2)  <= '1';
--         end if;
--         if(device_sel_data="11") then
--           clk_outx90(3)  <= clk_outx(3);
--         else
--           clk_outx90(3)  <= '1';
--         end if;
--       end if;
--     end process;
    
    
    
    
  end generate;



  -- serial data state machine	
  auto_i2c_state_machine: process (data_current_state, bitcount,sr_in,
                  r_w_bit_in,trigger_resync,update_data_state,
                  ser_data_in, NI_acc)
  begin
    -- by default
    load_bitcount <= '0';
    error_detected_int <= '0';

    case data_current_state is

      -- data is idle when no transaction is running
      when IDLE =>
        if trigger_resync = '1' then
          data_next_state <= START;
        else
          data_next_state <= IDLE;
        end if;

      -- start condition happens when a transaction is triggered.
      -- data line is going down when clock is high.
      when START =>
        if update_data_state = '1' then        
          if(NI_acc='0')then 
            data_next_state <= SEND_DEVICE_ID;
          else
            if(r_w_bit_in='1') then
              data_next_state <= SEND_READ_DEVICE_ID;
            else
              data_next_state <= SEND_DEVICE_ID;
            end if;
          end if;
        else
          data_next_state <= START;
        end if;

        load_bitcount <= '1';

      -- device id is sent during this state
      when SEND_DEVICE_ID =>

        if update_data_state = '1' and bitcount = 0 then
          data_next_state <= ACK_DEVICE_ID;
        else
          data_next_state <= SEND_DEVICE_ID;
        end if;

      -- receiving device_id acknowledge
      when ACK_DEVICE_ID =>

        if update_data_state = '1' then
          if sr_in(0) = '0' then -- if we received a ACK
            if(NI_acc='1' and r_w_bit_in='0')then
               data_next_state <= WRITE_DATA;
            else
               data_next_state <= SEND_INDEX;
            end if;
          else
            error_detected_int <= '1';
            data_next_state <= STOP;
          end if;
        else
          data_next_state <= ACK_DEVICE_ID;
        end if;

        load_bitcount <= '1'; -- prepare to count the index

      -- index is sent during this state who lasts for
      -- eight divided clock cycles
      when SEND_INDEX =>

        if (update_data_state = '1') and (bitcount = 0) then
          data_next_state <= ACK_INDEX;
        else
          data_next_state <= SEND_INDEX;
        end if;

      -- receiving index acknowledge
      when ACK_INDEX =>

        if update_data_state = '1' then
          if sr_in(0) = '0' then -- if we received a ACK
            if r_w_bit_in = '1' then
              data_next_state <= REPEATED_START;
            else
              data_next_state <= WRITE_DATA;
              load_bitcount <= '1'; -- prepare to count the data
            end if;
          else
            error_detected_int <= '1';
            data_next_state <= STOP;
          end if;
        else
          data_next_state <= ACK_INDEX;
        end if;

        load_bitcount <= '1';

      -- data to be written is sent during this state who lasts for
      -- eight divided clock cycles
      when WRITE_DATA =>

        if update_data_state = '1' and bitcount = 0 then
          data_next_state <= ACK_WRITE_DATA;
        else
          data_next_state <= WRITE_DATA;
        end if;

      when ACK_WRITE_DATA =>

        if update_data_state = '1' then
          if sr_in(0) = '0' then -- if we received a ACK
            data_next_state <= STOP;
          else
            error_detected_int <= '1';
            data_next_state <= STOP;
          end if;
        else
          data_next_state <= ACK_WRITE_DATA;
        end if;

      when REPEATED_START =>
        if update_data_state = '1' then
          data_next_state <= SEND_READ_DEVICE_ID;
        else
          data_next_state <= REPEATED_START;
        end if;

        load_bitcount <= '1'; -- prepare to count the 8 input data

      when SEND_READ_DEVICE_ID =>

        if update_data_state = '1' and bitcount = 0 then
          data_next_state <= ACK_READ_DEVICE_ID;
        else
          data_next_state <= SEND_READ_DEVICE_ID;
        end if;

      when ACK_READ_DEVICE_ID =>

        if update_data_state = '1' then
          if sr_in(0) = '0' then -- if we received a ACK
            data_next_state <= READ_DATA;
          else
            error_detected_int <= '1';
            data_next_state <= STOP;
          end if;
        else
          data_next_state <= ACK_READ_DEVICE_ID;
        end if;

        load_bitcount <= '1'; -- prepare to count the index

      -- data to be read is received during this state who lasts for
      -- eight divided clock cycles
      when READ_DATA =>

        if update_data_state = '1' and bitcount = 0 then
          data_next_state <= SEND_READ_NACK;
        else
          data_next_state <= READ_DATA;
        end if;

      -- We read all the data, stop the device
      when SEND_READ_NACK =>

        if update_data_state = '1' then
          data_next_state <= STOP;
        else
          data_next_state <= SEND_READ_NACK;
        end if;

      when STOP =>
        if update_data_state = '1' then
          data_next_state <= IDLE;
        else
          data_next_state <= STOP;
        end if;

    end case;
  end process;

  -- the data_out should only change while the clock is LOW. Otherwise, it can be interpreted as a stop or start operation
  -- When the data_current_state changes, the clock should be low, except in the start, stop, repeated start and idle condition
  -- we have to generate data_out from a flip flop to avoid glitches outside the chip.
  -- serial data state machine
  data_output_sm: process (data_next_state, clk_next_state,sr_out)
  begin

    case data_next_state is

      -- data is idle when no transaction is running
      when IDLE =>
        next_data_out <= '1';

      -- start condition happens when a transaction is triggered.
      -- data line is going down when clock is high.
      when START =>
                      
      -- To mark a start, the data falls after the first phase of the start cycle
      if clk_next_state = CLK_START_BEGIN_HIGH then
        next_data_out <= '1';
      else
        next_data_out <= '0';
      end if;

      -- device id is sent during this state
      when SEND_DEVICE_ID =>

        next_data_out <= sr_out(sr_out'high);

      -- receiving device_id acknowledge
      when ACK_DEVICE_ID =>
        
        next_data_out <= '1'; -- we read so we don't drive anything

      -- index is sent during this state who lasts for
      -- eight divided clock cycles
      when SEND_INDEX =>

        next_data_out <= sr_out(sr_out'high); -- shift data out

      -- receiving index acknowledge
      when ACK_INDEX =>

        next_data_out <= '1'; -- we read so we don't drive anything

      -- data to be written is sent during this state who lasts for
      -- eight divided clock cycles
      when WRITE_DATA =>

        next_data_out <= sr_out(sr_out'high); -- shift data out

      when ACK_WRITE_DATA =>

        next_data_out <= '1'; -- we read so we don't drive anything

      when REPEATED_START =>

        -- To mark a repeated start, the data falls after the second phase of the start cycle
        if (clk_next_state = CLK_REP_START_BEGIN_LOW) or (clk_next_state = CLK_REP_START_BEGIN_HIGH) or (clk_next_state = CLK_REP_START_END_HIGH) then
          next_data_out <= '1';
        else
          next_data_out <= '0';
        end if;

      when SEND_READ_DEVICE_ID =>

        next_data_out <= sr_out(sr_out'high);

      when ACK_READ_DEVICE_ID =>

        next_data_out <= '1'; -- we read so we don't drive anything

      -- data to be read is received during this state who lasts for
      -- eight divided clock cycles
      when READ_DATA =>

        next_data_out <= '1'; -- we read so we don't drive anything

      -- We read all the data, stop the device
      when SEND_READ_NACK =>

        next_data_out <= '1'; -- we don't want anymore data so we tell the device to stop

      when STOP =>
        -- To mark a stop, the data rises while (the clock is high (after the second phase)
        if (clk_next_state = CLK_STOP_END) then
          next_data_out <= '1';
        else
          next_data_out <= '0';
        end if;

    end case;
  end process;

end functionnal;
