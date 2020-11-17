-----------------------------------------------------------------------
-- MODULE        : line_buffer_v2
-- 
-- DESCRIPTION   : 
--              
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library work;
use work.hispi_pack.all;


entity line_buffer_v2 is
  generic (
    WORD_PTR_WIDTH : integer := 6
    );
  port (
    ---------------------------------------------------------------------
    -- Pixel clock domain
    ---------------------------------------------------------------------
    pclk         : in std_logic;
    pclk_reset   : in std_logic;
    pclk_init    : in std_logic;
    pclk_valid   : in std_logic;
    pclk_data    : in PIXEL_ARRAY(2 downto 0);
    pclk_sync    : in std_logic_vector(3 downto 0);
    pclk_row_id  : in std_logic_vector(1 downto 0);
    pclk_lane_id : in std_logic_vector(1 downto 0);


    ---------------------------------------------------------------------
    -- Line buffer interface
    ---------------------------------------------------------------------
    sclk           : in  std_logic;
    sclk_reset     : in  std_logic;
    sclk_read_en   : in  std_logic;
    sclk_buffer_id : in  std_logic_vector(1 downto 0);
    sclk_mux_id    : in  std_logic_vector(1 downto 0);
    sclk_word_ptr  : in  std_logic_vector(WORD_PTR_WIDTH-1 downto 0);
    sclk_sync      : out std_logic_vector(3 downto 0);
    sclk_data      : out std_logic_vector(29 downto 0)
    );
end line_buffer_v2;


architecture rtl of line_buffer_v2 is

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

  type PCLK_FSM_TYPE is (S_IDLE, S_WAIT_LINE, S_SOF, S_SOL, S_WRITE, S_TOGGLE_BUFFER, S_EOL, S_EOF, S_DONE);
  type OUTPUT_FSM_TYPE is (S_IDLE, S_WAIT_LINE, S_INIT, S_TRANSFER, S_EOL, S_END_OF_DMA, S_DONE);

  constant LINE_PTR_WIDTH    : integer := 2;
  constant LANE_PTR_WIDTH    : integer := 2;
  constant BUFFER_ADDR_WIDTH : integer := LINE_PTR_WIDTH + LANE_PTR_WIDTH + WORD_PTR_WIDTH;  -- in bits
  constant BUFFER_DATA_WIDTH : integer := 36;



  constant BUFFER_LINE_PTR_WIDTH : integer := 3;  -- in bits
  constant BUFFER_WORD_PTR_WIDTH : integer := (BUFFER_ADDR_WIDTH - BUFFER_LINE_PTR_WIDTH);

  signal pclk_word_ptr      : unsigned(WORD_PTR_WIDTH-1 downto 0);
  signal pclk_init_word_ptr : std_logic;
  signal pclk_incr_word_ptr : std_logic;
  signal pclk_state         : PCLK_FSM_TYPE := S_IDLE;
  signal pclk_write_en      : std_logic;
  signal pclk_write_address : std_logic_vector(BUFFER_ADDR_WIDTH - 1 downto 0);
  signal pclk_write_data    : std_logic_vector(BUFFER_DATA_WIDTH-1 downto 0);


  signal sclk_read_address : std_logic_vector(BUFFER_ADDR_WIDTH - 1 downto 0);
  signal sclk_read_data    : std_logic_vector(BUFFER_DATA_WIDTH-1 downto 0);


begin

  -----------------------------------------------------------------------------
  -- Process     : P_pclk_state
  -- Description : Read side FSM
  -----------------------------------------------------------------------------
  P_pclk_state : process (pclk) is
  begin
    if (rising_edge(pclk)) then
      if (pclk_reset = '1')then
        pclk_state <= S_IDLE;
      else

        case pclk_state is
          -------------------------------------------------------------------
          -- S_IDLE : Parking state
          -------------------------------------------------------------------
          when S_IDLE =>
            if (pclk_init = '1') then
              pclk_state <= S_WAIT_LINE;
            end if;

          -------------------------------------------------------------------
          -- S_WAIT_LINE : Wait for a new line available for transfer
          -------------------------------------------------------------------
          when S_WAIT_LINE =>
            if (pclk_sync(0) = '1') then
              pclk_state <= S_SOL;
            else
              pclk_state <= S_WAIT_LINE;
            end if;

          -------------------------------------------------------------------
          -- S_INIT : Initialize the DMA transfer
          -------------------------------------------------------------------
          when S_SOL =>
            pclk_state <= S_WRITE;

          -------------------------------------------------------------------
          --  S_TRANSFER : the DMA transfer occurs in this state
          -------------------------------------------------------------------
          when S_WRITE =>
            if (pclk_sync(3) = '1'and pclk_write_en = '1') then
              pclk_state <= S_EOL;
            elsif (pclk_sync(1) = '1'and pclk_write_en = '1') then
              pclk_state <= S_EOF;
            else
              pclk_state <= S_WRITE;
            end if;


          -------------------------------------------------------------------
          -- S_EOL : Indicates a full line transfer has completed
          -------------------------------------------------------------------
          when S_EOL =>
            pclk_state <= S_WAIT_LINE;

          -------------------------------------------------------------------
          -- S_EOF : Indicates a full line transfer has completed
          -------------------------------------------------------------------
          when S_EOF =>
            pclk_state <= S_DONE;

          -------------------------------------------------------------------
          -- S_DONE : What more to say? When we are done,... yes we are!
          -------------------------------------------------------------------
          when S_DONE =>
            pclk_state <= S_IDLE;

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
  -- Word ptr init
  -----------------------------------------------------------------------------
  pclk_init_word_ptr <= '1' when (pclk_init = '1') else
                        '1' when ((pclk_sync(3) = '1' or pclk_sync(3) = '1') and pclk_write_en = '1') else
                        '0';

  -----------------------------------------------------------------------------
  -- Buffer write en 
  -----------------------------------------------------------------------------
  pclk_incr_word_ptr <= '1' when (pclk_write_en = '1' and pclk_lane_id = "11") else
                        '0';


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_pclk_word_ptr : process (pclk) is
  begin
    if (rising_edge(pclk)) then
      if (pclk_reset = '1')then
        pclk_word_ptr <= (others => '0');
      else
        if (pclk_init_word_ptr = '1') then
          pclk_word_ptr <= (others => '0');
        elsif (pclk_incr_word_ptr = '1') then
          pclk_word_ptr <= pclk_word_ptr + 1;
        end if;
      end if;
    end if;
  end process;


  pclk_write_address <= pclk_row_id & pclk_lane_id & std_logic_vector(pclk_word_ptr);



  pclk_write_data(9 downto 0)   <= to_std_logic_vector(pclk_data(0));
  pclk_write_data(19 downto 10) <= to_std_logic_vector(pclk_data(1));
  pclk_write_data(29 downto 20) <= to_std_logic_vector(pclk_data(2));
  pclk_write_data(33 downto 30) <= pclk_sync;
  pclk_write_data(35 downto 34) <= "00";  -- Not used for now


  -----------------------------------------------------------------------------
  -- Line buffer (2xline buffer size to support double buffering)
  -----------------------------------------------------------------------------
  xdual_port_ram : dualPortRamVar
    generic map(
      DATAWIDTH => BUFFER_DATA_WIDTH,
      ADDRWIDTH => BUFFER_ADDR_WIDTH
      )
    port map(
      data      => pclk_write_data,
      rdaddress => sclk_read_address,
      rdclock   => sclk,
      rden      => sclk_read_en,
      wraddress => pclk_write_address,
      wrclock   => pclk,
      wren      => pclk_write_en,
      q         => sclk_read_data
      );


  sclk_read_address <= sclk_buffer_id & sclk_mux_id & std_logic_vector(sclk_word_ptr);
  sclk_sync         <= sclk_read_data(33 downto 30);
  -- sclk_data(0)         <= to_pixel(sclk_read_data(9 downto 0));
  -- sclk_data(1)         <= to_pixel(sclk_read_data(19 downto 10));
  -- sclk_data(2)         <= to_pixel(sclk_read_data(29 downto 20));

  sclk_data <= sclk_read_data(29 downto 0);

end rtl;

