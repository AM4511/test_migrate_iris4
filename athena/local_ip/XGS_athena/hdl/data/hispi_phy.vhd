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
    sclk : in std_logic;
    srst : in std_logic;

    -- Register file information
    idle_character   : in std_logic_vector(PIXEL_SIZE-1 downto 0);
    hispi_phy_en     : in std_logic;
    hispi_soft_reset : in std_logic;

    -- Calibration 
    sclk_cal_en        : in  std_logic;
    sclk_cal_busy      : out std_logic;
    sclk_cal_done      : out std_logic;
    sclk_cal_error     : out std_logic_vector(LANE_PER_PHY-1 downto 0);
    sclk_cal_tap_value : out std_logic_vector((5*LANE_PER_PHY)-1 downto 0);

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
      pclk_cal_en        : in  std_logic;
      pclk_cal_busy      : out std_logic;
      pclk_cal_error     : out std_logic;
      pclk_cal_load_tap  : out std_logic;
      pclk_cal_tap_value : out std_logic_vector(4 downto 0);

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
  end component;


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

  type FSM_STATE_TYPE is (S_IDLE, S_INIT, S_CALIBRATE, S_LOAD_DELAY, S_DONE);

  type SHIFT_REG_ARRAY is array (LANE_PER_PHY - 1 downto 0) of std_logic_vector (HISPI_SHIFT_REGISTER_SIZE - 1 downto 0);
  type REG_ALIGNED_ARRAY is array (LANE_PER_PHY - 1 downto 0) of std_logic_vector (PIXEL_SIZE- 1 downto 0);
  type LANE_DATA_ARRAY is array (LANE_PER_PHY - 1 downto 0) of std_logic_vector (DESERIALIZATION_RATIO - 1 downto 0);
  signal hclk_state : FSM_STATE_TYPE := S_IDLE;

  signal hclk            : std_logic;
  signal hclk_reset_Meta : std_logic := '1';
  signal hclk_reset      : std_logic := '1';

  signal hclk_cal_en                     : std_logic;
  signal hclk_serdes_data                : std_logic_vector(PHY_PARALLEL_WIDTH - 1 downto 0);
  signal hclk_data                       : REG_ALIGNED_ARRAY;
  signal hclk_lane_data                  : LANE_DATA_ARRAY;
  signal hclk_phy_areset                 : std_logic := '0';
  signal hclk_reset_counter              : integer range 0 to PLL_RESET_DURATION;
  signal hclk_fifo_full                  : std_logic;
  signal hclk_fifo_wen                   : std_logic;
  signal hclk_fifo_aggregated_write_data : std_logic_vector(15 downto 0);
  signal hclk_data_valid                 : std_logic;
  signal buffer_address                  : integer;
  signal hclk_decoded_sync               : std_logic_vector(3 downto 0);
  signal hclk_cal_en_vect                : std_logic_vector(3 downto 0);
  signal hclk_cal_busy                   : std_logic;

  signal delay_reset    : std_logic                                     := '0';
  signal delay_tap_in   : std_logic_vector((5*LANE_PER_PHY)-1 downto 0) := (others => '0');
  signal delay_tap_out  : std_logic_vector((5*LANE_PER_PHY)-1 downto 0);
  signal delay_data_ce  : std_logic_vector(LANE_PER_PHY-1 downto 0)     := (others => '0');
  signal delay_data_inc : std_logic_vector(LANE_PER_PHY-1 downto 0)     := (others => '0');

  signal pclk_cal_en        : std_logic;
  signal pclk_cal_busy      : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal pclk_cal_error     : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal pclk_cal_load_tap  : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal pclk_cal_tap_value : std_logic_vector((5*LANE_PER_PHY)-1 downto 0);


  signal sclk_latch_cal_status : std_logic;

begin


  -----------------------------------------------------------------------------
  -- Process      : P_hclk_phy_areset
  -- Clock domain : sclk
  -- Description  : This process generates the SERDES reset.
  -----------------------------------------------------------------------------
  P_hclk_phy_areset : process (sclk) is
  begin

    if (rising_edge(sclk)) then
      if (srst = '1'or hispi_soft_reset = '1') then
        hclk_reset_counter <= 0;
        hclk_phy_areset    <= '1';
      else

        -----------------------------------------------------------------------
        -- pll_reset
        -----------------------------------------------------------------------
        if (hclk_reset_counter = PLL_RESET_DURATION) then
          hclk_phy_areset <= '0';
        else
          hclk_reset_counter <= hclk_reset_counter + 1;
        end if;
      end if;
    end if;
  end process;





  -----------------------------------------------------------------------------
  -- WARNING CLOCK DOMAIN CROSSING!!!
  -- Reset re-synchronisation in the hclk clock domain
  -----------------------------------------------------------------------------
  P_phy_reset : process (hclk_phy_areset, hclk) is
  begin
    if (hclk_phy_areset = '1') then
      hclk_reset_Meta <= '1';
      hclk_reset      <= '1';

    elsif (rising_edge(hclk)) then
      hclk_reset_Meta <= '0';
      hclk_reset      <= hclk_reset_Meta;
    end if;
  end process;



  xhispi_serdes : hispi_serdes
    generic map(
      PHY_SERIAL_WIDTH   => LANE_PER_PHY,
      PHY_PARALLEL_WIDTH => PHY_PARALLEL_WIDTH
      )
    port map(
      async_pll_reset => hclk_phy_areset,
      delay_reset     => delay_reset,
      delay_data_ce   => delay_data_ce,
      delay_data_inc  => delay_data_inc,
      delay_tap_in    => delay_tap_in,
      delay_tap_out   => delay_tap_out,
      rx_in_clock_p   => hispi_serial_clk_p,
      rx_in_clock_n   => hispi_serial_clk_n,
      rx_in_p         => hispi_serial_input_p,
      rx_in_n         => hispi_serial_input_n,
      rx_out_clock    => hclk,
      rx_out          => hclk_serdes_data
      );


  G_lane_decoder : for i in 0 to LANE_PER_PHY-1 generate

    G_parallel_data : for j in 0 to DESERIALIZATION_RATIO-1 generate
      hclk_lane_data(i)(DESERIALIZATION_RATIO-1-j) <= hclk_serdes_data(j *LANE_PER_PHY + i);
    end generate G_parallel_data;

    inst_lane_decoder : lane_decoder
      generic map(
        PHY_OUTPUT_WIDTH => DESERIALIZATION_RATIO,
        PIXEL_SIZE       => PIXEL_SIZE
        )
      port map(
        hclk                 => hclk,
        hclk_reset           => hclk_reset,
        hclk_data_lane       => hclk_lane_data(i),
        rclk_idle_character  => idle_character,
        hispi_phy_en         => hispi_phy_en,
        pclk_cal_en          => pclk_cal_en,
        pclk_cal_busy        => pclk_cal_busy(i),
        pclk_cal_error       => pclk_cal_error(i),
        pclk_cal_load_tap    => pclk_cal_load_tap(i),
        pclk_cal_tap_value   => pclk_cal_tap_value((i*5) + 4 downto (i*5)),
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

  delay_reset <= '1' when (hclk_state = S_LOAD_DELAY) else
                 '0';


  -----------------------------------------------------------------------------
  -- Process      : P_hclk_cal_en_vect
  -- Clock domain : hclk
  -- Description  : Pulse stretcher for the clock domain crossing
  -----------------------------------------------------------------------------
  P_hclk_cal_en_vect : process (hclk) is
  begin
    if (rising_edge(hclk)) then
      if (hclk_reset = '1') then
        hclk_cal_en_vect <= (others => '0');
      else
        if (hclk_state = S_INIT) then
          hclk_cal_en_vect <= (others => '1');
        else
          hclk_cal_en_vect(0) <= '0';
          for i in 1 to hclk_cal_en_vect'left loop
            hclk_cal_en_vect(i) <= hclk_cal_en_vect(i-1);
          end loop;
        end if;
      end if;
    end if;
  end process;


  pclk_cal_en <= hclk_cal_en_vect(hclk_cal_en_vect'left);
  
  -----------------------------------------------------------------------------
  -- Process      : P_hclk_cal_busy
  -- Clock domain : hclk
  -- Description  : 
  -----------------------------------------------------------------------------
  P_hclk_cal_busy : process (hclk) is
  begin
    if (rising_edge(hclk)) then
      if (hclk_reset = '1') then
        hclk_cal_busy <= '0';
      else
        if (hclk_state = S_INIT) then
          hclk_cal_busy <= '1';
        elsif (hclk_state = S_DONE) then
          hclk_cal_busy <= '0';
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Module      : M_hclk_cal_en
  -- Description : Resynchronize sclk_cal_en on hclk domain
  -----------------------------------------------------------------------------
  -- WARNING CLOCK DOMAIN CROSSING!!!
  -----------------------------------------------------------------------------
  M_hclk_cal_en : mtx_resync
    port map (
      aClk  => sclk,
      aClr  => srst,
      aDin  => sclk_cal_en,
      bClk  => hclk,
      bClr  => hclk_reset,
      bDout => hclk_cal_en,
      bRise => open,
      bFall => open
      );


  -----------------------------------------------------------------------------
  -- Module      : M_sclk_cal_busy
  -- Description : Resynchronize hclk_cal_busy on sclk domain
  -----------------------------------------------------------------------------
  -- WARNING CLOCK DOMAIN CROSSING!!!
  -----------------------------------------------------------------------------
  M_sclk_cal_busy : mtx_resync
    port map (
      aClk  => hclk,
      aClr  => hclk_reset,
      aDin  => hclk_cal_busy,
      bClk  => sclk,
      bClr  => srst,
      bDout => sclk_cal_busy,
      bRise => open,
      bFall => sclk_latch_cal_status
      );

  sclk_cal_done<= sclk_latch_cal_status;

  
  -----------------------------------------------------------------------------
  -- Process     : P_hclk_state
  -- Description : Resynchronize pclk_cal_error and pclk_cal_tap_value on sclk
  -- Src clock   : hclk
  -- Dest clock  : sclk
  -----------------------------------------------------------------------------
  -- WARNING CLOCK DOMAIN CROSSING!!!
  -----------------------------------------------------------------------------
  P_sclk_latch_cal_status : process (sclk) is
  begin 
    if (rising_edge(sclk)) then
      if (srst = '1') then
          sclk_cal_error     <= (others=>'0');
          sclk_cal_tap_value <= (others=>'0');
      else
        if (sclk_latch_cal_status = '1') then
          sclk_cal_error     <=pclk_cal_error;
          sclk_cal_tap_value <=pclk_cal_tap_value;
        end if;
      end if;
    end if;
  end process;



  -----------------------------------------------------------------------------
  -- Process     : P_hclk_state
  -- Description : Calibration FSM
  -----------------------------------------------------------------------------
  P_hclk_state : process (hclk) is
  begin
    if (rising_edge(hclk)) then
      if (hclk_reset = '1')then
        hclk_state <= S_IDLE;
      else
        case hclk_state is
          -------------------------------------------------------------------
          -- S_IDLE : 
          -------------------------------------------------------------------
          when S_IDLE =>
            if (hclk_cal_en = '1') then
              hclk_state <= S_INIT;
            else
              hclk_state <= S_IDLE;
            end if;


          -------------------------------------------------------------------
          -- S_INIT : 
          -------------------------------------------------------------------
          when S_INIT =>
            hclk_state <= S_CALIBRATE;

          -------------------------------------------------------------------
          -- S_CALIBRATE : 
          -------------------------------------------------------------------
          when S_CALIBRATE =>
            if (pclk_cal_busy = (pclk_cal_busy'range => '0')) then
              hclk_state <= S_LOAD_DELAY;

            else
              hclk_state <= S_CALIBRATE;
            end if;

          -------------------------------------------------------------------
          -- S_LOAD_DELAY : 
          -------------------------------------------------------------------
          when S_LOAD_DELAY =>
            hclk_state <= S_DONE;

          -------------------------------------------------------------------
          -- S_DONE : 
          -------------------------------------------------------------------
          when S_DONE =>
            hclk_state <= S_IDLE;

          -------------------------------------------------------------------
          -- 
          -------------------------------------------------------------------
          when others =>
            null;
        end case;
      end if;
    end if;
  end process;


end architecture rtl;
