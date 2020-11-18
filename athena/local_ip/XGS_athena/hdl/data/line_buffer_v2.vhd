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
    pclk                : in  std_logic;
    pclk_reset          : in  std_logic;
    pclk_init           : in  std_logic;
    pclk_write_en       : in  std_logic;
    pclk_data           : in  PIXEL_ARRAY(2 downto 0);
    pclk_sync           : in  std_logic_vector(3 downto 0);
    pclk_buffer_id      : in  std_logic_vector(1 downto 0);
    pclk_mux_id         : in  std_logic_vector(1 downto 0);
    pclk_word_ptr       : in  std_logic_vector(WORD_PTR_WIDTH-1 downto 0);
    pclk_set_buff_ready : in  std_logic_vector(3 downto 0);
    pclk_buff_ready     : out std_logic_vector(3 downto 0);


    ---------------------------------------------------------------------
    -- Line buffer interface
    ---------------------------------------------------------------------
    sclk           : in  std_logic;
    sclk_reset     : in  std_logic;
    sclk_empty     : out std_logic;
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


  component mtx_resync is
    port
      (
        aClk  : in  std_logic;
        aClr  : in  std_logic;
        aDin  : in  std_logic;
        bclk  : in  std_logic;
        bclr  : in  std_logic;
        bDout : out std_logic;
        bRise : out std_logic;
        bFall : out std_logic
        );
  end component;


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

  --type PCLK_FSM_TYPE is (S_IDLE, S_WAIT_LINE, S_SOF, S_SOL, S_WRITE, S_TOGGLE_BUFFER, S_EOL, S_EOF, S_DONE);
  type OUTPUT_FSM_TYPE is (S_IDLE, S_WAIT_LINE, S_INIT, S_TRANSFER, S_EOL, S_END_OF_DMA, S_DONE);
  type WORD_COUNT_ARRAY is array (3 downto 0) of unsigned(WORD_PTR_WIDTH+2-1 downto 0);

  constant LINE_PTR_WIDTH    : integer := 2;
  constant LANE_PTR_WIDTH    : integer := 2;
  constant BUFFER_ADDR_WIDTH : integer := LINE_PTR_WIDTH + LANE_PTR_WIDTH + WORD_PTR_WIDTH;  -- in bits
  constant BUFFER_DATA_WIDTH : integer := 36;



  constant BUFFER_LINE_PTR_WIDTH : integer := 3;  -- in bits
  constant BUFFER_WORD_PTR_WIDTH : integer := (BUFFER_ADDR_WIDTH - BUFFER_LINE_PTR_WIDTH);

  --signal pclk_state         : PCLK_FSM_TYPE := S_IDLE;
  signal pclk_write_address : std_logic_vector(BUFFER_ADDR_WIDTH - 1 downto 0);
  signal pclk_write_data    : std_logic_vector(BUFFER_DATA_WIDTH-1 downto 0);
  --signal pclk_word_count    : WORD_COUNT_ARRAY;


  signal sclk_read_address     : std_logic_vector(BUFFER_ADDR_WIDTH - 1 downto 0);
  signal sclk_read_data        : std_logic_vector(BUFFER_DATA_WIDTH-1 downto 0);
  signal sclk_buffer_empty     : std_logic;
  signal sclk_set_buff_ready   : std_logic_vector(3 downto 0);
  signal sclk_buff_ready_ff    : std_logic_vector(3 downto 0);
  signal sclk_word_count_array : WORD_COUNT_ARRAY;

begin


  -----------------------------------------------------------------------------
  -- Module      :
  -- Description : 
  -----------------------------------------------------------------------------
  -- P_pclk_work_count : process (pclk) is
  -- begin
  --   if (rising_edge(sclk)) then
  --     if (sclk_reset = '1')then
  --       pclk_word_count <= (others => (others => '0'));
  --     else
  --       if (pclk_write_en = '1') then
  --         for i in 0 to 3 loop
  --           if (i = to_integer(unsigned(pclk_buffer_id))) then
  --             pclk_word_count(i) <= unsigned(pclk_word_ptr);
  --           end if;
  --         end loop;
  --       end if;
  --     end if;
  --   end if;
  -- end process;


  pclk_write_address <= pclk_buffer_id & pclk_mux_id & pclk_word_ptr;



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



  G_resync : for i in 0 to 3 generate


    M_sclk_set_buff_ready_resync : mtx_resync
      port map (
        aClk  => pclk,
        aClr  => pclk_reset,
        aDin  => pclk_set_buff_ready(i),
        bclk  => sclk,
        bclr  => sclk_reset,
        bDout => open,
        bRise => sclk_set_buff_ready(i),
        bFall => open
        );

    M_pclk_set_buff_ready_resync : mtx_resync
      port map (
        aClk  => sclk,
        aClr  => sclk_reset,
        aDin  => sclk_buff_ready_ff(i),
        bclk  => pclk,
        bclr  => pclk_reset,
        bDout => pclk_buff_ready(i),
        bRise => open,
        bFall => open
        );

  end generate G_resync;


  -----------------------------------------------------------------------------
  -- Process     :sclk_buff_ready_ff
  -- Description : 
  -----------------------------------------------------------------------------
  P_sclk_buff_ready_ff : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1')then
        sclk_buff_ready_ff <= (others => '0');
      else
        for i in 0 to 3 loop
          if (sclk_set_buff_ready(i) = '1') then
            sclk_buff_ready_ff(i) <= '1';
          elsif (i = to_integer(unsigned(sclk_buffer_id)) and sclk_buffer_empty = '1') then
            sclk_buff_ready_ff(i) <= '0';
          end if;
        end loop;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     :
  -- Description : 
  -----------------------------------------------------------------------------
  -- WARNING CLOCK DOMAIN CROSSING!!!
  -----------------------------------------------------------------------------
  P_sclk_word_count_array : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1')then
        sclk_word_count_array <= (others => (others => '0'));
      else
        for i in 0 to 3 loop
          if (sclk_set_buff_ready(i) = '1') then
            -- synthesis translate_off
            -- Test the buffer is empty. It must always be empty before
            -- starting filling, otherwise it is an overflow
            assert (sclk_word_count_array(i) = 0) report "line buffer overrun" severity error;
            -- synthesis translate_on

            -- pclk_word_count(i) is assumed to be stabled
            -- when sclk_set_buff_ready(i) = '1'
            sclk_word_count_array(i) <= unsigned(pclk_word_ptr) & "11";



          elsif (i = to_integer(unsigned(sclk_buffer_id)) and sclk_read_en = '1') then
            -- synthesis translate_off
            -- Test the buffer is not empty. It must always contain data when
            -- reading from it, otherwise it is an underflow
            assert (sclk_word_count_array(i) > 0) report "line buffer underrun" severity error;
            -- synthesis translate_on

            sclk_word_count_array(i) <= sclk_word_count_array(i)-1;
          end if;
        end loop;
      end if;
    end if;
  end process;




  -----------------------------------------------------------------------------
  -- Process     : P_sclk_buff_empty
  -- Description : Indicates if line buffer pointed by sclk_buffer_id is empty  
  -----------------------------------------------------------------------------
  P_sclk_buff_empty : process (sclk_buffer_id, sclk_word_count_array) is
    variable i : integer range 0 to 3;
  begin

    i := to_integer(unsigned(sclk_buffer_id));
    
    if (sclk_word_count_array(i) = (sclk_word_count_array(i)'range => '0'))then
      sclk_buffer_empty <= '1';
    else
      sclk_buffer_empty <= '0';
    end if;
  end process;


  sclk_empty <= sclk_buffer_empty;


  sclk_read_address <= sclk_buffer_id & sclk_mux_id & sclk_word_ptr;
  sclk_sync <= sclk_read_data(33 downto 30);
  sclk_data <= sclk_read_data(29 downto 0);

end rtl;

