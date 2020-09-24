-------------------------------------------------------------------------------
-- MODULE        : lane_decoder
--
-- DESCRIPTION   : Decode the HiSPI stream for one lane from the SERDES output.
--                 The results is stored in a dual clock FiFo (Clock domain crossing).
--
-- CLOCK DOMAINS : hispi_clk
--                 pclk
--                 fifo_read_clk
--
-- TODO          : 
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.regfile_xgs_athena_pack.all;
use work.hispi_pack.all;


entity lane_decoder is
  generic (
    PHY_OUTPUT_WIDTH : integer := 6;    -- Physical lane
    PIXEL_SIZE       : integer := 12;   -- Pixel size in bits
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
    hclk_tap_cntr  : in unsigned(4 downto 0);

    ---------------------------------------------------------------------------
    -- Lane calibration
    ---------------------------------------------------------------------------
    pclk                   : in  std_logic;
    pclk_cal_en            : in  std_logic;
    pclk_cal_start_monitor : in  std_logic;
    pclk_cal_monitor_done  : out std_logic;
    pclk_cal_busy          : out std_logic;
    pclk_cal_tap_value     : out std_logic_vector(4 downto 0);
    pclk_tap_histogram     : out std_logic_vector(31 downto 0);

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
end entity lane_decoder;


architecture rtl of lane_decoder is


  component bit_split is
    generic (
      PHY_OUTPUT_WIDTH : integer := 6;  -- SERDES parallel width in bits
      PIXEL_SIZE       : integer := 12  -- Pixel size in bits
      );
    port (
      ---------------------------------------------------------------------------
      -- HiSPi clock domain
      ---------------------------------------------------------------------------
      hclk           : in std_logic;
      hclk_reset     : in std_logic;
      hclk_data_lane : in std_logic_vector(PHY_OUTPUT_WIDTH-1 downto 0);

      -------------------------------------------------------------------------
      -- Register file interface
      -------------------------------------------------------------------------
      hclk_idle_char  : in std_logic_vector(PIXEL_SIZE-1 downto 0);
      hclk_crc_enable : in std_logic;

      ---------------------------------------------------------------------------
      -- Pixel clock domain
      ---------------------------------------------------------------------------
      pclk            : in  std_logic;
      pclk_bit_locked : out std_logic;
      pclk_valid      : out std_logic;
      pclk_embedded   : out std_logic;
      pclk_state      : out FSM_STATE_TYPE := S_DISABLED;
      pclk_data       : out std_logic_vector(PIXEL_SIZE-1 downto 0)
      );
  end component;


  component tap_controller is
    generic (
      PIXEL_SIZE : integer := 12
      );
    port (
      hclk_tap_cntr          : in  unsigned(4 downto 0);
      ---------------------------------------------------------------------------
      -- Pixel clock domain (pclk)
      ---------------------------------------------------------------------------
      pclk                   : in  std_logic;
      pclk_reset             : in  std_logic;
      pclk_pixel             : in  std_logic_vector(PIXEL_SIZE-1 downto 0);
      pclk_idle_character    : in  std_logic_vector(PIXEL_SIZE-1 downto 0);
      pclk_cal_en            : in  std_logic;
      pclk_cal_start_monitor : in  std_logic;
      pclk_cal_monitor_done  : out std_logic;
      pclk_cal_busy          : out std_logic;
      pclk_cal_error         : out std_logic;
      pclk_cal_tap_value     : out std_logic_vector(4 downto 0);
      pclk_tap_histogram     : out std_logic_vector(31 downto 0)
      );
  end component;


  component hispi_crc is
    generic (
      PIXEL_SIZE : integer := 12        -- Pixel size in bits
      );
    port (
      pclk          : in  std_logic;
      pclk_reset    : in  std_logic;
      pclk_crc_init : in  std_logic;
      pclk_crc_en   : in  std_logic;
      pclk_crc_data : in  std_logic_vector(PIXEL_SIZE-1 downto 0);
      pclk_crc1     : out std_logic_vector(PIXEL_SIZE-1 downto 0);
      pclk_crc2     : out std_logic_vector(PIXEL_SIZE-1 downto 0)
      );
  end component;


  component mtxDCFIFO is
    generic
      (
        DATAWIDTH : natural := 32;
        ADDRWIDTH : natural := 12
        );
    port
      (
        -- Asynchronous reset
        aClr   : in  std_logic;
        -- Write port I/F (wClk)
        wClk   : in  std_logic;
        wEn    : in  std_logic;
        wData  : in  std_logic_vector (DATAWIDTH-1 downto 0);
        wFull  : out std_logic;
        -- Read port I/F (rClk)
        rClk   : in  std_logic;
        rEn    : in  std_logic;
        rData  : out std_logic_vector (DATAWIDTH-1 downto 0);
        rEmpty : out std_logic
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


  constant HISPI_WORDS_PER_SYNC_CODE : integer := 4;
  constant PIX_SHIFT_REGISTER_SIZE   : integer := PIXEL_SIZE * HISPI_WORDS_PER_SYNC_CODE;
  constant FIFO_ADDRESS_WIDTH        : integer := 10;  -- jmansill 1024 locationsde 32bits : 32K : 1 block memoire 36Kbits
  constant FIFO_DATA_WIDTH           : integer := LANE_DATA_WIDTH;

  signal pclk_reset              : std_logic;
  signal pclk_reset_Meta1        : std_logic;
  signal pclk_reset_Meta2        : std_logic;
  signal pclk_data               : std_logic_vector(PIXEL_SIZE-1 downto 0);
  signal pclk_bit_locked         : std_logic;
  signal pclk_cal_busy_int       : std_logic;
  signal pclk_cal_error          : std_logic;
  signal pclk_hispi_phy_en       : std_logic;
  signal pclk_hispi_data_path_en : std_logic;
  signal pclk_valid              : std_logic;
  signal pclk_embedded           : std_logic;
  signal pclk_sof_pending        : std_logic;
  signal pclk_sof_flag           : std_logic;
  signal pclk_eof_flag           : std_logic;
  signal pclk_sol_flag           : std_logic;
  signal pclk_eol_flag           : std_logic;
  signal pclk_fifo_overrun       : std_logic;
  signal pclk_fifo_wen           : std_logic;
  signal pclk_fifo_full          : std_logic;
  signal pclk_packer_mux         : std_logic_vector (LANE_DATA_WIDTH-1 downto 0);
  signal pclk_state              : FSM_STATE_TYPE                                := S_DISABLED;
  signal pclk_dataCntr           : unsigned(2 downto 0);  -- Modulo 8 counter
  signal pclk_packer_valid       : std_logic;
  signal pclk_sync_error         : std_logic;
  signal pclk_packer_0_valid     : std_logic;
  signal pclk_packer_1_valid     : std_logic;
  signal pclk_packer_2_valid     : std_logic;
  signal pclk_packer_3_valid     : std_logic;
  signal pclk_packer_0           : std_logic_vector (LANE_DATA_WIDTH-1 downto 0) := X"00000000";
  signal pclk_packer_1           : std_logic_vector (LANE_DATA_WIDTH-1 downto 0) := X"10000000";
  signal pclk_packer_2           : std_logic_vector (LANE_DATA_WIDTH-1 downto 0) := X"20000000";
  signal pclk_packer_3           : std_logic_vector (LANE_DATA_WIDTH-1 downto 0) := X"30000000";
  signal pclk_crc_enable         : std_logic                                     := '1';
  signal pclk_crc_init           : std_logic;
  signal pclk_crc_en             : std_logic;
  signal pclk_crc_error          : std_logic;
  signal pclk_computed_crc1      : std_logic_vector(11 downto 0);
  signal pclk_computed_crc2      : std_logic_vector(11 downto 0);

  signal sclk_fifo_empty_int : std_logic;
  signal sclk_fifo_underrun  : std_logic;

  signal rclk_enable_hispi    : std_logic;
  signal rclk_enable_datapath : std_logic;
  signal rclk_fifo_overrun    : std_logic;
  signal rclk_fifo_underrun   : std_logic;
  signal rclk_sync_error      : std_logic;
  signal rclk_tap_histogram   : std_logic_vector(31 downto 0);
  signal rclk_cal_busy_rise   : std_logic;
  signal rclk_cal_busy_fall   : std_logic;
  signal rclk_cal_done        : std_logic;
  signal rclk_cal_error       : std_logic;
  signal rclk_bit_locked      : std_logic;
  signal rclk_bit_locked_fall : std_logic;
  signal rclk_crc_error       : std_logic;

  signal async_idle_character : std_logic_vector(PIXEL_SIZE-1 downto 0);

  -----------------------------------------------------------------------------
  -- Debug attributes on pclk clock domain
  -----------------------------------------------------------------------------
  attribute mark_debug of rclk_enable_hispi    : signal is "true";
  attribute mark_debug of rclk_enable_datapath : signal is "true";
  attribute mark_debug of rclk_fifo_overrun    : signal is "true";
  attribute mark_debug of rclk_fifo_underrun   : signal is "true";
  attribute mark_debug of rclk_sync_error      : signal is "true";
  attribute mark_debug of rclk_tap_histogram   : signal is "true";
  attribute mark_debug of rclk_cal_busy_rise   : signal is "true";
  attribute mark_debug of rclk_cal_busy_fall   : signal is "true";
  attribute mark_debug of rclk_cal_done        : signal is "true";
  attribute mark_debug of rclk_cal_error       : signal is "true";
  attribute mark_debug of rclk_bit_locked      : signal is "true";
  attribute mark_debug of rclk_bit_locked_fall : signal is "true";


  attribute mark_debug of pclk_reset              : signal is "true";
  attribute mark_debug of pclk_reset_Meta1        : signal is "true";
  attribute mark_debug of pclk_reset_Meta2        : signal is "true";
  attribute mark_debug of pclk_data               : signal is "true";
  attribute mark_debug of pclk_bit_locked         : signal is "true";
  attribute mark_debug of pclk_cal_busy_int       : signal is "true";
  attribute mark_debug of pclk_cal_error          : signal is "true";
  attribute mark_debug of pclk_hispi_phy_en       : signal is "true";
  attribute mark_debug of pclk_hispi_data_path_en : signal is "true";
  attribute mark_debug of pclk_embedded           : signal is "true";
  attribute mark_debug of pclk_sof_flag           : signal is "true";
  attribute mark_debug of pclk_eof_flag           : signal is "true";
  attribute mark_debug of pclk_sol_flag           : signal is "true";
  attribute mark_debug of pclk_eol_flag           : signal is "true";
  attribute mark_debug of pclk_fifo_overrun       : signal is "true";
  attribute mark_debug of pclk_fifo_wen           : signal is "true";
  attribute mark_debug of pclk_fifo_full          : signal is "true";
  attribute mark_debug of pclk_packer_mux         : signal is "true";
  attribute mark_debug of pclk_state              : signal is "true";
  attribute mark_debug of pclk_dataCntr           : signal is "true";
  attribute mark_debug of pclk_packer_valid       : signal is "true";
  attribute mark_debug of pclk_sync_error         : signal is "true";
  attribute mark_debug of pclk_packer_0_valid     : signal is "true";
  attribute mark_debug of pclk_packer_1_valid     : signal is "true";
  attribute mark_debug of pclk_packer_2_valid     : signal is "true";
  attribute mark_debug of pclk_packer_3_valid     : signal is "true";
  attribute mark_debug of pclk_packer_0           : signal is "true";
  attribute mark_debug of pclk_packer_1           : signal is "true";
  attribute mark_debug of pclk_packer_2           : signal is "true";
  attribute mark_debug of pclk_packer_3           : signal is "true";
  attribute mark_debug of pclk_crc_enable         : signal is "true";
  attribute mark_debug of pclk_crc_error          : signal is "true";
  attribute mark_debug of pclk_computed_crc1      : signal is "true";
  attribute mark_debug of pclk_computed_crc2      : signal is "true";

  attribute mark_debug of sclk_reset                : signal is "true";
  attribute mark_debug of sclk_fifo_empty_int       : signal is "true";
  attribute mark_debug of sclk_fifo_underrun        : signal is "true";
  attribute mark_debug of sclk_fifo_read_en         : signal is "true";
  attribute mark_debug of sclk_fifo_empty           : signal is "true";
  attribute mark_debug of sclk_fifo_read_data_valid : signal is "true";
  attribute mark_debug of sclk_fifo_read_data       : signal is "true";
  attribute mark_debug of sclk_sof_flag             : signal is "true";
  attribute mark_debug of sclk_eof_flag             : signal is "true";
  attribute mark_debug of sclk_sol_flag             : signal is "true";
  attribute mark_debug of sclk_eol_flag             : signal is "true";

begin

  async_idle_character <= regfile.HISPI.IDLE_CHARACTER.VALUE;


  -----------------------------------------------------------------------------
  -- Process     : P_pclk_reset
  -- Description : Resynchronize hclk_reset on the pixel clock
  -----------------------------------------------------------------------------
  P_pclk_reset : process (hclk_reset, pclk) is
  begin
    if (hclk_reset = '1') then
      pclk_reset_Meta1 <= '1';
      pclk_reset_Meta2 <= '1';
      pclk_reset       <= '1';

    elsif (rising_edge(pclk)) then
      pclk_reset_Meta1 <= '0';
      pclk_reset_Meta2 <= pclk_reset_Meta1;
      pclk_reset       <= pclk_reset_Meta2;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Module      : xbit_split
  -- Description : Extract pixels from the serial stream
  -----------------------------------------------------------------------------
  xbit_split : bit_split
    generic map(
      PHY_OUTPUT_WIDTH => PHY_OUTPUT_WIDTH,
      PIXEL_SIZE       => PIXEL_SIZE
      )
    port map(
      hclk            => hclk,
      hclk_reset      => hclk_reset,
      hclk_data_lane  => hclk_data_lane,
      hclk_idle_char  => async_idle_character,  -- Falsepath
      hclk_crc_enable => pclk_crc_enable,       -- Falsepath
      pclk            => pclk,
      pclk_bit_locked => pclk_bit_locked,
      pclk_valid      => pclk_valid,
      pclk_embedded   => pclk_embedded,
      pclk_state      => pclk_state,
      pclk_data       => pclk_data
      );


  -----------------------------------------------------------------------------
  -- Resync  pclk_hispi_phy_en
  -----------------------------------------------------------------------------
  M_pclk_hispi_phy_en : mtx_resync
    port map
    (
      aClk  => rclk,
      aClr  => rclk_reset,
      aDin  => rclk_enable_hispi,
      bclk  => pclk,
      bclr  => pclk_reset,
      bDout => pclk_hispi_phy_en,
      bRise => open,
      bFall => open
      );


  -----------------------------------------------------------------------------
  -- Resync  
  -----------------------------------------------------------------------------
  M_pclk_hispi_data_path_en : mtx_resync
    port map
    (
      aClk  => rclk,
      aClr  => rclk_reset,
      aDin  => rclk_enable_datapath,
      bclk  => pclk,
      bclr  => pclk_reset,
      bDout => pclk_hispi_data_path_en,
      bRise => open,
      bFall => open
      );


  -----------------------------------------------------------------------------
  -- Module      : xtap_controller
  -- Description : Calculate the tap delay for the serdes
  -----------------------------------------------------------------------------
  xtap_controller : tap_controller
    generic map(
      PIXEL_SIZE => PIXEL_SIZE
      )
    port map(
      hclk_tap_cntr          => hclk_tap_cntr,
      pclk                   => pclk,
      pclk_reset             => pclk_reset,
      pclk_pixel             => pclk_data,
      pclk_idle_character    => async_idle_character,  -- Falsepath
      pclk_cal_en            => pclk_cal_en,
      pclk_cal_start_monitor => pclk_cal_start_monitor,
      pclk_cal_monitor_done  => pclk_cal_monitor_done,
      pclk_cal_busy          => pclk_cal_busy_int,
      pclk_cal_error         => pclk_cal_error,
      pclk_cal_tap_value     => pclk_cal_tap_value,
      pclk_tap_histogram     => pclk_tap_histogram
      );

  pclk_cal_busy <= pclk_cal_busy_int;


  -----------------------------------------------------------------------------
  -- Module      : xhispi_crc
  -- Description : Calculate the data CRC on the lane
  -----------------------------------------------------------------------------
  xhispi_crc : hispi_crc
    generic map(
      PIXEL_SIZE => PIXEL_SIZE
      )
    port map(
      pclk          => pclk,
      pclk_reset    => pclk_reset,
      pclk_crc_init => pclk_crc_init,
      pclk_crc_en   => pclk_crc_en,
      pclk_crc_data => pclk_data,
      pclk_crc1     => pclk_computed_crc1,
      pclk_crc2     => pclk_computed_crc2
      );


  pclk_crc_init <= '1' when (pclk_state = S_IDLE) else
                   '0';


  pclk_crc_en <= '1' when (pclk_state = S_AIL) else
                 '1' when (pclk_state = S_EOL) else
                 '1' when (pclk_state = S_EOF) else
                 '0';


  -----------------------------------------------------------------------------
  -- Detect CRC error
  -----------------------------------------------------------------------------
  pclk_crc_error <= '1' when (pclk_state = S_CRC1 and pclk_computed_crc1 /= pclk_data) else
                    '1' when (pclk_state = S_CRC2 and pclk_computed_crc2 /= pclk_data) else
                    '0';

  -----------------------------------------------------------------------------
  -- Process     : P_packer
  -- Description : Generates the packar_x_valid flag one per lane
  -----------------------------------------------------------------------------
  P_packer : process (pclk) is
  begin
    if (rising_edge(pclk)) then
      if (pclk_reset = '1') then
        pclk_packer_0_valid <= '0';
        pclk_packer_1_valid <= '0';
        pclk_packer_2_valid <= '0';
        pclk_packer_3_valid <= '0';
      else
        if (pclk_state = S_AIL and pclk_embedded = '0') then
          case pclk_dataCntr is
            -------------------------------------------------------------------
            -- Phase 0 : Packing pixel from lane 0 in pclk_packer_0
            -------------------------------------------------------------------
            when "000" =>
              pclk_packer_0_valid        <= '0';
              pclk_packer_1_valid        <= '0';
              pclk_packer_2_valid        <= '0';
              pclk_packer_3_valid        <= '0';
              pclk_packer_0(11 downto 0) <= pclk_data;

            -------------------------------------------------------------------
            -- Phase 1 : Packing pixel from lane 1 in pclk_packer_1
            -------------------------------------------------------------------
            when "001" =>
              pclk_packer_0_valid        <= '0';
              pclk_packer_1_valid        <= '0';
              pclk_packer_2_valid        <= '0';
              pclk_packer_3_valid        <= '0';
              pclk_packer_1(11 downto 0) <= pclk_data;

            -------------------------------------------------------------------
            -- Phase 2 : Packing pixel from lane 2 in pclk_packer_2 
            -------------------------------------------------------------------
            when "010" =>
              pclk_packer_0_valid        <= '0';
              pclk_packer_1_valid        <= '0';
              pclk_packer_2_valid        <= '0';
              pclk_packer_3_valid        <= '0';
              pclk_packer_2(11 downto 0) <= pclk_data;

            -------------------------------------------------------------------
            -- Phase 3 : Packing pixel from lane 3 in pclk_packer_3
            -------------------------------------------------------------------
            when "011" =>
              pclk_packer_0_valid        <= '0';
              pclk_packer_1_valid        <= '0';
              pclk_packer_2_valid        <= '0';
              pclk_packer_3_valid        <= '0';
              pclk_packer_3(11 downto 0) <= pclk_data;

            -------------------------------------------------------------------
            -- Phase 4 : Packing pixel from lane 0 in pclk_packer_0 and ready to flush
            -------------------------------------------------------------------
            when "100" =>
              pclk_packer_0_valid         <= '1';
              pclk_packer_1_valid         <= '0';
              pclk_packer_2_valid         <= '0';
              pclk_packer_3_valid         <= '0';
              pclk_packer_0(27 downto 16) <= pclk_data;

            -------------------------------------------------------------------
            -- Phase 5 : Packing pixel from lane 1 in pclk_packer_1 and ready to flush
            -------------------------------------------------------------------
            when "101" =>
              pclk_packer_0_valid         <= '0';
              pclk_packer_1_valid         <= '1';
              pclk_packer_2_valid         <= '0';
              pclk_packer_3_valid         <= '0';
              pclk_packer_1(27 downto 16) <= pclk_data;

            -------------------------------------------------------------------
            -- Phase 6 : Packing pixel from lane 2 in pclk_packer_2 and ready to flush
            -------------------------------------------------------------------
            when "110" =>
              pclk_packer_0_valid         <= '0';
              pclk_packer_1_valid         <= '0';
              pclk_packer_2_valid         <= '1';
              pclk_packer_3_valid         <= '0';
              pclk_packer_2(27 downto 16) <= pclk_data;

            -------------------------------------------------------------------
            -- Phase 7 : Packing pixel from lane 3 in pclk_packer_3 and ready to flush
            -------------------------------------------------------------------
            when "111" =>
              pclk_packer_0_valid         <= '0';
              pclk_packer_1_valid         <= '0';
              pclk_packer_2_valid         <= '0';
              pclk_packer_3_valid         <= '1';
              pclk_packer_3(27 downto 16) <= pclk_data;
            when others =>
              null;
          end case;

        -----------------------------------------------------------------------
        -- Any other states, no data valid (No packing)
        -----------------------------------------------------------------------
        else
          pclk_packer_0_valid <= '0';
          pclk_packer_1_valid <= '0';
          pclk_packer_2_valid <= '0';
          pclk_packer_3_valid <= '0';
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : pclk_pclk_packer_mux 
  -- Description : 4-to-1 Multiplexer
  -----------------------------------------------------------------------------
  pclk_packer_mux <= pclk_packer_0 when (pclk_dataCntr = "101") else
                     pclk_packer_1 when (pclk_dataCntr = "110") else
                     pclk_packer_2 when (pclk_dataCntr = "111") else
                     pclk_packer_3 when (pclk_dataCntr = "000") else
                     (others => '0');


  pclk_packer_valid <= '1' when (pclk_dataCntr = "101" and pclk_packer_0_valid = '1') else
                       '1' when (pclk_dataCntr = "110" and pclk_packer_1_valid = '1') else
                       '1' when (pclk_dataCntr = "111" and pclk_packer_2_valid = '1') else
                       '1' when (pclk_dataCntr = "000" and pclk_packer_3_valid = '1') else
                       '0';


  -----------------------------------------------------------------------------
  -- Process     : P_pclk_dataCntr
  -- Description : Modulo 8 phase counter. Used to de-interlace data from
  --               4 lanes. 
  -----------------------------------------------------------------------------
  P_pclk_dataCntr : process (pclk) is
  begin
    if (rising_edge(pclk)) then
      if (pclk_reset = '1') then
        -- initialize with max count value
        pclk_dataCntr <= (others => '0');
      else
        -- Align the counter phase with the line sync
        if (pclk_state = S_SOF or pclk_state = S_SOL) then
          pclk_dataCntr <= (others => '0');
        -- As long as valid pixels are received, count modulo 8
        -- then wrap around.
        elsif (pclk_hispi_phy_en = '1'and pclk_state = S_AIL) then
          pclk_dataCntr <= pclk_dataCntr + 1;
        end if;
      end if;
    end if;
  end process;




  -----------------------------------------------------------------------------
  -- Module      :
  -- Description : 
  -----------------------------------------------------------------------------
  P_pclk_sof_pending : process (pclk) is
  begin
    if (rising_edge(pclk)) then
      if (pclk_reset = '1')then
        pclk_sof_pending <= '0';
      else
        if (pclk_state = S_SOF and pclk_embedded = '1') then
          pclk_sof_pending <= '1';
        elsif (pclk_state = S_SOL and pclk_embedded = '0') then
          pclk_sof_pending <= '0';
        end if;
      end if;
    end if;
  end process;


  pclk_sof_flag <= '1' when (pclk_state = S_SOL and pclk_sof_pending = '1') else
                   '0';

  pclk_eof_flag <= '1' when (pclk_state = S_EOF) else '0';
  pclk_sol_flag <= '1' when (pclk_state = S_SOL) else '0';
  pclk_eol_flag <= '1' when (pclk_state = S_EOL) else '0';


  pclk_fifo_wen <= '1' when (pclk_state = S_AIL and pclk_packer_valid = '1') else
                   '0';

  pclk_sync_error <= '1' when (pclk_state = S_ERROR) else
                     '0';


  -----------------------------------------------------------------------------
  -- Module      :
  -- Description : 
  -----------------------------------------------------------------------------
  P_pclk_fifo_overrun : process (pclk) is
  begin
    if (rising_edge(pclk)) then
      if (pclk_reset = '1')then
        pclk_fifo_overrun <= '0';
      else
        if (pclk_fifo_full = '1' and pclk_fifo_wen = '1') then
          pclk_fifo_overrun <= '1';
        else
          pclk_fifo_overrun <= '0';
        end if;
      end if;
    end if;
  end process;



  -----------------------------------------------------------------------------
  -- Module      : xoutput_fifo
  -- Description : Elastic FiFo
  -----------------------------------------------------------------------------
  xoutput_fifo : mtxDCFIFO
    generic map
    (
      DATAWIDTH => FIFO_DATA_WIDTH,
      ADDRWIDTH => FIFO_ADDRESS_WIDTH
      )
    port map
    (
      aClr   => pclk_reset,
      wClk   => pclk,
      wEn    => pclk_fifo_wen,
      wData  => pclk_packer_mux,
      wFull  => pclk_fifo_full,
      rClk   => sclk,
      rEn    => sclk_fifo_read_en,
      rData  => sclk_fifo_read_data,
      rEmpty => sclk_fifo_empty_int
      );


  -----------------------------------------------------------------------------
  -- Resync sclk_sof_flag
  -----------------------------------------------------------------------------
  M_sclk_sof_flag : mtx_resync
    port map
    (
      aClk  => pclk,
      aClr  => pclk_reset,
      aDin  => pclk_sof_flag,
      bclk  => sclk,
      bclr  => sclk_reset,
      bDout => sclk_sof_flag,
      bRise => open,
      bFall => open
      );

  -----------------------------------------------------------------------------
  -- Resync sclk_eof_flag
  -----------------------------------------------------------------------------
  M_sclk_eof_flag : mtx_resync
    port map
    (
      aClk  => pclk,
      aClr  => pclk_reset,
      aDin  => pclk_eof_flag,
      bclk  => sclk,
      bclr  => sclk_reset,
      bDout => sclk_eof_flag,
      bRise => open,
      bFall => open
      );

  -----------------------------------------------------------------------------
  -- Resync sclk_sol_flag
  -----------------------------------------------------------------------------
  M_sclk_sol_flag : mtx_resync
    port map
    (
      aClk  => pclk,
      aClr  => pclk_reset,
      aDin  => pclk_sol_flag,
      bclk  => sclk,
      bclr  => sclk_reset,
      bDout => sclk_sol_flag,
      bRise => open,
      bFall => open
      );

  -----------------------------------------------------------------------------
  -- Resync sclk_eof_flag
  -----------------------------------------------------------------------------
  M_sclk_eol_flag : mtx_resync
    port map
    (
      aClk  => pclk,
      aClr  => pclk_reset,
      aDin  => pclk_eol_flag,
      bclk  => sclk,
      bclr  => sclk_reset,
      bDout => sclk_eol_flag,
      bRise => open,
      bFall => open
      );


  -----------------------------------------------------------------------------
  -- Resync rclk_cal_busy
  -----------------------------------------------------------------------------
  M_rclk_cal_busy : mtx_resync
    port map
    (
      aClk  => pclk,
      aClr  => pclk_reset,
      aDin  => pclk_cal_busy_int,
      bclk  => rclk,
      bclr  => rclk_reset,
      bDout => open,
      bRise => rclk_cal_busy_rise,
      bFall => rclk_cal_busy_fall
      );


  -----------------------------------------------------------------------------
  -- Process     : P_rclk_cal_done
  -- Description : Indicates the calibration is completed.
  -----------------------------------------------------------------------------
  P_rclk_cal_done : process (rclk) is
  begin
    if (rising_edge(rclk)) then
      if (rclk_reset = '1') then
        rclk_cal_done <= '0';
      else
        if (rclk_enable_hispi = '1') then
          if (rclk_cal_busy_rise = '1') then
            rclk_cal_done <= '0';
          elsif (rclk_cal_busy_fall = '1') then
            rclk_cal_done <= '1';
          end if;
        else
          rclk_cal_done <= '0';
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_sclk_fifo_read_data_valid
  -- Description : Indicates presence of read data on the FiFo read data bus.
  -----------------------------------------------------------------------------
  P_sclk_fifo_read_data_valid : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        sclk_fifo_read_data_valid <= '0';
      else
        sclk_fifo_read_data_valid <= sclk_fifo_read_en;
      end if;
    end if;
  end process;



  -----------------------------------------------------------------------------
  -- Send the pixel clock to the higher level of hierarchy 
  -----------------------------------------------------------------------------
  sclk_fifo_empty <= sclk_fifo_empty_int;

  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -- Registerfile status
  -----------------------------------------------------------------------------
  rclk_enable_hispi    <= regfile.HISPI.CTRL.ENABLE_HISPI;
  rclk_enable_datapath <= regfile.HISPI.CTRL.ENABLE_DATA_PATH;
  -----------------------------------------------------------------------------
  -- Resync FiFo overrun
  -----------------------------------------------------------------------------
  M_sclk_fifo_overrun : mtx_resync
    port map
    (
      aClk  => pclk,
      aClr  => pclk_reset,
      aDin  => pclk_fifo_overrun,
      bclk  => rclk,
      bclr  => rclk_reset,
      bDout => rclk_fifo_overrun,
      bRise => open,
      bFall => open
      );


  regfile.HISPI.LANE_DECODER_STATUS(LANE_ID).FIFO_OVERRUN_set <= '1' when (rclk_fifo_overrun = '1' and rclk_enable_hispi = '1') else
                                                                 '0';


  -----------------------------------------------------------------------------
  -- Resync FiFo underrun
  -----------------------------------------------------------------------------
  sclk_fifo_underrun <= '1' when (sclk_fifo_read_en = '1' and sclk_fifo_empty_int = '1') else
                        '0';
  M_sclk_fifo_underrun : mtx_resync
    port map
    (
      aClk  => sclk,
      aClr  => sclk_reset,
      aDin  => sclk_fifo_underrun,
      bclk  => rclk,
      bclr  => rclk_reset,
      bDout => rclk_fifo_underrun,
      bRise => open,
      bFall => open
      );

  regfile.HISPI.LANE_DECODER_STATUS(LANE_ID).FIFO_UNDERRUN_set <= rclk_fifo_underrun;


  -----------------------------------------------------------------------------
  -- Resync Calibration done
  -----------------------------------------------------------------------------
  regfile.HISPI.LANE_DECODER_STATUS(LANE_ID).CALIBRATION_DONE <= rclk_cal_done;


  -----------------------------------------------------------------------------
  -- Calibration error
  -----------------------------------------------------------------------------
  M_rclk_cal_error : mtx_resync
    port map
    (
      aClk  => pclk,
      aClr  => pclk_reset,
      aDin  => pclk_cal_error,
      bclk  => rclk,
      bclr  => rclk_reset,
      bDout => rclk_cal_error,
      bRise => open,
      bFall => open
      );


  regfile.HISPI.LANE_DECODER_STATUS(LANE_ID).CALIBRATION_ERROR_set <= '1' when (rclk_cal_error = '1' and rclk_enable_hispi = '1') else
                                                                      '0';


  -----------------------------------------------------------------------------
  -- Resync rclk_bit_locked
  -----------------------------------------------------------------------------
  M_sclk_bit_locked : mtx_resync
    port map
    (
      aClk  => pclk,
      aClr  => pclk_reset,
      aDin  => pclk_bit_locked,
      bclk  => rclk,
      bclr  => rclk_reset,
      bDout => rclk_bit_locked,
      bRise => open,
      bFall => rclk_bit_locked_fall
      );

  regfile.HISPI.LANE_DECODER_STATUS(LANE_ID).PHY_BIT_LOCKED           <= rclk_bit_locked;
  regfile.HISPI.LANE_DECODER_STATUS(LANE_ID).PHY_BIT_LOCKED_ERROR_set <= '1' when (rclk_bit_locked_fall = '1' and rclk_enable_hispi = '1') else
                                                                         '0';



  -----------------------------------------------------------------------------
  -- Resync rclk_sync_error
  -----------------------------------------------------------------------------
  M_rclk_crc_error : mtx_resync
    port map
    (
      aClk  => pclk,
      aClr  => pclk_reset,
      aDin  => pclk_crc_error,
      bclk  => rclk,
      bclr  => rclk_reset,
      bDout => open,
      bRise => rclk_crc_error,
      bFall => open
      );


  regfile.HISPI.LANE_DECODER_STATUS(LANE_ID).CRC_ERROR_set <= '1' when (rclk_crc_error = '1' and rclk_enable_hispi = '1') else
                                                              '0';

  -- synthesis translate_off
  assert (not(rising_edge(rclk_crc_error))) report "Detected CRC error on lane_decoder" severity error;
  -- synthesis translate_on


  -----------------------------------------------------------------------------
  -- Resync rclk_sync_error
  -----------------------------------------------------------------------------
  M_rclk_sync_error : mtx_resync
    port map
    (
      aClk  => pclk,
      aClr  => pclk_reset,
      aDin  => pclk_sync_error,
      bclk  => rclk,
      bclr  => rclk_reset,
      bDout => open,
      bRise => rclk_sync_error,
      bFall => open
      );


  regfile.HISPI.LANE_DECODER_STATUS(LANE_ID).PHY_SYNC_ERROR_set <= '1' when (rclk_sync_error = '1' and rclk_enable_hispi = '1') else
                                                                   '0';





end architecture rtl;
