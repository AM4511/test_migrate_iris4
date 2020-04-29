-------------------------------------------------------------------------------
-- MODULE      : bit_split
--
-- DESCRIPTION : Extract the pixels from the serial stream. Find the pixel
--               bit-alignment in the input serial stream. Uses the idle
--               character to determine this alignment. The extraction is based
--               on the detection of 4 consecutives idle_character. This module
--               Also provide the associated pixel clock.
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
    hispi_clk      : in std_logic;
    hispi_reset    : in std_logic;
    -- Register file interface
    idle_character : in std_logic_vector(PIXEL_SIZE-1 downto 0);
    hispi_phy_en   : in std_logic;

    input_data : in  std_logic_vector(PHY_OUTPUT_WIDTH-1 downto 0);
    pix_clk    : out std_logic;
    pix_data   : out std_logic_vector(PIXEL_SIZE-1 downto 0)
    );
end entity bit_split;


architecture rtl of bit_split is

  constant HISPI_WORDS_PER_SYNC_CODE : integer := 4;
  constant HISPI_SHIFT_REGISTER_SIZE : integer := HISPI_WORDS_PER_SYNC_CODE * PIXEL_SIZE + PHY_OUTPUT_WIDTH;

  signal hispi_shift_register    : std_logic_vector (HISPI_SHIFT_REGISTER_SIZE-1 downto 0);
  signal hispi_lsb_ptr           : integer range 0 to PIXEL_SIZE-1;
  signal hispi_lsb_ptr_reg       : integer range 0 to 2*PIXEL_SIZE-1;
  signal hispi_aligned_pixel_mux : std_logic_vector (PIXEL_SIZE- 1 downto 0);
  signal idle_detected           : std_logic;
  signal load_data               : std_logic := '0';
  signal hispi_clk_div2          : std_logic := '0';


begin


  -----------------------------------------------------------------------------
  -- Process     : P_hispi_shift_register
  -- Description : Concatenate input data in a parallel shift register. The
  --               size of the shift register is HISPI_SHIFT_REGISTER_SIZE.
  -----------------------------------------------------------------------------
  P_hispi_shift_register : process (hispi_clk) is
    variable src_msb : integer;
    variable src_lsb : integer;
    variable dst_msb : integer;
    variable dst_lsb : integer;

  begin
    if (rising_edge(hispi_clk)) then
      if (hispi_reset = '1') then
        -- initialize with all 0's
        hispi_shift_register <= (others => '0');
      else

        src_lsb := 0;
        src_msb := HISPI_SHIFT_REGISTER_SIZE-PHY_OUTPUT_WIDTH-1;

        dst_lsb := PHY_OUTPUT_WIDTH;
        dst_msb := HISPI_SHIFT_REGISTER_SIZE-1;

        -- Shift data to the left PHY_OUTPUT_WIDTH bits for each lane.
        hispi_shift_register(input_data'range)       <= input_data;
        hispi_shift_register(dst_msb downto dst_lsb) <= hispi_shift_register(src_msb downto src_lsb);
      end if;
    end if;
  end process;



  -----------------------------------------------------------------------------
  -- Detect a sequence of 4 consecutives IDLE characters (4x12bits)
  -----------------------------------------------------------------------------
  P_detect_idle_char : process (hispi_shift_register, idle_character) is
    variable msb              : integer;
    variable lsb              : integer;
    variable idle_quad_vector : std_logic_vector(4*PIXEL_SIZE-1 downto 0);

  begin


    idle_quad_vector := idle_character & idle_character & idle_character & idle_character;


    ---------------------------------------------------------------------------
    -- Shift the observation window from 0 to PHY_OUTPUT_WIDTH-1
    ---------------------------------------------------------------------------
    for bit_index in 0 to PHY_OUTPUT_WIDTH-1 loop

      lsb := bit_index;
      msb := lsb + (4*PIXEL_SIZE) - 1;

      -- If detected 4-IDLE character, assert the flag idle_detected 
      if (hispi_shift_register(msb downto lsb) = idle_quad_vector) then
        idle_detected <= '1';
        hispi_lsb_ptr <= bit_index;
        exit;                           -- exit the bit_index forloop

      else
        idle_detected <= '0';
        hispi_lsb_ptr <= 0;
      end if;

    end loop;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_hispi_lsb_ptr_reg
  -- Description : Store the LSB alignment pointer value if the quad idle
  --               sequence detected
  -----------------------------------------------------------------------------
  P_hispi_lsb_ptr_reg : process (hispi_clk) is
  begin
    if (rising_edge(hispi_clk)) then
      if (hispi_reset = '1')then
        hispi_lsb_ptr_reg <= 0;
      else
        if (idle_detected = '1') then
          hispi_lsb_ptr_reg <= hispi_lsb_ptr;
        end if;
      end if;
    end if;
  end process P_hispi_lsb_ptr_reg;


  -----------------------------------------------------------------------------
  -- Process     : P_hispi_aligned_pixel_mux
  -- Description : Extracted the aligned pixel.
  -----------------------------------------------------------------------------
  P_hispi_aligned_pixel_mux : process (hispi_lsb_ptr_reg, hispi_shift_register) is
  begin
    for j in 0 to (PIXEL_SIZE -1) loop
      hispi_aligned_pixel_mux(j) <= hispi_shift_register(j+hispi_lsb_ptr_reg);
    end loop;
  end process P_hispi_aligned_pixel_mux;


  -----------------------------------------------------------------------------
  -- Process     : P_hispi_clk_div2
  -- Description : HiSPi clock divider. Divid by 2 click the HiSPi. Since we
  --               concatenate 2 x input_data to form a full pixel, we provide
  --               a divide by 2 clock to simplify the design.
  -----------------------------------------------------------------------------
  P_hispi_clk_div2 : process (hispi_clk) is
  begin
    if (rising_edge(hispi_clk)) then
      if (hispi_reset = '1')then
        hispi_clk_div2 <= '0';
      else
        -- If the idle sequence is detected,
        -- we realign the clock phase with the pixel boundaries
        if (idle_detected = '1') then
          hispi_clk_div2 <= '1';
        else
          hispi_clk_div2 <= not hispi_clk_div2;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_pix_data
  -- Description : Provide the correctly extracted pixel
  -----------------------------------------------------------------------------
  P_pix_data : process (hispi_clk) is
  begin
    if (rising_edge(hispi_clk)) then
      if (idle_detected = '1' or hispi_clk_div2 = '0') then
        pix_data <= hispi_aligned_pixel_mux;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Port remapping
  -----------------------------------------------------------------------------
  pix_clk <= hispi_clk_div2;

  
end architecture rtl;
