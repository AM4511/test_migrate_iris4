-----------------------------------------------------------------------
-- 
-- 
-- |Rc|   |KRr KRg KRb|   |R|   |OfR|
-- |Gc| = |KGr KGg KGb| * |G| + |OfG|
-- |Bc|   |KBr KBg KBb|   |B|   |OfB|
--
-- Rc = (KRr x R) + (KRg x G) + (KRb x B) + OfR
-- Gc = (KGr x R) + (KGg x G) + (KGb x B) + OfG
-- Bc = (KBr x R) + (KBg x G) + (KBb x B) + OfB
--
--
--
--
--
--
--                                                                                                                       
-- Created by :  Javier Mansilla
-- Date:        
-- Project:     IRIS 4
------------------------------------------------------------------------------


library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

-- pour pouvoir instancier des DSP48 directement
Library UNISIM;
use UNISIM.vcomponents.all;

library work;

entity ccm is
  port(
    pix_clk              : in  std_logic;
    pix_reset_n          : in  std_logic;

    pixel_sof_in         : in  std_logic;
    pixel_sol_in         : in  std_logic;
    pixel_en_in          : in  std_logic;
    pixel_eol_in         : in  std_logic;
    pixel_eof_in         : in  std_logic;

    red_in               : in  std_logic_vector (7 downto 0);
    green_in             : in  std_logic_vector (7 downto 0);
    blue_in              : in  std_logic_vector (7 downto 0);

    CCM_EN               : in  std_logic;
	
    KRr                  : in  std_logic_vector(11 downto 0);
    KRg                  : in  std_logic_vector(11 downto 0); 
    KRb                  : in  std_logic_vector(11 downto 0);
    Offr                 : in  std_logic_vector(8 downto 0); 

    KGr                  : in  std_logic_vector(11 downto 0);
    KGg                  : in  std_logic_vector(11 downto 0); 
    KGb                  : in  std_logic_vector(11 downto 0);
    Offg                 : in  std_logic_vector(8 downto 0); 

    KBr                  : in  std_logic_vector(11 downto 0);
    KBg                  : in  std_logic_vector(11 downto 0); 
    KBb                  : in  std_logic_vector(11 downto 0);
    Offb                 : in  std_logic_vector(8 downto 0); 

    pixel_sof_out        : out std_logic;
    pixel_sol_out        : out std_logic;
    pixel_en_out         : out std_logic;
    pixel_eol_out        : out std_logic;
    pixel_eof_out        : out std_logic;

    red_out              : out std_logic_vector (7 downto 0);
    green_out            : out std_logic_vector (7 downto 0);
    blue_out             : out std_logic_vector (7 downto 0)
    
  );
end ccm;

architecture functional of ccm is

  -- |Rc|   |KRr KRg KRb|   |R|   |OfR|
  -- |Gc| = |KGr KGg KGb| * |G| + |OfG|
  -- |Bc|   |KBr KBg KBb|   |B|   |OfB|

  -- Rc = (KRr x R) + (KRg x G) + (KRb x B) + OfR
  -- Gc = (KGr x R) + (KGg x G) + (KGb x B) + OfG
  -- Bc = (KBr x R) + (KBg x G) + (KBb x B) + OfB



  type IntegerArray8 is array (0 to 2) of integer range 0 to 255;
  type IntegerArray  is array (0 to 2) of integer;
  type VectorArray   is array (0 to 2) of std_logic_vector(22 downto 0);

  type Kfactor_Array is array (0 to 2) of std_logic_vector(KRr'range);            
  type Koffset_Array is array (0 to 2) of std_logic_vector(16 downto 0);    -- [+/-][8].[8]    

  type Pixel_out_Array is array (0 to 2) of std_logic_vector(7 downto 0); 


  signal Kr             : Kfactor_Array;
  signal Kg             : Kfactor_Array;
  signal Kb             : Kfactor_Array;
  signal KOff           : Koffset_Array;

  signal R_P1           : IntegerArray8;
  signal G_P1           : IntegerArray8;
  signal B_P1           : IntegerArray8;

  signal R_P2           : IntegerArray ;
  signal G_P2           : IntegerArray8;
  signal B_P2           : IntegerArray8;
  
  signal R_P3           : IntegerArray;
  signal G_P3           : IntegerArray;
  signal B_P3           : IntegerArray8;
  
  signal G_P4           : IntegerArray;
  signal B_P4           : IntegerArray;
  
  signal B_P5           : IntegerArray;
  signal B_P5_vect      : VectorArray;

  signal pixel_out      : Pixel_out_Array;  
  
  signal pixel_sof_in_P : std_logic_vector(6 downto 1);
  signal pixel_sol_in_P : std_logic_vector(6 downto 1);
  signal pixel_en_in_P  : std_logic_vector(6 downto 1);
  signal pixel_eol_in_P : std_logic_vector(6 downto 1);
  signal pixel_eof_in_P : std_logic_vector(6 downto 1);
 
  attribute use_dsp48 : string;
  attribute use_dsp48 of R_P2 : signal is "yes";
  attribute use_dsp48 of G_P3 : signal is "yes";
  attribute use_dsp48 of B_P4 : signal is "yes";


  
BEGIN

------------------------
--  Factors and offset
-- (0) is Red
-- (1) is Green
-- (2) is Blue
------------------------
Kr(0)   <= KRr;
Kg(0)   <= KRg;
Kb(0)   <= KRb;
	    
Kr(1)   <= KGr;
Kg(1)   <= KGg;
Kb(1)   <= KGb;
	    
Kr(2)   <= KBr;
Kg(2)   <= KBg;
Kb(2)   <= KBb;

KOff(0) <= Offr & "00000000";  --'0' are decimal part
KOff(1) <= Offg & "00000000";  --'0' are decimal part
KOff(2) <= Offb & "00000000";  --'0' are decimal part


-------------------------------------------------------------------
--
-- For each COMPONENT: need to do this for 3 components:
--        _____       _____       _____       _____       _____       _____       _____       _____    
--      _|     |_____|     |_____|     |_____|     |_____|     |_____|     |_____|     |_____|     |_____|
--  
--       <    R0     >
--                   <   R0'ff   >
--                               <  R0'ff*KRr >
--                                           <R0'ff*KRr+OfR>
--       <    B0     >
--                   <   B0'ff   >
--                               <   B0'2ff  >
--                                           < B0'2ff*KRg >
--                                                       < B0'2ff*KRg >
--                                                        +R0'ff*KRr+OfR
--       <    G0     >
--                   <   G0'ff   >
--                               <   G0'2ff  >
--                                           <   G0'3ff  >
--                                                       < G0'3ff*KRb >
--                                                                   < G0'3ff*KRb >
--                                                                    + B0'2ff*KRg    = RESULT
--                                                                    + R0'ff*KRr+OfR
--
--

-----------------------------------------------------------------
--  DSP
-----------------------------------------------------------------
-- Fixed-point precision:
--
--             K     Pix   
--  Res1  =  (s3.8 * 8.0 +  s8.0)  = ( s11.8 + s8)   = s12.8                   
--  Res2  =  (s3.8 * 8.0 +  Res1 ) = ( s11.8 + s12.8) = s13.8
--  Res3  =  (s3.8 * 8.0 +  Res2 ) = ( s11.8 + s13.8) = s14.8 (23 bits)
-- 
--
--
-- DSP IMPLEMENTATION PIPELINE for one component
--  
--
--                _________________                      _________________                      _________________             _________________
--               |      DSP1      |                     |      DSP2      |                     |      DSP3      |            |                |
--               |                |        R_P3         |                |        G_P4         |                |    B_P5    |   OVER/UNDER   |
--      KOff-----| C[]    PCOUT[] |---------------------| PCIN[] PCOUT[] |---------------------| PCIN[] PCOUT[] |------------|      FLOW      |----- PIXEL_OUT
--               |                |                     |                |                     |                |            |________________|
--       R_P1----| B[]            |            G_P2-----| B[]            |            B_P3-----| B[]            |            
--               |                |                     |                |                     |                |            
--      KR-------| A[]            |            KG-------| A[]            |           KB--------| A[]            |            
--               |                |                     |                |                     |                |            
--               |________________|                     |________________|                     |________________|            
--    

gen_component : for i in Pixel_out_Array'range generate


  --------------------------------------
  -- Stage 1 : flop all pixels
  -- R_P1 : 8.0      (7 downto 0)
  -- G_P1 : 8.0      (7 downto 0)
  -- B_P1 : 8.0      (7 downto 0)
  --------------------------------------
  process(pix_clk)
  begin
    if rising_edge(pix_clk) then
	  if(CCM_EN='1') then
        R_P1(i) <= to_integer(unsigned(red_in));
        G_P1(i) <= to_integer(unsigned(green_in));
        B_P1(i) <= to_integer(unsigned(blue_in));
	  end if;
    end if;
  end process;


  --------------------------------------
  -- Stage 2
  -- R_P2 : 8.0 * s3.8 = s11.8   (19 downto 0)->20 signed
  -- G_P2 : 8.0                  ( 7 downto 0)
  -- B_P2 : 8.0                  ( 7 downto 0)
  --------------------------------------
  process(pix_clk)
  begin
    if rising_edge(pix_clk) then
      if(CCM_EN='1') then
	    R_P2(i) <= R_P1(i) * to_integer(signed(Kr(i) ));
        G_P2(i) <= G_P1(i);
        B_P2(i) <= B_P1(i); 
      end if;		
    end if;
  end process;

  --------------------------------------
  -- Stage 3
  -- R_P3 : s11.8 + s8.0 = s12.8   (20 downto 0)
  -- G_P3 : 8.0 * s3.8   = s11.8   (19 downto 0)->20 signed
  -- B_P3 : 8.0                    ( 7 downto 0)
  --------------------------------------
  process(pix_clk)
  begin
    if rising_edge(pix_clk) then
      if(CCM_EN='1') then
        R_P3(i) <= R_P2(i)  + to_integer(signed(KOff(i) ));  
        G_P3(i) <= G_P2(i) * to_integer(signed(Kg(i) ));
	    B_P3(i) <= B_P2(i); 
	  end if;	
    end if;
  end process;

  --------------------------------------
  -- Stage 4
  --
  -- G_P4 : s11.8 + s12.8  = s13.8 (21 downto 0)
  -- B_P4 :  8.0 * s3.8    = s11.8 (19 downto 0)  
  --------------------------------------
  process(pix_clk)
  begin
    if rising_edge(pix_clk) then
      if(CCM_EN='1') then
        G_P4(i) <= G_P3(i) + R_P3(i);
	    B_P4(i) <= B_P3(i) * to_integer(signed(Kb(i) )); 
	  end if;	
    end if;
  end process;

  --------------------------------------
  -- Stage 5
  --
  --  B_P5: s11.8 + s13.8 = s14.8 (22 downto 0)
  --------------------------------------
  process(pix_clk)
  begin
    if rising_edge(pix_clk) then
      if(CCM_EN='1') then
	    B_P5(i) <= B_P4(i) + G_P4(i); 
	  end if;	
    end if;
  end process;

  B_P5_vect(i) <= std_logic_vector(to_signed(B_P5(i), 23));


  --------------------------------------
  -- Stage 6 : CLIP HI-LO 
  --
  -- Pixel out : (7 downto 0)  
  --------------------------------------
  process(pix_clk)
  begin
    if rising_edge(pix_clk) then
      if(CCM_EN='1') then        
        if B_P5_vect(i)(22) = '0' then -- Positive pixel	  
          -- Overflow
          if B_P5_vect(i)(21 downto 16) = "000000" then
            pixel_out(i) <= B_P5_vect(i)(15 downto 8);  -- NO OVERFLOW : keep 8 LSB                   
          else
            pixel_out(i) <= (others => '1');         -- OVERFLOW : set it to FF
          end if;	  
        else  
          -- Underflow
          pixel_out(i) <= (others => '0');   
        end if;
	  end if;	
	end if;  
  end process;

end generate;




  --------------------------
  -- Output pixels
  --------------------------
  
  red_out    <= pixel_out(0) when CCM_EN='1' else red_in;
  green_out  <= pixel_out(1) when CCM_EN='1' else green_in;
  blue_out   <= pixel_out(2) when CCM_EN='1' else blue_in;



  --------------------------
  -- Output Sync
  --------------------------
  process(pix_clk)
  begin
    if rising_edge(pix_clk) then        	  
 	  pixel_sof_in_P(1)                            <= pixel_sof_in;
	  pixel_sof_in_P(pixel_sof_in_P'high downto 2) <= pixel_sof_in_P(pixel_sof_in_P'high-1 downto 1);

 	  pixel_sol_in_P(1)                            <= pixel_sol_in;
	  pixel_sol_in_P(pixel_sol_in_P'high downto 2) <= pixel_sol_in_P(pixel_sol_in_P'high-1 downto 1);	  
	  
	  pixel_en_in_P(1)                             <= pixel_en_in;
	  pixel_en_in_P(pixel_en_in_P'high downto 2)   <= pixel_en_in_P(pixel_en_in_P'high-1 downto 1);
	  
 	  pixel_eol_in_P(1)                            <= pixel_eol_in;
	  pixel_eol_in_P(pixel_eol_in_P'high downto 2) <= pixel_eol_in_P(pixel_eol_in_P'high-1 downto 1);

 	  pixel_eof_in_P(1)                            <= pixel_eof_in;
	  pixel_eof_in_P(pixel_eof_in_P'high downto 2) <= pixel_eof_in_P(pixel_eof_in_P'high-1 downto 1);
 	  
    end if;
  end process;



  pixel_sof_out  <= pixel_sof_in_P(pixel_sof_in_P'high)when CCM_EN='1' else pixel_sof_in;
  pixel_sol_out  <= pixel_sol_in_P(pixel_sol_in_P'high)when CCM_EN='1' else pixel_sol_in;
  pixel_en_out   <= pixel_en_in_P (pixel_en_in_P 'high)when CCM_EN='1' else pixel_en_in; 
  pixel_eol_out  <= pixel_eol_in_P(pixel_eol_in_P'high)when CCM_EN='1' else pixel_eol_in;
  pixel_eof_out  <= pixel_eof_in_P(pixel_eof_in_P'high)when CCM_EN='1' else pixel_eof_in;


end functional;


