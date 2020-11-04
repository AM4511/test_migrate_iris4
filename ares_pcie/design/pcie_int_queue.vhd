-----------------------------------------------------------------------
-- $HeadURL: svn://brainstorm/fpga/trunk/Matrox/Imaging/FPGA/Iris2/cores/pcie_top/design/pcie_common/design/pcie_int_queue.vhd $
-- $Author: jlarn $
-- $Revision: 6332 $
-- $Date: 2010-05-25 15:17:30 -0400 (Tue, 25 May 2010) $
--
-- DESCRIPTION: Interrupt queue
--              Le but de ce module est de concentrer les sources 
--              d'interruption en direction d'une queue ecrite dans la 
--              memoire host. Quand il y a une interruption et que 
--              la mise-a-jour de la queue est faite, on renvoie 
--              l'interruption au host.
--
--              Dans le cas ou la queue est desactivee (dynamiquement
--              ou statiquement), on doit simplement faire passer les
--              interruptions de la source dans le FPGA au core PCIe.
--
--              NOTE: Il est impensable de passer du mode MSI au mode
--              legacy pendant qu'une interruption est en cours. Nous
--              ne testerons pas cette condition.
-----------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all; 
  use ieee.std_logic_unsigned.all;
  use ieee.numeric_std.all;
library work;
  --use work.int_queue_pak.all;
  use work.regfile_ares_pack.all;

entity pcie_int_queue is
  port (
    ---------------------------------------------------------------------
    -- Reset and clock signals
    ---------------------------------------------------------------------
    sys_clk                             : in    std_logic;
    sys_reset                           : in    std_logic;

    ---------------------------------------------------------------------
    -- Interrupt IN
    ---------------------------------------------------------------------
    int_status                          : in    std_logic_vector; -- pour les interrupt classique seulement
    int_event                           : in    std_logic_vector; -- pour envoyer un MSI, 1 bit par vecteur

    ---------------------------------------------------------------------
    -- single interrupt OUT
    ---------------------------------------------------------------------
    queue_int_out                       : out   std_logic; 
    msi_req                             : out   std_logic;
    msi_ack                             : in    std_logic;

    regfile                             : in    INTERRUPT_QUEUE_TYPE;      -- definit dans int_queue_pak
    
    ---------------------------------------------------------------------
    -- transmit interface
    ---------------------------------------------------------------------
    tlp_out_req_to_send                 : out std_logic;
    tlp_out_grant                       : in  std_logic;

    tlp_out_fmt_type                    : out std_logic_vector(6 downto 0); -- fmt and type field 
    tlp_out_length_in_dw                : out std_logic_vector(9 downto 0);
    tlp_out_attr                        : out std_logic_vector(1 downto 0); -- relaxed ordering, no snoop

    tlp_out_src_rdy_n                   : out std_logic;
    tlp_out_dst_rdy_n                   : in  std_logic;
    tlp_out_data                        : out std_logic_vector(63 downto 0);

    -- for master request transmit
    tlp_out_address                     : out std_logic_vector(63 downto 2); 
    tlp_out_ldwbe_fdwbe                 : out std_logic_vector(7 downto 0);

    -- for completion transmit
    tlp_out_transaction_id              : out std_logic_vector(23 downto 0); -- bus, device, function, tag
    tlp_out_byte_count                  : out std_logic_vector(12 downto 0); -- byte count tenant compte des byte enables
    tlp_out_lower_address               : out std_logic_vector(6 downto 0);

    ---------------------------------------------------------------------
    -- PCIe core user interrupt interface
    ---------------------------------------------------------------------
    cfg_interrupt_msienable              : in	std_logic;
    cfg_interrupt_msixenable             : in std_logic

  );
end pcie_int_queue;    

architecture functional of pcie_int_queue is

  -----------------------------------------------------
  -- signals
  -----------------------------------------------------
  signal need_msi                           : std_logic_vector(int_status'range) := (others => '0');
  signal int_status_p1                      : std_logic_vector(int_status'range) := (others => '0');
  constant NO_ACTIVE_INTERRUPTS             : std_logic_vector(int_status'range) := (others => '0');
  
  signal int_event_p1                         : std_logic_vector(int_event'range);
  signal event_to_signal                      : std_logic_vector(int_event'range);
  signal event_for_this_write                 : std_logic_vector(int_event'range);
  constant NO_ACTIVE_EVENTS                   : std_logic_vector(int_event'range) := (others => '0');
  signal producer_pointer                     : unsigned(9 downto 0); -- 4k divise en 4 bytes donne 1024 emplacements
  signal consumer_index_p1                    : std_logic_vector(INIT_INTERRUPT_QUEUE_CONS_IDX_TYPE.CONS_IDX'range);
  signal consumer_index_update                : std_logic;
  signal queue_is_empty                       : std_logic;

  -- state machine pour driver l'ecriture dans la ram
	type TYPE_WRITE_STATE is (IDLE, REQ_WRITE_EVENT, WAIT_EVENT_WRITE);
  signal next_write_state     : TYPE_WRITE_STATE;
	signal current_write_state  : TYPE_WRITE_STATE;

	type TYPE_MSI_STATE is (IDLE_MSI, REQ_MSI, MSI_SENT);
	signal next_msi_state     : TYPE_MSI_STATE;
	signal current_msi_state  : TYPE_MSI_STATE;

  --attribute mark_debug : string;
  --attribute mark_debug of event_to_signal   : signal is "true";
  --attribute mark_debug of event_for_this_write   : signal is "true";
  --attribute mark_debug of current_write_state   : signal is "true";
  --attribute mark_debug of tlp_out_req_to_send   : signal is "true";
  --attribute mark_debug of tlp_out_grant   : signal is "true";
  --attribute mark_debug of tlp_out_dst_rdy_n   : signal is "true";
  --attribute mark_debug of producer_pointer   : signal is "true";


begin

  -- Il y a 4 cas, queue active ou inactive, utilisant les interruptions legacy ou MSI.
  
  -------------------------------------------
  -- CAS 1 (prefere) QUEUE ACTIVE AVEC MSI --
  -------------------------------------------
  edgedtcprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if sys_reset = '1' or regfile.CONTROL.ENABLE = '0' then
        int_event_p1 <= (others => '0');
      else
        int_event_p1 <= int_event;
      end if;
                                     
      -- on enregistre les evenements qui se produisent pour pouvoir les ecrire dans la queue
      for i in event_to_signal'range loop      
        if sys_reset = '1' or regfile.CONTROL.ENABLE = '0' then
          event_to_signal(i) <= '0';
        elsif int_event(i) = '1' and int_event_p1(i) = '0'  then
        	-- rising edge d'un evenement, on l'enregistre.
          event_to_signal(i) <= '1';
        --elsif current_write_state = REQ_WRITE_PROD_INDEX and event_for_this_write(i) = '1' then
        elsif current_write_state = WAIT_EVENT_WRITE and event_for_this_write(i) = '1' then
          -- l'ecriture dans le host est confirmee
          event_to_signal(i) <= '0';
        end if;
      end loop;
      
      -- on enregistre les evenements qu'on va signaler quand on lance le state machine
      if current_write_state = IDLE then
        event_for_this_write <= event_to_signal;
      end if;
      
    end if;
  end process;

  -- pointeurs en memoire host
  prodptrprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if sys_reset = '1' or regfile.CONTROL.ENABLE = '0' then  -- on garde en reset tant qu'on est desactive.
        producer_pointer <= (others => '0');
      elsif current_write_state = REQ_WRITE_EVENT and next_write_state = WAIT_EVENT_WRITE then -- des que le req est accepte, nous pouvons incrementer l'adresse
        if int_event'length <= 32 then
          producer_pointer <= producer_pointer + 1; -- on ecrit un seul vecteur de 32 bits
        elsif int_event'length <= 64 then
          producer_pointer <= producer_pointer + 2; -- on ecrit 64 bit a chaque fois
        else
          assert int_event'length <= 64 report "LE CODE DE INT QUEUE NE SUPPORTE PAS ENCORE PLUS DE 64 EVENTS, SVP RENVOYER LE PROBLEME A JF" severity FAILURE;          
        end if;        
      end if;
    end if;
    
  end process;

  -- WRITE STATE MACHINE
  -- ce state machine commande les ecritures dans la memoire host.
  wrtfsm_comb: process(current_write_state, event_to_signal, regfile.CONS_IDX.CONS_IDX, tlp_out_grant, tlp_out_dst_rdy_n, producer_pointer, regfile.CONTROL.ENABLE )
  begin
    case current_write_state is

      -- on attend qu'il y aille quelque chose a ecrire.
      when IDLE => 
        if event_to_signal /= NO_ACTIVE_EVENTS and regfile.CONS_IDX.CONS_IDX /= to_integer(producer_pointer) and regfile.CONTROL.ENABLE = '1' then
          next_write_state <= REQ_WRITE_EVENT;
        else
          next_write_state <= IDLE;
        end if;

      -- on demande a ecrire un evenement, il faut attendre que le core nous l'accorde
      when REQ_WRITE_EVENT => 
        if tlp_out_grant = '1' then
          next_write_state <= WAIT_EVENT_WRITE;          
        else
          next_write_state <= REQ_WRITE_EVENT;
        end if;
        
      -- maintenant on attend que le data soit accepte
      when WAIT_EVENT_WRITE => 
        if tlp_out_dst_rdy_n = '0' then
          --next_write_state <= REQ_WRITE_MSI;
          next_write_state <= IDLE;
        else
          next_write_state <= WAIT_EVENT_WRITE;
        end if;

      when others =>
        next_write_state <= IDLE;
    end case;
  end process;
  
  wrtfsm_clockd: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if sys_reset = '1' then
        current_write_state <= IDLE;
      else
        current_write_state <= next_write_state;
      end if;
    end if;
  end process;

  -- MSI STATE MACHINE
  -- ce state machine commande l'envoie de MSI en mode queue
  -- fondamentalement, on envoie un MSI quand on ecrit un premier evenement dans la queue. Ensuite on se tait jusqu'a ce que le driver nous acknowledge le MSI
  -- en ecrivant le consumer index. Si d'autres evenements sont rentres et que le acknowledge indique qu'ils ne sont pas traite, on envoie un autre MSI.  
  -- Sinon, on se remet en attente et on ne va envoyer de MSI que lors du prochain evenement.
  msifsm_comb: process(current_msi_state, current_write_state, next_write_state, msi_ack, queue_is_empty, consumer_index_update, cfg_interrupt_msienable, cfg_interrupt_msixenable)
  begin

    -- condition globale, si les MSI ne sont pas active dans l'espace config, on doit reste desactive dans tous les etats.
    if (cfg_interrupt_msienable = '0' and cfg_interrupt_msixenable = '0') then
      next_msi_state <= IDLE_MSI;
    else
          
      case current_msi_state is

        -- on attend qu'il y aille un MSI a envoyer
        when IDLE_MSI => 
          if current_write_state = WAIT_EVENT_WRITE and next_write_state = IDLE then -- sur la fin du cycle d'ecriture on lance un MSI 
            next_msi_state <= REQ_MSI;
          else
            next_msi_state <= IDLE_MSI;
          end if;

        -- on demande d'envoyer un MSI
        when REQ_MSI => 
          if msi_ack = '1' then
            next_msi_state <= MSI_SENT;          
          elsif queue_is_empty = '1' then -- si le host a vider la queue, il n'a plus besoin de savoir qu'il doit vider la queue
            next_msi_state <= IDLE_MSI;
          else
            next_msi_state <= REQ_MSI;
          end if;
        
        -- MSI est envoye.  
        when MSI_SENT => 
          -- pour ne pas faire de deadlock, il faut toujours qu'on rearme si la queue est vide.  Si la queue est vide, c'est certain que le soft ne fera JAMAIS d'update
          if queue_is_empty = '1' then
            -- le driver acknowledge tout, on se remet en attente de nouvel element dans la queue
            next_msi_state <= IDLE_MSI;
          elsif consumer_index_update = '1' then -- and queue is not empty
            -- le driver a fait un acknowledge
            -- malgre l'acknowledge, la queue contient encore des evenements non-traite. On retriggue le MSI
            next_msi_state <= REQ_MSI;
          else
            next_msi_state <= MSI_SENT;
          end if;

        when others =>
          next_msi_state <= IDLE_MSI;
      end case;
      
    end if;
    
  end process;
  
  msifsm_clockd: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if sys_reset = '1'  then
        current_msi_state <= IDLE_MSI;
      else
        current_msi_state <= next_msi_state;
      end if;
    end if;
  end process;

  -- interface pour faire les writes
  tlp_out_req_to_send                 <= '1' when current_write_state = REQ_WRITE_EVENT else '0';-- or current_write_state = REQ_WRITE_PROD_INDEX 

  -- type de TLP qu'on envoie
  tlptypeprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then -- flopper pour aider le timing
      if conv_integer(regfile.ADDR_HIGH.ADDR) = 0 then -- si l'adresse est en bas de 4Gig
      -- pas compatible vivado 2015.2:if to_std_logic_vector(regfile.ADDR_HIGH) = x"00000000" then -- si l'adresse est en bas de 4Gig
        tlp_out_fmt_type <= "1000000"; -- 3DW + data, adressage 32 bits
      else
        -- si l'adresse est en haut de 4Gig
        tlp_out_fmt_type <= "1100000"; -- 4DW + data, adresse 64 bits
      end if;
    end if;
  end process;
  
  -- version 32 bits seulement
  --tlp_out_length_in_dw                <= (0 => '1', others => '0'); -- 1 DW, verifie par le assert plus haut
  tlplenprc: process(int_event) -- c'est statique a la compilation alors il ne devrait pas y avoir besoin de signal en sensibilite, mais bon c'est prudent d'en mettre un
  begin
    if int_event'length <= 32 then
      tlp_out_length_in_dw                <= (0 => '1', others => '0'); -- 1 DW
    elsif int_event'length <= 64 then
      tlp_out_length_in_dw                <= (1 => '1', others => '0'); -- 2 DW
    else
      assert int_event'length <= 64 report "LE CODE DE INT QUEUE NE SUPPORTE PAS ENCORE PLUS DE 64 EVENTS, SVP RENVOYER LE PROBLEME A JF" severity FAILURE;          
    end if;        
  end process;


  tlp_out_attr                        <= (others => '0');  -- pour ces message d'interrupt, on veux que les ecritures soient VRAIMENT vu dans l'ordre par le systeme.

  write_data_prc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if tlp_out_dst_rdy_n = '0' then
        -- le core vient d'accepter un data. Etant donne qu'on ne fait que des write 32 bits, alors il faut toujours desactiver notre signal de handshake
        tlp_out_src_rdy_n <= '1';
      elsif current_write_state = IDLE then -- pour qu'au reset le signal demeure valide
        tlp_out_src_rdy_n <= '1';
      elsif current_write_state /= IDLE then -- je crois que pour tous les evenement, on doit se declarer pret. Le core ne devrait pas aimer qu'on fasse un REQ sans avoir de data pret.
        tlp_out_src_rdy_n <= '0';
      end if;
    end if;
  end process;
  
  data_latch_prc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if current_write_state = IDLE then -- on peut ramasser le vecteur (jusqu'a 64 bits) a la sortie du IDLE. C'est plus simple et depense moins de puissance, en theorie
        tlp_out_data(int_event'length -1 downto 0) <= event_to_signal;  -- c'est la meme condition que ce qui sauvegarde event_for_this_write et ca doit le demeurer
        tlp_out_data(tlp_out_data'high downto int_event'length) <= (others => '0'); 
      end if;
    end if;
  end process;  

  -- for master request transmit
  addrprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
        -- quand on ecrit le data on ecrit tel que pointe par l'index      
        -- vivado 2015.2 n'aime pas ces alias! tlp_out_address <= to_std_logic_vector(regfile.ADDR_HIGH) & regfile.ADDR_LOW.ADDR(31 downto 12) & std_logic_vector(producer_pointer);

        -- si le vecteur change de longueur (comme sur N3IO par exemple) cette solution n'est pas bonne non-plus, mais nous allons l'utiliser pour faire une relache legacy critique ARES
        --tlp_out_address <= regfile.ADDR_HIGH.ADDR & regfile.ADDR_LOW.ADDR(31 downto 12) & std_logic_vector(producer_pointer);
		    
        -- la solution plus propre serait:
        tlp_out_address <= (others => '0'); -- mettre a 0 les bits non defini par les registre
        tlp_out_address(31 downto 2) <= regfile.ADDR_LOW.ADDR(31 downto 12) & std_logic_vector(producer_pointer);
        tlp_out_address(regfile.ADDR_HIGH.ADDR'high+32 downto 32) <= regfile.ADDR_HIGH.ADDR; -- fonctionne tant que le field .ADDR est x downto 0, ce qui doit toujours etre le cas
    end if;
  end process;
   
  tlp_out_ldwbe_fdwbe <= x"0F" when int_event'length <= 32 else x"FF";

  -- for completion transmit
  tlp_out_transaction_id              <= (others => '0');
  tlp_out_byte_count                  <= (others => '0');
  tlp_out_lower_address               <= (others => '0');

  -- determination si la queue est vide?
  emptyqprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if current_write_state = REQ_WRITE_EVENT or current_write_state = WAIT_EVENT_WRITE then  -- si nous sommes en train d'envoyer un événement, c'est certain que la queue ne sera pas vide.
        queue_is_empty <= '0';  -- nous devons forcer la queue pas vide pour ne pas perdre le MSI
      elsif unsigned(regfile.CONS_IDX.CONS_IDX) + 1 = producer_pointer then
        queue_is_empty <= '1';
      else
        queue_is_empty <= '0';
      end if;
      
      -- Est-ce qu'on a un acknowledge du driver?
      consumer_index_p1 <= regfile.CONS_IDX.CONS_IDX;
      if consumer_index_p1 /= regfile.CONS_IDX.CONS_IDX then
        consumer_index_update <= '1';
      else
        consumer_index_update <= '0';
      end if;
      
    end if;
  end process;

  ------------------------------
  -- MSI CLASSIQUE SANS QUEUE --
  ------------------------------
  -- Nous detectons que nous devons signaler une interruption lorsqu'il y a un rising edge du int status.
  -- Quand on fait des MSIs classiques sans la queue, le software signale au hardware qu'il a recu le message en acknowledgeant le int_status.
  msiredgeprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if sys_reset = '1' then
        int_status_p1 <= (others => '0');
      else
        int_status_p1 <= int_status;
      end if;

      for i in need_msi'range loop      
        if sys_reset = '1' then
          need_msi(i) <= '0';
        elsif msi_ack = '1' then
          -- le core acknowledge avoir envoye notre interrupt.
          need_msi(i) <= '0';
        elsif int_status(i) = '0' and int_status_p1(i) = '1' then
          -- on a un falling edge du status, le soft a cleare l'interrupt, on annule l'envoie de MSI
          need_msi(i) <= '0';
        elsif int_status(i) = '1' and int_status_p1(i) = '0' then
          -- on a un rising edge, donc un nouvel interrupt, on doit envoyer un MSI.
          need_msi(i) <= '1';
        end if;
      end loop;
      
    end if;
  end process;

  -----------------------------------------
  -- GENERATION DES INTERRUPTS EN SORTIE --
  -----------------------------------------
  -- interruption legacy
  legacyintstatus: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if (cfg_interrupt_msienable = '0' and cfg_interrupt_msixenable = '0') then -- il n'y a pas de MSI
        -- est-ce que la queue est active?
        if regfile.CONTROL.ENABLE = '1' then
          queue_int_out <= not queue_is_empty;  -- on tien l'interrupt actif tant que le soft n'aura pas vide la queue
        else
          -- Sans queue, on fait un OR de toutes les sources d'interruption
          if int_status = NO_ACTIVE_INTERRUPTS then
            queue_int_out <= '0';
          else
            queue_int_out <= '1';
          end if;      
        end if;
      else
        queue_int_out <= '0'; -- si on communique par MSI, alors on ne drive pas d'interrupt legacy
      end if;
    end if;
  end process;

  -- lancer les MSI (mais en mode queue seulement...?)
  msigenprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if regfile.CONTROL.ENABLE = '0' then
        -- sans la queue, nous allons demander des MSI que si le systeme est configure en MSI:
        if cfg_interrupt_msienable = '1' then
          -- Mode sans queue mais MSI actif
          -- Dans ce mode on envoie un MSI des qu'une des sources devient actif.  Quand un MSI est envoye, cela reset toutes les sources, jusqu'au prochain rising edge de la source.
          if need_msi = NO_ACTIVE_INTERRUPTS then
            msi_req <= '0'; -- il n'y a pas de source de MSI active, donc on ne demande rien au core pci
          else
            msi_req <= '1'; -- il y a au moins une source active, on demande au core d'envoyer un MSI au host.
          end if;
        else
          msi_req <= '0'; -- le MSI ne sont pas actif, donc on n'en drive pas.
        end if;
      elsif next_msi_state = REQ_MSI then -- si la machine d'etat demande un MSI on va envoyer la requete
        msi_req <= '1';        
      --elsif msi_ack = '1' then -- si le core confirme qu'il vient d'envoyer un MSI
      --  msi_req <= '0';        -- nous n'en n'aurons plus besoin, d'ici la prochaine ecriture dans la queue. Le MSI vient de sortir, alors le CPU va le recevoir.
      else
        msi_req <= '0'; -- si la machine d'etat ne demande pas de MSI, on n'en demande pas.
      end if;
    end if;
  end process;  
  
end functional;
    
