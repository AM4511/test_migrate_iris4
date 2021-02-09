-----------------------------------------------------------------------
-- File:        xgs_color_proc.vhd
-- Decription:  
--              
-- This module contains:
--
-- This is the pipeline  for color/mono processing in IRIS GTX 
--
-- Created by:  Javier Mansilla
-- Date:        
-- Project:     IRIS 4
--
--                                                
--                 _________           __________         _________          __________
--        20      |         |   20    |         |   20   |         |   20   |          |   64 (2x pix 24 bits) 
--   ------------>|  Gamma  |-------->|   WB    |------->|   Lut   |------->|  Bayer   |------------>  BAYER_EXPANSION
--                |_________|         |_________|        |_________|        |__________|
--                                                                              
--
--
-------------------------------------------------------------------------------

library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.std_logic_unsigned.all;
  use IEEE.std_logic_arith.conv_std_logic_vector;

library work;
  use work.osirispak.all;
  use work.regfile_athena_pack.all;

library UNISIM;
  use UNISIM.VCOMPONENTS.all;

entity xgs_color_proc is
   port (  
           
           ---------------------------------------------------------------------
           -- Axi domain reset and clock signals
           ---------------------------------------------------------------------
           axi_clk                              : in    std_logic;
           axi_reset_n                          : in    std_logic;

           ---------------------------------------------------------------------
           -- AXI in
           ---------------------------------------------------------------------  
           s_axis_tvalid                           : in   std_logic;
	       s_axis_tready                           : out   std_logic;
           s_axis_tuser                            : in   std_logic_vector(3 downto 0);
           s_axis_tlast                            : in   std_logic;
           s_axis_tdata                            : in   std_logic_vector;	
	       
           ---------------------------------------------------------------------
           -- AXI out
           ---------------------------------------------------------------------
	       m_axis_tready                           : in  std_logic;
           m_axis_tvalid                           : out std_logic;
           m_axis_tuser                            : out std_logic_vector(3 downto 0);
           m_axis_tlast                            : out std_logic;
           m_axis_tdata                            : out std_logic_vector(79 downto 0)

         
           ---------------------------------------------------------------------------
           --  Registers
           ---------------------------------------------------------------------------
           curr_db_reverse_y                       : in std_logic

        );
end xgs_color_proc;


------------------------------------------------------
-- Begin architecture structure
------------------------------------------------------

architecture functional of color_proc is


constant Pix_type    : integer := ((remap_data'high+1)/4);     -- this will return 8 or 10


-- Components

component xil_lut1010 
  port (
    clka  : in  STD_LOGIC;
    ena   : in  STD_LOGIC;
    wea   : in  STD_LOGIC_VECTOR(0 to 0);
    addra : in  STD_LOGIC_VECTOR(Pix_type-1 downto 0);
    dina  : in  STD_LOGIC_VECTOR(Pix_type-1 downto 0);
    douta : out STD_LOGIC_VECTOR(Pix_type-1 downto 0);

    clkb  : in  STD_LOGIC;
    enb   : in  STD_LOGIC;
    web   : in  STD_LOGIC_VECTOR(0 to 0);
    addrb : in  STD_LOGIC_VECTOR(Pix_type-1 downto 0);
    dinb  : in  STD_LOGIC_VECTOR(Pix_type-1 downto 0);
    doutb : out STD_LOGIC_VECTOR(Pix_type-1 downto 0)

  );
end component;


component xil_wb_mult
  Port ( 
    CLK : in STD_LOGIC;
    A   : in STD_LOGIC_VECTOR (Pix_type-1 downto 0);
    B   : in STD_LOGIC_VECTOR ( 15 downto 0 );
    CE  : in STD_LOGIC;
    P   : out STD_LOGIC_VECTOR (Pix_type+15 downto 0 )
  );
end component;


component xil_ram_bayer
  Port ( 
    clka  : in STD_LOGIC;
    ena   : in STD_LOGIC;
    wea   : in STD_LOGIC_VECTOR(0 to 0 );
    addra : in STD_LOGIC_VECTOR(11 downto 0 );
    dina  : in STD_LOGIC_VECTOR(Pix_type-1 downto 0 );
    clkb  : in STD_LOGIC;
    enb   : in STD_LOGIC;
    addrb : in STD_LOGIC_VECTOR(11 downto 0 );
    doutb : out STD_LOGIC_VECTOR(Pix_type-1 downto 0 )
  );
end component;


component event_cross_domain
  generic(
    POSITIVE_LOGIC_SRC_RST : boolean := FALSE
  );
  port(
    src_rst_n       : in  std_logic;
    dst_rst_n       : in  std_logic;
  
    src_clk         : in  std_logic; 
    dst_clk         : in  std_logic; 

    src_cycle       : in  std_logic;
    dst_cycle       : out std_logic
  );
end component;




type Colors is (R, Gr, Gb, B);
attribute enum_encoding : string;
attribute enum_encoding of Colors : type is "00 01 10 11";


-- Domain synchro
attribute ASYNC_REG       : string;

signal curr_db_color_space_P1     : std_logic_vector(regfile.DMA.GRAB_CSC.COLOR_SPACE'range);
signal curr_db_color_space_PIX    : std_logic_vector(regfile.DMA.GRAB_CSC.COLOR_SPACE'range);
attribute ASYNC_REG of curr_db_color_space_P1    : signal is "TRUE";
attribute ASYNC_REG of curr_db_color_space_PIX   : signal is "TRUE";

signal curr_db_reverse_y_P1   : std_logic;
signal curr_db_reverse_y_PIX  : std_logic;
attribute ASYNC_REG of curr_db_reverse_y_P1  : signal is "TRUE";
attribute ASYNC_REG of curr_db_reverse_y_PIX : signal is "TRUE";

signal curr_db_y_start0_P1    : std_logic;
signal curr_db_y_start0_PIX   : std_logic;
attribute ASYNC_REG of curr_db_y_start0_P1   : signal is "TRUE";
attribute ASYNC_REG of curr_db_y_start0_PIX  : signal is "TRUE";

-- mono pipeline
signal mono_sof            : std_logic;
signal mono_sol            : std_logic;
signal mono_data_val       : std_logic;
signal mono_data           : std_logic_vector(remap_data'range);
signal mono_eol            : std_logic;
signal mono_eof            : std_logic;


-- configuration du pipeline
signal BAYER_EXPANSION        : std_logic;
signal BAYER_RAW              : std_logic;
signal MONO                   : std_logic;

-- Gear BOX
signal gearbox_sof            : std_logic;
signal gearbox_sol            : std_logic;
signal gearbox_data_val       : std_logic;
signal gearbox_data           : std_logic_vector(Pix_type-1 downto 0);
signal gearbox_eol            : std_logic;
signal gearbox_eof            : std_logic;

signal gearbox_data_val_p     : std_logic_vector(10 downto 1); --pipeline
signal gearbox_eol_buff       : std_logic;
signal gearbox_eof_buff       : std_logic;
signal gearbox_data_dw1       : std_logic_vector(remap_data'range);
signal gearbox_data_dw2       : std_logic_vector(remap_data'range);


-- All LUT CONTROL
signal ENB_LUTGAMMA           : std_logic;
signal ENB_LUTB               : std_logic;
signal ENB_LUTG               : std_logic;
signal ENB_LUTR               : std_logic;
signal REG_LUT_WRN_STD_VECTOR : std_logic_vector(0 downto 0);
signal LUT_SS_P1              : std_logic;
signal lutgamma_RB            : std_logic_vector(Pix_type-1 downto 0);
signal lutb_RB                : std_logic_vector(Pix_type-1 downto 0);
signal lutg_RB                : std_logic_vector(Pix_type-1 downto 0);
signal lutr_RB                : std_logic_vector(Pix_type-1 downto 0);


--Gamma pipeline


signal LUT_Gamma_ena          : std_logic;
signal LUT_Gamma_addra        : std_logic_vector(Pix_type-1 downto 0);

signal gamma_sof              : std_logic;
signal gamma_sol              : std_logic;
signal gamma_data_val         : std_logic;
signal gamma_color_id         : Colors;
signal gamma_data             : std_logic_vector(Pix_type-1 downto 0);
signal gamma_eol              : std_logic;
signal gamma_eof              : std_logic;


-- Gear BOX for COLOR RAW PIXEL with Gamma correction

signal gearbox_raw_sof_in     : std_logic;
signal gearbox_raw_sol_in     : std_logic;
signal gearbox_raw_data_val_in: std_logic;
signal gearbox_raw_data_in    : std_logic_vector(Pix_type-1 downto 0);
signal gearbox_raw_eol_in     : std_logic;
signal gearbox_raw_eof_in     : std_logic;

signal raw_wb_sof             : std_logic;
signal raw_wb_sol             : std_logic;
signal raw_wb_data_val        : std_logic;
signal raw_wb_data            : std_logic_vector(color_proc_data'range);
signal raw_wb_eol             : std_logic;
signal raw_wb_eof             : std_logic;
signal raw_cntr               : std_logic_vector(1 downto 0);

--White balancing pipeline
signal gamma_data_p1          : std_logic_vector(Pix_type-1 downto 0);

signal gamma_sof_p1           : std_logic;
signal gamma_sol_p1           : std_logic;
signal gamma_data_val_p1      : std_logic;
signal gamma_color_id_p1      : Colors;
signal gamma_eol_p1           : std_logic;
signal gamma_eof_p1           : std_logic;

signal gamma_sof_p2           : std_logic;
signal gamma_sol_p2           : std_logic;
signal gamma_data_val_p2      : std_logic;
signal gamma_color_id_p2      : Colors;
signal gamma_eol_p2           : std_logic;
signal gamma_eof_p2           : std_logic;

signal gamma_sof_p3           : std_logic;
signal gamma_sol_p3           : std_logic;
signal gamma_data_val_p3      : std_logic;
signal gamma_color_id_p3      : Colors;
signal gamma_eol_p3           : std_logic;
signal gamma_eof_p3           : std_logic;

signal gamma_sof_p4           : std_logic;
signal gamma_sol_p4           : std_logic;
signal gamma_data_val_p4      : std_logic;
signal gamma_color_id_p4      : Colors;
signal gamma_eol_p4           : std_logic;
signal gamma_eof_p4           : std_logic;

signal wb_factor              : std_logic_vector(regfile.ACQ.WB_MULT1.WB_MULT_B'range);
signal wb_mult_res            : std_logic_vector(Pix_type+regfile.ACQ.WB_MULT1.WB_MULT_B'high downto 0);
signal wb_mult_en             : std_logic;

signal wb_b_acc               : std_logic_vector(30 downto 0);
signal wb_g_acc               : std_logic_vector(31 downto 0);
signal wb_r_acc               : std_logic_vector(30 downto 0);

signal wb_sof                 : std_logic;
signal wb_sol                 : std_logic;
signal wb_data_val            : std_logic;
signal wb_color_id            : Colors;
signal wb_data                : std_logic_vector(Pix_type-1 downto 0);
signal wb_eol                 : std_logic;
signal wb_eof                 : std_logic;


-- Non linear tone correction 3x 10x10 LUT

signal LUT_B_ena              : std_logic;
signal LUT_G_ena              : std_logic;
signal LUT_R_ena              : std_logic;

signal LUT_B_ena_p1           : std_logic;
signal LUT_G_ena_p1           : std_logic;
signal LUT_R_ena_p1           : std_logic;

signal LUT_B_addra            : std_logic_vector(Pix_type-1 downto 0);
signal LUT_G_addra            : std_logic_vector(Pix_type-1 downto 0);
signal LUT_R_addra            : std_logic_vector(Pix_type-1 downto 0);

signal lutr_data              : std_logic_vector(Pix_type-1 downto 0);
signal lutg_data              : std_logic_vector(Pix_type-1 downto 0);
signal lutb_data              : std_logic_vector(Pix_type-1 downto 0);

signal lut_sof                : std_logic;
signal lut_sol                : std_logic;
signal lut_data_val           : std_logic;
signal lut_color_id           : Colors;
signal lut_data               : std_logic_vector(Pix_type-1 downto 0);
signal lut_eol                : std_logic;
signal lut_eof                : std_logic;


-- Bayer
--signal first_bayer_pix    : std_logic;

signal bayer_is_line0         : std_logic;

signal bayer_read_enable      : std_logic;
signal bayer_r_ram_add        : std_logic_vector(11 downto 0);
signal bayer_write_enable     : std_logic;
signal bayer_w_ram_add        : std_logic_vector(11 downto 0);

signal BAYER_M_11             : std_logic_vector(Pix_type-1 downto 0);
signal BAYER_M_12             : std_logic_vector(Pix_type-1 downto 0);
signal BAYER_M_22             : std_logic_vector(Pix_type-1 downto 0);
signal BAYER_M_21             : std_logic_vector(Pix_type-1 downto 0);

signal lut_sol_p1             : std_logic;
signal lut_sol_p2             : std_logic;
signal lut_sol_p3             : std_logic;

signal lut_data_val_p1        : std_logic;
signal lut_data_val_p2        : std_logic;
signal lut_data_val_p3        : std_logic;

signal lut_data_p1            : std_logic_vector(Pix_type-1 downto 0);
signal lut_data_p2            : std_logic_vector(Pix_type-1 downto 0);

signal lut_eol_p1             : std_logic;
signal lut_eol_p2             : std_logic;
signal lut_eol_p3             : std_logic;
signal lut_eol_p4             : std_logic;

signal lut_eof_p1             : std_logic;
signal lut_eof_p2             : std_logic;
signal lut_eof_p3             : std_logic;

signal is_line_impaire        : std_logic;

signal bayer_mux_sel          : std_logic_vector(1 downto 0);

signal moyenne1               : std_logic_vector(Pix_type downto 0);        --11/9 bits
signal moyenne2               : std_logic_vector(Pix_type downto 0);        --11/9 bits

signal R_PIX_end_mosaic       : std_logic_vector(Pix_type-1 downto 0);
signal G_PIX_end_mosaic       : std_logic_vector(Pix_type-1 downto 0);
signal B_PIX_end_mosaic       : std_logic_vector(Pix_type-1 downto 0);

signal bayer_sof              : std_logic;
signal bayer_sol              : std_logic;
signal bayer_data_val         : std_logic;
signal bayer_data             : std_logic_vector(color_proc_data'range);
signal bayer_eol              : std_logic;
signal bayer_eof              : std_logic;

----------------------------------------------
--  Sync sysclk SOF to DMA
----------------------------------------------
signal color_proc_sof_int     : std_logic;

-- ----------------------------------------------
-- --  rule SOF checker
-- ----------------------------------------------
-- signal rule1_chk_sof          : std_logic;
-- 
-- signal rule_chk_sof_in        : std_logic;
-- signal rule_chk_sol_in        : std_logic;
-- signal rule_chk_valid_in      : std_logic;
-- signal rule_chk_eol_in        : std_logic;
-- signal rule_chk_eof_in        : std_logic;
-- 
-- signal rule1_SOF_error        : std_logic;
-- signal rule2_VALID_error      : std_logic;
-- signal rule3_EOLEOF_error     : std_logic;
-- signal rule4_SOFSOL_error     : std_logic;





BEGIN


----------------------------------------------------------------------------------------------------------
--
--  CLOCK DOMAIN CHANGE SYNCHRONIZERS
--
----------------------------------------------------------------------------------------------------------
process(pix_clk)
begin      
  if (pix_clk'event and pix_clk='1') then
    if(pix_reset='1') then
      curr_db_reverse_y_P1    <= '0';
      curr_db_reverse_y_PIX   <= '0';
      
      curr_db_y_start0_P1     <= '0';
      curr_db_y_start0_PIX    <= '0';
    
      curr_db_color_space_P1  <= (others=>'0');
      curr_db_color_space_PIX <= (others=>'0');
    else
      
      curr_db_reverse_y_P1    <= curr_db_reverse_y;
      curr_db_reverse_y_PIX   <= curr_db_reverse_y_P1;
      
      curr_db_y_start0_P1     <= curr_db_y_start(0);
      curr_db_y_start0_PIX    <= curr_db_y_start0_P1;
      
      curr_db_color_space_P1  <= curr_db_CSC.COLOR_SPACE;
      curr_db_color_space_PIX <= curr_db_color_space_P1;
    
    end if;
  end if;
end process;







process(pix_clk)
begin      
  if (pix_clk'event and pix_clk='1') then
    if(pix_reset='1') then
      BAYER_EXPANSION    <= '0';
    else
      if( curr_db_color_space_PIX="001" or         --BGR32 Pack,  enable Bayer 
          curr_db_color_space_PIX="010" or         --YUV 4:2:2,   enable Bayer
          curr_db_color_space_PIX="011" or         --BGR plannar, enable Bayer
          curr_db_color_space_PIX="100"            --Y from YUV,  enable Bayer
        ) then
        BAYER_EXPANSION     <= '1';
        BAYER_RAW           <= '0';
        MONO                <= '0';
      elsif(curr_db_color_space_PIX="101") then
        BAYER_EXPANSION     <= '0';                --BAYER RAW PIXEL 8/10 bits (WITH GAMMA LUT)
        BAYER_RAW           <= '1';
        MONO                <= '0';
      else
        BAYER_EXPANSION     <= '0';                --MONO, BYPASS ALL COLOR PROC
        BAYER_RAW           <= '0';
        MONO                <= '1';
      end if;
    end if;
  end if;
end process;



----------------------------------------------------------------------------------------------------------
--
--
--                Color LVDS x1  GearBOX : 32/40 bits 2/8    to    8/10 bits 8/8
--
--
--                ________                        ________
--           ____\   \   \_______________________\   \   \________________________________________________
-- 32/40         \ 1 \ 2 \ 3 \ 4 \ 5 \ 6 \ 7 \ 8 \ 1 \ 2 \
--                                                        ____
--   EOL     ____________________________________________\   \____________________________________________
--                                                                ____
--   EOF     ____________________________________________________\   \____________________________________
--
--
--                    ________________________________________________________________
--  8/10(P)  ________\ 1 \ 2 \ 3 \ 4 \ 5 \ 6 \ 7 \ 8 \ 1 \ 2 \ 3 \ 4 \ 5 \ 6 \ 7 \ 8 \_9___10_____________
--
--                                                                                    ____
--   EOL    _________________________________________________________________________\   \________________
--                                                                                            ____
--   EOF    _________________________________________________________________________________\   \________
--
--
--
----------------------------------------------------------------------------------------------------------

process(pix_clk)
begin
  if (pix_clk'event and pix_clk='1') then

    if(pix_reset='1' or MONO='1') then
      gearbox_data_val_p   <= (others => '0');
      gearbox_data_val     <= '0';
      gearbox_sof          <= '0';
      gearbox_sol          <= '0';
      gearbox_eol          <= '0';
      gearbox_eof          <= '0';
      
      gearbox_eol_buff     <= '0';
      gearbox_eof_buff     <= '0';
      
    else
      gearbox_data_val     <= remap_data_val or gearbox_data_val_p(1) or gearbox_data_val_p(2) or gearbox_data_val_p(3) or gearbox_data_val_p(4) or gearbox_data_val_p(5) or gearbox_data_val_p(6) or gearbox_data_val_p(7);
      gearbox_sof          <= remap_sof;
      gearbox_sol          <= remap_sol;
      
      if(remap_eol='1' and gearbox_data_val_p(2) ='1') then
        gearbox_eol_buff <= '1';
      elsif(gearbox_data_val_p(8) ='1') then
        gearbox_eol_buff <= '0';
      end if;

      if(remap_eof='1' and gearbox_data_val_p(4) ='1') then
        gearbox_eof_buff <= '1';
      elsif(gearbox_data_val_p(10) ='1') then
        gearbox_eof_buff <= '0';
      end if;
      
      gearbox_eol          <= gearbox_eol_buff and gearbox_data_val_p(8);
      gearbox_eof          <= gearbox_eof_buff and gearbox_data_val_p(10);
    end if;
 
    if(remap_data_val='1' and gearbox_data_val_p(1)='0') then
      gearbox_data_dw1      <= remap_data;
    end if;
    
    if(gearbox_data_val_p(1)='1') then
      gearbox_data_dw2 <= remap_data;
    end if;

    --if(pix_reset='1') then
    if(pix_reset='1' or MONO='1') then
      gearbox_data_val_p(1) <= '0';
    elsif(remap_data_val='1' and gearbox_data_val_p(1)='0') then
      gearbox_data_val_p(1) <= '1';
    else
      gearbox_data_val_p(1) <= '0';
    end if;

    --if(pix_reset='1') then
    if(pix_reset='1' or MONO='1') then
      gearbox_data_val_p <= (others =>'0');
    else
      gearbox_data_val_p(gearbox_data_val_p'high downto gearbox_data_val_p'low+1) <= gearbox_data_val_p(gearbox_data_val_p'high -1 downto gearbox_data_val_p'low);
    end if;

    -- il y a facon d'optimiser ca avec un shift register
    if(remap_data_val='1' and gearbox_data_val_p(1)='0') then
      gearbox_data  <= remap_data((Pix_type*1)-1 downto Pix_type*0);
    elsif(gearbox_data_val_p(1)='1') then
      gearbox_data  <= gearbox_data_dw1((Pix_type*2)-1 downto Pix_type*1);
    elsif(gearbox_data_val_p(2)='1') then
      gearbox_data  <= gearbox_data_dw1((Pix_type*3)-1 downto Pix_type*2);
    elsif(gearbox_data_val_p(3)='1') then
      gearbox_data  <= gearbox_data_dw1((Pix_type*4)-1 downto Pix_type*3);
    elsif(gearbox_data_val_p(4)='1') then
      gearbox_data  <= gearbox_data_dw2((Pix_type*1)-1 downto Pix_type*0);
    elsif(gearbox_data_val_p(5)='1') then
      gearbox_data  <= gearbox_data_dw2((Pix_type*2)-1 downto Pix_type*1);
    elsif(gearbox_data_val_p(6)='1') then
      gearbox_data  <= gearbox_data_dw2((Pix_type*3)-1 downto Pix_type*2);
    elsif(gearbox_data_val_p(7)='1') then
      gearbox_data  <= gearbox_data_dw2((Pix_type*4)-1 downto Pix_type*3);
    end if;

  end if;
end process;


--------------------------------------------------------------------
--
--
--  GAMMA CORRECTION (10x10 LUT)  + LUT RGB CONTROL
--
--
--------------------------------------------------------------------
---------------------------------------
--   PIPE on ctrl signals
---------------------------------------
process(pix_clk)
begin      
  if (pix_clk'event and pix_clk='1') then

    --if(pix_reset='1') then
    if(pix_reset='1') then
      gamma_data_val   <= '0';
      gamma_sof        <= '0';
      gamma_sol        <= '0';
      gamma_eol        <= '0';
      gamma_eof        <= '0';
    else
      gamma_data_val   <= gearbox_data_val;      -- dont eanble LUT if no need to
      gamma_sof        <= gearbox_sof;
      gamma_sol        <= gearbox_sol;
      gamma_eol        <= gearbox_eol;
      gamma_eof        <= gearbox_eof;
    end if;
  end if;
end process;


REG_LUT_WRN_STD_VECTOR(0) <=  regfile.ACQ.LUT_CTRL.LUT_WRN; --Vector()

ENB_LUTGAMMA  <= '1' when (regfile.ACQ.LUT_CTRL.LUT_SEL(1 downto 0)="00" and regfile.ACQ.LUT_CTRL.LUT_SS='1') else '0';
ENB_LUTB      <= '1' when (regfile.ACQ.LUT_CTRL.LUT_SEL(1 downto 0)="01" and regfile.ACQ.LUT_CTRL.LUT_SS='1') else '0';
ENB_LUTG      <= '1' when (regfile.ACQ.LUT_CTRL.LUT_SEL(1 downto 0)="10" and regfile.ACQ.LUT_CTRL.LUT_SS='1') else '0';
ENB_LUTR      <= '1' when (regfile.ACQ.LUT_CTRL.LUT_SEL(1 downto 0)="11" and regfile.ACQ.LUT_CTRL.LUT_SS='1') else '0';


process(sys_clk)
begin
  if rising_edge(sys_clk) then

    if (sys_reset_n = '0') then
      LUT_SS_P1  <= '0';
    else
      LUT_SS_P1  <=  regfile.ACQ.LUT_CTRL.LUT_SS;
    end if;
    
    if(LUT_SS_P1='1' and regfile.ACQ.LUT_CTRL.LUT_WRN='0') then
      if(regfile.ACQ.LUT_CTRL.LUT_SEL(1 downto 0)="00") then
        regfile.ACQ.LUT_RB.LUT_RB  <= lutgamma_RB;
      elsif(regfile.ACQ.LUT_CTRL.LUT_SEL(1 downto 0)="01") then
        regfile.ACQ.LUT_RB.LUT_RB  <= lutb_RB;
      elsif(regfile.ACQ.LUT_CTRL.LUT_SEL(1 downto 0)="10") then
        regfile.ACQ.LUT_RB.LUT_RB  <= lutg_RB;
      else
        regfile.ACQ.LUT_RB.LUT_RB  <= lutr_RB;
      end if;
    end if;

  end if;
end process;

LUT_Gamma_ena    <= remap_data_val                                  when (MONO='1') else  gearbox_data_val; 
LUT_Gamma_addra  <= remap_data((Pix_type*1)-1 downto (Pix_type*0))  when (MONO='1') else  gearbox_data;


XLUT_GAMMA : xil_lut1010
  port map(
    clka   =>  pix_clk,
    ena    =>  LUT_Gamma_ena,
    wea    =>  "0",
    addra  =>  LUT_Gamma_addra,
    dina   =>  (others=>'0'),
    douta  =>  gamma_data,
    
    clkb   =>  sys_clk,
    enb    =>  ENB_LUTGAMMA,
    web    =>  REG_LUT_WRN_STD_VECTOR,
    addrb  =>  regfile.ACQ.LUT_CTRL.LUT_ADD,
    doutb  =>  lutgamma_RB,
    dinb   =>  regfile.ACQ.LUT_CTRL.LUT_DATA_W
);



--------------------------------------------------------------------
--
--
--      Gb- B-Gb- B-Gb- B-Gb-B0    B0       7   0
--       R-Gr- R-Gr- R-Gr- R-Gr    Gr       6   1
--      Gb- B-Gb- B-Gb- B-Gb-B0    B0       5   2
--       R-Gr- R-Gr- R-Gr- R-Gr    Gr       4   3
--      Gb- B-Gb- B-Gb- B-Gb-B0    B0       3   4
--       R-Gr- R-Gr- R-Gr- R-Gr    Gr       2   5
--      Gb- B-Gb- B-Gb- B-Gb-B0    B0       1   6
--       R-Gr- R-Gr- R-Gr- R-Gr    Gr       0   7
--      ^ 
--       Pixel 0 in not reverse Y mode and start line = 0
--
--       R : "00"
--      Gr : "01"
--      Gb : "10"
--       B : "11"
--
--------------------------------------------------------------------
--
-- Add a lut_color_id(1:0) sync with the gamma data out
-- to identify the color of the pixel
--
--  "00" is R
--  "01" is Gr
--  "10" is Gb
--  "11" is B
--
--
process (pix_clk)
begin      
  if (pix_clk'event and pix_clk='1') then
    if(gamma_sof='1') then
      if(curr_db_reverse_y_PIX='0') then    --NO REVY
        if(curr_db_y_start0_PIX='0') then   --Ligne paire   : R
          gamma_color_id      <= R;            
        else                                --Ligne impaire : Gb
          gamma_color_id      <= Gb;
        end if;
      else                                  --REVY
        if(curr_db_y_start0_PIX='0') then   
          gamma_color_id      <= Gb;        --Ligne paire   : Gb
        else
          gamma_color_id      <= R;         --Ligne impaire : R
        end if;
      end if;
      
    elsif(gamma_eol='1') then               -- At EOL, remember that resolution is always a kernel size

      if(gamma_color_id=R) then
        gamma_color_id      <= Gb;          --R  -> Gb : REVY/notREVy
      else
        gamma_color_id      <= R;           --Gb -> R (G2 is Green of BLUE line)
      end if;
      
    elsif(gamma_data_val='1') then
      if(gamma_color_id=R) then
        gamma_color_id      <= Gr;          --R  -> Gr
      elsif(gamma_color_id=Gr) then
        gamma_color_id      <= R;           --Gr -> R
      elsif(gamma_color_id=Gb) then
        gamma_color_id      <= B;           --Gb -> B
      else
        gamma_color_id      <= Gb;          --B  -> Gb
      end if;
    end if;
  end if;
end process;


----------------------------------------------------------------------------------------------------------
--  HW assisted WB : Color ACCUMULATOR
--
--  Accumulateurs juste actifs avec le RAW ? ou on veux les avoir en tout le temps en couleur?
--  -> pour le moment juste en mode RAW.
--
------------------------------------------------------------------------------------------------------------
process (pix_clk)
begin      
  if (pix_clk'event and pix_clk='1') then
    if(BAYER_RAW='1') then 
      if(gamma_sof='1') then
        wb_b_acc <= (others=>'0');
      elsif(gamma_data_val='1') then
        if(gamma_color_id=B) then
          wb_b_acc <= wb_b_acc + gamma_data(gamma_data'high downto gamma_data'high-7);  --Counting 8 MSB bits only
        end if;
      end if;

      if(gamma_sof='1') then
        wb_g_acc <= (others=>'0');
      elsif(gamma_data_val='1') then
        if(gamma_color_id=Gr or gamma_color_id=Gb) then
          wb_g_acc <= wb_g_acc + gamma_data(gamma_data'high downto gamma_data'high-7);  --Counting 8 MSB bits only
        end if;
      end if;

      if(gamma_sof='1') then
        wb_r_acc <= (others=>'0');
      elsif(gamma_data_val='1') then
        if(gamma_color_id=R) then
          wb_r_acc <= wb_r_acc + gamma_data(gamma_data'high downto gamma_data'high-7);  --Counting 8 MSB bits only
        end if;
      end if;
    
      --if(gamma_eof='1') then                
      --  wb_b_acc_DB <= wb_b_acc;           -- ON pourrait faire sauter ce DB, si le driver fait bien le travail
      --  wb_g_acc_DB <= wb_g_acc;           -- ON pourrait faire sauter ce DB, si le driver fait bien le travail
      --  wb_r_acc_DB <= wb_r_acc;           -- ON pourrait faire sauter ce DB, si le driver fait bien le travail
      --end if
    end if;
  end if;
end process;

regfile.ACQ.wb_B_ACC.B_ACC <= wb_b_acc;
regfile.ACQ.WB_G_ACC.G_ACC <= wb_g_acc;
regfile.ACQ.WB_R_ACC.R_ACC <= wb_r_acc;



--------------------------------------------------------------------
--
--
--  WHITE BALANCE
--
--
--  Registre multiplicatif, 4 bit entier, 12 decimal
--
--  _ _ _ _ . _ _ _ _ _ _ _ _ _ _ _ _
--
--  La valeur unitaire multiplicative est donc 0x1000
--
--  Le pixel 10 bits de sortie est a :         21 downto 12
--  Le overflow de la multiplication est a :   25 downto 22
--  Les bits 11 downto 0 sont non significatifs.
--
------------------------------------------------------------------------
process (pix_clk)
begin      
  if (pix_clk'event and pix_clk='1') then

   wb_mult_en <= gamma_data_val or gamma_data_val_p1 or gamma_data_val_p2;

   -- Load the factor one clk before
   if(gamma_data_val='1') then
     if(gamma_color_id=R) then
       wb_factor <= regfile.ACQ.WB_MULT2.WB_MULT_R;    --R
     elsif(gamma_color_id=B) then
       wb_factor <= regfile.ACQ.WB_MULT1.WB_MULT_B;    --B
     else
       wb_factor <= regfile.ACQ.WB_MULT1.WB_MULT_G;    --G
     end if;
   end if;
   
  end if;
end process;




X_xil_wb_mult : xil_wb_mult
  Port map ( 
    CLK => pix_clk,
    A   => gamma_data_p1,
    B   => wb_factor,
    CE  => wb_mult_en,
    P   => wb_mult_res
   );


--  Clipping of the multiplication
process (pix_clk)
begin
  if rising_edge(pix_clk) then 
    if(wb_mult_res((wb_mult_res'high) downto (wb_mult_res'high-3) )= "0000") then
      wb_data  <= wb_mult_res ((wb_mult_res'high-4) downto (wb_mult_res'high-4-Pix_type+1) );
    else 
      wb_data  <= (others=>'1');        -- clip it to max value
    end if;
  end if;
end process;


process (pix_clk)
begin      
  if (pix_clk'event and pix_clk='1') then
    
    gamma_data_p1      <= gamma_data;

    gamma_color_id_p1  <= gamma_color_id;
    gamma_color_id_p2  <= gamma_color_id_p1;
    gamma_color_id_p3  <= gamma_color_id_p2;
    gamma_color_id_p4  <= gamma_color_id_p3;
    wb_color_id        <= gamma_color_id_p4;

    if(pix_reset='1' or BAYER_EXPANSION='0') then
    --if(pix_reset='1') then
      gamma_sof_p1      <= '0';
      gamma_sol_p1      <= '0';
      gamma_data_val_p1 <= '0';
      gamma_eol_p1      <= '0';
      gamma_eof_p1      <= '0';

      gamma_sof_p2      <= '0';
      gamma_sol_p2      <= '0';
      gamma_data_val_p2 <= '0';
      gamma_eol_p2      <= '0';
      gamma_eof_p2      <= '0';

      gamma_sof_p3      <= '0';
      gamma_sol_p3      <= '0';
      gamma_data_val_p3 <= '0';
      gamma_eol_p3      <= '0';
      gamma_eof_p3      <= '0';

      gamma_sof_p4      <= '0';
      gamma_sol_p4      <= '0';
      gamma_data_val_p4 <= '0';
      gamma_eol_p4      <= '0';
      gamma_eof_p4      <= '0';

      wb_sof            <= '0';
      wb_sol            <= '0';
      wb_data_val       <= '0';
      wb_eol            <= '0';
      wb_eof            <= '0';

    else
      gamma_sof_p1      <= gamma_sof;
      gamma_sol_p1      <= gamma_sol;
      gamma_data_val_p1 <= gamma_data_val;
      gamma_eol_p1      <= gamma_eol;
      gamma_eof_p1      <= gamma_eof;

      gamma_sof_p2      <= gamma_sof_p1;
      gamma_sol_p2      <= gamma_sol_p1;
      gamma_data_val_p2 <= gamma_data_val_p1;
      gamma_eol_p2      <= gamma_eol_p1;
      gamma_eof_p2      <= gamma_eof_p1;

      gamma_sof_p3      <= gamma_sof_p2;
      gamma_sol_p3      <= gamma_sol_p2;
      gamma_data_val_p3 <= gamma_data_val_p2;
      gamma_eol_p3      <= gamma_eol_p2;
      gamma_eof_p3      <= gamma_eof_p2;

      gamma_sof_p4      <= gamma_sof_p3;
      gamma_sol_p4      <= gamma_sol_p3;
      gamma_data_val_p4 <= gamma_data_val_p3;
      gamma_eol_p4      <= gamma_eol_p3;
      gamma_eof_p4      <= gamma_eof_p3;

      wb_sof            <= gamma_sof_p4;
      wb_sol            <= gamma_sol_p4;
      wb_data_val       <= gamma_data_val_p4;
      wb_eol            <= gamma_eol_p4;
      wb_eof            <= gamma_eof_p4;
    end if;



  end if;
end process;





--------------------------------------------------------------------
--
--
--  NON LINEAR TONE CORRECTION 3x 10x10 LUT
--
--
--------------------------------------------------------------------

process (pix_clk)
begin      
  if (pix_clk'event and pix_clk='1') then

    lut_color_id   <= wb_color_id;

    --if(pix_reset='1') then
    if(pix_reset='1' or BAYER_EXPANSION='0') then
      lut_sof        <= '0';
      lut_sol        <= '0';
      lut_data_val   <= '0';
      lut_eol        <= '0';
      lut_eof        <= '0';
    else
      lut_sof        <= wb_sof;
      lut_sol        <= wb_sol;
      lut_data_val   <= wb_data_val;
      lut_eol        <= wb_eol;
      lut_eof        <= wb_eof;
      
      LUT_B_ena_p1   <= LUT_B_ena;
      LUT_G_ena_p1   <= LUT_G_ena;
      LUT_R_ena_p1   <= LUT_R_ena;
    end if;
  end if;
end process;


--       R : "00"
--      Gr : "01"
--      Gb : "10"
--       B : "11"



LUT_B_ena     <= remap_data_val when (MONO='1') else '1' when(wb_data_val='1' and  wb_color_id=B)                        else '0';
LUT_G_ena     <= remap_data_val when (MONO='1') else '1' when(wb_data_val='1' and  ( wb_color_id=Gr or wb_color_id=Gb) ) else '0';
LUT_R_ena     <= remap_data_val when (MONO='1') else '1' when(wb_data_val='1' and  wb_color_id=R)                        else '0';

LUT_B_addra   <= remap_data((Pix_type*2)-1 downto (Pix_type*1))     when MONO='1' else  wb_data;
LUT_G_addra   <= remap_data((Pix_type*3)-1 downto (Pix_type*2))     when MONO='1' else  wb_data;
LUT_R_addra   <= remap_data((Pix_type*4)-1 downto (Pix_type*3))     when MONO='1' else  wb_data;




XLUT_B : xil_lut1010
  port map(
    clka   =>  pix_clk,
    ena    =>  LUT_B_ena,
    wea    =>  "0",
    addra  =>  LUT_B_addra,
    dina   =>  (others => '0'),
    douta  =>  lutb_data,
    
    clkb   =>  sys_clk,   
    enb    =>  ENB_LUTB, 
    web    =>  REG_LUT_WRN_STD_VECTOR,
    addrb  =>  regfile.ACQ.LUT_CTRL.LUT_ADD,
    doutb  =>  lutB_RB,
    dinb   =>  regfile.ACQ.LUT_CTRL.LUT_DATA_W
);


XLUT_G : xil_lut1010
  port map(
    clka   =>  pix_clk,
    ena    =>  LUT_G_ena,
    wea    =>  "0",
    addra  =>  LUT_G_addra,
    dina   =>  (others => '0'),
    douta  =>  lutg_data,
    
    clkb   =>  sys_clk,   
    enb    =>  ENB_LUTG, 
    web    =>  REG_LUT_WRN_STD_VECTOR,
    addrb  =>  regfile.ACQ.LUT_CTRL.LUT_ADD,
    doutb  =>  lutG_RB,
    dinb   =>  regfile.ACQ.LUT_CTRL.LUT_DATA_W
);


XLUT_R : xil_lut1010
  port map(
    clka   =>  pix_clk,
    ena    =>  LUT_R_ena,
    wea    =>  "0",
    addra  =>  LUT_R_addra,
    dina   =>  (others => '0'),
    douta  =>  lutr_data,
    
    clkb   =>  sys_clk,   
    enb    =>  ENB_LUTR, 
    web    =>  REG_LUT_WRN_STD_VECTOR,
    addrb  =>  regfile.ACQ.LUT_CTRL.LUT_ADD,
    doutb  =>  lutR_RB,
    dinb   =>  regfile.ACQ.LUT_CTRL.LUT_DATA_W
);




process (LUT_B_ena_p1, LUT_G_ena_p1, LUT_R_ena_p1, lutr_data, lutg_data, lutb_data)
begin      
  if(lut_r_ena_p1= '1') then
    lut_data <= lutr_data;
  elsif(lut_g_ena_p1= '1') then
    lut_data <= lutg_data;
  else
    lut_data <= lutb_data;
  end if;
end process;


--------------------------------------------------------------------
--
--
--  BAYER Correction
--
--
--------------------------------------------------------------------


-------------------------------------
--  Pipelines needed
-------------------------------------
process(pix_clk)
begin
  if rising_edge(pix_clk) then

    lut_data_p1         <= lut_data;
    lut_data_p2         <= lut_data_p1;

    --if(pix_reset='1') then
    if(pix_reset='1' or BAYER_EXPANSION='0') then
      lut_sol_p1          <= '0';
      lut_sol_p2          <= '0';
      lut_sol_p3          <= '0';

      lut_data_val_p1     <= '0';
      lut_data_val_p2     <= '0';
      lut_data_val_p3     <= '0';

      lut_eol_p1          <= '0';
      lut_eol_p2          <= '0';
      lut_eol_p3          <= '0';
      lut_eol_p4          <= '0';

      lut_eof_p1          <= '0';
      lut_eof_p2          <= '0';
      lut_eof_p3          <= '0';

      bayer_sof           <= '0';
      bayer_sol           <= '0';
      bayer_data_val      <= '0';
      bayer_eol           <= '0';
      bayer_eof           <= '0';

    else

      lut_sol_p1          <= lut_sol;
      lut_sol_p2          <= lut_sol_p1;
      lut_sol_p3          <= lut_sol_p2;

      lut_data_val_p1     <= lut_data_val;
      lut_data_val_p2     <= lut_data_val_p1;
      lut_data_val_p3     <= lut_data_val_p2;

      lut_eol_p1          <= lut_eol;
      lut_eol_p2          <= lut_eol_p1;
      lut_eol_p3          <= lut_eol_p2;
      lut_eol_p4          <= lut_eol_p3;       --use in line0

      lut_eof_p1          <= lut_eof;
      lut_eof_p2          <= lut_eof_p1;
      lut_eof_p3          <= lut_eof_p2;

      bayer_sof           <= lut_sof;
      bayer_sol           <= lut_sol_p3      and not(bayer_is_line0);
      bayer_data_val      <= lut_data_val_p3 and not(bayer_is_line0);
      bayer_eol           <= lut_eol_p3      and not(bayer_is_line0);
      bayer_eof           <= lut_eof_p3;

    end if;
  end if;
end process;



-------------------------------------
--  LINE 0 STAT
-------------------------------------
process(pix_clk)
begin
  if rising_edge(pix_clk) then
    if(pix_reset='1' or BAYER_EXPANSION='0') then
      bayer_is_line0 <= '0';
    elsif(lut_sof= '1') then
      bayer_is_line0 <= '1';
    elsif(lut_eol_p4='1') then
      bayer_is_line0 <= '0';
    end if;  
  end if;
end process;    

-------------------------------------
--  WRITE LOGIC
-------------------------------------
process(pix_clk)
begin
  if rising_edge(pix_clk) then
    if(lut_sol = '1') then
      bayer_w_ram_add <= (others => '0');
    elsif(lut_data_val_p2 = '1') then
      bayer_w_ram_add <=  bayer_w_ram_add + '1';
    end if;
    
    if(pix_reset='1' or BAYER_EXPANSION='0') then
      BAYER_M_22(0)  <= (others => '0');
	  BAYER_M_22(1)  <= (others => '0');

    elsif(lut_data_val_p1 = '1' and bayer_is_line0 = '0') then
      BAYER_M_22(0)  <= lut_data_p1(7 downto 0);
      BAYER_M_22(1)  <= lut_data_p1(15 downto 8);
	  
    end if;
    
    if(pix_reset='1' or BAYER_EXPANSION='0') then
      BAYER_M_21(0)  <= (others => '0');
      BAYER_M_21(1)  <= (others => '0');
    elsif(lut_data_val_p2 = '1' and bayer_is_line0 = '0') then
      BAYER_M_21(0)  <= BAYER_M_22(0);
      BAYER_M_21(1)  <= BAYER_M_22(1);

    end if;
    
  end if;
end process;

--------------------------------------
--  RAM
---------------------------------------

bayer_write_enable <= lut_data_val_p2;

X1_ram_bayer : xil_ram_bayer
 port map(
   clka  => pix_clk,
   ena   => bayer_write_enable,
   wea   => "1",                 --always write on this port
   addra => bayer_w_ram_add,
   dina  => lut_data_p2,
   
   clkb  => pix_clk,
   enb   => bayer_read_enable,
   addrb => bayer_r_ram_add,
   doutb => bayer_r_ram_dat
 );


BAYER_M_12(0) <= bayer_r_ram_dat(7 downto 0);
BAYER_M_12(1) <= bayer_r_ram_dat(15 downto 8);



-------------------------------------
--  READ LOGIC
-------------------------------------
process(pix_clk)
begin
  if rising_edge(pix_clk) then
    if(pix_reset='1' or BAYER_EXPANSION='0') then
      bayer_read_enable  <= '0';
    else
      bayer_read_enable <= lut_data_val and not(bayer_is_line0);
    end if;
    
    if(lut_sol = '1') then
      bayer_r_ram_add   <= (others => '0');
    elsif(lut_data_val_p1 = '1' and bayer_is_line0 = '0') then
      bayer_r_ram_add <=  bayer_r_ram_add + '1';
    end if;
    
    if(pix_reset='1' or BAYER_EXPANSION='0') then
      BAYER_M_11(0)   <= (others => '0');
      BAYER_M_11(1)   <= (others => '0');
    elsif(lut_data_val_p2 = '1' and bayer_is_line0 = '0') then
      BAYER_M_11(0) <= BAYER_M_12(0);
      BAYER_M_11(1) <= BAYER_M_12(1);
	  
    end if;
    
  end if;
end process;



-------------------------------------------------
--
--       MATRIX CALCULATION
--
--          -------------
--         \ M_11 \ M_12 \  <---- READ
--         \______\______\
--         \ M_21 \ M_22 \  <---- WRITE
--         \______\______\
--
-------------------------------------------------
-------------------------------------
--  LINE PAIR / IMPAIRE
-------------------------------------
process(pix_clk)
begin
  if rising_edge(pix_clk) then
    --if(pix_reset='1') then
    if(pix_reset='1' or BAYER_EXPANSION='0') then
      is_line_impaire <= '0';
    elsif(lut_sof= '1') then
      is_line_impaire <= '1';         -- XGS On commence toujours sur une ligne pair . On commence a traiter une ligne en retard, donc au SOF on reset a 1 !!!
    elsif(lut_eol_p2='1') then
      is_line_impaire <= not(is_line_impaire);
    end if;
    

  end if;
end process;




-------------------------------------
--  COMPTEUR MODE BAYER 
-------------------------------------
--
--          -------------
--         \ M_11 \ M_12 \
--         \______\______\
--         \ M_21 \ M_22 \
--         \______\______\
--
--
--         bayer_mux_sel
--     
--     (1)   (0)   (3)   (2)   
--     R-G   G-R   G-B   B-G
--     G-B   B-G   R-G   G-R
--

process(pix_clk)
begin
  if rising_edge(pix_clk) then
    --if(pix_reset='1') then
    if(pix_reset='1' or BAYER_EXPANSION='0') then
      bayer_mux_sel  <=  "00";
    else                                                           -- XGS ALWAYS RG TYPE BAYER 
      if(is_line_impaire = '0') then  
        bayer_mux_sel(0)  <=  "01";
        bayer_mux_sel(1)  <=  "00";
      elsif(is_line_impaire = '0') then  
        bayer_mux_sel(0)  <=  "00";
        bayer_mux_sel(1)  <=  "01";
      elsif(is_line_impaire = '1') then  
        bayer_mux_sel(0)  <=  "11";
        bayer_mux_sel(1)  <=  "10";
      else
        bayer_mux_sel(0)  <=  "10";
        bayer_mux_sel(1)  <=  "11";
      end if;
    end if;
  end if;
end process;    



-- generate 2 Bayer cores


Gen_Bayer_proc : for i in 0 to 1  generate
begin

  -------------------------------------
  --  BAYER MUXES 
  -------------------------------------
  --
  --          -------------
  --         \ M_11 \ M_12 \
  --         \______\______\
  --         \      \      \
  --         \ M_21 \ M_22 \
  --         \______\______\
  --
  
  moyenne1(i) <= std_logic_vector(std_logic_vector('0' & BAYER_M_12(i)) + std_logic_vector('0' & BAYER_M_21(i)));
  moyenne2(i) <= std_logic_vector(std_logic_vector('0' & BAYER_M_11(i)) + std_logic_vector('0' & BAYER_M_22(i)));
  
  process(pix_clk)
  begin
    if rising_edge(pix_clk) then
  
      ----------
      -- RED
      ----------
      if(lut_data_val_p3='1') then
        if(bayer_mux_sel(i) = "01") then
          R_PIX_end_mosaic(i) <= BAYER_M_11(i);
        elsif(bayer_mux_sel(i) = "00") then
          R_PIX_end_mosaic(i) <= BAYER_M_12(i);
        elsif(bayer_mux_sel(i) = "10") then
          R_PIX_end_mosaic(i) <= BAYER_M_22(i);
        else
          R_PIX_end_mosaic(i) <= BAYER_M_21(i);
        end if;
      end if;
      
      ----------
      -- GREEN
      ----------
      if(lut_data_val_p3='1') then
        if(bayer_mux_sel(i) = "01" or bayer_mux_sel(i) = "10") then
          G_PIX_end_mosaic(i) <= moyenne1(i)(pix_type downto 1);
        else
          G_PIX_end_mosaic(i) <= moyenne2(i)(pix_type downto 1);
        end if;
      end if;
      
      ----------
      -- BLUE
      ----------
      if(lut_data_val_p3='1') then
        if(bayer_mux_sel(i) = "10") then       -- bypass here if needed!!
          B_PIX_end_mosaic(i) <= BAYER_M_11(i);
        elsif(bayer_mux_sel(i) = "11") then
          B_PIX_end_mosaic(i) <= BAYER_M_12(i);
        elsif(bayer_mux_sel(i) = "01") then
          B_PIX_end_mosaic(i) <= BAYER_M_22(i);
        else
          B_PIX_end_mosaic(i) <= BAYER_M_21(i);
        end if;
      end if;
      
    end if;
  end process;
  


end generate;


bayer_data      <= "00000000" & R_PIX_end_mosaic(0) & G_PIX_end_mosaic(0) & B_PIX_end_mosaic(0) &
                   "00000000" & R_PIX_end_mosaic(1) & G_PIX_end_mosaic(1) & B_PIX_end_mosaic(1);







----------------------------------------------------------------------------------------------------------
--
--
--                Color LVDS x1  GearBOX : 8/10 bits 8/8 to 32/40 bits 2/8
--
--                 This is for the RAW WB pixels needed by the driver
--
--
--                    ________________________________________________________________
--  8/10(P)  ________\ 1 \ 2 \ 3 \ 4 \ 5 \ 6 \ 7 \ 8 \ 1 \ 2 \ 3 \ 4 \ 5 \ 6 \ 7 \ 8 \_9___10_____________
--
--                                                                                    ____
--   EOL    _________________________________________________________________________\   \________________
--                                                                                            ____
--   EOF    _________________________________________________________________________________\   \________
--
--                                    ____            ____            ____            ____
--           ________________________\ 1 \___________\ 2 \___________\ 3 \___________\ 4 \________________
-- 32/40        
--                                                                                        ____
--   EOL     ____________________________________________________________________________\   \____________
--                                                                                                 ____
--   EOF     _____________________________________________________________________________________\   \___
--
--
----------------------------------------------------------------------------------------------------------

gearbox_raw_sof_in      <=  gamma_sof;
gearbox_raw_sol_in      <=  gamma_sol;
gearbox_raw_data_val_in <=  gamma_data_val;
gearbox_raw_data_in     <=  gamma_data;
gearbox_raw_eol_in      <=  gamma_eol;
gearbox_raw_eof_in      <=  gamma_eof;


process (pix_clk)
begin      
  if (pix_clk'event and pix_clk='1') then

    if(pix_reset='1' or BAYER_RAW='0') then
      raw_wb_data_val     <= '0';
      raw_wb_sof          <= '0';
      raw_wb_sol          <= '0';
      raw_wb_eol          <= '0';
      raw_wb_eof          <= '0';
      raw_cntr            <= (others=>'0');

    else
    
      raw_wb_sof <= gearbox_raw_sof_in;
      raw_wb_sol <= gearbox_raw_sol_in;
      raw_wb_eol <= gearbox_raw_eol_in;
      raw_wb_eof <= gearbox_raw_eof_in;
    
      if(gearbox_raw_data_val_in='1') then
        if(raw_cntr="11") then
          raw_wb_data_val          <= '1';
        else
          raw_wb_data_val          <= '0';
        end if;
      else
        raw_wb_data_val <= '0';
      end if;

      if(gearbox_raw_sol_in='1') then
        raw_cntr <= (others=>'0');
      elsif(gearbox_raw_data_val_in='1') then
        raw_cntr <= raw_cntr+'1';
      end if;
      
    end if;

    if(gearbox_raw_data_val_in='1') then
      if(raw_cntr="00") then
        raw_wb_data((1*Pix_type)-1 downto (0*Pix_type)) <= gearbox_raw_data_in;
      elsif(raw_cntr="01") then
        raw_wb_data((2*Pix_type)-1 downto (1*Pix_type)) <= gearbox_raw_data_in;
      elsif(raw_cntr="10") then
        raw_wb_data((3*Pix_type)-1 downto (2*Pix_type)) <= gearbox_raw_data_in;
      else
        raw_wb_data((4*Pix_type)-1 downto (3*Pix_type)) <= gearbox_raw_data_in;
      end if;
    else
      raw_wb_data     <= raw_wb_data;
    end if;
   
  end if;
end process;




------------------------------------
--
--   COLOR_PROC OUTPUTS
--
------------------------------------
process(pix_clk)
begin      
  if (pix_clk'event and pix_clk='1') then
    if(pix_reset='1') then
      color_proc_sof_int      <= '0';
      color_proc_sol          <= '0';
      color_proc_data_val     <= '0';
      color_proc_eol          <= '0';
      color_proc_eof          <= '0';
      color_proc_eof_abort    <= '0';
      
    elsif(BAYER_EXPANSION='1') then
      color_proc_sof_int      <= bayer_sof;
      color_proc_sol          <= bayer_sol                                   after 1  ps; -- pour corriger probleme de hold cause par la pix_clk2 re-assignee;
      color_proc_data_val     <= bayer_data_val                              after 1  ps; -- pour corriger probleme de hold cause par la pix_clk2 re-assignee;
      color_proc_eol          <= bayer_eol                                   after 1  ps; -- pour corriger probleme de hold cause par la pix_clk2 re-assignee;
      color_proc_eof          <= bayer_eof                                   after 1  ps; -- pour corriger probleme de hold cause par la pix_clk2 re-assignee;
      color_proc_eof_abort    <= (bayer_eof and abort_readout_datapath_pix)  after 1  ps; -- pour corriger probleme de hold cause par la pix_clk2 re-assignee;
    else
      color_proc_sof_int      <= raw_wb_sof;
      color_proc_sol          <= raw_wb_sol                                  after 1  ps; -- pour corriger probleme de hold cause par la pix_clk2 re-assignee;
      color_proc_data_val     <= raw_wb_data_val                             after 1  ps; -- pour corriger probleme de hold cause par la pix_clk2 re-assignee;
      color_proc_eol          <= raw_wb_eol                                  after 1  ps; -- pour corriger probleme de hold cause par la pix_clk2 re-assignee;
      color_proc_eof          <= raw_wb_eof                                  after 1  ps; -- pour corriger probleme de hold cause par la pix_clk2 re-assignee;
      color_proc_eof_abort    <= (raw_wb_eof and abort_readout_datapath_pix) after 1  ps; -- pour corriger probleme de hold cause par la pix_clk2 re-assignee;
    end if;
    
    if(BAYER_EXPANSION='1') then
      color_proc_data         <= bayer_data     after 1  ps;  -- pour corriger probleme de hold cause par la pix_clk2 re-assignee;
    else
      color_proc_data         <= raw_wb_data    after 1  ps;  -- pour corriger probleme de hold cause par la pix_clk2 re-assignee;
    end if;  
    
  end if;  
end process;




color_proc_sof  <=  color_proc_sof_int after 1  ps;           -- pour corriger probleme de hold cause par la pix_clk2 re-assignee;








End functional;




