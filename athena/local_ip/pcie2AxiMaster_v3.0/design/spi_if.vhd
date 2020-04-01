-------------------------------------------------------------------------------
--  $Source: /proj4/typhoon/solios/usr/bcharbon/design/RCS/flash_spi.vhd,v $
--  $Revision: 10823 $
--  $Date: 2013-04-02 15:59:10 -0400 (Tue, 02 Apr 2013) $
--  $Author: jlarin $
--
--  Description: SPI interface for serial Flash
--
--  S/W sets SPIRW, SPIDATAW and SPICMDDONE before setting SPITXST to start
--  the transaction. When the transaction is completed, SPIWRTD will be set
--  to 1 and the S/W can read the SPIDATAR and send another transaction. On
--  the last transaction of a command sequence, the S/W sets SPICMDDONE to 1
--  to indicate to the interface to de-assert the Chip Enable.
--
--  NOTE: pour aider le timing, le signal ce_enaN_AND_ce_enaN_FF a ete creer
--  pour nous permettre de le signal de sortie spi_csN dans un IOB. Le but est
--  d'implanter EXACTEMENT la meme fonctionnalite qu'avant sans meme penser
--  a regarder la fonctionnalite du code, alors certaines variable peuvent 
--  maintenant etre inutile ou certain morceau de code peuvent etre ecrit 
--  bizarrement.  On fera le menage plus tard, si c'est necessaire.
-- 
--  Je revois le code pour determiner les contraintes de timing nécessaire sous
--  Vivado sans utiliser le fait que les FF de sorties sont dans le IOB car ce
--  n'est pas toujours vrai.
--
--  Tant qu'à y etre, j'ai enlever les reset inutiles et converti les resets en
--  mode synchrone car les sources de reset utilisant ce core fournissent deja 
--  un reset synchrone.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Work library
library work;
   use work.regfile_pcie2AxiMaster_pack.all;


entity spi_if is

  port (
    -----------------------------------------
    -- Clocks and reset
    -----------------------------------------
    sys_reset_n : in std_logic;
    sys_clk     : in std_logic;         -- register clock

    -----------------------------------------------------------------
    -- Flash interface
    -----------------------------------------------------------------
    spi_sdin  : in  std_logic;          -- data in
    spi_sdout : out std_logic;          -- data out
    spi_csN   : out std_logic;          -- chip select

    -----------------------------------------------------------------
    -- Flash interface without IOB
    -----------------------------------------------------------------
    spi_sdout_iob : out std_logic;      -- data out
    spi_sdout_ts  : out std_logic;      -- data out
    spi_csN_iob   : out std_logic;      -- chip select
    spi_csN_ts    : out std_logic;      -- chip select

    spi_sclk    : out std_logic;        -- clock
    spi_sclk_ts : out std_logic;        -- clock

    -----------------------------------------------------------------
    -- Registers 
    -----------------------------------------------------------------
    regfile : inout SPI_TYPE := INIT_SPI_TYPE

    );
end spi_if;


architecture functional of spi_if is


  component mtxSCFIFO is
    generic
      (
        DATAWIDTH : integer := 32;
        ADDRWIDTH : integer := 12
        );
    port
      (
        clk   : in  std_logic;
        sclr  : in  std_logic;
        wren  : in  std_logic;
        data  : in  std_logic_vector (DATAWIDTH-1 downto 0);
        rden  : in  std_logic;
        q     : out std_logic_vector (DATAWIDTH-1 downto 0);
        usedw : out std_logic_vector (ADDRWIDTH downto 0);
        empty : out std_logic;
        full  : out std_logic
        );
  end component;

  type spi_state is (RESET_S, IDLE_S, SHIFT_IN_S, SHIFT_OUT_S);
  signal curr_state_spi : spi_state;

  signal spi_clk_div2           : std_logic                    := '0';
  signal spi_sclk_int           : std_logic;
  signal spi_sclk_iob           : std_logic;
  signal start_xfer             : std_logic;
  signal shift_count            : std_logic_vector(2 downto 0);
  signal sclk_ena               : std_logic;
  signal ce_enaN                : std_logic;
  signal ce_enaN_AND_ce_enaN_FF : std_logic                    := '1';
  signal load_outreg            : std_logic;
  signal shift_in               : std_logic;
  signal shift_out              : std_logic;
  signal last_cmd               : std_logic;
  signal wrtd_int               : std_logic;
  signal outreg                 : std_logic_vector(7 downto 0);
  signal inreg                  : std_logic_vector(7 downto 0) := (others => '0');  -- pour que la simulation fonctionne si le host essaie de lire le registre AVANT de faire une transaction.

  signal sys_reset      : std_logic;
  signal spi_txst       : std_logic;
  signal begin_xfer     : std_logic;
  signal begin_xfer_p1  : std_logic;
  signal sclk_enable_n  : std_logic;
  signal sdout_enable_n : std_logic;
  signal csn_enable_n   : std_logic;


  type Def_S_state is (S_idle,
                       S_readfifo,
                       S_capture,
                       S_wait
                       );

  signal S_currState : Def_S_state;

  signal REG_SPITXST    : std_logic;
  signal REG_SPISEL     : std_logic;
  signal REG_SPIRW      : std_logic;
  signal REG_SPICMDDONE : std_logic;
  signal REG_SPIDATAW   : std_logic_vector(7 downto 0);

  signal fifo_data_in  : std_logic_vector(10 downto 0);
  signal fifo_data_out : std_logic_vector(10 downto 0);
  signal fifo_write    : std_logic;
  signal fifo_read     : std_logic;
  signal fifo_empty    : std_logic;
  signal fifo_idle     : std_logic;

  signal WRTD_TO_0 : std_logic;

  signal dummy_clk_0 : std_logic;
  signal dummy_clk_1 : std_logic;
  signal dummy_clk_2 : std_logic;

--  
--   -- attributes 
  attribute equivalent_register_removal                   : string;
  attribute equivalent_register_removal of sclk_enable_n  : signal is "no";
  attribute equivalent_register_removal of sdout_enable_n : signal is "no";
  attribute equivalent_register_removal of csn_enable_n   : signal is "no";
  attribute equivalent_register_removal of spi_sclk_iob   : signal is "no";
--   
--   
  attribute keep                                          : string;
  attribute keep of sclk_enable_n                         : signal is "true";
  attribute keep of sdout_enable_n                        : signal is "true";
  attribute keep of csn_enable_n                          : signal is "true";
  attribute keep of spi_sclk_iob                          : signal is "true";

  attribute iob                           : string;
  -- WE USE THE STRATUPE2, SO WE HAVE TO REMOVE IOB CONSTRAINT
  --attribute iob of sclk_enable_n :signal is "TRUE";
  --attribute iob of spi_sclk_iob :signal is "TRUE";
  attribute iob of csn_enable_n           : signal is "TRUE";
  attribute iob of sdout_enable_n         : signal is "TRUE";
  attribute iob of ce_enaN_AND_ce_enaN_FF : signal is "TRUE";

begin

  sys_reset <= not sys_reset_n;


  ---------------------------------------------------------------------------------------
  -- FIFO OPTIMISATION INPUT
  ---------------------------------------------------------------------------------------

  fifo_data_in(10 downto 0) <= regfile.spiregin.spisel  --(0) 
                               & regfile.spiregin.spirw & regfile.spiregin.spicmddone & regfile.spiregin.spidataw;

  fifo_write <= regfile.spiregin.spitxst;



  State_machine_clk : process(sys_clk)
  begin
    if(sys_clk'event and sys_clk = '1') then
      if(sys_reset_n = '0') then
        S_currState    <= S_idle;
        fifo_read      <= '0';
        REG_SPITXST    <= '0';
        REG_SPISEL     <= '0';
        REG_SPIRW      <= '0';
        REG_SPICMDDONE <= '0';
        REG_SPIDATAW   <= "00000000";

      else
        case S_currState is

          when S_idle =>
            if(fifo_empty = '0') then
              S_currstate <= S_readfifo;
              fifo_read   <= '1';
              fifo_idle   <= '0';
            else
              S_currstate <= S_idle;
              fifo_read   <= '0';
              fifo_idle   <= '1';
            end if;
            REG_SPITXST    <= '0';
            REG_SPISEL     <= REG_SPISEL;
            REG_SPIRW      <= REG_SPIRW;
            REG_SPICMDDONE <= REG_SPICMDDONE;
            REG_SPIDATAW   <= REG_SPIDATAW;

          when S_readfifo =>
            S_currstate    <= S_capture;  -- On lit ds le fifo - Commande
            fifo_read      <= '0';
            fifo_idle      <= '0';
            REG_SPITXST    <= '0';
            REG_SPISEL     <= REG_SPISEL;
            REG_SPIRW      <= REG_SPIRW;
            REG_SPICMDDONE <= REG_SPICMDDONE;
            REG_SPIDATAW   <= REG_SPIDATAW;

          when S_capture =>
            if(curr_state_spi = idle_s)then
              S_currstate    <= S_wait;     -- On loade la lecture du fifo
              fifo_read      <= '0';
              REG_SPITXST    <= '1';
              REG_SPISEL     <= fifo_data_out(10);
              REG_SPIRW      <= fifo_data_out(9);
              REG_SPICMDDONE <= fifo_data_out(8);
              REG_SPIDATAW   <= fifo_data_out(7 downto 0);
            else
              S_currstate    <= S_capture;  -- On lit ds le fifo - Commande
              fifo_read      <= '0';
              REG_SPITXST    <= '0';
              REG_SPISEL     <= REG_SPISEL;
              REG_SPIRW      <= REG_SPIRW;
              REG_SPICMDDONE <= REG_SPICMDDONE;
              REG_SPIDATAW   <= REG_SPIDATAW;
            end if;
            fifo_idle <= '0';


          when S_wait =>
            if(begin_xfer = '1' and begin_xfer_p1 = '0') then  -- PREFETCH, On peux aller chercher la prochaine commande, s'il y en a ds le fifo
              S_currstate <= S_idle;
              fifo_idle   <= '0';
            else
              S_currstate <= S_wait;
              fifo_idle   <= '0';
            end if;
            fifo_read      <= '0';
            REG_SPITXST    <= '0';
            REG_SPISEL     <= REG_SPISEL;
            REG_SPIRW      <= REG_SPIRW;
            REG_SPICMDDONE <= REG_SPICMDDONE;
            REG_SPIDATAW   <= REG_SPIDATAW;

        end case;
      end if;
    end if;
  end process;



  -- Matrox generic inferred FiFo
  Xspi_w_fifo : mtxSCFIFO
    generic map(
      DATAWIDTH => 11,
      ADDRWIDTH => 10
      )
    port map(
      clk   => sys_clk,
      sclr  => sys_reset,
      wren  => fifo_write,
      data  => fifo_data_in,
      rden  => fifo_read,
      q     => fifo_data_out,
      usedw => open,
      empty => fifo_empty,
      full  => open
      );



--*******************************--
-- Generate clock for SPI logic
--*******************************--

-- Generate internal clock for SPI logic at half frequency of input clock
-- (2x clock is required to generate spi_sclk to Flash)
  spi_clk_div2_p : process (sys_clk)    --, sys_reset_n)
  begin
    --if sys_reset_n = '0' then
    --  spi_clk_div2 <= '0';
    --els
    if sys_clk'event and sys_clk = '1' then
      spi_clk_div2 <= not(spi_clk_div2);
    end if;
  end process spi_clk_div2_p;

-- Generate output clock when enable is active.
-- spi_sclk is phase-shifted of 180deg with spi_clk_div2.
  sclk_p : process (sys_clk)            --, sys_reset_n)
  begin
    --if sys_reset_n = '0' then
    --  spi_sclk_int <= '0';
    --els
    if sys_clk'event and sys_clk = '1' then
      if sclk_ena = '1' then
        spi_sclk_int <= not(spi_sclk_int);
      else
        spi_sclk_int <= '0';
      end if;
    end if;
  end process sclk_p;

  -- pour compenser pour un "feature" du startupe2 des Artix7, on doit envoyer 3 clocks a vers le startupe2 (signal spi_sclk_iob) apres la programation du FPGA avant
  -- que ces clock soient envoyes sur la vrai pin CCLK externe. 
  sclk_patch : process (sys_clk, sys_reset_n)
  begin
    if sys_reset_n = '0' then
      dummy_clk_0 <= '0';
      dummy_clk_1 <= '0';
      dummy_clk_2 <= '0';
    elsif sys_clk'event and sys_clk = '1' then
      if spi_sclk_iob = '1' then  -- si la clock est visible vers l'exterieur
        dummy_clk_0 <= '1';
        dummy_clk_1 <= dummy_clk_0;
        dummy_clk_2 <= dummy_clk_1;
      end if;
    end if;
  end process;

-- je laisse le reset asynchrone ici pour que le FF soit sur le meme control set que le control de Tristate,
-- car le tri-state DOIT etre asynchrone.
  sclk_piob : process (sys_clk, sys_reset_n)
  begin
    if sys_reset_n = '0' then
      spi_sclk_iob <= '0';
    elsif sys_clk'event and sys_clk = '1' then
      if dummy_clk_2 = '0' then        -- insertion de clock dummy au power-up 
        spi_sclk_iob <= spi_clk_div2;   -- pour activer le starupE2 du Artix7.
      elsif sclk_ena = '1' then
        spi_sclk_iob <= not(spi_sclk_int);
      else
        spi_sclk_iob <= '0';
      end if;
    end if;
  end process;

-- Enlarging SPITXST in order to make it seen on div2 clock
  start_xfer_p : process (sys_clk, sys_reset_n)
  begin
    if sys_reset_n = '0' then
      spi_txst   <= '0';
      start_xfer <= '0';
    elsif sys_clk'event and sys_clk = '1' then
      spi_txst   <= REG_SPITXST;
      start_xfer <= REG_SPITXST or spi_txst;
    end if;
  end process start_xfer_p;

-- Want to make sure that it is not possible to read SPITXST at 1 while transfer is just started 
-- but does not show on wrtd_int yet
  begin_xfer_p : process (sys_clk)      --, sys_reset_n)
  begin
    --if (sys_reset_n = '0') then
    --  begin_xfer  <= '1';
    --  begin_xfer_p1<= '1';
    --els
    if (sys_clk'event and sys_clk = '1') then
      if (sys_reset_n = '0') then
        begin_xfer    <= '1';
        begin_xfer_p1 <= '1';
      else
        begin_xfer_p1 <= begin_xfer;
        if (REG_SPITXST = '1' and curr_state_spi = IDLE_S) then
          begin_xfer <= '0';
        elsif (wrtd_int = '0') then
          begin_xfer <= '1';
        end if;
      end if;
    end if;
  end process begin_xfer_p;


-- purpose: SPI state machine
--   On a Start of Transfer command, check the value of SPIRW register to know
--   if data must be shifted in or out of the FPGA.
--
-- inputs : start_xfer, shift_count, SPIRW
-- outputs: curr_state_spi
--
  spi_fsm_p : process (sys_clk)         --, sys_reset_n)
  begin
    if sys_clk'event and sys_clk = '1' then
      if sys_reset_n = '0' then
        curr_state_spi <= RESET_S;
      elsif (spi_clk_div2 = '1') then

        case curr_state_spi is
          when IDLE_S =>
            if start_xfer = '1' then
              if REG_SPIRW = '1' then
                curr_state_spi <= SHIFT_IN_S;
              else
                curr_state_spi <= SHIFT_OUT_S;
              end if;
            end if;
          when SHIFT_IN_S =>
            if shift_count = "111" then
              curr_state_spi <= IDLE_S;
            end if;
          when SHIFT_OUT_S =>
            if shift_count = "111" then
              curr_state_spi <= IDLE_S;
            end if;
          when others =>                -- RESET_S
            curr_state_spi <= IDLE_S;
        end case;
      end if;

    end if;
  end process spi_fsm_p;

--
-- purpose: Generate signals based on state machine
--
-- inputs : curr_state_spi, start_xfer, SPIRW, SPICMDDONE, regfile.SPI.SPIREGIN.SPISEL
-- outputs:
--   sclk_ena   : enable the clk going to the Flash
--   ce_enaN    : enable the Flash Chip Enable (active low)
--   load_outreg: load SPIDATAW in the output shift register
--   shift_in   : shift the incoming data (sdin) in the input shift register
--   shift_out  : shift the outgoing data (sdout) out of the output shift reg.
--   shift_count: counts the number of bits shifted
--   last_cmd   : indicates the last transaction for the command is in progress
--   wrtd_int   : Write Done; no transfer to/from Flash in progress
--
  spi_fsm_sig_p : process (sys_clk, sys_reset_n)
  begin
    if sys_reset_n = '0' then
      sclk_ena               <= '0';
      ce_enaN                <= '1';
      ce_enaN_AND_ce_enaN_FF <= '1';
      load_outreg            <= '0';
      shift_in               <= '0';
      shift_out              <= '0';
      shift_count            <= (others => '0');
      last_cmd               <= '0';
      wrtd_int               <= '1';

    elsif sys_clk'event and sys_clk = '1' then

      if (spi_clk_div2 = '1') then

        case curr_state_spi is
          when IDLE_S =>
            sclk_ena <= '0';
            -- ce must remain active for all the command duration
            if last_cmd = '1' then
              ce_enaN                <= '1';
              ce_enaN_AND_ce_enaN_FF <= ce_enaN;
            else
              ce_enaN                <= ce_enaN;
              ce_enaN_AND_ce_enaN_FF <= ce_enaN;
            end if;
            if REG_SPIRW = '0' and start_xfer = '1' then
              load_outreg <= '1';
            else
              load_outreg <= '0';
            end if;
            shift_in    <= '0';
            shift_out   <= '0';
            shift_count <= (others => '0');
            if REG_SPICMDDONE = '1' and start_xfer = '1' then
              last_cmd <= '1';
            else
              last_cmd <= '0';
            end if;
            wrtd_int <= '1';


          when SHIFT_IN_S =>
            sclk_ena               <= '1';
            ce_enaN                <= '0' or REG_SPISEL;  -- Active low select: selected when SPISEL=0
            ce_enaN_AND_ce_enaN_FF <= REG_SPISEL and ce_enaN;
            load_outreg            <= '0';
            shift_in               <= '1';
            shift_out              <= '0';
            shift_count            <= unsigned(shift_count) + 1;
            last_cmd               <= last_cmd;
            wrtd_int               <= '0';

          when SHIFT_OUT_S =>
            sclk_ena               <= '1';
            ce_enaN                <= '0' or REG_SPISEL;  -- Active low select: selected when SPISEL=0
            ce_enaN_AND_ce_enaN_FF <= REG_SPISEL and ce_enaN;
            load_outreg            <= '0';
            shift_in               <= '0';
            shift_out              <= '1';
            shift_count            <= unsigned(shift_count) + 1;
            last_cmd               <= last_cmd;
            wrtd_int               <= '0';

          when others =>                -- RESET_S
            sclk_ena               <= '0';
            ce_enaN                <= '1';
            ce_enaN_AND_ce_enaN_FF <= ce_enaN;
            load_outreg            <= '0';
            shift_in               <= '0';
            shift_out              <= '0';
            shift_count            <= (others => '0');
            last_cmd               <= '0';
            wrtd_int               <= '1';
        end case;

      end if;
    end if;
  end process spi_fsm_sig_p;


-- purpose: Shift the data in and out
--
-- inputs : load_outreg, shift_in, shift_out
-- outputs: outreg
  data_shift_out : process (sys_clk, sys_reset_n)
  begin
    if sys_reset_n = '0' then
      outreg(7 downto 0) <= (others => '0');  -- je reset le bit de sortie pour qu'il soit sur le meme control set que le output enable donc puisse etre mis dans le IOB
    elsif sys_clk'event and sys_clk = '1' then

      if (spi_clk_div2 = '1') then
        if load_outreg = '1' then
          outreg <= REG_SPIDATAW;
        elsif shift_out = '1' then
          outreg(7 downto 1) <= outreg(6 downto 0);
          outreg(0)          <= '0';
        end if;
      end if;
    end if;
  end process data_shift_out;



  data_shift_in : process (sys_clk)     --, sys_reset_n)
  begin
    --if sys_reset_n = '0' then
    --  inreg  <= (others => '0');
    --els
    if sys_clk'event and sys_clk = '1' then

      if spi_clk_div2 = '1' then
        if shift_in = '1' then
          inreg(7 downto 1) <= inreg(6 downto 0);
          inreg(0)          <= spi_sdin;
        end if;
      end if;
    end if;
  end process data_shift_in;

-- on laisse le reset asynchrone ici car on ne veux reellement pas driver les sorties lors d'un RESET. 
-- A ce moment, c'est le PCB qui determine les etats de signaux.
-- C'est vraiment la seule place valable pour mettre des reset asynchrone car la transition vers l'etat actif de notre reset (le reset PCI) est asynchrone.  
-- La sortie du reset est synchrone.
  spi_enable_p : process (sys_clk, sys_reset_n)
  begin
    if sys_reset_n = '0' then
      sclk_enable_n  <= '1';
      sdout_enable_n <= '1';
      csn_enable_n   <= '1';
    elsif sys_clk'event and sys_clk = '1' then
      sclk_enable_n  <= not regfile.SPIREGIN.SPI_ENABLE;
      sdout_enable_n <= not regfile.SPIREGIN.SPI_ENABLE;
      csn_enable_n   <= not regfile.SPIREGIN.SPI_ENABLE;

    end if;
  end process spi_enable_p;


--*********************--
-- Assign SPI outputs
--*********************--

-- Je crois que tous les probleme que Marie a eu avec ce signal est du a la polarite de sclk_enable. Malheureusement, Xilinx ne 
-- renverse pas la polarite pour les enables. Ce signal est le seul (a mon avis...) qui DOIT etre en polarite negative dans un design
-- Xilinx.

--spi_sclk    <= spi_sclk_iob             when sclk_enable_n = '0' else 'Z';
  spi_sclk    <= spi_sclk_iob;
  spi_sclk_ts <= sclk_enable_n;

  spi_sdout     <= outreg(7) when sdout_enable_n = '0' else 'Z';
-- version pour mettre les IOB a l'externe:
  spi_sdout_iob <= outreg(7);
  spi_sdout_ts  <= sdout_enable_n;

--spi_csN     <= (ce_enaN AND ce_enaN_FF) when csn_enable_n  = '0' else 'Z';
-- pour aider le timing, on va mettre dans le IOB?
  spi_csN     <= (ce_enaN_AND_ce_enaN_FF) when csn_enable_n = '0' else 'Z';
-- version pour mettre les IOB a l'externe:
  spi_csN_iob <= ce_enaN_AND_ce_enaN_FF;
  spi_csN_ts  <= csn_enable_n;

-- Assign registers outputs
  regfile.SPIREGOUT.SPI_WB_CAP <= '1';
  regfile.SPIREGOUT.SPIWRTD    <= begin_xfer and wrtd_int and fifo_idle and WRTD_TO_0;
  regfile.SPIREGOUT.SPIDATARD  <= inreg;


---------------------------------------------------
-- Pour faire descendre SPIWRTD un clk avant
---------------------------------------------------
  process (sys_clk, sys_reset_n)
  begin
    if sys_reset_n = '0' then
      WRTD_TO_0 <= '1';
    elsif sys_clk'event and sys_clk = '1' then
      if(fifo_empty = '1' and regfile.spiregin.spitxst = '1') then
        WRTD_TO_0 <= '0';
      else
        WRTD_TO_0 <= '1';
      end if;
    end if;
  end process;


end functional;
