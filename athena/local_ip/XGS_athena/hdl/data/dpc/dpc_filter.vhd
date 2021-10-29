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
-- DPC_CORR_PIXELS_DEPTH=6  =>   63 pixels, 6+1+4:  11 RAM36K 
-- DPC_CORR_PIXELS_DEPTH=7  =>  127 pixels, 6+1+4:  11 RAM36K 
-- DPC_CORR_PIXELS_DEPTH=8  =>  255 pixels, 6+1+4:  11 RAM36K 
-- DPC_CORR_PIXELS_DEPTH=9  =>  511 pixels, 6+1+4:  11 RAM36K   *default au 28 septembre
-- DPC_CORR_PIXELS_DEPTH=10 => 1023 pixels, 6+1+8:  15 RAM36K 
-- DPC_CORR_PIXELS_DEPTH=11 => 2047 pixels, 6+2+16: 24 RAM36K 
-- DPC_CORR_PIXELS_DEPTH=12 => 4095 pixels, 6+4+32: 42 RAM36K   
--
-----------------------------------------------------------------------
library ieee;
 use ieee.std_logic_1164.all;
 use IEEE.std_logic_unsigned.all;
 use IEEE.numeric_std.all;
 use IEEE.std_logic_arith.all;
 use std.textio.all ; 
 
library work;
 use work.dpc_package.all;

entity dpc_filter is
   generic( DPC_CORR_PIXELS_DEPTH         : integer := 6;    --6=>64,  7=>128, 8=>256, 9=>512, 10=>1024
            DPC_COLOR                     : integer := 0
		  );
   port(
    ---------------------------------------------------------------------
    -- Axi domain reset and clock signals
    ---------------------------------------------------------------------
    axi_clk                              : in    std_logic;
    axi_reset_n                          : in    std_logic;

    ---------------------------------------------------------------------
    -- Sys domain reset and clock signals : on axi_clk
    ---------------------------------------------------------------------   
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
	
	REG_color                            : in    std_logic :='0';    -- to bypass in color modes

    REG_dpc_enable                       : in    std_logic :='1';

    REG_dpc_pattern0_cfg                 : in    std_logic :='0';
    REG_dpc_highlight_all                : in    std_logic:='0';
    
    REG_dpc_fifo_rst                     : in    std_logic :='0';
    REG_dpc_fifo_ovr                     : out   std_logic;
    REG_dpc_fifo_und                     : out   std_logic;
    
    REG_dpc_list_wrn                     : in    std_logic; 
    REG_dpc_list_add                     : in    std_logic_vector(DPC_CORR_PIXELS_DEPTH-1 downto 0); 
    REG_dpc_list_ss                      : in    std_logic;
    REG_dpc_list_count                   : in    std_logic_vector(DPC_CORR_PIXELS_DEPTH-1 downto 0);

    REG_dpc_list_corr_pattern            : in    std_logic_vector(7 downto 0);
    REG_dpc_list_corr_y                  : in    std_logic_vector(11 downto 0);
    REG_dpc_list_corr_x                  : in    std_logic_vector(12 downto 0);
    
    REG_dpc_list_corr_rd                 : out   std_logic_vector(32 downto 0);   
       
    REG_dpc_firstlast_line_rem           : in    std_logic:='0';
    
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
	
	
	
  );
  
end dpc_filter;


architecture functional of dpc_filter is


  procedure Print(s : string) is 
  variable buf : line ; 
  begin
    write(buf, s) ; 
    WriteLine(OUTPUT, buf) ; 
  end procedure Print ; 
 

  component dpc_kernel_10x3
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
    REG_dpc_fifo_rst                     : in    std_logic;
    REG_dpc_fifo_ovr                     : out   std_logic;
    REG_dpc_fifo_und                     : out   std_logic;
        
    ---------------------------------------------------------------------
    -- Data and control in
    ---------------------------------------------------------------------
    start_of_frame_in                    : in    std_logic;
    start_of_line_in                     : in    std_logic;
    end_of_line_in                       : in    std_logic;
    pixel_in_en                          : in    std_logic;
    pixel_in                             : in    std_logic_vector;
    end_of_frame_in                      : in    std_logic;

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

  end component;

  
  component dpc_kernel_proc is
  generic( DPC_CORR_PIXELS_DEPTH         : integer := 6    --6=>64,  7=>128, 8=>256, 9=>512, 10=>1024    
  );
  port(
    ---------------------------------------------------------------------
    -- Pixel domain reset and clock signals
    ---------------------------------------------------------------------
    pix_clk                              : in    std_logic;
    pix_reset                            : in    std_logic;
    ---------------------------------------------------------------------
    -- Data IN
    ---------------------------------------------------------------------
    proc_eol                             : in    std_logic; 
    proc_enable                          : in    std_logic;
    proc_first_col                       : in    std_logic;
    proc_last_col                        : in    std_logic;
    proc_first_line                      : in    std_logic;  
    proc_last_line                       : in    std_logic;
    
    REG_dpc_pattern0_cfg                 : in    std_logic;
    REG_dpc_highlight_all                : in    std_logic:='0';
    
    proc_X_pix_curr                      : in    std_logic_vector(12 downto 0);
    proc_Y_pix_curr                      : in    std_logic_vector(11 downto 0);
    
    dpc_fifo_reset                       : in    std_logic;
    dpc_fifo_data_in                     : in    std_logic_vector(32 downto 0);
    dpc_fifo_write_in                    : in    std_logic;    
    dpc_fifo_list_rdy                    : in    std_logic; --write logic has finish write to fifo, we can start prefetch
	dpc_fifo_reset_done                  : out   std_logic;

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
    
    in_8                                 : in    std_logic_vector;
    -------------------------------------------------
    -- Data OUT
    -------------------------------------------------

    Curr_out                             : out   std_logic_vector
    
    
    
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
  
  
  
  constant nb_pixels  : integer := ((s_axis_tdata'high+1)/10)-1;      -- 0 base!   3=>4 pixels(32/40 bus)   7=>8 pixels(64/80 bus)
   
  signal axi_reset             : std_logic;

  signal s_axis_tready_int     : std_logic :='0';
  signal s_axis_first_line     : std_logic :='0';
  signal s_axis_first_prefetch : std_logic :='0';
  signal s_axis_line_gap       : std_logic :='0';
  signal s_axis_line_wait      : std_logic :='0';  
  signal s_axis_frame_done     : std_logic :='1';  
  
  signal curr_Xstart_corr      : std_logic_vector(12 downto 0):=(others=>'0');
  signal curr_Xend_corr        : std_logic_vector(12 downto 0):=(others=>'1');
  
  signal curr_Xstart_integer   : integer range 0 to 8191;
  signal curr_Xend_integer     : integer range 0 to 8191;
  
  signal BAYER_Sensor          : std_logic;
  
  signal REG_dpc_enable_P1     : std_logic :='0';
  signal REG_dpc_enable_DB     : std_logic :='0';

  signal dpc_sol_P1            : std_logic:='0';
 
  signal dpc_data_enable_start : std_logic:='0';
  signal dpc_data_enable_stop  : std_logic:='0';
  signal dpc_data_enable_P1    : std_logic:='0';

  signal dpc_data_bypass       : std_logic_vector(s_axis_tdata'range);
  
  signal dpc_data_in_100_P1    : std_logic_vector(89 downto 10):=(others=>'0');
  signal dpc_data_in_100_P2    : std_logic_vector(99 downto 0) :=(others=>'0');
  

  signal dpc_eol_P1            : std_logic:='0';
  signal dpc_eol_P2            : std_logic:='0';
  signal dpc_eol_P3            : std_logic:='0';

  signal dpc_eof_P1            : std_logic:='0';
  signal dpc_eof_P2            : std_logic:='0';
  signal dpc_eof_P3            : std_logic:='0';
  signal dpc_eof_P4            : std_logic:='0';
  
  signal dpc_kernel_10x3_sof   : std_logic:= '0';
  signal dpc_kernel_10x3_sol   : std_logic:= '0';
  signal dpc_kernel_10x3_eol   : std_logic:= '0';
  signal dpc_kernel_10x3_eof   : std_logic:= '0';
  
  
  
  signal kernel_10x3_sof         : std_logic:='0';
  signal kernel_10x3_sol         : std_logic:='0';
  signal kernel_10x3_eol         : std_logic:='0';
  signal kernel_10x3_en          : std_logic:='0';
  signal kernel_10x3_out         : std100_logic_vector(2 downto 0);
  signal kernel_10x3_eof         : std_logic:='0';
  
  type curr_pixel_type is record
    X_pos : std_logic_vector(12 downto 0);  --kernel
    Y_pos : std_logic_vector(11 downto 0);  --line
  end record curr_pixel_type;
  
  signal kernel_10x3_curr        : curr_pixel_type;

  signal proc_X_pix_curr         : std13_logic_vector(nb_pixels downto 0); 
  
  signal proc_first_col          : std_logic_vector(nb_pixels downto 0); 
  signal proc_last_col           : std_logic_vector(nb_pixels downto 0);   
 
  signal kernel_10x3_sof_P1      : std_logic:='0';
  signal kernel_10x3_sol_P1      : std_logic:='0';
  signal kernel_10x3_en_P1       : std_logic:='0';
  signal kernel_10x3_eol_P1      : std_logic:='0';
  signal kernel_10x3_eof_P1      : std_logic:='0';
  
  signal kernel_10x3_sol_P2      : std_logic:='0';
  signal kernel_10x3_en_P2       : std_logic:='0';
  signal kernel_10x3_eol_P2      : std_logic:='0';
  signal kernel_10x3_eof_P2      : std_logic:='0';
  
  signal kernel_10x3_sol_P3      : std_logic:='0';
  signal kernel_10x3_en_P3       : std_logic:='0';
  signal kernel_10x3_eol_P3      : std_logic:='0';
  signal kernel_10x3_eof_P3      : std_logic:='0';
  
  signal kernel_10x3_sol_P4      : std_logic:='0';
  signal kernel_10x3_en_P4       : std_logic:='0';
  signal kernel_10x3_eol_P4      : std_logic:='0';
  signal kernel_10x3_eof_P4      : std_logic:='0';

  signal proc_sol                : std_logic:='0';
  signal proc_en                 : std_logic:='0';
  signal proc_data               : std10_logic_vector(nb_pixels downto 0);
  signal proc_eol                : std_logic:='0';
  signal proc_eof                : std_logic:='0';
     
  signal kernel_10x3_first_line  : std_logic:='0';
  signal kernel_10x3_last_line   : std_logic:='0';

  signal kernel_10x3_first_col   : std_logic:='0';
  signal kernel_10x3_last_col    : std_logic:='0';
  
  signal Pix_corr                : std10_logic_vector(nb_pixels downto 0);
  --signal Pix_corr64              : std_logic_vector(63 downto 0);
  signal Pix_corr_sof            : std_logic:='0';
  signal Pix_corr_sol            : std_logic:='0';
  signal Pix_corr_en             : std_logic:='0';
  signal Pix_corr_eol            : std_logic:='0';
  signal Pix_corr_eof            : std_logic:='0';

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

  signal m_axis_tvalid_int        : std_logic :='0';
  signal m_axis_tdata_int         : std_logic_vector(79 downto 0);
  signal m_axis_tuser_int         : std_logic_vector(3 downto 0);
  signal m_axis_wait_data         : std_logic_vector(79 downto 0);
  signal m_axis_wait              : std_logic :='0';
  
  --------------------------
  -- ALIAS FOR SIMULATION
  --------------------------
  
  alias alias_fpnprnu_corr_data_0   : std_logic_vector(7 downto 0) is s_axis_tdata( 9 downto  2);
  alias alias_fpnprnu_corr_data_1   : std_logic_vector(7 downto 0) is s_axis_tdata(19 downto 12);
  alias alias_fpnprnu_corr_data_2   : std_logic_vector(7 downto 0) is s_axis_tdata(29 downto 22);
  alias alias_fpnprnu_corr_data_3   : std_logic_vector(7 downto 0) is s_axis_tdata(39 downto 32);
  alias alias_fpnprnu_corr_data_4   : std_logic_vector(7 downto 0) is s_axis_tdata(49 downto 42);
  alias alias_fpnprnu_corr_data_5   : std_logic_vector(7 downto 0) is s_axis_tdata(59 downto 52);
  alias alias_fpnprnu_corr_data_6   : std_logic_vector(7 downto 0) is s_axis_tdata(69 downto 62);
  alias alias_fpnprnu_corr_data_7   : std_logic_vector(7 downto 0) is s_axis_tdata(79 downto 72);
 
 
  alias alias_dpc_data_in_100_0_P1 : std_logic_vector(7 downto 0) is dpc_data_in_100_P1(19 downto 12);
  alias alias_dpc_data_in_100_1_P1 : std_logic_vector(7 downto 0) is dpc_data_in_100_P1(29 downto 22);
  alias alias_dpc_data_in_100_2_P1 : std_logic_vector(7 downto 0) is dpc_data_in_100_P1(39 downto 32);
  alias alias_dpc_data_in_100_3_P1 : std_logic_vector(7 downto 0) is dpc_data_in_100_P1(49 downto 42);
  --alias alias_dpc_data_in_100_4_P1 : std_logic_vector(7 downto 0) is dpc_data_in_100_P1(59 downto 52);
  --alias alias_dpc_data_in_100_5_P1 : std_logic_vector(7 downto 0) is dpc_data_in_100_P1(69 downto 62);
  --alias alias_dpc_data_in_100_6_P1 : std_logic_vector(7 downto 0) is dpc_data_in_100_P1(79 downto 72);
  --alias alias_dpc_data_in_100_7_P1 : std_logic_vector(7 downto 0) is dpc_data_in_100_P1(89 downto 82);
  
  alias alias_dpc_data_in_100_L_P2: std_logic_vector(7 downto 0) is dpc_data_in_100_P2(9 downto 2);  
  alias alias_dpc_data_in_100_0_P2: std_logic_vector(7 downto 0) is dpc_data_in_100_P2(19 downto 12);
  alias alias_dpc_data_in_100_1_P2: std_logic_vector(7 downto 0) is dpc_data_in_100_P2(29 downto 22);
  alias alias_dpc_data_in_100_2_P2: std_logic_vector(7 downto 0) is dpc_data_in_100_P2(39 downto 32);
  alias alias_dpc_data_in_100_3_P2: std_logic_vector(7 downto 0) is dpc_data_in_100_P2(49 downto 42);
  alias alias_dpc_data_in_100_4_P2: std_logic_vector(7 downto 0) is dpc_data_in_100_P2(59 downto 52);
  --alias alias_dpc_data_in_100_5_P2: std_logic_vector(7 downto 0) is dpc_data_in_100_P2(69 downto 62);
  --alias alias_dpc_data_in_100_6_P2: std_logic_vector(7 downto 0) is dpc_data_in_100_P2(79 downto 72);
  --alias alias_dpc_data_in_100_7_P2: std_logic_vector(7 downto 0) is dpc_data_in_100_P2(89 downto 82);
  --alias alias_dpc_data_in_100_H_P2: std_logic_vector(7 downto 0) is dpc_data_in_100_P2(99 downto 92);
        
  alias alias_proc_data_0               : std_logic_vector(7 downto 0) is proc_data(0)(9 downto 2);
  alias alias_proc_data_1               : std_logic_vector(7 downto 0) is proc_data(1)(9 downto 2);
  alias alias_proc_data_2               : std_logic_vector(7 downto 0) is proc_data(2)(9 downto 2);
  alias alias_proc_data_3               : std_logic_vector(7 downto 0) is proc_data(3)(9 downto 2);
  --alias alias_proc_data_4               : std_logic_vector(7 downto 0) is proc_data(4)(9 downto 2);
  --alias alias_proc_data_5               : std_logic_vector(7 downto 0) is proc_data(5)(9 downto 2);
  --alias alias_proc_data_6               : std_logic_vector(7 downto 0) is proc_data(6)(9 downto 2);
  --alias alias_proc_data_7               : std_logic_vector(7 downto 0) is proc_data(7)(9 downto 2);
  

begin
  
  
  -------------------------------
  -- DPC configuration register
  -------------------------------   
  REG_dpc_ver           <= "0000"; -- v0 : Initial monochrone correction only, 2 lines buffered.
  REG_dpc_list_length   <= conv_std_logic_vector(conv_integer(2**DPC_CORR_PIXELS_DEPTH)-1 , 12);
  
  -- Invert reset
  axi_reset  <= not(axi_reset_n);
  
  ---------------------------------------------------------------
  -- GTX : Correct X_start and X_end
  --
  -- Xstart and Xend are X positions related to HISPI decoding, since we 
  -- always work with full line (with interpolations) 
  -- X_start = 0
  -- X_end   = HiSPI_Xend - HiSPI_Xstart
  --
  ---------------------------------------------------------------
  curr_Xstart_corr <=  (others=>'0'); -- Xstart is always 0, since we always grab from interpolation pixel 0
  
  process(axi_clk)   
  begin
    if (axi_clk'event and axi_clk='1') then
      if(REG_dpc_enable='1' and REG_dpc_enable_P1='0') then -- this register is static, so load just one time after DPC pixels are programmed
        curr_Xend_corr   <= curr_Xend-curr_Xstart;
	  end if; 
    end if;
  end process;

  
  -------------------------------------------------
  --
  -- AXI SLAVE
  --
  -------------------------------------------------	
  process(axi_clk)   
  begin
    if (axi_clk'event and axi_clk='1') then
      --First line goes directly to the first fifo
      if(s_axis_tvalid='1' and s_axis_tuser(0)='1' ) then --give rdy for one complete line at SOG : no wait sinc we enter this line to the first fifo
	    s_axis_tready_int     <= '1';		
	    s_axis_first_line     <= '1'; 
		s_axis_first_prefetch <= '0'; 		
		s_axis_line_gap       <= '0';
        s_axis_line_wait      <= '0'; 
        s_axis_frame_done     <= '0'; 
	  elsif(s_axis_tvalid='1' and s_axis_tready_int='1' and s_axis_tuser(3)='1') then -- at eol stop first line prefecht
	    s_axis_tready_int     <= '0';		
	    s_axis_first_line     <= '0'; 	  
		s_axis_first_prefetch <= '0'; 
		s_axis_line_gap       <= '1';
        s_axis_line_wait      <= '0'; 
        s_axis_frame_done      <= '1'; 
      
      elsif(s_axis_line_gap='1') then  --put a second wait at EOL, to let DPC absorb the stream(video syncs)
	    s_axis_tready_int     <= '0';		
	    s_axis_first_line     <= '0'; 	  
		s_axis_first_prefetch <= '0'; 
		s_axis_line_gap       <= '0';              
        s_axis_line_wait      <= '0'; 
        s_axis_frame_done      <= '0'; 
      
      elsif(s_axis_tvalid='1' and s_axis_tuser(2)='1' ) then --give one rdy at SOL detection, then wait for master interface
	    s_axis_tready_int     <= '1';		
	    s_axis_first_line     <= '0'; 
		s_axis_first_prefetch <= '1';
		s_axis_line_gap       <= '0';
        s_axis_line_wait      <= '0'; 
        s_axis_frame_done      <= '0'; 

      elsif(s_axis_first_prefetch='1' and s_axis_tvalid='1' ) then -- remove rdy and then listen to master interface to be ready
	    s_axis_tready_int     <= '0';		
	    s_axis_first_line     <= '0'; 
		s_axis_first_prefetch <= '0';  	  
		s_axis_line_gap       <= '0';
        s_axis_line_wait      <= '1'; 	 
        s_axis_frame_done      <= '0'; 

      elsif(s_axis_first_prefetch='1' and m_axis_tvalid_int='1' and  m_axis_tuser_int(2)='1') then  -- wait for master present SOL on master to give slave ready to burst   
	    s_axis_tready_int     <= '1';		
	    s_axis_first_line     <= '0'; 
	 	s_axis_first_prefetch <= '0';  	  
		s_axis_line_gap       <= '0';      
        s_axis_line_wait      <= '0'; 
        s_axis_frame_done      <= '0'; 
       
      elsif(s_axis_tvalid='1' and s_axis_tready_int='1' and s_axis_tuser(1)='1') then --@EOF put ready to 0 till next line/frame
	    s_axis_tready_int     <= '0';		
	    s_axis_first_line     <= '0'; 
	 	s_axis_first_prefetch <= '0';  	  
		s_axis_line_gap       <= '0';      
        s_axis_line_wait      <= '0'; 
        s_axis_frame_done     <= '1'; 
      
	  elsif( (s_axis_line_wait='0' and s_axis_frame_done='0' and m_axis_tready='1' and m_axis_tvalid_int='1') or s_axis_first_line='1') then --enter data to DCP pipeline till output
	    s_axis_tready_int     <= '1';	
        s_axis_first_line     <= s_axis_first_line;	
		s_axis_first_prefetch <= '0';
		s_axis_line_gap       <= '0';
        s_axis_line_wait      <= '0'; 
        s_axis_frame_done     <= '0'; 

	  elsif (m_axis_tready='0' and m_axis_tvalid_int='1') then -- si wait sur master, then wait the slave!
	    s_axis_tready_int     <= '0';	
        s_axis_first_line     <= s_axis_first_line;	
		s_axis_first_prefetch <= '0';
		s_axis_line_gap       <= '0';        
        s_axis_line_wait      <= '0'; 
        s_axis_frame_done     <= s_axis_frame_done; 
        
	  end if;	
    end if;
  end process;

  s_axis_tready     <= s_axis_tready_int;

   
  ------------------------------
  -- Store Dead pixels in a RAM
  --
  -- SW will fill this ram with the 
  -- pixels to be corrected 50 max !
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
 
  process(axi_clk)  -- On resete le fifo a chaque SOF pour etre sur qu'il reste pas de data , ALLONGE le RESeT A 5CLK
  begin
    if (axi_clk'event and axi_clk='1') then
      dpc_fifo_reset_P1  <= s_axis_tvalid and s_axis_tready_int and s_axis_tuser(0); --compte-tenu qu'on buff 2 lignes, on a le temps en masse!
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

        if (conv_integer(RAM_R_data(12 downto  0)) = curr_Xstart_integer and conv_integer(RAM_R_data(24 downto 13)) = conv_integer(curr_Ystart(11 downto 0)) ) or
           (conv_integer(RAM_R_data(12 downto  0)) = curr_Xend_integer   and conv_integer(RAM_R_data(24 downto 13)) = conv_integer(curr_Ystart(11 downto 0)) ) or 
           (conv_integer(RAM_R_data(12 downto  0)) = curr_Xstart_integer and conv_integer(RAM_R_data(24 downto 13)) = conv_integer(curr_Yend(11 downto 0)) ) or
           (conv_integer(RAM_R_data(12 downto  0)) = curr_Xend_integer   and conv_integer(RAM_R_data(24 downto 13)) = conv_integer(curr_Yend(11 downto 0)) ) then       
          Print("DPC GAIA: Corner DP x=" & INTEGER'IMAGE(to_integer(ieee.numeric_std.unsigned(RAM_R_data(12 downto  0)))) & " y=" & INTEGER'IMAGE(to_integer(ieee.numeric_std.unsigned(RAM_R_data(24 downto  13)))) &  " REMOVED from DPC list"  );
          dpc_fifo_write   <= (others=>'0');     
        elsif(  conv_integer(RAM_R_data(24 downto 13)) >= conv_integer(curr_Ystart(11 downto 0)) and 
                conv_integer(RAM_R_data(24 downto 13)) <= conv_integer(curr_Yend(11 downto 0))   and
                conv_integer(RAM_R_data(12 downto  0)) >= curr_Xstart_integer                    and      
                conv_integer(RAM_R_data(12 downto  0)) <= curr_Xend_integer                      and				
				
				(  (DPC_COLOR=0 and ((curr_Ysub = '1' and  RAM_R_data(13) = '0') or curr_Ysub = '0') )  or   -- Mono  Y SUBsampling  (read 1 - skip 1)
				   (DPC_COLOR=1 and ((curr_Ysub = '1' and  RAM_R_data(14) = '0') or curr_Ysub = '0') )       -- Color Y SUBsampling (read 2 - skip 2)
				)
				
             ) then 
          for i in 0 to nb_pixels loop  -- X Loop        
            if(DPC_COLOR=0 and nb_pixels=7 and conv_integer(RAM_R_data(2 downto 0))=i  ) or     -- Mono
			  (DPC_COLOR=0 and nb_pixels=3 and conv_integer(RAM_R_data(1 downto 0))=i  ) or     -- Mono
              (DPC_COLOR=1 and nb_pixels=7 and conv_integer(RAM_R_data(2 downto 0))=i  ) or     -- Color
			  (DPC_COLOR=1 and nb_pixels=3 and conv_integer(RAM_R_data(1 downto 0))=i  ) then   -- COlor  			  
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
      
 
 
   

     

   
   
  
  
  -------------------------------------------
  -- Bypass/Disable dpc with COLOR sensors
  -------------------------------------------
  process(axi_clk)
  begin      
    if (axi_clk'event and axi_clk='1') then
      if(axi_reset_n='0') then
        BAYER_Sensor    <= '0';
      else
        if( REG_color='1') then
          BAYER_Sensor  <= '1';
        else
          BAYER_Sensor  <= '0';                --MONO sensor
        end if;
      end if;
    end if;
  end process;
  
  
  -------------------------------------------------------
  -- dpc Enable DB 
  -------------------------------------------------------
  process(axi_clk)
  begin
    if (axi_clk'event and axi_clk='1') then
      
	  REG_dpc_enable_P1 <= REG_dpc_enable;
      if(load_dma_context_EOFOT='1') then
        REG_dpc_enable_DB     <= REG_dpc_enable and not(BAYER_Sensor);
      end if;
      
    end if;
  end process;



  ---------------------------------------------------------------------------------------
  --
  --  STEP 1
  --
  --  On recois 8/4 pixels par coup d'horloge, dans ce process ce que je fais sur 2 clk
  --  est de generer tous les overscans horizontals pour qu'une fois apres avoir passe 
  --  par les fifos, les 8 engins n'aient pas a se soucier des overscans horizontaux
  --
  ---------------------------------------------------------------------------------------
  process(axi_clk)
  begin
    if (axi_clk'event and axi_clk='1') then
      
      if(s_axis_tvalid='1' and s_axis_tready_int='1' and (s_axis_tuser="0001" or s_axis_tuser="0100")) then --sof+sol
        dpc_sol_P1 <= '1';
      else
        dpc_sol_P1 <= '0';
      end if;        		
		
	  if(s_axis_tvalid='1' and s_axis_tready_int='1' and (s_axis_tuser="1000" or s_axis_tuser="0010") ) then --eof+eol
	    dpc_data_enable_stop <= '1';
	  else
	    dpc_data_enable_stop <= '0';
	  end if;
		
      if(dpc_data_enable_stop='1') then 
        dpc_data_enable_start <= '0';
      elsif(s_axis_tvalid='1' and s_axis_tready_int='1' and (s_axis_tuser="0001" or s_axis_tuser="0100")) then --sof+sol
        dpc_data_enable_start <= '1';
      end if; 
      
      dpc_data_enable_P1 <= ( (s_axis_tvalid and s_axis_tready_int) and dpc_data_enable_start) or dpc_data_enable_stop;

      
	  if(s_axis_tvalid='1' and s_axis_tready_int='1' and (s_axis_tuser="1000" or s_axis_tuser="0010") ) then
        dpc_eol_P1       <= '1';
	  else
        dpc_eol_P1       <= '0';
      end if;		
      dpc_eol_P2         <= dpc_eol_P1;
      dpc_eol_P3         <= dpc_eol_P2;        
		
	  if(s_axis_tvalid='1' and s_axis_tready_int='1' and s_axis_tuser="0010") then
        dpc_eof_P1         <= '1';
      else
        dpc_eof_P1         <= '0';
      end if;		
  	  dpc_eof_P2         <= dpc_eof_P1;
      dpc_eof_P3         <= dpc_eof_P2;        
      dpc_eof_P4         <= dpc_eof_P3;        

      -- data_valid
      if(s_axis_tvalid='1' and s_axis_tready_int='1') then 
        dpc_data_in_100_P1((10*(nb_pixels+1))+9 downto 10) <= s_axis_tdata((10*nb_pixels)+9 downto 0); -- P1[89:10] <= P0[79:0]
      end if;
      
	  if( (s_axis_tvalid='1' and s_axis_tready_int='1') and dpc_data_enable_start='1') or (dpc_data_enable_stop='1') then
        dpc_data_in_100_P2((10*nb_pixels)+9 downto 10) <= dpc_data_in_100_P1((10*nb_pixels)+9 downto 10);  --P2[79:10] <= P1[79:10]
      end if; 
		
      if(s_axis_tvalid='1' and s_axis_tready_int='1' and (s_axis_tuser="0001" or s_axis_tuser="0100")) then  --sol_p1=1
        dpc_data_in_100_P2((10*(nb_pixels+1))+9 downto (10*(nb_pixels+1))) <= s_axis_tdata(9 downto 0); -- P2[89:80] <= P0[9:0] : ON SOL : overscan repeat first pixel of the line : utilise plus tard ds : overscan low
      elsif( (s_axis_tvalid='1' and s_axis_tready_int='1') and dpc_data_enable_start='1') or (dpc_data_enable_stop='1') then
        dpc_data_in_100_P2((10*(nb_pixels+1))+9 downto (10*(nb_pixels+1))) <= dpc_data_in_100_P1((10*(nb_pixels+1))+9 downto (10*(nb_pixels+1))); -- P2[89:80] <= P1[89:80]
      end if;
      
   
      
      --Overscan LOW
      if( (s_axis_tvalid='1' and s_axis_tready_int='1') and dpc_data_enable_start='1') or (dpc_data_enable_stop='1') then
        dpc_data_in_100_P2(9 downto  0) <= dpc_data_in_100_P2((10*(nb_pixels+1))+9 downto (10*(nb_pixels+1)));  -- P2[9:0] <= P2[89:80]
      end if;
      
      --Overscan HI
      if(dpc_data_enable_stop='1') then
        dpc_data_in_100_P2((10*(nb_pixels+2))+9 downto (10*(nb_pixels+2))) <= dpc_data_in_100_P1((10*(nb_pixels+1))+9 downto (10*(nb_pixels+1)));  --99:90<=89:80 : ON EOL : overscan repeat last pixel of the line
      elsif( (s_axis_tvalid='1' and s_axis_tready_int='1') and dpc_data_enable_start='1') then
        dpc_data_in_100_P2((10*(nb_pixels+2))+9 downto (10*(nb_pixels+2))) <= s_axis_tdata(9 downto 0);           --99:90<=9:0
      end if;
      
    end if;
  end process;
  
  dpc_kernel_10x3_sof <= s_axis_tvalid and s_axis_tready_int and s_axis_tuser(0);  
  dpc_kernel_10x3_sol <= dpc_sol_P1 ;
  dpc_kernel_10x3_eol <= dpc_eol_P3 ;
  dpc_kernel_10x3_eof <= dpc_eof_P4 ;
  

  ---------------------------------------------------------------------------------------
  --
  --  STEP 2
  --
  --  Regenerer les Kernels 3x3 et les syncs pret a l'usage
  --
  --  kernel_10x3_out,  --(0) line n,(1) line n+1, (2) line+2 output is :
  --
  --                  OvS                                 OvS
  --  LINEn  (99:0) [ P09 P08 P07 P06 P05 P04 P03 P02 P01 P00 ]
  --  LINEn+1(99:0) [ P19 P18 P17 P16 P15 P14 P13 P12 P11 P10 ]
  --  LINEn+2(99:0) [ P29 P28 P27 P26 P25 P24 P23 P22 P21 P20 ]
  --  
  --------------------------------------------------------------------------------------- 
  Xdpc_kernel_10x3 : dpc_kernel_10x3
    generic map( lvds_ch        => 6)   
    port map(
      ---------------------------------------------------------------------
      -- Pixel domain reset and clock signals
      ---------------------------------------------------------------------
      pix_clk                              => axi_clk,
      pix_reset                            => axi_reset,
  
      ---------------------------------------------------------------------
      -- Overrun registers
      ---------------------------------------------------------------------
      REG_dpc_fifo_rst                     => REG_dpc_fifo_rst,
      REG_dpc_fifo_ovr                     => REG_dpc_fifo_ovr,
      REG_dpc_fifo_und                     => REG_dpc_fifo_und,
          
      ---------------------------------------------------------------------
      -- Data and control in
      ---------------------------------------------------------------------
      start_of_frame_in                    => dpc_kernel_10x3_sof,
      start_of_line_in                     => dpc_kernel_10x3_sol,
      pixel_in_en                          => dpc_data_enable_P1,
      pixel_in                             => dpc_data_in_100_P2(s_axis_tdata'high+20 downto 0),
      end_of_line_in                       => dpc_kernel_10x3_eol,
      end_of_frame_in                      => dpc_kernel_10x3_eof,

      m_axis_tvalid                        => m_axis_tvalid_int,
	  m_axis_tready                        => m_axis_tready,

      ---------------------------------------------------------------------
      -- Data and control out
      ---------------------------------------------------------------------
      first_line_out                       => kernel_10x3_first_line,
      last_line_out                        => kernel_10x3_last_line,
      first_col_out                        => kernel_10x3_first_col,
      last_col_out                         => kernel_10x3_last_col,
      start_of_frame_out                   => kernel_10x3_sof,
      start_of_line_out                    => kernel_10x3_sol,
      neighbor_en                          => kernel_10x3_en,
      neighbor_out                         => kernel_10x3_out,  --(0) line n,(1) line n+1, (2) line+2
      end_of_line_out                      => kernel_10x3_eol,
      end_of_frame_out                     => kernel_10x3_eof
    );

    
  --
  -- generer la position du pixel (kernel) courant
  --
  process(axi_clk)
  begin
    if (axi_clk'event and axi_clk='1') then
        
      --X registers in sensor are pixel based 
      if(kernel_10x3_sof='1' or kernel_10x3_eol='1') then
        kernel_10x3_curr.X_pos(12 downto 0) <= curr_Xstart_corr;                   
      elsif(kernel_10x3_en='1') then
        kernel_10x3_curr.X_pos <= kernel_10x3_curr.X_pos + conv_std_logic_vector(nb_pixels+1,5);   --7+1 ou 3+1 for GTX
      end if;
      
      --Y registers are line based in sensor
      if(kernel_10x3_sof='1') then
        kernel_10x3_curr.Y_pos(11 downto 0) <= curr_Ystart;
      elsif(kernel_10x3_eol='1') then
        if(curr_Ysub='0') then
          kernel_10x3_curr.Y_pos <= kernel_10x3_curr.Y_pos + '1';
        else
          if(DPC_COLOR=0) then
		    kernel_10x3_curr.Y_pos <= kernel_10x3_curr.Y_pos + "10";     -- Mono (skip 1)
          else
		    if(kernel_10x3_curr.Y_pos(0)='0') then                       -- Color
              kernel_10x3_curr.Y_pos <= kernel_10x3_curr.Y_pos + '1';    -- Color (no skip)
            else	                                                     -- Color 
              kernel_10x3_curr.Y_pos <= kernel_10x3_curr.Y_pos + "11";   -- Color (skip 2)
            end if;
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
  proc_first_col(0)                     <= kernel_10x3_first_col;    
  proc_first_col(nb_pixels downto 1)    <= (others=>'0');
  
  proc_last_col(nb_pixels)              <= kernel_10x3_last_col;
  proc_last_col(nb_pixels-1 downto 0)   <= (others=>'0');                 
            
            
  GEN_4_8_CORE: for i in 0 to nb_pixels generate
  
    proc_X_pix_curr(i)       <= kernel_10x3_curr.X_pos(12 downto 2) & conv_std_logic_vector(i,2) when nb_pixels = 3 else 
                                kernel_10x3_curr.X_pos(12 downto 3) & conv_std_logic_vector(i,3);
   
    Xdpc_kernel_proc : dpc_kernel_proc
    generic map( DPC_CORR_PIXELS_DEPTH         => DPC_CORR_PIXELS_DEPTH )	
	port map(
      ---------------------------------------------------------------------
      -- Pixel domain reset and clock signals
      ---------------------------------------------------------------------
      pix_clk                              => axi_clk,
      pix_reset                            => axi_reset,
  
      proc_X_pix_curr                      => proc_X_pix_curr(i),
      proc_Y_pix_curr                      => kernel_10x3_curr.Y_pos,

      REG_dpc_pattern0_cfg                 => REG_dpc_pattern0_cfg,
      REG_dpc_highlight_all                => REG_dpc_highlight_all,

      dpc_fifo_reset                       => dpc_fifo_reset,
      dpc_fifo_data_in                     => dpc_fifo_data,
      dpc_fifo_write_in                    => dpc_fifo_write(i),
      dpc_fifo_list_rdy                    => dpc_fifo_list_rdy,         --write logic has finish write to fifo, we can start prefetch
      dpc_fifo_reset_done                  => dpc_fifo_reset_done(i),

      ---------------------------------------------------------------------
      -- Data IN
      ---------------------------------------------------------------------   
      proc_enable                          => kernel_10x3_en,
      proc_eol                             => kernel_10x3_eol,
      proc_first_col                       => proc_first_col(i), 
      proc_last_col                        => proc_last_col(i),
      proc_first_line                      => kernel_10x3_first_line,  
      proc_last_line                       => kernel_10x3_last_line,      
      ---------
      -- 1 2 3 
      -- 4 5 6 
      -- 7 8 9 
      ---------   
      -- in_1                                 => kernel_10x3_out(0)((10*i)+ 9 downto (10*i)+ 0),
      -- in_2                                 => kernel_10x3_out(0)((10*i)+19 downto (10*i)+10),
      -- in_3                                 => kernel_10x3_out(0)((10*i)+29 downto (10*i)+20),
      --   
      -- in_4                                 => kernel_10x3_out(1)((10*i)+ 9 downto (10*i)+ 0),
      -- in_5                                 => kernel_10x3_out(1)((10*i)+19 downto (10*i)+10),
      -- in_6                                 => kernel_10x3_out(1)((10*i)+29 downto (10*i)+20),
      --   
      -- in_7                                 => kernel_10x3_out(2)((10*i)+ 9 downto (10*i)+ 0),
      -- in_8                                 => kernel_10x3_out(2)((10*i)+19 downto (10*i)+10),
      -- in_9                                 => kernel_10x3_out(2)((10*i)+29 downto (10*i)+20),


      ---------      ---------
      -- 1 2 3       -- 3 2 1 
      -- 4 5 6   =>  -- 4 8 0 
      -- 7 8 9       -- 5 6 7 
      ---------      ---------
      in_0                                 => kernel_10x3_out(1)((10*i)+29 downto (10*i)+20), --6
      in_1                                 => kernel_10x3_out(0)((10*i)+29 downto (10*i)+20), --3
      in_2                                 => kernel_10x3_out(0)((10*i)+19 downto (10*i)+10), --2
      in_3                                 => kernel_10x3_out(0)((10*i)+ 9 downto (10*i)+ 0), --1
      in_4                                 => kernel_10x3_out(1)((10*i)+ 9 downto (10*i)+ 0), --4
      in_5                                 => kernel_10x3_out(2)((10*i)+ 9 downto (10*i)+ 0), --7 
      in_6                                 => kernel_10x3_out(2)((10*i)+19 downto (10*i)+10), --8
      in_7                                 => kernel_10x3_out(2)((10*i)+29 downto (10*i)+20), --9
      --Center (Curr)
      in_8                                 => kernel_10x3_out(1)((10*i)+19 downto (10*i)+10), --5
      
      ------------------------------
      -- SYNC IN
      ------------------------------
      
      -------------------------------------------------
      -- Data OUT
      -------------------------------------------------
      Curr_out                             => proc_data(i)
    );
  end generate;  
    
  ------------------------------------
  -- Pipeline pour les signaux de sync
  ------------------------------------  
  process(axi_clk)
  begin
    if (axi_clk'event and axi_clk='1') then
      kernel_10x3_sol_P1  <= kernel_10x3_sol;
      kernel_10x3_en_P1   <= kernel_10x3_en;
      kernel_10x3_eol_P1  <= kernel_10x3_eol;
      kernel_10x3_eof_P1  <= kernel_10x3_eof;
      
      kernel_10x3_sol_P2  <= kernel_10x3_sol_P1;
      kernel_10x3_en_P2   <= kernel_10x3_en_P1;
      kernel_10x3_eol_P2  <= kernel_10x3_eol_P1;
      kernel_10x3_eof_P2  <= kernel_10x3_eof_P1;
      
      kernel_10x3_sol_P3  <= kernel_10x3_sol_P2;
      kernel_10x3_en_P3   <= kernel_10x3_en_P2;
      kernel_10x3_eol_P3  <= kernel_10x3_eol_P2;
      kernel_10x3_eof_P3  <= kernel_10x3_eof_P2;
      
      kernel_10x3_sol_P4  <= kernel_10x3_sol_P3;
      kernel_10x3_en_P4   <= kernel_10x3_en_P3;
      kernel_10x3_eol_P4  <= kernel_10x3_eol_P3;
      kernel_10x3_eof_P4  <= kernel_10x3_eof_P3;
            
      proc_sol            <= kernel_10x3_sol_P4;
      proc_en             <= kernel_10x3_en_P4;
      proc_eol            <= kernel_10x3_eol_P4;
      proc_eof            <= kernel_10x3_eof_P4;
    end if;
  end process;
  
  

  
--  ---------------------------------------------------------------------------------------
--  -- Selection du data a sortir 
--  ---------------------------------------------------------------------------------------  
  Conditional_muxoutput: for i in 0 to nb_pixels generate
   
    process(axi_clk)
    begin
      if (axi_clk'event and axi_clk='1') then

        Pix_corr(i) <= proc_data(i);

        
        Pix_corr_sof  <= kernel_10x3_sof;
           
        if(kernel_10x3_first_line='1' or kernel_10x3_last_line='1' ) and (REG_dpc_firstlast_line_rem='1') then  -- On enleve la premiere et la derniere ligne de la ROI recu par le module
          Pix_corr_sol  <= '0';
          Pix_corr_en   <= '0';
          Pix_corr_eol  <= '0';
        else
          Pix_corr_sol  <= proc_sol;
          Pix_corr_en   <= proc_en;
          Pix_corr_eol  <= proc_eol;
        end if;
          
        Pix_corr_eof    <= proc_eof; -- prend le eof du pipeline de la correction peu importe si on corrige ou pas.

      end if;
    end process;
  end generate;


 
  
  ----------------------------------------------
  -- STEP 4
  --
  -- AXI MASTER
  --
  ----------------------------------------------   
  
  
  
  
  -- SOF : le protocol Axi-Video demande a mettre un flag SOF actif pour le premier transfert du frame. Ca sort sur le Tuser0
  process(axi_clk)
  begin
    if rising_edge(axi_clk) then
      if axi_reset_n = '0' then
        m_axis_tuser_int(0) <= '0' after 1 ns;
      elsif Pix_corr_sof = '1' then      -- arrive une fois, au debut du frame avant le data
        m_axis_tuser_int(0) <= '1' after 1 ns;
      elsif m_axis_tvalid_int='1' and m_axis_tready='1' then -- le data vient d'etre transfere, donc le pixel suivant on descend le SOF
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
      elsif Pix_corr_sol = '1' and kernel_10x3_first_line='0' then      -- SOL
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
      elsif proc_eol = '1'  and kernel_10x3_last_line='0' then    -- dont put eol in last line of frame, only eof
        m_axis_tuser_int(3) <= '1' after 1 ns;
  	  elsif m_axis_tvalid_int='1' and m_axis_tready='1' then -- le data vient d'etre transfere, donc le pixel suivant on descend le SOF
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
      elsif proc_eol = '1' and kernel_10x3_last_line='1' then      
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
      elsif(Pix_corr_en='1') then
        m_axis_tvalid_int <= '1';
      elsif(m_axis_tvalid_int='1' and m_axis_tready='1') then
	     m_axis_tvalid_int <= Pix_corr_en;
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
          m_axis_tdata_int <= Pix_corr(7) & Pix_corr(6) & Pix_corr(5) & Pix_corr(4) & Pix_corr(3) & Pix_corr(2) & Pix_corr(1) & Pix_corr(0); -- Put new data on the bus
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
      elsif proc_eol = '1' then   
		m_axis_tlast    <= '1' after 1 ns;
  	  elsif m_axis_tvalid_int='1' and m_axis_tready='1' then -- le data vient d'etre transfere, donc le pixel suivant on descend le SOF
		m_axis_tlast    <= '0' after 1 ns;		
      end if;
    end if;
  end process;    


  
  
end functional;

