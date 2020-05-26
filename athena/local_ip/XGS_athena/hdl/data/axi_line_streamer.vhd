-------------------------------------------------------------------------------
-- MODULE      : axi_line_streamer
--
-- DESCRIPTION : Stream recombine lines extracted from the XGS sensor
--
-- REFERENCES  :
--                 See Xilinx UG934,  
--                 See Xilinx UG1037, chapter 4,Video IP: AXI Feature Adoption
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity axi_line_streamer is
  generic (
    NUMB_LINE_BUFFER          : integer;
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
    streamer_en    : in  std_logic;
    streamer_busy  : out std_logic;
    transfert_done : out std_logic;
    init_frame     : in  std_logic;

    ---------------------------------------------------------------------------
    -- Register interface
    ---------------------------------------------------------------------------
    y_row_start : in std_logic_vector(11 downto 0);
    y_row_stop  : in std_logic_vector(11 downto 0);

    ---------------------------------------------------------------------------
    -- Line buffer I/F
    ---------------------------------------------------------------------------
    clrBuffer           : out std_logic_vector(NUMB_LINE_BUFFER-1 downto 0);
    line_buffer_ready   : in  std_logic_vector(NUMB_LINE_BUFFER-1 downto 0);
    line_buffer_read    : out std_logic;
    line_buffer_ptr     : out std_logic_vector(LINE_BUFFER_PTR_WIDTH-1 downto 0);
    line_buffer_address : out std_logic_vector(LINE_BUFFER_ADDRESS_WIDTH-1 downto 0);
    line_buffer_count   : in  std_logic_vector(11 downto 0);
    line_buffer_row_id  : in  std_logic_vector(11 downto 0);
    line_buffer_data    : in  std_logic_vector(LINE_BUFFER_DATA_WIDTH-1 downto 0);

    ---------------------------------------------------------------------------
    -- AXI Master stream interface
    ---------------------------------------------------------------------------
    sclk_tready : in  std_logic;
    sclk_tvalid : out std_logic;
    sclk_tuser  : out std_logic_vector(3 downto 0);
    sclk_tlast  : out std_logic;
    sclk_tdata  : out std_logic_vector(63 downto 0)
    );
end axi_line_streamer;


architecture rtl of axi_line_streamer is

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


  signal m_wait          : std_logic;
  signal state           : FSM_TYPE;
  signal burst_length    : integer;
  signal burst_cntr      : integer := 0;
  signal read_en         : std_logic;
  signal read_data_valid : std_logic;
  signal first_row       : std_logic;
  signal last_row        : std_logic;
  signal buffer_ptr      : unsigned(LINE_BUFFER_PTR_WIDTH-1 downto 0);
  signal start_transfer  : std_logic;
  signal sclk_tvalid_int : std_logic;

  -----------------------------------------------------------------------------
  -- Debug attributes 
  -----------------------------------------------------------------------------
  attribute mark_debug of m_wait          : signal is "true";
  attribute mark_debug of state           : signal is "true";
  attribute mark_debug of burst_length    : signal is "true";
  attribute mark_debug of burst_cntr      : signal is "true";
  attribute mark_debug of read_en         : signal is "true";
  attribute mark_debug of read_data_valid : signal is "true";
  attribute mark_debug of first_row       : signal is "true";
  attribute mark_debug of last_row        : signal is "true";
  attribute mark_debug of buffer_ptr      : signal is "true";
  attribute mark_debug of start_transfer  : signal is "true";
  attribute mark_debug of sclk_tvalid_int : signal is "true";

  attribute mark_debug of streamer_en         : signal is "true";
  attribute mark_debug of streamer_busy       : signal is "true";
  attribute mark_debug of transfert_done      : signal is "true";
  attribute mark_debug of init_frame          : signal is "true";
  attribute mark_debug of clrBuffer           : signal is "true";
  attribute mark_debug of line_buffer_ready   : signal is "true";
  attribute mark_debug of line_buffer_read    : signal is "true";
  attribute mark_debug of line_buffer_ptr     : signal is "true";
  attribute mark_debug of line_buffer_address : signal is "true";
  attribute mark_debug of line_buffer_count   : signal is "true";
  attribute mark_debug of line_buffer_row_id  : signal is "true";
  attribute mark_debug of line_buffer_data    : signal is "true";
  attribute mark_debug of sclk_tready         : signal is "true";
  attribute mark_debug of sclk_tvalid         : signal is "true";
  attribute mark_debug of sclk_tuser          : signal is "true";
  attribute mark_debug of sclk_tlast          : signal is "true";
  attribute mark_debug of sclk_tdata          : signal is "true";
  attribute mark_debug of y_row_start         : signal is "true";
  attribute mark_debug of y_row_stop          : signal is "true";


begin


  m_wait <= '1' when (sclk_tready = '0' and read_data_valid = '1' and sclk_tvalid_int = '1') else
            '0';


  read_en <= '1' when (state = S_DATA_PHASE and m_wait = '0') else
             '0';


  -----------------------------------------------------------------------------
  -- Process     : P_clrBuffer
  -- Description : 
  -----------------------------------------------------------------------------
  P_clrBuffer : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        clrBuffer <= (others => '0');
      else
        if (state = S_EOL or state = S_EOF) then
          for i in 0 to NUMB_LINE_BUFFER loop
            if (i = to_integer(buffer_ptr)) then
              clrBuffer(i) <= '1';
              exit;
            end if;
          end loop;
        else
          clrBuffer <= (others => '0');
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


  last_row <= '1' when (line_buffer_row_id = y_row_stop) else
              '0';



  -----------------------------------------------------------------------------
  -- Process     : P_burst_length
  -- Description : 
  -----------------------------------------------------------------------------
  P_burst_length : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        burst_length <= 0;
      else
        if (state = S_LOAD_BURST_CNTR) then
          burst_length <= to_integer(unsigned(line_buffer_count));
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_buffer_ptr
  -- Description : 
  -----------------------------------------------------------------------------
  P_buffer_ptr : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        buffer_ptr <= (others => '0');
      else
        if (init_frame = '1') then
          buffer_ptr <= (others => '0');
        elsif (state = S_EOL) then
          buffer_ptr <= buffer_ptr+1;
        end if;
      end if;
    end if;
  end process;


  line_buffer_ptr <= std_logic_vector(buffer_ptr);


  -----------------------------------------------------------------------------
  -- Process     : P_burst_cntr
  -- Description : 
  -----------------------------------------------------------------------------
  P_burst_cntr : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        burst_cntr <= 0;
      else
        if (state = S_LOAD_BURST_CNTR) then
          burst_cntr <= 0;
        elsif (state = S_DATA_PHASE and read_en = '1') then
          burst_cntr <= burst_cntr+1;
        end if;
      end if;
    end if;
  end process;

  line_buffer_read    <= read_en;
  line_buffer_address <= std_logic_vector(to_unsigned(burst_cntr, line_buffer_address 'length));


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_start_transfer : process (state, buffer_ptr, line_buffer_ready) is
  begin
    if (state = S_WAIT_SOL) then
      for i in 0 to NUMB_LINE_BUFFER-1 loop
        if (i = to_integer(buffer_ptr) and line_buffer_ready(i) = '1') then
          start_transfer <= '1';
          exit;
        else
          start_transfer <= '0';
        end if;
      end loop;
    else
      start_transfer <= '0';
    end if;
  end process;


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
            if (start_transfer = '1') then
              state <= S_SOL;
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
            if (burst_cntr = (burst_length - 1)) then
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
          if (state = S_DATA_PHASE and burst_cntr = 1) then
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
  P_sclk_tdata : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        sclk_tdata <= (others => '0');
      else
        if (m_wait = '0' and read_data_valid = '1') then
          sclk_tdata <= line_buffer_data;
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


