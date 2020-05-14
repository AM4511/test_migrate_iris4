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
    pclk_cal_tap_value  : out std_logic_vector(4 downto 0);
    pclk_tap_histogram  : out std_logic_vector(31 downto 0)
    );
end entity tap_controller;


architecture rtl of tap_controller is

  attribute mark_debug : string;
  attribute keep       : string;


  type FSM_TYPE is (S_IDLE, S_RESET_TAP_CNTR, S_RESET_PIX_CNTR, S_MONITOR, S_EVALUATE, S_EXTRACT_WINDOW, S_CALIBRATION_ERROR, S_INCR_TAP, S_LOAD_TAP, S_LOAD_BEST_TAP, S_DONE);

  constant CNTR_WIDTH : integer                         := 6;
  constant MAX_COUNT  : unsigned(CNTR_WIDTH-1 downto 0) := "111110";

  signal state               : FSM_TYPE                        := S_IDLE;
  signal tap_cntr            : unsigned(4 downto 0)            := (others => '0');
  signal valid_pixel_cntr    : unsigned(CNTR_WIDTH-1 downto 0) := (others => '0');
  signal pixel_cntr          : unsigned(CNTR_WIDTH-1 downto 0) := (others => '0');
  signal valid_idle_sequence : std_logic;
  signal valid_window        : std_logic;

  signal window_low         : unsigned(4 downto 0);
  signal window_size        : unsigned(4 downto 0);
  signal best_window_low    : unsigned(4 downto 0);
  signal best_window_size   : unsigned(4 downto 0);
  signal best_window_center : unsigned(4 downto 0);
  signal tap_histogram      : std_logic_vector(31 downto 0);


  -----------------------------------------------------------------------------
  -- Debug attributes
  -----------------------------------------------------------------------------
  attribute mark_debug of state               : signal is "true";
  attribute mark_debug of tap_cntr            : signal is "true";
  attribute mark_debug of valid_pixel_cntr    : signal is "true";
  attribute mark_debug of pixel_cntr          : signal is "true";
  attribute mark_debug of valid_idle_sequence : signal is "true";  
  attribute mark_debug of valid_window        : signal is "true";  
  attribute mark_debug of window_low          : signal is "true";
  attribute mark_debug of window_size         : signal is "true";
  attribute mark_debug of best_window_low     : signal is "true";
  attribute mark_debug of best_window_size    : signal is "true";
  attribute mark_debug of best_window_center  : signal is "true";
  attribute mark_debug of pclk_reset          : signal is "true";
  attribute mark_debug of pclk_cal_tap_value  : signal is "true";
  attribute mark_debug of pclk_cal_load_tap   : signal is "true";
  attribute mark_debug of pclk_cal_error      : signal is "true";
  attribute mark_debug of pclk_cal_busy       : signal is "true";
  attribute mark_debug of pclk_idle_character : signal is "true";
  attribute mark_debug of pclk_pixel          : signal is "true";
  attribute mark_debug of tap_histogram       : signal is "true";

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
            state <= S_LOAD_TAP;


          -------------------------------------------------------------------
          -- S_LOAD_TAP : 
          -------------------------------------------------------------------
          when S_LOAD_TAP =>
            state <= S_RESET_PIX_CNTR;


          -------------------------------------------------------------------
          -- S_EXTRACT_WINDOW : 
          -------------------------------------------------------------------
          when S_EXTRACT_WINDOW =>
            if (best_window_size > 0) then
              state <= S_LOAD_BEST_TAP;
            else
              state <= S_CALIBRATION_ERROR;
            end if;


          -------------------------------------------------------------------
          -- S_LOAD_TAP : 
          -------------------------------------------------------------------
          when S_LOAD_BEST_TAP =>
            state <= S_DONE;

          -------------------------------------------------------------------
          -- S_CALIBRATION_ERROR : 
          -------------------------------------------------------------------
          when S_CALIBRATION_ERROR =>
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
  end process;



  -----------------------------------------------------------------------------
  -- Process     : P_valid_window
  -- Description : 
  -----------------------------------------------------------------------------
  P_valid_window : process (pclk) is
  begin
    if (rising_edge(pclk)) then
      if (pclk_reset = '1') then
        valid_window <= '0';
      else
        if (state = S_IDLE) then
          valid_window <= '0';
        elsif (state = S_EVALUATE) then
          valid_window <= valid_idle_sequence;
        end if;
      end if;
    end if;
  end process;

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
  end process;


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
  end process;


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
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_window_low
  -- Description : 
  -----------------------------------------------------------------------------
  P_window_low : process (pclk) is
  begin
    if (rising_edge(pclk)) then
      if (pclk_reset = '1') then
        window_low <= (others => '0');
      else
        if (state = S_RESET_TAP_CNTR) then
          window_low <= (others => '0');
        elsif (state = S_EVALUATE and valid_window = '0') then
          ---------------------------------------------------------------------
          -- If reliable pixels (we counted 64 valid consecutives IDLE characters)
          ---------------------------------------------------------------------
          if (valid_idle_sequence = '1') then
            window_low <= tap_cntr;
          end if;
        end if;
      end if;
    end if;
  end process;


  valid_idle_sequence <= '1' when (valid_pixel_cntr = "111111") else
                         '0';


  -----------------------------------------------------------------------------
  -- Process     : P_window_size
  -- Description : 
  -----------------------------------------------------------------------------
  P_window_size : process (pclk) is
  begin
    if (rising_edge(pclk)) then
      if (pclk_reset = '1') then
        window_size <= (others => '0');
      else
        if (state = S_RESET_TAP_CNTR) then
          window_size <= (others => '0');
        elsif (state = S_EVALUATE and valid_window = '1') then
          if (valid_idle_sequence = '1') then
            window_size <= (tap_cntr - window_low) + 1;
          end if;
        end if;
      end if;
    end if;
  end process;



  -----------------------------------------------------------------------------
  -- Process     : P_best_window
  -- Description : 
  -----------------------------------------------------------------------------
  P_best_window : process (pclk) is
  begin
    if (rising_edge(pclk)) then
      if (pclk_reset = '1') then
        best_window_low    <= (others => '0');
        best_window_size   <= (others => '0');
        best_window_center <= (others => '0');
      else
        if (state = S_RESET_TAP_CNTR) then
          best_window_low    <= (others => '0');
          best_window_size   <= (others => '0');
          best_window_center <= (others => '0');
        elsif (state = S_INCR_TAP and valid_window = '0') then
          if (window_size > best_window_size) then
            best_window_low    <= window_low;
            best_window_size   <= window_size;
            best_window_center <= window_low + (window_size/2);
          end if;
        end if;
      end if;
    end if;
  end process;


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
  end process;


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
        if (state = S_LOAD_TAP or state = S_LOAD_BEST_TAP) then
          pclk_cal_load_tap <= '1';
        else
          pclk_cal_load_tap <= '0';
        end if;
      end if;
    end if;
  end process;


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
        if (state = S_LOAD_BEST_TAP) then
          pclk_cal_tap_value <= std_logic_vector(best_window_center);
        elsif (state = S_EVALUATE) then
          pclk_cal_tap_value <= std_logic_vector(tap_cntr);
        end if;
      end if;
    end if;
  end process;


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
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_tap_histogram
  -- Description : Create an histogram of all valid tap value.
  -----------------------------------------------------------------------------
  P_tap_histogram : process (pclk) is
  begin
    if (rising_edge(pclk)) then
      if (pclk_reset = '1') then
        tap_histogram <= (others => '0');
      else
        if (state = S_RESET_TAP_CNTR) then
          tap_histogram <= (others => '0');
        elsif (state = S_EVALUATE) then
          tap_histogram(31)          <= valid_idle_sequence;
          tap_histogram(30 downto 0) <= tap_histogram(31 downto 1);
        end if;
      end if;
    end if;
  end process;

  pclk_tap_histogram <= tap_histogram;

end architecture rtl;
