-------------------------------------------------------------------------------
-- MODULE      : bit_split
--
-- DESCRIPTION : Extract the pixels from the serial stream. Find the pixel
--               bit-alignment in the input serial stream. Uses the idle
--               character to determine this alignment. The extraction is based
--               on the detection of 4 consecutives idle_character. This module
--               Also provide the associated pixel clock.
--
--  ToDo       : This file should be renamed bit SLIP (not split!!! Daah...;-)     
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library work;
use work.mtx_types_pkg.all;


entity bit_split is
  generic (
    PHY_OUTPUT_WIDTH : integer := 6;    -- SERDES parallel width in bits
    PIXEL_SIZE       : integer := 12    -- Pixel size in bits
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
    hclk_idle_char : in std_logic_vector(PIXEL_SIZE-1 downto 0);

    ---------------------------------------------------------------------------
    -- Pixel clock domain
    ---------------------------------------------------------------------------
    pclk            : in  std_logic;
    pclk_bit_locked : out std_logic;
    pclk_data       : out std_logic_vector(PIXEL_SIZE-1 downto 0)
    );
end entity bit_split;


architecture rtl of bit_split is

  attribute mark_debug : string;
  attribute keep       : string;

  constant HISPI_WORDS_PER_SYNC_CODE : integer := 4;
  constant HISPI_SHIFT_REGISTER_SIZE : integer := HISPI_WORDS_PER_SYNC_CODE * PIXEL_SIZE + PHY_OUTPUT_WIDTH;

  signal hclk_phase               : std_logic             := '0';
  signal hclk_shift_register      : std_logic_vector (HISPI_SHIFT_REGISTER_SIZE-1 downto 0);
  signal hclk_lsb_ptr             : integer range 0 to PIXEL_SIZE-1;
  signal hclk_lsb_ptr_reg         : integer range 0 to 2*PIXEL_SIZE-1;
  signal hclk_aligned_pixel_mux   : std_logic_vector (PIXEL_SIZE- 1 downto 0);
  signal hclk_data                : std_logic_vector(PIXEL_SIZE-1 downto 0);
  signal hclk_idle_detected       : std_logic;
  signal hclk_lock_cntr_max_value : unsigned(12 downto 0) := (others => '1');
  signal hclk_lock_cntr           : unsigned(12 downto 0);
  signal hclk_bit_locked          : std_logic;

  -----------------------------------------------------------------------------
  -- Debug attributes
  -----------------------------------------------------------------------------
  attribute mark_debug of hclk_reset          : signal is "true";
  attribute mark_debug of hclk_data_lane      : signal is "true";
  attribute mark_debug of hclk_data           : signal is "true";
  attribute mark_debug of hclk_idle_char      : signal is "true";
  attribute mark_debug of hclk_shift_register : signal is "true";
  attribute mark_debug of hclk_lsb_ptr_reg    : signal is "true";
  attribute mark_debug of hclk_idle_detected  : signal is "true";
  attribute mark_debug of hclk_lock_cntr      : signal is "true";
  attribute mark_debug of hclk_bit_locked     : signal is "true";

begin


  -----------------------------------------------------------------------------
  -- Process     : P_hclk_shift_register
  -- Description : Concatenate input data in a parallel shift register. The
  --               size of the shift register is HISPI_SHIFT_REGISTER_SIZE.
  -----------------------------------------------------------------------------
  P_hclk_shift_register : process (hclk) is
    variable src_msb : integer;
    variable src_lsb : integer;
    variable dst_msb : integer;
    variable dst_lsb : integer;

  begin
    if (rising_edge(hclk)) then
      if (hclk_reset = '1') then
        -- initialize with all 0's
        hclk_shift_register <= (others => '0');
      else

        src_lsb := 0;
        src_msb := HISPI_SHIFT_REGISTER_SIZE-PHY_OUTPUT_WIDTH-1;

        dst_lsb := PHY_OUTPUT_WIDTH;
        dst_msb := HISPI_SHIFT_REGISTER_SIZE-1;

        -- Shift data to the left PHY_OUTPUT_WIDTH bits for each lane.
        hclk_shift_register(hclk_data_lane'range)   <= hclk_data_lane;
        hclk_shift_register(dst_msb downto dst_lsb) <= hclk_shift_register(src_msb downto src_lsb);
      end if;
    end if;
  end process;



  -----------------------------------------------------------------------------
  -- Detect a sequence of 4 consecutives IDLE characters (4x12bits)
  -----------------------------------------------------------------------------
  P_detect_idle_char : process (hclk_shift_register, hclk_idle_char) is
    variable msb                   : integer;
    variable lsb                   : integer;
    variable hclk_idle_quad_vector : std_logic_vector(4*PIXEL_SIZE-1 downto 0);

  begin


    hclk_idle_quad_vector := hclk_idle_char & hclk_idle_char & hclk_idle_char & hclk_idle_char;


    ---------------------------------------------------------------------------
    -- Shift the observation window from 0 to PHY_OUTPUT_WIDTH-1
    ---------------------------------------------------------------------------
    for bit_index in 0 to PHY_OUTPUT_WIDTH-1 loop

      lsb := bit_index;
      msb := lsb + (4*PIXEL_SIZE) - 1;

      -- If detected 4-IDLE character, assert the flag hclk_idle_detected 
      if (hclk_shift_register(msb downto lsb) = hclk_idle_quad_vector) then
        hclk_idle_detected <= '1';
        hclk_lsb_ptr       <= bit_index;
        exit;                           -- exit the bit_index forloop

      else
        hclk_idle_detected <= '0';
        hclk_lsb_ptr       <= 0;
      end if;

    end loop;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_hclk_lsb_ptr_reg
  -- Description : Store the LSB alignment pointer value if the quad idle
  --               sequence detected
  -----------------------------------------------------------------------------
  P_hclk_lsb_ptr_reg : process (hclk) is
  begin
    if (rising_edge(hclk)) then
      if (hclk_reset = '1')then
        hclk_lsb_ptr_reg <= 0;
      else
        if (hclk_idle_detected = '1') then
          hclk_lsb_ptr_reg <= hclk_lsb_ptr;
        end if;
      end if;
    end if;
  end process P_hclk_lsb_ptr_reg;


  -----------------------------------------------------------------------------
  -- Process     : P_hclk_aligned_pixel_mux
  -- Description : Extracted the aligned pixel.
  -----------------------------------------------------------------------------
  P_hclk_aligned_pixel_mux : process (hclk_lsb_ptr_reg, hclk_shift_register) is
  begin
    for j in 0 to (PIXEL_SIZE -1) loop
      hclk_aligned_pixel_mux(j) <= hclk_shift_register(j+hclk_lsb_ptr_reg);
    end loop;
  end process P_hclk_aligned_pixel_mux;


  -----------------------------------------------------------------------------
  -- Process     : P_hclk_phase
  -- Description : HiSPi clock phase. 
  -----------------------------------------------------------------------------
  P_hclk_phase : process (hclk) is
  begin
    if (rising_edge(hclk)) then
      if (hclk_reset = '1')then
        hclk_phase <= '0';
      else
        -- If the idle sequence is detected,
        -- we realign the clock phase with the pixel boundaries
        if (hclk_idle_detected = '1') then
          hclk_phase <= '1';
        else
          hclk_phase <= not hclk_phase;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_hclk_lock_cntr
  -- Description : 
  -----------------------------------------------------------------------------
  P_hclk_lock_cntr : process (hclk) is
  begin
    if (rising_edge(hclk)) then
      if (hclk_reset = '1') then
        hclk_lock_cntr <= (others => '0');
      else
        if (hclk_phase = '0') then
          if (hclk_idle_detected = '1') then
            hclk_lock_cntr <= hclk_lock_cntr_max_value;
          elsif (hclk_bit_locked = '1') then
            hclk_lock_cntr <= hclk_lock_cntr - 1;
          end if;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Flag        : hclk_bit_locked
  -- Description : If the hclk_lock_cntr > 0 we consider the lane is in
  --               lock mode (we detect correctly the idle character).  
  -----------------------------------------------------------------------------
  hclk_bit_locked <= '1' when (hclk_lock_cntr > (hclk_lock_cntr'range => '0')) else
                     '0';


  P_pclk_bit_locked : process (hclk) is
  begin
    if (rising_edge(hclk)) then
      if (hclk_reset = '1') then
        pclk_bit_locked <= '0';
      else
        if (hclk_phase = '0') then
          pclk_bit_locked <= hclk_bit_locked;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_hclk_data
  -- Description : Provide the correctly extracted pixel
  -----------------------------------------------------------------------------
  P_hclk_data : process (hclk) is
  begin
    if (rising_edge(hclk)) then
      if (hclk_idle_detected = '1' or hclk_phase = '0') then
        hclk_data <= hclk_aligned_pixel_mux;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_pclk_data
  -- Description : Provide the correctly extracted pixel on pclk
  -----------------------------------------------------------------------------
  P_pclk_data : process (pclk) is
  begin
    if (rising_edge(pclk)) then
      pclk_data <= hclk_data;
    end if;
  end process;


end architecture rtl;
