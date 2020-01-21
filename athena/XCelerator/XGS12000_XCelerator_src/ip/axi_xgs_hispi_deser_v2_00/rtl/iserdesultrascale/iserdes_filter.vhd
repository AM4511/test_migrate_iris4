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

entity iserdes_filter is
    generic (
        NROF_CONN               : integer;
        MAX_DATAWIDTH           : integer;
        CHANNEL_COUNT           : integer
    );
    port (
        CLOCK                       : in    std_logic;  --appclock
        RESET                       : in    std_logic;  --active high reset

        ENABLE                      : in    std_logic;
        SELECT_CHANNEL              : in    std_logic;
        SKIP                        : in    std_logic_vector(NROF_CONN-1 downto 0);

        CONCATINATED_VALID          : in    std_logic_vector((NROF_CONN*CHANNEL_COUNT)-1 downto 0);
        CONCATINATED_DATA           : in    std_logic_vector((MAX_DATAWIDTH*NROF_CONN*CHANNEL_COUNT)-1 downto 0);
        FIFO_WREN                   : in    std_logic;

        WRDATA_FILT                 : out   std_logic_vector((MAX_DATAWIDTH*NROF_CONN)-1 downto 0) := (others => '0');
        WREN_FILT                   : out   std_logic_vector(NROF_CONN-1 downto 0) := (others => '0')
    );
end iserdes_filter;

architecture rtl of iserdes_filter is

type filterstatetp is (idle, enabled);

signal filterstate : filterstatetp;

constant ones           : std_logic_vector(NROF_CONN-1 downto 0) := (others => '1');
constant zeros          : std_logic_vector(NROF_CONN-1 downto 0) := (others => '0');

signal equal            : std_logic := '0';
signal prev_equal       : std_logic := '0';
signal inverse          : std_logic := '0';

signal startok          : std_logic := '0';

signal valid_inverse    : std_logic_vector(NROF_CONN-1 downto 0) := (others => '0');

constant pipedepth  : integer := 3;

type datapipetp is array(0 to pipedepth-1) of std_logic_vector((MAX_DATAWIDTH*NROF_CONN)-1 downto 0);
type validpipetp is array(0 to pipedepth-1) of std_logic_vector((NROF_CONN)-1 downto 0);

signal wr_data_pipe : datapipetp := (others => (others => '0'));
signal wr_valid_pipe : validpipetp := (others => (others => '0'));
signal wr_en_pipe : std_logic_vector(0 to pipedepth-1) := (others => '0');

signal CONCATINATED_VALID_i : std_logic_vector(NROF_CONN-1 downto 0) := (others => '0');

alias data0 : std_logic_vector(MAX_DATAWIDTH-1 downto 0) is CONCATINATED_DATA((0*MAX_DATAWIDTH*CHANNEL_COUNT)+(MAX_DATAWIDTH-1) downto (0*MAX_DATAWIDTH*CHANNEL_COUNT));
alias data0_valid : std_logic is CONCATINATED_VALID(0*CHANNEL_COUNT);

alias data0_pipe : std_logic_vector(MAX_DATAWIDTH-1 downto 0) is wr_data_pipe(2)((0*MAX_DATAWIDTH)+(MAX_DATAWIDTH-1) downto (0*MAX_DATAWIDTH));
alias data0_valid_pipe : std_logic is wr_valid_pipe(2)(0);

begin

gen_valid: for i in 0 to NROF_CONN-1 generate
    CONCATINATED_VALID_i(i) <= CONCATINATED_VALID(CHANNEL_COUNT*i);
end generate;
 --detection of filtering
 -- equal -> prev_equal -> startok
 -- 2 clks pipeline
 equal_process: process(CLOCK)
    begin
       if (CLOCK'event and CLOCK = '1') then
            if (CONCATINATED_VALID_i = ones(NROF_CONN-1 downto 0)) then
                equal <= '1';
            elsif (CONCATINATED_VALID_i = zeros(NROF_CONN-1 downto 0)) then
                equal <= '1';
            else
                equal <= '0';
            end if;

            if (CONCATINATED_VALID_i = valid_inverse) then
                inverse <= '1';
            else
                inverse <= '0';
            end if;

            prev_equal <= equal;
            valid_inverse <= not CONCATINATED_VALID_i;

            if (equal = '1' and prev_equal = '1') then
                startok <= '1';
            elsif (inverse = '1' and prev_equal = '0') then
                startok <= '1';
            else
                startok <= '0';
            end if;

       end if;
  end process;

  pipe_process: process(CLOCK)
   begin
     if (CLOCK'event and CLOCK = '1') then
        if CHANNEL_COUNT = 2 then
           if SELECT_CHANNEL = '0' then
               for i in 0 to NROF_CONN-1 loop
                   wr_data_pipe(0)((i*MAX_DATAWIDTH)+(MAX_DATAWIDTH)-1 downto (i*MAX_DATAWIDTH)) <= CONCATINATED_DATA((i*CHANNEL_COUNT*MAX_DATAWIDTH)+(1*MAX_DATAWIDTH)-1 downto (i*CHANNEL_COUNT*MAX_DATAWIDTH));
               end loop;
           else
               for i in 0 to NROF_CONN-1 loop
                   wr_data_pipe(0)((i*MAX_DATAWIDTH)+(MAX_DATAWIDTH)-1 downto (i*MAX_DATAWIDTH)) <= CONCATINATED_DATA((i*CHANNEL_COUNT*MAX_DATAWIDTH)+(2*MAX_DATAWIDTH)-1 downto (i*CHANNEL_COUNT*MAX_DATAWIDTH)+(1*MAX_DATAWIDTH));
               end loop;
           end if;
        else
           for i in 0 to NROF_CONN-1 loop
             wr_data_pipe(0)((i*MAX_DATAWIDTH)+(MAX_DATAWIDTH)-1 downto (i*MAX_DATAWIDTH)) <= CONCATINATED_DATA((i*CHANNEL_COUNT*MAX_DATAWIDTH)+(1*MAX_DATAWIDTH)-1 downto (i*CHANNEL_COUNT*MAX_DATAWIDTH));
           end loop;
        end if;

        wr_valid_pipe(0) <= CONCATINATED_VALID_i;
        wr_en_pipe(0)   <= FIFO_WREN;
        for i in 0 to wr_data_pipe'high -1 loop
            wr_data_pipe(i+1) <= wr_data_pipe(i);
            wr_valid_pipe(i+1) <= wr_valid_pipe(i);
            wr_en_pipe(i+1) <= wr_en_pipe(i);
        end loop;
        WRDATA_FILT <= wr_data_pipe(2);
     end if;
   end process;

  en_process: process(CLOCK)
    begin
      if (CLOCK'event and CLOCK = '1') then
        case filterstate is
          when idle =>
            if ENABLE = '1' then
                if (wr_en_pipe(1) = '1' and startok = '1') then
                    WREN_FILT   <= wr_valid_pipe(2);
                    filterstate <= enabled;
                else
                    WREN_FILT   <= (others => '0');
                end if;
            else
                if (wr_en_pipe(1) = '1') then
                    WREN_FILT   <= wr_valid_pipe(2);
                    filterstate <= enabled;
                else
                    WREN_FILT   <= (others => '0');
                end if;
            end if;

          when enabled =>
            if (wr_en_pipe(1) = '0') then
                WREN_FILT   <= (others => '0');
                filterstate <= idle;
            else
                WREN_FILT   <= wr_valid_pipe(2);
            end if;

          when others =>
            filterstate <= idle;
        end case;
      end if;
  end process;
end rtl;
