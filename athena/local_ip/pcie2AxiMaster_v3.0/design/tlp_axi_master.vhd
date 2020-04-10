-----------------------------------------------------------------------
-- $HeadURL: svn://brainstorm/fpga/trunk/Matrox/Imaging/FPGA/vmecpugp/mvb/design/tlp_mm_agent.vhd $
-- $Author: amarchan $
-- $Revision: 16264 $
-- $Date: 2016-05-06 18:22:48 -0400 (Fri, 06 May 2016) $
--
-- DESCRIPTION: Ce module fait le pont entre les requetes pcie qui 
--              arrivent, le bus vme_bus compatible aux register files
--              genere par le FDK ou les requetes sont executee
--              et le module ou les completions sont envoyees.
--              
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;


entity tlp_axi_master is
  port (
    ---------------------------------------------------------------------
    -- Reset and clock signals
    ---------------------------------------------------------------------
    sys_clk     : in std_logic;
    sys_reset_n : in std_logic;

    ---------------------------------------------------------------------      

    -- New receive request interface
    ---------------------------------------------------------------------
    tlp_in_accept_data    : out std_logic;
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

    -- for completion transmit
    tlp_out_attr           : out std_logic_vector(1 downto 0);  -- relaxed ordering, no snoop
    tlp_out_transaction_id : out std_logic_vector(23 downto 0);  -- bus, device, function, tag
    tlp_out_byte_count     : out std_logic_vector(12 downto 0);  -- byte count tenant compte des byte enables
    tlp_out_lower_address  : out std_logic_vector(6 downto 0);

    ---------------------------------------------------------------------
    -- PCIe Register FIFO error detection
    ---------------------------------------------------------------------
    RESET_STR_mm_ERR : in std_logic;

    mm_fifo_ovr : out std_logic;
    mm_fifo_und : out std_logic;

    ---------------------------------------------------------------------
    -- Memory Register file interface
    ---------------------------------------------------------------------
    mm_readdata      : in  std_logic_vector(31 downto 0);
    mm_readdatavalid : in  std_logic;
    mm_wait          : in  std_logic;
    mm_addr          : out std_logic_vector;
    mm_read          : out std_logic;
    mm_write         : out std_logic;
    mm_beN           : out std_logic_vector(3 downto 0);
    mm_writedata     : out std_logic_vector(31 downto 0)
    );
end tlp_axi_master;


architecture functional of tlp_axi_master is


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


  ---------------------------------------------------------------------------
  -- constants
  ---------------------------------------------------------------------------

  ---------------------------------------------------------------------------
  -- signals
  ---------------------------------------------------------------------------
  signal sys_reset : std_logic;

  type process_request_type is (S_IDLE, S_ACCEPT, S_STORE_TRANSACTION_ID, S_EXECUTE_WRITE, S_EXECUTE_READ, S_WAIT_LAST_DATA, S_DONE);

  -- Rx state machine 
  signal current_req_state : process_request_type;

  signal isWrite          : std_logic;
  signal transaction_cntr : natural;
  signal read_data_cntr   : natural;

  -- Register FIFO
  signal mm_fifo_rden  : std_logic;
  signal mm_fifo_empty : std_logic;
  signal mm_fifo_full  : std_logic;  -- pour l'instant, ce n'est qu'une information de debuggage
  signal mm_fifo_wren  : std_logic;
  signal mm_fifo_din   : std_logic_vector(35 downto 0);
  signal mm_fifo_dout  : std_logic_vector(35 downto 0);
  signal mm_fifo_usedw : std_logic_vector(9 downto 0);

  signal mm_read_int : std_logic;
  signal mm_read_en  : std_logic;

  -- state machine qui process les donnees a retourner aux requester (valeur en readback)
  type process_completion_type is (IDLE_COMP, GET_LADDR_BCOUNT, GET_TRANSACTION_ID, WAIT_DATA, REQ_TX, PREFETCH, TRANSFER_DATA, NEXT_TLP);

  -- Rx state machine 
  signal next_compl_state    : process_completion_type;
  signal current_compl_state : process_completion_type;

  signal total_read_length_dw : std_logic_vector(tlp_in_length_in_dw'range);
  signal lower_address        : std_logic_vector(6 downto 0);
  signal byte_count           : std_logic_vector(tlp_in_byte_count'range);
  signal length_in_byte       : std_logic_vector(8 downto 0);  -- hardcode a 1 to 128 car notre algo hardcode qu'on repond avec des TLP de 128 bytes au maximum.
  signal dw_length_downcount  : std_logic_vector(6 downto 0);  -- hardcode de 1 a 32 car notre algo hardcocode qu'on repond avec des tlp de 32 DW maximum.
  signal transaction_id       : std_logic_vector(tlp_out_transaction_id'range);
  signal attrib               : std_logic_vector(tlp_out_attr'range);
  signal addrCntrEn           : std_logic;
  signal ldAddrCntr           : std_logic;
  signal addrCntr             : natural;
  signal data_rdy_n           : std_logic;
  signal data_ack             : std_logic;
  signal input_data_ack       : std_logic;
  signal last_byte_ptr        : std_logic_vector(1 downto 0);

  
begin


  -------------------------------------------------------
  -- Active high reset
  -------------------------------------------------------
  sys_reset <= not sys_reset_n;


  -----------------------------------------------------------------------------
  -- Synchronous Process : P_current_req_state
  --
  -----------------------------------------------------------------------------
  P_current_req_state : process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if sys_reset = '1' then
        current_req_state <= S_IDLE;
      else
        case (current_req_state) is

          -------------------------------------------------------------------------
          -- State: S_IDLE
          -------------------------------------------------------------------------
          when S_IDLE =>
            if (tlp_in_valid = '1' and mm_wait = '0' and current_compl_state = IDLE_COMP) then
              current_req_state <= S_ACCEPT;
            else
              current_req_state <= S_IDLE;
            end if;


          -------------------------------------------------------------------------
          -- State: S_ACCEPT
          -------------------------------------------------------------------------
          when S_ACCEPT =>
            -- If write transaction (i.e. tlp_in_fmt_type(6) = '1')
            if (tlp_in_fmt_type(6) = '1') then
              current_req_state <= S_EXECUTE_WRITE;
            else
              current_req_state <= S_STORE_TRANSACTION_ID;
            end if;


          -------------------------------------------------------------------------
          -- State: S_STORE_TRANSACTION_ID (Read Transaction)
          -------------------------------------------------------------------------
          when S_STORE_TRANSACTION_ID =>
            current_req_state <= S_EXECUTE_READ;


          -------------------------------------------------------------------------
          -- State:S_EXECUTE_READ
          -------------------------------------------------------------------------
          when S_EXECUTE_READ =>
            if (transaction_cntr = 1 and addrCntrEn = '1') then
              current_req_state <= S_WAIT_LAST_DATA;
            else
              current_req_state <= S_EXECUTE_READ;
            end if;


          -------------------------------------------------------------------------
          -- State: S_WAIT_LAST_DATA
          -------------------------------------------------------------------------
          when S_WAIT_LAST_DATA =>
            if (read_data_cntr = 0) then
              current_req_state <= S_DONE;
            else
              current_req_state <= S_WAIT_LAST_DATA;
            end if;


          -------------------------------------------------------------------------
          -- State: S_EXECUTE_WRITE
          -------------------------------------------------------------------------
          when S_EXECUTE_WRITE =>
            if (transaction_cntr = 1 and addrCntrEn = '1') then
              current_req_state <= S_DONE;
            else
              current_req_state <= S_EXECUTE_WRITE;
            end if;


          -------------------------------------------------------------------------
          -- State: S_DONE
          -------------------------------------------------------------------------
          when S_DONE =>
            if (mm_wait = '0') then
              current_req_state <= S_IDLE;
            else
              current_req_state <= S_DONE;
            end if;


          -------------------------------------------------------------------------
          -- Default State
          -------------------------------------------------------------------------
          when others =>
            current_req_state <= S_IDLE;

        end case;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Synchronous Process : P_isWrite
  -- Clock       : sys_clk
  -- Reset       : sys_reset_n
  -- Description : Ce bit indique si la transaction est du payload avec ou
  --               sans data, ce qui est suffisant pour identifier un write vs
  --               read.
  -----------------------------------------------------------------------------
  P_isWrite : process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if (sys_reset_n = '0') then
        isWrite <= '0';
      else
        if (current_req_state = S_IDLE and tlp_in_valid = '1') then
          isWrite <= tlp_in_fmt_type(6);
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- On mux certain data a mettre dans le fifo de completion
  -- les ID D, A, et 1 sont juste des marqueurs pour aider le debug.
  -- Je les mets dans le fifo juste parce que les BRAM ont 36 bits de toute facon. 
  -- Cependant, meme s'ils ne sont jamais utilise a la sortie du fifo, ils risquent
  -- ne pas etre enlever par l'optimisation, alors idealement il faudra enlever
  -- ces marqeur sur la version synthetisee.
  -- Alternativement, pour pouvoir recuperer des SEU sur le fifo sans resetter
  -- tout le systeme, on pourra utiliser ces marqueur pour resynchroniser les
  -- 2 SM de part et d'autre du fifo. On n'implante pas ce mechanisme
  -- initialement pour ne pas cacher de bugs...
  -----------------------------------------------------------------------------
  with current_req_state select
    mm_fifo_din <= x"A" & "0" & tlp_in_byte_count & tlp_in_address(6 downto 0) & tlp_in_length_in_dw when S_ACCEPT,
    x"1" & "000000" & tlp_in_attr & tlp_in_transaction_id                                            when S_STORE_TRANSACTION_ID,
    x"D" & mm_readdata                                                                               when others;



  -----------------------------------------------------------------------------
  -- Synchronous Process : P_mm_fifo_wren
  -- Clock       : sys_clk
  -- Reset       : sys_reset
  -- Description : Quand le register file confirme qu'il y a du data de readback
  -- disponible, le data est sur le bus (pour un coup de clock). Comme on veut
  -- garder le mm_fifo_wren floppe et qu'on ne peux pas le savoir quand le
  -- data sera disponible, il faut retarder le data.
  -----------------------------------------------------------------------------
  mm_fifo_wren <= '1' when (current_req_state = S_ACCEPT and tlp_in_fmt_type(6) = '0') else
                  '1' when (current_req_state = S_STORE_TRANSACTION_ID) else
                  '1' when (mm_readdatavalid = '1') else
                  '0';



  -----------------------------------------------------------------------------
  -- Synchronous Process : P_tlp_in_accept_data
  -- Clock       : sys_clk
  -- Reset       : No reset
  -- Description : Feedback au module RX du core pcie.
  -- pour l'instant, c'est definit comme ceci: pour un TLP avec data,
  -- on acknowledge qu'on est pret a prendre le data avec tlp_in_accept_data,
  -- un clock par data. Pour les read, il n'y a pas de data, alors un seul
  -- coup de clock acknowledge le TLP.
  -----------------------------------------------------------------------------
  input_data_ack <= '1' when (current_req_state = S_EXECUTE_WRITE and transaction_cntr > 0 and mm_wait = '0') else
                    '1' when (current_req_state = S_STORE_TRANSACTION_ID) else
                    '0';


  ldAddrCntr <= '1' when(current_req_state = S_ACCEPT) else
                '0';


  addrCntrEn <= '1' when(input_data_ack = '1' and isWrite = '1') else
                '1' when (mm_read_int = '1' and mm_wait = '0') else
                '0';


  -----------------------------------------------------------------------------
  -- Synchronous Process : P_addrCntr
  -- Clock       : sys_clk
  -- Reset       : No reset
  -- Description : Byte address counter of each new DWORD transfered
  -----------------------------------------------------------------------------
  P_addrCntr : process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if (ldAddrCntr = '1') then
        addrCntr <= natural(conv_integer(tlp_in_address(31 downto 2) & "00"));
      elsif (addrCntrEn = '1') then
        addrCntr <= addrCntr + 2 + 2;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Synchronous Process : P_transaction_cntr
  -- Clock       : sys_clk
  -- Reset       : No reset
  -- Description : Pour pouvoir iterer plusieurs cycles register bus par
  -- transaction, il nous faut un compteur.
  -----------------------------------------------------------------------------
  P_transaction_cntr : process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if (current_req_state = S_IDLE) then
        transaction_cntr <= natural(conv_integer(tlp_in_length_in_dw));
      -- during write transaction
      elsif (addrCntrEn = '1') then
        transaction_cntr <= transaction_cntr - 1;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Synchronous Process : P_read_data_cntr
  -- Clock       : sys_clk
  -- Reset       : None
  -- Description : Count the return data
  -----------------------------------------------------------------------------
  P_read_data_cntr : process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if (current_req_state = S_IDLE) then
        read_data_cntr <= conv_integer(tlp_in_length_in_dw);
      --  read transaction
      elsif (mm_readdatavalid = '1'and isWrite = '0') then
        read_data_cntr <= read_data_cntr - 1;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Synchronous Process : P_mm_write
  -- Clock       : sys_clk
  -- Reset       : sys_reset_n
  -- Description : 
  -----------------------------------------------------------------------------
  P_mm_write : process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if (sys_reset_n = '0') then
        mm_write <= '0';
      else
        if (mm_wait = '0') then
          if (current_req_state = S_EXECUTE_WRITE) then
            mm_write <= '1';
          else
            mm_write <= '0';
          end if;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Synchronous Process : P_mm_addr
  -- Clock       : sys_clk
  -- Reset       : No reset
  -- Description : 
  -----------------------------------------------------------------------------
  P_mm_addr : process(sys_clk)
    variable phyAddr : std_logic_vector(31 downto 0);
  begin
    if rising_edge(sys_clk) then
      if (mm_wait = '0') then
        if (current_req_state = S_EXECUTE_WRITE or mm_read_en = '1') then
          -- fix address range
          phyAddr := conv_std_logic_vector(addrCntr, 32);
          mm_addr <= phyAddr(mm_addr'range);
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Synchronous Process : P_mm_beN
  -- Clock       : sys_clk
  -- Reset       : No reset
  -- Description : 
  -----------------------------------------------------------------------------
  P_mm_beN : process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if (mm_wait = '0') then
        -----------------------------------------------------------------------
        -- For a write transaction, ben are provided on the tlp bus
        -----------------------------------------------------------------------
        if (isWrite = '1') then
          if (input_data_ack = '1') then
            mm_beN <= not tlp_in_byte_en;
          end if;
        else
          -----------------------------------------------------------------------
          -- For a read transaction, ben are provided on the TLP bus for the
          -- first DWORD. For the next ones however, they must be calculated.
          -----------------------------------------------------------------------
          if (input_data_ack = '1') then
            -- First DWORD bytes enable
            mm_beN <= not tlp_in_byte_en;
          elsif (addrCntrEn = '1') then
            -- Last DWORD
            if (transaction_cntr = 2) then
              case last_byte_ptr is
                when "00" =>
                  mm_beN <= "1110";
                when "01" =>
                  mm_beN <= "1100";
                when "10" =>
                  mm_beN <= "1000";
                when "11" =>
                  mm_beN <= "0000";
                when others =>
                  null;
              end case;
            -- Other DWORDs
            else
              mm_beN <= "0000";
            end if;

          end if;

        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Synchronous Process : P_mm_writedata
  -- Clock       : sys_clk
  -- Reset       : No reset
  -- Description : 
  -----------------------------------------------------------------------------
  P_mm_writedata : process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if (mm_wait = '0') then
        if (current_req_state = S_EXECUTE_WRITE) then
          mm_writedata <= tlp_in_data;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Synchronous Process : P_last_addr
  -- Clock       : sys_clk
  -- Reset       : No reset
  -- Description : Calculate the last byte ptr in a DWORD
  -----------------------------------------------------------------------------
  P_last_addr : process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if (mm_wait = '0') then
        if (input_data_ack = '1') then
          last_byte_ptr <= tlp_in_address(1 downto 0) + tlp_in_byte_count(1 downto 0) -  '1';
        end if;
      end if;
    end if;
  end process;


  mm_read_en <= '1' when current_req_state = S_EXECUTE_READ and transaction_cntr > 0 and mm_read_int = '0' else
                '0';


  -----------------------------------------------------------------------------
  -- Synchronous Process : P_mm_read_int
  -- Clock       : sys_clk
  -- Reset       : sys_reset_n
  -- Description : 
  -----------------------------------------------------------------------------
  P_mm_read : process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if (sys_reset_n = '0') then
        mm_read_int <= '0';
      else
        if (mm_wait = '0') then
          if (mm_read_en = '1') then
            mm_read_int <= '1';
          else
            mm_read_int <= '0';
          end if;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Synchronous Process : P_mm_fifo_ovr
  -- Clock       : sys_clk
  -- Reset       : sys_reset_n
  -- Description : We flop overrun info because it will not stay on 
  -- FIFO interface. It is Reset by reset_str_mm_err bit in PCIE_STR_REG
  -- register.
  -----------------------------------------------------------------------------
  P_mm_fifo_ovr : process(sys_clk)
  begin
    if (sys_clk'event and sys_clk = '1') then
      if (sys_reset_n = '0' or RESET_STR_mm_ERR = '1') then
        mm_fifo_ovr <= '0';
      elsif (mm_fifo_wren = '1' and mm_fifo_full = '1') then
        mm_fifo_ovr <= '1';
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Synchronous Process : P_mm_fifo_und
  -- Clock       : sys_clk
  -- Reset       : (sys_reset_n = '0' or RESET_STR_mm_ERR = '1')
  -- Description : We flop underrun info because it will not stay on 
  -- FIFO interface. It is Reset by reset_str_mm_err bit in PCIE_STR_REG
  -- register.
  -----------------------------------------------------------------------------
  P_mm_fifo_und : process(sys_clk)
  begin
    if (sys_clk'event and sys_clk = '1') then
      if (sys_reset_n = '0' or RESET_STR_mm_ERR = '1') then
        mm_fifo_und <= '0';
      elsif (mm_fifo_rden = '1' and mm_fifo_empty = '1') then
        mm_fifo_und <= '1';
      end if;
    end if;
  end process;


  ---------------------------------------------------------------------------
  -- Inferred FIFO 512 Words x 36 Bits
  ---------------------------------------------------------------------------
  xmtxSCFIFO : mtxSCFIFO
    generic map
    (
      DATAWIDTH => 36,
      ADDRWIDTH => 9
      )
    port map
    (
      clk   => sys_clk,
      sclr  => sys_reset,
      wren  => mm_fifo_wren,
      data  => mm_fifo_din,
      rden  => mm_fifo_rden,
      q     => mm_fifo_dout,
      usedw => mm_fifo_usedw,
      empty => mm_fifo_empty,
      full  => mm_fifo_full
      );


  -- dans la version Artix-7, le fifo interne doit etre en reset pendant au moins 5 cycles.
  -- synthesis translate_off
  chkrstlengthassert : process
  begin
    wait until sys_reset = '1';  -- on debute un reset, ca doit durer 5 cycles
    for i in 1 to 5 loop
      wait until rising_edge(sys_clk);
      assert sys_reset = '1' report "PULSE DE RESET SUR FIFO INTERNE MOINS DE 5 CYCLES" severity failure;
    end loop;
    -- maintenant qu'on a attendu 5 cycles, il faut que le reset debarque avant qu'on retrigue
    wait until sys_reset = '0';
  end process;
  -- synthesis translate_on

  -- synthesis translate_off
  assert mm_fifo_full /= '1' report "REG FIFO FULL, JF check ca" severity failure;
  -- synthesis translate_on


  -----------------------------------------------------------------------------
  -- Asynchronous Process : P_current_req_state
  --
  -- Ce state machine recoit les information pour generer les TLP de completion. 
  -- Il recoit les donnes associees a la requete pour faire header, suivit du
  -- data a retourner il split les CPLD en block aligne sur 128 bytes, le read
  -- completion block. Ainsi notre TLP n'est jamais trop long par rapport a
  -- ce qui est programme dans le config space.
  -----------------------------------------------------------------------------
  P_next_compl_state : process(current_compl_state, tlp_out_grant, mm_fifo_empty, mm_fifo_usedw, dw_length_downcount, byte_count)
  begin

    case (current_compl_state) is
      -------------------------------------------------------------------------
      -- State: IDLE_COMP
      -------------------------------------------------------------------------
      when IDLE_COMP =>
        if (conv_integer(mm_fifo_usedw) > 1) then
          next_compl_state <= GET_LADDR_BCOUNT;
        else
          next_compl_state <= IDLE_COMP;
        end if;


      -------------------------------------------------------------------------
      -- State: GET_LADDR_BCOUNT
      -------------------------------------------------------------------------
      when GET_LADDR_BCOUNT =>
        next_compl_state <= GET_TRANSACTION_ID;


      -------------------------------------------------------------------------
      -- State: GET_TRANSACTION_ID
      -------------------------------------------------------------------------
      when GET_TRANSACTION_ID =>
        next_compl_state <= WAIT_DATA;


      -------------------------------------------------------------------------
      -- State: WAIT_DATA
      -------------------------------------------------------------------------
      when WAIT_DATA =>
        if (conv_integer(mm_fifo_usedw) >= dw_length_downcount) then
          next_compl_state <= PREFETCH;
        else
          next_compl_state <= WAIT_DATA;
        end if;

      -------------------------------------------------------------------------
      -- State: PREFETCH
      -------------------------------------------------------------------------
      when PREFETCH =>
        next_compl_state <= REQ_TX;


      -------------------------------------------------------------------------
      -- State: REQ_TX
      -------------------------------------------------------------------------
      when REQ_TX =>
        if (tlp_out_grant = '1') then
          next_compl_state <= TRANSFER_DATA;
        else
          next_compl_state <= REQ_TX;
        end if;


      -------------------------------------------------------------------------
      -- State: TRANSFER_DATA
      -------------------------------------------------------------------------
      when TRANSFER_DATA =>
        if conv_integer(dw_length_downcount) = 0 then
          next_compl_state <= NEXT_TLP;
        else
          next_compl_state <= TRANSFER_DATA;
        end if;


      -------------------------------------------------------------------------
      -- State: NEXT_TLP
      -------------------------------------------------------------------------
      when NEXT_TLP =>
        if conv_integer(byte_count) = 0 then
          next_compl_state <= IDLE_COMP;
        else
          next_compl_state <= WAIT_DATA;
        end if;


      -------------------------------------------------------------------------
      -- State: DEFAULT
      -------------------------------------------------------------------------
      when others =>
        next_compl_state <= IDLE_COMP;

    end case;
  end process;


  -----------------------------------------------------------------------------
  -- Synchronous Process : P_current_compl_state
  -- Clock       : sys_clk
  -- Reset       : sys_reset
  -----------------------------------------------------------------------------
  P_current_compl_state : process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if sys_reset = '1' then
        current_compl_state <= IDLE_COMP;
      else
        current_compl_state <= next_compl_state;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Synchronous Process : P_total_read_length_dw
  -- Clock       : sys_clk
  -- Reset       : sys_reset
  -- Description : 
  -----------------------------------------------------------------------------
  P_total_read_length_dw : process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if current_compl_state = GET_LADDR_BCOUNT then
        total_read_length_dw <= mm_fifo_dout(total_read_length_dw'range);  -- hardcode sur les LSB du fifo
      elsif current_compl_state = REQ_TX and next_compl_state = TRANSFER_DATA then
        total_read_length_dw <= total_read_length_dw - dw_length_downcount;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Synchronous Process : P_lower_address
  -- Clock       : sys_clk
  -- Reset       : sys_reset
  -- Description : 
  -----------------------------------------------------------------------------
  P_lower_address : process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if current_compl_state = GET_LADDR_BCOUNT then
        lower_address <= mm_fifo_dout(tlp_in_length_in_dw'length+lower_address'length-1 downto tlp_in_length_in_dw'length);  -- hardcode au dessus du tlp length.
      elsif current_compl_state = REQ_TX and next_compl_state = TRANSFER_DATA then
        lower_address <= (others => '0');  -- car maintenant on est forcement aligne sur un RCB
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Synchronous Process : P_byte_count
  -- Clock       : sys_clk
  -- Reset       : sys_reset
  -- Description : 
  -----------------------------------------------------------------------------
  P_byte_count : process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if current_compl_state = GET_LADDR_BCOUNT then
        byte_count <= mm_fifo_dout(tlp_in_length_in_dw'length+lower_address'length+byte_count'length-1 downto lower_address'length+tlp_in_length_in_dw'length);  -- hardcode au dessus du tlp length.
      elsif current_compl_state = REQ_TX and next_compl_state = TRANSFER_DATA then
        byte_count <= byte_count - length_in_byte;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Synchronous Process : P_transaction_id
  -- Clock       : sys_clk
  -- Reset       : 
  -- Description : on recupere les donnee a retourner avec le completion pour
  -- identifier la requete.
  -- x"1" & "000000" & tlp_in_attr & tlp_in_transaction_id when others; -- ou plutot S_STORE_TRANSACTION_ID
  -----------------------------------------------------------------------------
  P_transaction_id : process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if current_compl_state = GET_TRANSACTION_ID then
        transaction_id <= mm_fifo_dout(transaction_id'range);
        attrib         <= mm_fifo_dout(transaction_id'length+attrib'length-1 downto transaction_id'length);
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Synchronous Process : P_max_length_from_addr
  -- Clock       : sys_clk
  -- Reset       : 
  -- Description :  on determine la longeur du TLP en fonction de l'adresse
  -- ou on retourne le data. Si l'adresse n'est pas aligne sur un RCB de
  -- 128 bytes, ca limite la grandeur du TLP qu'on peut envoyer
  -----------------------------------------------------------------------------
  P_dw_length_downcount : process(sys_clk)
    variable max_length_from_addr : integer range 1 to 32;
  begin
    if rising_edge(sys_clk) then
      if (current_compl_state = GET_TRANSACTION_ID or current_compl_state = NEXT_TLP) then  -- une clock apres qu'on a les signaux source du fifo
        max_length_from_addr := 32 - conv_integer(lower_address(6 downto 2));

        if max_length_from_addr < conv_integer(total_read_length_dw) then
          -- on est limite par l'adresse
          dw_length_downcount <= conv_std_logic_vector(max_length_from_addr, dw_length_downcount'length);
        elsif conv_integer(total_read_length_dw) < 32 then
          -- on est limite par ce qui nous reste a transmettre
          dw_length_downcount <= total_read_length_dw(dw_length_downcount'range);
        else
          -- on est limite par le TLP
          dw_length_downcount <= conv_std_logic_vector(32, dw_length_downcount'length);
        end if;
      elsif current_compl_state = TRANSFER_DATA and tlp_out_dst_rdy_n = '0' then
        dw_length_downcount <= dw_length_downcount - '1';
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Synchronous Process : P_length_in_byte
  -- Clock       : sys_clk
  -- Reset       : 
  -- Description : Calcul equivalent, mais pour le byte count. Ce calcul est
  -- affecte par les bytes enables de debut et de fin de burst.Dans le cas ou
  -- le burst est totalement a l'interieur d'un RCB et que les bytes enables
  -- ne sont pas toute actives au debut et/ou a la fin du burst, alors il y
  -- a plusieurs possibilite de dw_length_downcount pour un meme calcul 
  -- de length_in_byte.  On ne peut donc pas determiner un signal a partir de l'autre
  -----------------------------------------------------------------------------
  P_length_in_byte : process(sys_clk)
    variable max_byte_count_from_addr : integer range 1 to 128;
  begin
    if rising_edge(sys_clk) then

      if current_compl_state = GET_TRANSACTION_ID or current_compl_state = NEXT_TLP then  -- une clock apres qu'on a les signaux source du fifo
        max_byte_count_from_addr := 128 - conv_integer(lower_address(6 downto 0));

        if max_byte_count_from_addr < conv_integer(byte_count) then
          -- on est limite par l'adresse
          length_in_byte <= conv_std_logic_vector(max_byte_count_from_addr, length_in_byte'length);
        elsif conv_integer(byte_count) < 128 then
          -- on est limite par ce qui nous reste a transmettre
          length_in_byte <= byte_count(length_in_byte'range);
        else
          -- on est limite par le TLP
          length_in_byte <= conv_std_logic_vector(128, length_in_byte'length);
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

  tlp_out_fmt_type <= "1001010";        -- toujours completion with data

  tlp_out_length_in_dw <= conv_std_logic_vector(conv_integer(dw_length_downcount), tlp_out_length_in_dw'length);  -- completer les MSB


  mm_fifo_rden <= '1' when (next_compl_state = PREFETCH) else
                  '1' when (next_compl_state = TRANSFER_DATA and tlp_out_dst_rdy_n = '0' and mm_fifo_empty = '0') else
                  '1' when (next_compl_state = GET_LADDR_BCOUNT or next_compl_state = GET_TRANSACTION_ID) else
                  '0';


  P_data_rdy_n : process (sys_clk) is
  begin
    if (rising_edge(sys_clk)) then
      if (sys_reset_n = '0') then
        data_rdy_n <= '1';
      else
        -- 
        if (mm_fifo_rden = '1') then
          data_rdy_n <= '0';
        elsif (data_ack = '1') then
          data_rdy_n <= '1';
        end if;
      end if;
    end if;
  end process;


  data_ack <= '1' when (data_rdy_n = '0' and tlp_out_dst_rdy_n = '0')else
              '0';


  tlp_in_accept_data <= input_data_ack;

  --tlp_out_src_rdy_n <= '0' when current_compl_state = TRANSFER_DATA else '1';
  tlp_out_src_rdy_n <= data_rdy_n;

  tlp_out_data <= mm_fifo_dout(31 downto 0);

  -- for completion transmit
  tlp_out_attr           <= attrib;
  tlp_out_transaction_id <= transaction_id;
  tlp_out_byte_count     <= byte_count;
  tlp_out_lower_address  <= lower_address;


  mm_read <= mm_read_int;

end functional;

