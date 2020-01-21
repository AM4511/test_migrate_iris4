-- *********************************************************************
-- Copyright 2014, ON Semiconductor Corporation.
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


-------------------
-- LIBRARY USAGE --
-------------------
--common:
---------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
--user:
-----------
library work;
use work.all;

-----------------------
-- ENTITY DEFINITION --
-----------------------
entity crc_checker is
  generic (
        gMax_Datawidth     : integer := 12;
        gNrOf_DataConn     : integer := 12;
        POLYNOMIAL         : std_logic_vector := "10001000000100001";
        gUSE_CRC_TOOL      : boolean := TRUE
  );
  port (
        -- Control signals
        CLOCK                       : in    std_logic;
        RESET                       : in    std_logic;

        en_decoder                  : in    std_logic;
        DATAWIDTH                   : in    std_logic_vector(3 downto 0);

        CHANNELS_ENABLE             : in    std_logic_vector(gNrOf_DataConn-1 downto 0);
        CRC_LANE_ENABLE             : in    std_logic;
        CRC_FRAME_ENABLE            : in    std_logic;
        MSB_FIRST                   : in    std_logic;

        FRAME_START                 : in    std_logic;
        FRAME_END                   : in    std_logic;
        LINE_START                  : in    std_logic;
        LINE_END                    : in    std_logic;

        -- Data input
        PAR_DATA_IN                 : in    std_logic_vector((gNrOf_DataConn*gMax_Datawidth)-1 downto 0);
        PAR_DATA_VALID_IN           : in    std_logic;

        PAR_DATA_IMGVALID_IN        : in    std_logic;
        PAR_DATA_EMBVALID_IN        : in    std_logic;

        PAR_DATA_FRAME_IN           : in    std_logic;
        PAR_DATA_LINE_IN            : in    std_logic;

        PAR_DATA_SYNC_START_IN      : in    std_logic;
        PAR_DATA_SYNC_END_IN        : in    std_logic;

        PAR_DATA_WINDOW_IN          : in    std_logic;

        PAR_DATA_FILL_VALID_IN      : in    std_logic;
        PAR_DATA_CRCLANE_VALID_IN   : in    std_logic; -- compare flag
        PAR_CALC_CRCLANE_VALID_IN   : in    std_logic; -- calc valid window

        -- Data out
        PAR_DATA_OUT                : out   std_logic_vector((gNrOf_DataConn*gMax_Datawidth)-1 downto 0) := (others => '0');
        PAR_DATA_VALID_OUT          : out   std_logic := '0';

        PAR_DATA_IMGVALID_OUT       : out   std_logic := '0';
        PAR_DATA_EMBVALID_OUT       : out   std_logic := '0';

        PAR_DATA_FRAME_OUT          : out   std_logic := '0';
        PAR_DATA_LINE_OUT           : out   std_logic := '0';

        PAR_DATA_SYNC_START_OUT     : out   std_logic := '0';
        PAR_DATA_SYNC_END_OUT       : out   std_logic := '0';

        PAR_DATA_WINDOW_OUT         : out   std_logic := '0';

        PAR_DATA_FILL_VALID_OUT     : out   std_logic := '0';
        PAR_DATA_CRCLANE_VALID_OUT  : out   std_logic := '0';
        PAR_CALC_CRCLANE_VALID_OUT  : out   std_logic := '0';

        FRAME_START_OUT             : out    std_logic := '0';
        LINE_START_OUT              : out    std_logic := '0';
        LINE_END_OUT                : out    std_logic :=  '0';

        -- Frame crc checksum output:
        FRAME_CRC_CHECKSUM          : out   std_logic_vector((gNrOf_DataConn*16)-1 downto 0) := (others => '0');

        --status
        CRC_STATUS                  : out   std_logic_vector(gNrOf_DataConn-1 downto 0) := (others => '0')
        );
end crc_checker;

---------------------------
-- BEHAVIOUR DESCRIPTION --
---------------------------
architecture rtl of crc_checker is

component crc_calc
  generic (
       gMax_Datawidth     : integer := 10;
       POLYNOMIAL         : std_logic_vector := "10001000000100001"
  );
  port ( -- System
       CLOCK              : in    std_logic;
       RESET              : in    std_logic;

       MSB_FIRST        : in    std_logic;
       -- Data input
       EN_DECODER       : in    std_logic;
       INIT             : in    std_logic;
       DATAWIDTH        : in    integer;
       DATA_IN_VALID    : in    std_logic;
       FRAME_VALID      : in    std_logic;
       CRCLANE_VALID_IN : in    std_logic;

       DATA_IN          : in    std_logic_vector(gMax_Datawidth-1 downto 0);
       CRC_OUT          : out   std_logic_vector(15 downto 0);
       SENSOR_CRC       : out   std_logic_vector(15 downto 0) := (others => '0');

       CRC_FRAME_ENABLE     : in    std_logic;
       FRAME_CRC_CHECKSUM   : out   std_logic_vector(15 downto 0)
       );
end component;

component crc_comp
  generic (
       gMax_Datawidth     : integer := 10
  );
  port ( -- System
       CLOCK             : in    std_logic;
       RESET             : in    std_logic;

       -- Data input
       en_decoder        : in    std_logic;
       VALID             : in    std_logic;

       SENS_CRC_IN       : in    std_logic_vector(15 downto 0);
       CALC_CRC_IN       : in    std_logic_vector(15 downto 0);

       STATUS            : out   std_logic
       );
end component;

--signals
constant    c_pipe_depth    : integer := 15;

signal FrameStartPipe    : std_logic_vector(0 to c_pipe_depth) := (others => '0');

type CRCcheckstatetp is (   Idle,
                            Valid
                        );

signal CRCcheckstate : CRCcheckstatetp;


signal datawidth_int    : integer range 10 to 12;

signal init             : std_logic := '0';
signal valid_comp       : std_logic := '0';
signal crc_status_comp  : std_logic_vector(gNrOf_DataConn-1 downto 0) := (others => '0');
signal sensor_crc       : std_logic_vector((gNrOf_DataConn*16)-1 downto 0) := (others => '0');

signal calc_CRC         : std_logic_vector((gNrOf_DataConn*16)-1 downto 0) := (others => '0');

signal PAR_DATA_int                 : std_logic_vector((gNrOf_DataConn*gMax_Datawidth)-1 downto 0) := (others => '0');
signal PAR_DATA_VALID_int           : std_logic := '0';
signal PAR_DATA_IMGVALID_int        : std_logic := '0';
signal PAR_DATA_EMBVALID_int        : std_logic := '0';

signal PAR_DATA_FRAME_int           : std_logic := '0';
signal PAR_DATA_LINE_int            : std_logic := '0';
signal PAR_DATA_SYNC_START_int      : std_logic := '0';
signal PAR_DATA_SYNC_END_int        : std_logic := '0';
signal PAR_DATA_WINDOW_int          : std_logic := '0';
signal PAR_DATA_FILL_VALID_int      : std_logic := '0';
signal PAR_DATA_CRCLANE_VALID_int   : std_logic := '0';
signal PAR_CALC_CRCLANE_VALID_int   : std_logic := '0';
signal FRAME_START_int              : std_logic := '0';
signal LINE_START_int               : std_logic := '0';
signal LINE_END_int                 : std_logic :='0';

type CompareStatetp is ( Idle, FrameCrc, LaneCrc, Valid1, Valid2 );
signal CrcCompareState     : CompareStatetp := Idle;


begin

CRC_STATUS    <= crc_status_comp and CHANNELS_ENABLE; -- masking non-used datachannels status

datawidth_select: process(CLOCK)
begin
    if (CLOCK'event and CLOCK = '1') then
        if (DATAWIDTH(3 downto 0) = "1010") then
            datawidth_int <= 10;
        elsif (DATAWIDTH(3 downto 0) = "1100") then
            datawidth_int <= 12;
        else
            datawidth_int <= 12;
        end if;

    end if;
end process;



-- Pipeline
pr_DataPipe: process(CLOCK)
begin
    if (CLOCK'event and CLOCK = '1') then

        for i in 0 to (FrameStartPipe'high-1) loop
            FrameStartPipe(i+1) <= FrameStartPipe(i);
        end loop;
        FrameStartPipe(0) <= FRAME_START;

    end if;

end process;

-- generate parallel CRC checkers
generate_CRC: for i in 0 to (gNrOf_DataConn-1) generate

the_crc_calc: crc_calc
  generic map(
       gMax_Datawidth       => gMax_Datawidth   ,
       POLYNOMIAL           => POLYNOMIAL
  )
  port map(
       CLOCK           => CLOCK           ,
       RESET           => RESET           ,

       MSB_FIRST       => MSB_FIRST,

       EN_DECODER      => EN_DECODER,
       INIT            => init            ,
       DATAWIDTH       => datawidth_int   ,
       DATA_IN_VALID   => PAR_CALC_CRCLANE_VALID_IN,
       FRAME_VALID     => PAR_DATA_FRAME_IN,
       CRCLANE_VALID_IN     => PAR_DATA_CRCLANE_VALID_IN,
       DATA_IN         => PAR_DATA_IN((i*gMax_Datawidth)+(gMax_Datawidth-1) downto (i*gMax_Datawidth))    ,
       CRC_OUT         => calc_crc((i*16)+15 downto (i*16)),
       SENSOR_CRC      => sensor_crc((i*16)+15 downto (i*16)),

       CRC_FRAME_ENABLE     => CRC_FRAME_ENABLE,
       FRAME_CRC_CHECKSUM   => FRAME_CRC_CHECKSUM((i*16)+15 downto (i*16))
       );

the_crc_comp: crc_comp
  generic map(
       gMax_Datawidth  => gMax_Datawidth
  )
  port map(
       CLOCK           => CLOCK                    ,
       RESET           => RESET                    ,

       en_decoder      => en_decoder               ,
       VALID           => valid_comp               ,

       SENS_CRC_IN     => sensor_crc((i*16)+15 downto (i*16)),
       CALC_CRC_IN     => calc_crc((i*16)+15 downto (i*16))       ,

       STATUS          => crc_status_comp(i)
  );

end generate;

CtrlProcess: process(RESET, CLOCK)
begin
    if (RESET = '1') then
        init                <= '0';
        valid_comp          <= '0';

    elsif(CLOCK'event and CLOCK = '1') then

        init            <= '0';
        valid_comp      <= '0';

        if (en_decoder ='1') then

            -- start pulse calculation
            if ((CRC_FRAME_ENABLE = '1' and FRAME_START = '1' ) or (CRC_LANE_ENABLE = '1' and LINE_START = '1' )) then
                init           <= '1';
            end if;


            -- compare sensor and calculated crc
            case CrcCompareState is
                when Idle =>
                    if (CRC_FRAME_ENABLE = '1') then
                        CrcCompareState <= FrameCrc;
                    elsif (CRC_LANE_ENABLE = '1') then
                        CrcCompareState <= LaneCrc;
                    end if;

                when FrameCrc =>
                    if (FRAME_END = '1') then
                        CrcCompareState <= Valid1;
                    end if;

                 when LaneCrc =>
                    CrcCompareState <= Valid1;

                when Valid1 =>
                    if (PAR_DATA_CRCLANE_VALID_IN = '1') then
                        CrcCompareState <= Valid2;
                    end if;

                when Valid2 =>
                    if (PAR_DATA_CRCLANE_VALID_IN = '1') then
                        if (CRC_LANE_ENABLE = '1') then
                            valid_comp  <= '1';
                            CrcCompareState <= Idle;
                        end if;
                    end if;

                when others =>
                    CrcCompareState <= Idle;
            end case;

        else
            CrcCompareState <= Idle;
        end if;


    end if;

end process;


-- fixme: correct output signal pipe
DataProcess: process(RESET, CLOCK)
begin

    if (CLOCK'event and CLOCK = '1') then

        PAR_DATA_int             <= PAR_DATA_IN;
        PAR_DATA_OUT             <= PAR_DATA_int;

        LINE_START_int           <= LINE_START;
        LINE_START_OUT           <= LINE_START_int;
        LINE_END_int             <= LINE_END;
        LINE_END_OUT             <= LINE_END_int;
        FRAME_START_int          <= FRAME_START;
        FRAME_START_OUT          <= FRAME_START_int;

        PAR_DATA_VALID_int       <= PAR_DATA_VALID_IN;
        PAR_DATA_IMGVALID_int    <= PAR_DATA_IMGVALID_IN;
        PAR_DATA_EMBVALID_int    <= PAR_DATA_EMBVALID_IN;

        PAR_DATA_VALID_OUT       <= PAR_DATA_VALID_int;
        PAR_DATA_IMGVALID_OUT    <= PAR_DATA_IMGVALID_int;
        PAR_DATA_EMBVALID_OUT    <= PAR_DATA_EMBVALID_int;

        PAR_DATA_FRAME_int          <= PAR_DATA_FRAME_IN;
        PAR_DATA_LINE_int           <= PAR_DATA_LINE_IN;
        PAR_DATA_SYNC_START_int     <= PAR_DATA_SYNC_START_IN;
        PAR_DATA_SYNC_END_int       <= PAR_DATA_SYNC_END_IN;
        PAR_DATA_WINDOW_int         <= PAR_DATA_WINDOW_IN;
        PAR_DATA_FILL_VALID_int     <= PAR_DATA_FILL_VALID_IN;
        PAR_DATA_CRCLANE_VALID_int  <= PAR_DATA_CRCLANE_VALID_IN;
        PAR_CALC_CRCLANE_VALID_int  <= PAR_CALC_CRCLANE_VALID_IN;

        PAR_DATA_FRAME_OUT          <= PAR_DATA_FRAME_int;
        PAR_DATA_LINE_OUT           <= PAR_DATA_LINE_int;
        PAR_DATA_SYNC_START_OUT     <= PAR_DATA_SYNC_START_int;
        PAR_DATA_SYNC_END_OUT       <= PAR_DATA_SYNC_END_int;
        PAR_DATA_WINDOW_OUT         <= PAR_DATA_WINDOW_int;
        PAR_DATA_FILL_VALID_OUT     <= PAR_DATA_FILL_VALID_int;
        PAR_DATA_CRCLANE_VALID_OUT  <= PAR_DATA_CRCLANE_VALID_int;
        PAR_CALC_CRCLANE_VALID_OUT  <= PAR_CALC_CRCLANE_VALID_int;

    end if;

end process;

end rtl;




