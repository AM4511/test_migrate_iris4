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

library unisim;
use unisim.vcomponents.all;

library unimacro;
use unimacro.vcomponents.all;

library work;
use work.all;

entity iserdes_fifo is
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
end iserdes_fifo;

architecture rtl of iserdes_fifo is

function GETCOUNTWIDTH ( datawidth       : in    integer) return integer is
    variable output : integer;
    begin
        if (datawidth > 18) then
            output := 9;
        elsif (datawidth > 9) then
            output := 10;
        elsif (datawidth > 4) then
            output := 11;
        else
            output := 12;
        end if;
    return output;
end function GETCOUNTWIDTH;

constant zeros          :   std_logic_vector(31 downto 0) := X"00000000";

type skipstatetp is (   idle,
                        write_enabled
                     );

signal skipstate        :   skipstatetp;

signal DI               :   std_logic_vector(MAX_DATAWIDTH downto 0) := (others => '0');
signal DO               :   std_logic_vector(MAX_DATAWIDTH downto 0) := (others => '0');

constant COUNTWIDTH     :   integer := GETCOUNTWIDTH(MAX_DATAWIDTH+1);

signal RDCOUNT          :   std_logic_vector(COUNTWIDTH-1 downto 0);
signal WRCOUNT          :   std_logic_vector(COUNTWIDTH-1 downto 0);

signal WREN             :   std_logic := '0';

signal error_detect     :   std_logic := '0';
signal rst              :   std_logic := '0';

signal  par_data_ch0    :   std_logic_vector(MAX_DATAWIDTH-1 downto 0) := (others => '0');
signal  par_data_ch1    :   std_logic_vector(MAX_DATAWIDTH-1 downto 0) := (others => '0');

signal DOUT             :   std_logic_vector(31 downto 0) := (others => '0');
signal DIN              :   std_logic_vector(31 downto 0) := (others => '0');

signal RDCOUNT_i        :   std_logic_vector(12 downto 0) := (others => '0');
signal WRCOUNT_i        :   std_logic_vector(12 downto 0) := (others => '0');

begin

WREN                            <= FIFO_WREN;
DI(MAX_DATAWIDTH-1 downto 0)    <= FIFO_DIN;
DI(MAX_DATAWIDTH)               <= error_detect;

FIFO_DOUT <= DO(MAX_DATAWIDTH-1 downto 0);
ERROR     <= DO(MAX_DATAWIDTH);
 
RST <= FIFO_RESET or CLKDIV_RESET;

gen_blockram_fifo: if (USE_BLOCKRAMFIFO = true) generate
    gen_legacy_fifo: if (C_FAMILY /= "ULTRASCALE") generate
        FIFO_DUALCLOCK_MACRO_inst : FIFO_DUALCLOCK_MACRO
          generic map (
            DEVICE                  => C_FAMILY,    -- Target Device: "VIRTEX5", "VIRTEX6", "7SERIES"
            ALMOST_FULL_OFFSET      => X"0080",     -- Sets almost full threshold
            ALMOST_EMPTY_OFFSET     => X"0080",     -- Sets the almost empty threshold
            DATA_WIDTH              => (MAX_DATAWIDTH+1), -- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
            FIFO_SIZE               => "18Kb",      -- Target BRAM, "18Kb" or "36Kb"
            FIRST_WORD_FALL_THROUGH => TRUE        -- Sets the FIFO FWFT to TRUE or FALSE
            )
          port map (
            ALMOSTEMPTY             => FIFO_AEMPTY  , -- 1-bit output almost empty
            ALMOSTFULL              => open         , -- 1-bit output almost full
            DO                      => DO           , -- Output data, width defined by DATA_WIDTH parameter
            EMPTY                   => FIFO_EMPTY   , -- 1-bit output empty
            FULL                    => open         , -- 1-bit output full
            RDCOUNT                 => RDCOUNT      , -- Output read count, width determined by FIFO depth
            RDERR                   => open         , -- 1-bit output read error
            WRCOUNT                 => WRCOUNT      , -- Output write count, width determined by FIFO depth
            WRERR                   => open         , -- 1-bit output write error
            DI                      => DI           , -- Input data, width defined by DATA_WIDTH parameter
            RDCLK                   => CLOCK        , -- 1-bit input read clock
            RDEN                    => FIFO_RDEN    , -- 1-bit input read enable
            RST                     => RST          , -- 1-bit input reset
            WRCLK                   => CLKDIV       , -- 1-bit input write clock
            WREN                    => WREN           -- 1-bit input write enable
          );
    end generate;
 
    gen_ultrascale_fifo: if (C_FAMILY = "ULTRASCALE") generate
        --FIXME: fifo type needs to change for datawidths > 16
        FIFO18E2_inst : FIFO18E2
          generic map (
            CASCADE_ORDER           => "NONE", -- FIRST, LAST, MIDDLE, NONE, PARALLEL
            CLOCK_DOMAINS           => "INDEPENDENT", -- COMMON, INDEPENDENT
            FIRST_WORD_FALL_THROUGH => "TRUE", -- FALSE, TRUE
            INIT                    => X"000000000", -- Initial values on output port
            PROG_EMPTY_THRESH       => 128, -- Programmable Empty Threshold
            PROG_FULL_THRESH        => 128, -- Programmable Full Threshold
            -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
            IS_RDCLK_INVERTED       => '0', -- Optional inversion for RDCLK
            IS_RDEN_INVERTED        => '0', -- Optional inversion for RDEN
            IS_RSTREG_INVERTED      => '0', -- Optional inversion for RSTREG
            IS_RST_INVERTED         => '0', -- Optional inversion for RST
            IS_WRCLK_INVERTED       => '0', -- Optional inversion for WRCLK
            IS_WREN_INVERTED        => '0', -- Optional inversion for WREN
            RDCOUNT_TYPE            => "RAW_PNTR", -- EXTENDED_DATACOUNT, RAW_PNTR, SIMPLE_DATACOUNT, SYNC_PNTR
            READ_WIDTH              => 18, -- 18-9
            REGISTER_MODE           => "UNREGISTERED", -- DO_PIPELINED, REGISTERED, UNREGISTERED
            RSTREG_PRIORITY         => "RSTREG", -- REGCE, RSTREG
            SLEEP_ASYNC             => "FALSE", -- FALSE, TRUE
            SRVAL                   => X"000000000", -- SET/reset value of the FIFO outputs
            WRCOUNT_TYPE            => "RAW_PNTR", -- EXTENDED_DATACOUNT, RAW_PNTR, SIMPLE_DATACOUNT, SYNC_PNTR
            WRITE_WIDTH             => 18 -- 18-9
            )
          port map (
            -- Cascade Signals outputs: Multi-FIFO cascade signals
            CASDOUT                         => open         , -- 32-bit output: Data cascade output bus
            CASDOUTP                        => open         , -- 4-bit output: Parity data cascade output bus
            CASNXTEMPTY                     => open         , -- 1-bit output: Cascade next empty
            CASPRVRDEN                      => open         , -- 1-bit output: Cascade previous read enable
            -- Read Data outputs: Read output data
            DOUT                            => DOUT         , -- 32-bit output: FIFO data output bus
            DOUTP                           => open         , -- 4-bit output: FIFO parity output bus.
            -- Status outputs: Flags and other FIFO status outputs
            EMPTY                           => FIFO_EMPTY   , -- 1-bit output: Empty
            FULL                            => open         , -- 1-bit output: Full
            PROGEMPTY                       => FIFO_AEMPTY  , -- 1-bit output: Programmable empty
            PROGFULL                        => open         , -- 1-bit output: Programmable full
            RDCOUNT                         => RDCOUNT_i    , -- 13-bit output: Read count
            RDERR                           => open         , -- 1-bit output: Read error
            RDRSTBUSY                       => open         , -- 1-bit output: Reset busy (sync to RDCLK)
            WRCOUNT                         => WRCOUNT_i    , -- 13-bit output: Write count
            WRERR                           => open         , -- 1-bit output: Write Error
            WRRSTBUSY                       => open         , -- 1-bit output: Reset busy (sync to WRCLK)
            -- Cascade Signals inputs: Multi-FIFO cascade signals
            CASDIN                          => X"00000000"  , -- 32-bit input: Data cascade input bus
            CASDINP                         => X"0"         , -- 4-bit input: Parity data cascade input bus
            CASDOMUX                        => '0'          , -- 1-bit input: Cascade MUX select
            CASDOMUXEN                      => '0'          , -- 1-bit input: Enable for cascade MUX select
            CASNXTRDEN                      => '0'          , -- 1-bit input: Cascade next read enable
            CASOREGIMUX                     => '0'          , -- 1-bit input: Cascade output MUX select
            CASOREGIMUXEN                   => '0'          , -- 1-bit input: Cascade output MUX seelct enable
            CASPRVEMPTY                     => '0'          , -- 1-bit input: Cascade previous empty
            -- Read Control Signals inputs: Read clock, enable and reset input signals
            RDCLK                           => CLOCK        , -- 1-bit input: Read clock
            RDEN                            => FIFO_RDEN    , -- 1-bit input: Read enable
            REGCE                           => '1'          , -- 1-bit input: Output register clock enable
            RSTREG                          => RST          , -- 1-bit input: Output register reset
            SLEEP                           => '0'          , -- 1-bit input: Sleep Mode
            -- Write Control Signals inputs: Write clock and enable input signals
            RST                             => RST          , -- 1-bit input: Reset
            WRCLK                           => CLKDIV       , -- 1-bit input: Write clock
            WREN                            => WREN         , -- 1-bit input: Write enable
            -- Write Data inputs: Write input data
            DIN                             => DIN          , -- 32-bit input: FIFO data input bus
            DINP                            => X"0"           -- 4-bit input: FIFO parity input bus
        );
        DIN(MAX_DATAWIDTH downto 0) <= DI(MAX_DATAWIDTH downto 0) ;
        DO <= DOUT(MAX_DATAWIDTH downto 0);
        RDCOUNT  <= RDCOUNT_i(COUNTWIDTH-1 downto 0);
        WRCOUNT  <= WRCOUNT_i(COUNTWIDTH-1 downto 0);
    end generate;
end generate;

--use fifo_en to
generate_compare: if (CHANNEL_COUNT > 1) generate
    compare: process(CLKDIV)
      begin
        if (CLKDIV'event and CLKDIV = '1') then
            if (PAR_VALID = '1') then
                if (PAR_DATA(MAX_DATAWIDTH-1 downto 0) = PAR_DATA((2*MAX_DATAWIDTH)-1 downto MAX_DATAWIDTH)) then
                    error_detect       <= '0';
                else
                    error_detect       <= '1';
                end if;
            end if;
        end if;
    end process;
end generate;

--debug

par_data_ch0 <= PAR_DATA((0*MAX_DATAWIDTH)+(MAX_DATAWIDTH-1) downto (0*MAX_DATAWIDTH));
gen_debug_ch1: if (CHANNEL_COUNT > 1) generate
    par_data_ch1 <= PAR_DATA((1*MAX_DATAWIDTH)+(MAX_DATAWIDTH-1) downto (1*MAX_DATAWIDTH));
end generate;

end rtl;
