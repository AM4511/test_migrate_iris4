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

entity xgs_image is
  generic(G_XGS45M           : integer := 0;
          G_NUM_PHY          : integer := 6;
          G_PXL_ARRAY_ROWS   : integer := 3100;
          G_PXL_PER_COLRAM   : integer := 174
          );
  port(
       trigger_int         : in std_logic;
       
       dataline            : out t_dataline(0 to G_NUM_PHY*4*G_PXL_PER_COLRAM-1);
       emb_data            : out std_logic;
       first_line          : out std_logic; --indicates first line of a frame
       last_line           : out std_logic; --indicates last line of a frame
       dataline_valid      : out std_logic;
       dataline_nxt        : in  std_logic;
       
       frame_length        : in  std_logic_vector(15 downto 0);
       roi_start           : in  integer range G_PXL_ARRAY_ROWS downto 0;
       roi_size            : in  integer range G_PXL_ARRAY_ROWS downto 0;
       ext_emb_data        : in  std_logic;
       cmc_patgen_en       : in  std_logic;
       active_ctxt         : in  std_logic_vector(2 downto 0);
       nested_readout      : in  std_logic;
       x_subsampling       : in  std_logic;
       y_subsampling       : in  std_logic;
       y_reversed          : in  std_logic;
       swap_top_bottom     : in  std_logic;
       
       sequencer_enable    : in  std_logic;
       slave_triggered_mode: in  std_logic;
       frame_count         : out std_logic_vector(7 downto 0);
       
       test_pattern_mode   : in  std_logic_vector(2 downto 0);
       test_data_red       : in  std_logic_vector(12 downto 0);
       test_data_greenr    : in  std_logic_vector(12 downto 0);
       test_data_blue      : in  std_logic_vector(12 downto 0);
       test_data_greenb    : in  std_logic_vector(12 downto 0)
       
      );
end xgs_image;

architecture behaviour of xgs_image is

constant C_TP_COLUMN_SIZE    : integer := G_PXL_PER_COLRAM * (G_XGS45M+1); 
constant G_PXL_ARRAY_COLUMNS : integer := G_PXL_PER_COLRAM * G_NUM_PHY * 4;

--A frame is defined as 3 lines
--Frame(0) = Embedded data line
--Frame(1) = Line with red and green_red pixels
--Frame(2) = Line with blue and green_blue pixels
type t_frame_type is array(0 to 2) of t_dataline(0 to G_PXL_ARRAY_COLUMNS-1);
signal frame           : t_frame_type;
signal frame_nxt       : std_logic;
signal frame_valid     : std_logic;
signal line_count      : integer range 0 to 2**16-1;
signal frame_count_int : std_logic_vector(7 downto 0);
type t_debug_frame_line is array(0 to 31) of std_logic_vector(11 downto 0);
signal debug_frame_line0: t_debug_frame_line;
signal debug_frame_line1: t_debug_frame_line;
signal debug_frame_line2: t_debug_frame_line;

begin

frame_count <= frame_count_int;

--Frame generation based on mode setting
FRAME_CONTENT : process(trigger_int, dataline_nxt, sequencer_enable, frame_nxt) --jmansill : Oue... pas fort pas mettre c signal dans la liste de sensibilite (gracieusite de onsemi)...
variable var_test_data_red    : unsigned(12 downto 0);
variable var_test_data_blue   : unsigned(12 downto 0);
variable var_test_data_greenr : unsigned(12 downto 0);
variable var_test_data_greenb : unsigned(12 downto 0); 
variable var_pixel_value      : unsigned(15 downto 0);
variable var_ftg              : unsigned(11 downto 0);
variable var_line_nr          : integer range 0 to 1023;
begin
  if sequencer_enable = '0' then
    frame_count_int <= (others => '0');
    frame_valid <= '0';
  elsif sequencer_enable = '1' or dataline_nxt = '1' then
    if frame_nxt'event and frame_nxt = '1' then
      frame_count_int <= std_logic_vector(unsigned(frame_count_int) + to_unsigned(1,frame_count_int'length)); 
    end if;
    
    if(slave_triggered_mode='0') then
      frame_valid <= '1';
    else
      if(frame_valid='0' and trigger_int='1') then
        frame_valid <= '1';
      --elsif(line_count = to_integer(unsigned(frame_length)) )then
      elsif(line_count = to_integer(unsigned(frame_length)) + roi_start )then
        frame_valid <= '0';
      else
        frame_valid <= frame_valid;  
      end if;  
    end if;
    
    
    case test_pattern_mode is 
      when "000" => --normal operation
        frame(0)    <= (others => X"EB5"); --Embedded dataline
        if ext_emb_data = '1' then
          for i in 0 to 347 loop
            frame(0)(i)(        11) <= swap_top_bottom;
            frame(0)(i)(        10) <= y_reversed;
            frame(0)(i)(         9) <= y_subsampling;
            frame(0)(i)(         8) <= x_subsampling;
            frame(0)(i)(         7) <= nested_readout;
            frame(0)(i)(6 downto 4) <= active_ctxt;
            frame(0)(i)(3 downto 0) <= "0101"; --Embedded dataline
          end loop;
        else
          for i in 0 to 347 loop
            frame(0)(i)(11 downto 7) <= "00000";
            frame(0)(i)( 6 downto 4) <= active_ctxt;
            frame(0)(i)( 3 downto 0) <= "0101"; --Embedded dataline
          end loop;
        end if;
        --for j in 0 to (G_PXL_ARRAY_COLUMNS/2)-1 loop
        --  frame(1)(2*j)   <= std_logic_vector(to_unsigned(line_count+2*j-2,12));
        --  frame(1)(2*j+1) <= std_logic_vector(to_unsigned(line_count+2*j-1,12));
        --  frame(2)(2*j)   <= std_logic_vector(to_unsigned(line_count+2*j  ,12));
        --  frame(2)(2*j+1) <= std_logic_vector(to_unsigned(line_count+2*j+1,12));    
        --end loop;      
        -- jmansill simple B&W ramp
        for j in 0 to (G_PXL_ARRAY_COLUMNS-1) loop
          --if(line_count>0) then
          if(line_count>roi_start) then
		    if(j<4) then                 --DUMMY
		      frame(1)(j) <= X"00D";
              frame(2)(j) <= X"00D"; 
			elsif(j<28) then             --Black REF  
		      frame(1)(j) <= X"000";
              frame(2)(j) <= X"000";
		    elsif(j<32) then             --DUMMY
		      frame(1)(j) <= X"00D";
              frame(2)(j) <= X"00D"; 			  
			elsif(j<4136) then           --Interpolation+valid
              frame(1)(j) <= std_logic_vector(to_unsigned(line_count-1+j,12));
              frame(2)(j) <= std_logic_vector(to_unsigned(line_count-1+j,12));  
			if(j<4140) then              --DUMMY
		      frame(1)(j) <= X"00D";
              frame(2)(j) <= X"00D"; 
			elsif(j<4172) then           --Black REF  
		      frame(1)(j) <= X"000";
              frame(2)(j) <= X"000";
		    elsif(j<4176) then           --DUMMY
		      frame(1)(j) <= X"00D";
              frame(2)(j) <= X"00D"; 		
          else
            frame(1)(j) <= X"EB5";
            frame(2)(j) <= X"EB5"; 
          end if;  
        end loop; 
        
        
      when "001" => --solid color
        frame(0)    <= (others => X"EB5"); --Embedded dataline
        if ext_emb_data = '1' then
          for i in 0 to 347 loop
            frame(0)(i)(        11) <= swap_top_bottom;
            frame(0)(i)(        10) <= y_reversed;
            frame(0)(i)(         9) <= y_subsampling;
            frame(0)(i)(         8) <= x_subsampling;
            frame(0)(i)(         7) <= nested_readout;
            frame(0)(i)(6 downto 4) <= (others => cmc_patgen_en);
            frame(0)(i)(3 downto 0) <= "0101"; --Embedded dataline
          end loop;
        else
          for i in 0 to 347 loop
            frame(0)(i)(11 downto 7) <= "00000";
            frame(0)(i)( 6 downto 4) <= (others => cmc_patgen_en);
            frame(0)(i)( 3 downto 0) <= "0101"; --Embedded dataline
          end loop;
        end if;
        var_test_data_red    := unsigned(test_data_red)   ;
        var_test_data_greenr := unsigned(test_data_greenr);
        var_test_data_blue   := unsigned(test_data_blue)  ;
        var_test_data_greenb := unsigned(test_data_greenb);    
        for j in 0 to (G_PXL_ARRAY_COLUMNS/2)-1 loop
          frame(1)(2*j)   <= std_logic_vector(var_test_data_red   (12 downto 1));
          frame(1)(2*j+1) <= std_logic_vector(var_test_data_greenr(12 downto 1));
          frame(2)(2*j)   <= std_logic_vector(var_test_data_greenb(12 downto 1));
          frame(2)(2*j+1) <= std_logic_vector(var_test_data_blue  (12 downto 1));    
        end loop; 
        
      when "010" => --color bar
        var_test_data_red(12 downto 1)    := X"FFF";  --white bar
        var_test_data_greenr(12 downto 1) := X"FFF";
        var_test_data_blue(12 downto 1)   := X"FFF";
        var_test_data_greenb(12 downto 1) := X"FFF";     
        for j in 0 to C_TP_COLUMN_SIZE-1 loop
          frame(1)(2*j)   <= std_logic_vector(var_test_data_red   (12 downto 1));
          frame(1)(2*j+1) <= std_logic_vector(var_test_data_greenr(12 downto 1));
          frame(2)(2*j)   <= std_logic_vector(var_test_data_greenb(12 downto 1));
          frame(2)(2*j+1) <= std_logic_vector(var_test_data_blue  (12 downto 1));    
        end loop;  
        var_test_data_red(12 downto 1)    := X"FFF"; --yellow bar
        var_test_data_greenr(12 downto 1) := X"FFF";
        var_test_data_blue(12 downto 1)   := X"001";
        var_test_data_greenb(12 downto 1) := X"FFF";     
        for j in C_TP_COLUMN_SIZE to 2*C_TP_COLUMN_SIZE-1 loop
          frame(1)(2*j)   <= std_logic_vector(var_test_data_red   (12 downto 1));
          frame(1)(2*j+1) <= std_logic_vector(var_test_data_greenr(12 downto 1));
          frame(2)(2*j)   <= std_logic_vector(var_test_data_greenb(12 downto 1));
          frame(2)(2*j+1) <= std_logic_vector(var_test_data_blue  (12 downto 1));    
        end loop;  
        var_test_data_red(12 downto 1)    := X"001"; --cyan bar
        var_test_data_greenr(12 downto 1) := X"FFF";
        var_test_data_blue(12 downto 1)   := X"FFF";
        var_test_data_greenb(12 downto 1) := X"FFF";     
        for j in 2*C_TP_COLUMN_SIZE to 3*C_TP_COLUMN_SIZE-1 loop
          frame(1)(2*j)   <= std_logic_vector(var_test_data_red   (12 downto 1));
          frame(1)(2*j+1) <= std_logic_vector(var_test_data_greenr(12 downto 1));
          frame(2)(2*j)   <= std_logic_vector(var_test_data_greenb(12 downto 1));
          frame(2)(2*j+1) <= std_logic_vector(var_test_data_blue  (12 downto 1));    
        end loop;  
        var_test_data_red(12 downto 1)    := X"001"; --green bar
        var_test_data_greenr(12 downto 1) := X"FFF";
        var_test_data_blue(12 downto 1)   := X"001";
        var_test_data_greenb(12 downto 1) := X"FFF";     
        for j in 3*C_TP_COLUMN_SIZE to 4*C_TP_COLUMN_SIZE-1 loop
          frame(1)(2*j)   <= std_logic_vector(var_test_data_red   (12 downto 1));
          frame(1)(2*j+1) <= std_logic_vector(var_test_data_greenr(12 downto 1));
          frame(2)(2*j)   <= std_logic_vector(var_test_data_greenb(12 downto 1));
          frame(2)(2*j+1) <= std_logic_vector(var_test_data_blue  (12 downto 1));    
        end loop;  
        var_test_data_red(12 downto 1)    := X"FFF"; --magenta bar
        var_test_data_greenr(12 downto 1) := X"001";
        var_test_data_blue(12 downto 1)   := X"FFF";
        var_test_data_greenb(12 downto 1) := X"001";     
        for j in 4*C_TP_COLUMN_SIZE to 5*C_TP_COLUMN_SIZE-1 loop
          frame(1)(2*j)   <= std_logic_vector(var_test_data_red   (12 downto 1));
          frame(1)(2*j+1) <= std_logic_vector(var_test_data_greenr(12 downto 1));
          frame(2)(2*j)   <= std_logic_vector(var_test_data_greenb(12 downto 1));
          frame(2)(2*j+1) <= std_logic_vector(var_test_data_blue  (12 downto 1));    
        end loop;  
        var_test_data_red(12 downto 1)    := X"FFF"; --red bar
        var_test_data_greenr(12 downto 1) := X"001";
        var_test_data_blue(12 downto 1)   := X"001";
        var_test_data_greenb(12 downto 1) := X"001";     
        for j in 5*C_TP_COLUMN_SIZE to 6*C_TP_COLUMN_SIZE-1 loop
          frame(1)(2*j)   <= std_logic_vector(var_test_data_red   (12 downto 1));
          frame(1)(2*j+1) <= std_logic_vector(var_test_data_greenr(12 downto 1));
          frame(2)(2*j)   <= std_logic_vector(var_test_data_greenb(12 downto 1));
          frame(2)(2*j+1) <= std_logic_vector(var_test_data_blue  (12 downto 1));    
        end loop;  
        var_test_data_red(12 downto 1)    := X"001"; --blue bar
        var_test_data_greenr(12 downto 1) := X"001";
        var_test_data_blue(12 downto 1)   := X"FFF";
        var_test_data_greenb(12 downto 1) := X"001";     
        for j in 6*C_TP_COLUMN_SIZE to 7*C_TP_COLUMN_SIZE-1 loop
          frame(1)(2*j)   <= std_logic_vector(var_test_data_red   (12 downto 1));
          frame(1)(2*j+1) <= std_logic_vector(var_test_data_greenr(12 downto 1));
          frame(2)(2*j)   <= std_logic_vector(var_test_data_greenb(12 downto 1));
          frame(2)(2*j+1) <= std_logic_vector(var_test_data_blue  (12 downto 1));    
        end loop;  
        var_test_data_red(12 downto 1)    := X"000"; --black bar
        var_test_data_greenr(12 downto 1) := X"000";
        var_test_data_blue(12 downto 1)   := X"000";
        var_test_data_greenb(12 downto 1) := X"000";     
        for j in 7*C_TP_COLUMN_SIZE to (G_PXL_ARRAY_COLUMNS/2)-1 loop
          frame(1)(2*j)   <= std_logic_vector(var_test_data_red   (12 downto 1));
          frame(1)(2*j+1) <= std_logic_vector(var_test_data_greenr(12 downto 1));
          frame(2)(2*j)   <= std_logic_vector(var_test_data_greenb(12 downto 1));
          frame(2)(2*j+1) <= std_logic_vector(var_test_data_blue  (12 downto 1));    
        end loop;  
      when "011" => --fade-to-gray
        if line_count <= 2 then
          var_line_nr := 0;
        else
          var_line_nr := ((line_count-1)/2) mod 1024;
        end if;
        if (var_line_nr = 0) then
          var_test_data_red(12 downto 1)    := X"FFF";  --white bar - part 1
          var_test_data_greenr(12 downto 1) := X"FFF";
          var_test_data_blue(12 downto 1)   := X"FFF";
          var_test_data_greenb(12 downto 1) := X"FFF";     
        else
          var_test_data_red(12 downto 1)    := to_unsigned(4096-2*var_line_nr,12);  --white bar - part 1
          var_test_data_greenr(12 downto 1) := to_unsigned(4096-2*var_line_nr,12);
          var_test_data_blue(12 downto 1)   := to_unsigned(4096-2*var_line_nr,12);
          var_test_data_greenb(12 downto 1) := to_unsigned(4096-2*var_line_nr,12);     
        end if;
        for j in 0 to C_TP_COLUMN_SIZE/2-1 loop
          frame(1)(2*j)   <= std_logic_vector(var_test_data_red   (12 downto 1));
          frame(1)(2*j+1) <= std_logic_vector(var_test_data_greenr(12 downto 1));
          frame(2)(2*j)   <= std_logic_vector(var_test_data_greenb(12 downto 1));
          frame(2)(2*j+1) <= std_logic_vector(var_test_data_blue  (12 downto 1));    
        end loop;  
        if (var_line_nr < 2) then
          var_test_data_red(12 downto 1)    := X"FFF";  --white bar - part 2
          var_test_data_greenr(12 downto 1) := X"FFF";
          var_test_data_blue(12 downto 1)   := X"FFF";
          var_test_data_greenb(12 downto 1) := X"FFF";     
        else
          var_test_data_red(12 downto 1)    := to_unsigned(4096-4*(var_line_nr/2)-(var_line_nr/128)+(var_line_nr/256),12);  --white bar - part 2
          var_test_data_greenr(12 downto 1) := to_unsigned(4096-4*(var_line_nr/2)-(var_line_nr/128)+(var_line_nr/256),12);
          var_test_data_blue(12 downto 1)   := to_unsigned(4096-4*(var_line_nr/2)-(var_line_nr/128)+(var_line_nr/256),12);
          var_test_data_greenb(12 downto 1) := to_unsigned(4096-4*(var_line_nr/2)-(var_line_nr/128)+(var_line_nr/256),12);     
        end if;
        for j in C_TP_COLUMN_SIZE/2 to C_TP_COLUMN_SIZE-1 loop
          frame(1)(2*j)   <= std_logic_vector(var_test_data_red   (12 downto 1));
          frame(1)(2*j+1) <= std_logic_vector(var_test_data_greenr(12 downto 1));
          frame(2)(2*j)   <= std_logic_vector(var_test_data_greenb(12 downto 1));
          frame(2)(2*j+1) <= std_logic_vector(var_test_data_blue  (12 downto 1));    
        end loop; 
 
        if var_line_nr = 0 then
          var_test_data_red(12 downto 1)    := X"FFF";  --yellow bar - part 1
          var_test_data_greenr(12 downto 1) := X"FFF";
          var_test_data_blue(12 downto 1)   := X"000";
          var_test_data_greenb(12 downto 1) := X"FFF";     
        else
          var_test_data_red(12 downto 1)    := to_unsigned(4096-2*var_line_nr,12); --yellow bar - part 1
          var_test_data_greenr(12 downto 1) := to_unsigned(4096-2*var_line_nr,12);
          var_test_data_blue(12 downto 1)   := to_unsigned(     2*var_line_nr,12);
          var_test_data_greenb(12 downto 1) := to_unsigned(4096-2*var_line_nr,12); 
        end if;
        for j in C_TP_COLUMN_SIZE to 3*C_TP_COLUMN_SIZE/2-1 loop
          frame(1)(2*j)   <= std_logic_vector(var_test_data_red   (12 downto 1));
          frame(1)(2*j+1) <= std_logic_vector(var_test_data_greenr(12 downto 1));
          frame(2)(2*j)   <= std_logic_vector(var_test_data_greenb(12 downto 1));
          frame(2)(2*j+1) <= std_logic_vector(var_test_data_blue  (12 downto 1));    
        end loop;  
        if (var_line_nr < 2) then
          var_test_data_red(12 downto 1)    := X"FFF";  --yellow bar bar - part 2
          var_test_data_greenr(12 downto 1) := X"FFF";
          var_test_data_blue(12 downto 1)   := X"000";
          var_test_data_greenb(12 downto 1) := X"FFF";     
        else
          var_test_data_red(12 downto 1)    := to_unsigned(4096-4*(var_line_nr/2)-(var_line_nr/128)+(var_line_nr/256),12); --yellow bar - part 2
          var_test_data_greenr(12 downto 1) := to_unsigned(4096-4*(var_line_nr/2)-(var_line_nr/128)+(var_line_nr/256),12);
          var_test_data_blue(12 downto 1)   := to_unsigned(     4*(var_line_nr/2)+(var_line_nr/128)-(var_line_nr/256),12);
          var_test_data_greenb(12 downto 1) := to_unsigned(4096-4*(var_line_nr/2)-(var_line_nr/128)+(var_line_nr/256),12); 
        end if;
        for j in 3*C_TP_COLUMN_SIZE/2 to 2*C_TP_COLUMN_SIZE-1 loop
          frame(1)(2*j)   <= std_logic_vector(var_test_data_red   (12 downto 1));
          frame(1)(2*j+1) <= std_logic_vector(var_test_data_greenr(12 downto 1));
          frame(2)(2*j)   <= std_logic_vector(var_test_data_greenb(12 downto 1));
          frame(2)(2*j+1) <= std_logic_vector(var_test_data_blue  (12 downto 1));    
        end loop;  

        if var_line_nr = 0 then
          var_test_data_red(12 downto 1)    := X"000"; --cyan bar - part 1
          var_test_data_greenr(12 downto 1) := X"FFF";
          var_test_data_blue(12 downto 1)   := X"FFF";
          var_test_data_greenb(12 downto 1) := X"FFF";     
        else
          var_test_data_red(12 downto 1)    := to_unsigned(     2*var_line_nr,12); --cyan bar - part 1
          var_test_data_greenr(12 downto 1) := to_unsigned(4096-2*var_line_nr,12);
          var_test_data_blue(12 downto 1)   := to_unsigned(4096-2*var_line_nr,12);
          var_test_data_greenb(12 downto 1) := to_unsigned(4096-2*var_line_nr,12); 
        end if;
        for j in 2*C_TP_COLUMN_SIZE to 5*C_TP_COLUMN_SIZE/2-1 loop
          frame(1)(2*j)   <= std_logic_vector(var_test_data_red   (12 downto 1));
          frame(1)(2*j+1) <= std_logic_vector(var_test_data_greenr(12 downto 1));
          frame(2)(2*j)   <= std_logic_vector(var_test_data_greenb(12 downto 1));
          frame(2)(2*j+1) <= std_logic_vector(var_test_data_blue  (12 downto 1));    
        end loop;  
        if (var_line_nr < 2) then
          var_test_data_red(12 downto 1)    := X"000";  --cyan bar - part 2
          var_test_data_greenr(12 downto 1) := X"FFF";
          var_test_data_blue(12 downto 1)   := X"FFF";
          var_test_data_greenb(12 downto 1) := X"FFF";     
        else
          var_test_data_red(12 downto 1)    := to_unsigned(     4*(var_line_nr/2)+(var_line_nr/128)-(var_line_nr/256),12); --cyan bar - part 2
          var_test_data_greenr(12 downto 1) := to_unsigned(4096-4*(var_line_nr/2)-(var_line_nr/128)+(var_line_nr/256),12);
          var_test_data_blue(12 downto 1)   := to_unsigned(4096-4*(var_line_nr/2)-(var_line_nr/128)+(var_line_nr/256),12);
          var_test_data_greenb(12 downto 1) := to_unsigned(4096-4*(var_line_nr/2)-(var_line_nr/128)+(var_line_nr/256),12); 
        end if;
        for j in 5*C_TP_COLUMN_SIZE/2 to 3*C_TP_COLUMN_SIZE-1 loop
          frame(1)(2*j)   <= std_logic_vector(var_test_data_red   (12 downto 1));
          frame(1)(2*j+1) <= std_logic_vector(var_test_data_greenr(12 downto 1));
          frame(2)(2*j)   <= std_logic_vector(var_test_data_greenb(12 downto 1));
          frame(2)(2*j+1) <= std_logic_vector(var_test_data_blue  (12 downto 1));    
        end loop;  

        if var_line_nr = 0 then
          var_test_data_red(12 downto 1)    := X"000"; --green bar - part 1
          var_test_data_greenr(12 downto 1) := X"FFF";
          var_test_data_blue(12 downto 1)   := X"000";
          var_test_data_greenb(12 downto 1) := X"FFF";     
        else
          var_test_data_red(12 downto 1)    := to_unsigned(     2*var_line_nr,12); --green bar - part 1
          var_test_data_greenr(12 downto 1) := to_unsigned(4096-2*var_line_nr,12);
          var_test_data_blue(12 downto 1)   := to_unsigned(     2*var_line_nr,12);
          var_test_data_greenb(12 downto 1) := to_unsigned(4096-2*var_line_nr,12); 
        end if;
        for j in 3*C_TP_COLUMN_SIZE to 7*C_TP_COLUMN_SIZE/2-1 loop
          frame(1)(2*j)   <= std_logic_vector(var_test_data_red   (12 downto 1));
          frame(1)(2*j+1) <= std_logic_vector(var_test_data_greenr(12 downto 1));
          frame(2)(2*j)   <= std_logic_vector(var_test_data_greenb(12 downto 1));
          frame(2)(2*j+1) <= std_logic_vector(var_test_data_blue  (12 downto 1));    
        end loop;  
        if (var_line_nr < 2) then
          var_test_data_red(12 downto 1)    := X"000";  --green bar - part 2
          var_test_data_greenr(12 downto 1) := X"FFF";
          var_test_data_blue(12 downto 1)   := X"000";
          var_test_data_greenb(12 downto 1) := X"FFF";     
        else
          var_test_data_red(12 downto 1)    := to_unsigned(     4*(var_line_nr/2)+(var_line_nr/128)-(var_line_nr/256),12); --green bar - part 2
          var_test_data_greenr(12 downto 1) := to_unsigned(4096-4*(var_line_nr/2)-(var_line_nr/128)+(var_line_nr/256),12);
          var_test_data_blue(12 downto 1)   := to_unsigned(     4*(var_line_nr/2)+(var_line_nr/128)-(var_line_nr/256),12);
          var_test_data_greenb(12 downto 1) := to_unsigned(4096-4*(var_line_nr/2)-(var_line_nr/128)+(var_line_nr/256),12); 
        end if;
        for j in 7*C_TP_COLUMN_SIZE/2 to 4*C_TP_COLUMN_SIZE-1 loop
          frame(1)(2*j)   <= std_logic_vector(var_test_data_red   (12 downto 1));
          frame(1)(2*j+1) <= std_logic_vector(var_test_data_greenr(12 downto 1));
          frame(2)(2*j)   <= std_logic_vector(var_test_data_greenb(12 downto 1));
          frame(2)(2*j+1) <= std_logic_vector(var_test_data_blue  (12 downto 1));    
        end loop;  

        if var_line_nr = 0 then
          var_test_data_red(12 downto 1)    := X"FFF"; --magenta bar - part 1
          var_test_data_greenr(12 downto 1) := X"000";
          var_test_data_blue(12 downto 1)   := X"FFF";
          var_test_data_greenb(12 downto 1) := X"000";     
        else
          var_test_data_red(12 downto 1)    := to_unsigned(4096-2*var_line_nr,12); --magenta bar - part 1
          var_test_data_greenr(12 downto 1) := to_unsigned(     2*var_line_nr,12);
          var_test_data_blue(12 downto 1)   := to_unsigned(4096-2*var_line_nr,12);
          var_test_data_greenb(12 downto 1) := to_unsigned(     2*var_line_nr,12); 
        end if;
        for j in 4*C_TP_COLUMN_SIZE to 9*C_TP_COLUMN_SIZE/2-1 loop
          frame(1)(2*j)   <= std_logic_vector(var_test_data_red   (12 downto 1));
          frame(1)(2*j+1) <= std_logic_vector(var_test_data_greenr(12 downto 1));
          frame(2)(2*j)   <= std_logic_vector(var_test_data_greenb(12 downto 1));
          frame(2)(2*j+1) <= std_logic_vector(var_test_data_blue  (12 downto 1));    
        end loop;  
        if (var_line_nr < 2) then
          var_test_data_red(12 downto 1)    := X"FFF";  --magenta bar - part 2
          var_test_data_greenr(12 downto 1) := X"000";
          var_test_data_blue(12 downto 1)   := X"FFF";
          var_test_data_greenb(12 downto 1) := X"000";     
        else
          var_test_data_red(12 downto 1)    := to_unsigned(4096-4*(var_line_nr/2)-(var_line_nr/128)+(var_line_nr/256),12); --magenta bar - part 2
          var_test_data_greenr(12 downto 1) := to_unsigned(     4*(var_line_nr/2)+(var_line_nr/128)-(var_line_nr/256),12);
          var_test_data_blue(12 downto 1)   := to_unsigned(4096-4*(var_line_nr/2)-(var_line_nr/128)+(var_line_nr/256),12);
          var_test_data_greenb(12 downto 1) := to_unsigned(     4*(var_line_nr/2)+(var_line_nr/128)-(var_line_nr/256),12); 
        end if;
        for j in 9*C_TP_COLUMN_SIZE/2 to 5*C_TP_COLUMN_SIZE-1 loop
          frame(1)(2*j)   <= std_logic_vector(var_test_data_red   (12 downto 1));
          frame(1)(2*j+1) <= std_logic_vector(var_test_data_greenr(12 downto 1));
          frame(2)(2*j)   <= std_logic_vector(var_test_data_greenb(12 downto 1));
          frame(2)(2*j+1) <= std_logic_vector(var_test_data_blue  (12 downto 1));    
        end loop;  

        if var_line_nr = 0 then
          var_test_data_red(12 downto 1)    := X"FFF"; --red bar - part 1
          var_test_data_greenr(12 downto 1) := X"000";
          var_test_data_blue(12 downto 1)   := X"000";
          var_test_data_greenb(12 downto 1) := X"000";     
        else
          var_test_data_red(12 downto 1)    := to_unsigned(4096-2*var_line_nr,12); --red bar - part 1
          var_test_data_greenr(12 downto 1) := to_unsigned(     2*var_line_nr,12);
          var_test_data_blue(12 downto 1)   := to_unsigned(     2*var_line_nr,12);
          var_test_data_greenb(12 downto 1) := to_unsigned(     2*var_line_nr,12); 
        end if;
        for j in 5*C_TP_COLUMN_SIZE to 11*C_TP_COLUMN_SIZE/2-1 loop
          frame(1)(2*j)   <= std_logic_vector(var_test_data_red   (12 downto 1));
          frame(1)(2*j+1) <= std_logic_vector(var_test_data_greenr(12 downto 1));
          frame(2)(2*j)   <= std_logic_vector(var_test_data_greenb(12 downto 1));
          frame(2)(2*j+1) <= std_logic_vector(var_test_data_blue  (12 downto 1));    
        end loop;  
        if (var_line_nr < 2) then
          var_test_data_red(12 downto 1)    := X"FFF";  --red bar - part 2
          var_test_data_greenr(12 downto 1) := X"000";
          var_test_data_blue(12 downto 1)   := X"000";
          var_test_data_greenb(12 downto 1) := X"000";     
        else
          var_test_data_red(12 downto 1)    := to_unsigned(4096-4*(var_line_nr/2)-(var_line_nr/128)+(var_line_nr/256),12); --red bar - part 2
          var_test_data_greenr(12 downto 1) := to_unsigned(     4*(var_line_nr/2)+(var_line_nr/128)-(var_line_nr/256),12);
          var_test_data_blue(12 downto 1)   := to_unsigned(     4*(var_line_nr/2)+(var_line_nr/128)-(var_line_nr/256),12);
          var_test_data_greenb(12 downto 1) := to_unsigned(     4*(var_line_nr/2)+(var_line_nr/128)-(var_line_nr/256),12); 
        end if;
        for j in 11*C_TP_COLUMN_SIZE/2 to 6*C_TP_COLUMN_SIZE-1 loop
          frame(1)(2*j)   <= std_logic_vector(var_test_data_red   (12 downto 1));
          frame(1)(2*j+1) <= std_logic_vector(var_test_data_greenr(12 downto 1));
          frame(2)(2*j)   <= std_logic_vector(var_test_data_greenb(12 downto 1));
          frame(2)(2*j+1) <= std_logic_vector(var_test_data_blue  (12 downto 1));    
        end loop;  

        if var_line_nr = 0 then
          var_test_data_red(12 downto 1)    := X"000"; --blue bar - part 1
          var_test_data_greenr(12 downto 1) := X"000";
          var_test_data_blue(12 downto 1)   := X"FFF";
          var_test_data_greenb(12 downto 1) := X"000";     
        else
          var_test_data_red(12 downto 1)    := to_unsigned(     2*var_line_nr,12); --blue bar - part 1
          var_test_data_greenr(12 downto 1) := to_unsigned(     2*var_line_nr,12);
          var_test_data_blue(12 downto 1)   := to_unsigned(4096-2*var_line_nr,12);
          var_test_data_greenb(12 downto 1) := to_unsigned(     2*var_line_nr,12); 
        end if;
        for j in 6*C_TP_COLUMN_SIZE to 13*C_TP_COLUMN_SIZE/2-1 loop
          frame(1)(2*j)   <= std_logic_vector(var_test_data_red   (12 downto 1));
          frame(1)(2*j+1) <= std_logic_vector(var_test_data_greenr(12 downto 1));
          frame(2)(2*j)   <= std_logic_vector(var_test_data_greenb(12 downto 1));
          frame(2)(2*j+1) <= std_logic_vector(var_test_data_blue  (12 downto 1));    
        end loop;  
        if (var_line_nr < 2) then
          var_test_data_red(12 downto 1)    := X"000";  --blue bar - part 2
          var_test_data_greenr(12 downto 1) := X"000";
          var_test_data_blue(12 downto 1)   := X"FFF";
          var_test_data_greenb(12 downto 1) := X"000";     
        else
          var_test_data_red(12 downto 1)    := to_unsigned(     4*(var_line_nr/2)+(var_line_nr/128)-(var_line_nr/256),12); --blue bar - part 2
          var_test_data_greenr(12 downto 1) := to_unsigned(     4*(var_line_nr/2)+(var_line_nr/128)-(var_line_nr/256),12);
          var_test_data_blue(12 downto 1)   := to_unsigned(4096-4*(var_line_nr/2)-(var_line_nr/128)+(var_line_nr/256),12);
          var_test_data_greenb(12 downto 1) := to_unsigned(     4*(var_line_nr/2)+(var_line_nr/128)-(var_line_nr/256),12); 
        end if;
        for j in 13*C_TP_COLUMN_SIZE/2 to 7*C_TP_COLUMN_SIZE-1 loop
          frame(1)(2*j)   <= std_logic_vector(var_test_data_red   (12 downto 1));
          frame(1)(2*j+1) <= std_logic_vector(var_test_data_greenr(12 downto 1));
          frame(2)(2*j)   <= std_logic_vector(var_test_data_greenb(12 downto 1));
          frame(2)(2*j+1) <= std_logic_vector(var_test_data_blue  (12 downto 1));    
        end loop;  

        if var_line_nr = 0 then
          var_test_data_red(12 downto 1)    := X"000"; --black bar - part 1
          var_test_data_greenr(12 downto 1) := X"000";
          var_test_data_blue(12 downto 1)   := X"000";
          var_test_data_greenb(12 downto 1) := X"000";     
        else
          var_test_data_red(12 downto 1)    := to_unsigned(     2*var_line_nr,12); --black bar - part 1
          var_test_data_greenr(12 downto 1) := to_unsigned(     2*var_line_nr,12);
          var_test_data_blue(12 downto 1)   := to_unsigned(     2*var_line_nr,12);
          var_test_data_greenb(12 downto 1) := to_unsigned(     2*var_line_nr,12); 
        end if;
        for j in 7*C_TP_COLUMN_SIZE to 15*C_TP_COLUMN_SIZE/2-1 loop
          frame(1)(2*j)   <= std_logic_vector(var_test_data_red   (12 downto 1));
          frame(1)(2*j+1) <= std_logic_vector(var_test_data_greenr(12 downto 1));
          frame(2)(2*j)   <= std_logic_vector(var_test_data_greenb(12 downto 1));
          frame(2)(2*j+1) <= std_logic_vector(var_test_data_blue  (12 downto 1));    
        end loop;  
        for j in 8*C_TP_COLUMN_SIZE to 17*C_TP_COLUMN_SIZE/2-1 loop
          frame(1)(2*j)   <= std_logic_vector(var_test_data_red   (12 downto 1));
          frame(1)(2*j+1) <= std_logic_vector(var_test_data_greenr(12 downto 1));
          frame(2)(2*j)   <= std_logic_vector(var_test_data_greenb(12 downto 1));
          frame(2)(2*j+1) <= std_logic_vector(var_test_data_blue  (12 downto 1));    
        end loop;  
        for j in 9*C_TP_COLUMN_SIZE to 19*C_TP_COLUMN_SIZE/2-1 loop
          frame(1)(2*j)   <= std_logic_vector(var_test_data_red   (12 downto 1));
          frame(1)(2*j+1) <= std_logic_vector(var_test_data_greenr(12 downto 1));
          frame(2)(2*j)   <= std_logic_vector(var_test_data_greenb(12 downto 1));
          frame(2)(2*j+1) <= std_logic_vector(var_test_data_blue  (12 downto 1));    
        end loop;  
        for j in 10*C_TP_COLUMN_SIZE to 21*C_TP_COLUMN_SIZE/2-1 loop
          frame(1)(2*j)   <= std_logic_vector(var_test_data_red   (12 downto 1));
          frame(1)(2*j+1) <= std_logic_vector(var_test_data_greenr(12 downto 1));
          frame(2)(2*j)   <= std_logic_vector(var_test_data_greenb(12 downto 1));
          frame(2)(2*j+1) <= std_logic_vector(var_test_data_blue  (12 downto 1));    
        end loop;  
        for j in 11*C_TP_COLUMN_SIZE to 23*C_TP_COLUMN_SIZE/2-1 loop
          frame(1)(2*j)   <= std_logic_vector(var_test_data_red   (12 downto 1));
          frame(1)(2*j+1) <= std_logic_vector(var_test_data_greenr(12 downto 1));
          frame(2)(2*j)   <= std_logic_vector(var_test_data_greenb(12 downto 1));
          frame(2)(2*j+1) <= std_logic_vector(var_test_data_blue  (12 downto 1));    
        end loop;  
        if (var_line_nr < 2) then
          var_test_data_red(12 downto 1)    := X"000";  --black bar - part 2
          var_test_data_greenr(12 downto 1) := X"000";
          var_test_data_blue(12 downto 1)   := X"000";
          var_test_data_greenb(12 downto 1) := X"000";     
        else
          var_test_data_red(12 downto 1)    := to_unsigned(     4*(var_line_nr/2)+(var_line_nr/128)-(var_line_nr/256),12); --black bar - part 2
          var_test_data_greenr(12 downto 1) := to_unsigned(     4*(var_line_nr/2)+(var_line_nr/128)-(var_line_nr/256),12);
          var_test_data_blue(12 downto 1)   := to_unsigned(     4*(var_line_nr/2)+(var_line_nr/128)-(var_line_nr/256),12);
          var_test_data_greenb(12 downto 1) := to_unsigned(     4*(var_line_nr/2)+(var_line_nr/128)-(var_line_nr/256),12); 
        end if;
        for j in 15*C_TP_COLUMN_SIZE/2 to 8*C_TP_COLUMN_SIZE-1 loop
          frame(1)(2*j)   <= std_logic_vector(var_test_data_red   (12 downto 1));
          frame(1)(2*j+1) <= std_logic_vector(var_test_data_greenr(12 downto 1));
          frame(2)(2*j)   <= std_logic_vector(var_test_data_greenb(12 downto 1));
          frame(2)(2*j+1) <= std_logic_vector(var_test_data_blue  (12 downto 1));    
        end loop;  
        for j in 17*C_TP_COLUMN_SIZE/2 to 9*C_TP_COLUMN_SIZE-1 loop
          frame(1)(2*j)   <= std_logic_vector(var_test_data_red   (12 downto 1));
          frame(1)(2*j+1) <= std_logic_vector(var_test_data_greenr(12 downto 1));
          frame(2)(2*j)   <= std_logic_vector(var_test_data_greenb(12 downto 1));
          frame(2)(2*j+1) <= std_logic_vector(var_test_data_blue  (12 downto 1));    
        end loop;  
        for j in 19*C_TP_COLUMN_SIZE/2 to 10*C_TP_COLUMN_SIZE-1 loop
          frame(1)(2*j)   <= std_logic_vector(var_test_data_red   (12 downto 1));
          frame(1)(2*j+1) <= std_logic_vector(var_test_data_greenr(12 downto 1));
          frame(2)(2*j)   <= std_logic_vector(var_test_data_greenb(12 downto 1));
          frame(2)(2*j+1) <= std_logic_vector(var_test_data_blue  (12 downto 1));    
        end loop;  
        for j in 21*C_TP_COLUMN_SIZE/2 to 11*C_TP_COLUMN_SIZE-1 loop
          frame(1)(2*j)   <= std_logic_vector(var_test_data_red   (12 downto 1));
          frame(1)(2*j+1) <= std_logic_vector(var_test_data_greenr(12 downto 1));
          frame(2)(2*j)   <= std_logic_vector(var_test_data_greenb(12 downto 1));
          frame(2)(2*j+1) <= std_logic_vector(var_test_data_blue  (12 downto 1));    
        end loop;  
        for j in 23*C_TP_COLUMN_SIZE/2 to (G_PXL_ARRAY_COLUMNS/2)-1 loop
          frame(1)(2*j)   <= std_logic_vector(var_test_data_red   (12 downto 1));
          frame(1)(2*j+1) <= std_logic_vector(var_test_data_greenr(12 downto 1));
          frame(2)(2*j)   <= std_logic_vector(var_test_data_greenb(12 downto 1));
          frame(2)(2*j+1) <= std_logic_vector(var_test_data_blue  (12 downto 1));    
        end loop;  
          
      when "100" => --diagonal gray 1x
        for j in 0 to G_PXL_ARRAY_COLUMNS-1 loop
          var_pixel_value := to_unsigned(((line_count+j)/2),16);
          if (line_count mod 2 = 0) then
            frame(2)(j) <= std_logic_vector(var_pixel_value(11 downto 0));
          else
            frame(1)(j) <= std_logic_vector(var_pixel_value(11 downto 0));
          end if;
        end loop;
      when "101" => --diagonal gray 3x
        if line_count /= 0 then
          for j in 0 to G_PXL_ARRAY_COLUMNS-1 loop
            var_pixel_value := to_unsigned((3*(line_count+j-1)+1)/2,16);
            if (line_count mod 2 = 0) then
              frame(2)(j) <= std_logic_vector(var_pixel_value(11 downto 0));
            else
              frame(1)(j) <= std_logic_vector(var_pixel_value(11 downto 0));
            end if;
          end loop;
        end if;
      when "110" => --white/black bar (Coarse)
        for j in 0 to G_NUM_PHY-1 loop
          for k in 0 to 2*G_PXL_PER_COLRAM-1 loop
            frame(1)( 2*j   *2*G_PXL_PER_COLRAM+k) <= (others => '1');
            frame(1)((2*j+1)*2*G_PXL_PER_COLRAM+k) <= (others => '0');
            frame(2)( 2*j   *2*G_PXL_PER_COLRAM+k) <= (others => '1');
            frame(2)((2*j+1)*2*G_PXL_PER_COLRAM+k) <= (others => '0');
          end loop;
        end loop;
      when others => --white/black bar (Fine)
        var_test_data_red(12 downto 8) := "00000";
        var_test_data_red( 7 downto 0) := unsigned(test_data_red(7 downto 0));
        var_test_data_greenr(12 downto 8) := "00000";
        var_test_data_greenr( 7 downto 0) := unsigned(test_data_greenr(7 downto 0));
        for j in 0 to 2*G_NUM_PHY-1 loop
          for k in 0 to G_PXL_PER_COLRAM-1 loop
            if k >= to_integer(var_test_data_greenr) then
              frame(1)(j*2*G_PXL_PER_COLRAM+2*k) <= (others => '0');
              frame(2)(j*2*G_PXL_PER_COLRAM+2*k) <= (others => '0');
            else
              frame(1)(j*2*G_PXL_PER_COLRAM+2*k) <= (others => '1'); 
              frame(2)(j*2*G_PXL_PER_COLRAM+2*k) <= (others => '1'); 
            end if;              
            if k >= to_integer(var_test_data_red) then
              frame(1)(j*2*G_PXL_PER_COLRAM+2*k+1) <= (others => '0');
              frame(2)(j*2*G_PXL_PER_COLRAM+2*k+1) <= (others => '0');
            else
              frame(1)(j*2*G_PXL_PER_COLRAM+2*k+1) <= (others => '1'); 
              frame(2)(j*2*G_PXL_PER_COLRAM+2*k+1) <= (others => '1'); 
            end if;              
          end loop;
        end loop;
    end case;
      
  end if;
end process FRAME_CONTENT;

LINE_COUNT_PROC : process(dataline_nxt, frame_valid)
begin
  frame_nxt <= '0';
  if frame_valid = '0' then
    --line_count     <= 0;
    line_count     <= roi_start;
    
  --jmansill
  elsif(slave_triggered_mode='1' and dataline_nxt='1') then 
    --if line_count = to_integer(unsigned(frame_length)) then
    if line_count = to_integer(unsigned(frame_length) + roi_start) then
      frame_nxt  <= '0';
      line_count <= 0;  --ici on va rester a length+1
    else      
      line_count <= line_count + 1;
    end if;
    
  elsif(slave_triggered_mode='0' and  dataline_nxt = '1') then
    --if line_count = to_integer(unsigned(frame_length)) then
    if line_count = to_integer(unsigned(frame_length) + roi_start) then
      frame_nxt  <= '1';
      line_count <= 0;
    else      
      line_count <= line_count + 1;
    end if;
  end if;
   
end process LINE_COUNT_PROC;

--emb_data       <= '1' when (line_count = 0) else '0';
--first_line     <= '1' when line_count = 0 else '0'; 
--last_line      <= '1' when line_count = roi_size else '0'; 
--dataline_valid <= '1' when frame_valid = '1' and line_count <= roi_size else '0';


emb_data       <= '1' when (line_count = roi_start) else '0';
first_line     <= '1' when line_count = roi_start else '0'; 
last_line      <= '1' when line_count = roi_start+roi_size else '0'; 
dataline_valid <= '1' when frame_valid = '1' and line_count <= (roi_start+roi_size) else '0';



DATA_REORDER : process(line_count, frame)
begin
  --order data lines according to data sent on HiSPi data lanes as specified by the silicon.
  for j in 0 to 2*G_NUM_PHY-1 loop
    for i in 0 to G_PXL_PER_COLRAM-1 loop
      --if line_count = 0 then
      if line_count = roi_start then       
       case frame(0)(2*j*G_PXL_PER_COLRAM+2*i+1) is 
          when X"000" => dataline(2*j*G_PXL_PER_COLRAM+G_PXL_PER_COLRAM+i) <= X"000";--X"001";   -- il y a t'il une raison pq le pixel0 est converti a 1 ici?????
          when others => dataline(2*j*G_PXL_PER_COLRAM+G_PXL_PER_COLRAM+i) <= frame(0)(2*j*G_PXL_PER_COLRAM+2*i+1);
        end case;
        case frame(0)(2*j*G_PXL_PER_COLRAM+2*i) is 
          when X"000" => dataline(2*j*G_PXL_PER_COLRAM                 +i) <= X"000";--X"001";
          when others => dataline(2*j*G_PXL_PER_COLRAM                 +i) <= frame(0)(2*j*G_PXL_PER_COLRAM+2*i); 
        end case;        
      elsif (line_count mod 2 = 0) then
        case frame(2)(2*j*G_PXL_PER_COLRAM+2*i+1) is 
          when X"000" => dataline(2*j*G_PXL_PER_COLRAM+G_PXL_PER_COLRAM+i) <= X"000";--X"001";
          when others => dataline(2*j*G_PXL_PER_COLRAM+G_PXL_PER_COLRAM+i) <= frame(2)(2*j*G_PXL_PER_COLRAM+2*i+1);
        end case;
        case frame(2)(2*j*G_PXL_PER_COLRAM+2*i) is 
          when X"000" => dataline(2*j*G_PXL_PER_COLRAM                 +i) <= X"000";--X"001";
          when others => dataline(2*j*G_PXL_PER_COLRAM                 +i) <= frame(2)(2*j*G_PXL_PER_COLRAM+2*i); 
        end case;        
      else
        case frame(1)(2*j*G_PXL_PER_COLRAM+2*i+1) is 
          when X"000" => dataline(2*j*G_PXL_PER_COLRAM                 +i) <= X"000";--X"001";
          when others => dataline(2*j*G_PXL_PER_COLRAM                 +i) <= frame(1)(2*j*G_PXL_PER_COLRAM+2*i+1);
        end case;
        case frame(1)(2*j*G_PXL_PER_COLRAM+2*i) is 
          when X"000" => dataline(2*j*G_PXL_PER_COLRAM+G_PXL_PER_COLRAM+i) <= X"000";--X"001";
          when others => dataline(2*j*G_PXL_PER_COLRAM+G_PXL_PER_COLRAM+i) <= frame(1)(2*j*G_PXL_PER_COLRAM+2*i); 
        end case;        
      end if;
    end loop;
  end loop;
end process DATA_REORDER;

DEBUG_PROC : process(frame)
begin
  for i in 0 to 31 loop
    debug_frame_line0(i) <= frame(0)(i);
    debug_frame_line1(i) <= frame(1)(i);
    debug_frame_line2(i) <= frame(2)(i);
  end loop;
end process DEBUG_PROC;

end behaviour;
