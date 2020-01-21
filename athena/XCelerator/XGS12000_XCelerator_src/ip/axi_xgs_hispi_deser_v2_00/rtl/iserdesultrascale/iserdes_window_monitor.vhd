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
--use ieee.std_logic_unsigned.all;
use ieee.std_logic_signed.all;
--user:
-----------
library work;
use work.all;

entity iserdes_window_monitor is
    generic (
        TAP_COUNT_MAX       : integer := 32;
        TAP_COUNT_BITS      : integer := 8;
        CHANNEL_COUNT       : integer := 2;
        SERDES_COUNT        : integer := 2;
        SAMPLE_COUNT        : integer := 128
    );
    port(
        CLOCK                   : in    std_logic;
        RESET                   : in    std_logic;

        --ctrl info
        MONITOR_START           : in    std_logic;
        MONITOR_BUSY            : out   std_logic := '0';

        CYCLE_VALID             : in    std_logic;

        DET_VALID               : in    std_logic;
        EDGE                    : in    std_logic;
        EQUAL                   : in    std_logic;
        CURRISPREV              : in    std_logic;
        SHIFTED1                : in    std_logic;
        SHIFTED2                : in    std_logic;

        --Ctrl IO, all controls should run on CLKDIV/parallelclk
        -- bitalign controls
        IODELAY_ISERDES_RESET   : out   std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0) := (others => '0');
        IODELAY_INC             : out   std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0) := (others => '0');
        IODELAY_CE              : out   std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0) := (others => '0');
        IODELAY_ENVTC           : out   std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0) := (others => '1');

        -- status info
        TAP_COUNT_IN            : in    std_logic_vector(TAP_COUNT_BITS-1 downto 0);
        TAP_DRIFT_IN            : in    std_logic_vector(TAP_COUNT_BITS-1 downto 0);
        TAP_DRIFT_OUT           : out   std_logic_vector(TAP_COUNT_BITS-1 downto 0) := (others => '0')
    );
end iserdes_window_monitor;

architecture rtl of iserdes_window_monitor is

type alignstatetp is (      idle,
                            shift_tap_minus_2,
                            check_tap_minus_2,
                            shift_tap_minus_1,
                            check_tap_minus_1,
                            shift_tap_zero   ,
                            check_tap_zero   ,
                            shift_tap_plus_1 ,
                            check_tap_plus_1 ,
                            shift_tap_plus_2 ,
                            check_tap_plus_2 ,
                            reset_tap_zero   ,
                            correct_tap
                            );

signal alignstate : alignstatetp := idle;

type statusstatetp is ( idle,
                        wait_update
                       );

signal statusstate : statusstatetp := idle;

constant ones               : std_logic_vector(31 downto 0) := X"FFFFFFFF";
constant zeros              : std_logic_vector(31 downto 0) := X"00000000";

signal correct_inc          : std_logic := '0';
signal correct_ce           : std_logic := '0';

signal compare_result       : std_logic_vector(4 downto 0) := (others => '0');

signal      gencntr         : std_logic_vector(15 downto 0) := (others => '0');
constant    gencntrld       : std_logic_vector(gencntr'high downto 0) := std_logic_vector(TO_UNSIGNED((SAMPLE_COUNT-2), gencntr'length));
constant    pipeld          : std_logic_vector(gencntr'high downto 0) := std_logic_vector(TO_UNSIGNED(12, gencntr'length));

signal update_data_channel  : std_logic := '0';

type   shifterstatetp is (  idle,
                            incr_decrement_next,
                            incr_decrement_done
                         );

signal shifterstate         : shifterstatetp := idle;

signal shiftselect          : std_logic_vector(2 downto 0) := (others => '0');
signal start_shift          : std_logic := '0';
signal end_shift            : std_logic := '0';

signal start_compare        : std_logic := '0';
signal end_compare          : std_logic := '0';

signal check_result         : std_logic := '0';

type checkerstatetp is (    idle,
                            wait_pipe,
                            checking
                        );

signal checkerstate : checkerstatetp := idle;

signal update_status        : std_logic := '0';
signal inc_status           : std_logic := '0';
signal dec_status           : std_logic := '0';

signal tap_setting          : std_logic_vector(TAP_COUNT_BITS-1 downto 0) := (others => '0');

signal inhibit_inc          : std_logic := '0';
signal inhibit_dec          : std_logic := '0';

begin

--see xapp860
resultdecoder: process(CLOCK)
  begin
    if (CLOCK'EVENT and CLOCK = '1') then
        --'0' = OK
        --'1' = Error
        case compare_result is
            when "00000" => -- do nothing
                correct_inc <= '0';
                correct_ce  <= '0';
            when "00001" => --increment delay
                correct_inc <= '1';
                correct_ce  <= '1';
            when "00010" => -- do nothing
                correct_inc <= '0';
                correct_ce  <= '0';
            when "00011" => --increment delay
                correct_inc <= '1';
                correct_ce  <= '1';
            when "00100" => -- do nothing
                correct_inc <= '0';
                correct_ce  <= '0';
            when "00101" => -- do nothing
                correct_inc <= '0';
                correct_ce  <= '0';
            when "00110" => -- do nothing
                correct_inc <= '0';
                correct_ce  <= '0';
            when "00111" => --increment delay
                correct_inc <= '0';
                correct_ce  <= '0';
            when "01000" => -- do nothing
                correct_inc <= '0';
                correct_ce  <= '0';
            when "01001" => -- do nothing
                correct_inc <= '0';
                correct_ce  <= '0';
            when "01010" => -- do nothing
                correct_inc <= '0';
                correct_ce  <= '0';
            when "01011" => -- do nothing
                correct_inc <= '0';
                correct_ce  <= '0';
            when "01100" => -- do nothing
                correct_inc <= '0';
                correct_ce  <= '0';
            when "01101" => -- do nothing
                correct_inc <= '0';
                correct_ce  <= '0';
            when "01110" => -- do nothing
                correct_inc <= '0';
                correct_ce  <= '0';
            when "01111" => --increment delay
                correct_inc <= '1';
                correct_ce  <= '1';
            when "10000" => --decrement delay
                correct_inc <= '0';
                correct_ce  <= '1';
            when "10001" => -- do nothing
                correct_inc <= '0';
                correct_ce  <= '0';
            when "10010" => -- do nothing
                correct_inc <= '0';
                correct_ce  <= '0';
            when "10011" => -- do nothing
                correct_inc <= '0';
                correct_ce  <= '0';
            when "10100" => -- do nothing
                correct_inc <= '0';
                correct_ce  <= '0';
            when "10101" => -- do nothing
                correct_inc <= '0';
                correct_ce  <= '0';
            when "10110" => -- do nothing
                correct_inc <= '0';
                correct_ce  <= '0';
            when "10111" => -- do nothing
                correct_inc <= '0';
                correct_ce  <= '0';
            when "11000" => --decrement delay
                correct_inc <= '0';
                correct_ce  <= '1';
            when "11001" => -- do nothing
                correct_inc <= '0';
                correct_ce  <= '0';
            when "11010" => -- do nothing
                correct_inc <= '0';
                correct_ce  <= '0';
            when "11011" => -- do nothing
                correct_inc <= '0';
                correct_ce  <= '0';
            when "11100" => --decrement delay
                correct_inc <= '0';
                correct_ce  <= '1';
            when "11101" => -- do nothing
                correct_inc <= '0';
                correct_ce  <= '0';
            when "11110" => --decrement delay
                correct_inc <= '0';
                correct_ce  <= '1';
            when "11111" => -- do nothing
                correct_inc <= '0';
                correct_ce  <= '0';
            when others => -- do nothing
                correct_inc <= '0';
                correct_ce  <= '0';
        end case;
    end if;
end process resultdecoder;

--FIXME:
--minimum tap setting is 2 for window alignment to work
--maximum tap setting is 30 for window alignment to work
--add logic that prevents moving beyond minimum and maximum

-- scan pattern through taps for window monitor
--
-- current state | next state | applied shift
-----------------+------------+--------------
--             0 |         -2 |            -2
--            -2 |         -1 |            +1
--            +1 |          0 |            +1
--             0 |         +1 |            +1
--            +1 |         +2 |            +1
--            +2 |          0 |            -2

alignsequencer: process(CLOCK)
  begin
    if (CLOCK'EVENT and CLOCK = '1') then
        start_compare <= '0';
        start_shift   <= '0';

        update_status       <= '0';
        inc_status          <= '0';
        dec_status          <= '0';

        case alignstate is
            when idle =>
                MONITOR_BUSY        <= '0';
                if (MONITOR_START = '1') then
                    MONITOR_BUSY        <= '1';
                    start_shift         <= '1';
                    shiftselect         <= "101";
                    update_data_channel <= '0';
                    compare_result      <= (others => '0');
                    alignstate          <= shift_tap_minus_2;
                end if;

            when shift_tap_minus_2 =>
                if (end_shift = '1') then
                    start_compare <= '1';
                    alignstate <= check_tap_minus_2;
                end if;

            when check_tap_minus_2 =>
                if (end_compare = '1') then
                    if (tap_setting(TAP_COUNT_BITS-1 downto 1) = std_logic_vector(to_unsigned(0, TAP_COUNT_BITS-1))) then --start tapsetting is 0 or 1, thus this measurement is not valid -> marked bad
                        compare_result(0)   <= '1';
                    else
                        compare_result(0)   <= check_result;
                    end if;
                    start_shift         <= '1';
                    shiftselect         <= "001";
                    alignstate          <= shift_tap_minus_1;
                end if;

            when shift_tap_minus_1 =>
                if (end_shift = '1') then
                    start_compare <= '1';
                    alignstate <= check_tap_minus_1;
                end if;

            when check_tap_minus_1 =>
                if (end_compare = '1') then
                    if (tap_setting(TAP_COUNT_BITS-1 downto 0) = std_logic_vector(to_unsigned(1, TAP_COUNT_BITS))) then --start tapsetting is 1, thus this measurement is not valid -> marked bad
                        compare_result(1)   <= '1';
                    else
                        compare_result(1)   <= check_result;
                    end if;
                    start_shift         <= '1';
                    shiftselect         <= "001";
                    alignstate          <= shift_tap_zero;
                end if;

            when shift_tap_zero =>
                if (end_shift = '1') then
                    start_compare <= '1';
                    alignstate <= check_tap_zero;
                end if;

            when check_tap_zero =>
                if (end_compare = '1') then
                    compare_result(2)   <= check_result;
                    start_shift         <= '1';
                    shiftselect         <= "001";
                    alignstate          <= shift_tap_plus_1;
                end if;

            when shift_tap_plus_1 =>
                if (end_shift = '1') then
                    start_compare <= '1';
                    alignstate <= check_tap_plus_1;
                end if;

            when check_tap_plus_1 =>
                if (end_compare = '1') then
                    if (tap_setting(TAP_COUNT_BITS-1 downto 0) = std_logic_vector(to_unsigned(TAP_COUNT_MAX-2, TAP_COUNT_BITS))) then --start tapsetting is TAP_COUNT_MAX-2, thus this measurement is not valid -> marked bad
                        compare_result(3)   <= '1';
                    else
                        compare_result(3)   <= check_result;
                    end if;
                    start_shift         <= '1';
                    shiftselect         <= "001";
                    alignstate          <= shift_tap_plus_2;
                end if;

            when shift_tap_plus_2 =>
                if (end_shift = '1') then
                    start_compare <= '1';
                    alignstate <= check_tap_plus_2;
                end if;

            when check_tap_plus_2 =>
                if (end_compare = '1') then
                    if (tap_setting(TAP_COUNT_BITS-1 downto 0) = std_logic_vector(to_unsigned(TAP_COUNT_MAX-2, TAP_COUNT_BITS))) then --start tapsetting is TAP_COUNT_MAX-2, thus this measurement is not valid -> marked bad
                        compare_result(4)   <= '1';
                    elsif (tap_setting(TAP_COUNT_BITS-1 downto 0) = std_logic_vector(to_unsigned(TAP_COUNT_MAX-1, TAP_COUNT_BITS))) then --start tapsetting is TAP_COUNT_MAX-1, thus this measurement is not valid -> marked bad
                        compare_result(4)   <= '1';
                    else
                        compare_result(4)   <= check_result;
                    end if;
                    start_shift         <= '1';
                    shiftselect         <= "101";
                    alignstate          <= reset_tap_zero;
                end if;

            when reset_tap_zero =>
                if (end_shift = '1') then
                    if (correct_ce = '1') then  --adjust tap setting
                        update_data_channel <= '1';
                        if (correct_inc = '1') then
                            if (inhibit_inc = '0') then
                                shiftselect         <= "001";
                                inc_status          <= '1';
                            else
                                shiftselect         <= "000";
                            end if;
                        else
                            if (inhibit_dec = '0') then
                                shiftselect         <= "100";
                                dec_status          <= '1';
                            else
                                shiftselect         <= "000";
                            end if;
                        end if;
                    else                        --no change
                        shiftselect         <= "000";
                    end if;
                    update_status <= '1';
                    start_shift         <= '1';
                    alignstate          <= correct_tap;
                end if;

            when correct_tap =>
                if (end_shift = '1') then
                    alignstate          <= idle;
                end if;

            when others =>
                alignstate          <= idle;

        end case;
    end if;
end process alignsequencer;

checker: process(CLOCK)
  begin
    if (CLOCK'EVENT and CLOCK = '1') then
        --if (CHANNEL_COUNT = 2) then
        end_compare <= '0';

        case checkerstate is
            when idle =>
                if (start_compare = '1') then
                    check_result <= '0';
                    gencntr      <= pipeld;
                    checkerstate <= wait_pipe;
                end if;

            when wait_pipe =>
                if (gencntr(gencntr'high) = '1') then
                    gencntr      <= gencntrld;
                    checkerstate <= checking;
                else
                    gencntr <= gencntr - '1';
                end if;

            when checking =>
                if (DET_VALID = '1') then
                    if (EQUAL = '0') then
                        check_result <= '1';
                        end_compare  <= '1';
                        checkerstate <= idle;
                    elsif (gencntr(gencntr'high) = '1')  then
                        check_result <= '0';
                        end_compare  <= '1';
                        checkerstate <= idle;
                    else
                        gencntr <= gencntr - '1';
                    end if;
                 end if;

            when others =>
                checkerstate <= idle;

        end case;
    end if;
end process;

--control line bit assignment
-- signal(3): ch1 serdes 1
-- signal(2): ch1 serdes 0
-- signal(1): ch0 serdes 1
-- signal(0): ch0 serdes 0

shifter: process( CLOCK)
  begin
    if (CLOCK'EVENT and CLOCK = '1') then
        end_shift <= '0';


        case shifterstate is
            when idle =>
                if (start_shift = '1') then
                    case shiftselect is
                        when "101" => -- -2
                            for i in 0 to CHANNEL_COUNT-1 loop
                                IODELAY_ISERDES_RESET((i*SERDES_COUNT)+SERDES_COUNT-1 downto (i*SERDES_COUNT))  <= (others => '0');
                                IODELAY_INC((i*SERDES_COUNT)+SERDES_COUNT-1 downto (i*SERDES_COUNT))            <= (others => '0');
                                IODELAY_CE((i*SERDES_COUNT)+SERDES_COUNT-1 downto (i*SERDES_COUNT))             <= ones(SERDES_COUNT-2 downto 0) & update_data_channel ;
                                IODELAY_ENVTC((i*SERDES_COUNT)+SERDES_COUNT-1 downto (i*SERDES_COUNT))          <= zeros(SERDES_COUNT-2 downto 0) & not update_data_channel;
                                          -- (but how to handle calib values then???)
                                
                            end loop;
                            shifterstate <= incr_decrement_next;

                        when "100" => -- -1
                            for i in 0 to CHANNEL_COUNT-1 loop
                                IODELAY_ISERDES_RESET((i*SERDES_COUNT)+SERDES_COUNT-1 downto (i*SERDES_COUNT))  <= (others => '0');
                                IODELAY_INC((i*SERDES_COUNT)+SERDES_COUNT-1 downto (i*SERDES_COUNT))            <= (others => '0');
                                IODELAY_CE((i*SERDES_COUNT)+SERDES_COUNT-1 downto (i*SERDES_COUNT))             <= ones(SERDES_COUNT-2 downto 0) & update_data_channel ;
                                IODELAY_ENVTC((i*SERDES_COUNT)+SERDES_COUNT-1 downto (i*SERDES_COUNT))          <= zeros(SERDES_COUNT-2 downto 0) & not update_data_channel;
                            end loop;
                            shifterstate <= incr_decrement_done;

                        when "000" => -- 0
                            shifterstate <= incr_decrement_done;

                        when "001" => -- +1
                            for i in 0 to CHANNEL_COUNT-1 loop
                                IODELAY_ISERDES_RESET((i*SERDES_COUNT)+SERDES_COUNT-1 downto (i*SERDES_COUNT))  <= (others => '0');
                                IODELAY_INC((i*SERDES_COUNT)+SERDES_COUNT-1 downto (i*SERDES_COUNT))            <= (others => '1');
                                IODELAY_CE((i*SERDES_COUNT)+SERDES_COUNT-1 downto (i*SERDES_COUNT))             <= ones(SERDES_COUNT-2 downto 0) & update_data_channel ;
                                IODELAY_ENVTC((i*SERDES_COUNT)+SERDES_COUNT-1 downto (i*SERDES_COUNT))          <= zeros(SERDES_COUNT-2 downto 0) & not update_data_channel;
                            end loop;
                            shifterstate <= incr_decrement_done;

                        when "010" => -- +2
                            for i in 0 to CHANNEL_COUNT-1 loop
                                IODELAY_ISERDES_RESET((i*SERDES_COUNT)+SERDES_COUNT-1 downto (i*SERDES_COUNT))  <= (others => '0');
                                IODELAY_INC((i*SERDES_COUNT)+SERDES_COUNT-1 downto (i*SERDES_COUNT))            <= (others => '1');
                                IODELAY_CE((i*SERDES_COUNT)+SERDES_COUNT-1 downto (i*SERDES_COUNT))             <= ones(SERDES_COUNT-2 downto 0) & update_data_channel ;
                                IODELAY_ENVTC((i*SERDES_COUNT)+SERDES_COUNT-1 downto (i*SERDES_COUNT))          <= zeros(SERDES_COUNT-2 downto 0) & not update_data_channel;
                            end loop;
                            shifterstate <= incr_decrement_next;

                        when others =>
                            shifterstate <= idle;
                    end case;
                end if;

            when incr_decrement_next =>
                shifterstate <= incr_decrement_done;

            when incr_decrement_done =>
                for i in 0 to CHANNEL_COUNT-1 loop
                    IODELAY_ISERDES_RESET((i*SERDES_COUNT)+SERDES_COUNT-1 downto (i*SERDES_COUNT))  <= (others => '0');
                    IODELAY_INC((i*SERDES_COUNT)+SERDES_COUNT-1 downto (i*SERDES_COUNT))            <= (others => '0');
                    IODELAY_CE((i*SERDES_COUNT)+SERDES_COUNT-1 downto (i*SERDES_COUNT))             <= (others => '0');
                    IODELAY_ENVTC((i*SERDES_COUNT)+SERDES_COUNT-1 downto (i*SERDES_COUNT))          <= (others => '1');
                end loop;
                end_shift <= '1';
                shifterstate <= idle;

            when others =>
                shifterstate <= idle;

        end case;
    end if;
end process;

--status generation
status: process(CLOCK)
  begin
    if (CLOCK'EVENT and CLOCK = '1') then
        case statusstate is
            when idle =>
                if (MONITOR_START = '1') then
                    statusstate <= wait_update;
                end if;

            when wait_update =>
                if (update_status = '1') then
                    if (inc_status = '1') then
                        TAP_DRIFT_OUT     <= TAP_DRIFT_IN + '1';
                    elsif (dec_status = '1') then
                        TAP_DRIFT_OUT     <= TAP_DRIFT_IN - '1';
                    else
                        TAP_DRIFT_OUT     <= TAP_DRIFT_IN;
                    end if;
                    statusstate <= idle;
                end if;

            when others =>
                statusstate <= idle;
        end case;
    end if;
end process status;

--tapcount limit check
--assumes: 1 < tapcount_after initial bitalign < TAP_COUNT_MAX-2
--if the start is OK the algorithm will not drift out of range

tapcheck: process(CLOCK)
  begin
    if (CLOCK'EVENT and CLOCK = '1') then
        
        --signed operation
        tap_setting <= TAP_COUNT_IN + TAP_DRIFT_IN;
        
        if (tap_setting < 3) then
            inhibit_dec <= '1'; 
        else 
            inhibit_dec <= '0'; 
        end if;
        
        if (tap_setting > TAP_COUNT_MAX-4) then
            inhibit_inc <= '1'; 
        else
            inhibit_inc <= '0'; 
        end if;
    end if;
end process tapcheck;

end rtl;