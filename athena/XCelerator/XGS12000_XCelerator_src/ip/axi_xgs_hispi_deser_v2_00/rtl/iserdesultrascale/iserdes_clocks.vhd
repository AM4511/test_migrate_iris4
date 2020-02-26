-- *********************************************************************
-- Copyright 2012, ON Semiconductor Corporation.
--
-- This software is owned by ON Semiconductor Corporation (ON)
-- and is protected by United States copyright laws and international
-- treaty provisions.  Therefore, you must treat this software like any
-- other copyrighted material (e.g., book, or musical recording), with
-- the exception that one copy may be made for personal use or
-- evaluation.  Reproduction, modification, translation, compilation, or
-- representation of this software in any other form (e.g., paper,
-- magnetic, optical, silicon, etc.) is prohibited without the express
-- written permission of ON.
--
-- Disclaimer: ON makes no warranty of any kind, express or
-- implied, with regard to this material, including, but not limited to,
-- the implied warranties of merchantability and fitness for a particular
-- purpose. ON reserves the right to make changes without further
-- notice to the materials described herein. ON does not assume any
-- liability arising out of the application or use of any product or
-- circuit described herein. ON's products described herein are not
-- authorized for use as components in life-support devices.
--
-- This software is protected by and subject to worldwide patent
-- coverage, including U.S. and foreign patents. Use may be limited by
-- and subject to the ON Software License Agreement.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

library unisim;
use unisim.vcomponents.all;

entity iserdes_clocks is
  generic (
        SIMULATION          : integer := 0;
        MAX_DATAWIDTH       : integer := 18;
        SERDES_DATAWIDTH    : integer := 6;
        DATA_RATE           : string  := "DDR";
        CLKSPEED            : integer := 62;
        SIM_DEVICE          : string  := "VIRTEX5";
        DIFF_TERM           : boolean := TRUE;
        USE_DIFF_HS_CLK_IN  : boolean := FALSE;
        USE_DIFF_LS_CLK_IN  : boolean := FALSE;
        USE_HS_REGIONAL_CLK : boolean := FALSE;
        USE_LS_CLK          : boolean := FALSE;
        CLOCK_COUNT         : integer := 2;
        USE_ONE_CLOCK       : boolean := TRUE;
        SERDES_COUNT        : integer := 2;
        IDELAY_COUNT        : integer := 1;
        CHANNEL_COUNT       : integer := 2;
        C_CALWIDTH          : integer := 5;
        LOW_PWR             : boolean := FALSE;
        STABLE_COUNT        : integer := 128;
        SAMPLE_COUNT        : integer := 128;
        TAP_COUNT_MAX       : integer := 32;
        TAP_COUNT_BITS      : integer := 8;
        REFCLK_F            : real    := 200.0;
        USE_HSCLK_BUFIO     : boolean := TRUE
  );
  port (
        DATAWIDTH           : in    integer;
        CLOCK               : in    std_logic;  --appclock
        RESET               : in    std_logic;  --active high reset

        HS_IN_CLK           : in    std_logic_vector(CLOCK_COUNT-1 downto 0);
        HS_IN_CLKb          : in    std_logic_vector(CLOCK_COUNT-1 downto 0);

        LS_IN_CLK           : in    std_logic_vector(CLOCK_COUNT-1 downto 0);
        LS_IN_CLKb          : in    std_logic_vector(CLOCK_COUNT-1 downto 0);

        HS_CLK_MON          : out   std_logic_vector(CLOCK_COUNT-1 downto 0);

        -- to iserdes
        CLK                 : out   std_logic_vector(CLOCK_COUNT-1 downto 0);
        CLKb                : out   std_logic_vector(CLOCK_COUNT-1 downto 0);
        CLKDIV              : out   std_logic_vector(CLOCK_COUNT-1 downto 0);
        CLKDIV_RESET        : out   std_logic_vector(CLOCK_COUNT-1 downto 0);

        --alignment of lowspeed clk
        START_ALIGN         : in    std_logic;
        START_ALIGN_SYNC    : in    std_logic;
        BUSY_ALIGN          : out   std_logic;

        --align controls
        IODELAY_CAL         : in    std_logic_vector((2*CHANNEL_COUNT*SERDES_COUNT*C_CALWIDTH)-1 downto 0);
        INHIBIT_BITALIGN    : in    std_logic;
        ALIGNMODE           : in    std_logic_vector(4 downto 0);   --selects how alignment is done (using 'standard' alignment, 2 serdes alignment, manual alignment, enable window_monitor)
        AUTOALIGNCHANNEL    : in    std_logic_vector(CHANNEL_COUNT-1 downto 0);   --selects which compare channels are used (high, low, both)
        MANUAL_TAP          : in    std_logic_vector(TAP_COUNT_BITS-1 downto 0);   --selects tap in manual mode
        ENABLE_TRAINING     : in    std_logic;
        DWCLK_SYNC          : out   std_logic_vector(10 downto 0);
        VTC_EN              : in    std_logic;

        --clk status
        CLK_STATUS          : out   std_logic_vector((CLOCK_COUNT*16)-1 downto 0);
        EDGE_DETECT         : out   std_logic_vector(CLOCK_COUNT-1 downto 0);
        STABLE_DETECT       : out   std_logic_vector(CLOCK_COUNT-1 downto 0);
        FIRST_EDGE_FOUND    : out   std_logic_vector(CLOCK_COUNT-1 downto 0);
        SECOND_EDGE_FOUND   : out   std_logic_vector(CLOCK_COUNT-1 downto 0);
        NROF_RETRIES        : out   std_logic_vector((CLOCK_COUNT*16)-1 downto 0);
        TAP_SETTING         : out   std_logic_vector((CLOCK_COUNT*TAP_COUNT_BITS)-1 downto 0);
        WINDOW_WIDTH        : out   std_logic_vector((CLOCK_COUNT*TAP_COUNT_BITS)-1 downto 0);
        TAP_DRIFT           : out   std_logic_vector((CLOCK_COUNT*TAP_COUNT_BITS)-1 downto 0);
        WORD_ALIGN          : out   std_logic_vector(CLOCK_COUNT-1 downto 0);
        SLIP_COUNT          : out   std_logic_vector((CLOCK_COUNT*8)-1 downto 0);

        ERROR               : out   std_logic
       );

attribute keep : string;
attribute keep of CLKDIV : signal is "TRUE";

end iserdes_clocks;

architecture rtl of iserdes_clocks is

component iserdes_hs_clock
  generic (
        SIMULATION          : integer := 0;
        MAX_DATAWIDTH       : integer := 18;
        SERDES_DATAWIDTH    : integer := 6;
        DATA_RATE           : string  := "DDR";
        CLKSPEED            : integer := 62;
        SIM_DEVICE          : string  := "VIRTEX5";
        DIFF_TERM           : boolean := TRUE;
        USE_DIFF_HS_CLK_IN  : boolean := FALSE;
        USE_HS_REGIONAL_CLK : boolean := FALSE;
        C_CALWIDTH          : integer := 5;
        USE_CALIBRATION     : boolean := FALSE;
        REFCLK_F            : real    := 200.0;
        USE_HSCLK_BUFIO     : boolean := TRUE;
        USE_SYNC_LOGIC      : boolean := TRUE
  );
  port (
        CLOCK               : in    std_logic;
        RESET               : in    std_logic;

        HS_IN_CLK           : in    std_logic;
        HS_IN_CLKb          : in    std_logic;

        HS_CLK_MON          : out   std_logic;

        --input calibration
        IODELAY_CAL         : in    std_logic_vector((C_CALWIDTH)-1 downto 0);

        --divider synchro logic
        START_ALIGN         : in    std_logic;

        BUFR_CLR_OUT        : out   std_logic := '0';
        BUFR_CE_OUT         : out   std_logic := '0';

        BUFR_CLR_IN         : in    std_logic;
        BUFR_CE_IN          : in    std_logic;

        -- to iserdes
        CLK                 : out   std_logic;
        CLKb                : out   std_logic;
        CLKDIV              : out   std_logic;
        CLKDIV_RESET        : out   std_logic;
        CLKSYNC             : out   std_logic;

        --lowspeed clk status
        CLK_STATUS          : out   std_logic_vector(15 downto 0)
       );
end component;

component iserdes_ls_clock
    generic (
        MAX_DATAWIDTH       : integer := 18;
        SERDES_DATAWIDTH    : integer := 6;
        SERDES_COUNT        : integer := 1;
        IDELAY_COUNT        : integer := 1;
        CHANNEL_COUNT       : integer := 2;
        DATA_RATE           : string  := "DDR";
        DIFF_TERM           : boolean := TRUE;
        C_CALWIDTH          : integer := 5;
        C_FAMILY            : string  := "VIRTEX5";
        LOW_PWR             : boolean := FALSE;
        CLOCK_COUNT         : integer := 1;
        STABLE_COUNT        : integer := 128;
        SAMPLE_COUNT        : integer := 128;
        TAP_COUNT_MAX       : integer := 32;
        TAP_COUNT_BITS      : integer := 8;
        REFCLK_F            : real    := 200.0
  );
  port (
        CLOCK               : in    std_logic;
        RESET               : in    std_logic;

        LS_IN_CLK           : in    std_logic_vector(CLOCK_COUNT-1 downto 0);
        LS_IN_CLKb          : in    std_logic_vector(CLOCK_COUNT-1 downto 0);

        -- to data channels
        CLK                 : in    std_logic_vector(CLOCK_COUNT-1 downto 0);
        CLKb                : in    std_logic_vector(CLOCK_COUNT-1 downto 0);
        CLKDIV              : in    std_logic_vector(CLOCK_COUNT-1 downto 0);
        CLKDIV_RESET        : in    std_logic_vector(CLOCK_COUNT-1 downto 0);

        START_ALIGN         : in    std_logic;
        BUSY_ALIGN          : out   std_logic;

        DATAWIDTH           : in    integer;
        IODELAY_CAL         : in    std_logic_vector((CHANNEL_COUNT*SERDES_COUNT*C_CALWIDTH)-1 downto 0);
        INHIBIT_BITALIGN    : in    std_logic;
        ALIGNMODE           : in    std_logic_vector(4 downto 0);   --selects how alignment is done (using 'standard' alignment, 2 serdes alignment, manual alignment, enable window_monitor)
        AUTOALIGNCHANNEL    : in    std_logic_vector(CHANNEL_COUNT-1 downto 0);   --selects which compare channels are used (high, low, both)
        MANUAL_TAP          : in    std_logic_vector(TAP_COUNT_BITS-1 downto 0);   --selects tap in manual mode
        ENABLE_TRAINING     : in    std_logic;
        DWCLK_SYNC          : out   std_logic_vector(10 downto 0);
        VTC_EN             : in    std_logic;

        --lowspeed clk status
        EDGE_DETECT         : out   std_logic;
        STABLE_DETECT       : out   std_logic;
        FIRST_EDGE_FOUND    : out   std_logic;
        SECOND_EDGE_FOUND   : out   std_logic;
        NROF_RETRIES        : out   std_logic_vector(15 downto 0);
        TAP_SETTING         : out   std_logic_vector(TAP_COUNT_BITS-1 downto 0);
        WINDOW_WIDTH        : out   std_logic_vector(TAP_COUNT_BITS-1 downto 0);
        TAP_DRIFT           : out   std_logic_vector(TAP_COUNT_BITS-1 downto 0);
        WORD_ALIGN          : out   std_logic;
        SLIP_COUNT          : out   std_logic_vector(7 downto 0);

        ERROR               : out   std_logic
        );
end component;

function calcsynclogic(CLOCK_COUNT    : integer
                                )
                                return boolean is
variable output : boolean := True;

begin
    if (CLOCK_COUNT > 1) then
        output := True;
    else
        output := False;
    end if;

    return output;
end function;

constant zero               : std_logic := '0';
constant one                : std_logic := '1';

signal CLK_i                : std_logic_vector(CLOCK_COUNT-1 downto 0);
signal CLKb_i               : std_logic_vector(CLOCK_COUNT-1 downto 0);
signal CLKDIV_i             : std_logic_vector(CLOCK_COUNT-1 downto 0);
signal CLKDIV_RESET_i       : std_logic_vector(CLOCK_COUNT-1 downto 0);
signal CLKSYNC              : std_logic_vector(CLOCK_COUNT-1 downto 0);

signal clk_s                : std_logic_vector(CLOCK_COUNT-1 downto 0);
signal clkb_s               : std_logic_vector(CLOCK_COUNT-1 downto 0);
signal clkdiv_s             : std_logic_vector(CLOCK_COUNT-1 downto 0);
signal clkdiv_reset_s       : std_logic_vector(CLOCK_COUNT-1 downto 0);

signal edge_detect_s        : std_logic;
signal stable_detect_s      : std_logic;
signal first_edge_found_s   : std_logic;
signal second_edge_found_s  : std_logic;
signal nrof_retries_s       : std_logic_vector(15 downto 0);
signal tap_setting_s        : std_logic_vector(TAP_COUNT_BITS-1 downto 0);
signal window_width_s       : std_logic_vector(TAP_COUNT_BITS-1 downto 0);
signal tap_drift_s          : std_logic_vector(TAP_COUNT_BITS-1 downto 0);
signal word_align_s         : std_logic;
signal slip_count_s         : std_logic_vector(7 downto 0);

signal BUFR_CLR             : std_logic_vector(CLOCK_COUNT-1 downto 0);
signal BUFR_CE              : std_logic_vector(CLOCK_COUNT-1 downto 0);
signal BUFR_CLR_r           : std_logic_vector(CLOCK_COUNT-1 downto 0);
signal BUFR_CE_r            : std_logic_vector(CLOCK_COUNT-1 downto 0);

constant USE_SYNC_LOGIC     : boolean := calcsynclogic(CLOCK_COUNT);

begin

gen_hs_clocks: for i in 0 to CLOCK_COUNT-1 generate
    the_iserdes_hs_clock: iserdes_hs_clock
      generic map (
            SIMULATION              => SIMULATION           ,
            MAX_DATAWIDTH           => MAX_DATAWIDTH        ,
            SERDES_DATAWIDTH        => SERDES_DATAWIDTH     ,
            DATA_RATE               => DATA_RATE            ,
            CLKSPEED                => CLKSPEED             ,
            SIM_DEVICE              => SIM_DEVICE           ,
            DIFF_TERM               => DIFF_TERM            ,
            USE_DIFF_HS_CLK_IN      => USE_DIFF_HS_CLK_IN   ,
            USE_HS_REGIONAL_CLK     => USE_HS_REGIONAL_CLK  ,
            C_CALWIDTH              => C_CALWIDTH           ,
            USE_CALIBRATION         => FALSE                , --FIXME
            REFCLK_F                => REFCLK_F             ,
            USE_HSCLK_BUFIO         => USE_HSCLK_BUFIO      ,
            USE_SYNC_LOGIC          => USE_SYNC_LOGIC
      )
      port map (
            CLOCK                   => CLOCK                ,
            RESET                   => RESET                ,

            HS_IN_CLK               => HS_IN_CLK(i)         ,
            HS_IN_CLKb              => HS_IN_CLKb(i)        ,

            HS_CLK_MON              => HS_CLK_MON(i)        ,

            --input calibration
            IODELAY_CAL             => IODELAY_CAL((i*C_CALWIDTH*SERDES_COUNT)+C_CALWIDTH-1 downto (i*C_CALWIDTH*SERDES_COUNT))    ,

            --divider synchro logic
            START_ALIGN             => START_ALIGN          ,

            BUFR_CLR_OUT            => BUFR_CLR(i)          ,
            BUFR_CE_OUT             => BUFR_CE(i)           ,

            BUFR_CLR_IN             => BUFR_CLR_r(i)        ,
            BUFR_CE_IN              => BUFR_CE_r(i)         ,

            -- to iserdes
            CLK                     => CLK_i(i)             ,
            CLKb                    => CLKb_i(i)            ,
            CLKDIV                  => CLKDIV_i(i)          ,
            CLKDIV_RESET            => CLKDIV_RESET_i(i)    ,
            CLKSYNC                 => CLKSYNC(i)           ,

            --lowspeed clk status
            CLK_STATUS              => CLK_STATUS((16*i)+15 downto (16*i))
           );

    --seperate FFs to be easily able to LOC constraint them
    FDRE_BUFR_CE : FDRE
        generic map (
            INIT => '0') -- Initial value of register ('0' or '1')
        port map (
            Q => BUFR_CE_r(i), -- Data output
            C => CLKSYNC(0), -- Clock input
            CE => one, -- Clock enable input
            R => zero, -- Synchronous reset input
            D => BUFR_CE(0) -- Data input
        );

    FDRE_BUFR_CLR : FDRE
        generic map (
            INIT => '1') -- Initial value of register ('0' or '1')
        port map (
            Q => BUFR_CLR_r(i), -- Data output
            C => CLKSYNC(0), -- Clock input
            CE => one, -- Clock enable input
            R => zero, -- Synchronous reset input
            D => BUFR_CLR(0) -- Data input
        );
end generate;

CLK                 <= clk_s;
CLKb                <= clkb_s;
CLKDIV              <= clkdiv_s;
CLKDIV_RESET        <= clkdiv_reset_s;

gen_one_clock: if (USE_ONE_CLOCK = TRUE) generate
  clk_s             <= CLK_i;
  clkb_s            <= CLKb_i;
  clkdiv_s          <= (others => CLKDIV_i(0));
  clkdiv_reset_s    <= (others => CLKDIV_RESET_i(0));
end generate;

gen_multi_clocks: if (USE_ONE_CLOCK = FALSE) generate
  clk_s             <= CLK_i;
  clkb_s            <= CLKb_i;
  clkdiv_s          <= CLKDIV_i;
  clkdiv_reset_s    <= CLKDIV_RESET_i;
end generate;


gen_ls_clock: if (USE_LS_CLK = TRUE) generate

      the_iserdes_ls_clock: iserdes_ls_clock
        generic map (
              MAX_DATAWIDTH         => MAX_DATAWIDTH                        ,
              SERDES_DATAWIDTH      => SERDES_DATAWIDTH                     ,
              DATA_RATE             => DATA_RATE                            ,
              C_FAMILY              => SIM_DEVICE                           ,
              DIFF_TERM             => DIFF_TERM                            ,
              SERDES_COUNT          => SERDES_COUNT                         ,
              IDELAY_COUNT          => IDELAY_COUNT                         ,
              CHANNEL_COUNT         => CHANNEL_COUNT                        ,
              C_CALWIDTH            => C_CALWIDTH                           ,
              LOW_PWR               => LOW_PWR                              ,
              CLOCK_COUNT           => CLOCK_COUNT                          ,
              STABLE_COUNT          => STABLE_COUNT                         ,
              SAMPLE_COUNT          => SAMPLE_COUNT                         ,
              TAP_COUNT_MAX         => TAP_COUNT_MAX                        ,
              TAP_COUNT_BITS        => TAP_COUNT_BITS                       ,
              REFCLK_F              => REFCLK_F
        )
        port map (
              CLOCK               => CLOCK                                  ,
              RESET               => RESET                                  ,

              LS_IN_CLK           => LS_IN_CLK                              ,
              LS_IN_CLKb          => LS_IN_CLKb                             ,

              -- to data channels
              CLK                 => clk_s                                  ,
              CLKb                => clkb_s                                 ,
              CLKDIV              => clkdiv_s                               ,
              CLKDIV_RESET        => clkdiv_reset_s                         ,

              START_ALIGN         => START_ALIGN_SYNC                       ,
              BUSY_ALIGN          => BUSY_ALIGN                             ,

              DATAWIDTH           => DATAWIDTH                              ,
              IODELAY_CAL         => IODELAY_CAL((1*CHANNEL_COUNT*SERDES_COUNT*C_CALWIDTH)+(CHANNEL_COUNT*SERDES_COUNT*C_CALWIDTH)-1 downto (1*CHANNEL_COUNT*SERDES_COUNT*C_CALWIDTH))    ,
              INHIBIT_BITALIGN    => INHIBIT_BITALIGN                       ,
              ALIGNMODE           => ALIGNMODE                              ,
              AUTOALIGNCHANNEL    => AUTOALIGNCHANNEL                       ,
              MANUAL_TAP          => MANUAL_TAP                             ,
              ENABLE_TRAINING     => ENABLE_TRAINING                        ,
              DWCLK_SYNC          => DWCLK_SYNC                             ,
              VTC_EN              => VTC_EN                                 ,

              --lowspeed clk status
              EDGE_DETECT         => edge_detect_s                          ,
              STABLE_DETECT       => stable_detect_s                        ,
              FIRST_EDGE_FOUND    => first_edge_found_s                     ,
              SECOND_EDGE_FOUND   => second_edge_found_s                    ,
              NROF_RETRIES        => nrof_retries_s                         ,
              TAP_SETTING         => tap_setting_s                          ,
              WINDOW_WIDTH        => window_width_s                         ,
              TAP_DRIFT           => tap_drift_s                            ,
              WORD_ALIGN          => word_align_s                           ,
              SLIP_COUNT          => slip_count_s                           ,

              ERROR               => ERROR
             );

             --FIXME: this status bit is assigned twice
             gen_status: for i in 0 to CLOCK_COUNT-1 generate
                EDGE_DETECT(i)                          <= edge_detect_s;
                STABLE_DETECT(i)                        <= stable_detect_s;
                FIRST_EDGE_FOUND(i)                     <= first_edge_found_s;
                SECOND_EDGE_FOUND(i)                    <= second_edge_found_s;
                NROF_RETRIES((i*16)+15 downto (i*16))   <= nrof_retries_s;
                TAP_SETTING((i*TAP_COUNT_BITS)+TAP_COUNT_BITS-1 downto (i*TAP_COUNT_BITS))       <= tap_setting_s;
                WINDOW_WIDTH((i*TAP_COUNT_BITS)+TAP_COUNT_BITS-1 downto (i*TAP_COUNT_BITS))      <= window_width_s;
                TAP_DRIFT((i*TAP_COUNT_BITS)+TAP_COUNT_BITS-1 downto (i*TAP_COUNT_BITS))         <= tap_drift_s;
                WORD_ALIGN(i)                           <= word_align_s;
                SLIP_COUNT((i*8)+7 downto (i*8))        <= slip_count_s;
             end generate;
end generate;

gen_no_ls_clock: if (USE_LS_CLK = FALSE) generate
    BUSY_ALIGN          <= '0';

    DWCLK_SYNC          <= (others => '0');

    --lowspeed clk status
    EDGE_DETECT         <= (others => '0');
    STABLE_DETECT       <= (others => '0');
    FIRST_EDGE_FOUND    <= (others => '0');
    SECOND_EDGE_FOUND   <= (others => '0');
    NROF_RETRIES        <= (others => '0');
    TAP_SETTING         <= (others => '0');
    WINDOW_WIDTH        <= (others => '0');
    TAP_DRIFT           <= (others => '0');
    WORD_ALIGN          <= (others => '0');
    SLIP_COUNT          <= (others => '0');

    ERROR               <= '0';
end generate;

end rtl;
