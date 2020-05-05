--
-- interface an Aptina 4-lane 20 bit per pixel or 2-lane 14 bit per pixel hispi device to Avalon-ST Video interface.
-- Note that readyLatency = 1 for the Avalon-ST Video protocol.
--
-- An Avalon MM slave interface provides access to 32-bit control and status registers. These are:
-- Address 0 (byte address 0x00): Pixels per line. Defaults to MAX_PIXELS_PER_LINE.
-- Address 1 (byte address 0x04): Lines per frame. Defaults to MAX_LINES_PER_FRAME.
-- Address 2 (bytes address0x08): Control and status.
--      Bit 0: reset active high. resets the hispi circuitry including the deserializer pll's. initializes to 0.
--  Bit 1: enable capture and avalon streaming. current frame continues until end. initializes to 0.
--  Bit 2: hispi deserializer lock signal. read only.
-- proper sequence is, disable capture and streaming.
-- wait until current frame is done
-- program pixels per line and lines per frame registers
-- reset hispi circuitry
-- program imager to new frame geometry
-- unreset hispi circuitry
-- wait for hispi deserializer lock
-- enable capture
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.mtx_types_pkg.all;
use work.hispi_pack.all;

entity hispi_phy is
  generic (
    LANE_PER_PHY : integer := 3;        -- Physical lane
    PIXEL_SIZE   : integer := 12        -- Pixel size in bits
    );
  port (
    sysclk : in std_logic;
    sysrst : in std_logic;

    -- Register file information
    idle_character   : in std_logic_vector(PIXEL_SIZE-1 downto 0);
    hispi_phy_en     : in std_logic;
    hispi_soft_reset : in std_logic;

    -- Calibration 
    cal_en        : in  std_logic;
    cal_busy      : out std_logic_vector(LANE_PER_PHY-1 downto 0);
    cal_error     : out std_logic_vector(LANE_PER_PHY-1 downto 0);
    cal_load_tap  : out std_logic_vector(LANE_PER_PHY-1 downto 0);
    cal_tap_value : out std_logic_vector((5*LANE_PER_PHY)-1 downto 0);

    -- HiSPi IO
    hispi_serial_clk_p   : in std_logic;
    hispi_serial_clk_n   : in std_logic;
    hispi_serial_input_p : in std_logic_vector(LANE_PER_PHY - 1 downto 0);
    hispi_serial_input_n : in std_logic_vector(LANE_PER_PHY - 1 downto 0);

    -- Read fifo interface
    fifo_read_clk        : in  std_logic;
    fifo_read_en         : in  std_logic_vector(LANE_PER_PHY-1 downto 0);
    fifo_empty           : out std_logic_vector(LANE_PER_PHY-1 downto 0);
    fifo_read_data_valid : out std_logic_vector(LANE_PER_PHY-1 downto 0);
    fifo_read_data       : out std32_logic_vector(LANE_PER_PHY-1 downto 0);

    -- Flags detected
    embeded_data : out std_logic_vector(LANE_PER_PHY-1 downto 0);
    sof_flag     : out std_logic_vector(LANE_PER_PHY-1 downto 0);
    eof_flag     : out std_logic_vector(LANE_PER_PHY-1 downto 0);
    sol_flag     : out std_logic_vector(LANE_PER_PHY-1 downto 0);
    eol_flag     : out std_logic_vector(LANE_PER_PHY-1 downto 0)
    );

end entity hispi_phy;


architecture rtl of hispi_phy is


  component hispi_serdes is
    generic (
      PHY_SERIAL_WIDTH   : integer := 1;
      PHY_PARALLEL_WIDTH : integer := 6
      );
    port (
      async_pll_reset : in  std_logic;
      delay_reset     : in  std_logic;
      delay_data_ce   : in  std_logic_vector(PHY_SERIAL_WIDTH-1 downto 0);
      delay_data_inc  : in  std_logic_vector(PHY_SERIAL_WIDTH-1 downto 0);
      delay_tap_in    : in  std_logic_vector((5*PHY_SERIAL_WIDTH)-1 downto 0);
      delay_tap_out   : out std_logic_vector((5*PHY_SERIAL_WIDTH)-1 downto 0);
      rx_in_clock_p   : in  std_logic;
      rx_in_clock_n   : in  std_logic;
      rx_in_p         : in  std_logic_vector (PHY_SERIAL_WIDTH-1 downto 0);
      rx_in_n         : in  std_logic_vector (PHY_SERIAL_WIDTH-1 downto 0);
      rx_out_clock    : out std_logic;
      rx_out          : out std_logic_vector (PHY_PARALLEL_WIDTH-1 downto 0)
      );
  end component;


  component lane_decoder is
    generic (
      PHY_OUTPUT_WIDTH : integer := 6;   -- Physical lane
      PIXEL_SIZE       : integer := 12;  -- Pixel size in bits
      LANE_DATA_WIDTH  : integer := 32
      );
    port (
      ---------------------------------------------------------------------------
      -- hispi_clk clock domain
      ---------------------------------------------------------------------------
      hclk           : in std_logic;
      hclk_reset     : in std_logic;
      hclk_data_lane : in std_logic_vector(PHY_OUTPUT_WIDTH-1 downto 0);

      ---------------------------------------------------------------------------
      -- Register file 
      ---------------------------------------------------------------------------
      rclk_idle_character : in std_logic_vector(PIXEL_SIZE-1 downto 0);
      hispi_phy_en        : in std_logic;

      -- calibration
      cal_en        : in  std_logic;
      cal_busy      : out std_logic;
      cal_error     : out std_logic;
      cal_load_tap  : out std_logic;
      cal_tap_value : out std_logic_vector(4 downto 0);


      -- Read fifo interface
      fifo_read_clk        : in  std_logic;
      fifo_read_en         : in  std_logic;
      fifo_empty           : out std_logic;
      fifo_read_data_valid : out std_logic;
      fifo_read_data       : out std_logic_vector(LANE_DATA_WIDTH-1 downto 0);

      -- Flags detected
      embeded_data : out std_logic;
      sof_flag     : out std_logic;
      eof_flag     : out std_logic;
      sol_flag     : out std_logic;
      eol_flag     : out std_logic
      );
  end component lane_decoder;


  constant DESERIALIZATION_RATIO     : integer := 6;
  constant PHY_PARALLEL_WIDTH        : integer := LANE_PER_PHY*DESERIALIZATION_RATIO;  -- Width in bit
  constant HISPI_PIXELS              : integer := 2;  -- 2 pixels are transferred in parallel over hispi
  constant HISPI_WORDS_PER_SYNC_CODE : integer := 4;  -- It takes 4 HiSpi words to contain a sync_code code (SOF, SOL, EOF, EOL)
  constant HISPI_SHIFT_REGISTER_SIZE : integer := (PIXEL_SIZE * (HISPI_WORDS_PER_SYNC_CODE+1)) + DESERIALIZATION_RATIO;
  constant PLL_RESET_DURATION        : integer := 15;
  constant HISPI_RESET_DURATION      : integer := 100;
  constant HSPI_SYNC_SIZE            : integer := 4;


  constant FRAME_FLAG_BIT     : integer := PIXEL_SIZE-2;
  constant START_FLAG_BIT     : integer := PIXEL_SIZE-3;
  constant EMBEDDED_FLAG_BIT  : integer := PIXEL_SIZE-5;
  constant FIFO_ADDRESS_WIDTH : integer := 4;
  constant MUX_RATIO          : integer := 4;

  type SHIFT_REG_ARRAY is array (LANE_PER_PHY - 1 downto 0) of std_logic_vector (HISPI_SHIFT_REGISTER_SIZE - 1 downto 0);
  type REG_ALIGNED_ARRAY is array (LANE_PER_PHY - 1 downto 0) of std_logic_vector (PIXEL_SIZE- 1 downto 0);
  type LANE_DATA_ARRAY is array (LANE_PER_PHY - 1 downto 0) of std_logic_vector (DESERIALIZATION_RATIO - 1 downto 0);


  signal hispi_reset                      : std_logic := '1';
  signal hispi_reset_Meta                 : std_logic := '1';
  signal hispi_clk                        : std_logic;
  signal hispi_serdes_data                : std_logic_vector(PHY_PARALLEL_WIDTH - 1 downto 0);
  signal hispi_data                       : REG_ALIGNED_ARRAY;
  signal hispi_lane_data                  : LANE_DATA_ARRAY;
  signal hispi_phy_areset                 : std_logic := '0';
  signal hispi_reset_counter              : integer range 0 to PLL_RESET_DURATION;
  signal hispi_fifo_full                  : std_logic;
  signal hispi_fifo_wen                   : std_logic;
  signal hispi_fifo_aggregated_write_data : std_logic_vector(15 downto 0);
  signal hispi_data_valid                 : std_logic;
  signal buffer_address                   : integer;
  signal hispi_decoded_sync               : std_logic_vector(3 downto 0);

  signal delay_reset    : std_logic                                     := '0';
  signal delay_data_ce  : std_logic_vector(LANE_PER_PHY-1 downto 0)     := (others => '0');
  signal delay_data_inc : std_logic_vector(LANE_PER_PHY-1 downto 0)     := (others => '0');
  signal delay_tap_in   : std_logic_vector((5*LANE_PER_PHY)-1 downto 0) := (others => '0');
  signal delay_tap_out  : std_logic_vector((5*LANE_PER_PHY)-1 downto 0);


begin


  -----------------------------------------------------------------------------
  -- Process      : P_hispi_phy_areset
  -- Clock domain : sysclk
  -- Description  : This process generates the SERDES reset.
  -----------------------------------------------------------------------------
  P_hispi_phy_areset : process (sysclk) is
  begin

    if (rising_edge(sysclk)) then
      if (sysrst = '1'or hispi_soft_reset = '1') then
        hispi_reset_counter <= 0;
        hispi_phy_areset    <= '1';
      else

        -----------------------------------------------------------------------
        -- pll_reset
        -----------------------------------------------------------------------
        if (hispi_reset_counter = PLL_RESET_DURATION) then
          hispi_phy_areset <= '0';
        else
          hispi_reset_counter <= hispi_reset_counter + 1;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- WARNING CLOCK DOMAIN CROSSING!!!
  -- Reset re-synchronisation in the hispi_clk clock domain
  -----------------------------------------------------------------------------
  P_phy_reset : process (hispi_phy_areset, hispi_clk) is
  begin
    if (hispi_phy_areset = '1') then
      hispi_reset_Meta <= '1';
      hispi_reset      <= '1';

    elsif (rising_edge(hispi_clk)) then
      hispi_reset_Meta <= '0';
      hispi_reset      <= hispi_reset_Meta;
    end if;
  end process;


  xhispi_serdes : hispi_serdes
    generic map(
      PHY_SERIAL_WIDTH   => LANE_PER_PHY,
      PHY_PARALLEL_WIDTH => PHY_PARALLEL_WIDTH
      )
    port map(
      async_pll_reset => hispi_phy_areset,
      delay_reset     => delay_reset,
      delay_data_ce   => delay_data_ce,
      delay_data_inc  => delay_data_inc,
      delay_tap_in    => delay_tap_in,
      delay_tap_out   => delay_tap_out,
      rx_in_clock_p   => hispi_serial_clk_p,
      rx_in_clock_n   => hispi_serial_clk_n,
      rx_in_p         => hispi_serial_input_p,
      rx_in_n         => hispi_serial_input_n,
      rx_out_clock    => hispi_clk,
      rx_out          => hispi_serdes_data
      );


  G_lane_decoder : for i in 0 to LANE_PER_PHY-1 generate

    G_parallel_data : for j in 0 to DESERIALIZATION_RATIO-1 generate
      hispi_lane_data(i)(DESERIALIZATION_RATIO-1-j) <= hispi_serdes_data(j *LANE_PER_PHY + i);
    end generate G_parallel_data;

    inst_lane_decoder : lane_decoder
      generic map(
        PHY_OUTPUT_WIDTH => DESERIALIZATION_RATIO,
        PIXEL_SIZE       => PIXEL_SIZE
        )
      port map(
        hclk                 => hispi_clk,
        hclk_reset           => hispi_reset,
        hclk_data_lane       => hispi_lane_data(i),
        rclk_idle_character  => idle_character,
        hispi_phy_en         => hispi_phy_en,
        cal_en               => cal_en,
        cal_busy             => cal_busy(i),
        cal_error            => cal_error(i),
        cal_load_tap         => cal_load_tap(i),
        cal_tap_value        => cal_tap_value((i*5) + 4 downto (i*5)),
        fifo_read_clk        => fifo_read_clk,
        fifo_read_en         => fifo_read_en(i),
        fifo_empty           => fifo_empty(i),
        fifo_read_data_valid => fifo_read_data_valid(i),
        fifo_read_data       => fifo_read_data(i),
        embeded_data         => embeded_data(i),
        sof_flag             => sof_flag(i),
        eof_flag             => eof_flag(i),
        sol_flag             => sol_flag(i),
        eol_flag             => eol_flag(i)
        );
  end generate G_lane_decoder;




end architecture rtl;
