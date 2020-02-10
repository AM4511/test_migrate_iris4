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

entity iserdes_datapaths is
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
end iserdes_datapaths;

architecture structure of iserdes_datapaths is

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

component iserdes_filter
    generic (
        NROF_CONN               : integer;
        MAX_DATAWIDTH           : integer;
        CHANNEL_COUNT           : integer
    );
    port (
        CLOCK                       : in    std_logic;  --appclock
        RESET                       : in    std_logic;  --active high reset

        ENABLE                      : in    std_logic;
        SELECT_CHANNEL              : in    std_logic;
        SKIP                        : in    std_logic_vector(NROF_CONN-1 downto 0);

        CONCATINATED_VALID          : in    std_logic_vector((NROF_CONN*CHANNEL_COUNT)-1 downto 0);
        CONCATINATED_DATA           : in    std_logic_vector((MAX_DATAWIDTH*NROF_CONN*CHANNEL_COUNT)-1 downto 0);
        FIFO_WREN                   : in    std_logic;

        WRDATA_FILT                 : out   std_logic_vector((MAX_DATAWIDTH*NROF_CONN)-1 downto 0);
        WREN_FILT                   : out   std_logic_vector(NROF_CONN-1 downto 0)
    );
end component;

signal FIFO_DIN                 : std_logic_vector((MAX_DATAWIDTH*NROF_CONN)-1 downto 0);
signal FIFO_WREN_i              : std_logic_vector(NROF_CONN-1 downto 0);

signal CONCATINATED_VALID_i     : std_logic_vector((NROF_CONN*CHANNEL_COUNT)-1 downto 0);
signal CONCATINATED_DATA_i      : std_logic_vector((NROF_CONN*CHANNEL_COUNT*MAX_DATAWIDTH)-1 downto 0);

begin

generate_datapath: for i in 0 to NROF_CONN-1 generate
    the_iserdes_datapath: iserdes_datapath
      generic map (
            SERDES_DATAWIDTH                                => SERDES_DATAWIDTH     ,
            SERDES_COUNT                                    => SERDES_COUNT         ,
            IDELAY_COUNT                                    => IDELAY_COUNT         ,
            CHANNEL_COUNT                                   => CHANNEL_COUNT        ,
            CLOCK_COUNT                                     => CLOCK_COUNT          ,
            DATA_RATE                                       => DATA_RATE            ,
            DIFF_TERM                                       => DIFF_TERM            ,
            INVERT_OUTPUT                                   => INVERT_OUTPUT        ,
            INVERSE_BITORDER                                => INVERSE_BITORDER     ,
            LOW_PWR                                         => LOW_PWR              ,
            C_FAMILY                                        => C_FAMILY             ,
            REFCLK_F                                        => REFCLK_F             ,
            C_CALWIDTH                                      => C_CALWIDTH           ,
            MAX_DATAWIDTH                                   => MAX_DATAWIDTH        ,
            USE_BLOCKRAMFIFO                                => USE_BLOCKRAMFIFO
           )
      port map (
            CLOCK                                            => CLOCK                ,
            CLOCK_RESET                                      => CLOCK_RESET          ,

            CLKDIV                                           => CLKDIV               ,
            CLKDIV_RESET                                     => CLKDIV_RESET         ,

            DATAWIDTH                                        => DATAWIDTH            ,

            -- serial
            SCLK                                             => SCLK                 ,
            SCLKb                                            => SCLKb                ,

            -- differential data input -> from outside,
            SDATAP                                           => SDATAP((i*CHANNEL_COUNT)+CHANNEL_COUNT-1 downto (i*CHANNEL_COUNT))    ,
            SDATAN                                           => SDATAN((i*CHANNEL_COUNT)+CHANNEL_COUNT-1 downto (i*CHANNEL_COUNT))    ,

            SDATA_MON                                        => SDATA_MON((i*CHANNEL_COUNT)+CHANNEL_COUNT-1 downto (i*CHANNEL_COUNT)) ,

            -- iodelay preload value, used for calibration of propagation delays and lengtmatchings
            -- can be set individually but will most likely have the same setting
            IODELAY_CAL                                      => IODELAY_CAL((i*CHANNEL_COUNT*SERDES_COUNT*C_CALWIDTH)+(CHANNEL_COUNT*SERDES_COUNT*C_CALWIDTH)-1 downto (i*CHANNEL_COUNT*SERDES_COUNT*C_CALWIDTH))   ,

            --Ctrl IO, all controls should run on CLKDIV/parallelclk
            -- bitalign controls
            IODELAY_ISERDES_RESET                            => IODELAY_ISERDES_RESET((i*CHANNEL_COUNT*SERDES_COUNT)+(CHANNEL_COUNT*SERDES_COUNT)-1 downto (i*CHANNEL_COUNT*SERDES_COUNT))                          ,
            IODELAY_INC                                      => IODELAY_INC((i*CHANNEL_COUNT*SERDES_COUNT)+(CHANNEL_COUNT*SERDES_COUNT)-1 downto (i*CHANNEL_COUNT*SERDES_COUNT))                                    ,
            IODELAY_CE                                       => IODELAY_CE((i*CHANNEL_COUNT*SERDES_COUNT)+(CHANNEL_COUNT*SERDES_COUNT)-1 downto (i*CHANNEL_COUNT*SERDES_COUNT))                                     ,
            IODELAY_ENVTC                                    => IODELAY_ENVTC((i*CHANNEL_COUNT*SERDES_COUNT)+(CHANNEL_COUNT*SERDES_COUNT)-1 downto (i*CHANNEL_COUNT*SERDES_COUNT))                                     ,
            ISERDES_BITSLIP                                  => ISERDES_BITSLIP((i*CHANNEL_COUNT*SERDES_COUNT)+(CHANNEL_COUNT*SERDES_COUNT)-1 downto (i*CHANNEL_COUNT*SERDES_COUNT))                                ,
            ISERDES_DATAOUT                                  => ISERDES_DATAOUT((i*CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH)+(CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH)-1 downto (i*CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH)),
            -- wordalign controls
            BITSLIP                                          => BITSLIP((i*CHANNEL_COUNT)+CHANNEL_COUNT-1 downto (i*CHANNEL_COUNT))             ,
            BITSLIP_RESET                                    => BITSLIP_RESET((i*CHANNEL_COUNT)+CHANNEL_COUNT-1 downto (i*CHANNEL_COUNT))             ,
            CONCATINATED_VALID                               => CONCATINATED_VALID_i((i*CHANNEL_COUNT)+CHANNEL_COUNT-1 downto (i*CHANNEL_COUNT))  ,
            CONCATINATED_DATA                                => CONCATINATED_DATA_i((i*CHANNEL_COUNT*MAX_DATAWIDTH)+(CHANNEL_COUNT*MAX_DATAWIDTH)-1 downto (i*CHANNEL_COUNT*MAX_DATAWIDTH))       ,

            --options
            CONCAT_MODE                                      => CONCAT_MODE             ,
            DWCLK_SYNC_IN                                    => DWCLK_SYNC              ,
            DWCLK_SYNC_OUT                                   => open                    ,
            VTC_EN                                           => VTC_EN                  ,

            --status
            SHIFT_STATUS                                     => SHIFT_STATUS((i*6*CHANNEL_COUNT)+(6*CHANNEL_COUNT)-1 downto (i*6*CHANNEL_COUNT))            ,

            FIFO_EN                                          => FIFO_WREN               ,
            FIFO_EMPTY                                       => FIFO_EMPTY(i)           ,
            FIFO_AEMPTY                                      => FIFO_AEMPTY(i)          ,
            FIFO_RDEN                                        => FIFO_RDEN(i)            ,
            FIFO_DOUT                                        => FIFO_DOUT((i*MAX_DATAWIDTH)+(MAX_DATAWIDTH)-1 downto (i*MAX_DATAWIDTH))               ,
            FIFO_RESET                                       => FIFO_RESET              ,
            FIFO_WREN                                        => FIFO_WREN_i(i)          ,
            FIFO_DIN                                         => FIFO_DIN((i*MAX_DATAWIDTH)+(MAX_DATAWIDTH)-1 downto (i*MAX_DATAWIDTH))                ,
            ERROR                                            => ERROR(i)
           );
end generate;

CONCATINATED_VALID <=  CONCATINATED_VALID_i;
CONCATINATED_DATA  <=  CONCATINATED_DATA_i;

the_iserdes_filter: iserdes_filter
    generic map (
        NROF_CONN       => NROF_CONN        ,
        MAX_DATAWIDTH   => MAX_DATAWIDTH    ,
        CHANNEL_COUNT   => CHANNEL_COUNT
    )
    port map (
        CLOCK                       => CLKDIV(0)            ,
        RESET                       => CLKDIV_RESET(0)      ,

        ENABLE                      => FILTER_MODE          ,
        SELECT_CHANNEL              => SELECT_CHANNEL       ,
        SKIP                        => PAR_SKIP             ,

        CONCATINATED_VALID          => CONCATINATED_VALID_i ,
        CONCATINATED_DATA           => CONCATINATED_DATA_i  ,
        FIFO_WREN                   => FIFO_WREN            ,

        WRDATA_FILT                 => FIFO_DIN             ,
        WREN_FILT                   => FIFO_WREN_i
    );

end structure;
