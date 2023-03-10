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
use ieee.math_real.all;
use IEEE.std_logic_textio.all;  

library std;
use std.textio.all;
 
library work;
use work.xgs_model_pkg.all;

entity xgs_image is
  generic(
          G_xgs_image_file_dec      : string;
          G_xgs_image_file_hex12    : string;
          G_xgs_image_file_hex8     : string;
  
          G_XGS45M           : integer := 0;
          G_NUM_PHY          : integer := 6;
          G_PXL_ARRAY_ROWS   : integer := 3100;
          G_PXL_PER_COLRAM   : integer := 174
          );
  port(
       xgs_model_GenImage  : in std_logic:='0'; 
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
       x_subsampling       : in  std_logic:='0';
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
--Frame(1) = Now is all data mono/color
type t_frame_type is array(0 to 1) of t_dataline(0 to G_PXL_ARRAY_COLUMNS-1);
signal frame           : t_frame_type;
signal frame_nxt       : std_logic;
signal frame_valid     : std_logic;
signal line_count      : integer range 0 to 2**16-1;
signal line_count_out_mux      : integer range 0 to 2**16-1;
signal frame_count_int : std_logic_vector(7 downto 0);
type t_debug_frame_line is array(0 to 31) of std_logic_vector(11 downto 0);
signal debug_frame_line0: t_debug_frame_line;
signal debug_frame_line1: t_debug_frame_line;
signal debug_frame_line2: t_debug_frame_line;

type XGS_image_array is array (0 to G_PXL_ARRAY_ROWS, 0 to G_PXL_ARRAY_COLUMNS) of integer range 0 to 4095;
--signal XGS_image : XGS_image_array;

begin

frame_count <= frame_count_int;



--
-- Deplace le contenu de Create_XGS_Image ici pour etre en mesure d'utiliser une variable aulieu d'un signal pour l'image
-- Ca prends moins de memoire ds modelsim et ca crash pas avec les 3 modeles
--
--Frame generation based on mode setting
FRAME_CONTENT : process(xgs_model_GenImage, trigger_int, dataline_nxt, sequencer_enable, frame_nxt) --jmansill : Oue... pas fort pas mettre c signal dans la liste de sensibilite (gracieusite de onsemi)...
  
  variable XGS_image : XGS_image_array;
  variable seed1, seed2 : integer := 69;
  variable random1              : integer;

  -- Random generator --jmansill
  impure function rand_int(min_val, max_val : integer) return integer is
    variable r : real;
  begin
    uniform(seed1, seed2, r);
    return integer(
      round(r * real(max_val - min_val + 1) + real(min_val) - 0.5));
  end function;

  file xgs_image_file_dec      : text open write_mode is G_xgs_image_file_dec;  --"XGS_image_dec.pgm";
  file xgs_image_file_hex12    : text open write_mode is G_xgs_image_file_hex12;--"XGS_image_hex12.pgm";
  file xgs_image_file_hex8     : text open write_mode is G_xgs_image_file_hex8; --"XGS_image_hex8.pgm";

  variable hex_value        : std_logic_vector(11 downto 0); 
  variable row_dec          : line;
  variable row_hex12        : line;
  variable row_hex8         : line;

  variable P_LEFT_DUMMY_0   : integer;
  variable P_LEFT_BLACKREF  : integer;
  variable P_LEFT_DUMMY_1   : integer;
  variable P_INTERPOLATION1  : integer;
  variable P_ROI_WIDTH      : integer;
  variable P_INTERPOLATION2  : integer;
  variable P_RIGHT_DUMMY_0  : integer;
  variable P_RIGHT_BLACKREF : integer;
  variable P_RIGHT_DUMMY_1  : integer;
  
  variable P_TOTAL  : integer;
  --variable P_X_START        : integer;
  --variable P_X_END          : integer;

  begin
    if(rising_edge(xgs_model_GenImage)) then    
		
		
	  if(G_xgs_image_file_hex12="XGS_image_5000_hex12.pgm") then
		  P_LEFT_DUMMY_0   :=  50;
		  P_LEFT_BLACKREF  :=  34;
		  P_LEFT_DUMMY_1   :=  4;
      	  P_INTERPOLATION1 :=  4;
		  P_ROI_WIDTH      :=  2592;
		  P_INTERPOLATION2 :=  4;
		  P_RIGHT_DUMMY_0  :=  4;
		  P_RIGHT_BLACKREF :=  42;
		  P_RIGHT_DUMMY_1  :=  50;
	  elsif(G_xgs_image_file_hex12="XGS_image_12000_hex12.pgm") then	  
		  P_LEFT_DUMMY_0   :=  4;
		  P_LEFT_BLACKREF  :=  24;
		  P_LEFT_DUMMY_1   :=  4;
      	  P_INTERPOLATION1 :=  4;		  
		  P_ROI_WIDTH      :=  4096;
      	  P_INTERPOLATION2 :=  4;		  
		  P_RIGHT_DUMMY_0  :=  4;
		  P_RIGHT_BLACKREF :=  24;
		  P_RIGHT_DUMMY_1  :=  4;   

         P_TOTAL           := P_LEFT_DUMMY_0+P_LEFT_BLACKREF+P_LEFT_DUMMY_1+P_INTERPOLATION1+P_ROI_WIDTH+P_INTERPOLATION2 + P_RIGHT_DUMMY_0 + P_RIGHT_BLACKREF + P_RIGHT_DUMMY_1 ;
          --P_X_START        := P_LEFT_DUMMY_0+P_LEFT_BLACKREF+P_LEFT_DUMMY_1;		  
          --P_X_END          := P_LEFT_DUMMY_0+P_LEFT_BLACKREF+P_LEFT_DUMMY_1+P_INTERPOLATION1+P_ROI_WIDTH+P_INTERPOLATION2;		  
		  --P_X_VALID        := P_INTERPOLATION1 + P_ROI_WIDTH + P_INTERPOLATION2;   
		  
	  elsif(G_xgs_image_file_hex12="XGS_image_16000_hex12.pgm") then
		  P_LEFT_DUMMY_0   :=  4;
		  P_LEFT_BLACKREF  :=  24;
		  P_LEFT_DUMMY_1   :=  52;
      	  P_INTERPOLATION1 :=  4;
		  P_ROI_WIDTH      :=  4000;
      	  P_INTERPOLATION2 :=  4;
		  P_RIGHT_DUMMY_0  :=  52;
		  P_RIGHT_BLACKREF :=  32;
		  P_RIGHT_DUMMY_1  :=  4;    
	  end if;	  
		
	  if(test_pattern_mode="000") then
	    report "Starting XGS image generation, Image is random 12bpp.";
	  elsif(test_pattern_mode="001") then
	    report "Starting XGS image generation, Image is ramp 12bpp.";
	  else
	  	report "Starting XGS image generation, Image is ramp 8bpp (8 MSB of 12bpp, +16 increments).";
	  end if;
	  
	  -- Entete .pgm
	  write(row_hex12, string'("P2"));
	  writeline(xgs_image_file_hex12, row_hex12);
      write(row_hex12, G_PXL_ARRAY_COLUMNS);
	  write(row_hex12, ' ');
	  write(row_hex12, G_PXL_ARRAY_ROWS);
	  writeline(xgs_image_file_hex12, row_hex12);
	  write(row_hex12, string'("4095"));
	  writeline(xgs_image_file_hex12, row_hex12);
	  
	  write(row_hex8, string'("P2"));
	  writeline(xgs_image_file_hex8, row_hex8);
      write(row_hex8, G_PXL_ARRAY_COLUMNS);
	  write(row_hex8, ' ');
	  write(row_hex8, G_PXL_ARRAY_ROWS);
	  writeline(xgs_image_file_hex8, row_hex8);
	  write(row_hex8, string'("4095"));
	  writeline(xgs_image_file_hex8, row_hex8);
	  
	  write(row_dec, string'("P2"));
	  writeline(xgs_image_file_dec, row_dec);
      write(row_dec, G_PXL_ARRAY_COLUMNS);
	  write(row_dec, ' ');
	  write(row_dec, G_PXL_ARRAY_ROWS);
	  writeline(xgs_image_file_dec, row_dec);
	  write(row_dec, string'("4095"));
	  writeline(xgs_image_file_dec, row_dec);	  
	  
	  deallocate(row_hex12);
	  deallocate(row_hex8);
	  deallocate(row_dec);	
	
      --for line_count in 0 to 3099 loop --le 3099 changera avec le senseur utilise.
      for line_count in 0 to (G_PXL_ARRAY_ROWS-1) loop -- Fixed by AM     
	    for j in 0 to (G_PXL_ARRAY_COLUMNS-1) loop
          
		  if(j<P_LEFT_DUMMY_0) then                 --DUMMY
             random1 := 16#00D#;
          elsif(j<(P_LEFT_DUMMY_0+P_LEFT_BLACKREF)) then             --Black REF  
             random1 := 16#000#;
          elsif(j<(P_LEFT_DUMMY_0+P_LEFT_BLACKREF+P_LEFT_DUMMY_1)) then             --DUMMY
             random1 := 16#00D#;
          elsif(j<(P_LEFT_DUMMY_0+P_LEFT_BLACKREF+P_LEFT_DUMMY_1+P_INTERPOLATION1+P_ROI_WIDTH+P_INTERPOLATION2)) then          
            if(test_pattern_mode="000") then 		  
              random1 := rand_int(0, 1023)*4;               -- random 10 bits msb
            elsif(test_pattern_mode="001") then 
			  random1 :=  (line_count+j-(P_LEFT_DUMMY_0+P_LEFT_BLACKREF+P_LEFT_DUMMY_1) ) mod 4096;	    -- ramp 12 bits 
            else			  
			  random1 := ((line_count+j-(P_LEFT_DUMMY_0+P_LEFT_BLACKREF+P_LEFT_DUMMY_1) )*16) mod 4096;	-- ramp 8 bits msb 	
			end if;  
          elsif(j<(P_LEFT_DUMMY_0+P_LEFT_BLACKREF+P_LEFT_DUMMY_1+P_INTERPOLATION1+P_ROI_WIDTH+P_INTERPOLATION2+P_RIGHT_DUMMY_0)) then           --DUMMY
            random1 := 16#00D#; 
          elsif(j<(P_LEFT_DUMMY_0+P_LEFT_BLACKREF+P_LEFT_DUMMY_1+P_INTERPOLATION1+P_ROI_WIDTH+P_INTERPOLATION2+P_RIGHT_DUMMY_0+P_RIGHT_BLACKREF)) then           --Black REF  		  
            random1 := 16#000#;
          elsif(j<(P_LEFT_DUMMY_0+P_LEFT_BLACKREF+P_LEFT_DUMMY_1+P_INTERPOLATION1+P_ROI_WIDTH+P_INTERPOLATION2+P_RIGHT_DUMMY_0+P_RIGHT_BLACKREF+P_RIGHT_DUMMY_1)) then           --DUMMY 		  
            random1 := 16#00D#;			  
          end if;
          
		  if(random1=4096) then 
		    report "random1=4096 WAFFF????";
		  end if;  
		  
		  XGS_image(line_count, j) := random1; 
		  
		  write(row_dec, random1);
          write(row_dec, ' ');
            
          hex_value := std_logic_vector(to_unsigned(random1, 12) );   
          hwrite(row_hex12, hex_value );
          write(row_hex12, ' ');      
          
		  hwrite(row_hex8, hex_value(11 downto 4) ) ;
          write(row_hex8, ' ');        		 		 
        end loop; 

        writeline(xgs_image_file_dec,   row_dec);
        writeline(xgs_image_file_hex12, row_hex12);    
        writeline(xgs_image_file_hex8,  row_hex8);      
		
	   	deallocate(row_hex12);
	    deallocate(row_hex8);
	    deallocate(row_dec);	
		
      end loop; 

	  report "XGS Image generation Done.";
      file_close(xgs_image_file_dec);
	  file_close(xgs_image_file_hex12);
	  file_close(xgs_image_file_hex8);	 
	  
	end if;    
  
  
--begin
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
      elsif(line_count >= to_integer(unsigned(frame_length)) + roi_start )then
        frame_valid <= '0';
      else
        frame_valid <= frame_valid;  
      end if;  
    end if;
    
    
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
	
    -- jmansill Loading image from generated file
    if(x_subsampling='0') then 
      for j in 0 to (G_PXL_ARRAY_COLUMNS-1) loop
        if(line_count>roi_start and line_count<(roi_start+ to_integer(unsigned(frame_length)) ) )then
	  	  frame(1)(j) <= std_logic_vector(to_unsigned(XGS_image(line_count-1, j), 12));
        else
          frame(1)(j) <= X"EB5";
        end if;		  
      end loop;  
	else
      for j in 0 to (P_TOTAL-1) loop
        if(line_count>roi_start and line_count<(roi_start+ to_integer(unsigned(frame_length)) ) )then
          -- 
		  --  Lane 0 & 1
          --   __________________ ____________________ _____________________ ____________________       _____________________ ____________________
          --  X    even_pack     X       odd_pack     X      even_pack      X       odd_pack     X ... X      even_pack      X       odd_pack     X
		  --                                                                                           
          --  | 0----------->173 | 174----------->347 | 348------------>521 | 522----------->695 | ... | 1044---------->1217 | 1218--------->1391 |
          --  | 0,2,4....344,346 | 1,3,5......345,347 | 348,350.....692,694 | 349,351....693,695 | ... | 1044,1046......1390 | 1045,1047.....1391 |
		  --
		  
		  
          -- 
		  --  Lane 4 & 5
          --   __________________ ____________________                                                  _____________________ ____________________
          --  X    even_pack     X       odd_pack     X  ............................................. X      even_pack      X       odd_pack     X 
		  --                                             
          --  | 0----------->173 | 174----------->347 |  ............................................. | 1044---------->1217 | 1218--------->1391 |
          --  | 2784,2786...3130 | 2785,2787.....3131 |  ............................................. | 3828,3830......4174 | 3829,3831.....4175 |
		  --

		  if(j mod 348 < 174)   then	
		    --Pixels pairs 
    	    frame(1)(j) <= std_logic_vector(to_unsigned(XGS_image(line_count-1, (j-(j mod 174))+ 2*(j mod 174) ), 12));	  
		  else
		    --pixels impairs
    	    frame(1)(j) <= std_logic_vector(to_unsigned(XGS_image(line_count-1, (j-(j mod 348))+ 2*(j mod 174) + 1 ), 12));	  
		  end if;

        else
          frame(1)(j) <= X"EB5";
        end if;		  
      end loop;  	
    end if;
	
  end if;
end process FRAME_CONTENT;



LINE_COUNT_PROC : process(dataline_nxt, frame_valid)
begin
  frame_nxt <= '0';
  if frame_valid = '0' then
    line_count          <= roi_start;  --utilise pour load image : linecount= roi_start => ligne embedded frame(0), les autres frame(1) : lignes valides 
    line_count_out_mux  <= roi_start;  --utilise pour le mux d'ouput: ligne paire/impaire : la ligne embedded toujours paire! (support subsampling!)
  --jmansill
  elsif(dataline_nxt='1') then 
    if line_count >= to_integer(unsigned(frame_length) + roi_start) then
      if(slave_triggered_mode='0') then
	    frame_nxt          <= '1';      --trig next frame if master mode
	  else
	  	frame_nxt          <= '0';
      end if; 
      line_count         <= 0;  
      line_count_out_mux <= 0;  
    else
	  if(line_count= roi_start) then   --if embedded, then go to first line of frame line_count=0 is embedded line
        line_count         <= roi_start+1 ;
        line_count_out_mux <= roi_start+1 ;
	  else
	    line_count_out_mux <= line_count_out_mux + 1; -- for outmux increment always +1 (pour ne pas perdre info ligne paire ou impaire)
	    if(y_subsampling='0') then      
          line_count <= line_count + 1;
	    else 
          line_count <= line_count + 2;	  
        end if;	
	  end if;	
    end if;  
  end if;
   
end process LINE_COUNT_PROC;

emb_data       <= '1' when (line_count = roi_start) else '0';
first_line     <= '1' when line_count = roi_start else '0'; 
  --last_line      <= '1' when line_count = roi_start+roi_size                          else '0';

  -- [AM] Fixed the last_line flag. This flag should take into account the
  -- sub-sampling factor. The EOF sync was not generated because the last _line
  -- flag was not asserted when the subsampling factor was enabled.
  last_line <= '1' when (line_count = roi_start+roi_size) and (y_subsampling = '0') else
               '1' when (line_count = roi_start+roi_size-1) and (y_subsampling = '1') else
               '0';

dataline_valid <= '1' when frame_valid = '1' and line_count <= (roi_start+roi_size) else '0';



DATA_REORDER : process(line_count, frame)
begin
  --order data lines according to data sent on HiSPi data lanes as specified by the silicon.
  for j in 0 to 2*G_NUM_PHY-1 loop
      for i in 0 to G_PXL_PER_COLRAM-1 loop
        if line_count_out_mux = roi_start then                               --Embedded(ligne paire)    
            dataline(2*j*G_PXL_PER_COLRAM+G_PXL_PER_COLRAM+i) <= frame(0)(2*j*G_PXL_PER_COLRAM+2*i+1);
            dataline(2*j*G_PXL_PER_COLRAM                 +i) <= frame(0)(2*j*G_PXL_PER_COLRAM+2*i); 
        elsif (line_count_out_mux mod 2 = 0 and y_subsampling = '0') then    --Ligne Image impaire (0 is embeded)
            dataline(2*j*G_PXL_PER_COLRAM+G_PXL_PER_COLRAM+i) <= frame(1)(2*j*G_PXL_PER_COLRAM+2*i+1);
            dataline(2*j*G_PXL_PER_COLRAM                 +i) <= frame(1)(2*j*G_PXL_PER_COLRAM+2*i); 
        else                                                                 --Ligne Image paire (0 est la ligne embeded, alors ligne 0 image est ligne 1 ici), le SUB Y passera toujours ici.
            dataline(2*j*G_PXL_PER_COLRAM                 +i) <= frame(1)(2*j*G_PXL_PER_COLRAM+2*i+1);
            dataline(2*j*G_PXL_PER_COLRAM+G_PXL_PER_COLRAM+i) <= frame(1)(2*j*G_PXL_PER_COLRAM+2*i); 
        end if;
      end loop;
  end loop;
end process DATA_REORDER;

DEBUG_PROC : process(frame)
begin
  for i in 0 to 31 loop
    debug_frame_line0(i) <= frame(0)(i);
    debug_frame_line1(i) <= frame(1)(i);
  end loop;
end process DEBUG_PROC;

end behaviour;
