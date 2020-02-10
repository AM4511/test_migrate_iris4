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

entity iserdes_sync is
    generic (
        MAX_DATAWIDTH           : integer;
        NROF_CONN               : integer;
        CHANNEL_COUNT           : integer;
        CLOCK_COUNT             : integer;
        TAP_COUNT_BITS          : integer
    );
    port (
        CLOCK                           : in    std_logic;
        CLOCK_RESET                     : in    std_logic;

        CLKDIV                          : in    std_logic;
        CLKDIV_RESET                    : in    std_logic;

        --signals synchronous with CLOCK
        START_TRAINING                  : in    std_logic;
        BUSY_TRAINING                   : out   std_logic;

        --control
        FIFO_EN                         : in    std_logic;

        DATAWIDTH                       : in    integer;
        SINGLECHANNEL                   : in    std_logic_vector(7 downto 0);
        ALIGNMODE                       : in    std_logic_vector(15 downto 0);
        AUTOALIGNCHANNEL                : in    std_logic_vector(CHANNEL_COUNT-1 downto 0);
        MANUAL_TAP                      : in    std_logic_vector(TAP_COUNT_BITS-1 downto 0);
        TRAINING                        : in    std_logic_vector(MAX_DATAWIDTH-1 downto 0);
        ENABLE_TRAINING                 : in    std_logic_vector(NROF_CONN-1 downto 0);

        --status
        CLK_STATUS                      : out   std_logic_vector((CLOCK_COUNT*16)-1 downto 0);
        
        EDGE_DETECT                     : out   std_logic_vector(NROF_CONN-1 downto 0);
        STABLE_DETECT                   : out   std_logic_vector(NROF_CONN-1 downto 0);
        FIRST_EDGE_FOUND                : out   std_logic_vector(NROF_CONN-1 downto 0);
        SECOND_EDGE_FOUND               : out   std_logic_vector(NROF_CONN-1 downto 0);
        NROF_RETRIES                    : out   std_logic_vector((NROF_CONN*16)-1 downto 0);
        TAP_SETTING                     : out   std_logic_vector((NROF_CONN*TAP_COUNT_BITS)-1 downto 0);
        WINDOW_WIDTH                    : out   std_logic_vector((NROF_CONN*TAP_COUNT_BITS)-1 downto 0);
        TAP_DRIFT                       : out   std_logic_vector((NROF_CONN*TAP_COUNT_BITS)-1 downto 0);
        WORD_ALIGN                      : out   std_logic_vector(NROF_CONN-1 downto 0);
        SLIP_COUNT                      : out   std_logic_vector((NROF_CONN*8)-1 downto 0);
        SHIFT_STATUS                    : out   std_logic_vector((6*CHANNEL_COUNT*NROF_CONN)-1 downto 0);

        EDGE_DETECT_CLK                 : out   std_logic_vector(CLOCK_COUNT-1 downto 0);
        STABLE_DETECT_CLK               : out   std_logic_vector(CLOCK_COUNT-1 downto 0);
        FIRST_EDGE_FOUND_CLK            : out   std_logic_vector(CLOCK_COUNT-1 downto 0);
        SECOND_EDGE_FOUND_CLK           : out   std_logic_vector(CLOCK_COUNT-1 downto 0);
        NROF_RETRIES_CLK                : out   std_logic_vector((CLOCK_COUNT*16)-1 downto 0);
        TAP_SETTING_CLK                 : out   std_logic_vector((CLOCK_COUNT*TAP_COUNT_BITS)-1 downto 0);
        WINDOW_WIDTH_CLK                : out   std_logic_vector((CLOCK_COUNT*TAP_COUNT_BITS)-1 downto 0);
        TAP_DRIFT_CLK                   : out   std_logic_vector((CLOCK_COUNT*TAP_COUNT_BITS)-1 downto 0);
        WORD_ALIGN_CLK                  : out   std_logic_vector(CLOCK_COUNT-1 downto 0);
        SLIP_COUNT_CLK                  : out   std_logic_vector((CLOCK_COUNT*8)-1 downto 0);

        --signals synchronous with CLKDIV(0)
        START_TRAINING_SYNC            : out   std_logic;
        BUSY_TRAINING_SYNC             : in    std_logic;

        FIFO_EN_SYNC                   : out    std_logic;

        DATAWIDTH_SYNC                 : out    integer;
        SINGLECHANNEL_SYNC             : out    std_logic_vector(7 downto 0);
        ALIGNMODE_SYNC                 : out    std_logic_vector(15 downto 0);
        AUTOALIGNCHANNEL_SYNC          : out    std_logic_vector(CHANNEL_COUNT-1 downto 0);
        MANUAL_TAP_SYNC                : out    std_logic_vector(TAP_COUNT_BITS-1 downto 0);
        TRAINING_SYNC                  : out    std_logic_vector(MAX_DATAWIDTH-1 downto 0);
        ENABLE_TRAINING_SYNC           : out    std_logic_vector(NROF_CONN-1 downto 0);

        CLK_STATUS_SYNC                : in    std_logic_vector((CLOCK_COUNT*16)-1 downto 0);

        EDGE_DETECT_SYNC               : in    std_logic_vector(NROF_CONN-1 downto 0);
        STABLE_DETECT_SYNC             : in    std_logic_vector(NROF_CONN-1 downto 0);
        FIRST_EDGE_FOUND_SYNC          : in    std_logic_vector(NROF_CONN-1 downto 0);
        SECOND_EDGE_FOUND_SYNC         : in    std_logic_vector(NROF_CONN-1 downto 0);
        NROF_RETRIES_SYNC              : in    std_logic_vector((NROF_CONN*16)-1 downto 0);
        TAP_SETTING_SYNC               : in    std_logic_vector((NROF_CONN*TAP_COUNT_BITS)-1 downto 0);
        WINDOW_WIDTH_SYNC              : in    std_logic_vector((NROF_CONN*TAP_COUNT_BITS)-1 downto 0);
        TAP_DRIFT_SYNC                 : in    std_logic_vector((NROF_CONN*TAP_COUNT_BITS)-1 downto 0);
        WORD_ALIGN_SYNC                : in    std_logic_vector(NROF_CONN-1 downto 0);
        SLIP_COUNT_SYNC                : in    std_logic_vector((NROF_CONN*8)-1 downto 0);
        SHIFT_STATUS_SYNC              : in    std_logic_vector((6*CHANNEL_COUNT*NROF_CONN)-1 downto 0);

        EDGE_DETECT_CLK_SYNC           : in    std_logic_vector(CLOCK_COUNT-1 downto 0);
        STABLE_DETECT_CLK_SYNC         : in    std_logic_vector(CLOCK_COUNT-1 downto 0);
        FIRST_EDGE_FOUND_CLK_SYNC      : in    std_logic_vector(CLOCK_COUNT-1 downto 0);
        SECOND_EDGE_FOUND_CLK_SYNC     : in    std_logic_vector(CLOCK_COUNT-1 downto 0);
        NROF_RETRIES_CLK_SYNC          : in    std_logic_vector((CLOCK_COUNT*16)-1 downto 0);
        TAP_SETTING_CLK_SYNC           : in    std_logic_vector((CLOCK_COUNT*TAP_COUNT_BITS)-1 downto 0);
        WINDOW_WIDTH_CLK_SYNC          : in    std_logic_vector((CLOCK_COUNT*TAP_COUNT_BITS)-1 downto 0);
        TAP_DRIFT_CLK_SYNC             : in    std_logic_vector((CLOCK_COUNT*TAP_COUNT_BITS)-1 downto 0);
        WORD_ALIGN_CLK_SYNC            : in    std_logic_vector(CLOCK_COUNT-1 downto 0);
        SLIP_COUNT_CLK_SYNC            : in    std_logic_vector((CLOCK_COUNT*8)-1 downto 0)
    );
end iserdes_sync;

architecture rtl of iserdes_sync is

type handshaketxtp is (     idle,
                            wait_ack_high,
                            wait_ack_low
                            );

signal handshaketx : handshaketxtp;

type handshakerxtp is (     idle,
                            wait_req_low
                            );

signal handshakerx : handshakerxtp;

signal ack          : std_logic;
signal ack_s        : std_logic;
signal ack_s2       : std_logic;

signal req          : std_logic;
signal req_s        : std_logic;
signal req_s2       : std_logic;

signal TimeOutCntr      : std_logic_vector(4 downto 0) := (others => '0');
constant TimeOutCntrLd  : std_logic_vector(TimeOutCntr'high downto 0) := "01111";

begin

--external control can
synctoclkdiv: process(CLKDIV_RESET, CLKDIV)
  begin
    if (CLKDIV_RESET = '1') then

        FIFO_EN_SYNC           <= '0';
        DATAWIDTH_SYNC         <= 8;
        SINGLECHANNEL_SYNC     <= (others => '0');
        ALIGNMODE_SYNC         <= (others => '0');
        AUTOALIGNCHANNEL_SYNC  <= (others => '0');
        MANUAL_TAP_SYNC        <= (others => '0');
        TRAINING_SYNC          <= (others => '0');
        ENABLE_TRAINING_SYNC   <= (others => '0');

    elsif (CLKDIV'event and CLKDIV = '1') then

        FIFO_EN_SYNC            <= FIFO_EN;
        DATAWIDTH_SYNC          <= DATAWIDTH;
        SINGLECHANNEL_SYNC      <= SINGLECHANNEL;
        ALIGNMODE_SYNC          <= ALIGNMODE;
        AUTOALIGNCHANNEL_SYNC   <= AUTOALIGNCHANNEL;
        MANUAL_TAP_SYNC         <= MANUAL_TAP;
        TRAINING_SYNC           <= TRAINING;
        ENABLE_TRAINING_SYNC    <= ENABLE_TRAINING;

    end if;
end process synctoclkdiv;

syncfromclkdiv: process(CLOCK_RESET, CLOCK)
  begin
    if (CLOCK_RESET = '1') then

        BUSY_TRAINING        <= '0';

        EDGE_DETECT          <= (others => '0');
        STABLE_DETECT        <= (others => '0');
        FIRST_EDGE_FOUND     <= (others => '0');
        SECOND_EDGE_FOUND    <= (others => '0');
        NROF_RETRIES         <= (others => '0');
        TAP_SETTING          <= (others => '0');
        WINDOW_WIDTH         <= (others => '0');
        TAP_DRIFT            <= (others => '0');
        WORD_ALIGN           <= (others => '0');
        SLIP_COUNT           <= (others => '0');
        SHIFT_STATUS         <= (others => '0');

        CLK_STATUS           <= (others => '0');

        EDGE_DETECT_CLK      <= (others => '0');
        STABLE_DETECT_CLK    <= (others => '0');
        FIRST_EDGE_FOUND_CLK <= (others => '0');
        SECOND_EDGE_FOUND_CLK<= (others => '0');
        NROF_RETRIES_CLK     <= (others => '0');
        TAP_SETTING_CLK      <= (others => '0');
        WINDOW_WIDTH_CLK     <= (others => '0');
        TAP_DRIFT_CLK        <= (others => '0');
        WORD_ALIGN_CLK       <= (others => '0');
        SLIP_COUNT_CLK       <= (others => '0');

    elsif (CLOCK'event and CLOCK = '1') then

        BUSY_TRAINING         <= BUSY_TRAINING_SYNC;

        EDGE_DETECT           <= EDGE_DETECT_SYNC;
        STABLE_DETECT         <= STABLE_DETECT_SYNC;
        FIRST_EDGE_FOUND      <= FIRST_EDGE_FOUND_SYNC;
        SECOND_EDGE_FOUND     <= SECOND_EDGE_FOUND_SYNC;
        NROF_RETRIES          <= NROF_RETRIES_SYNC;
        TAP_SETTING           <= TAP_SETTING_SYNC;
        WINDOW_WIDTH          <= WINDOW_WIDTH_SYNC;
        TAP_DRIFT             <= TAP_DRIFT_SYNC;
        WORD_ALIGN            <= WORD_ALIGN_SYNC;
        SLIP_COUNT            <= SLIP_COUNT_SYNC;
        SHIFT_STATUS          <= SHIFT_STATUS_SYNC;

        CLK_STATUS            <= CLK_STATUS_SYNC;

        EDGE_DETECT_CLK       <= EDGE_DETECT_CLK_SYNC;
        STABLE_DETECT_CLK     <= STABLE_DETECT_CLK_SYNC;
        FIRST_EDGE_FOUND_CLK  <= FIRST_EDGE_FOUND_CLK_SYNC;
        SECOND_EDGE_FOUND_CLK <= SECOND_EDGE_FOUND_CLK_SYNC;
        NROF_RETRIES_CLK      <= NROF_RETRIES_CLK_SYNC;
        TAP_SETTING_CLK       <= TAP_SETTING_CLK_SYNC;
        WINDOW_WIDTH_CLK      <= WINDOW_WIDTH_CLK_SYNC;
        TAP_DRIFT_CLK         <= TAP_DRIFT_CLK_SYNC;
        WORD_ALIGN_CLK        <= WORD_ALIGN_CLK_SYNC;
        SLIP_COUNT_CLK        <= SLIP_COUNT_CLK_SYNC;

    end if;
end process syncfromclkdiv;

handshake_tx: process(CLOCK_RESET, CLOCK)
  begin
    if (CLOCK_RESET = '1') then
        req             <= '0';
        ack_s           <= '0';
        ack_s2          <= '0';

        handshaketx     <= idle;
    elsif (CLOCK'event and CLOCK = '1') then

        ack_s  <= ack;
        ack_s2 <= ack_s;

        case handshaketx is
            when idle =>
                if (START_TRAINING = '1') then
                    req             <= '1';
                    TimeOutCntr     <= TimeOutCntrLd;
                    handshaketx     <= wait_ack_high;
                end if;

            when wait_ack_high =>
                if (ack_s2 = '1') then
                    req             <= '0';
                    TimeOutCntr     <= TimeOutCntrLd;
                    handshaketx     <= wait_ack_low;
                elsif (TimeOutCntr(TimeOutCntr'high) = '1') then
                    req             <= '0';
                    handshaketx     <= idle;
                else
                    TimeOutCntr <= TimeOutCntr - '1';
                end if;

            when wait_ack_low =>
                if (ack_s2 = '0') then
                    handshaketx     <= idle;
                elsif (TimeOutCntr(TimeOutCntr'high) = '1') then
                    handshaketx     <= idle;
                else
                    TimeOutCntr <= TimeOutCntr - '1';
                end if;

            when others =>
                handshaketx     <= idle;

        end case;
    end if;
end process handshake_tx;


handshake_rx: process(CLKDIV_RESET, CLKDIV)
  begin
    if (CLKDIV_RESET = '1') then
        ack             <= '0';
        req_s           <= '0';
        req_s2          <= '0';

        START_TRAINING_SYNC <= '0';

        handshakerx     <= idle;

    elsif (CLKDIV'event and CLKDIV = '1') then

        req_s       <= req;
        req_s2      <= req_s;

        START_TRAINING_SYNC <= '0';

        case handshakerx is
            when idle =>
                if (req_s2 = '1') then
                     ack                    <= '1';
                     START_TRAINING_SYNC    <= '1';
                     handshakerx            <= wait_req_low;
                end if;

            when wait_req_low =>
                if (req_s2 = '0') then
                    ack                     <= '0';
                    handshakerx             <= idle;
                end if;

            when others =>
                handshakerx                 <= idle;
        end case;
    end if;
end process handshake_rx;

end rtl;
