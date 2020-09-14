-----------------------------------------------------------------------
-- 
--              
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity axi_stream_in is
  generic (
    AXIS_DATA_WIDTH   : integer := 64;
    AXIS_USER_WIDTH   : integer := 4;
    BUFFER_ADDR_WIDTH : integer := 11   -- in bits
    );
  port (
    ---------------------------------------------------------------------
    -- PCIe user domain reset and clock signals
    ---------------------------------------------------------------------
    sclk   : in std_logic;
    srst_n : in std_logic;

    ----------------------------------------------------
    -- Line buffer config (Register file I/F)
    ----------------------------------------------------
    clr_max_line_buffer_cnt     : in  std_logic;
    line_ptr_width              : in  std_logic_vector(1 downto 0);
    max_line_buffer_cnt         : out std_logic_vector(3 downto 0);
    pcie_back_pressure_detected : out std_logic;

    ----------------------------------------------------
    -- AXI stream interface (Slave port)
    ----------------------------------------------------
    s_axis_tready : out std_logic;
    s_axis_tvalid : in  std_logic;
    s_axis_tdata  : in  std_logic_vector(AXIS_DATA_WIDTH-1 downto 0);
    s_axis_tlast  : in  std_logic;
    s_axis_tuser  : in  std_logic_vector(AXIS_USER_WIDTH-1 downto 0);

    ----------------------------------------------------
    -- Line buffer config
    ----------------------------------------------------

    ----------------------------------------------------
    -- Line buffer I/F
    ----------------------------------------------------
    start_of_frame  : out std_logic;
    line_ready      : out std_logic;
    line_transfered : in  std_logic;
    end_of_dma      : out std_logic;

    line_buffer_read_en      : in  std_logic;
    line_buffer_read_address : in  std_logic_vector(BUFFER_ADDR_WIDTH-1 downto 0);
    line_buffer_read_data    : out std_logic_vector(63 downto 0)
    );
end axi_stream_in;


architecture rtl of axi_stream_in is

  attribute mark_debug : string;
  attribute keep       : string;


  component dualPortRamVar is
    generic
      (
        DATAWIDTH : integer := 32;
        ADDRWIDTH : integer := 12
        );
    port
      (
        data      : in  std_logic_vector (DATAWIDTH-1 downto 0);
        rdaddress : in  std_logic_vector (ADDRWIDTH-1 downto 0);
        rdclock   : in  std_logic;
        rden      : in  std_logic := '1';
        wraddress : in  std_logic_vector (ADDRWIDTH-1 downto 0);
        wrclock   : in  std_logic := '1';
        wren      : in  std_logic := '0';
        q         : out std_logic_vector (DATAWIDTH-1 downto 0)
        );
  end component;

  type FSM_TYPE is (S_IDLE, S_SOF, S_SOL, S_WRITE, S_TOGGLE_BUFFER, S_PCI_BACK_PRESSURE, S_EOF);
  type OUTPUT_FSM_TYPE is (S_IDLE, S_WAIT_LINE, S_INIT, S_TRANSFER, S_EOL, S_END_OF_DMA, S_DONE);

  constant C_S_AXI_ADDR_WIDTH    : integer := 8;
  constant C_S_AXI_DATA_WIDTH    : integer := 32;
  constant BUFFER_DATA_WIDTH     : integer := 72;
  constant BUFFER_LINE_PTR_WIDTH : integer := 3;  -- in bits
  constant BUFFER_WORD_PTR_WIDTH : integer := (BUFFER_ADDR_WIDTH - BUFFER_LINE_PTR_WIDTH);

  constant CONT : std_logic_vector(1 downto 0) := "00";
  constant SOF  : std_logic_vector(1 downto 0) := "01";
  constant EOL  : std_logic_vector(1 downto 0) := "10";
  constant EOF  : std_logic_vector(1 downto 0) := "11";

  signal state        : FSM_TYPE        := S_IDLE;
  signal output_state : OUTPUT_FSM_TYPE := S_IDLE;

  signal buffer_write_en      : std_logic;
  signal buffer_write_address : unsigned(BUFFER_ADDR_WIDTH - 1 downto 0);
  signal buffer_write_ptr     : unsigned(BUFFER_ADDR_WIDTH-1 downto 0);
  signal buffer_write_data    : std_logic_vector(BUFFER_DATA_WIDTH-1 downto 0);

  signal buffer_read_en      : std_logic;
  signal buffer_read_address : unsigned(BUFFER_ADDR_WIDTH-1 downto 0);
  signal buffer_read_data    : std_logic_vector(BUFFER_DATA_WIDTH-1 downto 0);
  signal last_row            : std_logic;
  signal back_pressure_cntr  : integer;
  signal read_sync           : std_logic_vector(3 downto 0);

  signal init_line_ptr    : std_logic;
  signal incr_wr_line_ptr : std_logic;
  signal incr_rd_line_ptr : std_logic;
  signal wr_line_ptr      : unsigned(BUFFER_LINE_PTR_WIDTH-1 downto 0);
  signal rd_line_ptr      : unsigned(BUFFER_LINE_PTR_WIDTH-1 downto 0);
  signal line_ptr_mask    : unsigned(BUFFER_LINE_PTR_WIDTH-1 downto 0);
  signal distance_cntr    : unsigned(BUFFER_LINE_PTR_WIDTH downto 0);
  signal max_distance     : unsigned(BUFFER_LINE_PTR_WIDTH downto 0);

  signal wr_word_ptr       : unsigned(BUFFER_WORD_PTR_WIDTH-1 downto 0);
  signal rd_word_ptr       : unsigned(BUFFER_WORD_PTR_WIDTH-1 downto 0);
  signal line_buffer_full  : std_logic;
  signal line_buffer_empty : std_logic;
  signal numb_line_buffer  : std_logic_vector(3 downto 0);

  -----------------------------------------------------------------------------
  -- Debug attributes 
  -----------------------------------------------------------------------------
  attribute mark_debug of buffer_write_en          : signal is "true";
  attribute mark_debug of buffer_write_address     : signal is "true";
  attribute mark_debug of buffer_write_data        : signal is "true";
  attribute mark_debug of buffer_read_en           : signal is "true";
  attribute mark_debug of buffer_read_address      : signal is "true";
  attribute mark_debug of buffer_read_data         : signal is "true";
  attribute mark_debug of last_row                 : signal is "true";
  attribute mark_debug of s_axis_tready            : signal is "true";
  attribute mark_debug of s_axis_tvalid            : signal is "true";
  attribute mark_debug of s_axis_tdata             : signal is "true";
  attribute mark_debug of s_axis_tlast             : signal is "true";
  attribute mark_debug of s_axis_tuser             : signal is "true";
  attribute mark_debug of start_of_frame           : signal is "true";
  attribute mark_debug of line_ready               : signal is "true";
  attribute mark_debug of line_transfered          : signal is "true";
  attribute mark_debug of end_of_dma               : signal is "true";
  attribute mark_debug of line_buffer_read_en      : signal is "true";
  attribute mark_debug of line_buffer_read_address : signal is "true";
  attribute mark_debug of line_buffer_read_data    : signal is "true";

  attribute mark_debug of state              : signal is "true";
  attribute mark_debug of output_state       : signal is "true";
  attribute mark_debug of buffer_write_ptr   : signal is "true";
  attribute mark_debug of back_pressure_cntr : signal is "true";


begin


  s_axis_tready <= '1' when (state = S_WRITE) else
                   '0';


  init_line_ptr <= '1' when (state = S_SOF) else
                   '0';

  incr_wr_line_ptr <= '1' when (state = S_TOGGLE_BUFFER or state = S_EOF) else
                      '0';

  incr_rd_line_ptr <= '1' when (output_state = S_EOL or output_state = S_END_OF_DMA) else
                      '0';


  -- Create a mask for managing the number of bits used (wrap around) in the
  -- line pointer counters below.
  line_ptr_mask <= "111" when (line_ptr_width = "11") else  -- 8 Buffer mask, hence 3 bits
                   "011" when (line_ptr_width = "10") else
                   "001";


  numb_line_buffer <= "1000" when (line_ptr_width = "11") else
                      "0100" when (line_ptr_width = "10") else
                      "0010";


  -----------------------------------------------------------------------------
  -- Process     : P_wr_line_ptr
  -- Description : Line buffer pointer (Write port side)
  -----------------------------------------------------------------------------
  P_wr_line_ptr : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (srst_n = '0')then
        wr_line_ptr <= (others => '0');
      else
        -- Initialized on Start of frame
        if (init_line_ptr = '1') then
          wr_line_ptr <= (others => '0');

        -- Incremented after the line is completely written (@ EOL | EOF) in the current line
        -- buffer.
        elsif (incr_wr_line_ptr = '1') then
          wr_line_ptr <= (line_ptr_mask and (wr_line_ptr + 1));
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_rd_line_ptr
  -- Description : Line buffer pointer (Read port side)
  -----------------------------------------------------------------------------
  P_rd_line_ptr : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (srst_n = '0')then
        rd_line_ptr <= (others => '0');
      else
        -- Initialized on Start of frame
        if (init_line_ptr = '1') then
          rd_line_ptr <= (others => '0');

        -- Incremented after the line is completely evacuated by the DMA.
        elsif (incr_rd_line_ptr = '1') then
          rd_line_ptr <= (line_ptr_mask and (rd_line_ptr + 1));
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_distance_cntr
  -- Description : Like in any synchronous FiFo the distance counter calculate
  -- the distance between the write pointer and the read pointer. Used to
  -- generate the full and empty flags.
  -----------------------------------------------------------------------------
  P_distance_cntr : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (srst_n = '0')then
        distance_cntr <= (others => '0');
      else
        -- Initialized on Start of frame
        if (init_line_ptr = '1') then
          distance_cntr <= (others => '0');
        -- Incremented when a write only occured
        elsif (incr_wr_line_ptr = '1' and incr_rd_line_ptr = '0') then
          distance_cntr <= distance_cntr + 1;
        -- Incremented when a read only occured
        elsif (incr_wr_line_ptr = '0' and incr_rd_line_ptr = '1') then
          distance_cntr <= distance_cntr - 1;
        -- Remain unchanged when a write and read occurs on the same clock cycle or
        -- or when no access occurs on any side.
        else
          distance_cntr <= distance_cntr;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_max_distance
  -- Description : 
  -----------------------------------------------------------------------------
  P_max_distance : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (srst_n = '0')then
        max_distance <= (others => '0');
      else
        if (clr_max_line_buffer_cnt = '1') then
          max_distance <= (others => '0');
        elsif (distance_cntr > max_distance) then
          max_distance <= distance_cntr;
        end if;
      end if;
    end if;
  end process;
  max_line_buffer_cnt <= std_logic_vector(max_distance);


  -----------------------------------------------------------------------------
  -- Line buffer full flag (All line buffers are filled)
  -----------------------------------------------------------------------------
  line_buffer_full <= '1' when (distance_cntr = (unsigned(numb_line_buffer) -1)) else
                      '0';


  -----------------------------------------------------------------------------
  -- Line buffer empty (All line buffers are empty)
  -----------------------------------------------------------------------------
  line_buffer_empty <= '1' when (distance_cntr = (distance_cntr'range => '0')) else
                       '0';


  -----------------------------------------------------------------------------
  -- Process     : P_state
  -- Description : Line buffer write side state machine
  -----------------------------------------------------------------------------
  P_state : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (srst_n = '0')then
        state <= S_IDLE;
      else

        case state is
          -------------------------------------------------------------------
          -- S_IDLE : Parking state
          -------------------------------------------------------------------
          when S_IDLE =>
            if (s_axis_tvalid = '1') then
              if (s_axis_tuser(0) = '1') then
                state <= S_SOF;
              end if;
            else
              state <= S_IDLE;
            end if;


          -------------------------------------------------------------------
          -- S_SOF : Start of frame detected
          -------------------------------------------------------------------
          when S_SOF =>
            state <= S_SOL;


          -------------------------------------------------------------------
          -- S_SOL : Start of line; initialize the current buffer
          -------------------------------------------------------------------
          when S_SOL =>
            state <= S_WRITE;


          -------------------------------------------------------------------
          --  S_WRITE : 
          -------------------------------------------------------------------
          when S_WRITE =>
            -- If a end of line is detected
            if (s_axis_tvalid = '1' and s_axis_tlast = '1') then
              -- If a End of frame is detected
              if (s_axis_tuser(1) = '1') then
                state <= S_EOF;
              -- No end of frame but cant store next line : buffer full!
              elsif (line_buffer_full = '1') then
                state <= S_PCI_BACK_PRESSURE;
              -- Line buffer full, go switch to next line buffer
              else
                state <= S_TOGGLE_BUFFER;
              end if;
            else
              state <= S_WRITE;
            end if;


          -------------------------------------------------------------------
          -- S_PCI_BACK_PRESSURE : All line buffers are full. Wait until one
          -- line buffer gets available. 
          -------------------------------------------------------------------
          when S_PCI_BACK_PRESSURE =>
            if (line_buffer_full = '1') then
              state <= S_PCI_BACK_PRESSURE;
              -- synthesis translate_off
              assert false report "WARNING : PCIe DMA line buffer back pressure" severity warning;
              -- synthesis translate_on

            else
              state <= S_TOGGLE_BUFFER;
            end if;


          -------------------------------------------------------------------
          -- S_TOGGLE_BUFFER : Switch line buffer
          -------------------------------------------------------------------
          when S_TOGGLE_BUFFER =>
            state <= S_SOL;


          -------------------------------------------------------------------
          -- S_EOF : End of frame encounter. Go back in S_IDLE state
          -------------------------------------------------------------------
          when S_EOF =>
            state <= S_IDLE;


          -------------------------------------------------------------------
          -- 
          -------------------------------------------------------------------
          when others =>
            null;
        end case;
      end if;
    end if;
  end process P_state;


  pcie_back_pressure_detected <= '1' when (state = S_PCI_BACK_PRESSURE) else
                                 '0';


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  buffer_write_en <= '1' when (state = S_WRITE and s_axis_tvalid = '1') else
                     '0';


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_buffer_write_ptr : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (srst_n = '0')then
        buffer_write_ptr <= (others => '0');
      else
        if (state = S_SOL) then
          buffer_write_ptr <= (others => '0');
        elsif (buffer_write_en = '1') then
          buffer_write_ptr <= buffer_write_ptr + 1;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_buffer_write_address : process (numb_line_buffer, wr_line_ptr, buffer_write_ptr) is
  begin
    case numb_line_buffer is
      -------------------------------------------------------------------------
      -- 8 Line buffers
      -------------------------------------------------------------------------
      when "1000" =>
        buffer_write_address <= wr_line_ptr(2 downto 0) & buffer_write_ptr(buffer_write_address'left - 3 downto 0);
      -------------------------------------------------------------------------
      -- 4 Line buffers
      -------------------------------------------------------------------------
      when "0100" =>
        buffer_write_address <= wr_line_ptr(1 downto 0) & buffer_write_ptr(buffer_write_address'left - 2 downto 0);
      -------------------------------------------------------------------------
      -- 2 Line buffers
      -------------------------------------------------------------------------
      when "0010" =>
        buffer_write_address <= wr_line_ptr(0 downto 0) & buffer_write_ptr(buffer_write_address'left - 1 downto 0);

      -------------------------------------------------------------------------
      -- 2 Line buffers
      -------------------------------------------------------------------------
      when others =>
        buffer_write_address <= buffer_write_ptr;
    end case;
  end process;


  buffer_write_data <= "0000" & s_axis_tuser & s_axis_tdata;


  -----------------------------------------------------------------------------
  -- Line buffer (2xline buffer size to support double buffering)
  -----------------------------------------------------------------------------
  xdual_port_ram : dualPortRamVar
    generic map(
      DATAWIDTH => BUFFER_DATA_WIDTH,
      ADDRWIDTH => BUFFER_ADDR_WIDTH
      )
    port map(
      data      => buffer_write_data,
      rdaddress => std_logic_vector(buffer_read_address),
      rdclock   => sclk,
      rden      => buffer_read_en,
      wraddress => std_logic_vector(buffer_write_address),
      wrclock   => sclk,
      wren      => buffer_write_en,
      q         => buffer_read_data
      );

  buffer_read_en <= line_buffer_read_en;


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_buffer_read_address : process (numb_line_buffer, rd_line_ptr, line_buffer_read_address) is
  begin
    case numb_line_buffer is
      -------------------------------------------------------------------------
      -- 8 Line buffers
      -------------------------------------------------------------------------
      when "1000" =>
        buffer_read_address <= rd_line_ptr(2 downto 0) & unsigned(line_buffer_read_address(buffer_read_address'left - 3 downto 0));
      -------------------------------------------------------------------------
      -- 4 Line buffers
      -------------------------------------------------------------------------
      when "0100" =>
        buffer_read_address <= rd_line_ptr(1 downto 0) & unsigned(line_buffer_read_address(buffer_read_address'left - 2 downto 0));
      -------------------------------------------------------------------------
      -- 2 Line buffers
      -------------------------------------------------------------------------
      when "0010" =>
        buffer_read_address <= rd_line_ptr(0 downto 0) & unsigned(line_buffer_read_address(buffer_read_address'left - 1 downto 0));

      -------------------------------------------------------------------------
      -- 2 Line buffers
      -------------------------------------------------------------------------
      when others =>
        buffer_read_address <= unsigned(line_buffer_read_address);
    end case;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_hispi_output_state
  -- Description : Decode the hispi protocol output_state
  -----------------------------------------------------------------------------
  P_output_state : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (srst_n = '0')then
        output_state <= S_IDLE;
      else

        case output_state is
          -------------------------------------------------------------------
          -- S_IDLE : 
          -------------------------------------------------------------------
          when S_IDLE =>
            if (state = S_SOF) then
              output_state <= S_WAIT_LINE;
            end if;

          -------------------------------------------------------------------
          -- S_WAIT_LINE : Wait for a new line to transfer
          -------------------------------------------------------------------
          when S_WAIT_LINE =>
            if (distance_cntr > (distance_cntr'range => '0') and line_transfered = '0') then
              output_state <= S_INIT;
            else
              output_state <= S_WAIT_LINE;
            end if;

          -------------------------------------------------------------------
          -- S_INIT : 
          -------------------------------------------------------------------
          when S_INIT =>
            output_state <= S_TRANSFER;

          -------------------------------------------------------------------
          --  S_TRANSFER : 
          -------------------------------------------------------------------
          when S_TRANSFER =>
            if (line_transfered = '1') then
              if (last_row = '1') then
                output_state <= S_END_OF_DMA;
              else
                output_state <= S_EOL;
              end if;
            end if;

          -------------------------------------------------------------------
          -- S_EOL : 
          -------------------------------------------------------------------
          when S_EOL =>
            output_state <= S_WAIT_LINE;

          -------------------------------------------------------------------
          -- S_END_OF_DMA : 
          -------------------------------------------------------------------
          when S_END_OF_DMA =>
            output_state <= S_DONE;

          -------------------------------------------------------------------
          -- S_DONE : 
          -------------------------------------------------------------------
          when S_DONE =>
            output_state <= S_IDLE;

          -------------------------------------------------------------------
          -- 
          -------------------------------------------------------------------
          when others =>
            null;
        end case;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- line_ready
  -----------------------------------------------------------------------------
  P_line_ready : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (srst_n = '0')then
        line_ready <= '0';
      else
        if (output_state = S_INIT) then
          line_ready <= '1';
        elsif (line_transfered = '1') then
          line_ready <= '0';
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
      if (srst_n = '0')then
        last_row <= '0';
      else
        -- If we detect an end of frame
        if (output_state = S_TRANSFER and read_sync(1) = '1') then
          last_row <= '1';
        elsif (output_state = S_END_OF_DMA) then
          last_row <= '0';
        end if;
      end if;
    end if;
  end process;


  start_of_frame <= '1' when (state = S_SOF) else
                    '0';

  line_buffer_read_data <= buffer_read_data(63 downto 0);
  read_sync             <= buffer_read_data(67 downto 64);

  end_of_dma <= '1' when (output_state = S_END_OF_DMA) else
                '0';

end rtl;

