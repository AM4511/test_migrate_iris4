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

entity iserdes_ls_clock is
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
        VTC_EN              : in    std_logic;

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
end iserdes_ls_clock;

architecture rtl of iserdes_ls_clock is

--datahandling
component iserdes_datapath
  generic(
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
        USE_BLOCKRAMFIFO        : boolean := TRUE;
        USE_FIFO                : boolean := TRUE
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
        SDATAP                  : in    std_logic_vector(CHANNEL_COUNT-1 downto 0);
        SDATAN                  : in    std_logic_vector(CHANNEL_COUNT-1 downto 0);

        SDATA_MON               : out   std_logic_vector(CHANNEL_COUNT-1 downto 0);

        -- iodelay preload value, used for calibration of propagation delays and lengtmatchings
        -- can be set individually but will most likely have the same setting
        IODELAY_CAL             : in    std_logic_vector((CHANNEL_COUNT*SERDES_COUNT*C_CALWIDTH)-1 downto 0);

        --Ctrl IO, all controls should run on CLKDIV/parallelclk
        -- bitalign controls
        IODELAY_ISERDES_RESET   : in    std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        IODELAY_INC             : in    std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        IODELAY_CE              : in    std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        IODELAY_ENVTC           : in    std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);

        ISERDES_BITSLIP         : in    std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        ISERDES_DATAOUT         : out   std_logic_vector((CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH)-1 downto 0);

        -- wordalign controls
        BITSLIP                 : in    std_logic_vector((CHANNEL_COUNT)-1 downto 0);
        BITSLIP_RESET           : in    std_logic_vector((CHANNEL_COUNT)-1 downto 0);
        CONCATINATED_VALID      : out   std_logic_vector((CHANNEL_COUNT)-1 downto 0);
        CONCATINATED_DATA       : out   std_logic_vector((CHANNEL_COUNT*MAX_DATAWIDTH)-1 downto 0);

        --options
        CONCAT_MODE             : in    std_logic;
        DWCLK_SYNC_IN           : in    std_logic_vector(10 downto 0);
        DWCLK_SYNC_OUT          : out   std_logic_vector(10 downto 0);
        VTC_EN                  : in    std_logic;
        
        --status
        SHIFT_STATUS            : out   std_logic_vector((6*CHANNEL_COUNT)-1 downto 0);

        FIFO_EN                 : in    std_logic;
        FIFO_EMPTY              : out   std_logic;
        FIFO_AEMPTY             : out   std_logic;
        FIFO_RDEN               : in    std_logic;
        FIFO_DOUT               : out   std_logic_vector(MAX_DATAWIDTH-1 downto 0);
        FIFO_RESET              : in    std_logic;
        FIFO_WREN               : in    std_logic;
        FIFO_DIN                : in    std_logic_vector(MAX_DATAWIDTH-1 downto 0);

        ERROR                   : out   std_logic
       );
end component;

--training control
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
        NROF_CONN               : integer := 10
       );
  port(
        CLOCK                       : in    std_logic;
        RESET                       : in    std_logic;

        MONITOR_ENABLE              : in    std_logic;
        START_BITALIGN              : in    std_logic;
        BUSY_BITALIGN               : out   std_logic := '0';

        START_INITIALALIGN          : out   std_logic := '0';
        BUSY_INITIALALIGN           : in    std_logic;

        START_MONITOR               : out   std_logic := '0';
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

        ISERDES_DATAOUT_mux         : out   std_logic_vector((CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH)-1 downto 0)  := (others => '0');

        --muxed status info
        EDGE_DETECT_mux             : in    std_logic;
        STABLE_DETECT_mux           : in    std_logic;
        FIRST_EDGE_FOUND_mux        : in    std_logic;
        SECOND_EDGE_FOUND_mux       : in    std_logic;
        NROF_RETRIES_mux            : in    std_logic_vector(15 downto 0);
        TAP_SETTING_mux             : in    std_logic_vector(TAP_COUNT_BITS-1 downto 0);
        WINDOW_WIDTH_mux            : in    std_logic_vector(TAP_COUNT_BITS-1 downto 0);
        TAP_DRIFT_OUT_mux           : in    std_logic_vector(TAP_COUNT_BITS-1 downto 0);
        TAP_DRIFT_IN_mux            : out   std_logic_vector(TAP_COUNT_BITS-1 downto 0) := (others => '0');
        TAP_COUNT_IN_mux            : out   std_logic_vector(TAP_COUNT_BITS-1 downto 0) := (others => '0');

        -- all io
        IODELAY_ISERDES_RESET_all   : out   std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT)-1 downto 0) := (others => '0');
        IODELAY_INC_all             : out   std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT)-1 downto 0) := (others => '0');
        IODELAY_CE_all              : out   std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT)-1 downto 0) := (others => '0');
        IODELAY_ENVTC_all           : out   std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT)-1 downto 0) := (others => '0');
        ISERDES_BITSLIP_all         : out   std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT)-1 downto 0) := (others => '0');

        ISERDES_DATAOUT_all         : in    std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH)-1 downto 0);

        --all status info
        EDGE_DETECT_all             : out   std_logic_vector(NROF_CONN-1 downto 0) := (others => '0');
        STABLE_DETECT_all           : out   std_logic_vector(NROF_CONN-1 downto 0) := (others => '0');
        FIRST_EDGE_FOUND_all        : out   std_logic_vector(NROF_CONN-1 downto 0) := (others => '0');
        SECOND_EDGE_FOUND_all       : out   std_logic_vector(NROF_CONN-1 downto 0) := (others => '0');
        NROF_RETRIES_all            : out   std_logic_vector((NROF_CONN*16)-1 downto 0) := (others => '0');
        TAP_SETTING_all             : out   std_logic_vector((NROF_CONN*TAP_COUNT_BITS)-1 downto 0) := (others => '0');
        WINDOW_WIDTH_all            : out   std_logic_vector((NROF_CONN*TAP_COUNT_BITS)-1 downto 0) := (others => '0');
        TAP_DRIFT_OUT_all           : out   std_logic_vector((NROF_CONN*TAP_COUNT_BITS)-1 downto 0) := (others => '0');
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

        BITSLIP                 : out   std_logic_vector((CHANNEL_COUNT)-1 downto 0);
        BITSLIP_RESET           : out    std_logic_vector((CHANNEL_COUNT)-1 downto 0);
        CONCATINATED_VALID      : in    std_logic_vector((CHANNEL_COUNT)-1 downto 0);
        CONCATINATED_DATA       : in    std_logic_vector((CHANNEL_COUNT*MAX_DATAWIDTH)-1 downto 0);

        -- status info
        WORD_ALIGN              : out   std_logic;
        SLIP_COUNT              : out   std_logic_vector(7 downto 0)
  );
end component;

signal zeros                        : std_logic_vector(MAX_DATAWIDTH-1 downto 0) := (others => '0');

signal iodelay_iserdes_reset_mux    : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
signal iodelay_inc_mux              : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
signal iodelay_ce_mux               : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
signal iodelay_envtc_mux            : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
signal iserdes_bitslip_mux          : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
signal iserdes_dataout_mux          : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH)-1 downto 0);

signal iodelay_iserdes_reset        : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
signal iodelay_inc                  : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
signal iodelay_ce                   : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
signal iodelay_envtc                : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
signal iserdes_bitslip              : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
signal iserdes_dataout              : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH)-1 downto 0);

signal edge_detect_mux              : std_logic;
signal stable_detect_mux            : std_logic;
signal first_edge_found_mux         : std_logic;
signal second_edge_found_mux        : std_logic;
signal nrof_retries_mux             : std_logic_vector(15 downto 0);
signal tap_setting_mux              : std_logic_vector(TAP_COUNT_BITS-1 downto 0);
signal window_width_mux             : std_logic_vector(TAP_COUNT_BITS-1 downto 0);
signal tap_drift_out_mux            : std_logic_vector(TAP_COUNT_BITS-1 downto 0);
signal tap_drift_in_mux             : std_logic_vector(TAP_COUNT_BITS-1 downto 0);
signal tap_count_in_mux             : std_logic_vector(TAP_COUNT_BITS-1 downto 0);

signal tap_drift_all                : std_logic_vector(TAP_COUNT_BITS-1 downto 0);

signal concatinated_valid           : std_logic_vector((CHANNEL_COUNT)-1 downto 0);
signal concatinated_data            : std_logic_vector((CHANNEL_COUNT*MAX_DATAWIDTH)-1 downto 0);

signal training                     : std_logic_vector(MAX_DATAWIDTH-1 downto 0);

signal bitslip                      : std_logic_vector((CHANNEL_COUNT)-1 downto 0);
signal bitslip_reset                : std_logic_vector((CHANNEL_COUNT)-1 downto 0);
signal start_bitalign               : std_logic;
signal busy_bitalign                : std_logic;

signal start_wordalign              : std_logic;
signal busy_wordalign               : std_logic;

signal start_initialalign           : std_logic;
signal busy_initialalign            : std_logic;

signal start_monitor                : std_logic;
signal busy_monitor                 : std_logic;

begin

ls_clk_datapath: iserdes_datapath
  generic map (
        SERDES_DATAWIDTH        => SERDES_DATAWIDTH,
        SERDES_COUNT            => SERDES_COUNT,
        IDELAY_COUNT            => IDELAY_COUNT,
        CHANNEL_COUNT           => CHANNEL_COUNT,
        CLOCK_COUNT             => CLOCK_COUNT,
        DATA_RATE               => DATA_RATE,
        DIFF_TERM               => DIFF_TERM,
        INVERT_OUTPUT           => FALSE,
        INVERSE_BITORDER        => FALSE,
        LOW_PWR                 => LOW_PWR,
        C_FAMILY                => C_FAMILY,
        REFCLK_F                => REFCLK_F,
        C_CALWIDTH              => C_CALWIDTH,
        MAX_DATAWIDTH           => MAX_DATAWIDTH,
        USE_BLOCKRAMFIFO        => TRUE,
        USE_FIFO                => FALSE
       )
  port map (
        CLOCK                   => CLOCK            ,
        CLOCK_RESET             => RESET            ,

        CLKDIV                  => CLKDIV           ,
        CLKDIV_RESET            => CLKDIV_RESET     ,

        DATAWIDTH               => DATAWIDTH        ,

        -- serial
        SCLK                    => CLK              ,
        SCLKb                   => CLKb             ,

        -- differential data input -> from outside,
        SDATAP                  => LS_IN_CLK        ,
        SDATAN                  => LS_IN_CLKb       ,

        SDATA_MON               => open             ,

        -- iodelay preload value, used for calibration of propagation delays and lengtmatchings
        -- can be set individually but will most likely have the same setting
        IODELAY_CAL             => IODELAY_CAL      ,

        --Ctrl IO, all controls should run on CLKDIV/parallelclk
        -- bitalign controls
        IODELAY_ISERDES_RESET   => iodelay_iserdes_reset    ,
        IODELAY_INC             => iodelay_inc              ,
        IODELAY_CE              => iodelay_ce               ,
        IODELAY_ENVTC           => iodelay_envtc            ,
        ISERDES_BITSLIP         => iserdes_bitslip          ,
        ISERDES_DATAOUT         => iserdes_dataout          ,

        -- wordalign controls
        BITSLIP                 => bitslip                  ,
        BITSLIP_RESET           => bitslip_reset            ,
        CONCATINATED_VALID      => concatinated_valid       ,
        CONCATINATED_DATA       => concatinated_data        ,

        --options
        CONCAT_MODE             => '0'                      ,
        DWCLK_SYNC_IN           => "00000000000"            ,
        DWCLK_SYNC_OUT          => DWCLK_SYNC               ,
        VTC_EN                  => VTC_EN                   ,
        
        --status
        SHIFT_STATUS            => open                     ,

        FIFO_EN                 => '0'                      ,
        FIFO_EMPTY              => open                     ,
        FIFO_AEMPTY             => open                     ,
        FIFO_RDEN               => '0'                      ,
        FIFO_DOUT               => open                     ,
        FIFO_RESET              => '1'                      ,
        FIFO_WREN               => '0'                      ,
        FIFO_DIN                => zeros                    ,

        ERROR                   => ERROR
       );

ls_clk_sequencer: iserdes_sequencer
  port map (
        CLOCK                       => CLKDIV(0)        ,
        RESET                       => CLKDIV_RESET(0)  ,

        START_TRAINING              => START_ALIGN      ,
        BUSY_TRAINING               => BUSY_ALIGN       ,

        INHIBIT_BITALIGN            => INHIBIT_BITALIGN ,

        START_BITALIGN              => start_bitalign   ,
        BUSY_BITALIGN               => busy_bitalign    ,

        START_WORDALIGN             => start_wordalign  ,
        BUSY_WORDALIGN              => busy_wordalign
    );

ls_clk_bitalign: iserdes_bitalign
  generic map (
        SERDES_DATAWIDTH        => SERDES_DATAWIDTH             ,
        TAP_COUNT_MAX           => TAP_COUNT_MAX                ,
        TAP_COUNT_BITS          => TAP_COUNT_BITS               ,
        CHANNEL_COUNT           => CHANNEL_COUNT                ,
        SERDES_COUNT            => SERDES_COUNT                 ,
        STABLE_COUNT            => STABLE_COUNT                 ,
        SAMPLE_COUNT            => SAMPLE_COUNT
  )
  port map (
        CLOCK                   => CLKDIV(0)                    ,
        RESET                   => CLKDIV_RESET(0)              ,

        --ctrl info
        START_ALIGN             => start_initialalign           ,
        BUSY_ALIGN              => busy_initialalign            ,
        MONITOR_START           => start_monitor                ,
        MONITOR_BUSY            => busy_monitor                 ,

        DATAWIDTH               => DATAWIDTH                    ,

        ALIGNMODE               => ALIGNMODE(2 downto 0)        ,
        AUTOALIGNCHANNEL        => AUTOALIGNCHANNEL             ,
        MANUAL_TAP              => MANUAL_TAP                   ,

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
        TAP_COUNT_IN            => tap_count_in_mux             ,
        TAP_DRIFT_IN            => tap_drift_in_mux             ,
        TAP_DRIFT_OUT           => tap_drift_out_mux
       );                           

ls_clk_mux_bitalign: iserdes_mux_bitalign
  generic map(
        SERDES_DATAWIDTH            => SERDES_DATAWIDTH             ,
        CHANNEL_COUNT               => CHANNEL_COUNT                ,
        SERDES_COUNT                => SERDES_COUNT                 ,
        TAP_COUNT_BITS              => TAP_COUNT_BITS               ,
        NROF_CONN                   => 1
       )
  port map (
        CLOCK                       => CLKDIV(0)                    ,
        RESET                       => CLKDIV_RESET(0)              ,

        MONITOR_ENABLE              => ALIGNMODE(4)                 ,
        START_BITALIGN              => start_bitalign               ,
        BUSY_BITALIGN               => busy_bitalign                ,

        START_INITIALALIGN          => start_initialalign           ,
        BUSY_INITIALALIGN           => busy_initialalign            ,

        START_MONITOR               => start_monitor                ,
        BUSY_MONITOR                => busy_monitor                 ,

        ALIGNMODE                   => ALIGNMODE(3)                 ,
        ALIGNCHANNEL                => "00000000"                   ,

        ENABLE_TRAINING(0)          => ENABLE_TRAINING              ,

        --muxed io
        IODELAY_ISERDES_RESET_mux   => iodelay_iserdes_reset_mux    ,
        IODELAY_INC_mux             => iodelay_inc_mux              ,
        IODELAY_CE_mux              => iodelay_ce_mux               ,
        IODELAY_ENVTC_mux           => iodelay_envtc_mux            ,
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
        TAP_DRIFT_OUT_mux           => tap_drift_out_mux            ,
        TAP_DRIFT_IN_mux            => tap_drift_in_mux             ,
        TAP_COUNT_IN_mux            => tap_count_in_mux             ,

        -- all io
        IODELAY_ISERDES_RESET_all   => iodelay_iserdes_reset        ,
        IODELAY_INC_all             => iodelay_inc                  ,
        IODELAY_CE_all              => iodelay_ce                   ,
        IODELAY_ENVTC_all           => iodelay_envtc                ,
        ISERDES_BITSLIP_all         => iserdes_bitslip              ,
        ISERDES_DATAOUT_all         => iserdes_dataout              ,

        --all status info
        EDGE_DETECT_all(0)          => EDGE_DETECT                  ,
        STABLE_DETECT_all(0)        => STABLE_DETECT                ,
        FIRST_EDGE_FOUND_all(0)     => FIRST_EDGE_FOUND             ,
        SECOND_EDGE_FOUND_all(0)    => SECOND_EDGE_FOUND            ,
        NROF_RETRIES_all            => NROF_RETRIES                 ,
        TAP_SETTING_all             => TAP_SETTING                  ,
        WINDOW_WIDTH_all            => WINDOW_WIDTH                 ,
        TAP_DRIFT_OUT_all           => tap_drift_all                ,
        TAP_DRIFT_IN_all            => tap_drift_all
    );

TAP_DRIFT <= tap_drift_all;

ls_clk_wordalign: iserdes_wordalign
  generic map (
        MAX_DATAWIDTH               => MAX_DATAWIDTH                ,
        CHANNEL_COUNT               => CHANNEL_COUNT
  )
  port map (
        CLOCK                       => CLKDIV(0)                    ,
        RESET                       => CLKDIV_RESET(0)              ,

        DATAWIDTH                   => DATAWIDTH                    ,

        WORDALIGN_START             => start_wordalign              ,
        WORDALIGN_BUSY              => busy_wordalign               ,

        AUTOALIGNCHANNEL            => AUTOALIGNCHANNEL             ,
        TRAINING                    => training                     ,

        BITSLIP_RESET               => bitslip_reset                ,
        BITSLIP                     => bitslip                      ,
        CONCATINATED_VALID          => concatinated_valid           ,
        CONCATINATED_DATA           => concatinated_data            ,

        -- status info
        WORD_ALIGN                  => WORD_ALIGN                   ,
        SLIP_COUNT                  => SLIP_COUNT
  );

gen_max_datawidth_18: if MAX_DATAWIDTH = 18 generate
    training <= "111111111000000000" when DATAWIDTH = 18 else
                "111111110000000000" when DATAWIDTH = 16 else
                "111111100000000000" when DATAWIDTH = 14 else
                "111111000000000000" when DATAWIDTH = 12 else
                "111110000000000000" when DATAWIDTH = 10 else
                "111100000000000000" when DATAWIDTH = 8 else
                "111000000000000000" when DATAWIDTH = 6 else
                "111111111000000000";
end generate;

gen_max_datawidth_16: if MAX_DATAWIDTH = 16 generate
    training <= "1111111100000000" when DATAWIDTH = 16 else
                "1111111000000000" when DATAWIDTH = 14 else
                "1111110000000000" when DATAWIDTH = 12 else
                "1111100000000000" when DATAWIDTH = 10 else
                "1111000000000000" when DATAWIDTH = 8 else
                "1110000000000000" when DATAWIDTH = 6 else
                "1111111100000000";
end generate;

gen_max_datawidth_14: if MAX_DATAWIDTH = 14 generate
    training <= "11111110000000" when DATAWIDTH = 14 else
                "11111100000000" when DATAWIDTH = 12 else
                "11111000000000" when DATAWIDTH = 10 else
                "11110000000000" when DATAWIDTH = 8 else
                "11100000000000" when DATAWIDTH = 6 else
                "11111110000000";
end generate;

gen_max_datawidth_12: if MAX_DATAWIDTH = 12 generate
    training <= "111111000000" when DATAWIDTH = 12 else
                "111110000000" when DATAWIDTH = 10 else
                "111100000000" when DATAWIDTH = 8 else
                "111000000000" when DATAWIDTH = 6 else
                "111111000000";
end generate;

gen_max_datawidth_10: if MAX_DATAWIDTH = 10 generate
    training <= "1111100000" when DATAWIDTH = 10 else
                "1111000000" when DATAWIDTH = 8 else
                "1110000000" when DATAWIDTH = 6 else
                "1111100000";
end generate;

gen_max_datawidth_8: if MAX_DATAWIDTH = 8 generate
    training <= "11110000" when DATAWIDTH = 8 else
                "11100000" when DATAWIDTH = 6 else
                "11110000";
end generate;

gen_max_datawidth_6: if MAX_DATAWIDTH = 6 generate
    training <= "111000";
end generate;

end rtl;