-----------------------------------------------------------------------
-- MODULE        : axi_stream_in
-- 
-- DESCRIPTION   : AXI stream input interface
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

  component dma_line_buffer is
    generic (
      BUFFER_ADDR_WIDTH     : integer := 11;  -- in bits
      BUFFER_LINE_PTR_WIDTH : integer := 3
      );
    port (
      ---------------------------------------------------------------------
      -- PCIe user domain reset and clock signals
      ---------------------------------------------------------------------
      sclk        : in std_logic;
      srst_n      : in std_logic;
      sclk_unpack : in std_logic;

      -- Info buffer
      sclk_info_wren     : in  std_logic;
      sclk_info_wlength  : in  std_logic_vector(BUFFER_ADDR_WIDTH-1 downto 0);
      sclk_info_weof     : in  std_logic;
      sclk_info_wbuff_id : in  std_logic_vector(BUFFER_LINE_PTR_WIDTH-1 downto 0);
      sclk_info_rden     : in  std_logic;
      sclk_info_rlength  : out std_logic_vector(BUFFER_ADDR_WIDTH-1 downto 0);
      sclk_info_reof     : out std_logic;
      sclk_info_rbuff_id : out std_logic_vector(BUFFER_LINE_PTR_WIDTH-1 downto 0);

      -- Data buffer
      sclk_wren      : in  std_logic;
      sclk_wraddress : in  std_logic_vector (BUFFER_ADDR_WIDTH-1 downto 0);
      sclk_wrdata    : in  std_logic_vector (63 downto 0);
      sclk_rden      : in  std_logic;
      sclk_rdaddress : in  std_logic_vector (BUFFER_ADDR_WIDTH-1 downto 0);
      sclk_rddata    : out std_logic_vector (63 downto 0)
      );
  end component;



  type FSM_TYPE is (S_IDLE, S_SOF, S_SOL, S_WRITE, S_TOGGLE_BUFFER, S_PCI_BACK_PRESSURE, S_EOF);
  type OUTPUT_FSM_TYPE is (S_IDLE, S_WAIT_LINE, S_READ_CONTEXT, S_INIT, S_TRANSFER, S_TRANSFER_WAIT, S_EOL, S_END_OF_DMA, S_DONE);

  constant BUFFER_DATA_WIDTH     : integer := 64;
  constant BUFFER_LINE_PTR_WIDTH : integer := 3;  -- in bits
  -- constant BUFFER_WORD_PTR_WIDTH : integer := (BUFFER_ADDR_WIDTH - BUFFER_LINE_PTR_WIDTH);
  -- constant BUFFER_WORD_PTR_WIDTH : integer := (BUFFER_ADDR_WIDTH - 2);

  signal wr_state : FSM_TYPE        := S_IDLE;
  signal rd_state : OUTPUT_FSM_TYPE := S_IDLE;

  signal buffer_write_en      : std_logic;
  signal buffer_write_address : unsigned(BUFFER_ADDR_WIDTH - 1 downto 0);
  signal buffer_write_ptr     : unsigned(BUFFER_ADDR_WIDTH-1 downto 0);
  signal buffer_write_data    : std_logic_vector(BUFFER_DATA_WIDTH-1 downto 0);

  signal buffer_read_en    : std_logic;
  signal buffer_read_en_P1 : std_logic := '0';

  signal buffer_read_address : unsigned(BUFFER_ADDR_WIDTH-1 downto 0);
  signal buffer_read_data    : std_logic_vector(BUFFER_DATA_WIDTH-1 downto 0);
  signal last_row            : std_logic;
  signal read_sync           : std_logic_vector(3 downto 0);

  signal init_line_ptr    : std_logic;
  signal incr_wr_line_ptr : std_logic;
  signal incr_rd_line_ptr : std_logic;
  signal wr_line_ptr      : unsigned(BUFFER_LINE_PTR_WIDTH-1 downto 0);
  signal rd_line_ptr      : unsigned(BUFFER_LINE_PTR_WIDTH-1 downto 0);
  signal line_ptr_mask    : unsigned(BUFFER_LINE_PTR_WIDTH-1 downto 0);
  signal distance_cntr    : unsigned(BUFFER_LINE_PTR_WIDTH downto 0);
  signal max_distance     : unsigned(BUFFER_LINE_PTR_WIDTH downto 0);

  signal line_buffer_full  : std_logic;
  signal line_buffer_empty : std_logic;
  signal numb_line_buffer  : std_logic_vector(3 downto 0);
  signal sclk_unpack       : std_logic;

  signal sclk_info_wren     : std_logic;
  signal sclk_info_wlength  : std_logic_vector(BUFFER_ADDR_WIDTH-1 downto 0);
  signal sclk_info_weof     : std_logic;
  signal sclk_info_wbuff_id : std_logic_vector(BUFFER_LINE_PTR_WIDTH-1 downto 0);
  signal sclk_info_rden     : std_logic;
  signal sclk_info_rlength  : std_logic_vector(BUFFER_ADDR_WIDTH-1 downto 0);
  signal sclk_info_reof     : std_logic;
  signal sclk_info_rbuff_id : std_logic_vector(BUFFER_LINE_PTR_WIDTH-1 downto 0);
  signal sclk_rd_last_data  : std_logic;

  -----------------------------------------------------------------------------
  -- Debug attributes 
  -----------------------------------------------------------------------------
  attribute mark_debug of wr_state                 : signal is "true";
  attribute mark_debug of rd_state                 : signal is "true";
  attribute mark_debug of buffer_write_en          : signal is "true";
  attribute mark_debug of buffer_write_address     : signal is "true";
  attribute mark_debug of buffer_write_ptr         : signal is "true";
  attribute mark_debug of buffer_write_data        : signal is "true";
  attribute mark_debug of buffer_read_en           : signal is "true";
  attribute mark_debug of buffer_read_address      : signal is "true";
  attribute mark_debug of buffer_read_data         : signal is "true";
  attribute mark_debug of last_row                 : signal is "true";
  --attribute mark_debug of read_sync                : signal is "true";
  attribute mark_debug of init_line_ptr            : signal is "true";
  attribute mark_debug of incr_wr_line_ptr         : signal is "true";
  attribute mark_debug of incr_rd_line_ptr         : signal is "true";
  attribute mark_debug of wr_line_ptr              : signal is "true";
  attribute mark_debug of rd_line_ptr              : signal is "true";
  attribute mark_debug of line_ptr_mask            : signal is "true";
  attribute mark_debug of distance_cntr            : signal is "true";
  attribute mark_debug of max_distance             : signal is "true";
  attribute mark_debug of line_buffer_full         : signal is "true";
  attribute mark_debug of line_buffer_empty        : signal is "true";
  attribute mark_debug of numb_line_buffer         : signal is "true";
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


begin


  -----------------------------------------------------------------------------
  -- AXI stream flow control. When asserted it means we can accept a full line
  -----------------------------------------------------------------------------
  s_axis_tready <= '1' when (wr_state = S_WRITE) else
                   '0';

  -----------------------------------------------------------------------------
  -- Flag used to initialize line pointers on both side of the buffer (Write/Read)
  -----------------------------------------------------------------------------
  init_line_ptr <= '1' when (wr_state = S_SOF) else
                   '0';

  incr_wr_line_ptr <= '1' when (wr_state = S_TOGGLE_BUFFER or wr_state = S_EOF) else
                      '0';

  incr_rd_line_ptr <= '1' when (rd_state = S_EOL or rd_state = S_END_OF_DMA) else
                      '0';


  -- Create a mask for managing the number of bits used (wrap around) in the
  -- line pointer counters below.
  line_ptr_mask <= "111" when (line_ptr_width = "11") else  -- 8 Buffer mask, hence 3 bits
                   "011" when (line_ptr_width = "10") else
                   "001";


  -- Indicates the output buffer configuration vs line_ptr_width
  numb_line_buffer <= "1000" when (line_ptr_width = "11") else  -- 3 bits; 8 buffers
                      "0100" when (line_ptr_width = "10") else  -- 2 bits; 4 buffers
                      "0010";           -- Else; 2 buffers


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
  -- Process     : P_wr_state
  -- Description : Line buffer write side state machine
  -----------------------------------------------------------------------------
  P_wr_state : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (srst_n = '0')then
        wr_state <= S_IDLE;
      else

        case wr_state is
          -------------------------------------------------------------------
          -- S_IDLE : Parking state
          -------------------------------------------------------------------
          when S_IDLE =>
            if (s_axis_tvalid = '1') then
              if (s_axis_tuser(0) = '1') then
                wr_state <= S_SOF;
              end if;
            else
              wr_state <= S_IDLE;
            end if;


          -------------------------------------------------------------------
          -- S_SOF : Start of frame detected on the AXIS I/F
          -------------------------------------------------------------------
          when S_SOF =>
            wr_state <= S_SOL;


          -------------------------------------------------------------------
          -- S_SOL : Start of line; initialize the current buffer for a new
          --         line storage
          -------------------------------------------------------------------
          when S_SOL =>
            wr_state <= S_WRITE;


          -------------------------------------------------------------------
          --  S_WRITE : 
          -------------------------------------------------------------------
          when S_WRITE =>
            -- If a end of line is detected
            if (s_axis_tvalid = '1' and s_axis_tlast = '1') then
              -- If a End of frame is detected
              if (s_axis_tuser(1) = '1') then
                wr_state <= S_EOF;
              -- No end of frame but cant store next line : buffer full!
              elsif (line_buffer_full = '1') then
                wr_state <= S_PCI_BACK_PRESSURE;
                -- Line buffer full, go switch to next line buffer
                -- synthesis translate_off
                assert false report "WARNING : PCIe DMA line buffer back pressure" severity warning;
                -- synthesis translate_on

              else
                wr_state <= S_TOGGLE_BUFFER;
              end if;
            else
              wr_state <= S_WRITE;
            end if;


          -------------------------------------------------------------------
          -- S_PCI_BACK_PRESSURE : All line buffers are full. Wait until one
          -- line buffer gets available. 
          -------------------------------------------------------------------
          when S_PCI_BACK_PRESSURE =>
            if (line_buffer_full = '1') then
              wr_state <= S_PCI_BACK_PRESSURE;
              -- synthesis translate_off
              -- assert false report "WARNING : PCIe DMA line buffer back pressure" severity warning;
              -- synthesis translate_on

            else
              wr_state <= S_TOGGLE_BUFFER;
            end if;


          -------------------------------------------------------------------
          -- S_TOGGLE_BUFFER : Switch line buffer
          -------------------------------------------------------------------
          when S_TOGGLE_BUFFER =>
            wr_state <= S_SOL;


          -------------------------------------------------------------------
          -- S_EOF : End of frame encounter. Go back in S_IDLE state
          -------------------------------------------------------------------
          when S_EOF =>
            wr_state <= S_IDLE;


          -------------------------------------------------------------------
          -- 
          -------------------------------------------------------------------
          when others =>
            null;
        end case;
      end if;
    end if;
  end process P_wr_state;


  -----------------------------------------------------------------------------
  -- Status flag for the register file. Connected in the parent file
  -----------------------------------------------------------------------------
  pcie_back_pressure_detected <= '1' when (wr_state = S_PCI_BACK_PRESSURE) else
                                 '0';


  -----------------------------------------------------------------------------
  -- Buffer write en 
  -----------------------------------------------------------------------------
  buffer_write_en <= '1' when (wr_state = S_WRITE and s_axis_tvalid = '1') else
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
        if (wr_state = S_SOL) then
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


  --buffer_write_data <= "0000" & s_axis_tuser & s_axis_tdata;
  buffer_write_data <= s_axis_tdata;


  sclk_unpack <= '0';



  sclk_info_wren <= '1' when (wr_state = S_TOGGLE_BUFFER or wr_state = S_EOF) else
                    '0';

  sclk_info_weof <= '1' when (wr_state = S_EOF) else
                    '0';

  sclk_info_wlength<= std_logic_vector(buffer_write_ptr);
  
  sclk_info_wbuff_id <= std_logic_vector(wr_line_ptr);


  xdma_line_buffer : dma_line_buffer
    generic map(
      BUFFER_ADDR_WIDTH
      )
    port map(
      ---------------------------------------------------------------------
      -- PCIe user domain reset and clock signals
      ---------------------------------------------------------------------
      sclk               => sclk,
      srst_n             => srst_n,
      sclk_unpack        => sclk_unpack,
      sclk_info_wren     => sclk_info_wren,
      sclk_info_wlength  => sclk_info_wlength,
      sclk_info_weof     => sclk_info_weof,
      sclk_info_wbuff_id => sclk_info_wbuff_id,
      sclk_info_rden     => sclk_info_rden,
      sclk_info_rlength  => sclk_info_rlength,
      sclk_info_reof     => sclk_info_reof,
      sclk_info_rbuff_id => sclk_info_rbuff_id,
      sclk_wren          => buffer_write_en,
      sclk_wraddress     => std_logic_vector(buffer_write_address),
      sclk_wrdata        => buffer_write_data,
      sclk_rden          => buffer_read_en,
      sclk_rdaddress     => std_logic_vector(buffer_read_address),
      sclk_rddata        => buffer_read_data
      );

 sclk_info_rden <= '1' when (rd_state = S_READ_CONTEXT) else
                    '0';




  
  buffer_read_en <= '1' when (line_buffer_read_en = '1' and rd_state = S_TRANSFER) else '0';


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_buffer_read_address : process (numb_line_buffer, rd_line_ptr, line_buffer_read_address) is
    variable msb : integer := buffer_read_address'left;
  begin
    case numb_line_buffer is
      -------------------------------------------------------------------------
      -- 8 Line buffers
      -------------------------------------------------------------------------
      when "1000" =>
        buffer_read_address <= rd_line_ptr(2 downto 0) & unsigned(line_buffer_read_address(msb - 3 downto 0));

      -------------------------------------------------------------------------
      -- 4 Line buffers
      -------------------------------------------------------------------------
      when "0100" =>
        buffer_read_address <= rd_line_ptr(1 downto 0) & unsigned(line_buffer_read_address(msb - 2 downto 0));

      -------------------------------------------------------------------------
      -- 2 Line buffers
      -------------------------------------------------------------------------
      when "0010" =>
        buffer_read_address <= rd_line_ptr(0 downto 0) & unsigned(line_buffer_read_address(msb - 1 downto 0));

      -------------------------------------------------------------------------
      -- 2 Line buffers
      -------------------------------------------------------------------------
      when others =>
        buffer_read_address <= unsigned(line_buffer_read_address);
    end case;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_rd_state
  -- Description : Read side FSM
  -----------------------------------------------------------------------------
  P_rd_state : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (srst_n = '0')then
        rd_state <= S_IDLE;
      else

        case rd_state is
          -------------------------------------------------------------------
          -- S_IDLE : Parking state
          -------------------------------------------------------------------
          when S_IDLE =>
            if (wr_state = S_SOF) then
              rd_state <= S_WAIT_LINE;
            end if;

          -------------------------------------------------------------------
          -- S_WAIT_LINE : Wait for a new line available for transfer
          -------------------------------------------------------------------
          when S_WAIT_LINE =>
            if (distance_cntr > (distance_cntr'range => '0') and line_transfered = '0') then
              rd_state <= S_READ_CONTEXT;
            else
              rd_state <= S_WAIT_LINE;
            end if;

          -------------------------------------------------------------------
          -- S_READ_CONTEXT : Initialize the DMA transfer
          -------------------------------------------------------------------
          when S_READ_CONTEXT =>
            rd_state <= S_INIT;
            
          -------------------------------------------------------------------
          -- S_INIT : Initialize the DMA transfer
          -------------------------------------------------------------------
          when S_INIT =>
            rd_state <= S_TRANSFER;

          -------------------------------------------------------------------
          --  S_TRANSFER : the DMA transfer occurs in this state
          -------------------------------------------------------------------
          when S_TRANSFER =>
            --if (buffer_read_en_P1='1' and (read_sync = "1000" or read_sync = "0010") ) then
            -- If end of line or end of frame encountered
            --if (buffer_read_en_P1 = '1' and (read_sync(3) = '1' or read_sync(1) = '1')) then
            if (buffer_read_en_P1 = '1' and sclk_rd_last_data = '1') then
              rd_state <= S_TRANSFER_WAIT;
            else
              rd_state <= S_TRANSFER;
            end if;

          -------------------------------------------------------------------
          --  S_TRANSFER_WAIT : Wait for line_transferted to be 1
          -------------------------------------------------------------------
          when S_TRANSFER_WAIT =>
            if (line_transfered = '1') then
              --if (last_row = '1') then
              if (sclk_info_reof = '1') then
                rd_state <= S_END_OF_DMA;
              else
                rd_state <= S_EOL;
              end if;
            end if;

          -------------------------------------------------------------------
          -- S_EOL : Indicates a full line transfer has completed
          -------------------------------------------------------------------
          when S_EOL =>
            rd_state <= S_WAIT_LINE;

          -------------------------------------------------------------------
          -- S_END_OF_DMA : Indicates a full frame transfer has completed
          -------------------------------------------------------------------
          when S_END_OF_DMA =>
            rd_state <= S_DONE;

          -------------------------------------------------------------------
          -- S_DONE : What more to say? When we are done,... yes we are!
          -------------------------------------------------------------------
          when S_DONE =>
            rd_state <= S_IDLE;

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
  -- Flag indicating the we reached the last data beat of the current read line
  -----------------------------------------------------------------------------
  sclk_rd_last_data <= '1' when (unsigned(line_buffer_read_address) = unsigned(sclk_info_rlength) - 1) else
                       '0';

  
  -----------------------------------------------------------------------------
  -- Process     : P_last_row
  -- Description : Flag used to indicate to rd_state we are evacuating the 
  --               last row of the frame.
  -----------------------------------------------------------------------------
  -- P_last_row : process (sclk) is
  -- begin
  --   if (rising_edge(sclk)) then
  --     if (srst_n = '0')then
  --       buffer_read_en_P1 <= '0';
  --       last_row          <= '0';
  --     else
  --       buffer_read_en_P1 <= buffer_read_en;
  --       -- If we detect an end of frame
  --       if (rd_state = S_TRANSFER and buffer_read_en_P1 = '1' and read_sync(1) = '1') then  --READ EOF
  --         last_row <= '1';
  --       -- Cleared once the frame completely evacuated
  --       elsif (rd_state = S_END_OF_DMA) then
  --         last_row <= '0';
  --       end if;
  --     end if;
  --   end if;
  -- end process;


  -----------------------------------------------------------------------------
  -- line_ready
  -----------------------------------------------------------------------------
  P_line_ready : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (srst_n = '0')then
        line_ready <= '0';
      else
        if (rd_state = S_INIT) then
          line_ready <= '1';
        elsif (line_transfered = '1') then
          line_ready <= '0';
        end if;
      end if;
    end if;
  end process;

  --read_sync             <= buffer_read_data(67 downto 64);
  line_buffer_read_data <= buffer_read_data(63 downto 0);

  start_of_frame <= '1' when (wr_state = S_SOF) else
                    '0';


  end_of_dma <= '1' when (rd_state = S_END_OF_DMA) else
                '0';

end rtl;

