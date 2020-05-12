-------------------------------------------------------------------------------
-- MODULE        : hispi_phy
--
-- DESCRIPTION   : 
--
-- CLOCK DOMAINS : 
--                 
--                 
--
-- TODO          : Clarify clock domain crossing
--                 Remove sclk and srst
--
-------------------------------------------------------------------------------

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
    ---------------------------------------------------------------------------
    -- HiSPi IO
    ---------------------------------------------------------------------------
    hispi_serial_clk_p   : in std_logic;
    hispi_serial_clk_n   : in std_logic;
    hispi_serial_input_p : in std_logic_vector(LANE_PER_PHY - 1 downto 0);
    hispi_serial_input_n : in std_logic_vector(LANE_PER_PHY - 1 downto 0);

    ---------------------------------------------------------------------------
    -- axi_clk clock domain
    ---------------------------------------------------------------------------
    aclk       : in std_logic;
    aclk_reset : in std_logic;

    -- Register file information
    aclk_idle_character : in std_logic_vector(PIXEL_SIZE-1 downto 0);
    aclk_hispi_phy_en   : in std_logic;

    -- To XGS_controller
    hispi_pix_clk : out std_logic;

    -- Calibration
    aclk_manual_calibration_en   : in std_logic;
    aclk_manual_calibration_load : in std_logic;
    aclk_manual_calibration_tap  : in std_logic_vector(14 downto 0);

    aclk_reset_phy         : in  std_logic;
    aclk_start_calibration : in  std_logic;
    aclk_cal_done          : out std_logic;
    aclk_cal_error         : out std_logic_vector(LANE_PER_PHY-1 downto 0);
    aclk_cal_tap_value     : out std_logic_vector((5*LANE_PER_PHY)-1 downto 0);

    -- Read fifo interface
    aclk_fifo_read_en         : in  std_logic_vector(LANE_PER_PHY-1 downto 0);
    aclk_fifo_empty           : out std_logic_vector(LANE_PER_PHY-1 downto 0);
    aclk_fifo_read_data_valid : out std_logic_vector(LANE_PER_PHY-1 downto 0);
    aclk_fifo_read_data       : out std32_logic_vector(LANE_PER_PHY-1 downto 0);
    aclk_fifo_overrun         : out std_logic_vector(LANE_PER_PHY-1 downto 0);
    aclk_fifo_underrun        : out std_logic_vector(LANE_PER_PHY-1 downto 0);

    -- Flags 
    aclk_bit_locked      : out std_logic_vector(LANE_PER_PHY-1 downto 0);
    aclk_bit_locked_rise : out std_logic_vector(LANE_PER_PHY-1 downto 0);
    aclk_bit_locked_fall : out std_logic_vector(LANE_PER_PHY-1 downto 0);
    aclk_embeded_data    : out std_logic_vector(LANE_PER_PHY-1 downto 0);
    aclk_sof_flag        : out std_logic_vector(LANE_PER_PHY-1 downto 0);
    aclk_eof_flag        : out std_logic_vector(LANE_PER_PHY-1 downto 0);
    aclk_sol_flag        : out std_logic_vector(LANE_PER_PHY-1 downto 0);
    aclk_eol_flag        : out std_logic_vector(LANE_PER_PHY-1 downto 0)
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

      -- calibration
      pix_clk            : out std_logic;
      pclk_cal_en        : in  std_logic;
      pclk_cal_busy      : out std_logic;
      pclk_cal_error     : out std_logic;
      pclk_cal_load_tap  : out std_logic;
      pclk_cal_tap_value : out std_logic_vector(4 downto 0);


      ---------------------------------------------------------------------------
      -- axi_clk clock domain
      ---------------------------------------------------------------------------
      aclk       : in std_logic;
      aclk_reset : in std_logic;

      -- Register file 
      aclk_idle_character : in std_logic_vector(PIXEL_SIZE-1 downto 0);
      aclk_hispi_phy_en   : in std_logic;

      -- Read fifo interface
      aclk_fifo_read_en         : in  std_logic;
      aclk_fifo_empty           : out std_logic;
      aclk_fifo_read_data_valid : out std_logic;
      aclk_fifo_read_data       : out std_logic_vector(LANE_DATA_WIDTH-1 downto 0);
      aclk_fifo_overrun         : out std_logic;
      aclk_fifo_underrun        : out std_logic;

      -- Flags 
      aclk_bit_locked      : out std_logic;
      aclk_bit_locked_rise : out std_logic;
      aclk_bit_locked_fall : out std_logic;
      aclk_embeded_data    : out std_logic;
      aclk_sof_flag        : out std_logic;
      aclk_eof_flag        : out std_logic;
      aclk_sol_flag        : out std_logic;
      aclk_eol_flag        : out std_logic
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


  attribute mark_debug : string;
  attribute keep       : string;

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

  signal hclk                         : std_logic;
  signal hclk_reset_vect              : std_logic_vector(2 downto 0);
  signal hclk_reset                   : std_logic      := '1';
  signal hclk_state                   : FSM_STATE_TYPE := S_IDLE;
  signal hclk_start_calibration       : std_logic;
  signal hclk_serdes_data             : std_logic_vector(PHY_PARALLEL_WIDTH - 1 downto 0);
  signal hclk_lane_data               : LANE_DATA_ARRAY;
  signal hclk_manual_calibration_load : std_logic;

  signal delay_reset    : std_logic                                     := '0';
  signal delay_tap_in   : std_logic_vector((5*LANE_PER_PHY)-1 downto 0) := (others => '0');
  signal delay_tap_out  : std_logic_vector((5*LANE_PER_PHY)-1 downto 0);
  signal delay_data_ce  : std_logic_vector(LANE_PER_PHY-1 downto 0)     := (others => '0');
  signal delay_data_inc : std_logic_vector(LANE_PER_PHY-1 downto 0)     := (others => '0');

  signal pclk_cal_en   : std_logic;
  signal pclk_cal_busy : std_logic_vector(LANE_PER_PHY-1 downto 0);

  signal pclk_cal_error     : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal pclk_cal_load_tap  : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal pclk_cal_tap_value : std_logic_vector((5*LANE_PER_PHY)-1 downto 0);
  signal pix_clk            : std_logic_vector(LANE_PER_PHY-1 downto 0);

  signal aclk_latch_cal_status  : std_logic;
  signal aclk_hispi_phy_en_ff   : std_logic;
  signal aclk_hispi_phy_en_rise : std_logic;


  attribute mark_debug of hclk_reset_vect              : signal is "true";
  attribute mark_debug of hclk_reset                   : signal is "true";
  attribute mark_debug of hclk_state                   : signal is "true";
  attribute mark_debug of hclk_start_calibration       : signal is "true";
  attribute mark_debug of hclk_serdes_data             : signal is "true";
  attribute mark_debug of hclk_manual_calibration_load : signal is "true";

  attribute mark_debug of pclk_cal_en        : signal is "true";
  attribute mark_debug of pclk_cal_busy      : signal is "true";
  attribute mark_debug of pclk_cal_error     : signal is "true";
  attribute mark_debug of pclk_cal_load_tap  : signal is "true";
  attribute mark_debug of pclk_cal_tap_value : signal is "true";
  attribute mark_debug of pix_clk            : signal is "true";

  attribute mark_debug of aclk_latch_cal_status  : signal is "true";
  attribute mark_debug of aclk_hispi_phy_en_ff   : signal is "true";
  attribute mark_debug of aclk_hispi_phy_en_rise : signal is "true";

  attribute mark_debug of delay_reset    : signal is "true";
  attribute mark_debug of delay_tap_in   : signal is "true";
  attribute mark_debug of delay_tap_out  : signal is "true";
  attribute mark_debug of delay_data_ce  : signal is "true";
  attribute mark_debug of delay_data_inc : signal is "true";


begin


  -----------------------------------------------------------------------------
  -- WARNING CLOCK DOMAIN CROSSING!!!
  -- aclk_reset re-synchronisation in the hclk clock domain
  -----------------------------------------------------------------------------
  P_hclk_reset : process (aclk_reset, hclk) is
  begin
    if (aclk_reset = '1') then
      hclk_reset_vect <= (others => '1');
      hclk_reset      <= '1';

    elsif (rising_edge(hclk)) then
      hclk_reset_vect(0)                             <= '0';
      hclk_reset_vect(hclk_reset_vect'left downto 1) <= hclk_reset_vect(hclk_reset_vect'left -1 downto 0);
      hclk_reset                                     <= hclk_reset_vect(hclk_reset_vect'left);
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_aclk_hispi_phy_en_ff
  -- Description : 
  -----------------------------------------------------------------------------
  P_aclk_hispi_phy_en_ff : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1') then
        aclk_hispi_phy_en_ff   <= '0';
        aclk_hispi_phy_en_rise <= '0';
      else
        aclk_hispi_phy_en_ff <= aclk_hispi_phy_en;
        if (aclk_hispi_phy_en = '1' and aclk_hispi_phy_en_ff = '0') then
          aclk_hispi_phy_en_rise <= '1';
        else
          aclk_hispi_phy_en_rise <= '0';
        end if;
      end if;
    end if;
  end process;



  xhispi_serdes : hispi_serdes
    generic map(
      PHY_SERIAL_WIDTH   => LANE_PER_PHY,
      PHY_PARALLEL_WIDTH => PHY_PARALLEL_WIDTH
      )
    port map(
      async_pll_reset => aclk_reset_phy,
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
        hclk                      => hclk,
        hclk_reset                => hclk_reset,
        hclk_data_lane            => hclk_lane_data(i),
        pix_clk                   => pix_clk(i),
        pclk_cal_en               => pclk_cal_en,
        pclk_cal_busy             => pclk_cal_busy(i),
        pclk_cal_error            => pclk_cal_error(i),
        pclk_cal_load_tap         => pclk_cal_load_tap(i),
        pclk_cal_tap_value        => pclk_cal_tap_value((i*5) + 4 downto (i*5)),
        aclk                      => aclk,
        aclk_reset                => aclk_reset,
        aclk_idle_character       => aclk_idle_character,
        aclk_hispi_phy_en         => aclk_hispi_phy_en,
        aclk_fifo_read_en         => aclk_fifo_read_en(i),
        aclk_fifo_empty           => aclk_fifo_empty(i),
        aclk_fifo_read_data_valid => aclk_fifo_read_data_valid(i),
        aclk_fifo_read_data       => aclk_fifo_read_data(i),
        aclk_fifo_overrun         => aclk_fifo_overrun(i),
        aclk_fifo_underrun        => aclk_fifo_underrun(i),
        aclk_bit_locked           => aclk_bit_locked(i),
        aclk_bit_locked_rise      => aclk_bit_locked_rise(i),
        aclk_bit_locked_fall      => aclk_bit_locked_fall(i),
        aclk_embeded_data         => aclk_embeded_data(i),
        aclk_sof_flag             => aclk_sof_flag(i),
        aclk_eof_flag             => aclk_eof_flag(i),
        aclk_sol_flag             => aclk_sol_flag(i),
        aclk_eol_flag             => aclk_eol_flag(i)
        );
  end generate G_lane_decoder;



  -----------------------------------------------------------------------------
  -- Module      : M_hclk_manual_calibration_load
  -- Description : Resynchronize aclk_start_calibration on hclk domain
  -----------------------------------------------------------------------------
  -- WARNING CLOCK DOMAIN CROSSING!!!
  -----------------------------------------------------------------------------
  M_hclk_manual_calibration_load : mtx_resync
    port map (
      aClk  => aclk,
      aClr  => aclk_reset,
      aDin  => aclk_manual_calibration_load,
      bClk  => hclk,
      bClr  => hclk_reset,
      bDout => open,
      bRise => hclk_manual_calibration_load,
      bFall => open
      );

  delay_tap_in <= aclk_manual_calibration_tap when (aclk_manual_calibration_en = '1') else
                  pclk_cal_tap_value;

  delay_reset <= '1' when (aclk_manual_calibration_en = '0' and hclk_state = S_LOAD_DELAY) else
                 '1' when (aclk_manual_calibration_en = '1' and hclk_manual_calibration_load = '1') else
                 '0';


  pclk_cal_en <= '1' when (hclk_state = S_INIT) else
                 '0';




  -----------------------------------------------------------------------------
  -- Module      : M_hclk_start_calibration
  -- Description : Resynchronize aclk_start_calibration on hclk domain
  -----------------------------------------------------------------------------
  -- WARNING CLOCK DOMAIN CROSSING!!!
  -----------------------------------------------------------------------------
  M_hclk_start_calibration : mtx_resync
    port map (
      aClk  => aclk,
      aClr  => aclk_reset,
      aDin  => aclk_start_calibration,
      bClk  => hclk,
      bClr  => hclk_reset,
      bDout => hclk_start_calibration,
      bRise => open,
      bFall => open
      );


  -----------------------------------------------------------------------------
  -- Module      : M_aclk_latch_cal_status
  -- Description : Resynchronize aclk_latch_cal_status on aclk domain
  -----------------------------------------------------------------------------
  -- WARNING CLOCK DOMAIN CROSSING!!!
  -----------------------------------------------------------------------------
  M_aclk_latch_cal_status : mtx_resync
    port map (
      aClk  => hclk,
      aClr  => hclk_reset,
      aDin  => delay_reset,
      bClk  => aclk,
      bClr  => aclk_reset,
      bDout => open,
      bRise => aclk_latch_cal_status,
      bFall => open
      );


  aclk_cal_done <= aclk_latch_cal_status;


  -----------------------------------------------------------------------------
  -- Process     : P_hclk_state
  -- Description : Resynchronize pclk_cal_error and pclk_cal_tap_value on aclk
  -- Src clock   : hclk
  -- Dest clock  : aclk
  -----------------------------------------------------------------------------
  -- WARNING CLOCK DOMAIN CROSSING!!!
  -----------------------------------------------------------------------------
  P_aclk_latch_cal_status : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1') then
        aclk_cal_error     <= (others => '0');
        aclk_cal_tap_value <= (others => '0');
      else
        if (aclk_latch_cal_status = '1') then
          aclk_cal_error     <= pclk_cal_error;
          aclk_cal_tap_value <= delay_tap_out;  -- Assume to be stable
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
            if (hclk_start_calibration = '1') then
              hclk_state <= S_INIT;
            else
              hclk_state <= S_IDLE;
            end if;


          -------------------------------------------------------------------
          -- S_INIT : 
          -------------------------------------------------------------------
          when S_INIT =>
            if (pclk_cal_busy = (pclk_cal_busy'range => '1')) then
              hclk_state <= S_CALIBRATE;
            else
              hclk_state <= S_INIT;
            end if;

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


  hispi_pix_clk <= pix_clk(0);

end architecture rtl;
