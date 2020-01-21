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

entity iserdes_control is
  generic (
        NROF_CONN                : integer := 10;
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
end iserdes_control;

architecture rtl of iserdes_control is

component iserdes_sequencer
  port(
        CLOCK                       : in    std_logic;
        RESET                       : in    std_logic;

        START_TRAINING              : in    std_logic;
        BUSY_TRAINING               : out   std_logic;

        INHIBIT_BITALIGN            : in    std_logic;

        START_BITALIGN              : out   std_logic;
        BUSY_BITALIGN               : in    std_logic;

        START_WORDALIGN             : out   std_logic;
        BUSY_WORDALIGN              : in    std_logic
    );
end component;

component iserdes_bitalign
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
end component;

component iserdes_mux_bitalign
  generic(
        SERDES_DATAWIDTH        : integer := 6;
        CHANNEL_COUNT           : integer := 2;
        SERDES_COUNT            : integer := 2;
        TAP_COUNT_BITS          : integer := 8;
        NROF_CONN               : integer
       );
  port(
        CLOCK                       : in    std_logic;
        RESET                       : in    std_logic;

        MONITOR_ENABLE              : in    std_logic;
        START_BITALIGN              : in    std_logic;
        BUSY_BITALIGN               : out   std_logic;

        START_INITIALALIGN          : out   std_logic;
        BUSY_INITIALALIGN           : in    std_logic;

        START_MONITOR               : out   std_logic;
        BUSY_MONITOR                : in    std_logic;

        ALIGNMODE                   : in    std_logic; --select between align on one channel and align on all channels
        ALIGNCHANNEL                : in    std_logic_vector(7 downto 0);

        ENABLE_TRAINING             : in    std_logic_vector(NROF_CONN-1 downto 0);

        --muxed io
        IODELAY_ISERDES_RESET_mux   : in    std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        IODELAY_INC_mux             : in    std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        IODELAY_CE_mux              : in    std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        IODELAY_ENVTC_mux           : in    std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        ISERDES_BITSLIP_mux         : in    std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);

        ISERDES_DATAOUT_mux         : out   std_logic_vector((CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH)-1 downto 0);

        --muxed status info
        EDGE_DETECT_mux             : in    std_logic;
        STABLE_DETECT_mux           : in    std_logic;
        FIRST_EDGE_FOUND_mux        : in    std_logic;
        SECOND_EDGE_FOUND_mux       : in    std_logic;
        NROF_RETRIES_mux            : in    std_logic_vector(15 downto 0);
        TAP_SETTING_mux             : in    std_logic_vector(TAP_COUNT_BITS-1 downto 0);
        WINDOW_WIDTH_mux            : in    std_logic_vector(TAP_COUNT_BITS-1 downto 0);
        TAP_DRIFT_OUT_mux           : in    std_logic_vector(TAP_COUNT_BITS-1 downto 0);
        TAP_DRIFT_IN_mux            : out   std_logic_vector(TAP_COUNT_BITS-1 downto 0);
        TAP_COUNT_IN_mux            : out   std_logic_vector(TAP_COUNT_BITS-1 downto 0);

        -- all io
        IODELAY_ISERDES_RESET_all   : out   std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        IODELAY_INC_all             : out   std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        IODELAY_CE_all              : out   std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        IODELAY_ENVTC_all           : out   std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        ISERDES_BITSLIP_all         : out   std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);

        ISERDES_DATAOUT_all         : in    std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH)-1 downto 0);

        --all status info
        EDGE_DETECT_all             : out   std_logic_vector(NROF_CONN-1 downto 0);
        STABLE_DETECT_all           : out   std_logic_vector(NROF_CONN-1 downto 0);
        FIRST_EDGE_FOUND_all        : out   std_logic_vector(NROF_CONN-1 downto 0);
        SECOND_EDGE_FOUND_all       : out   std_logic_vector(NROF_CONN-1 downto 0);
        NROF_RETRIES_all            : out   std_logic_vector((NROF_CONN*16)-1 downto 0);
        TAP_SETTING_all             : out   std_logic_vector((NROF_CONN*TAP_COUNT_BITS)-1 downto 0);
        WINDOW_WIDTH_all            : out   std_logic_vector((NROF_CONN*TAP_COUNT_BITS)-1 downto 0);
        TAP_DRIFT_OUT_all           : out   std_logic_vector((NROF_CONN*TAP_COUNT_BITS)-1 downto 0);
        TAP_DRIFT_IN_all            : in    std_logic_vector((NROF_CONN*TAP_COUNT_BITS)-1 downto 0)
    );
end component;

component iserdes_wordalign
  generic (
        MAX_DATAWIDTH       : integer := 18;
        CHANNEL_COUNT       : integer := 2
  );
  port(
        CLOCK                   : in    std_logic;
        RESET                   : in    std_logic;

        DATAWIDTH               : in    integer;

        WORDALIGN_START         : in    std_logic;
        WORDALIGN_BUSY          : out   std_logic;

        AUTOALIGNCHANNEL        : in    std_logic_vector(CHANNEL_COUNT-1 downto 0);   --selects which compare channels are used (high, low, both)
        TRAINING                : in    std_logic_vector(MAX_DATAWIDTH-1 downto 0);

        BITSLIP_RESET           : out   std_logic_vector((CHANNEL_COUNT)-1 downto 0);
        BITSLIP                 : out   std_logic_vector((CHANNEL_COUNT)-1 downto 0);
        CONCATINATED_VALID      : in    std_logic_vector((CHANNEL_COUNT)-1 downto 0);
        CONCATINATED_DATA       : in    std_logic_vector((CHANNEL_COUNT*MAX_DATAWIDTH)-1 downto 0);

        -- status info
        WORD_ALIGN              : out   std_logic;
        SLIP_COUNT              : out   std_logic_vector(7 downto 0)
  );
end component;

component iserdes_mux_wordalign
  generic(
        MAX_DATAWIDTH           : integer := 18;
        CHANNEL_COUNT           : integer := 2;
        NROF_CONN               : integer
       );
  port(
        CLOCK                       : in    std_logic;
        RESET                       : in    std_logic;

        START_ALIGN                 : in    std_logic;
        BUSY_ALIGN                  : out   std_logic;

        START_WORDALIGN             : out   std_logic;
        BUSY_WORDALIGN              : in    std_logic;

        ENABLE_TRAINING             : in    std_logic_vector(NROF_CONN-1 downto 0);

        --muxed io
        BITSLIP_mux                 : in    std_logic_vector((CHANNEL_COUNT)-1 downto 0);
        BITSLIP_RESET_mux           : in    std_logic_vector((CHANNEL_COUNT)-1 downto 0);
        CONCATINATED_VALID_mux      : out   std_logic_vector((CHANNEL_COUNT)-1 downto 0);
        CONCATINATED_DATA_mux       : out   std_logic_vector((CHANNEL_COUNT*MAX_DATAWIDTH)-1 downto 0);

        --muxed status info
        WORD_ALIGN_mux              : in    std_logic;
        SLIP_COUNT_mux              : in    std_logic_vector(7 downto 0);

        -- all io
        BITSLIP_all                 : out   std_logic_vector((CHANNEL_COUNT*NROF_CONN)-1 downto 0);
        BITSLIP_RESET_all           : out   std_logic_vector((CHANNEL_COUNT*NROF_CONN)-1 downto 0);
        CONCATINATED_VALID_all      : in    std_logic_vector((CHANNEL_COUNT*NROF_CONN)-1 downto 0);
        CONCATINATED_DATA_all       : in    std_logic_vector((CHANNEL_COUNT*MAX_DATAWIDTH*NROF_CONN)-1 downto 0);

        --all status info
        WORD_ALIGN_all              : out   std_logic_vector(NROF_CONN-1 downto 0);
        SLIP_COUNT_all              : out   std_logic_vector((NROF_CONN*8)-1 downto 0)
    );
end component;

signal start_bitalign              : std_logic;
signal busy_bitalign               : std_logic;

signal start_wordalign             : std_logic;
signal busy_wordalign              : std_logic;

signal start_initialalign          : std_logic;
signal busy_initialalign           : std_logic;

signal start_monitor               : std_logic;
signal busy_monitor                : std_logic;

signal start_wordalign_mux         : std_logic;
signal busy_wordalign_mux          : std_logic;

signal edge_detect_mux             : std_logic;
signal stable_detect_mux           : std_logic;
signal first_edge_found_mux        : std_logic;
signal second_edge_found_mux       : std_logic;
signal nrof_retries_mux            : std_logic_vector(15 downto 0);
signal tap_setting_mux             : std_logic_vector(TAP_COUNT_BITS-1 downto 0);
signal window_width_mux            : std_logic_vector(TAP_COUNT_BITS-1 downto 0);
signal tap_drift_out_mux           : std_logic_vector(TAP_COUNT_BITS-1 downto 0);
signal tap_drift_in_mux            : std_logic_vector(TAP_COUNT_BITS-1 downto 0);
signal word_align_mux              : std_logic;
signal slip_count_mux              : std_logic_vector(7 downto 0);
signal tap_count_in_mux            : std_logic_vector(TAP_COUNT_BITS-1 downto 0);

signal iodelay_iserdes_reset_mux   : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
signal iodelay_inc_mux             : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
signal iodelay_ce_mux              : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
signal iodelay_envtc_mux           : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
signal iserdes_bitslip_mux         : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
signal iserdes_dataout_mux         : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH)-1 downto 0);

signal bitslip_mux                 : std_logic_vector((CHANNEL_COUNT)-1 downto 0);
signal bitslip_reset_mux           : std_logic_vector((CHANNEL_COUNT)-1 downto 0);
signal concatinated_valid_mux      : std_logic_vector((CHANNEL_COUNT)-1 downto 0);
signal concatinated_data_mux       : std_logic_vector((CHANNEL_COUNT*MAX_DATAWIDTH)-1 downto 0);

signal tap_drift_s                 : std_logic_vector((NROF_CONN*TAP_COUNT_BITS)-1 downto 0);

begin

the_iserdes_sequencer: iserdes_sequencer
  port map (
        CLOCK                   => CLOCK            ,
        RESET                   => RESET            ,

        START_TRAINING          => START_TRAINING   ,
        BUSY_TRAINING           => BUSY_TRAINING    ,

        START_BITALIGN          => start_bitalign   ,
        BUSY_BITALIGN           => busy_bitalign    ,

        INHIBIT_BITALIGN        => INHIBIT_BITALIGN ,

        START_WORDALIGN         => start_wordalign  ,
        BUSY_WORDALIGN          => busy_wordalign
    );

the_iserdes_bitalign: iserdes_bitalign
  generic map (
        SERDES_DATAWIDTH        => SERDES_DATAWIDTH             ,
        TAP_COUNT_MAX           => TAP_COUNT_MAX                ,
        TAP_COUNT_BITS          => TAP_COUNT_BITS               ,
        RETRY_MAX               => RETRY_MAX                    ,
        CHANNEL_COUNT           => CHANNEL_COUNT                ,
        SERDES_COUNT            => SERDES_COUNT                 ,
        STABLE_COUNT            => STABLE_COUNT                 ,
        SAMPLE_COUNT            => SAMPLE_COUNT
  )
  port map(
        CLOCK                   => CLOCK                        ,
        RESET                   => RESET                        ,

        --ctrl info
        START_ALIGN             => start_initialalign           ,
        BUSY_ALIGN              => busy_initialalign            ,

        MONITOR_START           => start_monitor                ,
        MONITOR_BUSY            => busy_monitor                 ,

        DATAWIDTH               => DATAWIDTH                    ,

        ALIGNMODE               => ALIGNMODE(2 downto 0)        , --selects how alignment is done (using 'standard' alignment, 2 serdes alignment, manual alignment, enable window_monitor)
        AUTOALIGNCHANNEL        => AUTOALIGNCHANNEL             , --selects which compare channels are used (high, low, both)
        MANUAL_TAP              => MANUAL_TAP                   , --selects tap in manual mode


        --Ctrl IO, all controls should run on CLKDIV/parallelclk
        -- bitalign controls
        IODELAY_ISERDES_RESET   => iodelay_iserdes_reset_mux    ,
        IODELAY_INC             => iodelay_inc_mux              ,
        IODELAY_CE              => iodelay_ce_mux               ,
        IODELAY_ENVTC           => iodelay_envtc_mux            ,
        ISERDES_BITSLIP         => iserdes_bitslip_mux          ,
        ISERDES_DATAOUT         => iserdes_dataout_mux          ,

        -- status info
        EDGE_DETECT             => edge_detect_mux              ,
        STABLE_DETECT           => stable_detect_mux            ,
        FIRST_EDGE_FOUND        => first_edge_found_mux         ,
        SECOND_EDGE_FOUND       => second_edge_found_mux        ,
        NROF_RETRIES            => nrof_retries_mux             ,
        TAP_SETTING             => tap_setting_mux              ,
        WINDOW_WIDTH            => window_width_mux             ,
        TAP_DRIFT_OUT           => tap_drift_out_mux            ,
        TAP_DRIFT_IN            => tap_drift_in_mux             ,
        TAP_COUNT_IN            => tap_count_in_mux
       );

TAP_DRIFT <= tap_drift_s;

the_iserdes_mux_bitalign: iserdes_mux_bitalign
  generic map (
        SERDES_DATAWIDTH            => SERDES_DATAWIDTH             ,
        CHANNEL_COUNT               => CHANNEL_COUNT                ,
        SERDES_COUNT                => SERDES_COUNT                 ,
        TAP_COUNT_BITS              => TAP_COUNT_BITS               ,
        NROF_CONN                   => NROF_CONN
       )
  port map(
        CLOCK                       => CLOCK                        ,
        RESET                       => RESET                        ,

        MONITOR_ENABLE              => ALIGNMODE(4)                 ,
        START_BITALIGN              => start_bitalign               ,
        BUSY_BITALIGN               => busy_bitalign                ,

        START_INITIALALIGN          => start_initialalign           ,
        BUSY_INITIALALIGN           => busy_initialalign            ,

        START_MONITOR               => start_monitor                ,
        BUSY_MONITOR                => busy_monitor                 ,

        ALIGNMODE                   => ALIGNMODE(3)                 ,
        ALIGNCHANNEL                => SINGLECHANNEL                ,

        ENABLE_TRAINING             => ENABLE_TRAINING              ,

        --muxed io
        IODELAY_ISERDES_RESET_mux   => iodelay_iserdes_reset_mux    ,
        IODELAY_INC_mux             => iodelay_inc_mux              ,
        IODELAY_CE_mux              => iodelay_ce_mux               ,
        IODELAY_ENVTC_MUX           => iodelay_envtc_mux            ,
        ISERDES_BITSLIP_mux         => iserdes_bitslip_mux          ,

        ISERDES_DATAOUT_mux         => iserdes_dataout_mux          ,

        --muxed status info
        EDGE_DETECT_mux             => edge_detect_mux              ,
        STABLE_DETECT_mux           => stable_detect_mux            ,
        FIRST_EDGE_FOUND_mux        => first_edge_found_mux         ,
        SECOND_EDGE_FOUND_mux       => second_edge_found_mux        ,
        NROF_RETRIES_mux            => nrof_retries_mux             ,
        TAP_SETTING_mux             => tap_setting_mux              ,
        WINDOW_WIDTH_mux            => window_width_mux             ,
        TAP_DRIFT_out_mux           => tap_drift_out_mux            ,
        TAP_DRIFT_in_mux            => tap_drift_in_mux             ,
        TAP_COUNT_IN_mux            => tap_count_in_mux             ,

        -- all io
        IODELAY_ISERDES_RESET_all   => IODELAY_ISERDES_RESET        ,
        IODELAY_INC_all             => IODELAY_INC                  ,
        IODELAY_CE_all              => IODELAY_CE                   ,
        IODELAY_ENVTC_all           => IODELAY_ENVTC                ,
        ISERDES_BITSLIP_all         => ISERDES_BITSLIP              ,

        ISERDES_DATAOUT_all         => ISERDES_DATAOUT              ,

        --all status info
        EDGE_DETECT_all             => EDGE_DETECT                  ,
        STABLE_DETECT_all           => STABLE_DETECT                ,
        FIRST_EDGE_FOUND_all        => FIRST_EDGE_FOUND             ,
        SECOND_EDGE_FOUND_all       => SECOND_EDGE_FOUND            ,
        NROF_RETRIES_all            => NROF_RETRIES                 ,
        TAP_SETTING_all             => TAP_SETTING                  ,
        WINDOW_WIDTH_all            => WINDOW_WIDTH                 ,
        TAP_DRIFT_OUT_all           => TAP_DRIFT_s                  ,
        TAP_DRIFT_IN_all            => TAP_DRIFT_s
    );

the_iserdes_wordalign: iserdes_wordalign
  generic map (
        MAX_DATAWIDTH           => MAX_DATAWIDTH                    ,
        CHANNEL_COUNT           => CHANNEL_COUNT
  )
  port map (
        CLOCK                   => CLOCK                            ,
        RESET                   => RESET                            ,

        DATAWIDTH               => DATAWIDTH                        ,

        WORDALIGN_START         => start_wordalign_mux              ,
        WORDALIGN_BUSY          => busy_wordalign_mux               ,

        AUTOALIGNCHANNEL        => AUTOALIGNCHANNEL                 ,
        TRAINING                => TRAINING                         ,

        BITSLIP_RESET           => bitslip_reset_mux                ,
        BITSLIP                 => bitslip_mux                      ,

        CONCATINATED_VALID      => concatinated_valid_mux           ,
        CONCATINATED_DATA       => concatinated_data_mux            ,

        -- status info
        WORD_ALIGN              => word_align_mux                   ,
        SLIP_COUNT              => slip_count_mux
  );

the_iserdes_mux_wordalign: iserdes_mux_wordalign
  generic map (
        MAX_DATAWIDTH           => MAX_DATAWIDTH            ,
        CHANNEL_COUNT           => CHANNEL_COUNT            ,
        NROF_CONN               => NROF_CONN
       )
  port map (
        CLOCK                       => CLOCK                        ,
        RESET                       => RESET                        ,

        START_ALIGN                 => start_wordalign              ,
        BUSY_ALIGN                  => busy_wordalign               ,

        START_WORDALIGN             => start_wordalign_mux          ,
        BUSY_WORDALIGN              => busy_wordalign_mux           ,

        ENABLE_TRAINING             => ENABLE_TRAINING              ,

        --muxed io
        BITSLIP_mux                 => bitslip_mux                  ,
        BITSLIP_RESET_mux           => bitslip_reset_mux            ,
        CONCATINATED_VALID_mux      => concatinated_valid_mux       ,
        CONCATINATED_DATA_mux       => concatinated_data_mux        ,

        --muxed status info
        WORD_ALIGN_mux              => word_align_mux               ,
        SLIP_COUNT_mux              => slip_count_mux               ,

        -- all io
        BITSLIP_all                 => BITSLIP                      ,
        BITSLIP_RESET_all           => BITSLIP_RESET                ,
        CONCATINATED_VALID_all      => CONCATINATED_VALID           ,
        CONCATINATED_DATA_all       => CONCATINATED_DATA            ,

        --all status info
        WORD_ALIGN_all              => WORD_ALIGN                   ,
        SLIP_COUNT_all              => SLIP_COUNT
    );

end rtl;