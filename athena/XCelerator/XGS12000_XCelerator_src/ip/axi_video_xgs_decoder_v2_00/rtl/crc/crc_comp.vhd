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


-------------
-- LIBRARY --
-------------
--common:
---------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

-----------------------
-- ENTITY DEFINITION --
-----------------------
entity crc_comp is
  generic (
       gMax_Datawidth     : integer := 10
  );
  port ( -- System
       CLOCK              : in    std_logic;
       RESET              : in    std_logic;
       -- Data input
       en_decoder         : in    std_logic;
       VALID              : in    std_logic;

       SENS_CRC_IN        : in    std_logic_vector(15 downto 0);
       CALC_CRC_IN        : in    std_logic_vector(15 downto 0);

       STATUS             : out   std_logic := '1'
       );
end;

---------------------------
-- BEHAVIOUR DESCRIPTION --
---------------------------
architecture rtl of crc_comp is


-------------------------------
-- TYPE & SIGNAL DEFINITIONS --
-------------------------------

type CompareStatetp is (
                        Idle,
                        LookForFirstValid,
                        LookForNextValid,
                        Error
                    );

signal CompareState : CompareStatetp := Idle;

--------------------
-- MAIN BEHAVIOUR --
--------------------
begin

-- CRC detector
-- status 0 = OK, status 1 = ERROR
--
-- An error is generated either when:
-- 1. the system has not run yet (after reset)
-- 2. a CRC is detected but not equal to the calculated crc
-- 3. no CRC is detected while looking for one (when sync pattern is not decoded correctly, ie when no sensor is inserted)

-- this way


  CRCcomp:process(CLOCK)

  begin

    if (CLOCK'event and CLOCK = '1') then

        case CompareState is
            when Idle =>
                if (en_decoder = '1') then
                    CompareState    <= LookForFirstValid;
                    STATUS          <= '1';
                end if;

            when LookForFirstValid =>
                if (en_decoder = '1') then
                    if (VALID = '1') then
                        if (SENS_CRC_IN = CALC_CRC_IN) then
                            STATUS          <= '0';
                            CompareState    <= LookForNextValid;
                        else
                            STATUS          <= '1';
                            CompareState    <= Error;
                        end if;
                    end if;
                else
                    STATUS          <= '1';
                    CompareState    <= Idle;
                end if;

            when LookForNextValid =>
                if (en_decoder = '1') then
                    if (VALID = '1') then
                        if (SENS_CRC_IN = CALC_CRC_IN) then
                            STATUS          <= '0';
                        else
                            STATUS          <= '1';
                            CompareState    <= Error;
                        end if;
                    end if;
                else
                    CompareState    <= Idle;
                end if;


            when Error =>
                if (en_decoder = '0') then
                    CompareState    <= Idle;
                end if;

            when others =>
                CompareState    <= Idle;

        end case;

    end if;

  end process;

end rtl;
