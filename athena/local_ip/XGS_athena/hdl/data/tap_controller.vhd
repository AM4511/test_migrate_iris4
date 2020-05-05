-------------------------------------------------------------------------------
-- MODULE        : tap_controller
--
-- DESCRIPTION   : Calculate the tap delay for calibrating the SERDES lanes
--
-- CLOCK DOMAINS : pclk
--                 
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity tap_controller is
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
    pclk_cal_tap_value  : out std_logic_vector(4 downto 0)
    );
end entity tap_controller;


architecture rtl of tap_controller is


  type FSM_TYPE is (S_IDLE, S_RESET_TAP_CNTR, S_RESET_PIX_CNTR, S_MONITOR, S_EVALUATE, S_EXTRACT_WINDOW, S_CALIBRATION_ERROR, S_INCR_TAP, S_LOAD_TAP, S_DONE);

  constant CNTR_WIDTH : integer                         := 6;
  constant MAX_COUNT  : unsigned(CNTR_WIDTH-1 downto 0) := "111110";

  signal state               : FSM_TYPE                        := S_IDLE;
  signal tap_cntr            : unsigned(4 downto 0)            := (others => '0');
  signal valid_pixel_cntr    : unsigned(CNTR_WIDTH-1 downto 0) := (others => '0');
  signal pixel_cntr          : unsigned(CNTR_WIDTH-1 downto 0) := (others => '0');
  signal valid_idle_sequence : std_logic;

  signal window_low    : unsigned(4 downto 0);
  signal window_high   : unsigned(4 downto 0);
  signal window_center : unsigned(5 downto 0);


begin


  -----------------------------------------------------------------------------
  -- Process     : P_state
  -- Description : Main state machine
  -----------------------------------------------------------------------------
  P_state : process (pclk) is
  begin
    if (rising_edge(pclk)) then
      if (pclk_reset = '1')then
        state <= S_IDLE;

      else
        case state is
          -------------------------------------------------------------------
          -- S_IDLE : 
          -------------------------------------------------------------------
          when S_IDLE =>
            if (pclk_cal_en = '1') then
              state <= S_RESET_TAP_CNTR;
            end if;


          -------------------------------------------------------------------
          -- S_RESET_TAP_CNTR : 
          -------------------------------------------------------------------
          when S_RESET_TAP_CNTR =>
            state <= S_RESET_PIX_CNTR;


          -------------------------------------------------------------------
          -- S_RESET_TAP_CNTR : 
          -------------------------------------------------------------------
          when S_RESET_PIX_CNTR =>
            state <= S_MONITOR;


          -------------------------------------------------------------------
          -- S_MONITOR : 
          -------------------------------------------------------------------
          when S_MONITOR =>
            if (pixel_cntr = MAX_COUNT) then
              state <= S_EVALUATE;
            else
              state <= S_MONITOR;
            end if;


          -------------------------------------------------------------------
          -- S_MONITOR : 
          -------------------------------------------------------------------
          when S_EVALUATE =>
            if (tap_cntr = "11111") then
              state <= S_EXTRACT_WINDOW;
            else
              state <= S_INCR_TAP;
            end if;


          -------------------------------------------------------------------
          -- S_INCR_TAP : 
          -------------------------------------------------------------------
          when S_INCR_TAP =>
            state <= S_RESET_PIX_CNTR;


          -------------------------------------------------------------------
          -- S_EXTRACT_WINDOW : 
          -------------------------------------------------------------------
          when S_EXTRACT_WINDOW =>
            if (window_high > window_low) then
              state <= S_LOAD_TAP;
            else
              state <= S_CALIBRATION_ERROR;
            end if;


          -------------------------------------------------------------------
          -- S_LOAD_TAP : 
          -------------------------------------------------------------------
          when S_LOAD_TAP =>
            state <= S_DONE;

          -------------------------------------------------------------------
          -- S_DONE : 
          -------------------------------------------------------------------
          when S_DONE =>
            state <= S_IDLE;


          -------------------------------------------------------------------
          -- 
          -------------------------------------------------------------------
          when others =>
            null;
        end case;
      end if;
    end if;
  end process P_state;


  -----------------------------------------------------------------------------
  -- Process     : P_tap_cntr
  -- Description : 
  -----------------------------------------------------------------------------
  P_tap_cntr : process (pclk) is
  begin
    if (rising_edge(pclk)) then
      if (pclk_reset = '1') then
        tap_cntr <= (others => '0');
      else
        if (state = S_RESET_TAP_CNTR) then
          tap_cntr <= (others => '0');
        elsif (state = S_INCR_TAP) then
          tap_cntr <= tap_cntr+1;
        end if;
      end if;
    end if;
  end process P_tap_cntr;


  -----------------------------------------------------------------------------
  -- Process     : P_pixel_cntr
  -- Description : 
  -----------------------------------------------------------------------------
  P_pixel_cntr : process (pclk) is
  begin
    if (rising_edge(pclk)) then
      if (pclk_reset = '1') then
        pixel_cntr <= (others => '0');
      else
        if (state = S_RESET_PIX_CNTR) then
          pixel_cntr <= (others => '0');
        elsif (state = S_MONITOR) then
          pixel_cntr <= pixel_cntr+1;
        end if;
      end if;
    end if;
  end process P_pixel_cntr;


  -----------------------------------------------------------------------------
  -- Process     : P_valid_pixel_cntr
  -- Description : 
  -----------------------------------------------------------------------------
  P_valid_pixel_cntr : process (pclk) is
  begin
    if (rising_edge(pclk)) then
      if (pclk_reset = '1') then
        valid_pixel_cntr <= (others => '0');
      else
        if (state = S_RESET_PIX_CNTR) then
          valid_pixel_cntr <= (others => '0');
        elsif (state = S_MONITOR) then
          if (pclk_pixel = pclk_idle_character) then
            valid_pixel_cntr <= valid_pixel_cntr+1;
          else
            valid_pixel_cntr <= (others => '0');
          end if;
        end if;
      end if;
    end if;
  end process P_valid_pixel_cntr;


  -----------------------------------------------------------------------------
  -- Process     : P_window_low
  -- Description : 
  -----------------------------------------------------------------------------
  P_window_low : process (pclk) is
  begin
    if (rising_edge(pclk)) then
      if (pclk_reset = '1') then
        window_low <= (others => '1');
      else
        if (state = S_RESET_TAP_CNTR) then
          window_low <= (others => '1');
        elsif (state = S_EVALUATE) then
          ---------------------------------------------------------------------
          -- If reliable pixels (we counted 64 valid consecutives IDLE characters)
          ---------------------------------------------------------------------
          if (valid_idle_sequence = '1') then
            if (tap_cntr < window_low) then
              window_low <= tap_cntr;
            else
              window_low <= window_low;
            end if;
          end if;
        end if;
      end if;
    end if;
  end process P_window_low;


  valid_idle_sequence <= '1' when (valid_pixel_cntr = "111111") else
                         '0';


  -----------------------------------------------------------------------------
  -- Process     : P_window_high
  -- Description : 
  -----------------------------------------------------------------------------
  P_window_high : process (pclk) is
  begin
    if (rising_edge(pclk)) then
      if (pclk_reset = '1') then
        window_high <= (others => '0');
      else
        if (state = S_RESET_TAP_CNTR) then
          window_high <= (others => '0');
        elsif (state = S_EVALUATE) then
          if (valid_idle_sequence = '1') then
            if (tap_cntr > window_high) then
              window_high <= tap_cntr;
            else
              window_high <= window_high;
            end if;
          end if;
        end if;
      end if;
    end if;
  end process P_window_high;



  -----------------------------------------------------------------------------
  -- Process     : P_pclk_cal_busy
  -- Description : 
  -----------------------------------------------------------------------------
  P_pclk_cal_busy : process (pclk) is
  begin
    if (rising_edge(pclk)) then
      if (pclk_reset = '1') then
        pclk_cal_busy <= '0';
      else
        if (state = S_RESET_TAP_CNTR) then
          pclk_cal_busy <= '1';
        elsif (state = S_DONE or state = S_IDLE) then
          pclk_cal_busy <= '0';
        end if;
      end if;
    end if;
  end process P_pclk_cal_busy;


  -----------------------------------------------------------------------------
  -- Process     : P_pclk_cal_load_tap
  -- Description : 
  -----------------------------------------------------------------------------
  P_pclk_cal_load_tap : process (pclk) is
  begin
    if (rising_edge(pclk)) then
      if (pclk_reset = '1') then
        pclk_cal_load_tap <= '0';
      else
        if (state = S_LOAD_TAP) then
          pclk_cal_load_tap <= '1';
        else
          pclk_cal_load_tap <= '0';
        end if;
      end if;
    end if;
  end process P_pclk_cal_load_tap;


  -----------------------------------------------------------------------------
  -- Determine center point of the valid window
  -----------------------------------------------------------------------------
  window_center <= (('0' & window_low) + ('0' & window_high))/2;


  -----------------------------------------------------------------------------
  -- Process     : P_pclk_cal_tap_value
  -- Description : 
  -----------------------------------------------------------------------------
  P_pclk_cal_tap_value : process (pclk) is
  begin
    if (rising_edge(pclk)) then
      if (pclk_reset = '1') then
        pclk_cal_tap_value <= (others => '0');
      else
        if (state = S_LOAD_TAP) then
          pclk_cal_tap_value <= std_logic_vector(window_center(4 downto 0));
        end if;
      end if;
    end if;
  end process P_pclk_cal_tap_value;


  -----------------------------------------------------------------------------
  -- Process     : P_pclk_cal_error
  -- Description : 
  -----------------------------------------------------------------------------
  P_pclk_cal_error : process (pclk) is
  begin
    if (rising_edge(pclk)) then
      if (pclk_reset = '1') then
        pclk_cal_error <= '0';
      else
        if (state = S_RESET_TAP_CNTR) then
          pclk_cal_error <= '0';
        elsif (state = S_CALIBRATION_ERROR) then
          pclk_cal_error <= '1';
        end if;
      end if;
    end if;
  end process P_pclk_cal_error;


end architecture rtl;
