library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity tap_controller is
  generic (
    PIXEL_SIZE : integer := 12          -- Pixel size in bits
    );
  port (
    sysclk : in std_logic;
    sysrst : in std_logic;

    cal_en : in  std_logic;
    busy   : out std_logic;
    input_pixel : in  std_logic_vector(PIXEL_SIZE-1 downto 0);

    ---------------------------------------------------------------------------
    -- Register fields
    ---------------------------------------------------------------------------
    idle_character : in  std_logic_vector(PIXEL_SIZE-1 downto 0);
    tap_in         : in  std_logic_vector(4 downto 0);
    tap_out        : out std_logic_vector(4 downto 0)
    );
end entity tap_controller;


architecture rtl of tap_controller is

  type FSM_TYPE is (S_IDLE, S_RESET_TAP_CNTR, S_RESET_PIX_CNTR, S_MONITOR, S_EVALUATE, S_INCR_TAP, S_SET_NEW_TAP, S_DONE);
  constant CNTR_WIDTH : integer                         := 6;
  constant MAX_COUNT  : unsigned(CNTR_WIDTH-1 downto 0) := "111110";

  signal state            : FSM_TYPE                        := S_IDLE;
  signal tap_cntr         : unsigned(4 downto 0)            := (others => '0');
  signal valid_pixel_cntr : unsigned(CNTR_WIDTH-1 downto 0) := (others => '0');
  signal pixel_cntr       : unsigned(CNTR_WIDTH-1 downto 0) := (others => '0');

  signal window_low  : unsigned(tap_cntr'range);
  signal window_high : unsigned(tap_cntr'range);

begin


  -----------------------------------------------------------------------------
  -- Process     : P_state
  -- Description : 
  -----------------------------------------------------------------------------
  P_state : process (sysclk) is
  begin
    if (rising_edge(sysclk)) then
      if (sysrst = '1')then
        state <= S_IDLE;

      else
        case state is
          -------------------------------------------------------------------
          -- S_IDLE : 
          -------------------------------------------------------------------
          when S_IDLE =>
            if (cal_en = '1') then
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
              state <= S_SET_NEW_TAP;
            else
              state <= S_INCR_TAP;
            end if;


          -------------------------------------------------------------------
          -- S_INCR_TAP : 
          -------------------------------------------------------------------
          when S_INCR_TAP =>
            state <= S_RESET_PIX_CNTR;


          -------------------------------------------------------------------
          -- S_DONE : 
          -------------------------------------------------------------------
          when S_SET_NEW_TAP =>
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
  P_tap_cntr : process (sysclk) is
  begin
    if (rising_edge(sysclk)) then
      if (sysrst = '1') then
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
  P_pixel_cntr : process (sysclk) is
  begin
    if (rising_edge(sysclk)) then
      if (sysrst = '1') then
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
  P_valid_pixel_cntr : process (sysclk) is
  begin
    if (rising_edge(sysclk)) then
      if (sysrst = '1') then
        valid_pixel_cntr <= (others => '0');
      else
        if (state = S_RESET_PIX_CNTR) then
          valid_pixel_cntr <= (others => '0');
        elsif (state = S_MONITOR) then
          if (input_pixel = idle_character) then
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
  P_window_low : process (sysclk) is
  begin
    if (rising_edge(sysclk)) then
      if (sysrst = '1') then
        window_low <= (others => '0');
      else
        if (state = S_RESET_TAP_CNTR) then
          window_low <= (others => '1');
        elsif (state = S_EVALUATE) then
          if (valid_pixel_cntr = (others => '1')) then
            if () then
            else
              
            end if;
          end if;
        end if;
      end if;
    end if;
  end process P_window_low;


end architecture rtl;
