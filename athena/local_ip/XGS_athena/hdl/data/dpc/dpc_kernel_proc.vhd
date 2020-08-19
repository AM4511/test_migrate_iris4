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

library work;
 use work.dpc_package.all;

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
  
  
  
  
  
entity dpc_kernel_proc is

  port(
    ---------------------------------------------------------------------
    -- Pixel domain reset and clock signals
    ---------------------------------------------------------------------
    pix_clk                              : in    std_logic;
    pix_reset                            : in    std_logic;
    ---------------------------------------------------------------------
    -- Data IN
    ---------------------------------------------------------------------
    proc_enable                          : in    std_logic;    
    proc_eol                             : in    std_logic; 
    proc_first_col                       : in    std_logic;
    proc_last_col                        : in    std_logic;
    proc_first_line                      : in    std_logic;  
    proc_last_line                       : in    std_logic;
    
    proc_X_pix_curr                      : in    std_logic_vector(12 downto 0);
    proc_Y_pix_curr                      : in    std_logic_vector(11 downto 0);    
 
    REG_dpc_pattern0_cfg                 : in    std_logic:='0';
 
    dpc_fifo_reset                       : in    std_logic;
    dpc_fifo_data_in                     : in    std_logic_vector(32 downto 0);
    dpc_fifo_write_in                    : in    std_logic;
    dpc_fifo_list_rdy                    : in    std_logic; --write logic has finish write to fifo, we can start prefetch
    
    ---------
    -- 3 2 1 
    -- 4 8 0 
    -- 5 6 7 
    ---------
    in_0                                 : in    std_logic_vector;
    in_1                                 : in    std_logic_vector;
    in_2                                 : in    std_logic_vector;    
    in_3                                 : in    std_logic_vector;
    in_4                                 : in    std_logic_vector;
    in_5                                 : in    std_logic_vector;    
    in_6                                 : in    std_logic_vector;
    in_7                                 : in    std_logic_vector;
    
    in_8                                 : in    std_logic_vector; --central pixel, bypass
    -------------------------------------------------
    -- Data OUT
    -------------------------------------------------
    Curr_out                             : out   std_logic_vector
  );
end dpc_kernel_proc;


architecture functional of dpc_kernel_proc is
  
  
  procedure Print(s : string) is 
  variable buf : line ; 
  begin
    write(buf, s) ; 
    WriteLine(OUTPUT, buf) ; 
  end procedure Print ; 
 
  
--  component xil_dpc_fifo_proc
--  Port ( 
--    clk : in STD_LOGIC;
--    srst : in STD_LOGIC;
--    din : in STD_LOGIC_VECTOR (32 downto 0 );
--    wr_en : in STD_LOGIC;
--    rd_en : in STD_LOGIC;
--    dout : out STD_LOGIC_VECTOR (32 downto 0 );
--    full : out STD_LOGIC;
--    empty : out STD_LOGIC
--  );
--  end component;  
  
 
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
  
  signal deadpix_exist   : std_logic:= '0';
  
  
  --------------------------------
  -- First step in pipeline
  --------------------------------  
  signal Correct_this_P1    : std_logic:='0';
  signal Correct_mode_P1    : std_logic_vector(2 downto 0);
  signal proc_enable_P1     : std_logic:='0';
  signal proc_eol_P1        : std_logic:='0';
  signal Correct_pattern_P1 : std_logic_vector(7 downto 0);
  signal in_0_P1            : std_logic_vector(9 downto 0);
  signal in_1_P1            : std_logic_vector(9 downto 0);
  signal in_2_P1            : std_logic_vector(9 downto 0);
  signal in_3_P1            : std_logic_vector(9 downto 0);
  signal in_4_P1            : std_logic_vector(9 downto 0);
  signal in_5_P1            : std_logic_vector(9 downto 0);
  signal in_6_P1            : std_logic_vector(9 downto 0);
  signal in_7_P1            : std_logic_vector(9 downto 0);
  signal in_8_P1            : std_logic_vector(9 downto 0);
  
  signal proc_first_col_P1  : std_logic:='0';
  signal proc_last_col_P1   : std_logic:='0';
  
  --------------------------------
  -- Second step in pipeline
  --------------------------------  
  signal Correct_this_P2   : std_logic:='0';
  signal Correct_mode_P2   : std_logic_vector(2 downto 0);
  signal proc_enable_P2    : std_logic:='0';
  signal in_0_P2           : std_logic_vector(9 downto 0);
  signal in_1_P2           : std_logic_vector(9 downto 0);
  signal in_2_P2           : std_logic_vector(9 downto 0);
  signal in_3_P2           : std_logic_vector(9 downto 0);
  signal in_4_P2           : std_logic_vector(9 downto 0);
  signal in_5_P2           : std_logic_vector(9 downto 0);
  signal in_6_P2           : std_logic_vector(9 downto 0);
  signal in_7_P2           : std_logic_vector(9 downto 0);
  signal in_8_P2           : std_logic_vector(9 downto 0);
  signal proc_eol_P2       : std_logic:='0';
  
  --------------------------------
  -- Third step in pipeline
  --------------------------------  
  signal Correct_this_P3   : std_logic:='0';
  signal Correct_mode_P3   : std_logic_vector(2 downto 0);
  signal proc_enable_P3    : std_logic:='0';
  signal sum0_P3           : std_logic_vector(10 downto 0);
  signal sum1_P3           : std_logic_vector(10 downto 0);
  signal sum2_P3           : std_logic_vector(10 downto 0);
  signal sum3_P3           : std_logic_vector(10 downto 0);
  signal in_8_P3           : std_logic_vector(9 downto 0);
  signal proc_eol_P3       : std_logic:='0';

  --------------------------------
  -- fourth step in pipeline
  --------------------------------  
  signal Correct_this_P4   : std_logic:='0';
  signal Correct_mode_P4   : std_logic_vector(2 downto 0);
  signal proc_enable_P4    : std_logic:='0';
  signal sum0_P4           : std_logic_vector(10 downto 0);
  signal sum4_P4           : std_logic_vector(11 downto 0);
  signal sum5_P4           : std_logic_vector(11 downto 0);
  signal in_8_P4           : std_logic_vector(9 downto 0);      
  signal proc_eol_P4       : std_logic:='0';

  --------------------------------
  -- five step in pipeline
  --------------------------------  
  signal Correct_this_P5   : std_logic:='0';
  signal Correct_mode_P5   : std_logic_vector(2 downto 0);
  signal proc_enable_P5    : std_logic:='0';
  signal sum0_P5           : std_logic_vector(10 downto 0);
  signal sum4_P5           : std_logic_vector(11 downto 0);
  signal sum6_P5           : std_logic_vector(12 downto 0);
  signal in_8_P5           : std_logic_vector(9 downto 0);
  signal proc_eol_P5       : std_logic:='0';  

  
begin


  --------------------------------
  -- Pre-First step in pipeline  (get the initial pixels to correct, if any)
  --------------------------------    
  dpc_fifo_srst <= '1' when (dpc_fifo_reset='1' or pix_reset='1') else '0';

  
--  X_xil_dpc_fifo_proc : xil_dpc_fifo_proc
--  PORT MAP (
--    clk    => pix_clk,
--    srst   => dpc_fifo_srst,
--    din    => dpc_fifo_data_in,
--    wr_en  => dpc_fifo_write_in,
--    rd_en  => dpc_fifo_rd_en,
--    dout   => dpc_fifo_dout,
--    full   => dpc_fifo_full,
--    empty  => dpc_fifo_empty
--  );
 
xpm_sensor_ser_fifo : xpm_fifo_sync
   generic map (
      DOUT_RESET_VALUE    => "0",       -- String
      ECC_MODE            => "no_ecc",  -- String
      FIFO_MEMORY_TYPE    => "auto",    -- String
      FIFO_READ_LATENCY   => 1,         -- DECIMAL ****
      FIFO_WRITE_DEPTH    => 64,        -- DECIMAL ****
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
									      
      wr_rst_busy   => open,              -- 1-bit output: Write Reset Busy: Active-High indicator that the FIFO write domain is currently in a reset state.
									      
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

      proc_first_col_P1  <= proc_first_col;       
      proc_last_col_P1   <= proc_last_col; 
      proc_eol_P1        <= proc_eol;
      
      in_8_P1            <= in_8;
      
      if(proc_enable='1') then     
       
        if(deadpix_exist='1' and proc_X_pix_curr = proc_nxt_X_pix_corr and proc_Y_pix_curr = proc_nxt_Y_pix_corr ) then
          
          -- TEST MODE PIXEL
          if( proc_nxt_pattern_corr=X"00" ) then  -- testmode set a white pixel
            Correct_mode_P1 <= "100";    
            if(REG_dpc_pattern0_cfg='0') then
              Correct_this_P1 <= '0';  -- bypass (use current pixel)
            else
              Correct_this_P1 <= '1';  -- replace current pixel with white pixel(0x3ff)            
            end if;            
          
          -- ONE pixel replacement (first/last Column)
          elsif( (proc_first_col='1' or proc_last_col='1') and ( proc_nxt_pattern_corr=X"88" or proc_nxt_pattern_corr=X"11" or proc_nxt_pattern_corr=X"22" or 
                                                                 proc_nxt_pattern_corr=X"33" or proc_nxt_pattern_corr=X"99" or proc_nxt_pattern_corr=X"aa" or
                                                                 proc_nxt_pattern_corr=X"bb" ) ) then                
            Correct_mode_P1 <= "000";
            Correct_this_P1 <= '1';           

          -- ONE pixel replacement (first/last Line)
          elsif( (proc_first_line='1' or proc_last_line='1') and ( proc_nxt_pattern_corr=X"44" or proc_nxt_pattern_corr=X"aa" or proc_nxt_pattern_corr=X"88" or 
                                                                   proc_nxt_pattern_corr=X"22" or proc_nxt_pattern_corr=X"66" or proc_nxt_pattern_corr=X"cc" or
                                                                   proc_nxt_pattern_corr=X"ee" ) ) then                
            Correct_mode_P1 <= "000";
            Correct_this_P1 <= '1';           
         
            
          -- TWO pixel interpolation
          elsif( ( (proc_first_col='1' or proc_last_col='1') and (                                proc_nxt_pattern_corr=X"66" or proc_nxt_pattern_corr=X"55" or --44 a ete optimise
                                                                   proc_nxt_pattern_corr=X"cc" or proc_nxt_pattern_corr=X"77" or proc_nxt_pattern_corr=X"dd" or 
                                                                   proc_nxt_pattern_corr=X"ee" or proc_nxt_pattern_corr=X"ff"  )  ) 
                 or
                 
                 ( (proc_first_line='1' or proc_last_line='1') and ( proc_nxt_pattern_corr=X"33" or proc_nxt_pattern_corr=X"99" or proc_nxt_pattern_corr=X"77" or
                                                                     proc_nxt_pattern_corr=X"dd" or proc_nxt_pattern_corr=X"bb" or proc_nxt_pattern_corr=X"11" or 
                                                                     proc_nxt_pattern_corr=X"55" or proc_nxt_pattern_corr=X"ff"  )  ) 
                 or                 
                   
                 proc_nxt_pattern_corr=X"22" or 
                 proc_nxt_pattern_corr=X"11" or 
                 proc_nxt_pattern_corr=X"88" or
                 proc_nxt_pattern_corr=X"44"     ) then
            Correct_mode_P1 <= "001";
            Correct_this_P1 <= '1';

            
          -- FOUR pixel interpolation
          elsif( proc_nxt_pattern_corr=X"aa" or 
                 proc_nxt_pattern_corr=X"99" or 
                 proc_nxt_pattern_corr=X"33" or
                 proc_nxt_pattern_corr=X"cc" or 
                 proc_nxt_pattern_corr=X"55" or 
                 proc_nxt_pattern_corr=X"66" or
                 proc_nxt_pattern_corr=X"77" or  -- 6pix correction mapped on 4
                 proc_nxt_pattern_corr=X"bb" or  -- 6pix correction mapped on 4
                 proc_nxt_pattern_corr=X"dd" or  -- 6pix correction mapped on 4 
                 proc_nxt_pattern_corr=X"ee"     -- 6pix correction mapped on 4                                                  
               ) then
            Correct_mode_P1 <= "010";
            Correct_this_P1 <= '1';
          
          -- EIGHT pixel interpolation
          elsif( proc_nxt_pattern_corr=X"ff") then
            Correct_mode_P1 <= "011";
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
        in_1_P1 <= in_1;
        in_2_P1 <= in_2;    
        in_3_P1 <= in_3;
        in_4_P1 <= in_4;
        in_5_P1 <= in_5;    
        in_6_P1 <= in_6;
        in_7_P1 <= in_7;          
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
        Print(" ");   
        Print("3 2 1 ");
        Print("4 8 0 ");
        Print("5 6 7 ");
        Print(" ");
        Print(INTEGER'IMAGE(to_integer(unsigned(in_3))) & " " & INTEGER'IMAGE(to_integer(unsigned(in_2))) & " " & INTEGER'IMAGE(to_integer(unsigned(in_1))) );
        Print(INTEGER'IMAGE(to_integer(unsigned(in_4))) & " " & INTEGER'IMAGE(to_integer(unsigned(in_8))) & " " & INTEGER'IMAGE(to_integer(unsigned(in_0))) );
        Print(INTEGER'IMAGE(to_integer(unsigned(in_5))) & " " & INTEGER'IMAGE(to_integer(unsigned(in_6))) & " " & INTEGER'IMAGE(to_integer(unsigned(in_7))) );
        Print(" ");
      
      
        if   (proc_first_col='1' and proc_nxt_pattern_corr=X"88") then
          Print("DPC GAIA: 1 pixel correction(First Col)  Loc7:" & INTEGER'IMAGE(to_integer(unsigned(in_7))) );      
        elsif(proc_first_col='1' and proc_nxt_pattern_corr=X"11") then 
          Print("DPC GAIA: 1 pixel correction(First Col)  Loc0:" & INTEGER'IMAGE(to_integer(unsigned(in_0))) );    
        elsif(proc_first_col='1' and proc_nxt_pattern_corr=X"22") then        
          Print("DPC GAIA: 1 pixel correction(First Col)  Loc1:" & INTEGER'IMAGE(to_integer(unsigned(in_1))) );    
        elsif(proc_first_col='1' and proc_nxt_pattern_corr=X"33") then 
          Print("DPC GAIA: 1 pixel correction(First Col)  Loc0:" & INTEGER'IMAGE(to_integer(unsigned(in_0))) );    
        elsif(proc_first_col='1' and proc_nxt_pattern_corr=X"99") then 
          Print("DPC GAIA: 1 pixel correction(First Col)  Loc0:" & INTEGER'IMAGE(to_integer(unsigned(in_0))) );    
        elsif(proc_first_col='1' and proc_nxt_pattern_corr=X"aa") then 
          Print("DPC GAIA: 1 pixel correction(First Col)  Loc7:" & INTEGER'IMAGE(to_integer(unsigned(in_7))) );    
        elsif(proc_first_col='1' and proc_nxt_pattern_corr=X"bb") then                 
          Print("DPC GAIA: 1 pixel correction(First Col)  Loc0:" & INTEGER'IMAGE(to_integer(unsigned(in_0))) );                   
      
        elsif(proc_last_col='1' and proc_nxt_pattern_corr=X"88") then 
          Print("DPC GAIA: 1 pixel correction(Last Col)  Loc3:" & INTEGER'IMAGE(to_integer(unsigned(in_3))) );        
        elsif(proc_last_col='1' and proc_nxt_pattern_corr=X"11") then
          Print("DPC GAIA: 1 pixel correction(Last Col)  Loc4:" & INTEGER'IMAGE(to_integer(unsigned(in_4))) );        
        elsif(proc_last_col='1' and proc_nxt_pattern_corr=X"22") then
          Print("DPC GAIA: 1 pixel correction(Last Col)  Loc5:" & INTEGER'IMAGE(to_integer(unsigned(in_5))) );        
        elsif(proc_last_col='1' and proc_nxt_pattern_corr=X"33") then
          Print("DPC GAIA: 1 pixel correction(Last Col)  Loc4:" & INTEGER'IMAGE(to_integer(unsigned(in_4))) );        
        elsif(proc_last_col='1' and proc_nxt_pattern_corr=X"99") then
          Print("DPC GAIA: 1 pixel correction(Last Col)  Loc4:" & INTEGER'IMAGE(to_integer(unsigned(in_4))) );        
        elsif(proc_last_col='1' and proc_nxt_pattern_corr=X"aa") then
          Print("DPC GAIA: 1 pixel correction(Last Col)  Loc5:" & INTEGER'IMAGE(to_integer(unsigned(in_5))) );        
        elsif(proc_last_col='1' and proc_nxt_pattern_corr=X"bb") then
          Print("DPC GAIA: 1 pixel correction(Last Col)  Loc4:" & INTEGER'IMAGE(to_integer(unsigned(in_4))) );        
 
        elsif   (proc_first_line='1' and proc_nxt_pattern_corr=X"44") then
          Print("DPC GAIA: 1 pixel correction(First Line)  Loc6:" & INTEGER'IMAGE(to_integer(unsigned(in_6))) );      
        elsif(proc_first_line='1' and proc_nxt_pattern_corr=X"aa") then 
          Print("DPC GAIA: 1 pixel correction(First Line)  Loc5:" & INTEGER'IMAGE(to_integer(unsigned(in_5))) );    
        elsif(proc_first_line='1' and proc_nxt_pattern_corr=X"88") then        
          Print("DPC GAIA: 1 pixel correction(First Line)  Loc7:" & INTEGER'IMAGE(to_integer(unsigned(in_7))) );    
        elsif(proc_first_line='1' and proc_nxt_pattern_corr=X"22") then 
          Print("DPC GAIA: 1 pixel correction(First Line)  Loc5:" & INTEGER'IMAGE(to_integer(unsigned(in_5))) );    
        elsif(proc_first_line='1' and proc_nxt_pattern_corr=X"66") then 
          Print("DPC GAIA: 1 pixel correction(First Line)  Loc6:" & INTEGER'IMAGE(to_integer(unsigned(in_6))) );    
        elsif(proc_first_line='1' and proc_nxt_pattern_corr=X"cc") then 
          Print("DPC GAIA: 1 pixel correction(First Line)  Loc6:" & INTEGER'IMAGE(to_integer(unsigned(in_6))) );    
        elsif(proc_first_line='1' and proc_nxt_pattern_corr=X"ee") then                 
          Print("DPC GAIA: 1 pixel correction(First Line)  Loc6:" & INTEGER'IMAGE(to_integer(unsigned(in_6))) );                   

        elsif   (proc_last_line='1' and proc_nxt_pattern_corr=X"44") then
          Print("DPC GAIA: 1 pixel correction(Last Line)  Loc2:" & INTEGER'IMAGE(to_integer(unsigned(in_2))) );      
        elsif(proc_last_line='1' and proc_nxt_pattern_corr=X"aa") then 
          Print("DPC GAIA: 1 pixel correction(Last Line)  Loc1:" & INTEGER'IMAGE(to_integer(unsigned(in_1))) );    
        elsif(proc_last_line='1' and proc_nxt_pattern_corr=X"88") then        
          Print("DPC GAIA: 1 pixel correction(Last Line)  Loc3:" & INTEGER'IMAGE(to_integer(unsigned(in_3))) );    
        elsif(proc_last_line='1' and proc_nxt_pattern_corr=X"22") then 
          Print("DPC GAIA: 1 pixel correction(Last Line)  Loc1:" & INTEGER'IMAGE(to_integer(unsigned(in_1))) );    
        elsif(proc_last_line='1' and proc_nxt_pattern_corr=X"66") then 
          Print("DPC GAIA: 1 pixel correction(Last Line)  Loc2:" & INTEGER'IMAGE(to_integer(unsigned(in_2))) );    
        elsif(proc_last_line='1' and proc_nxt_pattern_corr=X"cc") then 
          Print("DPC GAIA: 1 pixel correction(Last Line)  Loc2:" & INTEGER'IMAGE(to_integer(unsigned(in_2))) );    
        elsif(proc_last_line='1' and proc_nxt_pattern_corr=X"ee") then                 
          Print("DPC GAIA: 1 pixel correction(Last Line)  Loc2:" & INTEGER'IMAGE(to_integer(unsigned(in_2))) );                

       
        elsif( proc_first_col='1' or proc_last_col='1') and 
             ( proc_nxt_pattern_corr=X"44" or 
               proc_nxt_pattern_corr=X"66" or
               proc_nxt_pattern_corr=X"55" or
               proc_nxt_pattern_corr=X"cc" or
               proc_nxt_pattern_corr=X"77" or
               proc_nxt_pattern_corr=X"dd" or
               proc_nxt_pattern_corr=X"ee" or
               proc_nxt_pattern_corr=X"ff"
              ) then
          Print("DPC GAIA: 2 pixel correction (First-Last Col)  Loc2:" & INTEGER'IMAGE(to_integer(unsigned(in_2))) & "  Loc6:" & INTEGER'IMAGE(to_integer(unsigned(in_6))) );
        elsif( proc_first_line='1' or proc_last_line='1') and 
             ( proc_nxt_pattern_corr=X"33" or 
               proc_nxt_pattern_corr=X"99" or
               proc_nxt_pattern_corr=X"77" or
               proc_nxt_pattern_corr=X"dd" or
               proc_nxt_pattern_corr=X"bb" or
               proc_nxt_pattern_corr=X"11" or
               proc_nxt_pattern_corr=X"55" or
               proc_nxt_pattern_corr=X"ff"
              ) then
          Print("DPC GAIA: 2 pixel correction (First-Last Line)  Loc0:" & INTEGER'IMAGE(to_integer(unsigned(in_0))) & "  Loc4:" & INTEGER'IMAGE(to_integer(unsigned(in_4))) );              
        elsif(proc_nxt_pattern_corr=X"22") then
          Print("DPC GAIA: 2 pixel correction  Loc1:" & INTEGER'IMAGE(to_integer(unsigned(in_1))) & "  Loc5:" & INTEGER'IMAGE(to_integer(unsigned(in_5))) );
        elsif(proc_nxt_pattern_corr=X"11") then
          Print("DPC GAIA: 2 pixel correction  Loc1:" & INTEGER'IMAGE(to_integer(unsigned(in_1))) & "  Loc7:" & INTEGER'IMAGE(to_integer(unsigned(in_7))) );
        elsif(proc_nxt_pattern_corr=X"88") then
          Print("DPC GAIA: 2 pixel correction  Loc3:" & INTEGER'IMAGE(to_integer(unsigned(in_3))) & "  Loc7:" & INTEGER'IMAGE(to_integer(unsigned(in_7))) );
        elsif(proc_nxt_pattern_corr=X"44") then
          Print("DPC GAIA: 2 pixel correction  Loc2:" & INTEGER'IMAGE(to_integer(unsigned(in_2))) & "  Loc6:" & INTEGER'IMAGE(to_integer(unsigned(in_6))) );     
        
        elsif(proc_nxt_pattern_corr=X"aa" or proc_nxt_pattern_corr=X"bb" or proc_nxt_pattern_corr=X"ee") then
          Print("DPC GAIA: 4 pixel correction  Loc1:" & INTEGER'IMAGE(to_integer(unsigned(in_1))) & "  Loc3:" & INTEGER'IMAGE(to_integer(unsigned(in_3))) & "  Loc5:" & INTEGER'IMAGE(to_integer(unsigned(in_5))) & "  Loc7:" & INTEGER'IMAGE(to_integer(unsigned(in_7))) );
        elsif(proc_nxt_pattern_corr=X"99") then
          Print("DPC GAIA: 4 pixel correction  Loc0:" & INTEGER'IMAGE(to_integer(unsigned(in_0))) & "  Loc3:" & INTEGER'IMAGE(to_integer(unsigned(in_3))) & "  Loc4:" & INTEGER'IMAGE(to_integer(unsigned(in_4))) & "  Loc7:" & INTEGER'IMAGE(to_integer(unsigned(in_7))) );
        elsif(proc_nxt_pattern_corr=X"33") then
          Print("DPC GAIA: 4 pixel correction  Loc0:" & INTEGER'IMAGE(to_integer(unsigned(in_0))) & "  Loc1:" & INTEGER'IMAGE(to_integer(unsigned(in_1))) & "  Loc4:" & INTEGER'IMAGE(to_integer(unsigned(in_4))) & "  Loc5:" & INTEGER'IMAGE(to_integer(unsigned(in_5))) );
        elsif(proc_nxt_pattern_corr=X"cc") then
          Print("DPC GAIA: 4 pixel correction  Loc2:" & INTEGER'IMAGE(to_integer(unsigned(in_2))) & "  Loc3:" & INTEGER'IMAGE(to_integer(unsigned(in_3))) & "  Loc6:" & INTEGER'IMAGE(to_integer(unsigned(in_6))) & "  Loc7:" & INTEGER'IMAGE(to_integer(unsigned(in_7))) );
        elsif(proc_nxt_pattern_corr=X"55"or proc_nxt_pattern_corr=X"77" or proc_nxt_pattern_corr=X"dd"  ) then
          Print("DPC GAIA: 4 pixel correction  Loc0:" & INTEGER'IMAGE(to_integer(unsigned(in_0))) & "  Loc2:" & INTEGER'IMAGE(to_integer(unsigned(in_2))) & "  Loc4:" & INTEGER'IMAGE(to_integer(unsigned(in_4))) & "  Loc6:" & INTEGER'IMAGE(to_integer(unsigned(in_6))) );
        elsif(proc_nxt_pattern_corr=X"66") then
          Print("DPC GAIA: 4 pixel correction  Loc1:" & INTEGER'IMAGE(to_integer(unsigned(in_1))) & "  Loc2:" & INTEGER'IMAGE(to_integer(unsigned(in_2))) & "  Loc5:" & INTEGER'IMAGE(to_integer(unsigned(in_5))) & "  Loc6:" & INTEGER'IMAGE(to_integer(unsigned(in_6))) );
        
        elsif(proc_nxt_pattern_corr=X"ff") then
          Print("DPC GAIA: 8 pixel correction, all pixel are Locs are: " & INTEGER'IMAGE(to_integer(unsigned(in_0)))
                                                                         & INTEGER'IMAGE(to_integer(unsigned(in_1)))
                                                                         & INTEGER'IMAGE(to_integer(unsigned(in_2)))
                                                                         & INTEGER'IMAGE(to_integer(unsigned(in_3)))
                                                                         & INTEGER'IMAGE(to_integer(unsigned(in_4)))
                                                                         & INTEGER'IMAGE(to_integer(unsigned(in_5)))
                                                                         & INTEGER'IMAGE(to_integer(unsigned(in_6)))
                                                                         & INTEGER'IMAGE(to_integer(unsigned(in_7))) );         
        end if;  

      end if;
      
    end if;   
  end process;  
  
  
  --------------------------------
  -- Second step in pipeline (remap adder inputs)
  --------------------------------   
  process(pix_clk)
  begin
    if (pix_clk'event and pix_clk='1') then

      proc_enable_P2     <= proc_enable_P1;
      proc_eol_P2        <= proc_eol_P1;
     
      if(proc_enable_P1='1') then         
        Correct_this_P2 <= Correct_this_P1;
      elsif(proc_eol_P1='1') then          
        Correct_this_P2 <= '0';  --bypass     
      else
        Correct_this_P2 <= Correct_this_P2;
      end if;
      
      if(proc_enable_P1='1') then 
        Correct_mode_P2 <= Correct_mode_P1;

        if(Correct_this_P1='1') then

          if(proc_first_col_P1='1') then
            if(Correct_pattern_P1=X"88" or Correct_pattern_P1=X"aa") then    
              in_8_P2         <= in_7_P1;
            elsif(Correct_pattern_P1=X"11" or Correct_pattern_P1=X"33" or Correct_pattern_P1=X"99" or Correct_pattern_P1=X"bb") then                 
              in_8_P2         <= in_0_P1;
            elsif(Correct_pattern_P1=X"22") then                 
              in_8_P2         <= in_1_P1;
            end if;

          elsif(proc_last_col_P1='1') then
            if(Correct_pattern_P1=X"88") then                 
              in_8_P2         <= in_3_P1;
            elsif(Correct_pattern_P1=X"11" or Correct_pattern_P1=X"33" or Correct_pattern_P1=X"99"  or Correct_pattern_P1=X"bb") then                 
              in_8_P2         <= in_4_P1;          
            elsif(Correct_pattern_P1=X"22" or Correct_pattern_P1=X"aa") then                 
              in_8_P2         <= in_5_P1;   
            end if;  
          
          elsif(proc_first_line='1') then
            if(Correct_pattern_P1=X"44" or Correct_pattern_P1=X"66" or Correct_pattern_P1=X"cc" or Correct_pattern_P1=X"ee") then    
              in_8_P2         <= in_6_P1;
            elsif(Correct_pattern_P1=X"aa" or Correct_pattern_P1=X"22") then                 
              in_8_P2         <= in_5_P1;
            elsif(Correct_pattern_P1=X"88") then                 
              in_8_P2         <= in_7_P1;
            end if;
          
          elsif(proc_last_line='1') then
            if(Correct_pattern_P1=X"44" or Correct_pattern_P1=X"66" or Correct_pattern_P1=X"cc" or Correct_pattern_P1=X"ee") then    
              in_8_P2         <= in_2_P1;
            elsif(Correct_pattern_P1=X"aa" or Correct_pattern_P1=X"22") then                 
              in_8_P2         <= in_1_P1;
            elsif(Correct_pattern_P1=X"88") then                 
              in_8_P2         <= in_3_P1;              
            end if;          
            
          end if;
          
        else   
          in_8_P2    <=  in_8_P1; --No single pixel to correct
        end if;

        
        if(Correct_this_P1='1') then
          
          if(proc_first_col_P1='1' or proc_last_col_P1='1') and (                            Correct_pattern_P1=X"66" or Correct_pattern_P1=X"55" or --44 a ete optimise
                                                                 Correct_pattern_P1=X"cc" or Correct_pattern_P1=X"77" or Correct_pattern_P1=X"dd" or 
                                                                 Correct_pattern_P1=X"ee" or Correct_pattern_P1=X"ff"   )  then    
            in_0_P2 <= in_2_P1;                                                       

          elsif(proc_first_line='1' or proc_last_line='1') and  (Correct_pattern_P1=X"33" or Correct_pattern_P1=X"99" or Correct_pattern_P1=X"77" or
                                                                 Correct_pattern_P1=X"dd" or Correct_pattern_P1=X"bb" or Correct_pattern_P1=X"11" or
                                                                 Correct_pattern_P1=X"55" or Correct_pattern_P1=X"ff"   )  then    
            in_0_P2 <= in_0_P1;            
            
          -- in0/1 loaded if correcting with 2/4/8 pixels (correct_this_P1=1)
          elsif(Correct_pattern_P1=X"82" or Correct_pattern_P1=X"22" or Correct_pattern_P1=X"aa" or Correct_pattern_P1=X"bb" or Correct_pattern_P1=X"ee" or Correct_pattern_P1=X"66") then       
            in_0_P2 <= in_1_P1;
          elsif(Correct_pattern_P1=X"44" or Correct_pattern_P1=X"cc") then 
            in_0_P2 <= in_2_P1;
          elsif(Correct_pattern_P1=X"28" or Correct_pattern_P1=X"88") then 
            in_0_P2 <= in_3_P1;
          else
            in_0_P2 <= in_0_P1;
          end if;
          
          
          if(proc_first_col_P1='1' or proc_last_col_P1='1') and (                            Correct_pattern_P1=X"66" or Correct_pattern_P1=X"55" or --44 a ete optimise
                                                                 Correct_pattern_P1=X"cc" or Correct_pattern_P1=X"77" or Correct_pattern_P1=X"dd" or 
                                                                 Correct_pattern_P1=X"ee" or Correct_pattern_P1=X"ff"    )  then    
            in_1_P2 <= in_6_P1; 
          
          elsif(proc_first_line='1' or proc_last_line='1') and  (Correct_pattern_P1=X"33" or Correct_pattern_P1=X"99" or Correct_pattern_P1=X"77" or
                                                                 Correct_pattern_P1=X"dd" or Correct_pattern_P1=X"bb" or Correct_pattern_P1=X"11" or
                                                                 Correct_pattern_P1=X"55" or Correct_pattern_P1=X"ff"   )  then    
            in_1_P2 <= in_4_P1;            
                  
          elsif(Correct_pattern_P1=X"55" or Correct_pattern_P1=X"77" or Correct_pattern_P1=X"dd" or Correct_pattern_P1=X"66") then       
            in_1_P2 <= in_2_P1;
          elsif(Correct_pattern_P1=X"aa" or Correct_pattern_P1=X"bb" or Correct_pattern_P1=X"ee" or Correct_pattern_P1=X"99" or Correct_pattern_P1=X"cc") then 
            in_1_P2 <= in_3_P1;
          elsif(Correct_pattern_P1=X"28" or Correct_pattern_P1=X"22") then 
            in_1_P2 <= in_5_P1;
          elsif(Correct_pattern_P1=X"44") then 
            in_1_P2 <= in_6_P1;
          elsif(Correct_pattern_P1=X"82" or Correct_pattern_P1=X"88") then 
            in_1_P2 <= in_7_P1; 
          elsif(Correct_pattern_P1=X"11") then 
            in_1_P2 <= in_4_P1;  
          else       
            in_1_P2 <= in_1_P1;         
          end if;        
          
          -- in2/3 loaded if correcting with 4/8 pixels
          if(Correct_mode_P1="010" or Correct_mode_P1="011") then 
            if(Correct_pattern_P1=X"99" or Correct_pattern_P1=X"33" or Correct_pattern_P1=X"55" or Correct_pattern_P1=X"77" or Correct_pattern_P1=X"dd") then       
              in_2_P2 <= in_4_P1;
            elsif(Correct_pattern_P1=X"aa" or Correct_pattern_P1=X"bb" or Correct_pattern_P1=X"ee" or Correct_pattern_P1=X"66") then 
              in_2_P2 <= in_5_P1;
            elsif(Correct_pattern_P1=X"cc") then 
              in_2_P2 <= in_6_P1; 
            else       
              in_2_P2 <= in_2_P1;         
            end if;  
            
            if(Correct_pattern_P1=X"33") then       
              in_3_P2 <= in_5_P1;
            elsif(Correct_pattern_P1=X"55" or Correct_pattern_P1=X"77" or Correct_pattern_P1=X"dd" or Correct_pattern_P1=X"66") then 
              in_3_P2 <= in_6_P1;
            elsif(Correct_pattern_P1=X"aa" or Correct_pattern_P1=X"bb" or Correct_pattern_P1=X"ee" or Correct_pattern_P1=X"99" or Correct_pattern_P1=X"cc" ) then 
              in_3_P2 <= in_7_P1; 
            else       
              in_3_P2 <= in_3_P1;         
            end if;          
          end if;
          
          -- in4/5/6/7 loaded if correcting with 8 pixels
          if(Correct_mode_P1="011") then
            in_4_P2 <= in_4_P1;
            in_5_P2 <= in_5_P1;    
            in_6_P2 <= in_6_P1;
            in_7_P2 <= in_7_P1;
          end if;
        
        end if; --if(correct_this_P1=1)
      
      end if;  --proc_enable_P1
           
    end if; --clk
    
  end process;   

  
  --------------------------------
  -- Third step in pipeline (first stage adders)
  --------------------------------  
  process(pix_clk)
  begin
    if (pix_clk'event and pix_clk='1') then
           
      proc_enable_P3     <= proc_enable_P2;     
      proc_eol_P3        <= proc_eol_P2;

      if(proc_enable_P2='1') then 
        Correct_this_P3 <= Correct_this_P2;
      elsif(proc_eol_P2='1') then          
        Correct_this_P3 <= '0';  --bypass     
      else
        Correct_this_P3 <= Correct_this_P3;
      end if;

      
      if(proc_enable_P2='1') then 

        Correct_mode_P3 <= Correct_mode_P2;
        in_8_P3         <= in_8_P2;    
        
        -- Sum0 loaded if correcting with 2/4/8 pixels
        if(Correct_mode_P2="001" or Correct_mode_P2="010" or Correct_mode_P2="011") then
          sum0_P3 <= std_logic_vector('0' & in_0_P2) +  std_logic_vector('0' & in_1_P2);
        end if;
        
        -- Sum1 loaded if correcting with 4/8 pixels        
        if(Correct_mode_P2="010" or Correct_mode_P2="011") then 
          sum1_P3 <= std_logic_vector('0' & in_2_P2) +  std_logic_vector('0' & in_3_P2);
        end if;
        
        -- Sum2/3 loaded if correcting with 8 pixels
        if(Correct_mode_P2="011") then 
          sum2_P3 <= std_logic_vector('0' & in_4_P2) +  std_logic_vector('0' & in_5_P2);                
          sum3_P3 <= std_logic_vector('0' & in_6_P2) +  std_logic_vector('0' & in_7_P2);        
        end if; 
      end if;  --proc_enable_P2
      
    end if;
    
  end process;   
  

  --------------------------------
  -- fourth step in pipeline (second stage adders)
  --------------------------------  
  process(pix_clk)
  begin
    if (pix_clk'event and pix_clk='1') then
      
      proc_enable_P4     <= proc_enable_P3;           
      proc_eol_P4        <= proc_eol_P3;
      
      if(proc_enable_P3='1') then      
        Correct_this_P4 <= Correct_this_P3;
      elsif(proc_eol_P3='1') then          
        Correct_this_P4 <= '0';  --bypass     
      else
        Correct_this_P4 <= Correct_this_P4;
      end if;
      
      if(proc_enable_P3='1') then 
        Correct_mode_P4 <= Correct_mode_P3;
        in_8_P4         <= in_8_P3;

        -- Sum0 loaded if correcting with 2 pixels        
        if(Correct_mode_P3="001") then         
          sum0_P4 <= sum0_P3;
        end if;
        
        -- Sum4 loaded if correcting with 4/8 pixels        
        if(Correct_mode_P3="010" or Correct_mode_P3="011") then        
          sum4_P4 <= std_logic_vector('0' & sum0_P3) +  std_logic_vector('0' & sum1_P3);
        end if;
        
        -- Sum5 loaded if correcting with 8 pixels        
        if(Correct_mode_P3="011") then         
          sum5_P4 <= std_logic_vector('0' & sum2_P3) +  std_logic_vector('0' & sum3_P3);                
        end if; 
    
      end if;  --proc_enable_P3
      
    end if;
    
  end process;   

  --------------------------------
  -- five step in pipeline  (third stage adders)
  --------------------------------  
  process(pix_clk)
  begin
    if (pix_clk'event and pix_clk='1') then

      proc_enable_P5     <= proc_enable_P4;                
      proc_eol_P5        <= proc_eol_P4;            
      
      if(proc_enable_P4='1') then 
        Correct_this_P5 <= Correct_this_P4;
      elsif(proc_eol_P4='1') then          
        Correct_this_P5 <= '0';  --bypass     
      else
        Correct_this_P5 <= Correct_this_P5;
      end if;
      
      if(proc_enable_P4='1') then 

        Correct_mode_P5 <= Correct_mode_P4;
        in_8_P5         <= in_8_P4;

        -- Sum0 loaded if correcting with 2 pixels        
        if(Correct_mode_P4="001") then                 
          sum0_P5 <= sum0_P4;
        end if;
        
        -- Sum4 loaded if correcting with 4 pixels        
        if(Correct_mode_P4="010") then         
          sum4_P5 <= sum4_P4;
        end if;

        -- Sum6 loaded if correcting with 8 pixels        
        if(Correct_mode_P4="011") then          
          sum6_P5 <= std_logic_vector('0' & sum4_P4) +  std_logic_vector('0' & sum5_P4);
        end if;     
    
      end if;  --proc_enable_P4
      
    end if;
    
  end process; 
  
  --------------------------------
  -- sixth step in pipeline (COMBINATOIRE)
  -------------------------------- 
  Curr_out <=  "1111111111"         when (Correct_this_P5='1' and Correct_mode_P5="100") else --for identify where we are
               sum0_P5(10 downto 1) when (Correct_this_P5='1' and Correct_mode_P5="001") else 
               sum4_P5(11 downto 2) when (Correct_this_P5='1' and Correct_mode_P5="010") else
               sum6_P5(12 downto 3) when (Correct_this_P5='1' and Correct_mode_P5="011") else
               in_8_P5;                                                                       --bypass, or single pixel replacement(first and last column and row)
  

  process(pix_clk)
  begin
    if (pix_clk'event and pix_clk='1') then       
      if(proc_enable_P5='1' and Correct_this_P5 = '1') then
        
        if(Correct_mode_P5="000") then
          Print("DPC GAIA: Pixel corrected is now " & INTEGER'IMAGE(conv_integer(in_8_P5)) & " LSB10  " & INTEGER'IMAGE(conv_integer(in_8_P5(9 downto 2))) & " LSB8");
          Print(" ");
        elsif(Correct_mode_P5="001") then
          Print("DPC GAIA: Pixel corrected is now " & INTEGER'IMAGE(conv_integer(sum0_P5(10 downto 1))) & " LSB10  " & INTEGER'IMAGE(conv_integer(sum0_P5(10 downto 3))) & " LSB8");
          Print(" ");
        elsif(Correct_mode_P5="010") then
          Print("DPC GAIA: Pixel corrected is now " & INTEGER'IMAGE(conv_integer(sum4_P5(11 downto 2))) & " LSB10  " & INTEGER'IMAGE(conv_integer(sum4_P5(11 downto 4))) & " LSB8"); 
          Print(" ");
        elsif(Correct_mode_P5="011") then          
          Print("DPC GAIA: Pixel corrected is now " & INTEGER'IMAGE(conv_integer(sum6_P5(12 downto 3))) & " LSB10  " & INTEGER'IMAGE(conv_integer(sum6_P5(12 downto 5))) & " LSB8");
          Print(" ");
        end if;
        Print("--------------------------------------------------------------------------------------------------------");
        Print(" ");
      end if;
    
    end if;   
  end process; 
  


  
end functional;  
   
