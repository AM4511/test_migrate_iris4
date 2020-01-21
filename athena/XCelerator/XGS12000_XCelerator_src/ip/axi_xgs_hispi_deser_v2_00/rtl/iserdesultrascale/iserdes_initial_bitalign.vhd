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
use ieee.std_logic_unsigned.all;
--user:
-----------
library work;
use work.all;

-----------------------
-- ENTITY DEFINITION --
-----------------------
entity iserdes_initial_bitalign is
    generic (
        TAP_COUNT_MAX       : integer := 32;
        TAP_COUNT_BITS      : integer := 8;
        RETRY_MAX           : integer := 32767;
        CHANNEL_COUNT       : integer := 2;
        SERDES_COUNT        : integer := 2;
        STABLE_COUNT        : integer := 128
    );
    port (
        CLOCK                   : in    std_logic;
        RESET                   : in    std_logic;

        --ctrl info
        START_ALIGN             : in    std_logic;
        BUSY_ALIGN              : out   std_logic := '0';
        ALIGNMODE               : in    std_logic_vector(2 downto 0);   --selects how alignment is done (using 'standard' alignment, 2 serdes alignment, manual alignment, enable window_monitor)
        MANUAL_TAP              : in    std_logic_vector(TAP_COUNT_BITS-1 downto 0);   --selects tap in manual mode

        CYCLE_VALID             : in    std_logic;
        COMPARE_LOAD            : out   std_logic := '0';

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
        ISERDES_BITSLIP         : out   std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0) := (others => '0');
        IODELAY_ENVTC           : out   std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0) := (others => '0');

        -- status info
        EDGE_DETECT             : out   std_logic := '0';
        STABLE_DETECT           : out   std_logic := '0';
        FIRST_EDGE_FOUND        : out   std_logic := '0';
        SECOND_EDGE_FOUND       : out   std_logic := '0';
        NROF_RETRIES            : out   std_logic_vector(15 downto 0) := (others => '0');
        TAP_SETTING             : out   std_logic_vector(TAP_COUNT_BITS-1 downto 0) := (others => '0');
        WINDOW_WIDTH            : out   std_logic_vector(TAP_COUNT_BITS-1 downto 0) := (others => '0')
       );
end iserdes_initial_bitalign;

architecture rtl of iserdes_initial_bitalign is

constant ones               : std_logic_vector(31 downto 0) := X"FFFFFFFF";
constant zeros              : std_logic_vector(31 downto 0) := X"00000000";

signal start_handshake      : std_logic := '0';
signal end_handshake        : std_logic := '0';

signal retries              : std_logic_vector(15 downto 0) := (others => '0');

--serdes control
signal CTRL_CMP_LD          : std_logic := '0';

signal CTRL_RESET           : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0) := (others => '1');
signal CTRL_INC             : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0) := (others => '0');
signal CTRL_CE              : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0) := (others => '0');
signal CTRL_ENVTC           : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0) := (others => '1');

--expect 6 pipeline stages

signal pipecntr             : std_logic_vector(4 downto 0) := (others => '0');
constant pipecntrld         : std_logic_vector(pipecntr'high downto 0) := "00110";  --expect 6 pipeline stages from iodelay ctrl to iserdes_dataout
                                                                                    -- +2 to account for pipe in detector
                                                                                    -- -2 to compensate for underflow detection

type   serdescontrolstatetp is (idle,
                                wait_pipe,
                                wait_cycle
                                );
signal serdescontrolstate   : serdescontrolstatetp := idle;

signal maxcount             : std_logic_vector(TAP_COUNT_BITS downto 0) := (others => '0');
signal tapcount             : std_logic_vector(TAP_COUNT_BITS-1 downto 0) := (others => '0');
signal windowcount          : std_logic_vector(TAP_COUNT_BITS-1 downto 0) := (others => '0');

signal RetryCntr            : std_logic_vector(15 downto 0) := (others => '0');
signal GenCntr              : std_logic_vector(16 downto 0) := (others => '0');
constant StableCntrLoad     : std_logic_vector(GenCntr'high downto 0) := std_logic_vector(to_unsigned(STABLE_COUNT-1 ,GenCntr'length));

type alignstatetp is (  Idle,
                        Reset_Delay,
                        Wait_Reset_Delay,
                        Get_Edge,
                        Check_Edge,
                        Wait_Sample_Stable,
                        Valid_Begin_Found,
                        CheckFirstEdgeChanged,
                        CheckFirstEdgeStable,
                        CheckSecondEdgeChanged,
                        WindowFound,
                        Increment_Tap_Edge,
                        Reset_Delay_Man,
                        Increment_Tap_Man,
                        GetEdge_Man,
                        CheckEdge_Man,
                        Reset_Delay_2sd,
                        Wait_Reset_Delay_2sd,
                        Get_Edge_2sd,
                        Check_Edge_2sd,
                        SetWindow_2sd,
                        Wait_Cycle_2sd,
                        Wait_Sample_Stable_2sd,
                        SetSamplingPoint_2sd,
                        Alignment_Done,
                        EnableVTC
                        );

signal alignstate : alignstatetp := Idle;

begin

-- Iserdes control/
-- Synchronises to CYCLES & waits for prop delay
ISERDES_BITSLIP  <= (others => '0');
COMPARE_LOAD          <= CTRL_CMP_LD;

ctrl_wait_sync: process(CLOCK)
    variable equal_tmp: std_logic := '1';
  begin
    if (CLOCK'event and CLOCK = '1') then
        end_handshake <= '0';

        IODELAY_ISERDES_RESET   <= (others => '0');
        IODELAY_INC             <= (others => '0');
        IODELAY_CE              <= (others => '0');


        case serdescontrolstate is
            when idle =>
                if (start_handshake = '1') then
                    end_handshake         <= '0';
                    IODELAY_ISERDES_RESET <= CTRL_RESET;
                    IODELAY_INC           <= CTRL_INC;
                    IODELAY_CE            <= CTRL_CE;
                    IODELAY_ENVTC         <= CTRL_ENVTC;
                    pipecntr              <= pipecntrld;
                    serdescontrolstate    <= wait_pipe;
                end if;
            --first wait a while for the controls to ripple through
            --then wait for the cycle valid counter
            --then wait the appropriate number of clocks to generate the correct output to the control sequencer

            when wait_pipe =>
                if (pipecntr(pipecntr'high) = '1') then
                    --simplified, could be made more performant
                    serdescontrolstate    <= wait_cycle;
                else
                    pipecntr <= pipecntr - '1';
                end if;

            when wait_cycle =>
                if (DET_VALID = '1') then
                    end_handshake         <= '1';
                    serdescontrolstate    <= idle;
                    --serdescontrolstate    <= wait_next_cycle;
                end if;

            --when wait_next_cycle =>
            --    if (cycle_valid = '1') then
            --        end_handshake           <= '1';
            --        serdescontrolstate      <= idle;
            --    end if;

            when others =>
                serdescontrolstate    <= idle;
        end case;
    end if;
end process;

--align state machine
aligning: process(CLOCK)
begin
if (CLOCK'event and CLOCK = '1') then
    --defaults
    start_handshake     <= '0';


    case alignstate is
        when Idle =>

            BUSY_ALIGN      <= '0';

            if (START_ALIGN = '1') then
                BUSY_ALIGN          <= '1';

                EDGE_DETECT         <= '0';
                STABLE_DETECT       <= '0';
                FIRST_EDGE_FOUND    <= '0';
                SECOND_EDGE_FOUND   <= '0';
                NROF_RETRIES        <= (others => '0');
                TAP_SETTING         <= (others => '0');
                WINDOW_WIDTH        <= (others => '0');

                RetryCntr           <= std_logic_vector(TO_UNSIGNED((RETRY_MAX-1),(RetryCntr'high+1)));

                Maxcount            <= std_logic_vector(TO_UNSIGNED((TAP_COUNT_MAX-2),(Maxcount'high+1)));

                if (ALIGNMODE(1 downto 0) = "00" or ALIGNMODE(1 downto 0) = "11") then  --'standard' alignment
                    CTRL_CMP_LD         <= '0';
                    CTRL_RESET          <= (others => '1');
                    CTRL_INC            <= (others => '0');
                    CTRL_CE             <= (others => '0');
                    CTRL_ENVTC          <= (others => '0');
                    tapcount            <= (others => '0');
                    windowcount         <= (others => '0');
                    retries             <= (others => '0');
                    start_handshake     <= '1';
                    alignstate          <= Reset_Delay;
                elsif (ALIGNMODE(1 downto 0) = "01") then -- 2 SERDES alignment
                    if (SERDES_COUNT < 2) then --only works with 2 serdes per channel
                        alignstate          <= Idle;
                    else
                        CTRL_RESET          <= (others => '1');
                        CTRL_INC            <= (others => '0');
                        CTRL_CE             <= (others => '0');
                        CTRL_ENVTC          <= (others => '0');
                        tapcount            <= (others => '0');
                        windowcount         <= (others => '0');
                        retries             <= (others => '0');
                        start_handshake     <= '1';
                        alignstate          <= Reset_Delay_2sd;
                    end if;
                elsif (ALIGNMODE(1 downto 0) = "10") then -- manual alignment
                    CTRL_CMP_LD         <= '0';
                    CTRL_RESET          <= (others => '1');
                    CTRL_INC            <= (others => '0');
                    CTRL_CE             <= (others => '0');
                    CTRL_ENVTC          <= (others => '0');
                    tapcount            <= (others => '0');
                    windowcount         <= (others => '0');
                    retries             <= (others => '0');
                    start_handshake     <= '1';
                    alignstate          <= Reset_Delay_Man;
                else
                    alignstate          <= Idle;
                end if;
            end if;

--standard alignment
        when Reset_Delay =>
            GenCntr         <= StableCntrLoad;
            if (end_handshake = '1') then
               alignstate       <= Wait_Reset_Delay;
            end if;

        when Wait_Reset_Delay =>
             start_handshake     <= '1';
             --do nothing
             CTRL_RESET          <= (others => '0');
             CTRL_INC            <= (others => '0');
             CTRL_CE             <= (others => '0');
             alignstate          <= Get_Edge;

         when Get_Edge =>
            if (end_handshake = '1' ) then
                --fixme report edge detect only on enabled channel
                EDGE_DETECT          <= EDGE;
                alignstate           <= Check_Edge;
            end if;

        when Check_Edge =>
                if (RetryCntr(RetryCntr'high) = '1') then -- no stable edge found within retry limit
                    NROF_RETRIES    <= retries;
                    TAP_SETTING     <= tapcount;
                    alignstate      <= Idle;
                else
                    if (EDGE = '1' and EQUAL = '1') then             -- edge found, check stability
                        --do nothing
                        start_handshake <= '1';
                        CTRL_RESET      <= (others => '0');
                        CTRL_INC        <= (others => '0');
                        CTRL_CE         <= (others => '0');
                        alignstate      <= Wait_Sample_Stable;
                    else
                        start_handshake <= '1';    -- no edge found but retrylimit not yet reached, increment tap and try again
                        if (Maxcount(Maxcount'high) = '1') then
                                retries         <= retries + '1';
                                RetryCntr       <= RetryCntr - '1';
                                tapcount        <= (others => '0');
                                CTRL_RESET      <= (others => '1');
                                CTRL_INC        <= (others => '0');
                                CTRL_CE         <= (others => '0');
                                Maxcount        <= std_logic_vector(TO_UNSIGNED((TAP_COUNT_MAX-2),(Maxcount'high+1)));
                                alignstate      <= Reset_Delay;
                        else
                                retries         <= retries + '1';
                                RetryCntr       <= RetryCntr - '1';
                                tapcount        <= tapcount + '1';
                                Maxcount        <= Maxcount - '1';
                                CTRL_RESET      <= (others => '0');
                                CTRL_INC        <= (others => '1');
                                CTRL_CE         <= (others => '1');
                                alignstate      <= Get_Edge;
                        end if;
                    end if;
                end if;

        when Wait_Sample_Stable =>
            if (end_handshake = '1') then
                if (GenCntr(GenCntr'high) = '1') then  -- sampled x times the same edge data
                    STABLE_DETECT             <= '1';
                    start_handshake           <= '1';
                    CTRL_CMP_LD               <= '1';
                    CTRL_RESET                <= (others => '0');
                    CTRL_INC                  <= (others => '0');
                    CTRL_CE                   <= (others => '0');
                    alignstate                <= Valid_Begin_Found;
                else
                   if (CURRISPREV = '0' or EQUAL = '0') then     -- data not the same, increment tab and try again
                        start_handshake <= '1';
                        retries               <= retries + '1';
                        RetryCntr             <= RetryCntr - '1';
                        if (Maxcount(Maxcount'high) = '1') then
                            tapcount              <= (others => '0');
                            CTRL_RESET            <= (others => '1');
                            CTRL_INC              <= (others => '0');
                            CTRL_CE               <= (others => '0');
                            Maxcount              <= std_logic_vector(TO_UNSIGNED((TAP_COUNT_MAX-2),(Maxcount'high+1)));
                            alignstate            <= Reset_Delay;
                        else
                            tapcount              <= tapcount + '1';
                            Maxcount              <= Maxcount - '1';
                            CTRL_RESET            <= (others => '0');
                            CTRL_INC              <= (others => '1');
                            CTRL_CE               <= (others => '1');
                            GenCntr               <= StableCntrLoad;
                            alignstate            <= Get_Edge;
                        end if;
                    else
                        GenCntr               <= GenCntr - '1';
                        CTRL_RESET            <= (others => '0');
                        CTRL_INC              <= (others => '0');
                        CTRL_CE               <= (others => '0');
                        start_handshake       <= '1';
                    end if;
                end if;
            end if;

        when Valid_Begin_Found =>
            if (end_handshake = '1') then
                start_handshake <= '1';
                Maxcount        <= Maxcount - '1';
                tapcount        <= tapcount + '1';
                CTRL_CMP_LD     <= '0';
                CTRL_RESET      <= (others => '0');
                CTRL_INC        <= (others => '1');
                CTRL_CE         <= (others => '1');
                alignstate      <= CheckFirstEdgeChanged;
            end if;

        when CheckFirstEdgeChanged =>
            if (end_handshake = '1') then
                if (SHIFTED1 = '1' and EQUAL = '1') then  --edge found (1 time)
                    start_handshake <= '1';
                    CTRL_RESET      <= (others => '0');
                    CTRL_INC        <= (others => '0');
                    CTRL_CE         <= (others => '0');
                    GenCntr         <= StableCntrLoad;
                    alignstate      <= CheckFirstEdgeStable;
                else
                    start_handshake <= '1';
                    if (Maxcount(Maxcount'high) = '1') then
                        retries         <= retries + '1';
                        RetryCntr       <= RetryCntr - '1';
                        tapcount        <= (others => '0');
                        CTRL_RESET      <= (others => '1');
                        CTRL_INC        <= (others => '0');
                        CTRL_CE         <= (others => '0');
                        Maxcount        <= std_logic_vector(TO_UNSIGNED((TAP_COUNT_MAX-2),(Maxcount'high+1)));
                        alignstate      <= Reset_Delay;
                    else
                        Maxcount        <= Maxcount - '1';
                        tapcount        <= tapcount + '1';
                        CTRL_RESET      <= (others => '0');
                        CTRL_INC        <= (others => '1');
                        CTRL_CE         <= (others => '1');
                    end if;
                end if;
            end if;

        when CheckFirstEdgeStable =>
            if (end_handshake = '1') then
                start_handshake             <= '1';
                if (GenCntr(GenCntr'high) = '1') then -- edge detected ok
                    if (ALIGNMODE(1 downto 0) = "11") then
                        GenCntr                     <= (zeros(GenCntr'high-TAP_COUNT_BITS downto 0) & MANUAL_TAP) - "010";
                        windowcount                 <= windowcount + '1';
                        tapcount                    <= tapcount + '1';
                        Maxcount                    <= Maxcount - '1';
                        CTRL_RESET                  <= (others => '0');
                        CTRL_INC                    <= (others => '1');
                        CTRL_CE                     <= (others => '1');
                        FIRST_EDGE_FOUND            <= '1';
                        alignstate                  <= Increment_Tap_Edge;
                     else
                        windowcount                 <= windowcount + '1';
                        tapcount                    <= tapcount + '1';
                        Maxcount                    <= Maxcount - '1';
                        CTRL_RESET                  <= (others => '0');
                        CTRL_INC                    <= (others => '1');
                        CTRL_CE                     <= (others => '1');
                        FIRST_EDGE_FOUND            <= '1';
                        alignstate                  <= CheckSecondEdgeChanged;
                     end if;
                else
                    GenCntr                     <= GenCntr - '1';
                    if (SHIFTED1 = '1' and EQUAL = '1') then
                        CTRL_RESET              <= (others => '0');
                        CTRL_INC                <= (others => '0');
                        CTRL_CE                 <= (others => '0');
                    else -- edge changed during stability test
                        GenCntr                 <= StableCntrLoad;
                        tapcount                <= tapcount + '1'; -- increment tapcount by one and try again
                        Maxcount                <= Maxcount - '1';
                        CTRL_RESET              <= (others => '0');
                        CTRL_INC                <= (others => '1');
                        CTRL_CE                 <= (others => '1');
                        alignstate              <= CheckFirstEdgeChanged;
                    end if;
                end if;
            end if;

        when CheckSecondEdgeChanged =>
            if (end_handshake = '1') then
                if (SHIFTED1 = '0' or EQUAL = '0') then   -- 2nd edge found, window found
                    SECOND_EDGE_FOUND           <= '1';
                    WINDOW_WIDTH                <= windowcount;
                    GenCntr                     <= (zeros(GenCntr'high-TAP_COUNT_BITS+1 downto 0) & windowcount(TAP_COUNT_BITS-1 downto 1)) - "01"; --divide by 2
                    start_handshake             <= '1';
                    tapcount                    <= tapcount - '1';
                    CTRL_RESET                  <= (others => '0');
                    CTRL_INC                    <= (others => '0');
                    CTRL_CE                     <= (others => '1');
                    alignstate                  <= WindowFound;
                else
                        start_handshake <= '1';
                        if (Maxcount(Maxcount'high) = '1') then  --overrun tapcount
                            retries         <= retries + '1';
                            RetryCntr       <= RetryCntr - '1';
                            tapcount        <= (others => '0');
                            CTRL_RESET      <= (others => '1');
                            CTRL_INC        <= (others => '0');
                            CTRL_CE         <= (others => '0');
                            Maxcount        <= std_logic_vector(TO_UNSIGNED((TAP_COUNT_MAX-2),(Maxcount'high+1)));
                            alignstate      <= Reset_Delay;
                        else
                            windowcount     <= windowcount + '1';
                            maxcount        <= maxcount - '1';
                            tapcount        <= tapcount + '1';
                            CTRL_RESET      <= (others => '0');
                            CTRL_INC        <= (others => '1');
                            CTRL_CE         <= (others => '1');
                        end if;
                end if;
            end if;

        when WindowFound =>
            if (end_handshake = '1') then
                if (GenCntr(GenCntr'high) = '1') then
                   alignstate          <= Alignment_Done;
                else
                   start_handshake     <= '1';
                   tapcount            <= tapcount - '1';
                   GenCntr             <= GenCntr - '1';
                   CTRL_RESET          <= (others => '0');
                   CTRL_INC            <= (others => '0');
                   CTRL_CE             <= (others => '1');
                end if;
            end if;

--states for single edge alignment
        when Increment_Tap_Edge =>
            if (end_handshake = '1') then
                if (Maxcount(Maxcount'high) = '1') then -- remaining delay chain was too short to go to requested samplepoint
                                                        -- do not raise error but go as far as possible. actual tap setting can be read in windowwidth reg
                    CTRL_RESET          <= (others => '0');
                    CTRL_INC            <= (others => '0');
                    CTRL_CE             <= (others => '0');
                    WINDOW_WIDTH        <= windowcount;
                    alignstate          <= Alignment_Done;
                elsif (GenCntr(GenCntr'high) = '1') then -- succeeded
                    CTRL_RESET          <= (others => '0');
                    CTRL_INC            <= (others => '0');
                    CTRL_CE             <= (others => '0');
                    WINDOW_WIDTH        <= windowcount;
                    alignstate          <= Alignment_Done;
                else
                    windowcount         <= windowcount + '1';
                    GenCntr             <= GenCntr - '1';
                    Maxcount            <= Maxcount - '1';
                    start_handshake     <= '1';
                    tapcount            <= tapcount + '1';
                    CTRL_RESET          <= (others => '0');
                    CTRL_INC            <= (others => '1');
                    CTRL_CE             <= (others => '1');
                end if;
            end if;

-- states for manual alignment
        when Reset_Delay_Man =>
            if (end_handshake = '1') then
                if (MANUAL_TAP = X"00") then --nothing to do
                    start_handshake     <= '1';
                    CTRL_RESET          <= (others => '0');
                    CTRL_INC            <= (others => '0');
                    CTRL_CE             <= (others => '0');
                    alignstate          <= GetEdge_Man;
                else
                    GenCntr             <= (zeros(GenCntr'high-TAP_COUNT_BITS downto 0) & MANUAL_TAP) - "010";
                    start_handshake     <= '1';
                    tapcount            <= tapcount + '1';
                    CTRL_RESET          <= (others => '0');
                    CTRL_INC            <= (others => '1');
                    CTRL_CE             <= (others => '1');
                    alignstate          <= Increment_Tap_Man;
                end if;
            end if;

        when Increment_Tap_Man =>
            if (end_handshake = '1') then
                if (GenCntr(GenCntr'high) = '1') then
                    start_handshake     <= '1';
                    CTRL_RESET          <= (others => '0');
                    CTRL_INC            <= (others => '0');
                    CTRL_CE             <= (others => '0');
                    alignstate          <= GetEdge_Man;
                else
                    GenCntr             <= GenCntr - '1';
                    start_handshake     <= '1';
                    tapcount            <= tapcount + '1';
                    CTRL_RESET          <= (others => '0');
                    CTRL_INC            <= (others => '1');
                    CTRL_CE             <= (others => '1');
                end if;
            end if;

        when GetEdge_Man =>
            if (end_handshake = '1' ) then
                --fixme report edge detect only on enabled channel
                EDGE_DETECT          <= EDGE;
                start_handshake      <= '1';
                GenCntr              <= StableCntrLoad;
                CTRL_RESET           <= (others => '0');
                CTRL_INC             <= (others => '0');
                CTRL_CE              <= (others => '0');
                alignstate           <= CheckEdge_Man;
            end if;

        when CheckEdge_Man =>
            if (end_handshake = '1') then
                if (GenCntr(GenCntr'high) = '1') then
                    STABLE_DETECT        <= '1';
                    alignstate           <= Alignment_Done;
                elsif (CURRISPREV = '0' or EQUAL = '0') then
                    STABLE_DETECT        <= '0';
                    alignstate           <= Alignment_Done;
                else
                    start_handshake     <= '1';
                    CTRL_RESET          <= (others => '0');
                    CTRL_INC            <= (others => '0');
                    CTRL_CE             <= (others => '0');
                    GenCntr             <= GenCntr - '1';
                end if;
            end if;

        when Alignment_Done =>            
            start_handshake     <= '1';
            CTRL_RESET          <= (others => '0');
            CTRL_INC            <= (others => '0');
            CTRL_CE             <= (others => '0');
            CTRL_ENVTC          <= (others => '1');
            NROF_RETRIES        <= retries;
            TAP_SETTING         <= tapcount;
            alignstate          <= EnableVTC;

        when EnableVTC =>
            if (end_handshake = '1') then 
                CTRL_RESET          <= (others => '0');
                CTRL_INC            <= (others => '0');
                CTRL_CE             <= (others => '0');
                CTRL_ENVTC          <= (others => '1');
                alignstate          <= Idle;
            end if;

--2 serdes alignment
        when Reset_Delay_2sd =>
            if (end_handshake = '1') then
               alignstate       <= Wait_Reset_Delay_2sd;
            end if;

        when Wait_Reset_Delay_2sd =>
             start_handshake     <= '1';
             --do nothing
             CTRL_RESET          <= (others => '0');
             CTRL_INC            <= (others => '0');
             CTRL_CE             <= (others => '0');
             alignstate          <= Get_Edge_2sd;

        when Get_Edge_2sd =>
            if (end_handshake = '1' ) then
                --fixme report edge detect only on enabled channel
                EDGE_DETECT          <= EDGE;
                alignstate           <= Check_Edge_2sd;
            end if;

        when Check_Edge_2sd =>
                if (RetryCntr(RetryCntr'high) = '1') then -- no stable edge found within retry limit
                    NROF_RETRIES    <= retries;
                    TAP_SETTING     <= tapcount;
                    alignstate      <= Idle;
                else
                    RetryCntr  <= RetryCntr - '1';
                    if (EDGE = '1' and EQUAL = '1') then             -- edge found, set window
                        start_handshake <= '1';
                        GenCntr         <= (zeros(GenCntr'high-TAP_COUNT_BITS downto 0) & MANUAL_TAP(TAP_COUNT_BITS-1 downto 1) & '0') - "010"; -- always convert to an even window width.
                        CTRL_RESET      <= (others => '0');
                        CTRL_INC        <= (others => '0');
                        CTRL_CE         <= (others => '0');
                        for i in 0 to CHANNEL_COUNT-1 loop
                            CTRL_INC(i*SERDES_COUNT)     <= '1';                 --only increment the first serdes of each channel
                            CTRL_CE(i*SERDES_COUNT)      <= '1';
                        end loop;
                        alignstate      <= SetWindow_2sd;
                    else
                        start_handshake <= '1';    -- no edge found but retrylimit not yet reached, increment tap and try again
                        if (Maxcount(Maxcount'high) = '1') then
                                retries         <= retries + '1';
                                RetryCntr       <= RetryCntr - '1';
                                tapcount        <= (others => '0');
                                CTRL_RESET      <= (others => '1');
                                CTRL_INC        <= (others => '0');
                                CTRL_CE         <= (others => '0');
                                Maxcount        <= std_logic_vector(TO_UNSIGNED((TAP_COUNT_MAX-2),(Maxcount'high+1)));
                                alignstate      <= Reset_Delay_2sd;
                        else
                                retries         <= retries + '1';
                                RetryCntr       <= RetryCntr - '1';
                                tapcount        <= tapcount + '1';
                                Maxcount        <= Maxcount - '1';
                                CTRL_RESET      <= (others => '0');
                                CTRL_INC        <= (others => '1');
                                CTRL_CE         <= (others => '1');
                                alignstate      <= Get_Edge_2sd;
                        end if;
                    end if;
                end if;

        when SetWindow_2sd =>
            if (end_handshake = '1') then
                start_handshake           <= '1';
                if (GenCntr(GenCntr'high) = '1') then  -- window set
                    CTRL_RESET                <= (others => '0');
                    CTRL_INC                  <= (others => '0');
                    CTRL_CE                   <= (others => '0');
                    GenCntr                   <= StableCntrLoad;
                    alignstate                <= Wait_Cycle_2sd;
                else
                    GenCntr <= GenCntr - '1';
                    CTRL_RESET      <= (others => '0');
                    CTRL_INC        <= (others => '0');
                    CTRL_CE         <= (others => '0');
                    for i in 0 to CHANNEL_COUNT-1 loop
                        CTRL_INC(i*SERDES_COUNT)     <= '1';                 --only increment the first serdes of each channel
                        CTRL_CE(i*SERDES_COUNT)      <= '1';
                    end loop;
                end if;
            end if;

        when Wait_Cycle_2sd =>
            if (end_handshake = '1') then
                start_handshake           <= '1';
                CTRL_RESET                <= (others => '0');
                CTRL_INC                  <= (others => '0');
                CTRL_CE                   <= (others => '0');
                alignstate                <= Wait_Sample_Stable_2sd;
            end if;

        when Wait_Sample_Stable_2sd =>
            if (end_handshake = '1') then
                if (GenCntr(GenCntr'high) = '1') then  -- sampled x times the same edge data
                    STABLE_DETECT             <= '1';
                    start_handshake           <= '1';
                    CTRL_RESET                <= (others => '0');
                    CTRL_CE                   <= (others => '1');
                    CTRL_INC                  <= (others => '1');
                    for i in 0 to CHANNEL_COUNT-1 loop
                        CTRL_INC(i*SERDES_COUNT)     <= '0';                 --decrement the first serdes of each channel
                                                                             --increment the 2nd serdes of each channel
                    end loop;
                    GenCntr                   <= (zeros(GenCntr'high-TAP_COUNT_BITS downto 0) & '0' & MANUAL_TAP(TAP_COUNT_BITS-1 downto 1)) - "010"; -- shift half the # of taps
                    tapcount                  <= tapcount + '1';
                    windowcount               <= MANUAL_TAP;
                    WINDOW_WIDTH              <= MANUAL_TAP;
                    alignstate                <= SetSamplingPoint_2sd;
                else
                   if (CURRISPREV = '0' or EQUAL = '0') then     -- data not the same, increment tab and try again
                        start_handshake <= '1';
                        retries               <= retries + '1';
                        RetryCntr             <= RetryCntr - '1';
                        if (Maxcount(Maxcount'high) = '1') then
                            retries         <= retries + '1';
                            RetryCntr       <= RetryCntr - '1';
                            tapcount              <= (others => '0');
                            CTRL_RESET            <= (others => '1');
                            CTRL_INC              <= (others => '0');
                            CTRL_CE               <= (others => '0');
                            Maxcount              <= std_logic_vector(TO_UNSIGNED((TAP_COUNT_MAX-2),(Maxcount'high+1)));
                            alignstate            <= Reset_Delay_2sd;
                        else
                            tapcount              <= tapcount + '1';
                            Maxcount              <= Maxcount - '1';
                            CTRL_RESET            <= (others => '0');
                            CTRL_INC              <= (others => '1');
                            CTRL_CE               <= (others => '1');
                            GenCntr               <= StableCntrLoad;
                            alignstate            <= Wait_Cycle_2sd;
                        end if;
                    else
                        GenCntr               <= GenCntr - '1';
                        CTRL_RESET            <= (others => '0');
                        CTRL_INC              <= (others => '0');
                        CTRL_CE               <= (others => '0');
                        start_handshake       <= '1';
                    end if;
                end if;
            end if;

        when SetSamplingPoint_2sd =>
            if (end_handshake = '1') then
                if (GenCntr(GenCntr'high) = '1') then  -- sampled x times the same edge data
                    CTRL_RESET                <= (others => '0');
                    CTRL_CE                   <= (others => '0');
                    CTRL_INC                  <= (others => '0');
                    alignstate                <= Alignment_Done;
                else
                    start_handshake           <= '1';
                    tapcount                  <= tapcount + '1';
                    CTRL_RESET                <= (others => '0');
                    CTRL_CE                   <= (others => '1');
                    CTRL_INC                  <= (others => '1');
                    for i in 0 to CHANNEL_COUNT-1 loop
                        CTRL_INC(i*SERDES_COUNT)     <= '0';                 --decrement the first serdes of each channel
                                                                             --increment the 2nd serdes of each channel
                    end loop;
                    GenCntr                   <= GenCntr - '1';
                end if;
            end if;

        when others =>
            alignstate   <= Idle;

    end case;
end if;
end process;

end rtl;