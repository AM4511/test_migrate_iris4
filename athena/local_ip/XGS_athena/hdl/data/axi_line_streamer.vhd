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
    sysclk : in std_logic;
    sysrst : in std_logic;

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
    number_of_row : in std_logic_vector(11 downto 0);

    ---------------------------------------------------------------------------
    -- Line buffer I/F
    ---------------------------------------------------------------------------
    clrBuffer           : out std_logic_vector(NUMB_LINE_BUFFER-1 downto 0);
    line_buffer_ready   : in  std_logic_vector(NUMB_LINE_BUFFER-1 downto 0);
    line_buffer_read    : out std_logic;
    line_buffer_ptr     : out std_logic_vector(LINE_BUFFER_PTR_WIDTH-1 downto 0);
    line_buffer_address : out std_logic_vector(LINE_BUFFER_ADDRESS_WIDTH-1 downto 0);
    line_buffer_count   : in  std_logic_vector(11 downto 0);
    line_buffer_line_id : in  std_logic_vector(11 downto 0);
    line_buffer_data    : in  std_logic_vector(LINE_BUFFER_DATA_WIDTH-1 downto 0);

    ---------------------------------------------------------------------------
    -- AXI Master stream interface
    ---------------------------------------------------------------------------
    m_axis_tready : in  std_logic;
    m_axis_tvalid : out std_logic;
    m_axis_tuser  : out std_logic_vector(3 downto 0);
    m_axis_tlast  : out std_logic;
    m_axis_tdata  : out std_logic_vector(63 downto 0)
    );
end axi_line_streamer;



architecture rtl of axi_line_streamer is


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


  signal m_wait            : std_logic;
  signal state             : FSM_TYPE;
  signal burst_length      : integer;
  signal burst_cntr        : integer := 0;
  signal read_en           : std_logic;
  signal read_data_valid   : std_logic;
  signal first_row         : std_logic;
  signal last_row          : std_logic;
  signal buffer_ptr        : unsigned(LINE_BUFFER_PTR_WIDTH-1 downto 0);
  signal start_transfer    : std_logic;
  signal m_axis_tvalid_int : std_logic;


begin


  m_wait <= '1' when (m_axis_tready = '0' and read_data_valid = '1' and m_axis_tvalid_int = '1') else
            '0';


  read_en <= '1' when (state = S_DATA_PHASE and m_wait = '0') else
             '0';


  -----------------------------------------------------------------------------
  -- Process     : P_clrBuffer
  -- Description : 
  -----------------------------------------------------------------------------
  P_clrBuffer : process (sysclk) is
  begin
    if (rising_edge(sysclk)) then
      if (sysrst = '1') then
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
  P_first_row : process (sysclk) is
  begin
    if (rising_edge(sysclk)) then
      if (sysrst = '1') then
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
  P_last_row : process (sysclk) is
  begin
    if (rising_edge(sysclk)) then
      if (sysrst = '1') then
        last_row <= '0';
      else
        if (init_frame = '1') then
          last_row <= '0';
        elsif (state = S_SOL and (std_logic_vector(unsigned(number_of_row)-1) = line_buffer_line_id)) then
          last_row <= '1';
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_burst_length
  -- Description : 
  -----------------------------------------------------------------------------
  P_burst_length : process (sysclk) is
  begin
    if (rising_edge(sysclk)) then
      if (sysrst = '1') then
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
  P_buffer_ptr : process (sysclk) is
  begin
    if (rising_edge(sysclk)) then
      if (sysrst = '1') then
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
  P_burst_cntr : process (sysclk) is
  begin
    if (rising_edge(sysclk)) then
      if (sysrst = '1') then
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
  P_state : process (sysclk) is
  begin
    if (rising_edge(sysclk)) then
      if (sysrst = '1' or streamer_en = '0') then
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
  -- Process     : P_m_axis_tuser
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
  P_m_axis_tuser : process (sysclk) is
  begin
    if (rising_edge(sysclk)) then
      if (sysrst = '1') then
        m_axis_tuser <= "0000";
      else
        if (m_wait = '0') then
          ---------------------------------------------------------------------
          -- Start of frame
          ---------------------------------------------------------------------
          if (state = S_DATA_PHASE and burst_cntr = 1) then
            -- Start of frame
            if (first_row = '1') then
              m_axis_tuser <= "0001";
            -- Start of line
            else
              m_axis_tuser <= "0100";
            end if;


          ---------------------------------------------------------------------
          -- End of line/frame
          ---------------------------------------------------------------------
          elsif (state = S_LAST_DATA) then
            -- End of frame
            if (last_row = '1') then
              m_axis_tuser <= "0010";

            -- End of line
            else
              m_axis_tuser <= "1000";

            end if;

          ---------------------------------------------------------------------
          -- Continue
          ---------------------------------------------------------------------
          else
            m_axis_tuser <= "0000";
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
  P_read_data_valid : process (sysclk) is
  begin
    if (rising_edge(sysclk)) then
      if (sysrst = '1') then
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
  -- Process     : P_m_axis_tvalid
  -- Description : AXI Stream video interface : data bus
  -----------------------------------------------------------------------------
  P_m_axis_tvalid : process (sysclk) is
  begin
    if (rising_edge(sysclk)) then
      if (sysrst = '1') then
        m_axis_tvalid_int <= '0';
      else
        if (m_wait = '0') then
          m_axis_tvalid_int <= read_data_valid;
        end if;
      end if;
    end if;
  end process;


  m_axis_tvalid <= m_axis_tvalid_int;


  -----------------------------------------------------------------------------
  -- Process     : P_m_axis_tdata
  -- Description : AXI Stream video interface : data bus
  -----------------------------------------------------------------------------
  P_m_axis_tdata : process (sysclk) is
  begin
    if (rising_edge(sysclk)) then
      if (sysrst = '1') then
        m_axis_tdata <= (others => '0');
      else
        if (m_wait = '0' and read_data_valid = '1') then
          m_axis_tdata <= line_buffer_data;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_m_axis_tlast
  -- Description : In the AXI stream video protocol TLAST is used as the EOL
  --               sync marker
  -----------------------------------------------------------------------------
  P_m_axis_tlast : process (sysclk) is
  begin
    if (rising_edge(sysclk)) then
      if (sysrst = '1') then
        m_axis_tlast <= '0';
      else
        if (m_wait = '0') then
          if (state = S_LAST_DATA) then
            m_axis_tlast <= '1';
          else
            m_axis_tlast <= '0';
          end if;
        end if;
      end if;
    end if;
  end process;


end rtl;

