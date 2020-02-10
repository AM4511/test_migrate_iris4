-- *********************************************************************
-- Copyright 2011, ON Semiconductor Corporation.
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


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

library work;
use work.all;

entity iserdes_interface is
  generic (
        SIMULATION              : integer := 0;
        NROF_CONN               : integer := 10;
        MAX_DATAWIDTH           : integer := 10;
        SERDES_DATAWIDTH        : integer := 6;
        RETRY_MAX               : integer := 32767; --16 bits, global
        STABLE_COUNT            : integer := 16;
        TAP_COUNT_MAX           : integer := 32;
        TAP_COUNT_BITS          : integer := 8;
        DATA_RATE               : string  := "DDR"; -- DDR/SDR
        DIFF_TERM               : boolean := TRUE;
        USE_BLOCKRAMFIFO        : boolean := TRUE;
        INVERT_OUTPUT           : boolean := FALSE;
        INVERSE_BITORDER        : boolean := FALSE;
        CHANNEL_COUNT           : integer := 2;
        SERDES_COUNT            : integer := 2;
        SAMPLE_COUNT            : integer := 128;
        IDELAY_COUNT            : integer := 1;

        LOW_PWR                 : boolean := FALSE;
        REFCLK_F                : real    := 200.0;
        C_CALWIDTH              : integer := 5;

        CLKSPEED                : integer := 40; -- APPCLK speed in MHz. Everything is generated from Appclk to be as sync as possible

        C_FAMILY                : string  := "VIRTEX6";


        NROF_DELAYCTRLS         : integer := 1;
        IDELAYCLK_MULT          : integer := 3;
        IDELAYCLK_DIV           : integer := 1;
        GENIDELAYCLK            : boolean := FALSE; -- generate own idelayrefclk based on mult and div parameters or use external clk
                                       -- ext clk can come from common part and thus always be in spec regardless of clkspeed

        USE_DIFF_HS_CLK_IN      : boolean := FALSE;
        USE_DIFF_LS_CLK_IN      : boolean := FALSE;
        USE_HS_REGIONAL_CLK     : boolean := FALSE;
        USE_LS_CLK              : boolean := FALSE;
        CLOCK_COUNT             : integer := 2;
        USE_ONE_CLOCK           : boolean := TRUE;
        USE_HSCLK_BUFIO         : boolean := TRUE
  );
  port(
        CLOCK                       : in    std_logic;
        RESET                       : in    std_logic;

        CLK_STATUS                  : out   std_logic_vector((16*CLOCK_COUNT)-1 downto 0);

        CLKREF                      : in    std_logic; -- optional 200MHz/300MHz refclk

        -- from sensor (only used when USED_EXT_CLK = YES)
        LS_IN_CLK                   : in    std_logic_vector(CLOCK_COUNT-1 downto 0);
        LS_IN_CLKb                  : in    std_logic_vector(CLOCK_COUNT-1 downto 0);

        HS_IN_CLK                   : in    std_logic_vector(CLOCK_COUNT-1 downto 0);
        HS_IN_CLKb                  : in    std_logic_vector(CLOCK_COUNT-1 downto 0);

        HS_CLK_MON                  : out   std_logic_vector(CLOCK_COUNT-1 downto 0);

        --serdes data, directly connected to bondpads
        SDATAP                      : in    std_logic_vector((NROF_CONN*CHANNEL_COUNT)-1 downto 0);
        SDATAN                      : in    std_logic_vector((NROF_CONN*CHANNEL_COUNT)-1 downto 0);

        SDATA_MON                   : out   std_logic_vector((NROF_CONN*CHANNEL_COUNT)-1 downto 0);

        --calibration input
        IODELAY_CAL_CLK             : in    std_logic_vector((2*CHANNEL_COUNT*SERDES_COUNT*C_CALWIDTH)-1 downto 0); --values for both hs (0) (fixme) & ls clks (1)
        IODELAY_CAL                 : in    std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT*C_CALWIDTH)-1 downto 0);

        -- status info datachannel
        EDGE_DETECT                 : out   std_logic_vector(NROF_CONN-1 downto 0);
        STABLE_DETECT               : out   std_logic_vector(NROF_CONN-1 downto 0);
        FIRST_EDGE_FOUND            : out   std_logic_vector(NROF_CONN-1 downto 0);
        SECOND_EDGE_FOUND           : out   std_logic_vector(NROF_CONN-1 downto 0);
        NROF_RETRIES                : out   std_logic_vector((NROF_CONN*16)-1 downto 0);
        TAP_SETTING                 : out   std_logic_vector((NROF_CONN*TAP_COUNT_BITS)-1 downto 0);
        WINDOW_WIDTH                : out   std_logic_vector((NROF_CONN*TAP_COUNT_BITS)-1 downto 0);
        TAP_DRIFT                   : out   std_logic_vector((NROF_CONN*TAP_COUNT_BITS)-1 downto 0);
        WORD_ALIGN                  : out   std_logic_vector(NROF_CONN-1 downto 0);
        SLIP_COUNT                  : out   std_logic_vector((NROF_CONN*8)-1 downto 0);
        SHIFT_STATUS                : out   std_logic_vector((6*CHANNEL_COUNT*NROF_CONN)-1 downto 0);

        --status info ls clk channel (if any)
        EDGE_DETECT_CLK             : out   std_logic_vector(CLOCK_COUNT-1 downto 0);
        STABLE_DETECT_CLK           : out   std_logic_vector(CLOCK_COUNT-1 downto 0);
        FIRST_EDGE_FOUND_CLK        : out   std_logic_vector(CLOCK_COUNT-1 downto 0);
        SECOND_EDGE_FOUND_CLK       : out   std_logic_vector(CLOCK_COUNT-1 downto 0);
        NROF_RETRIES_CLK            : out   std_logic_vector((CLOCK_COUNT*16)-1 downto 0);
        TAP_SETTING_CLK             : out   std_logic_vector((CLOCK_COUNT*TAP_COUNT_BITS)-1 downto 0);
        WINDOW_WIDTH_CLK            : out   std_logic_vector((CLOCK_COUNT*TAP_COUNT_BITS)-1 downto 0);
        TAP_DRIFT_CLK               : out   std_logic_vector((CLOCK_COUNT*TAP_COUNT_BITS)-1 downto 0);
        WORD_ALIGN_CLK              : out   std_logic_vector(CLOCK_COUNT-1 downto 0);
        SLIP_COUNT_CLK              : out   std_logic_vector((CLOCK_COUNT*8)-1 downto 0);

        -- control
        START_TRAINING              : in    std_logic;
        BUSY_TRAINING               : out   std_logic;

        FIFO_EN                     : in    std_logic;

        DATAWIDTH                   : in    integer;
        SINGLECHANNEL               : in    std_logic_vector(7 downto 0);
        ALIGNMODE                   : in    std_logic_vector(15 downto 0);   --selects how alignment is done (using 'standard' alignment, 2 serdes alignment, manual alignment)
                                                                             --1 dt 0:  "00": 'standard' automatic alignment (XAPP...)
                                                                             --         "01": 2 SERDES alignment (SONET) (not yet supported)
                                                                             --         "10": manual tap alignment
                                                                             --         "11": RFU
                                                                             --2: RFU
                                                                             --3: do bitalign on all individual channels (0) or use results from a single channel for all channels
                                                                             --4: window monitor enable (bitalign)
                                                                             --5: selects between wordalignment on trainingword (0) or use of external word clock (1)
                                                                             --6: enables filtering mode
                                                                             --7: inhibits bitalign, testmode, only use after training WITH bitalign has been executed at least once
                                                                             --8: select output channel
                                                                             --9: disable vtc (required for window monitoring?)

        AUTOALIGNCHANNEL            : in    std_logic_vector(1 downto 0);   --selects which compare channels are used (high, low, both)
        MANUAL_TAP                  : in    std_logic_vector(TAP_COUNT_BITS-1 downto 0);   --selects tap in manual mode
        TRAINING                    : in    std_logic_vector(MAX_DATAWIDTH-1 downto 0);
        ENABLE_TRAINING             : in    std_logic_vector(NROF_CONN-1 downto 0);

        --data
        FIFO_EMPTY                  : out   std_logic_vector(NROF_CONN-1 downto 0);
        FIFO_AEMPTY                 : out   std_logic_vector(NROF_CONN-1 downto 0);
        FIFO_RDEN                   : in    std_logic_vector(NROF_CONN-1 downto 0);
        FIFO_DOUT                   : out   std_logic_vector((MAX_DATAWIDTH*NROF_CONN)-1 downto 0);
        FIFO_RESET                  : in    std_logic;
        ERROR                       : out   std_logic_vector(NROF_CONN-1 downto 0);
        ERROR_CLK                   : out   std_logic
       );
end iserdes_interface;

architecture structure of iserdes_interface is

component iserdes_idelayctrl
  generic (
    NROF_DELAYCTRLS     : integer;
    IDELAYCLK_MULT      : integer;
    IDELAYCLK_DIV       : integer;
    GENIDELAYCLK        : boolean;
    C_FAMILY            : string
    );
  port (
    CLOCK            : in std_logic;
    RESET            : in std_logic;
    CLKREF           : in std_logic;
    idelay_ctrl_rdy  : out std_logic
  );
end component;

component iserdes_datapaths
  generic(
        NROF_CONN               : integer;
        SERDES_DATAWIDTH        : integer := 6;
        SERDES_COUNT            : integer := 2;
        IDELAY_COUNT            : integer := 1;
        CHANNEL_COUNT           : integer := 2;
        CLOCK_COUNT             : integer := 1;
        DATA_RATE               : string  := "DDR"; -- DDR/SDR
        DIFF_TERM               : boolean := TRUE;
        INVERT_OUTPUT           : boolean := FALSE;
        INVERSE_BITORDER        : boolean := FALSE;
        LOW_PWR                 : boolean := FALSE;
        C_FAMILY                : string  := "VIRTEX6";
        REFCLK_F                : real    := 200.0;
        C_CALWIDTH              : integer := 5;
        MAX_DATAWIDTH           : integer;
        USE_BLOCKRAMFIFO        : boolean := TRUE
       );
  port(
        CLOCK                   : in    std_logic;
        CLOCK_RESET             : in    std_logic;

        CLKDIV                  : in    std_logic_vector(CLOCK_COUNT-1 downto 0);
        CLKDIV_RESET            : in    std_logic_vector(CLOCK_COUNT-1 downto 0);

        DATAWIDTH               : in    integer;

        -- serial
        SCLK                    : in    std_logic_vector(CLOCK_COUNT-1 downto 0);
        SCLKb                   : in    std_logic_vector(CLOCK_COUNT-1 downto 0);

        -- differential data input -> from outside,
        SDATAP                  : in    std_logic_vector((NROF_CONN*CHANNEL_COUNT)-1 downto 0);
        SDATAN                  : in    std_logic_vector((NROF_CONN*CHANNEL_COUNT)-1 downto 0);

        SDATA_MON               : out   std_logic_vector((NROF_CONN*CHANNEL_COUNT)-1 downto 0);

        -- iodelay preload value, used for calibration of propagation delays and lengtmatchings
        -- can be set individually but will most likely have the same setting
        IODELAY_CAL             : in    std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT*C_CALWIDTH)-1 downto 0);

        --Ctrl IO, all controls should run on CLKDIV/parallelclk
        -- bitalign controls
        IODELAY_ISERDES_RESET   : in    std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        IODELAY_INC             : in    std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        IODELAY_CE              : in    std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        IODELAY_ENVTC           : in    std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        ISERDES_BITSLIP         : in    std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        ISERDES_DATAOUT         : out   std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH)-1 downto 0);

        -- wordalign controls
        BITSLIP                 : in    std_logic_vector((NROF_CONN*CHANNEL_COUNT)-1 downto 0);
        BITSLIP_RESET           : in    std_logic_vector((CHANNEL_COUNT*NROF_CONN)-1 downto 0);
        CONCATINATED_VALID      : out   std_logic_vector((NROF_CONN*CHANNEL_COUNT)-1 downto 0);
        CONCATINATED_DATA       : out   std_logic_vector((NROF_CONN*CHANNEL_COUNT*MAX_DATAWIDTH)-1 downto 0);

        --options
        CONCAT_MODE             : in    std_logic;
        DWCLK_SYNC              : in    std_logic_vector(10 downto 0);
        PAR_SKIP                : in    std_logic_vector(NROF_CONN-1 downto 0);
        FILTER_MODE             : in    std_logic;
        SELECT_CHANNEL          : in    std_logic;
        VTC_EN                  : in    std_logic;

        --status
        SHIFT_STATUS            : out   std_logic_vector((6*CHANNEL_COUNT*NROF_CONN)-1 downto 0);

        FIFO_EMPTY              : out   std_logic_vector(NROF_CONN-1 downto 0);
        FIFO_AEMPTY             : out   std_logic_vector(NROF_CONN-1 downto 0);
        FIFO_RDEN               : in    std_logic_vector(NROF_CONN-1 downto 0);
        FIFO_DOUT               : out   std_logic_vector((MAX_DATAWIDTH*NROF_CONN)-1 downto 0);
        FIFO_RESET              : in    std_logic;
        FIFO_WREN               : in    std_logic;
        ERROR                   : out   std_logic_vector(NROF_CONN-1 downto 0)
       );
end component;

component iserdes_control
  generic (
        NROF_CONN                : integer;
        CHANNEL_COUNT            : integer := 2;
        SERDES_COUNT             : integer := 2;
        SERDES_DATAWIDTH         : integer := 6;
        MAX_DATAWIDTH            : integer := 18;
        STABLE_COUNT             : integer := 128;
        SAMPLE_COUNT             : integer := 128;
        TAP_COUNT_MAX            : integer := 32;
        TAP_COUNT_BITS           : integer := 8;
        RETRY_MAX                : integer := 32767
  );
  port(
        CLOCK                       : in    std_logic;
        RESET                       : in    std_logic;

        START_TRAINING              : in    std_logic;
        BUSY_TRAINING               : out   std_logic;

        --MONITOR_ENABLE              : in    std_logic;
        --ALIGNMODE                   : in    std_logic; --select between align on one channel and align on all channels
        DATAWIDTH                   : in    integer;
        SINGLECHANNEL               : in    std_logic_vector(7 downto 0);
        ALIGNMODE                   : in    std_logic_vector(4 downto 0);   --selects how alignment is done (using 'standard' alignment, 2 serdes alignment, manual alignment)
        AUTOALIGNCHANNEL            : in    std_logic_vector(CHANNEL_COUNT-1 downto 0);   --selects which compare channels are used (high, low, both)
        MANUAL_TAP                  : in    std_logic_vector(TAP_COUNT_BITS-1 downto 0);   --selects tap in manual mode
        TRAINING                    : in    std_logic_vector(MAX_DATAWIDTH-1 downto 0);
        ENABLE_TRAINING             : in    std_logic_vector(NROF_CONN-1 downto 0);
        INHIBIT_BITALIGN            : in    std_logic;

        -- all io
        IODELAY_ISERDES_RESET       : out   std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        IODELAY_INC                 : out   std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        IODELAY_CE                  : out   std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        IODELAY_ENVTC               : out   std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        ISERDES_BITSLIP             : out   std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        BITSLIP                     : out   std_logic_vector((CHANNEL_COUNT*NROF_CONN)-1 downto 0);
        BITSLIP_RESET               : out   std_logic_vector((CHANNEL_COUNT*NROF_CONN)-1 downto 0);

        ISERDES_DATAOUT             : in    std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH)-1 downto 0);

        CONCATINATED_VALID          : in    std_logic_vector((CHANNEL_COUNT*NROF_CONN)-1 downto 0);
        CONCATINATED_DATA           : in    std_logic_vector((CHANNEL_COUNT*MAX_DATAWIDTH*NROF_CONN)-1 downto 0);

        --all status info
        EDGE_DETECT                 : out   std_logic_vector(NROF_CONN-1 downto 0);
        STABLE_DETECT               : out   std_logic_vector(NROF_CONN-1 downto 0);
        FIRST_EDGE_FOUND            : out   std_logic_vector(NROF_CONN-1 downto 0);
        SECOND_EDGE_FOUND           : out   std_logic_vector(NROF_CONN-1 downto 0);
        NROF_RETRIES                : out   std_logic_vector((NROF_CONN*16)-1 downto 0);
        TAP_SETTING                 : out   std_logic_vector((NROF_CONN*TAP_COUNT_BITS)-1 downto 0);
        WINDOW_WIDTH                : out   std_logic_vector((NROF_CONN*TAP_COUNT_BITS)-1 downto 0);
        TAP_DRIFT                   : out   std_logic_vector((NROF_CONN*TAP_COUNT_BITS)-1 downto 0);
        WORD_ALIGN                  : out   std_logic_vector(NROF_CONN-1 downto 0);
        SLIP_COUNT                  : out   std_logic_vector((NROF_CONN*8)-1 downto 0)
       );
end component;

component iserdes_clocks
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
end component;

component iserdes_skip
    generic (
        NROF_CONN               : integer
    );
    port (
        CLOCK                       : in    std_logic;  --appclock
        RESET                       : in    std_logic;  --active high reset

        DATAWIDTH                   : in    integer;

        PAR_SKIP                    : out  std_logic_vector(NROF_CONN-1 downto 0);
        SLIP_COUNT                  : in   std_logic_vector((NROF_CONN*8)-1 downto 0)
    );
end component;

component iserdes_sync
    generic (
        MAX_DATAWIDTH           : integer;
        NROF_CONN               : integer;
        CHANNEL_COUNT           : integer;
        CLOCK_COUNT             : integer;
        TAP_COUNT_BITS          : integer
    );
    port (
        CLOCK                           : in    std_logic;
        CLOCK_RESET                     : in    std_logic;

        CLKDIV                          : in    std_logic;
        CLKDIV_RESET                    : in    std_logic;

        --signals synchronous with CLOCK
        START_TRAINING                  : in    std_logic;
        BUSY_TRAINING                   : out   std_logic;

        --control
        FIFO_EN                         : in    std_logic;

        DATAWIDTH                       : in    integer;
        SINGLECHANNEL                   : in    std_logic_vector(7 downto 0);
        ALIGNMODE                       : in    std_logic_vector(15 downto 0);
        AUTOALIGNCHANNEL                : in    std_logic_vector(CHANNEL_COUNT-1 downto 0);
        MANUAL_TAP                      : in    std_logic_vector(TAP_COUNT_BITS-1 downto 0);
        TRAINING                        : in    std_logic_vector(MAX_DATAWIDTH-1 downto 0);
        ENABLE_TRAINING                 : in    std_logic_vector(NROF_CONN-1 downto 0);

        --status
        CLK_STATUS                      : out   std_logic_vector((CLOCK_COUNT*16)-1 downto 0);

        EDGE_DETECT                     : out   std_logic_vector(NROF_CONN-1 downto 0);
        STABLE_DETECT                   : out   std_logic_vector(NROF_CONN-1 downto 0);
        FIRST_EDGE_FOUND                : out   std_logic_vector(NROF_CONN-1 downto 0);
        SECOND_EDGE_FOUND               : out   std_logic_vector(NROF_CONN-1 downto 0);
        NROF_RETRIES                    : out   std_logic_vector((NROF_CONN*16)-1 downto 0);
        TAP_SETTING                     : out   std_logic_vector((NROF_CONN*TAP_COUNT_BITS)-1 downto 0);
        WINDOW_WIDTH                    : out   std_logic_vector((NROF_CONN*TAP_COUNT_BITS)-1 downto 0);
        TAP_DRIFT                       : out   std_logic_vector((NROF_CONN*TAP_COUNT_BITS)-1 downto 0);
        WORD_ALIGN                      : out   std_logic_vector(NROF_CONN-1 downto 0);
        SLIP_COUNT                      : out   std_logic_vector((NROF_CONN*8)-1 downto 0);
        SHIFT_STATUS                    : out   std_logic_vector((6*CHANNEL_COUNT*NROF_CONN)-1 downto 0);

        EDGE_DETECT_CLK                 : out   std_logic_vector(CLOCK_COUNT-1 downto 0);
        STABLE_DETECT_CLK               : out   std_logic_vector(CLOCK_COUNT-1 downto 0);
        FIRST_EDGE_FOUND_CLK            : out   std_logic_vector(CLOCK_COUNT-1 downto 0);
        SECOND_EDGE_FOUND_CLK           : out   std_logic_vector(CLOCK_COUNT-1 downto 0);
        NROF_RETRIES_CLK                : out   std_logic_vector((CLOCK_COUNT*16)-1 downto 0);
        TAP_SETTING_CLK                 : out   std_logic_vector((CLOCK_COUNT*TAP_COUNT_BITS)-1 downto 0);
        WINDOW_WIDTH_CLK                : out   std_logic_vector((CLOCK_COUNT*TAP_COUNT_BITS)-1 downto 0);
        TAP_DRIFT_CLK                   : out   std_logic_vector((CLOCK_COUNT*TAP_COUNT_BITS)-1 downto 0);
        WORD_ALIGN_CLK                  : out   std_logic_vector(CLOCK_COUNT-1 downto 0);
        SLIP_COUNT_CLK                  : out   std_logic_vector((CLOCK_COUNT*8)-1 downto 0);

        --signals synchronous with CLKDIV(0)
        START_TRAINING_SYNC            : out   std_logic;
        BUSY_TRAINING_SYNC             : in    std_logic;

        FIFO_EN_SYNC                   : out    std_logic;

        DATAWIDTH_SYNC                 : out    integer;
        SINGLECHANNEL_SYNC             : out    std_logic_vector(7 downto 0);
        ALIGNMODE_SYNC                 : out    std_logic_vector(15 downto 0);
        AUTOALIGNCHANNEL_SYNC          : out    std_logic_vector(CHANNEL_COUNT-1 downto 0);
        MANUAL_TAP_SYNC                : out    std_logic_vector(TAP_COUNT_BITS-1 downto 0);
        TRAINING_SYNC                  : out    std_logic_vector(MAX_DATAWIDTH-1 downto 0);
        ENABLE_TRAINING_SYNC           : out    std_logic_vector(NROF_CONN-1 downto 0);

        CLK_STATUS_SYNC                : in    std_logic_vector((CLOCK_COUNT*16)-1 downto 0);

        EDGE_DETECT_SYNC               : in    std_logic_vector(NROF_CONN-1 downto 0);
        STABLE_DETECT_SYNC             : in    std_logic_vector(NROF_CONN-1 downto 0);
        FIRST_EDGE_FOUND_SYNC          : in    std_logic_vector(NROF_CONN-1 downto 0);
        SECOND_EDGE_FOUND_SYNC         : in    std_logic_vector(NROF_CONN-1 downto 0);
        NROF_RETRIES_SYNC              : in    std_logic_vector((NROF_CONN*16)-1 downto 0);
        TAP_SETTING_SYNC               : in    std_logic_vector((NROF_CONN*TAP_COUNT_BITS)-1 downto 0);
        WINDOW_WIDTH_SYNC              : in    std_logic_vector((NROF_CONN*TAP_COUNT_BITS)-1 downto 0);
        TAP_DRIFT_SYNC                 : in    std_logic_vector((NROF_CONN*TAP_COUNT_BITS)-1 downto 0);
        WORD_ALIGN_SYNC                : in    std_logic_vector(NROF_CONN-1 downto 0);
        SLIP_COUNT_SYNC                : in    std_logic_vector((NROF_CONN*8)-1 downto 0);
        SHIFT_STATUS_SYNC              : in    std_logic_vector((6*CHANNEL_COUNT*NROF_CONN)-1 downto 0);

        EDGE_DETECT_CLK_SYNC           : in    std_logic_vector(CLOCK_COUNT-1 downto 0);
        STABLE_DETECT_CLK_SYNC         : in    std_logic_vector(CLOCK_COUNT-1 downto 0);
        FIRST_EDGE_FOUND_CLK_SYNC      : in    std_logic_vector(CLOCK_COUNT-1 downto 0);
        SECOND_EDGE_FOUND_CLK_SYNC     : in    std_logic_vector(CLOCK_COUNT-1 downto 0);
        NROF_RETRIES_CLK_SYNC          : in    std_logic_vector((CLOCK_COUNT*16)-1 downto 0);
        TAP_SETTING_CLK_SYNC           : in    std_logic_vector((CLOCK_COUNT*TAP_COUNT_BITS)-1 downto 0);
        WINDOW_WIDTH_CLK_SYNC          : in    std_logic_vector((CLOCK_COUNT*TAP_COUNT_BITS)-1 downto 0);
        TAP_DRIFT_CLK_SYNC             : in    std_logic_vector((CLOCK_COUNT*TAP_COUNT_BITS)-1 downto 0);
        WORD_ALIGN_CLK_SYNC            : in    std_logic_vector(CLOCK_COUNT-1 downto 0);
        SLIP_COUNT_CLK_SYNC            : in    std_logic_vector((CLOCK_COUNT*8)-1 downto 0)
    );
end component;

signal CLOCK_RESET                  : std_logic;
signal CLKDIV_RESET                 : std_logic_vector(CLOCK_COUNT-1 downto 0);
signal CLKDIV                       : std_logic_vector(CLOCK_COUNT-1 downto 0);

signal SCLK                         : std_logic_vector(CLOCK_COUNT-1 downto 0);
signal SCLKb                        : std_logic_vector(CLOCK_COUNT-1 downto 0);

signal IODELAY_ISERDES_RESET        : std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
signal IODELAY_INC                  : std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
signal IODELAY_CE                   : std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
signal IODELAY_ENVTC                : std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
signal ISERDES_BITSLIP              : std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
signal ISERDES_DATAOUT              : std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH)-1 downto 0);

-- wordalign controls
signal BITSLIP                      : std_logic_vector((NROF_CONN*CHANNEL_COUNT)-1 downto 0);
signal BITSLIP_RESET                : std_logic_vector((CHANNEL_COUNT*NROF_CONN)-1 downto 0);
signal CONCATINATED_VALID           : std_logic_vector((NROF_CONN*CHANNEL_COUNT)-1 downto 0);
signal CONCATINATED_DATA            : std_logic_vector((NROF_CONN*CHANNEL_COUNT*MAX_DATAWIDTH)-1 downto 0);

--options
signal DWCLK_SYNC                   : std_logic_vector(10 downto 0);
signal PAR_SKIP                     : std_logic_vector(NROF_CONN-1 downto 0);

--synchronyser signals
signal START_TRAINING_sync          : std_logic;
signal BUSY_TRAINING_sync           : std_logic;

signal DATAWIDTH_sync               : integer;
signal SINGLECHANNEL_sync           : std_logic_vector(7 downto 0);
signal ALIGNMODE_sync               : std_logic_vector(15 downto 0);   --selects how alignment is done (using 'standard' alignment, 2 serdes alignment, manual alignment)
signal AUTOALIGNCHANNEL_sync        : std_logic_vector(CHANNEL_COUNT-1 downto 0);   --selects which compare channels are used (high, low, both)
signal MANUAL_TAP_sync              : std_logic_vector(TAP_COUNT_BITS-1 downto 0);   --selects tap in manual mode
signal TRAINING_sync                : std_logic_vector(MAX_DATAWIDTH-1 downto 0);
signal ENABLE_TRAINING_sync         : std_logic_vector(NROF_CONN-1 downto 0);

--status info
signal EDGE_DETECT_sync             : std_logic_vector(NROF_CONN-1 downto 0);
signal STABLE_DETECT_sync           : std_logic_vector(NROF_CONN-1 downto 0);
signal FIRST_EDGE_FOUND_sync        : std_logic_vector(NROF_CONN-1 downto 0);
signal SECOND_EDGE_FOUND_sync       : std_logic_vector(NROF_CONN-1 downto 0);
signal NROF_RETRIES_sync            : std_logic_vector((NROF_CONN*16)-1 downto 0);
signal TAP_SETTING_sync             : std_logic_vector((NROF_CONN*TAP_COUNT_BITS)-1 downto 0);
signal WINDOW_WIDTH_sync            : std_logic_vector((NROF_CONN*TAP_COUNT_BITS)-1 downto 0);
signal TAP_DRIFT_sync               : std_logic_vector((NROF_CONN*TAP_COUNT_BITS)-1 downto 0);
signal WORD_ALIGN_sync              : std_logic_vector(NROF_CONN-1 downto 0);
signal SLIP_COUNT_sync              : std_logic_vector((NROF_CONN*8)-1 downto 0);

signal EDGE_DETECT_CLK_sync         : std_logic_vector(CLOCK_COUNT-1 downto 0);
signal STABLE_DETECT_CLK_sync       : std_logic_vector(CLOCK_COUNT-1 downto 0);
signal FIRST_EDGE_FOUND_CLK_sync    : std_logic_vector(CLOCK_COUNT-1 downto 0);
signal SECOND_EDGE_FOUND_CLK_sync   : std_logic_vector(CLOCK_COUNT-1 downto 0);
signal NROF_RETRIES_CLK_sync        : std_logic_vector((CLOCK_COUNT*16)-1 downto 0);
signal TAP_SETTING_CLK_sync         : std_logic_vector((CLOCK_COUNT*TAP_COUNT_BITS)-1 downto 0);
signal WINDOW_WIDTH_CLK_sync        : std_logic_vector((CLOCK_COUNT*TAP_COUNT_BITS)-1 downto 0);
signal TAP_DRIFT_CLK_sync           : std_logic_vector((CLOCK_COUNT*TAP_COUNT_BITS)-1 downto 0);
signal WORD_ALIGN_CLK_sync          : std_logic_vector(CLOCK_COUNT-1 downto 0);
signal SLIP_COUNT_CLK_sync          : std_logic_vector((CLOCK_COUNT*8)-1 downto 0);

signal SHIFT_STATUS_sync            : std_logic_vector((6*CHANNEL_COUNT*NROF_CONN)-1 downto 0);

signal CLK_STATUS_sync              : std_logic_vector((CLOCK_COUNT*16)-1 downto 0);

signal FIFO_EN_SYNC                 : std_logic;

signal BUSY_TRAINING_clocks         : std_logic;
signal BUSY_TRAINING_control        : std_logic;

signal vtc_en                       : std_logic;

attribute keep : string;
attribute keep of clkdiv : signal is "true";
begin

the_iserdes_idelayctrl: iserdes_idelayctrl
  generic map (
    NROF_DELAYCTRLS     => NROF_DELAYCTRLS  ,
    IDELAYCLK_MULT      => IDELAYCLK_MULT   ,
    IDELAYCLK_DIV       => IDELAYCLK_DIV    ,
    GENIDELAYCLK        => GENIDELAYCLK     ,
    C_FAMILY            => C_FAMILY
    )
  port map (
    CLOCK            => CLOCK               ,
    RESET            => RESET               ,
    CLKREF           => CLKREF              ,
    idelay_ctrl_rdy  => open
  );


CLOCK_RESET     <= RESET;

the_iserdes_datapaths: iserdes_datapaths
  generic map(
        NROF_CONN               => NROF_CONN            ,
        SERDES_DATAWIDTH        => SERDES_DATAWIDTH     ,
        SERDES_COUNT            => SERDES_COUNT         ,
        IDELAY_COUNT            => IDELAY_COUNT         ,
        CHANNEL_COUNT           => CHANNEL_COUNT        ,
        CLOCK_COUNT             => CLOCK_COUNT          ,
        DATA_RATE               => DATA_RATE            ,
        DIFF_TERM               => DIFF_TERM            ,
        INVERT_OUTPUT           => INVERT_OUTPUT        ,
        INVERSE_BITORDER        => INVERSE_BITORDER     ,
        LOW_PWR                 => LOW_PWR              ,
        C_FAMILY                => C_FAMILY             ,
        REFCLK_F                => REFCLK_F             ,
        C_CALWIDTH              => C_CALWIDTH           ,
        MAX_DATAWIDTH           => MAX_DATAWIDTH        ,
        USE_BLOCKRAMFIFO        => USE_BLOCKRAMFIFO
       )
  port map (
        CLOCK                   => CLOCK                ,
        CLOCK_RESET             => CLOCK_RESET          ,

        CLKDIV                  => CLKDIV               ,
        CLKDIV_RESET            => CLKDIV_RESET         ,

        DATAWIDTH               => DATAWIDTH            ,

        -- serial
        SCLK                    => SCLK                 ,
        SCLKb                   => SCLKb                ,

        -- differential data input -> from outside,
        SDATAP                  => SDATAP               ,
        SDATAN                  => SDATAN               ,

        SDATA_MON               => SDATA_MON            ,

        -- iodelay preload value, used for calibration of propagation delays and lengtmatchings
        -- can be set individually but will most likely have the same setting
        IODELAY_CAL             => IODELAY_CAL          ,

        --Ctrl IO, all controls should run on CLKDIV/parallelclk
        -- bitalign controls
        IODELAY_ISERDES_RESET   => IODELAY_ISERDES_RESET,
        IODELAY_INC             => IODELAY_INC          ,
        IODELAY_CE              => IODELAY_CE           ,
        IODELAY_ENVTC           => IODELAY_ENVTC        ,
        ISERDES_BITSLIP         => ISERDES_BITSLIP      ,
        ISERDES_DATAOUT         => ISERDES_DATAOUT      ,

        -- wordalign controls
        BITSLIP                 => BITSLIP              ,
        BITSLIP_RESET           => BITSLIP_RESET        ,
        CONCATINATED_VALID      => CONCATINATED_VALID   ,
        CONCATINATED_DATA       => CONCATINATED_DATA    ,

        --options
        CONCAT_MODE             => ALIGNMODE_sync(5)    ,
        DWCLK_SYNC              => DWCLK_SYNC           ,
        PAR_SKIP                => PAR_SKIP             ,
        FILTER_MODE             => ALIGNMODE_sync(6)    ,
        SELECT_CHANNEL          => ALIGNMODE_sync(8)    ,
        VTC_EN                  => vtc_en               ,
        --status
        SHIFT_STATUS            => SHIFT_STATUS_sync    ,

        FIFO_EMPTY              => FIFO_EMPTY           ,
        FIFO_AEMPTY             => FIFO_AEMPTY          ,
        FIFO_RDEN               => FIFO_RDEN            ,
        FIFO_DOUT               => FIFO_DOUT            ,
        FIFO_RESET              => FIFO_RESET           ,
        FIFO_WREN               => FIFO_EN_SYNC         ,
        ERROR                   => ERROR
       );

vtc_en <= not ALIGNMODE_sync(9);

BUSY_TRAINING_sync <= BUSY_TRAINING_control or BUSY_TRAINING_clocks;

the_iserdes_control: iserdes_control
  generic map (
        NROF_CONN                   => NROF_CONN           ,
        CHANNEL_COUNT               => CHANNEL_COUNT       ,
        SERDES_COUNT                => SERDES_COUNT        ,
        SERDES_DATAWIDTH            => SERDES_DATAWIDTH    ,
        MAX_DATAWIDTH               => MAX_DATAWIDTH       ,
        STABLE_COUNT                => STABLE_COUNT        ,
        SAMPLE_COUNT                => SAMPLE_COUNT        ,
        TAP_COUNT_MAX               => TAP_COUNT_MAX       ,
        TAP_COUNT_BITS              => TAP_COUNT_BITS      ,
        RETRY_MAX                   => RETRY_MAX
  )
  port map (
        CLOCK                       => CLKDIV(0)            ,
        RESET                       => CLKDIV_RESET(0)      ,

        START_TRAINING              => START_TRAINING_sync  ,
        BUSY_TRAINING               => BUSY_TRAINING_control,

        DATAWIDTH                   => DATAWIDTH_sync       ,
        SINGLECHANNEL               => SINGLECHANNEL_sync   ,
        ALIGNMODE                   => ALIGNMODE_sync(4 downto 0)       ,
        AUTOALIGNCHANNEL            => AUTOALIGNCHANNEL_sync,
        MANUAL_TAP                  => MANUAL_TAP_sync      ,
        TRAINING                    => TRAINING_sync        ,
        ENABLE_TRAINING             => ENABLE_TRAINING_sync ,
        INHIBIT_BITALIGN            => ALIGNMODE_sync(7)    ,

        -- all io
        IODELAY_ISERDES_RESET       => IODELAY_ISERDES_RESET,
        IODELAY_INC                 => IODELAY_INC          ,
        IODELAY_CE                  => IODELAY_CE           ,
        IODELAY_ENVTC               => IODELAY_ENVTC        ,
        ISERDES_BITSLIP             => ISERDES_BITSLIP      ,
        BITSLIP                     => BITSLIP              ,
        BITSLIP_RESET               => BITSLIP_RESET        ,

        ISERDES_DATAOUT             => ISERDES_DATAOUT      ,

        CONCATINATED_VALID          => CONCATINATED_VALID   ,
        CONCATINATED_DATA           => CONCATINATED_DATA    ,

        --all status info
        EDGE_DETECT                 => EDGE_DETECT_sync      ,
        STABLE_DETECT               => STABLE_DETECT_sync    ,
        FIRST_EDGE_FOUND            => FIRST_EDGE_FOUND_sync ,
        SECOND_EDGE_FOUND           => SECOND_EDGE_FOUND_sync,
        NROF_RETRIES                => NROF_RETRIES_sync     ,
        TAP_SETTING                 => TAP_SETTING_sync      ,
        WINDOW_WIDTH                => WINDOW_WIDTH_sync     ,
        TAP_DRIFT                   => TAP_DRIFT_sync        ,
        WORD_ALIGN                  => WORD_ALIGN_sync       ,
        SLIP_COUNT                  => SLIP_COUNT_sync
       );

the_iserdes_clocks: iserdes_clocks
  generic map (
        SIMULATION                  => SIMULATION           ,
        MAX_DATAWIDTH               => MAX_DATAWIDTH        ,
        SERDES_DATAWIDTH            => SERDES_DATAWIDTH     ,
        DATA_RATE                   => DATA_RATE            ,
        CLKSPEED                    => CLKSPEED             ,
        SIM_DEVICE                  => C_FAMILY             ,
        DIFF_TERM                   => DIFF_TERM            ,
        USE_DIFF_HS_CLK_IN          => USE_DIFF_HS_CLK_IN   ,
        USE_DIFF_LS_CLK_IN          => USE_DIFF_LS_CLK_IN   ,
        USE_HS_REGIONAL_CLK         => USE_HS_REGIONAL_CLK  ,
        USE_LS_CLK                  => USE_LS_CLK           ,
        CLOCK_COUNT                 => CLOCK_COUNT          ,
        USE_ONE_CLOCK               => USE_ONE_CLOCK        ,
        SERDES_COUNT                => SERDES_COUNT         ,
        IDELAY_COUNT                => IDELAY_COUNT         ,
        CHANNEL_COUNT               => CHANNEL_COUNT        ,
        C_CALWIDTH                  => C_CALWIDTH           ,
        LOW_PWR                     => LOW_PWR              ,
        STABLE_COUNT                => STABLE_COUNT         ,
        SAMPLE_COUNT                => SAMPLE_COUNT         ,
        TAP_COUNT_MAX               => TAP_COUNT_MAX        ,
        TAP_COUNT_BITS              => TAP_COUNT_BITS       ,
        REFCLK_F                    => REFCLK_F             ,
        USE_HSCLK_BUFIO             => USE_HSCLK_BUFIO
  )
  port map (
        DATAWIDTH                   => DATAWIDTH_SYNC       ,
        CLOCK                       => CLOCK                ,
        RESET                       => RESET                ,

        HS_IN_CLK                   => HS_IN_CLK            ,
        HS_IN_CLKb                  => HS_IN_CLKb           ,

        LS_IN_CLK                   => LS_IN_CLK            ,
        LS_IN_CLKb                  => LS_IN_CLKb           ,

        HS_CLK_MON                  => HS_CLK_MON           ,

        -- to iserdes
        CLK                         => SCLK                 ,
        CLKb                        => SCLKb                ,
        CLKDIV                      => CLKDIV               ,
        CLKDIV_RESET                => CLKDIV_RESET         ,

        --alignment of lowspeed clk
        START_ALIGN                 => START_TRAINING       ,
        START_ALIGN_SYNC            => START_TRAINING_sync  ,
        BUSY_ALIGN                  => BUSY_TRAINING_clocks ,

        --align controls
        IODELAY_CAL                 => IODELAY_CAL_CLK              ,
        INHIBIT_BITALIGN            => ALIGNMODE_sync(7)            ,
        ALIGNMODE                   => ALIGNMODE_sync(4 downto 0)   ,   --selects how alignment is done (using 'standard' alignment, 2 serdes alignment, manual alignment, enable window_monitor)
        AUTOALIGNCHANNEL            => AUTOALIGNCHANNEL_SYNC        ,   --selects which compare channels are used (high, low, both)
        MANUAL_TAP                  => MANUAL_TAP_SYNC              ,   --selects tap in manual mode
        ENABLE_TRAINING             => '1'                          ,
        DWCLK_SYNC                  => DWCLK_SYNC                   ,
        VTC_EN                      => vtc_en                       ,

        --clk status
        CLK_STATUS                  => CLK_STATUS_sync              ,

        EDGE_DETECT                 => EDGE_DETECT_CLK_sync         ,
        STABLE_DETECT               => STABLE_DETECT_CLK_sync       ,
        FIRST_EDGE_FOUND            => FIRST_EDGE_FOUND_CLK_sync    ,
        SECOND_EDGE_FOUND           => SECOND_EDGE_FOUND_CLK_sync   ,
        NROF_RETRIES                => NROF_RETRIES_CLK_sync        ,
        TAP_SETTING                 => TAP_SETTING_CLK_sync         ,
        WINDOW_WIDTH                => WINDOW_WIDTH_CLK_sync        ,
        TAP_DRIFT                   => TAP_DRIFT_CLK_sync           ,
        WORD_ALIGN                  => WORD_ALIGN_CLK_sync          ,
        SLIP_COUNT                  => SLIP_COUNT_CLK_sync          ,

        ERROR                       => ERROR_CLK
       );

the_iserdes_skip: iserdes_skip
    generic map (
        NROF_CONN                   => NROF_CONN
    )
    port map (
        CLOCK                       => CLKDIV(0)            ,
        RESET                       => CLKDIV_RESET(0)      ,

        DATAWIDTH                   => DATAWIDTH_sync       ,

        PAR_SKIP                    => PAR_SKIP             ,
        SLIP_COUNT                  => SLIP_COUNT_sync
    );

the_iserdes_sync: iserdes_sync
    generic map (
        MAX_DATAWIDTH               => MAX_DATAWIDTH        ,
        NROF_CONN                   => NROF_CONN            ,
        CHANNEL_COUNT               => CHANNEL_COUNT        ,
        CLOCK_COUNT                 => CLOCK_COUNT          ,
        TAP_COUNT_BITS              => TAP_COUNT_BITS
    )
    port map (
        CLOCK                       => CLOCK                ,
        CLOCK_RESET                 => RESET                ,

        CLKDIV                      => CLKDIV(0)            ,
        CLKDIV_RESET                => CLKDIV_RESET(0)      ,

        --signals synchronous with CLOCK
        START_TRAINING              => START_TRAINING       ,
        BUSY_TRAINING               => BUSY_TRAINING        ,

        --control
        FIFO_EN                     => FIFO_EN              ,

        DATAWIDTH                   => DATAWIDTH            ,
        SINGLECHANNEL               => SINGLECHANNEL        ,
        ALIGNMODE                   => ALIGNMODE            ,
        AUTOALIGNCHANNEL            => AUTOALIGNCHANNEL(CHANNEL_COUNT-1 downto 0)   ,
        MANUAL_TAP                  => MANUAL_TAP           ,
        TRAINING                    => TRAINING             ,
        ENABLE_TRAINING             => ENABLE_TRAINING      ,

        --status
        CLK_STATUS                  => CLK_STATUS           ,

        EDGE_DETECT                 => EDGE_DETECT          ,
        STABLE_DETECT               => STABLE_DETECT        ,
        FIRST_EDGE_FOUND            => FIRST_EDGE_FOUND     ,
        SECOND_EDGE_FOUND           => SECOND_EDGE_FOUND    ,
        NROF_RETRIES                => NROF_RETRIES         ,
        TAP_SETTING                 => TAP_SETTING          ,
        WINDOW_WIDTH                => WINDOW_WIDTH         ,
        TAP_DRIFT                   => TAP_DRIFT            ,
        WORD_ALIGN                  => WORD_ALIGN           ,
        SLIP_COUNT                  => SLIP_COUNT           ,
        SHIFT_STATUS                => SHIFT_STATUS         ,

        EDGE_DETECT_CLK             => EDGE_DETECT_CLK      ,
        STABLE_DETECT_CLK           => STABLE_DETECT_CLK    ,
        FIRST_EDGE_FOUND_CLK        => FIRST_EDGE_FOUND_CLK ,
        SECOND_EDGE_FOUND_CLK       => SECOND_EDGE_FOUND_CLK,
        NROF_RETRIES_CLK            => NROF_RETRIES_CLK     ,
        TAP_SETTING_CLK             => TAP_SETTING_CLK      ,
        WINDOW_WIDTH_CLK            => WINDOW_WIDTH_CLK     ,
        TAP_DRIFT_CLK               => TAP_DRIFT_CLK        ,
        WORD_ALIGN_CLK              => WORD_ALIGN_CLK       ,
        SLIP_COUNT_CLK              => SLIP_COUNT_CLK       ,

        --signals synchronous with CLKDIV(0)
        START_TRAINING_SYNC         => START_TRAINING_SYNC       ,
        BUSY_TRAINING_SYNC          => BUSY_TRAINING_SYNC        ,

        FIFO_EN_SYNC                => FIFO_EN_SYNC              ,

        DATAWIDTH_SYNC              => DATAWIDTH_SYNC            ,
        SINGLECHANNEL_SYNC          => SINGLECHANNEL_SYNC        ,
        ALIGNMODE_SYNC              => ALIGNMODE_SYNC            ,
        AUTOALIGNCHANNEL_SYNC       => AUTOALIGNCHANNEL_SYNC     ,
        MANUAL_TAP_SYNC             => MANUAL_TAP_SYNC           ,
        TRAINING_SYNC               => TRAINING_SYNC             ,
        ENABLE_TRAINING_SYNC        => ENABLE_TRAINING_SYNC      ,

        CLK_STATUS_SYNC             => CLK_STATUS_sync           ,

        EDGE_DETECT_SYNC            => EDGE_DETECT_SYNC          ,
        STABLE_DETECT_SYNC          => STABLE_DETECT_SYNC        ,
        FIRST_EDGE_FOUND_SYNC       => FIRST_EDGE_FOUND_SYNC     ,
        SECOND_EDGE_FOUND_SYNC      => SECOND_EDGE_FOUND_SYNC    ,
        NROF_RETRIES_SYNC           => NROF_RETRIES_SYNC         ,
        TAP_SETTING_SYNC            => TAP_SETTING_SYNC          ,
        WINDOW_WIDTH_SYNC           => WINDOW_WIDTH_SYNC         ,
        TAP_DRIFT_SYNC              => TAP_DRIFT_SYNC            ,
        WORD_ALIGN_SYNC             => WORD_ALIGN_SYNC           ,
        SLIP_COUNT_SYNC             => SLIP_COUNT_SYNC           ,
        SHIFT_STATUS_SYNC           => SHIFT_STATUS_SYNC         ,

        EDGE_DETECT_CLK_SYNC        => EDGE_DETECT_CLK_SYNC      ,
        STABLE_DETECT_CLK_SYNC      => STABLE_DETECT_CLK_SYNC    ,
        FIRST_EDGE_FOUND_CLK_SYNC   => FIRST_EDGE_FOUND_CLK_SYNC ,
        SECOND_EDGE_FOUND_CLK_SYNC  => SECOND_EDGE_FOUND_CLK_SYNC,
        NROF_RETRIES_CLK_SYNC       => NROF_RETRIES_CLK_SYNC     ,
        TAP_SETTING_CLK_SYNC        => TAP_SETTING_CLK_SYNC      ,
        WINDOW_WIDTH_CLK_SYNC       => WINDOW_WIDTH_CLK_SYNC     ,
        TAP_DRIFT_CLK_SYNC          => TAP_DRIFT_CLK_SYNC        ,
        WORD_ALIGN_CLK_SYNC         => WORD_ALIGN_CLK_SYNC       ,
        SLIP_COUNT_CLK_SYNC         => SLIP_COUNT_CLK_SYNC
    );

end  structure;
