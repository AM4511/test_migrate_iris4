-----------------------------------------------------------------------
-- $HeadURL: svn://brainstorm/fpga/trunk/Matrox/Imaging/FPGA/Iris2/cores/pcie_top/design/pcie_common/design/pcie_rx_axi.vhd $
-- $Author: jlarin $
-- $Revision: 9721 $
-- $Date: 2012-08-17 12:58:29 -0400 (Fri, 17 Aug 2012) $
--
-- DESCRIPTION: Receiving packet from Xilinx PCIe AXI core interface.
--              Veuillez noter que notre code utilise le fait que le
--              lien ne sortira jamais de l'etat D0, donc on n'a pas
--              besoin d'enregister les erreurs et de les transmettre
--              lorsque le lien retourne en D0.
--
-- NOTE: we use the fact (from spec) that: "The m_axis_rx_tvalid 
--       signal is never deasserted mid-packet."
--
-- TODO: -ajouter la verification des ECRC (dans le core ET que notre
--       module laisse tomber les TLP avec erreur de ECRC
--       -generer les erreurs sur TLP posted vs not posted
--       -accepter les TLP NP
--       -utiliser cfg_err_cpl_rdy pour generer les erreurs
--       -traiter la possibilite que le user_lnk_up descende en plein millieu du paquet
----------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all; 
  use ieee.std_logic_unsigned.all;
  use ieee.std_logic_arith.all;
library work;
  use work.pciepack.all;

entity pcie_rx_axi is
  generic(
  	NB_PCIE_AGENTS : integer := 3;
    --AGENT_TO_BAR   : integer_vector(NB_PCIE_AGENTS-1 downto 0);
    AGENT_TO_BAR   : integer_vector;
    C_DATA_WIDTH                                   : integer    := 64 -- pour l'instant le code est HARDCODE a 64 bits.
    );
  port (
    ---------------------------------------------------------------------
    -- Reset and clock signals
    ---------------------------------------------------------------------
    sys_clk                              : in    std_logic;
    sys_reset_n                          : in    std_logic;
    user_lnk_up                          : in    std_logic;

    ---------------------------------------------------------------------
    -- Transaction layer AXI receive interface
    ---------------------------------------------------------------------
	  -- RX
	  m_axis_rx_tdata                            : in std_logic_vector((C_DATA_WIDTH - 1) downto 0);
	  m_axis_rx_tkeep                            : in std_logic_vector((C_DATA_WIDTH / 8 - 1) downto 0);
	  m_axis_rx_tlast                            : in std_logic;
	  m_axis_rx_tvalid                           : in std_logic;
	  m_axis_rx_tready                           : out std_logic;
	  m_axis_rx_tuser                            : in std_logic_vector(21 downto 0);
	  rx_np_ok                                   : out std_logic;
	  rx_np_req                                  : out std_logic;

    ---------------------------------------------------------------------
    -- New receive request interface
    ---------------------------------------------------------------------
    
    tlp_in_accept_data                   : in  std_logic_vector(NB_PCIE_AGENTS-1 downto 0);
    tlp_in_abort                         : in  std_logic_vector(NB_PCIE_AGENTS-1 downto 0);

    tlp_in_fmt_type                      : out std_logic_vector(6 downto 0); -- fmt and type field from decoded packet 
    tlp_in_address                       : out std_logic_vector(31 downto 0); -- 2 LSB a decoded from byte enables
    tlp_in_length_in_dw                  : out std_logic_vector(10 downto 0); -- valeur maximal 4k
    tlp_in_attr                          : out std_logic_vector(1 downto 0); -- relaxed ordering, no snoop
    tlp_in_transaction_id                : out std_logic_vector(23 downto 0); -- bus, device, function, tag
    tlp_in_valid                         : out std_logic_vector(NB_PCIE_AGENTS-1 downto 0);
    tlp_in_data                          : out std_logic_vector(31 downto 0);
    tlp_in_byte_en                       : out std_logic_vector(3 downto 0);
    tlp_in_byte_count                    : out std_logic_vector(12 downto 0); -- byte count tenant compte des byte enables

    ---------------------------------------------------------------------
    -- Error detection
    ---------------------------------------------------------------------
    cfg_err_cpl_unexpect                 : out std_logic;
    cfg_err_posted                       : out std_logic;
    cfg_err_malformed                    : out std_logic;
    cfg_err_ur                           : out std_logic;
    cfg_err_cpl_abort                    : out std_logic;
    cfg_err_tlp_cpl_header               : out std_logic_vector(47 downto 0);
    cfg_err_cpl_rdy                      : in  std_logic;                        -- on devrait latcher les erreurs jusqu'a ce qu'on recoive le ready
    cfg_err_locked                       : out std_logic
  );
end pcie_rx_axi;    

architecture functional of pcie_rx_axi is

  ---------------------------------------------------------------------------
  -- constants
  ---------------------------------------------------------------------------

  ---------------------------------------------------------------------------
  -- types
  ---------------------------------------------------------------------------
  --type tlp_rx_state_type is (IDLE, HEAD_DW2, HEAD_DW3, HEAD_DW4, DATA_DW);
  type tlp_rx_state_type is (WAIT_H1H0, HEAD_H2, SIGNAL_VALID, DRIVE_LOW_DATA, DRIVE_HIGH_DATA, DROP_TLP);

  ---------------------------------------------------------------------------
  -- signals
  ---------------------------------------------------------------------------
  -- Transaction interface with PCIe core
  --signal trn_rdst_rdy_buf_n                : std_logic;

  -- Rx state machine 
  signal nxt_tlp_rx_state                 : tlp_rx_state_type;
  signal tlp_rx_state                     : tlp_rx_state_type;

  signal nxt_head_fmt                     : std_logic_vector(1 downto 0);
  signal head_fmt                         : std_logic_vector(1 downto 0);
  signal nxt_head_type                    : std_logic_vector(4 downto 0);
  signal head_type                        : std_logic_vector(4 downto 0);
  signal nxt_head_ep                      : std_logic;
  signal head_ep                          : std_logic;
  signal nxt_head_attr                    : std_logic_vector(1 downto 0);
  signal head_attr                        : std_logic_vector(1 downto 0);
  signal nxt_head_length                  : std_logic_vector(10 downto 0);
  signal head_length                      : std_logic_vector(10 downto 0);
  signal nxt_head_req_id                  : std_logic_vector(15 downto 0);
  signal head_req_id                      : std_logic_vector(15 downto 0);
  signal nxt_head_tag                     : std_logic_vector(7 downto 0);
  signal head_tag                         : std_logic_vector(nxt_head_tag'range);
  signal nxt_head_fdwbe                   : std_logic_vector(3 downto 0);
  signal head_fdwbe                       : std_logic_vector(3 downto 0);
  signal nxt_head_ldwbe                   : std_logic_vector(3 downto 0);
  signal head_ldwbe                       : std_logic_vector(3 downto 0);
  signal nxt_count_data                   : std_logic_vector(9 downto 0);
  signal count_data                       : std_logic_vector(9 downto 0);

  signal nxt_byte_cnt                     : std_logic_vector(12 downto 0);
  signal byte_cnt                         : std_logic_vector(12 downto 0);
  signal nxt_lower_add                    : std_logic_vector(1 downto 0);
  signal lower_add                        : std_logic_vector(1 downto 0);

  signal current_agent                    : integer range 0 to NB_PCIE_AGENTS-1;
  signal wait_acknowledge                 : std_logic;
  signal dropped_tlp                      : std_logic;
  signal packet_started                   : std_logic;
  signal tready                           : std_logic; -- version locale de m_axis_rx_tready

begin

  -------------------------------------------------------
  -- Enable receive non-posted ok for now
  -------------------------------------------------------
  rx_np_ok <= '1';
  rx_np_req <= '1';
  -- pour l'intant, on laisse tout passer.  Tout comme sur Iris2, ca ne devrait jamais etre un probleme car on en fait pas de req read.
  -- idealement, plus tard, il faudrait utilise le nouveau protocol rx_np_req.  On demande un NP et des que tous nos module qui peuvent recevoir des 
  -- requete NP sont suffissament vides, on en demande un autre.  

  ---------------------------------------------------------------------------
  -- Decoding all TLP RX packets
  -- We accept 3 and 4 DW headers, only 1 or 2 DW data (no 
  -- burst to registers accepted)
  --
  -- We only support traffic class 0 so do not forward the received TC field
  -- NOTE: we use the fact (from spec) that: "The m_axis_rx_tvalid signal is never deasserted mid-packet."
  ---------------------------------------------------------------------------
  comfsm:process(tlp_rx_state, m_axis_rx_tvalid, tlp_in_accept_data, current_agent, m_axis_rx_tdata,
          head_fmt, head_type, head_ep, head_attr, head_length, head_req_id, head_tag, head_ldwbe, 
          head_fdwbe, count_data, dropped_tlp, m_axis_rx_tlast, tlp_in_abort, tready)
  begin
    
    nxt_head_fmt    <= head_fmt;
    nxt_head_type   <= head_type;
    nxt_head_ep     <= head_ep;
    nxt_head_attr   <= head_attr;
    nxt_head_req_id <= head_req_id; 
    nxt_head_tag    <= head_tag;    
    nxt_head_ldwbe  <= head_ldwbe;
    nxt_head_fdwbe  <= head_fdwbe;
    nxt_count_data  <= count_data;
    nxt_head_length <= head_length; 
  
    nxt_tlp_rx_state <= tlp_rx_state;

    case (tlp_rx_state) is
  
      -- dans cet etat, on attend le premier QW qu contient H0 et H1 (headers du TLP)
      when WAIT_H1H0 =>
      
        if (m_axis_rx_tvalid = '1') then
          nxt_head_fmt    <= m_axis_rx_tdata(30 downto 29); -- packet format
          nxt_head_type   <= m_axis_rx_tdata(28 downto 24); -- TLP packet type field
          nxt_head_ep     <= m_axis_rx_tdata(14);           -- EP: poisoned data
          nxt_head_attr   <= m_axis_rx_tdata(13 downto 12); -- attributes: (13) RO relaxed ordering and (12) No snoop
          nxt_head_length(9 downto 0) <= m_axis_rx_tdata(9 downto 0);   -- TLP data payload transfer size
          -- cas particulier ou lenght = 1024 DW
          if conv_integer(m_axis_rx_tdata(9 downto 0)) = 0 then
            nxt_head_length(10) <= '1';
          else
            nxt_head_length(10) <= '0';
          end if;

          nxt_head_req_id <= m_axis_rx_tdata(63 downto 48); -- Requester ID = bus nb + dev nb + fct nb
          nxt_head_tag    <= m_axis_rx_tdata(47 downto 40);  -- Tag (for outstanding requests) 
          nxt_head_ldwbe  <= m_axis_rx_tdata(39 downto 36);
          nxt_head_fdwbe  <= m_axis_rx_tdata(35 downto 32);

          nxt_tlp_rx_state <= HEAD_H2;
        else
          nxt_tlp_rx_state <= WAIT_H1H0;      
        end if;


      -- dans cet etat, le bus de data contient H2 et possiblement H3 si addr 64 bits (ou autre TLP 4DW) sinon le premier data D0, s'il y a du data.
      when HEAD_H2 =>

        nxt_count_data   <= head_length(nxt_count_data'range); -- on passe toujours par head_dw3 alors on s'en sert pour resetter le compte
                                                               -- VEUILLEZ NOTER QU'ICI ON TRICHE UN PEU, on utilise un compteur qui va jusqu'a 1023
                                                               -- car on presume que notre core ne supporte pas les TLPs de 4Kbyte. Le head length peut etre de
                                                               -- 4kbyte pour les read et le nxt_count_data ne sert qu'a compter les data en write. 
                                                               -- Si jamais le core associe a ce module supporte les TLP de 4K, il faudra corriger ici.
    
        -- cas ou on drop un TLP. 
        if (dropped_tlp = '1') then
          if m_axis_rx_tlast = '1' then -- Il est possible qu'il n'y ait pas de data et que le paquet soit deja termine      
            nxt_tlp_rx_state <= WAIT_H1H0;
          else
            -- sinon, il faudra passer dans un etat d'attente
            nxt_tlp_rx_state <= DROP_TLP;
          end if;
        elsif (m_axis_rx_tvalid = '1') then  -- si on ne doit pas laisser tomber le paquet alors on doit le signaler a un de nos agents
          if (head_fmt(1) = '0') then -- no data
        
            nxt_tlp_rx_state <= SIGNAL_VALID; 

          elsif (head_fmt = "10") then  -- 3DW header with data
            nxt_tlp_rx_state <= DRIVE_HIGH_DATA; -- le premier data est dans la partie haute du QW

          else -- 4DW header
            nxt_tlp_rx_state <= DRIVE_LOW_DATA;
          end if;

        else
          nxt_tlp_rx_state <= HEAD_H2; -- situation impossible en fait, a cause de la facon que le core est fait, en theorie.
        end if;

      -- on attends le acknowledge du bon module,
      when SIGNAL_VALID => 
    
        if tlp_in_accept_data(current_agent) = '1' then      
          nxt_tlp_rx_state <= WAIT_H1H0; 
        elsif tlp_in_abort(current_agent) = '1' then  -- si on avorte un read, il faut aller un coup de clock en drop pour faire un ack sur le l'interface axi
          nxt_tlp_rx_state <= DROP_TLP;     
        else
          nxt_tlp_rx_state <= SIGNAL_VALID;      
        end if;

      -- dans cet etat, on drive directement la partie basse du QW de data vers notre agent
      when DRIVE_LOW_DATA =>
    
        if tlp_in_accept_data(current_agent) = '1' then      
        
          if conv_integer(count_data) = 1 then
            nxt_tlp_rx_state <= WAIT_H1H0;
            
            --assert m_axis_rx_tlast = '1' report "ERROR: probleme de longueur sur decodage de TLP dans pcie_rx_axi" severity FAILURE;
            nxt_count_data   <= (others => '-');

          else -- Continue collecting data
            nxt_count_data   <= count_data - '1';
            nxt_tlp_rx_state <= DRIVE_HIGH_DATA;
          end if;
        elsif tlp_in_abort(current_agent) = '1' then  -- si on avorte un write, on drop le reste du tlp
          nxt_tlp_rx_state <= DROP_TLP;     
        else
          nxt_tlp_rx_state <= DRIVE_LOW_DATA;      
        end if;

      -- dans cet etat, on drive directement la partie haute du QW de data vers notre agent
      when DRIVE_HIGH_DATA =>
    
        if tlp_in_accept_data(current_agent) = '1' then      
        
          if conv_integer(count_data) = 1 then
            nxt_tlp_rx_state <= WAIT_H1H0;
            
            --assert m_axis_rx_tlast = '1' report "ERROR: probleme de longueur sur decodage de TLP dans pcie_rx_axi" severity FAILURE;
            nxt_count_data   <= (others => '-');

          else -- Continue collecting data
            nxt_count_data   <= count_data - '1';
            nxt_tlp_rx_state <= DRIVE_LOW_DATA;
          end if;
        elsif tlp_in_abort(current_agent) = '1' then  -- si on avorte un write, on drop le reste du tlp

          nxt_tlp_rx_state <= DROP_TLP;     
        else
          nxt_tlp_rx_state <= DRIVE_HIGH_DATA;      
        end if;

      -- on drop un paquet, il faut juste attendre qu'il finisse.
      when DROP_TLP => 
    
        if m_axis_rx_tlast = '1' and tready = '1' then      
          nxt_tlp_rx_state <= WAIT_H1H0;      
        else
          nxt_tlp_rx_state <= DROP_TLP;      
        end if;
      
      when others =>
        null;
    end case;
  end process;

  ---------------------------------------------------------------------------
  -- Flopping tlp_rx_state state machine
  ---------------------------------------------------------------------------
  process(sys_clk)
  begin
    if (sys_clk'event and sys_clk = '1') then
      if (sys_reset_n = '0')  then
  
        count_data  <= (others => '0');
    
        tlp_rx_state <= WAIT_H1H0;
      else
        head_fmt    <= nxt_head_fmt;
        head_type   <= nxt_head_type;
        head_ep     <= nxt_head_ep;
        head_attr   <= nxt_head_attr;
        head_length <= nxt_head_length; 
        head_req_id <= nxt_head_req_id; 
        head_tag    <= nxt_head_tag;    
        head_ldwbe  <= nxt_head_ldwbe;
        head_fdwbe  <= nxt_head_fdwbe;
        count_data  <= nxt_count_data;
    
        tlp_rx_state <= nxt_tlp_rx_state;
        
        -- on deplace la verification de longeur du TLP ici car dans un process asynchrone, il y a une condition de course dans le clock ou le compte descent a 1.
        if tlp_rx_state = DRIVE_HIGH_DATA or tlp_rx_state = DRIVE_LOW_DATA then
          if tlp_in_accept_data(current_agent) = '1' then      
            if conv_integer(count_data) = 1 then
          -- synthesis translate_off
              assert m_axis_rx_tlast = '1' report "ERROR: probleme de longueur sur decodage de TLP dans pcie_rx_axi" severity FAILURE;
          -- synthesis translate_on
            end if;
          end if;
        end if;  
        
      end if;
    end if;
  end process;  

  --Ici il faut calculer differemment dependant de si la requete est un memory read ou autre chose. (voir spec 1.1 sect 2.2.9)
  process ( tlp_rx_state, head_fmt, head_fdwbe, lower_add, head_type)
  begin

    -- On utilise le nxt_lower_add pour rapporter une erreur dans ce cycle, ou pour envoyer une completion a un read, alors on peut mettre a jour
    -- la valeur sauvegarder sur tout les cycles, pas seulement sur les cycles de memread ou io
    if tlp_rx_state = HEAD_H2 then

      if head_fmt(1) = '0' and  head_type = "00000" then -- ceci est LA condition pour identifier les memread, pourrait etre calcule 1 cycle plus tot si necessaire.
        -- Avec un memory read, l'adresse depend des byte enables
        if (head_fdwbe = "0000" or head_fdwbe(0) = '1') then
          nxt_lower_add <= "00";
        elsif (head_fdwbe(1) = '1') then
          nxt_lower_add <= "01";
        elsif (head_fdwbe(2) = '1') then
          nxt_lower_add <= "10";
        else -- head_fdwbe(3) = '1'
          nxt_lower_add <= "11";
        end if;  
      else
        -- dans TOUS les autres cas 
        nxt_lower_add <= "00";
      end if;
    
    else
      nxt_lower_add <= lower_add;
    end if;
  end process;  

  process (sys_clk)
  begin
    if (sys_clk'event and sys_clk = '1') then
        lower_add <= nxt_lower_add;
    end if;
  end process;  

  ---------------------------------------------------------------------------
  -- On calcule la quantite de bytes necessaire pour l'envoyer a l'agent PCIE
  -- Ca sert, entre autres, a faire le completion.
  ---------------------------------------------------------------------------
  process (tlp_rx_state, head_fmt, head_type, head_ldwbe, head_fdwbe, head_length, byte_cnt)
    variable byte_to_rem_f : std_logic_vector(1 downto 0);
    variable byte_to_rem_l : std_logic_vector(1 downto 0);
  begin
    
    nxt_byte_cnt <= byte_cnt;

    -- ici aussi on revise la facon de generer le byte count pour ne plus etre dependant du bar_hit
    if tlp_rx_state = HEAD_H2 then -- ont met a jour a toutes les requetes recues, meme si on n'a pas besoin d'envoyer de completion

      if head_fmt(1) = '0' and  head_type = "00000" then -- ceci est LA condition pour identifier les memread, pourrait etre calcule 1 cycle plus tot si necessaire.
        -- ceci est la copie exacte du tableau de p.95 PCIe base spec rev 2.0.
        -- Peut-etre que ca pourrait etre code de maniere plus compacte, mais si ce code fonctionne, on va le laisser comme ca!
        -- Only 1 DW transaction  
        if (head_ldwbe = "0000") then
        
          if (head_fdwbe(3) = '1' and head_fdwbe(0) = '1') then
            nxt_byte_cnt(2 downto 0) <= "100";
          elsif ((head_fdwbe(2) = '1' and head_fdwbe(0) = '1') or (head_fdwbe(3) = '1' and head_fdwbe(1) = '1')) then
            nxt_byte_cnt(2 downto 0) <= "011";
          elsif (head_fdwbe = "0011" or head_fdwbe = "0110" or head_fdwbe = "1100") then
            nxt_byte_cnt(2 downto 0) <= "010";
          else
            nxt_byte_cnt(2 downto 0) <= "001";
          end if;
          nxt_byte_cnt(nxt_byte_cnt'high downto 3) <= (others => '0');

        -- More than 1 DW memory transaction 
        else
    
          if (head_fdwbe(0) = '1') then
            byte_to_rem_f := "00";
          elsif (head_fdwbe(1) = '1') then
            byte_to_rem_f := "01";
          elsif (head_fdwbe(2) = '1') then
            byte_to_rem_f := "10";
          elsif (head_fdwbe(3) = '1') then
            byte_to_rem_f := "11";
          else
            byte_to_rem_f := "00";
          end if;      
      
          if (head_ldwbe(3) = '1') then
            byte_to_rem_l := "00";
          elsif (head_ldwbe(2) = '1') then
            byte_to_rem_l := "01";
          elsif (head_ldwbe(1) = '1') then
            byte_to_rem_l := "10";
          elsif (head_ldwbe(0) = '1') then
            byte_to_rem_l := "11";
          else
            byte_to_rem_l := "00";
          end if;
    
          nxt_byte_cnt <= (head_length & "00") - byte_to_rem_l - byte_to_rem_f;

        end if;  
      else
        -- pour TOUTES les autres transaction, le byte count doit etre 4
        nxt_byte_cnt <= conv_std_logic_vector(4,nxt_byte_cnt'length);
      end if;
    
    end if;
  end process;  

  process (sys_clk)
  begin
    if (sys_clk'event and sys_clk = '1') then
      byte_cnt <= nxt_byte_cnt;
    end if;
  end process;  

  -------------------------------------------------------
  -- Exposer le paquet decode au agent interne du FPGA --
  -------------------------------------------------------
  tlp_in_fmt_type               <= head_fmt & head_type; 

  addrprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if tlp_rx_state = HEAD_H2 then 
        if head_fmt(0) = '0' then -- access 3DW, l'adresse est dans H2
          tlp_in_address(31 downto 2) <= m_axis_rx_tdata(31 downto 2);
        else
          -- acces 4DW, les LSB de l'adresse seront dans H3
          tlp_in_address(31 downto 2) <= m_axis_rx_tdata(63 downto 34);
        end if;          
      end if;
    
      -- les 2 LSB sont determine a partir des byte enables. Techniquement, ce decodage ne doit etre fait que pour les memory read completion
      -- pour tous les autres type de completion (io write en fait) ca doit etre 0. Ici on va toujours fournir l'info au module du FPGA qui
      -- effectue la transaction et on va cacher le besoin de mettre ca a 0 sur les autres completions dans le module pcie_tx, 
      -- au cas ou le module du FPGA aurait besoin d'avoir la premiere adresse de l'acces (pour un io_read 8 bits par exemple)
      if tlp_rx_state = HEAD_H2 then
        if (head_fdwbe = "0000" or head_fdwbe(0) = '1') then
          tlp_in_address(1 downto 0) <= "00";
        elsif (head_fdwbe(1) = '1') then
          tlp_in_address(1 downto 0) <= "01";
        elsif (head_fdwbe(2) = '1') then
          tlp_in_address(1 downto 0) <= "10";
        else -- head_fdwbe(3) = '1'
          tlp_in_address(1 downto 0) <= "11";
        end if;  
      end if;  
    
    end if;
  end process;
      
  tlp_in_length_in_dw           <= head_length;
  tlp_in_attr                   <= head_attr;
  tlp_in_transaction_id         <= head_req_id & head_tag;

  -- le but de ce process est de determiner quel agent est associe avec le BAR HIT qu'on recoit. 
  -- Certains bar sont 64 bits et occupent 2 BARs alors qu'il n'y a qu'un seul agent associe. 
  -- Aussi, il peut y avoir des trous dans les bars
  decodeagentprc: process(sys_clk)
    variable nb_agent_non_bar : integer;
  begin
    if rising_edge(sys_clk) then
    
      -- Le bar hit est valide pendant tout le TLP, alors on n'a pas besoin de checker si on est au debut du TLP
      -- Cependant, c'est indefini si la transaction n'est pas IO ou Memory, alors il faudra demontrer que ca ne fait pas
      -- de trouble de faire un faux decodage (ou un multiple decodage) dans le cas ou on recoit un autre type de TLP.
      if packet_started = '0' and m_axis_rx_tvalid = '1' then -- au premier transfer du tlp, on enregistre le bar correspondant
        current_agent <= 0; -- pour garantir que si aucune condition en bas est active, current_agent ne sera jamais en dehors de sa plage valide
        nb_agent_non_bar := 0;
        for i in 0 to NB_PCIE_AGENTS-1 loop
          if AGENT_TO_BAR(i) < 7 then -- il n'existe que les bar 0 a 5, plus 6 pour le expansion rom
            if m_axis_rx_tuser(AGENT_TO_BAR(i)+2) = '1' then -- on a un hit sur un des agents qu'on a declare, le +2 vient de la definition de l'interface AXI du core
              current_agent <= i;
            end if;
          else
            -- on est sur un agent master, donc il n'y a pas de bar hit associe. 
            -- c'est donc notre agent courant tant qu'il n'y a pas de bar_hit
            if conv_integer(m_axis_rx_tuser(9 downto 2)) = 0 then
              current_agent <= i;

              -- Si jamais on avait plusieurs agents masters, alors il faudrait etre plus selectif
              -- on va faire un assert a ce sujet ici
              nb_agent_non_bar := nb_agent_non_bar + 1;
              --assert nb_agent_non_bar <= 1 report "ERROR Code non prevu pour plus d'un agent DMA, revoir process decodeagentprc" severity FAILURE;
              -- En fait, cette situation ne surviendra que si nous recevons des completion, donc qu'on fait des acces IO (improbable) ou des DMA read, ce qu'on ne fait pas
              -- donc on ne devrais jamais arriver ici.
              
              -- En simulation nous arrivons ici lorsqu'on envoie un MSGD-64. Or le code plus bas gere deja la situation en droppant le TLP. 
              -- Dans ce cas, il ne sert a rien de rapporter un probleme ici. La journee qu'on voudra gerer des completion, comme dans le cas d'un DMA read, il faudra revoir le code, pas juste le assert.

            end if;
     
          end if;
        end loop;
      end if;
    end if;
  end process;  

  -- detecter les debuts de paquets
  -- le signal packet_started doit toujours etre qualifier avec m_axis_rx_tvalid
  starttlpdetectprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if sys_reset_n = '0' then
        packet_started <= '0';
      elsif m_axis_rx_tvalid = '1' and tready = '1' then
        packet_started <= not m_axis_rx_tlast;
      end if;
      
      if tlp_rx_state = WAIT_H1H0 then
        assert packet_started = '0' or sys_reset_n = '0' report "Quand on attend un debut de paquet, notre variable packet_started DOIT etre a 0, sinon on a un probleme" severity FAILURE;
      end if;
      
    end if;
  end process;

  -- Il arrive certaines situation ou on recoit un TLP mais on doit l'ignorer, ou ignorer son data
  -- dans l'implantation actuelle, on refuse tout "completion" puisqu'on a aucun agent qui font des non-posted master transactions.
  -- Aussi, le user-code ne traite pas d'aucun Message. Ils doivent soit etre intercepte par le core Xilinx, soit rapporter
  -- un UR, soit etre ignore de maniere silencieuse.
  -- Ce process sert a detecter cette condition et a debloquer la communication entre le core et les agents en consequence
  ignoredataprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if m_axis_rx_tvalid = '1' and packet_started = '0' then
        -- on commence un paquet.
        if conv_integer(m_axis_rx_tuser(9 downto 2)) = 0 then
          dropped_tlp <= '1';
        else
          dropped_tlp <= '0';
        end if;
      elsif (tlp_rx_state = DRIVE_LOW_DATA or tlp_rx_state = DRIVE_HIGH_DATA or tlp_rx_state = SIGNAL_VALID) and tlp_in_abort(current_agent) = '1' then -- si l'agent avorte le transfert, 
        dropped_tlp <= '1';  -- on avorte le frame
      end if;
    end if;
  end process;

  -- Handshake avec l'application
  tlpvalidprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if sys_reset_n = '0' then
        tlp_in_valid <= (others => '0');
        wait_acknowledge <= '0';
      elsif tlp_rx_state = HEAD_H2 and dropped_tlp = '0' then -- version compatible 64 bits
        wait_acknowledge <= '1';
        tlp_in_valid(current_agent) <= '1';
      elsif tlp_in_accept_data(current_agent) = '1' or tlp_in_abort(current_agent) = '1' then  
        tlp_in_valid <= (others => '0');
        wait_acknowledge <= '0';
      end if;
    end if;
  end process;

  -- on passe le data directement a l'agent. Le acknowlege pourra donc etre envoye directement au core.
  -- j'espere que ce acknowledge ( accept_data(i) ) muxe et combine avec les state machines de ce module pourront generer le signal m_axis_rx_tready sans erreur de timing.
  -- Reordering bytes, from big endian (PCIe) to little endian
  datamuxprc: process(tlp_rx_state, m_axis_rx_tdata)
  begin
    if tlp_rx_state = DRIVE_LOW_DATA then
      tlp_in_data(31 downto 24) <= m_axis_rx_tdata(7 downto 0); 
      tlp_in_data(23 downto 16) <= m_axis_rx_tdata(15 downto 8); 
      tlp_in_data(15 downto 8)  <= m_axis_rx_tdata(23 downto 16); 
      tlp_in_data(7 downto 0)   <= m_axis_rx_tdata(31 downto 24); 
    else
      tlp_in_data(31 downto 24) <= m_axis_rx_tdata(39 downto 32); 
      tlp_in_data(23 downto 16) <= m_axis_rx_tdata(47 downto 40); 
      tlp_in_data(15 downto 8)  <= m_axis_rx_tdata(55 downto 48); 
      tlp_in_data(7 downto 0)   <= m_axis_rx_tdata(63 downto 56); 
    end if;
  end process;

  -- on va generer des byte enable pre-digere pour les autres modules
  bytengenprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if (tlp_rx_state = HEAD_H2) then
        tlp_in_byte_en <= head_fdwbe; -- pour le premier word, c'est simple.
      elsif m_axis_rx_tvalid = '1' and tready = '1' then -- on ne met a jour QUE s'il y a un transfert.
        if tlp_rx_state = DRIVE_LOW_DATA or tlp_rx_state = DRIVE_HIGH_DATA then
          if conv_integer(count_data) = 2 then
            tlp_in_byte_en <= head_ldwbe; -- cas particulier du dernier DW
          else
            tlp_in_byte_en <= (others => '1'); -- tous les autre DW sont actif, par la spec 1.1
          end if;
        end if;
      end if;
    end if;
  end process;
  
  tlp_in_byte_count <= byte_cnt;

  ---------------------------------------------------------------------------
  -- Error detection
  --
  -- 1: Received a completion: always unexpected (no MRd requests implemented)
  -- 2: Vendor defined type 0 message (not supported)
  -- 3: read locked
  -- 5: Data poisoning for posted transaction EP = 1
  -- 6: Data poisoning for non-posted transaction EP = 1
  ---------------------------------------------------------------------------
  process(sys_clk)
  begin
    if (sys_clk'event and sys_clk = '1') then
      if (sys_reset_n = '0') then

        cfg_err_cpl_unexpect <= '0';

      -- 1: Received a completion (on any BAR)
      elsif (tlp_rx_state = HEAD_H2 and head_type(4 downto 1) = "0101") then
        cfg_err_cpl_unexpect <= '1';
      else
        cfg_err_cpl_unexpect <= '0';        
      end if;
    end if;
  end process;  

  process(sys_clk)
  begin
    if (sys_clk'event and sys_clk = '1') then

      if (sys_reset_n = '0') then
        cfg_err_posted          <= '0';
        cfg_err_ur              <= '0';
        cfg_err_tlp_cpl_header  <= (others => '0');
        cfg_err_malformed       <= '0';
        cfg_err_locked          <= '0';
        cfg_err_cpl_abort       <= '0';

      elsif tlp_rx_state = HEAD_H2 then
             
        -- on ne verifie pas qu'un MRdLk n'a pas de payload car on repond UR a tous les MRdLk
        
        -- on ne verifie pas que les CplD a 3 Dword car on rejette deja tous les Cpl*
        
        if head_type = "00010" -- access IO
          and head_fmt(0) = '1' then -- 4DW
            cfg_err_malformed <= '1';
        elsif (head_fmt(1) = '0') and (head_type = "00000") -- memread
            and
          (
            (conv_integer(head_length) /= 1 and head_fdwbe = "0000") -- si tlp plus grand que 1DW alors il faut qu'il y ait des bit actif dans le premier DW (ie, un 0 byte read doit indiquer 1 DW)
            or
            (conv_integer(head_length) = 1 and head_ldwbe /= "0000") -- si le TLP mesure 1 DW, alors les last byte enables doivent etre inactifs.
            or
            (conv_integer(head_length) /= 1 and head_ldwbe = "0000") -- si le TLP mesure plus que 1 DW, alors les last bytes enables doivent etre actifs.
            or
            ( 
              -- si la longueur de l'acces ne permet pas les bytes non-contigus
              (
                ( conv_integer(head_length) = 2 and
                  (
                    (head_fmt(0) = '0' and m_axis_rx_tdata(2) = '1' ) -- 3DW, addresse pas alignee sur QW
                    or
                    (head_fmt(0) = '1' and m_axis_rx_tdata(34) = '1' ) -- 4DW, addresse pas alignee sur QW
                  )
                )
                or
                ( conv_integer(head_length) > 2)
              )
              and -- et que les bytes sont non-contigus
              (
                head_fdwbe(3) = '0' -- toujours non-contigus, sauf cas 0000 qui est deja traite plus haut
                or
                (head_fdwbe(2) = '0' and head_fdwbe(1 downto 0) /= "00") -- si les bits 0 ou 1 sont actif, alors le bit 2 doit l'etre aussi
                or
                (head_fdwbe(1) = '0' and head_fdwbe(0) = '1')
                or
                head_ldwbe(0) = '0' -- toujours non-contigus, sauf cas 0000 qui est deja traite plus haut
                or 
                (head_ldwbe(1) = '0' and head_ldwbe(3 downto 2) /= "00") -- si le bit 1 est pas actif, il ne faut pas que les bits 2 ou 3 subsequents soient actif
                or
                (head_ldwbe(2) = '0' and head_ldwbe(3) = '1')
              )
            ) 
          )
           then
            cfg_err_malformed <= '1';
        else
            cfg_err_malformed <= '0';
        end if;
        
        
        if (  
            -- cas 2 vendor defined type 0 message
            (head_type(4) = '1' and -- identifie les messages
              (head_ldwbe & head_fdwbe) = x"7E") -- Vendor_defined type 0 code
              -- selon la spec, il faudrait aussi laisser passer le type 1: 01111111
              -- laisser passer:
              -- Ignored Messages (messages codes 01000000, 01000001,
              -- 01000011, 01000100, 01000101, 01000111, 01001000)
              -- mais toute le reste devrait faire un UR comme le type 0
            or
            (head_type = "00001") -- Memory Read Locked, ne doit pas etre supporte
                            
            or  
             -- 5 and 6: Data poisoning
            (head_ep = '1')
           ) then
          cfg_err_ur   <= '1';  

          if (head_type = "00001") then -- Memory Read Locked
            cfg_err_locked <= '1'; -- indiquer pourquoi on ne supporte pas la transaction
          else
            cfg_err_locked <= '0';
          end if;          
      
          -- 2: Memory write              
          if (head_fmt(1) = '1') then -- ici il y a une petite erreur de logique. Il est vrai que head_fmt(1) = '1' pour les posted write.
            cfg_err_posted <= '1';    -- mais il est aussi a 1 pour les io write, config write, message with data et completion with data.
                                      -- or seulement les message with data and memory write sont posted.  Pour que ce code soit bon, il faut
                                      -- garantir que les autres situations ne sont pas possibles. Il est vrai que les config write seront
                                      -- bloqués par le core.  Mais pas les i/o write et les completion with data.
          
          -- 3 and 4: Memory read: non-posted, need to send cpl info
          else
            cfg_err_posted <= '0';

            if head_fmt(0) = '0' then -- version 3DW, l'adresse est dans les LSB
              cfg_err_tlp_cpl_header(47 downto 43) <= m_axis_rx_tdata(6 downto 2); -- Lower addr 4 MSB
            else 
              -- version 64 bits, l'adresse est dans le DW superieur
              cfg_err_tlp_cpl_header(47 downto 43) <= m_axis_rx_tdata(38 downto 34); -- Lower addr 4 MSB
            end if;

            cfg_err_tlp_cpl_header(42 downto 41) <= nxt_lower_add;      -- Lower addr 2 LSB
            cfg_err_tlp_cpl_header(40 downto 29) <= nxt_byte_cnt(11 downto 0);       -- Byte Count
            cfg_err_tlp_cpl_header(28 downto 26) <= "000";              -- Traffic class
            cfg_err_tlp_cpl_header(25 downto 24) <= head_attr;          -- Attribute
            cfg_err_tlp_cpl_header(23 downto 8)  <= head_req_id;        -- Request ID
            cfg_err_tlp_cpl_header( 7 downto 0)  <= head_tag;           -- TAG
          
          end if;
        end if;
        
        -- dans l'etat HEAD_DW2, aucun completer ne va signaller d'erreur
        cfg_err_cpl_abort       <= '0';

      elsif tlp_in_abort(current_agent) = '1' then -- si l'agent a qui on a signale le TLP ne veut pas le traiter, il nous retourne un abort.
        assert tlp_rx_state = SIGNAL_VALID or tlp_rx_state = DRIVE_LOW_DATA or tlp_rx_state = DRIVE_HIGH_DATA report "UN AGENT DOIT RAPPORTER UN ABORT QUE LORSQU'ON LUI SIGNALLE UN TLP!" severity FAILURE;
        cfg_err_cpl_abort <= '1';          

        -- driver le posted en fonction du type de tlp
        -- 2: Memory write              
        if (head_fmt(1) = '1') then -- ici il y a une petite erreur de logique. Il est vrai que head_fmt(1) = '1' pour les posted write.
          cfg_err_posted <= '1';    -- mais il est aussi a 1 pour les io write, config write, message with data et completion with data.
                                    -- or seulement les message with data and memory write sont posted.  Pour que ce code soit bon, il faut
                                    -- garantir que les autres situations ne sont pas possibles. Il est vrai que les config write seront
                                    -- bloqués par le core.  Mais pas les i/o write et les completion with data.
        
        -- 3 and 4: Memory read: non-posted, need to send cpl info
        else
          cfg_err_posted <= '0';

          if head_fmt(0) = '0' then -- version 3DW, l'adresse est dans les LSB
            cfg_err_tlp_cpl_header(47 downto 43) <= m_axis_rx_tdata(6 downto 2); -- Lower addr 4 MSB
          else 
            -- version 64 bits, l'adresse est dans le DW superieur
            cfg_err_tlp_cpl_header(47 downto 43) <= m_axis_rx_tdata(38 downto 34); -- Lower addr 4 MSB
          end if;

          cfg_err_tlp_cpl_header(42 downto 41) <= nxt_lower_add;      -- Lower addr 2 LSB
          cfg_err_tlp_cpl_header(40 downto 29) <= nxt_byte_cnt(11 downto 0);       -- Byte Count
          cfg_err_tlp_cpl_header(28 downto 26) <= "000";              -- Traffic class
          cfg_err_tlp_cpl_header(25 downto 24) <= head_attr;          -- Attribute
          cfg_err_tlp_cpl_header(23 downto 8)  <= head_req_id;        -- Request ID
          cfg_err_tlp_cpl_header( 7 downto 0)  <= head_tag;           -- TAG
        
        end if;
        
        -- Les Unsupported Request sont detecte dans l'etat HEAD_DW2, ce qui est mutuellement exclusif a etre ici
        cfg_err_ur              <= '0';
        cfg_err_malformed       <= '0';
        cfg_err_locked          <= '0';

      elsif cfg_err_cpl_rdy = '1' then -- normalement c'est ici qu'on redescend les erreur a 0 au coup de clock suivant.
                                       -- si jamais l'interface erreur est busy, nous allons garder les erreur active un certain temps, 
                                       -- jusqu'a temps qu'on traite le prochain paquet au moins. Il est toujours possible qu'on drop des erreurs
                                       -- mais ce n'est que dans un cas improbable ou on en genere en quantite, dans lequel cas notre systeme
                                       -- est malade de toute facon
        cfg_err_ur        <= '0';        
        cfg_err_posted    <= '0';
        cfg_err_malformed <= '0';        
        cfg_err_locked    <= '0';
        cfg_err_cpl_abort <= '0';
      end if;  
        
    end if;
  end process;  

  -- a la fin, on ne voudra pas avoir directement de lien entre des fifos externes et le fait qu'on soit pret a recevoir des donnees
  rrdyprc:process(user_lnk_up, tlp_rx_state, tlp_in_accept_data, current_agent, dropped_tlp, count_data, head_fmt)
  begin
    if user_lnk_up = '0' then
      -- si le link est down, on devra flusher le TLP en cours.
      -- le core va finir d'envoyer le bon nombre de data en fonction du header. Il faudra trouver une facon de flusher le TLP. Mais dans tous les cas, il ne faut pas
      -- que le TLP a flusher reste bloque dans le core, alors on va l'accepter
      tready <= '1';
    else
      if tlp_rx_state = WAIT_H1H0 then
        -- on est toujours pret a recevoir du data quand c'est notre state machine qui attend la connection
        tready <= '1';
      elsif tlp_rx_state = HEAD_H2 and head_fmt = "11" then -- on est sur H3H2 en 4DW+data, donc on accepte pour pouvoir voir le data
        tready <= '1';
      elsif dropped_tlp = '1' then
        -- dans le cas ou on est en train d'ignorer un TLP, il faut le laisser rentrer dans le beurre.
        tready <= '1';
      elsif tlp_rx_state = DRIVE_HIGH_DATA or tlp_rx_state = SIGNAL_VALID or (tlp_rx_state = DRIVE_LOW_DATA and conv_integer(count_data) = 1) then
        -- si on a du data pour un agent pcie, on peut recevoir le data du core si cet agent est pret a recevoir le data
        tready <= tlp_in_accept_data(current_agent);
      else
        tready <= '0';
      end if;        
    end if;
  end process;

  -- Assigning output ports
  m_axis_rx_tready <= tready;

end functional;
    
