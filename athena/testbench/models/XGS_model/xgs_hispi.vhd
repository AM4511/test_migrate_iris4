-- *********************************************************************
-- Copyright 2019, ON Semiconductor Corporation.
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
-- *********************************************************************
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.xgs_model_pkg.all;

entity xgs_hispi is
  generic(G_PXL_PER_COLRAM: integer := 174);
  port(
       bit_clock_period    : in time;
       
       TRIGGER_READOUT     : in std_logic;
       
       hispi_if_enable     : in std_logic;
       output_msb_first    : in std_logic;
       hispi_enable_crc    : in std_logic;
       hispi_standby_state : in std_logic;
       hispi_mux_sel       : in std_logic_vector(1 downto 0);
       vert_left_bar_en    : in std_logic;
       hispi_pixel_depth   : in std_logic_vector(2 downto 0); --0x4 = 10bit and 0x5 = 12bit
       blanking_data       : in std_logic_vector(11 downto 0);
       
       dataline            : in  t_dataline(0 to 4*G_PXL_PER_COLRAM-1);
       emb_data            : in  std_logic;
       first_line          : in  std_logic; --indicates first line of a frame
       last_line           : in  std_logic; --indicates last line of a frame
       dataline_valid      : in  std_logic;
       dataline_nxt        : out std_logic;
       
       line_time           : in  std_logic_vector(15 downto 0);
       
       D_CLK_N             : out   std_logic;
       D_CLK_P             : out   std_logic;
       DATA_0_N            : out   std_logic;
       DATA_0_P            : out   std_logic;
       DATA_1_N            : out   std_logic;
       DATA_1_P            : out   std_logic;
       DATA_2_N            : out   std_logic;
       DATA_2_P            : out   std_logic;
       DATA_3_N            : out   std_logic;
       DATA_3_P            : out   std_logic
      );
end xgs_hispi;

architecture behaviour of xgs_hispi is

constant C_HISPI_SYNC_0     : std_logic_vector(11 downto 0) := (others => '1');
constant C_HISPI_SYNC_1     : std_logic_vector(11 downto 0) := (others => '0');
constant C_HISPI_SYNC_2     : std_logic_vector(11 downto 0) := (others => '0');
constant C_HISPI_SYNC_SOL   : std_logic_vector(11 downto 0) := "100000000000";
constant C_HISPI_SYNC_SOF   : std_logic_vector(11 downto 0) := "110000000000";
constant C_HISPI_SYNC_EOL   : std_logic_vector(11 downto 0) := "101000000000";
constant C_HISPI_SYNC_EOF   : std_logic_vector(11 downto 0) := "111000000000";
constant C_HISPI_FILLER_12B : std_logic_vector(11 downto 0) := "000000000001";
constant C_HISPI_FILLER_10B : std_logic_vector(11 downto 0) := "000000000100";

-- polynomial: x^16 + x^12 + x^5 + 1
-- data width: 12
-- convention: the first serial bit is D[11]
function nextCRC16_D12
  (Data: unsigned(11 downto 0);
   crc:  unsigned(15 downto 0))
  return unsigned is

  variable d:      unsigned(11 downto 0);
  variable c:      unsigned(15 downto 0);
  variable newcrc: unsigned(15 downto 0);

begin
  d := Data;
  c := crc;

  newcrc(0) := d(11) xor d(8) xor d(4) xor d(0) xor c(4) xor c(8) xor c(12) xor c(15);
  newcrc(1) := d(9) xor d(5) xor d(1) xor c(5) xor c(9) xor c(13);
  newcrc(2) := d(10) xor d(6) xor d(2) xor c(6) xor c(10) xor c(14);
  newcrc(3) := d(11) xor d(7) xor d(3) xor c(7) xor c(11) xor c(15);
  newcrc(4) := d(8) xor d(4) xor c(8) xor c(12);
  newcrc(5) := d(11) xor d(9) xor d(8) xor d(5) xor d(4) xor d(0) xor c(4) xor c(8) xor c(9) xor c(12) xor c(13) xor c(15);
  newcrc(6) := d(10) xor d(9) xor d(6) xor d(5) xor d(1) xor c(5) xor c(9) xor c(10) xor c(13) xor c(14);
  newcrc(7) := d(11) xor d(10) xor d(7) xor d(6) xor d(2) xor c(6) xor c(10) xor c(11) xor c(14) xor c(15);
  newcrc(8) := d(11) xor d(8) xor d(7) xor d(3) xor c(7) xor c(11) xor c(12) xor c(15);
  newcrc(9) := d(9) xor d(8) xor d(4) xor c(8) xor c(12) xor c(13);
  newcrc(10) := d(10) xor d(9) xor d(5) xor c(9) xor c(13) xor c(14);
  newcrc(11) := d(11) xor d(10) xor d(6) xor c(10) xor c(14) xor c(15);
  newcrc(12) := d(8) xor d(7) xor d(4) xor d(0) xor c(0) xor c(4) xor c(8) xor c(11) xor c(12);
  newcrc(13) := d(9) xor d(8) xor d(5) xor d(1) xor c(1) xor c(5) xor c(9) xor c(12) xor c(13);
  newcrc(14) := d(10) xor d(9) xor d(6) xor d(2) xor c(2) xor c(6) xor c(10) xor c(13) xor c(14);
  newcrc(15) := d(11) xor d(10) xor d(7) xor d(3) xor c(3) xor c(7) xor c(11) xor c(14) xor c(15);
  return newcrc;
end nextCRC16_D12;

-- polynomial: x^16 + x^12 + x^5 + 1
-- data width: 10
-- convention: the first serial bit is D[9]
function nextCRC16_D10
  (Data: unsigned(9 downto 0);
   crc:  unsigned(15 downto 0))
  return unsigned is

  variable d:      unsigned(9 downto 0);
  variable c:      unsigned(15 downto 0);
  variable newcrc: unsigned(15 downto 0);

begin
  d := Data;
  c := crc;

  newcrc(0) := d(8) xor d(4) xor d(0) xor c(6) xor c(10) xor c(14);
  newcrc(1) := d(9) xor d(5) xor d(1) xor c(7) xor c(11) xor c(15);
  newcrc(2) := d(6) xor d(2) xor c(8) xor c(12);
  newcrc(3) := d(7) xor d(3) xor c(9) xor c(13);
  newcrc(4) := d(8) xor d(4) xor c(10) xor c(14);
  newcrc(5) := d(9) xor d(8) xor d(5) xor d(4) xor d(0) xor c(6) xor c(10) xor c(11) xor c(14) xor c(15);
  newcrc(6) := d(9) xor d(6) xor d(5) xor d(1) xor c(7) xor c(11) xor c(12) xor c(15);
  newcrc(7) := d(7) xor d(6) xor d(2) xor c(8) xor c(12) xor c(13);
  newcrc(8) := d(8) xor d(7) xor d(3) xor c(9) xor c(13) xor c(14);
  newcrc(9) := d(9) xor d(8) xor d(4) xor c(10) xor c(14) xor c(15);
  newcrc(10) := d(9) xor d(5) xor c(0) xor c(11) xor c(15);
  newcrc(11) := d(6) xor c(1) xor c(12);
  newcrc(12) := d(8) xor d(7) xor d(4) xor d(0) xor c(2) xor c(6) xor c(10) xor c(13) xor c(14);
  newcrc(13) := d(9) xor d(8) xor d(5) xor d(1) xor c(3) xor c(7) xor c(11) xor c(14) xor c(15);
  newcrc(14) := d(9) xor d(6) xor d(2) xor c(4) xor c(8) xor c(12) xor c(15);
  newcrc(15) := d(7) xor d(3) xor c(5) xor c(9) xor c(13);
  return newcrc;
end nextCRC16_D10;

signal transmit_buffer0 : t_dataline(0 to (4*G_PXL_PER_COLRAM)  +10);
signal transmit_buffer1 : t_dataline(0 to (4*G_PXL_PER_COLRAM)  +10);
signal transmit_buffer2 : t_dataline(0 to (4*G_PXL_PER_COLRAM)  +10);
signal transmit_buffer3 : t_dataline(0 to (4*G_PXL_PER_COLRAM)  +10);

signal debug_transmit_lane0_pixel : std_logic_vector(11 downto 0);
signal debug_transmit_lane1_pixel : std_logic_vector(11 downto 0);
signal debug_transmit_lane2_pixel : std_logic_vector(11 downto 0);
signal debug_transmit_lane3_pixel : std_logic_vector(11 downto 0);

signal pixel_count : integer range 0 to 65535;
signal bit_count   : integer range 0 to 11;

signal clk_hispi   : std_logic := '0';

signal update_transmit_buffer : std_logic;

signal bit_clock_period_int : time := 1.2857 ns;
signal TRIGGER_READOUT_P1 : std_logic;

--type t_debug_array_data is array(0 to G_PXL_PER_COLRAM +4) of unsigned(11 downto 0);
--type t_debug_array_crc is array(0 to G_PXL_PER_COLRAM +4) of unsigned(15 downto 0);


begin

dataline_nxt         <= update_transmit_buffer;
bit_clock_period_int <= bit_clock_period;

HISPI_TX_BUFFER : process(update_transmit_buffer)
variable var_offset           : integer range 4 to 5;
variable var_bits             : integer range 9 to 11;
variable var_dataline         : t_dataline(0 to 4*G_PXL_PER_COLRAM-1);
variable var_lane0_crc        : unsigned(15 downto 0);
variable var_lane1_crc        : unsigned(15 downto 0);
variable var_lane2_crc        : unsigned(15 downto 0);
variable var_lane3_crc        : unsigned(15 downto 0);
variable var_crc_out          : unsigned(15 downto 0);
variable var_transmit_buffer0 : t_dataline(0 to (4*G_PXL_PER_COLRAM)  +10);
variable var_transmit_buffer1 : t_dataline(0 to (4*G_PXL_PER_COLRAM)  +10);
variable var_transmit_buffer2 : t_dataline(0 to (4*G_PXL_PER_COLRAM)  +10);
variable var_transmit_buffer3 : t_dataline(0 to (4*G_PXL_PER_COLRAM)  +10);

begin
  
  if update_transmit_buffer = '1' then
    var_transmit_buffer0 := (others => blanking_data);
    var_transmit_buffer1 := (others => blanking_data);
    var_transmit_buffer2 := (others => blanking_data);
    var_transmit_buffer3 := (others => blanking_data);
    
    if dataline_valid = '1' then

      --fill required buffers with start SYNC code
      var_transmit_buffer0(0) := C_HISPI_SYNC_0;
      var_transmit_buffer0(1) := C_HISPI_SYNC_1;
      var_transmit_buffer0(2) := C_HISPI_SYNC_2;
      if first_line = '1' then
         var_transmit_buffer0(3) := C_HISPI_SYNC_SOF;            
      else
         var_transmit_buffer0(3) := C_HISPI_SYNC_SOL;
      end if;
      if emb_data = '1' then
        var_transmit_buffer0(3)(7) := '1';  -- jmansill 0xC1 is not the SOF embeded sync!!!! its 0xC8 : bit 7 instead 4
      end if;
      if vert_left_bar_en = '1' then
          if hispi_pixel_depth = "100" then
            var_transmit_buffer3(4) := C_HISPI_FILLER_10B;
          else
            var_transmit_buffer3(4) := C_HISPI_FILLER_12B;
          end if;
      end if;
      
      if to_integer(unsigned(hispi_mux_sel)) < 3 then
        var_transmit_buffer1(0) := C_HISPI_SYNC_0;
        var_transmit_buffer1(1) := C_HISPI_SYNC_1;
        var_transmit_buffer1(2) := C_HISPI_SYNC_2;
        if first_line = '1' then
          var_transmit_buffer1(3) := C_HISPI_SYNC_SOF;            
        else
          var_transmit_buffer1(3) := C_HISPI_SYNC_SOL;
        end if;
        if emb_data = '1' then
          var_transmit_buffer0(3)(7) := '1';  -- jmansill 0xC1 is not the SOF embeded sync!!!! its 0xC8 : bit 7 instead 4
        end if;
        if vert_left_bar_en = '1' then
          if hispi_pixel_depth = "100" then
            var_transmit_buffer3(4) := C_HISPI_FILLER_10B;
          else
            var_transmit_buffer3(4) := C_HISPI_FILLER_12B;
          end if;
        end if;
      end if;
      
      if to_integer(unsigned(hispi_mux_sel)) < 2 then
        var_transmit_buffer2(0) := C_HISPI_SYNC_0;
        var_transmit_buffer2(1) := C_HISPI_SYNC_1;
        var_transmit_buffer2(2) := C_HISPI_SYNC_2;
        if first_line = '1' then
          var_transmit_buffer2(3) := C_HISPI_SYNC_SOF;            
        else
          var_transmit_buffer2(3) := C_HISPI_SYNC_SOL;
        end if;
        if emb_data = '1' then
          var_transmit_buffer0(3)(7) := '1';  --jmansill  0xC1 is not the SOF embeded sync!!!! its 0xC8 : bit 7 instead 4
        end if;
        if vert_left_bar_en = '1' then
          if hispi_pixel_depth = "100" then
            var_transmit_buffer3(4) := C_HISPI_FILLER_10B;
          else
            var_transmit_buffer3(4) := C_HISPI_FILLER_12B;
          end if;
        end if;
      end if;
        
      if to_integer(unsigned(hispi_mux_sel)) < 1 then
        var_transmit_buffer3(0) := C_HISPI_SYNC_0;
        var_transmit_buffer3(1) := C_HISPI_SYNC_1;
        var_transmit_buffer3(2) := C_HISPI_SYNC_2;
        if first_line = '1' then
          var_transmit_buffer3(3) := C_HISPI_SYNC_SOF;            
        else
          var_transmit_buffer3(3) := C_HISPI_SYNC_SOL;
        end if;
        if emb_data = '1' then
          var_transmit_buffer0(3)(7) := '1';  --jmansill  0xC1 is not the SOF embeded sync!!!! its 0xC8 : bit 7 instead 4
        end if;
        if vert_left_bar_en = '1' then
          if hispi_pixel_depth = "100" then
            var_transmit_buffer3(4) := C_HISPI_FILLER_10B;
          else
            var_transmit_buffer3(4) := C_HISPI_FILLER_12B;
          end if;
        end if;
      end if;
      
      --add filler byte when vert_left_bar_en is set
      var_offset := 4;
      if vert_left_bar_en = '1' then
        var_offset := 5;
      end if;
      
      --fill required buffers with pixel data
      if hispi_pixel_depth = "100" then
        var_bits := 9;
      elsif hispi_pixel_depth = "101" then
        var_bits := 11;
      else
        assert false 
          report "Programmed HiSPi pixel depth is not supported. Program hispi_pixel_depth field with value 0x4 (10bit) or 0x5 (12bit)";
      end if;
      if output_msb_first = '0' then
        for j in 0 to 4*G_PXL_PER_COLRAM-1 loop
          for i in 0 to var_bits loop
            var_dataline(j)(i) := dataline(j)(var_bits-i);
          end loop;
        end loop;
      else
        var_dataline := dataline;
      end if;

      for i in 0 to (G_PXL_PER_COLRAM/3)-1 loop
        case hispi_mux_sel is
          when "00" =>
            var_transmit_buffer0(var_offset+3*i)   := var_dataline(                   3*i);
            var_transmit_buffer0(var_offset+3*i+1) := var_dataline(                   3*i+1);
            var_transmit_buffer0(var_offset+3*i+2) := var_dataline(                   3*i+2);

            var_transmit_buffer1(var_offset+3*i)   := var_dataline(  G_PXL_PER_COLRAM+3*i);
            var_transmit_buffer1(var_offset+3*i+1) := var_dataline(  G_PXL_PER_COLRAM+3*i+1);
            var_transmit_buffer1(var_offset+3*i+2) := var_dataline(  G_PXL_PER_COLRAM+3*i+2);
            
            var_transmit_buffer2(var_offset+3*i)   := var_dataline(2*G_PXL_PER_COLRAM+3*i);
            var_transmit_buffer2(var_offset+3*i+1) := var_dataline(2*G_PXL_PER_COLRAM+3*i+1);
            var_transmit_buffer2(var_offset+3*i+2) := var_dataline(2*G_PXL_PER_COLRAM+3*i+2);
            
            var_transmit_buffer3(var_offset+3*i)   := var_dataline(3*G_PXL_PER_COLRAM+3*i);
            var_transmit_buffer3(var_offset+3*i+1) := var_dataline(3*G_PXL_PER_COLRAM+3*i+1);
            var_transmit_buffer3(var_offset+3*i+2) := var_dataline(3*G_PXL_PER_COLRAM+3*i+2);
            
          when "01" => 
            var_transmit_buffer0(var_offset+4*i)   := var_dataline(                   3*i);
            var_transmit_buffer0(var_offset+4*i+1) := var_dataline(3*G_PXL_PER_COLRAM+3*i);
            var_transmit_buffer0(var_offset+4*i+2) := var_dataline(2*G_PXL_PER_COLRAM+3*i+1);
            var_transmit_buffer0(var_offset+4*i+3) := var_dataline(  G_PXL_PER_COLRAM+3*i+2);
            
            var_transmit_buffer1(var_offset+4*i)   := var_dataline(  G_PXL_PER_COLRAM+3*i);
            var_transmit_buffer1(var_offset+4*i+1) := var_dataline(                   3*i+1);
            var_transmit_buffer1(var_offset+4*i+2) := var_dataline(3*G_PXL_PER_COLRAM+3*i+1);
            var_transmit_buffer1(var_offset+4*i+3) := var_dataline(2*G_PXL_PER_COLRAM+3*i+2);
            
            var_transmit_buffer2(var_offset+4*i)   := var_dataline(2*G_PXL_PER_COLRAM+3*i);
            var_transmit_buffer2(var_offset+4*i+1) := var_dataline(  G_PXL_PER_COLRAM+3*i+1);
            var_transmit_buffer2(var_offset+4*i+2) := var_dataline(                   3*i+2);
            var_transmit_buffer2(var_offset+4*i+3) := var_dataline(3*G_PXL_PER_COLRAM+3*i+2);

          when "10" => 
            var_transmit_buffer0(var_offset+6*i  ) := var_dataline(                   3*i);
            var_transmit_buffer0(var_offset+6*i+1) := var_dataline(  G_PXL_PER_COLRAM+3*i);
            var_transmit_buffer0(var_offset+6*i+2) := var_dataline(                   3*i+1);
            var_transmit_buffer0(var_offset+6*i+3) := var_dataline(  G_PXL_PER_COLRAM+3*i+1);
            var_transmit_buffer0(var_offset+6*i+4) := var_dataline(                   3*i+2);
            var_transmit_buffer0(var_offset+6*i+5) := var_dataline(  G_PXL_PER_COLRAM+3*i+2);

            var_transmit_buffer1(var_offset+6*i  ) := var_dataline(2*G_PXL_PER_COLRAM+3*i);
            var_transmit_buffer1(var_offset+6*i+1) := var_dataline(3*G_PXL_PER_COLRAM+3*i);
            var_transmit_buffer1(var_offset+6*i+2) := var_dataline(2*G_PXL_PER_COLRAM+3*i+1);
            var_transmit_buffer1(var_offset+6*i+3) := var_dataline(3*G_PXL_PER_COLRAM+3*i+1);
            var_transmit_buffer1(var_offset+6*i+4) := var_dataline(2*G_PXL_PER_COLRAM+3*i+2);
            var_transmit_buffer1(var_offset+6*i+5) := var_dataline(3*G_PXL_PER_COLRAM+3*i+2);
            
          when others => --4:1 GTX
            var_transmit_buffer0(var_offset+12*i   ) := var_dataline(                   3*i);
            var_transmit_buffer0(var_offset+12*i+ 1) := var_dataline(  G_PXL_PER_COLRAM+3*i);
            var_transmit_buffer0(var_offset+12*i+ 2) := var_dataline(2*G_PXL_PER_COLRAM+3*i);
            var_transmit_buffer0(var_offset+12*i+ 3) := var_dataline(3*G_PXL_PER_COLRAM+3*i);
            var_transmit_buffer0(var_offset+12*i+ 4) := var_dataline(                   3*i+1);
            var_transmit_buffer0(var_offset+12*i+ 5) := var_dataline(  G_PXL_PER_COLRAM+3*i+1);
            var_transmit_buffer0(var_offset+12*i+ 6) := var_dataline(2*G_PXL_PER_COLRAM+3*i+1);
            var_transmit_buffer0(var_offset+12*i+ 7) := var_dataline(3*G_PXL_PER_COLRAM+3*i+1);
            var_transmit_buffer0(var_offset+12*i+ 8) := var_dataline(                   3*i+2);
            var_transmit_buffer0(var_offset+12*i+ 9) := var_dataline(  G_PXL_PER_COLRAM+3*i+2);
            var_transmit_buffer0(var_offset+12*i+10) := var_dataline(2*G_PXL_PER_COLRAM+3*i+2);
            var_transmit_buffer0(var_offset+12*i+11) := var_dataline(3*G_PXL_PER_COLRAM+3*i+2);
            
        end case;
      end loop;
    
      --fill required buffers with end SYNC code and CRC
      case hispi_mux_sel is
        when "00" =>
          var_transmit_buffer0(G_PXL_PER_COLRAM+var_offset  ) := C_HISPI_SYNC_0;
          var_transmit_buffer0(G_PXL_PER_COLRAM+var_offset+1) := C_HISPI_SYNC_1;
          var_transmit_buffer0(G_PXL_PER_COLRAM+var_offset+2) := C_HISPI_SYNC_2;
          if last_line = '1' then
            var_transmit_buffer0(G_PXL_PER_COLRAM+var_offset+3) := C_HISPI_SYNC_EOF;            
          else
            var_transmit_buffer0(G_PXL_PER_COLRAM+var_offset+3) := C_HISPI_SYNC_EOL;
          end if;
          if hispi_enable_crc = '1' then
            var_lane0_crc := (others => '1');
            for i in 0 to G_PXL_PER_COLRAM+var_offset-1 loop
              if hispi_pixel_depth = "100" then --10-bit
                var_lane0_crc := nextCRC16_D10(unsigned(var_transmit_buffer0(i+4)( 9 downto 0)),var_lane0_crc);
              else
                var_lane0_crc := nextCRC16_D12(unsigned(var_transmit_buffer0(i+4)(11 downto 0)),var_lane0_crc);
              end if;
            end loop;
            for i in 0 to 15 loop
              var_crc_out(i) := var_lane0_crc(15-i);
            end loop;
            var_transmit_buffer0(G_PXL_PER_COLRAM+var_offset+4) := std_logic_vector("0001" & var_crc_out(15 downto 8));
            var_transmit_buffer0(G_PXL_PER_COLRAM+var_offset+5) := std_logic_vector("0001" & var_crc_out( 7 downto 0));
          end if;
          
          var_transmit_buffer1(G_PXL_PER_COLRAM+var_offset  ) := C_HISPI_SYNC_0;
          var_transmit_buffer1(G_PXL_PER_COLRAM+var_offset+1) := C_HISPI_SYNC_1;
          var_transmit_buffer1(G_PXL_PER_COLRAM+var_offset+2) := C_HISPI_SYNC_2;
          if last_line = '1' then
            var_transmit_buffer1(G_PXL_PER_COLRAM+var_offset+3) := C_HISPI_SYNC_EOF;            
          else
            var_transmit_buffer1(G_PXL_PER_COLRAM+var_offset+3) := C_HISPI_SYNC_EOL;
          end if;
          if hispi_enable_crc = '1' then
            var_lane1_crc := (others => '1');
            for i in 0 to G_PXL_PER_COLRAM+var_offset-1 loop
              if hispi_pixel_depth = "100" then --10-bit
                var_lane1_crc := nextCRC16_D10(unsigned(var_transmit_buffer1(i+4)( 9 downto 0)),var_lane1_crc);
              else
                var_lane1_crc := nextCRC16_D12(unsigned(var_transmit_buffer1(i+4)(11 downto 0)),var_lane1_crc);
              end if;
            end loop;
            for i in 0 to 15 loop
              var_crc_out(i) := var_lane1_crc(15-i);
            end loop;
            var_transmit_buffer1(G_PXL_PER_COLRAM+var_offset+4) := std_logic_vector("0001" & var_crc_out(15 downto 8));
            var_transmit_buffer1(G_PXL_PER_COLRAM+var_offset+5) := std_logic_vector("0001" & var_crc_out( 7 downto 0));
          end if;

          var_transmit_buffer2(G_PXL_PER_COLRAM+var_offset  ) := C_HISPI_SYNC_0;
          var_transmit_buffer2(G_PXL_PER_COLRAM+var_offset+1) := C_HISPI_SYNC_1;
          var_transmit_buffer2(G_PXL_PER_COLRAM+var_offset+2) := C_HISPI_SYNC_2;
          if last_line = '1' then
            var_transmit_buffer2(G_PXL_PER_COLRAM+var_offset+3) := C_HISPI_SYNC_EOF;            
          else
            var_transmit_buffer2(G_PXL_PER_COLRAM+var_offset+3) := C_HISPI_SYNC_EOL;
          end if;
          if hispi_enable_crc = '1' then
            var_lane2_crc := (others => '1');
            for i in 0 to G_PXL_PER_COLRAM+var_offset-1 loop
              if hispi_pixel_depth = "100" then --10-bit
                var_lane2_crc := nextCRC16_D10(unsigned(var_transmit_buffer2(i+4)( 9 downto 0)),var_lane2_crc);
              else
                var_lane2_crc := nextCRC16_D12(unsigned(var_transmit_buffer2(i+4)(11 downto 0)),var_lane2_crc);
              end if;
            end loop;
            for i in 0 to 15 loop
              var_crc_out(i) := var_lane2_crc(15-i);
            end loop;
            var_transmit_buffer2(G_PXL_PER_COLRAM+var_offset+4) := std_logic_vector("0001" & var_crc_out(15 downto 8));
            var_transmit_buffer2(G_PXL_PER_COLRAM+var_offset+5) := std_logic_vector("0001" & var_crc_out( 7 downto 0));
          end if;
          
          var_transmit_buffer3(G_PXL_PER_COLRAM+var_offset  ) := C_HISPI_SYNC_0;
          var_transmit_buffer3(G_PXL_PER_COLRAM+var_offset+1) := C_HISPI_SYNC_1;
          var_transmit_buffer3(G_PXL_PER_COLRAM+var_offset+2) := C_HISPI_SYNC_2;
          if last_line = '1' then
            var_transmit_buffer3(G_PXL_PER_COLRAM+var_offset+3) := C_HISPI_SYNC_EOF;            
          else
            var_transmit_buffer3(G_PXL_PER_COLRAM+var_offset+3) := C_HISPI_SYNC_EOL;
          end if;
          if hispi_enable_crc = '1' then
            var_lane3_crc := (others => '1');
            for i in 0 to G_PXL_PER_COLRAM+var_offset-1 loop
              if hispi_pixel_depth = "100" then --10-bit
                var_lane3_crc := nextCRC16_D10(unsigned(var_transmit_buffer3(i+4)( 9 downto 0)),var_lane3_crc);
              else
                var_lane3_crc := nextCRC16_D12(unsigned(var_transmit_buffer3(i+4)(11 downto 0)),var_lane3_crc);
              end if;
            end loop;
            for i in 0 to 15 loop
              var_crc_out(i) := var_lane3_crc(15-i);
            end loop;
            var_transmit_buffer3(G_PXL_PER_COLRAM+var_offset+4) := std_logic_vector("0001" & var_crc_out(15 downto 8));
            var_transmit_buffer3(G_PXL_PER_COLRAM+var_offset+5) := std_logic_vector("0001" & var_crc_out( 7 downto 0));
          end if;
 
        when "01" =>
          var_transmit_buffer0((4*G_PXL_PER_COLRAM/3)+var_offset) := C_HISPI_SYNC_0;
          var_transmit_buffer0((4*G_PXL_PER_COLRAM/3)+var_offset+1) := C_HISPI_SYNC_1;
          var_transmit_buffer0((4*G_PXL_PER_COLRAM/3)+var_offset+2) := C_HISPI_SYNC_2;
          if last_line = '1' then
            var_transmit_buffer0((4*G_PXL_PER_COLRAM/3)+var_offset+3) := C_HISPI_SYNC_EOF;            
          else
            var_transmit_buffer0((4*G_PXL_PER_COLRAM/3)+var_offset+3) := C_HISPI_SYNC_EOL;
          end if;
          if hispi_enable_crc = '1' then
            var_lane0_crc := (others => '1');
            for i in 0 to (4*G_PXL_PER_COLRAM/3)+var_offset-1 loop
              if hispi_pixel_depth = "100" then --10-bit
                var_lane0_crc := nextCRC16_D10(unsigned(var_transmit_buffer0(i+4)( 9 downto 0)),var_lane0_crc);
              else
                var_lane0_crc := nextCRC16_D12(unsigned(var_transmit_buffer0(i+4)(11 downto 0)),var_lane0_crc);
              end if;
            end loop;
            for i in 0 to 15 loop
              var_crc_out(i) := var_lane0_crc(15-i);
            end loop;
            var_transmit_buffer0((4*G_PXL_PER_COLRAM/3)+var_offset+4) := std_logic_vector("0001" & var_crc_out(15 downto 8));
            var_transmit_buffer0((4*G_PXL_PER_COLRAM/3)+var_offset+5) := std_logic_vector("0001" & var_crc_out( 7 downto 0));
          end if;
          
          var_transmit_buffer1((4*G_PXL_PER_COLRAM/3)+var_offset) := C_HISPI_SYNC_0;
          var_transmit_buffer1((4*G_PXL_PER_COLRAM/3)+var_offset+1) := C_HISPI_SYNC_1;
          var_transmit_buffer1((4*G_PXL_PER_COLRAM/3)+var_offset+2) := C_HISPI_SYNC_2;
          if last_line = '1' then
            var_transmit_buffer1((4*G_PXL_PER_COLRAM/3)+var_offset+3) := C_HISPI_SYNC_EOF;            
          else
            var_transmit_buffer1((4*G_PXL_PER_COLRAM/3)+var_offset+3) := C_HISPI_SYNC_EOL;
          end if;
          if hispi_enable_crc = '1' then
            var_lane1_crc := (others => '1');
            for i in 0 to (4*G_PXL_PER_COLRAM/3)+var_offset-1 loop
              if hispi_pixel_depth = "100" then --10-bit
                var_lane1_crc := nextCRC16_D10(unsigned(var_transmit_buffer1(i+4)( 9 downto 0)),var_lane1_crc);
              else
                var_lane1_crc := nextCRC16_D12(unsigned(var_transmit_buffer1(i+4)(11 downto 0)),var_lane1_crc);
              end if;
            end loop;
            for i in 0 to 15 loop
              var_crc_out(i) := var_lane1_crc(15-i);
            end loop;
            var_transmit_buffer1((4*G_PXL_PER_COLRAM/3)+var_offset+4) := std_logic_vector("0001" & var_crc_out(15 downto 8));
            var_transmit_buffer1((4*G_PXL_PER_COLRAM/3)+var_offset+5) := std_logic_vector("0001" & var_crc_out( 7 downto 0));
          end if;

          var_transmit_buffer2((4*G_PXL_PER_COLRAM/3)+var_offset  ) := C_HISPI_SYNC_0;
          var_transmit_buffer2((4*G_PXL_PER_COLRAM/3)+var_offset+1) := C_HISPI_SYNC_1;
          var_transmit_buffer2((4*G_PXL_PER_COLRAM/3)+var_offset+2) := C_HISPI_SYNC_2;
          if last_line = '1' then
            var_transmit_buffer2((4*G_PXL_PER_COLRAM/3)+var_offset+3) := C_HISPI_SYNC_EOF;            
          else
            var_transmit_buffer2((4*G_PXL_PER_COLRAM/3)+var_offset+3) := C_HISPI_SYNC_EOL;
          end if;
          if hispi_enable_crc = '1' then
            var_lane2_crc := (others => '1');
            for i in 0 to (4*G_PXL_PER_COLRAM/3)+var_offset-1 loop
              if hispi_pixel_depth = "100" then --10-bit
                var_lane2_crc := nextCRC16_D10(unsigned(var_transmit_buffer2(i+4)( 9 downto 0)),var_lane2_crc);
              else
                var_lane2_crc := nextCRC16_D12(unsigned(var_transmit_buffer2(i+4)(11 downto 0)),var_lane2_crc);
              end if;
            end loop;
            for i in 0 to 15 loop
              var_crc_out(i) := var_lane2_crc(15-i);
            end loop;
            var_transmit_buffer2((4*G_PXL_PER_COLRAM/3)+var_offset+4) := std_logic_vector("0001" & var_crc_out(15 downto 8));
            var_transmit_buffer2((4*G_PXL_PER_COLRAM/3)+var_offset+5) := std_logic_vector("0001" & var_crc_out( 7 downto 0));
          end if;
          
        when "10" =>
          var_transmit_buffer0((2*G_PXL_PER_COLRAM)+var_offset  ) := C_HISPI_SYNC_0;
          var_transmit_buffer0((2*G_PXL_PER_COLRAM)+var_offset+1) := C_HISPI_SYNC_1;
          var_transmit_buffer0((2*G_PXL_PER_COLRAM)+var_offset+2) := C_HISPI_SYNC_2;
          if last_line = '1' then
            var_transmit_buffer0((2*G_PXL_PER_COLRAM)+var_offset+3) := C_HISPI_SYNC_EOF;            
          else
            var_transmit_buffer0((2*G_PXL_PER_COLRAM)+var_offset+3) := C_HISPI_SYNC_EOL;
          end if;
          if hispi_enable_crc = '1' then
            var_lane0_crc := (others => '1');
            for i in 0 to (2*G_PXL_PER_COLRAM)+var_offset-1 loop
              if hispi_pixel_depth = "100" then --10-bit
                var_lane0_crc := nextCRC16_D10(unsigned(var_transmit_buffer0(i+4)( 9 downto 0)),var_lane0_crc);
              else
                var_lane0_crc := nextCRC16_D12(unsigned(var_transmit_buffer0(i+4)(11 downto 0)),var_lane0_crc);
              end if;
            end loop;
            for i in 0 to 15 loop
              var_crc_out(i) := var_lane0_crc(15-i);
            end loop;
            var_transmit_buffer0((2*G_PXL_PER_COLRAM)+var_offset+4) := std_logic_vector("0001" & var_crc_out(15 downto 8));
            var_transmit_buffer0((2*G_PXL_PER_COLRAM)+var_offset+5) := std_logic_vector("0001" & var_crc_out( 7 downto 0));
          end if;
          
          var_transmit_buffer1((2*G_PXL_PER_COLRAM)+var_offset  ) := C_HISPI_SYNC_0;
          var_transmit_buffer1((2*G_PXL_PER_COLRAM)+var_offset+1) := C_HISPI_SYNC_1;
          var_transmit_buffer1((2*G_PXL_PER_COLRAM)+var_offset+2) := C_HISPI_SYNC_2;
          if last_line = '1' then
            var_transmit_buffer1((2*G_PXL_PER_COLRAM)+var_offset+3) := C_HISPI_SYNC_EOF;            
          else
            var_transmit_buffer1((2*G_PXL_PER_COLRAM)+var_offset+3) := C_HISPI_SYNC_EOL;
          end if;
          if hispi_enable_crc = '1' then
            var_lane1_crc := (others => '1');
            for i in 0 to (2*G_PXL_PER_COLRAM)+var_offset-1 loop
              if hispi_pixel_depth = "100" then --10-bit
                var_lane1_crc := nextCRC16_D10(unsigned(var_transmit_buffer1(i+4)( 9 downto 0)),var_lane1_crc);
              else
                var_lane1_crc := nextCRC16_D12(unsigned(var_transmit_buffer1(i+4)(11 downto 0)),var_lane1_crc);
              end if;
            end loop;
            for i in 0 to 15 loop
              var_crc_out(i) := var_lane1_crc(15-i);
            end loop;
            var_transmit_buffer1((2*G_PXL_PER_COLRAM)+var_offset+4) := std_logic_vector("0001" & var_crc_out(15 downto 8));
            var_transmit_buffer1((2*G_PXL_PER_COLRAM)+var_offset+5) := std_logic_vector("0001" & var_crc_out( 7 downto 0));
          end if;
          
        when others =>
          var_transmit_buffer0((4*G_PXL_PER_COLRAM)+var_offset) := C_HISPI_SYNC_0;
          var_transmit_buffer0((4*G_PXL_PER_COLRAM)+var_offset+1) := C_HISPI_SYNC_1;
          var_transmit_buffer0((4*G_PXL_PER_COLRAM)+var_offset+2) := C_HISPI_SYNC_2;
          if last_line = '1' then
            var_transmit_buffer0((4*G_PXL_PER_COLRAM)+var_offset+3) := C_HISPI_SYNC_EOF;            
          else
            var_transmit_buffer0((4*G_PXL_PER_COLRAM)+var_offset+3) := C_HISPI_SYNC_EOL;
          end if;
          if hispi_enable_crc = '1' then
            var_lane0_crc := (others => '1');
            for i in 0 to (4*G_PXL_PER_COLRAM)+var_offset-1 loop
              if hispi_pixel_depth = "100" then --10-bit
                var_lane0_crc := nextCRC16_D10(unsigned(var_transmit_buffer0(i+4)( 9 downto 0)),var_lane0_crc);
              else
                var_lane0_crc := nextCRC16_D12(unsigned(var_transmit_buffer0(i+4)(11 downto 0)),var_lane0_crc);
              end if;
            end loop;
            for i in 0 to 15 loop
              var_crc_out(i) := var_lane0_crc(15-i);
            end loop;
            var_transmit_buffer0((4*G_PXL_PER_COLRAM)+var_offset+4) := std_logic_vector("0001" & var_crc_out(15 downto 8));
            var_transmit_buffer0((4*G_PXL_PER_COLRAM)+var_offset+5) := std_logic_vector("0001" & var_crc_out( 7 downto 0));
          end if;
      end case;
    end if;
    
    transmit_buffer0 <= var_transmit_buffer0;
    transmit_buffer1 <= var_transmit_buffer1;
    transmit_buffer2 <= var_transmit_buffer2;
    transmit_buffer3 <= var_transmit_buffer3;

  end if;    
end process HISPI_TX_BUFFER;

clk_hispi <= not(clk_hispi) after bit_clock_period when hispi_if_enable = '1' else '0';

MAIN : process(clk_hispi, hispi_if_enable, hispi_pixel_depth)
begin
  if hispi_if_enable = '0' then
    update_transmit_buffer <= '0';
    bit_count              <= 0;
    pixel_count            <= 65535;
  
  elsif clk_hispi'event then
    update_transmit_buffer <= '0';
    if bit_count =  0 then
      if hispi_pixel_depth = "100" then -- 10 bit mode
        bit_count   <= 9;
      elsif hispi_pixel_depth = "101" then -- 12 bit mode
        bit_count   <= 11;
      else
        assert false 
          report "Programmed HiSPi pixel depth is not supported. Program hispi_pixel_depth field with value 0x4 (10bit) or 0x5 (12bit)";
      end if;
      if pixel_count >= to_integer(unsigned(line_time))-1 then
        update_transmit_buffer <= '1';
        pixel_count <= 0;
      else
        pixel_count <= pixel_count+1;
      end if;
    else
      bit_count <= bit_count-1;
    end if;
  end if;  

end process MAIN;

TRANSMIT_CLK : process(hispi_if_enable, hispi_standby_state,clk_hispi)
begin
  if hispi_if_enable = '0' then
    if hispi_standby_state = '1' then --differential zero
       D_CLK_N             <= '1';
       D_CLK_P             <= '0';
    else                              --tristate
       D_CLK_N             <= 'Z';
       D_CLK_P             <= 'Z';
    end if;
  else
    D_CLK_N  <= not(clk_hispi) after bit_clock_period_int/2;
    D_CLK_P  <= clk_hispi      after bit_clock_period_int/2;
  end if;
end process TRANSMIT_CLK;

TRANSMIT_DATA0 : process(hispi_if_enable, 
                         hispi_standby_state,
                         pixel_count,
                         bit_count,
                         blanking_data,
                         transmit_buffer0)
begin
  if hispi_if_enable = '0' then
    if hispi_standby_state = '1' then --differential zero
       DATA_0_N            <= '1';
       DATA_0_P            <= '0';
    else                              --tristate
       DATA_0_N            <= 'Z';
       DATA_0_P            <= 'Z';
    end if;
  elsif (pixel_count > (4*G_PXL_PER_COLRAM)+10) then
    DATA_0_N <= not(blanking_data(bit_count));
    DATA_0_P <= blanking_data(bit_count);
  else
    DATA_0_N <= not(transmit_buffer0(pixel_count)(bit_count));
    DATA_0_P <= transmit_buffer0(pixel_count)(bit_count);
    for i in 0 to 11 loop
      debug_transmit_lane0_pixel(i) <= transmit_buffer0(pixel_count)(11-i);
    end loop;
  end if;
end process TRANSMIT_DATA0;
 
TRANSMIT_DATA1 : process(hispi_if_enable, 
                         hispi_standby_state, 
                         hispi_mux_sel,
                         pixel_count,
                         bit_count,
                         blanking_data,
                         transmit_buffer1)
begin
  if hispi_if_enable = '0' or hispi_mux_sel = "11" then
    if hispi_standby_state = '1' then --differential zero
       DATA_1_N            <= '1';
       DATA_1_P            <= '0';
    else                              --tristate
       DATA_1_N            <= 'Z';
       DATA_1_P            <= 'Z';
    end if;
  elsif (pixel_count > (2*G_PXL_PER_COLRAM)+10) then
    DATA_1_N <= not(blanking_data(bit_count));
    DATA_1_P <= blanking_data(bit_count);
  else
    DATA_1_N <= not(transmit_buffer1(pixel_count)(bit_count));
    DATA_1_P <= transmit_buffer1(pixel_count)(bit_count);
    for i in 0 to 11 loop
      debug_transmit_lane1_pixel(i) <= transmit_buffer1(pixel_count)(11-i);
    end loop;
  end if;
end process TRANSMIT_DATA1;
 
TRANSMIT_DATA2 : process(hispi_if_enable, 
                         hispi_standby_state,
                         hispi_mux_sel,
                         pixel_count,
                         bit_count,
                         blanking_data,
                         transmit_buffer2)
begin
  if hispi_if_enable = '0' or to_integer(unsigned(hispi_mux_sel)) >= 2 then
    if hispi_standby_state = '1' then --differential zero
       DATA_2_N            <= '1';
       DATA_2_P            <= '0';
    else                              --tristate
       DATA_2_N            <= 'Z';
       DATA_2_P            <= 'Z';
    end if;
  elsif (pixel_count > (4*G_PXL_PER_COLRAM/3)+10) then
    DATA_2_N <= not(blanking_data(bit_count));
    DATA_2_P <= blanking_data(bit_count);
  else
    DATA_2_N <= not(transmit_buffer2(pixel_count)(bit_count));
    DATA_2_P <= transmit_buffer2(pixel_count)(bit_count);
    for i in 0 to 11 loop
      debug_transmit_lane2_pixel(i) <= transmit_buffer2(pixel_count)(11-i);
    end loop;
  end if;
end process TRANSMIT_DATA2;
 
TRANSMIT_DATA3 : process(hispi_if_enable, 
                         hispi_standby_state,
                         hispi_mux_sel,
                         pixel_count,
                         bit_count,
                         blanking_data,
                         transmit_buffer3)
begin
  if hispi_if_enable = '0' or to_integer(unsigned(hispi_mux_sel)) >= 1 then
    if hispi_standby_state = '1' then --differential zero
       DATA_3_N            <= '1';
       DATA_3_P            <= '0';
    else                              --tristate
       DATA_3_N            <= 'Z';
       DATA_3_P            <= 'Z';
    end if;
  elsif (pixel_count > G_PXL_PER_COLRAM+10) then
    DATA_3_N <= not(blanking_data(bit_count));
    DATA_3_P <= blanking_data(bit_count);
  else
    DATA_3_N <= not(transmit_buffer3(pixel_count)(bit_count));
    DATA_3_P <= transmit_buffer3(pixel_count)(bit_count);
    for i in 0 to 11 loop
      debug_transmit_lane3_pixel(i) <= transmit_buffer3(pixel_count)(11-i);
    end loop;
  end if;
end process TRANSMIT_DATA3;
 

end behaviour;
