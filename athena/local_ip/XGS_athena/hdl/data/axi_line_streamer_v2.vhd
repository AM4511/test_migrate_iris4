-------------------------------------------------------------------------------
-- MODULE      : axi_line_streamer
--
-- DESCRIPTION : Stream recombined lines extracted from the XGS sensor
--
-- REFERENCES  :
--                 See Xilinx UG934,  
--                 See Xilinx UG1037, chapter 4,Video IP: AXI Feature Adoption
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity axi_line_streamer_v2 is
  generic (
    LANE_PER_PHY              : integer := 3;  -- Physical lane
    MUX_RATIO                 : integer := 4;
    LINE_BUFFER_PTR_WIDTH     : integer := 1;
    LINE_BUFFER_DATA_WIDTH    : integer := 64;
    LINE_BUFFER_ADDRESS_WIDTH : integer := 10
    );
  port (
    ---------------------------------------------------------------------------
    -- System clock interface
    ---------------------------------------------------------------------------
    sclk       : in std_logic;
    sclk_reset : in std_logic;

    ---------------------------------------------------------------------------
    -- Control interface
    ---------------------------------------------------------------------------
    streamer_en     : in  std_logic;
    streamer_busy   : out std_logic;
    transfert_done  : out std_logic;
    init_frame      : in  std_logic;
    nb_lane_enabled : in  std_logic_vector(2 downto 0);

    ---------------------------------------------------------------------------
    -- Register interface (ROI parameters)
    ---------------------------------------------------------------------------
    x_row_start : in std_logic_vector(12 downto 0);
    x_row_stop  : in std_logic_vector(12 downto 0);
    y_row_start : in std_logic_vector(11 downto 0);
    y_row_stop  : in std_logic_vector(11 downto 0);

    ---------------------------------------------------------------------------
    -- Lane_decode I/F
    ---------------------------------------------------------------------------
    sclk_buffer_lane_id  : out std_logic_vector(1 downto 0);
    sclk_buffer_id       : out std_logic_vector(1 downto 0);
    sclk_buffer_mux_id   : out std_logic_vector(1 downto 0);
    sclk_buffer_word_ptr : out std_logic_vector(5 downto 0);
    sclk_buffer_read_en  : out std_logic;

    -- Even lanes
    sclk_buffer_empty_even : in std_logic_vector(LANE_PER_PHY - 1 downto 0);
    sclk_buffer_sync_even  : in std_logic_vector(3 downto 0);
    sclk_buffer_data_even  : in std_logic_vector(29 downto 0);

    -- Odd lanes
    sclk_buffer_empty_odd : in std_logic_vector(LANE_PER_PHY - 1 downto 0);
    sclk_buffer_sync_odd  : in std_logic_vector(3 downto 0);
    sclk_buffer_data_odd  : in std_logic_vector(29 downto 0);

    ---------------------------------------------------------------------------
    -- AXI Master stream interface
    ---------------------------------------------------------------------------
    sclk_tready : in  std_logic;
    sclk_tvalid : out std_logic;
    sclk_tuser  : out std_logic_vector(3 downto 0);
    sclk_tlast  : out std_logic;
    sclk_tdata  : out std_logic_vector(79 downto 0)
    );
end axi_line_streamer_v2;


architecture rtl of axi_line_streamer_v2 is

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

  attribute mark_debug : string;
  attribute keep       : string;

  type FSM_TYPE is (S_IDLE,
                    S_SOF,
                    S_WAIT_SOL,
                    S_SOL,
                    S_LOAD_BURST_CNTR,
                    S_DATA_PHASE,
                    S_LAST_DATA,
                    S_DONE,
                    S_EOL,
                    S_EOF
                    );

  constant DATAWIDTH : integer := 80;
  constant ADDRWIDTH : integer := 10;
  constant MAX_BURST : unsigned(sclk_buffer_word_ptr'range):= "111001";  --0x39

  signal sclk_fifo_write_en   : std_logic;
  signal sclk_fifo_write_data : std_logic_vector(DATAWIDTH - 1 downto 0);
  signal sclk_fifo_read_en    : std_logic;
  signal sclk_fifo_read_data  : std_logic_vector(DATAWIDTH - 1 downto 0);
  signal sclk_fifo_usedw      : std_logic_vector(ADDRWIDTH downto 0);
  signal sclk_fifo_empty      : std_logic;
  signal sclk_fifo_full       : std_logic;

  signal m_wait          : std_logic;
  signal state           : FSM_TYPE;
  signal burst_length    : integer;
  --signal burst_cntr      : integer               := 0;
  signal buffer_address  : integer               := 0;
  signal read_en         : std_logic;
  signal read_data_valid : std_logic;
  signal first_row       : std_logic;
  signal last_row        : std_logic;
  --signal buffer_read_ptr : unsigned(LINE_BUFFER_PTR_WIDTH-1 downto 0);
  signal start_transfer  : std_logic;
  signal sclk_tvalid_int : std_logic;
  signal pixel_ptr       : integer range 0 to 16 := 0;

  signal sclk_data_packer : std_logic_vector(119 downto 0);
  signal sclk_load_data   : std_logic;
  signal last_data        : std_logic;

  signal buffer_id_cntr    : unsigned(sclk_buffer_id'range);
  signal buffer_id_cntr_en : std_logic;
  signal lane_id_cntr      : integer range 0 to LANE_PER_PHY-1;
  signal lane_id_cntr_en   : std_logic;
  signal word_cntr         : unsigned(sclk_buffer_word_ptr'range);
  signal word_cntr_en      : std_logic;
  signal word_cntr_init    : std_logic;
  signal mux_id_cntr : unsigned(1 downto 0);
  signal mux_id_cntr_en : std_logic;
  signal mux_id_cntr_init : std_logic;
  
  -----------------------------------------------------------------------------
  -- Debug attributes 
  -----------------------------------------------------------------------------
  attribute mark_debug of m_wait : signal is "true";


begin


  m_wait <= '1' when (sclk_tready = '0' and read_data_valid = '1' and sclk_tvalid_int = '1') else
            '0';


  read_en <= '1' when (state = S_DATA_PHASE) else
             '0';



  -----------------------------------------------------------------------------
  -- Process     : P_state
  -- Description : Streamer main FSM. Control the stream transfer.
  -----------------------------------------------------------------------------
  P_state : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1' or streamer_en = '0') then
        state <= S_IDLE;

      else
        case state is
          ---------------------------------------------------------------------
          -- S_IDLE : Parking state
          ---------------------------------------------------------------------
          when S_IDLE =>
            if (init_frame = '1') then
              state <= S_SOF;
            else
              state <= S_IDLE;
            end if;

          ---------------------------------------------------------------------
          -- S_SOF : Indicate the SOF
          ---------------------------------------------------------------------
          when S_SOF =>
            state <= S_WAIT_SOL;

          ---------------------------------------------------------------------
          -- S_WAIT_SOL : Indicate the SOF
          ---------------------------------------------------------------------
          when S_WAIT_SOL =>
            -- When 6 lanes enabled and data vailable on the 6 lanes
            if (nb_lane_enabled = "110" and
                sclk_buffer_empty_even(2 downto 0) = "000" and
                sclk_buffer_empty_odd(2 downto 0) = "000"
                ) then
              state <= S_SOL;
            -- When 4 lanes enabled and data vailable on the 4 lanes
            elsif (nb_lane_enabled = "100" and
                   sclk_buffer_empty_even(1 downto 0) = "00" and
                   sclk_buffer_empty_odd(1 downto 0) = "00"
                   ) then
              state <= S_SOL;
            else
              state <= S_WAIT_SOL;
            end if;

          ---------------------------------------------------------------------
          -- S_SOL : Indicate the SOL
          ---------------------------------------------------------------------
          when S_SOL =>
            state <= S_LOAD_BURST_CNTR;

          ---------------------------------------------------------------------
          -- S_LOAD_BURST_CNTR : Load the burst counter
          ---------------------------------------------------------------------
          when S_LOAD_BURST_CNTR =>
            state <= S_DATA_PHASE;

          ---------------------------------------------------------------------
          -- S_DATA_PHASE : This phase indicates the data transfer from the
          --                buffer 
          ---------------------------------------------------------------------
          when S_DATA_PHASE =>
            if (last_data='1') then
              state <= S_LAST_DATA;
            else
              state <= S_DATA_PHASE;
            end if;
        

          ---------------------------------------------------------------------
          -- S_LAST_DATA : Indicates the last data beat of the current data
          --               phase
          ---------------------------------------------------------------------
          when S_LAST_DATA =>
            if (last_row = '1') then
              state <= S_EOF;
            else
              state <= S_EOL;
            end if;

          ---------------------------------------------------------------------
          -- S_EOL : End Of Line state
          ---------------------------------------------------------------------
          when S_EOL =>
            state <= S_WAIT_SOL;

          ---------------------------------------------------------------------
          -- S_EOF : End Of frame state
          ---------------------------------------------------------------------
          when S_EOF =>
            state <= S_DONE;

          ---------------------------------------------------------------------
          -- S_DONE
          ---------------------------------------------------------------------
          when S_DONE =>
            state <= S_IDLE;

          ---------------------------------------------------------------------
          -- 
          ---------------------------------------------------------------------
          when others =>
            null;
        end case;
      end if;
    end if;
  end process P_state;

  sclk_buffer_read_en <= '1' when (state = S_DATA_PHASE) else
                         '0';



  buffer_id_cntr_en <= '1' when (false) else
                       '0';

  
  -----------------------------------------------------------------------------
  -- Process     : P_buffer_id_cntr
  -- Description : 
  -----------------------------------------------------------------------------
  P_buffer_id_cntr : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        buffer_id_cntr <= (others => '0');
      else
        if (state = S_SOF) then
          buffer_id_cntr <= (others => '0');
        elsif (buffer_id_cntr_en = '1') then
          buffer_id_cntr <= buffer_id_cntr + 1;
        end if;
      end if;
    end if;
  end process;

  
  sclk_buffer_id <= std_logic_vector(buffer_id_cntr);

  
  -----------------------------------------------------------------------------
  -- Process     : P_word_cntr
  -- Description : 
  -----------------------------------------------------------------------------
  P_word_cntr : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        word_cntr <= (others => '0');
      else
        if (word_cntr_init = '1') then
          word_cntr <= (others => '0');
        elsif (word_cntr_en = '1') then
          -- Wrap around
          if (word_cntr = MAX_BURST) then
            word_cntr <= (others => '0');
          else
            word_cntr <= word_cntr+1;
          end if;
        end if;
      end if;
    end if;
  end process;

  word_cntr_en <= '1' when (state = S_DATA_PHASE) else
                  '0';

  word_cntr_init <= '1' when (state = S_SOF) else
                    '0';

  sclk_buffer_word_ptr <= std_logic_vector(word_cntr);

  -----------------------------------------------------------------------------
  -- Process     : P_sclk_buffer_mux_id
  -- Description : 
  -----------------------------------------------------------------------------
  P_sclk_buffer_mux_id : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        mux_id_cntr <= (others => '0');
      else
        if (state = S_SOF) then
          mux_id_cntr <= (others => '0');
        elsif (mux_id_cntr_en = '1') then
          mux_id_cntr <= mux_id_cntr + 1;
        end if;
      end if;
    end if;
  end process;
  
  mux_id_cntr_en<= '1' when (word_cntr = MAX_BURST and word_cntr_en = '1') else
                   '0';
  
  sclk_buffer_mux_id<=std_logic_vector(mux_id_cntr);

  
 
  -----------------------------------------------------------------------------
  -- Process     : P_lane_id_cntr
  -- Description : 
  -----------------------------------------------------------------------------
  P_lane_id_cntr : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        lane_id_cntr <= 0;
      else
        if (state = S_SOF) then
          lane_id_cntr <= 0;
        elsif (lane_id_cntr_en = '1') then
          lane_id_cntr <= lane_id_cntr + 1;

        end if;
      end if;
    end if;
  end process;

   lane_id_cntr_en <= '1' when (mux_id_cntr = "11" and mux_id_cntr_en = '1') else
                      '0';


  last_data <= '1' when (lane_id_cntr = LANE_PER_PHY and lane_id_cntr_en = '1') else
               '0';
  
  sclk_buffer_lane_id<= std_logic_vector(to_unsigned(lane_id_cntr, sclk_buffer_lane_id'length));
  
  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  -- P_start_transfer : process (sclk) is
  -- begin
  --   if (rising_edge(sclk)) then
  --     if (sclk_reset = '1') then
  --       start_transfer <= '0';
  --     else
  --       -----------------------------------------------------------------------
  --       -- In the init state we activate the required lane_packers
  --       -----------------------------------------------------------------------
  --       if (state = S_WAIT_SOL) then

  --         for i in 0 to LANE_PER_PHY-1 loop
  --           if (i = lane_id_cntr and sclk_buffer_empty_even(i) = '1' and sclk_buffer_empty_odd(i) = '1') then
  --             start_transfer <= '1';
  --           else
  --             start_transfer <= '0';
  --           end if;
  --         end loop;  -- i

  --       else
  --         start_transfer <= '0';
  --       end if;
  --     end if;
  --   end if;
  -- end process;


  -----------------------------------------------------------------------------
  -- Process     : P_sclk_data_packer
  -- Description : 
  -----------------------------------------------------------------------------
  P_sclk_data_packer : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_load_data = '1') then
        ---------------------------------------------------------------------
        -- Normal packing
        ---------------------------------------------------------------------
        case pixel_ptr is
          when 0 =>
            sclk_data_packer(9 downto 0)   <= sclk_buffer_data_even(9 downto 0);
            sclk_data_packer(19 downto 10) <= sclk_buffer_data_odd(9 downto 0);

            sclk_data_packer(29 downto 20) <= sclk_buffer_data_even(19 downto 10);
            sclk_data_packer(39 downto 30) <= sclk_buffer_data_odd(19 downto 10);

            sclk_data_packer(49 downto 40) <= sclk_buffer_data_even(29 downto 20);
            sclk_data_packer(59 downto 50) <= sclk_buffer_data_odd(29 downto 20);

          when 2 =>
            sclk_data_packer(29 downto 20) <= sclk_buffer_data_even(9 downto 0);
            sclk_data_packer(39 downto 30) <= sclk_buffer_data_odd(9 downto 0);

            sclk_data_packer(49 downto 40) <= sclk_buffer_data_even(19 downto 10);
            sclk_data_packer(59 downto 50) <= sclk_buffer_data_odd(19 downto 10);

            sclk_data_packer(69 downto 60) <= sclk_buffer_data_even(29 downto 20);
            sclk_data_packer(79 downto 70) <= sclk_buffer_data_odd(29 downto 20);

          when 4 =>
            sclk_data_packer(49 downto 40) <= sclk_buffer_data_even(9 downto 0);
            sclk_data_packer(59 downto 50) <= sclk_buffer_data_odd(9 downto 0);

            sclk_data_packer(69 downto 60) <= sclk_buffer_data_even(19 downto 10);
            sclk_data_packer(79 downto 70) <= sclk_buffer_data_odd(19 downto 10);

            sclk_data_packer(89 downto 80) <= sclk_buffer_data_even(29 downto 20);
            sclk_data_packer(99 downto 90) <= sclk_buffer_data_odd(29 downto 20);

          when 6 =>
            sclk_data_packer(69 downto 60) <= sclk_buffer_data_even(9 downto 0);
            sclk_data_packer(79 downto 70) <= sclk_buffer_data_odd(9 downto 0);

            sclk_data_packer(89 downto 80) <= sclk_buffer_data_even(19 downto 10);
            sclk_data_packer(99 downto 90) <= sclk_buffer_data_odd(19 downto 10);

            sclk_data_packer(109 downto 100) <= sclk_buffer_data_even(29 downto 20);
            sclk_data_packer(119 downto 110) <= sclk_buffer_data_odd(29 downto 20);

          when others =>
            null;
        end case;
      end if;
    end if;
  end process;


  sclk_fifo_write_en <= '1' when (sclk_load_data = '1' and pixel_ptr > 4) else
                        '0';
  sclk_fifo_write_data <= sclk_data_packer(79 downto 0);

  xoutput_fifo : mtxSCFIFO
    generic map (
      DATAWIDTH => DATAWIDTH,
      ADDRWIDTH => ADDRWIDTH
      )
    port map (
      clk   => sclk,
      sclr  => sclk_reset,
      wren  => sclk_fifo_write_en,
      data  => sclk_fifo_write_data,
      rden  => sclk_fifo_read_en,
      q     => sclk_fifo_read_data,
      usedw => sclk_fifo_usedw,
      empty => sclk_fifo_empty,
      full  => sclk_fifo_full
      );


  -----------------------------------------------------------------------------
  -- Process     : P_first_row
  -- Description : 
  -----------------------------------------------------------------------------
  P_first_row : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        first_row <= '0';
      else
        if (init_frame = '1') then
          first_row <= '1';
        elsif (state = S_EOL) then
          first_row <= '0';
        end if;
      end if;
    end if;
  end process;


  -- last_row <= '1' when (line_buffer_row_id = y_row_stop and state /= S_IDLE) else
  --             '0';



  -----------------------------------------------------------------------------
  -- Process     : P_burst_length
  -- Description : 
  -----------------------------------------------------------------------------
  -- P_burst_length : process (sclk) is
  --   variable xstart  : integer;
  --   variable xstop   : integer;
  --   variable xlength : integer;
  -- begin
  --   if (rising_edge(sclk)) then
  --     if (sclk_reset = '1') then
  --       burst_length <= 0;
  --     else
  --       xstart  := to_integer(unsigned(x_row_start));
  --       xstop   := to_integer(unsigned(x_row_stop));
  --       xlength := xstop - xstart + 1;
  --       if (state = S_LOAD_BURST_CNTR) then
  --         burst_length <= (xlength/4);
  --       end if;
  --     end if;
  --   end if;
  -- end process;


  -----------------------------------------------------------------------------
  -- Process     : P_buffer_read_ptr
  -- Description : Units in QWORD (2Bytes per pix / 8 bytes per QWORDS)
  -----------------------------------------------------------------------------
  -- P_buffer_read_ptr : process (sclk) is
  -- begin
  --   if (rising_edge(sclk)) then
  --     if (sclk_reset = '1') then
  --       buffer_read_ptr <= (others => '0');
  --     else
  --       if (init_frame = '1') then
  --         buffer_read_ptr <= (others => '0');
  --       elsif (state = S_EOL) then
  --         buffer_read_ptr <= buffer_read_ptr+1;
  --       end if;
  --     end if;
  --   end if;
  -- end process;


--  line_buffer_ptr <= std_logic_vector(buffer_read_ptr);



  -----------------------------------------------------------------------------
  -- Process     : P_line_buffer_clr
  -- Description : Clear the line buffer ready flag from  line_buffer module
  -----------------------------------------------------------------------------
  -- P_line_buffer_clr : process (sclk) is
  -- begin
  --   if (rising_edge(sclk)) then
  --     if (sclk_reset = '1') then
  --       line_buffer_clr <= '0';
  --     else
  --       if (state = S_LAST_DATA) then
  --         line_buffer_clr <= '1';
  --       else
  --         line_buffer_clr <= '0';
  --       end if;
  --     end if;
  --   end if;
  -- end process;


  -----------------------------------------------------------------------------
  -- Process     : P_burst_cntr
  -- Description : 
  -----------------------------------------------------------------------------
  -- P_burst_cntr : process (sclk) is
  -- begin
  --   if (rising_edge(sclk)) then
  --     if (sclk_reset = '1') then
  --       burst_cntr <= 0;
  --     else
  --       if (state = S_LOAD_BURST_CNTR) then
  --         burst_cntr <= 0;
  --       elsif (state = S_DATA_PHASE and read_en = '1') then
  --         burst_cntr <= burst_cntr+1;
  --       end if;
  --     end if;
  --   end if;
  -- end process;

  -----------------------------------------------------------------------------
  -- Process     : P_buffer_address
  -- Description : 
  -----------------------------------------------------------------------------
  P_line_buffer_address : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        buffer_address <= 0;
      else
        if (state = S_LOAD_BURST_CNTR) then
          buffer_address <= to_integer(unsigned(x_row_start))*2/8;
        elsif (state = S_DATA_PHASE and read_en = '1') then
          buffer_address <= buffer_address+1;
        end if;
      end if;
    end if;
  end process;

  -- line_buffer_address <= std_logic_vector(to_unsigned(buffer_address, line_buffer_address 'length));
  -- line_buffer_read    <= read_en;


  -----------------------------------------------------------------------------
  -- Process     : P_sclk_tuser
  -- Description : In the AXI stream video protocol TUSER is used as the SOF
  --               sync marker.
  --
  --               USER[3 2 1 0]  SYNC
  --               ===================
  --                    0 0 0 1   SOF
  --                    0 0 1 0   EOF
  --                    0 1 0 0   SOL
  --                    1 0 0 0   EOL
  --                    1 1 0 0   HEADER
  --                    others    RESERVED
  -----------------------------------------------------------------------------
  P_sclk_tuser : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        sclk_tuser <= "0000";
      else
        if (m_wait = '0') then
          ---------------------------------------------------------------------
          -- Start of frame
          ---------------------------------------------------------------------
          --if (state = S_DATA_PHASE and burst_cntr = 1) then
          if (true) then
            -- Start of frame
            if (first_row = '1') then
              sclk_tuser <= "0001";
            -- Start of line
            else
              sclk_tuser <= "0100";
            end if;


          ---------------------------------------------------------------------
          -- End of line/frame
          ---------------------------------------------------------------------
          elsif (state = S_LAST_DATA) then
            -- End of frame
            if (last_row = '1') then
              sclk_tuser <= "0010";

            -- End of line
            else
              sclk_tuser <= "1000";

            end if;

          ---------------------------------------------------------------------
          -- Continue
          ---------------------------------------------------------------------
          else
            sclk_tuser <= "0000";
          end if;
        end if;
      end if;
    end if;
  end process;



  transfert_done <= '1' when (state = S_DONE) else
                    '0';


  streamer_busy <= '1' when (state /= S_IDLE) else
                   '0';


  -----------------------------------------------------------------------------
  -- Process     : P_read_data_valid
  -- Description : Indicates data that the read data from the buffer is
  --               available
  -----------------------------------------------------------------------------
  P_read_data_valid : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        read_data_valid <= '0';
      else
        if (read_en = '1') then
          read_data_valid <= '1';
        elsif (m_wait = '0') then
          read_data_valid <= '0';
        else
          read_data_valid <= read_data_valid;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_sclk_tvalid
  -- Description : AXI Stream video interface : data bus
  -----------------------------------------------------------------------------
  P_sclk_tvalid : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        sclk_tvalid_int <= '0';
      else
        if (m_wait = '0') then
          sclk_tvalid_int <= read_data_valid;
        end if;
      end if;
    end if;
  end process;


  sclk_tvalid <= sclk_tvalid_int;


  -----------------------------------------------------------------------------
  -- Process     : P_sclk_tdata
  -- Description : AXI Stream video interface : data bus
  -----------------------------------------------------------------------------

  -- P_sclk_tdata : process (sclk) is
  -- begin
  --   if (rising_edge(sclk)) then
  --     if (sclk_reset = '1') then
  --       sclk_tdata <= (others => '0');
  --     else
  --       if (m_wait = '0' and read_data_valid = '1') then
  --         sclk_tdata <= line_buffer_data;
  --       end if;
  --     end if;
  --   end if;
  -- end process;


  -----------------------------------------------------------------------------
  -- Process     : P_sclk_tlast
  -- Description : In the AXI stream video protocol TLAST is used as the EOL
  --               sync marker
  -----------------------------------------------------------------------------
  P_sclk_tlast : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        sclk_tlast <= '0';
      else
        if (m_wait = '0') then
          if (state = S_LAST_DATA) then
            sclk_tlast <= '1';
          else
            sclk_tlast <= '0';
          end if;
        end if;
      end if;
    end if;
  end process;


end rtl;


