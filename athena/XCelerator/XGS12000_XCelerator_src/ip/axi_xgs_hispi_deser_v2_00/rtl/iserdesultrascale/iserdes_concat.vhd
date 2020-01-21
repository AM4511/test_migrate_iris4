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
use work.serdes_pack.all;
use work.all;

entity iserdes_concat is
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

        CONCATINATED_VALID      : out   std_logic := '0';
        CONCATINATED_DATA       : out   std_logic_vector(MAX_DATAWIDTH-1 downto 0) := (others => '0');

        CONCAT_MODE             : in    std_logic;
        BITSLIP                 : in    std_logic;
        BITSLIP_RESET           : in    std_logic;
        DWCLK_SYNC_IN           : in    std_logic_vector(10 downto 0);
        DWCLK_SYNC_OUT          : out   std_logic_vector(10 downto 0);

        --status
        SHIFT_STATUS            : out   std_logic_vector(5 downto 0)
       );
end iserdes_concat;

architecture rtl of iserdes_concat is

constant initarray6b : initarraytp := generateinitarray6bit;
constant initarray8b : initarraytp := generateinitarray8bit;

signal datawidth_select          : std_logic_vector(2 downto 0) := (others => '0');
signal shift_address             : std_logic_vector(2 downto 0) := (others => '0');
signal cycle_address             : std_logic_vector(2 downto 0) := (others => '0');

signal iserdes_bitslip_r         : std_logic := '0';

signal BR_DO                     : std_logic_vector(7 downto 0) := (others => '0');
signal BR_DO_unused              : std_logic_vector(7 downto 0) := (others => '0');
signal BR_DI                     : std_logic_vector(7 downto 0) := (others => '0');
signal RDADDR                    : std_logic_vector(10 downto 0) := (others => '0');
signal RDEN                      : std_logic := '0';
signal REGCE                     : std_logic := '0';
signal WE                        : std_logic_vector(0 downto 0) := "0";
signal WRADDR                    : std_logic_vector(10 downto 0) := (others => '0');
signal WREN                      : std_logic := '0';

alias  cycle_select              : std_logic_vector(2 downto 0) is BR_DO(2 downto 0);
alias  cycle_valid               : std_logic is BR_DO(3);
alias  cycle_reset               : std_logic is BR_DO(4);

signal cycle_skip                : std_logic := '0';

signal Serdes_concat            : std_logic_vector(4*SERDES_DATAWIDTH-1 downto 0);
type Serdes_Pipetp is array (0 to 3) of std_logic_vector(SERDES_DATAWIDTH-1 downto 0);
signal Serdes_Pipe              : Serdes_Pipetp := (others => (others => '0'));

signal padding                  : std_logic_vector(MAX_DATAWIDTH-1 downto 0) := (others => '0');
--fixme: this needs to be changed when greater bitwidths need to be supported
signal padding_max              : std_logic_vector(17 downto 0) := (others => '0');

signal cnt_bitslip              : std_logic_vector(3 downto 0) := (others => '0');


begin

gen_old_series: if (C_FAMILY /= "ULTRASCALE") generate

    -- BRAM_SDP_MACRO: Simple Dual Port RAM
    -- Xilinx HDL Libraries Guide, version 13.1
    -- Note - This Unimacro model assumes the port directions to be "downto".
    -- Simulation of this model with "to" in the port directions could lead to erroneous results.
    BRAM_SDP_MACRO_inst : BRAM_SDP_MACRO
    generic map (
        BRAM_SIZE           => "18Kb"       , -- Target BRAM, "18Kb" or "36Kb"
        DEVICE              => C_FAMILY     , -- Target device: "VIRTEX5", "VIRTEX6", "SPARTAN6", "7SERIES"
        WRITE_WIDTH         => 5            , -- Valid values are 1-72 (37-72 only valid when BRAM_SIZE="36Kb")
        READ_WIDTH          => 5            , -- Valid values are 1-72 (37-72 only valid when BRAM_SIZE="36Kb")
        DO_REG              => 0            , -- Optional output register (0 or 1)
        INIT_FILE           => "NONE"       ,
        SIM_COLLISION_CHECK => "ALL"        , -- Collision check enable "ALL", "WARNING_ONLY",
        -- "GENERATE_X_ONLY" or "NONE"
        SIM_MODE            => "SAFE"       , -- Simulation: "SAFE" vs "FAST",
        -- see "Synthesis and Simulation Design Guide" for details
        SRVAL               => X"000000000000000000"    , -- Set/Reset value for port output
        INIT                => X"000000000000000000"    , -- Initial values on output port

        -- The following INIT_xx declarations specify the initial contents of the RAM
        INIT_00 => initarray6b(0),
        INIT_01 => initarray6b(1),
        INIT_02 => initarray6b(2),
        INIT_03 => initarray6b(3),
        INIT_04 => initarray6b(4),
        INIT_05 => initarray6b(5),
        INIT_06 => initarray6b(6),
        INIT_07 => initarray6b(7),
        INIT_08 => initarray6b(8),
        INIT_09 => initarray6b(9),
        INIT_0A => initarray6b(10),
        INIT_0B => initarray6b(11),
        INIT_0C => initarray6b(12),
        INIT_0D => initarray6b(13),
        INIT_0E => initarray6b(14),
        INIT_0F => initarray6b(15),
        INIT_10 => initarray6b(16),
        INIT_11 => initarray6b(17),
        INIT_12 => initarray6b(18),
        INIT_13 => initarray6b(19),
        INIT_14 => initarray6b(20),
        INIT_15 => initarray6b(21),
        INIT_16 => initarray6b(22),
        INIT_17 => initarray6b(23),
        INIT_18 => initarray6b(24),
        INIT_19 => initarray6b(25),
        INIT_1A => initarray6b(26),
        INIT_1B => initarray6b(27),
        INIT_1C => initarray6b(28),
        INIT_1D => initarray6b(29),
        INIT_1E => initarray6b(30),
        INIT_1F => initarray6b(31),
        INIT_20 => initarray6b(32),
        INIT_21 => initarray6b(33),
        INIT_22 => initarray6b(34),
        INIT_23 => initarray6b(35),
        INIT_24 => initarray6b(36),
        INIT_25 => initarray6b(37),
        INIT_26 => initarray6b(38),
        INIT_27 => initarray6b(39),
        INIT_28 => initarray6b(40),
        INIT_29 => initarray6b(41),
        INIT_2A => initarray6b(42),
        INIT_2B => initarray6b(43),
        INIT_2C => initarray6b(44),
        INIT_2D => initarray6b(45),
        INIT_2E => initarray6b(46),
        INIT_2F => initarray6b(47),
        INIT_30 => initarray6b(48),
        INIT_31 => initarray6b(49),
        INIT_32 => initarray6b(50),
        INIT_33 => initarray6b(51),
        INIT_34 => initarray6b(52),
        INIT_35 => initarray6b(53),
        INIT_36 => initarray6b(54),
        INIT_37 => initarray6b(55),
        INIT_38 => initarray6b(56),
        INIT_39 => initarray6b(57),
        INIT_3A => initarray6b(58),
        INIT_3B => initarray6b(59),
        INIT_3C => initarray6b(60),
        INIT_3D => initarray6b(61),
        INIT_3E => initarray6b(62),
        INIT_3F => initarray6b(63),

        -- The next set of INITP_xx are for the parity bits
        INITP_00 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INITP_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INITP_02 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INITP_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INITP_04 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INITP_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INITP_06 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INITP_07 => X"0000000000000000000000000000000000000000000000000000000000000000")
        port map (
            DO      => BR_DO(4 downto 0), -- Output read data port
            DI      => BR_DI(4 downto 0), -- Input write data port
            RDADDR  => RDADDR           , -- Input read address
            RDCLK   => CLKDIV           , -- Input read clock
            RDEN    => RDEN             , -- Input read port enable
            REGCE   => REGCE            , -- Input read output register enable
            RST     => CLKDIV_RESET     , -- Input reset
            WE      => WE               , -- Input write enable
            WRADDR  => WRADDR           , -- Input write address
            WRCLK   => CLKDIV           , -- Input write clock
            WREN    => WREN               -- Input write port enable
    );
end generate;
-- End of BRAM_SDP_MACRO_inst instantiation

gen_ultrascale_series: if (C_FAMILY = "ULTRASCALE") generate

-- RAMB18E2: 18K-bit Configurable Synchronous Block RAM
-- UltraScale
-- Xilinx HDL Libraries Guide, version 2014.3

-- configured as TDP, but used as SDP

    RAMB18E2_inst : RAMB18E2
      generic map (
        -- CASCADE_ORDER_A, CASCADE_ORDER_B: "FIRST", "MIDDLE", "LAST", "NONE"
        CASCADE_ORDER_A => "NONE",
        CASCADE_ORDER_B => "NONE",
        -- CLOCK_DOMAINS: "COMMON", "INDEPENDENT"
        CLOCK_DOMAINS => "COMMON",
        -- Collision check: "ALL", "GENERATE_X_ONLY", "NONE", "WARNING_ONLY"
        SIM_COLLISION_CHECK => "ALL",
        -- DOA_REG, DOB_REG: Optional output register (0, 1)
        DOA_REG => 0,
        DOB_REG => 0,
        -- ENADDRENA/ENADDRENB: Address enable pin enable, "TRUE", "FALSE"
        ENADDRENA => "FALSE",
        ENADDRENB => "FALSE",
        -- INITP_00 to INITP_07: Initial contents of parity memory array
        INITP_00 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INITP_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INITP_02 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INITP_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INITP_04 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INITP_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INITP_06 => X"0000000000000000000000000000000000000000000000000000000000000000",
        INITP_07 => X"0000000000000000000000000000000000000000000000000000000000000000",
        -- INIT_00 to INIT_3F: Initial contents of data memory array
        INIT_00 => to_stdlogicvector(initarray8b(0)),
        INIT_01 => to_stdlogicvector(initarray8b(1)),
        INIT_02 => to_stdlogicvector(initarray8b(2)),
        INIT_03 => to_stdlogicvector(initarray8b(3)),
        INIT_04 => to_stdlogicvector(initarray8b(4)),
        INIT_05 => to_stdlogicvector(initarray8b(5)),
        INIT_06 => to_stdlogicvector(initarray8b(6)),
        INIT_07 => to_stdlogicvector(initarray8b(7)),
        INIT_08 => to_stdlogicvector(initarray8b(8)),
        INIT_09 => to_stdlogicvector(initarray8b(9)),
        INIT_0A => to_stdlogicvector(initarray8b(10)),
        INIT_0B => to_stdlogicvector(initarray8b(11)),
        INIT_0C => to_stdlogicvector(initarray8b(12)),
        INIT_0D => to_stdlogicvector(initarray8b(13)),
        INIT_0E => to_stdlogicvector(initarray8b(14)),
        INIT_0F => to_stdlogicvector(initarray8b(15)),
        INIT_10 => to_stdlogicvector(initarray8b(16)),
        INIT_11 => to_stdlogicvector(initarray8b(17)),
        INIT_12 => to_stdlogicvector(initarray8b(18)),
        INIT_13 => to_stdlogicvector(initarray8b(19)),
        INIT_14 => to_stdlogicvector(initarray8b(20)),
        INIT_15 => to_stdlogicvector(initarray8b(21)),
        INIT_16 => to_stdlogicvector(initarray8b(22)),
        INIT_17 => to_stdlogicvector(initarray8b(23)),
        INIT_18 => to_stdlogicvector(initarray8b(24)),
        INIT_19 => to_stdlogicvector(initarray8b(25)),
        INIT_1A => to_stdlogicvector(initarray8b(26)),
        INIT_1B => to_stdlogicvector(initarray8b(27)),
        INIT_1C => to_stdlogicvector(initarray8b(28)),
        INIT_1D => to_stdlogicvector(initarray8b(29)),
        INIT_1E => to_stdlogicvector(initarray8b(30)),
        INIT_1F => to_stdlogicvector(initarray8b(31)),
        INIT_20 => to_stdlogicvector(initarray8b(32)),
        INIT_21 => to_stdlogicvector(initarray8b(33)),
        INIT_22 => to_stdlogicvector(initarray8b(34)),
        INIT_23 => to_stdlogicvector(initarray8b(35)),
        INIT_24 => to_stdlogicvector(initarray8b(36)),
        INIT_25 => to_stdlogicvector(initarray8b(37)),
        INIT_26 => to_stdlogicvector(initarray8b(38)),
        INIT_27 => to_stdlogicvector(initarray8b(39)),
        INIT_28 => to_stdlogicvector(initarray8b(40)),
        INIT_29 => to_stdlogicvector(initarray8b(41)),
        INIT_2A => to_stdlogicvector(initarray8b(42)),
        INIT_2B => to_stdlogicvector(initarray8b(43)),
        INIT_2C => to_stdlogicvector(initarray8b(44)),
        INIT_2D => to_stdlogicvector(initarray8b(45)),
        INIT_2E => to_stdlogicvector(initarray8b(46)),
        INIT_2F => to_stdlogicvector(initarray8b(47)),
        INIT_30 => to_stdlogicvector(initarray8b(48)),
        INIT_31 => to_stdlogicvector(initarray8b(49)),
        INIT_32 => to_stdlogicvector(initarray8b(50)),
        INIT_33 => to_stdlogicvector(initarray8b(51)),
        INIT_34 => to_stdlogicvector(initarray8b(52)),
        INIT_35 => to_stdlogicvector(initarray8b(53)),
        INIT_36 => to_stdlogicvector(initarray8b(54)),
        INIT_37 => to_stdlogicvector(initarray8b(55)),
        INIT_38 => to_stdlogicvector(initarray8b(56)),
        INIT_39 => to_stdlogicvector(initarray8b(57)),
        INIT_3A => to_stdlogicvector(initarray8b(58)),
        INIT_3B => to_stdlogicvector(initarray8b(59)),
        INIT_3C => to_stdlogicvector(initarray8b(60)),
        INIT_3D => to_stdlogicvector(initarray8b(61)),
        INIT_3E => to_stdlogicvector(initarray8b(62)),
        INIT_3F => to_stdlogicvector(initarray8b(63)),
        -- INIT_A, INIT_B: Initial values on output ports
        INIT_A => "000000000000000000",
        INIT_B => "000000000000000000",
        -- Initialization File: RAM initialization file
        INIT_FILE => "NONE",
        -- Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
        IS_CLKARDCLK_INVERTED => '0',
        IS_CLKBWRCLK_INVERTED => '0',
        IS_ENARDEN_INVERTED => '0',
        IS_ENBWREN_INVERTED => '0',
        IS_RSTRAMARSTRAM_INVERTED => '0',
        IS_RSTRAMB_INVERTED => '0',
        IS_RSTREGARSTREG_INVERTED => '0',
        IS_RSTREGB_INVERTED => '0',
        -- RDADDRCHANGE: Disable memory access when output value does not change ("TRUE", "FALSE")
        RDADDRCHANGEA => "FALSE",
        RDADDRCHANGEB => "FALSE",
        -- READ_WIDTH_A/B, WRITE_WIDTH_A/B: Read/write width per port
        READ_WIDTH_A => 9, -- 0-18 -> configured as TDP
        READ_WIDTH_B => 9, -- 0-18 -> configured as TDP
        WRITE_WIDTH_A => 9, -- 0-18 -> configured as TDP
        WRITE_WIDTH_B => 9, -- 0-18 -> configured as TDP
        -- RSTREG_PRIORITY_A, RSTREG_PRIORITY_B: Reset or enable priority ("RSTREG", "REGCE")
        RSTREG_PRIORITY_A => "RSTREG",
        RSTREG_PRIORITY_B => "RSTREG",
        -- SRVAL_A, SRVAL_B: Set/reset value for output
        SRVAL_A => "000000000000000000",
        SRVAL_B => "000000000000000000",
        -- Sleep Async: Sleep function asynchronous or synchronous ("TRUE", "FALSE")
        SLEEP_ASYNC => "FALSE",
        -- WriteMode: "WRITE_FIRST", "NO_CHANGE", "READ_FIRST"
        WRITE_MODE_A => "NO_CHANGE",
        WRITE_MODE_B => "NO_CHANGE"
    )
    port map (
        -- Cascade Signals outputs: Multi-BRAM cascade signals
        CASDOUTA                    => open         , -- 16-bit output: Port A cascade output data
        CASDOUTB                    => open         , -- 16-bit output: Port B cascade output data
        CASDOUTPA                   => open         , -- 2-bit output: Port A cascade output parity data
        CASDOUTPB                   => open         , -- 2-bit output: Port B cascade output parity data
        -- Port A Data outputs: Port A data
        DOUTADOUT(7 downto 0)       => BR_DO        , -- 16-bit output: Port A data/LSB data
        DOUTADOUT(15 downto 8)      => BR_DO_unused ,
        DOUTPADOUTP                 => open         , -- 2-bit output: Port A parity/LSB parity
        -- Port B Data outputs: Port B data
        DOUTBDOUT                   => open         , -- 16-bit output: Port B data/MSB data
        DOUTPBDOUTP                 => open         , -- 2-bit output: Port B parity/MSB parity
        -- Cascade Signals inputs: Multi-BRAM cascade signals
        CASDIMUXA                   => '0'          , -- 1-bit input: Port A input data (0=DINA, 1=CASDINA)
        CASDIMUXB                   => '0'          , -- 1-bit input: Port B input data (0=DINB, 1=CASDINB)
        CASDINA                     => X"0000"      , -- 16-bit input: Port A cascade input data
        CASDINB                     => X"0000"      , -- 16-bit input: Port B cascade input data
        CASDINPA                    => "00"         , -- 2-bit input: Port A cascade input parity data
        CASDINPB                    => "00"         , -- 2-bit input: Port B cascade input parity data
        CASDOMUXA                   => '0'          , -- 1-bit input: Port A unregistered data (0=BRAM data, 1=CASDINA)
        CASDOMUXB                   => '0'          , -- 1-bit input: Port B unregistered data (0=BRAM data, 1=CASDINB)
        CASDOMUXEN_A                => '1'          , -- 1-bit input: Port A unregistered output data enable
        CASDOMUXEN_B                => '1'          , -- 1-bit input: Port B unregistered output data enable
        CASOREGIMUXA                => '0'          , -- 1-bit input: Port A registered data (0=BRAM data, 1=CASDINA)
        CASOREGIMUXB                => '0'          , -- 1-bit input: Port B registered data (0=BRAM data, 1=CASDINB)
        CASOREGIMUXEN_A             => '1'          , -- 1-bit input: Port A registered output data enable
        CASOREGIMUXEN_B             => '1'          , -- 1-bit input: Port B registered output data enable
        -- Port A Address/Control Signals inputs: Port A address and control signals
        ADDRARDADDR(13 downto 3)    => RDADDR       , -- 14-bit input: A/Read port address
        ADDRARDADDR(2 downto 0)     => "000"        , -- 14-bit input: A/Read port address
        ADDRENA                     => '1'          , -- 1-bit input: Active-High A/Read port address enable
        CLKARDCLK                   => CLKDIV       , -- 1-bit input: A/Read port clock
        ENARDEN                     => RDEN         , -- 1-bit input: Port A enable/Read enable
        REGCEAREGCE                 => '0'          , -- 1-bit input: Port A register enable/Register enable
        RSTRAMARSTRAM               => CLKDIV_RESET , -- 1-bit input: Port A set/reset
        RSTREGARSTREG               => CLKDIV_RESET , -- 1-bit input: Port A register set/reset
        WEA                         => "00"         , -- 2-bit input: Port A write enable
        -- Port A Data inputs: Port A data
        DINADIN                     => X"0000"      , -- 16-bit input: Port A data/LSB data
        DINPADINP                   => "00"         , -- 2-bit input: Port A parity/LSB parity
        -- Port B Address/Control Signals inputs: Port B address and control signals
        ADDRBWRADDR(10 downto 0)    => WRADDR       , -- 14-bit input: B/Write port address
        ADDRBWRADDR(13 downto 11)   => "000"        , -- 14-bit input: B/Write port address
        ADDRENB                     => '1'          , -- 1-bit input: Active-High B/Write port address enable
        CLKBWRCLK                   => CLKDIV       , -- 1-bit input: B/Write port clock
        ENBWREN                     => WE(0)        , -- 1-bit input: Port B enable/Write enable
        REGCEB                      => '0'          , -- 1-bit input: Port B register enable
        RSTRAMB                     => CLKDIV_RESET , -- 1-bit input: Port B set/reset
        RSTREGB                     => CLKDIV_RESET , -- 1-bit input: Port B register set/reset
        SLEEP                       => '0'          , -- 1-bit input: Sleep Mode
        WEBWE                       => "0000"       , -- 4-bit input: Port B write enable/Write enable
        -- Port B Data inputs: Port B data
        DINBDIN(7 downto 0)         => BR_DI        , -- 16-bit input: Port B data/MSB data
        DINBDIN(15 downto 8)        => X"00"        ,
        DINPBDINP                   => "00"           -- 2-bit input: Port B parity/MSB parity
    );
-- End of RAMB18E2_inst instantiation
end generate;

--defaults
--future use
WE                      <= "0";
WRADDR                  <= (others => '0');
WREN                    <= '0';
BR_DI                   <= (others => '0');
REGCE                   <= '0';

RDADDR(10 downto 9)     <= (others => '0') when CONCAT_MODE='0' else DWCLK_SYNC_IN(10 downto 9);
RDADDR(8 downto 6)      <= datawidth_select when CONCAT_MODE='0' else DWCLK_SYNC_IN(8 downto 6);
RDADDR(5 downto 3)      <= shift_address when CONCAT_MODE='0' else DWCLK_SYNC_IN(5 downto 3);
RDADDR(2 downto 0)      <= cycle_address when CONCAT_MODE='0' else DWCLK_SYNC_IN(2 downto 0);
RDEN                    <= not CLKDIV_RESET;

DWCLK_SYNC_OUT(10 downto 9)     <= (others => '0');
DWCLK_SYNC_OUT(8 downto 6)      <= datawidth_select;
DWCLK_SYNC_OUT(5 downto 3)      <= shift_address;
DWCLK_SYNC_OUT(2 downto 0)      <= cycle_address;

-- This process selects the datawidth length, this is put into a process to limit the number of possiblilities for easier synth
padding <= padding_max(17 downto 18-MAX_DATAWIDTH);

Datawidth_select_pr: process(CLKDIV)
begin
    if (CLKDIV'event and CLKDIV = '1') then
        case DATAWIDTH is
            when 6 =>
                datawidth_select      <= "110";
                padding_max(11 downto 0)  <= (others => '1');
                padding_max(17 downto 12) <= (others => '0');
            when 8 =>
                datawidth_select      <= "000";
                padding_max(9 downto 0)   <= (others => '1');
                padding_max(17 downto 10) <= (others => '0');
            when 10 =>
                datawidth_select      <= "001";
                padding_max(7 downto 0)   <= (others => '1');
                padding_max(17 downto 8)  <= (others => '0');
            when 12 =>
                datawidth_select      <= "010";
                padding_max(5 downto 0)   <= (others => '1');
                padding_max(17 downto 6)  <= (others => '0');
            when 14 =>
                datawidth_select      <= "011";
                padding_max(3 downto 0)   <= (others => '1');
                padding_max(17 downto 4)  <= (others => '0');
            when 16 =>
                datawidth_select      <= "100";
                padding_max(1 downto 0)   <= (others => '1');
                padding_max(17 downto 2)  <= (others => '0');
            when 18 =>
                datawidth_select      <= "101";
                padding_max(17 downto 0)  <= (others => '0');
            when others =>
                datawidth_select     <= "000";
                padding_max(7 downto 0)  <= (others => '1');
                padding_max(15 downto 8) <= (others => '0');
        end case;
    end if;
end process;

--data pipe
concat_serdes: process(CLKDIV)
begin
    if (CLKDIV'event and CLKDIV = '1') then
        Serdes_Pipe(0) <= ISERDES_DATA;
        for i in 0 to 2 loop
            Serdes_Pipe(i+1) <=  Serdes_Pipe(i);
        end loop;
    end if;
end process;

Serdes_concat <= Serdes_Pipe(3) & Serdes_Pipe(2) & Serdes_Pipe(1) & Serdes_Pipe(0);

SHIFT_STATUS <= datawidth_select & shift_address;

readout_pipe_process: process(CLKDIV)
begin
    if (CLKDIV'event and CLKDIV = '1') then
        if (CLKDIV_RESET = '1' or BITSLIP_RESET = '1') then
            --blockram ports
            shift_address           <= (others => '0');
            cycle_address           <= (others => '0');

            CONCATINATED_VALID      <= '0';
            CONCATINATED_DATA       <= (others => '0');

            iserdes_bitslip_r       <= '0';
            cycle_skip              <= '0';

            cnt_bitslip             <= (others => '0');
        else
            if (BITSLIP = '1') then
                iserdes_bitslip_r    <= '1';
                cnt_bitslip          <= cnt_bitslip + '1';
            end if;

            cycle_skip       <= '0';

            if (iserdes_bitslip_r = '1' and cycle_reset = '1') then
                iserdes_bitslip_r <= '0';
                if (shift_address= std_logic_vector(to_unsigned((SERDES_DATAWIDTH-1),3))) then
                    shift_address    <= (others => '0');
                    cycle_skip       <= '1';
                else
                    shift_address <= shift_address + '1';
                end if;
             end if;

             if  (cycle_reset = '1')  then
                 cycle_address  <=  "000";
             elsif (cycle_skip = '1') then
                 cycle_address <= cycle_address;
             else
                 cycle_address <= cycle_address + '1';
             end if;

             CONCATINATED_VALID  <= cycle_valid;
             for i in 0 to MAX_DATAWIDTH-1 loop
                 if padding(i) = '1' then
                     CONCATINATED_DATA(i) <= '0';
                 else
                     case BR_DO(2 downto 0) is
                         when "000" =>
                            CONCATINATED_DATA(i)    <= Serdes_concat(SERDES_DATAWIDTH+i);
                         when "001" =>
                            CONCATINATED_DATA(i)    <= Serdes_concat(SERDES_DATAWIDTH-1+i);
                         when "010" =>
                            CONCATINATED_DATA(i)    <= Serdes_concat(SERDES_DATAWIDTH-2+i);
                         when "011" =>
                            CONCATINATED_DATA(i)    <= Serdes_concat(SERDES_DATAWIDTH-3+i);
                         when "100" =>
                            CONCATINATED_DATA(i)    <= Serdes_concat(SERDES_DATAWIDTH-4+i);
                         when "101" =>
                            CONCATINATED_DATA(i)    <= Serdes_concat(SERDES_DATAWIDTH-5+i);
                         when "110" =>
                            if (SERDES_DATAWIDTH=8) then
                                CONCATINATED_DATA(i)    <= Serdes_concat(SERDES_DATAWIDTH-6+i);
                            else
                                CONCATINATED_DATA(i)    <= '0';
                            end if;
                         when "111" =>
                            if (SERDES_DATAWIDTH=8) then
                                 CONCATINATED_DATA(i)    <= Serdes_concat(SERDES_DATAWIDTH-7+i);
                            else
                                CONCATINATED_DATA(i)    <= '0';
                            end if;
                         when others =>
                                CONCATINATED_DATA(i)     <= '0';
                     end case;
                 end if;
             end loop;
        end if;
    end if;
end process;

end rtl;
