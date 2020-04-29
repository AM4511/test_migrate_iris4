-----------------------------------------------------------------------
-- $HeadURL: svn://brainstorm/fpga/trunk/Matrox/Imaging/FPGA/Iris2/cores/pcie_top/design/pcie_common/design/pcie_irq_axi.vhd $
-- $Author: mchampou $
-- $Revision: 6332 $
-- $Date: 2010-05-25 15:17:30 -0400 (Tue, 25 May 2010) $
--
-- DESCRIPTION: Interrupt request to PCIe core
--              We receive up to 32 different events to map on the 32 
--              MSI vectors.
--              
--              Ce code a ete bati avec l'idee d'utiliser plusieurs
--              vecteur MSI pour separer les sources d'interruption.
--              Malheureusement, les systemes et OS ne permettent pas
--              de couvrir tous les cas et l'architecture du framework
--              driver de MIL non plus. Il est donc prevu de faire 
--              l'aggregation des sources dans un module externe et de
--              ne recevoir qu'une seule source.  Si jamais nous 
--              devions avoir quelques sources ( grab + UART par
--              exemple) nous serons pret.
-----------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all; 
  use ieee.std_logic_unsigned.all;
  use ieee.std_logic_arith.all;

entity pcie_irq_axi is
  port (
    ---------------------------------------------------------------------
    -- Reset and clock signals
    ---------------------------------------------------------------------
    sys_clk                             : in    std_logic;
    sys_reset                           : in    std_logic;

    ---------------------------------------------------------------------
    -- Interrupt
    ---------------------------------------------------------------------
    int_status                          : in    std_logic_vector; -- pour les interrupt classique seulement
    msi_req                             : in    std_logic_vector; -- pour envoyer un MSI, 1 bit par vecteur
    msi_ack                             : out   std_logic_vector; -- confirmer l'envoie du MSI

    ---------------------------------------------------------------------
    -- PCIe core management interface
    ---------------------------------------------------------------------
    cfg_mgmt_do                         : in  std_logic_vector(31 downto 0);
    cfg_mgmt_rd_wr_done                 : in  std_logic;

    cfg_mgmt_di                         : out std_logic_vector(31 downto 0);
    cfg_mgmt_byte_en                    : out std_logic_vector(3 downto 0);
    cfg_mgmt_dwaddr                     : out std_logic_vector(9 downto 0);
    cfg_mgmt_wr_en                      : buffer std_logic;
    cfg_mgmt_rd_en                      : buffer std_logic;
    cfg_mgmt_wr_readonly                : buffer std_logic := '0';  -- on en a pas besoin, pour l'instant?

    ---------------------------------------------------------------------
    -- PCIe core user interrupt interface
    ---------------------------------------------------------------------
    cfg_interrupt_rdy                    : in std_logic;
    cfg_interrupt_msienable              : in	std_logic;
    cfg_interrupt_mmenable               : in std_logic_vector(2 downto 0);
    cfg_interrupt_msixenable             : in std_logic;

    cfg_interrupt                        : out   std_logic;
    cfg_interrupt_di                     : out   std_logic_vector(7 downto 0);
    cfg_interrupt_assert                 : out   std_logic
  );
end pcie_irq_axi;    

architecture functional of pcie_irq_axi is

  -----------------------------------------------------
  -- signals
  -----------------------------------------------------
  signal aliased_msi_req                    : std_logic_vector(int_status'high downto 0);
  signal aliased_msi_req_p1                      : std_logic_vector(aliased_msi_req'range);  -- pour detecter le rising edge
  signal need_msi                           : std_logic_vector(aliased_msi_req'range);

  signal msi_vector_to_signal               : integer range aliased_msi_req'range;
  signal msi_vector_to_clear                : std_logic_vector(aliased_msi_req'range);
  signal cfg_interrupt_buf                  : std_logic;
  signal cfg_interrupt_assert_buf           : std_logic;
  
  -- pour l'emulation legacy de INTAN
  signal local_inta_n                       : std_logic;
  signal host_inta_n                        : std_logic;
  signal send_intx_msg                      : std_logic;

  constant NO_ACTIVE_INTERRUPTS             : std_logic_vector(int_status'range) := (others => '0');
  
  -- shadow des bits dans le configuration space
  signal per_vector_mask                    : std_logic_vector(31 downto 0);
  signal per_vector_mask_p1                 : std_logic_vector(per_vector_mask'range);
  signal pending_bits                       : std_logic_vector(31 downto 0) := (others => '0');

begin

  -- Aliasing
  -- En MSI, il est possible qu'on ait moins de vecteur que demande. Dans ce cas, il faut aliaser les vecteurs en fonction de ce qui nous est offert.
  -- une bonne strategie est d'utiliser seulement un vecteur lorsqu'on n'a pas tous ceux qu'on demande.  On pourrait faire ca et le dire au gars de driver.
  --   aliasprc: process(cfg_interrupt_mmenable, int_status)
  --     variable accumulation : std_logic_vector(aliased_msi_req'high downto 0);
  --     variable nb_vec : integer range 1 to 32;
  --     variable mmenable_nb : integer range 0 to 7;
  --   begin
  --     accumulation := (others => '0'); -- par default, tout le monde est a off, y compris ceux qui sont masques par l'alias
  --     mmenable_nb := conv_integer(cfg_interrupt_mmenable);
  --     -- traiter le cas ou on demande un nombre illegal de vecteur, on considere que c'est un vecteur.
  --     if mmenable_nb > 5 then  
  --       mmenable_nb := 0;
  --     end if;
  --     
  --     nb_vec := 2 ** mmenable_nb;
  --     
  --     -- on fait l'aliasing en mappant chaque vecteur sur le modulo du nombre de vecteur alloue.
  --     for i in int_status'low to int_status'high loop
  --       accumulation(i mod nb_vec) := accumulation(i mod nb_vec) or int_status(i);
  --     end loop;
  --     
  --     aliased_msi_req <= accumulation;
  --   end process;
  -- le code plus haut fait, en theorie, de l'aliasing general. Cependant, ca genere tellement de niveau de logique que c'est deraisonable de passer ca en timing.
  -- Alors on va deplacer le probleme au gens de soft.
  -- Si l'OS refuse de nous allouer tous nos vecteurs, alors c'est au driver de retourner en INTA_n.
  aliased_msi_req <= msi_req;  
	
  -- a chaque rising edge du status d'un evenement, on envoie le MSI, en situation normal
  edgedtcprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if sys_reset = '1' then
        aliased_msi_req_p1 <= (others => '0');
      else
        aliased_msi_req_p1 <= aliased_msi_req;
      end if;

      for i in need_msi'range loop      
        if sys_reset = '1' then
          need_msi(i) <= '0';
        elsif aliased_msi_req(i) = '1' and aliased_msi_req_p1(i) = '0' and per_vector_mask(i) = '0' then
          -- on a un rising edge et il n'est pas masque, donc un nouvel interrupt, on doit envoyer un MSI.
          need_msi(i) <= '1';
        elsif per_vector_mask(i) = '0' and per_vector_mask_p1(i) = '1' and aliased_msi_req(i) = '1' then
        	-- on vient de clearer le mask, on envoie un MSI si la source d'interrupt est active (donc que le bit pending l'etait aussi).
          need_msi(i) <= '1';
        elsif aliased_msi_req(i) = '0' and aliased_msi_req_p1(i) = '1' then
          -- on a un falling edge du status, le soft a cleare l'interrupt, on annule l'envoie de MSI
          -- si la commande d'envoyer le MSI est deja envoye au core 
          need_msi(i) <= '0';
        --elsif cfg_interrupt_rdy = '1' and msi_vector_to_signal = i then pas bon
        elsif cfg_interrupt_rdy = '1' and msi_vector_to_clear(i) = '1' then
          -- le core acknowledge avoir envoye notre interrupt.
          need_msi(i) <= '0';
        end if;
        
        -- il faut que le nombre de demande de MSI soit equivalent au nombre de acknowledge de MSI
        assert msi_req'length = msi_ack'length report "IL FAUT QUE LE NOMBRE DE DEMANDE DE MSI SOIT EQUIVALENT AU NOMBRE DE ACKNOWLEDGE DE MSI" severity FAILURE;
        
        if sys_reset = '1' then
          msi_ack(i) <= '0';
        elsif cfg_interrupt_rdy = '1' and msi_vector_to_clear(i) = '1' and cfg_interrupt_msienable = '1' then
          msi_ack(i) <= '1';
        else
          msi_ack(i) <= '0';
        end if;        
        
      end loop;
      
    end if;
  end process;
	
  -- encoder la priorite des evenement pour savoir quel MSI envoye.
  -- theoriquement, les evenements sont tres espaces, donc il devrait toujours n'y en avoir qu'un à la fois
  -- si jamais le host ne répond pas, ou si un vecteur est maské, alors il faut déterminer quel interrupt on envoie avec un encodeur de priorité

  process (need_msi)
    variable msi_found : std_logic;
  begin

    msi_found        := '0'; -- This variable is used to acknowledge only one requester 

    msi_vector_to_signal <= need_msi'low; -- on met 0 pour ne pas que la meme valeur traine dans ce module, demandant que l'ancienne valeur soit dans la boucle de feedback

    -- simple priority encoder qui donne la priorite aux agent au numero le plus faible
    for i in need_msi'low to need_msi'high loop
      if need_msi(i) = '1' and msi_found = '0' then
        msi_found          := '1';
        msi_vector_to_signal       <= i;
      end if;
    end loop;  -- i

  end process;
  
  ---------------------------------------------------------------------
  -- pour emuler les anciennes interruption. D'abord, on genere une 
  -- version locale du inta_n
  ---------------------------------------------------------------------
  process(sys_clk)
  begin
    if (sys_clk'event and sys_clk = '1') then
      --if (sys_reset = '1')  then
      --  local_inta_n <= '1';
      --els
      if int_status = NO_ACTIVE_INTERRUPTS then
        local_inta_n <= '1';
      else
        local_inta_n <= '0';
      end if;      
    end if;
  end process;  

  -- we need to send a message when they are different and we are not ALREADY signalling
  send_intx_msg <= (local_inta_n xor host_inta_n) and not cfg_interrupt_buf;

  hstintpcr: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if sys_reset = '1' then
        host_inta_n <= '1';
      elsif cfg_interrupt_msienable = '0' and cfg_interrupt_rdy = '1' then  -- en mode classique, quand le core nous confirme qu'il a envoye le paquet
        host_inta_n <= not cfg_interrupt_assert_buf;                        -- son etat devient ce qu'on a latcher et envoye
      end if;
    end if;
  end process;
  
  ---------------------------------------------------------------------
  -- Legacy mode:

  -- If PCIe core sees Interrupt Disable bit of PCI command register set
  -- to 1, it will not send an interrupt message.
  --
  -- MSI mode:

  -- Only check set condition as cfg_interrupt_assert always 0.
  ---------------------------------------------------------------------
  process(sys_clk)
  begin
    if (sys_clk'event and sys_clk = '1') then
  
      if (sys_reset = '1')  then
  
        cfg_interrupt_buf    <= '0';
        cfg_interrupt_assert_buf <= '0';
       
      elsif (cfg_interrupt_msienable = '0' and cfg_interrupt_msixenable = '0') then

        -- interrupt classique
        cfg_interrupt_di <= (others => '0'); -- on a juste le droit d'utiliser INTA
        
        -- on latch l'etat a envoyer sur le coup de clock ou on decide de l'envoyer
        if send_intx_msg = '1' then
          cfg_interrupt_assert_buf <= not local_inta_n;
          cfg_interrupt_buf <= '1'; -- signaller l'interruption
        end if;
        
        -- quand on recoit un acknowledge que la commande est envoye, on arrete notre requete. C'est dominant.
        if cfg_interrupt_rdy = '1' then
          cfg_interrupt_buf <= '0';
        end if;

      elsif cfg_interrupt_msienable = '1' then
      
        -- on va envoyer un MSI.
        cfg_interrupt_assert_buf <= '0';
      
        -- on enregistre le numero du vecteur pendant qu'on a pas deja demande l'envoie au core, on le garde fixe pendant notre requete
        if cfg_interrupt_buf = '0' then
          cfg_interrupt_di <= conv_std_logic_vector(msi_vector_to_signal,8);

          msi_vector_to_clear <= (others => '0');           -- on enregistre lequel des bits on est en train de signaler.
          msi_vector_to_clear(msi_vector_to_signal) <= '1';
        end if;
        
        if (cfg_interrupt_rdy = '1') then -- doit etre dominant pour qu'on relache la pression quand le core acknowledge l'expedition du MSI
          cfg_interrupt_buf    <= '0';
        elsif conv_integer(need_msi) /= 0 then
      	  cfg_interrupt_buf    <= '1';
        end if;

      end if;
    end if;	
  end process;

  -- Assigning output port
  cfg_interrupt <= cfg_interrupt_buf;
  cfg_interrupt_assert <= cfg_interrupt_assert_buf;	

  -- MSI Mask et Pending
  -- le core n'implante pas la fonction de Per Vector Mask et Per Vector Pending Bits.  Ce qui est impliqué par la documentation, c'est qu'on doit utiliser
  -- l'interface de management pour lire le mask, qu'on doit l'appliquer, et qu'on doit mettre à jour le status dans les pending bits.
  -- Étant donné que l'interface management ne servait pas de toute façon, on va s'en servir pour continuellement transférer ces deux registre entre notre logique et le config space.

  mgntprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if sys_reset = '1' then
        cfg_mgmt_wr_en <= '0';
        cfg_mgmt_rd_en <= '0'; -- on va laisser le systeme tranquille en partant
        cfg_mgmt_wr_readonly <= '0';
      elsif cfg_mgmt_rd_en = '0' and cfg_mgmt_wr_en = '0' then  -- si on faisait rien, on part le cycle d'ecriture de registre de controle
      	cfg_mgmt_rd_en <= '1';  -- en read en partant
        cfg_mgmt_wr_en <= '0';
        cfg_mgmt_dwaddr <= conv_std_logic_vector(16#58#/4,cfg_mgmt_dwaddr'length); -- addresse 58, c'est le PerVectorMask
        --test-pour-xilinx cfg_mgmt_dwaddr <= conv_std_logic_vector(16#48#/4,cfg_mgmt_dwaddr'length); -- addresse 48, c'est le Control
      	--test-pour-xilinx cfg_mgmt_rd_en <= '0';  
        --test-pour-xilinx cfg_mgmt_wr_en <= '1';	-- en write en partant, pour activer le PVM capable
        --test-pour-xilinx cfg_mgmt_wr_readonly <= '1';
        --test-pour-xilinx cfg_mgmt_di <= x"01886005";
      elsif cfg_mgmt_rd_wr_done = '1' then
	      cfg_mgmt_wr_readonly <= '0';
      	if cfg_mgmt_rd_en = '1' then
        	-- on vient de finir un read, on va faire un write
	      	cfg_mgmt_rd_en <= '0'; 
	        cfg_mgmt_wr_en <= '1';
  	      cfg_mgmt_wr_readonly <= '1'; -- les bits de pending sont read-only sur le PCIe
	        cfg_mgmt_dwaddr <= conv_std_logic_vector(16#5C#/4,cfg_mgmt_dwaddr'length); -- addresse 0x5c, c'est le Pending
					-- on va charger le data pour qu'il soit stable pendant toute la transaction
          cfg_mgmt_di <= pending_bits;
        else
        	--test-pour-xilinx if cfg_mgmt_wr_readonly = '1' then -- on vient d'ecrire le MSI CONTROL, on relit pour le fun! 
		    --test-pour-xilinx     cfg_mgmt_dwaddr <= conv_std_logic_vector(16#48#/4,cfg_mgmt_dwaddr'length); -- addresse 58, c'est le PerVectorMask
			--test-pour-xilinx 		else
          	-- lecture normale: le Per-Vector Mask
		        cfg_mgmt_dwaddr <= conv_std_logic_vector(16#58#/4,cfg_mgmt_dwaddr'length); -- addresse 58, c'est le PerVectorMask
			--test-pour-xilinx 		end if;            
        	-- on recommence le read
	      	cfg_mgmt_rd_en <= '1'; 
	        cfg_mgmt_wr_en <= '0';
        end if;
      end if;
    end if;
  end process;
  
  cfg_mgmt_byte_en <= (others => '1'); -- on write toujours tous les bytes

	-- on recolte le resultat du read a la fin de la transaction
  pvmsaveprc: process(sys_clk)
  begin
  	if rising_edge(sys_clk) then
    	if cfg_mgmt_rd_en = '1' and cfg_mgmt_rd_wr_done = '1' then
      	per_vector_mask <= cfg_mgmt_do;
      end if;
      per_vector_mask_p1 <= per_vector_mask;
    end if;
  end process;  

	-- En MSI, un interrupt pending est un interrupt qui est actif mais masque dans le config space.
	pending_bits(aliased_msi_req'range) <= aliased_msi_req and per_vector_mask(aliased_msi_req'range);
  
end functional;
    