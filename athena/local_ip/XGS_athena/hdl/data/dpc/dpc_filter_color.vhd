-----------------------------------------------------------------------
-- $HeadURL: svn://brainstorm/fpga/trunk/Matrox/Imaging/FPGA/Iris3/cores/python_if/design/dpc_filter.vhd $
-- $Author: jmansill $
-- $Revision: 20201 $
-- $Date: 2019-07-15 16:04:33 -0400 (Mon, 15 Jul 2019) $
--
-- DESCRIPTION: 
--
-- Top du filtre DPC (Dead Pixel Correction) pour corriger les pixels hot et cold sur GTX
--
-- Axi slave and master are on the same domain : system clock.
-- Registers are in system clock.
--
--
--
-- Nombre de pixels maximum a corriger :
--
-- DPC_CORR_PIXELS_DEPTH=9  =>  511 pixels, 6+1+4:  11 RAM36K   <--- *default au 28 septembre
--
--
-- Compte tenu des ressources disponibles dans le fpga une implementation 5x1 est implemente
--
-- Le module ne fait aucun overscan X, compte tenu que le XGS a 4 pixels d'interpolation a droite
-- et a gauche de l'image valide 
--
-- Le module ne fait aucun overscan Y, compte tenu qu'on utilise un kernel 5x1
--
-- Compte tenu qu'il n'y a pas de overscan, deux pixels au debut du frame et 2 pixels a la fin du frame
-- sont consommes durant la correction. Donc pour une ligne de X pixels, apres le DPC on aura une 
-- ligne de X-4 pixels.
--
-- Les codes de correction pour un Kernel 5x1 :  pix[4 3 C 1 0] sont :
--
-- 0x01 : pixel pix[C] => Pix[0] 
-- 0x10 : pixel pix[C] => Pix[4] 
-- 0x17 : pixel pix[C] => (Pix[0]+Pix[4])/2
--
-----------------------------------------------------------------------
library ieee;
 use ieee.std_logic_1164.all;
 use IEEE.std_logic_unsigned.all;
 use IEEE.numeric_std.all;
 use IEEE.std_logic_arith.all;
 use std.textio.all ; 
 
library work;

entity dpc_filter_color is
   generic( DPC_CORR_PIXELS_DEPTH         : integer := 6    --6=>64,  7=>128, 8=>256, 9=>512, 10=>1024
		  );
   port(
    ---------------------------------------------------------------------
    -- Axi domain reset and clock signals
    ---------------------------------------------------------------------
    axi_clk                              : in    std_logic;
    axi_reset_n                          : in    std_logic;

    curr_Xstart                          : in    std_logic_vector(12 downto 0) :=(others=>'0');   --pixel (HISPI regsiters)
    curr_Xend                            : in    std_logic_vector(12 downto 0) :=(others=>'1');   --pixel (HISPI regsiters)
	
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
  
end dpc_filter_color;


architecture functional of dpc_filter_color is


procedure Print(s : string) is 
variable buf : line ; 
begin
  write(buf, s) ; 
  WriteLine(OUTPUT, buf) ; 
end procedure Print ; 


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

component dpc_kernel_proc_color 
  generic( DPC_CORR_PIXELS_DEPTH         : integer := 6    --6=>64,  7=>128, 8=>256, 9=>512, 10=>1024
    
  );
  port(
    ---------------------------------------------------------------------
    -- Pixel domain reset and clock signals
    ---------------------------------------------------------------------
    pix_clk                              : in    std_logic;
    pix_reset_n                          : in    std_logic;
    ---------------------------------------------------------------------
    -- Data IN
    ---------------------------------------------------------------------
    proc_enable                          : in    std_logic;    
    proc_eol                             : in    std_logic;        
	
    proc_X_pix_curr                      : in    std_logic_vector(12 downto 0);
    proc_Y_pix_curr                      : in    std_logic_vector(11 downto 0);    
 
    REG_dpc_pattern0_cfg                 : in    std_logic:='0';
 
    dpc_fifo_reset                       : in    std_logic;
	dpc_fifo_reset_done                  : out   std_logic;
    dpc_fifo_data_in                     : in    std_logic_vector(32 downto 0);
    dpc_fifo_write_in                    : in    std_logic;
    dpc_fifo_list_rdy                    : in    std_logic; --write logic has finish write to fifo, we can start prefetch
    
    --------------
    --  4 3 2 1 0
	--      C  
    --------------
    in_0                                 : in    std_logic_vector;
    in_1                                 : in    std_logic_vector;
    in_2                                 : in    std_logic_vector;   --central pixel, bypass 
    in_3                                 : in    std_logic_vector;
    in_4                                 : in    std_logic_vector;

    -------------------------------------------------
    -- Data OUT
    -------------------------------------------------
    Curr_out                             : out   std_logic_vector
  );
end component;


constant nb_pixels  : integer := ((axi_data'high+1)/10)-1;      

type STD13_LOGIC_VECTOR   is array (natural range <>) of std_logic_vector(12 downto 0);



signal axi_sof_P1        :  std_logic := '0';
signal axi_sof_P2        :  std_logic := '0';
signal axi_sof_P3        :  std_logic := '0';

signal axi_sol_P1        :  std_logic := '0';
signal axi_sol_P2        :  std_logic := '0';
signal axi_sol_P3        :  std_logic := '0';

signal axi_data_val_P1   :  std_logic := '0';
signal axi_data_val_P2   :  std_logic := '0';
signal axi_data_val_P3   :  std_logic := '0';			

signal axi_eol_P1        :  std_logic := '0';
signal axi_eol_P2        :  std_logic := '0';
signal axi_eol_P3        :  std_logic := '0';

signal axi_eof_P1        :  std_logic := '0';
signal axi_eof_P2        :  std_logic := '0';
signal axi_eof_P3        :  std_logic := '0';

-- Kernel 5x1
signal kernel_pipeline_loaded  : std_logic := '0';
signal kernel_sof         : std_logic:= '0';
signal kernel_sol         : std_logic:= '0';
signal kernel_data_val    : std_logic:= '0';
signal kernel_data        : std_logic_vector(59 downto 0);
signal kernel_eol         : std_logic:= '0';	
signal kernel_eof         : std_logic:= '0';




type curr_pixel_type is record
  X_pos : std_logic_vector(12 downto 0);  --kernel
  Y_pos : std_logic_vector(11 downto 0);  --line
end record curr_pixel_type;

signal kernel_5x1_curr        : curr_pixel_type;

signal proc_X_pix_curr        : std13_logic_vector(nb_pixels downto 0);

signal curr_Xstart_corr      : std_logic_vector(12 downto 0):=(others=>'0');
signal curr_Xend_corr        : std_logic_vector(12 downto 0):=(others=>'1');
  
signal curr_Xstart_integer   : integer range 0 to 8191;
signal curr_Xend_integer     : integer range 0 to 8191;

signal REG_dpc_enable_P1     : std_logic :='0';
signal REG_dpc_enable_DB     : std_logic :='0';


signal RAM_R_enable             : std_logic:='0';
signal RAM_R_enable_P1          : std_logic:='0';
signal RAM_R_address            : std_logic_vector(DPC_CORR_PIXELS_DEPTH-1 downto 0);
signal RAM_R_data               : std_logic_vector(32 downto 0);  --Pattern=8 y=12bits x=13bits
signal RAM_R_end                : std_logic:='0'; 
signal RAM_R_end_P1             : std_logic:='0'; 
signal RAM_W_data               : std_logic_vector(32 downto 0);

signal dpc_fifo_reset           : std_logic :='1';
signal dpc_fifo_reset_P1        : std_logic :='1';
signal dpc_fifo_reset_P2        : std_logic :='1';
signal dpc_fifo_reset_P3        : std_logic :='1';
signal dpc_fifo_reset_P4        : std_logic :='1';
signal dpc_fifo_reset_P5        : std_logic :='1';

signal dpc_fifo_data            : std_logic_vector(32 downto 0);
signal dpc_fifo_write           : std_logic_vector(nb_pixels downto 0) := (others=>'0');
signal dpc_fifo_list_rdy        : std_logic:='0'; --write logic has finish write to fifo, we can start prefetch
signal dpc_fifo_reset_done      : std_logic_vector(nb_pixels downto 0);

signal dpc_kernel_proc_data_out : std_logic_vector(19 downto 0);

 
--for simulation
signal axi_data16            : std_logic_vector(15 downto 0);
signal kernel_data_6x1_8bpp  : std_logic_vector(47 downto 0);
signal dpc_data16            : std_logic_vector(15 downto 0);       

--Output
signal kernel_sof_P1         : std_logic:= '0';
signal kernel_sol_P1         : std_logic:= '0';
signal kernel_data_val_P1    : std_logic:= '0';
signal kernel_eol_P1         : std_logic:= '0';	
signal kernel_eof_P1         : std_logic:= '0';

signal kernel_sof_P2         : std_logic:= '0';
signal kernel_sol_P2         : std_logic:= '0';
signal kernel_data_val_P2    : std_logic:= '0';
signal kernel_eol_P2         : std_logic:= '0';	
signal kernel_eof_P2         : std_logic:= '0';


begin
  
-------------------------------
-- DPC configuration register
-------------------------------   
REG_dpc_ver           <= "0001"; -- v : Initial color correction only, 5x1 matrix
REG_dpc_list_length   <= conv_std_logic_vector(conv_integer(2**DPC_CORR_PIXELS_DEPTH)-1 , 12);



axi_data16    <= axi_data(19 downto 12)    & axi_data(9 downto 2);

kernel_data_6x1_8bpp <= kernel_data(59 downto 52) & kernel_data(49 downto 42) & kernel_data(39 downto 32) & 
                        kernel_data(29 downto 22) & kernel_data(19 downto 12) & kernel_data(9 downto 2);
						

  process(axi_clk)
  begin
    if (axi_clk'event and axi_clk='1') then
      
	  
	  axi_sof_P1      <= axi_sof;  
	  axi_sof_P2      <= axi_sof_P1; 
	  axi_sof_P3      <= axi_sof_P2; 			
	  
	  axi_sol_P1      <= axi_sol;  
	  axi_sol_P2      <= axi_sol_P1; 
	  axi_sol_P3      <= axi_sol_P2; 			
	
	  if (axi_sol='1') then
        kernel_pipeline_loaded <= '0';
	  elsif(kernel_pipeline_loaded='0' and axi_data_val_P2='1') then
	    kernel_pipeline_loaded <= '1';
      end if;
		
	  if(axi_data_val='1') then
        kernel_data(59 downto 40) <= axi_data(19 downto 0);
  	    kernel_data(39 downto 20) <= kernel_data(59 downto 40);
        kernel_data(19 downto 0)  <= kernel_data(39 downto 20);
      end if;
		    
      axi_data_val_P1     <= axi_data_val;  
      axi_data_val_P2     <= axi_data_val_P1; 
	  axi_data_val_P3     <= (not(kernel_pipeline_loaded) and axi_data_val_P2 and axi_data_val_P1 and axi_data_val) or 			
				             (kernel_pipeline_loaded and axi_data_val);	  
	  axi_eol_P1        <= axi_eol;  
	  --axi_eol_P2        <= axi_eol_P1; 
	  --axi_eol_P3        <= axi_eol_P2; 			
 		  
	  axi_eof_P1        <= axi_eof;  
	  --axi_eof_P2        <= axi_eof_P1; 
	  --axi_eof_P3        <= axi_eof_P2; 			
 	
	  
    end if;
  end process;
  

  kernel_sof           <= axi_sof_P3;      
  kernel_sol           <= axi_sol_P3;     
  kernel_data_val      <= axi_data_val_P3;
  kernel_eol           <= axi_eol_P1;     
  kernel_eof           <= axi_eof_P1;  




  ---------------------------------------------------------------
  -- GTX : Correct X_start and X_end
  --
  -- Xstart and Xend are X positions related to HISPI decoding, since we always work with full line (with interpolations). 
  -- In color mode the 2 first pixels are removed to simplify the implementation of the 5x1 kernel (no edges to correct) 
  -- X_start = 2
  -- X_end   = HiSPI_Xend - HiSPI_Xstart - 2 (conient blanking, bL ...)
  --
  ---------------------------------------------------------------
  curr_Xstart_corr <=  "0000000000010"; -- Xstart is always 2 in color mode
  
  process(axi_clk)   
  begin
    if (axi_clk'event and axi_clk='1') then
      if(REG_dpc_enable='1' and REG_dpc_enable_P1='0') then -- this register is static, so load just one time after DPC pixels are programmed
        curr_Xend_corr   <= curr_Xend-curr_Xstart-"10";
	  end if; 
    end if;
  end process;



  ------------------------------
  -- Store Dead pixels in a RAM
  --
  -- SW will fill this ram with the 
  -- pixels to be corrected xxx max !
  --
  ------------------------------  
  RAM_W_data <= REG_dpc_list_corr_pattern & REG_dpc_list_corr_y & REG_dpc_list_corr_x; 
  Xdpc_ram : Infered_RAM
   generic map(
           C_RAM_WIDTH      => 33,                                               -- Specify data width 
           C_RAM_DEPTH      => DPC_CORR_PIXELS_DEPTH                                 -- Specify RAM depth (bits de l'adresse de la ram)
           )
   port map (  
           RAM_W_clk        => axi_clk,
           RAM_W_WRn        => REG_dpc_list_wrn,                  -- Write cycle
           RAM_W_enable     => REG_dpc_list_ss,                   -- Write enable
           RAM_W_address    => REG_dpc_list_add,                  -- Write address bus, width determined from RAM_DEPTH
           RAM_W_data       => RAM_W_data,                        -- RAM input data
           RAM_W_dataR      => REG_dpc_list_corr_rd,              -- RAM read data
           
           --This interface is for the DPC macro read 
           RAM_R_clk        => axi_clk,
           RAM_R_enable     => RAM_R_enable,     -- Read enable
           RAM_R_address    => RAM_R_address,    -- Read address bus, width determined from RAM_DEPTH
           RAM_R_data       => RAM_R_data        -- RAM output data
        );
   
 
  -------------------------------------------------------------
  -- At EOFOT we will reset fifo and then read the DPC list RAM
  -- if dpc_enable is enable
  --
  -- We have one complete line to read the DPC pixels from fifo
  --
  -------------------------------------------------------------  
 
  process(axi_clk)
  begin
    if (axi_clk'event and axi_clk='1') then     
	  REG_dpc_enable_P1 <= REG_dpc_enable;
      if(load_dma_context_EOFOT='1') then
        REG_dpc_enable_DB     <= REG_dpc_enable;
      end if;
      
    end if;
  end process; 
 
 
  process(axi_clk)  -- On resete le fifo a chaque SOF pour etre sur qu'il reste pas de data , ALLONGE le RESeT A 5CLK
  begin
    if (axi_clk'event and axi_clk='1') then
      dpc_fifo_reset_P1  <= load_dma_context_EOFOT; 
      dpc_fifo_reset_P2  <= dpc_fifo_reset_P1;
      dpc_fifo_reset_P3  <= dpc_fifo_reset_P2;
      dpc_fifo_reset_P4  <= dpc_fifo_reset_P3;
      dpc_fifo_reset_P5  <= dpc_fifo_reset_P4; 

      dpc_fifo_reset     <= dpc_fifo_reset_P5 or dpc_fifo_reset_P4 or dpc_fifo_reset_P3 or dpc_fifo_reset_P2 or dpc_fifo_reset_P1 ;

    end if;
  end process; 
 
 
 
  process(axi_clk)
  begin
    if (axi_clk'event and axi_clk='1') then
      if(REG_dpc_enable_DB='1' and dpc_fifo_reset_done(0)='1' and REG_dpc_list_count/= conv_std_logic_vector(0, DPC_CORR_PIXELS_DEPTH)  ) then
        RAM_R_address     <= (others=>'0');
        RAM_R_enable      <= '1';
        RAM_R_end         <= '0';
      elsif(RAM_R_enable='1') then 
        if(RAM_R_address = (REG_dpc_list_count - '1') ) then -- done sorting dp
          RAM_R_enable      <= '0'; 
          RAM_R_address     <= (others=>'0');
          RAM_R_end         <= '1';
        else
          RAM_R_enable      <= '1'; 
          RAM_R_address     <=  RAM_R_address+'1';      
          RAM_R_end         <= '0';
        end if;      
      else
        RAM_R_enable      <= '0'; 
        RAM_R_address     <= (others=>'0'); 
        RAM_R_end         <= '0';        
      end if;
      
      RAM_R_enable_P1 <= RAM_R_enable;
    end if;
  end process; 
 
 
 
  ------------------------------------------
  -- Filtrer les DP a l'exterieur de la ROI
  -- et les aiguiller(incuant pattern 0) vers 
  -- le kernel_proc correspondant
  ------------------------------------------

  curr_Xstart_integer <= conv_integer(curr_Xstart_corr);
  
  curr_Xend_integer   <= conv_integer(curr_Xend_corr);
    
  
  process(axi_clk)
  begin
    if (axi_clk'event and axi_clk='1') then
      RAM_R_end_P1      <= RAM_R_end;
      dpc_fifo_list_rdy <= RAM_R_end_P1;
      
      if(RAM_R_enable_P1='1') then
        dpc_fifo_data    <= RAM_R_data;      -- from DP LIST          

        if(  conv_integer(RAM_R_data(24 downto 13)) >= conv_integer(curr_Ystart(11 downto 0)) and 
             conv_integer(RAM_R_data(24 downto 13)) <= conv_integer(curr_Yend(11 downto 0))   and
             conv_integer(RAM_R_data(12 downto  0)) >= curr_Xstart_integer                    and      
             conv_integer(RAM_R_data(12 downto  0)) <= curr_Xend_integer                      and				
				  
		     ((curr_Ysub = '1' and  RAM_R_data(14) = '0') or curr_Ysub = '0' )       -- Color Y SUBsampling (read 2 - skip 2)	skip L2L3, L6L7, L10L11 (bit 14)	  
				
          ) then 
          for i in 0 to nb_pixels loop  -- X Loop        
            if(conv_integer(RAM_R_data(0))=i ) then   -- COlor  			  
              --current DP to each macro
              dpc_fifo_write(i)   <= '1';
            else  
              dpc_fifo_write(i)   <= '0';
            end if;  
          end loop;
        else
          Print("DPC GAIA: DP x=" & INTEGER'IMAGE(to_integer(ieee.numeric_std.unsigned(RAM_R_data(12 downto  0)))) & " y=" & INTEGER'IMAGE(to_integer(ieee.numeric_std.unsigned(RAM_R_data(24 downto  13)))) &  " REMOVED from DPC list"  );
          dpc_fifo_write   <= (others=>'0');         
        end if;        
   
      else
        dpc_fifo_write   <= (others=>'0');
      end if;
    end if;
  end process; 
      
 

  --
  -- generer la position du pixel (kernel) courant
  --
  process(axi_clk)
  begin
    if (axi_clk'event and axi_clk='1') then
        
      --X registers in sensor are pixel based 
      if(kernel_sof='1' or kernel_eol='1') then
        kernel_5x1_curr.X_pos(12 downto 0) <= curr_Xstart_corr;                   
      elsif(kernel_data_val='1') then
        kernel_5x1_curr.X_pos <= kernel_5x1_curr.X_pos + "10";   
      end if;
      
      --Y registers are line based in sensor
      if(kernel_sof='1') then
        kernel_5x1_curr.Y_pos(11 downto 0) <= curr_Ystart;
      elsif(kernel_eol='1') then
        if(curr_Ysub='0') then
          kernel_5x1_curr.Y_pos <= kernel_5x1_curr.Y_pos + '1';        -- No skip
        else
          if(kernel_5x1_curr.Y_pos(0)='0') then                       
            kernel_5x1_curr.Y_pos <= kernel_5x1_curr.Y_pos + '1';     -- Color (no skip)
          else	                                                       
            kernel_5x1_curr.Y_pos <= kernel_5x1_curr.Y_pos + "11";    -- Color (skip 2)
          end if;
        end if;        
      end if;                

    end if;
  end process;
    


  ---------------------------------------------------------------------------------------
  --
  --  STEP 3
  --
  --  Partie correction de kernels
  --
  ---------------------------------------------------------------------------------------      

  proc_X_pix_curr(0)       <= kernel_5x1_curr.X_pos(12 downto 1) & '0'; 
  proc_X_pix_curr(1)       <= kernel_5x1_curr.X_pos(12 downto 1) & '1'; 


  GEN_2_CORE: for i in 0 to 1 generate
     
    Xdpc_kernel_proc_color : dpc_kernel_proc_color
    generic map( DPC_CORR_PIXELS_DEPTH         => DPC_CORR_PIXELS_DEPTH )	
	port map(
      ---------------------------------------------------------------------
      -- Pixel domain reset and clock signals
      ---------------------------------------------------------------------
      pix_clk                              => axi_clk,
      pix_reset_n                          => axi_reset_n,
  
      ---------------------------------------------------------------------
      -- Data IN
      ---------------------------------------------------------------------   
      proc_enable                          => kernel_data_val,
      proc_eol                             => kernel_eol,

      proc_X_pix_curr                      => proc_X_pix_curr(i),
      proc_Y_pix_curr                      => kernel_5x1_curr.Y_pos,
	  
      REG_dpc_pattern0_cfg                 => REG_dpc_pattern0_cfg,
	  
      dpc_fifo_reset                       => dpc_fifo_reset,
      dpc_fifo_data_in                     => dpc_fifo_data,
      dpc_fifo_write_in                    => dpc_fifo_write(i),
      dpc_fifo_list_rdy                    => dpc_fifo_list_rdy,         --write logic has finish write to fifo, we can start prefetch
      dpc_fifo_reset_done                  => dpc_fifo_reset_done(i),
      
      --------------
      --  4 3 2 1 0
	  --      C  
      --------------
      in_0                                 => kernel_data(9 +(i*10) downto 0 +(i*10)),
      in_1                                 => kernel_data(19+(i*10) downto 10+(i*10)),
      in_2                                 => kernel_data(29+(i*10) downto 20+(i*10)),   --central pixel, bypass 
      in_3                                 => kernel_data(39+(i*10) downto 30+(i*10)),
      in_4                                 => kernel_data(49+(i*10) downto 40+(i*10)),

      
      -------------------------------------------------
      -- Data OUT
      -------------------------------------------------
      Curr_out                             => dpc_kernel_proc_data_out(9+(i*10) downto 0+(i*10))
    );
  end generate;  



--To OUTPUT
process(axi_clk)
begin
  if (axi_clk'event and axi_clk='1') then
     kernel_sof_P1         <= kernel_sof;
     kernel_sol_P1         <= kernel_sol;
     kernel_data_val_P1    <= kernel_data_val;
     kernel_eol_P1         <= kernel_eol;
     kernel_eof_P1         <= kernel_eof;
     
     kernel_sof_P2         <= kernel_sof_P1 ;
     kernel_sol_P2         <= kernel_sol_P1;
     kernel_data_val_P2    <= kernel_data_val_P1;
     kernel_eol_P2         <= kernel_eol_P1;
     kernel_eof_P2         <= kernel_eof_P1;
  end if;
end process;

 
  
dpc_sof           <= kernel_sof_P2;      
dpc_sol           <= kernel_sol_P2;      
dpc_data_val      <= kernel_data_val_P2;       
dpc_data          <= dpc_kernel_proc_data_out;
dpc_data16        <= dpc_kernel_proc_data_out(19 downto 12) & dpc_kernel_proc_data_out(9 downto 2);         
dpc_eol           <= kernel_eol_P2;      
dpc_eof           <= kernel_eof_P2;      



  
  
end functional;

