-------------------------------------------------------------------------------
-- MODULE        : tap_controller
--
-- DESCRIPTION   : Calculate the tap delay for calibrating the SERDES lanes
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity tap_controller is
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
end entity tap_controller;


architecture rtl of tap_controller is

  attribute mark_debug : string;
  attribute keep       : string;

  type FSM_TYPE is (S_DISABLED, S_IDLE, S_INIT, S_WAIT_START_MONITOR, S_RESET_PIX_CNTR, S_MONITOR, S_EVALUATE, S_TAP_DONE, S_EXTRACT_WINDOW, S_CALIBRATION_ERROR, S_COMPARE, S_LOAD_BEST_TAP, S_DONE);

  constant CNTR_WIDTH   : integer                         := 6;
  constant MAX_COUNT    : unsigned(CNTR_WIDTH-1 downto 0) := "111110";
  constant WINDOW_WIDTH : integer                         := 6;

  signal state                       : FSM_TYPE                        := S_IDLE;
  signal valid_pixel_cntr            : unsigned(CNTR_WIDTH-1 downto 0) := (others => '0');
  signal pixel_cntr                  : unsigned(CNTR_WIDTH-1 downto 0) := (others => '0');
  signal valid_idle_sequence         : std_logic;
  signal valid_window                : std_logic;
  signal window_low                  : unsigned(WINDOW_WIDTH-1 downto 0);
  signal window_size                 : unsigned(WINDOW_WIDTH-1 downto 0);
  signal best_window_low             : unsigned(WINDOW_WIDTH-1 downto 0);
  signal best_window_size            : unsigned(WINDOW_WIDTH-1 downto 0);
  signal best_window_center          : unsigned(WINDOW_WIDTH-1 downto 0);
  signal pclk_cal_monitor_done_pulse : unsigned(2 downto 0);
  signal tap_histogram               : std_logic_vector(31 downto 0);
  --signal pclk_pixel_debug            : std_logic_vector(PIXEL_SIZE-1 downto 0);
  --signal pclk_induce_error           : std_logic;


  -----------------------------------------------------------------------------
  -- Debug attributes
  -----------------------------------------------------------------------------
  -- attribute mark_debug of pclk_reset             : signal is "true";
  -- attribute mark_debug of pclk_idle_character    : signal is "true";
  -- attribute mark_debug of pclk_lane_enable       : signal is "true";
  -- attribute mark_debug of pclk_pixel             : signal is "true";
  -- attribute mark_debug of pclk_tap_cntr          : signal is "true";
  -- attribute mark_debug of pclk_cal_en            : signal is "true";
  -- attribute mark_debug of pclk_cal_start_monitor : signal is "true";
  -- attribute mark_debug of pclk_cal_monitor_done  : signal is "true";
  -- attribute mark_debug of pclk_cal_busy          : signal is "true";
  -- attribute mark_debug of pclk_cal_error         : signal is "true";
  -- attribute mark_debug of pclk_cal_tap_value     : signal is "true";
  -- attribute mark_debug of pclk_tap_histogram     : signal is "true";

  -- attribute mark_debug of state                       : signal is "true";
  -- attribute mark_debug of valid_pixel_cntr            : signal is "true";
  -- attribute mark_debug of pixel_cntr                  : signal is "true";
  -- attribute mark_debug of valid_idle_sequence         : signal is "true";
  -- attribute mark_debug of valid_window                : signal is "true";
  -- attribute mark_debug of window_low                  : signal is "true";
  -- attribute mark_debug of window_size                 : signal is "true";
  -- attribute mark_debug of best_window_low             : signal is "true";
  -- attribute mark_debug of best_window_size            : signal is "true";
  -- attribute mark_debug of best_window_center          : signal is "true";
  -- attribute mark_debug of pclk_cal_monitor_done_pulse : signal is "true";
  -- attribute mark_debug of tap_histogram               : signal is "true";



begin


  -- pclk_induce_error <= '1' when (pclk_tap_cntr < "01000" and pixel_cntr = "000011") else
  --                      '1' when (pclk_tap_cntr > "01010" and pixel_cntr = "000011") else
  --                      '1' when (pclk_tap_cntr = "01110" and pixel_cntr = "000011") else
  --                      '0';


  -- pclk_pixel_debug <= X"ABC" when (pclk_induce_error = '1') else
  --                     pclk_pixel;


  -----------------------------------------------------------------------------
  -- Process     : P_pclk_cal_monitor_done_pulse
  -- Description : 
  -----------------------------------------------------------------------------
  P_pclk_cal_monitor_done : process (pclk) is
  begin
    if (rising_edge(pclk)) then
      if (pclk_reset = '1') then
        pclk_cal_monitor_done_pulse <= (others => '0');
      else
        if (state = S_TAP_DONE) then
          pclk_cal_monitor_done_pulse <= (others => '1');
        else
          pclk_cal_monitor_done_pulse <= shift_right(pclk_cal_monitor_done_pulse, 1);
        end if;
      end if;
    end if;
  end process;

  pclk_cal_monitor_done <= pclk_cal_monitor_done_pulse(0);


  -----------------------------------------------------------------------------
  -- Process     : P_state
  -- Description : Main state machine
  -----------------------------------------------------------------------------
  P_state : process (pclk) is
  begin
    if (rising_edge(pclk)) then
      if (pclk_reset = '1' or pclk_lane_enable = '0')then
        state <= S_DISABLED;
      else
        case state is
          -------------------------------------------------------------------
          -- S_DISABLED : 
          -------------------------------------------------------------------
          when S_DISABLED =>
            state <= S_IDLE;


          -------------------------------------------------------------------
          -- S_IDLE : 
          -------------------------------------------------------------------
          when S_IDLE =>
            if (pclk_cal_en = '1') then
              state <= S_INIT;
            end if;


          -------------------------------------------------------------------
          -- S_INIT : 
          -------------------------------------------------------------------
          when S_INIT =>
            state <= S_WAIT_START_MONITOR;


          -------------------------------------------------------------------
          -- S_WAIT_START_MONITOR : 
          -------------------------------------------------------------------
          when S_WAIT_START_MONITOR =>
            if (pclk_cal_start_monitor = '1') then
              state <= S_RESET_PIX_CNTR;
            else
              state <= S_WAIT_START_MONITOR;
            end if;

          -------------------------------------------------------------------
          -- S_RESET_PIX_CNTR : 
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
          -- S_EVALUATE : 
          -------------------------------------------------------------------
          when S_EVALUATE =>
            state <= S_COMPARE;


          -------------------------------------------------------------------
          -- S_COMPARE : 
          -------------------------------------------------------------------
          when S_COMPARE =>
            state <= S_TAP_DONE;


          -------------------------------------------------------------------
          -- S_TAP_DONE : 
          -------------------------------------------------------------------
          when S_TAP_DONE =>
            if (pclk_tap_cntr = "11111") then
              state <= S_EXTRACT_WINDOW;
            else
              state <= S_WAIT_START_MONITOR;
            end if;


          -------------------------------------------------------------------
          -- S_EXTRACT_WINDOW : Extract the best valid window
          -------------------------------------------------------------------
          when S_EXTRACT_WINDOW =>
            -- We request a window of at least 3 taps: the center + 1 safe tap
            -- on each side.
            if (best_window_size > "000010") then
              state <= S_LOAD_BEST_TAP;
            else
              state <= S_CALIBRATION_ERROR;
            end if;


          -------------------------------------------------------------------
          -- S_LOAD_BEST_TAP : 
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
        if (state = S_RESET_PIX_CNTR or state = S_IDLE) then
          valid_pixel_cntr <= (others => '0');
        elsif (state = S_MONITOR) then
          if (pclk_pixel = pclk_idle_character) then
            --if (pclk_pixel_debug = pclk_idle_character) then
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
        if (state = S_INIT) then
          window_low <= (others => '0');
        elsif (state = S_EVALUATE and valid_window = '0') then
          ---------------------------------------------------------------------
          -- If reliable pixels (we counted 64 valid consecutives IDLE characters)
          ---------------------------------------------------------------------
          if (valid_idle_sequence = '1') then
            window_low <= unsigned('0' & pclk_tap_cntr);
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
        if (state = S_INIT) then
          window_size <= (others => '0');
        elsif (state = S_EVALUATE and valid_window = '1') then
          if (valid_idle_sequence = '1') then
            window_size <= (('0' & unsigned(pclk_tap_cntr)) - window_low) + 1;
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
        if (state = S_INIT) then
          best_window_low    <= (others => '0');
          best_window_size   <= (others => '0');
          best_window_center <= (others => '0');
        elsif (state = S_COMPARE and valid_window = '1') then
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
      if (pclk_reset = '1' or pclk_lane_enable = '0') then
        pclk_cal_busy <= '0';
      else
        if (state = S_INIT) then
          pclk_cal_busy <= '1';
        elsif (state = S_DONE or state = S_IDLE) then
          pclk_cal_busy <= '0';
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
        if (state = S_INIT) then
          tap_histogram <= X"AAAAAAAA";
        elsif (state = S_EVALUATE) then
          tap_histogram(31)          <= valid_idle_sequence;
          tap_histogram(30 downto 0) <= tap_histogram(31 downto 1);
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_pclk_tap_histogram
  -- Description : 
  -----------------------------------------------------------------------------
  P_pclk_tap_histogram : process (pclk) is
  begin
    if (rising_edge(pclk)) then
      if (pclk_reset = '1' or pclk_lane_enable = '0') then
        pclk_tap_histogram <= X"AAAAAAAA";
      else
        if (state = S_EXTRACT_WINDOW) then
          pclk_tap_histogram <= tap_histogram;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_pclk_cal_tap_value
  -- Description : This is the best tap value evaluated
  -----------------------------------------------------------------------------
  P_pclk_cal_tap_value : process (pclk) is
  begin
    if (rising_edge(pclk)) then
      if (pclk_reset = '1' or pclk_lane_enable = '0') then
        pclk_cal_tap_value <= (others => '0');
      else
        if (state = S_LOAD_BEST_TAP) then
          pclk_cal_tap_value <= std_logic_vector(best_window_center(4 downto 0));
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_pclk_cal_error
  -- Description : Flag used to indicate that a calibration error occured i.e.
  --               that no data valid window has been found after a cycle of
  --               calibration.  
  -----------------------------------------------------------------------------
  P_pclk_cal_error : process (pclk) is
  begin
    if (rising_edge(pclk)) then
      if (pclk_reset = '1'or pclk_lane_enable = '0') then
        pclk_cal_error <= '0';
      else
        if (state = S_INIT) then
          pclk_cal_error <= '0';
        elsif (state = S_CALIBRATION_ERROR) then
          pclk_cal_error <= '1';

          -- synthesis translate_off
          assert (false) report "Calibration error" severity error;
          -- synthesis translate_on

        end if;
      end if;
    end if;
  end process;


end architecture rtl;
