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
use ieee.std_logic_signed.all;
--xilinx:
---------
library unisim;
use unisim.vcomponents.all;
-----------------------
-- ENTITY DEFINITION --
-----------------------
entity iserdes_core is
  generic(
       SERDES_DATAWIDTH : integer := 6;
       SERDES_COUNT     : integer := 2;
       IDELAY_COUNT     : integer := 1;
       DATA_RATE        : string  := "DDR"; -- DDR/SDR
       DIFF_TERM        : boolean := TRUE;
       INVERT_OUTPUT    : boolean := FALSE;
       INVERSE_BITORDER : boolean := FALSE;
       LOW_PWR          : boolean := FALSE;
       C_FAMILY         : string  := "VIRTEX6";
       REFCLK_F         : real    := 200.0;
       C_CALWIDTH       : integer := 5
  );
  port (
        CLOCK                   : in    std_logic; --system clock, sync to local clock
        RESET                   : in    std_logic;

        -- Data IO
        -- clk src can be internal or external
        CLK                     : in    std_logic; -- high speed serial clock, either internal/external source,
        CLKb                    : in    std_logic; -- can come from DCM/PLL, IBUF, BUFIO


        CLKDIV                  : in    std_logic; -- parallel clock, derived from CLK using DCM/PLL or BUFR
                                                   -- can be same as clock/appclock in synchronous systems

        -- differential data input -> from outside, necesarry buffer is present in this file
        SDATAP                  : in    std_logic;
        SDATAN                  : in    std_logic;

        SDATA_MON               : out   std_logic;

        -- iodelay preload value, used for calibration of propagation delays and lengtmatchings
        -- can be set individually but will most likely have the same setting
        IODELAY_CAL             : in    std_logic_vector((SERDES_COUNT*C_CALWIDTH)-1 downto 0);

        --Ctrl IO, all controls should run on CLKDIV/parallelclk
        IODELAY_ISERDES_RESET   : in    std_logic_vector(SERDES_COUNT-1 downto 0);

        -- iodelay control
        IODELAY_INC             : in    std_logic_vector(SERDES_COUNT-1 downto 0);
        IODELAY_CE              : in    std_logic_vector(SERDES_COUNT-1 downto 0);
        IODELAY_ENVTC           : in    std_logic_vector(SERDES_COUNT-1 downto 0);

        VTC_EN                  : in    std_logic;
        
        -- iserdes_nodelay control
        ISERDES_BITSLIP         : in    std_logic_vector(SERDES_COUNT-1 downto 0);
        ISERDES_DATAOUT         : out   std_logic_vector((SERDES_COUNT*SERDES_DATAWIDTH)-1 downto 0)
       );
end iserdes_core;

architecture rtl of iserdes_core is

signal SerialBuf            : std_logic_vector(SERDES_COUNT-1 downto 0) := (others => '0');
signal SerialIn             : std_logic_vector(SERDES_COUNT-1 downto 0) := (others => '0');
signal SerialIoDelayOut     : std_logic_vector(SERDES_COUNT-1 downto 0) := (others => '0');
--only used for ultrascale cascading
signal SerialIoDelayOut2    : std_logic_vector(SERDES_COUNT-1 downto 0) := (others => '0');
signal SerialIoDelayOut3    : std_logic_vector(SERDES_COUNT-1 downto 0) := (others => '0');
signal SerialIoDelayOut4    : std_logic_vector(SERDES_COUNT-1 downto 0) := (others => '0');
signal SerialIoDelayOut5    : std_logic_vector(SERDES_COUNT-1 downto 0) := (others => '0');
signal SerialIoDelayOut6    : std_logic_vector(SERDES_COUNT-1 downto 0) := (others => '0');

signal SerialIoDelayOutFinal: std_logic_vector(SERDES_COUNT-1 downto 0) := (others => '0');


signal SDataMon             : std_logic_vector(SERDES_COUNT-1 downto 0) := (others => '0');

constant zero               : std_logic := '0';
constant one                : std_logic := '1';

constant zeros              : std_logic_vector(31 downto 0) := X"00000000";

signal MASTER_DATA          : std_logic_vector((6*SERDES_COUNT)-1 downto 0) := (others => '0');
signal SLAVE_DATA           : std_logic_vector((6*SERDES_COUNT)-1 downto 0) := (others => '0');

signal SHIFT_TO_SLAVE       : std_logic_vector((2*SERDES_COUNT)-1 downto 0) := (others => '0');

signal ISERDES_DATA         : std_logic_vector((SERDES_COUNT*SERDES_DATAWIDTH)-1 downto 0) := (others => '0');

signal CLKb_self            : std_logic := '0';

signal iodelay_tapsetting   : std_logic_vector((5*SERDES_COUNT)-1 downto 0) := (others => '0');

signal cntvalueout          : std_logic_vector((9*SERDES_COUNT)-1 downto 0) := (others => '0');

signal iodelay_envtc_and    : std_logic_vector(SERDES_COUNT-1 downto 0) := (others => '1');

alias sd1                   : std_logic_vector(5 downto 0) is MASTER_DATA(5 downto 0);
alias sd2                   : std_logic_vector(5 downto 0) is MASTER_DATA(11 downto 6);

attribute keep : string;
attribute keep of iodelay_tapsetting : signal is "TRUE";

begin

--inverted input of CLK should be made here for correct clk routing
CLKb_self  <= not CLK;

gen_1_serdes: if SERDES_COUNT = 1 generate
    IBUFDS_inst : IBUFDS
      generic map (
        DIFF_TERM => DIFF_TERM, -- Differential Termination
        IBUF_LOW_PWR => LOW_PWR, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
        IOSTANDARD => "DEFAULT")
      port map (
        O => SerialBuf(0), -- Buffer output
        I => SDATAP, -- Diff_p buffer input (connect directly to top-level port)
        IB => SDATAN -- Diff_n buffer input (connect directly to top-level port)
      );
    SerialIn(0) <= SerialBuf(0);
end generate;

gen_2_serdes: if SERDES_COUNT > 1 generate
    IBUFDS_DIFF_OUT_inst : IBUFDS_DIFF_OUT
      generic map (
        DIFF_TERM => DIFF_TERM, -- Differential Termination
        IBUF_LOW_PWR => LOW_PWR, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
        IOSTANDARD => "DEFAULT") -- Specify the input I/O standard
      port map (
        O => SerialBuf(0), -- Buffer diff_p output
        OB => SerialBuf(1), -- Buffer diff_n output
        I => SDATAP, -- Diff_p buffer input (connect directly to top-level port)
        IB => SDATAN -- Diff_n buffer input (connect directly to top-level port)
      );
    SerialIn(0) <= SerialBuf(0);
    gen_others: if (C_FAMILY = "VIRTEX5" or C_FAMILY = "VIRTEX6" or C_FAMILY = "7SERIES") generate
        SerialIn(1) <= not SerialBuf(1);
    end generate;
    --FIXME: possibbly this is a Vivado issue, and it will not work for 7-series either
    -- the inversion for ultrascale is done at the parallel side
    gen_ultrascale: if (C_FAMILY = "ULTRASCALE") generate
        SerialIn(1) <= SerialBuf(1); 
    end generate;
end generate;

--SDATA_MON <= SerialIn(0);

--IDELAY GENERATION
--virtex5
gen_virtex5_idelay: if (C_FAMILY = "VIRTEX5") generate

    --no support for precalibration
    iodelay_tapsetting <= (others => '0');

    gen_serdes_channels: for i in 0 to SERDES_COUNT-1 generate
        IODELAY_inst : IODELAY
          generic map (
            DELAY_SRC                   => "I",
                                        -- Specify which input port to be used
                                        -- "I"=IDATAIN, "O"=ODATAIN, "DATAIN"=DATAIN, "IO"=Bi-directional
            HIGH_PERFORMANCE_MODE       => TRUE,
                                        -- TRUE specifies lower jitter
                                        -- at expense of more power
            IDELAY_TYPE                 => "VARIABLE",
                                        -- "DEFAULT", "FIXED" or "VARIABLE"
            IDELAY_VALUE                => 0,
                                        -- 0 to 63 tap values
            ODELAY_VALUE                => 0,
                                        -- 0 to 63 tap values
            REFCLK_FREQUENCY            => REFCLK_F,
                                        -- Frequency used for IDELAYCTRL
                                        -- 175.0 to 225.0
            SIGNAL_PATTERN              => "DATA"
                                        -- Input signal type, "CLOCK" or "DATA"
          )
          port map (
            DATAOUT                     => SerialIoDelayOut(i)      ,    -- 1-bit delayed data output
            C                           => CLKDIV                   ,    -- 1-bit clock input
            CE                          => IODELAY_CE(i)            ,    -- 1-bit clock enable input
            DATAIN                      => zero                     ,    -- 1-bit internal data input
            IDATAIN                     => SerialIn(i)              ,    -- 1-bit input data input (connect to port)
            INC                         => IODELAY_INC(i)           ,    -- 1-bit increment/decrement input
            ODATAIN                     => zero                     ,    -- 1-bit output data input
            RST                         => IODELAY_ISERDES_RESET(i) ,    -- 1-bit active high, synch reset input
            T                           => one                   -- 1-bit 3-state control input
          );

        gen_one_idelay: if (IDELAY_COUNT = 1) generate
            SerialIoDelayOutFinal <= SerialIoDelayOut;
        end generate;

        gen_two_idelay: if (IDELAY_COUNT > 1) generate
            --FIXME:
            -- both idelays are incremented in parallel, giving less granularity and a tap size of 78*2 = 156 ps
            -- calibration is only applied to the first delay block though

            IODELAY_inst : IODELAY
              generic map (
                DELAY_SRC                   => "DATAIN",
                                            -- Specify which input port to be used
                                            -- "I"=IDATAIN, "O"=ODATAIN, "DATAIN"=DATAIN, "IO"=Bi-directional
                HIGH_PERFORMANCE_MODE       => TRUE,
                                            -- TRUE specifies lower jitter
                                            -- at expense of more power
                IDELAY_TYPE                 => "VARIABLE",
                                            -- "DEFAULT", "FIXED" or "VARIABLE"
                IDELAY_VALUE                => 0,
                                            -- 0 to 63 tap values
                ODELAY_VALUE                => 0,
                                            -- 0 to 63 tap values
                REFCLK_FREQUENCY            => REFCLK_F,
                                            -- Frequency used for IDELAYCTRL
                                            -- 175.0 to 225.0
                SIGNAL_PATTERN              => "DATA"
                                            -- Input signal type, "CLOCK" or "DATA"
              )
              port map (
                DATAOUT                     => SerialIoDelayOutFinal(i)     ,    -- 1-bit delayed data output
                C                           => CLKDIV                   ,    -- 1-bit clock input
                CE                          => IODELAY_CE(i)            ,    -- 1-bit clock enable input
                DATAIN                      => SerialIoDelayOut(i)      ,    -- 1-bit internal data input
                IDATAIN                     => zero                     ,    -- 1-bit input data input (connect to port)
                INC                         => IODELAY_INC(i)           ,    -- 1-bit increment/decrement input
                ODATAIN                     => zero                     ,    -- 1-bit output data input
                RST                         => IODELAY_ISERDES_RESET(i) ,    -- 1-bit active high, synch reset input
                T                           => one                   -- 1-bit 3-state control input
              );
        end generate;
    end generate;
end generate;

--virtex6
gen_virtex6_idelay: if (C_FAMILY = "VIRTEX6") generate
    gen_serdes_channels: for i in 0 to SERDES_COUNT-1 generate
        IODELAYE1_inst : IODELAYE1
          generic map (
            CINVCTRL_SEL                => FALSE,           -- Enable dynamic clock inversion ("TRUE"/"FALSE")
            DELAY_SRC                   => "I",             -- Delay input ("I", "CLKIN", "DATAIN", "IO", "O")
            HIGH_PERFORMANCE_MODE       => TRUE,            -- Reduced jitter ("TRUE"), Reduced power ("FALSE")
            IDELAY_TYPE                 => "VAR_LOADABLE",  -- "DEFAULT", "FIXED", "VARIABLE", or "VAR_LOADABLE"
            IDELAY_VALUE                => 0,               -- Input delay tap setting (0-32)
            ODELAY_TYPE                 => "FIXED",         -- "FIXED", "VARIABLE", or "VAR_LOADABLE"
            ODELAY_VALUE                => 0,               -- Output delay tap setting (0-32)
            REFCLK_FREQUENCY            => REFCLK_F,        -- IDELAYCTRL clock input frequency in MHz
            SIGNAL_PATTERN              => "DATA"           -- "DATA" or "CLOCK" input signal
          )
          port map (
            CNTVALUEOUT                 => iodelay_tapsetting((i*5)+4 downto (i*5)), -- 5-bit output - Counter value for monitoring purpose
            DATAOUT                     => SerialIoDelayOut(i)      , -- 1-bit output - Delayed data output
            C                           => CLKDIV                   , -- 1-bit input - Clock input
            CE                          => IODELAY_CE(i)            , -- 1-bit input - Active high enable increment/decrement function
            CINVCTRL                    => zero                     , -- 1-bit input - Dynamically inverts the Clock (C) polarity
            CLKIN                       => CLKDIV                   , -- 1-bit input - Clock Access into the IODELAY
            CNTVALUEIN                  => IODELAY_CAL((C_CALWIDTH*i)+(C_CALWIDTH-1) downto (C_CALWIDTH*i)+(C_CALWIDTH-5)), -- 5-bit input - Counter value for loadable counter application
            DATAIN                      => zero                     , -- 1-bit input - Internal delay data
            IDATAIN                     => SerialIn(i)              , -- 1-bit input - Delay data input
            INC                         => IODELAY_INC(i)           , -- 1-bit input - Increment / Decrement tap delay
            ODATAIN                     => zero                     , -- 1-bit input - Data input for the output datapath from the device
            RST                         => IODELAY_ISERDES_RESET(i) , -- 1-bit input - Active high, synchronous reset, resets delay chain to IDELAY_VALUE/ODELAY_VALUE tap. If no value is specified, the default is 0.
            T                           => one                        -- 1-bit input - 3-state input control. Tie high for input-only or internal delay or
                                                                      -- tie low for output only.
        );

        gen_one_idelay: if (IDELAY_COUNT = 1) generate
            --placeholder for multiple IDELAY elements
            SerialIoDelayOutFinal <= SerialIoDelayOut;
        end generate;

        gen_two_idelay: if (IDELAY_COUNT > 1) generate
            --FIXME:
            -- both idelays are incremented in parallel, giving less granularity and a tap size of 78*2 = 156 ps
            -- calibration is only applied to the first delay block though

            IODELAYE1_inst : IODELAYE1
              generic map (
                CINVCTRL_SEL                => FALSE,           -- Enable dynamic clock inversion ("TRUE"/"FALSE")
                DELAY_SRC                   => "DATAIN",        -- Delay input ("I", "CLKIN", "DATAIN", "IO", "O")
                HIGH_PERFORMANCE_MODE       => TRUE,            -- Reduced jitter ("TRUE"), Reduced power ("FALSE")
                IDELAY_TYPE                 => "VARIABLE",      -- "DEFAULT", "FIXED", "VARIABLE", or "VAR_LOADABLE"
                IDELAY_VALUE                => 0,               -- Input delay tap setting (0-32)
                ODELAY_TYPE                 => "FIXED",         -- "FIXED", "VARIABLE", or "VAR_LOADABLE"
                ODELAY_VALUE                => 0,               -- Output delay tap setting (0-32)
                REFCLK_FREQUENCY            => REFCLK_F,        -- IDELAYCTRL clock input frequency in MHz
                SIGNAL_PATTERN              => "DATA"           -- "DATA" or "CLOCK" input signal
              )
              port map (
                CNTVALUEOUT                 => open                     , -- 5-bit output - Counter value for monitoring purpose
                DATAOUT                     => SerialIoDelayOutFinal(i)     , -- 1-bit output - Delayed data output
                C                           => CLKDIV                   , -- 1-bit input - Clock input
                CE                          => IODELAY_CE(i)            , -- 1-bit input - Active high enable increment/decrement function
                CINVCTRL                    => zero                     , -- 1-bit input - Dynamically inverts the Clock (C) polarity
                CLKIN                       => CLKDIV                   , -- 1-bit input - Clock Access into the IODELAY
                CNTVALUEIN                  => zeros(4 downto 0)        , -- 5-bit input - Counter value for loadable counter application
                DATAIN                      => SerialIoDelayOut(i)      , -- 1-bit input - Internal delay data
                IDATAIN                     => zero                     , -- 1-bit input - Delay data input
                INC                         => IODELAY_INC(i)           , -- 1-bit input - Increment / Decrement tap delay
                ODATAIN                     => zero                     , -- 1-bit input - Data input for the output datapath from the device
                RST                         => IODELAY_ISERDES_RESET(i) , -- 1-bit input - Active high, synchronous reset, resets delay chain to IDELAY_VALUE/ODELAY_VALUE tap. If no value is specified, the default is 0.
                T                           => one                        -- 1-bit input - 3-state input control. Tie high for input-only or internal delay or
                                                                          -- tie low for output only.
            );
        end generate;
    end generate;
end generate;

--7series
gen_7series_idelay: if (C_FAMILY = "7SERIES") generate
    gen_serdes_channels: for i in 0 to SERDES_COUNT-1 generate
        IDELAYE2_inst : IDELAYE2
            generic map (
                CINVCTRL_SEL            => "FALSE",         -- Enable dynamic clock inversion (FALSE, TRUE)
                DELAY_SRC               => "IDATAIN",       -- Delay input (IDATAIN, DATAIN)
                HIGH_PERFORMANCE_MODE   => "TRUE",          -- Reduced jitter ("TRUE"), Reduced power ("FALSE")
                IDELAY_TYPE             => "VAR_LOAD",      -- FIXED, VARIABLE, VAR_LOAD, VAR_LOAD_PIPE
                IDELAY_VALUE            => 0,               -- Input delay tap setting (0-31)
                PIPE_SEL                => "FALSE",         -- Select pipelined mode, FALSE, TRUE
                REFCLK_FREQUENCY        => REFCLK_F,        -- IDELAYCTRL clock input frequency in MHz (190.0-210.0, 290.0-310.0).
                SIGNAL_PATTERN          => "DATA"           -- DATA, CLOCK input signal
            )
            port map (
                CNTVALUEOUT             => iodelay_tapsetting((i*5)+4 downto (i*5)), -- 5-bit output: Counter value output
                DATAOUT                 => SerialIoDelayOut(i)      , -- 1-bit output: Delayed data output
                C                       => CLKDIV                   , -- 1-bit input: Clock input
                CE                      => IODELAY_CE(i)            , -- 1-bit input: Active high enable increment/decrement input
                CINVCTRL                => zero                     , -- 1-bit input: Dynamic clock inversion input
                CNTVALUEIN              => IODELAY_CAL((C_CALWIDTH*i)+(C_CALWIDTH-1) downto (C_CALWIDTH*i)+(C_CALWIDTH-5)), -- 5-bit input: Counter value input
                DATAIN                  => zero, -- 1-bit input: Internal delay data input
                IDATAIN                 => SerialIn(i), -- 1-bit input: Data input from the I/O
                INC                     => IODELAY_INC(i), -- 1-bit input: Increment / Decrement tap delay input
                LD                      => zero, -- 1-bit input: Load IDELAY_VALUE input
                LDPIPEEN                => zero, -- 1-bit input: Enable PIPELINE register to load data input
                REGRST                  => IODELAY_ISERDES_RESET(i) -- 1-bit input: Active-high reset tap-delay input
            );

        gen_one_idelay: if (IDELAY_COUNT = 1) generate
            --placeholder for multiple IDELAY elements
            SerialIoDelayOutFinal <= SerialIoDelayOut;
        end generate;

        gen_two_idelay: if (IDELAY_COUNT > 1) generate
            --FIXME:
            -- both idelays are incremented in parallel, giving less granularity and a tap size of 78*2 = 156 ps
            -- calibration is only applied to the first delay block though
            IDELAYE2_inst : IDELAYE2
                generic map (
                    CINVCTRL_SEL            => "FALSE",         -- Enable dynamic clock inversion (FALSE, TRUE)
                    DELAY_SRC               => "DATAIN",        -- Delay input (IDATAIN, DATAIN)
                    HIGH_PERFORMANCE_MODE   => "TRUE",          -- Reduced jitter ("TRUE"), Reduced power ("FALSE")
                    IDELAY_TYPE             => "VARIABLE",      -- FIXED, VARIABLE, VAR_LOAD, VAR_LOAD_PIPE
                    IDELAY_VALUE            => 0,               -- Input delay tap setting (0-31)
                    PIPE_SEL                => "FALSE",         -- Select pipelined mode, FALSE, TRUE
                    REFCLK_FREQUENCY        => REFCLK_F,        -- IDELAYCTRL clock input frequency in MHz (190.0-210.0, 290.0-310.0).
                    SIGNAL_PATTERN          => "DATA"           -- DATA, CLOCK input signal
                )
                port map (
                    CNTVALUEOUT             => open                     , -- 5-bit output: Counter value output
                    DATAOUT                 => SerialIoDelayOutFinal(i)     , -- 1-bit output: Delayed data output
                    C                       => CLKDIV                   , -- 1-bit input: Clock input
                    CE                      => IODELAY_CE(i)            , -- 1-bit input: Active high enable increment/decrement input
                    CINVCTRL                => zero                     , -- 1-bit input: Dynamic clock inversion input
                    CNTVALUEIN              => zeros(4 downto 0)        , -- 5-bit input: Counter value input
                    DATAIN                  => SerialIoDelayOut(i)      , -- 1-bit input: Internal delay data input
                    IDATAIN                 => zero                     , -- 1-bit input: Data input from the I/O
                    INC                     => IODELAY_INC(i)           , -- 1-bit input: Increment / Decrement tap delay input
                    LD                      => zero                     , -- 1-bit input: Load IDELAY_VALUE input
                    LDPIPEEN                => zero                     , -- 1-bit input: Enable PIPELINE register to load data input
                    REGRST                  => IODELAY_ISERDES_RESET(i) -- 1-bit input: Active-high reset tap-delay input
                );
        end generate;
    end generate;
end generate;

--ultrascale
gen_ultrascale_idelay: if (C_FAMILY = "ULTRASCALE") generate
    gen_serdes_channels: for i in 0 to SERDES_COUNT-1 generate
        iodelay_envtc_and(i) <= IODELAY_ENVTC(i) and VTC_EN;
        
        gen_one_idelay: if (IDELAY_COUNT = 1) generate
            IDELAYE3_inst : IDELAYE3
                generic map (
                    CASCADE                 => "NONE",          -- Cascade setting (MASTER, NONE, SLAVE_END, SLAVE_MIDDLE)
                    DELAY_FORMAT            => "COUNT",         -- Units of the DELAY_VALUE (COUNT, TIME)
                    DELAY_SRC               => "IDATAIN",       -- Delay input (DATAIN, IDATAIN)
                    DELAY_TYPE              => "VAR_LOAD",      -- Set the type of tap delay line (FIXED, VARIABLE, VAR_LOAD)
                    DELAY_VALUE             => 0,               -- Input delay value setting
                    IS_CLK_INVERTED         => '0',             -- Optional inversion for CLK
                    IS_RST_INVERTED         => '0',             -- Optional inversion for RST
                    REFCLK_FREQUENCY        => REFCLK_F,        -- IDELAYCTRL clock input frequency in MHz (200.0-2400.0)
                    UPDATE_MODE             => "ASYNC"              -- Determines when updates to the delay will take effect (ASYNC, MANUAL, SYNC)
                )
                port map (
                    CASC_OUT                => open                     , -- 1-bit output: Cascade delay output to ODELAY input cascade
                    CNTVALUEOUT             => cntvalueout(9*i+8 downto 9*i) , -- 9-bit output: Counter value output
                    --CNTVALUEOUT(8 downto 5) => open                     , -- 9-bit output: Counter value output
                    DATAOUT                 => SerialIoDelayOutFinal(i) , -- 1-bit output: Delayed data output
                    CASC_IN                 => zero                     , -- 1-bit input: Cascade delay input from slave ODELAY CASCADE_OUT
                    CASC_RETURN             => zero                     , -- 1-bit input: Cascade delay returning from slave ODELAY DATAOUT
                    CE                      => IODELAY_CE(i)            , -- 1-bit input: Active high enable increment/decrement input
                    CLK                     => CLKDIV, -- 1-bit input: Clock input
                    CNTVALUEIN(4 downto 0)  => IODELAY_CAL((C_CALWIDTH*i)+(C_CALWIDTH-1) downto (C_CALWIDTH*i)+(C_CALWIDTH-5)), -- 9-bit input: Counter value input
                    CNTVALUEIN(8 downto 5)  => zeros(8 downto C_CALWIDTH),
                    DATAIN                  => zero                     , -- 1-bit input: Data input from the logic
                    EN_VTC                  => iodelay_envtc_and(i)     , -- 1-bit input: Keep delay constant over VT
                    IDATAIN                 => SerialIn(i)              , -- 1-bit input: Data input from the IOBUF
                    INC                     => IODELAY_INC(i)           , -- 1-bit input: Increment / Decrement tap delay input
                    LOAD                    => zero                     , -- 1-bit input: Load DELAY_VALUE input
                    RST                     => IODELAY_ISERDES_RESET(i)   -- 1-bit input: Asynchronous Reset to the DELAY_VALUE
                );

            iodelay_tapsetting((i*5)+4 downto (i*5)) <= cntvalueout(9*i+4 downto 9*i);

            --placeholder for multiple IDELAY elements
            SerialIoDelayOut <= (others => '0');
        end generate;

        --supported options for more than 1 delay element in ultrascale architecture:
        --SERDES_COUNT          |  1  |   2
        --IDELAY_COUNT (MAX)    |  4  |   2
        --note: it is actually odelay and idelay elements that are used

        gen_two_idelay: if (IDELAY_COUNT = 2) generate
            --master idelay
            IDELAYE3_inst : IDELAYE3
                generic map (
                    CASCADE                 => "MASTER",        -- Cascade setting (MASTER, NONE, SLAVE_END, SLAVE_MIDDLE)
                    DELAY_FORMAT            => "COUNT",         -- Units of the DELAY_VALUE (COUNT, TIME)
                    DELAY_SRC               => "IDATAIN",       -- Delay input (DATAIN, IDATAIN)
                    DELAY_TYPE              => "VAR_LOAD",      -- Set the type of tap delay line (FIXED, VARIABLE, VAR_LOAD)
                    DELAY_VALUE             => 0,               -- Input delay value setting
                    IS_CLK_INVERTED         => '0',             -- Optional inversion for CLK
                    IS_RST_INVERTED         => '0',             -- Optional inversion for RST
                    REFCLK_FREQUENCY        => REFCLK_F,        -- IDELAYCTRL clock input frequency in MHz (200.0-2400.0)
                    UPDATE_MODE             => "ASYNC"          -- Determines when updates to the delay will take effect (ASYNC, MANUAL, SYNC)
                )
                port map (
                    CASC_OUT                => SerialIoDelayOut(i)      , -- 1-bit output: Cascade delay output to ODELAY input cascade
                    CNTVALUEOUT             => cntvalueout(9*i+8 downto 9*i) , -- 9-bit output: Counter value output
                    --CNTVALUEOUT(8 downto 5) => open                     , -- 9-bit output: Counter value output
                    DATAOUT                 => SerialIoDelayOutFinal(i) , -- 1-bit output: Delayed data output
                    CASC_IN                 => zero                     , -- 1-bit input: Cascade delay input from slave ODELAY CASCADE_OUT
                    CASC_RETURN             => SerialIoDelayOut2(i)     , -- 1-bit input: Cascade delay returning from slave ODELAY DATAOUT
                    CE                      => IODELAY_CE(i)            , -- 1-bit input: Active high enable increment/decrement input
                    CLK                     => CLKDIV                   , -- 1-bit input: Clock input
                    CNTVALUEIN              => zeros(8 downto 0)        , -- 9-bit input: Counter value input
                    DATAIN                  => zero                     , -- 1-bit input: Data input from the logic
                    EN_VTC                  => iodelay_envtc_and(i)     , -- 1-bit input: Keep delay constant over VT
                    IDATAIN                 => SerialIn(i)              , -- 1-bit input: Data input from the IOBUF
                    INC                     => IODELAY_INC(i)           , -- 1-bit input: Increment / Decrement tap delay input
                    LOAD                    => zero                     , -- 1-bit input: Load DELAY_VALUE input
                    RST                     => IODELAY_ISERDES_RESET(i)   -- 1-bit input: Asynchronous Reset to the DELAY_VALUE
                );

            --slave odelay (slave_end)
            ODELAYE3_inst : ODELAYE3
                generic map (
                    CASCADE                 => "SLAVE_END",     -- Cascade setting (MASTER, NONE, SLAVE_END, SLAVE_MIDDLE)
                    DELAY_FORMAT            => "COUNT",         -- (COUNT, TIME)
                    DELAY_TYPE              => "FIXED",         -- Set the type of tap delay line (FIXED, VARIABLE, VAR_LOAD)
                    DELAY_VALUE             => 0,               -- Output delay tap setting
                    IS_CLK_INVERTED         => '0',             -- Optional inversion for CLK
                    IS_RST_INVERTED         => '0',             -- Optional inversion for RST
                    REFCLK_FREQUENCY        => REFCLK_F,        -- IDELAYCTRL clock input frequency in MHz (200.0-2400.0).
                    UPDATE_MODE             => "ASYNC"          -- Determines when updates to the delay will take effect (ASYNC, MANUAL, SYNC)
                )
                port map (
                    CASC_OUT                => open                     , -- 1-bit output: Cascade delay output to IDELAY input cascade
                    CNTVALUEOUT             => open                     , -- 9-bit output: Counter value output
                    DATAOUT                 => SerialIoDelayOut2(i)     , -- 1-bit output: Delayed data from ODATAIN input port
                    CASC_IN                 => SerialIoDelayOut(i)      , -- 1-bit input: Cascade delay input from slave IDELAY CASCADE_OUT
                    CASC_RETURN             => zero                     , -- 1-bit input: Cascade delay returning from slave IDELAY DATAOUT
                    CE                      => IODELAY_CE(i)            , -- 1-bit input: Active high enable increment/decrement input
                    CLK                     => CLKDIV                   , -- 1-bit input: Clock input
                    CNTVALUEIN              => zeros(8 downto 0)        , -- 9-bit input: Counter value input
                    EN_VTC                  => iodelay_envtc_and(i)     , -- 1-bit input: Keep delay constant over VT
                    INC                     => IODELAY_INC(i)           , -- 1-bit input: Increment / Decrement tap delay input
                    LOAD                    => zero                     , -- 1-bit input: Load DELAY_VALUE input
                    ODATAIN                 => zero                     , -- 1-bit input: Data input
                    RST                     => IODELAY_ISERDES_RESET(i)   -- 1-bit input: Asynchronous Reset to the DELAY_VALUE
                );

                iodelay_tapsetting((i*5)+4 downto (i*5)) <= cntvalueout(9*i+4 downto 9*i);
        end generate;

        gen_three_idelay: if (IDELAY_COUNT = 3) generate
            --master idelay
            IDELAYE3_inst : IDELAYE3
                generic map (
                    CASCADE                 => "MASTER",        -- Cascade setting (MASTER, NONE, SLAVE_END, SLAVE_MIDDLE)
                    DELAY_FORMAT            => "COUNT",         -- Units of the DELAY_VALUE (COUNT, TIME)
                    DELAY_SRC               => "IDATAIN",       -- Delay input (DATAIN, IDATAIN)
                    DELAY_TYPE              => "VAR_LOAD",      -- Set the type of tap delay line (FIXED, VARIABLE, VAR_LOAD)
                    DELAY_VALUE             => 0,               -- Input delay value setting
                    IS_CLK_INVERTED         => '0',             -- Optional inversion for CLK
                    IS_RST_INVERTED         => '0',             -- Optional inversion for RST
                    REFCLK_FREQUENCY        => REFCLK_F,        -- IDELAYCTRL clock input frequency in MHz (200.0-2400.0)
                    UPDATE_MODE             => "ASYNC"          -- Determines when updates to the delay will take effect (ASYNC, MANUAL, SYNC)
                )
                port map (
                    CASC_OUT                => SerialIoDelayOut(i)      , -- 1-bit output: Cascade delay output to ODELAY input cascade
                    CNTVALUEOUT             => cntvalueout(9*i+8 downto 9*i) , -- 9-bit output: Counter value output
                    --CNTVALUEOUT(8 downto 5) => open                     , -- 9-bit output: Counter value output
                    DATAOUT                 => SerialIoDelayOutFinal(i) , -- 1-bit output: Delayed data output
                    CASC_IN                 => zero                     , -- 1-bit input: Cascade delay input from slave ODELAY CASCADE_OUT
                    CASC_RETURN             => SerialIoDelayOut4(i)     , -- 1-bit input: Cascade delay returning from slave ODELAY DATAOUT
                    CE                      => IODELAY_CE(i)            , -- 1-bit input: Active high enable increment/decrement input
                    CLK                     => CLKDIV, -- 1-bit input: Clock input
                    CNTVALUEIN(4 downto 0) => IODELAY_CAL((C_CALWIDTH*i)+(C_CALWIDTH-1) downto (C_CALWIDTH*i)+(C_CALWIDTH-5)), -- 9-bit input: Counter value input
                    CNTVALUEIN(8 downto 5) => zeros(8 downto 5),
                    DATAIN                  => zero                     , -- 1-bit input: Data input from the logic
                    EN_VTC                  => iodelay_envtc_and(i)     , -- 1-bit input: Keep delay constant over VT
                    IDATAIN                 => SerialIn(i)              , -- 1-bit input: Data input from the IOBUF
                    INC                     => IODELAY_INC(i)           , -- 1-bit input: Increment / Decrement tap delay input
                    LOAD                    => zero                     , -- 1-bit input: Load DELAY_VALUE input
                    RST                     => IODELAY_ISERDES_RESET(i)   -- 1-bit input: Asynchronous Reset to the DELAY_VALUE
                );

            --slave odelay (slave_middle)
            ODELAYE3_inst : ODELAYE3
                generic map (
                    CASCADE                 => "SLAVE_MIDDLE",     -- Cascade setting (MASTER, NONE, SLAVE_END, SLAVE_MIDDLE)
                    DELAY_FORMAT            => "COUNT",         -- (COUNT, TIME)
                    DELAY_TYPE              => "FIXED",         -- Set the type of tap delay line (FIXED, VARIABLE, VAR_LOAD)
                    DELAY_VALUE             => 0,               -- Output delay tap setting
                    IS_CLK_INVERTED         => '0',             -- Optional inversion for CLK
                    IS_RST_INVERTED         => '0',             -- Optional inversion for RST
                    REFCLK_FREQUENCY        => REFCLK_F,        -- IDELAYCTRL clock input frequency in MHz (200.0-2400.0).
                    UPDATE_MODE             => "ASYNC"          -- Determines when updates to the delay will take effect (ASYNC, MANUAL, SYNC)
                )
                port map (
                    CASC_OUT                => SerialIoDelayOut2(i)     , -- 1-bit output: Cascade delay output to IDELAY input cascade
                    CNTVALUEOUT             => open                     , -- 9-bit output: Counter value output
                    DATAOUT                 => SerialIoDelayOut4(i)     , -- 1-bit output: Delayed data from ODATAIN input port
                    CASC_IN                 => SerialIoDelayOut(i)      , -- 1-bit input: Cascade delay input from slave IDELAY CASCADE_OUT
                    CASC_RETURN             => SerialIoDelayOut3(i)     , -- 1-bit input: Cascade delay returning from slave IDELAY DATAOUT
                    CE                      => IODELAY_CE(i)            , -- 1-bit input: Active high enable increment/decrement input
                    CLK                     => CLKDIV                   , -- 1-bit input: Clock input
                    CNTVALUEIN              => zeros(8 downto 0)        , -- 9-bit input: Counter value input
                    EN_VTC                  => iodelay_envtc_and(i)     , -- 1-bit input: Keep delay constant over VT
                    INC                     => IODELAY_INC(i)           , -- 1-bit input: Increment / Decrement tap delay input
                    LOAD                    => zero                     , -- 1-bit input: Load DELAY_VALUE input
                    ODATAIN                 => zero                     , -- 1-bit input: Data input
                    RST                     => IODELAY_ISERDES_RESET(i)   -- 1-bit input: Asynchronous Reset to the DELAY_VALUE
                );

            --slave idelay (slave_end)
            IDELAYE3_slave : IDELAYE3
                generic map (
                    CASCADE                 => "SLAVE_END",        -- Cascade setting (MASTER, NONE, SLAVE_END, SLAVE_MIDDLE)
                    DELAY_FORMAT            => "COUNT",         -- Units of the DELAY_VALUE (COUNT, TIME)
                    DELAY_SRC               => "IDATAIN",       -- Delay input (DATAIN, IDATAIN)
                    DELAY_TYPE              => "VAR_LOAD",      -- Set the type of tap delay line (FIXED, VARIABLE, VAR_LOAD)
                    DELAY_VALUE             => 0,               -- Input delay value setting
                    IS_CLK_INVERTED         => '0',             -- Optional inversion for CLK
                    IS_RST_INVERTED         => '0',             -- Optional inversion for RST
                    REFCLK_FREQUENCY        => REFCLK_F,        -- IDELAYCTRL clock input frequency in MHz (200.0-2400.0)
                    UPDATE_MODE             => "ASYNC"          -- Determines when updates to the delay will take effect (ASYNC, MANUAL, SYNC)
                )
                port map (
                    CASC_OUT                => SerialIoDelayOut3(i)     , -- 1-bit output: Cascade delay output to ODELAY input cascade
                    CNTVALUEOUT             => open                     , -- 9-bit output: Counter value output
                    DATAOUT                 => open                     , -- 1-bit output: Delayed data output
                    CASC_IN                 => SerialIoDelayOut2(i)     , -- 1-bit input: Cascade delay input from slave ODELAY CASCADE_OUT
                    CASC_RETURN             => zero                     , -- 1-bit input: Cascade delay returning from slave ODELAY DATAOUT
                    CE                      => IODELAY_CE(i)            , -- 1-bit input: Active high enable increment/decrement input
                    CLK                     => CLKDIV, -- 1-bit input: Clock input
                    CNTVALUEIN              => zeros(8 downto 0)        , -- 9-bit input: Counter value input
                    DATAIN                  => zero                     , -- 1-bit input: Data input from the logic
                    EN_VTC                  => iodelay_envtc_and(i)     , -- 1-bit input: Keep delay constant over VT
                    IDATAIN                 => zero                     , -- 1-bit input: Data input from the IOBUF
                    INC                     => IODELAY_INC(i)           , -- 1-bit input: Increment / Decrement tap delay input
                    LOAD                    => zero                     , -- 1-bit input: Load DELAY_VALUE input
                    RST                     => IODELAY_ISERDES_RESET(i)   -- 1-bit input: Asynchronous Reset to the DELAY_VALUE
                );

                iodelay_tapsetting((i*5)+4 downto (i*5)) <= cntvalueout(9*i+4 downto 9*i);
        end generate;

        gen_four_idelay: if (IDELAY_COUNT > 3) generate
            --master idelay
            IDELAYE3_inst : IDELAYE3
                generic map (
                    CASCADE                 => "MASTER",        -- Cascade setting (MASTER, NONE, SLAVE_END, SLAVE_MIDDLE)
                    DELAY_FORMAT            => "COUNT",         -- Units of the DELAY_VALUE (COUNT, TIME)
                    DELAY_SRC               => "IDATAIN",       -- Delay input (DATAIN, IDATAIN)
                    DELAY_TYPE              => "VAR_LOAD",      -- Set the type of tap delay line (FIXED, VARIABLE, VAR_LOAD)
                    DELAY_VALUE             => 0,               -- Input delay value setting
                    IS_CLK_INVERTED         => '0',             -- Optional inversion for CLK
                    IS_RST_INVERTED         => '0',             -- Optional inversion for RST
                    REFCLK_FREQUENCY        => REFCLK_F,        -- IDELAYCTRL clock input frequency in MHz (200.0-2400.0)
                    UPDATE_MODE             => "ASYNC"          -- Determines when updates to the delay will take effect (ASYNC, MANUAL, SYNC)
                )
                port map (
                    CASC_OUT                => SerialIoDelayOut(i)      , -- 1-bit output: Cascade delay output to ODELAY input cascade
                    CNTVALUEOUT             => cntvalueout(9*i+8 downto 9*i) , -- 9-bit output: Counter value output
                    --CNTVALUEOUT(8 downto 5) => open                     , -- 9-bit output: Counter value output
                    DATAOUT                 => SerialIoDelayOutFinal(i) , -- 1-bit output: Delayed data output
                    CASC_IN                 => zero                     , -- 1-bit input: Cascade delay input from slave ODELAY CASCADE_OUT
                    CASC_RETURN             => SerialIoDelayOut6(i)     , -- 1-bit input: Cascade delay returning from slave ODELAY DATAOUT
                    CE                      => IODELAY_CE(i)            , -- 1-bit input: Active high enable increment/decrement input
                    CLK                     => CLKDIV, -- 1-bit input: Clock input
                    CNTVALUEIN(4 downto 0)  => IODELAY_CAL((C_CALWIDTH*i)+(C_CALWIDTH-1) downto (C_CALWIDTH*i)+(C_CALWIDTH-5)), -- 9-bit input: Counter value input
                    CNTVALUEIN(8 downto 5)  => zeros(8 downto C_CALWIDTH),
                    DATAIN                  => zero                     , -- 1-bit input: Data input from the logic
                    EN_VTC                  => iodelay_envtc_and(i)     , -- 1-bit input: Keep delay constant over VT
                    IDATAIN                 => SerialIn(i)              , -- 1-bit input: Data input from the IOBUF
                    INC                     => IODELAY_INC(i)           , -- 1-bit input: Increment / Decrement tap delay input
                    LOAD                    => zero                     , -- 1-bit input: Load DELAY_VALUE input
                    RST                     => IODELAY_ISERDES_RESET(i)   -- 1-bit input: Asynchronous Reset to the DELAY_VALUE
                );

            --slave odelay (slave_middle)
            ODELAYE3_inst : ODELAYE3
                generic map (
                    CASCADE                 => "SLAVE_MIDDLE",     -- Cascade setting (MASTER, NONE, SLAVE_END, SLAVE_MIDDLE)
                    DELAY_FORMAT            => "COUNT",         -- (COUNT, TIME)
                    DELAY_TYPE              => "FIXED",         -- Set the type of tap delay line (FIXED, VARIABLE, VAR_LOAD)
                    DELAY_VALUE             => 0,               -- Output delay tap setting
                    IS_CLK_INVERTED         => '0',             -- Optional inversion for CLK
                    IS_RST_INVERTED         => '0',             -- Optional inversion for RST
                    REFCLK_FREQUENCY        => REFCLK_F,        -- IDELAYCTRL clock input frequency in MHz (200.0-2400.0).
                    UPDATE_MODE             => "ASYNC"          -- Determines when updates to the delay will take effect (ASYNC, MANUAL, SYNC)
                )
                port map (
                    CASC_OUT                => SerialIoDelayOut2(i)     , -- 1-bit output: Cascade delay output to IDELAY input cascade
                    CNTVALUEOUT             => open                     , -- 9-bit output: Counter value output
                    DATAOUT                 => SerialIoDelayOut6(i)     , -- 1-bit output: Delayed data from ODATAIN input port
                    CASC_IN                 => SerialIoDelayOut(i)      , -- 1-bit input: Cascade delay input from slave IDELAY CASCADE_OUT
                    CASC_RETURN             => SerialIoDelayOut5(i)     , -- 1-bit input: Cascade delay returning from slave IDELAY DATAOUT
                    CE                      => IODELAY_CE(i)            , -- 1-bit input: Active high enable increment/decrement input
                    CLK                     => CLKDIV                   , -- 1-bit input: Clock input
                    CNTVALUEIN              => zeros(8 downto 0)        , -- 9-bit input: Counter value input
                    EN_VTC                  => iodelay_envtc_and(i)     , -- 1-bit input: Keep delay constant over VT
                    INC                     => IODELAY_INC(i)           , -- 1-bit input: Increment / Decrement tap delay input
                    LOAD                    => zero                     , -- 1-bit input: Load DELAY_VALUE input
                    ODATAIN                 => zero                     , -- 1-bit input: Data input
                    RST                     => IODELAY_ISERDES_RESET(i)   -- 1-bit input: Asynchronous Reset to the DELAY_VALUE
                );

            --slave idelay (slave_middle)
            IDELAYE3_slave : IDELAYE3
                generic map (
                    CASCADE                 => "SLAVE_MIDDLE",        -- Cascade setting (MASTER, NONE, SLAVE_END, SLAVE_MIDDLE)
                    DELAY_FORMAT            => "COUNT",         -- Units of the DELAY_VALUE (COUNT, TIME)
                    DELAY_SRC               => "IDATAIN",       -- Delay input (DATAIN, IDATAIN)
                    DELAY_TYPE              => "VAR_LOAD",      -- Set the type of tap delay line (FIXED, VARIABLE, VAR_LOAD)
                    DELAY_VALUE             => 0,               -- Input delay value setting
                    IS_CLK_INVERTED         => '0',             -- Optional inversion for CLK
                    IS_RST_INVERTED         => '0',             -- Optional inversion for RST
                    REFCLK_FREQUENCY        => REFCLK_F,        -- IDELAYCTRL clock input frequency in MHz (200.0-2400.0)
                    UPDATE_MODE             => "ASYNC"          -- Determines when updates to the delay will take effect (ASYNC, MANUAL, SYNC)
                )
                port map (
                    CASC_OUT                => SerialIoDelayOut3(i)     , -- 1-bit output: Cascade delay output to ODELAY input cascade
                    CNTVALUEOUT             => open                     , -- 9-bit output: Counter value output
                    DATAOUT                 => SerialIoDelayOut5(i)     , -- 1-bit output: Delayed data output
                    CASC_IN                 => SerialIoDelayOut2(i)     , -- 1-bit input: Cascade delay input from slave ODELAY CASCADE_OUT
                    CASC_RETURN             => SerialIoDelayOut4(i)     , -- 1-bit input: Cascade delay returning from slave ODELAY DATAOUT
                    CE                      => IODELAY_CE(i)            , -- 1-bit input: Active high enable increment/decrement input
                    CLK                     => CLKDIV, -- 1-bit input: Clock input
                    CNTVALUEIN              => zeros(8 downto 0)        , -- 9-bit input: Counter value input
                    DATAIN                  => zero                     , -- 1-bit input: Data input from the logic
                    EN_VTC                  => iodelay_envtc_and(i)     , -- 1-bit input: Keep delay constant over VT
                    IDATAIN                 => zero                     , -- 1-bit input: Data input from the IOBUF
                    INC                     => IODELAY_INC(i)           , -- 1-bit input: Increment / Decrement tap delay input
                    LOAD                    => zero                     , -- 1-bit input: Load DELAY_VALUE input
                    RST                     => IODELAY_ISERDES_RESET(i)   -- 1-bit input: Asynchronous Reset to the DELAY_VALUE
                );

            --slave odelay (slave_end)
            ODELAYE3_slave : ODELAYE3
                generic map (
                    CASCADE                 => "SLAVE_END",     -- Cascade setting (MASTER, NONE, SLAVE_END, SLAVE_MIDDLE)
                    DELAY_FORMAT            => "COUNT",         -- (COUNT, TIME)
                    DELAY_TYPE              => "FIXED",         -- Set the type of tap delay line (FIXED, VARIABLE, VAR_LOAD)
                    DELAY_VALUE             => 0,               -- Output delay tap setting
                    IS_CLK_INVERTED         => '0',             -- Optional inversion for CLK
                    IS_RST_INVERTED         => '0',             -- Optional inversion for RST
                    REFCLK_FREQUENCY        => REFCLK_F,        -- IDELAYCTRL clock input frequency in MHz (200.0-2400.0).
                    UPDATE_MODE             => "ASYNC"          -- Determines when updates to the delay will take effect (ASYNC, MANUAL, SYNC)
                )
                port map (
                    CASC_OUT                => open                     , -- 1-bit output: Cascade delay output to IDELAY input cascade
                    CNTVALUEOUT             => open                     , -- 9-bit output: Counter value output
                    DATAOUT                 => SerialIoDelayOut4(i)     , -- 1-bit output: Delayed data from ODATAIN input port
                    CASC_IN                 => SerialIoDelayOut3(i)     , -- 1-bit input: Cascade delay input from slave IDELAY CASCADE_OUT
                    CASC_RETURN             => zero                     , -- 1-bit input: Cascade delay returning from slave IDELAY DATAOUT
                    CE                      => IODELAY_CE(i)            , -- 1-bit input: Active high enable increment/decrement input
                    CLK                     => CLKDIV                   , -- 1-bit input: Clock input
                    CNTVALUEIN              => zeros(8 downto 0)        , -- 9-bit input: Counter value input
                    EN_VTC                  => iodelay_envtc_and(i)     , -- 1-bit input: Keep delay constant over VT
                    INC                     => IODELAY_INC(i)           , -- 1-bit input: Increment / Decrement tap delay input
                    LOAD                    => zero                     , -- 1-bit input: Load DELAY_VALUE input
                    ODATAIN                 => zero                     , -- 1-bit input: Data input
                    RST                     => IODELAY_ISERDES_RESET(i)   -- 1-bit input: Asynchronous Reset to the DELAY_VALUE
                );

                iodelay_tapsetting((i*5)+4 downto (i*5)) <= cntvalueout(9*i+4 downto 9*i);
        end generate;
    end generate;
end generate;

-- iserdes
-- datawidth
-- can be 4, 6, 8 or 10 for DDR, can be 2, 3, 4, 5, 6, 7, or 8 for SDR.
--virtex5
gen_virtex5_iserdes: if (C_FAMILY = "VIRTEX5") generate
    gen_serdes_channels: for i in 0 to SERDES_COUNT-1 generate
        Master_iserdes : ISERDES_NODELAY
          generic map(
            BITSLIP_ENABLE  => TRUE         ,
            DATA_RATE       => DATA_RATE    ,
            DATA_WIDTH      => SERDES_DATAWIDTH,
            INIT_Q1         => '0'          ,
            INIT_Q2         => '0'          ,
            INIT_Q3         => '0'          ,
            INIT_Q4         => '0'          ,
            INTERFACE_TYPE  => "NETWORKING" ,
            NUM_CE          => 2            ,
            SERDES_MODE     => "MASTER"
          )
          port map (
            BITSLIP     => ISERDES_BITSLIP(i)       ,
            CE1         => one                      ,
            CE2         => one                      ,
            CLK         => CLK                      ,
            CLKB        => CLKb_self                ,
            CLKDIV      => CLKDIV                   ,
            D           => SerialIoDelayOutFinal(i)     ,
            OCLK        => zero                     ,
            RST         => IODELAY_ISERDES_RESET(i) ,
            SHIFTIN1    => zero                     ,
            SHIFTIN2    => zero                     ,
            Q1          => MASTER_DATA((6*i)+0)     ,
            Q2          => MASTER_DATA((6*i)+1)     ,
            Q3          => MASTER_DATA((6*i)+2)     ,
            Q4          => MASTER_DATA((6*i)+3)     ,
            Q5          => MASTER_DATA((6*i)+4)     ,
            Q6          => MASTER_DATA((6*i)+5)     ,
            SHIFTOUT1   => SHIFT_TO_SLAVE((2*i)+0)  ,
            SHIFTOUT2   => SHIFT_TO_SLAVE((2*i)+1)
            );

        -- dual serdes modules needed for widths of 8 and 10 in DDR mode, and 7 and 8 in SDR mode
        Slave_iserdes_gen: if (SERDES_DATAWIDTH > 6) generate
            Slave_iserdes : ISERDES_NODELAY
              generic map(
                BITSLIP_ENABLE  => TRUE         ,
                DATA_RATE       => DATA_RATE    ,
                DATA_WIDTH      => SERDES_DATAWIDTH,
                INIT_Q1         => '0'          ,
                INIT_Q2         => '0'          ,
                INIT_Q3         => '0'          ,
                INIT_Q4         => '0'          ,
                INTERFACE_TYPE  => "NETWORKING" ,
                NUM_CE          => 2            ,
                SERDES_MODE     => "SLAVE"
                )
              port map (
                BITSLIP     => ISERDES_BITSLIP(i)       ,
                CE1         => one                      ,
                CE2         => one                      ,
                CLK         => CLK                      ,
                CLKB        => CLKb_self                ,
                CLKDIV      => CLKDIV                   ,
                D           => zero                     ,
                OCLK        => zero                     ,
                RST         => IODELAY_ISERDES_RESET(i) ,
                SHIFTIN1    => SHIFT_TO_SLAVE((2*i)+0)  ,
                SHIFTIN2    => SHIFT_TO_SLAVE((2*i)+1)  ,
                Q1          => SLAVE_DATA((6*i)+0)      ,
                Q2          => SLAVE_DATA((6*i)+1)      ,
                Q3          => SLAVE_DATA((6*i)+2)      ,
                Q4          => SLAVE_DATA((6*i)+3)      ,
                Q5          => SLAVE_DATA((6*i)+4)      ,
                Q6          => SLAVE_DATA((6*i)+5)      ,
                SHIFTOUT1   => open                     ,
                SHIFTOUT2   => open
                );
        end generate;
    end generate;
end generate;

--virtex6
gen_virtex6_iserdes: if (C_FAMILY = "VIRTEX6") generate
    gen_serdes_channels: for i in 0 to SERDES_COUNT-1 generate
        Master_iserdes : ISERDESE1
          generic map (
            DATA_RATE           => DATA_RATE, -- "SDR" or "DDR"
            DATA_WIDTH          => SERDES_DATAWIDTH, -- Parallel data width (2-8, 10)
            DYN_CLKDIV_INV_EN   => FALSE,     -- Enable DYNCLKDIVINVSEL inversion (TRUE/FALSE)
            DYN_CLK_INV_EN      => FALSE, -- Enable DYNCLKINVSEL inversion (TRUE/FALSE)
            -- INIT_Q1 - INIT_Q4: Initial value on the Q outputs (0/1)
            INIT_Q1             => '0',
            INIT_Q2             => '0',
            INIT_Q3             => '0',
            INIT_Q4             => '0',
            INTERFACE_TYPE      => "NETWORKING", -- "MEMORY", "MEMORY_DDR3", "MEMORY_QDR", "NETWORKING", or "OVERSAMPLE"
            IOBDELAY            => "IFD", -- "NONE", "IBUF", "IFD", "BOTH"
            NUM_CE              => 2, -- Number of clock enables (1 or 2)
            OFB_USED            => FALSE, -- Select OFB path (TRUE/FALSE)
            SERDES_MODE         => "MASTER", -- "MASTER" or "SLAVE"
            -- SRVAL_Q1 - SRVAL_Q4: Q output values when SR is used (0/1)
            SRVAL_Q1            => '0',
            SRVAL_Q2            => '0',
            SRVAL_Q3            => '0',
            SRVAL_Q4            => '0'
          )
          port map (
            O                   => SDataMon(i)                     , -- 1-bit output: Combinatorial output
            -- Q1 - Q6: 1-bit (each) output: Registered data outputs
            Q1                  => MASTER_DATA((6*i)+0)     ,
            Q2                  => MASTER_DATA((6*i)+1)     ,
            Q3                  => MASTER_DATA((6*i)+2)     ,
            Q4                  => MASTER_DATA((6*i)+3)     ,
            Q5                  => MASTER_DATA((6*i)+4)     ,
            Q6                  => MASTER_DATA((6*i)+5)     ,
            -- SHIFTOUT1-SHIFTOUT2: 1-bit (each) output: Data width expansion output ports
            SHIFTOUT1           => SHIFT_TO_SLAVE((2*i)+0)  ,
            SHIFTOUT2           => SHIFT_TO_SLAVE((2*i)+1)  ,
            BITSLIP             => ISERDES_BITSLIP(i)       , -- 1-bit input: Bitslip enable input
            -- CE1, CE2: 1-bit (each) input: Data register clock enable inputs
            CE1                 => one                      ,
            CE2                 => one                      ,
            -- Clocks: 1-bit (each) input: ISERDESE1 clock input ports
            CLK                 => CLK                      , -- 1-bit input: High-speed clock input
            CLKB                => CLKb_self                , -- 1-bit input: High-speed secondary clock input
            CLKDIV              => CLKDIV                   , -- 1-bit input: Divided clock input
            OCLK                => zero                     , -- 1-bit input: High speed output clock input used when
            -- INTERFACE_TYPE="MEMORY"
            -- Dynamic Clock Inversions: 1-bit (each) input: Dynamic clock inversion pins to switch clock polarity
            DYNCLKDIVSEL        => zero                     , -- 1-bit input: Dynamic CLKDIV inversion input
            DYNCLKSEL           => zero                     , -- 1-bit input: Dynamic CLK/CLKB inversion input
            -- Input Data: 1-bit (each) input: ISERDESE1 data input ports
            D                   => SerialIn(i)              , -- 1-bit input: Data input
            DDLY                => SerialIoDelayOutFinal(i) , -- 1-bit input: Serial input data from IODELAYE1
            OFB                 => zero                     , -- 1-bit input: Data feedback input from OSERDESE1
            RST                 => IODELAY_ISERDES_RESET(i) , -- 1-bit input: Active high asynchronous reset input
            -- SHIFTIN1-SHIFTIN2: 1-bit (each) input: Data width expansion input ports
            SHIFTIN1            => zero                     ,
            SHIFTIN2            => zero
          );


        Slave_iserdes_gen: if (SERDES_DATAWIDTH > 6) generate
            Slave_iserdes : ISERDESE1
              generic map (
                DATA_RATE           => DATA_RATE, -- "SDR" or "DDR"
                DATA_WIDTH          => SERDES_DATAWIDTH, -- Parallel data width (2-8, 10)
                DYN_CLKDIV_INV_EN   => FALSE,     -- Enable DYNCLKDIVINVSEL inversion (TRUE/FALSE)
                DYN_CLK_INV_EN      => FALSE, -- Enable DYNCLKINVSEL inversion (TRUE/FALSE)
                -- INIT_Q1 - INIT_Q4: Initial value on the Q outputs (0/1)
                INIT_Q1             => '0',
                INIT_Q2             => '0',
                INIT_Q3             => '0',
                INIT_Q4             => '0',
                INTERFACE_TYPE      => "NETWORKING", -- "MEMORY", "MEMORY_DDR3", "MEMORY_QDR", "NETWORKING", or "OVERSAMPLE"
                IOBDELAY            => "IFD", -- "NONE", "IBUF", "IFD", "BOTH"
                NUM_CE              => 2, -- Number of clock enables (1 or 2)
                OFB_USED            => FALSE, -- Select OFB path (TRUE/FALSE)
                SERDES_MODE         => "SLAVE", -- "MASTER" or "SLAVE"
                -- SRVAL_Q1 - SRVAL_Q4: Q output values when SR is used (0/1)
                SRVAL_Q1            => '0',
                SRVAL_Q2            => '0',
                SRVAL_Q3            => '0',
                SRVAL_Q4            => '0'
              )
              port map (
                O                   => open                     , -- 1-bit output: Combinatorial output
                -- Q1 - Q6: 1-bit (each) output: Registered data outputs
                Q1                  => SLAVE_DATA((6*i)+0)      ,
                Q2                  => SLAVE_DATA((6*i)+1)      ,
                Q3                  => SLAVE_DATA((6*i)+2)      ,
                Q4                  => SLAVE_DATA((6*i)+3)      ,
                Q5                  => SLAVE_DATA((6*i)+4)      ,
                Q6                  => SLAVE_DATA((6*i)+5)      ,
                -- SHIFTOUT1-SHIFTOUT2: 1-bit (each) output: Data width expansion output ports
                SHIFTOUT1           => open                     ,
                SHIFTOUT2           => open                     ,
                BITSLIP             => ISERDES_BITSLIP(i)       , -- 1-bit input: Bitslip enable input
                -- CE1, CE2: 1-bit (each) input: Data register clock enable inputs
                CE1                 => one                      ,
                CE2                 => one                      ,
                -- Clocks: 1-bit (each) input: ISERDESE1 clock input ports
                CLK                 => CLK                      , -- 1-bit input: High-speed clock input
                CLKB                => CLKb_self                , -- 1-bit input: High-speed secondary clock input
                CLKDIV              => CLKDIV                   , -- 1-bit input: Divided clock input
                OCLK                => zero                     , -- 1-bit input: High speed output clock input used when
                -- INTERFACE_TYPE="MEMORY"
                -- Dynamic Clock Inversions: 1-bit (each) input: Dynamic clock inversion pins to switch clock polarity
                DYNCLKDIVSEL        => zero                     , -- 1-bit input: Dynamic CLKDIV inversion input
                DYNCLKSEL           => zero                     , -- 1-bit input: Dynamic CLK/CLKB inversion input
                -- Input Data: 1-bit (each) input: ISERDESE1 data input ports
                D                   => zero                     , -- 1-bit input: Data input
                DDLY                => zero                     , -- 1-bit input: Serial input data from IODELAYE1
                OFB                 => zero                     , -- 1-bit input: Data feedback input from OSERDESE1
                RST                 => IODELAY_ISERDES_RESET(i) , -- 1-bit input: Active high asynchronous reset input
                -- SHIFTIN1-SHIFTIN2: 1-bit (each) input: Data width expansion input ports
                SHIFTIN1            => SHIFT_TO_SLAVE((2*i)+0)  ,
                SHIFTIN2            => SHIFT_TO_SLAVE((2*i)+1)
              );
        end generate;
    end generate;
end generate;

--7series
--FIXME: only 6bit supported for now
gen_7series_iserdes: if (C_FAMILY = "7SERIES") generate
    gen_serdes_channels: for i in 0 to SERDES_COUNT-1 generate
        Master_iserdes : ISERDESE2
          generic map (
            DATA_RATE           => DATA_RATE, -- DDR, SDR
            DATA_WIDTH          => SERDES_DATAWIDTH, -- Parallel data width (2-8,10,14)
            DYN_CLKDIV_INV_EN   => "FALSE", -- Enable DYNCLKDIVINVSEL inversion (FALSE, TRUE)
            DYN_CLK_INV_EN      => "FALSE", -- Enable DYNCLKINVSEL inversion (FALSE, TRUE)
            -- INIT_Q1 - INIT_Q4: Initial value on the Q outputs (0/1)
            INIT_Q1             => '0',
            INIT_Q2             => '0',
            INIT_Q3             => '0',
            INIT_Q4             => '0',
            INTERFACE_TYPE      => "NETWORKING", -- MEMORY, MEMORY_DDR3, MEMORY_QDR, NETWORKING, OVERSAMPLE
            IOBDELAY            => "IFD", -- NONE, BOTH, IBUF, IFD
            NUM_CE              => 2, -- Number of clock enables (1,2)
            OFB_USED            => "FALSE", -- Select OFB path (FALSE, TRUE)
            SERDES_MODE         => "MASTER", -- MASTER, SLAVE
            -- SRVAL_Q1 - SRVAL_Q4: Q output values when SR is used (0/1)
            SRVAL_Q1            => '0',
            SRVAL_Q2            => '0',
            SRVAL_Q3            => '0',
            SRVAL_Q4            => '0'
          )
          port map (
            O                   => SDataMon(i)              , -- 1-bit output: Combinatorial output
            -- Q1 - Q8: 1-bit (each) output: Registered data outputs
            Q1                  => open                     ,
            Q2                  => open                     ,
            Q3                  => MASTER_DATA((6*i)+0)     ,
            Q4                  => MASTER_DATA((6*i)+1)     ,
            Q5                  => MASTER_DATA((6*i)+2)     ,
            Q6                  => MASTER_DATA((6*i)+3)     ,
            Q7                  => MASTER_DATA((6*i)+4)     ,
            Q8                  => MASTER_DATA((6*i)+5)     ,
            -- SHIFTOUT1, SHIFTOUT2: 1-bit (each) output: Data width expansion output ports
            SHIFTOUT1           => SHIFT_TO_SLAVE((2*i)+0)  ,
            SHIFTOUT2           => SHIFT_TO_SLAVE((2*i)+1)  ,
            BITSLIP             => ISERDES_BITSLIP(i)       , -- 1-bit input: The BITSLIP pin performs a Bitslip operation synchronous to
            -- CLKDIV when asserted (active High). Subsequently, the data seen on the
            -- Q1 to Q8 output ports will shift, as in a barrel-shifter operation, one
            -- position every time Bitslip is invoked (DDR operation is different from
            -- SDR).
            -- CE1, CE2: 1-bit (each) input: Data register clock enable inputs
            CE1                 => one                      ,
            CE2                 => one                      ,
            CLKDIVP             => zero                     , -- 1-bit input: TBD
            -- Clocks: 1-bit (each) input: ISERDESE2 clock input ports
            CLK                 => CLK                      , -- 1-bit input: High-speed clock
            CLKB                => CLKb_self                , -- 1-bit input: High-speed secondary clock
            CLKDIV              => CLKDIV                   , -- 1-bit input: Divided clock
            OCLK                => zero                     , -- 1-bit input: High speed output clock used when INTERFACE_TYPE="MEMORY"
            -- Dynamic Clock Inversions: 1-bit (each) input: Dynamic clock inversion pins to switch clock polarity
            DYNCLKDIVSEL        => zero                     , -- 1-bit input: Dynamic CLKDIV inversion
            DYNCLKSEL           => zero                     , -- 1-bit input: Dynamic CLK/CLKB inversion
            -- Input Data: 1-bit (each) input: ISERDESE2 data input ports
            D                   => SerialIn(i)              , -- 1-bit input: Data input
            DDLY                => SerialIoDelayOutFinal(i) , -- 1-bit input: Serial data from IDELAYE2
            OFB                 => zero                     , -- 1-bit input: Data feedback from OSERDESE2
            OCLKB               => zero                     , -- 1-bit input: High speed negative edge output clock
            RST                 => IODELAY_ISERDES_RESET(i) , -- 1-bit input: Active high asynchronous reset
            -- SHIFTIN1, SHIFTIN2: 1-bit (each) input: Data width expansion input ports
            SHIFTIN1            => zero                     ,
            SHIFTIN2            => zero
          );

        Slave_iserdes_gen: if (SERDES_DATAWIDTH > 6) generate
            --FIXME: need support for 8bit width of 7 series serdes first
        end generate;
    end generate;
end generate;

--ultrascale
--fixme (only 8 bit will be supported)
gen_ultrascale_iserdes: if (C_FAMILY = "ULTRASCALE") generate
    gen_serdes_channels: for i in 0 to SERDES_COUNT-1 generate
        ISERDESE3_inst : ISERDESE3
          generic map (
            DATA_WIDTH          => 8, -- Parallel data width (4,8)
            FIFO_ENABLE         => "TRUE", -- Enables the use of the FIFO
            FIFO_SYNC_MODE      => "FALSE", -- Enables the use of internal 2-stage synchronizers on the FIFO
            IS_CLK_B_INVERTED   => '0', -- Optional inversion for CLK_B
            IS_CLK_INVERTED     => '0', -- Optional inversion for CLK
            IS_RST_INVERTED     => '0' -- Optional inversion for RST
          )
          port map (
            FIFO_EMPTY      => open         , -- 1-bit output: FIFO empty flag
            INTERNAL_DIVCLK => open         , -- 1-bit output: Internally divided down clock used when FIFO is
            -- disabled (do not connect)
            Q(0)            => ISERDES_DATA((8*i)+7)             , -- 8-bit registered output
            Q(1)            => ISERDES_DATA((8*i)+6)             , -- 8-bit registered output
            Q(2)            => ISERDES_DATA((8*i)+5)             , -- 8-bit registered output
            Q(3)            => ISERDES_DATA((8*i)+4)             , -- 8-bit registered output
            Q(4)            => ISERDES_DATA((8*i)+3)             , -- 8-bit registered output
            Q(5)            => ISERDES_DATA((8*i)+2)             , -- 8-bit registered output
            Q(6)            => ISERDES_DATA((8*i)+1)             , -- 8-bit registered output
            Q(7)            => ISERDES_DATA((8*i)+0)             , -- 8-bit registered output
            CLK             => CLK          , -- 1-bit input: High-speed clock
            CLKDIV          => CLKDIV       , -- 1-bit input: Divided Clock
            CLK_B           => CLKb_self    , -- 1-bit input: Inversion of High-speed clock CLK
            D               => SerialIoDelayOutFinal(i)            , -- 1-bit input: Serial Data Input
            FIFO_RD_CLK     => CLKDIV       , -- 1-bit input: FIFO read clock
            FIFO_RD_EN      => one          , -- 1-bit input: Enables reading the FIFO when asserted
            RST             => IODELAY_ISERDES_RESET(i) -- 1-bit input: Asynchronous Reset
          );

    --not supported in this architecture
    SDataMon(0) <= '0';

    end generate;
end generate;


SDATA_MON<=SDataMon(0);

default_mapping: if (C_FAMILY = "VIRTEX5" or C_FAMILY = "VIRTEX6" or C_FAMILY = "7SERIES") generate

    ISERDES_DATAOUT <= ISERDES_DATA;

    With_slave_data_mapping: if (SERDES_DATAWIDTH > 6) generate
        gen_serdes_channels: for i in 0 to SERDES_COUNT-1 generate
            Normal_Output: if (INVERT_OUTPUT=FALSE) generate
                Normal_order: if (INVERSE_BITORDER=FALSE) generate
                    ISERDES_DATA((SERDES_DATAWIDTH*i)+5 downto (SERDES_DATAWIDTH*i)+0) <= MASTER_DATA((6*i)+5 downto (6*i));
                    ISERDES_DATA((SERDES_DATAWIDTH*i)+(SERDES_DATAWIDTH-1) downto (SERDES_DATAWIDTH*i)+6) <= SLAVE_DATA((6*i)+(SERDES_DATAWIDTH-5) downto (6*i)+2);
                end generate;

                Inverse_order: if (INVERSE_BITORDER=TRUE) generate
                    gen_inverse_master: for j in 0 to 5 generate
                        ISERDES_DATA((SERDES_DATAWIDTH*i)+(SERDES_DATAWIDTH-1)-j) <= MASTER_DATA((6*i)+j);
                    end generate;
                    gen_inverse_slave: for j in 6 to SERDES_DATAWIDTH-1 generate
                        ISERDES_DATA((SERDES_DATAWIDTH*i)+(SERDES_DATAWIDTH-1)-j) <= SLAVE_DATA((6*i)+j-4);
                    end generate;
                end generate;
            end generate;

            Inverse_Output: if (INVERT_OUTPUT=TRUE) generate
                 Normal_order: if (INVERSE_BITORDER=FALSE) generate
                     ISERDES_DATA((SERDES_DATAWIDTH*i)+5 downto (SERDES_DATAWIDTH*i)+0) <= not MASTER_DATA((6*i)+5 downto (6*i));
                     ISERDES_DATA((SERDES_DATAWIDTH*i)+(SERDES_DATAWIDTH-1) downto (SERDES_DATAWIDTH*i)+6) <= not SLAVE_DATA((6*i)+(SERDES_DATAWIDTH-5) downto (6*i)+2);
                 end generate;

                 Inverse_order: if (INVERSE_BITORDER=TRUE) generate
                    gen_inverse_master: for j in 0 to 5 generate
                        ISERDES_DATA((SERDES_DATAWIDTH*i)+(SERDES_DATAWIDTH-1)-j) <= not MASTER_DATA((6*i)+j);
                    end generate;
                    gen_inverse_slave: for j in 6 to SERDES_DATAWIDTH-1 generate
                        ISERDES_DATA((SERDES_DATAWIDTH*i)+(SERDES_DATAWIDTH-1)-j) <= not SLAVE_DATA((6*i)+j-4);
                    end generate;
                 end generate;
            end generate;
       end generate;
    end generate;

    Without_slave_data_mapping: if (SERDES_DATAWIDTH <= 6) generate
        gen_serdes_channels: for i in 0 to SERDES_COUNT-1 generate
            Normal_Output: if (INVERT_OUTPUT=FALSE) generate
                Normal_order: if (INVERSE_BITORDER=FALSE) generate
                    ISERDES_DATA((SERDES_DATAWIDTH*i)+(SERDES_DATAWIDTH-1) downto (SERDES_DATAWIDTH*i)) <= MASTER_DATA((6*i)+SERDES_DATAWIDTH-1 downto (6*i));
                end generate;

                Inverse_order: if (INVERSE_BITORDER=TRUE) generate
                        gen_inverse_master: for j in 0 to SERDES_DATAWIDTH-1 generate
                            ISERDES_DATA((SERDES_DATAWIDTH*i)+(SERDES_DATAWIDTH-1)-j) <= MASTER_DATA((SERDES_DATAWIDTH*i)+j);
                        end generate;
                end generate;
            end generate;

            Inverse_Output: if (INVERT_OUTPUT=TRUE) generate
                 Normal_order: if (INVERSE_BITORDER=FALSE) generate
                     ISERDES_DATA((SERDES_DATAWIDTH*i)+(SERDES_DATAWIDTH-1) downto (SERDES_DATAWIDTH*i)) <= not MASTER_DATA((6*i)+SERDES_DATAWIDTH-1 downto (6*i));
                 end generate;

                 Inverse_order: if (INVERSE_BITORDER=TRUE) generate
                         gen_inverse_master: for j in 0 to SERDES_DATAWIDTH-1 generate
                             ISERDES_DATA((SERDES_DATAWIDTH*i)+(SERDES_DATAWIDTH-1)-j) <= not MASTER_DATA((SERDES_DATAWIDTH*i)+j);
                         end generate;
                 end generate;
            end generate;
       end generate;
    end generate;
end generate;

ultrascale_mapping: if (C_FAMILY = "ULTRASCALE") generate
    Without_slave_data_mapping: if (SERDES_DATAWIDTH = 8) generate --only 8 bit width currently supported
        Normal_Output: if (INVERT_OUTPUT=FALSE) generate
            Normal_order: if (INVERSE_BITORDER=FALSE) generate
                ISERDES_DATAOUT((SERDES_DATAWIDTH*0)+(SERDES_DATAWIDTH-1) downto (SERDES_DATAWIDTH*0)) <= ISERDES_DATA((SERDES_DATAWIDTH*0)+SERDES_DATAWIDTH-1 downto (SERDES_DATAWIDTH*0));
                ISERDES_DATAOUT((SERDES_DATAWIDTH*1)+(SERDES_DATAWIDTH-1) downto (SERDES_DATAWIDTH*1)) <= not ISERDES_DATA((SERDES_DATAWIDTH*1)+SERDES_DATAWIDTH-1 downto (SERDES_DATAWIDTH*1));
            end generate;

            Inverse_order: if (INVERSE_BITORDER=TRUE) generate
                    gen_inverse_master: for j in 0 to SERDES_DATAWIDTH-1 generate
                        ISERDES_DATAOUT((SERDES_DATAWIDTH*0)+(SERDES_DATAWIDTH-1)-j) <= ISERDES_DATA((SERDES_DATAWIDTH*0)+j);
                        ISERDES_DATAOUT((SERDES_DATAWIDTH*1)+(SERDES_DATAWIDTH-1)-j) <= not ISERDES_DATA((SERDES_DATAWIDTH*1)+j);
                    end generate;
            end generate;
        end generate;

        Inverse_Output: if (INVERT_OUTPUT=TRUE) generate
             Normal_order: if (INVERSE_BITORDER=FALSE) generate
                 ISERDES_DATAOUT((SERDES_DATAWIDTH*0)+(SERDES_DATAWIDTH-1) downto (SERDES_DATAWIDTH*0)) <= not ISERDES_DATA((SERDES_DATAWIDTH*0)+SERDES_DATAWIDTH-1 downto (SERDES_DATAWIDTH*0));
                 ISERDES_DATAOUT((SERDES_DATAWIDTH*1)+(SERDES_DATAWIDTH-1) downto (SERDES_DATAWIDTH*1)) <= ISERDES_DATA((SERDES_DATAWIDTH*1)+SERDES_DATAWIDTH-1 downto (SERDES_DATAWIDTH*1));
             end generate;

             Inverse_order: if (INVERSE_BITORDER=TRUE) generate
                     gen_inverse_master: for j in 0 to SERDES_DATAWIDTH-1 generate
                         ISERDES_DATAOUT((SERDES_DATAWIDTH*0)+(SERDES_DATAWIDTH-1)-j) <= not ISERDES_DATA((SERDES_DATAWIDTH*0)+j);
                         ISERDES_DATAOUT((SERDES_DATAWIDTH*1)+(SERDES_DATAWIDTH-1)-j) <= ISERDES_DATA((SERDES_DATAWIDTH*1)+j);
                     end generate;
             end generate;
        end generate;
    end generate;
end generate;

end rtl;



