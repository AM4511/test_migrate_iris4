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
-- TODO          : Remove sync in the line buffer. Sync are recreated in
--                 axi_line_streamer 
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
    WORD_PTR_WIDTH   : integer := 6;
    LANE_ID          : integer := 0
    );
  port (
    ---------------------------------------------------------------------------
    -- hispi_clk clock domain
    ---------------------------------------------------------------------------
    hclk             : in std_logic;
    hclk_reset       : in std_logic;
    hclk_lane_enable : in std_logic;
    hclk_data_lane   : in std_logic_vector(PHY_OUTPUT_WIDTH-1 downto 0);

    ---------------------------------------------------------------------------
    -- Lane calibration
    ---------------------------------------------------------------------------
    pclk                   : in  std_logic;
    pclk_reset             : in  std_logic;
    pclk_cal_en            : in  std_logic;
    pclk_cal_start_monitor : in  std_logic;
    pclk_tap_cntr          : in  std_logic_vector(4 downto 0);
    pclk_valid             : out std_logic;
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

    ---------------------------------------------------------------------
    -- System clock domain
    ---------------------------------------------------------------------
    sclk       : in std_logic;
    sclk_reset : in std_logic;

    ---------------------------------------------------------------------------
    -- Sync
    ---------------------------------------------------------------------------
    sclk_sof : out std_logic;

    ---------------------------------------------------------------------------
    -- Line buffer interface
    ---------------------------------------------------------------------------
    sclk_buffer_empty    : out std_logic;
    sclk_buffer_read_en  : in  std_logic;
    sclk_buffer_id       : in  std_logic_vector(1 downto 0);
    sclk_buffer_mux_id   : in  std_logic_vector(1 downto 0);
    sclk_buffer_word_ptr : in  std_logic_vector(WORD_PTR_WIDTH-1 downto 0);
    sclk_buffer_sync     : out std_logic_vector(3 downto 0);
    sclk_buffer_data     : out PIXEL_ARRAY(2 downto 0)
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
      hclk             : in std_logic;
      hclk_reset       : in std_logic;
      hclk_lane_enable : in std_logic;
      hclk_data_lane   : in std_logic_vector(PHY_OUTPUT_WIDTH-1 downto 0);

      -------------------------------------------------------------------------
      -- Register file interface
      -------------------------------------------------------------------------
      hclk_idle_char  : in std_logic_vector(PIXEL_SIZE-1 downto 0);
      hclk_crc_enable : in std_logic;

      ---------------------------------------------------------------------------
      -- Pixel clock domain
      ---------------------------------------------------------------------------
      pclk            : in  std_logic;
      pclk_cal_busy   : in  std_logic;
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
      pclk                   : in  std_logic;
      pclk_reset             : in  std_logic;
      pclk_lane_enable       : in  std_logic;
      pclk_pixel             : in  std_logic_vector(PIXEL_SIZE-1 downto 0);
      pclk_idle_character    : in  std_logic_vector(PIXEL_SIZE-1 downto 0);
      pclk_tap_cntr          : in  std_logic_vector(4 downto 0);
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


  component line_buffer is
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



  constant HISPI_WORDS_PER_SYNC_CODE : integer                              := 4;
  constant PIX_SHIFT_REGISTER_SIZE   : integer                              := PIXEL_SIZE * HISPI_WORDS_PER_SYNC_CODE;
  constant FIFO_ADDRESS_WIDTH        : integer                              := 10;  -- jmansill 1024 locationsde 32bits : 32K : 1 block memoire 36Kbits
  constant FIFO_DATA_WIDTH           : integer                              := LANE_DATA_WIDTH+4;  -- Sync and data
  constant MAX_BURST                 : unsigned(sclk_buffer_word_ptr'range) := "111001";  --0x39

  signal pclk_data               : std_logic_vector(PIXEL_SIZE-1 downto 0);
  signal pclk_pixel              : PIXEL_TYPE;
  signal pclk_packer_0           : PIXEL_ARRAY(2 downto 0);
  signal pclk_packer_1           : PIXEL_ARRAY(2 downto 0);
  signal pclk_packer_2           : PIXEL_ARRAY(2 downto 0);
  signal pclk_packer_3           : PIXEL_ARRAY(2 downto 0);
  signal pclk_packer_mux         : PIXEL_ARRAY(2 downto 0);
  signal pclk_bit_locked         : std_logic;
  signal pclk_cal_busy_int       : std_logic;
  signal pclk_cal_error          : std_logic;
  signal pclk_hispi_phy_en       : std_logic;
  signal pclk_hispi_data_path_en : std_logic;
  signal pclk_embedded           : std_logic;
  signal pclk_sof_pending        : std_logic;
  signal pclk_sof_flag           : std_logic;
  signal pclk_set_buff_ready     : std_logic_vector(3 downto 0);
  signal pclk_buff_ready         : std_logic_vector(3 downto 0);

  signal pclk_buffer_init   : std_logic;
  signal pclk_buffer_data   : PIXEL_ARRAY(2 downto 0);
  signal pclk_buffer_id     : unsigned(1 downto 0);
  signal pclk_buffer_mux_id : unsigned(1 downto 0);
  signal pclk_word_ptr      : unsigned(WORD_PTR_WIDTH-1 downto 0);
  signal pclk_init_word_ptr : std_logic;
  signal pclk_incr_word_ptr : std_logic;

  signal pclk_buffer_wen   : std_logic;
  signal pclk_state        : FSM_STATE_TYPE := S_DISABLED;
  signal pclk_phase_cntr   : unsigned(3 downto 0);  -- Modulo 12 counter
  signal pclk_packer_valid : std_logic;
  signal pclk_sync         : std_logic_vector (3 downto 0);
  signal pclk_sync_error   : std_logic;


  signal pclk_buffer_overrun : std_logic;
  signal pclk_crc_enable     : std_logic := '1';
  signal pclk_crc_init       : std_logic;
  signal pclk_crc_en         : std_logic;
  signal pclk_crc_error      : std_logic;
  signal pclk_computed_crc1  : std_logic_vector(11 downto 0);
  signal pclk_computed_crc2  : std_logic_vector(11 downto 0);
  signal pclk_eol            : std_logic;
  signal pclk_sof            : std_logic;

  signal rclk_enable_hispi    : std_logic;
  signal rclk_enable_datapath : std_logic;
  signal rclk_buffer_overrun  : std_logic;
  signal rclk_buffer_underrun : std_logic;
  signal rclk_sync_error      : std_logic;
  signal rclk_tap_histogram   : std_logic_vector(31 downto 0);
  signal rclk_cal_busy_rise   : std_logic;
  signal rclk_cal_busy_fall   : std_logic;
  signal rclk_cal_done        : std_logic;
  signal rclk_cal_error       : std_logic;
  signal rclk_bit_locked      : std_logic;
  signal rclk_bit_locked_fall : std_logic;
  signal rclk_crc_error       : std_logic;

  signal async_idle_character  : std_logic_vector(PIXEL_SIZE-1 downto 0);
  signal sclk_buffer_data_slv  : std_logic_vector(29 downto 0);
  signal sclk_buffer_empty_int : std_logic;
  signal sclk_buffer_underrun  : std_logic;

  -----------------------------------------------------------------------------
  -- Debug attributes 
  -----------------------------------------------------------------------------
  attribute mark_debug of sclk_buffer_underrun  : signal is "true";
  attribute mark_debug of sclk_buffer_empty_int : signal is "true";
  attribute mark_debug of sclk_buffer_read_en   : signal is "true";

  attribute mark_debug of pclk_state          : signal is "true";
  attribute mark_debug of pclk_buffer_id      : signal is "true";
  attribute mark_debug of pclk_set_buff_ready : signal is "true";
  attribute mark_debug of pclk_buff_ready     : signal is "true";
  attribute mark_debug of pclk_embedded       : signal is "true";
  attribute mark_debug of pclk_buffer_overrun : signal is "true";


begin

  async_idle_character <= regfile.HISPI.IDLE_CHARACTER.VALUE;


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
      hclk             => hclk,
      hclk_reset       => hclk_reset,
      hclk_lane_enable => hclk_lane_enable,
      hclk_data_lane   => hclk_data_lane,
      hclk_idle_char   => async_idle_character,  -- Falsepath
      hclk_crc_enable  => pclk_crc_enable,       -- Falsepath
      pclk             => pclk,
      pclk_cal_busy    => pclk_cal_busy_int,
      pclk_bit_locked  => pclk_bit_locked,
      pclk_valid       => pclk_valid,
      pclk_embedded    => pclk_embedded,
      pclk_state       => pclk_state,
      pclk_data        => pclk_data
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
      pclk                   => pclk,
      pclk_reset             => pclk_reset,
      pclk_lane_enable       => hclk_lane_enable,      --Falsepath
      pclk_pixel             => pclk_data,
      pclk_idle_character    => async_idle_character,  -- Falsepath
      pclk_tap_cntr          => pclk_tap_cntr,
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


  pclk_eol <= '1' when (pclk_state = S_EOL) else
              '0';


  pclk_sof <= '1' when (pclk_state = S_SOF) else
              '0';


  -----------------------------------------------------------------------------
  -- Detect CRC error
  -----------------------------------------------------------------------------
  pclk_crc_error <= '1' when (pclk_state = S_CRC1 and pclk_computed_crc1 /= pclk_data) else
                    '1' when (pclk_state = S_CRC2 and pclk_computed_crc2 /= pclk_data) else
                    '0';

  -- Conversion from 12 to 10 bits per pixels
  pclk_pixel <= pclk_data(11 downto 2);

  -----------------------------------------------------------------------------
  -- Process     : P_packer
  -- Description : Generates the packar_x_valid flag one per lane
  -----------------------------------------------------------------------------
  P_packer : process (pclk) is
  begin
    if (rising_edge(pclk)) then
      if (pclk_reset = '1') then
        pclk_packer_valid <= '0';
      else
        if (pclk_state = S_AIL and pclk_embedded = '0') then
          case pclk_phase_cntr is
            -------------------------------------------------------------------
            -- Phase 0 : Packing pixel from lane 0 in pclk_packer_0
            -------------------------------------------------------------------
            when "0000" =>
              pclk_packer_valid <= '0';
              pclk_packer_0(0)  <= pclk_pixel;

            -------------------------------------------------------------------
            -- Phase 1 : Packing pixel from lane 1 in pclk_packer_1
            -------------------------------------------------------------------
            when "0001" =>
              pclk_packer_valid <= '0';
              pclk_packer_1(0)  <= pclk_pixel;

            -------------------------------------------------------------------
            -- Phase 2 : Packing pixel from lane 2 in pclk_packer_2 
            -------------------------------------------------------------------
            when "0010" =>
              pclk_packer_valid <= '0';
              pclk_packer_2(0)  <= pclk_pixel;

            -------------------------------------------------------------------
            -- Phase 3 : Packing pixel from lane 3 in pclk_packer_3
            -------------------------------------------------------------------
            when "0011" =>
              pclk_packer_valid <= '0';
              pclk_packer_3(0)  <= pclk_pixel;

            -------------------------------------------------------------------
            -- Phase 4 : Packing pixel from lane 0 in pclk_packer_0 and ready to flush
            -------------------------------------------------------------------
            when "0100" =>
              pclk_packer_valid <= '0';
              pclk_packer_0(1)  <= pclk_pixel;

            -------------------------------------------------------------------
            -- Phase 5 : Packing pixel from lane 1 in pclk_packer_1 and ready to flush
            -------------------------------------------------------------------
            when "0101" =>
              pclk_packer_valid <= '0';
              pclk_packer_1(1)  <= pclk_pixel;

            -------------------------------------------------------------------
            -- Phase 6 : Packing pixel from lane 2 in pclk_packer_2 and ready to flush
            -------------------------------------------------------------------
            when "0110" =>
              pclk_packer_valid <= '0';
              pclk_packer_2(1)  <= pclk_pixel;

            -------------------------------------------------------------------
            -- Phase 7 : Packing pixel from lane 3 in pclk_packer_3 and ready to flush
            -------------------------------------------------------------------
            when "0111" =>
              pclk_packer_valid <= '0';
              pclk_packer_3(1)  <= pclk_pixel;

            -------------------------------------------------------------------
            -- Phase 8 : Packing pixel from lane 0 in pclk_packer_0 and ready to flush
            -------------------------------------------------------------------
            when "1000" =>
              pclk_packer_valid <= '1';
              pclk_packer_0(2)  <= pclk_pixel;

            -------------------------------------------------------------------
            -- Phase 9 : Packing pixel from lane 1 in pclk_packer_1 and ready to flush
            -------------------------------------------------------------------
            when "1001" =>
              pclk_packer_valid <= '1';
              pclk_packer_1(2)  <= pclk_pixel;

            -------------------------------------------------------------------
            -- Phase 10 : Packing pixel from lane 2 in pclk_packer_2 and ready to flush
            -------------------------------------------------------------------
            when "1010" =>
              pclk_packer_valid <= '1';
              pclk_packer_2(2)  <= pclk_pixel;

            -------------------------------------------------------------------
            -- Phase 1 : Packing pixel from lane 3 in pclk_packer_3 and ready to flush
            -------------------------------------------------------------------
            when "1011" =>
              pclk_packer_valid <= '1';
              pclk_packer_3(2)  <= pclk_pixel;
            when others =>
              null;
          end case;

        -----------------------------------------------------------------------
        -- Any other states, no data valid (No packing)
        -----------------------------------------------------------------------
        else
          pclk_packer_valid <= '0';
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : pclk_pclk_packer_mux 
  -- Description : 4-to-1 Multiplexer
  -----------------------------------------------------------------------------
  pclk_packer_mux <= pclk_packer_0 when (pclk_phase_cntr = "1001") else
                     pclk_packer_1 when (pclk_phase_cntr = "1010") else
                     pclk_packer_2 when (pclk_phase_cntr = "1011") else
                     pclk_packer_3 when (pclk_phase_cntr = "0000") else
                     (others => (others => '0'));



  -----------------------------------------------------------------------------
  -- Process     : P_pclk_phase_cntr
  -- Description : Modulo 12 phase counter. Used to de-interlace data from
  --               4 lanes. 
  -----------------------------------------------------------------------------
  P_pclk_phase_cntr : process (pclk) is
  begin
    if (rising_edge(pclk)) then
      if (pclk_reset = '1') then
        -- initialize with max count value
        pclk_phase_cntr <= (others => '0');
      else
        -- Align the counter phase with the line sync
        if (pclk_state = S_SOF or pclk_state = S_SOL) then
          pclk_phase_cntr <= (others => '0');
        -- As long as valid pixels are received, count modulo 12
        -- then wrap around.
        elsif (pclk_hispi_phy_en = '1'and pclk_state = S_AIL) then
          if (pclk_phase_cntr = "1011") then
            -- Modulo 12; we wrap around
            pclk_phase_cntr <= (others => '0');
          else
            pclk_phase_cntr <= pclk_phase_cntr + 1;
          end if;
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

  pclk_buffer_wen <= '1' when (pclk_state = S_AIL and pclk_packer_valid = '1') else
                     '0';

  pclk_sync_error <= '1' when (pclk_state = S_ERROR) else
                     '0';


  -----------------------------------------------------------------------------
  -- Module      :
  -- Description : 
  -----------------------------------------------------------------------------
  P_pclk_set_buff_ready : process (pclk) is
  begin
    if (rising_edge(pclk)) then
      if (pclk_reset = '1')then
        pclk_set_buff_ready <= (others => '0');
      else
        if (pclk_state = S_EOL and pclk_embedded = '0') then
          for i in 0 to 3 loop
            if (i = to_integer(pclk_buffer_id)) then
              pclk_set_buff_ready(i) <= '1';
            else
              pclk_set_buff_ready(i) <= '0';
            end if;
          end loop;  -- i
        else
          pclk_set_buff_ready <= (others => '0');
        end if;
      end if;
    end if;
  end process;



  -----------------------------------------------------------------------------
  -- Process     : P_pclk_sync
  -- Description : Generates the sync marker aligned with pclk_buffer_data
  --               S_SOF  = 0001
  --               S_EOF  = 0010
  --               S_SOL  = 0100
  --               S_EOL  = 1000
  --               S_CONT = 0000               
  -----------------------------------------------------------------------------
  P_pclk_sync : process (pclk) is
  begin
    if (rising_edge(pclk)) then
      if (pclk_reset = '1')then
        pclk_sync <= (others => '0');
      else
        if (pclk_embedded = '0') then
          case pclk_state is
            when S_SOF =>
              pclk_sync(0) <= '1';
            when S_SOL =>
              if (pclk_sof_pending = '1') then
                -- Start of frame delayed by embedded data
                pclk_sync(0) <= '1';
              else
                -- Start of line
                pclk_sync(2) <= '1';
              end if;
            when S_EOL =>
              pclk_sync(3) <= '1';
            when S_EOF =>
              pclk_sync(1) <= '1';
            when others =>
              if (pclk_buffer_wen = '1') then
                pclk_sync <= (others => '0');
              end if;
          end case;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_pclk_buffer_id
  -- Description : Modulo 4 buffer counter. 
  -----------------------------------------------------------------------------
  P_pclk_buffer_id : process (pclk) is
  begin
    if (rising_edge(pclk)) then
      if (pclk_reset = '1') then
        pclk_buffer_id <= (others => '0');
      else
        if (pclk_state = S_SOF) then
          pclk_buffer_id <= (others => '0');
        elsif (pclk_state = S_EOL and pclk_embedded = '0') then
          pclk_buffer_id <= pclk_buffer_id + 1;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_pclk_buffer_mux_id
  -- Description : 
  -----------------------------------------------------------------------------
  P_pclk_buffer_mux_id : process (pclk) is
  begin
    if (rising_edge(pclk)) then
      if (pclk_reset = '1') then
        pclk_buffer_mux_id <= (others => '0');
      else
        if (pclk_state = S_AIL) then
          pclk_buffer_mux_id <= pclk_phase_cntr(1 downto 0);
        end if;
      end if;
    end if;
  end process;

  -----------------------------------------------------------------------------
  -- Word ptr init
  -----------------------------------------------------------------------------
  pclk_init_word_ptr <= '1' when (pclk_state = S_SOL) else
                        '0';

  -----------------------------------------------------------------------------
  -- Buffer write en 
  -----------------------------------------------------------------------------
  pclk_incr_word_ptr <= '1' when (pclk_state = S_AIL and pclk_buffer_wen = '1' and pclk_buffer_mux_id = "11") else
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

  pclk_buffer_init <= '1' when (pclk_state = S_SOF) else
                      '0';


  pclk_buffer_data <= pclk_packer_mux;

  xline_buffer : line_buffer
    generic map(
      WORD_PTR_WIDTH => WORD_PTR_WIDTH
      )
    port map(
      pclk                => pclk,
      pclk_reset          => pclk_reset,
      pclk_init           => pclk_buffer_init,
      pclk_write_en       => pclk_buffer_wen,
      pclk_data           => pclk_buffer_data,
      pclk_sync           => pclk_sync,
      pclk_buffer_id      => std_logic_vector(pclk_buffer_id),
      pclk_mux_id         => std_logic_vector(pclk_buffer_mux_id),
      pclk_word_ptr       => std_logic_vector(pclk_word_ptr),
      pclk_set_buff_ready => pclk_set_buff_ready,
      pclk_buff_ready     => pclk_buff_ready,
      sclk                => sclk,
      sclk_reset          => sclk_reset,
      sclk_empty          => sclk_buffer_empty_int,
      sclk_read_en        => sclk_buffer_read_en,
      sclk_buffer_id      => sclk_buffer_id,
      sclk_mux_id         => sclk_buffer_mux_id,
      sclk_word_ptr       => sclk_buffer_word_ptr,
      sclk_sync           => sclk_buffer_sync,
      sclk_data           => sclk_buffer_data_slv
      );

  sclk_buffer_data(0) <= to_pixel(sclk_buffer_data_slv(9 downto 0));
  sclk_buffer_data(1) <= to_pixel(sclk_buffer_data_slv(19 downto 10));
  sclk_buffer_data(2) <= to_pixel(sclk_buffer_data_slv(29 downto 20));

  sclk_buffer_empty <= sclk_buffer_empty_int;

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
  -- Registerfile status
  -----------------------------------------------------------------------------
  rclk_enable_hispi    <= regfile.HISPI.CTRL.ENABLE_HISPI;
  rclk_enable_datapath <= regfile.HISPI.CTRL.ENABLE_DATA_PATH;


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


  -----------------------------------------------------------------------------
  -- Process     : P_pclk_buffer_overrun
  -- Description : 
  -----------------------------------------------------------------------------
  P_pclk_buffer_overrun : process (pclk) is
  begin
    if (rising_edge(pclk)) then
      if (pclk_reset = '1')then
        pclk_buffer_overrun <= '0';
      else
        for i in 0 to 3 loop
          if (pclk_set_buff_ready(i) = '1' and pclk_buff_ready(i) = '1') then
            pclk_buffer_overrun <= '1';
            -- synthesis translate_off
            assert (false) report "Detected buffer overrun in lane_decoder" severity error;
            -- synthesis translate_on
            exit;
          else
            pclk_buffer_overrun <= '0';
          end if;
        end loop;
      end if;
    end if;
  end process;


  M_rclk_buffer_overrun : mtx_resync
    port map
    (
      aClk  => pclk,
      aClr  => pclk_reset,
      aDin  => pclk_buffer_overrun,
      bclk  => rclk,
      bclr  => rclk_reset,
      bDout => open,
      bRise => rclk_buffer_overrun,
      bFall => open
      );


  regfile.HISPI.LANE_DECODER_STATUS(LANE_ID).FIFO_OVERRUN_set <= '1' when (rclk_buffer_overrun = '1') else
                                                                 '0';


  -----------------------------------------------------------------------------
  -- Process     : P_sclk_buffer_underrun
  -- Description : 
  -----------------------------------------------------------------------------
  P_sclk_buffer_underrun : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        sclk_buffer_underrun <= '0';
      else
        if (sclk_buffer_read_en = '1') then
          if (sclk_buffer_empty_int = '1') then
            sclk_buffer_underrun <= '1';
            -- synthesis translate_off
            assert (false) report "Detected buffer underrun in lane_decoder" severity error;
          -- synthesis translate_on
          else
            sclk_buffer_underrun <= '0';
          end if;
        else
          sclk_buffer_underrun <= '0';
        end if;
      end if;
    end if;
  end process;




  M_rclk_buffer_underrun : mtx_resync
    port map
    (
      aClk  => sclk,
      aClr  => sclk_reset,
      aDin  => sclk_buffer_underrun,
      bclk  => rclk,
      bclr  => rclk_reset,
      bDout => open,
      bRise => rclk_buffer_underrun,
      bFall => open
      );


  regfile.HISPI.LANE_DECODER_STATUS(LANE_ID).FIFO_UNDERRUN_set <= '1' when (rclk_buffer_underrun = '1')else
                                                                  '0';

  -----------------------------------------------------------------------------
  -- Resync 
  -----------------------------------------------------------------------------
  M_sclk_sof : mtx_resync
    port map
    (
      aClk  => pclk,
      aClr  => pclk_reset,
      aDin  => pclk_sof,
      bclk  => sclk,
      bclr  => sclk_reset,
      bDout => open,
      bRise => sclk_sof,
      bFall => open
      );



end architecture rtl;
