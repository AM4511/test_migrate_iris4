-----------------------------------------------------------------------
-- $HeadURL: svn://brainstorm/fpga/trunk/Matrox/Imaging/FPGA/Iris2/cores/pcie_top/design/pcie_common/design/pcie_io_reg.vhd $
-- $Author: jlarin $
-- $Revision: 8653 $
-- $Date: 2012-03-14 11:37:26 -0400 (Wed, 14 Mar 2012) $
--
-- DESCRIPTION: Ce module fait le pont entre les requetes IO pcie qui 
--              arrivent, le bus reg_bus pour IO ou les requetes sont executee
--              et le module ou les completions sont envoyees.
--              
--              En theorie, les acces IO devraient etre serialise. 
--              Quand un master fait un read sur un UART, il doit
--              attendre le resultat du read avant d'en faire un autre
--              car les reads peuvent etre re-ordonne. Sinon, l'ordre
--              des donnee lues sur le UART serait aleatoire. Le host
--              peut poster certain IO write dans certaines condition
--              ou il peut garantir qu'il n'y aura pas de deadlock,
--              mais dans le cas specifique d'un UART, ca nous semble
--              impossible car un bridge intermediaire peut re-ordonner
--              une requete non-posted par rapport a une autre requete
--              non-posted, donc reordonner le data en write sur le
--              UART, ce qui serait innacceptable.
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
library work;
use work.pciepack.all;

entity pcie_io_reg is
  generic (
    ADDRWIDTH : natural := 4            -- Bit width
    );
  port (
    ---------------------------------------------------------------------
    -- Reset and clock signals
    ---------------------------------------------------------------------
    sys_clk     : in std_logic;
    sys_reset_n : in std_logic;

    ---------------------------------------------------------------------
    -- New receive request interface
    ---------------------------------------------------------------------

    tlp_in_accept_data : out std_logic;

    tlp_in_fmt_type       : in std_logic_vector(6 downto 0);  -- fmt and type field from decoded packet 
    tlp_in_address        : in std_logic_vector(31 downto 0);  -- 2 LSB a decoded from byte enables
    tlp_in_length_in_dw   : in std_logic_vector(10 downto 0);
    tlp_in_attr           : in std_logic_vector(1 downto 0);  -- relaxed ordering, no snoop
    tlp_in_transaction_id : in std_logic_vector(23 downto 0);  -- bus, device, function, tag
    tlp_in_valid          : in std_logic;
    tlp_in_data           : in std_logic_vector(31 downto 0);
    tlp_in_byte_en        : in std_logic_vector(3 downto 0);
    tlp_in_byte_count     : in std_logic_vector(12 downto 0);  -- byte count tenant compte des byte enables

    ---------------------------------------------------------------------
    -- New transmit interface
    ---------------------------------------------------------------------
    tlp_out_req_to_send : out std_logic;
    tlp_out_grant       : in  std_logic;

    tlp_out_fmt_type     : out std_logic_vector(6 downto 0);  -- fmt and type field 
    tlp_out_length_in_dw : out std_logic_vector(9 downto 0);

    tlp_out_src_rdy_n : out std_logic;
    tlp_out_dst_rdy_n : in  std_logic;
    tlp_out_data      : out std_logic_vector(31 downto 0);

    -- for master request transmit
    tlp_out_address     : out std_logic_vector(63 downto 2);
    tlp_out_ldwbe_fdwbe : out std_logic_vector(7 downto 0);

    -- for completion transmit
    tlp_out_attr           : out std_logic_vector(1 downto 0);  -- relaxed ordering, no snoop
    tlp_out_transaction_id : out std_logic_vector(23 downto 0);  -- bus, device, function, tag
    tlp_out_byte_count     : out std_logic_vector(12 downto 0);  -- byte count tenant compte des byte enables
    tlp_out_lower_address  : out std_logic_vector(6 downto 0);

    ---------------------------------------------------------------------
    -- PCIe Register FIFO error detection
    ---------------------------------------------------------------------
    RESET_STR_REG_ERR : in std_logic;

    reg_fifo_ovr : out std_logic;
    reg_fifo_und : out std_logic;

    ---------------------------------------------------------------------
    -- IO (uart) Registers interface
    ---------------------------------------------------------------------
    io_reg_done     : in std_logic;
    io_reg_readdata : in std_logic_vector(31 downto 0);

    io_reg_addr      : out std_logic_vector(ADDRWIDTH-1 downto 2);
    io_reg_write     : out std_logic;
    io_reg_read      : out std_logic;
    io_reg_beN       : out std_logic_vector(3 downto 0);
    io_reg_writedata : out std_logic_vector(31 downto 0)
    );
end pcie_io_reg;

architecture functional of pcie_io_reg is

  ---------------------------------------------------------------------------
  -- components
  ---------------------------------------------------------------------------
  component xil_pcie_reg_fifo is
    port (
      clk  : in std_logic;
      srst : in std_logic;

      wr_en : in  std_logic;
      din   : in  std_logic_vector(35 downto 0);
      rd_en : in  std_logic;
      dout  : out std_logic_vector(35 downto 0);

      data_count : out std_logic_vector(9 downto 0);
      empty      : out std_logic;
      full       : out std_logic;
      prog_full  : out std_logic;

      overflow  : out std_logic;
      underflow : out std_logic
      );
  end component;


  ---------------------------------------------------------------------------
  -- constants
  ---------------------------------------------------------------------------

  ---------------------------------------------------------------------------
  -- signals
  ---------------------------------------------------------------------------
  signal sys_reset : std_logic;

  -- state machine qui process les requetes venant du core pcie
  type process_request_type is (IDLE, ACCEPT, WAIT_DONE, EXECUTE);

  -- Rx state machine 
  signal next_req_state    : process_request_type;
  signal current_req_state : process_request_type;

  signal write_not_read : std_logic;

--   -- Register FIFO
  signal reg_fifo_rden  : std_logic;
  signal reg_fifo_empty : std_logic;
  signal reg_fifo_full  : std_logic;  -- pour l'instant, ce n'est qu'une information de debuggage
  signal reg_fifo_over  : std_logic;
  signal reg_fifo_under : std_logic;
  signal reg_fifo_wren  : std_logic;
  signal reg_fifo_din   : std_logic_vector(35 downto 0);
  signal reg_fifo_dout  : std_logic_vector(35 downto 0);
--  signal reg_data_count                   : std_logic_vector(9 downto 0);  
--   signal io_reg_hold                       : std_logic;


  -- state machine qui process les donnees a retourner aux requester (valeur en readback)
  type process_completion_type is (IDLE_COMP, GET_TRANSACTION_ID, WAIT_DATA, REQ_TX, TRANSFER_DATA);

  -- Rx state machine 
  signal next_compl_state    : process_completion_type;
  signal current_compl_state : process_completion_type;

  signal transaction_id            : std_logic_vector(tlp_out_transaction_id'range);
  signal completion_write_not_read : std_logic;  -- a la sortie du fifo, quand on envoie le completion


--  signal tlp_out_src_rdy_n_buf              : std_logic;

begin

  -- Ce state machine recoit les commandes du module pcie, les execute une a la fois en sauvegardant les bonnes infos dans le
  -- fifo de completion (pour read seulement) 
  combressm : process(current_req_state, tlp_in_valid, tlp_in_fmt_type, io_reg_done)
  begin

    case (current_req_state) is

      when IDLE =>

        if (tlp_in_valid = '1') then
          next_req_state <= ACCEPT;
        else
          next_req_state <= IDLE;
        end if;

      when ACCEPT =>
        -- Sur un IO read ou write on va vouloir sauvegarder des donne pour le completion
        next_req_state <= EXECUTE;

      when EXECUTE =>
        next_req_state <= WAIT_DONE;

      when WAIT_DONE =>
        -- contrairement aux acces Mem, les acces IO sont toujours 1 seul cycle
        if io_reg_done = '1' then
          next_req_state <= IDLE;
        else
          next_req_state <= WAIT_DONE;
        end if;


      when others =>
        next_req_state <= IDLE;

    end case;
  end process;

  flopressm : process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if sys_reset = '1' then
        current_req_state <= IDLE;
      else
        current_req_state <= next_req_state;
      end if;
    end if;
  end process;

  -- on mux certain data a mettre dans le fifo de completion
  -- les ID D, et 1 sont juste des marqueurs pour aider le debug. Je les mets dans le fifo juste parce que les BRAM ont 36 bits de toute facon. 
  -- Cependant, meme s'ils ne sont jamais utilise a la sortie du fifo, ils risquent ne pas etre enlever par l'optimisation, alors idealement il faudra enlever ces marqeur sur la version synthetisee.
  -- Alternativement, pour pouvoir recuperer des SEU sur le fifo sans resetter tout le systeme, on pourra utiliser ces marqueur pour resynchroniser les 2 SM de part et d'autre du fifo. O
  -- on n'implante pas ce mechanisme initialement pour ne pas cacher de bugs...
  with current_req_state select
    reg_fifo_din <= x"1" & tlp_in_fmt_type(6) & "0000000" & tlp_in_transaction_id when ACCEPT,  -- write not read est sauvegarder dans le MSB pour savoir s'il y aura du data dans le mot suivant le transaction ID dans le fifo
    x"D" & io_reg_readdata                                                        when others;  -- ou plutot IDLE. pour des acces IO, on n'a besoin que du transaction id, le reste est hardcode par le fait que c'est un acces IO

  -- techniquement, il faudrait flopper le reg_fifo_din et ajuster le reg_fifo_wren si jamais le io_reg_readdata change au clock suivant le io_reg_done...
  -- On va se sauver un peut de logique parce que en realite, un UART opere TELLEMENT plus lentement que le bus systeme
  fifowrprc : process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if sys_reset = '1' then
        reg_fifo_wren <= '0';
      elsif next_req_state = ACCEPT then  -- on store
        reg_fifo_wren <= '1';
      elsif current_req_state = WAIT_DONE and io_reg_done = '1' and write_not_read = '0' then  -- on store du data de readback a retourner au requester. 
        reg_fifo_wren <= '1';
      else
        reg_fifo_wren <= '0';
      end if;
    end if;
  end process;

  -- on sauvegarde si on doit faire un read ou un write pour le savoir pendant toute la transaction
  rnwprc : process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if current_req_state = IDLE then
        write_not_read <= tlp_in_fmt_type(6);  -- ce bit indique si la transaction est du payload avec ou sans data, ce qui est suffisant pour identifier un write vs read
      end if;
    end if;
  end process;

  -- feedback au module RX du core pcie.
  -- pour l'instant, c'est definit comme ceci: pour un TLP avec data, on acknowledge qu'on est pret a prendre le data avec tlp_in_accept_data, un clock par data
  -- Pour les read, il n'y a pas de data, alors un seul coup de clock acknowledge le TLP.
--   accdtaprc: process(sys_clk)
--   begin
--     if rising_edge(sys_clk) then
--       if sys_reset = '1' then
--         tlp_in_accept_data <= '0';
--       elsif current_req_state = STORE_TRANSACTION_ID then -- (and write_not_read = '0') condition implicite quand on est dans l'etat store: end condition for a read acknowledge
--         tlp_in_accept_data <= '0';
--       elsif current_req_state /= IDLE and conv_integer(execute_length) = 1 and write_not_read = '1' then -- end condition for a write access, on doit limite a autre que idle pour en pas couper le debut du write plus bas
--         tlp_in_accept_data <= '0';
--       elsif tlp_in_valid = '1' and current_req_state = IDLE and tlp_in_fmt_type(6)= '1' then -- start condition for a write access
--         tlp_in_accept_data <= '1';
--       elsif current_req_state = ACCEPT and write_not_read = '0' then -- start for a read acknowledge
--         tlp_in_accept_data <= '1';
--       end if;
--     end if;
--   end process;
  tlp_in_accept_data <= '1' when current_req_state = ACCEPT else '0';  -- dans la mesure ou c'est encode one-hot, c'est 100% equivalent a faire un process comme celui plus haut.

  regaddrprc : process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if current_req_state = ACCEPT then
        io_reg_addr <= tlp_in_address(io_reg_addr'high downto io_reg_addr'low);
      end if;
    end if;
  end process;

  -- le strobe reg read et reg write sont genere pendant l'etat execute seulement, dependant de si l'acces est un read ou un write
  regbusstrbprc : process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if next_req_state = EXECUTE then
        if write_not_read = '1' then
          io_reg_write <= '1';
          io_reg_read  <= '0';
        else
          io_reg_write <= '0';
          io_reg_read  <= '1';
        end if;
      else
        io_reg_write <= '0';
        io_reg_read  <= '0';
      end if;

      -- on flop le data puisque quand on l'accepte il va changer le clock suivant (?)
      io_reg_beN       <= not tlp_in_byte_en;
      io_reg_writedata <= tlp_in_data;

    end if;
  end process;

  -------------------------------------------------------
  -- FIFOs have active high reset
  -------------------------------------------------------
  sys_reset <= not sys_reset_n;

  ---------------------------------------------------------------------------
  -- We flop overrun/underrun info because it will not stay on FIFO interface.  
  -- It is Reset by reset_str_reg_err bit in PCIE_STR_REG register.
  ---------------------------------------------------------------------------
  process(sys_clk)
  begin
    if (sys_clk'event and sys_clk = '1') then
      if (sys_reset_n = '0' or RESET_STR_REG_ERR = '1') then
        reg_fifo_ovr <= '0';
      elsif (reg_fifo_over = '1') then
        reg_fifo_ovr <= reg_fifo_over;
      end if;
    end if;
  end process;

  process(sys_clk)
  begin
    if (sys_clk'event and sys_clk = '1') then
      if (sys_reset_n = '0' or RESET_STR_REG_ERR = '1') then
        reg_fifo_und <= '0';
      elsif (reg_fifo_under = '1') then
        reg_fifo_und <= reg_fifo_under;
      end if;
    end if;
  end process;

  ---------------------------------------------------------------------------
  -- instantiations
  ---------------------------------------------------------------------------
  xxil_pcie_reg_fifo : xil_pcie_reg_fifo
    port map (
      clk  => sys_clk,
      srst => sys_reset,

      wr_en => reg_fifo_wren,
      din   => reg_fifo_din,

      rd_en => reg_fifo_rden,
      dout  => reg_fifo_dout,

      data_count => open,
      empty      => reg_fifo_empty,
      full       => open,
      prog_full  => reg_fifo_full,      -- Will be full at 256/512

      overflow  => reg_fifo_over,
      underflow => reg_fifo_under
      );

  assert reg_fifo_full /= '1' report "REG FIFO FULL dans module IO, JF check ca" severity failure;

  -- determination de enough_data_to_send
  -- Le fifo est synchrone, alors le compte sera exact
  -- en fait, quand le state machine passe de GET_TRANSACTION_ID a WAIT_DATA, on lit un data, ce qui peut faire tomber le reg_data_count en dessous de dw_length_downcount 
  -- sans que le enough_data_to_send ait le temps de se mettre a jour. Mais dans ce cas, pour un register read, on sait que la situation va se resorber le coup de clock suivant.
  -- et qu'on va demander le TX pour un coup de clock, puis attendre que le header soit envoyer, donc bien assez de temps pour faire un seul reg read.
  -- pour l'interface memoire, c'est autre chose car le retour d'un read peut prendre un temps indefiniment long.
--   edtdprc: process(sys_clk)
--   begin
--     if rising_edge(sys_clk) then
--       if current_compl_state = GET_TRANSACTION_ID  or current_compl_state = NEXT_TLP then -- on doit d'abord forcer le signal a 0 au premier clock de wait data car le dw_length_downcount n'est pas valide 
--         enough_data_to_send <= '0';                  -- avant le wait data, donc enough_data_to_send est valide un clock plus tard, au deuxieme clock de wait_data
--       elsif conv_integer(reg_data_count) >= dw_length_downcount then
--         enough_data_to_send <= '1';
--       else
--         enough_data_to_send <= '0';
--       end if;
--     end if;
--   end process;


  -- Ce state machine recoit les information pour generer les TLP de completion. 
  -- Il recoit les donnes associees a la requete pour faire header, suivit du data a retourner
  combcomplsm : process(current_compl_state, tlp_out_grant, reg_fifo_empty, tlp_out_dst_rdy_n, reg_fifo_dout, completion_write_not_read)
  begin

    case (current_compl_state) is

      when IDLE_COMP =>
        if (reg_fifo_empty = '0') then
          next_compl_state <= GET_TRANSACTION_ID;
        else
          next_compl_state <= IDLE_COMP;
        end if;

      when GET_TRANSACTION_ID =>
        if (reg_fifo_empty = '0') then
          if reg_fifo_dout(31) = '0' then  -- write_not_read encode a l'entree du fifo sur le bit 31.
            -- sur un read, on devra attendre le data avant d'envoyer le completion
            next_compl_state <= WAIT_DATA;
          else
            -- mais sur un write, on peut deja envoyer le completion car la transaction est lancee sur une io_regbus et plus rien ne peut y changer.
            next_compl_state <= REQ_TX;
          end if;
        else
          next_compl_state <= GET_TRANSACTION_ID;
        end if;

      when WAIT_DATA =>
        if reg_fifo_empty = '0' then
          next_compl_state <= REQ_TX;
        else
          next_compl_state <= WAIT_DATA;
        end if;

      when REQ_TX =>
        if tlp_out_grant = '1' then
          if completion_write_not_read = '1' then
            -- si c'est un write, il n'y a pas de data
            next_compl_state <= IDLE_COMP;
          else
            -- si c'est un read, on a un data a envoyer,
            next_compl_state <= TRANSFER_DATA;
          end if;
        else
          next_compl_state <= REQ_TX;
        end if;

      when TRANSFER_DATA =>
        if tlp_out_dst_rdy_n = '0' then
          next_compl_state <= IDLE_COMP;
        else
          next_compl_state <= TRANSFER_DATA;
        end if;

      when others =>
        next_compl_state <= IDLE_COMP;

    end case;
  end process;

  flopcombsm : process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if sys_reset = '1' then
        current_compl_state <= IDLE_COMP;
      else
        current_compl_state <= next_compl_state;
      end if;
    end if;
  end process;

  -- on recupere les donnee a retourner avec le completion pour identifier la requete.
  --  x"1" & "000000" & "00" & tlp_in_transaction_id when others; 
  transidprc : process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if current_compl_state = GET_TRANSACTION_ID then
        transaction_id            <= reg_fifo_dout(transaction_id'range);
        completion_write_not_read <= reg_fifo_dout(31);  -- hardcode dans le mux plus haut
      end if;
    end if;
  end process;

  ------------------------------------------------
  -- generation des sorties sur l'interface TLP --
  ------------------------------------------------

  -- ici on patch pour etre compatible a l'ancien arbitre du module pcie_tx. Il faudrait revoir le protocol.
  -- Est-ce qu'un module devrait faire une requete puis le module TX lui donne le grant et l'agent requetant
  -- garde le grant jusqu'a ce que la transaction soit terminee?  Les deux modules savent la quantite de donne
  -- a transfere et peuvent donc determiner facilement la fin de la transaction, ca me semble naturel.
  -- soit qu'on revoit l'arbitre en consequence, ou soit qu'on recode cette ligne ci-bas pour flopper ce signal?
  tlp_out_req_to_send <= '1' when current_compl_state = REQ_TX or next_compl_state = TRANSFER_DATA else '0';

  tlp_out_fmt_type <= not completion_write_not_read & "001010";  -- toujours completion, With data sur un read, without data sur un completion de io write

  tlpoutlenprc : process(completion_write_not_read)
  begin
    if completion_write_not_read = '1' then
      -- pour un write, il n'y a pas de data
      tlp_out_length_in_dw <= conv_std_logic_vector(0, tlp_out_length_in_dw'length);
    else
      tlp_out_length_in_dw <= conv_std_logic_vector(1, tlp_out_length_in_dw'length);  -- les IO read sont toujours 1 DW
    end if;
  end process;

  with current_compl_state select
    reg_fifo_rden <= not tlp_out_dst_rdy_n when TRANSFER_DATA,
    '1'                                    when GET_TRANSACTION_ID,
    '0'                                    when others;

  tlp_out_src_rdy_n <= '0' when current_compl_state = TRANSFER_DATA else '1';
  tlp_out_data      <= reg_fifo_dout(31 downto 0);

  -- for master request transmit
  tlp_out_address     <= (others => '-');  -- nous somme un completeur, don't care
  tlp_out_ldwbe_fdwbe <= (others => '-');  -- nous somme un completeur, don't care

  -- for completion transmit
  tlp_out_attr           <= "00";       -- toujours 0 pour les acces io.
  tlp_out_transaction_id <= transaction_id;
  tlp_out_byte_count     <= conv_std_logic_vector(4, tlp_out_byte_count'length);  -- toujours 4 bytes comme completion
  tlp_out_lower_address  <= (others => '0');




end functional;

