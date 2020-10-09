library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tlp_completion is
  port (
    ---------------------------------------------------------------------
    -- Reset and clock signals
    ---------------------------------------------------------------------
    sys_clk   : in std_logic;
    sys_reset : in std_logic;

    ---------------------------------------------------------------------      
    -- Completion request
    ---------------------------------------------------------------------
    compl_req             : in  std_logic;
    compl_pending         : out std_logic;
    compl_fmt_type        : in  std_logic_vector(6 downto 0);  -- fmt and type field from decoded packet 
    compl_lower_address   : in  std_logic_vector(6 downto 0);  -- 2 LSB a decoded from byte enables
    compl_length_in_dw    : in  std_logic_vector(10 downto 0);
    compl_length_in_bytes : in  std_logic_vector(12 downto 0);
    compl_attr            : in  std_logic_vector(1 downto 0);  -- relaxed ordering, no snoop
    compl_transaction_id  : in  std_logic_vector(23 downto 0);  -- bus, device, function, tag

    ---------------------------------------------------------------------      
    -- Read data
    ---------------------------------------------------------------------
    read_data_valid : in std_logic;
    read_last_data  : in std_logic;
    read_data       : in std_logic_vector(31 downto 0);

    ---------------------------------------------------------------------
    -- New transmit interface
    ---------------------------------------------------------------------
    -- Arbitration
    tlp_out_req_to_send : out std_logic;
    tlp_out_grant       : in  std_logic;

    -- Parameters for completion
    tlp_out_attr           : out std_logic_vector(1 downto 0);  -- relaxed ordering, no snoop
    tlp_out_transaction_id : out std_logic_vector(23 downto 0);  -- bus, device, function, tag
    tlp_out_byte_count     : out std_logic_vector(12 downto 0);  -- byte count tenant compte des byte enables
    tlp_out_lower_address  : out std_logic_vector(6 downto 0);
    tlp_out_fmt_type       : out std_logic_vector(6 downto 0);  -- fmt and type field 
    tlp_out_length_in_dw   : out std_logic_vector(9 downto 0);

    -- Data transmission
    tlp_out_src_rdy_n : out std_logic;
    tlp_out_dst_rdy_n : in  std_logic;
    tlp_out_data      : out std_logic_vector(31 downto 0)
    );
end entity;


architecture rtl of tlp_completion is


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


  -- state machine qui process les donnees a retourner aux requester (valeur en readback)
  type STATE_COMPLETION_TYPE is (
    S_IDLE, S_INIT,
    GET_LADDR_BCOUNT,
    GET_TRANSACTION_ID,
    WAIT_DATA,
    REQ_TX,
    PREFETCH,
    TRANSFER_DATA,
    NEXT_TLP,
    S_FILL_DUMMY_DATA,
    S_COMPLETION_ERROR,
    S_TLP_DONE, S_COMPL_DONE
    );

  -- Completion FSM
  signal state : STATE_COMPLETION_TYPE;

  -- Latch parameters
  signal compl_fmt_type_ff        : std_logic_vector(6 downto 0);
  signal compl_lower_address_ff   : std_logic_vector(6 downto 0);
  signal compl_length_in_dw_ff    : std_logic_vector(10 downto 0);
  signal compl_length_in_bytes_ff : std_logic_vector(12 downto 0);
  signal compl_attr_ff            : std_logic_vector(1 downto 0);
  signal compl_transaction_id_ff  : std_logic_vector(23 downto 0);
  signal compl_dw_cntr            : unsigned(10 downto 0);

  -- Completion FIFO
  signal fifo_rden         : std_logic;
  signal fifo_empty        : std_logic;
  signal fifo_full         : std_logic;
  signal fifo_wren         : std_logic;
  signal fifo_din          : std_logic_vector(31 downto 0);
  signal fifo_dout         : std_logic_vector(31 downto 0);
  signal fifo_usedw        : std_logic_vector(10 downto 0);
  signal fifo_und          : std_logic;
  signal fifo_ovr          : std_logic;
  signal tlp_dw_cntr       : natural;
  signal tlp_cntr          : natural;
  signal tlp_ack           : std_logic;
  signal tlp_lower_address : std_logic_vector(tlp_out_lower_address'range);
  signal tlp_src_rdy       : std_logic;
  signal bytes_count       : natural;
  signal first_dw_byte_cnt : natural;
  signal last_dw_byte_cnt  : natural;
  signal compl_byte_cntr   : natural;

  signal qw_packer_valid : std_logic;
  signal qw_packer       : std_logic_vector(63 downto 0);


begin


  -----------------------------------------------------------------------------
  -- Synchronous Process : P_qw_packer
  -- Clock       : sys_clk
  -- Description : Quad word packer
  -----------------------------------------------------------------------------
  -- P_qw_packer : process(sys_clk)
  -- begin
  --   if rising_edge(sys_clk) then
  --     if (read_data_valid = '1' and state = WAIT_DATA) then
  --       if (compl_dw_cntr(0) = '0') then
  --         qw_packer(31 downto 0)  <= read_data;
  --         qw_packer(63 downto 32) <= (others => '0');
  --       else
  --         qw_packer(63 downto 32) <= read_data;
  --       end if;
  --     end if;
  --   end if;
  -- end process;


  -----------------------------------------------------------------------------
  -- Synchronous Process : P_qw_packer
  -- Clock       : sys_clk
  -- Description : Quad word packer data valid flag.  Indicates that a full QW
  -- is ready to be loaded in the fifo
  -----------------------------------------------------------------------------
  -- P_qw_packer_valid : process(sys_clk)
  -- begin
  --   if rising_edge(sys_clk) then
  --     if (sys_reset = '1') then
  --       qw_packer_valid <= '0';
  --     else
  --       if (read_data_valid = '1' and state = WAIT_DATA) then
  --         if (read_last_data = '1' or compl_dw_cntr(0) = '1') then
  --           qw_packer_valid <= '1';
  --         end if;
  --       elsif(fifo_wren = '1') then
  --         qw_packer_valid <= '0';
  --       end if;
  --     end if;
  --   end if;
  -- end process;




  -----------------------------------------------------------------------------
  -- Synchronous Process : P_compl_dw_cntr
  -- Clock       : sys_clk
  -- Description : 
  -----------------------------------------------------------------------------
  -- P_compl_dw_cntr : process(sys_clk)
  -- begin
  --   if rising_edge(sys_clk) then
  --     if (sys_reset = '1') then
  --       compl_dw_cntr <= (others => '0');
  --     else
  --       if (state = S_INIT) then
  --         compl_dw_cntr <= (others => '0');
  --       elsif (read_data_valid = '1' and state = WAIT_DATA) then
  --         compl_dw_cntr <= compl_dw_cntr +1;
  --       end if;
  --     end if;
  --   end if;
  -- end process;





  -----------------------------------------------------------------------------
  -- Asynchronous Process : P_fifo_wren
  -- Description : 
  -----------------------------------------------------------------------------
  -- fifo_wren <= '1' when (state = WAIT_DATA and read_data_valid = '1') else
  --              '1' when (state = S_FILL_DUMMY_DATA) else
  --              '0';

  fifo_wren <= '1' when (read_data_valid = '1' and state = WAIT_DATA) else
               '1' when (state = S_FILL_DUMMY_DATA) else
               '0';

  fifo_din <= read_data when (state = WAIT_DATA) else
              X"DEADBEAF";

  ---------------------------------------------------------------------------
  -- Inferred FIFO 1024 Words x 36 Bits (4KB)
  ---------------------------------------------------------------------------
  xINPUT_DATA_FIFO : mtxSCFIFO
    generic map
    (
      DATAWIDTH => 32,
      ADDRWIDTH => 10
      )
    port map
    (
      clk   => sys_clk,
      sclr  => sys_reset,
      wren  => fifo_wren,
      data  => fifo_din,
      rden  => fifo_rden,
      q     => fifo_dout,
      usedw => fifo_usedw,
      empty => fifo_empty,
      full  => fifo_full
      );


  -----------------------------------------------------------------------------
  -- Synchronous Process : P_completion_input_parameters
  -- Clock       : sys_clk
  -- Reset       : Not required
  -- Description : Latch completion request parameters for internal use.
  -----------------------------------------------------------------------------
  P_completion_input_parameters : process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if (state = S_IDLE and compl_req = '1') then
        compl_fmt_type_ff        <= compl_fmt_type;
        compl_lower_address_ff   <= compl_lower_address;
        compl_length_in_dw_ff    <= compl_length_in_dw;
        compl_length_in_bytes_ff <= compl_length_in_bytes;
        compl_attr_ff            <= compl_attr;
        compl_transaction_id_ff  <= compl_transaction_id;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Synchronous Process : P_state
  -- Clock       : sys_clk
  -- Reset       : sys_reset
  -- Description : TLP Completion Finite State Machine
  -----------------------------------------------------------------------------
  P_state : process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if (sys_reset = '1') then
        state <= S_IDLE;

      else
        -------------------------------------------------------------------------
        -- 
        -------------------------------------------------------------------------
        case (state) is
          -------------------------------------------------------------------------
          -- State=>
          -----------------------------------------------------
          when S_IDLE =>
            if (compl_req = '1') then
              state <= S_INIT;
            else
              state <= S_IDLE;
            end if;

          -------------------------------------------------------------------------
          -- State : S_INIT
          -----------------------------------------------------
          when S_INIT =>
            state <= WAIT_DATA;


          ---------------------------------------------------------------------
          -- State: WAIT_DATA
          -------------------------------------------------------------------------
          when WAIT_DATA =>
            if (read_data_valid = '1' and read_last_data = '1') then
              if (unsigned(fifo_usedw) = unsigned(compl_length_in_dw_ff)-1) then
                state <= GET_LADDR_BCOUNT;
              else
                state <= S_FILL_DUMMY_DATA;
              end if;
            else
              state <= WAIT_DATA;
            end if;


          -------------------------------------------------------------------------
          -- State: GET_LADDR_BCOUNT
          -------------------------------------------------------------------------
          when GET_LADDR_BCOUNT =>
            state <= REQ_TX;


          -------------------------------------------------------------------------
          -- State: REQ_TX
          -------------------------------------------------------------------------
          when REQ_TX =>
            if (tlp_out_grant = '1') then
              state <= TRANSFER_DATA;
            else
              state <= REQ_TX;
            end if;


          -------------------------------------------------------------------------
          -- State: TRANSFER_DATA
          -------------------------------------------------------------------------
          when TRANSFER_DATA =>
            -- When we transfer the last DW of the current TLP
            if (tlp_dw_cntr = 1 and tlp_ack = '1') then
              if (compl_byte_cntr <= 4) then
                -- If the complete read request is transfered
                state <= S_COMPL_DONE;
              else
                -- If the current TLP is transfered, more to come
                -- for the current read request transaction
                state <= S_TLP_DONE;
              end if;
            else
              state <= TRANSFER_DATA;
            end if;


          -------------------------------------------------------------------------
          -- State: S_FILL_DUMMY_DATA
          -------------------------------------------------------------------------
          when S_FILL_DUMMY_DATA =>
            if ((unsigned(fifo_usedw) = unsigned(compl_length_in_dw_ff)-1) and (fifo_wren='1')) then
              state <= S_COMPLETION_ERROR;
            else
              state <= S_FILL_DUMMY_DATA;
            end if;


          -------------------------------------------------------------------------
          -- State: S_COMPLETION_ERROR
          -------------------------------------------------------------------------
          when S_COMPLETION_ERROR =>
            -- Transfer the bad data anyway in order to avoid a deadlock in the
            -- PC
            state <= GET_LADDR_BCOUNT;


          -------------------------------------------------------------------------
          -- State: S_DONE
          -------------------------------------------------------------------------
          when S_TLP_DONE =>
            -- Jump to the begining of the next TLP transfer
            state <= GET_LADDR_BCOUNT;

          -------------------------------------------------------------------------
          -- State: S_DONE
          -------------------------------------------------------------------------
          when S_COMPL_DONE =>
            -- Read request completed. return to the parking state
            state <= S_IDLE;


          -------------------------------------------------------------------------
          -- State: DEFAULT
          -------------------------------------------------------------------------
          when others =>
            state <= S_IDLE;
        end case;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Synchronous Process : P_compl_pending
  -- Clock       : sys_clk
  -- Reset       : sys_reset
  -- Description : 
  -----------------------------------------------------------------------------
  P_compl_pending : process(sys_clk)
  begin
    if (rising_edge(sys_clk)) then
      if (sys_reset = '1') then
        compl_pending <= '0';
      else
        if (state = S_IDLE and compl_req = '1') then
          compl_pending <= '1';
        elsif (state = S_COMPL_DONE) then
          compl_pending <= '0';
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Synchronous Process : P_tlp_dw_cntr
  -- Clock       : sys_clk
  -- Reset       : sys_reset
  -- Description : 
  -----------------------------------------------------------------------------
  P_tlp_dw_cntr : process(sys_clk)
  begin
    if (rising_edge(sys_clk)) then
      if (state = GET_LADDR_BCOUNT)then
        if (compl_dw_cntr > 15) then
          tlp_dw_cntr <= 16;
        else
          tlp_dw_cntr <= to_integer(unsigned(fifo_usedw));
        end if;
      elsif (state = TRANSFER_DATA and tlp_ack = '1') then
        tlp_dw_cntr <= tlp_dw_cntr - 1;
      end if;
    end if;
  end process;


  tlp_ack <= '1' when (tlp_src_rdy = '1' and tlp_out_dst_rdy_n = '0') else
             '0';




  -----------------------------------------------------------------------------
  -- Synchronous Process : P_compl_byte_cntr
  -- Clock       : sys_clk
  -- Reset       : sys_reset
  -- Description : Completion Byte Counter.
  --               Calculate the number of bytes remaining to be transfered to
  --               the host in the current read transaction. This value is
  --               is independant of the number of TLP transmitted for the
  --               current read transaction.
  -----------------------------------------------------------------------------
  P_compl_byte_cntr : process(sys_clk)
  begin
    if (rising_edge(sys_clk)) then
      if (sys_reset = '1') then
        compl_byte_cntr <= 0;
      else
        if (state = S_INIT)then
          compl_byte_cntr <= to_integer(unsigned(compl_length_in_bytes_ff));
        elsif (state = TRANSFER_DATA) then
          if (tlp_ack = '1') then
            compl_byte_cntr <= compl_byte_cntr - bytes_count;
          end if;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- The number of bytes valid in the current DWORD transfered.
  --
  -- 3 Cases: 1) The First DW of the TLP transfered, including special case of 4
  --             bytes or less.
  --          2) Any DW in the middle of the TLP transfer
  --          3) The last DW of the TLP transfered
  -----------------------------------------------------------------------------
  bytes_count <= first_dw_byte_cnt when (compl_byte_cntr = to_integer(unsigned(compl_length_in_bytes_ff))) else
                 4 when (compl_byte_cntr > 3) else
                 last_dw_byte_cnt;


  -----------------------------------------------------------------------------
  -- Synchronous Process : P_first_dw_byte_cnt
  -- Clock       : sys_clk
  -- Reset       : sys_reset
  -- Description : Calculate the number of valid bytes in the first DWORD to 
  --               be transmited . Take into account the alignment due to the 
  --               start address not aigned on DW boundaries.
  -----------------------------------------------------------------------------
  P_first_dw_byte_cnt : process(sys_clk)
    variable length_in_bytes : natural;
  begin
    if (rising_edge(sys_clk)) then
      if (state = S_INIT)then
        length_in_bytes     := natural (to_integer(unsigned(compl_length_in_bytes_ff)));
        if (length_in_bytes <= 4) then
          -- Special case when byte count is only 1DW (1,2,3 or 4 Bytes)
          -- We pass the byte count directly.
          first_dw_byte_cnt <= length_in_bytes;
        else
          case compl_lower_address(1 downto 0) is
            when "00"   => first_dw_byte_cnt <= 4;
            when "01"   => first_dw_byte_cnt <= 3;
            when "10"   => first_dw_byte_cnt <= 2;
            when "11"   => first_dw_byte_cnt <= 1;
            when others => null;
          end case;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Synchronous Process : P_last_dw_byte_cnt
  -- Clock       : sys_clk
  -- Reset       : sys_reset
  -- Description : Calculate the number of valid bytes in the first DWORD to 
  --               be transmited . Take into account the alignment due to the 
  --               start address not aigned on DW boundaries and the burst size
  --               requested.
  -----------------------------------------------------------------------------
  P_last_dw_byte_cnt : process(sys_clk)
    variable compl_high_address : unsigned(1 downto 0);
  begin
    if (rising_edge(sys_clk)) then
      if (state = S_INIT)then
        compl_high_address := unsigned(compl_lower_address(1 downto 0)) + unsigned(compl_length_in_bytes_ff(1 downto 0));
        case compl_high_address is
          when "00"   => last_dw_byte_cnt <= 4;
          when "01"   => last_dw_byte_cnt <= 3;
          when "10"   => last_dw_byte_cnt <= 2;
          when "11"   => last_dw_byte_cnt <= 1;
          when others => null;
        end case;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Synchronous Process : P_tlp_cntr
  -- Clock       : sys_clk
  -- Reset       : sys_reset
  -- Description : Count the number of TLP Packet sent for the current
  --               read request
  -----------------------------------------------------------------------------
  P_tlp_cntr : process(sys_clk)
  begin
    if (rising_edge(sys_clk)) then
      if (state = S_INIT)then
        tlp_cntr <= 0;
      elsif (state = S_TLP_DONE) then
        tlp_cntr <= tlp_cntr+1;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Synchronous Process : P_tlp_lower_address
  -- Clock       : sys_clk
  -- Reset       : sys_reset
  -- Description : 
  -----------------------------------------------------------------------------
  P_tlp_lower_address : process (sys_clk) is
  begin
    if (rising_edge(sys_clk)) then
      if (state = S_INIT) then
        -- For the first TLP we transmit back the received lower_address
        -- from the transaction request (compl_lower_address_ff+
        tlp_lower_address <= compl_lower_address_ff;

      elsif (state = S_TLP_DONE) then
        -- For next TLPs data is always aligned to address 0x0 of a TLP
        tlp_lower_address <= (others => '0');
      end if;
    end if;
  end process;



  -----------------------------------------------------------------------------
  -- Synchronous Process : P_fifo_und
  -- Clock       : sys_clk
  -- Reset       : (sys_reset_n = '0' or RESET_STR_ERR = '1')
  -- Description : We flop underrun info because it will not stay on 
  -- FIFO interface. It is Reset by reset_str_err bit in PCIE_STR_REG
  -- register.
  -----------------------------------------------------------------------------
  P_fifo_und : process(sys_clk)
  begin
    if (rising_edge(sys_clk)) then
      if (sys_reset = '1') then
        fifo_und <= '0';
      elsif (fifo_rden = '1' and fifo_empty = '1') then
        fifo_und <= '1';
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Synchronous Process : P_fifo_ovr
  -- Clock       : sys_clk
  -- Reset       : sys_reset_n
  -- Description : We flop overrun info because it will not stay on 
  -- FIFO interface. It is Reset by reset_str_err bit in PCIE_STR_REG
  -- register.
  -----------------------------------------------------------------------------
  P_fifo_ovr : process(sys_clk)
  begin
    if (rising_edge(sys_clk)) then
      if (sys_reset = '1') then
        fifo_ovr <= '0';
      elsif (fifo_wren = '1' and fifo_full = '1') then
        fifo_ovr <= '1';
      end if;
    end if;
  end process;


  fifo_rden <= '1' when (state = REQ_TX and tlp_out_grant = '1' and fifo_empty = '0') else
               '1' when (state = TRANSFER_DATA and tlp_out_dst_rdy_n = '0' and fifo_empty = '0') else
               '0';


  -----------------------------------------------------------------------------
  -- Synchronous Process : P_tlp_src_rdy
  -- Clock       : sys_clk
  -- Reset       : sys_reset
  -- Description : 
  -----------------------------------------------------------------------------
  P_tlp_src_rdy : process(sys_clk) is
  begin
    if (rising_edge (sys_clk)) then
      if (sys_reset = '1' or state = S_IDLE) then
        tlp_src_rdy <= '0';
      else
        if (fifo_rden = '1') then
          tlp_src_rdy <= '1';
        elsif(tlp_ack = '1')then
          tlp_src_rdy <= '0';
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Synchronous Process : P_tlp_out_req_to_send
  -- Clock       : sys_clk
  -- Reset       : sys_reset
  -- Description : 
  -----------------------------------------------------------------------------
  P_tlp_out_req_to_send : process(sys_clk) is
  begin
    if (rising_edge (sys_clk)) then
      if (sys_reset = '1' or state = S_IDLE) then
        tlp_out_req_to_send <= '0';
      else
        if (state = REQ_TX) then
          tlp_out_req_to_send <= '1';
        elsif (tlp_dw_cntr = 1 and tlp_ack = '1') then
          tlp_out_req_to_send <= '0';
        end if;
      end if;
    end if;
  end process;


  tlp_out_fmt_type     <= "1001010";    -- toujours completion with data
  tlp_out_length_in_dw <= std_logic_vector(to_unsigned(tlp_dw_cntr, tlp_out_length_in_dw'length));

  tlp_out_src_rdy_n <= not tlp_src_rdy;

  tlp_out_data <= fifo_dout;

  -- for completion transmit
  tlp_out_attr           <= compl_attr_ff;
  tlp_out_transaction_id <= compl_transaction_id_ff;
  tlp_out_byte_count     <= std_logic_vector(to_unsigned(compl_byte_cntr, tlp_out_byte_count'length));
  tlp_out_lower_address  <= tlp_lower_address;

end rtl;
