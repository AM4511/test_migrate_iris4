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
entity iserdes_mux_wordalign is
  generic(
        MAX_DATAWIDTH           : integer := 18;
        CHANNEL_COUNT           : integer := 2;
        NROF_CONN               : integer := 10
       );
  port(
        CLOCK                       : in    std_logic;
        RESET                       : in    std_logic;

        START_ALIGN                 : in    std_logic;
        BUSY_ALIGN                  : out   std_logic := '0';

        START_WORDALIGN             : out   std_logic := '0';
        BUSY_WORDALIGN              : in    std_logic;

        ENABLE_TRAINING             : in    std_logic_vector(NROF_CONN-1 downto 0);

        --muxed io
        BITSLIP_mux                 : in    std_logic_vector((CHANNEL_COUNT)-1 downto 0);
        BITSLIP_RESET_mux           : in    std_logic_vector((CHANNEL_COUNT)-1 downto 0);
        CONCATINATED_VALID_mux      : out   std_logic_vector((CHANNEL_COUNT)-1 downto 0)  := (others => '0');
        CONCATINATED_DATA_mux       : out   std_logic_vector((CHANNEL_COUNT*MAX_DATAWIDTH)-1 downto 0)  := (others => '0');

        --muxed status info
        WORD_ALIGN_mux              : in    std_logic;
        SLIP_COUNT_mux              : in    std_logic_vector(7 downto 0);

        -- all io
        BITSLIP_all                 : out   std_logic_vector((CHANNEL_COUNT*NROF_CONN)-1 downto 0)  := (others => '0');
        BITSLIP_RESET_all           : out   std_logic_vector((CHANNEL_COUNT*NROF_CONN)-1 downto 0)  := (others => '0');
        CONCATINATED_VALID_all      : in    std_logic_vector((CHANNEL_COUNT*NROF_CONN)-1 downto 0);
        CONCATINATED_DATA_all       : in    std_logic_vector((CHANNEL_COUNT*MAX_DATAWIDTH*NROF_CONN)-1 downto 0);

        --all status info
        WORD_ALIGN_all              : out   std_logic_vector(NROF_CONN-1 downto 0) := (others => '0');
        SLIP_COUNT_all              : out   std_logic_vector((NROF_CONN*8)-1 downto 0) := (others => '0')
    );
end iserdes_mux_wordalign;

architecture rtl of iserdes_mux_wordalign is

type muxseqstatetp is ( idle,
                        check_word_align,
                        start_word_align,
                        word_align,
                        word_aligned
                        );

signal muxseqstate     : muxseqstatetp := idle;

signal channel_address : integer range 0 to NROF_CONN-1 := 0;
signal channel_address_r : integer range 0 to NROF_CONN-1 := 0;

signal update_status    : std_logic := '0';
signal reset_status     : std_logic := '0';

attribute equivalent_register_removal : string;
attribute shreg_extract : string;
attribute register_duplication: string;
attribute max_fanout: string;
attribute use_dsp48: string;

attribute max_fanout of channel_address_r: signal is "32";
attribute register_duplication of channel_address_r : signal is "yes";
attribute equivalent_register_removal of channel_address_r: signal is "no";
attribute shreg_extract of channel_address_r : signal is "no";
attribute use_dsp48 of channel_address_r: signal is "no";

begin

--channel sequencer
sequencer: process(CLOCK)
  begin
    if (CLOCK'event and CLOCK = '1') then

        START_WORDALIGN  <= '0';

        update_status <= '0';
        reset_status  <= '0';

        case muxseqstate is
            when idle =>
                BUSY_ALIGN          <= '0';
                if (START_ALIGN = '1') then
                    reset_status        <= '1';
                    BUSY_ALIGN          <= '1';
                    channel_address     <= 0;
                    muxseqstate         <= check_word_align;
                end if;

--states for align
            when check_word_align =>
                if (ENABLE_TRAINING(channel_address) = '1') then
                    START_WORDALIGN  <= '1';
                    muxseqstate         <= start_word_align;
                elsif (channel_address = NROF_CONN-1) then
                    channel_address <= 0;
                    muxseqstate <= idle;
                else
                    channel_address <= channel_address + 1;
                    muxseqstate <= check_word_align;
                end if;

            when start_word_align =>
                if (BUSY_WORDALIGN = '1') then
                    muxseqstate <= word_align;
                end if;

            when word_align =>
                if (BUSY_WORDALIGN = '0') then
                    update_status <= '1';
                    muxseqstate <= word_aligned;
                end if;

            when word_aligned =>
                if (channel_address = NROF_CONN-1) then
                    channel_address <= 0;
                    muxseqstate <= idle;
                else
                    channel_address <= channel_address + 1;
                    muxseqstate <= check_word_align;
                end if;

            when others =>
                muxseqstate         <= idle;

        end case;

    end if;
end process sequencer;


multiplexer: process(CLOCK)
  begin
    if (CLOCK'event and CLOCK = '1') then
        channel_address_r <= channel_address;

        if reset_status = '1' then
            WORD_ALIGN_all <= (others => '0');
            SLIP_COUNT_all <= (others => '0');
        elsif (update_status = '1') then
            WORD_ALIGN_all(channel_address_r) <= WORD_ALIGN_mux;
            SLIP_COUNT_all((8*channel_address_r)+7 downto (8*channel_address_r)) <= SLIP_COUNT_mux;
        end if;

        BITSLIP_all((CHANNEL_COUNT*channel_address_r)+(CHANNEL_COUNT)-1 downto (CHANNEL_COUNT*channel_address_r)) <= BITSLIP_mux;
        BITSLIP_RESET_all((CHANNEL_COUNT*channel_address_r)+(CHANNEL_COUNT)-1 downto (CHANNEL_COUNT*channel_address_r)) <= BITSLIP_RESET_mux;

        CONCATINATED_VALID_mux <= CONCATINATED_VALID_all((CHANNEL_COUNT*channel_address_r)+(CHANNEL_COUNT)-1 downto (CHANNEL_COUNT*channel_address_r));
        for i in 0 to NROF_CONN-1 loop
            if i = channel_address_r then
                CONCATINATED_DATA_mux <= CONCATINATED_DATA_all((CHANNEL_COUNT*MAX_DATAWIDTH*i)+(CHANNEL_COUNT*MAX_DATAWIDTH)-1 downto (CHANNEL_COUNT*MAX_DATAWIDTH*i));
            end if;
        end loop;
    end if;
end process multiplexer;

end rtl;
