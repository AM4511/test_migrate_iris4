-- *********************************************************************
-- Copyright 2014, ON Semiconductor Corporation.
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


library ieee;
use ieee.std_logic_1164.all;
--synopsys:
-----------
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
--user:
------------
library work;
use work.all;

entity generator is
  generic (
        DATAWIDTH   : integer := 16
        );
  port (
        CLOCK               : in    std_logic;

        linelength          : in    std_logic_vector(15 downto 0);
        nroflines           : in    std_logic_vector(15 downto 0);
        xinc                : in    std_logic_vector(15 downto 0);
        yinc                : in    std_logic_vector(15 downto 0);
        finc                : in    std_logic_vector(15 downto 0);

        enable              : in    std_logic;
        busy                : out   std_logic := '0';

        streamer_full           : in    std_logic;
        streamer_almostfull     : in    std_logic;
        streamer_empty          : in    std_logic;
        streamer_almostempty    : in    std_logic;

        PAR_DATA            : out   std_logic_vector(DATAWIDTH-1 downto 0) := (others => '0');
        PAR_DATA_VALID      : out   std_logic;
        PAR_DATA_SOF        : out   std_logic;
        PAR_DATA_EOL        : out   std_logic
       );
end generator;

architecture rtl of generator is

type    RdStateTP is ( Idle,
                       StartSeq, XLoop, YLoop
                      );
signal  RdState  : RdStateTP := Idle;

constant NrofPixels : integer := (DATAWIDTH/16);

--type   XDataCntrTp is array (0 to (NrofPixels-1)) of std_logic_vector(15 downto 0);

signal  XDataCntr           : std_logic_vector(15 downto 0) := (others => '0');
signal  YDataCntr           : std_logic_vector(15 downto 0) := (others => '0');
signal  FDataCntr           : std_logic_vector(15 downto 0) := (others => '0');

--signal  XDataCntr_r           : std_logic_vector(15 downto 0) := (others => '0');
signal  YDataCntr_r           : std_logic_vector(15 downto 0) := (others => '0');
signal  FDataCntr_r           : std_logic_vector(15 downto 0) := (others => '0');

signal  XRdCntr             : std_logic_vector(15 downto 0) := (others => '0');
signal  YRdCntr             : std_logic_vector(15 downto 0) := (others => '0');

signal  XCnt                : std_logic_vector(15 downto 0) := (others => '0');
signal  YCnt                : std_logic_vector(15 downto 0) := (others => '0');

signal  xinc_sync           : std_logic_vector(15 downto 0) := (others => '0');
signal  yinc_sync           : std_logic_vector(15 downto 0) := (others => '0');
signal  linelength_sync     : std_logic_vector(15 downto 0) := (others => '0');

signal  valid               : std_logic := '0';
signal  sof                 : std_logic := '0';
signal  sof2                : std_logic := '0';

function clog2 (
  integervalue : in integer)
  return integer is
  variable returnvalue : integer := 0;
begin
  if (integervalue <= 1) then
      returnvalue := 0;
  elsif (integervalue <= 2) then
      returnvalue := 1;
  elsif (integervalue <= 4) then
      returnvalue := 2;
  elsif (integervalue <= 8) then
      returnvalue := 3;
  elsif (integervalue <= 16) then
      returnvalue := 4;
  elsif (integervalue <= 32) then
      returnvalue := 5;
  elsif (integervalue <= 64) then
      returnvalue := 6;
  elsif (integervalue <= 128) then
      returnvalue := 7;
  elsif (integervalue <= 256) then
      returnvalue := 8;
  elsif (integervalue <= 512) then
      returnvalue := 9;
  elsif (integervalue <= 1024) then
      returnvalue := 10;
  elsif (integervalue <= 2048) then
      returnvalue := 11;
  elsif (integervalue <= 4096) then
      returnvalue := 12;
  elsif (integervalue <= 8192) then
      returnvalue := 13;
  elsif (integervalue <= 16384) then
      returnvalue := 14;
  elsif (integervalue <= 32768) then
      returnvalue := 15;
  else
      returnvalue := 16;
  end if;

  return returnvalue;
end;

constant fpwidth : integer := clog2(NrofPixels);
constant total_width : integer := (16 + fpwidth);
constant zeros : std_logic_vector(15 downto 0) := (others => '0');

signal xcntr_comp : std_logic_vector((NrofPixels*total_width) - 1 downto 0) := (others => '0');

begin

  ExtraFF: process(CLOCK)

  variable par_data_fixed_p : std_logic_vector((NrofPixels*total_width) - 1 downto 0) := (others => '0');
  --variable xcntr_comp : std_logic_vector((NrofPixels*total_width) - 1 downto 0) := (others => '0');
  begin
    if (CLOCK'event and CLOCK='1') then

        PAR_DATA_VALID <= valid;
        PAR_DATA_SOF <= sof2;

        --XDataCntr_r <= XDataCntr;
        YDataCntr_r <= YDataCntr;
        FDataCntr_r <= FDataCntr;


        gen_wr_data: for i in 0 to (NrofPixels-1) loop
            xcntr_comp(i*total_width+total_width-1 downto i*total_width) <=  (XDataCntr(15 downto 0) & zeros(fpwidth-1 downto 0))  + (std_logic_vector(shift_left(to_unsigned(i, total_width),clog2(to_integer(unsigned(xinc_sync))))));
            par_data_fixed_p(i*total_width+total_width-1 downto i*total_width) := xcntr_comp(i*total_width+total_width-1 downto i*total_width) + (YDataCntr_r(15 downto 0) & zeros(fpwidth-1 downto 0)) + (FDataCntr_r(15 downto 0) & zeros(fpwidth-1 downto 0));

            if (xcntr_comp(i*total_width+total_width-1 downto i*total_width+total_width-16) /= YDataCntr_r) then
                PAR_DATA((i*16)+15 downto (i*16)) <= par_data_fixed_p(i*total_width+total_width-1 downto i*total_width+total_width-16);
            else
                PAR_DATA((i*16)+15 downto (i*16)) <= not par_data_fixed_p(i*total_width+total_width-1 downto i*total_width+total_width-16);
            end if;
        end loop;
    end if;
  end process;

  TestSeq: process(CLOCK)
  begin
    if (CLOCK'event and CLOCK='1') then

    sof <= '0';
    sof2 <= sof;
    PAR_DATA_EOL <= '0';

      --main FSM for pixel readout
      case RdState is

        when Idle =>
          XDataCntr <= (others => '0');
          YDataCntr <= (others => '0');


          XCnt      <= (others => '0');
          YCnt      <= (others => '0');

          if (enable = '1') then
            busy        <= '1';
            linelength_sync <= LineLength;
 
            YRdCntr   <= '0' & (NrOfLines(14 downto 0) - "010");
            XRdCntr   <= '0' & (LineLength(14 downto 0) - "001");

            RdState     <= StartSeq;
          else
            FDataCntr <= (others => '0');
          end if;

        when StartSeq =>
          sof     <= '1';
          FDataCntr <= FDataCntr + finc;
          xinc_sync <= xinc;
          yinc_sync <= yinc;
          RdState <= Xloop;

        when XLoop =>
          if (XRdCntr(XRdCntr'high) = '0') then
            valid   <= '1';
            XDataCntr <= XDataCntr + xinc_sync;
            XRdCntr   <= XRdCntr - 1;
            XCnt      <= XCnt + 1;
          else
            PAR_DATA_EOL <= '1';
            valid   <= '0';
            XDataCntr <= (others => '0');
            XCnt      <= (others => '0');
            RdState   <= YLoop;
          end if;

        when YLoop =>
          if (streamer_empty = '1') then --make sure each line is fully flushed from streamer before continuing with next one --TEST
            if (YRdCntr(YRdCntr'high) = '0') then
              XRdCntr   <= '0' & (linelength_sync(14 downto 0) - "001");
              XCnt      <= (others => '0');
              YDataCntr <= YDataCntr + yinc_sync;
              YRdCntr   <= YRdCntr - 1;
              RdState   <= XLoop;
              YCnt      <= YCnt + 1;
            else
              busy    <= '0';
              RdState <= Idle;
            end if;
          end if;

        when others =>
          RdState <= Idle;

      end case; --RdState

    end if; --RESETb, CLOCK

  end process TestSeq;

end rtl;

