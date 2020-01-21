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
-- *********************************************************************
-- File           : $URL: http://bemc2idms.onsemi.com/repos/ff_te/VHDL/LIB/modules/Iserdes/branches/iserdesultrascale/packs/serdes_pack.vhd $
-- Author         : $Author: bert.dewil $
-- Department     : CISP
-- Date           : $Date: 2016-09-30 09:51:41 +0200 (Fri, 30 Sep 2016) $
-- Revision       : $Revision: 5575 $
-- *********************************************************************
-- Description
--
-- *********************************************************************

library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;
use ieee.numeric_bit.all;
--user:
-------
library work;
use work.all;

package serdes_pack is
type initarraytp is array (0 to 63) of bit_vector(255 downto 0);
type convertedarraytp is array (0 to 63) of std_logic_vector(255 downto 0);

function generateinitarray6bit return initarraytp;
function generateinitarray8bit return initarraytp;

end serdes_pack;


package body serdes_pack is

    function generateinitarray6bit return initarraytp is
        variable initarray :  initarraytp;
        variable serial_stream : bit_vector (64*256 downto 0) := (others => '0');
        variable y : integer;
        variable z: integer;
        variable offset_a : integer;
        variable offset_b : integer;


    -- function required for virtex5, virtex6 and 7 series

    -------------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------------
    ---  Lookup table block RAM address
    --   |10  |09  |08  |07  |06  |05  |04  |03  |02  |01  |00  |
    --   |         |              |              |              |
    --   |         |              |              |              |
    --   |used with| select       |select shifted|  pattern     |
    --   |DWclock  | datawidth    |word version  |  address     |
    --------------------------------------------------------------------------------------------------------------------
    ---  Lookup table block RAM data (5 bits wide)
    ---  2 dt 0: source bit address
    ---  3: valid (wren for fifo)
    ---  4: counter reset, is one in last-1 cycle

    begin

        --loop between different word shifts (for 6 bit serdes -> 6 possible options)
        for i in 0 to 5 loop

        --8 bit
            --1st cycle
            serial_stream(2+(i*64) downto 0+(i*64))                 := bit_vector(to_unsigned(i,3));
            serial_stream(3+(i*64))                                 := '1';                             --VALID
            serial_stream(4+(i*64))                                 := '0';

            --2nd cycle
            serial_stream(10+(i*64) downto 8+(i*64))                := bit_vector(to_unsigned(2+i,3));
            if ( i > 3) then
                serial_stream(11+(i*64))                            := '0';                             --INVALID
            else
                serial_stream(11+(i*64))                            := '1';                             --VALID
            end if;
            serial_stream(12+(i*64))                                := '0';

            --3rd cycle
            serial_stream(18+(i*64) downto 16+(i*64))       := bit_vector(to_unsigned(4+i,3));
            if ( i =2  or i = 3) then
                serial_stream(19+(i*64))                            := '0';                             --INVALID
            else
                serial_stream(19+(i*64))                            := '1';                             --VALID
            end if;
            serial_stream(20+(i*64))                                := '1';

            --4th cycle
            if (i < 2) then
                serial_stream(26+(i*64) downto 24+(i*64))           := bit_vector(to_unsigned(0,3));
                serial_stream(27+(i*64))                            := '0';                             --INVALID
            else
                serial_stream(26+(i*64) downto 24+(i*64))           := bit_vector(to_unsigned(i-2,3));
                serial_stream(27+(i*64))                            := '1';                             --VALID
            end if;
            serial_stream(28+(i*64))                                := '0';                             --reset


        --10 bit starts : 64 * 8 = bit 512
            serial_stream(512+2+(i*64) downto 512+0+(i*64))         := bit_vector(to_unsigned(i,3));
            serial_stream(512+3+(i*64))                             := '1';                             --VALID
            serial_stream(512+4+(i*64))                             := '0';

            if (i >= 2 ) then
                serial_stream(512+10+(i*64) downto 512+8+(i*64))    := bit_vector(to_unsigned(0,3));
                serial_stream(512+11+(i*64))                        := '0';                             --INVALID
            else
                serial_stream(512+10+(i*64) downto 512+8+(i*64))    := bit_vector(to_unsigned(4+i,3));
                serial_stream(512+11+(i*64))                        := '1';                             --VALID
            end if;
            serial_stream(512+12+(i*64))                            := '0';

            
            if (i < 2) then
                serial_stream(512+18+(i*64) downto 512+16+(i*64))   := bit_vector(to_unsigned(0,3));
                serial_stream(512+19+(i*64))                        := '0';                             --INVALID
            else
                serial_stream(512+18+(i*64) downto 512+16+(i*64))   := bit_vector(to_unsigned(i-2,3));
                serial_stream(512+19+(i*64))                        := '1';                             --VALID
            end if;
            serial_stream(512+20+(i*64))                            := '0';


            serial_stream(512+26+(i*64) downto 512+24+(i*64))       := bit_vector(to_unsigned(2+i,3));
            if (i >= 4 ) then
                serial_stream(512+27+(i*64))                        := '0';                             --INVALID
            else
                serial_stream(512+27+(i*64))                        := '1';                             --VALID
            end if;
            serial_stream(512+28+(i*64))                            := '1';


            
            if (i < 4) then
                serial_stream(512+34+(i*64) downto 512+32+(i*64))   := bit_vector(to_unsigned(0,3));
                serial_stream(512+35+(i*64))                        := '0';                             --INVALID
            else
                serial_stream(512+34+(i*64) downto 512+32+(i*64))   := bit_vector(to_unsigned(i-4,3));
                serial_stream(512+35+(i*64))                        := '1';                             --VALID
            end if;
                serial_stream(512+36+(i*64))                        := '0';                             -- reset


        --------------------------------------------------------------------------------------------------------------------------------

        -- 12 bit  starts: 128 * 8 = 1024

            serial_stream(1024+2+(i*64) downto 1024+0+(i*64))       := bit_vector(to_unsigned(i,3));
            serial_stream(1024+3+(i*64))                            := '1';                             --VALID
            serial_stream(1024+4+(i*64))                            := '0';

            serial_stream(1024+10+(i*64) downto 1024+8+(i*64))      := bit_vector(to_unsigned(0,3));
            serial_stream(1024+11+(i*64))                           := '0';                             -- invalid
            serial_stream(1024+12+(i*64))                           := '0';

            serial_stream(1024+18+(i*64) downto 1024+16+(i*64))     := bit_vector(to_unsigned(i,3));
            serial_stream(1024+19+(i*64))                           := '1';                             --VALID
            serial_stream(1024+20+(i*64))                           := '1';                             -- reset

            serial_stream(1024+26+(i*64) downto 1024+24+(i*64))     := bit_vector(to_unsigned(0,3));
            serial_stream(1024+27+(i*64))                           := '0';                             -- invalid
            serial_stream(1024+28+(i*64))                           := '0';

      --------------------------------------------------------------------------------------------------------------------------------


         -- 14 bit starts: 192 * 8 = 1536

            serial_stream(1536+2+(i*64) downto 1536+0+(i*64))       := bit_vector(to_unsigned(i,3));
            serial_stream(1536+3+(i*64))                            := '1';                             --VALID
            serial_stream(1536+4+(i*64))                            := '0';

            serial_stream(1536+10+(i*64) downto 1536+8+(i*64))      := bit_vector(to_unsigned(0,3));
            serial_stream(1536+11+(i*64))                           := '0';                             --INVALID
            serial_stream(1536+12+(i*64))                           := '0';

            serial_stream(1536+18+(i*64) downto 1536+16+(i*64))     := bit_vector(to_unsigned(2+i,3));
            if ( i >=4 ) then
                serial_stream(1536+19+(i*64))                       := '0';                             --INVALID
            else
                serial_stream(1536+19+(i*64))                       := '1';                             --VALID
            end if;
            serial_stream(1536+20+(i*64))                           := '0';

            
            if ( i <4 ) then
                serial_stream(1536+26+(i*64) downto 1536+24+(i*64))     := bit_vector(to_unsigned(0,3));
                serial_stream(1536+27+(i*64))                      := '0';                             --INVALID
            else
                serial_stream(1536+26+(i*64) downto 1536+24+(i*64))     := bit_vector(to_unsigned(i-4,3));
                serial_stream(1536+27+(i*64))                      := '1';                             --VALID
            end if;
            serial_stream(1536+28+(i*64))                           := '0';

            serial_stream(1536+34+(i*64) downto 1536+32+(i*64))     := bit_vector(to_unsigned(4+i,3));
            if (i >=2) then
                serial_stream(1536+35+(i*64))                       := '0';                             --INVALID
            else
                serial_stream(1536+35+(i*64))                       := '1';                             --VALID
            end if;
            serial_stream(1536+36+(i*64))                           := '0';

            
            if ( i < 2 ) then
                serial_stream(1536+42+(i*64) downto 1536+40+(i*64))     := bit_vector(to_unsigned(0,3));
                serial_stream(1536+43+(i*64))                       := '0';                             --INVALID
            else
                serial_stream(1536+42+(i*64) downto 1536+40+(i*64))     := bit_vector(to_unsigned(i-2,3));
                serial_stream(1536+43+(i*64))                       := '1';                             --INVALID
            end if;
            serial_stream(1536+44+(i*64))                           := '1';                             --RESET

            serial_stream(1536+50+(i*64) downto 1536+48+(i*64))     := bit_vector(to_unsigned(0,3));
            serial_stream(1536+51+(i*64))                           := '0';
            serial_stream(1536+52+(i*64))                           := '0';                             --RESET

     -----------------------------------------------------------------------------------------------------------------------------------------------------



        -- 16 bit dataword starts: 256 * 8 = 2048


            serial_stream(2048+2+(i*64) downto 2048+0+(i*64))       := bit_vector(to_unsigned(i,3));
            serial_stream(2048+3+(i*64))                            := '1';                             --VALID
            serial_stream(2048+4+(i*64))                            := '0';

            serial_stream(2048+10+(i*64) downto 2048+8+(i*64))      := bit_vector(to_unsigned(0,3));
            serial_stream(2048+11+(i*64))                           := '0';                             --INVALID
            serial_stream(2048+12+(i*64))                           := '0';

            serial_stream(2048+18+(i*64) downto 2048+16+(i*64))     := bit_vector(to_unsigned(4+i,3));
            if (i>=2)then
                serial_stream(2048+19+(i*64))                       := '0';                             --INVALID
            else
                serial_stream(2048+19+(i*64))                       := '1';                             --VALID
            end if;
            serial_stream(2048+20+(i*64))                           := '0';

            
            if(i<2)then
                serial_stream(2048+26+(i*64) downto 2048+24+(i*64))     := bit_vector(to_unsigned(0,3));
                serial_stream(2048+27+(i*64))                       := '0';                             --INVALID
            else
                serial_stream(2048+26+(i*64) downto 2048+24+(i*64))     := bit_vector(to_unsigned(i-2,3));
                serial_stream(2048+27+(i*64))                       := '1';                             --VALID
            end if;
            serial_stream(2048+28+(i*64))                           := '0';

            serial_stream(2048+34+(i*64) downto 2048+32+(i*64))     := bit_vector(to_unsigned(0,3));
            serial_stream(2048+35+(i*64))                           := '0';                             --INVALID
            serial_stream(2048+36+(i*64))                           := '0';

            serial_stream(2048+42+(i*64) downto 2048+40+(i*64))     := bit_vector(to_unsigned(2+i,3));
            if(i>=4)then
                serial_stream(2048+43+(i*64))                       := '0';                             --INVALID
            else
                serial_stream(2048+43+(i*64))                       := '1';                             --VALID
            end if;
            serial_stream(2048+44+(i*64))                           := '0';

            if(i<4)then
                serial_stream(2048+50+(i*64) downto 2048+48+(i*64))     := bit_vector(to_unsigned(0,3));
                serial_stream(2048+51+(i*64))                       := '0';                             --INVALID
            else
                serial_stream(2048+50+(i*64) downto 2048+48+(i*64))     := bit_vector(to_unsigned(i-4,3));
                serial_stream(2048+51+(i*64))                       := '1';                             --VALID
            end if;
            serial_stream(2048+52+(i*64))                           := '1';                             --RESET

            serial_stream(2048+58+(i*64) downto 2048+56+(i*64))     := bit_vector(to_unsigned(0,3));
            serial_stream(2048+59+(i*64))                           := '0';
            serial_stream(2048+60+(i*64))                           := '0';                             --RESET

     --------------------------------------------------------------------------------------------------------------------------------
        -- 18 bit datawidth starts: 320 * 8 = 2560

            serial_stream(2560+2+(i*64) downto 2560+0+(i*64))       := bit_vector(to_unsigned(i,3));
            serial_stream(2560+3+(i*64))                            := '1';                             --VALID
            serial_stream(2560+4+(i*64))                            := '0';

            serial_stream(2560+10+(i*64) downto 2560+8+(i*64))      := bit_vector(to_unsigned(0,3));
            serial_stream(2560+11+(i*64))                           := '0';                             --INVALID
            serial_stream(2560+12+(i*64))                           := '1';                             --RESET


            serial_stream(2560+18+(i*64) downto 2560+16+(i*64))     := bit_vector(to_unsigned(0,3));
            serial_stream(2560+19+(i*64))                           := '0';                             --INVALID
            serial_stream(2560+20+(i*64))                           := '0';                             --RESET


    -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

       --     When using the returning dataword clock, the serial data is running equal to this clock or is skewed by 1 bit (sooner or later) the address space 512 and 1024 are used for these shifted positions

      --      shift by 1 left

            if (i=5) then
                    y := 0;
            else
                    y := i+ 1;
            end if;

            offset_a    := 512*8;

            serial_stream(offset_a+2+(i*64) downto offset_a+0+(i*64))        := bit_vector(to_unsigned(y,3));
            serial_stream(offset_a+3+(i*64))                                 := '1';                             --VALID
            serial_stream(offset_a+4+(i*64))                                 := '0';

            serial_stream(offset_a+10+(i*64) downto offset_a+8+(i*64))                := bit_vector(to_unsigned(2+y,3));
            if ( y > 3) then
                serial_stream(offset_a+11+(i*64))                            := '0';                             --INVALID
            else
            serial_stream(offset_a+11+(i*64))                                := '1';                             --VALID
            end if;
            serial_stream(offset_a+12+(i*64))                                := '0';


            serial_stream(offset_a+18+(i*64) downto offset_a+16+(i*64))      := bit_vector(to_unsigned(4+y,3));
            if ( y =2  or y = 3) then
                serial_stream(offset_a+19+(i*64))                            := '0';                             --INVALID
            else
                serial_stream(offset_a+19+(i*64))                            := '1';                             --VALID
            end if;
            serial_stream(offset_a+20+(i*64))                                := '1';


            
            if (y < 2) then
                serial_stream(offset_a+26+(i*64) downto offset_a+24+(i*64))  := bit_vector(to_unsigned(0,3));
                serial_stream(offset_a+27+(i*64))                            := '0';                             --INVALID
            else
                serial_stream(offset_a+26+(i*64) downto offset_a+24+(i*64))  := bit_vector(to_unsigned(y-2,3));
                serial_stream(offset_a+27+(i*64))                            := '1';                             --VALID
            end if;
            serial_stream(offset_a+28+(i*64))                                := '0';                             --reset

       -- serial_stream (22+(i*40) downto 20+(i*40))              := bit_vector(to_unsigned(i));
       -- serial_stream (23+(i*40))                               := '1';                               --VALID
       -- serial_stream (24+(i*40))                               := '0';
       --
       -- serial_stream (27+(i*40) downto 25+(i*40))              := bit_vector(to_unsigned(2+i));
       -- serial_stream (28+(i*40))                               := '1';                               --VALID
       -- serial_stream (29+(i*40))                               := '0';
       --
       -- serial_stream (32+(i*40) downto 30+(i*40))              := bit_vector(to_unsigned(4+i));
       -- serial_stream (33+(i*40))                               := '1';                               --VALID
       -- serial_stream (34+(i*40))                               := '0';
       --
       -- serial_stream (38+(i*40) downto 35+(i*40))              := bit_vector(to_unsigned(0));
       -- serial_stream (39+(i*40))                               := '1';                               --reset



        --10 bit starts : 64 * 8 = bit 512

            serial_stream(offset_a+512+2+(i*64) downto offset_a+512+0+(i*64))   := bit_vector(to_unsigned(y,3));
            serial_stream(offset_a+512+3+(i*64))                                := '1';                             --VALID
            serial_stream(offset_a+512+4+(i*64))                                := '0';

            serial_stream(offset_a+512+10+(i*64) downto offset_a+512+8+(i*64))  := bit_vector(to_unsigned(4+y,3));
            if (y >= 2 ) then
                serial_stream(offset_a+512+11+(i*64))                           := '0';                             --INVALID
            else
                serial_stream(offset_a+512+11+(i*64))                           := '1';                             --VALID
            end if;
            serial_stream(offset_a+512+12+(i*64))                               := '0';

            
            if (y < 2) then
                serial_stream(offset_a+512+18+(i*64) downto offset_a+512+16+(i*64)) := bit_vector(to_unsigned(0,3));  --INVALID
                serial_stream(offset_a+512+19+(i*64))                           := '0';                             --INVALID
            else
                serial_stream(offset_a+512+18+(i*64) downto offset_a+512+16+(i*64)) := bit_vector(to_unsigned(y-2,3));  --INVALID
                serial_stream(offset_a+512+19+(i*64))                           := '1';                             --VALID
            end if;
            serial_stream(offset_a+512+20+(i*64))                               := '0';


            serial_stream(offset_a+512+26+(i*64) downto offset_a+512+24+(i*64)) := bit_vector(to_unsigned(2+y,3));
            if (y >= 4 ) then
                serial_stream(offset_a+512+27+(i*64))                           := '0';                             --INVALID
            else
                serial_stream(offset_a+512+27+(i*64))                           := '1';                             --VALID
            end if;
            serial_stream(offset_a+512+28+(i*64))                               := '1';


            
            if (y < 4) then
                serial_stream(offset_a+512+34+(i*64) downto offset_a+512+32+(i*64)) := bit_vector(to_unsigned(0,3));
                serial_stream(offset_a+512+35+(i*64))                           := '0';                             --INVALID
            else
                serial_stream(offset_a+512+34+(i*64) downto offset_a+512+32+(i*64)) := bit_vector(to_unsigned(y-4,3));
                serial_stream(offset_a+512+35+(i*64))                           := '1';                             --VALID
            end if;
                serial_stream(offset_a+512+36+(i*64))                           := '0';                             -- reset


        --------------------------------------------------------------------------------------------------------------------------------

        -- 12 bit  starts: 128 * 8 = 1024

            serial_stream(offset_a+1024+2+(i*64) downto offset_a+1024+0+(i*64))     := bit_vector(to_unsigned(y,3));
            serial_stream(offset_a+1024+3+(i*64))                                   := '1';                             --VALID
            serial_stream(offset_a+1024+4+(i*64))                                   := '0';

            serial_stream(offset_a+1024+10+(i*64) downto offset_a+1024+8+(i*64))    := bit_vector(to_unsigned(0,3));
            serial_stream(offset_a+1024+11+(i*64))                                  := '0';                             -- invalid
            serial_stream(offset_a+1024+12+(i*64))                                  := '0';

            serial_stream(offset_a+1024+18+(i*64) downto offset_a+1024+16+(i*64))   := bit_vector(to_unsigned(y,3));
            serial_stream(offset_a+1024+19+(i*64))                                  := '1';                             --VALID
            serial_stream(offset_a+1024+20+(i*64))                                  := '1';                             -- reset

            serial_stream(offset_a+1024+26+(i*64) downto offset_a+1024+24+(i*64))   := bit_vector(to_unsigned(0,3));
            serial_stream(offset_a+1024+27+(i*64))                                  := '0';                             -- invalid
            serial_stream(offset_a+1024+28+(i*64))                                  := '0';

      --------------------------------------------------------------------------------------------------------------------------------


         -- 14 bit starts: 192 * 8 = 1536

            serial_stream(offset_a+1536+2+(i*64) downto offset_a+1536+0+(i*64))     := bit_vector(to_unsigned(y,3));
            serial_stream(offset_a+1536+3+(i*64))                                   := '1';                             --VALID
            serial_stream(offset_a+1536+4+(i*64))                                   := '0';

            serial_stream(offset_a+1536+10+(i*64) downto offset_a+1536+8+(i*64))    := bit_vector(to_unsigned(0,3));
            serial_stream(offset_a+1536+11+(i*64))                                  := '0';                             --INVALID
            serial_stream(offset_a+1536+12+(i*64))                                  := '0';

            serial_stream(offset_a+1536+18+(i*64) downto offset_a+1536+16+(i*64))   := bit_vector(to_unsigned(2+y,3));
            if ( y >=4 ) then
                serial_stream(offset_a+1536+19+(i*64))                              := '0';                             --INVALID
            else
                serial_stream(offset_a+1536+19+(i*64))                              := '1';                             --VALID
            end if;
            serial_stream(offset_a+1536+20+(i*64))                                  := '0';

            
            if ( y <4 ) then
                serial_stream(offset_a+1536+26+(i*64) downto offset_a+1536+24+(i*64))   := bit_vector(to_unsigned(0,3));
                serial_stream(offset_a+1536+27+(i*64))                             := '0';                             --INVALID
            else
                serial_stream(offset_a+1536+26+(i*64) downto offset_a+1536+24+(i*64))   := bit_vector(to_unsigned(y-4,3));
                serial_stream(offset_a+1536+27+(i*64))                             := '1';                             --VALID
            end if;
            serial_stream(offset_a+1536+28+(i*64))                                  := '0';

            serial_stream(offset_a+1536+34+(i*64) downto offset_a+1536+32+(i*64))   := bit_vector(to_unsigned(4+y,3));
            if (y >=2) then
                serial_stream(offset_a+1536+35+(i*64))                              := '0';                             --INVALID
            else
                serial_stream(offset_a+1536+35+(i*64))                              := '1';                             --VALID
            end if;
            serial_stream(offset_a+1536+36+(i*64))                                  := '0';

            
            if ( y < 2 ) then
                serial_stream(offset_a+1536+42+(i*64) downto offset_a+1536+40+(i*64))   := bit_vector(to_unsigned(0,3));
                serial_stream(offset_a+1536+43+(i*64))                              := '0';                             --INVALID
            else
                serial_stream(offset_a+1536+42+(i*64) downto offset_a+1536+40+(i*64))   := bit_vector(to_unsigned(y-2,3));
                serial_stream(offset_a+1536+43+(i*64))                              := '1';                             --INVALID
            end if;
            serial_stream(offset_a+1536+44+(i*64))                                  := '1';                             --RESET

            serial_stream(offset_a+1536+50+(i*64) downto offset_a+1536+48+(i*64))   := bit_vector(to_unsigned(0,3));
            serial_stream(offset_a+1536+51+(i*64))                                  := '0';
            serial_stream(offset_a+1536+52+(i*64))                                  := '0';                             --RESET

     -----------------------------------------------------------------------------------------------------------------------------------------------------



        -- 16 bit dataword starts: 256 * 8 = 2048


            serial_stream(offset_a+2048+2+(i*64) downto offset_a+2048+0+(i*64))     := bit_vector(to_unsigned(y,3));
            serial_stream(offset_a+2048+3+(i*64))                                   := '1';                             --VALID
            serial_stream(offset_a+2048+4+(i*64))                                   := '0';

            serial_stream(offset_a+2048+10+(i*64) downto offset_a+2048+8+(i*64))    := bit_vector(to_unsigned(0,3));
            serial_stream(offset_a+2048+11+(i*64))                                  := '0';                             --INVALID
            serial_stream(offset_a+2048+12+(i*64))                                  := '0';

            serial_stream(offset_a+2048+18+(i*64) downto offset_a+2048+16+(i*64))   := bit_vector(to_unsigned(4+y,3));
            if (y>=2)then
                serial_stream(offset_a+2048+19+(i*64))                              := '0';                             --INVALID
            else
                serial_stream(offset_a+2048+19+(i*64))                              := '1';                             --VALID
            end if;
            serial_stream(offset_a+2048+20+(i*64))                                  := '0';

            
            if(y<2)then
                serial_stream(offset_a+2048+26+(i*64) downto offset_a+2048+24+(i*64))   := bit_vector(to_unsigned(0,3));
                serial_stream(offset_a+2048+27+(i*64))                              := '0';                             --INVALID
            else
                serial_stream(offset_a+2048+26+(i*64) downto offset_a+2048+24+(i*64))   := bit_vector(to_unsigned(y-2,3));
                serial_stream(offset_a+2048+27+(i*64))                              := '1';                             --VALID
            end if;
            serial_stream(offset_a+2048+28+(i*64))                                  := '0';

            serial_stream(offset_a+2048+34+(i*64) downto offset_a+2048+32+(i*64))   := bit_vector(to_unsigned(0,3));
            serial_stream(offset_a+2048+35+(i*64))                                  := '0';                             --INVALID
            serial_stream(offset_a+2048+36+(i*64))                                  := '0';

            serial_stream(offset_a+2048+42+(i*64) downto offset_a+2048+40+(i*64))   := bit_vector(to_unsigned(2+y,3));
            if(y>=4)then
                serial_stream(offset_a+2048+43+(i*64))                              := '0';                             --INVALID
            else
                serial_stream(offset_a+2048+43+(i*64))                              := '1';                             --VALID
            end if;
            serial_stream(offset_a+2048+44+(i*64))                                  := '0';

            
            if(y<4)then
                serial_stream(offset_a+2048+50+(i*64) downto offset_a+2048+48+(i*64))   := bit_vector(to_unsigned(0,3));
                serial_stream(offset_a+2048+51+(i*64))                              := '0';                             --INVALID
            else
                serial_stream(offset_a+2048+50+(i*64) downto offset_a+2048+48+(i*64))   := bit_vector(to_unsigned(y-4,3));
                serial_stream(offset_a+2048+51+(i*64))                              := '1';                             --VALID
            end if;
            serial_stream(offset_a+2048+52+(i*64))                                  := '1';                             --RESET

            serial_stream(offset_a+2048+58+(i*64) downto offset_a+2048+56+(i*64))   := bit_vector(to_unsigned(0,3));
            serial_stream(offset_a+2048+59+(i*64))                                  := '0';
            serial_stream(offset_a+2048+60+(i*64))                                  := '0';                             --RESET

     --------------------------------------------------------------------------------------------------------------------------------
        -- 18 bit datawidth starts: 320 * 8 = 2560

            serial_stream(offset_a+2560+2+(i*64) downto offset_a+2560+0+(i*64))     := bit_vector(to_unsigned(y,3));
            serial_stream(offset_a+2560+3+(i*64))                                   := '1';                             --VALID
            serial_stream(offset_a+2560+4+(i*64))                                   := '0';

            serial_stream(offset_a+2560+10+(i*64) downto offset_a+2560+8+(i*64))    := bit_vector(to_unsigned(0,3));
            serial_stream(offset_a+2560+11+(i*64))                                  := '0';                             --INVALID
            serial_stream(offset_a+2560+12+(i*64))                                  := '1';                             --RESET

            serial_stream(offset_a+2560+18+(i*64) downto offset_a+2560+16+(i*64))   := bit_vector(to_unsigned(0,3));
            serial_stream(offset_a+2560+19+(i*64))                                  := '0';                             --INVALID
            serial_stream(offset_a+2560+20+(i*64))                                  := '0';                             --RESET

    -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



       --     When using the returning dataword clock, the serial data is running equal to this clock or is skewed by 1 bit (sooner or later) the address space 512 and 1024 are used for these shifted positions

       --     shift by 1 right

            if (i=0) then
                    z := 5;
            else
                    z := i - 1;
            end if;

            offset_b    := 1024*8;

            serial_stream(offset_b+2+(i*64) downto offset_b+0+(i*64))        := bit_vector(to_unsigned(z,3));
            serial_stream(offset_b+3+(i*64))                                 := '1';                             --VALID
            serial_stream(offset_b+4+(i*64))                                 := '0';

            serial_stream(offset_b+10+(i*64) downto offset_b+8+(i*64))                := bit_vector(to_unsigned(2+z,3));
            if ( z > 3) then
                serial_stream(offset_b+11+(i*64))                            := '0';                             --INVALID
            else
            serial_stream(offset_b+11+(i*64))                                := '1';                             --VALID
            end if;
            serial_stream(offset_b+12+(i*64))                                := '0';


            serial_stream(offset_b+18+(i*64) downto offset_b+16+(i*64))      := bit_vector(to_unsigned(4+z,3));
            if ( z =2  or z = 3) then
                serial_stream(offset_b+19+(i*64))                            := '0';                             --INVALID
            else
                serial_stream(offset_b+19+(i*64))                            := '1';                             --VALID
            end if;
            serial_stream(offset_b+20+(i*64))                                := '1';


            
            if (z < 2) then
                serial_stream(offset_b+26+(i*64) downto offset_b+24+(i*64))      := bit_vector(to_unsigned(0,3));
                serial_stream(offset_b+27+(i*64))                            := '0';                             --INVALID
            else
                serial_stream(offset_b+26+(i*64) downto offset_b+24+(i*64))      := bit_vector(to_unsigned(z-2,3));
                serial_stream(offset_b+27+(i*64))                            := '1';                             --VALID
            end if;
            serial_stream(offset_b+28+(i*64))                                := '0';                             --reset

       -- serial_stream (22+(i*40) downto 20+(i*40))              := bit_vector(to_unsigned(i));
       -- serial_stream (23+(i*40))                               := '1';                               --VALID
       -- serial_stream (24+(i*40))                               := '0';
       --
       -- serial_stream (27+(i*40) downto 25+(i*40))              := bit_vector(to_unsigned(2+i));
       -- serial_stream (28+(i*40))                               := '1';                               --VALID
       -- serial_stream (29+(i*40))                               := '0';
       --
       -- serial_stream (32+(i*40) downto 30+(i*40))              := bit_vector(to_unsigned(4+i));
       -- serial_stream (33+(i*40))                               := '1';                               --VALID
       -- serial_stream (34+(i*40))                               := '0';
       --
       -- serial_stream (38+(i*40) downto 35+(i*40))              := bit_vector(to_unsigned(0));
       -- serial_stream (39+(i*40))                               := '1';                               --reset



        --10 bit starts : 64 * 8 = bit 512

            serial_stream(offset_b+512+2+(i*64) downto offset_b+512+0+(i*64))   := bit_vector(to_unsigned(z,3));
            serial_stream(offset_b+512+3+(i*64))                                := '1';                             --VALID
            serial_stream(offset_b+512+4+(i*64))                                := '0';

            serial_stream(offset_b+512+10+(i*64) downto offset_b+512+8+(i*64))  := bit_vector(to_unsigned(4+z,3));
            if (z >= 2 ) then
                serial_stream(offset_b+512+11+(i*64))                           := '0';                             --INVALID
            else
                serial_stream(offset_b+512+11+(i*64))                           := '1';                             --VALID
            end if;
            serial_stream(offset_b+512+12+(i*64))                               := '0';

            
            if (z < 2) then
                serial_stream(offset_b+512+18+(i*64) downto offset_b+512+16+(i*64)) := bit_vector(to_unsigned(0,3));  --INVALID
                serial_stream(offset_b+512+19+(i*64))                           := '0';                             --INVALID
            else
                serial_stream(offset_b+512+18+(i*64) downto offset_b+512+16+(i*64)) := bit_vector(to_unsigned(z-2,3));  --INVALID
                serial_stream(offset_b+512+19+(i*64))                           := '1';                             --VALID
            end if;
            serial_stream(offset_b+512+20+(i*64))                               := '0';


            serial_stream(offset_b+512+26+(i*64) downto offset_b+512+24+(i*64)) := bit_vector(to_unsigned(2+z,3));
            if (z >= 4 ) then
                serial_stream(offset_b+512+27+(i*64))                           := '0';                             --INVALID
            else
                serial_stream(offset_b+512+27+(i*64))                           := '1';                             --VALID
            end if;
            serial_stream(offset_b+512+28+(i*64))                               := '1';


            
            if (z < 4) then
                serial_stream(offset_b+512+34+(i*64) downto offset_b+512+32+(i*64)) := bit_vector(to_unsigned(0,3));
                serial_stream(offset_b+512+35+(i*64))                           := '0';                             --INVALID
            else
                serial_stream(offset_b+512+34+(i*64) downto offset_b+512+32+(i*64)) := bit_vector(to_unsigned(z-4,3));
                serial_stream(offset_b+512+35+(i*64))                           := '1';                             --VALID
            end if;
                serial_stream(offset_b+512+36+(i*64))                           := '0';                             -- reset


        --------------------------------------------------------------------------------------------------------------------------------

        -- 12 bit  starts: 128 * 8 = 1024

            serial_stream(offset_b+1024+2+(i*64) downto offset_b+1024+0+(i*64))     := bit_vector(to_unsigned(z,3));
            serial_stream(offset_b+1024+3+(i*64))                                   := '1';                             --VALID
            serial_stream(offset_b+1024+4+(i*64))                                   := '0';

            serial_stream(offset_b+1024+10+(i*64) downto offset_b+1024+8+(i*64))    := bit_vector(to_unsigned(0,3));
            serial_stream(offset_b+1024+11+(i*64))                                  := '0';                             -- invalid
            serial_stream(offset_b+1024+12+(i*64))                                  := '0';

            serial_stream(offset_b+1024+18+(i*64) downto offset_b+1024+16+(i*64))   := bit_vector(to_unsigned(z,3));
            serial_stream(offset_b+1024+19+(i*64))                                  := '1';                             --VALID
            serial_stream(offset_b+1024+20+(i*64))                                  := '1';                             -- reset

            serial_stream(offset_b+1024+26+(i*64) downto offset_b+1024+24+(i*64))   := bit_vector(to_unsigned(0,3));
            serial_stream(offset_b+1024+27+(i*64))                                  := '0';                             -- invalid
            serial_stream(offset_b+1024+28+(i*64))                                  := '0';

      --------------------------------------------------------------------------------------------------------------------------------


         -- 14 bit starts: 192 * 8 = 1536

            serial_stream(offset_b+1536+2+(i*64) downto offset_b+1536+0+(i*64))     := bit_vector(to_unsigned(z,3));
            serial_stream(offset_b+1536+3+(i*64))                                   := '1';                             --VALID
            serial_stream(offset_b+1536+4+(i*64))                                   := '0';

            serial_stream(offset_b+1536+10+(i*64) downto offset_b+1536+8+(i*64))    := bit_vector(to_unsigned(0,3));
            serial_stream(offset_b+1536+11+(i*64))                                  := '0';                             --INVALID
            serial_stream(offset_b+1536+12+(i*64))                                  := '0';

            serial_stream(offset_b+1536+18+(i*64) downto offset_b+1536+16+(i*64))   := bit_vector(to_unsigned(2+z,3));
            if ( z >=4 ) then
                serial_stream(offset_b+1536+19+(i*64))                              := '0';                             --INVALID
            else
                serial_stream(offset_b+1536+19+(i*64))                              := '1';                             --VALID
            end if;
            serial_stream(offset_b+1536+20+(i*64))                                  := '0';

            
            if ( z <4 ) then
                serial_stream(offset_b+1536+26+(i*64) downto offset_b+1536+24+(i*64))   := bit_vector(to_unsigned(0,3));
                serial_stream(offset_b+1536+27+(i*64))                             := '0';                             --INVALID
            else
                serial_stream(offset_b+1536+26+(i*64) downto offset_b+1536+24+(i*64))   := bit_vector(to_unsigned(z-4,3));
                serial_stream(offset_b+1536+27+(i*64))                             := '1';                             --VALID
            end if;
            serial_stream(offset_b+1536+28+(i*64))                                  := '0';

            serial_stream(offset_b+1536+34+(i*64) downto offset_b+1536+32+(i*64))   := bit_vector(to_unsigned(4+z,3));
            if (z >=2) then
                serial_stream(offset_b+1536+35+(i*64))                              := '0';                             --INVALID
            else
                serial_stream(offset_b+1536+35+(i*64))                              := '1';                             --VALID
            end if;
            serial_stream(offset_b+1536+36+(i*64))                                  := '0';

            
            if ( z < 2 ) then
                serial_stream(offset_b+1536+42+(i*64) downto offset_b+1536+40+(i*64))   := bit_vector(to_unsigned(0,3));
                serial_stream(offset_b+1536+43+(i*64))                              := '0';                             --INVALID
            else
                serial_stream(offset_b+1536+42+(i*64) downto offset_b+1536+40+(i*64))   := bit_vector(to_unsigned(z-2,3));
                serial_stream(offset_b+1536+43+(i*64))                              := '1';                             --INVALID
            end if;
            serial_stream(offset_b+1536+44+(i*64))                                  := '1';                             --RESET

            serial_stream(offset_b+1536+50+(i*64) downto offset_b+1536+48+(i*64))   := bit_vector(to_unsigned(0,3));
            serial_stream(offset_b+1536+51+(i*64))                                  := '0';
            serial_stream(offset_b+1536+52+(i*64))                                  := '0';                             --RESET

     -----------------------------------------------------------------------------------------------------------------------------------------------------



        -- 16 bit dataword starts: 256 * 8 = 2048


            serial_stream(offset_b+2048+2+(i*64) downto offset_b+2048+0+(i*64))     := bit_vector(to_unsigned(z,3));
            serial_stream(offset_b+2048+3+(i*64))                                   := '1';                             --VALID
            serial_stream(offset_b+2048+4+(i*64))                                   := '0';

            serial_stream(offset_b+2048+10+(i*64) downto offset_b+2048+8+(i*64))    := bit_vector(to_unsigned(0,3));
            serial_stream(offset_b+2048+11+(i*64))                                  := '0';                             --INVALID
            serial_stream(offset_b+2048+12+(i*64))                                  := '0';

            serial_stream(offset_b+2048+18+(i*64) downto offset_b+2048+16+(i*64))   := bit_vector(to_unsigned(4+z,3));
            if (z>=2)then
                serial_stream(offset_b+2048+19+(i*64))                              := '0';                             --INVALID
            else
                serial_stream(offset_b+2048+19+(i*64))                              := '1';                             --VALID
            end if;
            serial_stream(offset_b+2048+20+(i*64))                                  := '0';

            
            if(z<2)then
                serial_stream(offset_b+2048+26+(i*64) downto offset_b+2048+24+(i*64))   := bit_vector(to_unsigned(0,3));
                serial_stream(offset_b+2048+27+(i*64))                              := '0';                             --INVALID
            else
                serial_stream(offset_b+2048+26+(i*64) downto offset_b+2048+24+(i*64))   := bit_vector(to_unsigned(z-2,3));
                serial_stream(offset_b+2048+27+(i*64))                              := '1';                             --VALID
            end if;
            serial_stream(offset_b+2048+28+(i*64))                                  := '0';

            serial_stream(offset_b+2048+34+(i*64) downto offset_b+2048+32+(i*64))   := bit_vector(to_unsigned(0,3));
            serial_stream(offset_b+2048+35+(i*64))                                  := '0';                             --INVALID
            serial_stream(offset_b+2048+36+(i*64))                                  := '0';

            serial_stream(offset_b+2048+42+(i*64) downto offset_b+2048+40+(i*64))   := bit_vector(to_unsigned(2+z,3));
            if(z>=4)then
                serial_stream(offset_b+2048+43+(i*64))                              := '0';                             --INVALID
            else
                serial_stream(offset_b+2048+43+(i*64))                              := '1';                             --VALID
            end if;
            serial_stream(offset_b+2048+44+(i*64))                                  := '0';

            
            if(z<4)then
                serial_stream(offset_b+2048+50+(i*64) downto offset_b+2048+48+(i*64))   := bit_vector(to_unsigned(0,3));
                serial_stream(offset_b+2048+51+(i*64))                              := '0';                             --INVALID
            else
                serial_stream(offset_b+2048+50+(i*64) downto offset_b+2048+48+(i*64))   := bit_vector(to_unsigned(z-4,3));
                serial_stream(offset_b+2048+51+(i*64))                              := '1';                             --VALID
            end if;
            serial_stream(offset_b+2048+52+(i*64))                                  := '1';                             --RESET

            serial_stream(offset_b+2048+58+(i*64) downto offset_b+2048+56+(i*64))   := bit_vector(to_unsigned(0,3));
            serial_stream(offset_b+2048+59+(i*64))                                  := '0';
            serial_stream(offset_b+2048+60+(i*64))                                  := '0';                             --RESET

     --------------------------------------------------------------------------------------------------------------------------------
        -- 18 bit datawidth starts: 320 * 8 = 2560



            serial_stream(offset_b+2560+2+(i*64) downto offset_b+2560+0+(i*64))     := bit_vector(to_unsigned(z,3));
            serial_stream(offset_b+2560+3+(i*64))                                   := '1';                             --VALID
            serial_stream(offset_b+2560+4+(i*64))                                   := '0';

            serial_stream(offset_b+2560+10+(i*64) downto offset_b+2560+8+(i*64))    := bit_vector(to_unsigned(0,3));   --INVALID
            serial_stream(offset_b+2560+11+(i*64))                                  := '0';
            serial_stream(offset_b+2560+12+(i*64))                                  := '1';                             --RESET


            serial_stream(offset_b+2560+18+(i*64) downto offset_b+2560+16+(i*64))    := bit_vector(to_unsigned(0,3));
            serial_stream(offset_b+2560+19+(i*64))                                   := '0';
            serial_stream(offset_b+2560+20+(i*64))                                   := '0';                             --RESET


    -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

            for i in 0 to 63 loop

                initarray(i) := serial_stream((256*(i+1))-1 downto 0+(256*i));

            end loop;
        end loop;

        return initarray;

    end generateinitarray6bit;

    function generateinitarray8bit return initarraytp is
        variable initarray :  initarraytp;
        variable serial_stream : bit_vector (64*256 downto 0) := (others => '0');
        variable y : integer;
        variable z: integer;
        variable offset_a : integer;
        variable offset_b : integer;


    -- function required for ultrascale

    -------------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------------
    ---  Lookup table block RAM address
    --   |10  |09  |08  |07  |06  |05  |04  |03  |02  |01  |00  |
    --   |         |              |              |              |
    --   |         |              |              |              |
    --   |used with| select       |select shifted|  pattern     |
    --   |DWclock  | datawidth    |word version  |  address     |
    --------------------------------------------------------------------------------------------------------------------
    ---  Lookup table block RAM data (5 bits wide)
    ---  2 dt 0: source bit address
    ---  3: valid (wren for fifo)
    ---  4: counter reset, is one in last-1 cycle

    begin

        --loop between different word shifts (for 8 bit serdes -> 8 possible options)
        for i in 0 to 7 loop

        --8 bit
            --1st cycle
            serial_stream(2+(i*64) downto 0+(i*64))                 := bit_vector(to_unsigned(i,3));
            serial_stream(3+(i*64))                                 := '1';                             --VALID
            serial_stream(4+(i*64))                                 := '1';

            --2nd cycle
            serial_stream(10+(i*64) downto 8+(i*64))                 := bit_vector(to_unsigned(i,3));
            serial_stream(11+(i*64))                                 := '1';                             --VALID
            serial_stream(12+(i*64))                                 := '0';

        --10 bit starts : 64 * 8 = bit 512
            --1st cycle
            serial_stream(512+2+(i*64) downto 512+0+(i*64))         := bit_vector(to_unsigned(i,3));
            serial_stream(512+3+(i*64))                             := '1';                             --VALID
            serial_stream(512+4+(i*64))                             := '0';

            --2nd cycle
            serial_stream(512+10+(i*64) downto 512+8+(i*64))        := bit_vector(to_unsigned(i+2,3));
            if (i > 5) then
                serial_stream(512+11+(i*64))                        := '0';                             --INVALID
            else
                serial_stream(512+11+(i*64))                        := '1';                             --VALID
            end if;
            serial_stream(512+12+(i*64))                            := '0';

            --3rd cycle
            if (i = 4 or i = 5) then
                serial_stream(512+19+(i*64))                        := '0';                             --INVALID
            else
                if (i < 4) then
                    serial_stream(512+18+(i*64) downto 512+16+(i*64))   := bit_vector(to_unsigned(i+4,3));
                else
                    serial_stream(512+18+(i*64) downto 512+16+(i*64))   := bit_vector(to_unsigned(i+2,3));
                end if;
                serial_stream(512+19+(i*64))                        := '1';                             --VALID
            end if;
            serial_stream(512+20+(i*64))                            := '0';

            --4th cycle
            if (i = 2 or i = 3) then
                serial_stream(512+27+(i*64))                        := '0';                             --INVALID
            else
                if (i < 2) then
                    serial_stream(512+26+(i*64) downto 512+24+(i*64))  := bit_vector(to_unsigned(i+6,3));
                else
                    serial_stream(512+26+(i*64) downto 512+24+(i*64))  := bit_vector(to_unsigned(i+4,3));
                end if;
                serial_stream(512+27+(i*64))                        := '1';                             --VALID
            end if;
            serial_stream(512+28+(i*64))                            := '1';

            --5th cycle            
            if (i < 2) then
                serial_stream(512+34+(i*64) downto 512+32+(i*64))   := bit_vector(to_unsigned(0,3));
                serial_stream(512+35+(i*64))                        := '0';                             --INVALID
            else
                serial_stream(512+34+(i*64) downto 512+32+(i*64))   := bit_vector(to_unsigned(i-2,3));
                serial_stream(512+35+(i*64))                        := '1';                             --VALID
            end if;
            serial_stream(512+36+(i*64))                        := '0';                             -- reset

        -- 12 bit  starts: 128 * 8 = 1024
            --1st cycle
            serial_stream(1024+2+(i*64) downto 1024+0+(i*64))       := bit_vector(to_unsigned(i,3));
            serial_stream(1024+3+(i*64))                            := '1';                             --VALID
            serial_stream(1024+4+(i*64))                            := '0';

            --2nd cycle
            serial_stream(1024+10+(i*64) downto 1024+8+(i*64))      := bit_vector(to_unsigned(i+4,3));
            if (i >= 4) then
                serial_stream(1024+11+(i*64))                       := '0';                             -- INVALID
            else
                serial_stream(1024+11+(i*64))                       := '1';                             -- VALID
            end if;
            serial_stream(1024+12+(i*64))                           := '1';

            --3rd cycle
            if (i < 4) then
                serial_stream(1024+18+(i*64) downto 1024+16+(i*64)) := bit_vector(to_unsigned(0,3));
                serial_stream(1024+19+(i*64))                       := '0';                             -- invalid
            else
                serial_stream(1024+18+(i*64) downto 1024+16+(i*64)) := bit_vector(to_unsigned(i-4,3));
                serial_stream(1024+19+(i*64))                       := '1';                             -- valid
            end if;
            serial_stream(1024+20+(i*64))                           := '0';                             -- reset

      --------------------------------------------------------------------------------------------------------------------------------

         -- 14 bit starts: 192 * 8 = 1536
            --1st cycle
            serial_stream(1536+2+(i*64) downto 1536+0+(i*64))       := bit_vector(to_unsigned(i,3));
            serial_stream(1536+3+(i*64))                            := '1';                             --VALID
            serial_stream(1536+4+(i*64))                            := '0';

            --2nd cycle
            serial_stream(1536+10+(i*64) downto 1536+8+(i*64))      := bit_vector(to_unsigned(i+6,3));
            if ( i >=2 ) then
                serial_stream(1536+11+(i*64))                           := '0';                             --INVALID
            else
                serial_stream(1536+11+(i*64))                           := '1';                             --VALID
            end if;
            serial_stream(1536+12+(i*64))                           := '0';

            --3rd cycle            
            if ( i < 2 ) then
                serial_stream(1536+18+(i*64) downto 1536+16+(i*64)) := bit_vector(to_unsigned(0,3));
                serial_stream(1536+19+(i*64))                       := '0';                             --INVALID
            else
                serial_stream(1536+18+(i*64) downto 1536+16+(i*64)) := bit_vector(to_unsigned(i-2,3));
                serial_stream(1536+19+(i*64))                       := '1';                             --INVALID
            end if;
            serial_stream(1536+20+(i*64))                           := '0';

            --4th cycle
            serial_stream(1536+26+(i*64) downto 1536+24+(i*64))     := bit_vector(to_unsigned(i+4,3));
            if ( i >= 4 ) then
                 serial_stream(1536+27+(i*64))                      := '0';                             --INVALID
            else
                 serial_stream(1536+27+(i*64))                      := '1';                             --VALID
            end if;
            serial_stream(1536+28+(i*64))                           := '0';

            --5th cycle
            if (i < 4) then
                serial_stream(1536+34+(i*64) downto 1536+32+(i*64))     := bit_vector(to_unsigned(0,3));
                serial_stream(1536+35+(i*64))                       := '0';                             --INVALID
            else
                serial_stream(1536+34+(i*64) downto 1536+32+(i*64))     := bit_vector(to_unsigned(i-4,3));
                serial_stream(1536+35+(i*64))                       := '1';                             --VALID
            end if;
            serial_stream(1536+36+(i*64))                           := '0';

            --6th cycle
            if ( i >= 6 ) then
                serial_stream(1536+42+(i*64) downto 1536+40+(i*64))     := bit_vector(to_unsigned(0,3));
                serial_stream(1536+43+(i*64))                       := '0';                             --INVALID
            else
                serial_stream(1536+42+(i*64) downto 1536+40+(i*64))     := bit_vector(to_unsigned(i+6,3));
                serial_stream(1536+43+(i*64))                       := '1';                             --VALID
            end if;
            serial_stream(1536+44+(i*64))                           := '1';                             --RESET

            --7th cycle
            if ( i < 6 ) then
                serial_stream(1536+50+(i*64) downto 1536+48+(i*64))     := bit_vector(to_unsigned(0,3));
                serial_stream(1536+51+(i*64))                       := '0';                             --INVALID
            else
                serial_stream(1536+50+(i*64) downto 1536+48+(i*64))     := bit_vector(to_unsigned(i-6,3));
                serial_stream(1536+51+(i*64))                       := '1';                             --VALID
            end if;
            serial_stream(1536+52+(i*64))                           := '0';                             --RESET

            --8th cycle
            --(unused)
     -----------------------------------------------------------------------------------------------------------------------------------------------------

        -- 16 bit dataword starts: 256 * 8 = 2048
            --1st cycle
            serial_stream(2048+2+(i*64) downto 2048+0+(i*64))       := bit_vector(to_unsigned(i,3));
            serial_stream(2048+3+(i*64))                            := '1';                             --VALID
            serial_stream(2048+4+(i*64))                            := '1';

            --2nd cycle
            serial_stream(2048+10+(i*64) downto 2048+8+(i*64))      := bit_vector(to_unsigned(0,3));
            serial_stream(2048+11+(i*64))                           := '0';                             --INVALID
            serial_stream(2048+12+(i*64))                           := '0';

     --------------------------------------------------------------------------------------------------------------------------------
        -- 18 bit datawidth starts: 320 * 8 = 2560
            --unsupported with only 8 cycles :(
           


    -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

       --     When using the returning dataword clock, the serial data is running equal to this clock or is skewed by 1 bit (sooner or later) the address space 512 and 1024 are used for these shifted positions
      --FIXME ADD SKEWED STUFF
          
          
            for i in 0 to 63 loop

                initarray(i) := serial_stream((256*(i+1))-1 downto 0+(256*i));

            end loop;
        end loop;

        return initarray;

        end generateinitarray8bit;

end serdes_pack;