library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity hispi_serdes is
  generic (
    PHY_SERIAL_WIDTH   : integer := 1;
    PHY_PARALLEL_WIDTH : integer := 6
    );
  port (
    async_pll_reset : in  std_logic;
    delay_reset     : in  std_logic;
    delay_data_ce   : in  std_logic_vector(PHY_SERIAL_WIDTH-1 downto 0);
    delay_data_inc  : in  std_logic_vector(PHY_SERIAL_WIDTH-1 downto 0);
    delay_tap_in    : in  std_logic_vector((5*PHY_SERIAL_WIDTH)-1 downto 0);
    delay_tap_out   : out std_logic_vector((5*PHY_SERIAL_WIDTH)-1 downto 0);
    rx_in_clock_p   : in  std_logic;
    rx_in_clock_n   : in  std_logic;
    rx_in_p         : in  std_logic_vector (PHY_SERIAL_WIDTH-1 downto 0);
    rx_in_n         : in  std_logic_vector (PHY_SERIAL_WIDTH-1 downto 0);
    rx_out_clock    : out std_logic;
    rx_out          : out std_logic_vector (PHY_PARALLEL_WIDTH-1 downto 0)
    );
end entity;


architecture xilinx of hispi_serdes is

  component hispi_phy_xilinx
    generic
      (                                 -- width of the data for the system
        SYS_W : integer := 3;
        -- width of the data for the device
        DEV_W : integer := 18);
    port
      (
        -- From the system into the device
        data_in_from_pins_p : in  std_logic_vector(SYS_W-1 downto 0);
        data_in_from_pins_n : in  std_logic_vector(SYS_W-1 downto 0);
        data_in_to_device   : out std_logic_vector(DEV_W-1 downto 0);
        in_delay_reset      : in  std_logic;
        in_delay_data_ce    : in  std_logic_vector(SYS_W-1 downto 0);
        in_delay_data_inc   : in  std_logic_vector(SYS_W-1 downto 0);
        in_delay_tap_in     : in  std_logic_vector((5*SYS_W)-1 downto 0);
        in_delay_tap_out    : out std_logic_vector((5*SYS_W)-1 downto 0);

        bitslip     : in  std_logic_vector(SYS_W-1 downto 0);  -- Bitslip module is enabled in NETWORKING mode
                                      -- User should tie it to '0' if not needed
        -- Clock and reset signals
        clk_in_p    : in  std_logic;    -- Differential fast clock from IOB
        clk_in_n    : in  std_logic;
        clk_div_out : out std_logic;    -- Slow clock output
        clk_reset   : in  std_logic;    -- Reset signal for Clock circuit
        io_reset    : in  std_logic     -- Reset signal for IO circuit
        );
  end component;

  
--  component hispi_phy_xilinx_4L
--  generic
--   (-- width of the data for the system
--    SYS_W       : integer := 2;
--    -- width of the data for the device
--    DEV_W       : integer := 12);
--  port
--   (
--    -- From the system into the device
--    data_in_from_pins_p     : in    std_logic_vector(SYS_W-1 downto 0);
--    data_in_from_pins_n     : in    std_logic_vector(SYS_W-1 downto 0);
--    data_in_to_device       : out   std_logic_vector(DEV_W-1 downto 0);
--  
--  -- Input, Output delay control signals
--    in_delay_reset          : in    std_logic;                    -- Active high synchronous reset for input delay
--    in_delay_data_ce        : in    std_logic_vector(SYS_W -1 downto 0);                    -- Enable signal for delay 
--    in_delay_data_inc       : in    std_logic_vector(SYS_W -1 downto 0);                    -- Delay increment (high), decrement (low) signal
--    in_delay_tap_in         : in    std_logic_vector(5*SYS_W -1 downto 0); -- Dynamically loadable delay tap value for input delay
--    in_delay_tap_out        : out   std_logic_vector(5*SYS_W -1 downto 0); -- Delay tap value for monitoring input delay
--    bitslip                 : in    std_logic_vector(SYS_W-1 downto 0);                    -- Bitslip module is enabled in NETWORKING mode
--                                                                  -- User should tie it to '0' if not needed
--   
--  -- Clock and reset signals
--    clk_in_p                : in    std_logic;                    -- Differential fast clock from IOB
--    clk_in_n                : in    std_logic;
--    clk_div_out             : out   std_logic;                    -- Slow clock output
--    clk_reset               : in    std_logic;                    -- Reset signal for Clock circuit
--    io_reset                : in    std_logic);                   -- Reset signal for IO circuit
--  end component;
  

  constant RESET_LENGTH : integer := 8;
  signal bitslip        : std_logic_vector(PHY_SERIAL_WIDTH-1 downto 0);
  signal io_reset_Meta  : std_logic_vector(RESET_LENGTH-1 downto 0);
  signal io_reset       : std_logic;
  signal rx_div_clock   : std_logic;

begin

  -- Bit split not required. Alignment is done in lane decoder module.
  bitslip <= (bitslip'range => '0');

  -----------------------------------------------------------------------------
  -- WARNING CLOCK DOMAIN CROSSING!!!
  -- Reset re-synchronisation in the  clock domain
  -----------------------------------------------------------------------------
  P_io_reset : process (async_pll_reset, rx_div_clock) is
  begin
    if (async_pll_reset = '1') then
      io_reset_Meta <= (others => '1');
      io_reset      <= '1';

    elsif (rising_edge(rx_div_clock)) then
      io_reset_Meta(0)                           <= '0';
      io_reset_Meta(io_reset_Meta'left downto 1) <= io_reset_Meta(io_reset_Meta'left-1 downto 0);
      io_reset                                   <= io_reset_Meta(io_reset_Meta'left);
    end if;
  end process;


  
--  Generate2Lanes : if PHY_SERIAL_WIDTH = 2 generate
--    xhispi_phy_xilinx : hispi_phy_xilinx_4L
--    generic map (
--      SYS_W => PHY_SERIAL_WIDTH,
--      DEV_W => PHY_PARALLEL_WIDTH
--      )
--    port map (
--      data_in_from_pins_p => rx_in_p,
--      data_in_from_pins_n => rx_in_n,
--      data_in_to_device   => rx_out,
--      in_delay_reset      => delay_reset,
--      in_delay_data_ce    => delay_data_ce,
--      in_delay_data_inc   => delay_data_inc,
--      in_delay_tap_in     => delay_tap_in,
--      in_delay_tap_out    => delay_tap_out,
--      bitslip             => bitslip,
--      clk_in_p            => rx_in_clock_p,
--      clk_in_n            => rx_in_clock_n,
--      clk_div_out         => rx_div_clock,
--      clk_reset           => async_pll_reset,
--      io_reset            => io_reset
--      );
--  end generate Generate2Lanes;  
  
  
--  Generate3Lanes : if PHY_SERIAL_WIDTH = 3 generate
    xhispi_phy_xilinx : hispi_phy_xilinx
    generic map (
      SYS_W => PHY_SERIAL_WIDTH,
      DEV_W => PHY_PARALLEL_WIDTH
      )
    port map (
      data_in_from_pins_p => rx_in_p,
      data_in_from_pins_n => rx_in_n,
      data_in_to_device   => rx_out,
      in_delay_reset      => delay_reset,
      in_delay_data_ce    => delay_data_ce,
      in_delay_data_inc   => delay_data_inc,
      in_delay_tap_in     => delay_tap_in,
      in_delay_tap_out    => delay_tap_out,
      bitslip             => bitslip,
      clk_in_p            => rx_in_clock_p,
      clk_in_n            => rx_in_clock_n,
      clk_div_out         => rx_div_clock,
      clk_reset           => async_pll_reset,
      io_reset            => io_reset
      );
--  end generate Generate3Lanes;    


  rx_out_clock <= rx_div_clock;

end architecture xilinx;
