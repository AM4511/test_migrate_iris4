-----------------------------------------------------------------------
-- MODULE        : line_buffer
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


entity line_buffer is
  generic (
    WORD_PTR_WIDTH : integer := 6
    );
  port (
    ---------------------------------------------------------------------
    -- Pixel clock domain
    ---------------------------------------------------------------------
    pclk            : in  std_logic;
    pclk_reset      : in  std_logic;
    pclk_init       : in  std_logic;
    pclk_write_en   : in  std_logic;
    pclk_data       : in  PIXEL_ARRAY(2 downto 0);
    pclk_nxt_buffer : in  std_logic;
    pclk_full       : out std_logic;
    pclk_mux_id     : in  std_logic_vector(1 downto 0);
    pclk_word_ptr   : in  std_logic_vector(WORD_PTR_WIDTH-1 downto 0);

    ---------------------------------------------------------------------
    -- Line buffer interface
    ---------------------------------------------------------------------
    sclk               : in  std_logic;
    sclk_reset         : in  std_logic;
    sclk_lane_enable   : in  std_logic;
    sclk_read_en       : in  std_logic;
    sclk_empty         : out std_logic;
    sclk_transfer_done : in  std_logic;
    sclk_mux_id        : in  std_logic_vector(1 downto 0);
    sclk_word_ptr      : in  std_logic_vector(WORD_PTR_WIDTH-1 downto 0);
    sclk_data          : out PIXEL_ARRAY(2 downto 0)
    );
end line_buffer;


architecture rtl of line_buffer is

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


  constant LINE_PTR_WIDTH        : integer := 2;
  constant LANE_PTR_WIDTH        : integer := 2;
  constant BUFFER_ADDR_WIDTH     : integer := LINE_PTR_WIDTH + LANE_PTR_WIDTH + WORD_PTR_WIDTH;  -- in bits
  constant BUFFER_DATA_WIDTH     : integer := 36;
  constant BUFFER_LINE_PTR_WIDTH : integer := 3;  -- in bits
  constant BUFFER_WORD_PTR_WIDTH : integer := (BUFFER_ADDR_WIDTH - BUFFER_LINE_PTR_WIDTH);

  signal pclk_write_address : std_logic_vector(BUFFER_ADDR_WIDTH - 1 downto 0);
  signal pclk_write_data    : std_logic_vector(BUFFER_DATA_WIDTH-1 downto 0);
  signal pclk_buffer_ptr    : std_logic_vector(1 downto 0);


  signal sclk_read_address : std_logic_vector(BUFFER_ADDR_WIDTH - 1 downto 0);
  signal sclk_read_data    : std_logic_vector(BUFFER_DATA_WIDTH-1 downto 0);
  signal sclk_buffer_ptr   : std_logic_vector(1 downto 0);
  signal sclk_full         : std_logic;
  signal sclk_buffer_rdy   : std_logic;
  signal sclk_used_buffer  : std_logic_vector(1 downto 0);
  signal sclk_init         : std_logic;

  
  -----------------------------------------------------------------------------
  -- Debug attributes 
  -----------------------------------------------------------------------------
  attribute mark_debug of pclk_write_address : signal is "true";


begin



  -----------------------------------------------------------------------------
  -- Process     : P_pclk_buffer_ptr
  -- Description : Modulo 4 buffer counter. 
  -----------------------------------------------------------------------------
  P_pclk_buffer_ptr : process (pclk) is
  begin
    if (rising_edge(pclk)) then
      if (pclk_reset = '1') then
        pclk_buffer_ptr <= (others => '0');
      else
        if (pclk_init = '1') then
          pclk_buffer_ptr <= (others => '0');
        elsif (pclk_nxt_buffer = '1') then
          pclk_buffer_ptr <= pclk_buffer_ptr + 1;
        end if;
      end if;
    end if;
  end process;





  pclk_write_data(9 downto 0)   <= to_std_logic_vector(pclk_data(0));
  pclk_write_data(19 downto 10) <= to_std_logic_vector(pclk_data(1));
  pclk_write_data(29 downto 20) <= to_std_logic_vector(pclk_data(2));
  pclk_write_data(35 downto 30) <= "000000";  -- Not used for now


  M_sclk_init : mtx_resync
    port map (
      aClk  => pclk,
      aClr  => pclk_reset,
      aDin  => pclk_init,
      bclk  => sclk,
      bclr  => sclk_reset,
      bDout => open,
      bRise => sclk_init,
      bFall => open
      );


  M_sclk_buffer_rdy : mtx_resync
    port map (
      aClk  => pclk,
      aClr  => pclk_reset,
      aDin  => pclk_nxt_buffer,
      bclk  => sclk,
      bclr  => sclk_reset,
      bDout => open,
      bRise => sclk_buffer_rdy,
      bFall => open
      );

  pclk_write_address <= pclk_buffer_ptr & pclk_mux_id & pclk_word_ptr;

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

  sclk_read_address <= sclk_buffer_ptr & sclk_mux_id & sclk_word_ptr;

  M_pclk_full : mtx_resync
    port map (
      aClk  => sclk,
      aClr  => sclk_reset,
      aDin  => sclk_full,
      bclk  => pclk,
      bclr  => pclk_reset,
      bDout => pclk_full,
      bRise => open,
      bFall => open
      );


  -----------------------------------------------------------------------------
  -- Process     : P_sclk_buffer_ptr
  -- Description : 
  -----------------------------------------------------------------------------
  P_sclk_buffer_ptr : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1' or sclk_lane_enable = '0') then
        sclk_buffer_ptr <= (others => '0');
      else
        if (sclk_init = '1') then
          sclk_buffer_ptr <= (others => '0');
        elsif (sclk_transfer_done = '1') then
          sclk_buffer_ptr <= sclk_buffer_ptr + 1;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_sclk_used_buffer
  -- Description : 
  -----------------------------------------------------------------------------
  P_sclk_used_buffer : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1' or sclk_lane_enable = '0')then
        sclk_used_buffer <= (others => '0');
      else
        if (sclk_init = '1') then
          sclk_used_buffer <= (others => '0');
        elsif (sclk_buffer_rdy = '1' and sclk_transfer_done = '0') then
          sclk_used_buffer <= sclk_used_buffer+1;
        elsif (sclk_buffer_rdy = '0' and sclk_transfer_done = '1') then
          sclk_used_buffer <= sclk_used_buffer-1;
        else
          sclk_used_buffer <= sclk_used_buffer;
        end if;
      end if;
    end if;
  end process;


  sclk_full <= '1' when (sclk_used_buffer = "11") else
               '0';


  sclk_empty <= '1' when (sclk_used_buffer = "00") else
                '0';


  sclk_data(0) <= to_pixel(sclk_read_data(9 downto 0));
  sclk_data(1) <= to_pixel(sclk_read_data(19 downto 10));
  sclk_data(2) <= to_pixel(sclk_read_data(29 downto 20));

end rtl;

