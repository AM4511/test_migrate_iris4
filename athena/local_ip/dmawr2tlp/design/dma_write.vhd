-----------------------------------------------------------------------
-- $HeadURL: svn: dma_write.vhd $
-- $Author: jlarin $
-- $Revision: 9647 $
-- $Date: 2012-08-01 15:43:50 -0400 (Wed, 01 Aug 2012) $
--
-- DESCRIPTION: Nouveau DMA qui ne fait que l'operation de DMA, 
--              c'est-a-dire lire d'une memoire locale et pousser les
--              donnees vers la memoire host par le pcie
--              
-----------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all; 
  use ieee.std_logic_unsigned.all;
  use ieee.numeric_std.all;
  use work.dma_pack.all;

entity dma_write is
  generic (
    NUMBER_OF_PLANE        : integer range 1 to 3 := 1;
    READ_ADDRESS_MSB       : integer := 10;         -- doit etre ajuste en fonction de la ligne maximale. 4095 pixel x BGR32 = 16kB = 2k * 8 bytes 
    MAX_PCIE_PAYLOAD_SIZE  : integer := 128         -- ceci sert a limiter la dimension maximale que les agents master sur le pcie (le DMA) peuvent utiliser, en plus de la limitation
    
    );
  port (
    ---------------------------------------------------------------------
    -- PCIe user domain reset and clock signals
    ---------------------------------------------------------------------
    sys_clk                              : in    std_logic;
    sys_reset_n                          : in    std_logic;

    ---------------------------------------------------------------------
    -- Configuration space info (sys_clk)
    ---------------------------------------------------------------------
    cfg_bus_mast_en                      : in    std_logic;                              
    cfg_setmaxpld                        : in    std_logic_vector(2 downto 0);

    ---------------------------------------------------------------------
    -- PCIe tx (sys_clk)
    ---------------------------------------------------------------------
    ---------------------------------------------------------------------
    -- transmit interface
    ---------------------------------------------------------------------
    tlp_req_to_send                 : out std_logic;
    tlp_grant                       : in  std_logic;

    tlp_fmt_type                    : out std_logic_vector(6 downto 0); -- fmt and type field 
    tlp_length_in_dw                : out std_logic_vector(9 downto 0);

    tlp_src_rdy_n                   : out std_logic;
    tlp_dst_rdy_n                   : in  std_logic;
    tlp_data                        : out std_logic_vector(63 downto 0); 

    -- for master request transmit
    tlp_address                     : out std_logic_vector(63 downto 2); 
    tlp_ldwbe_fdwbe                 : out std_logic_vector(7 downto 0);

    -- for completion transmit
    tlp_attr                        : out std_logic_vector(1 downto 0); -- relaxed ordering, no snoop
    tlp_transaction_id              : out std_logic_vector(23 downto 0); -- bus, device, function, tag
    tlp_byte_count                  : out std_logic_vector(12 downto 0); -- byte count tenant compte des byte enables
    tlp_lower_address               : out std_logic_vector(6 downto 0);

    -- DMA transfer parameters
    host_number_of_plane                : in integer;
    host_write_address                  : in HOST_ADDRESS_ARRAY(NUMBER_OF_PLANE-1 downto 0);
    host_line_pitch                     : in std_logic_vector(15 downto 0);
    host_line_size                      : in std_logic_vector(13 downto 0);
    host_reverse_y                      : in  std_logic; -- ecrire a l'envers.

    -- To Sensor interface, grab abort logic
    dma_idle                            : out std_logic;
    dma_pcie_state                      : out std_logic_vector(2 downto 0);  -- pour debug seulement
    
    -- Interface to read data, on read_clk
    start_of_frame                      : in  std_logic; -- repart l'ecriture au host_write_address, repart la lecture a l'adresse 0 de la ram partagee
    line_ready                          : in  std_logic; -- indique qu'une ligne est disponible dans la RAM partagee
    line_transfered                     : out std_logic; -- indique que la ligne signalée par line_ready est maintenant consumée (transférée au host)
    end_of_dma                          : in std_logic;

    read_enable_out                     : buffer std_logic;
    read_address                        : buffer std_logic_vector(READ_ADDRESS_MSB downto 0); -- buffers 2k x 8 bytes hardcode pour l'instant
    read_data                           : in  std_logic_vector(63 downto 0)
  );
end dma_write;    

architecture functional of dma_write is


  ---------------------------------------------------------------------------
  -- constants
  ---------------------------------------------------------------------------

  -- Our maximum payload size is 1024B takes 8 bits when base 0
  constant MAXPAY_DW_MSB  : integer := 7; 
  constant MAXPAY_B_MSB   : integer := 9; 

  ---------------------------------------------------------------------------
  -- types
  ---------------------------------------------------------------------------
  type dma_pcie_ctrl_state_type is (IDLE, FRAME_STARTED, LINE_START, CALC_BYTECNT, CALC_EOL, TRANSF_DATA, LINE_END, NEXT_PLANE);

  ---------------------------------------------------------------------------
  -- signals
  ---------------------------------------------------------------------------
  signal dma_toreach_4kb                : std_logic_vector(host_line_size'range);
  signal dma_maxpayload                 : std_logic_vector(host_line_size'range);
  signal dma_maxpayload_static_and_pcie : std_logic_vector(host_line_size'range);
  signal dma_maxpayload_no_offset       : std_logic_vector(host_line_size'range);
  signal remain_bcnt                    : std_logic_vector(host_line_size'range);
  signal bytecnt                        : std_logic_vector(MAXPAY_B_MSB+1 downto 0); -- base1 (9:0)

  signal dwcnt                          : std_logic_vector(MAXPAY_DW_MSB+1 downto 0); -- base1 (9:0)
  signal curr_dwcnt                     : std_logic_vector(MAXPAY_DW_MSB+1 downto 0); -- base1 (9:0)
  signal data_byte_offset               : std_logic_vector(1 downto 0);
  signal dw_misalig                     : std_logic_vector(2 downto 0);

  signal ldwbe_misalig                  : std_logic_vector(1 downto 0);
  signal ldwbe_tobe                     : std_logic_vector(3 downto 0); 

  signal nxt_dma_pcie_ctrl_state        : dma_pcie_ctrl_state_type;
  signal dma_pcie_ctrl_state            : dma_pcie_ctrl_state_type;

  signal end_of_line                    : std_logic;

  signal line_offset                    : std_logic_vector(28 downto 0); -- multi plan: offset dans le frame buffer, choisis pour supporter jusqu'a 4k x 4k x BGR64 en signe
  
  signal dma_tlp_addr_buf               : std_logic_vector((tlp_address'left) downto 0);

  signal nb_pcie_dout                   : std_logic_vector(MAXPAY_DW_MSB+1 downto 0); -- base 1 (7:0)

  signal dma_tlp_fdwbe                  : std_logic_vector(3 downto 0);
  signal dma_tlp_ldwbe                  : std_logic_vector(3 downto 0);
  
  signal line_ready_meta                : std_logic;
  signal line_ready_sysclk              : std_logic;

  signal end_of_dma_sysclk              : std_logic;

  signal first_write_of_line            : std_logic;

  signal plane_counter                  : std_logic_vector(1 downto 0);
    
  -- signal de CE sur le FF qu'on va probablement vouloir pousser dans l'inference de la ram, dans un autre module.
  signal ram_output_enable              : std_logic;
  signal read_data_delayed              : std_logic_vector(63 downto 8) := (others => '0'); -- hardcode parce le vecteur du core pcie est 64 bit hardcode, initialise pour ne pas faire planter la simulation
  --signal byte_shift                     : std_logic_vector(2 downto 0);
  signal byte_shift                     : std_logic_vector(2 downto 0);

  attribute mark_debug : string;
  attribute mark_debug of dma_pcie_ctrl_state   : signal is "true";


begin

  assert NUMBER_OF_PLANE < 2**(plane_counter'length) report "LA LARGEUR DU VECTEUR plane_counter LIMITE LE NOMBRE DE PLAN!" severity FAILURE;
  
  -----------------------------------------------------------------------------
  -- Quantite de data a envoyer sur cette ligne. On charge au debut de la ligne
  -- et on reduit a chaque fois qu'on nous grant un DMA vers le host
  -----------------------------------------------------------------------------
  process(sys_clk)
  begin
    if (sys_clk'event and sys_clk = '1') then
  
      if (dma_pcie_ctrl_state = LINE_START) then

        remain_bcnt <= host_line_size;

      elsif (tlp_grant = '1') then
        remain_bcnt <= remain_bcnt - bytecnt;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- On charge l'adresse au debut du frame, on l'ajuste a chaque TLP puis on
  -- passe a la prochaine ligne quand une ligne est terminee
  -----------------------------------------------------------------------------
  process(sys_clk)
  begin
    
    if rising_edge(sys_clk) then
      if (tlp_grant = '1') then
        dma_tlp_addr_buf <= dma_tlp_addr_buf + bytecnt;
      elsif dma_pcie_ctrl_state = FRAME_STARTED or dma_pcie_ctrl_state = NEXT_PLANE then -- si on passe au prochain plan, il faut charger son adresse.
        dma_tlp_addr_buf <= std_logic_vector(signed(host_write_address(conv_integer(plane_counter))) + signed(line_offset));
      end if; 

      if (dma_pcie_ctrl_state = IDLE) then
        -- Initial frame address
        -- on peut charger tout le temps puisque on s'en sert pas de toute facon
        line_offset      <= (others => '0');
      elsif dma_pcie_ctrl_state = LINE_END and nxt_dma_pcie_ctrl_state = FRAME_STARTED then
        if host_reverse_y = '0' then
          line_offset      <= line_offset + host_line_pitch;
        else
          line_offset      <= line_offset - host_line_pitch;
        end if;
      end if; 

    end if;
  end process;

  -- Assigning output port, transferring DW portion
  tlp_address <= dma_tlp_addr_buf(63 downto 2);

  -----------------------------------------------------------------------------
  -- We need to find how much data we are sending in the TLP in bytes
  -----------------------------------------------------------------------------
  process(sys_clk)
  begin
    
    if (sys_clk'event and sys_clk = '1') then
      if (dma_pcie_ctrl_state = CALC_BYTECNT) then
    	
        if (remain_bcnt < dma_maxpayload) then
          if (remain_bcnt < dma_toreach_4kb) then
        
            bytecnt <= remain_bcnt(MAXPAY_B_MSB+1 downto 0);
          else  
            bytecnt <= dma_toreach_4kb(MAXPAY_B_MSB+1 downto 0);
          end if;
        else
          if (dma_maxpayload < dma_toreach_4kb) then
            bytecnt <= dma_maxpayload(MAXPAY_B_MSB+1 downto 0);
          else
            bytecnt <= dma_toreach_4kb(MAXPAY_B_MSB+1 downto 0);
          end if;  
        end if;
      
      end if;

    end if;
  end process;

  -----------------------------------------------------------------------------
  -- We need to find how much data we are sending in the TLP in DW
  -- on pourrait probablement faire des économies de logique en utilisant le fait
  -- que les adresses et les pitchs sont aligné sur un DW tout le temps.
  -- je ne vais pas stripper le code de cette logique tout de suite et je vais
  -- espéré que l'outil le fasse tout seul.
  -----------------------------------------------------------------------------
  process(sys_clk)
  begin
    if (sys_clk'event and sys_clk = '1') then
  
      if (sys_reset_n = '0') then
  
        dwcnt <= (others => '0');
    
      elsif (dma_pcie_ctrl_state = CALC_BYTECNT) then
    
        if (remain_bcnt < dma_maxpayload) then
          if (remain_bcnt < dma_toreach_4kb) then
        
            -- Sending remaining of the line, if not DW aligned, add 1 DW or 2 DW
            if (dw_misalig = "000") then
              dwcnt <= remain_bcnt(MAXPAY_B_MSB+1 downto 2);
            elsif (dw_misalig <= "100") then
              dwcnt <= remain_bcnt(MAXPAY_B_MSB+1 downto 2) + '1';
            else
              dwcnt <= remain_bcnt(MAXPAY_B_MSB+1 downto 2) + "10";
            end if;
          
          else  
            -- Sending up to 4 kB boundary
            if (dma_tlp_addr_buf(1 downto 0) = "00") then
              dwcnt <= dma_toreach_4kb(MAXPAY_B_MSB+1 downto 2);
            else
              dwcnt <= dma_toreach_4kb(MAXPAY_B_MSB+1 downto 2) + '1';
            end if;
          end if;
        else
          if (dma_maxpayload < dma_toreach_4kb) then
            if (dma_tlp_addr_buf(1 downto 0) = "00") then
              dwcnt <= dma_maxpayload(MAXPAY_B_MSB+1 downto 2);
            else												 
              dwcnt <= dma_maxpayload(MAXPAY_B_MSB+1 downto 2) + '1';
            end if;
          else
            -- Sending up to 4 kB boundary
            if (dma_tlp_addr_buf(1 downto 0) = "00") then
              dwcnt <= dma_toreach_4kb(MAXPAY_B_MSB+1 downto 2);
            else
              dwcnt <= dma_toreach_4kb(MAXPAY_B_MSB+1 downto 2) + '1';
            end if;
          end if;  
        end if;
      end if;
  
    end if;
  end process;

  -- driver la longueur de DW pour envoyer le TLP.
  tlp_length_in_dw(dwcnt'length-1 downto 0) <= dwcnt;
  tlp_length_in_dw(tlp_length_in_dw'high downto dwcnt'length) <= (others => '0'); -- padder les MSB avec 0.

  dw_misalig <= ('0' & remain_bcnt(1 downto 0)) + ('0' & dma_tlp_addr_buf(1 downto 0));

  -- pour pouvoir limiter la dimension des payload genere par le DMA (a 64 bytes, tel que suggere par Intel, par exemple).
  maxpayloadprc: process(cfg_setmaxpld)
  begin
    -- on code la comparaison (le IF) a l'interieur du case pour etre sur que la synthese fasse la simplification entre les constantes au temps de la compilation et pas de maniere dynamique.
    case cfg_setmaxpld is
    when "000" =>
      if MAX_PCIE_PAYLOAD_SIZE < 128 then
        dma_maxpayload_static_and_pcie <= std_logic_vector(to_unsigned(MAX_PCIE_PAYLOAD_SIZE,dma_maxpayload_static_and_pcie'length));
      else
        dma_maxpayload_static_and_pcie <= std_logic_vector(to_unsigned(128,dma_maxpayload_static_and_pcie'length));
      end if;
    when "001" =>
      if MAX_PCIE_PAYLOAD_SIZE < 256 then
        dma_maxpayload_static_and_pcie <= std_logic_vector(to_unsigned(MAX_PCIE_PAYLOAD_SIZE,dma_maxpayload_static_and_pcie'length));
      else
        dma_maxpayload_static_and_pcie <= std_logic_vector(to_unsigned(256,dma_maxpayload_static_and_pcie'length));
      end if;
    when "010" =>
      if MAX_PCIE_PAYLOAD_SIZE < 512 then
        dma_maxpayload_static_and_pcie <= std_logic_vector(to_unsigned(MAX_PCIE_PAYLOAD_SIZE,dma_maxpayload_static_and_pcie'length));
      else
        dma_maxpayload_static_and_pcie <= std_logic_vector(to_unsigned(512,dma_maxpayload_static_and_pcie'length));
      end if;
    when others =>
      if MAX_PCIE_PAYLOAD_SIZE < 1024 then
        dma_maxpayload_static_and_pcie <= std_logic_vector(to_unsigned(MAX_PCIE_PAYLOAD_SIZE,dma_maxpayload_static_and_pcie'length));
      else
        dma_maxpayload_static_and_pcie <= std_logic_vector(to_unsigned(1024,dma_maxpayload_static_and_pcie'length));
      end if;
    end case;
  end process;

  -- on ajoute un etage de limitation de payload dynamique controle par registre
  --process(sys_clk)
  --begin
  --  if (sys_clk'event and sys_clk = '1') then
  --    if dma_maxpayload_static_and_pcie < MAXPAYLOAD then
        dma_maxpayload_no_offset <= dma_maxpayload_static_and_pcie;
  --    else
  --      dma_maxpayload_no_offset <= conv_std_logic_vector(conv_integer(MAXPAYLOAD),dma_maxpayload_no_offset'length);
  --    end if;
  --  end if;
  --end process;

                            
  dma_maxpayload <= dma_maxpayload_no_offset - data_byte_offset;                            
                  
  -- We are calculating here how much data there is to reach 4KB boundary
  -- ici ca fonctionne parce que le host line size est > 4k.
  dma_toreach_4kb <= std_logic_vector(to_unsigned(4096,dma_toreach_4kb'length)) - dma_tlp_addr_buf(11 downto 0);

  -- Depending initial write offset
  -- the data for proper alignment
  data_byte_offset <= dma_tlp_addr_buf(1 downto 0);

  -----------------------------------------------------------------------------
  -- We need to save the dwcnt for the current transaction to compare with 
  -- nb_pcie_dout. 
  -----------------------------------------------------------------------------
  process(sys_clk)
  begin
    if (sys_clk'event and sys_clk = '1') then
      if (dma_pcie_ctrl_state = CALC_EOL) then -- on devance la mise a jour a la fin du calcul precedent car on va maintenant echantillonne curr_dwcnt plus tot.
        curr_dwcnt <= dwcnt;
      end if;  
    end if;
  end process;
  
  -----------------------------------------------------------------------------
  -- Calculating FDWBE once bytecnt available
  -----------------------------------------------------------------------------
  process(sys_clk)
  begin
    if (sys_clk'event and sys_clk = '1') then
      if (dma_pcie_ctrl_state = CALC_EOL) then
        if (dwcnt = "00000001" and dma_tlp_addr_buf(1 downto 0) = "00") then
          if (bytecnt(1 downto 0) = "01")  then
            dma_tlp_fdwbe <= "0001";
          elsif (bytecnt(1 downto 0) = "10")  then
            dma_tlp_fdwbe <= "0011";
          elsif (bytecnt(1 downto 0) = "11")  then
            dma_tlp_fdwbe <= "0111";
          else
            dma_tlp_fdwbe <= "1111";
          end if;
        elsif (dma_tlp_addr_buf(1 downto 0) = "01")  then
          dma_tlp_fdwbe <= "1110";
        elsif (dma_tlp_addr_buf(1 downto 0) = "10")  then
          dma_tlp_fdwbe <= "1100";
        elsif (dma_tlp_addr_buf(1 downto 0) = "11")  then
          dma_tlp_fdwbe <= "1000";
        else
          dma_tlp_fdwbe <= "1111";
        end if;

      end if;
    end if;
  end process;

  ldwbe_misalig <= (bytecnt(1 downto 0)) + (dma_tlp_addr_buf(1 downto 0));

  -----------------------------------------------------------------------------
  -- Calculating LDWBE once bytecnt available
  -----------------------------------------------------------------------------
  process(sys_clk)
  begin
    if (sys_clk'event and sys_clk = '1') then
  
      if (dma_pcie_ctrl_state = CALC_EOL) then
      case ldwbe_misalig(1 downto 0) is
          when "00" =>
            ldwbe_tobe <= "1111";
          when "01" =>
            ldwbe_tobe <= "0001";
          when "10" =>
            ldwbe_tobe <= "0011";
          when others =>
            ldwbe_tobe <= "0111";
        end case;
        
      end if;
    end if;
  end process;

  dma_tlp_ldwbe <= "0000" when dwcnt = "00000001" else ldwbe_tobe;

  tlp_ldwbe_fdwbe <= dma_tlp_ldwbe & dma_tlp_fdwbe;

  -----------------------------------------------------------------------------
  -- Calculating the end of line.  
  -----------------------------------------------------------------------------
  process(sys_clk)
  begin
    if (sys_clk'event and sys_clk = '1') then
  
      if (dma_pcie_ctrl_state = CALC_EOL) then
        if (remain_bcnt = bytecnt) then
          end_of_line <= '1';
        else
          end_of_line <= '0';
        end if;
      end if;
    end if;
  end process;

  -----------------------------------------------------------------------------
  -- DMA PCIE control state machine: sequence to have all info in order to 
  -- start PCIE transfer
  -----------------------------------------------------------------------------
  process(dma_pcie_ctrl_state, cfg_bus_mast_en, tlp_grant, start_of_frame, line_ready_sysclk, line_ready, tlp_dst_rdy_n, nb_pcie_dout, end_of_line, end_of_dma_sysclk, plane_counter, host_number_of_plane)--, old_dma_tlp_addr_buf)
  begin
	
    case dma_pcie_ctrl_state is
  
  	  when IDLE => 
        
        if start_of_frame = '1' then
          -- synthesis translate_off
          assert cfg_bus_mast_en = '1' report "On recoit un start of frame alors que le bus master n'est pas actif, c'est une condition NON-supportee!" severity FAILURE;
          -- synthesis translate_on
        end if;
      
        if (start_of_frame = '1' and cfg_bus_mast_en = '1') then
          nxt_dma_pcie_ctrl_state <= FRAME_STARTED;
        else
          nxt_dma_pcie_ctrl_state <= IDLE;
        end if;

      -- on attend qu'une ligne soit prete a etre transfere
  	  when FRAME_STARTED => 
        if (line_ready_sysclk = '1') then
          nxt_dma_pcie_ctrl_state <= LINE_START;
        elsif end_of_dma_sysclk = '1' then
          nxt_dma_pcie_ctrl_state <= IDLE;
        else
          nxt_dma_pcie_ctrl_state <= FRAME_STARTED;
        end if;
      
      -- etat par lequel on passe une fois a debut de la ligne
      when LINE_START =>
        nxt_dma_pcie_ctrl_state <= CALC_BYTECNT;

      -- premiere etape avant de demander le bus
      when CALC_BYTECNT =>
--        assert old_dma_tlp_addr_buf = dma_tlp_addr_buf report "ERREUR pendant CALC_BYTECNT" severity FAILURE;
        nxt_dma_pcie_ctrl_state <= CALC_EOL;

      -- deuxieme etape avant de demander le bus      
      when CALC_EOL =>
        nxt_dma_pcie_ctrl_state <= TRANSF_DATA;

      -- on demande et fait un transfer de DATA au core
      when TRANSF_DATA =>
        -- synthesis translate_off
        assert line_ready = '1' report "Violation de protocol, notre master descend sa requete en plein milieu de notre transfert de ligne" severity FAILURE;
        -- synthesis translate_on
--        assert old_dma_tlp_addr_buf = dma_tlp_addr_buf report "ERREUR pendant CALC_BYTECNT" severity FAILURE;
        
        if (tlp_dst_rdy_n = '0' and (conv_integer(nb_pcie_dout) = 1 or conv_integer(nb_pcie_dout) = 2) ) then
          if end_of_line = '1' then
            nxt_dma_pcie_ctrl_state <= LINE_END;
          else
            nxt_dma_pcie_ctrl_state <= CALC_BYTECNT;
          end if;
        else
          nxt_dma_pcie_ctrl_state <= TRANSF_DATA;
        end if;

      -- la ligne est terminee, on attend que notre master aie compris
  	  when LINE_END => 
          if conv_integer(plane_counter) = host_number_of_plane - 1 then
            if line_ready_sysclk = '1' then
              nxt_dma_pcie_ctrl_state <= LINE_END;
            else
              -- si on a transfere tous nos plan, on va attendre la prochaine ligne
              nxt_dma_pcie_ctrl_state <= FRAME_STARTED;
            end if;
          else 
            -- si on est en planaire, on va transmettre le prochain plan avant de finir la ligne.
            nxt_dma_pcie_ctrl_state <= NEXT_PLANE;
          end if;

  	  when NEXT_PLANE => 
          nxt_dma_pcie_ctrl_state <= LINE_START;

      when others =>
        nxt_dma_pcie_ctrl_state <= IDLE;

    end case;
  end process;

  -- resynchronisation de line_ready
  lr_rsprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if sys_reset_n = '0' then
        line_ready_meta   <= '0';
        line_ready_sysclk <= '0';
      else
        line_ready_meta <= line_ready;
        line_ready_sysclk <= line_ready_meta;
      end if;
    end if;
  end process;      
  
  -- actuellement, le end_of_dma est deja sur sysclk
  -- cependant, en situation d'erreur, il peut arriver pendant une ligne. Considerant qu'il est court (une clock de long) il peut etre perdu. On le latch donc ici jusqu'a ce qu'il soit utilise ou plus necessaire.
  eodprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if sys_reset_n = '0' then
        end_of_dma_sysclk <= '0';
      elsif dma_pcie_ctrl_state = IDLE then  -- si on a deja fini, ca sert a rien de finir encore.
        end_of_dma_sysclk <= '0';
      elsif end_of_dma = '1' then  -- on latch qu'il faut finir le DMA
        end_of_dma_sysclk <= '1';
      end if;
    end if;
  end process;
  
  -- sortir notre acknowledgement que la ligne est terminee
  -- floppe pour garantir que le glitch ne passe pas d'un domaine d'horloge a l'autre.
  ltprc:process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if dma_pcie_ctrl_state = LINE_END and (conv_integer(plane_counter) = host_number_of_plane - 1) then
        line_transfered <= '1';
      else 
        line_transfered <= '0';
      end if;
    end if;
  end process;

  -- pour debug seulement
  -- le mapping ci-dessous est pris de la compilation courante du anput. L'espoir est de mappé directement le signal d'état dans le registre. C'est à enlever à des fins d'optimisation si jamais c'est utile.
  with dma_pcie_ctrl_state select
  dma_pcie_state <= "000" when IDLE,
                    "001" when FRAME_STARTED,
                    "010" when LINE_START,
                    "011" when CALC_BYTECNT,
                    "100" when CALC_EOL,
                    "101" when TRANSF_DATA,
                    "110" when LINE_END,
                    "111" when others;

  -----------------------------------------------------------------------------
  -- Flopping DMA PCIE state machine
  -----------------------------------------------------------------------------
  process (sys_clk)
  begin
    if (sys_clk'event and sys_clk = '1') then
      if (sys_reset_n = '0') then
        dma_pcie_ctrl_state <= IDLE;
      else
        dma_pcie_ctrl_state <= nxt_dma_pcie_ctrl_state;
      end if;
    end if;
  end process;

  -----------------------------------------------------------------------------
  -- To Sensor interface, grab abort logic
  -----------------------------------------------------------------------------
  process (sys_clk)
  begin
    if (sys_clk'event and sys_clk = '1') then
      if (dma_pcie_ctrl_state = IDLE) then
        dma_idle <= '1';
      else
        dma_idle <= '0';
      end if;
    end if;
  end process;


  
  -------------------
  -- PLANE COUNTER --
  -------------------
  planecntrprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if nxt_dma_pcie_ctrl_state = FRAME_STARTED then
        plane_counter <= (others => '0');
      elsif nxt_dma_pcie_ctrl_state = NEXT_PLANE then
        plane_counter <= plane_counter + '1';
      end if;
    end if;
  end process;

  
  ---------------------------------------------------------------------------
  -- Quand on a une ligne a envoyer, on demande le bus de transmission
  ---------------------------------------------------------------------------
  process(sys_clk)
  begin
    if (sys_clk'event and sys_clk = '1') then
      if (sys_reset_n = '0') then

        tlp_req_to_send <= '0';
      elsif ((conv_integer(nb_pcie_dout) = 1 or conv_integer(nb_pcie_dout) = 2) and tlp_dst_rdy_n = '0') then
        tlp_req_to_send <= '0';
      elsif (nxt_dma_pcie_ctrl_state = TRANSF_DATA) then
        tlp_req_to_send <= '1';
      end if;
    end if;
  end process;

  -- type de TLP qu'on envoie
  tlptypeprc: process(sys_clk, dma_tlp_addr_buf)
  begin
    if conv_integer(dma_tlp_addr_buf(63 downto 32)) = 0 then -- si l'adresse est en bas de 4Gig
      tlp_fmt_type <= "1000000"; -- 3DW + data, adressage 32 bits
    else
      -- si l'adresse est en haut de 4Gig
      tlp_fmt_type <= "1100000"; -- 4DW + data, adresse 64 bits
    end if;
  end process;

  tlp_src_rdy_n <= '0' when dma_pcie_ctrl_state = TRANSF_DATA else '1'; -- on est toujours pret 

  -- je met le FF ici, mais idealement pour le timing, il faudrait qu'il se ramasse a la sortie de la RAM infere. Je me demande si Vivado va faire le transfert automatiquement?
  -- fonctionellement, c'est equivalent, mais c'est plus simple de le laisser ici que de router un signal de CE jusqu'a l'autre module
  outceprc: process(sys_clk)
    variable byte_shift_int : integer;
  begin
    if rising_edge(sys_clk) then

      -- au line start, on enregistre c'est quoi l'offset de cette ligne car il doit demeurer constant pour toute la ligne
      -- L'interface tlp_out est base sur les 32-bits, alors on ne doit faire un shift que pour aligner sur le bon 32 bits
      if dma_pcie_ctrl_state = LINE_START then
        --byte_shift <= dma_tlp_addr_buf(2 downto 0);
        byte_shift <= '0' & dma_tlp_addr_buf(1 downto 0); -- l'interface TLP demande juste d'etre aligne sur 32 bits
      elsif dma_pcie_ctrl_state = TRANSF_DATA and conv_integer(nb_pcie_dout) = 3 and tlp_dst_rdy_n = '0' then
        byte_shift(2) <= '1'; -- si un TLP coupe en plein milieu de notre 64 bit, on doit augmenter le shift de 4
                              -- cela ne peut survenir qu'une seule fois dans une ligne car lorsqu'on est aligne, on n'a pas besoin de se re-aligne.
      end if;

      if dma_pcie_ctrl_state = LINE_START then
        read_data_delayed <= (others => '0');
      elsif  ram_output_enable = '1' then
        read_data_delayed <= read_data(read_data_delayed'range); -- sauvegarder les donnes necessaires lorsque le data est desaligne
      end if;

      if ram_output_enable = '1' then
        byte_shift_int := conv_integer(byte_shift);
        for i in 0 to 7 loop
          if conv_integer(byte_shift) = 0 then -- cas special pour byte_shift 0
            tlp_data(8*i+7 downto 8*i) <= read_data(8*i+7 downto 8*i);
          elsif i >= byte_shift_int then
            tlp_data(8*i+7 downto 8*i) <= read_data(8*(i-byte_shift_int)+7 downto 8*(i-byte_shift_int));
          else
            tlp_data(8*i+7 downto 8*i) <= read_data_delayed(8*(i+8-byte_shift_int)+7 downto 8*(i+8-byte_shift_int));
          end if;
        end loop;
        --tlp_data <= read_data; original, direct map
      end if;

    end if;
  end process;

  -- ce n'est pas des completions qu'on envoie, alors ces valeurs sont don't care.
  tlp_attr            <= (others => '-');
  tlp_transaction_id  <= (others => '-');
  tlp_byte_count      <= (others => '-');
  tlp_lower_address   <= (others => '-');
  
  ---------------------------------------------------------------------------
  -- Counting data getting out of ram to know when the PCIe transfer
  -- needs to finish
  ---------------------------------------------------------------------------
  process(sys_clk)
  begin
    if (sys_clk'event and sys_clk = '1') then
      if tlp_grant = '1' then  --  on recoit le grant, donc notre header est accepte
        nb_pcie_dout <= curr_dwcnt;  -- ce qu'on avait sauvegarder en calculant la longeur de notre requete precedemment
      elsif (tlp_dst_rdy_n = '0') then
        --if conv_integer(nb_pcie_dout) /= 0 then -- arreter le compteur a 0, pour sauver du power, entre autres.
        if conv_integer(nb_pcie_dout) >= 2 then
          nb_pcie_dout <= nb_pcie_dout - "10"; -- on decremente de 2 DW car on sort 64 bits a la fois.
        else -- il est 0 ou 1, donc si on fait -1, on se ramasse a 0
          nb_pcie_dout <= (others => '0');
        end if;
      end if;
    end if;
  end process;

  -- On veut detecter la premiere ecriture de la ligne parce qu'on doit charger le pipeline de data une seule fois par ligne
  fwolprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if dma_pcie_ctrl_state = LINE_START then
        first_write_of_line <= '1';
      elsif dma_pcie_ctrl_state = TRANSF_DATA then
        --si on debut le transfert, on a passer les états ou on precharge le pipeline
        first_write_of_line <= '0';
      end if;
    end if;
  end process;
  
  -- generation des adresse de sortie pour la lecture de la ram partagee:
  rdadddrprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if dma_pcie_ctrl_state = IDLE then
        read_address <= (others => '0'); -- au debut d'un frame, on part de 0.
      else
        if dma_pcie_ctrl_state = LINE_START then 
          -- debut de ligne, on passe au debut
          read_address(read_address'high -2 downto read_address'low) <= (others => '0'); -- on recule au debut de la ligne, mais on preserve le MSB
          read_address(read_address'high downto read_address'high - 1) <= plane_counter;
        elsif (first_write_of_line = '1' and (dma_pcie_ctrl_state = CALC_EOL or dma_pcie_ctrl_state = CALC_BYTECNT)) or tlp_dst_rdy_n = '0' then 
            -- On load le pipeline ou quand le core accepte notre data, passons a l'adresse suivante.
          read_address(read_address'high downto read_address'low) <= read_address(read_address'high downto read_address'low) + '1';
        end if;

        -- la section de la ligne est maintenant faite dans le module de line_transfer en utilisant le handshake (line_ready, line transfered) pour incrementer les compteurs.
        -- c'est donc cache au DMA
      end if;
    end if;
  end process;

  -- permet a l'adresse d'etre utilisee pour sortir des donnees de la ram
  read_enable_out <= '1' when (first_write_of_line = '1' and (dma_pcie_ctrl_state = CALC_EOL or dma_pcie_ctrl_state = CALC_BYTECNT)) or tlp_dst_rdy_n = '0' else '0';

  -- sequencement de transfert
  -- l'etat phase 2 par lequel on passe a chaque debut de transfert de TLP CALC_EOL
  ram_output_enable <= '1' when (first_write_of_line = '1' and dma_pcie_ctrl_state = CALC_EOL) or tlp_dst_rdy_n = '0' else '0';

end functional;
    
