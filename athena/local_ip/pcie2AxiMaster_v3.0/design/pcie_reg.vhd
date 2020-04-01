-----------------------------------------------------------------------
-- $HeadURL: svn://brainstorm/fpga/trunk/Matrox/Imaging/FPGA/Iris2/cores/pcie_top/design/pcie_common/design/pcie_reg.vhd $
-- $Author: jlarin $
-- $Revision: 9647 $
-- $Date: 2012-08-01 15:43:50 -0400 (Wed, 01 Aug 2012) $
--
-- DESCRIPTION: Ce module fait le pont entre les requetes pcie qui 
--              arrivent, le bus reg_bus compatible aux register files
--              genere par le FDK ou les requetes sont executee
--              et le module ou les completions sont envoyees.
--              
-----------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all; 
  use ieee.std_logic_unsigned.all;
  use ieee.std_logic_arith.all;
library work;
  use work.pciepack.all;

entity pcie_reg is
  port (
    ---------------------------------------------------------------------
    -- Reset and clock signals
    ---------------------------------------------------------------------
    sys_clk                             : in    std_logic;
    sys_reset_n                         : in    std_logic;

    ---------------------------------------------------------------------
    -- New receive request interface
    ---------------------------------------------------------------------
    
    tlp_in_accept_data                  : out std_logic;

    tlp_in_fmt_type                     : in  std_logic_vector(6 downto 0); -- fmt and type field from decoded packet 
    tlp_in_address                      : in  std_logic_vector(31 downto 0); -- 2 LSB a decoded from byte enables
    tlp_in_length_in_dw                 : in  std_logic_vector(10 downto 0);
    tlp_in_attr                         : in  std_logic_vector(1 downto 0); -- relaxed ordering, no snoop
    tlp_in_transaction_id               : in  std_logic_vector(23 downto 0); -- bus, device, function, tag
    tlp_in_valid                        : in  std_logic;
    tlp_in_data                         : in  std_logic_vector(31 downto 0);
    tlp_in_byte_en                      : in  std_logic_vector(3 downto 0);
    tlp_in_byte_count                   : in  std_logic_vector(12 downto 0); -- byte count tenant compte des byte enables

    ---------------------------------------------------------------------
    -- New transmit interface
    ---------------------------------------------------------------------
    tlp_out_req_to_send                 : out std_logic;
    tlp_out_grant                       : in  std_logic;

    tlp_out_fmt_type                    : out std_logic_vector(6 downto 0); -- fmt and type field 
    tlp_out_length_in_dw                : out std_logic_vector(9 downto 0);

    tlp_out_src_rdy_n                   : out std_logic;
    tlp_out_dst_rdy_n                   : in  std_logic;
    tlp_out_data                        : out std_logic_vector(31 downto 0);

    -- for master request transmit
    tlp_out_address                     : out std_logic_vector(63 downto 2); 
    tlp_out_ldwbe_fdwbe                 : out std_logic_vector(7 downto 0);

    -- for completion transmit
    tlp_out_attr                        : out std_logic_vector(1 downto 0); -- relaxed ordering, no snoop
    tlp_out_transaction_id              : out std_logic_vector(23 downto 0); -- bus, device, function, tag
    tlp_out_byte_count                  : out std_logic_vector(12 downto 0); -- byte count tenant compte des byte enables
    tlp_out_lower_address               : out std_logic_vector(6 downto 0);
    
    ---------------------------------------------------------------------
    -- PCIe Register FIFO error detection
    ---------------------------------------------------------------------
    RESET_STR_REG_ERR                    : in    std_logic;
    
    reg_fifo_ovr                         : out   std_logic;
    reg_fifo_und                         : out   std_logic;

    ---------------------------------------------------------------------
    -- Memory Register file interface
    ---------------------------------------------------------------------
    reg_readdata                         : in    std_logic_vector(31 downto 0);
    reg_readdatavalid                    : in    std_logic;

    reg_addr                             : out   std_logic_vector;--(REG_ADDRMSB downto REG_ADDRLSB);
    reg_read                             : out   std_logic;
    reg_write                            : out   std_logic;
    reg_beN                              : out   std_logic_vector(3 downto 0);
    reg_writedata                        : out   std_logic_vector(31 downto 0)
  );
end pcie_reg;    

architecture functional of pcie_reg is

  ---------------------------------------------------------------------------
  -- components
  ---------------------------------------------------------------------------
  component xil_pcie_reg_fifo is
    port (
    clk                  : in std_logic;
    srst                 : in std_logic;

    wr_en                : in std_logic;
    din                  : in std_logic_vector(35 downto 0);
    rd_en                : in std_logic;
    dout                 : out std_logic_vector(35 downto 0);

    data_count           : out std_logic_vector(9 downto 0);
    empty                : out std_logic;
    full                 : out std_logic;
    prog_full            : out std_logic;

    overflow             : out std_logic;
    underflow            : out std_logic
    );
  end component;


  ---------------------------------------------------------------------------
  -- constants
  ---------------------------------------------------------------------------

  ---------------------------------------------------------------------------
  -- signals
  ---------------------------------------------------------------------------
  signal sys_reset                         : std_logic;
  signal fifo_sys_reset                    : std_logic; -- synchronous reset meme sur l'activation.

  -- state machine qui process les requetes venant du core pcie
  type process_request_type is (IDLE, ACCEPT, STORE_TRANSACTION_ID, EXECUTE_WRITE, WAIT_READVALID, EXECUTE_READ);

  -- Rx state machine 
  signal next_req_state                   : process_request_type;
  signal current_req_state                : process_request_type;

  --attribute mark_debug                     : string;
  --attribute mark_debug of current_req_state            : signal is "true";
  
  signal write_not_read                   : std_logic;
  signal execute_length                   : std_logic_vector(tlp_in_length_in_dw'range);
  signal reg_read_int                     : std_logic;
  signal reg_addr_int                     : std_logic_vector(reg_addr'range);

  signal reg_readdata_p1                  : std_logic_vector(reg_readdata'range); -- pour pouvoir bien pipeliner

  -- Register FIFO
  signal reg_fifo_rden                    : std_logic; 
  signal reg_fifo_empty                   : std_logic; 
  signal reg_fifo_full                    : std_logic; 
  signal reg_fifo_over                    : std_logic; 
  signal reg_fifo_under                   : std_logic; 
  signal reg_fifo_wren                    : std_logic;
  signal reg_fifo_din                     : std_logic_vector(35 downto 0);
  signal reg_fifo_dout                    : std_logic_vector(35 downto 0);
  signal reg_data_count                   : std_logic_vector(9 downto 0);  
  signal enough_data_to_send              : std_logic;

  -- state machine qui process les donnees a retourner aux requester (valeur en readback)
  type process_completion_type is (IDLE_COMP, GET_LADDR_BCOUNT, GET_TRANSACTION_ID, WAIT_DATA, REQ_TX, TRANSFER_DATA, NEXT_TLP);

  -- Rx state machine 
  signal next_compl_state                   : process_completion_type;
  signal current_compl_state                : process_completion_type;
  
  --attribute mark_debug of current_compl_state            : signal is "true";

  
  signal total_read_length_dw               : std_logic_vector(tlp_in_length_in_dw'range);
  signal lower_address                      : std_logic_vector(6 downto 0);
  signal byte_count                         : std_logic_vector(tlp_in_byte_count'range);
  signal length_in_byte                     : std_logic_vector(8 downto 0); -- hardcode a 1 to 128 car notre algo hardcode qu'on repond avec des TLP de 128 bytes au maximum.
  signal dw_length_downcount                : std_logic_vector(6 downto 0); -- hardcode de 1 a 32 car notre algo hardcocode qu'on repond avec des tlp de 32 DW maximum.
  signal transaction_id                     : std_logic_vector(tlp_out_transaction_id'range);
  signal attrib                             : std_logic_vector(tlp_out_attr'range);
  
begin

  -- Ce state machine recoit les commandes du module pcie, les execute une a la fois en sauvegardant les bonnes infos dans le
  -- fifo de completion (pour read seulement) 
  combressm:process(current_req_state, tlp_in_valid, tlp_in_fmt_type, execute_length, reg_readdatavalid, reg_fifo_full, reg_read_int)
  begin
    
    case (current_req_state) is
  
      when IDLE =>
      
        if (tlp_in_valid = '1') then
          next_req_state <= ACCEPT;
        else
          next_req_state <= IDLE;      
        end if;

      when ACCEPT =>
    
        if (tlp_in_fmt_type(6) = '1') then      -- TLP with data veut dire un write
          -- on n'aura pas de completion a envoyer, donc on passe tout de suite a l'execution
          next_req_state <= EXECUTE_WRITE;
        else
          -- Sur un read on va vouloir sauvegarder des donnes pour le completion
          next_req_state <= STORE_TRANSACTION_ID;      
        end if;

      when STORE_TRANSACTION_ID =>

        next_req_state <= WAIT_READVALID;

      when WAIT_READVALID => 
        if reg_readdatavalid = '1' then    
          if conv_integer(execute_length) = 0 then      
            next_req_state <= IDLE;
          else
            next_req_state <= EXECUTE_READ;      
          end if;
        else
          next_req_state <= WAIT_READVALID;      
        end if;

      when EXECUTE_READ => 
        if reg_fifo_full = '1' then
          -- cas d'overrun, on va rester dans l'etat read jusqu'a ce qu'il y ait de la place dans le fifo    
          next_req_state <= EXECUTE_READ;
        elsif reg_read_int = '1' then -- on fait une lecture, alors on va attendre la reponse
          next_req_state <= WAIT_READVALID;
        else
          -- si le fifo n'est pas full, mais qu'on est pas en train de faire une lecture, c'est qu'on sort de la condition overrun.
          -- on va donc faire un read a ce coup-ci.  On va donc rester dans cet etat un dernier coup d'horloge.
          next_req_state <= EXECUTE_READ;
        end if;

      when EXECUTE_WRITE => 
    
        if conv_integer(execute_length) = 0 then      
          next_req_state <= IDLE;
        else
          next_req_state <= EXECUTE_WRITE;      
        end if;

      when others =>
        next_req_state <= IDLE;
        
    end case;
  end process;

  flopressm:process(sys_clk)
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
  -- les ID D, A, et 1 sont juste des marqueurs pour aider le debug. Je les mets dans le fifo juste parce que les BRAM ont 36 bits de toute facon. 
  -- Cependant, meme s'ils ne sont jamais utilise a la sortie du fifo, ils risquent ne pas etre enlever par l'optimisation, alors idealement il faudra enlever ces marqeur sur la version synthetisee.
  -- Alternativement, pour pouvoir recuperer des SEU sur le fifo sans resetter tout le systeme, on pourra utiliser ces marqueur pour resynchroniser les 2 SM de part et d'autre du fifo.
  -- on n'implante pas ce mechanisme initialement pour ne pas cacher de bugs...
  with current_req_state select
    reg_fifo_din <= x"A" & "0" & tlp_in_byte_count & tlp_in_address(6 downto 0) & tlp_in_length_in_dw when ACCEPT,
                    x"1" & "000000" & tlp_in_attr & tlp_in_transaction_id when STORE_TRANSACTION_ID,
                    x"D" & reg_readdata_p1 when others;

  -- quand le register file confirme qu'il y a du data de readback disponible, le data est sur le bus (pour un coup de clock). 
  -- Comme on veut garder le reg_fifo_wren floppe et qu'on ne peux pas le savoir quand le data sera disponible, il faut retarder le data
  datadelayprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      reg_readdata_p1 <= reg_readdata;
    end if;
  end process;
    
  fifowrprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if sys_reset = '1' then
        reg_fifo_wren <= '0';
      elsif next_req_state = STORE_TRANSACTION_ID or (next_req_state = ACCEPT and tlp_in_fmt_type(6) = '0') then -- quand on accepte un read ou qu'on store des info (seulement en read aussi)
        reg_fifo_wren <= '1';
      elsif reg_readdatavalid = '1' then -- on store du data de readback a retourner au requester
        reg_fifo_wren <= '1';
      else
        reg_fifo_wren <= '0';
      end if;
    end if;
  end process;

  -- on sauvegarde si on doit faire un read ou un write pour le savoir pendant toute la transaction
  rnwprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if current_req_state = IDLE then
        write_not_read <= tlp_in_fmt_type(6); -- ce bit indique si la transaction est du payload avec ou sans data, ce qui est suffisant pour identifier un write vs read
      end if;
    end if;
  end process;  

  -- pour pouvoir iterer plusieurs cycles register bus par transaction, il nous faut un compteur
  elprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if current_req_state = IDLE then
        execute_length <= tlp_in_length_in_dw;
      elsif next_req_state = EXECUTE_WRITE then -- pour le write
        execute_length <= execute_length - '1';
      elsif current_req_state = STORE_TRANSACTION_ID or reg_readdatavalid = '1' then -- pour le read, on decremente en meme temps qu'on fait le reg_read, donc initialement, plus a chaque data retourne
        execute_length <= execute_length - '1';
      end if;
    end if;
  end process;

  -- feedback au module RX du core pcie.
  -- pour l'instant, c'est definit comme ceci: pour un TLP avec data, on acknowledge qu'on est pret a prendre le data avec tlp_in_accept_data, un clock par data
  -- Pour les read, il n'y a pas de data, alors un seul coup de clock acknowledge le TLP.
  accdtaprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if sys_reset = '1' then
        tlp_in_accept_data <= '0';
      elsif current_req_state = STORE_TRANSACTION_ID then -- (and write_not_read = '0') condition implicite quand on est dans l'etat store: end condition for a read acknowledge
        tlp_in_accept_data <= '0';
      elsif current_req_state /= IDLE and conv_integer(execute_length) = 1 and write_not_read = '1' then -- end condition for a write access, on doit limite a autre que idle pour en pas couper le debut du write plus bas
        tlp_in_accept_data <= '0';
      elsif tlp_in_valid = '1' and current_req_state = IDLE and tlp_in_fmt_type(6)= '1' then -- start condition for a write access
        tlp_in_accept_data <= '1';
      elsif current_req_state = ACCEPT and write_not_read = '0' then -- start for a read acknowledge
        tlp_in_accept_data <= '1';
      end if;
    end if;
  end process;
      
  regaddrprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if current_req_state = ACCEPT then
        reg_addr_int <= tlp_in_address(reg_addr'high downto reg_addr'low);--(REG_ADDRMSB downto REG_ADDRLSB);
      elsif current_req_state = EXECUTE_WRITE  or reg_readdatavalid = '1' then  -- maintenant qu'on utilise reg_readdatavalid, il ne faut plus pre-incrementer sur store_id  or current_req_state = STORE_TRANSACTION_ID
        reg_addr_int <= reg_addr_int + '1';
      end if;
    end if;
  end process;

  reg_addr <= reg_addr_int after 10 ps; -- pour prevenir les probleme de delta de simulation
  
  -- le strobe reg read et reg write sont genere pendant l'etat execute seulement, dependant de si l'acces est un read ou un write
  regbusstrbprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if next_req_state = EXECUTE_WRITE then
        --if write_not_read = '1' then -- ce check est redondant maintenant qu'on a separe execute en version write et read
          reg_write <= '1' after 10 ps; -- pour prevenir les probleme de delta de simulation
        --else
        --  reg_write <= '0' after 10 ps; -- pour prevenir les probleme de delta de simulation
        --end if;
      else
        reg_write <= '0' after 10 ps; -- pour prevenir les probleme de delta de simulation
      end if;

      --if sys_reset = '1' then
      --  reg_read_int <= '0'; -- on doit resetter ca il n'y a pas de condition else plus bas.
      --els
      if current_req_state = ACCEPT and write_not_read = '0' then -- condition de depart, au accept on doit deja planifier le read.
        reg_read_int <= '1';
      elsif (current_req_state = WAIT_READVALID and reg_readdatavalid = '1') and conv_integer(execute_length) /= 0 then -- cas ou on vient d'avoir notre data, on passe au prochain
        reg_read_int <= '1';
      elsif (current_req_state = EXECUTE_READ and reg_read_int = '0' and reg_fifo_full = '0') and conv_integer(execute_length) /= 0 then -- cas ou on vient de sortir d'un overrun du fifo, il faut repartir la machine avec un reg_read_int
        reg_read_int <= '1';
      else -- cas du dernier data de lu, on descent le read
        reg_read_int <= '0';      
      end if;      

      -- on flop le data puisque quand on l'accepte il va changer le clock suivant (?)
      reg_beN <= not tlp_in_byte_en  after 10 ps; -- pour prevenir les probleme de delta de simulation
      reg_writedata <= tlp_in_data  after 10 ps; -- pour prevenir les probleme de delta de simulation;
      
    end if;
  end process;
  
  reg_read <= reg_read_int after 10 ps; -- pour prevenir les probleme de delta de simulation
  
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

  -- Vivado se plain qu'il y a un reset asynchrone sur le FF qui drive le reset du fifo. On resynchronise.
  fiforstprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      fifo_sys_reset <= sys_reset;
    end if;
  end process;

  ---------------------------------------------------------------------------
  -- instantiations
  ---------------------------------------------------------------------------
  xxil_pcie_reg_fifo : xil_pcie_reg_fifo
    port map (
    clk                  => sys_clk,
    srst                 => fifo_sys_reset,
    
    wr_en                => reg_fifo_wren,
    din                  => reg_fifo_din,
    
    rd_en                => reg_fifo_rden,
    dout                 => reg_fifo_dout,
    
    data_count           => reg_data_count,
    empty                => reg_fifo_empty,
    full                 => open,
    prog_full            => reg_fifo_full, -- Will be full at 256/512

    overflow             => reg_fifo_over,
    underflow            => reg_fifo_under
  );

  -- dans la version Artix-7, le fifo interne doit etre en reset pendant au moins 5 cycles.
  -- synthesis translate_off
  chkrstlengthassert: process
  begin
    wait until sys_reset = '1'; -- on debute un reset, ca doit durer 5 cycles
    for i in 1 to 5 loop
      wait until rising_edge(sys_clk);
      assert sys_reset = '1' report "PULSE DE RESET SUR FIFO INTERNE MOINS DE 5 CYCLES" severity FAILURE;
    end loop;
    -- maintenant qu'on a attendu 5 cycles, il faut que le reset debarque avant qu'on retrigue
    wait until sys_reset = '0';
  end process;
  -- synthesis translate_on
  
  -- synthesis translate_off
  assert reg_fifo_full /= '1' report "REG FIFO FULL, JF check ca" severity WARNING;
  -- synthesis translate_on
  
  -- determination de enough_data_to_send
  -- Le fifo est synchrone, alors le compte sera exact
  -- en fait, quand le state machine passe de GET_TRANSACTION_ID a WAIT_DATA, on lit un data, ce qui peut faire tomber le reg_data_count en dessous de dw_length_downcount 
  -- sans que le enough_data_to_send ait le temps de se mettre a jour. Mais dans ce cas, pour un register read, on sait que la situation va se resorber le coup de clock suivant.
  -- et qu'on va demander le TX pour un coup de clock, puis attendre que le header soit envoyer, donc bien assez de temps pour faire un seul reg read.
  -- pour l'interface memoire, c'est autre chose car le retour d'un read peut prendre un temps indefiniment long.
  edtdprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if current_compl_state = GET_TRANSACTION_ID  or current_compl_state = NEXT_TLP then -- on doit d'abord forcer le signal a 0 au premier clock de wait data car le dw_length_downcount n'est pas valide 
        enough_data_to_send <= '0';                  -- avant le wait data, donc enough_data_to_send est valide un clock plus tard, au deuxieme clock de wait_data
      elsif conv_integer(reg_data_count) >= conv_integer(dw_length_downcount) then
        enough_data_to_send <= '1';
      else
        enough_data_to_send <= '0';
      end if;
    end if;
  end process;
  

  -- Ce state machine recoit les information pour generer les TLP de completion. 
  -- Il recoit les donnes associees a la requete pour faire header, suivit du data a retourner
  -- il split les CPLD en block aligne sur 128 bytes, le read completion block.  
  -- Ainsi notre TLP n'est jamais trop long par rapport a ce qui est programme dans le config space
  combcomplsm:process(current_compl_state,tlp_out_grant,reg_fifo_empty,enough_data_to_send,dw_length_downcount,byte_count)
  begin

    case (current_compl_state) is
  
      when IDLE_COMP =>
        if (reg_fifo_empty = '0') then
          next_compl_state <= GET_LADDR_BCOUNT;
        else
          next_compl_state <= IDLE_COMP;      
        end if;

      when GET_LADDR_BCOUNT =>
        if (reg_fifo_empty = '0') then
          next_compl_state <= GET_TRANSACTION_ID;
        else
          next_compl_state <= GET_LADDR_BCOUNT;      
        end if;

      when GET_TRANSACTION_ID =>
        if (reg_fifo_empty = '0') then
          next_compl_state <= WAIT_DATA;
        else
          next_compl_state <= GET_TRANSACTION_ID;      
        end if;

      when WAIT_DATA => 
        if enough_data_to_send = '1' then      
          next_compl_state <= REQ_TX;
        else
          next_compl_state <= WAIT_DATA;      
        end if;

      when REQ_TX =>
        if tlp_out_grant = '1' then
          next_compl_state <= TRANSFER_DATA;
        else
          next_compl_state <= REQ_TX;      
        end if;

      when TRANSFER_DATA =>
        if conv_integer(dw_length_downcount) = 0 then
          next_compl_state <= NEXT_TLP;
        else
          next_compl_state <= TRANSFER_DATA;      
        end if;

      when NEXT_TLP =>
        if conv_integer(byte_count) = 0 then
          next_compl_state <= IDLE_COMP;
        else
          next_compl_state <= WAIT_DATA;      
        end if;

      when others =>
        next_compl_state <= IDLE_COMP;
        
    end case;
  end process;

  flopcombsm:process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if sys_reset = '1' then
        current_compl_state <= IDLE_COMP;
      else
        current_compl_state <= next_compl_state;
      end if;
    end if;
  end process;

  -- on redecode ce qui sort du fifo
  --  with current_req_state select
  --  reg_fifo_din <= x"D" & reg_readdata when EXECUTE,
  --                  x"A" & "00" & tlp_in_byte_count & tlp_in_address(6 downto 0) & tlp_in_length_in_dw when ACCEPT,
  --                  x"1" & "000000" & tlp_in_attr & tlp_in_transaction_id when others; -- ou plutot STORE_TRANSACTION_ID
  tlplindwprc:process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if current_compl_state = GET_LADDR_BCOUNT then
        total_read_length_dw <= reg_fifo_dout(total_read_length_dw'range); -- hardcode sur les LSB du fifo
      elsif current_compl_state = REQ_TX and next_compl_state = TRANSFER_DATA then
        total_read_length_dw <= total_read_length_dw - dw_length_downcount;
      end if;
    end if;
  end process;
  
  tlpladdrprc:process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if current_compl_state = GET_LADDR_BCOUNT then
        lower_address <= reg_fifo_dout(tlp_in_length_in_dw'length+lower_address'length-1 downto tlp_in_length_in_dw'length); -- hardcode au dessus du tlp length.
      elsif current_compl_state = REQ_TX and next_compl_state = TRANSFER_DATA then
        lower_address <= (others => '0'); -- car maintenant on est forcement aligne sur un RCB
      end if;
    end if;
  end process;
  
  tlpbcprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if current_compl_state = GET_LADDR_BCOUNT then
        byte_count <= reg_fifo_dout(tlp_in_length_in_dw'length+lower_address'length+byte_count'length-1 downto lower_address'length+tlp_in_length_in_dw'length); -- hardcode au dessus du tlp length.
      elsif current_compl_state = REQ_TX and next_compl_state = TRANSFER_DATA then
        byte_count <= byte_count - length_in_byte;
      end if;
    end if;
  end process;

  -- on recupere les donnee a retourner avec le completion pour identifier la requete.
  --  x"1" & "000000" & tlp_in_attr & tlp_in_transaction_id when others; -- ou plutot STORE_TRANSACTION_ID
  transidprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if current_compl_state = GET_TRANSACTION_ID then
        transaction_id <= reg_fifo_dout(transaction_id'range);
        attrib <= reg_fifo_dout(transaction_id'length+attrib'length-1 downto transaction_id'length);
      end if;
    end if;
  end process;
        
  -- on determine la longeur du TLP en fonction de l'adresse ou on retourne le data. 
  -- Si l'adresse n'est pas aligne sur un RCB de 128 bytes, ca limite la grandeur du TLP qu'on peut envoyer
  tlplengthprc: process(sys_clk)
    variable max_length_from_addr : integer range 1 to 32;
  begin
    if rising_edge(sys_clk) then
      if current_compl_state = GET_TRANSACTION_ID or current_compl_state = NEXT_TLP then -- une clock apres qu'on a les signaux source du fifo
        max_length_from_addr := 32 - conv_integer(lower_address(6 downto 2));

        if max_length_from_addr < conv_integer(total_read_length_dw) then
          -- on est limite par l'adresse
          dw_length_downcount <= conv_std_logic_vector(max_length_from_addr,dw_length_downcount'length);
        elsif conv_integer(total_read_length_dw) < 32 then
          -- on est limite par ce qui nous reste a transmettre
          dw_length_downcount <= total_read_length_dw(dw_length_downcount'range);
        else
          -- on est limite par le TLP
          dw_length_downcount <= conv_std_logic_vector(32,dw_length_downcount'length);
        end if;
      elsif current_compl_state = TRANSFER_DATA and tlp_out_dst_rdy_n = '0' then
        dw_length_downcount <= dw_length_downcount - '1';
      end if;
    end if;
  end process;
  
  -- calcul equivalent, mais pour le byte count. Ce calcul est affecte par les bytes enables de debut et de fin de burst.
  -- dans le cas ou le burst est totalement a l'interieur d'un RCB et que les bytes enables ne sont pas toute actives
  -- au debut et/ou a la fin du burst, alors il y a plusieurs possibilite de dw_length_downcount pour un meme calcul 
  -- de length_in_byte.  On ne peut donc pas determiner un signal a partir de l'autre
  tlpbytecountprc: process(sys_clk)
    variable max_byte_count_from_addr: integer range 1 to 128;
  begin
    if rising_edge(sys_clk) then
      if current_compl_state = GET_TRANSACTION_ID or current_compl_state = NEXT_TLP then -- une clock apres qu'on a les signaux source du fifo
        max_byte_count_from_addr := 128 - conv_integer(lower_address(6 downto 0));

        if max_byte_count_from_addr < conv_integer(byte_count) then
          -- on est limite par l'adresse
          length_in_byte <= conv_std_logic_vector(max_byte_count_from_addr,length_in_byte'length);
        elsif conv_integer(byte_count) < 128 then
          -- on est limite par ce qui nous reste a transmettre
          length_in_byte <= byte_count(length_in_byte'range);
        else
          -- on est limite par le TLP
          length_in_byte <= conv_std_logic_vector(128,length_in_byte'length);
        end if;
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

  tlp_out_fmt_type <= "1001010"; -- toujours completion with data
  
  tlp_out_length_in_dw <= conv_std_logic_vector(conv_integer(dw_length_downcount),tlp_out_length_in_dw'length); -- completer les MSB

  with current_compl_state select
    reg_fifo_rden <=  not tlp_out_dst_rdy_n when TRANSFER_DATA,
                      '1' when GET_LADDR_BCOUNT,
                      '1' when GET_TRANSACTION_ID,
                      '0' when others;

  tlp_out_src_rdy_n <= '0' when current_compl_state = TRANSFER_DATA else '1';
  tlp_out_data         <= reg_fifo_dout(31 downto 0);

  -- for master request transmit
  tlp_out_address      <= (others => '-');-- nous somme un completeur, don't care
  tlp_out_ldwbe_fdwbe  <= (others => '-');-- nous somme un completeur, don't care

  -- for completion transmit
  tlp_out_attr           <= attrib;
  tlp_out_transaction_id <= transaction_id; 
  tlp_out_byte_count     <= byte_count;
  tlp_out_lower_address  <= lower_address;
                                          
      
    

end functional;
    