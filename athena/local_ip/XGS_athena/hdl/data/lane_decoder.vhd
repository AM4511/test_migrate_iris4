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
-- TODO          : Implement CRC
--                 Implement clock domain crossing for calibration signals!!!
--                 Implement Lane lock mechanism (watchdog counter)
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity lane_decoder is
  generic (
    PHY_OUTPUT_WIDTH : integer := 6;    -- Physical lane
    PIXEL_SIZE       : integer := 12;   -- Pixel size in bits
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
    aclk_idle_character : in  std_logic_vector(PIXEL_SIZE-1 downto 0);
    aclk_hispi_phy_en   : in  std_logic;
    aclk_tap_histogram  : out std_logic_vector(31 downto 0);

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
      aclk_idle_char : in std_logic_vector(PIXEL_SIZE-1 downto 0);

      ---------------------------------------------------------------------------
      -- Pixel clock domain
      ---------------------------------------------------------------------------
      pclk            : out std_logic;
      pclk_bit_locked : out std_logic;
      pclk_data       : out std_logic_vector(PIXEL_SIZE-1 downto 0)
      );
  end component;


  component tap_controller is
    generic (
      PIXEL_SIZE : integer := 12
      );
    port (
      pclk                : in  std_logic;
      pclk_reset          : in  std_logic;
      pclk_pixel          : in  std_logic_vector(PIXEL_SIZE-1 downto 0);
      pclk_idle_character : in  std_logic_vector(PIXEL_SIZE-1 downto 0);
      pclk_cal_en         : in  std_logic;
      pclk_cal_busy       : out std_logic;
      pclk_cal_error      : out std_logic;
      pclk_cal_load_tap   : out std_logic;
      pclk_cal_tap_value  : out std_logic_vector(4 downto 0);
      pclk_tap_histogram  : out std_logic_vector(31 downto 0)
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

  type FSM_STATE_TYPE is (S_UNKNOWN, S_IDLE, S_SOF, S_EOF, S_SOL, S_EOL, S_FLR, S_AIL, S_CRC1, S_CRC2, S_ERROR);

  constant HISPI_WORDS_PER_SYNC_CODE : integer := 4;
  constant PIX_SHIFT_REGISTER_SIZE   : integer := PIXEL_SIZE * HISPI_WORDS_PER_SYNC_CODE;
  constant FIFO_ADDRESS_WIDTH        : integer := 6;
  constant FIFO_DATA_WIDTH           : integer := LANE_DATA_WIDTH;

  signal pclk                : std_logic;
  signal pclk_reset          : std_logic;
  signal pclk_reset_Meta1    : std_logic;
  signal pclk_reset_Meta2    : std_logic;
  signal pclk_shift_register : std_logic_vector(PIX_SHIFT_REGISTER_SIZE-1 downto 0);
  signal pclk_data           : std_logic_vector(PIXEL_SIZE-1 downto 0);
  signal pclk_data_p1        : std_logic_vector(PIXEL_SIZE-1 downto 0);
  signal pclk_bit_locked     : std_logic;
  signal pclk_cal_busy_int   : std_logic;

  signal pclk_hispi_phy_en : std_logic;
  signal pclk_embeded_data : std_logic;
  signal pclk_sof_flag     : std_logic;
  signal pclk_eof_flag     : std_logic;
  signal pclk_sol_flag     : std_logic;
  signal pclk_eol_flag     : std_logic;
  signal pclk_fifo_overrun : std_logic;
  signal pclk_fifo_wen     : std_logic;
  signal pclk_fifo_full    : std_logic;
  signal pclk_packer_mux   : std_logic_vector (LANE_DATA_WIDTH-1 downto 0);
  signal pclk_state        : FSM_STATE_TYPE := S_UNKNOWN;
  signal pclk_dataCntr     : unsigned(2 downto 0);  -- Modulo 8 counter

  signal pclk_sync_detected : std_logic;
  signal pclk_packer_valid  : std_logic;

  signal pclk_packer_0_valid : std_logic;
  signal pclk_packer_1_valid : std_logic;
  signal pclk_packer_2_valid : std_logic;
  signal pclk_packer_3_valid : std_logic;
  signal pclk_packer_0       : std_logic_vector (LANE_DATA_WIDTH-1 downto 0) := X"00000000";
  signal pclk_packer_1       : std_logic_vector (LANE_DATA_WIDTH-1 downto 0) := X"10000000";
  signal pclk_packer_2       : std_logic_vector (LANE_DATA_WIDTH-1 downto 0) := X"20000000";
  signal pclk_packer_3       : std_logic_vector (LANE_DATA_WIDTH-1 downto 0) := X"30000000";

  signal pclk_crc_enable          : std_logic := '1';
  signal pclk_tap_histogram       : std_logic_vector (31 downto 0);
  signal aclk_fifo_empty_int      : std_logic;
  signal aclk_fifo_overrun_int    : std_logic;
  signal aclk_bit_locked_int      : std_logic;
  signal aclk_bit_locked_rise_int : std_logic;
  signal aclk_bit_locked_fall_int : std_logic;
  signal aclk_latch_tap_histogram : std_logic;

  -----------------------------------------------------------------------------
  -- Debug attributes on pclk clock domain
  -----------------------------------------------------------------------------
  attribute mark_debug of pclk_data                : signal is "true";
  attribute mark_debug of pclk_data_p1             : signal is "true";
  attribute mark_debug of pclk_state               : signal is "true";
  attribute mark_debug of pclk_sync_detected       : signal is "true";
  attribute mark_debug of pclk_shift_register      : signal is "true";
  attribute mark_debug of pclk_embeded_data        : signal is "true";
  attribute mark_debug of pclk_crc_enable          : signal is "true";
  attribute mark_debug of pclk_packer_0            : signal is "true";
  attribute mark_debug of pclk_packer_1            : signal is "true";
  attribute mark_debug of pclk_packer_2            : signal is "true";
  attribute mark_debug of pclk_packer_3            : signal is "true";
  attribute mark_debug of pclk_packer_0_valid      : signal is "true";
  attribute mark_debug of pclk_packer_1_valid      : signal is "true";
  attribute mark_debug of pclk_packer_2_valid      : signal is "true";
  attribute mark_debug of pclk_packer_3_valid      : signal is "true";
  attribute mark_debug of pclk_dataCntr            : signal is "true";
  attribute mark_debug of pclk_packer_mux          : signal is "true";
  attribute mark_debug of pclk_packer_valid        : signal is "true";
  attribute mark_debug of pclk_sof_flag            : signal is "true";
  attribute mark_debug of pclk_eof_flag            : signal is "true";
  attribute mark_debug of pclk_sol_flag            : signal is "true";
  attribute mark_debug of pclk_eol_flag            : signal is "true";
  attribute mark_debug of pclk_fifo_wen            : signal is "true";
  attribute mark_debug of pclk_fifo_overrun        : signal is "true";
  attribute mark_debug of pclk_fifo_full           : signal is "true";
  attribute mark_debug of aclk_latch_tap_histogram : signal is "true";

begin


  -----------------------------------------------------------------------------
  -- Process     : P_pclk_reset
  -- Description : Resynchronize the reset on the pixel clock
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
      aclk_idle_char  => aclk_idle_character,
      pclk            => pclk,
      pclk_bit_locked => pclk_bit_locked,
      pclk_data       => pclk_data
      );


  -----------------------------------------------------------------------------
  -- Resync aclk_eof_flag
  -----------------------------------------------------------------------------
  M_pclk_hispi_phy_en : mtx_resync
    port map
    (
      aClk  => aclk,
      aClr  => aclk_reset,
      aDin  => aclk_hispi_phy_en,
      bclk  => pclk,
      bclr  => pclk_reset,
      bDout => pclk_hispi_phy_en,
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
      pclk                => pclk,
      pclk_reset          => pclk_reset,
      pclk_pixel          => pclk_data,
      pclk_idle_character => aclk_idle_character,
      pclk_cal_en         => pclk_cal_en,
      pclk_cal_busy       => pclk_cal_busy_int,
      pclk_cal_error      => pclk_cal_error,
      pclk_cal_load_tap   => pclk_cal_load_tap,
      pclk_cal_tap_value  => pclk_cal_tap_value,
      pclk_tap_histogram  => pclk_tap_histogram
      );

  pclk_cal_busy <= pclk_cal_busy_int;


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
        if (pclk_state = S_AIL) then
          case pclk_dataCntr is
            -------------------------------------------------------------------
            -- Phase 0 : Packing pixel from lane 0 in pclk_packer_0
            -------------------------------------------------------------------
            when "000" =>
              pclk_packer_0_valid        <= '0';
              pclk_packer_1_valid        <= '0';
              pclk_packer_2_valid        <= '0';
              pclk_packer_3_valid        <= '0';
              pclk_packer_0(11 downto 0) <= pclk_data_p1;

            -------------------------------------------------------------------
            -- Phase 1 : Packing pixel from lane 1 in pclk_packer_1
            -------------------------------------------------------------------
            when "001" =>
              pclk_packer_0_valid        <= '0';
              pclk_packer_1_valid        <= '0';
              pclk_packer_2_valid        <= '0';
              pclk_packer_3_valid        <= '0';
              pclk_packer_1(11 downto 0) <= pclk_data_p1;

            -------------------------------------------------------------------
            -- Phase 2 : Packing pixel from lane 2 in pclk_packer_2 
            -------------------------------------------------------------------
            when "010" =>
              pclk_packer_0_valid        <= '0';
              pclk_packer_1_valid        <= '0';
              pclk_packer_2_valid        <= '0';
              pclk_packer_3_valid        <= '0';
              pclk_packer_2(11 downto 0) <= pclk_data_p1;

            -------------------------------------------------------------------
            -- Phase 3 : Packing pixel from lane 3 in pclk_packer_3
            -------------------------------------------------------------------
            when "011" =>
              pclk_packer_0_valid        <= '0';
              pclk_packer_1_valid        <= '0';
              pclk_packer_2_valid        <= '0';
              pclk_packer_3_valid        <= '0';
              pclk_packer_3(11 downto 0) <= pclk_data_p1;

            -------------------------------------------------------------------
            -- Phase 4 : Packing pixel from lane 0 in pclk_packer_0 and ready to flush
            -------------------------------------------------------------------
            when "100" =>
              pclk_packer_0_valid         <= '1';
              pclk_packer_1_valid         <= '0';
              pclk_packer_2_valid         <= '0';
              pclk_packer_3_valid         <= '0';
              pclk_packer_0(27 downto 16) <= pclk_data_p1;

            -------------------------------------------------------------------
            -- Phase 5 : Packing pixel from lane 1 in pclk_packer_1 and ready to flush
            -------------------------------------------------------------------
            when "101" =>
              pclk_packer_0_valid         <= '0';
              pclk_packer_1_valid         <= '1';
              pclk_packer_2_valid         <= '0';
              pclk_packer_3_valid         <= '0';
              pclk_packer_1(27 downto 16) <= pclk_data_p1;

            -------------------------------------------------------------------
            -- Phase 6 : Packing pixel from lane 2 in pclk_packer_2 and ready to flush
            -------------------------------------------------------------------
            when "110" =>
              pclk_packer_0_valid         <= '0';
              pclk_packer_1_valid         <= '0';
              pclk_packer_2_valid         <= '1';
              pclk_packer_3_valid         <= '0';
              pclk_packer_2(27 downto 16) <= pclk_data_p1;

            -------------------------------------------------------------------
            -- Phase 7 : Packing pixel from lane 3 in pclk_packer_3 and ready to flush
            -------------------------------------------------------------------
            when "111" =>
              pclk_packer_0_valid         <= '0';
              pclk_packer_1_valid         <= '0';
              pclk_packer_2_valid         <= '0';
              pclk_packer_3_valid         <= '1';
              pclk_packer_3(27 downto 16) <= pclk_data_p1;
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
        pclk_dataCntr <= (others => '1');
      else
        -- Align the counter phase with the line sync
        if (pclk_sync_detected = '1') then
          pclk_dataCntr <= (others => '1');
        -- As long as valid pixels are received, count modulo 8
        -- then wrap around.
        elsif (pclk_hispi_phy_en = '1'and pclk_state /= S_IDLE) then
          pclk_dataCntr <= pclk_dataCntr + 1;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_pclk_shift_register
  -- Description : Generate shift register data. Shift left by one pixel on  
  --               every clock cycle
  -----------------------------------------------------------------------------
  P_pclk_shift_register : process (pclk) is
    variable dst_msb : integer;
    variable dst_lsb : integer;
    variable src_msb : integer;
    variable src_lsb : integer;
  begin
    if (rising_edge(pclk)) then
      if (pclk_reset = '1') then
        -- initialize with all 0's
        pclk_shift_register <= (others => '0');
      else

        src_lsb := 0;
        src_msb := 3*PIXEL_SIZE-1;

        dst_lsb := PIXEL_SIZE;
        dst_msb := PIX_SHIFT_REGISTER_SIZE-1;

        -- Shift data left PHY_OUTPUT_WIDTH bits for each lane.
        pclk_shift_register(pclk_data'range)        <= pclk_data;
        pclk_shift_register(dst_msb downto dst_lsb) <= pclk_shift_register(src_msb downto src_lsb);
      end if;
    end if;
  end process;


  pclk_data_p1 <= pclk_shift_register(23 downto 12);


  -----------------------------------------------------------------------------
  -- Detect sync_code codes, SOF, SOL, EOF, EOL alignment
  -- don't assume a hispi phase but check all possibilities
  -- that is, hispi word boundaries can be on any of PHY_OUTPUT_WIDTH boundaries
  -----------------------------------------------------------------------------
  P_detect_sync_codes : process (pclk_shift_register) is
    variable msb : integer;
    variable lsb : integer;

  begin

    lsb := PIXEL_SIZE;
    msb := PIX_SHIFT_REGISTER_SIZE-1;

    if (
      (pclk_shift_register(msb downto lsb) = X"FFF000000")
      ) then
      pclk_sync_detected <= '1';
    else
      pclk_sync_detected <= '0';
    end if;

  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_pclk_state
  -- Description : Decode the hispi protocol state
  -----------------------------------------------------------------------------
  P_pclk_state : process (pclk) is
  begin
    if (rising_edge(pclk)) then
      if (pclk_reset = '1' or pclk_hispi_phy_en = '0')then
        pclk_state        <= S_UNKNOWN;
        pclk_embeded_data <= '1';
      else
        case pclk_state is
          -------------------------------------------------------------------
          -- S_IDLE : 
          -------------------------------------------------------------------
          when S_IDLE =>
            if (pclk_sync_detected = '1') then
              if (pclk_shift_register(11 downto 8) = "1100") then
                pclk_state        <= S_SOF;
                pclk_embeded_data <= pclk_shift_register(7);
              elsif(pclk_shift_register(11 downto 8) = "1000") then
                pclk_state        <= S_SOL;
                pclk_embeded_data <= pclk_shift_register(7);
              else
                pclk_state <= S_ERROR;
              end if;
            else
              pclk_state <= S_IDLE;
            end if;


          -------------------------------------------------------------------
          -- S_SOF : 
          -------------------------------------------------------------------
          when S_SOF =>
            pclk_state <= S_AIL;


          -------------------------------------------------------------------
          -- S_SOL : 
          -------------------------------------------------------------------
          when S_SOL =>
            pclk_state <= S_AIL;


          -------------------------------------------------------------------
          -- S_EOF : 
          -------------------------------------------------------------------
          when S_EOF =>
            if (pclk_crc_enable = '1') then
              pclk_state <= S_CRC1;
            else
              pclk_state <= S_IDLE;
            end if;


          -------------------------------------------------------------------
          -- S_EOL : 
          -------------------------------------------------------------------
          when S_EOL =>
            if (pclk_crc_enable = '1') then
              pclk_state <= S_CRC1;
            else
              pclk_state <= S_IDLE;
            end if;


          -------------------------------------------------------------------
          -- S_AIL : 
          -------------------------------------------------------------------
          when S_AIL =>
            if (pclk_sync_detected = '1') then
              if(pclk_shift_register(11 downto 9) = "111") then
                pclk_state <= S_EOF;
              elsif(pclk_shift_register(11 downto 9) = "101") then
                pclk_state <= S_EOL;
              else
                pclk_state <= S_ERROR;
              end if;
            else
              pclk_state <= S_AIL;
            end if;


          -------------------------------------------------------------------
          -- S_CRC1 : 
          -------------------------------------------------------------------
          when S_CRC1 =>
            pclk_state <= S_CRC2;


          -------------------------------------------------------------------
          -- S_CRC2 : 
          -------------------------------------------------------------------
          when S_CRC2 =>
            pclk_state <= S_IDLE;


          -------------------------------------------------------------------
          -- S_ERROR : 
          -------------------------------------------------------------------
          when S_ERROR =>
            pclk_state <= S_UNKNOWN;


          -------------------------------------------------------------------
          -- 
          -------------------------------------------------------------------
          when others =>
            pclk_state <= S_IDLE;

        end case;
      end if;
    end if;
  end process P_pclk_state;


  pclk_sof_flag <= '1' when (pclk_state = S_SOF) else '0';
  pclk_eof_flag <= '1' when (pclk_state = S_EOF) else '0';
  pclk_sol_flag <= '1' when (pclk_state = S_SOL) else '0';
  pclk_eol_flag <= '1' when (pclk_state = S_EOL) else '0';


  pclk_fifo_wen <= '1' when (pclk_state = S_AIL and pclk_packer_valid = '1') else
                   '0';


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
      rClk   => aclk,
      rEn    => aclk_fifo_read_en,
      rData  => aclk_fifo_read_data,
      rEmpty => aclk_fifo_empty_int
      );




  -----------------------------------------------------------------------------
  -- Resync aclk_embeded_data
  -----------------------------------------------------------------------------
  M_aclk_embeded_data : mtx_resync
    port map
    (
      aClk  => pclk,
      aClr  => pclk_reset,
      aDin  => pclk_embeded_data,
      bclk  => aclk,
      bclr  => aclk_reset,
      bDout => aclk_embeded_data,
      bRise => open,
      bFall => open
      );

  -----------------------------------------------------------------------------
  -- Resync aclk_sof_flag
  -----------------------------------------------------------------------------
  M_aclk_sof_flag : mtx_resync
    port map
    (
      aClk  => pclk,
      aClr  => pclk_reset,
      aDin  => pclk_sof_flag,
      bclk  => aclk,
      bclr  => aclk_reset,
      bDout => aclk_sof_flag,
      bRise => open,
      bFall => open
      );

  -----------------------------------------------------------------------------
  -- Resync aclk_eof_flag
  -----------------------------------------------------------------------------
  M_aclk_eof_flag : mtx_resync
    port map
    (
      aClk  => pclk,
      aClr  => pclk_reset,
      aDin  => pclk_eof_flag,
      bclk  => aclk,
      bclr  => aclk_reset,
      bDout => aclk_eof_flag,
      bRise => open,
      bFall => open
      );

  -----------------------------------------------------------------------------
  -- Resync aclk_sol_flag
  -----------------------------------------------------------------------------
  M_aclk_sol_flag : mtx_resync
    port map
    (
      aClk  => pclk,
      aClr  => pclk_reset,
      aDin  => pclk_sol_flag,
      bclk  => aclk,
      bclr  => aclk_reset,
      bDout => aclk_sol_flag,
      bRise => open,
      bFall => open
      );

  -----------------------------------------------------------------------------
  -- Resync aclk_eof_flag
  -----------------------------------------------------------------------------
  M_aclk_eol_flag : mtx_resync
    port map
    (
      aClk  => pclk,
      aClr  => pclk_reset,
      aDin  => pclk_eol_flag,
      bclk  => aclk,
      bclr  => aclk_reset,
      bDout => aclk_eol_flag,
      bRise => open,
      bFall => open
      );


  -----------------------------------------------------------------------------
  -- Resync aclk_eof_flag
  -----------------------------------------------------------------------------
  M_aclk_fifo_overrun : mtx_resync
    port map
    (
      aClk  => pclk,
      aClr  => pclk_reset,
      aDin  => pclk_fifo_overrun,
      bclk  => aclk,
      bclr  => aclk_reset,
      bDout => aclk_fifo_overrun_int,
      bRise => open,
      bFall => open
      );


  -----------------------------------------------------------------------------
  -- Resync aclk_bit_locked
  -----------------------------------------------------------------------------
  M_aclk_bit_locked : mtx_resync
    port map
    (
      aClk  => pclk,
      aClr  => pclk_reset,
      aDin  => pclk_bit_locked,
      bclk  => aclk,
      bclr  => aclk_reset,
      bDout => aclk_bit_locked_int,
      bRise => aclk_bit_locked_rise_int,
      bFall => aclk_bit_locked_fall_int
      );

  -----------------------------------------------------------------------------
  -- Resync aclk_bit_locked
  -----------------------------------------------------------------------------
  M_aclk_latch_tap_histogram : mtx_resync
    port map
    (
      aClk  => pclk,
      aClr  => pclk_reset,
      aDin  => pclk_cal_busy_int,
      bclk  => aclk,
      bclr  => aclk_reset,
      bDout => open,
      bRise => open,
      bFall => aclk_latch_tap_histogram
      );

  -----------------------------------------------------------------------------
  -- Process     : P_aclk_fifo_read_data_valid
  -- Description : Indicates presence of read data on the FiFo read data bus.
  -----------------------------------------------------------------------------
  P_aclk_fifo_read_data_valid : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1') then
        aclk_fifo_read_data_valid <= '0';
      else
        aclk_fifo_read_data_valid <= aclk_fifo_read_en;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_aclk_fifo_overrun
  -- Description : We gate aclk_fifo_overrun_int with aclk_hispi_phy_en
  --               otherwise can generate an overflow error in th register file
  --               when there is no pixclk available
  -----------------------------------------------------------------------------
  P_aclk_fifo_overrun : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1') then
        aclk_fifo_overrun <= '0';
      else
        if (aclk_hispi_phy_en = '1') then
          aclk_fifo_overrun <= aclk_fifo_overrun_int;
        else
          aclk_fifo_overrun <= '0';
        end if;
      end if;
    end if;
  end process;

  -----------------------------------------------------------------------------
  -- Process     : P_aclk_bit_locked
  -- Description : 
  -----------------------------------------------------------------------------
  P_aclk_bit_locked : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1') then
        aclk_bit_locked      <= '0';
        aclk_bit_locked_rise <= '0';
        aclk_bit_locked_fall <= '0';
      else
        if (aclk_hispi_phy_en = '1') then
          aclk_bit_locked      <= aclk_bit_locked_int;
          aclk_bit_locked_rise <= aclk_bit_locked_rise_int;
          aclk_bit_locked_fall <= aclk_bit_locked_fall_int;
        else
          aclk_bit_locked      <= '0';
          aclk_bit_locked_rise <= '0';
          aclk_bit_locked_fall <= '0';
        end if;
      end if;
    end if;
  end process;



  -----------------------------------------------------------------------------
  -- Process     : P_aclk_fifo_underrun
  -- Description : Flag a FiFo underrun error condition
  -----------------------------------------------------------------------------
  P_aclk_fifo_underrun : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1') then
        aclk_fifo_underrun <= '0';
      else
        if (aclk_fifo_read_en = '1' and aclk_fifo_empty_int = '1') then
          aclk_fifo_underrun <= '1';
        else
          aclk_fifo_underrun <= '0';
        end if;
      end if;
    end if;
  end process;

  -----------------------------------------------------------------------------
  -- Process     : P_aclk_tap_histogram
  -- Description : 
  -----------------------------------------------------------------------------
  P_aclk_tap_histogram : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1') then
        aclk_tap_histogram <= (others => '0');
      else
        if (aclk_latch_tap_histogram = '1') then
          aclk_tap_histogram <= pclk_tap_histogram;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Send the pixel clock to the higher level of hierarchy 
  -----------------------------------------------------------------------------
  pix_clk         <= pclk;
  aclk_fifo_empty <= aclk_fifo_empty_int;


end architecture rtl;
