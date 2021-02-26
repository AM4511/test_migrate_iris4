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
--               _________             _________           __________            _________ 
--    2x10bpp   |         |  2x10bpp  |         | 2x8bpp  |          | 2x24bpp  |         | (2x24bpp) 
--   ---------->|   DPC   |---------->|   WB    |-------->|  Bayer   |--------->|   Lut   |----------->  RGB24 : REG_BAYER_EN=1
--              |_________|     |     |_________|         |__________|          |_________|
--                              |                                                
--                               --------------------------------------------------------------------->  RAW8  : REG_BAYER_EN=0
--
-------------------------------------------------------------------------------

library ieee;
 use ieee.std_logic_1164.all;
 use IEEE.std_logic_unsigned.all;
 use IEEE.numeric_std.all;
 use IEEE.std_logic_arith.all;
 use std.textio.all ; 


entity xgs_color_proc is
   generic( DPC_CORR_PIXELS_DEPTH         : integer := 9    --6=>64,  7=>128, 8=>256, 9=>512, 10=>1024
            
		  );   
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
	       --s_axis_tready_int                       : in   std_logic;   --temporaire on va juste se hooker
           s_axis_tuser                            : in   std_logic_vector(3 downto 0);
           s_axis_tlast                            : in   std_logic;
           s_axis_tdata                            : in   std_logic_vector(19 downto 0);	
	       
           ---------------------------------------------------------------------
           -- AXI out
           ---------------------------------------------------------------------
	       m_axis_tready                           : in  std_logic;
           m_axis_tvalid                           : out std_logic;
           m_axis_tuser                            : out std_logic_vector(3 downto 0);
           m_axis_tlast                            : out std_logic;
           m_axis_tdata                            : out std_logic_vector(63 downto 0);
		   
           ---------------------------------------------------------------------
           -- Grab params
           ---------------------------------------------------------------------		   
		   curr_Xstart                             : in    std_logic_vector(12 downto 0) :=(others=>'0');   --pixel
           curr_Xend                               : in    std_logic_vector(12 downto 0) :=(others=>'1');   --pixel
           curr_Ystart                             : in    std_logic_vector(11 downto 0) :=(others=>'0');   --line
           curr_Yend                               : in    std_logic_vector(11 downto 0) :=(others=>'1');   --line    
           curr_Ysub                               : in    std_logic := '0';  
											      
	       load_dma_context_EOFOT                  : in    std_logic := '0';  -- in axi_clk
	       
           ---------------------------------------------------------------------
           -- Registers
           ---------------------------------------------------------------------
           REG_dpc_list_length                     : out   std_logic_vector(11 downto 0);
	       REG_dpc_ver                             : out   std_logic_vector(3 downto 0);
											     
           REG_dpc_enable                          : in    std_logic :='1';
											     
           REG_dpc_pattern0_cfg                    : in    std_logic :='0';
											     
           REG_dpc_list_wrn                        : in    std_logic; 
           REG_dpc_list_add                        : in    std_logic_vector(DPC_CORR_PIXELS_DEPTH-1 downto 0); 
           REG_dpc_list_ss                         : in    std_logic;
           REG_dpc_list_count                      : in    std_logic_vector(DPC_CORR_PIXELS_DEPTH-1 downto 0);
											     
           REG_dpc_list_corr_pattern               : in    std_logic_vector(7 downto 0);
           REG_dpc_list_corr_y                     : in    std_logic_vector(11 downto 0);
           REG_dpc_list_corr_x                     : in    std_logic_vector(12 downto 0);
											     
           REG_dpc_list_corr_rd                    : out   std_logic_vector(32 downto 0);   
         
           REG_wb_b_acc                            : out std_logic_vector(30 downto 0);
           REG_wb_g_acc                            : out std_logic_vector(31 downto 0);
           REG_wb_r_acc                            : out std_logic_vector(30 downto 0);

		   REG_WB_MULT_R                           : in std_logic_vector(15 downto 0):= "0001000000000000";
		   REG_WB_MULT_G                           : in std_logic_vector(15 downto 0):= "0001000000000000";
		   REG_WB_MULT_B                           : in std_logic_vector(15 downto 0):= "0001000000000000";
		   	   
           REG_BAYER_EN                            : in std_logic:='0';	   
			   
           REG_LUT_BYPASS                          : in std_logic;
		   REG_LUT_SEL                             : in std_logic_vector(3 downto 0);
		   REG_LUT_SS                              : in std_logic;
		   REG_LUT_WRN                             : in std_logic;
           REG_LUT_ADD                             : in std_logic_vector;
           REG_LUT_DATA_W                          : in std_logic_vector

		   
        );
end xgs_color_proc;


------------------------------------------------------
-- Begin architecture structure
------------------------------------------------------

architecture functional of xgs_color_proc is


component dpc_filter_color 
   generic( DPC_CORR_PIXELS_DEPTH         : integer := 6    --6=>64,  7=>128, 8=>256, 9=>512, 10=>1024
		  );
   port(
    ---------------------------------------------------------------------
    -- Axi domain reset and clock signals
    ---------------------------------------------------------------------
    axi_clk                              : in    std_logic;
    axi_reset_n                          : in    std_logic;

    curr_Xstart                          : in    std_logic_vector(12 downto 0) :=(others=>'0');   --pixel
    curr_Xend                            : in    std_logic_vector(12 downto 0) :=(others=>'1');   --pixel
	
    curr_Ystart                          : in    std_logic_vector(11 downto 0) :=(others=>'0');   --line
    curr_Yend                            : in    std_logic_vector(11 downto 0) :=(others=>'1');   --line    
	
    curr_Ysub                            : in    std_logic := '0';  
    
	load_dma_context_EOFOT               : in    std_logic := '0';  -- in axi_clk
	
    ---------------------------------------------------------------------
    -- Registers
    ---------------------------------------------------------------------
    REG_dpc_list_length                  : out   std_logic_vector(11 downto 0);
	REG_dpc_ver                          : out   std_logic_vector(3 downto 0);
	
    REG_dpc_enable                       : in    std_logic :='1';

    REG_dpc_pattern0_cfg                 : in    std_logic :='0';
      
    REG_dpc_list_wrn                     : in    std_logic; 
    REG_dpc_list_add                     : in    std_logic_vector(DPC_CORR_PIXELS_DEPTH-1 downto 0); 
    REG_dpc_list_ss                      : in    std_logic;
    REG_dpc_list_count                   : in    std_logic_vector(DPC_CORR_PIXELS_DEPTH-1 downto 0);

    REG_dpc_list_corr_pattern            : in    std_logic_vector(7 downto 0);
    REG_dpc_list_corr_y                  : in    std_logic_vector(11 downto 0);
    REG_dpc_list_corr_x                  : in    std_logic_vector(12 downto 0);
    
    REG_dpc_list_corr_rd                 : out   std_logic_vector(32 downto 0);   
         
    ---------------------------------------------------------------------
    -- DPC in
    ---------------------------------------------------------------------  
    axi_sof                              : in    std_logic;
	axi_sol                              : in    std_logic;
    axi_data_val                         : in    std_logic;
    axi_data                             : in    std_logic_vector(19 downto 0);
    axi_eol                              : in    std_logic;	
	axi_eof                              : in    std_logic;
	
    ---------------------------------------------------------------------
    -- DPC out
    ---------------------------------------------------------------------
    dpc_sof                              : out   std_logic;
	dpc_sol                              : out   std_logic;
    dpc_data_val                         : out   std_logic;
    dpc_data                             : out   std_logic_vector(19 downto 0);
    dpc_eol                              : out   std_logic;	
	dpc_eof                              : out   std_logic
	
  );
  
end component;



component Infered_RAM
generic (
        C_RAM_WIDTH      : integer := 10;                                                 -- Specify data width 
        C_RAM_DEPTH      : integer := 10                                                  -- Specify RAM depth (bits de l'adresse de la ram)
        );
port (  
        RAM_W_clk        : in  std_logic;
        RAM_W_WRn        : in  std_logic:='1';                                            -- Write cycle
        RAM_W_enable     : in  std_logic:='0';                                            -- Write enable
        RAM_W_address    : in  std_logic_vector(C_RAM_DEPTH-1 downto 0);                  -- Write address bus, width determined from RAM_DEPTH
        RAM_W_data       : in  std_logic_vector(C_RAM_WIDTH-1 downto 0);                  -- RAM input data
        RAM_W_dataR      : out std_logic_vector(C_RAM_WIDTH-1 downto 0):= (others=>'0');  -- RAM read data

        RAM_R_clk        : in  std_logic;
        RAM_R_enable     : in  std_logic:='0';                                            -- Read enable
        RAM_R_address    : in  std_logic_vector(C_RAM_DEPTH-1 downto 0);                  -- Read address bus, width determined from RAM_DEPTH
        RAM_R_data       : out std_logic_vector(C_RAM_WIDTH-1 downto 0):= (others=>'0')   -- RAM output data
     );
end component;  



component Infered_RAM_lutC
   generic (
           C_RAM_WIDTH      : integer := 8;                                                  -- Specify data width 
           C_RAM_DEPTH      : integer := 10                                                  -- Specify RAM depth (bits de l'adresse de la ram)
           );
   port (  
           RAM_W_clk        : in  std_logic;
           RAM_W_WRn        : in  std_logic:='1';                                            -- Write cycle
           RAM_W_enable     : in  std_logic:='0';                                            -- Write enable
           RAM_W_address    : in  std_logic_vector(C_RAM_DEPTH-1 downto 0);                  -- Write address bus, width determined from RAM_DEPTH
           RAM_W_data       : in  std_logic_vector(C_RAM_WIDTH-1 downto 0);                  -- RAM input data
           RAM_W_dataR      : out std_logic_vector(C_RAM_WIDTH-1 downto 0):= (others=>'0');  -- RAM read data

           RAM_R_clk        : in  std_logic;
           RAM_R_enable     : in  std_logic:='0';                                            -- Write enable
           RAM_R_address    : in  std_logic_vector(C_RAM_DEPTH-1 downto 0);                  -- Read address bus, width determined from RAM_DEPTH
           RAM_R_data       : out std_logic_vector(C_RAM_WIDTH-1 downto 0):= (others=>'0')   -- RAM output data
        );
end component;






-- Domain synchro
--attribute ASYNC_REG       : string;
--attribute ASYNC_REG of curr_db_color_space_P1    : signal is "TRUE";



-----------------------------
-- Constant 10bpp input
-----------------------------
constant Pix_type             : integer := 10;


-----------------------------
-- TEMP signals/outputs
-----------------------------

-- AXI slave control
signal s_axis_tready_int     : std_logic :='0';
signal s_axis_first_line     : std_logic :='0';
signal s_axis_first_prefetch : std_logic_vector(1 downto 0) := "00"; -- 4 data prefect on line 1 and after
signal s_axis_line_gap       : std_logic :='0';
signal s_axis_line_wait      : std_logic :='0';  
signal s_axis_frame_done     : std_logic :='1';  


-- AXI master control
signal m_axis_first_line        : std_logic :='0';
signal m_axis_last_line         : std_logic :='0';
signal m_axis_tvalid_int        : std_logic :='0';
signal m_axis_tdata_int         : std_logic_vector(63 downto 0);
signal m_axis_tuser_int         : std_logic_vector(3 downto 0);
signal m_axis_wait_data         : std_logic_vector(63 downto 0);
signal m_axis_wait              : std_logic :='0';



-- AXI to Matrox IF
signal s_axis_sol_P1            : std_logic:= '0';
signal s_axis_data_enable_P1    : std_logic:= '0';
signal s_axis_data_enable_P2    : std_logic:= '0';
signal s_axis_eol_P1            : std_logic:= '0';
signal s_axis_eol_P2            : std_logic:= '0';
signal s_axis_eol_P3            : std_logic:= '0';        
signal s_axis_eof_P1            : std_logic:= '0';
signal s_axis_eof_P2            : std_logic:= '0';
signal s_axis_eof_P3            : std_logic:= '0';        
signal s_axis_eof_P4            : std_logic:= '0';         
signal s_axis_data_in_P1        : std_logic_vector(19 downto 0);
signal s_axis_data_in_P2        : std_logic_vector(19 downto 0); 

signal axi_sof                  : std_logic;
signal axi_sol                  : std_logic;
signal axi_data_val             : std_logic;
signal axi_data                 : std_logic_vector(19 downto 0);
signal axi_eol                  : std_logic;
signal axi_eof                  : std_logic;


----------------------------------
-- DPC pipeline
-----------------------------------------------------
signal dpc_sof                  : std_logic;
signal dpc_sol                  : std_logic;
signal dpc_data_val             : std_logic;
signal dpc_data                 : std_logic_vector(19 downto 0);
signal dpc_eol                  : std_logic;
signal dpc_eof                  : std_logic;

----------------------------------
-- White balancing pipeline
-----------------------------------------------------
signal WBIn_sof              : std_logic;
signal WBIn_sol              : std_logic;
signal WBIn_data_val         : std_logic;
signal WBIn_data             : std_logic_vector(19 downto 0);
signal WBIn_eol              : std_logic;
signal WBIn_eof              : std_logic;

signal WBIn_sof_p1           : std_logic;
signal WBIn_sol_p1           : std_logic;
signal WBIn_data_val_p1      : std_logic;
signal WBIn_data_p1          : std_logic_vector(19 downto 0);
signal WBIn_eol_p1           : std_logic;
signal WBIn_eof_p1           : std_logic;

signal WBIn_sof_p2           : std_logic;
signal WBIn_sol_p2           : std_logic;
signal WBIn_data_val_p2      : std_logic;
signal WBIn_eol_p2           : std_logic;
signal WBIn_eof_p2           : std_logic;

signal WB_is_line_impaire    : std_logic;


signal C0_wb_factor          : std_logic_vector(REG_WB_MULT_R'range);
signal C0_wb_mult_res        : std_logic_vector(Pix_type+REG_WB_MULT_R'high downto 0);
signal C0_wb_data            : std_logic_vector(9 downto 0);

signal C1_wb_factor          : std_logic_vector(REG_WB_MULT_R'range);
signal C1_wb_mult_res        : std_logic_vector(Pix_type+REG_WB_MULT_R'high downto 0);
signal C1_wb_data            : std_logic_vector(9 downto 0);

signal wb_b_acc              : std_logic_vector(30 downto 0);
signal wb_g_acc              : std_logic_vector(31 downto 0);
signal wb_r_acc              : std_logic_vector(30 downto 0);

--Outputs
signal wb_sof                : std_logic;
signal wb_sol                : std_logic;
signal wb_data_val           : std_logic;
signal wb_data               : std_logic_vector(19 downto 0);
signal wb_eol                : std_logic;
signal wb_eof                : std_logic;





-----------------------------------------------------
-- Bayer
-----------------------------------------------------
signal BayerIn_overscan         : std_logic;
signal BayerIn_sof              : std_logic;
signal BayerIn_sol              : std_logic;
signal BayerIn_data_val         : std_logic;
signal BayerIn_data             : std_logic_vector(15 downto 0);
signal BayerIn_eol              : std_logic;
signal BayerIn_eof              : std_logic;

signal bayer_is_line0         : std_logic;

signal bayer_read_enable      : std_logic;
signal bayer_r_ram_add        : std_logic_vector(12 downto 0);
signal bayer_r_ram_dat        : std_logic_vector(15 downto 0);
signal bayer_write_enable     : std_logic;
signal bayer_w_ram_add        : std_logic_vector(12 downto 0);


signal BayerIn_sol_p1         : std_logic;
signal BayerIn_sol_p2         : std_logic;
signal BayerIn_sol_p3         : std_logic;

signal BayerIn_data_val_p1    : std_logic;
signal BayerIn_data_val_p2    : std_logic;
--signal BayerIn_data_val_p3    : std_logic;

signal BayerIn_data_p1        : std_logic_vector(15 downto 0);
signal BayerIn_data_p2        : std_logic_vector(15 downto 0);

signal BayerIn_eol_p1         : std_logic;
signal BayerIn_eol_p2         : std_logic;
signal BayerIn_eol_p3         : std_logic;
signal BayerIn_eol_p4         : std_logic;

signal BayerIn_eof_p1         : std_logic;
signal BayerIn_eof_p2         : std_logic;
signal BayerIn_eof_p3         : std_logic;

signal is_line_impaire        : std_logic;
signal bayer_is_first_word    : std_logic;

signal BAYER_M0               : std_logic_vector(31 downto 0);
signal BAYER_M1               : std_logic_vector(31 downto 0);

signal C0_moyenneP            : std_logic_vector(8 downto 0);
signal C0_moyenneI            : std_logic_vector(8 downto 0);
signal C0_R_PIX_end_mosaic    : std_logic_vector(7 downto 0);
signal C0_G_PIX_end_mosaic    : std_logic_vector(7 downto 0);
signal C0_B_PIX_end_mosaic    : std_logic_vector(7 downto 0);

signal C1_moyenneP            : std_logic_vector(8 downto 0);
signal C1_moyenneI            : std_logic_vector(8 downto 0);
signal C1_R_PIX_end_mosaic    : std_logic_vector(7 downto 0);
signal C1_G_PIX_end_mosaic    : std_logic_vector(7 downto 0);
signal C1_B_PIX_end_mosaic    : std_logic_vector(7 downto 0);

--outputs
signal bayer_sof                : std_logic;
signal bayer_sol                : std_logic;
signal bayer_data_val           : std_logic;
signal bayer_data               : std_logic_vector(63 downto 0);
signal bayer_eol                : std_logic;
signal bayer_eof                : std_logic;



-----------------------------------------------------
-- LUT RGB
-----------------------------------------------------
signal bayer_data_P1          : std_logic_vector(bayer_data'range); --to bypass LUT

signal LUT_RAM_W_enable       : std_logic_vector(2 downto 0);
signal RAM_R_enable_ored      : std_logic; 
signal lut_sof                : std_logic;
signal lut_sol                : std_logic;
signal lut_data_val           : std_logic;
signal lut_data               : std_logic_vector(63 downto 0);
signal lut_eol                : std_logic;
signal lut_eof                : std_logic;
signal lut_eol_comb           : std_logic; -- pour generation m_axis : eol, eof, tlast

signal raw_data               : std_logic_vector(63 downto 0);




----------------
-- FOR SIM ONLY
----------------
signal s_axis_tdata8             : std_logic_vector(15 downto 0);
signal axi_data8                : std_logic_vector(15 downto 0); 
signal wb_data8                 : std_logic_vector(15 downto 0); 


BEGIN

  s_axis_tdata8 <= s_axis_tdata(19 downto 12) & s_axis_tdata(9 downto 2);
  axi_data8     <= axi_data(19 downto 12) & axi_data(9 downto 2);
  wb_data8      <= wb_data(19 downto 12)  & wb_data(9 downto 2);




    
  -------------------------------------------------
  --
  -- AXI SLAVE CONTROL
  --
  -------------------------------------------------	
  process(axi_clk)   
  begin
    if (axi_clk'event and axi_clk='1') then
      
	  ----------------------------------------------------------------------------------
	  -- First line goes directly to the first fifo in BAYER MODE : REG_BAYER_EN = 1
      ----------------------------------------------------------------------------------
	  if(REG_BAYER_EN='1' and s_axis_tvalid='1' and s_axis_tuser(0)='1' ) then --give rdy for one complete line at SOG : no wait sinc we enter this line to the first fifo
	    s_axis_tready_int     <= '1';		
	    s_axis_first_line     <= '1'; 
		s_axis_first_prefetch <= "00"; 		
		s_axis_line_gap       <= '0';
        s_axis_line_wait      <= '0'; 
        s_axis_frame_done     <= '0'; 
	  elsif(REG_BAYER_EN='1' and s_axis_tvalid='1' and s_axis_tready_int='1' and s_axis_tuser(3)='1') then -- at eol stop first line prefecht
	    s_axis_tready_int     <= '0';		
	    s_axis_first_line     <= '0'; 	  
		s_axis_first_prefetch <= "00"; 
		s_axis_line_gap       <= '1';
        s_axis_line_wait      <= '0'; 
        s_axis_frame_done     <= '1'; 
      
      elsif(REG_BAYER_EN='1' and s_axis_line_gap='1') then  --put a second wait at EOL, to let DPC absorb the stream(video syncs)
	    s_axis_tready_int     <= '0';		
	    s_axis_first_line     <= '0'; 	  
		s_axis_first_prefetch <= "00"; 
		s_axis_line_gap       <= '0';              
        s_axis_line_wait      <= '0'; 
        s_axis_frame_done     <= '0'; 
      
	  
	  ---------------------------------------------
	  -- Others lines can be waited by DMA
      ---------------------------------------------	  
      elsif(REG_BAYER_EN='1' and s_axis_tvalid='1' and s_axis_tuser(2)='1' ) or   -- RGB this gives 4 rdy (RGB) at SOL detection - then wait for master interface 
	       (REG_BAYER_EN='0' and s_axis_tvalid='1' and s_axis_tuser(0)='1' ) then -- RAW this gives 3 rdy (RAW) at SOF detection - then wait for master interface
	    s_axis_tready_int     <= '1';		
	    s_axis_first_line     <= '0'; 
		s_axis_first_prefetch <= "01";
		s_axis_line_gap       <= '0';
        s_axis_line_wait      <= '0'; 
        s_axis_frame_done     <= '0'; 

      elsif(REG_BAYER_EN='1' and s_axis_first_prefetch="11" and s_axis_tvalid='1' ) or   -- RGB this gives 4 rdy at SOL detection - remove rdy and then listen to master interface to be ready
	       (REG_BAYER_EN='0' and s_axis_first_prefetch="10" and s_axis_tvalid='1' ) then -- RAW this gives 3 rdy at SOF detection - remove rdy and then listen to master interface to be ready
	    s_axis_tready_int     <= '0';		
	    s_axis_first_line     <= '0'; 
		s_axis_first_prefetch <= "00";  	  
		s_axis_line_gap       <= '0';
        s_axis_line_wait      <= '1'; 	 
        s_axis_frame_done     <= '0'; 

      elsif(s_axis_first_prefetch/="00" and s_axis_tvalid='1' ) then -- this gives 4/3 rdy at SOL/SOF detection - remove rdy and then listen to master interface to be ready
	    s_axis_tready_int     <= '1';		
	    s_axis_first_line     <= '0'; 
		s_axis_first_prefetch <= s_axis_first_prefetch+'1';  	  
		s_axis_line_gap       <= '0';
        s_axis_line_wait      <= '1'; 	 
        s_axis_frame_done     <= '0'; 

      elsif(s_axis_line_wait='1' and m_axis_tvalid_int='1' and m_axis_tready='1') then  -- wait for master to be rdy on master to give slave ready to burst   
	    s_axis_tready_int     <= '1';		
	    s_axis_first_line     <= '0'; 
	 	s_axis_first_prefetch <= "00";  	  
		s_axis_line_gap       <= '0';      
        s_axis_line_wait      <= '0'; 
        s_axis_frame_done     <= '0'; 
       
      elsif(s_axis_tvalid='1' and s_axis_tready_int='1' and s_axis_tuser(1)='1') then --@EOF put ready to 0 till next line/frame
	    s_axis_tready_int     <= '0';		
	    s_axis_first_line     <= '0'; 
	 	s_axis_first_prefetch <= "00";  	  
		s_axis_line_gap       <= '0';      
        s_axis_line_wait      <= '0'; 
        s_axis_frame_done     <= '1'; 
      
	  elsif( (s_axis_line_wait='0' and s_axis_frame_done='0' and m_axis_tready='1' and m_axis_tvalid_int='1') or s_axis_first_line='1') then --enter data to DCP pipeline till output
	    s_axis_tready_int     <= '1';	
        s_axis_first_line     <= s_axis_first_line;	
		s_axis_first_prefetch <= "00";
		s_axis_line_gap       <= '0';
        s_axis_line_wait      <= '0'; 
        s_axis_frame_done     <= '0'; 

	  elsif (s_axis_line_wait='0' and m_axis_tvalid_int='1' and m_axis_tready='0' ) then -- si wait sur master, then wait the slave!
	    s_axis_tready_int     <= '0';	
        s_axis_first_line     <= s_axis_first_line;	
		s_axis_first_prefetch <= "00";
		s_axis_line_gap       <= '0';        
        s_axis_line_wait      <= '0'; 
        s_axis_frame_done     <= s_axis_frame_done; 
        
	  end if;	
    end if;
  end process;

  s_axis_tready     <= s_axis_tready_int;


  ---------------------------------------------------------------------------------------
  -- AXI to Matrox IF
  ---------------------------------------------------------------------------------------
  process(axi_clk)
  begin
    if (axi_clk'event and axi_clk='1') then
      
      if(s_axis_tvalid='1' and s_axis_tready_int='1' and (s_axis_tuser="0001" or s_axis_tuser="0100")) then --sof+sol
        s_axis_sol_P1 <= '1';
      else
        s_axis_sol_P1 <= '0';
      end if;        		
		
      
      s_axis_data_enable_P1 <= s_axis_tvalid and s_axis_tready_int;
      s_axis_data_enable_P2 <= s_axis_data_enable_P1;
      
	  if(s_axis_tvalid='1' and s_axis_tready_int='1' and (s_axis_tuser="1000" or s_axis_tuser="0010") ) then
        s_axis_eol_P1       <= '1';
	  else
        s_axis_eol_P1       <= '0';
      end if;		
      s_axis_eol_P2         <= s_axis_eol_P1;
      s_axis_eol_P3         <= s_axis_eol_P2;        
		
	  if(s_axis_tvalid='1' and s_axis_tready_int='1' and s_axis_tuser="0010") then
        s_axis_eof_P1         <= '1';
      else
        s_axis_eof_P1         <= '0';
      end if;		
  	  s_axis_eof_P2         <= s_axis_eof_P1;
      s_axis_eof_P3         <= s_axis_eof_P2;        
      s_axis_eof_P4         <= s_axis_eof_P3;        

      -- data_valid
      if(s_axis_tvalid='1' and s_axis_tready_int='1') then 
        s_axis_data_in_P1 <= s_axis_tdata; 
      end if;
      
      s_axis_data_in_P2 <= s_axis_data_in_P1; 
		 
      
      
    end if;
  end process;
  
  --rename signals
  axi_sof           <= s_axis_tvalid and s_axis_tready_int and s_axis_tuser(0);  
  axi_sol           <= s_axis_sol_P1;
  axi_data_val      <= s_axis_data_enable_P2;
  axi_data          <= s_axis_data_in_P2; 
  axi_eol           <= s_axis_eol_P3;
  axi_eof           <= s_axis_eof_P4;  


 
--------------------------------------------------------------------
--
--
--  COLOR DEAD PIXEL CORRECTION
--
--
--------------------------------------------------------------------


Xdpc_filter_color : dpc_filter_color 
   generic map( DPC_CORR_PIXELS_DEPTH      => DPC_CORR_PIXELS_DEPTH    --6=>64,  7=>128, 8=>256, 9=>512, 10=>1024
		  )
   port map(
    ---------------------------------------------------------------------
    -- Axi domain reset and clock signals
    ---------------------------------------------------------------------
    axi_clk                              => axi_clk,
    axi_reset_n                          => axi_reset_n,

    ---------------------------------------------------------------------
    -- Sys domain reset and clock signals : on axi_clk
    ---------------------------------------------------------------------   
    curr_Xstart                          => curr_Xstart,
    curr_Xend                            => curr_Xend,
	                                       
    curr_Ystart                          => curr_Ystart,
    curr_Yend                            => curr_Yend, 
	                                       
    curr_Ysub                            => curr_Ysub,
	load_dma_context_EOFOT               => load_dma_context_EOFOT,
	
    ---------------------------------------------------------------------
    -- Registers
    ---------------------------------------------------------------------
    REG_dpc_list_length                  => REG_dpc_list_length,      
	REG_dpc_ver                          => REG_dpc_ver,              

    REG_dpc_enable                       => REG_dpc_enable,           

    REG_dpc_pattern0_cfg                 => REG_dpc_pattern0_cfg,     

    REG_dpc_list_wrn                     => REG_dpc_list_wrn,         
    REG_dpc_list_add                     => REG_dpc_list_add,         
    REG_dpc_list_ss                      => REG_dpc_list_ss ,         
    REG_dpc_list_count                   => REG_dpc_list_count,       

    REG_dpc_list_corr_pattern            => REG_dpc_list_corr_pattern,
    REG_dpc_list_corr_y                  => REG_dpc_list_corr_y,      
    REG_dpc_list_corr_x                  => REG_dpc_list_corr_x,      

    REG_dpc_list_corr_rd                 => REG_dpc_list_corr_rd,     
         
    ---------------------------------------------------------------------
    -- DPC in
    ---------------------------------------------------------------------  
    axi_sof                              => axi_sof,    
	axi_sol                              => axi_sol,     
    axi_data_val                         => axi_data_val,
    axi_data                             => axi_data,    
    axi_eol                              => axi_eol,     
	axi_eof                              => axi_eof,     
	
    ---------------------------------------------------------------------
    -- DPC out
    ---------------------------------------------------------------------
    dpc_sof                              => dpc_sof,      
	dpc_sol                              => dpc_sol,      
    dpc_data_val                         => dpc_data_val, 
    dpc_data                             => dpc_data,     
    dpc_eol                              => dpc_eol,      
	dpc_eof                              => dpc_eof      
	
  );



 


--------------------------------------------------------------------
--
--
--  WHITE BALANCE
--
--
--------------------------------------------------------------------
WBIn_sof          <= DPC_sof;     
WBIn_sol          <= DPC_sol;     
WBIn_data_val     <= DPC_data_val;
WBIn_data         <= DPC_data;    
WBIn_eol          <= DPC_eol;     
WBIn_eof          <= DPC_eof;     



--PIPELINE WB
process (axi_clk)
begin      
  if (axi_clk'event and axi_clk='1') then
    
    WBIn_data_p1      <= WBIn_data;

    if(axi_reset_n='0') then
      WBIn_sof_p1      <= '0';
      WBIn_sol_p1      <= '0';
      WBIn_data_val_p1 <= '0';
      WBIn_eol_p1      <= '0';
      WBIn_eof_p1      <= '0';

      WBIn_sof_p2      <= '0';
      WBIn_sol_p2      <= '0';
      WBIn_data_val_p2 <= '0';
      WBIn_eol_p2      <= '0';
      WBIn_eof_p2      <= '0';

    else
      WBIn_sof_p1      <= WBIn_sof;
      WBIn_sol_p1      <= WBIn_sol;
      WBIn_data_val_p1 <= WBIn_data_val;
      WBIn_eol_p1      <= WBIn_eol;
      WBIn_eof_p1      <= WBIn_eof;

      WBIn_sof_p2      <= WBIn_sof_p1;
      WBIn_sol_p2      <= WBIn_sol_p1;
      WBIn_data_val_p2 <= WBIn_data_val_p1;
      WBIn_eol_p2      <= WBIn_eol_p1;
      WBIn_eof_p2      <= WBIn_eof_p1;

    end if;
  end if;
end process;




----------------------------------------------------------------------------------------------------------
--  HW assisted WB : Color ACCUMULATOR
--
-- Ils sont pas utilise dans le DRiver, ni GTR ni GTX, mais utile pour JDK
------------------------------------------------------------------------------------------------------------


--  LINE PAIR / IMPAIRE
process(axi_clk)
begin
  if rising_edge(axi_clk) then
    if(axi_reset_n='0') then
      WB_is_line_impaire <= '0';
    elsif(BayerIn_sof= '1') then
      WB_is_line_impaire <= '0';   
    elsif(BayerIn_eol_p2='1') then
      WB_is_line_impaire <= not(WB_is_line_impaire);
    end if;  
  end if;
end process;

process (axi_clk)
begin      
  if (axi_clk'event and axi_clk='1') then
    if(WBIn_sof='1') then
      wb_b_acc <= (others=>'0');
    elsif(WBIn_data_val='1') then
      if(WB_is_line_impaire='1') then
        wb_b_acc <= wb_b_acc + WBIn_data(19 downto 12);  --Counting 8 MSB bits only
      end if;
    end if;

    if(WBIn_sof='1') then
      wb_g_acc <= (others=>'0');
    elsif(WBIn_data_val='1') then
      if(WB_is_line_impaire='0') then
        wb_g_acc <= wb_g_acc + WBIn_data(19 downto 12);  --Counting 8 MSB bits only
      else
        wb_g_acc <= wb_g_acc + WBIn_data(9 downto 2);    --Counting 8 MSB bits only	  
      end if;
    end if;

    if(WBIn_sof='1') then
      wb_r_acc <= (others=>'0');
    elsif(WBIn_data_val='1') then
      if(WB_is_line_impaire='0') then
        wb_r_acc <= wb_r_acc + WBIn_data(9 downto 2);    --Counting 8 MSB bits only
      end if;
    end if;
    

  end if;
end process;

-- pas besoin de DB pour JDK
REG_wb_b_acc <= wb_b_acc;
REG_wb_g_acc <= wb_g_acc;
REG_wb_r_acc <= wb_r_acc;



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
process (axi_clk)
begin      
  if (axi_clk'event and axi_clk='1') then

   -- Load the factor one clk before
   if(WBIn_data_val='1') then
     if(WB_is_line_impaire='0') then
       C0_wb_factor <= REG_WB_MULT_R; --R : LIGNE PAIRE
	   C1_wb_factor <= REG_WB_MULT_G; --G : LIGNE PAIRE
	 else
	   C0_wb_factor <= REG_WB_MULT_G; --G : LIGNE IMPAIRE
	   C1_wb_factor <= REG_WB_MULT_B; --B : LIGNE IMPAIRE	   
     end if;
	      
   end if;
   
  end if;
end process;


--C0 and C1 MULTIPLICATORS 
process (axi_clk)
begin      
  if (axi_clk'event and axi_clk='1') then
    if(WBIn_data_val_p1='1') then
      C0_wb_mult_res <= WBIn_data_p1(9 downto   0) * C0_wb_factor(15 downto 0);
      C1_wb_mult_res <= WBIn_data_p1(19 downto 10) * C1_wb_factor(15 downto 0);    
	end if;  
  end if;
end process;



--  Clipping of the multiplication
process (axi_clk)
begin
  if rising_edge(axi_clk) then 
    if(C0_wb_mult_res((C0_wb_mult_res'high) downto (C0_wb_mult_res'high-3) )= "0000") then
      C0_wb_data  <= C0_wb_mult_res ((C0_wb_mult_res'high-4) downto (C0_wb_mult_res'high-4-Pix_type+1) );
    else 
      C0_wb_data  <= (others=>'1');  -- clip it to max value
    end if;
  end if;
end process;

process (axi_clk)
begin
  if rising_edge(axi_clk) then 
    if(C1_wb_mult_res((C1_wb_mult_res'high) downto (C1_wb_mult_res'high-3) )= "0000") then
      C1_wb_data  <= C1_wb_mult_res ((C1_wb_mult_res'high-4) downto (C1_wb_mult_res'high-4-Pix_type+1) );
    else 
      C1_wb_data  <= (others=>'1');  -- clip it to max value
    end if;
  end if;
end process;



-- OUTPUTS WB
process (axi_clk)
begin      
  if (axi_clk'event and axi_clk='1') then
    if(axi_reset_n='0' ) then
      wb_sof            <= '0';
      wb_sol            <= '0';
      wb_data_val       <= '0';
      wb_eol            <= '0';
      wb_eof            <= '0';
    else
      wb_sof           <= WBIn_sof_p2;
      wb_sol           <= WBIn_sol_p2;
      wb_data_val      <= WBIn_data_val_p2;
      wb_eol           <= WBIn_eol_p2;
      wb_eof           <= WBIn_eof_p2;
    end if;
  end if;
end process;

wb_data <= C1_wb_data & C0_wb_data; 


--------------------------------------------------------------------
--
--
--  BAYER Correction
--  
--  The last pixel corrected is repeated 2 times to generate 
--  the same amount of data IN-OUT (overscan).
--
--  If the bayer receives X lines, it will generate X-1 lines of demosaic pixels
--
--
--
--------------------------------------------------------------------
BayerIn_overscan  <= BayerIn_eol;
BayerIn_sof       <= wb_sof;     
BayerIn_sol       <= wb_sol;     
BayerIn_data_val  <= wb_data_val or BayerIn_overscan ; --add one clk cycle for overscan
BayerIn_data      <= wb_data(19 downto 12) & wb_data(9 downto 2);    -- 10 to 8 temporaire, manque les LUT
BayerIn_eol       <= wb_eol;     
BayerIn_eof       <= wb_eof;     



-------------------------------------
--  Pipelines needed
-------------------------------------
process(axi_clk)
begin
  if rising_edge(axi_clk) then

    if(BayerIn_overscan='0') then
      BayerIn_data_p1         <= BayerIn_data;
    else
	  BayerIn_data_p1         <= BayerIn_data_p1; 
	end if;
	
	BayerIn_data_p2         <= BayerIn_data_p1;

    if(axi_reset_n='0' or REG_BAYER_EN='0') then
      BayerIn_sol_p1          <= '0';
      BayerIn_sol_p2          <= '0';
      BayerIn_sol_p3          <= '0';

      BayerIn_data_val_p1     <= '0';
      BayerIn_data_val_p2     <= '0';
      --BayerIn_data_val_p3     <= '0';

      BayerIn_eol_p1          <= '0';
      BayerIn_eol_p2          <= '0';
      BayerIn_eol_p3          <= '0';
      BayerIn_eol_p4          <= '0';

      BayerIn_eof_p1          <= '0';
      BayerIn_eof_p2          <= '0';
      BayerIn_eof_p3          <= '0';

    else

      BayerIn_sol_p1          <= BayerIn_sol;
      BayerIn_sol_p2          <= BayerIn_sol_p1;
      BayerIn_sol_p3          <= BayerIn_sol_p2;

      BayerIn_data_val_p1     <= BayerIn_data_val;
      BayerIn_data_val_p2     <= BayerIn_data_val_p1;
      --BayerIn_data_val_p3     <= BayerIn_data_val_p2 and not(bayer_is_first_word);

      BayerIn_eol_p1          <= BayerIn_eol;
      BayerIn_eol_p2          <= BayerIn_eol_p1;
      BayerIn_eol_p3          <= BayerIn_eol_p2;
      BayerIn_eol_p4          <= BayerIn_eol_p3;       --use in line0

      BayerIn_eof_p1          <= BayerIn_eof;
      BayerIn_eof_p2          <= BayerIn_eof_p1;
      BayerIn_eof_p3          <= BayerIn_eof_p2;

    end if;
  end if;
end process;



-------------------------------------
--  LINE 0 STAT
-------------------------------------
process(axi_clk)
begin
  if rising_edge(axi_clk) then
    if(axi_reset_n='0' or REG_BAYER_EN='0') then
      bayer_is_line0 <= '0';
    elsif(BayerIn_sof= '1') then
      bayer_is_line0 <= '1';
    elsif(BayerIn_eol_p4='1') then
      bayer_is_line0 <= '0';
    end if;  
  end if;
end process;    


-- We need to load 2 16bit data before start process, so mask the first 16 data to valid_P3
process(axi_clk)
begin
  if rising_edge(axi_clk) then
    if(axi_reset_n='0' or REG_BAYER_EN='0') then
      bayer_is_first_word <= '0';
    elsif(BayerIn_sol= '1') then
      bayer_is_first_word <= '1';
    elsif(BayerIn_data_val_p2='1') then
      bayer_is_first_word <= '0';
    end if;  
  end if;
end process;    




-----------------------------------------------------------------------------------------
--
--       MATRIX CALCULATION

--     >--------------------------------------------- BAYER_M1
--                                       |
--       --------------------------------
--      |   ______________________
--      |__|      RAM LINE        |_________________  BAYER_M0
--         |______________________|
--
--
--
--                                             Pix (0,0)
--                                            /
--                                           /
--              .-------------.-------------.
--   BAYER_M0   | B13  | B12  | B11  |  B10 |  <---- READ from RAM (beginning of image)
--              |______|______|______|______|
--   BAYER_M1   | B23  | B22  | B21  |  B20 |  <---- WRITE 
--              |______|______|______|______|
--
--
-----------------------------------------------------------------------------------------




-------------------------------------
--  WRITE LOGIC
-------------------------------------
process(axi_clk)
begin
  if rising_edge(axi_clk) then
    if(BayerIn_sol = '1') then
      bayer_w_ram_add <= (others => '0');
    elsif(BayerIn_data_val_p2 = '1') then
      bayer_w_ram_add <=  bayer_w_ram_add + '1';
    end if;
  end if;
end process;    

--------------------------------------
--  RAM
--------------------------------------

bayer_write_enable <= BayerIn_data_val_p2;


XBayer_ram : Infered_RAM
  generic map(
           C_RAM_WIDTH      => 16,                                -- Specify data width 
           C_RAM_DEPTH      => 13                                 -- Specify RAM depth (bits de l'adresse de la ram) 13 bits = 8192 location
           )
   port map (  
           RAM_W_clk        => axi_clk,
           RAM_W_WRn        => '1',                               -- Write cycle
           RAM_W_enable     => bayer_write_enable,                -- Write enable
           RAM_W_address    => bayer_w_ram_add,                   -- Write address bus, width determined from RAM_DEPTH
           RAM_W_data       => BayerIn_data_p2,                   -- RAM input data
           RAM_W_dataR      => open,                              -- RAM read data
           
           --This interface is for the DPC macro read 
           RAM_R_clk        => axi_clk,
           RAM_R_enable     => bayer_read_enable,                 -- Read enable
           RAM_R_address    => bayer_r_ram_add,                   -- Read address bus, width determined from RAM_DEPTH
           RAM_R_data       => bayer_r_ram_dat                    -- RAM output data
        );
   


BAYER_M0(31 downto 16) <= bayer_r_ram_dat;



-------------------------------------
--  READ LOGIC
-------------------------------------
process(axi_clk)
begin
  if rising_edge(axi_clk) then
    if(axi_reset_n='0' or REG_BAYER_EN='0') then
      bayer_read_enable  <= '0';
    else
      bayer_read_enable <= BayerIn_data_val and not(bayer_is_line0);
    end if;
    
    if(BayerIn_sol = '1') then
      bayer_r_ram_add   <= (others => '0');
    elsif(BayerIn_data_val_p1 = '1' and bayer_is_line0 = '0') then
      bayer_r_ram_add <=  bayer_r_ram_add + '1';
    end if;
    
    if(axi_reset_n='0' or REG_BAYER_EN='0') then
      BAYER_M0(15 downto 0)   <= (others => '0');
    elsif(BayerIn_data_val_p1 = '1'  and bayer_is_line0 = '0') then
      BAYER_M0(15 downto 0)   <= BAYER_M0(31 downto 16); 
    end if;
    
  end if;
end process;


-------------------------------------
--  Direct pixel
-------------------------------------
process(axi_clk)
begin
  if rising_edge(axi_clk) then

    if(axi_reset_n='0' or REG_BAYER_EN='0') then
      BAYER_M1  <= (others => '0');
    elsif(BayerIn_data_val_p1 = '1' and bayer_is_line0 = '0') then
      BAYER_M1(31 downto 16)  <= BayerIn_data_p1(15 downto 0);  
    end if;
    
    if(axi_reset_n='0' or REG_BAYER_EN='0') then      
      BAYER_M1(15 downto 0)  <= (others => '0');
    elsif(BayerIn_data_val_p1 = '1'  and bayer_is_line0 = '0') then
      BAYER_M1(15 downto 0)  <= BAYER_M1(31 downto 16);

    end if;
    
  end if;
end process;



-------------------------------------
--  LINE PAIR / IMPAIRE
-------------------------------------
process(axi_clk)
begin
  if rising_edge(axi_clk) then
    if(axi_reset_n='0' or REG_BAYER_EN='0') then
      is_line_impaire <= '0';
    elsif(BayerIn_sof= '1') then
      is_line_impaire <= '1';         -- XGS On commence toujours sur une ligne pair . On commence a traiter une ligne en retard, donc au SOF on reset a 1 !!!
    elsif(BayerIn_eol_p2='1') then
      is_line_impaire <= not(is_line_impaire);
    end if;  
  end if;
end process;


-----------------------------------------------------------------------------------------
-- generate 2 Bayer cores
-----------------------------------------------------------------------------------------
--
--                                             Pix (0,0)
--                                            / 
--                                           /  
--              .31--24.23--16.15---8.7-----0
--   BAYER_M0   |  Gr  |  R   |  Gr  |   R  |  <---- READ from RAM (beginning of image)
--              |______|______|______|______|
--   BAYER_M1   |  B   |  Gb  |  B   |  Gb  |  <---- WRITE 
--              |______|______|______|______|  
--                     .      .      .      . 
--                     .      .<----------->.  Core 0  
--                     .<----------->.         Core 1 
--
--




-------------------------------------------------------------
-- CORE 0
-------------------------------------------------------------
--
--
--        Ligne Paire                   Ligne Impaire
--
--  15        8 7         0       15        8 7         0
-- .-----------.-----------.     .-----------.-----------.
-- |     G     |     R     |     |     B     |     G     |   BAYER_M0
-- |___________|___________|     |___________|___________|
-- |     B     |     G     |     |     G     |     R     |   BAYER_M1
-- |___________|___________|     |___________|___________|
--
--

  -- Pour la compossante verte on fait une moyenne :
  C0_moyenneP <= std_logic_vector(std_logic_vector('0' & BAYER_M0(15 downto 8)) + std_logic_vector('0' & BAYER_M1( 7 downto 0)));
  C0_moyenneI <= std_logic_vector(std_logic_vector('0' & BAYER_M0( 7 downto 0)) + std_logic_vector('0' & BAYER_M1(15 downto 8)));


  process(axi_clk)
  begin
    if rising_edge(axi_clk) then
  
      ----------
      -- RED
      ----------
      if(BayerIn_data_val_p2='1' and bayer_is_first_word='0') then
        if(is_line_impaire = '0') then
          C0_R_PIX_end_mosaic <= BAYER_M0(7 downto 0);
        else
          C0_R_PIX_end_mosaic <= BAYER_M1(7 downto 0);
		end if;  
      end if;
      
      ---------- 
      -- GREEN
      ----------
      if(BayerIn_data_val_p2='1' and bayer_is_first_word='0') then
        if(is_line_impaire = '0') then
          C0_G_PIX_end_mosaic <= C0_moyenneP(8 downto 1);
        else
          C0_G_PIX_end_mosaic <= C0_moyenneI(8 downto 1); 
        end if;
      end if;
      
      ----------
      -- BLUE
      ----------
      if(BayerIn_data_val_p2='1' and bayer_is_first_word='0') then
        if(is_line_impaire = '0') then
          C0_B_PIX_end_mosaic <= BAYER_M1(15 downto 8);
        else
          C0_B_PIX_end_mosaic <= BAYER_M0(15 downto 8);        
        end if;
      end if;
      
    end if;
  end process;



-------------------------------------------------------------
-- CORE 1
-------------------------------------------------------------
--
--
--        Ligne Paire                   Ligne Impaire
--
--  23       16 15        8       23       16 15        8
-- .-----------.-----------.     .-----------.-----------.
-- |     R     |     G     |     |     G     |     B     |   BAYER_M0
-- |___________|___________|     |___________|___________|
-- |     G     |     B     |     |     R     |     G     |   BAYER_M1
-- |___________|___________|     |___________|___________|
--
--

  -- Pour la compossante verte on fait une moyenne :
  C1_moyenneP <= std_logic_vector(std_logic_vector('0' & BAYER_M0(15 downto  8)) + std_logic_vector('0' & BAYER_M1(23 downto 16)));
  C1_moyenneI <= std_logic_vector(std_logic_vector('0' & BAYER_M0(23 downto 16)) + std_logic_vector('0' & BAYER_M1(15 downto 8)));


  process(axi_clk)
  begin
    if rising_edge(axi_clk) then
  
      ----------
      -- RED
      ----------
      if(BayerIn_data_val_p2='1' and bayer_is_first_word='0') then
        if(is_line_impaire = '0') then
          C1_R_PIX_end_mosaic <= BAYER_M0(23 downto 16);  --P
        else
          C1_R_PIX_end_mosaic <= BAYER_M1(23 downto 16);  --I
		end if;  		  
      end if;
      
      ----------
      -- GREEN
      ----------
      if(BayerIn_data_val_p2='1' and bayer_is_first_word='0') then
        if(is_line_impaire = '0') then
          C1_G_PIX_end_mosaic <= C1_moyenneP(8 downto 1);  --P
        else                                          
          C1_G_PIX_end_mosaic <= C1_moyenneI(8 downto 1);  --I 
        end if;
      end if;
      
      ----------
      -- BLUE
      ----------
      if(BayerIn_data_val_p2='1' and bayer_is_first_word='0') then
        if(is_line_impaire = '0') then
          C1_B_PIX_end_mosaic <= BAYER_M1(15 downto 8);  --P
        else                                           
          C1_B_PIX_end_mosaic <= BAYER_M0(15 downto 8);  --I        
        end if;
      end if;
      
    end if;
  end process;



-------------------------------------------------------------
-- OUTPUTS
-------------------------------------------------------------
process(axi_clk)
begin
  if rising_edge(axi_clk) then
    if(axi_reset_n='0' or REG_BAYER_EN='0') then
      bayer_sof        <= '0';
      bayer_sol        <= '0';
      bayer_data_val   <= '0';
      bayer_eol        <= '0';
      bayer_eof        <= '0';
    else
      bayer_sof        <= BayerIn_sof;
      bayer_sol        <= BayerIn_sol_p3      and not(bayer_is_line0);
      bayer_data_val   <= BayerIn_data_val_p2 and not(bayer_is_line0) and not bayer_is_first_word;
      bayer_eol        <= BayerIn_eol_p3      and not(bayer_is_line0);
      bayer_eof        <= BayerIn_eof_p3;
    end if;
  end if;
end process;


bayer_data      <= "--------" & C1_R_PIX_end_mosaic & C1_G_PIX_end_mosaic & C1_B_PIX_end_mosaic &
				   "--------" & C0_R_PIX_end_mosaic & C0_G_PIX_end_mosaic & C0_B_PIX_end_mosaic;




  ----------------------------------------------
  -- STEP 
  --
  --  LUT RGB
  --
  ----------------------------------------------  
  --regfile.LUT.LUT_CAPABILITIES.LUT_VER          <= conv_std_logic_vector(1 , regfile.LUT.LUT_CAPABILITIES.LUT_VER'LENGTH );
  --regfile.LUT.LUT_CAPABILITIES.LUT_SIZE_CONFIG  <= conv_std_logic_vector(2 , regfile.LUT.LUT_CAPABILITIES.LUT_SIZE_CONFIG'LENGTH );
  
  
  --------------------------------------------------------------------
  --
  --
  --  LUT CORRECTION (8 to 8 LUT)  (1 palette)
  --
  --
  --------------------------------------------------------------------
  
  --(0) is blue
  --(1) is green
  --(2) is Red
  LUT_RAM_W_enable(0)    <= '1' when  ((REG_LUT_SEL(0)='1' or REG_LUT_SEL(3)='1') and REG_LUT_SS='1' and REG_LUT_WRN='1') else '0';
  LUT_RAM_W_enable(1)    <= '1' when  ((REG_LUT_SEL(1)='1' or REG_LUT_SEL(3)='1') and REG_LUT_SS='1' and REG_LUT_WRN='1') else '0';
  LUT_RAM_W_enable(2)    <= '1' when  ((REG_LUT_SEL(2)='1' or REG_LUT_SEL(3)='1') and REG_LUT_SS='1' and REG_LUT_WRN='1') else '0';                        
                              
  ----------------------------
  -- Generation of LUTS Path 0
  ----------------------------
  Gen_ch0_output : for ch in 0 to 2  generate
  begin
       
    XLUT_CH0 : Infered_RAM_lutC
     generic map (
             C_RAM_WIDTH      => 8,                    -- Specify data width 
             C_RAM_DEPTH      => 8                     -- Specify RAM depth (bits de l'adresse de la ram)
             )
     port map (  
             RAM_W_clk        =>  axi_clk,
             RAM_W_WRn        =>  '1',                               -- Write cycle
             RAM_W_enable     =>  LUT_RAM_W_enable(ch),              -- Write enable
             RAM_W_address    =>  REG_LUT_ADD(7 downto 0),           -- Write address bus, width determined from RAM_DEPTH
             RAM_W_data       =>  REG_LUT_DATA_W(7 downto 0),        -- RAM input data
             RAM_W_dataR      =>  open,                              -- RAM read data
  
             RAM_R_clk        =>  axi_clk,
             RAM_R_enable     =>  RAM_R_enable_ored,                 -- Read enable
             RAM_R_address    =>  bayer_data(7+ch*8  downto ch*8),   -- Read address bus, width determined from RAM_DEPTH
             RAM_R_data       =>  lut_data(7+ch*8  downto ch*8)      -- RAM output data
          );  
  end generate;

  -- To save power
  RAM_R_enable_ored <= '1' when (REG_LUT_BYPASS='0' and bayer_data_val='1') else '0'; 

  ----------------------------
  -- Generation of LUTS Path 1
  ----------------------------
  Gen_ch1_output : for ch in 0 to 2  generate
  begin
       
    XLUT_CH1 : Infered_RAM_lutC
     generic map (
             C_RAM_WIDTH      => 8,                    -- Specify data width 
             C_RAM_DEPTH      => 8                     -- Specify RAM depth (bits de l'adresse de la ram)
             )
     port map (  
             RAM_W_clk        =>  axi_clk,
             RAM_W_WRn        =>  '1',                                      -- Write cycle
             RAM_W_enable     =>  LUT_RAM_W_enable(ch),                     -- Write enable
             RAM_W_address    =>  REG_LUT_ADD(7 downto 0),                  -- Write address bus, width determined from RAM_DEPTH
             RAM_W_data       =>  REG_LUT_DATA_W(7 downto 0),               -- RAM input data
             RAM_W_dataR      =>  open,                                     -- RAM read data
  
             RAM_R_clk        =>  axi_clk,
             RAM_R_enable     =>  RAM_R_enable_ored,                        -- Read enable
             RAM_R_address    =>  bayer_data(32+7+ch*8  downto 32+ch*8),    -- Read address bus, width determined from RAM_DEPTH
             RAM_R_data       =>  lut_data  (32+7+ch*8  downto 32+ch*8)     -- RAM output data
          );  
  end generate;

  -- for lut bypass
  process(axi_clk)
  begin
    if rising_edge(axi_clk) then
      if(REG_LUT_BYPASS='1') then  
        bayer_data_P1 <= bayer_data;
	  end if;

    end if;
  end process;  


  
  -------------------------------------------------------------
  -- LUT OUTPUTS
  -------------------------------------------------------------
  process(axi_clk)
  begin
    if rising_edge(axi_clk) then
      if(axi_reset_n='0' or REG_BAYER_EN='0') then
        lut_sof        <= '0';
        lut_sol        <= '0';
        lut_data_val   <= '0';
        lut_eol        <= '0';
        lut_eof        <= '0';
      else
        lut_sof        <= bayer_sof;     
        lut_sol        <= bayer_sol;     
        lut_data_val   <= bayer_data_val;
        lut_eol        <= bayer_eol;     
        lut_eof        <= bayer_eof;     
      end if;
    end if;
  end process;
  
   
  lut_data(31 downto 24) <= "00000000";
  lut_data(63 downto 56) <= "00000000";
  
  

 
  ----------------------------------------------
  -- for RAW
  ----------------------------------------------   
  raw_data       <= "00000000" & "0000000000000000" & wb_data(19 downto 12) & 
                    "00000000" & "0000000000000000" & wb_data(9 downto 2);		  

 
  
  ----------------------------------------------
  -- STEP 4
  --
  -- AXI MASTER
  --
  ----------------------------------------------   
  process(axi_clk)
  begin
    if rising_edge(axi_clk) then
      if(axi_sof='1') then  
        m_axis_first_line <= '1';
	  elsif(REG_BAYER_EN='1') then       -- COLOR
	    if(lut_eol='1') then 	
          m_axis_first_line <= '0';
		end if;
	  else                                  -- RAW MONO
	    if(wb_eol='1') then 	
          m_axis_first_line <= '0';
		end if;		
	  end if;
      
	  if(REG_BAYER_EN='1') then       -- COLOR
	    if(BayerIn_eof='1') then  
          m_axis_last_line <= '1';
	    elsif(lut_eof='1') then 	
          m_axis_last_line <= '0';		  
	    end if;
	  else                               -- RAW MONO (no need)
        m_axis_last_line <= '0';		  
      end if;	  
    end if;
  end process;  

  
  -- SOF : le protocol Axi-Video demande a mettre un flag SOF actif pour le premier transfert du frame. Ca sort sur le Tuser0
  process(axi_clk)
  begin
    if rising_edge(axi_clk) then
      if axi_reset_n = '0' then
        m_axis_tuser_int(0) <= '0' after 1 ns;
      elsif(REG_BAYER_EN='1' and lut_sof = '1') then      -- COLOR:  arrive une fois, au debut du frame avant le data
        m_axis_tuser_int(0) <= '1' after 1 ns;
      elsif(REG_BAYER_EN='0' and wb_sof = '1') then       -- RAW: arrive une fois, au debut du frame avant le data
        m_axis_tuser_int(0) <= '1' after 1 ns;	
      elsif m_axis_tvalid_int='1' and m_axis_tready='1' then  -- le data vient d'etre transfere, donc le pixel suivant on descend le SOF
        m_axis_tuser_int(0) <= '0' after 1 ns;
      end if;
    end if;
  end process;

  -- SOL 
  process(axi_clk)
  begin
    if rising_edge(axi_clk) then
      if axi_reset_n = '0' then
        m_axis_tuser_int(2) <= '0' after 1 ns;
      elsif(REG_BAYER_EN='1' and lut_sol = '1' and m_axis_first_line='0')  then      -- COLOR SOL
        m_axis_tuser_int(2) <= '1' after 1 ns;  
      elsif(REG_BAYER_EN='0' and wb_sol = '1' and m_axis_first_line='0')  then      -- RAW SOL
        m_axis_tuser_int(2) <= '1' after 1 ns;      		
	  elsif m_axis_tvalid_int='1' and m_axis_tready='1' then -- le data vient d'etre transfere, donc le pixel suivant on descend le SOF
        m_axis_tuser_int(2) <= '0' after 1 ns;
      end if;
    end if;
  end process;  

  -- EOL
  process(axi_clk)
  begin
    if rising_edge(axi_clk) then
      if axi_reset_n = '0' then
        m_axis_tuser_int(3) <= '0' after 1 ns;
      elsif(REG_BAYER_EN='1' and bayer_eol = '1'  and m_axis_last_line='0') then    -- COLOR : dont put eol in last line of frame, only eof, un pipe avant lut_eol
        m_axis_tuser_int(3) <= '1' after 1 ns;
      elsif(REG_BAYER_EN='0' and  WBIn_eol_p2='1' and WBIn_eof_p1='0') then   --RAW   
        m_axis_tuser_int(3) <= '1' after 1 ns;		
  	  elsif m_axis_tvalid_int='1' and m_axis_tready='1' then  -- le data vient d'etre transfere, donc le pixel suivant on descend le SOF
        m_axis_tuser_int(3) <= '0' after 1 ns;
      end if;
    end if;
  end process;    
  

  
  -- EOF 
  process(axi_clk)
  begin
    if rising_edge(axi_clk) then
      if axi_reset_n = '0' then
        m_axis_tuser_int(1) <= '0' after 1 ns;
      elsif(REG_BAYER_EN='1' and bayer_eol = '1' and m_axis_last_line='1') then   -- COLOR   
        m_axis_tuser_int(1) <= '1' after 1 ns;
      elsif(REG_BAYER_EN='0' and  WBIn_eol_p2='1' and WBIn_eof_p1='1') then   --RAW   
        m_axis_tuser_int(1) <= '1' after 1 ns;		
      elsif m_axis_tvalid_int='1' and m_axis_tready='1' then -- le data vient d'etre transfere, donc le pixel suivant on descend le SOF
        m_axis_tuser_int(1) <= '0' after 1 ns;
      end if;
    end if;
  end process;    

  m_axis_tuser <= m_axis_tuser_int;


  -- VALID 
  process(axi_clk)
  begin
    if rising_edge(axi_clk) then
      if axi_reset_n = '0' then
        m_axis_tvalid_int <= '0' after 1 ns;
	  elsif(REG_BAYER_EN='1') then       --COLOR 
   	    if(lut_data_val='1') then
          m_axis_tvalid_int <= '1';
		elsif(m_axis_tvalid_int='1' and m_axis_tready='1') then
	      m_axis_tvalid_int <= bayer_data_val;    -- un pipeline avant lut_data_val
		end if;  	  
      else
  	    if(wb_data_val='1') then            --RAW
          m_axis_tvalid_int <= '1';		
        elsif(m_axis_tvalid_int='1' and m_axis_tready='1') then
	      m_axis_tvalid_int <= WBIn_data_val_p2;  -- un pipeline avant WB_data_val                                 
		end if;  
      end if;
	  	  
    end if;
  end process;  
  
  m_axis_tvalid <= m_axis_tvalid_int;
  
  -- AXIs peut nous mettre en wait state, ce proccess sert a enregistrer un data venant du revx lors du wait, et le remettre lorsque
  -- on aura sorti du waitstate
  process(axi_clk)
  begin
    if rising_edge(axi_clk) then
       if axi_reset_n = '0' then
        m_axis_wait       <= '0';
      elsif(m_axis_wait='0' and m_axis_tvalid_int = '1' and m_axis_tready = '0') then 
        m_axis_wait       <= '1';
        m_axis_wait_data  <= m_axis_tdata_int;
      elsif(m_axis_wait='1' and m_axis_tvalid_int = '1' and m_axis_tready = '1') then
        m_axis_wait       <= '0';              
      end if;   

      if m_axis_wait = '1' then
        if(m_axis_tvalid_int = '1' and m_axis_tready = '1') then  --data in the bus is sampled, put the data saved before as new data
           m_axis_tdata_int <= m_axis_wait_data; 
        end if;        
      else
        if(m_axis_tvalid_int = '1' and m_axis_tready = '0') then -- Dont update data, since the data is not sample yet
          m_axis_tdata_int <= m_axis_tdata_int;
        else  
          if(REG_BAYER_EN='1') then
		    m_axis_tdata_int <= lut_data; -- COLOR : Put new data on the bus
		  else
		    m_axis_tdata_int <= raw_data; -- RAW : Put new data on the bus		  
          end if; 		  
        end if;  
      end if;
       
    end if;
  end process;  
  
 
  m_axis_tdata <= m_axis_tdata_int after 1 ns;
   
 
  -- tlast
  process(axi_clk)
  begin
    if rising_edge(axi_clk) then
      if axi_reset_n = '0' then
		m_axis_tlast    <= '0' after 1 ns;		
      elsif(REG_BAYER_EN='1' and bayer_eol = '1') then   -- COLOR
		m_axis_tlast    <= '1' after 1 ns;
      elsif(REG_BAYER_EN='0' and WBIn_eol_p2='1') then   -- un pipeline avant WB_EOL
		m_axis_tlast    <= '1' after 1 ns;		
  	  elsif m_axis_tvalid_int='1' and m_axis_tready='1' then -- le data vient d'etre transfere, donc le pixel suivant on descend le SOF
		m_axis_tlast    <= '0' after 1 ns;		
      end if;
    end if;
  end process;    





End functional;




