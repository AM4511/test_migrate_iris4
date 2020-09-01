-----------------------------------------------------------------------
-- File:        lut.vhd
-- Decription:  
--              
-- This module contains: one 10 to 8 bits lut
-- This module receives 8 pixels 10bits, and outs 8 pixels 8 bits from the LUT
--
--
-- Created by:  Javier Mansilla
-- Date:        
-- Project:     IRIS 4
--
--
--                __________        
--               |          |        
--   ----/------>|   Lut    |----/--->
--      8x10bpp  |__________|   8x8bpp
--                
--
-- This module implements one lut-per-channel 
--
--
-------------------------------------------------------------------------------

library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.std_logic_unsigned.all;
  use IEEE.std_logic_arith.conv_std_logic_vector;

library work;
  use work.regfile_xgs_athena_pack.all;

library UNISIM;
  use UNISIM.VCOMPONENTS.all;

entity axi_lut is

   port (  
           axi_clk                                 : in std_logic;
           axi_reset_n                             : in std_logic;
           
           ---------------------------------------------------------------------
           -- AXI in
           ---------------------------------------------------------------------  
           s_axis_tvalid                           : in   std_logic;
           s_axis_tready                           : out  std_logic;
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
           m_axis_tdata                            : out std_logic_vector;
           
           ---------------------------------------------------------------------------
           --  Registers
           ---------------------------------------------------------------------------
           regfile                                 : inout REGFILE_XGS_ATHENA_TYPE := INIT_REGFILE_XGS_ATHENA_TYPE

        );
end axi_lut;

------------------------------------------------------
-- Begin architecture structure
------------------------------------------------------

architecture functional of axi_lut is


-- Components

component Infered_RAM_lut
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





----------------------------------------------
--  Signals
----------------------------------------------

constant C_RAM_WIDTH            : integer := 8;                           -- Specify data width (8 or 10 bits data)
constant C_RAM_DEPTH            : integer := 10;                          -- Specify RAM depth (bits de l'adresse de la ram)

constant Input_Pix_type         : integer := 10;

constant LUT_number             : integer := (s_axis_tdata'high+1)/Input_Pix_type;


signal s_axis_tdata_p1  : std_logic_vector(s_axis_tdata'range);

signal RAM_W_enable     : std_logic:='0';                                               -- Write enable
signal RAM_W_address    : std_logic_vector(C_RAM_DEPTH-1 downto 0);                     -- Write address bus, width determined from RAM_DEPTH
signal RAM_W_data       : std_logic_vector(C_RAM_WIDTH-1 downto 0);                     -- RAM input data


type LUT_ADDxCH_type is array (0 to LUT_number-1) of std_logic_vector(C_RAM_DEPTH-1 downto 0);
type LUT_DATxCH_type is array (0 to LUT_number-1) of std_logic_vector(C_RAM_WIDTH-1 downto 0);

signal RAM_R_enable     : std_logic:='0'; 
signal RAM_R_enable_ored: std_logic;                                              -- Write enable
signal RAM_R_address    : LUT_ADDxCH_type;
signal RAM_R_data       : LUT_DATxCH_type;



type AXI_FSM_TYPE is (S_IDLE, FIRST_PREFETCH, FIRST_TRANSFER, WAIT_SLV_BURST, SLV_BURST, SLV_BURST_END);
signal axi_state : AXI_FSM_TYPE;

signal m_axis_tuser_int  : std_logic_vector(s_axis_tuser'range);



BEGIN





--------------------------------------------------------------------
--
--
--  LUT CORRECTION (10 to 8 LUT)  (1 palette)
--
--
--------------------------------------------------------------------

RAM_W_enable             <= '1' when  (regfile.LUT.LUT_CTRL.LUT_SEL(3)='1' and regfile.LUT.LUT_CTRL.LUT_SS='1' and regfile.LUT.LUT_CTRL.LUT_WRN='1') else '0';
RAM_W_address            <=  regfile.LUT.LUT_CTRL.LUT_ADD;
RAM_W_data               <=  regfile.LUT.LUT_CTRL.LUT_DATA_W; --LUT is only 8 bits! (driver is program MSB bits when LUT 8 bits)
                         
                            
--Readback of LUT not supported to remove logic, see LUT_WRN in condition for the enable.
regfile.LUT.LUT_RB.LUT_RB  <= (others=>'0'); 


----------------------------
-- Generation of LUTS
----------------------------
Gen_ch_output : for ch in 0 to LUT_number-1  generate
begin
  
  RAM_R_address(ch)(9 downto 0)    <= s_axis_tdata( ((Input_Pix_type*(ch+1))-1) downto (Input_Pix_type*ch) );
  
  XLUT_X : Infered_RAM_lut
   generic map (
           C_RAM_WIDTH      => C_RAM_WIDTH,                    -- Specify data width 
           C_RAM_DEPTH      => C_RAM_DEPTH                     -- Specify RAM depth (bits de l'adresse de la ram)
           )
   port map (  
           RAM_W_clk        =>  axi_clk,
           RAM_W_WRn        =>  '1',                           -- Write cycle
           RAM_W_enable     =>  RAM_W_enable,                  -- Write enable
           RAM_W_address    =>  RAM_W_address,                 -- Write address bus, width determined from RAM_DEPTH
           RAM_W_data       =>  RAM_W_data,                    -- RAM input data
           RAM_W_dataR      =>  open,                          -- RAM read data

           RAM_R_clk        =>  axi_clk,
           RAM_R_enable     =>  RAM_R_enable_ored,             -- Read enable
           RAM_R_address    =>  RAM_R_address(ch),             -- Read address bus, width determined from RAM_DEPTH
           RAM_R_data       =>  RAM_R_DATA(ch)                 -- RAM output data
        );

end generate;






---------------------
-- BYPASS
---------------------
--s_axis_tready   <= m_axis_tready;
--m_axis_tvalid   <= s_axis_tvalid; 
--m_axis_tuser    <= s_axis_tuser; 
--m_axis_tlast    <= s_axis_tlast;  
--m_axis_tdata    <= s_axis_tdata(79 downto 72) & s_axis_tdata(69 downto 62) & s_axis_tdata(59 downto 52) & s_axis_tdata(49 downto 42) &
--                   s_axis_tdata(39 downto 32) & s_axis_tdata(29 downto 22) & s_axis_tdata(19 downto 12) & s_axis_tdata(9 downto 2);  
--

RAM_R_enable_ored <= '1' when (RAM_R_enable='1' or (axi_state=SLV_BURST and s_axis_tvalid='1' and RAM_R_enable='0') or (axi_state=WAIT_SLV_BURST and s_axis_tvalid='1') ) else '0';


  process (axi_clk) is
  begin
    if (rising_edge(axi_clk)) then
      if (axi_reset_n = '0') then
        axi_state         <= S_IDLE;
        s_axis_tready     <= '0';		
		m_axis_tuser_int  <= (others=>'0');
		m_axis_tvalid     <= '0';
  		m_axis_tlast      <= '0';			
		RAM_R_enable      <= '0'; 

      else
        case axi_state is

          ---------------------------------------------------------------------
          -- S_IDLE : 
          ---------------------------------------------------------------------
          when S_IDLE =>
            if (s_axis_tvalid = '1') then
              axi_state         <= FIRST_PREFETCH;
              s_axis_tready     <= '1';				
              m_axis_tuser_int  <= s_axis_tuser;  			  
			  m_axis_tvalid     <= '0';
     		  m_axis_tlast      <= '0';						 
			  RAM_R_enable      <= '1'; 
            else
              axi_state         <= S_IDLE;
              s_axis_tready     <= '0';	
			  m_axis_tuser_int  <= (others=>'0');
			  m_axis_tvalid     <= '0';
  		      m_axis_tlast      <= '0';			
			  RAM_R_enable      <= '0'; 

            end if;
 
          ---------------------------------------------------------------------
          -- S_PREFETCH : 
          ---------------------------------------------------------------------
          when FIRST_PREFETCH =>
            axi_state         <= FIRST_TRANSFER;
            s_axis_tready     <= '1';			
			m_axis_tuser_int      <= m_axis_tuser_int;			
  		    m_axis_tvalid     <= '1';
  		    m_axis_tlast      <= '0';			
			RAM_R_enable      <= '0'; 

          ---------------------------------------------------------------------
          -- First S_TRANSFER
          ---------------------------------------------------------------------
          when FIRST_TRANSFER =>
            if (m_axis_tready = '1') then
              axi_state         <= WAIT_SLV_BURST;
              s_axis_tready     <= '1';					  
  			  m_axis_tuser_int  <= (others=>'0');			
   		      m_axis_tvalid     <= '0';
			  m_axis_tlast      <= '0';			  
			  RAM_R_enable      <= '0'; 
            else
              axi_state         <= FIRST_TRANSFER;
              s_axis_tready     <= '1';			
			  m_axis_tuser_int  <= m_axis_tuser_int;			
  		      m_axis_tvalid     <= '1';
			  m_axis_tlast      <= '0';			  
			  RAM_R_enable      <= '0'; 			
            end if;

          ---------------------------------------------------------------------
          -- WAIT BURST SLAVE
          ---------------------------------------------------------------------
          when WAIT_SLV_BURST =>
            if (s_axis_tvalid = '1') then
              axi_state         <= SLV_BURST;
              s_axis_tready     <= '1';	
  			  m_axis_tuser_int  <= (others=>'0');			  
			  m_axis_tvalid     <= '1';  -- la lecture est comb
			  m_axis_tlast      <= '0';			  
			  RAM_R_enable      <= '1'; 
            else
              axi_state         <= WAIT_SLV_BURST;
              s_axis_tready     <= '1';				
  			  m_axis_tuser_int  <= (others=>'0');			  
   		      m_axis_tvalid     <= '0';
			  m_axis_tlast      <= '0';			  
			  RAM_R_enable      <= '0'; 
            end if;

          ---------------------------------------------------------------------
          -- SLV_BURST
          ---------------------------------------------------------------------
          when SLV_BURST =>
            
			if (s_axis_tvalid = '1' and s_axis_tlast='1') then
              axi_state         <= SLV_BURST_END;
              s_axis_tready     <= '0';
  			  m_axis_tuser_int  <= s_axis_tuser;			  
			  m_axis_tvalid     <= '1';
			  m_axis_tlast      <= '1';			  
			  RAM_R_enable      <= '0'; 
            elsif(s_axis_tvalid = '0') then 
			  axi_state         <= SLV_BURST;
              s_axis_tready     <= '1';
  			  m_axis_tuser_int  <= (others=>'0');			  
			  m_axis_tvalid     <= '0';
			  m_axis_tlast      <= '0';			  
			  RAM_R_enable      <= '0'; 					
			else			  
			  axi_state         <= SLV_BURST;
              s_axis_tready     <= '1';
  			  m_axis_tuser_int  <= (others=>'0');			  
			  m_axis_tvalid     <= '1';
			  m_axis_tlast      <= '0';			  
			  RAM_R_enable      <= '1'; 
            end if;
		  
          ---------------------------------------------------------------------
          -- SLV_BURST_END
          ---------------------------------------------------------------------
          when SLV_BURST_END =>           
            axi_state         <= S_IDLE;
            s_axis_tready     <= '0';
            m_axis_tuser_int  <= (others=>'0');
			m_axis_tvalid     <= '0';
			m_axis_tlast      <= '0';			  
			RAM_R_enable      <= '0'; 
	  		    
        end case;
      end if;
    end if;
  end process;



m_axis_tuser    <= m_axis_tuser_int; 

Gen_mux_data : for ch in 0 to LUT_number-1 generate
  m_axis_tdata( (C_RAM_WIDTH*(ch+1))-1 downto C_RAM_WIDTH*ch)     <=  RAM_R_DATA(ch)  when (regfile.LUT.LUT_CTRL.LUT_BYPASS='0') else  s_axis_tdata_p1( (Input_Pix_type*(ch+1)) -1 downto (Input_Pix_type*ch)+2);
end generate;





End functional;





