-----------------------------------------------------------------------
-- $HeadURL: svn://brainstorm/fpga/trunk/Matrox/Imaging/FPGA/Iris3/cores/i2c/design/i2c_if.vhd $
-- $Author: jmansill $
-- $Revision: 18754 $
-- $Date: 2018-06-21 10:14:44 -0400 (Thu, 21 Jun 2018) $
--
-- DESCRIPTION: TOP DU CORE I2C
-- 
-- VHDL Behavioral Description of an Automatic I2C Interface
-- Date : June 6th 2000
-- Author : Nicolas Ouellet
-- Modifie par : Jean-Francois Larin, jmansill
-- Matrox Electronic Systems Ltd.
--
-- TO DO list:
--
-- Currently, every access (clock cycle) is divided in 3 states.  In the first state
-- the clock is low and the data is set.  In the middle state, the clock is high. In the
-- last state the clock is low (so the clock stays low at least 2 times longer than the
-- high state, as the ADV7185 spec specifies...
-- First, we should add clock stretching.  To do that, we have to raise the clock
-- and then wait until the clock has risen (because the target device MAY hold the clock
-- down) and then start counting the high time. If we have 3 state, we can use an input frequency
-- 3 times the nominal data rate. If we add the clock stretching, then we must add 1 clock cycle
-- while the clock is high. 
--
-- The proposition is to overclock and add 3 generics. first generics is the length of the
-- first state (clock low) in clock cycles.  The second is the length of the clock high. The
-- Third is the length of the last state (Clock low).  Then the real total clock low time will
-- be the sum of the first and last state clock time and the nominal frequency (when the target
-- doesn't hold the clock) will be the input frequency divided by (Tlow1+Thigh+Tlow2+1)
-- (+1) is for the time the machine waits to check the clock
--
--
-- jmansill- 8 Novembre 2005 
-- Ajoute le support pour les read 1 byte sans adresse, pour pouvoir supporter les Eprom sur le CCU
-- Le generique NI_ACCESS a ete ajoute.
--
-- jmansill 25 fevrier 2008
-- Rentre le bus register file genere par le fdk.
-- Enleve les instances event_resync
--
-- jmansill 10 mars
-- Enleve l'appel au log2, ca ne marche pas avec une seule interface. Le registre de selection est de 
-- 2 bits ds le registerfile, comme ca on apourrait avoir jusqu'a 4 if. Dans l'Iris on aura juste une. 
-- Nexis2 pourrait avoir besoin de plus, on va donc laisser le feature la. Il consomme pas de logique 
-- en synthese.
-- 
-- jmansill 10 mars 2011
-- Le data envoye par le fpga sort maintenant une demi-periode clock interne apres le falling de smb_clk externe.
-- Avant il sortait une periode apres le falling de smb_clk externe. Le but est de respecter le holdtime sur le data.
-- La facon que ca ete fait a ete de relentir le smb_clk externe d'une demie periode interne.
-- On arrange le setup/hold time du sdata lors du REPEATED START, en allongeant le clock high et le data high de un clk
-- On arrange le setup time Tsu-sto du sdata lors du STOP, en allongeant le data low d'un clk
--
-- jmansill 10 novembre 2014
-- Le bit BUSY de l'interface tombe a '1' au moment precis ou on recoit le snapShot. Pas besoin de faire un delai avant de poller le bit de busy
-- Lorsqu'il y avait une erreur de protocole sur un cycle d'index(ACK non envoye par le slave), le core ne generait pas la condition de 
-- STOP correctement. C'est maintenant corrige.
--
-- jlarin 28 janvier 2016
-- j'ai ajoute le clock stretching. Essentiellement, a chaque fois qu'on monte la clock, on regarde une demi-clock plus tard si elle est montee. 
-- Dans tous les cas normaux, elle devrait etre monte et on continue normalement. Si le slave fait du clock stretching, alors on restera dans l'etat high un coup de clock de plus.
-- Cette lecture du signal clock nous empeche de retarder la clock qu'on envoie a l'exterieur d'une demi-clock interne. J'ai donc du enlever ce delai. 
-- D'ailleur, la spec I2C mentionne un hold de 0 ns. Alors ce delai devait etre une patch project specific?
--
-- jmansill 18 mars 2020
-- Make a AXI component with latest release
--
--
-------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library work;
   use work.regfile_i2c_pack.all;

library UNISIM;
  use UNISIM.VCOMPONENTS.all;


entity axi_i2c is
  generic(
      NI_ACCESS         : boolean := FALSE;
      SIMULATION        : boolean := FALSE;
      CLOCK_STRETCHING  : boolean := FALSE; -- par default, comportement classique.
      G_SYS_CLK_PERIOD  : integer := 16;    -- Sysclock period
	  
	  -- Parameters of Axi Slave Bus Interface S00_AXI
	  C_S_AXI_DATA_WIDTH	: integer	:= 32;
	  C_S_AXI_ADDR_WIDTH	: integer	:= 12
	  
    );
  port(
    -- serial external interface
    ser_clk             : inout std_logic;              -- output clock to i2c clock pin
    ser_data            : inout std_logic;              -- i/o serial data to/from i2c data pin

	-- User ports ends
	-- Do not modify the ports beyond this line

	-- Ports of Axi Slave Bus Interface S00_AXI
	s_axi_aclk	    : in std_logic;
	s_axi_aresetn	: in std_logic;
	s_axi_awaddr	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
	s_axi_awprot	: in std_logic_vector(2 downto 0);
	s_axi_awvalid	: in std_logic;
	s_axi_awready	: out std_logic;
	s_axi_wdata	    : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	s_axi_wstrb	    : in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
	s_axi_wvalid	: in std_logic;
	s_axi_wready	: out std_logic;
	s_axi_bresp	    : out std_logic_vector(1 downto 0);
	s_axi_bvalid	: out std_logic;
	s_axi_bready	: in std_logic;
	s_axi_araddr	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
	s_axi_arprot	: in std_logic_vector(2 downto 0);
	s_axi_arvalid	: in std_logic;
	s_axi_arready	: out std_logic;
	s_axi_rdata	    : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	s_axi_rresp	    : out std_logic_vector(1 downto 0);
	s_axi_rvalid	: out std_logic;
	s_axi_rready	: in std_logic 
	
  );
end axi_i2c;

architecture functionnal of axi_i2c is


  -------------------------------
  -- COMPONENT AxiSlave2Reg 
  -------------------------------
  component AxiSlave2Reg 
	generic (
		-- Width of S_AXI data bus
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		-- Width of S_AXI address bus
		C_S_AXI_ADDR_WIDTH	: integer	:= 12
	);
	port (
		-- Users to add ports here
        ---------------------------------------------------------------------------
        -- FDK IDE registerfile interface
        ---------------------------------------------------------------------------
        reg_read          : out std_logic;
        reg_write         : out std_logic;
        reg_addr          : out std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 2);
        reg_beN           : out std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
        reg_writedata     : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        reg_readdataValid : in  std_logic;
        reg_readdata      : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);

        ---------------------------------------------------------------------------
        -- AXI S MM 
        ---------------------------------------------------------------------------    
        S_AXI_ACLK        : in std_logic;
        S_AXI_ARESETN     : in std_logic;
        S_AXI_AWADDR      : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        --S_AXI_AWPROT      : in std_logic_vector(2 downto 0);
        S_AXI_AWVALID     : in std_logic;
        S_AXI_AWREADY     : out std_logic;
        
        S_AXI_WDATA       : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        S_AXI_WSTRB       : in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
        S_AXI_WVALID      : in std_logic;
        S_AXI_WREADY      : out std_logic;
        
        S_AXI_BRESP       : out std_logic_vector(1 downto 0);
        S_AXI_BVALID      : out std_logic;
        S_AXI_BREADY      : in std_logic;
        
        S_AXI_ARADDR      : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        --S_AXI_ARPROT      : in std_logic_vector(2 downto 0);
        S_AXI_ARVALID     : in std_logic;
        S_AXI_ARREADY     : out std_logic;
        
        S_AXI_RDATA       : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        S_AXI_RRESP       : out std_logic_vector(1 downto 0);
        S_AXI_RVALID      : out std_logic;
        S_AXI_RREADY      : in std_logic
        
	);
  end component;

  
  -------------------------------
  -- COMPONENT regfile_i2c
  -------------------------------
  component regfile_i2c   
   port (
      resetN        : in    std_logic;                                 -- System reset
      sysclk        : in    std_logic;                                 -- System clock
      regfile       : inout REGFILE_I2C_TYPE := INIT_REGFILE_I2C_TYPE; -- Register file
      ------------------------------------------------------------------------------------
      -- Interface name: registerFileIF
      -- Description: 
      ------------------------------------------------------------------------------------
      reg_read      : in    std_logic;                                 -- Read
      reg_write     : in    std_logic;                                 -- Write
      reg_addr      : in    std_logic_vector(11 downto 2);             -- Address
      reg_beN       : in    std_logic_vector(3 downto 0);              -- Byte enable
      reg_writedata : in    std_logic_vector(31 downto 0);             -- Write data
      reg_readdata  : out   std_logic_vector(31 downto 0)              -- Read data
   );

  end component;  
  
  
  component i2c_if 
  generic(
      NB_INTERFACE      : integer;
      NI_ACCESS         : boolean := FALSE;
      C3_SIMULATION     : boolean := FALSE;
      CLOCK_STRETCHING  : boolean := FALSE; -- par default, comportement classique.
      G_SYS_CLK_PERIOD  : integer := 16     -- Sysclock period
    );
  port(
    sys_reset_n         : in std_logic; 
    sys_clk             : in std_logic;         -- System clock (Register domain)

    -- serial external interface
    ser_clk             : inout std_logic_vector(NB_INTERFACE - 1 downto 0);              -- output clock to i2c clock pin
    ser_data            : inout std_logic_vector(NB_INTERFACE - 1 downto 0);              -- i/o serial data to/from i2c data pin

    regfile             : inout REGFILE_I2C_TYPE := INIT_REGFILE_I2C_TYPE -- Register file
  );
  end component;
  
  
  -------------------------------------------
  -- Register file from IP Integrator
  -------------------------------------------
  signal reg_read            :  std_logic;                                                     -- Read
  signal reg_write           :  std_logic;                                                     -- Write
  signal reg_addr            :  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 2);               -- Address
  signal reg_beN             :  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);           -- Byte enable
  signal reg_writedata       :  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);               -- Write data
  signal reg_readdatavalid   :  std_logic;                                                     -- Read data valid
  signal reg_readdata        :  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);               -- Read data
  signal regfile             :  REGFILE_I2C_TYPE; 
     
  signal clk_stretch         : std_logic;
  signal non_index_access    : std_logic;
  
begin

    clk_stretch      <= '1' when (CLOCK_STRETCHING = true) else '0';
    non_index_access <= '1' when (NI_ACCESS = true) else '0';

    regfile.I2C.I2C_ID.CLOCK_STRETCHING  <= clk_stretch;
    regfile.I2C.I2C_ID.NI_ACCESS         <= non_index_access; 


    X_AxiSlave2Reg : AxiSlave2Reg 
	generic map(
		-- Width of S_AXI data bus
		C_S_AXI_DATA_WIDTH	=> C_S_AXI_DATA_WIDTH ,
		-- Width of S_AXI address bus
		C_S_AXI_ADDR_WIDTH	=> C_S_AXI_ADDR_WIDTH
	)
	port map(

        ---------------------------------------------------------------------------
        -- FDK IDE registerfile interface
        ---------------------------------------------------------------------------
        reg_read          => reg_read,         
        reg_write         => reg_write,        
        reg_addr          => reg_addr,         
        reg_beN           => reg_beN,         
        reg_writedata     => reg_writedata,    
        reg_readdataValid => reg_readdataValid,
        reg_readdata      => reg_readdata,     
        
        S_AXI_ACLK        => S_AXI_ACLK,   
        S_AXI_ARESETN     => S_AXI_ARESETN,
        S_AXI_AWADDR      => S_AXI_AWADDR, 
        --S_AXI_AWPROT      => S_AXI_AWPROT, 
        S_AXI_AWVALID     => S_AXI_AWVALID,
        S_AXI_AWREADY     => S_AXI_AWREADY,
                         
        S_AXI_WDATA       => S_AXI_WDATA,  
        S_AXI_WSTRB       => S_AXI_WSTRB,  
        S_AXI_WVALID      => S_AXI_WVALID, 
        S_AXI_WREADY      => S_AXI_WREADY, 
                         
        S_AXI_BRESP       => S_AXI_BRESP,  
        S_AXI_BVALID      => S_AXI_BVALID, 
        S_AXI_BREADY      => S_AXI_BREADY, 
                         
        S_AXI_ARADDR      => S_AXI_ARADDR, 
        --S_AXI_ARPROT      => S_AXI_ARPROT, 
        S_AXI_ARVALID     => S_AXI_ARVALID,
        S_AXI_ARREADY     => S_AXI_ARREADY,
                         
        S_AXI_RDATA       => S_AXI_RDATA,  
        S_AXI_RRESP       => S_AXI_RRESP,  
        S_AXI_RVALID      => S_AXI_RVALID, 
        S_AXI_RREADY      => S_AXI_RREADY 
          
	);


  -------------------------------
  -- COMPONENT regfile_i2c
  -------------------------------
  Xregfile_i2c : regfile_i2c
   port map (
      resetN          =>  S_AXI_ARESETN,   -- System reset
      sysclk          =>  S_AXI_ACLK,       -- System clock
      regfile         =>  regfile,       -- Register file
      ------------------------------------------------------------------------------------
      -- Interface name: registerFileIF
      -- Description: 
      ------------------------------------------------------------------------------------
      reg_read        => reg_read,                   -- Read
      reg_write       => reg_write,                  -- Write
      reg_addr        => reg_addr,                   -- Address
      reg_beN         => reg_beN,                    -- Byte enable
      reg_writedata   => reg_writedata,              -- Write data
      reg_readdata    => reg_readdata                -- Read data
   );

   
  -- Pour dire au module axi quand sampler le data de lecture regbus, le readdata_valid est juste genere par le regfile s'il y a un external
  process(S_AXI_ACLK)
  begin
    if(rising_edge(S_AXI_ACLK)) then
      if(S_AXI_ARESETN='0') then
        reg_readdataValid <= '0';
      else
        reg_readdataValid <= reg_read;
      end if;
    end if;
  end process;


  -------------------------------
  -- COMPONENT i2c core
  -------------------------------  
  Xi2c_if : i2c_if 
  generic map(
      NB_INTERFACE      => 1,
      NI_ACCESS         => NI_ACCESS,
      C3_SIMULATION     => SIMULATION,
      CLOCK_STRETCHING  => CLOCK_STRETCHING,  -- par default, comportement classique.
      G_SYS_CLK_PERIOD  => G_SYS_CLK_PERIOD     -- Sysclock period
    )
  port map(
    sys_reset_n         => S_AXI_ARESETN,   
    sys_clk             => S_AXI_ACLK,        -- System clock (Register domain)

    -- serial external interface
    ser_clk(0)          => ser_clk,           -- output clock to i2c clock pin
    ser_data(0)         => ser_data,          -- i/o serial data to/from i2c data pin

    regfile             => regfile             -- Register file
  );


end functionnal;
