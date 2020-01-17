-----------------------------------------------------------------------
-- $HeadURL: svn://brainstorm/fpga/trunk/Matrox/Imaging/FPGA/Iris2/cores/pcie_top/design/pcie_common/design/pcie_tx_axi.vhd $
-- $Author: jlarin $
-- $Revision: 11436 $
-- $Date: 2013-07-30 13:47:21 -0400 (Tue, 30 Jul 2013) $
--
-- DESCRIPTION: Transmiting packets to Xilinx PCIe core AXI interface
--              Veuillez noter qu'on utilise le fait (garantie par 
--              spec) que lorsque le core nous permet d'envoyer le 
--              premier header d'un TLP, il garanti qu'on peut envoyer 
--              le TLP au complet sans se faire couper.
--
--  NOTE: Le passage d'un interface 32 bits a 64 bit est fait 
--        PARTIELLEMENT. Un generique doit etre utilise pour faire la 
--        selection.
-----------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all; 
  use ieee.std_logic_unsigned.all;
  use ieee.std_logic_arith.all;
  
library work;
  use work.pciepack.all;


entity pcie_tx_axi is
  generic(
  	NB_PCIE_AGENTS    : integer := 3;
    AGENT_IS_64_BIT   : std_logic_vector;    -- l'item 0 DOIT etre a droite.
    C_DATA_WIDTH      : integer := 64 -- pour l'instant le code est HARDCODE a 64 bits.
  );
  port (
    ---------------------------------------------------------------------
    -- Reset and clock signals
    ---------------------------------------------------------------------
    sys_clk                              : in    std_logic;
    sys_reset_n                          : in    std_logic;

    ---------------------------------------------------------------------
    -- Transaction layer transmit interface
    ---------------------------------------------------------------------
    --tx_buf_av                                  : in std_logic_vector(5 downto 0);
    --tx_cfg_req                                 : in std_logic; pas utilise a cause de tx_cfg_gnt en bas
    s_axis_tx_tready                           : in std_logic;
    s_axis_tx_tdata                            : out std_logic_vector((C_DATA_WIDTH - 1) downto 0);
    s_axis_tx_tkeep                            : out std_logic_vector((C_DATA_WIDTH / 8 - 1) downto 0);
    s_axis_tx_tlast                            : out std_logic;
    s_axis_tx_tvalid                           : out std_logic;
    s_axis_tx_tuser                            : out std_logic_vector(3 downto 0);
    --tx_cfg_gnt                                 : out std_logic;  hardcode a 1 un etage plus haut, donc pas necessaire ici.

    ---------------------------------------------------------------------
    -- Config information
    ---------------------------------------------------------------------
    cfg_bus_number                       : in    std_logic_vector(7 downto 0);
    cfg_device_number                    : in    std_logic_vector(4 downto 0);
    cfg_no_snoop_en                      : in    std_logic;
    cfg_relax_ord_en                     : in    std_logic;

    ---------------------------------------------------------------------
    -- New transmit interface
    ---------------------------------------------------------------------
    tlp_out_req_to_send                 : in  std_logic_vector(NB_PCIE_AGENTS-1 downto 0);
    tlp_out_grant                       : out std_logic_vector(NB_PCIE_AGENTS-1 downto 0);

    tlp_out_fmt_type                    : in  FMT_TYPE_ARRAY(NB_PCIE_AGENTS-1 downto 0);  -- fmt and type field 
    tlp_out_length_in_dw                : in  LENGTH_DW_ARRAY(NB_PCIE_AGENTS-1 downto 0);

    tlp_out_src_rdy_n                   : in  std_logic_vector(NB_PCIE_AGENTS-1 downto 0);
    tlp_out_dst_rdy_n                   : out std_logic_vector(NB_PCIE_AGENTS-1 downto 0);
    tlp_out_data                        : in  PCIE_DATA_ARRAY(NB_PCIE_AGENTS-1 downto 0);

    -- for master request transmit
    tlp_out_address                     : in  PCIE_ADDRESS_ARRAY(NB_PCIE_AGENTS-1 downto 0); 
    tlp_out_ldwbe_fdwbe                 : in  LDWBE_FDWBE_ARRAY(NB_PCIE_AGENTS-1 downto 0);

    -- for completion transmit
    tlp_out_attr                        : in  ATTRIB_VECTOR(NB_PCIE_AGENTS-1 downto 0); -- relaxed ordering, no snoop
    tlp_out_transaction_id              : in  TRANS_ID(NB_PCIE_AGENTS-1 downto 0); -- bus, device, function, tag
    tlp_out_byte_count                  : in  BYTE_COUNT_ARRAY(NB_PCIE_AGENTS-1 downto 0); -- byte count tenant compte des byte enables
    tlp_out_lower_address               : in  LOWER_ADDR_ARRAY(NB_PCIE_AGENTS-1 downto 0)
  );
end pcie_tx_axi;    

architecture functional of pcie_tx_axi is

  ---------------------------------------------------------------------------
  -- constant
  ---------------------------------------------------------------------------

  ---------------------------------------------------------------------------
  -- types
  ---------------------------------------------------------------------------
  type tlp_tx_state_type is (IDLE, HEADER_H1H0, HEADER_H2, LOAD_LOW, LOAD_HIGH, LOAD_64BITS, LOAD_DELAYED_LOW);

  ---------------------------------------------------------------------------
  -- signals
  ---------------------------------------------------------------------------
  signal nxt_tlp_tx_state                 : tlp_tx_state_type;
  signal tlp_tx_state                     : tlp_tx_state_type;

  signal nxt_gnt_id                       : integer;
  signal gnt_id                           : integer;

  -- signal relie a AXI
  signal tvalid                           : std_logic; -- s_axis_tx_tvalid mais qu'on peut relire a l'interne
  signal dst_rdy                          : std_logic; -- acquiesser le data venant de l'agent local PCIe.

  signal new_grant                        : std_logic;

  signal fmt_type                         : std_logic_vector(6 downto 0); -- c'est vraiment hardode par le protocole a 7 bits.
  signal tlp_length                       : std_logic_vector(9 downto 0) := (others => '0'); -- ici on hardcode qu'on ne supporte pas les TLPs de 4kbytes.
  signal byte_count                       : std_logic_vector(12 downto 0) :=(others => '0'); 
  signal ldwbe_fdwbe                      : std_logic_vector(7 downto 0); 
  signal transaction_id                   : std_logic_vector(tlp_out_transaction_id(0)'range);
  signal lower_address                    : std_logic_vector(tlp_out_lower_address(0)'range);
  signal address                          : std_logic_vector(tlp_out_address(0)'range);
  signal attr                             : std_logic_vector(tlp_out_attr(0)'range);

  signal tlp_out_data_p1                  : std_logic_vector(31 downto 0);
  
  constant AGENT_IS_64_BIT_DOWNTO         : std_logic_vector(AGENT_IS_64_BIT'length-1 downto 0) := AGENT_IS_64_BIT; -- pour controler l'ordre et le mettre le LSB a droite.

begin
 
  -----------------------------------------------------------------------------
  -- PCIe tx arbiter.
  -----------------------------------------------------------------------------
  process (tlp_out_req_to_send)
    variable gnt_set : std_logic;
  begin

    gnt_set        := '0'; -- This variable is used to acknowledge only one requester 

    nxt_gnt_id     <= 0; -- on met 0 pour ne pas que la meme valeur traine dans ce module, demandant que l'ancienne valeur soit dans la boucle de feedback

    -- simple priority encoder qui donne la priorite aux agent au numero le plus faible
    for i in tlp_out_req_to_send'high downto tlp_out_req_to_send'low loop   -- donner la priorite au numero le plus haut, normalement le DMA
      if tlp_out_req_to_send(i) = '1' and gnt_set = '0' then
        gnt_set          := '1';
        nxt_gnt_id       <= i;
      end if;
    end loop;  -- i

  end process;

  -- plus bas dans le code, on veut utiliser le fait que lorsque la logique nous demande d'envoyer un TLP (DMA, reponse a un read, etc), il y a toujours
  -- du data d'envoye avec le header. On le verifie ici.
  process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      for i in tlp_out_req_to_send'range loop
        if sys_reset_n = '1' then -- apres le reset
          assert tlp_out_req_to_send(i) = '0' or tlp_out_req_to_send(i) = '1' report "tlp_out_req_to_send(i) n'est pas 0 ou 1, il y a contention?" severity FAILURE;
        end if;
        if tlp_out_req_to_send(i) = '1' then
          -- synthesis translate_off
          assert conv_integer(tlp_out_length_in_dw(i)) /= 0 report "LONGUEUR DU TLP DEMANDE EST 0, c'est un cas ambigu!" severity warning;
          -- synthesis translate_on
          -- en fait, en y pensant bien, un agent pourrait envoyer un TLP sans data encode dans le type. Dans le cas, le type doit etre dominant et le length doit etre don't care...
        end if;
      end loop;
    end if;
  end process;

  -----------------------------------------------------------------------------
  -- Flopped gnt_id
  --  Spartan-6 FPGA complains about gnt_id logic and creates a latch: with 
  --  synchronous reset, it is fine.
  -----------------------------------------------------------------------------
  process(sys_clk)
  begin
    if (sys_clk'event and sys_clk = '1') then
      if new_grant = '1' then
        gnt_id <= nxt_gnt_id;
      end if;
    end if;
  end process;

  -- grant enable qui indique qu'on doit debuter une nouvelle transmission
  process(tlp_tx_state, tlp_out_req_to_send, s_axis_tx_tready)
  begin
    --if tlp_tx_state = IDLE and trn_tdst_rdy_n = '0' and conv_integer(tlp_out_req_to_send) /= 0 then
    if tlp_tx_state = IDLE and s_axis_tx_tready = '1' and conv_integer(tlp_out_req_to_send) /= 0 then
      -- on ne peut partir de transaction que si on est idle et que le core PCIe accepte le EOF precedent.  Et qu'un agent demande le bus, evidemment.
      new_grant <= '1';
    else
      new_grant <= '0';
    end if;
  end process;

  -- le new grant est actif quand on debute reellement l'envoie d'un TLP au core PCIe. 
  -- On peut donc acknowledger a l'agent qu'on a deja tout ramasser les info du header dont on a besoin et qu'il peut descendre sa requete.
  givegrantprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      for i in tlp_out_grant'range loop
        if new_grant = '1' and nxt_gnt_id = i then
          tlp_out_grant(i) <= '1';
        else
          tlp_out_grant(i) <= '0';
        end if;
      end loop;
    end if;
  end process;  
  
  ----------------------------------------------------------------------------
  -- On enregistre certains elements de la requete pour utilisation interne --
  ----------------------------------------------------------------------------
  savehdrprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if new_grant = '1' then
        fmt_type <= tlp_out_fmt_type(nxt_gnt_id);
        byte_count <= tlp_out_byte_count(nxt_gnt_id);
        transaction_id <= tlp_out_transaction_id(nxt_gnt_id);
        lower_address <= tlp_out_lower_address(nxt_gnt_id);
        attr <= tlp_out_attr(nxt_gnt_id);
        address <= tlp_out_address(nxt_gnt_id);
        ldwbe_fdwbe <= tlp_out_ldwbe_fdwbe(nxt_gnt_id);
      end if;
    end if;
  end process;

  -- ici en theorie, il faudrait ajouter un bit pour supporter le cas de 4kbytes. Presentement, le core supporte 512 bytes ou 128 bytes, dependant du modele. On est tres loin du 4k
  -- et on ne peut voir quand est-ce que ca sera utile dans un avenir previsible.  
  -- alternativement, on pourrait reduire la profondeur de ce compteur. 
  -- Mais en realite, j'espere que tous les agents vont hardcoder les bits hauts a 0 et que la synthese va stripper ces bit automatiquement
  tlplenprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if new_grant = '1' then
        tlp_length <= tlp_out_length_in_dw(nxt_gnt_id);
      elsif (tlp_tx_state = HEADER_H2 and fmt_type(5) = '0' and (tvalid = '0' or s_axis_tx_tready = '1')) -- cas du premier data avec le header H2
            or tlp_tx_state = LOAD_LOW or tlp_tx_state = LOAD_HIGH then -- on compte les donnees qu'on charge sur le bus axi
        tlp_length <= tlp_length - '1';
      elsif tlp_tx_state = LOAD_64BITS then
        -- synthesis translate_off
        assert conv_integer(tlp_length) >= 2 report "ON TENTE DE DECREMENTER LE tlp_length SOUS 0!" severity FAILURE;
        -- synthesis translate_on
        tlp_length <= tlp_length - "10";
      end if;
    end if;
  end process;

  -- On doit dire a notre agent pcie local quand est-ce qu'on accepte ses donnees. 
  -- Idealement, on veut flopper ce signal, question d'aider le timing a la sortie de notre module
  -- On doit etre actif (bas) avec essentiellement les memes condition que lorsque le tlp_length VA REDUIRE de 1.
  -- le hic, c'est que le signal s_axis_tx_tready vient de l'exterieur et est donc non-predictible un clock d'avance.
  -- En fait, dès que le début du paquet est accepté, donc H1H0 est sur le data bus et s_axis_tx_tready est à 1, alors 
  -- il est garanti que le reste du tlp sera accepté. Or le plus tard que le core peut descendre son s_axis_tx_tready,
  -- c'est quand on est dans l'etat HEADER_H2; c'est donc seulement dans cet état qu'on va surveiller s_axis_tx_tready.
  -- code version combinatoire:
  tlpoutreadyprc: process(fmt_type, s_axis_tx_tready, tlp_tx_state)
  begin
    if fmt_type(6) = '1' then -- est-ce qu'il y a du data? 
      if fmt_type(5) = '0' and tlp_tx_state = HEADER_H2 then -- est-ce la version 3 DW et qu'on est dans le header H2 (donc que le LSB est du data)
        dst_rdy <= s_axis_tx_tready; -- on ne prendra le data que si le core accepte notre header H1H0 dans ce clock-ci.
      elsif tlp_tx_state = LOAD_LOW or tlp_tx_state = LOAD_HIGH or tlp_tx_state = LOAD_64BITS then
        dst_rdy <= '1'; -- dans les etats de transfert de data, on accepte toujours le data (sachant que le core ne va jamais nous couper avant la fin de notre paquet)
      else
        dst_rdy <= '0'; -- dans les autres etat, n'accepte pas de data.
      end if;
    else 
      dst_rdy <= '0'; -- si le TLP est sans data, alors ne va pas acquiesser le data inexistant
    end if;
  end process;

  -- verification de protocol src rdy et dst ready
  checksrcprc:process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if dst_rdy = '1' then
        -- on gobe les donnes sur tlp_out_data, il faut que notre feed de data nous indique que le data est valide.
        -- synthesis translate_off
        assert tlp_out_src_rdy_n(gnt_id) = '0' report "La source ne donne plus de donnees valide avant la fin du TLP" severity FAILURE;
        -- synthesis translate_on
      end if;
    end if;
  end process;
  
  -- temporaire, un peu de construction.
  -- Le timing de ce code est effroyable.  On va verifier que ca fonctionne en simulation, puis on recodera pour aider le timing en place-and-route
  ackrecvdataprc: process(sys_clk,dst_rdy, gnt_id)
  begin
    --if rising_edge(sys_clk) then
      -- en theorie ici le code peut deduire que pendant le reset, le next_state ne sera pas HEAD_DW3_DATA_DW. Il faudra surveiller ce que ca donne en simulation et en vrai FF.
      -- Le reset devrait forcer tous les FF a etre inactif (1)
      
      for i in tlp_out_dst_rdy_n'range loop
        if dst_rdy = '1' and i = gnt_id then
          tlp_out_dst_rdy_n(i) <= '0';
        else
          tlp_out_dst_rdy_n(i) <= '1';
        end if;
      end loop;
    --end if;
  end process;

  -----------------------------------------------------------------------------
  -- Encoding TX TLP state machine, header + data
  -----------------------------------------------------------------------------
  process(tlp_tx_state, gnt_id,  tlp_length, fmt_type, new_grant,  tvalid, s_axis_tx_tready)
  begin 

    -- pour garantir qu'il n'y a pas de latch.
    nxt_tlp_tx_state <= tlp_tx_state;

    if tvalid = '0' or s_axis_tx_tready = '1' then -- si on output rien, alors c'est certain qu'on peut changer ce qu'on ouput.  Si le core accepte ce qui est sur le bus aussi on peut le changer
    
      case tlp_tx_state is
        when IDLE =>
    
          -- le new_grant verifie deja que le core xilinx est pret a partir.
          if new_grant = '1' then
            nxt_tlp_tx_state <= HEADER_H1H0;
          else
            nxt_tlp_tx_state <= IDLE;      
          end if;
      
        when HEADER_H1H0 =>
          -- synthesis translate_off
          assert fmt_type(6 downto 5) /= "01" report "CAS 4DW NO DATA PAS SUPPORTE INITIALEMENT" severity FAILURE;
          -- synthesis translate_on
          
          nxt_tlp_tx_state <= HEADER_H2; -- on doit toujours passer par l'etat H2, lequel incluera D0H2 et H3H2.
          --if fmt_type(5) = '1' then -- 4DW: transaction 64 bits (ou message, peut-etre dans le futur?)
          --elsif fmt_type(6)) = '1' then -- 3DW (implique par else), avec data
          --  nxt_tlp_tx_state <= HIGH_DATA_LOADED; -- on charge le H2 et le D0 dans ce cycle, donc au prochain cycle le data high sort.
          --else
          --  nxt_tlp_tx_state <= HEADER_H2; -- cas 3DW sans data
          --end if;

        when HEADER_H2 =>
          if fmt_type(6) = '0' then --  sans data
            nxt_tlp_tx_state <= IDLE; -- sans data, on a fini le TLP
          elsif fmt_type(5) = '0' and conv_integer(tlp_length) = 1 then -- avec data (car on est dans le else) 3DW seulement ET c'est le seul data a transferer
            nxt_tlp_tx_state <= IDLE;
          elsif AGENT_IS_64_BIT_DOWNTO(gnt_id) = '0' then -- version plus propre utilisant le generique
            nxt_tlp_tx_state <= LOAD_LOW; -- on a du data a transmettre encore avec ce QW
          elsif fmt_type(5) = '1' and conv_integer(tlp_length) = 1 then -- avec data (car on est dans le else du fmt_type(6)) 4DW seulement, agent 32 ou 64 bits ET il y a 1 data a transferer
            nxt_tlp_tx_state <= LOAD_LOW; 
          elsif fmt_type(5) = '0' and conv_integer(tlp_length) = 2 then -- avec data (car on est dans le else du fmt_type(6)) 3DW seulement, agent 64 bits ET il y a deux data a transferer
            nxt_tlp_tx_state <= LOAD_DELAYED_LOW; 
          else
            nxt_tlp_tx_state <= LOAD_64BITS;
          end if;

        when LOAD_LOW =>
          if conv_integer(tlp_length) = 1 then -- ici on pourrait ameliorer le timing en predisant le resultat de la comparaison et en floppant.
            nxt_tlp_tx_state <= IDLE;
          else
            nxt_tlp_tx_state <= LOAD_HIGH;      
          end if;
      
        when LOAD_HIGH =>
          if conv_integer(tlp_length) = 1 then -- ici on pourrait ameliorer le timing en predisant le resultat de la comparaison et en floppant.
            nxt_tlp_tx_state <= IDLE;
          else
            nxt_tlp_tx_state <= LOAD_LOW;      
          end if;

        when LOAD_64BITS =>
          -- synthesis translate_off
          assert conv_integer(tlp_length) /= 1 report "SI LA LONGUEUR EST 1, ON DEVRAIT ETRE EN LOAD LOW!" severity FAILURE;
          -- synthesis translate_on
          if conv_integer(tlp_length) = 2 then -- ici on pourrait ameliorer le timing en predisant le resultat de la comparaison et en floppant.
            nxt_tlp_tx_state <= IDLE;
          elsif conv_integer(tlp_length) = 3 then -- s'il reste 3 DW et qu'on va en transfere 2 dans ce cycle, au prochain il n'en restera qu'un qui sera mis dans la partie low du 64 bits
            if fmt_type(5) = '0' then -- si c'est 3 DW, la sortie est decalee d'un DW sur l'entree, on passe dans l'etat DELAYED pour flusher le dernier data          
              nxt_tlp_tx_state <= LOAD_DELAYED_LOW;
            else
              -- 4 DW, il ne reste qu'un DW a sortir, c'est analogue a transferer en 32 bits
              nxt_tlp_tx_state <= LOAD_LOW;
            end if;
          else
            nxt_tlp_tx_state <= LOAD_64BITS;      
          end if;
      
        when LOAD_DELAYED_LOW =>
          -- dans cet etat, on flush le dernier DW, donc on se retrouve idle ASSUREMENT au prochain cycle
          -- synthesis translate_off
          assert conv_integer(tlp_length) = 1 report "SI LA LONGUEUR N'EST PAS 1, ON NE DEVRAIT PAS ETRE EN LOAD DELAYED LOW!" severity FAILURE;
          -- synthesis translate_on
          nxt_tlp_tx_state <= IDLE;

        when others =>
          null;
      end case;
    end if;
    
  end process;

  -----------------------------------------------------------------------------
  -- Flopping process
  -----------------------------------------------------------------------------
  process(sys_clk)
  begin
    if (sys_clk'event and sys_clk = '1') then

      if (sys_reset_n = '0') then
  
        tlp_tx_state <= IDLE;
      else
    
        tlp_tx_state <= nxt_tlp_tx_state;
      end if;

    end if;         
  end process;


  -----------------------------------------------------------------------------
  -- Encoding TX TLP state machine, header + data
  -- AXI interface with Xilinx PCIe core
  -----------------------------------------------------------------------------
  trntdprc:process(sys_clk)
  begin 
    if rising_edge(sys_clk) then
    
      -- creer une version retardee du data pour faire le shift de 32 bit entre le bus de data interne et le core PCIe

      -- parce que lorsqu'il y a des donnes valables dans tlp_out_data, il est garanti que le core va accepter tout notre TLP sans wait-states, 
      -- il n'est pas necessaire ici de mettre une clock enable sur cette assignation. Cependant, pour sauver de la puissance, on pourrait ne mettre a jour
      -- cette valeur que si dst_rdy = '1'. Est-ce que ca va faire un nouveau control set qui va limiter le packing des FF? Est-ce qu'on serait mieux d'utiliser
      -- tvalid = '0' or s_axis_tx_tready = '1' pour etre sur le meme control set? Il faudra regarder ca apres le place&route pour juger.
      
      -- ca plante en simulation si utilise gnt_id avant qu'il soit valide, je vais donc mettre un enable inclusif et on verra si un autre enable est plus efficace (power/routing) plus tard.
      if tlp_tx_state /= IDLE then
        tlp_out_data_p1 <= tlp_out_data(gnt_id)(63 downto 32);
      end if;
      
        if tvalid = '0' or s_axis_tx_tready = '1' then -- si on output rien, alors c'est certain qu'on veut envoyer au core.  Si le core accepte ce qui est sur le bus aussi on peut le changer

        case tlp_tx_state is

          -- quand on est idle, alors on se prepare a envoyer le premier 64 bits de header
          -- on utilise la garantie du core que si le premier word est accepte, alors tout le TLP est accepte sans throttling
          when HEADER_H1H0 =>

            s_axis_tx_tdata(31)           <= '0';  -- reserved
            s_axis_tx_tdata(30 downto 24) <= fmt_type; -- le format et type est choisi par le requerant
            s_axis_tx_tdata(23 downto 14) <= (others => '0');  -- TC = 0 always, TD = 0 always,
                                                      --  never sending poisonous CLPD

            -- pour les attributes
            if fmt_type(5 downto 1) = "00101" then -- ceci identifie uniquement tous les CPL et CPLD
              -- pour un completion, il faut toujours retourner les attributs du request, donc ces attributs viennent de l'agent PCI qui a execute la requete.
              s_axis_tx_tdata(13 downto 12) <= attr;
            else
              -- quand on fait un DMA, on se fiche bien de l'ordre dans lequel les parties de l'image sont ecrite en memoire. Le driver ne doit pas
              -- se fier a ce qu'il voit dans la memoire host avant qu'il recoive l'interrupt de fin de DMA. Or ce message vers le host 
              -- (emule ou MSI) aura toujours le relaxed ordering desactive et va donc pousser tous les writes a la memoire. On veut donc toujours
              -- utiliser le relaxed ordering avec le DMA write vers le host.
              -- Pour ce qui est du No snoop, on doit signaler au host au host le no_snoop si on peut garantir que la ligne en question n'est pas cachee par le systeme.
              -- je ne vois pas comment est-ce que le driver peut faire ca dans notre cas, donc on hardcode ce bit a off.
              s_axis_tx_tdata(13 downto 12) <= cfg_relax_ord_en & '0'; -- Attributes
            end if;
        
            s_axis_tx_tdata(11 downto 10) <= "00"; -- reserved
            s_axis_tx_tdata(9 downto 0) <= tlp_length(9 downto 0);

            if fmt_type(5 downto 1) = "00101" then -- ceci identifie uniquement tous les CPL et CPLD (pourrait etre pre-calcule et floppe)
              s_axis_tx_tdata(63 downto 48) <= cfg_bus_number & cfg_device_number & "000"; -- Completer/Req ID, fct always 0
              s_axis_tx_tdata(47 downto 45) <= "000"; -- Only send successful completion by TRN interface, otherwise, use error signals
              s_axis_tx_tdata(44)           <= '0';   -- Byte count modified always 0 for PCIe completer

              -- le byte count est disponible un coup de clock apres le new grant
              s_axis_tx_tdata(43 downto 32)  <= byte_count(11 downto 0); -- c'est ici qu'on strip le MSB, donc pour une completion de 4k la valeur sera 0, tel qu'entendu par la spec pcie

            else
              -- non-completion. Pour l'instant, on presume memory write
              s_axis_tx_tdata(63 downto 48) <= cfg_bus_number & cfg_device_number & "000"; -- Completer/Req ID, fct always 0
              s_axis_tx_tdata(47 downto 40)  <= "00000000";    -- Tag always 0 for posted transactions

              s_axis_tx_tdata(39 downto 32)   <= ldwbe_fdwbe; -- Last DW byte enable and First DW byte enable
              --s_axis_tx_tdata(7 downto 0)   <= tlp_out_ldwbe_fdwbe; -- Last DW byte enable and First DW byte enable
            end if;
      
           when HEADER_H2 => -- inclus xxH2, D0H2 et H3H2

              -- ici le header H1 et H0 est deja sur le port de sortie, on prepare la suite, soit le H2 et possiblement le data
              if fmt_type(5 downto 1) = "00101" then -- ceci identifie uniquement tous les CPL et CPLD (pourrait etre pre-calcule et floppe)
                s_axis_tx_tdata(31 downto 8) <= transaction_id;
                s_axis_tx_tdata(7)           <= '0'; -- reserved
                s_axis_tx_tdata(6 downto 0)  <= lower_address;
              else
                -- requete master non-completion
                if fmt_type(5) = '1' then -- Header a 4 DW, ne peut etre que access 64 bits ou message et on ne supporte pas les messages.
                  s_axis_tx_tdata(31 downto 0) <= address(63 downto 32); -- on envoie la partie haute de l'adresse sur acces 64 bits
                else
                  -- acces 32 bits
                  s_axis_tx_tdata(31 downto 2)  <= address(31 downto 2); -- Assuming 32bit addressing
                  s_axis_tx_tdata(1 downto 0)   <= "00"; -- reserved
                end if;
              end if;

              -- partie haute, depend du type de transaction
              if fmt_type(5) = '1' then -- 4DW: transaction 64 bits (ou message, peut-etre dans le futur?)
                -- si c'est une adresse 64 bits, alors il faut maintenant envoyer la partie basse de l'addresse(dans le word haut du port AXI...)
      
                -- ne peut arriver que sur acces DMA pour l'instant
                s_axis_tx_tdata(63 downto 34)  <= address(31 downto 2); -- Assuming 32bit addressing, need bench confirmation
                s_axis_tx_tdata(33 downto 32)   <= "00"; -- reserved
              elsif fmt_type(6) = '1' then -- 3DW (implique par else), avec data

                -- Reordering bytes, from little endian to big endian (PCIe)
                s_axis_tx_tdata(63 downto 56) <= tlp_out_data(gnt_id)(7 downto 0);
                s_axis_tx_tdata(55 downto 48) <= tlp_out_data(gnt_id)(15 downto 8);
                s_axis_tx_tdata(47 downto 40) <= tlp_out_data(gnt_id)(23 downto 16);
                s_axis_tx_tdata(39 downto 32) <= tlp_out_data(gnt_id)(31 downto 24);
                -- synthesis translate_off
                assert tlp_out_src_rdy_n(gnt_id) = '0' report "On met des donnes invalides dans le TLP" severity FAILURE;
                -- synthesis translate_on
              else
                -- cas 3DW no data.  Sortie est Don't care
                s_axis_tx_tdata(63 downto 32) <= (others => '-');
              end if;

          when LOAD_LOW =>
            -- dans cet etat, le header 4DW est deja charge et le QW s'en va dans vers le core, on va donc maintenant charger la partie basse du data
            -- on utilise toujours le fait que lorsque le core commence a accepter un paquet, il garanti qu'il l'accepte au complet

            -- Reordering bytes, from little endian to big endian (PCIe)
            s_axis_tx_tdata(31 downto 24) <= tlp_out_data(gnt_id)(7 downto 0);
            s_axis_tx_tdata(23 downto 16) <= tlp_out_data(gnt_id)(15 downto 8);
            s_axis_tx_tdata(15 downto 8)  <= tlp_out_data(gnt_id)(23 downto 16);
            s_axis_tx_tdata(7 downto 0)   <= tlp_out_data(gnt_id)(31 downto 24);

            s_axis_tx_tdata(63 downto 32) <= (others => '-'); -- la partie haute est indeterminee pour l'instant
            -- synthesis translate_off
            assert tlp_out_src_rdy_n(gnt_id) = '0' report "On met des donnes invalides dans le TLP" severity FAILURE;
            -- synthesis translate_on
          when LOAD_HIGH =>
            -- ici les 32 bits inferieurs sont charge, on les preserve
            -- j'essaie de ne pas faire d'assignement, pour voir si l'outil de synthese va faire un clock enable tout seul

            -- la partie haute est prise du bus interne
            -- Reordering bytes, from little endian to big endian (PCIe)
            s_axis_tx_tdata(63 downto 56) <= tlp_out_data(gnt_id)(7 downto 0);
            s_axis_tx_tdata(55 downto 48) <= tlp_out_data(gnt_id)(15 downto 8);
            s_axis_tx_tdata(47 downto 40) <= tlp_out_data(gnt_id)(23 downto 16);
            s_axis_tx_tdata(39 downto 32) <= tlp_out_data(gnt_id)(31 downto 24);
            -- synthesis translate_off
            assert tlp_out_src_rdy_n(gnt_id) = '0' report "On met des donnes invalides dans le TLP" severity FAILURE;
            -- synthesis translate_on
          when LOAD_64BITS =>
            if fmt_type(5) = '1' then -- header 4 DW
              -- Header a 4 DW, le data du TLP reste aligne vers le core PCIE
              -- Reordering bytes, from little endian to big endian (PCIe)
              s_axis_tx_tdata(63 downto 56) <= tlp_out_data(gnt_id)(39 downto 32);
              s_axis_tx_tdata(55 downto 48) <= tlp_out_data(gnt_id)(47 downto 40);
              s_axis_tx_tdata(47 downto 40) <= tlp_out_data(gnt_id)(55 downto 48);
              s_axis_tx_tdata(39 downto 32) <= tlp_out_data(gnt_id)(63 downto 56);

              -- Reordering bytes, from little endian to big endian (PCIe)
              s_axis_tx_tdata(31 downto 24) <= tlp_out_data(gnt_id)(7 downto 0);
              s_axis_tx_tdata(23 downto 16) <= tlp_out_data(gnt_id)(15 downto 8);
              s_axis_tx_tdata(15 downto 8)  <= tlp_out_data(gnt_id)(23 downto 16);
              s_axis_tx_tdata(7 downto 0)   <= tlp_out_data(gnt_id)(31 downto 24);
            else
              -- Header a 3 DW, on doit retarder la partie haute de notre bus interne et la croiser a la sortie
              -- Reordering bytes, from little endian to big endian (PCIe)
              s_axis_tx_tdata(63 downto 56) <= tlp_out_data(gnt_id)(7 downto 0);
              s_axis_tx_tdata(55 downto 48) <= tlp_out_data(gnt_id)(15 downto 8);
              s_axis_tx_tdata(47 downto 40) <= tlp_out_data(gnt_id)(23 downto 16);
              s_axis_tx_tdata(39 downto 32) <= tlp_out_data(gnt_id)(31 downto 24);

              -- la partie basse a ete ramasse au clock precedent
              s_axis_tx_tdata(31 downto 24) <= tlp_out_data_p1(7 downto 0);
              s_axis_tx_tdata(23 downto 16) <= tlp_out_data_p1(15 downto 8);
              s_axis_tx_tdata(15 downto 8)  <= tlp_out_data_p1(23 downto 16);
              s_axis_tx_tdata(7 downto 0)   <= tlp_out_data_p1(31 downto 24);

            end if;
            -- synthesis translate_off
            assert tlp_out_src_rdy_n(gnt_id) = '0' report "On met des donnes invalides dans le TLP" severity FAILURE;
            -- synthesis translate_on
          when LOAD_DELAYED_LOW =>
            -- dans cet etat, il ne reste qu'un 32 bits a transferer, mais il est dans le delayed.
            -- on utilise toujours le fait que lorsque le core commence a accepter un paquet, il garanti qu'il l'accepte au complet

            -- Reordering bytes, from little endian to big endian (PCIe)
            -- la partie basse a ete ramasse au clock precedent
            s_axis_tx_tdata(31 downto 24) <= tlp_out_data_p1(7 downto 0);
            s_axis_tx_tdata(23 downto 16) <= tlp_out_data_p1(15 downto 8);
            s_axis_tx_tdata(15 downto 8)  <= tlp_out_data_p1(23 downto 16);
            s_axis_tx_tdata(7 downto 0)   <= tlp_out_data_p1(31 downto 24);

            s_axis_tx_tdata(63 downto 32) <= (others => '-'); -- la partie haute est indeterminee pour l'instant

          when others =>
            s_axis_tx_tdata <= (others => '-');

        end case;

      end if;

    end if;  
  end process;


  --------------------------------------
  -- Generation du Valid vers le core --
  --------------------------------------
  tvalidprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if sys_reset_n = '0' then
        tvalid <= '0';
      elsif tlp_tx_state = IDLE then
        -- si on est IDLE, on n'a pas de donnees sur le bus, c'est certain
        tvalid <= '0';
      elsif nxt_tlp_tx_state = LOAD_HIGH then
        tvalid <= '0'; -- si on vient de charger la partie basse et on attend la partie haute du data (a cause du demux de 32 a 64 bits), alors in insere un wait state
      else
        tvalid <= '1'; -- dans les cas qui restent, on a du data a transmettre!
      end if;
    end if;
  end process;
                                
  --  sortir le valid utilise à l'interne.
  s_axis_tx_tvalid <= tvalid;

  ------------------------
  -- GENERATION DU LAST --
  ------------------------
  lastprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if tlp_tx_state /= IDLE and nxt_tlp_tx_state = IDLE then -- forcement, c'est qu'on met le dernier data sur le bus!
        s_axis_tx_tlast <= '1';
      else
        s_axis_tx_tlast <= '0';
      end if;
      -- la doc semble impliquer que si tvalid n'est pas actif, alors tlast sera ignore.  
      -- Cependant, ca pourrait aussi vouloir dire qu'il ne faut pas driver tlast si tvalid est a 0.  Ca sera a verifier.
      -- le seul probleme potentiel serait le premier coup de clock, avant le reset...?
    end if;
  end process;

  
  ---------------------
  -- s_axis_tx_tkeep --
  ---------------------
  -- sert a indiquer quel bytes sont valides sur le bus de data.
  -- Il n'y a que 32 bits (sur 64) sur le bus que dans 2 cas, le reste du temps tout le bus est valide
  -- Ce n'est pas grave si on drive des bits actifs alors que tvalid n'est pas actif
  tkeepprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if s_axis_tx_tready = '1' then -- (tvalid = '0' or) Si le core accepte ce qui est sur le bus aussi on peut le changer. Si on est dans cet etat, il est certain qu'on drive le valid.
        -- on pourrait possiblement faire le check de tready seulement dans l'etat HEADER_H2 car c'est garanti par la spec du core que lorsqu'on est rendu plus tard dans notre machine d'etat, 
        -- le core va TOUJOURS activer le tready.  Est-ce que ca sauvera de la logique?
        if tlp_tx_state = HEADER_H2 and fmt_type(6 downto 5) = "00" then -- cas 3DW no data, 
          s_axis_tx_tkeep <= x"0F";
        elsif tlp_tx_state = LOAD_LOW and nxt_tlp_tx_state = IDLE then -- cas ou le data arrete apres avoir charge la partie low seulement
          s_axis_tx_tkeep <= x"0F";
        elsif tlp_tx_state = LOAD_DELAYED_LOW then -- cas ou le data arrete apres avoir charge la partie low seulement meme si le data qui entre est 64 bits
          s_axis_tx_tkeep <= x"0F";
        else
          s_axis_tx_tkeep <= x"FF"; -- dans tous les autres cas, toutes les bytes sont valides.
        end if;
      end if;
    end if;
  end process;

  ---------------------
  -- s_axis_tx_tuser --
  ---------------------
  -- le tuser contient divers signaux de controles accessoires
  s_axis_tx_tuser(3) <= '0'; -- AKA t_src_dsc.  On n'a pas besoin d'abandonner un TLP qu'on est en train d'envoyer
  s_axis_tx_tuser(2) <= '0'; -- AKA t_str.  On ne peut pas streamer (envoyer en cut-through) car notre bus du cote application est 32 bits, le bus data du core est 64 bits, donc on insere des wait states.
  s_axis_tx_tuser(1) <= '0'; -- AKA tx_err_fwd.  On ne veut pas envoyer des paquets empoisonné
  s_axis_tx_tuser(0) <= '0'; -- AKA tx_ecrc_gen.  On ne voit pas le besoin d'ajouter un CRC sur les paquets qu'on envoie.  Est-ce que les motherboard utilisent ca?
  
end functional;
