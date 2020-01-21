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

entity iserdes_skip is
    generic (
        NROF_CONN               : integer
    );
    port (
        CLOCK                       : in    std_logic;  --appclock
        RESET                       : in    std_logic;  --active high reset

        DATAWIDTH                   : in    integer;

        PAR_SKIP                    : out  std_logic_vector(NROF_CONN-1 downto 0);
        SLIP_COUNT                  : in   std_logic_vector((NROF_CONN*8)-1 downto 0)
    );
end iserdes_skip;

architecture rtl of iserdes_skip is



begin


PAR_SKIP <= (others => '0');

end rtl;
