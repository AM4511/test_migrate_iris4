-----------------------------------------------------------------------
-- $HeadURL: svn://brainstorm/fpga/trunk/Matrox/Imaging/FPGA/Iris3/cores/python_if/design/dpc_kernel_10x3.vhd $
-- $Author: jmansill $
-- $Revision: 20201 $
-- $Date: 2019-07-15 16:04:33 -0400 (Mon, 15 Jul 2019) $
--
-- DESCRIPTION: 
--
-- Ce module sert a buffer 2 lignes dans des linebuffers, et sortir
-- un kernel 10 pixels 10bpp x 3 lignes, prets pour se faire traiter par un filtre.
--
-- On sort 10 pixels, qui serviront au overscan horizontal ainsi qu'a traiter les 
-- kernels 8 ou 4 pixels en parallele du senseur PYTHON.
--
-- La premiere et derniere ligne ne sont pas traitees.
--
-- Ce code supporte  2 ROI de meme grandeur X-pixels.
-- 
--
-------------------------------------------
library ieee;
 use ieee.std_logic_1164.all;
 use IEEE.std_logic_unsigned.all;

library work;
 use work.dpc_package.all;

Library xpm;
  use xpm.vcomponents.all;


entity dpc_kernel_10x3 is
  generic(
    lvds_ch        : integer := 1;  -- 1:P480  -- To identify P480 camera
    KHEIGHT_GEN    : integer := 3
  );
  port(
    ---------------------------------------------------------------------
    -- Pixel domain reset and clock signals
    ---------------------------------------------------------------------
    pix_clk                              : in    std_logic;
    pix_reset                            : in    std_logic;

    ---------------------------------------------------------------------
    -- Overrun registers
    ---------------------------------------------------------------------
    REG_dpc_enable_DB                  : in    std_logic;

    REG_dpc_fifo_rst                   : in    std_logic;
    REG_dpc_fifo_ovr                   : out   std_logic;
    REG_dpc_fifo_und                   : out   std_logic;
    
    ---------------------------------------------------------------------
    -- Data and control in
    ---------------------------------------------------------------------
    start_of_frame_in                    : in    std_logic;
    start_of_line_in                     : in    std_logic;
    end_of_line_in                       : in    std_logic;
    pixel_in_en                          : in    std_logic;
    pixel_in                             : in    std_logic_vector;
    end_of_frame_in                      : in    std_logic;
    
	m_axis_ack                           : in    std_logic; -- for last line read burst
	m_axis_tvalid                        : in    std_logic; -- for last line read burst
	m_axis_tready                        : in    std_logic; -- for last line read burst
    ---------------------------------------------------------------------
    -- Data and control out
    ---------------------------------------------------------------------
    first_line_out                       : out   std_logic;  
    last_line_out                        : out   std_logic;
    first_col_out                        : out   std_logic;
    last_col_out                         : out   std_logic;
    start_of_frame_out                   : out   std_logic;
    start_of_line_out                    : out   std_logic;
    neighbor_en                          : out   std_logic;
    neighbor_out                         : out   STD100_LOGIC_VECTOR(KHEIGHT_GEN-1 downto 0):= (others =>(others=>'0'));  --10 pixels wide x 3 lines
    end_of_line_out                      : out   std_logic;
    end_of_frame_out                     : out   std_logic
  );
end dpc_kernel_10x3;


architecture functional of dpc_kernel_10x3 is
  
  component xil_nopel_fifo32 is
  port (
    rd_en     : in STD_LOGIC; 
    overflow  : out STD_LOGIC; 
    wr_en     : in STD_LOGIC; 
    full      : out STD_LOGIC; 
    empty     : out STD_LOGIC; 
    clk       : in STD_LOGIC; 
    srst      : in STD_LOGIC; 
    underflow : out STD_LOGIC; 
    dout      : out STD_LOGIC_VECTOR ( 59 downto 0 ); 
    din       : in STD_LOGIC_VECTOR ( 59 downto 0 ) 
  );
  END component xil_nopel_fifo32;
  
  component xil_nopel_fifo64 is
  port (
    rd_en     : in STD_LOGIC; 
    overflow  : out STD_LOGIC; 
    wr_en     : in STD_LOGIC; 
    full      : out STD_LOGIC; 
    empty     : out STD_LOGIC; 
    clk       : in STD_LOGIC; 
    srst      : in STD_LOGIC; 
    underflow : out STD_LOGIC; 
    dout      : out STD_LOGIC_VECTOR ( 99 downto 0 ); 
    din       : in STD_LOGIC_VECTOR ( 99 downto 0 ) 
  );
  END component xil_nopel_fifo64;
  
  
  constant BUS_Data_Width  : integer := (pixel_in'high+1);      -- 1 base!   60=>4 pixels bus interface + 2OS  ;   100=>8 pixels bus interface + 2OS
  
  
  -- reset signal HIGH for at least 5 clock cycles - needed by the fifos used here - see spec of FIFO
  signal rst_fifo_5cc            : std_logic := '1';


  -- counter for the lines entering the module and filling the buffers while no lines are being output
  -- we use this counter to mask the pixel_in_en signal which generates the pixel_out_en
  signal cntr_firsts_lines        : std_logic_vector(1 downto 0); 
             
  -- signal first_line_done is 0 at first, and becomes 1 when the first line is all received and processed inside
  -- the current module. Useful for line buffers read.
  signal first_line_done         : std_logic:='0';
  
  -- signal second_line_done is 0 at first, and becomes 1 when the second line is all received and processed inside
  -- the current module. Useful for line buffers read.
  signal second_line_done        : std_logic:='0';
  
  -- line buffers signals
  -- we write to all line buffers when pixel_in_en or data_enable_os_in is HIGH
  signal lbuff_wren_first              : std_logic:='0';
  signal lbuff_wren_second             : std_logic:='0';
  -- we read to all line buffers when we write to them, exception: during the first line, we don't read to line buffers
  signal lbuff_first_rden              : std_logic:='0';
  signal lbuff_second_rden             : std_logic:='0';

  signal pixel_in_P1             : std_logic_vector(pixel_in'range);
  
  -- line buffers signals
  signal dout_first              : std_logic_vector(pixel_in'range);
  signal dout_second             : std_logic_vector(pixel_in'range);
  
  signal start_of_frame_in_P1    : std_logic:='0';
  signal sol_P1                  : std_logic:='0';
  signal eol_P1                  : std_logic:='0';
  signal eof_os                  : std_logic:='0';
  signal enable_P1               : std_logic:='0';

  signal lbuff_first_empty      : std_logic;
  signal lbuff_first_underflow  : std_logic;
  signal lbuff_first_full       : std_logic;
  signal lbuff_first_overflow   : std_logic;
  
  signal lbuff_second_empty     : std_logic;
  signal lbuff_second_underflow : std_logic;
  signal lbuff_second_full      : std_logic;
  signal lbuff_second_overflow  : std_logic;
  
  signal eof_delaying_P1        : std_logic :='0';
  signal eof_delaying           : std_logic :='0';
  signal eof_cntr               : std_logic_vector(5 downto 0);
  
  signal lbuff_first_rden_OS    : std_logic :='0';
  signal lbuff_second_rden_OS   : std_logic :='0';
  
  signal last_line_fifo_rd      : std_logic :='0';
  signal last_line_fifo_rd_P1   : std_logic :='0';
  signal last_line_fifo_rd_P2   : std_logic :='0';
  signal last_line_fifo_rd_P3   : std_logic :='0';
   
  signal last_line_fifo_en      : std_logic :='0';
  signal last_line_fifo_en_P1   : std_logic :='0';
  signal last_line_fifo_en_P2   : std_logic :='0';

  signal last_line_fifo_rd_prefetch : std_logic :='0';
  
  signal last_line_fifo_rd_cntr    : std_logic_vector(9 downto 0);
  signal last_line_fifo_rd_started    : std_logic:='0';
  signal last_line_fifo_rd_started_P1 : std_logic:='0';

  signal lbuff_line_length         : std_logic_vector(9 downto 0);
  
  signal last_line_fifo_eol     : std_logic :='0';  -- for 480 support
  signal last_line_fifo_eol_P1  : std_logic :='0';  -- for 480 support
  signal last_line_fifo_eol_P2  : std_logic :='0';  -- for 480 support
  
  signal REG_dpc_fifo_rst_P1_resync : std_logic :='0';
  signal REG_dpc_fifo_rst_P2_resync : std_logic :='0';
  signal REG_dpc_fifo_rst_P3        : std_logic :='0';
  signal REG_dpc_fifo_rst_P4        : std_logic :='0';
  signal REG_dpc_fifo_rst_P5        : std_logic :='0';
  signal REG_dpc_fifo_rst_P6        : std_logic :='0';
  signal REG_dpc_fifo_rst_P7        : std_logic :='0';
  
  signal fifo_rst_P1 : std_logic := '1';
  signal fifo_rst_P2 : std_logic := '1';
  signal fifo_rst_P3 : std_logic := '1';
  signal fifo_rst_P4 : std_logic := '1';
  signal fifo_rst_P5 : std_logic := '1';
  signal fifo_rst    : std_logic := '1';
  
  signal first_line        : std_logic := '0';
  signal last_line         : std_logic := '0';
  signal last_line_P1      : std_logic := '0';
  signal first_col_out_int : std_logic := '0';
  
  
  --------------------------
  -- ALIAS FOR SIMULATION
  --------------------------
  alias alias_fifo_first_in_0    : std_logic_vector(7 downto 0) is pixel_in_P1(19 downto 12);
  alias alias_fifo_first_in_1    : std_logic_vector(7 downto 0) is pixel_in_P1(29 downto 22);
  alias alias_fifo_first_in_2    : std_logic_vector(7 downto 0) is pixel_in_P1(39 downto 32);
  alias alias_fifo_first_in_3    : std_logic_vector(7 downto 0) is pixel_in_P1(49 downto 42);
  --alias alias_fifo_first_in_4    : std_logic_vector(7 downto 0) is pixel_in_P1(59 downto 52);
  --alias alias_fifo_first_in_5    : std_logic_vector(7 downto 0) is pixel_in_P1(69 downto 62);
  --alias alias_fifo_first_in_6    : std_logic_vector(7 downto 0) is pixel_in_P1(79 downto 72);
  --alias alias_fifo_first_in_7    : std_logic_vector(7 downto 0) is pixel_in_P1(89 downto 82);
                           
  alias alias_fifo_first_out_0   : std_logic_vector(7 downto 0) is dout_first(19 downto 12);
  alias alias_fifo_first_out_1   : std_logic_vector(7 downto 0) is dout_first(29 downto 22);
  alias alias_fifo_first_out_2   : std_logic_vector(7 downto 0) is dout_first(39 downto 32);
  alias alias_fifo_first_out_3   : std_logic_vector(7 downto 0) is dout_first(49 downto 42);
  --alias alias_fifo_first_out_4   : std_logic_vector(7 downto 0) is dout_first(59 downto 52);
  --alias alias_fifo_first_out_5   : std_logic_vector(7 downto 0) is dout_first(69 downto 62);
  --alias alias_fifo_first_out_6   : std_logic_vector(7 downto 0) is dout_first(79 downto 72);
  --alias alias_fifo_first_out_7   : std_logic_vector(7 downto 0) is dout_first(89 downto 82);
  
  alias alias_fifo_second_out_0  :  std_logic_vector(7 downto 0) is dout_second(19 downto 12);
  alias alias_fifo_second_out_1  :  std_logic_vector(7 downto 0) is dout_second(29 downto 22);
  alias alias_fifo_second_out_2  :  std_logic_vector(7 downto 0) is dout_second(39 downto 32);
  alias alias_fifo_second_out_3  :  std_logic_vector(7 downto 0) is dout_second(49 downto 42);
  --alias alias_fifo_second_out_4  :  std_logic_vector(7 downto 0) is dout_second(59 downto 52);
  --alias alias_fifo_second_out_5  :  std_logic_vector(7 downto 0) is dout_second(69 downto 62);
  --alias alias_fifo_second_out_6  :  std_logic_vector(7 downto 0) is dout_second(79 downto 72);
  --alias alias_fifo_second_out_7  :  std_logic_vector(7 downto 0) is dout_second(89 downto 82);
    
  alias alias_kernel_10x3_0_0   : std_logic_vector(7 downto 0) is neighbor_out(0)(19 downto 12);
  alias alias_kernel_10x3_0_1   : std_logic_vector(7 downto 0) is neighbor_out(0)(29 downto 22);
  alias alias_kernel_10x3_0_2   : std_logic_vector(7 downto 0) is neighbor_out(0)(39 downto 32);
  alias alias_kernel_10x3_0_3   : std_logic_vector(7 downto 0) is neighbor_out(0)(49 downto 42);
  --alias alias_kernel_10x3_0_4   : std_logic_vector(7 downto 0) is neighbor_out(0)(59 downto 52);
  --alias alias_kernel_10x3_0_5   : std_logic_vector(7 downto 0) is neighbor_out(0)(69 downto 62);
  --alias alias_kernel_10x3_0_6   : std_logic_vector(7 downto 0) is neighbor_out(0)(79 downto 72);
  --alias alias_kernel_10x3_0_7   : std_logic_vector(7 downto 0) is neighbor_out(0)(89 downto 82);
  
  alias alias_kernel_10x3_1_0   : std_logic_vector(7 downto 0) is neighbor_out(1)(19 downto 12);
  alias alias_kernel_10x3_1_1   : std_logic_vector(7 downto 0) is neighbor_out(1)(29 downto 22);
  alias alias_kernel_10x3_1_2   : std_logic_vector(7 downto 0) is neighbor_out(1)(39 downto 32);
  alias alias_kernel_10x3_1_3   : std_logic_vector(7 downto 0) is neighbor_out(1)(49 downto 42);
  --alias alias_kernel_10x3_1_4   : std_logic_vector(7 downto 0) is neighbor_out(1)(59 downto 52);
  --alias alias_kernel_10x3_1_5   : std_logic_vector(7 downto 0) is neighbor_out(1)(69 downto 62);
  --alias alias_kernel_10x3_1_6   : std_logic_vector(7 downto 0) is neighbor_out(1)(79 downto 72);
  --alias alias_kernel_10x3_1_7   : std_logic_vector(7 downto 0) is neighbor_out(1)(89 downto 82);
  
  alias alias_kernel_10x3_2_0   : std_logic_vector(7 downto 0) is neighbor_out(2)(19 downto 12);
  alias alias_kernel_10x3_2_1   : std_logic_vector(7 downto 0) is neighbor_out(2)(29 downto 22);
  alias alias_kernel_10x3_2_2   : std_logic_vector(7 downto 0) is neighbor_out(2)(39 downto 32);
  alias alias_kernel_10x3_2_3   : std_logic_vector(7 downto 0) is neighbor_out(2)(49 downto 42);
  --alias alias_kernel_10x3_2_4   : std_logic_vector(7 downto 0) is neighbor_out(2)(59 downto 52);
  --alias alias_kernel_10x3_2_5   : std_logic_vector(7 downto 0) is neighbor_out(2)(69 downto 62);
  --alias alias_kernel_10x3_2_6   : std_logic_vector(7 downto 0) is neighbor_out(2)(79 downto 72);
  --alias alias_kernel_10x3_2_7   : std_logic_vector(7 downto 0) is neighbor_out(2)(89 downto 82);  

begin
  
  ---------------------------------------------------------------
  -- Process: rst_fifo_5cc 
  --
  -- Description: Reset fifos
  -- 
  ---------------------------------------------------------------
  process(pix_clk)
  begin
    if (pix_clk'event and pix_clk='1') then
      
      fifo_rst_P1 <= pix_reset;
      fifo_rst_P2 <= fifo_rst_P1;
      fifo_rst_P3 <= fifo_rst_P2;
      fifo_rst_P4 <= fifo_rst_P3;
      fifo_rst_P5 <= fifo_rst_P4;
      fifo_rst    <= fifo_rst_P5;
        
      REG_dpc_fifo_rst_P1_resync <= REG_dpc_fifo_rst;             --resync from regfile sysclk
      REG_dpc_fifo_rst_P2_resync <= REG_dpc_fifo_rst_P1_resync;

      REG_dpc_fifo_rst_P3 <= REG_dpc_fifo_rst_P2_resync; -- on allonge le reset a 5clk (minimum for artix fpga)
      REG_dpc_fifo_rst_P4 <= REG_dpc_fifo_rst_P3;
      REG_dpc_fifo_rst_P5 <= REG_dpc_fifo_rst_P4;
      REG_dpc_fifo_rst_P6 <= REG_dpc_fifo_rst_P5;
      REG_dpc_fifo_rst_P7 <= REG_dpc_fifo_rst_P6 or REG_dpc_fifo_rst_P5 or 
                             REG_dpc_fifo_rst_P4 or REG_dpc_fifo_rst_P3 or 
                             REG_dpc_fifo_rst_P2_resync;
                               
                               
      if(fifo_rst='1') then
        rst_fifo_5cc <= '1';
      elsif(REG_dpc_fifo_rst_P7='1' or REG_dpc_enable_DB='0') then
        rst_fifo_5cc <= '1';
      else
        rst_fifo_5cc <= '0';
      end if;
    end if;
  end process;


  ------------------------------------------------------------
  -- This counter is counting the first lines entering
  -- the module, to be able to identify the entering line.
  ------------------------------------------------------------
  process(pix_clk)
  begin
    if (pix_clk'event and pix_clk='1') then
      if (start_of_frame_in = '1'  or REG_dpc_enable_DB='0') then -- reset condition
        cntr_firsts_lines <= (others => '0');
      elsif ((cntr_firsts_lines /= "11") and end_of_line_in= '1')then
        cntr_firsts_lines <= cntr_firsts_lines + 1;
      end if;
    end if;
  end process;
  
  ----------------------------------------------------
  -- This signal first_line_done is useful to generate
  -- read enables to line buffers, cause we need to
  -- wait for the second line before starting to read
  -- to line buffers.
  ----------------------------------------------------
  process(pix_clk)
  begin
    if (pix_clk'event and pix_clk='1') then
      if (start_of_frame_in = '1'  or REG_dpc_enable_DB='0') then -- reset condition
        first_line_done  <= '0';
        second_line_done <= '0';
      else
        if(cntr_firsts_lines = "01") then
          first_line_done <= '1';
        else
          first_line_done <= first_line_done;
        end if;
        
        if(cntr_firsts_lines = "10") then
          second_line_done <= '1';
        else
          second_line_done <= second_line_done;
        end if;
      end if;
    end if;
  end process;

  

  ---------------------------------------------------
  -- ------------------------------------------------
  -- FIFO logic
  -- ------------------------------------------------
  ---------------------------------------------------
  
  ----------------------------------------------------------------------
  -- The signal lbuff_wren is the write enable used by all line buffers.
  --
  -- We always write to all buffers at the same time, the exception
  -- is concerning the data written. In fact, during first input
  -- line, we store the pixels in first line buffer. During all following 
  -- input lines, we also store new
  -- line in the first buffer and all other buffers are connected
  -- together following the formula:
  --
  -- din(i+1) = dout(i) 
  --
  ----------------------------------------------------------------------
  lbuff_wren_pro: process(pix_clk)
  begin
    if (pix_clk'event and pix_clk='1') then    
      if (REG_dpc_enable_DB='1' and pixel_in_en = '1') then
        lbuff_wren_first <= '1';
      else
        lbuff_wren_first <= '0';
      end if;
    end if;
    
    if (pix_clk'event and pix_clk='1') then    
      if (REG_dpc_enable_DB='1' and pixel_in_en = '1' and first_line_done = '1') then
        lbuff_wren_second <= '1';
      else
        lbuff_wren_second <= '0';
      end if;
    end if;
  end process;
  
  -----------------
  -- Line length: need this because the 2nd ROI will enter le linebuffer
  -- before all data is readed for the last line!
  -----------------
  process(pix_clk)
  begin
    if (pix_clk'event and pix_clk='1') then    
      if (pix_reset = '1'  or REG_dpc_enable_DB='0' or (start_of_line_in='1' and first_line_done = '1' and second_line_done = '0') ) then
        lbuff_line_length <= (others=>'0');
      elsif (pixel_in_en = '1' and first_line_done = '1' and second_line_done = '0') then -- count only in second line : the first line will erase the old value if 2 ROI are setted
        lbuff_line_length <= lbuff_line_length +'1';
      end if;
    end if;
  end process;
  

  ------------------------------------------------------------------------------------------
  -- 
  -- At EOF, we need to flush the fifo remaining line. But we also need to send the last 
  -- line entered without any correction! So we read to the 2 buffers !
  --
  -- The P480 sensor needs the dataval to be time delayed because the LUT has been optimized.
  -- So in the case of P480 we need to duty cycle 1:3 (1 Valid, 3 idle) access 
  -- 
  ------------------------------------------------------------------------------------------
  process(pix_clk)
  begin
    if (pix_clk'event and pix_clk='1') then
       
      eof_delaying_P1 <= eof_delaying;
      
      if (end_of_frame_in='1') then
        eof_delaying   <= '1';
        eof_cntr      <= (others =>'0');
      elsif(eof_delaying = '1') then
        if(eof_cntr="100000") then
          eof_delaying <= '0';
          eof_cntr    <= (others =>'0');
        else  
          eof_delaying <= '1';
          eof_cntr    <= eof_cntr +'1';
        end if;
      end if;
      
	  
	  -- The last line read need to be compatible with AXI waits, so do the same jobe here:
	  -- Read one data, then wait for axi master ack before continue
	  -- 
      if (eof_delaying_P1='1' and eof_delaying = '0') then 
        last_line_fifo_rd           <= '1';
        last_line_fifo_en           <= '1'; 
        last_line_fifo_rd_cntr      <= "0000000001";
        last_line_fifo_rd_started   <= '1';
        last_line_fifo_rd_prefetch  <= '1';

      elsif(last_line_fifo_rd_started='1' and last_line_fifo_rd='1' and last_line_fifo_rd_prefetch='1' and last_line_fifo_rd_cntr="00000000001") then -- end of prefetch 1 data      
        last_line_fifo_rd           <= '0';
        last_line_fifo_en           <= '0'; 
        last_line_fifo_rd_cntr      <= last_line_fifo_rd_cntr;		
        last_line_fifo_rd_started   <= '1';
        last_line_fifo_rd_prefetch  <= '0';

      elsif(last_line_fifo_rd_started='1' and last_line_fifo_rd_cntr=lbuff_line_length) then
        last_line_fifo_rd           <= '0';
        last_line_fifo_en           <= '0';        
        last_line_fifo_rd_cntr      <= "0000000001";
        last_line_fifo_rd_started   <= '0';		  
        last_line_fifo_rd_prefetch  <= '0';
              
      elsif(last_line_fifo_rd_started='1' and m_axis_ack='1' and last_line_fifo_rd_prefetch='0' ) then
        last_line_fifo_rd           <= '1';
        last_line_fifo_en           <= '1';          
        last_line_fifo_rd_cntr      <= last_line_fifo_rd_cntr+'1';			
        last_line_fifo_rd_started   <= '1';
        last_line_fifo_rd_prefetch  <= '0';

      elsif(last_line_fifo_rd_started='1' and m_axis_tready='1' and m_axis_tvalid='0' and last_line_fifo_rd_prefetch='0' and last_line_fifo_rd = '1') then -- Apres prefetch, avant burst
        last_line_fifo_rd           <= '1';
        last_line_fifo_en           <= '1';          
        last_line_fifo_rd_cntr      <= last_line_fifo_rd_cntr+'1';			
        last_line_fifo_rd_started   <= '1';
        last_line_fifo_rd_prefetch  <= '0';
        
      end if; 

      last_line_fifo_rd_started_P1 <= last_line_fifo_rd_started;

      
      last_line_fifo_rd_P1 <= last_line_fifo_rd;
      last_line_fifo_rd_P2 <= last_line_fifo_rd_P1;

      last_line_fifo_en_P1 <= last_line_fifo_en;
      last_line_fifo_en_P2 <= last_line_fifo_en_P1;
      
    end if;
  end process;


  ----------------------------------------------------------------------
  -- The signal lbuff_rden is the read enable used by all line buffers.
  --
  -- We always read all buffers after the first line is all received.
  ----------------------------------------------------------------------  
  lbuff_rden_1: process(REG_dpc_enable_DB, first_line_done, pixel_in_en)
  begin
    if (REG_dpc_enable_DB='1' and first_line_done = '1' and pixel_in_en = '1')  then
      lbuff_first_rden <= '1';
    else
      lbuff_first_rden <= '0';
    end if;
  end process;

  lbuff_rden_2: process(REG_dpc_enable_DB, second_line_done, pixel_in_en)
  begin
    if (REG_dpc_enable_DB='1' and second_line_done = '1' and pixel_in_en = '1')  then
      lbuff_second_rden <= '1';
    else
      lbuff_second_rden <= '0';
    end if;
  end process;
  
  -------------------------------------------
  -- Pipeline on pixel_in
  -------------------------------------------
  process(pix_clk)
  begin
    if (pix_clk'event and pix_clk='1') then
      if(REG_dpc_enable_DB='1') then
        if(pixel_in_en='1') then 
          pixel_in_P1 <= pixel_in;
        end if;
      end if;
    end if;
  end process;
  
  -------------------------------------------------------
  --
  -- LINE BUFFERS
  --
  -------------------------------------------------------
  lbuff_first_rden_OS  <= lbuff_first_rden  or last_line_fifo_rd;

  
--  DCP_LINE_BUFFER_40BITS_GEN : if (BUS_Data_Width = 60)  generate
--  
--    lbuff_first: xil_nopel_fifo32
--    port map(
--      clk          => pix_clk,
--      srst         => rst_fifo_5cc,
--                   
--      full         => lbuff_first_full,
--      wr_en        => lbuff_wren_first,
--      din          => pixel_in_P1,
--      overflow     => lbuff_first_overflow,
--                   
--      empty        => lbuff_first_empty,
--      rd_en        => lbuff_first_rden_OS,
--      dout         => dout_first,
--      underflow    => lbuff_first_underflow
--    );
--    
--    lbuff_second_rden_OS <= lbuff_second_rden or last_line_fifo_rd;
--    
--    lbuff_second: xil_nopel_fifo32
--    port map(
--      clk          => pix_clk,
--      srst         => rst_fifo_5cc,
--                   
--      full         => lbuff_second_full,
--      wr_en        => lbuff_wren_second, 
--      din          => dout_first,
--      overflow     => lbuff_second_overflow,
--                   
--      empty        => lbuff_second_empty,
--      rd_en        => lbuff_second_rden_OS,
--      dout         => dout_second,
--      underflow    => lbuff_second_underflow
--    );     
--
--    end generate;
  
  
  
  DCP_LINE_BUFFER_80BITS_GEN : if (BUS_Data_Width = 100)  generate
  
    --lbuff_first: xil_nopel_fifo64
    --port map(
    --  clk          => pix_clk,
    --  srst         => rst_fifo_5cc,
    --               
    --  full         => lbuff_first_full,
    --  wr_en        => lbuff_wren_first,
    --  din          => pixel_in_P1,
    --  overflow     => lbuff_first_overflow,
    --               
    --  empty        => lbuff_first_empty,
    --  rd_en        => lbuff_first_rden_OS,
    --  dout         => dout_first,
    --  underflow    => lbuff_first_underflow
    --);
    
	 lbuff_first: xpm_fifo_sync
     generic map (
      DOUT_RESET_VALUE    => "0",       -- String
      ECC_MODE            => "no_ecc",  -- String
      FIFO_MEMORY_TYPE    => "auto",    -- String
      FIFO_READ_LATENCY   => 1,         -- DECIMAL ****
      FIFO_WRITE_DEPTH    => 1024,      -- DECIMAL ****  1024x8 => 8k pixel max
      FULL_RESET_VALUE    => 0,         -- DECIMAL
      PROG_EMPTY_THRESH   => 10,        -- DECIMAL
      PROG_FULL_THRESH    => 10,        -- DECIMAL
      RD_DATA_COUNT_WIDTH => 1,         -- DECIMAL
      READ_DATA_WIDTH     => 100,       -- DECIMAL ****
      READ_MODE           => "std",     -- String
      USE_ADV_FEATURES    => "0707",    -- String
      WAKEUP_TIME         => 0,         -- DECIMAL
      WRITE_DATA_WIDTH    => 100,       -- DECIMAL ****
      WR_DATA_COUNT_WIDTH => 1          -- DECIMAL
    )
    port map (
      data_valid    => open,                  -- 1-bit output: Read Data Valid: When asserted, this signal indicates that valid data is available on the output bus (dout).
      dout          => dout_first,            -- READ_DATA_WIDTH-bit output: Read Data: The output data bus is driven when reading the FIFO.
      empty         => lbuff_first_empty,     -- 1-bit output: Empty Flag: When asserted, this signal indicates that
                                              -- the FIFO is empty. Read requests are ignored when the FIFO is empty,
                                              -- initiating a read while empty is not destructive to the FIFO.
      full          => lbuff_first_full,                    
      overflow      => lbuff_first_overflow,
      underflow     => lbuff_first_underflow, -- 1-bit output: Underflow: Indicates that the read request (rd_en)
                                              -- during the previous clock cycle was rejected because the FIFO is
                                              -- empty. Under flowing the FIFO is not destructive to the FIFO.

      injectdbiterr => '0',                   -- 1-bit input: Double Bit Error Injection: Injects a double bit error if the ECC feature is used on block RAMs or UltraRAM macros.								      
      injectsbiterr => '0',                   -- 1-bit input: Single Bit Error Injection: Injects a single bit error if the ECC feature is used on block RAMs or UltraRAM macros.									     									     
      sleep         => '0',                   -- 1-bit input: Dynamic power saving- If sleep is High, the memory/fifo
                                              -- block is in power saving mode.

      din           => pixel_in_P1,           -- WRITE_DATA_WIDTH-bit input: Write Data: The input data bus used when writing the FIFO.
      rd_en         => lbuff_first_rden_OS,   -- 1-bit input: Read Enable: If the FIFO is not empty, asserting this
                                              -- signal causes data (on dout) to be read from the FIFO. Must be held
                                              -- active-low when rd_rst_busy is active high.
      rst           => rst_fifo_5cc,          -- 1-bit input: Reset: Must be synchronous to wr_clk. The clock(s) can be
                                              -- unstable at the time of applying reset, but reset must be released
                                              -- only after the clock(s) is/are stable.
      wr_clk        => pix_clk,               -- 1-bit input: Write clock: Used for write operation. wr_clk must be a free running clock.
      wr_en         => lbuff_wren_first       -- 1-bit input: Write Enable: If the FIFO is not full, asserting this signal causes data (on din) to be written to the FIFO Must be held
                                              -- active-low when rst or wr_rst_busy or rd_rst_busy is active high
    );  

	
    lbuff_second_rden_OS <= lbuff_second_rden or last_line_fifo_rd;
    
    --lbuff_second: xil_nopel_fifo64
    --port map(
    --  clk          => pix_clk,
    --  srst         => rst_fifo_5cc,
    --               
    --  full         => lbuff_second_full,
    --  wr_en        => lbuff_wren_second, 
    --  din          => dout_first,
    --  overflow     => lbuff_second_overflow,
    --               
    --  empty        => lbuff_second_empty,
    --  rd_en        => lbuff_second_rden_OS,
    --  dout         => dout_second,
    --  underflow    => lbuff_second_underflow
    --);     

    lbuff_second : xpm_fifo_sync
    generic map (
      DOUT_RESET_VALUE    => "0",       -- String
      ECC_MODE            => "no_ecc",  -- String
      FIFO_MEMORY_TYPE    => "auto",    -- String
      FIFO_READ_LATENCY   => 1,         -- DECIMAL ****
      FIFO_WRITE_DEPTH    => 1024,      -- DECIMAL ****  1024x8 =>8k pixel max
      FULL_RESET_VALUE    => 0,         -- DECIMAL
      PROG_EMPTY_THRESH   => 10,        -- DECIMAL
      PROG_FULL_THRESH    => 10,        -- DECIMAL
      RD_DATA_COUNT_WIDTH => 1,         -- DECIMAL
      READ_DATA_WIDTH     => 100,       -- DECIMAL ****
      READ_MODE           => "std",     -- String
      USE_ADV_FEATURES    => "0707",    -- String
      WAKEUP_TIME         => 0,         -- DECIMAL
      WRITE_DATA_WIDTH    => 100,       -- DECIMAL ****
      WR_DATA_COUNT_WIDTH => 1          -- DECIMAL
    )
    port map (
      data_valid    => open,                  -- 1-bit output: Read Data Valid: When asserted, this signal indicates that valid data is available on the output bus (dout).
      dout          => dout_second,           -- READ_DATA_WIDTH-bit output: Read Data: The output data bus is driven when reading the FIFO.
      empty         => lbuff_second_empty,    -- 1-bit output: Empty Flag: When asserted, this signal indicates that
                                              -- the FIFO is empty. Read requests are ignored when the FIFO is empty,
                                              -- initiating a read while empty is not destructive to the FIFO.
      full          => lbuff_second_full,                    
      overflow      => lbuff_second_overflow,
      underflow     => lbuff_second_underflow,-- 1-bit output: Underflow: Indicates that the read request (rd_en)
                                              -- during the previous clock cycle was rejected because the FIFO is
                                              -- empty. Under flowing the FIFO is not destructive to the FIFO.
											  
      injectdbiterr => '0',                   -- 1-bit input: Double Bit Error Injection: Injects a double bit error if the ECC feature is used on block RAMs or UltraRAM macros.								      
      injectsbiterr => '0',                   -- 1-bit input: Single Bit Error Injection: Injects a single bit error if the ECC feature is used on block RAMs or UltraRAM macros.									     									     
      sleep         => '0',                   -- 1-bit input: Dynamic power saving- If sleep is High, the memory/fifo
                                              -- block is in power saving mode.

      din           => dout_first,            -- WRITE_DATA_WIDTH-bit input: Write Data: The input data bus used when writing the FIFO.
      rd_en         => lbuff_second_rden_OS,  -- 1-bit input: Read Enable: If the FIFO is not empty, asserting this
                                              -- signal causes data (on dout) to be read from the FIFO. Must be held
                                              -- active-low when rd_rst_busy is active high.
      rst           => rst_fifo_5cc,          -- 1-bit input: Reset: Must be synchronous to wr_clk. The clock(s) can be
                                              -- unstable at the time of applying reset, but reset must be released
                                              -- only after the clock(s) is/are stable.
      wr_clk        => pix_clk,               -- 1-bit input: Write clock: Used for write operation. wr_clk must be a free running clock.
      wr_en         => lbuff_wren_second      -- 1-bit input: Write Enable: If the FIFO is not full, asserting this signal causes data (on din) to be written to the FIFO Must be held
                                              -- active-low when rst or wr_rst_busy or rd_rst_busy is active high
    );  



    end generate;
  
  
 
 
 
 

 

  

  
  
  
  
  -----------------------
  -- 3x3 Kernel output
  -----------------------
  neighbor_out(0)(pixel_in'range) <= dout_second;     -- LINE n 
  neighbor_out(1)(pixel_in'range) <= dout_first;      -- LINE n+1 or last line
  neighbor_out(2)(pixel_in'range) <= pixel_in_P1;     -- LINE n+2
  
  -------------------------------------------
  -- Generation des nouveaux signaux de sync
  -------------------------------------------
  process(pix_clk)
  begin
    if (pix_clk'event and pix_clk='1') then
    
      start_of_frame_in_P1 <= start_of_frame_in;
      
      if(REG_dpc_enable_DB='1' and start_of_frame_in_P1='1') then 
        first_line <= '1';
      elsif(start_of_line_in='1' and second_line_done='1') then
        first_line <= '0';
      end if;
      
      if(REG_dpc_enable_DB='1' and eof_delaying='0' and eof_delaying_P1='1') then
        last_line <= '1'; 
      elsif(start_of_frame_in='1') then   
        last_line <= '0';
      end if;
      
      last_line_P1 <= last_line;
       
      
      if(REG_dpc_enable_DB='1') then
        sol_P1      <= (start_of_line_in and first_line_done) or ( not(eof_delaying) and eof_delaying_P1);
        --enable_P1   <= (pixel_in_en      and first_line_done) or  last_line_fifo_rd ;
        enable_P1   <= (pixel_in_en      and first_line_done) or  last_line_fifo_en ;
        

        if( (end_of_line_in='1'   and first_line_done='1') or (last_line_fifo_rd_started='0' and last_line_fifo_rd_started_P1='1') )then
		  eol_P1      <= '1';
        else
		  eol_P1      <= '0';
		end if;
		
        eof_os      <= eol_P1 and last_line_fifo_en_P1;
        --eof_os      <= not(last_line_fifo_en_P1) and last_line_fifo_en_P2;
   
        
        -- Identification du premier pixel (premier kernel)
        if(sol_P1='1' and first_line='0' and last_line='0') then
          first_col_out_int <= '1';
        elsif(enable_P1='1') then
          first_col_out_int <= '0';
        end if;
        
      end if;
    end if;
  end process;

  -----------------------
  -- Output sync signals
  -----------------------
  first_line_out        <= first_line;   
  last_line_out         <= last_line;   

  first_col_out         <= first_col_out_int; 
  last_col_out          <= (not(first_line) and not(last_line_P1)) and ( (end_of_line_in and first_line_done) or ( not(last_line_fifo_en) and last_line_fifo_en_P1) );
                           
  start_of_frame_out    <= start_of_line_in when (first_line_done='1' and second_line_done='0') else '0';   --ici je retarde le SOF d'une ligne
  start_of_line_out     <= sol_P1;
  neighbor_en           <= enable_P1;
  end_of_line_out       <= eol_P1;
  end_of_frame_out      <= eof_os;




  
  -- coverage off
  assert not((lbuff_first_overflow='1' or lbuff_second_overflow='1' or lbuff_first_underflow='1' or lbuff_second_underflow='1') and rst_fifo_5cc = '0') report "dpc_kernel10x3.vhd: There is an overflow or underflow in a fifo!"
  severity ERROR;    
  -- coverage on

  --Overrun detection
  process(pix_clk)
    begin
      if (pix_clk'event and pix_clk='1') then
        if (pix_reset = '1' or rst_fifo_5cc='1') then -- reset condition
          REG_dpc_fifo_ovr <= '0';
        elsif(lbuff_first_overflow='1' or lbuff_second_overflow='1') then
          REG_dpc_fifo_ovr <= '1';
        end if;
      end if;
  end process;

  --Underrun detection
  process(pix_clk)
    begin
      if (pix_clk'event and pix_clk='1') then
        if (pix_reset = '1' or rst_fifo_5cc='1') then -- reset condition
          REG_dpc_fifo_und <= '0';
        elsif(lbuff_first_underflow='1' or lbuff_second_underflow='1') then
          REG_dpc_fifo_und <= '1';
        end if;
      end if;
  end process;



end functional;  
   
