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
entity iserdes_wordalign is
  generic (
        MAX_DATAWIDTH       : integer := 18;
        CHANNEL_COUNT       : integer := 2
  );
  port(
        CLOCK                   : in    std_logic;
        RESET                   : in    std_logic;

        DATAWIDTH               : in    integer;

        WORDALIGN_START         : in    std_logic;
        WORDALIGN_BUSY          : out   std_logic := '0';

        AUTOALIGNCHANNEL        : in    std_logic_vector(CHANNEL_COUNT-1 downto 0);   --selects which compare channels are used (high, low, both)
        TRAINING                : in    std_logic_vector(MAX_DATAWIDTH-1 downto 0);

        BITSLIP_RESET           : out   std_logic_vector((CHANNEL_COUNT)-1 downto 0);
        BITSLIP                 : out   std_logic_vector((CHANNEL_COUNT)-1 downto 0);
        CONCATINATED_VALID      : in    std_logic_vector((CHANNEL_COUNT)-1 downto 0);
        CONCATINATED_DATA       : in    std_logic_vector((CHANNEL_COUNT*MAX_DATAWIDTH)-1 downto 0);

        -- status info
        WORD_ALIGN              : out   std_logic := '0';
        SLIP_COUNT              : out   std_logic_vector(7 downto 0) := (others => '0')
  );
end iserdes_wordalign;

architecture rtl of iserdes_wordalign is

type alignstatetp is (  Idle,
                        CheckSlipCount,
                        CheckData,
                        ApplyBitslip,
                        WaitPipe
                        );

signal alignstate       : alignstatetp := Idle;

signal bitslip_i        : std_logic := '0';
signal bitslip_reset_i  : std_logic := '0';
signal data_valid_s     : std_logic := '0';
signal data_valid_i     : std_logic := '0';
signal data_valid_r     : std_logic := '0';
signal equal_ch         : std_logic_vector((CHANNEL_COUNT)-1 downto 0) := (others => '0');
signal equal            : std_logic := '0';
signal slipcntr         : std_logic_vector(4 downto 0) := (others => '0');
constant gencntrld      : std_logic_vector(4 downto 0) := "01111";
signal gencntr          : std_logic_vector(gencntrld'high downto 0) := "01111";

alias  ch0_data         : std_logic_vector(MAX_DATAWIDTH-1 downto 0) is CONCATINATED_DATA((0*MAX_DATAWIDTH)+(MAX_DATAWIDTH-1) downto (0*MAX_DATAWIDTH));

constant zeros          : std_logic_vector(19 downto 0) := (others => '0');
signal data_mask        : std_logic_vector(19 downto 0) := (others => '0');

signal concatinated_data_s : std_logic_vector((CHANNEL_COUNT*MAX_DATAWIDTH)-1 downto 0) := (others => '0');

begin

BITSLIP_RESET <= (others => bitslip_reset_i);
BITSLIP <= (others => bitslip_i);
SLIP_COUNT <= "000" & slipcntr;

comparator: process(CLOCK)
    variable equal_tmp : std_logic := '1';
    variable equal_ch_tmp : std_logic_vector((CHANNEL_COUNT)-1 downto 0) := (others => '1');
  begin
    if (CLOCK'event and CLOCK = '1') then

        --use channel to wordalign on depending on selected channels
        data_valid_r <= '0';
        data_valid_s <= '0';
        data_valid_i <= data_valid_s;
        if CHANNEL_COUNT <= 1 then
            data_valid_s <= CONCATINATED_VALID(0);
        else
            if AUTOALIGNCHANNEL(0) = '1' then
                data_valid_s <= CONCATINATED_VALID(0);
            elsif AUTOALIGNCHANNEL(1) = '1' then
                data_valid_s <= CONCATINATED_VALID(1);
            end if;
        end if;
        concatinated_data_s <= CONCATINATED_DATA;

        --mask generation
        case DATAWIDTH is
            when 6 =>
                data_mask <= zeros(data_mask'high downto 6) & "111111";
            when 8 =>
                data_mask <= zeros(data_mask'high downto 8) & "11111111";
            when 10 =>
                data_mask <= zeros(data_mask'high downto 10) & "1111111111";
            when 12 =>
                data_mask <= zeros(data_mask'high downto 12) & "111111111111";
            when 14 =>
                data_mask <= zeros(data_mask'high downto 14) & "11111111111111";
            when 16 => 
                data_mask <= zeros(data_mask'high downto 16) & "1111111111111111";
            when 18 =>
                data_mask <= zeros(data_mask'high downto 18) & "111111111111111111";
            
            when others =>
                -- set to 16 bit
                data_mask <= zeros(data_mask'high downto 16) & "1111111111111111";
        end case;

        --use channel to wordalign on depending on selected channels
        if data_valid_s = '1' then
            for i in 0 to CHANNEL_COUNT-1 loop
                --compare every bit where mask is set
                equal_ch_tmp(i) := '1';
                for j in 0 to MAX_DATAWIDTH-1 loop
                    if ((concatinated_data_s((i*MAX_DATAWIDTH)+j) /= TRAINING(j)) and data_mask(MAX_DATAWIDTH-j-1) = '1') then
                        equal_ch_tmp(i) := '0'; 
                    end if;
                end loop;
                equal_ch(i) <= equal_ch_tmp(i);
            end loop;
            data_valid_i <= '1';
        end if;

        if (data_valid_i = '1') then
            data_valid_r <= '1';
            equal_tmp := '1';
            for i in 0 to CHANNEL_COUNT-1 loop
                equal_tmp := equal_tmp and equal_ch(i);
            end loop;
            equal <= equal_tmp;
        end if;
    end if;
end process;

aligning: process(CLOCK)
  begin
    if (CLOCK'event and CLOCK = '1') then

        bitslip_i           <= '0';
        bitslip_reset_i     <= '0';
        
        if (RESET = '1') then
            WORD_ALIGN          <= '0';
            WORDALIGN_BUSY      <= '0';
            slipcntr            <= (others => '0');
            gencntr             <= (others => '0');
            alignstate          <= Idle;
        else
            case alignstate is
                when Idle =>
                    WORDALIGN_BUSY      <= '0';
                    if (WORDALIGN_START = '1') then
                        slipcntr        <= (others => '0');
                        WORD_ALIGN      <= '0';
                        WORDALIGN_BUSY  <= '1';
                        bitslip_reset_i <= '1';
                        alignstate      <= ApplyBitslip;
                    end if;
            
                when CheckSlipCount =>
                    if (slipcntr = std_logic_vector(to_unsigned(DATAWIDTH, 5))) then --maximum bitslip attempts passed
                        alignstate      <= Idle;
                    else
                        alignstate      <= CheckData;
                    end if;
            
                when CheckData =>
                    if (data_valid_r = '1') then
                        if (equal = '1') then
                            WORD_ALIGN          <= '1';
                            alignstate          <= Idle;
                        else
                            bitslip_i           <= '1';
                            slipcntr            <= slipcntr + '1';
                            alignstate          <= ApplyBitslip;
                        end if;
                    end if;
            
                when ApplyBitslip =>
                    gencntr             <= gencntrld;
                    alignstate          <= WaitPipe;
            
                when WaitPipe =>
                    if (gencntr(gencntr'high) = '1') then
                        alignstate          <= CheckSlipCount;
                    else
                        gencntr <= gencntr - '1';
                    end if;
            
                when others =>
                    alignstate   <= Idle;
            
            end case;
        end if;
    end if;
end process;

end rtl;