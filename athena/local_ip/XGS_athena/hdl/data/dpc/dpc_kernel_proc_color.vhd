-----------------------------------------------------------------------
-- $HeadURL: svn://brainstorm/fpga/trunk/Matrox/Imaging/FPGA/Iris3/cores/python_if/design/nopel_minmax9.vhd $
-- $Author: jmansill $
-- $Revision: 19061 $
-- $Date: 2018-10-16 09:45:30 -0400 (Tue, 16 Oct 2018) $
--
-- DESCRIPTION: 
--
-- Ce module recois des pixels a corriger pour un pixel dans un kernel particulier et les sauvegarde dans un fifo.
-- Lorsque la ligne rentre ce module applique la correction sur ce pixel du kernel, et retourne le pixel corrige.
--
-------------------------------------------
library ieee;
 use ieee.std_logic_1164.all;
 use IEEE.std_logic_unsigned.all;
 use ieee.numeric_std.all;
 use std.textio.all ; 
 use IEEE.math_real.all;
 
library work;

Library xpm;
  use xpm.vcomponents.all;



--package TextUtil is
--  procedure Print(s : string) ;
--end package TextUtil ; 
--package body TextUtil is
--  procedure Print(s : string) is 
--    variable buf : line ; 
--  begin
--    write(buf, s) ; 
--    WriteLine(OUTPUT, buf) ; 
--  end procedure Print ; 
--end package body TextUtil ;  
  
  
  
  
  
entity dpc_kernel_proc_color is
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
    REG_dpc_highlight_all                : in    std_logic:='0';
 
    dpc_fifo_reset                       : in    std_logic;
	dpc_fifo_reset_done                  : out   std_logic;
    dpc_fifo_data_in                     : in    std_logic_vector(32 downto 0);
    dpc_fifo_write_in                    : in    std_logic;
    dpc_fifo_list_rdy                    : in    std_logic; --write logic has finish write to fifo, we can start prefetch
    
    --------------
    --  4 3 2 1 0
	--      C  
    --------------
    in_0                                 : in    std_logic_vector(9 downto 0);
    in_1                                 : in    std_logic_vector(9 downto 0);
    in_2                                 : in    std_logic_vector(9 downto 0);   --central pixel, bypass 
    in_3                                 : in    std_logic_vector(9 downto 0);
    in_4                                 : in    std_logic_vector(9 downto 0);

    -------------------------------------------------
    -- Data OUT
    -------------------------------------------------
    Curr_out                             : out   std_logic_vector(9 downto 0)
  );
end dpc_kernel_proc_color;


architecture functional of dpc_kernel_proc_color is
  
  
  procedure Print(s : string) is 
  variable buf : line ; 
  begin
    write(buf, s) ; 
    WriteLine(OUTPUT, buf) ; 
  end procedure Print ; 
 

 
  --------------------------------
  -- Pre-First step in pipeline
  --------------------------------    
  signal dpc_fifo_srst  : std_logic;
  
  signal proc_nxt_X_pix_corr     :   std_logic_vector(12 downto 0);  
  signal proc_nxt_Y_pix_corr     :   std_logic_vector(11 downto 0);  
  signal proc_nxt_pattern_corr   :   std_logic_vector(7 downto 0);    
   
  signal dpc_fifo_rd_en  : std_logic:='0';
  signal dpc_fifo_dout   : std_logic_vector(32 downto 0); 
  signal dpc_fifo_full   : std_logic;
  signal dpc_fifo_empty  : std_logic; 
  signal dpc_rst_busy    : std_logic; 
  signal dpc_rst_busy_P1 : std_logic:='0'; 
  
  signal deadpix_exist   : std_logic:= '0';
  
  
  --------------------------------
  -- First step in pipeline
  --------------------------------  
  signal Correct_this_P1    : std_logic:='0';
  signal Correct_mode_P1    : std_logic_vector(2 downto 0);
  signal proc_enable_P1     : std_logic:='0';
  signal Correct_pattern_P1 : std_logic_vector(7 downto 0);
  signal in_0_P1            : std_logic_vector(9 downto 0);
  --signal in_1_P1            : std_logic_vector(9 downto 0);
  signal in_2_P1            : std_logic_vector(9 downto 0);
  --signal in_3_P1            : std_logic_vector(9 downto 0);
  signal in_4_P1            : std_logic_vector(9 downto 0);
  
  signal sum_comb           : std_logic_vector(10 downto 0);
  
  
  
begin

--------------------------------
-- Pre-First step in pipeline  (get the initial pixels to correct, if any)
--------------------------------    
dpc_fifo_srst <= '1' when (dpc_fifo_reset='1' or pix_reset_n='0') else '0';

  
 
xpm_sensor_ser_fifo : xpm_fifo_sync
   generic map (
      DOUT_RESET_VALUE    => "0",       -- String
      ECC_MODE            => "no_ecc",  -- String
      FIFO_MEMORY_TYPE    => "auto",    -- String
      FIFO_READ_LATENCY   => 1,         -- DECIMAL ****
      FIFO_WRITE_DEPTH    => 2**DPC_CORR_PIXELS_DEPTH, 
      FULL_RESET_VALUE    => 0,         -- DECIMAL
      PROG_EMPTY_THRESH   => 10,        -- DECIMAL
      PROG_FULL_THRESH    => 10,        -- DECIMAL
      RD_DATA_COUNT_WIDTH => 1,         -- DECIMAL
      READ_DATA_WIDTH     => 33,        -- DECIMAL ****
      READ_MODE           => "std",     -- String
      USE_ADV_FEATURES    => "0707",    -- String
      WAKEUP_TIME         => 0,         -- DECIMAL
      WRITE_DATA_WIDTH    => 33,        -- DECIMAL ****
      WR_DATA_COUNT_WIDTH => 1          -- DECIMAL
   )
   port map (
      almost_empty  => open,
      almost_full   => open, 

      data_valid    => open,              -- 1-bit output: Read Data Valid: When asserted, this signal indicates that valid data is available on the output bus (dout).
										  
      dbiterr       => open,              
      dout          => dpc_fifo_dout,     -- READ_DATA_WIDTH-bit output: Read Data: The output data bus is driven when reading the FIFO.
										  
      empty         => dpc_fifo_empty,    -- 1-bit output: Empty Flag: When asserted, this signal indicates that
                                          -- the FIFO is empty. Read requests are ignored when the FIFO is empty,
                                          -- initiating a read while empty is not destructive to the FIFO.
      full          => dpc_fifo_full,                    
				   
      overflow      => open,
				   
      prog_empty    => open,       
				   
      prog_full     => open,       

      rd_data_count => open,              -- RD_DATA_COUNT_WIDTH-bit output: Read Data Count: This bus indicates the number of words read from the FIFO.

      rd_rst_busy   => open,              -- 1-bit output: Read Reset Busy: Active-High indicator that the FIFO read domain is currently in a reset state.

      sbiterr       => open,              -- 1-bit output: Single Bit Error: Indicates that the ECC decoder detected and fixed a single-bit error.

      underflow     => open,              -- 1-bit output: Underflow: Indicates that the read request (rd_en)
                                          -- during the previous clock cycle was rejected because the FIFO is
                                          -- empty. Under flowing the FIFO is not destructive to the FIFO.

      wr_ack        => open,              -- 1-bit output: Write Acknowledge: This signal indicates that a write
                                          -- request (wr_en) during the prior clock cycle is succeeded.
									      
      wr_data_count => open,              -- WR_DATA_COUNT_WIDTH-bit output: Write Data Count: This bus indicates
                                          -- the number of words written into the FIFO.
									      
      wr_rst_busy   => dpc_rst_busy,      -- 1-bit output: Write Reset Busy: Active-High indicator that the FIFO write domain is currently in a reset state.
									      
      din           => dpc_fifo_data_in,  -- WRITE_DATA_WIDTH-bit input: Write Data: The input data bus used when writing the FIFO.
									      
      injectdbiterr => '0',               -- 1-bit input: Double Bit Error Injection: Injects a double bit error if the ECC feature is used on block RAMs or UltraRAM macros.
									      
      injectsbiterr => '0',               -- 1-bit input: Single Bit Error Injection: Injects a single bit error if the ECC feature is used on block RAMs or UltraRAM macros.
									      
      rd_en         => dpc_fifo_rd_en,    -- 1-bit input: Read Enable: If the FIFO is not empty, asserting this
                                          -- signal causes data (on dout) to be read from the FIFO. Must be held
                                          -- active-low when rd_rst_busy is active high.
									      
      rst           => dpc_fifo_srst,     -- 1-bit input: Reset: Must be synchronous to wr_clk. The clock(s) can be
                                          -- unstable at the time of applying reset, but reset must be released
                                          -- only after the clock(s) is/are stable.
									      
      sleep         => '0',               -- 1-bit input: Dynamic power saving- If sleep is High, the memory/fifo
                                          -- block is in power saving mode.
									      
      wr_clk        => pix_clk,           -- 1-bit input: Write clock: Used for write operation. wr_clk must be a free running clock.
									      
      wr_en         => dpc_fifo_write_in  -- 1-bit input: Write Enable: If the FIFO is not full, asserting this signal causes data (on din) to be written to the FIFO Must be held
                                          -- active-low when rst or wr_rst_busy or rd_rst_busy is active high

   );  

  
  process(pix_clk)
  begin
    if (pix_clk'event and pix_clk='1') then
	dpc_rst_busy_P1 <= dpc_rst_busy;
      if(dpc_rst_busy='0' and dpc_rst_busy_P1='1') then
        dpc_fifo_reset_done <= '1';
	  else	
	    dpc_fifo_reset_done <= '0';
	  end if;
	end if;
  end process;
  
  
  dpc_fifo_rd_en <= '1' when (dpc_fifo_empty='0' and ( dpc_fifo_list_rdy='1' or (proc_enable='1' and proc_X_pix_curr = proc_nxt_X_pix_corr and proc_Y_pix_curr = proc_nxt_Y_pix_corr))  )  else  '0';
   
  proc_nxt_X_pix_corr   <= dpc_fifo_dout(12 downto 0);  
  proc_nxt_Y_pix_corr   <= dpc_fifo_dout(24 downto 13);  
  proc_nxt_pattern_corr <= dpc_fifo_dout(32 downto 25);    
  
  --Ce signal est utilise pour verifier qu'il y a au moins une pixel dans la liste 
  --Utile lorsque le fifo est vide : 0-0-0 : ca dit x=0, y=0 pattern=0 (test mode) !!!
  process(pix_clk)
  begin
    if (pix_clk'event and pix_clk='1') then
      if(dpc_fifo_srst='1') then
        deadpix_exist <='0';
      elsif(dpc_fifo_rd_en='1') then
        deadpix_exist <='1'; 
      end if;  
    end if;    
  end process;


  --------------------------------
  -- First step in pipeline  (find pixel to correct)
  --------------------------------  
  process(pix_clk)
  begin
    if (pix_clk'event and pix_clk='1') then

      proc_enable_P1     <= proc_enable;    
     
      in_2_P1            <= in_2;
      
      if(proc_enable='1') then     
       
        if(deadpix_exist='1' and proc_X_pix_curr = proc_nxt_X_pix_corr and proc_Y_pix_curr = proc_nxt_Y_pix_corr ) then
          
          -- TEST MODE PIXEL
          if(REG_dpc_highlight_all='1') then     -- Set all pixel list to white (highlight)
            Correct_mode_P1 <= "100";
            Correct_this_P1 <= '1';
          elsif( proc_nxt_pattern_corr=X"00" ) then  -- testmode set a white pixel
            Correct_mode_P1 <= "100";    
            if(REG_dpc_pattern0_cfg='0') then
              Correct_this_P1 <= '0';  -- bypass (use current pixel)
            else
              Correct_this_P1 <= '1';  -- replace current pixel with white pixel(0x3ff)            
            end if;            
          
          -- ONE pixel replacement 
          elsif( proc_nxt_pattern_corr=X"01" or proc_nxt_pattern_corr=X"10" ) then                
            Correct_mode_P1 <= "000";
            Correct_this_P1 <= '1';           

            
          -- TWO pixel interpolation
          elsif( proc_nxt_pattern_corr=X"10" or
                 proc_nxt_pattern_corr=X"11"     ) then
            Correct_mode_P1 <= "001";
            Correct_this_P1 <= '1';
		  
		  end if;	
                    
        else
          Correct_this_P1 <= '0';  --bypass
          Correct_mode_P1 <= "000";
        end if;
      else

        if(proc_eol='1') then          
          Correct_this_P1 <= '0';  --bypass
          Correct_mode_P1 <= "000";        
        else
          Correct_this_P1 <= Correct_this_P1;
          Correct_mode_P1 <= Correct_mode_P1;        
        end if;
        
      end if; --proc enable
      
      
      if(proc_enable='1') then    
        Correct_pattern_P1 <= proc_nxt_pattern_corr;            
        in_0_P1 <= in_0;
        --in_1_P1 <= in_1;
        in_2_P1 <= in_2;    
        --in_3_P1 <= in_3;
        in_4_P1 <= in_4;
      end if; --proc enable
           
    end if;
    
  end process; 
  
  --
  -- Print Correction type and factors to screen
  --
  process(pix_clk)
  begin
    if (pix_clk'event and pix_clk='1') then
 
      if(proc_enable='1' and deadpix_exist='1' and proc_X_pix_curr = proc_nxt_X_pix_corr and proc_Y_pix_curr = proc_nxt_Y_pix_corr ) then       
        Print("--------------------------------------------------------------------------------------------------------");
        Print("DPC GAIA: Correcting Pixel position: x=" & INTEGER'IMAGE(to_integer(unsigned(proc_X_pix_curr))) & ", y=" & INTEGER'IMAGE(to_integer(unsigned(proc_Y_pix_curr))) &" Pattern Mode #" & INTEGER'IMAGE(to_integer(unsigned(proc_nxt_pattern_corr))) );         
        
		if(proc_nxt_pattern_corr=X"00") then
		  if(REG_dpc_pattern0_cfg='0' ) then		  
		    Print("DPC GAIA: Pattern 0x00, Current pixel is bypassed (not corrected, dpc_pattern0_cfg=0) ");
		  else
		  	Print("DPC GAIA: Pattern 0x00, Current pixel is set to 0xff (dpc_pattern0_cfg=1) ");
          end if; 	
        end if; 	
		  
		Print(" ");   
        Print("4 3 2 1 0");
        Print(" ");
        Print(INTEGER'IMAGE(to_integer(unsigned(in_4))) & " " & INTEGER'IMAGE(to_integer(unsigned(in_3))) & " " & INTEGER'IMAGE(to_integer(unsigned(in_2))) & " " & INTEGER'IMAGE(to_integer(unsigned(in_1))) & " " & INTEGER'IMAGE(to_integer(unsigned(in_0))) );

        Print(" ");      
      
        if(proc_nxt_pattern_corr=X"01") then
          Print("DPC GTX: 1 pixel correction  Loc0:" & INTEGER'IMAGE(to_integer(unsigned(in_0)))  );
        elsif(proc_nxt_pattern_corr=X"10") then
          Print("DPC GTX: 1 pixel correction  Loc4:" & INTEGER'IMAGE(to_integer(unsigned(in_4)))  );
        elsif(proc_nxt_pattern_corr=X"11") then
          Print("DPC GTX: 2 pixel correction  Loc4:" & INTEGER'IMAGE(to_integer(unsigned(in_4))) & " Loc0:" & INTEGER'IMAGE(to_integer(unsigned(in_0))) );    
        end if;  

      end if;
      
    end if;   
  end process;  
  
  
  --------------------------------
  -- Second step in pipeline (remap adder inputs)
  --------------------------------   
  
  sum_comb <= std_logic_vector('0' & in_0_P1) +  std_logic_vector('0' & in_4_P1);
  
  process(pix_clk)
  begin
    if (pix_clk'event and pix_clk='1') then
    
      if(proc_enable_P1='1') then 
        if(Correct_this_P1='1') then
          if(Correct_mode_P1="100") then      -- set white pixel
		    Curr_out    <= (others=>'1');
		  elsif(Correct_pattern_P1=X"01") then    --pixel droite
		    Curr_out    <= in_0_P1;
		  elsif(Correct_pattern_P1=X"10") then    -- pixel gauche
		    Curr_out    <= in_4_P1;		  
		  elsif(Correct_pattern_P1=X"11") then    -- moyenn D+G/2 
            Curr_out    <= sum_comb(10 downto 1);	
          end if;         
        else   
          Curr_out    <=  in_2_P1; --No single pixel to correct
        end if;     
      end if;  --proc_enable_P1          
    end if; --clk    
  end process;   

  

  

--  process(pix_clk)
--  begin
--    if (pix_clk'event and pix_clk='1') then       
--      if(proc_enable_P5='1' and Correct_this_P5 = '1') then
--        
--        if(Correct_mode_P5="000") then
--          Print("DPC GAIA: Pixel corrected is now " & INTEGER'IMAGE(conv_integer(in_8_P5)) & " LSB10  " & INTEGER'IMAGE(conv_integer(in_8_P5(9 downto 2))) & " LSB8");
--          Print(" ");
--        elsif(Correct_mode_P5="001") then
--          Print("DPC GAIA: Pixel corrected is now " & INTEGER'IMAGE(conv_integer(sum0_P5(10 downto 1))) & " LSB10  " & INTEGER'IMAGE(conv_integer(sum0_P5(10 downto 3))) & " LSB8");
--          Print(" ");
--        elsif(Correct_mode_P5="010") then
--          Print("DPC GAIA: Pixel corrected is now " & INTEGER'IMAGE(conv_integer(sum4_P5(11 downto 2))) & " LSB10  " & INTEGER'IMAGE(conv_integer(sum4_P5(11 downto 4))) & " LSB8"); 
--          Print(" ");
--        elsif(Correct_mode_P5="011") then          
--          Print("DPC GAIA: Pixel corrected is now " & INTEGER'IMAGE(conv_integer(sum6_P5(12 downto 3))) & " LSB10  " & INTEGER'IMAGE(conv_integer(sum6_P5(12 downto 5))) & " LSB8");
--          Print(" ");
--        end if;
--        Print("--------------------------------------------------------------------------------------------------------");
--        Print(" ");
--      end if;
--    
--    end if;   
--  end process; 
  


  
end functional;  
   
