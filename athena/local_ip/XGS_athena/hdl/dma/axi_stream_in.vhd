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
    BUFFER_ADDR_WIDTH : integer := 10
    );
  port (
    ---------------------------------------------------------------------
    -- PCIe user domain reset and clock signals
    ---------------------------------------------------------------------
    sclk   : in std_logic;
    srst_n : in std_logic;

    ----------------------------------------------------
    -- Control I/F
    ----------------------------------------------------

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

  type FSM_TYPE is (S_IDLE, S_SOF, S_INIT, S_LOAD_LINE, S_TOGGLE_BUFFER, S_INIT_HOST_TRANSFER, S_DONE);
  type OUTPUT_FSM_TYPE is (S_IDLE, S_INIT, S_TRANSFER, S_END_OF_DMA, S_DONE);

  constant C_S_AXI_ADDR_WIDTH : integer := 8;
  constant C_S_AXI_DATA_WIDTH : integer := 32;
  constant BUFFER_DATA_WIDTH  : integer := 64;

  constant CONT : std_logic_vector(1 downto 0) := "00";
  constant SOF  : std_logic_vector(1 downto 0) := "01";
  constant EOL  : std_logic_vector(1 downto 0) := "10";
  constant EOF  : std_logic_vector(1 downto 0) := "11";

  signal state        : FSM_TYPE        := S_IDLE;
  signal output_state : OUTPUT_FSM_TYPE := S_IDLE;

  signal buffer_rdy           : std_logic_vector(1 downto 0);
  signal buffer_empty         : std_logic_vector(1 downto 0);
  signal buffer_write_en      : std_logic;
  signal buffer_write_address : std_logic_vector(BUFFER_ADDR_WIDTH downto 0);
  signal buffer_write_ptr     : unsigned(BUFFER_ADDR_WIDTH-1 downto 0);
  signal buffer_write_data    : std_logic_vector(BUFFER_DATA_WIDTH-1 downto 0);

  signal buffer_read_en      : std_logic;
  signal buffer_read_address : std_logic_vector(BUFFER_ADDR_WIDTH downto 0);
  signal buffer_read_data    : std_logic_vector(BUFFER_DATA_WIDTH-1 downto 0);
  signal last_row            : std_logic;
  signal double_buffer_ptr   : std_logic;


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



begin


  -----------------------------------------------------------------------------
  -- Process     : P_buffer_rdy
  -- Description : 
  -----------------------------------------------------------------------------
  P_buffer_rdy : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (srst_n = '0')then
        buffer_rdy <= (others => '0');
      else
        -----------------------------------------------------------------------
        -- Store data in buffer 0; Read from buffer 1
        -----------------------------------------------------------------------
        if (double_buffer_ptr = '0') then
          if (s_axis_tvalid = '1' and s_axis_tlast = '1') then
            buffer_rdy(0) <= '1';
          end if;
          if (line_transfered = '1') then
            buffer_rdy(1) <= '0';
          end if;

        -----------------------------------------------------------------------
        -- Store data in buffer 1; Read from buffer 0
        -----------------------------------------------------------------------
        else
          if (s_axis_tvalid = '1' and s_axis_tlast = '1') then
            buffer_rdy(1) <= '1';
          end if;
          if (line_transfered = '1') then
            buffer_rdy(0) <= '0';
          end if;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_buffer_empty
  -- Description : 
  -----------------------------------------------------------------------------
  P_buffer_empty : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (srst_n = '0')then
        buffer_empty <= (others => '1');
      else
        -----------------------------------------------------------------------
        -- Store data in buffer 0; Read from buffer 1
        -----------------------------------------------------------------------
        if (double_buffer_ptr = '0') then
          if (s_axis_tvalid = '1') then
            buffer_empty(0) <= '0';
          end if;
          if (line_transfered = '1') then
            buffer_empty(1) <= '1';
          end if;

        -----------------------------------------------------------------------
        -- Store data in buffer 1; Read from buffer 0
        -----------------------------------------------------------------------
        else
          if (s_axis_tvalid = '1') then
            buffer_empty(1) <= '0';
          end if;
          if (line_transfered = '1') then
            buffer_empty(0) <= '1';
          end if;
        end if;
      end if;
    end if;
  end process;



  s_axis_tready <= '1' when (state = S_LOAD_LINE and double_buffer_ptr = '0' and buffer_rdy(0) = '0') else
                   '1' when (state = S_LOAD_LINE and double_buffer_ptr = '1' and buffer_rdy(1) = '0') else
                   '0';


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
        if (state = S_LOAD_LINE and s_axis_tlast = '1' and s_axis_tvalid = '1' and s_axis_tuser(1) = '1') then
          last_row <= '1';
        elsif (output_state = S_END_OF_DMA) then
          last_row <= '0';
        end if;
      end if;
    end if;
  end process;

  -----------------------------------------------------------------------------
  -- Process     : P_double_buffer_ptr
  -- Description : 
  -----------------------------------------------------------------------------
  P_double_buffer_ptr : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (srst_n = '0')then
        double_buffer_ptr <= '0';
      else
        if (state = S_SOF) then
          double_buffer_ptr <= '0';
        elsif (state = S_TOGGLE_BUFFER) then
          double_buffer_ptr <= not double_buffer_ptr;
        end if;
      end if;
    end if;
  end process;



  -----------------------------------------------------------------------------
  -- Process     : P_hispi_state
  -- Description : Decode the hispi protocol state
  -----------------------------------------------------------------------------
  P_state : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (srst_n = '0')then
        state <= S_IDLE;
      else

        case state is
          -------------------------------------------------------------------
          -- S_IDLE : 
          -------------------------------------------------------------------
          when S_IDLE =>
            if (s_axis_tvalid = '1') then
              if (s_axis_tuser(0) = '1') then
                state <= S_SOF;
              else
                state <= S_INIT;
              end if;
            else
              state <= S_IDLE;
            end if;


          -------------------------------------------------------------------
          -- S_SOF : 
          -------------------------------------------------------------------
          when S_SOF =>
            state <= S_INIT;


          -------------------------------------------------------------------
          -- S_INIT : 
          -------------------------------------------------------------------
          when S_INIT =>
            state <= S_LOAD_LINE;


          -------------------------------------------------------------------
          --  S_LOAD_LINE : 
          -------------------------------------------------------------------
          when S_LOAD_LINE =>
            if (s_axis_tvalid = '1' and s_axis_tlast = '1') then
              state <= S_TOGGLE_BUFFER;
            else
              state <= S_LOAD_LINE;
            end if;

          -------------------------------------------------------------------
          -- S_TRANSFER : 
          -------------------------------------------------------------------
          when S_TOGGLE_BUFFER =>
            state <= S_INIT_HOST_TRANSFER;

          -------------------------------------------------------------------
          -- S_TRANSFER : 
          -------------------------------------------------------------------
          when S_INIT_HOST_TRANSFER =>
            if (output_state = S_INIT) then
              state <= S_DONE;
            else
              state <= S_INIT_HOST_TRANSFER;
            end if;

          -------------------------------------------------------------------
          -- S_DONE : 
          -------------------------------------------------------------------
          when S_DONE =>
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


-----------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------
  buffer_write_en <= '1' when (state = S_LOAD_LINE and double_buffer_ptr = '0' and buffer_rdy(0) = '0' and s_axis_tvalid = '1') else
                     '1' when (state = S_LOAD_LINE and double_buffer_ptr = '1' and buffer_rdy(1) = '0' and s_axis_tvalid = '1') else
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
        if (state = S_INIT) then
          buffer_write_ptr <= (others => '0');
        elsif (buffer_write_en = '1') then
          buffer_write_ptr <= buffer_write_ptr + 1;
        end if;
      end if;
    end if;
  end process;


  buffer_write_address <= (double_buffer_ptr) & std_logic_vector(buffer_write_ptr);
  buffer_write_data    <= s_axis_tdata;


  -----------------------------------------------------------------------------
  -- Line buffer (2xline buffer size to support double buffering)
  -----------------------------------------------------------------------------
  xdual_port_ram : dualPortRamVar
    generic map(
      DATAWIDTH => BUFFER_DATA_WIDTH,
      ADDRWIDTH => BUFFER_ADDR_WIDTH+1
      )
    port map(
      data      => buffer_write_data,
      rdaddress => buffer_read_address,
      rdclock   => sclk,
      rden      => buffer_read_en,
      wraddress => buffer_write_address,
      wrclock   => sclk,
      wren      => buffer_write_en,
      q         => buffer_read_data
      );

  buffer_read_en        <= line_buffer_read_en;
  buffer_read_address   <= not(double_buffer_ptr) & line_buffer_read_address;
  line_buffer_read_data <= buffer_read_data;



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
            if (state = S_INIT_HOST_TRANSFER) then
              output_state <= S_INIT;
            end if;

          -------------------------------------------------------------------
          -- S_INIT : 
          -------------------------------------------------------------------
          when S_INIT =>
            output_state <= S_TRANSFER;


          -------------------------------------------------------------------
          --  S_LOAD_LINE : 
          -------------------------------------------------------------------
          when S_TRANSFER =>
            if (line_transfered = '1') then
              if (last_row = '1') then
                output_state <= S_END_OF_DMA;
              else
                output_state <= S_DONE;
              end if;
            end if;

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


  start_of_frame <= '1' when (state = S_SOF) else
                    '0';

  line_buffer_read_data <= buffer_read_data;

  end_of_dma <= '1' when (output_state = S_END_OF_DMA) else
                '0';

end rtl;

