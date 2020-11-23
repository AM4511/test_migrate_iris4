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

library work;
use work.hispi_pack.all;

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
    frame_done      : out std_logic;
    nb_lane_enabled : in  std_logic_vector(2 downto 0);

    ---------------------------------------------------------------------------
    -- Register interface (ROI parameters)
    ---------------------------------------------------------------------------
    x_start : in std_logic_vector(12 downto 0);
    x_stop  : in std_logic_vector(12 downto 0);
    y_start : in std_logic_vector(11 downto 0);
    y_size  : in std_logic_vector(11 downto 0);

    ---------------------------------------------------------------------------
    -- Lane_decode I/F
    ---------------------------------------------------------------------------
    sclk_buffer_lane_id  : out std_logic_vector(1 downto 0);
    sclk_buffer_id       : out std_logic_vector(1 downto 0);
    sclk_buffer_mux_id   : out std_logic_vector(1 downto 0);
    sclk_buffer_word_ptr : out std_logic_vector(5 downto 0);
    sclk_buffer_read_en  : out std_logic;

    -- Even lanes
    sclk_buffer_empty_top : in std_logic_vector(LANE_PER_PHY - 1 downto 0);
    sclk_buffer_sync_top  : in std_logic_vector(3 downto 0);
    sclk_buffer_data_top  : in PIXEL_ARRAY(2 downto 0);

    -- Odd lanes
    sclk_buffer_empty_bottom : in std_logic_vector(LANE_PER_PHY - 1 downto 0);
    sclk_buffer_sync_bottom  : in std_logic_vector(3 downto 0);
    sclk_buffer_data_bottom  : in PIXEL_ARRAY(2 downto 0);

    ---------------------------------------------------------------------------
    -- AXI Master stream interface
    ---------------------------------------------------------------------------
    sclk_tready : in  std_logic;
    sclk_tvalid : out std_logic;
    sclk_tuser  : out std_logic_vector(3 downto 0);
    sclk_tlast  : out std_logic;
    sclk_tdata  : out PIXEL_ARRAY(7 downto 0)
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
  type OUTPUT_FSM_TYPE is (S_IDLE,
                           S_SOF,
                           S_PREFETCH,
                           S_TRANSFER,
                           S_EOF,
                           S_DONE
                           );

  constant DATAWIDTH : integer                              := 84;
  constant ADDRWIDTH : integer                              := 10;
  constant MAX_BURST : unsigned(sclk_buffer_word_ptr'range) := "111001";  --0x39

  signal sclk_fifo_write_en              : std_logic;
  signal sclk_fifo_write_data            : PIXEL_ARRAY(7 downto 0);
  signal sclk_fifo_write_data_slv        : std_logic_vector(79 downto 0);
  signal sclk_fifo_write_sync            : std_logic_vector(3 downto 0);
  signal sclk_fifo_write_aggregated_data : std_logic_vector(DATAWIDTH - 1 downto 0);
  signal sclk_data_packer_rdy            : std_logic;

  signal sclk_fifo_read_en       : std_logic;
  signal sclk_fifo_read_data_slv : std_logic_vector(79 downto 0);
  signal sclk_fifo_read_data     : PIXEL_ARRAY(7 downto 0);
  signal sclk_fifo_read_sync     : std_logic_vector(3 downto 0);
  signal sclk_fifo_usedw         : std_logic_vector(ADDRWIDTH downto 0);
  signal sclk_fifo_empty         : std_logic;
  signal sclk_fifo_full          : std_logic;

  signal m_wait     : std_logic;
  signal state      : FSM_TYPE;
  signal strm_state : OUTPUT_FSM_TYPE;

  signal burst_length      : integer;
  signal read_en           : std_logic;
  signal read_data_valid   : std_logic;
  signal first_row         : std_logic;
  signal last_row          : std_logic;
  signal sclk_tvalid_int   : std_logic;
  signal pixel_ptr         : integer range 0 to 16 := 0;
  signal pixel_cntr        : unsigned(12 downto 0);
  signal line_cntr         : unsigned(11 downto 0);
  signal sclk_valid_x_roi  : std_logic;
  signal sclk_data_packer  : PIXEL_ARRAY(17 downto 0);
  signal sclk_load_data    : std_logic;
  signal last_data         : std_logic;
  signal buffer_id_cntr    : unsigned(sclk_buffer_id'range);
  signal buffer_id_cntr_en : std_logic;
  signal lane_id_cntr      : integer range 0 to LANE_PER_PHY-1;
  signal lane_id_cntr_max  : integer range 0 to LANE_PER_PHY-1;
  signal lane_id_cntr_en   : std_logic;
  signal word_cntr         : unsigned(sclk_buffer_word_ptr'range);
  signal word_cntr_en      : std_logic;
  signal word_cntr_init    : std_logic;
  signal mux_id_cntr       : unsigned(1 downto 0);
  signal mux_id_cntr_en    : std_logic;
  signal current_x_start   : unsigned(12 downto 0);
  signal current_x_stop    : unsigned(12 downto 0);
  signal current_y_start   : unsigned(11 downto 0);
  signal current_y_stop    : unsigned(11 downto 0);
  signal odd_line          : std_logic;

  -----------------------------------------------------------------------------
  -- Debug attributes 
  -----------------------------------------------------------------------------
  attribute mark_debug of m_wait : signal is "true";


begin


  -- m_wait <= '1' when (sclk_tready = '0' and read_data_valid = '1' and sclk_tvalid_int = '1') else
  --           '0';

  m_wait <= '1' when (sclk_tready = '0') else
            '0';




  -----------------------------------------------------------------------------
  -- Process     : P_state
  -- Description : Line streamer main FSM. Control the data packing and the
  --               stream transfer.
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
                sclk_buffer_empty_top(2 downto 0) = "000" and
                sclk_buffer_empty_bottom(2 downto 0) = "000"
                ) then
              state <= S_SOL;
            -- When 4 lanes enabled and data vailable on the 4 lanes
            elsif (nb_lane_enabled = "100" and
                   sclk_buffer_empty_top(1 downto 0) = "00" and
                   sclk_buffer_empty_bottom(1 downto 0) = "00"
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
            if (last_data = '1') then
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

  -- Indicates the frame is completely packed
  frame_done <= '1' when (state = S_DONE) else
                '0';

  -----------------------------------------------------------------------------
  -- Process     : P_current_x_start
  -- Description : Units in pixels
  -----------------------------------------------------------------------------
  P_current_x_start : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        current_x_start <= (others => '0');
      else
        --if (sof_flag = '1') then
        if (state = S_SOF) then
          --ToDO should come from register
          current_x_start <= unsigned(x_start);
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_current_x_stop
  -- Description : Units in pixels
  -----------------------------------------------------------------------------
  P_current_x_stop : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        current_x_stop <= (others => '0');
      else
        if (state = S_SOF) then
          current_x_stop <= unsigned(x_stop);
        end if;
      end if;
    end if;
  end process;

  -----------------------------------------------------------------------------
  -- Process     : P_current_y_start
  -- Description : 
  -----------------------------------------------------------------------------
  P_current_y_start : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        current_y_start <= (others => '0');
      else
        --if (sof_flag = '1') then
        if (state = S_SOF) then
          current_y_start <= unsigned(y_start);
        end if;
      end if;
    end if;
  end process;

  -----------------------------------------------------------------------------
  -- Process     : P_current_y_stop
  -- Description :
  -----------------------------------------------------------------------------
  P_current_y_stop : process (sclk) is
    variable start : unsigned(11 downto 0);
    variable size  : unsigned(11 downto 0);
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        current_y_stop <= (others => '0');
      else
        --if (sof_flag = '1') then
        if (state = S_SOF) then
          start          := unsigned(y_start);
          size           := unsigned(y_size);
          current_y_stop <= start + (size - 1);
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_line_cntr
  -- Description : Count the complete number of lines received in the current
  --               frame
  -----------------------------------------------------------------------------
  P_line_cntr : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        line_cntr <= (others => '0');
      else
        --if (sof_flag = '1') then
        if (state = S_SOF) then
          line_cntr <= unsigned(y_start);
        elsif (state = S_EOL) then
          line_cntr <= line_cntr+1;
        end if;
      end if;
    end if;
  end process;


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


  -----------------------------------------------------------------------------
  -- Process     : P_last_row
  -- Description : 
  -----------------------------------------------------------------------------
  P_last_row : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        last_row <= '0';
      else
        if (state = S_SOF) then
          last_row <= '0';
        elsif (state = S_SOL and (line_cntr = current_y_stop)) then
          last_row <= '1';
        elsif (state = S_EOF) then
          last_row <= '0';
        end if;
      end if;
    end if;
  end process;



  read_en <= '1' when (state = S_DATA_PHASE) else
             '0';


  sclk_buffer_read_en <= read_en;

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


  buffer_id_cntr_en <= '1' when (STATE = S_EOL) else
                       '0';

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

  mux_id_cntr_en <= '1' when (word_cntr = MAX_BURST and word_cntr_en = '1') else
                    '0';

  sclk_buffer_mux_id <= std_logic_vector(mux_id_cntr);



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
          if (lane_id_cntr = lane_id_cntr_max) then
            lane_id_cntr <= 0;
          else
            lane_id_cntr <= lane_id_cntr + 1;
          end if;
        end if;
      end if;
    end if;
  end process;

  lane_id_cntr_en <= '1' when (mux_id_cntr = "11" and mux_id_cntr_en = '1') else
                     '0';


  last_data <= '1' when (lane_id_cntr = lane_id_cntr_max and lane_id_cntr_en = '1') else
               '0';

  lane_id_cntr_max <= 1 when (nb_lane_enabled = "100") else
                      2 when (nb_lane_enabled = "110") else
                      0;

  sclk_buffer_lane_id <= std_logic_vector(to_unsigned(lane_id_cntr, sclk_buffer_lane_id'length));


  -----------------------------------------------------------------------------
  -- Process     : P_sclk_load_data
  -- Description : 
  -----------------------------------------------------------------------------
  P_sclk_load_data : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        sclk_load_data <= '0';
      else
        sclk_load_data <= read_en;
      end if;
    end if;
  end process;

  -----------------------------------------------------------------------------
  -- Process     : P_pixel_ptr
  -- Description : 
  -----------------------------------------------------------------------------
  P_pixel_ptr : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        pixel_ptr <= 0;
      else
        if (state = S_SOL) then
          pixel_ptr <= 0;
        elsif (sclk_load_data = '1') then
          if (pixel_ptr < 8) then
            pixel_ptr <= pixel_ptr + 6;
          else
            pixel_ptr <= pixel_ptr + (6 - 8);
          end if;
        end if;
      end if;
    end if;
  end process;

  
  -----------------------------------------------------------------------------
  -- Process     : P_pixel_cntr
  -- Description : Count the total data loaded in the line packer
  -----------------------------------------------------------------------------
  P_pixel_cntr : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        pixel_cntr <= (others => '0');
      else
        if (state = S_SOL) then
          pixel_cntr <= (others => '0');
        elsif (sclk_data_packer_rdy = '1') then
          pixel_cntr <= pixel_cntr + 8;
        end if;
      end if;
    end if;
  end process;

  
  sclk_data_packer_rdy <= '1' when (state = S_DATA_PHASE and  pixel_ptr > 7) else
                          '0';

  
  sclk_valid_x_roi <= '1' when (state =  S_DATA_PHASE and
                                 (pixel_cntr >= current_x_start) and
                                 (pixel_cntr <= current_x_stop)
                                 ) else
                      '0';

  
  odd_line <= line_cntr(0);

  
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
            if (odd_line = '1') then
              sclk_data_packer(0) <= sclk_buffer_data_top(0);
              sclk_data_packer(1) <= sclk_buffer_data_bottom(0);

              sclk_data_packer(2) <= sclk_buffer_data_top(1);
              sclk_data_packer(3) <= sclk_buffer_data_bottom(1);

              sclk_data_packer(4) <= sclk_buffer_data_top(2);
              sclk_data_packer(5) <= sclk_buffer_data_bottom(2);
            else
              sclk_data_packer(0) <= sclk_buffer_data_bottom(0);
              sclk_data_packer(1) <= sclk_buffer_data_top(0);

              sclk_data_packer(2) <= sclk_buffer_data_bottom(1);
              sclk_data_packer(3) <= sclk_buffer_data_top(1);

              sclk_data_packer(4) <= sclk_buffer_data_bottom(2);
              sclk_data_packer(5) <= sclk_buffer_data_top(2);
            end if;
            sclk_data_packer(11 downto 6) <= (others => (others => '-'));

          when 6 =>
            if (odd_line = '1') then
              sclk_data_packer(6) <= sclk_buffer_data_top(0);
              sclk_data_packer(7) <= sclk_buffer_data_bottom(0);

              sclk_data_packer(8) <= sclk_buffer_data_top(1);
              sclk_data_packer(9) <= sclk_buffer_data_bottom(1);

              sclk_data_packer(10) <= sclk_buffer_data_top(2);
              sclk_data_packer(11) <= sclk_buffer_data_bottom(2);
            else
              sclk_data_packer(6) <= sclk_buffer_data_bottom(0);
              sclk_data_packer(7) <= sclk_buffer_data_top(0);

              sclk_data_packer(8) <= sclk_buffer_data_bottom(1);
              sclk_data_packer(9) <= sclk_buffer_data_top(1);

              sclk_data_packer(10) <= sclk_buffer_data_bottom(2);
              sclk_data_packer(11) <= sclk_buffer_data_top(2);
            end if;

          when 8 =>
            if (odd_line = '1') then
              sclk_data_packer(0) <= sclk_buffer_data_top(0);
              sclk_data_packer(1) <= sclk_buffer_data_bottom(0);

              sclk_data_packer(2) <= sclk_buffer_data_top(1);
              sclk_data_packer(3) <= sclk_buffer_data_bottom(1);

              sclk_data_packer(4) <= sclk_buffer_data_top(2);
              sclk_data_packer(5) <= sclk_buffer_data_bottom(2);
            else
              sclk_data_packer(0) <= sclk_buffer_data_bottom(0);
              sclk_data_packer(1) <= sclk_buffer_data_top(0);

              sclk_data_packer(2) <= sclk_buffer_data_bottom(1);
              sclk_data_packer(3) <= sclk_buffer_data_top(1);

              sclk_data_packer(4) <= sclk_buffer_data_bottom(2);
              sclk_data_packer(5) <= sclk_buffer_data_top(2);
            end if;
            sclk_data_packer(11 downto 6) <= (others => (others => '-'));

          when 10 =>
            sclk_data_packer(1 downto 0) <= sclk_data_packer(9 downto 8);
            if (odd_line = '1') then
              sclk_data_packer(2) <= sclk_buffer_data_top(0);
              sclk_data_packer(3) <= sclk_buffer_data_bottom(0);

              sclk_data_packer(4) <= sclk_buffer_data_top(1);
              sclk_data_packer(5) <= sclk_buffer_data_bottom(1);

              sclk_data_packer(6) <= sclk_buffer_data_top(2);
              sclk_data_packer(7) <= sclk_buffer_data_bottom(2);
            else
              sclk_data_packer(2) <= sclk_buffer_data_bottom(0);
              sclk_data_packer(3) <= sclk_buffer_data_top(0);

              sclk_data_packer(4) <= sclk_buffer_data_bottom(1);
              sclk_data_packer(5) <= sclk_buffer_data_top(1);

              sclk_data_packer(6) <= sclk_buffer_data_bottom(2);
              sclk_data_packer(7) <= sclk_buffer_data_top(2);
            end if;
            sclk_data_packer(11 downto 8) <= (others => (others => '-'));

          --OK
          when 12 =>
            sclk_data_packer(3 downto 0) <= sclk_data_packer(11 downto 8);
            if (odd_line = '1') then
              sclk_data_packer(4) <= sclk_buffer_data_top(0);
              sclk_data_packer(5) <= sclk_buffer_data_bottom(0);

              sclk_data_packer(6) <= sclk_buffer_data_top(1);
              sclk_data_packer(7) <= sclk_buffer_data_bottom(1);

              sclk_data_packer(8) <= sclk_buffer_data_top(2);
              sclk_data_packer(9) <= sclk_buffer_data_bottom(2);
            else
              sclk_data_packer(4) <= sclk_buffer_data_bottom(0);
              sclk_data_packer(5) <= sclk_buffer_data_top(0);

              sclk_data_packer(6) <= sclk_buffer_data_bottom(1);
              sclk_data_packer(7) <= sclk_buffer_data_top(1);

              sclk_data_packer(8) <= sclk_buffer_data_bottom(2);
              sclk_data_packer(9) <= sclk_buffer_data_top(2);
            end if;
            sclk_data_packer(11 downto 10) <= (others => (others => '-'));

          when others =>
            null;
        end case;
      end if;
    end if;
  end process;

  -----------------------------------------------------------------------------
  -- Process     : P_sclk_fifo_write_sync
  -- Description : Inferred sync markers
  -----------------------------------------------------------------------------
  P_sclk_fifo_write_sync : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        sclk_fifo_write_sync <= (others => '0');
      else
        if (state = S_SOF) then
          sclk_fifo_write_sync <= "0001";
        elsif (state = S_SOL) then
          sclk_fifo_write_sync(2) <= '1';
        elsif (sclk_data_packer_rdy = '1' and pixel_cntr(12 downto 3) = (current_x_stop(12 downto 3) - 1)) then
          -- EOL detected
          sclk_fifo_write_sync(3) <= '1';
          if (last_row = '1') then
            -- Also an EOF detected
            sclk_fifo_write_sync(1) <= '1';
          end if;
        elsif (sclk_fifo_write_en = '1') then
          sclk_fifo_write_sync <= (others => '0');
        end if;
      end if;
    end if;
  end process;


  sclk_fifo_write_en <= '1' when (sclk_load_data = '1' and pixel_ptr > 7 and sclk_valid_x_roi = '1') else
                        '0';

  sclk_fifo_write_data            <= sclk_data_packer(7 downto 0);
  sclk_fifo_write_data_slv        <= to_std_logic_vector(sclk_fifo_write_data);
  sclk_fifo_write_aggregated_data <= sclk_fifo_write_sync & sclk_fifo_write_data_slv;


  xoutput_fifo : mtxSCFIFO
    generic map (
      DATAWIDTH => DATAWIDTH,
      ADDRWIDTH => ADDRWIDTH
      )
    port map (
      clk             => sclk,
      sclr            => sclk_reset,
      wren            => sclk_fifo_write_en,
      data            => sclk_fifo_write_aggregated_data,
      rden            => sclk_fifo_read_en,
      q(79 downto 0)  => sclk_fifo_read_data_slv,
      q(83 downto 80) => sclk_fifo_read_sync,
      usedw           => sclk_fifo_usedw,
      empty           => sclk_fifo_empty,
      full            => sclk_fifo_full
      );

  sclk_fifo_read_data(0) <= sclk_fifo_read_data_slv(9 downto 0);
  sclk_fifo_read_data(1) <= sclk_fifo_read_data_slv(19 downto 10);
  sclk_fifo_read_data(2) <= sclk_fifo_read_data_slv(29 downto 20);
  sclk_fifo_read_data(3) <= sclk_fifo_read_data_slv(39 downto 30);
  sclk_fifo_read_data(4) <= sclk_fifo_read_data_slv(49 downto 40);
  sclk_fifo_read_data(5) <= sclk_fifo_read_data_slv(59 downto 50);
  sclk_fifo_read_data(6) <= sclk_fifo_read_data_slv(69 downto 60);
  sclk_fifo_read_data(7) <= sclk_fifo_read_data_slv(79 downto 70);

  -----------------------------------------------------------------------------
  -- Process     : P_strm_state
  -- Description : 
  -----------------------------------------------------------------------------
  P_strm_state : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        strm_state <= S_IDLE;

      else
        case strm_state is

          ---------------------------------------------------------------------
          -- S_IDLE : Parking state
          ---------------------------------------------------------------------
          when S_IDLE =>
            if (state = S_SOF) then
              strm_state <= S_SOF;
            else
              strm_state <= S_IDLE;
            end if;

          ---------------------------------------------------------------------
          -- S_PREFETCH : 
          ---------------------------------------------------------------------
          when S_SOF =>
            if (sclk_fifo_empty = '0') then
              strm_state <= S_PREFETCH;

            else
              strm_state <= S_SOF;
            end if;

          ---------------------------------------------------------------------
          -- S_PREFETCH : 
          ---------------------------------------------------------------------
          when S_PREFETCH =>
            strm_state <= S_TRANSFER;

          ---------------------------------------------------------------------
          -- S_TRANSFER
          ---------------------------------------------------------------------
          when S_TRANSFER =>
            if (sclk_fifo_read_sync(1) = '1') then
              strm_state <= S_EOF;
            end if;

          when S_EOF =>
            strm_state <= S_DONE;


          ---------------------------------------------------------------------
          -- S_DONE
          ---------------------------------------------------------------------
          when S_DONE =>
            strm_state <= S_IDLE;

          ---------------------------------------------------------------------
          -- 
          ---------------------------------------------------------------------
          when others =>
            null;
        end case;
      end if;
    end if;
  end process P_strm_state;


  sclk_fifo_read_en <= '1' when ((strm_state = S_PREFETCH or strm_state = S_TRANSFER) and sclk_fifo_empty = '0' and m_wait = '0') else
                       '0';



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
        -- Following a read request in the fifo, data will be available and
        -- valid on the next clock cycle. Note, the sclk_fifo_read_en is
        -- asserted only when m_wait = '0'
        if (sclk_fifo_read_en = '1') then
          read_data_valid <= '1';
        -- If no wait states on the AXI stream interface and no read request we
        -- assume the current data has been consumed on is not valid anymore
        elsif (m_wait = '0') then
          read_data_valid <= '0';

        -- If a wait states is requested on the AXI stream interface and
        -- the current valid state remains unchanged.
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
        sclk_tvalid <= '0';
      else
        if (m_wait = '0') then
          sclk_tvalid <= read_data_valid;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_sclk_tdata
  -- Description : AXI Stream video interface : data bus
  -----------------------------------------------------------------------------
  P_sclk_tdata : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        sclk_tdata <= (others => (others => '0'));
      else
        if (m_wait = '0' and read_data_valid = '1') then
          sclk_tdata <= sclk_fifo_read_data;
        end if;
      end if;
    end if;
  end process;


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
          if (read_data_valid = '1') then
            sclk_tlast <= sclk_fifo_read_sync(3);
          else
            sclk_tlast <= '0';
          end if;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_sclk_tuser
  -- Description : In the AXI stream video protocol TUSER is used as the SOF
  --               sync marker.
  --
  --               USER[3 2 1 0]  SYNC
  --               ===================
  --                    0 - 0 1   SOF
  --                    - 0 1 0   EOF
  --                    0 1 0 -   SOL
  --                    1 0 - 0   EOL
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
          if (read_data_valid = '1') then
            sclk_tuser <= sclk_fifo_read_sync;
          else
            sclk_tuser <= "0000";
          end if;
        end if;
      end if;
    end if;
  end process;


end rtl;


