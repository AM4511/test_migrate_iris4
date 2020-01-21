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


-------------
-- LIBRARY --
-------------
--common:
---------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

-- CRC Tool by Easics
library work;
use work.all;
use work.PCK_CRC16_D10.all;
use work.PCK_CRC16_D12.all;

-----------------------
-- ENTITY DEFINITION --
-----------------------
entity crc_calc is
  generic (
       gMax_Datawidth     : integer := 12;
       POLYNOMIAL         : std_logic_vector := "10001000000100001"
  );
  port ( -- System
       CLOCK            : in    std_logic;
       RESET            : in    std_logic;
       
       MSB_FIRST        : in    std_logic;
       -- Data input
       EN_DECODER       : in    std_logic;
       INIT             : in    std_logic;
       DATAWIDTH        : in    integer;
       DATA_IN_VALID    : in    std_logic;
       FRAME_VALID      : in    std_logic;
       CRCLANE_VALID_IN : in    std_logic;
       
       DATA_IN          : in    std_logic_vector(gMax_Datawidth-1 downto 0);
       CRC_OUT          : out   std_logic_vector(15 downto 0) := (others => '0');
       SENSOR_CRC       : out   std_logic_vector(15 downto 0) := (others => '0');
       
       CRC_FRAME_ENABLE     : in    std_logic;
       FRAME_CRC_CHECKSUM   : out   std_logic_vector(15 downto 0) := (others => '0')
       );
end;

---------------------------
-- BEHAVIOUR DESCRIPTION --
---------------------------
architecture rtl of crc_calc is

----------------------------
-- COMPONENTS DEFINITIONS --
----------------------------
-- Xilinx components
-- none

-- user components
-- none
component mipi_hispi_crc_16 
  port (
    clk                 : in   std_logic;
    reset_n             : in   std_logic;
    hispi_streaming_en  : in   std_logic;

    frame_valid         : in   std_logic;
    data_to_crc_valid   : in   std_logic;

    init_crc            : in   std_logic;

    data_to_crc         : in   std_logic_vector(15 downto 0);  -- Input to crc 
    pixel_depth_out     : in   std_logic_vector(2 downto 0);        
                                            -- Width of pixels to be transmitted across HiSpi link
                                            -- 'b011 = 8 bits 
                                            -- 'b100 = 10 bits 
                                            -- 'b101 = 12 bits
                                            -- 'b110 = 14 bits
                                            -- 'b111 = 16 bits

    hispi_checksum      : out  std_logic_vector(15 downto 0); -- Generated checksum

    test_start_checksum : in   std_logic;   -- When asserted (= 1) a 16-bit checksum will be 
                                            -- calculated over the next complete frame
    test_checksum       : out  std_logic_vector(15 downto 0);          
                                            -- If 'test_checksum_valid' is asserted then 
                                            -- 'test_checksum' is a valid checksum calculated 
                                            -- over a complete frame
    test_checksum_valid : out  std_logic    -- If asserted (= 1) then 'test_checksum' is
                                            -- outputing a valid checksum 
    );
end component;
-------------------------------
-- TYPE & SIGNAL DEFINITIONS --
-------------------------------
constant zeroes           : std_logic_vector(gMax_Datawidth-1 downto 0) := (others => '0');

signal data_swap          : std_logic_vector(gMax_Datawidth-1 downto 0) := (others => '0');
signal data_crc           : std_logic_vector(15 downto 0) := (others => '0');
signal data_in_valid_d    : std_logic := '0';
signal data_in_valid_d1   : std_logic := '0';
signal reset_n            : std_logic := '0';
signal pixel_depth        : std_logic_vector(2 downto 0) := (others => '0');
signal frame_crc_valid    : std_logic := '0';
signal test_checksum      : std_logic_vector(15 downto 0) := (others => '0');
signal sensor_crc_i       : std_logic_vector(15 downto 0) := (others => '0');

--------------------
-- MAIN BEHAVIOUR --
--------------------
begin

reset_n    <= not RESET;
SENSOR_CRC <= sensor_crc_i;

pr_pixeldepth: process(CLOCK)
begin
    if (CLOCK'event and CLOCK = '1') then
        if (DATAWIDTH = 10 ) then
            pixel_depth <= "100";
        elsif (DATAWIDTH = 12) then
            pixel_depth <= "101";
        else
            pixel_depth <= "101";
        end if;
    end if;    
end process;

pr_Bitswap: process(CLOCK)
begin
    if (CLOCK'event and CLOCK = '1') then
    
        data_in_valid_d     <= DATA_IN_VALID;
        data_in_valid_d1    <= data_in_valid_d;
    
        if ( DATAWIDTH = 10) then
            for i in (gMax_Datawidth - 10) to (gMax_Datawidth-1) loop
                data_swap(i) <= DATA_IN((gMax_Datawidth-1)-i+(gMax_Datawidth - 10));
            end loop;
            data_crc <= "000000" & data_swap(11 downto 2);
        else
             for i in (gMax_Datawidth - 12) to (gMax_Datawidth-1) loop
                data_swap(i) <= DATA_IN((gMax_Datawidth-1)-i+(gMax_Datawidth - 12));
            end loop;
            data_crc <= "0000" & data_swap;
        end if;
        
        if (frame_crc_valid = '1') then
            FRAME_CRC_CHECKSUM <= test_checksum;
        end if;
        
    end if;
    
end process;


pr_sensor: process(CLOCK)
begin
    if (CLOCK'event and CLOCK = '1') then
    
        -- extract sensor crc from 2 words
        if (CRCLANE_VALID_IN = '1') then
            if (MSB_FIRST = '1') then
                sensor_crc_i( 7 downto 0) <= DATA_IN(7+(gMax_Datawidth-DATAWIDTH) downto 0+(gMax_Datawidth-DATAWIDTH));
                sensor_crc_i(15 downto 8) <= sensor_crc_i(7 downto 0);
            else
                for i in 0 to 7 loop
                    sensor_crc_i(i) <= DATA_IN((gMax_Datawidth-1)-i);
                end loop;
                sensor_crc_i(15 downto 8) <= sensor_crc_i(7 downto 0);
            end if;
        end if;
            
    end if;
end process;


crc_hispi: mipi_hispi_crc_16 
  port map (
    clk                 => CLOCK,
    reset_n             => EN_DECODER,
    hispi_streaming_en  => EN_DECODER,

    frame_valid         => FRAME_VALID,
    data_to_crc_valid   => data_in_valid_d1,

    init_crc            => INIT,

    data_to_crc         => data_crc,
    pixel_depth_out     => pixel_depth,

    hispi_checksum      => CRC_OUT,

    test_start_checksum => CRC_FRAME_ENABLE,
                            
    test_checksum       => test_checksum,

    test_checksum_valid => frame_crc_valid

);
    
end rtl;
