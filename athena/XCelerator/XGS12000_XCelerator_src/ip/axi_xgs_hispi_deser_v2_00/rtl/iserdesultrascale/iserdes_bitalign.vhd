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
--


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
--user:
-----------
library work;
use work.all;

-----------------------
-- ENTITY DEFINITION --
-----------------------
entity iserdes_bitalign is
  generic (
        SERDES_DATAWIDTH    : integer := 6;
        TAP_COUNT_MAX       : integer := 32;
        TAP_COUNT_BITS      : integer := 8;
        RETRY_MAX           : integer := 32767;
        CHANNEL_COUNT       : integer := 2;
        SERDES_COUNT        : integer := 2;
        STABLE_COUNT        : integer := 128;
        SAMPLE_COUNT        : integer := 128
  );
  port(
        CLOCK                   : in    std_logic;
        RESET                   : in    std_logic;

        --ctrl info
        START_ALIGN             : in    std_logic;
        BUSY_ALIGN              : out   std_logic;
        MONITOR_START           : in    std_logic;
        MONITOR_BUSY            : out   std_logic;

        DATAWIDTH               : in    integer;

        ALIGNMODE               : in    std_logic_vector(2 downto 0);   --selects how alignment is done (using 'standard' alignment, 2 serdes alignment, manual alignment, enable window_monitor)
        AUTOALIGNCHANNEL        : in    std_logic_vector(CHANNEL_COUNT-1 downto 0);   --selects which compare channels are used (high, low, both)
        MANUAL_TAP              : in    std_logic_vector(TAP_COUNT_BITS-1 downto 0);   --selects tap in manual mode

        --Ctrl IO, all controls should run on CLKDIV/parallelclk
        -- bitalign controls
        IODELAY_ISERDES_RESET   : out   std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        IODELAY_INC             : out   std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        IODELAY_CE              : out   std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        IODELAY_ENVTC           : out   std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        ISERDES_BITSLIP         : out   std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        ISERDES_DATAOUT         : in    std_logic_vector((CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH)-1 downto 0);

        -- status info
        EDGE_DETECT             : out   std_logic;
        STABLE_DETECT           : out   std_logic;
        FIRST_EDGE_FOUND        : out   std_logic;
        SECOND_EDGE_FOUND       : out   std_logic;
        NROF_RETRIES            : out   std_logic_vector(15 downto 0);
        TAP_SETTING             : out   std_logic_vector(TAP_COUNT_BITS-1 downto 0);
        WINDOW_WIDTH            : out   std_logic_vector(TAP_COUNT_BITS-1 downto 0);
        TAP_COUNT_IN            : in    std_logic_vector(TAP_COUNT_BITS-1 downto 0);
        TAP_DRIFT_IN            : in    std_logic_vector(TAP_COUNT_BITS-1 downto 0);
        TAP_DRIFT_OUT           : out   std_logic_vector(TAP_COUNT_BITS-1 downto 0)
       );

end iserdes_bitalign;

architecture rtl of iserdes_bitalign is

component iserdes_initial_bitalign
    generic (
        TAP_COUNT_MAX       : integer := 32;
        TAP_COUNT_BITS      : integer := 8;
        RETRY_MAX           : integer := 32767;
        CHANNEL_COUNT       : integer := 2;
        SERDES_COUNT        : integer := 2;
        STABLE_COUNT        : integer := 128
    );
    port (
        CLOCK                   : in    std_logic;
        RESET                   : in    std_logic;

        --ctrl info
        START_ALIGN             : in    std_logic;
        BUSY_ALIGN              : out   std_logic;
        ALIGNMODE               : in    std_logic_vector(2 downto 0);   --selects how alignment is done (using 'standard' alignment, 2 serdes alignment, manual alignment, enable window_monitor)
        MANUAL_TAP              : in    std_logic_vector(TAP_COUNT_BITS-1 downto 0);   --selects tap in manual mode

        CYCLE_VALID             : in    std_logic;
        COMPARE_LOAD            : out   std_logic;

        DET_VALID               : in    std_logic;
        EDGE                    : in    std_logic;
        EQUAL                   : in    std_logic;
        CURRISPREV              : in    std_logic;
        SHIFTED1                : in    std_logic;
        SHIFTED2                : in    std_logic;

        --Ctrl IO, all controls should run on CLKDIV/parallelclk
        -- bitalign controls
        IODELAY_ISERDES_RESET   : out   std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        IODELAY_INC             : out   std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        IODELAY_CE              : out   std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        IODELAY_ENVTC           : out   std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        ISERDES_BITSLIP         : out   std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);

        -- status info
        EDGE_DETECT             : out   std_logic;
        STABLE_DETECT           : out   std_logic;
        FIRST_EDGE_FOUND        : out   std_logic;
        SECOND_EDGE_FOUND       : out   std_logic;
        NROF_RETRIES            : out   std_logic_vector(15 downto 0);
        TAP_SETTING             : out   std_logic_vector(TAP_COUNT_BITS-1 downto 0);
        WINDOW_WIDTH            : out   std_logic_vector(TAP_COUNT_BITS-1 downto 0)
        );
end component;

component iserdes_window_monitor
    generic (
        TAP_COUNT_MAX       : integer := 32;
        TAP_COUNT_BITS      : integer := 8;
        CHANNEL_COUNT       : integer := 2;
        SERDES_COUNT        : integer := 2;
        SAMPLE_COUNT        : integer := 128
    );
    port(
        CLOCK                   : in    std_logic;
        RESET                   : in    std_logic;

        --ctrl info
        MONITOR_START           : in    std_logic;
        MONITOR_BUSY            : out   std_logic;

        CYCLE_VALID             : in    std_logic;

        DET_VALID               : in    std_logic;
        EDGE                    : in    std_logic;
        EQUAL                   : in    std_logic;
        CURRISPREV              : in    std_logic;
        SHIFTED1                : in    std_logic;
        SHIFTED2                : in    std_logic;

        --Ctrl IO, all controls should run on CLKDIV/parallelclk
        -- bitalign controls
        IODELAY_ISERDES_RESET   : out   std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        IODELAY_INC             : out   std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        IODELAY_CE              : out   std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        IODELAY_ENVTC           : out   std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);

        -- status info
        TAP_COUNT_IN            : in    std_logic_vector(TAP_COUNT_BITS-1 downto 0);
        TAP_DRIFT_IN            : in    std_logic_vector(TAP_COUNT_BITS-1 downto 0);
        TAP_DRIFT_OUT           : out   std_logic_vector(TAP_COUNT_BITS-1 downto 0)
    );
end component;

component iserdes_detectors
    generic (
        SERDES_DATAWIDTH    : integer := 6;
        CHANNEL_COUNT       : integer := 2;
        SERDES_COUNT        : integer := 2
    );
    port (
        CLOCK                   : in    std_logic;
        RESET                   : in    std_logic;

        CYCLE_VALID             : in    std_logic;
        ISERDES_DATAOUT         : in    std_logic_vector((CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH)-1 downto 0);

        --ctrl info
        AUTOALIGNCHANNEL        : in    std_logic_vector(CHANNEL_COUNT-1 downto 0);   --selects which compare channels are used (high, low, both)

        COMPARE_LOAD            : in    std_logic;

        DET_VALID               : out   std_logic;
        EDGE                    : out   std_logic;
        EQUAL                   : out   std_logic;
        CURRISPREV              : out   std_logic;
        SHIFTED1                : out   std_logic;
        SHIFTED2                : out   std_logic
       );
end component;


signal cyclecntr            : std_logic_vector(5 downto 0) := (others => '0');
alias  cycle_valid          : std_logic is cyclecntr(cyclecntr'high);
signal cycle_count          : integer range 1 to 8;

signal IODELAY_ISERDES_RESET_init       : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
signal IODELAY_INC_init                 : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
signal IODELAY_CE_init                  : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
signal IODELAY_ENVTC_init               : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);

signal IODELAY_ISERDES_RESET_window     : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
signal IODELAY_INC_window               : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
signal IODELAY_CE_window                : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
signal IODELAY_ENVTC_window             : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
 
signal COMPARE_LOAD                 :  std_logic;

signal DET_VALID                    :  std_logic;
signal EDGE                         :  std_logic;
signal EQUAL                        :  std_logic;
signal CURRISPREV                   :  std_logic;
signal SHIFTED1                     :  std_logic;
signal SHIFTED2                     :  std_logic;

begin

--cycle counter
edge_detect_process: process(CLOCK)
  begin
    if (CLOCK'event and CLOCK = '1') then
        if (cyclecntr(cyclecntr'high) = '1') then
            cyclecntr <= std_logic_vector(to_unsigned(cycle_count-2, cyclecntr'LENGTH));
        else
            cyclecntr <= cyclecntr - '1';
        end if;
    end if;
end process;

--FIXME: replace with low-resource lookup table (--> BRAM?)
--FIXME: also add other SERDES widths
--converts datawidth to cycle repetition count for 6 bit
datawidth_decoder: process(CLOCK)
  begin
    if (CLOCK'event and CLOCK = '1') then
        case datawidth is
            when 6 =>
                cycle_count <= 1;
            when 7 =>
                cycle_count <= 7;
            when 8 =>
                cycle_count <= 4;
            when 9 =>
                cycle_count <= 3;
            when 10 =>
                cycle_count <= 5;
            when 11 => --unsupported, should be 11
                cycle_count <= 1;
            when 12 =>
                cycle_count <= 2;
            when 13 => --unsupported, should be 13
                cycle_count <= 1;
            when 14 =>
                cycle_count <= 7;
            when 15 =>
                cycle_count <= 5;
            when 16 =>
                cycle_count <= 8;
            when 17 => --unsupported, should be 17
                cycle_count <= 1;
            when 18 =>
                cycle_count <= 3;
            when others =>
                cycle_count <= 1;
        end case;
    end if;
end process;

IODELAY_ISERDES_RESET <= IODELAY_ISERDES_RESET_init or IODELAY_ISERDES_RESET_window;
IODELAY_INC <= IODELAY_INC_init or IODELAY_INC_window;
IODELAY_CE <= IODELAY_CE_init or IODELAY_CE_window;
IODELAY_ENVTC <= IODELAY_ENVTC_init and IODELAY_ENVTC_window;

the_iserdes_initial_bitalign:  iserdes_initial_bitalign
    generic map (
        TAP_COUNT_MAX           => TAP_COUNT_MAX                ,
        TAP_COUNT_BITS          => TAP_COUNT_BITS               ,
        RETRY_MAX               => RETRY_MAX                    ,
        CHANNEL_COUNT           => CHANNEL_COUNT                ,
        SERDES_COUNT            => SERDES_COUNT                 ,
        STABLE_COUNT            => STABLE_COUNT
    )
    port map (
        CLOCK                   => CLOCK                        ,
        RESET                   => RESET                        ,

        --ctrl info
        START_ALIGN             => START_ALIGN                  ,
        BUSY_ALIGN              => BUSY_ALIGN                   ,
        ALIGNMODE               => ALIGNMODE                    ,
        MANUAL_TAP              => MANUAL_TAP                   ,

        CYCLE_VALID             => cycle_valid                  ,

        COMPARE_LOAD            => COMPARE_LOAD                 ,

        DET_VALID               => DET_VALID                    ,
        EDGE                    => EDGE                         ,
        EQUAL                   => EQUAL                        ,
        CURRISPREV              => CURRISPREV                   ,
        SHIFTED1                => SHIFTED1                     ,
        SHIFTED2                => SHIFTED2                     ,

        --Ctrl IO, all controls should run on CLKDIV/parallelclk
        -- bitalign controls
        IODELAY_ISERDES_RESET   => IODELAY_ISERDES_RESET_init   ,
        IODELAY_INC             => IODELAY_INC_init             ,
        IODELAY_CE              => IODELAY_CE_init              ,
        IODELAY_ENVTC           => IODELAY_ENVTC_init           ,
        ISERDES_BITSLIP         => ISERDES_BITSLIP              ,

        -- status info
        EDGE_DETECT             => EDGE_DETECT                  ,
        STABLE_DETECT           => STABLE_DETECT                ,
        FIRST_EDGE_FOUND        => FIRST_EDGE_FOUND             ,
        SECOND_EDGE_FOUND       => SECOND_EDGE_FOUND            ,
        NROF_RETRIES            => NROF_RETRIES                 ,
        TAP_SETTING             => TAP_SETTING                  ,
        WINDOW_WIDTH            => WINDOW_WIDTH
       );

the_iserdes_window_monitor: iserdes_window_monitor
    generic map (
        TAP_COUNT_MAX           => TAP_COUNT_MAX                ,
        TAP_COUNT_BITS          => TAP_COUNT_BITS               ,
        CHANNEL_COUNT           => CHANNEL_COUNT                ,
        SERDES_COUNT            => SERDES_COUNT                 ,
        SAMPLE_COUNT            => SAMPLE_COUNT
    )
    port map (
        CLOCK                   => CLOCK                        ,
        RESET                   => RESET                        ,

        --ctrl info
        MONITOR_START           => MONITOR_START                ,
        MONITOR_BUSY            => MONITOR_BUSY                 ,

        CYCLE_VALID             => cycle_valid                  ,

        DET_VALID               => DET_VALID                    ,
        EDGE                    => EDGE                         ,
        EQUAL                   => EQUAL                        ,
        CURRISPREV              => CURRISPREV                   ,
        SHIFTED1                => SHIFTED1                     ,
        SHIFTED2                => SHIFTED2                     ,

        --Ctrl IO, all controls should run on CLKDIV/parallelclk
        -- bitalign controls
        IODELAY_ISERDES_RESET   => IODELAY_ISERDES_RESET_window ,
        IODELAY_INC             => IODELAY_INC_window           ,
        IODELAY_CE              => IODELAY_CE_window            ,
        IODELAY_ENVTC           => IODELAY_ENVTC_window         ,

        -- status info
        TAP_COUNT_IN            => TAP_COUNT_IN                 ,
        TAP_DRIFT_IN            => TAP_DRIFT_IN                 ,
        TAP_DRIFT_OUT           => TAP_DRIFT_OUT
    );

the_iserdes_detectors: iserdes_detectors
    generic map (
        SERDES_DATAWIDTH        => SERDES_DATAWIDTH             ,
        CHANNEL_COUNT           => CHANNEL_COUNT                ,
        SERDES_COUNT            => SERDES_COUNT
    )
    port map (
        CLOCK                   => CLOCK                        ,
        RESET                   => RESET                        ,

        CYCLE_VALID             => cycle_valid                  ,
        ISERDES_DATAOUT         => ISERDES_DATAOUT              ,

        --ctrl info
        AUTOALIGNCHANNEL        => AUTOALIGNCHANNEL             ,

        COMPARE_LOAD            => COMPARE_LOAD                 ,

        DET_VALID               => DET_VALID                    ,
        EDGE                    => EDGE                         ,
        EQUAL                   => EQUAL                        ,
        CURRISPREV              => CURRISPREV                   ,
        SHIFTED1                => SHIFTED1                     ,
        SHIFTED2                => SHIFTED2
       );


end rtl;