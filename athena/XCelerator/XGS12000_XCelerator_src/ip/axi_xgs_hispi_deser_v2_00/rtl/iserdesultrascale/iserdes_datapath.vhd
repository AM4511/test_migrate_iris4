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

library work;
use work.all;

entity iserdes_datapath is
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
        FIFO_DIN                : in    std_logic_vector(MAX_DATAWIDTH-1 downto 0);
        FIFO_WREN               : in    std_logic;

        ERROR                   : out   std_logic := '0'
       );

    attribute keep : string;

    attribute keep of CONCATINATED_DATA : signal is "TRUE";
    attribute keep of CONCATINATED_VALID : signal is "TRUE";
    attribute keep of BITSLIP : signal is "TRUE";
    attribute keep of BITSLIP_RESET : signal is "TRUE";

    attribute keep of IODELAY_ISERDES_RESET : signal is "TRUE";
    attribute keep of IODELAY_INC : signal is "TRUE";
    attribute keep of IODELAY_CE : signal is "TRUE";
    attribute keep of ISERDES_BITSLIP : signal is "TRUE";
    attribute keep of ISERDES_DATAOUT : signal is "TRUE";
end iserdes_datapath;

architecture structure of iserdes_datapath is

component iserdes_core
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
  port(
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
end component;

component iserdes_concat
  generic(
        MAX_DATAWIDTH       : integer;
        SERDES_DATAWIDTH    : integer;
        C_FAMILY            : string  := "VIRTEX6"
       );
  port(
        CLKDIV                  : in    std_logic;
        CLKDIV_RESET            : in    std_logic;

        DATAWIDTH               : in    integer;

        ISERDES_DATA            : in    std_logic_vector(SERDES_DATAWIDTH-1 downto 0);

        CONCATINATED_VALID      : out   std_logic;
        CONCATINATED_DATA       : out   std_logic_vector(MAX_DATAWIDTH-1 downto 0);

        CONCAT_MODE             : in    std_logic;
        BITSLIP                 : in    std_logic;
        BITSLIP_RESET           : in    std_logic;
        DWCLK_SYNC_IN           : in    std_logic_vector(10 downto 0);
        DWCLK_SYNC_OUT          : out   std_logic_vector(10 downto 0);

        --status
        SHIFT_STATUS            : out   std_logic_vector(5 downto 0)
       );
end component;

component iserdes_fifo
  generic(
        MAX_DATAWIDTH       : integer;
        C_FAMILY            : string  := "VIRTEX6";
        CHANNEL_COUNT       : integer := 2;
        USE_BLOCKRAMFIFO    : boolean := TRUE
       );
  port(
        CLOCK                   : in    std_logic;
        CLOCK_RESET             : in    std_logic;

        CLKDIV                  : in    std_logic;
        CLKDIV_RESET            : in    std_logic;

        FIFO_EN                 : in    std_logic;

        PAR_VALID               : in    std_logic;
        PAR_DATA                : in    std_logic_vector((MAX_DATAWIDTH*CHANNEL_COUNT)-1 downto 0);

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

constant channels_per_clock     : integer := CHANNEL_COUNT/CLOCK_COUNT;

signal   SCLK_s                 : std_logic_vector((CHANNEL_COUNT)-1 downto 0);
signal   SCLKb_s                : std_logic_vector((CHANNEL_COUNT)-1 downto 0);

signal   CLKDIV_s               : std_logic_vector((CHANNEL_COUNT)-1 downto 0);
signal   CLKDIV_RESET_s         : std_logic_vector((CHANNEL_COUNT)-1 downto 0);

signal   ISERDES_DATAOUT_i      : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH)-1 downto 0) := (others => '0');
signal   ISERDES_DATAOUT_r      : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH)-1 downto 0) := (others => '0');
signal   ISERDES_DATAOUT_r2     : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH)-1 downto 0) := (others => '0');
signal   ISERDES_DATAOUT_r3     : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH)-1 downto 0) := (others => '0');

signal   IODELAY_ISERDES_RESET_r    : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0) := (others => '0');
signal   IODELAY_INC_r              : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0) := (others => '0');
signal   IODELAY_CE_r               : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0) := (others => '0');
signal   IODELAY_ENVTC_r            : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0) := (others => '1');
signal   ISERDES_BITSLIP_r          : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0) := (others => '0');

signal   IODELAY_ISERDES_RESET_r2   : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0) := (others => '0');
signal   IODELAY_INC_r2             : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0) := (others => '0');
signal   IODELAY_CE_r2              : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0) := (others => '0');
signal   IODELAY_ENVTC_r2           : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0) := (others => '1');
signal   ISERDES_BITSLIP_r2         : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0) := (others => '0');

signal   PAR_VALID_i            : std_logic_vector((CHANNEL_COUNT)-1 downto 0);
signal   PAR_DATA_i             : std_logic_vector((MAX_DATAWIDTH*CHANNEL_COUNT)-1 downto 0);

signal   DWCLK_SYNC_OUT_i       : std_logic_vector(21 downto 0);

--make sure the dataoutvectors are kept as FFs and not extracted as shiftregs, to achieve optimal timing results
attribute shreg_extract : string;
attribute shreg_extract of ISERDES_DATAOUT_r : signal is "no";
attribute shreg_extract of ISERDES_DATAOUT_r2 : signal is "no";
attribute shreg_extract of ISERDES_DATAOUT_r3 : signal is "no";

begin

--assign clocks
generate_single_clock_assign: if CLOCK_COUNT=1 generate
    SCLK_s     <= (others => SCLK(0));
    SCLKb_s    <= (others => SCLKb(0));
    CLKDIV_s   <= (others => CLKDIV(0));
    CLKDIV_RESET_s   <= (others => CLKDIV_RESET(0));
end generate;

generate_multi_clock_assign: if CLOCK_COUNT>1 generate
    gen_assign: for i in 0 to CHANNEL_COUNT-1 generate
        SCLK_s(i)      <=  SCLK(i);
        SCLKb_s(i)     <=  SCLKb(i);
        CLKDIV_s(i)    <=  CLKDIV(i);
        CLKDIV_RESET_s(i)   <= CLKDIV_RESET(i);
    end generate;
end generate;

ISERDES_DATAOUT <= ISERDES_DATAOUT_r3;
DWCLK_SYNC_OUT <= DWCLK_SYNC_OUT_i(10 downto 0);

CONCATINATED_VALID <= PAR_VALID_i;
CONCATINATED_DATA  <= PAR_DATA_i;

generate_channels: for i in 0 to CHANNEL_COUNT-1 generate
    the_iserdes_core: iserdes_core
      generic map(
           SERDES_DATAWIDTH     => SERDES_DATAWIDTH ,
           SERDES_COUNT         => SERDES_COUNT     ,
           IDELAY_COUNT         => IDELAY_COUNT     ,
           DATA_RATE            => DATA_RATE        ,
           DIFF_TERM            => DIFF_TERM        ,
           INVERT_OUTPUT        => INVERT_OUTPUT    ,
           INVERSE_BITORDER     => INVERSE_BITORDER ,
           LOW_PWR              => LOW_PWR          ,
           C_FAMILY             => C_FAMILY         ,
           REFCLK_F             => REFCLK_F         ,
           C_CALWIDTH           => C_CALWIDTH
      )
      port map(
            CLOCK                   => CLOCK                ,
            RESET                   => CLOCK_RESET          ,

            -- Data IO
            -- clk src can be internal or external
            CLK                     => SCLK_s(i)            ,
            CLKb                    => SCLKb_s(i)           ,


            CLKDIV                  => CLKDIV_s(i)          ,


            -- differential data input -> from outside, necesarry buffer is present in this file
            SDATAP                  => SDATAP(i)            ,
            SDATAN                  => SDATAN(i)            ,

            SDATA_MON               => SDATA_MON(i)         ,

            -- iodelay preload value, used for calibration of propagation delays and lengtmatchings
            -- can be set individually but will most likely have the same setting
            IODELAY_CAL             => IODELAY_CAL((SERDES_COUNT*C_CALWIDTH*i)+(SERDES_COUNT*C_CALWIDTH)-1 downto (SERDES_COUNT*C_CALWIDTH*i)),

            --Ctrl IO, all controls should run on CLKDIV/parallelclk
            IODELAY_ISERDES_RESET   => IODELAY_ISERDES_RESET_r2((i*SERDES_COUNT)+(SERDES_COUNT-1) downto (i*SERDES_COUNT)),

            -- iodelay control
            IODELAY_INC             => IODELAY_INC_r2((i*SERDES_COUNT)+(SERDES_COUNT-1) downto (i*SERDES_COUNT)),
            IODELAY_CE              => IODELAY_CE_r2((i*SERDES_COUNT)+(SERDES_COUNT-1) downto (i*SERDES_COUNT)),
            IODELAY_ENVTC           => IODELAY_ENVTC_r2((i*SERDES_COUNT)+(SERDES_COUNT-1) downto (i*SERDES_COUNT)),
            VTC_EN                  => VTC_EN,

            -- iserdes_nodelay control
            ISERDES_BITSLIP         => ISERDES_BITSLIP_r2((i*SERDES_COUNT)+(SERDES_COUNT-1) downto (i*SERDES_COUNT)),
            ISERDES_DATAOUT         => ISERDES_DATAOUT_i((i*SERDES_COUNT*SERDES_DATAWIDTH)+(SERDES_COUNT*SERDES_DATAWIDTH)-1 downto (i*SERDES_COUNT*SERDES_DATAWIDTH))
           );

    --extra FF stages to make sure clock domain crossing from clkdiv0 to clkdiv1 (if any) can meet very aggressive timings
    --signals crossing to common clk domain
    FF_seperate_to: process(CLKDIV_s(i))
      begin
        if (CLKDIV_s(i)'event and CLKDIV_s(i) = '1') then
            ISERDES_DATAOUT_r((i*SERDES_COUNT*SERDES_DATAWIDTH)+(SERDES_COUNT*SERDES_DATAWIDTH)-1 downto (i*SERDES_COUNT*SERDES_DATAWIDTH)) <=
                ISERDES_DATAOUT_i((i*SERDES_COUNT*SERDES_DATAWIDTH)+(SERDES_COUNT*SERDES_DATAWIDTH)-1 downto (i*SERDES_COUNT*SERDES_DATAWIDTH));
        end if;
    end process;
   
    --returning data is first sampled on the falling edge before reclocking on the rising edge
    --this is done to make sure the data phase between both clk domains is maintained and everything can remain running in sync
    FF_common_to1: process(CLKDIV_s(0))
      begin
        if (CLKDIV_s(0)'event and CLKDIV_s(0) = '0') then
            ISERDES_DATAOUT_r2((i*SERDES_COUNT*SERDES_DATAWIDTH)+(SERDES_COUNT*SERDES_DATAWIDTH)-1 downto (i*SERDES_COUNT*SERDES_DATAWIDTH)) <=
                ISERDES_DATAOUT_r((i*SERDES_COUNT*SERDES_DATAWIDTH)+(SERDES_COUNT*SERDES_DATAWIDTH)-1 downto (i*SERDES_COUNT*SERDES_DATAWIDTH));
        end if;
    end process;

    FF_common_to2: process(CLKDIV_s(0))
      begin
        if (CLKDIV_s(0)'event and CLKDIV_s(0) = '1') then
            ISERDES_DATAOUT_r3((i*SERDES_COUNT*SERDES_DATAWIDTH)+(SERDES_COUNT*SERDES_DATAWIDTH)-1 downto (i*SERDES_COUNT*SERDES_DATAWIDTH)) <=
                ISERDES_DATAOUT_r2((i*SERDES_COUNT*SERDES_DATAWIDTH)+(SERDES_COUNT*SERDES_DATAWIDTH)-1 downto (i*SERDES_COUNT*SERDES_DATAWIDTH));
        end if;
    end process;
    
    --signals crossing from common clk domain
    FF_common_from: process(CLKDIV_s(0))
      begin
        if (CLKDIV_s(0)'event and CLKDIV_s(0) = '1') then
             IODELAY_ISERDES_RESET_r((i*SERDES_COUNT)+(SERDES_COUNT-1) downto (i*SERDES_COUNT)) <=
                IODELAY_ISERDES_RESET((i*SERDES_COUNT)+(SERDES_COUNT-1) downto (i*SERDES_COUNT));
             IODELAY_INC_r((i*SERDES_COUNT)+(SERDES_COUNT-1) downto (i*SERDES_COUNT)) <=
                IODELAY_INC((i*SERDES_COUNT)+(SERDES_COUNT-1) downto (i*SERDES_COUNT));
             IODELAY_CE_r((i*SERDES_COUNT)+(SERDES_COUNT-1) downto (i*SERDES_COUNT)) <=
                IODELAY_CE((i*SERDES_COUNT)+(SERDES_COUNT-1) downto (i*SERDES_COUNT));
             IODELAY_ENVTC_r((i*SERDES_COUNT)+(SERDES_COUNT-1) downto (i*SERDES_COUNT)) <=
                IODELAY_ENVTC((i*SERDES_COUNT)+(SERDES_COUNT-1) downto (i*SERDES_COUNT));
             ISERDES_BITSLIP_r((i*SERDES_COUNT)+(SERDES_COUNT-1) downto (i*SERDES_COUNT)) <=
                ISERDES_BITSLIP((i*SERDES_COUNT)+(SERDES_COUNT-1) downto (i*SERDES_COUNT));
        end if;
    end process;
    
    FF_seperate_from: process(CLKDIV_s(i))
      begin
        if (CLKDIV_s(i)'event and CLKDIV_s(i) = '1') then
             IODELAY_ISERDES_RESET_r2((i*SERDES_COUNT)+(SERDES_COUNT-1) downto (i*SERDES_COUNT)) <=
                IODELAY_ISERDES_RESET_r((i*SERDES_COUNT)+(SERDES_COUNT-1) downto (i*SERDES_COUNT));
             IODELAY_INC_r2((i*SERDES_COUNT)+(SERDES_COUNT-1) downto (i*SERDES_COUNT)) <=
                IODELAY_INC_r((i*SERDES_COUNT)+(SERDES_COUNT-1) downto (i*SERDES_COUNT));
             IODELAY_CE_r2((i*SERDES_COUNT)+(SERDES_COUNT-1) downto (i*SERDES_COUNT)) <=
                IODELAY_CE_r((i*SERDES_COUNT)+(SERDES_COUNT-1) downto (i*SERDES_COUNT));
             IODELAY_ENVTC_r2((i*SERDES_COUNT)+(SERDES_COUNT-1) downto (i*SERDES_COUNT)) <=
                IODELAY_ENVTC_r((i*SERDES_COUNT)+(SERDES_COUNT-1) downto (i*SERDES_COUNT));
             ISERDES_BITSLIP_r2((i*SERDES_COUNT)+(SERDES_COUNT-1) downto (i*SERDES_COUNT)) <=
                ISERDES_BITSLIP_r((i*SERDES_COUNT)+(SERDES_COUNT-1) downto (i*SERDES_COUNT));
        end if;
    end process;

    the_iserdes_concat: iserdes_concat
      generic map(
        MAX_DATAWIDTH           => MAX_DATAWIDTH        ,
        SERDES_DATAWIDTH        => SERDES_DATAWIDTH     ,
        C_FAMILY                => C_FAMILY
       )
      port map(
        CLKDIV                  => CLKDIV_s(0)          ,
        CLKDIV_RESET            => CLKDIV_RESET_s(0)    ,

        DATAWIDTH               => DATAWIDTH            ,

        ISERDES_DATA            => ISERDES_DATAOUT_r3((i*SERDES_COUNT*SERDES_DATAWIDTH)+(SERDES_DATAWIDTH)-1 downto (i*SERDES_COUNT*SERDES_DATAWIDTH)),

        CONCATINATED_VALID      => PAR_VALID_i(i)       ,
        CONCATINATED_DATA       => PAR_DATA_i((i*MAX_DATAWIDTH)+MAX_DATAWIDTH-1 downto (i*MAX_DATAWIDTH)),

        CONCAT_MODE             => CONCAT_MODE          ,
        BITSLIP                 => BITSLIP(i)           ,
        BITSLIP_RESET           => BITSLIP_RESET(i)     ,

        DWCLK_SYNC_IN           => DWCLK_SYNC_IN        ,
        DWCLK_SYNC_OUT          => DWCLK_SYNC_OUT_i((11*i)+10 downto (11*i))     ,

        --status
        SHIFT_STATUS            => SHIFT_STATUS((6*i)+5 downto (6*i))
       );
end generate;

gen_fifo: if USE_FIFO = True generate
    the_iserdes_fifo: iserdes_fifo
      generic map (
            MAX_DATAWIDTH           => MAX_DATAWIDTH    ,
            C_FAMILY                => C_FAMILY         ,
            CHANNEL_COUNT           => CHANNEL_COUNT    ,
            USE_BLOCKRAMFIFO        => USE_BLOCKRAMFIFO
           )
      port map(
            CLOCK                   => CLOCK                ,
            CLOCK_RESET             => CLOCK_RESET          ,

            CLKDIV                  => CLKDIV_s(0)          ,
            CLKDIV_RESET            => CLKDIV_RESET_s(0)    ,

            FIFO_EN                 => FIFO_EN              ,
            PAR_VALID               => PAR_VALID_i(0)       ,
            PAR_DATA                => PAR_DATA_i((MAX_DATAWIDTH*CHANNEL_COUNT)-1 downto 0),

            FIFO_EMPTY              => FIFO_EMPTY           ,
            FIFO_AEMPTY             => FIFO_AEMPTY          ,
            FIFO_RDEN               => FIFO_RDEN            ,
            FIFO_DOUT               => FIFO_DOUT            ,
            FIFO_RESET              => FIFO_RESET           ,
            FIFO_WREN               => FIFO_WREN            ,
            FIFO_DIN                => FIFO_DIN             ,

            ERROR                   => ERROR
           );
end generate;

--code path for low speed clock
--only generates error
gen_no_fifo: if USE_FIFO = False generate
    generate_compare: if (CHANNEL_COUNT > 1) generate
        compare: process(CLKDIV_s(0))
          begin
            if (CLKDIV_s(0)'event and CLKDIV_s(0) = '1') then
                if (PAR_VALID_i(0) = '1') then
                    if (PAR_DATA_i(MAX_DATAWIDTH-1 downto 0) = PAR_DATA_i((2*MAX_DATAWIDTH)-1 downto MAX_DATAWIDTH)) then
                        ERROR       <= '0';
                    else
                        ERROR       <= '1';
                    end if;
                end if;
            end if;
        end process;
    end generate;

    FIFO_EMPTY      <= '0';
    FIFO_AEMPTY     <= '0';

    FIFO_DOUT       <= (others => '0');

end generate;

end structure;
