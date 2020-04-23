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
    AXIS_USER_WIDTH   : integer := 1;
    BUFFER_ADDR_WIDTH : integer := 10
    );
  port (
    ---------------------------------------------------------------------
    -- PCIe user domain reset and clock signals
    ---------------------------------------------------------------------
    axi_clk     : in std_logic;
    axi_reset_n : in std_logic;

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

  type FSM_TYPE is (S_IDLE, S_INIT, S_LOAD_LINE, S_INIT_HOST_TRANSFER, S_WAIT_COMPLETION, S_DONE);

  constant C_S_AXI_ADDR_WIDTH   : integer := 8;
  constant C_S_AXI_DATA_WIDTH   : integer := 32;
  constant BUFFER_DATA_WIDTH    : integer := 64;

  constant CONT : std_logic_vector(1 downto 0) := "00";
  constant SOF  : std_logic_vector(1 downto 0) := "01";
  constant EOL  : std_logic_vector(1 downto 0) := "10";
  constant EOF  : std_logic_vector(1 downto 0) := "11";

  signal state : FSM_TYPE := S_IDLE;

  signal buffer_write_en      : std_logic;
  signal buffer_write_address : std_logic_vector(BUFFER_ADDR_WIDTH-1 downto 0);
  signal buffer_write_data    : std_logic_vector(BUFFER_DATA_WIDTH-1 downto 0);

  signal buffer_read_en      : std_logic;
  signal buffer_read_address : std_logic_vector(BUFFER_ADDR_WIDTH-1 downto 0);
  signal buffer_read_data    : std_logic_vector(BUFFER_DATA_WIDTH-1 downto 0);

  signal axis_data_ack : std_logic;
  signal sync          : std_logic_vector(1 downto 0);

begin

  s_axis_tready <= '1' when (state = S_LOAD_LINE) else
                   '0';

  sync(0) <= s_axis_tuser(0);
  sync(1) <= s_axis_tlast;

  -----------------------------------------------------------------------------
  -- Process     : P_hispi_state
  -- Description : Decode the hispi protocol state
  -----------------------------------------------------------------------------
  P_state : process (axi_clk) is
  begin
    if (rising_edge(axi_clk)) then
      if (axi_reset_n = '0')then
        state <= S_IDLE;
      else

        case state is
          -------------------------------------------------------------------
          -- S_IDLE : 
          -------------------------------------------------------------------
          when S_IDLE =>
            if (s_axis_tvalid = '1') then
              state <= S_INIT;
            else
              state <= S_IDLE;
            end if;


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
              state <= S_INIT_HOST_TRANSFER;
            else
              state <= S_LOAD_LINE;
            end if;


          -------------------------------------------------------------------
          -- S_TRANSFER : 
          -------------------------------------------------------------------
          when S_INIT_HOST_TRANSFER =>
            state <= S_WAIT_COMPLETION;


          -------------------------------------------------------------------
          -- S_WAIT_COMPLETION : 
          -------------------------------------------------------------------
          when S_WAIT_COMPLETION =>
            if (line_transfered = '1') then
              state <= S_DONE;
            else
              state <= S_WAIT_COMPLETION;
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
  buffer_write_en <= '1' when (state = S_LOAD_LINE and s_axis_tvalid = '1') else
                     '0';

-----------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------


-----------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------
  P_buffer_write_address : process (axi_clk) is
  begin
    if (rising_edge(axi_clk)) then
      if (axi_reset_n = '0')then
        buffer_write_address <= (others => '0');
      else
        if (state = S_INIT) then
          buffer_write_address <= (others => '0');
        elsif (buffer_write_en = '1') then
          buffer_write_address <= std_logic_vector(unsigned(buffer_write_address)+1);
        end if;
      end if;
    end if;
  end process;

  buffer_write_data <= s_axis_tdata;


  -----------------------------------------------------------------------------
  -- Line buffer 
  -----------------------------------------------------------------------------
  xdual_port_ram : dualPortRamVar
    generic map(
      DATAWIDTH => BUFFER_DATA_WIDTH,
      ADDRWIDTH => BUFFER_ADDR_WIDTH
      )
    port map(
      data      => buffer_write_data,
      rdaddress => buffer_read_address,
      rdclock   => axi_clk,
      rden      => buffer_read_en,
      wraddress => buffer_write_address,
      wrclock   => axi_clk,
      wren      => buffer_write_en,
      q         => buffer_read_data
      );
  
  buffer_read_en        <= line_buffer_read_en;
  buffer_read_address   <= line_buffer_read_address;
  line_buffer_read_data <= buffer_read_data;

  
-----------------------------------------------------------------------------
-- line_ready
-----------------------------------------------------------------------------
  P_line_ready : process (axi_clk) is
  begin
    if (rising_edge(axi_clk)) then
      if (axi_reset_n = '0')then
        line_ready <= '0';
      else
        if (state = S_INIT_HOST_TRANSFER) then
          line_ready <= '1';
        elsif (line_transfered = '1') then
          line_ready <= '0';
        end if;
      end if;
    end if;
  end process;


  start_of_frame <= '1' when (state = S_INIT and sync = SOF) else
                    '0';

  line_buffer_read_data <= buffer_read_data;
  end_of_dma            <= '0';         -- TBD

end rtl;

