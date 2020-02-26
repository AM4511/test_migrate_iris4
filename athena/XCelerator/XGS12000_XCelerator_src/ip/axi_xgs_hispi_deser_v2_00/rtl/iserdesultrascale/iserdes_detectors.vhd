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
entity iserdes_detectors is
    generic (
        SERDES_DATAWIDTH    : integer := 6;
        CHANNEL_COUNT       : integer := 2;
        SERDES_COUNT        : integer := 2
    );
    port (
        CLOCK                   : in    std_logic;
        RESET                   : in    std_logic;

        CYCLE_VALID             : in    std_logic;
        ISERDES_DATAOUT         : in    std_logic_vector((CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH)-1 downto 0);

        --ctrl info
        AUTOALIGNCHANNEL        : in    std_logic_vector(CHANNEL_COUNT-1 downto 0);   --selects which compare channels are used (high, low, both)

        COMPARE_LOAD            : in    std_logic;

        DET_VALID               : out   std_logic;
        EDGE                    : out   std_logic;
        EQUAL                   : out   std_logic;
        CURRISPREV              : out   std_logic;
        SHIFTED1                : out   std_logic;
        SHIFTED2                : out   std_logic
       );
end iserdes_detectors;

architecture rtl of iserdes_detectors is

constant ones               : std_logic_vector(31 downto 0) := X"FFFFFFFF";
constant zeros              : std_logic_vector(31 downto 0) := X"00000000";

signal iserdes_dataout_d    : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH)-1 downto 0) := (others => '0');
signal iserdes_dataout_d2   : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH)-1 downto 0) := (others => '0');
signal iserdes_dataout_d3   : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH)-1 downto 0) := (others => '0');
signal iserdes_dataout_d4   : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH)-1 downto 0) := (others => '0');

signal cycle_valid_d        : std_logic := '0';
signal cycle_valid_d2       : std_logic := '0';
signal cycle_valid_d3       : std_logic := '0';

signal iserdes_dataout_w    : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH*3)-1 downto 0) := (others => '0');
signal iserdes_dataout_w_d  : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH*3)-1 downto 0) := (others => '0');

signal iserdes_dataout_w_r  : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH*3)-1 downto 0) := (others => '0');

-- required for edge detect
signal edge_int             : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH*3)-1 downto 0);
signal edge_int_or          : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0) := (others => '0');

signal edge_int_all         : std_logic := '0';

--required for stable detect
signal equal_all            : std_logic  := '0';
signal equal_ch             : std_logic_vector(CHANNEL_COUNT-1 downto 0) := (others => '0');
signal equal_sd             : std_logic_vector(SERDES_COUNT-1 downto 0) := (others => '0');

signal curr_is_prev         : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0) := (others => '0');
signal curr_is_prev_all     : std_logic := '0';
signal curr_is_prev_ch      : std_logic_vector(CHANNEL_COUNT-1 downto 0) := (others => '0');

--required for first/2nd edge detect
signal shift_1_data_w       : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH*3)-1 downto 0) := (others => '0');
signal shift_2_data_w       : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH*3)-1 downto 0) := (others => '0');

signal shift_1_data_w_c     : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH*3)-1 downto 0) := (others => '0');
signal shift_2_data_w_c     : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT*SERDES_DATAWIDTH*3)-1 downto 0) := (others => '0');

signal data_shifted_1       : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0)  := (others => '0');
signal data_shifted_1_all   : std_logic := '0';
signal data_shifted_1_ch    : std_logic_vector(CHANNEL_COUNT-1 downto 0)  := (others => '0');

signal data_shifted_2       : std_logic_vector((CHANNEL_COUNT*SERDES_COUNT)-1 downto 0)  := (others => '0');
signal data_shifted_2_all   : std_logic := '0';
signal data_shifted_2_ch    : std_logic_vector(CHANNEL_COUNT-1 downto 0)  := (others => '0');

signal compare_load_valid   : std_logic := '0';

--debug
signal ch0           : std_logic_vector(SERDES_DATAWIDTH*3-1 downto 0) := (others => '0');
signal ch1           : std_logic_vector(SERDES_DATAWIDTH*3-1 downto 0) := (others => '0');
signal ch2           : std_logic_vector(SERDES_DATAWIDTH*3-1 downto 0) := (others => '0');
signal ch3           : std_logic_vector(SERDES_DATAWIDTH*3-1 downto 0) := (others => '0');

signal ch0_r         : std_logic_vector(SERDES_DATAWIDTH*3-1 downto 0) := (others => '0');
signal ch1_r         : std_logic_vector(SERDES_DATAWIDTH*3-1 downto 0) := (others => '0');
signal ch2_r         : std_logic_vector(SERDES_DATAWIDTH*3-1 downto 0) := (others => '0');
signal ch3_r         : std_logic_vector(SERDES_DATAWIDTH*3-1 downto 0) := (others => '0');

signal ch0_d         : std_logic_vector(SERDES_DATAWIDTH*3-1 downto 0) := (others => '0');
signal ch1_d         : std_logic_vector(SERDES_DATAWIDTH*3-1 downto 0) := (others => '0');
signal ch2_d         : std_logic_vector(SERDES_DATAWIDTH*3-1 downto 0) := (others => '0');
signal ch3_d         : std_logic_vector(SERDES_DATAWIDTH*3-1 downto 0) := (others => '0');

signal sh1_ch0       : std_logic_vector(SERDES_DATAWIDTH*3-1 downto 0) := (others => '0');
signal sh1_ch1       : std_logic_vector(SERDES_DATAWIDTH*3-1 downto 0) := (others => '0');
signal sh1_ch2       : std_logic_vector(SERDES_DATAWIDTH*3-1 downto 0) := (others => '0');
signal sh1_ch3       : std_logic_vector(SERDES_DATAWIDTH*3-1 downto 0) := (others => '0');
                     
signal sh2_ch0       : std_logic_vector(SERDES_DATAWIDTH*3-1 downto 0) := (others => '0');
signal sh2_ch1       : std_logic_vector(SERDES_DATAWIDTH*3-1 downto 0) := (others => '0');
signal sh2_ch2       : std_logic_vector(SERDES_DATAWIDTH*3-1 downto 0) := (others => '0');
signal sh2_ch3       : std_logic_vector(SERDES_DATAWIDTH*3-1 downto 0) := (others => '0');

signal sh1_ch0_c     : std_logic_vector(SERDES_DATAWIDTH*3-1 downto 0) := (others => '0');
signal sh1_ch1_c     : std_logic_vector(SERDES_DATAWIDTH*3-1 downto 0) := (others => '0');
signal sh1_ch2_c     : std_logic_vector(SERDES_DATAWIDTH*3-1 downto 0) := (others => '0');
signal sh1_ch3_c     : std_logic_vector(SERDES_DATAWIDTH*3-1 downto 0) := (others => '0');

signal sh2_ch0_c     : std_logic_vector(SERDES_DATAWIDTH*3-1 downto 0) := (others => '0');
signal sh2_ch1_c     : std_logic_vector(SERDES_DATAWIDTH*3-1 downto 0) := (others => '0');
signal sh2_ch2_c     : std_logic_vector(SERDES_DATAWIDTH*3-1 downto 0) := (others => '0');
signal sh2_ch3_c     : std_logic_vector(SERDES_DATAWIDTH*3-1 downto 0) := (others => '0');

--some more debug stuff
alias iserdes_dataout_ch0 : std_logic_vector(SERDES_DATAWIDTH-1 downto 0) is iserdes_dataout(SERDES_DATAWIDTH-1 downto 0);
alias iserdes_dataout_d_ch0 : std_logic_vector(SERDES_DATAWIDTH-1 downto 0) is iserdes_dataout_d(SERDES_DATAWIDTH-1 downto 0);
alias iserdes_dataout_d2_ch0 : std_logic_vector(SERDES_DATAWIDTH-1 downto 0) is iserdes_dataout_d2(SERDES_DATAWIDTH-1 downto 0);
alias iserdes_dataout_d3_ch0 : std_logic_vector(SERDES_DATAWIDTH-1 downto 0) is iserdes_dataout_d3(SERDES_DATAWIDTH-1 downto 0);
alias iserdes_dataout_d4_ch0 : std_logic_vector(SERDES_DATAWIDTH-1 downto 0) is iserdes_dataout_d4(SERDES_DATAWIDTH-1 downto 0);

attribute keep : string;

attribute keep of edge_int_all : signal is "TRUE";

attribute keep of curr_is_prev : signal is "TRUE";
attribute keep of curr_is_prev_all : signal is "TRUE";
attribute keep of curr_is_prev_ch : signal is "TRUE";

attribute keep of equal_all : signal is "TRUE";
attribute keep of equal_ch : signal is "TRUE";
attribute keep of equal_sd : signal is "TRUE";

attribute keep of data_shifted_1 : signal is "TRUE";
attribute keep of data_shifted_1_all : signal is "TRUE";
attribute keep of data_shifted_1_ch : signal is "TRUE";

attribute keep of data_shifted_2 : signal is "TRUE";
attribute keep of data_shifted_2_all : signal is "TRUE";
attribute keep of data_shifted_2_ch : signal is "TRUE";

attribute keep of iserdes_dataout_w_r : signal is "TRUE";
attribute keep of iserdes_dataout_d : signal is "TRUE";

begin

DET_VALID               <= cycle_valid_d2;
EDGE                    <= edge_int_all;
EQUAL                   <= equal_all;
CURRISPREV              <= curr_is_prev_all;
SHIFTED1                <= data_shifted_1_all;
SHIFTED2                <= data_shifted_2_all;

--cycle_valid_pipe
cycle_valid_pipe: process(CLOCK)
  begin
    if (CLOCK'event and CLOCK = '1') then
        cycle_valid_d  <= CYCLE_VALID;
        cycle_valid_d2 <= cycle_valid_d;
        cycle_valid_d3 <= cycle_valid_d2;  
        compare_load_valid <= '0';
        if CYCLE_VALID = '1' then
            compare_load_valid <= COMPARE_LOAD;
        end if;
    end if;
end process;

--data pipelining, makes vectors of SERDES_DATAWIDTH*3
data_pipelineing: process(CLOCK)
  begin
    if (CLOCK'event and CLOCK = '1') then
        iserdes_dataout_d <= ISERDES_DATAOUT;
        iserdes_dataout_d2 <= iserdes_dataout_d;
        iserdes_dataout_d3 <= iserdes_dataout_d2;
        iserdes_dataout_d4 <= iserdes_dataout_d3;

        if (CYCLE_VALID = '1') then
            iserdes_dataout_w_r <= iserdes_dataout_w;
        end if;

    end if;
end process;

-- data combinations are as follows (in case of 6 bit serdes):
-- ISERDES_DATAOUT
-- 23 dt 18 | 17 dt 12 | 11 dt 6  | 5 dt 0  |
--  CH1 SD1 |  CH1 SD0 | CH0 SD1  | CH0 SD0 |

gen_wide_datavectors: for i in 0 to (CHANNEL_COUNT*SERDES_COUNT)-1 generate
    --wide vector
    iserdes_dataout_w((i*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3)-1 downto (i*SERDES_DATAWIDTH*3)) <=
           iserdes_dataout_d2((i*SERDES_DATAWIDTH)+SERDES_DATAWIDTH-1 downto (i*SERDES_DATAWIDTH)) &
           iserdes_dataout_d((i*SERDES_DATAWIDTH)+SERDES_DATAWIDTH-1 downto (i*SERDES_DATAWIDTH)) &
           ISERDES_DATAOUT((i*SERDES_DATAWIDTH)+SERDES_DATAWIDTH-1 downto (i*SERDES_DATAWIDTH));

    --wide vector for use in shift application
    iserdes_dataout_w_d((i*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3)-1 downto (i*SERDES_DATAWIDTH*3)) <=
           iserdes_dataout_d3((i*SERDES_DATAWIDTH)+SERDES_DATAWIDTH-1 downto (i*SERDES_DATAWIDTH)) &
           iserdes_dataout_d2((i*SERDES_DATAWIDTH)+SERDES_DATAWIDTH-1 downto (i*SERDES_DATAWIDTH)) &
           iserdes_dataout_d((i*SERDES_DATAWIDTH)+SERDES_DATAWIDTH-1 downto (i*SERDES_DATAWIDTH));

    --wide vector shifted by one
    shift_1_data_w((i*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3)-1 downto (i*SERDES_DATAWIDTH*3)) <=
           iserdes_dataout_d4((i*SERDES_DATAWIDTH)) &
           iserdes_dataout_d3((i*SERDES_DATAWIDTH)+SERDES_DATAWIDTH-1 downto (i*SERDES_DATAWIDTH)) &
           iserdes_dataout_d2((i*SERDES_DATAWIDTH)+SERDES_DATAWIDTH-1 downto (i*SERDES_DATAWIDTH)) &
           iserdes_dataout_d((i*SERDES_DATAWIDTH)+SERDES_DATAWIDTH-1 downto (i*SERDES_DATAWIDTH)+1);

    --wide vector shifted by two
    shift_2_data_w((i*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3)-1 downto (i*SERDES_DATAWIDTH*3)) <=
           iserdes_dataout_d4((i*SERDES_DATAWIDTH)+1 downto (i*SERDES_DATAWIDTH)) &
           iserdes_dataout_d3((i*SERDES_DATAWIDTH)+SERDES_DATAWIDTH-1 downto (i*SERDES_DATAWIDTH)) &
           iserdes_dataout_d2((i*SERDES_DATAWIDTH)+SERDES_DATAWIDTH-1 downto (i*SERDES_DATAWIDTH)) &
           iserdes_dataout_d((i*SERDES_DATAWIDTH)+SERDES_DATAWIDTH-1 downto (i*SERDES_DATAWIDTH)+2);
end generate;

--one extra clk due to muxing of control signals
--one clk for controls to propagate to delay ouputs
--default delay on 6bit serdes = 2 clks due to clock sampling pipeline present on iserdes_dataout in datapath
--one extra clk due to muxing of dataout signals
--due to word combining of 6bit to 18bit, there is an additional 2 clks of delay
-- -> total 7 clks of delay


-- edge detectors
--pipelining:
--edge_int -> 7 clks
--edge_int_or -> 8 clk
--edge_int_all -> 9 clks

-- for each serdes in the datavector
gen_edge_detectors: for i in 0 to (CHANNEL_COUNT*SERDES_COUNT)-1 generate
    gen_edge_detect: for j in 0 to ((SERDES_DATAWIDTH*3)-2) generate
        edge_int((i*SERDES_DATAWIDTH*3)+j) <= iserdes_dataout_w((i*SERDES_DATAWIDTH*3)+j) xor iserdes_dataout_w((i*SERDES_DATAWIDTH*3)+j+1);
    end generate;
    --remaining edge
    edge_int((i*SERDES_DATAWIDTH*3)+SERDES_DATAWIDTH*3-1) <= iserdes_dataout_w((i*SERDES_DATAWIDTH*3)+0) xor iserdes_dataout_w((i*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3)-1);

    edge_detect_process: process(CLOCK)
        variable edge_tmp       : std_logic := '0';
    begin
      if (CLOCK'event and CLOCK = '1') then
          if (CYCLE_VALID = '1') then
              -- funny workaround to make OR-ing of parametrisable signals into one signal work
              edge_tmp := '0';
              for k in 0 to (SERDES_DATAWIDTH*3)-1 loop
                  --rewritten for sim
                  if ((edge_int((i*SERDES_DATAWIDTH*3)+k) = '1') or edge_tmp = '1') then
                    edge_tmp := '1';
                  end if;
              end loop;
              edge_int_or(i) <= edge_tmp;
          end if;
      end if;
    end process;
end generate;

edge_detect_process2: process(CLOCK)
    variable edge_all_tmp   : std_logic := '0';
  begin
     if (CLOCK'event and CLOCK = '1') then
         if (cycle_valid_d = '1') then
            -- funny workaround to make OR-ing of parametrisable signals into one signal work
            edge_all_tmp := '1';

            for k in 0 to CHANNEL_COUNT-1 loop
                for m in 0 to SERDES_COUNT-1 loop
                    edge_all_tmp := (edge_int_or(m+SERDES_COUNT*k) or not AUTOALIGNCHANNEL(k)) and edge_all_tmp;
                end loop;
            end loop;

            edge_int_all <= edge_all_tmp;
         end if;
     end if;
end process;

--equal detectors
--pipelining:
--equal_ch(x) -> 8 clk
--equal_sd(x) -> 8 clk
--equal_all   -> 9 clks

--between serdes within a channel
gen_channels: for i in 0 to CHANNEL_COUNT-1 generate
    --gen_serdes_used: for j in 0 to SERDES_COUNT-1 generate
    --
    --end generate;
    channel_equal_decoder: process(CLOCK)
        variable equal_tmp: std_logic := '1';
        variable equal_result: std_logic := '1';
      begin
        if (CLOCK'event and CLOCK = '1') then
            if (CYCLE_VALID = '1') then
                equal_tmp := '1';
                if (SERDES_COUNT = 1) then
                    equal_ch(i) <= equal_tmp;
                else
                    for j in 0 to SERDES_COUNT-2 loop
                        if (iserdes_dataout_w((i*SERDES_COUNT*SERDES_DATAWIDTH*3)+(j*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3)-1 downto (i*SERDES_COUNT*SERDES_DATAWIDTH*3)+(j*SERDES_DATAWIDTH*3)) =
                            iserdes_dataout_w((i*SERDES_COUNT*SERDES_DATAWIDTH*3)+((j+1)*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3)-1 downto (i*SERDES_COUNT*SERDES_DATAWIDTH*3)+((j+1)*SERDES_DATAWIDTH*3))) then
                            equal_result := '1' or not AUTOALIGNCHANNEL(i);
                        else
                            equal_result := '0' or not AUTOALIGNCHANNEL(i);
                        end if;
                        equal_tmp := equal_tmp and equal_result;
                    end loop;
                    equal_ch(i) <= equal_tmp;
                end if;
            end if;
        end if;
    end process;
end generate;

--between same serdes # of different channels
gen_serdess: for i in 0 to SERDES_COUNT-1 generate
    serdes_equal_decoder: process(CLOCK)
        variable equal_tmp: std_logic := '1';
        variable equal_result: std_logic := '1';
      begin
        if (CLOCK'event and CLOCK = '1') then
            if (CYCLE_VALID = '1') then
                equal_tmp := '1';
                if (CHANNEL_COUNT = 1) then
                    equal_sd(i) <= equal_tmp;
                else
                    for j in 0 to CHANNEL_COUNT-2 loop
                        if (iserdes_dataout_w((i*SERDES_DATAWIDTH*3)+(j*SERDES_COUNT*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3)-1 downto (i*SERDES_DATAWIDTH*3)+(j*SERDES_DATAWIDTH*SERDES_COUNT*3)) =
                            iserdes_dataout_w((i*SERDES_DATAWIDTH*3)+((j+1)*SERDES_DATAWIDTH*SERDES_COUNT*3)+(SERDES_DATAWIDTH*3)-1 downto (i*SERDES_DATAWIDTH*3)+((j+1)*SERDES_DATAWIDTH*SERDES_COUNT*3))) then
                            equal_result := '1';
                        else
                            equal_result := '0';
                        end if;
                        equal_tmp := equal_tmp and equal_result;
                    end loop;
                    equal_sd(i) <= equal_tmp;
                end if;
            end if;
        end if;
    end process;
end generate;

channelall_equal_decoder: process(CLOCK)
    variable equal_tmp: std_logic := '1';
  begin
    if (CLOCK'event and CLOCK = '1') then
        if (cycle_valid_d = '1') then
            if (AUTOALIGNCHANNEL = "11") then
                -- check between channels
                if ((equal_ch = ones(CHANNEL_COUNT-1 downto 0)) and (equal_sd = ones(SERDES_COUNT-1 downto 0))) then
                    equal_all <= '1';
                else
                    equal_all <= '0';
                end if;
            else
                --only per channel
                if (equal_ch = ones(CHANNEL_COUNT-1 downto 0)) then
                    equal_all <= '1';
                else
                    equal_all <= '0';
                end if;
            end if;
        end if;
    end if;
end process;

--between the previous data sample and the current one
--pipelining:
--curr_is_prev(x): 8 clk
--curr_is_prev_all: 9 clks
--curr_is_prev_ch(x): 9 clks

curr_prev_equal_decoder: process(CLOCK)
    variable equal_tmp: std_logic := '1';
  begin
    if (CLOCK'event and CLOCK = '1') then
        if (CYCLE_VALID = '1') then
            for i in 0 to (CHANNEL_COUNT*SERDES_COUNT)-1 loop
                if (iserdes_dataout_w((i*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3)-1 downto (i*SERDES_DATAWIDTH*3)) = iserdes_dataout_w_r((i*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3)-1 downto (i*SERDES_DATAWIDTH*3))) then
                    curr_is_prev(i) <= '1';
                else
                    curr_is_prev(i) <= '0';
                end if;
            end loop;

            for i in 0 to CHANNEL_COUNT-1 loop
                if (iserdes_dataout_w((i*(SERDES_DATAWIDTH*3*SERDES_COUNT))+(SERDES_DATAWIDTH*3)-1 downto (i*SERDES_DATAWIDTH*3*SERDES_COUNT)) = iserdes_dataout_w_r((i*SERDES_DATAWIDTH*3*SERDES_COUNT)+(SERDES_DATAWIDTH*3)-1 downto (i*SERDES_DATAWIDTH*3*SERDES_COUNT))) then
                    curr_is_prev_ch(i) <= '1' or not AUTOALIGNCHANNEL(i);
                else
                    curr_is_prev_ch(i) <= '0' or not AUTOALIGNCHANNEL(i);
                end if;
            end loop;
        end if;

        if (cycle_valid_d = '1') then
            if (curr_is_prev_ch = ones(CHANNEL_COUNT-1 downto 0)) then
                curr_is_prev_all <= '1';
            else
                curr_is_prev_all <= '0';
            end if;
        end if;
    end if;
end process;

--rotation checks
--pipelining:
-- data_shifted_1(x): 8 clk
-- data_shifted_1_all: 9 clks
-- data_shifted_1_ch(x): 9 clks
-- data_shifted_2(x): 8 clk
-- data_shifted_2_all: 9 clks
-- data_shifted_2_ch(x): 9 clks

rotate_equal_decoder: process(CLOCK)
    variable equal_tmp: std_logic := '1';
  begin
    if (CLOCK'event and CLOCK = '1') then
        if (compare_load_valid = '1') then --compare load is generated after cycle valid
            shift_1_data_w_c <= shift_1_data_w;
            shift_2_data_w_c <= shift_2_data_w;

            data_shifted_1      <= (others => '0');
            data_shifted_1_all  <= '0';
            data_shifted_1_ch   <= (others => '0');

            data_shifted_2      <= (others => '0');
            data_shifted_2_all  <= '0';
            data_shifted_2_ch   <= (others => '0');
        else
            if (CYCLE_VALID = '1') then
                for i in 0 to (CHANNEL_COUNT*SERDES_COUNT)-1 loop
                    if (shift_1_data_w_c((i*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3)-1 downto (i*SERDES_DATAWIDTH*3)) =
                        iserdes_dataout_w((i*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3)-1 downto (i*SERDES_DATAWIDTH*3))) then
                        data_shifted_1(i) <= '1';
                    else
                        data_shifted_1(i) <= '0';
                    end if;
                end loop;

                for i in 0 to CHANNEL_COUNT-1 loop
                    if (shift_1_data_w_c((i*SERDES_DATAWIDTH*3*SERDES_COUNT)+(SERDES_DATAWIDTH*3)-1 downto (i*SERDES_DATAWIDTH*3*SERDES_COUNT)) =
                        iserdes_dataout_w((i*SERDES_DATAWIDTH*3*SERDES_COUNT)+(SERDES_DATAWIDTH*3)-1 downto (i*SERDES_DATAWIDTH*3*SERDES_COUNT))) then
                        data_shifted_1_ch(i) <= '1' or not AUTOALIGNCHANNEL(i);
                    else
                        data_shifted_1_ch(i) <= '0' or not AUTOALIGNCHANNEL(i);
                    end if;
                end loop;
            end if;

            if (cycle_valid_d = '1') then
                if (data_shifted_1_ch = ones(CHANNEL_COUNT-1 downto 0)) then
                    data_shifted_1_all <= '1';
                else
                    data_shifted_1_all <= '0';
                end if;
            end if;

            if (CYCLE_VALID = '1') then
                for i in 0 to (CHANNEL_COUNT*SERDES_COUNT)-1 loop
                    if (shift_2_data_w_c((i*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3)-1 downto (i*SERDES_DATAWIDTH*3)) =
                        iserdes_dataout_w((i*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3)-1 downto (i*SERDES_DATAWIDTH*3))) then
                        data_shifted_2(i) <= '1';
                    else
                        data_shifted_2(i) <= '0';
                    end if;
                end loop;

                for i in 0 to CHANNEL_COUNT-1 loop
                    if (shift_2_data_w_c((i*SERDES_DATAWIDTH*3*SERDES_COUNT)+(SERDES_DATAWIDTH*3)-1 downto (i*SERDES_DATAWIDTH*3*SERDES_COUNT)) =
                        iserdes_dataout_w((i*SERDES_DATAWIDTH*3*SERDES_COUNT)+(SERDES_DATAWIDTH*3)-1 downto (i*SERDES_DATAWIDTH*3*SERDES_COUNT))) then
                        data_shifted_2_ch(i) <= '1' or not AUTOALIGNCHANNEL(i);
                    else
                        data_shifted_2_ch(i) <= '0' or not AUTOALIGNCHANNEL(i);
                    end if;
                end loop;
            end if;

            if (cycle_valid_d = '1') then
                if (data_shifted_2_ch = ones(CHANNEL_COUNT-1 downto 0)) then
                    data_shifted_2_all <= '1';
                else
                    data_shifted_2_all <= '0';
                end if;

            end if;
        end if;
    end if;
end process;

--debug stuff, only useful for sim
generate_4_channel_debug: if CHANNEL_COUNT*SERDES_COUNT=4 generate
    ch2     <= iserdes_dataout_w((2*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3-1) downto (2*SERDES_DATAWIDTH*3));
    ch3     <= iserdes_dataout_w((3*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3-1) downto (3*SERDES_DATAWIDTH*3));
    ch2_r   <= iserdes_dataout_w_r((2*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3-1) downto (2*SERDES_DATAWIDTH*3));
    ch3_r   <= iserdes_dataout_w_r((3*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3-1) downto (3*SERDES_DATAWIDTH*3));
    ch2_d   <= iserdes_dataout_w_d((2*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3-1) downto (2*SERDES_DATAWIDTH*3));
    ch3_d   <= iserdes_dataout_w_d((3*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3-1) downto (3*SERDES_DATAWIDTH*3));
    sh1_ch2_c <= shift_1_data_w_c((2*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3-1) downto (2*SERDES_DATAWIDTH*3));
    sh1_ch3_c <= shift_1_data_w_c((3*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3-1) downto (3*SERDES_DATAWIDTH*3));
    sh2_ch2_c <= shift_2_data_w_c((2*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3-1) downto (2*SERDES_DATAWIDTH*3));
    sh2_ch3_c <= shift_2_data_w_c((3*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3-1) downto (3*SERDES_DATAWIDTH*3)); 
    sh1_ch2 <= shift_1_data_w((2*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3-1) downto (2*SERDES_DATAWIDTH*3));
    sh1_ch3 <= shift_1_data_w((3*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3-1) downto (3*SERDES_DATAWIDTH*3));
    sh2_ch2 <= shift_2_data_w((2*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3-1) downto (2*SERDES_DATAWIDTH*3));
    sh2_ch3 <= shift_2_data_w((3*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3-1) downto (3*SERDES_DATAWIDTH*3)); 
    
end generate;

generate_2_channel_debug: if CHANNEL_COUNT*SERDES_COUNT>1 generate
    ch1     <= iserdes_dataout_w((1*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3-1) downto (1*SERDES_DATAWIDTH*3));
    ch1_r   <= iserdes_dataout_w_r((1*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3-1) downto (1*SERDES_DATAWIDTH*3));
    ch1_d   <= iserdes_dataout_w_d((1*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3-1) downto (1*SERDES_DATAWIDTH*3));
    sh1_ch1_c <= shift_1_data_w_c((1*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3-1) downto (1*SERDES_DATAWIDTH*3));
    sh2_ch1_c <= shift_2_data_w_c((1*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3-1) downto (1*SERDES_DATAWIDTH*3));
    sh1_ch1 <= shift_1_data_w((1*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3-1) downto (1*SERDES_DATAWIDTH*3));
    sh2_ch1 <= shift_2_data_w((1*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3-1) downto (1*SERDES_DATAWIDTH*3));
end generate;

ch0           <= iserdes_dataout_w((0*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3-1) downto (0*SERDES_DATAWIDTH*3));
ch0_r         <= iserdes_dataout_w_r((0*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3-1) downto (0*SERDES_DATAWIDTH*3));
ch0_d         <= iserdes_dataout_w_d((0*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3-1) downto (0*SERDES_DATAWIDTH*3));
sh1_ch0_c     <= shift_1_data_w_c((0*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3-1) downto (0*SERDES_DATAWIDTH*3));
sh2_ch0_c     <= shift_2_data_w_c((0*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3-1) downto (0*SERDES_DATAWIDTH*3));
sh1_ch0       <= shift_1_data_w((0*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3-1) downto (0*SERDES_DATAWIDTH*3));
sh2_ch0       <= shift_2_data_w((0*SERDES_DATAWIDTH*3)+(SERDES_DATAWIDTH*3-1) downto (0*SERDES_DATAWIDTH*3));

end rtl;