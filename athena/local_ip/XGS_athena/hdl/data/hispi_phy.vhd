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

library unisim;
use unisim.vcomponents.all;

library work;
use work.regfile_xgs_athena_pack.all;
use work.mtx_types_pkg.all;
use work.hispi_pack.all;


entity hispi_phy is
  generic (
    LANE_PER_PHY : integer := 3;        -- Physical lane
    PIXEL_SIZE   : integer := 12;       -- Pixel size in bits
    PHY_ID       : integer := 0
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
    -- To XGS_controller
    ---------------------------------------------------------------------------
    hispi_pix_clk : out std_logic;

    ---------------------------------------------------------------------------
    -- Registerfile clock domain
    ---------------------------------------------------------------------------
    rclk       : in    std_logic;
    rclk_reset : in    std_logic;
    regfile    : inout REGFILE_XGS_ATHENA_TYPE := INIT_REGFILE_XGS_ATHENA_TYPE;

    ---------------------------------------------------------------------------
    -- sclk clock domain
    ---------------------------------------------------------------------------
    sclk                   : in  std_logic;
    sclk_reset             : in  std_logic;
    sclk_reset_phy         : in  std_logic;
    sclk_start_calibration : in  std_logic;
    sclk_calibration_done  : out std_logic;

    -- Read fifo interface
    sclk_fifo_read_en         : in  std_logic_vector(LANE_PER_PHY-1 downto 0);
    sclk_fifo_empty           : out std_logic_vector(LANE_PER_PHY-1 downto 0);
    sclk_fifo_read_data_valid : out std_logic_vector(LANE_PER_PHY-1 downto 0);
    sclk_fifo_read_data       : out std32_logic_vector(LANE_PER_PHY-1 downto 0);

    -- Flags 
    sclk_sof_flag : out std_logic_vector(LANE_PER_PHY-1 downto 0);
    sclk_eof_flag : out std_logic_vector(LANE_PER_PHY-1 downto 0);
    sclk_sol_flag : out std_logic_vector(LANE_PER_PHY-1 downto 0);
    sclk_eol_flag : out std_logic_vector(LANE_PER_PHY-1 downto 0)
    );

end entity hispi_phy;


architecture rtl of hispi_phy is


  component hispi_phy_xilinx
    generic
      (
        SYS_W : integer := 3;           -- width of the data for the system
        DEV_W : integer := 18           -- width of the data for the device
        );
    port
      (
        -- From the system into the device
        data_in_from_pins_p : in  std_logic_vector(SYS_W-1 downto 0);
        data_in_from_pins_n : in  std_logic_vector(SYS_W-1 downto 0);
        data_in_to_device   : out std_logic_vector(DEV_W-1 downto 0);
        in_delay_reset      : in  std_logic;
        in_delay_data_ce    : in  std_logic_vector(SYS_W-1 downto 0);
        in_delay_data_inc   : in  std_logic_vector(SYS_W-1 downto 0);
        in_delay_tap_in     : in  std_logic_vector((5*SYS_W)-1 downto 0);
        in_delay_tap_out    : out std_logic_vector((5*SYS_W)-1 downto 0);

        bitslip     : in  std_logic_vector(SYS_W-1 downto 0);  -- Bitslip module is enabled in NETWORKING mode
        -- User should tie it to '0' if not needed
        -- Clock and reset signals
        clk_in_p    : in  std_logic;    -- Differential fast clock from IOB
        clk_in_n    : in  std_logic;
        clk_div_out : out std_logic;    -- Slow clock output
        clk_reset   : in  std_logic;    -- Reset signal for Clock circuit
        io_reset    : in  std_logic     -- Reset signal for IO circuit
        );
  end component;


  component lane_decoder is
    generic (
      PHY_OUTPUT_WIDTH : integer := 6;   -- Physical lane
      PIXEL_SIZE       : integer := 12;  -- Pixel size in bits
      LANE_DATA_WIDTH  : integer := 32;
      LANE_ID          : integer := 0
      );
    port (
      ---------------------------------------------------------------------------
      -- hispi_clk clock domain
      ---------------------------------------------------------------------------
      hclk           : in std_logic;
      hclk_reset     : in std_logic;
      hclk_data_lane : in std_logic_vector(PHY_OUTPUT_WIDTH-1 downto 0);


      -- calibration
      pclk               : in  std_logic;
      pclk_cal_en        : in  std_logic;
      pclk_cal_busy      : out std_logic;
      pclk_cal_load_tap  : out std_logic;
      pclk_cal_tap_value : out std_logic_vector(4 downto 0);


      ---------------------------------------------------------------------------
      -- Registerfile  clock domain
      ---------------------------------------------------------------------------
      rclk       : in    std_logic;
      rclk_reset : in    std_logic;
      regfile    : inout REGFILE_XGS_ATHENA_TYPE := INIT_REGFILE_XGS_ATHENA_TYPE;

      ---------------------------------------------------------------------------
      -- sclk clock domain
      ---------------------------------------------------------------------------
      sclk       : in std_logic;
      sclk_reset : in std_logic;


      -- Read fifo interface
      sclk_fifo_read_en         : in  std_logic;
      sclk_fifo_empty           : out std_logic;
      sclk_fifo_read_data_valid : out std_logic;
      sclk_fifo_read_data       : out std_logic_vector(LANE_DATA_WIDTH-1 downto 0);

      -- Flags
      --sclk_embeded_data : out std_logic;
      sclk_sof_flag : out std_logic;
      sclk_eof_flag : out std_logic;
      sclk_sol_flag : out std_logic;
      sclk_eol_flag : out std_logic
      );
  end component;


  component mtx_resync is
    port
      (
        aclk  : in  std_logic;
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
  constant LANE_DATA_WIDTH    : integer := 32;
  constant RESET_LENGTH       : integer := 8;

  type FSM_STATE_TYPE is (S_IDLE, S_INIT, S_CALIBRATE, S_LOAD_DELAY, S_DONE);

  type SHIFT_REG_ARRAY is array (LANE_PER_PHY - 1 downto 0) of std_logic_vector (HISPI_SHIFT_REGISTER_SIZE - 1 downto 0);
  type REG_ALIGNED_ARRAY is array (LANE_PER_PHY - 1 downto 0) of std_logic_vector (PIXEL_SIZE- 1 downto 0);
  type LANE_DATA_ARRAY is array (LANE_PER_PHY - 1 downto 0) of std_logic_vector (DESERIALIZATION_RATIO - 1 downto 0);

  signal bitslip                      : std_logic_vector(LANE_PER_PHY-1 downto 0) := (others => '0');
  signal hclk                         : std_logic;
  signal hclk_div2                    : std_logic                                 := '0';
  signal hclk_reset_vect              : std_logic_vector(2 downto 0);
  signal hclk_reset                   : std_logic                                 := '1';
  signal hclk_state                   : FSM_STATE_TYPE                            := S_IDLE;
  signal hclk_start_calibration       : std_logic;
  signal hclk_calibration_done        : std_logic;
  signal hclk_serdes_data             : std_logic_vector(PHY_PARALLEL_WIDTH - 1 downto 0);
  signal hclk_lane_data               : LANE_DATA_ARRAY;
  signal hclk_manual_calibration_en   : std_logic;
  signal hclk_manual_calibration_load : std_logic;
  signal hclk_lane_enabled            : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal hclk_lane_reset              : std_logic_vector(LANE_PER_PHY-1 downto 0);

  signal delay_reset    : std_logic                                     := '0';
  signal delay_tap_in   : std_logic_vector((5*LANE_PER_PHY)-1 downto 0) := (others => '0');
  signal delay_tap_out  : std_logic_vector((5*LANE_PER_PHY)-1 downto 0);
  signal delay_data_ce  : std_logic_vector(LANE_PER_PHY-1 downto 0)     := (others => '0');
  signal delay_data_inc : std_logic_vector(LANE_PER_PHY-1 downto 0)     := (others => '0');

  signal pclk               : std_logic;
  signal pclk_cal_en        : std_logic;
  signal pclk_cal_busy      : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal pclk_cal_load_tap  : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal pclk_cal_tap_value : std_logic_vector((5*LANE_PER_PHY)-1 downto 0);

  signal rclk_latch_cal_status       : std_logic;
  signal rclk_manual_calibration_tap : std_logic_vector((5*LANE_PER_PHY)-1 downto 0) := (others => '0');
  signal rclk_cal_tap_value          : std_logic_vector((5*LANE_PER_PHY)-1 downto 0);
  signal rclk_nb_lanes               : std_logic_vector(2 downto 0);


  attribute mark_debug of hclk_reset_vect              : signal is "true";
  attribute mark_debug of hclk_reset                   : signal is "true";
  attribute mark_debug of hclk_state                   : signal is "true";
  attribute mark_debug of hclk_start_calibration       : signal is "true";
  attribute mark_debug of hclk_serdes_data             : signal is "true";
  attribute mark_debug of hclk_manual_calibration_load : signal is "true";

  attribute mark_debug of pclk_cal_en        : signal is "true";
  attribute mark_debug of pclk_cal_busy      : signal is "true";
  attribute mark_debug of pclk_cal_load_tap  : signal is "true";
  attribute mark_debug of pclk_cal_tap_value : signal is "true";

  attribute mark_debug of rclk_latch_cal_status : signal is "true";
  attribute mark_debug of delay_reset           : signal is "true";
  attribute mark_debug of delay_tap_in          : signal is "true";
  attribute mark_debug of delay_tap_out         : signal is "true";
  attribute mark_debug of delay_data_ce         : signal is "true";
  attribute mark_debug of delay_data_inc        : signal is "true";


begin

  -----------------------------------------------------------------------------
  -- WARNING CLOCK DOMAIN CROSSING!!!
  -- sclk_reset re-synchronisation in the hclk clock domain
  -----------------------------------------------------------------------------
  P_hclk_reset : process (sclk_reset, hclk) is
  begin
    if (sclk_reset = '1') then
      hclk_reset_vect <= (others => '1');
      hclk_reset      <= '1';

    elsif (rising_edge(hclk)) then
      hclk_reset_vect(0)                             <= '0';
      hclk_reset_vect(hclk_reset_vect'left downto 1) <= hclk_reset_vect(hclk_reset_vect'left -1 downto 0);
      hclk_reset                                     <= hclk_reset_vect(hclk_reset_vect'left);
    end if;
  end process;


  xhispi_phy_xilinx : hispi_phy_xilinx
    generic map (
      SYS_W => LANE_PER_PHY,
      DEV_W => PHY_PARALLEL_WIDTH
      )
    port map (
      data_in_from_pins_p => hispi_serial_input_p,
      data_in_from_pins_n => hispi_serial_input_n,
      data_in_to_device   => hclk_serdes_data,
      in_delay_reset      => delay_reset,
      in_delay_data_ce    => delay_data_ce,
      in_delay_data_inc   => delay_data_inc,
      in_delay_tap_in     => delay_tap_in,
      in_delay_tap_out    => delay_tap_out,
      bitslip             => bitslip,
      clk_in_p            => hispi_serial_clk_p,
      clk_in_n            => hispi_serial_clk_n,
      clk_div_out         => hclk,
      clk_reset           => sclk_reset_phy,
      io_reset            => hclk_reset
      );

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_hclk_div2 : process (hclk) is
  begin
    if (rising_edge(hclk)) then
      if (hclk_reset = '1') then
        hclk_div2 <= '0';
      else
        hclk_div2 <= not hclk_div2;
      end if;
    end if;
  end process;


  xpclk_buffer : BUFG
    port map (
      O => pclk,
      I => hclk_div2
      );


  -----------------------------------------------------------------------------
  -- WARNING CLOCK DOMAIN CROSSING!!!
  -- SRC CLK    : rclk
  -- DST CLK    : hclk
  -- CDC method : False path field from register file
  -----------------------------------------------------------------------------
  rclk_nb_lanes <= regfile.HISPI.CTRL.XGS_NB_LANES;
  P_hclk_lane_enabled : process (hclk) is
  begin
    if (rising_edge(hclk)) then
      if (hclk_reset = '1') then
        hclk_lane_enabled <= (others => '0');
      else
        case(rclk_nb_lanes) is
          -- 4 lanes enabled
          when "100" =>
            hclk_lane_enabled <= "011";

          -- 6 lanes enabled
          when "110" =>
            hclk_lane_enabled <= "111";
          -- Other cases all lanes disabled
          when others =>
            hclk_lane_enabled <= "000";
        end case;
      end if;
    end if;
  end process;





  G_lane_decoder : for i in 0 to LANE_PER_PHY-1 generate

    ---------------------------------------------------------------------------
    -- Put the lane decoder in reset if not used (4 lanes sensors)
    ---------------------------------------------------------------------------
    hclk_lane_reset(i) <= '1' when (hclk_reset = '1' or hclk_lane_enabled(i) = '0') else
                          '0';


    ---------------------------------------------------------------------------
    -- Route the data to the respective lane
    ---------------------------------------------------------------------------
    G_parallel_data : for j in 0 to DESERIALIZATION_RATIO-1 generate
      hclk_lane_data(i)(DESERIALIZATION_RATIO-1-j) <= hclk_serdes_data(j *LANE_PER_PHY + i);
    end generate G_parallel_data;

    ---------------------------------------------------------------------------
    -- Lane decoder module
    ---------------------------------------------------------------------------
    inst_lane_decoder : lane_decoder
      generic map(
        PHY_OUTPUT_WIDTH => DESERIALIZATION_RATIO,
        PIXEL_SIZE       => PIXEL_SIZE,
        LANE_DATA_WIDTH  => LANE_DATA_WIDTH,
        LANE_ID          => (2*i) + PHY_ID
        )
      port map(
        hclk                      => hclk,
        hclk_reset                => hclk_lane_reset(i),
        hclk_data_lane            => hclk_lane_data(i),
        pclk                      => pclk,
        pclk_cal_en               => pclk_cal_en,
        pclk_cal_busy             => pclk_cal_busy(i),
        pclk_cal_load_tap         => pclk_cal_load_tap(i),
        pclk_cal_tap_value        => pclk_cal_tap_value((i*5) + 4 downto (i*5)),
        rclk                      => rclk,
        rclk_reset                => rclk_reset,
        regfile                   => regfile,
        sclk                      => sclk,
        sclk_reset                => sclk_reset,
        sclk_fifo_read_en         => sclk_fifo_read_en(i),
        sclk_fifo_empty           => sclk_fifo_empty(i),
        sclk_fifo_read_data_valid => sclk_fifo_read_data_valid(i),
        sclk_fifo_read_data       => sclk_fifo_read_data(i),
        sclk_sof_flag             => sclk_sof_flag(i),
        sclk_eof_flag             => sclk_eof_flag(i),
        sclk_sol_flag             => sclk_sol_flag(i),
        sclk_eol_flag             => sclk_eol_flag(i)
        );
  end generate G_lane_decoder;


  -----------------------------------------------------------------------------
  -- Module      : M_hclk_manual_calibration_en
  -- Description : Resynchronize regfile.HISPI.DEBUG.MANUAL_CALIB_EN
  --               on hclk domain
  -----------------------------------------------------------------------------
  -- WARNING CLOCK DOMAIN CROSSING!!!
  -----------------------------------------------------------------------------
  M_hclk_manual_calibration_en : mtx_resync
    port map (
      aclk  => rclk,
      aClr  => rclk_reset,
      aDin  => regfile.HISPI.DEBUG.MANUAL_CALIB_EN,
      bClk  => hclk,
      bClr  => hclk_reset,
      bDout => hclk_manual_calibration_en,
      bRise => open,
      bFall => open
      );


  -----------------------------------------------------------------------------
  -- Module      : M_hclk_manual_calibration_load
  -- Description : Resynchronize regfile.HISPI.DEBUG.MANUAL_CALIB_EN
  --               on hclk domain
  -----------------------------------------------------------------------------
  -- WARNING CLOCK DOMAIN CROSSING!!!
  -----------------------------------------------------------------------------
  M_hclk_manual_calibration_load : mtx_resync
    port map (
      aclk  => rclk,
      aClr  => rclk_reset,
      aDin  => regfile.HISPI.DEBUG.LOAD_TAPS,
      bClk  => hclk,
      bClr  => hclk_reset,
      bDout => open,
      bRise => hclk_manual_calibration_load,
      bFall => open
      );

  -----------------------------------------------------------------------------
  -- Manual calibration tap mapping
  -----------------------------------------------------------------------------
  G_TOP_PHY_MAPPING : if (PHY_ID = 0) generate
    rclk_manual_calibration_tap(4 downto 0)   <= regfile.HISPI.DEBUG.TAP_LANE_0;
    rclk_manual_calibration_tap(9 downto 5)   <= regfile.HISPI.DEBUG.TAP_LANE_2;
    rclk_manual_calibration_tap(14 downto 10) <= regfile.HISPI.DEBUG.TAP_LANE_4;
  end generate;


  G_BOTTOM_PHY_MAPPING : if (PHY_ID > 0) generate
    rclk_manual_calibration_tap(4 downto 0)   <= regfile.HISPI.DEBUG.TAP_LANE_1;
    rclk_manual_calibration_tap(9 downto 5)   <= regfile.HISPI.DEBUG.TAP_LANE_3;
    rclk_manual_calibration_tap(14 downto 10) <= regfile.HISPI.DEBUG.TAP_LANE_5;
  end generate;


  delay_tap_in((5*LANE_PER_PHY)-1 downto 0) <= rclk_manual_calibration_tap((5*LANE_PER_PHY)-1 downto 0) when (hclk_manual_calibration_en = '1') else
                                               pclk_cal_tap_value;


  delay_reset <= '1' when (hclk_manual_calibration_en = '0' and pclk_cal_load_tap(0) = '1') else
                 '1' when (hclk_manual_calibration_en = '1' and hclk_manual_calibration_load = '1') else
                 '0';


  pclk_cal_en <= '1' when (hclk_state = S_INIT) else
                 '0';


  -----------------------------------------------------------------------------
  -- Module      : M_hclk_start_calibration
  -- Description : Resynchronize sclk_start_calibration on hclk domain
  -----------------------------------------------------------------------------
  -- WARNING CLOCK DOMAIN CROSSING!!!
  -----------------------------------------------------------------------------
  M_hclk_start_calibration : mtx_resync
    port map (
      aclk  => sclk,
      aClr  => sclk_reset,
      aDin  => sclk_start_calibration,
      bClk  => hclk,
      bClr  => hclk_reset,
      bDout => hclk_start_calibration,
      bRise => open,
      bFall => open
      );

  -----------------------------------------------------------------------------
  -- Module      : M_sclk_calibration_done
  -- Description : Resynchronize 
  -----------------------------------------------------------------------------
  -- WARNING CLOCK DOMAIN CROSSING!!!
  -----------------------------------------------------------------------------
  M_sclk_calibration_done : mtx_resync
    port map (
      aclk  => hclk,
      aClr  => hclk_reset,
      aDin  => hclk_calibration_done,
      bClk  => sclk,
      bClr  => sclk_reset,
      bDout => sclk_calibration_done,
      bRise => open,
      bFall => open
      );


  -----------------------------------------------------------------------------
  -- Module      : M_sclk_latch_cal_status
  -- Description : Resynchronize sclk_latch_cal_status on sclk domain
  -----------------------------------------------------------------------------
  -- WARNING CLOCK DOMAIN CROSSING!!!
  -----------------------------------------------------------------------------
  M_sclk_latch_cal_status : mtx_resync
    port map (
      aclk  => hclk,
      aClr  => hclk_reset,
      aDin  => delay_reset,
      bClk  => rclk,
      bClr  => rclk_reset,
      bDout => open,
      bRise => rclk_latch_cal_status,
      bFall => open
      );


  -----------------------------------------------------------------------------
  -- Process     : P_rclk_cal_tap_value
  -- Description : 
  -- Src clock   : hclk
  -- Dest clock  : rclk
  -----------------------------------------------------------------------------
  -- WARNING CLOCK DOMAIN CROSSING!!!
  -----------------------------------------------------------------------------
  P_rclk_cal_tap_value : process (rclk) is
  begin
    if (rising_edge(rclk)) then
      if (rclk_reset = '1') then
        rclk_cal_tap_value <= (others => '0');
      else
        if (rclk_latch_cal_status = '1') then
          rclk_cal_tap_value <= delay_tap_out;  -- Assume to be stable
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- For top phy =>  PHY_ID=0; for bottom phy =>  PHY_ID=1
  --
  -- Top phy    = Lane0, Lane2, Lane4
  -- Bottom phy = Lane1, Lane3, Lane5
  -----------------------------------------------------------------------------
  G_cal_tap_value : for i in 0 to LANE_PER_PHY-1 generate
    regfile.HISPI.LANE_DECODER_STATUS(2*i+PHY_ID).CALIBRATION_TAP_VALUE <= rclk_cal_tap_value(5*i+4 downto 5*i);
  end generate G_cal_tap_value;



  -----------------------------------------------------------------------------
  -- Process     : P_hclk_calibration_done
  -- Description : 
  -----------------------------------------------------------------------------

  P_hclk_calibration_done : process (hclk) is
  begin
    if (rising_edge(hclk)) then
      if (hclk_reset = '1') then
        hclk_calibration_done <= '0';
      else
        if (hclk_state = S_INIT) then
          hclk_calibration_done <= '0';
        elsif (hclk_state = S_DONE) then
          hclk_calibration_done <= '1';
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


  hispi_pix_clk <= pclk;

end architecture rtl;
