-------------------------------------------------------------------------------
-- MODULE      : lane_decoder
--
-- DESCRIPTION : Decode the HiSPI stream for one lane from the SERDES output.
--               The results is stored in a dual clock FiFo (Clock domain crossing).
--
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
    hispi_clk   : in std_logic;
    hispi_reset : in std_logic;

    -- Register file interface
    idle_character : in std_logic_vector(PIXEL_SIZE-1 downto 0);
    hispi_phy_en   : in std_logic;


    -- Input stream (From XGS)
    input_data     : in std_logic_vector(PHY_OUTPUT_WIDTH-1 downto 0);

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
end entity lane_decoder;


architecture rtl of lane_decoder is


  component bit_split is
    generic (
      PHY_OUTPUT_WIDTH : integer := 6;  -- Physical lane
      PIXEL_SIZE       : integer := 12  -- Pixel size in bits
      );
    port (
      hispi_clk      : in std_logic;
      hispi_reset    : in std_logic;
      -- Register file interface
      idle_character : in std_logic_vector(PIXEL_SIZE-1 downto 0);
      hispi_phy_en   : in std_logic;

      input_data : in  std_logic_vector(PHY_OUTPUT_WIDTH-1 downto 0);
      pix_clk    : out std_logic;
      pix_data   : out std_logic_vector(PIXEL_SIZE-1 downto 0)
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

  type HISPI_STATE_TYPE is (S_UNKNOWN, S_IDL, S_SOF, S_EOF, S_SOL, S_EOL, S_FLR, S_AIL, S_CRC1, S_CRC2, S_ERROR);


  constant HISPI_WORDS_PER_SYNC_CODE : integer := 4;
  constant HISPI_SHIFT_REGISTER_SIZE : integer := PIXEL_SIZE * HISPI_WORDS_PER_SYNC_CODE;
  constant FIFO_ADDRESS_WIDTH        : integer := 6;
  constant FIFO_DATA_WIDTH           : integer := LANE_DATA_WIDTH;

  signal hispi_shift_register   : std_logic_vector(HISPI_SHIFT_REGISTER_SIZE-1 downto 0);
  signal sync_code_detected     : std_logic;
  signal idle_sequence_detected : std_logic;
  signal pix_clk                : std_logic;
  signal pix_reset              : std_logic;
  signal pix_reset_Meta1        : std_logic;
  signal pix_reset_Meta2        : std_logic;
  signal pix_data               : std_logic_vector(PIXEL_SIZE-1 downto 0);
  signal pix_data_p1            : std_logic_vector(PIXEL_SIZE-1 downto 0);
  signal hispi_fifo_full        : std_logic;
  signal hispi_fifo_wen         : std_logic;
  signal hispi_state            : HISPI_STATE_TYPE := S_UNKNOWN;
  signal dataCntr               : unsigned(2 downto 0); -- Modulo 8 counter

  signal packer_0_valid : std_logic;
  signal packer_1_valid : std_logic;
  signal packer_2_valid : std_logic;
  signal packer_3_valid : std_logic;
  signal packer_0       : std_logic_vector (LANE_DATA_WIDTH-1 downto 0) := X"00000000";
  signal packer_1       : std_logic_vector (LANE_DATA_WIDTH-1 downto 0) := X"10000000";
  signal packer_2       : std_logic_vector (LANE_DATA_WIDTH-1 downto 0) := X"20000000";
  signal packer_3       : std_logic_vector (LANE_DATA_WIDTH-1 downto 0) := X"30000000";
  signal packer_mux     : std_logic_vector (LANE_DATA_WIDTH-1 downto 0);

  signal packer_valid : std_logic;
  signal fifo_overrun : std_logic;
  signal crc_enable   : std_logic := '1';  --TBD should be register field
  signal flr_enable   : std_logic := '1';  --TBD should be register field


begin


  -----------------------------------------------------------------------------
  -- Process     : P_pix_reset
  -- Description : Resynchronize the reset on the pixel clock
  -----------------------------------------------------------------------------
  P_pix_reset : process (hispi_reset, pix_clk) is
  begin
    if (hispi_reset = '1') then
      pix_reset_Meta1 <= '1';
      pix_reset_Meta2 <= '1';
      pix_reset       <= '1';

    elsif (rising_edge(pix_clk)) then
      pix_reset_Meta1 <= '0';
      pix_reset_Meta2 <= pix_reset_Meta1;
      pix_reset       <= pix_reset_Meta2;
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
      hispi_clk      => hispi_clk,
      hispi_reset    => hispi_reset,
      idle_character => idle_character,
      hispi_phy_en   => hispi_phy_en,
      input_data     => input_data,
      pix_clk        => pix_clk,
      pix_data       => pix_data
      );


  -----------------------------------------------------------------------------
  -- Process     : P_packer
  -- Description : Generates the packar_x_valid flag one per lane
  -----------------------------------------------------------------------------
  P_packer : process (pix_clk) is
  begin
    if (rising_edge(pix_clk)) then
      if (pix_reset = '1') then
        packer_0_valid <= '0';
        packer_1_valid <= '0';
        packer_2_valid <= '0';
        packer_3_valid <= '0';
      else
        if (hispi_state = S_AIL) then
          case dataCntr is
            -------------------------------------------------------------------
            -- Phase 0 : Packing pixel from lane 0 in packer_0
            -------------------------------------------------------------------
            when "000" =>
              packer_0_valid        <= '0';
              packer_1_valid        <= '0';
              packer_2_valid        <= '0';
              packer_3_valid        <= '0';
              packer_0(11 downto 0) <= pix_data_p1;
              
            -------------------------------------------------------------------
            -- Phase 1 : Packing pixel from lane 1 in packer_1
            -------------------------------------------------------------------
            when "001" =>
              packer_0_valid        <= '0';
              packer_1_valid        <= '0';
              packer_2_valid        <= '0';
              packer_3_valid        <= '0';
              packer_1(11 downto 0) <= pix_data_p1;

            -------------------------------------------------------------------
            -- Phase 2 : Packing pixel from lane 2 in packer_2 
            -------------------------------------------------------------------
            when "010" =>
              packer_0_valid        <= '0';
              packer_1_valid        <= '0';
              packer_2_valid        <= '0';
              packer_3_valid        <= '0';
              packer_2(11 downto 0) <= pix_data_p1;

            -------------------------------------------------------------------
            -- Phase 3 : Packing pixel from lane 3 in packer_3
            -------------------------------------------------------------------
             when "011" =>
              packer_0_valid        <= '0';
              packer_1_valid        <= '0';
              packer_2_valid        <= '0';
              packer_3_valid        <= '0';
              packer_3(11 downto 0) <= pix_data_p1;

            -------------------------------------------------------------------
            -- Phase 4 : Packing pixel from lane 0 in packer_0 and ready to flush
            -------------------------------------------------------------------
            when "100" =>
              packer_0_valid         <= '1';
              packer_1_valid         <= '0';
              packer_2_valid         <= '0';
              packer_3_valid         <= '0';
              packer_0(27 downto 16) <= pix_data_p1;

            -------------------------------------------------------------------
            -- Phase 5 : Packing pixel from lane 1 in packer_1 and ready to flush
            -------------------------------------------------------------------
            when "101" =>
              packer_0_valid         <= '0';
              packer_1_valid         <= '1';
              packer_2_valid         <= '0';
              packer_3_valid         <= '0';
              packer_1(27 downto 16) <= pix_data_p1;
              
            -------------------------------------------------------------------
            -- Phase 6 : Packing pixel from lane 2 in packer_2 and ready to flush
            -------------------------------------------------------------------
            when "110" =>
              packer_0_valid         <= '0';
              packer_1_valid         <= '0';
              packer_2_valid         <= '1';
              packer_3_valid         <= '0';
              packer_2(27 downto 16) <= pix_data_p1;
              
            -------------------------------------------------------------------
            -- Phase 7 : Packing pixel from lane 3 in packer_3 and ready to flush
            -------------------------------------------------------------------
            when "111" =>
              packer_0_valid         <= '0';
              packer_1_valid         <= '0';
              packer_2_valid         <= '0';
              packer_3_valid         <= '1';
              packer_3(27 downto 16) <= pix_data_p1;
            when others =>
              null;
          end case;

        -----------------------------------------------------------------------
        -- Any other states, no data valid (No packing)
        -----------------------------------------------------------------------
        else
          packer_0_valid <= '0';
          packer_1_valid <= '0';
          packer_2_valid <= '0';
          packer_3_valid <= '0';
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : packer_mux 
  -- Description : 4-to-1 Multiplexer
  -----------------------------------------------------------------------------
  packer_mux <= packer_0 when (dataCntr = "101") else
                packer_1 when (dataCntr = "110") else
                packer_2 when (dataCntr = "111") else
                packer_3 when (dataCntr = "000") else
                (others => '0');


  packer_valid <= '1' when (dataCntr = "101" and packer_0_valid = '1') else
                  '1' when (dataCntr = "110" and packer_1_valid = '1') else
                  '1' when (dataCntr = "111" and packer_2_valid = '1') else
                  '1' when (dataCntr = "000" and packer_3_valid = '1') else
                  '0';


  -----------------------------------------------------------------------------
  -- Process     : P_dataCntr
  -- Description : Modulo 8 phase counter. Used to de-interlace data from
  --               4 lanes. 
  -----------------------------------------------------------------------------
  P_dataCntr : process (pix_clk) is
  begin
    if (rising_edge(pix_clk)) then
      if (pix_reset = '1') then
        -- initialize with max count value
        dataCntr <= (others => '1');
      else
        -- Align the counter phase with the line sync
        if (sync_code_detected = '1') then
          dataCntr <= (others => '1');
        -- As long as valid pixels are received, count modulo 8
        -- then wrap around.
        elsif (hispi_phy_en = '1'and hispi_state /= S_IDL) then
          dataCntr <= dataCntr + 1;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_hispi_shift_register
  -- Description : Generate shift register data. Shift left by one pixel on  
  --               every clock cycle
  -----------------------------------------------------------------------------
  P_hispi_shift_register : process (pix_clk) is
    variable dst_msb : integer;
    variable dst_lsb : integer;
    variable src_msb : integer;
    variable src_lsb : integer;
  begin
    if (rising_edge(pix_clk)) then
      if (pix_reset = '1') then
        -- initialize with all 0's
        hispi_shift_register <= (others => '0');
      else

        src_lsb := 0;
        src_msb := 3*PIXEL_SIZE-1;

        dst_lsb := PIXEL_SIZE;
        dst_msb := HISPI_SHIFT_REGISTER_SIZE-1;

        -- Shift data left PHY_OUTPUT_WIDTH bits for each lane.
        hispi_shift_register(pix_data'range)         <= pix_data;
        hispi_shift_register(dst_msb downto dst_lsb) <= hispi_shift_register(src_msb downto src_lsb);
      end if;
    end if;
  end process;


  pix_data_p1 <= hispi_shift_register(23 downto 12);

  
  -----------------------------------------------------------------------------
  -- Detect sync_code codes, SOF, SOL, EOF, EOL alignment
  -- don't assume a hispi phase but check all possibilities
  -- that is, hispi word boundaries can be on any of PHY_OUTPUT_WIDTH boundaries
  -----------------------------------------------------------------------------
  P_detect_sync_codes : process (hispi_shift_register) is
    variable msb : integer;
    variable lsb : integer;

  begin

    lsb := PIXEL_SIZE;
    msb := HISPI_SHIFT_REGISTER_SIZE-1;

    if (
      (hispi_shift_register(msb downto lsb) = X"FFF000000")
      ) then
      sync_code_detected <= '1';
    else
      sync_code_detected <= '0';
    end if;

  end process;


  -----------------------------------------------------------------------------
  -- Detect IDLE sequence (4 consecutive IDLE characters)
  -----------------------------------------------------------------------------
  P_idle_sequence_detected : process (hispi_shift_register, idle_character) is
    variable idle_quad_vector : std_logic_vector(hispi_shift_register'range);
  begin
    idle_quad_vector := idle_character & idle_character & idle_character & idle_character;

    if (hispi_shift_register = idle_quad_vector) then
      idle_sequence_detected <= '1';
    else
      idle_sequence_detected <= '0';
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_hispi_state
  -- Description : Decode the hispi protocol state
  -----------------------------------------------------------------------------
  P_hispi_state : process (pix_clk) is
  begin
    if (rising_edge(pix_clk)) then
      if (pix_reset = '1' or hispi_phy_en = '0')then
        hispi_state  <= S_UNKNOWN;
        embeded_data <= '1';
      else
        if (idle_sequence_detected = '1') then
          hispi_state  <= S_IDL;
          embeded_data <= '1';
        else
          case hispi_state is
            -------------------------------------------------------------------
            -- S_IDL : 
            -------------------------------------------------------------------
            when S_IDL =>
              if (sync_code_detected = '1') then
                if (hispi_shift_register(11 downto 8) = "1100") then
                  hispi_state  <= S_SOF;
                  embeded_data <= hispi_shift_register(7);
                elsif(hispi_shift_register(11 downto 8) = "1000") then
                  hispi_state  <= S_SOL;
                  embeded_data <= hispi_shift_register(7);
                else
                  hispi_state <= S_ERROR;
                end if;
              else
                hispi_state <= S_IDL;
              end if;


            -------------------------------------------------------------------
            -- S_SOF : 
            -------------------------------------------------------------------
            when S_SOF =>
              hispi_state <= S_AIL;


            -------------------------------------------------------------------
            -- S_SOL : 
            -------------------------------------------------------------------
            when S_SOL =>
              hispi_state <= S_AIL;


            -------------------------------------------------------------------
            -- S_EOF : 
            -------------------------------------------------------------------
            when S_EOF =>
              if (crc_enable = '1') then
                hispi_state <= S_CRC1;
              else
                hispi_state <= S_IDL;
              end if;


            -------------------------------------------------------------------
            -- S_EOL : 
            -------------------------------------------------------------------
            when S_EOL =>
              if (crc_enable = '1') then
                hispi_state <= S_CRC1;
              else
                hispi_state <= S_IDL;
              end if;


            -------------------------------------------------------------------
            -- S_AIL : 
            -------------------------------------------------------------------
            when S_AIL =>
              if (sync_code_detected = '1') then
                if(hispi_shift_register(11 downto 9) = "111") then
                  hispi_state <= S_EOF;
                elsif(hispi_shift_register(11 downto 9) = "101") then
                  hispi_state <= S_EOL;
                else
                  hispi_state <= S_ERROR;
                end if;
              else
                hispi_state <= S_AIL;
              end if;


            -------------------------------------------------------------------
            -- S_CRC1 : 
            -------------------------------------------------------------------
            when S_CRC1 =>
              hispi_state <= S_CRC2;


            -------------------------------------------------------------------
            -- S_CRC2 : 
            -------------------------------------------------------------------
            when S_CRC2 =>
              hispi_state <= S_IDL;


            -------------------------------------------------------------------
            -- S_ERROR : 
            -------------------------------------------------------------------
            when S_ERROR =>
              hispi_state <= S_UNKNOWN;


            -------------------------------------------------------------------
            -- 
            -------------------------------------------------------------------
            when others =>
              hispi_state <= S_ERROR;

          end case;
        end if;
      end if;
    end if;
  end process P_hispi_state;


  sof_flag <= '1' when (hispi_state = S_SOF) else '0';
  eof_flag <= '1' when (hispi_state = S_EOF) else '0';
  sol_flag <= '1' when (hispi_state = S_SOL) else '0';
  eol_flag <= '1' when (hispi_state = S_EOL) else '0';


  hispi_fifo_wen <= '1' when (hispi_state = S_AIL and packer_valid = '1') else
                    '0';


  P_fifo_overrun : process (pix_clk) is
  begin
    if (rising_edge(pix_clk)) then
      if (pix_reset = '1')then
        fifo_overrun <= '0';
      else
        if (hispi_fifo_full = '1' and hispi_fifo_wen = '1') then
          fifo_overrun <= '1';
        else
          fifo_overrun <= '0';
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
      aClr   => pix_reset,
      wClk   => pix_clk,
      wEn    => hispi_fifo_wen,
      wData  => packer_mux,
      wFull  => hispi_fifo_full,
      rClk   => fifo_read_clk,
      rEn    => fifo_read_en,
      rData  => fifo_read_data,
      rEmpty => fifo_empty
      );


  -----------------------------------------------------------------------------
  -- Process     : P_fifo_read_data_valid
  -- Description : Data valid flag.
  -----------------------------------------------------------------------------
  P_fifo_read_data_valid : process (fifo_read_clk) is
  begin
    if (rising_edge(fifo_read_clk)) then
      fifo_read_data_valid <= fifo_read_en;
    end if;
  end process;

  
end architecture rtl;
