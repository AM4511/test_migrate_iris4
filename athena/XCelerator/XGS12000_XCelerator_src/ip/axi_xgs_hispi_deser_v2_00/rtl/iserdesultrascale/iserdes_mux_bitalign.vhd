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
entity iserdes_mux_bitalign is
  generic(
        SERDES_DATAWIDTH        : integer := 6;
        CHANNEL_COUNT           : integer := 2;
        SERDES_COUNT            : integer := 2;
        TAP_COUNT_BITS          : integer := 8;
        NROF_CONN               : integer := 10
       );
  port(
        CLOCK                       : in    std_logic;
        RESET                       : in    std_logic;

        MONITOR_ENABLE              : in    std_logic;
        START_BITALIGN              : in    std_logic;
        BUSY_BITALIGN               : out   std_logic := '0';

        START_INITIALALIGN          : out   std_logic := '0';
        BUSY_INITIALALIGN           : in    std_logic;

        START_MONITOR               : out   std_logic := '0';
        BUSY_MONITOR                : in    std_logic;

        ALIGNMODE                   : in    std_logic; --select between align on one channel and align on all channels
        ALIGNCHANNEL                : in    std_logic_vector(7 downto 0);

        ENABLE_TRAINING             : in    std_logic_vector(NROF_CONN-1 downto 0);

        --muxed io
        IODELAY_ISERDES_RESET_mux   : in    std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        IODELAY_INC_mux             : in    std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        IODELAY_CE_mux              : in    std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        IODELAY_ENVTC_mux           : in    std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);
        ISERDES_BITSLIP_mux         : in    std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0);

        ISERDES_DATAOUT_mux         : out   std_logic_vector((CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH)-1 downto 0)  := (others => '0');

        --muxed status info
        EDGE_DETECT_mux             : in    std_logic;
        STABLE_DETECT_mux           : in    std_logic;
        FIRST_EDGE_FOUND_mux        : in    std_logic;
        SECOND_EDGE_FOUND_mux       : in    std_logic;
        NROF_RETRIES_mux            : in    std_logic_vector(15 downto 0);
        TAP_SETTING_mux             : in    std_logic_vector(TAP_COUNT_BITS-1 downto 0);
        WINDOW_WIDTH_mux            : in    std_logic_vector(TAP_COUNT_BITS-1 downto 0);
        TAP_DRIFT_OUT_mux           : in    std_logic_vector(TAP_COUNT_BITS-1 downto 0);
        TAP_DRIFT_IN_mux            : out   std_logic_vector(TAP_COUNT_BITS-1 downto 0) := (others => '0');
        TAP_COUNT_IN_mux            : out   std_logic_vector(TAP_COUNT_BITS-1 downto 0) := (others => '0');

        -- all io
        IODELAY_ISERDES_RESET_all   : out   std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT)-1 downto 0) := (others => '0');
        IODELAY_INC_all             : out   std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT)-1 downto 0) := (others => '0');
        IODELAY_CE_all              : out   std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT)-1 downto 0) := (others => '0');
        IODELAY_ENVTC_all           : out   std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT)-1 downto 0) := (others => '0');
        ISERDES_BITSLIP_all         : out   std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT)-1 downto 0) := (others => '0');

        ISERDES_DATAOUT_all         : in    std_logic_vector((NROF_CONN*CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH)-1 downto 0);

        --all status info
        EDGE_DETECT_all             : out   std_logic_vector(NROF_CONN-1 downto 0) := (others => '0');
        STABLE_DETECT_all           : out   std_logic_vector(NROF_CONN-1 downto 0) := (others => '0');
        FIRST_EDGE_FOUND_all        : out   std_logic_vector(NROF_CONN-1 downto 0) := (others => '0');
        SECOND_EDGE_FOUND_all       : out   std_logic_vector(NROF_CONN-1 downto 0) := (others => '0');
        NROF_RETRIES_all            : out   std_logic_vector((NROF_CONN*16)-1 downto 0) := (others => '0');
        TAP_SETTING_all             : out   std_logic_vector((NROF_CONN*TAP_COUNT_BITS)-1 downto 0) := (others => '0');
        WINDOW_WIDTH_all            : out   std_logic_vector((NROF_CONN*TAP_COUNT_BITS)-1 downto 0) := (others => '0');
        TAP_DRIFT_OUT_all           : out   std_logic_vector((NROF_CONN*TAP_COUNT_BITS)-1 downto 0) := (others => '0');
        TAP_DRIFT_IN_all            : in    std_logic_vector((NROF_CONN*TAP_COUNT_BITS)-1 downto 0)
    );
end iserdes_mux_bitalign;

architecture rtl of iserdes_mux_bitalign is

type muxseqstatetp is ( idlereset,
                        check_intial_align,
                        start_initial_align,
                        initial_align,
                        start_single_align,
                        single_align,
                        initial_aligned,
                        check_monitor_align,
                        start_monitor_align,
                        monitor_align
                        );

signal muxseqstate     : muxseqstatetp := idlereset;

signal channel_address : integer range 0 to NROF_CONN-1 := 0;
signal channel_address_r : integer range 0 to NROF_CONN-1 := 0;

signal select_all_ctrl : std_logic := '0';

signal update_status        : std_logic := '0';
signal update_mon_status    : std_logic := '0';
signal reset_status         : std_logic := '0';

signal tap_setting_i   : std_logic_vector((NROF_CONN*TAP_COUNT_BITS)-1 downto 0) := (others => '0');

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

        START_INITIALALIGN  <= '0';
        START_MONITOR       <= '0';

        update_status       <= '0';
        update_mon_status   <= '0';
        reset_status        <= '0';

        case muxseqstate is
            when idlereset =>
                BUSY_BITALIGN       <= '0';
                if (START_BITALIGN = '1') then
                    BUSY_BITALIGN       <= '1';
                    reset_status        <= '1';
                    if (ALIGNMODE = '0') then
                        channel_address     <= 0;
                        muxseqstate         <= check_intial_align;
                    else
                        channel_address     <= to_integer(unsigned(ALIGNCHANNEL));
                        START_INITIALALIGN  <= '1';
                        select_all_ctrl     <= '1';
                        muxseqstate         <= start_single_align;
                    end if;
                end if;

--states for align on all channels
            when check_intial_align =>
                if (ENABLE_TRAINING(channel_address) = '1') then
                    select_all_ctrl     <= '0';
                    START_INITIALALIGN  <= '1';
                    muxseqstate         <= start_initial_align;
                elsif (channel_address = NROF_CONN-1) then
                    muxseqstate <= initial_aligned;
                else
                    channel_address     <= channel_address + 1;
                    muxseqstate         <= check_intial_align;
                end if;

            when start_initial_align =>
                if (BUSY_INITIALALIGN = '1') then
                    muxseqstate <= initial_align;
                end if;

            when initial_align =>
                if (BUSY_INITIALALIGN = '0') then
                    if (channel_address = NROF_CONN-1) then
                        channel_address <= 0;
                        update_status <= '1';
                        muxseqstate <= initial_aligned;
                    else
                        update_status <= '1';
                        channel_address <= channel_address + 1;
                        muxseqstate <= check_intial_align;
                   end if;
                end if;

--states for align on one channel
            when start_single_align =>
                if (BUSY_INITIALALIGN = '1') then
                    muxseqstate <= single_align;
                end if;

            when single_align =>
                if (BUSY_INITIALALIGN = '0') then
                    update_status <= '1';
                    muxseqstate <= initial_aligned;
                end if;

--after initial align
            when initial_aligned =>
                if (START_BITALIGN = '1') then
                    BUSY_BITALIGN       <= '1';
                    if (ALIGNMODE = '0') then
                        select_all_ctrl     <= '0';
                        channel_address     <= 0;
                        reset_status        <= '1';
                        muxseqstate         <= check_intial_align;
                    else
                        select_all_ctrl     <= '1';
                        channel_address     <= to_integer(unsigned(ALIGNCHANNEL));
                        START_INITIALALIGN  <= '1';
                        reset_status        <= '1';
                        muxseqstate         <= start_single_align;
                    end if;
                elsif (SERDES_COUNT > 1 and MONITOR_ENABLE = '1') then
                    BUSY_BITALIGN <= '0'; --FIXME: is window align allowed to run during word align without busy indication???
                    channel_address <= 0;
                    select_all_ctrl     <= '0';
                    muxseqstate <= check_monitor_align;
                else
                    BUSY_BITALIGN       <= '0';
                end if;

-- states for monitor align
            when check_monitor_align =>
                if (ENABLE_TRAINING(channel_address) = '1') then
                    select_all_ctrl     <= '0';
                    START_MONITOR       <= '1';
                    muxseqstate         <= start_monitor_align;
                elsif (channel_address = NROF_CONN-1) then
                    channel_address     <= 0;
                    update_mon_status   <= '1';
                    muxseqstate         <= initial_aligned;
                else
                    channel_address     <= channel_address + 1;
                    muxseqstate         <= check_monitor_align;
                end if;

            when start_monitor_align =>
                if (BUSY_MONITOR = '1') then
                    muxseqstate <= monitor_align;
                end if;

            when monitor_align =>
                if (BUSY_MONITOR = '0') then
                    if (channel_address = NROF_CONN-1) then
                        channel_address     <= 0;
                        update_mon_status   <= '1';
                        muxseqstate         <= initial_aligned;
                    else
                        update_mon_status   <= '1';
                        channel_address     <= channel_address + 1;
                        muxseqstate         <= check_monitor_align;
                   end if;
                end if;

            when others =>
                muxseqstate         <= idlereset;

        end case;

    end if;
end process sequencer;

TAP_SETTING_all <= tap_setting_i;

multiplexer: process(CLOCK)
  begin
    if (CLOCK'event and CLOCK = '1') then

        channel_address_r   <= channel_address;

        if (reset_status = '1') then
            EDGE_DETECT_all <= (others => '0');
            STABLE_DETECT_all <= (others => '0');
            FIRST_EDGE_FOUND_all <= (others => '0');
            SECOND_EDGE_FOUND_all <= (others => '0');
            NROF_RETRIES_all <= (others => '0');
            tap_setting_i <= (others => '0');
            WINDOW_WIDTH_all <= (others => '0');
        elsif (update_status = '1') then
            EDGE_DETECT_all(channel_address_r) <= EDGE_DETECT_mux;
            STABLE_DETECT_all(channel_address_r) <= STABLE_DETECT_mux;
            FIRST_EDGE_FOUND_all(channel_address_r) <= FIRST_EDGE_FOUND_mux;
            SECOND_EDGE_FOUND_all(channel_address_r) <= SECOND_EDGE_FOUND_mux;
            NROF_RETRIES_all((16*channel_address_r)+15 downto (16*channel_address_r)) <= NROF_RETRIES_mux;
            tap_setting_i((TAP_COUNT_BITS*channel_address_r)+TAP_COUNT_BITS-1 downto (TAP_COUNT_BITS*channel_address_r)) <= TAP_SETTING_mux;
            WINDOW_WIDTH_all((TAP_COUNT_BITS*channel_address_r)+TAP_COUNT_BITS-1 downto (TAP_COUNT_BITS*channel_address_r)) <= WINDOW_WIDTH_mux;
        end if;

        if (reset_status = '1') then --drift status needs to be reset upon retrain
            TAP_DRIFT_OUT_all <= (others => '0');
        elsif (update_mon_status = '1') then
            TAP_DRIFT_OUT_all((TAP_COUNT_BITS*channel_address_r)+TAP_COUNT_BITS-1 downto (TAP_COUNT_BITS*channel_address_r)) <= TAP_DRIFT_OUT_mux;
        end if;

        TAP_DRIFT_IN_mux <= TAP_DRIFT_IN_all((TAP_COUNT_BITS*channel_address_r)+TAP_COUNT_BITS-1 downto (TAP_COUNT_BITS*channel_address_r));
        TAP_COUNT_IN_mux <= tap_setting_i((TAP_COUNT_BITS*channel_address_r)+TAP_COUNT_BITS-1 downto (TAP_COUNT_BITS*channel_address_r));

        --defaults
        IODELAY_ISERDES_RESET_all       <= (others => '0');
        IODELAY_INC_all                 <= (others => '0');
        IODELAY_CE_all                  <= (others => '0'); 
        IODELAY_ENVTC_all               <= (others => '1');
        ISERDES_BITSLIP_all             <= (others => '0');

        if (select_all_ctrl = '0') then    -- initital all channels connected seperately
            IODELAY_ISERDES_RESET_all((CHANNEL_COUNT*SERDES_COUNT*channel_address_r)+(CHANNEL_COUNT*SERDES_COUNT)-1 downto (CHANNEL_COUNT*SERDES_COUNT*channel_address_r)) <= IODELAY_ISERDES_RESET_mux;
            IODELAY_INC_all((CHANNEL_COUNT*SERDES_COUNT*channel_address_r)+(CHANNEL_COUNT*SERDES_COUNT)-1 downto (CHANNEL_COUNT*SERDES_COUNT*channel_address_r)) <= IODELAY_INC_mux;
            IODELAY_CE_all((CHANNEL_COUNT*SERDES_COUNT*channel_address_r)+(CHANNEL_COUNT*SERDES_COUNT)-1 downto (CHANNEL_COUNT*SERDES_COUNT*channel_address_r)) <= IODELAY_CE_mux;
            IODELAY_ENVTC_all((CHANNEL_COUNT*SERDES_COUNT*channel_address_r)+(CHANNEL_COUNT*SERDES_COUNT)-1 downto (CHANNEL_COUNT*SERDES_COUNT*channel_address_r)) <= IODELAY_ENVTC_mux;
            ISERDES_BITSLIP_all((CHANNEL_COUNT*SERDES_COUNT*channel_address_r)+(CHANNEL_COUNT*SERDES_COUNT)-1 downto (CHANNEL_COUNT*SERDES_COUNT*channel_address_r)) <= ISERDES_BITSLIP_mux;
        else                -- one channel connected
            for i in 0 to NROF_CONN-1 loop
                IODELAY_ISERDES_RESET_all((CHANNEL_COUNT*SERDES_COUNT*i)+(CHANNEL_COUNT*SERDES_COUNT)-1 downto (CHANNEL_COUNT*SERDES_COUNT*i)) <= IODELAY_ISERDES_RESET_mux;
                IODELAY_INC_all((CHANNEL_COUNT*SERDES_COUNT*i)+(CHANNEL_COUNT*SERDES_COUNT)-1 downto (CHANNEL_COUNT*SERDES_COUNT*i)) <= IODELAY_INC_mux;
                IODELAY_CE_all((CHANNEL_COUNT*SERDES_COUNT*i)+(CHANNEL_COUNT*SERDES_COUNT)-1 downto (CHANNEL_COUNT*SERDES_COUNT*i)) <= IODELAY_CE_mux;
                IODELAY_ENVTC_all((CHANNEL_COUNT*SERDES_COUNT*i)+(CHANNEL_COUNT*SERDES_COUNT)-1 downto (CHANNEL_COUNT*SERDES_COUNT*i)) <= IODELAY_ENVTC_mux;
                ISERDES_BITSLIP_all((CHANNEL_COUNT*SERDES_COUNT*i)+(CHANNEL_COUNT*SERDES_COUNT)-1 downto (CHANNEL_COUNT*SERDES_COUNT*i)) <= ISERDES_BITSLIP_mux;
            end loop;
        end if;

        for i in 0 to NROF_CONN-1 loop
            if i = channel_address_r then
                ISERDES_DATAOUT_mux <= ISERDES_DATAOUT_all((CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH*i)+(CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH)-1 downto (CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH*i));
            end if;
        end loop;

    end if;
end process multiplexer;

end rtl;
