-----------------------------------------------------------------------
-- $HeadURL: svn://brainstorm/fpga/trunk/Matrox/Imaging/cores/ccd_if/design/ccd_common/design/rgb_2_yuv.vhd $
-- $Author: jmansill $
-- $Revision: 6590 $
-- $Date: 2010-10-29 13:19:49 -0400 (Fri, 29 Oct 2010) $
--
-- DESCRIPTION: YUV CONVERSION
-----------------------------------------------------------------------
-- File:        rgb_2_yuv.vhd
-- Decription:  This module convert RGB space pixels to YUV
--               
-- Notes:
-- 
-- RGB(gamma corrected) to YUV
-- 
-- Y =    (CYr x R) + (CYg x G) + (CYb x B)  
-- U =  - (CUr x R) - (CUg x G) + (CUb x B) + 128 
-- V =    (CVr x R) - (CVg x G) - (CVb x B) + 128  
--
--                                                                                                                       
-- Created initialement par:  Javier Mansilla
-- Date:        
-- Project:     IRIS 3
------------------------------------------------------------------------------


library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

-- pour pouvoir instancier des DSP48 directement
Library UNISIM;
use UNISIM.vcomponents.all;

library work;

entity rgb_2_yuv is
  port(
    pix_clk              : in      std_logic;
    pix_reset_n          : in      std_logic;

    pixel_sof_in         : in      std_logic;
    pixel_sol_in         : in      std_logic;
    pixel_en_in          : in      std_logic;
    pixel_eol_in         : in      std_logic;
    pixel_eof_in         : in      std_logic;

    red_in               : in      std_logic_vector (7 downto 0);
    green_in             : in      std_logic_vector (7 downto 0);
    blue_in              : in      std_logic_vector (7 downto 0);

    pixel_sof_out        : out     std_logic;
    pixel_sol_out        : out     std_logic;
    pixel_en_out         : buffer  std_logic;
    pixel_eol_m1_out     : out     std_logic;  -- EOL one clk before
    pixel_eol_out        : out     std_logic;
    pixel_eof_out        : out     std_logic;

    Y                    : buffer  std_logic_vector (7 downto 0);
    U                    : buffer  std_logic_vector (7 downto 0);
    V                    : buffer  std_logic_vector (7 downto 0);
    UV_subsampled        : out     std_logic_vector (7 downto 0)
  );
end rgb_2_yuv;

architecture functional of rgb_2_yuv is

	-- Y Coefficients
	constant CYr    : std_logic_vector(7 downto 0) := "01001101";  --0.299	 76   => DOIT ETRE ARRONDI A 77.
	constant CYg    : std_logic_vector(7 downto 0) := "10010110";  --0.587	 150
	constant CYb    : std_logic_vector(7 downto 0) := "00011101";  --0.114	 29

	-- U Coefficientcs
	constant CUr    : std_logic_vector(7 downto 0) := "00101011";  --0.169	 43
	constant CUg    : std_logic_vector(7 downto 0) := "01010101";  --0.331	 84 => doit etre arrondi a 85 pour balancer
	constant CUb    : std_logic_vector(7 downto 0) := "10000000";  --0.500	 128

	-- V Coefficients
	constant CVr    : std_logic_vector(7 downto 0) := "10000000";  --0.500	 128  => 0.498 DOIT ETRE ARRONDI a 128 pour balancer
	constant CVg    : std_logic_vector(7 downto 0) := "01101011";  --0.419	 107  => 0.417 DOIT ETRE ARRONDI a 107 pour balancer
	constant CVb    : std_logic_vector(7 downto 0) := "00010101";  --0.081	 20   =>       DOIT ETRE 21


  signal Mult_Y_R   : std_logic_vector(15 downto 0);
  signal Mult_Y_G   : std_logic_vector(15 downto 0);
  signal Mult_Y_B   : std_logic_vector(15 downto 0);
  
  signal Mult_U_R   : std_logic_vector(15 downto 0);
  signal Mult_U_G   : std_logic_vector(15 downto 0);
  signal Mult_U_B   : std_logic_vector(15 downto 0);
  
  signal Mult_V_R   : std_logic_vector(15 downto 0);  
  signal Mult_V_G   : std_logic_vector(15 downto 0);
  signal Mult_V_B   : std_logic_vector(15 downto 0);
  
  signal Yadd       : std_logic_vector(16 downto 0);
  signal Uadd       : std_logic_vector(17 downto 0);
  signal Vadd       : std_logic_vector(17 downto 0);

  signal pixel_en_in_p1       : std_logic; 
  signal pixel_en_in_p2       : std_logic; 
  signal yuv_cntr             : std_logic;
  signal saved_V              : std_logic_vector(red_in'range);


  -- pour valider l'equivalence
  signal old_pixel_en_out         : std_logic;
  signal old_Y                    : std_logic_vector (7 downto 0);
  signal old_U                    : std_logic_vector (7 downto 0);
  signal old_V                    : std_logic_vector (7 downto 0);

  -- pipeline en adder cascadepour favoriser l'inference de DSP48 et garder toute la logique dans le DSP48.
  signal MultYR   : std_logic_vector(15 downto 0);
  signal MultYG   : std_logic_vector(15 downto 0);
  signal MultYB   : std_logic_vector(15 downto 0);
  
  signal MultUR   : std_logic_vector(15 downto 0);
  signal MultUG   : std_logic_vector(15 downto 0);
  signal MultUB   : std_logic_vector(15 downto 0);
  
  signal MultVR   : std_logic_vector(15 downto 0);  
  signal MultVG   : std_logic_vector(15 downto 0);
  signal MultVB   : std_logic_vector(15 downto 0);

  attribute use_dsp48 : string;
  attribute use_dsp48 of MultYR : signal is "yes";
  attribute use_dsp48 of MultYG : signal is "yes";
  attribute use_dsp48 of MultYB : signal is "yes";

  attribute use_dsp48 of MultUR : signal is "yes";
  attribute use_dsp48 of MultUG : signal is "yes";
  attribute use_dsp48 of MultUB : signal is "yes";

  attribute use_dsp48 of MultVR : signal is "yes";
  attribute use_dsp48 of MultVG : signal is "yes";
  attribute use_dsp48 of MultVB : signal is "yes";

  signal green_in_p1          : std_logic_vector(green_in'range);
  signal green_in_p2          : std_logic_vector(green_in'range);
  signal blue_in_p1           : std_logic_vector(blue_in'range);
  signal blue_in_p2           : std_logic_vector(blue_in'range);
  signal blue_in_p3           : std_logic_vector(blue_in'range);
  signal blue_in_p4           : std_logic_vector(blue_in'range);

  signal YaddR : std_logic_vector(16 downto 0);
  signal UaddR : std_logic_vector(17 downto 0);
  signal VaddR : std_logic_vector(17 downto 0);

  signal YaddRG : std_logic_vector(YaddR'range);
  signal UaddRG : std_logic_vector(UaddR'range);
  signal VaddRG : std_logic_vector(VaddR'range);

  signal YaddRGB : std_logic_vector(YaddR'range);
  signal UaddRGB : std_logic_vector(UaddR'range);
  signal VaddRGB : std_logic_vector(VaddR'range);

  signal pixel_sof_p    : std_logic_vector(0 to 4);
  signal pixel_sol_p    : std_logic_vector(0 to 4);
  signal pixel_valid_p  : std_logic_vector(0 to 4);
  signal pixel_eol_p    : std_logic_vector(0 to 4);
  signal pixel_eof_p    : std_logic_vector(0 to 4);

  signal Y_p1 : std_logic_vector(Y'range);
  signal U_p1 : std_logic_vector(Y'range);
  signal V_p1 : std_logic_vector(Y'range);
  
  -- version DSP48
--   constant ALL_ONE : std_logic_vector(47 downto 0) := (others => '1');
--   constant ZERO  : std_logic_vector(47 downto 0) := (others => '0');
-- 
--   signal Mult_Y_R_48   : std_logic_vector(47 downto 0);
-- 
-- 	constant CYr_48    : std_logic_vector(17 downto 0) := '0' & CYr & ZERO(8 downto 0); 
--   signal red_48      : std_logic_vector(29 downto 0);
  
BEGIN

  --
  -- RGB(gamma corrected) to YUV
  -- 
  -- Y =    (CYr x R) + (CYg x G) + (CYb x B)  
  -- U =  - (CUr x R) - (CUg x G) + (CUb x B) + 128 
  -- V =    (CVr x R) - (CVg x G) - (CVb x B) + 128  
  --

  -- version initiale: adder tree, conceptuellement plus simple et avec une latence plus faible, mais consommant plus d'energie.
  Multiplications:  process(pix_clk)
  begin
    if rising_edge(pix_clk) then
      Mult_Y_R <= unsigned(CYr) * unsigned(red_in);
      Mult_Y_G <= unsigned(CYg) * unsigned(green_in); 
      Mult_Y_B <= unsigned(CYb) * unsigned(blue_in);

      Mult_U_R <= unsigned(CUr) * unsigned(red_in);
      Mult_U_G <= unsigned(CUg) * unsigned(green_in); 
      Mult_U_B <= unsigned(CUb) * unsigned(blue_in);

      Mult_V_R <= unsigned(CVr) * unsigned(red_in);
      Mult_V_G <= unsigned(CVg) * unsigned(green_in); 
      Mult_V_B <= unsigned(CVb) * unsigned(blue_in);

    end if;
  end process;

  ADD_and_DIV:  process(pix_clk)
  begin
    if rising_edge(pix_clk) then
        Yadd     <=  std_logic_vector('0'&Mult_Y_R) + std_logic_vector('0'&Mult_Y_G) +  std_logic_vector('0'&Mult_Y_B);
        Uadd     <=  std_logic_vector("00"&Mult_U_B) + "001000000000000000" - std_logic_vector("00"&Mult_U_R) - std_logic_vector("00"&Mult_U_G) ;  
        Vadd     <=  std_logic_vector("00"&Mult_V_R) + "001000000000000000" - std_logic_vector("00"&Mult_V_G) - std_logic_vector("00"&Mult_V_B) ;     
    end if;
  end process;

  pipelines : process(pix_clk)
  begin
    if(rising_edge(pix_clk)) then

      if(pix_reset_n = '0') then
        pixel_en_in_p1          <= '0';
        pixel_en_in_p2          <= '0';
      else
        pixel_en_in_p1          <= pixel_en_in;
        pixel_en_in_p2          <= pixel_en_in_p1;
      end if;  

      if(pix_reset_n = '0') then
        old_pixel_en_out            <= '0';
      else
        old_pixel_en_out            <= pixel_en_in_p2;
      end if;
    end if;
  end process;


  oldMini_packer_16bits : process(pix_clk) 
  begin
    if(rising_edge(pix_clk)) then
      --if(pix_reset_n = '0') then
      --  yuv_cntr   <= '0';
      --elsif(pixel_en_in_p2='1') then
      --  yuv_cntr <= not(yuv_cntr);
      --end if;

      if(pixel_en_in_p2='1') then
        -- au lieu d'imposer le subsampling ici, on va faire un module general qui sort les 3 components et 
        -- le module appelant pourra decider de faire du YUV24, ou de subsampler en YUV16.
        old_Y <= Yadd(15 downto 8);
        old_U <= Uadd(15 downto 8);
        old_V <= Vadd(15 downto 8);

        -- et pour etre pratique avec notre premiere utilisation, on va sortir le UV combine quand meme
        --if(yuv_cntr='0') then
        --  UV_subsampled <= Uadd(15 downto 8);
        --  saved_V <= Vadd(15 downto 8);
        --else
        --  UV_subsampled <= saved_V;
        --end if;
      end if;
      
    end if;
  end process;


  -- version ADDER CASCADE
  -- cela correspond a ce que les DSP48 peuvent faire un logique interne, donc faible puissance,
  etape_rouge:  process(pix_clk)
  begin
    if rising_edge(pix_clk) then
      -- premiere etape, on multiple les rouges et on accumule dans le flop M, les autres couleurs attendent d'un flop
      MultYR <= unsigned(CYr) * unsigned(red_in);
      MultUR <= unsigned(CUr) * unsigned(red_in);
      MultVR <= unsigned(CVr) * unsigned(red_in);

      green_in_p1 <= green_in;
      blue_in_p1 <= blue_in;
      
    end if;
  end process;

  etape_vert:  process(pix_clk)
  begin
    if rising_edge(pix_clk) then
      -- deuxieme etape, on multiple les verts et on accumule dans le flop M, le bleu attendent d'un flop
      MultYG <= unsigned(CYg) * unsigned(green_in_p1); 
      MultUG <= unsigned(CUg) * unsigned(green_in_p1); 
      MultVG <= unsigned(CVg) * unsigned(green_in_p1); 

      -- deuxieme etape, on pipeline l'addition. Pour Y, on additionne rien
      YaddR <= '0'&Mult_Y_R;
      UaddR <= "001000000000000000" - std_logic_vector("00"&MultUR);
      VaddR <= std_logic_vector("00"&MultVR) + "001000000000000000";

      --green_in_p2 <= green_in_p1;
      blue_in_p2 <= blue_in_p1;
    end if;
  end process;

  etape_bleu:  process(pix_clk)
  begin
    if rising_edge(pix_clk) then
      -- troisieme etape, on multiple les bleu et on accumule dans le flop M
      MultYB <= unsigned(CYb) * unsigned(blue_in_p2);
      MultUB <= unsigned(CUb) * unsigned(blue_in_p2);
      MultVB <= unsigned(CVb) * unsigned(blue_in_p2);

      -- troisieme etape, on ajoute le vert
      YaddRG <= YaddR + std_logic_vector('0'&MultYG);
      UaddRG <= UaddR - std_logic_vector("00"&MultUG);
      VaddRG <= VaddR - std_logic_vector("00"&MultVG);
    end if;
  end process;

  etape_add:  process(pix_clk)
  begin
    if rising_edge(pix_clk) then
      -- quatrieme etape derniere addition
      YaddRGB <= YaddRG + std_logic_vector('0'&MultYB);
      UaddRGB <= UaddRG + std_logic_vector("00"&MultUB);
      VaddRGB <= VaddRG - std_logic_vector("00"&MultVB);
    end if;
  end process;

  pipeline: process(pix_clk)
  begin
    if rising_edge(pix_clk) then
      if(pix_reset_n = '0') then
        pixel_sof_p    <= (others => '0');
        pixel_sof_out  <= '0';
        pixel_sol_p    <= (others => '0');
        pixel_sol_out  <= '0';  
        pixel_valid_p  <= (others => '0');
        pixel_en_out   <= '0';
        pixel_eol_p    <= (others => '0');
        pixel_eol_out  <= '0';
        pixel_eof_p    <= (others => '0');
        pixel_eof_out  <= '0';	
      else
        pixel_sof_p(1)                         <= pixel_sof_in;
        pixel_sof_p(2 to pixel_sof_p'high)     <= pixel_sof_p(1 to pixel_sof_p'high-1);
        pixel_sof_out                          <= pixel_sof_p(pixel_sof_p'high);
 	  
        pixel_sol_p(1)                         <= pixel_sol_in;
        pixel_sol_p(2 to pixel_sol_p'high)     <= pixel_sol_p(1 to pixel_sol_p'high-1);
        pixel_sol_out                          <= pixel_sol_p(pixel_sol_p'high);
	  
        pixel_valid_p(1)                       <= pixel_en_in;
        pixel_valid_p(2 to pixel_valid_p'high) <= pixel_valid_p(1 to pixel_valid_p'high-1);
        pixel_en_out                           <= pixel_valid_p(pixel_valid_p'high);
		
		pixel_eol_p(1)                         <= pixel_eol_in;
        pixel_eol_p(2 to pixel_eol_p'high)     <= pixel_eol_p(1 to pixel_eol_p'high-1);
        pixel_eol_out                          <= pixel_eol_p(pixel_eol_p'high);

        pixel_eof_p(1)                         <= pixel_eof_in;
        pixel_eof_p(2 to pixel_eof_p'high)     <= pixel_eof_p(1 to pixel_eof_p'high-1);
        pixel_eof_out                          <= pixel_eof_p(pixel_eof_p'high);
      end if;
    end if;
  end process;
  
  pixel_eol_m1_out <= pixel_eol_p(pixel_eol_p'high);  --EOL one clk before

  -- validation d'equivalence!
  check:  process(pix_clk)
  begin
    if rising_edge(pix_clk) then
      if old_pixel_en_out = '1' then
        Y_p1 <= old_Y;
        U_p1 <= old_U;
        V_p1 <= old_V;
      end if;
      -- c'est ici qu'on sortirait le pixel!
      if pixel_valid_p(pixel_valid_p'high) = '1' then
        assert YaddRGB(15 downto 8) = Y_p1 report "Erreur de Y" severity ERROR;
        assert UaddRGB(15 downto 8) = U_p1 report "Erreur de U" severity ERROR;
        assert VaddRGB(15 downto 8) = V_p1 report "Erreur de V" severity ERROR;
      end if;
    end if;
  end process;

  Mini_packer_16bits : process(pix_clk) 
  begin
    if(rising_edge(pix_clk)) then
      if(pix_reset_n = '0') then
        yuv_cntr   <= '0';
      elsif( pixel_valid_p(pixel_valid_p'high) ='1') then
        yuv_cntr <= not(yuv_cntr);
      end if;

      if( pixel_valid_p(pixel_valid_p'high) ='1') then
        -- au lieu d'imposer le subsampling ici, on va faire un module general qui sort les 3 components et 
        -- le module appelant pourra decider de faire du YUV24, ou de subsampler en YUV16.
        Y <= YaddRGB(15 downto 8);
        U <= UaddRGB(15 downto 8);
        V <= VaddRGB(15 downto 8);
        -- et pour etre pratique avec notre premiere utilisation, on va sortir le UV combine quand meme
                
        if(yuv_cntr='0') then
          UV_subsampled <= UaddRGB(15 downto 8);
          saved_V <= VaddRGB(15 downto 8);
        else
          UV_subsampled <= saved_V;
        end if;
      end if;
      
    end if;
  end process;


--   -- version optimisee pour la puissance utilisant des DSP 48.
--   red_48 <= '0' & red_in & ZERO(20 downto 0);
--   
--    multRY : DSP48E1
--    generic map (
--       -- Feature Control Attributes: Data Path Selection
--       A_INPUT => "DIRECT",               -- Selects A input source, "DIRECT" (A port) or "CASCADE" (ACIN port)
--       B_INPUT => "DIRECT",               -- Selects B input source, "DIRECT" (B port) or "CASCADE" (BCIN port)
--       USE_DPORT => FALSE,                -- Select D port usage (TRUE or FALSE)
--       USE_MULT => "MULTIPLY",            -- Select multiplier usage ("MULTIPLY", "DYNAMIC", or "NALL_ONE")
--       USE_SIMD => "ALL_ONE48",               -- SIMD selection ("ALL_ONE48", "TWO24", "FOUR12")
--       -- Pattern Detector Attributes: Pattern Detection Configuration
--       AUTORESET_PATDET => "NO_RESET",    -- "NO_RESET", "RESET_MATCH", "RESET_NOT_MATCH" 
--       MASK => X"3fffffffffff",           -- 48-bit mask value for pattern detect (1=ignore)
--       PATTERN => X"000000000000",        -- 48-bit pattern match for pattern detect
--       SEL_MASK => "MASK",                -- "C", "MASK", "ROUNDING_MODE1", "ROUNDING_MODE2" 
--       SEL_PATTERN => "PATTERN",          -- Select pattern value ("PATTERN" or "C")
--       USE_PATTERN_DETECT => "NO_PATDET", -- Enable pattern detect ("PATDET" or "NO_PATDET")
--       -- Register Control Attributes: Pipeline Register Configuration
--       ACASCREG => 0,                     -- Number of pipeline stages between A/ACIN and ACOUT (0, 1 or 2)
--       ADREG => 1,                        -- Number of pipeline stages for pre-adder (0 or 1)
--       ALUMODEREG => 1,                   -- Number of pipeline stages for ALUMODE (0 or 1)
--       AREG => 0,                         -- Number of pipeline stages for A (0, 1 or 2)
--       BCASCREG => 0,                     -- Number of pipeline stages between B/BCIN and BCOUT (0, 1 or 2)
--       BREG => 0,                         -- Number of pipeline stages for B (0, 1 or 2)
--       CARRYINREG => 1,                   -- Number of pipeline stages for CARRYIN (0 or 1)
--       CARRYINSELREG => 1,                -- Number of pipeline stages for CARRYINSEL (0 or 1)
--       CREG => 1,                         -- Number of pipeline stages for C (0 or 1)
--       DREG => 1,                         -- Number of pipeline stages for D (0 or 1)
--       INMODEREG => 1,                    -- Number of pipeline stages for INMODE (0 or 1)
--       MREG => 1,                         -- Number of multiplier pipeline stages (0 or 1)
--       OPMODEREG => 1,                    -- Number of pipeline stages for OPMODE (0 or 1)
--       PREG => 1                          -- Number of pipeline stages for P (0 or 1)
--    )
--    port map (
--       -- Cascade: 30-bit (each) output: Cascade Ports
--       --ACOUT => ACOUT,                   -- 30-bit output: A port cascade output
--       --BCOUT => BCOUT,                   -- 18-bit output: B port cascade output
--       --CARRYCASCOUT => CARRYCASCOUT,     -- 1-bit output: Cascade carry output
--       --MULTSIGNOUT => MULTSIGNOUT,       -- 1-bit output: Multiplier sign cascade output
--       --PCOUT => PCOUT,                   -- 48-bit output: Cascade output
--       -- Control: 1-bit (each) output: Control Inputs/Status Bits
--       --OVERFLOW => OVERFLOW,             -- 1-bit output: Overflow in add/acc output
--       --PATTERNBDETECT => PATTERNBDETECT, -- 1-bit output: Pattern bar detect output
--       --PATTERNDETECT => PATTERNDETECT,   -- 1-bit output: Pattern detect output
--       --UNDERFLOW => UNDERFLOW,           -- 1-bit output: Underflow in add/acc output
--       -- Data: 4-bit (each) output: Data Ports
--       --CARRYOUT => CARRYOUT,             -- 4-bit output: Carry output
--       P => Mult_Y_R_48,                           -- 48-bit output: Primary data output -- 16 MSB valides
--       -- Cascade: 30-bit (each) input: Cascade Ports
--       ACIN => ALL_ONE(29 downto 0),                     -- 30-bit input: A cascade data input
--       BCIN => ALL_ONE(17 downto 0),                     -- 18-bit input: B cascade input
--       CARRYCASCIN => ALL_ONE(0),       -- 1-bit input: Cascade carry input
--       MULTSIGNIN => ALL_ONE(0),         -- 1-bit input: Multiplier sign input
--       PCIN => ALL_ONE,                     -- 48-bit input: P cascade input
--       -- Control: 4-bit (each) input: Control Inputs/Status Bits
--       ALUMODE => "0000",               -- 4-bit input: ALU control input
--       CARRYINSEL => "000",         -- 3-bit input: Carry select input
--       CLK => pix_clk,                       -- 1-bit input: Clock input
--       INMODE => "00000",                 -- 5-bit input: INMODE control input
--       OPMODE => "0000101",                 -- 7-bit input: Operation mode input
--       -- Data: 30-bit (each) input: Data Ports
--       A => red_48,                           -- 30-bit input: A data input
--       B => CYr_48,                           -- 18-bit input: B data input
--       C => ALL_ONE,                           -- 48-bit input: C data input
--       CARRYIN => '0',               -- 1-bit input: Carry input signal
--       D => ALL_ONE(24 downto 0),                           -- 25-bit input: D data input
--       -- Reset/Clock Enable: 1-bit (each) input: Reset/Clock Enable Inputs
--       CEA1 => '0',                     -- 1-bit input: Clock enable input for 1st stage AREG
--       CEA2 => '0',                     -- 1-bit input: Clock enable input for 2nd stage AREG
--       CEAD => '0',                     -- 1-bit input: Clock enable input for ADREG
--       CEALUMODE => '1',                 -- 1-bit input: Clock enable input for ALUMODE
--       CEB1 => '0',                     -- 1-bit input: Clock enable input for 1st stage BREG
--       CEB2 => '0',                     -- 1-bit input: Clock enable input for 2nd stage BREG
--       CEC => '0',                       -- 1-bit input: Clock enable input for CREG
--       CECARRYIN => '0',           -- 1-bit input: Clock enable input for CARRYINREG
--       CECTRL => '1',                 -- 1-bit input: Clock enable input for OPMODEREG and CARRYINSELREG
--       CED => '0',                       -- 1-bit input: Clock enable input for DREG
--       CEINMODE => '1',             -- 1-bit input: Clock enable input for INMODEREG
--       CEM => '1',                       -- 1-bit input: Clock enable input for MREG
--       CEP => '1',                       -- 1-bit input: Clock enable input for PREG
--       RSTA => '0',                     -- 1-bit input: Reset input for AREG
--       RSTALLCARRYIN => '0',   -- 1-bit input: Reset input for CARRYINREG
--       RSTALUMODE => '0',         -- 1-bit input: Reset input for ALUMODEREG
--       RSTB => '0',                     -- 1-bit input: Reset input for BREG
--       RSTC => '0',                     -- 1-bit input: Reset input for CREG
--       RSTCTRL => '0',               -- 1-bit input: Reset input for OPMODEREG and CARRYINSELREG
--       RSTD => '0',                     -- 1-bit input: Reset input for DREG and ADREG
--       RSTINMODE => '0',           -- 1-bit input: Reset input for INMODEREG
--       RSTM => '0',                     -- 1-bit input: Reset input for MREG
--       RSTP => '0'                      -- 1-bit input: Reset input for PREG
--    );

end functional;


