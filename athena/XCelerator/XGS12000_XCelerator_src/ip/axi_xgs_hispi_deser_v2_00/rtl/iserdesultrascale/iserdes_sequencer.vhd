-- *********************************************************************
-- Copyright 2008, Cypress Semiconductor Corporation.
--
-- This software is owned by Cypress Semiconductor Corporation (Cypress)
-- and is protected by United States copyright laws and international
-- treaty provisions.  Therefore, you must treat this software like any
-- other copyrighted material (e.g., book, or musical recording), with
-- the exception that one copy may be made for personal use or
-- evaluation.  Reproduction, modification, translation, compilation, or
-- representation of this software in any other form (e.g., paper,
-- magnetic, optical, silicon, etc.) is prohibited without the express
-- written permission of Cypress.
--
-- Disclaimer: Cypress makes no warranty of any kind, express or
-- implied, with regard to this material, including, but not limited to,
-- the implied warranties of merchantability and fitness for a particular
-- purpose. Cypress reserves the right to make changes without further
-- notice to the materials described herein. Cypress does not assume any
-- liability arising out of the application or use of any product or
-- circuit described herein. Cypress' products described herein are not
-- authorized for use as components in life-support devices.
--
-- This software is protected by and subject to worldwide patent
-- coverage, including U.S. and foreign patents. Use may be limited by
-- and subject to the Cypress Software License Agreement.
--


-------------------
-- LIBRARY USAGE --
-------------------
--common:
---------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

-----------------------
-- ENTITY DEFINITION --
-----------------------
entity iserdes_sequencer is
  port(
        CLOCK                       : in    std_logic;
        RESET                       : in    std_logic;

        START_TRAINING              : in    std_logic;
        BUSY_TRAINING               : out   std_logic;

        START_BITALIGN              : out   std_logic;
        BUSY_BITALIGN               : in    std_logic;

        INHIBIT_BITALIGN            : in    std_logic;

        START_WORDALIGN             : out   std_logic;
        BUSY_WORDALIGN              : in    std_logic
    );
end iserdes_sequencer;

architecture rtl of iserdes_sequencer is

type seqstatetp is (    idle,
                        start_bit_align,
                        bit_align,
                        start_word_align,
                        word_align
                        );

signal seqstate     : seqstatetp;

begin

--channel sequencer
sequencer: process(RESET, CLOCK)
  begin
    if (RESET = '1') then

        START_BITALIGN      <= '0';
        START_WORDALIGN     <= '0';

        BUSY_TRAINING       <= '0';

        seqstate            <= idle;

    elsif (CLOCK'event and CLOCK = '1') then

        --START_BITALIGN      <= '0';
        START_WORDALIGN     <= '0';

        case seqstate is
            when idle =>
                BUSY_TRAINING          <= '0';
                if (START_TRAINING = '1') then
                    BUSY_TRAINING       <= '1';  
                    if (INHIBIT_BITALIGN = '0') then --test mode
                        START_BITALIGN   <= '1';
                        seqstate         <= start_bit_align;
                    else
                        START_WORDALIGN  <= '1';
                        seqstate         <= start_word_align;
                    end if;
                end if;

            when start_bit_align =>
                if (BUSY_BITALIGN = '1') then
                    START_BITALIGN      <= '0';
                    seqstate <= bit_align;
                end if;

            when bit_align =>
                if (BUSY_BITALIGN = '0') then
                    START_WORDALIGN <= '1';
                    seqstate <= start_word_align;
                end if;

            when start_word_align =>
                if (BUSY_WORDALIGN = '1') then
                    seqstate <= word_align;
                end if;

            when word_align =>
                if (BUSY_WORDALIGN = '0') then
                    seqstate <= idle;
                end if;

            when others =>
                seqstate         <= idle;

        end case;

    end if;
end process sequencer;


end rtl;